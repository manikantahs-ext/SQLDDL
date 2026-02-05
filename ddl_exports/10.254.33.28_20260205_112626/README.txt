DDL Extraction README
Server: 10.254.33.28
Output folder: C:\Manikanta\ddl_exports\10.254.33.28_20260205_112626
Started: 2026-02-05T11:26:26.532889
Finished: 2026-02-05T11:26:41.249956
Elapsed seconds: 14.72

Databases processed: 14 (successful: 14, failures: 0)

Per-database details:
---------------------
- ACCOUNT_AB:
    status: OK
    objects_written: 1821
    elapsed_seconds: 1.43
    start_time: 2026-02-05T11:26:26.865341
    end_time: 2026-02-05T11:26:28.297016
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
    elapsed_seconds: 0.98
    start_time: 2026-02-05T11:26:28.297016
    end_time: 2026-02-05T11:26:29.281496
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
    elapsed_seconds: 0.84
    start_time: 2026-02-05T11:26:29.281496
    end_time: 2026-02-05T11:26:30.122008
    by_type:
        PROCEDURE: 9
        TABLE: 5
        INDEX: 4
        VIEW: 4

- BSEDB_AB:
    status: OK
    objects_written: 4015
    elapsed_seconds: 1.89
    start_time: 2026-02-05T11:26:30.122008
    end_time: 2026-02-05T11:26:32.010843
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
    elapsed_seconds: 0.93
    start_time: 2026-02-05T11:26:32.010843
    end_time: 2026-02-05T11:26:32.938182
    by_type:
        TABLE: 153
        PROCEDURE: 114
        VIEW: 32
        INDEX: 24
        PK_UNIQUE: 8
        FUNCTION: 1

- DBA_Admin:
    status: OK
    objects_written: 97
    elapsed_seconds: 0.9
    start_time: 2026-02-05T11:26:32.938182
    end_time: 2026-02-05T11:26:33.839526
    by_type:
        TABLE: 31
        PROCEDURE: 26
        PK_UNIQUE: 21
        INDEX: 11
        VIEW: 6
        FOREIGN_KEY: 1
        TRIGGER: 1

- Dustbin:
    status: OK
    objects_written: 118
    elapsed_seconds: 0.85
    start_time: 2026-02-05T11:26:33.839526
    end_time: 2026-02-05T11:26:34.688443
    by_type:
        TABLE: 111
        PROCEDURE: 4
        INDEX: 1
        PK_UNIQUE: 1
        VIEW: 1

- INHOUSE:
    status: OK
    objects_written: 302
    elapsed_seconds: 0.95
    start_time: 2026-02-05T11:26:34.688443
    end_time: 2026-02-05T11:26:35.637547
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
    elapsed_seconds: 0.83
    start_time: 2026-02-05T11:26:35.637547
    end_time: 2026-02-05T11:26:36.468565
    by_type:
        TABLE: 31
        PROCEDURE: 6
        VIEW: 4
        INDEX: 1

- MKTAPI:
    status: OK
    objects_written: 41
    elapsed_seconds: 0.76
    start_time: 2026-02-05T11:26:36.468565
    end_time: 2026-02-05T11:26:37.229286
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
    elapsed_seconds: 1.3
    start_time: 2026-02-05T11:26:37.229286
    end_time: 2026-02-05T11:26:38.531304
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
    elapsed_seconds: 1.34
    start_time: 2026-02-05T11:26:38.531304
    end_time: 2026-02-05T11:26:39.875159
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
    elapsed_seconds: 0.64
    start_time: 2026-02-05T11:26:39.875159
    end_time: 2026-02-05T11:26:40.510862
    by_type:
        INDEX: 12
        TABLE: 4
        PK_UNIQUE: 1
        VIEW: 1

- TestDB:
    status: OK
    objects_written: 0
    elapsed_seconds: 0.74
    start_time: 2026-02-05T11:26:40.510862
    end_time: 2026-02-05T11:26:41.249957
    by_type:
        <none>

Server totals (by object type):
--------------------------------
PROCEDURE: 5375
TABLE: 3769
VIEW: 944
INDEX: 504
PK_UNIQUE: 302
FUNCTION: 61
TRIGGER: 42
FOREIGN_KEY: 11
CHECK: 2

Total objects extracted: 11010

Failures summary:
-----------------
None

Notes:
- For any SQL execution failure, the SQL_PER_DB was saved to a file named like:
  failed_sql__<DB>__<timestamp>.sql
- Individual database .sql files (one per DB) are in this folder as <DB>.sql
- Central logger file(s) are located in: C:\Manikanta\central_logs
