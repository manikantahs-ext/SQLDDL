DDL Extraction README
Server: 10.253.78.155
Output folder: C:\Manikanta\ddl_exports\10.253.78.155_20260205_123234
Started: 2026-02-05T12:32:34.920668
Finished: 2026-02-05T12:32:35.823770
Elapsed seconds: 0.9

Databases processed: 12 (successful: 12, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 98
    elapsed_seconds: 0.08
    start_time: 2026-02-05T12:32:34.936747
    end_time: 2026-02-05T12:32:35.015452
    by_type:
        TABLE: 31
        PROCEDURE: 27
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        TRIGGER: 1

- FinPlan:
    status: OK
    objects_written: 105
    elapsed_seconds: 0.04
    start_time: 2026-02-05T12:32:35.015452
    end_time: 2026-02-05T12:32:35.058213
    by_type:
        PROCEDURE: 55
        TABLE: 35
        INDEX: 12
        FUNCTION: 1
        PK_UNIQUE: 1
        VIEW: 1

- NXT:
    status: OK
    objects_written: 1376
    elapsed_seconds: 0.21
    start_time: 2026-02-05T12:32:35.058213
    end_time: 2026-02-05T12:32:35.269362
    by_type:
        PROCEDURE: 585
        TABLE: 401
        INDEX: 273
        PK_UNIQUE: 87
        FOREIGN_KEY: 17
        FUNCTION: 9
        VIEW: 4

- NXT_Admin:
    status: OK
    objects_written: 380
    elapsed_seconds: 0.07
    start_time: 2026-02-05T12:32:35.269362
    end_time: 2026-02-05T12:32:35.339819
    by_type:
        PROCEDURE: 271
        TABLE: 79
        INDEX: 18
        PK_UNIQUE: 7
        FUNCTION: 5

- NXT_Logs:
    status: OK
    objects_written: 5
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:32:35.339819
    end_time: 2026-02-05T12:32:35.371099
    by_type:
        TABLE: 3
        INDEX: 1
        PROCEDURE: 1

- NXTAdminAuthSession:
    status: OK
    objects_written: 30
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:32:35.371099
    end_time: 2026-02-05T12:32:35.401886
    by_type:
        PROCEDURE: 23
        TABLE: 3
        INDEX: 2
        PK_UNIQUE: 2

- NXTAuthSession:
    status: OK
    objects_written: 46
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:32:35.401886
    end_time: 2026-02-05T12:32:35.433176
    by_type:
        PROCEDURE: 35
        TABLE: 5
        INDEX: 4
        PK_UNIQUE: 2

- NXTMFAuthSession:
    status: OK
    objects_written: 31
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:32:35.433176
    end_time: 2026-02-05T12:32:35.464454
    by_type:
        PROCEDURE: 23
        TABLE: 4
        INDEX: 2
        PK_UNIQUE: 2

- opticloud:
    status: OK
    objects_written: 1662
    elapsed_seconds: 0.23
    start_time: 2026-02-05T12:32:35.464454
    end_time: 2026-02-05T12:32:35.698985
    by_type:
        PROCEDURE: 937
        TABLE: 321
        PK_UNIQUE: 228
        VIEW: 129
        FOREIGN_KEY: 25
        FUNCTION: 18
        INDEX: 4

- ReportServer:
    status: OK
    objects_written: 410
    elapsed_seconds: 0.06
    start_time: 2026-02-05T12:32:35.698985
    end_time: 2026-02-05T12:32:35.761383
    by_type:
        PROCEDURE: 252
        INDEX: 43
        TABLE: 36
        PK_UNIQUE: 34
        FOREIGN_KEY: 29
        TRIGGER: 7
        VIEW: 5
        CHECK: 3
        FUNCTION: 1

- ReportServerTempDB:
    status: OK
    objects_written: 52
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:32:35.761383
    end_time: 2026-02-05T12:32:35.792590
    by_type:
        INDEX: 22
        TABLE: 13
        PK_UNIQUE: 11
        CHECK: 3
        FOREIGN_KEY: 2
        PROCEDURE: 1

- Upload_NXT:
    status: OK
    objects_written: 0
    elapsed_seconds: 0.02
    start_time: 2026-02-05T12:32:35.792590
    end_time: 2026-02-05T12:32:35.823770
    by_type:
        <none>

Server totals (by object type):
--------------------------------
PROCEDURE: 2210
TABLE: 931
PK_UNIQUE: 395
INDEX: 392
VIEW: 145
FOREIGN_KEY: 74
FUNCTION: 34
TRIGGER: 8
CHECK: 6

Total objects extracted: 4195

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
