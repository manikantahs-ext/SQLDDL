-- DDL Export
-- Server: 10.253.50.28
-- Database: InMemory_Test
-- Exported: 2026-02-01T02:30:21.512788

USE InMemory_Test;
GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Client_Details_Mem
-- --------------------------------------------------
ALTER TABLE [dbo].[Client_Details_Mem] ADD CONSTRAINT [PK__Client_D__DF7376E5E96C13FA] PRIMARY KEY ([Cl_Code])

GO

-- --------------------------------------------------
-- TABLE dbo.Client_Details_Mem
-- --------------------------------------------------
CREATE TABLE [dbo].[Client_Details_Mem]
(
    [Cl_Code] VARCHAR(10) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Long_Name] VARCHAR(100) NULL,
    [Cl_Type] VARCHAR(3) NULL,
    [AC_Type] VARCHAR(10) NULL,
    [AC_Num] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.vw_INMem_Client_Details
-- --------------------------------------------------
CREATE VIEW vw_INMem_Client_Details
AS
SELECT Cl_Code, Branch_Cd, Long_Name, Cl_Type, AC_Type, AC_Num FROM MSAJAG.dbo.Client_Details WITH (NOLOCK)

GO

