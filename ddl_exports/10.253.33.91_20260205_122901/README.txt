DDL Extraction README
Server: 10.253.33.91
Output folder: C:\Manikanta\ddl_exports\10.253.33.91_20260205_122901
Started: 2026-02-05T12:29:01.811113
Finished: 2026-02-05T12:29:19.275842
Elapsed seconds: 17.46

Databases processed: 13 (successful: 13, failures: 0)

Per-database details:
---------------------
- ACCOUNT:
    status: OK
    objects_written: 3429
    elapsed_seconds: 2.78
    start_time: 2026-02-05T12:29:01.874524
    end_time: 2026-02-05T12:29:04.650629
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
    elapsed_seconds: 0.5
    start_time: 2026-02-05T12:29:04.650629
    end_time: 2026-02-05T12:29:05.150433
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
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:29:05.150433
    end_time: 2026-02-05T12:29:05.181683
    by_type:
        PK_UNIQUE: 1
        TABLE: 1

- AUDIT_DB:
    status: OK
    objects_written: 4
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:29:05.181683
    end_time: 2026-02-05T12:29:05.212934
    by_type:
        INDEX: 2
        TABLE: 2

- DBA_Admin:
    status: OK
    objects_written: 109
    elapsed_seconds: 0.66
    start_time: 2026-02-05T12:29:05.212934
    end_time: 2026-02-05T12:29:05.869295
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
    objects_written: 871
    elapsed_seconds: 0.67
    start_time: 2026-02-05T12:29:05.869295
    end_time: 2026-02-05T12:29:06.541747
    by_type:
        TABLE: 736
        PROCEDURE: 93
        INDEX: 34
        PK_UNIQUE: 7
        VIEW: 1

- EventNotifications:
    status: OK
    objects_written: 6
    elapsed_seconds: 0.05
    start_time: 2026-02-05T12:29:06.541747
    end_time: 2026-02-05T12:29:06.589580
    by_type:
        PROCEDURE: 3
        PK_UNIQUE: 1
        TABLE: 1
        TRIGGER: 1

- INHOUSE:
    status: OK
    objects_written: 939
    elapsed_seconds: 0.86
    start_time: 2026-02-05T12:29:06.589580
    end_time: 2026-02-05T12:29:07.444813
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
    elapsed_seconds: 9.42
    start_time: 2026-02-05T12:29:07.444813
    end_time: 2026-02-05T12:29:16.869549
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
    elapsed_seconds: 0.44
    start_time: 2026-02-05T12:29:16.869549
    end_time: 2026-02-05T12:29:17.314169
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
    elapsed_seconds: 1.73
    start_time: 2026-02-05T12:29:17.314169
    end_time: 2026-02-05T12:29:19.048274
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
    elapsed_seconds: 0.11
    start_time: 2026-02-05T12:29:19.048274
    end_time: 2026-02-05T12:29:19.159261
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
    elapsed_seconds: 0.11
    start_time: 2026-02-05T12:29:19.159261
    end_time: 2026-02-05T12:29:19.269804
    by_type:
        PROCEDURE: 31
        TABLE: 10
        VIEW: 1

Server totals (by object type):
--------------------------------
PROCEDURE: 8043
TABLE: 7059
INDEX: 1502
VIEW: 1072
PK_UNIQUE: 288
FUNCTION: 147
CHECK: 88
TRIGGER: 81
FOREIGN_KEY: 13

Total objects extracted: 18293

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
