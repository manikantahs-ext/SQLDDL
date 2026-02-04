-- DDL Export
-- Server: 10.253.50.28
-- Database: MKTAPI
-- Exported: 2026-02-04T11:48:04.529887

USE MKTAPI;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_COMMON_CONTRACT_HEADER
-- --------------------------------------------------
create proc CLS_COMMON_CONTRACT_HEADER
(
@TODATE VARCHAR(11)
)
as

select * from pradnya..CLS_OWNER_VW

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FundTransfer_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FundTransfer_JV]
(
    [Fldauto] INT NOT NULL,
    [party_code] VARCHAR(50) NULL,
    [FromSegment] VARCHAR(50) NULL,
    [ToSegment] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [EntryDate] DATETIME NULL,
    [Flag] VARCHAR(50) NULL,
    [Remarks] VARCHAR(100) NULL,
    [VALID] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_POST_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_POST_DATA]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

