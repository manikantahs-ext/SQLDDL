#!/usr/bin/env python3
"""
Python_extract_object_per_DB_manyservers.py

Multi-server DDL extraction with optional Git push:
 - Reads servers from SERVERS_FILE_PATH
 - Uses embedded SQL credentials
 - Runs SQL_PER_DB inside each user database
 - Writes one CSV per database in per-server output folders
 - On SQL failure for a DB, saves the SQL to a .sql file for inspection and logs diagnostics
 - Optionally commits & pushes the generated output to a Git remote (supports GIT_PAT via env)
"""

import pyodbc
import csv
import os
import logging
import time
from datetime import datetime
import concurrent.futures
import sys
import subprocess
import shlex

# -------------------------
# EMBEDDED SQL AUTH CREDENTIALS (as requested)
# -------------------------
EMBEDDED_USERNAME = "Sqlradar"
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
DEFAULT_WORKERS = 1        # change to >1 if you want parallel servers
FETCH_BATCH = 200          # rows per fetchmany
LOG_LEVEL = logging.INFO

# -------------------------
# Git configuration (edit)
# -------------------------
# If empty, push step will be skipped.
# Example remote: "https://github.com/YourUser/sql-ddl-dumps.git"
GIT_REMOTE = "https://github.com/angel-one/tf-vault-gpx-oss"  # set to your HTTPS remote URL to enable push

# Recommended: set GIT_PAT in an environment variable instead of hardcoding here:
# os.environ["GIT_PAT"] = "ghp_xxx"  # avoid hardcoding
# The script will check env var GIT_PAT first, then variable below.
GIT_PAT = os.environ.get("GIT_PAT", "")  # fallback to blank (do NOT hardcode sensitive tokens here)

# Files/patterns to ignore in the repo (script will create/update .gitignore)
GIT_IGNORE_CONTENT = """# ignore script containing credentials and logs
Python_extract_object_per_DB_manyservers.py
*.log
__pycache__/
*.pyc
"""

# -------------------------
# Catalog SQL
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
        'CREATE TABLE ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName) + CHAR(13)+CHAR(10)+ '(' + CHAR(13)+CHAR(10) +
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
        , ',' + CHAR(13)+CHAR(10)) WITHIN GROUP (ORDER BY column_id)
        + CHAR(13)+CHAR(10) + ');' AS DDL
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
# Git helper functions
# -------------------------
def ensure_git_repo(base_dir: str, logger: logging.Logger, git_remote: str = None, git_pat: str = ""):
    """
    Ensure a git repo is initialized at base_dir and remote is configured.
    If git_remote provided and no 'origin' exists, origin will be added.
    If git_pat is provided, remote URL for push will use the PAT (temporarily).
    """
    def run(cmd, cwd=base_dir):
        logger.info("git> %s", cmd)
        completed = subprocess.run(shlex.split(cmd), cwd=cwd, capture_output=True, text=True)
        if completed.returncode != 0:
            logger.error("git cmd failed: %s\nSTDOUT:%s\nSTDERR:%s", cmd, completed.stdout, completed.stderr)
        return completed

    # init repo if not exists
    if not os.path.isdir(os.path.join(base_dir, ".git")):
        run(f"git init {shlex.quote(base_dir)}")
    # write/update .gitignore
    gi_path = os.path.join(base_dir, ".gitignore")
    try:
        with open(gi_path, "w", encoding="utf-8") as gf:
            gf.write(GIT_IGNORE_CONTENT)
        logger.info("Wrote .gitignore at %s", gi_path)
    except Exception as e:
        logger.exception("Failed to write .gitignore: %s", e)

    # set remote origin if requested
    if git_remote:
        # if origin exists, check; otherwise add
        res = run("git remote")
        if "origin" not in res.stdout.split():
            # If PAT provided, insert into URL for push (but store origin without PAT to avoid writing token into config)
            run(f"git remote add origin {git_remote}")

def git_add_commit_push(base_dir: str, paths_to_add: list, logger: logging.Logger, git_remote: str = None, git_pat: str = ""):
    """
    Add specific paths, commit and push. If git_pat is provided, uses HTTPS remote with PAT for push.
    """
    def run(cmd, cwd=base_dir, check=True):
        logger.info("git> %s", cmd)
        completed = subprocess.run(shlex.split(cmd), cwd=cwd, capture_output=True, text=True)
        if completed.returncode != 0:
            logger.error("git cmd failed: %s\nSTDOUT:%s\nSTDERR:%s", cmd, completed.stdout, completed.stderr)
            if check:
                raise RuntimeError(f"git command failed: {cmd}\n{completed.stderr}")
        return completed

    # stage specific paths
    for p in paths_to_add:
        run(f"git add {shlex.quote(p)}")

    # commit
    msg = f"Add DDL export {datetime.now().strftime('%Y%m%d_%H%M%S')}"
    try:
        run(f'git commit -m "{msg}"')
    except RuntimeError:
        logger.info("No changes to commit (or git commit failed).")

    # push
    if git_remote:
        push_cmd = "git push -u origin main"
        # if no main branch yet, create and push
        # ensure branch exists
        run("git branch --show-current", check=False)
        # try to set branch main if not set
        try:
            run("git branch -M main")
        except RuntimeError:
            logger.info("Could not rename branch to main; continuing.")
        # if PAT is provided, build a temp remote URL for push (do not mutate origin in repo)
        if git_pat:
            # construct remote with token for push only
            # parse git_remote to insert pat after https://
            if git_remote.startswith("https://"):
                auth_remote = git_remote.replace("https://", f"https://{git_pat}@")
                # perform push using auth_remote via git push <auth_remote> HEAD:main
                run(f"git push {shlex.quote(auth_remote)} HEAD:main")
            else:
                # fallback to regular push (ssh or other)
                run(push_cmd)
        else:
            run(push_cmd)
    else:
        logger.info("No GIT_REMOTE configured; skipping push.")

# -------------------------
# Per-server extractor (with diagnostics on SQL error)
# -------------------------
def process_server(server: str, driver: str, base_output: str, logger):

    server_start = time.time()
    safe_server = sanitize(server)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    server_dir = os.path.join(base_output, f"{safe_server}_{timestamp}")
    os.makedirs(server_dir, exist_ok=True)

    # Per-server log file
    server_log = os.path.join(server_dir, f"{safe_server}_{timestamp}.log")
    fh = logging.FileHandler(server_log, encoding="utf-8")
    fh.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(message)s"))
    logger.addHandler(fh)

    logger.info("=== SERVER START: %s ===", server)

    processed = 0
    failures = []

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
            safe_db = sanitize(db)
            db_start = time.time()
            csv_path = os.path.join(server_dir, f"{safe_db}.csv")
            rows_written = 0

            try:
                logger.info("[%s][%s] Connecting and extracting...", server, db)
                with pyodbc.connect(get_conn_str(server, driver, db), autocommit=True, timeout=30) as conn:

                    # execute with diagnostic capture
                    try:
                        cur = conn.cursor()
                        logger.info("[%s][%s] Executing extraction SQL...", server, db)
                        cur.execute(SQL_PER_DB)

                        # If execute succeeds, stream rows to CSV
                        with open(csv_path, "w", newline="", encoding="utf-8") as outcsv:
                            writer = csv.writer(outcsv, quoting=csv.QUOTE_ALL)
                            writer.writerow(["DatabaseName", "ObjectType", "SchemaName", "ObjectName", "DDL"])

                            rows_written = 0
                            while True:
                                rows = cur.fetchmany(FETCH_BATCH)
                                if not rows:
                                    break
                                for r in rows:
                                    dbname, objtype, schema, objname, ddl = r
                                    if ddl is None:
                                        ddl = ""
                                    writer.writerow([dbname, objtype, schema, objname, ddl])
                                    rows_written += 1
                                if rows_written % 1000 == 0:
                                    logger.info("[%s][%s] written %d rows so far...", server, db, rows_written)

                    except Exception as exec_err:
                        # Save the SQL to a file for manual inspection
                        failed_sql_file = os.path.join(server_dir, f"failed_sql__{sanitize(db)}__{timestamp}.sql")
                        try:
                            with open(failed_sql_file, "w", encoding="utf-8") as ff:
                                ff.write("-- Saved SQL_PER_DB for manual inspection\n")
                                ff.write("-- Connect in SSMS to the target database and run this (USE [<DB>]; then run):\n\n")
                                ff.write(SQL_PER_DB)
                            logger.error("[%s][%s] Saved failing SQL to: %s", server, db, failed_sql_file)
                        except Exception as wf:
                            logger.exception("[%s][%s] Failed to write failing SQL file: %s", server, db, wf)

                        # Run small diagnostic queries and log results
                        try:
                            diag_cur = conn.cursor()
                            diag_cur.execute("SELECT @@VERSION AS ServerVersion;")
                            ver_row = diag_cur.fetchone()
                            logger.error("[%s][%s] @@VERSION: %s", server, db, ver_row[0] if ver_row else "<no version>")

                            diag_cur.execute("SELECT DB_NAME() AS DbName;")
                            try:
                                logger.error("[%s][%s] DB_NAME(): %s", server, db, diag_cur.fetchone()[0])
                            except:
                                logger.error("[%s][%s] DB_NAME(): <failed to fetch>", server, db)

                            diag_cur.execute("SELECT compatibility_level FROM sys.databases WHERE name = DB_NAME();")
                            comp_row = diag_cur.fetchone()
                            logger.error("[%s][%s] compatibility_level: %s", server, db, comp_row[0] if comp_row else "<unknown>")

                        except Exception as diag_e:
                            logger.exception("[%s][%s] Diagnostic queries failed: %s", server, db, diag_e)

                        # Re-raise to be caught by outer per-DB exception handler
                        raise exec_err

                elapsed_db = time.time() - db_start
                logger.info("[%s][%s] Completed: %d rows -> %s (%.1f sec)", server, db, rows_written, csv_path, elapsed_db)
                processed += 1

            except Exception as e_db:
                logger.exception("[%s][%s] Error processing DB: %s", server, db, e_db)
                failures.append((db, str(e_db)))
                # write an error-marker CSV so there's a file for this DB
                try:
                    with open(csv_path, "w", newline="", encoding="utf-8") as f:
                        w = csv.writer(f, quoting=csv.QUOTE_ALL)
                        w.writerow(["DatabaseName", "ObjectType", "SchemaName", "ObjectName", "DDL"])
                        w.writerow([db, "ERROR", "", "", str(e_db)])
                    logger.info("[%s][%s] Wrote error marker CSV: %s", server, db, csv_path)
                except Exception as e2:
                    logger.exception("[%s][%s] Failed to write error CSV: %s", server, db, e2)

    except Exception as srv_err:
        logger.exception("[%s] SERVER ERROR: %s", server, srv_err)
        failures.append(("SERVER", str(srv_err)))

    finally:
        elapsed = time.time() - server_start
        logger.info("[%s] Finished. OK=%d ERRORS=%d Time=%.1f sec", server, processed, len(failures), elapsed)
        # remove per-server FileHandler
        logger.removeHandler(fh)

    return {
        "server": server,
        "processed": processed,
        "failures": failures,
        "output_dir": server_dir
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
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    central_log = os.path.join(BASE_OUTPUT_DIR, f"multi_server_{timestamp}.log")

    logging.basicConfig(
        level=LOG_LEVEL,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=[logging.StreamHandler(), logging.FileHandler(central_log, encoding="utf-8")]
    )
    logger = logging.getLogger("central")
    logger.info("Starting multi-server extraction")
    logger.info("Loaded servers: %s", servers)

    results = []
    # run sequentially or in parallel according to DEFAULT_WORKERS
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
        print(f" - {r['server']}: processed_dbs={r['processed']} failures={len(r['failures'])} output={r.get('output_dir')}")

    # -------------------------
    # Git push step (optional)
    # -------------------------
    if not GIT_REMOTE:
        logger.info("GIT_REMOTE not set — skipping push to GitHub.")
        return

    try:
        logger.info("Preparing to push outputs to Git remote: %s", GIT_REMOTE)
        # Ensure repo exists and .gitignore present
        ensure_git_repo(BASE_OUTPUT_DIR, logger, git_remote=GIT_REMOTE, git_pat=GIT_PAT)

        # Collect the list of paths to add: the subfolders generated during this run (per-server)
        paths_to_add = []
        for r in results:
            out = r.get("output_dir")
            if out and out.startswith(BASE_OUTPUT_DIR):
                # add relative path from BASE_OUTPUT_DIR
                rel = os.path.relpath(out, BASE_OUTPUT_DIR)
                paths_to_add.append(rel)

        if not paths_to_add:
            logger.info("No new output dirs to add to git. Skipping commit/push.")
            return

        logger.info("Paths to add to git: %s", paths_to_add)

        # perform add, commit, push
        git_add_commit_push(BASE_OUTPUT_DIR, paths_to_add, logger, git_remote=GIT_REMOTE, git_pat=GIT_PAT)
        logger.info("Push complete (if no errors).")

    except Exception as git_e:
        logger.exception("Git push failed: %s", git_e)
        print("Git push failed; see log for details.")

if __name__ == "__main__":
    main()
