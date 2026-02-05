-- DDL Export
-- Server: 10.254.33.28
-- Database: ReplicatedData
-- Exported: 2026-02-05T11:26:40.510861

USE ReplicatedData;
GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDX_PGTransaction_UPIRefID] ON [dbo].[PG_Transaction] ([UPIRefID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [indx_PG_Transaction_Aggregator_ID] ON [dbo].[PG_Transaction] ([Aggregator_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [INDX_PG_Transaction_ModifiedBy] ON [dbo].[PG_Transaction] ([ModifiedBy]) INCLUDE ([Aggregator_ID], [TransReq_dtm], [TransResp_dtm], [Bank_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [indx_PG_Transaction_Remarks] ON [dbo].[PG_Transaction] ([Remarks])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [indx_PG_Transaction_Segment_ID_Status_CreatedOn] ON [dbo].[PG_Transaction] ([Segment_ID], [Status], [CreatedOn]) INCLUDE ([Product_ID], [InternalRef_No], [Aggregator_ID], [Bank_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [INDX_PG_Transaction_Status_Client_Code_TransReq_dtm_SegmentCode] ON [dbo].[PG_Transaction] ([Status], [Client_Code], [TransReq_dtm], [SegmentCode]) INCLUDE ([Amount], [TransResp_dtm], [MerchantTxnId])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [INDX_PG_Transaction_Status_CreatedOn] ON [dbo].[PG_Transaction] ([Status], [CreatedOn]) INCLUDE ([Segment_ID], [Product_ID], [InternalRef_No], [Aggregator_ID], [Bank_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_missing_PG_Transaction_Client_Code_InternalRef_No] ON [dbo].[PG_Transaction] ([Client_Code], [InternalRef_No])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_missing_PG_Transaction_InternalRef_No] ON [dbo].[PG_Transaction] ([InternalRef_No])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PG_Transaction_SMSId] ON [dbo].[PG_Transaction] ([SMSId])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PG_Transaction_Status_TransReq_dtm] ON [dbo].[PG_Transaction] ([Status], [TransReq_dtm]) INCLUDE ([Aggregator_ID], [Bank_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.PG_Transaction
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_PG_Transaction_TransReq_dtm] ON [dbo].[PG_Transaction] ([TransReq_dtm]) INCLUDE ([InternalRef_No], [Aggregator_ID], [Status], [ModifiedBy], [Bank_ID], [VerificationStatus])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.PG_Transaction
-- --------------------------------------------------
ALTER TABLE [dbo].[PG_Transaction] ADD CONSTRAINT [PK_PG_Transaction] PRIMARY KEY ([Trans_ID])

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
-- TABLE dbo.PG_Transaction
-- --------------------------------------------------
CREATE TABLE [dbo].[PG_Transaction]
(
    [Trans_ID] INT IDENTITY(1,1) NOT NULL,
    [Client_Code] VARCHAR(100) NOT NULL,
    [Segment_ID] INT NOT NULL,
    [Product_ID] INT NOT NULL,
    [Amount] DECIMAL(18, 2) NULL,
    [InternalRef_No] VARCHAR(50) NULL,
    [BankRef_No] VARCHAR(100) NULL,
    [Aggregator_ID] INT NOT NULL,
    [TPV] VARCHAR(10) NULL,
    [Status] VARCHAR(100) NOT NULL,
    [TransReq_dtm] DATETIME NULL,
    [TransResp_dtm] DATETIME NULL,
    [Reconciliation] BIT NOT NULL,
    [CreatedBy] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(200) NULL,
    [ModifiedOn] DATETIME NULL,
    [Bank_ID] INT NULL,
    [RequestString] VARCHAR(MAX) NULL,
    [ResponseString] VARCHAR(MAX) NULL,
    [Remarks] VARCHAR(200) NULL,
    [IPAddress] VARCHAR(50) NULL,
    [FTMappingID] INT NULL,
    [AccountNo] VARCHAR(50) NULL,
    [GroupID] VARCHAR(10) NULL,
    [SegmentCode] VARCHAR(100) NULL,
    [MerchantTxnId] VARCHAR(50) NULL,
    [SMSId] VARCHAR(50) NULL,
    [VerificationStatus] VARCHAR(20) NULL,
    [ErrorCode] VARCHAR(20) NULL,
    [RespAccountNo] VARCHAR(50) NULL,
    [RespBankName] VARCHAR(200) NULL,
    [UPIRefID] VARCHAR(50) NULL,
    [SMSDT] DATETIME NULL,
    [SMSFlag] VARCHAR(1) NULL,
    [EmailDT] DATETIME NULL,
    [EmailFlag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PAYIN
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PAYIN]
(
    [CL_CODE] VARCHAR(10) NULL,
    [CLIENT_NAME] VARCHAR(100) NULL,
    [CLIENT_STATE] VARCHAR(50) NULL,
    [CITY_ASPER_PINCODE_CDSL] VARCHAR(500) NULL,
    [TIER] VARCHAR(3) NULL,
    [SEX] CHAR(1) NULL,
    [AGE] INT NULL,
    [CLIENTFLAG] VARCHAR(50) NULL,
    [OCCUPATION] VARCHAR(500) NULL,
    [ACOPEN_DATE] VARCHAR(11) NULL,
    [TRANS_ID] INT NOT NULL,
    [CLIENT_CODE] VARCHAR(100) NOT NULL,
    [SEGMENT_ID] INT NOT NULL,
    [PRODUCT_ID] INT NOT NULL,
    [AMOUNT] DECIMAL(18, 2) NULL,
    [AGGREGATOR_ID] INT NOT NULL,
    [TRANSREQ_DTM] DATETIME NULL,
    [TRANSRESP_DTM] DATETIME NULL,
    [RECONCILIATION] BIT NOT NULL,
    [CREATEDON] DATETIME NULL,
    [MODIFIEDON] DATETIME NULL,
    [BANK_ID] INT NULL,
    [REMARKS] VARCHAR(200) NULL,
    [FTMAPPINGID] INT NULL,
    [ACCOUNTNO] VARCHAR(50) NULL,
    [SEGMENTCODE] VARCHAR(100) NULL,
    [VERIFICATIONSTATUS] VARCHAR(20) NULL,
    [ERRORCODE] VARCHAR(20) NULL,
    [RESPBANKNAME] VARCHAR(200) NULL
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

