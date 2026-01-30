#!/usr/bin/env python3
"""
extract_ddls_per_db_nozip.py
Extract DDLs per database to CSV files (one CSV per DB). No zipping.

Requirements:
 - pyodbc (pip install pyodbc)
"""

import pyodbc
import csv
import os
import logging
import time
from datetime import datetime

# -------------------------
# Connection settings - EDIT THESE
# -------------------------
SERVER = '10.253.33.160'                       # e.g. "MYSERVER\\INSTANCE"
DRIVER = 'ODBC Driver 17 for SQL Server'    # change if necessary
USE_TRUSTED_CONNECTION = False               # True => Windows Auth; False => SQL Auth
SQL_USERNAME = 'Sqlradar'                           # if not trusted
SQL_PASSWORD = 'XPu2~HTVx>eG6Z'                           # if not trusted

# Optional: restrict databases by name pattern (None or list). Example: ['MyDb1','MyDb2']
DATABASE_ALLOWLIST = None  # e.g. ['MyDb1','MyDb2'] or None to process all user DBs

# -------------------------
# Output settings
# -------------------------
BASE_OUTPUT_DIR = os.path.join(os.getcwd(), "ddl_exports")
TIMESTAMP = datetime.now().strftime("%Y%m%d_%H%M%S")
OUTPUT_SUBDIR = os.path.join(BASE_OUTPUT_DIR, f"ddls_{TIMESTAMP}")
LOG_FILE = os.path.join(OUTPUT_SUBDIR, f"extract_log_{TIMESTAMP}.log")

# -------------------------
# Logging
# -------------------------
os.makedirs(OUTPUT_SUBDIR, exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler(LOG_FILE, encoding="utf-8")
    ]
)
logger = logging.getLogger("ddl-extract")

# -------------------------
# Query to list user DBs (server-level connection)
# -------------------------
DB_LIST_QUERY = """
SELECT name FROM sys.databases
WHERE database_id > 4 -- skip system DBs
  AND state = 0       -- online
ORDER BY name;
"""

# -------------------------
# Per-database DDL extraction SQL
# (runs inside the target database; DB_NAME() included)
# -------------------------
SQL_PER_DB = r"""
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
        'CREATE TABLE ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + CHAR(13)+CHAR(10)+ '(' + CHAR(13)+CHAR(10) +
        STRING_AGG(
            '    ' + QUOTENAME(ColumnName) + ' ' +
            CASE 
                WHEN UPPER(TypeName) IN ('NVARCHAR','NCHAR') THEN UPPER(TypeName) + '(' + CASE WHEN max_length = -1 THEN 'MAX' ELSE CAST(max_length/2 AS VARCHAR(10)) END + ')'
                WHEN UPPER(TypeName) IN ('VARCHAR','CHAR','VARBINARY','BINARY') THEN UPPER(TypeName) + '(' + CASE WHEN max_length = -1 THEN 'MAX' ELSE CAST(max_length AS VARCHAR(10)) END + ')'
                WHEN UPPER(TypeName) IN ('DECIMAL','NUMERIC') THEN UPPER(TypeName) + '(' + CAST(precision AS VARCHAR(10)) + ', ' + CAST(scale AS VARCHAR(10)) + ')'
                WHEN UPPER(TypeName) IN ('ROWVERSION','TIMESTAMP') THEN 'ROWVERSION'
                ELSE UPPER(TypeName)
            END +
            CASE WHEN is_identity = 1 
                 THEN ' IDENTITY(' + CAST(ISNULL(seed_value,0) AS VARCHAR(20)) + ',' + CAST(ISNULL(increment_value,1) AS VARCHAR(20)) + ')'
                 ELSE ''
            END +
            CASE WHEN is_nullable = 0 THEN ' NOT NULL' ELSE ' NULL' END +
            CASE WHEN DefaultDefinition IS NOT NULL 
                 THEN ' DEFAULT ' + 
                      CASE 
                        WHEN LEFT(LTRIM(DefaultDefinition),1) = '(' AND RIGHT(RTRIM(DefaultDefinition),1) = ')' 
                             AND CHARINDEX('(', DefaultDefinition, 2) = 0
                        THEN SUBSTRING(DefaultDefinition,2,LEN(DefaultDefinition)-2)
                        ELSE DefaultDefinition
                      END
                 ELSE '' END
        , ',' + CHAR(13)+CHAR(10)) WITHIN GROUP (ORDER BY column_id)
        + CHAR(13)+CHAR(10) + ');' AS DDL
    FROM ColInfo
    WHERE is_computed = 0
    GROUP BY SchemaName, TableName
)

-- PK / UNIQUE constraints
, KeyConstraints AS (
    SELECT 
        sch.name AS SchemaName,
        t.name  AS TableName,
        kc.name AS ConstraintName,
        kc.type_desc AS ConstraintType,
        kc.parent_object_id,
        kc.unique_index_id
    FROM sys.key_constraints kc
    JOIN sys.tables t ON kc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
    WHERE t.is_ms_shipped = 0
)
, KeyCols AS (
    SELECT 
        kc.name AS ConstraintName,
        sch.name AS SchemaName,
        t.name AS TableName,
        ic.key_ordinal,
        COL_NAME(ic.object_id, ic.column_id) AS ColumnName
    FROM sys.key_constraints kc
    JOIN sys.tables t ON kc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
    JOIN sys.index_columns ic ON ic.object_id = kc.parent_object_id AND ic.index_id = kc.unique_index_id
)
, KeyDDL AS (
    SELECT
        kc.SchemaName,
        kc.TableName,
        kc.ConstraintName,
        kc.ConstraintType,
        'ALTER TABLE ' + QUOTENAME(kc.SchemaName) + '.' + QUOTENAME(kc.TableName) + 
            ' ADD CONSTRAINT ' + QUOTENAME(kc.ConstraintName) + ' ' +
            CASE WHEN kc.ConstraintType = 'PRIMARY_KEY_CONSTRAINT' THEN 'PRIMARY KEY' ELSE 'UNIQUE' END +
            ' (' + STRING_AGG(QUOTENAME(kc2.ColumnName), ', ') WITHIN GROUP (ORDER BY kc2.key_ordinal) + ')' AS DDL
    FROM KeyConstraints kc
    JOIN KeyCols kc2 ON kc2.ConstraintName = kc.ConstraintName AND kc2.SchemaName = kc.SchemaName AND kc2.TableName = kc.TableName
    GROUP BY kc.SchemaName, kc.TableName, kc.ConstraintName, kc.ConstraintType
)

-- Foreign keys
, FKCols AS (
    SELECT
        fk.object_id AS FK_ObjectId,
        sch.name AS SchemaName,
        parent.name AS TableName,
        fk.name AS FKName,
        referenced_schema.name AS RefSchema,
        referenced_table.name AS RefTable,
        parent_col.name AS ParentCol,
        referenced_col.name AS RefCol,
        fkc.constraint_column_id
    FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    JOIN sys.tables parent ON fkc.parent_object_id = parent.object_id
    JOIN sys.schemas sch ON parent.schema_id = sch.schema_id
    JOIN sys.tables referenced_table ON fkc.referenced_object_id = referenced_table.object_id
    JOIN sys.schemas referenced_schema ON referenced_table.schema_id = referenced_schema.schema_id
    JOIN sys.columns parent_col ON fkc.parent_object_id = parent_col.object_id AND fkc.parent_column_id = parent_col.column_id
    JOIN sys.columns referenced_col ON fkc.referenced_object_id = referenced_col.object_id AND fkc.referenced_column_id = referenced_col.column_id
    WHERE parent.is_ms_shipped = 0
)
, FKDDL AS (
    SELECT
        SchemaName,
        TableName,
        FKName,
        'ALTER TABLE ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + 
        ' ADD CONSTRAINT ' + QUOTENAME(FKName) + ' FOREIGN KEY (' +
        STRING_AGG(QUOTENAME(ParentCol), ', ') WITHIN GROUP (ORDER BY constraint_column_id) + ')' +
        ' REFERENCES ' + QUOTENAME(RefSchema) + '.' + QUOTENAME(RefTable) + ' (' +
        STRING_AGG(QUOTENAME(RefCol), ', ') WITHIN GROUP (ORDER BY constraint_column_id) + ')' AS DDL
    FROM FKCols
    GROUP BY SchemaName, TableName, FKName, RefSchema, RefTable
)

-- Check constraints
, CheckDDL AS (
    SELECT
        sch.name AS SchemaName,
        t.name AS TableName,
        cc.name AS ConstraintName,
        'ALTER TABLE ' + QUOTENAME(sch.name) + '.' + QUOTENAME(t.name) + 
            ' ADD CONSTRAINT ' + QUOTENAME(cc.name) + ' CHECK ' + cc.definition AS DDL
    FROM sys.check_constraints cc
    JOIN sys.tables t ON cc.parent_object_id = t.object_id
    JOIN sys.schemas sch ON t.schema_id = sch.schema_id
    WHERE t.is_ms_shipped = 0
)

-- Indexes (skip primary keys)
, IndexCols AS (
    SELECT
        s.name AS SchemaName,
        t.name AS TableName,
        i.name AS IndexName,
        i.index_id,
        i.is_unique,
        i.type_desc,
        ic.key_ordinal,
        ic.index_column_id,
        COL_NAME(ic.object_id, ic.column_id) AS ColumnName,
        CASE WHEN ic.is_included_column = 1 THEN 1 ELSE 0 END AS IsIncluded
    FROM sys.indexes i
    JOIN sys.tables t ON i.object_id = t.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    WHERE i.is_hypothetical = 0
      AND t.is_ms_shipped = 0
      AND i.is_primary_key = 0
)
, IndexKeyCols AS (
    SELECT
        SchemaName,
        TableName,
        IndexName,
        index_id,
        is_unique,
        type_desc,
        STRING_AGG(QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY key_ordinal, index_column_id) AS KeyColumns
    FROM IndexCols
    WHERE IsIncluded = 0
    GROUP BY SchemaName, TableName, IndexName, index_id, is_unique, type_desc
)
, IndexIncludedCols AS (
    SELECT
        SchemaName,
        TableName,
        IndexName,
        STRING_AGG(QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY index_column_id) AS IncludedColumns
    FROM IndexCols
    WHERE IsIncluded = 1
    GROUP BY SchemaName, TableName, IndexName
)
, IndexDDL AS (
    SELECT
        k.SchemaName,
        k.TableName,
        k.IndexName,
        'CREATE ' +
            CASE WHEN k.is_unique = 1 THEN 'UNIQUE ' ELSE '' END +
            CASE WHEN k.type_desc LIKE '%CLUSTERED%' THEN 'CLUSTERED ' ELSE 'NONCLUSTERED ' END +
            'INDEX ' + QUOTENAME(k.IndexName) +
            ' ON ' + QUOTENAME(k.SchemaName) + '.' + QUOTENAME(k.TableName) + ' (' + k.KeyColumns + ')' +
            CASE WHEN ic.IncludedColumns IS NOT NULL THEN ' INCLUDE (' + ic.IncludedColumns + ')' ELSE '' END
            AS DDL
    FROM IndexKeyCols k
    LEFT JOIN IndexIncludedCols ic
        ON ic.SchemaName = k.SchemaName AND ic.TableName = k.TableName AND ic.IndexName = k.IndexName
)

-- Views / Procs / Functions / Triggers
, ModuleDefs AS (
    SELECT 
        o.type_desc,
        sch.name AS SchemaName,
        o.name AS ObjectName,
        ISNULL(m.definition, '/* encrypted or not available */') AS definition,
        o.object_id
    FROM sys.objects o
    JOIN sys.schemas sch ON o.schema_id = sch.schema_id
    LEFT JOIN sys.sql_modules m ON o.object_id = m.object_id
    WHERE o.type IN ('V','P','FN','TF','IF','TR')
      AND o.is_ms_shipped = 0
)
, ModuleDDL AS (
    SELECT
        type_desc,
        SchemaName,
        ObjectName,
        definition AS DDL
    FROM ModuleDefs
)

-- Final output
SELECT DB_NAME() AS DatabaseName, ObjectType, SchemaName, ObjectName, DDL
FROM (
    SELECT 'TABLE' AS ObjectType, SchemaName, TableName AS ObjectName, DDL FROM TableCreate
    UNION ALL
    SELECT 'PK_UNIQUE', SchemaName, TableName, DDL FROM KeyDDL
    UNION ALL
    SELECT 'FOREIGN_KEY', SchemaName, TableName, DDL FROM FKDDL
    UNION ALL
    SELECT 'CHECK', SchemaName, TableName, DDL FROM CheckDDL
    UNION ALL
    SELECT 'INDEX', SchemaName, TableName, DDL FROM IndexDDL
    UNION ALL
    SELECT
        CASE 
            WHEN type_desc LIKE '%VIEW%' THEN 'VIEW'
            WHEN type_desc LIKE '%PROCEDURE%' THEN 'PROCEDURE'
            WHEN type_desc LIKE '%FUNCTION%' THEN 'FUNCTION'
            WHEN type_desc LIKE '%TRIGGER%' THEN 'TRIGGER'
            ELSE 'MODULE'
        END AS ObjectType,
        SchemaName,
        ObjectName,
        DDL
    FROM ModuleDDL
) A
ORDER BY DatabaseName, SchemaName, ObjectType, ObjectName;
"""

# -------------------------
# Helper: connection string generator
# -------------------------
def get_conn_str(dbname=None):
    if USE_TRUSTED_CONNECTION:
        if dbname:
            return f"DRIVER={{{DRIVER}}};SERVER={SERVER};DATABASE={dbname};Trusted_Connection=yes;"
        else:
            return f"DRIVER={{{DRIVER}}};SERVER={SERVER};Trusted_Connection=yes;"
    else:
        if dbname:
            return f"DRIVER={{{DRIVER}}};SERVER={SERVER};DATABASE={dbname};UID={SQL_USERNAME};PWD={SQL_PASSWORD};"
        else:
            return f"DRIVER={{{DRIVER}}};SERVER={SERVER};UID={SQL_USERNAME};PWD={SQL_PASSWORD};"

# -------------------------
# Main flow
# -------------------------
def main():
    start_time = time.time()
    logger.info("Starting DDL extraction run")

    # Ensure output dir exists
    os.makedirs(OUTPUT_SUBDIR, exist_ok=True)

    # 1) Connect to server to list DBs
    try:
        logger.info("Connecting to server to enumerate databases: %s", SERVER)
        with pyodbc.connect(get_conn_str(), timeout=10) as srv_conn:
            srv_cur = srv_conn.cursor()
            srv_cur.execute(DB_LIST_QUERY)
            db_rows = [r[0] for r in srv_cur.fetchall()]
    except Exception as e:
        logger.exception("Failed to list databases: %s", e)
        return

    # Apply allowlist filter if provided
    if DATABASE_ALLOWLIST:
        db_rows = [d for d in db_rows if d in DATABASE_ALLOWLIST]

    logger.info("Databases to process: %s", ", ".join(db_rows) if db_rows else "<none>")

    processed = 0
    failures = []

    # 2) For each DB, connect and run SQL_PER_DB, stream results to CSV
    for db in db_rows:
        logger.info("-----")
        logger.info("Processing database: %s", db)
        db_start = time.time()
        safe_db_name = db.replace(" ", "_").replace(":", "_").replace("\\", "_")
        csv_filename = os.path.join(OUTPUT_SUBDIR, f"{safe_db_name}_ddls_{TIMESTAMP}.csv")
        try:
            # Connect directly into the database (avoids USE)
            with pyodbc.connect(get_conn_str(dbname=db), autocommit=True) as conn:
                cur = conn.cursor()
                logger.info("Executing extraction query on database: %s", db)
                cur.execute(SQL_PER_DB)

                # Prepare CSV writer
                with open(csv_filename, mode="w", newline="", encoding="utf-8") as csvfile:
                    writer = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
                    # header
                    writer.writerow(["DatabaseName", "ObjectType", "SchemaName", "ObjectName", "DDL"])

                    row_count = 0
                    # fetch many to stream
                    while True:
                        rows = cur.fetchmany(200)  # adjust batch size if desired
                        if not rows:
                            break
                        for r in rows:
                            # r is a pyodbc.Row: (DatabaseName, ObjectType, SchemaName, ObjectName, DDL)
                            dbname, objtype, schema, objname, ddl = r
                            if ddl is None:
                                ddl = ""
                            writer.writerow([dbname, objtype, schema, objname, ddl])
                            row_count += 1

                        # progress logging every N rows
                        if row_count % 1000 == 0:
                            logger.info("  %s: written %d rows so far...", db, row_count)

                elapsed = time.time() - db_start
                logger.info("Completed %s: %d rows written to %s (%.1f sec)", db, row_count, csv_filename, elapsed)
                processed += 1

        except Exception as e:
            logger.exception("Error processing database %s: %s", db, e)
            failures.append((db, str(e)))
            # write an empty CSV indicating the error
            try:
                with open(csv_filename, "w", encoding="utf-8", newline="") as f:
                    writer = csv.writer(f, quoting=csv.QUOTE_ALL)
                    writer.writerow(["DatabaseName", "ObjectType", "SchemaName", "ObjectName", "DDL"])
                    writer.writerow([db, "ERROR", "", "", str(e)])
                logger.info("Wrote error marker CSV for %s: %s", db, csv_filename)
            except Exception as e2:
                logger.exception("Failed to write error CSV for %s: %s", db, e2)

    # 3) Summary (no zip)
    total_elapsed = time.time() - start_time
    logger.info("Run complete. Databases processed: %d, failures: %d, elapsed: %.1f sec",
                processed, len(failures), total_elapsed)
    if failures:
        logger.warning("Failures: %s", failures)

    logger.info("Output directory: %s", OUTPUT_SUBDIR)
    logger.info("Log file: %s", LOG_FILE)


if __name__ == "__main__":
    main()
