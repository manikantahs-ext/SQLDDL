-- DDL Export
-- Server: 10.253.50.28
-- Database: ReportServer
-- Exported: 2026-02-03T02:30:35.694116

USE ReportServer;
GO

-- --------------------------------------------------
-- CHECK dbo.ChunkSegmentMapping
-- --------------------------------------------------
ALTER TABLE [dbo].[ChunkSegmentMapping] ADD CONSTRAINT [Positive_StartByte] CHECK ([StartByte]>=(0))

GO

-- --------------------------------------------------
-- CHECK dbo.ChunkSegmentMapping
-- --------------------------------------------------
ALTER TABLE [dbo].[ChunkSegmentMapping] ADD CONSTRAINT [Positive_LogicalByteCount] CHECK ([LogicalByteCount]>=(0))

GO

-- --------------------------------------------------
-- CHECK dbo.ChunkSegmentMapping
-- --------------------------------------------------
ALTER TABLE [dbo].[ChunkSegmentMapping] ADD CONSTRAINT [Positive_ActualByteCount] CHECK ([ActualByteCount]>=(0))

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ActiveSubscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[ActiveSubscriptions] ADD CONSTRAINT [FK_ActiveSubscriptions_Subscriptions] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([SubscriptionID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.AlertSubscribers
-- --------------------------------------------------
ALTER TABLE [dbo].[AlertSubscribers] ADD CONSTRAINT [FK_AlertSubscribers_Catalog] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.AlertSubscribers
-- --------------------------------------------------
ALTER TABLE [dbo].[AlertSubscribers] ADD CONSTRAINT [FK_AlertSubscribers_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.CachePolicy
-- --------------------------------------------------
ALTER TABLE [dbo].[CachePolicy] ADD CONSTRAINT [FK_CachePolicyReportID] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [FK_Catalog_CreatedByID] FOREIGN KEY ([CreatedByID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [FK_Catalog_LinkSourceID] FOREIGN KEY ([LinkSourceID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [FK_Catalog_ModifiedByID] FOREIGN KEY ([ModifiedByID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [FK_Catalog_ParentID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [FK_Catalog_Policy] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[Policies] ([PolicyID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.CatalogItemExtendedContent
-- --------------------------------------------------
ALTER TABLE [dbo].[CatalogItemExtendedContent] ADD CONSTRAINT [FK_CatalogItemExtendedContent_Catalog] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Comments
-- --------------------------------------------------
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Catalog] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Comments
-- --------------------------------------------------
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_CatalogResource] FOREIGN KEY ([AttachmentID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Comments
-- --------------------------------------------------
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Comments] FOREIGN KEY ([ThreadID]) REFERENCES [dbo].[Comments] ([CommentID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Comments
-- --------------------------------------------------
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [FK_Comments_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DataModelDataSource
-- --------------------------------------------------
ALTER TABLE [dbo].[DataModelDataSource] ADD CONSTRAINT [FK_DataModelDataSource_Catalog] FOREIGN KEY ([ItemId]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DataModelRole
-- --------------------------------------------------
ALTER TABLE [dbo].[DataModelRole] ADD CONSTRAINT [FK_DataModelRole_Catalog] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DataSets
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSets] ADD CONSTRAINT [FK_DataSetItemID] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DataSets
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSets] ADD CONSTRAINT [FK_DataSetLinkID] FOREIGN KEY ([LinkID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DataSource
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSource] ADD CONSTRAINT [FK_DataSourceItemID] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Favorites
-- --------------------------------------------------
ALTER TABLE [dbo].[Favorites] ADD CONSTRAINT [FK_Favorites_Catalog] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Favorites
-- --------------------------------------------------
ALTER TABLE [dbo].[Favorites] ADD CONSTRAINT [FK_Favorites_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ModelDrill
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelDrill] ADD CONSTRAINT [FK_ModelDrillModel] FOREIGN KEY ([ModelID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ModelDrill
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelDrill] ADD CONSTRAINT [FK_ModelDrillReport] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ModelItemPolicy
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelItemPolicy] ADD CONSTRAINT [FK_PoliciesPolicyID] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[Policies] ([PolicyID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ModelPerspective
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelPerspective] ADD CONSTRAINT [FK_ModelPerspectiveModel] FOREIGN KEY ([ModelID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Notifications
-- --------------------------------------------------
ALTER TABLE [dbo].[Notifications] ADD CONSTRAINT [FK_Notifications_Subscriptions] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([SubscriptionID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.PolicyUserRole
-- --------------------------------------------------
ALTER TABLE [dbo].[PolicyUserRole] ADD CONSTRAINT [FK_PolicyUserRole_Policy] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[Policies] ([PolicyID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.PolicyUserRole
-- --------------------------------------------------
ALTER TABLE [dbo].[PolicyUserRole] ADD CONSTRAINT [FK_PolicyUserRole_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([RoleID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.PolicyUserRole
-- --------------------------------------------------
ALTER TABLE [dbo].[PolicyUserRole] ADD CONSTRAINT [FK_PolicyUserRole_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ReportSchedule
-- --------------------------------------------------
ALTER TABLE [dbo].[ReportSchedule] ADD CONSTRAINT [FK_ReportSchedule_Report] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ReportSchedule
-- --------------------------------------------------
ALTER TABLE [dbo].[ReportSchedule] ADD CONSTRAINT [FK_ReportSchedule_Schedule] FOREIGN KEY ([ScheduleID]) REFERENCES [dbo].[Schedule] ([ScheduleID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ReportSchedule
-- --------------------------------------------------
ALTER TABLE [dbo].[ReportSchedule] ADD CONSTRAINT [FK_ReportSchedule_Subscriptions] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([SubscriptionID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Schedule
-- --------------------------------------------------
ALTER TABLE [dbo].[Schedule] ADD CONSTRAINT [FK_Schedule_Users] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SecData
-- --------------------------------------------------
ALTER TABLE [dbo].[SecData] ADD CONSTRAINT [FK_SecDataPolicyID] FOREIGN KEY ([PolicyID]) REFERENCES [dbo].[Policies] ([PolicyID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SubscriptionHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[SubscriptionHistory] ADD CONSTRAINT [FK_SubscriptionHistory_Subscriptions] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([SubscriptionID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.SubscriptionResults
-- --------------------------------------------------
ALTER TABLE [dbo].[SubscriptionResults] ADD CONSTRAINT [FK_SubscriptionResults_Subscriptions] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([SubscriptionID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Subscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [FK_Subscriptions_Catalog] FOREIGN KEY ([Report_OID]) REFERENCES [dbo].[Catalog] ([ItemID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Subscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [FK_Subscriptions_ModifiedBy] FOREIGN KEY ([ModifiedByID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.Subscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [FK_Subscriptions_Owner] FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserContactInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[UserContactInfo] ADD CONSTRAINT [FK_UserContactInfo_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserDataModelRole
-- --------------------------------------------------
ALTER TABLE [dbo].[UserDataModelRole] ADD CONSTRAINT [FK_UserDataModelRole_DataModelRole] FOREIGN KEY ([DataModelRoleID]) REFERENCES [dbo].[DataModelRole] ([DataModelRoleID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserDataModelRole
-- --------------------------------------------------
ALTER TABLE [dbo].[UserDataModelRole] ADD CONSTRAINT [FK_UserDataModelRole_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])

GO

-- --------------------------------------------------
-- FUNCTION dbo.ExtendedCatalog
-- --------------------------------------------------
CREATE FUNCTION [dbo].[ExtendedCatalog]
    (@OwnerID as uniqueidentifier,
     @Path as nvarchar(425),
     @EditSessionID as varchar(32))
RETURNS TABLE
AS RETURN
(
SELECT TOP 1 * FROM (
SELECT
    C.[ItemID],
    C.[PolicyID],
    C.[Path],
    C.[Name],
    C.[Description],
    C.[Property],
    C.[Type],
    C.[ExecutionFlag],
    C.[Parameter],
    C.[Intermediate],
    CONVERT(BIT, 1) AS IntermediateIsPermanent,
    C.[SnapshotDataID],
    C.[LinkSourceID],
    C.[ExecutionTime],
    C.[SnapshotLimit],
    C.[CreatedByID],
    C.[ModifiedByID],
    C.[CreationDate],
    C.[ModifiedDate],
    C.[MimeType],
    C.[Content],
	C.[ContentSize],
    C.[Hidden],
    NULL AS [EditSessionID],
    C.[SubType],
    C.[ComponentID],
	C.[ParentID]
FROM [Catalog] C
WHERE C.Path = @Path AND @EditSessionID IS NULL
UNION ALL
SELECT
    TC.[TempCatalogID],
    NULL as [PolicyID],
    TC.[ContextPath],
    TC.[Name],
    TC.[Description],
    TC.[Property],
    2 as [Type],
    1 as [ExecutionFlag],
    TC.[Parameter],
    TC.[Intermediate],
    TC.[IntermediateIsPermanent],
    NULL as [SnapshotDataID],
    NULL as [LinkSourceID],
    NULL as [ExecutionTime],
    0 as [SnapshotLimit],
    TC.[OwnerID] as [CreatedByID],
    TC.[OwnerID] as [ModifiedByID],
    TC.[CreationTime] as [CreationDate],
    TC.[CreationTime] as [ModifiedDate],
    NULL as [MimeType],
    TC.Content,
	DATALENGTH(TC.[Content]) AS [ContentSize],
    convert(bit, 0) as [Hidden],
    TC.[EditSessionID] AS [EditSessionID],
    NULL as [SubType],
    NULL as [ComponentID],
	NULL as [ParentID]
FROM [ReportServerTempDB].dbo.TempCatalog TC
WHERE	TC.OwnerID = @OwnerID AND
        TC.ContextPath = @Path AND
        TC.EditSessionID = @EditSessionID
) A )

GO

-- --------------------------------------------------
-- INDEX dbo.Batch
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Batch] ON [dbo].[Batch] ([BatchID], [AddedOn])

GO

-- --------------------------------------------------
-- INDEX dbo.Batch
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Batch_1] ON [dbo].[Batch] ([AddedOn])

GO

-- --------------------------------------------------
-- INDEX dbo.CachePolicy
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_CachePolicyReportID] ON [dbo].[CachePolicy] ([ReportID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_Catalog] ON [dbo].[Catalog] ([Path])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ComponentLookup] ON [dbo].[Catalog] ([Type], [ComponentID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DatasetLookup] ON [dbo].[Catalog] ([Type], [ItemID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Link] ON [dbo].[Catalog] ([LinkSourceID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Parent] ON [dbo].[Catalog] ([ParentID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Policy] ON [dbo].[Catalog] ([PolicyID])

GO

-- --------------------------------------------------
-- INDEX dbo.Catalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SnapshotDataId] ON [dbo].[Catalog] ([SnapshotDataID])

GO

-- --------------------------------------------------
-- INDEX dbo.CatalogItemExtendedContent
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ItemId_CatalogItemExtendedContent] ON [dbo].[CatalogItemExtendedContent] ([ItemId], [ContentType])

GO

-- --------------------------------------------------
-- INDEX dbo.ChunkData
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_ChunkData] ON [dbo].[ChunkData] ([SnapshotDataID], [ChunkType], [ChunkName])

GO

-- --------------------------------------------------
-- INDEX dbo.ChunkSegmentMapping
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ChunkSegmentMapping_SegmentId] ON [dbo].[ChunkSegmentMapping] ([SegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.ChunkSegmentMapping
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UNIQ_ChunkId_StartByte] ON [dbo].[ChunkSegmentMapping] ([ChunkId], [StartByte]) INCLUDE ([ActualByteCount], [LogicalByteCount])

GO

-- --------------------------------------------------
-- INDEX dbo.Comments
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Comments_Item] ON [dbo].[Comments] ([ItemID])

GO

-- --------------------------------------------------
-- INDEX dbo.Comments
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Comments_Thread] ON [dbo].[Comments] ([ThreadID])

GO

-- --------------------------------------------------
-- INDEX dbo.Comments
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Comments_User] ON [dbo].[Comments] ([UserID])

GO

-- --------------------------------------------------
-- INDEX dbo.ConfigurationInfo
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_ConfigurationInfo] ON [dbo].[ConfigurationInfo] ([Name])

GO

-- --------------------------------------------------
-- INDEX dbo.DataModelDataSource
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataModelDataSource] ON [dbo].[DataModelDataSource] ([ItemId])

GO

-- --------------------------------------------------
-- INDEX dbo.DataModelDataSource
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataModelDataSource_DataSourceID] ON [dbo].[DataModelDataSource] ([DataSourceID])

GO

-- --------------------------------------------------
-- INDEX dbo.DataModelRole
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataModelRole_ItemID] ON [dbo].[DataModelRole] ([ItemID])

GO

-- --------------------------------------------------
-- INDEX dbo.DataSets
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_DataSet_ItemID_Name] ON [dbo].[DataSets] ([ItemID], [Name])

GO

-- --------------------------------------------------
-- INDEX dbo.DataSets
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataSetLinkID] ON [dbo].[DataSets] ([LinkID])

GO

-- --------------------------------------------------
-- INDEX dbo.DataSource
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataSourceItemID] ON [dbo].[DataSource] ([ItemID])

GO

-- --------------------------------------------------
-- INDEX dbo.DataSource
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataSourceSubscriptionID] ON [dbo].[DataSource] ([SubscriptionID])

GO

-- --------------------------------------------------
-- INDEX dbo.DataSource
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__DataSour__F19B4C9D808AC546] ON [dbo].[DataSource] ([DSIDNum])

GO

-- --------------------------------------------------
-- INDEX dbo.Event
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Event_TimeEntered] ON [dbo].[Event] ([TimeEntered])

GO

-- --------------------------------------------------
-- INDEX dbo.Event
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Event2] ON [dbo].[Event] ([ProcessStart])

GO

-- --------------------------------------------------
-- INDEX dbo.ExecutionLogStorage
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ExecutionLog] ON [dbo].[ExecutionLogStorage] ([TimeStart], [LogEntryId])

GO

-- --------------------------------------------------
-- INDEX dbo.Favorites
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Favorites_UserID] ON [dbo].[Favorites] ([UserID])

GO

-- --------------------------------------------------
-- INDEX dbo.History
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_History] ON [dbo].[History] ([ReportID], [SnapshotDate])

GO

-- --------------------------------------------------
-- INDEX dbo.History
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SnapshotDataID] ON [dbo].[History] ([SnapshotDataID])

GO

-- --------------------------------------------------
-- INDEX dbo.ModelDrill
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_ModelDrillModelID] ON [dbo].[ModelDrill] ([ModelID], [ReportID], [ModelDrillID])

GO

-- --------------------------------------------------
-- INDEX dbo.ModelItemPolicy
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_ModelItemPolicy] ON [dbo].[ModelItemPolicy] ([CatalogItemID], [ModelItemID])

GO

-- --------------------------------------------------
-- INDEX dbo.ModelPerspective
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_ModelPerspective] ON [dbo].[ModelPerspective] ([ModelID])

GO

-- --------------------------------------------------
-- INDEX dbo.Notifications
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Notifications] ON [dbo].[Notifications] ([ProcessAfter])

GO

-- --------------------------------------------------
-- INDEX dbo.Notifications
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Notifications2] ON [dbo].[Notifications] ([ProcessStart])

GO

-- --------------------------------------------------
-- INDEX dbo.Notifications
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Notifications3] ON [dbo].[Notifications] ([NotificationEntered])

GO

-- --------------------------------------------------
-- INDEX dbo.PolicyUserRole
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_PolicyUserRole] ON [dbo].[PolicyUserRole] ([RoleID], [UserID], [PolicyID])

GO

-- --------------------------------------------------
-- INDEX dbo.ProductInfoHistory
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductInfoHistory_DateTime] ON [dbo].[ProductInfoHistory] ([DateTime])

GO

-- --------------------------------------------------
-- INDEX dbo.ReportSchedule
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ReportSchedule_ReportID] ON [dbo].[ReportSchedule] ([ReportID])

GO

-- --------------------------------------------------
-- INDEX dbo.ReportSchedule
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ReportSchedule_ScheduleID] ON [dbo].[ReportSchedule] ([ScheduleID])

GO

-- --------------------------------------------------
-- INDEX dbo.ReportSchedule
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ReportSchedule_SubscriptionID] ON [dbo].[ReportSchedule] ([SubscriptionID])

GO

-- --------------------------------------------------
-- INDEX dbo.Roles
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_Roles] ON [dbo].[Roles] ([RoleName])

GO

-- --------------------------------------------------
-- INDEX dbo.RunningJobs
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_RunningJobsStatus] ON [dbo].[RunningJobs] ([ComputerName], [JobType])

GO

-- --------------------------------------------------
-- INDEX dbo.Schedule
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_Schedule] ON [dbo].[Schedule] ([Name], [Path])

GO

-- --------------------------------------------------
-- INDEX dbo.Schedule
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ScheduleForListTask] ON [dbo].[Schedule] ([Type], [Path], [CreatedById]) INCLUDE ([Name], [StartDate], [Flags], [NextRunTime], [LastRunTime], [EndDate], [RecurrenceType], [MinutesInterval], [DaysInterval], [WeeksInterval], [DaysOfWeek], [DaysOfMonth], [Month], [MonthlyWeek], [State], [LastRunStatus], [ScheduledRunTimeout], [EventType], [EventData])

GO

-- --------------------------------------------------
-- INDEX dbo.SecData
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_SecData] ON [dbo].[SecData] ([PolicyID], [AuthType])

GO

-- --------------------------------------------------
-- INDEX dbo.SecData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SecData_NtSecDescState] ON [dbo].[SecData] ([NtSecDescState])

GO

-- --------------------------------------------------
-- INDEX dbo.Segment
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [IX_SegmentMetadata] ON [dbo].[Segment] ([SegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.SegmentedChunk
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ChunkId_SnapshotDataId] ON [dbo].[SegmentedChunk] ([ChunkId], [SnapshotDataId])

GO

-- --------------------------------------------------
-- INDEX dbo.SegmentedChunk
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UNIQ_SnapshotChunkMapping] ON [dbo].[SegmentedChunk] ([SnapshotDataId], [ChunkType], [ChunkName]) INCLUDE ([ChunkFlags], [ChunkId])

GO

-- --------------------------------------------------
-- INDEX dbo.ServerParametersInstance
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ServerParametersInstanceExpiration] ON [dbo].[ServerParametersInstance] ([Expiration])

GO

-- --------------------------------------------------
-- INDEX dbo.SnapshotData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SnapshotCleaning] ON [dbo].[SnapshotData] ([PermanentRefcount])

GO

-- --------------------------------------------------
-- INDEX dbo.SubscriptionHistory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SubscriptionHistorySubscriptionID] ON [dbo].[SubscriptionHistory] ([SubscriptionID])

GO

-- --------------------------------------------------
-- INDEX dbo.SubscriptionResults
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SubscriptionResults] ON [dbo].[SubscriptionResults] ([SubscriptionID], [ExtensionSettingsHash])

GO

-- --------------------------------------------------
-- INDEX dbo.Users
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_Users] ON [dbo].[Users] ([Sid], [UserName], [AuthType])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ActiveSubscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[ActiveSubscriptions] ADD CONSTRAINT [PK_ActiveSubscriptions] PRIMARY KEY ([ActiveID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CachePolicy
-- --------------------------------------------------
ALTER TABLE [dbo].[CachePolicy] ADD CONSTRAINT [PK_CachePolicy] PRIMARY KEY ([CachePolicyID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Catalog
-- --------------------------------------------------
ALTER TABLE [dbo].[Catalog] ADD CONSTRAINT [PK_Catalog] PRIMARY KEY ([ItemID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CatalogItemExtendedContent
-- --------------------------------------------------
ALTER TABLE [dbo].[CatalogItemExtendedContent] ADD CONSTRAINT [PK_CatalogItemExtendedContent] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ChunkData
-- --------------------------------------------------
ALTER TABLE [dbo].[ChunkData] ADD CONSTRAINT [PK_ChunkData] PRIMARY KEY ([ChunkID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ChunkSegmentMapping
-- --------------------------------------------------
ALTER TABLE [dbo].[ChunkSegmentMapping] ADD CONSTRAINT [PK_ChunkSegmentMapping] PRIMARY KEY ([ChunkId], [SegmentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CleanupLock
-- --------------------------------------------------
ALTER TABLE [dbo].[CleanupLock] ADD CONSTRAINT [PK_ID] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Comments
-- --------------------------------------------------
ALTER TABLE [dbo].[Comments] ADD CONSTRAINT [PK_Comments] PRIMARY KEY ([CommentID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ConfigurationInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[ConfigurationInfo] ADD CONSTRAINT [PK_ConfigurationInfo] PRIMARY KEY ([ConfigInfoID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataModelDataSource
-- --------------------------------------------------
ALTER TABLE [dbo].[DataModelDataSource] ADD CONSTRAINT [PK_DataModelDataSource] PRIMARY KEY ([DSID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataModelRole
-- --------------------------------------------------
ALTER TABLE [dbo].[DataModelRole] ADD CONSTRAINT [PK_DataModelRole] PRIMARY KEY ([DataModelRoleID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataSets
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSets] ADD CONSTRAINT [PK_DataSet] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataSource
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSource] ADD CONSTRAINT [PK_DataSource] PRIMARY KEY ([DSID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DataSource
-- --------------------------------------------------
ALTER TABLE [dbo].[DataSource] ADD CONSTRAINT [UQ__DataSour__F19B4C9D808AC546] UNIQUE ([DSIDNum])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DBUpgradeHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[DBUpgradeHistory] ADD CONSTRAINT [PK_DBUpgradeHistory] PRIMARY KEY ([UpgradeID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Event
-- --------------------------------------------------
ALTER TABLE [dbo].[Event] ADD CONSTRAINT [PK_Event] PRIMARY KEY ([EventID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ExecutionLogStorage
-- --------------------------------------------------
ALTER TABLE [dbo].[ExecutionLogStorage] ADD CONSTRAINT [PK__Executio__05F5D74515DA3E5D] PRIMARY KEY ([LogEntryId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Favorites
-- --------------------------------------------------
ALTER TABLE [dbo].[Favorites] ADD CONSTRAINT [PK_Favorites] PRIMARY KEY ([ItemID], [UserID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.History
-- --------------------------------------------------
ALTER TABLE [dbo].[History] ADD CONSTRAINT [PK_History] PRIMARY KEY ([HistoryID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Keys
-- --------------------------------------------------
ALTER TABLE [dbo].[Keys] ADD CONSTRAINT [PK_Keys] PRIMARY KEY ([InstallationID], [Client])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ModelDrill
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelDrill] ADD CONSTRAINT [PK_ModelDrill] PRIMARY KEY ([ModelDrillID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ModelItemPolicy
-- --------------------------------------------------
ALTER TABLE [dbo].[ModelItemPolicy] ADD CONSTRAINT [PK_ModelItemPolicy] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Notifications
-- --------------------------------------------------
ALTER TABLE [dbo].[Notifications] ADD CONSTRAINT [PK_Notifications] PRIMARY KEY ([NotificationID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Policies
-- --------------------------------------------------
ALTER TABLE [dbo].[Policies] ADD CONSTRAINT [PK_Policies] PRIMARY KEY ([PolicyID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PolicyUserRole
-- --------------------------------------------------
ALTER TABLE [dbo].[PolicyUserRole] ADD CONSTRAINT [PK_PolicyUserRole] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ProductInfoHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[ProductInfoHistory] ADD CONSTRAINT [IX_ProductInfoHistory_DateTime] UNIQUE ([DateTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Roles
-- --------------------------------------------------
ALTER TABLE [dbo].[Roles] ADD CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.RunningJobs
-- --------------------------------------------------
ALTER TABLE [dbo].[RunningJobs] ADD CONSTRAINT [PK_RunningJobs] PRIMARY KEY ([JobID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Schedule
-- --------------------------------------------------
ALTER TABLE [dbo].[Schedule] ADD CONSTRAINT [IX_Schedule] UNIQUE ([Name], [Path])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Schedule
-- --------------------------------------------------
ALTER TABLE [dbo].[Schedule] ADD CONSTRAINT [PK_ScheduleID] PRIMARY KEY ([ScheduleID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SecData
-- --------------------------------------------------
ALTER TABLE [dbo].[SecData] ADD CONSTRAINT [PK_SecData] PRIMARY KEY ([SecDataID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Segment
-- --------------------------------------------------
ALTER TABLE [dbo].[Segment] ADD CONSTRAINT [PK_Segment] PRIMARY KEY ([SegmentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SegmentedChunk
-- --------------------------------------------------
ALTER TABLE [dbo].[SegmentedChunk] ADD CONSTRAINT [PK_SegmentedChunk] PRIMARY KEY ([SegmentedChunkId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ServerParametersInstance
-- --------------------------------------------------
ALTER TABLE [dbo].[ServerParametersInstance] ADD CONSTRAINT [PK_ServerParametersInstance] PRIMARY KEY ([ServerParametersID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ServerUpgradeHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[ServerUpgradeHistory] ADD CONSTRAINT [PK_ServerUpgradeHistory] PRIMARY KEY ([UpgradeID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SnapshotData
-- --------------------------------------------------
ALTER TABLE [dbo].[SnapshotData] ADD CONSTRAINT [PK_SnapshotData] PRIMARY KEY ([SnapshotDataID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SubscriptionHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[SubscriptionHistory] ADD CONSTRAINT [PK_SubscriptionHistory] PRIMARY KEY ([SubscriptionHistoryID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SubscriptionResults
-- --------------------------------------------------
ALTER TABLE [dbo].[SubscriptionResults] ADD CONSTRAINT [PK_SubscriptionResults] PRIMARY KEY ([SubscriptionResultID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Subscriptions
-- --------------------------------------------------
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [PK_Subscriptions] PRIMARY KEY ([SubscriptionID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SubscriptionsBeingDeleted
-- --------------------------------------------------
ALTER TABLE [dbo].[SubscriptionsBeingDeleted] ADD CONSTRAINT [PK_SubscriptionsBeingDeleted] PRIMARY KEY ([SubscriptionID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UpgradeInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[UpgradeInfo] ADD CONSTRAINT [PK_UpgradeInfo] PRIMARY KEY ([Item])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserDataModelRole
-- --------------------------------------------------
ALTER TABLE [dbo].[UserDataModelRole] ADD CONSTRAINT [PK_UserDataModelRole] PRIMARY KEY ([UserID], [DataModelRoleID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Users
-- --------------------------------------------------
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY ([UserID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddAlertSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddAlertSubscription]
    @UserID uniqueidentifier,
    @ItemID uniqueidentifier,
    @AlertType nvarchar(50)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM AlertSubscribers WHERE
    UserID = @UserID AND
    ItemID = @ItemID AND
    AlertType = @AlertType) BEGIN
        INSERT
        INTO [AlertSubscribers] (UserID, ItemID, AlertType)
        VALUES (@UserID, @ItemID, @AlertType)
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddBatchRecord
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddBatchRecord]
@BatchID uniqueidentifier,
@UserName nvarchar(260),
@Action varchar(32),
@Item nvarchar(425) = NULL,
@Parent nvarchar(425) = NULL,
@Param nvarchar(425) = NULL,
@BoolParam bit = NULL,
@Content image = NULL,
@Properties ntext = NULL
AS

IF @Action='BatchStart' BEGIN
   INSERT
   INTO [Batch] (BatchID, AddedOn, [Action], Item, Parent, Param, BoolParam, Content, Properties)
   VALUES (@BatchID, GETUTCDATE(), @Action, @UserName, @Parent, @Param, @BoolParam, @Content, @Properties)
END ELSE BEGIN
   IF EXISTS (SELECT * FROM Batch WHERE BatchID = @BatchID AND [Action] = 'BatchStart' AND Item = @UserName) BEGIN
      INSERT
      INTO [Batch] (BatchID, AddedOn, [Action], Item, Parent, Param, BoolParam, Content, Properties)
      VALUES (@BatchID, GETUTCDATE(), @Action, @Item, @Parent, @Param, @BoolParam, @Content, @Properties)
   END ELSE BEGIN
      RAISERROR( 'Batch does not exist', 16, 1 )
   END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddDataModelDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddDataModelDataSource]
    @ItemID uniqueidentifier,
    @DSType VARCHAR(100),
    @DSKind VARCHAR(100),
    @AuthType VARCHAR(100),
    @ConnectionString varbinary(max) = null,
    @Username varbinary(max) = null,
    @Password varbinary(max) = null,
    @CreatedByID uniqueidentifier,
    @ModelConnectionName varchar(260)
AS
BEGIN
DECLARE @now as datetime
SET @now = GETDATE()
INSERT INTO DataModelDataSource
         (
           [ItemId]
          ,[DSType]
          ,[DSKind]
          ,[AuthType]
          ,[ConnectionString]
          ,[Username]
          ,[Password]
          ,[CreatedByID]
          ,[CreatedDate]
          ,[ModifiedByID]
          ,[ModifiedDate]
          ,[ModelConnectionName]
          )
    VALUES
        (@ItemID,
        @DSType,
        @DSKind,
        @AuthType,
        @ConnectionString,
        @Username,
        @Password,
        @CreatedByID,
        @now,
        @CreatedByID,
        @now,
        @ModelConnectionName)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddDataModelRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddDataModelRole]
    @ItemID uniqueidentifier,
    @ModelRoleID uniqueidentifier,
    @ModelRoleName NVARCHAR(255)
AS
BEGIN
    INSERT INTO 
        [dbo].[DataModelRole]([ItemID], [ModelRoleID], [ModelRoleName])
    VALUES
        (@ItemID, @ModelRoleID, @ModelRoleName)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddDataSet
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddDataSet]
@ID [uniqueidentifier],
@ItemID [uniqueidentifier],
@EditSessionID varchar(32) = NULL,
@Name [nvarchar] (260),
@LinkID [uniqueidentifier] = NULL, -- link id is trusted, if it is provided - we use it
@LinkPath [nvarchar] (425) = NULL, -- if LinkId is not provided we try to look up LinkPath
@AuthType [int]
AS

DECLARE @ActualLinkID uniqueidentifier
SET @ActualLinkID = NULL

IF (@LinkID is NULL) AND (@LinkPath is not NULL) BEGIN
   SELECT
      ItemID, NtSecDescPrimary
   FROM
      Catalog LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
   WHERE
      Path = @LinkPath AND Type = 8
   SET @ActualLinkID = (SELECT ItemID FROM Catalog WHERE Path = @LinkPath AND Type = 8)
END
ELSE BEGIN
   SET @ActualLinkID = @LinkID
END

IF(@EditSessionID is not null)
BEGIN
    INSERT
        INTO [ReportServerTempDB].dbo.TempDataSets
            (ID, ItemID, [Name], LinkID)
        VALUES
            (@ID, @ItemID, @Name, @ActualLinkID)

    EXEC ExtendEditSessionLifetime @EditSessionID
END
ELSE
BEGIN
INSERT
    INTO DataSets
            (ID, ItemID, [Name], LinkID)
        VALUES
            (@ID, @ItemID, @Name, @ActualLinkID)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddDataSource]
@DSID [uniqueidentifier],
@ItemID [uniqueidentifier] = NULL, -- null for future suport dynamic delivery
@SubscriptionID [uniqueidentifier] = NULL,
@EditSessionID varchar(32) = NULL,
@Name [nvarchar] (260) = NULL, -- only for scoped data sources, MUST be NULL for standalone!!!
@Extension [nvarchar] (260) = NULL,
@LinkID [uniqueidentifier] = NULL, -- link id is trusted, if it is provided - we use it
@LinkPath [nvarchar] (425) = NULL, -- if LinkId is not provided we try to look up LinkPath
@CredentialRetrieval [int],
@Prompt [ntext] = NULL,
@ConnectionString [image] = NULL,
@OriginalConnectionString [image] = NULL,
@OriginalConnectStringExpressionBased [bit] = NULL,
@UserName [image] = NULL,
@Password [image] = NULL,
@Flags [int],
@AuthType [int],
@Version [int]
AS

DECLARE @ActualLinkID uniqueidentifier
SET @ActualLinkID = NULL

IF (@LinkID is NULL) AND (@LinkPath is not NULL) BEGIN
   SELECT
      Type, ItemID, NtSecDescPrimary
   FROM
      Catalog LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
   WHERE
      Path = @LinkPath
   SET @ActualLinkID = (SELECT ItemID FROM Catalog WHERE Path = @LinkPath)
END
ELSE BEGIN
   SET @ActualLinkID = @LinkID
END

IF(@EditSessionID is not null)
BEGIN
    INSERT
        INTO [ReportServerTempDB].dbo.TempDataSources
            (DSID, ItemID, [Name], Extension, Link, CredentialRetrieval,
            Prompt, ConnectionString, OriginalConnectionString, OriginalConnectStringExpressionBased,
            UserName, Password, Flags, Version)
        VALUES
            (@DSID, @ItemID, @Name, @Extension, @ActualLinkID,
            @CredentialRetrieval, @Prompt,
            @ConnectionString, @OriginalConnectionString, @OriginalConnectStringExpressionBased,
            @UserName, @Password, @Flags, @Version)

    EXEC ExtendEditSessionLifetime @EditSessionID
END
ELSE
BEGIN
INSERT
    INTO DataSource
        ([DSID], [ItemID], [SubscriptionID], [Name], [Extension], [Link],
        [CredentialRetrieval], [Prompt],
        [ConnectionString], [OriginalConnectionString], [OriginalConnectStringExpressionBased],
        [UserName], [Password], [Flags], [Version])
    VALUES
        (@DSID, @ItemID, @SubscriptionID, @Name, @Extension, @ActualLinkID,
        @CredentialRetrieval, @Prompt,
        @ConnectionString, @OriginalConnectionString, @OriginalConnectStringExpressionBased,
        @UserName, @Password, @Flags, @Version)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddEvent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddEvent]
@EventType nvarchar (260),
@EventData nvarchar (260)
AS

insert into [Event]
    ([EventID], [EventType], [EventData], [TimeEntered], [ProcessStart], [BatchID])
values
    (NewID(), @EventType, @EventData, GETUTCDATE(), NULL, NULL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddExecutionLogEntry
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddExecutionLogEntry]
@InstanceName nvarchar(38),
@Report nvarchar(260),
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@RequestType tinyint,
@Format nvarchar(26),
@Parameters ntext,
@TimeStart DateTime,
@TimeEnd DateTime,
@TimeDataRetrieval int,
@TimeProcessing int,
@TimeRendering int,
@Source tinyint,
@Status nvarchar(40),
@ByteCount bigint,
@RowCount bigint,
@ExecutionId nvarchar(64) = null,
@ReportAction tinyint,
@AdditionalInfo xml = null
AS

-- Unless is is specifically 'False', it's true
if exists (select * from ConfigurationInfo where [Name] = 'EnableExecutionLogging' and [Value] like 'False')
begin
return
end

Declare @ReportID uniqueidentifier
select @ReportID = ItemID from Catalog with (nolock) where Path = @Report

insert into ExecutionLogStorage
(InstanceName, ReportID, UserName, ExecutionId, RequestType, [Format], Parameters, ReportAction, TimeStart, TimeEnd, TimeDataRetrieval, TimeProcessing, TimeRendering, Source, Status, ByteCount, [RowCount], AdditionalInfo)
Values
(@InstanceName, @ReportID, @UserName, @ExecutionId, @RequestType, @Format, @Parameters, @ReportAction, @TimeStart, @TimeEnd, @TimeDataRetrieval, @TimeProcessing, @TimeRendering, @Source, @Status, @ByteCount, @RowCount, @AdditionalInfo)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddExecutionLogEntryByReportId
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddExecutionLogEntryByReportId]
    @InstanceName nvarchar(38),
    @ReportID uniqueidentifier,
    @UserSid varbinary(85) = NULL,
    @UserName nvarchar(260),
    @AuthType int,
    @RequestType tinyint,
    @Format nvarchar(26),
    @Parameters ntext,
    @TimeStart DateTime,
    @TimeEnd DateTime,
    @TimeDataRetrieval int,
    @TimeProcessing int,
    @TimeRendering int,
    @Source tinyint,
    @Status nvarchar(40),
    @ByteCount bigint,
    @RowCount bigint,
    @ExecutionId nvarchar(64) = null,
    @ReportAction tinyint,
    @AdditionalInfo xml = null
AS

-- Unless is is specifically 'False', it's true
IF EXISTS (SELECT * FROM ConfigurationInfo WHERE [Name] = 'EnableExecutionLogging' AND [Value] LIKE 'False')
BEGIN
    RETURN
END

INSERT INTO ExecutionLogStorage
    (InstanceName, ReportID, UserName, ExecutionId, RequestType, [Format], Parameters, ReportAction, TimeStart, TimeEnd, TimeDataRetrieval, TimeProcessing, TimeRendering, Source, Status, ByteCount, [RowCount], AdditionalInfo)
VALUES
    (@InstanceName, @ReportID, @UserName, @ExecutionId, @RequestType, @Format, @Parameters, @ReportAction, @TimeStart, @TimeEnd, @TimeDataRetrieval, @TimeProcessing, @TimeRendering, @Source, @Status, @ByteCount, @RowCount, @AdditionalInfo)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddHistoryRecord
-- --------------------------------------------------
-- add new record to History table
CREATE PROCEDURE [dbo].[AddHistoryRecord]
@HistoryID uniqueidentifier,
@ReportID uniqueidentifier,
@SnapshotDate datetime,
@SnapshotDataID uniqueidentifier,
@SnapshotTransientRefcountChange int
AS
INSERT
INTO History (HistoryID, ReportID, SnapshotDataID, SnapshotDate)
VALUES (@HistoryID, @ReportID, @SnapshotDataID, @SnapshotDate)

IF @@ERROR = 0
BEGIN
   UPDATE SnapshotData
   -- Snapshots, when created, have transient refcount set to 1. Here create permanent reference
   -- here so we need to increase permanent refcount and decrease transient refcount. However,
   -- if it was already referenced by the execution snapshot, transient refcount was already
   -- decreased. Hence, there's a parameter @SnapshotTransientRefcountChange that is 0 or -1.
   SET PermanentRefcount = PermanentRefcount + 1, TransientRefcount = TransientRefcount + @SnapshotTransientRefcountChange
   WHERE SnapshotData.SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddItemToFavorites
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddItemToFavorites]
@ItemID uniqueidentifier,
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

IF NOT EXISTS (SELECT UserID FROM [Favorites] WHERE UserID = @UserID AND ItemID = @ItemID)
BEGIN
    INSERT INTO [dbo].[Favorites] (ItemID, UserID) VALUES (@ItemID, @UserID)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddModelPerspective
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddModelPerspective]
@ModelID as uniqueidentifier,
@PerspectiveID as ntext,
@PerspectiveName as ntext = null,
@PerspectiveDescription as ntext = null
AS

INSERT
INTO [ModelPerspective]
    ([ID], [ModelID], [PerspectiveID], [PerspectiveName], [PerspectiveDescription])
VALUES
    (newid(), @ModelID, @PerspectiveID, @PerspectiveName, @PerspectiveDescription)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddPersistedStream]
@SessionID varchar(32),
@Index int
AS

DECLARE @RefCount int
DECLARE @id varchar(32)
DECLARE @ExpirationDate datetime

set @RefCount = 0
set @ExpirationDate = DATEADD(day, 2, GETDATE())

set @id = (select SessionID from [ReportServerTempDB].dbo.SessionData where SessionID = @SessionID)

if @id is not null
begin
set @RefCount = 1
end

INSERT INTO [ReportServerTempDB].dbo.PersistedStream (SessionID, [Index], [RefCount], [ExpirationDate]) VALUES (@SessionID, @Index, @RefCount, @ExpirationDate)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddProductInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddProductInfo]
    @DbSchemaHash varchar(128),
    @Sku varchar(25),
    @BuildNumber varchar(25)
AS
    INSERT INTO [dbo].[ProductInfoHistory]
        ([DbSchemaHash], [Sku], [BuildNumber])
    VALUES
        (@DbSchemaHash, @Sku, @BuildNumber)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddReportSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddReportSchedule]
@ScheduleID uniqueidentifier,
@ReportID uniqueidentifier,
@SubscriptionID uniqueidentifier = NULL,
@Action int
AS

-- VSTS #139366: SQL Deadlock in AddReportSchedule stored procedure
-- Hold lock on [Schedule].[ScheduleID] to prevent deadlock
-- with Schedule_UpdateExpiration Schedule's after update trigger
select 1 from [Schedule] with (HOLDLOCK) where [Schedule].[ScheduleID] = @ScheduleID

Insert into ReportSchedule ([ScheduleID], [ReportID], [SubscriptionID], [ReportAction]) values (@ScheduleID, @ReportID, @SubscriptionID, @Action)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddReportToCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddReportToCache]
@ReportID as uniqueidentifier,
@ExecutionDate datetime,
@SnapshotDataID uniqueidentifier,
@CacheLimit int = 0,
@EditSessionTimeout int = NULL,
@QueryParamsHash int,
@ExpirationDate datetime OUTPUT,
@ScheduleID uniqueidentifier OUTPUT
AS
DECLARE @ExpirationFlags as int
DECLARE @Timeout as int

SET @ExpirationDate = NULL
SET @ScheduleID = NULL
SET @ExpirationFlags = (SELECT ExpirationFlags FROM CachePolicy WHERE ReportID = @ReportID)
IF @EditSessionTimeout IS NOT NULL
BEGIN
    SET @ExpirationFlags = 1 -- use timeout based expiration
    SET @Timeout = @EditSessionTimeout
    SET @ExpirationDate = DATEADD(n, @Timeout, @ExecutionDate)
END
ELSE IF @ExpirationFlags = 1 -- timeout based
BEGIN
    SET @Timeout = (SELECT CacheExpiration FROM CachePolicy WHERE ReportID = @ReportID)
    SET @ExpirationDate = DATEADD(n, @Timeout, @ExecutionDate)
END
ELSE IF @ExpirationFlags = 2 -- schedule based
BEGIN
    SELECT @ScheduleID=s.ScheduleID, @ExpirationDate=s.NextRunTime
    FROM Schedule s WITH(UPDLOCK) INNER JOIN ReportSchedule rs ON rs.ScheduleID = s.ScheduleID and rs.ReportAction = 3 WHERE rs.ReportID = @ReportID
END
ELSE
BEGIN
    -- Ignore NULL case. It means that a user set the Report not to be cached after the report execution fired.
    IF @ExpirationFlags IS NOT NULL
    BEGIN
        RAISERROR('Invalid cache flags', 16, 1)
    END
    RETURN
END

-- mark any existing entries for this parameter combination to expire very soon in the future
-- note that we do not explicitly delete them here to avoid a race with execution sessions which
-- have discovered these cache entries but have not as of yet increased their transient refcounts
DECLARE @NewExpirationTime DATETIME ;
SELECT @NewExpirationTime = DATEADD(n, 1, GETDATE()) ;

BEGIN TRANSACTION

UPDATE	[ReportServerTempDB].dbo.ExecutionCache WITH (ROWLOCK) -- had deadlocks caused by page lock escalation using rowlock to avoid it.
SET		AbsoluteExpiration = @NewExpirationTime
WHERE	AbsoluteExpiration > @NewExpirationTime AND
        ReportID = @ReportID AND
        ParamsHash = @QueryParamsHash

-- add to the report cache
INSERT INTO [ReportServerTempDB].dbo.ExecutionCache
(ExecutionCacheID, ReportID, ExpirationFlags, AbsoluteExpiration, RelativeExpiration, SnapshotDataID, LastUsedTime, ParamsHash)
VALUES
(newid(), @ReportID, @ExpirationFlags, @ExpirationDate, @Timeout, @SnapshotDataID, @ExecutionDate, @QueryParamsHash)

UPDATE [ReportServerTempDB].dbo.SnapshotData
SET PermanentRefcount = PermanentRefcount + 1,
    IsCached = CONVERT(BIT, 1),
    TransientRefcount = CASE
                        WHEN @EditSessionTimeout IS NOT NULL THEN TransientRefcount - 1
                        ELSE TransientRefCount
                        END
WHERE SnapshotDataID = @SnapshotDataID;
EXEC EnforceCacheLimits @ReportID, @CacheLimit ;

COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddRunningJob
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddRunningJob]
@JobID as nvarchar(32),
@StartDate as datetime,
@ComputerName as nvarchar(32),
@RequestName as nvarchar(425),
@RequestPath as nvarchar(425),
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@Description as ntext  = NULL,
@Timeout as int,
@JobAction as smallint,
@JobType as smallint,
@JobStatus as smallint
AS
SET NOCOUNT OFF
DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

INSERT INTO RunningJobs (JobID, StartDate, ComputerName, RequestName, RequestPath, UserID, Description, Timeout, JobAction, JobType, JobStatus )
VALUES             (@JobID, @StartDate, @ComputerName,  @RequestName, @RequestPath, @UserID, @Description, @Timeout, @JobAction, @JobType, @JobStatus)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddSubscriptionHistoryEntry
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddSubscriptionHistoryEntry]
	@SubscriptionID UNIQUEIDENTIFIER,
	@Type TINYINT,
	@StartTime DATETIME,
	@Status TINYINT,
	@Message NVARCHAR(1500)
AS
BEGIN

    DECLARE @Id AS bigint

	INSERT INTO [dbo].[SubscriptionHistory]
		(SubscriptionID, Type, StartTime, Status, Message)
	VALUES
		(@SubscriptionID, @Type, @StartTime, @Status, @Message)

	SELECT @Id = SCOPE_IDENTITY()

	DELETE FROM [dbo].[SubscriptionHistory] WHERE [SubscriptionID] = @SubscriptionID AND [SubscriptionHistoryID] NOT IN (
		SELECT TOP (10) [SubscriptionHistoryID]
		  FROM [dbo].[SubscriptionHistory]
		  WHERE [SubscriptionID] = @SubscriptionID
		  ORDER BY [StartTime] DESC )

    SELECT @Id AS Id

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddSubscriptionToBeingDeleted
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddSubscriptionToBeingDeleted]
@SubscriptionID uniqueidentifier
AS
-- Delete subscription if it is already in this table
-- Delete orphaned subscriptions, based on the age criteria: > 10 minutes
delete from [SubscriptionsBeingDeleted]
where (SubscriptionID = @SubscriptionID) or (DATEDIFF( minute, [CreationDate], GetUtcDate() ) > 10)

-- Add subscription being deleted into the DeletedSubscription table
insert into [SubscriptionsBeingDeleted] VALUES(@SubscriptionID, GetUtcDate())

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AddUserDataModelRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AddUserDataModelRole]
    @UserID uniqueidentifier,
    @DataModelRoleID bigint
AS
BEGIN
    INSERT INTO 
        [dbo].[UserDataModelRole]([UserID], [DataModelRoleID])
    VALUES
        (@UserID, @DataModelRoleID)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AnnounceOrGetKey
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[AnnounceOrGetKey]
@MachineName nvarchar(256),
@InstanceName nvarchar(32),
@InstallationID uniqueidentifier,
@PublicKey image,
@NumAnnouncedServices int OUTPUT
AS

-- Acquire lock
IF NOT EXISTS (SELECT * FROM [dbo].[Keys] WITH(XLOCK) WHERE [Client] < 0)
BEGIN
    RAISERROR('Keys lock row not found', 16, 1)
    RETURN
END

-- Get the number of services that have already announced their presence
SELECT @NumAnnouncedServices = count(*)
FROM [dbo].[Keys]
WHERE [Client] = 1

DECLARE @StoredInstallationID uniqueidentifier
DECLARE @StoredInstanceName nvarchar(32)

SELECT @StoredInstallationID = [InstallationID], @StoredInstanceName = [InstanceName]
FROM [dbo].[Keys]
WHERE [InstallationID] = @InstallationID AND [Client] = 1

IF @StoredInstallationID IS NULL -- no record present
BEGIN
    INSERT INTO [dbo].[Keys]
        ([MachineName], [InstanceName], [InstallationID], [Client], [PublicKey], [SymmetricKey])
    VALUES
        (@MachineName, @InstanceName, @InstallationID, 1, @PublicKey, null)
END
ELSE
BEGIN
    IF @StoredInstanceName IS NULL
    BEGIN
        UPDATE [dbo].[Keys]
        SET [InstanceName] = @InstanceName
        WHERE [InstallationID] = @InstallationID AND [Client] = 1
    END
END

SELECT [MachineName], [SymmetricKey], [PublicKey]
FROM [Keys]
WHERE [InstallationID] = @InstallationID and [Client] = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ChangeStateOfDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ChangeStateOfDataSource]
@ItemID [uniqueidentifier],
@Enable bit
AS
IF @Enable != 0 BEGIN
   UPDATE [DataSource]
      SET
         [Flags] = [Flags] | 1
   WHERE [ItemID] = @ItemID
END
ELSE
BEGIN
   UPDATE [DataSource]
      SET
         [Flags] = [Flags] & 0x7FFFFFFE
   WHERE [ItemID] = @ItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CheckSessionLock
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CheckSessionLock]
@SessionID as varchar(32),
@LockVersion  int OUTPUT
AS
DECLARE @Selected nvarchar(32)
SELECT @Selected=SessionID, @LockVersion = LockVersion FROM [ReportServerTempDB].dbo.SessionLock WITH (ROWLOCK) WHERE SessionID = @SessionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanAllHistories
-- --------------------------------------------------
-- delete snapshots exceeding # of snapshots for the whole system
CREATE PROCEDURE [dbo].[CleanAllHistories]
@SnapshotLimit int
AS
SET NOCOUNT OFF
DELETE FROM History
WHERE HistoryID in
    (SELECT HistoryID
     FROM History JOIN Catalog AS ReportJoinSnapshot ON ItemID = ReportID
     WHERE SnapshotLimit IS NULL and SnapshotDate <
        (SELECT MIN(SnapshotDate)
         FROM
            (SELECT TOP (@SnapshotLimit) SnapshotDate
             FROM History AS InnerSnapshot
             WHERE InnerSnapshot.ReportID = ReportJoinSnapshot.ItemID
             ORDER BY SnapshotDate DESC
            ) AS TopSnapshots
        )
    )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanBatchRecords
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanBatchRecords]
@MaxAgeMinutes int
AS
SET NOCOUNT OFF
DELETE FROM [Batch]
where BatchID in
   ( SELECT BatchID
     FROM [Batch]
     WHERE AddedOn < DATEADD(minute, -(@MaxAgeMinutes), GETUTCDATE()) )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanBrokenSnapshots
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanBrokenSnapshots]
@Machine nvarchar(512),
@SnapshotsCleaned int OUTPUT,
@ChunksCleaned int OUTPUT,
@TempSnapshotID uniqueidentifier OUTPUT
AS
    SET DEADLOCK_PRIORITY LOW
    DECLARE @now AS datetime
    SELECT @now = GETDATE()

    CREATE TABLE #tempSnapshot (SnapshotDataID uniqueidentifier)
    INSERT INTO #tempSnapshot SELECT TOP 1 SnapshotDataID
    FROM SnapshotData  WITH (NOLOCK)
    where SnapshotData.PermanentRefcount <= 0
    AND ExpirationDate < @now
    SET @SnapshotsCleaned = @@ROWCOUNT

    DELETE ChunkData FROM ChunkData INNER JOIN #tempSnapshot
    ON ChunkData.SnapshotDataID = #tempSnapshot.SnapshotDataID
    SET @ChunksCleaned = @@ROWCOUNT

    DELETE SnapshotData FROM SnapshotData INNER JOIN #tempSnapshot
    ON SnapshotData.SnapshotDataID = #tempSnapshot.SnapshotDataID

    TRUNCATE TABLE #tempSnapshot

    INSERT INTO #tempSnapshot SELECT TOP 1 SnapshotDataID
    FROM [ReportServerTempDB].dbo.SnapshotData  WITH (NOLOCK)
    where [ReportServerTempDB].dbo.SnapshotData.PermanentRefcount <= 0
    AND [ReportServerTempDB].dbo.SnapshotData.ExpirationDate < @now
    AND [ReportServerTempDB].dbo.SnapshotData.Machine = @Machine
    SET @SnapshotsCleaned = @SnapshotsCleaned + @@ROWCOUNT

    SELECT @TempSnapshotID = (SELECT SnapshotDataID FROM #tempSnapshot)

    DELETE [ReportServerTempDB].dbo.ChunkData FROM [ReportServerTempDB].dbo.ChunkData INNER JOIN #tempSnapshot
    ON [ReportServerTempDB].dbo.ChunkData.SnapshotDataID = #tempSnapshot.SnapshotDataID
    SET @ChunksCleaned = @ChunksCleaned + @@ROWCOUNT

    DELETE [ReportServerTempDB].dbo.SnapshotData FROM [ReportServerTempDB].dbo.SnapshotData INNER JOIN #tempSnapshot
    ON [ReportServerTempDB].dbo.SnapshotData.SnapshotDataID = #tempSnapshot.SnapshotDataID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanEventRecords
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanEventRecords]
@MaxAgeMinutes int
AS
-- Reset all notifications which have been add over n minutes ago
Update [Event] set [ProcessStart] = NULL, [ProcessHeartbeat] = NULL
where [EventID] in
   ( SELECT [EventID]
     FROM [Event]
     WHERE [ProcessHeartbeat] < DATEADD(minute, -(@MaxAgeMinutes), GETUTCDATE()) )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanExpiredCache]
AS
SET NOCOUNT OFF
DECLARE @now as datetime
SET @now = DATEADD(minute, -1, GETDATE())

UPDATE SN
SET
   PermanentRefcount = PermanentRefcount - 1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC ON SN.SnapshotDataID = EC.SnapshotDataID
WHERE
   EC.AbsoluteExpiration < @now

DELETE EC
FROM
   [ReportServerTempDB].dbo.ExecutionCache AS EC
WHERE
   EC.AbsoluteExpiration < @now

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredContentCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanExpiredContentCache]
AS
    SET DEADLOCK_PRIORITY LOW
    SET NOCOUNT ON
    DECLARE @now as datetime

    SET @now = DATEADD(minute, -1, GETDATE())

    DELETE
    FROM
       [ReportServerTempDB].dbo.[ContentCache]
    WHERE
       ExpirationDate < @now

    SELECT @@ROWCOUNT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredEditSessions
-- --------------------------------------------------
CREATE PROC [dbo].[CleanExpiredEditSessions]
    @MaxToClean int = 10,
    @NumCleaned int OUTPUT
AS BEGIN
    SET DEADLOCK_PRIORITY LOW

    declare @now datetime;
    select @now = GETDATE();

    declare @DeletedItems table (ItemID uniqueidentifier not null primary key, Intermediate uniqueidentifier null)
    declare @DeletedCacheSnapshots table (SnapshotDataID uniqueidentifier null)

    begin transaction
        insert into @DeletedItems
        select top(@MaxToClean) TempCatalogID, Intermediate
        from [ReportServerTempDB].dbo.TempCatalog TC WITH(UPDLOCK)
        where ExpirationTime < @now and not exists (
            select 1
            from [ReportServerTempDB].dbo.SessionData SD WITH (INDEX (IX_EditSessionID))
            where SD.EditSessionID = TC.EditSessionID ) ;

        delete from [ReportServerTempDB].dbo.TempDataSources
        where ItemID in (
            select ItemID from @DeletedItems ) ;

        delete from [ReportServerTempDB].dbo.TempDataSets
        where ItemID in (
            select ItemID from @DeletedItems ) ;

        delete from [ReportServerTempDB].dbo.TempCatalog
        where TempCatalogID in (
            select ItemID from @DeletedItems ) ;

        delete from [ReportServerTempDB].dbo.ExecutionCache
        output deleted.SnapshotDataID into @DeletedCacheSnapshots(SnapshotDataID)
        where ReportID in (
            select ItemID from @DeletedItems );

        update [ReportServerTempDB].dbo.SnapshotData
        set PermanentRefcount = PermanentRefcount - 1
        where SnapshotData.SnapshotDataID in
            (select Intermediate from @DeletedItems
             union
             select SnapshotDataID from @DeletedCacheSnapshots) ;
    commit

    select @NumCleaned = count(1) from @DeletedItems ;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredJobs
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanExpiredJobs]
AS
SET NOCOUNT OFF
DELETE FROM RunningJobs WHERE DATEADD(s, Timeout, StartDate) < GETDATE()

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredServerParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanExpiredServerParameters]
@ParametersCleaned INT OUTPUT
AS
  DECLARE @now as DATETIME
  SET @now = GETDATE()

DELETE FROM [dbo].[ServerParametersInstance]
WHERE ServerParametersID IN
(  SELECT TOP 20 ServerParametersID FROM [dbo].[ServerParametersInstance]
  WHERE Expiration < @now
)

SET @ParametersCleaned = @@ROWCOUNT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanExpiredSessions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanExpiredSessions]
@SessionsCleaned int OUTPUT
AS
SET DEADLOCK_PRIORITY LOW

set @SessionsCleaned = 0;
declare @maxCleanCount int = 200;
declare @rc int;
declare @now as datetime = GETDATE();

-- Create a temp table with the same schema and collation as the source table (SessionData).
-- Use the idiom with the condition WHERE 0 = 1 to return the schema without rows and without data scan.
SELECT SessionID, SnapshotDataID, CompiledDefinition
INTO #DeletedSessions
FROM [ReportServerTempDB].dbo.SessionData
WHERE 0 = 1;

-- Delete expired sessions
--
-- In this session, we attempt to delete the first batch of expired
-- sessions. A session is considered expired if its Expiration date
-- and time is reached and that there are no locks on its corresponding
-- row in the SessionLock table. As you can see we ensure that there
-- are no locks on the corresponding SessionLock row by providing the
-- READPAST hint. The ROWLOCK hint here ensures that we only take ROWLOCKS
--
-- Delete operation is executed in the batches of 20 to avoid lock
-- escalations. See http://support.microsoft.com/kb/323630 for more
-- details.
while @SessionsCleaned < @maxCleanCount
begin

  -- Delete the locks first
  delete top(20) sl
  output s.SessionID, s.SnapshotDataID, s.CompiledDefinition into #DeletedSessions
  from [ReportServerTempDB].dbo.SessionLock sl with(rowlock, readpast)
  join [ReportServerTempDB].dbo.SessionData s with(readpast) on sl.SessionID = s.SessionID
  where s.Expiration <= @now;

  set @rc = @@ROWCOUNT;
  if @rc = 0 break;
  set @SessionsCleaned = @SessionsCleaned + @rc;

  -- Now delete the sessions that correspond to those locks
  delete top(20) l
  from [ReportServerTempDB].dbo.SessionData l
  join #DeletedSessions s on s.SessionID = l.SessionID;
end

-- Delete sessions with no corresponding locks (orphaned sessions)
--
-- In this section we attempt to find and delete any SessionData
-- rows that do not have a corresponding SessionLock row.
-- These rows are considered orphan and should be deleted.
-- As you can see below, the SessionData table is queried using
-- the READPAST hint. This means that SessionData rows that have
-- locks on do not prevent this query from being executed. Also
-- note that SessionLock is read using NOLOCK instead of READPAST.
-- This is important because we need a true view on all rows that
-- exists in the SessionLock table whether they are locked or not.
--
-- Delete operation is executed in the batches of 20 to avoid lock
-- escalations. See http://support.microsoft.com/kb/323630 for more
-- details.
while @SessionsCleaned < @maxCleanCount
begin
  delete top(20) s
  output deleted.SessionID, deleted.SnapshotDataID, deleted.CompiledDefinition into #DeletedSessions
  from [ReportServerTempDB].dbo.SessionData s with(readpast)
  left join [ReportServerTempDB].dbo.SessionLock sl with(nolock) on sl.SessionID = s.SessionID
  where sl.SessionID is null and s.Expiration <= @now;

  set @rc = @@ROWCOUNT;
  set @SessionsCleaned = @SessionsCleaned + @rc;
  if @rc < 20 break;
end

-- Was there anything to clean-up?
if @SessionsCleaned = 0 return;

-- Delete persisted streams
--
-- Delete operation is executed in the batches of 20 to avoid lock
-- escalations. See http://support.microsoft.com/kb/323630 for more
-- details.
deletePersistedStreams:
delete top(20) ps
from [ReportServerTempDB].dbo.PersistedStream as ps
join #DeletedSessions sd on ps.SessionID = sd.SessionID;
if @@ROWCOUNT = 20 goto deletePersistedStreams;

-- Update ref counts
UPDATE SN
SET
   TransientRefcount = TransientRefcount-1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   JOIN #DeletedSessions AS SE ON SN.SnapshotDataID = SE.CompiledDefinition;

UPDATE SN
SET
   TransientRefcount = TransientRefcount-
      (SELECT COUNT(*)
       FROM #DeletedSessions AS SE1
       WHERE SE1.SnapshotDataID = SN.SnapshotDataID)
FROM
   SnapshotData AS SN
   JOIN #DeletedSessions AS SE ON SN.SnapshotDataID = SE.SnapshotDataID;

UPDATE SN
SET
   TransientRefcount = TransientRefcount-
      (SELECT COUNT(*)
       FROM #DeletedSessions AS SE1
       WHERE SE1.SnapshotDataID = SN.SnapshotDataID)
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   JOIN #DeletedSessions AS SE ON SN.SnapshotDataID = SE.SnapshotDataID;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanHistoryForReport
-- --------------------------------------------------
-- delete snapshots exceeding # of snapshots. won't work if @SnapshotLimit = 0
CREATE PROCEDURE [dbo].[CleanHistoryForReport]
@SnapshotLimit int,
@ReportID uniqueidentifier
AS
SET NOCOUNT OFF
DELETE FROM History
WHERE ReportID = @ReportID and SnapshotDate <
    (SELECT MIN(SnapshotDate)
     FROM
        (SELECT TOP (@SnapshotLimit) SnapshotDate
         FROM History
         WHERE ReportID = @ReportID
         ORDER BY SnapshotDate DESC
        ) AS TopSnapshots
    )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanNotificationRecords
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanNotificationRecords]
@MaxAgeMinutes int
AS
-- Reset all notifications which have been add over n minutes ago
Update [Notifications] set [ProcessStart] = NULL, [ProcessHeartbeat] = NULL, [Attempt] = 1
where [NotificationID] in
   ( SELECT [NotificationID]
     FROM [Notifications]
     WHERE [ProcessHeartbeat] < DATEADD(minute, -(@MaxAgeMinutes), GETUTCDATE()) and [Attempt] is NULL )

Update [Notifications] set [ProcessStart] = NULL, [ProcessHeartbeat] = NULL, [Attempt] = [Attempt] + 1
where [NotificationID] in
   ( SELECT [NotificationID]
     FROM [Notifications]
     WHERE [ProcessHeartbeat] < DATEADD(minute, -(@MaxAgeMinutes), GETUTCDATE()) and [Attempt] is not NULL )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanOrphanedPolicies
-- --------------------------------------------------
-- Cleaning orphan policies
CREATE PROCEDURE [dbo].[CleanOrphanedPolicies]
AS
SET NOCOUNT OFF
DELETE
   [Policies]
WHERE
   [Policies].[PolicyFlag] = 0
   AND
   NOT EXISTS (SELECT ItemID FROM [Catalog] WHERE [Catalog].[PolicyID] = [Policies].[PolicyID])

DELETE
   [Policies]
FROM
   [Policies]
   INNER JOIN [ModelItemPolicy] ON [ModelItemPolicy].[PolicyID] = [Policies].[PolicyID]
WHERE
   NOT EXISTS (SELECT ItemID
               FROM [Catalog]
               WHERE [Catalog].[ItemID] = [ModelItemPolicy].[CatalogItemID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CleanOrphanedSnapshots
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CleanOrphanedSnapshots]
@Machine nvarchar(512),
@PermanentSnapshotCount int,
@TemporarySnapshotCount int,
@PermanentChunkCount int,
@TemporaryChunkCount int,
@PermanentMappingCount int,
@TemporaryMappingCount int,
@PermanentSegmentCount int,
@TemporarySegmentCount int,
@SnapshotsCleaned int OUTPUT,
@ChunksCleaned int OUTPUT,
@MappingsCleaned int OUTPUT,
@SegmentsCleaned int OUTPUT
AS
    SELECT	@SnapshotsCleaned = 0,
        @ChunksCleaned = 0,
        @MappingsCleaned = 0,
        @SegmentsCleaned = 0 ;

    -- use readpast rather than NOLOCK.  using
    -- nolock could cause us to identify snapshots
    -- which have had the refcount decremented but
    -- the transaction is uncommitted which is dangerous.
    -- the exception to above is when doing a SELECT subclause
    -- to determine rows to DELETE as we don't want to
    -- delete the uncommitted data.

    SET DEADLOCK_PRIORITY LOW

    -- cleanup of segmented chunk information happens
    -- top->down.  meaning we delete chunk metadata, then
    -- mappings, then segment data.  the reason for doing
    -- this is because it minimizes the io read cost since
    -- each delete step tells us the work that we need to
    -- do in the next step.  however, there is the potential
    -- for failure at any step which can leave orphaned data
    -- structures.  we have another cleanup tasks
    -- which will scavenge this orphaned data and clean it up
    -- so we don't need to be 100% robust here.  this also
    -- means that we can play tricks like using readpast in the
    -- dml operations so that concurrent deletes will minimize
    -- blocking of each other.
    -- also, we optimize this cleanup for the scenario where the chunk is
    -- not shared.  this means that if we detect that a chunk is shared
    -- we will not delete any of its mappings.  there is potential for this
    -- to miss removing a chunk because it is shared and we are concurrently
    -- deleting the other snapshot (both see the chunk as shared...).  however
    -- we don't deal with that case here, and will instead orphan the chunk
    -- mappings and segments.  that is ok, we will just remove them when we
    -- scan for orphaned mappings/segments.

    declare @cleanedSnapshots table (SnapshotDataId uniqueidentifier primary key) ;
    declare @cleanedChunks table (ChunkId uniqueidentifier) ;
    declare @cleanedChunks2 table (ChunkId uniqueidentifier primary key) ;
    declare @cleanedSegments table (ChunkId uniqueidentifier, SegmentId uniqueidentifier) ;
    declare @deleteCount int ;

    begin transaction
    -- remove the actual snapshot entry
    -- we do this transacted with cleaning up chunk
    -- data because we do not lazily clean up old ChunkData table.
    -- we also do this before cleaning up segmented chunk data to
    -- get this SnapshotData record out of the table so another parallel
    -- cleanup task does not attempt to delete it which would just cause
    -- contention and reduce cleanup throughput.
    DELETE TOP (@PermanentSnapshotCount) SnapshotData
    output deleted.SnapshotDataID into @cleanedSnapshots (SnapshotDataId)
    FROM SnapshotData with(readpast)
    WHERE   SnapshotData.PermanentRefCount <= 0 AND
            SnapshotData.TransientRefCount <= 0 ;
    SET @SnapshotsCleaned = @@ROWCOUNT;

    -- clean up RS2000/RS2005 chunks
    set @deleteCount = 20;
    while (@deleteCount = 20)
    begin
        delete top(20) c
        from ChunkData c with (readpast)
        join @cleanedSnapshots cs ON c.SnapshotDataID = cs.SnapshotDataId;

        set @deleteCount = @@ROWCOUNT;
        SET @ChunksCleaned = @ChunksCleaned + @deleteCount;
    end
    commit

    -- clean up chunks
    set @deleteCount = @PermanentChunkCount;
    while (@deleteCount = @PermanentChunkCount)
    begin
        delete top (@PermanentChunkCount) SC
        output deleted.ChunkId into @cleanedChunks(ChunkId)
        from SegmentedChunk SC with (readpast)
        join @cleanedSnapshots cs on SC.SnapshotDataId = cs.SnapshotDataId ;
        set @deleteCount = @@ROWCOUNT;
        set @ChunksCleaned =  @ChunksCleaned + @deleteCount;
    end ;

    -- This is added based on the Execution Plan. It should speed
    -- up the "clean up unused mapping" operation below.
    insert into @cleanedChunks2
    select distinct ChunkId from @cleanedChunks;

    -- clean up unused mappings
    -- using NOLOCK hint in the SELECT subquery to include the dirty uncommitted rows so
    -- that those rows are excluded from the DELETE query
    set @deleteCount = @PermanentMappingCount;
    while (@deleteCount = @PermanentMappingCount)
    begin
        delete top(@PermanentMappingCount) CSM
        output deleted.ChunkId, deleted.SegmentId into @cleanedSegments (ChunkId, SegmentId)
        from ChunkSegmentMapping CSM with (readpast)
        join @cleanedChunks2 cc ON CSM.ChunkId = cc.ChunkId
        where not exists (
            select 1 from SegmentedChunk SC with(nolock)
            where SC.ChunkId = cc.ChunkId )
        and not exists (
            select 1 from [ReportServerTempDB].dbo.SegmentedChunk TSC with(nolock)
            where TSC.ChunkId = cc.ChunkId ) ;
        set @deleteCount = @@ROWCOUNT ;
        set @MappingsCleaned = @MappingsCleaned + @deleteCount ;
    end ;

    -- clean up segments
    set @deleteCount = @PermanentSegmentCount;
    while (@deleteCount = @PermanentSegmentCount)
    begin
        delete top (@PermanentSegmentCount) S
        from Segment S with (readpast)
        join @cleanedSegments cs on S.SegmentId = cs.SegmentId
        where not exists (
            select 1 from ChunkSegmentMapping csm with (nolock)
            where csm.SegmentId = cs.SegmentId ) ;
        set @deleteCount = @@ROWCOUNT ;
        set @SegmentsCleaned = @SegmentsCleaned + @deleteCount ;
    end

    DELETE FROM @cleanedSnapshots ;
    DELETE FROM @cleanedChunks ;
    DELETE FROM @cleanedSegments ;

    begin transaction
    DELETE TOP (@TemporarySnapshotCount) [ReportServerTempDB].dbo.SnapshotData
    output deleted.SnapshotDataID into @cleanedSnapshots(SnapshotDataId)
    FROM [ReportServerTempDB].dbo.SnapshotData with(readpast)
    WHERE   [ReportServerTempDB].dbo.SnapshotData.PermanentRefCount <= 0 AND
            [ReportServerTempDB].dbo.SnapshotData.TransientRefCount <= 0 AND
            [ReportServerTempDB].dbo.SnapshotData.Machine = @Machine ;
    SET @SnapshotsCleaned = @SnapshotsCleaned + @@ROWCOUNT ;

    DELETE [ReportServerTempDB].dbo.ChunkData FROM [ReportServerTempDB].dbo.ChunkData with (readpast)
    INNER JOIN @cleanedSnapshots cs
    ON [ReportServerTempDB].dbo.ChunkData.SnapshotDataID = cs.SnapshotDataId
    SET @ChunksCleaned = @ChunksCleaned + @@ROWCOUNT
    commit

    set @deleteCount = 1 ;
    while (@deleteCount > 0)
    begin
        delete SC
        output deleted.ChunkId into @cleanedChunks(ChunkId)
        from [ReportServerTempDB].dbo.SegmentedChunk SC with (readpast)
        join @cleanedSnapshots cs on SC.SnapshotDataId = cs.SnapshotDataId ;
        set @deleteCount = @@ROWCOUNT ;
        set @ChunksCleaned =  @ChunksCleaned + @deleteCount ;
    end ;

    -- clean up unused mappings
    -- using NOLOCK hint in the SELECT subquery to include the dirty uncommitted rows so
    -- that those rows are excluded from the DELETE query
    set @deleteCount = 1 ;
    while (@deleteCount > 0)
    begin
        delete top(@TemporaryMappingCount) CSM
        output deleted.ChunkId, deleted.SegmentId into @cleanedSegments (ChunkId, SegmentId)
        from [ReportServerTempDB].dbo.ChunkSegmentMapping CSM with (readpast)
        join @cleanedChunks cc ON CSM.ChunkId = cc.ChunkId
        where not exists (
            select 1 from [ReportServerTempDB].dbo.SegmentedChunk SC with(nolock)
            where SC.ChunkId = cc.ChunkId ) ;
        set @deleteCount = @@ROWCOUNT ;
        set @MappingsCleaned = @MappingsCleaned + @deleteCount ;
    end ;

    select distinct ChunkId from @cleanedSegments ;

    -- clean up segments
    -- using NOLOCK hint in the SELECT subquery to include the dirty uncommitted rows so
    -- that those rows are excluded from the DELETE query
    set @deleteCount = 1
    while (@deleteCount > 0)
    begin
        delete top (@TemporarySegmentCount) S
        from [ReportServerTempDB].dbo.Segment S with (readpast)
        join @cleanedSegments cs on S.SegmentId = cs.SegmentId
        where not exists (
            select 1 from [ReportServerTempDB].dbo.ChunkSegmentMapping csm with(nolock)
            where csm.SegmentId = cs.SegmentId ) ;
        set @deleteCount = @@ROWCOUNT ;
        set @SegmentsCleaned = @SegmentsCleaned + @deleteCount ;
    end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ClearScheduleConsistancyFlags
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ClearScheduleConsistancyFlags]
AS
update [Schedule] with (tablock, xlock) set [ConsistancyCheck] = NULL

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ClearSessionSnapshot
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ClearSessionSnapshot]
@SessionID as varchar(32),
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260),
@AuthType as int,
@Expiration as datetime
AS

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

EXEC DereferenceSessionSnapshot @SessionID, @OwnerID

UPDATE SE
SET
   SE.SnapshotDataID = null,
   SE.IsPermanentSnapshot = null,
   SE.SnapshotExpirationDate = null,
   SE.ShowHideInfo = null,
   SE.HasInteractivity = null,
   SE.AutoRefreshSeconds = null,
   SE.Expiration = @Expiration
FROM
   [ReportServerTempDB].dbo.SessionData AS SE
WHERE
   SE.SessionID = @SessionID AND
   SE.OwnerID = @OwnerID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CommentBelongsToUser
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CommentBelongsToUser]
@CommentID bigint,
@UserSid varbinary(85),
@UserName nvarchar(260),
@AuthType int
AS
BEGIN
    DECLARE @CommentOwner uniqueidentifier
    DECLARE @CurrentUser uniqueidentifier
    EXEC GetUserID @UserSid, @UserName, @AuthType, @CurrentUser OUTPUT
    SET @CommentOwner = (SELECT TOP(1) [UserID] FROM [Comments] WHERE [CommentID] = @CommentID)
    IF @CommentOwner = @CurrentUser
        SELECT 1
    ELSE
        SELECT 0
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CopyChunks
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CopyChunks]
    @OldSnapshotId UNIQUEIDENTIFIER,
    @NewSnapshotId UNIQUEIDENTIFIER,
    @IsPermanentSnapshot BIT
AS
BEGIN
    IF(@IsPermanentSnapshot = 1) BEGIN
        -- copy non-segmented chunks
        INSERT [dbo].[ChunkData] (
            ChunkId,
            SnapshotDataId,
            ChunkFlags,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            Content
            )
        SELECT
            NEWID(),
            @NewSnapshotId,
            [c].[ChunkFlags],
            [c].[ChunkName],
            [c].[ChunkType],
            [c].[Version],
            [c].[MimeType],
            [c].[Content]
        FROM [dbo].[ChunkData] [c] WHERE [c].[SnapshotDataId] = @OldSnapshotId

        -- copy segmented chunks... real easy just add the mapping
        INSERT [dbo].[SegmentedChunk](
            ChunkId,
            SnapshotDataId,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            ChunkFlags
            )
        SELECT
            ChunkId,
            @NewSnapshotId,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            ChunkFlags
        FROM [dbo].[SegmentedChunk] WITH (INDEX (UNIQ_SnapshotChunkMapping))
        WHERE [SnapshotDataId] = @OldSnapshotId
    END
    ELSE BEGIN
        -- copy non-segmented chunks
        INSERT [ReportServerTempDB].dbo.[ChunkData] (
            ChunkId,
            SnapshotDataId,
            ChunkFlags,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            Content
            )
        SELECT
            NEWID(),
            @NewSnapshotId,
            [c].[ChunkFlags],
            [c].[ChunkName],
            [c].[ChunkType],
            [c].[Version],
            [c].[MimeType],
            [c].[Content]
        FROM [ReportServerTempDB].dbo.[ChunkData] [c] WHERE [c].[SnapshotDataId] = @OldSnapshotId

        -- copy segmented chunks... real easy just add the mapping
        INSERT [ReportServerTempDB].[dbo].[SegmentedChunk](
            ChunkId,
            SnapshotDataId,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            ChunkFlags,
            Machine
            )
        SELECT
            ChunkId,
            @NewSnapshotId,
            ChunkName,
            ChunkType,
            Version,
            MimeType,
            ChunkFlags,
            Machine
        FROM [ReportServerTempDB].dbo.[SegmentedChunk] WITH (INDEX (UNIQ_SnapshotChunkMapping))
        WHERE [SnapshotDataId] = @OldSnapshotId
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CopyChunksOfType
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CopyChunksOfType]
@FromSnapshotID uniqueidentifier,
@FromIsPermanent bit,
@ToSnapshotID uniqueidentifier,
@ToIsPermanent bit,
@ChunkType int,
@ChunkName nvarchar(260) = NULL,
@TargetChunkName nvarchar(260) = NULL
AS

DECLARE @Machine nvarchar(512)

IF @FromIsPermanent != 0 AND @ToIsPermanent = 0 BEGIN

    -- copy the contiguous chunks
    INSERT INTO [ReportServerTempDB].dbo.ChunkData
        (ChunkID, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    SELECT
         newid(), @ToSnapshotID, COALESCE(@TargetChunkName, S.ChunkName), S.ChunkType, S.MimeType, S.Version, S.ChunkFlags, S.Content
    FROM
        ChunkData AS S
    WHERE
        S.SnapshotDataID = @FromSnapshotID AND
        (S.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (S.ChunkName = @ChunkName OR @ChunkName IS NUll) AND
    NOT EXISTS(
        SELECT T.ChunkName
        FROM [ReportServerTempDB].dbo.ChunkData AS T -- exclude the ones in the target
        WHERE
            T.ChunkName = COALESCE(@TargetChunkName, S.ChunkName) AND
            T.ChunkType = S.ChunkType AND
            T.SnapshotDataID = @ToSnapshotID)


    -- the chunks will be cleaned up by the machine in which they are being allocated to
    select @Machine = Machine from [ReportServerTempDB].dbo.SnapshotData SD where SD.SnapshotDataID = @ToSnapshotID

    INSERT INTO [ReportServerTempDB].dbo.SegmentedChunk
        (SnapshotDataId, ChunkId, ChunkFlags, ChunkName, ChunkType, Version, MimeType, Machine)
    SELECT
        @ToSnapshotID, SC.ChunkId, SC.ChunkFlags | 0x4, COALESCE(@TargetChunkName, SC.ChunkName), SC.ChunkType, SC.Version, SC.MimeType, @Machine
    FROM SegmentedChunk SC WITH(INDEX (UNIQ_SnapshotChunkMapping))
    WHERE
        SC.SnapshotDataId = @FromSnapshotID AND
        (SC.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (SC.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
        NOT EXISTS(
            -- exclude chunks already in the target
            SELECT TSC.ChunkName
            FROM [ReportServerTempDB].dbo.SegmentedChunk TSC
            -- JOIN [ReportServerTempDB].dbo.SnapshotChunkMapping TSCM ON (TSC.ChunkId = TSCM.ChunkId)
            WHERE
                TSC.ChunkName = COALESCE(@TargetChunkName, SC.ChunkName) AND
                TSC.ChunkType = SC.ChunkType AND
                TSC.SnapshotDataId = @ToSnapshotID
            )

 END ELSE IF @FromIsPermanent = 0 AND @ToIsPermanent = 0 BEGIN
    -- the chunks exist on the node in which they were originally allocated on, they should
    -- be cleaned up by that node
    select @Machine = Machine from [ReportServerTempDB].dbo.SnapshotData SD where SD.SnapshotDataID = @FromSnapshotID

    INSERT INTO [ReportServerTempDB].dbo.ChunkData
        (ChunkId, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    SELECT
        newid(), @ToSnapshotID, COALESCE(@TargetChunkName, S.ChunkName), S.ChunkType, S.MimeType, S.Version, S.ChunkFlags, S.Content
    FROM
        [ReportServerTempDB].dbo.ChunkData AS S
    WHERE
        S.SnapshotDataID = @FromSnapshotID AND
        (S.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (S.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
        NOT EXISTS(
            SELECT T.ChunkName
            FROM [ReportServerTempDB].dbo.ChunkData AS T -- exclude the ones in the target
            WHERE
                T.ChunkName = COALESCE(@TargetChunkName, S.ChunkName) AND
                T.ChunkType = S.ChunkType AND
                T.SnapshotDataID = @ToSnapshotID)

    -- copy the segmented chunks, copying the segmented
    -- chunks really just needs to update the mappings
    INSERT INTO [ReportServerTempDB].dbo.SegmentedChunk
        (SnapshotDataId, ChunkId, ChunkName, ChunkType, Version, ChunkFlags, MimeType, Machine)
    SELECT
        @ToSnapshotID, ChunkId, COALESCE(@TargetChunkName, C.ChunkName), C.ChunkType, C.Version, C.ChunkFlags, C.MimeType, @Machine
    FROM [ReportServerTempDB].dbo.SegmentedChunk C WITH(INDEX (UNIQ_SnapshotChunkMapping))
    WHERE	C.SnapshotDataId = @FromSnapshotID AND
            (C.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
            (C.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
            NOT EXISTS(
                -- exclude chunks that are already mapped into this snapshot
                SELECT T.ChunkId
                FROM [ReportServerTempDB].dbo.SegmentedChunk T
                WHERE	T.SnapshotDataId = @ToSnapshotID and
                        T.ChunkName = COALESCE(@TargetChunkName, C.ChunkName) and
                        T.ChunkType = C.ChunkType
                )

END ELSE IF @FromIsPermanent != 0 AND @ToIsPermanent != 0 BEGIN

    INSERT INTO ChunkData
        (ChunkID, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    SELECT
        newid(), @ToSnapshotID, COALESCE(@TargetChunkName, S.ChunkName), S.ChunkType, S.MimeType, S.Version, S.ChunkFlags, S.Content
    FROM
        ChunkData AS S
    WHERE
        S.SnapshotDataID = @FromSnapshotID AND
        (S.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (S.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
        NOT EXISTS(
            SELECT T.ChunkName
            FROM ChunkData AS T -- exclude the ones in the target
            WHERE
                T.ChunkName = COALESCE(@TargetChunkName, S.ChunkName) AND
                T.ChunkType = S.ChunkType AND
                T.SnapshotDataID = @ToSnapshotID)

    -- copy the segmented chunks, copying the segmented
    -- chunks really just needs to update the mappings
    INSERT INTO SegmentedChunk
        (SnapshotDataId, ChunkId, ChunkName, ChunkType, Version, ChunkFlags, C.MimeType)
    SELECT
        @ToSnapshotID, ChunkId, COALESCE(@TargetChunkName, C.ChunkName), C.ChunkType, C.Version, C.ChunkFlags, C.MimeType
    FROM SegmentedChunk C WITH(INDEX (UNIQ_SnapshotChunkMapping))
    WHERE	C.SnapshotDataId = @FromSnapshotID AND
            (C.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
            (C.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
            NOT EXISTS(
                -- exclude chunks that are already mapped into this snapshot
                SELECT T.ChunkId
                FROM SegmentedChunk T
                WHERE	T.SnapshotDataId = @ToSnapshotID and
                        T.ChunkName = COALESCE(@TargetChunkName, C.ChunkName) and
                        T.ChunkType = C.ChunkType
                )

END ELSE IF @FromIsPermanent = 0 AND @ToIsPermanent != 0 BEGIN
    INSERT INTO ChunkData
        (ChunkId, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    SELECT
        newid(), @ToSnapshotID, COALESCE(@TargetChunkName, S.ChunkName), S.ChunkType, S.MimeType, S.Version, S.ChunkFlags, S.Content
    FROM
        [ReportServerTempDB].dbo.ChunkData AS S
    WHERE
        S.SnapshotDataID = @FromSnapshotID AND
        (S.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (S.ChunkName = @ChunkName OR @ChunkName IS NULL) AND
        NOT EXISTS(
            SELECT T.ChunkName
            FROM ChunkData AS T -- exclude the ones in the target
            WHERE
                T.ChunkName = COALESCE(@TargetChunkName, S.ChunkName) AND
                T.ChunkType = S.ChunkType AND
                T.SnapshotDataID = @ToSnapshotID)

    declare @mapping_temp table (ChunkId uniqueidentifier not null primary key)

    INSERT INTO SegmentedChunk
        (SnapshotDataId, ChunkId, ChunkName, ChunkType, Version, ChunkFlags, MimeType)
    OUTPUT inserted.ChunkId INTO @mapping_temp
    SELECT
        @ToSnapshotID, ChunkId, COALESCE(@TargetChunkName, C.ChunkName), C.ChunkType, C.Version, C.ChunkFlags, C.MimeType
    FROM [ReportServerTempDB].dbo.SegmentedChunk C WITH(INDEX (UNIQ_SnapshotChunkMapping))
    WHERE
        C.SnapshotDataId = @FromSnapshotID AND
        (C.ChunkType = @ChunkType OR @ChunkType IS NULL) AND
        (C.ChunkName = @ChunkName OR @ChunkName IS NULL)  AND
        NOT EXISTS(
            -- exclude chunks that are already mapped into this snapshot
            SELECT T.ChunkId
            FROM SegmentedChunk T
            WHERE    T.SnapshotDataId = @ToSnapshotID and
               T.ChunkName = COALESCE(@TargetChunkName, C.ChunkName) and
               T.ChunkType = C.ChunkType
        )

     declare @segment_temp table (SegmentId uniqueidentifier not null primary key)

     INSERT INTO ChunkSegmentMapping
         (ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount)
     OUTPUT inserted.SegmentId INTO @segment_temp
     SELECT CM.ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount
     FROM [ReportServerTempDB].dbo.ChunkSegmentMapping CM
     INNER JOIN @mapping_temp as MT on MT.ChunkId = CM.ChunkId
     WHERE
        NOT EXISTS(
            -- exclude segment mappings that already exist in the target snapshot
            SELECT CMT.ChunkId
            FROM ChunkSegmentMapping CMT
            WHERE
               CMT.ChunkId = CM.ChunkId
               and CMT.SegmentId = CM.SegmentId
        )

     INSERT INTO Segment
         (SegmentId, Content)
     SELECT CS.SegmentId, Content
     FROM [ReportServerTempDB].dbo.Segment CS
     INNER JOIN @segment_temp as ST ON CS.SegmentId = ST.SegmentId
     WHERE
        NOT EXISTS(
            -- exclude segments that already exist in the target snapshot
            SELECT CST.SegmentId
            FROM Segment CST
            WHERE
               CST.SegmentId = CS.SegmentId
        )
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateCacheUpdateNotifications
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateCacheUpdateNotifications]
@ReportID uniqueidentifier,
@LastRunTime datetime
AS

update [Subscriptions]
set
    [LastRunTime] = @LastRunTime
from
    [Subscriptions] S
where
    S.[Report_OID] = @ReportID and S.EventType = 'SnapshotUpdated' and InactiveFlags = 0


-- Find all valid subscriptions for the given report and create a new notification row for
-- each subscription
insert into [Notifications]
    (
    [NotificationID],
    [SubscriptionID],
    [ActivationID],
    [ReportID],
    [ReportZone],
    [SnapShotDate],
    [ExtensionSettings],
    [Locale],
    [Parameters],
    [NotificationEntered],
    [SubscriptionLastRunTime],
    [DeliveryExtension],
    [SubscriptionOwnerID],
    [IsDataDriven],
    [Version]
    )
select
    NewID(),
    S.[SubscriptionID],
    NULL,
    S.[Report_OID],
    S.[ReportZone],
    NULL,
    S.[ExtensionSettings],
    S.[Locale],
    S.[Parameters],
    GETUTCDATE(),
    S.[LastRunTime],
    S.[DeliveryExtension],
    S.[OwnerID],
    0,
    S.[Version]
from
    [Subscriptions] S  inner join Catalog C on S.[Report_OID] = C.[ItemID]
where
    C.[ItemID] = @ReportID and S.EventType = 'SnapshotUpdated' and InactiveFlags = 0 and
    S.[DataSettings] is null

-- Create any data driven subscription by creating a data driven event
insert into [Event]
    (
    [EventID],
    [EventType],
    [EventData],
    [TimeEntered]
    )
select
    NewID(),
    'DataDrivenSubscription',
    S.SubscriptionID,
    GETUTCDATE()
from
    [Subscriptions] S  inner join Catalog C on S.[Report_OID] = C.[ItemID]
where
    C.[ItemID] = @ReportID and S.EventType = 'SnapshotUpdated' and InactiveFlags = 0 and
    S.[DataSettings] is not null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateChunkAndGetPointer
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateChunkAndGetPointer]
@SnapshotDataID uniqueidentifier,
@IsPermanentSnapshot bit,
@ChunkName nvarchar(260),
@ChunkType int,
@MimeType nvarchar(260) = NULL,
@Version smallint,
@Content image,
@ChunkFlags tinyint = NULL,
@ChunkPointer binary(16) OUTPUT
AS

DECLARE @ChunkID uniqueidentifier
SET @ChunkID = NEWID()

IF @IsPermanentSnapshot != 0 BEGIN

    DELETE ChunkData
    WHERE
        SnapshotDataID = @SnapshotDataID AND
        ChunkName = @ChunkName AND
        ChunkType = @ChunkType

    INSERT
    INTO ChunkData
        (ChunkID, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    VALUES
        (@ChunkID, @SnapshotDataID, @ChunkName, @ChunkType, @MimeType, @Version, @ChunkFlags, @Content)

    SELECT @ChunkPointer = TEXTPTR(Content)
                FROM ChunkData
                WHERE ChunkData.ChunkID = @ChunkID

END ELSE BEGIN

    DELETE [ReportServerTempDB].dbo.ChunkData
    WHERE
        SnapshotDataID = @SnapshotDataID AND
        ChunkName = @ChunkName AND
        ChunkType = @ChunkType

    INSERT
    INTO [ReportServerTempDB].dbo.ChunkData
        (ChunkID, SnapshotDataID, ChunkName, ChunkType, MimeType, Version, ChunkFlags, Content)
    VALUES
        (@ChunkID, @SnapshotDataID, @ChunkName, @ChunkType, @MimeType, @Version, @ChunkFlags, @Content)

    SELECT @ChunkPointer = TEXTPTR(Content)
                FROM [ReportServerTempDB].dbo.ChunkData AS CH
                WHERE CH.ChunkID = @ChunkID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateChunkSegment
-- --------------------------------------------------
create proc [dbo].[CreateChunkSegment]
    @SnapshotId			uniqueidentifier,
    @IsPermanent		bit,
    @ChunkId			uniqueidentifier,
    @Content			varbinary(max) = 0x0,
    @StartByte			bigint,
    @Length				int = 0,
    @LogicalByteCount	int = 0,
    @SegmentId			uniqueidentifier out
as begin
    declare @output table (SegmentId uniqueidentifier, ActualByteCount int) ;
    declare @ActualByteCount int ;
    if(@IsPermanent = 1) begin
        insert Segment(Content)
        output inserted.SegmentId, datalength(inserted.Content) into @output
        values (substring(@Content, 1, @Length)) ;

        select top 1    @SegmentId = SegmentId,
                        @ActualByteCount = ActualByteCount
        from @output ;

        insert ChunkSegmentMapping(ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount)
        values (@ChunkId, @SegmentId, @StartByte, @LogicalByteCount, @ActualByteCount) ;
    end
    else begin
        insert [ReportServerTempDB].dbo.Segment(Content)
        output inserted.SegmentId, datalength(inserted.Content) into @output
        values (substring(@Content, 1, @Length)) ;

        select top 1    @SegmentId = SegmentId,
                        @ActualByteCount = ActualByteCount
        from @output ;

        insert [ReportServerTempDB].dbo.ChunkSegmentMapping(ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount)
        values (@ChunkId, @SegmentId, @StartByte, @LogicalByteCount, @ActualByteCount) ;
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateDataDrivenNotification
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateDataDrivenNotification]
@SubscriptionID uniqueidentifier,
@ActiveationID uniqueidentifier,
@ReportID uniqueidentifier,
@ReportZone int,
@ExtensionSettings ntext,
@Locale nvarchar(128),
@Parameters ntext,
@LastRunTime datetime,
@DeliveryExtension nvarchar(260),
@OwnerSid varbinary (85) = null,
@OwnerName nvarchar(260),
@OwnerAuthType int,
@Version int
AS

declare @OwnerID as uniqueidentifier

EXEC GetUserID @OwnerSid,@OwnerName, @OwnerAuthType, @OwnerID OUTPUT

-- Verify if subscription is being deleted
if exists (select 1 from [dbo].[SubscriptionsBeingDeleted] where [SubscriptionID]=@SubscriptionID)
BEGIN
    RAISERROR( N'The subscription is being deleted', 16, 1)
    return;
END

-- Verify if subscription was deleted or deactivated
if not exists (select 1 from [dbo].[Subscriptions] where [SubscriptionID]=@SubscriptionID and [InactiveFlags] = 0)
BEGIN
    RAISERROR( N'The subscription was deleted or deactivated', 16, 1)
    return;
END

-- Insert into the notification table
insert into [Notifications]
    (
    [NotificationID],
    [SubscriptionID],
    [ActivationID],
    [ReportID],
    [ReportZone],
    [SnapShotDate],
    [ExtensionSettings],
    [Locale],
    [Parameters],
    [NotificationEntered],
    [SubscriptionLastRunTime],
    [DeliveryExtension],
    [SubscriptionOwnerID],
    [IsDataDriven],
    [Version]
    )
values
    (
    NewID(),
    @SubscriptionID,
    @ActiveationID,
    @ReportID,
    @ReportZone,
    NULL,
    @ExtensionSettings,
    @Locale,
    @Parameters,
    GETUTCDATE(),
    @LastRunTime,
    @DeliveryExtension,
    @OwnerID,
    1,
    @Version
    )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateEditSession
-- --------------------------------------------------
CREATE proc [dbo].[CreateEditSession]
    @EditSessionID varchar(32),
    @ContextPath nvarchar(440),
    @Name nvarchar(440),
    @OwnerSid varbinary(85) = NULL,
    @OwnerName nvarchar(260),
    @Content varbinary(max),
    @Description nvarchar(max) = NULL,
    @Intermediate uniqueidentifier,
    @Property nvarchar(max),
    @Parameter nvarchar(max),
    @AuthType int,
    @Timeout int,
    @DataCacheHash varbinary(64) = NULL,
    @NewItemID uniqueidentifier out
as begin
    DECLARE @OwnerID uniqueidentifier ;
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT ;

    UPDATE [ReportServerTempDB].dbo.SnapshotData
    SET  PermanentRefcount = PermanentRefcount + 1, TransientRefcount = TransientRefcount - 1
    WHERE SnapshotData.SnapshotDataID = @Intermediate

    SELECT @NewItemID = NEWID();

    -- copy in the report metadata
    insert into [ReportServerTempDB].dbo.TempCatalog (
        EditSessionID,
        TempCatalogID,
        ContextPath,
        [Name],
        Content,
        Description,
        Intermediate,
        IntermediateIsPermanent,
        Property,
        Parameter,
        OwnerID,
        CreationTime,
        ExpirationTime,
        DataCacheHash )
    values (
        @EditSessionID,
        @NewItemID,
        @ContextPath,
        @Name,
        @Content,
        @Description,
        @Intermediate,
        convert(bit, 0),
        @Property,
        @Parameter,
        @OwnerID,
        GETDATE(),
        DATEADD(n, @Timeout, GETDATE()),
        @DataCacheHash)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateNewActiveSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateNewActiveSubscription]
@ActiveID uniqueidentifier,
@SubscriptionID uniqueidentifier
AS


-- Insert into the activesubscription table
insert into [ActiveSubscriptions]
    (
    [ActiveID],
    [SubscriptionID],
    [TotalNotifications],
    [TotalSuccesses],
    [TotalFailures]
    )
values
    (
    @ActiveID,
    @SubscriptionID,
    NULL,
    0,
    0
    )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateNewSnapshotVersion
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateNewSnapshotVersion]
    @OldSnapshotId UNIQUEIDENTIFIER,
    @NewSnapshotId UNIQUEIDENTIFIER,
    @IsPermanentSnapshot BIT,
    @Machine NVARCHAR(512)
AS
BEGIN
    IF(@IsPermanentSnapshot = 1) BEGIN
        INSERT [dbo].[SnapshotData] (
            SnapshotDataId,
            CreatedDate,
            ParamsHash,
            QueryParams,
            EffectiveParams,
            Description,
            DependsOnUser,
            PermanentRefCount,
            TransientRefCount,
            ExpirationDate,
            PageCount,
            HasDocMap,
            PaginationMode,
            ProcessingFlags
            )
        SELECT
            @NewSnapshotId,
            [sn].CreatedDate,
            [sn].ParamsHash,
            [sn].QueryParams,
            [sn].EffectiveParams,
            [sn].Description,
            [sn].DependsOnUser,
            0,
            1,		-- always create with transient refcount of 1
            [sn].ExpirationDate,
            [sn].PageCount,
            [sn].HasDocMap,
            [sn].PaginationMode,
            [sn].ProcessingFlags
        FROM [dbo].[SnapshotData] [sn]
        WHERE [sn].SnapshotDataId = @OldSnapshotId
    END
    ELSE BEGIN
        INSERT [ReportServerTempDB].dbo.[SnapshotData] (
            SnapshotDataId,
            CreatedDate,
            ParamsHash,
            QueryParams,
            EffectiveParams,
            Description,
            DependsOnUser,
            PermanentRefCount,
            TransientRefCount,
            ExpirationDate,
            PageCount,
            HasDocMap,
            PaginationMode,
            ProcessingFlags,
            Machine,
            IsCached
            )
        SELECT
            @NewSnapshotId,
            [sn].CreatedDate,
            [sn].ParamsHash,
            [sn].QueryParams,
            [sn].EffectiveParams,
            [sn].Description,
            [sn].DependsOnUser,
            0,
            1,		-- always create with transient refcount of 1
            [sn].ExpirationDate,
            [sn].PageCount,
            [sn].HasDocMap,
            [sn].PaginationMode,
            [sn].ProcessingFlags,
            @Machine,
            [sn].IsCached
        FROM [ReportServerTempDB].dbo.[SnapshotData] [sn]
        WHERE [sn].SnapshotDataId = @OldSnapshotId
    END

    EXEC [dbo].[CopyChunks]
        @OldSnapshotId = @OldSnapshotId,
        @NewSnapshotId = @NewSnapshotId,
        @IsPermanentSnapshot = @IsPermanentSnapshot
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateObject
-- --------------------------------------------------
-- This SP should never be called with a policy ID unless it is guarenteed that
-- the parent will not be deleted before the insert (such as while running this script)
CREATE PROCEDURE [dbo].[CreateObject]
@ItemID uniqueidentifier,
@Name nvarchar (425),
@Path nvarchar (425),
@ParentID uniqueidentifier,
@Type int,
@Content image = NULL,
@Intermediate uniqueidentifier = NULL,
@LinkSourceID uniqueidentifier = NULL,
@Property ntext = NULL,
@Parameter ntext = NULL,
@Description ntext = NULL,
@Hidden bit = NULL,
@CreatedBySid varbinary(85) = NULL,
@CreatedByName nvarchar(260),
@AuthType int,
@CreationDate datetime,
@ModificationDate datetime,
@MimeType nvarchar (260) = NULL,
@SnapshotLimit int = NULL,
@PolicyRoot int = 0,
@PolicyID uniqueidentifier = NULL,
@ExecutionFlag int = 1, -- allow live execution, don't keep history
@SubType nvarchar(128) = NULL,
@ComponentID uniqueidentifier = NULL
AS

DECLARE @CreatedByID uniqueidentifier
EXEC GetUserID @CreatedBySid, @CreatedByName, @AuthType, @CreatedByID OUTPUT

UPDATE Catalog
SET ModifiedByID = @CreatedByID, ModifiedDate = @ModificationDate
WHERE ItemID = @ParentID

-- If no policyID, use the parent's
IF @PolicyID is NULL BEGIN
   SET @PolicyID = (SELECT PolicyID FROM [dbo].[Catalog] WHERE Catalog.ItemID = @ParentID)
END

-- If there is no policy ID then we are guarenteed not to have a parent
IF @PolicyID is NULL BEGIN
RAISERROR ('Parent Not Found', 16, 1)
return
END

INSERT INTO Catalog (ItemID,  Path,  Name,  ParentID,  Type,  Content, ContentSize,  Intermediate,  LinkSourceID,  Property,  Description,  Hidden,  CreatedByID,  CreationDate,  ModifiedByID,  ModifiedDate,  MimeType,  SnapshotLimit,  [Parameter],  PolicyID,  PolicyRoot, ExecutionFlag, SubType, ComponentID)
VALUES             (@ItemID, @Path, @Name, @ParentID, @Type, @Content, DATALENGTH(@Content), @Intermediate, @LinkSourceID, @Property, @Description, @Hidden, @CreatedByID, @CreationDate, @CreatedByID,  @ModificationDate, @MimeType, @SnapshotLimit, @Parameter, @PolicyID, @PolicyRoot , @ExecutionFlag, @SubType, @ComponentID)

IF @Intermediate IS NOT NULL AND @@ERROR = 0 BEGIN
   UPDATE SnapshotData
   SET PermanentRefcount = PermanentRefcount + 1, TransientRefcount = TransientRefcount - 1
   WHERE SnapshotData.SnapshotDataID = @Intermediate
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateOrUpdateContentCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateOrUpdateContentCache]
    @CatalogItemID uniqueidentifier,
    @ParamsHash int,
    @EffectiveParams nvarchar(max),
    @ContentType nvarchar(256),
    @Version smallint,
    @Content varbinary(max)
AS
BEGIN
    DECLARE @ExpirationDate as DateTime
    SET @ExpirationDate = NULL

    SELECT TOP 1 @ExpirationDate = AbsoluteExpiration
    FROM
        [ReportServerTempDB].dbo.[ExecutionCache]
    WHERE
        ReportId = @CatalogItemID AND
        ParamsHash = @ParamsHash
    ORDER BY AbsoluteExpiration DESC

    BEGIN TRANSACTION CONTENTCACHEUPSERT
    IF NOT EXISTS (SELECT ContentCacheID FROM [ReportServerTempDB].[dbo].ContentCache WHERE CatalogItemID = @CatalogItemID AND ParamsHash = @ParamsHash AND  ContentType = @ContentType)
        INSERT INTO [ReportServerTempDB].[dbo].ContentCache
            (
                [CatalogItemID],
                [CreatedDate],
                [ParamsHash],
                [EffectiveParams],
                [ContentType],
                [ExpirationDate],
                [Version],
                [Content]
            )
        VALUES
            (
                @CatalogItemID,
                GETDATE(),
                @ParamsHash,
                @EffectiveParams,
                @ContentType,
                @ExpirationDate,
                @Version,
                @Content
            )
    ELSE
        UPDATE [ReportServerTempDB].[dbo].ContentCache
        SET
            [CatalogItemID] = @CatalogItemID,
            [CreatedDate] = GETDATE(),
            [ParamsHash] = @ParamsHash,
            [EffectiveParams] = @EffectiveParams,
            [ContentType] = @ContentType,
            [ExpirationDate] = @ExpirationDate,
            [Version] = @Version,
            [Content] = @Content
         WHERE CatalogItemID = @CatalogItemID AND ParamsHash = @ParamsHash AND  ContentType = @ContentType
    COMMIT TRANSACTION CONTENTCACHEUPSERT
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateRdlChunk
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateRdlChunk]
    @ItemId UNIQUEIDENTIFIER,
    @SnapshotId UNIQUEIDENTIFIER,
    @IsPermanentSnapshot BIT,
    @ChunkName NVARCHAR(260),
    @ChunkFlags TINYINT,
    @ChunkType INT,
    @Version SMALLINT,
    @MimeType NVARCHAR(260) = NULL
AS
BEGIN

-- If the chunk already exists then bail out early
IF EXISTS (
    SELECT 1
    FROM [SegmentedChunk]
    WHERE   SnapshotDataId = @SnapshotId AND
            ChunkName = @ChunkName AND
            ChunkType = @ChunkType
    )
    RETURN ;

-- This is a 3-step process.  First we need to get the RDL out of the Catalog
-- table where it is stored in the Content row.  Note the join to make sure
-- that if ItemId is a Linked Report we go back to the main report to get the RDL.
-- Once we have the RDL stored in @SegmentData, we then invoke the CreateSegmentedChunk
-- stored proc which will create an empty segmented chunk for us and return the ChunkId.
-- finally, once we have a ChunkId, we can invoke CreateChunkSegment to actually put the
-- content into the chunk.  Note that we do not every actually break the chunk into multiple
-- sgements but instead we always use one.
DECLARE @SegmentData VARBINARY(MAX) ;
DECLARE @SegmentByteCount INT ;
SELECT @SegmentData = CONVERT(VARBINARY(MAX), ISNULL(Linked.Content, Original.Content))
FROM [Catalog] Original
LEFT OUTER JOIN [Catalog] Linked WITH (INDEX(PK_Catalog)) ON (Original.LinkSourceId = Linked.ItemId)
WHERE [Original].[ItemId] = @ItemId ;

SELECT @SegmentByteCount = DATALENGTH(@SegmentData) ;

DECLARE @ChunkId UNIQUEIDENTIFIER ;
EXEC [CreateSegmentedChunk]
    @SnapshotId = @SnapshotId,
    @IsPermanent = @IsPermanentSnapshot,
    @ChunkName = @ChunkName,
    @ChunkFlags = @ChunkFlags,
    @ChunkType = @ChunkType,
    @Version = @Version,
    @MimeType = @MimeType,
    @Machine = NULL,
    @ChunkId = @ChunkId out ;

DECLARE @SegmentId UNIQUEIDENTIFIER ;
EXEC [CreateChunkSegment]
    @SnapshotId = @SnapshotId,
    @IsPermanent = @IsPermanentSnapshot,
    @ChunkId = @ChunkId,
    @Content = @SegmentData,
    @StartByte = 0,
    @Length = @SegmentByteCount,
    @LogicalByteCount = @SegmentByteCount,
    @SegmentId = @SegmentId out
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateRole]
@RoleID as uniqueidentifier,
@RoleName as nvarchar(260),
@Description as nvarchar(512) = null,
@TaskMask as nvarchar(32),
@RoleFlags as tinyint
AS
INSERT INTO Roles
(RoleID, RoleName, Description, TaskMask, RoleFlags)
VALUES
(@RoleID, @RoleName, @Description, @TaskMask, @RoleFlags)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateSegmentedChunk
-- --------------------------------------------------
create proc [dbo].[CreateSegmentedChunk]
    @SnapshotId		uniqueidentifier,
    @IsPermanent	bit,
    @ChunkName		nvarchar(260),
    @ChunkFlags		tinyint,
    @ChunkType		int,
    @Version		smallint,
    @MimeType		nvarchar(260) = null,
    @Machine		nvarchar(512),
    @ChunkId		uniqueidentifier out
as begin
    declare @output table (ChunkId uniqueidentifier) ;
    if (@IsPermanent = 1) begin
        delete SegmentedChunk
        where SnapshotDataId = @SnapshotId and ChunkName = @ChunkName and ChunkType = @ChunkType

        delete ChunkData
        where SnapshotDataID = @SnapshotId and ChunkName = @ChunkName and ChunkType = @ChunkType

        insert SegmentedChunk(SnapshotDataId, ChunkFlags, ChunkName, ChunkType, Version, MimeType)
        output inserted.ChunkId into @output
        values (@SnapshotId, @ChunkFlags, @ChunkName, @ChunkType, @Version, @MimeType) ;
    end
    else begin
        delete [ReportServerTempDB].dbo.SegmentedChunk
        where SnapshotDataId = @SnapshotId and ChunkName = @ChunkName and ChunkType = @ChunkType

        delete [ReportServerTempDB].dbo.ChunkData
        where SnapshotDataID = @SnapshotId and ChunkName = @ChunkName and ChunkType = @ChunkType

        insert [ReportServerTempDB].dbo.SegmentedChunk(SnapshotDataId, ChunkFlags, ChunkName, ChunkType, Version, MimeType, Machine)
        output inserted.ChunkId into @output
        values (@SnapshotId, @ChunkFlags, @ChunkName, @ChunkType, @Version, @MimeType, @Machine) ;
    end
    select top 1 @ChunkId = ChunkId from @output
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateSession
-- --------------------------------------------------
-- Writes or updates session record
CREATE PROCEDURE [dbo].[CreateSession]
@SessionID as varchar(32),
@CompiledDefinition as uniqueidentifier = NULL,
@SnapshotDataID as uniqueidentifier = NULL,
@IsPermanentSnapshot as bit = NULL,
@ReportPath as nvarchar(464) = NULL,
@Timeout as int,
@AutoRefreshSeconds as int = NULL,
@DataSourceInfo as image = NULL,
@OwnerName as nvarchar (260),
@OwnerSid as varbinary (85) = NULL,
@AuthType as int,
@EffectiveParams as ntext = NULL,
@HistoryDate as datetime = NULL,
@PageHeight as float = NULL,
@PageWidth as float = NULL,
@TopMargin as float = NULL,
@BottomMargin as float = NULL,
@LeftMargin as float = NULL,
@RightMargin as float = NULL,
@AwaitingFirstExecution as bit = NULL,
@EditSessionID as varchar(32) = NULL,
@SitePath as nvarchar(440) = NULL,
@SiteZone as int,
@DataSetInfo as varbinary(max) = NULL,
@ReportDefinitionPath as nvarchar(464) = NULL
AS

UPDATE PS
SET PS.RefCount = 1
FROM
    [ReportServerTempDB].dbo.PersistedStream as PS
WHERE
    PS.SessionID = @SessionID

UPDATE SN
SET TransientRefcount = TransientRefcount + 1
FROM
   SnapshotData AS SN
WHERE
   SN.SnapshotDataID = @SnapshotDataID

UPDATE SN
SET TransientRefcount = TransientRefcount + 1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
WHERE
   SN.SnapshotDataID = @SnapshotDataID

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

DECLARE @now datetime
SET @now = GETDATE()

INSERT
   INTO [ReportServerTempDB].dbo.SessionData (
      SessionID,
      CompiledDefinition,
      SnapshotDataID,
      IsPermanentSnapshot,
      ReportPath,
      Timeout,
      AutoRefreshSeconds,
      Expiration,
      DataSourceInfo,
      OwnerID,
      EffectiveParams,
      CreationTime,
      HistoryDate,
      PageHeight,
      PageWidth,
      TopMargin,
      BottomMargin,
      LeftMargin,
      RightMargin,
      AwaitingFirstExecution,
      EditSessionID,
      SitePath,
      SiteZone,
      DataSetInfo,
      ReportDefinitionPath )
   VALUES (
      @SessionID,
      @CompiledDefinition,
      @SnapshotDataID,
      @IsPermanentSnapshot,
      @ReportPath,
      @Timeout,
      @AutoRefreshSeconds,
      DATEADD(s, @Timeout, @now),
      @DataSourceInfo,
      @OwnerID,
      @EffectiveParams,
      @now,
      @HistoryDate,
      @PageHeight,
      @PageWidth,
      @TopMargin,
      @BottomMargin,
      @LeftMargin,
      @RightMargin,
      @AwaitingFirstExecution,
      @EditSessionID,
      @SitePath,
      @SiteZone,
      @DataSetInfo,
      @ReportDefinitionPath )

INSERT INTO [ReportServerTempDB].dbo.SessionLock(SessionID)
VALUES (@SessionID)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateSnapShotNotifications
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateSnapShotNotifications]
@HistoryID uniqueidentifier,
@LastRunTime datetime
AS
update [Subscriptions]
set
    [LastRunTime] = @LastRunTime
from
    History SS inner join [Subscriptions] S on S.[Report_OID] = SS.[ReportID]
where
    SS.[HistoryID] = @HistoryID and S.EventType = 'ReportHistorySnapshotCreated' and InactiveFlags = 0


-- Find all valid subscriptions for the given report and create a new notification row for
-- each subscription
insert into [Notifications]
    (
    [NotificationID],
    [SubscriptionID],
    [ActivationID],
    [ReportID],
    [ReportZone],
    [SnapShotDate],
    [ExtensionSettings],
    [Locale],
    [Parameters],
    [NotificationEntered],
    [SubscriptionLastRunTime],
    [DeliveryExtension],
    [SubscriptionOwnerID],
    [IsDataDriven],
    [Version]
    )
select
    NewID(),
    S.[SubscriptionID],
    NULL,
    S.[Report_OID],
    S.[ReportZone],
    NULL,
    S.[ExtensionSettings],
    S.[Locale],
    S.[Parameters],
    GETUTCDATE(),
    S.[LastRunTime],
    S.[DeliveryExtension],
    S.[OwnerID],
    0,
    S.[Version]
from
    [Subscriptions] S with (READPAST) inner join History H on S.[Report_OID] = H.[ReportID]
where
    H.[HistoryID] = @HistoryID and S.EventType = 'ReportHistorySnapshotCreated' and InactiveFlags = 0 and
    S.[DataSettings] is null

-- Create any data driven subscription by creating a data driven event
insert into [Event]
    (
    [EventID],
    [EventType],
    [EventData],
    [TimeEntered]
    )
select
    NewID(),
    'DataDrivenSubscription',
    S.SubscriptionID,
    GETUTCDATE()
from
    [Subscriptions] S with (READPAST) inner join History H on S.[Report_OID] = H.[ReportID]
where
    H.[HistoryID] = @HistoryID and S.EventType = 'ReportHistorySnapshotCreated' and InactiveFlags = 0 and
    S.[DataSettings] is not null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateSubscription]
@id uniqueidentifier,
@Locale nvarchar (128),
@Report_Name nvarchar (425),
@ReportZone int,
@OwnerSid varbinary (85) = NULL,
@OwnerName nvarchar(260),
@OwnerAuthType int,
@DeliveryExtension nvarchar (260) = NULL,
@InactiveFlags int,
@ExtensionSettings ntext = NULL,
@ModifiedBySid varbinary (85) = NULL,
@ModifiedByName nvarchar(260),
@ModifiedByAuthType int,
@ModifiedDate datetime,
@Description nvarchar(512) = NULL,
@LastStatus nvarchar(260) = NULL,
@EventType nvarchar(260),
@MatchData ntext = NULL,
@Parameters ntext = NULL,
@DataSettings ntext = NULL,
@Version int

AS

-- Create a subscription with the given data.  The name must match a name in the
-- Catalog table and it must be a report type (2) or linked report (4)

DECLARE @Report_OID uniqueidentifier
DECLARE @OwnerID uniqueidentifier
DECLARE @ModifiedByID uniqueidentifier
DECLARE @TempDeliveryID uniqueidentifier

--Get the report id for this subscription
select @Report_OID = (select [ItemID] from [Catalog] where [Catalog].[Path] = @Report_Name and ([Catalog].[Type] = 2 or [Catalog].[Type] = 4 or [Catalog].[Type] = 8 or [Catalog].[Type] = 13))

EXEC GetUserID @OwnerSid, @OwnerName, @OwnerAuthType, @OwnerID OUTPUT
EXEC GetUserID @ModifiedBySid, @ModifiedByName, @ModifiedByAuthType, @ModifiedByID OUTPUT

if (@Report_OID is NULL)
begin
RAISERROR('Report Not Found', 16, 1)
return
end

Insert into Subscriptions
    (
        [SubscriptionID],
        [OwnerID],
        [Report_OID],
        [ReportZone],
        [Locale],
        [DeliveryExtension],
        [InactiveFlags],
        [ExtensionSettings],
        [ModifiedByID],
        [ModifiedDate],
        [Description],
        [LastStatus],
        [EventType],
        [MatchData],
        [LastRunTime],
        [Parameters],
        [DataSettings],
    [Version]
    )
values
    (@id, @OwnerID, @Report_OID, @ReportZone, @Locale, @DeliveryExtension, @InactiveFlags, @ExtensionSettings, @ModifiedByID, @ModifiedDate,
     @Description, @LastStatus, @EventType, @MatchData, NULL, @Parameters, @DataSettings, @Version)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateTask
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateTask]
@ScheduleID uniqueidentifier,
@Name nvarchar (260),
@StartDate datetime,
@Flags int,
@NextRunTime datetime = NULL,
@LastRunTime datetime = NULL,
@EndDate datetime = NULL,
@RecurrenceType int = NULL,
@MinutesInterval int = NULL,
@DaysInterval int = NULL,
@WeeksInterval int = NULL,
@DaysOfWeek int = NULL,
@DaysOfMonth int = NULL,
@Month int = NULL,
@MonthlyWeek int = NULL,
@State int = NULL,
@LastRunStatus nvarchar (260) = NULL,
@ScheduledRunTimeout int = NULL,
@UserSid varbinary (85) = null,
@UserName nvarchar(260),
@AuthType int,
@EventType nvarchar (260),
@EventData nvarchar (260),
@Type int ,
@Path nvarchar (425) = NULL
AS

DECLARE @UserID uniqueidentifier

EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

-- Create a task with the given data.
Insert into Schedule
    (
        [ScheduleID],
        [Name],
        [StartDate],
        [Flags],
        [NextRunTime],
        [LastRunTime],
        [EndDate],
        [RecurrenceType],
        [MinutesInterval],
        [DaysInterval],
        [WeeksInterval],
        [DaysOfWeek],
        [DaysOfMonth],
        [Month],
        [MonthlyWeek],
        [State],
        [LastRunStatus],
        [ScheduledRunTimeout],
        [CreatedById],
        [EventType],
        [EventData],
        [Type],
        [Path]
    )
values
    (@ScheduleID, @Name, @StartDate, @Flags, @NextRunTime, @LastRunTime, @EndDate, @RecurrenceType, @MinutesInterval,
     @DaysInterval, @WeeksInterval, @DaysOfWeek, @DaysOfMonth, @Month, @MonthlyWeek, @State, @LastRunStatus,
     @ScheduledRunTimeout, @UserID, @EventType, @EventData, @Type, @Path)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateTimeBasedSubscriptionNotification
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateTimeBasedSubscriptionNotification]
@SubscriptionID uniqueidentifier,
@LastRunTime datetime,
@LastStatus nvarchar(260)
as

insert into [Notifications]
    (
    [NotificationID],
    [SubscriptionID],
    [ActivationID],
    [ReportID],
    [ReportZone],
    [SnapShotDate],
    [ExtensionSettings],
    [Locale],
    [Parameters],
    [NotificationEntered],
    [SubscriptionLastRunTime],
    [DeliveryExtension],
    [SubscriptionOwnerID],
    [IsDataDriven],
    [Version]
    )
select
    NewID(),
    S.[SubscriptionID],
    NULL,
    S.[Report_OID],
    S.[ReportZone],
    NULL,
    S.[ExtensionSettings],
    S.[Locale],
    S.[Parameters],
    GETUTCDATE(),
    @LastRunTime,
    S.[DeliveryExtension],
    S.[OwnerID],
    0,
    S.[Version]
from
    [Subscriptions] S
where
    S.[SubscriptionID] = @SubscriptionID and InactiveFlags = 0 and
    S.[DataSettings] is null


-- Create any data driven subscription by creating a data driven event
insert into [Event]
    (
    [EventID],
    [EventType],
    [EventData],
    [TimeEntered]
    )
select
    NewID(),
    'DataDrivenSubscription',
    S.SubscriptionID,
    GETUTCDATE()
from
    [Subscriptions] S
where
    S.[SubscriptionID] = @SubscriptionID and InactiveFlags = 0 and
    S.[DataSettings] is not null

update [Subscriptions]
set
    [LastRunTime] = @LastRunTime,
    [LastStatus] = @LastStatus
where
    [SubscriptionID] = @SubscriptionID and InactiveFlags = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateTimeBasedSubscriptionSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CreateTimeBasedSubscriptionSchedule]
@SubscriptionID as uniqueidentifier,
@ScheduleID uniqueidentifier,
@Schedule_Name nvarchar (260),
@ItemPath nvarchar (425),
@Action int,
@StartDate datetime,
@Flags int,
@NextRunTime datetime = NULL,
@LastRunTime datetime = NULL,
@EndDate datetime = NULL,
@RecurrenceType int = NULL,
@MinutesInterval int = NULL,
@DaysInterval int = NULL,
@WeeksInterval int = NULL,
@DaysOfWeek int = NULL,
@DaysOfMonth int = NULL,
@Month int = NULL,
@MonthlyWeek int = NULL,
@State int = NULL,
@LastRunStatus nvarchar (260) = NULL,
@ScheduledRunTimeout int = NULL,
@UserSid varbinary (85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@EventType nvarchar (260),
@EventData nvarchar (260),
@Path nvarchar (425) = NULL
AS

EXEC CreateTask @ScheduleID, @Schedule_Name, @StartDate, @Flags, @NextRunTime, @LastRunTime,
        @EndDate, @RecurrenceType, @MinutesInterval, @DaysInterval, @WeeksInterval, @DaysOfWeek,
        @DaysOfMonth, @Month, @MonthlyWeek, @State, @LastRunStatus,
        @ScheduledRunTimeout, @UserSid, @UserName, @AuthType, @EventType, @EventData, 1 /*scoped type*/, @Path

if @@ERROR = 0
begin
    -- add a row to the reportSchedule table
    declare @ItemID uniqueidentifier
    select @ItemID = [ItemID] from [Catalog] with (HOLDLOCK) where [Catalog].[Path] = @ItemPath and ([Catalog].[Type] = 2 or [Catalog].[Type] = 4 or [Catalog].[Type] = 8 or [Catalog].[Type] = 13)
    EXEC AddReportSchedule @ScheduleID, @ItemID, @SubscriptionID, @Action
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DecreaseTransientSnapshotRefcount
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DecreaseTransientSnapshotRefcount]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit
AS
SET NOCOUNT OFF
if @IsPermanentSnapshot = 1
BEGIN
   UPDATE SnapshotData
   SET TransientRefcount = TransientRefcount - 1
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   UPDATE [ReportServerTempDB].dbo.SnapshotData
   SET TransientRefcount = TransientRefcount - 1
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeepCopySegment
-- --------------------------------------------------
create proc [dbo].[DeepCopySegment]
    @ChunkId		uniqueidentifier,
    @IsPermanent	bit,
    @SegmentId		uniqueidentifier,
    @NewSegmentId	uniqueidentifier out
as
begin
    select @NewSegmentId = newid() ;
    if (@IsPermanent = 1) begin
        insert Segment(SegmentId, Content)
        select @NewSegmentId, seg.Content
        from Segment seg
        where seg.SegmentId = @SegmentId ;

        update ChunkSegmentMapping
        set SegmentId = @NewSegmentId
        where ChunkId = @ChunkId and SegmentId = @SegmentId ;
    end
    else begin
        insert [ReportServerTempDB].dbo.Segment(SegmentId, Content)
        select @NewSegmentId, seg.Content
        from [ReportServerTempDB].dbo.Segment seg
        where seg.SegmentId = @SegmentId ;

        update [ReportServerTempDB].dbo.ChunkSegmentMapping
        set SegmentId = @NewSegmentId
        where ChunkId = @ChunkId and SegmentId = @SegmentId ;
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteActiveSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteActiveSubscription]
@ActiveID uniqueidentifier
AS

delete from ActiveSubscriptions where ActiveID = @ActiveID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteAlertSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteAlertSubscription]
    @AlertSubscriptionID bigint
AS
BEGIN
    DELETE FROM [AlertSubscribers] WHERE
    AlertSubscriptionID = @AlertSubscriptionID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteAllHistoryForReport
-- --------------------------------------------------
-- delete all snapshots for a report
CREATE PROCEDURE [dbo].[DeleteAllHistoryForReport]
@ReportID uniqueidentifier
AS
SET NOCOUNT OFF
DELETE
FROM History
WHERE HistoryID in
   (SELECT HistoryID
    FROM History JOIN Catalog on ItemID = ReportID
    WHERE ReportID = @ReportID
   )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteAllModelItemPolicies
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteAllModelItemPolicies]
@Path as nvarchar(450)
AS

DELETE Policies
FROM
   Policies AS P
   INNER JOIN ModelItemPolicy AS MIP ON P.PolicyID = MIP.PolicyID
   INNER JOIN Catalog AS C ON MIP.CatalogItemID = C.ItemID
WHERE
   C.[Path] = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteBatchRecords
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteBatchRecords]
@BatchID uniqueidentifier
AS
SET NOCOUNT OFF
DELETE
FROM [Batch]
WHERE BatchID = @BatchID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteCatalogExtendedContent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteCatalogExtendedContent]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50)
AS
BEGIN
    DELETE FROM [dbo].[CatalogItemExtendedContent] WHERE [ItemID] = @CatalogItemID AND ContentType = @ContentType
END

GRANT EXECUTE ON [dbo].[DeleteCatalogExtendedContent] TO RSExecRole

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteComment
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteComment]
@CommentID bigint
AS
BEGIN TRAN
    DECLARE @AttachmentID uniqueidentifier;

    SELECT TOP 1 @AttachmentID = [AttachmentID]
    FROM [Comments]
    WHERE [CommentID]=@CommentID

    UPDATE [Comments]
    SET ThreadID=NULL
    WHERE [ThreadID]=@CommentID;

    DELETE FROM [Comments]
    WHERE [CommentID]=@CommentID

    IF (@AttachmentID IS NOT NULL)
        DELETE FROM [Catalog]
        WHERE [ItemID] =  @AttachmentID;
COMMIT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteDataModelDataSourceByID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteDataModelDataSourceByID]
    @DataSourceID UNIQUEIDENTIFIER  
AS

BEGIN
DELETE FROM [dbo].[DataModelDataSource] WHERE [DataSourceID] = @DataSourceID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteDataModelRoleByID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteDataModelRoleByID]
    @DataModelRoleID bigint  
AS
BEGIN
    DELETE FROM 
        [dbo].[DataModelRole]
    WHERE 
        [DataModelRoleID] = @DataModelRoleID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteDataSets
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteDataSets]
@ItemID [uniqueidentifier]
AS
DELETE
FROM [DataSets]
WHERE [ItemID] = @ItemID
DELETE
FROM [ReportServerTempDB].dbo.TempDataSets
WHERE [ItemID] = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteDataSources
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteDataSources]
@ItemID [uniqueidentifier]
AS

DELETE
FROM [DataSource]
WHERE [ItemID] = @ItemID or [SubscriptionID] = @ItemID
DELETE
FROM [ReportServerTempDB].dbo.TempDataSources
WHERE [ItemID] = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteDrillthroughReports
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteDrillthroughReports]
@ModelID uniqueidentifier,
@ModelItemID nvarchar(425)
AS
 DELETE ModelDrill WHERE ModelID = @ModelID and ModelItemID = @ModelItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteEncryptedContent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteEncryptedContent]
@ConfigNamesToDelete AS [dbo].[EncryptedConfigList] READONLY
AS

-- Remove the encryption keys
delete from keys where client >= 0

-- Remove the encrypted content
UPDATE [dbo].[DataSource]
SET CredentialRetrieval = 1, -- CredentialRetrieval.Prompt
    ConnectionString = null,
    OriginalConnectionString = null,
    UserName = null,
    Password = null;

-- Remove only the OAuth client secret from ConfigurationInfo
DELETE FROM [dbo].[ConfigurationInfo]
WHERE [Name] IN (SELECT [ConfigName] FROM @ConfigNamesToDelete)

UPDATE [dbo].[Users]
SET [ServiceToken] = null

-- Remove KPIs since they are encrypted; Catalog Type=11 is KPI
UPDATE [dbo].[Catalog]
SET [Property] = null
WHERE [Type] = 11

-- Remove encrypted content in DataModelDataSource
UPDATE [dbo].[DataModelDataSource]
SET ConnectionString = null,
    Username = null,
    Password = null;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteEvent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteEvent]
@ID uniqueidentifier
AS
delete from [Event] where [EventID] = @ID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteExpiredPersistedStreams
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteExpiredPersistedStreams]
AS
SET NOCOUNT OFF
SET DEADLOCK_PRIORITY LOW
declare @now as datetime = GETDATE();
delete top (10) p
from [ReportServerTempDB].dbo.PersistedStream p with(readpast)
where p.RefCount = 0 AND p.ExpirationDate < @now;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteHistoriesWithNoPolicy
-- --------------------------------------------------
-- delete all snapshots for all reports that inherit system History policy
CREATE PROCEDURE [dbo].[DeleteHistoriesWithNoPolicy]
AS
SET NOCOUNT OFF
DELETE
FROM History
WHERE HistoryID in
   (SELECT HistoryID
    FROM History JOIN Catalog on ItemID = ReportID
    WHERE SnapshotLimit is null
   )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteHistoryRecord
-- --------------------------------------------------
-- delete one historical snapshot
CREATE PROCEDURE [dbo].[DeleteHistoryRecord]
@ReportID uniqueidentifier,
@SnapshotDate DateTime
AS
SET NOCOUNT OFF
DELETE
FROM History
WHERE ReportID = @ReportID AND SnapshotDate = @SnapshotDate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteHistoryRecordByHistoryId
-- --------------------------------------------------
-- delete one historical snapshot by history id
CREATE PROCEDURE [dbo].[DeleteHistoryRecordByHistoryId]
@ReportID uniqueidentifier,
@HistoryId uniqueidentifier
AS
SET NOCOUNT OFF
DELETE
FROM History
WHERE ReportID = @ReportID AND HistoryId = @HistoryId

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteKey
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteKey]
@InstallationID uniqueidentifier
AS

if (@InstallationID = '00000000-0000-0000-0000-000000000000')
RAISERROR('Cannot delete reserved key', 16, 1)

-- Remove the encryption keys
delete from keys where InstallationID = @InstallationID and Client = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteModelItemPolicy
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteModelItemPolicy]
@CatalogItemID as uniqueidentifier,
@ModelItemID as nvarchar(425)
AS
SET NOCOUNT OFF
DECLARE @PolicyID uniqueidentifier
SELECT @PolicyID = (SELECT PolicyID FROM ModelItemPolicy WHERE CatalogItemID = @CatalogItemID AND ModelItemID = @ModelItemID)
DELETE Policies FROM Policies WHERE Policies.PolicyID = @PolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteModelPerspectives
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteModelPerspectives]
@ModelID as uniqueidentifier
AS

DELETE
FROM [ModelPerspective]
WHERE [ModelID] = @ModelID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteNotification
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteNotification]
@ID uniqueidentifier
AS
delete from [Notifications] where [NotificationID] = @ID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteObject
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteObject]
@Path nvarchar (425),
@Prefix nvarchar (850),
@EditSessionID varchar(32) = NULL,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@AuthType int
AS

SET NOCOUNT OFF

IF(@EditSessionID is null)
BEGIN

-- Clean up extended table
DECLARE @IdsToDelete table(
    [ItemID] [uniqueidentifier] NOT NULL
)

INSERT INTO @IdsToDelete
SELECT ItemID FROM Catalog WHERE Path = @Path OR Path LIKE @Prefix ESCAPE '*'

DELETE E
FROM
    [CatalogItemExtendedContent] AS E 
    INNER JOIN @IdsToDelete AS C ON E.ItemID = C.ItemID

-- Lock all catalog items with the target policies.
DECLARE @OrphanedPolicies table(
    [PolicyID] [uniqueidentifier] NOT NULL
)

INSERT INTO @OrphanedPolicies
SELECT A.PolicyID FROM (
    SELECT
        DISTINCT R.PolicyID
    FROM
        Catalog AS R WHERE (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')
    UNION
    SELECT
        DISTINCT M.PolicyID
    FROM
        [ModelItemPolicy] AS M INNER JOIN Catalog AS C ON M.CatalogItemID = C.ItemID
    WHERE
        (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')
) A

SELECT
    R.PolicyID
FROM
   Catalog AS R WITH (XLOCK) INNER JOIN @OrphanedPolicies AS OP ON R.PolicyID = OP.PolicyID

-- Remove reference for intermediate formats
UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount - 1,
    -- to fix VSTS 384486 keep shared dataset compiled definition for 14 days
    ExpirationDate = case when R.Type = 8 then DATEADD(d, 14, GETDATE()) ELSE ExpirationDate END,
    TransientRefcount = TransientRefcount + case when R.Type = 8 then 1 ELSE 0 END
FROM
   Catalog AS R WITH (XLOCK)
   INNER JOIN [SnapshotData] AS SD ON R.Intermediate = SD.SnapshotDataID
WHERE
   (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')

-- Remove reference for execution snapshots
UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount - 1
FROM
   Catalog AS R WITH (XLOCK)
   INNER JOIN [SnapshotData] AS SD ON R.SnapshotDataID = SD.SnapshotDataID
WHERE
   (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')

-- Remove history for deleted reports and linked report
DELETE History
FROM
   [Catalog] AS R
   INNER JOIN [History] AS S ON R.ItemID = S.ReportID
WHERE
   (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')

-- Remove model drill reports
DELETE ModelDrill
FROM
   [Catalog] AS C
   INNER JOIN [ModelDrill] AS M ON C.ItemID = M.ReportID
WHERE
   (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')


-- Adjust data sources
UPDATE [DataSource]
   SET
      [Flags] = [Flags] & 0x7FFFFFFD, -- broken link
      [Link] = NULL
FROM
   [Catalog] AS C
   INNER JOIN [DataSource] AS DS ON C.[ItemID] = DS.[Link]
WHERE
   (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')

-- Clean all data sources
DELETE [DataSource]
FROM
    [Catalog] AS R
    INNER JOIN [DataSource] AS DS ON R.[ItemID] = DS.[ItemID]
WHERE
    (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')

        -- Adjust temp editsession data sources
        UPDATE [ReportServerTempDB].dbo.TempDataSources
           SET
              Flags = Flags & 0x7FFFFFFD, -- broken link
              Link = NULL
        FROM
           [Catalog] AS C
           INNER JOIN [ReportServerTempDB].dbo.TempDataSources AS DS ON C.[ItemID] = DS.Link
        WHERE
           (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')

-- Adjust shared datasets
UPDATE [DataSets]
   SET
      [LinkID] = NULL
FROM
   [Catalog] AS C
   INNER JOIN [DataSets] AS DS ON C.[ItemID] = DS.[LinkID]
WHERE
   (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')

-- Adjust temp shared datasets
UPDATE [ReportServerTempDB].dbo.TempDataSets
   SET
      [LinkID] = NULL
FROM
   [Catalog] AS C
   INNER JOIN [ReportServerTempDB].dbo.TempDataSets AS DS ON C.[ItemID] = DS.[LinkID]
WHERE
   (C.Path = @Path OR C.Path LIKE @Prefix ESCAPE '*')

-- Clean shared datasets
DELETE [DataSets]
FROM
    [Catalog] AS R
    INNER JOIN [DataSets] AS DS ON R.[ItemID] = DS.[ItemID]
WHERE
    (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')


-- Update linked reports
UPDATE LR
   SET
      LR.LinkSourceID = NULL
FROM
   [Catalog] AS R INNER JOIN [Catalog] AS LR ON R.ItemID = LR.LinkSourceID
WHERE
   (R.Path = @Path OR R.Path LIKE @Prefix ESCAPE '*')
   AND
   (LR.Path NOT LIKE @Prefix ESCAPE '*')

-- Remove references for cache entries
UPDATE SN
SET
   PermanentRefcount = PermanentRefcount - 1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC on SN.SnapshotDataID = EC.SnapshotDataID
   INNER JOIN Catalog AS C ON EC.ReportID = C.ItemID
WHERE
   (Path = @Path OR Path LIKE @Prefix ESCAPE '*')

-- Clean cache entries for items to be deleted
DELETE EC
FROM
   [ReportServerTempDB].dbo.ExecutionCache AS EC
   INNER JOIN Catalog AS C ON EC.ReportID = C.ItemID
WHERE
   (Path = @Path OR Path LIKE @Prefix ESCAPE '*')

DELETE F
FROM
    [Favorites] AS F
    INNER JOIN Catalog AS C ON F.ItemID = C.ItemID
WHERE
    (Path = @Path OR Path LIKE @Prefix ESCAPE '*')

-- Finally delete items
DELETE
FROM
   [Catalog]
WHERE
   (Path = @Path OR Path LIKE @Prefix ESCAPE '*')

EXEC CleanOrphanedPolicies
END
ELSE
BEGIN
        DECLARE @OwnerID uniqueidentifier
        EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

        -- Remove reference for intermediate formats
        UPDATE [ReportServerTempDB].dbo.SnapshotData
        SET PermanentRefcount = PermanentRefcount - 1
        FROM
           [ReportServerTempDB].dbo.TempCatalog AS R WITH (XLOCK)
           INNER JOIN [ReportServerTempDB].dbo.SnapshotData AS SD ON R.Intermediate = SD.SnapshotDataID
        WHERE
           R.ContextPath = @Path
           AND R.EditSessionID = @EditSessionID
           AND R.OwnerID = @OwnerID

        -- Clean all data sources
        DELETE [ReportServerTempDB].dbo.TempDataSources
        FROM
            [ReportServerTempDB].dbo.TempCatalog AS R
            INNER JOIN [ReportServerTempDB].dbo.TempDataSources AS DS ON R.TempCatalogID = DS.ItemID
        WHERE
            R.ContextPath = @Path
            AND R.EditSessionID = @EditSessionID
            AND R.OwnerID = @OwnerID

        -- Clean shared data sets
        DELETE [ReportServerTempDB].dbo.TempDataSets
        FROM
            [ReportServerTempDB].dbo.TempCatalog AS R
            INNER JOIN [ReportServerTempDB].dbo.TempDataSets AS DS ON R.TempCatalogID = DS.ItemID
        WHERE
            R.ContextPath = @Path
            AND R.EditSessionID = @EditSessionID
            AND R.OwnerID = @OwnerID

        -- Remove references for cache entries
        UPDATE SN
        SET
           PermanentRefcount = PermanentRefcount - 1
        FROM
           [ReportServerTempDB].dbo.SnapshotData AS SN
           INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC on SN.SnapshotDataID = EC.SnapshotDataID
           INNER JOIN [ReportServerTempDB].dbo.TempCatalog AS C ON EC.ReportID = C.TempCatalogID
        WHERE
           ContextPath = @Path
           AND C.EditSessionID = @EditSessionID
           AND C.OwnerID = @OwnerID

        -- Clean cache entries for items to be deleted
        DELETE EC
        FROM
           [ReportServerTempDB].dbo.ExecutionCache AS EC
           INNER JOIN [ReportServerTempDB].dbo.TempCatalog AS C ON EC.ReportID = C.TempCatalogID
        WHERE
            ContextPath = @Path
            AND C.EditSessionID = @EditSessionID
            AND C.OwnerID = @OwnerID

        -- Finally delete items
        DELETE
        FROM
           [ReportServerTempDB].dbo.TempCatalog
        WHERE
            ContextPath = @Path
            AND EditSessionID = @EditSessionID
            AND OwnerID = @OwnerID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteOneChunk
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteOneChunk]
@SnapshotID uniqueidentifier,
@IsPermanentSnapshot bit,
@ChunkName nvarchar(260),
@ChunkType int
AS
SET NOCOUNT OFF
-- for segmented chunks we just need to
-- remove the mapping, the cleanup thread
-- will pick up the rest of the pieces
IF @IsPermanentSnapshot != 0 BEGIN

DELETE ChunkData
WHERE
    SnapshotDataID = @SnapshotID AND
    ChunkName = @ChunkName AND
    ChunkType = @ChunkType

DELETE	SegmentedChunk
WHERE
    SnapshotDataId = @SnapshotID AND
    ChunkName = @ChunkName AND
    ChunkType = @ChunkType

END ELSE BEGIN

DELETE [ReportServerTempDB].dbo.ChunkData
WHERE
    SnapshotDataID = @SnapshotID AND
    ChunkName = @ChunkName AND
    ChunkType = @ChunkType

DELETE	[ReportServerTempDB].dbo.SegmentedChunk
WHERE
    SnapshotDataId = @SnapshotID AND
    ChunkName = @ChunkName AND
    ChunkType = @ChunkType

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeletePersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeletePersistedStream]
@SessionID varchar(32),
@Index int
AS

delete from [ReportServerTempDB].dbo.PersistedStream where SessionID = @SessionID and [Index] = @Index

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeletePersistedStreams
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeletePersistedStreams]
@SessionID varchar(32)
AS
SET NOCOUNT OFF
delete top (10) p
from [ReportServerTempDB].dbo.PersistedStream p
where p.SessionID = @SessionID;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeletePolicy
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeletePolicy]
@ItemName as nvarchar(425)
AS
SET NOCOUNT OFF
DECLARE @OldPolicyID uniqueidentifier
SELECT @OldPolicyID = (SELECT PolicyID FROM Catalog WHERE Catalog.Path = @ItemName)
UPDATE Catalog SET PolicyID =
(SELECT Parent.PolicyID FROM Catalog Parent, Catalog WHERE Parent.ItemID = Catalog.ParentID AND Catalog.Path = @ItemName),
PolicyRoot = 0
WHERE Catalog.PolicyID = @OldPolicyID
DELETE Policies FROM Policies WHERE Policies.PolicyID = @OldPolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteReportSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteReportSchedule]
@ScheduleID uniqueidentifier,
@ReportID uniqueidentifier,
@SubscriptionID uniqueidentifier = NULL,
@ReportAction int
AS

IF @SubscriptionID is NULL
BEGIN
delete from ReportSchedule where ScheduleID = @ScheduleID and ReportID = @ReportID and ReportAction = @ReportAction
END
ELSE
BEGIN
delete from ReportSchedule where ScheduleID = @ScheduleID and ReportID = @ReportID and ReportAction = @ReportAction and SubscriptionID = @SubscriptionID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteRole
-- --------------------------------------------------
-- Delete all policies associated with this role
CREATE PROCEDURE [dbo].[DeleteRole]
@RoleName nvarchar(260)
AS
SET NOCOUNT OFF
-- if you call this, you must delete/reconstruct all policies associated with this role
DELETE FROM Roles WHERE RoleName = @RoleName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteSnapshotAndChunks
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteSnapshotAndChunks]
@SnapshotID uniqueidentifier,
@IsPermanentSnapshot bit
AS

-- Delete from Snapshot, ChunkData and SegmentedChunk table.
-- Shared segments are not deleted.
-- TODO: currently this is being called from a bunch of places that handles exceptions.
-- We should try to delete the segments in some of all of those cases as well.
IF @IsPermanentSnapshot != 0 BEGIN

    DELETE ChunkData
    WHERE ChunkData.SnapshotDataID = @SnapshotID

    DELETE SegmentedChunk
    WHERE SegmentedChunk.SnapshotDataId = @SnapshotID

    DELETE SnapshotData
    WHERE SnapshotData.SnapshotDataID = @SnapshotID

END ELSE BEGIN

    DELETE [ReportServerTempDB].dbo.ChunkData
    WHERE SnapshotDataID = @SnapshotID

    DELETE [ReportServerTempDB].dbo.SegmentedChunk
    WHERE SnapshotDataId = @SnapshotID

    DELETE [ReportServerTempDB].dbo.SnapshotData
    WHERE SnapshotDataID = @SnapshotID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteSubscription]
@SubscriptionID uniqueidentifier
AS
    -- Delete the subscription
    DELETE FROM [Subscriptions] WHERE [SubscriptionID] = @SubscriptionID
    -- Delete it from the SubscriptionsBeingDeleted
    EXEC RemoveSubscriptionFromBeingDeleted @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteTask
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteTask]
@ScheduleID uniqueidentifier
AS
SET NOCOUNT OFF
-- Delete the task with the given task id
DELETE FROM Schedule
WHERE [ScheduleID] = @ScheduleID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteTimeBasedSubscriptionSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteTimeBasedSubscriptionSchedule]
@SubscriptionID as uniqueidentifier
as

delete ReportSchedule from ReportSchedule RS inner join Subscriptions S on S.[SubscriptionID] = RS.[SubscriptionID]
where
    S.[SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteUserDataModelRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeleteUserDataModelRole]
    @UserID uniqueidentifier,
    @DataModelRoleID bigint
AS
BEGIN
    DELETE FROM 
        [dbo].[UserDataModelRole]
    WHERE
        [UserID] =  @UserID AND
        [DataModelRoleID] = @DataModelRoleID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeliveryRemovedInactivateSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DeliveryRemovedInactivateSubscription]
@DeliveryExtension nvarchar(260),
@Status nvarchar(260)
AS
update
    Subscriptions
set
    [DeliveryExtension] = '',
    [InactiveFlags] = [InactiveFlags] | 1, -- Delivery Provider Removed Flag == 1
    [LastStatus] = @Status
where
    [DeliveryExtension] = @DeliveryExtension

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DereferenceSessionSnapshot
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[DereferenceSessionSnapshot]
@SessionID as varchar(32),
@OwnerID as uniqueidentifier
AS

UPDATE SN
SET TransientRefcount = TransientRefcount - 1
FROM
   SnapshotData AS SN
   INNER JOIN [ReportServerTempDB].dbo.SessionData AS SE ON SN.SnapshotDataID = SE.SnapshotDataID
WHERE
   SE.SessionID = @SessionID AND
   SE.OwnerID = @OwnerID

UPDATE SN
SET TransientRefcount = TransientRefcount - 1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   INNER JOIN [ReportServerTempDB].dbo.SessionData AS SE ON SN.SnapshotDataID = SE.SnapshotDataID
WHERE
   SE.SessionID = @SessionID AND
   SE.OwnerID = @OwnerID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.EnforceCacheLimits
-- --------------------------------------------------
CREATE PROC [dbo].[EnforceCacheLimits]
    @ItemID uniqueidentifier,
    @Cap int = 0
AS
BEGIN
    IF (@Cap > 0)
    BEGIN
        DECLARE @AffectedSnapshots TABLE (SnapshotDataID UNIQUEIDENTIFIER) ;
        DECLARE @Now DATETIME ;
        SELECT @Now = GETDATE() ;
        BEGIN TRANSACTION
            -- remove entries which are not in the top N based on the last used time
            -- don't count expired entries, don't purge them either (allow cleanup thread to handle expired entries)
            DELETE FROM [ReportServerTempDB].dbo.ExecutionCache
            OUTPUT DELETED.SnapshotDataID INTO @AffectedSnapshots(SnapshotDataID)
            WHERE	ExecutionCache.ReportID = @ItemID AND
                    ExecutionCache.AbsoluteExpiration > @Now AND
                    ExecutionCache.ExecutionCacheID NOT IN (
                        SELECT TOP (@Cap) EC.ExecutionCacheID
                        FROM [ReportServerTempDB].dbo.ExecutionCache EC
                        WHERE	EC.ReportID = @ItemID AND
                                EC.AbsoluteExpiration > @Now
                        ORDER BY EC.LastUsedTime DESC) ;

            UPDATE [ReportServerTempDB].dbo.SnapshotData
            SET PermanentRefCount = PermanentRefCount - 1
            WHERE SnapshotData.SnapshotDataID in (SELECT SnapshotDataID FROM @AffectedSnapshots) ;
        COMMIT
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ExpireExecutionLogEntries
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ExpireExecutionLogEntries]
AS
SET NOCOUNT OFF
-- -1 means no expiration
if exists (select * from ConfigurationInfo where [Name] = 'ExecutionLogDaysKept' and CAST(CAST(Value as nvarchar) as integer) = -1)
begin
return
end

delete from ExecutionLogStorage
where DateDiff(day, TimeStart, getdate()) >= (select CAST(CAST(Value as nvarchar) as integer) from ConfigurationInfo where [Name] = 'ExecutionLogDaysKept')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ExtendEditSessionLifetime
-- --------------------------------------------------
CREATE PROC [dbo].[ExtendEditSessionLifetime]
    @EditSessionID varchar(32),
    @Minutes int = NULL
AS
BEGIN
    if(@Minutes is null)
    begin
        declare @v nvarchar(max) ;
        select @v = convert(nvarchar(max), [Value]) from [dbo].[ConfigurationInfo] where [Name] = 'EditSessionTimeout' ;
        select @Minutes = convert(int, @v) / 60;  -- timeout stored in seconds

        if (@Minutes is null)
        begin
            select @Minutes = 120 ;
        end

        if(@Minutes < 1)
        begin
            select @Minutes = 1;
        end
    end

    update [ReportServerTempDB].dbo.TempCatalog
    set ExpirationTime = DATEADD(n, @Minutes, GETDATE())
    where EditSessionID = @EditSessionID ;
END

GRANT EXECUTE ON [dbo].[ExtendEditSessionLifetime] TO RSExecRole

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FinalizeTempCatalogExtendedContentWrite
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FinalizeTempCatalogExtendedContentWrite]
    @Id bigint,
    @CatalogItemID UNIQUEIDENTIFIER
AS
BEGIN
    UPDATE
        [dbo].[CatalogItemExtendedContent]
    SET 
        [ItemID] = @CatalogItemID
    WHERE
        [Id] = @Id
END

GRANT EXECUTE ON [dbo].[FinalizeTempCatalogExtendedContentWrite] TO RSExecRole

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindFavoriteableItemsNonRecursive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindFavoriteableItemsNonRecursive]
@Path nvarchar (425),
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserIDWithNoCreate @UserSid, @UserName, @AuthType, @UserID OUTPUT

SET NOCOUNT ON;

SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.[UserName],
    CU.[UserName],
    MU.[UserName],
    MU.[UserName],
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID,
    CAST (CASE WHEN F.ItemId IS NULL THEN 0 ELSE 1 END AS BIT)
FROM
   Catalog AS C
   INNER JOIN [dbo].[Catalog] AS P ON C.ParentID = P.ItemID
   INNER JOIN [dbo].[Users] AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN [dbo].[Users] AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN [dbo].[SecData] SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
   LEFT OUTER JOIN [dbo].[Favorites] F ON C.ItemID = F.ItemID AND F.UserID = @UserID
WHERE P.Path = @Path
   AND C.Path <> '/68f0607b-9378-4bbb-9e70-4da3d7d66838' -- hide System Resources from output

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindFavoriteableItemsRecursive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindFavoriteableItemsRecursive]
@Path nvarchar (850),
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserIDWithNoCreate @UserSid, @UserName, @AuthType, @UserID OUTPUT

SET NOCOUNT ON;

SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.[UserName],
    CU.[UserName],
    MU.[UserName],
    MU.[UserName],
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID,
    CAST (CASE WHEN F.ItemId IS NULL THEN 0 ELSE 1 END AS BIT)
FROM
    Catalog AS C
    INNER JOIN [dbo].[Catalog] AS P ON C.ParentID = P.ItemID
    INNER JOIN [dbo].[Users] AS CU ON C.CreatedByID = CU.UserID
    INNER JOIN [dbo].[Users] AS MU ON C.ModifiedByID = MU.UserID
    LEFT OUTER JOIN [dbo].[SecData] SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
    LEFT OUTER JOIN [dbo].[Favorites] F ON C.ItemID = F.ItemID AND F.UserID = @UserID
WHERE C.Path LIKE @Path ESCAPE '*'
   AND (C.SubType IS NULL OR C.SubType <> 'MobileReportChild') -- Do not drill into associated mobile report items
   AND C.Path <> '/68f0607b-9378-4bbb-9e70-4da3d7d66838' -- hide System Resources folder from output
   AND C.Path NOT LIKE '/68f0607b-9378-4bbb-9e70-4da3d7d66838/%' -- hide System Resources from recursive output

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindItemsByDataSet
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindItemsByDataSet]
@ItemID uniqueidentifier,
@AuthType int,
@Type int = NULL
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.UserName,
    CU.UserName,
    MU.UserName,
    MU.UserName,
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C WITH (NOLOCK)
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
   INNER JOIN DataSets AS DS ON C.ItemID = DS.ItemID
WHERE
   (@Type IS NULL OR @Type = C.Type)
   AND DS.LinkID = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindItemsByDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindItemsByDataSource]
@ItemID uniqueidentifier,
@AuthType int
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.UserName,
    CU.UserName,
    MU.UserName,
    MU.UserName,
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
   INNER JOIN DataSource AS DS ON C.ItemID = DS.ItemID
WHERE
   DS.Link = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindItemsByDataSourceRecursive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindItemsByDataSourceRecursive]
@ItemID uniqueidentifier,
@AuthType int
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.UserName,
    CU.UserName,
    MU.UserName,
    MU.UserName,
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
   INNER JOIN
   (
        SELECT ItemID FROM DataSource
        WHERE Link = @ItemID
        UNION
        SELECT ItemID FROM DataSets
        WHERE LinkID IN
        (
            SELECT D1.ItemID
            FROM DataSource D1
            WHERE D1.Link = @ItemID
        )
    )
   AS DS ON C.ItemID = DS.ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindItemsToUpdateByDataSet
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindItemsToUpdateByDataSet]
@DataSetID uniqueidentifier
AS

select
        6, /* KpiDataUpdate enum. ToDo: Retrieve this from DB instead*/
        RS.[ScheduleID],
        DS.[ItemID],
        RS.[SubscriptionID],
        C.[Path],
        C.[Type]
from
    [DataSets] DS Inner join [Catalog] C on C.[ItemID] = DS.[ItemID]
    Inner join [ReportSchedule] RS on RS.[ReportID] = DS.[LinkID]
where
    DS.[LinkID] = @DataSetID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindObjectsByLink
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindObjectsByLink]
@Link uniqueidentifier,
@AuthType int
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.UserName,
    CU.UserName,
    MU.UserName,
    MU.UserName,
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
WHERE C.LinkSourceID = @Link

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindObjectsNonRecursive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindObjectsNonRecursive]
@Path nvarchar (425),
@AuthType int
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.[UserName],
    CU.[UserName],
    MU.[UserName],
    MU.[UserName],
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C
   INNER JOIN Catalog AS P ON C.ParentID = P.ItemID
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
WHERE P.Path = @Path
   AND C.Path <> '/68f0607b-9378-4bbb-9e70-4da3d7d66838' -- hide System Resources from output

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindObjectsRecursive
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindObjectsRecursive]
@Prefix nvarchar (850),
@AuthType int
AS
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.UserName,
    CU.UserName,
    MU.UserName,
    MU.UserName,
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
from
   Catalog AS C
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
WHERE C.Path LIKE @Prefix ESCAPE '*'
   AND C.Path <> '/68f0607b-9378-4bbb-9e70-4da3d7d66838' -- hide System Resources folder from output
   AND C.Path NOT LIKE '/68f0607b-9378-4bbb-9e70-4da3d7d66838/%' -- hide System Resources from recursive output

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FindParents
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FindParents]
@Path nvarchar (425),
@AuthType int
AS
WITH Parents (ItemID, ParentID)
AS
(
    SELECT ItemID, ParentID
    FROM Catalog WHERE Path = @Path
    UNION ALL
    SELECT C.ItemID, C.ParentID
    FROM Catalog C
    JOIN Parents P ON (C.ItemID = P.ParentID)
)
SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.[UserName],
    CU.[UserName],
    MU.[UserName],
    MU.[UserName],
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID
FROM
   Catalog AS C
   INNER JOIN Parents P ON (C.ItemID = P.ItemID)
   INNER JOIN Users AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN Users AS MU ON C.ModifiedByID = MU.UserID
   LEFT OUTER JOIN SecData SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
WHERE C.Path <> @Path -- Exclude the target item from the output list
ORDER BY DATALENGTH(C.Path) DESC

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FlushCacheByID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FlushCacheByID]
@ItemID as uniqueidentifier
AS
BEGIN

DECLARE @AffectedSnapshots table (SnapshotDataID uniqueidentifier)

DELETE FROM [ReportServerTempDB].dbo.ExecutionCache
OUTPUT DELETED.SnapshotDataID into @AffectedSnapshots
WHERE ReportID = @ItemID

UPDATE [ReportServerTempDB].dbo.SnapshotData
SET PermanentRefcount = PermanentRefcount - 1
WHERE SnapshotDataID IN (SELECT SnapshotDataID FROM @AffectedSnapshots)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FlushContentCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FlushContentCache]
    @Path as nvarchar(425)
AS
    SET DEADLOCK_PRIORITY LOW
    SET NOCOUNT ON
    DECLARE @CatalogItemID AS UNIQUEIDENTIFIER

    SELECT @CatalogItemID=ItemID FROM [dbo].[Catalog] WHERE [Path]=@Path

    DELETE
    FROM
       [ReportServerTempDB].dbo.[ContentCache]
    WHERE
       CatalogItemID = @CatalogItemID

    SELECT @@ROWCOUNT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FlushReportFromCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[FlushReportFromCache]
@Path as nvarchar(425)
AS

SET DEADLOCK_PRIORITY LOW

-- VSTS #139360: SQL Deadlock in GetReportForexecution stored procedure
-- Use temporary table to keep the same order of accessing the ExecutionCache
-- and SnapshotData tables as GetReportForExecution does, that is first
-- delete from the ExecutionCache, then update the SnapshotData
CREATE TABLE #tempSnapshot (SnapshotDataID uniqueidentifier)
INSERT INTO #tempSnapshot SELECT SN.SnapshotDataID
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN WITH (UPDLOCK)
   INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC WITH (UPDLOCK) ON SN.SnapshotDataID = EC.SnapshotDataID
   INNER JOIN Catalog AS C ON EC.ReportID = C.ItemID
WHERE C.Path = @Path

DELETE EC
FROM
   [ReportServerTempDB].dbo.ExecutionCache AS EC
   INNER JOIN #tempSnapshot ON #tempSnapshot.SnapshotDataID = EC.SnapshotDataID

UPDATE SN
   SET SN.PermanentRefcount = SN.PermanentRefcount - 1
FROM
   [ReportServerTempDB].dbo.SnapshotData AS SN
   INNER JOIN #tempSnapshot ON #tempSnapshot.SnapshotDataID = SN.SnapshotDataID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_sqlagent_job_status
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Get_sqlagent_job_status]
  -- Individual job parameters
  @job_id                     UNIQUEIDENTIFIER = NULL,  -- If provided will only return info about this job
                                                        --   Note: Only @job_id or @job_name needs to be provided
  @job_name                   sysname          = NULL,  -- If provided will only return info about this job
  @owner_login_name           sysname          = NULL   -- If provided will only return jobs for this owner
AS
BEGIN
  DECLARE @retval           INT
  DECLARE @job_owner_sid    VARBINARY(85)
  DECLARE @is_sysadmin      INT

  SET NOCOUNT ON

  -- Remove any leading/trailing spaces from parameters (except @owner_login_name)
  SELECT @job_name         = LTRIM(RTRIM(@job_name))

  -- Turn [nullable] empty string parameters into NULLs
  IF (@job_name         = N'') SELECT @job_name = NULL


  -- Verify the job if supplied. This also checks if the caller has rights to view the job
  IF ((@job_id IS NOT NULL) OR (@job_name IS NOT NULL))
  BEGIN
    EXECUTE @retval = msdb..sp_verify_job_identifiers '@job_name',
                                                      '@job_id',
                                                       @job_name OUTPUT,
                                                       @job_id   OUTPUT
    IF (@retval <> 0)
      RETURN(1) -- Failure

  END

  -- If the login name isn't given, set it to the job owner or the current caller
  IF(@owner_login_name IS NULL)
  BEGIN

    SET @owner_login_name = (SELECT SUSER_SNAME(sj.owner_sid) FROM msdb.dbo.sysjobs sj where sj.job_id = @job_id)

    SET @is_sysadmin = ISNULL(IS_SRVROLEMEMBER(N'sysadmin', @owner_login_name), 0)

  END
  ELSE
  BEGIN
    -- Check owner
    IF (SUSER_SID(@owner_login_name) IS NULL)
    BEGIN
      RAISERROR(14262, -1, -1, '@owner_login_name', @owner_login_name)
      RETURN(1) -- Failure
    END

    --only allow sysadmin types to specify the owner
    IF ((ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) <> 1) AND
        (ISNULL(IS_MEMBER(N'SQLAgentAdminRole'), 0) = 1) AND
        (SUSER_SNAME() <> @owner_login_name))
    BEGIN
      --TODO: RAISERROR(14525, -1, -1)
      RETURN(1) -- Failure
    END

    SET @is_sysadmin = 0
  END


  IF (@job_id IS NOT NULL)
  BEGIN
    -- Individual job...
    EXECUTE @retval =  master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @owner_login_name, @job_id
    IF (@retval <> 0)
      RETURN(1) -- Failure

  END
  ELSE
  BEGIN
    -- Set of jobs...
    EXECUTE @retval =  master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @owner_login_name
    IF (@retval <> 0)
      RETURN(1) -- Failure

  END

  RETURN(0) -- Success
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAlertSubscribers
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAlertSubscribers]
    @ItemID uniqueidentifier,
    @AlertType nvarchar(50)
AS
BEGIN
    SELECT
        U.[DefaultEmailAddress]
    FROM
        [AlertSubscribers] as A
        INNER JOIN UserContactInfo as U ON A.[UserID] = U.[UserID]
    WHERE
        A.[ItemID] = @ItemID
        AND
        A.[AlertType] = @AlertType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAlertSubscriptionID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAlertSubscriptionID]
@UserID uniqueidentifier,
@ItemID uniqueidentifier,
@AlertType nvarchar(50)
AS
BEGIN
    SELECT
        AlertSubscriptionID
    FROM [AlertSubscribers]
    WHERE
        UserID = @UserID AND
        ItemID = @ItemID AND
        AlertType = @AlertType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAllConfigurationInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAllConfigurationInfo]
AS
SELECT [Name], [Value]
FROM [ConfigurationInfo]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAllFavoriteItems
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAllFavoriteItems]
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserIDWithNoCreate @UserSid, @UserName, @AuthType, @UserID OUTPUT

SET NOCOUNT ON;

SELECT
    C.Type,
    C.PolicyID,
    SD.NtSecDescPrimary,
    C.Name,
    C.Path,
    C.ItemID,
    C.ContentSize AS [Size],
    C.Description,
    C.CreationDate,
    C.ModifiedDate,
    CU.[UserName],
    CU.[UserName],
    MU.[UserName],
    MU.[UserName],
    C.MimeType,
    C.ExecutionTime,
    C.Hidden,
    C.SubType,
    C.ComponentID,
    CAST(1 AS bit)
FROM
   Catalog AS C
   INNER JOIN [dbo].[Catalog] AS P ON C.ParentID = P.ItemID
   INNER JOIN [dbo].[Users] AS CU ON C.CreatedByID = CU.UserID
   INNER JOIN [dbo].[Users] AS MU ON C.ModifiedByID = MU.UserID
   INNER JOIN [dbo].[Favorites] F ON C.ItemID = F.ItemID AND F.UserID = @UserID
   LEFT OUTER JOIN [dbo].[SecData] SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAllProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAllProperties]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN

DECLARE @OwnerID uniqueidentifier
if(@EditSessionID is not null)
BEGIN
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT
END

select
   iif( Catalog.LinkSourceID is null, Catalog.Property, Linked.Property) as Property, 
   Catalog.Description,
   Catalog.Type,
   Catalog.ContentSize,
   Catalog.ItemID,
   C.UserName,
   C.UserName,
   Catalog.CreationDate,
   M.UserName,
   M.UserName,
   Catalog.ModifiedDate,
   Catalog.MimeType,
   Catalog.ExecutionTime,
   SecData.NtSecDescPrimary,
   Catalog.LinkSourceID,
   Catalog.Hidden,
   Catalog.ExecutionFlag,
   Catalog.SnapshotLimit,
   Catalog.Name,
   Catalog.SubType,
   Catalog.ComponentID,
   Catalog.ParentID,
   Catalog.Property AS LinkedItemProperty
FROM ExtendedCatalog(@OwnerID, @Path, @EditSessionID) Catalog
   INNER JOIN Users C ON Catalog.CreatedByID = C.UserID
   INNER JOIN Users M ON Catalog.ModifiedByID = M.UserID
   LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
   LEFT OUTER JOIN Catalog Linked ON Linked.ItemID = Catalog.LinkSourceID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAnnouncedKey
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAnnouncedKey]
@InstallationID uniqueidentifier
AS

select PublicKey, MachineName, InstanceName
from Keys
where InstallationID = @InstallationID and Client = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetAReportsReportAction
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetAReportsReportAction]
@ReportID uniqueidentifier,
@ReportAction int
AS
select
        RS.[ReportAction],
        RS.[ScheduleID],
        RS.[ReportID],
        RS.[SubscriptionID],
        C.[Path],
        C.[Type]
from
    [ReportSchedule] RS Inner join [Catalog] C on RS.[ReportID] = C.[ItemID]
where
    C.ItemID = @ReportID and RS.[ReportAction] = @ReportAction

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetBatchRecords
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetBatchRecords]
@BatchID uniqueidentifier
AS
SELECT [Action], Item, Parent, Param, BoolParam, Content, Properties
FROM [Batch]
WHERE BatchID = @BatchID
ORDER BY AddedOn

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCacheOptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCacheOptions]
@Path as nvarchar(425)
AS
    SELECT ExpirationFlags, CacheExpiration,
    S.[ScheduleID],
    S.[Name],
    S.[StartDate],
    S.[Flags],
    S.[NextRunTime],
    S.[LastRunTime],
    S.[EndDate],
    S.[RecurrenceType],
    S.[MinutesInterval],
    S.[DaysInterval],
    S.[WeeksInterval],
    S.[DaysOfWeek],
    S.[DaysOfMonth],
    S.[Month],
    S.[MonthlyWeek],
    S.[State],
    S.[LastRunStatus],
    S.[ScheduledRunTimeout],
    S.[EventType],
    S.[EventData],
    S.[Type],
    S.[Path]
    FROM CachePolicy INNER JOIN Catalog ON Catalog.ItemID = CachePolicy.ReportID
    LEFT outer join reportschedule rs on catalog.itemid = rs.reportid and rs.reportaction = 3
    LEFT OUTER JOIN [Schedule] S ON S.ScheduleID = rs.ScheduleID
    LEFT OUTER JOIN [Users] Owner on Owner.UserID = S.[CreatedById]
    WHERE Catalog.Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCacheSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCacheSchedule]
@ReportID uniqueidentifier
AS
SELECT
    S.[ScheduleID],
    S.[Name],
    S.[StartDate],
    S.[Flags],
    S.[NextRunTime],
    S.[LastRunTime],
    S.[EndDate],
    S.[RecurrenceType],
    S.[MinutesInterval],
    S.[DaysInterval],
    S.[WeeksInterval],
    S.[DaysOfWeek],
    S.[DaysOfMonth],
    S.[Month],
    S.[MonthlyWeek],
    S.[State],
    S.[LastRunStatus],
    S.[ScheduledRunTimeout],
    S.[EventType],
    S.[EventData],
    S.[Type],
    S.[Path],
    Owner.[UserName],
    Owner.[UserName],
    Owner.[AuthType],
    RS.ReportAction
FROM
    Schedule S with (XLOCK) inner join ReportSchedule RS on S.ScheduleID = RS.ScheduleID
    inner join [Users] Owner on S.[CreatedById] = Owner.[UserID]
WHERE
    (RS.ReportAction = 1 or RS.ReportAction = 3) and -- 1 == UpdateCache, 3 == Invalidate cache
    RS.[ReportID] = @ReportID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCatalogContentData
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCatalogContentData]
    @CatalogItemID uniqueidentifier
AS
BEGIN
    SELECT
        COALESCE(DATALENGTH([Content]), 0) AS ContentLength,
        [Content]
    FROM
        [Catalog]
    WHERE
        [ItemID] = @CatalogItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCatalogExtendedContentData
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCatalogExtendedContentData]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50)
AS
BEGIN
    SELECT
        DATALENGTH([Content]) AS ContentLength,
        [Content]
    FROM
        [CatalogItemExtendedContent]  WITH (READPAST) -- Ignoring rows that are in middle of a transaction
    WHERE
        [ItemID] = @CatalogItemID AND ContentType = @ContentType

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCatalogExtendedContentLastUpdate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCatalogExtendedContentLastUpdate]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50)
AS
BEGIN
    SELECT
        ModifiedDate
    FROM
        [CatalogItemExtendedContent]  WITH (READPAST) -- Ignoring rows that are in middle of a transaction
    WHERE
        [ItemID] = @CatalogItemID AND ContentType = @ContentType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCatalogItemProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCatalogItemProperties]
@CatalogItemID AS uniqueidentifier
AS

SELECT
   [ItemID] AS [ItemId],
   [Path],
   [Name],
   [Type],
   [ContentSize] AS [SizeInBytes],
   C.[UserName] AS [CreatorUserName],
   [CreationDate],
   M.[UserName] AS [ModifierUserName],
   [Catalog].[ModifiedDate],
   [MimeType],
   [Hidden]
FROM
    [Catalog]
    INNER JOIN Users C ON [Catalog].CreatedByID = C.UserID
    INNER JOIN Users M ON [Catalog].ModifiedByID = M.UserID
WHERE
    [ItemID] = @CatalogItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetChildrenBeforeDelete
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetChildrenBeforeDelete]
@Prefix nvarchar (850),
@AuthType int
AS
SELECT C.PolicyID, C.Type, SD.NtSecDescPrimary
FROM
   Catalog AS C LEFT OUTER JOIN SecData AS SD ON C.PolicyID = SD.PolicyID AND SD.AuthType = @AuthType
WHERE
   C.Path LIKE @Prefix ESCAPE '*'  -- return children only, not item itself
   AND C.SubType <> 'MobileReportChild' -- Ignore resources from mobile reports

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetChunkInformation
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetChunkInformation]
@SnapshotDataID uniqueidentifier,
@IsPermanentSnapshot bit,
@ChunkName nvarchar(260),
@ChunkType int
AS
IF @IsPermanentSnapshot != 0 BEGIN

    SELECT
       MimeType
    FROM
       ChunkData AS CH WITH (HOLDLOCK, ROWLOCK)
    WHERE
       SnapshotDataID = @SnapshotDataID AND
       ChunkName = @ChunkName AND
       ChunkType = @ChunkType

END ELSE BEGIN

    SELECT
       MimeType
    FROM
       [ReportServerTempDB].dbo.ChunkData AS CH WITH (HOLDLOCK, ROWLOCK)
    WHERE
       SnapshotDataID = @SnapshotDataID AND
       ChunkName = @ChunkName AND
       ChunkType = @ChunkType

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetChunkPointerAndLength
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetChunkPointerAndLength]
@SnapshotDataID uniqueidentifier,
@IsPermanentSnapshot bit,
@ChunkName nvarchar(260),
@ChunkType int
AS
IF @IsPermanentSnapshot != 0 BEGIN

    SELECT
       TEXTPTR(Content),
       DATALENGTH(Content),
       MimeType,
       ChunkFlags,
       Version
    FROM
       ChunkData AS CH
    WHERE
       SnapshotDataID = @SnapshotDataID AND
       ChunkName = @ChunkName AND
       ChunkType = @ChunkType

END ELSE BEGIN

    SELECT
       TEXTPTR(Content),
       DATALENGTH(Content),
       MimeType,
       ChunkFlags,
       Version
    FROM
       [ReportServerTempDB].dbo.ChunkData AS CH
    WHERE
       SnapshotDataID = @SnapshotDataID AND
       ChunkName = @ChunkName AND
       ChunkType = @ChunkType

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCommentByCommentID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCommentByCommentID]
@CommentID bigint
AS
BEGIN
    SELECT TOP(1)
        C.[CommentID],
        C.[ItemID],
        U.[UserName],
        C.[ThreadID],
        C.[Text],
        C.[CreatedDate],
        C.[ModifiedDate],
        CAI.[Path] AS ItemPath,
        CAA.[Path] AS AttachmentPath,
        CAI.[Name]
    FROM
        [Comments] as C
        INNER JOIN Users as U ON C.[UserID] = U.[UserID]
        INNER JOIN Catalog as CAI ON C.[ItemID] = CAI.[ItemID]
        LEFT JOIN Catalog as CAA ON C.[AttachmentID] = CAA.[ItemID]
    WHERE
        C.[CommentID] = @CommentID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCommentsByItemID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCommentsByItemID]
@ItemID uniqueidentifier
AS
BEGIN
    SELECT
        C.[CommentID],
        C.[ItemID],
        U.[UserName],
        C.[ThreadID],
        C.[Text],
        C.[CreatedDate],
        C.[ModifiedDate],
        CA.[Path] AS AttachmentPath
    FROM
        [Comments] as C
        INNER JOIN Users as U ON C.[UserID] = U.[UserID]
        LEFT JOIN Catalog as CA ON C.[AttachmentID] = CA.[ItemID]
    WHERE
        C.[ItemID] = @ItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCompiledDefinition
-- --------------------------------------------------
-- used to create snapshots
CREATE PROCEDURE [dbo].[GetCompiledDefinition]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN

DECLARE @OwnerID uniqueidentifier
if(@EditSessionID is not null)
BEGIN
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT
END

    SELECT
       MainItem.Type,
       MainItem.Intermediate,
       MainItem.LinkSourceID,
       MainItem.Property,
       MainItem.Description,
       SecData.NtSecDescPrimary,
       MainItem.ItemID,
       MainItem.ExecutionFlag,
       LinkTarget.Intermediate,
       LinkTarget.Property,
       LinkTarget.Description,
       MainItem.[SnapshotDataID],
       MainItem.IntermediateIsPermanent
    FROM ExtendedCatalog(@OwnerID, @Path, @EditSessionID) MainItem
    LEFT OUTER JOIN SecData ON MainItem.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
    LEFT OUTER JOIN Catalog LinkTarget with (INDEX(PK_Catalog)) on MainItem.LinkSourceID = LinkTarget.ItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetContentCache
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetContentCache]
    @CatalogItemID uniqueidentifier,
    @ParamsHash int,
    @ContentType nvarchar(256)
AS
BEGIN
    DECLARE @now as DateTime
    SET @now = GETDATE()

    SELECT ContentCacheID, CatalogItemID, CreatedDate, ParamsHash, ExpirationDate, Version, ContentType, Content
    FROM [ReportServerTempDB].dbo.ContentCache WITH (NOLOCK)
    WHERE
        CatalogItemID = @CatalogItemID
        AND ParamsHash = @ParamsHash
        AND ContentType = @ContentType
        AND ExpirationDate > @now
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetContentCacheDetails
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetContentCacheDetails]
    @CatalogItemID uniqueidentifier,
    @ParamsHash int,
    @ContentType nvarchar(256)
AS
BEGIN
    DECLARE @now as DateTime
    SET @now = GETDATE()

    SELECT ContentCacheID, CatalogItemID, CreatedDate, ParamsHash, EffectiveParams, ExpirationDate, Version, ContentType
    FROM [ReportServerTempDB].dbo.ContentCache WITH (NOLOCK)
    WHERE
        CatalogItemID = @CatalogItemID
        AND ParamsHash = @ParamsHash
        AND ContentType = @ContentType
        AND ExpirationDate > @now
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetCurrentProductInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetCurrentProductInfo]
AS
    SELECT TOP 1 [DbSchemaHash], [Sku], [BuildNumber]
    FROM [dbo].[ProductInfoHistory]
    ORDER BY DateTime DESC

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataModelDatasourceForReencryption
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataModelDatasourceForReencryption]
@DSID as bigint
AS

SELECT
    [ConnectionString],
    [Username],
    [Password]
FROM [dbo].[DataModelDataSource]
WHERE [DSID] = @DSID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataModelDataSourcesByItemID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataModelDataSourcesByItemID]
    @ItemID uniqueidentifier
AS
    SELECT
        D.DSID,
        D.ItemId,
        D.DSType,
        D.DSKind,
        D.AuthType,
        D.ConnectionString,
        D.Username,
        D.Password,
        CU.UserName AS CreatedBy,
        D.CreatedDate,
        MU.UserName AS ModifiedBy,
        D.ModifiedDate,
        D.DataSourceID,
        D.ModelConnectionName
    FROM
        [DataModelDataSource] as D
        INNER JOIN [dbo].[Users] AS CU ON D.CreatedByID = CU.UserID
        INNER JOIN [dbo].[Users] AS MU ON D.ModifiedByID = MU.UserID
    WHERE
        D.[ItemID] = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataModelRoleAssignmentsByItemID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataModelRoleAssignmentsByItemID]
    @ItemID uniqueidentifier
AS
    SELECT
        UR.[UserID],
        U.[UserName],
        R.[DataModelRoleID],
        R.[ModelRoleID],
        R.[ModelRoleName]
    FROM
        [dbo].[UserDataModelRole] UR
        INNER JOIN [dbo].[DataModelRole] R ON R.[DataModelRoleID] = UR.[DataModelRoleID]
        INNER JOIN [dbo].[Users] U ON U.[UserID] = UR.[UserID]
    WHERE
        [ItemID] = @ItemID
    ORDER BY UR.[UserID]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataModelRolesByItemID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataModelRolesByItemID]
    @ItemID uniqueidentifier
AS
    SELECT
        [DataModelRoleID],
        [ItemID],
        [ModelRoleID],
        [ModelRoleName]
    FROM
        [dbo].[DataModelRole]
    WHERE
        [ItemID] = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataSetForExecution
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataSetForExecution]
@ItemID uniqueidentifier,
@ParamsHash int
AS
DECLARE @now AS datetime
SET @now = GETDATE()
SELECT
    SN.SnapshotDataID,
    SN.EffectiveParams,
    SN.QueryParams,
    (SELECT CachePolicy.ExpirationFlags FROM CachePolicy WHERE CachePolicy.ReportID = Cat.ItemID),
    Cat.Property
FROM
    Catalog AS Cat
    LEFT OUTER JOIN
    (
        SELECT
        TOP 1
            ReportID,
            SN.SnapshotDataID,
            EffectiveParams,
            QueryParams
        FROM [ReportServerTempDB].dbo.ExecutionCache AS EC
        INNER JOIN [ReportServerTempDB].dbo.SnapshotData AS SN ON EC.SnapshotDataID = SN.SnapshotDataID AND EC.ParamsHash = SN.ParamsHash
        WHERE
            AbsoluteExpiration > @now
            AND SN.ParamsHash = @ParamsHash
            AND EC.ReportID = @ItemID
        ORDER BY SN.CreatedDate DESC
    ) as SN ON Cat.ItemID = SN.ReportID
WHERE
    Cat.ItemID = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataSets
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[GetDataSets]
@ItemID [uniqueidentifier],
@AuthType int
AS
BEGIN

SELECT
    DS.ID,
    DS.LinkID,
    DS.[Name],
    C.Path,
    SD.NtSecDescPrimary,
    C.Intermediate,
    C.[Parameter]
FROM
   ExtendedDataSets AS DS
   LEFT OUTER JOIN Catalog C ON DS.[LinkID] = C.[ItemID]
   LEFT OUTER JOIN [SecData] AS SD ON C.[PolicyID] = SD.[PolicyID] AND SD.AuthType = @AuthType
WHERE
   DS.[ItemID] = @ItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataSourceForUpgrade
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDataSourceForUpgrade]
@CurrentVersion int
AS
SELECT
    [DSID]
FROM
    [DataSource]
WHERE
    [Version] != @CurrentVersion

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDatasourceInfoForReencryption
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDatasourceInfoForReencryption]
@DSID as uniqueidentifier
AS

SELECT
    [ConnectionString],
    [OriginalConnectionString],
    [UserName],
    [Password],
    [CredentialRetrieval],
    [Version]
FROM [dbo].[DataSource]
WHERE [DSID] = @DSID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDataSources
-- --------------------------------------------------
CREATE  PROCEDURE [dbo].[GetDataSources]
@ItemID [uniqueidentifier],
@AuthType int
AS
BEGIN

SELECT -- select data sources and their links (if they exist)
    DS.[DSID],      -- 0
    DS.[ItemID],    -- 1
    DS.[Name],      -- 2
    DS.[Extension], -- 3
    DS.[Link],      -- 4
    DS.[CredentialRetrieval], -- 5
    DS.[Prompt],    -- 6
    DS.[ConnectionString], -- 7
    DS.[OriginalConnectionString], -- 8
    DS.[UserName],  -- 9
    DS.[Password],  -- 10
    DS.[Flags],     -- 11
    DSL.[DSID] AS DSLinkDSID,     -- 12
    DSL.[ItemID] AS DSLinkItemId,   -- 13
    DSL.[Name] AS DSLinkName,     -- 14
    DSL.[Extension] AS DSLinkExtension, -- 15
    DSL.[Link] AS DSLinkLink,     -- 16
    DSL.[CredentialRetrieval] AS DSLinkCredentialRetrieval, -- 17
    DSL.[Prompt] AS DSLinkPrompt,   -- 18
    DSL.[ConnectionString] AS DSLinkConnectionString, -- 19
    DSL.[UserName] AS DSLinkUserName, -- 20
    DSL.[Password] AS DSLinkPassword, -- 21
    DSL.[Flags] AS DSLinkFlags,	-- 22
    C.Path,         -- 23
    SD.NtSecDescPrimary, -- 24
    DS.[OriginalConnectStringExpressionBased], -- 25
    DS.[Version], -- 26
    DSL.[Version] AS DSLinkVersion, -- 27
    (SELECT 1 WHERE EXISTS (SELECT * from [ModelItemPolicy] AS MIP WHERE C.[ItemID] = MIP.[CatalogItemID])) AS IsModelItemPolicyEnabled, -- 28
    DS.[DSIDNum] --29
FROM
   ExtendedDataSources AS DS
   LEFT OUTER JOIN
    (DataSource AS DSL
     INNER JOIN Catalog C ON DSL.[ItemID] = C.[ItemID]
       LEFT OUTER JOIN [SecData] AS SD ON C.[PolicyID] = SD.[PolicyID] AND SD.AuthType = @AuthType)
   ON DS.[Link] = DSL.[ItemID]
WHERE
   DS.[ItemID] = @ItemID or DS.[SubscriptionID] = @ItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDBVersion
-- --------------------------------------------------

    CREATE PROCEDURE [dbo].[GetDBVersion]
    @DBVersion nvarchar(32) OUTPUT
    AS
    SET @DBVersion = (select top(1) [ServerVersion] from [dbo].[ServerUpgradeHistory] ORDER BY [UpgradeID] DESC)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDefaultEmail
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDefaultEmail]
    @UserID uniqueidentifier
AS
BEGIN
    SELECT TOP(1)
        U.[DefaultEmailAddress]
    FROM
        [UserContactInfo] as U
    WHERE
        U.UserID = @UserID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDrillthroughReport
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDrillthroughReport]
@ModelPath nvarchar(425),
@ModelItemID nvarchar(425),
@Type tinyint
AS
 SELECT
 CatRep.Path
 FROM ModelDrill
 INNER JOIN Catalog CatMod ON ModelDrill.ModelID = CatMod.ItemID
 INNER JOIN Catalog CatRep ON ModelDrill.ReportID = CatRep.ItemID
 WHERE CatMod.Path = @ModelPath
 AND ModelItemID = @ModelItemID
 AND ModelDrill.[Type] = @Type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDrillthroughReports
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetDrillthroughReports]
@ModelID uniqueidentifier,
@ModelItemID nvarchar(425)
AS
 SELECT
 ModelDrill.Type,
 Catalog.Path
 FROM ModelDrill INNER JOIN Catalog ON ModelDrill.ReportID = Catalog.ItemID
 WHERE ModelID = @ModelID
 AND ModelItemID = @ModelItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetExecutionOptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetExecutionOptions]
@Path nvarchar(425)
AS
    SELECT ExecutionFlag,
    S.[ScheduleID],
    S.[Name],
    S.[StartDate],
    S.[Flags],
    S.[NextRunTime],
    S.[LastRunTime],
    S.[EndDate],
    S.[RecurrenceType],
    S.[MinutesInterval],
    S.[DaysInterval],
    S.[WeeksInterval],
    S.[DaysOfWeek],
    S.[DaysOfMonth],
    S.[Month],
    S.[MonthlyWeek],
    S.[State],
    S.[LastRunStatus],
    S.[ScheduledRunTimeout],
    S.[EventType],
    S.[EventData],
    S.[Type],
    S.[Path]
    FROM Catalog
    LEFT OUTER JOIN ReportSchedule ON Catalog.ItemID = ReportSchedule.ReportID AND ReportSchedule.ReportAction = 1
    LEFT OUTER JOIN [Schedule] S ON S.ScheduleID = ReportSchedule.ScheduleID
    LEFT OUTER JOIN [Users] Owner on Owner.UserID = S.[CreatedById]
    WHERE Catalog.Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetFirstPortionPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetFirstPortionPersistedStream]
@SessionID varchar(32)
AS

SELECT
    TOP 1
    TEXTPTR(P.Content),
    DATALENGTH(P.Content),
    P.[Index],
    P.[Name],
    P.MimeType,
    P.Extension,
    P.Encoding,
    P.Error
FROM
    [ReportServerTempDB].dbo.PersistedStream P WITH (XLOCK)
WHERE
    P.SessionID = @SessionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetIDPairsByLink
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetIDPairsByLink]
@Link uniqueidentifier
AS
SELECT LinkSourceID, ItemID
FROM Catalog
WHERE LinkSourceID = @Link

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetInvalidPolicies
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetInvalidPolicies]
    @TopCount int,
    @AuthType int
AS
BEGIN
    SELECT
        PolicyRoles.PolicyID,
        TopDirtyPolicies.XmlDescription,
        PolicyRoles.PolicyFlag,
        Catalog.Type,
        Catalog.Path,
        ModelItemPolicy.CatalogItemID,
        ModelItemPolicy.ModelItemID,
        PolicyRoles.RoleID,
        PolicyRoles.RoleName,
        PolicyRoles.TaskMask,
        PolicyRoles.RoleFlags
    FROM
        (SELECT TOP (@TopCount)
            PolicyId,
            XmlDescription
        FROM
            SecData
        WHERE SecData.NtSecDescState = 1 AND SecData.AuthType = @AuthType) TopDirtyPolicies

        INNER JOIN

        (SELECT
            DISTINCT
            PolicyUserRole.PolicyID,
            Roles.RoleID,
            Roles.RoleName,
            Roles.TaskMask,
            Roles.RoleFlags,
            Policies.PolicyFlag
        FROM
            PolicyUserRole
            INNER JOIN Roles ON PolicyUserRole.RoleID = Roles.RoleID
            INNER JOIN Policies ON PolicyUserRole.PolicyID = Policies.PolicyID
        ) PolicyRoles
        ON PolicyRoles.PolicyId = TopDirtyPolicies.PolicyID
        LEFT OUTER JOIN Catalog ON PolicyRoles.PolicyID = Catalog.PolicyID AND Catalog.PolicyRoot = 1
        LEFT OUTER JOIN ModelItemPolicy ON PolicyRoles.PolicyID = ModelItemPolicy.PolicyID
    ORDER BY PolicyRoles.PolicyID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetModelDefinition
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetModelDefinition]
@CatalogItemID as uniqueidentifier
AS

SELECT
    C.[Content]
FROM
    [Catalog] AS C
WHERE
    C.[ItemID] = @CatalogItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetModelItemInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetModelItemInfo]
@Path nvarchar (425),
@UseUpdateLock bit
AS
    IF(@UseUpdateLock = 0)
    BEGIN
        SELECT
            C.[Intermediate]
        FROM
            [Catalog] AS C
        WHERE
            C.[Path] = @Path
    END
    ELSE BEGIN
        -- acquire update lock, this means that the operation is being performed in a
        -- different transaction context which will be committed before trying to
        -- perform the actual load, to prevent deadlock in the case where we have to
        -- republish, this new transaction will acquire and hold upgrade locks
        SELECT
            C.[Intermediate]
        FROM
            [Catalog] AS C WITH(UPDLOCK ROWLOCK)
        WHERE
            C.[Path] = @Path
    END

    SELECT
        MIP.[ModelItemID], SD.[NtSecDescPrimary], SD.[XmlDescription]
    FROM
        [Catalog] AS C
        INNER JOIN [ModelItemPolicy] AS MIP ON C.[ItemID] = MIP.[CatalogItemID]
        LEFT OUTER JOIN [SecData] AS SD ON MIP.[PolicyID] = SD.[PolicyID]
    WHERE
        C.[Path] = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetModelPerspectives
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetModelPerspectives]
@Path nvarchar (425),
@AuthType int
AS

SELECT
    C.[Type],
    SD.[NtSecDescPrimary],
    C.[Description]
FROM
    [Catalog] as C
    LEFT OUTER JOIN [SecData] AS SD ON C.[PolicyID] = SD.[PolicyID] AND SD.[AuthType] = @AuthType
WHERE
    [Path] = @Path

SELECT
    P.[PerspectiveID],
    P.[PerspectiveName],
    P.[PerspectiveDescription]
FROM
    [Catalog] as C
    INNER JOIN [ModelPerspective] as P ON C.[ItemID] = P.[ModelID]
WHERE
    [Path] = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetModelsAndPerspectives
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetModelsAndPerspectives]
@AuthType int,
@SitePathPrefix nvarchar(520) = '%'
AS

SELECT
    C.[PolicyID],
    SD.[NtSecDescPrimary],
    C.[ItemID],
    C.[Path],
    C.[Description],
    P.[PerspectiveID],
    P.[PerspectiveName],
    P.[PerspectiveDescription]
FROM
    [Catalog] as C
    LEFT OUTER JOIN [ModelPerspective] as P ON C.[ItemID] = P.[ModelID]
    LEFT OUTER JOIN [SecData] AS SD ON C.[PolicyID] = SD.[PolicyID] AND SD.[AuthType] = @AuthType
WHERE
    C.Path like @SitePathPrefix AND C.[Type] = 6 -- Model
ORDER BY
    C.[Path]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetMyRunningJobs
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetMyRunningJobs]
@ComputerName as nvarchar(32),
@JobType as smallint
AS
SELECT JobID, StartDate, ComputerName, RequestName, RequestPath, SUSER_SNAME(Users.[Sid]), Users.[UserName], Description,
    Timeout, JobAction, JobType, JobStatus, Users.[AuthType]
FROM RunningJobs INNER JOIN Users
ON RunningJobs.UserID = Users.UserID
WHERE ComputerName = @ComputerName
AND JobType = @JobType

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetNameById
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetNameById]
@ItemID uniqueidentifier
AS
SELECT Path
FROM Catalog
WHERE ItemID = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetNextPortionPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetNextPortionPersistedStream]
@DataPointer binary(16),
@DataIndex int,
@Length int
AS

READTEXT [ReportServerTempDB].dbo.PersistedStream.Content @DataPointer @DataIndex @Length

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetObjectContent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetObjectContent]
@Path nvarchar (425),
@AuthType int
AS
SELECT Type, Content, LinkSourceID, MimeType, SecData.NtSecDescPrimary, ItemID
FROM Catalog
LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
WHERE Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetOneConfigurationInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetOneConfigurationInfo]
@Name nvarchar (260)
AS
SELECT [Value]
FROM [ConfigurationInfo]
WHERE [Name] = @Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetParameters]
@Path nvarchar (425),
@AuthType int
AS
SELECT
   Type,
   [Parameter],
   ItemID,
   SecData.NtSecDescPrimary,
   [LinkSourceID],
   [ExecutionFlag]
FROM Catalog
LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
WHERE Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetPoliciesForRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetPoliciesForRole]
@RoleName as nvarchar(260),
@AuthType as int
AS
SELECT
    Policies.PolicyID,
    SecData.XmlDescription,
    Policies.PolicyFlag,
    Catalog.Type,
    Catalog.Path,
    ModelItemPolicy.CatalogItemID,
    ModelItemPolicy.ModelItemID,
    RelatedRoles.RoleID,
    RelatedRoles.RoleName,
    RelatedRoles.TaskMask,
    RelatedRoles.RoleFlags
FROM
    Roles
    INNER JOIN PolicyUserRole ON Roles.RoleID = PolicyUserRole.RoleID
    INNER JOIN Policies ON PolicyUserRole.PolicyID = Policies.PolicyID
    INNER JOIN PolicyUserRole AS RelatedPolicyUserRole ON Policies.PolicyID = RelatedPolicyUserRole.PolicyID
    INNER JOIN Roles AS RelatedRoles ON RelatedPolicyUserRole.RoleID = RelatedRoles.RoleID
    LEFT OUTER JOIN SecData ON Policies.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
    LEFT OUTER JOIN Catalog ON Policies.PolicyID = Catalog.PolicyID AND Catalog.PolicyRoot = 1
    LEFT OUTER JOIN ModelItemPolicy ON Policies.PolicyID = ModelItemPolicy.PolicyID
WHERE
    Roles.RoleName = @RoleName
ORDER BY
    Policies.PolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetPolicy
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetPolicy]
@ItemName as nvarchar(425),
@AuthType int
AS
SELECT SecData.XmlDescription, Catalog.PolicyRoot , SecData.NtSecDescPrimary, Catalog.Type
FROM Catalog
INNER JOIN Policies ON Catalog.PolicyID = Policies.PolicyID
LEFT OUTER JOIN SecData ON Policies.PolicyID = SecData.PolicyID AND AuthType = @AuthType
WHERE Catalog.Path = @ItemName
AND PolicyFlag = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetPolicyByItemId
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetPolicyByItemId]
    @ItemId as UNIQUEIDENTIFIER,
    @AuthType INT
AS
    SELECT SecData.XmlDescription, Catalog.PolicyRoot, Catalog.Type
    FROM Catalog
        INNER JOIN Policies ON Catalog.PolicyID = Policies.PolicyID
        LEFT OUTER JOIN SecData ON Policies.PolicyID = SecData.PolicyID AND AuthType = @AuthType
    WHERE Catalog.ItemId = @ItemId
        AND PolicyFlag = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetPolicyRoots
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetPolicyRoots]
AS
SELECT
    [Path],
    [Type]
FROM
    [Catalog]
WHERE
    [PolicyRoot] = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetPrincipalID
-- --------------------------------------------------
-- looks up a principal, if not there looks up regular users and turns them into principals
-- if not, it creates a principal
CREATE PROCEDURE [dbo].[GetPrincipalID]
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@UserID uniqueidentifier OUTPUT
AS
-- windows auth
IF @AuthType = 1
BEGIN
    -- is this a principal?
    SELECT @UserID = (SELECT UserID FROM Users WHERE Sid = @UserSid AND UserType = 1 AND AuthType = @AuthType)
END
ELSE
BEGIN
    -- is this a principal?
    SELECT @UserID = (SELECT UserID FROM Users WHERE UserName = @UserName AND UserType = 1 AND AuthType = @AuthType)
END
IF @UserID IS NULL
   BEGIN
        IF @AuthType = 1 -- Windows
        BEGIN
            -- Is this a regular user
            SELECT @UserID = (SELECT UserID FROM Users WHERE Sid = @UserSid AND UserType = 0 AND AuthType = @AuthType)
        END
        ELSE
        BEGIN
            -- Is this a regular user
            SELECT @UserID = (SELECT UserID FROM Users WHERE UserName = @UserName AND UserType = 0 AND AuthType = @AuthType)
        END
      -- No, create a new principal
      IF @UserID IS NULL
         BEGIN
            SET @UserID = newid()
            INSERT INTO Users
            (UserID, Sid,   UserType, AuthType, UserName)
            VALUES
            (@UserID, @UserSid, 1,    @AuthType, @UserName)
         END
      ELSE
         BEGIN
             UPDATE Users SET UserType = 1 WHERE UserID = @UserID
         END
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetReportForExecution
-- --------------------------------------------------
-- gets either the intermediate format or snapshot from cache
CREATE PROCEDURE [dbo].[GetReportForExecution]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@ParamsHash int,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@AuthType int
AS
DECLARE @OwnerID uniqueidentifier
if(@EditSessionID is not null)
BEGIN
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT
END

DECLARE @now AS datetime
SET @now = GETDATE()

IF ( NOT EXISTS (
    SELECT TOP 1 1
        FROM
            ExtendedCatalog(@OwnerID, @Path, @EditSessionID) AS C
            INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC ON C.ItemID = EC.ReportID
        WHERE
            EC.AbsoluteExpiration > @now AND
            EC.ParamsHash = @ParamsHash
   ) )
BEGIN   -- no cache
    SELECT
        Cat.Type,
        Cat.LinkSourceID,
        Cat2.Path,
        Cat.Property,
        Cat.Description,
        SecData.NtSecDescPrimary,
        Cat.ItemID,
        CAST (0 AS BIT), -- not found,
        Cat.Intermediate,
        Cat.ExecutionFlag,
        SD.SnapshotDataID,
        SD.DependsOnUser,
        Cat.ExecutionTime,
        (SELECT Schedule.NextRunTime
         FROM
             Schedule WITH (XLOCK)
             INNER JOIN ReportSchedule ON Schedule.ScheduleID = ReportSchedule.ScheduleID
         WHERE ReportSchedule.ReportID = Cat.ItemID AND ReportSchedule.ReportAction = 1), -- update snapshot
        (SELECT Schedule.ScheduleID
         FROM
             Schedule
             INNER JOIN ReportSchedule ON Schedule.ScheduleID = ReportSchedule.ScheduleID
         WHERE ReportSchedule.ReportID = Cat.ItemID AND ReportSchedule.ReportAction = 1), -- update snapshot
        (SELECT CachePolicy.ExpirationFlags FROM CachePolicy WHERE CachePolicy.ReportID = Cat.ItemID),
        Cat2.Intermediate,
        SD.ProcessingFlags,
        Cat.IntermediateIsPermanent
    FROM
        ExtendedCatalog(@OwnerID, @Path, @EditSessionID) AS Cat
        LEFT OUTER JOIN SecData ON Cat.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
        LEFT OUTER JOIN Catalog AS Cat2 on Cat.LinkSourceID = Cat2.ItemID
        LEFT OUTER JOIN SnapshotData AS SD ON Cat.SnapshotDataID = SD.SnapshotDataID
END
ELSE
BEGIN   -- use cache
    SELECT TOP 1
        Cat.Type,
        Cat.LinkSourceID,
        Cat2.Path,
        Cat.Property,
        Cat.Description,
        SecData.NtSecDescPrimary,
        Cat.ItemID,
        CAST (1 AS BIT), -- found,
        SN.SnapshotDataID,
        SN.DependsOnUser,
        SN.EffectiveParams,  -- offset 10
        SN.CreatedDate,
        EC.AbsoluteExpiration,
        (SELECT CachePolicy.ExpirationFlags FROM CachePolicy WHERE CachePolicy.ReportID = Cat.ItemID),
        (SELECT Schedule.ScheduleID
         FROM
             Schedule WITH (XLOCK)
             INNER JOIN ReportSchedule ON Schedule.ScheduleID = ReportSchedule.ScheduleID
             WHERE ReportSchedule.ReportID = Cat.ItemID AND ReportSchedule.ReportAction = 1), -- update snapshot
        SN.QueryParams,  -- offset 15
        SN.ProcessingFlags,
        Cat.IntermediateIsPermanent,
        Cat.Intermediate
    FROM
        ExtendedCatalog(@OwnerID, @Path, @EditSessionID) AS Cat
        INNER JOIN [ReportServerTempDB].dbo.ExecutionCache AS EC ON Cat.ItemID = EC.ReportID
        INNER JOIN [ReportServerTempDB].dbo.SnapshotData AS SN ON EC.SnapshotDataID = SN.SnapshotDataID AND EC.ParamsHash = SN.ParamsHash
        LEFT OUTER JOIN SecData ON Cat.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
        LEFT OUTER JOIN Catalog AS Cat2 on Cat.LinkSourceID = Cat2.ItemID
    WHERE
        AbsoluteExpiration > @now
        AND SN.ParamsHash = @ParamsHash
    ORDER BY SN.CreatedDate DESC
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetReportParametersForExecution
-- --------------------------------------------------
-- gets either the intermediate format or snapshot from cache
CREATE PROCEDURE [dbo].[GetReportParametersForExecution]
@Path nvarchar (425),
@HistoryID DateTime = NULL,
@AuthType int,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@EditSessionID varchar(32) = NULL
AS
BEGIN

DECLARE @OwnerID uniqueidentifier
if(@EditSessionID is not null)
BEGIN
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT
END

SELECT
   C.[ItemID],
   C.[Type],
   C.[ExecutionFlag],
   [SecData].[NtSecDescPrimary],
   C.[Parameter],
   C.[Intermediate],
   C.[SnapshotDataID],
   [History].[SnapshotDataID],
   L.[Intermediate],
   C.[LinkSourceID],
   C.[ExecutionTime],
   C.IntermediateIsPermanent
FROM
   ExtendedCatalog(@OwnerID, @Path, @EditSessionID) AS C
   LEFT OUTER JOIN [SecData] ON C.[PolicyID] = [SecData].[PolicyID] AND [SecData].AuthType = @AuthType
   LEFT OUTER JOIN [History] ON ( C.[ItemID] = [History].[ReportID] AND [History].[SnapshotDate] = @HistoryID )
   LEFT OUTER JOIN [Catalog] AS L WITH (INDEX(PK_Catalog)) ON C.[LinkSourceID] = L.[ItemID]
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetRoles
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetRoles]
@RoleFlags as tinyint = NULL
AS
SELECT
    RoleName,
    Description,
    TaskMask
FROM
    Roles
WHERE
    (@RoleFlags is NULL) OR
    (RoleFlags = @RoleFlags)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSchedulesReports
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSchedulesReports]
@ID uniqueidentifier
AS

select
    C.Path
from
    ReportSchedule RS inner join Catalog C on (C.ItemID = RS.ReportID)
where
    ScheduleID = @ID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetServerParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetServerParameters]
@ServerParametersID nvarchar(32)
AS
DECLARE @now as DATETIME
SET @now = GETDATE()
SELECT Child.Path, Child.ParametersValues, Parent.ParametersValues
FROM [dbo].[ServerParametersInstance] Child
LEFT OUTER JOIN [dbo].[ServerParametersInstance] Parent
ON Child.ParentID = Parent.ServerParametersID
WHERE Child.ServerParametersID = @ServerParametersID
AND Child.Expiration > @now

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSessionData
-- --------------------------------------------------
-- Get record from session data, update session and snapshot
CREATE PROCEDURE [dbo].[GetSessionData]
@SessionID as varchar(32),
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260),
@AuthType as int,
@SnapshotTimeoutMinutes as int
AS

DECLARE @ExpirationDate as datetime
DECLARE @now as datetime
SET @now = GETDATE()

DECLARE @DBSessionID varchar(32)
DECLARE @SnapshotDataID uniqueidentifier
DECLARE @IsPermanentSnapshot bit
DECLARE @LockVersion int

EXEC CheckSessionLock @SessionID, @LockVersion OUTPUT

DECLARE @ActualOwnerID uniqueidentifier
DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

SELECT
    @DBSessionID = SE.SessionID,
    @SnapshotDataID = SE.SnapshotDataID,
    @IsPermanentSnapshot = SE.IsPermanentSnapshot,
    @ActualOwnerID = SE.OwnerID,
    @ExpirationDate = SE.Expiration

FROM
    [ReportServerTempDB].dbo.SessionData AS SE WITH (XLOCK)
WHERE
    SE.SessionID = @SessionID

IF (@DBSessionID IS NULL)
RAISERROR ('Invalid or Expired Session: %s', 16, 1, @SessionID)

IF (@ActualOwnerID <> @OwnerID)
RAISERROR ('Session %s does not belong to %s', 16, 1, @SessionID, @OwnerName)

IF (@ExpirationDate <= @now)
RAISERROR ('Expired Session: %s', 16, 1, @SessionID)

IF @IsPermanentSnapshot != 0 BEGIN -- If session has snapshot and it is permanent

SELECT
    SN.SnapshotDataID,
    SE.ShowHideInfo,
    SE.DataSourceInfo,
    SN.Description,
    SE.EffectiveParams,
    SN.CreatedDate,
    SE.IsPermanentSnapshot,
    SE.CreationTime,
    SE.HasInteractivity,
    SE.Timeout,
    SE.SnapshotExpirationDate,
    SE.ReportPath,
    SE.HistoryDate,
    SE.CompiledDefinition,
    SN.PageCount,
    SN.HasDocMap,
    SE.Expiration,
    SN.EffectiveParams,
    SE.PageHeight,
    SE.PageWidth,
    SE.TopMargin,
    SE.BottomMargin,
    SE.LeftMargin,
    SE.RightMargin,
    SE.AutoRefreshSeconds,
    SE.AwaitingFirstExecution,
    SN.[DependsOnUser],
    SN.PaginationMode,
    SN.ProcessingFlags,
    NULL, -- No compiled definition in tempdb to get flags from
    CONVERT(BIT, 0) AS [FoundInCache], -- permanent snapshot is never from Cache
    SE.SitePath,
    SE.SiteZone,
    SE.DataSetInfo,
    SE.ReportDefinitionPath,
    @LockVersion
FROM
    [ReportServerTempDB].dbo.SessionData AS SE
    INNER JOIN SnapshotData AS SN ON SN.SnapshotDataID = SE.SnapshotDataID
WHERE
   SE.SessionID = @DBSessionID

UPDATE SnapshotData
SET ExpirationDate = DATEADD(n, @SnapshotTimeoutMinutes, @now)
WHERE SnapshotDataID = @SnapshotDataID

END ELSE IF @IsPermanentSnapshot = 0 BEGIN -- If session has snapshot and it is temporary

SELECT
    SN.SnapshotDataID,
    SE.ShowHideInfo,
    SE.DataSourceInfo,
    SN.Description,
    SE.EffectiveParams,
    SN.CreatedDate,
    SE.IsPermanentSnapshot,
    SE.CreationTime,
    SE.HasInteractivity,
    SE.Timeout,
    SE.SnapshotExpirationDate,
    SE.ReportPath,
    SE.HistoryDate,
    SE.CompiledDefinition,
    SN.PageCount,
    SN.HasDocMap,
    SE.Expiration,
    SN.EffectiveParams,
    SE.PageHeight,
    SE.PageWidth,
    SE.TopMargin,
    SE.BottomMargin,
    SE.LeftMargin,
    SE.RightMargin,
    SE.AutoRefreshSeconds,
    SE.AwaitingFirstExecution,
    SN.[DependsOnUser],
    SN.PaginationMode,
    SN.ProcessingFlags,
    COMP.ProcessingFlags,


    -- If we are AwaitingFirstExecution, then we haven't executed a
    -- report and therefore have not been bound to a cached snapshot
    -- because that binding only happens at report execution time.
    CASE SE.AwaitingFirstExecution WHEN 1 THEN CONVERT(BIT, 0) ELSE SN.IsCached END,
    SE.SitePath,
    SE.SiteZone,
    SE.DataSetInfo,
    SE.ReportDefinitionPath,
    @LockVersion
FROM
    [ReportServerTempDB].dbo.SessionData AS SE
    INNER JOIN [ReportServerTempDB].dbo.SnapshotData AS SN ON SN.SnapshotDataID = SE.SnapshotDataID
    LEFT OUTER JOIN [ReportServerTempDB].dbo.SnapshotData AS COMP ON SE.CompiledDefinition = COMP.SnapshotDataID
WHERE
   SE.SessionID = @DBSessionID

UPDATE [ReportServerTempDB].dbo.SnapshotData
SET ExpirationDate = DATEADD(n, @SnapshotTimeoutMinutes, @now)
WHERE SnapshotDataID = @SnapshotDataID

END ELSE BEGIN -- If session doesn't have snapshot

SELECT
    null,
    SE.ShowHideInfo,
    SE.DataSourceInfo,
    null,
    SE.EffectiveParams,
    null,
    SE.IsPermanentSnapshot,
    SE.CreationTime,
    SE.HasInteractivity,
    SE.Timeout,
    SE.SnapshotExpirationDate,
    SE.ReportPath,
    SE.HistoryDate,
    SE.CompiledDefinition,
    null,
    null,
    SE.Expiration,
    null,
    SE.PageHeight,
    SE.PageWidth,
    SE.TopMargin,
    SE.BottomMargin,
    SE.LeftMargin,
    SE.RightMargin,
    SE.AutoRefreshSeconds,
    SE.AwaitingFirstExecution,
    null,
    null,
    null,
    COMP.ProcessingFlags,
    CONVERT(BIT, 0) AS [FoundInCache], -- no snapshot, so it can't be from the cache
    SE.SitePath,
    SE.SiteZone,
    SE.DataSetInfo,
    SE.ReportDefinitionPath,
    @LockVersion
FROM
    [ReportServerTempDB].dbo.SessionData AS SE
    LEFT OUTER JOIN [ReportServerTempDB].dbo.SnapshotData AS COMP ON (SE.CompiledDefinition = COMP.SnapshotDataID)
WHERE
   SE.SessionID = @DBSessionID

END


-- We need this update to keep session around while we process it.
UPDATE
   SE
SET
   Expiration = DATEADD(s, Timeout, GetDate())
FROM
   [ReportServerTempDB].dbo.SessionData AS SE
WHERE
   SE.SessionID = @DBSessionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSharePointPathsForUpgrade
-- --------------------------------------------------
CREATE PROC [dbo].[GetSharePointPathsForUpgrade]
AS
BEGIN
SELECT DISTINCT SUBSTRING([Path], 1, LEN([Path])-LEN([Name]) - 1) as Prefix, LEN([Path])-LEN([Name]) as PrefixLen
  FROM [Catalog]
  WHERE LEN([Path]) > 0 AND [Path] NOT LIKE '/{%'
  ORDER BY PrefixLen DESC
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSharePointSchedulePathsForUpgrade
-- --------------------------------------------------
CREATE PROC [dbo].[GetSharePointSchedulePathsForUpgrade]
AS
BEGIN
SELECT DISTINCT [Path], LEN([Path])
  FROM [Schedule]
  WHERE [Path] IS NOT NULL AND [Path] NOT LIKE '/{%'
  ORDER BY LEN([Path]) DESC
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSnapshotChunks
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSnapshotChunks]
@SnapshotDataID uniqueidentifier,
@IsPermanentSnapshot bit
AS

IF @IsPermanentSnapshot != 0 BEGIN

SELECT ChunkName, ChunkType, ChunkFlags, MimeType, Version, datalength(Content)
FROM ChunkData
WHERE
    SnapshotDataID = @SnapshotDataID

END ELSE BEGIN

SELECT ChunkName, ChunkType, ChunkFlags, MimeType, Version, datalength(Content)
FROM [ReportServerTempDB].dbo.ChunkData
WHERE
    SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSnapshotFromHistory
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSnapshotFromHistory]
@Path nvarchar (425),
@SnapshotDate datetime,
@AuthType int
AS
SELECT
   Catalog.ItemID,
   Catalog.Type,
   SnapshotData.SnapshotDataID,
   SnapshotData.DependsOnUser,
   SnapshotData.Description,
   SecData.NtSecDescPrimary,
   Catalog.[Property],
   SnapshotData.ProcessingFlags
FROM
   SnapshotData
   INNER JOIN History ON History.SnapshotDataID = SnapshotData.SnapshotDataID
   INNER JOIN Catalog ON History.ReportID = Catalog.ItemID
   LEFT OUTER JOIN SecData ON Catalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
WHERE
   Catalog.Path = @Path
   AND History.SnapshotDate = @SnapshotDate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSnapshotPromotedInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSnapshotPromotedInfo]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit
AS

-- We don't want to hold shared locks if even if we are in a repeatable
-- read transaction, so explicitly use READCOMMITTED lock hint
IF @IsPermanentSnapshot = 1
BEGIN
   SELECT PageCount, HasDocMap, PaginationMode, ProcessingFlags
   FROM SnapshotData WITH (READCOMMITTED)
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   SELECT PageCount, HasDocMap, PaginationMode, ProcessingFlags
   FROM [ReportServerTempDB].dbo.SnapshotData WITH (READCOMMITTED)
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSnapShotSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSnapShotSchedule]
@ReportID uniqueidentifier
AS

select
    S.[ScheduleID],
    S.[Name],
    S.[StartDate],
    S.[Flags],
    S.[NextRunTime],
    S.[LastRunTime],
    S.[EndDate],
    S.[RecurrenceType],
    S.[MinutesInterval],
    S.[DaysInterval],
    S.[WeeksInterval],
    S.[DaysOfWeek],
    S.[DaysOfMonth],
    S.[Month],
    S.[MonthlyWeek],
    S.[State],
    S.[LastRunStatus],
    S.[ScheduledRunTimeout],
    S.[EventType],
    S.[EventData],
    S.[Type],
    S.[Path],
    Owner.[UserName],
    Owner.[UserName],
    Owner.[AuthType]
from
    Schedule S with (XLOCK) inner join ReportSchedule RS on S.ScheduleID = RS.ScheduleID
    inner join [Users] Owner on S.[CreatedById] = Owner.[UserID]
where
    RS.ReportAction = 2 and -- 2 == create snapshot
    RS.ReportID = @ReportID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSubscription]
@SubscriptionID uniqueidentifier
AS

-- Grab all of the-- subscription properties given a id
select
        S.[SubscriptionID],
        S.[Report_OID],
        S.[ReportZone],
        S.[Locale],
        S.[InactiveFlags],
        S.[DeliveryExtension],
        S.[ExtensionSettings],
        Modified.[UserName],
        Modified.[UserName],
        S.[ModifiedDate],
        S.[Description],
        S.[LastStatus],
        S.[EventType],
        S.[MatchData],
        S.[Parameters],
        S.[DataSettings],
        A.[TotalNotifications],
        A.[TotalSuccesses],
        A.[TotalFailures],
        Owner.[UserName],
        Owner.[UserName],
        CAT.[Path],
        S.[LastRunTime],
        CAT.[Type],
        SD.NtSecDescPrimary,
        S.[Version],
        Owner.[AuthType]
from
    [Subscriptions] S inner join [Catalog] CAT on S.[Report_OID] = CAT.[ItemID]
    inner join [Users] Owner on S.OwnerID = Owner.UserID
    inner join [Users] Modified on S.ModifiedByID = Modified.UserID
    left outer join [SecData] SD on CAT.PolicyID = SD.PolicyID AND SD.AuthType = Owner.AuthType
    left outer join (select top(1) * from [ActiveSubscriptions] with(NOLOCK) where [SubscriptionID] = @SubscriptionID) A on S.[SubscriptionID] = A.[SubscriptionID]
where
    S.[SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSubscriptionHistory
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSubscriptionHistory]
	@SubscriptionID UNIQUEIDENTIFIER
AS
BEGIN

	SELECT
		[SubscriptionID],
		[SubscriptionHistoryID],
		[Type],
		[StartTime],
		[EndTime],
		[Status],
		[Message],
		[Details]
	FROM
		[SubscriptionHistory]
	WHERE
		[SubscriptionID] = @SubscriptionID
	ORDER BY [StartTime] DESC

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSubscriptionInfoForReencryption
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSubscriptionInfoForReencryption]
@SubscriptionID as uniqueidentifier
AS

SELECT [DeliveryExtension], [ExtensionSettings], [Version]
FROM [dbo].[Subscriptions]
WHERE [SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSubscriptionsForUpgrade
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSubscriptionsForUpgrade]
@CurrentVersion int
AS
SELECT
    [SubscriptionID]
FROM
    [Subscriptions]
WHERE
    [Version] != @CurrentVersion

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSystemPolicy
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetSystemPolicy]
@AuthType int
AS
SELECT SecData.NtSecDescPrimary, SecData.XmlDescription
FROM Policies
LEFT OUTER JOIN SecData ON Policies.PolicyID = SecData.PolicyID AND AuthType = @AuthType
WHERE PolicyFlag = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetTaskProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetTaskProperties]
@ScheduleID uniqueidentifier
AS
-- Grab all of a tasks properties given a task id
select
        S.[ScheduleID],
        S.[Name],
        S.[StartDate],
        S.[Flags],
        S.[NextRunTime],
        S.[LastRunTime],
        S.[EndDate],
        S.[RecurrenceType],
        S.[MinutesInterval],
        S.[DaysInterval],
        S.[WeeksInterval],
        S.[DaysOfWeek],
        S.[DaysOfMonth],
        S.[Month],
        S.[MonthlyWeek],
        S.[State],
        S.[LastRunStatus],
        S.[ScheduledRunTimeout],
        S.[EventType],
        S.[EventData],
        S.[Type],
        S.[Path],
        Owner.[UserName],
        Owner.[UserName],
        Owner.[AuthType]
from
    [Schedule] S with (XLOCK)
    Inner join [Users] Owner on S.[CreatedById] = Owner.UserID
where
    S.[ScheduleID] = @ScheduleID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetTimeBasedSubscriptionReportAction
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetTimeBasedSubscriptionReportAction]
@SubscriptionID uniqueidentifier
AS
select
        RS.[ReportAction],
        RS.[ScheduleID],
        RS.[ReportID],
        RS.[SubscriptionID],
        C.[Path],
        C.[Type]
from
    [ReportSchedule] RS Inner join [Catalog] C on RS.[ReportID] = C.[ItemID]
where
    RS.[SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetTimeBasedSubscriptionSchedule
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetTimeBasedSubscriptionSchedule]
@SubscriptionID as uniqueidentifier
AS

select
    S.[ScheduleID],
    S.[Name],
    S.[StartDate],
    S.[Flags],
    S.[NextRunTime],
    S.[LastRunTime],
    S.[EndDate],
    S.[RecurrenceType],
    S.[MinutesInterval],
    S.[DaysInterval],
    S.[WeeksInterval],
    S.[DaysOfWeek],
    S.[DaysOfMonth],
    S.[Month],
    S.[MonthlyWeek],
    S.[State],
    S.[LastRunStatus],
    S.[ScheduledRunTimeout],
    S.[EventType],
    S.[EventData],
    S.[Type],
    S.[Path],
    Owner.[UserName],
    Owner.[UserName],
    Owner.[AuthType]
from
    [ReportSchedule] R inner join Schedule S with (XLOCK) on R.[ScheduleID] = S.[ScheduleID]
    Inner join [Users] Owner on S.[CreatedById] = Owner.UserID
where
    R.[SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUpgradeItems
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetUpgradeItems]
AS
SELECT
    [Item],
    [Status]
FROM
    [UpgradeInfo]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserID
-- --------------------------------------------------
-- looks up any user name, if not it creates a regular user - uses Sid
CREATE PROCEDURE [dbo].[GetUserID]
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@UserID uniqueidentifier OUTPUT
AS
    IF @AuthType = 1 -- Windows
    BEGIN
        EXEC GetUserIDBySid @UserSid, @UserName, @AuthType, @UserID OUTPUT
    END
    ELSE
    BEGIN
        EXEC GetUserIDByName @UserName, @AuthType, @UserID OUTPUT
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserIDByName
-- --------------------------------------------------
-- looks up any user name by its User Name, if not it creates a regular user
CREATE PROCEDURE [dbo].[GetUserIDByName]
@UserName nvarchar(260),
@AuthType int,
@UserID uniqueidentifier OUTPUT
AS
SELECT @UserID = (SELECT UserID FROM Users WHERE UserName = @UserName AND AuthType = @AuthType)
IF @UserID IS NULL
   BEGIN
      SET @UserID = newid()
      INSERT INTO Users
      (UserID, Sid, UserType, AuthType, UserName)
      VALUES
      (@UserID, NULL, 0,    @AuthType, @UserName)
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserIDBySid
-- --------------------------------------------------
-- looks up any user name by its SID, if not it creates a regular user
CREATE PROCEDURE [dbo].[GetUserIDBySid]
@UserSid varbinary(85),
@UserName nvarchar(260),
@AuthType int,
@UserID uniqueidentifier OUTPUT
AS
SELECT @UserID = (SELECT UserID FROM Users WHERE Sid = @UserSid AND AuthType = @AuthType)
IF @UserID IS NULL
   BEGIN
      SET @UserID = newid()
      INSERT INTO Users
      (UserID, Sid, UserType, AuthType, UserName)
      VALUES
      (@UserID, @UserSid, 0, @AuthType, @UserName)
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserIDWithNoCreate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetUserIDWithNoCreate]
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@UserID uniqueidentifier OUTPUT
AS
    IF @AuthType = 1 -- Windows
    BEGIN
        SELECT @UserID = (SELECT UserID FROM Users WHERE Sid = @UserSid AND AuthType = @AuthType)
    END
    ELSE
    BEGIN
        SELECT @UserID = (SELECT UserID FROM Users WHERE UserName = @UserName AND AuthType = @AuthType)
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserServiceToken
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetUserServiceToken]
@UserSid as varbinary(85) = NULL,
@UserName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN

DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

if (@UserID is not null)
    BEGIN
        SELECT ServiceToken FROM Users WHERE UserId = @UserID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserServiceTokenForReencryption
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetUserServiceTokenForReencryption]
@UserID as uniqueidentifier
AS

SELECT [ServiceToken]
FROM [dbo].[Users]
WHERE [UserID] = @UserID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUserSettings
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[GetUserSettings]
@UserSid as varbinary(85) = NULL,
@UserName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN

DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

if (@UserID is not null)
    BEGIN
        SELECT Setting FROM Users WHERE UserId = @UserID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IncreaseTransientSnapshotRefcount
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[IncreaseTransientSnapshotRefcount]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@ExpirationMinutes as int
AS
SET NOCOUNT OFF
DECLARE @soon AS datetime
SET @soon = DATEADD(n, @ExpirationMinutes, GETDATE())

if @IsPermanentSnapshot = 1
BEGIN
   UPDATE SnapshotData
   SET ExpirationDate = @soon, TransientRefcount = TransientRefcount + 1
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   UPDATE [ReportServerTempDB].dbo.SnapshotData
   SET ExpirationDate = @soon, TransientRefcount = TransientRefcount + 1
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InitializeCatalogContentWrite
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[InitializeCatalogContentWrite]
    @CatalogItemID uniqueidentifier
AS
BEGIN
    IF EXISTS (SELECT * FROM [dbo].[Catalog] WHERE [ItemID] = @CatalogItemID)
    BEGIN
        UPDATE
            [Catalog]
        SET
            [Content] = 0x
        WHERE [ItemID] = @CatalogItemID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InitializeCatalogExtendedContentWrite
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[InitializeCatalogExtendedContentWrite]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50)
AS
BEGIN
    DECLARE @Id AS bigint
    
    IF @CatalogItemID IS NOT NULL
    BEGIN
        SELECT
            @Id = Id
        FROM
            [dbo].[CatalogItemExtendedContent]
        WHERE
            ItemID = @CatalogItemID AND ContentType = @ContentType
    END

    IF @Id IS NOT NULL
        BEGIN
            UPDATE
                [dbo].[CatalogItemExtendedContent]
            SET
                Content = 0x,
                ModifiedDate= GETDATE()
            WHERE
                ItemID = @CatalogItemID AND ContentType = @ContentType
        END
    ELSE
        BEGIN
            INSERT INTO [dbo].[CatalogItemExtendedContent] VALUES (@CatalogItemID, @ContentType , 0x, GETDATE())

            SELECT @Id = SCOPE_IDENTITY()
        END

    SELECT @Id AS Id
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsertComment
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[InsertComment]
@UserSid varbinary(85) = NULL,
@UserName nvarchar(260),
@AuthType int,
@ItemID uniqueidentifier,
@ThreadID bigint = NULL,
@Text nvarchar(2048),
@AttachmentPath nvarchar(425) = NULL
AS
BEGIN
    DECLARE @NewComment TABLE(CommentID bigint)
    DECLARE @NewCommentID bigint
    DECLARE @UserID uniqueidentifier
    DECLARE @AttachmentID uniqueidentifier
    EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT
    SET @AttachmentID = (SELECT TOP(1) ItemID FROM Catalog WHERE Path = @AttachmentPath)
    INSERT INTO [Comments] (ItemID, UserID, ThreadID, Text, CreatedDate, ModifiedDate, AttachmentID)
    OUTPUT INSERTED.CommentID INTO @NewComment(CommentID)
    VALUES (@ItemID, @UserID, @ThreadID, @Text, GETDATE(), null, @AttachmentID)
    SET @NewCommentID = (SELECT TOP(1) CommentID FROM @NewComment)
    EXEC GetCommentByCommentID @NewCommentID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsertUnreferencedSnapshot
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[InsertUnreferencedSnapshot]
@ReportID as uniqueidentifier = NULL,
@EffectiveParams as ntext = NULL,
@QueryParams as ntext = NULL,
@ParamsHash as int = NULL,
@CreatedDate as datetime,
@Description as nvarchar(512) = NULL,
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@ProcessingFlags as int,
@SnapshotTimeoutMinutes as int,
@Machine as nvarchar(512) = NULL
AS
DECLARE @now datetime
SET @now = GETDATE()

IF @IsPermanentSnapshot = 1
BEGIN
   INSERT INTO SnapshotData
      (SnapshotDataID, CreatedDate, EffectiveParams, QueryParams, ParamsHash, Description, PermanentRefcount, TransientRefcount, ExpirationDate, ProcessingFlags)
   VALUES
      (@SnapshotDataID, @CreatedDate, @EffectiveParams, @QueryParams, @ParamsHash, @Description, 0, 1, DATEADD(n, @SnapshotTimeoutMinutes, @now), @ProcessingFlags)
END ELSE BEGIN
   INSERT INTO [ReportServerTempDB].dbo.SnapshotData
      (SnapshotDataID, CreatedDate, EffectiveParams, QueryParams, ParamsHash, Description, PermanentRefcount, TransientRefcount, ExpirationDate, Machine, ProcessingFlags)
   VALUES
      (@SnapshotDataID, @CreatedDate, @EffectiveParams, @QueryParams, @ParamsHash, @Description, 0, 1, DATEADD(n, @SnapshotTimeoutMinutes, @now), @Machine, @ProcessingFlags)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvalidateSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[InvalidateSubscription]
@SubscriptionID uniqueidentifier,
@Flags int,
@LastStatus nvarchar(260)
AS

-- Mark all subscriptions for this report as inactive for the given flags
update
    Subscriptions
set
    [InactiveFlags] = S.[InactiveFlags] | @Flags,
    [LastStatus] = @LastStatus
from
    Subscriptions S
where
    SubscriptionID = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IsCatalogExtendedContentAvailable
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[IsCatalogExtendedContentAvailable]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50)
AS
DECLARE @isAvailable BIT = 0
IF EXISTS (SELECT * FROM [dbo].[CatalogItemExtendedContent] WHERE [ItemID] = @CatalogItemID AND ContentType = @ContentType)
BEGIN
    SET @isAvailable = 1
END

SELECT @isAvailable AS isAvailable

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IsFavoriteItem
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[IsFavoriteItem]
@ItemID uniqueidentifier,
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserIDWithNoCreate @UserSid, @UserName, @AuthType, @UserID OUTPUT

SELECT CAST(
    CASE WHEN EXISTS (SELECT ItemID FROM [dbo].[Favorites] WHERE UserID = @UserID AND ItemID = @ItemID) THEN 1
    ELSE 0
    END
AS BIT)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IsSegmentedChunk
-- --------------------------------------------------
create proc [dbo].[IsSegmentedChunk]
    @SnapshotId			uniqueidentifier,
    @IsPermanent		bit,
    @ChunkName			nvarchar(260),
    @ChunkType			int,
    @IsSegmented		bit out
as begin
    -- segmented chunks are read w/nolock
    -- we don't really care about locking in this scenario
    -- we just need to get some metadata which never changes (if it is segmented or not)
    if (@IsPermanent = 1) begin
        select top 1 @IsSegmented = IsSegmented
        from
        (
            select convert(bit, 0)
            from [ChunkData] c
            where c.ChunkName = @ChunkName and c.ChunkType = @ChunkType and c.SnapshotDataId = @SnapshotId
            union all
            select convert(bit, 1)
            from [SegmentedChunk] c WITH(NOLOCK)
            where c.ChunkName = @ChunkName and c.ChunkType = @ChunkType and c.SnapshotDataId = @SnapshotId
        ) A(IsSegmented)
    end
    else begin
        select top 1 @IsSegmented = IsSegmented
        from
        (
            select convert(bit, 0)
            from [ReportServerTempDB].dbo.[ChunkData] c
            where c.ChunkName = @ChunkName and c.ChunkType = @ChunkType and c.SnapshotDataId = @SnapshotId
            union all
            select convert(bit, 1)
            from [ReportServerTempDB].dbo.[SegmentedChunk] c WITH(NOLOCK)
            where c.ChunkName = @ChunkName and c.ChunkType = @ChunkType and c.SnapshotDataId = @SnapshotId
        ) A(IsSegmented)
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListHistory
-- --------------------------------------------------
-- list all historical snapshots for a specific report
CREATE PROCEDURE [dbo].[ListHistory]
@ReportID uniqueidentifier
AS
SELECT
   S.SnapshotDate,
   ISNULL((SELECT SUM(DATALENGTH( CD.Content ) ) FROM ChunkData AS CD WHERE CD.SnapshotDataID = S.SnapshotDataID ), 0) +
   ISNULL(
    (
     SELECT SUM(DATALENGTH( SEG.Content) )
     FROM Segment SEG WITH(NOLOCK)
     JOIN ChunkSegmentMapping CSM WITH(NOLOCK) ON (CSM.SegmentId = SEG.SegmentId)
     JOIN SegmentedChunk C WITH(NOLOCK) ON (C.ChunkId = CSM.ChunkId AND C.SnapshotDataId = S.SnapshotDataId)
    ), 0)
FROM
   History AS S -- skipping intermediate table SnapshotData
WHERE
   S.ReportID = @ReportID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListHistorySnapshots
-- --------------------------------------------------
-- list all historical snapshots for a specific report with full fields
CREATE PROCEDURE [dbo].[ListHistorySnapshots]
@ReportID uniqueidentifier
AS
SELECT
   S.HistoryID,
   S.ReportID,
   S.SnapshotDataID,
   S.SnapshotDate,
   ISNULL((SELECT SUM(DATALENGTH( CD.Content ) ) FROM ChunkData AS CD WHERE CD.SnapshotDataID = S.SnapshotDataID ), 0) +
   ISNULL(
    (
     SELECT SUM(DATALENGTH( SEG.Content) )
     FROM Segment SEG WITH(NOLOCK)
     JOIN ChunkSegmentMapping CSM WITH(NOLOCK) ON (CSM.SegmentId = SEG.SegmentId)
     JOIN SegmentedChunk C WITH(NOLOCK) ON (C.ChunkId = CSM.ChunkId AND C.SnapshotDataId = S.SnapshotDataId)
    ), 0) AS Size
FROM
   History AS S -- skipping intermediate table SnapshotData
WHERE
   S.ReportID = @ReportID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListInfoForReencryption
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListInfoForReencryption]
@ConfigNames AS [dbo].[EncryptedConfigList] READONLY
AS

SELECT [DSID]
FROM [dbo].[DataSource] WITH (XLOCK, TABLOCK)

SELECT [SubscriptionID]
FROM [dbo].[Subscriptions] WITH (XLOCK, TABLOCK)

SELECT [InstallationID], [PublicKey]
FROM [dbo].[Keys] WITH (XLOCK, TABLOCK)
WHERE [Client] = 1 AND ([SymmetricKey] IS NOT NULL)

SELECT [Name],[Value]
FROM [dbo].[ConfigurationInfo]
WHERE [Name] IN (SELECT [ConfigName] FROM @ConfigNames)

SELECT [UserID]
FROM [dbo].[Users]
WHERE ([ServiceToken] IS NOT NULL)

SELECT [DSID]
FROM [dbo].[DataModelDataSource]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListInstallations
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListInstallations]
AS

SELECT
    [MachineName],
    [InstanceName],
    [InstallationID],
    CASE WHEN [SymmetricKey] IS null THEN 0 ELSE 1 END
FROM [dbo].[Keys]
WHERE [Client] = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListRunningJobs
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListRunningJobs]
AS
SELECT JobID, StartDate, ComputerName, RequestName, RequestPath, SUSER_SNAME(Users.[Sid]), Users.[UserName], Description,
    Timeout, JobAction, JobType, JobStatus, Users.[AuthType]
FROM RunningJobs
INNER JOIN Users
ON RunningJobs.UserID = Users.UserID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListScheduledReports
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListScheduledReports]
@ScheduleID uniqueidentifier
AS
-- List all reports for a schedule
select
        RS.[ReportAction],
        RS.[ScheduleID],
        RS.[ReportID],
        RS.[SubscriptionID],
        C.[Path],
        C.[Type],
        C.[Name],
        C.[Description],
        C.[ModifiedDate],
        U.[UserName],
        U.[UserName],
        C.ContentSize,
        C.ExecutionTime,
        S.[Type],
        SD.[NtSecDescPrimary],
        SU.[ReportZone]

from
    [ReportSchedule] RS Inner join [Catalog] C on RS.[ReportID] = C.[ItemID]
    Inner join [Schedule] S on RS.[ScheduleID] = S.[ScheduleID]
    Inner join [Users] U on C.[ModifiedByID] = U.UserID
    left outer join [SecData] SD on SD.[PolicyID] = C.[PolicyID] AND SD.AuthType = U.AuthType
    left outer join [Subscriptions] SU on SU.[SubscriptionID] = RS.[SubscriptionID]
where
    RS.[ScheduleID] = @ScheduleID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListSubscriptionIDs
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListSubscriptionIDs]
AS

SELECT [SubscriptionID]
FROM [dbo].[Subscriptions] WITH (XLOCK, TABLOCK)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListSubscriptionsUsingDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListSubscriptionsUsingDataSource]
@DataSourceName nvarchar(450)
AS
select
    S.[SubscriptionID],
    S.[Report_OID],
    S.[ReportZone],
    S.[Locale],
    S.[InactiveFlags],
    S.[DeliveryExtension],
    S.[ExtensionSettings],
    Modified.[UserName],
    Modified.[UserName],
    S.[ModifiedDate],
    S.[Description],
    S.[LastStatus],
    S.[EventType],
    S.[MatchData],
    S.[Parameters],
    S.[DataSettings],
    A.[TotalNotifications],
    A.[TotalSuccesses],
    A.[TotalFailures],
    Owner.[UserName],
    Owner.[UserName],
    CAT.[Path],
    S.[LastRunTime],
    CAT.[Type],
    SD.NtSecDescPrimary,
    S.[Version],
    Owner.[AuthType]
from
    [DataSource] DS inner join Catalog C on C.ItemID = DS.Link
    inner join Subscriptions S on S.[SubscriptionID] = DS.[SubscriptionID]
    inner join [Catalog] CAT on S.[Report_OID] = CAT.[ItemID]
    inner join [Users] Owner on S.OwnerID = Owner.UserID
    inner join [Users] Modified on S.ModifiedByID = Modified.UserID
    left join [SecData] SD on SD.[PolicyID] = CAT.[PolicyID] AND SD.AuthType = Owner.AuthType
    left outer join [ActiveSubscriptions] A with (NOLOCK) on S.[SubscriptionID] = A.[SubscriptionID]
where
    C.Path = @DataSourceName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListTasks
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListTasks]
@Path nvarchar (425) = NULL,
@Prefix nvarchar (425) = NULL
AS

select
        S.[ScheduleID],
        S.[Name],
        S.[StartDate],
        S.[Flags],
        S.[NextRunTime],
        S.[LastRunTime],
        S.[EndDate],
        S.[RecurrenceType],
        S.[MinutesInterval],
        S.[DaysInterval],
        S.[WeeksInterval],
        S.[DaysOfWeek],
        S.[DaysOfMonth],
        S.[Month],
        S.[MonthlyWeek],
        S.[State],
        S.[LastRunStatus],
        S.[ScheduledRunTimeout],
        S.[EventType],
        S.[EventData],
        S.[Type],
        S.[Path],
        Owner.[UserName],
        Owner.[UserName],
        Owner.[AuthType],
        (select count(*) from ReportSchedule where ReportSchedule.ScheduleID = S.ScheduleID)
from
    [Schedule] S  inner join [Users] Owner on S.[CreatedById] = Owner.UserID
where
    S.[Type] = 0 /*Type 0 is shared schedules*/ and
    ((@Path is null) OR (S.Path = @Path) or (S.Path like @Prefix escape '*'))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListTasksForMaintenance
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListTasksForMaintenance]
AS

declare @date datetime
set @date = GETUTCDATE()

update
    [Schedule]
set
    [ConsistancyCheck] = @date
from
(
  SELECT TOP 20 [ScheduleID] FROM [Schedule] WITH(UPDLOCK) WHERE [ConsistancyCheck] is NULL
) AS t1
WHERE [Schedule].[ScheduleID] = t1.[ScheduleID]

select top 20
        S.[ScheduleID],
        S.[Name],
        S.[StartDate],
        S.[Flags],
        S.[NextRunTime],
        S.[LastRunTime],
        S.[EndDate],
        S.[RecurrenceType],
        S.[MinutesInterval],
        S.[DaysInterval],
        S.[WeeksInterval],
        S.[DaysOfWeek],
        S.[DaysOfMonth],
        S.[Month],
        S.[MonthlyWeek],
        S.[State],
        S.[LastRunStatus],
        S.[ScheduledRunTimeout],
        S.[EventType],
        S.[EventData],
        S.[Type],
        S.[Path]
from
    [Schedule] S
where
    [ConsistancyCheck] = @date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ListUsedDeliveryProviders
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ListUsedDeliveryProviders]
AS
select distinct [DeliveryExtension] from Subscriptions where [DeliveryExtension] <> ''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.LoadForDefinitionCheck
-- --------------------------------------------------
-- For loading compiled definitions to check for internal republishing, this is
-- done before calling GetCompiledDefinition or GetReportForExecution
CREATE PROCEDURE [dbo].[LoadForDefinitionCheck]
@Path					nvarchar(425),
@AcquireUpdateLocks	bit,
@AuthType				int
AS
IF(@AcquireUpdateLocks = 0) BEGIN
SELECT
        CompiledDefinition.SnapshotDataID,
        CompiledDefinition.ProcessingFlags,
        SecData.NtSecDescPrimary
    FROM Catalog MainItem
    LEFT OUTER JOIN SecData ON (MainItem.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType)
    LEFT OUTER JOIN Catalog LinkTarget WITH (INDEX = PK_CATALOG) ON (MainItem.LinkSourceID = LinkTarget.ItemID)
    JOIN SnapshotData CompiledDefinition ON (CompiledDefinition.SnapshotDataID = COALESCE(LinkTarget.Intermediate, MainItem.Intermediate))
    WHERE MainItem.Path = @Path AND (MainItem.Type = 2 /* Report */ OR MainItem.Type = 4 /* Linked Report */)
END
ELSE BEGIN
    -- acquire upgrade locks, this means that the check is being perform in a
    -- different transaction context which will be committed before trying to
    -- perform the actual load, to prevent deadlock in the case where we have to
    -- republish this new transaction will acquire and hold upgrade locks
SELECT
        CompiledDefinition.SnapshotDataID,
        CompiledDefinition.ProcessingFlags,
        SecData.NtSecDescPrimary
    FROM Catalog MainItem WITH(UPDLOCK ROWLOCK)
    LEFT OUTER JOIN SecData ON (MainItem.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType)
    LEFT OUTER JOIN Catalog LinkTarget WITH (UPDLOCK ROWLOCK INDEX = PK_CATALOG) ON (MainItem.LinkSourceID = LinkTarget.ItemID)
    JOIN SnapshotData CompiledDefinition WITH(UPDLOCK ROWLOCK) ON (CompiledDefinition.SnapshotDataID = COALESCE(LinkTarget.Intermediate, MainItem.Intermediate))
    WHERE MainItem.Path = @Path AND (MainItem.Type = 2 /* Report */ OR MainItem.Type = 4 /* Linked Report */)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.LoadForRepublishing
-- --------------------------------------------------
-- Loads a report's RDL for republishing
CREATE PROCEDURE [dbo].[LoadForRepublishing]
@Path		nvarchar(425)
AS
SELECT
    COALESCE(LinkTarget.Content, MainItem.Content) AS [Content],
    CompiledDefinition.SnapshotDataID,
    CompiledDefinition.ProcessingFlags
FROM Catalog MainItem
LEFT OUTER JOIN Catalog LinkTarget WITH (INDEX = PK_CATALOG) ON (MainItem.LinkSourceID = LinkTarget.ItemID)
JOIN SnapshotData CompiledDefinition ON (CompiledDefinition.SnapshotDataID = COALESCE(LinkTarget.Intermediate, MainItem.Intermediate))
WHERE MainItem.Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.LockPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[LockPersistedStream]
@SessionID varchar(32),
@Index int
AS

SELECT [Index] FROM [ReportServerTempDB].dbo.PersistedStream WITH (XLOCK) WHERE SessionID = @SessionID AND [Index] = @Index

GO

-- --------------------------------------------------
-- PROCEDURE dbo.LockSnapshotForUpgrade
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[LockSnapshotForUpgrade]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit
AS
if @IsPermanentSnapshot = 1
BEGIN
   SELECT ChunkName from ChunkData with (XLOCK)
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   SELECT ChunkName from [ReportServerTempDB].dbo.ChunkData with (XLOCK)
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MarkSnapshotAsDependentOnUser
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[MarkSnapshotAsDependentOnUser]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit
AS
SET NOCOUNT OFF
if @IsPermanentSnapshot = 1
BEGIN
   UPDATE SnapshotData
   SET DependsOnUser = 1
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   UPDATE [ReportServerTempDB].dbo.SnapshotData
   SET DependsOnUser = 1
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MigrateExecutionLog
-- --------------------------------------------------
create proc [dbo].[MigrateExecutionLog] @updatedRow int output
as
begin
    set @updatedRow = 0 ;
    if exists (select id from dbo.sysobjects where id = object_id(N'[dbo].[ExecutionLog_Old]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    begin
        SET DEADLOCK_PRIORITY LOW ;
        SET NOCOUNT OFF ;

        insert into [dbo].[ExecutionLogStorage]
            ([InstanceName],
             [ReportID],
             [UserName],
             [ExecutionId],
             [RequestType],
             [Format],
             [Parameters],
             [ReportAction],
             [TimeStart],
             [TimeEnd],
             [TimeDataRetrieval],
             [TimeProcessing],
             [TimeRendering],
             [Source],
             [Status],
             [ByteCount],
             [RowCount],
             [AdditionalInfo])
        select top (1024) with ties
            [InstanceName],
            [ReportID],
            [UserName],
            null,
            [RequestType],
            [Format],
            [Parameters],
            1,      --Render
            [TimeStart],
            [TimeEnd],
            [TimeDataRetrieval],
            [TimeProcessing],
            [TimeRendering],
            [Source],
            [Status],
            [ByteCount],
            [RowCount],
            null
         from [dbo].[ExecutionLog_Old] WITH (XLOCK)
         order by TimeStart ;

         delete from [dbo].[ExecutionLog_Old]
         where [TimeStart] in (select top (1024) with ties [TimeStart] from [dbo].[ExecutionLog_Old] order by [TimeStart]) ;

         set @updatedRow = @@ROWCOUNT ;

         IF @updatedRow = 0
         begin
            drop table [dbo].[ExecutionLog_Old]
         end
     end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MoveObject
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[MoveObject]
@OldPath nvarchar (425),
@OldPrefix nvarchar (850),
@NewName nvarchar (425),
@NewPath nvarchar (425),
@NewParentID uniqueidentifier,
@RenameOnly as bit,
@MaxPathLength as int
AS

DECLARE @LongPath nvarchar(425)
SET @LongPath =
  (SELECT TOP 1 Path
   FROM Catalog
   WHERE
      LEN(Path)-LEN(@OldPath)+LEN(@NewPath) > @MaxPathLength AND
      Path LIKE @OldPrefix ESCAPE '*')

IF @LongPath IS NOT NULL BEGIN
   SELECT @LongPath
   RETURN
END

IF @RenameOnly = 0 -- if this a full-blown move, not just a rename
BEGIN
    -- adjust policies on the top item that gets moved
    DECLARE @OldInheritedPolicyID as uniqueidentifier
    SELECT @OldInheritedPolicyID = (SELECT PolicyID FROM Catalog with (XLOCK) WHERE Path = @OldPath AND PolicyRoot = 0)
    IF (@OldInheritedPolicyID IS NOT NULL)
       BEGIN -- this was not a policy root, change it to inherit from target folder
         DECLARE @NewPolicyID as uniqueidentifier
         SELECT @NewPolicyID = (SELECT PolicyID FROM Catalog with (XLOCK) WHERE ItemID = @NewParentID)
         -- update item and children that shared the old policy
         UPDATE Catalog SET PolicyID = @NewPolicyID WHERE Path = @OldPath
         UPDATE Catalog SET PolicyID = @NewPolicyID
            WHERE Path LIKE @OldPrefix ESCAPE '*'
            AND Catalog.PolicyID = @OldInheritedPolicyID
     END
END

-- Update item that gets moved (Path, Name, and ParentId)
update Catalog
set Name = @NewName, Path = @NewPath, ParentID = @NewParentID
where Path = @OldPath
-- Update all its children (Path only, Names and ParentIds stay the same)
update Catalog
set Path = STUFF(Path, 1, LEN(@OldPath), @NewPath )
where Path like @OldPrefix escape '*'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ObjectExists
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ObjectExists]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN
DECLARE @OwnerID uniqueidentifier
if(@EditSessionID is not null)
BEGIN
    EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT
END

SELECT Type, ItemID, SnapshotLimit, NtSecDescPrimary, ExecutionFlag, Intermediate, [LinkSourceID], SubType, ComponentID
FROM ExtendedCatalog(@OwnerID, @Path, @EditSessionID)
LEFT OUTER JOIN SecData
ON ExtendedCatalog.PolicyID = SecData.PolicyID AND SecData.AuthType = @AuthType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.OpenSegmentedChunk
-- --------------------------------------------------
create proc [dbo].[OpenSegmentedChunk]
    @SnapshotId		uniqueidentifier,
    @IsPermanent	bit,
    @ChunkName		nvarchar(260),
    @ChunkType		int,
    @ChunkId        uniqueidentifier out,
    @ChunkFlags     tinyint out
as begin
    if (@IsPermanent = 1) begin
        select	@ChunkId = ChunkId,
                @ChunkFlags = ChunkFlags
        from dbo.SegmentedChunk chunk
        where chunk.SnapshotDataId = @SnapshotId and chunk.ChunkName = @ChunkName and chunk.ChunkType = @ChunkType

        select	csm.SegmentId,
                csm.LogicalByteCount as LogicalSegmentLength,
                csm.ActualByteCount as ActualSegmentLength
        from ChunkSegmentMapping csm
        where csm.ChunkId = @ChunkId
        order by csm.StartByte asc
    end
    else begin
        select	@ChunkId = ChunkId,
                @ChunkFlags = ChunkFlags
        from [ReportServerTempDB].dbo.SegmentedChunk chunk
        where chunk.SnapshotDataId = @SnapshotId and chunk.ChunkName = @ChunkName and chunk.ChunkType = @ChunkType

        if @ChunkFlags & 0x4 > 0 begin
            -- Shallow copy: read chunk segments from catalog
            select	csm.SegmentId,
                    csm.LogicalByteCount as LogicalSegmentLength,
                    csm.ActualByteCount as ActualSegmentLength
            from ChunkSegmentMapping csm
            where csm.ChunkId = @ChunkId
            order by csm.StartByte asc
        end
        else begin
            -- Regular copy: read chunk segments from temp db
            select	csm.SegmentId,
                    csm.LogicalByteCount as LogicalSegmentLength,
                    csm.ActualByteCount as ActualSegmentLength
            from [ReportServerTempDB].dbo.ChunkSegmentMapping csm
            where csm.ChunkId = @ChunkId
            order by csm.StartByte asc
        end
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PollEventsForRSProcess
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PollEventsForRSProcess]
    @NumberOfEvents AS INTEGER
AS

DECLARE @BatchID UNIQUEIDENTIFIER
SET @BatchID = NEWID()

UPDATE [Event] WITH (TABLOCKX)
    SET [BatchID] = @BatchID,
    [ProcessStart] = GETUTCDATE(),
    [ProcessHeartbeat] = GETUTCDATE()
FROM (
    SELECT TOP (@NumberOfEvents) [EventID]
    FROM [Event] WITH (TABLOCKX)
    WHERE [ProcessStart] is NULL AND [EventType] <> 'DataModelRefresh'
    ORDER BY [TimeEntered]
    ) AS t1
WHERE [Event].[EventID] = t1.[EventID]

SELECT TOP (@NumberOfEvents)
    E.[EventID],
    E.[EventType],
    E.[EventData]
FROM
    [Event] E WITH (TABLOCKX)
WHERE
    [BatchID] = @BatchID
    AND [EventType] <> 'DataModelRefresh'
ORDER BY [TimeEntered]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PromoteSnapshotInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PromoteSnapshotInfo]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@PageCount as int,
@HasDocMap as bit,
@PaginationMode as smallint,
@ProcessingFlags as int
AS

-- HasDocMap: Processing engine may not
-- compute this flag in all cases, which
-- can lead to it being false when passed into
-- this proc, however the server needs this
-- flag to be true if it was ever set to be
-- true in order to communicate that there is a
-- document map to the viewer control.

IF @IsPermanentSnapshot = 1
BEGIN
   UPDATE SnapshotData SET
    PageCount = @PageCount,
    HasDocMap = COALESCE(@HasDocMap | HasDocMap, @HasDocMap),
    PaginationMode = @PaginationMode,
    ProcessingFlags = @ProcessingFlags
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   UPDATE [ReportServerTempDB].dbo.SnapshotData SET
    PageCount = @PageCount,
    HasDocMap = COALESCE(@HasDocMap | HasDocMap, @HasDocMap),
    PaginationMode = @PaginationMode,
    ProcessingFlags = @ProcessingFlags
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ReadChunkPortion
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ReadChunkPortion]
@ChunkPointer binary(16),
@IsPermanentSnapshot bit,
@DataIndex int,
@Length int
AS

IF @IsPermanentSnapshot != 0 BEGIN
    READTEXT ChunkData.Content @ChunkPointer @DataIndex @Length
END ELSE BEGIN
    READTEXT [ReportServerTempDB].dbo.ChunkData.Content @ChunkPointer @DataIndex @Length
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ReadChunkSegment
-- --------------------------------------------------
create proc [dbo].[ReadChunkSegment]
    @ChunkId		uniqueidentifier,
    @SegmentId		uniqueidentifier,
    @IsPermanent	bit,
    @DataIndex		int,
    @Length			int
as begin
    if(@IsPermanent = 1) begin
        select substring(seg.Content, @DataIndex + 1, @Length) as [Content]
        from Segment seg
        join ChunkSegmentMapping csm on (csm.SegmentId = seg.SegmentId)
        where csm.ChunkId = @ChunkId and csm.SegmentId = @SegmentId
    end
    else begin
        select substring(seg.Content, @DataIndex + 1, @Length) as [Content]
        from [ReportServerTempDB].dbo.Segment seg
        join [ReportServerTempDB].dbo.ChunkSegmentMapping csm on (csm.SegmentId = seg.SegmentId)
        where csm.ChunkId = @ChunkId and csm.SegmentId = @SegmentId
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ReadRoleProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[ReadRoleProperties]
@RoleName as nvarchar(260)
AS
SELECT Description, TaskMask, RoleFlags FROM Roles WHERE RoleName = @RoleName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RebindDataSet
-- --------------------------------------------------
-- Republishing generates new ID and stores those in the object model,
-- in order to resolve the data sets we need to rebind the old
-- data set definition to the current ID
CREATE PROCEDURE [dbo].[RebindDataSet]
@ItemId		uniqueidentifier,
@Name		nvarchar(260),
@NewID	uniqueidentifier
AS
UPDATE DataSets
SET ID = @NewID
WHERE ItemID = @ItemId AND [Name] = @Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RebindDataSource
-- --------------------------------------------------
-- Republishing generates new DSID and stores those in the object model,
-- in order to resolve the data sources we need to rebind the old
-- data source definition to the current DSID
CREATE PROCEDURE [dbo].[RebindDataSource]
@ItemId		uniqueidentifier,
@Name		nvarchar(260),
@NewDSID	uniqueidentifier
AS
UPDATE DataSource
SET DSID = @NewDSID
WHERE ItemID = @ItemId AND [Name] = @Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveConfigurationInfoValue
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RemoveConfigurationInfoValue]
@Name nvarchar (260)
AS

DELETE FROM [dbo].[ConfigurationInfo] 
WHERE [Name] = @Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveItemFromFavorites
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RemoveItemFromFavorites]
@ItemID uniqueidentifier,
@UserName nvarchar (425),
@UserSid varbinary(85) = NULL,
@AuthType int
AS

DECLARE @UserID uniqueidentifier
EXEC GetUserIDWithNoCreate @UserSid, @UserName, @AuthType, @UserID OUTPUT

DELETE FROM [dbo].[Favorites] WHERE UserID = @UserID AND ItemID = @ItemID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveReportFromSession
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RemoveReportFromSession]
@SessionID as varchar(32),
@ReportPath as nvarchar(440),
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260),
@AuthType as int
AS

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

EXEC DereferenceSessionSnapshot @SessionID, @OwnerID

DELETE
   SE
FROM
   [ReportServerTempDB].dbo.SessionData AS SE
WHERE
   SE.SessionID = @SessionID AND
   SE.ReportPath = @ReportPath AND
   SE.OwnerID = @OwnerID

DELETE FROM [ReportServerTempDB].dbo.SessionLock WHERE SessionID=@SessionID

-- Delete any persisted streams associated with this session
UPDATE PS
SET
    PS.RefCount = 0,
    PS.ExpirationDate = GETDATE()
FROM
    [ReportServerTempDB].dbo.PersistedStream AS PS
WHERE
    PS.SessionID = @SessionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveRunningJob
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RemoveRunningJob]
@JobID as nvarchar(32)
AS
SET NOCOUNT OFF
DELETE FROM RunningJobs WHERE JobID = @JobID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveSegment
-- --------------------------------------------------
create proc [dbo].[RemoveSegment]
    @DeleteCountPermanent int,
    @DeleteCountTemp int
as
begin
    SET DEADLOCK_PRIORITY LOW

    -- Locking:
    -- Similar idea as in RemovedSegmentedMapping.  Readpast
    -- any Segments which are currently locked and run the
    -- inner scan with nolock.
    declare @numDeleted int;
    declare @toDeleteMapping table (
        SegmentId uniqueidentifier );

    insert into @toDeleteMapping (SegmentId)
    select top (@DeleteCountPermanent) SegmentId
    from Segment with (readpast)
    where not exists (
        select 1 from ChunkSegmentMapping CSM with (nolock)
        where CSM.SegmentId = Segment.SegmentId
        ) ;

    delete from Segment with (readpast)
    where Segment.SegmentId in (
        select td.SegmentId from @toDeleteMapping td
        where not exists (
            select 1 from ChunkSegmentMapping CSM
            where CSM.SegmentId = td.SegmentId ));

    select @numDeleted = @@rowcount ;

    declare @toDeleteTempSegment table (
        SegmentId uniqueidentifier );

    insert into @toDeleteTempSegment (SegmentId)
    select top (@DeleteCountTemp) SegmentId
    from [ReportServerTempDB].dbo.Segment with (readpast)
    where not exists (
        select 1 from [ReportServerTempDB].dbo.ChunkSegmentMapping CSM with (nolock)
        where CSM.SegmentId = [ReportServerTempDB].dbo.Segment.SegmentId
        ) ;

    delete from [ReportServerTempDB].dbo.Segment with (readpast)
    where [ReportServerTempDB].dbo.Segment.SegmentId in (
        select td.SegmentId from @toDeleteTempSegment td
        where not exists (
            select 1 from [ReportServerTempDB].dbo.ChunkSegmentMapping CSM
            where CSM.SegmentId = td.SegmentId
            )) ;
    select @numDeleted = @numDeleted + @@rowcount ;

    select @numDeleted;
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveSegmentedMapping
-- --------------------------------------------------
create proc [dbo].[RemoveSegmentedMapping]
    @DeleteCountPermanentChunk int,
    @DeleteCountPermanentMapping int,
    @DeleteCountTempChunk int,
    @DeleteCountTempMapping int,
    @MachineName nvarchar(260)
as
begin
    SET DEADLOCK_PRIORITY LOW

    declare @deleted table (
        ChunkID uniqueidentifier,
        IsPermanent bit );

    -- details on lock hints:
    -- we use readpast on ChunkSegmentMapping to skip past
    -- rows which are currently locked.  they are being actively
    -- used so clearly we do not want to delete them. we use
    -- nolock on SegmentedChunk table as well, this is because
    -- regardless of whether or not that row is locked, we want to
    -- know if it is referenced by a SegmentedChunk and if
    -- so we do not want to delete the mapping row.  ChunkIds are
    -- only modified when creating a shallow chunk copy(see ShallowCopyChunk),
    -- but in this case the ChunkSegmentMapping row is locked (via the insert)
    -- so we are safe.

    declare @toDeletePermChunks table (
        SnapshotDataId uniqueidentifier ) ;

    insert into @toDeletePermChunks (SnapshotDataId)
    select top (@DeleteCountPermanentChunk) SnapshotDataId
    from SegmentedChunk with (readpast)
    where not exists (
        select 1 from SnapshotData SD with (nolock)
        where SegmentedChunk.SnapshotDataId = SD.SnapshotDataID
        ) ;

    delete from SegmentedChunk with (readpast)
    where SegmentedChunk.SnapshotDataId in (
        select td.SnapshotDataId from @toDeletePermChunks td
        where not exists (
            select 1 from SnapshotData SD
            where td.SnapshotDataId = SD.SnapshotDataID
            )) ;

    -- clean up segmentedchunks from permanent database

    declare @toDeleteChunks table (
        ChunkId uniqueidentifier );

    -- clean up mappings from permanent database
    insert into @toDeleteChunks (ChunkId)
    select top (@DeleteCountPermanentMapping) ChunkId
    from ChunkSegmentMapping with (readpast)
    where not exists (
        select 1 from SegmentedChunk SC with (nolock)
        where SC.ChunkId = ChunkSegmentMapping.ChunkId
        ) ;

    delete from ChunkSegmentMapping with (readpast)
    output deleted.ChunkId, convert(bit, 1) into @deleted
    where ChunkSegmentMapping.ChunkId in (
        select td.ChunkId from @toDeleteChunks td
        where not exists (
            select 1 from SegmentedChunk SC
            where SC.ChunkId = td.ChunkId )
        and not exists (
            select 1 from [ReportServerTempDB].dbo.SegmentedChunk TSC
            where TSC.ChunkId = td.ChunkId ) )

    declare @toDeleteTempChunks table (
        SnapshotDataId uniqueidentifier);

    -- clean up SegmentedChunks from the Temp database
    -- for locking we play the same idea as in the previous query.
    -- snapshotIds never change, so again this operation is safe.
    insert into @toDeleteTempChunks (SnapshotDataId)
    select top (@DeleteCountTempChunk) SnapshotDataId
    from [ReportServerTempDB].dbo.SegmentedChunk with (readpast)
    where [ReportServerTempDB].dbo.SegmentedChunk.Machine = @MachineName
    and not exists (
        select 1 from [ReportServerTempDB].dbo.SnapshotData SD with (nolock)
        where [ReportServerTempDB].dbo.SegmentedChunk.SnapshotDataId = SD.SnapshotDataID
        ) ;

    delete from [ReportServerTempDB].dbo.SegmentedChunk with (readpast)
    where [ReportServerTempDB].dbo.SegmentedChunk.SnapshotDataId in (
        select td.SnapshotDataId from @toDeleteTempChunks td
        where not exists (
            select 1 from [ReportServerTempDB].dbo.SnapshotData SD
            where td.SnapshotDataId = SD.SnapshotDataID
            )) ;

    declare @toDeleteTempMappings table (
        ChunkId uniqueidentifier );

    -- clean up mappings from temp database
    insert into @toDeleteTempMappings (ChunkId)
    select top (@DeleteCountTempMapping) ChunkId
    from [ReportServerTempDB].dbo.ChunkSegmentMapping with (readpast)
    where not exists (
        select 1 from [ReportServerTempDB].dbo.SegmentedChunk SC with (nolock)
        where SC.ChunkId = [ReportServerTempDB].dbo.ChunkSegmentMapping.ChunkId
        ) ;

    delete from [ReportServerTempDB].dbo.ChunkSegmentMapping with (readpast)
    output deleted.ChunkId, convert(bit, 0) into @deleted
    where [ReportServerTempDB].dbo.ChunkSegmentMapping.ChunkId in (
        select td.ChunkId from @toDeleteTempMappings td
        where not exists (
            select 1 from [ReportServerTempDB].dbo.SegmentedChunk SC
            where td.ChunkId = SC.ChunkId )) ;

    -- need to return these so we can cleanup file system chunks
    select distinct ChunkID, IsPermanent
    from @deleted ;
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RemoveSubscriptionFromBeingDeleted
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[RemoveSubscriptionFromBeingDeleted]
@SubscriptionID uniqueidentifier
AS
delete from [SubscriptionsBeingDeleted] where SubscriptionID = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetAllProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetAllProperties]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@Property ntext,
@Description ntext = NULL,
@Hidden bit = NULL,
@ModifiedBySid varbinary (85) = NULL,
@ModifiedByName nvarchar(260),
@AuthType int,
@ModifiedDate DateTime
AS

IF(@EditSessionID is null)
BEGIN
DECLARE @ModifiedByID uniqueidentifier
EXEC GetUserID @ModifiedBySid, @ModifiedByName, @AuthType, @ModifiedByID OUTPUT

UPDATE Catalog
SET Property = @Property, Description = @Description, Hidden = @Hidden, ModifiedByID = @ModifiedByID, ModifiedDate = @ModifiedDate
WHERE Path = @Path
END
ELSE
BEGIN
    UPDATE [ReportServerTempDB].dbo.TempCatalog
    SET Property = @Property, Description = @Description
    WHERE ContextPath = @Path and EditSessionID = @EditSessionID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetCacheLastUsed
-- --------------------------------------------------
CREATE PROC [dbo].[SetCacheLastUsed]
    @SnapshotDataID uniqueidentifier,
    @Timestamp datetime
AS
BEGIN
    -- Extend the cache lifetime based on the current timestamp
    -- set the last used time, which is utilized to compute which entries
    -- to evict when enforcing cache limits
    -- in the case where the cache entry is using schedule based expiration (RelativeExpiration is null)
    -- then don't update AbsoluteExpiration
    UPDATE [ReportServerTempDB].dbo.ExecutionCache
    SET		AbsoluteExpiration = ISNULL(DATEADD(n, RelativeExpiration, @Timestamp), AbsoluteExpiration),
            LastUsedTime = @Timestamp
    WHERE SnapshotDataID = @SnapshotDataID ;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetCacheOptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetCacheOptions]
@Path as nvarchar(425),
@CacheReport as bit,
@ExpirationFlags as int,
@CacheExpiration as int = NULL
AS
DECLARE @CachePolicyID as uniqueidentifier
SELECT @CachePolicyID = (SELECT CachePolicyID
FROM CachePolicy with (XLOCK) INNER JOIN Catalog ON Catalog.ItemID = CachePolicy.ReportID
WHERE  Catalog.Path = @Path)
IF @CachePolicyID IS NULL -- no policy exists
BEGIN
    IF @CacheReport = 1 -- create a new one
    BEGIN
        INSERT INTO CachePolicy
        (CachePolicyID, ReportID, ExpirationFlags, CacheExpiration)
        (SELECT NEWID(), ItemID, @ExpirationFlags, @CacheExpiration
        FROM Catalog WHERE Catalog.Path = @Path)
    END
    -- ELSE if it has no policy and we want to remove its policy do nothing
END
ELSE -- existing policy
BEGIN
    IF @CacheReport = 1
    BEGIN
        UPDATE CachePolicy SET ExpirationFlags = @ExpirationFlags, CacheExpiration = @CacheExpiration
        WHERE CachePolicyID = @CachePolicyID
        EXEC FlushReportFromCache @Path
        EXEC FlushContentCache @Path
    END
    ELSE
    BEGIN
        DELETE FROM CachePolicy
        WHERE CachePolicyID = @CachePolicyID
        EXEC FlushReportFromCache @Path
        EXEC FlushContentCache @Path
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetConfigurationInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetConfigurationInfo]
@Name nvarchar (260),
@Value ntext
AS
DELETE
FROM [ConfigurationInfo]
WHERE [Name] = @Name

IF @Value is not null BEGIN
   INSERT
   INTO ConfigurationInfo
   VALUES ( newid(), @Name, @Value )
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetConfigurationInfoValue
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetConfigurationInfoValue]
@ConfigValue nvarchar (260),
@ConfigName nvarchar (260)
AS

UPDATE [dbo].[ConfigurationInfo]
SET [Value] = @ConfigValue
WHERE [Name] = @ConfigName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetDefaultEmail
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetDefaultEmail]
    @UserID uniqueidentifier,
    @DefaultEmailAddress nvarchar(256)
AS
BEGIN
    IF EXISTS (SELECT * FROM UserContactInfo WHERE UserID = @UserID) BEGIN
        UPDATE UserContactInfo SET
        DefaultEmailAddress = @DefaultEmailAddress
        WHERE UserID=@UserID
    END ELSE BEGIN
        INSERT
        INTO [UserContactInfo] (UserID, DefaultEmailAddress)
        VALUES (@UserID, @DefaultEmailAddress)
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetDrillthroughReports
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetDrillthroughReports]
@ReportID uniqueidentifier,
@ModelID uniqueidentifier,
@ModelItemID nvarchar(425),
@Type tinyint
AS
 SET NOCOUNT OFF
 INSERT INTO ModelDrill (ModelDrillID, ModelID, ReportID, ModelItemID, [Type])
 VALUES (newid(), @ModelID, @ReportID, @ModelItemID, @Type)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetExecutionOptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetExecutionOptions]
@Path as nvarchar(425),
@ExecutionFlag as int,
@ExecutionChanged as bit = 0
AS
IF @ExecutionChanged = 0
BEGIN
    UPDATE Catalog SET ExecutionFlag = @ExecutionFlag WHERE Catalog.Path = @Path
END
ELSE
BEGIN
    IF (@ExecutionFlag & 3) = 2
    BEGIN   -- set it to snapshot, flush cache
        EXEC FlushReportFromCache @Path
        DELETE CachePolicy FROM CachePolicy INNER JOIN Catalog ON CachePolicy.ReportID = Catalog.ItemID
        WHERE Catalog.Path = @Path
    END

    -- now clean existing snapshot and execution time if any
    UPDATE SnapshotData
    SET PermanentRefcount = PermanentRefcount - 1
    FROM
       SnapshotData
       INNER JOIN Catalog ON SnapshotData.SnapshotDataID = Catalog.SnapshotDataID
    WHERE Catalog.Path = @Path

    UPDATE Catalog
    SET ExecutionFlag = @ExecutionFlag, SnapshotDataID = NULL, ExecutionTime = NULL
    WHERE Catalog.Path = @Path
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetHistoryLimit
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetHistoryLimit]
@Path nvarchar (425),
@SnapshotLimit int = NULL
AS
UPDATE Catalog
SET SnapshotLimit=@SnapshotLimit
WHERE Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetKeysForInstallation
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetKeysForInstallation]
@InstallationID uniqueidentifier,
@SymmetricKey image = NULL,
@PublicKey image
AS

update [dbo].[Keys]
set [SymmetricKey] = @SymmetricKey, [PublicKey] = @PublicKey
where [InstallationID] = @InstallationID and [Client] = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetLastModified
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetLastModified]
@Path nvarchar (425),
@ModifiedBySid varbinary (85) = NULL,
@ModifiedByName nvarchar(260),
@AuthType int,
@ModifiedDate DateTime
AS
DECLARE @ModifiedByID uniqueidentifier
EXEC GetUserID @ModifiedBySid, @ModifiedByName, @AuthType, @ModifiedByID OUTPUT
UPDATE Catalog
SET ModifiedByID = @ModifiedByID, ModifiedDate = @ModifiedDate
WHERE Path = @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetMachineName
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetMachineName]
@MachineName nvarchar(256),
@InstallationID uniqueidentifier
AS

UPDATE [dbo].[Keys]
SET MachineName = @MachineName
WHERE [InstallationID] = @InstallationID and [Client] = 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetModelItemPolicy
-- --------------------------------------------------
-- update the system policy
CREATE PROCEDURE [dbo].[SetModelItemPolicy]
@CatalogItemID as uniqueidentifier,
@ModelItemID as nvarchar(425),
@PrimarySecDesc as image,
@SecondarySecDesc as ntext = NULL,
@XmlPolicy as ntext,
@AuthType as int,
@PolicyID uniqueidentifier OUTPUT
AS
SELECT @PolicyID = (SELECT PolicyID FROM ModelItemPolicy WHERE CatalogItemID = @CatalogItemID AND ModelItemID = @ModelItemID )
IF (@PolicyID IS NULL)
   BEGIN
     SET @PolicyID = newid()
     INSERT INTO Policies (PolicyID, PolicyFlag)
     VALUES (@PolicyID, 2)
     INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription, NTSecDescPrimary, NtSecDescSecondary)
     VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
     INSERT INTO ModelItemPolicy (ID, CatalogItemID, ModelItemID, PolicyID)
     VALUES (newid(), @CatalogItemID, @ModelItemID, @PolicyID)
   END
ELSE
   BEGIN
      DECLARE @SecDataID as uniqueidentifier
      SELECT @SecDataID = (SELECT SecDataID FROM SecData WHERE PolicyID = @PolicyID and AuthType = @AuthType)
      IF (@SecDataID IS NULL)
      BEGIN -- insert new sec desc's
        INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription, NTSecDescPrimary, NtSecDescSecondary)
        VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
      END
      ELSE
      BEGIN -- update existing sec desc's
        UPDATE SecData SET
        XmlDescription = @XmlPolicy,
        NtSecDescPrimary = @PrimarySecDesc,
        NtSecDescSecondary = @SecondarySecDesc
        WHERE SecData.PolicyID = @PolicyID
        AND AuthType = @AuthType

      END
   END
DELETE FROM PolicyUserRole WHERE PolicyID = @PolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetNotificationAttempt
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetNotificationAttempt]
@Attempt int,
@SecondsToAdd int,
@NotificationID uniqueidentifier
AS

update
    [Notifications]
set
    [ProcessStart] = NULL,
    [Attempt] = @Attempt,
    [ProcessAfter] = DateAdd(second, @SecondsToAdd, GetUtcDate())
where
    [NotificationID] = @NotificationID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetObjectContent
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetObjectContent]
@Path nvarchar (425),
@EditSessionID varchar(32) = NULL,
@Type int,
@Content image = NULL,
@Intermediate uniqueidentifier = NULL,
@Parameter ntext = NULL,
@LinkSourceID uniqueidentifier = NULL,
@MimeType nvarchar (260) = NULL,
@DataCacheHash varbinary(64) = NULL,
@SubType nvarchar(128) = NULL,
@ComponentID uniqueidentifier= NULL
AS

DECLARE @OldIntermediate as uniqueidentifier
DECLARE @OldPermanent as bit
IF(@EditSessionID is null)
BEGIN
SET @OldIntermediate = (SELECT Intermediate FROM Catalog WITH (XLOCK) WHERE Path = @Path)

UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount - 1,
    -- to fix VSTS 384486 keep shared dataset compiled definition for 14 days
    ExpirationDate = case when @Type = 8 then DATEADD(d, 14, GETDATE()) ELSE ExpirationDate END,
    TransientRefcount = TransientRefcount + case when @Type = 8 then 1 ELSE 0 END
WHERE SnapshotData.SnapshotDataID = @OldIntermediate

UPDATE Catalog
SET Type=@Type, Content = @Content, ContentSize = DATALENGTH(@Content), Intermediate = @Intermediate, [Parameter] = @Parameter, LinkSourceID = @LinkSourceID, MimeType = @MimeType, SubType = @SubType, ComponentID = @ComponentID
WHERE Path = @Path

UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount + 1, TransientRefcount = TransientRefcount - 1
WHERE SnapshotData.SnapshotDataID = @Intermediate

EXEC FlushReportFromCache @Path

END
ELSE
BEGIN
    DECLARE @OldDataCacheHash binary(64) ;
    DECLARE @ItemID uniqueidentifier ;

    SELECT	@OldIntermediate = Intermediate,
            @OldPermanent = IntermediateIsPermanent,
            @OldDataCacheHash = DataCacheHash,
            @ItemID = TempCatalogID
    FROM [ReportServerTempDB].dbo.TempCatalog WITH (XLOCK)
    WHERE ContextPath = @Path and EditSessionID = @EditSessionID

    UPDATE [ReportServerTempDB].dbo.TempCatalog
    SET Content = @Content,
        Intermediate = @Intermediate,
        IntermediateIsPermanent = 0,
        Parameter = @Parameter,
        DataCacheHash = @DataCacheHash
    WHERE ContextPath = @Path and EditSessionID = @EditSessionID

    UPDATE [ReportServerTempDB].dbo.SnapshotData
    SET  PermanentRefcount = PermanentRefcount - 1
    WHERE SnapshotData.SnapshotDataID = @OldIntermediate

    UPDATE [ReportServerTempDB].dbo.SnapshotData
    SET PermanentRefcount = PermanentRefcount + 1, TransientRefcount = TransientRefcount - 1
    WHERE SnapshotData.SnapshotDataID = @Intermediate

    EXEC ExtendEditSessionLifetime @EditSessionID ;

    IF ((@OldDataCacheHash <> @DataCacheHash) OR
        (@OldDataCacheHash IS NULL) OR
        (@DataCacheHash IS NULL))
    BEGIN
        EXEC FlushCacheById @ItemID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetParameters]
@Path nvarchar (425),
@Parameter ntext
AS
UPDATE Catalog
SET [Parameter] = @Parameter
WHERE Path = @Path
EXEC FlushReportFromCache @Path

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetPersistedStreamError
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetPersistedStreamError]
@SessionID varchar(32),
@Index int,
@AllRows bit,
@Error nvarchar(512)
AS

if @AllRows = 0
BEGIN
    UPDATE [ReportServerTempDB].dbo.PersistedStream SET Error = @Error WHERE SessionID = @SessionID and [Index] = @Index
END
ELSE
BEGIN
    UPDATE [ReportServerTempDB].dbo.PersistedStream SET Error = @Error WHERE SessionID = @SessionID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetPolicy
-- --------------------------------------------------
-- this assumes the item exists in the catalog
CREATE PROCEDURE [dbo].[SetPolicy]
@ItemName as nvarchar(425),
@ItemNameLike as nvarchar(850),
@PrimarySecDesc as image,
@SecondarySecDesc as ntext = NULL,
@XmlPolicy as ntext,
@AuthType int,
@PolicyID uniqueidentifier OUTPUT
AS
SELECT @PolicyID = (SELECT PolicyID FROM Catalog WHERE Path = @ItemName AND PolicyRoot = 1)
IF (@PolicyID IS NULL)
   BEGIN -- this is not a policy root
     SET @PolicyID = newid()
     INSERT INTO Policies (PolicyID, PolicyFlag)
     VALUES (@PolicyID, 0)
     INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription, NTSecDescPrimary, NtSecDescSecondary)
     VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
     DECLARE @OldPolicyID as uniqueidentifier
     SELECT @OldPolicyID = (SELECT PolicyID FROM Catalog WHERE Path = @ItemName)
     -- update item and children that shared the old policy
     UPDATE Catalog SET PolicyID = @PolicyID, PolicyRoot = 1 WHERE Path = @ItemName
     UPDATE Catalog SET PolicyID = @PolicyID
    WHERE Path LIKE @ItemNameLike ESCAPE '*'
    AND Catalog.PolicyID = @OldPolicyID
   END
ELSE
   BEGIN
      UPDATE Policies SET
      PolicyFlag = 0
      WHERE Policies.PolicyID = @PolicyID
      DECLARE @SecDataID as uniqueidentifier
      SELECT @SecDataID = (SELECT SecDataID FROM SecData WHERE PolicyID = @PolicyID and AuthType = @AuthType)
      IF (@SecDataID IS NULL)
      BEGIN -- insert new sec desc's
        INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription ,NTSecDescPrimary, NtSecDescSecondary)
        VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
      END
      ELSE
      BEGIN -- update existing sec desc's
        UPDATE SecData SET
        XmlDescription = @XmlPolicy,
        NtSecDescPrimary = @PrimarySecDesc,
        NtSecDescSecondary = @SecondarySecDesc
        WHERE SecData.PolicyID = @PolicyID
        AND AuthType = @AuthType
      END
   END
DELETE FROM PolicyUserRole WHERE PolicyID = @PolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetReencryptedDataModelDataSource
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetReencryptedDataModelDataSource]
    @DSID bigint,
    @ConnectionString varbinary(max) = null,
    @Username varbinary(max) = null,
    @Password varbinary(max) = null
AS

UPDATE [dbo].[DataModelDataSource]
SET
    [ConnectionString] = @ConnectionString,
    [Username] = @Username,
    [Password] = @Password
WHERE [DSID] = @DSID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetReencryptedDatasourceInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetReencryptedDatasourceInfo]
@DSID uniqueidentifier,
@ConnectionString image = NULL,
@OriginalConnectionString image = NULL,
@UserName image = NULL,
@Password image = NULL,
@CredentialRetrieval int,
@Version int
AS

UPDATE [dbo].[DataSource]
SET
    [ConnectionString] = @ConnectionString,
    [OriginalConnectionString] = @OriginalConnectionString,
    [UserName] = @UserName,
    [Password] = @Password,
    [CredentialRetrieval] = @CredentialRetrieval,
    [Version] = @Version
WHERE [DSID] = @DSID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetReencryptedSubscriptionInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetReencryptedSubscriptionInfo]
@SubscriptionID as uniqueidentifier,
@ExtensionSettings as ntext = NULL,
@Version as int
AS

UPDATE [dbo].[Subscriptions]
SET [ExtensionSettings] = @ExtensionSettings,
    [Version] = @Version
WHERE [SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetReencryptedUserServiceToken
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetReencryptedUserServiceToken]
@UserID uniqueidentifier,
@ServiceToken ntext
AS

UPDATE [dbo].[Users]
SET [ServiceToken] = @ServiceToken
WHERE [UserID] = @UserID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetRoleProperties
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetRoleProperties]
@RoleName as nvarchar(260),
@Description as nvarchar(512) = NULL,
@TaskMask as nvarchar(32),
@RoleFlags as tinyint
AS
SET NOCOUNT OFF
DECLARE @ExistingRoleFlags as tinyint
SET @ExistingRoleFlags = (SELECT RoleFlags FROM Roles WHERE RoleName = @RoleName)
IF @ExistingRoleFlags IS NULL
BEGIN
    RETURN
END
IF @ExistingRoleFlags <> @RoleFlags
BEGIN
    RAISERROR ('Bad role flags', 16, 1)
END
UPDATE Roles SET
Description = @Description,
TaskMask = @TaskMask,
RoleFlags = @RoleFlags
WHERE RoleName = @RoleName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetRolePropertiesAndInvalidatePolicies
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetRolePropertiesAndInvalidatePolicies]
    @RoleName as nvarchar(260),
    @Description as nvarchar(512) = NULL,
    @TaskMask as nvarchar(32),
    @RoleFlags as tinyint
AS
BEGIN
    SET NOCOUNT OFF
    DECLARE @ExistingTaskMask as nvarchar(32)
    SELECT @ExistingTaskMask = TaskMask FROM Roles WHERE RoleName = @RoleName

    EXEC SetRoleProperties @RoleName, @Description, @TaskMask, @RoleFlags

    -- if task masks match, then no additional work needs to be done
    IF @ExistingTaskMask = @TaskMask
    BEGIN
        RETURN
    END

    SELECT [NtSecDescState]
    FROM [dbo].[SecData] WITH (XLOCK, TABLOCK)

    -- if task masks do not match, then a permission has been granted/revoked
    -- so, set policy state to invalid for every policy that uses this role
    UPDATE [dbo].[SecData] SET [NtSecDescState] = 1 WHERE [NtSecDescState] != 1 AND PolicyID in (
        SELECT DISTINCT p.PolicyID
            FROM
                [dbo].[Catalog] AS C
                    INNER JOIN [dbo].[PolicyUserRole] AS P ON C.PolicyID = P.PolicyID
                    INNER JOIN [dbo].[Roles] AS R ON R.RoleID = P.RoleID AND R.RoleName = @RoleName
        )
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSessionCredentials
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetSessionCredentials]
@SessionID as varchar(32),
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260),
@AuthType as int,
@DataSourceInfo as image = NULL,
@Expiration as datetime,
@EffectiveParams as ntext = NULL
AS

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

EXEC DereferenceSessionSnapshot @SessionID, @OwnerID

UPDATE SE
SET
   SE.DataSourceInfo = @DataSourceInfo,
   SE.SnapshotDataID = null,
   SE.IsPermanentSnapshot = null,
   SE.SnapshotExpirationDate = null,
   SE.ShowHideInfo = null,
   SE.HasInteractivity = null,
   SE.AutoRefreshSeconds = null,
   SE.Expiration = @Expiration,
   SE.EffectiveParams = @EffectiveParams,
   SE.AwaitingFirstExecution = 1
FROM
   [ReportServerTempDB].dbo.SessionData AS SE
WHERE
   SE.SessionID = @SessionID AND
   SE.OwnerID = @OwnerID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSessionData
-- --------------------------------------------------
-- Writes or updates session record
CREATE PROCEDURE [dbo].[SetSessionData]
@SessionID as varchar(32),
@ReportPath as nvarchar(440),
@HistoryDate as datetime = NULL,
@Timeout as int,
@AutoRefreshSeconds as int = NULL,
@EffectiveParams ntext = NULL,
@OwnerSid as varbinary (85) = NULL,
@OwnerName as nvarchar (260),
@AuthType as int,
@ShowHideInfo as image = NULL,
@DataSourceInfo as image = NULL,
@SnapshotDataID as uniqueidentifier = NULL,
@IsPermanentSnapshot as bit = NULL,
@SnapshotTimeoutSeconds as int = NULL,
@HasInteractivity as bit,
@SnapshotExpirationDate as datetime = NULL,
@AwaitingFirstExecution as bit  = NULL,
@EditSessionID as varchar(32) = NULL,
@DataSetInfo as varbinary(max) = null
AS

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

DECLARE @now datetime
SET @now = GETDATE()

-- is there a session for the same report ?
DECLARE @OldSnapshotDataID uniqueidentifier
DECLARE @OldIsPermanentSnapshot bit
DECLARE @OldSessionID varchar(32)

SELECT
   @OldSessionID = SessionID,
   @OldSnapshotDataID = SnapshotDataID,
   @OldIsPermanentSnapshot = IsPermanentSnapshot
FROM [ReportServerTempDB].dbo.SessionData WITH (XLOCK)
WHERE SessionID = @SessionID

IF @OldSessionID IS NOT NULL
BEGIN -- Yes, update it
   IF @OldSnapshotDataID != @SnapshotDataID or @SnapshotDataID is NULL BEGIN
      EXEC DereferenceSessionSnapshot @SessionID, @OwnerID
   END

   UPDATE
      [ReportServerTempDB].dbo.SessionData
   SET
      SnapshotDataID = @SnapshotDataID,
      IsPermanentSnapshot = @IsPermanentSnapshot,
      Timeout = @Timeout,
      AutoRefreshSeconds = @AutoRefreshSeconds,
      SnapshotExpirationDate = @SnapshotExpirationDate,
      -- we want database session to expire later than in-memory session
      Expiration = DATEADD(s, @Timeout+10, @now),
      ShowHideInfo = @ShowHideInfo,
      DataSourceInfo = @DataSourceInfo,
      AwaitingFirstExecution = @AwaitingFirstExecution,
      DataSetInfo = @DataSetInfo
      -- EffectiveParams = @EffectiveParams, -- no need to update user params as they are always same
      -- ReportPath = @ReportPath
      -- OwnerID = @OwnerID
   WHERE
      SessionID = @SessionID


   -- update expiration date on a snapshot that we reference
   IF @IsPermanentSnapshot != 0 BEGIN
      UPDATE
         SnapshotData
      SET
         ExpirationDate = DATEADD(n, @SnapshotTimeoutSeconds, @now)
      WHERE
         SnapshotDataID = @SnapshotDataID
   END ELSE BEGIN
      UPDATE
         [ReportServerTempDB].dbo.SnapshotData
      SET
         ExpirationDate = DATEADD(n, @SnapshotTimeoutSeconds, @now)
      WHERE
         SnapshotDataID = @SnapshotDataID
   END

END
ELSE
BEGIN -- no, insert it
   UPDATE PS
    SET PS.RefCount = 1
    FROM
        [ReportServerTempDB].dbo.PersistedStream as PS
    WHERE
        PS.SessionID = @SessionID

    INSERT INTO [ReportServerTempDB].dbo.SessionData
      (SessionID, SnapshotDataID, IsPermanentSnapshot, ReportPath,
       EffectiveParams, Timeout, AutoRefreshSeconds, Expiration,
       ShowHideInfo, DataSourceInfo, OwnerID,
       CreationTime, HasInteractivity, SnapshotExpirationDate, HistoryDate, AwaitingFirstExecution, EditSessionID, DataSetInfo)
   VALUES
      (@SessionID, @SnapshotDataID, @IsPermanentSnapshot, @ReportPath,
       @EffectiveParams, @Timeout, @AutoRefreshSeconds, DATEADD(s, @Timeout, @now),
       @ShowHideInfo, @DataSourceInfo, @OwnerID, @now,
       @HasInteractivity, @SnapshotExpirationDate, @HistoryDate, @AwaitingFirstExecution, @EditSessionID, @DataSetInfo)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSessionParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetSessionParameters]
@SessionID as varchar(32),
@OwnerSid as varbinary(85) = NULL,
@OwnerName as nvarchar(260),
@AuthType as int,
@EffectiveParams as ntext = NULL
AS

DECLARE @OwnerID uniqueidentifier
EXEC GetUserID @OwnerSid, @OwnerName, @AuthType, @OwnerID OUTPUT

UPDATE SE
SET
   SE.EffectiveParams = @EffectiveParams,
   SE.AwaitingFirstExecution = 1
FROM
   [ReportServerTempDB].dbo.SessionData AS SE
WHERE
   SE.SessionID = @SessionID AND
   SE.OwnerID = @OwnerID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSnapshotChunksVersion
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetSnapshotChunksVersion]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@Version as smallint
AS
declare @affectedRows int
set @affectedRows = 0
if @IsPermanentSnapshot = 1
BEGIN
   if @Version > 0
   BEGIN
      UPDATE ChunkData
      SET Version = @Version
      WHERE SnapshotDataID = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount

      UPDATE SegmentedChunk
      SET Version = @Version
      WHERE SnapshotDataId = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount
   END ELSE BEGIN
      UPDATE ChunkData
      SET Version = Version
      WHERE SnapshotDataID = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount

      UPDATE SegmentedChunk
      SET Version = Version
      WHERE SnapshotDataId = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount
   END
END ELSE BEGIN
   if @Version > 0
   BEGIN
      UPDATE [ReportServerTempDB].dbo.ChunkData
      SET Version = @Version
      WHERE SnapshotDataID = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount

      UPDATE [ReportServerTempDB].dbo.SegmentedChunk
      SET Version = @Version
      WHERE SnapshotDataId = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount
   END ELSE BEGIN
      UPDATE [ReportServerTempDB].dbo.ChunkData
      SET Version = Version
      WHERE SnapshotDataID = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount

      UPDATE [ReportServerTempDB].dbo.SegmentedChunk
      SET Version = Version
      WHERE SnapshotDataId = @SnapshotDataID

      SELECT @affectedRows = @affectedRows + @@rowcount
   END
END
SELECT @affectedRows

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSnapshotProcessingFlags
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetSnapshotProcessingFlags]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@ProcessingFlags int
AS

if @IsPermanentSnapshot = 1
BEGIN
    UPDATE SnapshotData
    SET ProcessingFlags = @ProcessingFlags
    WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
    UPDATE [ReportServerTempDB].dbo.SnapshotData
    SET ProcessingFlags = @ProcessingFlags
    WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetSystemPolicy
-- --------------------------------------------------
-- update the system policy
CREATE PROCEDURE [dbo].[SetSystemPolicy]
@PrimarySecDesc as image,
@SecondarySecDesc as ntext = NULL,
@XmlPolicy as ntext,
@AuthType as int,
@PolicyID uniqueidentifier OUTPUT
AS
SELECT @PolicyID = (SELECT PolicyID FROM Policies WHERE PolicyFlag = 1)
IF (@PolicyID IS NULL)
   BEGIN
     SET @PolicyID = newid()
     INSERT INTO Policies (PolicyID, PolicyFlag)
     VALUES (@PolicyID, 1)
     INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription, NTSecDescPrimary, NtSecDescSecondary)
     VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
   END
ELSE
   BEGIN
      DECLARE @SecDataID as uniqueidentifier
      SELECT @SecDataID = (SELECT SecDataID FROM SecData WHERE PolicyID = @PolicyID and AuthType = @AuthType)
      IF (@SecDataID IS NULL)
      BEGIN -- insert new sec desc's
        INSERT INTO SecData (SecDataID, PolicyID, AuthType, XmlDescription, NTSecDescPrimary, NtSecDescSecondary)
        VALUES (newid(), @PolicyID, @AuthType, @XmlPolicy, @PrimarySecDesc, @SecondarySecDesc)
      END
      ELSE
      BEGIN -- update existing sec desc's
        UPDATE SecData SET
        XmlDescription = @XmlPolicy,
        NtSecDescPrimary = @PrimarySecDesc,
        NtSecDescSecondary = @SecondarySecDesc
        WHERE SecData.PolicyID = @PolicyID
        AND AuthType = @AuthType

      END
   END
DELETE FROM PolicyUserRole WHERE PolicyID = @PolicyID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetUpgradeItemStatus
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SetUpgradeItemStatus]
@ItemName nvarchar(260),
@Status nvarchar(512)
AS
UPDATE
    [UpgradeInfo]
SET
    [Status] = @Status
WHERE
    [Item] = @ItemName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetUserServiceToken
-- --------------------------------------------------
-- set AAD token on user account
CREATE PROCEDURE [dbo].[SetUserServiceToken]
@ServiceToken ntext,
@UserSid as varbinary(85) = NULL,
@UserName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN
DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

IF (@UserID is not null)
    BEGIN
        UPDATE Users
        SET ServiceToken = @ServiceToken
        WHERE UserID = @UserID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SetUserSettings
-- --------------------------------------------------
-- set user properties on user account
CREATE PROCEDURE [dbo].[SetUserSettings]
@Setting ntext,
@UserSid as varbinary(85) = NULL,
@UserName as nvarchar(260) = NULL,
@AuthType int
AS
BEGIN
DECLARE @UserID uniqueidentifier
EXEC GetUserID @UserSid, @UserName, @AuthType, @UserID OUTPUT

IF (@UserID is not null)
    BEGIN
        UPDATE Users
        SET Setting = @Setting
        WHERE UserID = @UserID
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ShallowCopyChunk
-- --------------------------------------------------
create proc [dbo].[ShallowCopyChunk]
    @SnapshotId		uniqueidentifier,
    @ChunkId		uniqueidentifier,
    @IsPermanent	bit,
    @Machine		nvarchar(512),
    @NewChunkId		uniqueidentifier out
as
begin
    -- @SnapshotId & @ChunkId are the old identifiers
    -- build the chunksegmentmapping first to prevent race
    -- condition with cleaning it up
    select @NewChunkId = newid() ;
    if (@IsPermanent = 1) begin
        insert ChunkSegmentMapping (ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount)
        select @NewChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount
        from ChunkSegmentMapping where ChunkId = @ChunkId ;

        update SegmentedChunk
        set ChunkId = @NewChunkId
        where ChunkId = @ChunkId and SnapshotDataId = @SnapshotId
    end
    else begin
        insert [ReportServerTempDB].dbo.ChunkSegmentMapping (ChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount)
        select @NewChunkId, SegmentId, StartByte, LogicalByteCount, ActualByteCount
        from [ReportServerTempDB].dbo.ChunkSegmentMapping where ChunkId = @ChunkId ;

        -- update the machine name also, this is only really useful
        -- for file system chunks, in which case the snapshot should
        -- have been versioned on the initial update
        update [ReportServerTempDB].dbo.SegmentedChunk
        set
            ChunkId = @NewChunkId,
            Machine = @Machine
        where ChunkId = @ChunkId and SnapshotDataId = @SnapshotId
    end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.StoreServerParameters
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[StoreServerParameters]
@ServerParametersID nvarchar(32),
@Path nvarchar(425),
@CurrentDate datetime,
@Timeout int,
@Expiration datetime,
@ParametersValues image,
@ParentParametersID nvarchar(32) = NULL
AS

DECLARE @ExistingServerParametersID as nvarchar(32)
SET @ExistingServerParametersID = (SELECT ServerParametersID from [dbo].[ServerParametersInstance] WHERE ServerParametersID = @ServerParametersID)
IF @ExistingServerParametersID IS NULL -- new row
BEGIN
  INSERT INTO [dbo].[ServerParametersInstance]
    (ServerParametersID, ParentID, Path, CreateDate, ModifiedDate, Timeout, Expiration, ParametersValues)
  VALUES
    (@ServerParametersID, @ParentParametersID, @Path, @CurrentDate, @CurrentDate, @Timeout, @Expiration, @ParametersValues)
END
ELSE
BEGIN
  UPDATE [dbo].[ServerParametersInstance]
  SET Timeout = @Timeout,
  Expiration = @Expiration,
  ParametersValues = @ParametersValues,
  ModifiedDate = @CurrentDate,
  Path = @Path,
  ParentID = @ParentParametersID
  WHERE ServerParametersID = @ServerParametersID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TakeEventFromQueue
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[TakeEventFromQueue]
@EventType AS NVARCHAR(520)
AS

-- READPAST hint skip any row being locked (used by other query)
DELETE FROM [Event]
OUTPUT DELETED.*
WHERE EventID IN
(
    SELECT TOP 1 EventID
    FROM [Event] WITH (READPAST)
    WHERE EventType=@EventType
    ORDER BY TimeEntered ASC
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempChunkExists
-- --------------------------------------------------
CREATE PROC [dbo].[TempChunkExists]
    @ChunkId uniqueidentifier
AS
BEGIN
    SELECT COUNT(1) FROM [ReportServerTempDB].dbo.SegmentedChunk
    WHERE ChunkId = @ChunkId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TryAcquireCleanupLock
-- --------------------------------------------------
-- selects back 0 if lock NOT acquired
-- selects back 1 if lock acquired
-- Acquires a lock that governs the nightly cleanup (defaults to 2am) for the db.
-- this is done to keep scaleout farms from blocking each other, as each RS in a scaleout
-- farm  invokes the same cleanup job at the same time
-- IMPLEMENTATION: success updates the CleanupLock table with the specified machine name and time
-- lock is held for 8 hours
-- repeated calls from the same machine will all succeed
CREATE PROCEDURE [dbo].TryAcquireCleanupLock
@MachineName nvarchar(256)
AS

DECLARE @OldMachineName AS NVARCHAR(256);
DECLARE @OldLock        AS DATETIME;

SELECT @OldMachineName = CL.MachineName, @OldLock = CL.LockDate
FROM CleanupLock CL WITH (XLOCK)
WHERE CL.ID = 0;

IF @@ROWCOUNT = 0
BEGIN
    INSERT into CleanupLock
    (ID, MachineName, LockDate)
    VALUES
    (0, @MachineName, GETDATE());
    SELECT CAST(1 AS bit);
END
ELSE IF @OldMachineName = @MachineName
        OR @OldLock <  DATEADD(hour, -8, GETDATE())
BEGIN
    UPDATE CleanupLock
    SET MachineName = @MachineName,
        LockDate = GETDATE()
    WHERE
    ID = 0;
    SELECT CAST(1 AS bit);
END
ELSE
BEGIN
    SELECT CAST(0 AS bit);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateActiveSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateActiveSubscription]
@ActiveID uniqueidentifier,
@TotalNotifications int = NULL,
@TotalSuccesses int = NULL,
@TotalFailures int = NULL
AS

if @TotalNotifications is not NULL
begin
    update ActiveSubscriptions set TotalNotifications = @TotalNotifications where ActiveID = @ActiveID
end

if @TotalSuccesses is not NULL
begin
    update ActiveSubscriptions set TotalSuccesses = TotalSuccesses + @TotalSuccesses where ActiveID = @ActiveID
end

if @TotalFailures is not NULL
begin
    update ActiveSubscriptions set TotalFailures = TotalFailures + @TotalFailures where ActiveID = @ActiveID
end

select
    TotalNotifications,
    TotalSuccesses,
    TotalFailures
from
    ActiveSubscriptions
where
    ActiveID = @ActiveID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateCatalogContentSize
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateCatalogContentSize]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentSize bigint
AS
BEGIN
    UPDATE
        [dbo].[Catalog]
    SET
        [ContentSize] = @ContentSize
    WHERE
        [ItemID] = @CatalogItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateComment
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateComment]
@Text nvarchar(2048),
@CommentID bigint
AS
BEGIN
    UPDATE
        [Comments]
    SET
        [Text]=@Text,
        [ModifiedDate]=GETDATE()
    WHERE
        [CommentID]=@CommentID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateCompiledDefinition
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateCompiledDefinition]
    @Path				NVARCHAR(425),
    @OldSnapshotId		UNIQUEIDENTIFIER,
    @NewSnapshotId		UNIQUEIDENTIFIER,
    @ItemId				UNIQUEIDENTIFIER OUTPUT
AS BEGIN
    -- we have a clustered unique index on [Path] which the QO
    -- should match for the filter
    UPDATE [dbo].[Catalog]
    SET [Intermediate] = @NewSnapshotId,
        @ItemId = [ItemID]
    WHERE [Path] = @Path AND
          ([Intermediate] = @OldSnapshotId OR (@OldSnapshotId IS NULL AND [Intermediate] IS NULL));

    DECLARE @UpdatedReferences INT ;
    SELECT @UpdatedReferences = @@ROWCOUNT ;

    IF(@UpdatedReferences <> 0)
    BEGIN
        UPDATE [dbo].[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] + @UpdatedReferences,
            [TransientRefcount] = [TransientRefcount] - 1
        WHERE [SnapshotDataID] = @NewSnapshotId ;

        UPDATE [dbo].[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] - @UpdatedReferences
        WHERE [SnapshotDataID] = @OldSnapshotId ;
    END
END

GRANT EXECUTE ON [dbo].[UpdateCompiledDefinition] TO RSExecRole

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateDataModelDataSourceByID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateDataModelDataSourceByID]
    @DataSourceID UNIQUEIDENTIFIER,
    @AuthType VARCHAR(100),
    @ConnectionString VARBINARY(MAX) = NULL,
    @Username VARBINARY(MAX) = NULL,
    @Password VARBINARY(MAX) = NULL,
    @ModifiedByID UNIQUEIDENTIFIER
AS

BEGIN
UPDATE [dbo].[DataModelDataSource]
SET
    [AuthType] = @AuthType,
    [ConnectionString] = @ConnectionString,
    [Username] = @Username,
    [Password] = @Password,
    [ModifiedByID] = @ModifiedByID,
    [ModifiedDate] = GETDATE()
WHERE [DataSourceID] = @DataSourceID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateDataModelRoleByID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateDataModelRoleByID]
    @DataModelRoleID bigint,
    @ModelRoleName NVARCHAR(255)
AS
BEGIN
    UPDATE 
        [dbo].[DataModelRole]
    SET
        [ModelRoleName] = @ModelRoleName
    WHERE 
        [DataModelRoleID] = @DataModelRoleID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdatePolicy
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdatePolicy]
    @PolicyID as uniqueidentifier,
    @PrimarySecDesc as image,
    @SecondarySecDesc as ntext = NULL,
    @AuthType int
AS
    UPDATE SecData
    SET
        NtSecDescPrimary = @PrimarySecDesc,
        NtSecDescSecondary = @SecondarySecDesc,
        NtSecDescState = 0 -- Setting State back to Valid
    WHERE
        SecData.PolicyID = @PolicyID AND
        SecData.AuthType = @AuthType

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdatePolicyPrincipal
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdatePolicyPrincipal]
@PolicyID uniqueidentifier,
@PrincipalSid varbinary(85) = NULL,
@PrincipalName nvarchar(260),
@PrincipalAuthType int,
@RoleName nvarchar(260),
@PrincipalID uniqueidentifier OUTPUT,
@RoleID uniqueidentifier OUTPUT
AS
EXEC GetPrincipalID @PrincipalSid , @PrincipalName, @PrincipalAuthType, @PrincipalID  OUTPUT
SELECT @RoleID = (SELECT RoleID FROM Roles WHERE RoleName = @RoleName)
INSERT INTO PolicyUserRole
(ID, RoleID, UserID, PolicyID)
VALUES (newid(), @RoleID, @PrincipalID, @PolicyID)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdatePolicyRole
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdatePolicyRole]
@PolicyID uniqueidentifier,
@PrincipalID uniqueidentifier,
@RoleName nvarchar(260),
@RoleID uniqueidentifier OUTPUT
AS
SELECT @RoleID = (SELECT RoleID FROM Roles WHERE RoleName = @RoleName)
INSERT INTO PolicyUserRole
(ID, RoleID, UserID, PolicyID)
VALUES (newid(), @RoleID, @PrincipalID, @PolicyID)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdatePolicyStatus
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdatePolicyStatus]
    @PolicyID as uniqueidentifier,
    @AuthType int,
    @Status int
AS
    UPDATE SecData
    SET
        NtSecDescState = @Status
    WHERE
        SecData.PolicyID = @PolicyID AND SecData.AuthType = @AuthType

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateRunningJob
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateRunningJob]
@JobID as nvarchar(32),
@JobStatus as smallint
AS
SET NOCOUNT OFF
UPDATE RunningJobs SET JobStatus = @JobStatus WHERE JobID = @JobID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateScheduleNextRunTime
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateScheduleNextRunTime]
@ScheduleID as uniqueidentifier,
@NextRunTime as datetime
as
update Schedule set [NextRunTime] = @NextRunTime where [ScheduleID] = @ScheduleID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSnapshot
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSnapshot]
@Path as nvarchar(425),
@SnapshotDataID as uniqueidentifier,
@executionDate as datetime
AS
DECLARE @OldSnapshotDataID uniqueidentifier
DECLARE @ExecutionFlag int

SELECT @OldSnapshotDataID = SnapshotDataID,
       @ExecutionFlag = ExecutionFlag
       FROM Catalog WITH (XLOCK) WHERE Catalog.Path = @Path

    -- If the report is deleted after execution snapshot is fired
    IF (@@rowcount = 0)
    BEGIN
        RAISERROR('Report does not exist', 16, 1)
        RETURN
    END

-- update reference count in snapshot table
UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount-1
WHERE SnapshotData.SnapshotDataID = @OldSnapshotDataID

 -- If the report is not set to execution snapshot after the
 -- update execution snapshot fired, ignore this case.
IF (@ExecutionFlag & 3) <> 2
    BEGIN
        RAISERROR('Invalid snapshot flag', 16, 1)
        RETURN
    END

-- update catalog to point to the new execution snapshot
UPDATE Catalog
SET SnapshotDataID = @SnapshotDataID, ExecutionTime = @executionDate
WHERE Catalog.Path = @Path

UPDATE SnapshotData
SET PermanentRefcount = PermanentRefcount+1, TransientRefcount = TransientRefcount-1
WHERE SnapshotData.SnapshotDataID = @SnapshotDataID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSnapshotPaginationInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSnapshotPaginationInfo]
@SnapshotDataID as uniqueidentifier,
@IsPermanentSnapshot as bit,
@PageCount as int,
@PaginationMode as smallint
AS
IF @IsPermanentSnapshot = 1
BEGIN
   UPDATE SnapshotData SET
    PageCount = @PageCount,
    PaginationMode = @PaginationMode
   WHERE SnapshotDataID = @SnapshotDataID
END ELSE BEGIN
   UPDATE [ReportServerTempDB].dbo.SnapshotData SET
    PageCount = @PageCount,
    PaginationMode = @PaginationMode
   WHERE SnapshotDataID = @SnapshotDataID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSnapshotReferences
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSnapshotReferences]
    @OldSnapshotId UNIQUEIDENTIFIER,
    @NewSnapshotId UNIQUEIDENTIFIER,
    @IsPermanentSnapshot BIT,
    @TransientRefCountModifier INT,
    @UpdatedReferences INT OUTPUT
AS
BEGIN
    SET @UpdatedReferences = 0

    IF(@IsPermanentSnapshot = 1)
    BEGIN
        -- Update Snapshot Executions
        UPDATE [dbo].[Catalog]
        SET [SnapshotDataID] = @NewSnapshotId
        WHERE [SnapshotDataID] = @OldSnapshotId

        SELECT @UpdatedReferences = @UpdatedReferences + @@ROWCOUNT

        -- Update History
        UPDATE [dbo].[History]
        SET [SnapshotDataID] = @NewSnapshotId
        WHERE [SnapshotDataID] = @OldSnapshotId

        SELECT @UpdatedReferences = @UpdatedReferences + @@ROWCOUNT

        UPDATE [dbo].[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] - @UpdatedReferences,
            [TransientRefcount] = [TransientRefcount] + @TransientRefCountModifier
        WHERE [SnapshotDataID] = @OldSnapshotId

        UPDATE [dbo].[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] + @UpdatedReferences
        WHERE [SnapshotDataID] = @NewSnapshotId
    END
    ELSE
    BEGIN
        -- Update Execution Cache
        UPDATE [ReportServerTempDB].dbo.[ExecutionCache]
        SET [SnapshotDataID] = @NewSnapshotId
        WHERE [SnapshotDataID] = @OldSnapshotId

        SELECT @UpdatedReferences = @UpdatedReferences + @@ROWCOUNT

        UPDATE [ReportServerTempDB].dbo.[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] - @UpdatedReferences,
            [TransientRefcount] = [TransientRefcount] + @TransientRefCountModifier
        WHERE [SnapshotDataID] = @OldSnapshotId

        UPDATE [ReportServerTempDB].dbo.[SnapshotData]
        SET [PermanentRefcount] = [PermanentRefcount] + @UpdatedReferences
        WHERE [SnapshotDataID] = @NewSnapshotId
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSubscription
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSubscription]
@id uniqueidentifier,
@Locale nvarchar(260),
@OwnerSid varbinary(85) = NULL,
@OwnerName nvarchar(260),
@OwnerAuthType int,
@DeliveryExtension nvarchar(260) = NULL,
@InactiveFlags int,
@ExtensionSettings ntext = NULL,
@ModifiedBySid varbinary(85) = NULL,
@ModifiedByName nvarchar(260),
@ModifiedByAuthType int,
@ModifiedDate datetime,
@Description nvarchar(512) = NULL,
@LastStatus nvarchar(260) = NULL,
@EventType nvarchar(260),
@MatchData ntext = NULL,
@Parameters ntext = NULL,
@DataSettings ntext = NULL,
@Version int
AS
-- Update a subscription's information.
DECLARE @ModifiedByID uniqueidentifier
DECLARE @OwnerID uniqueidentifier

EXEC GetUserID @ModifiedBySid, @ModifiedByName, @ModifiedByAuthType, @ModifiedByID OUTPUT
EXEC GetUserID @OwnerSid, @OwnerName, @OwnerAuthType, @OwnerID OUTPUT

-- Make sure there is a valid provider
update Subscriptions set
        [DeliveryExtension] = @DeliveryExtension,
        [Locale] = @Locale,
        [OwnerID] = @OwnerID,
        [InactiveFlags] = @InactiveFlags,
        [ExtensionSettings] = @ExtensionSettings,
        [ModifiedByID] = @ModifiedByID,
        [ModifiedDate] = @ModifiedDate,
        [Description] = @Description,
        [LastStatus] = @LastStatus,
        [EventType] = @EventType,
        [MatchData] = @MatchData,
        [Parameters] = @Parameters,
        [DataSettings] = @DataSettings,
    [Version] = @Version
where
    [SubscriptionID] = @id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSubscriptionHistoryEntry
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSubscriptionHistoryEntry]
	@SubscriptionHistoryID BIGINT,
	@EndTime DATETIME,
	@Status TINYINT,
	@Message NVARCHAR(1500),
	@Details NVARCHAR(4000)
AS
BEGIN

	UPDATE [dbo].[SubscriptionHistory]
	   SET [EndTime] = @EndTime
		  ,[Status] = @Status
		  ,[Message] = @Message
		  ,[Details] = @Details
	 WHERE [SubscriptionHistoryID] = @SubscriptionHistoryID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSubscriptionLastRunInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSubscriptionLastRunInfo]
@SubscriptionID uniqueidentifier,
@Flags int,
@LastRunTime datetime,
@LastStatus nvarchar(260)
AS

update Subscriptions set
        [InactiveFlags] = @Flags,
        [LastRunTime] = @LastRunTime,
        [LastStatus] = @LastStatus
where
    [SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSubscriptionResult
-- --------------------------------------------------
CREATE PROCEDURE [dbo].UpdateSubscriptionResult
@SubscriptionID uniqueidentifier,
@ExtensionSettings nvarchar(max),
@SubscriptionResult nvarchar(256)
AS
    declare @ExtensionSettingsHash int
    set @ExtensionSettingsHash = CHECKSUM(@ExtensionSettings)

    IF EXISTS (
        SELECT 1 FROM dbo.[SubscriptionResults]
        WHERE [SubscriptionID]=@SubscriptionID
            AND [ExtensionSettingsHash]=@ExtensionSettingsHash
            AND [ExtensionSettings] = @ExtensionSettings)
    BEGIN
        UPDATE [SubscriptionResults] SET [SubscriptionResult]=@SubscriptionResult
        WHERE [SubscriptionID]=@SubscriptionID
            AND [ExtensionSettingsHash]=@ExtensionSettingsHash
            AND [ExtensionSettings] = @ExtensionSettings
    END
    ELSE
    BEGIN
        INSERT INTO [SubscriptionResults] (SubscriptionResultID, SubscriptionID, ExtensionSettingsHash, ExtensionSettings, SubscriptionResult)
        VALUES (NewID(), @SubscriptionID, @ExtensionSettingsHash, @ExtensionSettings, @SubscriptionResult)
    END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateSubscriptionStatus
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateSubscriptionStatus]
@SubscriptionID uniqueidentifier,
@Status nvarchar(260)
AS

update Subscriptions set
        [LastStatus] = @Status
where
    [SubscriptionID] = @SubscriptionID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateTask
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateTask]
@ScheduleID uniqueidentifier,
@Name nvarchar (260),
@StartDate datetime,
@Flags int,
@NextRunTime datetime = NULL,
@LastRunTime datetime = NULL,
@EndDate datetime = NULL,
@RecurrenceType int = NULL,
@MinutesInterval int = NULL,
@DaysInterval int = NULL,
@WeeksInterval int = NULL,
@DaysOfWeek int = NULL,
@DaysOfMonth int = NULL,
@Month int = NULL,
@MonthlyWeek int = NULL,
@State int = NULL,
@LastRunStatus nvarchar (260) = NULL,
@ScheduledRunTimeout int = NULL

AS

-- Update a tasks values. ScheduleID and Report information can not be updated
Update Schedule set
        [StartDate] = @StartDate,
        [Name] = @Name,
        [Flags] = @Flags,
        [NextRunTime] = @NextRunTime,
        [LastRunTime] = @LastRunTime,
        [EndDate] = @EndDate,
        [RecurrenceType] = @RecurrenceType,
        [MinutesInterval] = @MinutesInterval,
        [DaysInterval] = @DaysInterval,
        [WeeksInterval] = @WeeksInterval,
        [DaysOfWeek] = @DaysOfWeek,
        [DaysOfMonth] = @DaysOfMonth,
        [Month] = @Month,
        [MonthlyWeek] = @MonthlyWeek,
        [State] = @State,
        [LastRunStatus] = @LastRunStatus,
        [ScheduledRunTimeout] = @ScheduledRunTimeout
where
    [ScheduleID] = @ScheduleID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpdateUsernameFromSID
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UpdateUsernameFromSID]
AS
SET NOCOUNT OFF

DECLARE @TotalRecords BIGINT;
DECLARE @BatchSize INT = 100;
DECLARE @i BIGINT = 0;


SELECT ROW_NUMBER() OVER (ORDER BY ModifiedDate ASC) AS RowNumber, [Sid] INTO #SidsToUpdate FROM [dbo].[Users]
WHERE AuthType=1

SELECT @TotalRecords = MAX(RowNumber) FROM #SidsToUpdate

WHILE (@i <= @TotalRecords)
BEGIN

    UPDATE [dbo].[Users] SET UserName = COALESCE(SUSER_SNAME([Sid]), UserName), ModifiedDate = GETDATE()
    WHERE AuthType=1 AND [Sid] IN (SELECT [Sid] FROM #SidsToUpdate WHERE RowNumber >= @i AND RowNumber < @i + @BatchSize )

    SET @i = @i + @BatchSize
END

DROP TABLE #SidsToUpdate

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpgradeSharePointPaths
-- --------------------------------------------------
CREATE PROC [dbo].[UpgradeSharePointPaths]
    @OldPrefix nvarchar(440),
    @NewPrefix nvarchar(440),
    @PrefixLen int

AS
BEGIN
UPDATE [Catalog]
  SET [Path] = @NewPrefix + SUBSTRING([Path], @PrefixLen, 5000)
  WHERE [Path] like @OldPrefix escape '*';
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UpgradeSharePointSchedulePaths
-- --------------------------------------------------
CREATE PROC [dbo].[UpgradeSharePointSchedulePaths]
    @OldPath nvarchar(440),
    @NewPath nvarchar(440)

AS
BEGIN
-- Update Path if the pair (Name, NewPath) is unique.
UPDATE [Schedule]
  SET [Path] = @NewPath
  WHERE [Path] = @OldPath
  AND NOT EXISTS (SELECT [Name] FROM [Schedule] AS S2
                    WHERE S2.[Path] = @NewPath
                    AND S2.[Name] = [Schedule].[Name])

-- If any paths were not updated in the first pass, generate a unique name.
-- Update Name, Path to (Name + "(<ScheduleID>)", NewPath)
UPDATE [Schedule]
  SET [Path] = @NewPath,
       [Name] = [Name] + ' (' + CAST([ScheduleID] AS NCHAR(36)) + ')'
  WHERE [Path] = @OldPath
  AND NOT EXISTS (SELECT [Name] FROM [Schedule] AS S2
                    WHERE S2.[Path] = @NewPath
                    AND S2.[Name] = [Schedule].[Name] + ' (' + CAST([Schedule].[ScheduleID] AS NCHAR(36)) + ')')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteCatalogContentChunk
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteCatalogContentChunk]
    @CatalogItemID uniqueidentifier,
    @Chunk varbinary(max),
    @Offset int,
    @Length int
AS
BEGIN
    UPDATE
        [Catalog]
    SET [Content]
        .WRITE(@Chunk, @Offset, @Length)
    WHERE [ItemID] = @CatalogItemID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteCatalogExtendedContentChunk
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteCatalogExtendedContentChunk]
    @CatalogItemID UNIQUEIDENTIFIER,
    @ContentType VARCHAR(50),
    @Chunk VARBINARY(max),
    @Offset INT,
    @Length INT
AS
BEGIN
    UPDATE
        [CatalogItemExtendedContent]
    SET [Content]
        .WRITE(@Chunk, @Offset, @Length)
    WHERE
        [ItemID] = @CatalogItemID AND ContentType = @ContentType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteCatalogExtendedContentChunkById
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteCatalogExtendedContentChunkById]
    @Id bigint,
    @Chunk VARBINARY(max),
    @Offset INT,
    @Length INT
AS
BEGIN
    UPDATE
        [dbo].[CatalogItemExtendedContent]
    SET [Content]
        .WRITE(@Chunk, @Offset, @Length)
    WHERE
        [Id] = @Id
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteChunkPortion
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteChunkPortion]
@ChunkPointer binary(16),
@IsPermanentSnapshot bit,
@DataIndex int = NULL,
@DeleteLength int = NULL,
@Content image
AS

IF @IsPermanentSnapshot != 0 BEGIN
    UPDATETEXT ChunkData.Content @ChunkPointer @DataIndex @DeleteLength @Content
END ELSE BEGIN
    UPDATETEXT [ReportServerTempDB].dbo.ChunkData.Content @ChunkPointer @DataIndex @DeleteLength @Content
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteChunkSegment
-- --------------------------------------------------
create proc [dbo].[WriteChunkSegment]
    @ChunkId			uniqueidentifier,
    @IsPermanent		bit,
    @SegmentId			uniqueidentifier,
    @DataIndex			int,
    @Length				int,
    @LogicalByteCount	int,
    @Content			varbinary(max)
as begin
    declare @output table (actualLength int not null) ;
    if(@IsPermanent = 1) begin
        update Segment
        set Content.write( substring(@Content, 1, @Length), @DataIndex, @Length )
        output datalength(inserted.Content) into @output(actualLength)
        where SegmentId = @SegmentId

        update ChunkSegmentMapping
        set LogicalByteCount = @LogicalByteCount,
            ActualByteCount = (select top 1 actualLength from @output)
        where ChunkSegmentMapping.ChunkId = @ChunkId and ChunkSegmentMapping.SegmentId = @SegmentId
    end
    else begin
        update [ReportServerTempDB].dbo.Segment
        set Content.write( substring(@Content, 1, @Length), @DataIndex, @Length )
        output datalength(inserted.Content) into @output(actualLength)
        where SegmentId = @SegmentId

        update [ReportServerTempDB].dbo.ChunkSegmentMapping
        set LogicalByteCount = @LogicalByteCount,
            ActualByteCount = (select top 1 actualLength from @output)
        where ChunkId = @ChunkId and SegmentId = @SegmentId
    end

    if(@@rowcount <> 1)
        raiserror('unexpected # of segments update', 16, 1)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteFirstPortionPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteFirstPortionPersistedStream]
@SessionID varchar(32),
@Index int,
@Name nvarchar(260) = NULL,
@MimeType nvarchar(260) = NULL,
@Extension nvarchar(260) = NULL,
@Encoding nvarchar(260) = NULL,
@Content image
AS

UPDATE [ReportServerTempDB].dbo.PersistedStream set Content = @Content, [Name] = @Name, MimeType = @MimeType, Extension = @Extension WHERE SessionID = @SessionID AND [Index] = @Index

SELECT TEXTPTR(Content) FROM [ReportServerTempDB].dbo.PersistedStream WHERE SessionID = @SessionID AND [Index] = @Index

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteLockSession
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteLockSession]
@SessionID as varchar(32),
@Persisted bit,
@CheckLockVersion bit = 0,
@LockVersion int
AS
SET NOCOUNT OFF ;
IF @Persisted = 1
BEGIN
    IF @CheckLockVersion = 0
    BEGIN
        UPDATE [ReportServerTempDB].dbo.SessionLock WITH (ROWLOCK)
        SET SessionID = SessionID
        WHERE SessionID = @SessionID;
    END
    ELSE
    BEGIN
        DECLARE @ActualLockVersion as int

        UPDATE [ReportServerTempDB].dbo.SessionLock WITH (ROWLOCK)
        SET SessionID = SessionID,
        LockVersion = LockVersion + 1
        WHERE SessionID = @SessionID
        AND LockVersion = @LockVersion ;

        IF (@@ROWCOUNT = 0)
        BEGIN
            SELECT @ActualLockVersion = LockVersion
            FROM [ReportServerTempDB].dbo.SessionLock WITH (ROWLOCK)
            WHERE SessionID = @SessionID;

            IF (@ActualLockVersion <> @LockVersion)
                RAISERROR ('Invalid version locked', 16,1)
            END
        END
    END
ELSE
BEGIN
    INSERT INTO [ReportServerTempDB].dbo.SessionLock WITH (ROWLOCK) (SessionID) VALUES (@SessionID)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WriteNextPortionPersistedStream
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[WriteNextPortionPersistedStream]
@DataPointer binary(16),
@DataIndex int,
@DeleteLength int,
@Content image
AS

UPDATETEXT [ReportServerTempDB].dbo.PersistedStream.Content @DataPointer @DataIndex @DeleteLength @Content

GO

-- --------------------------------------------------
-- TABLE dbo.ActiveSubscriptions
-- --------------------------------------------------
CREATE TABLE [dbo].[ActiveSubscriptions]
(
    [ActiveID] UNIQUEIDENTIFIER NOT NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [TotalNotifications] INT NULL,
    [TotalSuccesses] INT NOT NULL,
    [TotalFailures] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AlertSubscribers
-- --------------------------------------------------
CREATE TABLE [dbo].[AlertSubscribers]
(
    [AlertSubscriptionID] BIGINT IDENTITY(1,1) NOT NULL,
    [AlertType] NVARCHAR(50) NOT NULL,
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Batch
-- --------------------------------------------------
CREATE TABLE [dbo].[Batch]
(
    [BatchID] UNIQUEIDENTIFIER NOT NULL,
    [AddedOn] DATETIME NOT NULL,
    [Action] VARCHAR(32) NOT NULL,
    [Item] NVARCHAR(425) NULL,
    [Parent] NVARCHAR(425) NULL,
    [Param] NVARCHAR(425) NULL,
    [BoolParam] BIT NULL,
    [Content] IMAGE NULL,
    [Properties] NTEXT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CachePolicy
-- --------------------------------------------------
CREATE TABLE [dbo].[CachePolicy]
(
    [CachePolicyID] UNIQUEIDENTIFIER NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [ExpirationFlags] INT NOT NULL,
    [CacheExpiration] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Catalog
-- --------------------------------------------------
CREATE TABLE [dbo].[Catalog]
(
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [Path] NVARCHAR(425) NOT NULL,
    [Name] NVARCHAR(425) NOT NULL,
    [ParentID] UNIQUEIDENTIFIER NULL,
    [Type] INT NOT NULL,
    [Content] VARBINARY(MAX) NULL,
    [Intermediate] UNIQUEIDENTIFIER NULL,
    [SnapshotDataID] UNIQUEIDENTIFIER NULL,
    [LinkSourceID] UNIQUEIDENTIFIER NULL,
    [Property] NTEXT NULL,
    [Description] NVARCHAR(512) NULL,
    [Hidden] BIT NULL,
    [CreatedByID] UNIQUEIDENTIFIER NOT NULL,
    [CreationDate] DATETIME NOT NULL,
    [ModifiedByID] UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate] DATETIME NOT NULL,
    [MimeType] NVARCHAR(260) NULL,
    [SnapshotLimit] INT NULL,
    [Parameter] NTEXT NULL,
    [PolicyID] UNIQUEIDENTIFIER NOT NULL,
    [PolicyRoot] BIT NOT NULL,
    [ExecutionFlag] INT NOT NULL,
    [ExecutionTime] DATETIME NULL,
    [SubType] NVARCHAR(128) NULL,
    [ComponentID] UNIQUEIDENTIFIER NULL,
    [ContentSize] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CatalogItemExtendedContent
-- --------------------------------------------------
CREATE TABLE [dbo].[CatalogItemExtendedContent]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [ItemId] UNIQUEIDENTIFIER NULL,
    [ContentType] VARCHAR(50) NULL,
    [Content] VARBINARY(MAX) NULL,
    [ModifiedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ChunkData
-- --------------------------------------------------
CREATE TABLE [dbo].[ChunkData]
(
    [ChunkID] UNIQUEIDENTIFIER NOT NULL,
    [SnapshotDataID] UNIQUEIDENTIFIER NOT NULL,
    [ChunkFlags] TINYINT NULL,
    [ChunkName] NVARCHAR(260) NULL,
    [ChunkType] INT NULL,
    [Version] SMALLINT NULL,
    [MimeType] NVARCHAR(260) NULL,
    [Content] IMAGE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ChunkSegmentMapping
-- --------------------------------------------------
CREATE TABLE [dbo].[ChunkSegmentMapping]
(
    [ChunkId] UNIQUEIDENTIFIER NOT NULL,
    [SegmentId] UNIQUEIDENTIFIER NOT NULL,
    [StartByte] BIGINT NOT NULL,
    [LogicalByteCount] INT NOT NULL,
    [ActualByteCount] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CleanupLock
-- --------------------------------------------------
CREATE TABLE [dbo].[CleanupLock]
(
    [ID] INT NOT NULL,
    [MachineName] NVARCHAR(256) NULL,
    [LockDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Comments
-- --------------------------------------------------
CREATE TABLE [dbo].[Comments]
(
    [CommentID] BIGINT IDENTITY(1,1) NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [ThreadID] BIGINT NULL,
    [Text] NVARCHAR(2048) NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [AttachmentID] UNIQUEIDENTIFIER NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ConfigurationInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[ConfigurationInfo]
(
    [ConfigInfoID] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(260) NOT NULL,
    [Value] NTEXT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataModelDataSource
-- --------------------------------------------------
CREATE TABLE [dbo].[DataModelDataSource]
(
    [DSID] BIGINT IDENTITY(1,1) NOT NULL,
    [ItemId] UNIQUEIDENTIFIER NOT NULL,
    [DSType] VARCHAR(100) NULL,
    [DSKind] VARCHAR(100) NULL,
    [AuthType] VARCHAR(100) NULL,
    [ConnectionString] VARBINARY(MAX) NULL,
    [Username] VARBINARY(MAX) NULL,
    [Password] VARBINARY(MAX) NULL,
    [ModelConnectionName] VARCHAR(260) NULL,
    [CreatedByID] UNIQUEIDENTIFIER NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [ModifiedByID] UNIQUEIDENTIFIER NULL,
    [ModifiedDate] DATETIME NOT NULL DEFAULT (getdate()),
    [DataSourceID] UNIQUEIDENTIFIER NOT NULL DEFAULT (newsequentialid())
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataModelRole
-- --------------------------------------------------
CREATE TABLE [dbo].[DataModelRole]
(
    [DataModelRoleID] BIGINT IDENTITY(1,1) NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [ModelRoleID] UNIQUEIDENTIFIER NOT NULL,
    [ModelRoleName] NVARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataSets
-- --------------------------------------------------
CREATE TABLE [dbo].[DataSets]
(
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [LinkID] UNIQUEIDENTIFIER NULL,
    [Name] NVARCHAR(260) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DataSource
-- --------------------------------------------------
CREATE TABLE [dbo].[DataSource]
(
    [DSID] UNIQUEIDENTIFIER NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NULL,
    [Name] NVARCHAR(260) NULL,
    [Extension] NVARCHAR(260) NULL,
    [Link] UNIQUEIDENTIFIER NULL,
    [CredentialRetrieval] INT NULL,
    [Prompt] NTEXT NULL,
    [ConnectionString] IMAGE NULL,
    [OriginalConnectionString] IMAGE NULL,
    [OriginalConnectStringExpressionBased] BIT NULL,
    [UserName] IMAGE NULL,
    [Password] IMAGE NULL,
    [Flags] INT NULL,
    [Version] INT NOT NULL,
    [DSIDNum] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DBUpgradeHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[DBUpgradeHistory]
(
    [UpgradeID] BIGINT IDENTITY(1,1) NOT NULL,
    [DbVersion] NVARCHAR(25) NULL,
    [User] NVARCHAR(128) NULL DEFAULT (suser_sname()),
    [DateTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.Event
-- --------------------------------------------------
CREATE TABLE [dbo].[Event]
(
    [EventID] UNIQUEIDENTIFIER NOT NULL,
    [EventType] NVARCHAR(260) NOT NULL,
    [EventData] NVARCHAR(260) NULL,
    [TimeEntered] DATETIME NOT NULL,
    [ProcessStart] DATETIME NULL,
    [ProcessHeartbeat] DATETIME NULL,
    [BatchID] UNIQUEIDENTIFIER NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ExecutionLogStorage
-- --------------------------------------------------
CREATE TABLE [dbo].[ExecutionLogStorage]
(
    [LogEntryId] BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceName] NVARCHAR(38) NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NULL,
    [UserName] NVARCHAR(260) NULL,
    [ExecutionId] NVARCHAR(64) NULL,
    [RequestType] TINYINT NOT NULL,
    [Format] NVARCHAR(26) NULL,
    [Parameters] NTEXT NULL,
    [ReportAction] TINYINT NULL,
    [TimeStart] DATETIME NOT NULL,
    [TimeEnd] DATETIME NOT NULL,
    [TimeDataRetrieval] INT NOT NULL,
    [TimeProcessing] INT NOT NULL,
    [TimeRendering] INT NOT NULL,
    [Source] TINYINT NOT NULL,
    [Status] NVARCHAR(40) NOT NULL,
    [ByteCount] BIGINT NOT NULL,
    [RowCount] BIGINT NOT NULL,
    [AdditionalInfo] XML NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Favorites
-- --------------------------------------------------
CREATE TABLE [dbo].[Favorites]
(
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [UserID] UNIQUEIDENTIFIER NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.History
-- --------------------------------------------------
CREATE TABLE [dbo].[History]
(
    [HistoryID] UNIQUEIDENTIFIER NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [SnapshotDataID] UNIQUEIDENTIFIER NOT NULL,
    [SnapshotDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Keys
-- --------------------------------------------------
CREATE TABLE [dbo].[Keys]
(
    [MachineName] NVARCHAR(256) NULL,
    [InstallationID] UNIQUEIDENTIFIER NOT NULL,
    [InstanceName] NVARCHAR(32) NULL,
    [Client] INT NOT NULL,
    [PublicKey] IMAGE NULL,
    [SymmetricKey] IMAGE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ModelDrill
-- --------------------------------------------------
CREATE TABLE [dbo].[ModelDrill]
(
    [ModelDrillID] UNIQUEIDENTIFIER NOT NULL,
    [ModelID] UNIQUEIDENTIFIER NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [ModelItemID] NVARCHAR(425) NOT NULL,
    [Type] TINYINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ModelItemPolicy
-- --------------------------------------------------
CREATE TABLE [dbo].[ModelItemPolicy]
(
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [CatalogItemID] UNIQUEIDENTIFIER NOT NULL,
    [ModelItemID] NVARCHAR(425) NOT NULL,
    [PolicyID] UNIQUEIDENTIFIER NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ModelPerspective
-- --------------------------------------------------
CREATE TABLE [dbo].[ModelPerspective]
(
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [ModelID] UNIQUEIDENTIFIER NOT NULL,
    [PerspectiveID] NTEXT NOT NULL,
    [PerspectiveName] NTEXT NULL,
    [PerspectiveDescription] NTEXT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Notifications
-- --------------------------------------------------
CREATE TABLE [dbo].[Notifications]
(
    [NotificationID] UNIQUEIDENTIFIER NOT NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [ActivationID] UNIQUEIDENTIFIER NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [SnapShotDate] DATETIME NULL,
    [ExtensionSettings] NTEXT NOT NULL,
    [Locale] NVARCHAR(128) NOT NULL,
    [Parameters] NTEXT NULL,
    [ProcessStart] DATETIME NULL,
    [NotificationEntered] DATETIME NOT NULL,
    [ProcessAfter] DATETIME NULL,
    [Attempt] INT NULL,
    [SubscriptionLastRunTime] DATETIME NOT NULL,
    [DeliveryExtension] NVARCHAR(260) NOT NULL,
    [SubscriptionOwnerID] UNIQUEIDENTIFIER NOT NULL,
    [IsDataDriven] BIT NOT NULL,
    [BatchID] UNIQUEIDENTIFIER NULL,
    [ProcessHeartbeat] DATETIME NULL,
    [Version] INT NOT NULL,
    [ReportZone] INT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.Policies
-- --------------------------------------------------
CREATE TABLE [dbo].[Policies]
(
    [PolicyID] UNIQUEIDENTIFIER NOT NULL,
    [PolicyFlag] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.PolicyUserRole
-- --------------------------------------------------
CREATE TABLE [dbo].[PolicyUserRole]
(
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [RoleID] UNIQUEIDENTIFIER NOT NULL,
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [PolicyID] UNIQUEIDENTIFIER NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ProductInfoHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[ProductInfoHistory]
(
    [DateTime] DATETIME NULL DEFAULT (getdate()),
    [DbSchemaHash] VARCHAR(128) NOT NULL,
    [Sku] VARCHAR(25) NOT NULL,
    [BuildNumber] VARCHAR(25) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ReportSchedule
-- --------------------------------------------------
CREATE TABLE [dbo].[ReportSchedule]
(
    [ScheduleID] UNIQUEIDENTIFIER NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NULL,
    [ReportAction] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Roles
-- --------------------------------------------------
CREATE TABLE [dbo].[Roles]
(
    [RoleID] UNIQUEIDENTIFIER NOT NULL,
    [RoleName] NVARCHAR(260) NOT NULL,
    [Description] NVARCHAR(512) NULL,
    [TaskMask] NVARCHAR(32) NOT NULL,
    [RoleFlags] TINYINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RunningJobs
-- --------------------------------------------------
CREATE TABLE [dbo].[RunningJobs]
(
    [JobID] NVARCHAR(32) NOT NULL,
    [StartDate] DATETIME NOT NULL,
    [ComputerName] NVARCHAR(32) NOT NULL,
    [RequestName] NVARCHAR(425) NOT NULL,
    [RequestPath] NVARCHAR(425) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [Description] NTEXT NULL,
    [Timeout] INT NOT NULL,
    [JobAction] SMALLINT NOT NULL,
    [JobType] SMALLINT NOT NULL,
    [JobStatus] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Schedule
-- --------------------------------------------------
CREATE TABLE [dbo].[Schedule]
(
    [ScheduleID] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(260) NOT NULL,
    [StartDate] DATETIME NOT NULL,
    [Flags] INT NOT NULL,
    [NextRunTime] DATETIME NULL,
    [LastRunTime] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [RecurrenceType] INT NULL,
    [MinutesInterval] INT NULL,
    [DaysInterval] INT NULL,
    [WeeksInterval] INT NULL,
    [DaysOfWeek] INT NULL,
    [DaysOfMonth] INT NULL,
    [Month] INT NULL,
    [MonthlyWeek] INT NULL,
    [State] INT NULL,
    [LastRunStatus] NVARCHAR(260) NULL,
    [ScheduledRunTimeout] INT NULL,
    [CreatedById] UNIQUEIDENTIFIER NOT NULL,
    [EventType] NVARCHAR(260) NOT NULL,
    [EventData] NVARCHAR(260) NULL,
    [Type] INT NOT NULL,
    [ConsistancyCheck] DATETIME NULL,
    [Path] NVARCHAR(260) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SecData
-- --------------------------------------------------
CREATE TABLE [dbo].[SecData]
(
    [SecDataID] UNIQUEIDENTIFIER NOT NULL,
    [PolicyID] UNIQUEIDENTIFIER NOT NULL,
    [AuthType] INT NOT NULL,
    [XmlDescription] NTEXT NOT NULL,
    [NtSecDescPrimary] IMAGE NOT NULL,
    [NtSecDescSecondary] NTEXT NULL,
    [NtSecDescState] INT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.Segment
-- --------------------------------------------------
CREATE TABLE [dbo].[Segment]
(
    [SegmentId] UNIQUEIDENTIFIER NOT NULL DEFAULT (newsequentialid()),
    [Content] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SegmentedChunk
-- --------------------------------------------------
CREATE TABLE [dbo].[SegmentedChunk]
(
    [ChunkId] UNIQUEIDENTIFIER NOT NULL DEFAULT (newsequentialid()),
    [SnapshotDataId] UNIQUEIDENTIFIER NOT NULL,
    [ChunkFlags] TINYINT NOT NULL,
    [ChunkName] NVARCHAR(260) NOT NULL,
    [ChunkType] INT NOT NULL,
    [Version] SMALLINT NOT NULL,
    [MimeType] NVARCHAR(260) NULL,
    [SegmentedChunkId] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ServerParametersInstance
-- --------------------------------------------------
CREATE TABLE [dbo].[ServerParametersInstance]
(
    [ServerParametersID] NVARCHAR(32) NOT NULL,
    [ParentID] NVARCHAR(32) NULL,
    [Path] NVARCHAR(425) NOT NULL,
    [CreateDate] DATETIME NOT NULL,
    [ModifiedDate] DATETIME NOT NULL,
    [Timeout] INT NOT NULL,
    [Expiration] DATETIME NOT NULL,
    [ParametersValues] IMAGE NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ServerUpgradeHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[ServerUpgradeHistory]
(
    [UpgradeID] BIGINT IDENTITY(1,1) NOT NULL,
    [ServerVersion] NVARCHAR(25) NULL,
    [User] NVARCHAR(128) NULL DEFAULT (suser_sname()),
    [DateTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.SnapshotData
-- --------------------------------------------------
CREATE TABLE [dbo].[SnapshotData]
(
    [SnapshotDataID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [ParamsHash] INT NULL,
    [QueryParams] NTEXT NULL,
    [EffectiveParams] NTEXT NULL,
    [Description] NVARCHAR(512) NULL,
    [DependsOnUser] BIT NULL,
    [PermanentRefcount] INT NOT NULL,
    [TransientRefcount] INT NOT NULL,
    [ExpirationDate] DATETIME NOT NULL,
    [PageCount] INT NULL,
    [HasDocMap] BIT NULL,
    [PaginationMode] SMALLINT NULL,
    [ProcessingFlags] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SubscriptionHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[SubscriptionHistory]
(
    [SubscriptionHistoryID] BIGINT IDENTITY(1,1) NOT NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [Type] TINYINT NULL,
    [StartTime] DATETIME NULL,
    [EndTime] DATETIME NULL,
    [Status] TINYINT NULL,
    [Message] NVARCHAR(1500) NULL,
    [Details] NVARCHAR(4000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SubscriptionResults
-- --------------------------------------------------
CREATE TABLE [dbo].[SubscriptionResults]
(
    [SubscriptionResultID] UNIQUEIDENTIFIER NOT NULL,
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [ExtensionSettingsHash] INT NOT NULL,
    [ExtensionSettings] NVARCHAR(MAX) NOT NULL,
    [SubscriptionResult] NVARCHAR(260) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Subscriptions
-- --------------------------------------------------
CREATE TABLE [dbo].[Subscriptions]
(
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [OwnerID] UNIQUEIDENTIFIER NOT NULL,
    [Report_OID] UNIQUEIDENTIFIER NOT NULL,
    [Locale] NVARCHAR(128) NOT NULL,
    [InactiveFlags] INT NOT NULL,
    [ExtensionSettings] NTEXT NULL,
    [ModifiedByID] UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate] DATETIME NOT NULL,
    [Description] NVARCHAR(512) NULL,
    [LastStatus] NVARCHAR(260) NULL,
    [EventType] NVARCHAR(260) NOT NULL,
    [MatchData] NTEXT NULL,
    [LastRunTime] DATETIME NULL,
    [Parameters] NTEXT NULL,
    [DataSettings] NTEXT NULL,
    [DeliveryExtension] NVARCHAR(260) NULL,
    [Version] INT NOT NULL,
    [ReportZone] INT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.SubscriptionsBeingDeleted
-- --------------------------------------------------
CREATE TABLE [dbo].[SubscriptionsBeingDeleted]
(
    [SubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [CreationDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UpgradeInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[UpgradeInfo]
(
    [Item] NVARCHAR(260) NOT NULL,
    [Status] NVARCHAR(512) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserContactInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[UserContactInfo]
(
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [DefaultEmailAddress] NVARCHAR(256) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserDataModelRole
-- --------------------------------------------------
CREATE TABLE [dbo].[UserDataModelRole]
(
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [DataModelRoleID] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Users
-- --------------------------------------------------
CREATE TABLE [dbo].[Users]
(
    [UserID] UNIQUEIDENTIFIER NOT NULL,
    [Sid] VARBINARY(85) NULL,
    [UserType] INT NOT NULL,
    [AuthType] INT NOT NULL,
    [UserName] NVARCHAR(260) NULL,
    [ServiceToken] NTEXT NULL,
    [Setting] NTEXT NULL,
    [ModifiedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.History_Notifications
-- --------------------------------------------------

CREATE TRIGGER [dbo].[History_Notifications] ON [dbo].[History]  
AFTER INSERT
AS 
   insert
      into [dbo].[Event]
      ([EventID], [EventType], [EventData], [TimeEntered]) 
      select NewID(), 'ReportHistorySnapshotCreated', inserted.[HistoryID], GETUTCDATE()
   from inserted

GO

-- --------------------------------------------------
-- TRIGGER dbo.HistoryDelete_SnapshotRefcount
-- --------------------------------------------------

CREATE TRIGGER [dbo].[HistoryDelete_SnapshotRefcount] ON [dbo].[History] 
AFTER DELETE
AS
   UPDATE [dbo].[SnapshotData]
   SET [PermanentRefcount] = [PermanentRefcount] - 1
   FROM [SnapshotData] SD INNER JOIN deleted D on SD.[SnapshotDataID] = D.[SnapshotDataID]

GO

-- --------------------------------------------------
-- TRIGGER dbo.ReportSchedule_Schedule
-- --------------------------------------------------

CREATE TRIGGER [dbo].[ReportSchedule_Schedule] ON [dbo].[ReportSchedule]
AFTER DELETE
AS

-- if the deleted row is the last connection between a schedule and a report delete the schedule
-- as long as the schedule is not a shared schedule (type == 0)
delete [Schedule] from 
    [Schedule] S inner join deleted D on S.[ScheduleID] = D.[ScheduleID] 
where
    S.[Type] != 0 and
    not exists (select * from [ReportSchedule] R where S.[ScheduleID] = R.[ScheduleID])

GO

-- --------------------------------------------------
-- TRIGGER dbo.Schedule_DeleteAgentJob
-- --------------------------------------------------

CREATE TRIGGER [dbo].[Schedule_DeleteAgentJob] ON [dbo].[Schedule]  
AFTER DELETE
AS 
DECLARE id_cursor CURSOR
FOR
    SELECT ScheduleID from deleted
OPEN id_cursor

DECLARE @next_id uniqueidentifier
FETCH NEXT FROM id_cursor INTO @next_id
WHILE (@@FETCH_STATUS <> -1) -- -1 == FETCH statement failed or the row was beyond the result set.
BEGIN
    if (@@FETCH_STATUS <> -2) -- - 2 == Row fetched is missing.
    BEGIN
        exec msdb.dbo.sp_delete_job @job_name = @next_id -- delete the schedule
    END
    FETCH NEXT FROM id_cursor INTO @next_id
END
CLOSE id_cursor
DEALLOCATE id_cursor

GO

-- --------------------------------------------------
-- TRIGGER dbo.Schedule_UpdateExpiration
-- --------------------------------------------------

CREATE TRIGGER [dbo].[Schedule_UpdateExpiration] ON [dbo].[Schedule]  
AFTER UPDATE
AS 
UPDATE
   EC
SET
   AbsoluteExpiration = I.NextRunTime
FROM
   [ReportServerTempDB].dbo.ExecutionCache AS EC
   INNER JOIN ReportSchedule AS RS ON EC.ReportID = RS.ReportID
   INNER JOIN inserted AS I ON RS.ScheduleID = I.ScheduleID AND RS.ReportAction = 3

GO

-- --------------------------------------------------
-- TRIGGER dbo.Subscription_delete_DataSource
-- --------------------------------------------------
-- end session tables

CREATE TRIGGER [dbo].[Subscription_delete_DataSource] ON [dbo].[Subscriptions]
AFTER DELETE 
AS
    delete DataSource from DataSource DS inner join deleted D on DS.SubscriptionID = D.SubscriptionID

GO

-- --------------------------------------------------
-- TRIGGER dbo.Subscription_delete_Schedule
-- --------------------------------------------------

CREATE TRIGGER [dbo].[Subscription_delete_Schedule] ON [dbo].[Subscriptions] 
AFTER DELETE 
AS
    delete ReportSchedule from ReportSchedule RS inner join deleted D on RS.SubscriptionID = D.SubscriptionID

GO

-- --------------------------------------------------
-- VIEW dbo.ExecutionLog
-- --------------------------------------------------
CREATE VIEW [dbo].[ExecutionLog]
AS
SELECT
    [InstanceName],
    [ReportID],
    [UserName],
    CASE ([RequestType])
        WHEN 1 THEN CONVERT(BIT, 1)
        ELSE CONVERT(BIT, 0)
    END AS [RequestType],
    [Format],
    [Parameters],
    [TimeStart],
    [TimeEnd],
    [TimeDataRetrieval],
    [TimeProcessing],
    [TimeRendering],
    CASE([Source])
        WHEN 6 THEN 3
        ELSE [Source]
    END AS Source,      -- Session source doesn't exist in yukon, mark source as snapshot
                        -- for in-session requests
    [Status],
    [ByteCount],
    [RowCount]
FROM [ExecutionLogStorage] WITH (NOLOCK)
WHERE [ReportAction] = 1 -- Backwards compatibility log only contains render requests

GO

-- --------------------------------------------------
-- VIEW dbo.ExecutionLog2
-- --------------------------------------------------

CREATE VIEW [dbo].[ExecutionLog2]
AS
SELECT 
	InstanceName, 
	COALESCE(C.Path, 'Unknown') AS ReportPath, 
	UserName,
	ExecutionId, 
	CASE(RequestType)
		WHEN 0 THEN 'Interactive'
		WHEN 1 THEN 'Subscription'
		ELSE 'Unknown'
		END AS RequestType, 
	-- SubscriptionId, 
	Format, 
	Parameters, 
	CASE(ReportAction)		
		WHEN 1 THEN 'Render'
		WHEN 2 THEN 'BookmarkNavigation'
		WHEN 3 THEN 'DocumentMapNavigation'
		WHEN 4 THEN 'DrillThrough'
		WHEN 5 THEN 'FindString'
		WHEN 6 THEN 'GetDocumentMap'
		WHEN 7 THEN 'Toggle'
		WHEN 8 THEN 'Sort'
		ELSE 'Unknown'
		END AS ReportAction,
	TimeStart, 
	TimeEnd, 
	TimeDataRetrieval, 
	TimeProcessing, 
	TimeRendering,
	CASE(Source)
		WHEN 1 THEN 'Live'
		WHEN 2 THEN 'Cache'
		WHEN 3 THEN 'Snapshot' 
		WHEN 4 THEN 'History'
		WHEN 5 THEN 'AdHoc'
		WHEN 6 THEN 'Session'
		WHEN 7 THEN 'Rdce'
		ELSE 'Unknown'
		END AS Source,
	Status,
	ByteCount,
	[RowCount],
	AdditionalInfo
FROM ExecutionLogStorage EL WITH(NOLOCK)
LEFT OUTER JOIN Catalog C WITH(NOLOCK) ON (EL.ReportID = C.ItemID)

GO

-- --------------------------------------------------
-- VIEW dbo.ExecutionLog3
-- --------------------------------------------------
CREATE VIEW [dbo].[ExecutionLog3]
AS
SELECT
    InstanceName,
    COALESCE(CASE(ReportAction)
        WHEN 11 THEN AdditionalInfo.value('(AdditionalInfo/SourceReportUri)[1]', 'nvarchar(max)')
        ELSE C.Path
        END, 'Unknown') AS ItemPath,
    UserName,
    ExecutionId,
    CASE(RequestType)
        WHEN 0 THEN 'Interactive'
        WHEN 1 THEN 'Subscription'
        WHEN 2 THEN 'Refresh Cache'
        ELSE 'Unknown'
        END AS RequestType,
    -- SubscriptionId,
    Format,
    Parameters,
    CASE(ReportAction)
        WHEN 1 THEN 'Render'
        WHEN 2 THEN 'BookmarkNavigation'
        WHEN 3 THEN 'DocumentMapNavigation'
        WHEN 4 THEN 'DrillThrough'
        WHEN 5 THEN 'FindString'
        WHEN 6 THEN 'GetDocumentMap'
        WHEN 7 THEN 'Toggle'
        WHEN 8 THEN 'Sort'
        WHEN 9 THEN 'Execute'
        WHEN 10 THEN 'RenderEdit'
        WHEN 11 THEN 'ExecuteDataShapeQuery'
        WHEN 12 THEN 'RenderMobileReport'
        WHEN 13 THEN 'ConceptualSchema'
        WHEN 14 THEN 'QueryData'
        WHEN 15 THEN 'ASModelStream'
        WHEN 16 THEN 'RenderExcelWorkbook'
        WHEN 17 THEN 'GetExcelWorkbookInfo'
        WHEN 18 THEN 'SaveToCatalog'
        WHEN 19 THEN 'DataRefresh'
        ELSE 'Unknown'
        END AS ItemAction,
    TimeStart,
    TimeEnd,
    TimeDataRetrieval,
    TimeProcessing,
    TimeRendering,
    CASE(Source)
        WHEN 1 THEN 'Live'
        WHEN 2 THEN 'Cache'
        WHEN 3 THEN 'Snapshot'
        WHEN 4 THEN 'History'
        WHEN 5 THEN 'AdHoc'
        WHEN 6 THEN 'Session'
        WHEN 7 THEN 'Rdce'
        ELSE 'Unknown'
        END AS Source,
    Status,
    ByteCount,
    [RowCount],
    AdditionalInfo
FROM ExecutionLogStorage EL WITH(NOLOCK)
LEFT OUTER JOIN Catalog C WITH(NOLOCK) ON (EL.ReportID = C.ItemID)

GO

-- --------------------------------------------------
-- VIEW dbo.ExtendedDataSets
-- --------------------------------------------------
CREATE VIEW [dbo].ExtendedDataSets
AS
SELECT
    ID, LinkID, [Name], ItemID
FROM DataSets
UNION ALL
SELECT
    ID, LinkID, [Name], ItemID
FROM [ReportServerTempDB].dbo.TempDataSets

GO

-- --------------------------------------------------
-- VIEW dbo.ExtendedDataSources
-- --------------------------------------------------
CREATE VIEW [dbo].ExtendedDataSources
AS
SELECT
    DSID, ItemID, SubscriptionID, Name, Extension, Link,
    CredentialRetrieval, Prompt, ConnectionString,
    OriginalConnectionString, OriginalConnectStringExpressionBased,
    UserName, Password, Flags, Version, DSIDNum
FROM DataSource
UNION ALL
SELECT
    DSID, ItemID, NULL as [SubscriptionID], Name, Extension, Link,
    CredentialRetrieval, Prompt, ConnectionString,
    OriginalConnectionString, OriginalConnectStringExpressionBased,
    UserName, Password, Flags, Version, null
FROM [ReportServerTempDB].dbo.TempDataSources

GO

