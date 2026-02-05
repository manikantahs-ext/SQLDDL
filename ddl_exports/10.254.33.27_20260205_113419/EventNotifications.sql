-- DDL Export
-- Server: 10.254.33.27
-- Database: EventNotifications
-- Exported: 2026-02-05T11:34:25.331158

USE EventNotifications;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.LoggedEvents
-- --------------------------------------------------
ALTER TABLE [dbo].[LoggedEvents] ADD CONSTRAINT [PK__LoggedEv__0378F5037F60ED59] PRIMARY KEY ([EventNumber])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- --------------------------------------------------
CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.LogEventsProc
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[LogEventsProc]
AS
SET NOCOUNT ON;
DECLARE     @message_body XML,
            @message_type_name NVARCHAR(256),
            @dialog UNIQUEIDENTIFIER ;
--  This procedure continues to process messages in the queue until the
--  queue is empty.
WHILE (1 = 1)
BEGIN
    BEGIN TRANSACTION ;
    -- Receive the next available message
    WAITFOR (
        RECEIVE TOP(1) -- just handle one message at a time
            @message_type_name=message_type_name,  --the type of message received
            @message_body=message_body,      -- the message contents
            @dialog = conversation_handle    -- the identifier of the dialog this message was received on
            FROM NotifyQueue
    ), TIMEOUT 2000 ; -- if the queue is empty for two seconds, give up and go away
   -- If RECEIVE did not return a message, roll back the transaction
   -- and break out of the while loop, exiting the procedure.
    IF (@@ROWCOUNT = 0)
        BEGIN
            ROLLBACK TRANSACTION ;
            BREAK ;
        END ;
   -- Check to see if the message is an end dialog message.
    IF (@message_type_name = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
    BEGIN
        PRINT 'End Dialog received for dialog # ' + cast(@dialog as nvarchar(40)) ;
        END CONVERSATION @dialog ;
    END ;
    ELSE
    BEGIN
    -- Extract the event information using XQuery.
    --++++++++++++++++**************put if condition here
                       
    -- Use XQuery to extract XML values to be inserted into the log table
    INSERT INTO [dbo].[LoggedEvents] (
        EventType,
        EventTime,
        LoginName,
        UserName,
        ServerName,
        DatabaseName,
        SchemaName,
        ObjectName,
        ObjectType,
        TSQLCmdText
    )
    VALUES
    (
    CAST(@message_body.query('/EVENT_INSTANCE/EventType/text()')  AS NVARCHAR(256)),
    CAST(CAST(@message_body.query('/EVENT_INSTANCE/PostTime/text()') AS NVARCHAR(MAX)) AS DATETIME),
    CAST(@message_body.query('/EVENT_INSTANCE/LoginName/text()') AS sysname),
    @message_body.value('(/EVENT_INSTANCE/ClientHost)[1]', 'NVARCHAR(15)')  ,
    CAST(@message_body.query('/EVENT_INSTANCE/ServerName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/DatabaseName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/SchemaName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/ObjectName/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/ObjectType/text()') AS sysname),
    CAST(@message_body.query('/EVENT_INSTANCE/TSQLCommand/CommandText/text()') AS NVARCHAR(MAX))
    ) ;
    

    END ;
    COMMIT TRANSACTION ;
END ;

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
-- TABLE dbo.Logged_SA_Events
-- --------------------------------------------------
CREATE TABLE [dbo].[Logged_SA_Events]
(
    [SPID] INT NULL,
    [IPAddress] VARCHAR(48) NULL,
    [MachineName] NVARCHAR(128) NULL,
    [ApplicationName] NVARCHAR(128) NULL,
    [LoginName] NVARCHAR(128) NOT NULL,
    [LoggedTimeStamp] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.LoggedEvents
-- --------------------------------------------------
CREATE TABLE [dbo].[LoggedEvents]
(
    [EventNumber] INT IDENTITY(1,1) NOT NULL,
    [EventType] NVARCHAR(256) NULL,
    [EventTime] DATETIME NULL,
    [LoginName] NVARCHAR(128) NULL,
    [UserName] NVARCHAR(128) NULL,
    [ServerName] NVARCHAR(128) NULL,
    [DatabaseName] NVARCHAR(128) NULL,
    [SchemaName] NVARCHAR(128) NULL,
    [ObjectName] NVARCHAR(128) NULL,
    [ObjectType] NVARCHAR(128) NULL,
    [TSQLCmdText] NVARCHAR(MAX) NULL
);

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

