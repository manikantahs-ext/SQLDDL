DDL Extraction README
Server: 10.254.33.118
Output folder: C:\Manikanta\ddl_exports\10.254.33.118_20260205_113507
Started: 2026-02-05T11:35:07.701160
Finished: 2026-02-05T11:35:09.753618
Elapsed seconds: 2.05

Databases processed: 2 (successful: 2, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 102
    elapsed_seconds: 0.92
    start_time: 2026-02-05T11:35:08.112887
    end_time: 2026-02-05T11:35:09.050378
    by_type:
        PROCEDURE: 31
        TABLE: 30
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        FUNCTION: 1
        TRIGGER: 1

- ReplicatedData:
    status: OK
    objects_written: 71
    elapsed_seconds: 0.7
    start_time: 2026-02-05T11:35:09.050378
    end_time: 2026-02-05T11:35:09.753619
    by_type:
        PK_UNIQUE: 27
        TABLE: 27
        INDEX: 14
        PROCEDURE: 3

Server totals (by object type):
--------------------------------
TABLE: 57
PK_UNIQUE: 48
PROCEDURE: 34
INDEX: 25
VIEW: 6
FOREIGN_KEY: 1
FUNCTION: 1
TRIGGER: 1

Total objects extracted: 173

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
