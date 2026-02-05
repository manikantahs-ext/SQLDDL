-- DDL Export
-- Server: 10.254.33.21
-- Database: CommonTools
-- Exported: 2026-02-05T11:26:51.937635

USE CommonTools;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.current_process
-- --------------------------------------------------

CREATE PROC [dbo].[current_process] (@paraid as int)    
AS    
/*--------------------------------------------------------------------    
Purpose: Shows what individual SQL statements are currently executing.    
----------------------------------------------------------------------    
Parameters: None.    
Revision History:    
 24/07/2008  Ian_Stirk@yahoo.com Initial version    
Example Usage:    
 1. exec YourServerName.master.dbo.dba_WhatSQLIsExecuting                   
---------------------------------------------------------------------*/    
BEGIN    
    -- Do not lock anything, and do not get held up by any locks.    
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
    -- What SQL Statements Are Currently Running?    
  
if @paraid<>0  
BEGIN  
    SELECT [Spid] = session_Id    
 , ecid    
 , [Database] = DB_NAME(sp.dbid)    
 , [User] = nt_username    
 , [Status] = er.status    
 , [Wait] = wait_type    
 , [Individual Query] = SUBSTRING (qt.text,     
             er.statement_start_offset/2,    
 (CASE WHEN er.statement_end_offset = -1    
        THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2    
  ELSE er.statement_end_offset END -     
                                er.statement_start_offset)/2)    
 ,[Parent Query] = qt.text    
 , Program = program_name    
 , Hostname    
 , nt_domain    
 , start_time    
    FROM sys.dm_exec_requests er    
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid    
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt    
    WHERE session_Id > 50              -- Ignore system spids.    
    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.    
 AND session_id = @paraid  
    ORDER BY 1, 2    
END  
ELSE  
BEGIN  
    SELECT [Spid] = session_Id    
 , ecid    
 , [Database] = DB_NAME(sp.dbid)    
 , [User] = nt_username    
 , [Status] = er.status    
 , [Wait] = wait_type    
 , [Individual Query] = SUBSTRING (qt.text,     
             er.statement_start_offset/2,    
 (CASE WHEN er.statement_end_offset = -1    
        THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2    
  ELSE er.statement_end_offset END -     
                                er.statement_start_offset)/2)    
 ,[Parent Query] = qt.text    
 , Program = program_name    
 , Hostname    
 , nt_domain    
 , start_time    
    FROM sys.dm_exec_requests er    
    INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid    
    CROSS APPLY sys.dm_exec_sql_text(er.sql_handle)as qt    
    WHERE session_Id > 50              -- Ignore system spids.    
    AND session_Id NOT IN (@@SPID)     -- Ignore this current statement.    
    ORDER BY 1, 2    
END  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_test
-- --------------------------------------------------
create proc DBA_test
As
Select 'TRIGGER CHECK PROCEDURE'

drop proc DBA_test

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------

  -- exec rebuild_index2 'AdventureWorksDW'
CREATE procedure [dbo].[rebuild_index]
@database varchar(100)
as
declare @db_id  int
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
DECLARE @MAXROWID int;
DECLARE @MINROWID int;
DECLARE @CURRROWID int; 
DECLARE @ID int;    
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function    
-- and convert object and index IDs to names.    
Create table #work_to_do(id bigint primary key identity(1,1),objectid int,indexid int,partitionnum bigint,frag float )  

insert into #work_to_do(objectid,indexid,partitionnum,frag)
 select
object_id AS objectid,    
index_id AS indexid,    
partition_number AS partitionnum,    
avg_fragmentation_in_percent AS frag    
 FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')    
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0; 

  
   --select @ID =ID from #work_to_do 
  
  SELECT @MINROWID=MIN(ID),@MAXROWID=MAX(ID) FROM #work_to_do WITH(NOLOCK) ; 

  SET @CURRROWID=@MINROWID;  

WHILE (@CURRROWID<=@MAXROWID)
   BEGIN 
 
    SELECT  @objectid=objectid , @indexid=indexid  , @partitionnum=partitionnum , @frag=frag 
     FROM #work_to_do WHERE ID=@CURRROWID 
     set @CURRROWID=@CURRROWID+1   


SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)    
FROM sys.objects AS o    
JOIN sys.schemas as s ON s.schema_id = o.schema_id    
WHERE o.object_id = @objectid;    
SELECT @indexname = QUOTENAME(name)    
FROM sys.indexes    
WHERE object_id = @objectid AND index_id = @indexid;    
SELECT @partitioncount = count (*)    
FROM sys.partitions    
WHERE object_id = @objectid AND index_id = @indexid;    
    
-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.    
IF @frag < 30.0    
      SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';    
IF @frag >= 30.0    
      SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';    
IF @partitioncount > 1    
      SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));    
IF @frag >= 30.0    
      set @command = @command +N' WITH (SORT_IN_TEMPDB = ON)'   
   
EXEC (@command);    
PRINT N'Executed: ' + @command;    
select N'Executed: ' + @command; 
end

      
-- Drop the temporary table.    
DROP TABLE #work_to_do;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_who4
-- --------------------------------------------------

CREATE PROCEDURE sp_who4   
@loginame sysname = NULL,   
/* NEW PARAMETER ADDED BY CHB */   
@hostname sysname = NULL,   
/* NEW PARAMETER ADDED BY The Indoctrinator!!*/  
@PRG_NAME as varchar(50) = ''   
as   
  
set nocount on   
  
if @hostname is null set @hostname = '0'   
  
declare   
@retcode int   
  
declare   
@sidlow varbinary(85)   
,@sidhigh varbinary(85)   
,@sid1 varbinary(85)   
,@spidlow int   
,@spidhigh int   
  
declare   
@charMaxLenLoginName varchar(6)   
,@charMaxLenDBName varchar(6)   
,@charMaxLenCPUTime varchar(10)   
,@charMaxLenDiskIO varchar(10)   
,@charMaxLenHostName varchar(10)   
,@charMaxLenProgramName varchar(10)   
,@charMaxLenLastBatch varchar(10)   
,@charMaxLenCommand varchar(10)   
  
declare   
@charsidlow varchar(85)   
,@charsidhigh varchar(85)   
,@charspidlow varchar(11)   
,@charspidhigh varchar(11)   
DECLARE @strQUERY as varchar(7000)   
set @strQUERY = ''  
--------   
  
select   
@retcode = 0 -- 0=good ,1=bad.   
  
--------defaults   
select @sidlow = convert(varbinary(85), (replicate(char(0), 85)))   
select @sidhigh = convert(varbinary(85), (replicate(char(1), 85)))   
  
select   
@spidlow = 0   
,@spidhigh= 32767   
  
----------------------------------------  
----------------------   
IF (@loginame IS NULL) --Simple default to all LoginNames.   
GOTO LABEL_17PARM1EDITED   
  
--------   
  
-- select @sid1 = suser_sid(@loginame)   
select @sid1 = null   
if exists(select * from master.dbo.syslogins where loginname = @loginame)   
select @sid1 = sid from master.dbo.syslogins where loginname = @loginame   
  
IF (@sid1 IS NOT NULL) --Parm is a recognized login name.   
   
begin   
select @sidlow = suser_sid(@loginame)   
,@sidhigh = suser_sid(@loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
IF (lower(@loginame) IN ('active')) --Special action, not sleeping.   
   
begin   
select @loginame = lower(@loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
IF (patindex ('%[^0-9]%' , isnull(@loginame,'z')) = 0) --Is a number.   
   
begin   
select   
@spidlow= convert(int, @loginame)   
,@spidhigh = convert(int, @loginame)   
GOTO LABEL_17PARM1EDITED   
end   
  
--------   
  
RaisError(15007,-1,-1,@loginame)   
select @retcode = 1   
GOTO LABEL_86RETURN   
  
  
LABEL_17PARM1EDITED:   
  
  
-------------------- Capture consistent   
-- sysprocesses. -------------------   
  
SELECT   
  
spid   
,CAST(null AS VARCHAR(5000)) as commandtext   
,status   
,sid   
,hostname   
,program_name   
,cmd   
,cpu   
,physical_io   
,blocked   
,dbid   
,convert(sysname, rtrim(loginame))   
as loginname   
,spid as 'spid_sort'   
  
, substring( convert(varchar,last_batch,111) ,6 ,5 ) + ' '   
+ substring( convert(varchar,last_batch,113) ,13 ,8 )   
as 'last_batch_char'   
  
INTO #tb1_sysprocesses   
from master.dbo.sysprocesses(nolock)  
  
/*******************************************   
  
FOLLOWING SECTION ADDED BY CHB 05/06/2004   
  
RETURNS LAST COMMAND EXECUTED BY EACH SPID   
  
********************************************/   
  
CREATE TABLE #spid_cmds   
(SQLID INT IDENTITY, spid INT, EventType VARCHAR(100), Parameters INT, Command VARCHAR(8000))   
  
DECLARE spids CURSOR FOR   
SELECT spid FROM #tb1_sysprocesses   
  
DECLARE @spid INT, @sqlid INT   
  
OPEN spids   
FETCH NEXT FROM spids  
INTO @spid   
  
/*   
EXECUTE DBCC INPUTBUFFER FOR EACH SPID   
*/   
  
WHILE (@@FETCH_STATUS = 0)   
   
BEGIN   
INSERT INTO #spid_cmds (EventType, Parameters, Command)   
EXEC('DBCC INPUTBUFFER( ' + @spid + ')')   
  
SELECT @sqlid = MAX(SQLID) FROM #spid_cmds   
  
UPDATE #spid_cmds SET spid = @spid WHERE SQLID = @sqlid  
  
FETCH NEXT FROM spids INTO @spid   
  
END   
  
CLOSE spids   
DEALLOCATE spids   
  
UPDATE p   
SET p.commandtext = s.command   
FROM #tb1_sysprocesses P   
JOIN #spid_cmds s   
ON p.spid = s.spid   
  
----------------------------------------  
-----   
  
--------Screen out any rows?   
  
IF (@loginame IN ('active'))   
DELETE #tb1_sysprocesses   
where lower(status) = 'sleeping'   
and upper(cmd)IN (   
'AWAITING COMMAND'   
,'MIRROR HANDLER'   
,'LAZY WRITER'   
,'CHECKPOINT SLEEP'   
,'RA MANAGER'   
)   
  and blocked= 0   
  
  
  
--------Prepare to dynamically optimize   
-- column widths.   
  
  
Select   
@charsidlow = convert(varchar(85),@sidlow)   
,@charsidhigh= convert(varchar(85),@sidhigh)   
,@charspidlow = convert(varchar,@spidlow)   
,@charspidhigh= convert(varchar,@spidhigh)   
  
  
  
SELECT   
@charMaxLenLoginName =   
convert( varchar   
,isnull( max( datalength(loginname)) ,5)   
)   
  
,@charMaxLenDBName=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),db_name(dbid))))) ,6)   
)   
  
,@charMaxLenCPUTime=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),cpu)))) ,7)   
)   
  
,@charMaxLenDiskIO=   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),physical_io)))) ,6)   
)   
  
,@charMaxLenCommand =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),cmd)))) ,7)   
)   
  
,@charMaxLenHostName =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),hostname)))) ,8)   
)   
  
,@charMaxLenProgramName =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),program_name)))) ,11)   
)   
  
,@charMaxLenLastBatch =   
convert( varchar   
,isnull( max( datalength( rtrim(convert(varchar(128),last_batch_char)))) ,9)   
)   
from   
#tb1_sysprocesses   
where   
-- sid >= @sidlow   
-- andsid <= @sidhigh   
-- and   
spid >= @spidlow   
and spid <= @spidhigh   
  
  
  
--------Output the report.   
  
  
--EXECUTE(   
set @strQUERY= '   
SET nocount off   
  
SELECT   
SPID = convert(char(5),spid)   
,CommandText  
  
,Status=   
CASE lower(status)   
When ''sleeping'' Then lower(status)   
Else upper(status)   
END   
  
,Login = substring(loginname,1,' + @charMaxLenLoginName + ')   
  
,HostName =   
CASE hostname   
When Null Then '' .''   
When '' '' Then '' .''   
Else substring(hostname,1,' + @charMaxLenHostName + ')   
END   
  
,BlkBy =   
CASE isnull(convert(char(5),blocked),''0'')   
When ''0'' Then '' .''   
Else isnull(convert(char(5),blocked),''0'')   
END   
  
,DBName= substring(case when dbid = 0 then null when dbid <> 0 then db_name(dbid) end,1,' + @charMaxLenDBName + ')   
,Command= substring(cmd,1,' + @charMaxLenCommand + ')   
  
,CPUTime= substring(convert(varchar,cpu),1,' + @charMaxLenCPUTime + ')   
,DiskIO= substring(convert(varchar,physical_io),1,' + @charMaxLenDiskIO + ')   
  
,LastBatch = substring(last_batch_char,1,' + @charMaxLenLastBatch + ')   
  
,ProgramName= substring(program_name,1,' + @charMaxLenProgramName + ')   
,SPID = convert(char(5),spid) --Handy extra for right-scrolling users.   
from   
#tb1_sysprocesses --Usually DB qualification is needed in exec().   
where   
spid >= ' + @charspidlow + '   
and spid <= ' + @charspidhigh + '   
and (HostName like ''' + @hostname + '%'' or ''' + @hostname + ''' = ''0'')   
AND substring(program_name,1,' + @charMaxLenProgramName + ') like(''%' + @PRG_NAME + '%'')  
  
  
-- (Seems always auto sorted.)order by   
-- spid_sort   
  
SET nocount on   
'   
--print @strQUERY  
EXECUTE (@strQUERY)   
/*****AKUNDONE: removed from where-clause in above EXEC sqlstr   
sid >= ' + @charsidlow + '   
andsid <= ' + @charsidhigh + '   
and   
**************/   
  
  
LABEL_86RETURN:   
  
  
if (object_id('tempdb..#tb1_sysprocesses') is not null)   
drop table #tb1_sysprocesses   
  
return @retcode -- sp_who4

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findinJobs
-- --------------------------------------------------
Create Procedure usp_findinJobs(@Str as varchar(500))
as
select b.name,
Case when b.enabled=1 then 'Active' else 'Deactive' end as Status,
date_created,date_modified,a.step_id,a.step_name,a.command
from msdb.dbo.sysjobsteps a, msdb.dbo.sysjobs b
where command like '%'+@Str+'%'
and a.job_id=b.job_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
CREATE PROCEDURE usp_findInUSP  
@dbname varchar(500),
@srcstr varchar(500)  
AS  
  
 set nocount on
 set @srcstr  = '%' + @srcstr + '%'  

 declare @str as varchar(1000)
 set @str=''
 if @dbname <>''
 Begin
	set @dbname=@dbname+'.dbo.'
 End
 else
 begin
	set @dbname=db_name()+'.dbo.'
 End
 print @dbname

 set @str='select O.name,O.xtype from '+@dbname+'sysComments  C ' 
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id ' 
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''  
 --print @str
  exec(@str)
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findObjInDb
-- --------------------------------------------------

CREATE procedure usp_findObjInDb(@sqlobj as varchar(50))
as
set nocount on

SELECT Row_number() Over(Order By name) As Row_num, name into #aa FROM sys.sysdatabases
where name not in ('master','tempdb','model','msdb')
order by name

declare @dbname as varchar(100),@str as varchar(max),@ctr as int
set @dbname=''
set @str=''
set @ctr=1

set @str=' create table #file1 '
set @str=@str+ ' ( '
set @str=@str+ ' Dbname varchar(50), '
set @str=@str+ ' ObjectName varchar(100) '
set @str=@str+ ' ) '

set @str=@str+ ' insert into #file1 '

while @ctr  <= (select MAX(row_num) from #aa) 
begin
	
	
	select @dbname=name from #aa where row_num=@ctr
	/* set @str='use ['+@dbname+'] '	*/
	set @str=@str+' select '''+@dbname+''' as DB, name from ['+@dbname+'].dbo.sysobjects where name like ''%'+@sqlobj+'%'' ' 
	if @ctr  < (select MAX(row_num) from #aa) 
	BEgin
		set @str=@str+' Union all '
	END
	
	set @ctr=@ctr+1
end  

set @str=@str+' select * from #file1'

print @str
--exec @str

set nocount off

GO

