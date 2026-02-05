-- DDL Export
-- Server: 10.253.33.87
-- Database: Archival_Stage
-- Exported: 2026-02-05T12:29:46.823624

USE Archival_Stage;
GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_COMPANYWISE_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxcol] ON [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST] ([UPDATE_DATE])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------
/*

Proc Created by Amit kumar Bhatta on 27th feb 2013 for rebuilding the indexes of database passed as paremeter for the proc.

*/
create procedure [dbo].[rebuild_index]
@database varchar(100)
as
begin

declare @db_id int
Select @db_id = db_id(@database) 

if @db_id is Null
return

SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.

SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        IF @frag < 30.0
            SET @command = N'use '+@database + N' ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @frag >= 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
        IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;

end

GO

-- --------------------------------------------------
-- TABLE dbo.ALG_FINALLIMIT_COMPANYWISE_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST]
(
    [ZONE] VARCHAR(25) NULL,
    [REGION] VARCHAR(20) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CLIENT_CATEGORY] VARCHAR(10) NULL,
    [CLIENT_TYPE] VARCHAR(10) NULL,
    [CL_TYPE] VARCHAR(10) NULL,
    [SB_CATEGORY] VARCHAR(10) NULL,
    [ALM] DECIMAL(15, 2) NULL,
    [ALM_HLD_COLL] BIT NULL,
    [EQDECR] DECIMAL(15, 2) NULL,
    [OPLM] DECIMAL(15, 2) NULL,
    [COLM] DECIMAL(15, 2) NULL,
    [COLM_NBFC] DECIMAL(15, 2) NULL,
    [LMT_HLD_COLL] BIT NULL,
    [COLM_HLD_COLL] BIT NULL,
    [OPLM_HLD_COLL] BIT NULL,
    [HLD_COLL_HC_BLUECHIP] INT NULL,
    [HLD_COLL_HC_GOOD] INT NULL,
    [HLD_COLL_HC_AVERAGE] INT NULL,
    [HLD_COLL_HC_POOR] INT NULL,
    [MTM_LMT_PERC] DECIMAL(19, 6) NULL,
    [POA_ALLOWED] BIT NULL,
    [RISK_GRT_MIN_LMT] DECIMAL(15, 2) NULL,
    [BLOCK_MIN_LMT] BIT NULL,
    [MIN_LIM_EQDECR] DECIMAL(15, 2) NULL,
    [MIN_LIM_COLM] DECIMAL(15, 2) NULL,
    [MIN_LIM_COLM_NBFC] DECIMAL(15, 2) NULL,
    [MIN_LIM_ALLEXC] DECIMAL(15, 2) NULL,
    [UN_RECO_CR_LMT] BIT NULL,
    [UN_RECO_LIMIT] DECIMAL(15, 2) NULL,
    [DEF_QTY] INT NULL,
    [DEF_VAL] DECIMAL(15, 2) NULL,
    [ALLExch_ALLOW_UNRECO_CR] BIT NULL,
    [ABL_ALLOW_UNRECO_CR] BIT NULL,
    [ACBPL_ALLOW_UNRECO_CR] BIT NULL,
    [BSE_LEDGER] MONEY NOT NULL,
    [NSE_LEDGER] MONEY NOT NULL,
    [NSEFO_LEDGER] MONEY NOT NULL,
    [BSEFO_LEDGER] MONEY NOT NULL,
    [MCD_LEDGER] MONEY NOT NULL,
    [NSX_LEDGER] MONEY NOT NULL,
    [MCX_LEDGER] MONEY NOT NULL,
    [NCDEX_LEDGER] MONEY NOT NULL,
    [NBFC_LEDGER] MONEY NOT NULL,
    [NET_LEDGER] MONEY NOT NULL,
    [BSE_DEPOSIT] MONEY NOT NULL,
    [NSE_DEPOSIT] MONEY NOT NULL,
    [NSEFO_DEPOSIT] MONEY NOT NULL,
    [BSEFO_DEPOSIT] MONEY NOT NULL,
    [MCD_DEPOSIT] MONEY NOT NULL,
    [NSX_DEPOSIT] MONEY NOT NULL,
    [MCX_DEPOSIT] MONEY NOT NULL,
    [NCDEX_DEPOSIT] MONEY NOT NULL,
    [NBFC_DEPOSIT] MONEY NOT NULL,
    [NET_DEPOSIT] MONEY NOT NULL,
    [BSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [BSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [MCD_UNRECO_CREDIT] MONEY NOT NULL,
    [NSX_UNRECO_CREDIT] MONEY NOT NULL,
    [MCX_UNRECO_CREDIT] MONEY NOT NULL,
    [NCDEX_UNRECO_CREDIT] MONEY NOT NULL,
    [NBFC_UNRECO_CREDIT] MONEY NOT NULL,
    [NET_UNRECO_CREDIT] MONEY NOT NULL,
    [HOLD_BLUECHIP] MONEY NULL,
    [HOLD_GOOD] MONEY NULL,
    [HOLD_POOR] MONEY NULL,
    [HOLD_JUNK] MONEY NULL,
    [HOLD_TOTAL] MONEY NULL,
    [HOLD_TOTAL_WO_HC] MONEY NULL,
    [HOLD_TOTAL_NEGATIVE] MONEY NULL,
    [NBFC_HOLD_TOTAL] MONEY NULL,
    [NBFC_HOLD_WO_HC] MONEY NULL,
    [COLL_NSEFO] MONEY NOT NULL,
    [COLL_BSEFO] MONEY NOT NULL,
    [COLL_MCD] MONEY NOT NULL,
    [COLL_NSX] MONEY NOT NULL,
    [COLL_MCX] MONEY NOT NULL,
    [COLL_NCDEX] MONEY NOT NULL,
    [COLL_TOTAL] MONEY NOT NULL,
    [ABL_COLL_TOTAL_WO_HC] MONEY NULL,
    [ACBPL_COLL_TOTAL_WO_HC] MONEY NULL,
    [CASH_COLL_NSEFO] MONEY NOT NULL,
    [CASH_COLL_BSEFO] MONEY NOT NULL,
    [CASH_COLL_MCD] MONEY NOT NULL,
    [CASH_COLL_NSX] MONEY NOT NULL,
    [CASH_COLL_MCX] MONEY NOT NULL,
    [CASH_COLL_NCDEX] MONEY NOT NULL,
    [CASHCOLL_TOTAL] MONEY NOT NULL,
    [PURE_RISK] MONEY NOT NULL,
    [POA] MONEY NOT NULL,
    [POA_WO_HC] MONEY NULL,
    [ALLExch_LIMITVALUE] MONEY NULL,
    [ABL_LIMITVALUE] MONEY NULL,
    [ACBPL_LIMITVALUE] MONEY NULL,
    [ALLExch_LIMITVALUE_WO_HC] MONEY NULL,
    [ABL_LIMITVALUE_WO_HC] MONEY NULL,
    [ACBPL_LIMITVALUE_WO_HC] MONEY NULL,
    [ALLExch_FINAL_LIMITVALUE] MONEY NULL,
    [EQ_FINAL_LIMITVALUE] MONEY NULL,
    [CURR_FINAL_LIMITVALUE] MONEY NULL,
    [COMMO_FINAL_LIMITVALUE] MONEY NULL,
    [MASTER_SETTING] VARCHAR(100) NULL,
    [UPDATE_DATE] DATETIME NOT NULL,
    [ACTIVITIES] VARCHAR(40) NULL,
    [INSERTDATE] DATETIME NOT NULL,
    [ArchivedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.day_defination_change
-- --------------------------------------------------
CREATE TABLE [dbo].[day_defination_change]
(
    [object_name] NVARCHAR(128) NOT NULL,
    [schema_name] NVARCHAR(128) NULL,
    [type_desc] NVARCHAR(60) NULL,
    [create_date] DATETIME NOT NULL,
    [modify_date] DATETIME NOT NULL
);

GO

