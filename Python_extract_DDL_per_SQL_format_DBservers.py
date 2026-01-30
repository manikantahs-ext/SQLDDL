#!/usr/bin/env python3
"""
Python_extract_DDL_per_SQL_format_DBservers.py

Multi-server DDL extraction (SQL output version, README summary per server):
 - Reads servers from SERVERS_FILE_PATH
 - Uses embedded SQL credentials
 - Runs a large SQL_PER_DB T-SQL batch inside each user database
 - Writes one .sql per database in per-server output folders (concatenated DDL with comments)
 - No per-server .log files are created any more.
 - Creates a README.txt in each server folder summarizing objects extracted by type and timings.
 - Central multi_server_*.log files are written to a separate folder outside the ddl_exports directory.

NOTE: This script contains plaintext credentials. Store and run securely.
"""

import pyodbc
import os
import logging
import time
from datetime import datetime
import concurrent.futures
import sys
import traceback
from collections import defaultdict

# -------------------------
# EMBEDDED SQL AUTH CREDENTIALS (as requested)
# -------------------------
EMBEDDED_USERNAME = "SqlRadar"
EMBEDDED_PASSWORD = "XPu2~HTVx>eG6Z"

# -------------------------
# SERVERS file location (edit if needed)
# -------------------------
SERVERS_FILE_PATH = r"C:\Manikanta\servers.txt"

# -------------------------
# Defaults / config
# -------------------------
DEFAULT_DRIVER = 'ODBC Driver 17 for SQL Server'
BASE_OUTPUT_DIR = os.path.join(os.getcwd(), "ddl_exports")
CENTRAL_LOG_DIR = os.path.join(os.getcwd(), "central_logs")   # central logs (outside ddl_exports)
DEFAULT_WORKERS = 1        # change to >1 if you want parallel servers
FETCH_BATCH = 200          # rows per fetchmany
LOG_LEVEL = logging.INFO

# -------------------------
# Catalog SQL (unchanged)
# -------------------------
DB_LIST_QUERY = """
SELECT name FROM sys.databases
WHERE database_id > 4
  AND state = 0
ORDER BY name;
"""

SQL_PER_DB = r"""
SET NOCOUNT ON;

;WITH ColInfo AS (
    SELECT
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        -- Prefer system_type_id join to get canonical type names
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
        -- fallback if the above doesn't find a match (rare)
    LEFT JOIN sys.types tp2 ON c.user_type_id = tp2.user_type_id AND tp.is_user_defined = 1
    LEFT JOIN sys.identity_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
    LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
    WHERE t.is_ms_shipped = 0
)
, TableCreate AS (
    SELECT
        SchemaName,
        TableName,
        'CREATE TABLE ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + CHAR(10) + '(' + CHAR(10) +
        STRING_AGG(
            '    ' + QUOTENAME(ColumnName) + ' ' +
            -- handle type names and lengths
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
            -- pretty default: strip single outer parens if present
            CASE WHEN DefaultDefinition IS NOT NULL 
                 THEN ' DEFAULT ' + 
                      CASE 
                        WHEN LEFT(LTRIM(DefaultDefinition),1) = '(' AND RIGHT(RTRIM(DefaultDefinition),1) = ')' 
                             AND CHARINDEX('(', DefaultDefinition, 2) = 0
                        THEN SUBSTRING(DefaultDefinition,2,LEN(DefaultDefinition)-2)
                        ELSE DefaultDefinition
                      END
                 ELSE '' END
        , ',' + CHAR(10)) WITHIN GROUP (ORDER BY column_id)
        + CHAR(10) + ');' AS DDL
    FROM ColInfo
    WHERE is_computed = 0  -- exclude computed columns by default; remove this filter to include them specially
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
            CASE WHEN k.type_desc = 'CLUSTERED' THEN 'CLUSTERED ' ELSE 'NONCLUSTERED ' END +
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
# Helpers
# -------------------------
def sanitize(name):
    return (name.replace(" ", "_")
                .replace(":", "_")
                .replace("\\", "_")
                .replace("/", "_"))

def get_conn_str(server: str, driver: str, dbname: str = None) -> str:
    if dbname:
        return (
            f"DRIVER={{{driver}}};SERVER={server};DATABASE={dbname};"
            f"UID={EMBEDDED_USERNAME};PWD={EMBEDDED_PASSWORD};"
        )
    return (
        f"DRIVER={{{driver}}};SERVER={server};"
        f"UID={EMBEDDED_USERNAME};PWD={EMBEDDED_PASSWORD};"
    )

# -------------------------
# Per-server extractor (writes .sql per DB, README summary)
# -------------------------
def process_server(server: str, driver: str, base_output: str, logger):
    server_start = time.time()
    safe_server = sanitize(server)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    server_dir = os.path.join(base_output, f"{safe_server}_{timestamp}")
    os.makedirs(server_dir, exist_ok=True)

    logger.info("=== SERVER START: %s ===", server)

    processed = 0
    failures = []

    # Stats containers for README
    per_db_stats = {}
    server_type_totals = defaultdict(int)
    server_total_objects = 0
    db_order = []

    try:
        # 1) enumerate DBs
        logger.info("[%s] Listing databases...", server)
        conn_str = get_conn_str(server, driver)
        with pyodbc.connect(conn_str, timeout=10) as srv_conn:
            cur = srv_conn.cursor()
            cur.execute(DB_LIST_QUERY)
            db_list = [r[0] for r in cur.fetchall()]

        logger.info("[%s] DBs found: %s", server, db_list)

        # 2) extract for each DB
        for db in db_list:
            db_order.append(db)
            safe_db = sanitize(db)
            db_start = time.time()
            sql_path = os.path.join(server_dir, f"{safe_db}.sql")
            objects_written = 0
            per_type_counts = defaultdict(int)

            try:
                logger.info("[%s][%s] Connecting and extracting...", server, db)
                with pyodbc.connect(get_conn_str(server, driver, db), autocommit=True, timeout=30) as conn:
                    cur = conn.cursor()
                    logger.info("[%s][%s] Executing extraction SQL...", server, db)
                    cur.execute(SQL_PER_DB)

                    # If execute succeeds, stream rows to .sql
                    with open(sql_path, "w", encoding="utf-8", newline='\n') as outsql:
                        header = (
                            f"-- DDL Export\n"
                            f"-- Server: {server}\n"
                            f"-- Database: {db}\n"
                            f"-- Exported: {datetime.now().isoformat()}\n\n"
                            f"USE {db};\nGO\n\n"
                        )
                        outsql.write(header)

                        while True:
                            rows = cur.fetchmany(FETCH_BATCH)
                            if not rows:
                                break
                            for r in rows:
                                try:
                                    dbname, objtype, schema, objname, ddl = r
                                except Exception:
                                    logger.exception("[%s][%s] Unexpected row format: %s", server, db, r)
                                    continue

                                if ddl is None:
                                    ddl = "/* <no DDL provided> */"

                                outsql.write(f"-- --------------------------------------------------\n")
                                outsql.write(f"-- {objtype} {schema}.{objname}\n")
                                outsql.write(f"-- --------------------------------------------------\n")
                                outsql.write(ddl.rstrip() + "\n\n")
                                outsql.write("GO\n\n")

                                objects_written += 1
                                per_type_counts[objtype] += 1
                                server_type_totals[objtype] += 1
                                server_total_objects += 1

                            if objects_written % 1000 == 0 and objects_written > 0:
                                logger.info("[%s][%s] written %d objects so far...", server, db, objects_written)

                elapsed_db = time.time() - db_start
                logger.info("[%s][%s] Completed: %d objects -> %s (%.1f sec)", server, db, objects_written, sql_path, elapsed_db)
                processed += 1

                # save per-db stats
                per_db_stats[db] = {
                    "objects_written": objects_written,
                    "by_type": dict(per_type_counts),
                    "start_time": datetime.fromtimestamp(db_start).isoformat(),
                    "end_time": datetime.fromtimestamp(time.time()).isoformat(),
                    "elapsed_seconds": round(elapsed_db, 2),
                    "status": "OK"
                }

            except Exception as exec_err:
                # Handle per-DB execution error: save failing SQL, diagnostics, error marker .sql
                logger.exception("[%s][%s] Error processing DB: %s", server, db, exec_err)
                failures.append((db, str(exec_err)))

                # Save the SQL_PER_DB to a failing SQL file for manual inspection
                failed_sql_file = os.path.join(server_dir, f"failed_sql__{sanitize(db)}__{timestamp}.sql")
                try:
                    with open(failed_sql_file, "w", encoding="utf-8", newline='\n') as ff:
                        ff.write("-- Saved SQL_PER_DB for manual inspection\n")
                        ff.write("-- Connect in SSMS to the target database and run this (USE [<DB>]; then run):\n\n")
                        ff.write(SQL_PER_DB)
                    logger.error("[%s][%s] Saved failing SQL to: %s", server, db, failed_sql_file)
                except Exception as wf:
                    logger.exception("[%s][%s] Failed to write failing SQL file: %s", server, db, wf)

                # Try to run small diagnostic queries if possible
                try:
                    with pyodbc.connect(get_conn_str(server, driver, db), autocommit=True, timeout=10) as diag_conn:
                        dcur = diag_conn.cursor()
                        try:
                            dcur.execute("SELECT @@VERSION AS ServerVersion;")
                            ver_row = dcur.fetchone()
                            logger.error("[%s][%s] @@VERSION: %s", server, db, ver_row[0] if ver_row else "<no version>")
                        except Exception:
                            logger.exception("[%s][%s] @@VERSION query failed", server, db)

                        try:
                            dcur.execute("SELECT DB_NAME() AS DbName;")
                            logger.error("[%s][%s] DB_NAME(): %s", server, db, dcur.fetchone()[0])
                        except Exception:
                            logger.exception("[%s][%s] DB_NAME() query failed", server, db)

                        try:
                            dcur.execute("SELECT compatibility_level FROM sys.databases WHERE name = DB_NAME();")
                            comp_row = dcur.fetchone()
                            logger.error("[%s][%s] compatibility_level: %s", server, db, comp_row[0] if comp_row else "<unknown>")
                        except Exception:
                            logger.exception("[%s][%s] compatibility_level query failed", server, db)
                except Exception:
                    logger.exception("[%s][%s] Could not open diag connection", server, db)

                # Also write an error marker .sql so there's a file for this DB
                try:
                    with open(sql_path, "w", encoding="utf-8", newline='\n') as errsql:
                        errsql.write(f"-- ERROR extracting database {db}\n")
                        errsql.write(f"-- Server: {server}\n")
                        errsql.write(f"-- Time: {datetime.now().isoformat()}\n\n")
                        errsql.write(f"-- Exception: {str(exec_err)}\n\n")
                    logger.info("[%s][%s] Wrote error marker SQL: %s", server, db, sql_path)
                except Exception as e2:
                    logger.exception("[%s][%s] Failed to write error SQL marker: %s", server, db, e2)

                # record failure stats
                per_db_stats[db] = {
                    "objects_written": objects_written,
                    "by_type": dict(per_type_counts),
                    "start_time": datetime.fromtimestamp(db_start).isoformat(),
                    "end_time": datetime.fromtimestamp(time.time()).isoformat(),
                    "elapsed_seconds": round(time.time() - db_start, 2),
                    "status": "ERROR",
                    "error": str(exec_err)
                }

    except Exception as srv_err:
        logger.exception("[%s] SERVER ERROR: %s", server, srv_err)
        failures.append(("SERVER", str(srv_err)))

    # Always write README (attempt even if server-level error happened)
    try:
        elapsed = time.time() - server_start
    except Exception:
        elapsed = 0.0

    readme_path = os.path.join(server_dir, "README.txt")
    try:
        with open(readme_path, "w", encoding="utf-8", newline='\n') as rf:
            rf.write(f"DDL Extraction README\n")
            rf.write(f"Server: {server}\n")
            rf.write(f"Output folder: {server_dir}\n")
            rf.write(f"Started: {datetime.fromtimestamp(server_start).isoformat()}\n")
            rf.write(f"Finished: {datetime.now().isoformat()}\n")
            rf.write(f"Elapsed seconds: {round(elapsed,2)}\n")
            rf.write("\n")
            rf.write(f"Databases processed: {len(per_db_stats)} (successful: {processed}, failures: {len(failures)})\n")
            rf.write("\n")
            rf.write("Per-database details:\n")
            rf.write("---------------------\n")
            for db in db_order:
                info = per_db_stats.get(db)
                if not info:
                    rf.write(f"- {db}: not attempted or no info\n")
                    continue
                rf.write(f"- {db}:\n")
                rf.write(f"    status: {info.get('status')}\n")
                rf.write(f"    objects_written: {info.get('objects_written')}\n")
                rf.write(f"    elapsed_seconds: {info.get('elapsed_seconds')}\n")
                rf.write(f"    start_time: {info.get('start_time')}\n")
                rf.write(f"    end_time: {info.get('end_time')}\n")
                rf.write(f"    by_type:\n")
                by_type = info.get('by_type', {})
                if by_type:
                    for t, c in sorted(by_type.items(), key=lambda x: (-x[1], x[0])):
                        rf.write(f"        {t}: {c}\n")
                else:
                    rf.write(f"        <none>\n")
                if info.get("status") == "ERROR":
                    rf.write(f"    error: {info.get('error')}\n")
                rf.write("\n")

            rf.write("Server totals (by object type):\n")
            rf.write("--------------------------------\n")
            if server_type_totals:
                for t, c in sorted(server_type_totals.items(), key=lambda x: (-x[1], x[0])):
                    rf.write(f"{t}: {c}\n")
            else:
                rf.write("<no objects extracted>\n")
            rf.write(f"\nTotal objects extracted: {server_total_objects}\n")
            rf.write("\nFailures summary:\n")
            rf.write("-----------------\n")
            if failures:
                for fdb, ferr in failures:
                    rf.write(f"- {fdb}: {ferr}\n")
            else:
                rf.write("None\n")
            rf.write("\nNotes:\n")
            rf.write("- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:\n")
            rf.write("  failed_sql__<DB>__<timestamp>.sql\n")
            rf.write("- Individual database .sql files (one per DB) are in this folder as <DB>.sql\n")
            rf.write(f"- Central logger file(s) are located in: {CENTRAL_LOG_DIR}\n")

        logger.info("[%s] Wrote README: %s", server, readme_path)
    except Exception as re:
        logger.exception("[%s] Failed to write README: %s", server, re)

    return {
        "server": server,
        "processed": processed,
        "failures": failures,
        "output_dir": server_dir,
        "readme": readme_path
    }

# -------------------------
# MAIN
# -------------------------
def main():
    # validate servers file
    if not os.path.isfile(SERVERS_FILE_PATH):
        print(f"ERROR: servers.txt not found at: {SERVERS_FILE_PATH}")
        sys.exit(1)

    servers = []
    with open(SERVERS_FILE_PATH, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                servers.append(line)

    if not servers:
        print(f"ERROR: No servers found in {SERVERS_FILE_PATH}")
        sys.exit(1)

    # prepare output and central logging
    os.makedirs(BASE_OUTPUT_DIR, exist_ok=True)
    os.makedirs(CENTRAL_LOG_DIR, exist_ok=True)  # ensure central log folder exists
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    central_log = os.path.join(CENTRAL_LOG_DIR, f"multi_server_{timestamp}.log")  # central log path

    logging.basicConfig(
        level=LOG_LEVEL,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=[logging.StreamHandler(), logging.FileHandler(central_log, encoding="utf-8")]
    )
    logger = logging.getLogger("central")
    logger.info("Starting multi-server extraction")
    logger.info("Loaded servers: %s", servers)
    logger.info("Central log location: %s", central_log)

    results = []
    workers = max(1, DEFAULT_WORKERS)
    if workers == 1:
        for s in servers:
            res = process_server(s, DEFAULT_DRIVER, BASE_OUTPUT_DIR, logger)
            results.append(res)
    else:
        with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as exe:
            futures = {exe.submit(process_server, s, DEFAULT_DRIVER, BASE_OUTPUT_DIR, logger): s for s in servers}
            for fut in concurrent.futures.as_completed(futures):
                try:
                    res = fut.result()
                except Exception as e:
                    server_name = futures.get(fut, "<unknown>")
                    logger.exception("Server task %s crashed: %s", server_name, e)
                    res = {"server": server_name, "processed": 0, "failures": [("__executor__", str(e))], "output_dir": None}
                results.append(res)

    # summary
    total_processed = sum(r.get("processed", 0) for r in results)
    total_failures = sum(len(r.get("failures", [])) for r in results)
    logger.info("All servers done. total_servers=%d total_processed_dbs=%d total_failures=%d", len(servers), total_processed, total_failures)
    logger.info("Central log: %s", central_log)
    print("\nPer-server summary:")
    for r in results:
        print(f" - {r['server']}: processed_dbs={r['processed']} failures={len(r['failures'])} output_dir={r.get('output_dir')} README={r.get('readme')}")

if __name__ == "__main__":
    main()