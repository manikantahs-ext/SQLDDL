-- DDL Export
-- Server: 10.253.50.28
-- Database: ReportServerTempDB
-- Exported: 2026-01-30T12:58:00.848560

USE ReportServerTempDB;
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
-- FOREIGN_KEY dbo.TempDataSets
-- --------------------------------------------------
ALTER TABLE [dbo].[TempDataSets] ADD CONSTRAINT [FK_DataSetItemID] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[TempCatalog] ([TempCatalogID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.TempDataSources
-- --------------------------------------------------
ALTER TABLE [dbo].[TempDataSources] ADD CONSTRAINT [FK_DataSourceItemID] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[TempCatalog] ([TempCatalogID])

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
-- INDEX dbo.ContentCache
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ContentCache] ON [dbo].[ContentCache] ([CatalogItemID], [ParamsHash], [ContentType])

GO

-- --------------------------------------------------
-- INDEX dbo.ContentCache
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ContentCache_ExpirationDate] ON [dbo].[ContentCache] ([ExpirationDate])

GO

-- --------------------------------------------------
-- INDEX dbo.ExecutionCache
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_CacheLookup] ON [dbo].[ExecutionCache] ([ReportID], [ParamsHash], [AbsoluteExpiration]) INCLUDE ([SnapshotDataID])

GO

-- --------------------------------------------------
-- INDEX dbo.ExecutionCache
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IX_ExecutionCache] ON [dbo].[ExecutionCache] ([AbsoluteExpiration], [ReportID], [SnapshotDataID])

GO

-- --------------------------------------------------
-- INDEX dbo.ExecutionCache
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ExecutionCacheLastUsed] ON [dbo].[ExecutionCache] ([ReportID], [AbsoluteExpiration], [LastUsedTime], [ExecutionCacheID])

GO

-- --------------------------------------------------
-- INDEX dbo.ExecutionCache
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SnapshotDataID] ON [dbo].[ExecutionCache] ([SnapshotDataID])

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
-- INDEX dbo.SessionData
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IDX_SessionData] ON [dbo].[SessionData] ([SessionID])

GO

-- --------------------------------------------------
-- INDEX dbo.SessionData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_EditSessionID] ON [dbo].[SessionData] ([EditSessionID])

GO

-- --------------------------------------------------
-- INDEX dbo.SessionData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SessionCleanup] ON [dbo].[SessionData] ([Expiration])

GO

-- --------------------------------------------------
-- INDEX dbo.SessionData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SessionSnapshotID] ON [dbo].[SessionData] ([SnapshotDataID])

GO

-- --------------------------------------------------
-- INDEX dbo.SessionLock
-- --------------------------------------------------
CREATE UNIQUE CLUSTERED INDEX [IDX_SessionLock] ON [dbo].[SessionLock] ([SessionID])

GO

-- --------------------------------------------------
-- INDEX dbo.SnapshotData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IS_SnapshotExpiration] ON [dbo].[SnapshotData] ([PermanentRefcount], [ExpirationDate])

GO

-- --------------------------------------------------
-- INDEX dbo.SnapshotData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_SnapshotCleaning] ON [dbo].[SnapshotData] ([PermanentRefcount], [TransientRefcount]) INCLUDE ([Machine])

GO

-- --------------------------------------------------
-- INDEX dbo.SnapshotData
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_SnapshotData] ON [dbo].[SnapshotData] ([SnapshotDataID], [ParamsHash])

GO

-- --------------------------------------------------
-- INDEX dbo.TempCatalog
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Cleanup] ON [dbo].[TempCatalog] ([ExpirationTime])

GO

-- --------------------------------------------------
-- INDEX dbo.TempCatalog
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UNIQ_TempCatalogID] ON [dbo].[TempCatalog] ([TempCatalogID])

GO

-- --------------------------------------------------
-- INDEX dbo.TempDataSets
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataSetLinkID] ON [dbo].[TempDataSets] ([LinkID])

GO

-- --------------------------------------------------
-- INDEX dbo.TempDataSets
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_TempDataSet_ItemID_Name] ON [dbo].[TempDataSets] ([ItemID], [Name])

GO

-- --------------------------------------------------
-- INDEX dbo.TempDataSources
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DataSourceItemID] ON [dbo].[TempDataSources] ([ItemID])

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
-- PK_UNIQUE dbo.ContentCache
-- --------------------------------------------------
ALTER TABLE [dbo].[ContentCache] ADD CONSTRAINT [PK_ContentCache] PRIMARY KEY ([ContentCacheID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DBUpgradeHistory
-- --------------------------------------------------
ALTER TABLE [dbo].[DBUpgradeHistory] ADD CONSTRAINT [PK_DBUpgradeHistory] PRIMARY KEY ([UpgradeID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ExecutionCache
-- --------------------------------------------------
ALTER TABLE [dbo].[ExecutionCache] ADD CONSTRAINT [PK_ExecutionCache] PRIMARY KEY ([ExecutionCacheID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PersistedStream
-- --------------------------------------------------
ALTER TABLE [dbo].[PersistedStream] ADD CONSTRAINT [PK_PersistedStream] PRIMARY KEY ([SessionID], [Index])

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
-- PK_UNIQUE dbo.TempCatalog
-- --------------------------------------------------
ALTER TABLE [dbo].[TempCatalog] ADD CONSTRAINT [PK_TempCatalog] PRIMARY KEY ([EditSessionID], [ContextPath])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TempCatalog
-- --------------------------------------------------
ALTER TABLE [dbo].[TempCatalog] ADD CONSTRAINT [UNIQ_TempCatalogID] UNIQUE ([TempCatalogID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TempDataSets
-- --------------------------------------------------
ALTER TABLE [dbo].[TempDataSets] ADD CONSTRAINT [PK_TempDataSet] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TempDataSources
-- --------------------------------------------------
ALTER TABLE [dbo].[TempDataSources] ADD CONSTRAINT [PK_DataSource] PRIMARY KEY ([DSID])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetDBVersion
-- --------------------------------------------------

    CREATE PROCEDURE [dbo].[GetDBVersion]
    @DBVersion nvarchar(32) OUTPUT
    AS
    SET @DBVersion = (select top(1) [DbVersion]  from [dbo].[DBUpgradeHistory])

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
-- TABLE dbo.ContentCache
-- --------------------------------------------------
CREATE TABLE [dbo].[ContentCache]
(
    [ContentCacheID] BIGINT IDENTITY(1,1) NOT NULL,
    [CatalogItemID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [ParamsHash] INT NULL,
    [EffectiveParams] NVARCHAR(MAX) NULL,
    [ContentType] NVARCHAR(256) NULL,
    [ExpirationDate] DATETIME NOT NULL,
    [Version] SMALLINT NULL,
    [Content] VARBINARY(MAX) NULL
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
-- TABLE dbo.ExecutionCache
-- --------------------------------------------------
CREATE TABLE [dbo].[ExecutionCache]
(
    [ExecutionCacheID] UNIQUEIDENTIFIER NOT NULL,
    [ReportID] UNIQUEIDENTIFIER NOT NULL,
    [ExpirationFlags] INT NOT NULL,
    [AbsoluteExpiration] DATETIME NULL,
    [RelativeExpiration] INT NULL,
    [SnapshotDataID] UNIQUEIDENTIFIER NOT NULL,
    [LastUsedTime] DATETIME NOT NULL DEFAULT (getdate()),
    [ParamsHash] INT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.PersistedStream
-- --------------------------------------------------
CREATE TABLE [dbo].[PersistedStream]
(
    [SessionID] VARCHAR(32) NOT NULL,
    [Index] INT NOT NULL,
    [Content] IMAGE NULL,
    [Name] NVARCHAR(260) NULL,
    [MimeType] NVARCHAR(260) NULL,
    [Extension] NVARCHAR(260) NULL,
    [Encoding] NVARCHAR(260) NULL,
    [Error] NVARCHAR(512) NULL,
    [RefCount] INT NOT NULL,
    [ExpirationDate] DATETIME NOT NULL
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
    [Machine] NVARCHAR(512) NOT NULL,
    [SegmentedChunkId] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SessionData
-- --------------------------------------------------
CREATE TABLE [dbo].[SessionData]
(
    [SessionID] VARCHAR(32) NOT NULL,
    [CompiledDefinition] UNIQUEIDENTIFIER NULL,
    [SnapshotDataID] UNIQUEIDENTIFIER NULL,
    [IsPermanentSnapshot] BIT NULL,
    [ReportPath] NVARCHAR(464) NULL,
    [Timeout] INT NOT NULL,
    [AutoRefreshSeconds] INT NULL,
    [Expiration] DATETIME NOT NULL,
    [ShowHideInfo] IMAGE NULL,
    [DataSourceInfo] IMAGE NULL,
    [OwnerID] UNIQUEIDENTIFIER NOT NULL,
    [EffectiveParams] NTEXT NULL,
    [CreationTime] DATETIME NOT NULL,
    [HasInteractivity] BIT NULL,
    [SnapshotExpirationDate] DATETIME NULL,
    [HistoryDate] DATETIME NULL,
    [PageHeight] FLOAT NULL,
    [PageWidth] FLOAT NULL,
    [TopMargin] FLOAT NULL,
    [BottomMargin] FLOAT NULL,
    [LeftMargin] FLOAT NULL,
    [RightMargin] FLOAT NULL,
    [AwaitingFirstExecution] BIT NULL,
    [EditSessionID] VARCHAR(32) NULL,
    [DataSetInfo] VARBINARY(MAX) NULL,
    [SitePath] NVARCHAR(440) NULL,
    [SiteZone] INT NOT NULL DEFAULT ((0)),
    [ReportDefinitionPath] NVARCHAR(464) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SessionLock
-- --------------------------------------------------
CREATE TABLE [dbo].[SessionLock]
(
    [SessionID] VARCHAR(32) NOT NULL,
    [LockVersion] INT NOT NULL DEFAULT ((0))
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
    [Machine] NVARCHAR(512) NOT NULL,
    [PaginationMode] SMALLINT NULL,
    [ProcessingFlags] INT NULL,
    [IsCached] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempCatalog
-- --------------------------------------------------
CREATE TABLE [dbo].[TempCatalog]
(
    [EditSessionID] VARCHAR(32) NOT NULL,
    [TempCatalogID] UNIQUEIDENTIFIER NOT NULL,
    [ContextPath] NVARCHAR(425) NOT NULL,
    [Name] NVARCHAR(425) NOT NULL,
    [Content] VARBINARY(MAX) NULL,
    [Description] NVARCHAR(MAX) NULL,
    [Intermediate] UNIQUEIDENTIFIER NULL,
    [IntermediateIsPermanent] BIT NOT NULL DEFAULT ((0)),
    [Property] NVARCHAR(MAX) NULL,
    [Parameter] NVARCHAR(MAX) NULL,
    [OwnerID] UNIQUEIDENTIFIER NOT NULL,
    [CreationTime] DATETIME NOT NULL,
    [ExpirationTime] DATETIME NOT NULL,
    [DataCacheHash] VARBINARY(64) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempDataSets
-- --------------------------------------------------
CREATE TABLE [dbo].[TempDataSets]
(
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
    [LinkID] UNIQUEIDENTIFIER NULL,
    [Name] NVARCHAR(260) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempDataSources
-- --------------------------------------------------
CREATE TABLE [dbo].[TempDataSources]
(
    [DSID] UNIQUEIDENTIFIER NOT NULL,
    [ItemID] UNIQUEIDENTIFIER NOT NULL,
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
    [Version] INT NOT NULL
);

GO

