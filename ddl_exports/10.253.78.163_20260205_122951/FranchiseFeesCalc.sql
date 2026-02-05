-- DDL Export
-- Server: 10.253.78.163
-- Database: FranchiseFeesCalc
-- Exported: 2026-02-05T12:29:58.588870

USE FranchiseFeesCalc;
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
-- INDEX dbo.tbl_BranchCode_BranchName
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__tbl_Bran__1C61B888B644FCBE] ON [dbo].[tbl_BranchCode_BranchName] ([BranchCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B61F9D11838] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BranchCode_BranchName
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BranchCode_BranchName] ADD CONSTRAINT [UQ__tbl_Bran__1C61B888B644FCBE] UNIQUE ([BranchCode])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pANGEL_ACCOUNT_ANALYSIS
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pANGEL_ACCOUNT_ANALYSIS]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pACCOUNTED_DR    decimal ,
	@pACCOUNTED_CR  decimal ,
	@pENTITY_DESCRIPTION  nvarchar(max) ,
	@pACCOUNT_CODE   int,
	@pACCOUNT_DESCRIPTION nvarchar(max),
	@pBRANCH_CODE  int,
	--@pIsActive  bit,
	@pCreatedOn datetime,
	@pCreatedBy  nvarchar(20),
	@pUpdatedOn datetime ,
	@pUpdatedBy  nvarchar(20)
		
AS
BEGIN
SET NOCOUNT ON;

INSERT INTO  [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS](
	ACCOUNTED_DR  ,
	ACCOUNTED_CR,
	ENTITY_DESCRIPTION,
	ACCOUNT_CODE,
	ACCOUNT_DESCRIPTION ,
	BRANCH_CODE ,
	CreatedOn,
	CreatedBy,
	UpdatedOn  ,
	UpdatedBy
	)
VALUES (
	@pACCOUNTED_DR  ,
	@pACCOUNTED_CR,
	@pENTITY_DESCRIPTION,
	@pACCOUNT_CODE,
	@pACCOUNT_DESCRIPTION ,
	@pBRANCH_CODE ,
	GETDATE(),
	@pCreatedBy,
	GETDATE()  ,
	@pUpdatedBy
	 );

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDeleteBCBN_BYBRANCHCODE
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pDeleteBCBN_BYBRANCHCODE]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pID int,
@pDeletedBy nvarchar(30)
AS 
BEGIN 
SET NOCOUNT ON;
 
UPDATE [dbo].[tbl_BranchCode_BranchName]
SET IsActive=0,DeletedBy=@pDeletedBy,DeletedOn=GETDATE()
 WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDeleteEntityCodeSegmentNameByID
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pDeleteEntityCodeSegmentNameByID]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pEntity_Code int,
@pDeletedBy nvarchar(30)
AS 
BEGIN 
SET NOCOUNT ON;
 
UPDATE [dbo].[tbl_EntityCode_SegmentName]
SET IsActive=0,DeletedBy=@pDeletedBy,DeletedOn=GETDATE()
 WHERE ENTITY_CODE=@pEntity_Code
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDeleteExpectionData
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pDeleteExpectionData]  
@pSbTag nvarchar(8)  
AS   
BEGIN   
SET NOCOUNT ON;  
  
--UPDATE [FranchiseFeesCalc].[dbo].[tblFranchise]  
--SET ITrdBrok=V1.ITrdBrok,  
-- ITradechar=V1.ITradechar,  
-- category=CASE WHEN V1.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END,--Category  
-- DUMMY=(CASE WHEN (select Count(B2C_SB) from mis.remisior.dbo.b2c_sb where B2C_SB=V1.sb)>0   
--   THEN  (SELECT TOP 1 B2C_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=V1.Branch)   
--   ELSE  (SELECT TOP 1 B2B_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=V1.Branch)   
--   END),  
-- Gross_Normal=CASE WHEN (V1.ITrdBrok+V1.ITradechar)=0 THEN V1.brok_earned ELSE 0 END,  
-- SB_Normal=CASE WHEN (V1.ITrdBrok+V1.ITradechar)=0 THEN (V1.remi_share+V1.sub_remi_share) ELSE 0 END,  
-- SB_ItardeBrok=(V1.ITrdBrok-V1.ITradeBrokAngel),  
-- SB_ItardeChar=(V1.ITradechar-V1.ITradeCharAngel)  
--FROM [FranchiseFeesCalc].[dbo].[tblFranchise] F1  
--INNER JOIN remisior.dbo. vw_daily_sharing V1  
--ON F1.Code=REPLACE(V1.segment+'_'+V1.sb+'_'+V1.client+'_'+convert(varchar, V1.sauda_date, 112),' ', '')+'_'+CASE WHEN V1.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END  
--WHERE F1.sb=@pSbTag  
  
  
DELETE FROM  FranchiseFeesCalc.dbo.tblFranchise WHERE sb=@pSbTag  
INSERT INTO FranchiseFeesCalc.dbo.tblFranchise  
SELECT   
REPLACE(v.segment+'_'+v.sb+'_'+v.client+'_'+convert(varchar, v.sauda_date, 112),' ', '')+'_'+CASE WHEN v.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END AS Code,  
segment,sauda_date,brok_earned,remi_share,sub_remi_share,angel_share,v.branch,  
sb,client,Addt_Brok,AddAngelShare,ITrdBrok,ITradechar,ITradeBrokAngel,ITradeCharAngel,  
CASE WHEN v.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END AS Category,--Category  
0,--IsMissMatchUpdated  
CASE WHEN (ITrdBrok+ITradechar)=0 THEN brok_earned ELSE 0 END,--Gross_Normal  
CASE WHEN (ITrdBrok+ITradechar)=0 THEN (remi_share+sub_remi_share) ELSE 0 END,--SB_Normal  
(ITrdBrok-ITradeBrokAngel),--SB_ItardeBrok  
(ITradechar-ITradeCharAngel),--SB_ItardeChar  
0,--SB_Other  
0,--Gross_Other  
0,0,0,  
NULL,--RemarksforOtherCharges  
NULL,--OtherChargesUpdatedOn  
NULL,--OtherchargesCreatedBy  
(CASE WHEN (select Count(B2C_SB) from mis.remisior.dbo.b2c_sb where B2C_SB=v.sb)>0   
     THEN  (SELECT TOP 1 B2C_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=v.Branch)   
     ELSE  (SELECT TOP 1 B2B_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=v.Branch)   
    END)AS DUMMY--DUMMY  
FROM   
remisior.dbo. vw_daily_sharing v (NOLOCK)  
WHERE   
sauda_date>=   
CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END  
AND sauda_date<=  
CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate()),'-',MONTH(GETDATE())-1,'-', DAY(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))) ELSE CONCAT(YEAR(getdate())+1,'-',MONTH(GETDATE())-1,'-31') END  
 AND v.sb=@pSbTag  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDeleteFranchiseeJV
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pDeleteFranchiseeJV]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
DELETE [dbo].[FRANCHISE_JV]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDeleteOtherChargesDetails_BYID
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pDeleteOtherChargesDetails_BYID]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pID int,
@pDeletedBy nvarchar(50)
AS 
BEGIN 
SET NOCOUNT ON;
 
UPDATE FranchiseFeesCalc.dbo.[OtherCharges]
SET IsActive=0,DeletedBy=@pDeletedBy,DeletedOn=GETDATE()
 WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pEntityCodeSegmentNameInsertUpdate
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pEntityCodeSegmentNameInsertUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pEntity_Code  int,
	@pSegment_Name  nvarchar(10) ,
	@pCreatedBy nvarchar(30)
	
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT ENTITY_CODE FROM [dbo].[tbl_EntityCode_SegmentName] (NOLOCK)
WHERE ENTITY_CODE=@pEntity_Code
)
BEGIN
INSERT INTO [dbo].[tbl_EntityCode_SegmentName] (
	ENTITY_CODE,
	SEGMENT_NAME,
	CreatedOn ,
	CreatedBy,
	IsActive
	)
VALUES (
	@pEntity_Code,
	@pSegment_Name,
	GETDATE() ,
	@pCreatedBy,
	1
	 );
END

ELSE
BEGIN
UPDATE  [dbo].[tbl_EntityCode_SegmentName]
SET	ENTITY_CODE=@pEntity_Code,
	SEGMENT_NAME=@pSegment_Name,
	CreatedOn=GETDATE(),
	CreatedBy=@pCreatedBy
	

WHERE ENTITY_CODE=@pEntity_Code
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExceptional_FromtblExceptional
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExceptional_FromtblExceptional]
AS 
BEGIN 

SET NOCOUNT ON;

select ID, sb,	Branch,	Category,	ITrdBrok,	ITradechar,IncomePercent

from [dbo].[tblExceptional] (NOLOCK)
where IsActive=1

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExceptionalDelete
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pExceptionalDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pSBTag nvarchar(10),
@pBranch nvarchar(20),
@pDeletedBy nvarchar(30)

AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/

EXEC pDeleteExpectionData @pSbTag=@pSBTag --Update Actual date in tblFranchise

UPDATE  [dbo].[tblExceptional]
SET IsActive=0,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE sb=@pSBTag AND Branch=@pBranch;
END


--select * from [dbo].[tblExceptional]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExceptionalRecordsBySBTagAndBranch
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExceptionalRecordsBySBTagAndBranch]
@pSBTag nvarchar(10),
@pBranch nvarchar(10)
AS 
BEGIN 
SET NOCOUNT ON;
select Category	,ITrdBrok,ITradechar, IncomePercent
from [dbo].[tblExceptional] (NOLOCK)
where  sb=@pSBTag and Branch=@pBranch

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExpensesAccCodebyBranch
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExpensesAccCodebyBranch]
AS 
BEGIN 
SET NOCOUNT ON;

DECLARE @AccountCode nvarchar(20)
DECLARE MY_CURSOR CURSOR 
  LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT DISTINCT  ACCOUNT_CODE from FranchiseFeesCalc.dbo.tbl_ANGEL_ACCOUNT_ANALYSIS

OPEN MY_CURSOR
FETCH NEXT FROM MY_CURSOR INTO @AccountCode
WHILE @@FETCH_STATUS = 0
BEGIN 

INSERT INTO FranchiseFeesCalc.[dbo].[tblExpense]
SELECT UniqueId= BranchName + '_'+CAST(@AccountCode AS nvarchar(20)),
BranchTag=BranchName,
BRANCH_CODE=BranchCode,
ACCOUNT_CODE=@AccountCode,
ACCOUNT_DESCRIPTION= (SELECT TOP 1 ACCOUNT_DESCRIPTION from FranchiseFeesCalc.dbo.tbl_ANGEL_ACCOUNT_ANALYSIS WHERE ACCOUNT_CODE=@AccountCode),
OtherExpenseType='Ops_Exp',
IsActive=1
  FROM  FranchiseFeesCalc.[dbo].[tbl_BranchCode_BranchName] B

FETCH NEXT FROM MY_CURSOR INTO @AccountCode
END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExportCSVNoParameter
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pExportCSVNoParameter]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pStageNo int
AS
BEGIN
SET NOCOUNT ON
----**-----Stage_1----**------
IF(@pStageNo=1)
	BEGIN
		SELECT * FROM [dbo].[tblFranchise]
	END
		
----**-----Stage_2----**------
IF(@pStageNo=2)
	BEGIN
		SELECT SB,Branch,Category FROM [dbo].[tblMisMatchB2BRecord]
	END
----**-----Stage_3----**------
IF(@pStageNo=3)
	BEGIN
		SELECT [sb]
      ,[Branch]
      ,[Category]
      ,[ITrdBrok]
      ,[ITradechar]
      ,[SB_Branch]
      ,[IncomePercent] FROM [dbo].[tblExceptional]
	END
----**-----Stage_4----**------
IF(@pStageNo=4)
	BEGIN
		SELECT [segment]
      ,[sauda_date]
      ,[branch]
      ,[Category]
      ,[SB_Other]
      ,[Gross_Other]
      ,[RemarksforOtherCharges]
      ,[Ops_Other]
      ,[Brokerage_Paid] FROM [dbo].[OtherCharges]
	END

----**-----Stage_5----**------
IF(@pStageNo=5)
	BEGIN
		SELECT * FROM [FranchiseFeesCalc].[dbo].[tblMonthWiseTotal] WHERE [Years]=(SELECT datename(year, dateadd(y,0, getdate()))) AND [Months]=(SELECT datename(month, dateadd(m, -1, getdate())-1))
	END
----**-----Stage_6----**------
IF(@pStageNo=6)
	BEGIN
		SELECT   * FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]
	END
----**-----Stage_7----**------
IF(@pStageNo=7)
	BEGIN
		SELECT BranchName,	OracleCode,	ACCOUNT_DESCRIPTION,	ACCOUNT_CODE,	ExpenseTypes
 FROM [dbo].[OracleTypeMaping]
	END
----**-----Stage_8----**------
IF(@pStageNo=8)
	BEGIN
		SELECT * FROM [dbo].[tblOracleMonthWiseTotal] WHERE [Years]=(SELECT datename(year, dateadd(y,0, getdate()))) AND [Months]=(SELECT datename(month, dateadd(m, -1, getdate())-1))
	END

----**-----Stage_10----**------
IF(@pStageNo=10)
	BEGIN
		SELECT * FROM [dbo].[FRANCHISE_JV]
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pFetchFranchise_Stages
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pFetchFranchise_Stages]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pMonths	int,
	@pYears		int
	
	
AS
BEGIN
SET NOCOUNT ON;


SELECT * FROM  [dbo].[FranchiseeCalcBtnStages] WHERE  Months=@pMonths AND Years=@pYears

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pFranchiseCalculationDelete
-- --------------------------------------------------



Create PROCEDURE [dbo].[pFranchiseCalculationDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pMonths int,
@pYears int,
@pModifiedBy nvarchar(30)

AS
BEGIN
SET NOCOUNT ON

DELETE [dbo].[tblMonthWiseTotal] WHERE Months=@pMonths AND Years=@pYears

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_5=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END


--select * from [dbo].[tblMonthWiseTotal]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pFranchiseCopiedDataDelete
-- --------------------------------------------------



Create PROCEDURE [dbo].[pFranchiseCopiedDataDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pMonths int,
@pYears int,
@pModifiedBy nvarchar(30)

AS
BEGIN
SET NOCOUNT ON

DELETE [dbo].[tblFranchise]

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_1=0,Stage_5=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END


--select * from [dbo].[FranchiseeCalcBtnStages]
--[pOracleCalculationDelete]
--[pOracleCopiedDataDelete]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pFranchiseOracleDataDelete
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pFranchiseOracleDataDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pMonths int,
@pYears int,
@pModifiedBy nvarchar(30),
@pStageNo int

AS
BEGIN
SET NOCOUNT ON
----**-----Stage_1----**------
IF(@pStageNo=1)
BEGIN
DELETE [dbo].[tblMonthWiseTotal] WHERE Months=DateName( month , DateAdd( month , @pMonths , 0 ) - 1 ) AND Years=@pYears

DELETE [dbo].[tblFranchise]

SET @pStageNo=7

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_1=0,Stage_5=0,Stage_2=0,Stage_4=0,Stage_3=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END
----**-----Stage_5----**------
IF(@pStageNo=5)
BEGIN
DELETE [dbo].[tblMonthWiseTotal] WHERE Months=DateName( month , DateAdd( month , @pMonths , 0 ) - 1 ) AND Years=@pYears

SET @pStageNo=7

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_5=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END
----**-----Stage_6----**------
IF(@pStageNo=6)
BEGIN
DELETE [dbo].[tblOracleMonthWiseTotal] WHERE Months=DateName( month , DateAdd( month , @pMonths , 0 ) - 1 ) AND Years=@pYears

DELETE [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]


UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_7=0,Stage_6=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END
----**-----Stage_7----**------
IF(@pStageNo=7)
BEGIN
DELETE [dbo].[tblOracleMonthWiseTotal] WHERE Months=DateName( month , DateAdd( month , @pMonths , 0 ) - 1 ) AND Years=@pYears

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_7=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END

END


--[pOracleCalculationDelete]
--[pOracleCopiedDataDelete]
--[pFranchiseCalculationDelete]
--[pFranchiseCopiedDataDelete]
--pFranchiseOracleDataDelete

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pFranchiseRecords
-- --------------------------------------------------
    
    
    
CREATE PROCEDURE [dbo].[pFranchiseRecords]    
    
AS     
    
BEGIN     
    
SET NOCOUNT ON;    
    
    
    
--Delete last third month data from [tblFranchise_History]    
    
IF(SELECT COUNT(*) FROM [dbo].[tblFranchise_History]    
    
WHERE Months=MONTH(DATEADD(month, -3, GETDATE())) AND Years=YEAR(DATEADD(month, -3, GETDATE())))>0    
    
BEGIN    
    
DELETE [dbo].[tblFranchise_History]     
    
END    
    
    
    
--Move last second month data to [tblFranchise_History]    
    
IF(SELECT COUNT(*) FROM [dbo].[tblFranchise_History]    
    
WHERE Months=MONTH(DATEADD(month, -2, GETDATE())) AND Years=YEAR(DATEADD(month, -2, GETDATE())))=0    
    
BEGIN    
    
 INSERT INTO [dbo].[tblFranchise_History]    
    
 SELECT *,MONTH(DATEADD(month, -2, GETDATE())),YEAR(DATEADD(month, -2, GETDATE())),GETDATE() FROM [dbo].[tblFranchise]    
    
    
    
 DELETE [dbo].[tblFranchise]     
    
END    
    
    
    
    
    
--Copy New Data    
    
DECLARE @Branch nvarchar(20)    
DECLARE MY_CURSOR CURSOR     
    
  LOCAL STATIC READ_ONLY FORWARD_ONLY    
    
FOR     
    
SELECT DISTINCT  Ftag from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE ToDate>getdate()    
OPEN MY_CURSOR    
    
FETCH NEXT FROM MY_CURSOR INTO @Branch    
    
WHILE @@FETCH_STATUS = 0    
    
BEGIN     
    
INSERT INTO FranchiseFeesCalc.dbo.tblFranchise    
    
SELECT     
    
REPLACE(v.segment+'_'+v.sb+'_'+v.client+'_'+convert(varchar, v.sauda_date, 112),' ', '')+'_'+CASE WHEN v.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END AS Code,    
segment,sauda_date,brok_earned,remi_share,sub_remi_share,angel_share,v.branch,    
sb,client,Addt_Brok,AddAngelShare,ITrdBrok,ITradechar,ITradeBrokAngel,ITradeCharAngel,    
CASE WHEN v.sb IN(select B2C_SB from mis.remisior.dbo.b2c_sb)THEN 'B2C' ELSE 'B2B' END AS Category,--Category    
0,--IsMissMatchUpdated    
CASE WHEN (ITrdBrok+ITradechar)=0 THEN brok_earned ELSE 0 END,--Gross_Normal    
    
CASE WHEN (ITrdBrok+ITradechar)=0 THEN (remi_share+sub_remi_share) ELSE 0 END,--SB_Normal    
    
(ITrdBrok-ITradeBrokAngel),--SB_ItardeBrok    
    
(ITradechar-ITradeCharAngel),--SB_ItardeChar    
0,--SB_Other    
0,--Gross_Other    
0,0,0,    
NULL,--RemarksforOtherCharges    
NULL,--OtherChargesUpdatedOn    
NULL,--OtherchargesCreatedBy    
    
(CASE WHEN (select Count(B2C_SB) from mis.remisior.dbo.b2c_sb where B2C_SB=v.sb)>0     
     THEN  (SELECT TOP 1 B2C_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=v.Branch)     
     ELSE  (SELECT TOP 1 B2B_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=v.Branch)     
   END)AS DUMMY--DUMMY    
    
FROM remisior.dbo.vw_daily_sharing v (NOLOCK)    
WHERE sauda_date>= CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END    
AND sauda_date<=DATEADD(ss, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))    
--CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate()),'-',MONTH(GETDATE())-1,'-', DAY(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))) ELSE CONCAT(YEAR(getdate())+1,'-',MONTH(GETDATE())-1,'-31') END    
 AND v.branch=@Branch    
    
FETCH NEXT FROM MY_CURSOR INTO @Branch    
END    
CLOSE MY_CURSOR    
DEALLOCATE MY_CURSOR    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetB2BandB2CMonthlyTotal
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetB2BandB2CMonthlyTotal]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

SELECT branch,segment,category, DATENAME(MONTH,[sauda_date]) AS Month,YEAR([sauda_date]) AS Year, Sum(ITrdBrok+ITradechar) AS Total 
FROM [FranchiseFeesCalc].[dbo].[tblFranchise] (NOLOCK)
GROUP BY branch,segment,category,YEAR([sauda_date]),MONTH([sauda_date]),DATENAME(MONTH,[sauda_date])
ORDER BY branch,segment,category,YEAR([sauda_date]),MONTH([sauda_date]),DATENAME(MONTH,[sauda_date])

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBCBN_BYBranchCode
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetBCBN_BYBranchCode]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pID int
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID, BranchCode,BranchName,CreatedBy,CreatedOn
FROM [dbo].[tbl_BranchCode_BranchName](NOLOCK)
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBCBNDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetBCBNDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,BranchCode,BranchName,CreatedBy,CreatedOn
FROM [dbo].[tbl_BranchCode_BranchName] (NOLOCK)
WHERE IsActive=1
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBranchTableDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetBranchTableDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT DISTINCT(BranchName),BranchCode FROM [dbo].[tbl_BranchCode_BranchName]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBrokeragePaid
-- --------------------------------------------------






CREATE PROCEDURE [dbo].[pGetBrokeragePaid]

--=============================================

--Author:			<Author,,Akidut>

--Created Date:		<Created Date,,23/10/2019>

--Discription:		<Description,,Insert and Update for AdminMaster>

--=============================================

@pMonth nvarchar(15),

@pYear int

AS 

BEGIN 

SET NOCOUNT ON;



SET NOCOUNT ON;

	SELECT Z.Branch,Z.Segment, Balance

	FROM (

	SELECT BranchName AS Branch,SEGMENT_NAME AS Segment,Balance AS Balance

	FROM [dbo].[tblOracleMonthWiseTotal] 

	WHERE Months=@pMonth AND Years=@pYear AND ACCOUNT_CODE=511104



	UNION 



	SELECT branch AS Branch,segment AS Segment,Brokerage_Paid AS Balance

	FROM [dbo].[OtherCharges] 

	WHERE Brokerage_Paid!=0 AND  sauda_date<=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)) 
	AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END
	AND IsActive=1

	) As Z

	

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetEntityCodeSegmentNameByEC
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetEntityCodeSegmentNameByEC]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pENTITY_CODE int
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ENTITY_CODE, SEGMENT_NAME,CreatedBy,CreatedOn
FROM [dbo].[tbl_EntityCode_SegmentName](NOLOCK)
WHERE ENTITY_CODE=@pENTITY_CODE
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetEntityCodeSegmentNameDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetEntityCodeSegmentNameDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

 SELECT ENTITY_CODE,SEGMENT_NAME,CreatedBy,CreatedOn FROM [dbo].[tbl_EntityCode_SegmentName]
 WHERE IsActive=1

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetEntityTableDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetEntityTableDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT DISTINCT(SEGMENT_NAME),ENTITY_CODE FROM [dbo].[tbl_EntityCode_SegmentName]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetExceptionalDataFromFrachiseMast_06Nov2025
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[pGetExceptionalDataFromFrachiseMast_06Nov2025]    
--=============================================    
--Author:   <Author,,Akidut>    
--Created Date:  <Created Date,,23/10/2019>    
--Discription:  <Description,,Insert and Update for AdminMaster>    
--=============================================    
@pSBTag nvarchar(10)    
AS     
BEGIN     
SET NOCOUNT ON;    
     
SELECT  TF.SBTAG,TF.Branch,    
50 AS ITrdBrok,100 AS ITradechar,TF.SBTAG+'_'+TF.Branch AS SBTAG_Branch,    
F.B2B_IncomePercent , F.B2C_IncomePercent ,    
CASE WHEN TF.SBTAG IN(    
select B2C_SB from mis.remisior.dbo.b2c_sb    
) THEN 'B2C' ELSE 'B2B' END AS Category    
 FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F (NOLOCK)    
INNER JOIN    
[SB_COMP].[dbo].[SB_Broker] (NOLOCK) TF ON F.Ftag=TF.Branch    
WHERE TF.SBTAG=@pSBTag    
END    
    
 --AND F.ToDate>GETDATE()    
    
     
    
--select * from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F    
    
--select * from [dbo].[tblExceptional]    
    
--select sbtag from  sb_broker where sbtag not in (select B2C_SB from mis.remisior.dbo.b2c_sb)    
    
    
--select B2C_SB from mis.remisior.dbo.b2c_sb    
--where B2C_SB='AKHL'    
    
    
--CASE WHEN S.sbtag IN(    
--select B2C_SB from mis.remisior.dbo.b2c_sb    
--) THEN 'B2C' ELSE 'B2B' END AS Category,    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetExceptionalDataFromFrachiseMast_tobedeleted09jan2026
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[pGetExceptionalDataFromFrachiseMast]    
--=============================================    
--Author:   <Author,,Akidut>    
--Created Date:  <Created Date,,23/10/2019>    
--Discription:  <Description,,Insert and Update for AdminMaster>    
--=============================================    
@pSBTag nvarchar(10)    
AS     
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SET NOCOUNT ON;    
     
SELECT  TF.SBTAG,TF.Branch,    
50 AS ITrdBrok,100 AS ITradechar,TF.SBTAG+'_'+TF.Branch AS SBTAG_Branch,    
F.B2B_IncomePercent , F.B2C_IncomePercent ,    
CASE WHEN TF.SBTAG IN(    
select B2C_SB from mis.remisior.dbo.b2c_sb    
) THEN 'B2C' ELSE 'B2B' END AS Category    
 FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F (NOLOCK)    
INNER JOIN    
[SB_COMP].[dbo].[SB_Broker] (NOLOCK) TF ON F.Ftag=TF.Branch    
WHERE TF.SBTAG=@pSBTag    
END    
    
 --AND F.ToDate>GETDATE()    
    
     
    
--select * from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F    
    
--select * from [dbo].[tblExceptional]    
    
--select sbtag from  sb_broker where sbtag not in (select B2C_SB from mis.remisior.dbo.b2c_sb)    
    
    
--select B2C_SB from mis.remisior.dbo.b2c_sb    
--where B2C_SB='AKHL'    
    
    
--CASE WHEN S.sbtag IN(    
--select B2C_SB from mis.remisior.dbo.b2c_sb    
--) THEN 'B2C' ELSE 'B2B' END AS Category,    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetGSTDetails
-- --------------------------------------------------
  
  
  
CREATE PROCEDURE [dbo].[pGetGSTDetails]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Insert and Update for AdminMaster>  
--=============================================  
  
AS   
BEGIN   
SET NOCOUNT ON;  
  
SELECT DISTINCT(A.SUPNO),B.State,  
CASE WHEN B.CGST='YES' AND B.SGST='YES' THEN '2*18*CGST_SGST'   
--ELSE (CASE WHEN B.CGST='YES' AND B.UGST='YES' THEN '2*18*US' ELSE '1*18*I' END) END AS Code  
WHEN B.CGST='YES' AND B.UGST='YES' THEN '2*18*CGST_UGST' ELSE '1*18*IGST' END AS Code  
--B.State,C.Segment,C.OrgId,C.SBTag   
FROM [remisior].[dbo].tbl_GstSbMaster A  
INNER JOIN [remisior].[dbo].StateGstMaster B  
ON A.STATE=B.State  
INNER JOIN [SB_COMP].[dbo].vendor_mapping C  
ON C.vendor_number=A.SUPNO  
WHERE A.CreatedStatus='Verified' AND C.SBTag IN (SELECT DISTINCT  Ftag from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE ToDate>getdate())  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetMonthlyWiseTotal
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[pGetMonthlyWiseTotal]

--=============================================

--Author:			<Author,,Akidut>

--Created Date:		<Created Date,,23/10/2019>

--Discription:		<Description,,Insert and Update for AdminMaster>

--=============================================

AS 

BEGIN 

SET NOCOUNT ON;

EXEC pUpdateExpectionData --SP to update exception data in tblFranchise

INSERT INTO [dbo].[tblMonthWiseTotal]

SELECT YEAR(DATEADD(month, -1, GETDATE())) AS Years,

DATENAME(MONTH,DATEADD(month, -1, GETDATE())) AS Months, 

F.branch,F.segment,F.Category,

SUM(ITrdBrok) AS ITrdBrok,

SUM(ITradechar) AS ITradechar,

SUM(Gross_Normal) AS Gross_Normal,

SUM(SB_Normal) AS SB_Normal,

SUM(SB_ItardeBrok) AS SB_ItardeBrok,

SUM(SB_ItardeChar)AS SB_ItardeChar,

(select SUM(SB_Other) from [dbo].[OtherCharges] where F.branch=branch AND F.segment=segment AND F.Category=Category AND sauda_date<=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)) AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END) AS SB_Other,

(select SUM(Gross_Other) from [dbo].[OtherCharges] where F.branch=branch AND F.segment=segment AND F.Category=Category AND sauda_date<=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)) AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(
getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END) AS Gross_Other,

(select SUM(Ops_Other) from [dbo].[OtherCharges] where F.branch=branch  AND sauda_date<=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)) AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate
()),'-04-01') END) AS Ops_Other,

SUM(Fr_Normal) AS Fr_Normal,SUM(FR_ItardeBrok) AS FR_ItardeBrok,

SUM(FR_ItardeChar) AS FR_ItardeChar,

(select SUM(Brokerage_Paid) from [dbo].[OtherCharges] where F.branch=branch AND F.segment=segment AND F.Category=Category AND sauda_date<=GETDATE()AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END) AS Brokerage_Paid,

(F.dummy)

FROM [dbo].[tblFranchise] F 

--WHERE  F.sauda_date<  DATEADD(month, -1, GETDATE())

WHERE  F.sauda_date>= 

CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END

AND F.sauda_date<=DATEADD(ss, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))

--CASE WHEN (MONTH(GETDATE())) <= 3 THEN CONCAT(YEAR(getdate()),'-',MONTH(GETDATE())-1,'-31') ELSE CONCAT(YEAR(getdate())+1,'-',MONTH(GETDATE())-1,'-31') END
--CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate()),'-',MONTH(GETDATE())-1,'-', DAY(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1))) ELSE CONCAT(YEAR(getdate())+1,'-',MONTH(GETDATE())-1,'-31') END

--AND branch='XN' AND	segment='ACPLMCX'

	--AND NOT EXISTS(SELECT Years ,Months from [dbo].[tblMonthWiseTotal])

--and Category='B2C' 

GROUP BY F.branch,F.segment,F.Category,F.dummy

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetMonthlyWiseTotalUsingMY
-- --------------------------------------------------






CREATE PROCEDURE [dbo].[pGetMonthlyWiseTotalUsingMY]

--=============================================

--Author:			<Author,,Akidut>

--Created Date:		<Created Date,,23/10/2019>

--Discription:		<Description,,Insert and Update for AdminMaster>

--=============================================

@pMonth nvarchar(15),

@pYear int

AS 

BEGIN 

SET NOCOUNT ON;

SELECT M.[branch]

,M.[segment]

,M.[Category]

,M.[ITrdBrok]

,M.[ITradechar]

,M.[Gross_Normal]

,M.[SB_Normal]

,M.[SB_ItardeBrok]

,M.[SB_ItardeChar]

,M.[SB_Other]

,M.[Gross_Other]

,M.[Ops_Other]

,M.[Brokerage_Paid]

,M.[Fr_Normal]

,M.[FR_ItardeBrok]

,M.[FR_ItardeChar]
,M.[FrNormalPercent]

FROM [FranchiseFeesCalc].[dbo].[tblMonthWiseTotal] M

WHERE Months=@pMonth AND Years=@pYear

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetOps_ExpenseDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetOps_ExpenseDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT branch AS Branch,SUM(Ops_Other) AS Ops_Other,RemarksforOtherCharges AS Remarks
FROM [dbo].[OtherCharges] 
WHERE (Ops_Other IS NOT NULL OR Ops_Other!=0) 
AND sauda_date<=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0)) 
AND sauda_date>=CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END
AND IsActive=1
GROUP BY branch,RemarksforOtherCharges HAVING SUM(Ops_Other)!=0
END


--select DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetOracleTypeMapping
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetOracleTypeMapping]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
--SELECT ID,BranchName,	OracleCode,	ACCOUNT_DESCRIPTION,ACCOUNT_CODE,ExpenseTypes
--FROM [FranchiseFeesCalc].[dbo].[OracleTypeMaping] (NOLOCK)


SELECT OracleCode,ID,BranchName,ACCOUNT_DESCRIPTION,ACCOUNT_CODE,ExpenseTypes 
FROM [dbo].[OracleTypeMaping]
UNION
SELECT  Distinct(A.BRANCH_CODE) AS OracleCode,0 AS ID, B.BranchName ,A.ACCOUNT_DESCRIPTION ,A.ACCOUNT_CODE,' ' AS ExpenseTypes
FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS] A
INNER JOIN [dbo].[tbl_BranchCode_BranchName] B
ON B.BranchCode=A.BRANCH_CODE
WHERE NOT EXISTS (SELECT O.OracleCode,	O.ACCOUNT_DESCRIPTION,	O.ACCOUNT_CODE FROM [dbo].[OracleTypeMaping] O  WHERE A.ACCOUNT_CODE = O.ACCOUNT_CODE AND A.BRANCH_CODE=O.OracleCode)


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetOracleTypeMapping_BYID
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetOracleTypeMapping_BYID]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pID int
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,BranchName,OracleCode,ACCOUNT_DESCRIPTION,ACCOUNT_CODE,ExpenseTypes
FROM [FranchiseFeesCalc].[dbo].[OracleTypeMaping] (NOLOCK)
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetOtherChargesDetails
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetOtherChargesDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID, sauda_date, branch,Category,RemarksforOtherCharges,segment,SB_Other,Gross_Other,Brokerage_Paid,Ops_Other,OtherChargesUpdatedOn,OtherchargesCreatedBy
FROM FranchiseFeesCalc.dbo.[OtherCharges] (NOLOCK)
WHERE IsActive=1
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetOtherChargesDetails_BYID
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetOtherChargesDetails_BYID]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pID int
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID, sauda_date, branch,Category,RemarksforOtherCharges,segment,SB_Other,Gross_Other,Ops_Other,Brokerage_Paid,OtherChargesUpdatedOn,OtherchargesCreatedBy
FROM FranchiseFeesCalc.dbo.[OtherCharges]
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetTotalofOracleTable
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetTotalofOracleTable]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,04/02/2020>
--Discription:		<Description,,Get the total by segment>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

INSERT INTO tblOracleMonthWiseTotal
SELECT YEAR(DATEADD(month, -1, GETDATE())) AS Years,DATENAME(MONTH,DATEADD(month, -1, GETDATE())) AS Months,B.BranchName,E.SEGMENT_NAME,
SUM(A.ACCOUNTED_CR) AS AccountCredited,SUM(A.ACCOUNTED_DR) AS AccountDebited,SUM(A.ACCOUNTED_DR-A.ACCOUNTED_CR) AS Balance,A.ACCOUNT_DESCRIPTION,A.ACCOUNT_CODE,B.BranchCode,E.ENTITY_CODE
FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS] A
INNER JOIN
[dbo].[tbl_BranchCode_BranchName] B
ON
A.BRANCH_CODE=B.BranchCode
INNER JOIN
[dbo].[tbl_EntityCode_SegmentName] E
ON
A.ENTITY_CODE=E.ENTITY_CODE
WHERE  A.ACCOUNTING_DATE<=  DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
AND A.ACCOUNTING_DATE>= CASE WHEN (MONTH(GETDATE())) <= 4 THEN CONCAT(YEAR(getdate())-1,'-04-01') ELSE CONCAT(YEAR(getdate()),'-04-01') END
 --AND ACCOUNT_CODE=511104 AND BranchName='XI'
--AND NOT EXISTS(SELECT Years ,Months from [dbo].[tblOracleMonthWiseTotal])
GROUP BY B.BranchName,E.SEGMENT_NAME,A.ACCOUNT_DESCRIPTION,A.ACCOUNT_CODE,B.BranchCode,E.ENTITY_CODE

END

--SELECT DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)


--select * from [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetTypesofExpense
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetTypesofExpense]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminMaster>
--=============================================
@pMonth nvarchar(15),
@pYear int
AS 
BEGIN 
SET NOCOUNT ON;

--select T.BranchName,T.SEGMENT_NAME,T.Balance,T.ACCOUNT_DESCRIPTION,O.ExpenseTypes
--from [FranchiseFeesCalc].[dbo].[tblOracleMonthWiseTotal] T
--INNER JOIN [dbo].[OracleTypeMaping] O
--ON T.BRANCH_CODE=O.OracleCode

select T.BranchName,T.SEGMENT_NAME,T.Balance,T.ACCOUNT_DESCRIPTION,O.ExpenseTypes 
from [dbo].[tblOracleMonthWiseTotal] T

INNER JOIN [dbo].[OracleTypeMaping] O
ON T.BranchName=O.BranchName AND T.ACCOUNT_DESCRIPTION=O.ACCOUNT_DESCRIPTION
WHERE T.Months=@pMonth AND T.Years=@pYear

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pJVPostInsertUpdate
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pJVPostInsertUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pINVOICE_NUM nvarchar(30) ,
	@pINVOICE_TYPE_LOOKUP_CODE nvarchar(10) ,
	@pINVOICE_DATE nvarchar(20) ,
	@pVENDOR_NUM int ,
	@pVENDOR_SITE_CODE nvarchar(10) ,
	@pINVOICE_AMOUNT decimal(18, 2),
	@pINVOICE_CURRENCY_CODE nvarchar(5) ,
	@pTERMS_NAME nvarchar(10) ,
	@pDescription nvarchar(200) ,
	@pSTATUS nvarchar(20) ,
	@pSOURCE nvarchar(20) ,
	@pDOC_CATEGORY_CODE nvarchar(15) ,
	@pPAYMENT_METHOD_LOOKUP_CODE nvarchar(15) ,
	@pGL_DATE nvarchar(20) ,
	@pORG_ID int ,
	@pLINE_NUMBER int ,
	@pLINE_TYPE_LOOKUP_CODE nvarchar(15) ,
	@pLINE_AMOUNT decimal(18, 2) ,
	@pLine_DESCRIPTION nvarchar(200) ,
	@pDIST_LINE_NUMBER nvarchar(20),
	@pDIST_AMOUNT nvarchar(20) ,
	@pDIST_CODE_CONCATENATED nvarchar(70) ,
	@pACCOUNTING_DATE nvarchar(20) ,
	@pDIST_DESCRIPTION nvarchar(200) ,
	@pPAY_GROUP_LOOKUP_CODE nvarchar(50) ,
	@pSEGMENT_1 nvarchar(30) ,
	@pSEGMENT_2 nvarchar(30) ,
	@pSEGMENT_3 nvarchar(30) ,
	@pSEGMENT_4 nvarchar(30) ,
	@pSEGMENT_5 nvarchar(30) ,
	@pSEGMENT_6 nvarchar(30) ,
	@pSEGMENT_7 nvarchar(30) ,
	@pSEGMENT_8 nvarchar(30) ,
	@pSEGMENT_9 nvarchar(30) ,
	@pSEGMENT_10 nvarchar(30) ,
	@pSEGMENT_11 nvarchar(30) ,
	@pASSETS_TRACKING_FLAG nvarchar(50) ,
	@pATTRIBUTE_CATEGORY nvarchar(10) ,
	@pATTRIBUTE1 nvarchar(30) ,
	@pATTRIBUTE2 nvarchar(30) ,
	@pATTRIBUTE3 nvarchar(30) ,
	@pATTRIBUTE4 nvarchar(30) ,
	@pATTRIBUTE5 nvarchar(30) ,
	@pATTRIBUTE6 nvarchar(30) ,
	@pATTRIBUTE7 nvarchar(30) ,
	@pATTRIBUTE8 nvarchar(30) ,
	@pATTRIBUTE9 nvarchar(30) ,
	@pATTRIBUTE10 nvarchar(30) ,
	@pATTRIBUTE11 nvarchar(30) ,
	@pATTRIBUTE12 nvarchar(30) ,
	@pATTRIBUTE13 nvarchar(30) ,
	@pATTRIBUTE14 nvarchar(30) ,
	@pATTRIBUTE15 nvarchar(30) ,
	@pDIST_ATTRIBUTE_CATEGORY nvarchar(30) ,
	@pDIST_ATTRIBUTE1 nvarchar(30) ,
	@pDIST_ATTRIBUTE2 nvarchar(30) ,
	@pDIST_ATTRIBUTE3 nvarchar(30) ,
	@pDIST_ATTRIBUTE4 nvarchar(30) ,
	@pDIST_ATTRIBUTE5 nvarchar(30) ,
	@pDIST_GLOBAL_ATT_CATEGORY nvarchar(30) ,
	@pGLOBAL_ATTRIBUTE1 nvarchar(30) ,
	@pGLOBAL_ATTRIBUTE2 nvarchar(30) ,
	@pGLOBAL_ATTRIBUTE3 nvarchar(30) ,
	@pGLOBAL_ATTRIBUTE4 nvarchar(30) ,
	@pGLOBAL_ATTRIBUTE5 nvarchar(30) ,
	@pPREPAY_NUM nvarchar(20) ,
	@pPREPAY_DIST_NUM nvarchar(20) ,
	@pPREPAY_APPLY_AMOUNT nvarchar(20) ,
	@pPREPAY_GL_DATE nvarchar(20) ,
	@pINVOICE_INCLUDES_PREPAY_FLAG nvarchar(30) ,
	@pPREPAY_LINE_NUM nvarchar(20) ,
	@pCREATED_BY nvarchar(30) ,
	@pCREATION_DATE nvarchar(20),
	@pPROCESSED_STATUS nvarchar(200) ,
	@pERROR_MESSAGE nvarchar(50) ,
	@pINVOICE_STATUS nvarchar(100) ,
	@pBATCH_NAME nvarchar(50) 

	
	
AS
BEGIN
SET NOCOUNT ON;
BEGIN
INSERT INTO   [dbo].[FRANCHISE_JV](
		[INVOICE_NUM]
      ,[INVOICE_TYPE_LOOKUP_CODE]
      ,[INVOICE_DATE]
      ,[VENDOR_NUM]
      ,[VENDOR_SITE_CODE]
      ,[INVOICE_AMOUNT]
      ,[INVOICE_CURRENCY_CODE]
      ,[TERMS_NAME]
      ,[Description]
      ,[STATUS]
      ,[SOURCE]
      ,[DOC_CATEGORY_CODE]
      ,[PAYMENT_METHOD_LOOKUP_CODE]
      ,[GL_DATE]
      ,[ORG_ID]
      ,[LINE_NUMBER]
      ,[LINE_TYPE_LOOKUP_CODE]
      ,[LINE_AMOUNT]
      ,[Line_DESCRIPTION]
      ,[DIST_LINE_NUMBER]
      ,[DIST_AMOUNT]
      ,[DIST_CODE_CONCATENATED]
      ,[ACCOUNTING_DATE]
      ,[DIST_DESCRIPTION]
      ,[PAY_GROUP_LOOKUP_CODE]
      ,[SEGMENT_1]
      ,[SEGMENT_2]
      ,[SEGMENT_3]
      ,[SEGMENT_4]
      ,[SEGMENT_5]
      ,[SEGMENT_6]
      ,[SEGMENT_7]
      ,[SEGMENT_8]
      ,[SEGMENT_9]
      ,[SEGMENT_10]
      ,[SEGMENT_11]
      ,[ASSETS_TRACKING_FLAG]
      ,[ATTRIBUTE_CATEGORY]
      ,[ATTRIBUTE1]
      ,[ATTRIBUTE2]
      ,[ATTRIBUTE3]
      ,[ATTRIBUTE4]
      ,[ATTRIBUTE5]
      ,[ATTRIBUTE6]
      ,[ATTRIBUTE7]
      ,[ATTRIBUTE8]
      ,[ATTRIBUTE9]
      ,[ATTRIBUTE10]
      ,[ATTRIBUTE11]
      ,[ATTRIBUTE12]
      ,[ATTRIBUTE13]
      ,[ATTRIBUTE14]
      ,[ATTRIBUTE15]
      ,[DIST_ATTRIBUTE_CATEGORY]
      ,[DIST_ATTRIBUTE1]
      ,[DIST_ATTRIBUTE2]
      ,[DIST_ATTRIBUTE3]
      ,[DIST_ATTRIBUTE4]
      ,[DIST_ATTRIBUTE5]
      ,[DIST_GLOBAL_ATT_CATEGORY]
      ,[GLOBAL_ATTRIBUTE1]
      ,[GLOBAL_ATTRIBUTE2]
      ,[GLOBAL_ATTRIBUTE3]
      ,[GLOBAL_ATTRIBUTE4]
      ,[GLOBAL_ATTRIBUTE5]
      ,[PREPAY_NUM]
      ,[PREPAY_DIST_NUM]
      ,[PREPAY_APPLY_AMOUNT]
      ,[PREPAY_GL_DATE]
      ,[INVOICE_INCLUDES_PREPAY_FLAG]
      ,[PREPAY_LINE_NUM]
      ,[CREATED_BY]
      ,[CREATION_DATE]
      ,[PROCESSED_STATUS]
      ,[ERROR_MESSAGE]
      ,[INVOICE_STATUS]
      ,[BATCH_NAME]
	)
VALUES (
	  @pINVOICE_NUM
      ,@pINVOICE_TYPE_LOOKUP_CODE
      ,@pINVOICE_DATE
      ,@pVENDOR_NUM
      ,@pVENDOR_SITE_CODE
      ,@pINVOICE_AMOUNT
      ,@pINVOICE_CURRENCY_CODE
      ,@pTERMS_NAME
      ,@pDescription
      ,@pSTATUS
      ,@pSOURCE
      ,@pDOC_CATEGORY_CODE
      ,@pPAYMENT_METHOD_LOOKUP_CODE
      ,@pGL_DATE
      ,@pORG_ID
      ,@pLINE_NUMBER
      ,@pLINE_TYPE_LOOKUP_CODE
      ,@pLINE_AMOUNT
      ,@pLine_DESCRIPTION
      ,@pDIST_LINE_NUMBER
      ,@pDIST_AMOUNT
      ,@pDIST_CODE_CONCATENATED
      ,@pACCOUNTING_DATE
      ,@pDIST_DESCRIPTION
      ,@pPAY_GROUP_LOOKUP_CODE
      ,@pSEGMENT_1
      ,@pSEGMENT_2
      ,@pSEGMENT_3
      ,@pSEGMENT_4
      ,@pSEGMENT_5
      ,@pSEGMENT_6
      ,@pSEGMENT_7
      ,@pSEGMENT_8
      ,@pSEGMENT_9
      ,@pSEGMENT_10
      ,@pSEGMENT_11
      ,@pASSETS_TRACKING_FLAG
      ,@pATTRIBUTE_CATEGORY
      ,@pATTRIBUTE1
      ,@pATTRIBUTE2
      ,@pATTRIBUTE3
      ,@pATTRIBUTE4
      ,@pATTRIBUTE5
      ,@pATTRIBUTE6
      ,@pATTRIBUTE7
      ,@pATTRIBUTE8
      ,@pATTRIBUTE9
      ,@pATTRIBUTE10
      ,@pATTRIBUTE11
      ,@pATTRIBUTE12
      ,@pATTRIBUTE13
      ,@pATTRIBUTE14
      ,@pATTRIBUTE15
      ,@pDIST_ATTRIBUTE_CATEGORY
      ,@pDIST_ATTRIBUTE1
      ,@pDIST_ATTRIBUTE2
      ,@pDIST_ATTRIBUTE3
      ,@pDIST_ATTRIBUTE4
      ,@pDIST_ATTRIBUTE5
      ,@pDIST_GLOBAL_ATT_CATEGORY
      ,@pGLOBAL_ATTRIBUTE1
      ,@pGLOBAL_ATTRIBUTE2
      ,@pGLOBAL_ATTRIBUTE3
      ,@pGLOBAL_ATTRIBUTE4
      ,@pGLOBAL_ATTRIBUTE5
      ,@pPREPAY_NUM
      ,@pPREPAY_DIST_NUM
      ,@pPREPAY_APPLY_AMOUNT
      ,@pPREPAY_GL_DATE
      ,@pINVOICE_INCLUDES_PREPAY_FLAG
      ,@pPREPAY_LINE_NUM
      ,@pCREATED_BY
      ,@pCREATION_DATE
      ,@pPROCESSED_STATUS
      ,@pERROR_MESSAGE
      ,@pINVOICE_STATUS
      ,@pBATCH_NAME
	 );
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMissMatch_B2BRecords_06Nov2025
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pMissMatch_B2BRecords_06Nov2025]  
AS   
BEGIN   
SET NOCOUNT ON;  
INSERT INTO [dbo].[tblMisMatchB2BRecord]  
select distinct(sb),S.Branch,Category,REPLACE(sb+'_'+S.Branch,' ','')AS SbBrnCat,0 AS IsUpdated  
from [FranchiseFeesCalc].[dbo].[tblFranchise] S (NOLOCK)  
left join [SB_COMP].[dbo].SB_Broker (NOLOCK)   
on  
SBTAG=S.sb  
where OrgType in ('CO','I','P','PF') and Category='B2C'  
AND NOT EXISTS (SELECT sb,Branch,Category,SbBrnCat  
 FROM FranchiseFeesCalc.dbo.tblMisMatchB2BRecord (NOLOCK) WHERE SbBrnCat=sb+'_'+S.Branch)  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMissMatch_B2BRecords_tobedeleted09jan2026
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pMissMatch_B2BRecords]  
AS   
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SET NOCOUNT ON;  
INSERT INTO [dbo].[tblMisMatchB2BRecord]  
select distinct(sb),S.Branch,Category,REPLACE(sb+'_'+S.Branch,' ','')AS SbBrnCat,0 AS IsUpdated  
from [FranchiseFeesCalc].[dbo].[tblFranchise] S (NOLOCK)  
left join [SB_COMP].[dbo].SB_Broker (NOLOCK)   
on  
SBTAG=S.sb  
where OrgType in ('CO','I','P','PF') and Category='B2C'  
AND NOT EXISTS (SELECT sb,Branch,Category,SbBrnCat  
 FROM FranchiseFeesCalc.dbo.tblMisMatchB2BRecord (NOLOCK) WHERE SbBrnCat=sb+'_'+S.Branch)  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMissMatch_FromtblMisMatchB2Brecord
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pMissMatch_FromtblMisMatchB2Brecord]
AS 
BEGIN 
SET NOCOUNT ON;
select sb,Branch
from [dbo].[tblMisMatchB2BRecord] (NOLOCK)
where  IsUpdated=0

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMovetoOracle_History
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pMovetoOracle_History]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,04/02/2020>
--Discription:		<Description,,Get the total by segment>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
--Delete last third month data from [tbl_ANGEL_ACCOUNT_ANALYSIS_History]
IF(SELECT COUNT(*) FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS_History]
WHERE Months=MONTH(DATEADD(month, -3, GETDATE())) AND Years=YEAR(DATEADD(month, -3, GETDATE())))>0
BEGIN
DELETE [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS_History]
END

--Move last second month data to [tbl_ANGEL_ACCOUNT_ANALYSIS_History]
IF(SELECT COUNT(*) FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS_History]
WHERE Months=MONTH(DATEADD(month, -2, GETDATE())) AND Years=YEAR(DATEADD(month, -2, GETDATE())))=0
BEGIN
	INSERT INTO [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS_History]
	SELECT *,MONTH(DATEADD(month, -2, GETDATE())),YEAR(DATEADD(month, -2, GETDATE())) FROM [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]

	DELETE [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]
END

END


--select * from [dbo].[tblOracleMonthWiseTotal]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pOracleCalculationDelete
-- --------------------------------------------------



Create PROCEDURE [dbo].[pOracleCalculationDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AdminDashboard based on ID>
--=============================================
@pMonths int,
@pYears int,
@pModifiedBy nvarchar(30)

AS
BEGIN
SET NOCOUNT ON

DELETE [dbo].[tblOracleMonthWiseTotal] WHERE Months=@pMonths AND Years=@pYears

UPDATE [dbo].[FranchiseeCalcBtnStages] 
SET Stage_7=0,
ModifiedOn=GETDATE(),
ModifiedBy=@pModifiedBy 

WHERE Months=@pMonths AND Years=@pYears
END


--select * from [dbo].[FranchiseeCalcBtnStages]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pOracleTypeMappingUpdate
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pOracleTypeMappingUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pBranchCode int,
	@pBranchName nvarchar(10),
	@pAccountDescription nvarchar(max),
	@pAccountCode int,
	@pExpenseTypes  nvarchar(30),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF(@pID=0)
	BEGIN
		INSERT INTO [dbo].[OracleTypeMaping] VALUES(@pBranchName,@pBranchCode,@pAccountDescription,@pAccountCode,@pExpenseTypes)
	END
ELSE
	BEGIN
		UPDATE [dbo].[OracleTypeMaping] 
		SET	ExpenseTypes=@pExpenseTypes
		WHERE ID=@pID
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBTagAllForExceptional_06Nov2025
-- --------------------------------------------------
    
    
    
CREATE PROCEDURE [dbo].[pSBTagAllForExceptional_06Nov2025]    
--=============================================    
--Author:   <Author,,Akidut>    
--Created Date:  <Created Date,,23/10/2019>    
--Discription:  <Description,,Insert and Update for AdminMaster>    
--=============================================    
AS     
BEGIN     
SET NOCOUNT ON;    
     
SELECT SBTAG from [SB_COMP].[dbo].[SB_Broker] S (NOLOCK)    
inner join    
[CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F (NOLOCK)    
ON    
S.Branch=F.FTag     
WHERE S.Branch !='' AND F.ToDate>GETDATE() AND S.SBTAG!='T A G'    
END    
    
--select * from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F    
    
--SELECT * from [SB_COMP].[dbo].[SB_Broker] S

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBTagAllForExceptional_tobedeleted09jan2026
-- --------------------------------------------------
    
    
    
CREATE PROCEDURE [dbo].[pSBTagAllForExceptional]    
--=============================================    
--Author:   <Author,,Akidut>    
--Created Date:  <Created Date,,23/10/2019>    
--Discription:  <Description,,Insert and Update for AdminMaster>    
--=============================================    
AS     
BEGIN     
SET NOCOUNT ON;    
 
 insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SELECT SBTAG from [SB_COMP].[dbo].[SB_Broker] S (NOLOCK)    
inner join    
[CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F (NOLOCK)    
ON    
S.Branch=F.FTag     
WHERE S.Branch !='' AND F.ToDate>GETDATE() AND S.SBTAG!='T A G'    
END    
    
--select * from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] F    
    
--SELECT * from [SB_COMP].[dbo].[SB_Broker] S

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdateExceptional
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pUpdateExceptional]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
@pSBTag nvarchar(10),
@pBranch nvarchar(5),
@pCategory nvarchar(5),
@pIncomePercent decimal(18,2),
@pITrdBrok decimal(18,2),
@pITradechar decimal(18,2),
@pUpdatedBy nvarchar(30)
--@pUpdatedOn datetime


AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT ID FROM  [dbo].[tblExceptional] (NOLOCK)
WHERE sb=@pSBTag AND Branch=@pBranch
)
BEGIN
INSERT INTO [dbo].[tblExceptional]  (
	sb,
	Branch,
	Category,
	ITrdBrok,
	ITradechar,
	SB_Branch,	
	IncomePercent,	
	IsActive,	
	UpdatedOn,	
	UpdatedBy
	)
VALUES (
	@pSBTag,
	@pBranch,
	@pCategory,
	@pITrdBrok,
	@pITradechar,
	@pSBTag+'_'+@pBranch,	
	@pIncomePercent,	
	1,	
	GETDATE(),	
	@pUpdatedBy	
	 );
END

ELSE
BEGIN
	
UPDATE [dbo].[tblExceptional]
SET	Category=@pCategory,
IncomePercent=@pIncomePercent,
ITrdBrok=@pITrdBrok,
ITradechar=@pITradechar,
UpdatedBy=@pUpdatedBy,
UpdatedOn=GETDATE()
WHERE sb=@pSBTag AND Branch=@pBranch

END
END

select * from [dbo].[tblExceptional]

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdateExpectionData
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pUpdateExpectionData]
AS 
BEGIN 
SET NOCOUNT ON;

IF(SELECT COUNT(*) FROM [FranchiseFeesCalc].[dbo].[tblExceptional] WHERE IsActive=1)>0
BEGIN


DECLARE @SbTag nvarchar(20)

DECLARE MY_CURSOR CURSOR 
  LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT sb FROM [FranchiseFeesCalc].[dbo].[tblExceptional] WHERE IsActive=1

OPEN MY_CURSOR

FETCH NEXT FROM MY_CURSOR INTO @SbTag

WHILE @@FETCH_STATUS = 0

BEGIN 

UPDATE [FranchiseFeesCalc].[dbo].[tblFranchise]
SET category=E1.category,
	DUMMY=E1.IncomePercent
	--ITrdBrok=E1.ITrdBrok,
	--ITradechar=E1.ITradechar,
	--Gross_Normal=CASE WHEN (E1.ITrdBrok+E1.ITradechar)=0 THEN brok_earned ELSE 0 END,
	--SB_Normal=CASE WHEN (E1.ITrdBrok+E1.ITradechar)=0 THEN (remi_share+sub_remi_share) ELSE 0 END,
	--SB_ItardeBrok=(E1.ITrdBrok-ITradeBrokAngel),
	--SB_ItardeChar=(E1.ITradechar-ITradeCharAngel)
FROM [FranchiseFeesCalc].[dbo].[tblFranchise] F1
INNER JOIN [FranchiseFeesCalc].[dbo].[tblExceptional] E1
ON F1.sb=E1.sb
WHERE F1.sb=@SbTag

FETCH NEXT FROM MY_CURSOR INTO @SbTag
END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR

END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdateFranchise_Stages
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pUpdateFranchise_Stages]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pMonths	int,
	@pYears		int,
	@pStage_1	bit=NULL,
	@pStage_2	bit=NULL,
	@pStage_3	bit=NULL,
	@pStage_4	bit=NULL,
	@pStage_5	bit=NULL,
	@pStage_6	bit=NULL,
	@pStage_7	bit=NULL,
	@pFinal_Stage bit=NULL,
	
	@pModifiedBy nvarchar(30)='Akidut',
	@pSystemIP   nvarchar(25)='1.1.1.1',
	@pID         bigint=NULL
	
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT ID FROM [dbo].[FranchiseeCalcBtnStages]
WHERE Months=@pMonths AND Years=@pYears
)
BEGIN
INSERT INTO  [dbo].[FranchiseeCalcBtnStages] (
	Months,
	Years,
	Stage_1,
	Stage_2,
	Stage_3,
	Stage_4,
	Stage_5,
	Stage_6,
	Stage_7,
	Final_Stage,
	ModifiedOn ,
	ModifiedBy,
	SystemIP
	)
VALUES (
	@pMonths,	
	@pYears,		
	@pStage_1,	
	@pStage_2,	
	@pStage_3,	
	@pStage_4,	
	@pStage_5,	
	@pStage_6,	
	@pStage_7,	
	@pFinal_Stage,
	GETDATE(),
	@pModifiedBy,
	@pSystemIP 
	       
	
	 );
END

ELSE
BEGIN
UPDATE  [dbo].[FranchiseeCalcBtnStages]
SET	
	Stage_1=@pStage_1,	
	Stage_2=@pStage_2,	
	Stage_3=@pStage_3,	
	Stage_4=@pStage_4,	
	Stage_5=@pStage_5,	
	Stage_6=@pStage_6,	
	Stage_7=@pStage_7,	
Final_Stage=@pFinal_Stage,
ModifiedOn=	GETDATE(),
ModifiedBy=	@pModifiedBy,
SystemIP=	@pSystemIP 

WHERE  Months=@pMonths AND Years=@pYears
END


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdateMisMatchB2CtoB2B
-- --------------------------------------------------
  
  
  
  
CREATE PROCEDURE [dbo].[pUpdateMisMatchB2CtoB2B]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Insert and Update for AdminDashboard>  
--=============================================  
@pCategory nvarchar(5),  
@pSBTag nvarchar(10),  
@pBranch nvarchar(10)  
  
AS  
BEGIN  
SET NOCOUNT ON;  
  
  
--UPDATE tblFranchise  
--SET Category=@pCategory ,IsMissMatchUpdated=1    
--WHERE sb=@pSBTag  
   
UPDATE [dbo].[tblMisMatchB2BRecord]  
SET Category=@pCategory, IsUpdated=1  
WHERE sb=@pSBTag  
  
  
SELECT * INTO #Temp FROM (SELECT B2B_IncomePercent,B2C_IncomePercent FROM [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE Ftag=@pBranch )data  
  
IF EXISTS(SELECT Branch FROM [dbo].[tblExceptional] WHERE sb=@pSBTag)  
 BEGIN  
  UPDATE [dbo].[tblExceptional]  
  SET Category=@pCategory,  
  IncomePercent= CASE WHEN @pCategory='B2B' THEN (SELECT TOP 1 B2B_IncomePercent FROM #Temp) ELSE  (SELECT TOP 1 B2C_IncomePercent FROM #Temp) END  
  WHERE sb=@pSBTag  
 END  
ELSE  
 BEGIN  
  INSERT INTO [dbo].[tblExceptional] VALUES(@pSBTag,@pBranch,@pCategory,50,100,@pSBTag+'_'+@pBranch,  
  CASE WHEN @pCategory='B2B' THEN (SELECT TOP 1 B2B_IncomePercent FROM #Temp) ELSE  (SELECT TOP 1 B2C_IncomePercent FROM #Temp) END,  
  1,GETDATE(),'User1',NULL,NULL)  
 END  
  
DROP Table #Temp  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUploadBNBCInsertUpdate
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pUploadBNBCInsertUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pBranchCode  int,
	@pBranchName  nvarchar(10) ,
	@pCreatedBy nvarchar(30)
	
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT BranchCode FROM [dbo].[tbl_BranchCode_BranchName] (NOLOCK)
WHERE BranchCode=@pBranchCode
)
BEGIN
INSERT INTO  [dbo].[tbl_BranchCode_BranchName] (
	BranchCode,
	BranchName,
	CreatedOn ,
	CreatedBy,
	IsActive
	)
VALUES (
	@pBranchCode,
	@pBranchName,
	GETDATE() ,
	@pCreatedBy,
	1
	 );
END

ELSE
BEGIN
UPDATE  [dbo].[tbl_BranchCode_BranchName]
SET	BranchCode=@pBranchCode,
	BranchName=@pBranchName,
	CreatedOn=GETDATE(),
	CreatedBy=@pCreatedBy
	

WHERE BranchCode=@pBranchCode
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUploadOtherChargesInsertUpdate
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pUploadOtherChargesInsertUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AdminDashboard>
--=============================================
	@pApplyDate  datetime ,
	@pBranch  nvarchar(10) ,
	@pCategory  nvarchar(5) ,
	@pRemarks nvarchar(max),
	@pSegment  nvarchar(20),
	@pGross_Other  decimal,
	@pSB_Other decimal,
	@pBrokerage_Paid decimal,
	@pOps_Other decimal,
	@pCreatedBy  nvarchar(20),
	@pID bigint,
	@err_message nvarchar(25)=NULL
	
	
AS
BEGIN
SET NOCOUNT ON;
IF exists(SELECT segment,sauda_date,branch,Category,SB_Other,Gross_Other,RemarksforOtherCharges,Ops_Other,Brokerage_Paid 
FROM [dbo].[OtherCharges] (NOLOCK) 
WHERE sauda_date=@pApplyDate AND branch=@pBranch 
AND Category=@pCategory AND RemarksforOtherCharges=@pRemarks 
AND segment=@pSegment AND SB_Other=@pSB_Other 
AND Gross_Other=@pGross_Other AND Brokerage_Paid=@pBrokerage_Paid 
AND Ops_Other=@pOps_Other)
BEGIN
SET @err_message = 'Update Failed ! Duplicates Record Found'
END
ELSE
BEGIN
IF not exists 
(
SELECT ID FROM [dbo].[OtherCharges] (NOLOCK)
WHERE ID=@pID
)
BEGIN
INSERT INTO  [dbo].[OtherCharges] (
	sauda_date,
	branch,
	Category  ,
	RemarksforOtherCharges,
	segment,
	SB_Other ,
	Gross_Other,
	Brokerage_Paid,
	Ops_Other,
	OtherChargesUpdatedOn ,
	OtherchargesCreatedBy,
	IsActive
	)
VALUES (
	@pApplyDate,
	@pBranch,
	@pCategory  ,
	@pRemarks,
	@pSegment,
	@pSB_Other ,
	@pGross_Other,
	@pBrokerage_Paid,
	@pOps_Other,
	GETDATE() ,
	@pCreatedBy,
	1
	 );
END

ELSE
BEGIN
UPDATE  [dbo].[OtherCharges]
SET	sauda_date=@pApplyDate,
	branch=@pBranch,
	Category=@pCategory,
	RemarksforOtherCharges=@pRemarks,
	segment=@pSegment,
	SB_Other=@pSB_Other,
	Gross_Other=@pGross_Other,
	Brokerage_Paid=@pBrokerage_Paid,
	Ops_Other=@pOps_Other,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pCreatedBy

WHERE ID=@pID
END
	END
		END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pVendorNoMappingWithBranch
-- --------------------------------------------------
  
  
  
CREATE PROCEDURE [dbo].[pVendorNoMappingWithBranch]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Insert and Update for AdminMaster>  
--=============================================  
AS   
BEGIN   
SET NOCOUNT ON;  
  
select DISTINCT(SBTag+'_'+Segment) AS SBTag,vendor_number  
from [SB_COMP].[dbo].vendor_mapping  
WHERE SBTAG in (SELECT DISTINCT  Ftag from [CSOKYC-6].[Franchisee].[dbo].[Franchisee_Mast] WHERE ToDate>getdate() )  
GROUP BY SBTag,vendor_number,Segment  
  
  
END

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
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
CREATE PROCEDURE usp_findInUSP          
@dbname varchar(500),        
@srcstr varchar(500)          
AS          
          
 set nocount on        
 set @srcstr  = '%' + @srcstr + '%'          
        
 declare @str as varchar(1000)        
 set @str=''        
 if @dbname <>''        
 Begin        
 set @dbname=@dbname+'.dbo.'        
 End        
 else        
 begin        
 set @dbname=db_name()+'.dbo.'        
 End        
 print @dbname        
        
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '         
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '         
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''          
 print @str        
  exec(@str)        
set nocount off

GO

-- --------------------------------------------------
-- TABLE dbo.FRANCHISE_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[FRANCHISE_JV]
(
    [INVOICE_NUM] NVARCHAR(30) NULL,
    [INVOICE_TYPE_LOOKUP_CODE] NVARCHAR(10) NULL,
    [INVOICE_DATE] NVARCHAR(20) NULL,
    [VENDOR_NUM] INT NULL,
    [VENDOR_SITE_CODE] NVARCHAR(10) NULL,
    [INVOICE_AMOUNT] DECIMAL(18, 2) NULL,
    [INVOICE_CURRENCY_CODE] NVARCHAR(5) NULL,
    [TERMS_NAME] NVARCHAR(10) NULL,
    [Description] NVARCHAR(200) NULL,
    [STATUS] NVARCHAR(20) NULL,
    [SOURCE] NVARCHAR(20) NULL,
    [DOC_CATEGORY_CODE] NVARCHAR(15) NULL,
    [PAYMENT_METHOD_LOOKUP_CODE] NVARCHAR(15) NULL,
    [GL_DATE] NVARCHAR(20) NULL,
    [ORG_ID] INT NULL,
    [LINE_NUMBER] INT NULL,
    [LINE_TYPE_LOOKUP_CODE] NVARCHAR(15) NULL,
    [LINE_AMOUNT] DECIMAL(18, 2) NULL,
    [Line_DESCRIPTION] NVARCHAR(200) NULL,
    [DIST_LINE_NUMBER] NVARCHAR(20) NULL,
    [DIST_AMOUNT] NVARCHAR(20) NULL,
    [DIST_CODE_CONCATENATED] NVARCHAR(70) NULL,
    [ACCOUNTING_DATE] NVARCHAR(20) NULL,
    [DIST_DESCRIPTION] NVARCHAR(200) NULL,
    [PAY_GROUP_LOOKUP_CODE] NVARCHAR(50) NULL,
    [SEGMENT_1] NVARCHAR(30) NULL,
    [SEGMENT_2] NVARCHAR(30) NULL,
    [SEGMENT_3] NVARCHAR(30) NULL,
    [SEGMENT_4] NVARCHAR(30) NULL,
    [SEGMENT_5] NVARCHAR(30) NULL,
    [SEGMENT_6] NVARCHAR(30) NULL,
    [SEGMENT_7] NVARCHAR(30) NULL,
    [SEGMENT_8] NVARCHAR(30) NULL,
    [SEGMENT_9] NVARCHAR(30) NULL,
    [SEGMENT_10] NVARCHAR(30) NULL,
    [SEGMENT_11] NVARCHAR(30) NULL,
    [ASSETS_TRACKING_FLAG] NVARCHAR(50) NULL,
    [ATTRIBUTE_CATEGORY] NVARCHAR(10) NULL,
    [ATTRIBUTE1] NVARCHAR(30) NULL,
    [ATTRIBUTE2] NVARCHAR(30) NULL,
    [ATTRIBUTE3] NVARCHAR(30) NULL,
    [ATTRIBUTE4] NVARCHAR(30) NULL,
    [ATTRIBUTE5] NVARCHAR(30) NULL,
    [ATTRIBUTE6] NVARCHAR(30) NULL,
    [ATTRIBUTE7] NVARCHAR(30) NULL,
    [ATTRIBUTE8] NVARCHAR(30) NULL,
    [ATTRIBUTE9] NVARCHAR(30) NULL,
    [ATTRIBUTE10] NVARCHAR(30) NULL,
    [ATTRIBUTE11] NVARCHAR(30) NULL,
    [ATTRIBUTE12] NVARCHAR(30) NULL,
    [ATTRIBUTE13] NVARCHAR(30) NULL,
    [ATTRIBUTE14] NVARCHAR(30) NULL,
    [ATTRIBUTE15] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE_CATEGORY] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE1] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE2] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE3] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE4] NVARCHAR(30) NULL,
    [DIST_ATTRIBUTE5] NVARCHAR(30) NULL,
    [DIST_GLOBAL_ATT_CATEGORY] NVARCHAR(30) NULL,
    [GLOBAL_ATTRIBUTE1] NVARCHAR(30) NULL,
    [GLOBAL_ATTRIBUTE2] NVARCHAR(30) NULL,
    [GLOBAL_ATTRIBUTE3] NVARCHAR(30) NULL,
    [GLOBAL_ATTRIBUTE4] NVARCHAR(30) NULL,
    [GLOBAL_ATTRIBUTE5] NVARCHAR(30) NULL,
    [PREPAY_NUM] NVARCHAR(20) NULL,
    [PREPAY_DIST_NUM] NVARCHAR(20) NULL,
    [PREPAY_APPLY_AMOUNT] NVARCHAR(20) NULL,
    [PREPAY_GL_DATE] NVARCHAR(20) NULL,
    [INVOICE_INCLUDES_PREPAY_FLAG] NVARCHAR(20) NULL,
    [PREPAY_LINE_NUM] NVARCHAR(20) NULL,
    [CREATED_BY] NVARCHAR(30) NULL,
    [CREATION_DATE] NVARCHAR(20) NULL,
    [PROCESSED_STATUS] NVARCHAR(200) NULL,
    [ERROR_MESSAGE] NVARCHAR(50) NULL,
    [INVOICE_STATUS] NVARCHAR(100) NULL,
    [BATCH_NAME] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FranchiseeCalcBtnStages
-- --------------------------------------------------
CREATE TABLE [dbo].[FranchiseeCalcBtnStages]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Months] VARCHAR(15) NULL,
    [Years] INT NULL,
    [Stage_1] BIT NULL,
    [Stage_2] BIT NULL,
    [Stage_3] BIT NULL,
    [Stage_4] BIT NULL,
    [Stage_5] BIT NULL,
    [Stage_6] BIT NULL,
    [Stage_7] BIT NULL,
    [Final_Stage] BIT NULL,
    [ModifiedBy] NVARCHAR(30) NULL,
    [ModifiedOn] DATETIME NULL,
    [SystemIP] NVARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OracleTypeMaping
-- --------------------------------------------------
CREATE TABLE [dbo].[OracleTypeMaping]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [BranchName] NVARCHAR(15) NOT NULL,
    [OracleCode] INT NOT NULL,
    [ACCOUNT_DESCRIPTION] NVARCHAR(MAX) NOT NULL,
    [ACCOUNT_CODE] INT NOT NULL,
    [ExpenseTypes] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OtherCharges
-- --------------------------------------------------
CREATE TABLE [dbo].[OtherCharges]
(
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [branch] VARCHAR(50) NULL,
    [Category] NVARCHAR(5) NULL,
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [SB_Other] DECIMAL(18, 2) NULL,
    [Gross_Other] DECIMAL(18, 2) NULL,
    [RemarksforOtherCharges] NVARCHAR(MAX) NULL,
    [OtherChargesUpdatedOn] DATETIME NULL,
    [OtherchargesCreatedBy] NVARCHAR(50) NULL,
    [IsActive] BIT NULL,
    [DeletedBy] NVARCHAR(50) NULL,
    [DeletedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(50) NULL,
    [UpdatedOn] DATETIME NULL,
    [Ops_Other] DECIMAL(18, 2) NULL,
    [Brokerage_Paid] DECIMAL(18, 0) NULL
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
-- TABLE dbo.tbl_ANGEL_ACCOUNT_ANALYSIS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS]
(
    [ACCOUNTED_DR] DECIMAL(18, 0) NULL,
    [ACCOUNTED_CR] DECIMAL(18, 0) NULL,
    [ACCOUNT_CODE] INT NULL,
    [ACCOUNT_DESCRIPTION] NVARCHAR(250) NULL,
    [BRANCH_CODE] INT NULL,
    [ENTITY_CODE] INT NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [VENDOR_NUM] INT NULL,
    [VENDOR_NAME] NVARCHAR(200) NULL,
    [VENDOR_TYPE_LOOKUP_CODE] NVARCHAR(200) NULL,
    [VENDOR_SITE] NVARCHAR(200) NULL,
    [DOC_SEQUENCE_VALUE] NVARCHAR(200) NULL,
    [INVOICE_NUM] NVARCHAR(200) NULL,
    [PERIOD_NAME] NVARCHAR(200) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [LEDGER_ID] NVARCHAR(200) NULL,
    [LEDGER_NAME] NVARCHAR(200) NULL,
    [DISTRIBUTION_LINE_NUMBER] NVARCHAR(200) NULL,
    [DISTRIBUTION_LINE_DESCRIPTION] NVARCHAR(400) NULL,
    [JOURNAL_DESCRIPTION] NVARCHAR(400) NULL,
    [ACCOUNT_TYPE] NVARCHAR(200) NULL,
    [ORG_ID] NVARCHAR(200) NULL,
    [CONCATENATED_SEGMENT] NVARCHAR(200) NULL,
    [ENTITY_DESCRIPTION] NVARCHAR(200) NULL,
    [BRANCH_DESCRIPTION] NVARCHAR(350) NULL,
    [DEPARTMENT_CODE] NVARCHAR(300) NULL,
    [DEPARTMENT_DESCRIPTION] NVARCHAR(200) NULL,
    [LOB_CODE] NVARCHAR(200) NULL,
    [LOB_DESCRIPTION] NVARCHAR(350) NULL,
    [INTERCOMPANY_CODE] NVARCHAR(300) NULL,
    [INTERCOMPANY_DESCRIPTION] NVARCHAR(200) NULL,
    [CHANNAL_CODE] NVARCHAR(300) NULL,
    [CHANNEL_DESCRIPTION] NVARCHAR(200) NULL,
    [PROJECT_CODE] NVARCHAR(300) NULL,
    [PROJECT_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE1_CODE] NVARCHAR(300) NULL,
    [FUTURE1_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE2_CODE] NVARCHAR(300) NULL,
    [FUTURE2_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE3_CODE] NVARCHAR(300) NULL,
    [FUTURE3_DESCRIPTION] NVARCHAR(200) NULL,
    [OPERATING_NAME] NVARCHAR(200) NULL,
    [JE_SOURCE] NVARCHAR(200) NULL,
    [JE_CATEGORY] NVARCHAR(200) NULL,
    [NAME] NVARCHAR(350) NULL,
    [ATTRIBUTE1] NVARCHAR(200) NULL,
    [CURRENCY_CODE] NVARCHAR(200) NULL,
    [POSTED_DATE] DATETIME NULL,
    [POSTING_STATUS] NVARCHAR(200) NULL,
    [CHART_OF_ACCOUNTS_ID] NVARCHAR(300) NULL,
    [DFF_FROM_DATE] NVARCHAR(300) NULL,
    [DFF_TO_DATE] NVARCHAR(300) NULL,
    [BILL_NO] NVARCHAR(300) NULL,
    [IO_ENTERED_BY] NVARCHAR(300) NULL,
    [IO_APPROVED_BY] NVARCHAR(300) NULL,
    [CODE_COMBINATION_ID] NVARCHAR(300) NULL,
    [INVOICE_ID] NVARCHAR(300) NULL,
    [JE_HEADER_ID] NVARCHAR(300) NULL,
    [JE_LINE_NUM] NVARCHAR(300) NULL,
    [ACCRUAL_REV_STATUS] NVARCHAR(300) NULL,
    [ACCRUAL_REV_JE_HEADER_ID] DECIMAL(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ANGEL_ACCOUNT_ANALYSIS_History
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ANGEL_ACCOUNT_ANALYSIS_History]
(
    [ACCOUNTED_DR] DECIMAL(18, 0) NULL,
    [ACCOUNTED_CR] DECIMAL(18, 0) NULL,
    [ACCOUNT_CODE] INT NULL,
    [ACCOUNT_DESCRIPTION] NVARCHAR(250) NULL,
    [BRANCH_CODE] INT NULL,
    [ENTITY_CODE] INT NULL,
    [ACCOUNTING_DATE] DATETIME NULL,
    [VENDOR_NUM] INT NULL,
    [VENDOR_NAME] NVARCHAR(200) NULL,
    [VENDOR_TYPE_LOOKUP_CODE] NVARCHAR(200) NULL,
    [VENDOR_SITE] NVARCHAR(200) NULL,
    [DOC_SEQUENCE_VALUE] NVARCHAR(200) NULL,
    [INVOICE_NUM] NVARCHAR(200) NULL,
    [PERIOD_NAME] NVARCHAR(200) NULL,
    [INVOICE_DATE] DATETIME NULL,
    [LEDGER_ID] NVARCHAR(200) NULL,
    [LEDGER_NAME] NVARCHAR(200) NULL,
    [DISTRIBUTION_LINE_NUMBER] NVARCHAR(200) NULL,
    [DISTRIBUTION_LINE_DESCRIPTION] NVARCHAR(400) NULL,
    [JOURNAL_DESCRIPTION] NVARCHAR(400) NULL,
    [ACCOUNT_TYPE] NVARCHAR(200) NULL,
    [ORG_ID] NVARCHAR(200) NULL,
    [CONCATENATED_SEGMENT] NVARCHAR(200) NULL,
    [ENTITY_DESCRIPTION] NVARCHAR(200) NULL,
    [BRANCH_DESCRIPTION] NVARCHAR(350) NULL,
    [DEPARTMENT_CODE] NVARCHAR(300) NULL,
    [DEPARTMENT_DESCRIPTION] NVARCHAR(200) NULL,
    [LOB_CODE] NVARCHAR(200) NULL,
    [LOB_DESCRIPTION] NVARCHAR(350) NULL,
    [INTERCOMPANY_CODE] NVARCHAR(300) NULL,
    [INTERCOMPANY_DESCRIPTION] NVARCHAR(200) NULL,
    [CHANNAL_CODE] NVARCHAR(300) NULL,
    [CHANNEL_DESCRIPTION] NVARCHAR(200) NULL,
    [PROJECT_CODE] NVARCHAR(300) NULL,
    [PROJECT_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE1_CODE] NVARCHAR(300) NULL,
    [FUTURE1_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE2_CODE] NVARCHAR(300) NULL,
    [FUTURE2_DESCRIPTION] NVARCHAR(200) NULL,
    [FUTURE3_CODE] NVARCHAR(300) NULL,
    [FUTURE3_DESCRIPTION] NVARCHAR(200) NULL,
    [OPERATING_NAME] NVARCHAR(200) NULL,
    [JE_SOURCE] NVARCHAR(200) NULL,
    [JE_CATEGORY] NVARCHAR(200) NULL,
    [NAME] NVARCHAR(350) NULL,
    [ATTRIBUTE1] NVARCHAR(200) NULL,
    [CURRENCY_CODE] NVARCHAR(200) NULL,
    [POSTED_DATE] DATETIME NULL,
    [POSTING_STATUS] NVARCHAR(200) NULL,
    [CHART_OF_ACCOUNTS_ID] NVARCHAR(300) NULL,
    [DFF_FROM_DATE] NVARCHAR(300) NULL,
    [DFF_TO_DATE] NVARCHAR(300) NULL,
    [BILL_NO] NVARCHAR(300) NULL,
    [IO_ENTERED_BY] NVARCHAR(300) NULL,
    [IO_APPROVED_BY] NVARCHAR(300) NULL,
    [CODE_COMBINATION_ID] NVARCHAR(300) NULL,
    [INVOICE_ID] NVARCHAR(300) NULL,
    [JE_HEADER_ID] NVARCHAR(300) NULL,
    [JE_LINE_NUM] NVARCHAR(300) NULL,
    [ACCRUAL_REV_STATUS] NVARCHAR(300) NULL,
    [ACCRUAL_REV_JE_HEADER_ID] DECIMAL(18, 0) NULL,
    [Months] INT NULL,
    [Years] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BranchCode_BranchName
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BranchCode_BranchName]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [BranchName] NVARCHAR(15) NULL,
    [BranchCode] INT NOT NULL,
    [CreatedBy] NVARCHAR(30) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_EntityCode_SegmentName
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_EntityCode_SegmentName]
(
    [ENTITY_CODE] INT NULL,
    [SEGMENT_NAME] NVARCHAR(25) NULL,
    [CreatedBy] NVARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(30) NULL,
    [UpdatedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(30) NULL,
    [DeletedOn] DATETIME NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Temp_2_Franchise
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Temp_2_Franchise]
(
    [Code] VARCHAR(8000) NULL,
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [sub_remi_share] MONEY NULL,
    [angel_share] MONEY NULL,
    [branch] VARCHAR(50) NULL,
    [sb] VARCHAR(10) NULL,
    [client] CHAR(20) NULL,
    [Addt_Brok] MONEY NULL,
    [AddAngelShare] MONEY NOT NULL,
    [ITrdBrok] MONEY NULL,
    [ITradechar] MONEY NULL,
    [ITradeBrokAngel] MONEY NULL,
    [ITradeCharAngel] MONEY NULL,
    [Category] NVARCHAR(5) NULL,
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IsMissMatchUpdated] BIT NULL,
    [Gross_Normal] DECIMAL(18, 2) NULL,
    [SB_Normal] DECIMAL(18, 2) NULL,
    [SB_ItardeBrok] DECIMAL(18, 2) NULL,
    [SB_ItardeChar] DECIMAL(18, 2) NULL,
    [SB_Other] DECIMAL(18, 2) NULL,
    [Gross_Other] DECIMAL(18, 2) NULL,
    [Fr_Normal] DECIMAL(18, 2) NULL,
    [FR_ItardeBrok] DECIMAL(18, 2) NULL,
    [FR_ItardeChar] DECIMAL(18, 2) NULL,
    [RemarksforOtherCharges] NVARCHAR(MAX) NULL,
    [OtherChargesUpdatedOn] DATETIME NULL,
    [OtherchargesCreatedBy] NVARCHAR(50) NULL,
    [DUMMY] DECIMAL(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Temp_Franchise
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Temp_Franchise]
(
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [sub_remi_share] MONEY NULL,
    [angel_share] MONEY NULL,
    [branch] VARCHAR(50) NULL,
    [sb] VARCHAR(10) NULL,
    [client] CHAR(20) NULL,
    [Addt_Brok] MONEY NULL,
    [AddAngelShare] MONEY NOT NULL,
    [ITrdBrok] MONEY NULL,
    [ITradechar] MONEY NULL,
    [ITradeBrokAngel] MONEY NULL,
    [ITradeCharAngel] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblExceptional
-- --------------------------------------------------
CREATE TABLE [dbo].[tblExceptional]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [sb] NVARCHAR(10) NULL,
    [Branch] NVARCHAR(10) NULL,
    [Category] NVARCHAR(5) NULL,
    [ITrdBrok] DECIMAL(18, 2) NULL,
    [ITradechar] DECIMAL(18, 2) NULL,
    [SB_Branch] NVARCHAR(20) NULL,
    [IncomePercent] DECIMAL(18, 2) NULL,
    [IsActive] BIT NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(30) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblExpense
-- --------------------------------------------------
CREATE TABLE [dbo].[tblExpense]
(
    [UniqueId] NVARCHAR(25) NULL,
    [BranchTag] NVARCHAR(10) NULL,
    [BRANCH_CODE] INT NULL,
    [ACCOUNT_CODE] INT NULL,
    [ACCOUNT_DESCRIPTION] NVARCHAR(250) NULL,
    [OtherExpenseType] NVARCHAR(15) NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFranchise
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFranchise]
(
    [Code] VARCHAR(8000) NULL,
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [sub_remi_share] MONEY NULL,
    [angel_share] MONEY NULL,
    [branch] VARCHAR(50) NULL,
    [sb] VARCHAR(10) NULL,
    [client] CHAR(20) NULL,
    [Addt_Brok] MONEY NULL,
    [AddAngelShare] MONEY NOT NULL,
    [ITrdBrok] MONEY NULL,
    [ITradechar] MONEY NULL,
    [ITradeBrokAngel] MONEY NULL,
    [ITradeCharAngel] MONEY NULL,
    [Category] NVARCHAR(5) NULL,
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IsMissMatchUpdated] BIT NULL,
    [Gross_Normal] DECIMAL(18, 2) NULL,
    [SB_Normal] DECIMAL(18, 2) NULL,
    [SB_ItardeBrok] DECIMAL(18, 2) NULL,
    [SB_ItardeChar] DECIMAL(18, 2) NULL,
    [SB_Other] DECIMAL(18, 2) NULL,
    [Gross_Other] DECIMAL(18, 2) NULL,
    [Fr_Normal] DECIMAL(18, 2) NULL,
    [FR_ItardeBrok] DECIMAL(18, 2) NULL,
    [FR_ItardeChar] DECIMAL(18, 2) NULL,
    [RemarksforOtherCharges] NVARCHAR(MAX) NULL,
    [OtherChargesUpdatedOn] DATETIME NULL,
    [OtherchargesCreatedBy] NVARCHAR(50) NULL,
    [DUMMY] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFranchise_History
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFranchise_History]
(
    [Code] VARCHAR(8000) NULL,
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [sub_remi_share] MONEY NULL,
    [angel_share] MONEY NULL,
    [branch] VARCHAR(50) NULL,
    [sb] VARCHAR(10) NULL,
    [client] CHAR(20) NULL,
    [Addt_Brok] MONEY NULL,
    [AddAngelShare] MONEY NOT NULL,
    [ITrdBrok] MONEY NULL,
    [ITradechar] MONEY NULL,
    [ITradeBrokAngel] MONEY NULL,
    [ITradeCharAngel] MONEY NULL,
    [Category] NVARCHAR(5) NULL,
    [ID] BIGINT NOT NULL,
    [IsMissMatchUpdated] BIT NULL,
    [Gross_Normal] DECIMAL(18, 2) NULL,
    [SB_Normal] DECIMAL(18, 2) NULL,
    [SB_ItardeBrok] DECIMAL(18, 2) NULL,
    [SB_ItardeChar] DECIMAL(18, 2) NULL,
    [SB_Other] DECIMAL(18, 2) NULL,
    [Gross_Other] DECIMAL(18, 2) NULL,
    [Fr_Normal] DECIMAL(18, 2) NULL,
    [FR_ItardeBrok] DECIMAL(18, 2) NULL,
    [FR_ItardeChar] DECIMAL(18, 2) NULL,
    [RemarksforOtherCharges] NVARCHAR(MAX) NULL,
    [OtherChargesUpdatedOn] DATETIME NULL,
    [OtherchargesCreatedBy] NVARCHAR(50) NULL,
    [DUMMY] DECIMAL(18, 0) NULL,
    [Months] INT NULL,
    [Years] INT NULL,
    [MovedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMisMatchB2BRecord
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMisMatchB2BRecord]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [sb] NVARCHAR(10) NULL,
    [Branch] NVARCHAR(15) NULL,
    [Category] NVARCHAR(5) NULL,
    [SbBrnCat] NVARCHAR(MAX) NULL,
    [IsUpdated] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblMonthWiseTotal
-- --------------------------------------------------
CREATE TABLE [dbo].[tblMonthWiseTotal]
(
    [Years] INT NULL,
    [Months] NVARCHAR(15) NULL,
    [branch] NVARCHAR(10) NULL,
    [segment] NVARCHAR(30) NULL,
    [Category] NVARCHAR(5) NULL,
    [ITrdBrok] DECIMAL(18, 2) NULL,
    [ITradechar] DECIMAL(18, 2) NULL,
    [Gross_Normal] DECIMAL(18, 2) NULL,
    [SB_Normal] DECIMAL(18, 2) NULL,
    [SB_ItardeBrok] DECIMAL(18, 2) NULL,
    [SB_ItardeChar] DECIMAL(18, 2) NULL,
    [SB_Other] DECIMAL(18, 2) NULL,
    [Gross_Other] DECIMAL(18, 2) NULL,
    [Ops_Other] DECIMAL(18, 2) NULL,
    [Fr_Normal] DECIMAL(18, 2) NULL,
    [FR_ItardeBrok] DECIMAL(18, 2) NULL,
    [FR_ItardeChar] DECIMAL(18, 2) NULL,
    [Brokerage_Paid] DECIMAL(18, 2) NULL,
    [FrNormalPercent] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblOracleMonthWiseTotal
-- --------------------------------------------------
CREATE TABLE [dbo].[tblOracleMonthWiseTotal]
(
    [Years] INT NULL,
    [Months] NVARCHAR(10) NULL,
    [BranchName] NVARCHAR(10) NULL,
    [SEGMENT_NAME] NVARCHAR(20) NULL,
    [AccountCredited] DECIMAL(18, 0) NULL,
    [AccountDebited] DECIMAL(18, 0) NULL,
    [Balance] DECIMAL(18, 0) NULL,
    [ACCOUNT_DESCRIPTION] NVARCHAR(MAX) NULL,
    [ACCOUNT_CODE] INT NULL,
    [BRANCH_CODE] INT NULL,
    [ENTITY_CODE] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempTable
-- --------------------------------------------------
CREATE TABLE [dbo].[TempTable]
(
    [Code] VARCHAR(8000) NULL,
    [segment] VARCHAR(10) NULL,
    [sauda_date] DATETIME NULL,
    [brok_earned] MONEY NULL,
    [remi_share] MONEY NULL,
    [sub_remi_share] MONEY NULL,
    [angel_share] MONEY NULL,
    [branch] VARCHAR(50) NULL,
    [sb] VARCHAR(10) NULL,
    [client] CHAR(20) NULL,
    [Addt_Brok] MONEY NULL,
    [AddAngelShare] MONEY NOT NULL,
    [ITrdBrok] MONEY NULL,
    [ITradechar] MONEY NULL,
    [ITradeBrokAngel] MONEY NULL,
    [ITradeCharAngel] MONEY NULL,
    [Category] NVARCHAR(5) NULL,
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IsMissMatchUpdated] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TotalMonthlyBillingB2B_B2C
-- --------------------------------------------------
CREATE TABLE [dbo].[TotalMonthlyBillingB2B_B2C]
(
    [Branch] NVARCHAR(10) NULL,
    [Segment] NVARCHAR(15) NULL,
    [Category] NVARCHAR(3) NULL,
    [MonthlyWise] DATE NULL,
    [Total] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.vw_Franchise
-- --------------------------------------------------
CREATE view vw_Franchise                   
As  
  
select      
segment,    
sauda_date,    
SUM(brok_earned) as brok_earned,    
SUM(remi_share) as remi_share,    
SUM(sub_remi_share) as sub_remi_share,    
SUM(angel_share) as angel_share,    
branch,    
sb,    
SUM(Addt_Brok) as Addt_Brok,    
SUM(AddAngelShare) as AddAngelShare,    
SUM(ITrdBrok) as ITrdBrok,    
SUM(ITradechar) as ITradechar,    
SUM(ITradeBrokAngel) as ITradeBrokAngel,    
SUM(ITradeCharAngel) as ITradeCharAngel,    
Category,     
SUM(Gross_Normal) as Gross_Normal,    
SUM(SB_Normal) as SB_Normal,    
SUM(SB_ItardeBrok) as SB_ItardeBrok,    
SUM(SB_ItardeChar) as SB_ItardeChar,    
DUMMY    
 from  tblFranchise with(NOLOCK)  where SB not in ('HIAT','SANQ') and Branch not in ('PTN','XC','ARL','NARYN')  
group by segment, sauda_date,branch, sb,Category,DUMMY

GO

