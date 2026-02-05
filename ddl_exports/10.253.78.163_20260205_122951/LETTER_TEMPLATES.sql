-- DDL Export
-- Server: 10.253.78.163
-- Database: LETTER_TEMPLATES
-- Exported: 2026-02-05T12:30:01.135235

USE LETTER_TEMPLATES;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------
CREATE procedure [dbo].[rebuild_index]  
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
DECLARE partitions CURSOR FOR SELECT objectid,indexid,partitionnum,frag FROM #work_to_do;  
  
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
END;  
  
-- Close and deallocate the cursor.  
CLOSE partitions;  
DEALLOCATE partitions;  
  
-- Drop the temporary table.  
DROP TABLE #work_to_do;  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_functions_findInUSP
-- --------------------------------------------------
create PROCEDURE usp_functions_findInUSP  
@str varchar(500)  
AS  
  
 set @str = '%' + @str + '%'  
   
 select O.name from sysComments  C  
 join sysObjects O on O.id = C.id  
 where O.xtype = 'P' and C.text like @str

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_letter_templates
-- --------------------------------------------------
    
CREATE proc usp_letter_templates    
(    
@template_name as varchar(100)    
)    
as    
Set NoCount on    
    
if (Select count(*) from letter_templates where template_name=@template_name and chk = 'Y') > 0    
begin    
declare @sql varchar(1000)    
set @sql = 'declare @DPLEDBAL money;    
Select @DPLEDBAL= sum(case when ld_debitflag=''C''then ld_amount end)- sum(case when ld_debitflag = ''D''     
then -ld_amount end) from [ABCSOORACLEMDLW].synergy.dbo.ledger ;    
print convert(varchar(500),@DPLEDBAL);    
select template_name,ref_no,subject,    
Replace(content,''___________________'',''<u>''+convert(varchar(500),@DPLEDBAL)+''</u>'')content,    
footer,dt,sr_no,chk    
from letter_templates where template_name=''DP initiated Closure'''    
--print @sql    
exec (@sql)    
end    
else    
begin    
select * from letter_templates where template_name = @template_name    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_letter_templates31122012
-- --------------------------------------------------
  
CREATE proc usp_letter_templates31122012  
(  
@template_name as varchar(100)  
)  
as  
Set NoCount on  
  
if (Select count(*) from letter_templates where template_name=@template_name and chk = 'Y') > 0  
begin  
declare @sql varchar(1000)  
set @sql = 'declare @DPLEDBAL money;  
Select @DPLEDBAL= sum(case when ld_debitflag=''C''then ld_amount end)- sum(case when ld_debitflag = ''D''   
then -ld_amount end) from dpbackoffice.acercross.dbo.ledger ;  
print convert(varchar(500),@DPLEDBAL);  
select template_name,ref_no,subject,  
Replace(content,''___________________'',''<u>''+convert(varchar(500),@DPLEDBAL)+''</u>'')content,  
footer,dt,sr_no,chk  
from letter_templates where template_name=''DP initiated Closure'''  
--print @sql  
exec (@sql)  
end  
else  
begin  
select * from letter_templates where template_name = @template_name  
end

GO

-- --------------------------------------------------
-- TABLE dbo.client_details
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details]
(
    [client_name] VARCHAR(50) NULL,
    [address1] VARCHAR(300) NULL,
    [address2] VARCHAR(300) NULL,
    [address3] VARCHAR(300) NULL,
    [city] VARCHAR(50) NULL,
    [zip] NUMERIC(18, 0) NULL,
    [tel_no] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_details1
-- --------------------------------------------------
CREATE TABLE [dbo].[client_details1]
(
    [client_name1] VARCHAR(50) NULL,
    [address11] VARCHAR(300) NULL,
    [address21] VARCHAR(300) NULL,
    [address31] VARCHAR(300) NULL,
    [city1] VARCHAR(50) NULL,
    [zip1] NUMERIC(18, 0) NULL,
    [tel_no1] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dba
-- --------------------------------------------------
CREATE TABLE [dbo].[dba]
(
    [server1] VARCHAR(50) NULL,
    [db] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.letter_templates
-- --------------------------------------------------
CREATE TABLE [dbo].[letter_templates]
(
    [template_name] VARCHAR(50) NULL,
    [ref_no] VARCHAR(50) NULL,
    [subject] VARCHAR(200) NULL,
    [content] VARCHAR(5000) NULL,
    [footer] VARCHAR(500) NULL,
    [dt] VARCHAR(50) NULL,
    [sr_no] INT IDENTITY(1,1) NOT NULL,
    [chk] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.letter_templates1
-- --------------------------------------------------
CREATE TABLE [dbo].[letter_templates1]
(
    [template_no] VARCHAR(50) NULL,
    [template_name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.letter_templates2
-- --------------------------------------------------
CREATE TABLE [dbo].[letter_templates2]
(
    [server] VARCHAR(50) NULL,
    [db] VARCHAR(50) NULL,
    [query] VARCHAR(50) NULL,
    [template] VARCHAR(50) NULL,
    [date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pr2_db
-- --------------------------------------------------
CREATE TABLE [dbo].[pr2_db]
(
    [template_name] VARCHAR(50) NULL,
    [dt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.print_db
-- --------------------------------------------------
CREATE TABLE [dbo].[print_db]
(
    [server1] VARCHAR(50) NULL,
    [db] VARCHAR(50) NULL,
    [qy] TEXT NULL,
    [template_name] VARCHAR(50) NULL,
    [dt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.print_letter
-- --------------------------------------------------
CREATE TABLE [dbo].[print_letter]
(
    [template_name] VARCHAR(50) NULL,
    [dt] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.search
-- --------------------------------------------------
CREATE TABLE [dbo].[search]
(
    [sr_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.server_db
-- --------------------------------------------------
CREATE TABLE [dbo].[server_db]
(
    [server1] VARCHAR(50) NULL,
    [db] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.server_db1
-- --------------------------------------------------
CREATE TABLE [dbo].[server_db1]
(
    [server1] VARCHAR(50) NULL,
    [un] VARCHAR(50) NULL,
    [pswd] VARCHAR(50) NULL,
    [db] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sr
-- --------------------------------------------------
CREATE TABLE [dbo].[sr]
(
    [template_name] VARCHAR(50) NULL,
    [sr_no] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblCustomerInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tblCustomerInfo]
(
    [ID1] INT IDENTITY(1,1) NOT NULL,
    [Email] TEXT NULL,
    [Name] TEXT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.to1
-- --------------------------------------------------
CREATE TABLE [dbo].[to1]
(
    [name1] VARCHAR(50) NULL,
    [add2] VARCHAR(50) NULL,
    [city1] VARCHAR(50) NULL,
    [pin_no1] VARCHAR(50) NULL,
    [tel_no1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_info
-- --------------------------------------------------
CREATE TABLE [dbo].[user_info]
(
    [name_user] VARCHAR(50) NULL,
    [add1] VARCHAR(50) NULL,
    [add2] VARCHAR(50) NULL,
    [add3] VARCHAR(50) NULL,
    [city] VARCHAR(50) NULL,
    [pin] INT IDENTITY(1,1) NOT NULL,
    [tel_no] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.user_info2
-- --------------------------------------------------
CREATE TABLE [dbo].[user_info2]
(
    [name_user] VARCHAR(50) NULL,
    [add1] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL,
    [pin_no] VARCHAR(50) NULL,
    [tel_no] VARCHAR(50) NULL
);

GO

