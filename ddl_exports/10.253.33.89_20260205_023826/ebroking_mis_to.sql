-- DDL Export
-- Server: 10.253.33.89
-- Database: ebroking_mis_to
-- Exported: 2026-02-05T02:38:43.586015

USE ebroking_mis_to;
GO

-- --------------------------------------------------
-- TABLE dbo.mis_to_backup_prashant
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_to_backup_prashant]
(
    [Company] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Dealer] VARCHAR(20) NULL,
    [Region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [Sub_broker] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [party_name] VARCHAR(100) NULL,
    [B2C] CHAR(1) NULL,
    [Ebrok_Cli] CHAR(1) NULL,
    [No_Of_trade] INT NULL,
    [Terminal_id] VARCHAR(10) NULL,
    [Product] VARCHAR(20) NULL,
    [Turnover] MONEY NULL,
    [brokerage] MONEY NULL,
    [TO_Trd_Fut] MONEY NULL,
    [TO_Del_Opt] MONEY NULL,
    [BK_Trd_Fut] MONEY NULL,
    [BK_Del_Opt] MONEY NULL,
    [ManagerIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mis_to_backup_prashant_pp
-- --------------------------------------------------
CREATE TABLE [dbo].[mis_to_backup_prashant_pp]
(
    [Company] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [Dealer] VARCHAR(20) NULL,
    [Region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [Sub_broker] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [party_name] VARCHAR(100) NULL,
    [B2C] CHAR(1) NULL,
    [Ebrok_Cli] CHAR(1) NULL,
    [No_Of_trade] INT NULL,
    [Terminal_id] VARCHAR(10) NULL,
    [Product] VARCHAR(20) NULL,
    [Turnover] MONEY NULL,
    [brokerage] MONEY NULL,
    [TO_Trd_Fut] MONEY NULL,
    [TO_Del_Opt] MONEY NULL,
    [BK_Trd_Fut] MONEY NULL,
    [BK_Del_Opt] MONEY NULL,
    [ManagerIP] VARCHAR(20) NULL
);

GO

