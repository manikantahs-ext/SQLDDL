-- DDL Export
-- Server: 10.253.33.89
-- Database: ImportDBCTCLNew
-- Exported: 2026-02-05T02:38:46.752171

USE ImportDBCTCLNew;
GO

-- --------------------------------------------------
-- TABLE dbo.BRANCHMasters$
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCHMasters$]
(
    [stBrTag] NVARCHAR(255) NULL,
    [stBrName] NVARCHAR(255) NULL,
    [stBrRegion] NVARCHAR(255) NULL,
    [stBrAddress1] NVARCHAR(255) NULL,
    [stBrAddress2] NVARCHAR(255) NULL,
    [stBrAddress3] NVARCHAR(255) NULL,
    [stBrCity] NVARCHAR(255) NULL,
    [stBrState] NVARCHAR(255) NULL,
    [stBrNation] NVARCHAR(255) NULL,
    [stBrZip] NVARCHAR(255) NULL,
    [stEmployee] NVARCHAR(255) NULL,
    [ConBranch] NVARCHAR(255) NULL,
    [ConPerson] NVARCHAR(255) NULL,
    [stBrSTD] NVARCHAR(255) NULL,
    [stBrContactNo] NVARCHAR(255) NULL,
    [stBrEmail] NVARCHAR(255) NULL,
    [stLocation] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_BR_ID$
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_BR_ID$]
(
    [BSE_BR_ID] FLOAT NULL,
    [SB# Tag] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ManagerSegment$
-- --------------------------------------------------
CREATE TABLE [dbo].[ManagerSegment$]
(
    [ID] FLOAT NULL,
    [ManagerID] NVARCHAR(255) NULL,
    [Segment] NVARCHAR(255) NULL,
    [LowerLimit] FLOAT NULL,
    [UpperLimit] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Other Than BSE$
-- --------------------------------------------------
CREATE TABLE [dbo].[Other Than BSE$]
(
    [BRID] FLOAT NULL,
    [CTCLServer] NVARCHAR(255) NULL,
    [ManagerID] NVARCHAR(255) NULL,
    [BranchCode] NVARCHAR(255) NULL,
    [SBTag] NVARCHAR(255) NULL,
    [OdinID] NVARCHAR(255) NULL,
    [PurposeofCtclID] NVARCHAR(255) NULL,
    [Segment] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BranchMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BranchMaster]
(
    [inSrNo] INT IDENTITY(1,1) NOT NULL,
    [stBrTag] VARCHAR(20) NOT NULL,
    [stBrName] VARCHAR(500) NULL,
    [stBrRegion] VARCHAR(500) NULL,
    [stBrAddress1] VARCHAR(500) NULL,
    [stBrAddress2] VARCHAR(500) NULL,
    [stBrAddress3] VARCHAR(500) NULL,
    [stBrCity] VARCHAR(500) NULL,
    [stBrState] VARCHAR(500) NULL,
    [stBrNation] VARCHAR(500) NULL,
    [stBrZip] VARCHAR(6) NULL,
    [stEmployee] VARCHAR(2) NULL,
    [ConBranch] VARCHAR(500) NULL,
    [ConPerson] VARCHAR(MAX) NULL,
    [stBrSTD] VARCHAR(6) NULL,
    [stBrContactNo] VARCHAR(100) NULL,
    [stBrEmail] VARCHAR(150) NULL,
    [stLocation] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ManagerSegment
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ManagerSegment]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ManagerID] INT NULL,
    [Segment] NVARCHAR(255) NULL,
    [LowerLimit] INT NULL,
    [UpperLimit] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBBranch_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBBranch_Master]
(
    [BRID] FLOAT NULL,
    [CTCLSever] NVARCHAR(255) NULL,
    [ManagerID] NVARCHAR(255) NULL,
    [BranchCode] NVARCHAR(255) NULL,
    [SBTag] NVARCHAR(255) NULL,
    [OdinID] NVARCHAR(255) NULL,
    [PurposeofCtclID] NVARCHAR(255) NULL,
    [Segment] NVARCHAR(255) NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBBSEBranch_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBBSEBranch_Master]
(
    [BRID] FLOAT NULL,
    [SBTag] NVARCHAR(255) NULL,
    [CreatedDate] DATETIME NULL
);

GO

