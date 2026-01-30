#!/usr/bin/env python3
"""
Python_extract_object.py
Extract DDL from all user databases and save to a single .sql file.

Requirements:
 - pyodbc (pip install pyodbc)
 - ODBC Driver for SQL Server (e.g. "ODBC Driver 17 for SQL Server")
"""

import pyodbc
from datetime import datetime
import sys
import os

# -------------------------
# Connection settings - EDIT THESE
# -------------------------
SERVER = r'localhost'                 # e.g. "MYSERVER\\INSTANCE" or "localhost"
DRIVER = 'ODBC Driver 17 for SQL Server'  # change if necessary
USE_TRUSTED_CONNECTION = True         # True => Windows Auth; False => SQL Auth
SQL_USERNAME = ''                     # needed if USE_TRUSTED_CONNECTION is False
SQL_PASSWORD = ''                     # needed if USE_TRUSTED_CONNECTION is False

# -------------------------
# Output file
# -------------------------
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
OUTPUT_FILE = f"all_database_ddls_{timestamp}.sql"

# -------------------------
# Big T-SQL script (safe embedded string)
# -------------------------
SQL_BUILD_SCRIPT = """
SET NOCOUNT ON;

-- 1) Create output table
IF OBJECT_ID('tempdb..AllDbObjectDDLs') IS NOT NULL
    DROP TABLE tempdb..AllDbObjectDDLs;

CREATE TABLE tempdb..AllDbObjectDDLs (
    DatabaseName SYSNAME,
    ObjectType   VARCHAR(50),
    SchemaName   SYSNAME,
    ObjectName   SYSNAME,
    DDL          NVARCHAR(MAX)
);

-- 2) Inner extraction script tokenized by @@DB@@ (will be substituted per DB)
DECLARE @InnerScript NVARCHAR(MAX) = N'
SET NOCOUNT ON;

;WITH ColInfo AS (
    SELECT
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        tp.name AS TypeName,
        c.max_length,
        c.precision,
        c.scale,
        c.is_nullable,
        c.is_identity,
        c.column_id,
        ic.seed_value,
        ic.increment_value,
        dc.definition AS DefaultDefinition,
        c.is_computed,
        c.is_sparse,
        c.is_filestream,
        t.object_id
    FROM sys.tables t
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.columns c ON t.object_id = c.object_id
    JOIN sys.types tp ON c.system_type_id = tp.user_type_id AND tp.is_user_defined = 0
    LEFT JOIN sys.identity_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
    LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
    WHERE t.is_ms_shipped = 0
)
, TableCreate AS (
    SELECT
        SchemaName,
        TableName,
        ''CREATE TABLE '' + QUOTENAME(SchemaName) + ''.'' + QUOTENAME(TableName) + CHAR(13)+CHAR(10)+ ''('' + CHAR(13)+CHAR(10) +
        STRING_AGG(
            ''    '' + QUOTENAME(ColumnName) + '' '' +
            CASE 
                WHEN UPPER(TypeName) IN (''NVARCHAR'',''NCHAR'') THEN UPPER(TypeName) + ''('' + CASE WHEN max_length = -1 THEN ''MAX'' ELSE CAST(max_length/2 AS VARCHAR(10)) END + '')''
                WHEN UPPER(TypeName) IN (''VARCHAR'',''CHAR'',''VARBINARY'',''BINARY'') THEN UPPER(TypeName) + ''('' + CASE WHEN max_length = -1 THEN ''MAX'' ELSE CAST(max_length AS VARCHAR(10)) END + '')''
                WHEN UPPER(TypeName) IN (''DECIMAL'',''NUMERIC'') THEN UPPER(TypeName) + ''('' + CAST(precision AS VARCHAR(10)) + '', '' + CAST(scale AS VARCHAR(10)) + '')''
                WHEN UPPER(TypeName) IN (''ROWVERSION'',''TIMESTAMP'') THEN ''ROWVERSION''
                ELSE UPPER(TypeName)
            END +
            CASE WHEN is_identity = 1 
                THEN '' IDENTITY('' + CAST(ISNULL(seed_value,0) AS VARCHAR(20)) + '','' + CAST(ISNULL(increment_value,1) AS VARCHAR(20)) + '')''
                ELSE ''''
            END +
            CASE WHEN is_nullable = 0 THEN '' NOT NULL'' ELSE '' NULL'' END +
            CASE WHEN DefaultDefinition IS NOT NULL THEN 
                 '' DEFAULT '' + 
                 CASE 
                    WHEN LEFT(LTRIM(DefaultDefinition),1) = ''('' AND RIGHT(RTRIM(DefaultDefinition),1) = '')'' 
                         AND CHARINDEX(''('', DefaultDefinition, 2) = 0
                    THEN SUBSTRING(DefaultDefinition,2,LEN(DefaultDefinition)-2)
                    ELSE DefaultDefinition
                 END
                ELSE '''' END
        , '','' + CHAR(13)+CHAR(10)) WITHIN GROUP (ORDER BY column_id)
        + CHAR(13)+CHAR(10) + '');'' AS DDL
    FROM ColInfo
    WHERE is_computed = 0
    GROUP BY SchemaName, TableName
)

-- PK/Unique
, KeyConstraints AS (
    SELECT sch.name AS SchemaName, t.name AS TableName, kc.name AS ConstraintName,
           kc.type_desc AS ConstraintType, kc.unique_index_id
    FROM sys.key_constraints kc
    JOIN sys.tables t ON kc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
    WHERE t.is_ms_shipped = 0
)
, KeyCols AS (
    SELECT kc.name AS ConstraintName, sch.name AS SchemaName, t.name AS TableName,
           ic.key_ordinal, COL_NAME(ic.object_id, ic.column_id) AS ColumnName
    FROM sys.key_constraints kc
    JOIN sys.tables t ON kc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
    JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
)
, KeyDDL AS (
    SELECT kc.SchemaName, kc.TableName, kc.ConstraintName, kc.ConstraintType,
           ''ALTER TABLE '' + QUOTENAME(kc.SchemaName) + ''.'' + QUOTENAME(kc.TableName) +
           '' ADD CONSTRAINT '' + QUOTENAME(kc.ConstraintName) + 
           CASE WHEN kc.ConstraintType = ''PRIMARY_KEY_CONSTRAINT''
                THEN '' PRIMARY KEY ''
                ELSE '' UNIQUE ''
           END +
           ''('' + STRING_AGG(QUOTENAME(kc2.ColumnName), '', '') WITHIN GROUP (ORDER BY kc2.key_ordinal) + '')'' AS DDL
    FROM KeyConstraints kc
    JOIN KeyCols kc2 ON kc.ConstraintName = kc2.ConstraintName
    GROUP BY kc.SchemaName, kc.TableName, kc.ConstraintName, kc.ConstraintType
)

-- FKs
, FKCols AS (
    SELECT fk.name AS FKName, sch.name AS SchemaName, parent.name AS TableName,
           parent_col.name AS ParentCol, referenced_schema.name AS RefSchema,
           referenced_table.name AS RefTable, referenced_col.name AS RefCol,
           fkc.constraint_column_id
    FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    JOIN sys.tables parent ON fkc.parent_object_id = parent.object_id
    JOIN sys.schemas sch ON parent.schema_id = sch.schema_id
    JOIN sys.tables referenced_table ON fkc.referenced_object_id = referenced_table.object_id
    JOIN sys.schemas referenced_schema ON referenced_table.schema_id = referenced_schema.schema_id
    JOIN sys.columns parent_col ON fkc.parent_object_id = parent_col.object_id AND fkc.parent_column_id = parent_col.column_id
    JOIN sys.columns referenced_col ON fkc.referenced_object_id = referenced_col.object_id AND fkc.referenced_column_id = referenced_col.column_id
)
, FKDDL AS (
    SELECT SchemaName, TableName, FKName,
           ''ALTER TABLE '' + QUOTENAME(SchemaName) + ''.'' + QUOTENAME(TableName) +
           '' ADD CONSTRAINT '' + QUOTENAME(FKName) + '' FOREIGN KEY ('' +
           STRING_AGG(QUOTENAME(ParentCol), '', '') WITHIN GROUP (ORDER BY constraint_column_id) + '')'' +
           '' REFERENCES '' + QUOTENAME(RefSchema) + ''.'' + QUOTENAME(RefTable) + ''('' +
           STRING_AGG(QUOTENAME(RefCol), '', '') WITHIN GROUP (ORDER BY constraint_column_id) + '')'' AS DDL
    FROM FKCols
    GROUP BY SchemaName, TableName, FKName, RefSchema, RefTable
)

-- Check
, CheckDDL AS (
    SELECT sch.name AS SchemaName, t.name AS TableName, cc.name AS ConstraintName,
           ''ALTER TABLE '' + QUOTENAME(sch.name) + ''.'' + QUOTENAME(t.name) +
           '' ADD CONSTRAINT '' + QUOTENAME(cc.name) + '' CHECK '' + cc.definition AS DDL
    FROM sys.check_constraints cc
    JOIN sys.tables t ON cc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
)

-- Indexes
, IndexCols AS (
    SELECT s.name AS SchemaName, t.name AS TableName, i.name AS IndexName,
           i.index_id, i.is_unique, i.type_desc, ic.key_ordinal, ic.index_column_id,
           COL_NAME(ic.object_id, ic.column_id) AS ColumnName,
           ic.is_included_column
    FROM sys.indexes i
    JOIN sys.tables t ON t.object_id = i.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    WHERE i.is_primary_key = 0 AND i.is_hypothetical = 0
)
, IndexKeyCols AS (
    SELECT SchemaName, TableName, IndexName, index_id, is_unique, type_desc,
           STRING_AGG(QUOTENAME(ColumnName), '', '') WITHIN GROUP (ORDER BY key_ordinal, index_column_id) AS KeyColumns
    FROM IndexCols
    WHERE is_included_column = 0
    GROUP BY SchemaName, TableName, IndexName, index_id, is_unique, type_desc
)
, IndexIncludedCols AS (
    SELECT SchemaName, TableName, IndexName,
           STRING_AGG(QUOTENAME(ColumnName), '', '') WITHIN GROUP (ORDER BY index_column_id) AS IncludedColumns
    FROM IndexCols
    WHERE is_included_column = 1
    GROUP BY SchemaName, TableName, IndexName
)
, IndexDDL AS (
    SELECT 
        k.SchemaName,
        k.TableName,
        k.IndexName,
        ''CREATE '' +
        CASE WHEN k.is_unique = 1 THEN ''UNIQUE '' ELSE '''' END +
        CASE WHEN k.type_desc LIKE ''CLUSTERED'' THEN ''CLUSTERED '' ELSE ''NONCLUSTERED '' END +
        ''INDEX '' + QUOTENAME(k.IndexName) +
        '' ON '' + QUOTENAME(k.SchemaName) + ''.'' + QUOTENAME(k.TableName) + '' ('' + k.KeyColumns + '')'' +
        CASE WHEN i.IncludedColumns IS NOT NULL 
             THEN '' INCLUDE ('' + i.IncludedColumns + '')'' 
             ELSE '''' END AS DDL
    FROM IndexKeyCols k
    LEFT JOIN IndexIncludedCols i ON 
        i.SchemaName = k.SchemaName AND i.TableName = k.TableName AND i.IndexName = k.IndexName
)

-- Modules
, ModuleDefs AS (
    SELECT 
        o.type_desc,
        sch.name AS SchemaName,
        o.name AS ObjectName,
        ISNULL(m.definition, ''/* encrypted or not available */'') AS definition
    FROM sys.objects o
    JOIN sys.schemas sch ON o.schema_id = sch.schema_id
    LEFT JOIN sys.sql_modules m ON o.object_id = m.object_id
    WHERE o.type IN (''V'',''P'',''FN'',''TF'',''IF'',''TR'')
      AND o.is_ms_shipped = 0
)

SELECT
    ''@@DB@@'' AS DatabaseName,
    ObjectType,
    SchemaName,
    ObjectName,
    DDL
FROM (
    SELECT ''TABLE'' AS ObjectType, SchemaName, TableName AS ObjectName, DDL FROM TableCreate
    UNION ALL SELECT ''PK_UNIQUE'', SchemaName, TableName, DDL FROM KeyDDL
    UNION ALL SELECT ''FOREIGN_KEY'', SchemaName, TableName, DDL FROM FKDDL
    UNION ALL SELECT ''CHECK'', SchemaName, TableName, DDL FROM CheckDDL
    UNION ALL SELECT ''INDEX'', SchemaName, TableName, DDL FROM IndexDDL
    UNION ALL SELECT
        CASE 
            WHEN type_desc LIKE ''%VIEW%'' THEN ''VIEW''
            WHEN type_desc LIKE ''%PROCEDURE%'' THEN ''PROCEDURE''
            WHEN type_desc LIKE ''%FUNCTION%'' THEN ''FUNCTION''
            WHEN type_desc LIKE ''%TRIGGER%'' THEN ''TRIGGER''
            ELSE ''MODULE''
        END AS ObjectType,
        SchemaName,
        ObjectName,
        definition AS DDL
    FROM ModuleDefs
) A;
';

-- 3) Loop all DBs and execute per-DB insertion
DECLARE @DB SYSNAME, @SQL NVARCHAR(MAX);

DECLARE dbs CURSOR FOR
SELECT name FROM sys.databases
WHERE database_id > 4 AND state = 0;  -- user DBs and online

OPEN dbs;
FETCH NEXT FROM dbs INTO @DB;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Processing DB: ' + @DB;

    SET @SQL = REPLACE(@InnerScript, '@@DB@@', @DB);
    SET @SQL = 'USE [' + @DB + ']; ' + @SQL;

    INSERT INTO tempdb..AllDbObjectDDLs (DatabaseName, ObjectType, SchemaName, ObjectName, DDL)
    EXEC(@SQL);

    FETCH NEXT FROM dbs INTO @DB;
END

CLOSE dbs;
DEALLOCATE dbs;

-- 4) done
"""

# -------------------------
# SQL to extract results after build
# -------------------------
SQL_EXTRACT = """
SELECT DatabaseName, ObjectType, SchemaName, ObjectName, DDL
FROM tempdb..AllDbObjectDDLs
ORDER BY DatabaseName, SchemaName, ObjectType, ObjectName;
"""

# -------------------------
# Helper: create connection string
# -------------------------
def get_connection_string():
    if USE_TRUSTED_CONNECTION:
        return f"DRIVER={{{DRIVER}}};SERVER={SERVER};Trusted_Connection=yes;"
    else:
        return f"DRIVER={{{DRIVER}}};SERVER={SERVER};UID={SQL_USERNAME};PWD={SQL_PASSWORD};"

# -------------------------
# Main
# -------------------------
def main():
    print("Connecting to SQL Server:", SERVER)
    conn_str = get_connection_string()
    try:
        conn = pyodbc.connect(conn_str, autocommit=False)
    except Exception as e:
        print("Error connecting to SQL Server:", e)
        sys.exit(1)

    cur = conn.cursor()
    try:
        print("Executing T-SQL to collect DDLs (this can take time)...")
        # Execute the big build script
        cur.execute(SQL_BUILD_SCRIPT)
        conn.commit()
        print("DDL collection script executed and committed.")

        print("Fetching collected DDLs...")
        cur.execute(SQL_EXTRACT)
        rows = cur.fetchall()
        print(f"Total objects extracted: {len(rows)}")

        print("Writing output file:", OUTPUT_FILE)
        with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
            for row in rows:
                db, objtype, schema, name, ddl = row
                f.write(f"-- Database: {db}\n")
                f.write(f"-- Schema:   {schema}\n")
                f.write(f"-- Object:   {objtype} {name}\n")
                if ddl is None:
                    f.write("-- (definition not available)\n\n\n")
                else:
                    f.write(f"{ddl}\n\n\n")

        print("Output file written successfully.")
    except Exception as e:
        print("ERROR during execution:", e)
        try:
            conn.rollback()
            print("Transaction rolled back.")
        except Exception:
            pass
    finally:
        try:
            cur.close()
            conn.close()
        except Exception:
            pass

if __name__ == "__main__":
    main()
