-- DDL Export
-- Server: 10.253.50.28
-- Database: NBFC
-- Exported: 2026-01-30T12:57:57.927103

USE NBFC;
GO

-- --------------------------------------------------
-- INDEX dbo.NHNT
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_CLI] ON [dbo].[NHNT] ([CLIENT_CODE])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP
-- --------------------------------------------------
  
CREATE PROC SP @spName VARCHAR(25)AS               
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------
  

  
CREATE PROC Tbl @TblName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD
-- --------------------------------------------------

CREATE  PROC [dbo].[V2_UPDATE_PASSWORD]
(
	@PASSWORD VARCHAR(512),
	@USERID VARCHAR(25),
	@DAYCOUNT INT	
)

AS


SET NOCOUNT ON

DECLARE @@FLDOLDPASSWORD TINYINT
DECLARE @@FLDAUTO INT
DECLARE @@PASSAUTO BIGINT
DECLARE @@OLDPASSSTRING VARCHAR(2000)
DECLARE @@OLDPASSCOUNT INT
DECLARE @@NEWPASSSTRING VARCHAR(2000)


/*
CREATE TABLE TBLUSERPASSHIST
(
	FLDAUTO BIGINT IDENTITY(1,1),
	FLDUSERID INT,
	FLDOLDPASSLISTING VARCHAR(2000)
)
*/


SELECT @@FLDOLDPASSWORD = ISNULL(FLDOLDPASSWORD,1) FROM TBLGLOBALPARAMS

IF ISNULL(@@FLDOLDPASSWORD,0) = 0
BEGIN
	SET @@FLDOLDPASSWORD = 1
END



SELECT @@FLDAUTO = ISNULL(FLDAUTO,0) FROM TBLPRADNYAUSERS
WHERE FLDUSERNAME = @USERID

IF ISNULL(@@FLDAUTO,0) = 0
BEGIN
	SELECT MSG = 'USER NOT FOUND'
	RETURN
END



SELECT @@OLDPASSSTRING = ISNULL(FLDOLDPASSLISTING,''), @@PASSAUTO = ISNULL(FLDAUTO,0)  FROM TBLUSERPASSHIST
WHERE FLDUSERID = @@FLDAUTO

IF ISNULL(@@OLDPASSSTRING,'') = ''
BEGIN
	SET @@OLDPASSSTRING = ''
END

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	SET @@PASSAUTO = 0
END


SELECT 
	@@OLDPASSCOUNT = COUNT(1)
FROM 
	FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE 
	SPLITTED_VALUE = @PASSWORD
	AND SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)


IF ISNULL(@@OLDPASSCOUNT,0) > 0
BEGIN
	SELECT MSG = 'PASSWORD ALREADY USED DURING LAST ' + CAST(@@FLDOLDPASSWORD AS VARCHAR) + ' ATTEMPTS.  PLEASE CHANGE'
	RETURN
END



UPDATE TBLPRADNYAUSERS 
SET 
	FLDPASSWORD = @PASSWORD,
	PWD_EXPIRY_DATE = (GETDATE()+ @DAYCOUNT)
WHERE 
	FLDAUTO = @@FLDAUTO

								
UPDATE TBLUSERCONTROLMASTER 
SET 
	FLDATTEMPTCNT = 0,
	FLDFIRSTLOGIN = 'N'
WHERE 
	TBLUSERCONTROLMASTER.FLDUSERID = @@FLDAUTO 



SET @@NEWPASSSTRING = ''


DECLARE @@STRING VARCHAR(100)

DECLARE vendor_cursor CURSOR FOR 

SELECT SPLITTED_VALUE
FROM 
	FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
WHERE  SNO > (
						SELECT 
								ISNULL(ISNULL(MAX(SNO),0) - @@FLDOLDPASSWORD, 0)
						FROM 
							FUN_SPLITSTRING (@@OLDPASSSTRING,'±')
					)
OPEN vendor_cursor

FETCH NEXT FROM vendor_cursor 
INTO @@STRING

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @@STRING + '±'
FETCH NEXT FROM vendor_cursor 
INTO @@STRING
END 

CLOSE vendor_cursor
DEALLOCATE vendor_cursor

	SET @@NEWPASSSTRING = @@NEWPASSSTRING + @PASSWORD 

IF ISNULL(@@PASSAUTO,0) = 0
BEGIN
	INSERT INTO TBLUSERPASSHIST 
	(FLDUSERID, FLDOLDPASSLISTING) 
	VALUES
	(@@FLDAUTO, @@NEWPASSSTRING)
END
ELSE
BEGIN
	UPDATE TBLUSERPASSHIST
	SET FLDOLDPASSLISTING = @@NEWPASSSTRING
	WHERE FLDAUTO = @@PASSAUTO
	AND FLDUSERID = @@FLDAUTO 
END

SELECT MSG = 'PASSWORD UPDATED SUCCESSFULLY'
RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw
-- --------------------------------------------------
    
CREATE PROC Vw @VwName VARCHAR(25)AS                   
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO

-- --------------------------------------------------
-- TABLE dbo.DEL_REASONCODE
-- --------------------------------------------------
CREATE TABLE [dbo].[DEL_REASONCODE]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [SLIPFORMAT] VARCHAR(20) NULL,
    [FROMACCOUNT] VARCHAR(16) NULL,
    [TOACCOUNT] VARCHAR(16) NULL,
    [REASONCODE] VARCHAR(2) NULL,
    [REASONDESC] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mine
-- --------------------------------------------------
CREATE TABLE [dbo].[mine]
(
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Address1] CHAR(100) NULL,
    [Address2] CHAR(100) NULL,
    [City] CHAR(20) NULL,
    [State] CHAR(15) NULL,
    [Nation] CHAR(15) NULL,
    [Zip] CHAR(10) NULL,
    [Fax] CHAR(15) NULL,
    [Phone1] CHAR(15) NULL,
    [Phone2] CHAR(15) NULL,
    [Reg_No] CHAR(30) NULL,
    [Registered] BIT NOT NULL,
    [Main_Sub] CHAR(1) NULL,
    [Email] CHAR(50) NULL,
    [Com_Perc] MONEY NULL,
    [branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NHNT
-- --------------------------------------------------
CREATE TABLE [dbo].[NHNT]
(
    [CLIENT_CODE] NVARCHAR(255) NULL,
    [NISE_PARTY_CODE] NVARCHAR(255) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [TYPE] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SUBBROKERS
-- --------------------------------------------------
CREATE TABLE [dbo].[SUBBROKERS]
(
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(50) NULL,
    [Address1] CHAR(100) NULL,
    [Address2] CHAR(100) NULL,
    [City] CHAR(20) NULL,
    [State] CHAR(15) NULL,
    [Nation] CHAR(15) NULL,
    [Zip] CHAR(10) NULL,
    [Fax] CHAR(15) NULL,
    [Phone1] CHAR(15) NULL,
    [Phone2] CHAR(15) NULL,
    [Reg_No] CHAR(30) NULL,
    [Registered] BIT NOT NULL,
    [Main_Sub] CHAR(1) NULL,
    [Email] CHAR(50) NULL,
    [Com_Perc] MONEY NULL,
    [branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.AUDIT_MARGIN_VIEW
-- --------------------------------------------------


CREATE VIEW [dbo].[AUDIT_MARGIN_VIEW]
AS
SELECT PARTY_CODE,MARGIN_DATE as MDATE, MARGIN=CASE WHEN MTOM < 0 THEN ABS(MTOM) ELSE 0 END + VARAMT FROM MSAJAG.DBO.TBL_MG02

GO

