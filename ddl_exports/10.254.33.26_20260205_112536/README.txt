DDL Extraction README
Server: 10.254.33.26
Output folder: C:\Manikanta\ddl_exports\10.254.33.26_20260205_112536
Started: 2026-02-05T11:25:36.296342
Finished: 2026-02-05T11:25:59.726196
Elapsed seconds: 23.43

Databases processed: 12 (successful: 12, failures: 0)

Per-database details:
---------------------
- ACCOUNT:
    status: OK
    objects_written: 3429
    elapsed_seconds: 3.27
    start_time: 2026-02-05T11:25:36.689960
    end_time: 2026-02-05T11:25:39.968433
    by_type:
        PROCEDURE: 1565
        TABLE: 1516
        INDEX: 152
        VIEW: 113
        PK_UNIQUE: 35
        FUNCTION: 32
        TRIGGER: 15
        CHECK: 1

- ACCOUNTSLBS:
    status: OK
    objects_written: 683
    elapsed_seconds: 1.36
    start_time: 2026-02-05T11:25:39.968433
    end_time: 2026-02-05T11:25:41.328263
    by_type:
        PROCEDURE: 301
        TABLE: 162
        INDEX: 116
        CHECK: 64
        PK_UNIQUE: 15
        VIEW: 9
        FUNCTION: 8
        TRIGGER: 8

- ASBA:
    status: OK
    objects_written: 2
    elapsed_seconds: 0.71
    start_time: 2026-02-05T11:25:41.328263
    end_time: 2026-02-05T11:25:42.041212
    by_type:
        PK_UNIQUE: 1
        TABLE: 1

- DBA_Admin:
    status: OK
    objects_written: 103
    elapsed_seconds: 1.08
    start_time: 2026-02-05T11:25:42.041212
    end_time: 2026-02-05T11:25:43.125431
    by_type:
        TABLE: 33
        PROCEDURE: 29
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        FUNCTION: 1
        TRIGGER: 1

- Dustbin:
    status: OK
    objects_written: 871
    elapsed_seconds: 1.35
    start_time: 2026-02-05T11:25:43.125431
    end_time: 2026-02-05T11:25:44.479763
    by_type:
        TABLE: 736
        PROCEDURE: 93
        INDEX: 34
        PK_UNIQUE: 7
        VIEW: 1

- EventNotifications:
    status: OK
    objects_written: 6
    elapsed_seconds: 0.74
    start_time: 2026-02-05T11:25:44.479763
    end_time: 2026-02-05T11:25:45.218345
    by_type:
        PROCEDURE: 3
        PK_UNIQUE: 1
        TABLE: 1
        TRIGGER: 1

- Inhouse:
    status: OK
    objects_written: 939
    elapsed_seconds: 1.4
    start_time: 2026-02-05T11:25:45.218345
    end_time: 2026-02-05T11:25:46.616456
    by_type:
        TABLE: 299
        VIEW: 279
        PROCEDURE: 278
        INDEX: 67
        FUNCTION: 12
        PK_UNIQUE: 4

- MSAJAG:
    status: OK
    objects_written: 9165
    elapsed_seconds: 7.52
    start_time: 2026-02-05T11:25:46.616456
    end_time: 2026-02-05T11:25:54.140258
    by_type:
        PROCEDURE: 4346
        TABLE: 3451
        INDEX: 647
        VIEW: 535
        PK_UNIQUE: 112
        TRIGGER: 40
        FUNCTION: 34

- MTFTRADE:
    status: OK
    objects_written: 561
    elapsed_seconds: 1.58
    start_time: 2026-02-05T11:25:54.140258
    end_time: 2026-02-05T11:25:55.718408
    by_type:
        PROCEDURE: 232
        TABLE: 201
        INDEX: 76
        CHECK: 22
        VIEW: 15
        PK_UNIQUE: 10
        FUNCTION: 4
        TRIGGER: 1

- NSESLBS:
    status: OK
    objects_written: 2366
    elapsed_seconds: 2.23
    start_time: 2026-02-05T11:25:55.718408
    end_time: 2026-02-05T11:25:57.952727
    by_type:
        PROCEDURE: 1133
        TABLE: 594
        INDEX: 395
        VIEW: 99
        PK_UNIQUE: 77
        FUNCTION: 40
        TRIGGER: 15
        FOREIGN_KEY: 12
        CHECK: 1

- PRADNYA:
    status: OK
    objects_written: 116
    elapsed_seconds: 0.8
    start_time: 2026-02-05T11:25:57.952727
    end_time: 2026-02-05T11:25:58.749759
    by_type:
        TABLE: 48
        PROCEDURE: 33
        FUNCTION: 17
        VIEW: 13
        PK_UNIQUE: 3
        INDEX: 2

- scratchpad:
    status: OK
    objects_written: 42
    elapsed_seconds: 0.98
    start_time: 2026-02-05T11:25:58.749759
    end_time: 2026-02-05T11:25:59.726196
    by_type:
        PROCEDURE: 31
        TABLE: 10
        VIEW: 1

Server totals (by object type):
--------------------------------
PROCEDURE: 8044
TABLE: 7052
INDEX: 1500
VIEW: 1071
PK_UNIQUE: 286
FUNCTION: 148
CHECK: 88
TRIGGER: 81
FOREIGN_KEY: 13

Total objects extracted: 18283

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
