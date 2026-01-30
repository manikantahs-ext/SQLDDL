-- DDL Export
-- Server: 10.253.50.28
-- Database: bo_table_copy
-- Exported: 2026-01-30T12:37:59.163938

USE bo_table_copy;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.StartJob
-- --------------------------------------------------
CREATE PROC StartJob
AS
EXEC msdb.dbo.sp_start_job N'test_multiserver';

GO

-- --------------------------------------------------
-- PROCEDURE dbo.testinsert
-- --------------------------------------------------
create procedure testinsert
AS

BEGIN 

insert test_job
SELECT getdate()

--create table test_job
--(
--ID int identity(1,1),
--date_exec DATETIME
--)


END

GO

-- --------------------------------------------------
-- TABLE dbo.test_job
-- --------------------------------------------------
CREATE TABLE [dbo].[test_job]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [date_exec] DATETIME NULL
);

GO

