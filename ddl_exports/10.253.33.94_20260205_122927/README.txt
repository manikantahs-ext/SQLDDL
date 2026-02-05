DDL Extraction README
Server: 10.253.33.94
Output folder: C:\Manikanta\ddl_exports\10.253.33.94_20260205_122927
Started: 2026-02-05T12:29:27.338266
Finished: 2026-02-05T12:29:29.681877
Elapsed seconds: 2.34

Databases processed: 13 (successful: 13, failures: 0)

Per-database details:
---------------------
- ACCOUNT_AB:
    status: OK
    objects_written: 1821
    elapsed_seconds: 0.35
    start_time: 2026-02-05T12:29:27.345794
    end_time: 2026-02-05T12:29:27.697691
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
    elapsed_seconds: 0.09
    start_time: 2026-02-05T12:29:27.697691
    end_time: 2026-02-05T12:29:27.790326
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
    start_time: 2026-02-05T12:29:27.790326
    end_time: 2026-02-05T12:29:27.822052
    by_type:
        PROCEDURE: 9
        TABLE: 5
        INDEX: 4
        VIEW: 4

- BSEDB_AB:
    status: OK
    objects_written: 4015
    elapsed_seconds: 0.8
    start_time: 2026-02-05T12:29:27.822052
    end_time: 2026-02-05T12:29:28.620610
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
    elapsed_seconds: 0.12
    start_time: 2026-02-05T12:29:28.620610
    end_time: 2026-02-05T12:29:28.744521
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
    elapsed_seconds: 0.07
    start_time: 2026-02-05T12:29:28.744521
    end_time: 2026-02-05T12:29:28.811045
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
    start_time: 2026-02-05T12:29:28.811045
    end_time: 2026-02-05T12:29:28.900760
    by_type:
        TABLE: 111
        PROCEDURE: 4
        INDEX: 1
        PK_UNIQUE: 1
        VIEW: 1

- INHOUSE:
    status: OK
    objects_written: 302
    elapsed_seconds: 0.12
    start_time: 2026-02-05T12:29:28.900760
    end_time: 2026-02-05T12:29:29.017298
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
    start_time: 2026-02-05T12:29:29.017298
    end_time: 2026-02-05T12:29:29.064733
    by_type:
        TABLE: 31
        PROCEDURE: 6
        VIEW: 4
        INDEX: 1

- MKTAPI:
    status: OK
    objects_written: 41
    elapsed_seconds: 0.03
    start_time: 2026-02-05T12:29:29.064733
    end_time: 2026-02-05T12:29:29.096477
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
    elapsed_seconds: 0.3
    start_time: 2026-02-05T12:29:29.096477
    end_time: 2026-02-05T12:29:29.400744
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
    elapsed_seconds: 0.25
    start_time: 2026-02-05T12:29:29.400744
    end_time: 2026-02-05T12:29:29.650627
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
    start_time: 2026-02-05T12:29:29.650627
    end_time: 2026-02-05T12:29:29.681878
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
