DDL Extraction README
Server: 10.254.33.61
Output folder: C:\Manikanta\ddl_exports\10.254.33.61_20260205_113509
Started: 2026-02-05T11:35:09.784763
Finished: 2026-02-05T11:35:19.969676
Elapsed seconds: 10.18

Databases processed: 10 (successful: 10, failures: 0)

Per-database details:
---------------------
- DBA_Admin:
    status: OK
    objects_written: 101
    elapsed_seconds: 0.81
    start_time: 2026-02-05T11:35:10.128727
    end_time: 2026-02-05T11:35:10.942904
    by_type:
        TABLE: 31
        PROCEDURE: 29
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        FUNCTION: 1
        TRIGGER: 1

- FinPlan:
    status: OK
    objects_written: 105
    elapsed_seconds: 0.79
    start_time: 2026-02-05T11:35:10.942904
    end_time: 2026-02-05T11:35:11.752144
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
    elapsed_seconds: 1.66
    start_time: 2026-02-05T11:35:11.752144
    end_time: 2026-02-05T11:35:13.411250
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
    elapsed_seconds: 0.98
    start_time: 2026-02-05T11:35:13.411250
    end_time: 2026-02-05T11:35:14.390719
    by_type:
        PROCEDURE: 271
        TABLE: 79
        INDEX: 18
        PK_UNIQUE: 7
        FUNCTION: 5

- NXT_Logs:
    status: OK
    objects_written: 5
    elapsed_seconds: 0.73
    start_time: 2026-02-05T11:35:14.390719
    end_time: 2026-02-05T11:35:15.116543
    by_type:
        TABLE: 3
        INDEX: 1
        PROCEDURE: 1

- NXTAdminAuthSession:
    status: OK
    objects_written: 30
    elapsed_seconds: 0.79
    start_time: 2026-02-05T11:35:15.116543
    end_time: 2026-02-05T11:35:15.910618
    by_type:
        PROCEDURE: 23
        TABLE: 3
        INDEX: 2
        PK_UNIQUE: 2

- NXTAuthSession:
    status: OK
    objects_written: 46
    elapsed_seconds: 0.9
    start_time: 2026-02-05T11:35:15.910618
    end_time: 2026-02-05T11:35:16.813209
    by_type:
        PROCEDURE: 35
        TABLE: 5
        INDEX: 4
        PK_UNIQUE: 2

- NXTMFAuthSession:
    status: OK
    objects_written: 31
    elapsed_seconds: 0.8
    start_time: 2026-02-05T11:35:16.813209
    end_time: 2026-02-05T11:35:17.612972
    by_type:
        PROCEDURE: 23
        TABLE: 4
        INDEX: 2
        PK_UNIQUE: 2

- opticloud:
    status: OK
    objects_written: 1662
    elapsed_seconds: 1.58
    start_time: 2026-02-05T11:35:17.612972
    end_time: 2026-02-05T11:35:19.193434
    by_type:
        PROCEDURE: 937
        TABLE: 321
        PK_UNIQUE: 228
        VIEW: 129
        FOREIGN_KEY: 25
        FUNCTION: 18
        INDEX: 4

- Upload_NXT:
    status: OK
    objects_written: 0
    elapsed_seconds: 0.78
    start_time: 2026-02-05T11:35:19.193434
    end_time: 2026-02-05T11:35:19.969676
    by_type:
        <none>

Server totals (by object type):
--------------------------------
PROCEDURE: 1959
TABLE: 882
PK_UNIQUE: 350
INDEX: 327
VIEW: 140
FOREIGN_KEY: 43
FUNCTION: 34
TRIGGER: 1

Total objects extracted: 3736

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
