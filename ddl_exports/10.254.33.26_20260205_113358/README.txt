DDL Extraction README
Server: 10.254.33.26
Output folder: C:\Manikanta\ddl_exports\10.254.33.26_20260205_113358
Started: 2026-02-05T11:33:58.268492
Finished: 2026-02-05T11:34:16.102808
Elapsed seconds: 17.83

Databases processed: 12 (successful: 12, failures: 0)

Per-database details:
---------------------
- ACCOUNT:
    status: OK
    objects_written: 3429
    elapsed_seconds: 2.19
    start_time: 2026-02-05T11:33:58.644615
    end_time: 2026-02-05T11:34:00.830980
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
    elapsed_seconds: 1.32
    start_time: 2026-02-05T11:34:00.830980
    end_time: 2026-02-05T11:34:02.148574
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
    elapsed_seconds: 0.75
    start_time: 2026-02-05T11:34:02.148574
    end_time: 2026-02-05T11:34:02.895286
    by_type:
        PK_UNIQUE: 1
        TABLE: 1

- DBA_Admin:
    status: OK
    objects_written: 103
    elapsed_seconds: 1.05
    start_time: 2026-02-05T11:34:02.895304
    end_time: 2026-02-05T11:34:03.940355
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
    elapsed_seconds: 1.38
    start_time: 2026-02-05T11:34:03.940355
    end_time: 2026-02-05T11:34:05.316678
    by_type:
        TABLE: 736
        PROCEDURE: 93
        INDEX: 34
        PK_UNIQUE: 7
        VIEW: 1

- EventNotifications:
    status: OK
    objects_written: 6
    elapsed_seconds: 0.68
    start_time: 2026-02-05T11:34:05.316678
    end_time: 2026-02-05T11:34:05.998949
    by_type:
        PROCEDURE: 3
        PK_UNIQUE: 1
        TABLE: 1
        TRIGGER: 1

- Inhouse:
    status: OK
    objects_written: 939
    elapsed_seconds: 1.24
    start_time: 2026-02-05T11:34:05.998949
    end_time: 2026-02-05T11:34:07.242132
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
    elapsed_seconds: 4.47
    start_time: 2026-02-05T11:34:07.242132
    end_time: 2026-02-05T11:34:11.713588
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
    elapsed_seconds: 0.98
    start_time: 2026-02-05T11:34:11.713588
    end_time: 2026-02-05T11:34:12.692755
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
    elapsed_seconds: 1.84
    start_time: 2026-02-05T11:34:12.692755
    end_time: 2026-02-05T11:34:14.534550
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
    elapsed_seconds: 0.72
    start_time: 2026-02-05T11:34:14.534550
    end_time: 2026-02-05T11:34:15.252992
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
    elapsed_seconds: 0.85
    start_time: 2026-02-05T11:34:15.252992
    end_time: 2026-02-05T11:34:16.102808
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
