-- DDL Export
-- Server: 10.253.33.87
-- Database: IspaceScoreCard
-- Exported: 2026-02-05T12:29:50.696869

USE IspaceScoreCard;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.Proc_AUM_Summary
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Proc_AUM_Summary]  
(  
 @FDT DATETIME=NULL,  
 @TDT DATETIME=NULL  
)  
AS  
  
--IF OBJECT_ID('Ispc_Master_Scard_MthSeg_AUM_Summary','U') IS NOT NULL  
-- DROP TABLE Ispc_Master_Scard_MthSeg_AUM_Summary  
   
IF @Fdt IS NULL And @TDT IS NULL  
BEGIN  
   
 SET @Fdt= convert(varchar(11),getdate())+ ' 00:00:00'  
 SET @TDT= convert(varchar(11),getdate())+ ' 23:59:59'
   
END  
  
SELECT   A.Party_code,RMS_Date=CONVERT(VARCHAR(11),RMS_Date,106),--RMS_Date=(SELECT CONVERT(VARCHAR(11),MAX(RMS_DATE),106) FROM RMS_DTCLFI WITH(NOLOCK)),   
   Segment=A.Co_code,  
   A.Ledger,A.Cash_Colleteral,NonCashCollateral=ISNULL(C.NonCashCollateral,0),  
   Holding=A.Holding_total,  
   UnbookedLoss_Options = UBLOSS ,  
   DP_Holding,  
   POAStatus = CASE WHEN D.Party_code IS NULL THEN 'Inactive' ELSE 'Active' END,  
   B.NBFC_CLI,  
   [FROM DATE] = @Fdt,  
   [TO DATE] = @TDT  
INTO #SegmentAxmlate_History  
FROM             
(  
   SELECT  P.Party_code,--RMS_Date=CONVERT(VARCHAR(11),A.LastBillDate,106),  
     RMS_Date = MAX(Z.RMS_Date),               
     P.Co_code,  
     P.Ledger,P.Cash_Colleteral,--C.NonCashCollateral,  
     P.Holding_total,UBLOSS = (P.MTM_Loss_Act+P.MTM_Profit_Act),DP_Holding=0  
   FROM General.dbo.RMS_DTCLFI P WITH(NOLOCK)   
   INNER JOIN [History].dbo.RMS_DTCLFI Z  
    ON P.Party_code = Z.Party_code AND P.Co_code = z.Co_code AND P.Ledger = Z.Ledger  
       AND P.Cash_Colleteral = Z.Cash_Colleteral  
   WHERE  Z.RMS_Date BETWEEN @Fdt AND @TDT        
   GROUP BY P.Party_code,P.Co_code,P.Ledger,P.Cash_Colleteral,P.Holding_total,P.MTM_Loss_Act,P.MTM_Profit_Act  
   
   
   UNION ALL  
   
   SELECT  Party_Code,0 RMS_Date ,CO_CODE = 'DP',Ledger=0,Cash_Collateral=0,Holding_total = 0,MTM_Loss_Act=0,  
     SUM(total) DP_Holding  
   FROM General.dbo.rms_Holding WITH(NOLOCK)  
   WHERE source = 'DP'   
   GROUP BY  party_Code,upd_date  
) A  
INNER JOIN General.dbo.CLIENT_DETAILS B WITH(NOLOCK)  
 ON A.Party_code = B.party_Code  
LEFT JOIN(  
   SELECT  Party_Code,CO_CODE,NonCashCollateral = SUM(CASE WHEN CASH_NCASH = 'N' THEN AMOUNT ELSE 0 END)  
   FROM General.dbo.CLIENT_COLLATERALS WITH(NOLOCK)  
   GROUP BY Party_Code,CO_CODE  
   )C  
 ON A.Party_code = C.party_Code AND A.CO_CODE = C.CO_CODE  
LEFT JOIN General.dbo.Tbl_NewPOA D WITH(NOLOCK)  
 ON A.Party_code = D.party_Code  
ORDER BY Party_Code  
  
;With CTE_Temp  
AS  
(  
   Select Party_code,Segment,Ledger,Cash_Colleteral,NonCashCollateral,Holding,Unbookedloss_options,  
    DP_Holding,poastatus,  
    Startofmonth=CAST(DATEADD(mm,DATEDIFF(mm,0,[From Date]),0) AS DATETIME),  
    Countp=CASE WHEN DATEDIFF(D,[FROM DATE],[TO DATE])>0 THEN DATEDIFF(D,[FROM DATE],[TO DATE])  
       ELSE 1  
     END  
   From #SegmentAxmlate_History  
)  
Select   Startofmonth,Party_code,Segment,  
   SUM(Ledger)/SUM(countp)                        AS ledger, -- Cash Net Value  
   SUM(Cash_Colleteral)/SUM(countp)    AS Cash_Colleteral, -- FD Security  
   SUM(NonCashCollateral)/SUM(countp)    AS NonCashCollateral, -- Non Cash Security/Collateral  
   SUM(Holding)/SUM(countp)                       AS Holding, -- Angel's Pool Account Holing i.e. Stocks of Clients     
   SUM(Unbookedloss_options)/SUM(countp)   As Unbookedloss_options,   
   SUM(DP_Holding)/SUM(countp)                    AS DP_Holding,  
   SUM(Ledger+Cash_Colleteral+NonCashCollateral+Holding+Unbookedloss_options+DP_Holding)/SUM(countp) [AUM_Overall],  
   SUM(Ledger+Cash_Colleteral+NonCashCollateral+Holding+Unbookedloss_options+  
   CASE WHEN poastatus ='Active'     THEN DP_Holding ELSE 0 END)/SUM(countp) AS AUM_WithActiveDp,  
   SUM(CASE WHEN poastatus ='Active' THEN DP_Holding ELSE 0 END)/SUM(countp) AS ActiveDP,  
   SUM(Countp) [Days_Cnt]  
INTO #AUM_Summary  
From CTE_Temp  
Group By Party_code,Startofmonth,Segment  
  
TRUNCATE TABLE Ispc_Master_Scard_MthSeg_AUM_Summary  

INSERT INTO Ispc_Master_Scard_MthSeg_AUM_Summary  
Select *  From #AUM_Summary

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

-- --------------------------------------------------
-- TABLE dbo.Ispc_Master_Scard_MthSeg_AUM_Summary
-- --------------------------------------------------
CREATE TABLE [dbo].[Ispc_Master_Scard_MthSeg_AUM_Summary]
(
    [Startofmonth] DATETIME NULL,
    [Party_code] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [ledger] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCashCollateral] MONEY NULL,
    [Holding] MONEY NULL,
    [Unbookedloss_options] MONEY NULL,
    [DP_Holding] MONEY NULL,
    [AUM_Overall] MONEY NULL,
    [AUM_WithActiveDp] MONEY NULL,
    [ActiveDP] MONEY NULL,
    [Days_Cnt] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_SBDeposite
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_SBDeposite]
(
    [Client] NVARCHAR(255) NULL
);

GO

