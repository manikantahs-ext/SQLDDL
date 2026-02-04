-- DDL Export
-- Server: 10.253.33.87
-- Database: Mimansa
-- Exported: 2026-02-05T02:38:21.537019

USE Mimansa;
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
-- PROCEDURE dbo.usp_CalculateSecMarginOnDPHolding
-- --------------------------------------------------
CREATE proc [dbo].[usp_CalculateSecMarginOnDPHolding]
@FromDate varchar(11), 
@ToDate varchar(30)

as
/*
exec usp_CalculateSecMarginOnDPHolding @FromDate = 'Jan 01 2014', @ToDate = 'Jun  2 2014 23:59'

*/

BEGIN

	Declare @FromDate_1 varchar(11), @ToDate_1 varchar(30)

	if(@FromDate = '' )
		set @FromDate_1 = 'Apr 01 2014'
	else
		set @FromDate_1 = @FromDate

	
	if(@ToDate = '' )
		set @ToDate_1 = convert(varchar(11),getdate(), 109) + ' 23:59'
	else
		set @ToDate_1 = @ToDate -- + ' 23:59'
	
	--return	
	--DROP TABLE #temp
	SELECT A.Party_code, ReportDate = cast(convert(varchar(11), max(upd_date),109) as smalldatetime),M.ActivefromEq 
	into #temp
	from mimansa.CRM.dbo.AngelclientMarginDetails_allseg m with (nolock) left outer join History.DBO.RMS_HOLDING (NOLOCK) A
	on A.Party_code = M.Party_code
	Where m.ActivefromEq between @FromDate_1 and @ToDate_1 and Exchangesegment = 'EQUITY' and  isnull(OldCode,'') = ''
	and upd_date  < Dateadd(d,16,Cast(m.ActivefromEq as Datetime))
	Group by A.Party_code,M.ActivefromEq
		
	--drop table #TempDPHolding
	select t.party_code,ActivefromEq,ReportDate, isin, scrip_cd,Scripname,upd_date,bs, exchange, qty, clsrate,Total,SHRT_HC,HairCut, ExchangeHairCut, total_withHC  
	into #TempDPHolding
	from #temp t, (select A.isin, scrip_cd, scripname, party_code,upd_date,bs, a.exchange, qty, clsrate,Total,Q.SHRT_HC,
					HairCut=(  
							CASE WHEN A.EXCHANGE = 'BSECM'   
									THEN ISNULL(B.BSE_PROJ_VAR, 100)            
									WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
									THEN ISNULL(B.NSE_PROJ_VAR, 100)            
									ELSE 100            
							END) ,
						ExchangeHairCut=(  
								CASE WHEN A.EXCHANGE = 'BSECM'   
										THEN ISNULL(B.BSE_VAR, 100)            
										WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
										THEN ISNULL(B.NSE_VAR, 100)  
										ELSE 100  
								END)  ,  
						total_WithHC=            
						CASE WHEN A.QTY > 0   
								THEN (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))-((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*((  
									CASE WHEN A.EXCHANGE = 'BSECM'   
											THEN ISNULL(B.BSE_PROJ_VAR, 100)            
											WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
											THEN ISNULL(B.NSE_PROJ_VAR, 100)            
											ELSE 100            
									END)/100.00))            
							ELSE (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))+((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*(ISNULL(Q.SHRT_HC,100.00)/100.00))            
						END   
					from History.DBO.RMS_HOLDING (NOLOCK) A INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q   
					ON A.EXCHANGE=Q.CO_CODE LEFT OUTER JOIN  GENERAL.DBO.SCRIPVAR_MASTER (NOLOCK) B  ON A.ISIN=B.ISIN   
					) h
	where t.Party_code = h.party_code AND t.ReportDate = convert(varchar(11), upd_date ,109)
 
	truncate table AngelClientDPSecMarginDetails

	insert into AngelClientDPSecMarginDetails
	SELECT *, LogDate = getdate() from #TempDPHolding 
	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CalculateSecMarginOnDPHolding_temp02Jun
-- --------------------------------------------------
CREATE proc [dbo].[usp_CalculateSecMarginOnDPHolding_temp02Jun]
@FromDate varchar(11), 
@ToDate varchar(30)

as
/*
exec usp_CalculateSecMarginOnDPHolding_temp02Jun @FromDate = 'Apr 01 2014', @ToDate = 'Jun  2 2014 23:59'
select  * from History.DBO.RMS_HOLDING (NOLOCK) where Party_code='M81126' order by upd_date,scripname desc
select  top 10 * from GENERAL.DBO.SCRIPVAR_MASTER (NOLOCK) where ISIN='INE614G01033' order by crtdt desc
*/

BEGIN

	Declare @@FromDate_1 varchar(11), @@ToDate_1 varchar(30)

	if(@FromDate = '' )
		set @@FromDate_1 = 'Apr 01 2014'
	else
		set @@FromDate_1 = @FromDate

	
	if(@ToDate = '' )
		set @@ToDate_1 = convert(varchar(11),getdate(), 109) + ' 23:59'
	else
		set @@ToDate_1 = @ToDate -- + ' 23:59'
	
	--return	
	--DROP TABLE #temp
	/*SELECT A.Party_code, ReportDate = cast(convert(varchar(11), max(upd_date),109) as smalldatetime),M.ActivefromEq 
	into #temp
	from mimansa.CRM.dbo.AngelclientMarginDetails_allseg m with (nolock) left outer join History.DBO.RMS_HOLDING (NOLOCK) A
	on A.Party_code = M.Party_code
	Where m.ActivefromEq between @FromDate_1 and @ToDate_1 and Exchangesegment = 'EQUITY' and  isnull(OldCode,'') = ''
	and upd_date  < Dateadd(d,16,Cast(m.ActivefromEq as Datetime))
	Group by A.Party_code,M.ActivefromEq*/

	select Party_code,ActivefromEq,ActivefromEq16= Dateadd(d,16,m.ActivefromEq )
	into #MarginTemp
	 from mimansa.CRM.dbo.AngelclientMarginDetails_allseg m with(nolock)
	where  m.ActivefromEq >= @@FromDate_1 
	and m.ActivefromEq<=@@ToDate_1 
	and Exchangesegment = 'EQUITY' and  isnull(OldCode,'') = ''

	SELECT m.Party_code, ReportDate =upd_date--max(upd_date)-- cast(convert(varchar(11), max(upd_date),109) as smalldatetime),
	,M.ActivefromEq 
	into #temp1
	from #MarginTemp m with (nolock) inner join History.DBO.RMS_HOLDING A with (nolock)
	on m.Party_code = a.Party_code
	Where upd_date  < ActivefromEq16

	select Party_code,ActivefromEq,ReportDate=cast(convert(varchar(11), max(ReportDate),109) as smalldatetime)
		into #temp
		from #temp1
		Group by Party_code,ActivefromEq
		
	--drop table #TempDPHolding
	select t.party_code,ActivefromEq,ReportDate, isin, scrip_cd,Scripname,upd_date,bs, exchange, qty, clsrate,Total,SHRT_HC,HairCut, ExchangeHairCut, total_withHC  
	into #TempDPHolding
	from #temp t, (select A.isin, scrip_cd, scripname, party_code,upd_date,bs, a.exchange, qty, clsrate,Total,Q.SHRT_HC,
					HairCut=(  
							CASE WHEN A.EXCHANGE = 'BSECM'   
									THEN ISNULL(B.BSE_PROJ_VAR, 100)            
									WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
									THEN ISNULL(B.NSE_PROJ_VAR, 100)            
									ELSE 100            
							END) ,
						ExchangeHairCut=(  
								CASE WHEN A.EXCHANGE = 'BSECM'   
										THEN ISNULL(B.BSE_VAR, 100)            
										WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
										THEN ISNULL(B.NSE_VAR, 100)  
										ELSE 100  
								END)  ,  
						total_WithHC=            
						CASE WHEN A.QTY > 0   
								THEN (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))-((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*((  
									CASE WHEN A.EXCHANGE = 'BSECM'   
											THEN ISNULL(B.BSE_PROJ_VAR, 100)            
											WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
											THEN ISNULL(B.NSE_PROJ_VAR, 100)            
											ELSE 100            
									END)/100.00))            
							ELSE (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))+((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*(ISNULL(Q.SHRT_HC,100.00)/100.00))            
						END   
					from History.DBO.RMS_HOLDING (NOLOCK) A INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q   
					ON A.EXCHANGE=Q.CO_CODE LEFT OUTER JOIN  GENERAL.DBO.SCRIPVAR_MASTER (NOLOCK) B  ON A.ISIN=B.ISIN   
					) h
	where t.Party_code = h.party_code AND t.ReportDate = convert(varchar(11), upd_date ,109)
 
	truncate table AngelClientDPSecMarginDetails

	insert into AngelClientDPSecMarginDetails
	SELECT *, LogDate = getdate() from #TempDPHolding 
	--	SELECT count( * ) from #TempDPHolding 
	--SELECT top 10 * from #TempDPHolding 
	
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_CalculateSecMarginOnDPHolding_temp24Jun
-- --------------------------------------------------
CREATE proc [dbo].[usp_CalculateSecMarginOnDPHolding_temp24Jun]
@FromDate varchar(11), 
@ToDate varchar(30)

as
/*
exec usp_CalculateSecMarginOnDPHolding_temp24Jun @FromDate = 'Apr 01 2014', @ToDate = 'Jun 25 2014 23:59'
select  * from History.DBO.RMS_HOLDING (NOLOCK) where Party_code='M81126' order by upd_date,scripname asc
select  top 10 * from GENERAL.DBO.SCRIPVAR_MASTER (NOLOCK) where ISIN='INE614G01033' order by crtdt desc
select top 10 * from GENERAL.DBO.COMPANY where CO_CODE='NSECM'

*/

BEGIN

Declare @@FromDate_1 varchar(11), @@ToDate_1 varchar(30)

	if(@FromDate = '' )
		set @@FromDate_1 = 'Apr 01 2014'
	else
		set @@FromDate_1 = @FromDate

	
	if(@ToDate = '' )
		set @@ToDate_1 = convert(varchar(11),getdate(), 109) + ' 23:59'
	else
		set @@ToDate_1 = @ToDate -- + ' 23:59'
	
	--return	
	--DROP TABLE #temp
	/*SELECT A.Party_code, ReportDate = cast(convert(varchar(11), max(upd_date),109) as smalldatetime),M.ActivefromEq 
	into #temp
	from mimansa.CRM.dbo.AngelclientMarginDetails_allseg m with (nolock) left outer join History.DBO.RMS_HOLDING (NOLOCK) A
	on A.Party_code = M.Party_code
	Where m.ActivefromEq between @FromDate_1 and @ToDate_1 and Exchangesegment = 'EQUITY' and  isnull(OldCode,'') = ''
	and upd_date  < Dateadd(d,16,Cast(m.ActivefromEq as Datetime))
	Group by A.Party_code,M.ActivefromEq*/

	select Party_code,ActivefromEq,ActivefromEq16= Dateadd(d,16,m.ActivefromEq )
	into #MarginTemp
	 from mimansa.CRM.dbo.AngelclientMarginDetails_allseg m with(nolock)
	where  m.ActivefromEq >= @@FromDate_1 
	and m.ActivefromEq<=@@ToDate_1 
	and Exchangesegment = 'EQUITY' and  isnull(OldCode,'') = ''

	SELECT m.Party_code, ReportDate =upd_date--max(upd_date)-- cast(convert(varchar(11), max(upd_date),109) as smalldatetime),
	,M.ActivefromEq 
	into #temp1
	from #MarginTemp m with (nolock) inner join History.DBO.RMS_HOLDING A with (nolock)
	on m.Party_code = a.Party_code
	Where upd_date  < ActivefromEq16

	select Party_code,ActivefromEq,ReportDate=cast(convert(varchar(11), max(ReportDate),109) as smalldatetime)
		into #temp
		from #temp1
		Group by Party_code,ActivefromEq
		
	--drop table #TempDPHolding
	--select t.party_code,ActivefromEq,ReportDate, isin, scrip_cd,Scripname,upd_date,bs, exchange, qty, clsrate,Total,SHRT_HC,HairCut, ExchangeHairCut, total_withHC  
	--into #TempDPHolding
	--from #temp t, (select A.isin, scrip_cd, scripname, party_code,upd_date,bs, a.exchange, qty, clsrate,Total,Q.SHRT_HC,
	--				HairCut=(  
	--						CASE WHEN A.EXCHANGE = 'BSECM'   
	--								THEN ISNULL(B.BSE_PROJ_VAR, 100)            
	--								WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
	--								THEN ISNULL(B.NSE_PROJ_VAR, 100)            
	--								ELSE 100            
	--						END) ,
	--					ExchangeHairCut=(  
	--							CASE WHEN A.EXCHANGE = 'BSECM'   
	--									THEN ISNULL(B.BSE_VAR, 100)            
	--									WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
	--									THEN ISNULL(B.NSE_VAR, 100)  
	--									ELSE 100  
	--							END)  ,  
	--					total_WithHC=            
	--					CASE WHEN A.QTY > 0   
	--							THEN (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))-((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*((  
	--								CASE WHEN A.EXCHANGE = 'BSECM'   
	--										THEN ISNULL(B.BSE_PROJ_VAR, 100)            
	--										WHEN (A.EXCHANGE = 'NSECM' OR A.EXCHANGE = 'NSEFO')   
	--										THEN ISNULL(B.NSE_PROJ_VAR, 100)            
	--										ELSE 100            
	--								END)/100.00))            
	--						ELSE (A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))+((A.CLSRATE*(A.QTY+ISNULL(A.ADJQTY,0)))*(ISNULL(Q.SHRT_HC,100.00)/100.00))            
	--					END   
	--				from History.DBO.RMS_HOLDING (NOLOCK) A INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q   
	--				ON A.EXCHANGE=Q.CO_CODE LEFT OUTER JOIN  GENERAL.DBO.SCRIPVAR_MASTER (NOLOCK) B  ON A.ISIN=B.ISIN   
	--				) h
	--where t.Party_code = h.party_code AND t.ReportDate = convert(varchar(11), upd_date ,109)
 
 select h.Party_code,ActivefromEq,ReportDate,Dphold=sum(h.total) into #TempDPHolding from History.DBO.RMS_HOLDING (NOLOCK) h,#temp t where t.Party_code=h.Party_code and h.EXCHANGE = 'POA' AND t.ReportDate = convert(varchar(11), h.upd_date ,109)
group by h.Party_code,ActivefromEq,ReportDate

	--truncate table AngelClientDPSecMarginDetails
	--insert into AngelClientDPSecMarginDetails

	truncate table AngelClientDPSecMargin

	insert into AngelClientDPSecMargin
	SELECT *, LogDate = getdate() from #TempDPHolding 
	--	SELECT count( * ) from #TempDPHolding 
	--SELECT top 10 * from AngelClientDPSecMargin where party_code in('M81126','P66649')

	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findtextinspArjun
-- --------------------------------------------------

-- =============================================
-- Author:		Arjun Singh
-- Create date: <Create Date,,>
-- Description:	[dbo].[usp_findtextinspArjun]  'Equity Trade Confirmation Log','general'
-- =============================================

create PROCEDURE [dbo].[usp_findtextinspArjun]  
  @text varchar(250),   
  @dbname varchar(64) = null  
AS BEGIN  
SET NOCOUNT ON;   
  
if isnull(@dbname,'') = ''
  begin  
    --enumerate all databases.   
  DECLARE #db CURSOR FOR Select Name from master..sysdatabases 
  declare @c_dbname varchar(64)   
  
  OPEN #db FETCH #db INTO @c_dbname   
  while @@FETCH_STATUS <> -1 --and @MyCount < 500   
   begin  
     execute usp_findtextinspArjun @text, @c_dbname   
     FETCH #db INTO @c_dbname   
   end     
  CLOSE #db DEALLOCATE #db   
 end --if @dbname is null   
else  
 begin --@dbname is not null   
  declare @sql varchar(250)   
  --create the find like command   
  select @sql = 'select ''' + @dbname + ''' as db, o.name,m.definition '  
  select @sql = @sql + ' from '+@dbname+'.sys.sql_modules m '  
  select @sql = @sql + ' inner join '+@dbname+'..sysobjects o on m.object_id=o.id'  
  select @sql = @sql + ' where [definition] like ''%'+@text+'%'''  
  execute (@sql)   
 end --@dbname is not null   
END

GO

-- --------------------------------------------------
-- TABLE dbo.AngelClientDPSecMargin
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelClientDPSecMargin]
(
    [Party_code] VARCHAR(10) NULL,
    [ActivefromEq] DATETIME NULL,
    [ReportDate] SMALLDATETIME NULL,
    [DPHold] FLOAT NULL,
    [LogDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AngelClientDPSecMarginDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelClientDPSecMarginDetails]
(
    [party_code] VARCHAR(10) NOT NULL,
    [ActivefromEq] DATETIME NULL,
    [ReportDate] SMALLDATETIME NULL,
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [Scripname] VARCHAR(50) NULL,
    [upd_date] DATETIME NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [Total] MONEY NULL,
    [SHRT_HC] MONEY NULL,
    [HairCut] DECIMAL(10, 2) NOT NULL,
    [ExchangeHairCut] DECIMAL(10, 2) NOT NULL,
    [total_withHC] FLOAT NULL,
    [LogDate] DATETIME NULL
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

