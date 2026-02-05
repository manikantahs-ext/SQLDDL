-- DDL Export
-- Server: 10.253.33.91
-- Database: AUDIT_DB
-- Exported: 2026-02-05T12:29:05.212934

USE AUDIT_DB;
GO

-- --------------------------------------------------
-- INDEX dbo.LEDGER_TRIG
-- --------------------------------------------------
CREATE CLUSTERED INDEX [CX__LEDGER_TRIG] ON [dbo].[LEDGER_TRIG] ([UPDDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.trigger_audit
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_trigger_audit] ON [dbo].[trigger_audit] ([action_time])

GO

-- --------------------------------------------------
-- TABLE dbo.LEDGER_TRIG
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER_TRIG]
(
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NULL,
    [edt] DATETIME NULL,
    [lno] INT NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [vno1] VARCHAR(12) NULL,
    [refno] CHAR(12) NULL,
    [balamt] MONEY NOT NULL,
    [NoDays] INT NULL,
    [cdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [BookType] CHAR(2) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [pdt] DATETIME NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [actnodays] INT NULL,
    [narration] VARCHAR(234) NULL,
    [COMP_NAME] VARCHAR(50) NULL,
    [LOGIN_NAME] NVARCHAR(255) NULL DEFAULT (suser_name()),
    [UPDDATE] DATETIME2 NULL,
    [DBACTION] VARCHAR(20) NULL,
    [SNO] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trigger_audit
-- --------------------------------------------------
CREATE TABLE [dbo].[trigger_audit]
(
    [database_name] VARCHAR(125) NOT NULL,
    [table_name] VARCHAR(125) NOT NULL,
    [action_type] VARCHAR(20) NULL,
    [action_time] DATETIME2 NOT NULL DEFAULT (sysdatetime()),
    [original_login_name] VARCHAR(125) NULL DEFAULT (original_login()),
    [effective_login_name] VARCHAR(125) NULL DEFAULT (suser_name()),
    [client_app_name] VARCHAR(255) NULL,
    [client_host_name] VARCHAR(255) NULL,
    [session_id] INT NULL,
    [identity_min] BIGINT NULL,
    [identity_max] BIGINT NULL,
    [remarks] NVARCHAR(255) NULL
);

GO

