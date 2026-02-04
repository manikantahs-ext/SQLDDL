DDL Extraction README
Server: 10.253.33.91
Output folder: C:\Manikanta\ddl_exports\10.253.33.91_20260205_023930
Started: 2026-02-05T02:39:30.652462
Finished: 2026-02-05T02:40:04.878794
Elapsed seconds: 34.23

Databases processed: 13 (successful: 13, failures: 0)

Per-database details:
---------------------
- ACCOUNT:
    status: OK
    objects_written: 3429
    elapsed_seconds: 3.31
    start_time: 2026-02-05T02:39:30.699334
    end_time: 2026-02-05T02:39:34.004379
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
    elapsed_seconds: 1.1
    start_time: 2026-02-05T02:39:34.004379
    end_time: 2026-02-05T02:39:35.100908
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
    elapsed_seconds: 0.56
    start_time: 2026-02-05T02:39:35.100908
    end_time: 2026-02-05T02:39:35.680053
    by_type:
        PK_UNIQUE: 1
        TABLE: 1

- AUDIT_DB:
    status: OK
    objects_written: 4
    elapsed_seconds: 0.58
    start_time: 2026-02-05T02:39:35.680053
    end_time: 2026-02-05T02:39:36.261276
    by_type:
        INDEX: 2
        TABLE: 2

- DBA_Admin:
    status: OK
    objects_written: 109
    elapsed_seconds: 0.69
    start_time: 2026-02-05T02:39:36.261276
    end_time: 2026-02-05T02:39:36.949301
    by_type:
        TABLE: 38
        PROCEDURE: 28
        PK_UNIQUE: 23
        INDEX: 11
        VIEW: 7
        FOREIGN_KEY: 1
        TRIGGER: 1

- Dustbin:
    status: OK
    objects_written: 870
    elapsed_seconds: 1.6
    start_time: 2026-02-05T02:39:36.949301
    end_time: 2026-02-05T02:39:38.548488
    by_type:
        TABLE: 735
        PROCEDURE: 93
        INDEX: 34
        PK_UNIQUE: 7
        VIEW: 1

- EventNotifications:
    status: OK
    objects_written: 6
    elapsed_seconds: 0.63
    start_time: 2026-02-05T02:39:38.548488
    end_time: 2026-02-05T02:39:39.174949
    by_type:
        PROCEDURE: 3
        PK_UNIQUE: 1
        TABLE: 1
        TRIGGER: 1

- INHOUSE:
    status: OK
    objects_written: 939
    elapsed_seconds: 1.53
    start_time: 2026-02-05T02:39:39.174949
    end_time: 2026-02-05T02:39:40.709076
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
    elapsed_seconds: 17.58
    start_time: 2026-02-05T02:39:40.709076
    end_time: 2026-02-05T02:39:58.293951
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
    elapsed_seconds: 0.99
    start_time: 2026-02-05T02:39:58.293951
    end_time: 2026-02-05T02:39:59.280792
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
    elapsed_seconds: 3.49
    start_time: 2026-02-05T02:39:59.280792
    end_time: 2026-02-05T02:40:02.772443
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
    elapsed_seconds: 0.69
    start_time: 2026-02-05T02:40:02.772443
    end_time: 2026-02-05T02:40:03.458691
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
    elapsed_seconds: 1.42
    start_time: 2026-02-05T02:40:03.458716
    end_time: 2026-02-05T02:40:04.878141
    by_type:
        PROCEDURE: 31
        TABLE: 10
        VIEW: 1

Server totals (by object type):
--------------------------------
PROCEDURE: 8043
TABLE: 7058
INDEX: 1502
VIEW: 1072
PK_UNIQUE: 288
FUNCTION: 147
CHECK: 88
TRIGGER: 81
FOREIGN_KEY: 13

Total objects extracted: 18292

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
