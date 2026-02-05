-- DDL Export
-- Server: 10.254.33.27
-- Database: ACCOUNTFO_ARC
-- Exported: 2026-02-05T11:34:21.284497

USE ACCOUNTFO_ARC;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_diagramobjects
-- --------------------------------------------------

	CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B610BC6C43E] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GET_ACC_LEDGER2_FORMULA_BALANCES
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[CLS_GET_ACC_LEDGER2_FORMULA_BALANCES] 
	@FR_DATE VARCHAR(11),-- FROM DATE OF THE PERIOD 
	@EFFDATE VARCHAR(11),-- DATE FOR WHICH THE BALANCE IS REQUIRED  
	@PROCESS_CODE VARCHAR(10),-- PROCESS CODE FROM THE FORMULA MASTER  
	@REPORT_FORMULA VARCHAR(MAX),-- IN CASE NOT TO SET THE FORMULA AND GET THE SPECIFIEC FIELDS
	@EXCHANGE VARCHAR(10) = '',-- EXCHANGE
	@SEGMENT VARCHAR(50) = '',-- SEGMENT
	@REPORT_COLUMN VARCHAR(1000) = '', 
	@REPORT_GROUPING VARCHAR(1000) = '',
	@COSTCODE INT = 0,
	@TABLE_NAME  VARCHAR(1000) = '' 
	
AS
SELECT
	@REPORT_FORMULA = FORMULANAME
FROM FORMULA_MASTER
WHERE PROCESSCODE = @PROCESS_CODE

IF @EXCHANGE = '' BEGIN
SELECT
	@EXCHANGE = EXCHANGE
	,@SEGMENT = SEGMENT
FROM pradnya.OWNER
END

DECLARE @START_DATE VARCHAR(11)

IF LEN(@FR_DATE) = 10 SELECT
	@FR_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FR_DATE, 103), 109)

IF LEN(@EFFDATE) = 10 BEGIN
SELECT
	@EFFDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @EFFDATE, 103), 109)
END

SELECT
	@START_DATE = CONVERT(VARCHAR(11), SDTCUR, 109)
FROM PARAMETER
WHERE @EFFDATE BETWEEN SDTCUR
AND LDTCUR

DECLARE @MIN_BILL_DATE VARCHAR(11)
, @MAX_BILL_DATE VARCHAR(11)

DECLARE @servername varchar(20)='ANAND1.ACCOUNT.DBO'

SELECT
	@MIN_BILL_DATE = CONVERT(VARCHAR(11), MIN(VDT), 109)
	,@MAX_BILL_DATE = CONVERT(VARCHAR(11), MAX(VDT), 109)
FROM (SELECT TOP 2
		*
	FROM BILLPOSTED
	WHERE VDT <= @EFFDATE
	ORDER BY VDT DESC) A

CREATE TABLE #REPORT_DATA(CLTCODE VARCHAR(10)
, VDTBAL_OPBAL MONEY
, EDTBAL_OPBAL MONEY
, VDTBAL_DATES MONEY
, EDTBAL_DATES MONEY
, VDTBAL_DATES_CREDIT MONEY
, VDTBAL_DATES_DEBIT MONEY
, EDTBAL_DATES_CREDIT MONEY
, EDTBAL_DATES_DEBIT MONEY
, VDTBAL MONEY
, EDTBAL MONEY
, VDTBAL_RECEIPT MONEY
, T_DAY_BILL MONEY
, T1_DAY_BILL MONEY
, VDTBAL_BILL_DR MONEY
, VDTBAL_BILL_CR MONEY
, VDTBAL_NONBILL MONEY
, EDTBAL_RECEIPT MONEY
, EDTBAL_BILL_DR MONEY
, EDTBAL_BILL_CR MONEY
, EDTBAL_NONBILL MONEY
, FDT_RECEIPT MONEY
, FDT_CREDIT_BILLS MONEY
, FDT_DEBIT_BILLS MONEY
, FDT_CR MONEY
, FDT_DR MONEY
, MARGIN_BAL MONEY)

DECLARE @@SQL VARCHAR(MAX)

INSERT INTO #REPORT_DATA
	SELECT
		CLTCODE
		,VDTBAL_OPBAL = SUM(VDTBAL_OPBAL)
		,EDTBAL_OPBAL = SUM(EDTBAL_OPBAL)
		,VDTBAL_DATES = SUM(VDTBAL_DATES)
		,EDTBAL_DATES = SUM(EDTBAL_DATES)
		,VDTBAL_DATES_CREDIT = SUM(VDTBAL_DATES_CREDIT)
		,VDTBAL_DATES_DEBIT = SUM(VDTBAL_DATES_DEBIT)
		,EDTBAL_DATES_CREDIT = SUM(EDTBAL_DATES_CREDIT)
		,EDTBAL_DATES_DEBIT = SUM(VDTBAL_DATES_DEBIT)
		,VDTBAL = SUM(VDTBAL)
		,EDTBAL = SUM(EDTBAL)
		,VDTBAL_RECEIPT = SUM(VDTBAL_RECEIPT)
		,T_DAY_BILL = SUM(T_DAY_BILL)
		,T1_DAY_BILL = SUM(T1_DAY_BILL)
		,VDTBAL_BILL_DR = SUM(VDTBAL_BILL_DR)
		,VDTBAL_BILL_CR = SUM(VDTBAL_BILL_CR)
		,VDTBAL_NONBILL = SUM(VDTBAL_NONBILL)
		,EDTBAL_RECEIPT = SUM(EDTBAL_RECEIPT)
		,EDTBAL_BILL_DR = SUM(EDTBAL_BILL_DR)
		,EDTBAL_BILL_CR = SUM(EDTBAL_BILL_CR)
		,EDTBAL_NONBILL = SUM(EDTBAL_NONBILL)
		,FDT_RECEIPT = SUM(FDT_RECEIPT)
		,FDT_CREDIT_BILLS = SUM(FDT_CREDIT_BILLS)
		,FDT_DEBIT_BILLS = SUM(FDT_DEBIT_BILLS)
		,FDT_CR = SUM(FDT_CR)
		,FDT_DR = SUM(FDT_DR)
		,MARGIN_BAL = 0
	FROM (SELECT
			CLTCODE = L.CLTCODE
			,VDTBAL_OPBAL =
							CASE
								WHEN (VDT >= @START_DATE AND
									VDT < @FR_DATE) OR
									VTYP = 18 THEN SUM(CASE L.DRCR
										WHEN 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END
			,EDTBAL_OPBAL =
							CASE
								WHEN (EDT >= @START_DATE AND
									EDT < @FR_DATE) OR
									VTYP = 18 THEN SUM(CASE L.DRCR
										WHEN 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE THEN SUM(CASE L.DRCR
						WHEN 'C' THEN VAMT
						ELSE -VAMT
					END)
				ELSE 0
			END
			,VDTBAL_DATES =
							CASE
								WHEN VDT >= @FR_DATE AND
									VTYP <> 18 THEN SUM(CASE L.DRCR
										WHEN 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END
			,EDTBAL_DATES =
							CASE
								WHEN EDT >= @FR_DATE AND
									VTYP <> 18 AND
									EDT <= @EFFDATE + ' 23:59' THEN SUM(CASE L.DRCR
										WHEN 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END
			,VDTBAL_DATES_CREDIT =
									CASE
										WHEN VDT >= @FR_DATE AND
											VTYP <> 18 THEN SUM(CASE L.DRCR
												WHEN 'C' THEN VAMT
												ELSE 0
											END)
										ELSE 0
									END
			,VDTBAL_DATES_DEBIT =
									CASE
										WHEN VDT >= @FR_DATE AND
											VTYP <> 18 THEN SUM(CASE L.DRCR
												WHEN 'D' THEN VAMT
												ELSE 0
											END)
										ELSE 0
									END
			,EDTBAL_DATES_CREDIT =
									CASE
										WHEN EDT >= @FR_DATE AND
											EDT <= @EFFDATE + ' 23:59' AND
											VTYP <> 18 THEN SUM(CASE L.DRCR
												WHEN 'C' THEN VAMT
												ELSE 0
											END)
										ELSE 0
									END
			,EDTBAL_DATES_DEBIT =
									CASE
										WHEN EDT >= @FR_DATE AND
											EDT <= @EFFDATE + ' 23:59' AND
											VTYP <> 18 THEN SUM(CASE L.DRCR
												WHEN 'D' THEN VAMT
												ELSE 0
											END)
										ELSE 0
									END
			,VDTBAL =
						CASE
							WHEN VDT >= @START_DATE THEN SUM(CASE L.DRCR
									WHEN 'D' THEN VAMT
									ELSE -VAMT
								END)
							ELSE 0
						END
			,EDTBAL =
						CASE
							WHEN EDT >= @START_DATE AND
								EDT <= @EFFDATE + ' 23:59' THEN SUM(CASE L.DRCR
									WHEN 'D' THEN VAMT
									ELSE -VAMT
								END)
							ELSE 0
						END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE THEN SUM(CASE L.DRCR
						WHEN 'C' THEN VAMT
						ELSE -VAMT
					END)
				ELSE 0
			END
			,VDTBAL_RECEIPT =
								CASE
									WHEN VDT >= @START_DATE AND
										VTYP = 2 THEN SUM(VAMT)
									ELSE 0
								END
			,T_DAY_BILL =
							CASE
								WHEN VDT LIKE @MAX_BILL_DATE + '%' AND
									VTYP = 15 THEN SUM(CASE
										WHEN L.DRCR = 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END
			,T1_DAY_BILL =
							CASE
								WHEN VDT LIKE @MIN_BILL_DATE + '%' AND
									VTYP = 15 THEN SUM(CASE
										WHEN L.DRCR = 'D' THEN VAMT
										ELSE -VAMT
									END)
								ELSE 0
							END
			,VDTBAL_BILL_DR =
								CASE
									WHEN VDT >= @START_DATE AND
										VTYP = 15 AND
										L.DRCR = 'D' THEN SUM(VAMT)
									ELSE 0
								END
			,VDTBAL_BILL_CR =
								CASE
									WHEN VDT >= @START_DATE AND
										VTYP = 15 AND
										L.DRCR = 'C' THEN SUM(VAMT)
									ELSE 0
								END
			,VDTBAL_NONBILL =
								CASE
									WHEN VDT >= @START_DATE AND
										VTYP NOT IN (
										15
										, 2
										) THEN SUM(CASE L.DRCR
											WHEN 'D' THEN VAMT
											ELSE -VAMT
										END)
									ELSE 0
								END
			,EDTBAL_RECEIPT =
								CASE
									WHEN EDT >= @START_DATE AND
										EDT <= @EFFDATE + ' 23:59' AND
										VTYP = 2 THEN SUM(VAMT)
									ELSE 0
								END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE AND
					VTYP = 2 THEN SUM(-VAMT)
				ELSE 0
			END
			,EDTBAL_BILL_DR =
								CASE
									WHEN EDT >= @START_DATE AND
										EDT <= @EFFDATE + ' 23:59' AND
										VTYP = 15 AND
										L.DRCR = 'D' THEN SUM(VAMT)
									ELSE 0
								END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE AND
					VTYP = 15 AND
					L.DRCR = 'D' THEN SUM(-VAMT)
				ELSE 0
			END
			,EDTBAL_BILL_CR =
								CASE
									WHEN EDT >= @START_DATE AND
										EDT <= @EFFDATE + ' 23:59' AND
										VTYP = 15 AND
										L.DRCR = 'C' THEN SUM(VAMT)
									ELSE 0
								END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE AND
					VTYP = 15 AND
					L.DRCR = 'C' THEN SUM(-VAMT)
				ELSE 0
			END
			,EDTBAL_NONBILL =
								CASE
									WHEN EDT >= @START_DATE AND
										EDT <= @EFFDATE + ' 23:59' AND
										VTYP NOT IN (
										15
										, 2
										) THEN SUM(CASE L.DRCR
											WHEN 'D' THEN VAMT
											ELSE -VAMT
										END)
									ELSE 0
								END + CASE
				WHEN EDT >= @START_DATE AND
					VDT < @START_DATE THEN SUM(CASE L.DRCR
						WHEN 'C' THEN VAMT
						ELSE -VAMT
					END)
				ELSE 0
			END
			,FDT_RECEIPT =
							CASE
								WHEN EDT > @EFFDATE + ' 23:59' AND
									VDT <= @EFFDATE + ' 23:59' AND
									VTYP = 2 THEN SUM(VAMT)
								ELSE 0
							END
			,FDT_CREDIT_BILLS =
								CASE
									WHEN EDT > @EFFDATE + ' 23:59' AND
										VDT <= @EFFDATE + ' 23:59' AND
										VTYP = 15 AND
										L.DRCR = 'C' THEN SUM(VAMT)
									ELSE 0
								END
			,FDT_DEBIT_BILLS =
								CASE
									WHEN EDT > @EFFDATE + ' 23:59' AND
										VDT <= @EFFDATE + ' 23:59' AND
										VTYP = 15 AND
										L.DRCR = 'D' THEN SUM(VAMT)
									ELSE 0
								END
			,FDT_CR =
						CASE
							WHEN EDT > @EFFDATE + ' 23:59' AND
								VDT <= @EFFDATE + ' 23:59' AND
								L.DRCR = 'C' AND
								VTYP <> 2 THEN SUM(VAMT)
							ELSE 0
						END
			,FDT_DR =
						CASE
							WHEN EDT > @EFFDATE + ' 23:59' AND
								VDT <= @EFFDATE + ' 23:59' AND
								L.DRCR = 'D' AND
								VTYP <> 2 THEN SUM(VAMT)
							ELSE 0
						END
		FROM	LEDGER L (NOLOCK)
				,LEDGER2 L2 (NOLOCK)
				,#FORMULA_CLIENT_MASTER A
		WHERE A.CLTCODE = L.CLTCODE --AND SESSION_ID = @SESSIONID
		AND L.VNO = L2.VNO
		AND L.VTYP = L2.VTYPE
		AND L.BOOKTYPE = L2.BOOKTYPE
		AND L.LNO = L2.LNO
		AND L.CLTCODE = L2.CLTCODE
		AND COSTCODE = @COSTCODE
		AND (
		VDT >= @START_DATE
		OR EDT >= @START_DATE
		)
		AND VDT <= @EFFDATE + ' 23:59'
		GROUP BY	L.CLTCODE
					,VDT
					,EDT
					,VTYP
					,L.DRCR) A
	GROUP BY CLTCODE

--HAVING SUM(VDTBAL) <> 0 AND SUM(EDTBAL) <> 0
DECLARE @ML_BAL_REQ TINYINT

SELECT
	@ML_BAL_REQ = CHARINDEX('MARGIN_BAL', @REPORT_FORMULA)

IF @ML_BAL_REQ > 0 BEGIN
UPDATE RD
SET MARGIN_BAL = ML.AMOUNT
FROM #REPORT_DATA RD
, (SELECT
		PARTY_CODE
		,AMOUNT = SUM(CASE DRCR
			WHEN 'C' THEN AMOUNT
			ELSE -AMOUNT
		END)
	FROM MARGINLEDGER ML
	WHERE VDT >= @START_DATE
	AND VDT <= @EFFDATE + ' 23:59'
	GROUP BY PARTY_CODE) ML
WHERE RD.CLTCODE = PARTY_CODE
END

/*IF @REPORT_COLUMN = ''
BEGIN
	SET @@SQL = " SELECT "  
	SET @@SQL = @@SQL + " CLTCODE, "  
	SET @@SQL = @@SQL + " PARTY_NAME, "  
	SET @@SQL = @@SQL + " ENTITY_LEVEL,"  
	SET @@SQL = @@SQL + " ENTITY_CODE, "  
	SET @@SQL = @@SQL + @REPORT_FORMULA + ", EXCHANGE = '" + @EXCHANGE + "', SEGMENT = '" + @SEGMENT + "', SESSIONID = '" + @SESSIONID + "', POPULATE_DATE = GETDATE() "  
	SET @@SQL = @@SQL + " FROM "  
	SET @@SQL = @@SQL + " #REPORT_DATA"  
END
ELSE
BEGIN*/


IF @TABLE_NAME <> '' SET @@SQL = "INSERT INTO "+ @servername +'.'+@TABLE_NAME +" SELECT " ELSE SET @@SQL = " SELECT "

IF @REPORT_COLUMN <> '' SET @@SQL = @@SQL + @REPORT_COLUMN + ", "
SET @@SQL = @@SQL + @REPORT_FORMULA
SET @@SQL = @@SQL + " FROM "
SET @@SQL = @@SQL + " #REPORT_DATA R, #FORMULA_CLIENT_MASTER M"
SET @@SQL = @@SQL + " WHERE M.CLTCODE = R.CLTCODE "

IF @REPORT_GROUPING <> '' SET @@SQL = @@SQL + " GROUP BY " + @REPORT_GROUPING

--END

PRINT @@SQL
EXEC (@@SQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLS_GLLEDGER
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[CLS_GLLEDGER]
	@FR_DATE VARCHAR(11), /* AS ON DATE ENTERED BY USER */
	@VDT VARCHAR(11), /* AS ON DATE ENTERED BY USER */
	@FROM_GL_CODE VARCHAR(10),
	@TO_GL_CODE VARCHAR(10),
	@VIEWOPTION VARCHAR(10),
	@STATUSID VARCHAR(20), /* AS BROKER/BRANCH/CLIENT ETC. */
	@STATUSNAME VARCHAR(20), /* IN CASE OF BRANCH LOGIN BRANCHCODE */
	@SORTBYDATE VARCHAR(3), /* WHETHER REPORT IS BASED ON VDT OR EDT */
	@SHOWZEROBAL VARCHAR(1) = 'N', /* SHOW ZERO BAL   */
	@GRPCODE VARCHAR(20),
	@SHAREDB VARCHAR(20),
	@EXCHANGE VARCHAR(10),
	@SEGMENT VARCHAR(9),
	@TABLE_NAME VARCHAR(100),
	@BRANCHCODE VARCHAR(10) = '',
	@WITHOPENING BIT = 0,
	@SORT_BY VARCHAR(10) = 'ACCODE',
	@SHOW_MARGIN CHAR(1) = 'N'
	
AS

CREATE TABLE #FORMULA_CLIENT_MASTER
(
	CLTCODE VARCHAR(10) NOT NULL
)

ALTER TABLE #FORMULA_CLIENT_MASTER
 ADD PRIMARY KEY (CLTCODE)

DECLARE @@COSTCODE AS INT,
	@@SQL AS VARCHAR(1000)
	
DECLARE @servername as varchar(20) = 'ANAND1.ACCOUNT.DBO'


CREATE TABLE #COSTMAST (COSTCODE INT, COSTNAME VARCHAR(100))

IF @STATUSID = 'REGION'
BEGIN
	SET @@SQL = " INSERT INTO #COSTMAST "
	SET @@SQL = @@SQL + " SELECT COSTCODE, COSTNAME FROM COSTMAST C, " + @SHAREDB + ".DBO.REGION R WHERE REGIONCODE = RTRIM('" + @STATUSNAME + "') AND COSTNAME = BRANCH_CODE "
	
	EXEC (@@SQL)
END

IF @STATUSID = 'AREA'
BEGIN
	SET @@SQL = " INSERT INTO #COSTMAST "
	SET @@SQL = @@SQL + " SELECT COSTCODE, COSTNAME FROM COSTMAST C, " + @SHAREDB + ".DBO.AREA A WHERE AREACODE = RTRIM('" + @STATUSNAME + "') AND COSTNAME = BRANCH_CODE "
	
	EXEC (@@SQL)
END

IF @STATUSID = 'BRANCH'
BEGIN
	SET @@SQL = " INSERT INTO #COSTMAST "
	SET @@SQL = @@SQL + " SELECT COSTCODE, COSTNAME FROM COSTMAST WHERE COSTNAME = RTRIM('" + @STATUSNAME + "') "
	
	EXEC (@@SQL)
END


SET @@COSTCODE = -1

IF @BRANCHCODE <> '' OR @BRANCHCODE <> '%'
BEGIN
	SELECT TOP 1 @@COSTCODE = COSTCODE FROM COSTMAST WHERE COSTNAME = @BRANCHCODE
END

CREATE TABLE #TB
(
	CLTCODE VARCHAR(10),
	AMOUNT MONEY
)

IF @WITHOPENING = 1
BEGIN
	ALTER TABLE #TB
	ADD
		OPENING_AMOUNT MONEY,
		PERIOD_CREDIT MONEY,
		PERIOD_DEBIT MONEY
END

DECLARE
	@AMOUNT_PARAMETER VARCHAR(200),
	@NET_AMOUNT_PARAMETER VARCHAR(200),
	@DISPLAY_AMOUNT VARCHAR(300)
	
IF UPPER(@SORTBYDATE) = 'VDT'
BEGIN
	SET @NET_AMOUNT_PARAMETER = 'VDTBAL = SUM(VDTBAL)'
	IF @WITHOPENING = 0
	BEGIN
		SET @AMOUNT_PARAMETER = 'VDTBAL'
		SET @DISPLAY_AMOUNT = '-AMOUNT'
	END
	ELSE
	BEGIN
		SET @AMOUNT_PARAMETER = 'VDTBAL,VDTBAL_OPBAL, VDTBAL_DATES_CREDIT, VDTBAL_DATES_DEBIT'
		SET @DISPLAY_AMOUNT = ' -AMOUNT,-OPENING_AMOUNT, PERIOD_CREDIT, PERIOD_DEBIT'
	END
END
ELSE
BEGIN
	SET @NET_AMOUNT_PARAMETER = 'EDTBAL = SUM(EDTBAL)'
	IF @WITHOPENING = 0
	BEGIN
		SET @AMOUNT_PARAMETER = 'EDTBAL'
		SET @DISPLAY_AMOUNT = '-AMOUNT'
	END
	ELSE
	BEGIN
		SET @AMOUNT_PARAMETER = 'EDTBAL, EDTBAL_OPBAL, EDTBAL_DATES_CREDIT, EDTBAL_DATES_DEBIT'
		SET @DISPLAY_AMOUNT = '-AMOUNT,-OPENING_AMOUNT, PERIOD_CREDIT, PERIOD_DEBIT'
	END
END


SET @@SQL = "INSERT INTO #FORMULA_CLIENT_MASTER "
SET @@SQL = @@SQL + "SELECT CLTCODE "
SET @@SQL = @@SQL + "FROM ACMAST A "
SET @@SQL = @@SQL + "WHERE CLTCODE >= '" + @FROM_GL_CODE + "' AND CLTCODE <= '" + @TO_GL_CODE + "'"
IF UPPER(@VIEWOPTION) = 'GL'
	SET @@SQL = @@SQL + " AND ACCAT = 3 "
ELSE IF UPPER(@VIEWOPTION) = 'BANK'
	SET @@SQL = @@SQL + " AND ACCAT = 2 "	
ELSE IF UPPER(@VIEWOPTION) = 'CASH'
	SET @@SQL = @@SQL + " AND ACCAT = 1 "	
IF UPPER(@STATUSID) <> 'BROKER'
	SET @@SQL = @@SQL + "AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE COSTNAME = BRANCHCODE) "
print'sss'
PRINT @@SQL
EXEC(@@SQL)	
print 'dd'


IF UPPER(@STATUSID) = 'BROKER' AND @@COSTCODE = -1
BEGIN

	INSERT INTO #TB
	EXEC CLS_GET_ACC_LEDGER_FORMULA_BALANCES @FR_DATE, @VDT, 0, @AMOUNT_PARAMETER, @EXCHANGE, @SEGMENT , 'M.CLTCODE', '',''
END
ELSE
BEGIN
		INSERT INTO #TB
		EXEC CLS_GET_ACC_LEDGER2_FORMULA_BALANCES @FR_DATE, @VDT, 0, @AMOUNT_PARAMETER, @EXCHANGE, @SEGMENT , 'M.CLTCODE','',@@COSTCODE, ''
	
END

DROP TABLE #FORMULA_CLIENT_MASTER


SET @@SQL = "INSERT INTO " + @servername +'.'+@TABLE_NAME
SET @@SQL = @@SQL + " SELECT TB.CLTCODE, ACNAME, BRANCHCODE,	'" + @EXCHANGE + "','" +  @SEGMENT + "', " + @DISPLAY_AMOUNT + ", ACCAT, A.GRPCODE, GRPNAME "
SET @@SQL = @@SQL + "FROM "
SET @@SQL = @@SQL + "	#TB TB , ACMAST A, GRPMAST G "
SET @@SQL = @@SQL + "WHERE A.GRPCODE = G.GRPCODE AND TB.CLTCODE = A.CLTCODE "
/*SET @@SQL = @@SQL + "UNION "
SET @@SQL = @@SQL + "SELECT CLTCODE, ACNAME = 'PARTY TOTAL', BRANCHCODE = '', -AMOUNT, 0,	'" + @EXCHANGE + "','" +  @SEGMENT + "', '', '' "
SET @@SQL = @@SQL + "FROM #TB WHERE CLTCODE = '' AND ISNULL(AMOUNT, 0) <> 0 "*/
PRINT @@SQL
EXEC(@@SQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- --------------------------------------------------
CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------
CREATE procedure [dbo].[rebuild_index]  
@database varchar(100)  
as  
begin  
  
declare @db_id int  
Select @db_id = db_id(@database)  
  
if @db_id is Null  
return  
  
SET NOCOUNT ON;  
DECLARE @objectid int;  
DECLARE @indexid int;  
DECLARE @partitioncount bigint;  
DECLARE @schemaname nvarchar(130);  
DECLARE @objectname nvarchar(130);  
DECLARE @indexname nvarchar(130);  
DECLARE @partitionnum bigint;  
DECLARE @partitions bigint;  
DECLARE @frag float;  
DECLARE @command nvarchar(4000);  
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function  
-- and convert object and index IDs to names.  
  
SELECT  
object_id AS objectid,  
index_id AS indexid,  
partition_number AS partitionnum,  
avg_fragmentation_in_percent AS frag  
INTO #work_to_do  
FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')  
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0;  
  
-- Declare the cursor for the list of partitions to be processed.  
DECLARE partitions CURSOR FOR SELECT objectid,indexid,partitionnum,frag FROM #work_to_do;  
  
-- Open the cursor.  
OPEN partitions;  
  
-- Loop through the partitions.  
WHILE (1=1)  
BEGIN;  
FETCH NEXT  
FROM partitions  
INTO @objectid, @indexid, @partitionnum, @frag;  
IF @@FETCH_STATUS < 0 BREAK;  
SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)  
FROM sys.objects AS o  
JOIN sys.schemas as s ON s.schema_id = o.schema_id  
WHERE o.object_id = @objectid;  
SELECT @indexname = QUOTENAME(name)  
FROM sys.indexes  
WHERE object_id = @objectid AND index_id = @indexid;  
SELECT @partitioncount = count (*)  
FROM sys.partitions  
WHERE object_id = @objectid AND index_id = @indexid;  
  
-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.  
IF @frag < 30.0  
      SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';  
IF @frag >= 30.0  
      SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';  
IF @partitioncount > 1  
      SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));  
IF @frag >= 30.0  
      set @command = @command +N' WITH (SORT_IN_TEMPDB = ON)' 
 
EXEC (@command);  
PRINT N'Executed: ' + @command;  
END;  
  
-- Close and deallocate the cursor.  
CLOSE partitions;  
DEALLOCATE partitions;  
  
-- Drop the temporary table.  
DROP TABLE #work_to_do;  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_alterdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_creatediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_dropdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagramdefinition
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_renamediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_upgraddiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOBILLMATCH
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOBILLMATCH]
(
    [Exchange] CHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [Sett_type] VARCHAR(3) NULL,
    [Sett_No] VARCHAR(12) NULL,
    [BillNo] VARCHAR(10) NULL,
    [Date] DATETIME NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Amount] MONEY NULL,
    [DrCr] CHAR(1) NULL,
    [balamt] MONEY NULL,
    [vtype] SMALLINT NULL,
    [vno] DECIMAL(12, 0) NULL,
    [lno] DECIMAL(4, 0) NULL,
    [Branch] VARCHAR(10) NULL,
    [booktype] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOLEDGER]
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
    [narration] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOLEDGER1
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOLEDGER1]
(
    [bnkname] VARCHAR(35) NULL,
    [brnname] VARCHAR(20) NULL,
    [dd] CHAR(1) NULL,
    [ddno] VARCHAR(15) NULL,
    [dddt] DATETIME NULL,
    [reldt] DATETIME NULL,
    [relamt] MONEY NULL,
    [refno] CHAR(12) NOT NULL,
    [receiptno] INT NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] DECIMAL(18, 0) NULL,
    [drcr] CHAR(1) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] INT NULL,
    [SlipNo] INT NULL,
    [slipdate] DATETIME NULL,
    [ChequeInName] VARCHAR(50) NULL,
    [Chqprinted] TINYINT NULL,
    [clear_mode] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOLEDGER2
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOLEDGER2]
(
    [vtype] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] INT NULL,
    [drcr] CHAR(1) NULL,
    [camt] MONEY NULL,
    [costcode] SMALLINT NULL,
    [BookType] CHAR(2) NULL,
    [cltcode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOLEDGER3
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOLEDGER3]
(
    [naratno] INT NOT NULL,
    [narr] VARCHAR(234) NULL,
    [refno] CHAR(12) NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [BookType] CHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOMARGINLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOMARGINLEDGER]
(
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] INT NOT NULL,
    [drcr] CHAR(1) NOT NULL,
    [vdt] DATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(20) NOT NULL,
    [Sett_no] MONEY NOT NULL,
    [Sett_type] VARCHAR(3) NOT NULL,
    [BookType] CHAR(2) NULL,
    [MCltcode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ARC_MAR312005_FOPARAMETER
-- --------------------------------------------------
CREATE TABLE [dbo].[ARC_MAR312005_FOPARAMETER]
(
    [sdtcur] DATETIME NULL,
    [ldtcur] DATETIME NULL,
    [ldtprv] DATETIME NULL,
    [sdtnxt] DATETIME NULL,
    [curyear] TINYINT NULL,
    [vnoflag] SMALLINT NULL,
    [Match_BtoB] SMALLINT NULL,
    [Match_CtoC] SMALLINT NULL,
    [maker_checker] SMALLINT NULL,
    [VoucherPrintFlag] SMALLINT NULL,
    [BranchFlag] SMALLINT NULL,
    [reportdays] INT NULL
);

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
-- TABLE dbo.Sheet1$
-- --------------------------------------------------
CREATE TABLE [dbo].[Sheet1$]
(
    [Sr# No#] FLOAT NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Security Name] NVARCHAR(255) NULL,
    [ISIN] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysdiagrams
-- --------------------------------------------------
CREATE TABLE [dbo].[sysdiagrams]
(
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
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

