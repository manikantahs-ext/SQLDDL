DDL Extraction README
Server: 10.253.33.94
Output folder: C:\Manikanta\ddl_exports\10.253.33.94_20260205_024023
Started: 2026-02-05T02:40:23.520477
Finished: 2026-02-05T02:40:27.484558
Elapsed seconds: 3.96

Databases processed: 13 (successful: 13, failures: 0)

Per-database details:
---------------------
- ACCOUNT_AB:
    status: OK
    objects_written: 1821
    elapsed_seconds: 0.68
    start_time: 2026-02-05T02:40:23.551729
    end_time: 2026-02-05T02:40:24.236423
    by_type:
        PROCEDURE: 956
        TABLE: 614
        VIEW: 104
        INDEX: 89
        PK_UNIQUE: 25
        FUNCTION: 18
        TRIGGER: 14
        CHECK: 1

- ACCOUNTBFO:
    status: OK
    objects_written: 250
    elapsed_seconds: 0.11
    start_time: 2026-02-05T02:40:24.236423
    end_time: 2026-02-05T02:40:24.350322
    by_type:
        TABLE: 137
        PROCEDURE: 98
        VIEW: 5
        INDEX: 4
        FUNCTION: 3
        TRIGGER: 2
        CHECK: 1

- APIDetails:
    status: OK
    objects_written: 22
    elapsed_seconds: 0.03
    start_time: 2026-02-05T02:40:24.350322
    end_time: 2026-02-05T02:40:24.381573
    by_type:
        PROCEDURE: 9
        TABLE: 5
        INDEX: 4
        VIEW: 4

- BSEDB_AB:
    status: OK
    objects_written: 4015
    elapsed_seconds: 1.02
    start_time: 2026-02-05T02:40:24.381573
    end_time: 2026-02-05T02:40:25.399764
    by_type:
        PROCEDURE: 2079
        TABLE: 1066
        VIEW: 365
        INDEX: 251
        PK_UNIQUE: 214
        TRIGGER: 22
        FUNCTION: 18

- BSEFO:
    status: OK
    objects_written: 332
    elapsed_seconds: 0.16
    start_time: 2026-02-05T02:40:25.399764
    end_time: 2026-02-05T02:40:25.555934
    by_type:
        TABLE: 153
        PROCEDURE: 114
        VIEW: 32
        INDEX: 24
        PK_UNIQUE: 8
        FUNCTION: 1

- DBA_Admin:
    status: OK
    objects_written: 100
    elapsed_seconds: 0.58
    start_time: 2026-02-05T02:40:25.555934
    end_time: 2026-02-05T02:40:26.135564
    by_type:
        TABLE: 33
        PROCEDURE: 27
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        TRIGGER: 1

- Dustbin:
    status: OK
    objects_written: 118
    elapsed_seconds: 0.09
    start_time: 2026-02-05T02:40:26.135564
    end_time: 2026-02-05T02:40:26.229740
    by_type:
        TABLE: 111
        PROCEDURE: 4
        INDEX: 1
        PK_UNIQUE: 1
        VIEW: 1

- INHOUSE:
    status: OK
    objects_written: 302
    elapsed_seconds: 0.27
    start_time: 2026-02-05T02:40:26.229740
    end_time: 2026-02-05T02:40:26.496971
    by_type:
        TABLE: 141
        PROCEDURE: 116
        VIEW: 12
        INDEX: 11
        PK_UNIQUE: 9
        FOREIGN_KEY: 8
        FUNCTION: 5

- INHOUSE_BFO:
    status: OK
    objects_written: 42
    elapsed_seconds: 0.05
    start_time: 2026-02-05T02:40:26.496971
    end_time: 2026-02-05T02:40:26.543773
    by_type:
        TABLE: 31
        PROCEDURE: 6
        VIEW: 4
        INDEX: 1

- MKTAPI:
    status: OK
    objects_written: 41
    elapsed_seconds: 0.05
    start_time: 2026-02-05T02:40:26.543773
    end_time: 2026-02-05T02:40:26.591148
    by_type:
        TABLE: 15
        PROCEDURE: 12
        PK_UNIQUE: 5
        TRIGGER: 3
        FOREIGN_KEY: 2
        INDEX: 2
        VIEW: 2

- MSAJAG:
    status: OK
    objects_written: 2637
    elapsed_seconds: 0.52
    start_time: 2026-02-05T02:40:26.591148
    end_time: 2026-02-05T02:40:27.107116
    by_type:
        PROCEDURE: 1852
        VIEW: 388
        TABLE: 315
        INDEX: 67
        PK_UNIQUE: 13
        FUNCTION: 2

- PRADNYA:
    status: OK
    objects_written: 1315
    elapsed_seconds: 0.35
    start_time: 2026-02-05T02:40:27.107116
    end_time: 2026-02-05T02:40:27.453309
    by_type:
        TABLE: 1146
        PROCEDURE: 103
        INDEX: 27
        VIEW: 20
        FUNCTION: 14
        PK_UNIQUE: 5

- ReplicatedData:
    status: OK
    objects_written: 18
    elapsed_seconds: 0.03
    start_time: 2026-02-05T02:40:27.453309
    end_time: 2026-02-05T02:40:27.484558
    by_type:
        INDEX: 12
        TABLE: 4
        PK_UNIQUE: 1
        VIEW: 1

Server totals (by object type):
--------------------------------
PROCEDURE: 5376
TABLE: 3771
VIEW: 944
INDEX: 504
PK_UNIQUE: 302
FUNCTION: 61
TRIGGER: 42
FOREIGN_KEY: 11
CHECK: 2

Total objects extracted: 11013

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
