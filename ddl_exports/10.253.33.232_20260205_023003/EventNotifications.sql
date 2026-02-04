-- DDL Export
-- Server: 10.253.33.232
-- Database: EventNotifications
-- Exported: 2026-02-05T02:30:07.775710

USE EventNotifications;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.LoggedEvents
-- --------------------------------------------------
ALTER TABLE [dbo].[LoggedEvents] ADD CONSTRAINT [PK__LoggedEv__0378F5037F60ED59] PRIMARY KEY ([EventNumber])

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
-- TABLE dbo.a1
-- --------------------------------------------------
CREATE TABLE [dbo].[a1]
(
    [fname] VARCHAR(10) NULL
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

