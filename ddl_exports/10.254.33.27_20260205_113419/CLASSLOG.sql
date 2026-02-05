-- DDL Export
-- Server: 10.254.33.27
-- Database: CLASSLOG
-- Exported: 2026-02-05T11:34:23.956201

USE CLASSLOG;
GO

-- --------------------------------------------------
-- TABLE dbo.APPLOG
-- --------------------------------------------------
CREATE TABLE [dbo].[APPLOG]
(
    [UID] VARCHAR(200) NULL,
    [SESSIONID] VARCHAR(200) NULL,
    [TIMESTAMP] VARCHAR(200) NULL,
    [USERNAME] VARCHAR(200) NULL,
    [EXCHANGE] VARCHAR(200) NULL,
    [SEGMENT] VARCHAR(200) NULL,
    [STATUSID] VARCHAR(200) NULL,
    [STATUSNAME] VARCHAR(200) NULL,
    [IP] VARCHAR(200) NULL,
    [PREVIOUSPAGE] VARCHAR(500) NULL,
    [CLASSNAME] VARCHAR(500) NULL,
    [METHOD] VARCHAR(200) NULL,
    [REPCODE] INT NULL,
    [ISERROR] BIT NULL DEFAULT ((0)),
    [SRNO] BIGINT IDENTITY(0,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.APPLOG_TRG
-- --------------------------------------------------
CREATE TABLE [dbo].[APPLOG_TRG]
(
    [UID] VARCHAR(200) NULL,
    [SESSIONID] VARCHAR(200) NULL,
    [TIMESTAMP] VARCHAR(200) NULL,
    [USERNAME] VARCHAR(200) NULL,
    [EXCHANGE] VARCHAR(200) NULL,
    [SEGMENT] VARCHAR(200) NULL,
    [STATUSID] VARCHAR(200) NULL,
    [STATUSNAME] VARCHAR(200) NULL,
    [IP] VARCHAR(200) NULL,
    [PREVIOUSPAGE] VARCHAR(500) NULL,
    [CLASSNAME] VARCHAR(500) NULL,
    [METHOD] VARCHAR(200) NULL,
    [REPCODE] INT NULL,
    [ISERROR] BIT NULL,
    [EXECUTEDON] DATETIME NULL,
    [ACTION] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fragmentaion_after_reorg
-- --------------------------------------------------
CREATE TABLE [dbo].[Fragmentaion_after_reorg]
(
    [Schema] NVARCHAR(128) NOT NULL,
    [Table] NVARCHAR(128) NOT NULL,
    [Index] NVARCHAR(128) NULL,
    [avg_fragmentation_in_percent] FLOAT NULL,
    [page_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fragmentaion_before_reorg
-- --------------------------------------------------
CREATE TABLE [dbo].[Fragmentaion_before_reorg]
(
    [Schema] NVARCHAR(128) NOT NULL,
    [Table] NVARCHAR(128) NOT NULL,
    [Index] NVARCHAR(128) NULL,
    [avg_fragmentation_in_percent] FLOAT NULL,
    [page_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.APPLOG_DELETE
-- --------------------------------------------------

CREATE TRIGGER [dbo].[APPLOG_DELETE] ON [dbo].[APPLOG] FOR DELETE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO APPLOG_TRG ([UID],SESSIONID,[TIMESTAMP],USERNAME,EXCHANGE,SEGMENT,STATUSID,
							STATUSNAME,IP,PREVIOUSPAGE,CLASSNAME,METHOD,REPCODE,ISERROR,EXECUTEDON,[ACTION])
	SELECT [UID],SESSIONID,[TIMESTAMP],USERNAME,EXCHANGE,SEGMENT,STATUSID,
							STATUSNAME,IP,PREVIOUSPAGE,CLASSNAME,METHOD,REPCODE,ISERROR,EXECUTEDON = GETDATE(), [ACTION] = 'D' FROM DELETED
END

GO

-- --------------------------------------------------
-- TRIGGER dbo.APPLOG_UPDATE
-- --------------------------------------------------

CREATE TRIGGER [dbo].[APPLOG_UPDATE] ON [dbo].[APPLOG] FOR UPDATE
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO APPLOG_TRG ([UID],SESSIONID,[TIMESTAMP],USERNAME,EXCHANGE,SEGMENT,STATUSID,
							STATUSNAME,IP,PREVIOUSPAGE,CLASSNAME,METHOD,REPCODE,ISERROR,EXECUTEDON,[ACTION])
	SELECT [UID],SESSIONID,[TIMESTAMP],USERNAME,EXCHANGE,SEGMENT,STATUSID,
							STATUSNAME,IP,PREVIOUSPAGE,CLASSNAME,METHOD,REPCODE,ISERROR,EXECUTEDON = GETDATE(), [ACTION] = 'M' FROM DELETED
END

GO

-- --------------------------------------------------
-- VIEW dbo.Fragmentaion_details
-- --------------------------------------------------
create view Fragmentaion_details
as 

SELECT S.name as 'Schema',
T.name as 'Table',
I.name as 'Index',
DDIPS.avg_fragmentation_in_percent,
DDIPS.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 0

GO

-- --------------------------------------------------
-- TABLE yatin.APPLOG
-- --------------------------------------------------
CREATE TABLE [yatin].[APPLOG]
(
    [UID] VARCHAR(200) NULL,
    [SESSIONID] VARCHAR(200) NULL,
    [TIMESTAMP] VARCHAR(200) NULL,
    [USERNAME] VARCHAR(200) NULL,
    [EXCHANGE] VARCHAR(200) NULL,
    [SEGMENT] VARCHAR(200) NULL,
    [STATUSID] VARCHAR(200) NULL,
    [STATUSNAME] VARCHAR(200) NULL,
    [IP] VARCHAR(200) NULL,
    [PREVIOUSPAGE] VARCHAR(500) NULL,
    [CLASSNAME] VARCHAR(500) NULL,
    [METHOD] VARCHAR(200) NULL,
    [REPCODE] INT NULL,
    [ISERROR] BIT NULL DEFAULT ((0)),
    [SRNO] BIGINT IDENTITY(0,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE yatin.APPLOG_TRG
-- --------------------------------------------------
CREATE TABLE [yatin].[APPLOG_TRG]
(
    [UID] VARCHAR(200) NULL,
    [SESSIONID] VARCHAR(200) NULL,
    [TIMESTAMP] VARCHAR(200) NULL,
    [USERNAME] VARCHAR(200) NULL,
    [EXCHANGE] VARCHAR(200) NULL,
    [SEGMENT] VARCHAR(200) NULL,
    [STATUSID] VARCHAR(200) NULL,
    [STATUSNAME] VARCHAR(200) NULL,
    [IP] VARCHAR(200) NULL,
    [PREVIOUSPAGE] VARCHAR(500) NULL,
    [CLASSNAME] VARCHAR(500) NULL,
    [METHOD] VARCHAR(200) NULL,
    [REPCODE] INT NULL,
    [ISERROR] BIT NULL,
    [EXECUTEDON] DATETIME NULL,
    [ACTION] VARCHAR(2) NULL
);

GO

