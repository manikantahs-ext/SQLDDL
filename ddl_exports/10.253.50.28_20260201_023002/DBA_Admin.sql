-- DDL Export
-- Server: 10.253.50.28
-- Database: DBA_Admin
-- Exported: 2026-02-01T02:30:20.510702

USE DBA_Admin;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.instance_details
-- --------------------------------------------------
ALTER TABLE [dbo].[instance_details] ADD CONSTRAINT [fk_host_name] FOREIGN KEY ([host_name]) REFERENCES [dbo].[instance_hosts] ([host_name])

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_Get_Login_name_IP_Details
-- --------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_Get_Login_name_IP_Details] 
(
	-- Add the parameters for the function here
	@TextDetails nvarchar(500) ,
	@type Int 
	
)
RETURNS nvarchar(100)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @IPADDR     nvarchar (100 )
	DECLARE @LoginName  nvarchar (100 )
	DECLARE @OUTPUT   nvarchar (100)

	IF (@type  = 0)  
	BEGIN 
	   IF @TextDetails  LIKE '%CLIENT:%'
       SET @OUTPUT =  replace ( SUBSTRING(@TextDetails,charindex('CLIENT:',@TextDetails) + LEN('CLIENT:'), LEN(@TextDetails)), ']','')
	   ELSE IF @TextDetails  LIKE '%SERVER:%'
	   SET @OUTPUT =  replace ( SUBSTRING(@TextDetails,charindex('SERVER:',@TextDetails) + LEN('SERVER:'), LEN(@TextDetails)), ']','')
	

	END 
    ELSE IF @type = 1  
	 BEGIN 
	 SET @OUTPUT =  SUBSTRING(@TextDetails,charindex('Login failed for user:',@TextDetails) + LEN('Login failed for user:'), LEN(@TextDetails)) 
	 SET @OUTPUT = left(@OUTPUT, charindex('.', @OUTPUT) - 1)
	 SET @OUTPUT = replace (@OUTPUT , '''','')
	 END 



	-- Add the T-SQL statements to compute the return value here
--	SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>

	-- Return the result of the function
	RETURN @OUTPUT

END

GO

-- --------------------------------------------------
-- INDEX dbo.ag_health_state
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_ag_health_state] ON [dbo].[ag_health_state] ([collection_time_utc], [replica_server_name], [database_name])

GO

-- --------------------------------------------------
-- INDEX dbo.alert_categories
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [ci_alert_categories] ON [dbo].[alert_categories] ([error_number], [error_severity])

GO

-- --------------------------------------------------
-- INDEX dbo.alert_history
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_alert_history] ON [dbo].[alert_history] ([collection_time_utc])

GO

-- --------------------------------------------------
-- INDEX dbo.db_size_daily_report
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXC_db_size_daily_report] ON [dbo].[db_size_daily_report] ([collection_time], [server_name], [database_name], [file_name])

GO

-- --------------------------------------------------
-- INDEX dbo.db_size_daily_report
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IXNC1_db_size_daily_report] ON [dbo].[db_size_daily_report] ([collection_time], [server_name], [file_drive])

GO

-- --------------------------------------------------
-- INDEX dbo.log_space_consumers
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_log_space_consumers] ON [dbo].[log_space_consumers] ([collection_time])

GO

-- --------------------------------------------------
-- INDEX dbo.os_task_list
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_os_task_list] ON [dbo].[os_task_list] ([collection_time_utc], [host_name], [task_name])

GO

-- --------------------------------------------------
-- INDEX dbo.performance_counters
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_performance_counters] ON [dbo].[performance_counters] ([collection_time_utc], [host_name], [object], [counter], [instance], [value])

GO

-- --------------------------------------------------
-- INDEX dbo.performance_counters
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [nci_counter_collection_time_utc] ON [dbo].[performance_counters] ([counter], [collection_time_utc])

GO

-- --------------------------------------------------
-- INDEX dbo.resource_consumption
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [uq_resource_consumption] ON [dbo].[resource_consumption] ([start_time], [event_time], [row_id])

GO

-- --------------------------------------------------
-- INDEX dbo.tempdb_space_consumers
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [CI_tempdb_space_consumers] ON [dbo].[tempdb_space_consumers] ([collection_time], [usage_rank])

GO

-- --------------------------------------------------
-- INDEX dbo.tempdb_space_usage
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [CI_tempdb_space_usage] ON [dbo].[tempdb_space_usage] ([collection_time])

GO

-- --------------------------------------------------
-- INDEX dbo.WhoIsActive
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_WhoIsActive] ON [dbo].[WhoIsActive] ([collection_time])

GO

-- --------------------------------------------------
-- INDEX dbo.xevent_metrics
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [uq_xevent_metrics] ON [dbo].[xevent_metrics] ([start_time], [event_time], [row_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Blitz
-- --------------------------------------------------
ALTER TABLE [dbo].[Blitz] ADD CONSTRAINT [pk_Blitz] PRIMARY KEY ([CheckDate], [ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BlitzFirst_WaitStats_Categories
-- --------------------------------------------------
ALTER TABLE [dbo].[BlitzFirst_WaitStats_Categories] ADD CONSTRAINT [PK__BlitzFir__98C9ED573FDFBA9A] PRIMARY KEY ([WaitType])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BlitzIndex
-- --------------------------------------------------
ALTER TABLE [dbo].[BlitzIndex] ADD CONSTRAINT [pk_BlitzIndex] PRIMARY KEY ([run_datetime], [id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BlitzIndex_Mode0
-- --------------------------------------------------
ALTER TABLE [dbo].[BlitzIndex_Mode0] ADD CONSTRAINT [pk_BlitzIndex_Mode0] PRIMARY KEY ([run_datetime], [id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BlitzIndex_Mode1
-- --------------------------------------------------
ALTER TABLE [dbo].[BlitzIndex_Mode1] ADD CONSTRAINT [pk_BlitzIndex_Mode1] PRIMARY KEY ([run_datetime], [id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BlitzIndex_Mode4
-- --------------------------------------------------
ALTER TABLE [dbo].[BlitzIndex_Mode4] ADD CONSTRAINT [pk_BlitzIndex_Mode4] PRIMARY KEY ([run_datetime], [id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.disk_space
-- --------------------------------------------------
ALTER TABLE [dbo].[disk_space] ADD CONSTRAINT [pk_disk_space] PRIMARY KEY ([collection_time_utc], [host_name], [disk_volume])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.file_io_stats
-- --------------------------------------------------
ALTER TABLE [dbo].[file_io_stats] ADD CONSTRAINT [pk_file_io_stats] PRIMARY KEY ([collection_time_utc], [database_id], [file_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.instance_details
-- --------------------------------------------------
ALTER TABLE [dbo].[instance_details] ADD CONSTRAINT [pk_instance_details] PRIMARY KEY ([sql_instance], [host_name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.instance_hosts
-- --------------------------------------------------
ALTER TABLE [dbo].[instance_hosts] ADD CONSTRAINT [pk_instance_hosts] PRIMARY KEY ([host_name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.memory_clerks
-- --------------------------------------------------
ALTER TABLE [dbo].[memory_clerks] ADD CONSTRAINT [pk_memory_clerks] PRIMARY KEY ([collection_time_utc], [memory_clerk])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.perfmon_files
-- --------------------------------------------------
ALTER TABLE [dbo].[perfmon_files] ADD CONSTRAINT [pk_perfmon_files] PRIMARY KEY ([file_name], [collection_time_utc])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.purge_table
-- --------------------------------------------------
ALTER TABLE [dbo].[purge_table] ADD CONSTRAINT [pk_purge_table] PRIMARY KEY ([table_name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.resource_consumption
-- --------------------------------------------------
ALTER TABLE [dbo].[resource_consumption] ADD CONSTRAINT [pk_resource_consumption] PRIMARY KEY ([event_time], [start_time], [row_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.resource_consumption_Processed_XEL_Files
-- --------------------------------------------------
ALTER TABLE [dbo].[resource_consumption_Processed_XEL_Files] ADD CONSTRAINT [pk_resource_consumption_Processed_XEL_Files] PRIMARY KEY ([file_path], [collection_time_utc])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.resource_consumption_queries
-- --------------------------------------------------
ALTER TABLE [dbo].[resource_consumption_queries] ADD CONSTRAINT [pk_resource_consumption_queries] PRIMARY KEY ([event_time], [start_time], [row_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.server_privileged_info
-- --------------------------------------------------
ALTER TABLE [dbo].[server_privileged_info] ADD CONSTRAINT [pk_server_privileged_info] PRIMARY KEY ([collection_time_utc], [host_name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sql_agent_job_stats
-- --------------------------------------------------
ALTER TABLE [dbo].[sql_agent_job_stats] ADD CONSTRAINT [pk_sql_agent_job_stats] PRIMARY KEY ([JobName])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sql_agent_job_thresholds
-- --------------------------------------------------
ALTER TABLE [dbo].[sql_agent_job_thresholds] ADD CONSTRAINT [pk_sql_agent_job_thresholds] PRIMARY KEY ([JobName])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Backup_Details
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Backup_Details] ADD CONSTRAINT [PK_tbl_Backup_Details] PRIMARY KEY ([Collection_Time], [DatabaseID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.wait_stats
-- --------------------------------------------------
ALTER TABLE [dbo].[wait_stats] ADD CONSTRAINT [pk_wait_stats] PRIMARY KEY ([collection_time_utc], [wait_type])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.xevent_metrics
-- --------------------------------------------------
ALTER TABLE [dbo].[xevent_metrics] ADD CONSTRAINT [pk_xevent_metrics] PRIMARY KEY ([event_time], [start_time], [row_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.xevent_metrics_Processed_XEL_Files
-- --------------------------------------------------
ALTER TABLE [dbo].[xevent_metrics_Processed_XEL_Files] ADD CONSTRAINT [pk_xevent_metrics_Processed_XEL_Files] PRIMARY KEY ([file_path], [collection_time_utc])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.xevent_metrics_queries
-- --------------------------------------------------
ALTER TABLE [dbo].[xevent_metrics_queries] ADD CONSTRAINT [pk_xevent_metrics_queries] PRIMARY KEY ([event_time], [start_time], [row_id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CommandExecute
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[CommandExecute]

@DatabaseContext nvarchar(max),
@Command nvarchar(max),
@CommandType nvarchar(max),
@Mode int,
@Comment nvarchar(max) = NULL,
@DatabaseName nvarchar(max) = NULL,
@SchemaName nvarchar(max) = NULL,
@ObjectName nvarchar(max) = NULL,
@ObjectType nvarchar(max) = NULL,
@IndexName nvarchar(max) = NULL,
@IndexType int = NULL,
@StatisticsName nvarchar(max) = NULL,
@PartitionNumber int = NULL,
@ExtendedInfo xml = NULL,
@LockMessageSeverity int = 16,
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max),
@Execute nvarchar(max)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2022-12-03 17:23:44                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorMessageOriginal nvarchar(max)
  DECLARE @Severity int

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @sp_executesql nvarchar(max) = QUOTENAME(@DatabaseContext) + '.sys.sp_executesql'

  DECLARE @StartTime datetime2
  DECLARE @EndTime datetime2

  DECLARE @ID int

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @RevertCommand nvarchar(max)

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseContext IS NULL OR NOT EXISTS (SELECT * FROM sys.databases WHERE name = @DatabaseContext)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseContext is not supported.', 16, 1
  END

  IF @Command IS NULL OR @Command = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Command is not supported.', 16, 1
  END

  IF @CommandType IS NULL OR @CommandType = '' OR LEN(@CommandType) > 60
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CommandType is not supported.', 16, 1
  END

  IF @Mode NOT IN(1,2) OR @Mode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Mode is not supported.', 16, 1
  END

  IF @LockMessageSeverity NOT IN(10,16) OR @LockMessageSeverity IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute as user                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @ExecuteAsUser IS NOT NULL
  BEGIN
    SET @Command = 'EXECUTE AS USER = ''' + REPLACE(@ExecuteAsUser,'''','''''') + '''; ' + @Command + '; REVERT;'

    SET @RevertCommand = 'REVERT'
  END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = SYSDATETIME()

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Database context: ' + QUOTENAME(@DatabaseContext)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Command: ' + @Command
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  IF @Comment IS NOT NULL
  BEGIN
    SET @StartMessage = 'Comment: ' + @Comment
    RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT
  END

  IF @LogToTable = 'Y'
  BEGIN
    INSERT INTO dbo.CommandLog (DatabaseName, SchemaName, ObjectName, ObjectType, IndexName, IndexType, StatisticsName, PartitionNumber, ExtendedInfo, CommandType, Command, StartTime)
    VALUES (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber, @ExtendedInfo, @CommandType, @Command, @StartTime)
  END

  SET @ID = SCOPE_IDENTITY()

  ----------------------------------------------------------------------------------------------------
  --// Execute command                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @Mode = 1 AND @Execute = 'Y'
  BEGIN
    EXECUTE @sp_executesql @stmt = @Command
    SET @Error = @@ERROR
    SET @ReturnCode = @Error
  END

  IF @Mode = 2 AND @Execute = 'Y'
  BEGIN
    BEGIN TRY
      EXECUTE @sp_executesql @stmt = @Command
    END TRY
    BEGIN CATCH
      SET @Error = ERROR_NUMBER()
      SET @ErrorMessageOriginal = ERROR_MESSAGE()

      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
      RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT

      IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
      BEGIN
        SET @ReturnCode = ERROR_NUMBER()
      END

      IF @ExecuteAsUser IS NOT NULL
      BEGIN
        EXECUTE @sp_executesql @RevertCommand
      END
    END CATCH
  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  SET @EndTime = SYSDATETIME()

  SET @EndMessage = 'Outcome: ' + CASE WHEN @Execute = 'N' THEN 'Not Executed' WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Duration: ' + CASE WHEN (DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) > 0 THEN CAST((DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) AS nvarchar) + '.' ELSE '' END + CONVERT(nvarchar,DATEADD(SECOND,DATEDIFF(SECOND,@StartTime,@EndTime),'1900-01-01'),108)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,@EndTime,120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    UPDATE dbo.CommandLog
    SET EndTime = @EndTime,
        ErrorNumber = CASE WHEN @Execute = 'N' THEN NULL ELSE @Error END,
        ErrorMessage = @ErrorMessageOriginal
    WHERE ID = @ID
  END

  ReturnCode:
  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DatabaseBackup
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[DatabaseBackup]

@Databases nvarchar(max) = NULL,
@Directory nvarchar(max) = NULL,
@BackupType nvarchar(max),
@Verify nvarchar(max) = 'N',
@CleanupTime int = NULL,
@CleanupMode nvarchar(max) = 'AFTER_BACKUP',
@Compress nvarchar(max) = NULL,
@CopyOnly nvarchar(max) = 'N',
@ChangeBackupType nvarchar(max) = 'N',
@BackupSoftware nvarchar(max) = NULL,
@CheckSum nvarchar(max) = 'N',
@BlockSize int = NULL,
@BufferCount int = NULL,
@MaxTransferSize int = NULL,
@NumberOfFiles int = NULL,
@MinBackupSizeForMultipleFiles int = NULL,
@MaxFileSize int = NULL,
@CompressionLevel int = NULL,
@Description nvarchar(max) = NULL,
@Threads int = NULL,
@Throttle int = NULL,
@Encrypt nvarchar(max) = 'N',
@EncryptionAlgorithm nvarchar(max) = NULL,
@ServerCertificate nvarchar(max) = NULL,
@ServerAsymmetricKey nvarchar(max) = NULL,
@EncryptionKey nvarchar(max) = NULL,
@ReadWriteFileGroups nvarchar(max) = 'N',
@OverrideBackupPreference nvarchar(max) = 'N',
@NoRecovery nvarchar(max) = 'N',
@URL nvarchar(max) = NULL,
@Credential nvarchar(max) = NULL,
@MirrorDirectory nvarchar(max) = NULL,
@MirrorCleanupTime int = NULL,
@MirrorCleanupMode nvarchar(max) = 'AFTER_BACKUP',
@MirrorURL nvarchar(max) = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@Updateability nvarchar(max) = 'ALL',
@AdaptiveCompression nvarchar(max) = NULL,
@ModificationLevel int = NULL,
@LogSizeSinceLastLogBackup int = NULL,
@TimeSinceLastLogBackup int = NULL,
@DataDomainBoostHost nvarchar(max) = NULL,
@DataDomainBoostUser nvarchar(max) = NULL,
@DataDomainBoostDevicePath nvarchar(max) = NULL,
@DataDomainBoostLockboxPath nvarchar(max) = NULL,
@DirectoryStructure nvarchar(max) = '{ServerName}${InstanceName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@AvailabilityGroupDirectoryStructure nvarchar(max) = '{ClusterName}${AvailabilityGroupName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}{BackupType}_{Partial}_{CopyOnly}',
@FileName nvarchar(max) = '{ServerName}${InstanceName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@AvailabilityGroupFileName nvarchar(max) = '{ClusterName}${AvailabilityGroupName}_{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}',
@FileExtensionFull nvarchar(max) = NULL,
@FileExtensionDiff nvarchar(max) = NULL,
@FileExtensionLog nvarchar(max) = NULL,
@Init nvarchar(max) = 'N',
@Format nvarchar(max) = 'N',
@ObjectLevelRecoveryMap nvarchar(max) = 'N',
@ExcludeLogShippedFromLogBackup nvarchar(max) = 'Y',
@DirectoryCheck nvarchar(max) = 'Y',
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2022-12-03 17:23:44                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)
  DECLARE @DirectorySeparator nvarchar(max)

  DECLARE @Updated bit

  DECLARE @Cluster nvarchar(max)

  DECLARE @DefaultDirectory nvarchar(4000)

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentRootDirectoryID int
  DECLARE @CurrentRootDirectoryPath nvarchar(4000)

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)
  DECLARE @CurrentDatabaseSize bigint

  DECLARE @CurrentIsEncrypted bit

  DECLARE @CurrentBackupType nvarchar(max)
  DECLARE @CurrentMaxTransferSize int
  DECLARE @CurrentNumberOfFiles int
  DECLARE @CurrentFileExtension nvarchar(max)
  DECLARE @CurrentFileNumber int
  DECLARE @CurrentDifferentialBaseLSN numeric(25,0)
  DECLARE @CurrentDifferentialBaseIsSnapshot bit
  DECLARE @CurrentLogLSN numeric(25,0)
  DECLARE @CurrentLatestBackup datetime2
  DECLARE @CurrentDatabaseNameFS nvarchar(max)
  DECLARE @CurrentDirectoryStructure nvarchar(max)
  DECLARE @CurrentDatabaseFileName nvarchar(max)
  DECLARE @CurrentMaxFilePathLength nvarchar(max)
  DECLARE @CurrentFileName nvarchar(max)
  DECLARE @CurrentDirectoryID int
  DECLARE @CurrentDirectoryPath nvarchar(max)
  DECLARE @CurrentFilePath nvarchar(max)
  DECLARE @CurrentDate datetime2
  DECLARE @CurrentCleanupDate datetime2
  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentAvailabilityGroupBackupPreference nvarchar(max)
  DECLARE @CurrentIsPreferredBackupReplica bit
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)
  DECLARE @CurrentLogShippingRole nvarchar(max)

  DECLARE @CurrentBackupSetID int
  DECLARE @CurrentIsMirror bit
  DECLARE @CurrentLastLogBackup datetime2
  DECLARE @CurrentLogSizeSinceLastLogBackup float
  DECLARE @CurrentAllocatedExtentPageCount bigint
  DECLARE @CurrentModifiedExtentPageCount bigint

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @Directories TABLE (ID int PRIMARY KEY,
                              DirectoryPath nvarchar(max),
                              Mirror bit,
                              Completed bit)

  DECLARE @URLs TABLE (ID int PRIMARY KEY,
                       DirectoryPath nvarchar(max),
                       Mirror bit)

  DECLARE @DirectoryInfo TABLE (FileExists bit,
                                FileIsADirectory bit,
                                ParentDirectoryExists bit)

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseNameFS nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               StartPosition int,
                               DatabaseSize bigint,
                               LogSizeSinceLastLogBackup float,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @CurrentBackupOutput bit

  DECLARE @CurrentBackupSet TABLE (ID int IDENTITY PRIMARY KEY,
                                   Mirror bit,
                                   VerifyCompleted bit,
                                   VerifyOutput int)

  DECLARE @CurrentDirectories TABLE (ID int PRIMARY KEY,
                                     DirectoryPath nvarchar(max),
                                     Mirror bit,
                                     DirectoryNumber int,
                                     CleanupDate datetime2,
                                     CleanupMode nvarchar(max),
                                     CreateCompleted bit,
                                     CleanupCompleted bit,
                                     CreateOutput int,
                                     CleanupOutput int)

  DECLARE @CurrentURLs TABLE (ID int PRIMARY KEY,
                              DirectoryPath nvarchar(max),
                              Mirror bit,
                              DirectoryNumber int)

  DECLARE @CurrentFiles TABLE ([Type] nvarchar(max),
                               FilePath nvarchar(max),
                               Mirror bit)

  DECLARE @CurrentCleanupDates TABLE (CleanupDate datetime2,
                                      Mirror bit)

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @Directory = ' + ISNULL('''' + REPLACE(@Directory,'''','''''') + '''','NULL')
  SET @Parameters += ', @BackupType = ' + ISNULL('''' + REPLACE(@BackupType,'''','''''') + '''','NULL')
  SET @Parameters += ', @Verify = ' + ISNULL('''' + REPLACE(@Verify,'''','''''') + '''','NULL')
  SET @Parameters += ', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL')
  SET @Parameters += ', @CleanupMode = ' + ISNULL('''' + REPLACE(@CleanupMode,'''','''''') + '''','NULL')
  SET @Parameters += ', @Compress = ' + ISNULL('''' + REPLACE(@Compress,'''','''''') + '''','NULL')
  SET @Parameters += ', @CopyOnly = ' + ISNULL('''' + REPLACE(@CopyOnly,'''','''''') + '''','NULL')
  SET @Parameters += ', @ChangeBackupType = ' + ISNULL('''' + REPLACE(@ChangeBackupType,'''','''''') + '''','NULL')
  SET @Parameters += ', @BackupSoftware = ' + ISNULL('''' + REPLACE(@BackupSoftware,'''','''''') + '''','NULL')
  SET @Parameters += ', @CheckSum = ' + ISNULL('''' + REPLACE(@CheckSum,'''','''''') + '''','NULL')
  SET @Parameters += ', @BlockSize = ' + ISNULL(CAST(@BlockSize AS nvarchar),'NULL')
  SET @Parameters += ', @BufferCount = ' + ISNULL(CAST(@BufferCount AS nvarchar),'NULL')
  SET @Parameters += ', @MaxTransferSize = ' + ISNULL(CAST(@MaxTransferSize AS nvarchar),'NULL')
  SET @Parameters += ', @NumberOfFiles = ' + ISNULL(CAST(@NumberOfFiles AS nvarchar),'NULL')
  SET @Parameters += ', @MinBackupSizeForMultipleFiles = ' + ISNULL(CAST(@MinBackupSizeForMultipleFiles AS nvarchar),'NULL')
  SET @Parameters += ', @MaxFileSize = ' + ISNULL(CAST(@MaxFileSize AS nvarchar),'NULL')
  SET @Parameters += ', @CompressionLevel = ' + ISNULL(CAST(@CompressionLevel AS nvarchar),'NULL')
  SET @Parameters += ', @Description = ' + ISNULL('''' + REPLACE(@Description,'''','''''') + '''','NULL')
  SET @Parameters += ', @Threads = ' + ISNULL(CAST(@Threads AS nvarchar),'NULL')
  SET @Parameters += ', @Throttle = ' + ISNULL(CAST(@Throttle AS nvarchar),'NULL')
  SET @Parameters += ', @Encrypt = ' + ISNULL('''' + REPLACE(@Encrypt,'''','''''') + '''','NULL')
  SET @Parameters += ', @EncryptionAlgorithm = ' + ISNULL('''' + REPLACE(@EncryptionAlgorithm,'''','''''') + '''','NULL')
  SET @Parameters += ', @ServerCertificate = ' + ISNULL('''' + REPLACE(@ServerCertificate,'''','''''') + '''','NULL')
  SET @Parameters += ', @ServerAsymmetricKey = ' + ISNULL('''' + REPLACE(@ServerAsymmetricKey,'''','''''') + '''','NULL')
  SET @Parameters += ', @EncryptionKey = ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL')
  SET @Parameters += ', @ReadWriteFileGroups = ' + ISNULL('''' + REPLACE(@ReadWriteFileGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @OverrideBackupPreference = ' + ISNULL('''' + REPLACE(@OverrideBackupPreference,'''','''''') + '''','NULL')
  SET @Parameters += ', @NoRecovery = ' + ISNULL('''' + REPLACE(@NoRecovery,'''','''''') + '''','NULL')
  SET @Parameters += ', @URL = ' + ISNULL('''' + REPLACE(@URL,'''','''''') + '''','NULL')
  SET @Parameters += ', @Credential = ' + ISNULL('''' + REPLACE(@Credential,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorDirectory = ' + ISNULL('''' + REPLACE(@MirrorDirectory,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorCleanupTime = ' + ISNULL(CAST(@MirrorCleanupTime AS nvarchar),'NULL')
  SET @Parameters += ', @MirrorCleanupMode = ' + ISNULL('''' + REPLACE(@MirrorCleanupMode,'''','''''') + '''','NULL')
  SET @Parameters += ', @MirrorURL = ' + ISNULL('''' + REPLACE(@MirrorURL,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @Parameters += ', @AdaptiveCompression = ' + ISNULL('''' + REPLACE(@AdaptiveCompression,'''','''''') + '''','NULL')
  SET @Parameters += ', @ModificationLevel = ' + ISNULL(CAST(@ModificationLevel AS nvarchar),'NULL')
  SET @Parameters += ', @LogSizeSinceLastLogBackup = ' + ISNULL(CAST(@LogSizeSinceLastLogBackup AS nvarchar),'NULL')
  SET @Parameters += ', @TimeSinceLastLogBackup = ' + ISNULL(CAST(@TimeSinceLastLogBackup AS nvarchar),'NULL')
  SET @Parameters += ', @DataDomainBoostHost = ' + ISNULL('''' + REPLACE(@DataDomainBoostHost,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostUser = ' + ISNULL('''' + REPLACE(@DataDomainBoostUser,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostDevicePath = ' + ISNULL('''' + REPLACE(@DataDomainBoostDevicePath,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataDomainBoostLockboxPath = ' + ISNULL('''' + REPLACE(@DataDomainBoostLockboxPath,'''','''''') + '''','NULL')
  SET @Parameters += ', @DirectoryStructure = ' + ISNULL('''' + REPLACE(@DirectoryStructure,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupDirectoryStructure = ' + ISNULL('''' + REPLACE(@AvailabilityGroupDirectoryStructure,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileName = ' + ISNULL('''' + REPLACE(@FileName,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupFileName = ' + ISNULL('''' + REPLACE(@AvailabilityGroupFileName,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionFull = ' + ISNULL('''' + REPLACE(@FileExtensionFull,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionDiff = ' + ISNULL('''' + REPLACE(@FileExtensionDiff,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileExtensionLog = ' + ISNULL('''' + REPLACE(@FileExtensionLog,'''','''''') + '''','NULL')
  SET @Parameters += ', @Init = ' + ISNULL('''' + REPLACE(@Init,'''','''''') + '''','NULL')
  SET @Parameters += ', @Format = ' + ISNULL('''' + REPLACE(@Format,'''','''''') + '''','NULL')
  SET @Parameters += ', @ObjectLevelRecoveryMap = ' + ISNULL('''' + REPLACE(@ObjectLevelRecoveryMap,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExcludeLogShippedFromLogBackup = ' + ISNULL('''' + REPLACE(@ExcludeLogShippedFromLogBackup,'''','''''') + '''','NULL')
  SET @Parameters += ', @DirectoryCheck = ' + ISNULL('''' + REPLACE(@DirectoryCheck,'''','''''') + '''','NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  IF @AmazonRDS = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure DatabaseBackup is not supported on Amazon RDS.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseNameFS, DatabaseType, AvailabilityGroup, [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([name],'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|','')) AS DatabaseNameFS,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 0

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Check database names                                                                       //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @tmpDatabases
  WHERE Selected = 1
  AND DatabaseNameFS = ''
  ORDER BY DatabaseName ASC
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The names of the following databases are not supported: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 16, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @tmpDatabases
  WHERE UPPER(DatabaseNameFS) IN(SELECT UPPER(DatabaseNameFS) FROM @tmpDatabases GROUP BY UPPER(DatabaseNameFS) HAVING COUNT(*) > 1)
  AND UPPER(DatabaseNameFS) IN(SELECT UPPER(DatabaseNameFS) FROM @tmpDatabases WHERE Selected = 1)
  AND DatabaseNameFS <> ''
  ORDER BY DatabaseName ASC
  OPTION (RECOMPILE)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The names of the following databases are not unique in the file system: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select default directory                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Directory IS NULL AND @URL IS NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    IF @Version >= 15
    BEGIN
      SET @DefaultDirectory = CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS nvarchar(max))
    END
    ELSE
    BEGIN
      EXECUTE [master].dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', @DefaultDirectory OUTPUT
    END

    IF @DefaultDirectory LIKE 'http://%' OR @DefaultDirectory LIKE 'https://%'
    BEGIN
      SET @URL = @DefaultDirectory
    END
    ELSE
    BEGIN
      INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
      SELECT 1, @DefaultDirectory, 0, 0
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Select directories                                                                         //--
  ----------------------------------------------------------------------------------------------------

  SET @Directory = REPLACE(@Directory, CHAR(10), '')
  SET @Directory = REPLACE(@Directory, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Directory) > 0 SET @Directory = REPLACE(@Directory, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Directory) > 0 SET @Directory = REPLACE(@Directory, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Directory = LTRIM(RTRIM(@Directory));

  WITH Directories (StartPosition, EndPosition, Directory) AS
  (
  SELECT 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, 1), 0), LEN(@Directory) + 1) AS EndPosition,
          SUBSTRING(@Directory, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, 1), 0), LEN(@Directory) + 1) - 1) AS Directory
  WHERE @Directory IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) AS EndPosition,
          SUBSTRING(@Directory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Directory, EndPosition + 1), 0), LEN(@Directory) + 1) - EndPosition - 1) AS Directory
  FROM Directories
  WHERE EndPosition < LEN(@Directory) + 1
  )
  INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
  SELECT ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
          Directory,
          0,
          0
  FROM Directories
  OPTION (MAXRECURSION 0)

  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(10), '')
  SET @MirrorDirectory = REPLACE(@MirrorDirectory, CHAR(13), '')

  WHILE CHARINDEX(', ',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,', ',',')
  WHILE CHARINDEX(' ,',@MirrorDirectory) > 0 SET @MirrorDirectory = REPLACE(@MirrorDirectory,' ,',',')

  SET @MirrorDirectory = LTRIM(RTRIM(@MirrorDirectory));

  WITH Directories (StartPosition, EndPosition, Directory) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, 1), 0), LEN(@MirrorDirectory) + 1) - 1) AS Directory
  WHERE @MirrorDirectory IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) AS EndPosition,
         SUBSTRING(@MirrorDirectory, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorDirectory, EndPosition + 1), 0), LEN(@MirrorDirectory) + 1) - EndPosition - 1) AS Directory
  FROM Directories
  WHERE EndPosition < LEN(@MirrorDirectory) + 1
  )
  INSERT INTO @Directories (ID, DirectoryPath, Mirror, Completed)
  SELECT (SELECT COUNT(*) FROM @Directories) + ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
         Directory,
         1,
         0
  FROM Directories
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check directories                                                                          //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%' OR (DirectoryPath LIKE '/%/%' AND @HostPlatform = 'Linux') OR DirectoryPath = 'NUL') OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' '))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The number of directories for the parameters @Directory and @MirrorDirectory has to be the same.', 16, 3
  END

  IF (@Directory IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 8) OR (@Directory IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 4
  END

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath = 'NUL') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath <> 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Directory is not supported.', 16, 5
  END

  IF EXISTS (SELECT * FROM @Directories WHERE Mirror = 0 AND DirectoryPath = 'NUL') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Mirrored backup is not supported when backing up to NUL', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Directories WHERE Mirror = 1 AND (NOT (DirectoryPath LIKE '_:' OR DirectoryPath LIKE '_:\%' OR DirectoryPath LIKE '\\%\%' OR (DirectoryPath LIKE '/%/%' AND @HostPlatform = 'Linux')) OR DirectoryPath IS NULL OR LEFT(DirectoryPath,1) = ' ' OR RIGHT(DirectoryPath,1) = ' '))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @Directories GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 2
  END

  IF @BackupSoftware IN('SQLBACKUP','SQLSAFE') AND (SELECT COUNT(*) FROM @Directories WHERE Mirror = 1) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 4
  END

  IF @MirrorDirectory IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 8
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 5
  END

  IF @MirrorDirectory IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported.', 16, 6
  END

  IF (@BackupSoftware IS NULL AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1) AND SERVERPROPERTY('EngineEdition') <> 3)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorDirectory is not supported. Mirrored backup to disk is only available in Enterprise and Developer Edition.', 16, 8
  END

  ----------------------------------------------------------------------------------------------------

  IF NOT EXISTS (SELECT * FROM @Errors WHERE Severity >= 16) AND @DirectoryCheck = 'Y'
  BEGIN
    WHILE (1 = 1)
    BEGIN
      SELECT TOP 1 @CurrentRootDirectoryID = ID,
                   @CurrentRootDirectoryPath = DirectoryPath
      FROM @Directories
      WHERE Completed = 0
      AND DirectoryPath <> 'NUL'
      ORDER BY ID ASC

      IF @@ROWCOUNT = 0
      BEGIN
        BREAK
      END

      INSERT INTO @DirectoryInfo (FileExists, FileIsADirectory, ParentDirectoryExists)
      EXECUTE [master].dbo.xp_fileexist @CurrentRootDirectoryPath

      IF NOT EXISTS (SELECT * FROM @DirectoryInfo WHERE FileExists = 0 AND FileIsADirectory = 1 AND ParentDirectoryExists = 1)
      BEGIN
        INSERT INTO @Errors ([Message], Severity, [State])
        SELECT 'The directory ' + @CurrentRootDirectoryPath + ' does not exist.', 16, 1
      END

      UPDATE @Directories
      SET Completed = 1
      WHERE ID = @CurrentRootDirectoryID

      SET @CurrentRootDirectoryID = NULL
      SET @CurrentRootDirectoryPath = NULL

      DELETE FROM @DirectoryInfo
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Select URLs                                                                                //--
  ----------------------------------------------------------------------------------------------------

  SET @URL = REPLACE(@URL, CHAR(10), '')
  SET @URL = REPLACE(@URL, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @URL) > 0 SET @URL = REPLACE(@URL, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @URL) > 0 SET @URL = REPLACE(@URL, ' ' + @StringDelimiter, @StringDelimiter)

  SET @URL = LTRIM(RTRIM(@URL));

  WITH URLs (StartPosition, EndPosition, [URL]) AS
  (
  SELECT 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, 1), 0), LEN(@URL) + 1) AS EndPosition,
          SUBSTRING(@URL, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, 1), 0), LEN(@URL) + 1) - 1) AS [URL]
  WHERE @URL IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
          ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, EndPosition + 1), 0), LEN(@URL) + 1) AS EndPosition,
          SUBSTRING(@URL, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @URL, EndPosition + 1), 0), LEN(@URL) + 1) - EndPosition - 1) AS [URL]
  FROM URLs
  WHERE EndPosition < LEN(@URL) + 1
  )
  INSERT INTO @URLs (ID, DirectoryPath, Mirror)
  SELECT ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
          [URL],
          0
  FROM URLs
  OPTION (MAXRECURSION 0)

  SET @MirrorURL = REPLACE(@MirrorURL, CHAR(10), '')
  SET @MirrorURL = REPLACE(@MirrorURL, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @MirrorURL) > 0 SET @MirrorURL = REPLACE(@MirrorURL, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter ,@MirrorURL) > 0 SET @MirrorURL = REPLACE(@MirrorURL, ' ' + @StringDelimiter, @StringDelimiter)

  SET @MirrorURL = LTRIM(RTRIM(@MirrorURL));

  WITH URLs (StartPosition, EndPosition, [URL]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, 1), 0), LEN(@MirrorURL) + 1) AS EndPosition,
         SUBSTRING(@MirrorURL, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, 1), 0), LEN(@MirrorURL) + 1) - 1) AS [URL]
  WHERE @MirrorURL IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, EndPosition + 1), 0), LEN(@MirrorURL) + 1) AS EndPosition,
         SUBSTRING(@MirrorURL, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @MirrorURL, EndPosition + 1), 0), LEN(@MirrorURL) + 1) - EndPosition - 1) AS [URL]
  FROM URLs
  WHERE EndPosition < LEN(@MirrorURL) + 1
  )
  INSERT INTO @URLs (ID, DirectoryPath, Mirror)
  SELECT (SELECT COUNT(*) FROM @URLs) + ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS ID,
         [URL],
         1
  FROM URLs
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check URLs                                                                          //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @URLs WHERE Mirror = 0 AND DirectoryPath NOT LIKE 'https://%/%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @URLs GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @URLs WHERE Mirror = 1 AND DirectoryPath NOT LIKE 'https://%/%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @URLs GROUP BY DirectoryPath HAVING COUNT(*) <> 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 2
  END

  IF (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) <> (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) AND (SELECT COUNT(*) FROM @URLs WHERE Mirror = 1) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Get directory separator                                                                   //--
  ----------------------------------------------------------------------------------------------------

  SELECT @DirectorySeparator = CASE
  WHEN @URL IS NOT NULL THEN '/'
  WHEN @HostPlatform = 'Windows' THEN '\'
  WHEN @HostPlatform = 'Linux' THEN '/'
  END

  UPDATE @Directories
  SET DirectoryPath = LEFT(DirectoryPath,LEN(DirectoryPath) - 1)
  WHERE RIGHT(DirectoryPath,1) = @DirectorySeparator

  UPDATE @URLs
  SET DirectoryPath = LEFT(DirectoryPath,LEN(DirectoryPath) - 1)
  WHERE RIGHT(DirectoryPath,1) = @DirectorySeparator

  ----------------------------------------------------------------------------------------------------
  --// Get file extension                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionFull IS NULL
  BEGIN
    SELECT @FileExtensionFull = CASE
    WHEN @BackupSoftware IS NULL THEN 'bak'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'bak'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  IF @FileExtensionDiff IS NULL
  BEGIN
    SELECT @FileExtensionDiff = CASE
    WHEN @BackupSoftware IS NULL THEN 'bak'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'bak'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  IF @FileExtensionLog IS NULL
  BEGIN
    SELECT @FileExtensionLog = CASE
    WHEN @BackupSoftware IS NULL THEN 'trn'
    WHEN @BackupSoftware = 'LITESPEED' THEN 'trn'
    WHEN @BackupSoftware = 'SQLBACKUP' THEN 'sqb'
    WHEN @BackupSoftware = 'SQLSAFE' THEN 'safe'
    END
  END

  ----------------------------------------------------------------------------------------------------
  --// Get default compression                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF @Compress IS NULL
  BEGIN
    SELECT @Compress = CASE WHEN @BackupSoftware IS NULL AND EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'Y'
                            WHEN @BackupSoftware IS NULL AND NOT EXISTS(SELECT * FROM sys.configurations WHERE name = 'backup compression default' AND value_in_use = 1) THEN 'N'
                            WHEN @BackupSoftware IS NOT NULL AND (@CompressionLevel IS NULL OR @CompressionLevel > 0)  THEN 'Y'
                            WHEN @BackupSoftware IS NOT NULL AND @CompressionLevel = 0  THEN 'N' END
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @BackupType NOT IN ('FULL','DIFF','LOG') OR @BackupType IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupType is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF SERVERPROPERTY('EngineEdition') = 8 AND NOT (@BackupType = 'FULL' AND @CopyOnly = 'Y')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'SQL Database Managed Instance only supports COPY_ONLY full backups.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Verify NOT IN ('Y','N') OR @Verify IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported.', 16, 1
  END

  IF @BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND @Verify = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported with encrypted backups with Idera SQL Safe Backup', 16, 2
  END

  IF @Verify = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported with Data Domain Boost', 16, 3
  END

  IF @Verify = 'Y' AND EXISTS(SELECT * FROM @Directories WHERE DirectoryPath = 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Verify is not supported. Verify is not supported when backing up to NUL.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @CleanupTime < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported.', 16, 1
  END

  IF @CleanupTime IS NOT NULL AND @URL IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported on Azure Blob Storage.', 16, 2
  END

  IF @CleanupTime IS NOT NULL AND EXISTS(SELECT * FROM @Directories WHERE DirectoryPath = 'NUL')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported when backing up to NUL.', 16, 4
  END

  IF @CleanupTime IS NOT NULL AND ((@DirectoryStructure NOT LIKE '%{DatabaseName}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{DatabaseName}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {DatabaseName} is not part of the directory.', 16, 5
  END

  IF @CleanupTime IS NOT NULL AND ((@DirectoryStructure NOT LIKE '%{BackupType}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{BackupType}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {BackupType} is not part of the directory.', 16, 6
  END

  IF @CleanupTime IS NOT NULL AND @CopyOnly = 'Y' AND ((@DirectoryStructure NOT LIKE '%{CopyOnly}%' OR @DirectoryStructure IS NULL) OR (SERVERPROPERTY('IsHadrEnabled') = 1 AND (@AvailabilityGroupDirectoryStructure NOT LIKE '%{CopyOnly}%' OR @AvailabilityGroupDirectoryStructure IS NULL)))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupTime is not supported. Cleanup is not supported if the token {CopyOnly} is not part of the directory.', 16, 7
  END

  ----------------------------------------------------------------------------------------------------

  IF @CleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @CleanupMode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CleanupMode is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Compress NOT IN ('Y','N') OR @Compress IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 1
  END

  IF @Compress = 'Y' AND @BackupSoftware IS NULL AND NOT ((@Version >= 10 AND @Version < 10.5 AND SERVERPROPERTY('EngineEdition') = 3) OR (@Version >= 10.5 AND (SERVERPROPERTY('EngineEdition') IN (3, 8) OR SERVERPROPERTY('EditionID') IN (-1534726760, 284895786))))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported. Backup compression is not supported in this version and edition of SQL Server.', 16, 2
  END

  IF @Compress = 'N' AND @BackupSoftware IN ('LITESPEED','SQLBACKUP','SQLSAFE') AND (@CompressionLevel IS NULL OR @CompressionLevel >= 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 3
  END

  IF @Compress = 'Y' AND @BackupSoftware IN ('LITESPEED','SQLBACKUP','SQLSAFE') AND @CompressionLevel = 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Compress is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @CopyOnly NOT IN ('Y','N') OR @CopyOnly IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CopyOnly is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @ChangeBackupType NOT IN ('Y','N') OR @ChangeBackupType IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ChangeBackupType is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @BackupSoftware NOT IN ('LITESPEED','SQLBACKUP','SQLSAFE','DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupSoftware is not supported.', 16, 1
  END

  IF @BackupSoftware IS NOT NULL AND @HostPlatform = 'Linux'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BackupSoftware is not supported. Only native backups are supported on Linux', 16, 2
  END

  IF @BackupSoftware = 'LITESPEED' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_backup_database')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'LiteSpeed for SQL Server is not installed. Download https://www.quest.com/products/litespeed-for-sql-server/.', 16, 3
  END

  IF @BackupSoftware = 'SQLBACKUP' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'sqlbackup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Red Gate SQL Backup Pro is not installed. Download https://www.red-gate.com/products/dba/sql-backup/.', 16, 4
  END

  IF @BackupSoftware = 'SQLSAFE' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'X' AND [name] = 'xp_ss_backup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Idera SQL Safe Backup is not installed. Download https://www.idera.com/productssolutions/sqlserver/sqlsafebackup.', 16, 5
  END

  IF @BackupSoftware = 'DATA_DOMAIN_BOOST' AND NOT EXISTS (SELECT * FROM [master].sys.objects WHERE [type] = 'PC' AND [name] = 'emc_run_backup')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'EMC Data Domain Boost is not installed. Download https://www.emc.com/en-us/data-protection/data-domain.htm.', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF @CheckSum NOT IN ('Y','N') OR @CheckSum IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckSum is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @BlockSize NOT IN (512,1024,2048,4096,8192,16384,32768,65536)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported.', 16, 1
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Redgate SQL Backup Pro', 16, 2
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Idera SQL Safe', 16, 3
  END

  IF @BlockSize IS NOT NULL AND @URL IS NOT NULL AND @Credential IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'BLOCKSIZE is not supported when backing up to URL with page blobs. See https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url', 16, 4
  END

  IF @BlockSize IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BlockSize is not supported. This parameter is not supported with Data Domain Boost', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @BufferCount <= 0 OR @BufferCount > 2147483647
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 1
  END

  IF @BufferCount IS NOT NULL AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 2
  END

  IF @BufferCount IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @BufferCount is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxTransferSize < 65536 OR @MaxTransferSize > 4194304
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 1
  END

  IF @MaxTransferSize > 1048576 AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 2
  END

  IF @MaxTransferSize IS NOT NULL AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 3
  END

  IF @MaxTransferSize IS NOT NULL AND @URL IS NOT NULL AND @Credential IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'MAXTRANSFERSIZE is not supported when backing up to URL with page blobs. See https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url', 16, 4
  END

  IF @MaxTransferSize IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxTransferSize is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @NumberOfFiles < 1 OR @NumberOfFiles > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 1
  END

  IF @NumberOfFiles > 32 AND @BackupSoftware = 'SQLBACKUP'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 2
  END

  IF @NumberOfFiles < (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 3
  END

  IF @NumberOfFiles % (SELECT NULLIF(COUNT(*),0) FROM @Directories WHERE Mirror = 0) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 4
  END

  IF @URL IS NOT NULL AND @Credential IS NOT NULL AND @NumberOfFiles <> 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'Backup striping to URL with page blobs is not supported. See https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url', 16, 5
  END

  IF @NumberOfFiles > 1 AND @BackupSoftware IN('SQLBACKUP','SQLSAFE') AND EXISTS(SELECT * FROM @Directories WHERE Mirror = 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 6
  END

  IF @NumberOfFiles > 32 AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 7
  END

  IF @NumberOfFiles < (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 8
  END

  IF @NumberOfFiles % (SELECT NULLIF(COUNT(*),0) FROM @URLs WHERE Mirror = 0) > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NumberOfFiles is not supported.', 16, 9
  END

    ----------------------------------------------------------------------------------------------------

  IF @MinBackupSizeForMultipleFiles <= 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported.', 16, 1
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @NumberOfFiles IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. This parameter can only be used together with @NumberOfFiles.', 16, 2
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @BackupType = 'DIFF' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. The column sys.dm_db_file_space_usage.modified_extent_page_count is not available in this version of SQL Server.', 16, 3
  END

  IF @MinBackupSizeForMultipleFiles IS NOT NULL AND @BackupType = 'LOG' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinBackupSizeForMultipleFiles is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxFileSize <= 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported.', 16, 1
  END

  IF @MaxFileSize IS NOT NULL AND @NumberOfFiles IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @MaxFileSize and @NumberOfFiles cannot be used together.', 16, 2
  END

  IF @MaxFileSize IS NOT NULL AND @BackupType = 'DIFF' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported. The column sys.dm_db_file_space_usage.modified_extent_page_count is not available in this version of SQL Server.', 16, 3
  END

  IF @MaxFileSize IS NOT NULL AND @BackupType = 'LOG' AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxFileSize is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF (@BackupSoftware IS NULL AND @CompressionLevel IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND (@CompressionLevel < 0  OR @CompressionLevel > 8)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND (@CompressionLevel < 0 OR @CompressionLevel > 4)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND (@CompressionLevel < 1 OR @CompressionLevel > 4)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 4
  END

  IF @CompressionLevel IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CompressionLevel is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF LEN(@Description) > 255
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND LEN(@Description) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 2
  END

  IF @BackupSoftware = 'DATA_DOMAIN_BOOST' AND LEN(@Description) > 254
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Description is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @Threads IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED','SQLBACKUP','SQLSAFE') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND (@Threads < 1 OR @Threads > 32)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND (@Threads < 2 OR @Threads > 32)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND (@Threads < 1 OR @Threads > 64)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Threads is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @Throttle < 1 OR @Throttle > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Throttle is not supported.', 16, 1
  END

  IF @Throttle IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Throttle is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @Encrypt NOT IN('Y','N') OR @Encrypt IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 1
  END

  IF @Encrypt = 'Y' AND @BackupSoftware IS NULL AND NOT (@Version >= 12 AND (SERVERPROPERTY('EngineEdition') = 3) OR SERVERPROPERTY('EditionID') IN(-1534726760, 284895786))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 2
  END

  IF @Encrypt = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Encrypt is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_192','AES_256','TRIPLE_DES_3KEY') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 1
  END

  IF @BackupSoftware = 'LITESPEED' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('RC2_40','RC2_56','RC2_112','RC2_128','TRIPLE_DES_3KEY','RC4_128','AES_128','AES_192','AES_256') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 2
  END

  IF @BackupSoftware = 'SQLBACKUP' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 3
  END

  IF @BackupSoftware = 'SQLSAFE' AND @Encrypt = 'Y' AND (@EncryptionAlgorithm NOT IN('AES_128','AES_256') OR @EncryptionAlgorithm IS NULL)
  OR (@EncryptionAlgorithm IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 4
  END

  IF @EncryptionAlgorithm IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionAlgorithm is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF (NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerCertificate IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 1
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NULL AND @ServerAsymmetricKey IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 2
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL AND @ServerAsymmetricKey IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 3
  END

  IF @ServerCertificate IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.certificates WHERE name = @ServerCertificate)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerCertificate is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF NOT (@BackupSoftware IS NULL AND @Encrypt = 'Y') AND @ServerAsymmetricKey IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 1
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NULL AND @ServerCertificate IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 2
  END

  IF @BackupSoftware IS NULL AND @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL AND @ServerCertificate IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 3
  END

  IF @ServerAsymmetricKey IS NOT NULL AND NOT EXISTS(SELECT * FROM master.sys.asymmetric_keys WHERE name = @ServerAsymmetricKey)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ServerAsymmetricKey is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @EncryptionKey IS NOT NULL AND @BackupSoftware IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 1
  END

  IF @EncryptionKey IS NOT NULL AND @Encrypt = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 2
  END

  IF @EncryptionKey IS NULL AND @Encrypt = 'Y' AND @BackupSoftware IN('LITESPEED','SQLBACKUP','SQLSAFE')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 3
  END

  IF @EncryptionKey IS NOT NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @EncryptionKey is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @ReadWriteFileGroups NOT IN('Y','N') OR @ReadWriteFileGroups IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ReadWriteFileGroups is not supported.', 16, 1
  END

  IF @ReadWriteFileGroups = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ReadWriteFileGroups is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @OverrideBackupPreference NOT IN('Y','N') OR @OverrideBackupPreference IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @OverrideBackupPreference is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @NoRecovery NOT IN('Y','N') OR @NoRecovery IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 1
  END

  IF @NoRecovery = 'Y' AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 2
  END

  IF @NoRecovery = 'Y' AND @BackupSoftware = 'SQLSAFE'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoRecovery is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @URL IS NOT NULL AND @Directory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 1
  END

  IF @URL IS NOT NULL AND @MirrorDirectory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 2
  END

  IF @URL IS NOT NULL AND @Version < 11.03339
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 3
  END

  IF @URL IS NOT NULL AND @BackupSoftware IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @URL is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @Credential IS NULL AND @URL IS NOT NULL AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') = 8)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 1
  END

  IF @Credential IS NOT NULL AND @URL IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 2
  END

  IF @URL IS NOT NULL AND @Credential IS NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE UPPER(credential_identity) = 'SHARED ACCESS SIGNATURE')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 3
  END

  IF @Credential IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.credentials WHERE name = @Credential)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Credential is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorCleanupTime < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupTime is not supported.', 16, 1
  END

  IF @MirrorCleanupTime IS NOT NULL AND @MirrorDirectory IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupTime is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorCleanupMode NOT IN('BEFORE_BACKUP','AFTER_BACKUP') OR @MirrorCleanupMode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorCleanupMode is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MirrorURL IS NOT NULL AND @Directory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 1
  END

  IF @MirrorURL IS NOT NULL AND @MirrorDirectory IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 2
  END

  IF @MirrorURL IS NOT NULL AND @Version < 11.03339
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 3
  END

  IF @MirrorURL IS NOT NULL AND @BackupSoftware IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 4
  END

  IF @MirrorURL IS NOT NULL AND @URL IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MirrorURL is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Updateability is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @AdaptiveCompression NOT IN('SIZE','SPEED')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AdaptiveCompression is not supported.', 16, 1
  END

  IF @AdaptiveCompression IS NOT NULL AND (@BackupSoftware NOT IN('LITESPEED') OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AdaptiveCompression is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @ModificationLevel IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ModificationLevel is not supported.', 16, 1
  END

  IF @ModificationLevel IS NOT NULL AND @ChangeBackupType = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @ModificationLevel can only be used together with @ChangeBackupType = ''Y''.', 16, 2
  END

  IF @ModificationLevel IS NOT NULL AND @BackupType <> 'DIFF'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @ModificationLevel can only be used for differential backups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogSizeSinceLastLogBackup IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogSizeSinceLastLogBackup is not supported.', 16, 1
  END

  IF @LogSizeSinceLastLogBackup IS NOT NULL AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogSizeSinceLastLogBackup is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeSinceLastLogBackup IS NOT NULL AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_backup_time')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeSinceLastLogBackup is not supported.', 16, 1
  END

  IF @TimeSinceLastLogBackup IS NOT NULL AND @BackupType <> 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeSinceLastLogBackup is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF (@TimeSinceLastLogBackup IS NOT NULL AND @LogSizeSinceLastLogBackup IS NULL) OR (@TimeSinceLastLogBackup IS NULL AND @LogSizeSinceLastLogBackup IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @TimeSinceLastLogBackup and @LogSizeSinceLastLogBackup can only be used together.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostHost IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostHost is not supported.', 16, 1
  END

  IF @DataDomainBoostHost IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostHost is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostUser IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostUser is not supported.', 16, 1
  END

  IF @DataDomainBoostUser IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostUser is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostDevicePath IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostDevicePath is not supported.', 16, 1
  END

  IF @DataDomainBoostDevicePath IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostDevicePath is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataDomainBoostLockboxPath IS NOT NULL AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataDomainBoostLockboxPath is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DirectoryStructure = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DirectoryStructure is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroupDirectoryStructure = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupDirectoryStructure is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileName IS NULL OR @FileName = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 1
  END

  IF @FileName NOT LIKE '%.{FileExtension}'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 2
  END

  IF (@NumberOfFiles > 1 AND @FileName NOT LIKE '%{FileNumber}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 3
  END

  IF @FileName LIKE '%{DirectorySeparator}%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 4
  END

  IF @FileName LIKE '%/%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 5
  END

  IF @FileName LIKE '%\%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileName is not supported.', 16, 6
  END

  ----------------------------------------------------------------------------------------------------

  IF (SERVERPROPERTY('IsHadrEnabled') = 1 AND @AvailabilityGroupFileName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 1
  END

  IF @AvailabilityGroupFileName = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 2
  END

  IF @AvailabilityGroupFileName NOT LIKE '%.{FileExtension}'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 3
  END

  IF (@NumberOfFiles > 1 AND @AvailabilityGroupFileName NOT LIKE '%{FileNumber}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 4
  END

  IF @AvailabilityGroupFileName LIKE '%{DirectorySeparator}%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 5
  END

  IF @AvailabilityGroupFileName LIKE '%/%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 6
  END

  IF @AvailabilityGroupFileName LIKE '%\%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupFileName is not supported.', 16, 7
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@DirectoryStructure,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{MajorVersion}',''),'{MinorVersion}','') AS DirectoryStructure) Temp WHERE DirectoryStructure LIKE '%{%' OR DirectoryStructure LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @DirectoryStructure contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@AvailabilityGroupDirectoryStructure,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{MajorVersion}',''),'{MinorVersion}','') AS AvailabilityGroupDirectoryStructure) Temp WHERE AvailabilityGroupDirectoryStructure LIKE '%{%' OR AvailabilityGroupDirectoryStructure LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @AvailabilityGroupDirectoryStructure contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@FileName,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{FileNumber}',''),'{NumberOfFiles}',''),'{FileExtension}',''),'{MajorVersion}',''),'{MinorVersion}','') AS [FileName]) Temp WHERE [FileName] LIKE '%{%' OR [FileName] LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @FileName contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@AvailabilityGroupFileName,'{DirectorySeparator}',''),'{ServerName}',''),'{InstanceName}',''),'{ServiceName}',''),'{ClusterName}',''),'{AvailabilityGroupName}',''),'{DatabaseName}',''),'{BackupType}',''),'{Partial}',''),'{CopyOnly}',''),'{Description}',''),'{Year}',''),'{Month}',''),'{Day}',''),'{Week}',''),'{Hour}',''),'{Minute}',''),'{Second}',''),'{Millisecond}',''),'{Microsecond}',''),'{FileNumber}',''),'{NumberOfFiles}',''),'{FileExtension}',''),'{MajorVersion}',''),'{MinorVersion}','') AS AvailabilityGroupFileName) Temp WHERE AvailabilityGroupFileName LIKE '%{%' OR AvailabilityGroupFileName LIKE '%}%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameter @AvailabilityGroupFileName contains one or more tokens that are not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionFull LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionFull is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionDiff LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionDiff is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FileExtensionLog LIKE '%.%'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileExtensionLog is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Init NOT IN('Y','N') OR @Init IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 1
  END

  IF @Init = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 2
  END

  IF @Init = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Init is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @Format NOT IN('Y','N') OR @Format IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 1
  END

  IF @Format = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 2
  END

  IF @Format = 'Y' AND @BackupSoftware = 'DATA_DOMAIN_BOOST'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Format is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @ObjectLevelRecoveryMap NOT IN('Y','N') OR @ObjectLevelRecoveryMap IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 1
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupSoftware IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 2
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupSoftware <> 'LITESPEED'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 3
  END

  IF @ObjectLevelRecoveryMap = 'Y' AND @BackupType = 'LOG'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ObjectLevelRecovery is not supported.', 16, 4
  END

  ----------------------------------------------------------------------------------------------------

  IF @ExcludeLogShippedFromLogBackup NOT IN('Y','N') OR @ExcludeLogShippedFromLogBackup IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExcludeLogShippedFromLogBackup is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DirectoryCheck NOT IN('Y','N') OR @DirectoryCheck IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DirectoryCheck is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IN('LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC') AND NOT EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. The column sys.dm_db_log_stats.log_since_last_log_backup_mb is not available in this version of SQL Server.', 16, 2
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-backup.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check @@SERVERNAME                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @@SERVERNAME <> CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The @@SERVERNAME does not match SERVERPROPERTY(''ServerName''). See ' + CASE WHEN SERVERPROPERTY('IsClustered') = 0 THEN 'https://docs.microsoft.com/en-us/sql/database-engine/install-windows/rename-a-computer-that-hosts-a-stand-alone-instance-of-sql-server' WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'https://docs.microsoft.com/en-us/sql/sql-server/failover-clusters/install/rename-a-sql-server-failover-cluster-instance' END + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Check Availability Group cluster name                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    SELECT @Cluster = NULLIF(cluster_name,'')
    FROM sys.dm_hadr_cluster
  END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC','LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LogSizeSinceLastLogBackup = (SELECT log_since_last_log_backup_mb FROM sys.dm_db_log_stats(DB_ID(tmpDatabases.DatabaseName)))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'LOG_SIZE_SINCE_LAST_LOG_BACKUP_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LogSizeSinceLastLogBackup ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'LOG_SIZE_SINCE_LAST_LOG_BACKUP_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LogSizeSinceLastLogBackup DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute backup commands                                                                    //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName,
          @CurrentDatabaseNameFS = (SELECT DatabaseNameFS FROM @tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName)
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName,
                   @CurrentDatabaseNameFS = DatabaseNameFS
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
      BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc,
           @CurrentIsEncrypted = is_encrypted,
           @CurrentDatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = sys.databases.database_id)
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage =  'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage =  'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Encrypted: ' + CASE WHEN @CurrentIsEncrypted = 1 THEN 'Yes' WHEN @CurrentIsEncrypted = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentMaxTransferSize = CASE
    WHEN @MaxTransferSize IS NOT NULL THEN @MaxTransferSize
    WHEN @MaxTransferSize IS NULL AND @Compress = 'Y' AND @CurrentIsEncrypted = 1 AND @BackupSoftware IS NULL AND (@Version >= 13 AND @Version < 15.0404316) AND @Credential IS NULL THEN 65537
    END

    IF @CurrentDatabaseState = 'ONLINE' AND NOT (@CurrentInStandby = 1)
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name],
             @CurrentAvailabilityGroupBackupPreference = UPPER(automated_backup_preference_desc)
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1 AND @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SELECT @CurrentIsPreferredBackupReplica = sys.fn_hadr_backup_is_preferred_replica(@CurrentDatabaseName)
    END

    SELECT @CurrentDifferentialBaseLSN = differential_base_lsn
    FROM sys.master_files
    WHERE database_id = DB_ID(@CurrentDatabaseName)
    AND [type] = 0
    AND [file_id] = 1

    IF @CurrentDatabaseState = 'ONLINE' AND NOT (@CurrentInStandby = 1)
    BEGIN
      SELECT @CurrentLogLSN = last_log_backup_lsn
      FROM sys.database_recovery_status
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentDatabaseState = 'ONLINE' AND NOT (@CurrentInStandby = 1)
    AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
    AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL)
    AND (@BackupType IN('DIFF','FULL') OR (@ChangeBackupType = 'Y' AND @CurrentBackupType = 'LOG' AND @CurrentRecoveryModel IN('FULL','BULK_LOGGED') AND @CurrentLogLSN IS NULL AND @CurrentDatabaseName <> 'master'))
    AND (@ModificationLevel IS NOT NULL OR @MinBackupSizeForMultipleFiles IS NOT NULL OR @MaxFileSize IS NOT NULL)
    BEGIN
      SET @CurrentCommand = 'SELECT @ParamAllocatedExtentPageCount = SUM(allocated_extent_page_count), @ParamModifiedExtentPageCount = SUM(modified_extent_page_count) FROM sys.dm_db_file_space_usage'

      EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamAllocatedExtentPageCount bigint OUTPUT, @ParamModifiedExtentPageCount bigint OUTPUT', @ParamAllocatedExtentPageCount = @CurrentAllocatedExtentPageCount OUTPUT, @ParamModifiedExtentPageCount = @CurrentModifiedExtentPageCount OUTPUT
    END

    SET @CurrentBackupType = @BackupType

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'LOG' AND @CurrentRecoveryModel IN('FULL','BULK_LOGGED') AND @CurrentLogLSN IS NULL AND @CurrentDatabaseName <> 'master'
      BEGIN
        SET @CurrentBackupType = 'DIFF'
      END
      IF @CurrentBackupType = 'DIFF' AND (@CurrentDatabaseName = 'master' OR @CurrentDifferentialBaseLSN IS NULL OR (@CurrentModifiedExtentPageCount * 1. / @CurrentAllocatedExtentPageCount * 100 >= @ModificationLevel))
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END

    IF @CurrentDatabaseState = 'ONLINE' AND NOT (@CurrentInStandby = 1)
    AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
    BEGIN
      SELECT @CurrentLastLogBackup = log_backup_time,
             @CurrentLogSizeSinceLastLogBackup = log_since_last_log_backup_mb
      FROM sys.dm_db_log_stats (DB_ID(@CurrentDatabaseName))
    END

    IF @CurrentBackupType = 'DIFF'
    BEGIN
      SELECT @CurrentDifferentialBaseIsSnapshot = is_snapshot
      FROM msdb.dbo.backupset
      WHERE database_name = @CurrentDatabaseName
      AND [type] = 'D'
      AND checkpoint_lsn = @CurrentDifferentialBaseLSN
    END

    IF @ChangeBackupType = 'Y'
    BEGIN
      IF @CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseIsSnapshot = 1
      BEGIN
        SET @CurrentBackupType = 'FULL'
      END
    END;

    WITH CurrentDatabase AS
    (
    SELECT BackupSize = CASE WHEN @CurrentBackupType = 'FULL' THEN COALESCE(CAST(@CurrentAllocatedExtentPageCount AS bigint) * 8192, CAST(@CurrentDatabaseSize AS bigint) * 8192)
                             WHEN @CurrentBackupType = 'DIFF' THEN CAST(@CurrentModifiedExtentPageCount AS bigint) * 8192
                             WHEN @CurrentBackupType = 'LOG' THEN CAST(@CurrentLogSizeSinceLastLogBackup * 1024 * 1024 AS bigint)
                             END,
           MaxNumberOfFiles = CASE WHEN @BackupSoftware IN('SQLBACKUP','DATA_DOMAIN_BOOST') THEN 32 ELSE 64 END,
           CASE WHEN (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) > 0 THEN (SELECT COUNT(*) FROM @Directories WHERE Mirror = 0) ELSE (SELECT COUNT(*) FROM @URLs WHERE Mirror = 0) END AS NumberOfDirectories,
           CAST(@MinBackupSizeForMultipleFiles AS bigint) * 1024 * 1024 AS MinBackupSizeForMultipleFiles,
           CAST(@MaxFileSize AS bigint) * 1024 * 1024 AS MaxFileSize
    )
    SELECT @CurrentNumberOfFiles = CASE WHEN @NumberOfFiles IS NULL AND @BackupSoftware = 'DATA_DOMAIN_BOOST' THEN 1
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NULL THEN NumberOfDirectories
                                        WHEN @NumberOfFiles = 1 THEN @NumberOfFiles
                                        WHEN @NumberOfFiles > 1 AND (BackupSize >= MinBackupSizeForMultipleFiles OR MinBackupSizeForMultipleFiles IS NULL OR BackupSize IS NULL) THEN @NumberOfFiles
                                        WHEN @NumberOfFiles > 1 AND (BackupSize < MinBackupSizeForMultipleFiles) THEN NumberOfDirectories
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NOT NULL AND (BackupSize IS NULL OR BackupSize = 0) THEN NumberOfDirectories
                                        WHEN @NumberOfFiles IS NULL AND @MaxFileSize IS NOT NULL THEN (SELECT MIN(NumberOfFilesInEachDirectory)
                                                                                                       FROM (SELECT ((BackupSize / NumberOfDirectories) / MaxFileSize + CASE WHEN (BackupSize / NumberOfDirectories) % MaxFileSize = 0 THEN 0 ELSE 1 END) AS NumberOfFilesInEachDirectory
                                                                                                             UNION
                                                                                                             SELECT MaxNumberOfFiles / NumberOfDirectories) Files) * NumberOfDirectories
                                        END

    FROM CurrentDatabase

    SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
    FROM sys.database_mirroring
    WHERE database_id = DB_ID(@CurrentDatabaseName)

    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_primary_databases WHERE primary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'PRIMARY'
    END
    ELSE
    IF EXISTS (SELECT * FROM msdb.dbo.log_shipping_secondary_databases WHERE secondary_database = @CurrentDatabaseName)
    BEGIN
      SET @CurrentLogShippingRole = 'SECONDARY'
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group backup preference: ' + ISNULL(@CurrentAvailabilityGroupBackupPreference,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Is preferred backup replica: ' + CASE WHEN @CurrentIsPreferredBackupReplica = 1 THEN 'Yes' WHEN @CurrentIsPreferredBackupReplica = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentLogShippingRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Log shipping role: ' + @CurrentLogShippingRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SET @DatabaseMessage = 'Differential base LSN: ' + ISNULL(CAST(@CurrentDifferentialBaseLSN AS nvarchar),'N/A')
    RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

    IF @CurrentBackupType = 'DIFF' OR @CurrentDifferentialBaseIsSnapshot IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Differential base is snapshot: ' + CASE WHEN @CurrentDifferentialBaseIsSnapshot = 1 THEN 'Yes' WHEN @CurrentDifferentialBaseIsSnapshot = 0 THEN 'No' ELSE 'N/A' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SET @DatabaseMessage = 'Last log backup LSN: ' + ISNULL(CAST(@CurrentLogLSN AS nvarchar),'N/A')
    RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

    IF @CurrentBackupType IN('DIFF','FULL') AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_file_space_usage') AND name = 'modified_extent_page_count')
    BEGIN
      SET @DatabaseMessage = 'Allocated extent page count: ' + ISNULL(CAST(@CurrentAllocatedExtentPageCount AS nvarchar) + ' (' + CAST(@CurrentAllocatedExtentPageCount * 1. * 8 / 1024 AS nvarchar) + ' MB)','N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Modified extent page count: ' + ISNULL(CAST(@CurrentModifiedExtentPageCount AS nvarchar) + ' (' + CAST(@CurrentModifiedExtentPageCount * 1. * 8 / 1024 AS nvarchar) + ' MB)','N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentBackupType = 'LOG' AND EXISTS(SELECT * FROM sys.all_columns WHERE object_id = OBJECT_ID('sys.dm_db_log_stats') AND name = 'log_since_last_log_backup_mb')
    BEGIN
      SET @DatabaseMessage = 'Last log backup: ' + ISNULL(CONVERT(nvarchar(19),NULLIF(@CurrentLastLogBackup,'1900-01-01'),120),'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Log size since last log backup (MB): ' + ISNULL(CAST(@CurrentLogSizeSinceLastLogBackup AS nvarchar),'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND NOT (@CurrentInStandby = 1)
    AND NOT (@CurrentBackupType = 'LOG' AND @CurrentRecoveryModel = 'SIMPLE')
    AND NOT (@CurrentBackupType = 'LOG' AND @CurrentRecoveryModel IN('FULL','BULK_LOGGED') AND @CurrentLogLSN IS NULL)
    AND NOT (@CurrentBackupType = 'DIFF' AND @CurrentDifferentialBaseLSN IS NULL)
    AND NOT (@CurrentBackupType IN('DIFF','LOG') AND @CurrentDatabaseName = 'master')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'N' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'FULL' AND @CopyOnly = 'Y' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'DIFF' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'N' AND (@CurrentIsPreferredBackupReplica <> 1 OR @CurrentIsPreferredBackupReplica IS NULL) AND @OverrideBackupPreference = 'N')
    AND NOT (@CurrentAvailabilityGroup IS NOT NULL AND @CurrentBackupType = 'LOG' AND @CopyOnly = 'Y' AND (@CurrentAvailabilityGroupRole <> 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL))
    AND NOT ((@CurrentLogShippingRole = 'PRIMARY' AND @CurrentLogShippingRole IS NOT NULL) AND @CurrentBackupType = 'LOG' AND @ExcludeLogShippedFromLogBackup = 'Y')
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    AND NOT (@CurrentBackupType = 'LOG' AND @LogSizeSinceLastLogBackup IS NOT NULL AND @TimeSinceLastLogBackup IS NOT NULL AND NOT(@CurrentLogSizeSinceLastLogBackup >= @LogSizeSinceLastLogBackup OR @CurrentLogSizeSinceLastLogBackup IS NULL OR DATEDIFF(SECOND,@CurrentLastLogBackup,SYSDATETIME()) >= @TimeSinceLastLogBackup OR @CurrentLastLogBackup IS NULL))
    AND NOT (@CurrentBackupType = 'LOG' AND @Updateability = 'READ_ONLY' AND @BackupSoftware = 'DATA_DOMAIN_BOOST')
    BEGIN

      IF @CurrentBackupType = 'LOG' AND (@CleanupTime IS NOT NULL OR @MirrorCleanupTime IS NOT NULL)
      BEGIN
        SELECT @CurrentLatestBackup = MAX(backup_start_date)
        FROM msdb.dbo.backupset
        WHERE ([type] IN('D','I')
        OR ([type] = 'L' AND last_lsn < @CurrentDifferentialBaseLSN))
        AND is_damaged = 0
        AND [database_name] = @CurrentDatabaseName
      END

      SET @CurrentDate = SYSDATETIME()

      INSERT INTO @CurrentCleanupDates (CleanupDate)
      SELECT @CurrentDate

      IF @CurrentBackupType = 'LOG'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate)
        SELECT @CurrentLatestBackup
      END

      SELECT @CurrentDirectoryStructure = CASE
      WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @AvailabilityGroupDirectoryStructure
      ELSE @DirectoryStructure
      END

      IF @CurrentDirectoryStructure IS NOT NULL
      BEGIN
      -- Directory structure - remove tokens that are not needed
        IF @ReadWriteFileGroups = 'N' SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Partial}','')
        IF @CopyOnly = 'N' SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{CopyOnly}','')
        IF @Cluster IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}','')
        IF @CurrentAvailabilityGroup IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}','')
        IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}','')
        IF @@SERVICENAME IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServiceName}','')
        IF @Description IS NULL SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Description}','')

        IF @Directory IS NULL AND @MirrorDirectory IS NULL AND @URL IS NULL AND @DefaultDirectory LIKE '%' + '.' + @@SERVICENAME + @DirectorySeparator + 'MSSQL' + @DirectorySeparator + 'Backup'
        BEGIN
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServerName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}','')
          SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}','')
        END

        WHILE (@Updated = 1 OR @Updated IS NULL)
        BEGIN
          SET @Updated = 0

          IF CHARINDEX('\',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'\','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('/',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'/','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('__',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'__','_')
            SET @Updated = 1
          END

          IF CHARINDEX('--',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'--','-')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}$','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('${DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'${DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}_',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}_','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('_{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'_{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('{DirectorySeparator}-',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}-','{DirectorySeparator}')
            SET @Updated = 1
          END
          IF CHARINDEX('-{DirectorySeparator}',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'-{DirectorySeparator}','{DirectorySeparator}')
            SET @Updated = 1
          END

          IF CHARINDEX('_$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'_$','_')
            SET @Updated = 1
          END
          IF CHARINDEX('$_',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'$_','_')
            SET @Updated = 1
          END

          IF CHARINDEX('-$',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'-$','-')
            SET @Updated = 1
          END
          IF CHARINDEX('$-',@CurrentDirectoryStructure) > 0
          BEGIN
            SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'$-','-')
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '_'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '_'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '-'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '-'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,1) = '$'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,1) = '$'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 1)
            SET @Updated = 1
          END

          IF LEFT(@CurrentDirectoryStructure,20) = '{DirectorySeparator}'
          BEGIN
            SET @CurrentDirectoryStructure = RIGHT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 20)
            SET @Updated = 1
          END
          IF RIGHT(@CurrentDirectoryStructure,20) = '{DirectorySeparator}'
          BEGIN
            SET @CurrentDirectoryStructure = LEFT(@CurrentDirectoryStructure,LEN(@CurrentDirectoryStructure) - 20)
            SET @Updated = 1
          END
        END

        SET @Updated = NULL

        -- Directory structure - replace tokens with real values
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DirectorySeparator}',@DirectorySeparator)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServerName}',CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN LEFT(CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))) - 1) ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar(max)) END)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{InstanceName}',ISNULL(CAST(SERVERPROPERTY('InstanceName') AS nvarchar(max)),''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ServiceName}',ISNULL(@@SERVICENAME,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{ClusterName}',ISNULL(@Cluster,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{AvailabilityGroupName}',ISNULL(@CurrentAvailabilityGroup,''))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{DatabaseName}',@CurrentDatabaseNameFS)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{BackupType}',@CurrentBackupType)
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Partial}','PARTIAL')
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{CopyOnly}','COPY_ONLY')
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Description}',LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@Description,''),'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Year}',CAST(DATEPART(YEAR,@CurrentDate) AS nvarchar))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Month}',RIGHT('0' + CAST(DATEPART(MONTH,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Day}',RIGHT('0' + CAST(DATEPART(DAY,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Week}',RIGHT('0' + CAST(DATEPART(WEEK,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Hour}',RIGHT('0' + CAST(DATEPART(HOUR,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Minute}',RIGHT('0' + CAST(DATEPART(MINUTE,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Second}',RIGHT('0' + CAST(DATEPART(SECOND,@CurrentDate) AS nvarchar),2))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Millisecond}',RIGHT('00' + CAST(DATEPART(MILLISECOND,@CurrentDate) AS nvarchar),3))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{Microsecond}',RIGHT('00000' + CAST(DATEPART(MICROSECOND,@CurrentDate) AS nvarchar),6))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{MajorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMajorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),4)))
        SET @CurrentDirectoryStructure = REPLACE(@CurrentDirectoryStructure,'{MinorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMinorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),3)))
      END

      INSERT INTO @CurrentDirectories (ID, DirectoryPath, Mirror, DirectoryNumber, CreateCompleted, CleanupCompleted)
      SELECT ROW_NUMBER() OVER (ORDER BY ID),
             DirectoryPath + CASE WHEN DirectoryPath = 'NUL' THEN '' WHEN @CurrentDirectoryStructure IS NOT NULL THEN @DirectorySeparator + @CurrentDirectoryStructure ELSE '' END,
             Mirror,
             ROW_NUMBER() OVER (PARTITION BY Mirror ORDER BY ID ASC),
             0,
             0
      FROM @Directories
      ORDER BY ID ASC

      INSERT INTO @CurrentURLs (ID, DirectoryPath, Mirror, DirectoryNumber)
      SELECT ROW_NUMBER() OVER (ORDER BY ID),
             DirectoryPath + CASE WHEN @CurrentDirectoryStructure IS NOT NULL THEN @DirectorySeparator + @CurrentDirectoryStructure ELSE '' END,
             Mirror,
             ROW_NUMBER() OVER (PARTITION BY Mirror ORDER BY ID ASC)
      FROM @URLs
      ORDER BY ID ASC

      SELECT @CurrentDatabaseFileName = CASE
      WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @AvailabilityGroupFileName
      ELSE @FileName
      END

      -- File name - remove tokens that are not needed
      IF @ReadWriteFileGroups = 'N' SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Partial}','')
      IF @CopyOnly = 'N' SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{CopyOnly}','')
      IF @Cluster IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ClusterName}','')
      IF @CurrentAvailabilityGroup IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{AvailabilityGroupName}','')
      IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{InstanceName}','')
      IF @@SERVICENAME IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServiceName}','')
      IF @Description IS NULL SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Description}','')
      IF @CurrentNumberOfFiles = 1 SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{FileNumber}','')
      IF @CurrentNumberOfFiles = 1 SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{NumberOfFiles}','')

      WHILE (@Updated = 1 OR @Updated IS NULL)
      BEGIN
        SET @Updated = 0

        IF CHARINDEX('__',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'__','_')
          SET @Updated = 1
        END

        IF CHARINDEX('--',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'--','-')
          SET @Updated = 1
        END

        IF CHARINDEX('_$',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'_$','_')
          SET @Updated = 1
        END
        IF CHARINDEX('$_',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'$_','_')
          SET @Updated = 1
        END

        IF CHARINDEX('-$',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'-$','-')
          SET @Updated = 1
        END
        IF CHARINDEX('$-',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'$-','-')
          SET @Updated = 1
        END

        IF CHARINDEX('_.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'_.','.')
          SET @Updated = 1
        END

        IF CHARINDEX('-.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'-.','.')
          SET @Updated = 1
        END

        IF CHARINDEX('of.',@CurrentDatabaseFileName) > 0
        BEGIN
          SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'of.','.')
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '_'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '_'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '-'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '-'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END

        IF LEFT(@CurrentDatabaseFileName,1) = '$'
        BEGIN
          SET @CurrentDatabaseFileName = RIGHT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
        IF RIGHT(@CurrentDatabaseFileName,1) = '$'
        BEGIN
          SET @CurrentDatabaseFileName = LEFT(@CurrentDatabaseFileName,LEN(@CurrentDatabaseFileName) - 1)
          SET @Updated = 1
        END
      END

      SET @Updated = NULL

      SELECT @CurrentFileExtension = CASE
      WHEN @CurrentBackupType = 'FULL' THEN @FileExtensionFull
      WHEN @CurrentBackupType = 'DIFF' THEN @FileExtensionDiff
      WHEN @CurrentBackupType = 'LOG' THEN @FileExtensionLog
      END

      -- File name - replace tokens with real values
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServerName}',CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN LEFT(CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))) - 1) ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar(max)) END)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{InstanceName}',ISNULL(CAST(SERVERPROPERTY('InstanceName') AS nvarchar(max)),''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ServiceName}',ISNULL(@@SERVICENAME,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{ClusterName}',ISNULL(@Cluster,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{AvailabilityGroupName}',ISNULL(@CurrentAvailabilityGroup,''))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{BackupType}',@CurrentBackupType)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Partial}','PARTIAL')
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{CopyOnly}','COPY_ONLY')
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Description}',LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ISNULL(@Description,''),'\',''),'/',''),':',''),'*',''),'?',''),'"',''),'<',''),'>',''),'|',''))))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Year}',CAST(DATEPART(YEAR,@CurrentDate) AS nvarchar))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Month}',RIGHT('0' + CAST(DATEPART(MONTH,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Day}',RIGHT('0' + CAST(DATEPART(DAY,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Week}',RIGHT('0' + CAST(DATEPART(WEEK,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Hour}',RIGHT('0' + CAST(DATEPART(HOUR,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Minute}',RIGHT('0' + CAST(DATEPART(MINUTE,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Second}',RIGHT('0' + CAST(DATEPART(SECOND,@CurrentDate) AS nvarchar),2))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Millisecond}',RIGHT('00' + CAST(DATEPART(MILLISECOND,@CurrentDate) AS nvarchar),3))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{Microsecond}',RIGHT('00000' + CAST(DATEPART(MICROSECOND,@CurrentDate) AS nvarchar),6))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{NumberOfFiles}',@CurrentNumberOfFiles)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{FileExtension}',@CurrentFileExtension)
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{MajorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMajorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),4)))
      SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{MinorVersion}',ISNULL(CAST(SERVERPROPERTY('ProductMinorVersion') AS nvarchar),PARSENAME(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar),3)))

      SELECT @CurrentMaxFilePathLength = CASE
      WHEN EXISTS (SELECT * FROM @CurrentDirectories) THEN (SELECT MAX(LEN(DirectoryPath + @DirectorySeparator)) FROM @CurrentDirectories)
      WHEN EXISTS (SELECT * FROM @CurrentURLs) THEN (SELECT MAX(LEN(DirectoryPath + @DirectorySeparator)) FROM @CurrentURLs)
      END
      + LEN(REPLACE(REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',@CurrentDatabaseNameFS), '{FileNumber}', CASE WHEN @CurrentNumberOfFiles >= 1 AND @CurrentNumberOfFiles <= 9 THEN '1' WHEN @CurrentNumberOfFiles >= 10 THEN '01' END))

      -- The maximum length of a backup device is 259 characters
      IF @CurrentMaxFilePathLength > 259
      BEGIN
        SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',LEFT(@CurrentDatabaseNameFS,CASE WHEN (LEN(@CurrentDatabaseNameFS) + 259 - @CurrentMaxFilePathLength - 3) < 20 THEN 20 ELSE (LEN(@CurrentDatabaseNameFS) + 259 - @CurrentMaxFilePathLength - 3) END) + '...')
      END
      ELSE
      BEGIN
        SET @CurrentDatabaseFileName = REPLACE(@CurrentDatabaseFileName,'{DatabaseName}',@CurrentDatabaseNameFS)
      END

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 0)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 0)
          AND Mirror = 0

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles >= 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) END)

          IF @CurrentDirectoryPath = 'NUL'
          BEGIN
            SET @CurrentFilePath = 'NUL'
          END
          ELSE
          BEGIN
            SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName
          END

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 0

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END

      IF EXISTS (SELECT * FROM @CurrentDirectories WHERE Mirror = 1)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentDirectories WHERE Mirror = 1)
          AND Mirror = 1

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'DISK', @CurrentFilePath, 1

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 1, 0
      END

      IF EXISTS (SELECT * FROM @CurrentURLs WHERE Mirror = 0)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentURLs
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0)
          AND Mirror = 0

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'URL', @CurrentFilePath, 0

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 0, 0
      END

      IF EXISTS (SELECT * FROM @CurrentURLs WHERE Mirror = 1)
      BEGIN
        SET @CurrentFileNumber = 0

        WHILE @CurrentFileNumber < @CurrentNumberOfFiles
        BEGIN
          SET @CurrentFileNumber = @CurrentFileNumber + 1

          SELECT @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentURLs
          WHERE @CurrentFileNumber >= (DirectoryNumber - 1) * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0) + 1
          AND @CurrentFileNumber <= DirectoryNumber * (SELECT @CurrentNumberOfFiles / COUNT(*) FROM @CurrentURLs WHERE Mirror = 0)
          AND Mirror = 1

          SET @CurrentFileName = REPLACE(@CurrentDatabaseFileName, '{FileNumber}', CASE WHEN @CurrentNumberOfFiles > 1 AND @CurrentNumberOfFiles <= 9 THEN CAST(@CurrentFileNumber AS nvarchar) WHEN @CurrentNumberOfFiles >= 10 THEN RIGHT('0' + CAST(@CurrentFileNumber AS nvarchar),2) ELSE '' END)

          SET @CurrentFilePath = @CurrentDirectoryPath + @DirectorySeparator + @CurrentFileName

          INSERT INTO @CurrentFiles ([Type], FilePath, Mirror)
          SELECT 'URL', @CurrentFilePath, 1

          SET @CurrentDirectoryPath = NULL
          SET @CurrentFileName = NULL
          SET @CurrentFilePath = NULL
        END

        INSERT INTO @CurrentBackupSet (Mirror, VerifyCompleted)
        SELECT 1, 0
      END

      -- Create directory
      IF @HostPlatform = 'Windows'
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND NOT EXISTS(SELECT * FROM @CurrentDirectories WHERE DirectoryPath = 'NUL' OR DirectoryPath IN(SELECT DirectoryPath FROM @Directories))
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath
          FROM @CurrentDirectories
          WHERE CreateCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'xp_create_subdir'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_create_subdir N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''' IF @ReturnCode <> 0 RAISERROR(''Error creating directory.'', 16, 1)'

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CreateCompleted = 1,
              CreateOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      IF @CleanupMode = 'BEFORE_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),SYSDATETIME()), 0

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 0 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 0 OR Mirror IS NULL)),
              CleanupMode = 'BEFORE_BACKUP'
          WHERE Mirror = 0
        END
      END

      IF @MirrorCleanupMode = 'BEFORE_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@MirrorCleanupTime),SYSDATETIME()), 1

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 1 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 1 OR Mirror IS NULL)),
              CleanupMode = 'BEFORE_BACKUP'
          WHERE Mirror = 1
        END
      END

      -- Delete old backup files, before backup
      IF NOT EXISTS (SELECT * FROM @CurrentDirectories WHERE CreateOutput <> 0 OR CreateOutput IS NULL)
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupMode = 'BEFORE_BACKUP'
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_delete_file'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_slssqlmaint'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqbutility'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_delete'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Perform a backup
      IF NOT EXISTS (SELECT * FROM @CurrentDirectories WHERE DirectoryPath <> 'NUL' AND DirectoryPath NOT IN(SELECT DirectoryPath FROM @Directories) AND (CreateOutput <> 0 OR CreateOutput IS NULL))
      OR @HostPlatform = 'Linux'
      BEGIN
        IF @BackupSoftware IS NULL
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SELECT @CurrentCommandType = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP_DATABASE'
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP_LOG'
          END

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand += ' TO'

          SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ' MIRROR TO'

            SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand += ' WITH '
          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'

          IF @Version >= 10
          BEGIN
            SET @CurrentCommand += CASE WHEN @Compress = 'Y' AND (@CurrentIsEncrypted = 0 OR (@CurrentIsEncrypted = 1 AND ((@Version >= 13 AND @CurrentMaxTransferSize >= 65537) OR @Version >= 15.0404316 OR SERVERPROPERTY('EngineEdition') = 8))) THEN ', COMPRESSION' ELSE ', NO_COMPRESSION' END
          END

          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ', FORMAT'
          END

          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @Init = 'Y' SET @CurrentCommand += ', INIT'
          IF @Format = 'Y' SET @CurrentCommand += ', FORMAT'
          IF @BlockSize IS NOT NULL SET @CurrentCommand += ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          IF @BufferCount IS NOT NULL SET @CurrentCommand += ', BUFFERCOUNT = ' + CAST(@BufferCount AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', MAXTRANSFERSIZE = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''
          IF @Encrypt = 'Y' SET @CurrentCommand += ', ENCRYPTION (ALGORITHM = ' + UPPER(@EncryptionAlgorithm) + ', '
          IF @Encrypt = 'Y' AND @ServerCertificate IS NOT NULL SET @CurrentCommand += 'SERVER CERTIFICATE = ' + QUOTENAME(@ServerCertificate)
          IF @Encrypt = 'Y' AND @ServerAsymmetricKey IS NOT NULL SET @CurrentCommand += 'SERVER ASYMMETRIC KEY = ' + QUOTENAME(@ServerAsymmetricKey)
          IF @Encrypt = 'Y' SET @CurrentCommand += ')'
          IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand += ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
        END

        IF @BackupSoftware = 'LITESPEED'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SELECT @CurrentCommandType = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'xp_backup_database'
          WHEN @CurrentBackupType = 'LOG' THEN 'xp_backup_log'
          END

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_backup_database @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          WHEN @CurrentBackupType = 'LOG' THEN 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_backup_log @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''
          END

          SELECT @CurrentCommand += ', @filename = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SELECT @CurrentCommand += ', @mirror = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = 1
            ORDER BY FilePath ASC
          END

          SET @CurrentCommand += ', @with = '''
          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @BlockSize IS NOT NULL SET @CurrentCommand += ', BLOCKSIZE = ' + CAST(@BlockSize AS nvarchar)
          SET @CurrentCommand += ''''
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ', @read_write_filegroups = 1'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @AdaptiveCompression IS NOT NULL SET @CurrentCommand += ', @adaptivecompression = ''' + CASE WHEN @AdaptiveCompression = 'SIZE' THEN 'Size' WHEN @AdaptiveCompression = 'SPEED' THEN 'Speed' END + ''''
          IF @BufferCount IS NOT NULL SET @CurrentCommand += ', @buffercount = ' + CAST(@BufferCount AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', @maxtransfersize = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Init = 'Y' SET @CurrentCommand += ', @init = 1'
          IF @Format = 'Y' SET @CurrentCommand += ', @format = 1'
          IF @Throttle IS NOT NULL SET @CurrentCommand += ', @throttle = ' + CAST(@Throttle AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''
          IF @ObjectLevelRecoveryMap = 'Y' SET @CurrentCommand += ', @olrmap = 1'

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', @cryptlevel = ' + CASE
          WHEN @EncryptionAlgorithm = 'RC2_40' THEN '0'
          WHEN @EncryptionAlgorithm = 'RC2_56' THEN '1'
          WHEN @EncryptionAlgorithm = 'RC2_112' THEN '2'
          WHEN @EncryptionAlgorithm = 'RC2_128' THEN '3'
          WHEN @EncryptionAlgorithm = 'TRIPLE_DES_3KEY' THEN '4'
          WHEN @EncryptionAlgorithm = 'RC4_128' THEN '5'
          WHEN @EncryptionAlgorithm = 'AES_128' THEN '6'
          WHEN @EncryptionAlgorithm = 'AES_192' THEN '7'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN '8'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing LiteSpeed backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLBACKUP'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'sqlbackup'

          SELECT @CurrentCommand = CASE
          WHEN @CurrentBackupType IN('DIFF','FULL') THEN 'BACKUP DATABASE ' + QUOTENAME(@CurrentDatabaseName)
          WHEN @CurrentBackupType = 'LOG' THEN 'BACKUP LOG ' + QUOTENAME(@CurrentDatabaseName)
          END

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' READ_WRITE_FILEGROUPS'

          SET @CurrentCommand += ' TO'

          SELECT @CurrentCommand += ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SET @CurrentCommand += ' WITH '

          IF EXISTS(SELECT * FROM @CurrentFiles WHERE Mirror = 1)
          BEGIN
            SET @CurrentCommand += ' MIRRORFILE' + ' = N''' + REPLACE((SELECT FilePath FROM @CurrentFiles WHERE Mirror = 1),'''','''''') + ''', '
          END

          IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
          IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
          IF @CurrentBackupType = 'DIFF' SET @CurrentCommand += ', DIFFERENTIAL'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ', COPY_ONLY'
          IF @NoRecovery = 'Y' AND @CurrentBackupType = 'LOG' SET @CurrentCommand += ', NORECOVERY'
          IF @Init = 'Y' SET @CurrentCommand += ', INIT'
          IF @Format = 'Y' SET @CurrentCommand += ', FORMAT'
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', COMPRESSION = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', THREADCOUNT = ' + CAST(@Threads AS nvarchar)
          IF @CurrentMaxTransferSize IS NOT NULL SET @CurrentCommand += ', MAXTRANSFERSIZE = ' + CAST(@CurrentMaxTransferSize AS nvarchar)
          IF @Description IS NOT NULL SET @CurrentCommand += ', DESCRIPTION = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', KEYSIZE = ' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN '128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN '256'
          END

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLBackup backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'SQLSAFE'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'xp_ss_backup'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_backup @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

          SELECT @CurrentCommand += ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 0
          ORDER BY FilePath ASC

          SELECT @CurrentCommand += ', @mirrorfile = N''' + REPLACE(FilePath,'''','''''') + ''''
          FROM @CurrentFiles
          WHERE Mirror = 1
          ORDER BY FilePath ASC

          SET @CurrentCommand += ', @backuptype = ' + CASE WHEN @CurrentBackupType = 'FULL' THEN '''Full''' WHEN @CurrentBackupType = 'DIFF' THEN '''Differential''' WHEN @CurrentBackupType = 'LOG' THEN '''Log''' END
          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ', @readwritefilegroups = 1'
          SET @CurrentCommand += ', @checksum = ' + CASE WHEN @CheckSum = 'Y' THEN '1' WHEN @CheckSum = 'N' THEN '0' END
          SET @CurrentCommand += ', @copyonly = ' + CASE WHEN @CopyOnly = 'Y' THEN '1' WHEN @CopyOnly = 'N' THEN '0' END
          IF @CompressionLevel IS NOT NULL SET @CurrentCommand += ', @compressionlevel = ' + CAST(@CompressionLevel AS nvarchar)
          IF @Threads IS NOT NULL SET @CurrentCommand += ', @threads = ' + CAST(@Threads AS nvarchar)
          IF @Init = 'Y' SET @CurrentCommand += ', @overwrite = 1'
          IF @Description IS NOT NULL SET @CurrentCommand += ', @desc = N''' + REPLACE(@Description,'''','''''') + ''''

          IF @EncryptionAlgorithm IS NOT NULL SET @CurrentCommand += ', @encryptiontype = N''' + CASE
          WHEN @EncryptionAlgorithm = 'AES_128' THEN 'AES128'
          WHEN @EncryptionAlgorithm = 'AES_256' THEN 'AES256'
          END + ''''

          IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptedbackuppassword = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''
          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing SQLsafe backup.'', 16, 1)'
        END

        IF @BackupSoftware = 'DATA_DOMAIN_BOOST'
        BEGIN
          SET @CurrentDatabaseContext = 'master'

          SET @CurrentCommandType = 'emc_run_backup'

          SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.emc_run_backup '''

          SET @CurrentCommand += ' -c ' + CASE WHEN @CurrentAvailabilityGroup IS NOT NULL THEN @Cluster ELSE CAST(SERVERPROPERTY('MachineName') AS nvarchar) END

          SET @CurrentCommand += ' -l ' + CASE
          WHEN @CurrentBackupType = 'FULL' THEN 'full'
          WHEN @CurrentBackupType = 'DIFF' THEN 'diff'
          WHEN @CurrentBackupType = 'LOG' THEN 'incr'
          END

          IF @NoRecovery = 'Y' SET @CurrentCommand += ' -H'

          IF @CleanupTime IS NOT NULL SET @CurrentCommand += ' -y +' + CAST(@CleanupTime/24 + CASE WHEN @CleanupTime%24 > 0 THEN 1 ELSE 0 END AS nvarchar) + 'd'

          IF @CheckSum = 'Y' SET @CurrentCommand += ' -k'

          SET @CurrentCommand += ' -S ' + CAST(@CurrentNumberOfFiles AS nvarchar)

          IF @Description IS NOT NULL SET @CurrentCommand += ' -b "' + REPLACE(@Description,'''','''''') + '"'

          IF @BufferCount IS NOT NULL SET @CurrentCommand += ' -O "BUFFERCOUNT=' + CAST(@BufferCount AS nvarchar) + '"'

          IF @ReadWriteFileGroups = 'Y' AND @CurrentDatabaseName <> 'master' SET @CurrentCommand += ' -O "READ_WRITE_FILEGROUPS"'

          IF @DataDomainBoostHost IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_HOST=' + REPLACE(@DataDomainBoostHost,'''','''''') + '"'
          IF @DataDomainBoostUser IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_USER=' + REPLACE(@DataDomainBoostUser,'''','''''') + '"'
          IF @DataDomainBoostDevicePath IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DEVICE_PATH=' + REPLACE(@DataDomainBoostDevicePath,'''','''''') + '"'
          IF @DataDomainBoostLockboxPath IS NOT NULL SET @CurrentCommand += ' -a "NSR_DFA_SI_DD_LOCKBOX_PATH=' + REPLACE(@DataDomainBoostLockboxPath,'''','''''') + '"'
          SET @CurrentCommand += ' -a "NSR_SKIP_NON_BACKUPABLE_STATE_DB=TRUE"'
          SET @CurrentCommand += ' -a "BACKUP_PROMOTION=NONE"'
          IF @CopyOnly = 'Y' SET @CurrentCommand += ' -a "NSR_COPY_ONLY=TRUE"'

          IF SERVERPROPERTY('InstanceName') IS NULL SET @CurrentCommand += ' "MSSQL' + ':' + REPLACE(REPLACE(@CurrentDatabaseName,'''',''''''),'.','\.') + '"'
          IF SERVERPROPERTY('InstanceName') IS NOT NULL SET @CurrentCommand += ' "MSSQL$' + CAST(SERVERPROPERTY('InstanceName') AS nvarchar) + ':' + REPLACE(REPLACE(@CurrentDatabaseName,'''',''''''),'.','\.') + '"'

          SET @CurrentCommand += ''''

          SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error performing Data Domain Boost backup.'', 16, 1)'
        END

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
        SET @CurrentBackupOutput = @CurrentCommandOutput
      END

      -- Verify the backup
      IF @CurrentBackupOutput = 0 AND @Verify = 'Y'
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentBackupSetID = ID,
                       @CurrentIsMirror = Mirror
          FROM @CurrentBackupSet
          WHERE VerifyCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'RESTORE_VERIFYONLY'

            SET @CurrentCommand = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand += ' ' + [Type] + ' = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            IF @URL IS NOT NULL AND @Credential IS NOT NULL SET @CurrentCommand += ', CREDENTIAL = N''' + REPLACE(@Credential,'''','''''') + ''''
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_restore_verifyonly'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_restore_verifyonly'

            SELECT @CurrentCommand += ' @filename = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ', @with = '''
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            SET @CurrentCommand += ''''
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', @encryptionkey = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error verifying LiteSpeed backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqlbackup'

            SET @CurrentCommand = 'RESTORE VERIFYONLY FROM'

            SELECT @CurrentCommand += ' DISK = N''' + REPLACE(FilePath,'''','''''') + '''' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) <> @CurrentNumberOfFiles THEN ',' ELSE '' END
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' WITH '
            IF @CheckSum = 'Y' SET @CurrentCommand += 'CHECKSUM'
            IF @CheckSum = 'N' SET @CurrentCommand += 'NO_CHECKSUM'
            IF @EncryptionKey IS NOT NULL SET @CurrentCommand += ', PASSWORD = N''' + REPLACE(@EncryptionKey,'''','''''') + ''''

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqlbackup N''-SQL "' + REPLACE(@CurrentCommand,'''','''''') + '"''' + ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLBackup backup.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_verify'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_verify @database = N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''''

            SELECT @CurrentCommand += ', ' + CASE WHEN ROW_NUMBER() OVER (ORDER BY FilePath ASC) = 1 THEN '@filename' ELSE '@backupfile' END + ' = N''' + REPLACE(FilePath,'''','''''') + ''''
            FROM @CurrentFiles
            WHERE Mirror = @CurrentIsMirror
            ORDER BY FilePath ASC

            SET @CurrentCommand += ' IF @ReturnCode <> 0 RAISERROR(''Error verifying SQLsafe backup.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentBackupSet
          SET VerifyCompleted = 1,
              VerifyOutput = @CurrentCommandOutput
          WHERE ID = @CurrentBackupSetID

          SET @CurrentBackupSetID = NULL
          SET @CurrentIsMirror = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      IF @CleanupMode = 'AFTER_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@CleanupTime),SYSDATETIME()), 0

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 0 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 0 OR Mirror IS NULL)),
              CleanupMode = 'AFTER_BACKUP'
          WHERE Mirror = 0
        END
      END

      IF @MirrorCleanupMode = 'AFTER_BACKUP'
      BEGIN
        INSERT INTO @CurrentCleanupDates (CleanupDate, Mirror)
        SELECT DATEADD(hh,-(@MirrorCleanupTime),SYSDATETIME()), 1

        IF NOT EXISTS(SELECT * FROM @CurrentCleanupDates WHERE (Mirror = 1 OR Mirror IS NULL) AND CleanupDate IS NULL)
        BEGIN
          UPDATE @CurrentDirectories
          SET CleanupDate = (SELECT MIN(CleanupDate)
                             FROM @CurrentCleanupDates
                             WHERE (Mirror = 1 OR Mirror IS NULL)),
              CleanupMode = 'AFTER_BACKUP'
          WHERE Mirror = 1
        END
      END

      -- Delete old backup files, after backup
      IF ((@CurrentBackupOutput = 0 AND @Verify = 'N')
      OR (@CurrentBackupOutput = 0 AND @Verify = 'Y' AND NOT EXISTS (SELECT * FROM @CurrentBackupSet WHERE VerifyOutput <> 0 OR VerifyOutput IS NULL)))
      AND (@BackupSoftware <> 'DATA_DOMAIN_BOOST' OR @BackupSoftware IS NULL)
      AND @CurrentBackupType = @BackupType
      BEGIN
        WHILE (1 = 1)
        BEGIN
          SELECT TOP 1 @CurrentDirectoryID = ID,
                       @CurrentDirectoryPath = DirectoryPath,
                       @CurrentCleanupDate = CleanupDate
          FROM @CurrentDirectories
          WHERE CleanupDate IS NOT NULL
          AND CleanupMode = 'AFTER_BACKUP'
          AND CleanupCompleted = 0
          ORDER BY ID ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          IF @BackupSoftware IS NULL
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_delete_file'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_delete_file 0, N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + @CurrentFileExtension + ''', ''' + CONVERT(nvarchar(19),@CurrentCleanupDate,126) + ''' IF @ReturnCode <> 0 RAISERROR(''Error deleting files.'', 16, 1)'
          END

          IF @BackupSoftware = 'LITESPEED'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_slssqlmaint'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_slssqlmaint N''-MAINTDEL -DELFOLDER "' + REPLACE(@CurrentDirectoryPath,'''','''''') + '" -DELEXTENSION "' + @CurrentFileExtension + '" -DELUNIT "' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + '" -DELUNITTYPE "minutes" -DELUSEAGE'' IF @ReturnCode <> 0 RAISERROR(''Error deleting LiteSpeed backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLBACKUP'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'sqbutility'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.sqbutility 1032, N''' + REPLACE(@CurrentDatabaseName,'''','''''') + ''', N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + ''', ''' + CASE WHEN @CurrentBackupType = 'FULL' THEN 'D' WHEN @CurrentBackupType = 'DIFF' THEN 'I' WHEN @CurrentBackupType = 'LOG' THEN 'L' END + ''', ''' + CAST(DATEDIFF(hh,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'h'', ' + ISNULL('''' + REPLACE(@EncryptionKey,'''','''''') + '''','NULL') + ' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLBackup backup files.'', 16, 1)'
          END

          IF @BackupSoftware = 'SQLSAFE'
          BEGIN
            SET @CurrentDatabaseContext = 'master'

            SET @CurrentCommandType = 'xp_ss_delete'

            SET @CurrentCommand = 'DECLARE @ReturnCode int EXECUTE @ReturnCode = dbo.xp_ss_delete @filename = N''' + REPLACE(@CurrentDirectoryPath,'''','''''') + '\*.' + @CurrentFileExtension + ''', @age = ''' + CAST(DATEDIFF(mi,@CurrentCleanupDate,SYSDATETIME()) + 1 AS nvarchar) + 'Minutes'' IF @ReturnCode <> 0 RAISERROR(''Error deleting SQLsafe backup files.'', 16, 1)'
          END

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          UPDATE @CurrentDirectories
          SET CleanupCompleted = 1,
              CleanupOutput = @CurrentCommandOutput
          WHERE ID = @CurrentDirectoryID

          SET @CurrentDirectoryID = NULL
          SET @CurrentDirectoryPath = NULL
          SET @CurrentCleanupDate = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END
    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      SET @Error = @@ERROR
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL
    SET @CurrentIsEncrypted = NULL
    SET @CurrentDatabaseSize = NULL

    SET @CurrentBackupType = NULL
    SET @CurrentMaxTransferSize = NULL
    SET @CurrentNumberOfFiles = NULL
    SET @CurrentFileExtension = NULL
    SET @CurrentFileNumber = NULL
    SET @CurrentDifferentialBaseLSN = NULL
    SET @CurrentDifferentialBaseIsSnapshot = NULL
    SET @CurrentLogLSN = NULL
    SET @CurrentLatestBackup = NULL
    SET @CurrentDatabaseNameFS = NULL
    SET @CurrentDirectoryStructure = NULL
    SET @CurrentDatabaseFileName = NULL
    SET @CurrentMaxFilePathLength = NULL
    SET @CurrentDate = NULL
    SET @CurrentCleanupDate = NULL
    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentAvailabilityGroupBackupPreference = NULL
    SET @CurrentIsPreferredBackupReplica = NULL
    SET @CurrentDatabaseMirroringRole = NULL
    SET @CurrentLogShippingRole = NULL
    SET @CurrentLastLogBackup = NULL
    SET @CurrentLogSizeSinceLastLogBackup = NULL
    SET @CurrentAllocatedExtentPageCount = NULL
    SET @CurrentModifiedExtentPageCount = NULL

    SET @CurrentDatabaseContext = NULL
    SET @CurrentCommand = NULL
    SET @CurrentCommandOutput = NULL
    SET @CurrentCommandType = NULL

    SET @CurrentBackupOutput = NULL

    DELETE FROM @CurrentDirectories
    DELETE FROM @CurrentURLs
    DELETE FROM @CurrentFiles
    DELETE FROM @CurrentCleanupDates
    DELETE FROM @CurrentBackupSet

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DatabaseIntegrityCheck
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[DatabaseIntegrityCheck]

@Databases nvarchar(max) = NULL,
@CheckCommands nvarchar(max) = 'CHECKDB',
@PhysicalOnly nvarchar(max) = 'N',
@DataPurity nvarchar(max) = 'N',
@NoIndex nvarchar(max) = 'N',
@ExtendedLogicalChecks nvarchar(max) = 'N',
@TabLock nvarchar(max) = 'N',
@FileGroups nvarchar(max) = NULL,
@Objects nvarchar(max) = NULL,
@MaxDOP int = NULL,
@AvailabilityGroups nvarchar(max) = NULL,
@AvailabilityGroupReplicas nvarchar(max) = 'ALL',
@Updateability nvarchar(max) = 'ALL',
@TimeLimit int = NULL,
@LockTimeout int = NULL,
@LockMessageSeverity int = 16,
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2022-12-03 17:23:44                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @Severity int

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)

  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentAvailabilityGroupBackupPreference nvarchar(max)
  DECLARE @CurrentSecondaryRoleAllowConnections nvarchar(max)
  DECLARE @CurrentIsPreferredBackupReplica bit
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)

  DECLARE @CurrentFGID int
  DECLARE @CurrentFileGroupID int
  DECLARE @CurrentFileGroupName nvarchar(max)
  DECLARE @CurrentFileGroupExists bit

  DECLARE @CurrentOID int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentObjectExists bit

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               [Snapshot] bit,
                               StartPosition int,
                               LastCommandTime datetime2,
                               DatabaseSize bigint,
                               LastGoodCheckDbTime datetime2,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @tmpFileGroups TABLE (ID int IDENTITY,
                                FileGroupID int,
                                FileGroupName nvarchar(max),
                                StartPosition int,
                                [Order] int,
                                Selected bit,
                                Completed bit,
                                PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpObjects TABLE (ID int IDENTITY,
                             SchemaID int,
                             SchemaName nvarchar(max),
                             ObjectID int,
                             ObjectName nvarchar(max),
                             ObjectType nvarchar(max),
                             StartPosition int,
                             [Order] int,
                             Selected bit,
                             Completed bit,
                             PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @SelectedFileGroups TABLE (DatabaseName nvarchar(max),
                                     FileGroupName nvarchar(max),
                                     StartPosition int,
                                     Selected bit)

  DECLARE @SelectedObjects TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  StartPosition int,
                                  Selected bit)

  DECLARE @SelectedCheckCommands TABLE (CheckCommand nvarchar(max))

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @CheckCommands = ' + ISNULL('''' + REPLACE(@CheckCommands,'''','''''') + '''','NULL')
  SET @Parameters += ', @PhysicalOnly = ' + ISNULL('''' + REPLACE(@PhysicalOnly,'''','''''') + '''','NULL')
  SET @Parameters += ', @DataPurity = ' + ISNULL('''' + REPLACE(@DataPurity,'''','''''') + '''','NULL')
  SET @Parameters += ', @NoIndex = ' + ISNULL('''' + REPLACE(@NoIndex,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExtendedLogicalChecks = ' + ISNULL('''' + REPLACE(@ExtendedLogicalChecks,'''','''''') + '''','NULL')
  SET @Parameters += ', @TabLock = ' + ISNULL('''' + REPLACE(@TabLock,'''','''''') + '''','NULL')
  SET @Parameters += ', @FileGroups = ' + ISNULL('''' + REPLACE(@FileGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @Objects = ' + ISNULL('''' + REPLACE(@Objects,'''','''''') + '''','NULL')
  SET @Parameters += ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroupReplicas = ' + ISNULL('''' + REPLACE(@AvailabilityGroupReplicas,'''','''''') + '''','NULL')
  SET @Parameters += ', @Updateability = ' + ISNULL('''' + REPLACE(@Updateability,'''','''''') + '''','NULL')
  SET @Parameters += ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @Parameters += ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @Parameters += ', @LockMessageSeverity = ' + ISNULL(CAST(@LockMessageSeverity AS nvarchar),'NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT  'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Snapshot], [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         CASE WHEN source_database_id IS NOT NULL THEN 1 ELSE 0 END AS [Snapshot],
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  AND NOT ((tmpDatabases.DatabaseName = 'tempdb' OR tmpDatabases.[Snapshot] = 1) AND tmpDatabases.DatabaseName <> SelectedDatabases.DatabaseName)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  AND NOT ((tmpDatabases.DatabaseName = 'tempdb' OR tmpDatabases.[Snapshot] = 1) AND tmpDatabases.DatabaseName <> SelectedDatabases.DatabaseName)
  WHERE SelectedDatabases.Selected = 0

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Select filegroups                                                                          //--
  ----------------------------------------------------------------------------------------------------

  SET @FileGroups = REPLACE(@FileGroups, CHAR(10), '')
  SET @FileGroups = REPLACE(@FileGroups, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @FileGroups) > 0 SET @FileGroups = REPLACE(@FileGroups, ' ' + @StringDelimiter, @StringDelimiter)

  SET @FileGroups = LTRIM(RTRIM(@FileGroups));

  WITH FileGroups1 (StartPosition, EndPosition, FileGroupItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, 1), 0), LEN(@FileGroups) + 1) - 1) AS FileGroupItem
  WHERE @FileGroups IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) AS EndPosition,
         SUBSTRING(@FileGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FileGroups, EndPosition + 1), 0), LEN(@FileGroups) + 1) - EndPosition - 1) AS FileGroupItem
  FROM FileGroups1
  WHERE EndPosition < LEN(@FileGroups) + 1
  ),
  FileGroups2 (FileGroupItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem LIKE '-%' THEN RIGHT(FileGroupItem,LEN(FileGroupItem) - 1) ELSE FileGroupItem END AS FileGroupItem,
         StartPosition,
         CASE WHEN FileGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM FileGroups1
  ),
  FileGroups3 (FileGroupItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN FileGroupItem = 'ALL_FILEGROUPS' THEN '%.%' ELSE FileGroupItem END AS FileGroupItem,
         StartPosition,
         Selected
  FROM FileGroups2
  ),
  FileGroups4 (DatabaseName, FileGroupName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,2) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(FileGroupItem,4) IS NULL AND PARSENAME(FileGroupItem,3) IS NULL THEN PARSENAME(FileGroupItem,1) ELSE NULL END AS FileGroupName,
         StartPosition,
         Selected
  FROM FileGroups3
  )
  INSERT INTO @SelectedFileGroups (DatabaseName, FileGroupName, StartPosition, Selected)
  SELECT DatabaseName, FileGroupName, StartPosition, Selected
  FROM FileGroups4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select objects                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Objects = REPLACE(@Objects, CHAR(10), '')
  SET @Objects = REPLACE(@Objects, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Objects) > 0 SET @Objects = REPLACE(@Objects, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Objects) > 0 SET @Objects = REPLACE(@Objects, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Objects = LTRIM(RTRIM(@Objects));

  WITH Objects1 (StartPosition, EndPosition, ObjectItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, 1), 0), LEN(@Objects) + 1) - 1) AS ObjectItem
  WHERE @Objects IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) AS EndPosition,
         SUBSTRING(@Objects, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Objects, EndPosition + 1), 0), LEN(@Objects) + 1) - EndPosition - 1) AS ObjectItem
  FROM Objects1
  WHERE EndPosition < LEN(@Objects) + 1
  ),
  Objects2 (ObjectItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN ObjectItem LIKE '-%' THEN RIGHT(ObjectItem,LEN(ObjectItem) - 1) ELSE ObjectItem END AS ObjectItem,
          StartPosition,
         CASE WHEN ObjectItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Objects1
  ),
  Objects3 (ObjectItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN ObjectItem = 'ALL_OBJECTS' THEN '%.%.%' ELSE ObjectItem END AS ObjectItem,
         StartPosition,
         Selected
  FROM Objects2
  ),
  Objects4 (DatabaseName, SchemaName, ObjectName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,3) ELSE NULL END AS DatabaseName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,2) ELSE NULL END AS SchemaName,
         CASE WHEN PARSENAME(ObjectItem,4) IS NULL THEN PARSENAME(ObjectItem,1) ELSE NULL END AS ObjectName,
         StartPosition,
         Selected
  FROM Objects3
  )
  INSERT INTO @SelectedObjects (DatabaseName, SchemaName, ObjectName, StartPosition, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, StartPosition, Selected
  FROM Objects4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select check commands                                                                      //--
  ----------------------------------------------------------------------------------------------------

  SET @CheckCommands = REPLACE(@CheckCommands, @StringDelimiter + ' ', @StringDelimiter);

  WITH CheckCommands (StartPosition, EndPosition, CheckCommand) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, 1), 0), LEN(@CheckCommands) + 1) - 1) AS CheckCommand
  WHERE @CheckCommands IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) AS EndPosition,
         SUBSTRING(@CheckCommands, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @CheckCommands, EndPosition + 1), 0), LEN(@CheckCommands) + 1) - EndPosition - 1) AS CheckCommand
  FROM CheckCommands
  WHERE EndPosition < LEN(@CheckCommands) + 1
  )
  INSERT INTO @SelectedCheckCommands (CheckCommand)
  SELECT CheckCommand
  FROM CheckCommands
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand NOT IN('CHECKDB','CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands GROUP BY CheckCommand HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 2
  END

  IF NOT EXISTS (SELECT * FROM @SelectedCheckCommands)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.' , 16, 3
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKDB')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP','CHECKALLOC','CHECKTABLE','CHECKCATALOG'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 4
  END

  IF EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKFILEGROUP')) AND EXISTS (SELECT CheckCommand FROM @SelectedCheckCommands WHERE CheckCommand IN('CHECKALLOC','CHECKTABLE'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CheckCommands is not supported.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @PhysicalOnly NOT IN ('Y','N') OR @PhysicalOnly IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PhysicalOnly is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DataPurity NOT IN ('Y','N') OR @DataPurity IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DataPurity is not supported.', 16, 1
  END

  IF @PhysicalOnly = 'Y' AND @DataPurity = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @PhysicalOnly and @DataPurity cannot be used together.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @NoIndex NOT IN ('Y','N') OR @NoIndex IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @NoIndex is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @ExtendedLogicalChecks NOT IN ('Y','N') OR @ExtendedLogicalChecks IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExtendedLogicalChecks is not supported.', 16, 1
  END

  IF @PhysicalOnly = 'Y' AND @ExtendedLogicalChecks = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @PhysicalOnly and @ExtendedLogicalChecks cannot be used together.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TabLock NOT IN ('Y','N') OR @TabLock IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TabLock is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedFileGroups WHERE DatabaseName IS NULL OR FileGroupName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 1
  END

  IF @FileGroups IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedFileGroups)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 2
  END

  IF @FileGroups IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FileGroups is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedObjects WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 1
  END

  IF (@Objects IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedObjects))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 2
  END

  IF (@Objects IS NOT NULL AND NOT EXISTS (SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE'))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Objects is not supported.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxDOP < 0 OR @MaxDOP > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported.', 16, 1
  END

  IF @MaxDOP IS NOT NULL AND NOT (@Version >= 12.050000 OR SERVERPROPERTY('EngineEdition') IN (5, 8))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported. MAXDOP is not available in this version of SQL Server.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroupReplicas NOT IN('ALL','PRIMARY','SECONDARY','PREFERRED_BACKUP_REPLICA') OR @AvailabilityGroupReplicas IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroupReplicas is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Updateability NOT IN('READ_ONLY','READ_WRITE','ALL') OR @Updateability IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Updateability is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeLimit < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeLimit is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockTimeout < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockTimeout is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockMessageSeverity NOT IN(10, 16)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC','DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC','REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC') AND NOT ((@Version >= 12.06024 AND @Version < 13) OR (@Version >= 13.05026 AND @Version < 14) OR @Version >= 14.0302916)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. DATABASEPROPERTYEX(''DatabaseName'', ''LastGoodCheckDbTime'') is not available in this version of SQL Server.', 16, 2
  END

  IF @DatabaseOrder IN('REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC') AND @LogToTable = 'N'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. You need to provide the parameter @LogToTable = ''Y''.', 16, 3
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC','REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC') AND @CheckCommands <> 'CHECKDB'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. You need to provide the parameter @CheckCommands = ''CHECKDB''.', 16, 4
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported. This parameter is not supported in Azure SQL Database.', 16, 5
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported. This parameter is not supported in Azure SQL Database.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-integrity-check.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedFileGroups
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @FileGroups parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedObjects
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Objects parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedFileGroups
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @FileGroups parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedObjects
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @Objects parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check @@SERVERNAME                                                                         //--
  ----------------------------------------------------------------------------------------------------

  IF @@SERVERNAME <> CAST(SERVERPROPERTY('ServerName') AS nvarchar(max)) AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The @@SERVERNAME does not match SERVERPROPERTY(''ServerName''). See ' + CASE WHEN SERVERPROPERTY('IsClustered') = 0 THEN 'https://docs.microsoft.com/en-us/sql/database-engine/install-windows/rename-a-computer-that-hosts-a-stand-alone-instance-of-sql-server' WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'https://docs.microsoft.com/en-us/sql/sql-server/failover-clusters/install/rename-a-sql-server-failover-cluster-instance' END + '.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('DATABASE_LAST_GOOD_CHECK_ASC','DATABASE_LAST_GOOD_CHECK_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LastGoodCheckDbTime = NULLIF(CAST(DATABASEPROPERTYEX (DatabaseName,'LastGoodCheckDbTime') AS datetime2),'1900-01-01 00:00:00.000')
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IN('REPLICA_LAST_GOOD_CHECK_ASC','REPLICA_LAST_GOOD_CHECK_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET LastCommandTime = MaxStartTime
    FROM @tmpDatabases tmpDatabases
    INNER JOIN (SELECT DatabaseName, MAX(StartTime) AS MaxStartTime
                FROM dbo.CommandLog
                WHERE CommandType = 'DBCC_CHECKDB'
                AND ErrorNumber = 0
                GROUP BY DatabaseName) CommandLog
    ON tmpDatabases.DatabaseName = CommandLog.DatabaseName COLLATE DATABASE_DEFAULT
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_LAST_GOOD_CHECK_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastGoodCheckDbTime ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_LAST_GOOD_CHECK_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastGoodCheckDbTime DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'REPLICA_LAST_GOOD_CHECK_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastCommandTime ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'REPLICA_LAST_GOOD_CHECK_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY LastCommandTime DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
     BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseState IN('ONLINE','EMERGENCY') AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id,
             @CurrentSecondaryRoleAllowConnections = secondary_role_allow_connections_desc
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name],
             @CurrentAvailabilityGroupBackupPreference = UPPER(automated_backup_preference_desc)
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1 AND @CurrentAvailabilityGroup IS NOT NULL AND @AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA'
    BEGIN
      SELECT @CurrentIsPreferredBackupReplica = sys.fn_hadr_backup_is_preferred_replica(@CurrentDatabaseName)
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage =  'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      IF @CurrentAvailabilityGroupRole = 'SECONDARY'
      BEGIN
        SET @DatabaseMessage =  'Readable Secondary: ' + ISNULL(@CurrentSecondaryRoleAllowConnections,'N/A')
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
      END

      IF @AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA'
      BEGIN
        SET @DatabaseMessage = 'Availability group backup preference: ' + ISNULL(@CurrentAvailabilityGroupBackupPreference,'N/A')
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

        SET @DatabaseMessage = 'Is preferred backup replica: ' + CASE WHEN @CurrentIsPreferredBackupReplica = 1 THEN 'Yes' WHEN @CurrentIsPreferredBackupReplica = 0 THEN 'No' ELSE 'N/A' END
        RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
      END
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentDatabaseState IN('ONLINE','EMERGENCY')
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR @CurrentAvailabilityGroupRole IS NULL OR SERVERPROPERTY('EngineEdition') = 3)
    AND ((@AvailabilityGroupReplicas = 'PRIMARY' AND @CurrentAvailabilityGroupRole = 'PRIMARY') OR (@AvailabilityGroupReplicas = 'SECONDARY' AND @CurrentAvailabilityGroupRole = 'SECONDARY') OR (@AvailabilityGroupReplicas = 'PREFERRED_BACKUP_REPLICA' AND @CurrentIsPreferredBackupReplica = 1) OR @AvailabilityGroupReplicas = 'ALL' OR @CurrentAvailabilityGroupRole IS NULL)
    AND NOT (@CurrentIsReadOnly = 1 AND @Updateability = 'READ_WRITE')
    AND NOT (@CurrentIsReadOnly = 0 AND @Updateability = 'READ_ONLY')
    BEGIN

      -- Check database
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKDB') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKDB'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKDB (' + QUOTENAME(@CurrentDatabaseName)
        IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
        SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @DataPurity = 'Y' SET @CurrentCommand += ', DATA_PURITY'
        IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
        IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand += ', EXTENDED_LOGICAL_CHECKS'
        IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
        IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

      -- Check filegroups
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKFILEGROUP')
      AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR (@CurrentAvailabilityGroupRole = 'SECONDARY' AND @CurrentSecondaryRoleAllowConnections = 'ALL') OR @CurrentAvailabilityGroupRole IS NULL)
      AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT data_space_id AS FileGroupID, name AS FileGroupName, 0 AS [Order], 0 AS Selected, 0 AS Completed FROM sys.filegroups filegroups WHERE [type] <> ''FX'' ORDER BY CASE WHEN filegroups.name = ''PRIMARY'' THEN 1 ELSE 0 END DESC, filegroups.name ASC'

        INSERT INTO @tmpFileGroups (FileGroupID, FileGroupName, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql  @stmt = @CurrentCommand
        SET @Error = @@ERROR
        IF @Error <> 0 SET @ReturnCode = @Error

        IF @FileGroups IS NULL
        BEGIN
          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = 1
          FROM @tmpFileGroups tmpFileGroups
        END
        ELSE
        BEGIN
          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = SelectedFileGroups.Selected
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN @SelectedFileGroups SelectedFileGroups
          ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
          WHERE SelectedFileGroups.Selected = 1

          UPDATE tmpFileGroups
          SET tmpFileGroups.Selected = SelectedFileGroups.Selected
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN @SelectedFileGroups SelectedFileGroups
          ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
          WHERE SelectedFileGroups.Selected = 0

          UPDATE tmpFileGroups
          SET tmpFileGroups.StartPosition = SelectedFileGroups2.StartPosition
          FROM @tmpFileGroups tmpFileGroups
          INNER JOIN (SELECT tmpFileGroups.FileGroupName, MIN(SelectedFileGroups.StartPosition) AS StartPosition
                      FROM @tmpFileGroups tmpFileGroups
                      INNER JOIN @SelectedFileGroups SelectedFileGroups
                      ON @CurrentDatabaseName LIKE REPLACE(SelectedFileGroups.DatabaseName,'_','[_]') AND tmpFileGroups.FileGroupName LIKE REPLACE(SelectedFileGroups.FileGroupName,'_','[_]')
                      WHERE SelectedFileGroups.Selected = 1
                      GROUP BY tmpFileGroups.FileGroupName) SelectedFileGroups2
          ON tmpFileGroups.FileGroupName = SelectedFileGroups2.FileGroupName
        END;

        WITH tmpFileGroups AS (
        SELECT FileGroupName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, FileGroupName ASC) AS RowNumber
        FROM @tmpFileGroups tmpFileGroups
        WHERE Selected = 1
        )
        UPDATE tmpFileGroups
        SET [Order] = RowNumber

        SET @ErrorMessage = ''
        SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(FileGroupName) + ', '
        FROM @SelectedFileGroups SelectedFileGroups
        WHERE DatabaseName = @CurrentDatabaseName
        AND FileGroupName NOT LIKE '%[%]%'
        AND NOT EXISTS (SELECT * FROM @tmpFileGroups WHERE FileGroupName = SelectedFileGroups.FileGroupName)
        IF @@ROWCOUNT > 0
        BEGIN
          SET @ErrorMessage = 'The following file groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
          RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
          SET @Error = @@ERROR
          RAISERROR(@EmptyLine,10,1) WITH NOWAIT
        END

        WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SELECT TOP 1 @CurrentFGID = ID,
                       @CurrentFileGroupID = FileGroupID,
                       @CurrentFileGroupName = FileGroupName
          FROM @tmpFileGroups
          WHERE Selected = 1
          AND Completed = 0
          ORDER BY [Order] ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          -- Does the filegroup exist?
          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.filegroups filegroups WHERE [type] <> ''FX'' AND filegroups.data_space_id = @ParamFileGroupID AND filegroups.[name] = @ParamFileGroupName) BEGIN SET @ParamFileGroupExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamFileGroupID int, @ParamFileGroupName sysname, @ParamFileGroupExists bit OUTPUT', @ParamFileGroupID = @CurrentFileGroupID, @ParamFileGroupName = @CurrentFileGroupName, @ParamFileGroupExists = @CurrentFileGroupExists OUTPUT

            IF @CurrentFileGroupExists IS NULL SET @CurrentFileGroupExists = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ', ' + ' The file group ' + QUOTENAME(@CurrentFileGroupName) + ' in the database ' + QUOTENAME(@CurrentDatabaseName) + ' is locked. It could not be checked if the filegroup exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END
          END CATCH

          IF @CurrentFileGroupExists = 1
          BEGIN
            SET @CurrentDatabaseContext = @CurrentDatabaseName

            SET @CurrentCommandType = 'DBCC_CHECKFILEGROUP'

            SET @CurrentCommand = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand += 'DBCC CHECKFILEGROUP (' + QUOTENAME(@CurrentFileGroupName)
            IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
            SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
            IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput = @Error
            IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
          END

          UPDATE @tmpFileGroups
          SET Completed = 1
          WHERE Selected = 1
          AND Completed = 0
          AND ID = @CurrentFGID

          SET @CurrentFGID = NULL
          SET @CurrentFileGroupID = NULL
          SET @CurrentFileGroupName = NULL
          SET @CurrentFileGroupExists = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Check disk space allocation structures
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKALLOC') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKALLOC'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKALLOC (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
        IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

      -- Check objects
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKTABLE')
      AND (@CurrentAvailabilityGroupRole = 'PRIMARY' OR (@CurrentAvailabilityGroupRole = 'SECONDARY' AND @CurrentSecondaryRoleAllowConnections = 'ALL') OR @CurrentAvailabilityGroupRole IS NULL)
      AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SELECT schemas.[schema_id] AS SchemaID, schemas.[name] AS SchemaName, objects.[object_id] AS ObjectID, objects.[name] AS ObjectName, RTRIM(objects.[type]) AS ObjectType, 0 AS [Order], 0 AS Selected, 0 AS Completed FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' ORDER BY schemas.name ASC, objects.name ASC'

        INSERT INTO @tmpObjects (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand
        SET @Error = @@ERROR
        IF @Error <> 0 SET @ReturnCode = @Error

        IF @Objects IS NULL
        BEGIN
          UPDATE tmpObjects
          SET tmpObjects.Selected = 1
          FROM @tmpObjects tmpObjects
        END
        ELSE
        BEGIN
          UPDATE tmpObjects
          SET tmpObjects.Selected = SelectedObjects.Selected
          FROM @tmpObjects tmpObjects
          INNER JOIN @SelectedObjects SelectedObjects
          ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
          WHERE SelectedObjects.Selected = 1

          UPDATE tmpObjects
          SET tmpObjects.Selected = SelectedObjects.Selected
          FROM @tmpObjects tmpObjects
          INNER JOIN @SelectedObjects SelectedObjects
          ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
          WHERE SelectedObjects.Selected = 0

          UPDATE tmpObjects
          SET tmpObjects.StartPosition = SelectedObjects2.StartPosition
          FROM @tmpObjects tmpObjects
          INNER JOIN (SELECT tmpObjects.SchemaName, tmpObjects.ObjectName, MIN(SelectedObjects.StartPosition) AS StartPosition
                      FROM @tmpObjects tmpObjects
                      INNER JOIN @SelectedObjects SelectedObjects
                      ON @CurrentDatabaseName LIKE REPLACE(SelectedObjects.DatabaseName,'_','[_]') AND tmpObjects.SchemaName LIKE REPLACE(SelectedObjects.SchemaName,'_','[_]') AND tmpObjects.ObjectName LIKE REPLACE(SelectedObjects.ObjectName,'_','[_]')
                      WHERE SelectedObjects.Selected = 1
                      GROUP BY tmpObjects.SchemaName, tmpObjects.ObjectName) SelectedObjects2
          ON tmpObjects.SchemaName = SelectedObjects2.SchemaName AND tmpObjects.ObjectName = SelectedObjects2.ObjectName
        END;

        WITH tmpObjects AS (
        SELECT SchemaName, ObjectName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, SchemaName ASC, ObjectName ASC) AS RowNumber
        FROM @tmpObjects tmpObjects
        WHERE Selected = 1
        )
        UPDATE tmpObjects
        SET [Order] = RowNumber

        SET @ErrorMessage = ''
        SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + ', '
        FROM @SelectedObjects SelectedObjects
        WHERE DatabaseName = @CurrentDatabaseName
        AND SchemaName NOT LIKE '%[%]%'
        AND ObjectName NOT LIKE '%[%]%'
        AND NOT EXISTS (SELECT * FROM @tmpObjects WHERE SchemaName = SelectedObjects.SchemaName AND ObjectName = SelectedObjects.ObjectName)
        IF @@ROWCOUNT > 0
        BEGIN
          SET @ErrorMessage = 'The following objects do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
          RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
          SET @Error = @@ERROR
          RAISERROR(@EmptyLine,10,1) WITH NOWAIT
        END

        WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SELECT TOP 1 @CurrentOID = ID,
                       @CurrentSchemaID = SchemaID,
                       @CurrentSchemaName = SchemaName,
                       @CurrentObjectID = ObjectID,
                       @CurrentObjectName = ObjectName,
                       @CurrentObjectType = ObjectType
          FROM @tmpObjects
          WHERE Selected = 1
          AND Completed = 0
          ORDER BY [Order] ASC

          IF @@ROWCOUNT = 0
          BEGIN
            BREAK
          END

          -- Does the object exist?
          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.schema_id = schemas.schema_id LEFT OUTER JOIN sys.tables tables ON objects.object_id = tables.object_id WHERE objects.[type] IN(''U'',''V'') AND EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.object_id = objects.object_id)' + CASE WHEN @Version >= 12 THEN ' AND (tables.is_memory_optimized = 0 OR is_memory_optimized IS NULL)' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType) BEGIN SET @ParamObjectExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamObjectExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamObjectExists = @CurrentObjectExists OUTPUT

            IF @CurrentObjectExists IS NULL SET @CurrentObjectExists = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ', ' + 'The object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the object exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END
          END CATCH

          IF @CurrentObjectExists = 1
          BEGIN
            SET @CurrentDatabaseContext = @CurrentDatabaseName

            SET @CurrentCommandType = 'DBCC_CHECKTABLE'

            SET @CurrentCommand = ''
            IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
            SET @CurrentCommand += 'DBCC CHECKTABLE (''' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ''''
            IF @NoIndex = 'Y' SET @CurrentCommand += ', NOINDEX'
            SET @CurrentCommand += ') WITH NO_INFOMSGS, ALL_ERRORMSGS'
            IF @DataPurity = 'Y' SET @CurrentCommand += ', DATA_PURITY'
            IF @PhysicalOnly = 'Y' SET @CurrentCommand += ', PHYSICAL_ONLY'
            IF @ExtendedLogicalChecks = 'Y' SET @CurrentCommand += ', EXTENDED_LOGICAL_CHECKS'
            IF @TabLock = 'Y' SET @CurrentCommand += ', TABLOCK'
            IF @MaxDOP IS NOT NULL SET @CurrentCommand += ', MAXDOP = ' + CAST(@MaxDOP AS nvarchar)

            EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @LogToTable = @LogToTable, @Execute = @Execute
            SET @Error = @@ERROR
            IF @Error <> 0 SET @CurrentCommandOutput = @Error
            IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
          END

          UPDATE @tmpObjects
          SET Completed = 1
          WHERE Selected = 1
          AND Completed = 0
          AND ID = @CurrentOID

          SET @CurrentOID = NULL
          SET @CurrentSchemaID = NULL
          SET @CurrentSchemaName = NULL
          SET @CurrentObjectID = NULL
          SET @CurrentObjectName = NULL
          SET @CurrentObjectType = NULL
          SET @CurrentObjectExists = NULL

          SET @CurrentDatabaseContext = NULL
          SET @CurrentCommand = NULL
          SET @CurrentCommandOutput = NULL
          SET @CurrentCommandType = NULL
        END
      END

      -- Check catalog
      IF EXISTS(SELECT * FROM @SelectedCheckCommands WHERE CheckCommand = 'CHECKCATALOG') AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentDatabaseContext = CASE WHEN SERVERPROPERTY('EngineEdition') = 5 THEN @CurrentDatabaseName ELSE 'master' END

        SET @CurrentCommandType = 'DBCC_CHECKCATALOG'

        SET @CurrentCommand = ''
        IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
        SET @CurrentCommand += 'DBCC CHECKCATALOG (' + QUOTENAME(@CurrentDatabaseName)
        SET @CurrentCommand += ') WITH NO_INFOMSGS'

        EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseContext, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 1, @DatabaseName = @CurrentDatabaseName, @LogToTable = @LogToTable, @Execute = @Execute
        SET @Error = @@ERROR
        IF @Error <> 0 SET @CurrentCommandOutput = @Error
        IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
      END

    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      SET @Error = @@ERROR
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL

    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentAvailabilityGroupBackupPreference = NULL
    SET @CurrentSecondaryRoleAllowConnections = NULL
    SET @CurrentIsPreferredBackupReplica = NULL
    SET @CurrentDatabaseMirroringRole = NULL

    SET @CurrentDatabaseContext = NULL
    SET @CurrentCommand = NULL
    SET @CurrentCommandOutput = NULL
    SET @CurrentCommandType = NULL

    DELETE FROM @tmpFileGroups
    DELETE FROM @tmpObjects

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Db_Drive_Growth
-- --------------------------------------------------
Create   procedure Db_Drive_Growth
(@dbname nvarchar(128),
@drive char(3),
@growthtype varchar(30),
@days int)
AS
BEGIN
set quoted_identifier off

IF NULLIF(@dbname, '') IS NOT NULL
BEGIN

IF OBJECT_ID(N'tempdb..#temp1') IS NOT NULL  
DROP TABLE #temp1  

create table #temp1
(Collection_time smalldatetime NOT NULL,
[database_name] [nvarchar](128) NOT NULL,
[used_space_mb] [decimal](20, 2) NOT NULL)

if (@growthtype='day')
begin
insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(day, -@days, getdate()) 
group by database_name,collection_time
order by collection_time asc

insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(day, -@days, getdate()) 
group by database_name,collection_time
order by collection_time desc
END

if (@growthtype='week')
begin
insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(week, -@days, getdate()) 
group by database_name,collection_time
order by collection_time asc

insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(week, -@days, getdate()) 
group by database_name,collection_time
order by collection_time desc
END

if (@growthtype='month')
begin
insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(month, -@days, getdate()) 
group by database_name,collection_time
order by collection_time asc

insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(month, -@days, getdate()) 
group by database_name,collection_time
order by collection_time desc
END

if (@growthtype='year')
begin
insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(year, -@days, getdate()) 
group by database_name,collection_time
order by collection_time asc

insert into #temp1
SELECT top 1 collection_time,database_name,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE database_name=@dbname and file_type='ROWS'
and  collection_time >= DATEADD(year, -@days, getdate()) 
group by database_name,collection_time
order by collection_time desc
END

END


IF NULLIF(@drive, '') IS NOT NULL
BEGIN

IF OBJECT_ID(N'tempdb..#temp2') IS NOT NULL  
DROP TABLE #temp2  

create table #temp2
(Collection_time smalldatetime NOT NULL,
[file_drive] [nvarchar](128) NOT NULL,
[used_space_mb] [decimal](20, 2) NOT NULL)

if (@growthtype='day')
begin
insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE file_drive=@drive 
and  collection_time >= DATEADD(day, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time asc

insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE file_drive=@drive 
and  collection_time >= DATEADD(day, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time desc
end

if (@growthtype='week')
begin
insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE file_drive=@drive 
and  collection_time >= DATEADD(week, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time asc

insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE file_drive=@drive 
and  collection_time >= DATEADD(week, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time desc
end

if (@growthtype='month')
begin
insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE file_drive=@drive 
and  collection_time >= DATEADD(month, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time asc

insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE file_drive=@drive 
and  collection_time >= DATEADD(month, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time desc
end

if (@growthtype='year')
begin
insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb) 
FROM [DBA_Admin].[dbo].[db_size_daily_report]  
WHERE file_drive=@drive 
and  collection_time >= DATEADD(year, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time asc

insert into #temp2
SELECT top 1 collection_time,file_drive,sum(used_space_mb)
FROM [DBA_Admin].[dbo].[db_size_daily_report]
WHERE file_drive=@drive 
and  collection_time >= DATEADD(year, -@days, getdate()) 
group by file_drive,collection_time
order by collection_time desc
end

END


IF NULLIF(@dbname, '') IS NOT NULL
BEGIN
select top 1 'Past ' +convert(varchar(30),@days) +' ' +@growthtype +' growth of ' +@dbname +' Database = '
+convert(varchar(128), (select used_space_mb FROM #temp1 where Collection_time=(select max(Collection_time) from #temp1))  - 
(select used_space_mb FROM #temp1 where Collection_time=(select min(Collection_time) from #temp1))) +' MB' AS GROWTH
FROM #temp1
END

IF NULLIF(@drive, '') IS NOT NULL
BEGIN
select top 1 'Past ' +convert(varchar(30),@days) +' ' +@growthtype +' growth of ' +@drive +' Drive = '
+convert(varchar(128), (select used_space_mb FROM #temp2 where Collection_time=(select max(Collection_time) from #temp2))  - 
(select used_space_mb FROM #temp2 where Collection_time=(select min(Collection_time) from #temp2))) +' MB' AS GROWTH
FROM #temp2
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBSizeDailyReport_P
-- --------------------------------------------------
create procedure [DBSizeDailyReport_P]
as
DECLARE @todaydate DATE,
            @weekDate DATETIME,
            @weekID INT
SET @todaydate=(SELECT CONVERT(VARCHAR(10),GETDATE(),111))
SELECT @weekDate=GETDATE()
SET @weekID= (SELECT (DATEPART(DY, @weekDate)))
IF EXISTS (SELECT 1 FROM [DBSizeDailyReport] WHERE ServerName = @@SERVERNAME  and WeekID = @weekID and Date = @todaydate )
      BEGIN
	  DELETE FROM [DBSizeDailyReport] Where ServerName = @@SERVERNAME and WeekID = @weekID
 insert into DBSizeDailyReport
 EXECUTE master.sys.sp_MSforeachdb 'DECLARE @todaydate DATE,
            @weekDate DATETIME,
            @weekID INT
SET @todaydate=(SELECT CONVERT(VARCHAR(10),GETDATE(),111))
SELECT @weekDate=GETDATE()
SET @weekID= (SELECT (DATEPART(DY, @weekDate)));
USE [?];
 select @@servername,CONVERT(varchar(30),CONNECTIONPROPERTY(''local_net_address'')),x.[DATABASE NAME],x.[total size data],x.[space util],y.[total size log],y.[space util],
 y.[total size log]+x.[total size data] ''total db size'',@weekID,@todaydate
  from (select DB_NAME() ''DATABASE NAME'',
 sum(size*8/1024) ''total size data'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=0
 group by type_desc  ) as x ,
 (select 
 sum(size*8/1024) ''total size log'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=1
 group by type_desc  )y'
 END
 ELSE
      BEGIN
 insert into DBSizeDailyReport
 EXECUTE master.sys.sp_MSforeachdb 'DECLARE @todaydate DATE,
            @weekDate DATETIME,
            @weekID INT
SET @todaydate=(SELECT CONVERT(VARCHAR(10),GETDATE(),111))
SELECT @weekDate=GETDATE()
SET @weekID= (SELECT (DATEPART(DY, @weekDate)));
USE [?];
 select @@servername,CONVERT(varchar(30),CONNECTIONPROPERTY(''local_net_address'')),x.[DATABASE NAME],x.[total size data],x.[space util],y.[total size log],y.[space util],
 y.[total size log]+x.[total size data] ''total db size'',@weekID,@todaydate
  from (select DB_NAME() ''DATABASE NAME'',
 sum(size*8/1024) ''total size data'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=0
 group by type_desc  ) as x ,
 (select 
 sum(size*8/1024) ''total size log'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=1
 group by type_desc  )y'
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IndexOptimize
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[IndexOptimize]

@Databases nvarchar(max) = NULL,
@FragmentationLow nvarchar(max) = NULL,
@FragmentationMedium nvarchar(max) = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh nvarchar(max) = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 int = 5,
@FragmentationLevel2 int = 30,
@MinNumberOfPages int = 1000,
@MaxNumberOfPages int = NULL,
@SortInTempdb nvarchar(max) = 'N',
@MaxDOP int = NULL,
@FillFactor int = NULL,
@PadIndex nvarchar(max) = NULL,
@LOBCompaction nvarchar(max) = 'Y',
@UpdateStatistics nvarchar(max) = NULL,
@OnlyModifiedStatistics nvarchar(max) = 'N',
@StatisticsModificationLevel int = NULL,
@StatisticsSample int = NULL,
@StatisticsResample nvarchar(max) = 'N',
@PartitionLevel nvarchar(max) = 'Y',
@MSShippedObjects nvarchar(max) = 'N',
@Indexes nvarchar(max) = NULL,
@TimeLimit int = NULL,
@Delay int = NULL,
@WaitAtLowPriorityMaxDuration int = NULL,
@WaitAtLowPriorityAbortAfterWait nvarchar(max) = NULL,
@Resumable nvarchar(max) = 'N',
@AvailabilityGroups nvarchar(max) = NULL,
@LockTimeout int = NULL,
@LockMessageSeverity int = 16,
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2022-12-03 17:23:44                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET ARITHABORT ON

  SET NUMERIC_ROUNDABORT OFF

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @Severity int

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)

  DECLARE @PartitionLevelStatistics bit

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentExecuteAsUserExists bit
  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)

  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)
  DECLARE @CurrentComment nvarchar(max)
  DECLARE @CurrentExtendedInfo xml

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @CurrentIxID int
  DECLARE @CurrentIxOrder int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentIsMemoryOptimized bit
  DECLARE @CurrentIndexID int
  DECLARE @CurrentIndexName nvarchar(max)
  DECLARE @CurrentIndexType int
  DECLARE @CurrentStatisticsID int
  DECLARE @CurrentStatisticsName nvarchar(max)
  DECLARE @CurrentPartitionID bigint
  DECLARE @CurrentPartitionNumber int
  DECLARE @CurrentPartitionCount int
  DECLARE @CurrentIsPartition bit
  DECLARE @CurrentIndexExists bit
  DECLARE @CurrentStatisticsExists bit
  DECLARE @CurrentIsImageText bit
  DECLARE @CurrentIsNewLOB bit
  DECLARE @CurrentIsFileStream bit
  DECLARE @CurrentIsColumnStore bit
  DECLARE @CurrentIsComputed bit
  DECLARE @CurrentIsTimestamp bit
  DECLARE @CurrentAllowPageLocks bit
  DECLARE @CurrentNoRecompute bit
  DECLARE @CurrentIsIncremental bit
  DECLARE @CurrentRowCount bigint
  DECLARE @CurrentModificationCounter bigint
  DECLARE @CurrentOnReadOnlyFileGroup bit
  DECLARE @CurrentResumableIndexOperation bit
  DECLARE @CurrentFragmentationLevel float
  DECLARE @CurrentPageCount bigint
  DECLARE @CurrentFragmentationGroup nvarchar(max)
  DECLARE @CurrentAction nvarchar(max)
  DECLARE @CurrentMaxDOP int
  DECLARE @CurrentUpdateStatistics nvarchar(max)
  DECLARE @CurrentStatisticsSample int
  DECLARE @CurrentStatisticsResample nvarchar(max)
  DECLARE @CurrentDelay datetime

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               StartPosition int,
                               DatabaseSize bigint,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @tmpIndexesStatistics TABLE (ID int IDENTITY,
                                       SchemaID int,
                                       SchemaName nvarchar(max),
                                       ObjectID int,
                                       ObjectName nvarchar(max),
                                       ObjectType nvarchar(max),
                                       IsMemoryOptimized bit,
                                       IndexID int,
                                       IndexName nvarchar(max),
                                       IndexType int,
                                       AllowPageLocks bit,
                                       IsImageText bit,
                                       IsNewLOB bit,
                                       IsFileStream bit,
                                       IsColumnStore bit,
                                       IsComputed bit,
                                       IsTimestamp bit,
                                       OnReadOnlyFileGroup bit,
                                       ResumableIndexOperation bit,
                                       StatisticsID int,
                                       StatisticsName nvarchar(max),
                                       [NoRecompute] bit,
                                       IsIncremental bit,
                                       PartitionID bigint,
                                       PartitionNumber int,
                                       PartitionCount int,
                                       StartPosition int,
                                       [Order] int,
                                       Selected bit,
                                       Completed bit,
                                       PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @SelectedIndexes TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  IndexName nvarchar(max),
                                  StartPosition int,
                                  Selected bit)

  DECLARE @Actions TABLE ([Action] nvarchar(max))

  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')

  DECLARE @ActionsPreferred TABLE (FragmentationGroup nvarchar(max),
                                   [Priority] int,
                                   [Action] nvarchar(max))

  DECLARE @CurrentActionsAllowed TABLE ([Action] nvarchar(max))

  DECLARE @CurrentAlterIndexWithClauseArguments TABLE (ID int IDENTITY,
                                                       Argument nvarchar(max),
                                                       Added bit DEFAULT 0)

  DECLARE @CurrentAlterIndexArgumentID int
  DECLARE @CurrentAlterIndexArgument nvarchar(max)
  DECLARE @CurrentAlterIndexWithClause nvarchar(max)

  DECLARE @CurrentUpdateStatisticsWithClauseArguments TABLE (ID int IDENTITY,
                                                             Argument nvarchar(max),
                                                             Added bit DEFAULT 0)

  DECLARE @CurrentUpdateStatisticsArgumentID int
  DECLARE @CurrentUpdateStatisticsArgument nvarchar(max)
  DECLARE @CurrentUpdateStatisticsWithClause nvarchar(max)

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLow = ' + ISNULL('''' + REPLACE(@FragmentationLow,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationMedium = ' + ISNULL('''' + REPLACE(@FragmentationMedium,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationHigh = ' + ISNULL('''' + REPLACE(@FragmentationHigh,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
  SET @Parameters += ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
  SET @Parameters += ', @MinNumberOfPages = ' + ISNULL(CAST(@MinNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @MaxNumberOfPages = ' + ISNULL(CAST(@MaxNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @SortInTempdb = ' + ISNULL('''' + REPLACE(@SortInTempdb,'''','''''') + '''','NULL')
  SET @Parameters += ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @Parameters += ', @FillFactor = ' + ISNULL(CAST(@FillFactor AS nvarchar),'NULL')
  SET @Parameters += ', @PadIndex = ' + ISNULL('''' + REPLACE(@PadIndex,'''','''''') + '''','NULL')
  SET @Parameters += ', @LOBCompaction = ' + ISNULL('''' + REPLACE(@LOBCompaction,'''','''''') + '''','NULL')
  SET @Parameters += ', @UpdateStatistics = ' + ISNULL('''' + REPLACE(@UpdateStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @OnlyModifiedStatistics = ' + ISNULL('''' + REPLACE(@OnlyModifiedStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @StatisticsModificationLevel = ' + ISNULL(CAST(@StatisticsModificationLevel AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsSample = ' + ISNULL(CAST(@StatisticsSample AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsResample = ' + ISNULL('''' + REPLACE(@StatisticsResample,'''','''''') + '''','NULL')
  SET @Parameters += ', @PartitionLevel = ' + ISNULL('''' + REPLACE(@PartitionLevel,'''','''''') + '''','NULL')
  SET @Parameters += ', @MSShippedObjects = ' + ISNULL('''' + REPLACE(@MSShippedObjects,'''','''''') + '''','NULL')
  SET @Parameters += ', @Indexes = ' + ISNULL('''' + REPLACE(@Indexes,'''','''''') + '''','NULL')
  SET @Parameters += ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @Parameters += ', @Delay = ' + ISNULL(CAST(@Delay AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityMaxDuration = ' + ISNULL(CAST(@WaitAtLowPriorityMaxDuration AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityAbortAfterWait = ' + ISNULL('''' + REPLACE(@WaitAtLowPriorityAbortAfterWait,'''','''''') + '''','NULL')
  SET @Parameters += ', @Resumable = ' + ISNULL('''' + REPLACE(@Resumable,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @Parameters += ', @LockMessageSeverity = ' + ISNULL(CAST(@LockMessageSeverity AS nvarchar),'NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExecuteAsUser = ' + ISNULL('''' + REPLACE(@ExecuteAsUser,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 0

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Select indexes                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Indexes = REPLACE(@Indexes, CHAR(10), '')
  SET @Indexes = REPLACE(@Indexes, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Indexes = LTRIM(RTRIM(@Indexes));

  WITH Indexes1 (StartPosition, EndPosition, IndexItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) - 1) AS IndexItem
  WHERE @Indexes IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) - EndPosition - 1) AS IndexItem
  FROM Indexes1
  WHERE EndPosition < LEN(@Indexes) + 1
  ),
  Indexes2 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem LIKE '-%' THEN RIGHT(IndexItem,LEN(IndexItem) - 1) ELSE IndexItem END AS IndexItem,
         StartPosition,
         CASE WHEN IndexItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Indexes1
  ),
  Indexes3 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem = 'ALL_INDEXES' THEN '%.%.%.%' ELSE IndexItem END AS IndexItem,
         StartPosition,
         Selected
  FROM Indexes2
  ),
  Indexes4 (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,3) ELSE PARSENAME(IndexItem,4) END AS DatabaseName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,2) ELSE PARSENAME(IndexItem,3) END AS SchemaName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,1) ELSE PARSENAME(IndexItem,2) END AS ObjectName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN '%' ELSE PARSENAME(IndexItem,1) END AS IndexName,
         StartPosition,
         Selected
  FROM Indexes3
  )
  INSERT INTO @SelectedIndexes (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected
  FROM Indexes4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select actions                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @FragmentationLow = REPLACE(@FragmentationLow, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationLow (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) - 1) AS [Action]
  WHERE @FragmentationLow IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationLow
  WHERE EndPosition < LEN(@FragmentationLow) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Low' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationLow
  OPTION (MAXRECURSION 0)

  SET @FragmentationMedium = REPLACE(@FragmentationMedium, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationMedium (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) - 1) AS [Action]
  WHERE @FragmentationMedium IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationMedium
  WHERE EndPosition < LEN(@FragmentationMedium) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Medium' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationMedium
  OPTION (MAXRECURSION 0)

  SET @FragmentationHigh = REPLACE(@FragmentationHigh, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationHigh (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) - 1) AS [Action]
  WHERE @FragmentationHigh IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationHigh
  WHERE EndPosition < LEN(@FragmentationHigh) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'High' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationHigh
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'High' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'High' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 1
  END

  IF @FragmentationLevel1 >= @FragmentationLevel2
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 1
  END

  IF @FragmentationLevel2 <= @FragmentationLevel1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @MinNumberOfPages < 0 OR @MinNumberOfPages IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxNumberOfPages < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @SortInTempdb NOT IN('Y','N') OR @SortInTempdb IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @SortInTempdb is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxDOP < 0 OR @MaxDOP > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FillFactor <= 0 OR @FillFactor > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FillFactor is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @PadIndex NOT IN('Y','N')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PadIndex is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LOBCompaction NOT IN('Y','N') OR @LOBCompaction IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LOBCompaction is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @UpdateStatistics NOT IN('ALL','COLUMNS','INDEX')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @UpdateStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics NOT IN('Y','N') OR @OnlyModifiedStatistics IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @OnlyModifiedStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsModificationLevel <= 0 OR @StatisticsModificationLevel > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsModificationLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics = 'Y' AND @StatisticsModificationLevel IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @OnlyModifiedStatistics and @StatisticsModificationLevel.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsSample <= 0 OR @StatisticsSample  > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsSample is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsResample NOT IN('Y','N') OR @StatisticsResample IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 1
  END

  IF @StatisticsResample = 'Y' AND @StatisticsSample IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @PartitionLevel NOT IN('Y','N') OR @PartitionLevel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PartitionLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MSShippedObjects NOT IN('Y','N') OR @MSShippedObjects IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MSShippedObjects is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedIndexes WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL OR IndexName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 1
  END

  IF @Indexes IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedIndexes)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeLimit < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeLimit is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Delay < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Delay is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityMaxDuration < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityMaxDuration IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityAbortAfterWait NOT IN('NONE','SELF','BLOCKERS')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF (@WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @WaitAtLowPriorityMaxDuration IS NULL) OR (@WaitAtLowPriorityAbortAfterWait IS NULL AND @WaitAtLowPriorityMaxDuration IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @WaitAtLowPriorityMaxDuration and @WaitAtLowPriorityAbortAfterWait can only be used together.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Resumable NOT IN('Y','N') OR @Resumable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 1
  END

  IF @Resumable = 'Y' AND NOT (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5, 8))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 2
  END

  IF @Resumable = 'Y' AND @SortInTempdb = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Resumable and @SortInTempdb.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockTimeout < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockTimeout is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockMessageSeverity NOT IN(10, 16)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @Indexes parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Should statistics be updated on the partition level?                                       //--
  ----------------------------------------------------------------------------------------------------

  SET @PartitionLevelStatistics = CASE WHEN @PartitionLevel = 'Y' AND ((@Version >= 12.05 AND @Version < 13) OR @Version >= 13.04422 OR SERVERPROPERTY('EngineEdition') IN (5,8)) THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
      BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    IF @ExecuteAsUser IS NOT NULL
    BEGIN
      SET @CurrentCommand = ''
      SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.database_principals database_principals WHERE database_principals.[name] = @ParamExecuteAsUser) BEGIN SET @ParamExecuteAsUserExists = 1 END ELSE BEGIN SET @ParamExecuteAsUserExists = 0 END'

      EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamExecuteAsUser sysname, @ParamExecuteAsUserExists bit OUTPUT', @ParamExecuteAsUser = @ExecuteAsUser, @ParamExecuteAsUserExists = @CurrentExecuteAsUserExists OUTPUT
    END

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name]
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentExecuteAsUserExists = 0
    BEGIN
      SET @DatabaseMessage = 'The user ' + QUOTENAME(@ExecuteAsUser) + ' does not exist in the database ' + QUOTENAME(@CurrentDatabaseName) + '.'
      RAISERROR('%s',16,1,@DatabaseMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') = 'READ_WRITE'
    AND (@CurrentExecuteAsUserExists = 1 OR @CurrentExecuteAsUserExists IS NULL)
    BEGIN

      -- Select indexes in the current database
      IF (EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IS NOT NULL) AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'
                              + ' SELECT SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, NoRecompute, IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed'
                              + ' FROM ('

        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', indexes.index_id AS IndexID'
                                                    + ', indexes.[name] AS IndexName'
                                                    + ', indexes.[type] AS IndexType'
                                                    + ', indexes.allow_page_locks AS AllowPageLocks'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id WHERE columns.[object_id] = objects.object_id AND types.name IN(''image'',''text'',''ntext'')) THEN 1 ELSE 0 END AS IsImageText'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE columns.[object_id] = objects.object_id AND (types.name IN(''xml'') OR (types.name IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1'
                                                    + ' WHEN indexes.[type] = 2 AND EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND (types.[name] IN(''xml'') OR (types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1 ELSE 0 END AS IsNewLOB'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns WHERE columns.[object_id] = objects.object_id  AND columns.is_filestream = 1) THEN 1 ELSE 0 END AS IsFileStream'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = objects.object_id AND [type] IN(5,6)) THEN 1 ELSE 0 END AS IsColumnStore'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.object_id = columns.object_id AND index_columns.column_id = columns.column_id WHERE (index_columns.key_ordinal > 0 OR index_columns.partition_ordinal > 0) AND columns.is_computed = 1 AND index_columns.object_id = indexes.object_id AND index_columns.index_id = indexes.index_id) THEN 1 ELSE 0 END AS IsComputed'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.system_type_id WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND types.[name] = ''timestamp'') THEN 1 ELSE 0 END AS IsTimestamp'

                                                    + ', CASE WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.destination_data_spaces destination_data_spaces ON indexes.data_space_id = destination_data_spaces.partition_scheme_id INNER JOIN sys.filegroups filegroups ON destination_data_spaces.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes2.[object_id] = indexes.[object_id] AND indexes2.[index_id] = indexes.index_id' + CASE WHEN @PartitionLevel = 'Y' THEN ' AND destination_data_spaces.destination_id = partitions.partition_number' ELSE '' END + ') THEN 1'
                                                    + ' WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.filegroups filegroups ON indexes.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = indexes2.[object_id] AND indexes.[index_id] = indexes2.index_id) THEN 1'
                                                    + ' WHEN indexes.[type] = 1 AND EXISTS (SELECT * FROM sys.tables tables INNER JOIN sys.filegroups filegroups ON tables.lob_data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND tables.[object_id] = objects.[object_id]) THEN 1 ELSE 0 END AS OnReadOnlyFileGroup'

                                                    + ', ' + CASE WHEN @Version >= 14 THEN 'CASE WHEN EXISTS(SELECT * FROM sys.index_resumable_operations index_resumable_operations WHERE state_desc = ''PAUSED'' AND index_resumable_operations.object_id = indexes.object_id AND index_resumable_operations.index_id = indexes.index_id AND (index_resumable_operations.partition_number = partitions.partition_number OR index_resumable_operations.partition_number IS NULL)) THEN 1 ELSE 0 END' ELSE '0' END + ' AS ResumableIndexOperation'

                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_id AS PartitionID' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionID' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_number AS PartitionNumber' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionNumber' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'IndexPartitions.partition_count AS PartitionCount' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionCount' END
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.indexes indexes'
                                                    + ' INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'
                                                    + ' LEFT OUTER JOIN sys.stats stats ON indexes.[object_id] = stats.[object_id] AND indexes.[index_id] = stats.[stats_id]'
          IF @PartitionLevel = 'Y'
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' LEFT OUTER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id'
                                                      + ' LEFT OUTER JOIN (SELECT partitions.[object_id], partitions.index_id, COUNT(DISTINCT partitions.partition_number) AS partition_count FROM sys.partitions partitions GROUP BY partitions.[object_id], partitions.index_id) IndexPartitions ON partitions.[object_id] = IndexPartitions.[object_id] AND partitions.[index_id] = IndexPartitions.[index_id]'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND indexes.[type] IN(1,2,3,4,5,6,7)'
                                                    + ' AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0'
        END

        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL'
        BEGIN
          SET @CurrentCommand = @CurrentCommand + ' UNION '
        END

        IF @UpdateStatistics IN('ALL','COLUMNS')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', NULL AS IndexID, NULL AS IndexName'
                                                    + ', NULL AS IndexType'
                                                    + ', NULL AS AllowPageLocks'
                                                    + ', NULL AS IsImageText'
                                                    + ', NULL AS IsNewLOB'
                                                    + ', NULL AS IsFileStream'
                                                    + ', NULL AS IsColumnStore'
                                                    + ', NULL AS IsComputed'
                                                    + ', NULL AS IsTimestamp'
                                                    + ', NULL AS OnReadOnlyFileGroup'
                                                    + ', NULL AS ResumableIndexOperation'
                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', NULL AS PartitionID'
                                                    + ', ' + CASE WHEN @PartitionLevelStatistics = 1 THEN 'dm_db_incremental_stats_properties.partition_number' ELSE 'NULL' END + ' AS PartitionNumber'
                                                    + ', NULL AS PartitionCount'
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.stats stats'
                                                    + ' INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'

          IF @PartitionLevelStatistics = 1
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' OUTER APPLY sys.dm_db_incremental_stats_properties(stats.object_id, stats.stats_id) dm_db_incremental_stats_properties'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND NOT EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = stats.[object_id] AND indexes.index_id = stats.stats_id)'
        END

        SET @CurrentCommand = @CurrentCommand + ') IndexesStatistics'

        INSERT INTO @tmpIndexesStatistics (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, [NoRecompute], IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand
        SET @Error = @@ERROR
        IF @Error <> 0
        BEGIN
          SET @ReturnCode = @Error
        END
      END

      IF @Indexes IS NULL
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = 1
        FROM @tmpIndexesStatistics tmpIndexesStatistics
      END
      ELSE
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 1

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 0

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.StartPosition = SelectedIndexes2.StartPosition
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN (SELECT tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName, MIN(SelectedIndexes.StartPosition) AS StartPosition
                    FROM @tmpIndexesStatistics tmpIndexesStatistics
                    INNER JOIN @SelectedIndexes SelectedIndexes
                    ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
                    WHERE SelectedIndexes.Selected = 1
                    GROUP BY tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName) SelectedIndexes2
        ON tmpIndexesStatistics.SchemaName = SelectedIndexes2.SchemaName
        AND tmpIndexesStatistics.ObjectName = SelectedIndexes2.ObjectName
        AND (tmpIndexesStatistics.IndexName = SelectedIndexes2.IndexName OR tmpIndexesStatistics.IndexName IS NULL)
        AND (tmpIndexesStatistics.StatisticsName = SelectedIndexes2.StatisticsName OR tmpIndexesStatistics.StatisticsName IS NULL)
      END;

      WITH tmpIndexesStatistics AS (
      SELECT SchemaName, ObjectName, [Order], ROW_NUMBER() OVER (ORDER BY ISNULL(ResumableIndexOperation,0) DESC, StartPosition ASC, SchemaName ASC, ObjectName ASC, CASE WHEN IndexType IS NULL THEN 1 ELSE 0 END ASC, IndexType ASC, IndexName ASC, StatisticsName ASC, PartitionNumber ASC) AS RowNumber
      FROM @tmpIndexesStatistics tmpIndexesStatistics
      WHERE Selected = 1
      )
      UPDATE tmpIndexesStatistics
      SET [Order] = RowNumber

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following objects in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + '.' + QUOTENAME(IndexName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName NOT LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName AND IndexName = SelectedIndexes.IndexName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following indexes in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SELECT TOP 1 @CurrentIxID = ID,
                     @CurrentIxOrder = [Order],
                     @CurrentSchemaID = SchemaID,
                     @CurrentSchemaName = SchemaName,
                     @CurrentObjectID = ObjectID,
                     @CurrentObjectName = ObjectName,
                     @CurrentObjectType = ObjectType,
                     @CurrentIsMemoryOptimized = IsMemoryOptimized,
                     @CurrentIndexID = IndexID,
                     @CurrentIndexName = IndexName,
                     @CurrentIndexType = IndexType,
                     @CurrentAllowPageLocks = AllowPageLocks,
                     @CurrentIsImageText = IsImageText,
                     @CurrentIsNewLOB = IsNewLOB,
                     @CurrentIsFileStream = IsFileStream,
                     @CurrentIsColumnStore = IsColumnStore,
                     @CurrentIsComputed = IsComputed,
                     @CurrentIsTimestamp = IsTimestamp,
                     @CurrentOnReadOnlyFileGroup = OnReadOnlyFileGroup,
                     @CurrentResumableIndexOperation = ResumableIndexOperation,
                     @CurrentStatisticsID = StatisticsID,
                     @CurrentStatisticsName = StatisticsName,
                     @CurrentNoRecompute = [NoRecompute],
                     @CurrentIsIncremental = IsIncremental,
                     @CurrentPartitionID = PartitionID,
                     @CurrentPartitionNumber = PartitionNumber,
                     @CurrentPartitionCount = PartitionCount
        FROM @tmpIndexesStatistics
        WHERE Selected = 1
        AND Completed = 0
        ORDER BY [Order] ASC

        IF @@ROWCOUNT = 0
        BEGIN
          BREAK
        END

        -- Is the index a partition?
        IF @CurrentPartitionNumber IS NULL OR @CurrentPartitionCount = 1 BEGIN SET @CurrentIsPartition = 0 END ELSE BEGIN SET @CurrentIsPartition = 1 END

        -- Does the index exist?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @CurrentIsPartition = 0 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType) BEGIN SET @ParamIndexExists = 1 END'
          IF @CurrentIsPartition = 1 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] INNER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType AND partitions.partition_id = @ParamPartitionID AND partitions.partition_number = @ParamPartitionNumber) BEGIN SET @ParamIndexExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamIndexID int, @ParamIndexName sysname, @ParamIndexType int, @ParamPartitionID bigint, @ParamPartitionNumber int, @ParamIndexExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamIndexID = @CurrentIndexID, @ParamIndexName = @CurrentIndexName, @ParamIndexType = @CurrentIndexType, @ParamPartitionID = @CurrentPartitionID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamIndexExists = @CurrentIndexExists OUTPUT

            IF @CurrentIndexExists IS NULL
            BEGIN
              SET @CurrentIndexExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Does the statistics exist?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.stats stats INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND stats.stats_id = @ParamStatisticsID AND stats.[name] = @ParamStatisticsName) BEGIN SET @ParamStatisticsExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamStatisticsID int, @ParamStatisticsName sysname, @ParamStatisticsExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsName = @CurrentStatisticsName, @ParamStatisticsExists = @CurrentStatisticsExists OUTPUT

            IF @CurrentStatisticsExists IS NULL
            BEGIN
              SET @CurrentStatisticsExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the statistics exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Has the data in the statistics been modified since the statistics was last updated?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_incremental_stats_properties (@ParamObjectID, @ParamStatisticsID) WHERE partition_number = @ParamPartitionNumber'
          END
          ELSE
          IF (@Version >= 10.504000 AND @Version < 11) OR @Version >= 11.03000
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_stats_properties (@ParamObjectID, @ParamStatisticsID)'
          END
          ELSE
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = rowcnt, @ParamModificationCounter = rowmodctr FROM sys.sysindexes sysindexes WHERE sysindexes.[id] = @ParamObjectID AND sysindexes.[indid] = @ParamStatisticsID'
          END

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamPartitionNumber int, @ParamRowCount bigint OUTPUT, @ParamModificationCounter bigint OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamRowCount = @CurrentRowCount OUTPUT, @ParamModificationCounter = @CurrentModificationCounter OUTPUT

            IF @CurrentRowCount IS NULL SET @CurrentRowCount = 0
            IF @CurrentModificationCounter IS NULL SET @CurrentModificationCounter = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The rows and modification_counter could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Is the index fragmented?
        IF @CurrentIndexID IS NOT NULL
        AND @CurrentOnReadOnlyFileGroup = 0
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3) OR @MinNumberOfPages > 0 OR @MaxNumberOfPages IS NOT NULL)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'SELECT @ParamFragmentationLevel = MAX(avg_fragmentation_in_percent), @ParamPageCount = SUM(page_count) FROM sys.dm_db_index_physical_stats(DB_ID(@ParamDatabaseName), @ParamObjectID, @ParamIndexID, @ParamPartitionNumber, ''LIMITED'') WHERE alloc_unit_type_desc = ''IN_ROW_DATA'' AND index_level = 0'

          BEGIN TRY
            EXECUTE sp_executesql @stmt = @CurrentCommand, @params = N'@ParamDatabaseName nvarchar(max), @ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamFragmentationLevel float OUTPUT, @ParamPageCount bigint OUTPUT', @ParamDatabaseName = @CurrentDatabaseName, @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamFragmentationLevel = @CurrentFragmentationLevel OUTPUT, @ParamPageCount = @CurrentPageCount OUTPUT
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The page_count and avg_fragmentation_in_percent could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Select fragmentation group
        IF @CurrentIndexID IS NOT NULL AND @CurrentOnReadOnlyFileGroup = 0 AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentFragmentationGroup = CASE
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel2 THEN 'High'
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 THEN 'Medium'
          WHEN @CurrentFragmentationLevel < @FragmentationLevel1 THEN 'Low'
          END
        END

        -- Which actions are allowed?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL) AND (@CurrentAllowPageLocks = 1 OR @CurrentIndexType = 5)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REORGANIZE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_OFFLINE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0
          AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          AND (@CurrentIsPartition = 0 OR @Version >= 12)
          AND ((@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 2 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsFileStream = 0 AND @Version >= 11)
          OR (@CurrentIndexType = 2 AND @Version >= 11))
          AND (@CurrentIsColumnStore = 0 OR @Version < 11)
          AND SERVERPROPERTY('EngineEdition') IN (3,5,8)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_ONLINE')
          END
        END

        -- Decide action
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (@CurrentPageCount >= @MinNumberOfPages OR @MinNumberOfPages = 0)
        AND (@CurrentPageCount <= @MaxNumberOfPages OR @MaxNumberOfPages IS NULL)
        AND @CurrentResumableIndexOperation = 0
        BEGIN
          IF EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3)
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE FragmentationGroup = @CurrentFragmentationGroup
            AND [Priority] = (SELECT MIN([Priority])
                              FROM @ActionsPreferred
                              WHERE FragmentationGroup = @CurrentFragmentationGroup
                              AND [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
          ELSE
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE [Priority] = (SELECT MIN([Priority])
                                FROM @ActionsPreferred
                                WHERE [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
        END

        IF @CurrentResumableIndexOperation = 1
        BEGIN
          SET @CurrentAction = 'INDEX_REBUILD_ONLINE'
        END

        -- Workaround for limitation in SQL Server, http://support.microsoft.com/kb/2292737
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentMaxDOP = @MaxDOP

          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentAllowPageLocks = 0
          BEGIN
            SET @CurrentMaxDOP = 1
          END
        END

        -- Update statistics?
        IF @CurrentStatisticsID IS NOT NULL
        AND ((@UpdateStatistics = 'ALL' AND (@CurrentIndexType IN (1,2,3,4,7) OR @CurrentIndexID IS NULL)) OR (@UpdateStatistics = 'INDEX' AND @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN (1,2,3,4,7)) OR (@UpdateStatistics = 'COLUMNS' AND @CurrentIndexID IS NULL))
        AND ((@OnlyModifiedStatistics = 'N' AND @StatisticsModificationLevel IS NULL) OR (@OnlyModifiedStatistics = 'Y' AND @CurrentModificationCounter > 0) OR ((@CurrentModificationCounter * 1. / NULLIF(@CurrentRowCount,0)) * 100 >= @StatisticsModificationLevel) OR (@StatisticsModificationLevel IS NOT NULL AND @CurrentModificationCounter > 0 AND (@CurrentModificationCounter >= SQRT(@CurrentRowCount * 1000))) OR (@CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8))))
        AND ((@CurrentIsPartition = 0 AND (@CurrentAction NOT IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') OR @CurrentAction IS NULL)) OR (@CurrentIsPartition = 1 AND (@CurrentPartitionNumber = @CurrentPartitionCount OR (@PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1))))
        BEGIN
          SET @CurrentUpdateStatistics = 'Y'
        END
        ELSE
        BEGIN
          SET @CurrentUpdateStatistics = 'N'
        END

        SET @CurrentStatisticsSample = @StatisticsSample
        SET @CurrentStatisticsResample = @StatisticsResample

        -- Memory-optimized tables only supports FULLSCAN and RESAMPLE in SQL Server 2014
        IF @CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND (@CurrentStatisticsSample <> 100 OR @CurrentStatisticsSample IS NULL)
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Incremental statistics only supports RESAMPLE
        IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Create index comment
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'ImageText: ' + CASE WHEN @CurrentIsImageText = 1 THEN 'Yes' WHEN @CurrentIsImageText = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'NewLOB: ' + CASE WHEN @CurrentIsNewLOB = 1 THEN 'Yes' WHEN @CurrentIsNewLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'FileStream: ' + CASE WHEN @CurrentIsFileStream = 1 THEN 'Yes' WHEN @CurrentIsFileStream = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 11 SET @CurrentComment += 'ColumnStore: ' + CASE WHEN @CurrentIsColumnStore = 1 THEN 'Yes' WHEN @CurrentIsColumnStore = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Computed: ' + CASE WHEN @CurrentIsComputed = 1 THEN 'Yes' WHEN @CurrentIsComputed = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Timestamp: ' + CASE WHEN @CurrentIsTimestamp = 1 THEN 'Yes' WHEN @CurrentIsTimestamp = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'AllowPageLocks: ' + CASE WHEN @CurrentAllowPageLocks = 1 THEN 'Yes' WHEN @CurrentAllowPageLocks = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'PageCount: ' + ISNULL(CAST(@CurrentPageCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'Fragmentation: ' + ISNULL(CAST(@CurrentFragmentationLevel AS nvarchar),'N/A')
        END

        IF @CurrentIndexID IS NOT NULL AND (@CurrentPageCount IS NOT NULL OR @CurrentFragmentationLevel IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentPageCount AS nvarchar) AS [PageCount],
                                                 CAST(@CurrentFragmentationLevel AS nvarchar) AS Fragmentation
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentIndexID IS NOT NULL AND @CurrentAction IS NOT NULL AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'ALTER_INDEX'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName)
          IF @CurrentResumableIndexOperation = 1 SET @CurrentCommand += ' RESUME'
          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REBUILD'
          IF @CurrentAction IN('INDEX_REORGANIZE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REORGANIZE'
          IF @CurrentIsPartition = 1 AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'Y' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = ON'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'N' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = OFF'
          END

          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = ON' + CASE WHEN @WaitAtLowPriorityMaxDuration IS NOT NULL THEN ' (WAIT_AT_LOW_PRIORITY (MAX_DURATION = ' + CAST(@WaitAtLowPriorityMaxDuration AS nvarchar) + ', ABORT_AFTER_WAIT = ' + UPPER(@WaitAtLowPriorityAbortAfterWait) + '))' ELSE '' END
          END

          IF @CurrentAction = 'INDEX_REBUILD_OFFLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = OFF'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentMaxDOP IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @FillFactor IS NOT NULL AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'FILLFACTOR = ' + CAST(@FillFactor AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @PadIndex = 'Y' AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'PAD_INDEX = ON'
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT CASE WHEN @Resumable = 'Y' AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 THEN 'RESUMABLE = ON' ELSE 'RESUMABLE = OFF' END
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0 AND @Resumable = 'Y'  AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 AND @TimeLimit IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAX_DURATION = ' + CAST(DATEDIFF(MINUTE,SYSDATETIME(),DATEADD(SECOND,@TimeLimit,@StartTime)) AS nvarchar(max))
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'Y'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = ON'
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'N'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = OFF'
          END

          IF EXISTS (SELECT * FROM @CurrentAlterIndexWithClauseArguments)
          BEGIN
            SET @CurrentAlterIndexWithClause = ' WITH ('

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentAlterIndexArgumentID = ID,
                           @CurrentAlterIndexArgument = Argument
              FROM @CurrentAlterIndexWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentAlterIndexWithClause += @CurrentAlterIndexArgument + ', '

              UPDATE @CurrentAlterIndexWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentAlterIndexArgumentID
            END

            SET @CurrentAlterIndexWithClause = RTRIM(@CurrentAlterIndexWithClause)

            SET @CurrentAlterIndexWithClause = LEFT(@CurrentAlterIndexWithClause,LEN(@CurrentAlterIndexWithClause) - 1)

            SET @CurrentAlterIndexWithClause = @CurrentAlterIndexWithClause + ')'
          END

          IF @CurrentAlterIndexWithClause IS NOT NULL SET @CurrentCommand += @CurrentAlterIndexWithClause

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @PartitionNumber = @CurrentPartitionNumber, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          IF @Delay > 0
          BEGIN
            SET @CurrentDelay = DATEADD(ss,@Delay,'1900-01-01')
            WAITFOR DELAY @CurrentDelay
          END
        END

        SET @CurrentMaxDOP = @MaxDOP

        -- Create statistics comment
        IF @CurrentStatisticsID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexID IS NOT NULL THEN 'Index' ELSE 'Column' END + ', '
          IF @CurrentIndexID IS NOT NULL SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'Incremental: ' + CASE WHEN @CurrentIsIncremental = 1 THEN 'Y' WHEN @CurrentIsIncremental = 0 THEN 'N' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'RowCount: ' + ISNULL(CAST(@CurrentRowCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'ModificationCounter: ' + ISNULL(CAST(@CurrentModificationCounter AS nvarchar),'N/A')
        END

        IF @CurrentStatisticsID IS NOT NULL AND (@CurrentRowCount IS NOT NULL OR @CurrentModificationCounter IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentRowCount AS nvarchar) AS [RowCount],
                                                 CAST(@CurrentModificationCounter AS nvarchar) AS ModificationCounter
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentStatisticsID IS NOT NULL AND @CurrentUpdateStatistics = 'Y' AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'UPDATE_STATISTICS'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'UPDATE STATISTICS ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentStatisticsName)

          IF @CurrentMaxDOP IS NOT NULL AND ((@Version >= 12.06024 AND @Version < 13) OR (@Version >= 13.05026 AND @Version < 14) OR @Version >= 14.030154)
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentStatisticsSample = 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'FULLSCAN'
          END

          IF @CurrentStatisticsSample IS NOT NULL AND @CurrentStatisticsSample <> 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'SAMPLE ' + CAST(@CurrentStatisticsSample AS nvarchar) + ' PERCENT'
          END

          IF @CurrentStatisticsResample = 'Y'
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'RESAMPLE'
          END

          IF @CurrentNoRecompute = 1
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'NORECOMPUTE'
          END

          IF EXISTS (SELECT * FROM @CurrentUpdateStatisticsWithClauseArguments)
          BEGIN
            SET @CurrentUpdateStatisticsWithClause = ' WITH'

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentUpdateStatisticsArgumentID = ID,
                           @CurrentUpdateStatisticsArgument = Argument
              FROM @CurrentUpdateStatisticsWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentUpdateStatisticsWithClause = @CurrentUpdateStatisticsWithClause + ' ' + @CurrentUpdateStatisticsArgument + ','

              UPDATE @CurrentUpdateStatisticsWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentUpdateStatisticsArgumentID
            END

            SET @CurrentUpdateStatisticsWithClause = LEFT(@CurrentUpdateStatisticsWithClause,LEN(@CurrentUpdateStatisticsWithClause) - 1)
          END

          IF @CurrentUpdateStatisticsWithClause IS NOT NULL SET @CurrentCommand += @CurrentUpdateStatisticsWithClause

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1 AND @CurrentPartitionNumber IS NOT NULL SET @CurrentCommand += ' ON PARTITIONS(' + CAST(@CurrentPartitionNumber AS nvarchar(max)) + ')'

          EXECUTE @CurrentCommandOutput = dbo.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @StatisticsName = @CurrentStatisticsName, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
        END

        NoAction:

        -- Update that the index or statistics is completed
        UPDATE @tmpIndexesStatistics
        SET Completed = 1
        WHERE Selected = 1
        AND Completed = 0
        AND [Order] = @CurrentIxOrder
        AND ID = @CurrentIxID

        -- Clear variables
        SET @CurrentDatabaseContext = NULL

        SET @CurrentCommand = NULL
        SET @CurrentCommandOutput = NULL
        SET @CurrentCommandType = NULL
        SET @CurrentComment = NULL
        SET @CurrentExtendedInfo = NULL

        SET @CurrentIxID = NULL
        SET @CurrentIxOrder = NULL
        SET @CurrentSchemaID = NULL
        SET @CurrentSchemaName = NULL
        SET @CurrentObjectID = NULL
        SET @CurrentObjectName = NULL
        SET @CurrentObjectType = NULL
        SET @CurrentIsMemoryOptimized = NULL
        SET @CurrentIndexID = NULL
        SET @CurrentIndexName = NULL
        SET @CurrentIndexType = NULL
        SET @CurrentStatisticsID = NULL
        SET @CurrentStatisticsName = NULL
        SET @CurrentPartitionID = NULL
        SET @CurrentPartitionNumber = NULL
        SET @CurrentPartitionCount = NULL
        SET @CurrentIsPartition = NULL
        SET @CurrentIndexExists = NULL
        SET @CurrentStatisticsExists = NULL
        SET @CurrentIsImageText = NULL
        SET @CurrentIsNewLOB = NULL
        SET @CurrentIsFileStream = NULL
        SET @CurrentIsColumnStore = NULL
        SET @CurrentIsComputed = NULL
        SET @CurrentIsTimestamp = NULL
        SET @CurrentAllowPageLocks = NULL
        SET @CurrentNoRecompute = NULL
        SET @CurrentIsIncremental = NULL
        SET @CurrentRowCount = NULL
        SET @CurrentModificationCounter = NULL
        SET @CurrentOnReadOnlyFileGroup = NULL
        SET @CurrentResumableIndexOperation = NULL
        SET @CurrentFragmentationLevel = NULL
        SET @CurrentPageCount = NULL
        SET @CurrentFragmentationGroup = NULL
        SET @CurrentAction = NULL
        SET @CurrentMaxDOP = NULL
        SET @CurrentUpdateStatistics = NULL
        SET @CurrentStatisticsSample = NULL
        SET @CurrentStatisticsResample = NULL
        SET @CurrentAlterIndexArgumentID = NULL
        SET @CurrentAlterIndexArgument = NULL
        SET @CurrentAlterIndexWithClause = NULL
        SET @CurrentUpdateStatisticsArgumentID = NULL
        SET @CurrentUpdateStatisticsArgument = NULL
        SET @CurrentUpdateStatisticsWithClause = NULL

        DELETE FROM @CurrentActionsAllowed
        DELETE FROM @CurrentAlterIndexWithClauseArguments
        DELETE FROM @CurrentUpdateStatisticsWithClauseArguments

      END

    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @Error = @@ERROR
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentExecuteAsUserExists = NULL
    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL

    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentDatabaseMirroringRole = NULL

    SET @CurrentCommand = NULL

    DELETE FROM @tmpIndexesStatistics

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.logiopsSP
-- --------------------------------------------------
Create proc [dbo].[logiopsSP] 
as
 
insert into LogIops
select db_name(mf.database_id) as database_name, mf.physical_name, 
left(mf.physical_name, 1) as drive_letter, 
vfs.num_of_writes, vfs.num_of_bytes_written, vfs.io_stall_write_ms, 
mf.type_desc, vfs.num_of_reads, vfs.num_of_bytes_read, vfs.io_stall_read_ms,
vfs.io_stall, vfs.size_on_disk_bytes,Recordtime = Getdate()
from sys.master_files mf
join sys.dm_io_virtual_file_stats(NULL, NULL) vfs
on mf.database_id=vfs.database_id and mf.file_id=vfs.file_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_WhatIsRunning
-- --------------------------------------------------

CREATE PROCEDURE dbo.sp_WhatIsRunning
(	@program_name nvarchar(1000) = NULL, 
	@login_name nvarchar(255) = NULL, 
	@database_name varchar(255) = NULL, 
	@session_id int = NULL, 
	@session_host_name nvarchar(255) = NULL, 
	@query_pattern nvarchar(200) = NULL, 
	@get_plans bit = 0
)
WITH RECOMPILE --,EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		1.0.0
		Date:			2022-05-03

		exec sp_WhatIsRunning @query_pattern = 'usp_SomeThingOther'
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	--	Query to find what's is running on server
	;WITH T_Requests AS 
	(
		select  [elapsed_time_s] = datediff(SECOND,COALESCE(r.start_time, s.last_request_start_time),GETDATE())
				,[elapsed_time_ms] = datediff(MILLISECOND,COALESCE(r.start_time, s.last_request_start_time),GETDATE())
				,s.session_id
				,st.text as sql_command
				,r.command as command
				,s.login_name as login_name
				,db_name(COALESCE(r.database_id,s.database_id)) as database_name
				,[program_name] = CASE	WHEN	s.program_name like 'SQLAgent - TSQL JobStep %'
						THEN	(	select	top 1 'SQL Job = '+j.name 
									from msdb.dbo.sysjobs (nolock) as j
									inner join msdb.dbo.sysjobsteps (nolock) AS js on j.job_id=js.job_id
									where right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring(s.program_name,30,34),10) 
								) + ' ( '+SUBSTRING(LTRIM(RTRIM(s.program_name)), CHARINDEX(': Step ',LTRIM(RTRIM(s.program_name)))+2,LEN(LTRIM(RTRIM(s.program_name)))-CHARINDEX(': Step ',LTRIM(RTRIM(s.program_name)))-2)+' )'  COLLATE SQL_Latin1_General_CP1_CI_AS
						ELSE	s.program_name
						END
				,(case when r.wait_time = 0 then null else r.wait_type end) as wait_type
				,r.wait_time as wait_time
				,(SELECT CASE
						WHEN pageid = 1 OR pageid % 8088 = 0 THEN 'PFS'
						WHEN pageid = 2 OR pageid % 511232 = 0 THEN 'GAM'
						WHEN pageid = 3 OR (pageid - 1) % 511232 = 0 THEN 'SGAM'
						WHEN pageid IS NULL THEN NULL
						ELSE 'Not PFS/GAM/SGAM' END
						FROM (SELECT CASE WHEN r.[wait_type] LIKE 'PAGE%LATCH%' AND r.[wait_resource] LIKE '%:%'
						THEN CAST(RIGHT(r.[wait_resource], LEN(r.[wait_resource]) - CHARINDEX(':', r.[wait_resource], LEN(r.[wait_resource])-CHARINDEX(':', REVERSE(r.[wait_resource])))) AS INT)
						ELSE NULL END AS pageid) AS latch_pageid
				) AS wait_resource_type
				,null as tempdb_allocations
				,null as tempdb_current
				,r.blocking_session_id
				,r.logical_reads as reads
				,r.writes as writes
				,r.cpu_time
				,granted_query_memory = CASE WHEN ((CAST(r.granted_query_memory AS numeric(20,2))*8)/1024/1024) >= 1.0
												THEN CAST(CONVERT(numeric(38,2),(CAST(r.granted_query_memory AS numeric(20,2))*8)/1024/1024) AS VARCHAR(23)) + ' GB'
												WHEN ((CAST(r.granted_query_memory AS numeric(20,2))*8)/1024) >= 1.0
												THEN CAST(CONVERT(numeric(38,2),(CAST(r.granted_query_memory AS numeric(20,2))*8)/1024) AS VARCHAR(23)) + ' MB'
												ELSE CAST((CAST(r.granted_query_memory AS numeric(20,2))*8) AS VARCHAR(23)) + ' KB'
												END
				,COALESCE(r.status, s.status) as status
				,open_transaction_count = s.open_transaction_count
				,s.host_name as host_name
				,COALESCE(r.start_time, s.last_request_start_time) as start_time
				,s.login_time as login_time
				,r.statement_start_offset ,r.statement_end_offset
				,[SqlQueryPlan] = case when @get_plans = 1 then CAST(sqp.query_plan AS xml) else null end
				,GETUTCDATE() as collection_time
				,granted_query_memory as granted_query_memory_raw
				,r.plan_handle ,r.sql_handle
		FROM	sys.dm_exec_sessions AS s
		LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
		OUTER APPLY (select top 1 dec.most_recent_sql_handle as [sql_handle] from sys.dm_exec_connections dec where dec.most_recent_session_id = s.session_id and dec.most_recent_sql_handle is not null) AS dec
		OUTER APPLY sys.dm_exec_sql_text(COALESCE(r.sql_handle,dec.sql_handle)) AS st
		OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS bqp
		OUTER APPLY sys.dm_exec_text_query_plan(r.plan_handle,r.statement_start_offset, r.statement_end_offset) as sqp
		WHERE	s.session_id != @@SPID
			AND (	(CASE	WHEN	s.session_id IN (select ri.blocking_session_id from sys.dm_exec_requests as ri)
							--	Get sessions involved in blocking (including system sessions)
							THEN	1
							WHEN	r.blocking_session_id IS NOT NULL AND r.blocking_session_id <> 0
							THEN	1
							ELSE	0
					END) = 1
					OR
					(CASE	WHEN	s.session_id > 50
									AND r.session_id IS NOT NULL -- either some part of session has active request
									--AND ISNULL(open_resultset_count,0) > 0 -- some result is open
									AND s.status <> 'sleeping'
							THEN	1
							ELSE	0
					END) = 1
					OR
					(CASE	WHEN	s.session_id > 50 AND s.open_transaction_count <> 0
							THEN	1
							ELSE	0
					END) = 1
				)		
	)
	SELECT	[collection_time] = getutcdate(),
			[dd hh:mm:ss.mss] = right('   0'+convert(varchar, elapsed_time_s/86400),4)+ ' '+convert(varchar,dateadd(MILLISECOND,elapsed_time_ms,'1900-01-01 00:00:00'),114),
			[session_id], [blocking_session_id], [command], 
			[wait_type], 
			[wait_time] = right('   0'+convert(varchar, [wait_time]/86400000),4)+ ' '+convert(varchar,dateadd(MILLISECOND,[wait_time],'1900-01-01 00:00:00'),114),
			[granted_query_memory], [program_name], [login_name], [database_name], [sql_command], 
			[plan_handle] ,[sql_handle], 
			--[wait_time], 
			[wait_resource_type], [tempdb_allocations], [tempdb_current], 
			[reads], [writes], [cpu_time], [status], [open_transaction_count], [host_name], [start_time], [login_time], 
			[statement_start_offset], [statement_end_offset]
	FROM T_Requests AS r
	WHERE 1 = 1
	AND	(( @query_pattern is null or len(@query_pattern) = 0 )
			or (	r.sql_command like ('%'+@query_pattern+'%')
				 )
		 ) 
	and ( @program_name is null or [program_name] like ('%'+@program_name+'%') COLLATE SQL_Latin1_General_CP1_CI_AS)
	and ( @login_name is null or [login_name] like ('%'+@login_name+'%') COLLATE SQL_Latin1_General_CP1_CI_AS)
	and ( @database_name is null or [database_name] like ('%'+@database_name+'%') COLLATE SQL_Latin1_General_CP1_CI_AS)
	and ( @session_id is null or [session_id] = @session_id )
	and ( @session_host_name is null or [host_name]like ('%'+@session_host_name+'%') COLLATE SQL_Latin1_General_CP1_CI_AS)
	and ( @query_pattern is null or sql_command like ('%'+@query_pattern+'%') COLLATE SQL_Latin1_General_CP1_CI_AS)
	ORDER BY start_time asc, granted_query_memory_raw desc
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.test
-- --------------------------------------------------
create proc test
as
DECLARE @spacetable table
 (
 database_name varchar(50) ,
 serverIp varchar(30),
 total_size_data int,
 space_util_data int,
 space_data_left int,
 percent_fill_data float,
 total_size_data_log int,
 space_util_log int,
 space_log_left int,
 percent_fill_log char(50),
 [total db size] int,
 [total size used] int,
 [total size left] int
 )
 insert into  @spacetable
 EXECUTE master.sys.sp_MSforeachdb 'USE [?];
 select x.[DATABASE NAME],CONVERT(varchar(30),CONNECTIONPROPERTY(''local_net_address'')),x.[total size data],x.[space util],x.[total size data]-x.[space util] [space left data],
 x.[percent fill],y.[total size log],y.[space util],
 y.[total size log]-y.[space util] [space left log],y.[percent fill],
 y.[total size log]+x.[total size data] ''total db size''
 ,x.[space util]+y.[space util] ''total size used'',
 (y.[total size log]+x.[total size data])-(y.[space util]+x.[space util]) ''total size left''
  from (select DB_NAME() ''DATABASE NAME'',
 sum(size*8/1024) ''total size data'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=0
 group by type_desc  ) as x ,
 (select 
 sum(size*8/1024) ''total size log'',sum(FILEPROPERTY(name,''SpaceUsed'')*8/1024) ''space util''
 ,case when sum(size*8/1024)=0 then ''less than 1% used'' else
 substring(cast((sum(FILEPROPERTY(name,''SpaceUsed''))*1.0*100/sum(size)) as CHAR(50)),1,6) end ''percent fill''
 from sys.master_files where database_id=DB_ID(DB_NAME())  and  type=1
 group by type_desc  )y'
 select * from @spacetable
 order by database_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_active_requests_count
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_active_requests_count
	@count smallint = -1 output
--WITH RECOMPILE, EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		1.0.0
		Date:			2022-07-15

		declare @active_requests_count smallint;
		exec usp_active_requests_count @count = @active_requests_count output;
		select [active_requests_count] = @active_requests_count;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 30000; -- 30 seconds
	
	DECLARE @passed_count smallint = @count;

	SELECT @count = COUNT(*)
	FROM	sys.dm_exec_sessions AS s
	LEFT JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
	OUTER APPLY (select top 1 dec.most_recent_sql_handle as [sql_handle] from sys.dm_exec_connections dec where dec.most_recent_session_id = s.session_id and dec.most_recent_sql_handle is not null) AS dec
	OUTER APPLY sys.dm_exec_sql_text(COALESCE(r.sql_handle,dec.sql_handle)) AS st
	OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS bqp
	OUTER APPLY sys.dm_exec_text_query_plan(r.plan_handle,r.statement_start_offset, r.statement_end_offset) as sqp
	WHERE	s.session_id != @@SPID
		AND (	(CASE	WHEN	s.session_id IN (select ri.blocking_session_id from sys.dm_exec_requests as ri)
						--	Get sessions involved in blocking (including system sessions)
						THEN	1
						WHEN	r.blocking_session_id IS NOT NULL AND r.blocking_session_id <> 0
						THEN	1
						ELSE	0
				END) = 1
				OR
				(CASE	WHEN	s.session_id > 50
								AND r.session_id IS NOT NULL -- either some part of session has active request
								--AND ISNULL(open_resultset_count,0) > 0 -- some result is open
								AND s.status <> 'sleeping'
						THEN	1
						ELSE	0
				END) = 1
				OR
				(CASE	WHEN	s.session_id > 50 AND s.open_transaction_count <> 0
						THEN	1
						ELSE	0
				END) = 1
			);

	IF @passed_count = -1
		SELECT @count as active_requests_count;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_avg_disk_latency_ms
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_avg_disk_latency_ms
	@avg_disk_latency_ms int = -1.0 output,
	@snapshot_interval_minutes int = 15,
	@type varchar(20) = 'read_write', /* read, write, read_write */
	@verbose tinyint = 0
--WITH RECOMPILE, EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		2024-10-22
		Date:			2024-10-22 - Enhancement#10 - Required for alerting

		declare @avg_disk_latency_ms bigint;
		exec usp_avg_disk_latency_ms @avg_disk_latency_ms = @avg_disk_latency_ms output;
		select [avg_disk_latency_ms] = @avg_disk_latency_ms;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 30000; -- 30 seconds
	
	DECLARE @passed_avg_disk_latency_ms smallint = @avg_disk_latency_ms;

	declare @collect_time_utc_snap1 datetime2;
	declare @collect_time_utc_snap2 datetime2;

	select top 1 @collect_time_utc_snap2 = collection_time_utc
	from dbo.file_io_stats s
	order by collection_time_utc desc;

	select top 1 @collect_time_utc_snap1 = collection_time_utc
	from dbo.file_io_stats s where collection_time_utc <= dateadd(minute,-@snapshot_interval_minutes,@collect_time_utc_snap2) -- 2 snapshots with a gap
	order by collection_time_utc desc;

	if @verbose >= 1
	begin
		print '@collect_time_utc_snap1 = '+convert(varchar,@collect_time_utc_snap1,121);
		print '@collect_time_utc_snap2 = '+convert(varchar,@collect_time_utc_snap2,121);
	end

	if @verbose >= 1
		print 'Compute delta file io stats..'
	;with iostats_snap1 as (
		select	sample_ms = max(sample_ms),
				io_stall_read_ms = sum(io_stall_read_ms),
				num_of_reads = sum(num_of_reads),
				io_stall_write_ms = sum(io_stall_write_ms),
				num_of_writes = sum(num_of_writes),
				io_stall = SUM(io_stall)
		from dbo.file_io_stats s1
		where s1.collection_time_utc = @collect_time_utc_snap1
		AND (num_of_reads > 0 or num_of_writes > 0)
	)
	,iostats_snap2 as (
		select	sample_ms = max(sample_ms),
				io_stall_read_ms = sum(io_stall_read_ms),
				num_of_reads = sum(num_of_reads),
				io_stall_write_ms = sum(io_stall_write_ms),
				num_of_writes = sum(num_of_writes),
				io_stall = SUM(io_stall)
		from dbo.file_io_stats s2
		where s2.collection_time_utc = @collect_time_utc_snap2
		AND (num_of_reads > 0 or num_of_writes > 0)
	)
	select @avg_disk_latency_ms = case when (s2.num_of_reads+s2.num_of_writes) > (s1.num_of_reads+s1.num_of_writes)
										then (s2.io_stall-s1.io_stall) / ((s2.num_of_reads+s2.num_of_writes) - (s1.num_of_reads+s1.num_of_writes))
										else 0
										end
	from iostats_snap1 s1, iostats_snap2 s2;

	SELECT [avg_disk_latency_ms] = isnull(@avg_disk_latency_ms,0);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_avg_disk_wait_ms
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_avg_disk_wait_ms
	@avg_disk_wait_ms decimal(20,2) = -1.0 output,
	@snapshot_interval_minutes int = 10,
	@consider_other_disk_io_waits bit = 1,
	@consider_tran_log_io_waits bit = 1,
	@verbose tinyint = 0
--WITH RECOMPILE, EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		2024-06-05
		Date:			2024-06-05 - Enhancement#42 - Get [avg_disk_wait_ms]

		declare @avg_disk_wait_ms bigint;
		exec usp_avg_disk_wait_ms @avg_disk_wait_ms = @avg_disk_wait_ms output;
		select [avg_disk_wait_ms] = @avg_disk_wait_ms;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 30000; -- 30 seconds
	
	DECLARE @passed_avg_disk_wait_ms smallint = @avg_disk_wait_ms;

	declare @collect_time_utc_snap1 datetime2;
	declare @collect_time_utc_snap2 datetime2;

	select top 1 @collect_time_utc_snap2 = collection_time_utc
	from dbo.wait_stats s
	order by collection_time_utc desc;

	select top 1 @collect_time_utc_snap1 = collection_time_utc
	from dbo.wait_stats s where collection_time_utc < dateadd(minute,-@snapshot_interval_minutes,@collect_time_utc_snap2) -- 2 snapshots with a gap
	order by collection_time_utc desc;

	if @verbose >= 1
	begin
		print '@collect_time_utc_snap1 = '+convert(varchar,@collect_time_utc_snap1,121);
		print '@collect_time_utc_snap2 = '+convert(varchar,@collect_time_utc_snap2,121);
	end

	if @verbose >= 1
		print 'Compute delta wait stats..'
	;with wait_snap1 as (
		select	wait_time_ms = sum(convert(bigint,wait_time_ms)), 
				waiting_tasks_count = sum(convert(bigint,waiting_tasks_count))
		from dbo.wait_stats s1
		where s1.collection_time_utc = @collect_time_utc_snap1
		and [wait_type] IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc 
								where wc.Ignorable = 0 
								and (	wc.WaitCategory = 'Buffer IO'
									or	( @consider_other_disk_io_waits = 1 and wc.WaitCategory = 'Other Disk IO' )
									or	( @consider_tran_log_io_waits = 1 and wc.WaitCategory = 'Tran Log IO' )
									)
							)
		AND [waiting_tasks_count] > 0
	)
	,wait_snap2 as (
		select	wait_time_ms = sum(convert(bigint,wait_time_ms)), 
				waiting_tasks_count = sum(convert(bigint,waiting_tasks_count))
		from dbo.wait_stats s2
		where s2.collection_time_utc = @collect_time_utc_snap2
		and [wait_type] IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc 
								where wc.Ignorable = 0 
								and (	wc.WaitCategory = 'Buffer IO'
									or	( @consider_other_disk_io_waits = 1 and wc.WaitCategory = 'Other Disk IO' )
									or	( @consider_tran_log_io_waits = 1 and wc.WaitCategory = 'Tran Log IO' )
									)
							)
		AND [waiting_tasks_count] > 0
	)
	select	@avg_disk_wait_ms = (s2.wait_time_ms - s1.wait_time_ms) / (s2.waiting_tasks_count - s1.waiting_tasks_count)
	from wait_snap1 s1, wait_snap2 s2;

	SELECT [avg_disk_wait_ms] = @avg_disk_wait_ms;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_avg_ms_per_disk_wait
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_avg_ms_per_disk_wait
	@avg_ms_per_wait decimal(20,2) = -1.0 output,
	@snapshot_interval_minutes int = 5,
	@verbose tinyint = 0
--WITH RECOMPILE, EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		2024-06-05
		Date:			2024-06-05 - Enhancement#42 - Get [avg_ms_per_disk_wait]

		declare @avg_ms_per_wait bigint;
		exec usp_avg_ms_per_disk_wait @avg_ms_per_wait = @avg_ms_per_wait output;
		select [avg_ms_per_disk_wait] = @avg_ms_per_wait;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 30000; -- 30 seconds
	
	DECLARE @passed_avg_ms_per_wait smallint = @avg_ms_per_wait;

	declare @collect_time_utc_snap1 datetime2;
	declare @collect_time_utc_snap2 datetime2;

	select top 1 @collect_time_utc_snap2 = collection_time_utc
	from dbo.wait_stats s
	order by collection_time_utc desc;

	select top 1 @collect_time_utc_snap1 = collection_time_utc
	from dbo.wait_stats s where collection_time_utc < dateadd(minute,-@snapshot_interval_minutes,@collect_time_utc_snap2) -- 2 snapshots with a gap
	order by collection_time_utc desc;

	if @verbose >= 1
	begin
		print '@collect_time_utc_snap1 = '+convert(varchar,@collect_time_utc_snap1,121);
		print '@collect_time_utc_snap2 = '+convert(varchar,@collect_time_utc_snap2,121);
	end

	if @verbose >= 1
		print 'Compute delta wait stats..'
	;with wait_snap1 as (
		select	wait_time_ms = sum(convert(bigint,wait_time_ms)), 
				waiting_tasks_count = sum(convert(bigint,waiting_tasks_count))
		from dbo.wait_stats s1
		where s1.collection_time_utc = @collect_time_utc_snap1
		and [wait_type] IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc 
								where wc.Ignorable = 0 
								and wc.WaitCategory in ('Other Disk IO','Tran Log IO','Buffer IO') )
		AND [waiting_tasks_count] > 0
	)
	,wait_snap2 as (
		select	wait_time_ms = sum(convert(bigint,wait_time_ms)), 
				waiting_tasks_count = sum(convert(bigint,waiting_tasks_count))
		from dbo.wait_stats s2
		where s2.collection_time_utc = @collect_time_utc_snap2
		and [wait_type] IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc 
								where wc.Ignorable = 0 
								and wc.WaitCategory in ('Other Disk IO','Tran Log IO','Buffer IO') )
		AND [waiting_tasks_count] > 0
	)
	select	@avg_ms_per_wait = (s2.wait_time_ms - s1.wait_time_ms) / (s2.waiting_tasks_count - s1.waiting_tasks_count)
	from wait_snap1 s1, wait_snap2 s2;

	SELECT [avg_ms_per_disk_wait] = @avg_ms_per_wait;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_capture_alert_messages
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_capture_alert_messages
(	@server_name nvarchar(128) = null, /* Alert Server Name */
	@database_name nvarchar(128) = null, /* Alert database */
	@error_number int = 0, /* Alert Error Number */
	@error_severity tinyint = 0, /* Alert Error Severity */
	@error_message nvarchar(510) = null, /* Alert Error Message */
	@host_instance nvarchar(128) = null, /* Name of the computer running SQL Server. If the SQL Server instance is a named instance, this includes the instance name.  */
	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Capture-AlertMessages', /* Subject of Failure Mail */
	@send_error_mail bit = 1 /* Send mail on failure */
)
AS 
BEGIN

	/*
		https://learn.microsoft.com/en-us/sql/ssms/agent/use-tokens-in-job-steps?view=sql-server-ver16
		Version:		1.0.0
		Date:			2024-04-26 - Initial Draft

		EXEC dbo.usp_capture_alert_messages
				@server_name = '$(ESCAPE_SQUOTE(A-SVR))',
				@database_name = '$(ESCAPE_SQUOTE(A-DBN))', 
				@error_number = $(ESCAPE_NONE(A-ERR)), 
				@error_severity = $(ESCAPE_NONE(A-SEV)), 
				@error_message = '$(ESCAPE_SQUOTE(A-MSG))', 
				@host_instance = '$(ESCAPE_SQUOTE(SRVR))',
				@recipients = 'dba_team@gmail.com';
		

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;

	SET @_job_name = '(dba) '+@alert_key;

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';
		insert [dbo].[alert_history]
			([server_name], [database_name], [error_number], [error_severity], [error_message], [host_instance])
		select	@server_name, @database_name, @error_number, @error_severity, @error_message, @host_instance;

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_sql;
		INSERT #CommandLog
		EXEC sp_executesql @_sql, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;


/*
select @@SPID;
RAISERROR (N'This is message %s %d.', -- Message text.
           19, -- Severity,
           1, -- State,
           N'number', -- First argument.
           5)
	with log; -- Second argument.
-- The message text returned is: This is message number 5.
*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_check_sql_agent_jobs
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_check_sql_agent_jobs]
(	@job_category_to_include nvarchar(2000) = null, /* Include jobs of only these categories || Delimiter separated list */
	@job_category_to_exclude nvarchar(2000) = null, /* Execute jobs of these categories || Delimiter separated list */
	@jobs_to_include nvarchar(2000) = null, /* Include these jobs only */
	@jobs_to_exclude nvarchar(2000) = null, /* Execute these jobs || Delimiter separated list */
	@delimiter char(4) = ',', /* Delimiter to separate entities in above parameters */
	@send_error_mail bit = 1, /* Send mail on failure */
	@default_threshold_continous_failure tinyint = 2, /* Send mail only when failure is x times continously */
	@default_notification_delay_minutes tinyint = 15, /* Send mail only after a gap of x minutes from last mail */ 
	@default_mail_recipient varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Check-SQLAgentJobs', /* Subject of Failure Mail */
	@reset_stats bit = 0, /* truncate table dbo.sql_agent_job_stats */
	@consider_disabled_jobs bit = 1, /* fetch history for disabled jobs also */
	@drop_recreate bit = 0, /* drop & recreate tables */
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0 /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */	
)
AS 
BEGIN

	/*
		Version:		1.6.1
		Purpose:		https://github.com/imajaydwivedi/SQLMonitor/issues/193
						Monitor SQL Agent jobs, and send mail when thresholds are crossed
		Updates:		2023-07-18 - Ajay=> Issue#269 - Add last execution Duration in table dbo.sql_agent_job_stats
						2023-07-03 - Ajay => Bug#265 - Disabled Jobs Not Appearing in Dashboard Panel SQLAgent Job Activity Monitor
						2023-05-08 - Ajay=> Initial Draft	
						2023-08-16 - Ajay => BugFix - Jobs which does not exist are not getting updated in column dbo.sql_agent_job_thresholds.IsNotFound

		EXEC dbo.usp_check_sql_agent_jobs @default_mail_recipient = 'dba_team@gmail.com'
		EXEC dbo.usp_check_sql_agent_jobs @default_mail_recipient = 'dba_team@gmail.com', @verbose = 2 ,@drop_recreate = 1
	
		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	--SET ANSI_WARNINGS OFF;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	IF (@default_mail_recipient IS NULL OR @default_mail_recipient = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@default_mail_recipient is mandatory parameter', 20, -1) with log;

	DECLARE @_output VARCHAR(8000);
	SET @_output = 'Declare local variables'+CHAR(10);
	-- Local Variables
	DECLARE @_rows_affected int = 0;
	DECLARE @_sqlString NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_columns VARCHAR(8000);
	DECLARE @_cpu_system int;
	DECLARE @_cpu_sql int;
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html  NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;
	DECLARE @_output_column_list VARCHAR(8000);
	DECLARE @_crlf nchar(2);
	DECLARE @_tab nchar(1);

	SET @_crlf = NCHAR(13)+NCHAR(10);
	SET @_tab = N'  '; --NCHAR(9);

	
	SET @_output_column_list = '[collection_time][dd hh:mm:ss.mss][session_id][program_name][login_name][database_name]
							[cpu][used_memory][open_tran_count][status][wait_info][sql_command]
							[blocked_session_count][blocking_session_id][sql_text][%]';

	SET @_job_name = '(dba) '+@alert_key;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY
		SET @_output += '<br>Start Try Block..'+@_crlf;
		IF @verbose > 0
			PRINT 'Start Try Block..';

		-- Drop tables if required
		IF @drop_recreate = 1
		BEGIN
			IF OBJECT_ID('dbo.sql_agent_job_thresholds') is not null
			begin
				SET @_output += '<br>Dropping table dbo.sql_agent_job_thresholds..'+@_crlf;
				EXEC ('DROP TABLE dbo.sql_agent_job_thresholds');
			end
			IF OBJECT_ID('dbo.sql_agent_job_stats') is not null
			begin
				SET @_output += '<br>Dropping table dbo.sql_agent_job_stats..'+@_crlf;
				EXEC ('DROP TABLE dbo.sql_agent_job_stats');
			end
		END

		IF OBJECT_ID('dbo.sql_agent_job_thresholds') IS NULL
		BEGIN
			SET @_output += '<br>Creating table dbo.sql_agent_job_thresholds..'+@_crlf;

			-- Drop table dbo.sql_agent_job_thresholds
			CREATE TABLE dbo.sql_agent_job_thresholds
			(	JobName varchar(255) NOT NULL,
				JobCategory varchar(255) NOT NULL,
				[Expected-Max-Duration(Min)] BIGINT,
				[Continous_Failure_Threshold] int default 2,
				[Successfull_Execution_ClockTime_Threshold_Minutes] bigint null, /* Job should execute successfully at least within this time */
				[StopJob_If_LongRunning] bit default 0,
				[StopJob_If_NotSuccessful_In_ThresholdTime] bit default 0,
				[RestartJob_If_NotSuccessful_In_ThresholdTime] bit default 0,
				[RestartJob_If_Failed] bit default 0,
				[Kill_Job_Blocker] bit default 0,
				[Alert_When_Blocked] bit default 0,
				[EnableJob_If_Found_Disabled] bit NOT NULL default 0,
				[IgnoreJob] bit not null default 0,
				[IsDisabled] bit default 0 not null,
				[IsNotFound] bit default 0 not null,
				[Include_In_MailNotification] bit default 0,
				[Mail_Recepients] varchar(2000) default null,
				CollectionTimeUTC datetime2 default sysutcdatetime(),
				UpdatedDateUTC datetime2 not null default sysutcdatetime(),
				UpdatedBy varchar(125) not null default suser_name(),
				Remarks varchar(2000) null,

				constraint pk_sql_agent_job_thresholds primary key clustered (JobName)
			);
		END

		IF OBJECT_ID('dbo.sql_agent_job_stats') IS NULL
		BEGIN
			SET @_output += '<br>Creating table dbo.sql_agent_job_stats..'+@_crlf;

			-- DROP TABLE dbo.sql_agent_job_stats
			CREATE TABLE dbo.sql_agent_job_stats
			(	JobName varchar(255) NOT NULL,
				Instance_Id bigint,
				[Last_RunTime] datetime2 null,
				[Last_Run_Duration_Seconds] int null,
				[Last_Run_Outcome] varchar(50) null,
				[Last_Successful_ExecutionTime] datetime2 null,				
				[Running_Since] datetime2,
				[Running_StepName] varchar(250) null,
				[Running_Since_Min] bigint,
				[Session_Id] int null,
				[Blocking_Session_Id] int null,
				[Next_RunTime] datetime2 null,
				[Total_Executions] bigint default 0,
				[Total_Success_Count] bigint default 0,
				[Total_Stopped_Count] bigint default 0,
				[Total_Failed_Count] bigint default 0,
				[Continous_Failures] int default 0,
				--[Starts_In_Min] bigint null,
				[<10-Min] bigint not null default 0,
				[10-Min] bigint not null default 0,
				[30-Min] bigint not null default 0,
				[1-Hrs] bigint not null default 0,
				[2-Hrs] bigint not null default 0,
				[3-Hrs] bigint not null default 0,
				[6-Hrs] bigint not null default 0,
				[9-Hrs] bigint not null default 0,
				[12-Hrs] bigint not null default 0,
				[18-Hrs] bigint not null default 0,
				[24-Hrs] bigint not null default 0,
				[36-Hrs] bigint not null default 0,
				[48-Hrs] bigint not null default 0,
				CollectionTimeUTC datetime2 default sysutcdatetime(),
				UpdatedDateUTC datetime2 not null default sysutcdatetime()

				constraint pk_sql_agent_job_stats primary key clustered (JobName)
			);
		END

		IF ( @reset_stats = 1 )
		BEGIN
			IF @verbose > 0
				PRINT @_tab+'Reset table dbo.sql_agent_job_stats..';

			IF @is_test_alert = 0
			BEGIN
				SET @_output += '<br>Reset table dbo.sql_agent_job_stats..'+@_crlf;
				TRUNCATE TABLE dbo.sql_agent_job_stats;
			END
		END

		-- Populate table dbo.sql_agent_job_thresholds
		IF @verbose > 0
			PRINT @_tab+'Populate new jobs into table dbo.sql_agent_job_thresholds..';
		SET @_output += '<br>'+@_tab+'Populate new jobs into table dbo.sql_agent_job_thresholds..'+@_crlf;
		;WITH JobStats AS (
			SELECT	[JobName] = j.name, 
					[JobCategory] = c.name, 
					[Expected-Max-Duration(Min)] = CASE WHEN h.run_status = 1 -- Only successful executions
														THEN (PERCENTILE_DISC(0.99) 
																WITHIN GROUP (ORDER BY ((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) ) 
																OVER (PARTITION BY j.name))
														ELSE 5
														END,
					[IgnoreJob] = (CASE WHEN EXISTS (select  v.name as jobname, c.name as category from msdb.dbo.sysjobs_view as v left join msdb.dbo.syscategories as c on c.category_id = v.category_id where c.name like 'repl%' AND v.name = j.name) then 1 else 0 end)
					,h.run_status
			FROM	msdb.dbo.sysjobs AS j
			INNER JOIN msdb.dbo.syscategories AS c
				ON c.category_id = j.category_id
			LEFT JOIN
					msdb.dbo.sysjobhistory AS h
				ON	h.job_id = j.job_id			
			WHERE	h.step_id = 0
			AND j.name NOT IN (select t.JobName COLLATE SQL_Latin1_General_CP1_CI_AS from dbo.sql_agent_job_thresholds as t)
			--and j.name = 'SomeJobName'
			--and h.run_status = 1 
		)
		INSERT dbo.sql_agent_job_thresholds
		([JobName], [JobCategory], [Expected-Max-Duration(Min)], [Continous_Failure_Threshold], [Successfull_Execution_ClockTime_Threshold_Minutes], [StopJob_If_LongRunning], [StopJob_If_NotSuccessful_In_ThresholdTime], [RestartJob_If_NotSuccessful_In_ThresholdTime], [RestartJob_If_Failed], [EnableJob_If_Found_Disabled], [IgnoreJob], [IsDisabled], [IsNotFound], [Include_In_MailNotification], [Mail_Recepients], [Remarks])
		SELECT	[JobName], [JobCategory], 
				[Expected-Max-Duration(Min)] = CASE WHEN MAX([Expected-Max-Duration(Min)]) < 5 THEN 5 ELSE MAX([Expected-Max-Duration(Min)]) END,
				[Continous_Failure_Threshold] = -1, 
				[Successfull_Execution_ClockTime_Threshold_Minutes] = -1, 
				[StopJob_If_LongRunning] = 0, 
				[StopJob_If_NotSuccessful_In_ThresholdTime] = 0, 
				[RestartJob_If_NotSuccessful_In_ThresholdTime] = 0, 
				[RestartJob_If_Failed] = 0, 
				[EnableJob_If_Found_Disabled] = 0, 
				[IgnoreJob] = MAX([IgnoreJob]), 
				[IsDisabled] = 0, 
				[IsNotFound] = 0, 
				[Include_In_MailNotification] = 0, 
				[Mail_Recepients] = null,
				[Remarks] = null
		FROM JobStats js
		GROUP BY [JobName], [JobCategory];
    
		-- Update table dbo.sql_agent_job_thresholds
		IF @verbose > 0
			PRINT @_tab+'Detect/Updates changes in Job Category..';
		SET @_output += '<br>'+@_tab+'Detect/Updates changes in Job Category..'+@_crlf;

		UPDATE sajt 
		SET		JobCategory = sc.name, 
				IsDisabled = (case when sjv.enabled = 1 then 0 else 1 end)
		FROM msdb.dbo.sysjobs_view sjv
		JOIN msdb.dbo.syscategories sc
		ON sc.category_id = sjv.category_id
		JOIN dbo.sql_agent_job_thresholds sajt
		ON sajt.JobName = sjv.name COLLATE SQL_Latin1_General_CP1_CI_AS
		WHERE 1=1
		and (	(sc.name <> sajt.JobCategory COLLATE SQL_Latin1_General_CP1_CI_AS)
			or	(sajt.IsDisabled <> (case when sjv.enabled = 1 then 0 else 1 end))
			);

		IF @verbose > 0
			PRINT @_tab+'Remove jobs that don''t exist..';
		SET @_output += '<br>'+@_tab+'Remove jobs that don''t exist..'+@_crlf;

		DELETE sajt
		FROM dbo.sql_agent_job_thresholds sajt
		WHERE 1=1
		AND sajt.IsNotFound = 0
		AND NOT EXISTS (select 1/0 from msdb.dbo.sysjobs_view sjv where sajt.JobName = sjv.name COLLATE SQL_Latin1_General_CP1_CI_AS);

		if @verbose >= 2
		begin
			select [RunningQuery] = 'dbo.sql_agent_job_thresholds', *
			from dbo.sql_agent_job_thresholds
		end

		if @is_test_alert = 1
		begin
			if @verbose > 0
				PRINT @_tab+'Executing select 1/0..';
			SET @_output += '<br>'+@_tab+'Executing select 1/0..'+@_crlf;
			select 1/0;
		end

		-- Populate table dbo.sql_agent_job_stats
		IF @verbose > 0
			PRINT @_tab+'Populate table dbo.sql_agent_job_stats..';
		SET @_output += '<br>'+@_tab+'Populate table dbo.sql_agent_job_stats..'+@_crlf;

		IF @verbose > 0
			PRINT @_tab+@_tab+'Create table #JobPastHistory..';
		SET @_output += '<br>'+@_tab+'Populate table dbo.JobPastHistory..'+@_crlf;
		IF OBJECT_ID('tempdb..#JobPastHistory') IS NOT NULL
			DROP TABLE #JobPastHistory;
		;with jobs_history_all_instances as
		(
			/* Find Job Execution History more recent from Base Table */
			select	[JobName] = j.name, [Instance_Id] = jh.instance_id,
					[RunDateTime], [RunDurationMinutes], [RunDurationSeconds],
					[RunStatus] = case run_status	when 0 then 'Failed'
													when 1 then 'Succeeded'
													when 2 then 'Retry'
													when 3 then 'Canceled'
													when 4 then 'In Progress'
													else 'None'
													end
			from msdb.dbo.sysjobs_view j
			cross apply (
				select	[RunDateTime] = DATETIMEFROMPARTS(
											   LEFT(padded_run_date, 4),         -- year
											   SUBSTRING(padded_run_date, 5, 2), -- month
											   RIGHT(padded_run_date, 2),        -- day
											   LEFT(padded_run_time, 2),         -- hour
											   SUBSTRING(padded_run_time, 3, 2), -- minute
											   RIGHT(padded_run_time, 2),        -- second
											   0),          -- millisecond
						[RunDurationMinutes] = ((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60),
						[RunDurationSeconds] = datediff(second,'1900-01-01', (case when jh.run_duration <= 235959
												then convert(datetime, '1900-01-01 '+STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(jh.run_duration AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':'))
												else convert(varchar,dateadd(day,(CAST(LEFT(CAST(jh.run_duration AS VARCHAR), LEN(CAST(jh.run_duration AS VARCHAR)) - 4) AS INT) / 24),'1900-01-01'),23) + ' ' + 
												+ RIGHT('00' + CAST(CAST(LEFT(CAST(jh.run_duration AS VARCHAR), LEN(CAST(jh.run_duration AS VARCHAR)) - 4) AS INT) % 24 AS VARCHAR), 2) + ':' + STUFF(CAST(RIGHT(CAST(jh.run_duration AS VARCHAR), 4) AS VARCHAR(6)), 3, 0, ':')
													 end)),
						run_date ,run_time, jh.instance_id, jh.run_status
				from msdb.dbo.sysjobhistory jh
				CROSS APPLY ( SELECT RIGHT('000000' + CAST(jh.run_time AS VARCHAR(6)), 6), RIGHT('00000000' + CAST(jh.run_date AS VARCHAR(8)), 8) ) AS shp(padded_run_time, padded_run_date)
				inner join dbo.sql_agent_job_thresholds sajt
					on sajt.JobName = j.name COLLATE SQL_Latin1_General_CP1_CI_AS
					and sajt.IgnoreJob = 0
				left join dbo.sql_agent_job_stats as sajs
					on sajs.JobName = sajt.JobName
					and jh.instance_id > (case when sajs.Instance_Id is null then 0 else sajs.Instance_Id end)
				where jh.job_id = j.job_id and jh.step_id = 0
				and jh.run_status in (0,1,3) /* Failed, Success, Canceled */
			) jh
			--where j.name = 'Divide-By-Zero'
		)
		,jobs_history_all_instances_timeframed as (
			select	[JobName], [Instance_Id], [RunDateTime], [RunDurationMinutes], [RunDurationSeconds], [RunStatus],
					[TimeRange] = case	when [RunDurationMinutes]/60 >= 48 then '48-Hrs'
										when [RunDurationMinutes]/60 >= 36 then '36-Hrs'
										when [RunDurationMinutes]/60 >= 24 then '24-Hrs'
										when [RunDurationMinutes]/60 >= 18 then '18-Hrs'
										when [RunDurationMinutes]/60 >= 12 then '12-Hrs'
										when [RunDurationMinutes]/60 >= 9 then '9-Hrs'
										when [RunDurationMinutes]/60 >= 6 then '6-Hrs'
										when [RunDurationMinutes]/60 >= 3 then '3-Hrs'
										when [RunDurationMinutes]/60 >= 2 then '2-Hrs'
										when [RunDurationMinutes]/60 >= 1 then '1-Hrs'
										when [RunDurationMinutes] >= 30 then '30-Min'
										when [RunDurationMinutes] >= 10 then '10-Min'
										else '<10-Min'
									end
		
			from	jobs_history_all_instances
		)
		,jobs_history as (
			select	JobName, [Instance_Id] = max([Instance_Id]), [RunStatus] = NULL, 
					[Last_RunTime] = max([RunDateTime]),
					--[Last_Run_Duration_Seconds] = NULL,
					[Total_Executions] = COUNT(*),
					[Total_Success_Count] = SUM((CASE WHEN [RunStatus] = 'Succeeded' THEN 1 ELSE 0 END)),
					[Total_Stopped_Count] = SUM((CASE WHEN [RunStatus] = 'Canceled' THEN 1 ELSE 0 END)),
					[Total_Failed_Count] = SUM((CASE WHEN [RunStatus] = 'Failed' THEN 1 ELSE 0 END)),
					[Continous_Failures] = null,
					[Last_Successful_ExecutionTime] = MAX((CASE WHEN [RunStatus] = 'Succeeded' THEN [RunDateTime] ELSE NULL END)),
					[<10-Min] = sum(case [TimeRange] when '<10-Min' then 1 else 0 end),
					[10-Min] = sum(case [TimeRange] when '10-Min' then 1 else 0 end),
					[30-Min] = sum(case [TimeRange] when '30-Min' then 1 else 0 end),
					[1-Hrs] = sum(case [TimeRange] when '1-Hrs' then 1 else 0 end),
					[2-Hrs] = sum(case [TimeRange] when '2-Hrs' then 1 else 0 end),
					[3-Hrs] = sum(case [TimeRange] when '3-Hrs' then 1 else 0 end),
					[6-Hrs] = sum(case [TimeRange] when '6-Hrs' then 1 else 0 end),
					[9-Hrs] = sum(case [TimeRange] when '9-Hrs' then 1 else 0 end),
					[12-Hrs] = sum(case [TimeRange] when '12-Hrs' then 1 else 0 end),
					[18-Hrs] = sum(case [TimeRange] when '18-Hrs' then 1 else 0 end),
					[24-Hrs] = sum(case [TimeRange] when '24-Hrs' then 1 else 0 end),
					[36-Hrs] = sum(case [TimeRange] when '36-Hrs' then 1 else 0 end),
					[48-Hrs] = sum(case [TimeRange] when '48-Hrs' then 1 else 0 end)
		
			from jobs_history_all_instances_timeframed jh
			group by jh.JobName
		)
		select	js.JobName, js.[Instance_Id], rs.RunStatus, [Last_RunTime], 
				[Last_Run_Duration_Seconds] = rs.RunDurationSeconds,
				js.Total_Executions, js.Total_Success_Count, js.Total_Stopped_Count,
				js.Total_Failed_Count, js.Continous_Failures, js.Last_Successful_ExecutionTime, [<10-Min], [10-Min], [30-Min], 
				[1-Hrs], [2-Hrs], [3-Hrs], [6-Hrs], [9-Hrs], [12-Hrs], [18-Hrs], [24-Hrs], [36-Hrs], [48-Hrs]
		into	#JobPastHistory
		from jobs_history js
		outer apply ( select i.RunStatus, i.RunDurationSeconds from jobs_history_all_instances_timeframed i 
						where i.JobName = js.JobName and i.Instance_Id = js.Instance_Id
					) as rs;

		if @verbose >= 2
		begin
			select [RunningQuery] = '#JobPastHistory', *
			from #JobPastHistory
		end

		IF @verbose > 0
			PRINT @_tab+@_tab+'Populate table #AgentJobs using master..xp_sqlagent_enum_jobs..';
		SET @_output += '<br>'+@_tab+@_tab+'Populate table #AgentJobs using master..xp_sqlagent_enum_jobs..'+@_crlf;
		if OBJECT_ID('tempdb.dbo.#AgentJobs') is not null
			drop table #AgentJobs
		create table #AgentJobs
		(	Job_ID uniqueidentifier, 
			Last_Run_Date int, 
			Last_Run_Time int, 
			Next_Run_Date int, 
			Next_Run_Time int, 
			Next_Run_Schedule_ID int, 
			Requested_To_Run int, 
			Request_Source int, 
			Request_Source_ID varchar(100), 
			Running int, 
			Current_Step int, 
			Current_Retry_Attempt int, 
			[State] int
		);
		insert into #AgentJobs
		exec master.dbo.xp_sqlagent_enum_jobs 1, garbage;

		if @verbose >= 2
		begin
			select	[RunningQuery] = '#AgentJobs join sysjobs_view', aj.*, v.name, 
					[CurrentTime] = getdate(),
					[LastRunTime] = case	when aj.Last_Run_Date = 0 then NULL
										else CONVERT(varchar, DATEADD(S, (aj.Last_Run_Time / 10000) * 60 * 60 /* hours */
												+ ((aj.Last_Run_Time - (aj.Last_Run_Time / 10000) * 10000) / 100) * 60 /* mins */
												+ (aj.Last_Run_Time - (aj.Last_Run_Time / 100) * 100) /* secs */, CONVERT(datetime, RTRIM(aj.Last_Run_Date), 112)), 120)
										end,
					[NextRunTime] = case	when Next_Run_Date = 0 then NULL
										else CONVERT(varchar, DATEADD(S, (Next_Run_Time / 10000) * 60 * 60 /* hours */
												+ ((Next_Run_Time - (Next_Run_Time / 10000) * 10000) / 100) * 60 /* mins */
												+ (Next_Run_Time - (Next_Run_Time / 100) * 100) /* secs */, CONVERT(datetime, RTRIM(Next_Run_Date), 112)), 120)
										end
			from #AgentJobs aj
			join msdb..sysjobs_view v
				on v.job_id = aj.Job_ID
			where Running = 1
		end

		IF @verbose > 0
			PRINT @_tab+@_tab+'Create table #JobActivityMonitor..';
		SET @_output += '<br>'+@_tab+@_tab+'Create table #JobActivityMonitor..'+@_crlf;

		if object_id('tempdb..#JobActivityMonitor') is not null
			drop table #JobActivityMonitor;
		select	[JobName] = sj.name,
				[Enabled] = sj.enabled,
				rj.[Running],
				[Current_Step] = js.step_name + ' ( Step '+convert(varchar,rj.Current_Step)+')',
				[Session_Id] = blk.session_id,
				[Blocking_Session_Id] = blk.blocking_session_id,
				[State] = case [State]	when 1 then 'Executing'
										when 2 then 'Waiting for thread'
										when 3 then 'Between retries'
										when 4 then 'Idle'
										when 5 then 'Suspended'
										when 6 then 'Obsolete'
										when 7 then 'Performing completion actions'
										else 'Unknown'
										end,
				[StartTime] = case	when Next_Run_Date = 0 or Running = 0 then NULL
									else CONVERT(varchar, DATEADD(S, (Next_Run_Time / 10000) * 60 * 60 /* hours */
											+ ((Next_Run_Time - (Next_Run_Time / 10000) * 10000) / 100) * 60 /* mins */
											+ (Next_Run_Time - (Next_Run_Time / 100) * 100) /* secs */, CONVERT(datetime, RTRIM(Next_Run_Date), 112)), 120)
									end,
				[LastRunTime] = case	when rj.Last_Run_Date = 0 then NULL
									else CONVERT(varchar, DATEADD(S, (rj.Last_Run_Time / 10000) * 60 * 60 /* hours */
											+ ((rj.Last_Run_Time - (rj.Last_Run_Time / 10000) * 10000) / 100) * 60 /* mins */
											+ (rj.Last_Run_Time - (rj.Last_Run_Time / 100) * 100) /* secs */, CONVERT(datetime, RTRIM(rj.Last_Run_Date), 112)), 120)
									end,
				[NextRunTime] = case	when Next_Run_Date = 0 then NULL
									else CONVERT(varchar, DATEADD(S, (Next_Run_Time / 10000) * 60 * 60 /* hours */
											+ ((Next_Run_Time - (Next_Run_Time / 10000) * 10000) / 100) * 60 /* mins */
											+ (Next_Run_Time - (Next_Run_Time / 100) * 100) /* secs */, CONVERT(datetime, RTRIM(Next_Run_Date), 112)), 120)
									end
		into #JobActivityMonitor
		from #AgentJobs as rj
		join msdb.dbo.sysjobs sj on rj.Job_ID = sj.job_id
		left join msdb.dbo.sysjobsteps js on js.job_id = sj.job_id and js.step_id = rj.Current_Step
		outer apply (
					select top 1 der.blocking_session_id, des.session_id
					from sys.dm_exec_sessions des 
					left join sys.dm_exec_requests der 
						on der.session_id = des.session_id
						and der.blocking_session_id > 0
					where des.program_name like 'SQLAgent - TSQL JobStep %'
					and right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring(des.program_name,30,34),10) 
				) blk
		--where rj.[Running] = 1
		order by name;

		if @verbose >= 2
		begin
			select [RunningQuery] = '#JobActivityMonitor', *
			from #JobActivityMonitor
		end

		IF @verbose > 0
			PRINT @_tab+@_tab+'Create table #JobActivityMonitorConsolidated..';
		SET @_output += '<br>'+@_tab+@_tab+'Create table #JobActivityMonitorConsolidated..'+@_crlf;

		if object_id('tempdb..#JobActivityMonitorConsolidated') is not null
			drop table #JobActivityMonitorConsolidated;
		SELECT	[JobName] = coalesce(jh.[JobName],am.[JobName]), [Instance_Id], 
				[Last_RunTime] = case when am.LastRunTime > jh.Last_RunTime then am.LastRunTime else jh.Last_RunTime end,
				[Last_Run_Duration_Seconds] = jh.[Last_Run_Duration_Seconds],
				RunStatus, [Total_Executions], [Total_Success_Count], [Total_Stopped_Count], [Total_Failed_Count], 
				[Continous_Failures], [Last_Successful_ExecutionTime], 
				[Running_Since] = case when am.Running = 1 then am.StartTime else null end, 
				[Running_StepName] = am.Current_Step, 
				[Running_Since_Min] = datediff(minute,am.StartTime,GETDATE()),
				[Session_Id] = am.Session_Id,
				[Blocking_Session_Id] = am.Blocking_Session_Id,
				[Next_RunTime] = am.NextRunTime, 
				[<10-Min], [10-Min], [30-Min], [1-Hrs], [2-Hrs], [3-Hrs], 
				[6-Hrs], [9-Hrs], [12-Hrs], [18-Hrs], [24-Hrs], [36-Hrs], [48-Hrs], [UpdatedDate] = sysutcdatetime()
				,am.Enabled
		into #JobActivityMonitorConsolidated
		FROM #JobPastHistory jh
		full outer join #JobActivityMonitor am
			on am.JobName = jh.JobName;

		if @verbose >= 2
		begin
			select [RunningQuery] = '#JobActivityMonitorConsolidated', *
			from #JobActivityMonitorConsolidated
		end

		IF @verbose > 0
			PRINT @_tab+@_tab+'Create table #sql_agent_job_stats..';
		SET @_output += '<br>'+@_tab+@_tab+'Create table #sql_agent_job_stats..'+@_crlf;

		if object_id('tempdb..#sql_agent_job_stats') is not null
			drop table #sql_agent_job_stats;
		select	JobName = coalesce(js.JobName, jam.JobName) COLLATE SQL_Latin1_General_CP1_CI_AS,
				Instance_Id = case when isnull(jam.Instance_Id,0) > isnull(js.Instance_Id,0) then jam.Instance_Id else js.Instance_Id end,
				[Last_RunTime] = case when isnull(jam.Last_RunTime,'1970-01-01') > isnull(js.Last_RunTime,'1970-01-01') then jam.Last_RunTime else js.Last_RunTime end,
				[Last_Run_Duration_Seconds] = jam.[Last_Run_Duration_Seconds],
				[Last_Run_Outcome] = case when jam.RunStatus is not null then jam.RunStatus else js.Last_Run_Outcome end COLLATE SQL_Latin1_General_CP1_CI_AS,
				[Last_Successful_ExecutionTime] = case when jam.[Last_Successful_ExecutionTime] is not null 
														then jam.[Last_Successful_ExecutionTime] 
														else js.[Last_Successful_ExecutionTime] 
													end,
				[Running_Since] = jam.[Running_Since],
				[Running_StepName] = jam.[Running_StepName],
				[Running_Since_Min] = jam.[Running_Since_Min],
				[Session_Id] = jam.Session_Id,
				[Blocking_Session_Id] = jam.Blocking_Session_Id,
				[Next_RunTime] = jam.[Next_RunTime],
				[Total_Executions] = isnull(js.Total_Executions,0) + isnull(jam.Total_Executions,0),
				[Total_Success_Count] = isnull(js.Total_Success_Count,0) + isnull(jam.Total_Success_Count,0),
				[Total_Stopped_Count] = isnull(js.[Total_Stopped_Count],0) + isnull(jam.[Total_Stopped_Count],0),
				[Total_Failed_Count] = isnull(js.[Total_Failed_Count],0) + isnull(jam.[Total_Failed_Count],0),
				[Continous_Failures] = isnull(js.[Continous_Failures],0) + isnull(jam.[Continous_Failures],0),
				[<10-Min] = isnull(js.[<10-Min],0) + isnull(jam.[<10-Min],0),
				[10-Min] = isnull(js.[10-Min],0) + isnull(jam.[10-Min],0),
				[30-Min] = isnull(js.[30-Min],0) + isnull(jam.[30-Min],0),
				[1-Hrs] = isnull(js.[1-Hrs],0) + isnull(jam.[1-Hrs],0),
				[2-Hrs] = isnull(js.[2-Hrs],0) + isnull(jam.[2-Hrs],0),
				[3-Hrs] = isnull(js.[3-Hrs],0) + isnull(jam.[3-Hrs],0),
				[6-Hrs] = isnull(js.[6-Hrs],0) + isnull(jam.[6-Hrs],0),
				[9-Hrs] = isnull(js.[9-Hrs],0) + isnull(jam.[9-Hrs],0),
				[12-Hrs] = isnull(js.[12-Hrs],0) + isnull(jam.[12-Hrs],0),
				[18-Hrs] = isnull(js.[18-Hrs],0) + isnull(jam.[18-Hrs],0),
				[24-Hrs] = isnull(js.[24-Hrs],0) + isnull(jam.[24-Hrs],0),
				[36-Hrs] = isnull(js.[36-Hrs],0) + isnull(jam.[36-Hrs],0),
				[48-Hrs] = isnull(js.[48-Hrs],0) + isnull(jam.[48-Hrs],0),
				[CollectionTimeUTC] = coalesce(js.[CollectionTimeUTC],sysutcdatetime()),				
				[UpdatedDateUTC] = SYSUTCDATETIME()
		into #sql_agent_job_stats				
		from #JobActivityMonitorConsolidated jam
		full outer join dbo.sql_agent_job_stats js
			on js.JobName = jam.JobName COLLATE SQL_Latin1_General_CP1_CI_AS
		where 1=1
		and (	jam.Enabled = 1
			or	@consider_disabled_jobs = 1
			);

		if @verbose >= 2
		begin
			select [RunningQuery] = '#sql_agent_job_stats', *
			from #sql_agent_job_stats
		end

		BEGIN TRAN
			IF @verbose > 0
				PRINT @_tab+@_tab+'Truncate & Repopulate table dbo.sql_agent_job_stats..';
			SET @_output += '<br>'+@_tab+@_tab+'Truncate & Repopulate table dbo.sql_agent_job_stats..'+@_crlf;			

			truncate table dbo.sql_agent_job_stats;

			INSERT dbo.sql_agent_job_stats
			(	[JobName], [Instance_Id], [Last_RunTime], [Last_Run_Duration_Seconds], [Last_Run_Outcome], 
				[Last_Successful_ExecutionTime], [Running_Since], [Running_StepName], [Running_Since_Min], [Session_Id], 
				[Blocking_Session_Id], [Next_RunTime], [Total_Executions], [Total_Success_Count], [Total_Stopped_Count], 
				[Total_Failed_Count], [Continous_Failures], [<10-Min], [10-Min], [30-Min], [1-Hrs], [2-Hrs], [3-Hrs], 
				[6-Hrs], [9-Hrs], [12-Hrs], [18-Hrs], [24-Hrs], [36-Hrs], [48-Hrs], [CollectionTimeUTC], [UpdatedDateUTC]
			)
			SELECT	[JobName], [Instance_Id], [Last_RunTime], [Last_Run_Duration_Seconds], [Last_Run_Outcome], 
				[Last_Successful_ExecutionTime], [Running_Since], [Running_StepName], [Running_Since_Min], [Session_Id], 
				[Blocking_Session_Id], [Next_RunTime], [Total_Executions], [Total_Success_Count], [Total_Stopped_Count], 
				[Total_Failed_Count], [Continous_Failures], [<10-Min], [10-Min], [30-Min], [1-Hrs], [2-Hrs], [3-Hrs], 
				[6-Hrs], [9-Hrs], [12-Hrs], [18-Hrs], [24-Hrs], [36-Hrs], [48-Hrs], [CollectionTimeUTC], [UpdatedDateUTC]
			FROM #sql_agent_job_stats;			
		COMMIT TRAN	

		SET @_output += '<br>FINISH. Script executed without error.'+CHAR(10);
		IF @verbose > 0
		BEGIN
			PRINT 'End Try Block..';
			PRINT '***************************************************************'
		END

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();

    declare @_product_version tinyint;
	  select @_product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT @_tab+'Inside Catch Block. Get recent '+cast(@default_threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @_product_version IS NOT NULL
		BEGIN
			SET @_sqlString = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sqlString = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;

			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure
			' + char(10);
		END
		IF @verbose > 1
			PRINT @_tab+@_sqlString;
		INSERT #CommandLog
		EXEC sp_executesql @_sqlString, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @default_threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT @_tab+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT @_tab+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
		BEGIN
			PRINT 'End Catch Block.'
			PRINT '***************************************************************'
		END
	END CATCH	

	

	IF @send_error_mail = 1 /* If failure alert has to be send */
	BEGIN
		/*	Check if Any Error, then based on Continous Threshold & Delay, send mail
			Check if No Error, then clear the alert if active,
		*/
		IF @verbose > 0
			PRINT @_crlf + 'Start Notification Validation Block..';

		IF @verbose > 0
			PRINT @_tab + 'Get Last @last_sent_failed &  @last_sent_cleared..';
		SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
		SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

		IF @verbose > 0
		BEGIN
			PRINT @_tab + '@_last_sent_failed_active => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_active,121),'');
			PRINT @_tab + '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
		END

		-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
		IF		(@send_error_mail = 1) 
			AND (@_continous_failures >= @default_threshold_continous_failure) 
			AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @default_notification_delay_minutes) )
		BEGIN
			IF @verbose > 0
				PRINT @_tab + 'Setting Mail variable values for Job FAILED ACTIVE notification..'
			SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
			SET @_mail_body_html =
					N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
					N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
					N'<br>Line Number: ' + convert(varchar, @_errorLine) +
					N'<br>Error Message: <br>"' + @_errorMessage +
					N'<br><br>Kindly resolve the job failure based on above error message.'+
					N'<br><br>Below is Job Output till now -><br><br>'+@_output+
					N'<br><br>Regards,'+
					N'<br>Job ['+@_job_name+']' +
					N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@default_threshold_continous_failure) +
					N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@default_notification_delay_minutes)
			SET @_send_mail = 1;
		END
		ELSE
			PRINT @_crlf+@_tab + 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+@_tab+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

		-- Check if No error, then clear active alert if any.
		IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
		BEGIN
			IF @verbose > 0
				PRINT @_tab + 'Setting Mail variable values for Job FAILED CLEARED notification..'
			SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
			SET @_mail_body_html =
					N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
					N'<br><br>Regards,'+
					N'<br>Job ['+@_job_name+']' +
					N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@default_threshold_continous_failure) +
					N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@default_notification_delay_minutes)
			SET @_send_mail = 1;
		END
		ELSE
			PRINT @_crlf+@_tab + 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+@_tab+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

		IF @is_test_alert = 1
			SET @_subject = 'TestAlert - '+@_subject;

		IF @_send_mail = 1
		BEGIN
			SELECT @_profile_name = p.name
			FROM msdb.dbo.sysmail_profile p 
			JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
			JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
			JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
			JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

			EXEC msdb.dbo.sp_send_dbmail
					@recipients = @default_mail_recipient,
					@profile_name = @_profile_name,
					@subject = @_subject,
					@body = @_mail_body_html,
					@body_format = 'HTML';
		END

		IF @verbose > 0
		BEGIN
			PRINT @_crlf + 'End Notification Validation Block..';
			PRINT '***************************************************************'
		END
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
		raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_ag_health_state
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_ag_health_state
(	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Collect-AgHealthState', /* Subject of Failure Mail */
	@send_error_mail bit = 1 /* Send mail on failure */
)
AS 
BEGIN

	/*
		Version:		1.0.0
		Date:			2023-09-07

		EXEC dbo.usp_collect_ag_health_state @recipients = 'some_dba_mail_id@gmail.com'

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;

	SET @_job_name = '(dba) '+@alert_key;

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';

		set @_sql = '
if object_id(''tempdb..#availability_databases'') is not null
	drop table #availability_databases;

select	ar.replica_server_name,
		drs.is_primary_replica,
		adc.database_name,
		ag.name AS ag_name,
		drs.is_local,
		ag.is_distributed,
		drs.synchronization_state_desc,
		drs.synchronization_health_desc,
		last_redone_time = drs.last_redone_time,
		drs.log_send_queue_size,
		drs.log_send_rate,
		drs.redo_queue_size,
		drs.redo_rate,
		[estimated_redo_completion_time_min] = case when drs.redo_rate <> 0 then (drs.redo_queue_size / drs.redo_rate) / 60.0 else (drs.redo_queue_size / 1) / 60.0 end,
		last_commit_time = drs.last_commit_time,
		drs.is_suspended,
		drs.suspend_reason_desc,
		ag.group_id
into #availability_databases
from sys.dm_hadr_database_replica_states as drs
inner join sys.availability_databases_cluster as adc on drs.group_id = adc.group_id
	and drs.group_database_id = adc.group_database_id
inner join sys.availability_groups as ag on ag.group_id = drs.group_id
inner join sys.availability_replicas as ar on drs.group_id = ar.group_id
	and drs.replica_id = ar.replica_id;

select	[collection_time_utc] = SYSUTCDATETIME(),
		replica_server_name,
		is_primary_replica,
		database_name,
		ag_name,
		[ag_listener] = agl.dns_name+'' (''+ia.ip_address+'')'',
		is_local,
		ag.is_distributed,
		synchronization_state_desc,
		synchronization_health_desc,
		latency_seconds = case when is_primary_replica = 1 then 0
								else (	select DATEDIFF(second,ag.last_commit_time,p.last_commit_time) 
										from #availability_databases p 
										where p.is_primary_replica = 1 and p.database_name = ag.database_name
									)
								end,
		redo_queue_size,
		log_send_queue_size,
		last_redone_time,
		log_send_rate,		
		redo_rate,
		estimated_redo_completion_time_min,
		last_commit_time,
		is_suspended,
		suspend_reason_desc
from #availability_databases as ag
left join sys.availability_group_listeners agl on agl.group_id = ag.group_id
left join sys.availability_group_listener_ip_addresses ia on ia.listener_id = agl.listener_id and ia.state_desc = ''ONLINE''
order by ag.ag_name, ag.replica_server_name, ag.database_name;';
		
		if @verbose >= 1
			print @_sql;

		if CONVERT(tinyint,SERVERPROPERTY('IsHadrEnabled')) = 1
		begin
			IF @verbose > 0
				print 'Populate table dbo.ag_health_state..';
			INSERT INTO dbo.ag_health_state 
			(collection_time_utc, replica_server_name, is_primary_replica, [database_name], ag_name, ag_listener, is_local, is_distributed, synchronization_state_desc, synchronization_health_desc, latency_seconds, redo_queue_size, log_send_queue_size, last_redone_time, log_send_rate, redo_rate, estimated_redo_completion_time_min, last_commit_time, is_suspended, suspend_reason_desc )
			exec sp_executesql @_sql;
		end
		else
			print 'HADR is not enabled on server.'

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_sql;
		INSERT #CommandLog
		EXEC sp_executesql @_sql, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_file_io_stats
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_file_io_stats
(	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Collect-FileIOStats', /* Subject of Failure Mail */
	@send_error_mail bit = 1 /* Send mail on failure */
)
AS 
BEGIN

	/*
		Version:		1.1.2
		Date:			2022-10-20

		EXEC dbo.usp_collect_file_io_stats @recipients = 'dba_team@gmail.com'
		EXEC dbo.usp_collect_file_io_stats @verbose = 1

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_s NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;
	DECLARE @_rows_affected bigint = 0;
	DECLARE @_server_major_version INT;

	SET @_job_name = '(dba) '+@alert_key;
	SET @_server_major_version = CONVERT(INT,SERVERPROPERTY ('ProductMajorVersion'));

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';
		if @verbose > 0
			print 'Populate IO Latency Stats..'
		
		IF @_server_major_version >= 12
			set @_s = '
		select  [collection_time_utc] = sysutcdatetime(), 
				d.name as [database_name], d.database_id, mf.name as file_logical_name, mf.file_id, mf.physical_name as file_location,
				vfs.sample_ms, vfs.num_of_reads, vfs.num_of_bytes_read, vfs.io_stall_read_ms, vfs.io_stall_queued_read_ms,
				vfs.num_of_writes, vfs.num_of_bytes_written, vfs.io_stall_write_ms, vfs.io_stall_queued_write_ms, 
				vfs.io_stall, vfs.size_on_disk_bytes, 
				ps.io_count, ps.io_pending_ms_ticks_total, ps.io_pending_ms_ticks_avg, ps.io_pending_ms_ticks_max, ps.io_pending_ms_ticks_min
		from sys.dm_io_virtual_file_stats(null,null) vfs
		join sys.master_files mf on mf.database_id = vfs.database_id and mf.file_id = vfs.file_id
		join sys.databases d on d.database_id = mf.database_id
		left join (	select	r.io_handle, 
							io_pending_ms_ticks_min = MIN(io_pending_ms_ticks),
							io_pending_ms_ticks_max = MAX(io_pending_ms_ticks),
							io_pending_ms_ticks_avg = AVG(io_pending_ms_ticks),
							io_pending_ms_ticks_total = SUM(io_pending_ms_ticks),
							io_count = COUNT_BIG(*)
					from sys.dm_io_pending_io_requests as r 
					where r.io_type = ''disk''
					group by r.io_handle
				) ps
			on ps.io_handle = vfs.file_handle;';
		ELSE
			set @_s = '
		select  [collection_time_utc] = sysutcdatetime(), 
				d.name as [database_name], d.database_id, mf.name as file_logical_name, mf.file_id, mf.physical_name as file_location,
				vfs.sample_ms, vfs.num_of_reads, vfs.num_of_bytes_read, vfs.io_stall_read_ms, 
				io_stall_queued_read_ms = 0,
				vfs.num_of_writes, vfs.num_of_bytes_written, vfs.io_stall_write_ms, 
				io_stall_queued_write_ms = 0, 
				vfs.io_stall, vfs.size_on_disk_bytes, 
				ps.io_count, ps.io_pending_ms_ticks_total, ps.io_pending_ms_ticks_avg, ps.io_pending_ms_ticks_max, ps.io_pending_ms_ticks_min
		from sys.dm_io_virtual_file_stats(null,null) vfs
		join sys.master_files mf on mf.database_id = vfs.database_id and mf.file_id = vfs.file_id
		join sys.databases d on d.database_id = mf.database_id
		left join (	select	r.io_handle, 
							io_pending_ms_ticks_min = MIN(io_pending_ms_ticks),
							io_pending_ms_ticks_max = MAX(io_pending_ms_ticks),
							io_pending_ms_ticks_avg = AVG(io_pending_ms_ticks),
							io_pending_ms_ticks_total = SUM(io_pending_ms_ticks),
							io_count = COUNT_BIG(*)
					from sys.dm_io_pending_io_requests as r 
					where r.io_type = ''disk''
					group by r.io_handle
				) ps
			on ps.io_handle = vfs.file_handle;';

		insert [dbo].[file_io_stats]
		(	[collection_time_utc], [database_name], [database_id], [file_logical_name], [file_id], [file_location], [sample_ms], 
			[num_of_reads], [num_of_bytes_read], [io_stall_read_ms], [io_stall_queued_read_ms], [num_of_writes], [num_of_bytes_written], 
			[io_stall_write_ms], [io_stall_queued_write_ms], [io_stall], [size_on_disk_bytes], [io_pending_count], [io_pending_ms_ticks_total], 
			[io_pending_ms_ticks_avg], [io_pending_ms_ticks_max], [io_pending_ms_ticks_min]
		)
		exec (@_s);

		set @_rows_affected = @@ROWCOUNT;

		print 'Rows affected = '+convert(varchar,@_rows_affected);

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_s = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_s = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_s;
		INSERT #CommandLog
		EXEC sp_executesql @_s, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_memory_clerks
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_memory_clerks
(	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Collect-MemoryClerks', /* Subject of Failure Mail */
	@send_error_mail bit = 1 /* Send mail on failure */
)
AS 
BEGIN

	/*
		Version:		1.0.0
		Date:			2023-02-09

		EXEC dbo.usp_collect_memory_clerks @recipients = 'dba_team@gmail.com'

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;

	SET @_job_name = '(dba) '+@alert_key;

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';	
		INSERT INTO dbo.memory_clerks 
			(collection_time_utc, memory_clerk, [name], size_mb)
		SELECT	[collection_time_utc] = SYSUTCDATETIME(),
				[memory_clerk] = [type],
				[name] = MAX(name),
				[size_mb] = SUM(pages_kb) / 1024
		FROM sys.dm_os_memory_clerks WITH (NOLOCK)
		GROUP BY [type]
		HAVING (SUM(pages_kb) / 1024) > 0
		ORDER BY SUM(pages_kb) DESC

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_sql;
		INSERT #CommandLog
		EXEC sp_executesql @_sql, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_privileged_info
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_privileged_info
(	@result_to_table nvarchar(125), /* table that need to be populated */
	@verbose tinyint = 0, /* display debugging messages. 0 = No messages. 1 = Only print messages. 2 = Print & Table Results */
	@truncate_table bit = 1, /* when enabled, table would be truncated */
	@has_staging_table bit = 1 /* when enabled, assume there is no staging table */
)
AS
BEGIN

	/*
		Version:		0.0.0
		Purpose:		Fetch information that need Sysadmin access in general & Save in some table.
		Modifications:	2023-08-30 - Initial Draft

		exec dbo.usp_collect_privileged_info
					@result_to_table = 'dbo.server_privileged_info',
					@truncate_table = 1,
					@has_staging_table = 0,
					@verbose = 2;
		https://stackoverflow.com/questions/10191193/how-to-test-linkedservers-connectivity-in-tsql
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	IF @result_to_table NOT IN ('dbo.server_privileged_info')
		THROW 50001, '''result_to_table'' Parameter value is invalid.', 1;		

	DECLARE @_sql NVARCHAR(max);
	DECLARE @_params NVARCHAR(max);
	DECLARE @_crlf NCHAR(2);
	DECLARE @_str_variable nvarchar(500);
	DECLARE @_int_variable int = 0;

	DECLARE @_srv_name	nvarchar (125);
	DECLARE @_at_server_name varchar (125);
	DECLARE @_staging_table nvarchar(125);

	SET @_staging_table = @result_to_table + (case when @has_staging_table = 1 then '__staging' else '' end);
	SET @_crlf = NCHAR(10)+NCHAR(13);

	IF @truncate_table = 1
	BEGIN
		SET @_sql = 'truncate table '+@_staging_table+';';
		IF @verbose >= 1
			PRINT @_sql;
		EXEC (@_sql);
	END

	-- dbo.server_privileged_info
	if @result_to_table = 'dbo.server_privileged_info'
	begin -- dbo.server_privileged_info
		set @_sql =  "
SET QUOTED_IDENTIFIER ON;
declare @host_distribution nvarchar(500);
declare @processor_name nvarchar(500);
declare @fqdn nvarchar(100);

exec usp_extended_results @host_distribution = @host_distribution output;
exec usp_extended_results @processor_name = @processor_name output;
exec usp_extended_results @fqdn = @fqdn output;

select	[host_name] = CONVERT(varchar,SERVERPROPERTY('ComputerNamePhysicalNetBIOS')),
		[host_distribution] = @host_distribution,
		[processor_name] = @processor_name,
		[fqdn] = (case when default_domain() = 'WORKGROUP' then 'WORKGROUP' ELSE @fqdn END);
"
		-- Decorate for remote query if LinkedServer
		if @verbose >= 1
			print @_crlf+@_sql+@_crlf;
		
		begin try
			insert into [dbo].[server_privileged_info]
			(	[host_name], [host_distribution], [processor_name], [fqdn] )
			exec (@_sql);
		end try
		begin catch
			-- print @_sql;
			print char(10)+char(13)+'Error occurred while executing below query on '+quotename(@_srv_name)+char(10)+'     '+@_sql;
			print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
			print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
			print  '	ErrorState => '+convert(varchar,ERROR_STATE());
			--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
			print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
			print  '	ErrorMessage => '+ERROR_MESSAGE();
		end catch
	end -- dbo.server_privileged_info

	IF @has_staging_table = 1
	BEGIN
		SET @_sql =
		'BEGIN TRAN
			TRUNCATE TABLE '+@result_to_table+';
			ALTER TABLE '+@result_to_table+'__staging SWITCH TO '+@result_to_table+';
		COMMIT TRAN';
		IF @verbose >= 1
			print @_crlf+@_sql+@_crlf;
		EXEC (@_sql);
	END

	PRINT 'Transaction Counts => '+convert(varchar,@@trancount);
END
set quoted_identifier on;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_wait_stats
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_wait_stats
(	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Collect-WaitStats', /* Subject of Failure Mail */
	@send_error_mail bit = 1 /* Send mail on failure */
)
AS 
BEGIN

	/*
		Version:		1.0.0
		Date:			2022-10-13

		EXEC dbo.usp_collect_wait_stats @recipients = 'dba_team@gmail.com'

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;

	SET @_job_name = '(dba) '+@alert_key;

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';	
		INSERT [dbo].[wait_stats]
		([collection_time_utc], [wait_type], [waiting_tasks_count], [wait_time_ms], [max_wait_time_ms], [signal_wait_time_ms])
		SELECT [collection_time_utc] = sysutcdatetime(), [wait_type], [waiting_tasks_count], [wait_time_ms], [max_wait_time_ms], [signal_wait_time_ms]
		FROM sys.dm_os_wait_stats
		WHERE [waiting_tasks_count] > 0;

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_sql;
		INSERT #CommandLog
		EXEC sp_executesql @_sql, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_xevent_metrics
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_xevent_metrics
AS 
BEGIN
	/*
		Version:		1.1.5
		Date:			2022-11-11

		EXEC dbo.usp_collect_xevent_metrics

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds
	
	declare @xe_directory nvarchar(2000);
	declare @xe_file nvarchar(255);
	declare @context varbinary(2000);
	declare @current_time datetime2 = sysutcdatetime();

	if OBJECT_ID('tempdb..#xe_files') is not null
		drop table #xe_files;
	create table #xe_files (directory nvarchar(2000), subdirectory nvarchar(255), depth tinyint, is_file bit);

	-- Get XEvent files directory
	;with targets_xml as (
		select	target_data_xml = CONVERT(XML, target_data)
		from sys.dm_xe_sessions xs
		join sys.dm_xe_session_targets xt on xt.event_session_address = xs.address
		where xs.name = 'xevent_metrics'
		and xt.target_name = 'event_file'
	)
	,targets_current as (
		select file_path = t.target_data_xml.value('(/EventFileTarget/File/@name)[1]','varchar(2000)')
		from targets_xml t
	)
	select @xe_directory = (case when CHARINDEX('\',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('\',reverse(t.file_path))+1)
							 when CHARINDEX('/',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('/',reverse(t.file_path))+1)
							 end)
			,@xe_file = t.file_path
	from targets_current t;

	--select [@xe_directory] = @xe_directory, [@xe_file] = @xe_file;

	-- Fetch files from XEvent directory
	insert #xe_files
	(subdirectory, depth, is_file)
	exec xp_dirtree @xe_directory,1,1;
	update #xe_files set directory = @xe_directory;

	--select * from #xe_files f where f.subdirectory like ('xevent_metrics%') order by f.subdirectory asc;

	-- Stop
	ALTER EVENT SESSION [xevent_metrics] ON SERVER STATE=STOP;
	-- Start
	ALTER EVENT SESSION [xevent_metrics] ON SERVER STATE=START;

	-- Extract XEvent Info from File
	declare @c_file nvarchar(255);
	declare @c_file_path nvarchar(2000);

	declare cur_files cursor local forward_only for
			select subdirectory
			from #xe_files f
			where f.subdirectory like ('xevent_metrics%')
			order by f.subdirectory asc;

	open cur_files;
	fetch next from cur_files into @c_file;

	while @@FETCH_STATUS = 0
	begin
		set @c_file_path = @xe_directory+@c_file;
		print @c_file_path;

		if not exists (select * from dbo.xevent_metrics_Processed_XEL_Files f where f.file_path = @c_file_path and f.is_processed = 1)
		begin
			insert dbo.xevent_metrics_Processed_XEL_Files (file_path,collection_time_utc)
			select @c_file_path as file_path, @current_time as collection_time_utc;

			;with t_event_data as (
				select xf.object_name as event_name, xf.file_name, event_data = convert(xml,xf.event_data) --,xf.timestamp_utc, 
				from sys.fn_xe_file_target_read_file(@c_file_path,null,null,null) as xf
				where xf.object_name in ('sql_batch_completed','rpc_completed','sql_statement_completed')
			)
			,t_data_extracted as (
				select  [event_name]
						,[event_time] = DATEADD(mi, DATEDIFF(mi, sysutcdatetime(), sysdatetime()), (event_data.value('(/event/@timestamp)[1]','datetime2')))
						--,[event_time] = event_data.value('(/event/@timestamp)[1]','datetime2')
						,[cpu_time] = event_data.value('(/event/data[@name="cpu_time"]/value)[1]','bigint')
						,[duration_seconds] = (event_data.value('(/event/data[@name="duration"]/value)[1]','bigint'))/1000000
						,[physical_reads] = event_data.value('(/event/data[@name="physical_reads"]/value)[1]','bigint')
						,[logical_reads] = event_data.value('(/event/data[@name="logical_reads"]/value)[1]','bigint')
						,[writes] = event_data.value('(/event/data[@name="writes"]/value)[1]','bigint')
						,[spills] = event_data.value('(/event/data[@name="spills"]/value)[1]','bigint')
						,[row_count] = event_data.value('(/event/data[@name="row_count"]/value)[1]','bigint')
						,[result] = case event_data.value('(/event/data[@name="result"]/value)[1]','int')
											when 0 then 'OK'
											when 1 then 'Error'
											when 2 then 'Abort'
											else 'Unknown'
											end
						,[username] = event_data.value('(/event/action[@name="username"]/value)[1]','varchar(255)')
						,[sql_text] = case when event_name = 'rpc_completed' and event_data.value('(/event/action[@name="sql_text"]/value)[1]','varchar(max)') is null
											then ltrim(rtrim(event_data.value('(/event/data[@name="statement"]/value)[1]','varchar(max)')))
											else ltrim(rtrim(event_data.value('(/event/action[@name="sql_text"]/value)[1]','varchar(max)')))
										end
						--,[query_hash] = event_data.value('(/event/action[@name="query_hash"]/value)[1]','varbinary(255)')
						--,[query_plan_hash] = event_data.value('(/event/action[@name="query_plan_hash"]/value)[1]','varbinary(255)')
						,[database_name] = event_data.value('(/event/action[@name="database_name"]/value)[1]','varchar(255)')
						,[client_hostname] = event_data.value('(/event/action[@name="client_hostname"]/value)[1]','varchar(255)')
						,[client_app_name] = event_data.value('(/event/action[@name="client_app_name"]/value)[1]','varchar(255)')
						,[session_resource_pool_id] = event_data.value('(/event/action[@name="session_resource_pool_id"]/value)[1]','int')
						,[session_resource_group_id] = event_data.value('(/event/action[@name="session_resource_group_id"]/value)[1]','int')
						,[session_id] = event_data.value('(/event/action[@name="session_id"]/value)[1]','int')
						,[request_id] = event_data.value('(/event/action[@name="request_id"]/value)[1]','int')
						,[scheduler_id] = event_data.value('(/event/action[@name="scheduler_id"]/value)[1]','int')
				from t_event_data ed
			)
			insert [dbo].[vw_xevent_metrics]
			(	row_id, start_time, event_time, event_name, session_id, request_id, result, database_name, client_app_name, username, cpu_time_ms, duration_seconds, 
				logical_reads, physical_reads, row_count, writes, spills, sql_text, /* query_hash, query_plan_hash, */
				client_hostname, session_resource_pool_id, session_resource_group_id, scheduler_id --, context_info
			)
			select	[row_id] = ROW_NUMBER()over(order by event_time, duration_seconds desc, session_id, request_id),
					start_time = DATEADD(second,-(duration_seconds),event_time), event_time, event_name, 
					session_id, request_id, result, database_name,
					[client_app_name] = CASE	WHEN	[client_app_name] like 'SQLAgent - TSQL JobStep %'
						THEN	(	select	top 1 'SQL Job = '+j.name 
									from msdb.dbo.sysjobs (nolock) as j
									inner join msdb.dbo.sysjobsteps (nolock) AS js on j.job_id=js.job_id
									where right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring([client_app_name],30,34),10) 
								) + ' ( '+SUBSTRING(LTRIM(RTRIM([client_app_name])), CHARINDEX(': Step ',LTRIM(RTRIM([client_app_name])))+2,LEN(LTRIM(RTRIM([client_app_name])))-CHARINDEX(': Step ',LTRIM(RTRIM([client_app_name])))-2)+' )'
						ELSE	[client_app_name]
						END,
					username, 
					cpu_time_ms = case	when event_name = 'rpc_completed' and convert(int,SERVERPROPERTY('ProductMajorVersion')) >= 11 
										then cpu_time/1000
										when event_name = 'sql_batch_completed' and convert(int,SERVERPROPERTY('ProductMajorVersion')) >= 15
										then cpu_time/1000
										else cpu_time
										end, 
					duration_seconds, logical_reads, physical_reads, row_count, 
					writes, spills, sql_text, /* query_hash, query_plan_hash, */
					client_hostname, session_resource_pool_id, session_resource_group_id, scheduler_id--, context_info
			from t_data_extracted de
			where not exists (select 1 from [dbo].[xevent_metrics] t 
								where t.start_time = DATEADD(second,-(de.duration_seconds),de.event_time)
								and t.event_time = de.event_time
								and t.event_name = de.event_name  COLLATE SQL_Latin1_General_CP1_CI_AS
								and t.session_id = de.session_id
								and t.request_id = de.request_id)

			update f set is_processed = 1
			from dbo.xevent_metrics_Processed_XEL_Files f
			where f.file_path = @c_file_path and f.is_processed = 0 and f.collection_time_utc = @current_time;
		end

		fetch next from cur_files into @c_file;
	end

	close cur_files;
	deallocate cur_files;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collect_xevents_resource_consumption
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_collect_xevents_resource_consumption
AS 
BEGIN
	/*
		Version:		1.1.5
		Date:			2022-11-11

		EXEC dbo.usp_collect_xevents_resource_consumption

		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds
	
	declare @xe_directory nvarchar(2000);
	declare @xe_file nvarchar(255);
	declare @context varbinary(2000);
	declare @current_time datetime2 = sysutcdatetime();

	if OBJECT_ID('tempdb..#xe_files') is not null
		drop table #xe_files;
	create table #xe_files (directory nvarchar(2000), subdirectory nvarchar(255), depth tinyint, is_file bit);

	-- Get XEvent files directory
	;with targets_xml as (
		select	target_data_xml = CONVERT(XML, target_data)
		from sys.dm_xe_sessions xs
		join sys.dm_xe_session_targets xt on xt.event_session_address = xs.address
		where xs.name = 'resource_consumption'
		and xt.target_name = 'event_file'
	)
	,targets_current as (
		select file_path = t.target_data_xml.value('(/EventFileTarget/File/@name)[1]','varchar(2000)')
		from targets_xml t
	)
	select @xe_directory = (case when CHARINDEX('\',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('\',reverse(t.file_path))+1)
							 when CHARINDEX('/',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('/',reverse(t.file_path))+1)
							 end)
			,@xe_file = t.file_path
	from targets_current t;

	--select [@xe_directory] = @xe_directory, [@xe_file] = @xe_file;

	-- Fetch files from XEvent directory
	insert #xe_files
	(subdirectory, depth, is_file)
	exec xp_dirtree @xe_directory,1,1;
	update #xe_files set directory = @xe_directory;

	--select * from #xe_files f where f.subdirectory like ('resource_consumption%') order by f.subdirectory asc;

	-- Stop
	ALTER EVENT SESSION [resource_consumption] ON SERVER STATE=STOP;
	-- Start
	ALTER EVENT SESSION [resource_consumption] ON SERVER STATE=START;

	-- Extract XEvent Info from File
	declare @c_file nvarchar(255);
	declare @c_file_path nvarchar(2000);

	declare cur_files cursor local forward_only for
			select subdirectory
			from #xe_files f
			where f.subdirectory like ('resource_consumption%')
			order by f.subdirectory asc;

	open cur_files;
	fetch next from cur_files into @c_file;

	while @@FETCH_STATUS = 0
	begin
		set @c_file_path = @xe_directory+@c_file;
		print @c_file_path;

		if not exists (select * from dbo.resource_consumption_Processed_XEL_Files f where f.file_path = @c_file_path and f.is_processed = 1)
		begin
			insert dbo.resource_consumption_Processed_XEL_Files (file_path,collection_time_utc)
			select @c_file_path as file_path, @current_time as collection_time_utc;

			;with t_event_data as (
				select xf.object_name as event_name, xf.file_name, event_data = convert(xml,xf.event_data) --,xf.timestamp_utc, 
				from sys.fn_xe_file_target_read_file(@c_file_path,null,null,null) as xf
				where xf.object_name in ('sql_batch_completed','rpc_completed','sql_statement_completed')
			)
			,t_data_extracted as (
				select  [event_name]
						,[event_time] = DATEADD(mi, DATEDIFF(mi, sysutcdatetime(), sysdatetime()), (event_data.value('(/event/@timestamp)[1]','datetime2')))
						--,[event_time] = event_data.value('(/event/@timestamp)[1]','datetime2')
						,[cpu_time] = event_data.value('(/event/data[@name="cpu_time"]/value)[1]','bigint')
						,[duration_seconds] = (event_data.value('(/event/data[@name="duration"]/value)[1]','bigint'))/1000000
						,[physical_reads] = event_data.value('(/event/data[@name="physical_reads"]/value)[1]','bigint')
						,[logical_reads] = event_data.value('(/event/data[@name="logical_reads"]/value)[1]','bigint')
						,[writes] = event_data.value('(/event/data[@name="writes"]/value)[1]','bigint')
						,[spills] = event_data.value('(/event/data[@name="spills"]/value)[1]','bigint')
						,[row_count] = event_data.value('(/event/data[@name="row_count"]/value)[1]','bigint')
						,[result] = case event_data.value('(/event/data[@name="result"]/value)[1]','int')
											when 0 then 'OK'
											when 1 then 'Error'
											when 2 then 'Abort'
											else 'Unknown'
											end
						,[username] = event_data.value('(/event/action[@name="username"]/value)[1]','varchar(255)')
						,[sql_text] = case when event_name = 'rpc_completed' and event_data.value('(/event/action[@name="sql_text"]/value)[1]','varchar(max)') is null
											then ltrim(rtrim(event_data.value('(/event/data[@name="statement"]/value)[1]','varchar(max)')))
											else ltrim(rtrim(event_data.value('(/event/action[@name="sql_text"]/value)[1]','varchar(max)')))
										end
						--,[query_hash] = event_data.value('(/event/action[@name="query_hash"]/value)[1]','varbinary(255)')
						--,[query_plan_hash] = event_data.value('(/event/action[@name="query_plan_hash"]/value)[1]','varbinary(255)')
						,[database_name] = event_data.value('(/event/action[@name="database_name"]/value)[1]','varchar(255)')
						,[client_hostname] = event_data.value('(/event/action[@name="client_hostname"]/value)[1]','varchar(255)')
						,[client_app_name] = event_data.value('(/event/action[@name="client_app_name"]/value)[1]','varchar(255)')
						,[session_resource_pool_id] = event_data.value('(/event/action[@name="session_resource_pool_id"]/value)[1]','int')
						,[session_resource_group_id] = event_data.value('(/event/action[@name="session_resource_group_id"]/value)[1]','int')
						,[session_id] = event_data.value('(/event/action[@name="session_id"]/value)[1]','int')
						,[request_id] = event_data.value('(/event/action[@name="request_id"]/value)[1]','int')
						,[scheduler_id] = event_data.value('(/event/action[@name="scheduler_id"]/value)[1]','int')
				from t_event_data ed
			)
			insert [dbo].[vw_resource_consumption]
			(	row_id, start_time, event_time, event_name, session_id, request_id, result, database_name, client_app_name, username, cpu_time_ms, duration_seconds, 
				logical_reads, physical_reads, row_count, writes, spills, sql_text, /* query_hash, query_plan_hash, */
				client_hostname, session_resource_pool_id, session_resource_group_id, scheduler_id --, context_info
			)
			select	[row_id] = ROW_NUMBER()over(order by event_time, duration_seconds desc, session_id, request_id),
					start_time = DATEADD(second,-(duration_seconds),event_time), event_time, event_name, 
					session_id, request_id, result, database_name,
					[client_app_name] = CASE	WHEN	[client_app_name] like 'SQLAgent - TSQL JobStep %'
						THEN	(	select	top 1 'SQL Job = '+j.name 
									from msdb.dbo.sysjobs (nolock) as j
									inner join msdb.dbo.sysjobsteps (nolock) AS js on j.job_id=js.job_id
									where right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring([client_app_name],30,34),10) 
								) + ' ( '+SUBSTRING(LTRIM(RTRIM([client_app_name])), CHARINDEX(': Step ',LTRIM(RTRIM([client_app_name])))+2,LEN(LTRIM(RTRIM([client_app_name])))-CHARINDEX(': Step ',LTRIM(RTRIM([client_app_name])))-2)+' )'
						ELSE	[client_app_name]
						END,
					username, 
					cpu_time_ms = case	when event_name = 'rpc_completed' and convert(int,SERVERPROPERTY('ProductMajorVersion')) >= 11 
										then cpu_time/1000
										when event_name = 'sql_batch_completed' and convert(int,SERVERPROPERTY('ProductMajorVersion')) >= 15
										then cpu_time/1000
										else cpu_time
										end, 
					duration_seconds, logical_reads, physical_reads, row_count, 
					writes, spills, sql_text, /* query_hash, query_plan_hash, */
					client_hostname, session_resource_pool_id, session_resource_group_id, scheduler_id--, context_info
			from t_data_extracted de
			where not exists (select 1 from [dbo].[resource_consumption] t 
								where t.start_time = DATEADD(second,-(de.duration_seconds),de.event_time)
								and t.event_time = de.event_time
								and t.event_name = de.event_name  COLLATE SQL_Latin1_General_CP1_CI_AS
								and t.session_id = de.session_id
								and t.request_id = de.request_id)

			update f set is_processed = 1
			from dbo.resource_consumption_Processed_XEL_Files f
			where f.file_path = @c_file_path and f.is_processed = 0 and f.collection_time_utc = @current_time;
		end

		fetch next from cur_files into @c_file;
	end

	close cur_files;
	deallocate cur_files;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_create_agent_alerts
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_create_agent_alerts
(	@drop_create_alert bit = 0, /* When enabled, drop the alert, and recreate */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@alert_operator_name varchar(255) = null
)
AS 
BEGIN

	/*
		https://learn.microsoft.com/en-us/sql/ssms/agent/use-tokens-in-job-steps?view=sql-server-ver16
		Pre-requisites:	dbo.alert_categories, dbo.alert_history, dbo.usp_capture_alert_messages, job [(dba) Capture-AlertMessages]

		Version -> 2026-01-31
		2026-01-31 - #3 - Infra to Track Server and Database Configuration Changes
		2024-05-23 - Updated to include Sev 19-25

		EXEC dbo.usp_create_agent_alerts
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_job_name nvarchar(500);
	DECLARE @c_alert_name varchar(255);
	DECLARE @c_alert_error_number int;
	DECLARE @c_error_severity int;

	-- Variables for Try/Catch Block
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';

		if @verbose > 0
			print 'Enable Replace Token in SQLAgent Jobs'
		EXEC msdb.dbo.sp_set_sqlagent_properties @alert_replace_runtime_tokens=1

		if not (@alert_operator_name is not null and exists (select * from msdb.dbo.sysoperators where name = @alert_operator_name))
		begin
			set @alert_operator_name = null;
			print 'Since operator ['+@alert_operator_name+'] is not found. Neglecting same.';
		end

		DECLARE cur_ForEachErrorNumber CURSOR LOCAL FAST_FORWARD FOR
			SELECT ac.error_number, ac.error_severity, ac.alert_name
			FROM dbo.alert_categories ac;

		OPEN cur_ForEachErrorNumber;
		FETCH NEXT FROM cur_ForEachErrorNumber INTO @c_alert_error_number, @c_error_severity, @c_alert_name;

		WHILE @@fetch_status = 0
		BEGIN
			IF ( @drop_create_alert = 1 
				OR EXISTS ( SELECT 1/0 FROM msdb.dbo.sysalerts WHERE name = @c_alert_name
							AND job_id = '00000000-0000-0000-0000-000000000000' )
			)
			BEGIN
				EXECUTE msdb.dbo.sp_delete_alert @name = @c_alert_name;			
			END

			IF NOT EXISTS ( SELECT 1/0 FROM msdb.dbo.sysalerts WHERE name = @c_alert_name )
			BEGIN
				EXECUTE msdb.dbo.sp_add_alert @name = @c_alert_name, @message_id = @c_alert_error_number, @severity = @c_error_severity, @enabled = 1, @delay_between_responses = 0, @include_event_description_in = 1, @job_name = N'(dba) Capture-AlertMessages';

				if @alert_operator_name is  not null
					EXECUTE msdb.dbo.sp_add_notification @alert_name = @c_alert_name, @operator_name = @alert_operator_name, @notification_method = 1;

				print 'Alert ['+@c_alert_name+'] created.'
			END
			ELSE
				print 'Alert ['+@c_alert_name+'] already exists.'

			FETCH NEXT FROM cur_ForEachErrorNumber INTO @c_alert_error_number, @c_error_severity, @c_alert_name;
		END

		--==== Close/Deallocate cursor
		CLOSE cur_ForEachErrorNumber;

		DEALLOCATE cur_ForEachErrorNumber;

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
		print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
		print  '	ErrorState => '+convert(varchar,ERROR_STATE());
		--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
		print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
		print  '	ErrorMessage => '+ERROR_MESSAGE();
	END CATCH
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_enable_page_compression
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_enable_page_compression
	@verbose tinyint = 0,
	@dry_run bit = 0
--WITH EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		1.0.1
		Date:			2022-10-15

		exec usp_enable_page_compression @verbose = 2, @dry_run = 1;
	*/
	SET NOCOUNT ON; 
	declare @table_name nvarchar(125);
	declare @index_name nvarchar(125);
	declare @sql_text nvarchar(4000);
	declare @counter int = 1;
	declare @index_counts int = 0;
	--declare @sql nvarchar(max);
	--declare @params nvarchar(max);
	--declare @err_message nvarchar(2000);
	declare @crlf nchar(2);
	declare @tab nchar(1);

	declare @index_table_to_compress table (id int identity(1,1) not null, table_name nvarchar(125) not null, index_name nvarchar(125) null);

	insert @index_table_to_compress (table_name, index_name)
	select table_name, index_name
	from (values ('dbo.performance_counters',NULL),
				 ('dbo.performance_counters','nci_counter_collection_time_utc'),
				 ('dbo.os_task_list',NULL),
				 ('dbo.os_task_list','nci_cpu_time_seconds'),
				  ('dbo.os_task_list','nci_memory_kb'),
				 ('dbo.os_task_list','nci_user_name'),
				 ('dbo.os_task_list','nci_window_title'),
				 ('dbo.wait_stats',NULL),
				 ('dbo.xevent_metrics', NULL),
				 ('dbo.xevent_metrics','uq_xevent_metrics'),
				 --('dbo.xevent_metrics_queries', NULL),
				 ('dbo.disk_space',NULL),
				 ('dbo.BlitzIndex',NULL),
				 ('dbo.file_io_stats',NULL),
				 ('dbo.WrongName',NULL)
		) table_indexes(table_name, index_name);

	select @index_counts = count(*) from @index_table_to_compress;

	if @verbose > 0
	begin
		select	running_query = '@index_table_to_compress',
				is_existing = case when OBJECT_ID(table_name) is null then 0 else 1 end, 
				*
		from @index_table_to_compress;
	end

	while @counter <= @index_counts
	begin
		select @table_name = table_name, @index_name = index_name from @index_table_to_compress where id = @counter;
		
		if @index_name is null
		begin
			set @sql_text = '
					if exists ( select * from sys.partitions p inner join sys.indexes i on p.object_id = i.object_id and p.index_id = i.index_id 
									where p.object_id = object_id('''+@table_name+''') and p.data_compression = 0 and i.index_id  in (0,1))
						ALTER TABLE '+@table_name+' REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
				'+char(10)
		end
		else
		begin
			set @sql_text = '
					if exists ( select * from sys.partitions p inner join sys.indexes i on p.object_id = i.object_id and p.index_id = i.index_id 
									where p.object_id = object_id('''+@table_name+''') and p.data_compression = 0 and i.name = '''+@index_name+''' )
						ALTER INDEX '+quotename(@index_name)+' ON '+@table_name+' REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);  
				'+char(10)
		end

		if OBJECT_ID(@table_name) is not null
		begin
			if @verbose > 0
				print @sql_text;
			if @dry_run = 0
				exec (@sql_text);
		end
		else
			print 'Table '+@table_name+' does not exist.'

		set @counter = @counter + 1;
	end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_extended_results
-- --------------------------------------------------

CREATE procedure dbo.usp_extended_results @processor_name nvarchar(500) = null output, @host_distribution nvarchar(500) = null output, @fqdn nvarchar(100) = null output
--with execute as owner
as
begin
	set nocount on;
	
	-- Processor Name
	exec xp_instance_regread 'HKEY_LOCAL_MACHINE', 'HARDWARE\DESCRIPTION\System\CentralProcessor\0', 'ProcessorNameString', @value = @processor_name output;

	-- Windows Version
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE', 'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'ProductName', @value = @host_distribution OUTPUT;

	-- FQDN
	EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\services\Tcpip\Parameters', N'Domain', @fqdn OUTPUT;     
	SET @fqdn = Cast(SERVERPROPERTY('MachineName') as nvarchar) + '.' + @fqdn;
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetFailedLoginsListEvryDay
-- --------------------------------------------------
CREATE PROC [dbo].[usp_GetFailedLoginsListEvryDay]
AS
BEGIN
   SET NOCOUNT ON

   DECLARE @ErrorLogCount INT 
   DECLARE @LastLogDate DATETIME

   DECLARE @ErrorLogInfo TABLE (
       LogDate DATETIME
      ,ProcessInfo NVARCHAR (50)
      ,[Text] NVARCHAR (MAX)
      )
   
   DECLARE @EnumErrorLogs TABLE (
       [Archive#] INT
      ,[Date] DATETIME
      ,LogFileSizeMB INT
      )

   INSERT INTO @EnumErrorLogs
   EXEC sp_enumerrorlogs

   SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
   FROM @EnumErrorLogs

   WHILE @ErrorLogCount IS NOT NULL
   BEGIN

      INSERT INTO @ErrorLogInfo
      EXEC sp_readerrorlog @ErrorLogCount

      SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
      FROM @EnumErrorLogs
      WHERE [Archive#] > @ErrorLogCount
      AND CONVERT (date, @LastLogDate)   =  CONVERT (date , GETDATE())    
  
   END

    --List all last week failed logins count of attempts and the Login failure message
  INsert into [dbo].[FailedLogincapture] 
   SELECT COUNT (TEXT) AS NumberOfAttempts, 
   TEXT AS Details, MIN(LogDate) as MinLogDate,
   --MAX(LogDate) as MaxLogDate,
   DBA_Admin.[dbo].[fn_Get_Login_name_IP_Details] (TEXT , 0) AS IP,
   CONVERT ( date , GETDATE())
 --  [AUDIT_DB].[dbo].[Sp_Get_Login_name_IP_Details] (TEXT , 1) AS LOGIN_NAME
   FROM @ErrorLogInfo
   WHERE ProcessInfo = 'Logon'
      AND TEXT LIKE '%fail%'
	  AND TEXT NOT LIKE '%Reason: Failed to open the explicitly specified database%'
      AND CONVERT (date,LogDate) = CONVERT (date , GETDATE()) 
   GROUP BY TEXT
   ORDER BY NumberOfAttempts DESC

   SET NOCOUNT OFF
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetSuccessfulLoginsListEvryDay
-- --------------------------------------------------
CREATE  PROC [dbo].[usp_GetSuccessfulLoginsListEvryDay]
AS
BEGIN
   SET NOCOUNT ON

   DECLARE @ErrorLogCount INT 
   DECLARE @LastLogDate DATETIME

   DECLARE @ErrorLogInfo TABLE (
       LogDate DATETIME
      ,ProcessInfo NVARCHAR (50)
      ,[Text] NVARCHAR (MAX)
      )
   
   DECLARE @EnumErrorLogs TABLE (
       [Archive#] INT
      ,[Date] DATETIME
      ,LogFileSizeMB INT
      )

   INSERT INTO @EnumErrorLogs
   EXEC sp_enumerrorlogs

   SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
   FROM @EnumErrorLogs

   WHILE @ErrorLogCount IS NOT NULL
   BEGIN

      INSERT INTO @ErrorLogInfo
      EXEC sp_readerrorlog @ErrorLogCount

      SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
      FROM @EnumErrorLogs
      WHERE [Archive#] > @ErrorLogCount
      AND CONVERT(date,@LastLogDate) = CONVERT(date,getdate()) 
  
   END

    --List all last Successul logins count 
 --Insert into [dbo].[SuccessfullLoginCapture] 
   SELECT COUNT (TEXT) AS NumberOfAttempts, TEXT AS Details, 
   MIN(LogDate) as LoginDate,
 --  MAX(LogDate) as MaxLogDate,
   DBA_Admin.[dbo].[fn_Get_Login_name_IP_Details] (TEXT , 0) AS IP,
   CONVERT ( date , GETDATe() )
 --  [AUDIT_DB].[dbo].[Sp_Get_Login_name_IP_Details] (TEXT , 1) AS LOGIN_NAME                            
   FROM @ErrorLogInfo
   WHERE ProcessInfo = 'Logon'
      AND TEXT LIKE '%Login succeeded for user%'
	  AND TEXT NOT LIKE '%Database Mirroring Login succeeded for%'
      AND CONVERT(date,LogDate) = CONVERT(date,getdate())   
   GROUP BY TEXT
   ORDER BY NumberOfAttempts DESC

   

   SET NOCOUNT OFF
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_LogSaver
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_LogSaver]
(
	@log_used_pct_threshold tinyint = 80,
	@log_used_gb_threshold int = NULL,
	@threshold_condition varchar(5) = 'or', /* and | or */
	@databases varchar(max) = NULL, /* Comma separated list of databases. -ve (negative) if database has to be excluded */
	@email_recipients varchar(max) = 'dba_team@gmail.com',
	@retention_days int = 30,
	@purge_table bit = 1,
	@drop_create_table bit = 0,
	@kill_spids bit = 0,
	@send_email bit = 0,
	@skip_autogrowth_validation bit = 0,
	@verbose tinyint = 0 /* 1 => messages, 2 => messages + table results */
)
AS
BEGIN
/*	Purpose:		
	Modifications:	2023-08-11 - Initial Draft
	

	exec usp_LogSaver 
				--@databases = 'Facebook,-DBA,Dbatools,tempdb',
				--@databases = '-DBA',
				@log_used_pct_threshold = 80,
				@log_used_gb_threshold = 500,
				@threshold_condition = 'or',
				@skip_autogrowth_validation = 0,
				@email_recipients = 'sqlagentservice@gmail.com',
				@purge_table = 0,
				@kill_spids = 0,
				@send_email = 0,
				@drop_create_table = 0,
				@verbose = 2;

	select * from dbo.log_space_consumers where collection_time > dateadd(minute,-10,getdate())
*/
	SET NOCOUNT ON
	SET XACT_ABORT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @_start_time datetime2;
	SET @_start_time = SYSDATETIME();

	IF @verbose >= 1
		PRINT '('+convert(varchar, getdate(), 21)+') Declaring local variables..';

	DECLARE @_spid int
	DECLARE @_sql varchar(max)
	DECLARE @_params nvarchar(max)
	DECLARE @_email_body varchar(max) = ''
	DECLARE @_email_subject nvarchar(255)
	DECLARE @_log_used_pct decimal(38,2)
	DECLARE @_error varchar(8000)
	DECLARE @_is_pct_threshold_valid bit = 0;
	DECLARE @_is_gb_threshold_valid bit = 0;
	DECLARE @_thresholds_validated bit = 0;
	DECLARE @_exists_valid_autogrowing_file bit = 0;
	DECLARE @_transaction_start_time datetime;

	DECLARE @_tab nchar(1) = CHAR(9);

	declare @c_database_name sysname;
	declare @c_recovery_model varchar(50);
	declare @c_log_reuse_wait_desc varchar(125);
	declare @c_log_size_mb numeric(12,2);
	declare @c_log_used_pct numeric(6,2);

	IF @verbose >= 1
		PRINT '('+convert(varchar, getdate(), 21)+') Creating #temp tables..';

	IF OBJECT_ID('tempdb..#logspace') IS NOT NULL
		DROP TABLE #logspace;
	CREATE TABLE #logspace
	(	[database_name] sysname,
		log_size_mb   decimal(38,2),
		log_used_pct  decimal(38,2),
		log_status    int
	);

	IF OBJECT_ID('tempdb..#dbcc_opentran') IS NOT NULL
		DROP TABLE #dbcc_opentran;
	CREATE TABLE #dbcc_opentran
	(	[database_name]  sysname NULL,
		transaction_property varchar(100) NULL,
		transaction_property_value varchar(1000) NULL
	);

	IF OBJECT_ID('tempdb..#log_space_consumers') IS NOT NULL
		DROP TABLE #log_space_consumers;
	CREATE TABLE #log_space_consumers 
	(
		[collection_time] datetime2 not null
		,[database_name] sysname not null
		,[recovery_model] varchar(20) not null
		,[log_reuse_wait_desc] varchar(125) not null
		,[log_size_mb] decimal(20, 2) not null
		,[log_used_mb] decimal(20, 2) not null
		,[exists_valid_autogrowing_file] bit null
		,[log_used_pct] decimal(10, 2) default 0.0 not null
		,[log_used_pct_threshold] decimal(10,2) not null
		,[log_used_gb_threshold] decimal(20,2) null
		,[spid] int null
		,[transaction_start_time] datetime null
		,[login_name] sysname null
		,[program_name] sysname null
		,[host_name] sysname null
		,[host_process_id] int null
		,[command] varchar(16) null
		,[additional_info] varchar(255) null
		,[action_taken] varchar(100) null
		,[sql_text] varchar(max) null
		,[is_pct_threshold_valid] bit default 0 not null
		,[is_gb_threshold_valid] bit default 0 not null
		,[threshold_condition] varchar(5) not null
		,[thresholds_validated] bit default 0 not null
	);

	IF OBJECT_ID('dbo.log_space_consumers') IS NOT NULL AND @drop_create_table = 1
		EXEC ('drop table dbo.log_space_consumers');

	IF OBJECT_ID('dbo.log_space_consumers') IS NULL
	BEGIN
		SET @_sql = 'SELECT * INTO dbo.log_space_consumers FROM #log_space_consumers;
		CREATE CLUSTERED INDEX ci_log_space_consumers ON dbo.log_space_consumers (collection_time);'

		EXEC (@_sql);
	END

	-- Create Temporary Tables
	IF OBJECT_ID('tempdb..#db_list_from_params') IS NOT NULL
		DROP TABLE #db_list_from_params;
	CREATE TABLE #db_list_from_params ([database_name] sysname, [skip_db] bit);

	IF OBJECT_ID('tempdb..#db_list') IS NOT NULL
		DROP TABLE #db_list;
	CREATE TABLE #db_list ([database_name] sysname, [recovery_model] varchar(50), [log_reuse_wait_desc] varchar(125));	

	IF @databases IS NOT NULL
	BEGIN
		IF @verbose >= 1
			PRINT '('+convert(varchar, getdate(), 21)+') Extracting database names from ('+@databases+') parameter value..';
		;WITH t1([database_name], [databases]) AS 
		(
			SELECT	CAST(LEFT(@databases, CHARINDEX(',',@databases+',')-1) AS VARCHAR(500)) as [database_name],
					STUFF(@databases, 1, CHARINDEX(',',@databases+','), '') as [databases]
			--
			UNION ALL
			--
			SELECT	CAST(LEFT([databases], CHARINDEX(',',[databases]+',')-1) AS VARChAR(500)) AS [database_name],
					STUFF([databases], 1, CHARINDEX(',',[databases]+','), '')  as [databases]
			FROM t1
			WHERE [databases] > ''	
		)
		INSERT #db_list_from_params ([database_name], [skip_db])
		SELECT	[database_name] = case when left(ltrim(rtrim([database_name])),1) = '-' then RIGHT(ltrim(rtrim([database_name])),len(ltrim(rtrim([database_name])))-1) else ltrim(rtrim([database_name])) end, 
				[skip_db] = case when left(ltrim(rtrim([database_name])),1) = '-' then 1 else 0 end
		FROM t1
		OPTION (MAXRECURSION 32000);

		IF @verbose >= 2
		BEGIN
			PRINT '('+convert(varchar, getdate(), 21)+') select * from #db_list_from_params..'
			select running_query, t.*
			from #db_list_from_params t
			full outer join (values ('#db_list_from_params') )dummy(running_query) on 1 = 1
		END
	END
	
	IF @databases IS NOT NULL
	BEGIN
		IF @verbose >= 1
			PRINT '('+convert(varchar, getdate(), 21)+') Extracting database names from ('+@databases+') parameter value..';

		IF EXISTS (SELECT 1/0 FROM #db_list_from_params p WHERE p.skip_db = 0)
		BEGIN
			IF @verbose >= 1
				PRINT '('+convert(varchar, getdate(), 21)+') Databases parameter has databases for Inclusion logic. Working on same..';

			INSERT #db_list ([database_name], [recovery_model], [log_reuse_wait_desc])
			SELECT d.name, d.recovery_model_desc, d.[log_reuse_wait_desc]
			FROM sys.databases d
			INNER JOIN #db_list_from_params pl
				ON pl.database_name = d.name
			WHERE	1=1
				AND	d.state_desc = 'ONLINE'
				AND pl.skip_db = 0;
		END
		ELSE
		BEGIN
			IF @verbose >= 1
				PRINT '('+convert(varchar, getdate(), 21)+') Databases parameter has databases for Exclusion logic only. Working on same..';

			INSERT #db_list ([database_name], [recovery_model], [log_reuse_wait_desc])
			SELECT d.name, d.recovery_model_desc, d.[log_reuse_wait_desc]
			FROM sys.databases d			
			WHERE	1=1
				AND	d.state_desc = 'ONLINE'
				AND d.name NOT IN (SELECT pl.database_name FROM #db_list_from_params pl WHERE pl.skip_db = 1);
		END
	END
	ELSE
	BEGIN
		IF @verbose >= 1
			PRINT '('+convert(varchar, getdate(), 21)+') Databases parameter not provided. Working on #db_list..';

		INSERT #db_list ([database_name], [recovery_model], [log_reuse_wait_desc])
		SELECT d.name, d.recovery_model_desc, d.[log_reuse_wait_desc]
		FROM sys.databases d			
		WHERE	1=1
			AND	d.state_desc = 'ONLINE';
	END

	IF @verbose >= 2
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') select * from #db_list..'
		select running_query, t.*
		from #db_list t
		full outer join (values ('#db_list') )dummy(running_query) on 1 = 1
	END

	IF @verbose >= 1
		PRINT '('+convert(varchar, getdate(), 21)+') Populate #logspace using SQLPERF(LOGSPACE)..'
	INSERT INTO #logspace ([database_name], log_size_mb, log_used_pct, log_status) 
		EXEC ('DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS');

	IF @verbose >= 2
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') select * from #logspace join #db_list..'
		select running_query, t.*, dl.*
		from #logspace t
		join #db_list dl on dl.database_name = t.database_name
		full outer join (values ('#logspace + #db_list') )dummy(running_query) on 1 = 1
	END
	
	IF @verbose >= 1
		PRINT '('+convert(varchar, getdate(), 21)+') Start a cursor, and loop through each database..'

	DECLARE cur_databases CURSOR LOCAL FORWARD_ONLY FOR
		SELECT dl.database_name, dl.recovery_model, dl.log_reuse_wait_desc, 
				ls.log_size_mb, ls.log_used_pct
		FROM #db_list dl
		JOIN #logspace ls
			ON ls.database_name = dl.database_name;

	OPEN cur_databases;
	FETCH NEXT FROM cur_databases INTO @c_database_name, @c_recovery_model, @c_log_reuse_wait_desc, @c_log_size_mb, @c_log_used_pct;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @_is_pct_threshold_valid = 0;
		SET @_is_gb_threshold_valid = 0;
		SET @_thresholds_validated = 0;		
		SET @_exists_valid_autogrowing_file = 0;
		SET @_spid = NULL;
		SET @_transaction_start_time = NULL;
		TRUNCATE TABLE #dbcc_opentran;

		IF @verbose >= 1
			PRINT '('+convert(varchar, getdate(), 21)+') Working on database ['+@c_database_name+']..';

		IF @verbose >= 1
			PRINT @_tab+@_tab+'Validate if a valid auto-growing log file exists..'
		IF EXISTS (	SELECT * FROM sys.master_files mf 
					WHERE mf.database_id = DB_ID(@c_database_name) AND mf.type_desc = 'LOG'
					AND mf.growth > 0 AND mf.max_size <> 0 -- auto growth is enabled
					AND (	mf.max_size = -1
						OR	((mf.max_size*8.0/1024)*@log_used_pct_threshold/100.0) > @c_log_size_mb -- @log_used_pct_threshold of max size is not reached
						)
				)
		BEGIN
			SET @_exists_valid_autogrowing_file = 1;
		END

		-- Validate if % thresholds are crossed
		IF	(	@log_used_pct_threshold IS NOT NULL
			AND	@c_log_used_pct >= @log_used_pct_threshold
			AND (	@_exists_valid_autogrowing_file = 0
				OR	@skip_autogrowth_validation = 1
				)
			)
		BEGIN
			SET @_is_pct_threshold_valid = 1;
		END

		IF (@log_used_gb_threshold IS NOT NULL) AND ((@c_log_size_mb * @c_log_used_pct / 100.0) > (@log_used_gb_threshold*1024.0))
		BEGIN
			SET @_is_gb_threshold_valid = 1;
		END

		SET @_thresholds_validated = (CASE	WHEN @threshold_condition = 'and' and (@_is_pct_threshold_valid = 1 and @_is_gb_threshold_valid = 1) THEN 1
											WHEN @threshold_condition = 'or' and (@_is_pct_threshold_valid = 1 OR @_is_gb_threshold_valid = 1) THEN 1
											ELSE 0
											END);

		IF (@_thresholds_validated = 1) AND (@verbose >= 1)
			PRINT @_tab+@_tab+'Threshold broken for database ['+@c_database_name+']..';
		
		IF @verbose >= 1
		BEGIN
			PRINT @_tab+@_tab+'@c_log_reuse_wait_desc = '+ @c_log_reuse_wait_desc;
			PRINT @_tab+@_tab+'@c_log_size_mb = '+ convert(varchar,@c_log_size_mb);
			PRINT @_tab+@_tab+'@c_log_used_pct = '+ convert(varchar,@c_log_used_pct);
			PRINT @_tab+@_tab+'@_exists_valid_autogrowing_file = '+ convert(varchar,@_exists_valid_autogrowing_file);
			PRINT @_tab+@_tab+'@_is_pct_threshold_valid = '+ convert(varchar,@_is_pct_threshold_valid);
			PRINT @_tab+@_tab+'@_is_gb_threshold_valid = '+ convert(varchar,@_is_gb_threshold_valid);
			--PRINT @_tab+@_tab+'@_thresholds_validated = '+ convert(varchar,@_thresholds_validated);
		END
		
		-- If Thresholds are met, then find out oldest transaction details
		IF @_thresholds_validated = 1
		BEGIN
			IF @verbose >= 1
				PRINT @_tab+@_tab+'Find longest open transaction using DBCC OPENTRAN..';
			SET @_sql = 'DBCC OPENTRAN(''' + @c_database_name + ''') WITH TABLERESULTS, NO_INFOMSGS;';
			INSERT INTO #dbcc_opentran (transaction_property, transaction_property_value) 
			EXEC (@_sql);

			IF @verbose >= 2
			BEGIN
				PRINT @_tab+@_tab+' select * from #dbcc_opentran..'
				select running_query, [@c_database_name] = @c_database_name, t.*
				from #dbcc_opentran t
				full outer join (values ('#dbcc_opentran') )dummy(running_query) on 1 = 1
			END

			SELECT	@_spid = CASE WHEN transaction_property = 'OLDACT_SPID' THEN transaction_property_value ELSE @_spid END,
					@_transaction_start_time = CASE WHEN transaction_property = 'OLDACT_STARTTIME' THEN convert(datetime,transaction_property_value) ELSE @_transaction_start_time END
			FROM #dbcc_opentran 
			WHERE transaction_property IN ('OLDACT_SPID','OLDACT_STARTTIME');
		END

		IF @verbose >= 1
			PRINT @_tab+@_tab+'Populate #log_space_consumers with log usage + transaction details..';

		INSERT INTO #log_space_consumers
		(	[collection_time], [database_name], [recovery_model], [log_reuse_wait_desc], [log_size_mb], [log_used_mb], 
			[exists_valid_autogrowing_file], [log_used_pct], [log_used_pct_threshold], [log_used_gb_threshold], [spid], 
			[transaction_start_time], [login_name], [program_name], [host_name], [host_process_id], [command], [sql_text], 
			[action_taken], [additional_info], [is_pct_threshold_valid], [is_gb_threshold_valid], [threshold_condition],
			[thresholds_validated]
		)
		SELECT	[collection_time] = @_start_time,
				[database_name] = @c_database_name,
				[recovery_model] = @c_recovery_model,
				[log_reuse_wait_desc] = @c_log_reuse_wait_desc,
				[log_size_mb] = @c_log_size_mb,
				[log_used_mb] = convert(numeric(20,2), @c_log_size_mb*@c_log_used_pct/100.0),
				[exists_valid_autogrowing_file] = @_exists_valid_autogrowing_file,
				[log_used_pct] = @c_log_used_pct,
				[log_used_pct_threshold] = @log_used_pct_threshold,
				[log_used_gb_threshold] = @log_used_gb_threshold,
				[spid] = des.session_id,
				[transaction_start_time] = @_transaction_start_time,
				[login_name] = des.login_name,
				[program_name] = CASE	WHEN	des.program_name like 'SQLAgent - TSQL JobStep %'
										THEN	(	select	top 1 'SQL Job = '+j.name 
													from msdb.dbo.sysjobs (nolock) as j
													inner join msdb.dbo.sysjobsteps (nolock) AS js on j.job_id=js.job_id
													where right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring(des.program_name,30,34),10) 
												) + ' ( '+SUBSTRING(LTRIM(RTRIM(des.program_name)), CHARINDEX(': Step ',LTRIM(RTRIM(des.program_name)))+2,LEN(LTRIM(RTRIM(des.program_name)))-CHARINDEX(': Step ',LTRIM(RTRIM(des.program_name)))-2)+' )'
										ELSE	des.program_name
										END,
				[host_name] = des.[host_name],
				[host_process_id] = des.host_process_id,
				[command] = der.command,
				[sql_text] = est.text,
				[action_taken] = CASE WHEN dl.log_reuse_wait_desc = 'ACTIVE_TRANSACTION'
									THEN CASE	WHEN @kill_spids = 1 AND @send_email = 1 THEN 'Process Terminated, Notified DBA'
												WHEN @kill_spids = 1 THEN 'Process Terminated'
												WHEN @send_email = 1 THEN 'Notified DBA'
												ELSE 'No Action Taken'
												END
									ELSE 'No Action Taken'
									END,
				[additional_info] = null,
				[is_pct_threshold_valid] = @_is_pct_threshold_valid, 
				[is_gb_threshold_valid] = @_is_gb_threshold_valid, 
				[threshold_condition] = @threshold_condition,
				[thresholds_validated] = @_thresholds_validated
		FROM	#logspace t
		INNER JOIN #db_list dl 
			ON	dl.database_name = t.database_name
			AND	dl.database_name = @c_database_name
		LEFT JOIN sys.dm_exec_sessions des
			ON	des.session_id = @_spid
			AND	dl.log_reuse_wait_desc IN ('ACTIVE_TRANSACTION')
		LEFT JOIN sys.dm_exec_requests der
			ON	der.session_id = des.session_id
		OUTER APPLY sys.dm_exec_sql_text(der.sql_handle) est
		WHERE	1=1;
			--AND	status <> 'background'
			--AND	loginame NOT IN ('sa', 'NT AUTHORITY\SYSTEM');

		-- If Thresholds are met, then ACTIVE_TRANSACTION is main issue, then take action if allowed.
		IF (@_thresholds_validated = 1) AND (@_spid IS NOT NULL) AND (@c_log_reuse_wait_desc = 'ACTIVE_TRANSACTION')
		BEGIN
			IF ( (@_spid <> 0 AND @_spid >= 50) AND (@c_log_reuse_wait_desc = 'ACTIVE_TRANSACTION') )
			BEGIN
				SET @_sql = 'KILL ' + CONVERT(varchar(30), @_spid) + ';'
				IF @verbose >= 1
					PRINT @_tab+@_tab+(CASE WHEN @kill_spids = 1 THEN 'Execute: ' ELSE 'DryRun: ' END)+@_sql;

				IF @kill_spids = 1	
				BEGIN
					BEGIN TRY
						EXEC (@_sql);
					END TRY
					BEGIN CATCH
						PRINT '***** ERROR *****'+CHAR(13)+@_tab+ERROR_MESSAGE()+CHAR(13);
					END CATCH
				END
			END
			ELSE
			BEGIN
				IF @verbose >= 1
					PRINT @_tab+@_tab+'Log space is NOT caused by active transaction. So no action taken.';
			END
		END
		ELSE IF (@_thresholds_validated = 1) AND (@c_log_reuse_wait_desc <> 'ACTIVE_TRANSACTION') AND (@verbose >= 1)
			PRINT @_tab+@_tab+'Log space is NOT caused by active transaction. So no action taken.';
		ELSE IF (@verbose >= 1)
			PRINT @_tab+@_tab+'No action required for database ['+@c_database_name+']..';

		FETCH NEXT FROM cur_databases INTO @c_database_name, @c_recovery_model, @c_log_reuse_wait_desc, @c_log_size_mb, @c_log_used_pct;
	END

	IF @verbose >= 2
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') select * from #log_space_consumers..'
		select running_query, t.*
		from #log_space_consumers t
		full outer join (values ('#log_space_consumers') )dummy(running_query) on 1 = 1
	END

	IF EXISTS (SELECT 1/0 FROM #log_space_consumers)
	BEGIN
		IF @verbose >= 1
			PRINT '('+convert(varchar, getdate(), 21)+') Populate dbo.log_space_consumers from #log_space_consumers..'
		INSERT dbo.log_space_consumers
		SELECT * FROM #log_space_consumers;
	END

	IF (@purge_table = 1)
	BEGIN
		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Purge dbo.log_space_consumers with @retention_days = '+convert(varchar,@retention_days);
		DELETE FROM dbo.log_space_consumers WHERE collection_time <= DATEADD(day, -@retention_days, GETDATE());
	END

	IF EXISTS (SELECT 1/0 FROM #log_space_consumers WHERE thresholds_validated = 1 and spid IS NOT NULL)
	BEGIN
		-- Get 1st spid to report about
		select @c_database_name = lsc.database_name, @_spid = lsc.spid
		from #log_space_consumers lsc
		where thresholds_validated = 1
		and spid IS NOT NULL
		order by spid
		offset 0 rows fetch next 1 row only;

		WHILE @@ROWCOUNT <> 0
		BEGIN
			SET @_email_subject  = NULL;
			SET @_email_body = NULL;

			SET @_email_body = 'The following SQL Server process ' + CASE WHEN @kill_spids = 1 THEN 'was' ELSE 'is' END + ' preventing the ['+@c_database_name+'] database transaction log from clearing. Please visit https://ajaydwivedi.com/go/logsaver to view killed database process history.' + CHAR(10) + CHAR(10);

			SELECT	@_email_subject = 'Log Saver: ' + CONVERT(nvarchar(255), SERVERPROPERTY('ServerName')) + ' - ' + QUOTENAME(@c_database_name),
					@_email_body = @_email_body +
								'        current time: ' + CONVERT(varchar(100), collection_time, 121) + CHAR(10) +
								'                spid: ' + CONVERT(varchar(30), spid) + CHAR(10) +
								'     tran start time: ' + CONVERT(varchar(100), transaction_start_time, 121) + CHAR(10) +
								'       database_name: ' + database_name + CHAR(10) +
								'      recovery_model: ' + recovery_model + CHAR(10) +
								' log_reuse_wait_desc: ' + log_reuse_wait_desc + CHAR(10) +
								'         log_size_gb: ' + CONVERT(varchar(100), log_size_mb/1024) + CHAR(10) +
								'         log_used_gb: ' + CONVERT(varchar(100), log_used_mb/1024) + CHAR(10) +
								'        log_used_pct: ' + CONVERT(varchar(100), log_used_pct) + CHAR(10) +
								'          login_name: ' + login_name + CHAR(10) +
								'        program_name: ' + program_name + CHAR(10) +
								'           host_name: ' + host_name + CHAR(10) +
								'     host_process_id: ' + CONVERT(varchar(30), host_process_id) + CHAR(10) +
								'             command: ' + command + CHAR(10) +
								'            sql_text: ' + LTRIM(REPLACE(REPLACE(REPLACE(LEFT(sql_text, 200), CHAR(10), ' '), CHAR(13), ' '), '  ', ' ')) + CHAR(10) +
								'        action_taken: ' + action_taken + CHAR(10) + CHAR(10)
			FROM   #log_space_consumers
			WHERE thresholds_validated = 1
			and spid = @_spid;

			IF @verbose > 0
			BEGIN
				PRINT CHAR(13)+CHAR(13)+@_email_subject;
				PRINT @_email_body;
			END

			IF @send_email = 1
			BEGIN
				IF @verbose > 0
					PRINT '('+convert(varchar, getdate(), 21)+') Notifying DBA using email..';
				EXEC msdb.dbo.sp_send_dbmail
							@recipients =  @email_recipients,
							@subject =     @_email_subject,
							@body =        @_email_body,
							@body_format = 'TEXT'
			END
			
			select @c_database_name = lsc.database_name, @_spid = lsc.spid
			from #log_space_consumers lsc
			where thresholds_validated = 1
			and spid IS NOT NULL
			and lsc.spid > @_spid
			order by spid
			offset 0 rows fetch next 1 row only;
		END
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_partition_maintenance
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_partition_maintenance
	@step varchar(100) = null, /* Any particular step */
	@hourly_retention_days int = 90, /* Hourly Partition Merge Threshold */
	@daily_retention_days int = 750, /* Daily Partition Merge Threshold */
	@monthly_retention_days int = 1770, /* Monthly Partition Merge Threshold */
	@quarterly_retention_days int = 1770, /* Quarterly Partition Merge Threshold */
	@verbose tinyint = 0, /* {0,1,2} = {no message, print messages, all messages} */
	@dry_run bit = 0 /* When enabled, don't execute actual code */
AS 
BEGIN

	/*
		Version:		1.0.1
		Date:			2022-10-10 - Added new partition scheme maintenance - Hourly, Daily, Monthly, Quarterly

		EXEC dbo.usp_partition_maintenance @step = 'add_partition_datetime2_hourly', @verbose = 2, @dry_run = 1;
		EXEC dbo.usp_partition_maintenance @step = 'remove_partition_datetime2_hourly', @verbose = 2, @dry_run = 1;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET QUOTED_IDENTIFIER ON;
	SET DEADLOCK_PRIORITY HIGH;

	declare @err_message nvarchar(2000);
	declare @current_step_name varchar(50);
	declare @current_boundary_value datetime2;
	declare @target_boundary_value datetime2; /* last day of new quarter */
	declare @current_time datetime2;
	declare @partition_boundary datetime2;
	--declare @pf_name varchar(125);
	--declare @ps_name varchar(125);
	declare @sql nvarchar(max);
	declare @params nvarchar(max);
	declare @crlf nchar(2);
	declare @tab nchar(1);
	set @crlf = nchar(13)+nchar(10);
	set @tab = nchar(9);

	if @verbose > 0
		print 'Validate parameters..'

	if @step is not null and @step not in (	'add_partition_datetime2_hourly_old','add_partition_datetime2_hourly','add_partition_datetime2_daily',
											'add_partition_datetime2_monthly','add_partition_datetime2_quarterly',
											'add_partition_datetime_hourly_old','add_partition_datetime_hourly','add_partition_datetime_daily',
											'add_partition_datetime_monthly','add_partition_datetime_quarterly',
											--
											'remove_partition_datetime2_hourly_old','remove_partition_datetime2_hourly','remove_partition_datetime2_daily',
											'remove_partition_datetime2_monthly','remove_partition_datetime2_quarterly',
											'remove_partition_datetime_hourly_old','remove_partition_datetime_hourly','remove_partition_datetime_daily',
											'remove_partition_datetime_monthly','remove_partition_datetime_quarterly')
		raiserror ('@step parameter value not valid', 20, -1) with log;

	set @current_step_name = 'add_partition_datetime2_hourly_old'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when sysdatetime() > sysutcdatetime() then sysdatetime() else sysutcdatetime() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +2, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba] partition scheme';
			select top 1 @current_boundary_value = convert(datetime2,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba' and ps.name = 'ps_dba'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime2));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime2';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(hour,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);

				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime2_hourly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime2_hourly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when sysdatetime() > sysutcdatetime() then sysdatetime() else sysutcdatetime() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +2, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime2_hourly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime2,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime2_hourly' and ps.name = 'ps_dba_datetime2_hourly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime2));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime2_hourly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime2_hourly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime2';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(hour,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);

				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime2_daily'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime2_daily') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when sysdatetime() > sysutcdatetime() then sysdatetime() else sysutcdatetime() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +4, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime2_daily] partition scheme';
			select top 1 @current_boundary_value = convert(datetime2,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime2_daily' and ps.name = 'ps_dba_datetime2_daily'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime2));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime2_daily next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime2_daily() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime2';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(DAY,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);

				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime2_monthly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime2_monthly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when sysdatetime() > sysutcdatetime() then sysdatetime() else sysutcdatetime() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +4, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime2_monthly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime2,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime2_monthly' and ps.name = 'ps_dba_datetime2_monthly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime2));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end
			
			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime2_monthly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime2_monthly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime2';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,1,@current_boundary_value)), 0);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime2_quarterly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime2_quarterly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when sysdatetime() > sysutcdatetime() then sysdatetime() else sysutcdatetime() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +6, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime2_quarterly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime2,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime2_quarterly' and ps.name = 'ps_dba_datetime2_quarterly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime2));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end
			
			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime2_quarterly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime2_quarterly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime2';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,3,@current_boundary_value)), 0);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime_hourly_old'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when getdate() > getutcdate() then getdate() else getutcdate() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +2, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime] partition scheme';
			select top 1 @current_boundary_value = convert(datetime,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime' and ps.name = 'ps_dba_datetime'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(hour,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime_hourly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime_hourly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when getdate() > getutcdate() then getdate() else getutcdate() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +2, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime_hourly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime_hourly' and ps.name = 'ps_dba_datetime_hourly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime_hourly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime_hourly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(hour,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime_daily'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime_daily') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when getdate() > getutcdate() then getdate() else getutcdate() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +4, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime_daily] partition scheme';
			select top 1 @current_boundary_value = convert(datetime,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime_daily' and ps.name = 'ps_dba_datetime_daily'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end

			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime_daily next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime_daily() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(DAY,1,@current_boundary_value);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime_monthly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime_monthly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when getdate() > getutcdate() then getdate() else getutcdate() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +4, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime_monthly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime_monthly' and ps.name = 'ps_dba_datetime_monthly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end
			
			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime_monthly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime_monthly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,1,@current_boundary_value)), 0);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'add_partition_datetime_quarterly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_schemes ps where ps.name = 'ps_dba_datetime_quarterly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try
			set @current_time = (case when getdate() > getutcdate() then getdate() else getutcdate() end);
			set @target_boundary_value = DATEADD (dd, -1, DATEADD(qq, DATEDIFF(qq, 0, @current_time) +6, 0));

			if @verbose > 0
				print @tab+'Checking @current_boundary_value for [ps_dba_datetime_quarterly] partition scheme';
			select top 1 @current_boundary_value = convert(datetime,prv.value)
			from sys.partition_range_values prv
			join sys.partition_functions pf on pf.function_id = prv.function_id
			join sys.partition_schemes as ps on ps.function_id = pf.function_id
			where pf.name = 'pf_dba_datetime_quarterly' and ps.name = 'ps_dba_datetime_quarterly'
			order by prv.value desc;

			if(@current_boundary_value is null or @current_boundary_value < @current_time )
			begin
				print @tab+'Warning - @current_boundary_value is NULL or its previous to current time.';
				set @current_boundary_value = dateadd(hour,datediff(hour,convert(date,@current_time),@current_time),cast(convert(date,@current_time)as datetime));
				if (@current_step_name not like '%hourly') -- convert to 12:00 am time
					set @current_boundary_value = convert(date,@current_boundary_value)
			end
			
			if @verbose > 0
			begin
				print @tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end

			if (@current_boundary_value < @target_boundary_value)
			begin
				set @sql =	N'alter partition scheme ps_dba_datetime_quarterly next used [PRIMARY];'+@crlf+
							N'alter partition function pf_dba_datetime_quarterly() split range (@current_boundary_value);';
				set @params = N'@current_boundary_value datetime';

				if @verbose > 0
				begin
					print @tab+'Start loop if (@current_boundary_value < @target_boundary_value)..';
					print @crlf+'declare '+@params+';';
					print @sql+@crlf+@crlf;
				end
			end
			else
			begin
				if @verbose > 0
					print @tab+'No action required in this step.';
			end

			while (@current_boundary_value < @target_boundary_value)
			begin
				set @current_boundary_value = DATEADD(month, DATEDIFF(month, 0, DATEADD(MONTH,3,@current_boundary_value)), 0);
				if @verbose > 0
					print @tab+@tab+'@current_boundary_value = '+ convert(varchar,@current_boundary_value,120);				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @current_boundary_value;
				else
					print @tab+@tab+'DRY RUN: add partition boundary..'
			end
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime2_hourly_old'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@hourly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@hourly_retention_days = '+ convert(varchar,@hourly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba' and ps.name = 'ps_dba'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime2_hourly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime2_hourly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@hourly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@hourly_retention_days = '+ convert(varchar,@hourly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime2_hourly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime2_hourly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime2_hourly' and ps.name = 'ps_dba_datetime2_hourly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime2_daily'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime2_daily') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@daily_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@daily_retention_days = '+ convert(varchar,@daily_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime2_daily() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime2_daily] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime2_daily' and ps.name = 'ps_dba_datetime2_daily'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime2_monthly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime2_monthly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@monthly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@monthly_retention_days = '+ convert(varchar,@monthly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime2_monthly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime2_monthly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime2_monthly' and ps.name = 'ps_dba_datetime2_monthly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime2_quarterly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime2_quarterly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@quarterly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@quarterly_retention_days = '+ convert(varchar,@quarterly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime2_quarterly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime2_quarterly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime2_quarterly' and ps.name = 'ps_dba_datetime2_quarterly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime_hourly_old'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@hourly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@hourly_retention_days = '+ convert(varchar,@hourly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime' and ps.name = 'ps_dba_datetime'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime_hourly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime_hourly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@hourly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@hourly_retention_days = '+ convert(varchar,@hourly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime_hourly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime_hourly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime_hourly' and ps.name = 'ps_dba_datetime_hourly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime_daily'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime_daily') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@daily_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@daily_retention_days = '+ convert(varchar,@daily_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime_daily() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime_daily] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime_daily' and ps.name = 'ps_dba_datetime_daily'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime_monthly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime_monthly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@monthly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@monthly_retention_days = '+ convert(varchar,@monthly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime_monthly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime_monthly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime_monthly' and ps.name = 'ps_dba_datetime_monthly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	set @current_step_name = 'remove_partition_datetime_quarterly'
	if ( (@step is null or @step = @current_step_name) and exists (select * from sys.partition_functions pf where pf.name = 'pf_dba_datetime_quarterly') )
	begin
		if @verbose > 0
			print @crlf+'@current_step_name = '+quotename(@current_step_name,'''');
		begin try			
			set @target_boundary_value = DATEADD(DAY,-@quarterly_retention_days,GETDATE());

			if @verbose > 0
			begin
				print @tab+'@quarterly_retention_days = '+ convert(varchar,@quarterly_retention_days);
				print @tab+'@target_boundary_value = '+ convert(varchar,@target_boundary_value,120);
			end
			
			set @sql =	N'alter partition function pf_dba_datetime_quarterly() merge range (@partition_boundary);';
			set @params = N'@partition_boundary datetime2';

			if @verbose > 0
			begin
				print @tab+'Get [pf_dba_datetime_quarterly] partitions less than @target_boundary_value & open Cursor..';
				print @crlf+'declare '+@params+';';
				print @sql+@crlf+@crlf;
			end

			declare cur_boundaries cursor local fast_forward for
					select convert(datetime2,prv.value) as boundary_value
					from sys.partition_range_values prv
					join sys.partition_functions pf on pf.function_id = prv.function_id
					join sys.partition_schemes as ps on ps.function_id = pf.function_id
					where pf.name = 'pf_dba_datetime_quarterly' and ps.name = 'ps_dba_datetime_quarterly'
						and convert(datetime2,prv.value) < @target_boundary_value
					order by prv.value asc;

			open cur_boundaries;
			fetch next from cur_boundaries into @partition_boundary;
			while @@FETCH_STATUS = 0
			begin
				if @verbose > 0
					print @tab+@tab+'@partition_boundary = '+ convert(varchar,@partition_boundary,120);
				
				set @sql = '/* usp_partition_maintenance */ '+@sql;
				if @dry_run = 0
					exec sp_executesql @sql, @params, @partition_boundary;
				else
					print @tab+@tab+'DRY RUN: remove partition boundary..'

				fetch next from cur_boundaries into @partition_boundary;
			end
			close cur_boundaries
			deallocate cur_boundaries;
		end try
		begin catch
			set @err_message = isnull(@err_message,'') + char(10) + 'Error in step ['+@current_step_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
	end


	if @err_message is not null
    raiserror (@err_message, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_purge_tables
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_purge_tables
	@verbose tinyint = 0,
	@dry_run bit = 0
AS 
BEGIN

	/*
		Version:		1.0.1
		Date:			2022-10-01 - Parameterization

		EXEC dbo.usp_purge_tables @verbose = 2, @dry_run = 1;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	declare @c_table_name sysname;
	declare @c_date_key sysname;
	declare @c_retention_days smallint;
	declare @c_purge_row_size int;
	declare @_sql nvarchar(max);
	declare @_params nvarchar(max);
	declare @_err_message nvarchar(2000);
	declare @_crlf nchar(2);
	declare @_tab nchar(1);
	declare @_tables nvarchar(2000);

	set @_crlf = nchar(13)+nchar(10);
	set @_tab = nchar(9);
	

	if @verbose >= 2
	begin
		select running_query = 'dbo.purge_table', 
				is_existing = case when OBJECT_ID(table_name) is null then 0 else 1 end, 
				* 
		from dbo.purge_table 
		--where OBJECT_ID(table_name) is not null;
	end

	-- Find tables that do not exist
	select @_tables = coalesce(@_tables+','+@_crlf+@_tab+table_name,table_name)
	from dbo.purge_table where OBJECT_ID(table_name) is null;

	if @_tables is not null
		print 'WARNING:- Following tables do not exists.'+@_crlf+@_tab+@_tables+@_crlf+@_crlf;

	declare cur_purge_tables cursor local forward_only for
		select table_name, date_key, retention_days, purge_row_size 
		from dbo.purge_table where OBJECT_ID(table_name) is not null;

	open cur_purge_tables;
	fetch next from cur_purge_tables into @c_table_name, @c_date_key, @c_retention_days, @c_purge_row_size;

	while @@FETCH_STATUS = 0
	begin
		print 'Processing table '+@c_table_name;

		set @_params = N'@purge_row_size int, @retention_days smallint';

		--set quoted_identifier off;
		set @_sql = '
		DECLARE @r INT;
	
		SET @r = 1;
		while @r > 0
		begin
			/* dbo.usp_purge_tables */
			delete top (@purge_row_size) pt
			from '+@c_table_name+' pt
			where '+@c_date_key+' < dateadd(day,-@retention_days,cast(getdate() as date));

			set @r = @@ROWCOUNT;
		end
		'
		--set quoted_identifier on;
		begin try
			if @verbose > 0
				print @_crlf+@_tab+@_tab+'declare '+@_params+';'+@_crlf+@_sql+@_crlf;
			if @dry_run = 0
			begin
				exec sp_executesql @_sql, @_params, @c_purge_row_size, @c_retention_days;
				update dbo.purge_table set latest_purge_datetime = SYSDATETIME() where table_name = @c_table_name;
			end
		end try
		begin catch
			set @_err_message = isnull(@_err_message,'') + char(10) + 'Error while purging table '+@c_table_name+'.'+char(10)+ ERROR_MESSAGE()+char(10);
		end catch
		fetch next from cur_purge_tables into @c_table_name, @c_date_key, @c_retention_days, @c_purge_row_size;
	end
	close cur_purge_tables;
	deallocate cur_purge_tables;

	if @_err_message is not null
    raiserror (@_err_message, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_run_WhoIsActive
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_run_WhoIsActive
(	@drop_recreate bit = 0, /* Drop and recreate table */
	@destination_table VARCHAR(4000) = 'dbo.WhoIsActive', /* Destination table Name */
	@send_error_mail bit = 1, /* Send mail on failure */
	@threshold_continous_failure tinyint = 3, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 15, /* Send mail only after a gap of x minutes from last mail */ 
	@is_test_alert bit = 0, /* enable for alert testing */
	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Run-WhoIsActive', /* Subject of Failure Mail */
	@retention_day int = 15, /* No of days for data retention */
	@purge_flag bit = 1 /* When enabled, then based on @retention_day, old data would be purged */
)
AS 
BEGIN

	/*
		Version:		1.2.1
		Update:			2022-10-12 - Removed Staging Table Logic. Also removed computed columns to avoid single threaded search.
						2022-12-12 - Add @format_output = 0 to get numeric values instead of Human readable format

		EXEC dbo.usp_run_WhoIsActive @recipients = 'dba_team@gmail.com'
		EXEC dbo.usp_run_WhoIsActive @recipients = 'dba_team@gmail.com', @verbose = 2 ,@drop_recreate = 1
	
		Additional Requirements
		1) Default Global Mail Profile
			-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
		2) Make sure context database is set to correct dba database
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	/* Derived Parameters */
	--DECLARE @staging_table VARCHAR(4000) = @destination_table+'_Staging';

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	DECLARE @_output VARCHAR(8000);
	SET @_output = 'Declare local variables'+CHAR(10);
	-- Local Variables
	DECLARE @_rows_affected int = 0;
	DECLARE @_sqlString NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_columns VARCHAR(8000);
	DECLARE @_cpu_system int;
	DECLARE @_cpu_sql int;
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html  NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;
	DECLARE @_output_column_list VARCHAR(8000);
	DECLARE @_crlf nchar(2);
	DECLARE @_tab nchar(1);

	SET @_crlf = NCHAR(13)+NCHAR(10);
	SET @_tab = NCHAR(9);

	SET @_output_column_list = '[collection_time][dd hh:mm:ss.mss][session_id][program_name][login_name][database_name]
							[CPU][used_memory][open_tran_count][status][wait_info][sql_command]
							[blocked_session_count][blocking_session_id][sql_text][%]';

	IF @verbose > 0
		PRINT 'Dynamically fetch @_job_name ..'
	SET @_job_name = '(dba) '+@alert_key;

	IF @verbose > 0
	BEGIN
		PRINT '@destination_table => '+@destination_table;
		--PRINT '@staging_table => '+@staging_table;
	END

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	BEGIN TRY
		SET @_output += '<br>Start Try Block..'+CHAR(10);
		IF @verbose > 0
			PRINT 'Start Try Block..';

		-- Step 01: Create WhoIsActive table if not exists
		IF @verbose > 0
			PRINT 'Start Step 01: Create WhoIsActive table if not exists..';
		IF ( (OBJECT_ID(@destination_table) IS NULL) OR (@drop_recreate = 1))
		BEGIN
			SET @_output += '<br>Inside Step 01: Create WhoIsActive table if not exists..'+CHAR(10);
		
			IF (@drop_recreate = 1)
			BEGIN
				IF @verbose > 0
					PRINT @_tab+'Inside Step 01: Drop WhoIsActive table if exists..';
				SET @_sqlString = 'if object_id('''+@destination_table+''') is not null drop table '+@destination_table;
				IF @verbose > 1
					PRINT @_tab+@_sqlString;
				EXEC(@_sqlString)
			END

			IF @verbose > 0
				PRINT @_tab+'Inside Step 01: Create WhoIsActive table with @_output_column_list..';
			EXEC dbo.sp_WhoIsActive @get_outer_command=1, @get_task_info=2, @find_block_leaders=1, @get_plans=1, @get_avg_time=1, 
									@get_additional_info=1, @get_transaction_info=1, @get_memory_info = 1, @format_output = 0
									,@output_column_list = @_output_column_list
									,@return_schema = 1, @schema = @_sqlString OUTPUT; 
			SET @_sqlString = REPLACE(@_sqlString, '<table_name>', @destination_table) 
			IF @verbose > 1
				PRINT @_tab+@_sqlString;
			EXEC(@_sqlString)
		END
		ELSE
		BEGIN
			IF @verbose > 1
				PRINT @_tab+'Table '+@destination_table+' already exists.';
		END
		IF @verbose > 0
			PRINT 'End Step 01: Create WhoIsActive table if not exists..'+char(10);

		--	Step 02: Add Indexes& computed Columns
		IF @verbose > 0
			PRINT 'Start Step 02: Add Indexes & computed Columns..';
		IF NOT EXISTS (select * from sys.indexes i where i.type_desc = 'CLUSTERED' and i.object_id = OBJECT_ID(@destination_table))
		BEGIN
			SET @_output += '<br>Inside Step 02: Add Indexes & computed Columns..'+CHAR(10);

			IF @verbose > 0
				PRINT @_tab+'Inside Step 02: Add clustered index..';
			SET @_sqlString = 'CREATE CLUSTERED INDEX ci_'+SUBSTRING(@destination_table,CHARINDEX('.',@destination_table)+1,LEN(@destination_table))+' ON '+@destination_table+' ( [collection_time] ASC )';
			IF @verbose > 1
				PRINT @_tab+@_sqlString;
			EXEC (@_sqlString);
		END

		IF @verbose > 0
			PRINT 'End Step 02: Add Indexes & computed Columns..'+char(10);

		-- Step 03: Purge Old data
		IF @purge_flag = 1
		BEGIN
			IF @verbose > 0
				PRINT 'Start Step 03: Purge Old data..';
			SET @_output += '<br>Execute Step 03: Purge Old data..'+CHAR(10);
			SET @_sqlString = 'DELETE FROM '+@destination_table+' where collection_time < DATEADD(day,-'+cast(@retention_day as varchar)+',getdate());'
			IF @verbose > 1
				PRINT @_tab+@_sqlString;
			EXEC(@_sqlString);
			IF @verbose > 0
				PRINT 'End Step 03: Purge Old data..'+char(10);
		END

		-- Step 04: Populate WhoIsActive table
		IF @verbose > 0
			PRINT 'Start Step 04: Populate WhoIsActive table..';
		SET @_output += '<br>Execute Step 04: Populate WhoIsActive table..'+CHAR(10);
		EXEC dbo.sp_WhoIsActive @get_outer_command=1, @get_task_info=2, @find_block_leaders=1, @get_plans=1, @get_avg_time=1, 
								@get_additional_info=1, @get_transaction_info=1, @get_memory_info = 1, @format_output = 0
								,@output_column_list = @_output_column_list
								,@destination_table = @destination_table;
		SET @_rows_affected = ISNULL(@@ROWCOUNT,0);
		SET @_output += '<br>@_rows_affected is set from @@ROWCOUNT.'+CHAR(10);
		IF @verbose > 0
			PRINT 'End Step 04: Populate WhoIsActive table..'+char(10);
	
		-- Step 05: Return rows affected
		SET @_output += '<br>Execute Step 05: Return rows affected..'+CHAR(10);
		PRINT '[rows_affected] = '+CONVERT(varchar,ISNULL(@_rows_affected,0));
		SET @_output += '<br>FINISH. Script executed without error.'+CHAR(10);
		IF @verbose > 0
			PRINT 'End Step 05: Return rows affected. Script completed without error'
	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();

    declare @_product_version tinyint;
	  select @_product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT @_tab+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @_product_version IS NOT NULL
		BEGIN
			SET @_sqlString = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sqlString = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;

			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure
			' + char(10);
		END
		IF @verbose > 1
			PRINT @_tab+@_sqlString;
		INSERT #CommandLog
		EXEC sp_executesql @_sqlString, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT @_tab+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT @_tab+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Below is Job Output till now -><br><br>'+@_output+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+@_tab+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+@_tab+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_TempDbSaver
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_TempDbSaver]
(
	 @data_used_pct_threshold tinyint = 90,
	 @data_used_gb_threshold int = null,
	 @threshold_condition varchar(5) = 'or', /* {and | or} */
	 @kill_spids bit = 0,	 
	 @email_recipients varchar(max) = 'dba_team@gmail.com',
	 @send_email bit = 0,
	 @verbose tinyint = 0, /* 1 => messages, 2 => messages + table results */
	 @first_x_rows int = 10,
	 @drop_create_table bit = 0,
	 @retention_days int = 15,
	 @purge_table bit = 1
)
AS
BEGIN
	/*
		Purpose:		Detect and/or Kill sessions causing tempdb space utilization
		Modifications:	2023-Aug-10 - Initial Draft

		EXEC [dbo].[usp_TempDbSaver] @data_used_pct_threshold = 80, @data_used_gb_threshold = null, @kill_spids = 0, @verbose = 2, @first_x_rows = 10 -- Don't kill & Display all debug messages
		EXEC [dbo].[usp_TempDbSaver] @data_used_pct_threshold = 80, @data_used_gb_threshold = 500, @kill_spids = 1, @verbose = 0, @first_x_rows = 10 -- Kill & Avoid any messages

		declare @first_x_rows int = 10;
		select top 1 * from dbo.tempdb_space_usage order by collection_time desc;
		select * from dbo.tempdb_space_consumers order by collection_time desc, usage_rank asc
				offset 0 rows fetch next @first_x_rows rows only;

	*/
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET XACT_ABORT ON;

	IF @data_used_pct_threshold IS NULL AND @data_used_gb_threshold IS NULL
		THROW 51000, '@data_used_pct_threshold or @data_used_gb_threshold must be provided.', 1;
	IF @threshold_condition NOT IN ('and','or')
		THROW 51000, 'Expected value for @threshold_condition are {and || or} only.', 1;

	DECLARE @_start_time datetime2;
	SET @_start_time = SYSDATETIME();

	DECLARE @_sql nvarchar(max) = ''; 
	DECLARE @_sql_kill nvarchar(max);
	DECLARE @_params nvarchar(max);
	DECLARE @_email_body varchar(max) = null;
	DECLARE @_email_subject nvarchar(255) = 'Tempdb Saver: ' + @@SERVERNAME;
	DECLARE @_data_used_pct_current decimal(5,2);
	DECLARE @_is_pct_threshold_valid bit = 0;
	DECLARE @_is_gb_threshold_valid bit = 0;
	DEclare @_thresholds_validated bit = 0;

	SET @_params = N'@collection_time datetime2';

	DECLARE @t_login_exceptions TABLE (login_name sysname);
	/*
	INSERT @t_login_exceptions
	VALUES ('sa'),
			('NT AUTHORITY\SYSTEM');
	*/

	IF (@verbose > 0)
		PRINT '('+convert(varchar, getdate(), 21)+') Creating table variable @t_tempdb_consumers..';
	DECLARE @t_tempdb_consumers TABLE
	(
		[collection_time] [datetime2] NOT NULL,
		[spid] [smallint] NULL,
		[login_name] [nvarchar](128) NOT NULL,
		[program_name] [nvarchar](128) NULL,
		[host_name] [nvarchar](128) NULL,
		[host_process_id] [int] NULL,
		[is_active_session] [int] NOT NULL,
		[open_transaction_count] [int] NOT NULL,
		[transaction_isolation_level] [varchar](15) NULL,
		[size_bytes] [bigint] NULL,
		[transaction_begin_time] [datetime] NULL,
		[is_snapshot] [int] NOT NULL,
		[log_bytes] [bigint] NULL,
		[log_rsvd] [bigint] NULL,
		[action_taken] [varchar](200) NULL
	);
	
	IF @drop_create_table = 1 AND OBJECT_ID('dbo.tempdb_space_usage') IS NOT NULL
		EXEC ('drop table dbo.tempdb_space_usage;');

	IF OBJECT_ID('dbo.tempdb_space_usage') IS NULL
	BEGIN
		SET @_sql = '
		CREATE TABLE dbo.tempdb_space_usage
		(	[collection_time] datetime2 not null,
			[data_size_mb] varchar(100) not null,
			[data_used_mb] varchar(100) not null, 
			[data_used_pct] decimal(5,2) not null, 
			[log_size_mb] varchar(100) not null,
			[log_used_mb] varchar(100) null,
			[log_used_pct] decimal(5,2) null,
			[version_store_mb] decimal(20,2) null,
			[version_store_pct] decimal(20,2) null
		);
		create unique clustered index CI_tempdb_space_usage on dbo.tempdb_space_usage (collection_time);
		'
		IF (@verbose > 0)
		BEGIN
			PRINT '('+convert(varchar, getdate(), 21)+') Creating table dbo.tempdb_space_usage..'+CHAR(10)+CHAR(13);
			PRINT @_sql;
		END

		EXEC (@_sql)
	END

	IF @drop_create_table = 1 AND OBJECT_ID('dbo.tempdb_space_consumers') IS NOT NULL
		EXEC ('drop table dbo.tempdb_space_consumers;');

	IF OBJECT_ID('dbo.tempdb_space_consumers') IS NULL
	BEGIN
		SET @_sql = '
		CREATE TABLE dbo.tempdb_space_consumers
		(
			 collection_time datetime2 not null,
			 usage_rank tinyint not null,
			 spid int not null,
			 login_name sysname not null,
			 program_name sysname NULL,
			 host_name sysname NULL,
			 host_process_id int null,
			 is_active_session int null,
			 open_transaction_count int null,
			 transaction_isolation_level varchar(15) null,
			 size_bytes bigint null,
			 [transaction_begin_time] [datetime] NULL,
			 [is_snapshot] [int] NOT NULL,
			 [log_bytes] [bigint] NULL,
			 [log_rsvd] [bigint] NULL,
			 action_taken varchar(100) null
		);
		create unique clustered index CI_tempdb_space_consumers on dbo.tempdb_space_consumers (collection_time, usage_rank);
		'
		IF (@verbose > 0)
		BEGIN
			PRINT '('+convert(varchar, getdate(), 21)+') Creating table dbo.tempdb_space_consumers..'+CHAR(10)+CHAR(13);
			PRINT @_sql;
		END

		EXEC (@_sql)
	END

	IF (@verbose > 0)
		PRINT '('+convert(varchar, getdate(), 21)+') Populate table dbo.tempdb_space_usage..'
		
	SET @_sql = '
		use tempdb ;

		;with t_files_size as (
			select	[file_type] = f.type_desc,
					[size_mb] = convert(numeric(10,2), (f.size*8.0)/1024 ),
					[used_mb] = convert(numeric(10,2), CAST(FILEPROPERTY(f.name, ''SpaceUsed'') as int)/128.0 )
			from sys.database_files f left join sys.filegroups fg on fg.data_space_id = f.data_space_id
		)
		,t_files_by_type as (
			select	[data_size_mb] = case when file_type = ''ROWS'' then [size_mb] else 0.0 end,
					[data_used_mb] = case when file_type = ''ROWS'' then [used_mb] else 0.0 end,
					[log_size_mb] = case when file_type = ''LOG'' then [size_mb] else 0.0 end,
					[log_used_mb] = case when file_type = ''LOG'' then [used_mb] else 0 end,
					vs.[version_store_mb]
			from t_files_size fs
			full outer join (	SELECT [version_store_mb] = (SUM(version_store_reserved_page_count) / 128.0)	
								FROM tempdb.sys.dm_db_file_space_usage fsu with (nolock)
							) vs
				on 1=1
		)
		select	[collection_time] = @collection_time,
				[data_size_mb] = sum([data_size_mb]),
				[data_used_mb] = sum([data_used_mb]),
				[data_used_pct] = convert(numeric(12,2),sum([data_used_mb])*100.0/(sum([data_size_mb]))),
				[log_size_mb] = sum([log_size_mb]),
				[log_used_mb] = sum([log_used_mb]),
				[log_used_pct] = convert(numeric(12,2),sum([log_used_mb])*100.0/(sum([log_size_mb]))),
				[version_store_mb] = max([version_store_mb]),
				[version_store_pct] = convert(numeric(12,2),max([version_store_mb])*100.0/sum([data_used_mb]))
		from t_files_by_type; ';

	IF (@verbose > 0)
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') Insert dbo.tempdb_space_usage..'+CHAR(10)+CHAR(13);
		PRINT @_sql;
	END

	INSERT INTO dbo.tempdb_space_usage
	([collection_time], data_size_mb, data_used_mb, data_used_pct, log_size_mb, log_used_mb, log_used_pct, version_store_mb, version_store_pct)
	EXEC sp_executesql @_sql, @_params, @collection_time = @_start_time;

	IF (@verbose >= 2)
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') select * from dbo.tempdb_space_usage..'
		select top 1 running_query, t.*
		from dbo.tempdb_space_usage t
		full outer join (values ('dbo.tempdb_space_usage') )dummy(running_query) on 1 = 1
		where t.collection_time = @_start_time;
	END	

	IF (@verbose > 0)
		PRINT '('+convert(varchar, getdate(), 21)+') Populate table @t_tempdb_consumers..'	
	SET @_sql = '
	;WITH T_SnapshotTran
	AS (	
		SELECT	[s_tst].[session_id], --DB_NAME(s_tdt.database_id) as database_name,
				[begin_time] = ISNULL(MIN([s_tdt].[database_transaction_begin_time]),MIN(DATEADD(SECOND,-snp.elapsed_time_seconds,GETDATE()))),
				--[database_transaction_begin_time] = MIN([s_tdt].[database_transaction_begin_time]),
				--[database_transaction_begin_time2] = MIN(DATEADD(SECOND,-snp.elapsed_time_seconds,GETDATE())),
				SUM([s_tdt].[database_transaction_log_bytes_used]) AS [log_bytes],
				SUM([s_tdt].[database_transaction_log_bytes_reserved]) AS [log_rsvd],
				MAX(CASE WHEN snp.elapsed_time_seconds IS NOT NULL THEN 1 ELSE 0 END) AS is_snapshot
		FROM sys.dm_tran_database_transactions [s_tdt]
		JOIN sys.dm_tran_session_transactions [s_tst]
			ON [s_tst].[transaction_id] = [s_tdt].[transaction_id]
		LEFT JOIN sys.dm_tran_active_snapshot_database_transactions snp
			ON snp.session_id = s_tst.session_id AND snp.transaction_id = s_tst.transaction_id
		--WHERE s_tdt.database_id = 2
		GROUP BY [s_tst].[session_id] --,s_tdt.database_id
	)
	,T_TempDbTrans AS 
	(
		SELECT	[collection_time] = @collection_time,
				[spid] = des.session_id,
				[login_name] = des.original_login_name,  
				--des.program_name,
				[program_name] = CASE	WHEN	des.program_name like ''SQLAgent - TSQL JobStep %''
					THEN	(	select	top 1 ''SQL Job = ''+j.name 
								from msdb.dbo.sysjobs (nolock) as j
								inner join msdb.dbo.sysjobsteps (nolock) AS js on j.job_id=js.job_id
								where right(cast(js.job_id as nvarchar(50)),10) = RIGHT(substring(des.program_name,30,34),10) 
							) + '' ( ''+SUBSTRING(LTRIM(RTRIM(des.program_name)), CHARINDEX('': Step '',LTRIM(RTRIM(des.program_name)))+2,LEN(LTRIM(RTRIM(des.program_name)))-CHARINDEX('': Step '',LTRIM(RTRIM(des.program_name)))-2)+'' )'' collate SQL_Latin1_General_CP1_CI_AS
					ELSE	des.program_name
					END,
				des.host_name,
				des.host_process_id,
				[is_active_session] = CASE WHEN er.request_id IS NOT NULL THEN 1 ELSE 0 END,
				des.open_transaction_count,
				[transaction_isolation_level] = (CASE des.transaction_isolation_level 
						WHEN 0 THEN ''Unspecified''
						WHEN 1 THEN ''ReadUncommitted''
						WHEN 2 THEN ''ReadCommitted''
						WHEN 3 THEN ''Repeatable''
						WHEN 4 THEN ''Serializable'' 
						WHEN 5 THEN ''Snapshot'' END ),
				[size_bytes] = ((ssu.user_objects_alloc_page_count+ssu.internal_objects_alloc_page_count)-(ssu.internal_objects_dealloc_page_count+ssu.user_objects_dealloc_page_count))*8192,
				[transaction_begin_time] = case when des.open_transaction_count > 0 then (case when ott.begin_time is not null then ott.begin_time when er.start_time is not null then er.start_time else des.last_request_start_time end) else er.start_time end,
				[is_snapshot] = CASE WHEN ISNULL(ott.is_snapshot,0) = 1 THEN 1
									 WHEN tasdt.is_snapshot = 1 THEN 1
									 ELSE ISNULL(ott.is_snapshot,0)
									 END,
				ott.[log_bytes], ott.log_rsvd,
				CONVERT(varchar(200),NULL) AS action_taken
		FROM       sys.dm_exec_sessions des
		LEFT JOIN sys.dm_db_session_space_usage ssu on ssu.session_id = des.session_id
		LEFT JOIN T_SnapshotTran ott ON ott.session_id = ssu.session_id
		LEFT JOIN sys.dm_exec_requests er ON er.session_id = des.session_id
		OUTER APPLY (SELECT ( (tsu.user_objects_alloc_page_count+tsu.internal_objects_alloc_page_count)-(tsu.user_objects_dealloc_page_count+tsu.internal_objects_dealloc_page_count) )*8192 AS size_bytes 
					FROM sys.dm_db_task_space_usage tsu 
					WHERE ((tsu.user_objects_alloc_page_count+tsu.internal_objects_alloc_page_count)-(tsu.user_objects_dealloc_page_count+tsu.internal_objects_dealloc_page_count)) > 0
						AND tsu.session_id = er.session_id
					) as ra
		OUTER APPLY (select 1 as [is_snapshot] from sys.dm_tran_active_snapshot_database_transactions asdt where asdt.session_id = des.session_id) as tasdt
		WHERE des.session_id <> @@SPID --AND (er.request_id IS NOT NULL OR des.open_transaction_count > 0)
			--AND ssu.database_id = 2
	)
	SELECT top (@first_x_rows) *
	FROM T_TempDbTrans ot
	WHERE 1=1
	and ot.[spid] >= 50
	and (size_bytes > 0 OR is_active_session = 1 OR open_transaction_count > 0 OR  is_snapshot = 1)
	'
	IF EXISTS (SELECT * FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and s.version_store_pct >= 30)
	BEGIN
		--SET @_sql = @_sql + 'and is_snapshot = 1'+CHAR(10)
		SET @_sql = @_sql + 'order by is_snapshot DESC, (case when transaction_begin_time is null then dateadd(day,1,getdate()) else transaction_begin_time end ) ASC, size_bytes desc;'+CHAR(10)
	END
	ELSE
		SET @_sql = @_sql + 'order by size_bytes desc;'+CHAR(10)
	
	IF (@verbose > 1)
		PRINT @_sql

	SET @_params = N'@collection_time datetime2, @first_x_rows int';
	INSERT @t_tempdb_consumers
	EXEC sp_executesql @_sql, @_params, @collection_time = @_start_time, @first_x_rows = @first_x_rows;

	IF (@verbose > 1)
	BEGIN
		PRINT '('+convert(varchar, getdate(), 21)+') select * from @t_tempdb_consumers..'
		
		IF EXISTS (SELECT * FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and s.version_store_pct >= 30)
			select running_query, t.*
			from @t_tempdb_consumers t
			full outer join (values ('@t_tempdb_consumers') )dummy(running_query) on 1 = 1
			order by is_snapshot DESC, transaction_begin_time ASC;
		ELSE
			select running_query, t.* --top (@first_x_rows) 
			from @t_tempdb_consumers t
			full outer join (values ('@t_tempdb_consumers') )dummy(running_query) on 1 = 1
			order by size_bytes desc;
	END

	IF @data_used_pct_threshold IS NOT NULL AND EXISTS (SELECT 1/0 FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and data_used_pct > @data_used_pct_threshold)
		SET @_is_pct_threshold_valid = 1;
	IF @data_used_gb_threshold IS NOT NULL AND EXISTS (SELECT 1/0 FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and data_used_mb > (@data_used_gb_threshold*1024.0))
		SET @_is_gb_threshold_valid = 1;
	SET @_thresholds_validated = (CASE	WHEN @threshold_condition = 'and' and (@_is_pct_threshold_valid = 1 and @_is_gb_threshold_valid = 1) THEN 1
										WHEN @threshold_condition = 'or' and (@_is_pct_threshold_valid = 1 OR @_is_gb_threshold_valid = 1) THEN 1
										ELSE 0
										END);

	IF @verbose >= 1
	BEGIN
		SELECT	[@data_used_pct_threshold] = @data_used_pct_threshold, 
				[@_is_pct_threshold_valid] = @_is_pct_threshold_valid,
				[@data_used_gb_threshold] = @data_used_gb_threshold,
				[@_is_gb_threshold_valid] = @_is_gb_threshold_valid, 
				[@_thresholds_validated] = @_thresholds_validated,
				[@threshold_condition] = @threshold_condition;
	END

	IF @verbose > 0
		PRINT '('+convert(varchar, getdate(), 21)+') Validate @_thresholds_validated, and take action..'	
	IF @_thresholds_validated = 1
	BEGIN
		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Found @_thresholds_validated to be true.'
			
		IF EXISTS (SELECT * FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and s.version_store_pct >= 30) -- If Version Store Issue
		BEGIN
			IF @verbose > 0
			BEGIN
				PRINT '('+convert(varchar, getdate(), 21)+') Version Store Issue.';
				PRINT '('+convert(varchar, getdate(), 21)+') version_store_mb >= 30% of data_used_mb';
				PRINT '('+convert(varchar, getdate(), 21)+') Pick top spid (@_sql_kill) order by ''ORDER BY is_snapshot DESC, transaction_begin_time ASC''';
			END
			SELECT TOP 1 @_sql_kill = CONVERT(varchar(30), tu.spid)
			FROM	@t_tempdb_consumers tu
			WHERE   host_process_id IS NOT NULL
			AND     login_name NOT IN (SELECT ex.login_name FROM @t_login_exceptions ex)
			ORDER BY is_snapshot DESC, transaction_begin_time ASC;
		END
		ELSE
		BEGIN -- Not Version Store issue.
			IF @verbose > 0
			BEGIN
				PRINT '('+convert(varchar, getdate(), 21)+') Not Version Store Issue.';
				PRINT '('+convert(varchar, getdate(), 21)+') version_store_mb < 30% of data_used_mb';
				PRINT '('+convert(varchar, getdate(), 21)+') Pick top spid (@_sql_kill) order by ''(ISNULL(size_bytes,0)+ISNULL(log_bytes,0)+ISNULL(log_rsvd,0)) DESC''';
			END
			SELECT TOP 1 @_sql_kill = CONVERT(varchar(30), tu.spid)
			FROM @t_tempdb_consumers tu
			WHERE         host_process_id IS NOT NULL
			AND         login_name NOT IN (SELECT ex.login_name FROM @t_login_exceptions ex)
			AND size_bytes <> 0
			ORDER BY (ISNULL(size_bytes,0)+ISNULL(log_bytes,0)+ISNULL(log_rsvd,0)) DESC;
		END
		

		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Top tempdb consumer spid (@_sql_kill) = '+@_sql_kill;
  
		IF (@_sql_kill IS NOT NULL)
		BEGIN
			IF (@kill_spids = 1)
			BEGIN
				IF @verbose > 0
					PRINT '('+convert(varchar, getdate(), 21)+') Kill top consumer.';
				UPDATE @t_tempdb_consumers SET action_taken = 'Process Terminated' WHERE spid = @_sql_kill
				SET @_sql = 'kill ' + @_sql_kill;
				PRINT (@_sql);
				EXEC (@_sql);
				IF @verbose > 0
					PRINT '('+convert(varchar, getdate(), 21)+') Update @t_tempdb_consumers with action_taken ''Process Terminated''.';
			END
			ELSE
			BEGIN
				UPDATE @t_tempdb_consumers SET action_taken = 'Notified DBA' WHERE spid = @_sql_kill
				IF @verbose > 0
					PRINT '('+convert(varchar, getdate(), 21)+') Update @t_tempdb_consumers with action_taken ''Notified DBA''.';
			END;

			SET @_email_body = 'The following SQL Server process ' + CASE WHEN @kill_spids = 1 THEN 'was' ELSE 'is' END + ' consuming the most tempdb space.' + CHAR(10) + CHAR(10)
			SELECT @_data_used_pct_current = data_used_pct FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time;
			SELECT @_email_body = @_email_body + 
								'      date_time: ' + CONVERT(varchar(100), collection_time, 121) + CHAR(10) + 
								'tempdb_used_pct: ' + CONVERT(varchar(100), @_data_used_pct_current) + CHAR(10) +
								'           spid: ' + CONVERT(varchar(30), spid) + CHAR(10) +
								'     login_name: ' + login_name + CHAR(10) +
								'   program_name: ' + ISNULL(program_name, '') + CHAR(10) +
								'      host_name: ' + ISNULL(host_name, '') + CHAR(10) +
								'host_process_id: ' + CONVERT(varchar(30), host_process_id) + CHAR(10) +
								'      is_active: ' + CONVERT(varchar(30), is_active_session) + CHAR(10) +
								'     tran_count: ' + CONVERT(varchar(30), open_transaction_count) + CHAR(10) +
								'    is_snapshot: ' + CONVERT(varchar(30), is_snapshot) + CHAR(10) +
								'tran_start_time: ' + (case when transaction_begin_time is null then '' else CONVERT(varchar(100), transaction_begin_time, 121) end) + CHAR(10) + 
								'   action_taken: ' + action_taken + CHAR(10) + CHAR(10)
			FROM   @t_tempdb_consumers tu
			WHERE spid = @_sql_kill;

			PRINT @_email_body
			If(@send_email =1)
			BEGIN
				EXEC msdb.dbo.sp_send_dbmail  
					@recipients =  @email_recipients,  
					@subject =     @_email_subject,  
					@body =        @_email_body,
				@body_format = 'TEXT'
			END
		END;

		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Populate table dbo.tempdb_space_consumers with top 10 session details.';
		IF EXISTS (SELECT * FROM dbo.tempdb_space_usage s WHERE s.collection_time = @_start_time and s.version_store_pct >= 30)
		BEGIN
			INSERT INTO dbo.tempdb_space_consumers 
			([collection_time], [spid], [login_name], [program_name], [host_name], [host_process_id], [is_active_session], [open_transaction_count], [transaction_isolation_level], [size_bytes], [transaction_begin_time], [is_snapshot], [log_bytes], [log_rsvd], [action_taken], [usage_rank])
			SELECT [collection_time], [spid], [login_name], [program_name], [host_name], [host_process_id], [is_active_session], [open_transaction_count], [transaction_isolation_level], [size_bytes], [transaction_begin_time], [is_snapshot], [log_bytes], [log_rsvd], [action_taken], 
					[usage_rank] = ROW_NUMBER()over(order by collection_time, is_snapshot DESC, (case when transaction_begin_time is null then dateadd(day,1,getdate()) else transaction_begin_time end) ASC)
			FROM  @t_tempdb_consumers 
			order by collection_time, is_snapshot DESC, (case when transaction_begin_time is null then dateadd(day,1,getdate()) else transaction_begin_time end) ASC, [size_bytes] desc, [log_rsvd] desc
			offset 0 rows fetch next @first_x_rows rows only;
			
		END
		ELSE
			INSERT INTO dbo.tempdb_space_consumers 
			([collection_time], [spid], [login_name], [program_name], [host_name], [host_process_id], [is_active_session], [open_transaction_count], [transaction_isolation_level], [size_bytes], [transaction_begin_time], [is_snapshot], [log_bytes], [log_rsvd], [action_taken], [usage_rank])
			SELECT [collection_time], [spid], [login_name], [program_name], [host_name], [host_process_id], [is_active_session], [open_transaction_count], [transaction_isolation_level], [size_bytes], [transaction_begin_time], [is_snapshot], [log_bytes], [log_rsvd], [action_taken], 
					[usage_rank] = ROW_NUMBER()over(order by collection_time, size_bytes DESC)
			FROM  @t_tempdb_consumers 
			order by collection_time, size_bytes DESC
			offset 0 rows fetch next @first_x_rows rows only;
	END;
	ELSE
	BEGIN
		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Current tempdb space usage under threshold.'
	END

	IF (@purge_table = 1)
	BEGIN
		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Purge dbo.tempdb_space_consumers with @retention_days = '+convert(varchar,@retention_days);
		DELETE FROM dbo.tempdb_space_consumers WHERE collection_time <= DATEADD(day, -@retention_days, GETDATE());

		IF @verbose > 0
			PRINT '('+convert(varchar, getdate(), 21)+') Purge dbo.tempdb_space_usage with @retention_days = '+convert(varchar,@retention_days);
		DELETE FROM dbo.tempdb_space_usage WHERE collection_time <= DATEADD(day, -@retention_days, GETDATE());
	END

	--if @_email_body != null
	--begin
	--	SELECT @_email_body as Body
	--end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_waits_per_core_per_minute
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_waits_per_core_per_minute
	@waits_seconds__per_core_per_minute decimal(20,2) = -1.0 output,
	@snapshot_interval_minutes int = 5,
	@verbose tinyint = 0
--WITH RECOMPILE, EXECUTE AS OWNER 
AS 
BEGIN

	/*
		Version:		1.6.4
		Modifications:	2022-11-26 - Initial Draft
						2023-08-29 - Fix Divide by Zero Error
						2023-12-30 - #21 - Add exception for some waits through Wait Stats table

		declare @waits_seconds__per_core_per_minute bigint;
		exec usp_waits_per_core_per_minute @waits_seconds__per_core_per_minute = @waits_seconds__per_core_per_minute output;
		select [waits_seconds__per_core_per_minute] = @waits_seconds__per_core_per_minute;
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 30000; -- 30 seconds
	
	DECLARE @passed_waits_seconds__per_core_per_minute smallint = @waits_seconds__per_core_per_minute;

	declare @schedulers smallint;
	select @schedulers = count(*) from sys.dm_os_schedulers where status = 'VISIBLE ONLINE' and is_online = 1;
	if @verbose >= 1
		print '@schedulers = '+convert(varchar,@schedulers);

	declare @collect_time_utc_snap1 datetime2;
	declare @collect_time_utc_snap2 datetime2;

	select top 1 @collect_time_utc_snap2 = collection_time_utc
	from dbo.wait_stats s
	order by collection_time_utc desc;

	select top 1 @collect_time_utc_snap1 = collection_time_utc
	from dbo.wait_stats s where collection_time_utc < dateadd(minute,-@snapshot_interval_minutes,@collect_time_utc_snap2) -- 2 snapshots with a gap
	order by collection_time_utc desc;

	if @verbose >= 1
	begin
		print '@collect_time_utc_snap1 = '+convert(varchar,@collect_time_utc_snap1,121);
		print '@collect_time_utc_snap2 = '+convert(varchar,@collect_time_utc_snap2,121);
	end

	--select @collect_time_utc_snap1, @collect_time_utc_snap2;

	if @verbose >= 1
		print 'Compute delta wait stats..'
	;with wait_snap1 as (
		select sum(wait_time_ms)/1000 as wait_time_s
		from dbo.wait_stats s1
		where s1.collection_time_utc = @collect_time_utc_snap1
		and [wait_type] NOT IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc where coalesce(wc.IgnorableOnPerCoreMetric,wc.Ignorable,0) = 1 )
		AND [waiting_tasks_count] > 0
	)
	,wait_snap2 as (
		select sum(wait_time_ms)/1000 as wait_time_s
		from dbo.wait_stats s2
		where s2.collection_time_utc = @collect_time_utc_snap2
		and [wait_type] NOT IN ( select wc.[WaitType] from [dbo].[BlitzFirst_WaitStats_Categories] wc where coalesce(wc.IgnorableOnPerCoreMetric,wc.Ignorable,0) = 1 )
		AND [waiting_tasks_count] > 0
	)
	select @waits_seconds__per_core_per_minute = CEILING(
				case when datediff(minute,@collect_time_utc_snap1,@collect_time_utc_snap2) = 0
					 then 0
					 else convert(numeric(20,2), (s2.wait_time_s - s1.wait_time_s)*1.0 / @schedulers / datediff(minute,@collect_time_utc_snap1,@collect_time_utc_snap2))
					 end)
	from wait_snap1 s1, wait_snap2 s2;

	--IF @passed_waits_seconds__per_core_per_minute = -1.0
	SELECT [waits_seconds__per_core_per_minute] = @waits_seconds__per_core_per_minute;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_wrapper_CollectPrivilegedInfo
-- --------------------------------------------------

CREATE PROCEDURE dbo.usp_wrapper_CollectPrivilegedInfo
(	@verbose tinyint = 0, /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
	@recipients varchar(500) = 'dba_team@gmail.com', /* Folks who receive the failure mail */
	@alert_key varchar(100) = 'Wrapper-CollectPrivilegedInfo', /* Subject of Failure Mail */
	@send_error_mail bit = 1, /* Send mail on failure */
	@is_test_alert bit = 0, /* enable for alert testing */
	@step_name varchar(100),
	@threshold_continous_failure tinyint = 2, /* Send mail only when failure is x times continously */
	@notification_delay_minutes tinyint = 10, /* Send mail only after a gap of x minutes from last mail */ 
	@truncate_table bit = 1, /* when enabled, table would be truncated */
	@has_staging_table bit = 1, /* when enabled, assume there is no staging table */
	@schedule_minutes int = 10 /* schedule for execution in minutes */
)
AS 
BEGIN

/*
	Version:		0.0.0
	Purpose:		Fetch information that need Sysadmin access in general & Save in some table.
	Modifications:	2023-08-30 - Initial Draft

	exec dbo.usp_wrapper_CollectPrivilegedInfo 
		@recipients = 'dba_team@gmail.com', 
		@step_name = 'dbo.server_privileged_info',
		@truncate_table = 1,
		@has_staging_table = 0,
		@schedule_minutes = 10
		,@verbose = 2

	Additional Requirements
	1) Default Global Mail Profile
		-> SqlInstance -> Management -> Right click "Database Mail" -> Configure Database Mail -> Select option "Manage profile security" -> Check Public checkbox, and Select "Yes" for Default for profile that should be set a global default
	2) Make sure context database is set to correct dba database
*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	--SET LOCK_TIMEOUT 60000; -- 60 seconds

	-- Local Variables
	DECLARE @_sql NVARCHAR(MAX);
	DECLARE @_params NVARCHAR(MAX);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_last_sent_failed_active datetime;
	DECLARE @_last_sent_failed_cleared datetime;
	DECLARE @_mail_body_html NVARCHAR(MAX);  
	DECLARE @_subject nvarchar(1000);
	DECLARE @_job_name nvarchar(500);
	DECLARE @_continous_failures tinyint = 0;
	DECLARE @_send_mail bit = 0;

	SET @_job_name = '(dba) '+@alert_key;

	IF (@recipients IS NULL OR @recipients = 'dba_team@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	IF @step_name NOT IN ('dbo.server_privileged_info')
		THROW 50001, '''step_name'' Parameter value is invalid.', 1;		

	-- Variables for Try/Catch Block
	DECLARE @_profile_name varchar(200);
	DECLARE	@_errorNumber int,
			@_errorSeverity int,
			@_errorState int,
			@_errorLine int,
			@_errorMessage nvarchar(4000);

	SET @_params = N'@verbose tinyint, @truncate_table bit, @has_staging_table bit, @schedule_minutes int';

	BEGIN TRY

		IF @verbose > 0
			PRINT 'Start Try Block..';	
		
		IF @step_name = 'dbo.server_privileged_info'
		BEGIN
			IF @verbose > 0
				PRINT 'dbo.server_privileged_info';
			SET @_sql = N'-- Collect Metrics that need sysadmin access
if	( (select isnull(max(collection_time_utc),''2023-01-01 00:00'') from dbo.server_privileged_info) < dateadd(minute, -@schedule_minutes, getutcdate()) )
begin
	exec dbo.usp_collect_privileged_info
					@result_to_table = ''dbo.server_privileged_info'',
					@truncate_table = @truncate_table,
					@has_staging_table = @has_staging_table,
					@verbose = @verbose;
end
else
	print ''Did not meet schedule requirement.''+char(13);';
			IF @verbose > 0
				PRINT @_sql;
			EXEC sp_executesql @_sql, @_params, @verbose, @truncate_table, @has_staging_table, @schedule_minutes;
		END

	END TRY  -- Perform main logic inside Try/Catch
	BEGIN CATCH
		IF @verbose > 0
			PRINT 'Start Catch Block.'

		SELECT @_errorNumber	 = Error_Number()
				,@_errorSeverity = Error_Severity()
				,@_errorState	 = Error_State()
				,@_errorLine	 = Error_Line()
				,@_errorMessage	 = Error_Message();
		declare @product_version tinyint;
		select @product_version = CONVERT(tinyint,SERVERPROPERTY('ProductMajorVersion'));

		IF @verbose >= 1
		BEGIN
			PRINT CHAR(13);
			PRINT '@_errorNumber => '+convert(varchar,@_errorNumber);
			PRINT '@_errorState => '+convert(varchar,@_errorState);
			PRINT '@_errorMessage => '+@_errorMessage;
			PRINT CHAR(13);
		END

		IF OBJECT_ID('tempdb..#CommandLog') IS NOT NULL
			TRUNCATE TABLE #CommandLog;
		ELSE
			CREATE TABLE #CommandLog(collection_time datetime2 not null, status varchar(30) not null);

		IF @verbose > 0
			PRINT CHAR(9)+'Inside Catch Block. Get recent '+cast(@threshold_continous_failure as varchar)+' execution entries from logs..'
		IF @product_version IS NOT NULL
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
					[status] = case when run_status = 1 then ''Success'' else ''Failure'' end
			FROM msdb.dbo.sysjobs jobs
			INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
			WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			ORDER BY run_date_time DESC OFFSET 0 ROWS FETCH FIRST @threshold_continous_failure ROWS ONLY;' + char(10);
		END
		ELSE
		BEGIN
			SET @_sql = N'
			DECLARE @threshold_continous_failure tinyint = @_threshold_continous_failure;
			SET @threshold_continous_failure -= 1;
			
			SELECT [run_date_time], [status]
			FROM (
				SELECT	[run_date_time] = msdb.dbo.agent_datetime(run_date, run_time),
						[status] = case when run_status = 1 then ''Success'' else ''Failure'' end,
						[seq] = ROW_NUMBER() OVER (ORDER BY msdb.dbo.agent_datetime(run_date, run_time) DESC)
				FROM msdb.dbo.sysjobs jobs
				INNER JOIN msdb.dbo.sysjobhistory history ON jobs.job_id = history.job_id
				WHERE jobs.enabled = 1 AND jobs.name = @_job_name AND step_id = 0 AND run_status NOT IN (2,4) -- not retry/inprogress
			) t
			WHERE [seq] BETWEEN 1 and @threshold_continous_failure			
			' + char(10);
		END

		IF @verbose > 1
			PRINT CHAR(9)+@_sql;
		INSERT #CommandLog
		EXEC sp_executesql @_sql, N'@_job_name varchar(500), @_threshold_continous_failure tinyint', @_job_name = @_job_name, @_threshold_continous_failure = @threshold_continous_failure;

		SELECT @_continous_failures = COUNT(*)+1 FROM #CommandLog WHERE [status] = 'Failure';

		IF @verbose > 0
			PRINT CHAR(9)+'@_continous_failures => '+cast(@_continous_failures as varchar);
		IF @verbose > 1
		BEGIN
			PRINT CHAR(9)+'SELECT [RunningQuery] = ''Previous Run Status from #CommandLog'', * FROM #CommandLog;'
			SELECT [RunningQuery], cl.* 
			FROM #CommandLog cl
			FULL OUTER JOIN (VALUES ('Previous Run Status from #CommandLog')) rq (RunningQuery)
			ON 1 = 1;
		END

		IF @verbose > 0
			PRINT 'End Catch Block.'
	END CATCH	

	/* 
	Check if Any Error, then based on Continous Threshold & Delay, send mail
	Check if No Error, then clear the alert if active,
	*/

	IF @verbose > 0
		PRINT 'Get Last @last_sent_failed &  @last_sent_cleared..';
	SELECT @_last_sent_failed_active = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![ACTIVE!]') ESCAPE '!';
	SELECT @_last_sent_failed_cleared = MAX(si.sent_date) FROM msdb..sysmail_sentitems si WHERE si.subject LIKE ('% - Job !['+@_job_name+'!] - ![FAILED!] - ![CLEARED!]') ESCAPE '!';

	IF @verbose > 0
	BEGIN
		PRINT '@_last_sent_failed_active => '+CONVERT(nvarchar(30),@_last_sent_failed_active,121);
		PRINT '@_last_sent_failed_cleared => '+ISNULL(CONVERT(nvarchar(30),@_last_sent_failed_cleared,121),'');
	END

	-- Check if Failed, @threshold_continous_failure is breached, and crossed @notification_delay_minutes
	IF		(@send_error_mail = 1) 
		AND (@_continous_failures >= @threshold_continous_failure) 
		AND ( (@_last_sent_failed_active IS NULL) OR (DATEDIFF(MINUTE,@_last_sent_failed_active,GETDATE()) >= @notification_delay_minutes) )
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED ACTIVE notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [ACTIVE]';
		SET @_mail_body_html =
				N'Sql Agent job '''+@_job_name+''' has failed @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Error Number: ' + convert(varchar, @_errorNumber) + 
				N'<br>Line Number: ' + convert(varchar, @_errorLine) +
				N'<br>Error Message: <br>"' + @_errorMessage +
				N'<br><br>Kindly resolve the job failure based on above error message.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Active" mail notification checks not satisfied. '+char(10)+char(9)+'((@send_error_mail = 1) AND (@_continous_failures >= @threshold_continous_failure) AND ( (@last_sent_failed IS NULL) OR (DATEDIFF(MINUTE,@last_sent_failed,GETDATE()) >= @notification_delay_minutes) ))';

	-- Check if No error, then clear active alert if any.
	IF (@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active >= ISNULL(@_last_sent_failed_cleared,@_last_sent_failed_active))
	BEGIN
		IF @verbose > 0
			PRINT 'Setting Mail variable values for Job FAILED CLEARED notification..'
		SET @_subject = QUOTENAME(@@SERVERNAME)+' - Job ['+@_job_name+'] - [FAILED] - [CLEARED]';
		SET @_mail_body_html=
				N'Sql Agent job '''+@_job_name+''' has completed successfully. So clearing alert @'+ CONVERT(nvarchar(30),getdate(),121) +'.'+
				N'<br><br>Regards,'+
				N'<br>Job ['+@_job_name+']' +
				N'<br><br>--> Continous Failure Threshold -> ' + CONVERT(varchar,@threshold_continous_failure) +
				N'<br>--> Notification Delay (Minutes) -> ' + CONVERT(varchar,@notification_delay_minutes)
		SET @_send_mail = 1;
	END
	ELSE
		PRINT 'IMPORTANT => Failure "Clearing" mail notification checks not satisfied. '+char(10)+char(9)+'(@send_error_mail = 1) AND (@_errorMessage IS NULL) AND (@_last_sent_failed_active > @_last_sent_failed_cleared)';

	IF @is_test_alert = 1
		SET @_subject = 'TestAlert - '+@_subject;

	IF @_send_mail = 1
	BEGIN
		SELECT @_profile_name = p.name
		FROM msdb.dbo.sysmail_profile p 
		JOIN msdb.dbo.sysmail_principalprofile pp ON pp.profile_id = p.profile_id AND pp.is_default = 1
		JOIN msdb.dbo.sysmail_profileaccount pa ON p.profile_id = pa.profile_id 
		JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id 
		JOIN msdb.dbo.sysmail_server s ON a.account_id = s.account_id;

		EXEC msdb.dbo.sp_send_dbmail
				@recipients = @recipients,
				@profile_name = @_profile_name,
				@subject = @_subject,
				@body = @_mail_body_html,
				@body_format = 'HTML';
	END

	IF @_errorMessage IS NOT NULL --AND @send_error_mail = 0
    raiserror (@_errorMessage, 20, -1) with log;
END

GO

-- --------------------------------------------------
-- TABLE dbo.ag_health_state
-- --------------------------------------------------
CREATE TABLE [dbo].[ag_health_state]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [replica_server_name] NVARCHAR(256) NULL,
    [is_primary_replica] BIT NULL,
    [database_name] NVARCHAR(128) NULL,
    [ag_name] NVARCHAR(128) NULL,
    [ag_listener] NVARCHAR(114) NULL,
    [is_local] BIT NULL,
    [is_distributed] BIT NULL,
    [synchronization_state_desc] NVARCHAR(60) NULL,
    [synchronization_health_desc] NVARCHAR(60) NULL,
    [latency_seconds] INT NULL,
    [redo_queue_size] BIGINT NULL,
    [log_send_queue_size] BIGINT NULL,
    [last_redone_time] DATETIME NULL,
    [log_send_rate] BIGINT NULL,
    [redo_rate] BIGINT NULL,
    [estimated_redo_completion_time_min] NUMERIC(26, 6) NULL,
    [last_commit_time] DATETIME NULL,
    [is_suspended] BIT NULL,
    [suspend_reason_desc] NVARCHAR(60) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.alert_categories
-- --------------------------------------------------
CREATE TABLE [dbo].[alert_categories]
(
    [error_number] INT NOT NULL,
    [error_severity] INT NULL,
    [category] VARCHAR(128) NOT NULL,
    [sub_category] VARCHAR(128) NULL,
    [alert_name] VARCHAR(255) NOT NULL,
    [remarks] NVARCHAR(500) NULL,
    [created_time] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [created_by] NVARCHAR(128) NOT NULL DEFAULT (suser_name())
);

GO

-- --------------------------------------------------
-- TABLE dbo.alert_history
-- --------------------------------------------------
CREATE TABLE [dbo].[alert_history]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [server_name] NVARCHAR(128) NULL,
    [database_name] NVARCHAR(128) NULL,
    [error_number] INT NULL,
    [error_severity] TINYINT NULL,
    [error_message] NVARCHAR(510) NULL,
    [host_instance] NVARCHAR(128) NULL,
    [collection_time] DATETIME2 NOT NULL DEFAULT (sysdatetime())
);

GO

-- --------------------------------------------------
-- TABLE dbo.Blitz
-- --------------------------------------------------
CREATE TABLE [dbo].[Blitz]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [ServerName] NVARCHAR(128) NULL,
    [CheckDate] DATETIME NOT NULL DEFAULT (getdate()),
    [Priority] TINYINT NULL,
    [FindingsGroup] VARCHAR(50) NULL,
    [Finding] VARCHAR(200) NULL,
    [DatabaseName] NVARCHAR(128) NULL,
    [URL] VARCHAR(200) NULL,
    [Details] NVARCHAR(4000) NULL,
    [QueryPlan] XML NULL,
    [QueryPlanFiltered] NVARCHAR(MAX) NULL,
    [CheckID] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BlitzFirst_WaitStats_Categories
-- --------------------------------------------------
CREATE TABLE [dbo].[BlitzFirst_WaitStats_Categories]
(
    [WaitType] NVARCHAR(60) NOT NULL,
    [WaitCategory] NVARCHAR(128) NOT NULL,
    [Ignorable] BIT NULL DEFAULT ((0)),
    [IgnorableOnPerCoreMetric] BIT NULL DEFAULT ((0)),
    [IgnorableOnDashboard] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.BlitzIndex
-- --------------------------------------------------
CREATE TABLE [dbo].[BlitzIndex]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [database_name] NVARCHAR(128) NULL,
    [schema_name] NVARCHAR(128) NULL,
    [table_name] NVARCHAR(128) NULL,
    [index_name] NVARCHAR(128) NULL,
    [Drop_Tsql] NVARCHAR(MAX) NULL,
    [Create_Tsql] NVARCHAR(MAX) NULL,
    [index_id] INT NULL,
    [db_schema_object_indexid] NVARCHAR(500) NULL,
    [object_type] NVARCHAR(15) NULL,
    [index_definition] NVARCHAR(MAX) NULL,
    [key_column_names_with_sort_order] NVARCHAR(MAX) NULL,
    [count_key_columns] INT NULL,
    [include_column_names] NVARCHAR(MAX) NULL,
    [count_included_columns] INT NULL,
    [secret_columns] NVARCHAR(MAX) NULL,
    [count_secret_columns] INT NULL,
    [partition_key_column_name] NVARCHAR(MAX) NULL,
    [filter_definition] NVARCHAR(MAX) NULL,
    [is_indexed_view] BIT NULL,
    [is_primary_key] BIT NULL,
    [is_unique_constraint] BIT NULL,
    [is_XML] BIT NULL,
    [is_spatial] BIT NULL,
    [is_NC_columnstore] BIT NULL,
    [is_CX_columnstore] BIT NULL,
    [is_in_memory_oltp] BIT NULL,
    [is_disabled] BIT NULL,
    [is_hypothetical] BIT NULL,
    [is_padded] BIT NULL,
    [fill_factor] INT NULL,
    [is_referenced_by_foreign_key] BIT NULL,
    [last_user_seek] DATETIME NULL,
    [last_user_scan] DATETIME NULL,
    [last_user_lookup] DATETIME NULL,
    [last_user_update] DATETIME NULL,
    [total_reads] BIGINT NULL,
    [user_updates] BIGINT NULL,
    [reads_per_write] MONEY NULL,
    [index_usage_summary] NVARCHAR(200) NULL,
    [total_singleton_lookup_count] BIGINT NULL,
    [total_range_scan_count] BIGINT NULL,
    [total_leaf_delete_count] BIGINT NULL,
    [total_leaf_update_count] BIGINT NULL,
    [index_op_stats] NVARCHAR(200) NULL,
    [partition_count] INT NULL,
    [total_rows] BIGINT NULL,
    [total_reserved_MB] NUMERIC(29, 2) NULL,
    [total_reserved_LOB_MB] NUMERIC(29, 2) NULL,
    [total_reserved_row_overflow_MB] NUMERIC(29, 2) NULL,
    [index_size_summary] NVARCHAR(300) NULL,
    [total_row_lock_count] BIGINT NULL,
    [total_row_lock_wait_count] BIGINT NULL,
    [total_row_lock_wait_in_ms] BIGINT NULL,
    [avg_row_lock_wait_in_ms] BIGINT NULL,
    [total_page_lock_count] BIGINT NULL,
    [total_page_lock_wait_count] BIGINT NULL,
    [total_page_lock_wait_in_ms] BIGINT NULL,
    [avg_page_lock_wait_in_ms] BIGINT NULL,
    [total_index_lock_promotion_attempt_count] BIGINT NULL,
    [total_index_lock_promotion_count] BIGINT NULL,
    [total_forwarded_fetch_count] BIGINT NULL,
    [data_compression_desc] NVARCHAR(4000) NULL,
    [page_latch_wait_count] BIGINT NULL,
    [page_latch_wait_in_ms] BIGINT NULL,
    [page_io_latch_wait_count] BIGINT NULL,
    [page_io_latch_wait_in_ms] BIGINT NULL,
    [create_date] DATETIME NULL,
    [modify_date] DATETIME NULL,
    [more_info] NVARCHAR(500) NULL,
    [display_order] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BlitzIndex_Mode0
-- --------------------------------------------------
CREATE TABLE [dbo].[BlitzIndex_Mode0]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [priority] INT NULL,
    [finding] NVARCHAR(4000) NULL,
    [database_name] NVARCHAR(128) NULL,
    [details] NVARCHAR(MAX) NULL,
    [index_definition] NVARCHAR(MAX) NULL,
    [secret_columns] NVARCHAR(MAX) NULL,
    [index_usage_summary] NVARCHAR(MAX) NULL,
    [index_size_summary] NVARCHAR(MAX) NULL,
    [more_info] NVARCHAR(MAX) NULL,
    [url] NVARCHAR(MAX) NULL,
    [create_tsql] NVARCHAR(MAX) NULL,
    [sample_query_plan] XML NULL,
    [total_forwarded_fetch_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BlitzIndex_Mode1
-- --------------------------------------------------
CREATE TABLE [dbo].[BlitzIndex_Mode1]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [database_name] NVARCHAR(128) NULL,
    [object_count] INT NULL,
    [reserved_gb] NUMERIC(29, 1) NULL,
    [reserved_lob_gb] NUMERIC(29, 1) NULL,
    [reserved_row_overflow_gb] NUMERIC(29, 1) NULL,
    [clustered_table_count] INT NULL,
    [clustered_table_gb] NUMERIC(29, 1) NULL,
    [nc_index_count] INT NULL,
    [nc_index_gb] NUMERIC(29, 1) NULL,
    [table_nc_index_ratio] NUMERIC(29, 1) NULL,
    [heap_count] INT NULL,
    [heap_gb] NUMERIC(29, 1) NULL,
    [partitioned_table_count] INT NULL,
    [partitioned_nc_count] INT NULL,
    [partitioned_gb] NUMERIC(29, 1) NULL,
    [filtered_index_count] INT NULL,
    [indexed_view_count] INT NULL,
    [max_table_row_count] INT NULL,
    [max_table_gb] NUMERIC(29, 1) NULL,
    [max_nc_index_gb] NUMERIC(29, 1) NULL,
    [table_count_over_1gb] INT NULL,
    [table_count_over_10gb] INT NULL,
    [table_count_over_100gb] INT NULL,
    [nc_index_count_over_1gb] INT NULL,
    [nc_index_count_over_10gb] INT NULL,
    [nc_index_count_over_100gb] INT NULL,
    [min_create_date] DATETIME NULL,
    [max_create_date] DATETIME NULL,
    [max_modify_date] DATETIME NULL,
    [display_order] INT NULL,
    [total_forwarded_fetch_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BlitzIndex_Mode4
-- --------------------------------------------------
CREATE TABLE [dbo].[BlitzIndex_Mode4]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [run_id] UNIQUEIDENTIFIER NULL,
    [run_datetime] DATETIME NOT NULL DEFAULT (getdate()),
    [server_name] NVARCHAR(128) NULL,
    [priority] INT NULL,
    [finding] NVARCHAR(4000) NULL,
    [database_name] NVARCHAR(128) NULL,
    [details] NVARCHAR(MAX) NULL,
    [index_definition] NVARCHAR(MAX) NULL,
    [secret_columns] NVARCHAR(MAX) NULL,
    [index_usage_summary] NVARCHAR(MAX) NULL,
    [index_size_summary] NVARCHAR(MAX) NULL,
    [more_info] NVARCHAR(MAX) NULL,
    [url] NVARCHAR(MAX) NULL,
    [create_tsql] NVARCHAR(MAX) NULL,
    [sample_query_plan] XML NULL,
    [total_forwarded_fetch_count] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.db_size_daily_report
-- --------------------------------------------------
CREATE TABLE [dbo].[db_size_daily_report]
(
    [collection_time] SMALLDATETIME NOT NULL,
    [server_name] VARCHAR(128) NOT NULL,
    [server_ip] VARCHAR(14) NULL,
    [database_name] NVARCHAR(128) NOT NULL,
    [file_type] NVARCHAR(60) NOT NULL,
    [file_name] NVARCHAR(128) NOT NULL,
    [file_location] VARCHAR(500) NOT NULL,
    [file_drive] CHAR(3) NOT NULL,
    [file_size_mb] DECIMAL(20, 2) NOT NULL,
    [used_space_mb] DECIMAL(20, 2) NULL,
    [free_space_mb] DECIMAL(20, 2) NULL,
    [free_space_pcnt] DECIMAL(20, 2) NULL,
    [is_auto_growth_enabled] BIT NOT NULL DEFAULT ((0)),
    [auto_growth_type] VARCHAR(5) NULL,
    [auto_growth_mb] DECIMAL(20, 2) NULL,
    [max_size_mb] DECIMAL(20, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DBA_DDLChangelog
-- --------------------------------------------------
CREATE TABLE [dbo].[DBA_DDLChangelog]
(
    [DDLChangeLogId] INT IDENTITY(1,1) NOT NULL,
    [InsertionDate] DATETIME NULL,
    [ServerName] NVARCHAR(200) NULL,
    [DatabaseName] NVARCHAR(200) NULL,
    [CurrentUser] NVARCHAR(100) NULL,
    [LoginName] NVARCHAR(100) NULL,
    [UserName] NVARCHAR(100) NULL DEFAULT (CONVERT([nvarchar](50),original_login(),(0))),
    [EventType] NVARCHAR(200) NULL,
    [objectName] NVARCHAR(200) NULL,
    [objectType] NVARCHAR(200) NULL,
    [tsql] TEXT NULL,
    [hostName] NVARCHAR(MAX) NULL,
    [IpAddress] NCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.disk_space
-- --------------------------------------------------
CREATE TABLE [dbo].[disk_space]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(125) NOT NULL,
    [disk_volume] VARCHAR(255) NOT NULL,
    [label] VARCHAR(125) NULL,
    [capacity_mb] DECIMAL(20, 2) NOT NULL,
    [free_mb] DECIMAL(20, 2) NOT NULL,
    [block_size] INT NULL,
    [filesystem] VARCHAR(125) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FailedLogincapture
-- --------------------------------------------------
CREATE TABLE [dbo].[FailedLogincapture]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [NoOfAttmpts] INT NULL,
    [LoginDetails] NVARCHAR(MAX) NULL,
    [LoginDate] DATE NULL,
    [IP_Details] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.file_io_stats
-- --------------------------------------------------
CREATE TABLE [dbo].[file_io_stats]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [database_name] NVARCHAR(128) NOT NULL,
    [database_id] INT NOT NULL,
    [file_logical_name] NVARCHAR(128) NOT NULL,
    [file_id] INT NOT NULL,
    [file_location] NVARCHAR(260) NOT NULL,
    [sample_ms] BIGINT NOT NULL,
    [num_of_reads] BIGINT NOT NULL,
    [num_of_bytes_read] BIGINT NOT NULL,
    [io_stall_read_ms] BIGINT NOT NULL,
    [io_stall_queued_read_ms] BIGINT NOT NULL,
    [num_of_writes] BIGINT NOT NULL,
    [num_of_bytes_written] BIGINT NOT NULL,
    [io_stall_write_ms] BIGINT NOT NULL,
    [io_stall_queued_write_ms] BIGINT NOT NULL,
    [io_stall] BIGINT NOT NULL,
    [size_on_disk_bytes] BIGINT NOT NULL,
    [io_pending_count] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_total] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_avg] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_max] BIGINT NULL DEFAULT ((0)),
    [io_pending_ms_ticks_min] BIGINT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.instance_details
-- --------------------------------------------------
CREATE TABLE [dbo].[instance_details]
(
    [sql_instance] VARCHAR(255) NOT NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [database] VARCHAR(255) NOT NULL,
    [collector_tsql_jobs_server] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [collector_powershell_jobs_server] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [data_destination_sql_instance] VARCHAR(255) NULL DEFAULT (CONVERT([varchar],serverproperty('MachineName'))),
    [dba_group_mail_id] VARCHAR(2000) NOT NULL DEFAULT 'some_dba_mail_id@gmail.com',
    [sqlmonitor_script_path] VARCHAR(2000) NOT NULL DEFAULT 'C:\SQLMonitor',
    [sqlmonitor_version] VARCHAR(20) NOT NULL DEFAULT '1.1.0',
    [is_alias] BIT NOT NULL DEFAULT ((0)),
    [source_sql_instance] VARCHAR(255) NULL,
    [sql_instance_port] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.instance_hosts
-- --------------------------------------------------
CREATE TABLE [dbo].[instance_hosts]
(
    [host_name] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.log_space_consumers
-- --------------------------------------------------
CREATE TABLE [dbo].[log_space_consumers]
(
    [collection_time] DATETIME2 NOT NULL,
    [database_name] NVARCHAR(128) NOT NULL,
    [recovery_model] VARCHAR(20) NOT NULL,
    [log_reuse_wait_desc] VARCHAR(125) NOT NULL,
    [log_size_mb] DECIMAL(20, 2) NOT NULL,
    [log_used_mb] DECIMAL(20, 2) NOT NULL,
    [exists_valid_autogrowing_file] BIT NULL,
    [log_used_pct] DECIMAL(10, 2) NOT NULL,
    [log_used_pct_threshold] DECIMAL(10, 2) NOT NULL,
    [log_used_gb_threshold] DECIMAL(20, 2) NULL,
    [spid] INT NULL,
    [transaction_start_time] DATETIME NULL,
    [login_name] NVARCHAR(128) NULL,
    [program_name] NVARCHAR(128) NULL,
    [host_name] NVARCHAR(128) NULL,
    [host_process_id] INT NULL,
    [command] VARCHAR(16) NULL,
    [additional_info] VARCHAR(255) NULL,
    [action_taken] VARCHAR(100) NULL,
    [sql_text] VARCHAR(MAX) NULL,
    [is_pct_threshold_valid] BIT NOT NULL,
    [is_gb_threshold_valid] BIT NOT NULL,
    [threshold_condition] VARCHAR(5) NOT NULL,
    [thresholds_validated] BIT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LogIops
-- --------------------------------------------------
CREATE TABLE [dbo].[LogIops]
(
    [database_name] VARCHAR(50) NULL,
    [physical_name] VARCHAR(500) NOT NULL,
    [drive_letter] NVARCHAR(1) NULL,
    [num_of_writes] BIGINT NOT NULL,
    [num_of_bytes_written] BIGINT NOT NULL,
    [io_stall_write_ms] BIGINT NOT NULL,
    [type_desc] VARCHAR(10) NULL,
    [num_of_reads] BIGINT NOT NULL,
    [num_of_bytes_read] BIGINT NOT NULL,
    [io_stall_read_ms] BIGINT NOT NULL,
    [io_stall] BIGINT NOT NULL,
    [size_on_disk_bytes] BIGINT NOT NULL,
    [Recordtime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.memory_clerks
-- --------------------------------------------------
CREATE TABLE [dbo].[memory_clerks]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [memory_clerk] VARCHAR(255) NOT NULL,
    [name] VARCHAR(255) NOT NULL,
    [size_mb] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.os_task_list
-- --------------------------------------------------
CREATE TABLE [dbo].[os_task_list]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [task_name] NVARCHAR(100) NOT NULL,
    [pid] BIGINT NOT NULL,
    [session_name] VARCHAR(20) NULL,
    [memory_kb] BIGINT NULL,
    [status] VARCHAR(30) NULL,
    [user_name] VARCHAR(200) NOT NULL,
    [cpu_time] CHAR(14) NOT NULL,
    [cpu_time_seconds] BIGINT NOT NULL,
    [window_title] NVARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.perfmon_files
-- --------------------------------------------------
CREATE TABLE [dbo].[perfmon_files]
(
    [host_name] VARCHAR(255) NOT NULL,
    [file_name] VARCHAR(255) NOT NULL,
    [file_path] VARCHAR(255) NOT NULL,
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime())
);

GO

-- --------------------------------------------------
-- TABLE dbo.performance_counters
-- --------------------------------------------------
CREATE TABLE [dbo].[performance_counters]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [host_name] VARCHAR(255) NOT NULL,
    [object] VARCHAR(255) NOT NULL,
    [counter] VARCHAR(255) NOT NULL,
    [value] NUMERIC(38, 10) NULL,
    [instance] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.purge_table
-- --------------------------------------------------
CREATE TABLE [dbo].[purge_table]
(
    [table_name] NVARCHAR(128) NOT NULL,
    [date_key] NVARCHAR(128) NOT NULL,
    [retention_days] SMALLINT NOT NULL DEFAULT ((15)),
    [purge_row_size] INT NOT NULL DEFAULT ((100000)),
    [created_by] NVARCHAR(128) NOT NULL DEFAULT (suser_name()),
    [created_date] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [reference] VARCHAR(255) NULL,
    [latest_purge_datetime] DATETIME2 NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.resource_consumption
-- --------------------------------------------------
CREATE TABLE [dbo].[resource_consumption]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [event_name] NVARCHAR(60) NOT NULL,
    [session_id] INT NOT NULL,
    [request_id] INT NOT NULL,
    [result] VARCHAR(50) NULL,
    [database_name] VARCHAR(255) NULL,
    [client_app_name] VARCHAR(255) NULL,
    [username] VARCHAR(255) NULL,
    [cpu_time_ms] BIGINT NULL,
    [duration_seconds] BIGINT NULL,
    [logical_reads] BIGINT NULL,
    [physical_reads] BIGINT NULL,
    [row_count] BIGINT NULL,
    [writes] BIGINT NULL,
    [spills] BIGINT NULL,
    [client_hostname] VARCHAR(255) NULL,
    [session_resource_pool_id] INT NULL,
    [session_resource_group_id] INT NULL,
    [scheduler_id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.resource_consumption_Processed_XEL_Files
-- --------------------------------------------------
CREATE TABLE [dbo].[resource_consumption_Processed_XEL_Files]
(
    [file_path] VARCHAR(2000) NOT NULL,
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [is_processed] BIT NOT NULL DEFAULT ((0)),
    [is_removed_from_disk] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.resource_consumption_queries
-- --------------------------------------------------
CREATE TABLE [dbo].[resource_consumption_queries]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [sql_text] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.server_privileged_info
-- --------------------------------------------------
CREATE TABLE [dbo].[server_privileged_info]
(
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [host_name] VARCHAR(125) NOT NULL,
    [host_distribution] VARCHAR(200) NULL,
    [processor_name] VARCHAR(200) NULL,
    [fqdn] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sql_agent_job_stats
-- --------------------------------------------------
CREATE TABLE [dbo].[sql_agent_job_stats]
(
    [JobName] VARCHAR(255) NOT NULL,
    [Instance_Id] BIGINT NULL,
    [Last_RunTime] DATETIME2 NULL,
    [Last_Run_Duration_Seconds] INT NULL,
    [Last_Run_Outcome] VARCHAR(50) NULL,
    [Last_Successful_ExecutionTime] DATETIME2 NULL,
    [Running_Since] DATETIME2 NULL,
    [Running_StepName] VARCHAR(250) NULL,
    [Running_Since_Min] BIGINT NULL,
    [Session_Id] INT NULL,
    [Blocking_Session_Id] INT NULL,
    [Next_RunTime] DATETIME2 NULL,
    [Total_Executions] BIGINT NULL DEFAULT ((0)),
    [Total_Success_Count] BIGINT NULL DEFAULT ((0)),
    [Total_Stopped_Count] BIGINT NULL DEFAULT ((0)),
    [Total_Failed_Count] BIGINT NULL DEFAULT ((0)),
    [Continous_Failures] INT NULL DEFAULT ((0)),
    [<10-Min] BIGINT NOT NULL DEFAULT ((0)),
    [10-Min] BIGINT NOT NULL DEFAULT ((0)),
    [30-Min] BIGINT NOT NULL DEFAULT ((0)),
    [1-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [2-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [3-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [6-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [9-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [12-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [18-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [24-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [36-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [48-Hrs] BIGINT NOT NULL DEFAULT ((0)),
    [CollectionTimeUTC] DATETIME2 NULL DEFAULT (sysutcdatetime()),
    [UpdatedDateUTC] DATETIME2 NOT NULL DEFAULT (sysutcdatetime())
);

GO

-- --------------------------------------------------
-- TABLE dbo.sql_agent_job_thresholds
-- --------------------------------------------------
CREATE TABLE [dbo].[sql_agent_job_thresholds]
(
    [JobName] VARCHAR(255) NOT NULL,
    [JobCategory] VARCHAR(255) NOT NULL,
    [Expected-Max-Duration(Min)] BIGINT NULL,
    [Continous_Failure_Threshold] INT NULL DEFAULT ((2)),
    [Successfull_Execution_ClockTime_Threshold_Minutes] BIGINT NULL,
    [StopJob_If_LongRunning] BIT NULL DEFAULT ((0)),
    [StopJob_If_NotSuccessful_In_ThresholdTime] BIT NULL DEFAULT ((0)),
    [RestartJob_If_NotSuccessful_In_ThresholdTime] BIT NULL DEFAULT ((0)),
    [RestartJob_If_Failed] BIT NULL DEFAULT ((0)),
    [Kill_Job_Blocker] BIT NULL DEFAULT ((0)),
    [Alert_When_Blocked] BIT NULL DEFAULT ((0)),
    [EnableJob_If_Found_Disabled] BIT NOT NULL DEFAULT ((0)),
    [IgnoreJob] BIT NOT NULL DEFAULT ((0)),
    [IsDisabled] BIT NOT NULL DEFAULT ((0)),
    [IsNotFound] BIT NOT NULL DEFAULT ((0)),
    [Include_In_MailNotification] BIT NULL DEFAULT ((0)),
    [Mail_Recepients] VARCHAR(2000) NULL DEFAULT NULL,
    [CollectionTimeUTC] DATETIME2 NULL DEFAULT (sysutcdatetime()),
    [UpdatedDateUTC] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [UpdatedBy] VARCHAR(125) NOT NULL DEFAULT (suser_name()),
    [Remarks] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SuccessfullLoginCapture
-- --------------------------------------------------
CREATE TABLE [dbo].[SuccessfullLoginCapture]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [NoOfAttmpts] INT NULL,
    [LoginDetails] NVARCHAR(MAX) NULL,
    [LoginDate] DATE NULL,
    [IP_Details] NVARCHAR(MAX) NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Backup_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Backup_Details]
(
    [Collection_Time] DATETIME NOT NULL,
    [Server_Name] VARCHAR(255) NULL,
    [DatabaseName] VARCHAR(255) NULL,
    [DatabaseID] INT NOT NULL,
    [Recovery_Model] VARCHAR(25) NULL,
    [Full_Backup_Start] DATETIME NULL,
    [Full_Backup_End] DATETIME NULL,
    [Diff_Backup_Start] DATETIME NULL,
    [Diff_Backup_End] DATETIME NULL,
    [Log_Backup_Start] DATETIME NULL,
    [Log_Backup_End] DATETIME NULL,
    [Full_Backup_Path] VARCHAR(255) NULL,
    [Diff_Backup_Path] VARCHAR(255) NULL,
    [Log_Backup_Path] VARCHAR(255) NULL,
    [Full_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Diff_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Log_Backup_Size_GB] DECIMAL(10, 2) NULL,
    [Time_Since_Last_Full_Backup_Minutes] INT NULL,
    [Time_Since_Last_Diff_Backup_Minutes] INT NULL,
    [Time_Since_Last_Log_Backup_Minutes] INT NULL,
    [Time_Since_Last_Full_Backup_Detail] VARCHAR(75) NULL,
    [Time_Since_Last_Diff_Backup_Detail] VARCHAR(75) NULL,
    [Time_Since_Last_Log_Backup_Detail] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempdb_space_consumers
-- --------------------------------------------------
CREATE TABLE [dbo].[tempdb_space_consumers]
(
    [collection_time] DATETIME2 NOT NULL,
    [usage_rank] TINYINT NOT NULL,
    [spid] INT NOT NULL,
    [login_name] NVARCHAR(128) NOT NULL,
    [program_name] NVARCHAR(128) NULL,
    [host_name] NVARCHAR(128) NULL,
    [host_process_id] INT NULL,
    [is_active_session] INT NULL,
    [open_transaction_count] INT NULL,
    [transaction_isolation_level] VARCHAR(15) NULL,
    [size_bytes] BIGINT NULL,
    [transaction_begin_time] DATETIME NULL,
    [is_snapshot] INT NOT NULL,
    [log_bytes] BIGINT NULL,
    [log_rsvd] BIGINT NULL,
    [action_taken] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempdb_space_usage
-- --------------------------------------------------
CREATE TABLE [dbo].[tempdb_space_usage]
(
    [collection_time] DATETIME2 NOT NULL,
    [data_size_mb] VARCHAR(100) NOT NULL,
    [data_used_mb] VARCHAR(100) NOT NULL,
    [data_used_pct] DECIMAL(5, 2) NOT NULL,
    [log_size_mb] VARCHAR(100) NOT NULL,
    [log_used_mb] VARCHAR(100) NULL,
    [log_used_pct] DECIMAL(5, 2) NULL,
    [version_store_mb] DECIMAL(20, 2) NULL,
    [version_store_pct] DECIMAL(20, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.wait_stats
-- --------------------------------------------------
CREATE TABLE [dbo].[wait_stats]
(
    [collection_time_utc] DATETIME2 NOT NULL,
    [wait_type] NVARCHAR(60) NOT NULL,
    [waiting_tasks_count] BIGINT NOT NULL,
    [wait_time_ms] BIGINT NOT NULL,
    [max_wait_time_ms] BIGINT NOT NULL,
    [signal_wait_time_ms] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WhoIsActive
-- --------------------------------------------------
CREATE TABLE [dbo].[WhoIsActive]
(
    [collection_time] DATETIME NOT NULL,
    [session_id] SMALLINT NOT NULL,
    [program_name] NVARCHAR(128) NULL,
    [login_name] NVARCHAR(128) NOT NULL,
    [database_name] NVARCHAR(128) NULL,
    [CPU] BIGINT NULL,
    [used_memory] BIGINT NOT NULL,
    [open_tran_count] SMALLINT NULL,
    [status] VARCHAR(30) NOT NULL,
    [wait_info] NVARCHAR(4000) NULL,
    [sql_command] NVARCHAR(MAX) NULL,
    [blocked_session_count] SMALLINT NULL,
    [blocking_session_id] SMALLINT NULL,
    [sql_text] NVARCHAR(MAX) NULL,
    [avg_elapsed_time] INT NULL,
    [physical_io] BIGINT NULL,
    [reads] BIGINT NULL,
    [physical_reads] BIGINT NULL,
    [writes] BIGINT NULL,
    [tempdb_allocations] BIGINT NULL,
    [tempdb_current] BIGINT NULL,
    [context_switches] BIGINT NULL,
    [max_used_memory] BIGINT NULL,
    [requested_memory] BIGINT NULL,
    [granted_memory] BIGINT NULL,
    [tasks] SMALLINT NULL,
    [tran_start_time] DATETIME NULL,
    [tran_log_writes] NVARCHAR(4000) NULL,
    [implicit_tran] NVARCHAR(3) NULL,
    [query_plan] XML NULL,
    [percent_complete] REAL NULL,
    [host_name] NVARCHAR(128) NULL,
    [additional_info] XML NULL,
    [memory_info] XML NULL,
    [start_time] DATETIME NOT NULL,
    [login_time] DATETIME NULL,
    [request_id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xevent_metrics
-- --------------------------------------------------
CREATE TABLE [dbo].[xevent_metrics]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [event_name] NVARCHAR(60) NOT NULL,
    [session_id] INT NOT NULL,
    [request_id] INT NOT NULL,
    [result] VARCHAR(50) NULL,
    [database_name] VARCHAR(255) NULL,
    [client_app_name] VARCHAR(255) NULL,
    [username] VARCHAR(255) NULL,
    [cpu_time_ms] BIGINT NULL,
    [duration_seconds] BIGINT NULL,
    [logical_reads] BIGINT NULL,
    [physical_reads] BIGINT NULL,
    [row_count] BIGINT NULL,
    [writes] BIGINT NULL,
    [spills] BIGINT NULL,
    [client_hostname] VARCHAR(255) NULL,
    [session_resource_pool_id] INT NULL,
    [session_resource_group_id] INT NULL,
    [scheduler_id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xevent_metrics_Processed_XEL_Files
-- --------------------------------------------------
CREATE TABLE [dbo].[xevent_metrics_Processed_XEL_Files]
(
    [file_path] VARCHAR(2000) NOT NULL,
    [collection_time_utc] DATETIME2 NOT NULL DEFAULT (sysutcdatetime()),
    [is_processed] BIT NOT NULL DEFAULT ((0)),
    [is_removed_from_disk] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.xevent_metrics_queries
-- --------------------------------------------------
CREATE TABLE [dbo].[xevent_metrics_queries]
(
    [row_id] BIGINT NOT NULL,
    [start_time] DATETIME2 NOT NULL,
    [event_time] DATETIME2 NOT NULL,
    [sql_text] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.tgr_insert_resource_consumption
-- --------------------------------------------------

create trigger dbo.tgr_insert_resource_consumption on dbo.vw_resource_consumption
instead of insert as
begin
	set nocount on;

	insert dbo.resource_consumption
	(	[row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id] )
	select [row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id]
	from inserted;

	insert dbo.resource_consumption_queries
	(	[row_id], [start_time], [event_time], [sql_text] )
	select [row_id], [start_time], [event_time], [sql_text]
	from inserted;
end

GO

-- --------------------------------------------------
-- TRIGGER dbo.tgr_insert_xevent_metrics
-- --------------------------------------------------

create trigger dbo.tgr_insert_xevent_metrics on dbo.vw_xevent_metrics
instead of insert as
begin
	set nocount on;

	insert dbo.xevent_metrics
	(	[row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id] )
	select [row_id], [start_time], [event_time], [event_name], [session_id], [request_id], [result], [database_name], 
		[client_app_name], [username], [cpu_time_ms], [duration_seconds], [logical_reads], [physical_reads], [row_count], 
		[writes], [spills], [client_hostname], [session_resource_pool_id], [session_resource_group_id], [scheduler_id]
	from inserted;

	insert dbo.xevent_metrics_queries
	(	[row_id], [start_time], [event_time], [sql_text] )
	select [row_id], [start_time], [event_time], [sql_text]
	from inserted;
end

GO

-- --------------------------------------------------
-- VIEW dbo.vw_disk_space
-- --------------------------------------------------
CREATE view dbo.vw_disk_space
--with schemabinding
as
with cte_disk_space_local as (select collection_time_utc, host_name, disk_volume, label, capacity_mb, free_mb, block_size, filesystem from dbo.disk_space)
--,cte_disk_space_datasource as (select collection_time_utc, host_name, disk_volume, label, capacity_mb, free_mb, block_size, filesystem from [SQL2019].DBA.dbo.disk_space)

select collection_time_utc, host_name, disk_volume, label, capacity_mb, free_mb, block_size, filesystem from cte_disk_space_local
--union all
--select collection_time_utc, host_name, disk_volume, label, capacity_mb, free_mb, block_size, filesystem from cte_disk_space_datasource

GO

-- --------------------------------------------------
-- VIEW dbo.vw_file_io_stats_deltas
-- --------------------------------------------------

CREATE VIEW [dbo].[vw_file_io_stats_deltas]
WITH SCHEMABINDING 
AS
WITH RowDates as ( 
	SELECT ROW_NUMBER() OVER (ORDER BY [collection_time_utc]) ID, [collection_time_utc]
	FROM [dbo].[file_io_stats] 
	--WHERE [collection_time_utc] between @start_time and @end_time
	GROUP BY [collection_time_utc]
)
, collection_time_utcs as
(	SELECT ThisDate.collection_time_utc, LastDate.collection_time_utc as Previouscollection_time_utc
    FROM RowDates ThisDate
    JOIN RowDates LastDate
    ON ThisDate.ID = LastDate.ID + 1
)
, [t_DiskDrives] AS 
(	select ds.disk_volume
	from dbo.disk_space ds
	where ds.collection_time_utc = (select max(i.collection_time_utc) from dbo.disk_space i)
)
--select * from collection_time_utcs
SELECT s.collection_time_utc, s.database_name, dv.disk_volume, s.[file_logical_name], s.[file_location],
		[sample_ms_delta] = s.sample_ms - sPrior.sample_ms,
		[elapsed_seconds] = DATEDIFF(ss, sPrior.collection_time_utc, s.collection_time_utc),
		[read_write_bytes_delta] = ( (s.[num_of_bytes_read]+s.[num_of_bytes_written]) - (sPrior.[num_of_bytes_read]+sPrior.[num_of_bytes_written]) ),
		[read_writes_delta] = ( (s.[num_of_reads]+s.[num_of_writes]) - (sPrior.[num_of_reads]+sPrior.[num_of_writes]) ),  
		[read_bytes_delta] = s.[num_of_bytes_read] - sPrior.[num_of_bytes_read],
		[writes_bytes_delta] = s.[num_of_bytes_read] - sPrior.[num_of_bytes_read],
		[num_of_reads_delta] = s.[num_of_reads] - sPrior.[num_of_reads],
		[num_of_writes_delta] = s.[num_of_writes] - sPrior.[num_of_writes],
		[io_stall_delta] = s.[io_stall]- sPrior.[io_stall]
FROM [dbo].[file_io_stats] s
INNER JOIN collection_time_utcs Dates
	ON Dates.collection_time_utc = s.collection_time_utc
INNER JOIN [dbo].[file_io_stats] sPrior 
	ON s.[database_name] = sPrior.[database_name] 
	AND s.[file_logical_name] = sPrior.[file_logical_name] 
	AND Dates.Previouscollection_time_utc = sPrior.collection_time_utc
OUTER APPLY (
			select top 1 dd.disk_volume
			from [t_DiskDrives] dd
			where s.file_location like (dd.disk_volume+'%')
			order by len(dd.disk_volume) desc
		) dv
WHERE [s].[io_stall] >= [sPrior].[io_stall]
--ORDER BY s.collection_time_utc, wait_time_ms_delta desc

GO

-- --------------------------------------------------
-- VIEW dbo.vw_os_task_list
-- --------------------------------------------------
CREATE view dbo.vw_os_task_list
--with schemabinding
as
with cte_os_tasks_local as (select [collection_time_utc], [host_name], [task_name], [pid], [session_name], [memory_kb], [status], [user_name], [cpu_time], [cpu_time_seconds], [window_title] from dbo.os_task_list)
--,cte_os_tasks_datasource as (select [collection_time_utc], [host_name], [task_name], [pid], [session_name], [memory_kb], [status], [user_name], [cpu_time], [cpu_time_seconds], [window_title] from [SQL2019].DBA.dbo.os_task_list)

select [collection_time_utc], [host_name], [task_name], [pid], [session_name], [memory_kb], [status], [user_name], [cpu_time], [cpu_time_seconds], [window_title] from cte_os_tasks_local
--union all
--select [collection_time_utc], [host_name], [task_name], [pid], [session_name], [memory_kb], [status], [user_name], [cpu_time], [cpu_time_seconds], [window_title] from cte_os_tasks_datasource

GO

-- --------------------------------------------------
-- VIEW dbo.vw_performance_counters
-- --------------------------------------------------
CREATE view dbo.vw_performance_counters
--with schemabinding
as
with cte_counters_local as (select collection_time_utc, host_name, object, counter, value, instance from dbo.performance_counters)
--,cte_counters_datasource as (select collection_time_utc, host_name, object, counter, value, instance from [SQL2019].DBA.dbo.performance_counters)

select collection_time_utc, host_name, object, counter, value, instance from cte_counters_local --with (forceseek)
--union all
--select collection_time_utc, host_name, object, counter, value, instance from cte_counters_datasource

GO

-- --------------------------------------------------
-- VIEW dbo.vw_resource_consumption
-- --------------------------------------------------

CREATE VIEW [dbo].[vw_resource_consumption]
WITH SCHEMABINDING 
AS
SELECT rc.[row_id], rc.[start_time], rc.[event_time], rc.[event_name], rc.[session_id], rc.[request_id], rc.[result], rc.[database_name], rc.[client_app_name], rc.[username], rc.[cpu_time_ms], rc.[duration_seconds], rc.[logical_reads], rc.[physical_reads], rc.[row_count], rc.[writes], rc.[spills], txt.[sql_text], /* rc.[query_hash], rc.[query_plan_hash], */ rc.[client_hostname], rc.[session_resource_pool_id], rc.[session_resource_group_id], rc.[scheduler_id]
FROM [dbo].[resource_consumption] rc
LEFT JOIN [dbo].[resource_consumption_queries] txt
	ON rc.event_time = txt.event_time
	AND rc.start_time = txt.start_time
	AND rc.row_id = txt.row_id

GO

-- --------------------------------------------------
-- VIEW dbo.vw_wait_stats_deltas
-- --------------------------------------------------

CREATE VIEW [dbo].[vw_wait_stats_deltas]
WITH SCHEMABINDING 
AS
WITH RowDates as ( 
	SELECT ROW_NUMBER() OVER (ORDER BY [collection_time_utc]) ID, [collection_time_utc]
	FROM [dbo].[wait_stats] 
	--WHERE [collection_time_utc] between @start_time and @end_time
	GROUP BY [collection_time_utc]
)
, collection_time_utcs as
(	SELECT ThisDate.collection_time_utc, LastDate.collection_time_utc as Previouscollection_time_utc
    FROM RowDates ThisDate
    JOIN RowDates LastDate
    ON ThisDate.ID = LastDate.ID + 1
)
--select * from collection_time_utcs
SELECT	w.collection_time_utc, w.wait_type, 
		COALESCE(wc.WaitCategory, 'Other') AS WaitCategory, 
		COALESCE(wc.Ignorable,0) AS Ignorable,
		COALESCE(wc.IgnorableOnPerCoreMetric,wc.Ignorable,0) AS IgnorableOnPerCoreMetric,
		COALESCE(wc.IgnorableOnDashboard,wc.Ignorable,0) AS IgnorableOnDashboard
		,DATEDIFF(ss, wPrior.collection_time_utc, w.collection_time_utc) AS ElapsedSeconds
		,(w.wait_time_ms - wPrior.wait_time_ms) AS wait_time_ms_delta
		,(w.wait_time_ms - wPrior.wait_time_ms) / 60000.0 AS wait_time_minutes_delta
		,(w.wait_time_ms - wPrior.wait_time_ms) / 1000.0 / DATEDIFF(ss, wPrior.collection_time_utc, w.collection_time_utc) AS wait_time_minutes_per_minute
		,(w.signal_wait_time_ms - wPrior.signal_wait_time_ms) AS signal_wait_time_ms_delta
		,(w.waiting_tasks_count - wPrior.waiting_tasks_count) AS waiting_tasks_count_delta
FROM [dbo].[wait_stats] w
--INNER HASH JOIN collection_time_utcs Dates
INNER JOIN collection_time_utcs Dates
ON Dates.collection_time_utc = w.collection_time_utc
INNER JOIN [dbo].[wait_stats] wPrior ON w.wait_type = wPrior.wait_type AND Dates.Previouscollection_time_utc = wPrior.collection_time_utc
LEFT OUTER JOIN [dbo].[BlitzFirst_WaitStats_Categories] wc ON w.wait_type = wc.WaitType
WHERE [w].[wait_time_ms] >= [wPrior].[wait_time_ms]
--ORDER BY w.collection_time_utc, wait_time_ms_delta desc

GO

-- --------------------------------------------------
-- VIEW dbo.vw_xevent_metrics
-- --------------------------------------------------

CREATE VIEW [dbo].[vw_xevent_metrics]
WITH SCHEMABINDING 
AS
SELECT rc.[row_id], rc.[start_time], rc.[event_time], rc.[event_name], rc.[session_id], rc.[request_id], rc.[result], rc.[database_name], rc.[client_app_name], rc.[username], rc.[cpu_time_ms], rc.[duration_seconds], rc.[logical_reads], rc.[physical_reads], rc.[row_count], rc.[writes], rc.[spills], txt.[sql_text], /* rc.[query_hash], rc.[query_plan_hash], */ rc.[client_hostname], rc.[session_resource_pool_id], rc.[session_resource_group_id], rc.[scheduler_id]
FROM [dbo].[xevent_metrics] rc
LEFT JOIN [dbo].[xevent_metrics_queries] txt
	ON rc.event_time = txt.event_time
	AND rc.start_time = txt.start_time
	AND rc.row_id = txt.row_id

GO

