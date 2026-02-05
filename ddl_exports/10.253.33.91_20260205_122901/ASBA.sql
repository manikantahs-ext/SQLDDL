-- DDL Export
-- Server: 10.253.33.91
-- Database: ASBA
-- Exported: 2026-02-05T12:29:05.181682

USE ASBA;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.LEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[LEDGER] ADD CONSTRAINT [PK1_LEDGER] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- TABLE dbo.LEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

