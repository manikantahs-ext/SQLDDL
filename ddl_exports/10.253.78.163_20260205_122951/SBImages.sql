-- DDL Export
-- Server: 10.253.78.163
-- Database: SBImages
-- Exported: 2026-02-05T12:32:29.808254

USE SBImages;
GO

-- --------------------------------------------------
-- INDEX dbo.Sb_Images
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PartnerSeq] ON [dbo].[Sb_Images] ([PartnerSeq], [CatCode], [DocProofCode], [FileExtension], [Status], [Comments], [ReUploadStatus])

GO

-- --------------------------------------------------
-- INDEX dbo.Sb_Images
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Refno] ON [dbo].[Sb_Images] ([Refno])

GO

-- --------------------------------------------------
-- INDEX dbo.Sb_Images
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ReUploadStatus] ON [dbo].[Sb_Images] ([ReUploadStatus], [UploadCompleteStatus], [Status]) INCLUDE ([Refno])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_GstFile
-- --------------------------------------------------
  
CREATE proc proc_GstFile  
@PanNo varchar(10)=null,  
@Mode varchar(10),  
@accessto varchar(10),  
@accesscode varchar(10)  
as  
begin  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

if(@Mode='View' and  @accesscode<>'')  
  
select FileName ,replace(Extension,'.','') as Extension ,Files from [Sb_GstCertificateFile] with (nolock)  
where PanNo =@Panno  
end

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_GstFile_06Nov2025
-- --------------------------------------------------
  
create proc proc_GstFile_06Nov2025  
@PanNo varchar(10)=null,  
@Mode varchar(10),  
@accessto varchar(10),  
@accesscode varchar(10)  
as  
begin  
if(@Mode='View' and  @accesscode<>'')  
  
select FileName ,replace(Extension,'.','') as Extension ,Files from [Sb_GstCertificateFile] with (nolock)  
where PanNo =@Panno  
end

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

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
-- TABLE dbo.Sb_GstCertificateFile
-- --------------------------------------------------
CREATE TABLE [dbo].[Sb_GstCertificateFile]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [PanNo] VARCHAR(20) NULL,
    [SbTag] VARCHAR(10) NULL,
    [Extension] VARCHAR(10) NULL,
    [FileName] VARCHAR(100) NULL,
    [Files] IMAGE NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] VARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sb_Images
-- --------------------------------------------------
CREATE TABLE [dbo].[Sb_Images]
(
    [Refno] NUMERIC(18, 0) NOT NULL,
    [PartnerSeq] INT NULL,
    [CatCode] VARCHAR(50) NULL,
    [DocProofCode] VARCHAR(20) NULL,
    [Images] IMAGE NULL,
    [FileExtension] VARCHAR(20) NULL,
    [Status] VARCHAR(20) NULL,
    [Comments] VARCHAR(200) NULL,
    [CrtBy] VARCHAR(50) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(50) NULL,
    [MdyDt] DATETIME NULL,
    [ReUploadStatus] VARCHAR(2) NULL,
    [UploadCompleteStatus] BIT NOT NULL DEFAULT ((0)),
    [checker] VARCHAR(50) NULL,
    [CDT] DATETIME NULL,
    [Cstatus] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_images_20140324002
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_images_20140324002]
(
    [Refno] NUMERIC(18, 0) NOT NULL,
    [PartnerSeq] INT NULL,
    [CatCode] VARCHAR(50) NULL,
    [DocProofCode] VARCHAR(20) NULL,
    [Images] IMAGE NULL,
    [FileExtension] VARCHAR(20) NULL,
    [Status] VARCHAR(20) NULL,
    [Comments] VARCHAR(200) NULL,
    [CrtBy] VARCHAR(50) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(50) NULL,
    [MdyDt] DATETIME NULL,
    [ReUploadStatus] VARCHAR(2) NULL,
    [UploadCompleteStatus] BIT NOT NULL,
    [checker] VARCHAR(50) NULL,
    [CDT] DATETIME NULL,
    [Cstatus] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sb_images_27mar2014
-- --------------------------------------------------
CREATE TABLE [dbo].[sb_images_27mar2014]
(
    [Refno] NUMERIC(18, 0) NOT NULL,
    [PartnerSeq] INT NULL,
    [CatCode] VARCHAR(50) NULL,
    [DocProofCode] VARCHAR(20) NULL,
    [Images] IMAGE NULL,
    [FileExtension] VARCHAR(20) NULL,
    [Status] VARCHAR(20) NULL,
    [Comments] VARCHAR(200) NULL,
    [CrtBy] VARCHAR(50) NULL,
    [CrtDt] DATETIME NULL,
    [MdyBy] VARCHAR(50) NULL,
    [MdyDt] DATETIME NULL,
    [ReUploadStatus] VARCHAR(2) NULL,
    [UploadCompleteStatus] BIT NOT NULL,
    [checker] VARCHAR(50) NULL,
    [CDT] DATETIME NULL,
    [Cstatus] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_SIGNATUREIMAGE
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_SIGNATUREIMAGE]
(
    [SIGID_REF] NUMERIC(18, 0) NULL,
    [SBTAG] VARCHAR(20) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [SIGNATURE] VARBINARY(MAX) NULL,
    [CREATEDON] DATETIME NULL,
    [MODIFIEDON] DATETIME NULL,
    [SIG_STATUS] VARCHAR(20) NULL
);

GO

