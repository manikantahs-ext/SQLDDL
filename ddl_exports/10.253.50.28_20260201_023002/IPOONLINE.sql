-- DDL Export
-- Server: 10.253.50.28
-- Database: IPOONLINE
-- Exported: 2026-02-01T02:30:28.431539

USE IPOONLINE;
GO

-- --------------------------------------------------
-- FUNCTION dbo.Fn_FormatStr
-- --------------------------------------------------
--SELECT citrus_usr.FN_FORMATSTR('3.00100',12,3,'L','0')   
--select CITRUS_USR.FN_FORMATSTR('64444',12,3,'L','0')  
CREATE function [Fn_FormatStr]        
(        
@pa_val varchar(100),        
@pa_Intcnt int,        
@pa_decimalcnt int,        
@pa_appendpos char(1),        
@pa_appendchar char(1)         
)        
Returns varchar(8000)        
as         
Begin         
Declare @l_txt_nos varchar(100),        
@l_paint_val varchar(100),        
@l_padec_val varchar(100)        
set @l_paint_val = Substring(@pa_val,0,charindex('.',@pa_val) )      
      
if @l_paint_val = ''      
set @l_paint_val=@pa_val       
      
--set @l_padec_val = Abs(Substring(@pa_val,charindex('.',@pa_val)+1,len(@pa_val)))  
if charindex('.',@pa_val) = 0  
begin  
 set @l_padec_val = replicate(@pa_appendchar,@pa_decimalcnt)  
end  
else  
begin  
 set @l_padec_val = Substring(@pa_val,charindex('.',@pa_val)+1,@pa_decimalcnt)       
end  
--  
      
if @l_padec_val = @pa_val      
set @l_padec_val='0'      
      
--        
if @pa_appendpos='L'        
Begin        
 set @l_txt_nos = replicate(@pa_appendchar,@pa_Intcnt - len(@l_paint_val)) + @l_paint_val        
        
 if @pa_decimalcnt <> 0        
 begin        
  set @l_txt_nos = @l_txt_nos + replicate(@pa_appendchar,@pa_decimalcnt - len(@l_padec_val)) + @l_padec_val        
 end        
End        
if @pa_appendpos='R'        
Begin        
 set @l_txt_nos =  @l_paint_val + replicate(@pa_appendchar,@pa_Intcnt - len(@l_paint_val))        
        
 if @pa_decimalcnt <> 0        
 begin        
  set @l_txt_nos = @l_txt_nos +  @l_padec_val + replicate(@pa_appendchar,@pa_decimalcnt - len(@l_padec_val))         
 end        
End        
        
        
        
Return  @l_txt_nos        
End

GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_SPLITVAL_BY
-- --------------------------------------------------
    
CREATE function dbo.[FN_SPLITVAL_BY](@LINE VARCHAR(max),@LEVEL INTEGER,@by varchar(10)) RETURNS VARCHAR(max)        
AS        
BEGIN        
--        
  DECLARE        
  --        
  @@FNLINE   VARCHAR(max),        
  @@RETLINE  VARCHAR(max),        
  @CTR       INTEGER        
  SET @@FNLINE =  @by + @LINE + @by        
  SET @CTR =0        
  --        
  WHILE @CTR < @LEVEL        
  BEGIN        
    --        
    SET @@FNLINE = SUBSTRING(@@FNLINE,CHARINDEX(@by,@@FNLINE) +len(@by),LEN(@@FNLINE))        
    --        
    IF CHARINDEX(@by,@@FNLINE) <> 0        
    BEGIN        
      --        
      SET @@RETLINE = SUBSTRING(@@FNLINE,1,CHARINDEX(@by,@@FNLINE)-1)        
      --        
    END        
    --        
    ELSE        
    BEGIN        
      --        
      SET @@RETLINE = ''        
      --        
    END        
    --        
    SET @CTR = @CTR+1        
    --        
  END        
  --        
RETURN @@RETLINE        
--        
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.ufn_CountString
-- --------------------------------------------------
CREATE function dbo.[ufn_CountString]    
( @pInput VARCHAR(max), @pSearchString VARCHAR(100) )    
RETURNS INT    
BEGIN    
    
    RETURN (LEN(@pInput) -     
            LEN(REPLACE(@pInput, @pSearchString, ''))) /    
            LEN(@pSearchString)    
    
END

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCH_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__BRANCH_MASTER__367C1819] ON [dbo].[BRANCH_MASTER] ([BM_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENT_CASH_BALANCE
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__CLIENT_CASH_BALA__339FAB6E] ON [dbo].[CLIENT_CASH_BALANCE] ([CCB_CM_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENT_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__CLIENT_MASTER__30C33EC3] ON [dbo].[CLIENT_MASTER] ([CM_UM_ID])

GO

-- --------------------------------------------------
-- INDEX dbo.IPO_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__IPO_MASTER__3B40CD36] ON [dbo].[IPO_MASTER] ([IM_IPO_SYMBOL])

GO

-- --------------------------------------------------
-- INDEX dbo.IPO_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__IPO_MASTER__3C34F16F] ON [dbo].[IPO_MASTER] ([IM_IPO_NAME])

GO

-- --------------------------------------------------
-- INDEX dbo.SUBBROKER_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__SUBBROKER_MASTER__2DE6D218] ON [dbo].[SUBBROKER_MASTER] ([SBM_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLADMIN
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TBLADMIN] ([fldauto_admin])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLADMINCONFIG
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TBLADMINCONFIG] ([Fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCATEGORY
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [categoryidx] ON [dbo].[TBLCATEGORY] ([fldcategorycode])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCATMENU
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TBLCATMENU] ([fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCATMENU_LOG
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXREP] ON [dbo].[TBLCATMENU_LOG] ([Fldreportcode], [Fldadminauto], [CREATED_ON])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCLASSUSERLOGINS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDXLOGIN] ON [dbo].[TBLCLASSUSERLOGINS] ([FLDUSERNAME], [FLDSESSION], [FLDIPADDRESS])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLMENUHEAD
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxMenu] ON [dbo].[TBLMENUHEAD] ([fldmenucode])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLPRADNYAUSERS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[TBLPRADNYAUSERS] ([fldauto], [fldadminauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLREPORTGRP
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpr] ON [dbo].[TBLREPORTGRP] ([fldreportgrp], [fldmenugrp])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLREPORTS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxReport] ON [dbo].[TBLREPORTS] ([fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLREPORTS_BLOCKED
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpt] ON [dbo].[TBLREPORTS_BLOCKED] ([fldadminauto], [Fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLUSERCONTROLGLOBALS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[TBLUSERCONTROLGLOBALS] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLUSERCONTROLMASTER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [AutoIDx] ON [dbo].[TBLUSERCONTROLMASTER] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLUSERCONTROLMASTER_JRNL
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[TBLUSERCONTROLMASTER_JRNL] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.USER_MASTER
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__USER_MASTER__2B0A656D] ON [dbo].[USER_MASTER] ([UM_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_LOGIN_ERR_LOG
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXDT] ON [dbo].[V2_LOGIN_ERR_LOG] ([LOGIN_DT])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_LOGIN_LOG
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDXUSER] ON [dbo].[V2_LOGIN_LOG] ([ADDDT], [USERID])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxReport] ON [dbo].[V2_Report_Access_Log] ([Sno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCH_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCH_MASTER] ADD CONSTRAINT [PK__BRANCH_MASTER__3587F3E0] PRIMARY KEY ([BM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCH_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCH_MASTER] ADD CONSTRAINT [UQ__BRANCH_MASTER__367C1819] UNIQUE ([BM_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_BANK_DETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_BANK_DETAILS] ADD CONSTRAINT [PK_CLIENT_BANK_DETAILS] PRIMARY KEY ([CBD_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_CASH_BALANCE
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_CASH_BALANCE] ADD CONSTRAINT [PK_CLIENT_CASH_BALANCE] PRIMARY KEY ([CCB_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_CASH_BALANCE
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_CASH_BALANCE] ADD CONSTRAINT [UQ__CLIENT_CASH_BALA__339FAB6E] UNIQUE ([CCB_CM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_DP_DETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_DP_DETAILS] ADD CONSTRAINT [PK_CLIENT_DP_DETAILS] PRIMARY KEY ([CDD_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_MASTER] ADD CONSTRAINT [PK_CLIENT_MASTER] PRIMARY KEY ([CM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.CLIENT_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[CLIENT_MASTER] ADD CONSTRAINT [UQ__CLIENT_MASTER__30C33EC3] UNIQUE ([CM_UM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FIN_ACCOUNT_MSTR
-- --------------------------------------------------
ALTER TABLE [dbo].[FIN_ACCOUNT_MSTR] ADD CONSTRAINT [FIN_ACCOUNT_MSTR_PK] PRIMARY KEY ([FINA_ACC_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IPO_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[IPO_MASTER] ADD CONSTRAINT [PK__IPO_MASTER__3A4CA8FD] PRIMARY KEY ([IM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IPO_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[IPO_MASTER] ADD CONSTRAINT [UQ__IPO_MASTER__3B40CD36] UNIQUE ([IM_IPO_SYMBOL])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IPO_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[IPO_MASTER] ADD CONSTRAINT [UQ__IPO_MASTER__3C34F16F] UNIQUE ([IM_IPO_NAME])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IPO_TRANSACTIONS
-- --------------------------------------------------
ALTER TABLE [dbo].[IPO_TRANSACTIONS] ADD CONSTRAINT [PK_IPO_TRANSACTIONS] PRIMARY KEY ([IT_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SUBBROKER_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[SUBBROKER_MASTER] ADD CONSTRAINT [PK__SUBBROKER_MASTER__2CF2ADDF] PRIMARY KEY ([SBM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SUBBROKER_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[SUBBROKER_MASTER] ADD CONSTRAINT [UQ__SUBBROKER_MASTER__2DE6D218] UNIQUE ([SBM_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBLUSERCONTROLMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[TBLUSERCONTROLMASTER] ADD CONSTRAINT [PK_TBLUSERCONTROLMASTER] PRIMARY KEY ([FLDUSERID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TBLUSERPASSHIST
-- --------------------------------------------------
ALTER TABLE [dbo].[TBLUSERPASSHIST] ADD CONSTRAINT [PK_TBLUSERPASSHIST] PRIMARY KEY ([FLDAUTO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.USER_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[USER_MASTER] ADD CONSTRAINT [PK__USER_MASTER__2A164134] PRIMARY KEY ([UM_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.USER_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[USER_MASTER] ADD CONSTRAINT [UQ__USER_MASTER__2B0A656D] UNIQUE ([UM_CODE])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADDEDIT_BLOCKED_PAYOUT
-- --------------------------------------------------

    
create PROCEDURE [dbo].[ADDEDIT_BLOCKED_PAYOUT]   
(    
 @PARTY_CODE VARCHAR(10),    
 @BRANCH_CD VARCHAR(10),    
 @SUB_BROKER VARCHAR(25),    
 @FROMDATE VARCHAR(10),    
 @TODATE VARCHAR(10),    
 @QTY NUMERIC(18,4),    
 @ISIN VARCHAR(12),    
 @RECTYPE VARCHAR(4),    
 @USERID VARCHAR(10),    
 @SRNO INT,    
 @CLOSEREC VARCHAR(1),
 @EXCEPTIONTYPE VARCHAR(10),
 @REMARKS   VARCHAR(50)
)    
AS    
BEGIN    
 IF @RECTYPE='ADD'     
 BEGIN       
  INSERT INTO TBL_BLOCKED_PAYOUT(RECORD_TYPE,PARTY_CODE,BRANCH_CD,SUB_BROKER,FROMDATE,TODATE,ISIN,QTY_LIMIT,ADDED_BY,ADDED_ON,REMARKS)    
  VALUES(@EXCEPTIONTYPE,@PARTY_CODE,@BRANCH_CD,@SUB_BROKER,CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109),CONVERT(VARCHAR(11),    
  CONVERT(DATETIME, @TODATE, 103), 109),@ISIN,@QTY,@USERID,GETDATE(),@REMARKS)    
 END    
     
 IF @RECTYPE='EDIT' AND @CLOSEREC='N'     
 BEGIN    
 UPDATE TBL_BLOCKED_PAYOUT SET TODATE = CONVERT(VARCHAR(11),CONVERT(DATETIME, @TODATE, 103), 109) + ' 23:59:59',
 REMARKS = @REMARKS,
 ADDED_BY = @USERID,
 ADDED_ON = GETDATE()
 WHERE SNO = @SRNO    
      
 END    
 IF @RECTYPE='EDIT' AND @CLOSEREC='Y'    
 BEGIN    
 UPDATE TBL_BLOCKED_PAYOUT SET TODATE = CONVERT(VARCHAR(11),CONVERT(DATETIME, @TODATE, 103), 109) + ' 23:59:59' 
 WHERE SNO = @SRNO    
 END    
     
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADDEDIT_IPO_INTMSTR
-- --------------------------------------------------


    
create PROCEDURE [dbo].[ADDEDIT_IPO_INTMSTR]   
(    
 @PARTY_CODE VARCHAR(10),    
 @BRANCH_CD VARCHAR(10),    
 @SUB_BROKER VARCHAR(25),    
 @FROMDATE VARCHAR(10),    
 @TODATE VARCHAR(10),    
 @QTY NUMERIC(18,4),    
 @ISIN VARCHAR(12),    
 @RECTYPE VARCHAR(4),    
 @USERID VARCHAR(10),    
 @SRNO INT,    
 @CLOSEREC VARCHAR(1),
 @EXCEPTIONTYPE VARCHAR(10),
 @REMARKS   VARCHAR(50)
)    
AS    
BEGIN    
 IF @RECTYPE='ADD'     
 BEGIN       
  INSERT INTO TBL_IPO_INTMSTR(RECORD_TYPE,PARTY_CODE,BRANCH_CD,SUB_BROKER,FROMDATE,TODATE,ISIN,QTY_LIMIT,ADDED_BY,ADDED_ON,REMARKS)    
  VALUES(@EXCEPTIONTYPE,@PARTY_CODE,@BRANCH_CD,@SUB_BROKER,CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109),CONVERT(VARCHAR(11),    
  CONVERT(DATETIME, @TODATE, 103), 109),@ISIN,@QTY,@USERID,GETDATE(),@REMARKS)    
 END    
     
 IF @RECTYPE='EDIT' AND @CLOSEREC='N'     
 BEGIN    
 UPDATE TBL_IPO_INTMSTR SET TODATE = CONVERT(VARCHAR(11),CONVERT(DATETIME, @TODATE, 103), 109) + ' 23:59:59',
 REMARKS = @REMARKS,
 ADDED_BY = @USERID,
 ADDED_ON = GETDATE()
 WHERE SNO = @SRNO    
      
 END    
 IF @RECTYPE='EDIT' AND @CLOSEREC='Y'    
 BEGIN    
 UPDATE TBL_IPO_INTMSTR SET TODATE = CONVERT(VARCHAR(11),CONVERT(DATETIME, @TODATE, 103), 109) + ' 23:59:59' 
 WHERE SNO = @SRNO    
 END    
     
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ADMIN_ADDREPORT
-- --------------------------------------------------
CREATE PROC ADMIN_ADDREPORT
(
	@REPORT VARCHAR(35),
	@PATH VARCHAR(500),
	@TARGET VARCHAR(25),
	@DESC VARCHAR(80),
	@REPORTGRP VARCHAR(10),
	@MENUGRP VARCHAR(3),
	@STATUS VARCHAR(20)
	
)
/*
BEGIN TRAN
EXEC ADMIN_ADDREPORT 'Voucher Edit','/ACCOUNT/ACCMODULES/VOUCHER_EDIT/V2_VOUCHER_MAIN.ASP','FRATOPIC','DCA','98',5,'ALL'
SELECT * FROM TBLREPORTS WHERE FLDREPORTNAME = 'VOUCHER EDIT'
ROLLBACK
*/
AS
	DECLARE 
		@RESULT VARCHAR(50),
		@COUNT INT
SELECT @COUNT = COUNT(*) FROM TBLREPORTS WHERE UPPER(RTRIM(LTRIM(FLDREPORTNAME))) = UPPER(RTRIM(LTRIM(@REPORT)))

IF @COUNT > 0 
 BEGIN
	SET @RESULT = 'REPORT NAME ALREADY EXIST...'
	SELECT @RESULT AS MESSAGE
	RETURN;
 END


BEGIN TRY
	SET NOCOUNT ON;

	INSERT INTO TBLREPORTS 
	VALUES(@REPORT,@PATH,@TARGET,@DESC,@REPORTGRP,@MENUGRP,@STATUS,0)
	
	SET @RESULT = 'REPORT SUCCESSFULLY INSERTED!'

	IF @@ERROR = 0
	 BEGIN
		SELECT @RESULT AS MESSAGE
    END 
		
END TRY
BEGIN CATCH
	SELECT 
        ERROR_MESSAGE() AS MESSAGE;
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_GETLEDGERBALANCE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CBO_GETLEDGERBALANCE](      
                @STATUSID   VARCHAR(25),      
                @STATUSNAME VARCHAR(25),      
                @FROMCODE   VARCHAR(25),      
                @TOCODE     VARCHAR(25),      
                @DATEFROM VARCHAR(11),      
                @DATETO   VARCHAR(11),      
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',
                @SEGMENTDB VARCHAR(25)
                )      
      
  AS      
      
  SET NOCOUNT ON       
      
  CREATE TABLE [DBO].[#LEDBALANCE] (      
   [ENT_CODE] [VARCHAR] (25) NOT NULL ,      
   [ENT_NAME] [VARCHAR] (100) NOT NULL ,      
   [LEDBAL] [MONEY] NOT NULL ,      
   [DRCR] [VARCHAR] (1) NOT NULL,       
   [BALFLAG] [INT] NOT NULL,       
   [LEDFLAG] [INT] NOT NULL       
  ) ON [PRIMARY]      
      
  INSERT INTO #LEDBALANCE       
  SELECT   ENT_CODE = LDG_ACCOUNT_ID,       
           ENT_NAME=ISNULL(CM_APPNAME1,''),       
           LEDBAL = SUM(LDG_AMOUNT),      
           DRCR = 'C',        
           BALFLAG = 1,       
           LEDFLAG = 1       
  FROM     LEDGER L (NOLOCK),CLIENT_MASTER M
  WHERE    LDG_VOUCHER_DT <= @DATETO + ' 23:59:59' AND CM_UM_ID= LDG_ACCOUNT_ID
  AND LDG_IPO_NO like @SEGMENTDB +'%'
  GROUP BY LDG_ACCOUNT_ID ,ISNULL(CM_APPNAME1,'')
      
  INSERT INTO #LEDBALANCE       
  SELECT   ENT_CODE=LDG_ACCOUNT_ID,       
           ENT_NAME=ISNULL(CM_APPNAME1,''),       
           LEDBAL = SUM(LDG_AMOUNT),      
           DRCR = 'C',        
           BALFLAG = 2,       
           LEDFLAG = 1       
  FROM     LEDGER L (NOLOCK),CLIENT_MASTER M
  WHERE    ISNULL(LDG_TO_DT,LDG_VOUCHER_DT) > @DATETO + ' 23:59:59'       AND CM_UM_ID= LDG_ACCOUNT_ID
  AND LDG_IPO_NO like @SEGMENTDB +'%'
  GROUP BY LDG_ACCOUNT_ID  ,ISNULL(CM_APPNAME1,'')
      
  SELECT   ENT_CODE,       
           ENT_NAME,       
           LEDBAL = SUM(CASE       
                          WHEN LEDFLAG = 1       
                               AND BALFLAG = 1 THEN LEDBAL     
                          ELSE 0       
                        END),      
           MARBAL = SUM(CASE       
                          WHEN LEDFLAG = 2       
                               AND BALFLAG = 1 THEN LEDBAL     
                          ELSE 0       
                        END),      
           UCLBAL = SUM(CASE       
                          WHEN LEDFLAG = 1       
                               AND BALFLAG = 2 THEN LEDBAL
                          ELSE 0       
                        END),
		   EXCHANGE = 'IPO',
		   SEGMENT = 'FUNDING'
  FROM     #LEDBALANCE       
 GROUP BY ENT_CODE, ENT_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_GETLEDGERDETAILS
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[CBO_GETLEDGERDETAILS](
                @STATUSID   VARCHAR(25),
                @STATUSNAME VARCHAR(25),
                @FROMCODE   VARCHAR(25),
                @TOCODE     VARCHAR(25),
                @FROMDATE   VARCHAR(11),
                @TODATE     VARCHAR(11),
                @SEARCHCODE VARCHAR(25), 
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',
                @SEGMENTDB VARCHAR(25))

AS

/*
  EXECUTE CBO_GETLEDGERDETAILS 1,258
*/
  SET NOCOUNT ON
  
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  
  IF @SEARCHCODE = '' SELECT SEARCHCODE = '%'

  DECLARE  @FLDAUTO     INT,
           @FLDAUTOFROM INT,
           @OPENDATE    VARCHAR(11)
  SET @OPENDATE = 'APR  1 2014'
                      
CREATE TABLE [dbo].[#MINILEDGER_DETAIL] (
	[MLD_VTYP] [smallint] NOT NULL ,
	[MLD_BOOKTYPE] [varchar] (20) NOT NULL ,
	[MLD_LNO] [decimal](5, 0) NOT NULL ,
	[MLD_VNO] [varchar] (20) NOT NULL ,
	[MLD_EDT] [datetime] NOT NULL ,
	[MLD_VDT] [datetime] NOT NULL ,
	[MLD_SHORTDESC] [char] (35) NOT NULL ,
	[MLD_DRAMT] [money] NOT NULL ,
	[MLD_CRAMT] [money] NOT NULL ,
	[MLD_DDNO] [varchar] (20) NULL ,
	[MLD_NARRATION] [varchar] (300) NULL ,
	[MLD_CLTCODE] [varchar] (25) NOT NULL ,
	[MLD_OPBAL] [money] NOT NULL ,
	[MLD_CROSAC] [varchar] (10) NULL ,
	[MLD_EDIFF] [int] NULL ,
	[MLD_LEDGER] [int] NULL ,
	[MLD_OPBALFLAG] [int] NOT NULL,
	[MLD_ENTEREDBY] [VARCHAR](100) NOT NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[#OPPBALANCE_TMP] (
	[CLTCODE] [varchar] (25) NOT NULL ,
	[OPPBAL] [money] NOT NULL ,
	[DRCR] [varchar] (1) NOT NULL,
	[IPO_NO] VARCHAR(20),
	[VDT] DATETIME,
	[EDT] DATETIME
	
) ON [PRIMARY]

CREATE TABLE [dbo].[#CLIENT] (
  [ENT_CODE]    [VARCHAR](25) NOT NULL,
  [PARTY_CODE]  [VARCHAR](20) NOT NULL,
  [ENT_NAME]	[VARCHAR](200) NOT NULL,
) ON [PRIMARY]

  INSERT INTO #CLIENT 
  SELECT ENT_CODE = CM_UM_ID, PARTY_CODE = CM_UM_ID, ENT_NAME = CM_APPNAME1
  FROM  CLIENT_MASTER 
  WHERE CONVERT(VARCHAR,CM_UM_ID) BETWEEN @FROMCODE AND @TOCODE
  AND CM_UM_ID LIKE @SEARCHCODE
  ---------------------------------------------
  --SETTLEMENT LEDGER OPENING BALANCE
  ---------------------------------------------
          
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE = C.ENT_CODE,
           OPBAL = ABS(ISNULL(SUM(LDG_AMOUNT),0)),
           DRCR = (CASE WHEN ISNULL(SUM(LDG_AMOUNT),0) > 0 THEN 'C' ELSE 'D' END),
		   IPO_NO = LDG_IPO_NO, '' LDG_VOUCHER_DT,'' --case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end
  FROM     LEDGER L WITH (NOLOCK),
           #CLIENT C
  WHERE    ISNULL(case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end,LDG_VOUCHER_DT) >= @OPENDATE
           AND ISNULL(case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end,LDG_VOUCHER_DT) < @FROMDATE --@OPENDATE
           AND CONVERT(VARCHAR,L.LDG_ACCOUNT_ID) = C.PARTY_CODE AND LDG_IPO_NO like @SEGMENTDB +'%'
  GROUP BY C.ENT_CODE,LDG_IPO_NO 
  --,LDG_VOUCHER_DT,case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end
            
  --INSERT INTO #OPPBALANCE_TMP
  --SELECT   CLTCODE = C.ENT_CODE,
  --         OPPBAL = ABS(ISNULL(SUM(LDG_AMOUNT),0)),
  --         DRCR =  (CASE WHEN ISNULL(SUM(LDG_AMOUNT),0) > 0 THEN 'C' ELSE 'D' END),
		--   IPO_NO = LDG_IPO_NO,LDG_VOUCHER_DT,case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end
  --FROM     LEDGER L WITH (NOLOCK), 
  --         #CLIENT C
  --WHERE    ISNULL(case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end,LDG_VOUCHER_DT) >= @OPENDATE
  --         AND LDG_VOUCHER_DT <= @FROMDATE --@OPENDATE
  --         AND CONVERT(VARCHAR,L.LDG_ACCOUNT_ID) = C.PARTY_CODE AND LDG_IPO_NO like @SEGMENTDB +'%'
  --GROUP BY C.ENT_CODE,LDG_IPO_NO ,LDG_VOUCHER_DT,case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end
           
           
           
           
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = IPO_NO,
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = Edt,
         VDT = Vdt,
         SHORTDESC = 'OPENEN',
         DRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN OPPBAL
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN 0
                    ELSE ABS(OPPBAL)
                  END),
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(@FROMDATE)),
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   (SELECT   CLTCODE, IPO_NO, 
                   OPPBAL = SUM(CASE 
                                  WHEN DRCR = 'D' THEN OPPBAL
                                  ELSE -OPPBAL
                                END),VDT,isnull(EDT,'1900-01-01 00:00:00.000') EDT
          FROM     #OPPBALANCE_TMP
          GROUP BY CLTCODE,IPO_NO,VDT,EDT) L

  ---------------------------------------------
  --MARGIN LEDGER OPENING BALANCE
  ---------------------------------------------
                         
  TRUNCATE TABLE #OPPBALANCE_TMP
           
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = IPO_NO,
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN OPPBAL
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN 0
                    ELSE ABS(OPPBAL)
                  END),
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(@FROMDATE)),
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   (SELECT   CLTCODE,IPO_NO,
                   OPPBAL = SUM(CASE 
                                  WHEN DRCR = 'D' THEN OPPBAL
                                  ELSE -OPPBAL
                                END)
          FROM     #OPPBALANCE_TMP
          GROUP BY CLTCODE,IPO_NO) L
         
  ---------------------------------------------
  --SETTLEMENT LEDGER ENTRIES
  ---------------------------------------------
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP=LDG_VOUCHER_TYPE,
         BOOKTYPE=LDG_IPO_NO,
         LNO=1,
         VNO=LDG_VOUCHER_NO,
         EDT=ISNULL(LDG_TO_DT,LDG_VOUCHER_DT),
         VDT=LDG_VOUCHER_DT,
         SHORTDESC = (case when LDG_VOUCHER_TYPE = 1 then 'Payment'
						   when LDG_VOUCHER_TYPE = 2 then 'Receipt'
						   Else 'JV' End),
         DRAMT = (CASE 
                    WHEN LDG_AMOUNT < 0 THEN ABS(LDG_AMOUNT)
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN LDG_AMOUNT > 0 THEN ABS(LDG_AMOUNT)
                    ELSE 0
                  END),
         DDNO = ISNULL(LDG_INSTRUMENT_NO,''),
         NARRATION = L.LDG_NARRATION,
         CLTCODE = C.ENT_CODE,
         OPBAL = 0,
         CROSAC = LDG_GL_CODE,
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 1,
		 MLD_ENTEREDBY = ''
  FROM   LEDGER L WITH (NOLOCK),
         #CLIENT C 
  WHERE  ISNULL( ISNULL(case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end,LDG_VOUCHER_DT) ,LDG_VOUCHER_DT) BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
         AND L.LDG_VOUCHER_DT <= @TODATE + ' 23:59:59' AND LDG_IPO_NO like @SEGMENTDB +'%'
         AND CONVERT(VARCHAR,L.LDG_ACCOUNT_ID) = C.PARTY_CODE
  ORDER BY 6, 12, 1, 2, 4, 3
  --ORDER BY L.VDT, L.CLTCODE, L.VTYP, L.BOOKTYPE, L.VNO, L.DRCR, L.LNO 
                        
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP=LDG_VOUCHER_TYPE,
         BOOKTYPE=LDG_IPO_NO,
         LNO=1,
         VNO=LDG_VOUCHER_NO,
         EDT=ISNULL(LDG_TO_DT,LDG_VOUCHER_DT),
         VDT=LDG_VOUCHER_DT,
		 SHORTDESC = (case when LDG_VOUCHER_TYPE = 1 then 'Payment'
						   when LDG_VOUCHER_TYPE = 2 then 'Receipt'
						   Else 'JV' End),
         DRAMT = (CASE 
                    WHEN LDG_AMOUNT < 0 THEN ABS(LDG_AMOUNT)
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN LDG_AMOUNT > 0 THEN ABS(LDG_AMOUNT)
                    ELSE 0
                  END),
         DDNO = ISNULL(LDG_INSTRUMENT_NO,''),
         NARRATION = L.LDG_NARRATION,
         CLTCODE = C.ENT_CODE,
         OPBAL = 0,
         CROSAC = LDG_GL_CODE,
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 2,
		 MLD_ENTEREDBY = ''
  FROM   LEDGER L WITH (NOLOCK),
         #CLIENT C 
  WHERE  ISNULL( ISNULL(case when LDG_TO_DT='1900-01-01 00:00:00.000' then null else LDG_TO_DT end,LDG_VOUCHER_DT) ,LDG_VOUCHER_DT) > @TODATE + ' 23:59:59' 
         AND L.LDG_VOUCHER_DT <= @TODATE + ' 23:59:59' AND LDG_IPO_NO like @SEGMENTDB +'%'
         AND L.LDG_ACCOUNT_ID = C.PARTY_CODE 
  ORDER BY 6, 12, 1, 2, 4, 3
  --ORDER BY VDT, CLTCODE, VTYP, BOOKTYPE, LNO, VNO, DRCR 
  
  ---------------------------------------------------------------
  --UPDATE CROSS ACCOUNT AND CHEQUE NUMBER
  ---------------------------------------------------------------
                    
  ---------------------------------------------------------------
  --POPULATE MINI LEDGER MASTER RECORDS 
  ---------------------------------------------------------------
/*
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         ISNULL(LDG_TO_DT,LDG_VOUCHER_DT) = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = 0,
         CRAMT = 0,
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(CONVERT(CHAR,@FROMDATE))),
         MLM_CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   #MINILEDGER_MASTER 
  WHERE  NOT EXISTS (SELECT DISTINCT MLD_CLTCODE
                     FROM   #MINILEDGER_DETAIL 
                     WHERE  MLM_CLTCODE = MLD_CLTCODE
                            AND MLD_LEDGER = 1
                            AND MLD_OPBALFLAG = 0) 

          
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = 0,
         CRAMT = 0,
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(CONVERT(CHAR,@FROMDATE))),
         MLM_CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   #MINILEDGER_MASTER 
  WHERE  NOT EXISTS (SELECT DISTINCT MLD_CLTCODE
                     FROM   #MINILEDGER_DETAIL 
                     WHERE  MLM_CLTCODE = MLD_CLTCODE
                            AND MLD_LEDGER = 2
                            AND MLD_OPBALFLAG = 0) 
*/
  SELECT D.*, 
         EXCHANGE='', 
         SEGMENT=MLD_BOOKTYPE, 
         C.ENT_NAME 
  FROM   #MINILEDGER_DETAIL D, 
         (SELECT DISTINCT ENT_CODE, ENT_NAME FROM #CLIENT) C 
  WHERE  C.ENT_CODE = D.MLD_CLTCODE
  ORDER BY 12, 16, 17, 6, 5, 8 DESC, 9

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_SHOWLEDGERBALANCE
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CBO_SHOWLEDGERBALANCE](    
                @STATUSID   VARCHAR(25),    
                @STATUSNAME VARCHAR(25),    
                @EXCHANGE   VARCHAR(25),    
                @SEGMENT    VARCHAR(25),    
                @SEGMENTDB  VARCHAR(25),    
                @FROMCODE   VARCHAR(25),    
                @TOCODE     VARCHAR(25),    
                @DATEFROM   VARCHAR(11),    
                @DATETO     VARCHAR(11),    
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',
				@RPT_TYPE VARCHAR(20) = 'SUMMARY')    
    
AS    
    
/*==============================================================================================================      
        EXEC CBO_SHOWLEDGERBALANCE @NOOFDAYS 10    
==============================================================================================================*/    
    
  SET NOCOUNT ON    
    
    
  CREATE TABLE [DBO].[#BALANCE] (    
   [ENT_CODE] [VARCHAR] (25) NOT NULL ,    
   [ENT_NAME] [VARCHAR] (100) NOT NULL ,    
   [LEDBAL]   [MONEY] NOT NULL ,    
   [MARBAL]   [MONEY] NOT NULL ,    
   [UCLBAL]   [MONEY] NOT NULL ,     
   [EXCHANGE] [VARCHAR] (25) NOT NULL ,    
   [SEGMENT]  [VARCHAR] (25) NOT NULL     
  ) ON [PRIMARY]    
    
  DECLARE  @@ACCCUR       AS CURSOR,    
           @@ACCOUNTDB   VARCHAR(25),    
           @@EXCHANGE    VARCHAR(25),    
           @@SEGMENT     VARCHAR(25),    
           @@SQL         VARCHAR(5000)    
      
      SELECT @@SQL = ' '    
      SELECT @@SQL = @@SQL + 'INSERT INTO #BALANCE '    
      SELECT @@SQL = @@SQL + 'EXECUTE CBO_GETLEDGERBALANCE '    
	  	   
      SELECT @@SQL = @@SQL + '@STATUSID   = ''' + @STATUSID + ''', '    
      SELECT @@SQL = @@SQL + '@STATUSNAME = ''' + @STATUSNAME + ''', '    
	  SELECT @@SQL = @@SQL + '@FROMCODE   = ''' + @FROMCODE + ''', '    
      SELECT @@SQL = @@SQL + '@TOCODE     = ''' + @TOCODE + ''', '    
      SELECT @@SQL = @@SQL + '@DATEFROM   = ''' + @DATEFROM + ''', '    
      SELECT @@SQL = @@SQL + '@DATETO     = ''' + @DATETO + ''', '    
      SELECT @@SQL = @@SQL + '@SEARCHWHAT = ''' + @SEARCHWHAT + ''', '    
      SELECT @@SQL = @@SQL + '@SEGMENTDB = ''' + @SEGMENTDB + ''' '  
      
	  print @@SQL          
      EXEC( @@SQL)    

    
  SELECT   ENT_CODE,     
           ENT_NAME,     
           LEDBAL = SUM(LEDBAL),     
           MARBAL = SUM(MARBAL),     
           UCLBAL = SUM(UCLBAL),     
    CLRBAL = SUM((LEDBAL + MARBAL) - UCLBAL)     
  FROM     #BALANCE     
  GROUP BY ENT_CODE,ENT_NAME     
  ORDER BY 1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CBO_SHOWLEDGERDETAILS
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[CBO_SHOWLEDGERDETAILS](      
                @STATUSID   VARCHAR(25),      
                @STATUSNAME VARCHAR(25),      
                @EXCHANGE   VARCHAR(25),      
                @SEGMENT    VARCHAR(25),      
                @SEGMENTDB  VARCHAR(25),      
                @FROMCODE   VARCHAR(25),      
                @TOCODE     VARCHAR(25),      
                @DATEFROM   VARCHAR(11),      
                @DATETO     VARCHAR(11),      
                @SEARCHCODE VARCHAR(25),      
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',    
    @RPT_TYPE VARCHAR(20) = 'SUMMARY')      
      
AS      
      
/*==============================================================================================================        
        EXEC CBO_SHOWLEDGERDETAILS @NOOFDAYS 10      
==============================================================================================================*/      
      
  SET NOCOUNT ON      
      
  CREATE TABLE [DBO].[#SEGMENT] (      
   [EXCHANGE]  [VARCHAR] (25) NOT NULL ,      
   [SEGMENT]   [VARCHAR] (25) NOT NULL ,      
   [SEGMENTDB] [VARCHAR] (25) NOT NULL ,      
  ) ON [PRIMARY]      
      
      
CREATE TABLE [dbo].[#MINILEDGER_DETAIL] (      
 [MLD_SNO] [int] IDENTITY (1, 1) NOT NULL ,      
 [MLD_VTYP] [smallint] NOT NULL ,      
 [MLD_BOOKTYPE] [char] (20) NOT NULL ,      
 [MLD_LNO] [decimal](5, 0) NOT NULL ,      
 [MLD_VNO] [varchar] (12) NOT NULL ,      
 [MLD_EDT] [datetime] NOT NULL ,      
 [MLD_VDT] [datetime] NOT NULL ,      
 [MLD_SHORTDESC] [char] (35) NOT NULL ,      
 [MLD_DRAMT] [money] NOT NULL ,      
 [MLD_CRAMT] [money] NOT NULL ,      
 [MLD_DDNO] [varchar] (20) NULL ,      
 [MLD_NARRATION] [varchar] (300) NULL ,      
 [MLD_CLTCODE] [varchar] (20) NOT NULL ,      
 [MLD_OPBAL] [money] NOT NULL ,      
 [MLD_CROSAC] [varchar] (20) NULL ,      
 [MLD_EDIFF] [int] NULL ,      
 [MLD_LEDGER] [int] NULL ,      
 [MLD_OPBALFLAG] [int] NOT NULL ,       
 [ENTEREDBY]  [varchar] (100) NULL,    
 [EXCHANGE] [varchar] (25) NULL ,      
 [SEGMENT] [varchar] (100) NULL ,       
 [ENT_NAME] [varchar] (200) NULL    
) ON [PRIMARY]      
      
  DECLARE  @@ACCCUR       AS CURSOR,      
           @@ACCOUNTDB   VARCHAR(25),      
           @@EXCHANGE    VARCHAR(25),      
           @@SEGMENT     VARCHAR(25),      
           @@SQL         VARCHAR(5000)      
     
      SELECT @@SQL = ' '      
      SELECT @@SQL = @@SQL + 'INSERT INTO #MINILEDGER_DETAIL '      
      SELECT @@SQL = @@SQL + 'EXECUTE CBO_GETLEDGERDETAILS '       
      SELECT @@SQL = @@SQL + '@STATUSID   = ''' + @STATUSID + ''', '      
      SELECT @@SQL = @@SQL + '@STATUSNAME = ''' + @STATUSNAME + ''', '         
      SELECT @@SQL = @@SQL + '@FROMCODE   = ''' + @FROMCODE + ''', '      
      SELECT @@SQL = @@SQL + '@TOCODE     = ''' + @TOCODE + ''', '      
      SELECT @@SQL = @@SQL + '@FROMDATE   = ''' + @DATEFROM + ''', '      
      SELECT @@SQL = @@SQL + '@TODATE     = ''' + @DATETO + ''', '      
      SELECT @@SQL = @@SQL + '@SEARCHCODE = ''' + @SEARCHCODE + ''', '      
      SELECT @@SQL = @@SQL + '@SEARCHWHAT = ''' + @SEARCHWHAT + ''', '      
      SELECT @@SQL = @@SQL + '@SEGMENTDB = ''' + @SEGMENTDB + ''' '      

      EXEC( @@SQL)      
    
SELECT  MLD_SNO,MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DRAMT,MLD_CRAMT,    
 MLD_DDNO,MLD_NARRATION,MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG       
 INTO #LEDGER    
 FROM            
 (      
  SELECT MLD_SNO, MLD_EDT, MLD_VDT, MLD_SHORTDESC, MLD_DRAMT, MLD_CRAMT, MLD_DDNO,     
   MLD_NARRATION = (CASE WHEN MLD_DRAMT > 0 AND (MLD_NARRATION = 'FUNDING BILL' or MLD_NARRATION = 'LOAN')    
          THEN 'LOAN DISBURSEMENT'      
          WHEN MLD_CRAMT > 0 AND (MLD_NARRATION = 'FUNDING BILL' or MLD_NARRATION = 'LOAN')    
          THEN 'LOAN REPAYMENT'       
          ELSE MLD_NARRATION    
        END),    
  MLD_CLTCODE,     
  MLD_CROSAC,    
  --MLD_CROSAC='',     
  EXCHANGE, SEGMENT, MLD_OPBALFLAG    
  FROM (    
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC,      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,      
         MLD_NARRATION=MLD_NARRATION,      
         MLD_CLTCODE,      
         MLD_CROSAC,      
         EXCHANGE,      
         SEGMENT,      
         MLD_OPBALFLAG      
  FROM   #MINILEDGER_DETAIL       
  WHERE  MLD_OPBALFLAG = 0       
  GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DDNO,MLD_NARRATION,      
           MLD_CLTCODE,MLD_CROSAC,MLD_OPBALFLAG,      
         EXCHANGE,      
         SEGMENT      
  UNION ALL      
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC=(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_SHORTDESC    
        WHEN (MLD_SHORTDESC = 'BIIL' OR MLD_SHORTDESC = 'LOAN') AND SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN 'PAYBNK'    
          WHEN (MLD_SHORTDESC = 'BIIL' OR MLD_SHORTDESC = 'LOAN') AND SUM(MLD_DRAMT-MLD_CRAMT) < 0 THEN 'REPBNK'    
          ELSE MLD_SHORTDESC END) ,      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,  
         MLD_NARRATION,    
         MLD_CLTCODE,      
   MLD_CROSAC,    
         --MLD_CROSAC='',      
         EXCHANGE,      
         SEGMENT,      
         MLD_OPBALFLAG      
  FROM (    
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC=(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_SHORTDESC   
        /*WHEN MLD_SHORTDESC = 'BIIL' AND SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN 'PAYBNK'    
          WHEN MLD_SHORTDESC = 'BIIL' AND SUM(MLD_DRAMT-MLD_CRAMT) < 0 THEN 'PAYBNK'    
          ELSE 'PAYBNK' END)*/    
          WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_SHORTDESC END),      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,      
         MLD_NARRATION=(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_NARRATION    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_NARRATION END),    
         MLD_CLTCODE,     
   MLD_CROSAC,     
         --MLD_CROSAC='',      
         EXCHANGE,      
         SEGMENT,      
         MLD_OPBALFLAG,  
   VNO = (CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_VNO    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN '' ELSE MLD_VNO END)      
  FROM   #MINILEDGER_DETAIL       
  WHERE  MLD_OPBALFLAG <> 0       
  GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DDNO,MLD_BOOKTYPE,ENTEREDBY,(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_VNO    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN '' ELSE MLD_VNO END),    
 (CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_NARRATION    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_NARRATION END),    
           MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG) B     
 GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_NARRATION,MLD_CLTCODE,MLD_DDNO,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG,VNO    
 HAVING SUM(MLD_CRAMT-MLD_DRAMT) <> 0    
  ) A     
) P    

update #ledger set segment = im_ipo_name from ipo_master where im_id = segment
    
SELECT MLD_SNO,MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DRAMT,MLD_CRAMT,    
MLD_DDNO=(CASE WHEN MLD_DDNO='100214' THEN '' ELSE MLD_DDNO END),    
MLD_NARRATION,MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG,LONG_NAME=CM_APPNAME1,
L_ADDRESS1='', L_ADDRESS2='', L_ADDRESS3='', L_CITY='', L_STATE='', L_ZIP='',L_NATION='',RES_PHONE1='',RES_PHONE2='',OFF_PHONE1='',    
OFF_PHONE2='',EMAIL=''
FROM   #LEDGER B,CLIENT_MASTER C1    
WHERE C1.CM_UM_ID = B.MLD_CLTCODE    
ORDER BY SEGMENT,1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_VALIDATE_ADMIN
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[CLASS_VALIDATE_ADMIN]    
(    
    @ADMINID     VARCHAR(50),    
    @IPADDRESS  VARCHAR(20),    
    @RETCODE    INT  OUTPUT,    
    @RETMSG     VARCHAR(200)  OUTPUT,    
    @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,    
    @LASTLOGIN VARCHAR(40) OUTPUT    
)    
AS    

  DECLARE  @@USER_COUNT TINYINT    
  DECLARE  @@LASTLOGIN VARCHAR(40)      
  DECLARE  @@USER_SESSION VARCHAR(200)    
    
                              
  SELECT @@USER_COUNT = COUNT(1)    
  FROM   TBLCLASSADMINLOGINS (NOLOCK)    
  WHERE  FLDADMINNAME = @ADMINID    
                        
  IF ISNULL(@@USER_COUNT,0) = 0    
    BEGIN    
      INSERT INTO TBLCLASSADMINLOGINS    
	  (    
	   FLDAUTO,    
	   FLDADMINNAME,    
	   FLDSTATUS,    
	   FLDSTNAME,    
	   FLDSESSION,    
	   FLDIPADDRESS,    
	   FLDLASTVISIT,    
	   FLDTIMEOUTPRD    
	  )  
	  SELECT A.FLDAUTO_ADMIN,    
		A.FLDNAME,    
		A.FLDSTATUS,    
		A.FLDSTNAME,    
		'',    
		'',    
		GETDATE(),    
		''   
	  FROM   TBLADMIN A (NOLOCK)    
	  WHERE  A.FLDNAME = @ADMINID   
                                 
	  IF @@ERROR <> 0    
		BEGIN    
		 SET @RETCODE = 0    
		 SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'    
		 RETURN    
		END    
	END    
        
    
 SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)    
 FROM TBLCLASSADMINLOGINS    
 WHERE FLDADMINNAME = @ADMINID    
    
    
 SET @@USER_SESSION = NEWID()    
                           
 UPDATE TBLCLASSADMINLOGINS    
 SET    FLDIPADDRESS = @IPADDRESS,    
   FLDSESSION = @@USER_SESSION,    
   FLDLASTVISIT = GETDATE(),    
   FLDLASTLOGIN = GETDATE()    
 WHERE  FLDADMINNAME = @ADMINID    
                            
  IF @@ERROR <> 0    
    BEGIN    
  SET @RETCODE = 0    
  SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'    
  RETURN    
    END    
        
  SET @RETCODE = 1    
  SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'    
  SET @UM_SESSION = @@USER_SESSION    
  SET @LASTLOGIN = @@LASTLOGIN                    
  RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLASS_VALIDATE_USER
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[CLASS_VALIDATE_USER]  
(  
                @USERID     VARCHAR(50),  
                @IPADDRESS  VARCHAR(20),  
                @RETCODE    INT  OUTPUT,  
                @RETMSG     VARCHAR(200)  OUTPUT,  
                @UM_SESSION UNIQUEIDENTIFIER  OUTPUT,  
				@LASTLOGIN VARCHAR(40) OUTPUT  
)  
AS  
  
  DECLARE  @@USER_COUNT TINYINT  
  DECLARE  @@LASTLOGIN VARCHAR(40)    
  DECLARE  @@USER_SESSION VARCHAR(200)  
  
                            
  SELECT @@USER_COUNT = COUNT(1)  
  FROM   TBLCLASSUSERLOGINS (NOLOCK)  
  WHERE  FLDUSERNAME = @USERID  
                         
  IF ISNULL(@@USER_COUNT,0) = 0  
    BEGIN  
      
		INSERT INTO TBLCLASSUSERLOGINS  
		(  
			FLDAUTO,  
			FLDUSERNAME,  
			FLDSTATUS,  
			FLDSTNAME,  
			FLDSESSION,  
			FLDIPADDRESS,  
			FLDLASTVISIT,  
			FLDTIMEOUTPRD  
		)  
		SELECT P.FLDAUTO,  
			P.FLDUSERNAME,  
			A.FLDSTATUS,  
			P.FLDSTNAME,  
			'',  
			'',  
			GETDATE(),  
			ISNULL(M.FLDTIMEOUT,1)  
		FROM   TBLPRADNYAUSERS P (NOLOCK)  
		LEFT OUTER JOIN TBLUSERCONTROLMASTER M (NOLOCK)  
		ON (M.FLDUSERID = P.FLDAUTO)  
		INNER JOIN TBLADMIN A (NOLOCK)  
		ON (P.FLDADMINAUTO = A.FLDAUTO_ADMIN)  
		WHERE  P.FLDUSERNAME = @USERID  
  
		BEGIN  
			SET @RETCODE = 0               
			SET @RETMSG = 'UNABLE TO FETCH USER INFORMATION'               
			RETURN  
		END  
	END  
        
      
  
SELECT @@LASTLOGIN = CONVERT(VARCHAR,ISNULL(FLDLASTLOGIN,''),113)  
FROM TBLCLASSUSERLOGINS  
WHERE FLDUSERNAME = @USERID  
  
  
 SET @@USER_SESSION = NEWID()  
                         
 UPDATE TBLCLASSUSERLOGINS  
 SET    FLDIPADDRESS = @IPADDRESS,  
   FLDSESSION = @@USER_SESSION,  
   FLDLASTVISIT = GETDATE(),  
   FLDLASTLOGIN = GETDATE()  
 WHERE  FLDUSERNAME = @USERID  
                          
  IF @@ERROR <> 0  
    BEGIN  

		INSERT INTO V2_LOGIN_ERR_LOG VALUES (@USERID,'',@IPADDRESS,'LOGIN_FAIL','USER',GETDATE())
		SET @RETCODE = 0  
		SET @RETMSG = 'UNABLE TO UPDATE LOGIN INFORMATION'  

	RETURN  
    END  
								
		INSERT INTO V2_LOGIN_LOG (USERID, USERNAME, CATEGORY, STATUSNAME, STATUSID, IPADD, ACTION, ADDDT)
		SELECT  FLDAUTO,FLDUSERNAME, FLDCATEGORY,TBLPRADNYAUSERS.FLDSTNAME,FLDSTATUS, @IPADDRESS,'LOGIN',GETDATE() 
		FROM TBLPRADNYAUSERS , TBLADMIN WHERE 
		TBLADMIN.FLDAUTO_ADMIN = TBLPRADNYAUSERS.FLDADMINAUTO
		AND FLDUSERNAME = @USERID  

		SET @RETCODE = 1  
		SET @RETMSG = 'USER LOGGED IN SUCCESSFULLY'  
		SET @UM_SESSION = @@USER_SESSION  
		SET @LASTLOGIN = @@LASTLOGIN                  
  RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CLIENT_MASTER_GET
-- --------------------------------------------------
 
-- Creates a new record in the [dbo].[CLIENT_MASTER] table.
CREATE PROCEDURE [dbo].[CLIENT_MASTER_GET]
    @p_CM_UM_ID varchar(61)   
	--,@ErrorCode int output,  
--@Message varchar(200) output  
 AS
BEGIN
 if not exists (SELECT * FROM CLIENT_MASTER WHERE CM_UM_ID =@p_CM_UM_ID)
begin

--SELECT DISTINCT CASE WHEN SUBCM_DESC LIKE '%INDIVI%' THEN 'IND' WHEN SUBCM_DESC LIKE '%HUF%' THEN 'HUF' 
--WHEN SUBCM_DESC LIKE '%NRI%' THEN 'NRI' ELSE DPAM_SUBCM_CD END CM_USER_TYPE,
--STAM_DESC CM_USER_STATUS
--,CM_POA = (SELECT CASE WHEN COUNT(1)=0 THEN '0' ELSE '1' END FROM 
--[172.31.16.94].DMAT.CITRUS_USR.DP_POA_DTLS 
--WHERE DPPD_DPAM_ID=DPAM_ID AND DPPD_DELETED_IND=1)	,
--ISNULL(DPAM_SBA_NAME,'') CM_APPNAME1,
--ISNULL(DPHD_SH_FNAME,'') + ' ' + ISNULL(DPHD_SH_MNAME,'') + ' ' +  ISNULL(DPHD_SH_LNAME,'') CM_APPNAME2,
--ISNULL(DPHD_TH_FNAME,'') + ' ' + ISNULL(DPHD_TH_MNAME,'') + ' ' +  ISNULL(DPHD_TH_LNAME,'') CM_APPNAME3
--,ISNULL(CLIM_DOB,'') CM_DOB1
--,ISNULL(DPHD_SH_DOB,'') CM_DOB2
--,ISNULL(DPHD_TH_DOB,'') CM_DOB3
--,ISNULL(CLIM_GENDER,'') CM_GENDER1
--,ISNULL(DPHD_SH_GENDER,'') CM_GENDER2
--,ISNULL(DPHD_TH_GENDER,'') CM_GENDER3
--,ISNULL(DPHD_FH_FTHNAME,'') CM_FATHERHUSBAND
--,ISNULL(ENTP_VALUE,'') CM_PAN1
--,ISNULL(DPHD_SH_PAN_NO,'') CM_PAN2
--,ISNULL(DPHD_TH_PAN_NO,'') CM_PAN3
--,'' CM_CIRCLE1
--,'' CM_CIRCLE2
--, ''CM_CIRCLE3
--, ''CM_MAPINFLAG 
--,'' CM_MAPIN
--, '' CM_CATEGORY 
--,  '' CM_BM_ID 
--, '' CM_SBM_ID 
--,rtrim(ltrim(ISNULL(DPHD_NOM_FNAME,''))) + ' ' + rtrim(ltrim(ISNULL(DPHD_NOM_MNAME,''))) + ' ' +  rtrim(ltrim(ISNULL(DPHD_NOM_LNAME,''))) CM_NOMINEE
--, '' CM_NOMINEE_RELATION
--,  ISNULL(DPHD_GAU_PAN_NO,'') CM_GUARDIANPAN
--, CDD_DEPOSITORY = CASE WHEN LEN(DPAM_SBA_NO)=16 THEN 'CDSL' ELSE 'NSDL' END
--,  CDD_DPID = (SELECT TOP 1 DPM_DPID FROM [172.31.16.94].DMAT.CITRUS_USR.DP_MSTR WHERE DPM_EXCSM_ID=DPAM_EXCSM_ID AND DPM_DELETED_IND=1)
--,   CDD_DPNAME = (SELECT TOP 1 DPM_NAME FROM [172.31.16.94].DMAT.CITRUS_USR.DP_MSTR WHERE
--    DPM_EXCSM_ID=DPAM_EXCSM_ID AND DPM_DELETED_IND=1) 
--, CDD_CLIENTDPID = ISNULL(DPAM_SBA_NO,'')  
--, CBD_BANK_NAME = (SELECT TOP 1  BANM_NAME FROM [172.31.16.94].DMAT.CITRUS_USR.BANK_MSTR WHERE BANM_ID=CLIBA_BANM_ID) 
--,    CBD_BRANCH = (SELECT TOP 1  BANM_BRANCH FROM [172.31.16.94].DMAT.CITRUS_USR.BANK_MSTR WHERE BANM_ID=CLIBA_BANM_ID) 
--,  CBD_CITY = (SELECT TOP 1  BANM_BRANCH FROM [172.31.16.94].DMAT.CITRUS_USR.BANK_MSTR WHERE BANM_ID=CLIBA_BANM_ID) 
--,  CBD_ACCTYPE = CLIBA_AC_TYPE 
--,    CBD_ACCNO = CLIBA_AC_NO 
--,  CBD_CUSTID = '' 
--,  CBD_CHEQUENAME = '' ,ISNULL(ACCP_VALUE,'') CM_PARTY_CODE
--FROM [172.31.16.94].DMAT.CITRUS_USR.DP_ACCT_MSTR
--LEFT OUTER JOIN [172.31.16.94].DMAT.CITRUS_USR.ENTITY_PROPERTIES ON
--ENTP_ENT_ID=DPAM_CRN_NO AND ENTP_ENTPM_CD='PAN_GIR_NO' AND ENTP_DELETED_IND=1
--,[172.31.16.94].DMAT.CITRUS_USR.SUB_CTGRY_MSTR  
--,[172.31.16.94].DMAT.CITRUS_USR.STATUS_MSTR,[172.31.16.94].DMAT.CITRUS_USR.DP_HOLDER_DTLS,[172.31.16.94].DMAT.CITRUS_USR.CLIENT_MSTR 
--,[172.31.16.94].DMAT.CITRUS_USR.CLIENT_BANK_ACCTS 
--left outer join [172.31.16.94].DMAT.CITRUS_USR.ACCOUNT_PROPERTIES on  ACCP_CLISBA_ID=cliba_clisba_id AND ACCP_ACCPM_PROP_CD='BBO_CODE'
--WHERE DPAM_SBA_NO=@p_CM_UM_ID
--AND DPAM_SUBCM_CD =SUBCM_CD AND DPAM_DELETED_IND=1 
--AND DPAM_STAM_CD=STAM_CD AND DPAM_CRN_NO=CLIM_CRN_NO AND CLIM_DELETED_IND=1
--AND DPAM_ID=DPHD_DPAM_ID AND CLIBA_CLISBA_ID=DPAM_ID AND CLIBA_FLG='1' 
--AND ENTP_ENT_ID=DPAM_CRN_NO AND ENTP_ENTPM_CD='PAN_GIR_NO' AND ENTP_DELETED_IND=1


select * from [172.31.16.94].DMAT.CITRUS_USR.CLIENT_MASTER_GET_IPO where DPAM_SBA_NO=@p_CM_UM_ID
--select * from [196.1.115.196].msajag.dbo.CLIENT_MASTER where cdd_clientdpid=@p_CM_UM_ID
end
else
begin 
print '123'
SELECT * FROM CLIENT_MASTER,CLIENT_BANK_DETAILS,CLIENT_DP_DETAILS 
WHERE CM_UM_ID =@p_CM_UM_ID
and CBD_CM_ID = cm_id
and CDD_CM_ID = cm_id

end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CREATE_CLASS_USER
-- --------------------------------------------------


/*
Use MSAJAG

Use BSEDB

Use NSEFO

Use NSECURFO

Use MCDXCDS

Use BSEFO
*/

CREATE PROC [dbo].[CREATE_CLASS_USER]  
(
 @FLDAUTO VARCHAR(50),	  
 @USERNAME VARCHAR(25),  
 @PASSWORD VARCHAR(50),  
 @FIRSTNAME VARCHAR(25),  
 @MIDDLENAME VARCHAR(25),  
 @LASTNAME VARCHAR(25),  
 @SEX  VARCHAR(8),  
 @ADD1  VARCHAR(100),  
 @MAILADD2 VARCHAR(100),  
 @PHONE1  VARCHAR(10),  
 @PHONE2  VARCHAR(10),   
 @CATEGORY VARCHAR(10),  
 @ADMIN_AUTO INT,  
 @STNAME  VARCHAR(50),  
 @ADMIN_NAME VARCHAR(30),  
 @IPADD  VARCHAR(20),  
 @PWDEXPIRYDAYS SMALLINT,  
 @USERSTATUS SMALLINT,  
 @ATTEMPTCOUNT SMALLINT,  
 @MAXATTEMPTCOUNT SMALLINT,  
 @ACCESSLEVEL CHAR(1),  
 @LOGINSTATUS SMALLINT,
 @FIRSTLOGIN CHAR(1),	
 @USERIPADDRESS VARCHAR(2000),
 @USERTYPE VARCHAR(25), 	
 @EXCHANGE VARCHAR(3),
 @SEGMENT VARCHAR(20),
 @CREATION_FLAG VARCHAR(3), --All or Single segment
 @ACTION_FLAG VARCHAR(20), -- EDIT OR REGISTER 
 @FLD_MAC_ID VARCHAR(200)
)  
  
AS
DECLARE   
 @@EDIT_FLAG  CHAR(1),  
 @@NEWDATE  DATETIME, 
 @@EXPDATE  VARCHAR(11), 	 
 @@FLDLOG_DATA VARCHAR(8000),  
 @@FLDAUTO  INT,  
 @@FLDAUTO_NEW INT,
 @@FLDADMINAUTO INT,	
 @@ERROR_COUNT BIGINT,  
 @MESSAGE  VARCHAR(200),
 @MOB_ACCESS SMALLINT,
 @RESULT VARCHAR(MAX),
 @TIMEOUT  SMALLINT,
 @FORCELOGOUT SMALLINT

BEGIN TRAN   
/*
CREATE_CLASS_USER_ALL  '81928',  'MeUser',  'B5A07E53E1EF805D',  'MeUser',  'MeUser',  'MeUser',  'MALE',  'Mumbai',  'a@c.n',  '9867534119',  '5454545454',  '428',  '2',  'Broker',  'Administrator',  '10.228.50.74',  '30',  2,  0,  6,  'F',  0,  'Y',  ''
,  'Broker',  'NSE',  'CAPITAL',  '',  'SIN',  'Edit',  ''  

SELECT top 1 FLDUSERNAME = '12',FLDFIRSTNAME = '54',RESULT = 'PRADNYA & USER CONTROL MASTER NOT POPULATED PROPERLY!',EXCHANGE = '54', SEGMENT = '54'
from tblpradnyausers
ROLLBACK 
RETURN	*/

SET @@NEWDATE = GETDATE()
SET @@EXPDATE = CONVERT(VARCHAR,GETDATE() + @PWDEXPIRYDAYS,109)  
/*SELECT 
	@MOB_ACCESS = MOB_ACCESS 
FROM 
	PRADNYA.DBO.ADMIN_INFO*/

IF UPPER(@ACTION_FLAG) = 'EDIT' 
 BEGIN
	SET @@EDIT_FLAG = 'E' 
	SET @@FLDLOG_DATA = '' 
 END
ELSE
 IF UPPER(@ACTION_FLAG) = 'REGISTER' 
  BEGIN
	SET @@EDIT_FLAG = 'A' 
	SET @@FLDLOG_DATA = 'ADDENTRY' 
  END	
ELSE
 IF UPPER(@ACTION_FLAG) = 'DELETE'
  BEGIN
	SET @@EDIT_FLAG = 'D' 
	SET @@FLDLOG_DATA = ''   
  END 

--BEGIN TRY
	IF UPPER(@ACTION_FLAG) = 'EDIT' 
     BEGIN
		
		SELECT @@FLDAUTO = FLDAUTO, @@FLDADMINAUTO = FLDADMINAUTO FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERNAME
	
		SELECT   
		 @@ERROR_COUNT = COUNT(FLDUSERNAME)
		FROM     
		 TBLPRADNYAUSERS (NOLOCK)   
		WHERE  
		 FLDUSERNAME = @USERNAME 
		
		IF @@ERROR_COUNT <> 0    
		BEGIN 
		
		
		SELECT @TIMEOUT = FLDTIMEOUT/*,@FIRSTLOGIN = FLDFIRSTLOGIN,@FORCELOGOUT = FLDFORCELOGOUT*/ FROM TBLUSERCONTROLGLOBALS	WHERE FLDCATEGORYID = @CATEGORY
		
		SELECT
			@@FLDLOG_DATA = @PASSWORD +'~'+ 
			CASE WHEN @FIRSTNAME = '' THEN '$' ELSE @FIRSTNAME END +'~'+
			CASE WHEN @MIDDLENAME = '' THEN '$' ELSE @MIDDLENAME END +'~'+
			CASE WHEN @LASTNAME = '' THEN '$' ELSE @LASTNAME END +'~'+
			CASE WHEN @SEX = '' THEN '$' ELSE @SEX END +'~'+
			CASE WHEN @ADD1 = '' THEN '$' ELSE @ADD1 END +'~'+
			CASE WHEN @MAILADD2 = '' THEN '$' ELSE @MAILADD2 END  +'~'+
			CASE WHEN @PHONE1 = '' THEN '$' ELSE @PHONE1 END +'~'+
			CASE WHEN @PHONE2 = '' THEN '$' ELSE @PHONE2 END +'~'+
			CASE WHEN CONVERT(VARCHAR,@CATEGORY) = '' THEN '$' ELSE CONVERT(VARCHAR,@CATEGORY) END+'~'+
			CASE WHEN CONVERT(VARCHAR,@PWDEXPIRYDAYS) = '' THEN '$' ELSE CONVERT(VARCHAR,@PWDEXPIRYDAYS) END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,@MAXATTEMPTCOUNT) = '' THEN '$' ELSE CONVERT(VARCHAR,@MAXATTEMPTCOUNT) END +'~'+
			CASE WHEN CONVERT(VARCHAR,@USERSTATUS) = '' THEN '$' ELSE CONVERT(VARCHAR,@USERSTATUS) END +'~'+
			CASE WHEN CONVERT(VARCHAR,@LOGINSTATUS) = '' THEN '$' ELSE CONVERT(VARCHAR,@LOGINSTATUS) END +'~'+
			CASE WHEN @ACCESSLEVEL = '' THEN '$' ELSE @ACCESSLEVEL END +'~'+
			CASE WHEN @USERIPADDRESS  = '' THEN '$' ELSE @USERIPADDRESS END+'~'+
			CASE WHEN CONVERT(VARCHAR,@TIMEOUT) = '' THEN '$' ELSE CONVERT(VARCHAR,@TIMEOUT) END +'~'+
			CASE WHEN @FIRSTLOGIN = '' THEN '$' ELSE @FIRSTLOGIN END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,@FORCELOGOUT) = '' THEN '$' ELSE CONVERT(VARCHAR,@FORCELOGOUT) END +'~'+
			CASE WHEN @FLD_MAC_ID = '' THEN '$' ELSE @FLD_MAC_ID END
		from owner

		/*SELECT 
			@@FLDLOG_DATA = FLDPASSWORD +'~'+ 
			CASE WHEN FLDFIRSTNAME = '' THEN '$' ELSE FLDFIRSTNAME END +'~'+
			CASE WHEN FLDMIDDLENAME = '' THEN '$' ELSE FLDMIDDLENAME END +'~'+
			CASE WHEN FLDLASTNAME = '' THEN '$' ELSE FLDLASTNAME END +'~'+
			CASE WHEN FLDSEX = '' THEN '$' ELSE FLDSEX END +'~'+
			CASE WHEN FLDADDRESS1 = '' THEN '$' ELSE FLDADDRESS1 END +'~'+
			CASE WHEN FLDADDRESS2 = '' THEN '$' ELSE FLDADDRESS2 END  +'~'+
			CASE WHEN FLDPHONE1 = '' THEN '$' ELSE FLDPHONE1 END +'~'+
			CASE WHEN FLDPHONE2 = '' THEN '$' ELSE FLDPHONE2 END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDCATEGORY) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDCATEGORY) END+'~'+
			CASE WHEN CONVERT(VARCHAR,PWD_EXPIRY_DATE) = '' THEN '$' ELSE CONVERT(VARCHAR,PWD_EXPIRY_DATE) END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,FLDATTEMPTCNT) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDATTEMPTCNT) END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDSTATUS) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDSTATUS) END +'~'+
			CASE WHEN CONVERT(VARCHAR,FLDLOGINFLAG) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDLOGINFLAG) END +'~'+
			CASE WHEN FLDACCESSLVL = '' THEN '$' ELSE FLDACCESSLVL END +'~'+
			CASE WHEN FLDIPADD  = '' THEN '$' ELSE FLDIPADD END+'~'+
			CASE WHEN CONVERT(VARCHAR,FLDTIMEOUT) = '' THEN '$' ELSE FLDFIRSTLOGIN END +'~'+
			CASE WHEN FLDFIRSTLOGIN = '' THEN '$' ELSE FLDFIRSTLOGIN END +'~'+ 
			CASE WHEN CONVERT(VARCHAR,FLDFORCELOGOUT) = '' THEN '$' ELSE CONVERT(VARCHAR,FLDFORCELOGOUT) END +'~'+
			CASE WHEN FLD_MAC_ID = '' THEN '$' ELSE FLD_MAC_ID END
		FROM 
			TBLPRADNYAUSERS TP, TBLUSERCONTROLMASTER TU 
		WHERE 
			TP.FLDAUTO = FLDUSERID
			AND FLDUSERNAME = @USERNAME */
		
		-- CLASS USER LOG TABLE ------------------------------  
		INSERT INTO   
		TBLPRADNYAUSERS_LOG  
		(  
		FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2,  
		FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA  
		)  
		SELECT  
			FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1,  
			FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, @@NEWDATE, @@EDIT_FLAG, @ADMIN_NAME, @@NEWDATE, @IPADD, @@FLDLOG_DATA  
		FROM   
			TBLPRADNYAUSERS  
		WHERE   
			FLDUSERNAME =@USERNAME  

		INSERT INTO   
			TBLUSERCONTROLMASTER_JRNL   
		SELECT   
			FLDAUTO,
			FLDUSERID,
			FLDPWDEXPIRY,
			FLDMAXATTEMPT,
			FLDATTEMPTCNT,
			FLDSTATUS,
			FLDLOGINFLAG,
			FLDACCESSLVL,
			FLDIPADD,
			FLDTIMEOUT,
			FLDFIRSTLOGIN,
			FLDFORCELOGOUT,
			@@FLDADMINAUTO,
			@@NEWDATE,
			FLD_MAC_ID   
		FROM   
			TBLUSERCONTROLMASTER  
		WHERE   
			FLDUSERID = @@FLDAUTO  
		
		UPDATE 
			TBLPRADNYAUSERS 
		SET 
			FLDUSERNAME = @USERNAME, FLDPASSWORD = @PASSWORD, FLDFIRSTNAME = @FIRSTNAME, FLDMIDDLENAME = @MIDDLENAME,
			FLDLASTNAME = @LASTNAME, FLDSEX = @SEX,	FLDADDRESS1 = @ADD1, FLDADDRESS2 = @MAILADD2, FLDPHONE1 = @PHONE1,
			FLDPHONE2 = @PHONE2, FLDCATEGORY = @CATEGORY, FLDSTNAME = @STNAME, PWD_EXPIRY_DATE = @@EXPDATE, EDIT_FLAG = @@EDIT_FLAG 
		WHERE 
			FLDAUTO = @@FLDAUTO
		
		
		UPDATE 
			TBLUSERCONTROLMASTER
		SET
			FLDPWDEXPIRY = @PWDEXPIRYDAYS, FLDMAXATTEMPT = @MAXATTEMPTCOUNT, FLDATTEMPTCNT = 0, FLDSTATUS = @USERSTATUS,
			FLDLOGINFLAG = @LOGINSTATUS, FLDACCESSLVL = @ACCESSLEVEL, FLDIPADD = @USERIPADDRESS, FLDFIRSTLOGIN = @FIRSTLOGIN, FLD_MAC_ID = @FLD_MAC_ID
		WHERE 
			FLDUSERID = @@FLDAUTO

		SET @RESULT = 'EDITED SUCCESSFULLY'
	  	
		IF @@ERROR = 0
		 BEGIN
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
			SELECT @USERNAME,@FIRSTNAME, @RESULT ,'',''
		 END
		END
 		ELSE
		 BEGIN
			SET @MESSAGE = 'USER DOST NOT EXIST IN SYSTEM!'    
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
			SELECT @USERNAME,@FIRSTNAME, @MESSAGE ,'','' 
		 END 
	 END
   	ELSE	
	 BEGIN
		SELECT   
		 @@ERROR_COUNT = COUNT(FLDUSERNAME)
		FROM     
		 TBLPRADNYAUSERS (NOLOCK)   
		WHERE  
		 FLDUSERNAME =@USERNAME 
		
		IF @@ERROR_COUNT = 0    
		 BEGIN   
				--MAIN CLASS USER TABLE------------------------------  
			INSERT INTO   
			 TBLPRADNYAUSERS  
			(  
			 FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, 
			 FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE,EDIT_FLAG, CREATED_BY, MODIFIED_BY  
			)  
			VALUES  
			(  
			 @USERNAME, @PASSWORD, @FIRSTNAME, @MIDDLENAME, @LASTNAME, @SEX, @ADD1, @MAILADD2, @PHONE1, @PHONE2, @CATEGORY,   
			 @ADMIN_AUTO, @STNAME, @@EXPDATE, @@EDIT_FLAG, @ADMIN_NAME, @ADMIN_NAME   
			)  
		  
			-- CLASS USER LOG TABLE ------------------------------  
			INSERT INTO   
			 TBLPRADNYAUSERS_LOG  
			(  
			 FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2,  
			 FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA  
			)  
			SELECT  
			 FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1,  
			 FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, @@NEWDATE, @@EDIT_FLAG, @ADMIN_NAME, @@NEWDATE, @IPADD, @@FLDLOG_DATA  
			FROM   
			 TBLPRADNYAUSERS  
			WHERE   
			 FLDUSERNAME =@USERNAME  
		 
		 
			SELECT @@FLDAUTO_NEW = FLDAUTO FROM TBLPRADNYAUSERS WHERE FLDUSERNAME = @USERNAME
			
			-- USER CONTROL MASTER TABLE -----------------------------  
			INSERT INTO TBLUSERCONTROLMASTER 
				(
				FLDUSERID,
				FLDPWDEXPIRY,
				FLDMAXATTEMPT,
				FLDATTEMPTCNT,
				FLDSTATUS,
				FLDLOGINFLAG,
				FLDACCESSLVL,
				FLDIPADD,
				FLDTIMEOUT,
				FLDFIRSTLOGIN,
				FLDFORCELOGOUT,
				FLD_MAC_ID
				)  
			SELECT   
				A.FLDAUTO, 
				@PWDEXPIRYDAYS, 
				@MAXATTEMPTCOUNT,
				@ATTEMPTCOUNT, 
				@USERSTATUS, 
				0, 
				@ACCESSLEVEL, 
				@USERIPADDRESS, 
				B.FLDTIMEOUT,  
				B.FLDFIRSTLOGIN, 
				B.FLDFORCELOGOUT
				, 
				@FLD_MAC_ID  
			FROM   
				TBLPRADNYAUSERS A LEFT OUTER JOIN TBLUSERCONTROLMASTER X  
			ON   
				(A.FLDAUTO = X.FLDUSERID), TBLUSERCONTROLGLOBALS B  
			WHERE   
				B.FLDCATEGORYID = A.FLDCATEGORY  
				AND ISNULL(A.FLDAUTO,0) = @@FLDAUTO_NEW  
		   
			--LOG USER CONTROL MASTER TABLE -----------------------------  
			  
			INSERT INTO   
			 TBLUSERCONTROLMASTER_JRNL   
			SELECT   
				FLDAUTO,
				FLDUSERID,
				FLDPWDEXPIRY,
				FLDMAXATTEMPT,
				FLDATTEMPTCNT,
				FLDSTATUS,
				FLDLOGINFLAG,
				FLDACCESSLVL,
				FLDIPADD,
				FLDTIMEOUT,
				FLDFIRSTLOGIN,
				FLDFORCELOGOUT,
				@@FLDADMINAUTO,
				@@NEWDATE,
				FLD_MAC_ID 
			FROM   
			 TBLUSERCONTROLMASTER  
			WHERE   
			 FLDUSERID = @@FLDAUTO_NEW  
		  
			--FOR MOBILE USER 
			/*IF @MOB_ACCESS = 1 AND @USERTYPE = 'CLIENT'
			  BEGIN
				INSERT INTO PRADNYA.DBO.USER_INFO (CLIENTID,USERNAME,LASTNAME,MAILID,STATUS_FLAG,EXCHANGE,SEGMENT,LOGIN_FLAG)
				SELECT 
					FLDUSERNAME, FLDFIRSTNAME, FLDLASTNAME, FLDADDRESS2, 1, EXCHANGE = @EXCHANGE+'·', SEGMENT = '|'+@SEGMENT, LOGIN_FLAG = 0 
				FROM 
					TBLPRADNYAUSERS 
				WHERE
					 FLDUSERNAME = @USERNAME  
			  END */  		
			
			SET @RESULT = 'CREATED SUCCESSFULLY..'
	  	
			IF @@ERROR = 0
			 BEGIN
				SELECT  
					FLDUSERNAME, FLDFIRSTNAME, RESULT = @RESULT, EXCHANGE='', SEGMENT = '' INTO #RES 
				FROM 
					TBLPRADNYAUSERS TP, TBLUSERCONTROLMASTER TU
				WHERE
					 FLDUSERNAME = @USERNAME 
					 AND TP.FLDAUTO = TU.FLDUSERID
				
				IF @@ROWCOUNT = 0 
				 BEGIN
					ROLLBACK TRAN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
					SELECT FLDUSERNAME = '',FLDFIRSTNAME = '',RESULT = 'PRADNYA & USER CONTROL MASTER NOT POPULATED PROPERLY!',EXCHANGE = '', SEGMENT = ''
					RETURN	
				 END
				ELSE
				 BEGIN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
					SELECT * FROM #RES
				 END	
			 END 
		  END
		ELSE 
		 BEGIN
			SET @MESSAGE = 'USER ALREADY EXIST IN SYSTEM!'
			INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)    
			SELECT @USERNAME,'', @MESSAGE ,'','' 
		 END 
	END			
/*END TRY
BEGIN CATCH
	SELECT 
        ERROR_MESSAGE() AS MESSAGE;
		ROLLBACK
END CATCH*/
IF @@ERROR = 0
 BEGIN
	COMMIT TRAN
 END
ELSE
 BEGIN
	ROLLBACK TRAN	
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CREATE_CLASS_USER_ALL
-- --------------------------------------------------


CREATE PROC [dbo].[CREATE_CLASS_USER_ALL]
(
	 @FLDAUTO		VARCHAR(50),	  
	 @USERNAME		VARCHAR(25),  
	 @PASSWORD		VARCHAR(50),  
	 @FIRSTNAME		VARCHAR(25),  
	 @MIDDLENAME	VARCHAR(25),  
	 @LASTNAME		VARCHAR(25),  
	 @SEX			VARCHAR(8),  
	 @ADD1			VARCHAR(100),  
	 @MAILADD2		VARCHAR(100),  
	 @PHONE1		VARCHAR(10),  
	 @PHONE2		VARCHAR(10),   
	 @CATEGORY		VARCHAR(10),  
	 @ADMIN_AUTO	INT,  
	 @STNAME		VARCHAR(50),  
	 @ADMIN_NAME	VARCHAR(30),  
	 @IPADD			VARCHAR(20),  
	 @PWDEXPIRYDAYS SMALLINT,  
	 @USERSTATUS	SMALLINT,  
	 @ATTEMPTCOUNT	SMALLINT,  
	 @MAXATTEMPTCOUNT SMALLINT,  
	 @ACCESSLEVEL	CHAR(1),  
	 @LOGINSTATUS	SMALLINT,
	 @FIRSTLOGIN	CHAR(1),	
	 @USERIPADDRESS VARCHAR(2000),
	 @USERTYPE		VARCHAR(25), 	
	 @EXCHANGE		VARCHAR(3),
	 @SEGMENT		VARCHAR(20),
	 @EXCSEG		VARCHAR(MAX),
	 @CREATION_FLAG VARCHAR(10), --All or Single segment
	 @ACTION_FLAG	VARCHAR(20), -- EDIT OR REGISTER 
	 @FLD_MAC_ID	VARCHAR(200)	
)

AS
/*
BEGIN TRAN
[CREATE_CLASS_USER_ALL]  '80662',  'AJAY',  'A8EE7FDD1FA67206',  'Ajay',  'n',  'Sengar',  'MALE',  'mumbai',  'a@c.c',  '46454',  '',  '400',  '2',  'Broker',  'Administrator',  '10.11.12.74',  '30',  2,  0,  6,  'F',  0,  'N',  '10.11.12.74',  'Broker',
  
'NSE',  'CAPITAL',  '',  'MULTI',  'Edit',
'10.11.12.74'  

ROLLBACK	
SELECT FLDAUTO_ADMIN FROM [MTSRVR06\DEV].NSEFO.DBO.TBLADMIN WHERE FLDNAME = 'Broker' 
INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) 
select * from nsefo..tblpradnyausers where fldusername = 'ajay'
EXECUTE CREATE_CLASS_USER_ALL  '',  'All',  'B5A07E53E1EF805D',  'bhrt',  'bhrt',  'bhrt',  'MALE',  'mum',  'a@c.n',  '9898989898',  '9989889898',  '388',  '2',  'Broker',  'Administrator',  '10.11.12.74',  '31',  2,  0,  6,  'F',  0,  'Y',  '',  'Broker
',  'NSE',  'CAPITAL',  'BSE~CAPITAL,NSE~CAPITAL,BSE~FUTURES,NSE~FUTURES,',  'Choose',  'Register',  '' 
*/
BEGIN TRY
 CREATE TABLE [DBO].[#DBNAME]  
 (  
	SHAREDB VARCHAR(50),
	SHARESERVER VARCHAR(50),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10)
 ) ON [PRIMARY]  

 CREATE TABLE [DBO].[#RESULT]  
 (  
	UNAME VARCHAR(50),
	FIRSTNAME VARCHAR(50),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10),
	RESULT VARCHAR(MAX)
 ) ON [PRIMARY]

 CREATE TABLE [DBO].#ADMIN_AUTO
 (
	ADMIN_AUTO INT	
 ) ON [PRIMARY]

 CREATE TABLE [DBO].#MKCK
 (
	MKCKFLAG INT	
 )
	
 CREATE TABLE [DBO].#CATEGORY
 (
	CATEGORY VARCHAR(50),
	CATEGORYCODE INT
 ) ON [PRIMARY]
 CREATE TABLE [DBO].#PRADNYA
 (
	FLDAUTO	INT,
	FLDADMINAUTO INT
 )

DECLARE  
 @@SHAREDB VARCHAR(20),	  
 @@SHARESVR VARCHAR(20),  
 @@EXCHANGE VARCHAR(15),  
 @@SEGMENT VARCHAR(15),  
 @@ORDERFLAG VARCHAR(1),  
 @@SQL VARCHAR(5000),
 @@DB VARCHAR(MAX),
 @@SEGORD TINYINT,
 @@FLDNAME VARCHAR(30),	
 @@CATFLAG INT,	  
 @@CATNAME VARCHAR(50),
 @@MKCKFLAG INT,
 @@FLDAUTO	INT,
 @@FLDADMINAUTO INT,	 	
 @@MAINREC AS CURSOR  
 

	SELECT @@FLDNAME = FLDNAME FROM TBLADMIN WHERE FLDAUTO_ADMIN = @ADMIN_AUTO
	SELECT @@CATNAME = FLDCATEGORYNAME FROM TBLCATEGORY WHERE FLDCATEGORYCODE = @CATEGORY
	
	SET @@DB = " INSERT INTO #DBNAME "   
	SET @@DB = @@DB + " SELECT "
	SET @@DB = @@DB + "		SHAREDB, SHARESERVER, EXCHANGE, SEGMENT "
	SET @@DB = @@DB + " FROM "
	SET @@DB = @@DB + "		PRADNYA.DBO.MULTICOMPANY (NOLOCK) "
	SET @@DB = @@DB + " WHERE "
	SET @@DB = @@DB + " 	PRIMARYSERVER = 1 "
	IF UPPER(@CREATION_FLAG) = 'CHOOSE'
	 BEGIN	
		SET @@DB = @@DB + "		AND EXCHANGE+'~'+SEGMENT IN ('" + REPLACE(@EXCSEG,',',''',''') + "')  "
	 END
	ELSE
	 IF UPPER(@CREATION_FLAG) = 'SIN'
	  BEGIN	
		SET @@DB = @@DB + "		AND EXCHANGE+'~'+SEGMENT IN ( '"+@EXCHANGE+"' +'~'+ '"+@SEGMENT+"' ) "
      END 
	 		
	SET @@DB = @@DB + " ORDER BY "
	SET @@DB = @@DB + "		EXCHANGE "  

	PRINT @@DB
	EXEC(@@DB)  

	SET @@MAINREC = CURSOR FOR  
	
	SELECT SHAREDB, SHARESERVER, EXCHANGE, SEGMENT FROM #DBNAME  
	SET @@SEGORD = 1  
	
	OPEN @@MAINREC  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT  
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			IF @@SHARESVR <> @@SERVERNAME 
				BEGIN
					
					SET @@SQL = " INSERT INTO #ADMIN_AUTO SELECT FLDAUTO_ADMIN FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLADMIN WHERE FLDNAME = '"+ @@FLDNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #CATEGORY SELECT FLDCATEGORYNAME,FLDCATEGORYCODE FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLCATEGORY WHERE FLDCATEGORYNAME = '"+ @@CATNAME + "' "
					SET @@SQL = @@SQL + " INSERT INTO #MKCK SELECT MKCKFLAG FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLGLOBALPARAMS "
					SET @@SQL = @@SQL + " INSERT INTO #PRADNYA SELECT FLDAUTO, FLDADMINAUTO FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+@USERNAME+"' "
				END
			 ELSE
				BEGIN	
					SET @@SQL = " INSERT INTO #ADMIN_AUTO SELECT FLDAUTO_ADMIN FROM " + @@SHAREDB + ".DBO.TBLADMIN WHERE FLDNAME = '"+ @@FLDNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #CATEGORY SELECT FLDCATEGORYNAME,FLDCATEGORYCODE FROM " + @@SHAREDB + ".DBO.TBLCATEGORY WHERE FLDCATEGORYNAME = '"+ @@CATNAME +"' "
					SET @@SQL = @@SQL + " INSERT INTO #MKCK SELECT MKCKFLAG FROM " + @@SHAREDB + ".DBO.TBLGLOBALPARAMS "
					SET @@SQL = @@SQL + " INSERT INTO #PRADNYA SELECT FLDAUTO, FLDADMINAUTO FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+@USERNAME+"' "
				END
		
			PRINT @@SQL	
			EXEC(@@SQL)

			SELECT @@MKCKFLAG = MKCKFLAG FROM #MKCK
			--SELECT @@FLDAUTO = FLDAUTO, @@FLDADMINAUTO = FLDADMINAUTO FROM #PRADNYA	 				
			SELECT @CATEGORY = CATEGORYCODE FROM #CATEGORY 
			SELECT @ADMIN_AUTO = ADMIN_AUTO FROM #ADMIN_AUTO
			
						
			IF @@ROWCOUNT = 0 
			 BEGIN
				INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) VALUES('','','<B><U>'+ @@FLDNAME +'</U></B> ADMIN USER IS NOT AVAILABLE IN THIS EXCH - SEG','','')
			 END
			ELSE
			 IF (SELECT COUNT(1) FROM #CATEGORY ) = 0
				BEGIN
					INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) VALUES('','','USER CATEGORY IS NOT AVAILABLE IN THIS EXCH - SEG','','')		
				END			
			ELSE
			 BEGIN	
			 --SET @@SQL = " INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT) "
			 IF @@SHARESVR <> @@SERVERNAME 
				BEGIN
					SET @@SQL = @@SQL + " EXEC " + @@SHARESVR + "." + @@SHAREDB + ".DBO.CREATE_CLASS_USER "
				END
			 ELSE
				BEGIN	
					SET @@SQL = @@SQL + " EXEC " + @@SHAREDB + ".DBO.CREATE_CLASS_USER "
				END
			SET @@SQL = @@SQL + "  '" + @FLDAUTO + "' "
			SET @@SQL = @@SQL + ", '" + @USERNAME + "' "
			SET @@SQL = @@SQL + ", '" + @PASSWORD + "' "
			SET @@SQL = @@SQL + ", '" + @FIRSTNAME + "' "
			SET @@SQL = @@SQL + ", '" + @MIDDLENAME + "' "
			SET @@SQL = @@SQL + ", '" + @LASTNAME + "' "
			SET @@SQL = @@SQL + ", '" + @SEX + "' "
			SET @@SQL = @@SQL + ", '" + @ADD1 + "' "
			SET @@SQL = @@SQL + ", '" + @MAILADD2 + "' "
			SET @@SQL = @@SQL + ", '" + @PHONE1 + "' "
			SET @@SQL = @@SQL + ", '" + @PHONE2 + "' "
			SET @@SQL = @@SQL + ", '" + @CATEGORY + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@ADMIN_AUTO) + " "
			SET @@SQL = @@SQL + ", '" + @STNAME + "' "
			SET @@SQL = @@SQL + ", '" + @ADMIN_NAME + "' "
			SET @@SQL = @@SQL + ", '" + @IPADD + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@PWDEXPIRYDAYS) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,CASE WHEN @@MKCKFLAG = 0 THEN 0 ELSE @USERSTATUS END) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@ATTEMPTCOUNT) + " "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@MAXATTEMPTCOUNT) + " "
			SET @@SQL = @@SQL + ", '" + @ACCESSLEVEL + "' "
			SET @@SQL = @@SQL + ",  " + CONVERT(VARCHAR,@LOGINSTATUS) + " "
			SET @@SQL = @@SQL + ", '" + @FIRSTLOGIN + "' "
			SET @@SQL = @@SQL + ", '" + @USERIPADDRESS + "' "
			SET @@SQL = @@SQL + ", '" + @USERTYPE + "' "
			SET @@SQL = @@SQL + ", '" + @EXCHANGE + "' " 
			SET @@SQL = @@SQL + ", '" + @SEGMENT + "' " 
			SET @@SQL = @@SQL + ", '" + @CREATION_FLAG + "' " 
			SET @@SQL = @@SQL + ", '" + @ACTION_FLAG + "' " 
			SET @@SQL = @@SQL + ", '" + @FLD_MAC_ID + "' " 
			PRINT (@@SQL)
			EXEC(@@SQL)
		   END	

			UPDATE 
				#RESULT
			SET 
				EXCHANGE = @@EXCHANGE,
				SEGMENT = @@SEGMENT
			WHERE 
				EXCHANGE = '' AND SEGMENT = ''
			
			TRUNCATE TABLE #ADMIN_AUTO
			TRUNCATE TABLE #MKCK
			TRUNCATE TABLE #CATEGORY		
	SET @@SEGORD = @@SEGORD + 1  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT
	END 

	SELECT * FROM #RESULT
	TRUNCATE TABLE #DBNAME  
	DROP TABLE #DBNAME
END TRY
BEGIN CATCH
	INSERT INTO #RESULT (UNAME,FIRSTNAME,RESULT, EXCHANGE, SEGMENT)
	SELECT '','',
        ERROR_MESSAGE() AS MESSAGE,'','';
        
        SELECT * FROM #RESULT
		ROLLBACK
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DELETE_CLASS_USER_ALL
-- --------------------------------------------------

CREATE PROC [dbo].[DELETE_CLASS_USER_ALL]
(
	@UNAME		VARCHAR(30),
	@EXCSEG		VARCHAR(MAX),
	@IPADD		VARCHAR(20),
	@ADMIN_NAME VARCHAR(50)    

)
AS
/*
SELECT * FROM TBLPRADNYAUSERS
select * from TBLUSERCONTROLMASTER_JRNL
MXM~FUTURES,NMC~FUTURES,NSE~CAPITAL,
EXEC DELETE_CLASS_USER_ALL 'ASASD', 'BCM~FUTURES,BSE~CAPITAL,NSE~CAPITAL,NXM~FUTURES,', '10.11.12.74', 'Administrator'
SP_HELPTEXT ADMIN_DELUSER
INSERT INTO #USER_AUTO 
SELECT FLDAUTO FROM [MTSRVR06\DEV].MCDXCDSPCM.DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = 'DS' 
*/
DECLARE  
 @@SHAREDB VARCHAR(20),
 @@SHARESVR VARCHAR(20),  
 @@EXCHANGE VARCHAR(15),  
 @@SEGMENT VARCHAR(15),  
 @@SQL VARCHAR(MAX),
 @@DB VARCHAR(MAX),
 @@SEGORD TINYINT,
 @@FLDAUTO INT,
 @ADMINID INT,
 @GLOBALDATE DATETIME,  
 @@MAINREC AS CURSOR  

 CREATE TABLE [DBO].[#DBNAME]  
 (  
	SHAREDB VARCHAR(50),
	SHARESERVER VARCHAR(50),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10)
 ) ON [PRIMARY]  

 CREATE TABLE [DBO].#USER_AUTO
 (
	FLDAUTO INT	
 ) ON [PRIMARY]

 CREATE TABLE [DBO].#RESULT
 (
	UNAME VARCHAR(30),
	EXCHANGE VARCHAR(6),   
	SEGMENT VARCHAR(10),
	MSG VARCHAR(100)	
 )	
	SET @GLOBALDATE = GETDATE()  

	SET @@DB = " INSERT INTO #DBNAME "   
	SET @@DB = @@DB + " SELECT "
	SET @@DB = @@DB + "		SHAREDB, SHARESERVER, EXCHANGE, SEGMENT "
	SET @@DB = @@DB + " FROM "
	SET @@DB = @@DB + "		PRADNYA.DBO.MULTICOMPANY (NOLOCK) "
	SET @@DB = @@DB + " WHERE "
	SET @@DB = @@DB + " 	PRIMARYSERVER = 1 "
	SET @@DB = @@DB + "		AND EXCHANGE+'~'+SEGMENT IN ('" + REPLACE(@EXCSEG,',',''',''') + "')  "
	SET @@DB = @@DB + " ORDER BY "
	SET @@DB = @@DB + "		EXCHANGE "  
	PRINT @@DB
	EXEC(@@DB) 

	SET @@MAINREC = CURSOR FOR  
	SELECT SHAREDB, SHARESERVER, EXCHANGE, SEGMENT FROM #DBNAME  

	SET @@SEGORD = 1  
	
	OPEN @@MAINREC  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT  
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			IF @@SHARESVR <> @@SERVERNAME 
				BEGIN
				
					SET @@SQL = " INSERT INTO #USER_AUTO SELECT FLDAUTO FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+ @UNAME +"' "
					EXEC(@@SQL)

					SELECT @@FLDAUTO = FLDAUTO FROM #USER_AUTO	
					
					SET @@SQL = " INSERT INTO " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS_LOG(FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA)  "
					SET @@SQL = @@SQL + " SELECT "
					SET @@SQL = @@SQL + " 	FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, 'D', '"+@ADMIN_NAME+"', '"+CONVERT(VARCHAR(11),@GLOBALDATE)+"', '"+@IPADD+"', 'DELETEENTRY' "
			  		SET @@SQL = @@SQL + " FROM "
					SET @@SQL = @@SQL + " 	" + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS  "
					SET @@SQL = @@SQL + "  WHERE  "
					SET @@SQL = @@SQL + " 	FLDAUTO = "+CONVERT(VARCHAR,@@FLDAUTO)+" "
					
					SET @@SQL = @@SQL + " INSERT INTO " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER_JRNL(FLDAUTO, FLDUSERID, FLDPWDEXPIRY, FLDMAXATTEMPT, FLDATTEMPTCNT, FLDSTATUS, FLDLOGINFLAG, FLDACCESSLVL, FLDIPADD, FLDTIMEOUT, FLDFIRSTLOGIN, FLDFORCELOGOUT, FLDUPDTBY, FLDUPDTDT)  "
					SET @@SQL = @@SQL + " SELECT   "
					SET @@SQL = @@SQL + " 	  FLDAUTO, FLDUSERID, FLDPWDEXPIRY, FLDMAXATTEMPT, FLDATTEMPTCNT, FLDSTATUS, FLDLOGINFLAG, FLDACCESSLVL, FLDIPADD, FLDTIMEOUT, FLDFIRSTLOGIN, FLDFORCELOGOUT, '"+@IPADD+"', '"+CONVERT(VARCHAR(11),@GLOBALDATE)+"' "
					SET @@SQL = @@SQL + " FROM   "
					SET @@SQL = @@SQL + "   " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER TBC  "
					SET @@SQL = @@SQL + " WHERE   "
					SET @@SQL = @@SQL + "   FLDUSERID = "+CONVERT(VARCHAR,@@FLDAUTO)+" "
    
					SET @@SQL = @@SQL + " DELETE FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDAUTO = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
					SET @@SQL = @@SQL + " DELETE FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER WHERE FLDUSERID = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
					SET @@SQL = @@SQL + " DELETE FROM " + @@SHARESVR + "." + @@SHAREDB + ".DBO.TBLCLASSUSERLOGINS WHERE FLDAUTO = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
				END
			 ELSE
				BEGIN
					SET @@SQL = " INSERT INTO #USER_AUTO SELECT FLDAUTO FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDUSERNAME = '"+ @UNAME +"' "	
					EXEC(@@SQL)

					SELECT @@FLDAUTO = FLDAUTO FROM #USER_AUTO

					SET @@SQL = " INSERT INTO " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS_LOG(FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, EDIT_FLAG, CREATED_BY, CREATED_ON, MACHINEIP, FLDLOG_DATA)  "
					SET @@SQL = @@SQL + " SELECT "
					SET @@SQL = @@SQL + " 	FLDAUTO, FLDUSERNAME, FLDPASSWORD, FLDFIRSTNAME, FLDMIDDLENAME, FLDLASTNAME, FLDSEX, FLDADDRESS1, FLDADDRESS2, FLDPHONE1, FLDPHONE2, FLDCATEGORY, FLDADMINAUTO, FLDSTNAME, PWD_EXPIRY_DATE, 'D', '"+@ADMIN_NAME+"', '"+CONVERT(VARCHAR(11),@GLOBALDATE)+"', '"+@IPADD+"', 'DELETEENTRY' "
			  		SET @@SQL = @@SQL + " FROM   "
					SET @@SQL = @@SQL + " 	" + @@SHAREDB + ".DBO.TBLPRADNYAUSERS  "
					SET @@SQL = @@SQL + "  WHERE   "
					SET @@SQL = @@SQL + " 	FLDAUTO = "+CONVERT(VARCHAR,@@FLDAUTO)+" "

					SET @@SQL = @@SQL + " INSERT INTO " + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER_JRNL(FLDAUTO, FLDUSERID, FLDPWDEXPIRY, FLDMAXATTEMPT, FLDATTEMPTCNT, FLDSTATUS, FLDLOGINFLAG, FLDACCESSLVL, FLDIPADD, FLDTIMEOUT, FLDFIRSTLOGIN, FLDFORCELOGOUT, FLDUPDTBY, F
LDUPDTDT)  "
					SET @@SQL = @@SQL + " SELECT   "
					SET @@SQL = @@SQL + " 	  FLDAUTO, FLDUSERID, FLDPWDEXPIRY, FLDMAXATTEMPT, FLDATTEMPTCNT, FLDSTATUS, FLDLOGINFLAG, FLDACCESSLVL, FLDIPADD, FLDTIMEOUT, FLDFIRSTLOGIN, FLDFORCELOGOUT, '"+@IPADD+"', '"+CONVERT(VARCHAR(11),@GLOBALDATE)+"' "
					SET @@SQL = @@SQL + " FROM   "
					SET @@SQL = @@SQL + "   " + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER   "
					SET @@SQL = @@SQL + " WHERE   "
					SET @@SQL = @@SQL + "   FLDUSERID = "+CONVERT(VARCHAR,@@FLDAUTO)+" "

					SET @@SQL = @@SQL + " DELETE FROM " + @@SHAREDB + ".DBO.TBLPRADNYAUSERS WHERE FLDAUTO = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
					SET @@SQL = @@SQL + " DELETE FROM " + @@SHAREDB + ".DBO.TBLUSERCONTROLMASTER WHERE FLDUSERID = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
					SET @@SQL = @@SQL + " DELETE FROM " + @@SHAREDB + ".DBO.TBLCLASSUSERLOGINS WHERE FLDAUTO = "+ CONVERT(VARCHAR,@@FLDAUTO) +" "
				END
			--PRINT @@SQL	
			EXEC(@@SQL)
			IF @@ERROR = 0
			BEGIN
				INSERT INTO #RESULT VALUES (@UNAME,@@EXCHANGE,@@SEGMENT,'DELETED SUCCESSFULLY')
			END	

 SET @@SEGORD = @@SEGORD + 1  
	FETCH NEXT FROM @@MAINREC INTO @@SHAREDB, @@SHARESVR, @@EXCHANGE, @@SEGMENT
	END 

IF @@ERROR = 0
 BEGIN
	SELECT * FROM #RESULT
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_IDUSER_LIST
-- --------------------------------------------------
CREATE PROC [dbo].[GET_IDUSER_LIST]  
(  
 @IDUSER VARCHAR(30)  
)  
  
AS  
  
SET @IDUSER = UPPER(@IDUSER)  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
IF @IDUSER = 'BRANCH'  
 BEGIN  
  SELECT DISTINCT BRANCH_CODE, BRANCH = UPPER(BRANCH) FROM BRANCH (NOLOCK) ORDER BY BRANCH  
 END  
ELSE IF @IDUSER = 'SUBBROKER'  
 BEGIN   
  SELECT DISTINCT SUB_BROKER, NAME = UPPER(NAME) FROM SUBBROKERS (NOLOCK) WHERE SUB_BROKER <> '' AND NAME <> '' ORDER BY NAME   
 END  
ELSE IF @IDUSER = 'TRADER'  
 BEGIN  
 SELECT DISTINCT SHORT_NAME,LONG_NAME FROM BRANCHES (NOLOCK) WHERE SHORT_NAME <> '' AND LONG_NAME <> '' ORDER BY LONG_NAME   
 END  
ELSE IF @IDUSER = 'AREA'  
 BEGIN  
  SELECT DISTINCT AREACODE,DESCRIPTION FROM AREA (NOLOCK) ORDER BY DESCRIPTION  
 END   
ELSE IF @IDUSER = 'REGION'  
 BEGIN  
  SELECT DISTINCT REGIONCODE,DESCRIPTION FROM REGION (NOLOCK) ORDER BY DESCRIPTION  
 END  
ELSE IF @IDUSER = 'FAMILY'  
 BEGIN  
  SELECT DISTINCT FAMILY, FAMILY AS DESCRIPTION FROM MSAJAG.DBO.CLIENT_DETAILS (NOLOCK) WHERE FAMILY <> '' AND FAMILY <> CL_CODE ORDER BY DESCRIPTION  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_USER_EDIT
-- --------------------------------------------------
CREATE PROC [dbo].[GET_USER_EDIT]
(
	@UID	VARCHAR(25),
	@UNAME	VARCHAR(25),
	@CAT	VARCHAR(15),
	@ADMIN_ID INT 
)			
/*
	SELECT * FROM TBLPRADNYAUSERS WHERE FLDCATEGORY = 0
	EXEC GET_USER_EDIT '','', '','2' 
*/
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	(SELECT 
		UPPER(T.FLDUSERNAME) AS FLDUSERNAME, 
		UPPER(T.FLDFIRSTNAME) AS FLDFIRSTNAME, 
		UPPER(T.FLDLASTNAME) AS FLDLASTNAME, 
		T.FLDPHONE1, 
		T.FLDPHONE2, 
		T.FLDAUTO, 
		UPPER(C.FLDCATEGORYNAME) AS FLDCATEGORYNAME 
	FROM  
		TBLPRADNYAUSERS T,TBLCATEGORY C  
	WHERE 
		T.FLDCATEGORY = C.FLDCATEGORYCODE  
		AND  T.FLDADMINAUTO = @ADMIN_ID    
		AND T.FLDUSERNAME LIKE @UID + '%' 
		AND FLDUSERNAME LIKE @UNAME + '%' 
		AND FLDCATEGORY LIKE @CAT +'%' 
	)
	UNION ALL
	(
	SELECT 
		UPPER(FLDUSERNAME),
		UPPER(FLDFIRSTNAME),
		UPPER(FLDLASTNAME),
		FLDPHONE1,
		FLDPHONE2,
		FLDAUTO, 
		FLDCATEGORYNAME = '0'
	FROM 
		TBLPRADNYAUSERS T  
	WHERE 
		FLDADMINAUTO = @ADMIN_ID AND FLDCATEGORY = '0'  
		AND T.FLDUSERNAME LIKE  @UID + '%' 
		AND FLDUSERNAME LIKE @UNAME + '%' 
	)
	ORDER BY 7,1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_USER_FOREDIT
-- --------------------------------------------------

CREATE PROC [dbo].[GET_USER_FOREDIT]
(
	@FLDAUTO INT
)
AS
/*
GET_USER_FOREDIT 81848
select * from TBLUSERCONTROLMASTER where flduserid = 81848
*/
SELECT 
	T.FLDAUTO,
	FLDUSERNAME,
	FLDPASSWORD,
	FLDFIRSTNAME,
	FLDMIDDLENAME,
	FLDLASTNAME,
	FLDSEX,
	FLDADDRESS1,
	FLDADDRESS2,
	FLDPHONE1,	
	FLDPHONE2,	
	FLDCATEGORY,
	FLDADMINAUTO,
	FLDSTNAME,
	PWD_EXPIRY_DATE,
	TB.FLDPWDEXPIRY,
	TB.FLDMAXATTEMPT,
	TB.FLDATTEMPTCNT,
	TB.FLDSTATUS,
	TB.FLDLOGINFLAG,
	TB.FLDACCESSLVL,
	TB.FLDIPADD,
	TB.FLDFIRSTLOGIN,
	TB.FLDFORCELOGOUT,
	FLD_MAC_ID
FROM 
	TBLPRADNYAUSERS T, TBLUSERCONTROLMASTER TB
WHERE
	T.FLDAUTO = @FLDAUTO  
	AND T.FLDAUTO = FLDUSERID

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_CHECKLOGIN_USER
-- --------------------------------------------------
CREATE PROC [dbo].[IPO_CHECKLOGIN_USER] 
(
	@UM_ID BIGINT,
	@UM_SESSION VARCHAR(64),
	@IPADDRESS VARCHAR(20),
	@RETCODE INT OUTPUT,
	@RETMSG VARCHAR(200) OUTPUT
)
AS

DECLARE @@USERCOUNT INT

SELECT 
	@@USERCOUNT = COUNT(1) 
FROM
	USER_MASTER (NOLOCK)
WHERE
	UM_ID = @UM_ID
	AND UM_SESSION = REPLACE(REPLACE(@UM_SESSION,'{',''),'}','')

IF @@USERCOUNT = 0 
BEGIN
	SET @RETCODE = 0
	SET @RETMSG = 'SESSION IS NOT VALID. KINDLY LOG-OUT AND LOG-IN AGAIN'
	EXEC IPO_LOG_ERRORS @RETCODE, @RETMSG, 'CHECKLOGIN_USER', @IPADDRESS, @UM_ID
	RETURN
END

SET @RETCODE = 1
SET @RETMSG = 'SESSION VALIDATED SUCCESSFULLY'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_CLIENT_MASTER_ADD
-- --------------------------------------------------
-- Creates a new record in the [dbo].[CLIENT_MASTER] table.
CREATE PROCEDURE [dbo].[IPO_CLIENT_MASTER_ADD]
    @p_CM_UM_ID bigint,
    @p_CM_USER_TYPE varchar(3),
    @p_CM_USER_STATUS varchar(10),
    @p_CM_POA tinyint,
    @p_CM_APPNAME1 varchar(100),
    @p_CM_APPNAME2 varchar(100),
    @p_CM_APPNAME3 varchar(100),
    @p_CM_DOB1 varchar(11),
    @p_CM_DOB2 varchar(11),
    @p_CM_DOB3 varchar(11),
    @p_CM_GENDER1 varchar(1),
    @p_CM_GENDER2 varchar(1),
    @p_CM_GENDER3 varchar(1),
    @p_CM_FATHERHUSBAND varchar(100),
    @p_CM_PAN1 varchar(16),
    @p_CM_PAN2 varchar(16),
    @p_CM_PAN3 varchar(16),
    @p_CM_CIRCLE1 varchar(30),
    @p_CM_CIRCLE2 varchar(30),
    @p_CM_CIRCLE3 varchar(30),
    @p_CM_MAPINFLAG tinyint,
    @p_CM_MAPIN varchar(16),
    @p_CM_CATEGORY varchar(50),
    @p_CM_BM_ID bigint,
    @p_CM_SBM_ID bigint,
    @p_CM_NOMINEE varchar(100),
    @p_CM_NOMINEE_RELATION varchar(50),
    @p_CM_GUARDIANPAN varchar(16),
    @p_CDD_DEPOSITORY varchar(10),
    @p_CDD_DPID varchar(8),
    @p_CDD_DPNAME varchar(100),
    @p_CDD_CLIENTDPID varchar(16),
    @p_CDD_DEFAULT tinyint,
    @p_CBD_BANK_NAME varchar(64),
    @p_CBD_BRANCH varchar(64),
    @p_CBD_CITY varchar(64),
    @p_CBD_ACCTYPE varchar(1),
    @p_CBD_ACCNO varchar(20),
    @p_CBD_CUSTID varchar(32),
    @p_CBD_CHEQUENAME varchar(100),
    @p_CBD_DEFAULT tinyint,
    @p_CM_MODIFIEDBY bigint,
	@p_IP_ADD varchar(20),  
	@P_PARTY_CODE varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  

AS
BEGIN

DECLARE @CM_ID BIGINT  
    
SET @CM_ID = 0      
SET @ErrorCode      = 0  

	IF NOT EXISTS(SELECT CM_ID FROM CLIENT_MASTER WHERE CM_UM_ID = @p_CM_UM_ID)                
	 BEGIN    
		BEGIN TRANSACTION    
    
	  
		INSERT
		INTO [dbo].[CLIENT_MASTER]
			(
				[CM_UM_ID],
				[CM_USER_TYPE],
				[CM_USER_STATUS],
				[CM_POA],
				[CM_APPNAME1],
				[CM_APPNAME2],
				[CM_APPNAME3],
				[CM_DOB1],
				[CM_DOB2],
				[CM_DOB3],
				[CM_GENDER1],
				[CM_GENDER2],
				[CM_GENDER3],
				[CM_FATHERHUSBAND],
				[CM_PAN1],
				[CM_PAN2],
				[CM_PAN3],
				[CM_CIRCLE1],
				[CM_CIRCLE2],
				[CM_CIRCLE3],
				[CM_MAPINFLAG],
				[CM_MAPIN],
				[CM_CATEGORY],
				[CM_BM_ID],
				[CM_SBM_ID],
				[CM_NOMINEE],
				[CM_NOMINEE_RELATION],
				[CM_GUARDIANPAN],
				[CM_MODIFIEDBY],
				[CM_MODIFIEDDT],
				[CM_PARTY_CODE]
			)
		VALUES
			(
				 @p_CM_UM_ID,
				 @p_CM_USER_TYPE,
				 @p_CM_USER_STATUS,
				 @p_CM_POA,
				 @p_CM_APPNAME1,
				 @p_CM_APPNAME2,
				 @p_CM_APPNAME3,
				 CAST(@p_CM_DOB1 AS DATETIME),
				 CAST(@p_CM_DOB2 AS DATETIME),
				 CAST(@p_CM_DOB3 AS DATETIME),
				 @p_CM_GENDER1,
				 @p_CM_GENDER2,
				 @p_CM_GENDER3,
				 @p_CM_FATHERHUSBAND,
				 @p_CM_PAN1,
				 @p_CM_PAN2,
				 @p_CM_PAN3,
				 @p_CM_CIRCLE1,
				 @p_CM_CIRCLE2,
				 @p_CM_CIRCLE3,
				 @p_CM_MAPINFLAG,
				 @p_CM_MAPIN,
				 @p_CM_CATEGORY,
				 @p_CM_BM_ID,
				 @p_CM_SBM_ID,
				 @p_CM_NOMINEE,
				 @p_CM_NOMINEE_RELATION,
				 @p_CM_GUARDIANPAN,
				 @p_CM_MODIFIEDBY,
				 GETDATE(),
				 @P_PARTY_CODE
			)

  SET @CM_ID = SCOPE_IDENTITY()    
  
  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR INSERTING INTO CLIENT MASTER - ' + cast(@p_CM_UM_ID as varchar)    
   GOTO ERROR    
  END   
	 
    INSERT
    INTO [dbo].[CLIENT_BANK_DETAILS]
        (
            [CBD_CM_ID],
            [CBD_BANK_NAME],
            [CBD_BRANCH],
            [CBD_CITY],
            [CBD_ACCTYPE],
            [CBD_ACCNO],
            [CBD_CUSTID],
            [CBD_CHEQUENAME],
            [CBD_DEFAULT],
            [CBD_MODIFIEDBY],
            [CBD_MODIFIEDDT]
        )
    VALUES
        (
             @CM_ID,
             @p_CBD_BANK_NAME,
             @p_CBD_BRANCH,
             @p_CBD_CITY,
             @p_CBD_ACCTYPE,
             @p_CBD_ACCNO,
             @p_CBD_CUSTID,
             @p_CBD_CHEQUENAME,
             @p_CBD_DEFAULT,
            @p_CM_MODIFIEDBY,
             GETDATE()
        )

	  IF @@ERROR <> 0     
	  BEGIN     
	   SET  @ErrorCode = 1    
	   SET  @Message   = 'ERROR INSERTING INTO CLIENT BANK DETAILS - ' + cast(@p_CM_UM_ID as varchar)       
	   GOTO ERROR    
	  END   

    INSERT
    INTO [dbo].[CLIENT_DP_DETAILS]
        (
            [CDD_CM_ID],
            [CDD_DEPOSITORY],
            [CDD_DPID],
            [CDD_DPNAME],
            [CDD_CLIENTDPID],
            [CDD_DEFAULT],
            [CDD_MODIFIEDBY],
            [CDD_MODIFIEDDT]
        )
    VALUES
        (
             @CM_ID,
             @p_CDD_DEPOSITORY,
             @p_CDD_DPID,
             @p_CDD_DPNAME,
             @p_CDD_CLIENTDPID,
             @p_CDD_DEFAULT,
             @p_CM_MODIFIEDBY,
             GETDATE()
        )

	  IF @@ERROR <> 0     
	  BEGIN     
	   SET  @ErrorCode = 1    
	   SET  @Message   = 'ERROR INSERTING INTO CLIENT DP DETAILS - ' + cast(@p_CM_UM_ID as varchar)        
	   GOTO ERROR    
	  END   

    INSERT INTO [dbo].[CLIENT_CASH_BALANCE]
        (
            [CCB_CM_ID],
            [CCB_AVAILABLE_LIMIT],
            [CCB_USED_LIMIT]
        )
    VALUES
        (
             @CM_ID,
             100000000000,
             0
        )


	  IF @@ERROR <> 0     
	  BEGIN     
	   SET  @ErrorCode = 1    
	   SET  @Message   = 'ERROR INSERTING INTO CLIENT CASH DETAILS - ' + cast(@p_CM_UM_ID as varchar)       
	   GOTO ERROR    
	  END   

	 ERROR:    
		 IF @ErrorCode = 1    
		 BEGIN    
			  ROLLBACK TRANSACTION    
			  SET  @ErrorCode = -1000067                
			  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_CLIENT_MASTER_ADD',@p_IP_ADD,@p_CM_MODIFIEDBY  
		 END    
		 ELSE    
		 BEGIN    
			  COMMIT TRANSACTION    
			  SET @Message        = 'CLIENT MASTER ADDED SUCCESSFULLY.'  
		 END    
  
	END    
	ELSE      
	BEGIN  
		 SET @Message   = 'CLIENT DETAILS ALREAD EXISTS. PLEASE SELECT ANOTHER CLIENT'      
	END  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_CLIENT_MASTER_EDIT
-- --------------------------------------------------
-- Creates a new record in the [dbo].[CLIENT_MASTER] table.
CREATE PROCEDURE [dbo].[IPO_CLIENT_MASTER_EDIT]
    @p_CM_UM_ID bigint,
    @p_CM_USER_TYPE varchar(3),
    @p_CM_USER_STATUS varchar(10),
    @p_CM_POA tinyint,
    @p_CM_APPNAME1 varchar(100),
    @p_CM_APPNAME2 varchar(100),
    @p_CM_APPNAME3 varchar(100),
    @p_CM_DOB1 varchar(11),
    @p_CM_DOB2 varchar(11),
    @p_CM_DOB3 varchar(11),
    @p_CM_GENDER1 varchar(1),
    @p_CM_GENDER2 varchar(1),
    @p_CM_GENDER3 varchar(1),
    @p_CM_FATHERHUSBAND varchar(100),
    @p_CM_PAN1 varchar(16),
    @p_CM_PAN2 varchar(16),
    @p_CM_PAN3 varchar(16),
    @p_CM_CIRCLE1 varchar(30),
    @p_CM_CIRCLE2 varchar(30),
    @p_CM_CIRCLE3 varchar(30),
    @p_CM_MAPINFLAG tinyint,
    @p_CM_MAPIN varchar(16),
    @p_CM_CATEGORY varchar(50),
    @p_CM_BM_ID bigint,
    @p_CM_SBM_ID bigint,
    @p_CM_NOMINEE varchar(100),
    @p_CM_NOMINEE_RELATION varchar(50),
    @p_CM_GUARDIANPAN varchar(16),
    @p_CDD_DEPOSITORY varchar(10),
    @p_CDD_DPID varchar(16),
    @p_CDD_DPNAME varchar(100),
    @p_CDD_CLIENTDPID varchar(8),
    @p_CDD_DEFAULT tinyint,
    @p_CBD_BANK_NAME varchar(64),
    @p_CBD_BRANCH varchar(64),
    @p_CBD_CITY varchar(64),
    @p_CBD_ACCTYPE varchar(1),
    @p_CBD_ACCNO varchar(20),
    @p_CBD_CUSTID varchar(32),
    @p_CBD_CHEQUENAME varchar(100),
    @p_CBD_DEFAULT tinyint,
    @p_CM_MODIFIEDBY bigint,
	@p_IP_ADD varchar(20),  
	@P_PARTY_CODE varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  
AS
BEGIN

DECLARE @CM_ID BIGINT  
    
SET @CM_ID = 0      
SET @ErrorCode      = 0  

IF NOT EXISTS(SELECT CM_ID FROM CLIENT_MASTER WHERE CM_UM_ID = @p_CM_UM_ID)   
begin
print 'abc'
exec IPO_CLIENT_MASTER_add @p_CM_UM_ID ,
    @p_CM_USER_TYPE ,
    @p_CM_USER_STATUS ,
    @p_CM_POA ,
    @p_CM_APPNAME1 ,
    @p_CM_APPNAME2 ,
    @p_CM_APPNAME3 ,
    @p_CM_DOB1 ,
    @p_CM_DOB2,
    @p_CM_DOB3 ,
    @p_CM_GENDER1 ,
    @p_CM_GENDER2 ,
    @p_CM_GENDER3 ,
    @p_CM_FATHERHUSBAND,
    @p_CM_PAN1,
    @p_CM_PAN2 ,
    @p_CM_PAN3 ,
    @p_CM_CIRCLE1 ,
    @p_CM_CIRCLE2 ,
    @p_CM_CIRCLE3,
    @p_CM_MAPINFLAG ,
    @p_CM_MAPIN ,
    @p_CM_CATEGORY,
    @p_CM_BM_ID ,
    @p_CM_SBM_ID ,
    @p_CM_NOMINEE ,
    @p_CM_NOMINEE_RELATION ,
    @p_CM_GUARDIANPAN ,
    @p_CDD_DEPOSITORY ,
    @p_CDD_DPID ,
    @p_CDD_DPNAME ,
    @p_CDD_CLIENTDPID ,
    @p_CDD_DEFAULT ,
    @p_CBD_BANK_NAME ,
    @p_CBD_BRANCH ,
    @p_CBD_CITY ,
    @p_CBD_ACCTYPE ,
    @p_CBD_ACCNO ,
    @p_CBD_CUSTID ,
    @p_CBD_CHEQUENAME ,
    @p_CBD_DEFAULT ,
    @p_CM_MODIFIEDBY ,
	@p_IP_ADD , 
@P_PARTY_CODE, 
	@ErrorCode  out ,  
	@Message  out 


return
end
 
		BEGIN TRANSACTION    
    print '455'

		INSERT INTO CLIENT_MASTER_JRNL
		SELECT
			CM_ID,CM_UM_ID,CM_USER_TYPE,CM_USER_STATUS,CM_POA,CM_APPNAME1,CM_APPNAME2,CM_APPNAME3,
CM_DOB1,CM_DOB2,CM_DOB3,CM_GENDER1,CM_GENDER2,CM_GENDER3,CM_FATHERHUSBAND,CM_PAN1,CM_PAN2,
CM_PAN3,CM_CIRCLE1,CM_CIRCLE2,CM_CIRCLE3,CM_MAPINFLAG,CM_MAPIN,CM_CATEGORY,CM_BM_ID,CM_SBM_ID,
CM_NOMINEE,CM_NOMINEE_RELATION,CM_GUARDIANPAN,CM_MODIFIEDBY,CM_MODIFIEDDT,@p_CM_MODIFIEDBY, GETDATE(),CM_PARTY_CODE
		FROM 
			[dbo].[CLIENT_MASTER]
		WHERE 
			[CM_UM_ID] = @p_CM_UM_ID
		    print '45533'		  
 
		UPDATE [dbo].[CLIENT_MASTER]
		SET

				
				[CM_USER_TYPE] = @p_CM_USER_TYPE,
				[CM_USER_STATUS] =@p_CM_USER_STATUS,
				[CM_POA] = @p_CM_POA,
				[CM_APPNAME1] = @p_CM_APPNAME1,
				[CM_APPNAME2] = @p_CM_APPNAME2,
				[CM_APPNAME3] = @p_CM_APPNAME3,
				[CM_DOB1] = CAST(@p_CM_DOB1 AS DATETIME),
				[CM_DOB2] = CAST(@p_CM_DOB2 AS DATETIME),
				[CM_DOB3] = CAST(@p_CM_DOB3 AS DATETIME),
				[CM_GENDER1] = @p_CM_GENDER1,
				[CM_GENDER2] = @p_CM_GENDER2,
				[CM_GENDER3] = @p_CM_GENDER3,
				[CM_FATHERHUSBAND] = @p_CM_FATHERHUSBAND,
				[CM_PAN1] = @p_CM_PAN1,
				[CM_PAN2] = @p_CM_PAN2,
				[CM_PAN3] = @p_CM_PAN3,
				[CM_CIRCLE1] = @p_CM_CIRCLE1,
				[CM_CIRCLE2] = @p_CM_CIRCLE2,
				[CM_CIRCLE3] = @p_CM_CIRCLE3,
				[CM_MAPINFLAG] = @p_CM_MAPINFLAG,
				[CM_MAPIN] = @p_CM_MAPIN,
				[CM_CATEGORY] = @p_CM_CATEGORY,
				[CM_BM_ID] = @p_CM_BM_ID,
				[CM_SBM_ID] = @p_CM_SBM_ID,
				[CM_NOMINEE] = @p_CM_NOMINEE,
				[CM_NOMINEE_RELATION] = @p_CM_NOMINEE_RELATION,
				[CM_GUARDIANPAN] = @p_CM_GUARDIANPAN,
				[CM_MODIFIEDBY] = @p_CM_MODIFIEDBY,
				[CM_MODIFIEDDT] = GETDATE(),
				[CM_PARTY_CODE] =@P_PARTY_CODE
		WHERE [CM_UM_ID] = @p_CM_UM_ID
    
  SELECT @CM_ID = CM_ID FROM CLIENT_MASTER WHERE [CM_UM_ID] = @p_CM_UM_ID    
  
  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR UPDATING CLIENT MASTER - ' + cast(@p_CM_UM_ID as varchar)   
   GOTO ERROR    
  END   
	 
		INSERT INTO CLIENT_BANK_DETAILS_JRNL
		SELECT
			*, 	@p_CM_MODIFIEDBY, GETDATE()
		FROM 
			[dbo].[CLIENT_BANK_DETAILS]
		WHERE 
			[CBD_CM_ID] = @CM_ID

    UPDATE [dbo].[CLIENT_BANK_DETAILS]
    SET
            [CBD_BANK_NAME] = @p_CBD_BANK_NAME,
            [CBD_BRANCH] = @p_CBD_BRANCH,
            [CBD_CITY] = @p_CBD_CITY,
            [CBD_ACCTYPE] = @p_CBD_ACCTYPE,
            [CBD_ACCNO] = @p_CBD_ACCNO,
            [CBD_CUSTID] = @p_CBD_CUSTID,
            [CBD_CHEQUENAME] = @p_CBD_CHEQUENAME,
            [CBD_DEFAULT] = @p_CBD_DEFAULT,
            [CBD_MODIFIEDBY] = @p_CM_MODIFIEDBY,
            [CBD_MODIFIEDDT] = GETDATE()
	WHERE [CBD_CM_ID] = @CM_ID


	  IF @@ERROR <> 0     
	  BEGIN     
	   SET  @ErrorCode = 1    
	   SET  @Message   = 'ERROR UPDATING CLIENT BANK DETAILS - ' + cast(@p_CM_UM_ID as varchar)    
	   GOTO ERROR    
	  END   

		INSERT INTO CLIENT_DP_DETAILS_JRNL
		SELECT
			*, 	@p_CM_MODIFIEDBY, GETDATE()
		FROM 
			[dbo].[CLIENT_DP_DETAILS]
		WHERE 
			[CDD_CM_ID] = @CM_ID

    UPDATE [dbo].[CLIENT_DP_DETAILS]
    SET
            [CDD_DEPOSITORY] = @p_CDD_DEPOSITORY,
            [CDD_DPID] = @p_CDD_DPID,
            [CDD_DPNAME] = @p_CDD_DPNAME,
            [CDD_CLIENTDPID] = @p_CDD_CLIENTDPID,
            [CDD_DEFAULT] = @p_CDD_DEFAULT,
            [CDD_MODIFIEDBY] = @p_CM_MODIFIEDBY,
            [CDD_MODIFIEDDT] = GETDATE()
	WHERE [CDD_CM_ID] = @CM_ID 
 

	  IF @@ERROR <> 0     
	  BEGIN     
	   SET  @ErrorCode = 1    
	   SET  @Message   = 'ERROR UPDATING CLIENT DP DETAILS - ' + cast(@p_CM_UM_ID as varchar)   
	   GOTO ERROR    
	  END   


	 ERROR:    
		 IF @ErrorCode = 1    
		 BEGIN    
			  ROLLBACK TRANSACTION    
			  SET  @ErrorCode = -1000067                
			  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_CLIENT_MASTER_EDIT', @p_IP_ADD, @p_CM_MODIFIEDBY  
		 END    
		 ELSE    
		 BEGIN    
			  COMMIT TRANSACTION    
			  SET @Message        = 'CLIENT MASTER UPDATED SUCCESSFULLY.'  
		 END    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_FETCH_DETAILS
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[IPO_FETCH_DETAILS]                                                
(                                                
 @p_IPO_ID BIGINT,                                                
 @p_TERMINAL  VARCHAR(20),          
 @p_STATUS VARCHAR(20),                         
 @p_DATE_FROM VARCHAR(11),                                    
 @p_DATE_TO VARCHAR(11),                               
 @ErrorCode  INT OUTPUT,                                                        
 @Message  VARCHAR(200) OUTPUT                                                
)                                                
AS                                              
/*  
DECLARE @P7 INT  
DECLARE @P8 VARCHAR(200)  
  
SET @P7 = 0  
SET @P8 = ''  
exec IPO_FETCH_DETAILS 1, 'NEAT','ORDERED','02-FEB-2008','02-FEB-2008', @P7 OUTPUT, @P8 OUTPUT  
PRINT @p8  
  
*/  
BEGIN                                               
          

CREATE TABLE #EXPORT_DATA
(
	EXPID BIGINT
)

IF @p_IPO_ID > 0
BEGIN
	INSERT INTO #EXPORT_DATA
	SELECT 
		IT_ID
	FROM
		IPO_TRANSACTIONS (NOLOCK)
	 WHERE  
	  IT_FINAL_STATUS = @p_STATUS  
	  AND IT_IM_ID = @p_IPO_ID  
	  AND IT_MODIFIEDDT BETWEEN CAST(@p_DATE_FROM  AS DATETIME) AND CAST(@p_DATE_TO + ' 23:59:59' AS DATETIME)       
END
ELSE
BEGIN
	INSERT INTO #EXPORT_DATA
	SELECT 
		IT_ID
	FROM
		IPO_TRANSACTIONS (NOLOCK)
	 WHERE  
	  IT_FINAL_STATUS = @p_STATUS  
	  AND IT_ACCEPT_DATE BETWEEN CAST(@p_DATE_FROM  AS DATETIME) AND CAST(@p_DATE_TO + ' 23:59:59' AS DATETIME)       
END


 IF @p_STATUS = 'ORDERED'	
 BEGIN
	UPDATE 
		IPO_TRANSACTIONS
	SET
		IT_FINAL_STATUS = 'GENERATED'
	FROM
		#EXPORT_DATA
	WHERE
		IT_ID = EXPID		
 END                                                          
  
 --SELECT   
 -- BANKSRNO = '',  
 -- MARKETTYPE = '01',  
 -- SERIES = 'EQ',  
 -- ACTIONCODE = '01',   
 -- PAYMENTRECEIVED = 'Y',  
 -- PRIORITY = 1,  
 -- ALLOCATIONMETHOD = 1,  
 -- CLIENTSTATUS = 181,  
 -- IM_IPO_NAME,  
 -- IM_IPO_SYMBOL,  
 -- IT_USER_TYPE,  
 -- IT_APPNAME1,  
 -- IT_APPNAME2,  
 -- IT_APPNAME3,  
 -- CM_AGE1 = DATEDIFF(YY,CM_DOB1, GETDATE()),  
 -- IT_FATHERHUSBAND,  
 -- IT_PAN1,  
 -- IT_PAN2,  
 -- IT_PAN3,  
 -- IT_CIRCLE1,  
 -- IT_CIRCLE2,  
 -- IT_CIRCLE3,  
 -- IT_CATEGORY,  
 -- IT_DEPOSITORY,  
 -- IT_DPID,  
 -- IT_DPNAME,  
 -- IT_CLIENTDPID,  
 -- IT_BID_QTY1,  
 -- IT_BID_PRICE1,  
 -- IT_BID_QTY2,  
 -- IT_BID_PRICE2,  
 -- IT_BID_QTY3,  
 -- IT_BID_PRICE3,  
 -- IT_AMOUNT1 = CAST(IT_BID_QTY1 AS NUMERIC(24,4)) * IT_BID_PRICE1,  
 -- IT_AMOUNT2 = CAST(IT_BID_QTY2 AS NUMERIC(24,4)) * IT_BID_PRICE2,  
 -- IT_AMOUNT3 = CAST(IT_BID_QTY3 AS NUMERIC(24,4)) * IT_BID_PRICE3,  
 -- IT_APPNO,  
 -- IT_ADDRESS = REPLACE(UM_ADD1,',',';') + (CASE WHEN LEN(UM_ADD2) > 0 THEN REPLACE(UM_ADD2,',',';') END) +  (CASE WHEN LEN(UM_ADD3) > 0 THEN REPLACE(UM_ADD3,',',';') END),  
 -- UM_CITY,  
 -- UM_STATE,  
 -- UM_PINCODE,  
 -- UM_COUNTRY,  
 -- IM_SYNMEM_NAME,  
 -- IM_BROKER_NAME,  
 -- IM_REGISTRAR,  
 -- UM_CODE,  
 -- UM_OCCUPATION,
 -- IT_ACCEPT_QTY,
 -- IT_ACCEPT_PRICE,
 -- IT_ACCEPT_DATE  
 --FROM   
 -- IPO_TRANSACTIONS (NOLOCK)  
 -- INNER JOIN #EXPORT_DATA (NOLOCK)
	--ON (IT_ID = EXPID)
 -- INNER JOIN IPO_MASTER (NOLOCK)  
 --  ON (IT_IM_ID = IM_ID)  
 -- INNER JOIN CLIENT_MASTER (NOLOCK)  
 --  --INNER JOIN USER_MASTER (NOLOCK)  
 --  --ON (CM_UM_ID = UM_ID)  
 -- ON (IT_CM_ID = CM_ID)  
 --WHERE  
 --1 = 1
-- select * from #EXPORT_DATA
IF @P_TERMINAL='BOLT'
BEGIN
 SELECT CONVERT(CHAR(12),'850')
+CONVERT(CHAR(20),IT_APPNO)
+CONVERT(CHAR(5),IT_USER_TYPE)
+CONVERT(CHAR(50),IT_APPNAME1)
+CONVERT(CHAR(5),IT_DEPOSITORY)
+CONVERT(CHAR(16),IT_DPID)
+CONVERT(CHAR(16),IT_CLIENTDPID)
+CONVERT(CHAR(15),CONVERT(VARCHAR(15),DBO.FN_FORMATSTR(CONVERT(VARCHAR(15),IT_BID_QTY1),15,0,'L','0')))
+CONVERT(CHAR(1),IT_CUT_OFF1)
+CONVERT(CHAR(8),CONVERT(NUMERIC(6,2),IT_BID_PRICE1))
+CONVERT(CHAR(1),'N')
+CONVERT(CHAR(12),'000000000000')
+CONVERT(CHAR(9),'000000000')
+CONVERT(CHAR(10),IT_PAN1)
+CONVERT(CHAR(6),'NASBAB')
+CONVERT(CHAR(6),'NASBAB')
+CONVERT(CHAR(16),'')
+CONVERT(CHAR(16),'0')
+CONVERT(CHAR(1),'N')  IPO_TRANSACTIONS
FROM IPO_TRANSACTIONS           
INNER JOIN #EXPORT_DATA (NOLOCK)
ON (IT_ID = EXPID)
--INNER JOIN IPO_MASTER (NOLOCK)  
--ON (IT_IM_ID = IM_ID)  
--INNER JOIN CLIENT_MASTER (NOLOCK)  
----INNER JOIN USER_MASTER (NOLOCK)  
----ON (CM_UM_ID = UM_ID)  
--ON (IT_CM_ID = CM_ID)               
WHERE IT_FINAL_STATUS ='ORDERED' -- AND IT_IM_ID = 1  
END
 
IF @p_TERMINAL='NEAT' 
BEGIN
SELECT CONVERT(CHAR(1),'1')
,CONVERT(CHAR(20),IT_APPNO)
,CONVERT(CHAR(5),IT_USER_TYPE)
,CONVERT(CHAR(50),IT_APPNAME1)
,CONVERT(CHAR(5),IT_DEPOSITORY)
,CONVERT(CHAR(16),IT_DPID)
,CONVERT(CHAR(16),IT_CLIENTDPID)
,CONVERT(CHAR(15),CONVERT(VARCHAR(15),DBO.FN_FORMATSTR(CONVERT(VARCHAR(15),IT_BID_QTY1),15,0,'L','0')))
,CONVERT(CHAR(1),IT_CUT_OFF1)
,CONVERT(CHAR(8),CONVERT(NUMERIC(6,2),IT_BID_PRICE1))
,CONVERT(CHAR(1),'N')
,CONVERT(CHAR(12),'000000000000')
,CONVERT(CHAR(9),'000000000')
,CONVERT(CHAR(10),IT_PAN1)
,CONVERT(CHAR(6),'NASBAB')
,CONVERT(CHAR(6),'NASBAB')
,CONVERT(CHAR(16),'')
,CONVERT(CHAR(16),'0')
,CONVERT(CHAR(1),'N')  IPO_TRANSACTIONS
FROM IPO_TRANSACTIONS           
INNER JOIN #EXPORT_DATA (NOLOCK)
ON (IT_ID = EXPID)
--INNER JOIN IPO_MASTER (NOLOCK)  
--ON (IT_IM_ID = IM_ID)  
--INNER JOIN CLIENT_MASTER (NOLOCK)  
----INNER JOIN USER_MASTER (NOLOCK)  
----ON (CM_UM_ID = UM_ID)  
--ON (IT_CM_ID = CM_ID)               
WHERE IT_FINAL_STATUS ='ORDERED'
END
              
 IF @@ERROR <> 0  
 BEGIN  
  SET @ErrorCode=-8000000                                                  
  SET @Message='NO DATA AVAILABLE'     
  RETURN  
 END           
 ELSE  
 BEGIN  
  TRUNCATE TABLE #EXPORT_DATA
  DROP TABLE #EXPORT_DATA
  SET @ErrorCode=0                                         
  SET @Message='DATA FETCHED SUCCESSFULLY'     
  RETURN  
 END                       
                                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_GETIPOLIST
-- --------------------------------------------------
CREATE PROC [dbo].[IPO_GETIPOLIST]
AS

SELECT 
	IM_ID,
	IM_IPO_NAME,
	IM_OPEN_DATE = CONVERT(VARCHAR,IM_OPEN_DATE,105),
	IM_CLOSE_DATE = CONVERT(VARCHAR,IM_CLOSE_DATE,105),
	IM_ISSUE_TYPE,
	IM_ISSUE_SERIES,
	IM_FLOOR_PRICE,
	IM_CAP_PRICE,
	IM_MIN_BID_QTY,
	IM_BID_QTY_MULTIPLE,
	IM_PARTIAL_AMT
FROM
	IPO_MASTER (NOLOCK)
WHERE
	LEFT(GETDATE(),11) BETWEEN IM_OPEN_DATE AND IM_CLOSE_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_MASTER_ADD
-- --------------------------------------------------


-- Creates a new record in the [dbo].[IPO_MASTER] table.
CREATE PROCEDURE [dbo].[IPO_IPO_MASTER_ADD]
    @p_IM_IPO_NAME varchar(100),
    @p_IM_IPO_SYMBOL varchar(20),
    @p_IM_OPEN_DATE varchar(11),
    @p_IM_CLOSE_DATE varchar(11),
    @p_IM_ISSUE_SERIES varchar(20),
    @p_IM_ISSUE_TYPE varchar(24),
    @p_IM_FLOOR_PRICE varchar(24),
    @p_IM_CAP_PRICE varchar(24),
    @p_IM_FIXED_PRICE varchar(24),
    @p_IM_PRICE_MULTIPLE varchar(24),
    @p_IM_CUTOFF_PRICE varchar(24),
    @p_IM_TRADING_LOT int,
    @p_IM_MIN_BID_QTY int,
    @p_IM_BID_QTY_MULTIPLE int,
    @p_IM_FACE_VALUE varchar(24),
    @p_IM_PARTIAL_AMT varchar(24),
    @p_IM_PARTIAL_FLAG tinyint,
    @p_IM_SYNMEM_NAME varchar(100),
    @p_IM_SYNMEM_CODE varchar(16),
    @p_IM_BROKER_NAME varchar(100),
    @p_IM_BROKER_CODE varchar(16),
    @p_IM_SUBBROKER varchar(16),
    @p_IM_BANK_NAME varchar(64),
    @p_IM_BANK_BRANCH varchar(64),
    @p_IM_BANK_SRNO varchar(16),
    @p_IM_REGISTRAR varchar(64),
    @p_IM_APPNO_START int,
    @p_IM_APPNO_END int,
    @p_IM_APPNO_PREFIX varchar(10),
    @p_IM_APPNO_SUFFIX varchar(10),
    @p_IM_APPNO_LENGTH smallint,
    @p_IM_CHQ_PAYABLETO varchar(100),
    @p_IM_OTHER_DETAILS varchar(100),
    @p_IM_NRI_FLAG tinyint,
    @p_IM_GL_CODE varchar(20),
    @p_IM_GL_NAME varchar(100),
    @p_IM_MODIFIEDBY varchar(100),
	@p_IP_ADD varchar(20),  
	 
	@p_IM_ISIN varchar(20),
    @p_IM_NseScriptCode varchar(100),
    @p_IM_BseScriptCode varchar(100),
    @p_IM_chkEmp char(1),
	@p_IM_chkShareHolder char(1),
	@P_IM_chkpublic char(1),
    @P_IM_LIMIT_SETTING varchar(500),
	@P_IM_MINIMUM_INT_DAYS int,
	@ErrorCode int output, 
	@Message varchar(200) output  
	
AS
BEGIN
    
SET @ErrorCode      = 0    
  
IF NOT EXISTS(SELECT IM_IPO_NAME FROM IPO_MASTER WHERE IM_IPO_NAME = @p_IM_IPO_NAME)                
 BEGIN   
 
       BEGIN TRANSACTION    
    
    INSERT
    INTO [dbo].[IPO_MASTER]
        (
            [IM_IPO_NAME],
            [IM_IPO_SYMBOL],
            [IM_OPEN_DATE],
            [IM_CLOSE_DATE],
            [IM_ISSUE_SERIES],
            [IM_ISSUE_TYPE],
            [IM_FLOOR_PRICE],
            [IM_CAP_PRICE],
            [IM_FIXED_PRICE],
            [IM_PRICE_MULTIPLE],
            [IM_CUTOFF_PRICE],
            [IM_TRADING_LOT],
            [IM_MIN_BID_QTY],
            [IM_BID_QTY_MULTIPLE],
            [IM_FACE_VALUE],
            [IM_PARTIAL_AMT],
            [IM_PARTIAL_FLAG],
            [IM_SYNMEM_NAME],
            [IM_SYNMEM_CODE],
            [IM_BROKER_NAME],
            [IM_BROKER_CODE],
            [IM_SUBBROKER],
            [IM_BANK_NAME],
            [IM_BANK_BRANCH],
            [IM_BANK_SRNO],
            [IM_REGISTRAR],
            [IM_APPNO_START],
            [IM_APPNO_END],
            [IM_APPNO_PREFIX],
            [IM_APPNO_SUFFIX],
            [IM_APPNO_LENGTH],
            [IM_CHQ_PAYABLETO],
            [IM_OTHER_DETAILS],
            [IM_NRI_FLAG],
            [IM_GL_CODE],
            [IM_GL_NAME],
            [IM_MODIFIEDBY],
            [IM_MODIFIEDDT],
			IM_ISIN_CD,
			IM_NSE_SCRIPCD,
			IM_BSE_SCRIPCD,
			IM_EMP,
			IM_SH,
			IM_PUBLIC,
			IM_IPO_MIN_INT_DAYS
        )
    VALUES
        (
             @p_IM_IPO_NAME,
             @p_IM_IPO_SYMBOL,
             CAST(@p_IM_OPEN_DATE AS DATETIME),
             CAST(@p_IM_CLOSE_DATE AS DATETIME),
             @p_IM_ISSUE_SERIES,
             @p_IM_ISSUE_TYPE,
             CAST(@p_IM_FLOOR_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_CAP_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_FIXED_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_PRICE_MULTIPLE AS NUMERIC(24,4)),
             CAST(@p_IM_CUTOFF_PRICE AS NUMERIC(24,4)),
             @p_IM_TRADING_LOT,
             @p_IM_MIN_BID_QTY,
             @p_IM_BID_QTY_MULTIPLE,
             CAST(@p_IM_FACE_VALUE AS NUMERIC(24,4)),
             CAST(@p_IM_PARTIAL_AMT AS NUMERIC(24,4)),
             @p_IM_PARTIAL_FLAG,
             @p_IM_SYNMEM_NAME,
             @p_IM_SYNMEM_CODE,
             @p_IM_BROKER_NAME,
             @p_IM_BROKER_CODE,
             @p_IM_SUBBROKER,
             @p_IM_BANK_NAME,
             @p_IM_BANK_BRANCH,
             @p_IM_BANK_SRNO,
             @p_IM_REGISTRAR,
             @p_IM_APPNO_START,
             @p_IM_APPNO_END,
             @p_IM_APPNO_PREFIX,
             @p_IM_APPNO_SUFFIX,
             @p_IM_APPNO_LENGTH,
             @p_IM_CHQ_PAYABLETO,
             @p_IM_OTHER_DETAILS,
             @p_IM_NRI_FLAG,
             @p_IM_GL_CODE,
             @p_IM_GL_NAME,
             @p_IM_MODIFIEDBY,
             GETDATE(),
			 @p_IM_ISIN, 
			 @p_IM_NseScriptCode,
			 @p_IM_BseScriptCode,
			 @p_IM_chkEmp,
			 @p_IM_chkShareHolder,
			 @P_IM_chkpublic,
			 @P_IM_MINIMUM_INT_DAYS
        )
declare @P_LM_ID numeric
, @P_IM_ID INTEGER  
SELECT @P_LM_ID = IM_ID FROM IPO_MASTER WHERE IM_IPO_NAME = @P_IM_IPO_NAME


IF NOT EXISTS (SELECT FINA_ACC_CODE FROM FIN_ACCOUNT_MSTR WHERE FINA_ACC_CODE=@P_IM_GL_CODE)
BEGIN
SELECT @P_IM_ID=IM_ID FROM IPO_MASTER WHERE [IM_IPO_NAME] = @P_IM_IPO_NAME

INSERT INTO FIN_ACCOUNT_MSTR
SELECT case when isnull(MAX(FINA_ACC_ID)+1,'0')='0' then isnull(MAX(FINA_ACC_ID)+1,'0')+1 else
 MAX(FINA_ACC_ID)+1 end,@P_IM_GL_CODE,@P_IM_GL_NAME,'G',0,0,0,'HO',GETDATE(),'HO',GETDATE(),'1' FROM FIN_ACCOUNT_MSTR
END 

declare @l_counter numeric
declare @l_count numeric
declare @l_string varchar(1000)
set @l_counter  = 1
set @l_count    = 1
select @l_count    = dbo.[ufn_CountString](@P_IM_LIMIT_SETTING,'*|~*')

while @l_count    > = @l_counter  
begin 

select @l_string = dbo.[FN_SPLITVAL_BY](@P_IM_LIMIT_SETTING,@l_counter  ,'*|~*' )

INSERT
    INTO [dbo].[IPO_MASTER_LS]
        (
         IMLS_IM_ID
		,IMLS_CTGRY
		,IMLS_MIN_AMT
		,IMLS_MAX_AMT
		,IMLS_DELETED_IND
        )
VALUES (
         @P_LM_ID
		, dbo.[FN_SPLITVAL_BY](@l_string,1,'|*~|')
		, dbo.[FN_SPLITVAL_BY](@l_string,2,'|*~|')
		, dbo.[FN_SPLITVAL_BY](@l_string,3,'|*~|')
		,'1'
       )
       set @l_counter   = @l_counter   + 1 
       
end 


  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR INSERTING INTO IPO MASTER - '  + @p_IM_IPO_SYMBOL   
   GOTO ERROR    
  END    

 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000067                
  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_IPO_MASTER_ADD',@p_IP_ADD,@p_IM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message        = 'IPO REGISTERED SUCCESSFULLY.'  
 END    
  
END    
ELSE      
BEGIN  
 SET @Message   = 'IPO NAME ALREAD EXISTS. PLEASE SELECT ANOTHER IPO NAME'      
END  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_MASTER_ADD_17072014
-- --------------------------------------------------


-- Creates a new record in the [dbo].[IPO_MASTER] table.
create PROCEDURE [dbo].[IPO_IPO_MASTER_ADD_17072014]
    @p_IM_IPO_NAME varchar(100),
    @p_IM_IPO_SYMBOL varchar(20),
    @p_IM_OPEN_DATE varchar(11),
    @p_IM_CLOSE_DATE varchar(11),
    @p_IM_ISSUE_SERIES varchar(20),
    @p_IM_ISSUE_TYPE varchar(24),
    @p_IM_FLOOR_PRICE varchar(24),
    @p_IM_CAP_PRICE varchar(24),
    @p_IM_FIXED_PRICE varchar(24),
    @p_IM_PRICE_MULTIPLE varchar(24),
    @p_IM_CUTOFF_PRICE varchar(24),
    @p_IM_TRADING_LOT int,
    @p_IM_MIN_BID_QTY int,
    @p_IM_BID_QTY_MULTIPLE int,
    @p_IM_FACE_VALUE varchar(24),
    @p_IM_PARTIAL_AMT varchar(24),
    @p_IM_PARTIAL_FLAG tinyint,
    @p_IM_SYNMEM_NAME varchar(100),
    @p_IM_SYNMEM_CODE varchar(16),
    @p_IM_BROKER_NAME varchar(100),
    @p_IM_BROKER_CODE varchar(16),
    @p_IM_SUBBROKER varchar(16),
    @p_IM_BANK_NAME varchar(64),
    @p_IM_BANK_BRANCH varchar(64),
    @p_IM_BANK_SRNO varchar(16),
    @p_IM_REGISTRAR varchar(64),
    @p_IM_APPNO_START int,
    @p_IM_APPNO_END int,
    @p_IM_APPNO_PREFIX varchar(10),
    @p_IM_APPNO_SUFFIX varchar(10),
    @p_IM_APPNO_LENGTH smallint,
    @p_IM_CHQ_PAYABLETO varchar(100),
    @p_IM_OTHER_DETAILS varchar(100),
    @p_IM_NRI_FLAG tinyint,
    @p_IM_GL_CODE varchar(20),
    @p_IM_GL_NAME varchar(100),
    @p_IM_MODIFIEDBY bigint,
	@p_IP_ADD varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  
AS
BEGIN
     
SET @ErrorCode      = 0    
  
IF NOT EXISTS(SELECT IM_IPO_NAME FROM IPO_MASTER WHERE IM_IPO_NAME = @p_IM_IPO_NAME)                
 BEGIN    
       BEGIN TRANSACTION    
    
    INSERT
    INTO [dbo].[IPO_MASTER]
        (
            [IM_IPO_NAME],
            [IM_IPO_SYMBOL],
            [IM_OPEN_DATE],
            [IM_CLOSE_DATE],
            [IM_ISSUE_SERIES],
            [IM_ISSUE_TYPE],
            [IM_FLOOR_PRICE],
            [IM_CAP_PRICE],
            [IM_FIXED_PRICE],
            [IM_PRICE_MULTIPLE],
            [IM_CUTOFF_PRICE],
            [IM_TRADING_LOT],
            [IM_MIN_BID_QTY],
            [IM_BID_QTY_MULTIPLE],
            [IM_FACE_VALUE],
            [IM_PARTIAL_AMT],
            [IM_PARTIAL_FLAG],
            [IM_SYNMEM_NAME],
            [IM_SYNMEM_CODE],
            [IM_BROKER_NAME],
            [IM_BROKER_CODE],
            [IM_SUBBROKER],
            [IM_BANK_NAME],
            [IM_BANK_BRANCH],
            [IM_BANK_SRNO],
            [IM_REGISTRAR],
            [IM_APPNO_START],
            [IM_APPNO_END],
            [IM_APPNO_PREFIX],
            [IM_APPNO_SUFFIX],
            [IM_APPNO_LENGTH],
            [IM_CHQ_PAYABLETO],
            [IM_OTHER_DETAILS],
            [IM_NRI_FLAG],
            [IM_GL_CODE],
            [IM_GL_NAME],
            [IM_MODIFIEDBY],
            [IM_MODIFIEDDT]
        )
    VALUES
        (
             @p_IM_IPO_NAME,
             @p_IM_IPO_SYMBOL,
             CAST(@p_IM_OPEN_DATE AS DATETIME),
             CAST(@p_IM_CLOSE_DATE AS DATETIME),
             @p_IM_ISSUE_SERIES,
             @p_IM_ISSUE_TYPE,
             CAST(@p_IM_FLOOR_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_CAP_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_FIXED_PRICE AS NUMERIC(24,4)),
             CAST(@p_IM_PRICE_MULTIPLE AS NUMERIC(24,4)),
             CAST(@p_IM_CUTOFF_PRICE AS NUMERIC(24,4)),
             @p_IM_TRADING_LOT,
             @p_IM_MIN_BID_QTY,
             @p_IM_BID_QTY_MULTIPLE,
             CAST(@p_IM_FACE_VALUE AS NUMERIC(24,4)),
             CAST(@p_IM_PARTIAL_AMT AS NUMERIC(24,4)),
             @p_IM_PARTIAL_FLAG,
             @p_IM_SYNMEM_NAME,
             @p_IM_SYNMEM_CODE,
             @p_IM_BROKER_NAME,
             @p_IM_BROKER_CODE,
             @p_IM_SUBBROKER,
             @p_IM_BANK_NAME,
             @p_IM_BANK_BRANCH,
             @p_IM_BANK_SRNO,
             @p_IM_REGISTRAR,
             @p_IM_APPNO_START,
             @p_IM_APPNO_END,
             @p_IM_APPNO_PREFIX,
             @p_IM_APPNO_SUFFIX,
             @p_IM_APPNO_LENGTH,
             @p_IM_CHQ_PAYABLETO,
             @p_IM_OTHER_DETAILS,
             @p_IM_NRI_FLAG,
             @p_IM_GL_CODE,
             @p_IM_GL_NAME,
             @p_IM_MODIFIEDBY,
             GETDATE()
        )


  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR INSERTING INTO IPO MASTER - '  + @p_IM_IPO_SYMBOL   
   GOTO ERROR    
  END    

 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000067                
  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_IPO_MASTER_ADD',@p_IP_ADD,@p_IM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message        = 'IPO REGISTERED SUCCESSFULLY.'  
 END    
  
END    
ELSE      
BEGIN  
 SET @Message   = 'IPO NAME ALREAD EXISTS. PLEASE SELECT ANOTHER IPO NAME'      
END  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_MASTER_EDIT
-- --------------------------------------------------

-- sp_HELP IPO_MASTER
-- Creates a new record in the [dbo].[IPO_MASTER] table.
CREATE PROCEDURE [dbo].[IPO_IPO_MASTER_EDIT]
    @p_IM_IPO_NAME varchar(100),
    @p_IM_IPO_SYMBOL varchar(20),
    @p_IM_OPEN_DATE varchar(11),
    @p_IM_CLOSE_DATE varchar(11),
    @p_IM_ISSUE_SERIES varchar(20),
    @p_IM_ISSUE_TYPE varchar(24),
    @p_IM_FLOOR_PRICE NUMERIC(24,4),
    @p_IM_CAP_PRICE NUMERIC(24,4),
    @p_IM_FIXED_PRICE NUMERIC(24,4),
    @p_IM_PRICE_MULTIPLE NUMERIC(24,4),
    @p_IM_CUTOFF_PRICE NUMERIC(24,4),
    @p_IM_TRADING_LOT int,
    @p_IM_MIN_BID_QTY int,
    @p_IM_BID_QTY_MULTIPLE int,
    @p_IM_FACE_VALUE NUMERIC(24,4),
    @p_IM_PARTIAL_AMT NUMERIC(24,4),
    @p_IM_PARTIAL_FLAG tinyint,
    @p_IM_SYNMEM_NAME varchar(100),
    @p_IM_SYNMEM_CODE varchar(16),
    @p_IM_BROKER_NAME varchar(100),
    @p_IM_BROKER_CODE varchar(16),
    @p_IM_SUBBROKER varchar(16),
    @p_IM_BANK_NAME varchar(64),
    @p_IM_BANK_BRANCH varchar(64),
    @p_IM_BANK_SRNO varchar(16),
    @p_IM_REGISTRAR varchar(64),
    @p_IM_APPNO_START int,
    @p_IM_APPNO_END int,
    @p_IM_APPNO_PREFIX varchar(10),
    @p_IM_APPNO_SUFFIX varchar(10),
    @p_IM_APPNO_LENGTH smallint,
    @p_IM_CHQ_PAYABLETO varchar(100),
    @p_IM_OTHER_DETAILS varchar(100),
    @p_IM_NRI_FLAG tinyint,
    @p_IM_GL_CODE varchar(20),
    @p_IM_GL_NAME varchar(100),
    @p_IM_MODIFIEDBY varchar(100),
	@p_IP_ADD varchar(20),
	
	@p_IM_ISIN varchar(20),
    @p_IM_NseScriptCode varchar(100),
    @p_IM_BseScriptCode varchar(100),
    @p_IM_chkEmp char(1),
	@p_IM_chkShareHolder char(1),
	@P_IM_chkpublic char(1),
    @P_IM_LIMIT_SETTING varchar(500),
	@P_IM_MINIMUM_INT_DAYS int,
	 
	@ErrorCode int output,  
	@Message varchar(200) output  
AS
BEGIN

   
SET @ErrorCode = 0    
DECLARE @P_IM_ID INTEGER  
 BEGIN TRANSACTION
    

--		INSERT INTO IPO_MASTER_JRNL
--		SELECT
--			*, 	@p_IM_MODIFIEDBY, GETDATE()
--		FROM 
--			[dbo].[IPO_MASTER]
--		WHERE 
--			[IM_IPO_NAME] = @p_IM_IPO_NAME

    UPDATE [dbo].[IPO_MASTER]
    SET       
            [IM_IPO_SYMBOL] = @p_IM_IPO_SYMBOL,
            [IM_OPEN_DATE] = CAST(@p_IM_OPEN_DATE AS DATETIME),
            [IM_CLOSE_DATE] = CAST(@p_IM_CLOSE_DATE AS DATETIME),
            [IM_ISSUE_SERIES] = @p_IM_ISSUE_SERIES,
            [IM_ISSUE_TYPE] = @p_IM_ISSUE_TYPE,
            [IM_FLOOR_PRICE] = @p_IM_FLOOR_PRICE,
            [IM_CAP_PRICE] = @p_IM_CAP_PRICE,
            [IM_FIXED_PRICE] = @p_IM_FIXED_PRICE,
            [IM_PRICE_MULTIPLE] = @p_IM_PRICE_MULTIPLE,
            [IM_CUTOFF_PRICE] = @p_IM_CUTOFF_PRICE,
            [IM_TRADING_LOT] = @p_IM_TRADING_LOT,
            [IM_MIN_BID_QTY] = @p_IM_MIN_BID_QTY,
            [IM_BID_QTY_MULTIPLE] = @p_IM_BID_QTY_MULTIPLE,
            [IM_FACE_VALUE] = @p_IM_FACE_VALUE,
            [IM_PARTIAL_AMT] = @p_IM_PARTIAL_AMT,
            [IM_PARTIAL_FLAG] = @p_IM_PARTIAL_FLAG,
            [IM_SYNMEM_NAME] = @p_IM_SYNMEM_NAME,
            [IM_SYNMEM_CODE] = @p_IM_SYNMEM_CODE,
            [IM_BROKER_NAME] = @p_IM_BROKER_NAME,
            [IM_BROKER_CODE] = @p_IM_BROKER_CODE,
            [IM_SUBBROKER] = @p_IM_SUBBROKER,
            [IM_BANK_NAME] = @p_IM_BANK_NAME,
            [IM_BANK_BRANCH] = @p_IM_BANK_BRANCH,
            [IM_BANK_SRNO] = @p_IM_BANK_SRNO,
            [IM_REGISTRAR] = @p_IM_REGISTRAR,
            [IM_APPNO_START] = @p_IM_APPNO_START,
            [IM_APPNO_END] = @p_IM_APPNO_END,
            [IM_APPNO_PREFIX] = @p_IM_APPNO_PREFIX,
            [IM_APPNO_SUFFIX] = @p_IM_APPNO_SUFFIX,
            [IM_APPNO_LENGTH] = @p_IM_APPNO_LENGTH,
            [IM_CHQ_PAYABLETO] = @p_IM_CHQ_PAYABLETO,
            [IM_OTHER_DETAILS] = @p_IM_OTHER_DETAILS,
            [IM_NRI_FLAG] = @p_IM_NRI_FLAG,
            [IM_GL_CODE] = @p_IM_GL_CODE,
            [IM_GL_NAME] = @p_IM_GL_NAME,
			
			IM_ISIN_CD = @p_IM_ISIN,
			IM_NSE_SCRIPCD = @p_IM_NseScriptCode,
			IM_BSE_SCRIPCD = @p_IM_BseScriptCode,
			IM_EMP = @p_IM_chkEmp,
			IM_SH = @p_IM_chkShareHolder,
			IM_PUBLIC =@P_IM_chkpublic,
			IM_IPO_MIN_INT_DAYS = @P_IM_MINIMUM_INT_DAYS,
			
            [IM_MODIFIEDBY] = @p_IM_MODIFIEDBY,
            [IM_MODIFIEDDT] = GETDATE()
	WHERE
		[IM_IPO_NAME] = @p_IM_IPO_NAME

IF NOT EXISTS (SELECT FINA_ACC_CODE FROM FIN_ACCOUNT_MSTR WHERE FINA_ACC_CODE=@P_IM_GL_CODE)
BEGIN
SELECT @P_IM_ID=IM_ID FROM IPO_MASTER WHERE [IM_IPO_NAME] = @P_IM_IPO_NAME

INSERT INTO FIN_ACCOUNT_MSTR
SELECT MAX(FINA_ACC_ID)+1,@P_IM_GL_CODE,@P_IM_GL_NAME,'G',0,0,@P_IM_ID,'HO',GETDATE(),'HO',GETDATE(),'1' FROM FIN_ACCOUNT_MSTR
END 
IF EXISTS (SELECT FINA_ACC_CODE FROM FIN_ACCOUNT_MSTR WHERE FINA_ACC_CODE=@P_IM_GL_CODE)
BEGIN
SELECT @P_IM_ID=IM_ID FROM IPO_MASTER WHERE [IM_IPO_NAME] = @P_IM_IPO_NAME
UPDATE FIN_ACCOUNT_MSTR SET FINA_ACC_CODE=@P_IM_GL_CODE,FINA_ACC_NAME=@P_IM_GL_NAME,FINA_DPM_ID=@P_IM_ID WHERE FINA_ACC_CODE=@P_IM_GL_CODE
END 

declare @P_LM_ID numeric

SELECT @P_LM_ID = IM_ID FROM IPO_MASTER WHERE IM_IPO_NAME = @p_IM_IPO_NAME

declare @l_counter numeric
declare @l_count numeric
declare @l_string varchar(1000)
set @l_counter  = 1
set @l_count    = 1
select @l_count    = dbo.[ufn_CountString](@P_IM_LIMIT_SETTING,'*|~*')

while @l_count    > = @l_counter  
begin 

select @l_string = dbo.[FN_SPLITVAL_BY](@P_IM_LIMIT_SETTING,@l_counter  ,'*|~*' )

update [dbo].[IPO_MASTER_LS]
       	set IMLS_MIN_AMT= dbo.[FN_SPLITVAL_BY](@l_string,2,'|*~|')
		,IMLS_MAX_AMT=dbo.[FN_SPLITVAL_BY](@l_string,3,'|*~|')
	where IMLS_IM_ID = @P_LM_ID
		and IMLS_CTGRY = dbo.[FN_SPLITVAL_BY](@l_string,1,'|*~|')
		
		
       set @l_counter   = @l_counter   + 1 
       
end 


  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR UPDATING INTO IPO MASTER - '  + @p_IM_IPO_SYMBOL   
   GOTO ERROR    
  END    

 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000077                
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_MASTER_EDIT', @p_IP_ADD, @p_IM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message = 'IPO MASTER UPDATED SUCCESSFULLY.'  
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_MASTER_EDIT_18072014
-- --------------------------------------------------

-- sp_HELP IPO_MASTER
-- Creates a new record in the [dbo].[IPO_MASTER] table.
create PROCEDURE [dbo].[IPO_IPO_MASTER_EDIT_18072014]
    @p_IM_IPO_NAME varchar(100),
    @p_IM_IPO_SYMBOL varchar(20),
    @p_IM_OPEN_DATE varchar(11),
    @p_IM_CLOSE_DATE varchar(11),
    @p_IM_ISSUE_SERIES varchar(20),
    @p_IM_ISSUE_TYPE varchar(24),
    @p_IM_FLOOR_PRICE NUMERIC(24,4),
    @p_IM_CAP_PRICE NUMERIC(24,4),
    @p_IM_FIXED_PRICE NUMERIC(24,4),
    @p_IM_PRICE_MULTIPLE NUMERIC(24,4),
    @p_IM_CUTOFF_PRICE NUMERIC(24,4),
    @p_IM_TRADING_LOT int,
    @p_IM_MIN_BID_QTY int,
    @p_IM_BID_QTY_MULTIPLE int,
    @p_IM_FACE_VALUE NUMERIC(24,4),
    @p_IM_PARTIAL_AMT NUMERIC(24,4),
    @p_IM_PARTIAL_FLAG tinyint,
    @p_IM_SYNMEM_NAME varchar(100),
    @p_IM_SYNMEM_CODE varchar(16),
    @p_IM_BROKER_NAME varchar(100),
    @p_IM_BROKER_CODE varchar(16),
    @p_IM_SUBBROKER varchar(16),
    @p_IM_BANK_NAME varchar(64),
    @p_IM_BANK_BRANCH varchar(64),
    @p_IM_BANK_SRNO varchar(16),
    @p_IM_REGISTRAR varchar(64),
    @p_IM_APPNO_START int,
    @p_IM_APPNO_END int,
    @p_IM_APPNO_PREFIX varchar(10),
    @p_IM_APPNO_SUFFIX varchar(10),
    @p_IM_APPNO_LENGTH smallint,
    @p_IM_CHQ_PAYABLETO varchar(100),
    @p_IM_OTHER_DETAILS varchar(100),
    @p_IM_NRI_FLAG tinyint,
    @p_IM_GL_CODE varchar(20),
    @p_IM_GL_NAME varchar(100),
    @p_IM_MODIFIEDBY bigint,
	@p_IP_ADD varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  
AS
BEGIN

   
SET @ErrorCode = 0    
  
 BEGIN TRANSACTION
    

--		INSERT INTO IPO_MASTER_JRNL
--		SELECT
--			*, 	@p_IM_MODIFIEDBY, GETDATE()
--		FROM 
--			[dbo].[IPO_MASTER]
--		WHERE 
--			[IM_IPO_NAME] = @p_IM_IPO_NAME

    UPDATE [dbo].[IPO_MASTER]
    SET       
            [IM_IPO_SYMBOL] = @p_IM_IPO_SYMBOL,
            [IM_OPEN_DATE] = CAST(@p_IM_OPEN_DATE AS DATETIME),
            [IM_CLOSE_DATE] = CAST(@p_IM_CLOSE_DATE AS DATETIME),
            [IM_ISSUE_SERIES] = @p_IM_ISSUE_SERIES,
            [IM_ISSUE_TYPE] = @p_IM_ISSUE_TYPE,
            [IM_FLOOR_PRICE] = @p_IM_FLOOR_PRICE,
            [IM_CAP_PRICE] = @p_IM_CAP_PRICE,
            [IM_FIXED_PRICE] = @p_IM_FIXED_PRICE,
            [IM_PRICE_MULTIPLE] = @p_IM_PRICE_MULTIPLE,
            [IM_CUTOFF_PRICE] = @p_IM_CUTOFF_PRICE,
            [IM_TRADING_LOT] = @p_IM_TRADING_LOT,
            [IM_MIN_BID_QTY] = @p_IM_MIN_BID_QTY,
            [IM_BID_QTY_MULTIPLE] = @p_IM_BID_QTY_MULTIPLE,
            [IM_FACE_VALUE] = @p_IM_FACE_VALUE,
            [IM_PARTIAL_AMT] = @p_IM_PARTIAL_AMT,
            [IM_PARTIAL_FLAG] = @p_IM_PARTIAL_FLAG,
            [IM_SYNMEM_NAME] = @p_IM_SYNMEM_NAME,
            [IM_SYNMEM_CODE] = @p_IM_SYNMEM_CODE,
            [IM_BROKER_NAME] = @p_IM_BROKER_NAME,
            [IM_BROKER_CODE] = @p_IM_BROKER_CODE,
            [IM_SUBBROKER] = @p_IM_SUBBROKER,
            [IM_BANK_NAME] = @p_IM_BANK_NAME,
            [IM_BANK_BRANCH] = @p_IM_BANK_BRANCH,
            [IM_BANK_SRNO] = @p_IM_BANK_SRNO,
            [IM_REGISTRAR] = @p_IM_REGISTRAR,
            [IM_APPNO_START] = @p_IM_APPNO_START,
            [IM_APPNO_END] = @p_IM_APPNO_END,
            [IM_APPNO_PREFIX] = @p_IM_APPNO_PREFIX,
            [IM_APPNO_SUFFIX] = @p_IM_APPNO_SUFFIX,
            [IM_APPNO_LENGTH] = @p_IM_APPNO_LENGTH,
            [IM_CHQ_PAYABLETO] = @p_IM_CHQ_PAYABLETO,
            [IM_OTHER_DETAILS] = @p_IM_OTHER_DETAILS,
            [IM_NRI_FLAG] = @p_IM_NRI_FLAG,
            [IM_GL_CODE] = @p_IM_GL_CODE,
            [IM_GL_NAME] = @p_IM_GL_NAME,
            [IM_MODIFIEDBY] = @p_IM_MODIFIEDBY,
            [IM_MODIFIEDDT] = GETDATE()
	WHERE
		[IM_IPO_NAME] = @p_IM_IPO_NAME


  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR UPDATING INTO IPO MASTER - '  + @p_IM_IPO_SYMBOL   
   GOTO ERROR    
  END    

 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000077                
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_MASTER_EDIT', @p_IP_ADD, @p_IM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message = 'IPO MASTER UPDATED SUCCESSFULLY.'  
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_TRANSACTIONS_ADD
-- --------------------------------------------------
-- Creates a new record in the [dbo].[IPO_TRANSACTIONS] table.
CREATE PROCEDURE [dbo].[IPO_IPO_TRANSACTIONS_ADD]
(
	@p_IT_IM_ID BIGINT,
	@p_UM_ID BIGINT,
	@p_IT_CL_ID BIGINT,
	@p_BID_QTY INT,
	@p_BID_PRICE NUMERIC(24,4),
	@p_BID_QTY2 INT,
	@p_BID_PRICE2 NUMERIC(24,4),
	@p_BID_QTY3 INT,
	@p_BID_PRICE3 NUMERIC(24,4),
	@p_ISSUE_SERIES VARCHAR(20),
	@p_CUT_OFF TINYINT,
	@p_CUT_OFF2 TINYINT,
	@p_CUT_OFF3 TINYINT,
	@p_IT_MODIFIEDBY BIGINT,
	@p_IP_ADD VARCHAR(20),  
	@ErrorCode INT OUTPUT,  
	@Message VARCHAR(200) OUTPUT 
)

/*
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
*/
AS
BEGIN

	DECLARE @IM_IPO_NAME VARCHAR(100)                         
	DECLARE @IM_IPO_SYMBOL VARCHAR(20)
	DECLARE @IM_FIXED_PRICE NUMERIC(24,4)
	DECLARE @IM_PARTIAL_FLAG TINYINT
	DECLARE @IM_PARTIAL_AMT NUMERIC(24,4)
	DECLARE @IM_GL_CODE VARCHAR(10)
	DECLARE @IM_GL_NAME VARCHAR(100)
	DECLARE @UM_CODE VARCHAR(50)
	DECLARE @UM_NAME VARCHAR(100)
	DECLARE @NUMISSPRICE NUMERIC(24,4)
	DECLARE @CALCAMOUNT NUMERIC(24,4)
	DECLARE @IM_APPNO_START INT
	DECLARE @IM_APPNO_END INT
	DECLARE @IM_APPNO_PREFIX VARCHAR(10)
	DECLARE @IM_APPNO_SUFFIX VARCHAR(10)
	DECLARE @IM_APPNO_LENGTH INT
	DECLARE @IT_APPNO VARCHAR(100)
	DECLARE @IPAPPCOUNT INT


BEGIN TRANSACTION

	SELECT 
		@IPAPPCOUNT = COUNT(1) 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE
		IT_FINAL_STATUS iN ('ORDERED', 'GENERATED', 'CONFIRMED')
		AND IT_IM_ID = @p_IT_IM_ID
		AND IT_CM_ID = @p_IT_CL_ID

	IF @IPAPPCOUNT > 0
	BEGIN
		SET  @ErrorCode = -1010013                                      
		SET  @Message   = 'YOU HAVE ALREADY APPLIED FOR THIS IPO'                                      
		GOTO ERROR    
	END


	SELECT
		@UM_CODE = UM_CODE,
		@UM_NAME = UM_NAME
	FROM 
		USER_MASTER (NOLOCK)
	WHERE
		UM_ID = @p_UM_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010000                                      
		SET  @Message   = 'ERROR FETCH USER DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    


	SELECT 
		@IM_IPO_NAME = IM_IPO_NAME,
		@IM_IPO_SYMBOL = IM_IPO_SYMBOL, 
		@IM_FIXED_PRICE = IM_FIXED_PRICE,
		@IM_PARTIAL_FLAG = IM_PARTIAL_FLAG,
		@IM_PARTIAL_AMT = IM_PARTIAL_AMT,
		@IM_GL_CODE = IM_GL_CODE,
		@IM_GL_NAME = IM_GL_NAME,
		@IM_APPNO_START = IM_APPNO_START,
		@IM_APPNO_END = IM_APPNO_END,
		@IM_APPNO_PREFIX = IM_APPNO_PREFIX,
		@IM_APPNO_SUFFIX = IM_APPNO_SUFFIX,
		@IM_APPNO_LENGTH = IM_APPNO_LENGTH
	FROM
		IPO_MASTER (NOLOCK)
	WHERE
		IM_ID = @p_IT_IM_ID
	      

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010001                                      
		SET  @Message   = 'ERROR FETCH IPO DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    

	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
		SET @IM_PARTIAL_AMT = @IM_FIXED_PRICE
		SET @IM_PARTIAL_FLAG = 1
	END

	DECLARE @OM_CHECK_BALANCE VARCHAR(20)
	DECLARE @OM_POST_LEDGER VARCHAR(3)

	SELECT
		@OM_CHECK_BALANCE = OM_CHECK_BALANCE,
		@OM_POST_LEDGER = OM_POST_LEDGER
	FROM
		OWNER_MASTER (NOLOCK)

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010002                                      
		SET  @Message   = 'ERROR FETCH OWNER MASTER - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END  
	/* NOW CHECK BALANCES FROM LEDGER */

	DECLARE @CASH_DEPOSITED DECIMAL(24,4)
	DECLARE @CASH_USED DECIMAL(24,4)
	DECLARE @CASH_AVAILABLE DECIMAL(24,4)

	SET @CASH_AVAILABLE = CAST(1000000000000 AS NUMERIC(24,4))

	IF @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @BALAMT MONEY
		EXEC ACCOUNT.DBO.IPO_CHECKLEDBAL 'FDT', @UM_CODE, 'IPOSYS',  @BALAMT output, @ERRORCODE output    		
			IF @ERRORCODE = 0    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(@BALAMT as NUMERIC(24,4))    
			END    
			ELSE    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(0 as NUMERIC(24,4))    
			END  
	END
	/* NOW CHECK BALANCES FROM CASH */
	
	--IF @OM_CHECK_BALANCE = 'CASH'
	--BEGIN
	--		SELECT 
	--			@CASH_DEPOSITED = CCB_AVAILABLE_LIMIT,
	--			@CASH_USED = CCB_USED_LIMIT,
	--			@CASH_AVAILABLE = ISNULL(CCB_AVAILABLE_LIMIT,0) - ISNULL(CCB_USED_LIMIT,0)
	--		FROM 
	--			CLIENT_CASH_BALANCE (NOLOCK)
	--		WHERE
	--			CCB_CM_ID = 	@p_IT_CL_ID
		   
		                                   
	--		IF @@ROWCOUNT = 0       
	--		BEGIN                        
	--			SET  @ErrorCode = -1010003                                      
	--			SET  @Message   = 'ERROR GETTING CASH DETAILS'                                      
	--			GOTO ERROR                                           
	--		END      
	--END
	/* NOW CHECK BALANCES LESS THAN ZERO */

	IF (@CASH_AVAILABLE <= 0)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010004                                     
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                    
		GOTO ERROR                                      
	END      



	/* NOW CALCULATE MAX BID VALUE */

  
	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
			DECLARE @MAXBIDQTY INT
			SET @MAXBIDQTY = @p_BID_QTY
			IF @p_BID_QTY2 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY2
			END
			IF @p_BID_QTY3 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY3
			END
			
			/* NOW SET THE PRICE AND CALCULATE VALUE  AT MAX BID QTY */

			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @IM_FIXED_PRICE
			END

			SET @CALCAMOUNT = @NUMISSPRICE * CAST(@MAXBIDQTY AS NUMERIC(24,4))
	END
	ELSE
	BEGIN
		DECLARE @MAXBIDVAL NUMERIC(24,4)
			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
				SET @p_BID_PRICE2 = @IM_PARTIAL_AMT
				SET @p_BID_PRICE3 = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @p_BID_PRICE
			END		
			
			SET @MAXBIDVAL = CAST(@p_BID_QTY AS NUMERIC(24,4)) * @NUMISSPRICE
			IF (CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2
			END
			IF (CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3
			END			
			SET @CALCAMOUNT = @MAXBIDVAL
	END


	/* NOW CHECK AGAINST BALANCE AVAILABLE */

	IF (@CALCAMOUNT > @CASH_AVAILABLE)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010005                                      
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                        
		GOTO ERROR
	END       	


	/* NOW POST TO LEDGER */

	IF @OM_POST_LEDGER = 'YES' AND @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @SessionID AS VARCHAR(8)
		DECLARE @MYBIDAMT MONEY

		SET @MYBIDAMT = CAST(@CALCAMOUNT AS MONEY)
	
		SELECT @sessionID = cast(cast(right(replace(convert(varchar,getdate(),114),':',''),6) as int) as varchar)    

		Exec ACCOUNT.DBO.IPO_POSTBIDDINGAMOUNT @UM_CODE, @MYBIDAMT, 'IPOSYS', @UM_NAME, @IM_IPO_NAME, @sessionID, 'ALL','A', 2, @IM_GL_CODE, @IM_GL_NAME     

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010006                                      
			SET  @Message   = 'PROBLEM POSTING ENTRIES TO LEDGER'                                      
			GOTO ERROR                                    
		END      
	END

	/* NOW UPDATE CASH BALANCE */

	IF @OM_CHECK_BALANCE = 'CASH' AND @OM_POST_LEDGER = 'YES'
	BEGIN
			UPDATE CLIENT_CASH_BALANCE
				SET CCB_USED_LIMIT = CCB_USED_LIMIT + @CALCAMOUNT
			WHERE
				CCB_CM_ID = 	@p_IT_CL_ID
		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010007                                      
			SET  @Message   = 'PROBLEM UPDATING CASH BALANCE'                                      
			GOTO ERROR                                    
		END  
	END       

	/* NOW FETCH DP DETAILS */

		DECLARE @IT_DEPOSITORY VARCHAR(10)
		DECLARE @IT_DPID VARCHAR(16)
		DECLARE @IT_DPNAME VARCHAR(100)
		DECLARE @IT_CLIENTDPID VARCHAR(8)

			SELECT 
				@IT_DEPOSITORY = CDD_DEPOSITORY,
				@IT_DPID = CDD_DPID,
				@IT_DPNAME = CDD_DPNAME,
				@IT_CLIENTDPID = CDD_CLIENTDPID
			FROM 
				CLIENT_DP_DETAILS (NOLOCK)
			WHERE
				CDD_CM_ID = 	@p_IT_CL_ID
		   
		                                   
			IF @@ROWCOUNT = 0       
			BEGIN                        
				SET  @ErrorCode = -101008                                      
				SET  @Message   = 'ERROR GETTING DP DETAILS'                                      
				GOTO ERROR                                           
			END      


	/* NOW GENERATE FORM NUMBER */

	IF @IM_APPNO_LENGTH = 0 
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END
	IF ((LEN(LTRIM(RTRIM(@IM_APPNO_PREFIX))) + LEN(LTRIM(RTRIM(@IM_APPNO_SUFFIX))))) > @IM_APPNO_LENGTH
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END

	DECLARE @MAXAPPID VARCHAR(100)
	DECLARE @MAXNEWID INT

	SET @MAXAPPID= ''
	SET @MAXNEWID = 0

	SELECT 
		@MAXAPPID = ISNULL(MAX(IT_APPNO),'') 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE 
		IT_IM_ID = @p_IT_IM_ID

	


		                                   
	IF @MAXAPPID = ''    
	BEGIN                        
		SET  @MAXNEWID = @IM_APPNO_START                                
	END      
	ELSE
	BEGIN
		SET @MAXAPPID = REPLACE(REPLACE(LTRIM(RTRIM(@MAXAPPID)),@IM_APPNO_PREFIX,''),@IM_APPNO_SUFFIX,'')
		SET  @MAXNEWID = CAST(@MAXAPPID AS INT) + 1
	END

	
	SET @MAXAPPID = CAST(@MAXNEWID AS VARCHAR)

	IF @MAXNEWID > @IM_APPNO_END
	BEGIN
			SET  @ErrorCode = -1010010                                      
			SET  @Message   = 'CANNOT GENERATE NEW FORM ID. GREATER THAN END ID'                                      
			GOTO ERROR   
	END

	WHILE (LEN(ISNULL(@IM_APPNO_PREFIX,'')) + LEN(ISNULL(@IM_APPNO_SUFFIX,''))+LEN(@MAXAPPID)) < @IM_APPNO_LENGTH
	BEGIN
	   SET @MAXAPPID = '0' + @MAXAPPID
	END
	

	SET @IT_APPNO = ISNULL(@IM_APPNO_PREFIX,'') + @MAXAPPID + ISNULL(@IM_APPNO_SUFFIX,'')

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010011                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID'                                      
			GOTO ERROR                                    
		END 

	/* NOW INSERT INTO IPO TRANSACTIONS */

 --   IF @ERRORCODE <> 0 
	--BEGIN
	--	SET @MESSAGE = 'UNKNOW ERROR - ' + CAST(@ERRORCODE AS VARCHAR)
	--	GOTO ERROR
	--END       

    INSERT
    INTO [dbo].[IPO_TRANSACTIONS]
        (
            [IT_IM_ID],
            [IT_CM_ID],
            [IT_USER_TYPE],
            [IT_USER_STATUS],
            [IT_POA],
            [IT_APPNAME1],
            [IT_APPNAME2],
            [IT_APPNAME3],
            [IT_DOB1],
            [IT_DOB2],
            [IT_DOB3],
            [IT_GENDER1],
            [IT_GENDER2],
            [IT_GENDER3],
            [IT_FATHERHUSBAND],
            [IT_PAN1],
            [IT_PAN2],
            [IT_PAN3],
            [IT_CIRCLE1],
            [IT_CIRCLE2],
            [IT_CIRCLE3],
            [IT_MAPINFLAG],
            [IT_MAPIN],
            [IT_CATEGORY],
            [IT_BM_ID],
            [IT_SBM_ID],
            [IT_NOMINEE],
            [IT_NOMINEE_RELATION],
            [IT_GUARDIANPAN],
            [IT_DEPOSITORY],
            [IT_DPID],
            [IT_DPNAME],
            [IT_CLIENTDPID],
            [IT_BID_QTY1],
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
            [IT_CUT_OFF1],
            [IT_CUT_OFF2],
            [IT_CUT_OFF3],
            [IT_PARTIAL_FLAG],
            [IT_PARTIAL_AMT],
            [IT_APPLIED_VALUE],
            [IT_APPNO],
            [IT_ORDER_TYPE],
            [IT_ORDER_STATUS],
            [IT_APP_PRINT_FLAG],
            [IT_STATUS],
            [IT_STATUS_MSG],
            [IT_FINAL_STATUS],
            [IT_MODIFIEDBY],
            [IT_MODIFIEDDT]
        )
	SELECT
		    @p_IT_IM_ID,
			CM_ID,
			CM_USER_TYPE,
			CM_USER_STATUS,
			CM_POA,
			CM_APPNAME1,
			CM_APPNAME2,
			CM_APPNAME3,
			CM_DOB1,
			CM_DOB2,
			CM_DOB3,
			CM_GENDER1,
			CM_GENDER2,
			CM_GENDER3,
			CM_FATHERHUSBAND,
			CM_PAN1,
			CM_PAN2,
			CM_PAN3,
			CM_CIRCLE1,
			CM_CIRCLE2,
			CM_CIRCLE3,
			CM_MAPINFLAG,
			CM_MAPIN,
			CM_CATEGORY,
			CM_BM_ID,
			CM_SBM_ID,
			CM_NOMINEE,
			CM_NOMINEE_RELATION,
			CM_GUARDIANPAN,
            @IT_DEPOSITORY,
            @IT_DPID,
            @IT_DPNAME,
            @IT_CLIENTDPID,
            @p_BID_QTY,
            @NUMISSPRICE,
			@p_BID_QTY2,
			@p_BID_PRICE2,
			@p_BID_QTY3,
			@p_BID_PRICE3,
            @p_CUT_OFF,
            @p_CUT_OFF2,
            @p_CUT_OFF3,
            @IM_PARTIAL_FLAG,
            @IM_PARTIAL_AMT,
            @CALCAMOUNT,
            @IT_APPNO,
            'FRESH ORDER',
            'ORDERED',
            0,
            'ORDERED',
            'ORDER ENTERED SUCCESSFULLY',
            'ORDERED',
            @p_IT_MODIFIEDBY,
            GETDATE()
	FROM
		CLIENT_MASTER
	WHERE 
		[CM_ID] = @p_IT_CL_ID

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010012                                      
			SET  @Message   = 'ERROR IN INSERTING TO TRANSACTION LOG'                                      
			GOTO ERROR                                    
		END      
		ELSE
		BEGIN
			SET  @ErrorCode = 0                                   
			GOTO ERROR 
		END	

 ERROR:    
    
 IF @ErrorCode = 0    
 BEGIN    
  COMMIT TRANSACTION    
  SET @ErrorCode = 0    
  SET @Message = 'ORDER PLACED SUCCESSFULLY SUCCESSFULLY. APPLICATION NO - ' + LTRIM(RTRIM(@IT_APPNO)) 
  RETURN 
END    
 ELSE    
 BEGIN    
  ROLLBACK TRANSACTION    
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_TRANSACTIONS_ADD', @p_IP_ADD, @p_IT_MODIFIEDBY  
	RETURN
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_TRANSACTIONS_ADD_bakjul2814
-- --------------------------------------------------
-- Creates a new record in the [dbo].[IPO_TRANSACTIONS] table.
create PROCEDURE [dbo].[IPO_IPO_TRANSACTIONS_ADD_bakjul2814]
(
	@p_IT_IM_ID BIGINT,
	@p_UM_ID BIGINT,
	@p_IT_CL_ID BIGINT,
	@p_BID_QTY INT,
	@p_BID_PRICE NUMERIC(24,4),
	@p_BID_QTY2 INT,
	@p_BID_PRICE2 NUMERIC(24,4),
	@p_BID_QTY3 INT,
	@p_BID_PRICE3 NUMERIC(24,4),
	@p_ISSUE_SERIES VARCHAR(20),
	@p_CUT_OFF TINYINT,
	@p_CUT_OFF2 TINYINT,
	@p_CUT_OFF3 TINYINT,
	@p_IT_MODIFIEDBY BIGINT,
	@p_IP_ADD VARCHAR(20),  
	@ErrorCode INT OUTPUT,  
	@Message VARCHAR(200) OUTPUT 
)

/*
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
*/
AS
BEGIN

	DECLARE @IM_IPO_NAME VARCHAR(100)                         
	DECLARE @IM_IPO_SYMBOL VARCHAR(20)
	DECLARE @IM_FIXED_PRICE NUMERIC(24,4)
	DECLARE @IM_PARTIAL_FLAG TINYINT
	DECLARE @IM_PARTIAL_AMT NUMERIC(24,4)
	DECLARE @IM_GL_CODE VARCHAR(10)
	DECLARE @IM_GL_NAME VARCHAR(100)
	DECLARE @UM_CODE VARCHAR(50)
	DECLARE @UM_NAME VARCHAR(100)
	DECLARE @NUMISSPRICE NUMERIC(24,4)
	DECLARE @CALCAMOUNT NUMERIC(24,4)
	DECLARE @IM_APPNO_START INT
	DECLARE @IM_APPNO_END INT
	DECLARE @IM_APPNO_PREFIX VARCHAR(10)
	DECLARE @IM_APPNO_SUFFIX VARCHAR(10)
	DECLARE @IM_APPNO_LENGTH INT
	DECLARE @IT_APPNO VARCHAR(100)
	DECLARE @IPAPPCOUNT INT


BEGIN TRANSACTION

	SELECT 
		@IPAPPCOUNT = COUNT(1) 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE
		IT_FINAL_STATUS iN ('ORDERED', 'GENERATED', 'CONFIRMED')
		AND IT_IM_ID = @p_IT_IM_ID
		AND IT_CM_ID = @p_IT_CL_ID

	IF @IPAPPCOUNT > 0
	BEGIN
		SET  @ErrorCode = -1010013                                      
		SET  @Message   = 'YOU HAVE ALREADY APPLIED FOR THIS IPO'                                      
		GOTO ERROR    
	END


	SELECT
		@UM_CODE = UM_CODE,
		@UM_NAME = UM_NAME
	FROM 
		USER_MASTER (NOLOCK)
	WHERE
		UM_ID = @p_UM_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010000                                      
		SET  @Message   = 'ERROR FETCH USER DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    


	SELECT 
		@IM_IPO_NAME = IM_IPO_NAME,
		@IM_IPO_SYMBOL = IM_IPO_SYMBOL, 
		@IM_FIXED_PRICE = IM_FIXED_PRICE,
		@IM_PARTIAL_FLAG = IM_PARTIAL_FLAG,
		@IM_PARTIAL_AMT = IM_PARTIAL_AMT,
		@IM_GL_CODE = IM_GL_CODE,
		@IM_GL_NAME = IM_GL_NAME,
		@IM_APPNO_START = IM_APPNO_START,
		@IM_APPNO_END = IM_APPNO_END,
		@IM_APPNO_PREFIX = IM_APPNO_PREFIX,
		@IM_APPNO_SUFFIX = IM_APPNO_SUFFIX,
		@IM_APPNO_LENGTH = IM_APPNO_LENGTH
	FROM
		IPO_MASTER (NOLOCK)
	WHERE
		IM_ID = @p_IT_IM_ID
	      

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010001                                      
		SET  @Message   = 'ERROR FETCH IPO DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    

	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
		SET @IM_PARTIAL_AMT = @IM_FIXED_PRICE
		SET @IM_PARTIAL_FLAG = 1
	END

	DECLARE @OM_CHECK_BALANCE VARCHAR(20)
	DECLARE @OM_POST_LEDGER VARCHAR(3)

	SELECT
		@OM_CHECK_BALANCE = OM_CHECK_BALANCE,
		@OM_POST_LEDGER = OM_POST_LEDGER
	FROM
		OWNER_MASTER (NOLOCK)

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010002                                      
		SET  @Message   = 'ERROR FETCH OWNER MASTER - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END  
	/* NOW CHECK BALANCES FROM LEDGER */

	DECLARE @CASH_DEPOSITED DECIMAL(24,4)
	DECLARE @CASH_USED DECIMAL(24,4)
	DECLARE @CASH_AVAILABLE DECIMAL(24,4)

	SET @CASH_AVAILABLE = CAST(1000000000000 AS NUMERIC(24,4))

	IF @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @BALAMT MONEY
		EXEC ACCOUNT.DBO.IPO_CHECKLEDBAL 'FDT', @UM_CODE, 'IPOSYS',  @BALAMT output, @ERRORCODE output    		
			IF @ERRORCODE = 0    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(@BALAMT as NUMERIC(24,4))    
			END    
			ELSE    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(0 as NUMERIC(24,4))    
			END  
	END
	/* NOW CHECK BALANCES FROM CASH */
	
	IF @OM_CHECK_BALANCE = 'CASH'
	BEGIN
			SELECT 
				@CASH_DEPOSITED = CCB_AVAILABLE_LIMIT,
				@CASH_USED = CCB_USED_LIMIT,
				@CASH_AVAILABLE = ISNULL(CCB_AVAILABLE_LIMIT,0) - ISNULL(CCB_USED_LIMIT,0)
			FROM 
				CLIENT_CASH_BALANCE (NOLOCK)
			WHERE
				CCB_CM_ID = 	@p_IT_CL_ID
		   
		                                   
			IF @@ROWCOUNT = 0       
			BEGIN                        
				SET  @ErrorCode = -1010003                                      
				SET  @Message   = 'ERROR GETTING CASH DETAILS'                                      
				GOTO ERROR                                           
			END      
	END
	/* NOW CHECK BALANCES LESS THAN ZERO */

	IF (@CASH_AVAILABLE <= 0)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010004                                     
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                    
		GOTO ERROR                                      
	END      



	/* NOW CALCULATE MAX BID VALUE */

  
	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
			DECLARE @MAXBIDQTY INT
			SET @MAXBIDQTY = @p_BID_QTY
			IF @p_BID_QTY2 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY2
			END
			IF @p_BID_QTY3 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY3
			END
			
			/* NOW SET THE PRICE AND CALCULATE VALUE  AT MAX BID QTY */

			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @IM_FIXED_PRICE
			END

			SET @CALCAMOUNT = @NUMISSPRICE * CAST(@MAXBIDQTY AS NUMERIC(24,4))
	END
	ELSE
	BEGIN
		DECLARE @MAXBIDVAL NUMERIC(24,4)
			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
				SET @p_BID_PRICE2 = @IM_PARTIAL_AMT
				SET @p_BID_PRICE3 = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @p_BID_PRICE
			END		
			
			SET @MAXBIDVAL = CAST(@p_BID_QTY AS NUMERIC(24,4)) * @NUMISSPRICE
			IF (CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2
			END
			IF (CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3
			END			
			SET @CALCAMOUNT = @MAXBIDVAL
	END


	/* NOW CHECK AGAINST BALANCE AVAILABLE */

	IF (@CALCAMOUNT > @CASH_AVAILABLE)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010005                                      
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                        
		GOTO ERROR
	END       	


	/* NOW POST TO LEDGER */

	IF @OM_POST_LEDGER = 'YES' AND @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @SessionID AS VARCHAR(8)
		DECLARE @MYBIDAMT MONEY

		SET @MYBIDAMT = CAST(@CALCAMOUNT AS MONEY)
	
		SELECT @sessionID = cast(cast(right(replace(convert(varchar,getdate(),114),':',''),6) as int) as varchar)    

		Exec ACCOUNT.DBO.IPO_POSTBIDDINGAMOUNT @UM_CODE, @MYBIDAMT, 'IPOSYS', @UM_NAME, @IM_IPO_NAME, @sessionID, 'ALL','A', 2, @IM_GL_CODE, @IM_GL_NAME     

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010006                                      
			SET  @Message   = 'PROBLEM POSTING ENTRIES TO LEDGER'                                      
			GOTO ERROR                                    
		END      
	END

	/* NOW UPDATE CASH BALANCE */

	IF @OM_CHECK_BALANCE = 'CASH' AND @OM_POST_LEDGER = 'YES'
	BEGIN
			UPDATE CLIENT_CASH_BALANCE
				SET CCB_USED_LIMIT = CCB_USED_LIMIT + @CALCAMOUNT
			WHERE
				CCB_CM_ID = 	@p_IT_CL_ID
		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010007                                      
			SET  @Message   = 'PROBLEM UPDATING CASH BALANCE'                                      
			GOTO ERROR                                    
		END  
	END       

	/* NOW FETCH DP DETAILS */

		DECLARE @IT_DEPOSITORY VARCHAR(10)
		DECLARE @IT_DPID VARCHAR(16)
		DECLARE @IT_DPNAME VARCHAR(100)
		DECLARE @IT_CLIENTDPID VARCHAR(8)

			SELECT 
				@IT_DEPOSITORY = CDD_DEPOSITORY,
				@IT_DPID = CDD_DPID,
				@IT_DPNAME = CDD_DPNAME,
				@IT_CLIENTDPID = CDD_CLIENTDPID
			FROM 
				CLIENT_DP_DETAILS (NOLOCK)
			WHERE
				CDD_CM_ID = 	@p_IT_CL_ID
		   
		                                   
			IF @@ROWCOUNT = 0       
			BEGIN                        
				SET  @ErrorCode = -101008                                      
				SET  @Message   = 'ERROR GETTING DP DETAILS'                                      
				GOTO ERROR                                           
			END      


	/* NOW GENERATE FORM NUMBER */

	IF @IM_APPNO_LENGTH = 0 
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END
	IF ((LEN(LTRIM(RTRIM(@IM_APPNO_PREFIX))) + LEN(LTRIM(RTRIM(@IM_APPNO_SUFFIX))))) > @IM_APPNO_LENGTH
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END

	DECLARE @MAXAPPID VARCHAR(100)
	DECLARE @MAXNEWID INT

	SET @MAXAPPID= ''
	SET @MAXNEWID = 0

	SELECT 
		@MAXAPPID = ISNULL(MAX(IT_APPNO),'') 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE 
		IT_IM_ID = @p_IT_IM_ID

	


		                                   
	IF @MAXAPPID = ''    
	BEGIN                        
		SET  @MAXNEWID = @IM_APPNO_START                                
	END      
	ELSE
	BEGIN
		SET @MAXAPPID = REPLACE(REPLACE(LTRIM(RTRIM(@MAXAPPID)),@IM_APPNO_PREFIX,''),@IM_APPNO_SUFFIX,'')
		SET  @MAXNEWID = CAST(@MAXAPPID AS INT) + 1
	END

	
	SET @MAXAPPID = CAST(@MAXNEWID AS VARCHAR)

	IF @MAXNEWID > @IM_APPNO_END
	BEGIN
			SET  @ErrorCode = -1010010                                      
			SET  @Message   = 'CANNOT GENERATE NEW FORM ID. GREATER THAN END ID'                                      
			GOTO ERROR   
	END

	WHILE (LEN(ISNULL(@IM_APPNO_PREFIX,'')) + LEN(ISNULL(@IM_APPNO_SUFFIX,''))+LEN(@MAXAPPID)) < @IM_APPNO_LENGTH
	BEGIN
	   SET @MAXAPPID = '0' + @MAXAPPID
	END
	

	SET @IT_APPNO = ISNULL(@IM_APPNO_PREFIX,'') + @MAXAPPID + ISNULL(@IM_APPNO_SUFFIX,'')

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010011                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID'                                      
			GOTO ERROR                                    
		END 

	/* NOW INSERT INTO IPO TRANSACTIONS */

    IF @ERRORCODE <> 0 
	BEGIN
		SET @MESSAGE = 'UNKNOW ERROR - ' + CAST(@ERRORCODE AS VARCHAR)
		GOTO ERROR
	END       

    INSERT
    INTO [dbo].[IPO_TRANSACTIONS]
        (
            [IT_IM_ID],
            [IT_CM_ID],
            [IT_USER_TYPE],
            [IT_USER_STATUS],
            [IT_POA],
            [IT_APPNAME1],
            [IT_APPNAME2],
            [IT_APPNAME3],
            [IT_DOB1],
            [IT_DOB2],
            [IT_DOB3],
            [IT_GENDER1],
            [IT_GENDER2],
            [IT_GENDER3],
            [IT_FATHERHUSBAND],
            [IT_PAN1],
            [IT_PAN2],
            [IT_PAN3],
            [IT_CIRCLE1],
            [IT_CIRCLE2],
            [IT_CIRCLE3],
            [IT_MAPINFLAG],
            [IT_MAPIN],
            [IT_CATEGORY],
            [IT_BM_ID],
            [IT_SBM_ID],
            [IT_NOMINEE],
            [IT_NOMINEE_RELATION],
            [IT_GUARDIANPAN],
            [IT_DEPOSITORY],
            [IT_DPID],
            [IT_DPNAME],
            [IT_CLIENTDPID],
            [IT_BID_QTY1],
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
            [IT_CUT_OFF1],
            [IT_CUT_OFF2],
            [IT_CUT_OFF3],
            [IT_PARTIAL_FLAG],
            [IT_PARTIAL_AMT],
            [IT_APPLIED_VALUE],
            [IT_APPNO],
            [IT_ORDER_TYPE],
            [IT_ORDER_STATUS],
            [IT_APP_PRINT_FLAG],
            [IT_STATUS],
            [IT_STATUS_MSG],
            [IT_FINAL_STATUS],
            [IT_MODIFIEDBY],
            [IT_MODIFIEDDT]
        )
	SELECT
		    @p_IT_IM_ID,
			CM_ID,
			CM_USER_TYPE,
			CM_USER_STATUS,
			CM_POA,
			CM_APPNAME1,
			CM_APPNAME2,
			CM_APPNAME3,
			CM_DOB1,
			CM_DOB2,
			CM_DOB3,
			CM_GENDER1,
			CM_GENDER2,
			CM_GENDER3,
			CM_FATHERHUSBAND,
			CM_PAN1,
			CM_PAN2,
			CM_PAN3,
			CM_CIRCLE1,
			CM_CIRCLE2,
			CM_CIRCLE3,
			CM_MAPINFLAG,
			CM_MAPIN,
			CM_CATEGORY,
			CM_BM_ID,
			CM_SBM_ID,
			CM_NOMINEE,
			CM_NOMINEE_RELATION,
			CM_GUARDIANPAN,
            @IT_DEPOSITORY,
            @IT_DPID,
            @IT_DPNAME,
            @IT_CLIENTDPID,
            @p_BID_QTY,
            @NUMISSPRICE,
			@p_BID_QTY2,
			@p_BID_PRICE2,
			@p_BID_QTY3,
			@p_BID_PRICE3,
            @p_CUT_OFF,
            @p_CUT_OFF2,
            @p_CUT_OFF3,
            @IM_PARTIAL_FLAG,
            @IM_PARTIAL_AMT,
            @CALCAMOUNT,
            @IT_APPNO,
            'FRESH ORDER',
            'ORDERED',
            0,
            'ORDERED',
            'ORDER ENTERED SUCCESSFULLY',
            'ORDERED',
            @p_IT_MODIFIEDBY,
            GETDATE()
	FROM
		CLIENT_MASTER
	WHERE 
		[CM_ID] = @p_IT_CL_ID

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010012                                      
			SET  @Message   = 'ERROR IN INSERTING TO TRANSACTION LOG'                                      
			GOTO ERROR                                    
		END      
		ELSE
		BEGIN
			SET  @ErrorCode = 0                                   
			GOTO ERROR 
		END	

 ERROR:    
    
 IF @ErrorCode = 0    
 BEGIN    
  COMMIT TRANSACTION    
  SET @ErrorCode = 0    
  SET @Message = 'ORDER PLACED SUCCESSFULLY SUCCESSFULLY. APPLICATION NO - ' + LTRIM(RTRIM(@IT_APPNO)) 
  RETURN 
END    
 ELSE    
 BEGIN    
  ROLLBACK TRANSACTION    
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_TRANSACTIONS_ADD', @p_IP_ADD, @p_IT_MODIFIEDBY  
	RETURN
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_TRANSACTIONS_CANCEL
-- --------------------------------------------------
-- Creates a new record in the [dbo].[IPO_TRANSACTIONS] table.
CREATE PROCEDURE [dbo].[IPO_IPO_TRANSACTIONS_CANCEL]
(
	@p_ORD_ID BIGINT,
	@p_ORD_MODIFIEDBY BIGINT,
	@p_IP_ADD VARCHAR(20),  
	@ErrorCode INT OUTPUT,  
	@Message VARCHAR(200) OUTPUT 
)

AS
BEGIN

	DECLARE @IM_IPO_NAME VARCHAR(100)                         
	DECLARE @IM_GL_CODE VARCHAR(10)
	DECLARE @IM_GL_NAME VARCHAR(100)
	DECLARE @UM_CODE VARCHAR(50)
	DECLARE @UM_NAME VARCHAR(100)
	DECLARE @IT_APPLIED_VALUE NUMERIC(24,4)
	DECLARE @IT_CM_ID BIGINT
	DECLARE @IT_IM_ID BIGINT
	DECLARE @CM_UM_ID BIGINT
	DECLARE @IPAPPCOUNT INT


BEGIN TRANSACTION

	SELECT 
		@IPAPPCOUNT = COUNT(1) 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE
		IT_FINAL_STATUS = 'ORDERED'
		AND IT_ID = @p_ORD_ID

	IF @IPAPPCOUNT <> 1
	BEGIN
		SET  @ErrorCode = -1020013                                      
		SET  @Message   = 'THIS ORDER CANNOT BE CANCELLED'                                      
		GOTO ERROR    
	END


	SELECT
		@IT_CM_ID = IT_CM_ID,
		@IT_IM_ID = IT_IM_ID,
		@IT_APPLIED_VALUE = IT_APPLIED_VALUE
	FROM 
		IPO_TRANSACTIONS 
	WHERE
		IT_ID = @p_ORD_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1020000                                      
		SET  @Message   = 'ERROR FETCH ORDER DETAILS - ORDER CANCELLATION'                                      
		GOTO ERROR                                      
	END    

	SELECT
		@IM_IPO_NAME = IM_IPO_NAME,
		@IM_GL_CODE = IM_GL_CODE,
		@IM_GL_NAME = IM_GL_NAME
	FROM 
		IPO_MASTER
	WHERE
		IM_ID = @IT_IM_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1020001                                      
		SET  @Message   = 'ERROR FETCH IPO DETAILS - ORDER CANCELLATION'                                      
		GOTO ERROR                                      
	END    


	SELECT
		@CM_UM_ID = CM_UM_ID
	FROM 
		CLIENT_MASTER
	WHERE
		CM_ID = @IT_CM_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1020002                                      
		SET  @Message   = 'ERROR FETCH CLIENT MASTER DETAILS - ORDER CANCELLATION'                                      
		GOTO ERROR                                      
	END    

	SELECT
		@UM_CODE = UM_CODE,
		@UM_NAME = UM_NAME
	FROM 
		USER_MASTER
	WHERE
		UM_ID = @CM_UM_ID

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1020003                                      
		SET  @Message   = 'ERROR FETCH USER MASTER DETAILS - ORDER CANCELLATION'                                      
		GOTO ERROR                                      
	END    



	DECLARE @OM_CHECK_BALANCE VARCHAR(20)
	DECLARE @OM_POST_LEDGER VARCHAR(3)

	SELECT
		@OM_CHECK_BALANCE = OM_CHECK_BALANCE,
		@OM_POST_LEDGER = OM_POST_LEDGER
	FROM
		OWNER_MASTER (NOLOCK)

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1020004                                      
		SET  @Message   = 'ERROR FETCH OWNER MASTER - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END  



	/* NOW POST TO LEDGER */

	IF @OM_POST_LEDGER = 'YES' AND @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @SessionID AS VARCHAR(8)
		DECLARE @MYBIDAMT MONEY

		SET @MYBIDAMT = CAST(@IT_APPLIED_VALUE AS MONEY)
	
		SELECT @sessionID = cast(cast(right(replace(convert(varchar,getdate(),114),':',''),6) as int) as varchar)    

		Exec ACCOUNT.DBO.IPO_POSTBIDDINGAMOUNT @IM_GL_CODE, @MYBIDAMT, 'IPOSYS', @IM_GL_NAME , @IM_IPO_NAME, @sessionID, 'ALL','A', 2, @UM_CODE, @UM_NAME    

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1020005                                      
			SET  @Message   = 'PROBLEM POSTING ENTRIES TO LEDGER'                                      
			GOTO ERROR                                    
		END      
	END

	/* NOW UPDATE CASH BALANCE */

	IF @OM_CHECK_BALANCE = 'CASH' AND @OM_POST_LEDGER = 'YES'
	BEGIN
			UPDATE CLIENT_CASH_BALANCE
				SET CCB_USED_LIMIT = CCB_USED_LIMIT - @IT_APPLIED_VALUE
			WHERE
				CCB_CM_ID = 	@IT_CM_ID

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1020006                                      
			SET  @Message   = 'PROBLEM UPDATING CASH BALANCE'                                      
			GOTO ERROR                                    
		END  
	END       

	/* NOW UPDATE IPO TRANSACTIONS */

    IF @ERRORCODE <> 0 
	BEGIN
		SET @MESSAGE = 'UNKNOW ERROR - ' + CAST(@ERRORCODE AS VARCHAR)
		GOTO ERROR
	END       

    UPDATE [dbo].[IPO_TRANSACTIONS]
	SET
            [IT_STATUS_MSG] = 'ORDER CANCELLED SUCCESSFULLY',
            [IT_FINAL_STATUS] = 'CANCELLED',
            [IT_UPDATEBY] = @p_ORD_MODIFIEDBY,
            [IT_UPDATEDT] = GETDATE()
    WHERE
		[IT_ID] = @p_ORD_ID

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1020007                                      
			SET  @Message   = 'ERROR IN INSERTING TO TRANSACTION LOG'                                      
			GOTO ERROR                                    
		END      
		ELSE
		BEGIN
			SET  @ErrorCode = 0                                   
			GOTO ERROR 
		END	

 ERROR:    
    
 IF @ErrorCode = 0    
 BEGIN    
  COMMIT TRANSACTION    
  SET @ErrorCode = 0    
  SET @Message = 'ORDER CANCELLED SUCCESSFULLY SUCCESSFULLY. ORD NO - ' + LTRIM(RTRIM(@p_ORD_ID)) 
  RETURN 
END    
 ELSE    
 BEGIN    
  ROLLBACK TRANSACTION    
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_TRANSACTIONS_CANCEL', @p_IP_ADD, @p_ORD_MODIFIEDBY  
	RETURN
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_IPO_TRANSACTIONS_MAK_ADD
-- --------------------------------------------------
-- Creates a new record in the [dbo].[IPO_TRANSACTIONS_MAK] table.
CREATE PROCEDURE [dbo].[IPO_IPO_TRANSACTIONS_MAK_ADD]
(
	@p_IT_IM_ID BIGINT,
	@p_UM_ID BIGINT,
	@p_IT_CL_ID BIGINT,
	@p_BID_QTY INT,
	@p_BID_PRICE NUMERIC(24,4),
	@p_BID_QTY2 INT,
	@p_BID_PRICE2 NUMERIC(24,4),
	@p_BID_QTY3 INT,
	@p_BID_PRICE3 NUMERIC(24,4),
	@p_ISSUE_SERIES VARCHAR(20),
	@p_CUT_OFF TINYINT,
	@p_CUT_OFF2 TINYINT,
	@p_CUT_OFF3 TINYINT,
	@p_IT_MODIFIEDBY BIGINT,
	@p_IP_ADD VARCHAR(20),  
	@ErrorCode INT OUTPUT,  
	@Message VARCHAR(200) OUTPUT 
)

/*
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
*/
AS
BEGIN

	DECLARE @IM_IPO_NAME VARCHAR(100)                         
	DECLARE @IM_IPO_SYMBOL VARCHAR(20)
	DECLARE @IM_FIXED_PRICE NUMERIC(24,4)
	DECLARE @IM_PARTIAL_FLAG TINYINT
	DECLARE @IM_PARTIAL_AMT NUMERIC(24,4)
	DECLARE @IM_GL_CODE VARCHAR(10)
	DECLARE @IM_GL_NAME VARCHAR(100)
	DECLARE @UM_CODE VARCHAR(50)
	DECLARE @UM_NAME VARCHAR(100)
	DECLARE @NUMISSPRICE NUMERIC(24,4)
	DECLARE @CALCAMOUNT NUMERIC(24,4)
	DECLARE @IM_APPNO_START INT
	DECLARE @IM_APPNO_END INT
	DECLARE @IM_APPNO_PREFIX VARCHAR(10)
	DECLARE @IM_APPNO_SUFFIX VARCHAR(10)
	DECLARE @IM_APPNO_LENGTH INT
	DECLARE @IT_APPNO VARCHAR(100)
	DECLARE @IPAPPCOUNT INT


BEGIN TRANSACTION

	SELECT 
		@IPAPPCOUNT = COUNT(1) 
	FROM 
		IPO_TRANSACTIONS (NOLOCK)
	WHERE
		IT_FINAL_STATUS iN ('ORDERED', 'GENERATED', 'CONFIRMED')
		AND IT_IM_ID = @p_IT_IM_ID
		AND IT_CM_ID = @p_IT_CL_ID

	IF @IPAPPCOUNT > 0
	BEGIN
		SET  @ErrorCode = -1010013                                      
		SET  @Message   = 'YOU HAVE ALREADY APPLIED FOR THIS IPO'                                      
		GOTO ERROR    
	END
	
	update [IPO_TRANSACTIONS_MAK] set IT_DELETED_IND = 3
	where IT_DELETED_IND = 0
	AND IT_IM_ID = @p_IT_IM_ID
	AND IT_CM_ID = @p_IT_CL_ID
	


	SELECT
		@UM_CODE = UM_CODE,
		@UM_NAME = UM_NAME
	FROM 
		USER_MASTER (NOLOCK)
	WHERE
		UM_ID = @p_UM_ID
	UNION ALL
	SELECT
		@UM_CODE = FLDUSERNAME,
		@UM_NAME = FLDUSERNAME
	FROM 
		TBLPRADNYAUSERS (NOLOCK)
	WHERE
		fldauto = @p_UM_ID

		

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010000                                      
		SET  @Message   = 'ERROR FETCH USER DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    


	SELECT 
		@IM_IPO_NAME = IM_IPO_NAME,
		@IM_IPO_SYMBOL = IM_IPO_SYMBOL, 
		@IM_FIXED_PRICE = IM_FIXED_PRICE,
		@IM_PARTIAL_FLAG = IM_PARTIAL_FLAG,
		@IM_PARTIAL_AMT = IM_PARTIAL_AMT,
		@IM_GL_CODE = IM_GL_CODE,
		@IM_GL_NAME = IM_GL_NAME,
		@IM_APPNO_START = IM_APPNO_START,
		@IM_APPNO_END = IM_APPNO_END,
		@IM_APPNO_PREFIX = IM_APPNO_PREFIX,
		@IM_APPNO_SUFFIX = IM_APPNO_SUFFIX,
		@IM_APPNO_LENGTH = IM_APPNO_LENGTH
	FROM
		IPO_MASTER (NOLOCK)
	WHERE
		IM_ID = @p_IT_IM_ID
	      

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010001                                      
		SET  @Message   = 'ERROR FETCH IPO DETAILS - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END    

	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
		SET @IM_PARTIAL_AMT = @IM_FIXED_PRICE
		SET @IM_PARTIAL_FLAG = 1
	END

	DECLARE @OM_CHECK_BALANCE VARCHAR(20)
	DECLARE @OM_POST_LEDGER VARCHAR(3)

	SELECT
		@OM_CHECK_BALANCE = OM_CHECK_BALANCE,
		@OM_POST_LEDGER = OM_POST_LEDGER
	FROM
		OWNER_MASTER (NOLOCK)

	IF @@ROWCOUNT = 0       
	BEGIN                        
		SET  @ErrorCode = -1010002                                      
		SET  @Message   = 'ERROR FETCH OWNER MASTER - ORDER ENTRY'                                      
		GOTO ERROR                                      
	END  
	/* NOW CHECK BALANCES FROM LEDGER */

	DECLARE @CASH_DEPOSITED DECIMAL(24,4)
	DECLARE @CASH_USED DECIMAL(24,4)
	DECLARE @CASH_AVAILABLE DECIMAL(24,4)

	SET @CASH_AVAILABLE = CAST(1000000000000 AS NUMERIC(24,4))

	IF @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @BALAMT MONEY
		EXEC ACCOUNT.DBO.IPO_CHECKLEDBAL 'FDT', @UM_CODE, 'IPOSYS',  @BALAMT output, @ERRORCODE output    		
			IF @ERRORCODE = 0    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(@BALAMT as NUMERIC(24,4))    
			END    
			ELSE    
			BEGIN    
			 SET @CASH_AVAILABLE = Cast(0 as NUMERIC(24,4))    
			END  
	END
	/* NOW CHECK BALANCES FROM CASH */
	
	--IF @OM_CHECK_BALANCE = 'CASH'
	--BEGIN
	--		SELECT 
	--			@CASH_DEPOSITED = CCB_AVAILABLE_LIMIT,
	--			@CASH_USED = CCB_USED_LIMIT,
	--			@CASH_AVAILABLE = ISNULL(CCB_AVAILABLE_LIMIT,0) - ISNULL(CCB_USED_LIMIT,0)
	--		FROM 
	--			CLIENT_CASH_BALANCE (NOLOCK)
	--		WHERE
	--			CCB_CM_ID = 	@p_IT_CL_ID
		   
		                                   
	--		IF @@ROWCOUNT = 0       
	--		BEGIN                        
	--			SET  @ErrorCode = -1010003                                      
	--			SET  @Message   = 'ERROR GETTING CASH DETAILS'                                      
	--			GOTO ERROR                                           
	--		END      
	--END
	/* NOW CHECK BALANCES LESS THAN ZERO */

	IF (@CASH_AVAILABLE <= 0)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010004                                     
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                    
		GOTO ERROR                                      
	END      



	/* NOW CALCULATE MAX BID VALUE */

  
	IF @p_ISSUE_SERIES = 'FIXED PRICE'
	BEGIN
			DECLARE @MAXBIDQTY INT
			SET @MAXBIDQTY = @p_BID_QTY
			IF @p_BID_QTY2 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY2
			END
			IF @p_BID_QTY3 > @MAXBIDQTY
			BEGIN
				SET @MAXBIDQTY = @p_BID_QTY3
			END
			
			/* NOW SET THE PRICE AND CALCULATE VALUE  AT MAX BID QTY */

			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @IM_FIXED_PRICE
			END

			SET @CALCAMOUNT = @NUMISSPRICE * CAST(@MAXBIDQTY AS NUMERIC(24,4))
	END
	ELSE
	BEGIN
		DECLARE @MAXBIDVAL NUMERIC(24,4)
			IF @IM_PARTIAL_FLAG = 1
			BEGIN
				SET @NUMISSPRICE = @IM_PARTIAL_AMT
				SET @p_BID_PRICE2 = @IM_PARTIAL_AMT
				SET @p_BID_PRICE3 = @IM_PARTIAL_AMT
			END
			ELSE
			BEGIN
				SET @NUMISSPRICE = @p_BID_PRICE
			END		
			
			SET @MAXBIDVAL = CAST(@p_BID_QTY AS NUMERIC(24,4)) * @NUMISSPRICE
			IF (CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY2 AS NUMERIC(24,4)) * @p_BID_PRICE2
			END
			IF (CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3) > @MAXBIDVAL
			BEGIN
				SET @MAXBIDVAL = CAST(@p_BID_QTY3 AS NUMERIC(24,4)) * @p_BID_PRICE3
			END			
			SET @CALCAMOUNT = @MAXBIDVAL
	END


	/* NOW CHECK AGAINST BALANCE AVAILABLE */

	IF (@CALCAMOUNT > @CASH_AVAILABLE)                                      
	BEGIN                                      
		SET  @ErrorCode = -1010005                                      
		SET  @Message   = 'SUFFICIENT CASH NOT AVAILABLE TO PLACE ORDER'                        
		GOTO ERROR
	END       	


	/* NOW POST TO LEDGER */

	IF @OM_POST_LEDGER = 'YES' AND @OM_CHECK_BALANCE = 'LEDGER'
	BEGIN
		DECLARE @SessionID AS VARCHAR(8)
		DECLARE @MYBIDAMT MONEY

		SET @MYBIDAMT = CAST(@CALCAMOUNT AS MONEY)
	
		SELECT @sessionID = cast(cast(right(replace(convert(varchar,getdate(),114),':',''),6) as int) as varchar)    

		Exec ACCOUNT.DBO.IPO_POSTBIDDINGAMOUNT @UM_CODE, @MYBIDAMT, 'IPOSYS', @UM_NAME, @IM_IPO_NAME, @sessionID, 'ALL','A', 2, @IM_GL_CODE, @IM_GL_NAME     

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010006                                      
			SET  @Message   = 'PROBLEM POSTING ENTRIES TO LEDGER'                                      
			GOTO ERROR                                    
		END      
	END

	/* NOW UPDATE CASH BALANCE */

	IF @OM_CHECK_BALANCE = 'CASH' AND @OM_POST_LEDGER = 'YES'
	BEGIN
			UPDATE CLIENT_CASH_BALANCE
				SET CCB_USED_LIMIT = CCB_USED_LIMIT + @CALCAMOUNT
			WHERE
				CCB_CM_ID = 	@p_IT_CL_ID
		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010007                                      
			SET  @Message   = 'PROBLEM UPDATING CASH BALANCE'                                      
			GOTO ERROR                                    
		END  
	END       

	/* NOW FETCH DP DETAILS */

		DECLARE @IT_DEPOSITORY VARCHAR(10)
		DECLARE @IT_DPID VARCHAR(16)
		DECLARE @IT_DPNAME VARCHAR(100)
		DECLARE @IT_CLIENTDPID VARCHAR(8)

			SELECT 
				@IT_DEPOSITORY = CDD_DEPOSITORY,
				@IT_DPID = CDD_DPID,
				@IT_DPNAME = CDD_DPNAME,
				@IT_CLIENTDPID = CDD_CLIENTDPID
			FROM 
				CLIENT_DP_DETAILS (NOLOCK)
			WHERE
				CDD_CM_ID = 	@p_IT_CL_ID
		   
		                                   
			IF @@ROWCOUNT = 0       
			BEGIN                        
				SET  @ErrorCode = -101008                                      
				SET  @Message   = 'ERROR GETTING DP DETAILS'                                      
				GOTO ERROR                                           
			END      


	/* NOW GENERATE FORM NUMBER */

	IF @IM_APPNO_LENGTH = 0 
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END
	IF ((LEN(LTRIM(RTRIM(@IM_APPNO_PREFIX))) + LEN(LTRIM(RTRIM(@IM_APPNO_SUFFIX))))) > @IM_APPNO_LENGTH
	BEGIN
			SET  @ErrorCode = -1010009                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID DUE TO LENGTH'                                      
			GOTO ERROR   
	END

	DECLARE @MAXAPPID VARCHAR(100)
	DECLARE @MAXNEWID INT

	SET @MAXAPPID= ''
	SET @MAXNEWID = 0

	SELECT 
		@MAXAPPID = ISNULL(MAX(IT_APPNO),'') 
	FROM 
		IPO_TRANSACTIONS_MAK (NOLOCK)
	WHERE 
		IT_IM_ID = @p_IT_IM_ID

	


		                                   
	IF @MAXAPPID = ''    
	BEGIN                        
		SET  @MAXNEWID = @IM_APPNO_START                                
	END      
	ELSE
	BEGIN
		SET @MAXAPPID = REPLACE(REPLACE(LTRIM(RTRIM(@MAXAPPID)),@IM_APPNO_PREFIX,''),@IM_APPNO_SUFFIX,'')
		SET  @MAXNEWID = CAST(@MAXAPPID AS INT) + 1
	END

	
	SET @MAXAPPID = CAST(@MAXNEWID AS VARCHAR)

	IF @MAXNEWID > @IM_APPNO_END
	BEGIN
			SET  @ErrorCode = -1010010                                      
			SET  @Message   = 'CANNOT GENERATE NEW FORM ID. GREATER THAN END ID'                                      
			GOTO ERROR   
	END

	WHILE (LEN(ISNULL(@IM_APPNO_PREFIX,'')) + LEN(ISNULL(@IM_APPNO_SUFFIX,''))+LEN(@MAXAPPID)) < @IM_APPNO_LENGTH
	BEGIN
	   SET @MAXAPPID = '0' + @MAXAPPID
	END
	

	SET @IT_APPNO = ISNULL(@IM_APPNO_PREFIX,'') + @MAXAPPID + ISNULL(@IM_APPNO_SUFFIX,'')

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010011                                      
			SET  @Message   = 'ERROR GENERATING NEW FORM ID'                                      
			GOTO ERROR                                    
		END 

	/* NOW INSERT INTO IPO TRANSACTIONS */

 --   IF @ERRORCODE <> 0 
	--BEGIN
	--	SET @MESSAGE = 'UNKNOW ERROR - ' + CAST(@ERRORCODE AS VARCHAR)
	--	GOTO ERROR
	--END       

    INSERT
    INTO [dbo].[IPO_TRANSACTIONS_MAK]
        (
            [IT_IM_ID],
            [IT_CM_ID],
            [IT_USER_TYPE],
            [IT_USER_STATUS],
            [IT_POA],
            [IT_APPNAME1],
            [IT_APPNAME2],
            [IT_APPNAME3],
            [IT_DOB1],
            [IT_DOB2],
            [IT_DOB3],
            [IT_GENDER1],
            [IT_GENDER2],
            [IT_GENDER3],
            [IT_FATHERHUSBAND],
            [IT_PAN1],
            [IT_PAN2],
            [IT_PAN3],
            [IT_CIRCLE1],
            [IT_CIRCLE2],
            [IT_CIRCLE3],
            [IT_MAPINFLAG],
            [IT_MAPIN],
            [IT_CATEGORY],
            [IT_BM_ID],
            [IT_SBM_ID],
            [IT_NOMINEE],
            [IT_NOMINEE_RELATION],
            [IT_GUARDIANPAN],
            [IT_DEPOSITORY],
            [IT_DPID],
            [IT_DPNAME],
            [IT_CLIENTDPID],
            [IT_BID_QTY1],
            [IT_BID_PRICE1],
            [IT_BID_QTY2],
            [IT_BID_PRICE2],
            [IT_BID_QTY3],
            [IT_BID_PRICE3],
            [IT_CUT_OFF1],
            [IT_CUT_OFF2],
            [IT_CUT_OFF3],
            [IT_PARTIAL_FLAG],
            [IT_PARTIAL_AMT],
            [IT_APPLIED_VALUE],
            [IT_APPNO],
            [IT_ORDER_TYPE],
            [IT_ORDER_STATUS],
            [IT_APP_PRINT_FLAG],
            [IT_STATUS],
            [IT_STATUS_MSG],
            [IT_FINAL_STATUS],
            [IT_MODIFIEDBY],
            [IT_MODIFIEDDT],[IT_DELETED_IND]
        )
	SELECT
		    @p_IT_IM_ID,
			CM_ID,
			CM_USER_TYPE,
			CM_USER_STATUS,
			CM_POA,
			CM_APPNAME1,
			CM_APPNAME2,
			CM_APPNAME3,
			CM_DOB1,
			CM_DOB2,
			CM_DOB3,
			CM_GENDER1,
			CM_GENDER2,
			CM_GENDER3,
			CM_FATHERHUSBAND,
			CM_PAN1,
			CM_PAN2,
			CM_PAN3,
			CM_CIRCLE1,
			CM_CIRCLE2,
			CM_CIRCLE3,
			CM_MAPINFLAG,
			CM_MAPIN,
			CM_CATEGORY,
			CM_BM_ID,
			CM_SBM_ID,
			CM_NOMINEE,
			CM_NOMINEE_RELATION,
			CM_GUARDIANPAN,
            @IT_DEPOSITORY,
            @IT_DPID,
            @IT_DPNAME,
            @IT_CLIENTDPID,
            @p_BID_QTY,
            @NUMISSPRICE,
			@p_BID_QTY2,
			@p_BID_PRICE2,
			@p_BID_QTY3,
			@p_BID_PRICE3,
            @p_CUT_OFF,
            @p_CUT_OFF2,
            @p_CUT_OFF3,
            @IM_PARTIAL_FLAG,
            @IM_PARTIAL_AMT,
            @CALCAMOUNT,
            @IT_APPNO,
            'FRESH ORDER',
            'ORDERED',
            0,
            'ORDERED',
            'ORDER ENTERED SUCCESSFULLY',
            'ORDERED',
            @p_IT_MODIFIEDBY,
            GETDATE(),0
	FROM
		CLIENT_MASTER
	WHERE 
		[CM_ID] = @p_IT_CL_ID

		IF @@ERROR <> 0       
		BEGIN                        
			SET  @ErrorCode = -1010012                                      
			SET  @Message   = 'ERROR IN INSERTING TO TRANSACTION LOG'                                      
			GOTO ERROR                                    
		END      
		ELSE
		BEGIN
			SET  @ErrorCode = 0                                   
			GOTO ERROR 
		END	

 ERROR:    
    
 IF @ErrorCode = 0    
 BEGIN    
  COMMIT TRANSACTION    
  SET @ErrorCode = 0    
  SET @Message = 'ORDER PLACED SUCCESSFULLY SUCCESSFULLY.  APPLICATION NO - ' + LTRIM(RTRIM(@IT_APPNO)) 
  RETURN 
END    
 ELSE    
 BEGIN    
  ROLLBACK TRANSACTION    
  EXEC IPO_LOG_ERRORS @ErrorCode, @Message, 'IPO_IPO_TRANSACTIONS_MAK_ADD', @p_IP_ADD, @p_IT_MODIFIEDBY  
	RETURN
 END    
  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_LOG_ERRORS
-- --------------------------------------------------
CREATE Procedure [dbo].[IPO_LOG_ERRORS]    
(                                              
 @RETCODE Varchar (100),                                              
 @RETMSG  varchar(1000),                         
 @RETSOURCE Varchar (20)  ,  
 @RETIPADD VARCHAR(20),
 @UM_ID BIGINT                            
)                                              
AS            
BEGIN          
 INSERT INTO ERROR_LOG (EL_RETCODE,EL_RETMSG,EL_DETAILS,EL_IP_ADD, EL_ADDDT, EL_UM_ID)                   
VALUES   
(@RETCODE,@RETMSG,@RETSOURCE,@RETIPADD,GETDATE(), @UM_ID)          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_NAME_FETCH
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[IPO_NAME_FETCH]      
(      
 @ErrorCode  INT OUTPUT,              
 @Message  VARCHAR(200) OUTPUT      
)      
AS      

SELECT 
	IM_ID, IM_IPO_NAME   
FROM
	IPO_MASTER (NOLOCK)
WHERE 
	GETDATE() BETWEEN IM_OPEN_DATE AND IM_CLOSE_DATE

IF @@ERROR <> 0
BEGIN
	SET @ErrorCode = -2000000
    SET @Message='ERROR FETCHING IPO NAMES'
	RETURN
END
ELSE
BEGIN
	SET @ErrorCode = 0
    SET @Message='SUCCESSFULLY FETCHED IPO NAMES'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_USER_MASTER_ADD
-- --------------------------------------------------

-- Creates a new record in the [dbo].[USER_MASTER] table.  
CREATE PROCEDURE [dbo].[IPO_USER_MASTER_ADD]  
    @p_UM_CODE varchar(50),  
    @p_UM_PWD varchar(50),  
    @p_UM_NAME varchar(100),  
    @p_UM_ADD1 varchar(100),  
    @p_UM_ADD2 varchar(100),  
    @p_UM_ADD3 varchar(100),  
    @p_UM_CITY varchar(64),  
    @p_UM_STATE varchar(64),  
    @p_UM_COUNTRY varchar(64),  
    @p_UM_PINCODE varchar(10),  
    @p_UM_OFFICE_CONTACT varchar(15),  
    @p_UM_RESI_CONTACT varchar(15),  
    @p_UM_FAX varchar(15),  
    @p_UM_EMAILID varchar(50),  
    @p_UM_OCCUPATION varchar(50),  
    @p_UM_TAX_STATUS varchar(50),  
    @p_UM_ANNUALINCOME numeric(24,2),  
    @p_UM_MAXTRY smallint,  
    @p_UM_RETRIES smallint,  
    @p_UM_MODIFIEDBY bigint,  
	@p_UM_ACCESS_LVL varchar(1),  
	@p_UM_IP_ADD varchar(2000),  
	@p_IP_ADD varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  
AS  
BEGIN  
  
  
DECLARE @UM_ID BIGINT  
    
SET @UM_ID = 0      
SET @ErrorCode      = 0    
  
IF NOT EXISTS(SELECT UM_CODE FROM USER_MASTER WHERE UM_CODE = @p_UM_CODE)                
 BEGIN    
       BEGIN TRANSACTION    
    
  
    INSERT  
    INTO [dbo].[USER_MASTER]  
     (  
      [UM_CODE],  
      [UM_PWD],  
      [UM_USER_TYPE],  
      [UM_NAME],  
      [UM_ADD1],  
      [UM_ADD2],  
      [UM_ADD3],  
      [UM_CITY],  
      [UM_STATE],  
      [UM_COUNTRY],  
      [UM_PINCODE],  
      [UM_OFFICE_CONTACT],  
      [UM_RESI_CONTACT],  
      [UM_FAX],  
      [UM_EMAILID],  
      [UM_OCCUPATION],  
      [UM_TAX_STATUS],  
      [UM_ANNUALINCOME],  
      [UM_MAXTRY],  
      [UM_RETRIES],  
      [UM_MODIFIEDBY],  
      [UM_MODIFIEDDT],     
      [UM_ACCESS_LVL],  
      [UM_IP_ADD],  
      [UM_SESSION],  
      [UM_FIRST_LOGIN],  
      [UM_PASSWORD_EXPIRY]             
     )  
    VALUES  
     (  
       @p_UM_CODE,  
       @p_UM_PWD,  
       1,  
       @p_UM_NAME,  
       @p_UM_ADD1,  
       @p_UM_ADD2,  
       @p_UM_ADD3,  
       @p_UM_CITY,  
       @p_UM_STATE,  
       @p_UM_COUNTRY,  
       @p_UM_PINCODE,  
       @p_UM_OFFICE_CONTACT,  
       @p_UM_RESI_CONTACT,  
       @p_UM_FAX,  
       @p_UM_EMAILID,  
       @p_UM_OCCUPATION,  
       @p_UM_TAX_STATUS,  
       @p_UM_ANNUALINCOME,  
       @p_UM_MAXTRY,  
       @p_UM_RETRIES,  
       @p_UM_MODIFIEDBY,  
       GETDATE(),  
       @p_UM_ACCESS_LVL,  
       @p_UM_IP_ADD,  
       '',  
       'Y',  
       GETDATE()+15  
     )  
  
  SET @UM_ID = SCOPE_IDENTITY()    
  
  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR INSERTING INTO USER MASTER - ' + @p_UM_CODE
   GOTO ERROR    
  END    
 /*  
    INSERT INTO CLIENT_CASH_BALANCE    
    (CCB_CM_ID, CCB_AVAILABLE_LIMIT, CCB_USED_LIMIT)    
    VALUES    
    (@UM_ID, 1000000000, 0)    
     
  
  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'Error while inserting details to  client Cash master'    
   GOTO ERROR    
  END    
 */   
  
 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000067                
  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_USER_MASTER_ADD',@p_IP_ADD, @p_UM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message        = 'USER REGISTERED SUCCESSFULLY.'  
 END    
  
END    
ELSE      
BEGIN  
 SET @Message   = 'USER ID ALREAD EXISTS. PLEASE SELECT ANOTHER USER ID'      
END  
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_USER_MASTER_EDIT
-- --------------------------------------------------
-- Creates a new record in the [dbo].[USER_MASTER] table.  
CREATE PROCEDURE [dbo].[IPO_USER_MASTER_EDIT]  
	@p_UM_CODE varchar(50),  
	@p_UM_PWD varchar(50),  
    @p_UM_ADD1 varchar(100),  
    @p_UM_ADD2 varchar(100),  
    @p_UM_ADD3 varchar(100),  
    @p_UM_CITY varchar(64),  
    @p_UM_STATE varchar(64),  
    @p_UM_COUNTRY varchar(64),  
    @p_UM_PINCODE varchar(10),  
    @p_UM_OFFICE_CONTACT varchar(15),  
    @p_UM_RESI_CONTACT varchar(15),  
    @p_UM_FAX varchar(15),  
    @p_UM_EMAILID varchar(50),   
	@p_UM_MAXTRY smallint,  
	@p_UM_RETRIES smallint,  
	@p_UM_MODIFIEDBY bigint,  
	@p_UM_ACCESS_LVL varchar(1),  
	@p_UM_IP_ADD varchar(2000),  
	@p_IP_ADD varchar(20),  
	@ErrorCode int output,  
	@Message varchar(200) output  
AS  

BEGIN  
  
  
DECLARE @UM_ID BIGINT  
    
SET @UM_ID = 0      
SET @ErrorCode      = 0    
  

       BEGIN TRANSACTION    
    
	INSERT INTO USER_MASTER_JRNL
	SELECT 
		*, @p_UM_MODIFIEDBY, GETDATE() 
	FROM 
		[dbo].[USER_MASTER]  
	WHERE 
		UM_CODE = @p_UM_CODE
  
    UPDATE [dbo].[USER_MASTER]  
	SET
      [UM_PWD] =  @p_UM_PWD, 
      [UM_ADD1] = @p_UM_ADD1, 
      [UM_ADD2] = @p_UM_ADD2,  
      [UM_ADD3] = @p_UM_ADD3, 
      [UM_CITY] = @p_UM_CITY,
      [UM_STATE] = @p_UM_STATE,  
      [UM_COUNTRY] = @p_UM_COUNTRY,  
      [UM_PINCODE] = @p_UM_PINCODE,  
      [UM_OFFICE_CONTACT] = @p_UM_OFFICE_CONTACT,  
      [UM_RESI_CONTACT] = @p_UM_RESI_CONTACT,  
      [UM_FAX] = @p_UM_FAX,  
      [UM_EMAILID] = @p_UM_EMAILID,  
      [UM_MAXTRY] = @p_UM_MAXTRY,  
      [UM_RETRIES] = @p_UM_RETRIES,  
      [UM_MODIFIEDBY] = @p_UM_MODIFIEDBY,  
      [UM_MODIFIEDDT] = GETDATE(),     
      [UM_ACCESS_LVL] = @p_UM_ACCESS_LVL,  
      [UM_IP_ADD]  = @p_UM_IP_ADD,  
      [UM_FIRST_LOGIN] = 'Y',  
      [UM_PASSWORD_EXPIRY] = GETDATE()+15    
	WHERE            
		UM_CODE = @p_UM_CODE

  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'ERROR UPDATING USER MASTER FOR USER CODE -' + @p_UM_CODE    
   GOTO ERROR    
  END    
 /*  
    INSERT INTO CLIENT_CASH_BALANCE    
    (CCB_CM_ID, CCB_AVAILABLE_LIMIT, CCB_USED_LIMIT)    
    VALUES    
    (@UM_ID, 1000000000, 0)    
     
  
  IF @@ERROR <> 0     
  BEGIN     
   SET  @ErrorCode = 1    
   SET  @Message   = 'Error while inserting details to  client Cash master'    
   GOTO ERROR    
  END    
 */   
  
 ERROR:    
    
 IF @ErrorCode = 1    
 BEGIN    
  ROLLBACK TRANSACTION    
  SET  @ErrorCode = -1000067                
  EXEC IPO_LOG_ERRORS @ErrorCode,@Message,'IPO_USER_MASTER_EDIT',@p_IP_ADD, @p_UM_MODIFIEDBY  
 END    
 ELSE    
 BEGIN    
  COMMIT TRANSACTION    
  SET @Message        = 'USER UPDATED SUCCESSFULLY.'  
 END    
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_VALIDATE_USER
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[IPO_VALIDATE_USER]
(
	@USERID VARCHAR(50),
	@PASSWORD VARCHAR(50),
	@IPADDRESS VARCHAR(20),
	@RETCODE INT OUTPUT,
	@RETMSG VARCHAR(200) OUTPUT,
	@UM_ID BIGINT OUTPUT,
	@UM_USER_TYPE TINYINT OUTPUT,
	@UM_NAME VARCHAR(100) OUTPUT,
	@CM_USER_TYPE VARCHAR(3) OUTPUT,
	@CM_POA TINYINT OUTPUT,
	@CM_ID BIGINT OUTPUT,
	@UM_SESSION UNIQUEIDENTIFIER OUTPUT
)
AS

DECLARE @@UM_ID BIGINT
DECLARE @@UM_USER_TYPE TINYINT
DECLARE @@UM_NAME VARCHAR(100)
DECLARE @@UM_SESSION VARCHAR(200)
DECLARE @@UM_MAXTRY SMALLINT
DECLARE @@UM_RETRIES SMALLINT
DECLARE @@UM_ACCESS_LVL VARCHAR(1)
DECLARE @@UM_IP_ADD VARCHAR(2000)
DECLARE @@UM_FIRST_LOGIN VARCHAR(1)
DECLARE @@EXPIRYDATEDIFF BIGINT
DECLARE @@USER_COUNT TINYINT
DECLARE @@CM_USER_TYPE VARCHAR(3)
DECLARE @@CM_POA TINYINT
DECLARE @@CM_ID BIGINT


SET @@CM_USER_TYPE = ''
SET @@CM_POA = 0
SET @@CM_ID = 0


SELECT 
	@@USER_COUNT = COUNT(1) 
FROM 
	USER_MASTER (NOLOCK)
WHERE
	UM_CODE = @USERID

IF ISNULL(@@USER_COUNT,0) = 0
BEGIN
	SET @RETCODE =  1000001
	SET @RETMSG = 'INVALID USERNAME / PASSWORD'
	RETURN
END

SELECT 
	@@UM_ID = UM_ID,
	@@UM_USER_TYPE = UM_USER_TYPE,
	@@UM_NAME = UM_NAME,
	@@UM_SESSION = NEWID(),
	@@UM_MAXTRY = UM_MAXTRY,
	@@UM_RETRIES = UM_RETRIES,
	@@UM_ACCESS_LVL = UM_ACCESS_LVL,
	@@UM_IP_ADD = UM_IP_ADD,
	@@UM_FIRST_LOGIN = UM_FIRST_LOGIN,
	@@EXPIRYDATEDIFF = CAST(DATEDIFF(D,GETDATE(),UM_PASSWORD_EXPIRY) AS BIGINT)
FROM
	USER_MASTER (NOLOCK)
WHERE
	UM_CODE = @USERID
	AND UM_PWD = @PASSWORD

IF ISNULL(@@UM_ID,0) = 0
BEGIN
	SET @RETCODE =  1000002
	SET @RETMSG = 'INVALID USERNAME / PASSWORD'
	EXEC IPO_LOG_ERRORS @RETCODE, @RETMSG, 'VALIDATE_USER', @IPADDRESS, @@UM_ID
	RETURN
END

IF ISNULL(@@UM_MAXTRY,0) - ISNULL(@@UM_RETRIES,0) <= 0
BEGIN
	SET @RETCODE = 1000012
	SET @RETMSG = 'USER ID IS DISABLED'
	EXEC IPO_LOG_ERRORS @RETCODE, @RETMSG, 'VALIDATE_USER', @IPADDRESS, @@UM_ID
	RETURN
END 

IF ISNULL(@@UM_ACCESS_LVL,'L') = 'L'
BEGIN
		DECLARE @@IPCOUNT INT
		DECLARE @@IPVAL VARCHAR(20)
		DECLARE @@IPPART AS CURSOR
		SET @@IPCOUNT = 0
		
		SET @@IPPART = CURSOR FOR 
			SELECT   
				DISTINCT DETAILS
			FROM 
				IPO_FN_SPLITSTRINGS(@@UM_IP_ADD,'|','')

		OPEN @@IPPART

		FETCH NEXT FROM @@IPPART
		INTO @@IPVAL

		WHILE @@FETCH_STATUS = 0
		BEGIN

				IF @@IPCOUNT = 0
				BEGIN
					SELECT 
							@@IPCOUNT = COUNT(1) 
					FROM
						IPO_FN_SPLITSTRINGS(@@IPVAL,'.','') A
						LEFT OUTER JOIN
							IPO_FN_SPLITSTRINGS(@IPADDRESS,'.','') B
						ON (A.ITEM = B.ITEM)
					WHERE
						ISNULL(B.ITEM,0) <> 0
				END
		      
		FETCH NEXT FROM @@IPPART
		INTO @@IPVAL
		END
		CLOSE @@IPPART
		DEALLOCATE @@IPPART

		IF @@IPCOUNT = 0
		BEGIN
			SET @RETCODE = 1000013
			SET @RETMSG = 'YOU ARE NOT ALLOWED TO LOGIN (IP RESTRICTION)'
			EXEC IPO_LOG_ERRORS @RETCODE, @RETMSG, 'VALIDATE_USER', @IPADDRESS, @@UM_ID
			RETURN
		END
END
	
IF @@UM_USER_TYPE = 1
BEGIN
	SELECT 
		@@CM_USER_TYPE = CM_USER_TYPE,
		@@CM_POA = CM_POA,
		@@CM_ID = CM_ID
	FROM
		CLIENT_MASTER (NOLOCK)
	WHERE
		CM_UM_ID = @@UM_ID

	IF ISNULL(@@CM_USER_TYPE,'') = ''
	BEGIN
		SET @RETCODE = 1000014
		SET @RETMSG = 'CLIENT MASTER DETAILS NOT AVAILABLE'
		EXEC IPO_LOG_ERRORS @RETCODE, @RETMSG, 'VALIDATE_USER', @IPADDRESS, @@UM_ID
		RETURN		
	END
	
	IF ISNULL(@@CM_POA,0) = 0
	BEGIN
		SET @@CM_POA = 0
		SET @@CM_USER_TYPE = ISNULL(@@CM_USER_TYPE,'')	
		SET @@CM_ID = ISNULL(@@CM_ID,0)
	END
END

IF @@UM_FIRST_LOGIN = 'Y' OR @@EXPIRYDATEDIFF < 0
BEGIN
	SET @UM_ID = @@UM_ID
	SET @RETCODE = 0
	SET @RETMSG = 'KINDLY CHANGE YOUR PASSWORD'
	RETURN
END

UPDATE 
	USER_MASTER
SET 
	UM_RETRIES = 0,
	UM_SESSION = @@UM_SESSION
WHERE 
	UM_ID = @@UM_ID


INSERT INTO LOGIN_LOG (LL_UM_ID, LL_UM_USER_TYPE, LL_IP_ADD, LL_ACTION, LL_ADDDT) 
VALUES
(@@UM_ID, @@UM_USER_TYPE, @IPADDRESS, 'LOGIN', GETDATE())

SET @RETCODE = 1
SET @RETMSG = 'USER ' + @@UM_NAME + ' LOGGED IN SUCCESSFULLY'
SET @UM_ID = @@UM_ID
SET @UM_USER_TYPE = @@UM_USER_TYPE
SET @UM_NAME = @@UM_NAME
SET @UM_SESSION = @@UM_SESSION
SET @CM_USER_TYPE = @@CM_USER_TYPE
SET @CM_POA = @@CM_POA
SET @CM_ID = @@CM_ID

RETURN

GO

-- --------------------------------------------------
-- PROCEDURE dbo.IPO_VoucherEntry
-- --------------------------------------------------
CREATE proc [dbo].[IPO_VoucherEntry](
 @pa_action varchar(100)
,@pa_ipo_no numeric
,@pa_voucher_no numeric
,@pa_voucher_dt datetime
,@pa_voucher_type INT
,@pa_client_id varchar(16)
,@pa_bank_name varchar(250)
,@pa_bank_acno varchar(250)
,@pa_c_d_flg char(1)
,@pa_amt numeric(18,3)
,@pa_chq_no varchar(16)
,@pa_narration varchar(100)
,@pa_gl_code varchar(100)
,@pa_rmks varchar(250)
,@pa_login_name  varchar(100)
,@pa_interest_amt numeric(18,2)
,@pa_ref_no varchar(100)
,@pa_LDG_FROM_DT datetime
,@pa_LDG_TO_DT datetime
,@pa_LDG_INST_TYPE  varchar(100)
,@pa_out varchar(1000) out
)
as
begin

 
declare @l_voucher_no numeric
declare @l_vch_no numeric(18,0)

select @l_voucher_no = max(isnull(LDG_VOUCHER_NO,0))+1 
from ledger

if @pa_action  ='ADD'
begin
 
 set @pa_voucher_no =  @l_voucher_no 
 set @pa_voucher_no = isnull(@pa_voucher_no,1)
 insert into ledger(LDG_VOUCHER_TYPE
	,LDG_VOUCHER_NO	,LDG_IPO_NO	,LDG_VOUCHER_DT	,LDG_ACCOUNT_ID	,LDG_ACCOUNT_TYPE
	,LDG_GL_CODE	,LDG_AMOUNT	,LDG_NARRATION	,LDG_BANK_NAME	,LDG_ACCOUNT_NO
	,LDG_INSTRUMENT_NO	,LDG_BANK_CL_DATE	,LDG_STATUS	,LDG_BRANCH_ID	,LDG_REMARKS
	,LDG_CREATED_BY	,LDG_CREATED_DT	,LDG_LST_UPD_BY	,LDG_LST_UPD_DT	,LDG_DELETED_IND,LDG_FROM_DT
,LDG_TO_DT
,LDG_INST_TYPE)
 select @pa_voucher_type,@pa_voucher_no,@pa_ipo_no,@pa_voucher_dt,@pa_client_id,'P'
  ,@pa_gl_code,case when @pa_voucher_type ='1' then  @pa_amt* -1 
  when @pa_voucher_type ='2' then @pa_amt 
  when @pa_voucher_type ='3' and @pa_c_d_flg ='C' then @pa_amt 
  when @pa_voucher_type ='3' and @pa_c_d_flg ='D' then @pa_amt*-1 
  else @pa_amt end  ,@pa_narration,@pa_bank_name,@pa_bank_acno
  ,@pa_chq_no,null,@pa_ref_no,null,@pa_rmks
  ,@pa_login_name , getdate(),@pa_login_name ,getdate(),1
  ,@pa_voucher_dt 
  ,@pa_LDG_TO_DT
,@pa_LDG_INST_TYPE  

  
  
  
  
  if @pa_interest_amt <> 0 
  begin 
    exec [IPO_VoucherEntry] 'ADD',@pa_ipo_no,0,@pa_voucher_dt,2,@pa_client_id,'','','',@pa_interest_amt,'','AUTO CREDIT INTEREST TO CLIENT'
    ,@pa_gl_code
  ,'','AUTO',0,@l_voucher_no,'',@pa_voucher_dt 
  ,@pa_LDG_TO_DT
,@pa_LDG_INST_TYPE  

exec [IPO_VoucherEntry] 'ADD',@pa_ipo_no,0,@pa_voucher_dt,3,@pa_client_id,'','','D',@pa_interest_amt,'','Provision interest collected'
    ,@pa_gl_code
  ,'','AUTO',0,@l_voucher_no,'',@pa_voucher_dt 
  ,@pa_LDG_TO_DT
,@pa_LDG_INST_TYPE  

end 


  
	end 
	if @pa_action  ='EDIT'
	begin 

update ledger 
set LDG_IPO_NO = @pa_ipo_no
,LDG_VOUCHER_DT=@pa_voucher_dt
,LDG_ACCOUNT_ID=@pa_client_id
,LDG_GL_CODE=@pa_gl_code
,LDG_AMOUNT=case when @pa_voucher_type ='1' then  @pa_amt* -1 
  when @pa_voucher_type ='2' then @pa_amt 
  when @pa_voucher_type ='3' and @pa_c_d_flg ='C' then @pa_amt 
  when @pa_voucher_type ='3' and @pa_c_d_flg ='D' then @pa_amt*-1 
  else @pa_amt end 
,LDG_NARRATION=@pa_narration
,LDG_BANK_NAME=@pa_bank_name
,LDG_ACCOUNT_NO=@pa_bank_acno
,LDG_INSTRUMENT_NO=@pa_chq_no
,LDG_REMARKS=@pa_rmks
,ldg_lst_upd_dt = getdate()
,ldg_lst_upd_by = @pa_login_name 
,LDG_FROM_DT =@pa_LDG_FROM_DT 
,LDG_TO_DT=@pa_LDG_TO_DT
,LDG_INST_TYPE  = @pa_LDG_INST_TYPE  
where ldg_voucher_no = @pa_voucher_no
and ldg_deLeted_ind = 1

if @pa_interest_amt <> 0 
begin 

select @l_vch_no  = ldg_voucher_no from ledger where LDG_STATUS = CONVERT(VARCHAR,@pa_voucher_no)

exec [IPO_VoucherEntry] 'EDIT',@pa_ipo_no,@l_vch_no  ,@pa_voucher_dt,2,@pa_client_id,'','',''
,@pa_interest_amt,'','AUTO CREDIT INTEREST TO CLIENT',@pa_gl_code
  ,'','AUTO',0,'','',@pa_voucher_dt,@pa_LDG_TO_DT,@pa_LDG_INST_TYPE
  
  exec [IPO_VoucherEntry] 'EDIT',@pa_ipo_no,@l_vch_no  ,@pa_voucher_dt,3,@pa_client_id,'','','D'
,@pa_interest_amt,'','Provision interest collected',@pa_gl_code
  ,'','AUTO',0,'','',@pa_voucher_dt,@pa_LDG_TO_DT,@pa_LDG_INST_TYPE
  

end 

end 
if @pa_action  ='DELETE'
begin 


if @pa_voucher_no <> 0 
begin 
select @l_vch_no  = ldg_voucher_no from ledger where LDG_STATUS = CONVERT(VARCHAR,@pa_voucher_no)

exec [IPO_VoucherEntry] 'DELETE',@pa_ipo_no,@l_vch_no  ,@pa_voucher_dt,2,@pa_client_id,'','',''
,@pa_interest_amt,'','AUTO CREDIT INTEREST TO CLIENT',@pa_gl_code
    ,'','AUTO',0,'','',@pa_voucher_dt,@pa_LDG_TO_DT,@pa_LDG_INST_TYPE

exec [IPO_VoucherEntry] 'DELETE',@pa_ipo_no,@l_vch_no  ,@pa_voucher_dt,3,@pa_client_id,'','','D'
,@pa_interest_amt,'','Provision interest collected',@pa_gl_code
    ,'','AUTO',0,'','',@pa_voucher_dt,@pa_LDG_TO_DT,@pa_LDG_INST_TYPE



end

update ledger 
set ldg_lst_upd_dt = getdate()
,ldg_lst_upd_by = @pa_login_name 
,ldg_deLeted_ind = 0 
where ldg_voucher_no = @pa_voucher_no
and ldg_deLeted_ind = 1 





end 
if @pa_action  ='SEARCH'
begin
PRINT '23'
select  ADDFLAG = (CASE WHEN ISNULL(LDG_VOUCHER_NO,0) = 0 THEN 'ADD' ELSE 'EDIT' END),(SELECT  CM_APPNAME1 +' - '+ CONVERT(varchar,CM_UM_ID)    
FROM CLIENT_MASTER WHERE CM_UM_ID= LDG_ACCOUNT_ID ) NAME
,LDG_ID
,LDG_VOUCHER_TYPE
,LDG_VOUCHER_NO
,LDG_IPO_NO
,LDG_VOUCHER_DT
,LDG_ACCOUNT_ID
,LDG_ACCOUNT_TYPE
,LDG_GL_CODE
,abs(LDG_AMOUNT) LDG_AMOUNT
,LDG_NARRATION
,LDG_BANK_NAME
,LDG_ACCOUNT_NO
,LDG_INSTRUMENT_NO
,LDG_BANK_CL_DATE
,LDG_STATUS
,LDG_BRANCH_ID
,LDG_REMARKS
,LDG_CREATED_BY
,LDG_CREATED_DT
,LDG_LST_UPD_BY
,LDG_LST_UPD_DT
,LDG_DELETED_IND
,LDG_FROM_DT
,LDG_TO_DT
,LDG_INST_TYPE 
,isnull((select abs(ldg_amount) from ledger b where a.ldg_account_id = b.ldg_account_id   
and a.ldg_voucher_dt = b.ldg_voucher_dt  and a.ldg_voucher_type = b.ldg_voucher_type  and CONVERT(VARCHAR,a.ldg_voucher_no) = isnull(b.ldg_status ,'0')   
)  ,0) interestamt  
,case when LDG_AMOUNT < 0 then 'D' else 'C' end crdrflg
FROM LEDGER a 
WHERE 
CASE WHEN @pa_voucher_no <>'0'  THEN  LDG_VOUCHER_NO ELSE '0' END = CASE WHEN @pa_voucher_no <>'0'  THEN @pa_voucher_no ELSE '0' END AND 
CASE WHEN @pa_client_id <>''  THEN LDG_ACCOUNT_ID ELSE '' END = CASE WHEN @pa_client_id <>''  THEN @pa_client_id ELSE '' END 
AND CASE WHEN @pa_voucher_dt <>''  THEN LDG_VOUCHER_DT ELSE '' END = CASE WHEN @pa_voucher_dt <>''  THEN @pa_voucher_dt ELSE '' END 
AND CASE WHEN @pa_gl_code <>''  THEN LDG_GL_CODE ELSE '' END = CASE WHEN @pa_gl_code <>''  THEN @pa_gl_code ELSE '' END 
AND LDG_DELETED_IND = 1 
and ldg_voucher_type <>'1'

PRINT '34'
end 

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_app_ipo_clt_mapping
-- --------------------------------------------------
CREATE proc [dbo].[pr_app_ipo_clt_mapping](@p_IT_IM_ID numeric,@p_IT_CL_ID numeric,@pa_action varchar(100))  
as  
begin   
  
if  @pa_action ='APP'  
begin 


  
insert into [IPO_TRANSACTIONS]   
select IT_IM_ID,IT_CM_ID,IT_USER_TYPE,IT_USER_STATUS,IT_POA  
,IT_APPNAME1,IT_APPNAME2,IT_APPNAME3,IT_DOB1,IT_DOB2,IT_DOB3  
,IT_GENDER1,IT_GENDER2,IT_GENDER3,IT_FATHERHUSBAND,IT_PAN1,IT_PAN2  
,IT_PAN3,IT_CIRCLE1,IT_CIRCLE2,IT_CIRCLE3,IT_MAPINFLAG,IT_MAPIN  
,IT_CATEGORY,IT_BM_ID,IT_SBM_ID,IT_NOMINEE,IT_NOMINEE_RELATION,IT_GUARDIANPAN,IT_DEPOSITORY  
,IT_DPID,IT_DPNAME,IT_CLIENTDPID,IT_BID_QTY1,IT_BID_PRICE1,IT_BID_QTY2,IT_BID_PRICE2,IT_BID_QTY3  
,IT_BID_PRICE3,IT_CUT_OFF1,IT_CUT_OFF2,IT_CUT_OFF3,IT_PARTIAL_FLAG,IT_PARTIAL_AMT,IT_APPNO,IT_EXCHANGE_REFNO  
,IT_RTA_REFNO,IT_ORDER_TYPE,IT_ORDER_STATUS,IT_APP_PRINT_FLAG,IT_STATUS,IT_STATUS_MSG,IT_APPLIED_VALUE,IT_ACCEPT_QTY  
,IT_ACCEPT_PRICE,IT_ACCEPT_DATE,IT_FINAL_STATUS,IT_MODIFIEDBY,IT_MODIFIEDDT,IT_UPDATEBY,IT_UPDATEDT   
from [IPO_TRANSACTIONS_MAK]  
where IT_DELETED_IND = 0  
AND IT_IM_ID = @p_IT_IM_ID  
AND IT_CM_ID = @p_IT_CL_ID  
  
  
update [IPO_TRANSACTIONS_MAK] set IT_DELETED_IND = 1  
where IT_DELETED_IND = 0  
AND IT_IM_ID = @p_IT_IM_ID  
AND IT_CM_ID = @p_IT_CL_ID  

declare @l_gl_code varchar(100)
select @l_gl_code = im_gl_code from ipo_master where  IM_ID = @p_IT_IM_ID 

declare @l_client_id varchar(16)
,@l_amt numeric(18,3)

select @l_client_id  = IT_DPID + IT_CLIENTDPID 
,@l_amt  = IT_APPLIED_VALUE 
from [IPO_TRANSACTIONS]  
where  IT_IM_ID = @p_IT_IM_ID  
AND IT_CM_ID = @p_IT_CL_ID  
  
DECLARE @L_DT VARCHAR(11)
SELECT @L_DT  = convert(varchar(11),getdate(),109)  

exec [IPO_VoucherEntry] 'ADD',@p_IT_IM_ID,0,@L_DT,1,@l_client_id,'','','',@l_amt,'','AUTO DEBIT TO CLIENT',@l_gl_code,'','AUTO',0,'','','','',''

  
  
end   
if  @pa_action ='REJ'  
begin   
  
  
update [IPO_TRANSACTIONS_MAK] set IT_DELETED_IND = 9  
 where IT_DELETED_IND = 0  
 AND IT_IM_ID = @p_IT_IM_ID  
 AND IT_CM_ID = @p_IT_CL_ID  
  
  
end   
  
  
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_client_ipo_trx_checker
-- --------------------------------------------------
CREATE procedure [dbo].[pr_client_ipo_trx_checker]
@pa_IM_ID bigint
as 
begin
	SELECT IT_USER_TYPE,IT_APPNAME1,IT_PAN1,IT_BID_QTY1,IT_BID_PRICE1,IT_APPLIED_VALUE 
	FROM IPO_TRANSACTIONS_MAK		
	WHERE IT_IM_ID = @PA_IM_ID AND IT_DELETED_IND = 0
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_get_ActIntAmt
-- --------------------------------------------------

--exec pr_get_proamt 1,'1201090112312312','0.00',0
--exec pr_get_proamt 1,'1201090005206438',0,0
--exec pr_get_proamt 1,'1201090112312312',0,0
--exec pr_get_proamt 1,'1201090112312312','50.00',11
CREATE proc [dbo].[pr_get_ActIntAmt](@pa_ipo_id numeric,@pa_client_id varchar(16),@pa_pro_inter numeric(18,2),@pa_noofdays numeric)
as
begin 

declare @l_interest numeric(18,2)
,@l_noofdays numeric

select @l_interest = @pa_pro_inter
select @l_noofdays = @pa_noofdays

if exists (select * from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id)
begin 

if @pa_pro_inter = '0.00'
select @l_interest  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id and record_type ='INTCHRG'

if @pa_noofdays = '0'
select @l_noofdays  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id and record_type ='MININTCHRG'



end 
else 
begin 

if @pa_pro_inter = '0.00'
select @l_interest  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = '' and record_type ='INTCHRG'

if @pa_noofdays = '0'
select @l_noofdays  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = '' and record_type ='MININTCHRG'




end 
declare @l_applied_value numeric(18,2)
select @l_applied_value  = 0 
select  @l_applied_value = convert(numeric(18,2),IT_APPLIED_VALUE ) from ipo_transactions 
,client_master
where it_im_id = @pa_ipo_id
and IT_CM_ID=CM_ID
and convert(varchar(20),CM_UM_ID)=@pa_client_id
--AND  NOT EXISTS (SELECT IMIC_ID FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_IM_ID=IT_IM_ID AND CM_UM_ID=IMIC_BOID)
--and IT_DPID + IT_CLIENTDPID = @pa_client_id

declare @l_applied_value_PI numeric(18,2)
select @l_applied_value_PI  = 0 
select  @l_applied_value_PI = convert(numeric(18,2),ldg_amount ) from ledger
where ldg_account_id = @pa_client_id and ldg_voucher_type='2'
and ldg_narration='AUTO CREDIT INTEREST TO CLIENT' and ldg_deleted_ind=1



select @l_interest interest 
, @l_noofdays noofdays 
, @l_applied_value AppliedValue 
, ((( @l_applied_value * @l_interest ) / 100)/365)*@l_noofdays  InterestAmt
,@l_applied_value_PI [Prov_IntCharge]
,Diff=((( @l_applied_value * @l_interest ) / 100)/365)*@l_noofdays - abs(@l_applied_value_PI)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_get_proamt
-- --------------------------------------------------
--exec pr_get_proamt 1,'1201090112312312','0.00',0
--exec pr_get_proamt 1,'1201090005206438',0,0
--exec pr_get_proamt 1,'1201090112312312',0,0
--exec pr_get_proamt 1,'1201090112312312','50.00',11
CREATE proc [dbo].[pr_get_proamt](@pa_ipo_id numeric,@pa_client_id varchar(16),@pa_pro_inter numeric(18,2),@pa_noofdays numeric)
as
begin 

declare @l_interest numeric(18,2)
,@l_noofdays numeric

select @l_interest = @pa_pro_inter
select @l_noofdays = @pa_noofdays

if exists (select * from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id)
begin 

if @pa_pro_inter = '0.00'
select @l_interest  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id and record_type ='INTCHRG'

if @pa_noofdays = '0'
select @l_noofdays  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = @pa_client_id and record_type ='MININTCHRG'



end 
else 
begin 

if @pa_pro_inter = '0.00'
select @l_interest  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = '' and record_type ='INTCHRG'

if @pa_noofdays = '0'
select @l_noofdays  = qty_limit from TBL_IPO_INTMSTR  where ISIN = @pa_ipo_id 
and party_code = '' and record_type ='MININTCHRG'




end 
declare @l_applied_value numeric(18,2)
select @l_applied_value  = 0 
select  @l_applied_value = convert(numeric(18,2),IT_APPLIED_VALUE ) from ipo_transactions 
,client_master
where it_im_id = @pa_ipo_id
and IT_CM_ID=CM_ID
and convert(varchar(20),CM_UM_ID)=@pa_client_id
--and IT_DPID + IT_CLIENTDPID = @pa_client_id

declare @l_applied_value_PI numeric(18,2)
select @l_applied_value_PI  = 0 
select  @l_applied_value_PI = convert(numeric(18,2),ldg_amount ) from ledger
where ldg_account_id = @pa_client_id and ldg_voucher_type='1'
and ldg_narration='AUTO DEBIT INTEREST TO CLIENT' and ldg_deleted_ind=1



select @l_interest interest 
, @l_noofdays noofdays 
, @l_applied_value AppliedValue 
, ((( @l_applied_value * @l_interest ) / 100)/365)*@l_noofdays  InterestAmt
,@l_applied_value_PI [Prov_IntCharge]
,Diff=((( @l_applied_value * @l_interest ) / 100)/365)*@l_noofdays - abs(@l_applied_value_PI)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_INS_UPD_IPO_ALLOCATED_MSTR
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[PR_INS_UPD_IPO_ALLOCATED_MSTR]
(
 @PA_ACTION VARCHAR(20)
,@PA_IMA_IM_ID NUMERIC
,@PA_IMA_PARTY_CODE VARCHAR(20)
,@PA_IMA_BOID VARCHAR(16)
,@PA_IMA_ISIN VARCHAR(12)
,@PA_IMA_QTY NUMERIC(18,5)
,@PA_IMA_TRANS_NO VARCHAR(50)
,@PA_LOGINNAME VARCHAR(30)
)
AS
BEGIN
IF @PA_ACTION='INS'
BEGIN
IF NOT EXISTS (SELECT IMA_IM_ID FROM IPO_ALLOCATED_MASTER WHERE IMA_BOID=@PA_IMA_BOID AND IMA_ISIN=@PA_IMA_ISIN  AND IMA_TRANS_NO=@PA_IMA_TRANS_NO)
BEGIN
INSERT INTO IPO_ALLOCATED_MASTER
(
IMA_IM_ID
,IMA_PARTY_CODE
,IMA_BOID
,IMA_ISIN
,IMA_QTY
,IMA_TRANS_NO
,IMA_CREATED_BY
,IMA_CREATED_DATE
,IMA_LAST_UPD_BY
,IMA_LST_UPD_DT
,IMA_DELETED_IND
)
values
(
 @PA_IMA_IM_ID 
,@PA_IMA_PARTY_CODE 
,@PA_IMA_BOID 
,@PA_IMA_ISIN 
,@PA_IMA_QTY 
,@PA_IMA_TRANS_NO 
,@PA_LOGINNAME 
,GETDATE() 
,@PA_LOGINNAME 
,GETDATE()
,'1'
)
END
END

IF @PA_ACTION='DEL'
BEGIN
DELETE FROM IPO_ALLOCATED_MASTER WHERE IMA_TRANS_NO=@PA_IMA_TRANS_NO
END

IF @PA_ACTION='DIRECT'
BEGIN
INSERT INTO IPO_ALLOCATED_MASTER
(
IMA_IM_ID
,IMA_PARTY_CODE
,IMA_BOID
,IMA_ISIN
,IMA_QTY
,IMA_TRANS_NO
,IMA_CREATED_BY
,IMA_CREATED_DATE
,IMA_LAST_UPD_BY
,IMA_LST_UPD_DT
,IMA_DELETED_IND
)
SELECT distinct IT_IM_ID,ISNULL(CM_PARTY_CODE,''),CDSHM_BEN_ACCT_NO,CDSHM_ISIN,CDSHM_QTY,CDSHM_TRANS_NO,@PA_LOGINNAME 
,GETDATE() 
,@PA_LOGINNAME 
,GETDATE()
,'1' FROM IPO_TRANSACTIONS , [172.31.16.94].dmat.CITRUS_USR.CDSL_HOLDING_DTLS , IPO_MASTER,CLIENT_MASTER
WHERE CDSHM_BEN_ACCT_NO=CM_UM_ID
AND IT_IM_ID = IM_ID
AND IT_CM_ID =CM_ID
AND IM_ISIN_CD = CDSHM_ISIN
AND IM_ID=@PA_IMA_IM_ID and cdshm_qty>0
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_INS_UPD_IPO_ALLOTMENT
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PR_INS_UPD_IPO_ALLOTMENT]
	@PA_ACTION VARCHAR(20),
	@PA_IAM_ID BIGINT,
	@PA_IAM_IM_ID NUMERIC(18,0),
	@PA_IAM_IPO_NAME VARCHAR(100),
	@PA_IAM_CUT_OFF_PRICE NUMERIC(24,4),
	@PA_IAM_ALLOT_RT NUMERIC(24,4),
	@PA_IAM_DISCOUNTED_RT NUMERIC(24,4),
	@PA_IAM_ALLOT_DT DATETIME,
	@PA_IAM_MODIFIEDBY VARCHAR(100),
	@ERRORCODE INT OUTPUT, 
	@MESSAGE VARCHAR(200) OUTPUT
AS
BEGIN--1
	SET @ERRORCODE = 0
	IF @PA_ACTION = 'INS'
	BEGIN--2
		IF NOT EXISTS(SELECT IAM_IM_ID FROM IPO_ALLOTMENT_MASTER WHERE IAM_IM_ID = @PA_IAM_IM_ID)                
		BEGIN--3   
	 
			BEGIN TRANSACTION    
		    
			INSERT
			INTO [dbo].[IPO_ALLOTMENT_MASTER]
			(
				IAM_IM_ID,
				IAM_IPO_NAME,
				IAM_CUT_OFF_PRICE,
				IAM_ALLOT_RT,
				IAM_DISCOUNTED_RT,
				IAM_ALLOT_DT,
				IAM_CREATED_BY,
				IAM_CREATED_DT,
				IAM_MODIFIED_BY,
				IAM_MODIFIED_DT,
				IAM_DELETED_IND
			)
			VALUES
			(
				@PA_IAM_IM_ID,
				@PA_IAM_IPO_NAME,
				@PA_IAM_CUT_OFF_PRICE,
				@PA_IAM_ALLOT_RT,
				@PA_IAM_DISCOUNTED_RT,
				@PA_IAM_ALLOT_DT,
				@PA_IAM_MODIFIEDBY,
				GETDATE(),
				@PA_IAM_MODIFIEDBY,
				GETDATE(),
				'1'
			)
			 
			IF @@ERROR <> 0     
			BEGIN     
			   SET  @ERRORCODE = 1    
			   SET  @MESSAGE = 'ERROR INSERTING INTO IPO ALLOTMENT MASTER - '  + @PA_IAM_IPO_NAME   
			   GOTO ERROR    
			END    

			ERROR:    
			    
			IF @ERRORCODE = 1    
			BEGIN    
				  ROLLBACK TRANSACTION    
				  SET  @ERRORCODE = -1000067                
				  EXEC IPO_LOG_ERRORS @ERRORCODE,@MESSAGE,'PR_INS_UPD_IPO_ALLOTMENT','',@PA_IAM_MODIFIEDBY  
			END    
			ELSE    
			BEGIN    
				  COMMIT TRANSACTION    
				  SET @MESSAGE = 'IPO ALLOTMENT SUCCESSFULLY.'  
			END    
		END--3  
		ELSE      
		BEGIN  
			  SET @MESSAGE = 'IPO ALLOTED ALREADY EXISTS. PLEASE SELECT ANOTHER IPO NAME'      
		END  
	END
		ELSE IF @PA_ACTION = 'EDT'
		BEGIN
			BEGIN TRANSACTION

			UPDATE IPO_ALLOTMENT_MASTER
			SET IAM_CUT_OFF_PRICE = @PA_IAM_CUT_OFF_PRICE,
				IAM_ALLOT_RT = @PA_IAM_ALLOT_RT,
				IAM_DISCOUNTED_RT = @PA_IAM_DISCOUNTED_RT,
				IAM_ALLOT_DT = @PA_IAM_ALLOT_DT,
				IAM_MODIFIED_BY = @PA_IAM_MODIFIEDBY,
				IAM_MODIFIED_DT = GETDATE()
			WHERE IAM_ID = @PA_IAM_ID
			AND IAM_DELETED_IND = 1
				
			IF @@ERROR <> 0     
			BEGIN     
			   SET  @ERRORCODE = 1    
			   SET  @MESSAGE = 'ERROR IN EDITING RECORD - '  + @PA_IAM_IPO_NAME   
			   GOTO ERROREDT    
			END    

			ERROREDT:    
			    
			IF @ERRORCODE = 1    
			BEGIN    
				  ROLLBACK TRANSACTION    
				  SET  @ERRORCODE = -1000067                
				  EXEC IPO_LOG_ERRORS @ERRORCODE,@MESSAGE,'PR_INS_UPD_IPO_ALLOTMENT','',@PA_IAM_MODIFIEDBY  
			END    
			ELSE    
			BEGIN    
				  COMMIT TRANSACTION    
				  SET @MESSAGE = 'RECORD EDITED SUCCESSFULLY.'  
			END   

		END
		ELSE IF @PA_ACTION = 'DEL'
		BEGIN

			BEGIN TRANSACTION

			DELETE FROM IPO_ALLOTMENT_MASTER
			WHERE IAM_ID = @PA_IAM_ID
			AND IAM_DELETED_IND = 1
			
			IF @@ERROR <> 0     
			BEGIN     
			   SET  @ERRORCODE = 1    
			   SET  @MESSAGE = 'ERROR IN DELETING RECORD - '  + @PA_IAM_ID   
			   GOTO ERRORDEL    
			END    

			ERRORDEL:    
			    
			IF @ERRORCODE = 1    
			BEGIN    
				  ROLLBACK TRANSACTION    
				  SET  @ERRORCODE = -1000067                
				  EXEC IPO_LOG_ERRORS @ERRORCODE,@MESSAGE,'PR_INS_UPD_IPO_ALLOTMENT','',@PA_IAM_MODIFIEDBY  
			END    
			ELSE    
			BEGIN    
				  COMMIT TRANSACTION    
				  SET @MESSAGE = 'RECORD DELETED SUCCESSFULLY.'  
			END   

		END	
		
END--1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_INS_UPD_IPO_BANK_POST
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[PR_INS_UPD_IPO_BANK_POST]
(
 @PA_ACTION VARCHAR(20)
,@PA_IMIB_IM_ID NUMERIC
,@PA_IMIB_PARTY_CODE VARCHAR(20)
,@PA_IMIB_BOID VARCHAR(16)
,@PA_IMIB_ID NUMERIC 
,@PA_IMIB_APP_AMT MONEY
,@PA_IMIB_ALL_AMT MONEY 
,@PA_IMIB_DIFF MONEY
,@PA_LOGINNAME VARCHAR(30)
)
AS
BEGIN
IF @PA_ACTION='INS'
BEGIN
IF NOT EXISTS (SELECT IMIB_IM_ID,@PA_IMIB_BOID FROM IPO_BANK_POST_MASTER WHERE IMIB_BOID=@PA_IMIB_BOID 
AND IMIB_IM_ID=@PA_IMIB_IM_ID )
	BEGIN
	INSERT INTO IPO_BANK_POST_MASTER
	(
	IMIB_IM_ID 
	,IMIB_PARTYCODE 
	,IMIB_BOID 
	,IMIB_APP_AMT 
	,IMIB_ALLOCATED_AMT
	
	,IMIB_DIFF
	,IMIB_CREATED_BY 
	,IMIB_CREATED_DT 
	,IMIB_LST_UPD_BY 
	,IMIB_LST_UPD_DT 
	,IMIB_DELETED_IND 
	,IMIB_FLAG 
	)
	values
	(
	 @PA_IMIB_IM_ID 
	,@PA_IMIB_PARTY_CODE 
	,@PA_IMIB_BOID  
	,@PA_IMIB_APP_AMT 
	,@PA_IMIB_ALL_AMT
	
	,@PA_IMIB_DIFF
	,@PA_LOGINNAME 
	,GETDATE() 
	,@PA_LOGINNAME 
	,GETDATE()
	,'1'
	,'1'
	)
	END
	
		DECLARE @L_VOUCHER_NO NUMERIC
		DECLARE @L_VCH_NO NUMERIC(18,0)
        ,@L_DIFF MONEY 
        ,@PA_GL_CODE varchar(11),@PA_VOUCHER_DT DATETIME ,@PA_LDG_FROM_DT DATETIME,@PA_LDG_TO_DT DATETIME
        SELECT @L_DIFF =abs((@PA_IMIB_ALL_AMT-@PA_IMIB_APP_AMT))
		SELECT @L_VOUCHER_NO = MAX(ISNULL(LDG_VOUCHER_NO,0))+1 
		FROM LEDGER  		
		select @PA_GL_CODE = isnull(IM_GL_CODE,'') from ipo_master where IM_ID=@PA_IMIB_IM_ID
		select @PA_VOUCHER_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
		select @PA_LDG_FROM_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
		select @PA_LDG_TO_DT = 'Dec 21 2100'
		
		EXEC [IPO_VOUCHERENTRY] 'ADD',@PA_IMIB_IM_ID,0,@PA_VOUCHER_DT,1,@PA_IMIB_BOID,'','','',@L_DIFF,'','DIFFERENCE CREDITED FOR BANK'
			,@PA_GL_CODE
		    ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
		    ,@PA_LDG_TO_DT
			,''
	
END


--IF @PA_ACTION='POST'
--BEGIN
--IF EXISTS (SELECT IMIB_IM_ID FROM IPO_CLOSE_MASTER WHERE IMIB_BOID=@PA_IMIB_BOID 
--AND IMIB_IM_ID=@PA_IMIB_IM_ID AND IMIB_FLAG='0')
--	BEGIN


--		DECLARE @C_CLIENT_SUMMARY1  CURSOR 
--		,@c_im_id  numeric
--		,@c_IMIB_BOID varchar(16)
--		,@c_IMIB_INT_AMT money
--		,@c_IMIB_PROV_INT money
--        ,@PA_GL_CODE varchar(11),@PA_VOUCHER_DT DATETIME ,@PA_LDG_FROM_DT DATETIME,@PA_LDG_TO_DT DATETIME
        

--		DECLARE @L_VOUCHER_NO NUMERIC
--		DECLARE @L_VCH_NO NUMERIC(18,0)

--		SELECT @L_VOUCHER_NO = MAX(ISNULL(LDG_VOUCHER_NO,0))+1 
--		FROM LEDGER        
        
--		SET @C_CLIENT_SUMMARY1  = CURSOR FAST_FORWARD FOR 
		
--		SELECT IMIB_IM_ID,IMIB_BOID,IMIB_INT_AMT,IMIB_PROV_INT FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIB_BOID=@PA_IMIB_BOID 
--		AND IMIB_IM_ID=@PA_IMIB_IM_ID AND IMIB_FLAG='0'
--		select @PA_GL_CODE = isnull(IM_GL_CODE,'') from ipo_master where IM_ID=@PA_IMIB_IM_ID
--		select @PA_VOUCHER_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
--		select @PA_LDG_FROM_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
--		select @PA_LDG_TO_DT = 'Dec 21 2100'--convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
		
--		OPEN @C_CLIENT_SUMMARY1  
		  
--		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIB_BOID, @c_IMIB_INT_AMT,@c_IMIB_PROV_INT
		  
		  
		  
--		WHILE @@FETCH_STATUS = 0                                                                                                          
--		BEGIN 

--		EXEC [IPO_VOUCHERENTRY] 'ADD',@c_im_id,0,@PA_VOUCHER_DT,2,@c_IMIB_BOID,'','','',@c_IMIB_INT_AMT,'','ACTUAL INTEREST CHARGE'
--			,@PA_GL_CODE
--		  ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
--		  ,@PA_LDG_TO_DT
--		,'' -- @PA_LDG_INST_TYPE  


--		UPDATE IPO_INTERESTCALCULATE_MASTER SET IMIB_FLAG='1' FROM  IPO_INTERESTCALCULATE_MASTER WHERE IMIB_FLAG='0' AND IMIB_IM_ID=@c_im_id
--		AND IMIB_BOID=@c_IMIB_BOID

--		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIB_BOID, @c_IMIB_INT_AMT,@c_IMIB_PROV_INT
		  
		  
--		--  
--		END  
		  
--		CLOSE @C_CLIENT_SUMMARY1    
--		DEALLOCATE  @C_CLIENT_SUMMARY1   




--	END
--END

IF @PA_ACTION='DEL'
BEGIN
DELETE FROM IPO_BANK_POST_MASTER WHERE IMIB_BOID=@PA_IMIB_BOID 
AND IMIB_IM_ID=@PA_IMIB_IM_ID AND IMIB_FLAG='1'
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_INS_UPD_IPO_CLOSE
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[PR_INS_UPD_IPO_CLOSE]
(
 @PA_ACTION VARCHAR(20)
,@PA_IMIC_IM_ID NUMERIC
,@PA_IMIC_PARTY_CODE VARCHAR(20)
,@PA_IMIC_BOID VARCHAR(16)
,@PA_IMIC_ID NUMERIC 
,@PA_IMIC_APP_AMT MONEY
,@PA_IMIC_ALL_AMT MONEY 
,@PA_IMIC_OUT MONEY
,@PA_IMIC_DIFF MONEY
,@PA_LOGINNAME VARCHAR(30)
)
AS
BEGIN
IF @PA_ACTION='INS'
BEGIN
IF NOT EXISTS (SELECT IMIC_IM_ID FROM IPO_CLOSE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
AND IMIC_IM_ID=@PA_IMIC_IM_ID )
	BEGIN
	INSERT INTO IPO_CLOSE_MASTER
	(
	IMIC_IM_ID 
	,IMIC_PARTYCODE 
	,IMIC_BOID 
	,IMIC_APP_AMT 
	,IMIC_ALLOCATED_AMT
	,IMIC_OUTSTANDING
	,IMIC_DIFF
	,IMIC_CREATED_BY 
	,IMIC_CREATED_DT 
	,IMIC_LST_UPD_BY 
	,IMIC_LST_UPD_DT 
	,IMIC_DELETED_IND 
	,IMIC_FLAG 
	)
	values
	(
	 @PA_IMIC_IM_ID 
	,@PA_IMIC_PARTY_CODE 
	,@PA_IMIC_BOID  
	,@PA_IMIC_APP_AMT 
	,@PA_IMIC_ALL_AMT
	,@PA_IMIC_OUT 	
	,@PA_IMIC_DIFF
	,@PA_LOGINNAME 
	,GETDATE() 
	,@PA_LOGINNAME 
	,GETDATE()
	,'1'
	,'1'
	)
	END
END


--IF @PA_ACTION='POST'
--BEGIN
--IF EXISTS (SELECT IMIC_IM_ID FROM IPO_CLOSE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
--AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='0')
--	BEGIN


--		DECLARE @C_CLIENT_SUMMARY1  CURSOR 
--		,@c_im_id  numeric
--		,@c_IMIC_BOID varchar(16)
--		,@c_IMIC_INT_AMT money
--		,@c_IMIC_PROV_INT money
--        ,@PA_GL_CODE varchar(11),@PA_VOUCHER_DT DATETIME ,@PA_LDG_FROM_DT DATETIME,@PA_LDG_TO_DT DATETIME
        

--		DECLARE @L_VOUCHER_NO NUMERIC
--		DECLARE @L_VCH_NO NUMERIC(18,0)

--		SELECT @L_VOUCHER_NO = MAX(ISNULL(LDG_VOUCHER_NO,0))+1 
--		FROM LEDGER        
        
--		SET @C_CLIENT_SUMMARY1  = CURSOR FAST_FORWARD FOR 
		
--		SELECT IMIC_IM_ID,IMIC_BOID,IMIC_INT_AMT,IMIC_PROV_INT FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
--		AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='0'
--		select @PA_GL_CODE = isnull(IM_GL_CODE,'') from ipo_master where IM_ID=@PA_IMIC_IM_ID
--		select @PA_VOUCHER_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
--		select @PA_LDG_FROM_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
--		select @PA_LDG_TO_DT = 'Dec 21 2100'--convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		
--		OPEN @C_CLIENT_SUMMARY1  
		  
--		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIC_BOID, @c_IMIC_INT_AMT,@c_IMIC_PROV_INT
		  
		  
		  
--		WHILE @@FETCH_STATUS = 0                                                                                                          
--		BEGIN 

--		EXEC [IPO_VOUCHERENTRY] 'ADD',@c_im_id,0,@PA_VOUCHER_DT,2,@c_IMIC_BOID,'','','',@c_IMIC_INT_AMT,'','ACTUAL INTEREST CHARGE'
--			,@PA_GL_CODE
--		  ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
--		  ,@PA_LDG_TO_DT
--		,'' -- @PA_LDG_INST_TYPE  


--		UPDATE IPO_INTERESTCALCULATE_MASTER SET IMIC_FLAG='1' FROM  IPO_INTERESTCALCULATE_MASTER WHERE IMIC_FLAG='0' AND IMIC_IM_ID=@c_im_id
--		AND IMIC_BOID=@c_IMIC_BOID

--		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIC_BOID, @c_IMIC_INT_AMT,@c_IMIC_PROV_INT
		  
		  
--		--  
--		END  
		  
--		CLOSE @C_CLIENT_SUMMARY1    
--		DEALLOCATE  @C_CLIENT_SUMMARY1   

		DECLARE @L_VOUCHER_NO NUMERIC
		DECLARE @L_VCH_NO NUMERIC(18,0)
        ,@L_DIFF MONEY ,@L_DIFF_ABS money
        ,@PA_GL_CODE varchar(11),@PA_VOUCHER_DT DATETIME ,@PA_LDG_FROM_DT DATETIME,@PA_LDG_TO_DT DATETIME
        SELECT @L_DIFF =  SUM(LDG_AMOUNT) FROM LEDGER WHERE LDG_ACCOUNT_ID=@PA_IMIC_BOID AND LDG_IPO_NO=@PA_IMIC_IM_ID --abs((@PA_IMIB_ALL_AMT-@PA_IMIB_APP_AMT))
		SELECT @L_VOUCHER_NO = MAX(ISNULL(LDG_VOUCHER_NO,0))+1 
		FROM LEDGER  		
		select @PA_GL_CODE = isnull(IM_GL_CODE,'') from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_VOUCHER_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_LDG_FROM_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_LDG_TO_DT = null -- convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIB_IM_ID
		select @L_DIFF_ABS= abs(@L_DIFF)
		IF @L_DIFF<0
		BEGIN
		EXEC [IPO_VOUCHERENTRY] 'ADD',@PA_IMIC_IM_ID,0,@PA_VOUCHER_DT,2,@PA_IMIC_BOID,'','','',@L_DIFF_ABS,'','CLOSE SETTLEMENT'
			,@PA_GL_CODE
		    ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
		    ,@PA_LDG_TO_DT
			,''
        END
		IF @L_DIFF>0
		BEGIN
		EXEC [IPO_VOUCHERENTRY] 'ADD',@PA_IMIC_IM_ID,0,@PA_VOUCHER_DT,1,@PA_IMIC_BOID,'','','',@L_DIFF_ABS,'','CLOSE SETTLEMENT'
			,@PA_GL_CODE
		    ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
		    ,@PA_LDG_TO_DT
			,''
        END

--	END
--END

IF @PA_ACTION='DEL'
BEGIN
DELETE FROM IPO_CLOSE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='1'
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_INS_UPD_IPO_INTERESTCALC
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[PR_INS_UPD_IPO_INTERESTCALC]
(
 @PA_ACTION VARCHAR(20)
,@PA_IMIC_IM_ID NUMERIC
,@PA_IMIC_PARTY_CODE VARCHAR(20)
,@PA_IMIC_BOID VARCHAR(16)
,@PA_IMIC_ID NUMERIC 
,@PA_IMIC_APP_AMT MONEY
,@PA_IMIC_INT INT 
,@PA_IMIC_DAYS INT
,@PA_IMIC_INT_AMT MONEY
,@PA_IMIC_PROV_INT INT
,@PA_IMIC_DIFF MONEY
,@PA_LOGINNAME VARCHAR(30)
)
AS
BEGIN
IF @PA_ACTION='INS'
BEGIN
IF NOT EXISTS (SELECT IMIC_IM_ID FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
AND IMIC_IM_ID=@PA_IMIC_IM_ID )
	BEGIN
	INSERT INTO IPO_INTERESTCALCULATE_MASTER
	(
	IMIC_IM_ID 
	,IMIC_PARTYCODE 
	,IMIC_BOID 
	,IMIC_APP_AMT 
	,IMIC_INT  
	,IMIC_DAYS 
	,IMIC_INT_AMT 
	,IMIC_PROV_INT 
	,IMIC_DIFF 
	,IMIC_CREATED_BY 
	,IMIC_CREATED_DT 
	,IMIC_LST_UPD_BY 
	,IMIC_LST_UPD_DT 
	,IMIC_DELETED_IND 
	,IMIC_FLAG 
	)
	values
	(
	 @PA_IMIC_IM_ID 
	,@PA_IMIC_PARTY_CODE 
	,@PA_IMIC_BOID  
	,@PA_IMIC_APP_AMT 
	,@PA_IMIC_INT  
	,@PA_IMIC_DAYS 
	,@PA_IMIC_INT_AMT 
	,@PA_IMIC_PROV_INT 
	,@PA_IMIC_DIFF
	,@PA_LOGINNAME 
	,GETDATE() 
	,@PA_LOGINNAME 
	,GETDATE()
	,'1'
	,'0'
	)
	END
END


IF @PA_ACTION='POST'
BEGIN
IF EXISTS (SELECT IMIC_IM_ID FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='0')
	BEGIN


		DECLARE @C_CLIENT_SUMMARY1  CURSOR 
		,@c_im_id  numeric
		,@c_IMIC_BOID varchar(16)
		,@c_IMIC_INT_AMT money
		,@c_IMIC_PROV_INT money
        ,@PA_GL_CODE varchar(11),@PA_VOUCHER_DT DATETIME ,@PA_LDG_FROM_DT DATETIME,@PA_LDG_TO_DT DATETIME
        

		DECLARE @L_VOUCHER_NO NUMERIC
		DECLARE @L_VCH_NO NUMERIC(18,0)

		SELECT @L_VOUCHER_NO = MAX(ISNULL(LDG_VOUCHER_NO,0))+1 
		FROM LEDGER        
        
		SET @C_CLIENT_SUMMARY1  = CURSOR FAST_FORWARD FOR 
		
		SELECT IMIC_IM_ID,IMIC_BOID,IMIC_INT_AMT,IMIC_PROV_INT FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
		AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='0'
		select @PA_GL_CODE = isnull(IM_GL_CODE,'') from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_VOUCHER_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_LDG_FROM_DT = convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		select @PA_LDG_TO_DT = 'Dec 21 2100'--convert(varchar(11),Getdate(),109) from ipo_master where IM_ID=@PA_IMIC_IM_ID
		
		OPEN @C_CLIENT_SUMMARY1  
		  
		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIC_BOID, @c_IMIC_INT_AMT,@c_IMIC_PROV_INT
		  
		  
		  
		WHILE @@FETCH_STATUS = 0                                                                                                          
		BEGIN 

		EXEC [IPO_VOUCHERENTRY] 'ADD',@c_im_id,0,@PA_VOUCHER_DT,1,@c_IMIC_BOID,'','','',@c_IMIC_INT_AMT,'','ACTUAL INTEREST CHARGE'
			,@PA_GL_CODE
		  ,'','AUTO',0,@L_VOUCHER_NO,'',@PA_LDG_FROM_DT 
		  ,@PA_LDG_TO_DT
		,'' -- @PA_LDG_INST_TYPE  


		UPDATE IPO_INTERESTCALCULATE_MASTER SET IMIC_FLAG='1' FROM  IPO_INTERESTCALCULATE_MASTER WHERE IMIC_FLAG='0' AND IMIC_IM_ID=@c_im_id
		AND IMIC_BOID=@c_IMIC_BOID

		FETCH NEXT FROM @C_CLIENT_SUMMARY1 INTO @c_im_id,  @c_IMIC_BOID, @c_IMIC_INT_AMT,@c_IMIC_PROV_INT
		  
		  
		--  
		END  
		  
		CLOSE @C_CLIENT_SUMMARY1    
		DEALLOCATE  @C_CLIENT_SUMMARY1   




	END
END

IF @PA_ACTION='DEL'
BEGIN
DELETE FROM IPO_INTERESTCALCULATE_MASTER WHERE IMIC_BOID=@PA_IMIC_BOID 
AND IMIC_IM_ID=@PA_IMIC_IM_ID AND IMIC_FLAG='0'
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_IPO_ALLOCATED_DATA
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[PR_IPO_ALLOCATED_DATA]
(@PA_IM_ID BIGINT , @PA_ISIN VARCHAR(12),@PA_FILLER1 VARCHAR(20))
AS
BEGIN
SELECT * FROM IPO_TRANSACTIONS , [10.228.50.6].DMATMO.CITRUS_USR.CDSL_HOLDING_DTLS , IPO_MASTER,CLIENT_MASTER
WHERE CDSHM_BEN_ACCT_NO=CM_UM_ID
AND IT_IM_ID = IM_ID
AND IT_CM_ID =CM_ID
AND IM_ISIN_CD = CDSHM_ISIN
AND IM_ID=@PA_IM_ID
AND NOT EXISTS (SELECT * FROM IPO_ALLOCATED_MASTER WHERE IMA_BOID =CDSHM_BEN_ACCT_NO AND IMA_IM_ID=IM_ID)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_ipO_Bank
-- --------------------------------------------------

--EXEC PR_IPO_CLOSE  34,'','0.00',0
--EXEC PR_GET_PROAMT 1,'1201090005206438',0,0
--EXEC PR_GET_PROAMT 1,'1201090112312312',0,0
--EXEC PR_GET_PROAMT 1,'1201090112312312','50.00',11
CREATE  PROC [dbo].[pr_ipO_Bank](@PA_IPO_ID NUMERIC,@PA_CLIENT_ID VARCHAR(16),@PA_PRO_INTER NUMERIC(18,2),@PA_NOOFDAYS NUMERIC)
AS
BEGIN 

SELECT IT_BID_QTY1*IT_BID_PRICE1 APPLIEDAMT ,  IMA_QTY*645 ALLOCATEDAMT,CM_UM_ID,SUM(LDG_AMOUNT) OUSTANDING,
DIFF=case when ((IMA_QTY*645)) +SUM(LDG_AMOUNT) < 0 then convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645)) +SUM(LDG_AMOUNT))) + ' DR' else convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645)) +SUM(LDG_AMOUNT))) + ' CR' end 
,DIFFBANK =  case when  ((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)) <0 then convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)))) + ' DR' else convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)))) + ' CR' end 
FROM IPO_TRANSACTIONS,IPO_ALLOCATED_MASTER,CLIENT_MASTER,LEDGER WHERE IT_IM_ID=@PA_IPO_ID
AND IMA_IM_ID=IT_IM_ID
AND IT_CM_ID=CM_ID
AND LDG_IPO_NO=IT_IM_ID
AND LDG_ACCOUNT_ID=CM_UM_ID
AND IMA_BOID LIKE '%'
and not exists (SELECT IMIB_BOID FROM IPO_BANK_POST_MASTER WHERE IMIB_BOID=IMA_BOID and IMIB_IM_ID =IMA_IM_ID)
GROUP BY IT_BID_QTY1*IT_BID_PRICE1,IMA_QTY*645 ,CM_UM_ID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_ipO_CLOSE
-- --------------------------------------------------

--EXEC PR_IPO_CLOSE  34,'','0.00',0
--EXEC PR_GET_PROAMT 1,'1201090005206438',0,0
--EXEC PR_GET_PROAMT 1,'1201090112312312',0,0
--EXEC PR_GET_PROAMT 1,'1201090112312312','50.00',11
CREATE  PROC [dbo].[pr_ipO_CLOSE](@PA_IPO_ID NUMERIC,@PA_CLIENT_ID VARCHAR(16),@PA_PRO_INTER NUMERIC(18,2),@PA_NOOFDAYS NUMERIC)
AS
BEGIN 

SELECT IT_BID_QTY1*IT_BID_PRICE1 APPLIEDAMT ,  IMA_QTY*645 ALLOCATEDAMT,CM_UM_ID,SUM(LDG_AMOUNT) OUSTANDING,
DIFF=case when ((IMA_QTY*645)) +SUM(LDG_AMOUNT) < 0 then convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645)) +SUM(LDG_AMOUNT))) + ' DR' else convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645)) +SUM(LDG_AMOUNT))) + ' CR' end 
,DIFFBANK =  case when  ((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)) <0 then convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)))) + ' DR' else convert(varchar(100),convert(numeric(18,2),((IMA_QTY*645) -(IT_BID_QTY1*IT_BID_PRICE1)))) + ' CR' end 
FROM IPO_TRANSACTIONS,IPO_ALLOCATED_MASTER,CLIENT_MASTER,LEDGER WHERE IT_IM_ID=@PA_IPO_ID
AND IMA_IM_ID=IT_IM_ID
AND IT_CM_ID=CM_ID
AND LDG_IPO_NO=IT_IM_ID
AND LDG_ACCOUNT_ID=CM_UM_ID
AND IMA_BOID LIKE '%'
and not exists (SELECT IMIC_BOID FROM IPO_CLOSE_MASTER WHERE IMIC_BOID=IMA_BOID and IMIC_IM_ID =IMA_IM_ID)

GROUP BY IT_BID_QTY1*IT_BID_PRICE1,IMA_QTY*645 ,CM_UM_ID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pr_rpt_ledger
-- --------------------------------------------------
CREATE proc [dbo].[pr_rpt_ledger](@pa_voucher_no varchar(100)  
,@pa_client_id varchar(16)  
,@pa_voucher_dt_from datetime  
,@pa_voucher_dt_to datetime  
,@pa_gl_code varchar(100)  
,@pa_LDG_IPO_NO varchar(100))  
as  
begin   
select  LDG_VOUCHER_TYPE  
,LDG_VOUCHER_NO  
, (select im_ipo_name from ipo_master where im_id = LDG_IPO_NO ) LDG_IPO_name  
,LDG_IPO_NO  
,LDG_VOUCHER_DT  
,LDG_ACCOUNT_ID  
,LDG_ACCOUNT_TYPE  
,LDG_GL_CODE  
,abs(LDG_AMOUNT) LDG_AMOUNT  
,LDG_NARRATION  
,LDG_BANK_NAME  
,LDG_ACCOUNT_NO  
,LDG_INSTRUMENT_NO  
,LDG_BANK_CL_DATE  
,LDG_STATUS  
,LDG_BRANCH_ID  
,LDG_REMARKS  
,LDG_CREATED_BY  
,LDG_CREATED_DT  
,LDG_LST_UPD_BY  
,LDG_LST_UPD_DT  
,LDG_DELETED_IND  
,LDG_FROM_DT  
,LDG_TO_DT  
,LDG_INST_TYPE   
,isnull((select abs(ldg_amount) from ledger b where a.ldg_account_id = b.ldg_account_id   
and a.ldg_voucher_dt = b.ldg_voucher_dt  and a.ldg_voucher_type = b.ldg_voucher_type  and CONVERT(VARCHAR,a.ldg_voucher_no) = isnull(b.ldg_status ,'0')   
)  ,0) interestamt  
,case when LDG_AMOUNT < 0 then 'D' else 'C' end crdrflg  
FROM LEDGER a   
WHERE   
CASE WHEN @pa_voucher_no <>'0'  THEN  LDG_VOUCHER_NO ELSE '0' END = CASE WHEN @pa_voucher_no <>'0'  THEN @pa_voucher_no ELSE '0' END AND   
CASE WHEN @pa_client_id <>''  THEN LDG_ACCOUNT_ID ELSE '' END = CASE WHEN @pa_client_id <>''  THEN @pa_client_id ELSE '' END   
AND CASE WHEN @pa_voucher_dt_from <>''  THEN LDG_VOUCHER_DT ELSE '' END between  CASE WHEN @pa_voucher_dt_from <>''  THEN @pa_voucher_dt_from ELSE 'jan 01 1900' END   
and CASE WHEN @pa_voucher_dt_to <>''  THEN @pa_voucher_dt_to ELSE 'dec 31 2100' END   
AND CASE WHEN @pa_gl_code <>''  THEN LDG_GL_CODE ELSE '' END = CASE WHEN @pa_gl_code <>''  THEN @pa_gl_code ELSE '' END   
AND LDG_DELETED_IND = 1   
and CASE WHEN @pa_LDG_IPO_NO <>''  THEN LDG_IPO_NO  else '' end = CASE WHEN @pa_LDG_IPO_NO <>''  then @pa_LDG_IPO_NO else '' end   
and ldg_voucher_type <>'1'  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------
  

  
CREATE PROC Tbl @TblName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw
-- --------------------------------------------------
    
CREATE PROC Vw @VwName VARCHAR(25)AS                   
Select * from sysobjects where name Like '%' + @VwName + '%' and xtype='V' Order By Name

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_SUBBROKERS
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_SUBBROKERS]
(
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] CHAR(100) NOT NULL,
    [Address1] CHAR(40) NULL,
    [Address2] CHAR(40) NULL,
    [City] CHAR(20) NULL,
    [State] VARCHAR(50) NULL,
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
    [branch_Code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(50) NULL,
    [SharingType] VARCHAR(3) NULL,
    [Trd_Sharing] NUMERIC(18, 4) NULL,
    [Del_Sharing] NUMERIC(18, 4) NULL,
    [Trd_Charges] NUMERIC(18, 4) NULL,
    [Del_Charges] NUMERIC(18, 4) NULL,
    [RemPartyCode] VARCHAR(10) NULL,
    [Branch_SharingType] VARCHAR(3) NULL,
    [Branch_Trd_Sharing] NUMERIC(18, 4) NULL,
    [Branch_Del_Sharing] NUMERIC(18, 4) NULL,
    [Branch_Trd_Charges] NUMERIC(18, 4) NULL,
    [Branch_Del_Charges] NUMERIC(18, 4) NULL,
    [Branch_RemPartyCode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.boisl
-- --------------------------------------------------
CREATE TABLE [dbo].[boisl]
(
    [CDSHM_DPM_ID] FLOAT NULL,
    [CDSHM_BEN_ACCT_NO] FLOAT NULL,
    [CDSHM_DPAM_ID] FLOAT NULL,
    [CDSHM_TRATM_CD] FLOAT NULL,
    [CDSHM_T] NVARCHAR(255) NULL,
    [RATM_DES] NVARCHAR(255) NULL,
    [C] NVARCHAR(255) NULL,
    [F8] NVARCHAR(255) NULL,
    [CDSHM_TRAS] DATETIME NULL,
    [_DT] DATETIME NULL,
    [CDSHM_ISIN] NVARCHAR(255) NULL,
    [CDSHM_QTY] FLOAT NULL,
    [CDSHM_IN] NVARCHAR(255) NULL,
    [T_REF_NO] NVARCHAR(255) NULL,
    [CDSHM_TRANS_NO] FLOAT NULL,
    [CDSHM_SETT_TYPE CDSHM_SETT_NO CDSHM_COUNTER_BOID   CDSHM_COUNTER] FLOAT NULL,
    [CDSHM_TRADE_NO] FLOAT NULL,
    [CDSHM_CREATED_BY] NVARCHAR(255) NULL,
    [CDSHM_CREA] DATETIME NULL,
    [TED_DT] DATETIME NULL,
    [CDSHM_LST_UPD_BY] NVARCHAR(255) NULL,
    [CDSHM_LST_] DATETIME NULL,
    [UPD_DT] DATETIME NULL,
    [CDSHM_DELETED_IND] FLOAT NULL,
    [cdshm_slip_no] NVARCHAR(255) NULL,
    [cdshm_tratm_t] NVARCHAR(255) NULL,
    [ype_desc] NVARCHAR(255) NULL,
    [cdshm_interna] NVARCHAR(255) NULL,
    [l_trastm] NVARCHAR(255) NULL,
    [CDSHM_BAL_TYPE                 cdshm_id] FLOAT NULL,
    [cdshm_opn_bal] FLOAT NULL,
    [cdshm_charge] FLOAT NULL,
    [CDSHM_DP_CHARGE] FLOAT NULL,
    [CDSHM_TRG_SETTM_NO WAIVE_FLAG] NVARCHAR(255) NULL,
    [cdshm_trans_cdas_code] NVARCHAR(255) NULL,
    [CDSHM_CDAS_TRAS_TYPE] FLOAT NULL,
    [CDSHM_CDAS_SUB_TRAS_TYPE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BRANCH_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCH_MASTER]
(
    [BM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [BM_CODE] VARCHAR(50) NOT NULL,
    [BM_NAME] VARCHAR(100) NOT NULL,
    [BM_ADD1] VARCHAR(100) NOT NULL,
    [BM_ADD2] VARCHAR(100) NULL,
    [BM_ADD3] VARCHAR(100) NULL,
    [BM_CITY] VARCHAR(64) NOT NULL,
    [BM_STATE] VARCHAR(64) NOT NULL,
    [BM_COUNTRY] VARCHAR(64) NOT NULL,
    [BM_PINCODE] VARCHAR(10) NOT NULL,
    [BM_CONTACTPERSON] VARCHAR(100) NULL,
    [BM_OFFICE_CONTACT] VARCHAR(15) NULL,
    [BM_FAX] VARCHAR(15) NULL,
    [BM_EMAILID] VARCHAR(50) NULL,
    [BM_MODIFIEDBY] BIGINT NOT NULL,
    [BM_MODIFIEDDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_BANK_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_BANK_DETAILS]
(
    [CBD_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CBD_CM_ID] BIGINT NOT NULL,
    [CBD_BANK_NAME] VARCHAR(64) NOT NULL,
    [CBD_BRANCH] VARCHAR(64) NOT NULL,
    [CBD_CITY] VARCHAR(64) NULL,
    [CBD_ACCTYPE] VARCHAR(1) NOT NULL,
    [CBD_ACCNO] VARCHAR(20) NOT NULL,
    [CBD_CUSTID] VARCHAR(32) NULL,
    [CBD_CHEQUENAME] VARCHAR(100) NULL,
    [CBD_DEFAULT] TINYINT NOT NULL,
    [CBD_MODIFIEDBY] BIGINT NULL,
    [CBD_MODIFIEDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_BANK_DETAILS_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_BANK_DETAILS_JRNL]
(
    [CBD_ID_JRNL] BIGINT IDENTITY(1,1) NOT NULL,
    [CBD_ID] BIGINT NOT NULL,
    [CBD_CM_ID] BIGINT NOT NULL,
    [CBD_BANK_NAME] VARCHAR(64) NOT NULL,
    [CBD_BRANCH] VARCHAR(64) NOT NULL,
    [CBD_CITY] VARCHAR(64) NULL,
    [CBD_ACCTYPE] VARCHAR(1) NOT NULL,
    [CBD_ACCNO] VARCHAR(20) NOT NULL,
    [CBD_CUSTID] VARCHAR(32) NULL,
    [CBD_CHEQUENAME] VARCHAR(100) NULL,
    [CBD_DEFAULT] TINYINT NOT NULL,
    [CBD_MODIFIEDBY] BIGINT NULL,
    [CBD_MODIFIEDDT] DATETIME NULL,
    [CBD_JRNLBY] BIGINT NULL,
    [CBD_JRNLDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_CASH_BALANCE
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_CASH_BALANCE]
(
    [CCB_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CCB_CM_ID] BIGINT NOT NULL,
    [CCB_AVAILABLE_LIMIT] NUMERIC(24, 4) NOT NULL,
    [CCB_USED_LIMIT] NUMERIC(24, 4) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_DP_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_DP_DETAILS]
(
    [CDD_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CDD_CM_ID] BIGINT NULL,
    [CDD_DEPOSITORY] VARCHAR(10) NOT NULL,
    [CDD_DPID] VARCHAR(16) NOT NULL,
    [CDD_DPNAME] VARCHAR(100) NOT NULL,
    [CDD_CLIENTDPID] VARCHAR(8) NOT NULL,
    [CDD_DEFAULT] TINYINT NOT NULL,
    [CDD_MODIFIEDBY] BIGINT NOT NULL,
    [CDD_MODIFIEDDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_DP_DETAILS_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_DP_DETAILS_JRNL]
(
    [CDD_ID_JRNL] BIGINT IDENTITY(1,1) NOT NULL,
    [CDD_ID] BIGINT NOT NULL,
    [CDD_CM_ID] BIGINT NULL,
    [CDD_DEPOSITORY] VARCHAR(10) NOT NULL,
    [CDD_DPID] VARCHAR(16) NOT NULL,
    [CDD_DPNAME] VARCHAR(100) NOT NULL,
    [CDD_CLIENTDPID] VARCHAR(8) NOT NULL,
    [CDD_DEFAULT] TINYINT NOT NULL,
    [CDD_MODIFIEDBY] BIGINT NOT NULL,
    [CDD_MODIFIEDDT] DATETIME NOT NULL,
    [CDD_ALTERBY] BIGINT NOT NULL,
    [CDD_ALTERDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_MASTER]
(
    [CM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [CM_UM_ID] BIGINT NOT NULL,
    [CM_USER_TYPE] VARCHAR(3) NOT NULL,
    [CM_USER_STATUS] VARCHAR(10) NOT NULL,
    [CM_POA] TINYINT NOT NULL,
    [CM_APPNAME1] VARCHAR(100) NOT NULL,
    [CM_APPNAME2] VARCHAR(100) NULL,
    [CM_APPNAME3] VARCHAR(100) NULL,
    [CM_DOB1] DATETIME NOT NULL,
    [CM_DOB2] DATETIME NULL,
    [CM_DOB3] DATETIME NULL,
    [CM_GENDER1] VARCHAR(1) NOT NULL,
    [CM_GENDER2] VARCHAR(1) NULL,
    [CM_GENDER3] VARCHAR(1) NULL,
    [CM_FATHERHUSBAND] VARCHAR(100) NOT NULL,
    [CM_PAN1] VARCHAR(16) NOT NULL,
    [CM_PAN2] VARCHAR(16) NULL,
    [CM_PAN3] VARCHAR(16) NULL,
    [CM_CIRCLE1] VARCHAR(30) NULL,
    [CM_CIRCLE2] VARCHAR(30) NULL,
    [CM_CIRCLE3] VARCHAR(30) NULL,
    [CM_MAPINFLAG] TINYINT NULL,
    [CM_MAPIN] VARCHAR(16) NULL,
    [CM_CATEGORY] VARCHAR(50) NOT NULL,
    [CM_BM_ID] BIGINT NOT NULL,
    [CM_SBM_ID] BIGINT NOT NULL,
    [CM_NOMINEE] VARCHAR(100) NULL,
    [CM_NOMINEE_RELATION] VARCHAR(50) NULL,
    [CM_GUARDIANPAN] VARCHAR(16) NULL,
    [CM_MODIFIEDBY] BIGINT NOT NULL,
    [CM_MODIFIEDDT] DATETIME NOT NULL,
    [CM_PARTY_CODE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_MASTER_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_MASTER_JRNL]
(
    [CM_ID_JRNL] BIGINT IDENTITY(1,1) NOT NULL,
    [CM_ID] BIGINT NOT NULL,
    [CM_UM_ID] BIGINT NOT NULL,
    [CM_USER_TYPE] VARCHAR(3) NOT NULL,
    [CM_USER_STATUS] VARCHAR(10) NOT NULL,
    [CM_POA] TINYINT NOT NULL,
    [CM_APPNAME1] VARCHAR(100) NOT NULL,
    [CM_APPNAME2] VARCHAR(100) NULL,
    [CM_APPNAME3] VARCHAR(100) NULL,
    [CM_DOB1] DATETIME NOT NULL,
    [CM_DOB2] DATETIME NULL,
    [CM_DOB3] DATETIME NULL,
    [CM_GENDER1] VARCHAR(1) NOT NULL,
    [CM_GENDER2] VARCHAR(1) NULL,
    [CM_GENDER3] VARCHAR(1) NULL,
    [CM_FATHERHUSBAND] VARCHAR(100) NOT NULL,
    [CM_PAN1] VARCHAR(16) NOT NULL,
    [CM_PAN2] VARCHAR(16) NULL,
    [CM_PAN3] VARCHAR(16) NULL,
    [CM_CIRCLE1] VARCHAR(30) NULL,
    [CM_CIRCLE2] VARCHAR(30) NULL,
    [CM_CIRCLE3] VARCHAR(30) NULL,
    [CM_MAPINFLAG] TINYINT NULL,
    [CM_MAPIN] VARCHAR(16) NULL,
    [CM_CATEGORY] VARCHAR(50) NOT NULL,
    [CM_BM_ID] BIGINT NOT NULL,
    [CM_SBM_ID] BIGINT NOT NULL,
    [CM_NOMINEE] VARCHAR(100) NULL,
    [CM_NOMINEE_RELATION] VARCHAR(50) NULL,
    [CM_GUARDIANPAN] VARCHAR(16) NULL,
    [CM_MODIFIEDBY] BIGINT NOT NULL,
    [CM_MODIFIEDDT] DATETIME NOT NULL,
    [CM_ALTERBY] BIGINT NOT NULL,
    [CM_ALTERDT] DATETIME NOT NULL,
    [CM_PARTY_CODE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ERROR_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[ERROR_LOG]
(
    [EL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [EL_RETCODE] VARCHAR(100) NULL,
    [EL_RETMSG] VARCHAR(1000) NULL,
    [EL_DETAILS] VARCHAR(100) NULL,
    [EL_IP_ADD] VARCHAR(20) NULL,
    [EL_ADDDT] DATETIME NULL,
    [EL_UM_ID] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FIN_ACCOUNT_MSTR
-- --------------------------------------------------
CREATE TABLE [dbo].[FIN_ACCOUNT_MSTR]
(
    [FINA_ACC_ID] NUMERIC(10, 0) NOT NULL,
    [FINA_ACC_CODE] VARCHAR(20) NULL,
    [FINA_ACC_NAME] VARCHAR(50) NULL,
    [FINA_ACC_TYPE] CHAR(1) NULL,
    [FINA_GROUP_ID] INT NULL,
    [FINA_BRANCH_ID] INT NULL,
    [FINA_DPM_ID] NUMERIC(10, 0) NULL,
    [FINA_CREATED_BY] VARCHAR(25) NULL,
    [FINA_CREATED_DT] DATETIME NULL,
    [FINA_LST_UPD_BY] VARCHAR(25) NULL,
    [FINA_LST_UPD_DT] DATETIME NULL,
    [FINA_DELETED_IND] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_ALLOCATED_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_ALLOCATED_MASTER]
(
    [IMA_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [IMA_IM_ID] NUMERIC(18, 0) NULL,
    [IMA_PARTY_CODE] VARCHAR(20) NULL,
    [IMA_BOID] VARCHAR(16) NULL,
    [IMA_ISIN] VARCHAR(12) NULL,
    [IMA_QTY] NUMERIC(18, 5) NULL,
    [IMA_TRANS_NO] VARCHAR(50) NULL,
    [IMA_CREATED_BY] VARCHAR(50) NULL,
    [IMA_CREATED_DATE] DATETIME NULL,
    [IMA_LAST_UPD_BY] VARCHAR(50) NULL,
    [IMA_LST_UPD_DT] DATETIME NULL,
    [IMA_DELETED_IND] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_ALLOTMENT_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_ALLOTMENT_MASTER]
(
    [IAM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IAM_IM_ID] NUMERIC(18, 0) NULL,
    [IAM_IPO_NAME] VARCHAR(100) NULL,
    [IAM_CUT_OFF_PRICE] NUMERIC(24, 4) NULL,
    [IAM_ALLOT_RT] NUMERIC(24, 4) NULL,
    [IAM_DISCOUNTED_RT] NUMERIC(24, 4) NULL,
    [IAM_ALLOT_DT] DATETIME NULL,
    [IAM_CREATED_BY] VARCHAR(100) NULL,
    [IAM_CREATED_DT] DATETIME NULL,
    [IAM_MODIFIED_BY] VARCHAR(100) NULL,
    [IAM_MODIFIED_DT] DATETIME NULL,
    [IAM_DELETED_IND] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_BANK_POST_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_BANK_POST_MASTER]
(
    [IMIB_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [IMIB_IM_ID] NUMERIC(18, 0) NULL,
    [IMIB_PARTYCODE] VARCHAR(16) NULL,
    [IMIB_BOID] VARCHAR(16) NULL,
    [IMIB_APP_AMT] MONEY NULL,
    [IMIB_ALLOCATED_AMT] MONEY NULL,
    [IMIB_DIFF] MONEY NULL,
    [IMIB_CREATED_BY] VARCHAR(100) NULL,
    [IMIB_CREATED_DT] DATETIME NULL,
    [IMIB_LST_UPD_BY] VARCHAR(100) NULL,
    [IMIB_LST_UPD_DT] DATETIME NULL,
    [IMIB_DELETED_IND] SMALLINT NULL,
    [IMIB_FLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_CLOSE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_CLOSE_MASTER]
(
    [IMIC_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [IMIC_IM_ID] NUMERIC(18, 0) NULL,
    [IMIC_PARTYCODE] VARCHAR(16) NULL,
    [IMIC_BOID] VARCHAR(16) NULL,
    [IMIC_APP_AMT] MONEY NULL,
    [IMIC_ALLOCATED_AMT] MONEY NULL,
    [IMIC_OUTSTANDING] MONEY NULL,
    [IMIC_DIFF] MONEY NULL,
    [IMIC_CREATED_BY] VARCHAR(100) NULL,
    [IMIC_CREATED_DT] DATETIME NULL,
    [IMIC_LST_UPD_BY] VARCHAR(100) NULL,
    [IMIC_LST_UPD_DT] DATETIME NULL,
    [IMIC_DELETED_IND] SMALLINT NULL,
    [IMIC_FLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_INTERESTCALCULATE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_INTERESTCALCULATE_MASTER]
(
    [IMIC_ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [IMIC_IM_ID] NUMERIC(18, 0) NULL,
    [IMIC_PARTYCODE] VARCHAR(16) NULL,
    [IMIC_BOID] VARCHAR(16) NULL,
    [IMIC_APP_AMT] MONEY NULL,
    [IMIC_INT] INT NULL,
    [IMIC_DAYS] INT NULL,
    [IMIC_INT_AMT] MONEY NULL,
    [IMIC_PROV_INT] INT NULL,
    [IMIC_DIFF] MONEY NULL,
    [IMIC_CREATED_BY] VARCHAR(100) NULL,
    [IMIC_CREATED_DT] DATETIME NULL,
    [IMIC_LST_UPD_BY] VARCHAR(100) NULL,
    [IMIC_LST_UPD_DT] DATETIME NULL,
    [IMIC_DELETED_IND] SMALLINT NULL,
    [IMIC_FLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_MASTER]
(
    [IM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IM_IPO_NAME] VARCHAR(100) NOT NULL,
    [IM_IPO_SYMBOL] VARCHAR(20) NOT NULL,
    [IM_OPEN_DATE] DATETIME NULL,
    [IM_CLOSE_DATE] DATETIME NULL,
    [IM_ISSUE_SERIES] VARCHAR(20) NULL,
    [IM_ISSUE_TYPE] VARCHAR(24) NULL,
    [IM_FLOOR_PRICE] NUMERIC(24, 4) NULL,
    [IM_CAP_PRICE] NUMERIC(24, 4) NULL,
    [IM_FIXED_PRICE] NUMERIC(24, 4) NULL,
    [IM_PRICE_MULTIPLE] NUMERIC(24, 4) NULL,
    [IM_CUTOFF_PRICE] NUMERIC(24, 4) NULL,
    [IM_TRADING_LOT] INT NULL,
    [IM_MIN_BID_QTY] INT NULL,
    [IM_BID_QTY_MULTIPLE] INT NULL,
    [IM_FACE_VALUE] NUMERIC(24, 4) NULL,
    [IM_PARTIAL_AMT] NUMERIC(24, 4) NULL,
    [IM_PARTIAL_FLAG] TINYINT NULL,
    [IM_SYNMEM_NAME] VARCHAR(100) NULL,
    [IM_SYNMEM_CODE] VARCHAR(16) NULL,
    [IM_BROKER_NAME] VARCHAR(100) NULL,
    [IM_BROKER_CODE] VARCHAR(16) NULL,
    [IM_SUBBROKER] VARCHAR(16) NULL,
    [IM_BANK_NAME] VARCHAR(64) NULL,
    [IM_BANK_BRANCH] VARCHAR(64) NULL,
    [IM_BANK_SRNO] VARCHAR(16) NULL,
    [IM_REGISTRAR] VARCHAR(64) NULL,
    [IM_APPNO_START] INT NULL,
    [IM_APPNO_END] INT NULL,
    [IM_APPNO_PREFIX] VARCHAR(10) NULL,
    [IM_APPNO_SUFFIX] VARCHAR(10) NULL,
    [IM_APPNO_LENGTH] SMALLINT NULL,
    [IM_CHQ_PAYABLETO] VARCHAR(100) NULL,
    [IM_OTHER_DETAILS] VARCHAR(100) NULL,
    [IM_NRI_FLAG] TINYINT NULL,
    [IM_GL_CODE] VARCHAR(20) NULL,
    [IM_GL_NAME] VARCHAR(100) NULL,
    [IM_MODIFIEDBY] VARCHAR(100) NULL,
    [IM_MODIFIEDDT] DATETIME NULL,
    [IM_ISIN_CD] VARCHAR(12) NULL,
    [IM_NSE_SCRIPCD] VARCHAR(50) NULL,
    [IM_BSE_SCRIPCD] VARCHAR(50) NULL,
    [IM_EMP] CHAR(1) NULL,
    [IM_SH] CHAR(1) NULL,
    [IM_PUBLIC] CHAR(1) NULL,
    [IM_IPO_MIN_INT_DAYS] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_MASTER_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_MASTER_JRNL]
(
    [IM_ID_JRNL] BIGINT IDENTITY(1,1) NOT NULL,
    [IM_ID] BIGINT NOT NULL,
    [IM_IPO_NAME] VARCHAR(100) NOT NULL,
    [IM_IPO_SYMBOL] VARCHAR(20) NOT NULL,
    [IM_OPEN_DATE] DATETIME NOT NULL,
    [IM_CLOSE_DATE] DATETIME NOT NULL,
    [IM_ISSUE_SERIES] VARCHAR(20) NOT NULL,
    [IM_ISSUE_TYPE] VARCHAR(24) NOT NULL,
    [IM_FLOOR_PRICE] NUMERIC(24, 4) NOT NULL,
    [IM_CAP_PRICE] NUMERIC(24, 4) NOT NULL,
    [IM_FIXED_PRICE] NUMERIC(24, 4) NOT NULL,
    [IM_PRICE_MULTIPLE] NUMERIC(24, 4) NOT NULL,
    [IM_CUTOFF_PRICE] NUMERIC(24, 4) NOT NULL,
    [IM_TRADING_LOT] INT NOT NULL,
    [IM_MIN_BID_QTY] INT NOT NULL,
    [IM_BID_QTY_MULTIPLE] INT NOT NULL,
    [IM_FACE_VALUE] NUMERIC(24, 4) NOT NULL,
    [IM_PARTIAL_AMT] NUMERIC(24, 4) NOT NULL,
    [IM_PARTIAL_FLAG] TINYINT NOT NULL,
    [IM_SYNMEM_NAME] VARCHAR(100) NULL,
    [IM_SYNMEM_CODE] VARCHAR(16) NULL,
    [IM_BROKER_NAME] VARCHAR(100) NULL,
    [IM_BROKER_CODE] VARCHAR(16) NULL,
    [IM_SUBBROKER] VARCHAR(16) NULL,
    [IM_BANK_NAME] VARCHAR(64) NULL,
    [IM_BANK_BRANCH] VARCHAR(64) NULL,
    [IM_BANK_SRNO] VARCHAR(16) NULL,
    [IM_REGISTRAR] VARCHAR(64) NULL,
    [IM_APPNO_START] INT NOT NULL,
    [IM_APPNO_END] INT NOT NULL,
    [IM_APPNO_PREFIX] VARCHAR(10) NULL,
    [IM_APPNO_SUFFIX] VARCHAR(10) NULL,
    [IM_APPNO_LENGTH] SMALLINT NULL,
    [IM_CHQ_PAYABLETO] VARCHAR(100) NULL,
    [IM_OTHER_DETAILS] VARCHAR(100) NULL,
    [IM_NRI_FLAG] TINYINT NULL,
    [IM_GL_CODE] VARCHAR(20) NULL,
    [IM_GL_NAME] VARCHAR(100) NULL,
    [IM_MODIFIEDBY] BIGINT NOT NULL,
    [IM_MODIFIEDDT] DATETIME NOT NULL,
    [IM_JRNLBY] BIGINT NOT NULL,
    [IM_JRNLDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_MASTER_LS
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_MASTER_LS]
(
    [IMLS_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IMLS_IM_ID] NUMERIC(18, 0) NULL,
    [IMLS_CTGRY] VARCHAR(50) NULL,
    [IMLS_MIN_AMT] MONEY NULL,
    [IMLS_MAX_AMT] MONEY NULL,
    [IMLS_DELETED_IND] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_MASTER_LS_18072014
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_MASTER_LS_18072014]
(
    [IMLS_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IMLS_IM_ID] NUMERIC(18, 0) NULL,
    [IMLS_CTGRY] VARCHAR(50) NULL,
    [IMLS_MIN_AMT] MONEY NULL,
    [IMLS_MAX_AMT] MONEY NULL,
    [IMLS_DELETED_IND] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_REF_CODES
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_REF_CODES]
(
    [IRC_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IRC_TYPE] VARCHAR(32) NULL,
    [IRC_VALUE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IPO_TRANSACTIONS
-- --------------------------------------------------
CREATE TABLE [dbo].[IPO_TRANSACTIONS]
(
    [IT_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [IT_IM_ID] BIGINT NOT NULL,
    [IT_CM_ID] BIGINT NOT NULL,
    [IT_USER_TYPE] VARCHAR(3) NOT NULL,
    [IT_USER_STATUS] VARCHAR(10) NOT NULL,
    [IT_POA] TINYINT NOT NULL,
    [IT_APPNAME1] VARCHAR(100) NOT NULL,
    [IT_APPNAME2] VARCHAR(100) NULL,
    [IT_APPNAME3] VARCHAR(100) NULL,
    [IT_DOB1] DATETIME NOT NULL,
    [IT_DOB2] DATETIME NULL,
    [IT_DOB3] DATETIME NULL,
    [IT_GENDER1] VARCHAR(1) NOT NULL,
    [IT_GENDER2] VARCHAR(1) NULL,
    [IT_GENDER3] VARCHAR(1) NULL,
    [IT_FATHERHUSBAND] VARCHAR(100) NOT NULL,
    [IT_PAN1] VARCHAR(16) NOT NULL,
    [IT_PAN2] VARCHAR(16) NULL,
    [IT_PAN3] VARCHAR(16) NULL,
    [IT_CIRCLE1] VARCHAR(30) NOT NULL,
    [IT_CIRCLE2] VARCHAR(30) NULL,
    [IT_CIRCLE3] VARCHAR(30) NULL,
    [IT_MAPINFLAG] TINYINT NULL,
    [IT_MAPIN] VARCHAR(16) NULL,
    [IT_CATEGORY] VARCHAR(50) NULL,
    [IT_BM_ID] BIGINT NOT NULL,
    [IT_SBM_ID] BIGINT NOT NULL,
    [IT_NOMINEE] VARCHAR(100) NULL,
    [IT_NOMINEE_RELATION] VARCHAR(50) NULL,
    [IT_GUARDIANPAN] VARCHAR(16) NULL,
    [IT_DEPOSITORY] VARCHAR(10) NOT NULL,
    [IT_DPID] VARCHAR(16) NOT NULL,
    [IT_DPNAME] VARCHAR(100) NOT NULL,
    [IT_CLIENTDPID] VARCHAR(8) NOT NULL,
    [IT_BID_QTY1] INT NOT NULL,
    [IT_BID_PRICE1] NUMERIC(24, 4) NOT NULL,
    [IT_BID_QTY2] INT NOT NULL,
    [IT_BID_PRICE2] NUMERIC(24, 4) NOT NULL,
    [IT_BID_QTY3] INT NOT NULL,
    [IT_BID_PRICE3] NUMERIC(24, 4) NOT NULL,
    [IT_CUT_OFF1] TINYINT NOT NULL,
    [IT_CUT_OFF2] TINYINT NOT NULL,
    [IT_CUT_OFF3] TINYINT NOT NULL,
    [IT_PARTIAL_FLAG] TINYINT NOT NULL,
    [IT_PARTIAL_AMT] NUMERIC(24, 4) NOT NULL,
    [IT_APPNO] VARCHAR(100) NOT NULL,
    [IT_EXCHANGE_REFNO] VARCHAR(64) NULL,
    [IT_RTA_REFNO] VARCHAR(64) NULL,
    [IT_ORDER_TYPE] VARCHAR(24) NOT NULL,
    [IT_ORDER_STATUS] VARCHAR(24) NOT NULL,
    [IT_APP_PRINT_FLAG] TINYINT NOT NULL,
    [IT_STATUS] VARCHAR(24) NOT NULL,
    [IT_STATUS_MSG] VARCHAR(100) NULL,
    [IT_APPLIED_VALUE] NUMERIC(24, 4) NULL,
    [IT_ACCEPT_QTY] INT NULL,
    [IT_ACCEPT_PRICE] NUMERIC(24, 4) NULL,
    [IT_ACCEPT_DATE] DATETIME NULL,
    [IT_FINAL_STATUS] VARCHAR(24) NOT NULL,
    [IT_MODIFIEDBY] BIGINT NOT NULL,
    [IT_MODIFIEDDT] DATETIME NULL,
    [IT_UPDATEBY] BIGINT NULL,
    [IT_UPDATEDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER]
(
    [LDG_ID] NUMERIC(10, 0) IDENTITY(1,1) NOT NULL,
    [LDG_VOUCHER_TYPE] INT NULL,
    [LDG_VOUCHER_NO] NUMERIC(10, 0) NULL,
    [LDG_IPO_NO] VARCHAR(50) NULL,
    [LDG_VOUCHER_DT] DATETIME NULL,
    [LDG_ACCOUNT_ID] VARCHAR(16) NULL,
    [LDG_ACCOUNT_TYPE] CHAR(1) NULL,
    [LDG_GL_CODE] VARCHAR(100) NULL,
    [LDG_AMOUNT] MONEY NULL,
    [LDG_NARRATION] VARCHAR(250) NULL,
    [LDG_BANK_NAME] VARCHAR(400) NULL,
    [LDG_ACCOUNT_NO] VARCHAR(16) NULL,
    [LDG_INSTRUMENT_NO] VARCHAR(15) NULL,
    [LDG_BANK_CL_DATE] DATETIME NULL,
    [LDG_STATUS] VARCHAR(100) NULL,
    [LDG_BRANCH_ID] INT NULL,
    [LDG_REMARKS] VARCHAR(500) NULL,
    [LDG_CREATED_BY] VARCHAR(25) NOT NULL,
    [LDG_CREATED_DT] DATETIME NOT NULL,
    [LDG_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [LDG_LST_UPD_DT] DATETIME NOT NULL,
    [LDG_DELETED_IND] SMALLINT NOT NULL,
    [LDG_FROM_DT] DATETIME NULL,
    [LDG_TO_DT] DATETIME NULL,
    [LDG_INST_TYPE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LOGIN_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[LOGIN_LOG]
(
    [LL_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [LL_UM_ID] BIGINT NOT NULL,
    [LL_UM_USER_TYPE] TINYINT NOT NULL,
    [LL_IP_ADD] VARCHAR(20) NULL,
    [LL_ACTION] VARCHAR(6) NULL,
    [LL_ADDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OWNER
-- --------------------------------------------------
CREATE TABLE [dbo].[OWNER]
(
    [COMPANY] VARCHAR(50) NULL,
    [ADD1] VARCHAR(30) NULL,
    [ADD2] VARCHAR(30) NULL,
    [PHONE] VARCHAR(25) NULL,
    [ZIP] VARCHAR(6) NULL,
    [CITY] VARCHAR(20) NULL,
    [MEMBER_CODE] VARCHAR(15) NULL,
    [BANK_NAME] VARCHAR(50) NULL,
    [BANK_ADD] VARCHAR(50) NULL,
    [MAX_PARTYLEN] TINYINT NULL,
    [PREPRINT_CHQ] CHAR(1) NULL,
    [SEBI_REGNO] VARCHAR(15) NULL,
    [PAN] VARCHAR(50) NULL,
    [FAX] VARCHAR(25) NULL,
    [STATE] VARCHAR(50) NULL,
    [AUTOGEN_PARTYCODE] INT NULL,
    [MIN_PWD_LENGTH] TINYINT NULL,
    [MAX_PWD_LENGTH] TINYINT NULL,
    [SPCL_CHAR] VARCHAR(1) NULL,
    [ENCRYPTED] VARCHAR(1) NULL,
    [BLOCKED_PWD] VARCHAR(200) NULL,
    [CHECK_BALANCE] VARCHAR(20) NULL,
    [POST_LEDGER] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SUBBROKER_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[SUBBROKER_MASTER]
(
    [SBM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [SBM_CODE] VARCHAR(50) NOT NULL,
    [SBM_NAME] VARCHAR(100) NOT NULL,
    [SBM_ADD1] VARCHAR(100) NOT NULL,
    [SBM_ADD2] VARCHAR(100) NULL,
    [SBM_ADD3] VARCHAR(100) NULL,
    [SBM_CITY] VARCHAR(64) NOT NULL,
    [SBM_STATE] VARCHAR(64) NOT NULL,
    [SBM_COUNTRY] VARCHAR(64) NOT NULL,
    [SBM_PINCODE] VARCHAR(10) NOT NULL,
    [SBM_CONTACTPERSON] VARCHAR(100) NULL,
    [SBM_OFFICE_CONTACT] VARCHAR(15) NULL,
    [SBM_FAX] VARCHAR(15) NULL,
    [SBM_EMAILID] VARCHAR(50) NULL,
    [SBM_MODIFIEDBY] BIGINT NOT NULL,
    [SBM_MODIFIEDDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Dp_client_master_ipo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Dp_client_master_ipo]
(
    [cm_firstname] CHAR(100) NULL,
    [boid] CHAR(16) NULL,
    [cm_acc_closuredate] VARCHAR(8) NULL,
    [cm_acctype] VARCHAR(1) NOT NULL,
    [cm_active] VARCHAR(6) NOT NULL,
    [cm_add1] VARCHAR(30) NOT NULL,
    [cm_add2] VARCHAR(30) NOT NULL,
    [cm_add3] VARCHAR(30) NOT NULL,
    [cm_bankname] VARCHAR(8000) NOT NULL,
    [cm_blsavingcd] VARCHAR(20) NOT NULL,
    [cm_bostatementcycle] CHAR(2) NULL,
    [cm_brboffcode] VARCHAR(8000) NULL,
    [cm_brcode] VARCHAR(8000) NOT NULL,
    [cm_cd] VARCHAR(20) NULL,
    [cm_chgsscheme] VARCHAR(200) NULL,
    [cm_city] VARCHAR(25) NOT NULL,
    [cm_clienttype] VARCHAR(1) NOT NULL,
    [cm_country] VARCHAR(25) NOT NULL,
    [cm_dateofbirth] VARCHAR(8) NULL,
    [cm_divbankacno] VARCHAR(50) NULL,
    [cm_divbankccy] VARCHAR(100) NULL,
    [cm_divbankcode] VARCHAR(12) NULL,
    [cm_divbranchno] VARCHAR(2) NOT NULL,
    [cm_dpintrefno] VARCHAR(20) NULL,
    [cm_email] CHAR(50) NULL,
    [cm_lastname] CHAR(20) NULL,
    [cm_micr] VARCHAR(12) NULL,
    [cm_middlename] CHAR(20) NULL,
    [cm_mobile] VARCHAR(17) NULL,
    [cm_name] VARCHAR(150) NULL,
    [cm_occupation] CHAR(4) NULL,
    [cm_opendate] VARCHAR(8) NULL,
    [cm_pin] VARCHAR(10) NOT NULL,
    [cm_poaforpayin] VARCHAR(1) NOT NULL,
    [cm_poaregdate] VARCHAR(8) NOT NULL,
    [cm_productcd] VARCHAR(1) NOT NULL,
    [cm_sech_name] VARCHAR(142) NULL,
    [cm_state] VARCHAR(25) NOT NULL,
    [cm_tele1] VARCHAR(17) NULL,
    [cm_thih_name] VARCHAR(142) NULL,
    [cm_title] VARCHAR(1) NOT NULL,
    [IS POA] VARCHAR(1) NOT NULL,
    [Master POA ID] CHAR(16) NOT NULL,
    [cm_freezedt] VARCHAR(8000) NULL,
    [cm_freezereason] VARCHAR(200) NOT NULL,
    [cm_freezeyn] VARCHAR(1) NOT NULL,
    [cb_add1] VARCHAR(30) NOT NULL,
    [cb_add2] VARCHAR(30) NOT NULL,
    [cb_add3] VARCHAR(30) NOT NULL,
    [cb_annualincome] VARCHAR(100) NULL,
    [cb_bankadd1] VARCHAR(30) NOT NULL,
    [cb_bankadd2] VARCHAR(30) NOT NULL,
    [cb_bankadd3] VARCHAR(30) NOT NULL,
    [cb_bankbranch] VARCHAR(200) NULL,
    [cb_bosettlementplanflag] CHAR(1) NULL,
    [cb_city] VARCHAR(25) NOT NULL,
    [cb_cmcd] VARCHAR(20) NULL,
    [cb_country] VARCHAR(25) NOT NULL,
    [cb_degree] CHAR(4) NULL,
    [cb_dividendcurrency] VARCHAR(1) NOT NULL,
    [cb_fathername] VARCHAR(50) NULL,
    [cb_formno] VARCHAR(20) NULL,
    [cb_geographical] CHAR(4) NULL,
    [cb_language] VARCHAR(100) NULL,
    [cb_lifestyle] VARCHAR(1) NOT NULL,
    [cb_nationality] CHAR(3) NULL,
    [cb_nominee] VARCHAR(142) NULL,
    [cb_nominee_dob] VARCHAR(8) NULL,
    [cb_nomineeadd1] VARCHAR(30) NULL,
    [cb_nomineeadd2] VARCHAR(30) NULL,
    [cb_nomineeadd3] VARCHAR(30) NULL,
    [cb_nomineecity] VARCHAR(25) NULL,
    [cb_nomineecountry] VARCHAR(25) NULL,
    [cb_nomineepin] VARCHAR(10) NULL,
    [cb_nomineestate] VARCHAR(25) NULL,
    [cb_panno] VARCHAR(25) NULL,
    [cb_pin] VARCHAR(10) NOT NULL,
    [cb_sechfathername] VARCHAR(50) NULL,
    [cb_sechlastname] VARCHAR(20) NULL,
    [cb_sechmiddle] VARCHAR(20) NULL,
    [cb_sechpanno] VARCHAR(25) NULL,
    [cb_sechtitle] VARCHAR(1) NOT NULL,
    [cb_setupdate] VARCHAR(1) NOT NULL,
    [cb_sexcode] CHAR(1) NOT NULL,
    [cb_state] VARCHAR(25) NOT NULL,
    [cb_tele1] VARCHAR(17) NULL,
    [cb_thirdfathername] VARCHAR(50) NULL,
    [cb_thirdlastname] VARCHAR(20) NULL,
    [cb_thirdmiddle] VARCHAR(20) NULL,
    [cb_thirdpanno] VARCHAR(25) NULL,
    [cb_thirdtitle] VARCHAR(1) NOT NULL,
    [cb_voicemail] VARCHAR(20) NULL,
    [Last_Modified_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_IPO_INTMSTR
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_IPO_INTMSTR]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [RECORD_TYPE] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(25) NULL,
    [ISIN] VARCHAR(100) NULL,
    [QTY_LIMIT] NUMERIC(18, 3) NULL,
    [FROMDATE] DATETIME NULL,
    [TODATE] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL,
    [ADDED_ON] DATETIME NULL,
    [REMARKS] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_VCODE_MSTR
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_VCODE_MSTR]
(
    [TBL_VC_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [TBL_VC_TYPE] CHAR(1) NULL,
    [TBL_VC_CODE] VARCHAR(50) NULL,
    [TBL_VC_FLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMIN
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMIN]
(
    [fldauto_admin] INT IDENTITY(1,1) NOT NULL,
    [fldname] NVARCHAR(30) NOT NULL,
    [fldpassword] VARCHAR(512) NULL,
    [fldcompany] NVARCHAR(50) NULL,
    [fldstname] NVARCHAR(50) NULL,
    [fldstatus] NVARCHAR(25) NOT NULL,
    [flddesc] NVARCHAR(100) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDUSERSTATUS] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDROLE] SMALLINT NULL,
    [FLDRIGHTS] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMIN_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMIN_LOG]
(
    [Fldauto_Admin] INT NOT NULL,
    [Fldname] VARCHAR(30) NOT NULL,
    [Fldpassword] VARCHAR(512) NULL,
    [Fldcompany] VARCHAR(50) NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Fldstatus] VARCHAR(25) NOT NULL,
    [Flddesc] VARCHAR(100) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDUSERSTATUS] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDROLE] SMALLINT NULL,
    [FLDRIGHTS] SMALLINT NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINEIP] VARCHAR(20) NULL,
    [FLDLOG_DATA] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMINCONFIG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMINCONFIG]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldadmin] VARCHAR(50) NULL,
    [Fldflag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLADMINPASSHIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLADMINPASSHIST]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDADMINID] INT NULL,
    [FLDOLDPASSLISTING] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATEGORY
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATEGORY]
(
    [fldcategorycode] INT IDENTITY(1,1) NOT NULL,
    [fldcategoryname] NVARCHAR(50) NOT NULL,
    [fldadminauto] INT NULL,
    [flddesc] NVARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATEGORY_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATEGORY_LOG]
(
    [Fldcategorycode] INT NOT NULL,
    [Fldcategoryname] VARCHAR(50) NOT NULL,
    [Fldadminauto] INT NULL,
    [Flddesc] VARCHAR(80) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATMENU
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATMENU]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldreportcode] INT NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldcategorycode] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCATMENU_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCATMENU_LOG]
(
    [Fldreportcode] INT NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldcategorycode_OLD] VARCHAR(2000) NULL,
    [Fldcategorycode_NEW] VARCHAR(2000) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINE_IP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCLASSADMINLOGINS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCLASSADMINLOGINS]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDAUTO] BIGINT NULL,
    [FLDADMINNAME] VARCHAR(50) NULL,
    [FLDSTATUS] VARCHAR(25) NULL,
    [FLDSTNAME] VARCHAR(50) NULL,
    [FLDSESSION] VARCHAR(200) NULL,
    [FLDIPADDRESS] VARCHAR(20) NULL,
    [FLDLASTVISIT] DATETIME NULL,
    [FLDTIMEOUTPRD] INT NULL,
    [FLDLASTLOGIN] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLCLASSUSERLOGINS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLCLASSUSERLOGINS]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDAUTO] BIGINT NULL,
    [FLDUSERNAME] VARCHAR(50) NULL,
    [FLDSTATUS] VARCHAR(25) NULL,
    [FLDSTNAME] VARCHAR(50) NULL,
    [FLDSESSION] VARCHAR(200) NULL,
    [FLDIPADDRESS] VARCHAR(20) NULL,
    [FLDLASTVISIT] DATETIME NULL,
    [FLDTIMEOUTPRD] INT NULL,
    [FLDLASTLOGIN] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLGLOBALPARAMS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLGLOBALPARAMS]
(
    [FLDPWDMINLENGTH] SMALLINT NULL,
    [FLDPWDMAXLENGTH] SMALLINT NULL,
    [FLDSPCLCHAR] CHAR(1) NULL,
    [FLDENCRYPTION] CHAR(1) NULL,
    [FLDBLOCKPWD] VARCHAR(255) NULL,
    [FLDDELBLOCK] CHAR(1) NULL,
    [fldlastins] BIGINT NULL,
    [fldlastdel] BIGINT NULL,
    [fldlastupdt] BIGINT NULL,
    [fldupdtdate] DATETIME NULL,
    [fldclientMakerCheker] INT NULL,
    [fldAutoCodeGenerate] INT NULL,
    [fldflag] VARCHAR(3) NULL,
    [fldreportflag] VARCHAR(3) NULL,
    [fldCheckClientProcess] VARCHAR(1) NULL,
    [fldBranchAdd] TINYINT NULL,
    [BranchFlag] CHAR(1) NULL,
    [FldPwdAlphaNumOnly] INT NULL,
    [FLDOLDPASSWORD] TINYINT NULL,
    [FLDPANVALIDATION] CHAR(1) NULL,
    [FLDPARTYCODEBY] VARCHAR(10) NULL,
    [ALLOW_MULTI_LOGIN] INT NULL,
    [MAX_REJECTION_ALLOW] SMALLINT NULL,
    [MAC_ID_VALIDATION] INT NULL,
    [MKCKFLAG] SMALLINT NULL,
    [FldAddRpt] SMALLINT NULL,
    [FldCaptcha] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLMENUHEAD
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLMENUHEAD]
(
    [fldmenucode] NVARCHAR(20) NULL,
    [fldmenuname] NVARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLPRADNYAUSERS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLPRADNYAUSERS]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldusername] NVARCHAR(25) NULL,
    [fldpassword] VARCHAR(512) NULL,
    [fldfirstname] NVARCHAR(25) NULL,
    [fldmiddlename] NVARCHAR(25) NULL,
    [fldlastname] NVARCHAR(25) NULL,
    [fldsex] NVARCHAR(8) NULL,
    [fldaddress1] VARCHAR(100) NULL,
    [fldaddress2] VARCHAR(100) NULL,
    [fldphone1] NVARCHAR(10) NULL,
    [fldphone2] NVARCHAR(10) NULL,
    [fldcategory] NVARCHAR(10) NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldstname] NVARCHAR(50) NULL,
    [PWD_EXPIRY_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLPRADNYAUSERS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLPRADNYAUSERS_LOG]
(
    [Fldauto] INT NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(512) NULL,
    [Fldfirstname] VARCHAR(25) NULL,
    [Fldmiddlename] VARCHAR(25) NULL,
    [Fldlastname] VARCHAR(25) NULL,
    [Fldsex] VARCHAR(8) NULL,
    [Fldaddress1] VARCHAR(100) NULL,
    [Fldaddress2] VARCHAR(100) NULL,
    [Fldphone1] VARCHAR(10) NULL,
    [Fldphone2] VARCHAR(10) NULL,
    [Fldcategory] VARCHAR(10) NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldstname] VARCHAR(50) NULL,
    [Pwd_Expiry_Date] DATETIME NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL,
    [MachineIP] VARCHAR(20) NULL,
    [FLDLOG_DATA] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTGRP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTGRP]
(
    [fldreportgrp] INT IDENTITY(1,1) NOT NULL,
    [fldgrpname] NVARCHAR(35) NULL,
    [fldmenugrp] NVARCHAR(3) NULL,
    [flddesc] NVARCHAR(80) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTGRP_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTGRP_LOG]
(
    [Fldreportgrp] INT NOT NULL,
    [Fldgrpname] VARCHAR(35) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTS]
(
    [fldreportcode] INT IDENTITY(1,1) NOT NULL,
    [fldreportname] NVARCHAR(50) NULL,
    [fldpath] NVARCHAR(100) NULL,
    [fldtarget] NVARCHAR(25) NULL,
    [flddesc] NVARCHAR(80) NULL,
    [fldreportgrp] NVARCHAR(10) NULL,
    [fldmenugrp] NVARCHAR(3) NULL,
    [fldstatus] NVARCHAR(20) NULL,
    [fldorder] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTS_BLOCKED
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTS_BLOCKED]
(
    [fldusername] VARCHAR(25) NOT NULL,
    [fldcategory] VARCHAR(10) NOT NULL,
    [fldadminauto] INT NOT NULL,
    [fldstatus] VARCHAR(25) NOT NULL,
    [Block_Flag] INT NOT NULL,
    [Fldreportcode] INT NOT NULL,
    [fldpath] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLREPORTS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLREPORTS_LOG]
(
    [Fldreportcode] INT NOT NULL,
    [Fldreportname] VARCHAR(35) NULL,
    [Fldpath] VARCHAR(500) NULL,
    [Fldtarget] VARCHAR(25) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [Fldreportgrp] VARCHAR(10) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Fldstatus] VARCHAR(20) NULL,
    [Fldorder] INT NOT NULL,
    [EDIT_FLAG] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(30) NULL,
    [CREATED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERBLOCK
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERBLOCK]
(
    [FLDAUTO] INT NOT NULL,
    [FLDNAME] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERCONTROLGLOBALS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERCONTROLGLOBALS]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDCATEGORYID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERCONTROLMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERCONTROLMASTER]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDUSERID] INT NOT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDSTATUS] SMALLINT NULL,
    [FLDLOGINFLAG] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERCONTROLMASTER_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERCONTROLMASTER_JRNL]
(
    [FLDAUTO] BIGINT NULL,
    [FLDUSERID] INT NULL,
    [FLDPWDEXPIRY] INT NULL,
    [FLDMAXATTEMPT] SMALLINT NULL,
    [FLDATTEMPTCNT] SMALLINT NULL,
    [FLDSTATUS] SMALLINT NULL,
    [FLDLOGINFLAG] SMALLINT NULL,
    [FLDACCESSLVL] CHAR(1) NULL,
    [FLDIPADD] VARCHAR(2000) NULL,
    [FLDTIMEOUT] SMALLINT NULL,
    [FLDFIRSTLOGIN] CHAR(1) NULL,
    [FLDFORCELOGOUT] SMALLINT NULL,
    [FLDUPDTBY] VARCHAR(64) NULL,
    [FLDUPDTDT] DATETIME NULL,
    [FLD_MAC_ID] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERPASSHIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERPASSHIST]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [FLDUSERID] INT NULL,
    [FLDOLDPASSLISTING] VARCHAR(2000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERS
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERS]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [PRADNYAAUTO] INT NULL,
    [REMARK] VARCHAR(200) NULL,
    [MAX_EDIT] TINYINT NULL,
    [BLOCK] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLUSERS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLUSERS_LOG]
(
    [FLDAUTO] INT NULL,
    [PRADNYAAUTO] INT NULL,
    [REMARK] VARCHAR(200) NULL,
    [MAX_EDIT] TINYINT NULL,
    [BLOCK] CHAR(1) NULL,
    [CREATED_BY] VARCHAR(20) NULL,
    [CREATED_ON] DATETIME NULL,
    [MACHINEIP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.USER_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[USER_MASTER]
(
    [UM_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [UM_CODE] VARCHAR(50) NOT NULL,
    [UM_PWD] VARCHAR(50) NOT NULL,
    [UM_USER_TYPE] TINYINT NOT NULL,
    [UM_NAME] VARCHAR(100) NOT NULL,
    [UM_ADD1] VARCHAR(100) NOT NULL,
    [UM_ADD2] VARCHAR(100) NULL,
    [UM_ADD3] VARCHAR(100) NULL,
    [UM_CITY] VARCHAR(64) NOT NULL,
    [UM_STATE] VARCHAR(64) NOT NULL,
    [UM_COUNTRY] VARCHAR(64) NOT NULL,
    [UM_PINCODE] VARCHAR(10) NOT NULL,
    [UM_OFFICE_CONTACT] VARCHAR(15) NULL,
    [UM_RESI_CONTACT] VARCHAR(15) NULL,
    [UM_FAX] VARCHAR(15) NULL,
    [UM_EMAILID] VARCHAR(50) NULL,
    [UM_OCCUPATION] VARCHAR(50) NULL,
    [UM_TAX_STATUS] VARCHAR(50) NULL,
    [UM_ANNUALINCOME] DECIMAL(24, 2) NULL,
    [UM_MAXTRY] SMALLINT NOT NULL,
    [UM_RETRIES] SMALLINT NOT NULL,
    [UM_MODIFIEDBY] BIGINT NOT NULL,
    [UM_MODIFIEDDT] DATETIME NOT NULL,
    [UM_ACCESS_LVL] VARCHAR(1) NULL,
    [UM_IP_ADD] VARCHAR(2000) NULL,
    [UM_SESSION] VARCHAR(200) NULL,
    [UM_FIRST_LOGIN] VARCHAR(1) NULL,
    [UM_PASSWORD_EXPIRY] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.USER_MASTER_JRNL
-- --------------------------------------------------
CREATE TABLE [dbo].[USER_MASTER_JRNL]
(
    [UM_ID_JRNL] BIGINT IDENTITY(1,1) NOT NULL,
    [UM_ID] BIGINT NOT NULL,
    [UM_CODE] VARCHAR(50) NOT NULL,
    [UM_PWD] VARCHAR(50) NOT NULL,
    [UM_USER_TYPE] TINYINT NOT NULL,
    [UM_NAME] VARCHAR(100) NOT NULL,
    [UM_ADD1] VARCHAR(100) NOT NULL,
    [UM_ADD2] VARCHAR(100) NULL,
    [UM_ADD3] VARCHAR(100) NULL,
    [UM_CITY] VARCHAR(64) NOT NULL,
    [UM_STATE] VARCHAR(64) NOT NULL,
    [UM_COUNTRY] VARCHAR(64) NOT NULL,
    [UM_PINCODE] VARCHAR(10) NOT NULL,
    [UM_OFFICE_CONTACT] VARCHAR(15) NULL,
    [UM_RESI_CONTACT] VARCHAR(15) NULL,
    [UM_FAX] VARCHAR(15) NULL,
    [UM_EMAILID] VARCHAR(50) NULL,
    [UM_OCCUPATION] VARCHAR(50) NULL,
    [UM_TAX_STATUS] VARCHAR(50) NULL,
    [UM_ANNUALINCOME] DECIMAL(24, 2) NULL,
    [UM_MAXTRY] SMALLINT NOT NULL,
    [UM_RETRIES] SMALLINT NOT NULL,
    [UM_MODIFIEDBY] BIGINT NOT NULL,
    [UM_MODIFIEDDT] DATETIME NOT NULL,
    [UM_ACCESS_LVL] VARCHAR(1) NULL,
    [UM_IP_ADD] VARCHAR(2000) NULL,
    [UM_SESSION] VARCHAR(200) NULL,
    [UM_FIRST_LOGIN] VARCHAR(1) NULL,
    [UM_PASSWORD_EXPIRY] DATETIME NULL,
    [UM_ALTERBY] BIGINT NOT NULL,
    [UM_ALTERDT] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.USERDISABLED_LIST
-- --------------------------------------------------
CREATE TABLE [dbo].[USERDISABLED_LIST]
(
    [USERID] BIGINT NULL,
    [USERSTATUS] SMALLINT NULL,
    [MODEFLAG] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_LOGIN_ERR_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_LOGIN_ERR_LOG]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOGIN_ID] VARCHAR(20) NULL,
    [LOGIN_PWD] VARCHAR(512) NULL,
    [IPADD] VARCHAR(20) NULL,
    [ERR_TYPE] VARCHAR(20) NULL,
    [LOGIN_TYPE] VARCHAR(10) NULL,
    [LOGIN_DT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_LOGIN_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_LOGIN_LOG]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [USERID] INT NULL,
    [USERNAME] VARCHAR(64) NULL,
    [CATEGORY] VARCHAR(64) NULL,
    [STATUSNAME] VARCHAR(32) NULL,
    [STATUSID] VARCHAR(32) NULL,
    [IPADD] VARCHAR(20) NULL,
    [ACTION] VARCHAR(6) NULL,
    [ADDDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Report_Access_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [RepPath] VARCHAR(4000) NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(50) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusID] VARCHAR(32) NULL,
    [IPAdd] VARCHAR(20) NULL,
    [AddDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.BRANCH
-- --------------------------------------------------

CREATE VIEW [dbo].[BRANCH] AS
SELECT Branch_Code,Branch,Long_Name,Address1,Address2,City,State,Nation,Zip,Phone1,Phone2,Fax,Email,Remote,Security_Net,Money_Net,Excise_Reg,Contact_Person,
Prefix,SharingType='',Trd_Sharing=0,Del_Sharing=0,Trd_Charges=0,Del_Charges=0,REMPARTYCODE FROM MSAJAG.DBO.BRANCH
UNION 
SELECT BRANCH_CODE='HO',BRANCH='HO',Long_Name='HO',
Address1='',Address2='',City='',State='',Nation='',Zip='',Phone1='',Phone2='',Fax='',Email='',
Remote=0,Security_Net=0,Money_Net=0,Excise_Reg='',Contact_Person='',Prefix='',SharingType='',
Trd_Sharing=0,Del_Sharing=0,Trd_Charges=0,Del_Charges=0,RemPartyCode=''

GO

-- --------------------------------------------------
-- VIEW dbo.OWNER_MASTER
-- --------------------------------------------------


CREATE VIEW OWNER_MASTER AS
SELECT 
	COMPANY	 AS OM_COMPANY,
	ADD1	 AS OM_ADD1,
	ADD2	 AS OM_ADD2,
	PHONE	 AS OM_PHONE,
	ZIP	 AS OM_ZIP,
	CITY	 AS OM_CITY,
	MEMBER_CODE	 AS OM_MEMBER_CODE,
	BANK_NAME	 AS OM_BANK_NAME,
	BANK_ADD	 AS OM_BANK_ADD,
	MAX_PARTYLEN	 AS OM_MAX_PARTYLEN,
	PREPRINT_CHQ	 AS OM_PREPRINT_CHQ,
	SEBI_REGNO	 AS OM_SEBI_REGNO,
	PAN	 AS OM_PAN,
	FAX	 AS OM_FAX,
	STATE	 AS OM_STATE,
	AUTOGEN_PARTYCODE	 AS OM_AUTOGEN_PARTYCODE,
	MIN_PWD_LENGTH	 AS OM_MIN_PWD_LENGTH,
	MAX_PWD_LENGTH	 AS OM_MAX_PWD_LENGTH,
	SPCL_CHAR	 AS OM_SPCL_CHAR,
	ENCRYPTED	 AS OM_ENCRYPTED,
	BLOCKED_PWD	 AS OM_BLOCKED_PWD,
	CHECK_BALANCE	 AS OM_CHECK_BALANCE,
	POST_LEDGER	 AS OM_POST_LEDGER
FROM [OWNER]

GO

-- --------------------------------------------------
-- VIEW dbo.SUBBROKERS
-- --------------------------------------------------
CREATE VIEW [dbo].[SUBBROKERS]

AS
SELECT * 
  FROM   BAK_SUBBROKERS

GO

-- --------------------------------------------------
-- VIEW dbo.VW_EXCEPTION_LIST
-- --------------------------------------------------
CREATE VIEW [dbo].[VW_EXCEPTION_LIST] AS
SELECT DISPVAL = 'INTEREST CHARGE', STOREVAL = 'INTCHRG'
UNION ALL
SELECT DISPVAL = 'MIN INTEREST CHARGE', STOREVAL = 'MININTCHRG'
UNION ALL
SELECT DISPVAL = 'MAX FUNDING LIMIT', STOREVAL = 'MAXFUNDLMT'
UNION ALL
SELECT DISPVAL = 'CUTOFFTIME', STOREVAL = 'CUTOFFTIME'

GO

