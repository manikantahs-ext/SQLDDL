-- DDL Export
-- Server: 10.254.33.27
-- Database: NSEMFSS
-- Exported: 2026-02-05T11:26:25.396282

USE NSEMFSS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.awsdms_fn_LsnSegmentToHexa
-- --------------------------------------------------
        
CREATE FUNCTION [dbo].[awsdms_fn_LsnSegmentToHexa] (@InputData VARBINARY(32)) RETURNS VARCHAR(64)
AS
  BEGIN
    DECLARE  @HexDigits   	CHAR(16),
             @OutputData      VARCHAR(64),
             @i           	INT,
             @InputDataLength INT

    DECLARE  @ByteInfo  	INT,
             @LeftNibble 	INT,
             @RightNibble INT

    SET @OutputData = ''

    SET @i = 1

    SET @InputDataLength = DATALENGTH(@InputData)

    SET @HexDigits = '0123456789abcdef'

    WHILE (@i <= @InputDataLength)
      BEGIN
        SET @ByteInfo = CONVERT(INT,SUBSTRING(@InputData,@i,1))
        SET @LeftNibble= FLOOR(@ByteInfo / 16)
        SET @RightNibble = @ByteInfo - (@LeftNibble* 16)
        SET @OutputData = @OutputData + SUBSTRING(@HexDigits,@LeftNibble+ 1,1) + SUBSTRING(@HexDigits,@RightNibble + 1,1)
        SET @i = @i + 1
      END

    RETURN @OutputData

  END

GO

-- --------------------------------------------------
-- FUNCTION dbo.awsdms_fn_NumericLsnToHexa
-- --------------------------------------------------
        
CREATE FUNCTION [dbo].[awsdms_fn_NumericLsnToHexa](@numeric25Lsn numeric(25,0)) returns varchar(32)
 AS
 BEGIN
-- In order to avoid form sign overflow problems - declare the LSN segments 
-- to be one 'type' larger than the intendent target type.
-- For example, convert(smallint, convert(numeric(25,0),65535)) will fail 
-- but convert(binary(2), convert(int,convert(numeric(25,0),65535))) will give the 
-- expected result of 0xffff.

declare @high4bytelsnSegment bigint,@mid4bytelsnSegment bigint,@low2bytelsnSegment int
declare @highFactor bigint, @midFactor int

declare @lsnLeftSeg	binary(4)
declare @lsnMidSeg	binary(4)
declare @lsnRightSeg	binary(2)

declare	@hexaLsn	varchar(32)

select @highFactor = 1000000000000000
select @midFactor  = 100000

select @high4bytelsnSegment = convert(bigint, floor(@numeric25Lsn / @highFactor))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @high4bytelsnSegment) * @highFactor
select @mid4bytelsnSegment = convert(bigint,floor(@numeric25Lsn / @midFactor ))
select @numeric25Lsn = @numeric25Lsn - convert(numeric(25,0), @mid4bytelsnSegment) * @midFactor
select @low2bytelsnSegment = convert(int, @numeric25Lsn)

set	@lsnLeftSeg	= convert(binary(4), @high4bytelsnSegment)
set	@lsnMidSeg	= convert(binary(4), @mid4bytelsnSegment)
set   @lsnRightSeg	= convert(binary(2), @low2bytelsnSegment)

return [dbo].[awsdms_fn_LsnSegmentToHexa](@lsnLeftSeg)+':'+[dbo].[awsdms_fn_LsnSegmentToHexa](@lsnMidSeg)+':'+[dbo].[awsdms_fn_LsnSegmentToHexa](@lsnRightSeg)
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FN_SERIES_NAME
-- --------------------------------------------------
CREATE  FUNCTION FN_SERIES_NAME (@SERIES_ID VARCHAR(3) ) 
RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @SERIES_NAME VARCHAR(20)
	SELECT @SERIES_NAME = CASE 
					WHEN @SERIES_ID = 'DP' THEN ' - Dividend Payout'
					WHEN @SERIES_ID = 'DR' THEN ' - Dividend ReInvest' 
					WHEN @SERIES_ID = 'GR' THEN ' - Growth' 
				ELSE @SERIES_ID END

	RETURN @SERIES_NAME

END

GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_ucc_entp
-- --------------------------------------------------

CREATE function [fn_ucc_entp](@pa_crn_no     NUMERIC
                          ,@pa_entp_cd    VARCHAR(20)
                          ,@pa_exch       CHAR(4)  
                          )
RETURNS VARCHAR(50)
AS
BEGIN
--
  DECLARE @l_entp_entpm_cd      VARCHAR(22)
        , @l_entp_value         VARCHAR(25)
        , @l_lst_upd_dt         datetime
  --   
if Right(@pa_entp_cd,4)='_HST'
  BEGIN 
	SELECT @l_entp_entpm_cd  =T.entp_entpm_cd,@l_entp_value         =T.entp_value FROM 
	(
	  SELECT  TOP 2  entp_entpm_cd
		   ,  entp_value 
		   , entp_lst_upd_dt
	  FROM   entp_hst   
	  WHERE  entp_entpm_cd         = LEFT(@pa_entp_cd,LEN(@pa_entp_cd)-LEN(RIGHT(@pa_entp_cd,4)))--Left(@pa_entp_cd,10)
	  AND    entp_ent_id           = @pa_crn_no
	  AND    entp_deleted_ind      = 1
	  and    entp_action           ='E'
	  order by entp_lst_upd_dt desc
	) T
	ORDER BY t.entp_lst_upd_dt desc

  END
  ELSE
  BEGIN   
  SELECT @l_entp_entpm_cd      = entp_entpm_cd
       , @l_entp_value         = entp_value 
  FROM   entity_properties      
  WHERE  entp_entpm_cd         = @pa_entp_cd
  AND    entp_ent_id           = @pa_crn_no
  AND    entp_deleted_ind      = 1
  --
  END
  /*RETURN CASE WHEN @pa_exch    = 'NSE' THEN 
                ISNULL(CONVERT(VARCHAR(30), @l_entp_value),'')
              WHEN @pa_exch    = 'BSE' THEN
                ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')
              WHEN @pa_exch    = 'MCX' THEN
                ISNULL(CONVERT(VARCHAR(25), @l_entp_value),'')
              END
 */
 RETURN ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')  
--
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_CATEGORY_PAYIN
-- --------------------------------------------------
CREATE FUNCTION FUN_CATEGORY_PAYIN(@NOOFDAY	INT, @TDATE	DATETIME) Returns DATETIME
AS
BEGIN
	DECLARE @PDATE	DATETIME,
			@PAYCUR	CURSOR

	SET @PDATE = @TDATE

	SET @PAYCUR	= CURSOR FOR
	SELECT DISTINCT START_DATE FROM SETT_MST WHERE START_DATE >= @TDATE
	ORDER BY 1
	OPEN @PAYCUR
	FETCH NEXT FROM @PAYCUR INTO @PDATE
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @NOOFDAY = @NOOFDAY - 1
		IF @NOOFDAY >= 0 
			FETCH NEXT FROM @PAYCUR INTO @PDATE
		ELSE
		BEGIN
			RETURN (@PDATE)
		END
	END
	CLOSE @PAYCUR
	DEALLOCATE @PAYCUR

	RETURN (@PDATE)
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.FUN_SPLITSTRING
-- --------------------------------------------------
  
create  FUNCTION [dbo].[FUN_SPLITSTRING](  
                @SPLITSTRING VARCHAR(8000),  
                @DELIMITER   VARCHAR(3))  
RETURNS @SPLITTED TABLE (  
    [SNO] [INT] IDENTITY(1,1) NOT NULL,   
    [SPLITTED_VALUE] [VARCHAR](100) NOT NULL)  
  
AS  
  
/* Split the String and get splitted values in the result-set. Delimiter upto 3 characters long can be used for splitting */  
BEGIN     
  DECLARE  @STRING         VARCHAR(8000),  
           @POSITION       INT,  
           @START_LOCATION INT,  
           @STRING_LENGTH  INT  
                             
  SET @STRING = @SPLITSTRING  
                  
  SET @POSITION = 0  
                    
  SET @START_LOCATION = 0  
                          
  SET @STRING_LENGTH = LEN(@STRING)  
                         
  WHILE @STRING_LENGTH > 0  
    BEGIN  
      
      SET @POSITION = CHARINDEX(@DELIMITER,@STRING,@START_LOCATION)  
                        
      IF @POSITION = 0  
        BEGIN  
          INSERT INTO @SPLITTED  
          SELECT @STRING  
                   
          SET @STRING_LENGTH = 0  
                                 
        END  
      ELSE  
        BEGIN  
          INSERT INTO @SPLITTED  
          SELECT LEFT(@STRING,@POSITION - 1)  
                   
          SET @STRING = RIGHT(@STRING,@STRING_LENGTH - @POSITION)  
                          
          SET @STRING_LENGTH = LEN(@STRING)  
        END  
          
    END  
  
  RETURN   
  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.UFN_LOGINCHECK
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branch] ON [dbo].[BRANCH] ([BRANCH], [BRANCH_CODE], [LONG_NAME])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Brcode] ON [dbo].[BRANCH] ([BRANCH_CODE], [BRANCH])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCHES
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branches] ON [dbo].[BRANCHES] ([SHORT_NAME], [BRANCH_CD], [COM_PERC])

GO

-- --------------------------------------------------
-- INDEX dbo.BRANCHES
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Branchshort] ON [dbo].[BRANCHES] ([BRANCH_CD], [SHORT_NAME], [COM_PERC])

GO

-- --------------------------------------------------
-- INDEX dbo.broktable
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Bk] ON [dbo].[broktable] ([Table_No], [Line_No], [Trd_Del], [Val_perc], [Upper_lim])

GO

-- --------------------------------------------------
-- INDEX dbo.broktable
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Broktable_Upperlim] ON [dbo].[broktable] ([Trd_Del], [Def_table], [Table_No], [Upper_lim], [Line_No], [Val_perc], [Day_puc], [Day_Sales], [Sett_Purch])

GO

-- --------------------------------------------------
-- INDEX dbo.broktable
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Tabnouplim] ON [dbo].[broktable] ([Table_No], [Upper_lim], [Line_No], [Val_perc])

GO

-- --------------------------------------------------
-- INDEX dbo.broktable
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Upperlim] ON [dbo].[broktable] ([Trd_Del], [Def_table], [Table_No], [Upper_lim], [Line_No], [Val_perc], [Day_puc], [Day_Sales], [Sett_Purch], [sett_sales], [round_to])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENTSTATUS
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxSt] ON [dbo].[CLIENTSTATUS] ([CL_STATUS])

GO

-- --------------------------------------------------
-- INDEX dbo.clienttype
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxType] ON [dbo].[clienttype] ([Cl_Type])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltrans
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Delhold] ON [dbo].[Deltrans] ([Sett_No], [Sett_Type], [Party_Code], [Scrip_Cd], [Series], [Certno], [Trtype], [Filler2], [Drcr], [Bdptype], [Bdpid], [Bcltdpid])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltrans
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Delholdisett] ON [dbo].[Deltrans] ([Isett_No], [Isett_Type], [Party_Code], [Scrip_Cd], [Series], [Certno], [Trtype], [Filler2], [Drcr], [Bdptype], [Bdpid], [Bcltdpid])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltrans
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Sno] ON [dbo].[Deltrans] ([Sno])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltranspi
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxSettNo] ON [dbo].[Deltranspi] ([Sett_No], [Sett_Type], [Party_Code], [Scrip_Cd], [Series])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltranspi
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxSettNoFrom] ON [dbo].[Deltranspi] ([Sett_No], [Sett_Type], [Fromno])

GO

-- --------------------------------------------------
-- INDEX dbo.Deltranstemp
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Snoinx] ON [dbo].[Deltranstemp] ([Sno])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattrans
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Dematinx] ON [dbo].[Demattrans] ([Sno], [Sett_No], [Isin], [Cltaccno], [Drcr])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattrans
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Dint] ON [dbo].[Demattrans] ([Refno], [Sett_No], [Sett_Type], [Scrip_Cd], [Series], [Cltaccno], [Bdptype], [Bdpid], [Bcltaccno], [Trtype])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattransout
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Out] ON [dbo].[Demattransout] ([Sett_No], [Sett_Type], [Trtype], [Isin], [Bdptype])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattransspeed
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Delspeed] ON [dbo].[Demattransspeed] ([Transno], [Trdate], [Drcr], [Isin])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattransspeed
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [snospeed] ON [dbo].[Demattransspeed] ([Sno])

GO

-- --------------------------------------------------
-- INDEX dbo.Demattransspeed
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [trn_speed] ON [dbo].[Demattransspeed] ([Sett_No], [Isin], [Bdptype], [Bdpid], [Bcltaccno], [Transno])

GO

-- --------------------------------------------------
-- INDEX dbo.FINAL_MFSS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_F] ON [dbo].[FINAL_MFSS] ([PARTY_CODE], [CLTDPID], [PAN_NO])

GO

-- --------------------------------------------------
-- INDEX dbo.IMP_FilePath
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxFl] ON [dbo].[IMP_FilePath] ([File_Type])

GO

-- --------------------------------------------------
-- INDEX dbo.MFSS_CLIENT
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party] ON [dbo].[MFSS_CLIENT] ([PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.MFSS_CLMST_VALUES
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXTYPE] ON [dbo].[MFSS_CLMST_VALUES] ([V_TYPE])

GO

-- --------------------------------------------------
-- INDEX dbo.POBANK
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [iX_BANK] ON [dbo].[POBANK] ([BANKID])

GO

-- --------------------------------------------------
-- INDEX dbo.POBANK
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [iX_BANK_NAME] ON [dbo].[POBANK] ([BANK_NAME], [BRANCH_NAME]) INCLUDE ([BANKID])

GO

-- --------------------------------------------------
-- INDEX dbo.Speed_Temp
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxSrNo] ON [dbo].[Speed_Temp] ([Sett_No], [Sett_Type], [Party_Code], [Scrip_Cd], [Series])

GO

-- --------------------------------------------------
-- INDEX dbo.STATE_MASTER
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDXSTATE] ON [dbo].[STATE_MASTER] ([State])

GO

-- --------------------------------------------------
-- INDEX dbo.SUBBROKERS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxSb] ON [dbo].[SUBBROKERS] ([SUB_BROKER], [BRANCH_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.SUBBROKERS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [indSbBrok] ON [dbo].[SUBBROKERS] ([SUB_BROKER])

GO

-- --------------------------------------------------
-- INDEX dbo.TblAdmin
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblAdmin] ([Fldauto_Admin])

GO

-- --------------------------------------------------
-- INDEX dbo.TblAdminconfig
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblAdminconfig] ([Fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TblCategory
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [categoryidx] ON [dbo].[TblCategory] ([Fldcategorycode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblCatmenu
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxAdmin] ON [dbo].[TblCatmenu] ([Fldauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TBLCLASSUSERLOGINS
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IDXLOGIN] ON [dbo].[TBLCLASSUSERLOGINS] ([FLDUSERNAME], [FLDSESSION], [FLDIPADDRESS])

GO

-- --------------------------------------------------
-- INDEX dbo.TblMenuHead
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxMenu] ON [dbo].[TblMenuHead] ([Fldmenucode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblPradnyausers
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxUser] ON [dbo].[TblPradnyausers] ([Fldauto], [Fldadminauto])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReportgrp
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpr] ON [dbo].[TblReportgrp] ([Fldreportgrp], [Fldmenugrp])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReports
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxReport] ON [dbo].[TblReports] ([Fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.TblReports_Blocked
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxRpt] ON [dbo].[TblReports_Blocked] ([fldadminauto], [Fldreportcode])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlGlobals
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[tblUserControlGlobals] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [AutoIDx] ON [dbo].[tblUserControlMaster] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [UserIdidx] ON [dbo].[tblUserControlMaster] ([FLDUSERID])

GO

-- --------------------------------------------------
-- INDEX dbo.tblUserControlMaster_Jrnl
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxUser] ON [dbo].[tblUserControlMaster_Jrnl] ([FLDAUTO])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_Login_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxUser] ON [dbo].[V2_Login_Log] ([AddDt], [UserId])

GO

-- --------------------------------------------------
-- INDEX dbo.V2_Report_Access_Log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idxReport] ON [dbo].[V2_Report_Access_Log] ([RepPath])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.awsdms_truncation_safeguard
-- --------------------------------------------------
ALTER TABLE [dbo].[awsdms_truncation_safeguard] ADD CONSTRAINT [PK__awsdms_t__65C99AC8D4E98C7D] PRIMARY KEY ([latchTaskName], [latchMachineGUID], [LatchKey])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCH
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCH] ADD CONSTRAINT [Pk_Branch] PRIMARY KEY ([BRANCH_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BRANCHES
-- --------------------------------------------------
ALTER TABLE [dbo].[BRANCHES] ADD CONSTRAINT [PK_BRANCHES] PRIMARY KEY ([SHORT_NAME])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Delaccbalance
-- --------------------------------------------------
ALTER TABLE [dbo].[Delaccbalance] ADD CONSTRAINT [PK_Delaccbalance] PRIMARY KEY ([Cltcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Demattrans
-- --------------------------------------------------
ALTER TABLE [dbo].[Demattrans] ADD CONSTRAINT [PK_demattrans] PRIMARY KEY ([Sno])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_BROKERAGE_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_BROKERAGE_MASTER] ADD CONSTRAINT [PK_MFSS_BROKERAGE_MASTER] PRIMARY KEY ([PARTY_CODE], [FROMDATE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_CLIENT
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_CLIENT] ADD CONSTRAINT [PK_MFSS_CLIENT] PRIMARY KEY ([PARTY_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_CLIENT_CommonInterface
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_CLIENT_CommonInterface] ADD CONSTRAINT [PK_MFSS_CLIENT1] PRIMARY KEY ([PARTY_CODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_DPMASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_DPMASTER] ADD CONSTRAINT [PK_MFSS_DPMASTER] PRIMARY KEY ([PARTY_CODE], [DP_TYPE], [DPID], [CLTDPID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_NAV
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_NAV] ADD CONSTRAINT [PK_MFSS_NAV] PRIMARY KEY ([NAV_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_ALLOT_CONF_new
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_ALLOT_CONF_new] ADD CONSTRAINT [PK_MFSS_ORDER_ALLOT_CONF] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_ALLOT_REJ_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_ALLOT_REJ_NEW] ADD CONSTRAINT [PK_MFSS_ORDER_ALLOT_REJ] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_NEW] ADD CONSTRAINT [PK_MFSS_ORDER] PRIMARY KEY ([ORDER_NO], [SETT_TYPE], [SETT_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_REDEM_CONF_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_REDEM_CONF_NEW] ADD CONSTRAINT [PK_MFSS_ORDER_REDEM_CONF] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_REDEM_REJ_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_REDEM_REJ_NEW] ADD CONSTRAINT [PK_MFSS_ORDER_REDEM_REJ1] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_ORDER_TMP_NEW
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_ORDER_TMP_NEW] ADD CONSTRAINT [PK_MFSS_ORDER_TMP] PRIMARY KEY ([ORDER_NO], [ORDER_DATE], [SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_SCRIP_MASTER
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_SCRIP_MASTER] ADD CONSTRAINT [PK_MFSS_SCRIP_MASTER] PRIMARY KEY ([SCRIP_CD], [SERIES])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_SETTLEMENT
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_SETTLEMENT] ADD CONSTRAINT [PK_MFSS_SETTLEMENT] PRIMARY KEY ([ORDER_NO], [SETT_NO], [SETT_TYPE], [SCRIP_CD], [SERIES], [ORDER_DATE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MFSS_TRADE
-- --------------------------------------------------
ALTER TABLE [dbo].[MFSS_TRADE] ADD CONSTRAINT [PK_MFSS_TRADE] PRIMARY KEY ([ORDER_NO], [SETT_NO], [SETT_TYPE], [SCRIP_CD], [SERIES], [ORDER_DATE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SETT_MST
-- --------------------------------------------------
ALTER TABLE [dbo].[SETT_MST] ADD CONSTRAINT [PK_SETT_MST] PRIMARY KEY ([Sett_Type], [Sett_No])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.TblPradnyausers
-- --------------------------------------------------
ALTER TABLE [dbo].[TblPradnyausers] ADD CONSTRAINT [PK_tblpradnyausers] PRIMARY KEY ([Fldauto])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '<<!9S52WJ619S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_01022011
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_01022011]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-])4]/+9-}-!8;:<$2.<@(:1-@5!W'  
SET @ERRCODE2 = '<<!9T52WJ769S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_03052012
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_03052012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '7=99S52WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_04MAY2024_ORE_3655
-- --------------------------------------------------


CREATE PROC [dbo].[CHECKVERSION_04MAY2024_ORE_3655]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '7=99U62WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_07022014
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0=>9S62WJ739S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_07Oct2023
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '5,/9T62WJ649S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12012019
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '0=>9S52WJ7Y9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12072011
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_12072011]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '0/*9T52WJ769S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12092020
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '1;$9S52WJ6X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_12FEB2024
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '/;,9T02WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_13012015
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0=>9T42WJ729S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_13042011
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_13042011]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '<<!9T52WJ769S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_14072015
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0/*9T32WJ729S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_15042015
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '<<!9T32WJ729S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16072014
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0/*9T22WJ739S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16072018
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@Z'
SET @ERRCODE2 = '</{9U72WJ7Z9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16102012
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_16102012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '5,/9S42WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16102014
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '5,/9T32WJ739S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_16102019
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '5,/9S52WJ7Y9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_17072012
-- --------------------------------------------------

  
CREATE PROC [DBO].[CHECKVERSION_17072012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '0/*9S32WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_17072018
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@'
SET @ERRCODE2 = '5,/9S42WJ7Z9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_17102015
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '5,/9S72WJ729S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_20042012
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_20042012]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '<<!9S02WJ759S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_20042021
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '<<!9S72WJ669S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_21042017
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@Z'
SET @ERRCODE2 = '<<!9S22WJ7 9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_22042019
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99U72WJ7Y9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_22102013
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '5,/9S52WJ749S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_23Oct2018
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '5,/9S42WJ7Z9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_24042023
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '<<!9R12WJ649S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_24072013
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_24072013]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '0/*9S42WJ749S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_24102016
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '5,/9S22WJ719S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_25072020
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '0/*9S62WJ6X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_25102017
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '6>.9U72WJ7 9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '$!'''
SET @ERRCODE5 = '///\3?0'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'N75'
SET @ERRCODE11 = 'R7X'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'R5X'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_26042013
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_26042013]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '<<!9S42WJ749S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_26072016
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0/*9R12WJ719S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_26082013
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_26082013]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '</{9R02WJ749S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_26102024
-- --------------------------------------------------


CREATE PROC [dbo].[CHECKVERSION_26102024]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '5,/9S42WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_27012016
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '0=>9R12WJ719S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_27072017
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@Z'
SET @ERRCODE2 = '0/*9S22WJ7 9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_28010221
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '0=>9R12WJ669S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_28042016
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '<<!9R12WJ719S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_28052013
-- --------------------------------------------------
  
CREATE PROC [DBO].[CHECKVERSION_28052013]  
AS  
  
DECLARE   
@ERRCODE1 VARCHAR(100),  
@ERRCODE2 VARCHAR(20),  
@ERRCODE3 VARCHAR(2),  
@ERRCODE4 VARCHAR(10),  
@ERRCODE5 VARCHAR(10),  
@ERRCODE6 VARCHAR(100),  
@ERRCODE7 VARCHAR(100),  
@ERRCODE8 VARCHAR(100),  
@ERRCODE9 VARCHAR(100),  
@ERRCODE10 VARCHAR(10),  
@ERRCODE11 VARCHAR(10),  
@ERRCODE12 VARCHAR(100),  
@ERRCODE13 VARCHAR(10),  
@ERRCODE14 VARCHAR(100)  
  
SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'  
SET @ERRCODE2 = '7=99R02WJ749S8xTKD2 '  
SET @ERRCODE3 = 'R4'  
SET @ERRCODE4 = '6!'''  
SET @ERRCODE5 = '7''\@'  
SET @ERRCODE6 = 'LICENSE PERIOD OVER '  
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'  
SET @ERRCODE8 = ''  
SET @ERRCODE9 = 'LICENSE NOT VALID'  
SET @ERRCODE10 = 'S6  M'  
SET @ERRCODE11 = 'N'  
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'  
SET @ERRCODE13 = 'SY'  
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'  
  
SELECT  
 ERRCODE1 = @ERRCODE1,  
 ERRCODE2 = @ERRCODE2,  
 ERRCODE3 = @ERRCODE3,  
 ERRCODE4 = @ERRCODE4,  
 ERRCODE5 = @ERRCODE5,  
 ERRCODE6 = @ERRCODE6,  
 ERRCODE7 = @ERRCODE7,  
 ERRCODE8 = @ERRCODE8,  
 ERRCODE9 = @ERRCODE9,  
 ERRCODE10 = @ERRCODE10,  
 ERRCODE11 = @ERRCODE11,  
 ERRCODE12 = @ERRCODE12,  
 ERRCODE13 = @ERRCODE13,  
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_28052021
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99S22WJ669S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_28Jan2024
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '0=>9S32WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_29042014
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-#3 8*!@ZF>2!/##''@>T=>''!]2(2>({7:2# :VL'
SET @ERRCODE2 = '<<!9S52WJ739S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_29Jun2023
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '0/*9U92WJ649S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_30042020
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '7=99U92WJ6X9S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '1(,@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'R7X'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'R5X'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_31may2025
-- --------------------------------------------------


CREATE PROC [dbo].[CHECKVERSION_31may2025]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '0/>9U02WJ629S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_bkp_20220404
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@!7]/:@-F<5@&:3]4Y9&<#7-}6T8?*/?@Y$@<[.)*Y4@[/>$)YT([(.$)&HK'
SET @ERRCODE2 = '<<!9R12WJ659S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_bkp03032025
-- --------------------------------------------------

create PROC [dbo].[CHECKVERSION_bkp03032025]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '7=!9U92WJ629S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_11Mar2024
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '7=!9T12WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_15Apr2024
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '<<!9T72WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_16DEC2023
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '0=>9S32WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_bkup_18Jun22
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '0/*9U82WJ659S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_20JAN2025
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '0=>9T22WJ629S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_24APR2022
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!8K;6>!>2(990)/268?@U-}-#;*9<>//-&{99''!! ;;L'
SET @ERRCODE2 = '<<!9R12WJ659S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_BKUP_26Feb2024
-- --------------------------------------------------

CREATE PROC [DBO].[CHECKVERSION]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-/-\8*{8''9>!'
SET @ERRCODE2 = '/;,9S62WJ639S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECKVERSION_MAY122011
-- --------------------------------------------------

CREATE PROC [dbo].[CHECKVERSION_MAY122011]
AS

DECLARE 
@ERRCODE1 VARCHAR(100),
@ERRCODE2 VARCHAR(20),
@ERRCODE3 VARCHAR(2),
@ERRCODE4 VARCHAR(10),
@ERRCODE5 VARCHAR(10),
@ERRCODE6 VARCHAR(100),
@ERRCODE7 VARCHAR(100),
@ERRCODE8 VARCHAR(100),
@ERRCODE9 VARCHAR(100),
@ERRCODE10 VARCHAR(10),
@ERRCODE11 VARCHAR(10),
@ERRCODE12 VARCHAR(100),
@ERRCODE13 VARCHAR(10),
@ERRCODE14 VARCHAR(100)

SET @ERRCODE1 = '<&{:9-{75)[*/-@5!WK:3<92.]*:U`\$\(7?>*>5<(7OU=)( 8&[1-@5!WJ'
SET @ERRCODE2 = '7=99T72WJ769S8xTKD2 '
SET @ERRCODE3 = 'R4'
SET @ERRCODE4 = '6!'''
SET @ERRCODE5 = '7''\@'
SET @ERRCODE6 = 'LICENSE PERIOD OVER '
SET @ERRCODE7 = 'LICENSE PERIOD WILL BE EXPIRED ON'
SET @ERRCODE8 = ''
SET @ERRCODE9 = 'LICENSE NOT VALID'
SET @ERRCODE10 = 'S6  M'
SET @ERRCODE11 = 'N'
SET @ERRCODE12 = 'NO OF BRANCH LICENSE IS REACHED TO ALERT LIMIT, PLEASE GET ADDITIONAL LICENSE'
SET @ERRCODE13 = 'SY'
SET @ERRCODE14 = 'BRANCH LICENSE HAD REACHED TO ITS LIMIT, PLEASE GET ADDITIONAL LICENSE'

SELECT
 ERRCODE1 = @ERRCODE1,
 ERRCODE2 = @ERRCODE2,
 ERRCODE3 = @ERRCODE3,
 ERRCODE4 = @ERRCODE4,
 ERRCODE5 = @ERRCODE5,
 ERRCODE6 = @ERRCODE6,
 ERRCODE7 = @ERRCODE7,
 ERRCODE8 = @ERRCODE8,
 ERRCODE9 = @ERRCODE9,
 ERRCODE10 = @ERRCODE10,
 ERRCODE11 = @ERRCODE11,
 ERRCODE12 = @ERRCODE12,
 ERRCODE13 = @ERRCODE13,
 ERRCODE14 = @ERRCODE14

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
                                 
  IF @@ERROR <> 0    
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
-- PROCEDURE dbo.CLASS_VALIDATE_USER_21042011
-- --------------------------------------------------
    
   CREATE PROCEDURE [DBO].[CLASS_VALIDATE_USER_21042011]      
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
                                   
  IF @@ERROR <> 0      
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
-- PROCEDURE dbo.CREATEMENU
-- --------------------------------------------------
/* encrypted or not available */

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
-- PROCEDURE dbo.FILELISTPROC
-- --------------------------------------------------
CREATE  PROC [DBO].[FILELISTPROC] (@FILEPATH VARCHAR(100) )        
AS         
      
DECLARE @NEWFILEPATH VARCHAR(100)      
      
SET @NEWFILEPATH = REPLACE(@FILEPATH, '*.TXT', '*.*')      
CREATE TABLE #FILELIST         
( FILENAMELIST VARCHAR(100))        
INSERT INTO #FILELIST         
EXEC MASTER.DBO.XP_CMDSHELL @NEWFILEPATH        
  
SELECT * FROM #FILELIST

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fun
-- --------------------------------------------------

CREATE PROC Fun @fun VARCHAR(25)AS           
Select * from sysobjects where name Like '%' + @fun + '%' and xtype='FN' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_PWD_EXPIRY
-- --------------------------------------------------
CREATE PROC GET_PWD_EXPIRY  
(  
  @UNAME VARCHAR(100)  
)  
AS  
SELECT LTRIM(RTRIM(T.FLDFIRSTNAME)) AS FIRSTNAME,     
 CASE WHEN DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 2  THEN  'THE DAY AFTER TOMORROW'    
 ELSE    
  CASE WHEN  DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 1  THEN  'TOMORROW'    
 ELSE    
 CASE WHEN  DATEDIFF (DD, GETDATE(), T.PWD_EXPIRY_DATE) = 0  THEN  '<U>TODAY</U>'    
 ELSE    
 'ON ' + LEFT(CONVERT(VARCHAR, T.PWD_EXPIRY_DATE, 109), 11)    
END   
END   
END    
 AS PWD_EXPIRY_DATE    
 FROM    
 TBLPRADNYAUSERS T, TBLADMIN A   
 WHERE    
 T.FLDADMINAUTO = A.FLDAUTO_ADMIN    
 AND T.FLDUSERNAME = @UNAME   
 AND GETDATE() <= T.PWD_EXPIRY_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_USER_CATEGORY
-- --------------------------------------------------

CREATE PROC GET_USER_CATEGORY  
(  
  @FLDCATEGORY INT  
)  
AS  
SELECT FLDCATEGORYNAME FROM TBLCATEGORY WHERE FLDCATEGORYCODE = @FLDCATEGORY

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSCLTDELWISE
-- --------------------------------------------------
/****** OBJECT:  STORED PROCEDURE DBO.INSCLTDELWISE    SCRIPT DATE: 12/09/2004 4:50:00 PM ******/                
                
CREATE PROC [dbo].[INSCLTDELWISE] ( @SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2),@REFNO INT) AS                
DECLARE @@SCRIP_CD VARCHAR(12),                
 @@SERIES VARCHAR(3),                
 @@PARTY_CODE VARCHAR(10),                
 @@DELQTY NUMERIC(18,4),                
 @@QTY NUMERIC(18,4),                
 @@QTY1 NUMERIC(18,4),                
 @@TRADEQTY NUMERIC(18,4),                
 @@CERTNO VARCHAR(15),                
 @@FROMNO VARCHAR(15),                
 @@FOLIONO VARCHAR(15),                
 @@REASON VARCHAR(25),                
 @@TCODE NUMERIC(18,0),                
 @@CERTPARTY VARCHAR(10),                
 @@ORGQTY NUMERIC(18,4),                
 @@SDATE VARCHAR(11),                
 @@SNO NUMERIC(18,0),                
 @@PCOUNT NUMERIC(18,4),                
 @@REMQTY NUMERIC(18,4),                
 @@OLDQTY NUMERIC(18,4),                
 @@FLAG VARCHAR(1),                
 @@QTYCUR CURSOR,                
 @@DELCLT CURSOR,                
 @@CERTCUR CURSOR,  
 @@DPCLT VARCHAR(16)  
          
SET @@DELCLT = CURSOR FOR                            
 SELECT DT.SCRIP_CD,DT.SERIES,DT.PARTY_CODE,QTY,DPCLT,FLAG='N' FROM DELIVERYCLT DT   
 WHERE INOUT = 'O'                
 AND SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE                 
 ORDER BY DT.SCRIP_CD,DT.SERIES,FLAG,DT.QTY ASC,DT.PARTY_CODE                
OPEN @@DELCLT                
FETCH NEXT FROM @@DELCLT INTO @@SCRIP_CD,@@SERIES,@@PARTY_CODE,@@DELQTY,@@DPCLT,@@FLAG                
WHILE @@FETCH_STATUS = 0                 
BEGIN                
                     
       SET @@QTYCUR = CURSOR FOR                 
       SELECT ISNULL(SUM(QTY),0) FROM DELTRANS                 
       WHERE SETT_NO = @SETT_NO                 
       AND SETT_TYPE = @SETT_TYPE                 
       AND REFNO = @REFNO                
       AND PARTY_CODE = @@PARTY_CODE                
       AND SCRIP_CD  = @@SCRIP_CD                 
       AND SERIES = @@SERIES                 
       AND DRCR = 'D' AND FILLER2 = 1  
       AND CLTDPID = (CASE WHEN LEN(CLTDPID) = 16 THEN @@DPCLT ELSE RIGHT(@@DPCLT,8) END)  
       OPEN @@QTYCUR                 
       FETCH NEXT FROM @@QTYCUR INTO @@QTY                   
                       
       IF @@DELQTY > @@QTY                
       BEGIN                  
  SELECT @@DELQTY = @@DELQTY - @@QTY                
  SET @@CERTCUR = CURSOR FOR                
  SELECT QTY,CERTNO, FROMNO,FOLIONO,TDATE=LEFT(CONVERT(VARCHAR,TRANSDATE,109),11),ORGQTY,SNO,TCODE                
  FROM DELTRANS                 
  WHERE SETT_NO = @SETT_NO                 
  AND SETT_TYPE = @SETT_TYPE                 
  AND REFNO = @REFNO                
  AND PARTY_CODE = 'BROKER'                
  AND SCRIP_CD  = @@SCRIP_CD                 
  AND SERIES = @@SERIES                 
  AND DRCR = 'D' AND TRTYPE = 904 AND FILLER2 = 1                    
  ORDER BY TRANSDATE ASC,QTY DESC                 
   OPEN @@CERTCUR                
   FETCH NEXT FROM @@CERTCUR INTO @@TRADEQTY,@@CERTNO,@@FROMNO,@@FOLIONO,@@SDATE,@@ORGQTY,@@SNO,@@TCODE                
   IF @@FETCH_STATUS = 0                 
   BEGIN                
     SELECT @@PCOUNT = 0                
     WHILE @@PCOUNT < @@DELQTY AND @@FETCH_STATUS = 0                 
     BEGIN                
    SELECT @@PCOUNT = @@PCOUNT + @@TRADEQTY                
    IF @@PCOUNT <= @@DELQTY                 
    BEGIN                    
     UPDATE DELTRANS SET PARTY_CODE = @@PARTY_CODE, REASON=(CASE WHEN @@FLAG='E' THEN 'EXCESS RECEIVED TRANSFER' ELSE 'PAY-OUT' END),  
     DPID = LEFT(@@DPCLT,8), CLTDPID = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN RIGHT(@@DPCLT, 8) ELSE @@DPCLT END),  
     DPTYPE = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN 'NSDL' ELSE 'CDSL' END)  
     WHERE SNO = @@SNO                
    END                    
       ELSE                  
    BEGIN                
      SELECT @@PCOUNT = @@PCOUNT - @@TRADEQTY                
      SELECT @@REMQTY = @@DELQTY - @@PCOUNT                
      SELECT @@OLDQTY = @@TRADEQTY - @@REMQTY                
      SELECT @@PCOUNT = @@PCOUNT + @@REMQTY                  
                      
     INSERT INTO DELTRANS(SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,FROMNO,TONO,CERTNO,FOLIONO,  
     HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5)                
     SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY=@@OLDQTY,FROMNO,TONO,CERTNO,FOLIONO,  
     HOLDERNAME,REASON,'D',DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,1,FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5                
     FROM DELTRANS WHERE SNO = @@SNO          
                
     UPDATE DELTRANS SET PARTY_CODE = @@PARTY_CODE, REASON=(CASE WHEN @@FLAG='E' THEN 'EXCESS RECEIVED TRANSFER' ELSE 'PAY-OUT' END),  
     DPID = LEFT(@@DPCLT,8), CLTDPID = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN RIGHT(@@DPCLT, 8) ELSE @@DPCLT END),   
     DPTYPE = (CASE WHEN LEFT(@@DPCLT,2) = 'IN' THEN 'NSDL' ELSE 'CDSL' END),   
     QTY = @@REMQTY            
     WHERE SNO = @@SNO           
                  
    END                
    FETCH NEXT FROM @@CERTCUR INTO @@TRADEQTY,@@CERTNO,@@FROMNO,@@FOLIONO,@@SDATE,@@ORGQTY,@@SNO,@@TCODE                
     END                
   END                
   CLOSE @@CERTCUR                
   DEALLOCATE @@CERTCUR                 
      END                
      CLOSE @@QTYCUR                
      DEALLOCATE @@QTYCUR                
      FETCH NEXT FROM @@DELCLT INTO @@SCRIP_CD,@@SERIES,@@PARTY_CODE,@@DELQTY,@@DPCLT,@@FLAG                
END                
CLOSE @@DELCLT                
DEALLOCATE @@DELCLT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelAccCheck
-- --------------------------------------------------
     
CREATE PROC [dbo].[InsDelAccCheck] AS           
TRUNCATE TABLE DELACCBALANCE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelAccDebit
-- --------------------------------------------------

CREATE Proc [dbo].[InsDelAccDebit](@FPartyCode Varchar(10),@TPartyCode Varchar(10)) AS
select D.Scrip_cd,D.Series,M.SEC_NAME AS SCHEME_NAME,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId,CertNo,    
Qty=sum(qty),delivered,bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,Cl_Rate=IsNull(NAV_VALUE,0),Exchg = 'BSE'     
from NSEMFSS.DBO.Client1 c1,NSEMFSS.DBO.client2 c2,DelAccBalance A,DeliveryDp DP, MFSS_SCRIP_MASTER M, 
NSEMFSS.DBO.DelTrans D Left Outer Join MFSS_NAV C    
On ( D.Scrip_Cd = C.Scrip_CD 
And NAV_DATE = (Select Max(NAV_DATE) From MFSS_NAV Where Scrip_Cd = C.Scrip_CD  ))     
where D.Party_Code >= @FPartyCode and D.Party_Code <= @TPartyCode and DrCr = 'D'
And TrType <> 906 and D.Party_code = C2.Party_code     
and C1.Cl_Code = c2.Cl_Code and filler2= 1 And A.CltCode = D.Party_Code And Delivered = '0'    
And DP.DpType = D.BDpType And DP.DpCltNo = D.BCltDpId And DP.DpId = D.BDpId And Description not like '%POOL%'
AND M.SCRIP_CD = D.SCRIP_CD    
Group by D.Scrip_cd,D.Series,M.SEC_NAME,D.Party_Code,C1.Long_Name,TrType,CltDpId,D.DpId, CertNo, delivered,    
bdptype,bdpid,bcltdpid,Amount,ISett_No,Isett_Type,delivered,NAV_VALUE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelCheckPos
-- --------------------------------------------------
CREATE PROC [dbo].[InsDelCheckPos] (@REFNO INT) AS                      
DECLARE                      
@@SNO NUMERIC(18,0),                      
@@SETT_NO VARCHAR(7),                      
@@SETT_TYPE VARCHAR(2),                      
@@PARTY_CODE VARCHAR(10),                      
@@SCRIP_CD VARCHAR(12),                      
@@SERIES VARCHAR(3),                      
@@DEMATQTY NUMERIC(18, 4),                      
@@CERTQTY NUMERIC(18, 4),                      
@@DELQTY NUMERIC(18, 4),                      
@@DQTY NUMERIC(18, 4),                      
@@REMQTY NUMERIC(18, 4),                      
@@CLTACCNO VARCHAR(16),                      
@@BANKCODE VARCHAR(16),                      
@@TRANSNO VARCHAR(16),                      
@@DEMATCUR CURSOR,                      
@@DELCUR CURSOR,                      
@@MCUR CURSOR,                      
@@DCUR CURSOR,                      
@@CERTCUR CURSOR                      
                      
SET NOCOUNT ON                       
                
UPDATE DEMATTRANS SET SERIES = 'MF'      
      
UPDATE DEMATTRANS SET SCRIP_CD = M.SCRIP_CD, SETT_TYPE = M.SETT_TYPE,       
PARTY_CODE = M.PARTY_CODE, SERIES = M.SERIES      
FROM DELIVERYCLT M       
WHERE DEMATTRANS.SETT_NO = M.SETT_NO       
AND M.DPCLT = DEMATTRANS.CLTACCNO      
AND M.ISIN = DEMATTRANS.ISIN       
AND TRTYPE <> 906       
      
UPDATE DEMATTRANS SET SCRIP_CD = M.SCRIP_CD, SETT_TYPE = M.SETT_TYPE, SERIES = M.SERIES       
FROM DELIVERYCLT M       
WHERE DEMATTRANS.SETT_NO = M.SETT_NO       
AND M.ISIN = DEMATTRANS.ISIN       
AND TRTYPE = 906

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelPayIn
-- --------------------------------------------------
CREATE PROC [dbo].[InsDelPayIn] 
(
      @STATUSID VARCHAR(25), 
      @STATUSNAME VARCHAR(25), 
      @SETT_NO VARCHAR(11), 
      @SETT_TYPE VARCHAR(11), 
      @FPARTY_CD VARCHAR(10), 
      @TPARTY_CD VARCHAR(10)
) 
/*
Exec NSEMFSS.DBO.InsDelPayIn 'broker','broker','1011186','T3','0','zz'
*/
AS
SET NOCOUNT ON
set dateformat mdy
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

      SELECT 
            PARTY_CODE,
            LONG_NAME
      INTO #CLIENTMASTER 
      FROM CLIENT2 C2 WITH(NOLOCK), 
            CLIENT1 C1 WITH(NOLOCK) 
      WHERE C1.CL_CODE = C2.CL_CODE 
            AND C2.PARTY_CODE >= @FPARTY_CD 
            AND C2.PARTY_CODE <= @TPARTY_CD 
             AND @STATUSNAME = 
                  (CASE 
                        WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD
                        WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER
                        WHEN @STATUSID = 'TRADER' THEN C1.TRADER
                        WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY
                        WHEN @STATUSID = 'AREA' THEN C1.AREA
                        WHEN @STATUSID = 'REGION' THEN C1.REGION
                        WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE
                  ELSE 
                        'BROKER'
                  END)

      SELECT 
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            ISIN=CERTNO,
            D.SCRIP_CD,
            SEC_NAME AS SCHEME_NAME,
            QTY=SUM(QTY), 
            CLTDPID = CLTDPID,
            DPID = D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            TRANSDATE=LEFT(CONVERT(VARCHAR,TRANSDATE,109),11),
            EXCHG='BSE', 
            REMARK=(
                  CASE 
                        WHEN TRTYPE = 907 
                        THEN 'INTER SETTLEMENT FROM ' + CLTDPID 
                        ELSE 'RECEIVED' 
                  END
                  ) 
      FROM DELTRANS D WITH(NOLOCK), 
            #CLIENTMASTER C2 WITH(NOLOCK), MFSS_SCRIP_MASTER M 
      WHERE D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND DRCR = 'C' 
            AND FILLER2 = 1 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
            AND SHARETYPE <> 'AUCTION' 
            AND C2.PARTY_CODE = D.PARTY_CODE 
            AND D.SCRIP_CD = M.SCRIP_CD
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            LONG_NAME,
            CERTNO,
            D.SCRIP_CD,
            SEC_NAME,
            CLTDPID,
            D.DPID,
            ISETT_NO,
            ISETT_TYPE, 
            D.SETT_NO,
            TRANSDATE,
            DELIVERED,
            TRTYPE 

      UNION ALL 

      SELECT 
            D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            ISIN=' ',
            D.SCRIP_CD,
            SCHEME_NAME,
            QTY=D.QTY-SUM((
                  CASE 
                        WHEN DRCR = 'C' 
                        THEN ISNULL(DE.QTY,0) 
                        ELSE -ISNULL(DE.QTY,0) 
                  END
                  )), 
            CLTDPID=' ', 
            DPID = ' ', 
            ISETT_NO=' ',
            ISETT_TYPE=' ',
            TRANSDATE=LEFT(CONVERT(VARCHAR,SEC_PAYIN,109),11),
            EXCHG='NSE', 
            REMARK='PAYIN SHORTAGE' 
      FROM SETT_MST S WITH(NOLOCK),
            #CLIENTMASTER C2 WITH(NOLOCK),
            DELIVERYCLT D WITH(NOLOCK) 
            LEFT OUTER JOIN 
            DELTRANS DE WITH(NOLOCK) 
            ON 
            ( 
                  DE.SETT_NO = D.SETT_NO 
                  AND DE.SETT_TYPE = D.SETT_TYPE 
                  AND DE.SCRIP_CD = D.SCRIP_CD 
                  AND DE.SERIES = D.SERIES 
                  AND DE.PARTY_CODE = D.PARTY_CODE 
                  AND FILLER2 = 1 
                  AND SHARETYPE <> 'AUCTION'
            ) 
      WHERE D.INOUT = 'I' 
            AND D.QTY > 0 
            AND D.PARTY_CODE = C2.PARTY_CODE 
            AND D.SETT_NO = S.SETT_NO 
            AND D.SETT_TYPE = S.SETT_TYPE 
            AND D.SETT_NO = @SETT_NO 
            AND D.SETT_TYPE = @SETT_TYPE 
            AND D.PARTY_CODE >= @FPARTY_CD 
            AND D.PARTY_CODE <= @TPARTY_CD 
      GROUP BY D.SETT_NO,
            D.SETT_TYPE,
            D.PARTY_CODE,
            C2.LONG_NAME,
            D.SCRIP_CD,
            D.SERIES,
            SCHEME_NAME,
            D.QTY,
            SEC_PAYIN 
      HAVING D.QTY <> SUM((
            CASE 
                  WHEN DRCR = 'C' 
                  THEN ISNULL(DE.QTY,0) 
                  ELSE -ISNULL(DE.QTY,0) 
            END
            )) 
      ORDER BY D.PARTY_CODE,
            EXCHG,
            SEC_NAME,
            D.SETT_NO,
            D.SETT_TYPE,
            LEFT(CONVERT(VARCHAR,TRANSDATE,109),11)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InsDelPayOut
-- --------------------------------------------------

CREATE Proc [dbo].[InsDelPayOut](@StatusId Varchar(15),@StatusName Varchar(25),@FromTrDate Varchar(11),@ToTrDate Varchar(11),@FParty_Cd Varchar(10),@TParty_Cd Varchar(10),@Branch Varchar(10)) As  
Select D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name=Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',
L_Address1, L_Address2, L_Address3, L_City, L_State, L_Zip,
IsIn=CertNo,D.Scrip_Cd,SEC_NAME AS SCHEME_NAME,Qty=Sum(Qty),  
CltDpId = (Case When Delivered = '0'   
         Then DpCltNo   
         When ISett_No <> '' And TrType <> 908  
         Then ' '  
  Else  
         CltDpID   
      End),       
DpId =    (Case When Delivered = '0'   
         Then D.DpID   
         When ISett_No <> '' And TrType <> 908  
         Then ' '  
  Else  
         D.DpID   
      End),Isett_No,Isett_Type,  
TransDate=Left(Convert(Varchar,TransDate,109),11),Exchg='BSE',  
Remark=(Case When Delivered = '0'   
      Then ''/*'SHARES HELD FOR DEBIT'*/
      When ISett_No <> ''   
      Then 'TRFD FOR PAY-IN OF ' + 'BSE' + '/' + Right(ISett_No,3)  
      When TransDate > Sec_PayOut  
      Then ''/*'SHARES HELD FOR DEBIT Released'*/
      When Reason Like 'Excess%' Then 'EXCESS RECEIVED TRANSFER'  
 Else '' End)  
From NSEMFSS.DBO.DelTrans D,  
NSEMFSS.DBO.Client2 C2 , NSEMFSS.DBO.Client1 C1, NSEMFSS.DBO.Sett_Mst S,NSEMFSS.DBO.DeliveryDp Dp, NSEMFSS.DBO.MFSS_SCRIP_MASTER M   
Where TransDate >= @FromTrDate And TransDate <= @ToTrDate + ' 23:59:59' And DrCr = 'D' And Filler2 = 1  
And D.Party_Code >= @FParty_Cd And D.Party_Code <= @TParty_Cd  
And C1.Cl_Code = C2.Cl_Code and C2.Party_code = D.Party_Code And D.Sett_No = S.Sett_No  
And D.Sett_Type = S.Sett_Type And Dp.DpId = D.BDpId and Dp.DpCltNo = D.BCltDpID and ( Delivered in ('G','D') or Description not Like '%POOL%')  
And C1.Branch_cd Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End )  
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End )  
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End )  
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End )  
And C2.Party_code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End ) 
AND M.SCRIP_CD = D.SCRIP_CD 
Group By D.Sett_no,D.Sett_Type,D.Party_Code,Long_Name+' (' + Branch_Cd + ') ' + ' (' + sub_Broker + ') ',
L_Address1, L_Address2, L_Address3, L_City, L_State, L_Zip,
CertNo,D.Scrip_Cd,SEC_NAME,CltDpId,DpCltNo,D.DpID,DP.DpID,Isett_No,Isett_Type,  
S.Sett_No,TransDate,Delivered,Sec_PayOut, TrType,Reason
order by d.Party_Code,SEC_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDELTRANSPRINTBEN
-- --------------------------------------------------
CREATE PROC [dbo].[INSDELTRANSPRINTBEN] (@OPTFLAG INT, @BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),      
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))                         
AS                        
DECLARE                         
@SETT_NO VARCHAR(7),                        
@SETT_TYPE VARCHAR(2),                        
@SNO NUMERIC,                        
@QTY NUMERIC(18,4),                        
@DIFFQTY NUMERIC(18,4),                        
@SLIPNO INT,                        
@BATCHNO INT,                        
@TRANSDATE VARCHAR(11),                        
@HOLDERNAME VARCHAR(30),                        
@FOLIONO VARCHAR(20),                        
@PARTY_CODE VARCHAR(10),                        
@SCRIP_CD VARCHAR(12),                        
@SERIES VARCHAR(3),                        
@CERTNO VARCHAR(12),                        
@TRTYPE INT,                        
@DPID VARCHAR(8),                        
@CLTDPID VARCHAR(16),                        
@DELBDPID VARCHAR(8),                        
@DELBCLTDPID VARCHAR(16),                        
@ALLQTY NUMERIC(18,4),                        
@DELCUR CURSOR,                        
@BENCUR CURSOR,              
@REFNO INT,              
@FROMPARTY VARCHAR(10),                       
@TOPARTY VARCHAR(10),      
@FLAG INT      
              
              
IF @OPTFLAG = 3                        
BEGIN                        
              
UPDATE DELTRANSPRINTBEN SET OPTIONFLAG = 3 WHERE OPTIONFLAG = 4              
              
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME                        
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND OPTIONFLAG = 3                        
AND D.QTY = NEWQTY                        
AND FILLER1 = 'THIRD PARTY'                      
                      
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 3                        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                      
AND FILLER1 = 'THIRD PARTY'                      
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 3 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID,         @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                        
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                        
 AND FILLER1 = 'THIRD PARTY'                      
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID,                     
 @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO              
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 3                      
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                                       
END                        
                        
IF @OPTFLAG = 4                        
BEGIN                        
              
SELECT @REFNO = REFNO FROM DELSEGMENT               
SELECT @FROMPARTY = ISNULL(MIN(FROMPARTY),'0'), @TOPARTY = ISNULL(MAX(TOPARTY),'ZZZZZZZ') FROM DELTRANSPRINTBEN              
              
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME                        
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND OPTIONFLAG = 4                        
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 4 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID, @CLTDPID,                   @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY, FLAG = 1 FROM DELTRANS D                       
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD             
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
 And Sett_No In (Select Sett_No From MSAJAG.DBO.DelPayOut L              
 Where L.Sett_No = D.Sett_No And L.Sett_Type = D.Sett_Type              
 And L.Party_Code = D.Party_Code And L.CertNo = D.CertNo          
 AND L.SCRIP_CD = D.SCRIP_CD AND L.SERIES = D.SERIES               
 And ActPayout > 0 )      
 UNION ALL      
 SELECT SETT_NO, SETT_TYPE, SNO, QTY, FLAG = 2 FROM DELTRANS D                
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND DPID = @DPID                        
 AND CLTDPID = @CLTDPID                        
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
 And Sett_No Not In (Select Sett_No From MSAJAG.DBO.DelPayOut L              
 Where L.Sett_No = D.Sett_No And L.Sett_Type = D.Sett_Type              
 And L.Party_Code = D.Party_Code And L.CertNo = D.CertNo          
 AND L.SCRIP_CD = D.SCRIP_CD AND L.SERIES = D.SERIES               
 And ActPayout > 0 )      
 ORDER BY 5, SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY, @FLAG                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE           
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                  
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,               
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
 AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                 
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY, @FLAG                        
 END                      
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE, @DPID, @CLTDPID,                     
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                        
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.DPID = D.DPID                        
AND DELTRANS.CLTDPID = D.CLTDPID                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 4                        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO              
        
/*        
INSERT INTO MSAJAG.DBO.DELPAYOUT_RECO              
SELECT EXCHANGE, SETT_NO, SETT_TYPE, PARTY_CODE, SCRIP_CD, SERIES, CERTNO, ACTYPE,               
HOLDQTY=DEBITQTY, RMSPAYQTY=ACTPAYOUT, PAYQTY, RUNDATE = GETDATE()              
FROM MSAJAG.DBO.DELPAYOUT              
WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY         
AND EXCHANGE = (CASE WHEN @REFNO = 110 THEN 'NSE' ELSE 'BSE' END)              
              
INSERT INTO MSAJAG.DBO.DELPAYOUT_RECO              
SELECT EXCHANGE=(CASE WHEN REFNO = 110 THEN 'NSE' ELSE 'BSE' END),              
DELTRANSTEMP.SETT_NO, DELTRANSTEMP.SETT_TYPE, DELTRANSTEMP.PARTY_CODE,               
DELTRANSTEMP.SCRIP_CD, DELTRANSTEMP.SERIES, DELTRANSTEMP.CERTNO, ACTYPE = 'BEN',              
HOLDQTY = 0, RMSPAYQTY = 0, PAYQTY = SUM(DELTRANSTEMP.QTY), RUNDATE = GETDATE()              
FROM DELTRANSTEMP, DELTRANSPRINTBEN D                        
WHERE DELTRANSTEMP.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANSTEMP.PARTY_CODE <= D.TOPARTY               
AND DELTRANSTEMP.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANSTEMP.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANSTEMP.SERIES = D.SERIES                    
AND DELTRANSTEMP.CERTNO = D.CERTNO                        
AND DELTRANSTEMP.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1              
AND DRCR = 'D'              
AND DELTRANSTEMP.BDPTYPE = D.BDPTYPE                        
AND DELTRANSTEMP.BDPID = D.BDPID                        
AND DELTRANSTEMP.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'D'                        
AND DELTRANSTEMP.DPID = D.DPID                        
AND DELTRANSTEMP.CLTDPID = D.CLTDPID                        
AND DELTRANSTEMP.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 4                       
AND DELTRANSTEMP.SLIPNO = D.SLIPNO                      
AND DELTRANSTEMP.BATCHNO = D.BATCHNO              
GROUP BY DELTRANSTEMP.SETT_NO, DELTRANSTEMP.SETT_TYPE, DELTRANSTEMP.PARTY_CODE,               
DELTRANSTEMP.SCRIP_CD, DELTRANSTEMP.SERIES, DELTRANSTEMP.CERTNO, DELTRANSTEMP.REFNO              
              
DELETE FROM MSAJAG.DBO.DELPAYOUT              
WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY              
AND EXCHANGE = (CASE WHEN @REFNO = 110 THEN 'NSE' ELSE 'BSE' END)              
*/        
END                        
                        
IF @OPTFLAG = 5                        
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 5                      
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 5 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN      
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 5                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END                  
                        
IF @OPTFLAG = 6                      
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                 
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 6                      
AND D.QTY = NEWQTY        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 6 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                  
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY            
AND DELTRANS.PARTY_CODE = D.PARTY_CODE           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 6                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END         
        
IF @OPTFLAG = 7                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 7                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )      
                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 7 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID      
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                 
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'          
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 7        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
END      
      
IF @OPTFLAG = 8                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = '0'                        
AND OPTIONFLAG = 8                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 8 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,          
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 8        
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                       
END    
    
IF @OPTFLAG = 9                      
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                 
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE = D.PARTY_CODE                         
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID     
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID    
AND DELIVERED = '0'                        
AND OPTIONFLAG = 9                      
AND D.QTY = NEWQTY                        
                        
SET @BENCUR = CURSOR FOR                        
SELECT PARTY_CODE, SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 9 AND QTY <> NEWQTY                         
ORDER BY PARTY_CODE, CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE = @PARTY_CODE                        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID    
 AND DELTRANS.DPID = @BDPID                   
 AND DELTRANS.CLTDPID = @BCLTDPID    
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @PARTY_CODE, @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                        
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,    
DELTRANS.FILLER5                  
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY            
AND DELTRANS.PARTY_CODE = D.PARTY_CODE           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID     
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                       
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 9                  
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO                        
END    
    
IF @OPTFLAG = 10                    
BEGIN                        
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,                         
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,                        
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME,                      
DPTYPE = @BDPTYPE, DPID = @BDPID, CLTDPID = @BCLTDPID                      
FROM DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY           
AND DELTRANS.PARTY_CODE <> 'BROKER'            
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                         
AND DELIVERED = '0'                        
AND OPTIONFLAG = 10                      
AND D.QTY = NEWQTY                        
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                        
SET @BENCUR = CURSOR FOR                        
SELECT SCRIP_CD, SERIES, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,                         
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID                        
FROM DELTRANSPRINTBEN WHERE OPTIONFLAG = 10 AND QTY <> NEWQTY                         
ORDER BY CERTNO                        
OPEN @BENCUR                        
FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,                   
@SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
WHILE @@FETCH_STATUS = 0                         
BEGIN                        
 SELECT @DIFFQTY = @ALLQTY                        
 SET @DELCUR = CURSOR FOR                        
 SELECT SETT_NO, SETT_TYPE, SNO, QTY FROM DELTRANS                        
 WHERE PARTY_CODE <> 'BROKER'        
 AND SCRIP_CD = @SCRIP_CD                    
 AND SERIES = @SERIES                    
 AND CERTNO = @CERTNO                        
 AND TRTYPE = @TRTYPE                        
 AND DRCR = 'D'                        
 AND DELIVERED = '0'                        
 AND FILLER2 = 1                         
 AND BDPID = @DELBDPID                        
 AND BCLTDPID = @DELBCLTDPID    
 AND DELTRANS.DPID = @BDPID                   
 AND DELTRANS.CLTDPID = @BCLTDPID    
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC                        
 OPEN @DELCUR                        
 FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                         
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0                         
 BEGIN                        
  IF @DIFFQTY >= @QTY                        
  BEGIN                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
   SELECT @DIFFQTY = @DIFFQTY - @QTY                        
  END                        
  ELSE                        
  BEGIN                        
   INSERT INTO DELTRANS                        
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,                        
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,                        
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,                        
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,                        
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY                        
   WHERE SETT_NO = @SETT_NO                        
   AND SETT_TYPE = @SETT_TYPE                        
   AND SNO = @SNO                        
                        
   SELECT @DIFFQTY = 0                         
  END                        
  FETCH NEXT FROM @DELCUR INTO @SETT_NO, @SETT_TYPE, @SNO, @QTY                        
 END                        
 FETCH NEXT FROM @BENCUR INTO @SCRIP_CD, @SERIES, @CERTNO, @TRTYPE,          
 @SLIPNO, @BATCHNO, @FOLIONO, @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID                        
END                         
                        
INSERT INTO DELTRANSTEMP                        
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,                        
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,                        
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,                        
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,                        
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,                        
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5                   
FROM DELTRANS, DELTRANSPRINTBEN D                        
WHERE DELTRANS.PARTY_CODE >= D.FROMPARTY                        
AND DELTRANS.PARTY_CODE <= D.TOPARTY                        
AND DELTRANS.SCRIP_CD = D.SCRIP_CD                    
AND DELTRANS.SERIES = D.SERIES                    
AND DELTRANS.CERTNO = D.CERTNO                        
AND DELTRANS.TRTYPE = D.TRTYPE                        
AND FILLER2 = 1                        
AND DRCR = 'D'                        
AND DELTRANS.BDPTYPE = D.BDPTYPE                        
AND DELTRANS.BDPID = D.BDPID                        
AND DELTRANS.BCLTDPID = D.BCLTDPID    
AND DELTRANS.DPID = @BDPID                   
AND DELTRANS.CLTDPID = @BCLTDPID                        
AND DELIVERED = 'G'                        
AND DELTRANS.FOLIONO = D.FOLIONO                        
AND OPTIONFLAG = 10     
AND DELTRANS.SLIPNO = D.SLIPNO                      
AND DELTRANS.BATCHNO = D.BATCHNO       
AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
   WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
   AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
   )                       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDELTRANSPRINTPOOL
-- --------------------------------------------------
CREATE PROC [dbo].[INSDELTRANSPRINTPOOL] (@OPTFLAG INT, @BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),      
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))       
AS      
DECLARE       
@SETT_NO VARCHAR(7),      
@SETT_TYPE VARCHAR(2),      
@SNO NUMERIC,      
@QTY NUMERIC(18, 4),      
@DIFFQTY NUMERIC(18, 4),      
@SLIPNO INT,      
@BATCHNO INT,      
@TRANSDATE VARCHAR(11),      
@HOLDERNAME VARCHAR(30),      
@FOLIONO VARCHAR(20),      
@PARTY_CODE VARCHAR(10),      
@CERTNO VARCHAR(12),      
@TRTYPE INT,      
@DPID VARCHAR(8),      
@CLTDPID VARCHAR(16),      
@DELBDPID VARCHAR(8),      
@DELBCLTDPID VARCHAR(16),      
@ALLQTY INT,      
@DELCUR CURSOR,      
@BENCUR CURSOR      
      
IF @OPTFLAG = 1       
BEGIN      
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,       
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,      
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME      
FROM DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = '0'      
AND DELTRANS.ISETT_NO = D.ISETT_NO      
AND DELTRANS.ISETT_TYPE = D.ISETT_TYPE      
AND OPTIONFLAG = 1  AND DELTRANS.PARTY_CODE <> 'BROKER'      
END      
      
IF @OPTFLAG = 3      
BEGIN      
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,       
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,      
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME      
FROM DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = '0'      
AND DELTRANS.DPID = D.DPID      
AND DELTRANS.CLTDPID = D.CLTDPID      
AND OPTIONFLAG = 3      
AND D.QTY = NEWQTY       
AND DELTRANS.PARTY_CODE <> 'BROKER'      
      
INSERT INTO DELTRANSTEMP      
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,      
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,      
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,      
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,      
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,      
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5      
FROM DELTRANS, DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = 'G'      
AND DELTRANS.DPID = D.DPID      
AND DELTRANS.CLTDPID = D.CLTDPID      
AND DELTRANS.FOLIONO = D.FOLIONO      
AND DELTRANS.SLIPNO = D.SLIPNO      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND OPTIONFLAG = 3      
AND D.QTY = NEWQTY       
AND DELTRANS.PARTY_CODE <> 'BROKER'      
      
SET @BENCUR = CURSOR FOR      
SELECT SETT_NO, SETT_TYPE, PARTY_CODE, CERTNO, TRTYPE, DPID, CLTDPID, SLIPNO, BATCHNO, FOLIONO,       
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID      
FROM DELTRANSPRINTPOOL WHERE OPTIONFLAG = 3 AND QTY <> NEWQTY       
ORDER BY PARTY_CODE, CERTNO      
OPEN @BENCUR      
FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE, @PARTY_CODE, @CERTNO, @TRTYPE, @DPID, @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO,       
@HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID      
WHILE @@FETCH_STATUS = 0       
BEGIN      
 SELECT @DIFFQTY = @ALLQTY      
 SET @DELCUR = CURSOR FOR      
 SELECT SNO, QTY FROM DELTRANS      
 WHERE PARTY_CODE = @PARTY_CODE      
 AND CERTNO = @CERTNO      
 AND TRTYPE = @TRTYPE      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1       
 AND DPID = @DPID      
 AND CLTDPID = @CLTDPID      
 AND BDPID = @DELBDPID      
 AND BCLTDPID = @DELBCLTDPID      
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC      
 OPEN @DELCUR      
 FETCH NEXT FROM @DELCUR INTO @SNO, @QTY       
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0       
 BEGIN      
  IF @DIFFQTY >= @QTY      
  BEGIN      
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,      
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
   SELECT @DIFFQTY = @DIFFQTY - @QTY      
  END      
  ELSE      
  BEGIN      
   INSERT INTO DELTRANS      
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,      
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,      
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,      
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
      
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,      
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
      
   SELECT @DIFFQTY = 0       
  END      
  FETCH NEXT FROM @DELCUR INTO @SNO, @QTY       
 END      
 FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE,@PARTY_CODE, @CERTNO, @TRTYPE, @DPID, @CLTDPID, @SLIPNO, @BATCHNO, @FOLIONO,       
 @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID      
END      
      
INSERT INTO DELTRANSTEMP      
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,      
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,      
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'D',DELTRANS.ORGQTY,      
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,      
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,      
DELTRANS.FILLER2,DELTRANS.FILLER3,DELTRANS.BDPTYPE,DELTRANS.BDPID,DELTRANS.BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5      
FROM DELTRANS, DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = 'G'      
AND DELTRANS.DPID = D.DPID      
AND DELTRANS.CLTDPID = D.CLTDPID      
AND DELTRANS.FOLIONO = D.FOLIONO   
AND DELTRANS.SLIPNO = D.SLIPNO      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND OPTIONFLAG = 3      
AND D.QTY <> NEWQTY      
      
END      
      
IF @OPTFLAG = 2      
BEGIN      
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,       
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,      
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME      
FROM DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = '0'      
AND OPTIONFLAG = 2      
AND DELTRANS.PARTY_CODE <> 'BROKER'      
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
    )       
      
INSERT INTO DELTRANSTEMP      
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,      
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,      
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,      
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,      
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,      
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5      
FROM DELTRANS, DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = 'G'      
AND OPTIONFLAG = 2      
AND DELTRANS.FOLIONO = D.FOLIONO      
AND DELTRANS.SLIPNO = D.SLIPNO      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND DELTRANS.PARTY_CODE <> 'BROKER'      
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1       
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = DELTRANS.PARTY_CODE       
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)      
    )       
END      
    
IF @OPTFLAG = 4      
BEGIN      
UPDATE DELTRANS SET DELIVERED = 'G', SLIPNO = D.SLIPNO,       
BATCHNO = D.BATCHNO, FOLIONO = D.FOLIONO,      
TRANSDATE = D.TRANSDATE, HOLDERNAME = D.HOLDERNAME      
FROM DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = '0'      
AND OPTIONFLAG = 4    
AND D.QTY = NEWQTY       
AND DELTRANS.PARTY_CODE <> 'BROKER'      
      
INSERT INTO DELTRANSTEMP      
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,      
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,      
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,      
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,      
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,      
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5      
FROM DELTRANS, DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = 'G'      
AND DELTRANS.FOLIONO = D.FOLIONO      
AND DELTRANS.SLIPNO = D.SLIPNO      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND OPTIONFLAG = 4     
AND D.QTY = NEWQTY       
AND DELTRANS.PARTY_CODE <> 'BROKER'      
      
SET @BENCUR = CURSOR FOR      
SELECT SETT_NO, SETT_TYPE, PARTY_CODE, CERTNO, TRTYPE, SLIPNO, BATCHNO, FOLIONO,       
HOLDERNAME, QTY , TRANSDATE = LEFT(CONVERT(VARCHAR,TRANSDATE,109),11), BDPID, BCLTDPID      
FROM DELTRANSPRINTPOOL WHERE OPTIONFLAG = 4 AND QTY <> NEWQTY       
ORDER BY PARTY_CODE, CERTNO      
OPEN @BENCUR      
FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE, @PARTY_CODE, @CERTNO, @TRTYPE, @SLIPNO, @BATCHNO, @FOLIONO,       
@HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID      
WHILE @@FETCH_STATUS = 0       
BEGIN      
 SELECT @DIFFQTY = @ALLQTY      
 SET @DELCUR = CURSOR FOR      
 SELECT SNO, QTY FROM DELTRANS      
 WHERE PARTY_CODE = @PARTY_CODE      
 AND CERTNO = @CERTNO      
 AND TRTYPE = @TRTYPE      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1       
 AND BDPID = @DELBDPID      
 AND BCLTDPID = @DELBCLTDPID      
 ORDER BY SETT_NO, SETT_TYPE, QTY DESC      
 OPEN @DELCUR      
 FETCH NEXT FROM @DELCUR INTO @SNO, @QTY       
 WHILE @@FETCH_STATUS = 0 AND @DIFFQTY > 0       
 BEGIN      
  IF @DIFFQTY >= @QTY      
  BEGIN      
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,      
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G'      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
   SELECT @DIFFQTY = @DIFFQTY - @QTY      
  END      
  ELSE      
  BEGIN      
   INSERT INTO DELTRANS      
   SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,@QTY-@DIFFQTY,FROMNO,TONO,      
   CERTNO,FOLIONO,HOLDERNAME,REASON,DRCR,DELIVERED,ORGQTY,DPTYPE,DPID,CLTDPID,BRANCHCD,      
   PARTIPANTCODE,SLIPNO,BATCHNO,ISETT_NO,ISETT_TYPE,SHARETYPE,TRANSDATE,FILLER1,FILLER2,      
   FILLER3,BDPTYPE,BDPID,BCLTDPID,FILLER4,FILLER5 FROM DELTRANS      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
      
   UPDATE DELTRANS SET SLIPNO = @SLIPNO, BATCHNO = @BATCHNO, FOLIONO = @FOLIONO,      
   HOLDERNAME = @HOLDERNAME, TRANSDATE = @TRANSDATE, DELIVERED = 'G', QTY = @DIFFQTY      
   WHERE SETT_NO = @SETT_NO      
   AND SETT_TYPE = @SETT_TYPE      
   AND SNO = @SNO      
      
   SELECT @DIFFQTY = 0       
  END      
  FETCH NEXT FROM @DELCUR INTO @SNO, @QTY       
 END      
 FETCH NEXT FROM @BENCUR INTO @SETT_NO, @SETT_TYPE,@PARTY_CODE, @CERTNO, @TRTYPE, @SLIPNO, @BATCHNO, @FOLIONO,       
 @HOLDERNAME, @ALLQTY , @TRANSDATE, @DELBDPID, @DELBCLTDPID      
END      
      
INSERT INTO DELTRANSTEMP      
SELECT DELTRANS.SNO,DELTRANS.SETT_NO,DELTRANS.SETT_TYPE,DELTRANS.REFNO,DELTRANS.TCODE,DELTRANS.TRTYPE,      
DELTRANS.PARTY_CODE,DELTRANS.SCRIP_CD,DELTRANS.SERIES,DELTRANS.QTY,DELTRANS.FROMNO,DELTRANS.TONO,      
DELTRANS.CERTNO,DELTRANS.FOLIONO,DELTRANS.HOLDERNAME,DELTRANS.REASON,DELTRANS.DRCR,'0',DELTRANS.ORGQTY,      
DELTRANS.DPTYPE,DELTRANS.DPID,DELTRANS.CLTDPID,DELTRANS.BRANCHCD,DELTRANS.PARTIPANTCODE,DELTRANS.SLIPNO,      
DELTRANS.BATCHNO,DELTRANS.ISETT_NO,DELTRANS.ISETT_TYPE,DELTRANS.SHARETYPE,DELTRANS.TRANSDATE,DELTRANS.FILLER1,      
DELTRANS.FILLER2,DELTRANS.FILLER3,@BDPTYPE,@BDPID,@BCLTDPID,DELTRANS.FILLER4,DELTRANS.FILLER5      
FROM DELTRANS, DELTRANSPRINTPOOL D      
WHERE DELTRANS.SETT_NO = D.SETT_NO      
AND DELTRANS.SETT_TYPE = D.SETT_TYPE      
AND DELTRANS.PARTY_CODE >= D.FROMPARTY      
AND DELTRANS.PARTY_CODE <= D.TOPARTY      
AND DELTRANS.PARTY_CODE = D.PARTY_CODE      
AND DELTRANS.SCRIP_CD LIKE '%'      
AND DELTRANS.SERIES LIKE '%'      
AND DELTRANS.CERTNO = D.CERTNO      
AND DELTRANS.TRTYPE = D.TRTYPE      
AND FILLER2 = 1      
AND DRCR = 'D'      
AND DELTRANS.BDPTYPE = D.BDPTYPE      
AND DELTRANS.BDPID = D.BDPID      
AND DELTRANS.BCLTDPID = D.BCLTDPID      
AND DELIVERED = 'G'      
AND DELTRANS.FOLIONO = D.FOLIONO      
AND DELTRANS.SLIPNO = D.SLIPNO      
AND DELTRANS.BATCHNO = D.BATCHNO      
AND OPTIONFLAG = 4      
AND D.QTY <> NEWQTY      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Insdematnsecursor
-- --------------------------------------------------
CREATE Proc [dbo].[Insdematnsecursor] ( @Refno Int) As      
      
Insert Into Deltrans      
Select Sett_No, Sett_Type, Refno, Tcode, Trtype, Party_Code, D.Scrip_Cd, D.Series, Qty, Transno, Transno, D.Isin, Transno, '',       
'Pay-Out', 'C', '0', Qty, Dptype, Dpid, Cltaccno, Branch_Cd, Partipantcode, 0, '', '', '', 'Demat',       
Trdate, Filler1, 1, Filler3, Bdptype, Bdpid, Bcltaccno, Filler4, Filler5      
From Demattrans D Where Drcr = 'C'       
And D.Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type      
        And De.Scrip_Cd = D.Scrip_Cd And De.Series = D.Series )             
      
Insert Into Deltrans      
Select Sett_No, Sett_Type, Refno, Tcode, (CASE WHEN TRTYPE = 906 THEN 904 ELSE 906 END),   
(CASE WHEN TRTYPE = 906 THEN 'BROKER' ELSE 'EXE' END), D.Scrip_Cd, D.Series, Qty, Transno, Transno, D.Isin, Transno, '',       
'Pay-Out', 'D', (CASE WHEN TRTYPE = 906 THEN '0' ELSE 'D' END), Qty, Dptype, Dpid, Cltaccno, Branch_Cd, Partipantcode, 0, '', '', '', 'Demat',       
Trdate, Filler1, 1, Filler3, Bdptype, Bdpid, Bcltaccno, Filler4, Filler5      
From Demattrans D Where Drcr = 'C'       
And D.Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = D.Sett_No And DE.Sett_Type = D.Sett_Type      
        And De.Scrip_Cd = D.Scrip_Cd And De.Series = D.Series )      
      
Delete From Demattrans Where Drcr = 'C'       
And Scrip_Cd In ( Select Distinct Scrip_Cd From Deliveryclt De       
                       Where DE.Sett_No = Demattrans.Sett_No And DE.Sett_Type = Demattrans.Sett_Type      
        And De.Scrip_Cd = Demattrans.Scrip_Cd And De.Series = Demattrans.Series )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDEMATTRANSDUPLICATE
-- --------------------------------------------------

CREATE PROC [dbo].[INSDEMATTRANSDUPLICATE]  
AS  
TRUNCATE TABLE SPEED_TEMP
          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
INSERT INTO SPEED_TEMP       
SELECT T.SNO, T.SETT_NO, T.SETT_TYPE, T.REFNO, T.TCODE, 
T.TRTYPE, T.PARTY_CODE, T.SCRIP_CD, T.SERIES, T.QTY, T.TRDATE, 
T.CLTACCNO, T.DPID, T.DPNAME, T.ISIN, T.BRANCH_CD, T.PARTIPANTCODE, 
T.DPTYPE, T.TRANSNO, T.DRCR, T.BDPTYPE, T.BDPID, T.BCLTACCNO
FROM DELTRANS D WITH(INDEX(DELHOLD)),             
DEMATTRANSSPEED T WITH(INDEX(TRN_SPEED))            
WHERE T.SETT_NO = D.SETT_NO            
AND D.CERTNO = T.ISIN            
AND D.FILLER2 = 1 AND D.DRCR = 'C'             
AND D.BDPTYPE = T.BDPTYPE            
AND D.BDPID = T.BDPID            
AND D.BCLTDPID = T.BCLTACCNO 
AND D.DPID = T.DPID            
AND D.CLTDPID = T.CLTACCNO           
AND D.FROMNO = T.TRANSNO 
AND D.TRTYPE <> 907
           
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
INSERT INTO SPEED_TEMP       
SELECT T.SNO, T.SETT_NO, T.SETT_TYPE, T.REFNO, T.TCODE, 
T.TRTYPE, T.PARTY_CODE, T.SCRIP_CD, T.SERIES, T.QTY, T.TRDATE, 
T.CLTACCNO, T.DPID, T.DPNAME, T.ISIN, T.BRANCH_CD, T.PARTIPANTCODE, 
T.DPTYPE, T.TRANSNO, T.DRCR, T.BDPTYPE, T.BDPID, T.BCLTACCNO
FROM DELTRANS D WITH(INDEX(DELHOLD)),             
DEMATTRANSSPEED T WITH(INDEX(TRN_SPEED))            
WHERE T.SETT_NO = D.SETT_NO            
AND D.CERTNO = T.ISIN            
AND D.FILLER2 = 1 AND D.DRCR = 'C'             
AND D.BDPTYPE = T.BDPTYPE            
AND D.BDPID = T.BDPID            
AND D.BCLTDPID = T.BCLTACCNO 
AND D.FROMNO = T.TRANSNO 
AND D.TRTYPE = 907

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDEMATTRANSINSERT
-- --------------------------------------------------
  
CREATE PROC [dbo].[INSDEMATTRANSINSERT] (                    
 @TCODE INT,                     
 @REFNO INT )                     
AS                     
             
UPDATE DELCODE SET TCODE = @TCODE WHERE REFNO = @REFNO                    
                
DELETE FROM DEMATTRANSSPEED WHERE SNO IN (SELECT SNO FROM SPEED_TEMP)                
/* TILL HERE */                
                    
DELETE DEMATTRANSSPEED FROM DEMATTRANS DT                 
WHERE DEMATTRANSSPEED.SETT_NO = DT.SETT_NO                
AND DEMATTRANSSPEED.ISIN = DT.ISIN                       
AND LEFT(DEMATTRANSSPEED.TRDATE,11) = LEFT(DT.TRDATE,11)  
AND DEMATTRANSSPEED.DRCR = DT.DRCR                   
AND DT.BDPTYPE = 'NSDL'                   
AND DT.BCLTACCNO = DEMATTRANSSPEED.BCLTACCNO                       
AND DEMATTRANSSPEED.TRANSNO = DT.TRANSNO    
AND DT.DPID = DEMATTRANSSPEED.DPID   
AND DT.CLTACCNO = DEMATTRANSSPEED.CLTACCNO                     
                    
DELETE DEMATTRANSSPEED FROM DEMATTRANSOUT DT                 
WHERE DEMATTRANSSPEED.SETT_NO = DT.SETT_NO                
AND DEMATTRANSSPEED.ISIN = DT.ISIN                       
AND LEFT(DEMATTRANSSPEED.TRDATE,11) = LEFT(DT.TRDATE,11)  
AND DEMATTRANSSPEED.DRCR = DT.DRCR                   
AND DT.BDPTYPE = 'NSDL'                   
AND DT.BCLTACCNO = DEMATTRANSSPEED.BCLTACCNO                       
AND DEMATTRANSSPEED.TRANSNO = DT.TRANSNO                      
                    
INSERT INTO DEMATTRANS( SETT_NO, SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,                    
TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,PARTIPANTCODE,DPTYPE,TRANSNO,                     
DRCR , BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5 )                    
SELECT SETT_NO, SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,                     
TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,PARTIPANTCODE,DPTYPE,TRANSNO,                     
DRCR , BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5 FROM DEMATTRANSSPEED                     
                                      
UPDATE DEMATTRANS SET SCRIP_CD = S2.SCRIP_CD,SERIES = D.SERIES, SETT_TYPE = S2.SETT_TYPE
FROM DELIVERYCLT S2 ,DEMATTRANS  D 
WHERE D.SETT_NO = S2.SETT_NO 
AND S2.ISIN = D.ISIN
                    
IF @REFNO = 120                     
BEGIN                    
      UPDATE DEMATTRANS SET SETT_TYPE = D.SETT_TYPE FROM DELIVERYCLT D                     
        WHERE D.SETT_NO = DEMATTRANS.SETT_NO AND D.SCRIP_CD = DEMATTRANS.SCRIP_CD AND D.SETT_TYPE = 'C'                     
        AND D.SETT_NO >= '2004164' AND DEMATTRANS.SETT_TYPE = 'D'                     
                  
      UPDATE DEMATTRANS SET SETT_TYPE = D.SETT_TYPE FROM DELIVERYCLT D                     
        WHERE D.SETT_NO = DEMATTRANS.SETT_NO AND D.SCRIP_CD = DEMATTRANS.SCRIP_CD AND D.SETT_TYPE = 'D'                  
        AND D.SETT_NO >= '2004164' AND DEMATTRANS.SETT_TYPE = 'C'                  
END                    
                    
UPDATE DEMATTRANS SET CLTACCNO = RTRIM(ISNULL((SELECT LEFT(SETT_NO + '                ',16) FROM DEMATTRANS D WHERE                     
D.TRANSNO = DEMATTRANS.TRANSNO AND                    
D.TRTYPE = 907 AND D.DRCR = 'D'),CLTACCNO))                    
WHERE TRTYPE = 907 AND DRCR = 'C'                    
                       
UPDATE DEMATTRANS SET DPID = RTRIM(ISNULL((SELECT LEFT(SETT_TYPE + '                ',8) FROM DEMATTRANS D                     
WHERE D.TRANSNO = DEMATTRANS.TRANSNO AND                    
D.TRTYPE = 907 AND D.DRCR = 'D'),DPID))                    
WHERE TRTYPE = 907 AND DRCR = 'C'                
                    
UPDATE DEMATTRANS SET                     
PARTY_CODE = (CASE WHEN @REFNO = 120                     
                              THEN 'BSE'                     
                              ELSE 'NSE'                     
                     END)                     
WHERE TRTYPE = 906    
                      
INSERT INTO DEMATTRANSOUT SELECT SETT_NO,SETT_TYPE,REFNO,TCODE,TRTYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,TRDATE,CLTACCNO,DPID,DPNAME,ISIN,BRANCH_CD,                    
PARTIPANTCODE,DPTYPE,TRANSNO,DRCR,BDPTYPE,BDPID,BCLTACCNO,FILLER1,FILLER2,FILLER3,FILLER4,FILLER5                    
FROM DEMATTRANS WHERE DRCR = 'D'     
                        
DELETE FROM DEMATTRANS WHERE DRCR = 'D'                    
                    
TRUNCATE TABLE SPEED_TEMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.INSDUPRECCHECK
-- --------------------------------------------------

CREATE PROC INSDUPRECCHECK AS         
        
DELETE FROM DEMATTRANSSPEED   
WHERE TRANSNO IN (SELECT TRANSNO FROM DEMATTRANS   
                  WHERE SETT_NO = DEMATTRANSSPEED.SETT_NO   
                  AND Left(Convert(Varchar,TRDATE,109),11) = Left(Convert(Varchar,DEMATTRANSSPEED.TRDATE,109),11)  
                  AND DEMATTRANS.ISIN = DEMATTRANSSPEED.ISIN       
                  AND TRANSNO = DEMATTRANSSPEED.TRANSNO AND DPID = DEMATTRANSSPEED.DPID   
                  AND CLTACCNO = DEMATTRANSSPEED.CLTACCNO)  
         
DELETE FROM DEMATTRANSSPEED   
WHERE TRANSNO IN (SELECT FROMNO FROM DELTRANS   
                  WHERE SETT_NO = DEMATTRANSSPEED.SETT_NO   
                  AND Left(Convert(Varchar,Transdate,109),11) = Left(Convert(Varchar,DEMATTRANSSPEED.TRDATE,109),11)  
                  AND CERTNO = DEMATTRANSSPEED.ISIN       
                  AND FROMNO = DEMATTRANSSPEED.TRANSNO AND DPID = DEMATTRANSSPEED.DPID   
                  AND CLTDPID = DEMATTRANSSPEED.CLTACCNO AND FILLER2 = 1 AND DRCR = 'C')         
                    
INSERT INTO DEMATTRANS (SETT_NO, SETT_TYPE, REFNO, TCODE, TRTYPE, PARTY_CODE, SCRIP_CD, SERIES, QTY,   
                        TRDATE, CLTACCNO, DPID, DPNAME, ISIN, BRANCH_CD, PARTIPANTCODE, DPTYPE, TRANSNO,   
                        DRCR, BDPTYPE, BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5)        
SELECT SETT_NO, SETT_TYPE, REFNO, TCODE, TRTYPE, PARTY_CODE, SCRIP_CD, SERIES, QTY,   
       TRDATE, CLTACCNO, DPID, DPNAME, ISIN, BRANCH_CD, PARTIPANTCODE, DPTYPE, TRANSNO, DRCR, BDPTYPE,   
       BDPID, BCLTACCNO, FILLER1, FILLER2, FILLER3, FILLER4, FILLER5   
FROM DEMATTRANSSPEED

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Insertdematspeed
-- --------------------------------------------------

Create Procedure [dbo].[Insertdematspeed]     
    
       @Sett_No                  Varchar(7)          ,             
       @Sett_Type                Varchar(2)          ,             
       @Refno                    Int                 ,             
       @Tcode                    Numeric(18, 0)       ,             
       @Trtype                   Numeric(18, 0)       ,             
       @Party_Code               Varchar(10)         ,             
       @Scrip_Cd                 Varchar(12)         = Null,       
       @Series                   Varchar(3)          = Null,       
       @Qty                      Numeric(18, 4)       ,             
       @Trdate                   Datetime            ,             
       @Cltaccno                 Varchar(16)         = Null,       
       @Dpid                     Varchar(16)         = Null,       
       @Dpname                   Varchar(50)         = Null,       
       @Isin                     Varchar(12)         = Null,       
       @Branch_Cd                Varchar(10)         = Null,       
       @Partipantcode            Varchar(10)         = Null,       
       @Dptype                 Varchar(4)         = Null,       
       @Transno                Varchar(15)         ,             
       @Drcr                       Varchar(1)    ,     
       @Bdptype               Varchar(4)         = Null,       
       @Bdpid                     Varchar(16)         = Null,       
       @Bcltaccno             Varchar(50)         = Null,     
       @Filler1  Varchar(100),           
       @Filler2  Int,     
       @Filler3  Int,     
       @Filler4  Int,     
       @Filler5  Int    
    
As    
    
       Declare @Procname Varchar(50)    
       Select @Procname = Object_Name(@@Procid)    
    
       Begin Transaction Trninsans    
    
              Begin    
                     Insert Into Demattransspeed(    
                                          Sett_No,     
                                          Sett_Type,     
                                          Refno,     
                                          Tcode,     
                                          Trtype,     
                                          Party_Code,     
                                          Scrip_Cd,     
                                          Series,     
                                          Qty,     
                                          Trdate,     
                                          Cltaccno,     
                                          Dpid,     
                                          Dpname,     
                                          Isin,     
                                          Branch_Cd,     
                                          Partipantcode,     
                                          Dptype,     
                                          Transno,     
                                          Drcr,     
               Bdptype,                   
               Bdpid,     
                      Bcltaccno,     
               Filler1,             
               Filler2,     
                                          Filler3,     
                                          Filler4,     
               Filler5    
                                          )    
                     Select    
                                          @Sett_No,     
                                          @Sett_Type,     
                                          @Refno,     
                                          @Tcode,     
                                          @Trtype,     
                                          @Party_Code,     
                                          @Scrip_Cd,     
                                          @Series,     
                                          @Qty,     
                                          @Trdate,     
                                          @Cltaccno,     
                                          @Dpid,     
                                          @Dpname,     
                                          @Isin,      
                                          @Branch_Cd,     
                                          @Partipantcode,     
                                          @Dptype,     
                                          @Transno,     
                                          @Drcr,     
               @Bdptype,                   
               @Bdpid,     
                      @Bcltaccno,     
               @Filler1,             
               @Filler2,     
                                          @Filler3,     
                                          @Filler4,     
               @Filler5    
    
                     If @@Error ! = 0    
                            Begin    
                                   Rollback Transaction Trninsans    
                                   Raiserror('Error Inserting Into Table Demattrans.  Error Occurred In Procedure %s.  Rolling Back Transaction...', 16, 1, @Procname)    
                                   Return    
                            End    
                     Else    
                            Begin    
                                   Commit Transaction Trninsans    
                            End    
              End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MF_ACTIVATE
-- --------------------------------------------------
CREATE  PROC [dbo].[MF_ACTIVATE] (@CL_CODE VARCHAR(10))          
AS          
          
DECLARE @CLTCOUNT INT        
        
  SELECT @CLTCOUNT =COUNT(PARTY_CODE) FROM         
  (SELECT PARTY_CODE FROM MFSS_CLIENT   WHERE PARTY_CODE =  @CL_CODE        
   UNION ALL        
   SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_CLIENT  WHERE PARTY_CODE =  @CL_CODE     ) A        
     



     
    IF ( @CLTCOUNT > 0   )

	BEGIN 
	   DECLARE @DPID VARCHAR(16)
	    
		SELECT @DPID =COUNT(ISNULL(NISE_PARTY_CODE,'')) FROM [172.31.16.94].DMAT.DBO.TBL_CLIENT_MASTER WHERE NISE_PARTY_CODE = @CL_CODE

   END  
         
          
          
  IF ( @CLTCOUNT > 0    AND @DPID  <>0)        
     BEGIN         
      --UPDATE MIS.KYC.DBO.TBL_MF_ONETIME_MAILER set MFBoActivated='E',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE  
      DELETE FROM  MFSS_CLIENT WHERE  PARTY_CODE = @CL_CODE
      DELETE FROM  BSEMFSS.DBO.MFSS_CLIENT WHERE  PARTY_CODE = @CL_CODE
      
      DELETE FROM  BBO_FA.DBO.ACMAST WHERE  CLTCODE = @CL_CODE
      
      DELETE FROM MFSS_BROKERAGE_MASTER WHERE PARTY_CODE = @CL_CODE
      DELETE FROM BSEMFSS.DBO.MFSS_BROKERAGE_MASTER WHERE PARTY_CODE = @CL_CODE
      
      DELETE FROM MFSS_DPMASTER   WHERE PARTY_CODE = @CL_CODE
      DELETE FROM BSEMFSS.DBO.MFSS_DPMASTER   WHERE PARTY_CODE = @CL_CODE  
      
      DELETE FROM BBO_FA.DBO.MULTIBANKID   WHERE CLTCODE = @CL_CODE
                     
     END         
             
  --ELSE       
  -- BEGIN    
      
    IF @CL_CODE <> ''          
  BEGIN            
    INSERT INTO MFSS_CLIENT          
    SELECT TOP 1 PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION,SBU,FAMILY,GENDER, OCCUPATION_CODE=isnull(ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),'8'),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB, ISNULL(H.DPHD_GAU_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_GAU_MNAME,'') + ' ' +  ISNULL(H.DPHD_GAU_LNAME,'')  GAURDIAN_NAME,        
    ISNULL(H.DPHD_NOM_PAN_NO,'') GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    (CASE WHEN LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) ='' THEN 'SI' ELSE 'JO' END) MODE_HOLDING, HOLDER2_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_SH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) + ' ' + LTRIM(RTRIM( ISNULL(H.DPHD_SH_LNAME,''))) HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_TH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_TH_MNAME,''))) + ' ' +  LTRIM(RTRIM(ISNULL(H.DPHD_TH_LNAME,''))) HOLDER3_NAME,        
    ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
  FROM CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)   ,
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
  WHERE C.PARTY_CODE = H.DPAM_BBO_CODE     AND H.POAFLAG ='Y'         
   AND C.PARTY_CODE =@CL_CODE        
           
    INSERT INTO BSEMFSS.DBO.MFSS_CLIENT          
    SELECT TOP 1 PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION,SBU,FAMILY,GENDER, OCCUPATION_CODE=ISNULL(ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),'8'),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB, ISNULL(H.DPHD_GAU_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_GAU_MNAME,'') + ' ' +  ISNULL(H.DPHD_GAU_LNAME,'')  GAURDIAN_NAME,        
    ISNULL(H.DPHD_NOM_PAN_NO,'') GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    (CASE WHEN LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) ='' THEN 'SI' ELSE 'JO' END) MODE_HOLDING, HOLDER2_CODE,        
     LTRIM(RTRIM(ISNULL(H.DPHD_SH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) + ' ' + LTRIM(RTRIM( ISNULL(H.DPHD_SH_LNAME,''))) HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_TH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_TH_MNAME,''))) + ' ' +  LTRIM(RTRIM(ISNULL(H.DPHD_TH_LNAME,''))) HOLDER3_NAME,        
   ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
    FROM BSEMFSS.DBO.CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)      ,
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
   WHERE C.PARTY_CODE = H.DPAM_BBO_CODE AND H.POAFLAG ='Y'          
   AND C.PARTY_CODE =@CL_CODE       
            
            
          
          
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','NSE','MFSS' FROM           
   MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','BSE','MFSS' FROM           
   BSEMFSS.DBO.MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
           
           
   INSERT INTO MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM MFSS_BROKERAGE_MASTER)        
           
   INSERT INTO BSEMFSS.DBO.MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_BROKERAGE_MASTER)          
             
             
   INSERT INTO MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM MFSS_CLIENT  WHERE PARTY_CODE =@CL_CODE      
          
           
   INSERT INTO BSEMFSS..MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM BSEMFSS.DBO.MFSS_CLIENT   WHERE PARTY_CODE =@CL_CODE      
         
   INSERT INTO POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM MFSS_CLIENT M        
   LEFT OUTER         
   JOIN POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH        
  
   --BSE        
   INSERT INTO BSEMFSS..POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM BSEMFSS..MFSS_CLIENT M   
   LEFT OUTER         
   JOIN BSEMFSS..POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH       
         
         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID(Cltcode,Bankid,Accno,Acctype,Chequename,Defaultbank,exchange,segment)        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'BSE','MFSS'        
   FROM  BSEMFSS.DBO.MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'NSE','MFSS'        
   FROM  MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME   AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME        
    
    DECLARE @ExistCount int
    
    select @ExistCount=count(0) from MFSS_CLIENT with(Nolock) where party_code= @CL_CODE 
    
    if @ExistCount >0
     begin
  Update MIS.KYC.DBO.TBL_MF_ONETIME_MAILER set MFBoActivated='y',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE         
  end
  
    END       
          
 -- END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MF_ACTIVATE_Campaignwise
-- --------------------------------------------------
          
CREATE PROC [dbo].[MF_ACTIVATE_Campaignwise] (@CL_CODE VARCHAR(10))          
AS          
          
DECLARE @CLTCOUNT INT        
        
  SELECT @CLTCOUNT =COUNT(PARTY_CODE) FROM         
  (SELECT PARTY_CODE FROM MFSS_CLIENT   WHERE PARTY_CODE =  @CL_CODE        
   UNION ALL        
   SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_CLIENT  WHERE PARTY_CODE =  @CL_CODE     ) A        
     
    IF ( @CLTCOUNT > 0   )

	BEGIN 
	   DECLARE @DPID VARCHAR(16)
	    
		SELECT @DPID =COUNT(ISNULL(NISE_PARTY_CODE,'')) FROM [172.31.16.94].DMAT.DBO.TBL_CLIENT_MASTER WHERE NISE_PARTY_CODE = @CL_CODE

   END   
	     
          
          
  IF (@CLTCOUNT > 0    AND @DPID  <>0)   
     BEGIN         
      --UPDATE MIS.KYC.DBO.TBL_MF_ONETIME_MAILER set MFBoActivated='E',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE  
      DELETE FROM  MFSS_CLIENT WHERE  PARTY_CODE = @CL_CODE
      DELETE FROM  BSEMFSS.DBO.MFSS_CLIENT WHERE  PARTY_CODE = @CL_CODE
      
      DELETE FROM  BBO_FA.DBO.ACMAST WHERE  CLTCODE = @CL_CODE
      
      DELETE FROM MFSS_BROKERAGE_MASTER WHERE PARTY_CODE = @CL_CODE
      DELETE FROM BSEMFSS.DBO.MFSS_BROKERAGE_MASTER WHERE PARTY_CODE = @CL_CODE
      
      DELETE FROM MFSS_DPMASTER   WHERE PARTY_CODE = @CL_CODE
      DELETE FROM BSEMFSS.DBO.MFSS_DPMASTER   WHERE PARTY_CODE = @CL_CODE  
      
      DELETE FROM BBO_FA.DBO.MULTIBANKID   WHERE CLTCODE = @CL_CODE
                     
     END         
             
  --ELSE       
  -- BEGIN    
      
    IF @CL_CODE <> ''          
  BEGIN            
    INSERT INTO MFSS_CLIENT          
    SELECT TOP 1 PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION=(case when REGION ='MAHARASHTRA' THEN 'MAHARASTRA' ELSE REGION END),SBU,FAMILY,GENDER, OCCUPATION_CODE=isnull(ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),'8'),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB,   LTRIM(RTRIM(ISNULL(H.DPHD_GAU_FNAME,'')))        
    + ' ' +   LTRIM(RTRIM(ISNULL(H.DPHD_GAU_MNAME,''))) + ' ' +    LTRIM(RTRIM(ISNULL(H.DPHD_GAU_LNAME,'')))  GAURDIAN_NAME,        
    ISNULL(H.DPHD_NOM_PAN_NO,'') GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    (CASE WHEN LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) ='' THEN 'SI' ELSE 'JO' END) MODE_HOLDING, HOLDER2_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_SH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) + ' ' + LTRIM(RTRIM( ISNULL(H.DPHD_SH_LNAME,''))) HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_TH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_TH_MNAME,''))) + ' ' +  LTRIM(RTRIM(ISNULL(H.DPHD_TH_LNAME,''))) HOLDER3_NAME,        
    ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
  FROM CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)   ,
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
  WHERE C.PARTY_CODE = H.DPAM_BBO_CODE     AND H.POAFLAG ='Y'         
   AND C.PARTY_CODE =@CL_CODE               
           
    INSERT INTO BSEMFSS.DBO.MFSS_CLIENT          
    SELECT TOP 1 PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION=(case when REGION ='MAHARASHTRA' THEN 'MAHARASTRA' ELSE REGION END),SBU,FAMILY,GENDER, OCCUPATION_CODE=ISNULL(ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),'8'),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB,   LTRIM(RTRIM(ISNULL(H.DPHD_GAU_FNAME,'') ))       
    + ' ' +   LTRIM(RTRIM(ISNULL(H.DPHD_GAU_MNAME,''))) + ' ' +    LTRIM(RTRIM(ISNULL(H.DPHD_GAU_LNAME,'')))  GAURDIAN_NAME,        
    ISNULL(H.DPHD_NOM_PAN_NO,'') GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    (CASE WHEN LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) ='' THEN 'SI' ELSE 'JO' END) MODE_HOLDING, HOLDER2_CODE,        
     LTRIM(RTRIM(ISNULL(H.DPHD_SH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_SH_MNAME,''))) + ' ' + LTRIM(RTRIM( ISNULL(H.DPHD_SH_LNAME,''))) HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    LTRIM(RTRIM(ISNULL(H.DPHD_TH_FNAME,'')))        
    + ' ' + LTRIM(RTRIM(ISNULL(H.DPHD_TH_MNAME,''))) + ' ' +  LTRIM(RTRIM(ISNULL(H.DPHD_TH_LNAME,''))) HOLDER3_NAME,        
   ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
    FROM BSEMFSS.DBO.CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)      ,
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
   WHERE C.PARTY_CODE = H.DPAM_BBO_CODE AND H.POAFLAG ='Y'          
   AND C.PARTY_CODE =@CL_CODE       
            
            
          
          
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','NSE','MFSS' FROM           
   MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','BSE','MFSS' FROM           
   BSEMFSS.DBO.MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
           
           
   INSERT INTO MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM MFSS_BROKERAGE_MASTER)        
           
   INSERT INTO BSEMFSS.DBO.MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_BROKERAGE_MASTER)          
             
             
   INSERT INTO MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM MFSS_CLIENT  WHERE PARTY_CODE =@CL_CODE      
          
           
   INSERT INTO BSEMFSS..MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM BSEMFSS.DBO.MFSS_CLIENT   WHERE PARTY_CODE =@CL_CODE      
         
   INSERT INTO POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM MFSS_CLIENT M        
   LEFT OUTER         
   JOIN POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH        
           
   --BSE        
   INSERT INTO BSEMFSS..POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM BSEMFSS..MFSS_CLIENT M        
   LEFT OUTER         
   JOIN BSEMFSS..POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH       
         
         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID(Cltcode,Bankid,Accno,Acctype,Chequename,Defaultbank,exchange,segment)        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'BSE','MFSS'        
   FROM  BSEMFSS.DBO.MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'NSE','MFSS'        
   FROM  MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME   AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME        
    
    DECLARE @ExistCount int
    
     
    SELECT @ExistCount =COUNT(PARTY_CODE) FROM         
  (SELECT PARTY_CODE FROM MFSS_CLIENT   WHERE PARTY_CODE =  @CL_CODE        
   UNION ALL        
   SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_CLIENT  WHERE PARTY_CODE =  @CL_CODE     ) A   
    
    if @ExistCount >0
     begin
  Update MIS.KYC.DBO.tbl_Mf_Onetime_Mailer_Campaign set MFBoActivated='y',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE         
  end
  
    END       
          
 -- END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MF_ACTIVTE
-- --------------------------------------------------
          
CREATE PROC MF_ACTIVTE (@CL_CODE VARCHAR(10))          
AS          
          
DECLARE @CLTCOUNT INT        
        
  SELECT @CLTCOUNT =COUNT(PARTY_CODE) FROM         
  (SELECT PARTY_CODE FROM MFSS_CLIENT   WHERE PARTY_CODE =  @CL_CODE        
   UNION ALL        
   SELECT PARTY_CODE FROM BSEMFSS.DBO.MFSS_CLIENT  WHERE PARTY_CODE =  @CL_CODE     ) A        
         
          
          
  IF @CLTCOUNT > 0         
     BEGIN         
      UPDATE MIS.KYC.DBO.TBL_MF_ONETIME_MAILER set MFBoActivated='E',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE           
     END         
        
  ELSE       
   BEGIN    
      
    IF @CL_CODE <> ''          
  BEGIN            
    INSERT INTO MFSS_CLIENT          
    SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION,SBU,FAMILY,GENDER, OCCUPATION_CODE=ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB, ISNULL(H.DPHD_GAU_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_GAU_MNAME,'') + ' ' +  ISNULL(H.DPHD_GAU_LNAME,'')  GAURDIAN_NAME,        
    H.DPHD_NOM_PAN_NO GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    MODE_HOLDING, HOLDER2_CODE,        
    ISNULL(H.DPHD_SH_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_SH_MNAME,'') + ' ' +  ISNULL(H.DPHD_SH_LNAME,'') HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    ISNULL(H.DPHD_TH_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_TH_MNAME,'') + ' ' +  ISNULL(H.DPHD_TH_LNAME,'') HOLDER3_NAME,        
    ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
  FROM CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)      
  LEFT OUTER JOIN       
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
  ON C.PARTY_CODE = H.DPAM_BBO_CODE          
  WHERE C.PARTY_CODE =@CL_CODE        
           
    INSERT INTO BSEMFSS.DBO.MFSS_CLIENT          
    SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE='E',CL_STATUS,BRANCH_CD,SUB_BROKER,        
    TRADER,AREA,REGION,SBU,FAMILY,GENDER, OCCUPATION_CODE=ISNULL(H.OCCUPATION_CODE,C.OCCUPATION_CODE),        
    TAX_STATUS=ISNULL(C.TAX_STATUS,''),C.PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,        
    OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID=ISNULL(EMAIL_ID,''), BANK_NAME,BANK_BRANCH,BANK_CITY=BANK_BRANCH,ACC_NO,        
    PAYMODE,MICR_NO=ISNULL(MICR_NO,''),DOB=DOB, ISNULL(H.DPHD_GAU_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_GAU_MNAME,'') + ' ' +  ISNULL(H.DPHD_GAU_LNAME,'')  GAURDIAN_NAME,        
    H.DPHD_NOM_PAN_NO GAURDIAN_PAN_NO,        
    NOMINEE_NAME,        
    NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,        
    MODE_HOLDING, HOLDER2_CODE,        
    ISNULL(H.DPHD_SH_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_SH_MNAME,'') + ' ' +  ISNULL(H.DPHD_SH_LNAME,'') HOLDER2_NAME,        
    ISNULL(H.DPHD_SH_PAN_NO,'') HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,        
    ISNULL(H.DPHD_TH_FNAME,'')        
    + ' ' + ISNULL(H.DPHD_TH_MNAME,'') + ' ' +  ISNULL(H.DPHD_TH_LNAME,'') HOLDER3_NAME,        
    ISNULL(H.DPHD_TH_PAN_NO,'') HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,        
    BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE=GETDATE(),        
    NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY='E-ACTIVATION',ADDEDON= GETDATE(),        
     ACTIVE_FROM = CONVERT(VARCHAR(11),GETDATE(),120),        
    INACTIVE_FROM = '2049-12-31 23:59', POAFLAG=(CASE WHEN ISNULL(H.POAFLAG,'NO')='Y' THEN 'YES' ELSE 'NO' END ),'',''        
    FROM BSEMFSS.DBO.CLIENT_OTHER_SEGMENT_VIEW  C(NOLOCK)      
   LEFT OUTER JOIN       
  [172.31.16.94].DMAT.CITRUS_USR.VW_HOLDER_DTLS_FORCLASS H          
   ON C.PARTY_CODE = H.DPAM_BBO_CODE          
   WHERE C.PARTY_CODE =@CL_CODE      
            
            
          
          
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','NSE','MFSS' FROM           
   MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
   INSERT INTO BBO_FA.DBO.ACMAST           
   SELECT PARTY_NAME,PARTY_NAME,'ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','BSE','MFSS' FROM           
   MFSS_CLIENT WHERE PARTY_CODE=@CL_CODE          
           
           
           
   INSERT INTO MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM MFSS_BROKERAGE_MASTER)        
           
   INSERT INTO BSEMFSS.DBO.MFSS_BROKERAGE_MASTER          
   SELECT @CL_CODE,1,1,GETDATE(),'2049-12-31 23:59'  WHERE @CL_CODE NOT IN (SELECT PARTY_CODE FROM MFSS_BROKERAGE_MASTER)          
             
             
   INSERT INTO MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM MFSS_CLIENT  WHERE PARTY_CODE =@CL_CODE      
          
           
   INSERT INTO BSEMFSS..MFSS_DPMASTER        
   SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,        
   DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,        
   isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG        
   FROM BSEMFSS.DBO.MFSS_CLIENT   WHERE PARTY_CODE =@CL_CODE      
         
   INSERT INTO POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM MFSS_CLIENT M        
   LEFT OUTER         
   JOIN POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH        
           
   --BSE        
   INSERT INTO BSEMFSS..POBANK        
   SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM BSEMFSS..MFSS_CLIENT M        
   LEFT OUTER         
   JOIN BSEMFSS..POBANK        
   ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME        
   WHERE BANKID IS NULL        
   GROUP BY M.BANK_NAME, BANK_BRANCH       
         
         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID(Cltcode,Bankid,Accno,Acctype,Chequename,Defaultbank,exchange,segment)        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'BSE','MFSS'        
   FROM  BSEMFSS.DBO.MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME         
           
   INSERT INTO BBO_FA.DBO.MULTIBANKID        
   SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'NSE','MFSS'        
   FROM  MFSS_CLIENT M , POBANK P        
   WHERE M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME   AND PARTY_CODE =@CL_CODE      
   GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME        
      
  Update MIS.KYC.DBO.TBL_MF_ONETIME_MAILER set MFBoActivated='y',MFBoDate=getdate() WHERE CLIENT_CODE =@CL_CODE         
    END       
          
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MFSS_CLIENT_CI
-- --------------------------------------------------
  
--DROP TABLE #MFSS_CLIENT_COMMONINTERFACE  
  
  
  
CREATE PROC [dbo].[MFSS_CLIENT_CI]  
AS  
  
/** MFSS CLIENT INSERT PROVIDED BY MKT  
SOURCE : INHOUSE  
DESTINATION :MFSS (NSE,BSE)  
CREATED BY : SIVA KUMAR   
DATE: 2015-11-19' **/  
  
BEGIN   
SELECT * INTO #MFSS_CLIENT_COMMONINTERFACE   
FROM MFSS_CLIENT_COMMONINTERFACE WHERE CIFLAG=0  
  
UPDATE #MFSS_CLIENT_COMMONINTERFACE SET   
DP_TYPE=CD.DEPOSITORY1,  
DPID=CD.DPID1,  
CLTDPID=CD.CLTDPID1  
 FROM [AngelNseCM].MSAJAG.DBO.CLIENT_DETAILS CD WITH(NOLOCK) WHERE #MFSS_CLIENT_COMMONINTERFACE.PARTY_CODE=CD.CL_CODE  
  
DELETE #MFSS_CLIENT_COMMONINTERFACE WHERE PARTY_CODE IN   
(select party_code from mfss_client  
 union all  
 select party_code from BSEMFSS.dbo.mfss_client)   
   
  
  
INSERT INTO MFSS_CLIENT  
SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,ISNULL(GENDER,'')GENDER,OCCUPATION_CODE,TAX_STATUS,  
PAN_NO,KYC_FLAG,ADDR1,ISNULL(ADDR2,'')ADDR2,ISNULL(ADDR3,'')ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,ISNULL(EMAIL_ID,'')EMAIL_ID,  
BANK_NAME,BANK_BRANCH,ISNULL(BANK_CITY,BANK_BRANCH) BANK_CITY,ACC_NO,PAYMODE,ISNULL(MICR_NO,'')MICR_NO,DOB,  
ISNULL(GAURDIAN_NAME,'')GAURDIAN_NAME,ISNULL(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,ISNULL(NOMINEE_NAME,'')NOMINEE_NAME,ISNULL(NOMINEE_RELATION,'')NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,ISNULL(HOLDER2_CODE,'')HOLDER2_CODE,  
ISNULL(HOLDER2_NAME,'')HOLDER2_NAME,ISNULL(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,ISNULL(HOLDER2_KYC_FLAG,'')HOLDER2_KYC_FLAG,  
ISNULL(HOLDER3_CODE,'')HOLDER3_CODE,ISNULL(HOLDER3_NAME,'')HOLDER3_NAME,ISNULL(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,ISNULL(HOLDER3_KYC_FLAG,'')HOLDER3_KYC_FLAG,  
BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,GETDATE() BROK_EFF_DATE,ISNULL(NEFTCODE,'')NEFTCODE,ISNULL(CHEQUENAME,'')CHEQUENAME,ISNULL(RESIFAX,'')RESIFAX,ISNULL(OFFICEFAX,'')OFFICEFAX,  
ISNULL(MAPINID,'')MAPINID,ISNULL(REMARK,'')REMARK,UCC_STATUS,ADDEDBY,GETDATE() ADDEDON,'2015-12-01' ACTIVE_FROM,'2049-12-31 23:59:00.000' INACTIVE_FROM,  
POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE  
FROM #MFSS_CLIENT_COMMONINTERFACE    
WHERE  CIFLAG=0  
  
INSERT INTO BSEMFSS..MFSS_CLIENT  
SELECT PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,ISNULL(GENDER,'')GENDER,OCCUPATION_CODE,TAX_STATUS,  
PAN_NO,KYC_FLAG,ADDR1,ISNULL(ADDR2,'')ADDR2,ISNULL(ADDR3,'')ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,ISNULL(EMAIL_ID,'')EMAIL_ID,  
BANK_NAME,BANK_BRANCH,ISNULL(BANK_CITY,BANK_BRANCH) BANK_CITY,ACC_NO,PAYMODE,ISNULL(MICR_NO,'')MICR_NO,DOB,  
ISNULL(GAURDIAN_NAME,'')GAURDIAN_NAME,ISNULL(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,ISNULL(NOMINEE_NAME,'')NOMINEE_NAME,ISNULL(NOMINEE_RELATION,'')NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,ISNULL(HOLDER2_CODE,'')HOLDER2_CODE,  
ISNULL(HOLDER2_NAME,'')HOLDER2_NAME,ISNULL(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,ISNULL(HOLDER2_KYC_FLAG,'')HOLDER2_KYC_FLAG,  
ISNULL(HOLDER3_CODE,'')HOLDER3_CODE,ISNULL(HOLDER3_NAME,'')HOLDER3_NAME,ISNULL(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,ISNULL(HOLDER3_KYC_FLAG,'')HOLDER3_KYC_FLAG,  
BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,GETDATE() BROK_EFF_DATE,ISNULL(NEFTCODE,'')NEFTCODE,ISNULL(CHEQUENAME,'')CHEQUENAME,ISNULL(RESIFAX,'')RESIFAX,ISNULL(OFFICEFAX,'')OFFICEFAX,  
ISNULL(MAPINID,'')MAPINID,ISNULL(REMARK,'')REMARK,UCC_STATUS,ADDEDBY,GETDATE() ADDEDON,'2015-12-01' ACTIVE_FROM,'2049-12-31 23:59:00.000' INACTIVE_FROM,  
POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
  
INSERT INTO BBO_FA.DBO.ACMAST   
SELECT PARTY_NAME,PARTY_NAME,ACTYP='ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','BSE','MFSS'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
INSERT INTO BBO_FA.DBO.ACMAST   
SELECT PARTY_NAME,PARTY_NAME,ACTYP='ASSET',4,'',PARTY_CODE,'','A0307000000','','',BRANCH_CD,0,'C','','','','NSE','MFSS'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
INSERT INTO MFSS_BROKERAGE_MASTER  
SELECT PARTY_CODE,1,1,GETDATE(),'2049-12-31 23:59:00.000'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
INSERT INTO BSEMFSS..MFSS_BROKERAGE_MASTER  
SELECT PARTY_CODE,1,1,GETDATE(),'2049-12-31 23:59:00.000'  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
INSERT INTO MFSS_DPMASTER  
SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,  
DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,  
isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
INSERT INTO BSEMFSS..MFSS_DPMASTER  
SELECT PARTY_CODE,PARTY_NAME,OCCUPATION_CODE,TAX_STATUS,PAN_NO,DOB,isnull(GAURDIAN_NAME,'')GAURDIAN_NAME,isnull(GAURDIAN_PAN_NO,'')GAURDIAN_PAN_NO,  
DP_TYPE,DPID,CLTDPID,MODE_HOLDING,isnull(HOLDER2_NAME,'')HOLDER2_NAME,isnull(HOLDER2_PAN_NO,'')HOLDER2_PAN_NO,isnull(HOLDER3_NAME,'')HOLDER3_NAME,  
isnull(HOLDER3_PAN_NO,'')HOLDER3_PAN_NO,1,ADDEDBY,getdate(),POAFLAG  
FROM #MFSS_CLIENT_COMMONINTERFACE  
WHERE CIFLAG=0  
  
  
---NSE--  
INSERT INTO POBANK  
SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM #MFSS_CLIENT_COMMONINTERFACE M  
LEFT OUTER   
JOIN POBANK  
ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME  
WHERE BANKID IS NULL  
GROUP BY M.BANK_NAME, BANK_BRANCH  
  
---BSE  
INSERT INTO BSEMFSS..POBANK  
SELECT  M.BANK_NAME, BANK_BRANCH,'','','','','','','','','','','' FROM #MFSS_CLIENT_COMMONINTERFACE M  
LEFT OUTER   
JOIN BSEMFSS..POBANK  
ON M.BANK_NAME= POBANK.BANK_NAME AND BANK_BRANCH=BRANCH_NAME  
WHERE BANKID IS NULL  
GROUP BY M.BANK_NAME, BANK_BRANCH  
  
  
INSERT INTO BBO_FA.DBO.MULTIBANKID(Cltcode,Bankid,Accno,Acctype,Chequename,Defaultbank,exchange,segment)  
SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'BSE','MFSS'  
FROM  #MFSS_CLIENT_COMMONINTERFACE M , POBANK P  
WHERE CIFLAG=0  
AND M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  
GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME   
  
INSERT INTO BBO_FA.DBO.MULTIBANKID  
SELECT PARTY_CODE,MAX(P.BANKID),ACC_NO,BANK_AC_TYPE,PARTY_NAME ,1,'NSE','MFSS'  
FROM  #MFSS_CLIENT_COMMONINTERFACE M , POBANK P  
WHERE CIFLAG=0  
AND M.BANK_NAME= P.BANK_NAME AND M.BANK_BRANCH=P.BRANCH_NAME  
GROUP BY PARTY_CODE,ACC_NO,BANK_AC_TYPE,PARTY_NAME   
  
UPDATE MFSS_CLIENT_COMMONINTERFACE SET CIFLAG=1  
WHERE PARTY_CODE IN   
(SELECT PARTY_CODE FROM #MFSS_CLIENT_COMMONINTERFACE)  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS
-- --------------------------------------------------



  ---EXEC [MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE ]  'JUN 25 2016','JUN 26 2016'
  

CREATE PROC [dbo].[MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS]      
(      
 @FDATE VARCHAR(11)='',      
 @TDATE VARCHAR(11)=''      
)      
      
AS      
BEGIN      
  
 IF @FDATE ='' AND @TDATE =''       
 BEGIN      
  SELECT @FDATE = LEFT(MIN(CL_ACTIVATED_ON),11),@TDATE = LEFT(MAX(CL_ACTIVATED_ON),11)      
  FROM ABVSCITRUS.CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE      
  WHERE DATA_MIGRATE_STAT = 0      
 END  
 
 CREATE TABLE #DATA      
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [BRANCH_CD] [VARCHAR](10) NULL,      
  [PARTY_CODE] [VARCHAR](10) NOT NULL,      
  [SUB_BROKER] [VARCHAR](10) NOT NULL,      
  [TRADER] [VARCHAR](20) NULL,      
  [LONG_NAME] [VARCHAR](100) NULL,      
  [SHORT_NAME] [VARCHAR](30) NULL,      
  [L_ADDRESS1] [VARCHAR](100) NULL,      
  [L_CITY] [VARCHAR](40) NULL,      
  [L_ADDRESS2] [VARCHAR](100) NULL,      
  [L_STATE] [VARCHAR](50) NULL,      
  [L_ADDRESS3] [VARCHAR](100) NULL,      
  [L_NATION] [VARCHAR](15) NULL,      
  [L_ZIP] [VARCHAR](10) NULL,      
  [PAN_GIR_NO] [VARCHAR](50) NULL,      
  [WARD_NO] [VARCHAR](50) NULL,      
  [SEBI_REGN_NO] [VARCHAR](25) NULL,      
  [RES_PHONE1] [VARCHAR](15) NULL,      
  [RES_PHONE2] [VARCHAR](15) NULL,      
  [OFF_PHONE1] [VARCHAR](15) NULL,      
  [OFF_PHONE2] [VARCHAR](15) NULL,      
  [MOBILE_PAGER] [VARCHAR](40) NULL,      
  [FAX] [VARCHAR](15) NULL,      
  [EMAIL] [VARCHAR](100) NULL,      
  [CL_TYPE] [VARCHAR](3) NOT NULL,      
  [CL_STATUS] [VARCHAR](3) NOT NULL,      
  [FAMILY] [VARCHAR](10) NOT NULL,      
  [REGION] [VARCHAR](20) NULL,      
  [AREA] [VARCHAR](20) NULL,      
  [P_ADDRESS1] [VARCHAR](100) NULL,      
  [P_CITY] [VARCHAR](40) NULL,      
  [P_ADDRESS2] [VARCHAR](100) NULL,      
  [P_STATE] [VARCHAR](50) NULL,      
  [P_ADDRESS3] [VARCHAR](100) NULL,      
  [P_NATION] [VARCHAR](15) NULL,      
  [P_ZIP] [VARCHAR](10) NULL,      
  [P_PHONE] [VARCHAR](15) NULL,      
  [ADDEMAILID] [VARCHAR](230) NULL,      
  [SEX] [CHAR](1) NULL,      
  [DOB] [DATETIME] NULL,      
  [INTRODUCER] [VARCHAR](30) NULL,      
  [APPROVER] [VARCHAR](30) NULL,      
  [INTERACTMODE] [TINYINT] NULL,      
  [PASSPORT_NO] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_AT] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_ON] [DATETIME] NULL,      
  [PASSPORT_EXPIRES_ON] [DATETIME] NULL,      
  [LICENCE_NO] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_AT] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_ON] [DATETIME] NULL,      
  [LICENCE_EXPIRES_ON] [DATETIME] NULL,      
  [RAT_CARD_NO] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_AT] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_ON] [DATETIME] NULL,      
  [VOTERSID_NO] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_AT] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_ON] [DATETIME] NULL,      
  [IT_RETURN_YR] [VARCHAR](30) NULL,      
  [IT_RETURN_FILED_ON] [DATETIME] NULL,      
  [REGR_NO] [VARCHAR](50) NULL,      
  [REGR_AT] [VARCHAR](50) NULL,      
  [REGR_ON] [DATETIME] NULL,      
  [REGR_AUTHORITY] [VARCHAR](50) NULL,      
  [CLIENT_AGREEMENT_ON] [DATETIME] NULL,      
  [SETT_MODE] [VARCHAR](50) NULL,      
  [DEALING_WITH_OTHER_TM] [VARCHAR](50) NULL,      
  [OTHER_AC_NO] [VARCHAR](50) NULL,      
  [INTRODUCER_ID] [VARCHAR](50) NULL,      
  [INTRODUCER_RELATION] [VARCHAR](50) NULL,      
  [REPATRIAT_BANK] [NUMERIC](18, 0) NULL,      
  [REPATRIAT_BANK_AC_NO] [VARCHAR](30) NULL,      
  [CHK_KYC_FORM] [TINYINT] NULL,      
  [CHK_CORPORATE_DEED] [TINYINT] NULL,      
  [CHK_BANK_CERTIFICATE] [TINYINT] NULL,      
  [CHK_ANNUAL_REPORT] [TINYINT] NULL,      
  [CHK_NETWORTH_CERT] [TINYINT] NULL,      
  [CHK_CORP_DTLS_RECD] [TINYINT] NULL,      
  [BANK_NAME] [VARCHAR](100) NULL,      
  [BRANCH_NAME] [VARCHAR](50) NULL,      
  [AC_TYPE] [VARCHAR](10) NULL,      
  [AC_NUM] [VARCHAR](20) NULL,      
  [DEPOSITORY1] [VARCHAR](7) NULL,      
  [DPID1] [VARCHAR](16) NULL,      
  [CLTDPID1] [VARCHAR](16) NULL,      
  [POA1] [CHAR](1) NULL,      
  [DEPOSITORY2] [VARCHAR](7) NULL,      
  [DPID2] [VARCHAR](16) NULL,      
  [CLTDPID2] [VARCHAR](16) NULL,      
  [POA2] [CHAR](1) NULL,      
  [DEPOSITORY3] [VARCHAR](7) NULL,      
  [DPID3] [VARCHAR](16) NULL,      
  [CLTDPID3] [VARCHAR](16) NULL,      
  [POA3] [CHAR](1) NULL,      
  [REL_MGR] [VARCHAR](10) NULL,      
  [C_GROUP] [VARCHAR](10) NULL,     
  [SBU] [VARCHAR](10) NULL,      
  [STATUS] [CHAR](1) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [MODIFIDEDBY] [VARCHAR](25) NULL,      
  [MODIFIDEDON] [DATETIME] NULL,      
  [BANK_ID] [VARCHAR](20) NULL,      
  [MAPIN_ID] [VARCHAR](12) NULL,      
  [UCC_CODE] [VARCHAR](12) NULL,      
  [MICR_NO] [VARCHAR](10) NULL,      
  [IFSC_CODE] [VARCHAR](20) NULL,      
  [DIRECTOR_NAME] [VARCHAR](500) NULL,      
  [PAYLOCATION] [VARCHAR](20) NULL,      
  [FMCODE] [VARCHAR](10) NULL,      
  [PARENTCODE] [VARCHAR](10) NULL,      
  [PRODUCTCODE] [VARCHAR](2) NULL,      
  [INCOME_SLAB] [VARCHAR](50) NULL,      
  [NETWORTH_SLAB] [VARCHAR](50) NULL,      
  [AUTOFUNDPAYOUT] [INT] NULL,      
  [SEBI_REG_DATE] [DATETIME] NULL,      
  [SEBI_EXP_DATE] [DATETIME] NULL,      
  [PERSON_TAG] [INT] NULL,      
  [COMMODITY_TRADER] [VARCHAR](20) NULL,      
  [CHANNEL_TYPE] [VARCHAR](20) NULL,      
  [DMA_AGREEMENT_DATE] [DATETIME] NULL,      
  [DMA_ACTIVATION_DATE] [DATETIME] NULL,      
  [FO_TRADER] [VARCHAR](20) NULL,      
  [CDS_TRADER] [VARCHAR](20) NULL,      
  [CDS_SUBBROKER] [VARCHAR](10) NULL,      
  [RES_PHONE1_STD] [VARCHAR](10) NULL,      
  [RES_PHONE2_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE1_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE2_STD] [VARCHAR](10) NULL,      
  [P_PHONE_STD] [VARCHAR](10) NULL,      
  [BANKID] [INT] NULL,      
  [VALID_PARTY] [VARCHAR](1),      
  [VALID_REGION] [VARCHAR](1),      
  [VALID_AREA] [VARCHAR](1),      
  [VALID_TRADER] [VARCHAR](1),      
  [VALID_SUBBROKER] [VARCHAR](1),      
  [VALID_BRANCH] [VARCHAR](1),      
  [VALID_BANK] [VARCHAR](1),      
  [VALID_DPBANK1] [VARCHAR](1),      
  [VALID_DPBANK2] [VARCHAR](1),      
  [VALID_DPBANK3] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1),      
  [OCCUPATION] INT      
 )      
                                  

INSERT INTO #DATA                                      
 SELECT DISTINCT      
  REF_SRNO,CL_CODE,BRANCH_CD,PARTY_CODE,SUB_BROKER,TRADER,      
  LONG_NAME=LEFT(LONG_NAME,100),SHORT_NAME=LEFT(REPLACE(SHORT_NAME, ' NULL ', ''),30),L_ADDRESS1=LEFT(L_ADDRESS1,40),      
  L_CITY=LEFT(L_CITY,40),L_ADDRESS2=LEFT(L_ADDRESS2,40),      
  L_STATE=CASE LEFT(L_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(L_STATE,50) END,      
  L_ADDRESS3=LEFT(L_ADDRESS3,40),L_NATION=LEFT(L_NATION,15),L_ZIP=LEFT(L_ZIP,10),      
  PAN_GIR_NO,WARD_NO,SEBI_REGN_NO=ISNULL(SEBI_REGN_NO,''),RES_PHONE1=LEFT(RES_PHONE1,15),      
  RES_PHONE2=LEFT(RES_PHONE2,15),OFF_PHONE1=LEFT(OFF_PHONE1,15),OFF_PHONE2=LEFT(OFF_PHONE2,15),      
  MOBILE_PAGER=LEFT(MOBILE_PAGER,40),      
  FAX=LEFT(FAX,15),EMAIL=LEFT(EMAIL,100),      
  CL_STATUS,/*CL_TYPE=(CASE CL_TYPE WHEN 'CLI' THEN 'ROR' ELSE CL_TYPE END)*/
  CL_TYPE=(CASE CL_TYPE WHEN 'ROR' THEN 'IND' ELSE CL_TYPE END),FAMILY,REGION,AREA,      
  P_ADDRESS1=LEFT(P_ADDRESS1,100),P_CITY=LEFT(P_CITY,20),      
  P_ADDRESS2=LEFT(P_ADDRESS2,100),P_STATE=CASE LEFT(P_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(P_STATE,50) END,      
  P_ADDRESS3=LEFT(P_ADDRESS3,100),P_NATION=LEFT(P_NATION,15),P_ZIP=LEFT(P_ZIP,10),      
  P_PHONE=LEFT(P_PHONE,15),ADDEMAILID=LEFT(ADDEMAILID,230),      
  SEX=ISNULL(SEX, 'M'),DOB=CONVERT(DATETIME,DOB,103),INTRODUCER=LEFT(INTRODUCER,30),APPROVER,INTERACTMODE,PASSPORT_NO,PASSPORT_ISSUED_AT,      
  PASSPORT_ISSUED_ON,PASSPORT_EXPIRES_ON,LICENCE_NO,LICENCE_ISSUED_AT,      
  LICENCE_ISSUED_ON,LICENCE_EXPIRES_ON,RAT_CARD_NO,RAT_CARD_ISSUED_AT,      
  RAT_CARD_ISSUED_ON,VOTERSID_NO,VOTERSID_ISSUED_AT,VOTERSID_ISSUED_ON,      
  IT_RETURN_YR,IT_RETURN_FILED_ON,REGR_NO,REGR_AT,REGR_ON,REGR_AUTHORITY,      
  CLIENT_AGREEMENT_ON,SETT_MODE,DEALING_WITH_OTHER_TM,OTHER_AC_NO,INTRODUCER_ID,      
  INTRODUCER_RELATION,REPATRIAT_BANK,REPATRIAT_BANK_AC_NO,CHK_KYC_FORM,      
  CHK_CORPORATE_DEED,CHK_BANK_CERTIFICATE,CHK_ANNUAL_REPORT,CHK_NETWORTH_CERT,      
  CHK_CORP_DTLS_RECD,BANK_NAME,BRANCH_NAME=LEFT(BRANCH_NAME,50),AC_TYPE=LEFT(AC_TYPE, 1),AC_NUM,DEPOSITORY1,DPID1,      
  CLTDPID1,POA1 = CASE WHEN POA1 = '0' THEN '' ELSE POA1 END,DEPOSITORY2,      
  DPID2 = CASE WHEN CONVERT(VARCHAR, DPID2) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID2) END,CLTDPID2,POA2,DEPOSITORY3,      
  DPID3 = CASE WHEN CONVERT(VARCHAR, DPID3) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID3) END,CLTDPID3,      
  POA3,REL_MGR,C_GROUP,SBU,[STATUS],IMP_STATUS,MODIFIDEDBY,MODIFIDEDON,BANK_ID,      
  MAPIN_ID,UCC_CODE = PARTY_CODE,MICR_NO,IFSC_CODE,DIRECTOR_NAME,      
  PAYLOCATION = '',FMCODE,PARENTCODE,PRODUCTCODE,      
  INCOME_SLAB,NETWORTH_SLAB,AUTOFUNDPAYOUT,SEBI_REG_DATE,SEBI_EXP_DATE,PERSON_TAG,      
  COMMODITY_TRADER,CHANNEL_TYPE,DMA_AGREEMENT_DATE,DMA_ACTIVATION_DATE,FO_TRADER,      
  CDS_TRADER,CDS_SUBBROKER,RES_PHONE1_STD=LEFT(RES_PHONE1_STD,10),RES_PHONE2_STD=LEFT(RES_PHONE2_STD,10),      
  OFF_PHONE1_STD=LEFT(OFF_PHONE1_STD,10),OFF_PHONE2_STD=LEFT(OFF_PHONE2_STD,10),P_PHONE_STD=LEFT(P_PHONE_STD,10),BANKID=0,      
  VALID_PARTY='N',VALID_REGION = 'N',VALID_AREA = 'N',VALID_TRADER = 'N',VALID_SUBBROKER = 'N',      
  VALID_BRANCH = 'N',VALID_BANK = CASE WHEN AC_NUM ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK1 = CASE WHEN ISNULL(CLTDPID1, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK2 = CASE WHEN ISNULL(CLTDPID2, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK3 = CASE WHEN ISNULL(CLTDPID3, '') ='' THEN 'Y' ELSE 'N' END,      
  RECVALID ='N', OCCUPATION   
 FROM       
  ABVSCITRUS.CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE      
 WHERE      
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'       
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'      
  AND ISNULL(CL_type,'') <> ''   
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')

  
  
 IF (SELECT COUNT(1) FROM #DATA) = 0 RETURN      
      
 CREATE TABLE #DATA_BROK       
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [EXCHANGE] [VARCHAR](3) NOT NULL,      
  [SEGMENT] [VARCHAR](7) NOT NULL,      
  [BROK_SCHEME] [TINYINT] NULL,      
  [TRD_BROK] [INT] NULL,      
  [DEL_BROK] [INT] NULL,      
  [SER_TAX] [TINYINT] NULL,      
  [SER_TAX_METHOD] [TINYINT] NULL,      
  [CREDIT_LIMIT] [INT] NOT NULL,      
  [INACTIVE_FROM] [DATETIME] NULL,      
  [PRINT_OPTIONS] [TINYINT] NULL,      
  [NO_OF_COPIES] [INT] NULL,      
  [PARTICIPANT_CODE] [VARCHAR](15) NULL,      
  [CUSTODIAN_CODE] [VARCHAR](50) NULL,      
  [INST_CONTRACT] [CHAR](1) NULL,      
  [ROUND_STYLE] [INT] NULL,      
  [STP_PROVIDER] [VARCHAR](5) NULL,      
  [STP_RP_STYLE] [TINYINT] NULL,      
  [MARKET_TYPE] [INT] NULL,      
  [MULTIPLIER] [INT] NULL,      
  [CHARGED] [INT] NULL,      
  [MAINTENANCE] [INT] NULL,      
  [REQD_BY_EXCH] [INT] NULL,      
  [REQD_BY_BROKER] [INT] NULL,      
  [CLIENT_RATING] [VARCHAR](10) NULL,      
  [DEBIT_BALANCE] [CHAR](1) NULL,      
  [INTER_SETT] [CHAR](1) NULL,      
  [TRD_STT] [MONEY] NULL,      
  [TRD_TRAN_CHRGS] [FLOAT] NULL,      
  [TRD_SEBI_FEES] [MONEY] NULL,      
  [TRD_STAMP_DUTY] [MONEY] NULL,      
  [TRD_OTHER_CHRGS] [MONEY] NULL,      
  [TRD_EFF_DT] [DATETIME] NULL,      
  [DEL_STT] [MONEY] NULL,      
  [DEL_TRAN_CHRGS] [FLOAT] NULL,      
  [DEL_SEBI_FEES] [MONEY] NULL,      
  [DEL_STAMP_DUTY] [MONEY] NULL,      
  [DEL_OTHER_CHRGS] [MONEY] NULL,      
  [DEL_EFF_DT] [DATETIME] NULL,      
  [ROUNDING_METHOD] [VARCHAR](10) NULL,      
  [ROUND_TO_DIGIT] [TINYINT] NULL,      
  [ROUND_TO_PAISE] [INT] NULL,      
  [FUT_BROK] [INT] NULL,      
  [FUT_OPT_BROK] [INT] NULL,      
  [FUT_FUT_FIN_BROK] [INT] NULL,      
  [FUT_OPT_EXC] [INT] NULL,      
  [FUT_BROK_APPLICABLE] [INT] NULL,      
  [FUT_STT] [SMALLINT] NULL,      
  [FUT_TRAN_CHRGS] [SMALLINT] NULL,      
  [FUT_SEBI_FEES] [SMALLINT] NULL,      
  [FUT_STAMP_DUTY] [SMALLINT] NULL,      
  [FUT_OTHER_CHRGS] [SMALLINT] NULL,      
  [STATUS] [CHAR](1) NULL,      
  [MODIFIEDON] [DATETIME] NULL,      
  [MODIFIEDBY] [VARCHAR](25) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [PAY_B3B_PAYMENT] [CHAR](1) NULL,      
  [PAY_BANK_NAME] [VARCHAR](50) NULL,      
  [PAY_BRANCH_NAME] [VARCHAR](50) NULL,      
  [PAY_AC_NO] [VARCHAR](20) NULL,      
  [PAY_PAYMENT_MODE] [CHAR](1) NULL,      
  [BROK_EFF_DATE] [DATETIME] NULL,      
  [INST_TRD_BROK] [INT] NULL,      
  [INST_DEL_BROK] [INT] NULL,      
  [SYSTEMDATE] [DATETIME] NULL,      
  [ACTIVE_DATE] [DATETIME] NULL,      
  [CHECKACTIVECLIENT] [VARCHAR](1) NULL,      
  [DEACTIVE_REMARKS] [VARCHAR](100) NULL,      
  [DEACTIVE_VALUE] [VARCHAR](1) NULL,      
  [VALUE_PACK] [VARCHAR](20) NULL,      
  [VALID_TRD_BROK] [VARCHAR](1),      
  [VALID_DEL_BROK] [VARCHAR](1),      
  [VALID_FUT_BROK] [VARCHAR](1),      
  [VALID_OPT_BROK] [VARCHAR](1),      
  [VALID_FUT_EXP_BROK] [VARCHAR](1),      
  [VALID_OPT_EXC_BROK] [VARCHAR](1),      
  [VALID_VALUEPACK_BROK] [VARCHAR](1),      
  [VALID_EXCHANGE] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1)      
 )      
                           
 INSERT INTO #DATA_BROK      
 SELECT       
  REF_SRNO,CL_CODE,EXCHANGE,SEGMENT,      
  BROK_SCHEME = (CASE WHEN SEGMENT NOT IN ('CAPITAL', 'SLBS')      
  THEN BROK_SCHEME ELSE (CASE WHEN BROK_SCHEME = 1 THEN 2 ELSE BROK_SCHEME END)      
  END),      
  TRD_BROK,DEL_BROK,SER_TAX,SER_TAX_METHOD,CREDIT_LIMIT,INACTIVE_FROM,PRINT_OPTIONS,      
  NO_OF_COPIES,PARTICIPANT_CODE,CUSTODIAN_CODE,INST_CONTRACT,ROUND_STYLE,STP_PROVIDER,STP_RP_STYLE,MARKET_TYPE,MULTIPLIER,CHARGED,      
  MAINTENANCE,REQD_BY_EXCH,REQD_BY_BROKER,CLIENT_RATING,DEBIT_BALANCE,INTER_SETT,TRD_STT,TRD_TRAN_CHRGS,TRD_SEBI_FEES,TRD_STAMP_DUTY,      
  TRD_OTHER_CHRGS,TRD_EFF_DT,DEL_STT,DEL_TRAN_CHRGS,DEL_SEBI_FEES,DEL_STAMP_DUTY,DEL_OTHER_CHRGS,DEL_EFF_DT,ROUNDING_METHOD,      
  ROUND_TO_DIGIT,ROUND_TO_PAISE,FUT_BROK,FUT_OPT_BROK,FUT_FUT_FIN_BROK,FUT_OPT_EXC,FUT_BROK_APPLICABLE,FUT_STT,FUT_TRAN_CHRGS,      
  FUT_SEBI_FEES,FUT_STAMP_DUTY,FUT_OTHER_CHRGS,[STATUS],MODIFIEDON,MODIFIEDBY,IMP_STATUS,PAY_B3B_PAYMENT,PAY_BANK_NAME,PAY_BRANCH_NAME,      
  PAY_AC_NO,PAY_PAYMENT_MODE,BROK_EFF_DATE,INST_TRD_BROK,INST_DEL_BROK,SYSTEMDATE,ACTIVE_DATE,CHECKACTIVECLIENT,DEACTIVE_REMARKS,      
  DEACTIVE_VALUE,TRD_VALUE_PACK,      
  VALID_TRD_BROK = 'N',VALID_DEL_BROK = 'N',VALID_FUT_BROK = 'N',VALID_OPT_BROK = 'N',      
  VALID_FUT_EXP_BROK = 'N',VALID_OPT_EXC_BROK = 'N',VALID_VALUEPACK_BROK = 'N',VALID_EXCHANGE='N',RECVALID = 'N'       
 FROM       
  ABVSCITRUS.crmdb_a.dbo.VIEW_CLASS_CLIENT_BROK_DETAILS_UPDATE      
 WHERE       
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'        
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'      
  --AND EXCHANGE NOT IN ('NCX','MCX')      
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')
    
 -- TO REMOVE (2 LINES ONLY FOR UAT SERVER)      
 -- DELETE #DATA WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
 -- DELETE #DATA_BROK WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA_BROK.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
     
      
  --- VALID_PARTY EQ  ------         
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, mfss_client AS B      
  WHERE A.CL_CODE = B.PARTY_CODE      
      
  --- VALID_PARTY COMM  ------         
  /*sURESH UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, CLIENT_DETAILS AS B      
  WHERE A.CL_CODE = B.CL_CODE --*/      
      
  --- VALID_PARTY DP  ------          
  /**  
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, AGMUBODPL3.DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B      
  WHERE A.CL_CODE = B.CM_BLSAVINGCD AND VALID_PARTY = 'N'          
      
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, AGMUBODPL3.DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B      
  WHERE A.PAN_GIR_NO = ltrim(rtrim(B.CB_PANNO)) AND VALID_PARTY = 'N'      
  **/  
    
  ---- VALIDATE REGION ----       
  UPDATE #DATA      
  SET VALID_REGION= 'Y'      
  FROM #DATA AS A, REGION AS B      
  WHERE A.REGION = B.REGIONCODE      
      
  ---- VALIDATE AREA ----      
  UPDATE #DATA       
  SET VALID_AREA = 'Y'       
  FROM #DATA AS A, AREA AS B       
  WHERE A.AREA = B.AREACODE      
      
  ---- VALIDATE TRADER ----      
  UPDATE #DATA      
  SET VALID_TRADER = 'Y'      
  FROM #DATA AS A, BRANCHES AS B      
  WHERE A.TRADER = B.SHORT_NAME      
  AND A.BRANCH_CD = B.BRANCH_CD      
      
  ---- VALIDATE SUBBROKER ----      
  UPDATE #DATA      
  SET VALID_SUBBROKER = 'Y'      
  FROM #DATA AS A, SUBBROKERS AS B      
  WHERE A.SUB_BROKER = B.SUB_BROKER      
                                       
  ---- VALIDATE BRANCH ----      
  UPDATE #DATA       
  SET VALID_BRANCH = 'Y'      
  FROM #DATA AS A, BRANCH AS B       
  WHERE A.BRANCH_CD = B.BRANCH_CODE       
      
  ---- VALIDATE BANK ----      
       
  UPDATE #DATA       
  SET VALID_BANK = 'Y' /* suresh ,BANKID=B.RBI_BANKID      
  FROM #DATA AS A, ACCOUNT.DBO.RBIBANKMASTER AS B       
  WHERE A.BANK_NAME = B.BANK_NAME       
  AND A.BRANCH_NAME = B.BRANCH_NAME       
  AND A.MICR_NO = B.MICR_CODE       
  AND A.IFSC_CODE = ISNULL(B.IFSC_CODE,'')      
  AND AC_NUM <> ''-*/      
      
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK1 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID1 = B.BANKID       
  AND CLTDPID1<> ''                                       
      
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK2 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID2 = B.BANKID       
  AND CLTDPID2<> ''                              
                              
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK3 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID3 = B.BANKID       
  AND CLTDPID3<> ''      
      
  -- UPDATING VALID RECORD -----      
  UPDATE #DATA     SET RECVALID='Y'        
  WHERE      
  VALID_PARTY='Y'      
  AND VALID_REGION = 'Y'        
  AND VALID_AREA = 'Y'        
  AND VALID_TRADER = 'Y'        
  AND VALID_SUBBROKER = 'Y'        
  AND VALID_BRANCH = 'Y'        
  AND VALID_BANK = 'Y'        
  AND VALID_DPBANK1 = 'Y'       
  AND VALID_DPBANK2 = 'Y'       
  AND VALID_DPBANK3 = 'Y'      
      
  

    
 UPDATE C SET      
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,      
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,         
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,    
 BRANCH_CD= CASE WHEN ISNULL(A.BRANCH_CD, '') <> '' THEN ISNULL(A.BRANCH_CD, '') ELSE C.BRANCH_CD END ,         
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,       
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,        
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,          
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,          
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,         
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,       
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,          
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,       
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,          
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,         
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,        
 ZIP= CASE WHEN ISNULL(A.L_ZIP, '') <> '' THEN ISNULL(A.L_ZIP, '') ELSE C.ZIP END,          
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,         
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,         
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,       
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,        
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,         
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,       
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,      
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,          
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,         
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,     
 --INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,       
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE      
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,          
 --HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,          
 --HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,          
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END     
 FROM #DATA A LEFT OUTER JOIN ABVSCITRUS.CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,
  BSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE  

UPDATE NSEMFSS.DBO.MFSS_CLIENT SET      
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,      
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,         
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,    
 BRANCH_CD= CASE WHEN ISNULL(A.BRANCH_CD, '') <> '' THEN ISNULL(A.BRANCH_CD, '') ELSE C.BRANCH_CD END ,         
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,       
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,        
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,          
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,          
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,         
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,       
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,          
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,       
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,          
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,         
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,        
 ZIP= CASE WHEN ISNULL(A.L_ZIP, '') <> '' THEN ISNULL(A.L_ZIP, '') ELSE C.ZIP END,          
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,         
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,         
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,       
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,        
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,         
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,       
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,      
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,          
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,         
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,     
-- INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,       
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION      
-- TAX_STATUS=FMCODE,      
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,          
-- HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,          
-- HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,          
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END     
 FROM #DATA A LEFT OUTER JOIN ABVSCITRUS.CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,
  NSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE  

   
      
 /*UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C                      
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='BSE'      
 AND B.SEGMENT='CAPITAL'     */    
               
 ----------------------------------------------------------------------------------------------------------------                                    
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 PARTY_NAME=A.LONG_NAME,      
 CL_TYPE=A.CL_TYPE ,       
 CL_STATUS=A.CL_STATUS ,      
 BRANCH_CD=A.BRANCH_CD ,      
 SUB_BROKER=A.SUB_BROKER,      
 TRADER=A.TRADER ,      
 AREA=A.AREA ,      
 REGION=A.REGION ,       
 FAMILY=A.FAMILY,      
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO=A.PAN_GIR_NO ,      
 ADDR1=A.L_ADDRESS1 ,      
 ADDR2=A.L_ADDRESS2 ,      
 ADDR3=ISNULL(A.L_ADDRESS3, ''),      
 CITY=A.L_CITY ,      
 STATE=A.L_STATE ,      
 ZIP=A.L_ZIP ,      
 NATION=A.L_NATION ,      
 OFFICE_PHONE=A.P_PHONE ,      
 RES_PHONE=A.RES_PHONE1 ,      
 MOBILE_NO=A.MOBILE_PAGER ,      
 EMAIL_ID=A.EMAIL ,      
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=A.AC_NUM ,      
 MICR_NO=A.MICR_NO ,      
 NEFTCODE=A.IFSC_CODE,      
 DOB=A.DOB ,      
 BANK_AC_TYPE=CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END ,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59',      
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE,      
 HOLDER2_NAME=ISNULL(APP_NAME_2, ''),      
 HOLDER2_PAN_NO=ISNULL(APP_PAN_NO_2, ''),      
 HOLDER3_NAME=ISNULL(APP_NAME_3, ''),      
 HOLDER3_PAN_NO=ISNULL(APP_PAN_NO_3, '')      
 FROM #DATA A LEFT OUTER JOIN ABVSCITRUS.CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE, ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE       
      
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C          
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='NSE'      
 AND B.SEGMENT='CAPITAL'  */

 UPDATE A
SET
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.ACNAME END,
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.LONGNAME END
--BRANCHCODE= CASE WHEN #DATA.BRANCH_CD <> '' THEN #DATA.BRANCH_CD ELSE A.BRANCHCODE END
FROM #DATA ,BBO_FA.DBO.ACMAST A WHERE RECVALID='Y' 
AND #DATA.CL_CODE=A.CLTCODE     
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE 
AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')  
 
 

/*UPDATE ANGELFO.BBO_FA.DBO.ACMAST 
SET
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.ACNAME END,
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.LONGNAME END,
BRANCHCODE=#DATA.BRANCH_CD
FROM #DATA WHERE RECVALID='Y'      
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')          */
      
 /*DELETE ANGELFO.BBO_FA.DBO.ACMAST      
 FROM ANGELFO.BBO_FA.DBO.ACMAST AS A,#DATA AS B ,#DATA_BROK C      
 WHERE B.RECVALID = 'Y'      
 AND A.CLTCODE = B.PARTY_CODE      
 AND B.CL_CODE=C.CL_CODE       
 AND C.EXCHANGE IN ('NSE','BSE') AND C.SEGMENT='CAPITAL'      
        
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME  , LONG_NAME , 'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'NSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
      
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME ,LONG_NAME ,'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'BSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
*/   

 UPDATE A    
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,      
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END     
 FROM NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   
 
  UPDATE A     
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,      
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END     
 FROM BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   
 
 /*             
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'      
         
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   */
        
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='NSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='BSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 /*INSERT INTO ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT      
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'       
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='NSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM ANGELFO.NSEMFSS.DBO.MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE) */      
                 
 INSERT INTO ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT       
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'        
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='BSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM BSEMFSS..MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE)     

 DELETE ANGELFO.BBO_FA.DBO.MULTIBANKID      
 FROM ANGELFO.BBO_FA.DBO.MULTIBANKID AS A,#DATA AS B      
 WHERE B.RECVALID = 'Y'      
 AND B.CL_CODE=A.CLTCODE AND SEGMENT='MFSS'        
                 
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','NSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'      
      
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','BSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'     */   
    
 ------------------------------------------------------------------------------------------                   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_01082018
-- --------------------------------------------------
  
  
  
  ---EXEC [MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE ]  'JUN 25 2016','JUN 26 2016' 
  
  -- exec MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_01082018 
    
  
CREATE  PROC [dbo].[MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_01082018]        
(        
 @FDATE VARCHAR(11)='',        
 @TDATE VARCHAR(11)=''        
)        
        
AS        
BEGIN        
    
 IF @FDATE ='' AND @TDATE =''         
 BEGIN        
  SELECT @FDATE = LEFT(MIN(CL_ACTIVATED_ON),11),@TDATE = LEFT(MAX(CL_ACTIVATED_ON),11)        
  FROM [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE        
  WHERE DATA_MIGRATE_STAT = 0        
 END  
 
 print @FDATE  
   
 CREATE TABLE #DATA        
 (        
  [SRNO] [INT] NOT NULL,        
  [CL_CODE] [VARCHAR](10) NOT NULL,        
  [BRANCH_CD] [VARCHAR](10) NULL,        
  [PARTY_CODE] [VARCHAR](10) NOT NULL,        
  [SUB_BROKER] [VARCHAR](10) NOT NULL,        
  [TRADER] [VARCHAR](20) NULL,        
  [LONG_NAME] [VARCHAR](100) NULL,        
  [SHORT_NAME] [VARCHAR](30) NULL,        
  [L_ADDRESS1] [VARCHAR](100) NULL,        
  [L_CITY] [VARCHAR](40) NULL,        
  [L_ADDRESS2] [VARCHAR](100) NULL,        
  [L_STATE] [VARCHAR](50) NULL,        
  [L_ADDRESS3] [VARCHAR](100) NULL,        
  [L_NATION] [VARCHAR](15) NULL,        
  [L_ZIP] [VARCHAR](10) NULL,        
  [PAN_GIR_NO] [VARCHAR](50) NULL,        
  [WARD_NO] [VARCHAR](50) NULL,        
  [SEBI_REGN_NO] [VARCHAR](25) NULL,        
  [RES_PHONE1] [VARCHAR](15) NULL,        
  [RES_PHONE2] [VARCHAR](15) NULL,        
  [OFF_PHONE1] [VARCHAR](15) NULL,        
  [OFF_PHONE2] [VARCHAR](15) NULL,        
  [MOBILE_PAGER] [VARCHAR](40) NULL,        
  [FAX] [VARCHAR](15) NULL,        
  [EMAIL] [VARCHAR](100) NULL,        
  [CL_TYPE] [VARCHAR](3) NOT NULL,        
  [CL_STATUS] [VARCHAR](3) NOT NULL,        
  [FAMILY] [VARCHAR](10) NOT NULL,        
  [REGION] [VARCHAR](20) NULL,        
  [AREA] [VARCHAR](20) NULL,        
  [P_ADDRESS1] [VARCHAR](100) NULL,        
  [P_CITY] [VARCHAR](40) NULL,        
  [P_ADDRESS2] [VARCHAR](100) NULL,        
  [P_STATE] [VARCHAR](50) NULL,        
  [P_ADDRESS3] [VARCHAR](100) NULL,        
  [P_NATION] [VARCHAR](15) NULL,        
  [P_ZIP] [VARCHAR](10) NULL,        
  [P_PHONE] [VARCHAR](15) NULL,        
  [ADDEMAILID] [VARCHAR](230) NULL,        
  [SEX] [CHAR](1) NULL,        
  [DOB] [DATETIME] NULL,        
  [INTRODUCER] [VARCHAR](30) NULL,        
  [APPROVER] [VARCHAR](30) NULL,        
  [INTERACTMODE] [TINYINT] NULL,        
  [PASSPORT_NO] [VARCHAR](30) NULL,        
  [PASSPORT_ISSUED_AT] [VARCHAR](30) NULL,        
  [PASSPORT_ISSUED_ON] [DATETIME] NULL,        
  [PASSPORT_EXPIRES_ON] [DATETIME] NULL,        
  [LICENCE_NO] [VARCHAR](30) NULL,        
  [LICENCE_ISSUED_AT] [VARCHAR](30) NULL,        
  [LICENCE_ISSUED_ON] [DATETIME] NULL,        
  [LICENCE_EXPIRES_ON] [DATETIME] NULL,        
  [RAT_CARD_NO] [VARCHAR](30) NULL,        
  [RAT_CARD_ISSUED_AT] [VARCHAR](30) NULL,        
  [RAT_CARD_ISSUED_ON] [DATETIME] NULL,        
  [VOTERSID_NO] [VARCHAR](30) NULL,        
  [VOTERSID_ISSUED_AT] [VARCHAR](30) NULL,        
  [VOTERSID_ISSUED_ON] [DATETIME] NULL,        
  [IT_RETURN_YR] [VARCHAR](30) NULL,        
  [IT_RETURN_FILED_ON] [DATETIME] NULL,        
  [REGR_NO] [VARCHAR](50) NULL,        
  [REGR_AT] [VARCHAR](50) NULL,        
  [REGR_ON] [DATETIME] NULL,        
  [REGR_AUTHORITY] [VARCHAR](50) NULL,        
  [CLIENT_AGREEMENT_ON] [DATETIME] NULL,        
  [SETT_MODE] [VARCHAR](50) NULL,        
  [DEALING_WITH_OTHER_TM] [VARCHAR](50) NULL,        
  [OTHER_AC_NO] [VARCHAR](50) NULL,        
  [INTRODUCER_ID] [VARCHAR](50) NULL,        
  [INTRODUCER_RELATION] [VARCHAR](50) NULL,        
  [REPATRIAT_BANK] [NUMERIC](18, 0) NULL,        
  [REPATRIAT_BANK_AC_NO] [VARCHAR](30) NULL,        
  [CHK_KYC_FORM] [TINYINT] NULL,        
  [CHK_CORPORATE_DEED] [TINYINT] NULL,        
  [CHK_BANK_CERTIFICATE] [TINYINT] NULL,        
  [CHK_ANNUAL_REPORT] [TINYINT] NULL,        
  [CHK_NETWORTH_CERT] [TINYINT] NULL,        
  [CHK_CORP_DTLS_RECD] [TINYINT] NULL,        
  [BANK_NAME] [VARCHAR](100) NULL,        
  [BRANCH_NAME] [VARCHAR](50) NULL,        
  [AC_TYPE] [VARCHAR](10) NULL,        
  [AC_NUM] [VARCHAR](20) NULL,        
  [DEPOSITORY1] [VARCHAR](7) NULL,        
  [DPID1] [VARCHAR](16) NULL,        
  [CLTDPID1] [VARCHAR](16) NULL,        
  [POA1] [CHAR](1) NULL,        
  [DEPOSITORY2] [VARCHAR](7) NULL,        
  [DPID2] [VARCHAR](16) NULL,        
  [CLTDPID2] [VARCHAR](16) NULL,        
  [POA2] [CHAR](1) NULL,        
  [DEPOSITORY3] [VARCHAR](7) NULL,        
  [DPID3] [VARCHAR](16) NULL,        
  [CLTDPID3] [VARCHAR](16) NULL,        
  [POA3] [CHAR](1) NULL,        
  [REL_MGR] [VARCHAR](10) NULL,        
  [C_GROUP] [VARCHAR](10) NULL,       
  [SBU] [VARCHAR](10) NULL,        
  [STATUS] [CHAR](1) NULL,        
  [IMP_STATUS] [TINYINT] NULL,        
  [MODIFIDEDBY] [VARCHAR](25) NULL,        
  [MODIFIDEDON] [DATETIME] NULL,        
  [BANK_ID] [VARCHAR](20) NULL,        
  [MAPIN_ID] [VARCHAR](12) NULL,        
  [UCC_CODE] [VARCHAR](12) NULL,        
  [MICR_NO] [VARCHAR](10) NULL,        
  [IFSC_CODE] [VARCHAR](20) NULL,        
  [DIRECTOR_NAME] [VARCHAR](500) NULL,        
  [PAYLOCATION] [VARCHAR](20) NULL,        
  [FMCODE] [VARCHAR](10) NULL,        
  [PARENTCODE] [VARCHAR](10) NULL,        
  [PRODUCTCODE] [VARCHAR](2) NULL,        
  [INCOME_SLAB] [VARCHAR](50) NULL,        
  [NETWORTH_SLAB] [VARCHAR](50) NULL,        
  [AUTOFUNDPAYOUT] [INT] NULL,        
  [SEBI_REG_DATE] [DATETIME] NULL,        
  [SEBI_EXP_DATE] [DATETIME] NULL,        
  [PERSON_TAG] [INT] NULL,        
  [COMMODITY_TRADER] [VARCHAR](20) NULL,        
  [CHANNEL_TYPE] [VARCHAR](20) NULL,        
  [DMA_AGREEMENT_DATE] [DATETIME] NULL,        
  [DMA_ACTIVATION_DATE] [DATETIME] NULL,        
  [FO_TRADER] [VARCHAR](20) NULL,        
  [CDS_TRADER] [VARCHAR](20) NULL,        
  [CDS_SUBBROKER] [VARCHAR](10) NULL,        
  [RES_PHONE1_STD] [VARCHAR](10) NULL,        
  [RES_PHONE2_STD] [VARCHAR](10) NULL,        
  [OFF_PHONE1_STD] [VARCHAR](10) NULL,        
  [OFF_PHONE2_STD] [VARCHAR](10) NULL,        
  [P_PHONE_STD] [VARCHAR](10) NULL,        
  [BANKID] [INT] NULL,        
  [VALID_PARTY] [VARCHAR](1),        
  [VALID_REGION] [VARCHAR](1),        
  [VALID_AREA] [VARCHAR](1),        
  [VALID_TRADER] [VARCHAR](1),        
  [VALID_SUBBROKER] [VARCHAR](1),        
  [VALID_BRANCH] [VARCHAR](1),        
  [VALID_BANK] [VARCHAR](1),        
  [VALID_DPBANK1] [VARCHAR](1),        
  [VALID_DPBANK2] [VARCHAR](1),        
  [VALID_DPBANK3] [VARCHAR](1),        
  [RECVALID] [VARCHAR](1),        
  [OCCUPATION] INT        
 )        
                                    
  
INSERT INTO #DATA                                        
 SELECT DISTINCT        
  REF_SRNO,CL_CODE,BRANCH_CD,PARTY_CODE,SUB_BROKER,TRADER,        
  LONG_NAME=LEFT(LONG_NAME,100),SHORT_NAME=LEFT(REPLACE(SHORT_NAME, ' NULL ', ''),30),L_ADDRESS1=LEFT(L_ADDRESS1,40),        
  L_CITY=LEFT(L_CITY,40),L_ADDRESS2=LEFT(L_ADDRESS2,40),        
  L_STATE=CASE LEFT(L_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(L_STATE,50) END,        
  L_ADDRESS3=LEFT(L_ADDRESS3,40),L_NATION=LEFT(L_NATION,15),L_ZIP=LEFT(L_ZIP,10),        
  PAN_GIR_NO,WARD_NO,SEBI_REGN_NO=ISNULL(SEBI_REGN_NO,''),RES_PHONE1=LEFT(RES_PHONE1,15),        
  RES_PHONE2=LEFT(RES_PHONE2,15),OFF_PHONE1=LEFT(OFF_PHONE1,15),OFF_PHONE2=LEFT(OFF_PHONE2,15),        
  MOBILE_PAGER=LEFT(MOBILE_PAGER,40),        
  FAX=LEFT(FAX,15),EMAIL=LEFT(EMAIL,100),        
  CL_STATUS,/*CL_TYPE=(CASE CL_TYPE WHEN 'CLI' THEN 'ROR' ELSE CL_TYPE END)*/  
  CL_TYPE=(CASE CL_TYPE WHEN 'ROR' THEN 'IND' ELSE CL_TYPE END),FAMILY,REGION,AREA,        
  P_ADDRESS1=LEFT(P_ADDRESS1,100),P_CITY=LEFT(P_CITY,20),        
  P_ADDRESS2=LEFT(P_ADDRESS2,100),P_STATE=CASE LEFT(P_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(P_STATE,50) END,        
  P_ADDRESS3=LEFT(P_ADDRESS3,100),P_NATION=LEFT(P_NATION,15),P_ZIP=LEFT(P_ZIP,10),        
  P_PHONE=LEFT(P_PHONE,15),ADDEMAILID=LEFT(ADDEMAILID,230),        
  SEX=ISNULL(SEX, 'M'),DOB=CONVERT(DATETIME,DOB,103),INTRODUCER=LEFT(INTRODUCER,30),APPROVER,INTERACTMODE,PASSPORT_NO,PASSPORT_ISSUED_AT,        
  PASSPORT_ISSUED_ON,PASSPORT_EXPIRES_ON,LICENCE_NO,LICENCE_ISSUED_AT,        
  LICENCE_ISSUED_ON,LICENCE_EXPIRES_ON,RAT_CARD_NO,RAT_CARD_ISSUED_AT,        
  RAT_CARD_ISSUED_ON,VOTERSID_NO,VOTERSID_ISSUED_AT,VOTERSID_ISSUED_ON,        
  IT_RETURN_YR,IT_RETURN_FILED_ON,REGR_NO,REGR_AT,REGR_ON,REGR_AUTHORITY,        
  CLIENT_AGREEMENT_ON,SETT_MODE,DEALING_WITH_OTHER_TM,OTHER_AC_NO,INTRODUCER_ID,        
  INTRODUCER_RELATION,REPATRIAT_BANK,REPATRIAT_BANK_AC_NO,CHK_KYC_FORM,        
  CHK_CORPORATE_DEED,CHK_BANK_CERTIFICATE,CHK_ANNUAL_REPORT,CHK_NETWORTH_CERT,        
  CHK_CORP_DTLS_RECD,BANK_NAME,BRANCH_NAME=LEFT(BRANCH_NAME,50),AC_TYPE=LEFT(AC_TYPE, 1),AC_NUM,DEPOSITORY1,DPID1,        
  CLTDPID1,POA1 = CASE WHEN POA1 = '0' THEN '' ELSE POA1 END,DEPOSITORY2,        
  DPID2 = CASE WHEN CONVERT(VARCHAR, DPID2) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID2) END,CLTDPID2,POA2,DEPOSITORY3,        
  DPID3 = CASE WHEN CONVERT(VARCHAR, DPID3) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID3) END,CLTDPID3,        
  POA3,REL_MGR,C_GROUP,SBU,[STATUS],IMP_STATUS,MODIFIDEDBY,MODIFIDEDON,BANK_ID,        
  MAPIN_ID,UCC_CODE = PARTY_CODE,MICR_NO,IFSC_CODE,DIRECTOR_NAME,        
  PAYLOCATION = '',FMCODE,PARENTCODE,PRODUCTCODE,        
  INCOME_SLAB,NETWORTH_SLAB,AUTOFUNDPAYOUT,SEBI_REG_DATE,SEBI_EXP_DATE,PERSON_TAG,        
  COMMODITY_TRADER,CHANNEL_TYPE,DMA_AGREEMENT_DATE,DMA_ACTIVATION_DATE,FO_TRADER,        
  CDS_TRADER,CDS_SUBBROKER,RES_PHONE1_STD=LEFT(RES_PHONE1_STD,10),RES_PHONE2_STD=LEFT(RES_PHONE2_STD,10),        
  OFF_PHONE1_STD=LEFT(OFF_PHONE1_STD,10),OFF_PHONE2_STD=LEFT(OFF_PHONE2_STD,10),P_PHONE_STD=LEFT(P_PHONE_STD,10),BANKID=0,        
  VALID_PARTY='N',VALID_REGION = 'N',VALID_AREA = 'N',VALID_TRADER = 'N',VALID_SUBBROKER = 'N',        
  VALID_BRANCH = 'N',VALID_BANK = CASE WHEN AC_NUM ='' THEN 'Y' ELSE 'N' END,        
  VALID_DPBANK1 = CASE WHEN ISNULL(CLTDPID1, '') ='' THEN 'Y' ELSE 'N' END,        
  VALID_DPBANK2 = CASE WHEN ISNULL(CLTDPID2, '') ='' THEN 'Y' ELSE 'N' END,        
  VALID_DPBANK3 = CASE WHEN ISNULL(CLTDPID3, '') ='' THEN 'Y' ELSE 'N' END,        
  RECVALID ='N', OCCUPATION     
 FROM         
  [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE        
 WHERE        
  CL_ACTIVATED_ON BETWEEN  @FDATE AND @TDATE + ' 23:59'          
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'        
  AND ISNULL(CL_type,'') <> '' 
  and  cl_code='D62319'     
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')  
  
    
    
 IF (SELECT COUNT(1) FROM #DATA) = 0 RETURN        
        
 CREATE TABLE #DATA_BROK         
 (        
  [SRNO] [INT] NOT NULL,        
  [CL_CODE] [VARCHAR](10) NOT NULL,        
  [EXCHANGE] [VARCHAR](3) NOT NULL,        
  [SEGMENT] [VARCHAR](7) NOT NULL,        
  [BROK_SCHEME] [TINYINT] NULL,        
  [TRD_BROK] [INT] NULL,        
  [DEL_BROK] [INT] NULL,        
  [SER_TAX] [TINYINT] NULL,        
  [SER_TAX_METHOD] [TINYINT] NULL,        
  [CREDIT_LIMIT] [INT] NOT NULL,        
  [INACTIVE_FROM] [DATETIME] NULL,        
  [PRINT_OPTIONS] [TINYINT] NULL,        
  [NO_OF_COPIES] [INT] NULL,        
  [PARTICIPANT_CODE] [VARCHAR](15) NULL,        
  [CUSTODIAN_CODE] [VARCHAR](50) NULL,        
  [INST_CONTRACT] [CHAR](1) NULL,        
  [ROUND_STYLE] [INT] NULL,        
  [STP_PROVIDER] [VARCHAR](5) NULL,        
  [STP_RP_STYLE] [TINYINT] NULL,        
  [MARKET_TYPE] [INT] NULL,        
  [MULTIPLIER] [INT] NULL,        
  [CHARGED] [INT] NULL,        
  [MAINTENANCE] [INT] NULL,        
  [REQD_BY_EXCH] [INT] NULL,        
  [REQD_BY_BROKER] [INT] NULL,        
  [CLIENT_RATING] [VARCHAR](10) NULL,        
  [DEBIT_BALANCE] [CHAR](1) NULL,        
  [INTER_SETT] [CHAR](1) NULL,        
  [TRD_STT] [MONEY] NULL,        
  [TRD_TRAN_CHRGS] [FLOAT] NULL,        
  [TRD_SEBI_FEES] [MONEY] NULL,        
  [TRD_STAMP_DUTY] [MONEY] NULL,        
  [TRD_OTHER_CHRGS] [MONEY] NULL,        
  [TRD_EFF_DT] [DATETIME] NULL,          [DEL_STT] [MONEY] NULL,        
  [DEL_TRAN_CHRGS] [FLOAT] NULL,        
  [DEL_SEBI_FEES] [MONEY] NULL,        
  [DEL_STAMP_DUTY] [MONEY] NULL,        
  [DEL_OTHER_CHRGS] [MONEY] NULL,        
  [DEL_EFF_DT] [DATETIME] NULL,        
  [ROUNDING_METHOD] [VARCHAR](10) NULL,        
  [ROUND_TO_DIGIT] [TINYINT] NULL,        
  [ROUND_TO_PAISE] [INT] NULL,        
  [FUT_BROK] [INT] NULL,        
  [FUT_OPT_BROK] [INT] NULL,        
  [FUT_FUT_FIN_BROK] [INT] NULL,        
  [FUT_OPT_EXC] [INT] NULL,        
  [FUT_BROK_APPLICABLE] [INT] NULL,        
  [FUT_STT] [SMALLINT] NULL,        
  [FUT_TRAN_CHRGS] [SMALLINT] NULL,        
  [FUT_SEBI_FEES] [SMALLINT] NULL,        
  [FUT_STAMP_DUTY] [SMALLINT] NULL,        
  [FUT_OTHER_CHRGS] [SMALLINT] NULL,        
  [STATUS] [CHAR](1) NULL,        
  [MODIFIEDON] [DATETIME] NULL,        
  [MODIFIEDBY] [VARCHAR](25) NULL,        
  [IMP_STATUS] [TINYINT] NULL,        
  [PAY_B3B_PAYMENT] [CHAR](1) NULL,        
  [PAY_BANK_NAME] [VARCHAR](50) NULL,        
  [PAY_BRANCH_NAME] [VARCHAR](50) NULL,        
  [PAY_AC_NO] [VARCHAR](20) NULL,        
  [PAY_PAYMENT_MODE] [CHAR](1) NULL,        
  [BROK_EFF_DATE] [DATETIME] NULL,        
  [INST_TRD_BROK] [INT] NULL,        
  [INST_DEL_BROK] [INT] NULL,        
  [SYSTEMDATE] [DATETIME] NULL,        
  [ACTIVE_DATE] [DATETIME] NULL,        
  [CHECKACTIVECLIENT] [VARCHAR](1) NULL,        
  [DEACTIVE_REMARKS] [VARCHAR](100) NULL,        
  [DEACTIVE_VALUE] [VARCHAR](1) NULL,        
  [VALUE_PACK] [VARCHAR](20) NULL,        
  [VALID_TRD_BROK] [VARCHAR](1),        
  [VALID_DEL_BROK] [VARCHAR](1),        
  [VALID_FUT_BROK] [VARCHAR](1),        
  [VALID_OPT_BROK] [VARCHAR](1),        
  [VALID_FUT_EXP_BROK] [VARCHAR](1),        
  [VALID_OPT_EXC_BROK] [VARCHAR](1),        
  [VALID_VALUEPACK_BROK] [VARCHAR](1),        
  [VALID_EXCHANGE] [VARCHAR](1),        
  [RECVALID] [VARCHAR](1)        
 )        
                             
 INSERT INTO #DATA_BROK        
 SELECT         
  REF_SRNO,CL_CODE,EXCHANGE,SEGMENT,        
  BROK_SCHEME = (CASE WHEN SEGMENT NOT IN ('CAPITAL', 'SLBS')        
  THEN BROK_SCHEME ELSE (CASE WHEN BROK_SCHEME = 1 THEN 2 ELSE BROK_SCHEME END)        
  END),        
  TRD_BROK,DEL_BROK,SER_TAX,SER_TAX_METHOD,CREDIT_LIMIT,INACTIVE_FROM,PRINT_OPTIONS,        
  NO_OF_COPIES,PARTICIPANT_CODE,CUSTODIAN_CODE,INST_CONTRACT,ROUND_STYLE,STP_PROVIDER,STP_RP_STYLE,MARKET_TYPE,MULTIPLIER,CHARGED,        
  MAINTENANCE,REQD_BY_EXCH,REQD_BY_BROKER,CLIENT_RATING,DEBIT_BALANCE,INTER_SETT,TRD_STT,TRD_TRAN_CHRGS,TRD_SEBI_FEES,TRD_STAMP_DUTY,        
  TRD_OTHER_CHRGS,TRD_EFF_DT,DEL_STT,DEL_TRAN_CHRGS,DEL_SEBI_FEES,DEL_STAMP_DUTY,DEL_OTHER_CHRGS,DEL_EFF_DT,ROUNDING_METHOD,        
  ROUND_TO_DIGIT,ROUND_TO_PAISE,FUT_BROK,FUT_OPT_BROK,FUT_FUT_FIN_BROK,FUT_OPT_EXC,FUT_BROK_APPLICABLE,FUT_STT,FUT_TRAN_CHRGS,        
  FUT_SEBI_FEES,FUT_STAMP_DUTY,FUT_OTHER_CHRGS,[STATUS],MODIFIEDON,MODIFIEDBY,IMP_STATUS,PAY_B3B_PAYMENT,PAY_BANK_NAME,PAY_BRANCH_NAME,        
  PAY_AC_NO,PAY_PAYMENT_MODE,BROK_EFF_DATE,INST_TRD_BROK,INST_DEL_BROK,SYSTEMDATE,ACTIVE_DATE,CHECKACTIVECLIENT,DEACTIVE_REMARKS,        
  DEACTIVE_VALUE,TRD_VALUE_PACK,        
  VALID_TRD_BROK = 'N',VALID_DEL_BROK = 'N',VALID_FUT_BROK = 'N',VALID_OPT_BROK = 'N',        
  VALID_FUT_EXP_BROK = 'N',VALID_OPT_EXC_BROK = 'N',VALID_VALUEPACK_BROK = 'N',VALID_EXCHANGE='N',RECVALID = 'N'         
 FROM         
  [172.31.16.57].crmdb_a.dbo.VIEW_CLASS_CLIENT_BROK_DETAILS_UPDATE        
 WHERE         
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'   
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'
  and  cl_code='D62319'         
  --AND EXCHANGE NOT IN ('NCX','MCX')        
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')  
      
 -- TO REMOVE (2 LINES ONLY FOR UAT SERVER)        
 -- DELETE #DATA WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)        
 -- DELETE #DATA_BROK WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA_BROK.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)        
       
 
 
  --- VALID_PARTY EQ  ------           
  UPDATE #DATA        
  SET VALID_PARTY= 'Y'        
  FROM #DATA AS A, mfss_client AS B        
  WHERE A.CL_CODE = B.PARTY_CODE        
        
  --- VALID_PARTY COMM  ------           
  /*sURESH UPDATE #DATA        
  SET VALID_PARTY= 'Y'        
  FROM #DATA AS A, CLIENT_DETAILS AS B        
  WHERE A.CL_CODE = B.CL_CODE --*/        
        
  --- VALID_PARTY DP  ------            
  /**    
  UPDATE #DATA        
  SET VALID_PARTY= 'Y'        
  FROM #DATA AS A, [172.31.16.94].DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B        
  WHERE A.CL_CODE = B.CM_BLSAVINGCD AND VALID_PARTY = 'N'            
        
  UPDATE #DATA        
  SET VALID_PARTY= 'Y'        
  FROM #DATA AS A, [172.31.16.94].DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B        
  WHERE A.PAN_GIR_NO = ltrim(rtrim(B.CB_PANNO)) AND VALID_PARTY = 'N'        
  **/    
      
  ---- VALIDATE REGION ----         
  UPDATE #DATA        
  SET VALID_REGION= 'Y'        
  FROM #DATA AS A, REGION AS B        
  WHERE A.REGION = B.REGIONCODE        
        
  ---- VALIDATE AREA ----        
  UPDATE #DATA         
  SET VALID_AREA = 'Y'         
  FROM #DATA AS A, AREA AS B         
  WHERE A.AREA = B.AREACODE        
        
  ---- VALIDATE TRADER ----        
  UPDATE #DATA        
  SET VALID_TRADER = 'Y'        
  FROM #DATA AS A, BRANCHES AS B        
  WHERE A.TRADER = B.SHORT_NAME        
  AND A.BRANCH_CD = B.BRANCH_CD        
        
  ---- VALIDATE SUBBROKER ----        
  UPDATE #DATA        
  SET VALID_SUBBROKER = 'Y'        
  FROM #DATA AS A, SUBBROKERS AS B        
  WHERE A.SUB_BROKER = B.SUB_BROKER        
                                         
  ---- VALIDATE BRANCH ----        
  UPDATE #DATA         
  SET VALID_BRANCH = 'Y'        
  FROM #DATA AS A, BRANCH AS B         
  WHERE A.BRANCH_CD = B.BRANCH_CODE         
        
  ---- VALIDATE BANK ----        
         
  UPDATE #DATA         
  SET VALID_BANK = 'Y' /* suresh ,BANKID=B.RBI_BANKID        
  FROM #DATA AS A, ACCOUNT.DBO.RBIBANKMASTER AS B         
  WHERE A.BANK_NAME = B.BANK_NAME         
  AND A.BRANCH_NAME = B.BRANCH_NAME         
  AND A.MICR_NO = B.MICR_CODE         
  AND A.IFSC_CODE = ISNULL(B.IFSC_CODE,'')        
  AND AC_NUM <> ''-*/        
        
  ---- VALIDATE DPBANK ----        
  UPDATE #DATA         
  SET VALID_DPBANK1 = 'Y'         
  FROM #DATA AS A, BANK AS B         
  WHERE A.DPID1 = B.BANKID         
  AND CLTDPID1<> ''                                         
        
  ---- VALIDATE DPBANK ----        
  UPDATE #DATA         
  SET VALID_DPBANK2 = 'Y'         
  FROM #DATA AS A, BANK AS B         
  WHERE A.DPID2 = B.BANKID         
  AND CLTDPID2<> ''                                
                                
  ---- VALIDATE DPBANK ----        
  UPDATE #DATA         
  SET VALID_DPBANK3 = 'Y'         
  FROM #DATA AS A, BANK AS B         
  WHERE A.DPID3 = B.BANKID         
  AND CLTDPID3<> ''        
        
  -- UPDATING VALID RECORD -----        
  UPDATE #DATA     SET RECVALID='Y'          
  WHERE        
  VALID_PARTY='Y'        
  AND VALID_REGION = 'Y'          
  AND VALID_AREA = 'Y'          
  AND VALID_TRADER = 'Y'          
  AND VALID_SUBBROKER = 'Y'          
  AND VALID_BRANCH = 'Y'          
  AND VALID_BANK = 'Y'          
  AND VALID_DPBANK1 = 'Y'         
  AND VALID_DPBANK2 = 'Y'         
  AND VALID_DPBANK3 = 'Y'   
  
    
  
      
 UPDATE C SET        
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,        
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,           
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,      
 BRANCH_CD= CASE WHEN ISNULL(A.BRANCH_CD, '') <> '' THEN ISNULL(A.BRANCH_CD, '') ELSE C.BRANCH_CD END ,           
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,         
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,          
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,            
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,            
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,           
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,        
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,         
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,            
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,         
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,            
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,           
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,          
 ZIP= CASE WHEN ISNULL(A.L_ZIP, '') <> '' THEN ISNULL(A.L_ZIP, '') ELSE C.ZIP END,            
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,           
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,           
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,         
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,          
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,           
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,        
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,        
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,        
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,         
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,        
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,            
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,           
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,        
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,        
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,        
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,        
 ADDEDBY='CITRUS' ,        
 ADDEDON=GETDATE() ,        
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,       
 --INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,         
 MODE_HOLDING=CHANNEL_TYPE,        
 OCCUPATION_CODE=OCCUPATION,        
 TAX_STATUS=FMCODE        
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,            
 --HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,            
 --HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,            
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END       
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,  
  BSEMFSS.DBO.MFSS_CLIENT C        
 WHERE A.RECVALID = 'Y'         
 AND A.CL_CODE=C.PARTY_CODE    
  
UPDATE NSEMFSS.DBO.MFSS_CLIENT SET        
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,        
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,           
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,      
 BRANCH_CD= CASE WHEN ISNULL(A.BRANCH_CD, '') <> '' THEN ISNULL(A.BRANCH_CD, '') ELSE C.BRANCH_CD END ,           
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,         
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,          
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,            
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,            
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,           
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,        
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,         
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,            
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,         
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,            
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,           
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,          
 ZIP= CASE WHEN ISNULL(A.L_ZIP, '') <> '' THEN ISNULL(A.L_ZIP, '') ELSE C.ZIP END,            
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,           
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,           
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,         
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,          
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,           
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,        
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,        
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,        
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,         
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,        
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,            
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,           
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,        
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,        
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,        
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,        
 ADDEDBY='CITRUS' ,        
 ADDEDON=GETDATE() ,        
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,       
-- INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,         
 MODE_HOLDING=CHANNEL_TYPE,        
 OCCUPATION_CODE=OCCUPATION        
-- TAX_STATUS=FMCODE,        
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,            
-- HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,            
-- HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,            
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END       
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,  
  NSEMFSS.DBO.MFSS_CLIENT C        
 WHERE A.RECVALID = 'Y'         
 AND A.CL_CODE=C.PARTY_CODE    
  
     
        
 /*UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET        
 BROK_EFF_DATE=B.BROK_EFF_DATE,        
 ADDEDBY='CITRUS' ,        
 ADDEDON=GETDATE() ,        
 ACTIVE_FROM=GETDATE() ,        
 INACTIVE_FROM='DEC 31 2049 23:59'         
 FROM #DATA_BROK B,ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C                        
 WHERE B.RECVALID = 'Y'         
 AND B.CL_CODE=C.PARTY_CODE        
 AND B.EXCHANGE='BSE'        
 AND B.SEGMENT='CAPITAL'     */      
                 
 ----------------------------------------------------------------------------------------------------------------                                      
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET        
 PARTY_NAME=A.LONG_NAME,        
 CL_TYPE=A.CL_TYPE ,         
 CL_STATUS=A.CL_STATUS ,        
 BRANCH_CD=A.BRANCH_CD ,        
 SUB_BROKER=A.SUB_BROKER,        
 TRADER=A.TRADER ,        
 AREA=A.AREA ,        
 REGION=A.REGION ,         
 FAMILY=A.FAMILY,        
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,        
 PAN_NO=A.PAN_GIR_NO ,        
 ADDR1=A.L_ADDRESS1 ,        
 ADDR2=A.L_ADDRESS2 ,        
 ADDR3=ISNULL(A.L_ADDRESS3, ''),        
 CITY=A.L_CITY ,        
 STATE=A.L_STATE ,        
 ZIP=A.L_ZIP ,        
 NATION=A.L_NATION ,        
 OFFICE_PHONE=A.P_PHONE ,        
 RES_PHONE=A.RES_PHONE1 ,        
 MOBILE_NO=A.MOBILE_PAGER ,        
 EMAIL_ID=A.EMAIL ,        
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,        
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,        
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,        
 ACC_NO=A.AC_NUM ,        
 MICR_NO=A.MICR_NO ,        
 NEFTCODE=A.IFSC_CODE,        
 DOB=A.DOB ,        
 BANK_AC_TYPE=CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END ,        
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,        
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,        
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,        
 ADDEDBY='CITRUS' ,        
 ADDEDON=GETDATE() ,        
 ACTIVE_FROM=GETDATE() ,        
 INACTIVE_FROM='DEC 31 2049 23:59',        
 MODE_HOLDING=CHANNEL_TYPE,        
 OCCUPATION_CODE=OCCUPATION,        
 TAX_STATUS=FMCODE,        
 HOLDER2_NAME=ISNULL(APP_NAME_2, ''),        
 HOLDER2_PAN_NO=ISNULL(APP_PAN_NO_2, ''),        
 HOLDER3_NAME=ISNULL(APP_NAME_3, ''),        
 HOLDER3_PAN_NO=ISNULL(APP_PAN_NO_3, '')        
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE, ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C        
 WHERE A.RECVALID = 'Y'         
 AND A.CL_CODE=C.PARTY_CODE         
        
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET        
 BROK_EFF_DATE=B.BROK_EFF_DATE,        
 ADDEDBY='CITRUS' ,        
 ADDEDON=GETDATE() ,        
 ACTIVE_FROM=GETDATE() ,        
 INACTIVE_FROM='DEC 31 2049 23:59'         
 FROM #DATA_BROK B,ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C            
 WHERE B.RECVALID = 'Y'         
 AND B.CL_CODE=C.PARTY_CODE        
 AND B.EXCHANGE='NSE'        
 AND B.SEGMENT='CAPITAL'  */  
  
 UPDATE A  
SET  
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.ACNAME END,  
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.LONGNAME END  
--BRANCHCODE= CASE WHEN #DATA.BRANCH_CD <> '' THEN #DATA.BRANCH_CD ELSE A.BRANCHCODE END  
FROM #DATA ,BBO_FA.DBO.ACMAST A WHERE RECVALID='Y'   
AND #DATA.CL_CODE=A.CLTCODE       
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE   
AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')    
   
   
  
/*UPDATE ANGELFO.BBO_FA.DBO.ACMAST   
SET  
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.ACNAME END,  
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.LONGNAME END,  
BRANCHCODE=#DATA.BRANCH_CD  
FROM #DATA WHERE RECVALID='Y'        
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')          */  
        
 /*DELETE ANGELFO.BBO_FA.DBO.ACMAST        
 FROM ANGELFO.BBO_FA.DBO.ACMAST AS A,#DATA AS B ,#DATA_BROK C        
 WHERE B.RECVALID = 'Y'        
 AND A.CLTCODE = B.PARTY_CODE        
 AND B.CL_CODE=C.CL_CODE         
 AND C.EXCHANGE IN ('NSE','BSE') AND C.SEGMENT='CAPITAL'        
          
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                  
 SELECT DISTINCT LONG_NAME  , LONG_NAME , 'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'NSE' ,'MFSS'             
 FROM #DATA WHERE RECVALID='Y'        
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')         
        
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                  
 SELECT DISTINCT LONG_NAME ,LONG_NAME ,'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'BSE' ,'MFSS'             
 FROM #DATA WHERE RECVALID='Y'        
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')         
*/     
  
 UPDATE A      
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,  
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,  
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,        
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,  
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,  
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END       
 FROM NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B        
 WHERE A.PARTY_CODE = B.PARTY_CODE         
 AND A.DPID = B.DPID1        
 AND A.CLTDPID = B.CLTDPID1        
 AND B.RECVALID = 'Y'     
   
  UPDATE A       
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,  
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,  
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,        
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,  
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,  
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END       
 FROM BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B        
 WHERE A.PARTY_CODE = B.PARTY_CODE         
 AND A.DPID = B.DPID1        
 AND A.CLTDPID = B.CLTDPID1        
 AND B.RECVALID = 'Y'     
   
 /*               
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER        
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,        
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE        
 FROM ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B        
 WHERE A.PARTY_CODE = B.PARTY_CODE         
 AND A.DPID = B.DPID1        
 AND A.CLTDPID = B.CLTDPID1        
 AND B.RECVALID = 'Y'        
           
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER        
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,        
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE        
 FROM ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B        
 WHERE A.PARTY_CODE = B.PARTY_CODE         
 AND A.DPID = B.DPID1        
 AND A.CLTDPID = B.CLTDPID1        
 AND B.RECVALID = 'Y'   */  
          
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER        
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')        
 FROM ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C        
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='NSE'AND C.SEGMENT='CAPITAL'        
 AND GETDATE() BETWEEN FROMDATE AND TODATE        
        
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER        
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')        
 FROM ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C        
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='BSE'AND C.SEGMENT='CAPITAL'        
 AND GETDATE() BETWEEN FROMDATE AND TODATE        
        
 /*INSERT INTO ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER                  
 SELECT DISTINCT        
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'         
 FROM #DATA A,#DATA_BROK B         
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='NSE'  AND B.SEGMENT='CAPITAL'         
 AND EXISTS(SELECT PARTY_CODE FROM ANGELFO.NSEMFSS.DBO.MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE) */        
                   
 INSERT INTO ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER                  
 SELECT DISTINCT         
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'          
 FROM #DATA A,#DATA_BROK B         
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='BSE'  AND B.SEGMENT='CAPITAL'         
 AND EXISTS(SELECT PARTY_CODE FROM BSEMFSS..MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE)       
  
 DELETE ANGELFO.BBO_FA.DBO.MULTIBANKID        
 FROM ANGELFO.BBO_FA.DBO.MULTIBANKID AS A,#DATA AS B        
 WHERE B.RECVALID = 'Y'        
 AND B.CL_CODE=A.CLTCODE AND SEGMENT='MFSS'          
                   
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID       
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)       
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','NSE','MFSS'        
 FROM #DATA A        
 WHERE A.RECVALID = 'Y'        
        
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID       
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)       
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','BSE','MFSS'        
 FROM #DATA A        
 WHERE A.RECVALID = 'Y'     */     
      
 ------------------------------------------------------------------------------------------                     
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_20092017
-- --------------------------------------------------



  ---EXEC [MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE ]  'JUN 25 2016','JUN 26 2016'
  

CREATE PROC [dbo].[MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_20092017]      
(      
 @FDATE VARCHAR(11)='',      
 @TDATE VARCHAR(11)=''      
)      
      
AS      
BEGIN      
  
 IF @FDATE ='' AND @TDATE =''       
 BEGIN      
  SELECT @FDATE = LEFT(MIN(CL_ACTIVATED_ON),11),@TDATE = LEFT(MAX(CL_ACTIVATED_ON),11)      
  FROM [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE      
  WHERE DATA_MIGRATE_STAT = 0      
 END  
 
 CREATE TABLE #DATA      
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [BRANCH_CD] [VARCHAR](10) NULL,      
  [PARTY_CODE] [VARCHAR](10) NOT NULL,      
  [SUB_BROKER] [VARCHAR](10) NOT NULL,      
  [TRADER] [VARCHAR](20) NULL,      
  [LONG_NAME] [VARCHAR](100) NULL,      
  [SHORT_NAME] [VARCHAR](30) NULL,      
  [L_ADDRESS1] [VARCHAR](100) NULL,      
  [L_CITY] [VARCHAR](40) NULL,      
  [L_ADDRESS2] [VARCHAR](100) NULL,      
  [L_STATE] [VARCHAR](50) NULL,      
  [L_ADDRESS3] [VARCHAR](100) NULL,      
  [L_NATION] [VARCHAR](15) NULL,      
  [L_ZIP] [VARCHAR](10) NULL,      
  [PAN_GIR_NO] [VARCHAR](50) NULL,      
  [WARD_NO] [VARCHAR](50) NULL,      
  [SEBI_REGN_NO] [VARCHAR](25) NULL,      
  [RES_PHONE1] [VARCHAR](15) NULL,      
  [RES_PHONE2] [VARCHAR](15) NULL,      
  [OFF_PHONE1] [VARCHAR](15) NULL,      
  [OFF_PHONE2] [VARCHAR](15) NULL,      
  [MOBILE_PAGER] [VARCHAR](40) NULL,      
  [FAX] [VARCHAR](15) NULL,      
  [EMAIL] [VARCHAR](100) NULL,      
  [CL_TYPE] [VARCHAR](3) NOT NULL,      
  [CL_STATUS] [VARCHAR](3) NOT NULL,      
  [FAMILY] [VARCHAR](10) NOT NULL,      
  [REGION] [VARCHAR](20) NULL,      
  [AREA] [VARCHAR](20) NULL,      
  [P_ADDRESS1] [VARCHAR](100) NULL,      
  [P_CITY] [VARCHAR](40) NULL,      
  [P_ADDRESS2] [VARCHAR](100) NULL,      
  [P_STATE] [VARCHAR](50) NULL,      
  [P_ADDRESS3] [VARCHAR](100) NULL,      
  [P_NATION] [VARCHAR](15) NULL,      
  [P_ZIP] [VARCHAR](10) NULL,      
  [P_PHONE] [VARCHAR](15) NULL,      
  [ADDEMAILID] [VARCHAR](230) NULL,      
  [SEX] [CHAR](1) NULL,      
  [DOB] [DATETIME] NULL,      
  [INTRODUCER] [VARCHAR](30) NULL,      
  [APPROVER] [VARCHAR](30) NULL,      
  [INTERACTMODE] [TINYINT] NULL,      
  [PASSPORT_NO] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_AT] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_ON] [DATETIME] NULL,      
  [PASSPORT_EXPIRES_ON] [DATETIME] NULL,      
  [LICENCE_NO] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_AT] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_ON] [DATETIME] NULL,      
  [LICENCE_EXPIRES_ON] [DATETIME] NULL,      
  [RAT_CARD_NO] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_AT] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_ON] [DATETIME] NULL,      
  [VOTERSID_NO] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_AT] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_ON] [DATETIME] NULL,      
  [IT_RETURN_YR] [VARCHAR](30) NULL,      
  [IT_RETURN_FILED_ON] [DATETIME] NULL,      
  [REGR_NO] [VARCHAR](50) NULL,      
  [REGR_AT] [VARCHAR](50) NULL,      
  [REGR_ON] [DATETIME] NULL,      
  [REGR_AUTHORITY] [VARCHAR](50) NULL,      
  [CLIENT_AGREEMENT_ON] [DATETIME] NULL,      
  [SETT_MODE] [VARCHAR](50) NULL,      
  [DEALING_WITH_OTHER_TM] [VARCHAR](50) NULL,      
  [OTHER_AC_NO] [VARCHAR](50) NULL,      
  [INTRODUCER_ID] [VARCHAR](50) NULL,      
  [INTRODUCER_RELATION] [VARCHAR](50) NULL,      
  [REPATRIAT_BANK] [NUMERIC](18, 0) NULL,      
  [REPATRIAT_BANK_AC_NO] [VARCHAR](30) NULL,      
  [CHK_KYC_FORM] [TINYINT] NULL,      
  [CHK_CORPORATE_DEED] [TINYINT] NULL,      
  [CHK_BANK_CERTIFICATE] [TINYINT] NULL,      
  [CHK_ANNUAL_REPORT] [TINYINT] NULL,      
  [CHK_NETWORTH_CERT] [TINYINT] NULL,      
  [CHK_CORP_DTLS_RECD] [TINYINT] NULL,      
  [BANK_NAME] [VARCHAR](100) NULL,      
  [BRANCH_NAME] [VARCHAR](50) NULL,      
  [AC_TYPE] [VARCHAR](10) NULL,      
  [AC_NUM] [VARCHAR](20) NULL,      
  [DEPOSITORY1] [VARCHAR](7) NULL,      
  [DPID1] [VARCHAR](16) NULL,      
  [CLTDPID1] [VARCHAR](16) NULL,      
  [POA1] [CHAR](1) NULL,      
  [DEPOSITORY2] [VARCHAR](7) NULL,      
  [DPID2] [VARCHAR](16) NULL,      
  [CLTDPID2] [VARCHAR](16) NULL,      
  [POA2] [CHAR](1) NULL,      
  [DEPOSITORY3] [VARCHAR](7) NULL,      
  [DPID3] [VARCHAR](16) NULL,      
  [CLTDPID3] [VARCHAR](16) NULL,      
  [POA3] [CHAR](1) NULL,      
  [REL_MGR] [VARCHAR](10) NULL,      
  [C_GROUP] [VARCHAR](10) NULL,     
  [SBU] [VARCHAR](10) NULL,      
  [STATUS] [CHAR](1) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [MODIFIDEDBY] [VARCHAR](25) NULL,      
  [MODIFIDEDON] [DATETIME] NULL,      
  [BANK_ID] [VARCHAR](20) NULL,      
  [MAPIN_ID] [VARCHAR](12) NULL,      
  [UCC_CODE] [VARCHAR](12) NULL,      
  [MICR_NO] [VARCHAR](10) NULL,      
  [IFSC_CODE] [VARCHAR](20) NULL,      
  [DIRECTOR_NAME] [VARCHAR](500) NULL,      
  [PAYLOCATION] [VARCHAR](20) NULL,      
  [FMCODE] [VARCHAR](10) NULL,      
  [PARENTCODE] [VARCHAR](10) NULL,      
  [PRODUCTCODE] [VARCHAR](2) NULL,      
  [INCOME_SLAB] [VARCHAR](50) NULL,      
  [NETWORTH_SLAB] [VARCHAR](50) NULL,      
  [AUTOFUNDPAYOUT] [INT] NULL,      
  [SEBI_REG_DATE] [DATETIME] NULL,      
  [SEBI_EXP_DATE] [DATETIME] NULL,      
  [PERSON_TAG] [INT] NULL,      
  [COMMODITY_TRADER] [VARCHAR](20) NULL,      
  [CHANNEL_TYPE] [VARCHAR](20) NULL,      
  [DMA_AGREEMENT_DATE] [DATETIME] NULL,      
  [DMA_ACTIVATION_DATE] [DATETIME] NULL,      
  [FO_TRADER] [VARCHAR](20) NULL,      
  [CDS_TRADER] [VARCHAR](20) NULL,      
  [CDS_SUBBROKER] [VARCHAR](10) NULL,      
  [RES_PHONE1_STD] [VARCHAR](10) NULL,      
  [RES_PHONE2_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE1_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE2_STD] [VARCHAR](10) NULL,      
  [P_PHONE_STD] [VARCHAR](10) NULL,      
  [BANKID] [INT] NULL,      
  [VALID_PARTY] [VARCHAR](1),      
  [VALID_REGION] [VARCHAR](1),      
  [VALID_AREA] [VARCHAR](1),      
  [VALID_TRADER] [VARCHAR](1),      
  [VALID_SUBBROKER] [VARCHAR](1),      
  [VALID_BRANCH] [VARCHAR](1),      
  [VALID_BANK] [VARCHAR](1),      
  [VALID_DPBANK1] [VARCHAR](1),      
  [VALID_DPBANK2] [VARCHAR](1),      
  [VALID_DPBANK3] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1),      
  [OCCUPATION] INT      
 )      
                                  

INSERT INTO #DATA                                      
 SELECT DISTINCT      
  REF_SRNO,CL_CODE,BRANCH_CD,PARTY_CODE,SUB_BROKER,TRADER,      
  LONG_NAME=LEFT(LONG_NAME,100),SHORT_NAME=LEFT(REPLACE(SHORT_NAME, ' NULL ', ''),30),L_ADDRESS1=LEFT(L_ADDRESS1,40),      
  L_CITY=LEFT(L_CITY,40),L_ADDRESS2=LEFT(L_ADDRESS2,40),      
  L_STATE=CASE LEFT(L_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(L_STATE,50) END,      
  L_ADDRESS3=LEFT(L_ADDRESS3,40),L_NATION=LEFT(L_NATION,15),L_ZIP=LEFT(L_ZIP,10),      
  PAN_GIR_NO,WARD_NO,SEBI_REGN_NO=ISNULL(SEBI_REGN_NO,''),RES_PHONE1=LEFT(RES_PHONE1,15),      
  RES_PHONE2=LEFT(RES_PHONE2,15),OFF_PHONE1=LEFT(OFF_PHONE1,15),OFF_PHONE2=LEFT(OFF_PHONE2,15),      
  MOBILE_PAGER=LEFT(MOBILE_PAGER,40),      
  FAX=LEFT(FAX,15),EMAIL=LEFT(EMAIL,100),      
  CL_STATUS,/*CL_TYPE=(CASE CL_TYPE WHEN 'CLI' THEN 'ROR' ELSE CL_TYPE END)*/
  CL_TYPE=(CASE CL_TYPE WHEN 'ROR' THEN 'IND' ELSE CL_TYPE END),FAMILY,REGION,AREA,      
  P_ADDRESS1=LEFT(P_ADDRESS1,100),P_CITY=LEFT(P_CITY,20),      
  P_ADDRESS2=LEFT(P_ADDRESS2,100),P_STATE=CASE LEFT(P_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(P_STATE,50) END,      
  P_ADDRESS3=LEFT(P_ADDRESS3,100),P_NATION=LEFT(P_NATION,15),P_ZIP=LEFT(P_ZIP,10),      
  P_PHONE=LEFT(P_PHONE,15),ADDEMAILID=LEFT(ADDEMAILID,230),      
  SEX=ISNULL(SEX, 'M'),DOB=CONVERT(DATETIME,DOB,103),INTRODUCER=LEFT(INTRODUCER,30),APPROVER,INTERACTMODE,PASSPORT_NO,PASSPORT_ISSUED_AT,      
  PASSPORT_ISSUED_ON,PASSPORT_EXPIRES_ON,LICENCE_NO,LICENCE_ISSUED_AT,      
  LICENCE_ISSUED_ON,LICENCE_EXPIRES_ON,RAT_CARD_NO,RAT_CARD_ISSUED_AT,      
  RAT_CARD_ISSUED_ON,VOTERSID_NO,VOTERSID_ISSUED_AT,VOTERSID_ISSUED_ON,      
  IT_RETURN_YR,IT_RETURN_FILED_ON,REGR_NO,REGR_AT,REGR_ON,REGR_AUTHORITY,      
  CLIENT_AGREEMENT_ON,SETT_MODE,DEALING_WITH_OTHER_TM,OTHER_AC_NO,INTRODUCER_ID,      
  INTRODUCER_RELATION,REPATRIAT_BANK,REPATRIAT_BANK_AC_NO,CHK_KYC_FORM,      
  CHK_CORPORATE_DEED,CHK_BANK_CERTIFICATE,CHK_ANNUAL_REPORT,CHK_NETWORTH_CERT,      
  CHK_CORP_DTLS_RECD,BANK_NAME,BRANCH_NAME=LEFT(BRANCH_NAME,50),AC_TYPE=LEFT(AC_TYPE, 1),AC_NUM,DEPOSITORY1,DPID1,      
  CLTDPID1,POA1 = CASE WHEN POA1 = '0' THEN '' ELSE POA1 END,DEPOSITORY2,      
  DPID2 = CASE WHEN CONVERT(VARCHAR, DPID2) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID2) END,CLTDPID2,POA2,DEPOSITORY3,      
  DPID3 = CASE WHEN CONVERT(VARCHAR, DPID3) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID3) END,CLTDPID3,      
  POA3,REL_MGR,C_GROUP,SBU,[STATUS],IMP_STATUS,MODIFIDEDBY,MODIFIDEDON,BANK_ID,      
  MAPIN_ID,UCC_CODE = PARTY_CODE,MICR_NO,IFSC_CODE,DIRECTOR_NAME,      
  PAYLOCATION = '',FMCODE,PARENTCODE,PRODUCTCODE,      
  INCOME_SLAB,NETWORTH_SLAB,AUTOFUNDPAYOUT,SEBI_REG_DATE,SEBI_EXP_DATE,PERSON_TAG,      
  COMMODITY_TRADER,CHANNEL_TYPE,DMA_AGREEMENT_DATE,DMA_ACTIVATION_DATE,FO_TRADER,      
  CDS_TRADER,CDS_SUBBROKER,RES_PHONE1_STD=LEFT(RES_PHONE1_STD,10),RES_PHONE2_STD=LEFT(RES_PHONE2_STD,10),      
  OFF_PHONE1_STD=LEFT(OFF_PHONE1_STD,10),OFF_PHONE2_STD=LEFT(OFF_PHONE2_STD,10),P_PHONE_STD=LEFT(P_PHONE_STD,10),BANKID=0,      
  VALID_PARTY='N',VALID_REGION = 'N',VALID_AREA = 'N',VALID_TRADER = 'N',VALID_SUBBROKER = 'N',      
  VALID_BRANCH = 'N',VALID_BANK = CASE WHEN AC_NUM ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK1 = CASE WHEN ISNULL(CLTDPID1, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK2 = CASE WHEN ISNULL(CLTDPID2, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK3 = CASE WHEN ISNULL(CLTDPID3, '') ='' THEN 'Y' ELSE 'N' END,      
  RECVALID ='N', OCCUPATION   
 FROM       
  [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE      
 WHERE      
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'       
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'      
  AND ISNULL(CL_type,'') <> ''   
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')

  
  
 IF (SELECT COUNT(1) FROM #DATA) = 0 RETURN      
      
 CREATE TABLE #DATA_BROK       
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [EXCHANGE] [VARCHAR](3) NOT NULL,      
  [SEGMENT] [VARCHAR](7) NOT NULL,      
  [BROK_SCHEME] [TINYINT] NULL,      
  [TRD_BROK] [INT] NULL,      
  [DEL_BROK] [INT] NULL,      
  [SER_TAX] [TINYINT] NULL,      
  [SER_TAX_METHOD] [TINYINT] NULL,      
  [CREDIT_LIMIT] [INT] NOT NULL,      
  [INACTIVE_FROM] [DATETIME] NULL,      
  [PRINT_OPTIONS] [TINYINT] NULL,      
  [NO_OF_COPIES] [INT] NULL,      
  [PARTICIPANT_CODE] [VARCHAR](15) NULL,      
  [CUSTODIAN_CODE] [VARCHAR](50) NULL,      
  [INST_CONTRACT] [CHAR](1) NULL,      
  [ROUND_STYLE] [INT] NULL,      
  [STP_PROVIDER] [VARCHAR](5) NULL,      
  [STP_RP_STYLE] [TINYINT] NULL,      
  [MARKET_TYPE] [INT] NULL,      
  [MULTIPLIER] [INT] NULL,      
  [CHARGED] [INT] NULL,      
  [MAINTENANCE] [INT] NULL,      
  [REQD_BY_EXCH] [INT] NULL,      
  [REQD_BY_BROKER] [INT] NULL,      
  [CLIENT_RATING] [VARCHAR](10) NULL,      
  [DEBIT_BALANCE] [CHAR](1) NULL,      
  [INTER_SETT] [CHAR](1) NULL,      
  [TRD_STT] [MONEY] NULL,      
  [TRD_TRAN_CHRGS] [FLOAT] NULL,      
  [TRD_SEBI_FEES] [MONEY] NULL,      
  [TRD_STAMP_DUTY] [MONEY] NULL,      
  [TRD_OTHER_CHRGS] [MONEY] NULL,      
  [TRD_EFF_DT] [DATETIME] NULL,      
  [DEL_STT] [MONEY] NULL,      
  [DEL_TRAN_CHRGS] [FLOAT] NULL,      
  [DEL_SEBI_FEES] [MONEY] NULL,      
  [DEL_STAMP_DUTY] [MONEY] NULL,      
  [DEL_OTHER_CHRGS] [MONEY] NULL,      
  [DEL_EFF_DT] [DATETIME] NULL,      
  [ROUNDING_METHOD] [VARCHAR](10) NULL,      
  [ROUND_TO_DIGIT] [TINYINT] NULL,      
  [ROUND_TO_PAISE] [INT] NULL,      
  [FUT_BROK] [INT] NULL,      
  [FUT_OPT_BROK] [INT] NULL,      
  [FUT_FUT_FIN_BROK] [INT] NULL,      
  [FUT_OPT_EXC] [INT] NULL,      
  [FUT_BROK_APPLICABLE] [INT] NULL,      
  [FUT_STT] [SMALLINT] NULL,      
  [FUT_TRAN_CHRGS] [SMALLINT] NULL,      
  [FUT_SEBI_FEES] [SMALLINT] NULL,      
  [FUT_STAMP_DUTY] [SMALLINT] NULL,      
  [FUT_OTHER_CHRGS] [SMALLINT] NULL,      
  [STATUS] [CHAR](1) NULL,      
  [MODIFIEDON] [DATETIME] NULL,      
  [MODIFIEDBY] [VARCHAR](25) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [PAY_B3B_PAYMENT] [CHAR](1) NULL,      
  [PAY_BANK_NAME] [VARCHAR](50) NULL,      
  [PAY_BRANCH_NAME] [VARCHAR](50) NULL,      
  [PAY_AC_NO] [VARCHAR](20) NULL,      
  [PAY_PAYMENT_MODE] [CHAR](1) NULL,      
  [BROK_EFF_DATE] [DATETIME] NULL,      
  [INST_TRD_BROK] [INT] NULL,      
  [INST_DEL_BROK] [INT] NULL,      
  [SYSTEMDATE] [DATETIME] NULL,      
  [ACTIVE_DATE] [DATETIME] NULL,      
  [CHECKACTIVECLIENT] [VARCHAR](1) NULL,      
  [DEACTIVE_REMARKS] [VARCHAR](100) NULL,      
  [DEACTIVE_VALUE] [VARCHAR](1) NULL,      
  [VALUE_PACK] [VARCHAR](20) NULL,      
  [VALID_TRD_BROK] [VARCHAR](1),      
  [VALID_DEL_BROK] [VARCHAR](1),      
  [VALID_FUT_BROK] [VARCHAR](1),      
  [VALID_OPT_BROK] [VARCHAR](1),      
  [VALID_FUT_EXP_BROK] [VARCHAR](1),      
  [VALID_OPT_EXC_BROK] [VARCHAR](1),      
  [VALID_VALUEPACK_BROK] [VARCHAR](1),      
  [VALID_EXCHANGE] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1)      
 )      
                           
 INSERT INTO #DATA_BROK      
 SELECT       
  REF_SRNO,CL_CODE,EXCHANGE,SEGMENT,      
  BROK_SCHEME = (CASE WHEN SEGMENT NOT IN ('CAPITAL', 'SLBS')      
  THEN BROK_SCHEME ELSE (CASE WHEN BROK_SCHEME = 1 THEN 2 ELSE BROK_SCHEME END)      
  END),      
  TRD_BROK,DEL_BROK,SER_TAX,SER_TAX_METHOD,CREDIT_LIMIT,INACTIVE_FROM,PRINT_OPTIONS,      
  NO_OF_COPIES,PARTICIPANT_CODE,CUSTODIAN_CODE,INST_CONTRACT,ROUND_STYLE,STP_PROVIDER,STP_RP_STYLE,MARKET_TYPE,MULTIPLIER,CHARGED,      
  MAINTENANCE,REQD_BY_EXCH,REQD_BY_BROKER,CLIENT_RATING,DEBIT_BALANCE,INTER_SETT,TRD_STT,TRD_TRAN_CHRGS,TRD_SEBI_FEES,TRD_STAMP_DUTY,      
  TRD_OTHER_CHRGS,TRD_EFF_DT,DEL_STT,DEL_TRAN_CHRGS,DEL_SEBI_FEES,DEL_STAMP_DUTY,DEL_OTHER_CHRGS,DEL_EFF_DT,ROUNDING_METHOD,      
  ROUND_TO_DIGIT,ROUND_TO_PAISE,FUT_BROK,FUT_OPT_BROK,FUT_FUT_FIN_BROK,FUT_OPT_EXC,FUT_BROK_APPLICABLE,FUT_STT,FUT_TRAN_CHRGS,      
  FUT_SEBI_FEES,FUT_STAMP_DUTY,FUT_OTHER_CHRGS,[STATUS],MODIFIEDON,MODIFIEDBY,IMP_STATUS,PAY_B3B_PAYMENT,PAY_BANK_NAME,PAY_BRANCH_NAME,      
  PAY_AC_NO,PAY_PAYMENT_MODE,BROK_EFF_DATE,INST_TRD_BROK,INST_DEL_BROK,SYSTEMDATE,ACTIVE_DATE,CHECKACTIVECLIENT,DEACTIVE_REMARKS,      
  DEACTIVE_VALUE,TRD_VALUE_PACK,      
  VALID_TRD_BROK = 'N',VALID_DEL_BROK = 'N',VALID_FUT_BROK = 'N',VALID_OPT_BROK = 'N',      
  VALID_FUT_EXP_BROK = 'N',VALID_OPT_EXC_BROK = 'N',VALID_VALUEPACK_BROK = 'N',VALID_EXCHANGE='N',RECVALID = 'N'       
 FROM       
  [172.31.16.57].crmdb_a.dbo.VIEW_CLASS_CLIENT_BROK_DETAILS_UPDATE      
 WHERE       
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'       
  AND DATA_MIGRATE_STAT = 0 AND [STATUS]='U'      
  --AND EXCHANGE NOT IN ('NCX','MCX')      
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')
    
 -- TO REMOVE (2 LINES ONLY FOR UAT SERVER)      
 -- DELETE #DATA WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
 -- DELETE #DATA_BROK WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA_BROK.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
     
      
  --- VALID_PARTY EQ  ------         
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, mfss_client AS B      
  WHERE A.CL_CODE = B.PARTY_CODE      
      
  --- VALID_PARTY COMM  ------         
  /*sURESH UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, CLIENT_DETAILS AS B      
  WHERE A.CL_CODE = B.CL_CODE --*/      
      
  --- VALID_PARTY DP  ------          
  /**  
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, [172.31.16.94].DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B      
  WHERE A.CL_CODE = B.CM_BLSAVINGCD AND VALID_PARTY = 'N'          
      
  UPDATE #DATA      
  SET VALID_PARTY= 'Y'      
  FROM #DATA AS A, [172.31.16.94].DMAT.CITRUS_USR.VW_CLIENT_DP_DATA_VIEW AS B      
  WHERE A.PAN_GIR_NO = ltrim(rtrim(B.CB_PANNO)) AND VALID_PARTY = 'N'      
  **/  
    
  ---- VALIDATE REGION ----       
  UPDATE #DATA      
  SET VALID_REGION= 'Y'      
  FROM #DATA AS A, REGION AS B      
  WHERE A.REGION = B.REGIONCODE      
      
  ---- VALIDATE AREA ----      
  UPDATE #DATA       
  SET VALID_AREA = 'Y'       
  FROM #DATA AS A, AREA AS B       
  WHERE A.AREA = B.AREACODE      
      
  ---- VALIDATE TRADER ----      
  UPDATE #DATA      
  SET VALID_TRADER = 'Y'      
  FROM #DATA AS A, BRANCHES AS B      
  WHERE A.TRADER = B.SHORT_NAME      
  AND A.BRANCH_CD = B.BRANCH_CD      
      
  ---- VALIDATE SUBBROKER ----      
  UPDATE #DATA      
  SET VALID_SUBBROKER = 'Y'      
  FROM #DATA AS A, SUBBROKERS AS B      
  WHERE A.SUB_BROKER = B.SUB_BROKER      
                                       
  ---- VALIDATE BRANCH ----      
  UPDATE #DATA       
  SET VALID_BRANCH = 'Y'      
  FROM #DATA AS A, BRANCH AS B       
  WHERE A.BRANCH_CD = B.BRANCH_CODE       
      
  ---- VALIDATE BANK ----      
       
  UPDATE #DATA       
  SET VALID_BANK = 'Y' /* suresh ,BANKID=B.RBI_BANKID      
  FROM #DATA AS A, ACCOUNT.DBO.RBIBANKMASTER AS B       
  WHERE A.BANK_NAME = B.BANK_NAME       
  AND A.BRANCH_NAME = B.BRANCH_NAME       
  AND A.MICR_NO = B.MICR_CODE       
  AND A.IFSC_CODE = ISNULL(B.IFSC_CODE,'')      
  AND AC_NUM <> ''-*/      
      
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK1 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID1 = B.BANKID       
  AND CLTDPID1<> ''                                       
      
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK2 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID2 = B.BANKID       
  AND CLTDPID2<> ''                              
                              
  ---- VALIDATE DPBANK ----      
  UPDATE #DATA       
  SET VALID_DPBANK3 = 'Y'       
  FROM #DATA AS A, BANK AS B       
  WHERE A.DPID3 = B.BANKID       
  AND CLTDPID3<> ''      
      
  -- UPDATING VALID RECORD -----      
  UPDATE #DATA     SET RECVALID='Y'        
  WHERE      
  VALID_PARTY='Y'      
  AND VALID_REGION = 'Y'        
  AND VALID_AREA = 'Y'        
  AND VALID_TRADER = 'Y'        
  AND VALID_SUBBROKER = 'Y'        
  AND VALID_BRANCH = 'Y'        
  AND VALID_BANK = 'Y'        
  AND VALID_DPBANK1 = 'Y'       
  AND VALID_DPBANK2 = 'Y'       
  AND VALID_DPBANK3 = 'Y'      
      
  
 
    
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET      
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,      
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,         
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,    
 BRANCH_CD= CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END ,         
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,       
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,        
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,          
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,          
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,         
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,       
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,          
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,       
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,          
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,         
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,        
 ZIP= CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,          
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,         
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,         
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,       
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,        
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,         
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,       
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,      
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,          
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,         
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,     
 --INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,       
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE      
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,          
 --HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,          
 --HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,          
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END     
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,
  ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE  

UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
  PARTY_NAME= CASE WHEN ISNULL(A.LONG_NAME, '') <> '' THEN ISNULL(A.LONG_NAME, '') ELSE C.PARTY_NAME END,      
 CL_TYPE= CASE WHEN ISNULL(A.CL_TYPE, '') <> '' THEN ISNULL(A.CL_TYPE, '') ELSE C.CL_TYPE END,         
 CL_STATUS=CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,    
 BRANCH_CD= CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END ,         
 SUB_BROKER= CASE WHEN ISNULL(A.SUB_BROKER, '') <> '' THEN ISNULL(A.SUB_BROKER, '') ELSE C.SUB_BROKER END,       
 TRADER= CASE WHEN ISNULL(A.TRADER, '') <> '' THEN ISNULL(A.TRADER, '') ELSE C.TRADER END,        
 AREA= CASE WHEN ISNULL(A.AREA, '') <> '' THEN ISNULL(A.AREA, '') ELSE C.AREA END,          
 REGION= CASE WHEN ISNULL(A.REGION, '') <> '' THEN ISNULL(A.REGION, '') ELSE C.REGION END,          
 FAMILY= CASE WHEN ISNULL(A.FAMILY, '') <> '' THEN ISNULL(A.FAMILY, '') ELSE C.FAMILY END,         
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO= CASE WHEN ISNULL(A.PAN_GIR_NO, '') <> '' THEN ISNULL(A.PAN_GIR_NO, '') ELSE C.PAN_NO END,       
 ADDR1= CASE WHEN ISNULL(A.L_ADDRESS1, '') <> '' THEN ISNULL(A.L_ADDRESS1, '') ELSE C.ADDR1 END,          
 ADDR2= CASE WHEN ISNULL(A.L_ADDRESS2, '') <> '' THEN ISNULL(A.L_ADDRESS2, '') ELSE C.ADDR2 END,       
 ADDR3= CASE WHEN ISNULL(A.L_ADDRESS3, '') <> '' THEN ISNULL(A.L_ADDRESS3, '') ELSE C.ADDR3 END,          
 CITY= CASE WHEN ISNULL(A.L_CITY, '') <> '' THEN ISNULL(A.L_CITY, '') ELSE C.CITY END,         
 STATE= CASE WHEN ISNULL(A.L_STATE, '') <> '' THEN ISNULL(A.L_STATE, '') ELSE C.STATE END,        
 ZIP= CASE WHEN ISNULL(A.CL_STATUS, '') <> '' THEN ISNULL(A.CL_STATUS, '') ELSE C.CL_STATUS END,          
 NATION= CASE WHEN ISNULL(A.L_NATION, '') <> '' THEN ISNULL(A.L_NATION, '') ELSE C.NATION END,         
 OFFICE_PHONE= CASE WHEN ISNULL(A.P_PHONE, '') <> '' THEN ISNULL(A.P_PHONE, '') ELSE C.OFFICE_PHONE END,         
 RES_PHONE= CASE WHEN ISNULL(A.RES_PHONE1, '') <> '' THEN ISNULL(A.RES_PHONE1, '') ELSE C.RES_PHONE END,       
 MOBILE_NO= CASE WHEN ISNULL(A.MOBILE_PAGER, '') <> '' THEN ISNULL(A.MOBILE_PAGER, '') ELSE C.MOBILE_NO END,        
 EMAIL_ID= CASE WHEN ISNULL(A.EMAIL, '') <> '' THEN ISNULL(A.EMAIL, '') ELSE C.EMAIL_ID END,         
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=CASE WHEN ISNULL(A.AC_NUM, '') <> '' THEN ISNULL(A.AC_NUM, '') ELSE C.ACC_NO END,       
 MICR_NO= CASE WHEN ISNULL(A.MICR_NO, '') <> '' THEN ISNULL(A.MICR_NO, '') ELSE C.MICR_NO END,      
 NEFTCODE= CASE WHEN ISNULL(A.IFSC_CODE, '') <> '' THEN ISNULL(A.IFSC_CODE, '') ELSE C.NEFTCODE END,          
 DOB=CASE WHEN ISNULL(A.DOB, '') <> '' THEN ISNULL(A.DOB, '') ELSE C.DOB END,         
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 --ACTIVE_FROM=CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE getdate() END,     
-- INACTIVE_FROM= CASE WHEN ISNULL(A.ACTIVE_FROM, '') <> '' THEN ISNULL(A.ACTIVE_FROM, '') ELSE 'DEC 31 2049 23:59'END,       
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION      
-- TAX_STATUS=FMCODE,      
 --HOLDER2_NAME= CASE WHEN ISNULL(A.APP_NAME_2, '') <> '' THEN ISNULL(A.APP_NAME_2, '') ELSE C.HOLDER2_NAME END,          
-- HOLDER2_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_2, '') <> '' THEN ISNULL(A.APP_PAN_NO_2, '') ELSE C.HOLDER2_PAN_NO END,          
-- HOLDER3_NAME= CASE WHEN ISNULL(A.APP_NAME_3, '') <> '' THEN ISNULL(A.APP_NAME_3, '') ELSE C.HOLDER3_NAME END,          
 --HOLDER3_PAN_NO= CASE WHEN ISNULL(A.APP_PAN_NO_3, '') <> '' THEN ISNULL(A.APP_PAN_NO_3, '') ELSE C.HOLDER3_PAN_NO END     
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE,
  ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE  

   
      
 /*UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C                      
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='BSE'      
 AND B.SEGMENT='CAPITAL'     */    
               
 ----------------------------------------------------------------------------------------------------------------                                    
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 PARTY_NAME=A.LONG_NAME,      
 CL_TYPE=A.CL_TYPE ,       
 CL_STATUS=A.CL_STATUS ,      
 BRANCH_CD=A.BRANCH_CD ,      
 SUB_BROKER=A.SUB_BROKER,      
 TRADER=A.TRADER ,      
 AREA=A.AREA ,      
 REGION=A.REGION ,       
 FAMILY=A.FAMILY,      
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO=A.PAN_GIR_NO ,      
 ADDR1=A.L_ADDRESS1 ,      
 ADDR2=A.L_ADDRESS2 ,      
 ADDR3=ISNULL(A.L_ADDRESS3, ''),      
 CITY=A.L_CITY ,      
 STATE=A.L_STATE ,      
 ZIP=A.L_ZIP ,      
 NATION=A.L_NATION ,      
 OFFICE_PHONE=A.P_PHONE ,      
 RES_PHONE=A.RES_PHONE1 ,      
 MOBILE_NO=A.MOBILE_PAGER ,      
 EMAIL_ID=A.EMAIL ,      
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=A.AC_NUM ,      
 MICR_NO=A.MICR_NO ,      
 NEFTCODE=A.IFSC_CODE,      
 DOB=A.DOB ,      
 BANK_AC_TYPE=CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END ,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59',      
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE,      
 HOLDER2_NAME=ISNULL(APP_NAME_2, ''),      
 HOLDER2_PAN_NO=ISNULL(APP_PAN_NO_2, ''),      
 HOLDER3_NAME=ISNULL(APP_NAME_3, ''),      
 HOLDER3_PAN_NO=ISNULL(APP_PAN_NO_3, '')      
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE, ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE       
      
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C          
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='NSE'      
 AND B.SEGMENT='CAPITAL'  */

 UPDATE A
SET
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.ACNAME END,
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE A.LONGNAME END
--BRANCHCODE= CASE WHEN #DATA.BRANCH_CD <> '' THEN #DATA.BRANCH_CD ELSE A.BRANCHCODE END
FROM #DATA ,ANGELFO.BBO_FA.DBO.ACMAST A WHERE RECVALID='Y' 
AND #DATA.CL_CODE=A.CLTCODE     
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE 
AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')  
 
 

/*UPDATE ANGELFO.BBO_FA.DBO.ACMAST 
SET
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.ACNAME END,
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.LONGNAME END,
BRANCHCODE=#DATA.BRANCH_CD
FROM #DATA WHERE RECVALID='Y'      
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')          */
      
 /*DELETE ANGELFO.BBO_FA.DBO.ACMAST      
 FROM ANGELFO.BBO_FA.DBO.ACMAST AS A,#DATA AS B ,#DATA_BROK C      
 WHERE B.RECVALID = 'Y'      
 AND A.CLTCODE = B.PARTY_CODE      
 AND B.CL_CODE=C.CL_CODE       
 AND C.EXCHANGE IN ('NSE','BSE') AND C.SEGMENT='CAPITAL'      
        
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME  , LONG_NAME , 'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'NSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
      
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME ,LONG_NAME ,'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'BSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
*/   

 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,      
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END     
 FROM ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   
 
  UPDATE ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO= CASE WHEN B.PAN_GIR_NO <> '' THEN B.PAN_GIR_NO ELSE A.PAN_NO END,
 DOB=  CASE WHEN B.DOB <> '' THEN B.DOB ELSE A.DOB END,
 POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE A.POAFLAG END,      
 MODE_HOLDING=  CASE WHEN B.CHANNEL_TYPE <> '' THEN B.CHANNEL_TYPE ELSE A.MODE_HOLDING END,
 OCCUPATION_CODE=  CASE WHEN B.OCCUPATION <> '' THEN B.OCCUPATION ELSE A.OCCUPATION_CODE END,
  TAX_STATUS=  CASE WHEN B.FMCODE <> '' THEN B.FMCODE ELSE A.TAX_STATUS END     
 FROM ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   
 
 /*             
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'      
         
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   */
        
 /*UPDATE ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='NSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='BSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 /*INSERT INTO ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT      
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'       
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='NSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM ANGELFO.NSEMFSS.DBO.MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE) */      
                 
 INSERT INTO ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT       
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'        
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='BSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM BSEMFSS..MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE)     

 DELETE ANGELFO.BBO_FA.DBO.MULTIBANKID      
 FROM ANGELFO.BBO_FA.DBO.MULTIBANKID AS A,#DATA AS B      
 WHERE B.RECVALID = 'Y'      
 AND B.CL_CODE=A.CLTCODE AND SEGMENT='MFSS'        
                 
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','NSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'      
      
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','BSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'     */   
    
 ------------------------------------------------------------------------------------------                   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_suresh_27092016
-- --------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



  ---EXEC [MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE ]  'JUN 25 2016','JUN 26 2016'
  
CREATE  PROC [dbo].[MIG_CITRUS_TO_CLIENT_DETAILS_EQUITY_UPDATE_MFSS_suresh_27092016]      
(      
 @FDATE VARCHAR(11)='',      
 @TDATE VARCHAR(11)=''      
)      
      
AS      
BEGIN      
  
 IF @FDATE ='' AND @TDATE =''       
 BEGIN      
  SELECT @FDATE = LEFT(MIN(CL_ACTIVATED_ON),11),@TDATE = LEFT(MAX(CL_ACTIVATED_ON),11)      
  FROM [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE_suresh_27092016      
  WHERE DATA_MIGRATE_STAT = 1      
 END  
 
 CREATE TABLE #DATA      
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [BRANCH_CD] [VARCHAR](10) NULL,      
  [PARTY_CODE] [VARCHAR](10) NOT NULL,      
  [SUB_BROKER] [VARCHAR](10) NOT NULL,      
  [TRADER] [VARCHAR](20) NULL,      
  [LONG_NAME] [VARCHAR](100) NULL,      
  [SHORT_NAME] [VARCHAR](30) NULL,      
  [L_ADDRESS1] [VARCHAR](100) NULL,      
  [L_CITY] [VARCHAR](40) NULL,      
  [L_ADDRESS2] [VARCHAR](100) NULL,      
  [L_STATE] [VARCHAR](50) NULL,      
  [L_ADDRESS3] [VARCHAR](100) NULL,      
  [L_NATION] [VARCHAR](15) NULL,      
  [L_ZIP] [VARCHAR](10) NULL,      
  [PAN_GIR_NO] [VARCHAR](50) NULL,      
  [WARD_NO] [VARCHAR](50) NULL,      
  [SEBI_REGN_NO] [VARCHAR](25) NULL,      
  [RES_PHONE1] [VARCHAR](15) NULL,      
  [RES_PHONE2] [VARCHAR](15) NULL,      
  [OFF_PHONE1] [VARCHAR](15) NULL,      
  [OFF_PHONE2] [VARCHAR](15) NULL,      
  [MOBILE_PAGER] [VARCHAR](40) NULL,      
  [FAX] [VARCHAR](15) NULL,      
  [EMAIL] [VARCHAR](100) NULL,      
  [CL_TYPE] [VARCHAR](3) NOT NULL,      
  [CL_STATUS] [VARCHAR](3) NOT NULL,      
  [FAMILY] [VARCHAR](10) NOT NULL,      
  [REGION] [VARCHAR](20) NULL,      
  [AREA] [VARCHAR](20) NULL,      
  [P_ADDRESS1] [VARCHAR](100) NULL,      
  [P_CITY] [VARCHAR](40) NULL,      
  [P_ADDRESS2] [VARCHAR](100) NULL,      
  [P_STATE] [VARCHAR](50) NULL,      
  [P_ADDRESS3] [VARCHAR](100) NULL,      
  [P_NATION] [VARCHAR](15) NULL,      
  [P_ZIP] [VARCHAR](10) NULL,      
  [P_PHONE] [VARCHAR](15) NULL,      
  [ADDEMAILID] [VARCHAR](230) NULL,      
  [SEX] [CHAR](1) NULL,      
  [DOB] [DATETIME] NULL,      
  [INTRODUCER] [VARCHAR](30) NULL,      
  [APPROVER] [VARCHAR](30) NULL,      
  [INTERACTMODE] [TINYINT] NULL,      
  [PASSPORT_NO] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_AT] [VARCHAR](30) NULL,      
  [PASSPORT_ISSUED_ON] [DATETIME] NULL,      
  [PASSPORT_EXPIRES_ON] [DATETIME] NULL,      
  [LICENCE_NO] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_AT] [VARCHAR](30) NULL,      
  [LICENCE_ISSUED_ON] [DATETIME] NULL,      
  [LICENCE_EXPIRES_ON] [DATETIME] NULL,      
  [RAT_CARD_NO] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_AT] [VARCHAR](30) NULL,      
  [RAT_CARD_ISSUED_ON] [DATETIME] NULL,      
  [VOTERSID_NO] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_AT] [VARCHAR](30) NULL,      
  [VOTERSID_ISSUED_ON] [DATETIME] NULL,      
  [IT_RETURN_YR] [VARCHAR](30) NULL,      
  [IT_RETURN_FILED_ON] [DATETIME] NULL,      
  [REGR_NO] [VARCHAR](50) NULL,      
  [REGR_AT] [VARCHAR](50) NULL,      
  [REGR_ON] [DATETIME] NULL,      
  [REGR_AUTHORITY] [VARCHAR](50) NULL,      
  [CLIENT_AGREEMENT_ON] [DATETIME] NULL,      
  [SETT_MODE] [VARCHAR](50) NULL,      
  [DEALING_WITH_OTHER_TM] [VARCHAR](50) NULL,      
  [OTHER_AC_NO] [VARCHAR](50) NULL,      
  [INTRODUCER_ID] [VARCHAR](50) NULL,      
  [INTRODUCER_RELATION] [VARCHAR](50) NULL,      
  [REPATRIAT_BANK] [NUMERIC](18, 0) NULL,      
  [REPATRIAT_BANK_AC_NO] [VARCHAR](30) NULL,      
  [CHK_KYC_FORM] [TINYINT] NULL,      
  [CHK_CORPORATE_DEED] [TINYINT] NULL,      
  [CHK_BANK_CERTIFICATE] [TINYINT] NULL,      
  [CHK_ANNUAL_REPORT] [TINYINT] NULL,      
  [CHK_NETWORTH_CERT] [TINYINT] NULL,      
  [CHK_CORP_DTLS_RECD] [TINYINT] NULL,      
  [BANK_NAME] [VARCHAR](100) NULL,      
  [BRANCH_NAME] [VARCHAR](50) NULL,      
  [AC_TYPE] [VARCHAR](10) NULL,      
  [AC_NUM] [VARCHAR](20) NULL,      
  [DEPOSITORY1] [VARCHAR](7) NULL,      
  [DPID1] [VARCHAR](16) NULL,      
  [CLTDPID1] [VARCHAR](16) NULL,      
  [POA1] [CHAR](1) NULL,      
  [DEPOSITORY2] [VARCHAR](7) NULL,      
  [DPID2] [VARCHAR](16) NULL,      
  [CLTDPID2] [VARCHAR](16) NULL,      
  [POA2] [CHAR](1) NULL,      
  [DEPOSITORY3] [VARCHAR](7) NULL,      
  [DPID3] [VARCHAR](16) NULL,      
  [CLTDPID3] [VARCHAR](16) NULL,      
  [POA3] [CHAR](1) NULL,      
  [REL_MGR] [VARCHAR](10) NULL,      
  [C_GROUP] [VARCHAR](10) NULL,     
  [SBU] [VARCHAR](10) NULL,      
  [STATUS] [CHAR](1) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [MODIFIDEDBY] [VARCHAR](25) NULL,      
  [MODIFIDEDON] [DATETIME] NULL,      
  [BANK_ID] [VARCHAR](20) NULL,      
  [MAPIN_ID] [VARCHAR](12) NULL,      
  [UCC_CODE] [VARCHAR](12) NULL,      
  [MICR_NO] [VARCHAR](10) NULL,      
  [IFSC_CODE] [VARCHAR](20) NULL,      
  [DIRECTOR_NAME] [VARCHAR](500) NULL,      
  [PAYLOCATION] [VARCHAR](20) NULL,      
  [FMCODE] [VARCHAR](10) NULL,      
  [PARENTCODE] [VARCHAR](10) NULL,      
  [PRODUCTCODE] [VARCHAR](2) NULL,      
  [INCOME_SLAB] [VARCHAR](50) NULL,      
  [NETWORTH_SLAB] [VARCHAR](50) NULL,      
  [AUTOFUNDPAYOUT] [INT] NULL,      
  [SEBI_REG_DATE] [DATETIME] NULL,      
  [SEBI_EXP_DATE] [DATETIME] NULL,      
  [PERSON_TAG] [INT] NULL,      
  [COMMODITY_TRADER] [VARCHAR](20) NULL,      
  [CHANNEL_TYPE] [VARCHAR](20) NULL,      
  [DMA_AGREEMENT_DATE] [DATETIME] NULL,      
  [DMA_ACTIVATION_DATE] [DATETIME] NULL,      
  [FO_TRADER] [VARCHAR](20) NULL,      
  [CDS_TRADER] [VARCHAR](20) NULL,      
  [CDS_SUBBROKER] [VARCHAR](10) NULL,      
  [RES_PHONE1_STD] [VARCHAR](10) NULL,      
  [RES_PHONE2_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE1_STD] [VARCHAR](10) NULL,      
  [OFF_PHONE2_STD] [VARCHAR](10) NULL,      
  [P_PHONE_STD] [VARCHAR](10) NULL,      
  [BANKID] [INT] NULL,      
  [VALID_PARTY] [VARCHAR](1),      
  [VALID_REGION] [VARCHAR](1),      
  [VALID_AREA] [VARCHAR](1),      
  [VALID_TRADER] [VARCHAR](1),      
  [VALID_SUBBROKER] [VARCHAR](1),      
  [VALID_BRANCH] [VARCHAR](1),      
  [VALID_BANK] [VARCHAR](1),      
  [VALID_DPBANK1] [VARCHAR](1),      
  [VALID_DPBANK2] [VARCHAR](1),      
  [VALID_DPBANK3] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1),      
  [OCCUPATION] INT      
 )      
                                  

INSERT INTO #DATA                                      
 SELECT DISTINCT      
  REF_SRNO,CL_CODE,BRANCH_CD,PARTY_CODE,SUB_BROKER,TRADER,      
  LONG_NAME=LEFT(LONG_NAME,100),SHORT_NAME=LEFT(REPLACE(SHORT_NAME, ' NULL ', ''),30),L_ADDRESS1=LEFT(L_ADDRESS1,40),      
  L_CITY=LEFT(L_CITY,40),L_ADDRESS2=LEFT(L_ADDRESS2,40),      
  L_STATE=CASE LEFT(L_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(L_STATE,50) END,      
  L_ADDRESS3=LEFT(L_ADDRESS3,40),L_NATION=LEFT(L_NATION,15),L_ZIP=LEFT(L_ZIP,10),      
  PAN_GIR_NO,WARD_NO,SEBI_REGN_NO=ISNULL(SEBI_REGN_NO,''),RES_PHONE1=LEFT(RES_PHONE1,15),      
  RES_PHONE2=LEFT(RES_PHONE2,15),OFF_PHONE1=LEFT(OFF_PHONE1,15),OFF_PHONE2=LEFT(OFF_PHONE2,15),      
  MOBILE_PAGER=LEFT(MOBILE_PAGER,40),      
  FAX=LEFT(FAX,15),EMAIL=LEFT(EMAIL,100),      
  CL_STATUS,/*CL_TYPE=(CASE CL_TYPE WHEN 'CLI' THEN 'ROR' ELSE CL_TYPE END)*/
  CL_TYPE=(CASE CL_TYPE WHEN 'ROR' THEN 'IND' ELSE CL_TYPE END),FAMILY,REGION,AREA,      
  P_ADDRESS1=LEFT(P_ADDRESS1,100),P_CITY=LEFT(P_CITY,20),      
  P_ADDRESS2=LEFT(P_ADDRESS2,100),P_STATE=CASE LEFT(P_STATE,50) WHEN 'GUJARAT' THEN 'GUJRAT' WHEN 'TAMIL NADU' THEN 'TAMILNADU' ELSE LEFT(P_STATE,50) END,      
  P_ADDRESS3=LEFT(P_ADDRESS3,100),P_NATION=LEFT(P_NATION,15),P_ZIP=LEFT(P_ZIP,10),      
  P_PHONE=LEFT(P_PHONE,15),ADDEMAILID=LEFT(ADDEMAILID,230),      
  SEX=ISNULL(SEX, 'M'),DOB=CONVERT(DATETIME,DOB,103),INTRODUCER=LEFT(INTRODUCER,30),APPROVER,INTERACTMODE,PASSPORT_NO,PASSPORT_ISSUED_AT,      
  PASSPORT_ISSUED_ON,PASSPORT_EXPIRES_ON,LICENCE_NO,LICENCE_ISSUED_AT,      
  LICENCE_ISSUED_ON,LICENCE_EXPIRES_ON,RAT_CARD_NO,RAT_CARD_ISSUED_AT,      
  RAT_CARD_ISSUED_ON,VOTERSID_NO,VOTERSID_ISSUED_AT,VOTERSID_ISSUED_ON,      
  IT_RETURN_YR,IT_RETURN_FILED_ON,REGR_NO,REGR_AT,REGR_ON,REGR_AUTHORITY,      
  CLIENT_AGREEMENT_ON,SETT_MODE,DEALING_WITH_OTHER_TM,OTHER_AC_NO,INTRODUCER_ID,      
  INTRODUCER_RELATION,REPATRIAT_BANK,REPATRIAT_BANK_AC_NO,CHK_KYC_FORM,      
  CHK_CORPORATE_DEED,CHK_BANK_CERTIFICATE,CHK_ANNUAL_REPORT,CHK_NETWORTH_CERT,      
  CHK_CORP_DTLS_RECD,BANK_NAME,BRANCH_NAME=LEFT(BRANCH_NAME,50),AC_TYPE=LEFT(AC_TYPE, 1),AC_NUM,DEPOSITORY1,DPID1,      
  CLTDPID1,POA1 = CASE WHEN POA1 = '0' THEN '' ELSE POA1 END,DEPOSITORY2,      
  DPID2 = CASE WHEN CONVERT(VARCHAR, DPID2) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID2) END,CLTDPID2,POA2,DEPOSITORY3,      
  DPID3 = CASE WHEN CONVERT(VARCHAR, DPID3) = '0' THEN '' ELSE CONVERT(VARCHAR, DPID3) END,CLTDPID3,      
  POA3,REL_MGR,C_GROUP,SBU,[STATUS],IMP_STATUS,MODIFIDEDBY,MODIFIDEDON,BANK_ID,      
  MAPIN_ID,UCC_CODE = PARTY_CODE,MICR_NO,IFSC_CODE,DIRECTOR_NAME,      
  PAYLOCATION = '',FMCODE,PARENTCODE,PRODUCTCODE,      
  INCOME_SLAB,NETWORTH_SLAB,AUTOFUNDPAYOUT,SEBI_REG_DATE,SEBI_EXP_DATE,PERSON_TAG,      
  COMMODITY_TRADER,CHANNEL_TYPE,DMA_AGREEMENT_DATE,DMA_ACTIVATION_DATE,FO_TRADER,      
  CDS_TRADER,CDS_SUBBROKER,RES_PHONE1_STD=LEFT(RES_PHONE1_STD,10),RES_PHONE2_STD=LEFT(RES_PHONE2_STD,10),      
  OFF_PHONE1_STD=LEFT(OFF_PHONE1_STD,10),OFF_PHONE2_STD=LEFT(OFF_PHONE2_STD,10),P_PHONE_STD=LEFT(P_PHONE_STD,10),BANKID=0,      
  VALID_PARTY='N',VALID_REGION = 'N',VALID_AREA = 'N',VALID_TRADER = 'N',VALID_SUBBROKER = 'N',      
  VALID_BRANCH = 'N',VALID_BANK = CASE WHEN AC_NUM ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK1 = CASE WHEN ISNULL(CLTDPID1, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK2 = CASE WHEN ISNULL(CLTDPID2, '') ='' THEN 'Y' ELSE 'N' END,      
  VALID_DPBANK3 = CASE WHEN ISNULL(CLTDPID3, '') ='' THEN 'Y' ELSE 'N' END,      
  RECVALID ='N', OCCUPATION   
 FROM       
  [172.31.16.57].CRMDB_A.DBO.VIEW_CLASS_CLIENT_DETAILS_UPDATE_suresh_27092016      
 WHERE      
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'       
  AND DATA_MIGRATE_STAT = 1 AND [STATUS]='U'      
  AND ISNULL(CL_type,'') <> ''   
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')

  
  
 IF (SELECT COUNT(1) FROM #DATA) = 0 RETURN      
      
 CREATE TABLE #DATA_BROK       
 (      
  [SRNO] [INT] NOT NULL,      
  [CL_CODE] [VARCHAR](10) NOT NULL,      
  [EXCHANGE] [VARCHAR](3) NOT NULL,      
  [SEGMENT] [VARCHAR](7) NOT NULL,      
  [BROK_SCHEME] [TINYINT] NULL,      
  [TRD_BROK] [INT] NULL,      
  [DEL_BROK] [INT] NULL,      
  [SER_TAX] [TINYINT] NULL,      
  [SER_TAX_METHOD] [TINYINT] NULL,      
  [CREDIT_LIMIT] [INT] NOT NULL,      
  [INACTIVE_FROM] [DATETIME] NULL,      
  [PRINT_OPTIONS] [TINYINT] NULL,      
  [NO_OF_COPIES] [INT] NULL,      
  [PARTICIPANT_CODE] [VARCHAR](15) NULL,      
  [CUSTODIAN_CODE] [VARCHAR](50) NULL,      
  [INST_CONTRACT] [CHAR](1) NULL,      
  [ROUND_STYLE] [INT] NULL,      
  [STP_PROVIDER] [VARCHAR](5) NULL,      
  [STP_RP_STYLE] [TINYINT] NULL,      
  [MARKET_TYPE] [INT] NULL,      
  [MULTIPLIER] [INT] NULL,      
  [CHARGED] [INT] NULL,      
  [MAINTENANCE] [INT] NULL,      
  [REQD_BY_EXCH] [INT] NULL,      
  [REQD_BY_BROKER] [INT] NULL,      
  [CLIENT_RATING] [VARCHAR](10) NULL,      
  [DEBIT_BALANCE] [CHAR](1) NULL,      
  [INTER_SETT] [CHAR](1) NULL,      
  [TRD_STT] [MONEY] NULL,      
  [TRD_TRAN_CHRGS] [FLOAT] NULL,      
  [TRD_SEBI_FEES] [MONEY] NULL,      
  [TRD_STAMP_DUTY] [MONEY] NULL,      
  [TRD_OTHER_CHRGS] [MONEY] NULL,      
  [TRD_EFF_DT] [DATETIME] NULL,      
  [DEL_STT] [MONEY] NULL,      
  [DEL_TRAN_CHRGS] [FLOAT] NULL,      
  [DEL_SEBI_FEES] [MONEY] NULL,      
  [DEL_STAMP_DUTY] [MONEY] NULL,      
  [DEL_OTHER_CHRGS] [MONEY] NULL,      
  [DEL_EFF_DT] [DATETIME] NULL,      
  [ROUNDING_METHOD] [VARCHAR](10) NULL,      
  [ROUND_TO_DIGIT] [TINYINT] NULL,      
  [ROUND_TO_PAISE] [INT] NULL,      
  [FUT_BROK] [INT] NULL,      
  [FUT_OPT_BROK] [INT] NULL,      
  [FUT_FUT_FIN_BROK] [INT] NULL,      
  [FUT_OPT_EXC] [INT] NULL,      
  [FUT_BROK_APPLICABLE] [INT] NULL,      
  [FUT_STT] [SMALLINT] NULL,      
  [FUT_TRAN_CHRGS] [SMALLINT] NULL,      
  [FUT_SEBI_FEES] [SMALLINT] NULL,      
  [FUT_STAMP_DUTY] [SMALLINT] NULL,      
  [FUT_OTHER_CHRGS] [SMALLINT] NULL,      
  [STATUS] [CHAR](1) NULL,      
  [MODIFIEDON] [DATETIME] NULL,      
  [MODIFIEDBY] [VARCHAR](25) NULL,      
  [IMP_STATUS] [TINYINT] NULL,      
  [PAY_B3B_PAYMENT] [CHAR](1) NULL,      
  [PAY_BANK_NAME] [VARCHAR](50) NULL,      
  [PAY_BRANCH_NAME] [VARCHAR](50) NULL,      
  [PAY_AC_NO] [VARCHAR](20) NULL,      
  [PAY_PAYMENT_MODE] [CHAR](1) NULL,      
  [BROK_EFF_DATE] [DATETIME] NULL,      
  [INST_TRD_BROK] [INT] NULL,      
  [INST_DEL_BROK] [INT] NULL,      
  [SYSTEMDATE] [DATETIME] NULL,      
  [ACTIVE_DATE] [DATETIME] NULL,      
  [CHECKACTIVECLIENT] [VARCHAR](1) NULL,      
  [DEACTIVE_REMARKS] [VARCHAR](100) NULL,      
  [DEACTIVE_VALUE] [VARCHAR](1) NULL,      
  [VALUE_PACK] [VARCHAR](20) NULL,      
  [VALID_TRD_BROK] [VARCHAR](1),      
  [VALID_DEL_BROK] [VARCHAR](1),      
  [VALID_FUT_BROK] [VARCHAR](1),      
  [VALID_OPT_BROK] [VARCHAR](1),      
  [VALID_FUT_EXP_BROK] [VARCHAR](1),      
  [VALID_OPT_EXC_BROK] [VARCHAR](1),      
  [VALID_VALUEPACK_BROK] [VARCHAR](1),      
  [VALID_EXCHANGE] [VARCHAR](1),      
  [RECVALID] [VARCHAR](1)      
 )      
                           
 INSERT INTO #DATA_BROK      
 SELECT       
  REF_SRNO,CL_CODE,EXCHANGE,SEGMENT,      
  BROK_SCHEME = (CASE WHEN SEGMENT NOT IN ('CAPITAL', 'SLBS')      
  THEN BROK_SCHEME ELSE (CASE WHEN BROK_SCHEME = 1 THEN 2 ELSE BROK_SCHEME END)      
  END),      
  TRD_BROK,DEL_BROK,SER_TAX,SER_TAX_METHOD,CREDIT_LIMIT,INACTIVE_FROM,PRINT_OPTIONS,      
  NO_OF_COPIES,PARTICIPANT_CODE,CUSTODIAN_CODE,INST_CONTRACT,ROUND_STYLE,STP_PROVIDER,STP_RP_STYLE,MARKET_TYPE,MULTIPLIER,CHARGED,      
  MAINTENANCE,REQD_BY_EXCH,REQD_BY_BROKER,CLIENT_RATING,DEBIT_BALANCE,INTER_SETT,TRD_STT,TRD_TRAN_CHRGS,TRD_SEBI_FEES,TRD_STAMP_DUTY,      
  TRD_OTHER_CHRGS,TRD_EFF_DT,DEL_STT,DEL_TRAN_CHRGS,DEL_SEBI_FEES,DEL_STAMP_DUTY,DEL_OTHER_CHRGS,DEL_EFF_DT,ROUNDING_METHOD,      
  ROUND_TO_DIGIT,ROUND_TO_PAISE,FUT_BROK,FUT_OPT_BROK,FUT_FUT_FIN_BROK,FUT_OPT_EXC,FUT_BROK_APPLICABLE,FUT_STT,FUT_TRAN_CHRGS,      
  FUT_SEBI_FEES,FUT_STAMP_DUTY,FUT_OTHER_CHRGS,[STATUS],MODIFIEDON,MODIFIEDBY,IMP_STATUS,PAY_B3B_PAYMENT,PAY_BANK_NAME,PAY_BRANCH_NAME,      
  PAY_AC_NO,PAY_PAYMENT_MODE,BROK_EFF_DATE,INST_TRD_BROK,INST_DEL_BROK,SYSTEMDATE,ACTIVE_DATE,CHECKACTIVECLIENT,DEACTIVE_REMARKS,      
  DEACTIVE_VALUE,TRD_VALUE_PACK,      
  VALID_TRD_BROK = 'N',VALID_DEL_BROK = 'N',VALID_FUT_BROK = 'N',VALID_OPT_BROK = 'N',      
  VALID_FUT_EXP_BROK = 'N',VALID_OPT_EXC_BROK = 'N',VALID_VALUEPACK_BROK = 'N',VALID_EXCHANGE='N',RECVALID = 'N'       
 FROM       
  [172.31.16.57].crmdb_a.dbo.VIEW_CLASS_CLIENT_BROK_DETAILS_UPDATE_suresh_27092016      
 WHERE       
  CL_ACTIVATED_ON BETWEEN @FDATE AND @TDATE + ' 23:59'       
  AND DATA_MIGRATE_STAT = 1 AND [STATUS]='U'      
  --AND EXCHANGE NOT IN ('NCX','MCX')      
  --AND CL_CODE IN ('P52029 ','A83168','K36477','J28581 ','JA98','M31449','R52751 ','M31529','D49402','V19361 ','S48278','J22195')
    
 -- TO REMOVE (2 LINES ONLY FOR UAT SERVER)      
 -- DELETE #DATA WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
 -- DELETE #DATA_BROK WHERE NOT EXISTS (SELECT CL_CODE FROM CLIENT_BROK_DETAILS WHERE #DATA_BROK.CL_CODE = CLIENT_BROK_DETAILS.CL_CODE)      
     
      
   update #DATA set  RECVALID = 'Y'  
   
   update #DATA_BROK set  RECVALID = 'Y'  



  

    
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET      
 PARTY_NAME=A.LONG_NAME,      
 CL_TYPE=A.CL_TYPE ,       
 CL_STATUS=A.CL_STATUS ,      
 BRANCH_CD=A.BRANCH_CD ,      
 SUB_BROKER=A.SUB_BROKER,      
 TRADER=A.TRADER ,      
 AREA=A.AREA ,      
 REGION=A.REGION ,       
 FAMILY=A.FAMILY,      
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO=A.PAN_GIR_NO ,      
 ADDR1=A.L_ADDRESS1 ,      
 ADDR2=A.L_ADDRESS2 ,      
 ADDR3=ISNULL(A.L_ADDRESS3, ''),      
 CITY=A.L_CITY ,      
 STATE=A.L_STATE ,      
 ZIP=A.L_ZIP ,      
 NATION=A.L_NATION ,      
 OFFICE_PHONE=A.P_PHONE ,      
 RES_PHONE=A.RES_PHONE1 ,      
 MOBILE_NO=A.MOBILE_PAGER ,      
 EMAIL_ID=A.EMAIL ,      
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=A.AC_NUM ,      
 MICR_NO=A.MICR_NO ,      
 NEFTCODE=A.IFSC_CODE,      
 DOB=A.DOB ,      
 BANK_AC_TYPE= CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59',      
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE,      
 HOLDER2_NAME=ISNULL(APP_NAME_2, ''),      
 HOLDER2_PAN_NO=ISNULL(APP_PAN_NO_2, ''),      
 HOLDER3_NAME=ISNULL(APP_NAME_3, ''),      
 HOLDER3_PAN_NO=ISNULL(APP_PAN_NO_3, '')      
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE, ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE  
 
   
      
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.BSEMFSS.DBO.MFSS_CLIENT C                      
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='BSE'      
 AND B.SEGMENT='CAPITAL'         
               
 ----------------------------------------------------------------------------------------------------------------                                    
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 PARTY_NAME=A.LONG_NAME,      
 CL_TYPE=A.CL_TYPE ,       
 CL_STATUS=A.CL_STATUS ,      
 BRANCH_CD=A.BRANCH_CD ,      
 SUB_BROKER=A.SUB_BROKER,      
 TRADER=A.TRADER ,      
 AREA=A.AREA ,      
 REGION=A.REGION ,       
 FAMILY=A.FAMILY,      
 GENDER=CASE WHEN ISNULL(A.SEX, '') <> '' THEN ISNULL(A.SEX, '') ELSE C.GENDER END,      
 PAN_NO=A.PAN_GIR_NO ,      
 ADDR1=A.L_ADDRESS1 ,      
 ADDR2=A.L_ADDRESS2 ,      
 ADDR3=ISNULL(A.L_ADDRESS3, ''),      
 CITY=A.L_CITY ,      
 STATE=A.L_STATE ,      
 ZIP=A.L_ZIP ,      
 NATION=A.L_NATION ,      
 OFFICE_PHONE=A.P_PHONE ,      
 RES_PHONE=A.RES_PHONE1 ,      
 MOBILE_NO=A.MOBILE_PAGER ,      
 EMAIL_ID=A.EMAIL ,      
 BANK_NAME=CASE WHEN ISNULL(A.BANK_NAME, '') <> '' THEN ISNULL(A.BANK_NAME, '') ELSE C.BANK_NAME END,      
 BANK_BRANCH=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_BRANCH END,      
 BANK_CITY=CASE WHEN ISNULL(A.BRANCH_NAME, '') <> '' THEN ISNULL(A.BRANCH_NAME, '') ELSE C.BANK_CITY END,      
 ACC_NO=A.AC_NUM ,      
 MICR_NO=A.MICR_NO ,      
 NEFTCODE=A.IFSC_CODE,      
 DOB=A.DOB ,      
 BANK_AC_TYPE=CASE WHEN A.AC_TYPE = 'CURRENT' THEN 'CB' ELSE 'SB' END ,      
 DP_TYPE=CASE WHEN ISNULL(A.DEPOSITORY1, '') <> '' THEN ISNULL(A.DEPOSITORY1, '') ELSE C.DP_TYPE END,      
 DPID=CASE WHEN ISNULL(A.DPID1, '') <> '' THEN ISNULL(A.DPID1, '') ELSE C.DPID END,      
 CLTDPID=CASE WHEN ISNULL(A.CLTDPID1, '') <> '' THEN ISNULL(A.CLTDPID1, '') ELSE C.CLTDPID END,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59',      
 MODE_HOLDING=CHANNEL_TYPE,      
 OCCUPATION_CODE=OCCUPATION,      
 TAX_STATUS=FMCODE,      
 HOLDER2_NAME=ISNULL(APP_NAME_2, ''),      
 HOLDER2_PAN_NO=ISNULL(APP_PAN_NO_2, ''),      
 HOLDER3_NAME=ISNULL(APP_NAME_3, ''),      
 HOLDER3_PAN_NO=ISNULL(APP_PAN_NO_3, '')      
 FROM #DATA A LEFT OUTER JOIN [172.31.16.57].CRMDB_A.DBO.VIEW_OTHER_HOLDER_DETAILS ON BO_PARTYCODE = A.CL_CODE, ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C      
 WHERE A.RECVALID = 'Y'       
 AND A.CL_CODE=C.PARTY_CODE       
      
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_CLIENT SET      
 BROK_EFF_DATE=B.BROK_EFF_DATE,      
 ADDEDBY='CITRUS' ,      
 ADDEDON=GETDATE() ,      
 ACTIVE_FROM=GETDATE() ,      
 INACTIVE_FROM='DEC 31 2049 23:59'       
 FROM #DATA_BROK B,ANGELFO.NSEMFSS.DBO.MFSS_CLIENT C          
 WHERE B.RECVALID = 'Y'       
 AND B.CL_CODE=C.PARTY_CODE      
 AND B.EXCHANGE='NSE'      
 AND B.SEGMENT='CAPITAL'  
 
 

UPDATE ANGELFO.BBO_FA.DBO.ACMAST 
SET
ACNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.ACNAME END,
LONGNAME=CASE WHEN #DATA.LONG_NAME <> '' THEN #DATA.LONG_NAME ELSE ACMAST.LONGNAME END,
BRANCHCODE=#DATA.BRANCH_CD
FROM #DATA WHERE RECVALID='Y'      
AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')          
      
 /*DELETE ANGELFO.BBO_FA.DBO.ACMAST      
 FROM ANGELFO.BBO_FA.DBO.ACMAST AS A,#DATA AS B ,#DATA_BROK C      
 WHERE B.RECVALID = 'Y'      
 AND A.CLTCODE = B.PARTY_CODE      
 AND B.CL_CODE=C.CL_CODE       
 AND C.EXCHANGE IN ('NSE','BSE') AND C.SEGMENT='CAPITAL'      
        
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME  , LONG_NAME , 'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'NSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
      
 INSERT INTO ANGELFO.BBO_FA.DBO.ACMAST                
 SELECT DISTINCT LONG_NAME ,LONG_NAME ,'ASSET' ,4 ,'' ,PARTY_CODE ,'' ,'A0307000000' ,'' ,MICR_NO ,BRANCH_CD ,0 ,'C' ,'' ,'' ,'' ,'BSE' ,'MFSS'           
 FROM #DATA WHERE RECVALID='Y'      
 AND EXISTS (SELECT TOP 1 * FROM #DATA_BROK WHERE #DATA_BROK.CL_CODE = #DATA.CL_CODE AND EXCHANGE IN ('NSE','BSE') AND SEGMENT='CAPITAL')       
*/                
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'      
         
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER      
 SET PAN_NO=PAN_GIR_NO,DOB=B.DOB,POAFLAG=CASE WHEN POA1 <> '' THEN POA1 ELSE POAFLAG END,      
 MODE_HOLDING=CHANNEL_TYPE,OCCUPATION_CODE=OCCUPATION, TAX_STATUS=FMCODE      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_DPMASTER AS A ,#DATA AS B      
 WHERE A.PARTY_CODE = B.PARTY_CODE       
 AND A.DPID = B.DPID1      
 AND A.CLTDPID = B.CLTDPID1      
 AND B.RECVALID = 'Y'   
        
 UPDATE ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='NSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 UPDATE ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER      
 SET TODATE = DATEADD(D, - 1, CONVERT(VARCHAR(11), CONVERT(DATETIME, GETDATE(), 103), 109) + ' 23:59')      
 FROM ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER B ,#DATA_BROK C      
 WHERE B.PARTY_CODE=C.CL_CODE AND C.EXCHANGE='BSE'AND C.SEGMENT='CAPITAL'      
 AND GETDATE() BETWEEN FROMDATE AND TODATE      
      
 /*INSERT INTO ANGELFO.NSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT      
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'       
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='NSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM ANGELFO.NSEMFSS.DBO.MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE)       
                 
 INSERT INTO ANGELFO.BSEMFSS.DBO.MFSS_BROKERAGE_MASTER                
 SELECT DISTINCT       
 PARTY_CODE,BUY_BROK_TABLE_NO='1001',SELL_BROK_TABLE_NO='1002',BROK_EFF_DATE=LEFT(GETDATE(),11) ,'DEC 31 2049 23:59'        
 FROM #DATA A,#DATA_BROK B       
 WHERE A.RECVALID = 'Y' AND A.CL_CODE=B.CL_CODE AND B.EXCHANGE='BSE'  AND B.SEGMENT='CAPITAL'       
 AND EXISTS(SELECT PARTY_CODE FROM BSEMFSS..MFSS_CLIENT M WHERE A.CL_CODE = M.PARTY_CODE)     

 DELETE ANGELFO.BBO_FA.DBO.MULTIBANKID      
 FROM ANGELFO.BBO_FA.DBO.MULTIBANKID AS A,#DATA AS B      
 WHERE B.RECVALID = 'Y'      
 AND B.CL_CODE=A.CLTCODE AND SEGMENT='MFSS'        
                 
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','NSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'      
      
 INSERT INTO ANGELFO.BBO_FA.DBO.MULTIBANKID     
 (CLTCODE,BANKID,ACCNO,ACCTYPE,CHEQUENAME,DEFAULTBANK,EXCHANGE,SEGMENT)     
 SELECT DISTINCT PARTY_CODE,ISNULL(BANKID,'0'),AC_NUM,'SB',SHORT_NAME,'1','BSE','MFSS'      
 FROM #DATA A      
 WHERE A.RECVALID = 'Y'     */   
    
 ------------------------------------------------------------------------------------------                   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_DUPRECCHECK
-- --------------------------------------------------

CREATE PROC [dbo].[NSEMFSS_DUPRECCHECK] (@SAUDA_DATE VARCHAR(11))  
AS  


IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP WHERE CONF_FLAG <> '' ) > 0   
BEGIN  
 UPDATE MFSS_ORDER SET CONF_FLAG = M.CONF_FLAG,  
        REJECT_REASON = M.REJECT_REASON  
 FROM MFSS_ORDER_TMP M  
 WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE  
 AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
 AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
 AND M.SERIES = MFSS_ORDER.SERIES  
END  
  
INSERT INTO MFSS_ORDER  
SELECT ORDER_NO,SETT_TYPE,SETT_NO,SUB_RED_FLAG,ALLOTMENT_MODE,ORDER_DATE,ORDER_TIME,  
    AMC_CODE,AMC_SCHEME_CODE,RTA_CODE,RTA_SCHEME_CODE,SCHEME_CATEGORY,SCRIP_CD,SERIES,  
    SCHEME_OPT_TYPE,ISIN,QTY,AMOUNT,PURCHASE_TYPE,MEMBERCODE,BRANCH_CODE,DEALER_CODE,FOLIONO,  
    PAYOUT_MECHANISM,APPLN_NO,PARTY_CODE,TAX_STATUS,MODE_HOLDING,F_CL_NAME,F_CL_PAN,F_CL_KYC,  
    S_CL_NAME,S_CL_PAN,S_CL_KYC,T_CL_NAME,T_CL_PAN,T_CL_KYC,G_NAME,G_PAN,DPNAME,DP_ID,CLTDPID,  
    MOBILE_NO,BANK_AC_TYPE,BANK_AC_NO,BANK_NAME,BANK_BRANCH,BANK_CITY,MICR_CODE,NEFT_CODE,  
    RTGS_CODE,EMAIL_ID,USER_ID = '',CONF_FLAG,REJECT_REASON,NAV_VALUE_ALLOTED=0,QTY_ALLOTED=0,AMOUNT_ALLOTED=0,
    SIP_Regd_No,SIP_Tranche_No,EUIN_NUMBER
    FROM MFSS_ORDER_TMP M  
WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE  
AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_ORDER   
      WHERE REPLACE(CONVERT(VARCHAR, MFSS_ORDER.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE  
      AND M.ORDER_NO = MFSS_ORDER.ORDER_NO  
      AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD  
      AND M.SERIES = MFSS_ORDER.SERIES )

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_DUPRECSETTCHECK
-- --------------------------------------------------
CREATE PROC [dbo].[NSEMFSS_DUPRECSETTCHECK] (@SAUDA_DATE VARCHAR(11))
AS

IF (SELECT ISNULL(COUNT(1), 0) FROM MFSS_ORDER_TMP 
	WHERE REPLACE(CONVERT(VARCHAR, ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
	AND CONF_FLAG = 'Y' ) > 0 
BEGIN
	INSERT INTO MFSS_TRADE
	SELECT ORDER_NO, STATUS=CONVERT(VARCHAR(2),'11'), SETT_NO, SETT_TYPE, SCRIP_CD, SERIES, ISIN, PARTY_CODE, 
	SETTFLAG = (CASE WHEN SUB_RED_FLAG = 'P' THEN 4 ELSE 5 END),
    F_CL_KYC, F_CL_PAN, APPLN_NO, 
	PURCHASE_TYPE, DP_SETTLMENT = (CASE WHEN LEN(DP_ID) = 0 THEN 'N' ELSE 'Y' END), 
	DP_ID, DPCODE=CONVERT(VARCHAR(8),''), CLTDPID=CLTDPID, FOLIONO, AMOUNT, QTY, MODE_HOLDING, 
	S_CLIENTID='', S_CL_KYC, S_CL_PAN, T_CLIENTID='', T_CL_KYC, T_CL_PAN,
	USER_ID = DEALER_CODE, BRANCH_ID = BRANCH_CODE, SUB_RED_FLAG, ORDER_DATE, ORDER_TIME, 
	MEMBERCODE, '', '', '' 
	FROM MFSS_ORDER M
	WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
	AND CONF_FLAG = 'Y'
	AND ORDER_NO NOT IN (SELECT ORDER_NO FROM MFSS_TRADE 
						 WHERE REPLACE(CONVERT(VARCHAR, MFSS_TRADE.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
							AND M.ORDER_NO = MFSS_TRADE.ORDER_NO
							AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD
							AND M.SERIES = MFSS_TRADE.SERIES )
END

DELETE FROM MFSS_TRADE
WHERE REPLACE(CONVERT(VARCHAR, ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
AND ORDER_NO IN (SELECT ORDER_NO FROM MFSS_SETTLEMENT M
						 WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
							AND M.ORDER_NO = MFSS_TRADE.ORDER_NO
							AND M.SCRIP_CD = MFSS_TRADE.SCRIP_CD
							AND M.SERIES = MFSS_TRADE.SERIES )

UPDATE MFSS_TRADE SET SETT_NO = S.SETT_NO, SETT_TYPE = S.SETT_TYPE
FROM SETT_MST S
WHERE REPLACE(CONVERT(VARCHAR, S.START_DATE, 106), ' ', '-') = @SAUDA_DATE
AND   MFSS_TRADE.SETT_NO = ''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSEMFSS_SCRIPUPLOAD
-- --------------------------------------------------

CREATE PROC NSEMFSS_SCRIPUPLOAD
(
	@FilePath Varchar(100), 
	@ROWTERMINATOR VARCHAR(10)='\n'
)
AS

DECLARE @SQL VARCHAR(2000)

TRUNCATE TABLE MFSS_SCRIP_MASTER_TMP

SELECT TOKEN,SCRIP_CD,SERIES,INTRUMENTTYPE,QUANTITY_LIMIT,RTSCHEMECODE,
AMCSCHEMECODE,ISIN,FOLIO_LENGHT,SEC_STATUS_NRM,ELIGIBILITY_NRM,
SEC_STATUS_ODDLOT,ELIGIBILITY_ODDLOT,SEC_STATUS_SPOT,ELIGIBILITY_SPOT,
SEC_STATUS_AUCTION,ELIGIBILITY_AUCTION,AMCCODE,CATEGORYCODE,SEC_NAME,
ISSUE_RATE,MINSUBSCRADDL,BUYNAVPRICE,SELLNAVPRICE,RTAGENTCODE,VALDECINDICATOR,
CATSTARTTIME,QTYDECINDICATOR,CATENDTIME,MINSUBSCRFRESH,VALUE_LIMIT,
RECORD_DATE=0,EX_DATE=0,NAVDATE=0,NO_DELIVERY_END_DATE=0,ST_ELIGIBLE_IDX,ST_ELIGIBLE_AON,ST_ELIGIBLE_MIN_FILL,
SECDEPMANDATORY,SEC_DIVIDEND,SECALLOWDEP,SECALLOWSELL,SECMODCXL,SECALLOWBUY,BOOK_CL_START_DT=0,
BOOK_CL_END_DT=0,DIVIDEND,RIGHTS,BONUS,INTEREST,AGM,EGM,OTHER,LOCAL_DTTIME=0,DELETEFLAG,REMARK
INTO #MFSS_SCRIP_MASTER_TMP FROM MFSS_SCRIP_MASTER_TMP
WHERE 1 = 2 

SET @SQL = 'BULK INSERT #MFSS_SCRIP_MASTER_TMP FROM ''' + @FilePath + ''' WITH  ( FIELDTERMINATOR = ''|'', ROWTERMINATOR = '''+ @ROWTERMINATOR +''', FirstRow = 2 )'
EXEC (@SQL)

INSERT INTO MFSS_SCRIP_MASTER_TMP
SELECT TOKEN,SCRIP_CD,SERIES,INTRUMENTTYPE,QUANTITY_LIMIT,RTSCHEMECODE,
AMCSCHEMECODE,ISIN,FOLIO_LENGHT,SEC_STATUS_NRM,ELIGIBILITY_NRM,
SEC_STATUS_ODDLOT,ELIGIBILITY_ODDLOT,SEC_STATUS_SPOT,ELIGIBILITY_SPOT,
SEC_STATUS_AUCTION,ELIGIBILITY_AUCTION,AMCCODE,CATEGORYCODE,SEC_NAME,
ISSUE_RATE,MINSUBSCRADDL,BUYNAVPRICE,SELLNAVPRICE,RTAGENTCODE,VALDECINDICATOR,
CATSTARTTIME,QTYDECINDICATOR,CATENDTIME,MINSUBSCRFRESH,VALUE_LIMIT,
RECORD_DATE=DATEADD(SS, RECORD_DATE, CONVERT(DATETIME,'JAN  1 1980')),
EX_DATE=DATEADD(SS, EX_DATE, CONVERT(DATETIME,'JAN  1 1980')),
NAVDATE=DATEADD(SS, NAVDATE, CONVERT(DATETIME,'JAN  1 1980')),
NO_DELIVERY_END_DATE=DATEADD(SS, NO_DELIVERY_END_DATE, CONVERT(DATETIME,'JAN  1 1980')),
ST_ELIGIBLE_IDX,ST_ELIGIBLE_AON,ST_ELIGIBLE_MIN_FILL,
SECDEPMANDATORY,SEC_DIVIDEND,SECALLOWDEP,SECALLOWSELL,SECMODCXL,SECALLOWBUY,
BOOK_CL_START_DT=DATEADD(SS, BOOK_CL_START_DT, CONVERT(DATETIME,'JAN  1 1980')),
BOOK_CL_END_DT=DATEADD(SS, BOOK_CL_END_DT, CONVERT(DATETIME,'JAN  1 1980')),
DIVIDEND,RIGHTS,BONUS,INTEREST,AGM,EGM,OTHER,LOCAL_DTTIME=0,DELETEFLAG,REMARK
FROM #MFSS_SCRIP_MASTER_TMP

DELETE FROM MFSS_SCRIP_MASTER WHERE SCRIP_CD IN ( SELECT SCRIP_CD FROM MFSS_SCRIP_MASTER_TMP 
WHERE MFSS_SCRIP_MASTER.SCRIP_CD = MFSS_SCRIP_MASTER_TMP.SCRIP_CD 
AND MFSS_SCRIP_MASTER.SERIES = MFSS_SCRIP_MASTER_TMP.SERIES) 

INSERT INTO MFSS_SCRIP_MASTER 
SELECT * FROM MFSS_SCRIP_MASTER_TMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_ClientMaster
-- --------------------------------------------------
CREATE PROC PROC_MFSS_ClientMaster 
AS

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_CONTRACTALLTRADE
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_CONTRACTALLTRADE] (@SAUDA_DATE VARCHAR(11))
AS

DECLARE @CNTNO VARCHAR(7)

SELECT @CNTNO = CONTRACTNO FROM CONTGEN
WHERE @SAUDA_DATE >= Start_Date and @SAUDA_DATE <= End_Date

SELECT DISTINCT SETT_NO, SETT_TYPE, PARTY_CODE, CONTRACTNO
INTO #CNTNO FROM MFSS_SETTLEMENT M
WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE

SELECT * INTO #CONF
FROM MFSS_CONFIRMVIEW

UPDATE #CONF SET CONTRACTNO = C.CONTRACTNO
FROM #CNTNO C
WHERE C.PARTY_CODE = #CONF.PARTY_CODE
AND C.SETT_NO = #CONF.SETT_NO
AND C.SETT_TYPE = #CONF.SETT_TYPE

SELECT DISTINCT SETT_NO, SETT_TYPE, PARTY_CODE, CONTRACTNO
INTO #CNTNO_1 FROM #CONF M
WHERE REPLACE(CONVERT(VARCHAR, M.ORDER_DATE, 106), ' ', '-') = @SAUDA_DATE
AND CONTRACTNO = '0'
ORDER BY SETT_NO, SETT_TYPE, PARTY_CODE

ALTER TABLE #CNTNO_1
ADD SNO Int IDENTITY (1, 1) NOT NULL 

UPDATE #CNTNO_1 SET CONTRACTNO = RIGHT('0000000' + CONVERT(VARCHAR,SNO + CONVERT(INT,@CNTNO)),7)

UPDATE #CONF SET CONTRACTNO = C.CONTRACTNO
FROM #CNTNO_1 C
WHERE C.PARTY_CODE = #CONF.PARTY_CODE
AND C.SETT_NO = #CONF.SETT_NO
AND C.SETT_TYPE = #CONF.SETT_TYPE

SELECT @CNTNO = MAX(CONVERT(INT,CONTRACTNO)) FROM #CONF

UPDATE CONTGEN SET CONTRACTNO = @CNTNO
WHERE @SAUDA_DATE >= Start_Date and @SAUDA_DATE <= End_Date

INSERT INTO MFSS_SETTLEMENT
SELECT * FROM #CONF

TRUNCATE TABLE MFSS_TRADE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_DFDS_DELIVERY
-- --------------------------------------------------

CREATE PROC [dbo].[PROC_MFSS_DFDS_DELIVERY]
(
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2),
	@TRANSNO	VARCHAR(16)
)

AS

INSERT INTO DELTRANS
SELECT D.SETT_NO,D.SETT_TYPE,REFNO=110,TCODE=1,TRTYPE=904,D.PARTY_CODE,D.SCRIP_CD,D.SERIES,D.QTY,
FROMNO=TRANSNO,TONO=TRANSNO,CERTNO=D.ISIN,FOLIONO=TRANSNO,HOLDERNAME='PAYIN',REASON='PAYIN',
DRCR='C',DELIVERED='0',ORGQTY=D.QTY,DPTYPE=(CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END),
DPID=(CASE WHEN LEN(CLTDPID) = 16 THEN LEFT(CLTDPID,8) ELSE D.DPID END),CLTDPID,BRANCHCD='HO',PARTIPANTCODE,
SLIPNO='0',BATCHNO='',ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',
TRANSDATE=LEFT(SEC_PAYIN,11),FILLER1='DFDS',FILLER2=1,FILLER3='0',
BDPTYPE=DP.DPTYPE,BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''
FROM MFSS_DFDS D, DELIVERYDP DP, SETT_MST S, DELIVERYCLT C
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE
AND D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE
AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE
AND D.PARTY_CODE = C.PARTY_CODE
AND D.SCRIP_CD = C.SCRIP_CD
AND D.SERIES = C.SERIES
AND DP.DESCRIPTION LIKE '%POOL%'
AND INOUT = 'I'
AND DP.DPTYPE = (CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END)
AND TRANSNO = @TRANSNO


INSERT INTO DELTRANS
SELECT D.SETT_NO,D.SETT_TYPE,REFNO=110,TCODE=1,TRTYPE=906,PARTY_CODE='EXE',D.SCRIP_CD,D.SERIES,D.QTY,
FROMNO=TRANSNO,TONO=TRANSNO,CERTNO=D.ISIN,FOLIONO=TRANSNO,HOLDERNAME='PAYIN',REASON='PAYIN',
DRCR='D',DELIVERED='D',ORGQTY=D.QTY,DPTYPE=(CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END),
DPID=(CASE WHEN LEN(CLTDPID) = 16 THEN LEFT(CLTDPID,8) ELSE D.DPID END),CLTDPID,BRANCHCD='HO',PARTIPANTCODE,
SLIPNO='0',BATCHNO='',ISETT_NO='',ISETT_TYPE='',SHARETYPE='DEMAT',
TRANSDATE=LEFT(SEC_PAYIN,11),FILLER1='DFDS',FILLER2=1,FILLER3='0',
BDPTYPE=DP.DPTYPE,BDPID=DP.DPID,BCLTDPID=DP.DPCLTNO,FILLER4='',FILLER5=''
FROM MFSS_DFDS D, DELIVERYDP DP, SETT_MST S, DELIVERYCLT C
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE
AND D.SETT_NO = S.SETT_NO AND D.SETT_TYPE = S.SETT_TYPE
AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE
AND D.PARTY_CODE = C.PARTY_CODE
AND D.SCRIP_CD = C.SCRIP_CD
AND D.SERIES = C.SERIES
AND DP.DESCRIPTION LIKE '%POOL%'
AND INOUT = 'I'
AND DP.DPTYPE = (CASE WHEN D.DPID LIKE 'IN%' THEN 'NSDL' ELSE 'CDSL' END)
AND TRANSNO = @TRANSNO

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_DPMASTER
-- --------------------------------------------------

CREATE PROC PROC_MFSS_DPMASTER
(
	@Party_Code		VARCHAR(10),
	@DP_TYPE		VARCHAR(4),
	@DPID			VARCHAR(8),
	@CLTDPID		VARCHAR(16)
)

AS

	DELETE FROM MFSS_DPMASTER 
	WHERE PARTY_CODE = @Party_Code
	AND DP_TYPE = @DP_TYPE
	AND DPID = @DPID
	AND CLTDPID = @CLTDPID
	AND DEFAULTDP = 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_FUNDS_OBL_CALC
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_FUNDS_OBL_CALC]
(
	@TRADE_DATE VARCHAR(11)
)

AS
/*
	PROC_MFSS_FUNDS_OBL_CALC 'DEC  5 2009'
	
*/
DECLARE
		@SNO		NUMERIC(18,0), 
		@PARTY_CODE	VARCHAR(10), 
		@AMOUNT		NUMERIC(18, 4),
		@LEDCUR		CURSOR,
		@SDTCUR		DATETIME

SELECT @SDTCUR = SDTCUR FROM BBO_FA.dbo.PARAMETER WHERE @TRADE_DATE BETWEEN SDTCUR AND LDTCUR

CREATE TABLE #CLCODES
(
	CLTCODE VARCHAR(10),
	CL_BALANCE VARCHAR(1)
)
/*---------GETTING CLIENT MASTER SETTIING FOR BALANCE TYPE------------------------*/
INSERT INTO #CLCODES
	(CLTCODE, CL_BALANCE)
SELECT
	M.PARTY_CODE,
	CL_BALANCE = CASE WHEN M.CL_BALANCE <> 'E' THEN 'V' ELSE 'E' END
FROM
	MFSS_CLIENT M
WHERE
	EXISTS (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION O 
			WHERE O.ORDER_DATE LIKE @TRADE_DATE + '%' AND M.PARTY_CODE = O.PARTY_CODE)
------------------------------------------------------------------------------------
CREATE TABLE #LEDBAL
(
	CLTCODE VARCHAR(10),
	BALAMT NUMERIC(18, 4)
)
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/
INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	L.CLTCODE,
	BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
FROM
	BBO_FA.dbo.ACC_LEDGER_PL L,
	#CLCODES C
WHERE
	L.EXCHANGE = 'NSE'
	AND L.SEGMENT = 'MFSS'
	AND L.CLTCODE = C.CLTCODE
	AND C.CL_BALANCE = 'V'
	AND L.VDT >= @SDTCUR AND L.VDT < @TRADE_DATE
GROUP BY
	L.CLTCODE

INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	L.CLTCODE,
	BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
FROM
	BBO_FA.dbo.ACC_LEDGER_PL L,
	#CLCODES C
WHERE
	L.EXCHANGE = 'NSE'
	AND L.SEGMENT = 'MFSS'
	AND L.CLTCODE = C.CLTCODE
	AND C.CL_BALANCE = 'V'
	AND L.VDT >= @TRADE_DATE AND L.VDT <= @TRADE_DATE + ' 23:59:59'
	AND L.VTYPE <> 15
GROUP BY
	L.CLTCODE

-------------------------------------------------------------------------------------
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/

INSERT INTO #LEDBAL (CLTCODE, BALAMT)
SELECT
	CLTCODE,
	BALAMT = SUM(BALAMT)
FROM
	(
	SELECT
		L.CLTCODE,
		BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)
	FROM
		BBO_FA.dbo.ACC_LEDGER_PL L,
		#CLCODES C
	WHERE
		L.EXCHANGE = 'NSE'
		AND L.SEGMENT = 'MFSS'
		AND L.CLTCODE = C.CLTCODE
		AND C.CL_BALANCE = 'E'
		AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @TRADE_DATE + ' 23:59'
	GROUP BY
		L.CLTCODE
	UNION ALL
	SELECT
		L.CLTCODE,
		BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)
	FROM
		BBO_FA.dbo.ACC_LEDGER_PL L,
		#CLCODES C
	WHERE
		L.EXCHANGE = 'NSE'
		AND L.SEGMENT = 'MFSS'
		AND L.CLTCODE = C.CLTCODE
		AND C.CL_BALANCE = 'E'
		AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)
		AND L.VDT < @SDTCUR
	GROUP BY
		L.CLTCODE
	) A
GROUP BY
	CLTCODE
--------------------------OLD CODE----------------------------------
--SELECT CLTCODE, BALAMT = SUM(CRAMOUNT-DRAMOUNT)
--INTO #LEDBAL 
--FROM BBO_FA.DBO.ACC_LEDGER_PL
--WHERE EXCHANGE = 'NSE' AND SEGMENT = 'MFSS'
--AND EDT <= @TRADE_DATE + ' 23:59:59'
--AND @TRADE_DATE BETWEEN LDTCUR AND SDTCUR
--AND CLTCODE IN (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION
--				WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59')
--GROUP BY CLTCODE

SET @LEDCUR = CURSOR FOR
SELECT SNO, PARTY_CODE, AMOUNT FROM MFSS_FUNDS_OBLIGATION
WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59'
ORDER BY SNO
OPEN @LEDCUR
FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE MFSS_FUNDS_OBLIGATION SET AVAIL_AMOUNT = BALAMT
	FROM #LEDBAL
	WHERE SNO = @SNO
	AND CLTCODE = PARTY_CODE

	UPDATE #LEDBAL SET BALAMT = (CASE WHEN @AMOUNT > BALAMT THEN 0 ELSE BALAMT - @AMOUNT END)
	WHERE CLTCODE = @PARTY_CODE

	FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT
END
CLOSE @LEDCUR
DEALLOCATE @LEDCUR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_FUNDS_OBL_CALC_bak
-- --------------------------------------------------
CREATE PROC [dbo].[PROC_MFSS_FUNDS_OBL_CALC_bak]  
(  
 @TRADE_DATE VARCHAR(11)  
)  
  
AS  
/*  
 PROC_MFSS_FUNDS_OBL_CALC 'DEC  5 2009'  
   
*/  
DECLARE  
  @SNO  NUMERIC(18,0),   
  @PARTY_CODE VARCHAR(10),   
  @AMOUNT  NUMERIC(18, 4),  
  @LEDCUR  CURSOR,  
  @SDTCUR  DATETIME  
  
SELECT @SDTCUR = SDTCUR FROM BBO_FA.dbo.PARAMETER WHERE @TRADE_DATE BETWEEN SDTCUR AND LDTCUR  
  
CREATE TABLE #CLCODES  
(  
 CLTCODE VARCHAR(10),  
 CL_BALANCE VARCHAR(1)  
)  
/*---------GETTING CLIENT MASTER SETTIING FOR BALANCE TYPE------------------------*/  
INSERT INTO #CLCODES  
 (CLTCODE, CL_BALANCE)  
SELECT  
 M.PARTY_CODE,  
 CL_BALANCE = CASE WHEN M.CL_BALANCE <> 'E' THEN 'V' ELSE 'E' END  
FROM  
 MFSS_CLIENT M  
WHERE  
 EXISTS (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION O WHERE O.ORDER_DATE LIKE @TRADE_DATE + '%' AND M.PARTY_CODE = O.PARTY_CODE)  
------------------------------------------------------------------------------------  
CREATE TABLE #LEDBAL  
(  
 CLTCODE VARCHAR(10),  
 BALAMT NUMERIC(18, 4)  
)  
/*---------------------CALCULATING BALANCE VOUCHER DATE WISE------------------------*/  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 L.CLTCODE,  
 BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
FROM  
 BBO_FA.dbo.ACC_LEDGER_PL L,  
 #CLCODES C  
WHERE  
 L.EXCHANGE = 'NSE'  
 AND L.SEGMENT = 'MFSS'  
 AND L.CLTCODE = C.CLTCODE  
 AND C.CL_BALANCE = 'V'  
 AND L.VDT BETWEEN @SDTCUR AND @TRADE_DATE + ' 23:59'  
GROUP BY  
 L.CLTCODE  
-------------------------------------------------------------------------------------  
/*---------------------CALCULATING BALANCE EFFECTIVE DATE WISE------------------------*/  
  
INSERT INTO #LEDBAL (CLTCODE, BALAMT)  
SELECT  
 CLTCODE,  
 BALAMT = SUM(BALAMT)  
FROM  
 (  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.CRAMOUNT-L.DRAMOUNT)  
 FROM  
  BBO_FA.dbo.ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT BETWEEN CONVERT(VARCHAR(11), @SDTCUR, 109) AND @TRADE_DATE + ' 23:59'  
 GROUP BY  
  L.CLTCODE  
 UNION ALL  
 SELECT  
  L.CLTCODE,  
  BALAMT = SUM(L.DRAMOUNT-L.CRAMOUNT)  
 FROM  
  BBO_FA.dbo.ACC_LEDGER_PL L,  
  #CLCODES C  
 WHERE  
  L.EXCHANGE = 'NSE'  
  AND L.SEGMENT = 'MFSS'  
  AND L.CLTCODE = C.CLTCODE  
  AND C.CL_BALANCE = 'E'  
  AND L.EDT >= CONVERT(VARCHAR(11), @SDTCUR, 109)  
  AND L.VDT < @SDTCUR  
 GROUP BY  
  L.CLTCODE  
 ) A  
GROUP BY  
 CLTCODE  
--------------------------OLD CODE----------------------------------  
--SELECT CLTCODE, BALAMT = SUM(CRAMOUNT-DRAMOUNT)  
--INTO #LEDBAL   
--FROM BBO_FA.DBO.ACC_LEDGER_PL  
--WHERE EXCHANGE = 'NSE' AND SEGMENT = 'MFSS'  
--AND EDT <= @TRADE_DATE + ' 23:59:59'  
--AND @TRADE_DATE BETWEEN LDTCUR AND SDTCUR  
--AND CLTCODE IN (SELECT PARTY_CODE FROM MFSS_FUNDS_OBLIGATION  
--    WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59')  
--GROUP BY CLTCODE  
  
SET @LEDCUR = CURSOR FOR  
SELECT SNO, PARTY_CODE, AMOUNT FROM MFSS_FUNDS_OBLIGATION  
WHERE ORDER_DATE = @TRADE_DATE + ' 23:59:59'  
ORDER BY SNO  
OPEN @LEDCUR  
FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT  
WHILE @@FETCH_STATUS = 0  
BEGIN  
 UPDATE MFSS_FUNDS_OBLIGATION SET AVAIL_AMOUNT = BALAMT  
 FROM #LEDBAL  
 WHERE SNO = @SNO  
 AND CLTCODE = PARTY_CODE  
  
 UPDATE #LEDBAL SET BALAMT = (CASE WHEN @AMOUNT > BALAMT THEN 0 ELSE BALAMT - @AMOUNT END)  
 WHERE CLTCODE = @PARTY_CODE  
  
 FETCH NEXT FROM @LEDCUR INTO @SNO, @PARTY_CODE, @AMOUNT  
END  
CLOSE @LEDCUR  
DEALLOCATE @LEDCUR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_MISSINGSCRIP
-- --------------------------------------------------
CREATE PROC PROC_MFSS_MISSINGSCRIP AS      
SET NOCOUNT ON     
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
    
CREATE TABLE #MFSS_TRADE
(  
 SCRIP_CD VARCHAR (10),  
 SERIES VARCHAR(2)  
)  
  
INSERT INTO #MFSS_TRADE 
  SELECT   
 DISTINCT SCRIP_CD,  
                  SERIES  
  FROM   MFSS_TRADE (NOLOCK)  
  
SELECT * FROM #MFSS_TRADE MFSS_TRADE  
  WHERE  NOT EXISTS (SELECT SCRIP_CD  
                     FROM   MFSS_SCRIP_MASTER M
                     WHERE  MFSS_TRADE.SCRIP_CD = M.SCRIP_CD  
						AND MFSS_TRADE.SERIES = M.SERIES)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_STATUS_UPDATE
-- --------------------------------------------------

CREATE PROC [dbo].[PROC_MFSS_STATUS_UPDATE]
(
	@FLAG INT
)
AS

IF @FLAG = 1 
BEGIN
	UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED, 
						  QTY_ALLOTED = M.QTY_ALLOTED, 
						  AMOUNT_ALLOTED = M.AMOUNT_ALLOTED,
						  FOLIONO = M.FOLIONO
	FROM MFSS_ORDER_ALLOT_CONF M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END), 
						  AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)
	FROM MFSS_ORDER_ALLOT_CONF M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES

END

IF @FLAG = 2 
BEGIN
	UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON
	FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	INSERT INTO MFSS_SETTLEMENT_DELETED
	SELECT * FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)

	DELETE FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)
END

IF @FLAG = 3 
BEGIN
	UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED, 
						  QTY_ALLOTED = M.QTY_ALLOTED, 
						  AMOUNT_ALLOTED = M.AMOUNT_ALLOTED
	FROM MFSS_ORDER_REDEM_CONF M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END), 
						  AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)
	FROM MFSS_ORDER_REDEM_CONF M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES

END

IF @FLAG = 4 
BEGIN
	UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON
	FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	INSERT INTO MFSS_SETTLEMENT_DELETED
	SELECT * FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)

	DELETE FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_STATUS_UPDATE_BKUP_28JUL20
-- --------------------------------------------------


CREATE PROC [dbo].[PROC_MFSS_STATUS_UPDATE_BKUP_28JUL20]
(
	@FLAG INT
)
AS

IF @FLAG = 1 
BEGIN
	UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED, 
						  QTY_ALLOTED = M.QTY_ALLOTED, 
						  AMOUNT_ALLOTED = M.AMOUNT_ALLOTED,
						  FOLIONO = M.FOLIONO
	FROM MFSS_ORDER_ALLOT_CONF M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END), 
						  AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)
	FROM MFSS_ORDER_ALLOT_CONF M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES

END

IF @FLAG = 2 
BEGIN
	UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON
	FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	INSERT INTO MFSS_SETTLEMENT_DELETED
	SELECT * FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)

	DELETE FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_ALLOT_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)
END

IF @FLAG = 3 
BEGIN
	UPDATE MFSS_ORDER SET NAV_VALUE_ALLOTED = M.NAV_VALUE_ALLOTED, 
						  QTY_ALLOTED = M.QTY_ALLOTED, 
						  AMOUNT_ALLOTED = M.AMOUNT_ALLOTED
	FROM MFSS_ORDER_REDEM_CONF M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	UPDATE MFSS_SETTLEMENT SET QTY = (CASE WHEN MFSS_SETTLEMENT.QTY = 0 THEN M.QTY_ALLOTED ELSE MFSS_SETTLEMENT.QTY END), 
						  AMOUNT = (CASE WHEN MFSS_SETTLEMENT.AMOUNT = 0 THEN M.AMOUNT_ALLOTED ELSE MFSS_SETTLEMENT.AMOUNT END)
	FROM MFSS_ORDER_REDEM_CONF M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES

END

IF @FLAG = 4 
BEGIN
	UPDATE MFSS_ORDER SET CONF_FLAG = 'N', REJECT_REASON = M.REJECT_REASON
	FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_ORDER.ORDER_DATE
	AND M.ORDER_NO = MFSS_ORDER.ORDER_NO
	AND M.SCRIP_CD = MFSS_ORDER.SCRIP_CD
	AND M.SERIES = MFSS_ORDER.SERIES

	INSERT INTO MFSS_SETTLEMENT_DELETED
	SELECT * FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)

	DELETE FROM MFSS_SETTLEMENT
	WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER_REDEM_REJ M
	WHERE M.ORDER_DATE = MFSS_SETTLEMENT.ORDER_DATE
	AND M.ORDER_NO = MFSS_SETTLEMENT.ORDER_NO
	AND M.SCRIP_CD = MFSS_SETTLEMENT.SCRIP_CD
	AND M.SERIES = MFSS_SETTLEMENT.SERIES)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN
-- --------------------------------------------------

 --EXEC PROC_MFSS_VALAN '2014048','S'
CREATE PROC [dbo].[PROC_MFSS_VALAN]            
(            
 @SETT_NO   VARCHAR(7),            
    @SETT_TYPE VARCHAR(2)            
)            
AS            
        
          
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST           
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
 AND START_DATE <= 'DEC 23 2010 23:59') > 0           
BEGIN          
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE          
 RETURN          
END            
            
        
 UPDATE MFSS_SETTLEMENT            
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'            
      THEN M.BUY_BROK_TABLE_NO            
      ELSE M.SELL_BROK_TABLE_NO            
       END)            
 FROM MFSS_BROKERAGE_MASTER M            
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE            
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                   
            
UPDATE MFSS_SETTLEMENT SET             
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),            
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100            
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G            
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE               
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1             
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM            
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'            
            
DELETE FROM ACCBILL          
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
          
/*  
UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0   
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER O, TBL_MFFS_DPAYIN P  
       WHERE ORDER_DATE BETWEEN FROMDATE AND TODATE  
       AND O.SCHEME_CATEGORY = P.SCHEME_CATEGORY  
       AND SUB_RED_FLAG = 'P' AND O.AMOUNT >= AMT_CUT_OFF)   
*/        
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),           
BRANCHCD = BRANCH_CD,          
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)  + ISNULL(BROKER_CHRG,0)          
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)  + ISNULL(BROKER_CHRG,0)         
       END),2),          
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)          
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)          
       END),          
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN BROKERAGE           
      ELSE BROKERAGE          
       END),          
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN SERVICE_TAX          
      ELSE SERVICE_TAX        
       END),  
STAMP_DUTY =  SUM(ISNULL(BROKER_CHRG,0)),SUB_RED_FLAG, CATEGORYCODE,  
SEC_PAY = ORDER_DATE          
INTO #VALAN           
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M           
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE          
AND S.PARTY_CODE = C.PARTY_CODE          
AND M.SCRIP_CD = S.SCRIP_CD  
AND M.SERIES = S.SERIES  
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE,ORDER_DATE, BRANCH_CD,SUB_RED_FLAG, CATEGORYCODE 


       
  
UPDATE #VALAN SET SEC_PAY = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, ORDER_DATE)   
FROM MFSS_CATEGORY C  
WHERE #VALAN.CATEGORYCODE = C.CATEGORYCODE  
AND ORDER_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SUB_RED_FLAG = 'R'  


          
INSERT INTO ACCBILL          
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),          
BRANCHCD,NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD,NARRATION = CATEGORYCODE    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG, CATEGORYCODE         

INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD,NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE 
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD,NARRATION = CATEGORYCODE          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE          
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD,NARRATION=CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE  
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,           
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX,CATEGORYCODE  
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD,NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,SUB_RED_FLAG,CATEGORYCODE          
          
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CATEGORYCODE 

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE         
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE          
          
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX,CATEGORYCODE           
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0             
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD,NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO          
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND BRANCHCD <> 'ZZZ'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD,NARRATION          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD='ZZZ',NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO         
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,NARRATION   
/*  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 2  
AND PARTY_CODE NOT IN (SELECT ACCODE FROM VALANACCOUNT)  
  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 1  
AND PARTY_CODE IN (SELECT ACCODE FROM VALANACCOUNT)  
*/  
UPDATE ACCBILL SET NARRATION = 'MFSS BILL POSTED-' + NARRATION  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_01072022
-- --------------------------------------------------

 --EXEC PROC_MFSS_VALAN '2014048','S'
create PROC [dbo].[PROC_MFSS_VALAN_01072022]            
(            
 @SETT_NO   VARCHAR(7),            
    @SETT_TYPE VARCHAR(2)            
)            
AS            
        
          
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST           
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
 AND START_DATE <= 'DEC 23 2010 23:59') > 0           
BEGIN          
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE          
 RETURN          
END            
            
        
 UPDATE MFSS_SETTLEMENT            
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'            
      THEN M.BUY_BROK_TABLE_NO            
      ELSE M.SELL_BROK_TABLE_NO            
       END)            
 FROM MFSS_BROKERAGE_MASTER M            
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE            
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                   
            
UPDATE MFSS_SETTLEMENT SET             
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),            
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100            
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G            
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE               
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1             
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM            
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'            
            
DELETE FROM ACCBILL          
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
          
/*  
UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0   
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER O, TBL_MFFS_DPAYIN P  
       WHERE ORDER_DATE BETWEEN FROMDATE AND TODATE  
       AND O.SCHEME_CATEGORY = P.SCHEME_CATEGORY  
       AND SUB_RED_FLAG = 'P' AND O.AMOUNT >= AMT_CUT_OFF)   
*/        
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),           
BRANCHCD = BRANCH_CD,          
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)  + ISNULL(BROKER_CHRG,0)          
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)  + ISNULL(BROKER_CHRG,0)         
       END),2),          
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)          
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)          
       END),          
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN BROKERAGE           
      ELSE BROKERAGE          
       END),          
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN SERVICE_TAX          
      ELSE SERVICE_TAX        
       END),  
STAMP_DUTY =  SUM(ISNULL(BROKER_CHRG,0)),SUB_RED_FLAG, CATEGORYCODE,  
SEC_PAY = ORDER_DATE          
INTO #VALAN           
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M           
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE          
AND S.PARTY_CODE = C.PARTY_CODE          
AND M.SCRIP_CD = S.SCRIP_CD  
AND M.SERIES = S.SERIES  
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE,ORDER_DATE, BRANCH_CD,SUB_RED_FLAG, CATEGORYCODE 


       
  
UPDATE #VALAN SET SEC_PAY = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, ORDER_DATE)   
FROM MFSS_CATEGORY C  
WHERE #VALAN.CATEGORYCODE = C.CATEGORYCODE  
AND ORDER_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SUB_RED_FLAG = 'R'  


          
INSERT INTO ACCBILL          
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),          
BRANCHCD,NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD,NARRATION = CATEGORYCODE    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG, CATEGORYCODE         

INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD,NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE 
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD,NARRATION = CATEGORYCODE          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE          
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD,NARRATION=CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE  
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,           
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX,CATEGORYCODE  
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD,NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,SUB_RED_FLAG,CATEGORYCODE          
          
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(STAMP_DUTY),2),        
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'STAMP DUTY'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CATEGORYCODE 

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE         
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE          
          
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX,CATEGORYCODE           
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0             
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD,NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO          
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND BRANCHCD <> 'ZZZ'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD,NARRATION          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD='ZZZ',NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO         
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,NARRATION   
/*  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 2  
AND PARTY_CODE NOT IN (SELECT ACCODE FROM VALANACCOUNT)  
  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 1  
AND PARTY_CODE IN (SELECT ACCODE FROM VALANACCOUNT)  
*/  
UPDATE ACCBILL SET NARRATION = 'MFSS BILL POSTED-' + NARRATION  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_12032014
-- --------------------------------------------------
  
CREATE PROC [dbo].[PROC_MFSS_VALAN_12032014]            
(            
 @SETT_NO   VARCHAR(7),            
    @SETT_TYPE VARCHAR(2)            
)            
AS            
        
          
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST           
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
 AND START_DATE <= 'DEC 23 2010 23:59') > 0           
BEGIN          
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE          
 RETURN          
END            
            
        
 UPDATE MFSS_SETTLEMENT            
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'            
      THEN M.BUY_BROK_TABLE_NO            
      ELSE M.SELL_BROK_TABLE_NO            
       END)            
 FROM MFSS_BROKERAGE_MASTER M            
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE            
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                   
            
UPDATE MFSS_SETTLEMENT SET             
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),            
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100            
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G            
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE               
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1             
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM            
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'            
            
DELETE FROM ACCBILL          
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
          
/*  
UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0   
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER O, TBL_MFFS_DPAYIN P  
       WHERE ORDER_DATE BETWEEN FROMDATE AND TODATE  
       AND O.SCHEME_CATEGORY = P.SCHEME_CATEGORY  
       AND SUB_RED_FLAG = 'P' AND O.AMOUNT >= AMT_CUT_OFF)   
*/        
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),           
BRANCHCD = BRANCH_CD,          
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)           
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)          
       END),2),          
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)          
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)          
       END),          
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN BROKERAGE           
      ELSE BROKERAGE          
       END),          
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN SERVICE_TAX          
      ELSE SERVICE_TAX        
       END), SUB_RED_FLAG, CATEGORYCODE,  
SEC_PAY = ORDER_DATE          
INTO #VALAN           
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M           
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE          
AND S.PARTY_CODE = C.PARTY_CODE          
AND M.SCRIP_CD = S.SCRIP_CD  
AND M.SERIES = S.SERIES  
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE,ORDER_DATE, BRANCH_CD,SUB_RED_FLAG, CATEGORYCODE          
  
UPDATE #VALAN SET SEC_PAY = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, ORDER_DATE)   
FROM MFSS_CATEGORY C  
WHERE #VALAN.CATEGORYCODE = C.CATEGORYCODE  
AND ORDER_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SUB_RED_FLAG = 'R'  
          
INSERT INTO ACCBILL          
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),          
BRANCHCD,NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD,NARRATION = CATEGORYCODE    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG, CATEGORYCODE         
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD,NARRATION = CATEGORYCODE          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE          
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD,NARRATION=CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE  
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,           
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX,CATEGORYCODE  
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD,NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,SUB_RED_FLAG,CATEGORYCODE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE         
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE          
          
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX,CATEGORYCODE           
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0             
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD,NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO          
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND BRANCHCD <> 'ZZZ'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD,NARRATION          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD='ZZZ',NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO         
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,NARRATION   
/*  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 2  
AND PARTY_CODE NOT IN (SELECT ACCODE FROM VALANACCOUNT)  
  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 1  
AND PARTY_CODE IN (SELECT ACCODE FROM VALANACCOUNT)  
*/  
UPDATE ACCBILL SET NARRATION = 'MFSS BILL POSTED-' + NARRATION  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_BAK
-- --------------------------------------------------

CREATE PROC [dbo].[PROC_MFSS_VALAN_BAK]          
(          
 @SETT_NO   VARCHAR(7),          
    @SETT_TYPE VARCHAR(2)          
)          
AS          
      
        
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST         
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE        
 AND START_DATE <= 'DEC 23 2010 23:59') > 0         
BEGIN        
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE        
 RETURN        
END          
          
      
 UPDATE MFSS_SETTLEMENT          
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'          
      THEN M.BUY_BROK_TABLE_NO          
      ELSE M.SELL_BROK_TABLE_NO          
       END)          
 FROM MFSS_BROKERAGE_MASTER M          
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO          
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE          
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE          
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                 
          
UPDATE MFSS_SETTLEMENT SET           
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),          
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100          
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G          
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO          
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE          
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE             
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1           
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT            
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM          
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'          
          
DELETE FROM ACCBILL        
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE        
        
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),         
BRANCHCD = BRANCH_CD,        
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)         
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)        
       END),2),        
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)        
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)        
       END),        
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN BROKERAGE         
      ELSE BROKERAGE        
       END),        
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'         
      THEN SERVICE_TAX        
      ELSE SERVICE_TAX      
       END), SUB_RED_FLAG        
INTO #VALAN         
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S         
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE        
AND S.PARTY_CODE = C.PARTY_CODE        
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, LEFT(S.ORDER_DATE, 11), BRANCH_CD,SUB_RED_FLAG        
        
INSERT INTO ACCBILL        
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),        
BRANCHCD,NARRATION = 'MFSS BILL POSTED'        
FROM #VALAN S, SETT_MST M        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),        
BRANCHCD,NARRATION = 'MFSS BILL POSTED'        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'CLEARING HOUSE'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),        
BRANCHCD,NARRATION = 'MFSS BILL POSTED'        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'BROKERAGE REALISED'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD        
        

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX = 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD          

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,         
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),          
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX     
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),    
BRANCHCD,NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'EDU CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX     
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),        
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'CLEARING HOUSE'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,SUB_RED_FLAG        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),        
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'        
FROM #VALAN S, SETT_MST M, VALANACCOUNT V        
WHERE S.SETT_NO = M.SETT_NO        
AND S.SETT_TYPE = M.SETT_TYPE        
AND V.ACNAME = 'BROKERAGE REALISED'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT        
        
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX = 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT          

INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'SERVICE TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX         
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),          
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX     
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0    
    
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,    
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),    
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G        
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'EDU CESS TAX'    
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT      
AND CESS_TAX+EDUCESSTAX > 0    
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX     
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0           
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',        
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE,PAYOUT_DATE,        
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),        
BRANCHCD,NARRATION = 'MFSS BILL POSTED'        
FROM ACCBILL S, VALANACCOUNT V        
WHERE S.SETT_NO = @SETT_NO        
AND S.SETT_TYPE = @SETT_TYPE        
AND V.ACNAME = 'ROUNDING OFF'        
AND BRANCHCD <> 'ZZZ'        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD        
        
INSERT INTO ACCBILL        
SELECT ACCODE,BILL_NO='0',        
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),        
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,        
PAYIN_DATE,PAYOUT_DATE,        
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),        
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'        
FROM ACCBILL S, VALANACCOUNT V        
WHERE S.SETT_NO = @SETT_NO       
AND S.SETT_TYPE = @SETT_TYPE        
AND V.ACNAME = 'ROUNDING OFF'        
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_BKUP_28JUL20
-- --------------------------------------------------
 --EXEC PROC_MFSS_VALAN '2014048','S'
CREATE PROC [dbo].[PROC_MFSS_VALAN_BKUP_28JUL20]            
(            
 @SETT_NO   VARCHAR(7),            
    @SETT_TYPE VARCHAR(2)            
)            
AS            
        
          
IF (SELECT ISNULL(COUNT(1),0) FROM SETT_MST           
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
 AND START_DATE <= 'DEC 23 2010 23:59') > 0           
BEGIN          
 EXEC PROC_MFSS_VALAN_OLD @SETT_NO, @SETT_TYPE          
 RETURN          
END            
            
        
 UPDATE MFSS_SETTLEMENT            
 SET FILLER1 = (CASE WHEN MFSS_SETTLEMENT.SUB_RED_FLAG = 'P'            
      THEN M.BUY_BROK_TABLE_NO            
      ELSE M.SELL_BROK_TABLE_NO            
       END)            
 FROM MFSS_BROKERAGE_MASTER M            
 WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
 AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
 AND M.PARTY_CODE = MFSS_SETTLEMENT.PARTY_CODE            
 AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE                   
            
UPDATE MFSS_SETTLEMENT SET             
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),            
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100            
FROM MFSS_CLIENT C, BROKTABLE B, GLOBALS G            
WHERE MFSS_SETTLEMENT.SETT_NO = @SETT_NO            
AND MFSS_SETTLEMENT.SETT_TYPE = @SETT_TYPE            
AND MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE               
AND B.TABLE_NO = MFSS_SETTLEMENT.FILLER1             
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT              
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM            
--AND MFSS_SETTLEMENT.SUB_RED_FLAG <> 'P'            
            
DELETE FROM ACCBILL          
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE          
          
/*  
UPDATE #MFSS_SETTLEMENT_TEMP SET AMOUNT = 0   
WHERE ORDER_NO IN (SELECT ORDER_NO FROM MFSS_ORDER O, TBL_MFFS_DPAYIN P  
       WHERE ORDER_DATE BETWEEN FROMDATE AND TODATE  
       AND O.SCHEME_CATEGORY = P.SCHEME_CATEGORY  
       AND SUB_RED_FLAG = 'P' AND O.AMOUNT >= AMT_CUT_OFF)   
*/        
SELECT S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(S.ORDER_DATE, 11),           
BRANCHCD = BRANCH_CD,          
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)           
      ELSE - S.AMOUNT + BROKERAGE + SERVICE_TAX + ISNULL(INS_CHRG,0)          
       END),2),          
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN   S.AMOUNT + ISNULL(INS_CHRG,0)          
      ELSE - S.AMOUNT + ISNULL(INS_CHRG,0)          
       END),          
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN BROKERAGE           
      ELSE BROKERAGE          
       END),          
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'           
      THEN SERVICE_TAX          
      ELSE SERVICE_TAX        
       END), SUB_RED_FLAG, CATEGORYCODE,  
SEC_PAY = ORDER_DATE          
INTO #VALAN           
FROM MFSS_CLIENT C, MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M           
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE          
AND S.PARTY_CODE = C.PARTY_CODE          
AND M.SCRIP_CD = S.SCRIP_CD  
AND M.SERIES = S.SERIES  
GROUP BY S.SETT_NO, S.SETT_TYPE, S.PARTY_CODE,ORDER_DATE, BRANCH_CD,SUB_RED_FLAG, CATEGORYCODE 


       
  
UPDATE #VALAN SET SEC_PAY = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, ORDER_DATE)   
FROM MFSS_CATEGORY C  
WHERE #VALAN.CATEGORYCODE = C.CATEGORYCODE  
AND ORDER_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SUB_RED_FLAG = 'R'  


          
INSERT INTO ACCBILL          
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=(CASE WHEN PARTY_AMOUNT > 0 THEN 1 ELSE 2 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(PARTY_AMOUNT),          
BRANCHCD,NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD,NARRATION = CATEGORYCODE    
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,SUB_RED_FLAG, CATEGORYCODE         
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD,NARRATION = CATEGORYCODE          
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE          
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD,NARRATION=CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CATEGORYCODE  
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2) ,           
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,CESS_TAX,EDUCESSTAX,CATEGORYCODE  
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD,NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD,NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,BRANCHCD,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=(CASE WHEN ROUND(SUM(EXCHG_AMOUNT),2) >= 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ABS(ROUND(SUM(EXCHG_AMOUNT),2)),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'CLEARING HOUSE'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,SUB_RED_FLAG,CATEGORYCODE          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),          
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE         
FROM #VALAN S, SETT_MST M, VALANACCOUNT V          
WHERE S.SETT_NO = M.SETT_NO          
AND S.SETT_TYPE = M.SETT_TYPE          
AND V.ACNAME = 'BROKERAGE REALISED'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE          
          
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(SUM(S.SERVICE_TAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE       
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX = 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CATEGORYCODE            
  
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,  
AMOUNT=ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'SERVICE TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT  
AND CESS_TAX+EDUCESSTAX > 0        
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,CESS_TAX,EDUCESSTAX,CATEGORYCODE           
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),            
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE     
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE       
HAVING ROUND(CESS_TAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0      
      
INSERT INTO ACCBILL            
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,            
PAYIN_DATE=SEC_PAY,PAYOUT_DATE=FUNDS_PAYOUT,      
AMOUNT=ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2),      
BRANCHCD='ZZZ',NARRATION = CATEGORYCODE   
FROM #VALAN S, SETT_MST M, VALANACCOUNT V, GLOBALS G          
WHERE S.SETT_NO = M.SETT_NO            
AND S.SETT_TYPE = M.SETT_TYPE            
AND V.ACNAME = 'EDU CESS TAX'      
AND START_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT        
AND CESS_TAX+EDUCESSTAX > 0      
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,SEC_PAY,FUNDS_PAYOUT,EDUCESSTAX,CESS_TAX,CATEGORYCODE      
HAVING ROUND(EDUCESSTAX*(ROUND(SUM(S.SERVICE_TAX),2)-ROUND(ROUND(SUM(S.SERVICE_TAX),2)*100/(100+(CESS_TAX+EDUCESSTAX)),2))/(CESS_TAX+EDUCESSTAX),2) > 0             
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD,NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO          
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND BRANCHCD <> 'ZZZ'          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD,NARRATION          
          
INSERT INTO ACCBILL          
SELECT ACCODE,BILL_NO='0',          
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),          
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,          
PAYIN_DATE,PAYOUT_DATE,          
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),          
BRANCHCD='ZZZ',NARRATION -- = 'MFSS BILL POSTED'          
FROM ACCBILL S, VALANACCOUNT V          
WHERE S.SETT_NO = @SETT_NO         
AND S.SETT_TYPE = @SETT_TYPE          
AND V.ACNAME = 'ROUNDING OFF'          
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')          
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,NARRATION   
/*  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 2  
AND PARTY_CODE NOT IN (SELECT ACCODE FROM VALANACCOUNT)  
  
UPDATE ACCBILL SET PAYIN_DATE = .DBO.FUN_CATEGORY_PAYIN(SELL_PAYIN, START_DATE)   
FROM MFSS_CATEGORY C  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE     
AND CATEGORYCODE = NARRATION  
AND START_DATE BETWEEN FROM_DATE AND TO_DATE  
AND SELL_BUY = 1  
AND PARTY_CODE IN (SELECT ACCODE FROM VALANACCOUNT)  
*/  
UPDATE ACCBILL SET NARRATION = 'MFSS BILL POSTED-' + NARRATION  
WHERE SETT_NO = @SETT_NO         
AND SETT_TYPE = @SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PROC_MFSS_VALAN_OLD
-- --------------------------------------------------
--SELECT * FROM MFSS_SETTLEMENT  
CREATE PROC [dbo].[PROC_MFSS_VALAN_OLD]  
(  
 @SETT_NO   VARCHAR(7),  
    @SETT_TYPE VARCHAR(2)  
)  
AS  
  
UPDATE MFSS_SETTLEMENT SET   
BROKERAGE = (CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),  
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100  
FROM MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G  
WHERE MFSS_SETTLEMENT.PARTY_CODE = C.PARTY_CODE     
AND MFSS_SETTLEMENT.PARTY_CODE = M.PARTY_CODE    
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P'   
           THEN M.BUY_BROK_TABLE_NO   
        ELSE M.SELL_BROK_TABLE_NO   
      END)   
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE    
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT    
AND MFSS_SETTLEMENT.AMOUNT > B.LOWER_LIM AND MFSS_SETTLEMENT.AMOUNT <= B.UPPER_LIM   
  
DELETE FROM ACCBILL  
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
  
SELECT SETT_NO, SETT_TYPE, S.PARTY_CODE, ORDER_DATE=LEFT(ORDER_DATE, 11),   
BRANCHCD = BRANCH_CD,  
PARTY_AMOUNT = ROUND(SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN AMOUNT + BROKERAGE + SERVICE_TAX   
      ELSE BROKERAGE + SERVICE_TAX  
       END),2),  
EXCHG_AMOUNT = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN AMOUNT   
      ELSE 0  
       END),  
BROKERAGE    = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN BROKERAGE   
      ELSE BROKERAGE  
       END),  
SERVICE_TAX  = SUM(CASE WHEN SUB_RED_FLAG = 'P'   
      THEN SERVICE_TAX  
      ELSE SERVICE_TAX  
       END)  
INTO #VALAN   
FROM MFSS_SETTLEMENT S, MFSS_CLIENT C  
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE  
AND S.PARTY_CODE = C.PARTY_CODE  
GROUP BY SETT_NO, SETT_TYPE, S.PARTY_CODE, LEFT(ORDER_DATE, 11), BRANCH_CD  
  
INSERT INTO ACCBILL  
SELECT S.PARTY_CODE,BILL_NO='0',SELL_BUY=1,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=PARTY_AMOUNT,  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'CLEARING HOUSE'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'BROKERAGE REALISED'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'SERVICE TAX'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(EXCHG_AMOUNT),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'CLEARING HOUSE'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(BROKERAGE),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'BROKERAGE REALISED'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',SELL_BUY=2,S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE=FUNDS_PAYIN,PAYOUT_DATE=FUNDS_PAYOUT,AMOUNT=ROUND(SUM(SERVICE_TAX),2),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM #VALAN S, SETT_MST M, VALANACCOUNT V  
WHERE S.SETT_NO = M.SETT_NO  
AND S.SETT_TYPE = M.SETT_TYPE  
AND V.ACNAME = 'SERVICE TAX'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,FUNDS_PAYIN,FUNDS_PAYOUT  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',  
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),  
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE,PAYOUT_DATE,  
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),  
BRANCHCD,NARRATION = 'MFSS BILL POSTED'  
FROM ACCBILL S, VALANACCOUNT V  
WHERE S.SETT_NO = @SETT_NO  
AND S.SETT_TYPE = @SETT_TYPE  
AND V.ACNAME = 'ROUNDING OFF'  
AND BRANCHCD <> 'ZZZ'  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE,BRANCHCD  
  
INSERT INTO ACCBILL  
SELECT ACCODE,BILL_NO='0',  
SELL_BUY=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 2 ELSE 1 END),  
S.SETT_NO,S.SETT_TYPE,START_DATE,END_DATE,  
PAYIN_DATE,PAYOUT_DATE,  
AMOUNT=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),  
BRANCHCD='ZZZ',NARRATION = 'MFSS BILL POSTED'  
FROM ACCBILL S, VALANACCOUNT V  
WHERE S.SETT_NO = @SETT_NO  
AND S.SETT_TYPE = @SETT_TYPE  
AND V.ACNAME = 'ROUNDING OFF'  
AND ( PARTY_CODE IN (SELECT PARTY_CODE FROM MFSS_CLIENT) OR BRANCHCD = 'ZZZ')  
GROUP BY S.SETT_NO,S.SETT_TYPE,ACCODE,START_DATE,END_DATE,PAYIN_DATE,PAYOUT_DATE

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
-- PROCEDURE dbo.RPT_CLIENTLISTING
-- --------------------------------------------------
--RPT_CLIENTLISTING ,'','','','','','','broker','broker'

CREATE   PROC RPT_CLIENTLISTING
	(
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE ,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		BRANCH_CD,
		SUB_BROKER,
		TRADER,
		AREA,
		REGION,
		SBU,
		FAMILY,
		BANK_NAME,
		BANK_BRANCH,
		BANK_CITY,
		ACC_NO,
		DP_TYPE,
		DPID,
		CLTDPID
	FROM
		MFSS_CLIENT (NOLOCK)
	WHERE
		PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN FAMILY
			WHEN @STATUSID = 'AREA'
			THEN AREA
			WHEN @STATUSID = 'REGION'
			THEN REGION
			WHEN @STATUSID = 'CLIENT'
			THEN PARTY_CODE
			ELSE 'BROKER' 
		END)

	
	ORDER BY
		1,2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELBENPAYOUT_NRM_CLRATE
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_DELBENPAYOUT_NRM_CLRATE] (                  
@BDPTYPE VARCHAR(4), @BDPID VARCHAR(8), @BCLTDPID VARCHAR(16),                   
@FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),                  
@FROMSCRIP VARCHAR(20), @TOSCRIP VARCHAR(20),  
@ACNAME VARCHAR(100),                  
@CHKFLAG VARCHAR(20), @PAYFLAG INT, @SUMMARYFLAG INT,            
@CATEGORY VARCHAR(10), @BRANCHCODE VARCHAR(10))                  
AS                       
        
TRUNCATE TABLE DELACCBALANCE        
                  
IF @CHKFLAG <> 'THIRD PARTY' AND @PAYFLAG = 1                  
BEGIN                  
 EXEC INSDELACCCHECK                  
                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,' '),TRTYPE,                  
 D.DPTYPE,D.CLTDPID,D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),                  
 ISETT_NO=' ',ISETT_TYPE=' ',SETT_NO=' ',SETT_TYPE=' ',SERIESID=D.SERIES,CL_RATE = CONVERT(NUMERIC(18,4),0)                   
 INTO #DELPAYOUT                   
 FROM MFSS_DPMASTER M, MFSS_SCRIP_MASTER S, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A                   
  ON ( A.CLTCODE = D.PARTY_CODE )                   
 WHERE TRTYPE IN (904,905) AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID                   
 AND M.DP_TYPE = D.DPTYPE AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP     
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series              
 AND TRTYPE >= (CASE WHEN @CHKFLAG = 'BRANCH MARKING'                
        THEN 905                
        ELSE 904                
      END)            
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )                     
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,ISNULL(PARTY_NAME,' '),TRTYPE,D.CLTDPID,D.DPID,                  
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,D.DPTYPE                   
 ORDER BY D.DPTYPE,D.PARTY_CODE,S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUT SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUT.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUT.SCRIP_CD                                    
 AND #DELPAYOUT.CL_RATE = 0                  
                              
 SELECT * FROM #DELPAYOUT                   
                  
END                  
                  
IF @CHKFLAG = 'THIRD PARTY' AND @PAYFLAG = 1                  
BEGIN                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(C1.LONG_NAME,' '),TRTYPE,                  
 D.DPTYPE,D.CLTDPID,D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=0,                  
 ISETT_NO=' ',ISETT_TYPE=' ',SETT_NO=' ',SETT_TYPE=' ', SERIESID=D.SERIES,CL_RATE = CONVERT(NUMERIC(18,4),0)                   
 INTO #DELPAYOUTTHIRD                   
 FROM CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER S, DELTRANS D                   
 WHERE TRTYPE IN (904,905) AND D.PARTY_CODE = C2.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE                   
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP                  
 AND D.FILLER1 LIKE 'THIRD PARTY'            
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series   
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )                  
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,C1.LONG_NAME,TRTYPE,D.CLTDPID,D.DPID,                   
 CERTNO, BDPTYPE,BDPID,BCLTDPID,D.DPTYPE                   
 ORDER BY D.DPTYPE,D.PARTY_CODE,S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUTTHIRD SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUTTHIRD.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUTTHIRD.SCRIP_CD                                    
 AND #DELPAYOUTTHIRD.CL_RATE = 0                  
                  
 SELECT * FROM #DELPAYOUTTHIRD                   
                  
END                  
                  
IF @PAYFLAG = 0                  
BEGIN                  
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=' ',TRTYPE,DT.DPTYPE,CLTDPID=DPCLTNO,                  
 DT.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=0,ISETT_NO=' ',ISETT_TYPE=' ',                  
 SETT_NO=' ',SETT_TYPE=' ', SERIESID = D.SERIES, CL_RATE = CONVERT(NUMERIC(18,4),0),ACTPAYOUT=CONVERT(NUMERIC(18,3),SUM(QTY))                   
 INTO #DELPAYOUTBEN                  
 FROM DELTRANS D, MFSS_SCRIP_MASTER S, DELIVERYDP DT                   
 WHERE TRTYPE = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then 1002 Else 904 END)         
 AND DT.DESCRIPTION = @ACNAME                  
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @BDPTYPE AND BDPID = @BDPID                  
 AND BCLTDPID = @BCLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP    
 AND D.SCRIP_CD = S.SCRIP_CD and d.series = s.series           
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1             
    WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE             
    AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)            
    )        
 AND D.CLTDPID = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then DT.DpCltNo Else D.CLTDPID END)        
 AND D.DPID = (CASE WHEN @CHKFLAG = 'Ben To Coll' Then DT.DPID Else D.DPID END)        
 GROUP BY D.PARTY_CODE, S.SEC_NAME,D.SCRIP_CD,D.SERIES,TRTYPE,DPCLTNO,DT.DPID,CERTNO,BDPTYPE,BDPID,BCLTDPID,DT.DPTYPE                   
 ORDER BY D.PARTY_CODE, S.SEC_NAME,D.SCRIP_CD                  
                  
 UPDATE #DELPAYOUTBEN SET CL_RATE = C.NAV_VALUE FROM MFSS_NAV C WHERE                                     
 NAV_DATE = (SELECT MAX(NAV_DATE) FROM MFSS_NAV C1 WHERE C1.SCRIP_CD = #DELPAYOUTBEN.SCRIP_CD                                    
 AND NAV_DATE <= LEFT(GETDATE(),11) + ' 23:59' )                              
 AND C.SCRIP_CD = #DELPAYOUTBEN.SCRIP_CD                                    
 AND #DELPAYOUTBEN.CL_RATE = 0                 
              
 IF @SUMMARYFLAG = 0               
 BEGIN                  
  SELECT * FROM #DELPAYOUTBEN              
  ORDER BY PARTY_CODE, SERIES, SCRIP_CD,  CERTNO                 
    END              
 ELSE              
 BEGIN              
  SELECT SCRIP_CD, SERIES, PARTY_CODE = 'BEN', LONG_NAME, TRTYPE, DPTYPE, CLTDPID, DPID, CERTNO,               
  QTY=CONVERT(NUMERIC(18,3),SUM(QTY)), BDPTYPE, BDPID, BCLTDPID, AMOUNT = 0, ISETT_NO, ISETT_TYPE, SETT_NO, SETT_TYPE,              
  SERIESID, CL_RATE, ACTPAYOUT=SUM(ACTPAYOUT) FROM #DELPAYOUTBEN              
  GROUP BY SCRIP_CD, SERIES, LONG_NAME, TRTYPE, DPTYPE, CLTDPID, DPID, CERTNO, BDPTYPE, BDPID, BCLTDPID,               
  ISETT_NO, ISETT_TYPE, SETT_NO, SETT_TYPE, SERIESID, CL_RATE              
  ORDER BY SCRIP_CD, SERIES, CERTNO              
 END              
   
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELHOLDMATCH_NEW
-- --------------------------------------------------
    
CREATE PROC [dbo].[RPT_DELHOLDMATCH_NEW]               
( @CLTDPID VARCHAR(16),                
  @DPID VARCHAR(8) )                
AS               
CREATE TABLE #HOLDRECO            
(             
 ISIN VARCHAR(12),            
 SCRIP_NAME VARCHAR(250),            
 SETT_NO VARCHAR(7),            
 SETT_TYPE VARCHAR(2),            
 SCRIP_CD VARCHAR(50),            
 QTY NUMERIC(18,3),            
 FREEQTY NUMERIC(18,3),            
 PLEDGEQTY NUMERIC(18,3),            
 HOLDQTY NUMERIC(18,3),            
 HOLDFREEQTY NUMERIC(18,3),            
 HOLDPLEDGEQTY NUMERIC(18,3),            
 TODAYQTY NUMERIC(18,3)            
)             
SELECT SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,SERIES,CERTNO,QTY=SUM(QTY),TRANSDATE,DRCR,      
BDPTYPE,BDPID,BCLTDPID,FILLER2,DELIVERED, EXCHG = 'BSE'      
INTO #DEL FROM DELTRANS      
WHERE DRCR = 'D' AND FILLER2 = 1 AND BCLTDPID = @CLTDPID AND BDPID = @DPID        
AND SHARETYPE = 'DEMAT'       
GROUP BY SETT_NO,SETT_TYPE,TRTYPE,SCRIP_CD,SERIES,CERTNO,TRANSDATE,DRCR,BDPTYPE,BDPID,BCLTDPID,FILLER2, DELIVERED      
    
IF (SELECT ISNULL(COUNT(*),0) FROM DELIVERYDP WHERE DPID = @DPID AND DPCLTNO = @CLTDPID AND DESCRIPTION LIKE '%POOL%' AND DPTYPE = 'NSDL') > 0                 
BEGIN      
INSERT INTO #HOLDRECO               
SELECT ISIN=ISNULL(CERTNO,A.ISIN),SCRIP_NAME=S2.SEC_NAME, D.SETT_NO , D.SETT_TYPE, SCRIP_CD=S2.SCRIP_CD ,                
QTY=SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)),                
FREEQTY=SUM(CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ,                
PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),                
/*TODAYQTY=SUM(CASE WHEN CONVERT(VARCHAR,TRANSDATE,106) = CONVERT(VARCHAR,GETDATE(),106) AND DELIVERED = 'G' THEN QTY ELSE 0 END) */                
TODAYQTY=SUM(CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR,TRANSDATE,106) + ' 23:59:59') >= GETDATE() AND DELIVERED = 'G' THEN QTY ELSE 0 END)                 
FROM MFSS_SCRIP_MASTER S2 (NOLOCK), #DEL D (NOLOCK) LEFT OUTER JOIN RPT_DELCDSLBALANCE A   (NOLOCK)              
ON ( A.ISIN = CERTNO AND BCLTDPID = A.CLTDPID AND BDPID = A.DPID AND A.PARTY_CODE= D.SETT_NO+D.SETT_TYPE)                 
WHERE BCLTDPID = @CLTDPID AND BDPID = @DPID               
AND CERTNO LIKE 'IN%' AND S2.SCRIP_CD = D.SCRIP_CD AND S2.SERIES = D.SERIES             
AND D.FILLER2 = 1           
GROUP BY D.SETT_NO,D.SETT_TYPE,ISNULL(CERTNO,A.ISIN),S2.SEC_NAME,FREEBAL,CURRBAL,PLEDGEBAL              
HAVING SUM(CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) <> 0                 
OR ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0               
UNION                 
SELECT ISIN=A.ISIN, SCRIP_NAME=S2.SEC_NAME, SETT_NO= LEFT(PARTY_CODE,7),SETT_TYPE= SUBSTRING(PARTY_CODE,8,9), SCRIP_CD=S2.SCRIP_CD ,            
QTY=0,FREEQTY=0,PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),TODAYQTY=0                 
FROM MFSS_SCRIP_MASTER S2 (NOLOCK), RPT_DELCDSLBALANCE A (NOLOCK) WHERE CLTDPID = @CLTDPID                
AND DPID = @DPID AND S2.SCRIP_CD = A.SCRIP_CD           
AND S2.SERIES = A.SERIES AND                 
A.ISIN NOT IN ( SELECT DISTINCT CERTNO FROM #DEL D WHERE BCLTDPID = A.CLTDPID AND                 
BDPID = A.DPID AND A.ISIN = CERTNO               
AND DELIVERED <> 'D' AND CERTNO LIKE 'IN%' AND A.PARTY_CODE= D.SETT_NO+D.SETT_TYPE )                 
--ORDER BY 2              
END                
ELSE                
BEGIN               
INSERT INTO #HOLDRECO             
SELECT ISIN=ISNULL(CERTNO,A.ISIN),SCRIP_NAME=M.SEC_NAME, SETT_NO='NA', SETT_TYPE='NA', SCRIP_CD=D.SCRIP_CD,                
QTY=SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)),                
FREEQTY=SUM((CASE WHEN TRTYPE <> 909 THEN (CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ELSE 0 END)) ,                
PLEDGEQTY=SUM((CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END)),HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),                
/*TODAYQTY=SUM(CASE WHEN CONVERT(VARCHAR,TRANSDATE,106) = CONVERT(VARCHAR,GETDATE(),106) AND DELIVERED = 'G' THEN QTY ELSE 0 END) */                
TODAYQTY=SUM(CASE WHEN  TRANSDATE >= GETDATE() AND DELIVERED IN ('G','D') THEN QTY ELSE 0 END)                 
FROM MFSS_SCRIP_MASTER M, #DEL D (NOLOCK)  LEFT OUTER JOIN RPT_DELCDSLBALANCE_NEW A    (NOLOCK)               
ON ( A.ISIN = CERTNO AND BCLTDPID = A.CLTDPID AND BDPID = A.DPID)                 
WHERE BCLTDPID = @CLTDPID AND BDPID = @DPID AND DRCR = 'D'                 
AND FILLER2 = 1 AND CERTNO LIKE 'IN%' AND TRTYPE <> 906                    
AND ( DELIVERED = ( CASE WHEN  TRANSDATE >= GETDATE() THEN 'G' ELSE '0' END)                
    OR DELIVERED = ( CASE WHEN  TRANSDATE >= GETDATE() THEN 'D' ELSE '0' END) )     
    AND D.SCRIP_CD = M.SCRIP_CD AND M.SERIES = D.SERIES              
GROUP BY ISNULL(CERTNO,A.ISIN),SEC_NAME,D.SCRIP_CD,FREEBAL,CURRBAL,PLEDGEBAL                 
HAVING ( SUM((CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END)) <> 0                 
OR SUM((CASE WHEN TRTYPE <> 909 THEN (CASE WHEN DELIVERED = '0' AND TRANSDATE <= GETDATE() THEN QTY ELSE 0 END) ELSE 0 END)) <> 0                 
OR SUM((CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END)) <> 0                 
OR ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0                 
OR SUM(CASE WHEN  TRANSDATE >= GETDATE() AND DELIVERED IN ('G','D') THEN QTY ELSE 0 END) <> 0 )                
UNION ALL                
SELECT ISIN=A.ISIN, SCRIP_NAME=ISNULL(S2.SEC_NAME,'SCRIP'), SETT_NO='NA', SETT_TYPE='NA',   
SCRIP_CD=ISNULL(S2.SCRIP_CD,'SCRIP'),QTY=0,FREEQTY=0,PLEDGEQTY=0,HOLDQTY=ISNULL(CURRBAL,0),                
HOLDFREEQTY=ISNULL(FREEBAL,0),HOLDPLEDGEQTY=ISNULL(PLEDGEBAL,0),TODAYQTY=0                 
FROM RPT_DELCDSLBALANCE_NEW A (NOLOCK)  LEFT OUTER JOIN MFSS_SCRIP_MASTER S2  (NOLOCK)                
ON (S2.SCRIP_CD = A.SCRIP_CD AND S2.SERIES = A.SERIES)                 
WHERE CLTDPID = @CLTDPID                
AND DPID = @DPID AND                 
A.ISIN NOT IN ( SELECT DISTINCT CERTNO FROM #DEL D  (NOLOCK) WHERE BCLTDPID = A.CLTDPID AND                 
BDPID = A.DPID AND A.ISIN = CERTNO                 
AND DRCR = 'D' AND FILLER2 = 1 AND CERTNO LIKE 'IN%' AND TRTYPE <> 906       
AND DELIVERED <> 'D')                 
GROUP BY A.ISIN,ISNULL(S2.SEC_NAME,'SCRIP'),S2.SCRIP_CD,FREEBAL,CURRBAL,PLEDGEBAL                 
HAVING ( ISNULL(CURRBAL,0) <> 0 OR ISNULL(FREEBAL,0) <> 0 OR ISNULL(PLEDGEBAL,0) <> 0 )                
--ORDER BY 2                 
END          
      
SELECT * FROM #HOLDRECO ORDER BY SCRIP_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_DELIVERYPAYOUT
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_DELIVERYPAYOUT]              
(@SETT_NO VARCHAR(7),                  
 @SETT_TYPE VARCHAR(2),                  
 @FROMPARTY VARCHAR(10),                  
 @TOPARTY VARCHAR(10),                  
 @FROMSCRIP VARCHAR(12),                  
 @TOSCRIP VARCHAR(12),                  
 @DPTYPE VARCHAR(4),                  
 @DPID VARCHAR(8),                  
 @CLTDPID VARCHAR(16),        
 @CATEGORY VARCHAR(10),         
 @BRANCHCODE VARCHAR(10),        
 @chkflag Varchar(20))                  
AS                  
                  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
              
EXEC INSDELACCCHECK        
  
/*INSERT INTO DELACCBALANCE          
SELECT PARTY_CODE, 0, PAYFLAG = 0          
FROM DELPARTYFLAG          
WHERE PARTY_CODE NOT IN (SELECT CLTCODE FROM DELACCBALANCE)          
*/      
          
--UPDATE DELACCBALANCE SET AMOUNT = 0, PAYFLAG=1 WHERE CLTCODE IN ( SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 1 )                  
--UPDATE DELACCBALANCE SET AMOUNT = -1, PAYFLAG=2 WHERE CLTCODE IN ( SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 2 )                  
        
if @ChkFlag = 'Branch Marking'         
Begin        
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,                  
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),                  
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),                  
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, MFSS_SCRIP_MASTER S, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A                   
 ON ( A.CLTCODE = D.PARTY_CODE )                   
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906                  
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE                  
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)        
 AND D.SCRIP_CD = S.SCRIP_CD AND D.SERIES = S.SERIES    
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1         
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE         
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END))        
 AND TRTYPE = 905        
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,                   
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG           
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,S.SEC_NAME,D.SCRIP_CD                  
End        
Else if @ChkFlag = 'Always Payout'         
Begin        
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,                  
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),                  
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),                  
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, MFSS_SCRIP_MASTER S, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A                   
 ON ( A.CLTCODE = D.PARTY_CODE )                   
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906                  
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE                  
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)     
 AND D.SCRIP_CD = S.SCRIP_CD AND D.SERIES = S.SERIES      
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1         
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE         
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)        
      )        
 AND ISNULL(A.PAYFLAG,0) = 1        
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,                   
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG           
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,SEC_NAME,D.SCRIP_CD                  
End        
Else        
Begin        
 SELECT D.SCRIP_CD,SERIES=S.SEC_NAME,D.PARTY_CODE,LONG_NAME=ISNULL(PARTY_NAME,''),TRTYPE,D.DPTYPE,D.CLTDPID,                  
 D.DPID,CERTNO,QTY=CONVERT(NUMERIC(18,3),SUM(QTY)),BDPTYPE,BDPID,BCLTDPID,AMOUNT=ISNULL(AMOUNT,0),                  
 ISETT_NO,ISETT_TYPE,FLAG=(CASE WHEN TRTYPE = 907 THEN 1 WHEN TRTYPE = 908 THEN 2 ELSE 3 END),                  
 INEXC=0, PAYFLAG = ISNULL(A.PAYFLAG,0) FROM MFSS_DPMASTER M, MFSS_SCRIP_MASTER S, DELTRANS D LEFT OUTER JOIN DELACCBALANCE A                   
 ON ( A.CLTCODE = D.PARTY_CODE )                   
 WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND TRTYPE <> 906                  
 AND D.PARTY_CODE = M.PARTY_CODE AND M.DPID = D.DPID AND M.CLTDPID = D.CLTDPID AND M.DP_TYPE = D.DPTYPE                  
 AND DELIVERED = '0' AND D.PARTY_CODE <> 'BROKER'                   
 AND BDPTYPE = @DPTYPE AND BDPID = @DPID AND BCLTDPID = @CLTDPID AND DRCR = 'D' AND FILLER2 = 1                   
 AND D.PARTY_CODE >= @FROMPARTY AND D.PARTY_CODE <= @TOPARTY                  
 AND D.SCRIP_CD >= @FROMSCRIP AND D.SCRIP_CD <= @TOSCRIP AND TRTYPE IN (904,905)      
 AND D.SCRIP_CD = S.SCRIP_CD AND D.SERIES = S.SERIES     
 AND EXISTS (SELECT PARTY_CODE FROM CLIENT2 C2, CLIENT1 C1         
      WHERE C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE         
      AND C1.BRANCH_CD = (CASE WHEN @BRANCHCODE = 'ALL' THEN C1.BRANCH_CD ELSE @BRANCHCODE END)        
      )        
 GROUP BY S.SEC_NAME,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,PARTY_NAME,TRTYPE,D.CLTDPID,D.DPID,                   
 CERTNO, BDPTYPE,BDPID,BCLTDPID,AMOUNT,ISETT_NO,ISETT_TYPE,D.DPTYPE,PAYFLAG           
 ORDER BY FLAG,ISETT_NO,ISETT_TYPE,D.DPTYPE,D.PARTY_CODE,SEC_NAME,D.SCRIP_CD                  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_BILL
-- --------------------------------------------------

CREATE   PROC RPT_MFSS_BILL
	(
		@FROMDATE VARCHAR(11),
		@TODATE VARCHAR(11),
		@FROMPARTY VARCHAR(15),
		@TOPARTY VARCHAR(15),
		@FROMBRANCH VARCHAR(15),
		@TOBRANCH VARCHAR(15),
		@FROMSUBBROKER VARCHAR(15),
		@TOSUBBROKER VARCHAR(15),
		@STATUSID VARCHAR(15),
		@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'ZZZZZZZZZZ'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'ZZZZZZZZZZ'
	END


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		MS.ORDER_NO,
		MS.ISIN,
		MS.SCRIP_CD,
		SEC_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'PURCHASE' ELSE 'REDEEM' END),
		CR_AMOUNT = (CASE WHEN SUB_RED_FLAG <> 'P' THEN SUM(AMOUNT) ELSE 0 END),
		DR_AMOUNT = (CASE WHEN SUB_RED_FLAG = 'P' THEN SUM(AMOUNT) ELSE 0 END),
		BROKERAGE = SUM(BROKERAGE),
		SERVICE_TAX = SUM(SERVICE_TAX),
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY = SUM(QTY),
		NETAMOUNT = SUM(
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (BROKERAGE - SERVICE_TAX)
		END),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		BILLNO = CONTRACTNO,
		FOLIONO		
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND S.SERIES = MS.SERIES
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	GROUP BY	
		MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		OFFICE_PHONE,
		RES_PHONE, 
		EMAIL_ID,
		PAN_NO,
		CONVERT(VARCHAR,ORDER_DATE,103),
		MS.SETT_NO,
		MS.SETT_TYPE,
		MS.SCRIP_CD,
		S.SERIES,
		SUB_RED_FLAG,
		CONVERT(VARCHAR,ORDER_DATE,112),
		CONTRACTNO,SEC_NAME,
		MS.ORDER_NO,
		MS.ISIN,
		FOLIONO	
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_CONFIRMATION
-- --------------------------------------------------
CREATE   PROC RPT_MFSS_CONFIRMATION
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END



	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),	
		CONTRACTNO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		S.SCRIP_CD,
		SEC_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES) ,
		SELL_BUY = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'Pur.' ELSE 'Redm.' END),
		QTY = QTY,
		AMOUNT,
		BROKERAGE,
		SERVICE_TAX,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		NETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE + SERVICE_TAX)
			ELSE (AMOUNT - BROKERAGE - SERVICE_TAX)
		END),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		FOLIONO		
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND S.SERIES = MS.SERIES
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		CONTRACTNO,
		ORDER_NO,
		SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_DFDSREPORT
-- --------------------------------------------------
CREATE PROC RPT_MFSS_DFDSREPORT
(
	@STATUSID	VARCHAR(20),
	@STATUSNAME	VARCHAR(30),
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2)
)
AS

SELECT SETT_NO,SETT_TYPE,S.PARTY_CODE,PARTY_NAME,
SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN,
QTY,S.DPID,S.CLTDPID,TRANSNO 
FROM MFSS_DFDS S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
WHERE S.SETT_NO = @SETT_NO
AND S.SETT_TYPE = @SETT_TYPE
AND S.PARTY_CODE = C.PARTY_CODE
AND S.SCRIP_CD = M.SCRIP_CD
AND S.SERIES = M.SERIES
AND @STATUSNAME =             
				  (CASE             
						WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
						WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
						WHEN @STATUSID = 'TRADER' THEN C.TRADER            
						WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
						WHEN @STATUSID = 'AREA' THEN C.AREA            
						WHEN @STATUSID = 'REGION' THEN C.REGION            
						WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
				  ELSE             
						'BROKER'            
				  END)
ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_FUND_OBL_MATCH
-- --------------------------------------------------

CREATE PROC RPT_MFSS_FUND_OBL_MATCH
(
	@STATUSID	VARCHAR(20),
	@STATUSNAME	VARCHAR(30),
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2)
)
AS
SELECT S.PARTY_CODE, C.PARTY_NAME, ORDER_DATE = CONVERT(VARCHAR,S.ORDER_DATE,103), 
S.ORDER_NO, S.SCRIP_CD, S.SERIES, SEC_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES),
S.ISIN, S.AMOUNT, EX_AMOUNT = ISNULL(O.AMOUNT, 0)
FROM MFSS_CLIENT C, MFSS_SCRIP_MASTER M, MFSS_SETTLEMENT S
FULL OUTER JOIN MFSS_FUNDS_OBLIGATION O
ON 
	(
		S.SETT_NO = O.SETT_NO AND S.SETT_TYPE = O.SETT_TYPE
		AND S.PARTY_CODE = O.PARTY_CODE AND S.SCRIP_CD = O.SCRIP_CD AND S.SCRIP_CD = O.SCRIP_CD
		AND S.ORDER_NO = O.ORDER_NO
	)
WHERE S.SETT_NO = @SETT_NO AND S.SETT_TYPE = @SETT_TYPE
AND S.PARTY_CODE = C.PARTY_CODE
AND SUB_RED_FLAG = 'P'
AND S.SCRIP_CD = M.SCRIP_CD
AND S.SERIES = M.SERIES
AND @STATUSNAME =             
                  (CASE             
                        WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
                        WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
                        WHEN @STATUSID = 'TRADER' THEN C.TRADER            
                        WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
                        WHEN @STATUSID = 'AREA' THEN C.AREA            
                        WHEN @STATUSID = 'REGION' THEN C.REGION            
                        WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
                  ELSE             
                        'BROKER'            
                  END)
ORDER BY PARTY_CODE, SEC_NAME, S.SCRIP_CD, S.SERIES

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_NAVDATA
-- --------------------------------------------------

CREATE PROC RPT_MFSS_NAVDATA
(
	@NAV_DATE VARCHAR(11)
)
AS
SELECT NAV_DATE = CONVERT(VARCHAR,NAV_DATE,103), SCRIP_CD, SERIES, SCHEME_NAME = SCHEME_NAME + DBO.FN_SERIES_NAME(SERIES),
CATEGORY_CODE, CATEGORY_NAME, ISIN, NAV_VALUE
FROM MFSS_NAV
WHERE NAV_DATE = @NAV_DATE + ' 23:59:59'
ORDER BY 3, 1, 2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_ORDERCONFIRMATION
-- --------------------------------------------------


CREATE  PROC [dbo].[RPT_MFSS_ORDERCONFIRMATION]
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25),
	@RPT_TYPE INT = 1
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT 
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME = MC.PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
			END), 
		EMAIL_ID,
		PAN_NO,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),	
		BILLNO = CONTRACTNO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		SCRIP_CD = MS.SCRIP_CD,
		SCRIP_NAME =  S.sec_NAME ,
		SELL_BUY = SUB_RED_FLAG,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		QTY,
		PQTY  = (CASE WHEN SUB_RED_FLAG = 'P' THEN QTY ELSE 0 END),
		SQTY  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN QTY ELSE 0 END),
		RATE  = (CASE WHEN (QTY)> 0 THEN  (AMOUNT)/(QTY) ELSE 0 END),
		PRATE = (CASE WHEN SUB_RED_FLAG = 'P' AND (QTY)> 0 THEN (AMOUNT)/(QTY) ELSE 0 END),
		SRATE = (CASE WHEN SUB_RED_FLAG <> 'P' AND (QTY)> 0  THEN (AMOUNT)/(QTY) ELSE 0 END),
		AMOUNT,
		PAMOUNT  = (CASE WHEN SUB_RED_FLAG = 'P' THEN (AMOUNT) ELSE 0 END),
		SAMOUNT  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN (AMOUNT) ELSE 0 END),
		BROKERAGE,
		PBROKERAGE  = (CASE WHEN SUB_RED_FLAG = 'P' THEN (BROKERAGE) ELSE 0 END),
		SBROKERAGE  = (CASE WHEN SUB_RED_FLAG <> 'P' THEN (BROKERAGE) ELSE 0 END),
		INS_CHRG,
		TURN_TAX,
		OTHER_CHRG,
		SEBI_TAX,
		BROKER_CHRG,
		SERVICE_TAX,
		NETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE)
			ELSE (AMOUNT - BROKERAGE)
		END),
		PNETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN (AMOUNT + BROKERAGE)
			ELSE 0
		END),
		SNETAMOUNT = (
		CASE WHEN SUB_RED_FLAG = 'P' 
			THEN 0
			ELSE (AMOUNT - BROKERAGE)
		END),
		FOLIONO			
	FROM
		MFSS_SETTLEMENT MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK),
		MFSS_SCRIP_MASTER S (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND S.SCRIP_CD = MS.SCRIP_CD
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)
	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		CONTRACTNO,
		ORDER_NO,
		S.sec_NAME,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_STATUSREPORT
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_MFSS_STATUSREPORT]
	(
	@STATUSID	VARCHAR(20),
	@STATUSNAME	VARCHAR(30),
	@FROMSETT_NO	VARCHAR(7),
	@TOSETT_NO	VARCHAR(7),
	@FROMPARTY	VARCHAR(15),
	@TOPARTY	VARCHAR(15),
	@SETT_TYPE	VARCHAR(2),
	@STATUS     VARCHAR(2)
	)
	
	AS

	IF @TOSETT_NO = ''
	BEGIN
		SET @TOSETT_NO = '9999999'
	END

	IF @TOPARTY = ''
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF @STATUS = 'AC' 
	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE, 
		S.PARTY_CODE, C.PARTY_NAME, 
		ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103), 
		SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN, 
		APPLN_NO, DP_FOLIO = (CASE WHEN S.CLTDPID = '' THEN CONVERT(VARCHAR,FOLIONO) ELSE RIGHT(S.DP_ID+S.CLTDPID,16) END), 
		ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = QTY_ALLOTED, ALLOT_AMT = AMOUNT_ALLOTED, NAV_VALUE_ALLOTED,
		REMARK = ''
		FROM MFSS_ORDER_ALLOT_CONF S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
		WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO
		AND S.SETT_TYPE = @SETT_TYPE
		AND S.PARTY_CODE = C.PARTY_CODE
		AND S.SCRIP_CD = M.SCRIP_CD
		AND S.SERIES = M.SERIES
		AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND @STATUSNAME =             
			  (CASE             
				WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
				WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
				WHEN @STATUSID = 'TRADER' THEN C.TRADER            
				WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
				WHEN @STATUSID = 'AREA' THEN C.AREA            
				WHEN @STATUSID = 'REGION' THEN C.REGION            
				WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
			  ELSE             
				'BROKER'            
			  END)
		ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES
	END
	
	
	IF @STATUS = 'AR' 
	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE, 
		S.PARTY_CODE, C.PARTY_NAME, 
		ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103), 
		SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN, 
		APPLN_NO, DP_FOLIO = '-', 
		ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = 0, ALLOT_AMT = 0, NAV_VALUE_ALLOTED=0,
		REMARK = REJECT_REASON
		FROM MFSS_ORDER_ALLOT_REJ S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
		WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO
		AND S.SETT_TYPE = @SETT_TYPE
		AND S.PARTY_CODE = C.PARTY_CODE
		AND S.SCRIP_CD = M.SCRIP_CD
		AND S.SERIES = M.SERIES
		AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND @STATUSNAME =             
			  (CASE             
				WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
				WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
				WHEN @STATUSID = 'TRADER' THEN C.TRADER            
				WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
				WHEN @STATUSID = 'AREA' THEN C.AREA            
				WHEN @STATUSID = 'REGION' THEN C.REGION            
				WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
			  ELSE             
				'BROKER'            
			  END)
		ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES
	END
	
	
	IF @STATUS = 'RC' 
	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE, 
		S.PARTY_CODE, C.PARTY_NAME, 
		ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103), 
		SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN, 
		APPLN_NO, DP_FOLIO = (CASE WHEN S.BANK_AC_NO = '' THEN CONVERT(VARCHAR,FOLIONO) ELSE S.BANK_NAME +'-'+BANK_AC_NO END), 
		ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = QTY_ALLOTED, ALLOT_AMT = AMOUNT_ALLOTED, NAV_VALUE_ALLOTED,
		REMARK = ''
		FROM MFSS_ORDER_REDEM_CONF S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
		WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO
		AND S.SETT_TYPE = @SETT_TYPE
		AND S.PARTY_CODE = C.PARTY_CODE
		AND S.SCRIP_CD = M.SCRIP_CD
		AND S.SERIES = M.SERIES
		AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND @STATUSNAME =             
			  (CASE             
				WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
				WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
				WHEN @STATUSID = 'TRADER' THEN C.TRADER            
				WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
				WHEN @STATUSID = 'AREA' THEN C.AREA            
				WHEN @STATUSID = 'REGION' THEN C.REGION            
				WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
			  ELSE             
				'BROKER'            
			  END)
		ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES
	END
	
	
	IF @STATUS = 'RR' 
	BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT REPORT_DATE = CONVERT(VARCHAR,REPORTDATE,103), SETT_NO, SETT_TYPE, 
		S.PARTY_CODE, C.PARTY_NAME, 
		ORDER_NO, ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103), 
		SCHEME_NAME = SEC_NAME + DBO.FN_SERIES_NAME(S.SERIES), S.SCRIP_CD, S.SERIES, S.ISIN, 
		APPLN_NO, DP_FOLIO = '-', 
		ORDQTY = QTY, ORDAMT = AMOUNT, ALLOT_QTY = 0, ALLOT_AMT = 0, NAV_VALUE_ALLOTED=0,
		REMARK = REJECT_REASON
		FROM MFSS_ORDER_REDEM_REJ S, MFSS_SCRIP_MASTER M, MFSS_CLIENT C
		WHERE S.SETT_NO BETWEEN @FROMSETT_NO AND @TOSETT_NO
		AND S.SETT_TYPE = @SETT_TYPE
		AND S.PARTY_CODE = C.PARTY_CODE
		AND S.SCRIP_CD = M.SCRIP_CD
		AND S.SERIES = M.SERIES
		AND S.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND @STATUSNAME =             
			  (CASE             
				WHEN @STATUSID = 'BRANCH' THEN C.BRANCH_CD            
				WHEN @STATUSID = 'SUBBROKER' THEN C.SUB_BROKER            
				WHEN @STATUSID = 'TRADER' THEN C.TRADER            
				WHEN @STATUSID = 'FAMILY' THEN C.FAMILY            
				WHEN @STATUSID = 'AREA' THEN C.AREA            
				WHEN @STATUSID = 'REGION' THEN C.REGION            
				WHEN @STATUSID = 'CLIENT' THEN C.PARTY_CODE            
			  ELSE             
				'BROKER'            
			  END)
		ORDER BY S.PARTY_CODE, C.PARTY_NAME, SEC_NAME, S.SCRIP_CD, S.SERIES
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_MFSS_TRADEBOOK
-- --------------------------------------------------
CREATE   PROC RPT_MFSS_TRADEBOOK
	(
	@FROMDATE VARCHAR(11),
	@TODATE VARCHAR(11),
	@FROMPARTY VARCHAR(15),
	@TOPARTY VARCHAR(15),
	@FROMBRANCH VARCHAR(15),
	@TOBRANCH VARCHAR(15),
	@FROMSUBBROKER VARCHAR(15),
	@TOSUBBROKER VARCHAR(15),
	@CONF_FLAG VARCHAR(2),
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25)
	)
	
	AS

	IF LEN(@TOPARTY) = 0
	BEGIN
		SET @TOPARTY = 'zzzzzzzzzz'
	END

	IF LEN(@TOBRANCH) = 0 
	BEGIN
		SET @TOBRANCH = 'zzzzzzzzzz'
	END

	IF LEN(@TOSUBBROKER) = 0 
	BEGIN
		SET @TOSUBBROKER = 'zzzzzzzzzz'
	END

	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT
		PARTY_CODE = MS.PARTY_CODE,
		PARTY_NAME,
		ADDR1,
		ADDR2,
		ADDR3,
		CITY,
		STATE,
		ZIP,
		PHONE = (CASE 
				WHEN OFFICE_PHONE <> '' THEN OFFICE_PHONE + ', '
				WHEN RES_PHONE <> '' THEN RES_PHONE
				ELSE ''
				END), 
		EMAIL_ID = MC.EMAIL_ID,
		PAN_NO,
		ORDER_NO,
		SETT_NO = MS.SETT_NO,
		SETT_TYPE = MS.SETT_TYPE,
		SELL_BUY = (CASE 
				WHEN SUB_RED_FLAG = 'P' THEN 'Purchase' 
				ELSE 'Redeem' 
				END),
		ALLOTMENT_MODE,
		ORDER_DATE = CONVERT(VARCHAR,ORDER_DATE,103),
		ORDER_TIME = CONVERT(VARCHAR,ORDER_TIME,108),
		SCRIP_CD,
		SERIES=ltrim(Replace(DBO.FN_SERIES_NAME(SERIES),'-','')),
		QTY,
		AMOUNT,
		CONF_FLAG,
		REJECT_REASON,
		NAV_VALUE_ALLOTED,
		AMOUNT_ALLOTED,
		ORDDATE = CONVERT(VARCHAR,ORDER_DATE,112),
		TODATE = REPLACE(CONVERT(VARCHAR,GETDATE(),103),'/',''),
		FOLIONO
	FROM
		MFSS_ORDER MS (NOLOCK),
		MFSS_CLIENT MC (NOLOCK),
		SETT_MST SM (NOLOCK)
	WHERE
		MS.PARTY_CODE = MC.PARTY_CODE
		AND MS.SETT_NO = SM.SETT_NO
		AND MS.SETT_TYPE = SM.SETT_TYPE
		AND MS.ORDER_DATE BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
		AND MS.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY
		AND MC.BRANCH_CD BETWEEN @FROMBRANCH AND @TOBRANCH
		AND MC.SUB_BROKER BETWEEN @FROMSUBBROKER AND @TOSUBBROKER
		AND CONF_FLAG BETWEEN @CONF_FLAG AND @CONF_FLAG
		AND @STATUSNAME = (         
		CASE         
			WHEN @STATUSID = 'BRANCH'
			THEN MC.BRANCH_CD
			WHEN @STATUSID = 'SUBBROKER'
			THEN MC.SUB_BROKER
			WHEN @STATUSID = 'TRADER'
			THEN MC.TRADER
			WHEN @STATUSID = 'FAMILY'
			THEN MC.FAMILY
			WHEN @STATUSID = 'AREA'
			THEN MC.AREA
			WHEN @STATUSID = 'REGION'
			THEN MC.REGION
			WHEN @STATUSID = 'CLIENT'
			THEN MC.PARTY_CODE
			ELSE 'BROKER' 
		END)

	ORDER BY
		CONVERT(VARCHAR,ORDER_DATE,112),
		MS.PARTY_CODE,
		ORDER_NO,
		SCRIP_CD,
		SUB_RED_FLAG

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelAllClientList
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NSEDelAllClientList] (          
@StatusId Varchar(15),@StatusName Varchar(25),@SCRIP_CD Varchar(12), @Series Varchar(3))          
as           
Set Transaction Isolation level read uncommitted          
       
select distinct d.PARTY_CODE, LONG_NAME,      
Qty=0      
from DeliveryClt D, Client2 C2, Client1 C1          
where D.SCRIP_CD = @SCRIP_CD      
and d.series = @Series      
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code       
And @StatusName =       
   (case       
         when @StatusId = 'BRANCH' then c1.branch_cd      
         when @StatusId = 'SUBBROKER' then c1.sub_broker      
         when @StatusId = 'Trader' then c1.Trader      
         when @StatusId = 'Family' then c1.Family      
         when @StatusId = 'Area' then c1.Area      
         when @StatusId = 'Region' then c1.Region      
         when @StatusId = 'Client' then c2.party_code      
   else       
         'BROKER'      
   End)              
order by d.PARTY_CODE, LONG_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelAllScripList
-- --------------------------------------------------
  
CREATE Proc [dbo].[Rpt_NSEDelAllScripList] (        
@StatusId Varchar(15),@StatusName Varchar(25),@Party_Code Varchar(10))        
as  
Set Transaction Isolation level read uncommitted        
     
select distinct d.scrip_cd,d.series,d.scheme_name,    
Qty=0    
from DeliveryClt D, Client2 C2, Client1 C1        
where D.Party_Code = @Party_Code        
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code     
And @StatusName =     
   (case     
         when @StatusId = 'BRANCH' then c1.branch_cd    
         when @StatusId = 'SUBBROKER' then c1.sub_broker    
         when @StatusId = 'Trader' then c1.Trader    
         when @StatusId = 'Family' then c1.Family    
         when @StatusId = 'Area' then c1.Area    
         when @StatusId = 'Region' then c1.Region    
         when @StatusId = 'Client' then c2.party_code    
   else     
         'BROKER'    
   End)        
Group by d.scrip_cd,d.series ,d.scheme_name    
order by d.scrip_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelCertinfo
-- --------------------------------------------------
   
CREATE PROCEDURE [dbo].[rpt_NSEDelCertinfo]      
@targetid varchar(2),      
@settno varchar(7),      
@settype varchar(3),      
@scripcd varchar(20),      
@series varchar(3),      
@partycode varchar(20)      
AS    

if @targetid = 1      
begin      
	select Sett_no,Sett_Type,Party_Code,d.Scrip_cd,d.Series,scheme_name=sec_name,
	Qty,TransDate,CertNo,HolderName,FolioNo,TrType,Reason,CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type      
	from DelTrans d (nolock), mfss_scrip_master m where sett_no = @SettNo and sett_type = @Settype      
	and d.scrip_cd = @scripcd and d.series = @series and DrCr = 'C'       
	and party_code = @partycode and filler2 = 1  and d.scrip_cd = m.scrip_cd and d.series = m.series    
end      
if @targetid = 2      
begin      
	select Sett_no,Sett_Type,Party_Code,d.Scrip_cd,d.Series,scheme_name=sec_name,
	Qty,TransDate,CertNo,HolderName,FolioNo,TrType,      
	Reason=(case When TrType = 909 Then 'DEMAT' Else Reason End),CltDpId,DpId,DpType,BCltDpId,BDpId,BDpType,Delivered,ISett_no,ISett_Type      
	from DelTrans d (nolock), mfss_scrip_master m where sett_no = @SettNo and sett_type = @Settype      
	and d.scrip_cd = @scripcd and d.series = @series and DrCr = 'D'       
	and party_code = @partycode and filler2 = 1 and d.scrip_cd = m.scrip_cd and d.series = m.series      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelClientList
-- --------------------------------------------------

CREATE Proc [dbo].[Rpt_NSEDelClientList] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )    
as     
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2      
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code     
 and d.sett_no like @settno and d.sett_type like @Sett_Type   
 and d.party_code like @Party_Code + '%'    
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)   
 order by c1.short_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelClientScrips
-- --------------------------------------------------

  
CREATE PROCEDURE [dbo].[rpt_NSEDelClientScrips]      
@StatusId Varchar(15),@StatusName Varchar(25),      
@dematid varchar(2),      
@settno varchar(7),      
@settype varchar(3),      
@partycode varchar(20)      
AS  
Set Transaction Isolation level read uncommitted      
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.SCHEME_NAME,d.inout,d.Qty,     
/*RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),      
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End))*/      
RecQty = (Case When D.Sett_Type ='W' Then       
   (Case When InOut ='I' Then Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)      
   Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End),      
GivenQty = (Case When D.Sett_Type ='W' Then       
   (Case When InOut ='O' Then Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)      
   Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) End)      
from client1 c1,client2 c2, deliveryclt d Left Outer Join DelTrans De      
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )       
 where  d.party_code = c2.party_code and c1.cl_code =c2.cl_code      
 and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode   
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)      
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty,d.SCHEME_NAME   
--Union All      
--select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,      
--RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),      
--GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))      
--from client1 c1,client2 c2,DelTrans D      
--where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code      
--and d.sett_no = @settno and d.sett_type = @settype and d.party_code = @partycode And Filler2 = 1      
--And d.Party_code Not In ( Select Party_Code From DeliveryClt De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
--And De.Party_Code = D.Party_Code And De.Series = D.Series )   
--And @StatusName =   
--   (case   
--         when @StatusId = 'BRANCH' then c1.branch_cd  
--         when @StatusId = 'SUBBROKER' then c1.sub_broker  
--         when @StatusId = 'Trader' then c1.Trader  
--         when @StatusId = 'Family' then c1.Family  
--         when @StatusId = 'Area' then c1.Area  
--         when @StatusId = 'Region' then c1.Region  
--         when @StatusId = 'Client' then c2.party_code  
--   else   
--         'BROKER'  
--   End)       
--group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code      
Order By d.sett_no,d.sett_type,d.scrip_cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelClientSettScrip_new
-- --------------------------------------------------


CREATE PROCEDURE  [dbo].[rpt_NSEDelClientSettScrip_new]  
@scripcd varchar(20),      
@series varchar(3),      
@partycode varchar(10)      
AS      
Set Transaction Isolation level read uncommitted      
  
  
  
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,SCHEME_NAME,  
d.BUYQty, D.SELLQTY,       
RecQty = Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)),      
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)),      
Demat_Date = 'Jan 30 2079'      
from client1 c1,client2 c2, (select sett_no, sett_type, party_code, scrip_cd, series,SCHEME_NAME,   
BuyQty = SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END),  
SELLQty = SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)  
FROM DELIVERYCLT  
GROUP BY sett_no, sett_type, party_code, scrip_cd, series,SCHEME_NAME) D   
Left Outer Join DelTrans De      
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD      
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )       
where d.party_code = c2.party_code and c1.cl_code =c2.cl_code      
and d.party_code = @partycode And d.scrip_cd = @scripcd and d.series = @series      
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,SCHEME_NAME,c1.short_name,d.party_code,D.BUYQty, SELLQTY      
Order By d.sett_no,d.sett_type,SCHEME_NAME,d.scrip_cd,d.series

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelDematCltIdSearch
-- --------------------------------------------------
    
-- Exec Rpt_NSEDelDematCltIdSearch 'broker','broker','HOC0000001','12010402','1201040200005621','ALL'  
CREATE proc [dbo].[Rpt_NSEDelDematCltIdSearch]  
(  
 @StatusId varchar(10),  
 @statusname varchar(20),  
 @Party_code varchar(12),  
 @DpId varchar(8),  
 @CltDpId varchar(16),  
 @Status varchar(10)  
   
)  
as   
Declare @@ssql varchar(8000)  
Begin  
  If @Status <> 'PAYOUT'  
  Begin  
   Set @@ssql='select M.Party_code,Introducer=M.PARTY_NAME,DpId,CltDpNo=M.CltDpID,DPTYPE=M.Dp_Type,  
      Def=(Case When POAFLAG = ''YES'' Then ''Received'' Else ''Not Received'' End),  
   ACType=''Pay_In'' from MFSS_DPMASTER M, Client2 C2, Client1 C1   
   where C1.Cl_Code = C2.Cl_Code And M.Party_Code = C2.Party_Code   
   And M.Party_code like '''+ @Party_code +'%'' and DpId like  '''+ @DpId +'%'' and M.CltDpID like '''+ @CltDpId +'%'' '  
     
   If @StatusId = 'branch'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.branch_cd = @statusname'  
   End  
   If @StatusId = 'subbroker'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.sub_broker = @statusname'  
   End  
   If @StatusId = 'trader'  
   Begin   
    Set @@ssql=@@ssql + ' And C1.trader = @statusname'  
   End  
   If @StatusId = 'family'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.family = @statusname'  
   End  
   If @StatusId = 'area'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.area = @statusname'   
   End  
   If @StatusId = 'region'  
   Begin  
    Set @@ssql=@@ssql + ' And C1.region = @statusname '  
   End  
   If @StatusId = 'client'  
   Begin   
    Set @@ssql=@@ssql + ' And C2.Party_Code = @statusname'   
   End  
   if @Status = 'POA'   
   Begin  
    Set @@ssql=@@ssql + ' And Def = ''1'''  
   End  
   if @Status = 'NONPOA'  
   Begin  
    Set @@ssql=@@ssql + ' And Def = ''0'''  
   end  
  End  
   
  
 If @Status = 'ALL'  
 Begin  
  Set @@ssql=@@ssql + ' UNION ALL'  
 End  
 If @Status = 'ALL' Or @Status = 'PAYOUT'  
 Begin   
  Set @@ssql=@@ssql + ' select C2.Party_code,Introducer=Long_Name,DpId=C4.DPID,CltDpNo=C4.CltDpId,  
  DpType=DP_TYPE, Def=(Case When DEFAULTDP = 1 Then ''Default'' Else ''-'' End),ACType=''Pay_Out''   
  from Client2 C2,MFSS_DPMASTER C4, Client1 C1   
  where c1.cl_code = c2.cl_code and C2.party_Code = C4.party_Code And C2.Party_code like '''+@Party_code+'%''   
  and C4.DPID like '''+@DpId+'%'' and C4.CltDpId like '''+ @CltDpId+'%'' And DP_TYPE in (''NSDL'',''CDSL'' )   
  And C4.DPID <> '''' '  
  If @StatusId = 'branch'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.branch_cd = @statusname'  
  End  
  If @StatusId = 'subbroker'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.sub_broker = @statusname'  
  End  
  If @StatusId = 'trader'  
  Begin   
   Set @@ssql=@@ssql + ' And C1.trader = @statusname'  
  End  
  If @StatusId = 'family'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.family = @statusname'  
  End  
  If @StatusId = 'area'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.area = @statusname '  
  End  
  If @StatusId = 'region'  
  Begin  
   Set @@ssql=@@ssql + ' And C1.region = @statusname '  
  End  
  If @StatusId = 'client'  
  Begin   
   Set @@ssql=@@ssql + ' And C2.Party_Code = @statusname '  
  End  
 End  
 Set @@ssql=@@ssql + ' order by 1'  
--print(@@ssql)  
Exec(@@ssql)  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELDEMATISINSEARCH
-- --------------------------------------------------
CREATE PROC [dbo].[RPT_NSEDELDEMATISINSEARCH]  
(  
 @SCRIP_CD VARCHAR(30),  
 @ISIN VARCHAR(12)  
)  
AS   
BEGIN  
  SELECT SCHEME_NAME=SEC_NAME, SCRIP_CD = M.SCRIP_CD + '-' + SERIES, M.ISIN, VALID='CURRENT'  
  FROM MFSS_SCRIP_MASTER M  WHERE M.SCRIP_CD LIKE @SCRIP_CD+'%' AND M.ISIN LIKE @ISIN+'%'   
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelDematTransNoSearch
-- --------------------------------------------------
CREATE PROC [dbo].[Rpt_NSEDelDematTransNoSearch]
(
	@TRANSNO VARCHAR(10)
)
AS 
BEGIN
		SELECT TRANSNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES,SCHEME_NAME=ISNULL(SEC_NAME,'N/A'),QTY,TRDATE=CONVERT(VARCHAR,TRDATE,103),
		CLTACCNO,DPID,D.ISIN FROM DEMATTRANS D LEFT OUTER JOIN MFSS_SCRIP_MASTER M
		ON (D.SCRIP_CD = M.SCRIP_CD)
		WHERE TRANSNO LIKE @TRANSNO+'%' 
		UNION ALL
		SELECT TRANSNO=FROMNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES,SEC_NAME AS SCHEME_NAME,QTY,TRDATE=CONVERT(VARCHAR,TRANSDATE,103),
		CLTACCNO=CLTDPID,DPID,ISIN=CERTNO FROM DELTRANS D, MFSS_SCRIP_MASTER M
		WHERE FROMNO LIKE @TRANSNO+'%' AND FILLER2 = 1 AND DRCR = 'C' 
		AND (D.SCRIP_CD = M.SCRIP_CD)
		ORDER BY TRANSNO,SETT_NO,SETT_TYPE,PARTY_CODE,D.SCRIP_CD,D.SERIES
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelExeReport
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelExeReport]     
(@TDate Varchar(11),    
 @BDpId Varchar(8),    
 @BCltDpId Varchar(16),    
 @FParty Varchar(10),    
 @TParty Varchar(10),    
 @FScrip Varchar(12),    
 @TScrip Varchar(12)    
) As    
/* Pool To Client Trans */    
Set Transaction Isolation level read uncommitted    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME, Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M   
Where DrCr = 'D' And Delivered = 'D'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip  
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES   
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
And D.SNo in ( Select Sno From DelTransTemp Where BDpId = @BDpId And BCltDpId = @BCltDpId and CONVERT(VARCHAR,TransDate,103) = @TDate )     
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Pool To Pool InterSett */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Inter Sett'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered in ('G','D')    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 907    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES 
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Pool To Ben Trans */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'     
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
 Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Like '%POOL%'    
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD  AND M.SERIES = D.SERIES
And TCode in (Select TCode From DelTrans Where DrCr = 'D'     
And BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code     
And d.SCRIP_CD = SCRIP_CD AND D.SERIES = SERIES)    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'     
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Like '%POOL%'    
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD  
And D.Sno in (Select Sno From DelTransTemp Where BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code     
And d.SCRIP_CD = SCRIP_CD and CONVERT(VARCHAR,TransDate,103) = @TDate  )    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type    
Union All    
/* Ben To Client Trans */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'D'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Not Like '%POOL%' And Filler2 = 1    
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered = 'G'    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )    
And Dp.Description Not Like '%POOL%' And Filler2 = 1    
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip   
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES  
And D.Sno In ( Select SNo From DelTransTemp Where DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId and CONVERT(VARCHAR,TransDate,103) = @TDate )    
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Union All    
/* Ben To Pool InterSett */    
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SCHEME_NAME=SEC_NAME,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Pool'     
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2, MFSS_SCRIP_MASTER M  
  Where DrCr = 'D' And Delivered in ('G','D')    
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 1000    
and CONVERT(VARCHAR,TransDate,103) = @TDate  And Dp.Description Not Like '%POOL%' And Filler2 = 1     
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId     
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code    
And D.Party_Code >= @FParty And D.Party_Code <= @TParty    
And d.SCRIP_CD >= @FScrip And d.SCRIP_CD <= @TScrip    
AND M.SCRIP_CD = D.SCRIP_CD AND M.SERIES = D.SERIES 
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,d.SCRIP_CD,D.SERIES,SEC_NAME,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type    
Order By D.Party_Code,C1.Short_Name,SEC_NAME,d.SCRIP_CD,D.SERIES,CertNo,Remark,Sett_no,Sett_Type,ISett_No,ISett_Type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rpt_NSEDelGive
-- --------------------------------------------------
--exec RPT_NSEDELGIVE '3','1011186','T3'    
CREATE PROCEDURE [dbo].[rpt_NSEDelGive]                    
@DEMATID VARCHAR(2),                    
@SETT_NO VARCHAR(7),                    
@SETT_TYPE VARCHAR(3)                    
AS    
DECLARE               
@START_DATE DATETIME,              
@SEC_PAYIN DATETIME              
            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  
            
SELECT *             
INTO #DEL FROM DELTRANS                
WHERE SETT_NO = @SETT_NO                
AND SETT_TYPE = @SETT_TYPE                
AND FILLER2 = 1                 
AND TRTYPE = 906                
AND CERTNO <> 'AUCTION'                
            
SELECT SETT_NO, SETT_TYPE, SCRIP_CD, SERIES = SCHEME_NAME,SERIES_TEST = SERIES,    
BUYQTY = SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END),            
SELLQTY = SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)            
INTO #DELNET FROM DELNET              
WHERE SETT_NO = @SETT_NO              
AND SETT_TYPE = @SETT_TYPE              
--AND INOUT = 'O'              
GROUP BY SETT_NO, SETT_TYPE, SCRIP_CD, SERIES,SCHEME_NAME           
            
SELECT @START_DATE=MIN(START_DATE), @SEC_PAYIN=MAX(SEC_PAYIN)              
FROM SETT_MST              
WHERE SETT_NO = @SETT_NO              
AND SETT_TYPE = @SETT_TYPE                
            
SELECT D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.SERIES_TEST,           
GIVENSE=BUYQTY, RECEIVENSE=SELLQTY,                   
GIVENNSE= ISNULL(SUM(CASE WHEN DRCR = 'D' THEN DT.QTY ELSE 0 END),0),                    
RECEIVEDNSE=ISNULL(SUM(CASE WHEN DRCR = 'C' THEN DT.QTY ELSE 0 END),0),                
CL_RATE = CONVERT(NUMERIC(18,4),0)                
INTO #SHORT FROM #DELNET D LEFT OUTER JOIN #DEL DT                    
ON (DT.SETT_NO = D.SETT_NO AND DT.SETT_TYPE = D.SETT_TYPE AND                     
DT.SCRIP_CD = D.SCRIP_CD and D.SERIES_TEST = DT.SERIES AND TRTYPE = 906                     
AND FILLER2 = 1 )         
WHERE D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE --AND INOUT = 'I'                     
GROUP BY D.SETT_NO,D.SETT_TYPE,D.SCRIP_CD,D.SERIES,D.BUYQTY,SELLQTY,D.SERIES_TEST                   
              
SELECT * FROM #SHORT                 
ORDER BY SCRIP_CD,SERIES

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelHoldParty
-- --------------------------------------------------

CREATE Proc [dbo].[Rpt_NseDelHoldParty] (            
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),            
@ToParty varchar(10),@FromScrip Varchar(12),          
@ToScrip Varchar(12),@BDpID Varchar(8),          
@BCltDpID Varchar(16), @Branch Varchar(10))            
AS            
if @BDpID = ''             
Select @BDpID = '%'            
if @BCltDpID = ''             
Select @BCltDpID = '%'            
Set Transaction Isolation level read uncommitted            
select D.scrip_cd, D.series, SCHEME_NAME=sec_name, D.Party_Code,Sett_No, Sett_type, QTy=Sum(Qty),CertNo,BDpId,BCltDpId,            
HoldQty=(Case When @StatusId = 'broker' Then Sum(Case When P.Description NOT LIKE '%PLEDGE%' AND TrType <> 909 Then Qty Else 0 End) Else Sum(Qty) End),       
PledgeQty=(Case When @StatusId = 'broker' Then Sum(Case When P.Description LIKE '%PLEDGE%' OR TrType = 909 Then Qty Else 0 End) Else 0 End),      
Party_Name = C1.Long_Name , C1.Long_Name             
from DELTRANS D, Client1 C1, Client2 C2, DeliveryDP P, MFSS_SCRIP_MASTER M             
where BDpId Like @BDpId and BCltDpId Like @BCltDpId      
AND D.Bdpid = P.Dpid    
AND D.BCltDpId = P.Dpcltno           
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY            
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP And DrCr = 'D' and Filler2 = 1  And Delivered = '0'            
And D.Party_Code <> 'BROKER' And TrType <> 906 And CertNo not like 'Auction'            
And C1.Branch_Cd Like @Branch          
And C1.Cl_Code = C2.Cl_Code And C2.Party_Code = D.Party_Code            
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)             
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)            
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)            
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)            
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)            
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)            
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)            
AND D.SCRIP_CD = M.SCRIP_CD AND D.SERIES = M.SERIES   
group by D.scrip_cd,CertNo, D.series,sec_name, D.Party_Code,C1.Long_Name, Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0             
Order By D.Party_Code,sec_name,D.Scrip_CD,D.Series,Sett_No, Sett_type

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELHOLDSCRIP
-- --------------------------------------------------
 CREATE PROC [dbo].[RPT_NSEDELHOLDSCRIP] (          
@STATUSID VARCHAR(15),@STATUSNAME VARCHAR(25),@FROMPARTY VARCHAR(10),          
@TOPARTY VARCHAR(10),@FROMSCRIP VARCHAR(12),@TOSCRIP VARCHAR(12),        
@BDPID VARCHAR(8),@BCLTDPID VARCHAR(16), @BRANCH VARCHAR(10))          
AS          
IF @BDPID = ''           
SELECT @BDPID = '%'          
IF @BCLTDPID = ''           
SELECT @BCLTDPID = '%'          
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED          
SELECT D.SCRIP_CD, D.SERIES,SCHEME_NAME=sec_name,D.PARTY_CODE,C1.LONG_NAME,SETT_NO, SETT_TYPE, QTY=SUM(QTY),CERTNO,BDPID,BCLTDPID,    
HOLDQTY=(CASE WHEN @STATUSID = 'BROKER' THEN SUM(CASE WHEN TRTYPE <> 909 THEN QTY ELSE 0 END) ELSE SUM(QTY) END),     
PLEDGEQTY=(CASE WHEN @STATUSID = 'BROKER' THEN SUM(CASE WHEN TRTYPE = 909 THEN QTY ELSE 0 END) ELSE 0 END)    
FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER M          
WHERE BDPID LIKE @BDPID+'%' AND BCLTDPID LIKE @BCLTDPID+'%' AND C1.CL_CODE = C2.CL_CODE AND D.PARTY_CODE = C2.PARTY_CODE          
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY          
AND D.SCRIP_CD BETWEEN @FROMSCRIP AND @TOSCRIP AND DRCR = 'D' AND FILLER2 = 1  AND DELIVERED = '0'  AND TRTYPE <> 907           
AND D.PARTY_CODE <> 'BROKER' AND TRTYPE <> 906 AND CERTNO NOT LIKE 'AUCTION'          
AND C1.BRANCH_CD LIKE @BRANCH        
AND C1.BRANCH_CD LIKE (CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE '%' END)           
AND C1.SUB_BROKER LIKE (CASE WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME ELSE '%' END)          
AND C1.TRADER LIKE (CASE WHEN @STATUSID = 'TRADER' THEN @STATUSNAME ELSE '%' END)          
AND C1.FAMILY LIKE (CASE WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME ELSE '%' END)          
AND C1.REGION LIKE (CASE WHEN @STATUSID = 'REGION' THEN @STATUSNAME ELSE '%' END)          
AND C1.AREA LIKE (CASE WHEN @STATUSID = 'AREA' THEN @STATUSNAME ELSE '%' END)          
AND C2.PARTY_CODE LIKE (CASE WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME ELSE '%' END)     
AND D.SCRIP_CD = M.SCRIP_CD AND D.SERIES = M.SERIES
GROUP BY D.SCRIP_CD,CERTNO, D.SERIES ,sec_name,D.PARTY_CODE,C1.LONG_NAME, SETT_NO, SETT_TYPE,BDPID,BCLTDPID HAVING SUM(QTY) > 0           
ORDER BY sec_name,D.SCRIP_CD,D.SERIES,D.PARTY_CODE,SETT_NO, SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELHOLDSUM
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_NSEDELHOLDSUM] (      
@STATUSID VARCHAR(15),@STATUSNAME VARCHAR(25),@HOLDDATE VARCHAR(11),@BDPID VARCHAR(8),@BCLTDPID VARCHAR(16))      
AS      
SELECT D.SCRIP_CD, D.SERIES, SCHEME_NAME=SEC_NAME, CERTNO ,SETT_NO, SETT_TYPE,QTY=SUM(QTY) FROM DELTRANS D,    
CLIENT1 C1,CLIENT2 C2, MFSS_SCRIP_MASTER M    
WHERE BDPID = @BDPID AND BCLTDPID = @BCLTDPID       
AND C1.CL_CODE = C2.CL_CODE AND C2.PARTY_CODE = D.PARTY_CODE    
AND FILLER2 = 1 AND DRCR = 'D' AND DELIVERED = '0' AND TRTYPE IN(904,905,909)    
AND SHARETYPE <> 'AUCTION'    
AND @STATUSNAME =     
   (CASE     
         WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD    
         WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER    
         WHEN @STATUSID = 'TRADER' THEN C1.TRADER    
         WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY    
         WHEN @STATUSID = 'AREA' THEN C1.AREA    
         WHEN @STATUSID = 'REGION' THEN C1.REGION    
         WHEN @STATUSID = 'CLIENT' THEN C2.PARTY_CODE    
   ELSE     
         'BROKER'    
   END)    
AND M.SCRIP_CD = D.SCRIP_CD  AND M.SERIES = D.SERIES         
GROUP BY D.SCRIP_CD, D.SERIES, SEC_NAME, CERTNO , SETT_NO, SETT_TYPE HAVING SUM(QTY) > 0       
ORDER BY SEC_NAME, D.SCRIP_CD, D.SERIES,CERTNO,SETT_NO,SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelListAsc
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.Rpt_NSEDelListAsc    Script Date: 12/16/2003 2:31:23 PM ******/  
  
CREATE  Proc [dbo].[Rpt_NSEDelListAsc] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )  
as   
If @statusid = 'broker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 order by D.Party_Code ASC  
End  
If @statusid = 'branch'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, branches br    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and br.short_name = c1.trader and br.branch_cd = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'subbroker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, subbrokers sb  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'trader'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.trader = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'client'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c2.party_code = @statusname  
 order by D.Party_Code ASC  
End  
If @statusid = 'family'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.family = @statusname  
 order by D.Party_Code ASC  
End 
If @statusid = 'area'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.area = @statusname  
 order by D.Party_Code ASC  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelListDesc
-- --------------------------------------------------
 
CREATE  Proc [dbo].[Rpt_NSEDelListDesc] (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )  
as   
If @statusid = 'broker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 order by D.Party_Code DESC  
End  
If @statusid = 'branch'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, branches br    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and br.short_name = c1.trader and br.branch_cd = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'subbroker'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, subbrokers sb  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'trader'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.trader = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'client'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c2.party_code = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'family'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.family = @statusname  
 order by D.Party_Code DESC  
End  
If @statusid = 'area'  
Begin   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no = @settno and d.sett_type = @Sett_Type   
 and c1.area = @statusname  
 order by D.Party_Code DESC  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NSEDelScripList
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NSEDelScripList] (    
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Scrip_Cd Varchar(12),@Series Varchar(3))    
as     
select distinct d.scrip_cd,d.series,SCHEME_NAME,Qty=Sum(Case When Inout = 'I' Then d.qty Else -D.Qty End)   
from DeliveryClt D, Client2 C2, Client1 C1  
where d.sett_no like @settno and d.sett_type like @Sett_Type   
and d.scrip_cd like @Scrip_Cd and d.series like @Series    
And D.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code  
And @StatusName =   
   (case   
         when @StatusId = 'BRANCH' then c1.branch_cd  
         when @StatusId = 'SUBBROKER' then c1.sub_broker  
         when @StatusId = 'Trader' then c1.Trader  
         when @StatusId = 'Family' then c1.Family  
         when @StatusId = 'Area' then c1.Area  
         when @StatusId = 'Region' then c1.Region  
         when @StatusId = 'Client' then c2.party_code  
   else   
         'BROKER'  
   End)       
Group by SCHEME_NAME,d.scrip_cd,d.series order by SCHEME_NAME,d.scrip_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelScripWise_New
-- --------------------------------------------------
 
CREATE PROC [dbo].[Rpt_NseDelScripWise_New] (@STATUSID VARCHAR(15), @STATUSNAME VARCHAR(25),@SETT_NO VARCHAR(7), @SETT_TYPE VARCHAR(2),@PARTY_CODE VARCHAR(10),      
@SCRIP_CD VARCHAR(12), @SERIES VARCHAR(3)) AS  
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,PARTY_CODE,      
BUYQTY=SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END),      
SELLQTY=SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)     
INTO #DELCLT   
FROM DELIVERYCLT D  
WHERE  D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE  
AND D.PARTY_CODE LIKE @PARTY_CODE       
AND D.SCRIP_CD LIKE @SCRIP_CD       
AND D.SERIES LIKE @SERIES      
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,PARTY_CODE      
  
SELECT * INTO #DELTRANS  
FROM DELTRANS D  
WHERE  D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE  
AND D.PARTY_CODE LIKE @PARTY_CODE       
AND D.SCRIP_CD LIKE @SCRIP_CD       
AND D.SERIES LIKE @SERIES    
AND FILLER2 = 1  
  
SELECT * INTO #CLIENT2  
FROM CLIENT2  
WHERE PARTY_CODE IN (SELECT PARTY_CODE FROM #DELCLT  
      UNION  
      SELECT PARTY_CODE FROM #DELTRANS)  
  
SELECT * INTO #CLIENT1  
FROM CLIENT1  
WHERE CL_CODE IN (SELECT CL_CODE FROM #CLIENT2)  
  
SELECT D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,C1.SHORT_NAME,D.SCRIP_CD,D.SERIES,SCHEME_NAME,      
BUYTRADEQTY = BUYQTY, BUYRECQTY=SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) ,      
SELLTRADEQTY = SELLQTY , SELLRECQTY=SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END) ,      
BUYSHORTAGE = (CASE WHEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) > 0       
          THEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END)      
          ELSE 0 END )       
 + (CASE WHEN (SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) < 0 THEN       
  ABS(SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) ELSE 0 END),      
SELLSHORTAGE = (CASE WHEN (SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) > 0 THEN       
  ABS(SELLQTY - SUM(CASE WHEN DRCR = 'C' THEN ISNULL(DE.QTY,0) ELSE 0 END)) ELSE 0 END) +      
  (CASE WHEN BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END) < 0       
           THEN ABS(BUYQTY - SUM(CASE WHEN DRCR = 'D' THEN ISNULL(DE.QTY,0) ELSE 0 END))      
          ELSE 0 END )      
FROM #CLIENT2 C2,#CLIENT1 C1, #DELCLT D LEFT OUTER JOIN #DELTRANS DE       
ON ( DE.SETT_NO = D.SETT_NO AND DE.SETT_TYPE = D.SETT_TYPE AND DE.SCRIP_CD = D.SCRIP_CD      
AND DE.SERIES = D.SERIES AND DE.PARTY_CODE = D.PARTY_CODE AND FILLER2 = 1 )      
WHERE D.PARTY_CODE = C2.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE AND D.SETT_NO = @SETT_NO AND D.SETT_TYPE = @SETT_TYPE      
AND C1.BRANCH_CD LIKE (CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE '%' END)      
AND C1.SUB_BROKER LIKE (CASE WHEN @STATUSID = 'SUBBROKER' THEN @STATUSNAME ELSE '%' END)      
AND C1.TRADER LIKE (CASE WHEN @STATUSID = 'TRADER' THEN @STATUSNAME ELSE '%' END)      
AND C1.FAMILY LIKE (CASE WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME ELSE '%' END)      
AND D.PARTY_CODE LIKE (CASE WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME ELSE '%' END)      
AND D.PARTY_CODE LIKE @PARTY_CODE       
AND D.SCRIP_CD LIKE @SCRIP_CD       
AND D.SERIES LIKE @SERIES      
GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,C1.SHORT_NAME,D.SCRIP_CD,D.SERIES,D.BUYQTY,SELLQTY ,SCHEME_NAME

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelSettPosParty
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelSettPosParty]       
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))      
As      
  
Select *, Scripname = SCHEME_NAME Into #Del From DeliveryClt  
Where sett_no = @SettNo and sett_type = @Sett_Type       
  
select D.Party_Code,C1.Long_Name,ScripName,D.Scrip_Cd,D.Series,  
ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end )       
from #Del D, Client2 C2, Client1 C1  
Where sett_no = @SettNo and sett_type = @Sett_Type       
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code  
And @StatusName =             
                  (case             
                        when @StatusId = 'BRANCH' then c1.branch_cd            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker            
                        when @StatusId = 'Trader' then c1.Trader            
                        when @StatusId = 'Family' then c1.Family            
                        when @StatusId = 'Area' then c1.Area            
                        when @StatusId = 'Region' then c1.Region            
                        when @StatusId = 'Client' then c2.party_code            
                  else             
                        'BROKER'            
                  End)            
Order By D.Party_Code,C1.Long_Name,ScripName

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelSettPosScrip
-- --------------------------------------------------
CREATE Proc [dbo].[Rpt_NseDelSettPosScrip]     
(@StatusId Varchar(15),@StatusName Varchar(25),@SettNo Varchar(7),@Sett_Type Varchar(2))    
As    
Select *, Scripname = SCHEME_NAME Into #Del From DeliveryClt  
Where sett_no = @SettNo and sett_type = @Sett_Type       
  
select D.Party_Code,C1.Long_Name,ScripName,D.Scrip_Cd,D.Series,  
ToDelQty=(Case When Inout = 'O' then Qty Else 0 end ), ToRecQty=(Case When Inout = 'I' then Qty Else 0 end )       
from #Del D, Client2 C2, Client1 C1  
Where sett_no = @SettNo and sett_type = @Sett_Type       
And D.Party_Code = C2.Party_Code and C1.Cl_Code = C2.Cl_Code  
And @StatusName =             
                  (case             
                        when @StatusId = 'BRANCH' then c1.branch_cd            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker            
                        when @StatusId = 'Trader' then c1.Trader            
                        when @StatusId = 'Family' then c1.Family            
                        when @StatusId = 'Area' then c1.Area            
                        when @StatusId = 'Region' then c1.Region            
                        when @StatusId = 'Client' then c2.party_code            
                  else             
                        'BROKER'            
                  End)            
Order By ScripName,D.Party_Code,C1.Long_Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelTransaction
-- --------------------------------------------------

CREATE Proc [dbo].[Rpt_NseDelTransaction] (    
@StatusId Varchar(15),@StatusName Varchar(25),@FromDate varchar(11),@ToDate Varchar(11),@Party_Code Varchar(10),@Scrip_Cd Varchar(12))    
AS    
   
select D.Party_Code, c1.short_name,D.scrip_cd, D.series, SCHEME_NAME=sec_name, D.Sett_No, D.Sett_type, D.TCode, D.Qty,    
Transno = D.FolioNo, D.DrCr, D.TransDate,D.reason, D.certno, D.SlipNo,DpType,CltDpNo=CltDpId,DpId    
from deltrans D, CLient1 C1, Client2 C2, MFSS_SCRIP_MASTER M   
where c1.cl_code = c2.cl_code and c2.Party_code = d.party_code     
and D.transdate >= @FromDate and D.transdate <= @ToDate + ' 23:59:59'    
and D.Party_Code Like @Party_Code and D.Scrip_Cd like @Scrip_Cd And Filler2 = 1     
AND M.SCRIP_CD = D.SCRIP_CD  and m.series = d.series
And C1.Branch_Cd Like (Case When @StatusId = 'branch' then @Statusname else '%' End)           
And C1.Sub_broker Like (Case When @StatusId = 'subbroker' then @Statusname else '%' End)          
And C1.Trader Like (Case When @StatusId = 'trader' then @Statusname else '%' End)          
And C1.Family Like (Case When @StatusId = 'family' then @Statusname else '%' End)          
And C1.Region Like (Case When @StatusId = 'region' then @Statusname else '%' End)          
And C1.Area Like (Case When @StatusId = 'area' then @Statusname else '%' End)          
And C2.Party_Code Like (Case When @StatusId = 'client' then @Statusname else '%' End)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_NSEDELTRANSFER
-- --------------------------------------------------

CREATE PROC [dbo].[RPT_NSEDELTRANSFER]     
(@STATUSID VARCHAR(15), @STATUSNAME VARCHAR(25),     
 @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10),     
 @FROMSCRIP VARCHAR(12), @TOSCRIP VARCHAR(12),  
 @FROMDATE VARCHAR(11), @TODATE VARCHAR(11)  
)    
AS     
  
SELECT SETT_NO, SETT_TYPE, D.PARTY_CODE, C1.LONG_NAME, D.SCRIP_CD, D.SERIES, SCHEME_NAME=SEC_NAME, QTY = SUM(QTY), DPID, CLTDPID,     
TRANSDATE = LEFT(CONVERT(VARCHAR, TRANSDATE, 109), 11), BDPID, BCLTDPID, TRTYPE, ISETT_NO, ISETT_TYPE     
FROM DELTRANS D, CLIENT1 C1, CLIENT2 C2, MFSS_SCRIP_MASTER M   
WHERE DELIVERED = 'D' AND FILLER2 = 1 AND DRCR = 'D'     
AND C2.PARTY_CODE = D.PARTY_CODE AND C1.CL_CODE = C2.CL_CODE     
AND D.PARTY_CODE > = @FROMPARTY AND D.PARTY_CODE < = @TOPARTY    
AND D.SCRIP_CD > = @FROMSCRIP AND D.SCRIP_CD < = @TOSCRIP     
AND D.TRANSDATE BETWEEN @FROMDATE AND @TODATE + ' 23:59'  
AND M.SCRIP_CD = D.SCRIP_CD AND D.SERIES = M.SERIES  
GROUP BY D.PARTY_CODE, C1.LONG_NAME, D.SCRIP_CD, D.SERIES, SEC_NAME,SETT_NO, SETT_TYPE, DPID,     
CLTDPID, LEFT(CONVERT(VARCHAR, TRANSDATE, 109), 11), BDPID, BCLTDPID, TRTYPE, ISETT_NO, ISETT_TYPE     
ORDER BY D.PARTY_CODE, C1.LONG_NAME, SEC_NAME, D.SCRIP_CD, D.SERIES, SETT_NO, SETT_TYPE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_UCCFILEGENERATION
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[RPT_UCCFILEGENERATION]
	(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@PARTYFROM VARCHAR(10),
	@PARTYTO VARCHAR(10),
	@BRANCHFROM VARCHAR(10),
	@BRANCHTO VARCHAR(10),
	@CLTYPE VARCHAR(3),
	@FILETYPE CHAR(1)
	)

	AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF (@FILETYPE = 'C')
	BEGIN
		SELECT
			PARTY_CODE = PARTY_CODE,
			PARTY_NAME = LEFT(PARTY_NAME,70),
			GENDER = (CASE 
							WHEN CL_STATUS IN ('HUF','CC') THEN '' 
							ELSE GENDER 
						END),
			OCCUPATION_CODE,
			TAX_STATUS,
			PAN_NO = PAN_NO,
			KYC_FLAG,
			ADDR1 = LEFT(REPLACE(ADDR1,',',' '),40),
			ADDR2 = LEFT(REPLACE(ADDR2,',',' '),40),
			ADDR3 = LEFT(REPLACE(ADDR3,',',' '),40),
			CITY  = LEFT(REPLACE(CITY,',',' '),35),
			STATE_CODE,
			ZIP,
			OFFICE_PHONE = LEFT(REPLACE(OFFICE_PHONE,',',' '),8),
			RES_PHONE = LEFT(REPLACE(RES_PHONE,',',' '),8),
			MOBILE_NO = LEFT(REPLACE(MOBILE_NO,',',' '),10),
			EMAIL_ID = LEFT(REPLACE(EMAIL_ID,',',' '),50),
			BANK_NAME = LEFT(BANK_NAME,40),
			BANK_BRANCH = LEFT(BANK_BRANCH,40),
			BANK_CITY = LEFT(BANK_CITY,35),
			ACC_NO = LEFT(ACC_NO,40),
			PAYMODE,
			NEFTCODE = LEFT(NEFTCODE,11),
			DOB = CASE WHEN DOB ='' THEN '' ELSE CONVERT(VARCHAR,DOB,103) END,
			GAURDIAN_NAME = LEFT(GAURDIAN_NAME,35),
			GAURDIAN_PAN_NO,
			NOMINEE_NAME = LEFT(NOMINEE_NAME,40),
			NOMINEE_RELATION = LEFT(NOMINEE_RELATION,40),
			BANK_AC_TYPE,
			STAT_COMM_MODE
		FROM 
			MFSS_CLIENT (NOLOCK), 
			STATE_MASTER (NOLOCK)
		WHERE 
			MFSS_CLIENT.STATE = STATE_MASTER.STATE
			AND ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = (CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END)
		ORDER BY
			PARTY_CODE,
			PARTY_NAME
	END
	ELSE
	BEGIN
		SELECT
			D.PARTY_CODE,
			D.DP_TYPE,
			DPID = (CASE WHEN D.DP_TYPE = 'NSDL' THEN D.DPID ELSE '' END),
			BEN_ID = ISNULL(D.CLTDPID,''),
			D.MODE_HOLDING,
			PARTY_NAME = LEFT(D.PARTY_NAME,70),
			PAN_NO = D.PAN_NO,
			D.TAX_STATUS,
			D.OCCUPATION_CODE,
			DOB = (CASE WHEN D.DOB ='' THEN '' ELSE CONVERT(VARCHAR,D.DOB,103) END),
			GAURDIAN_NAME = LEFT(D.GAURDIAN_NAME,35),
			D.GAURDIAN_PAN_NO,
			HOLDER2_NAME = LEFT(D.HOLDER2_NAME,70),
			D.HOLDER2_PAN_NO,
			HOLDER3_NAME = LEFT(D.HOLDER3_NAME,70),
			D.HOLDER3_PAN_NO
		FROM 
			MFSS_DPMASTER D, MFSS_CLIENT C (NOLOCK)
		WHERE 
			D.PARTY_CODE = C.PARTY_CODE
			AND D.ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND D.PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			AND C.BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = (CASE WHEN @CLTYPE ='' THEN C.CL_TYPE ELSE @CLTYPE END)
		ORDER BY
			D.PARTY_CODE,
			D.PARTY_NAME
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_UCCFILEGENERATION_04122019
-- --------------------------------------------------


create PROCEDURE [dbo].[RPT_UCCFILEGENERATION_04122019]
	(
	@DATEFROM VARCHAR(11),
	@DATETO VARCHAR(11),
	@PARTYFROM VARCHAR(10),
	@PARTYTO VARCHAR(10),
	@BRANCHFROM VARCHAR(10),
	@BRANCHTO VARCHAR(10),
	@CLTYPE VARCHAR(3),
	@FILETYPE CHAR(1)
	)

	AS

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	IF (@FILETYPE = 'C')
	BEGIN
		SELECT
			PARTY_CODE = PARTY_CODE,
			PARTY_NAME = LEFT(PARTY_NAME,70),
			GENDER = (CASE 
							WHEN CL_STATUS IN ('HUF','CC') THEN '' 
							ELSE GENDER 
						END),
			OCCUPATION_CODE,
			TAX_STATUS,
			PAN_NO = PAN_NO,
			KYC_FLAG,
			ADDR1 = LEFT(REPLACE(ADDR1,',',' '),40),
			ADDR2 = LEFT(REPLACE(ADDR2,',',' '),40),
			ADDR3 = LEFT(REPLACE(ADDR3,',',' '),40),
			CITY  = LEFT(REPLACE(CITY,',',' '),35),
			STATE_CODE,
			ZIP,
			OFFICE_PHONE = LEFT(REPLACE(OFFICE_PHONE,',',' '),8),
			RES_PHONE = LEFT(REPLACE(RES_PHONE,',',' '),8),
			MOBILE_NO = LEFT(REPLACE(MOBILE_NO,',',' '),10),
			EMAIL_ID = LEFT(REPLACE(EMAIL_ID,',',' '),50),
			BANK_NAME = LEFT(BANK_NAME,40),
			BANK_BRANCH = LEFT(BANK_BRANCH,40),
			BANK_CITY = LEFT(BANK_CITY,35),
			ACC_NO = LEFT(ACC_NO,40),
			PAYMODE,
			NEFTCODE = LEFT(NEFTCODE,11),
			DOB = CASE WHEN DOB ='' THEN '' ELSE CONVERT(VARCHAR,DOB,103) END,
			GAURDIAN_NAME = LEFT(GAURDIAN_NAME,35),
			GAURDIAN_PAN_NO,
			NOMINEE_NAME = LEFT(NOMINEE_NAME,40),
			NOMINEE_RELATION = LEFT(NOMINEE_RELATION,40),
			BANK_AC_TYPE,
			STAT_COMM_MODE
		FROM 
			MFSS_CLIENT (NOLOCK), 
			STATE_MASTER (NOLOCK),
			clientsureshmfss (NOLOCK)
		WHERE 
			MFSS_CLIENT.STATE = STATE_MASTER.STATE
			AND ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			and PARTY_CODE=partycode
			AND BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = (CASE WHEN @CLTYPE ='' THEN CL_TYPE ELSE @CLTYPE END)
		ORDER BY
			PARTY_CODE,
			PARTY_NAME
	END
	ELSE
	BEGIN
		SELECT
			D.PARTY_CODE,
			D.DP_TYPE,
			DPID = (CASE WHEN D.DP_TYPE = 'NSDL' THEN D.DPID ELSE '' END),
			BEN_ID = ISNULL(D.CLTDPID,''),
			D.MODE_HOLDING,
			PARTY_NAME = LEFT(D.PARTY_NAME,70),
			PAN_NO = D.PAN_NO,
			D.TAX_STATUS,
			D.OCCUPATION_CODE,
			DOB = (CASE WHEN D.DOB ='' THEN '' ELSE CONVERT(VARCHAR,D.DOB,103) END),
			GAURDIAN_NAME = LEFT(D.GAURDIAN_NAME,35),
			D.GAURDIAN_PAN_NO,
			HOLDER2_NAME = LEFT(D.HOLDER2_NAME,70),
			D.HOLDER2_PAN_NO,
			HOLDER3_NAME = LEFT(D.HOLDER3_NAME,70),
			D.HOLDER3_PAN_NO
		FROM 
			MFSS_DPMASTER D, MFSS_CLIENT C (NOLOCK),
			clientsureshmfss (NOLOCK)
		WHERE 
			D.PARTY_CODE = C.PARTY_CODE
			AND D.ADDEDON BETWEEN @DATEFROM AND @DATETO + ' 23:59'
			AND D.PARTY_CODE BETWEEN @PARTYFROM AND @PARTYTO
			and c.PARTY_CODE=partycode
			AND C.BRANCH_CD BETWEEN @BRANCHFROM AND @BRANCHTO
			AND CL_TYPE = (CASE WHEN @CLTYPE ='' THEN C.CL_TYPE ELSE @CLTYPE END)
		ORDER BY
			D.PARTY_CODE,
			D.PARTY_NAME
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Searchinall
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Searchinall]       
(@strFind AS VARCHAR(MAX))
AS
BEGIN
    SET NOCOUNT ON; 
    --TO FIND STRING IN ALL PROCEDURES        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) SP_Name
              ,OBJECT_DEFINITION(OBJECT_ID) SP_Definition
        FROM   sys.procedures
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@strFind+'%'
    END 

    --TO FIND STRING IN ALL VIEWS        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) View_Name
              ,OBJECT_DEFINITION(OBJECT_ID) View_Definition
        FROM   sys.views
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@strFind+'%'
    END 

    --TO FIND STRING IN ALL FUNCTION        
    BEGIN
        SELECT ROUTINE_NAME           Function_Name
              ,ROUTINE_DEFINITION     Function_definition
        FROM   INFORMATION_SCHEMA.ROUTINES
        WHERE  ROUTINE_DEFINITION LIKE '%'+@strFind+'%'
               AND ROUTINE_TYPE = 'FUNCTION'
        ORDER BY
               ROUTINE_NAME
    END

    --TO FIND STRING IN ALL TABLES OF DATABASE.    
    BEGIN
        SELECT t.name      AS Table_Name
              ,c.name      AS COLUMN_NAME
        FROM   sys.tables  AS t
               INNER JOIN sys.columns c
                    ON  t.OBJECT_ID = c.OBJECT_ID
        WHERE  c.name LIKE '%'+@strFind+'%'
        ORDER BY
               Table_Name
    END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP
-- --------------------------------------------------
CREATE PROC SP @spName VARCHAR(25)AS             
Select * from sysobjects where name Like '%' + @spName + '%' and xtype='P' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDBRANCH_EXECUTE
-- --------------------------------------------------
CREATE PROC SP_ADDBRANCH_EXECUTE    
@STRSQL VARCHAR(8000)    
AS    
PRINT @STRSQL    
EXEC (@STRSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDCLIENT_EXECUTE
-- --------------------------------------------------
CREATE PROC SP_ADDCLIENT_EXECUTE    
@STRSQL VARCHAR(8000)    
AS    
PRINT @STRSQL    
EXEC (@STRSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_ADDEDITSCRIP_EXECUTE
-- --------------------------------------------------
--  Alter this sp under SRE-34143
CREATE PROC [dbo].[SP_ADDEDITSCRIP_EXECUTE]  
@STRSQL VARCHAR(8000)  
AS  
SET NOCOUNT ON;
PRINT @STRSQL  
EXEC (@STRSQL)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_generate_inserts
-- --------------------------------------------------
    
----------------------------------------------------------------------------------------------------------------------     
-- http://vyaskn.tripod.com/code.htm#inserts     
------------------------------------------------------------------------------------------------------------------------     
--SET NOCOUNT ON     
--GO     
--     
--PRINT 'Using Master database'     
--USE master     
--GO     
--     
--PRINT 'Checking for the existence of this procedure'     
--IF (SELECT OBJECT_ID('sp_generate_inserts','P')) IS NOT NULL --means, the procedure already exists     
-- BEGIN     
-- PRINT 'Procedure already exists. So, dropping it'     
-- DROP PROC sp_generate_inserts     
-- END     
--GO     
--     
----Turn system object marking on     
--EXEC master.dbo.sp_MS_upd_sysobj_category 1     
--GO     
    
CREATE PROC [dbo].[sp_generate_inserts]     
(     
@table_name varchar(776), -- The table/view for which the INSERT statements will be generated using the existing data     
@target_table varchar(776) = NULL, -- Use this parameter to specify a different table name into which the data will be inserted     
@include_column_list bit = 1, -- Use this parameter to include/ommit column list in the generated INSERT statement     
@from varchar(800) = NULL, -- Use this parameter to filter the rows based on a filter condition (using WHERE)     
@include_timestamp bit = 0, -- Specify 1 for this parameter, if you want to include the TIMESTAMP/ROWVERSION column's data in the INSERT statement     
@debug_mode bit = 0, -- If @debug_mode is set to 1, the SQL statements constructed by this procedure will be printed for later examination     
@owner varchar(64) = NULL, -- Use this parameter if you are not the owner of the table     
@ommit_images bit = 0, -- Use this parameter to generate INSERT statements by omitting the 'image' columns     
@ommit_identity bit = 0, -- Use this parameter to ommit the identity columns     
@top int = NULL, -- Use this parameter to generate INSERT statements only for the TOP n rows     
@cols_to_include varchar(8000) = NULL, -- List of columns to be included in the INSERT statement     
@cols_to_exclude varchar(8000) = NULL, -- List of columns to be excluded from the INSERT statement     
@disable_constraints bit = 0, -- When 1, disables foreign key constraints and enables them after the INSERT statements     
@ommit_computed_cols bit = 0 -- When 1, computed columns will not be included in the INSERT statement     
)     
AS     
BEGIN     
/***********************************************************************************************************     
Procedure: sp_generate_inserts (Build 22)     
(Copyright  2002 Narayana Vyas Kondreddi. All rights reserved.)     
Purpose: To generate INSERT statements from existing data.     
These INSERTS can be executed to regenerate the data at some other location.     
This procedure is also useful to create a database setup, where in you can     
script your data along with your table definitions.     
Written by: Narayana Vyas Kondreddi     
http://vyaskn.tripod.com     
Acknowledgements:     
Divya Kalra -- For beta testing     
Mark Charsley -- For reporting a problem with scripting uniqueidentifier columns with NULL values     
Artur Zeygman -- For helping me simplify a bit of code for handling non-dbo owned tables     
Joris Laperre -- For reporting a regression bug in handling text/ntext columns     
Tested on: SQL Server 7.0 and SQL Server 2000     
Date created: January 17th 2001 21:52 GMT     
Date modified: May 1st 2002 19:50 GMT     
Email: vyaskn@hotmail.com     
NOTE: This procedure may not work with tables with too many columns.     
Results can be unpredictable with huge text columns or SQL Server 2000's sql_variant data types     
Whenever possible, Use @include_column_list parameter to ommit column list in the INSERT statement, for better results     
IMPORTANT: This procedure is not tested with internation data (Extended characters or Unicode). If needed     
you might want to convert the datatypes of character variables in this procedure to their respective unicode counterparts     
like nchar and nvarchar     
Example 1: To generate INSERT statements for table 'titles':     
EXEC sp_generate_inserts 'titles'     
Example 2: To ommit the column list in the INSERT statement: (Column list is included by default)     
IMPORTANT: If you have too many columns, you are advised to ommit column list, as shown below,     
to avoid erroneous results     
EXEC sp_generate_inserts 'titles', @include_column_list = 0     
Example 3: To generate INSERT statements for 'titlesCopy' table from 'titles' table:     
EXEC sp_generate_inserts 'titles', 'titlesCopy'     
Example 4: To generate INSERT statements for 'titles' table for only those titles     
which contain the word 'Computer' in them:     
NOTE: Do not complicate the FROM or WHERE clause here. It's assumed that you are good with T-SQL if you are using this parameter     
EXEC sp_generate_inserts 'titles', @from = "from titles where title like '%Computer%'"     
Example 5: To specify that you want to include TIMESTAMP column's data as well in the INSERT statement:     
(By default TIMESTAMP column's data is not scripted)     
EXEC sp_generate_inserts 'titles', @include_timestamp = 1     
Example 6: To print the debug information:     
EXEC sp_generate_inserts 'titles', @debug_mode = 1     
Example 7: If you are not the owner of the table, use @owner parameter to specify the owner name     
To use this option, you must have SELECT permissions on that table     
EXEC sp_generate_inserts Nickstable, @owner = 'Nick'     
Example 8: To generate INSERT statements for the rest of the columns excluding images     
When using this otion, DO NOT set @include_column_list parameter to 0.     
EXEC sp_generate_inserts imgtable, @ommit_images = 1     
Example 9: To generate INSERT statements excluding (ommiting) IDENTITY columns:     
(By default IDENTITY columns are included in the INSERT statement)     
EXEC sp_generate_inserts mytable, @ommit_identity = 1     
Example 10: To generate INSERT statements for the TOP 10 rows in the table:     
EXEC sp_generate_inserts mytable, @top = 10     
Example 11: To generate INSERT statements with only those columns you want:     
EXEC sp_generate_inserts titles, @cols_to_include = "'title','title_id','au_id'"     
Example 12: To generate INSERT statements by omitting certain columns:     
EXEC sp_generate_inserts titles, @cols_to_exclude = "'title','title_id','au_id'"     
Example 13: To avoid checking the foreign key constraints while loading data with INSERT statements:     
EXEC sp_generate_inserts titles, @disable_constraints = 1     
Example 14: To exclude computed columns from the INSERT statement:     
EXEC sp_generate_inserts MyTable, @ommit_computed_cols = 1     
***********************************************************************************************************/     
SET NOCOUNT ON     
--Making sure user only uses either @cols_to_include or @cols_to_exclude     
IF ((@cols_to_include IS NOT NULL) AND (@cols_to_exclude IS NOT NULL))     
BEGIN     
RAISERROR('Use either @cols_to_include or @cols_to_exclude. Do not use both the parameters at once',16,1)     
RETURN -1 --Failure. Reason: Both @cols_to_include and @cols_to_exclude parameters are specified     
END     
--Making sure the @cols_to_include and @cols_to_exclude parameters are receiving values in proper format     
IF ((@cols_to_include IS NOT NULL) AND (PATINDEX('''%''',@cols_to_include) = 0))     
BEGIN     
RAISERROR('Invalid use of @cols_to_include property',16,1)     
PRINT 'Specify column names surrounded by single quotes and separated by commas'     
PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_include = "''title_id'',''title''"'     
RETURN -1 --Failure. Reason: Invalid use of @cols_to_include property     
END     
IF ((@cols_to_exclude IS NOT NULL) AND (PATINDEX('''%''',@cols_to_exclude) = 0))     
BEGIN     
RAISERROR('Invalid use of @cols_to_exclude property',16,1)     
PRINT 'Specify column names surrounded by single quotes and separated by commas'     
PRINT 'Eg: EXEC sp_generate_inserts titles, @cols_to_exclude = "''title_id'',''title''"'     
RETURN -1 --Failure. Reason: Invalid use of @cols_to_exclude property     
END     
--Checking to see if the database name is specified along wih the table name     
--Your database context should be local to the table for which you want to generate INSERT statements     
--specifying the database name is not allowed     
IF (PARSENAME(@table_name,3)) IS NOT NULL     
BEGIN     
RAISERROR('Do not specify the database name. Be in the required database and just specify the table name.',16,1)     
RETURN -1 --Failure. Reason: Database name is specified along with the table name, which is not allowed     
END     
--Checking for the existence of 'user table' or 'view'     
--This procedure is not written to work on system tables     
--To script the data in system tables, just create a view on the system tables and script the view instead     
IF @owner IS NULL     
BEGIN     
IF ((OBJECT_ID(@table_name,'U') IS NULL) AND (OBJECT_ID(@table_name,'V') IS NULL))     
BEGIN     
RAISERROR('User table or view not found.',16,1)     
PRINT 'You may see this error, if you are not the owner of this table or view. In that case use @owner parameter to specify the owner name.'     
PRINT 'Make sure you have SELECT permission on that table or view.'     
RETURN -1 --Failure. Reason: There is no user table or view with this name     
END     
END     
ELSE     
BEGIN     
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name AND (TABLE_TYPE = 'BASE TABLE' OR TABLE_TYPE = 'VIEW') AND TABLE_SCHEMA = @owner)     
BEGIN     
RAISERROR('User table or view not found.',16,1)     
PRINT 'You may see this error, if you are not the owner of this table. In that case use @owner parameter to specify the owner name.'     
PRINT 'Make sure you have SELECT permission on that table or view.'     
RETURN -1 --Failure. Reason: There is no user table or view with this name     
END     
END     
--Variable declarations     
DECLARE @Column_ID int,     
@Column_List varchar(8000),     
@Column_Name varchar(128),     
@Start_Insert varchar(786),     
@Data_Type varchar(128),     
@Actual_Values varchar(8000), --This is the string that will be finally executed to generate INSERT statements     
@IDN varchar(128) --Will contain the IDENTITY column's name in the table     
--Variable Initialization     
SET @IDN = ''     
SET @Column_ID = 0     
SET @Column_Name = ''     
SET @Column_List = ''     
SET @Actual_Values = ''     
IF @owner IS NULL     
BEGIN     
SET @Start_Insert = 'INSERT INTO ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']'     
END     
ELSE     
BEGIN     
SET @Start_Insert = 'INSERT ' + '[' + LTRIM(RTRIM(@owner)) + '].' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']'     
END     
--To get the first column's ID     
SELECT @Column_ID = MIN(ORDINAL_POSITION)     
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
WHERE TABLE_NAME = @table_name AND     
(@owner IS NULL OR TABLE_SCHEMA = @owner)     
--Loop through all the columns of the table, to get the column names and their data types     
WHILE @Column_ID IS NOT NULL     
BEGIN     
SELECT @Column_Name = QUOTENAME(COLUMN_NAME),     
@Data_Type = DATA_TYPE     
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
WHERE ORDINAL_POSITION = @Column_ID AND     
TABLE_NAME = @table_name AND     
(@owner IS NULL OR TABLE_SCHEMA = @owner)     
IF @cols_to_include IS NOT NULL --Selecting only user specified columns     
BEGIN     
IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_include) = 0     
BEGIN     
GOTO SKIP_LOOP     
END     
END     
IF @cols_to_exclude IS NOT NULL --Selecting only user specified columns     
BEGIN     
IF CHARINDEX( '''' + SUBSTRING(@Column_Name,2,LEN(@Column_Name)-2) + '''',@cols_to_exclude) <> 0     
BEGIN     
GOTO SKIP_LOOP     
END     
END     
--Making sure to output SET IDENTITY_INSERT ON/OFF in case the table has an IDENTITY column     
IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsIdentity')) = 1     
BEGIN     
IF @ommit_identity = 0 --Determing whether to include or exclude the IDENTITY column     
SET @IDN = @Column_Name     
ELSE     
GOTO SKIP_LOOP     
END     
--Making sure whether to output computed columns or not     
IF @ommit_computed_cols = 1     
BEGIN     
IF (SELECT COLUMNPROPERTY( OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name),SUBSTRING(@Column_Name,2,LEN(@Column_Name) - 2),'IsComputed')) = 1     
BEGIN     
GOTO SKIP_LOOP     
END     
END     
--Tables with columns of IMAGE data type are not supported for obvious reasons     
IF(@Data_Type in ('image'))     
BEGIN     
IF (@ommit_images = 0)     
BEGIN     
RAISERROR('Tables with image columns are not supported.',16,1)     
PRINT 'Use @ommit_images = 1 parameter to generate INSERTs for the rest of the columns.'     
PRINT 'DO NOT ommit Column List in the INSERT statements. If you ommit column list using @include_column_list=0, the generated INSERTs will fail.'     
RETURN -1 --Failure. Reason: There is a column with image data type     
END     
ELSE     
BEGIN     
GOTO SKIP_LOOP     
END     
END     
--Determining the data type of the column and depending on the data type, the VALUES part of     
--the INSERT statement is generated. Care is taken to handle columns with NULL values. Also     
--making sure, not to lose any data from flot, real, money, smallmomey, datetime columns     
SET @Actual_Values = @Actual_Values +     
CASE     
WHEN @Data_Type IN ('char','varchar','nchar','nvarchar')     
THEN     
'COALESCE('''''''' + REPLACE(RTRIM(' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'     
WHEN @Data_Type IN ('datetime','smalldatetime')     
THEN     
'COALESCE('''''''' + RTRIM(CONVERT(char,' + @Column_Name + ',109))+'''''''',''NULL'')'     
WHEN @Data_Type IN ('uniqueidentifier')     
THEN     
'COALESCE('''''''' + REPLACE(CONVERT(char(255),RTRIM(' + @Column_Name + ')),'''''''','''''''''''')+'''''''',''NULL'')'     
WHEN @Data_Type IN ('text','ntext')     
THEN     
'COALESCE('''''''' + REPLACE(CONVERT(char(8000),' + @Column_Name + '),'''''''','''''''''''')+'''''''',''NULL'')'     
WHEN @Data_Type IN ('binary','varbinary')     
THEN     
'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'     
WHEN @Data_Type IN ('timestamp','rowversion')     
THEN     
CASE     
WHEN @include_timestamp = 0     
THEN     
'''DEFAULT'''     
ELSE     
'COALESCE(RTRIM(CONVERT(char,' + 'CONVERT(int,' + @Column_Name + '))),''NULL'')'     
END     
WHEN @Data_Type IN ('float','real','money','smallmoney')     
THEN     
'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ',2)' + ')),''NULL'')'     
ELSE     
'COALESCE(LTRIM(RTRIM(' + 'CONVERT(char, ' + @Column_Name + ')' + ')),''NULL'')'     
END + '+' + ''',''' + ' + '     
--Generating the column list for the INSERT statement     
SET @Column_List = @Column_List + @Column_Name + ','     
SKIP_LOOP: --The label used in GOTO     
SELECT @Column_ID = MIN(ORDINAL_POSITION)     
FROM INFORMATION_SCHEMA.COLUMNS (NOLOCK)     
WHERE TABLE_NAME = @table_name AND     
ORDINAL_POSITION > @Column_ID AND     
(@owner IS NULL OR TABLE_SCHEMA = @owner)     
--Loop ends here!     
END     
--To get rid of the extra characters that got concatenated during the last run through the loop     
SET @Column_List = LEFT(@Column_List,len(@Column_List) - 1)     
SET @Actual_Values = LEFT(@Actual_Values,len(@Actual_Values) - 6)     
IF LTRIM(@Column_List) = ''     
BEGIN     
RAISERROR('No columns to select. There should at least be one column to generate the output',16,1)     
RETURN -1 --Failure. Reason: Looks like all the columns are ommitted using the @cols_to_exclude parameter     
END     
--Forming the final string that will be executed, to output the INSERT statements     
IF (@include_column_list <> 0)     
BEGIN     
SET @Actual_Values =     
'SELECT ' +     
CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +     
'''' + RTRIM(@Start_Insert) +     
' ''+' + '''(' + RTRIM(@Column_List) + '''+' + ''')''' +     
' +''VALUES(''+ ' + @Actual_Values + '+'')''' + ' ' +     
COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')     
END     
ELSE IF (@include_column_list = 0)     
BEGIN     
SET @Actual_Values =     
'SELECT ' +     
CASE WHEN @top IS NULL OR @top < 0 THEN '' ELSE ' TOP ' + LTRIM(STR(@top)) + ' ' END +     
'''' + RTRIM(@Start_Insert) +     
' '' +''VALUES(''+ ' + @Actual_Values + '+'')''' + ' ' +     
COALESCE(@from,' FROM ' + CASE WHEN @owner IS NULL THEN '' ELSE '[' + LTRIM(RTRIM(@owner)) + '].' END + '[' + rtrim(@table_name) + ']' + '(NOLOCK)')     
END     
--Determining whether to ouput any debug information     
IF @debug_mode =1     
BEGIN     
PRINT '/*****START OF DEBUG INFORMATION*****'     
PRINT 'Beginning of the INSERT statement:'     
PRINT @Start_Insert     
PRINT ''     
PRINT 'The column list:'     
PRINT @Column_List     
PRINT ''     
PRINT 'The SELECT statement executed to generate the INSERTs'     
PRINT @Actual_Values     
PRINT ''     
PRINT '*****END OF DEBUG INFORMATION*****/'     
PRINT ''     
END     
PRINT '--INSERTs generated by ''sp_generate_inserts'' stored procedure written by Vyas'     
PRINT '--Build number: 22'     
PRINT '--Problems/Suggestions? Contact Vyas @ vyaskn@hotmail.com'     
PRINT '--http://vyaskn.tripod.com'     
PRINT ''     
PRINT 'SET NOCOUNT ON'     
PRINT ''     
--Determining whether to print IDENTITY_INSERT or not     
IF (@IDN <> '')     
BEGIN     
PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' ON'     
PRINT 'GO'     
PRINT ''     
END     
IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)     
BEGIN     
IF @owner IS NULL     
BEGIN     
SELECT 'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'     
END     
ELSE     
BEGIN     
SELECT 'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' NOCHECK CONSTRAINT ALL' AS '--Code to disable constraints temporarily'     
END     
PRINT 'GO'     
END     
PRINT ''     
PRINT 'PRINT ''Inserting values into ' + '[' + RTRIM(COALESCE(@target_table,@table_name)) + ']' + ''''     
--All the hard work pays off here!!! You'll get your INSERT statements, when the next line executes!     
EXEC (@Actual_Values)     
PRINT 'PRINT ''Done'''     
PRINT ''     
IF @disable_constraints = 1 AND (OBJECT_ID(QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + @table_name, 'U') IS NOT NULL)     
BEGIN     
IF @owner IS NULL     
BEGIN     
SELECT 'ALTER TABLE ' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'     
END     
ELSE     
BEGIN     
SELECT 'ALTER TABLE ' + QUOTENAME(@owner) + '.' + QUOTENAME(COALESCE(@target_table, @table_name)) + ' CHECK CONSTRAINT ALL' AS '--Code to enable the previously disabled constraints'     
END     
PRINT 'GO'     
END     
PRINT ''     
IF (@IDN <> '')     
BEGIN     
PRINT 'SET IDENTITY_INSERT ' + QUOTENAME(COALESCE(@owner,USER_NAME())) + '.' + QUOTENAME(@table_name) + ' OFF'     
PRINT 'GO'     
END     
PRINT 'SET NOCOUNT OFF'     
SET NOCOUNT OFF     
RETURN 0 --Success. We are done!     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_MENU_RIGHTS
-- --------------------------------------------------
   CREATE PROC SP_MENU_RIGHTS   
(  
 @NOPT INT,   
 @VALIDDATE VARCHAR(20)='',  
 @NALERT INT=0  
)  
as   
  
CREATE TABLE #VERSION  
(  
  ERRCODE1 VARCHAR(100),    
  ERRCODE2 VARCHAR(20),    
  ERRCODE3 VARCHAR(2),    
  ERRCODE4 VARCHAR(10),    
  ERRCODE5 VARCHAR(10),    
  ERRCODE6 VARCHAR(100),    
  ERRCODE7 VARCHAR(100),    
  ERRCODE8 VARCHAR(100),    
  ERRCODE9 VARCHAR(100),    
  ERRCODE10 VARCHAR(10),    
  ERRCODE11 VARCHAR(100),   
  ERRCODE12 VARCHAR(100),  
  ERRCODE13 VARCHAR(100),    
  ERRCODE14 VARCHAR(100)    
)  
  
INSERT INTO #VERSION EXEC CHECKVERSION  
  
IF @NOPT =1  
BEGIN  
 SELECT ERRCODE2,ERRCODE3 FROM #VERSION  
END  
ELSE  
BEGIN  
  
 SELECT CASE  
  WHEN DATEDIFF(D,GETDATE(),@VALIDDATE)- @NALERT < 0  
  THEN ERRCODE7 + ' ' + @VALIDDATE  
  WHEN  CONVERT(VARCHAR,GETDATE(),112) >= CONVERT(VARCHAR,CONVERT(DATETIME,@VALIDDATE,112),112)  
  THEN ERRCODE6  
  ELSE ''   
 END AS USERMSG  
 FROM #VERSION   
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Tbl
-- --------------------------------------------------

CREATE PROC Tbl @TblName VARCHAR(25)AS           
Select * from sysobjects where name Like '%' + @TblName + '%' and xtype='U' Order By Name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_getJobStatus
-- --------------------------------------------------

    
create  PROCEDURE  usp_getJobStatus     
                          @JobName NVARCHAR (1000)    
    
    AS    
    
    
    ---exec usp_getJobStatus 'AUTO PROCESS SETTLEMENT_'
DECLARE @DEL_JOB_NAME NVARCHAR (1000)    
    
DECLARE @JOBCURSOR CURSOR,    
  @SQL VARCHAR(MAX)    
    
        IF OBJECT_ID('TempDB..#JobResults','U') IS NOT NULL DROP TABLE #JobResults    
        CREATE TABLE #JobResults ( Job_ID   UNIQUEIDENTIFIER NOT NULL,     
                                   Last_Run_Date         INT NOT NULL,     
                                   Last_Run_Time         INT NOT NULL,     
                                   Next_Run_date         INT NOT NULL,     
                                   Next_Run_Time         INT NOT NULL,     
                                   Next_Run_Schedule_ID  INT NOT NULL,     
                                   Requested_to_Run      INT NOT NULL,    
                                   Request_Source        INT NOT NULL,     
                                   Request_Source_id     SYSNAME     
                                   COLLATE Database_Default      NULL,     
                                   Running               INT NOT NULL,    
                                   Current_Step          INT NOT NULL,     
                                   Current_Retry_Attempt INT NOT NULL,     
                                   Job_State             INT NOT NULL )     
    
        INSERT  #JobResults     
        EXECUTE master.dbo.xp_sqlagent_enum_jobs 1, '';     
        
        SELECT  job.name                                                AS [Job_Name],     
             CASE     
                WHEN r.running = 0 THEN    
                    CASE     
                        WHEN jobInfo.lASt_run_outcome = 0 THEN 'Failed'    
                        WHEN jobInfo.lASt_run_outcome = 1 THEN 'Success'    
                        WHEN jobInfo.lASt_run_outcome = 3 THEN 'Canceled'    
                        ELSE 'Unknown'    
                    END    
                        WHEN r.job_state = 0 THEN 'Success'    
                        WHEN r.job_state = 4 THEN 'Success'    
                        WHEN r.job_state = 5 THEN 'Success'    
                        WHEN r.job_state = 1 THEN 'In Progress'    
                        WHEN r.job_state = 2 THEN 'In Progress'    
                        WHEN r.job_state = 3 THEN 'In Progress'    
                        WHEN r.job_state = 7 THEN 'In Progress'    
                     ELSE 'Unknown' END                                 AS [Run_Status_Description]    
  INTO #DELJOB    
        FROM    #JobResults AS r     
            LEFT OUTER JOIN msdb.dbo.sysjobservers AS jobInfo     
               ON r.job_id = jobInfo.job_id     
            INNER JOIN msdb.dbo.sysjobs AS job     
               ON r.job_id = job.job_id   
                 
        WHERE   job.[enabled] = 1    
                AND  job.name LIKE '%' + @JobName + '%'    
    and jobInfo.lASt_run_outcome = 0    
    
  SET @JOBCURSOR = CURSOR FOR    
  SELECT top 1000 Job_Name FROM #DELJOB    
  OPEN @JOBCURSOR    
  FETCH NEXT FROM @JOBCURSOR INTO @DEL_JOB_NAME    
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
   SET @SQL = 'execute msdb..sp_delete_job @job_name=''' + @DEL_JOB_NAME + ''''    
   EXEC (@SQL)    
   --PRINT @SQL 
   FETCH NEXT FROM @JOBCURSOR INTO @DEL_JOB_NAME    
  END    
  CLOSE @JOBCURSOR    
  DEALLOCATE @JOBCURSOR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.V2_UPDATE_PASSWORD
-- --------------------------------------------------



CREATE  PROC V2_UPDATE_PASSWORD
(
	@PASSWORD VARCHAR(15),
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
-- TABLE dbo.ACCBILL
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCBILL]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Start_Date] DATETIME NOT NULL,
    [End_Date] DATETIME NOT NULL,
    [Payin_Date] DATETIME NOT NULL,
    [Payout_Date] DATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCBILL_BKUP_28JUL20
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCBILL_BKUP_28JUL20]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Start_Date] DATETIME NOT NULL,
    [End_Date] DATETIME NOT NULL,
    [Payin_Date] DATETIME NOT NULL,
    [Payout_Date] DATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AREA
-- --------------------------------------------------
CREATE TABLE [dbo].[AREA]
(
    [AREACODE] VARCHAR(20) NULL,
    [DESCRIPTION] VARCHAR(50) NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.awsdms_truncation_safeguard
-- --------------------------------------------------
CREATE TABLE [dbo].[awsdms_truncation_safeguard]
(
    [latchTaskName] VARCHAR(128) NOT NULL,
    [latchMachineGUID] VARCHAR(40) NOT NULL,
    [LatchKey] CHAR(1) NOT NULL,
    [latchLocker] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BAK_CONTGEN_31032020
-- --------------------------------------------------
CREATE TABLE [dbo].[BAK_CONTGEN_31032020]
(
    [Contractno] VARCHAR(7) NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BANK
-- --------------------------------------------------
CREATE TABLE [dbo].[BANK]
(
    [BankId] VARCHAR(16) NOT NULL,
    [BankName] VARCHAR(60) NULL,
    [address1] VARCHAR(60) NULL,
    [address2] VARCHAR(60) NULL,
    [city] VARCHAR(40) NULL,
    [pincode] VARCHAR(20) NULL,
    [phone1] VARCHAR(20) NULL,
    [phone2] VARCHAR(20) NULL,
    [phone3] VARCHAR(20) NULL,
    [phone4] VARCHAR(20) NULL,
    [fax1] VARCHAR(40) NULL,
    [fax2] VARCHAR(20) NULL,
    [email] VARCHAR(50) NULL,
    [BankType] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BRANCH
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCH]
(
    [BRANCH_CODE] VARCHAR(20) NOT NULL,
    [BRANCH] VARCHAR(80) NULL,
    [LONG_NAME] VARCHAR(100) NULL,
    [ADDRESS1] VARCHAR(100) NULL,
    [ADDRESS2] VARCHAR(100) NULL,
    [CITY] VARCHAR(40) NULL,
    [STATE] VARCHAR(30) NULL,
    [NATION] VARCHAR(30) NULL,
    [ZIP] VARCHAR(30) NULL,
    [PHONE1] VARCHAR(30) NULL,
    [PHONE2] VARCHAR(30) NULL,
    [FAX] VARCHAR(30) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [REMOTE] BIT NOT NULL,
    [SECURITY_NET] BIT NOT NULL,
    [MONEY_NET] BIT NOT NULL,
    [EXCISE_REG] VARCHAR(60) NULL,
    [CONTACT_PERSON] VARCHAR(150) NULL,
    [PREFIX] VARCHAR(3) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BRANCHES
-- --------------------------------------------------
CREATE TABLE [dbo].[BRANCHES]
(
    [BRANCH_CD] VARCHAR(50) NOT NULL,
    [SHORT_NAME] VARCHAR(20) NOT NULL,
    [LONG_NAME] VARCHAR(50) NULL,
    [ADDRESS1] VARCHAR(25) NULL,
    [ADDRESS2] VARCHAR(25) NULL,
    [CITY] VARCHAR(20) NULL,
    [STATE] CHAR(15) NULL,
    [NATION] CHAR(15) NULL,
    [ZIP] CHAR(15) NULL,
    [PHONE1] CHAR(15) NULL,
    [PHONE2] CHAR(15) NULL,
    [FAX] CHAR(15) NULL,
    [EMAIL] CHAR(50) NULL,
    [REMOTE] BIT NOT NULL,
    [SECURITY_NET] BIT NOT NULL,
    [MONEY_NET] BIT NOT NULL,
    [EXCISE_REG] CHAR(30) NULL,
    [CONTACT_PERSON] CHAR(25) NULL,
    [COM_PERC] MONEY NULL,
    [TERMINAL_ID] VARCHAR(10) NULL,
    [DEFTRADER] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[broktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] DECIMAL(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(18, 4) NULL,
    [Day_Sales] NUMERIC(18, 4) NULL,
    [Sett_Purch] NUMERIC(18, 4) NULL,
    [round_to] DECIMAL(10, 2) NULL,
    [Table_name] CHAR(25) NULL,
    [sett_sales] NUMERIC(18, 4) NULL,
    [NORMAL] DECIMAL(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] DECIMAL(10, 2) NULL,
    [Def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] NUMERIC(18, 9) NULL,
    [NoZero] INT NULL,
    [Branch_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_DETAIL_SETTING
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_DETAIL_SETTING]
(
    [OBJNAME] VARCHAR(30) NULL,
    [BLANK_ALLOWED] INT NULL,
    [FIELD_WIDTH] INT NULL,
    [enable_disable] INT NULL,
    [CLIENT_TYPE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_MSTR
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_MSTR]
(
    [CLIM_CRN_NO] NUMERIC(10, 0) NOT NULL,
    [CLIM_NAME1] VARCHAR(100) NULL,
    [CLIM_NAME2] VARCHAR(50) NULL,
    [CLIM_NAME3] VARCHAR(50) NULL,
    [CLIM_SHORT_NAME] VARCHAR(200) NULL,
    [CLIM_GENDER] VARCHAR(1) NOT NULL,
    [CLIM_DOB] DATETIME NOT NULL,
    [CLIM_ENTTM_CD] VARCHAR(20) NULL,
    [CLIM_STAM_CD] VARCHAR(20) NOT NULL,
    [CLIM_CLICM_CD] VARCHAR(20) NULL,
    [CLIM_SBUM_ID] NUMERIC(10, 0) NULL,
    [CLIM_RMKS] VARCHAR(1000) NULL,
    [CLIM_CREATED_BY] VARCHAR(25) NOT NULL,
    [CLIM_CREATED_DT] DATETIME NOT NULL,
    [CLIM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [CLIM_LST_UPD_DT] DATETIME NOT NULL,
    [CLIM_DELETED_IND] SMALLINT NOT NULL,
    [clim_PAN_NO] VARCHAR(25) NULL,
    [clim_sba_no] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENTSTATUS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENTSTATUS]
(
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [DESCRIPTION] VARCHAR(35) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clientsureshmfss
-- --------------------------------------------------
CREATE TABLE [dbo].[clientsureshmfss]
(
    [partycode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clienttype
-- --------------------------------------------------
CREATE TABLE [dbo].[clienttype]
(
    [Cl_Type] VARCHAR(3) NOT NULL,
    [Description] VARCHAR(50) NULL,
    [GROUP_CODE] VARCHAR(10) NULL,
    [prefix] VARCHAR(3) NOT NULL,
    [priority] INT NULL,
    [MarginFlag] VARCHAR(1) NULL,
    [DEBITBALPERCENTAGE] DECIMAL(18, 4) NULL,
    [FutBalPercentage] DECIMAL(18, 4) NULL,
    [FUNDS_FNO_IM] VARCHAR(1) NULL,
    [FUNDS_FNO_EXP] VARCHAR(1) NULL,
    [FUNDS_ADHOC_PAYOUT] VARCHAR(1) NULL,
    [FUNDS_SETT_PAYOUT] VARCHAR(1) NULL,
    [FAMILY_BALANCE] VARCHAR(1) NULL,
    [CREATEBY] VARCHAR(20) NULL,
    [CREATEDATE] DATETIME NULL,
    [UPDATEBY] VARCHAR(20) NULL,
    [UPDATEDATE] DATETIME NULL,
    [InstFlag] VARCHAR(1) NULL,
    [PANVALIDATION] VARCHAR(1) NULL,
    [CREDITAMOUNT] NUMERIC(18, 4) NULL,
    [CASHMARGINMARKUP] NUMERIC(18, 4) NULL,
    [FOMARGINMARKUP] NUMERIC(18, 4) NULL,
    [NLRSell] NUMERIC(18, 4) NULL,
    [NLRMCall] NUMERIC(18, 4) NULL,
    [NLRHold] NUMERIC(18, 4) NULL,
    [SPANMARKUP] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_TBLUSERGROUPMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_TBLUSERGROUPMASTER]
(
    [fldAuto] INT IDENTITY(1,1) NOT NULL,
    [fldUserID] INT NULL,
    [Group_Code] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLS_TBLUSERGROUPMASTER_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[CLS_TBLUSERGROUPMASTER_LOG]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [FLDAUTO] INT NULL,
    [FLDUSERID] INT NULL,
    [GROUP_CODE] VARCHAR(20) NULL,
    [FLAG] CHAR(1) NULL,
    [ADDED_DT] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CONTGEN
-- --------------------------------------------------
CREATE TABLE [dbo].[CONTGEN]
(
    [Contractno] VARCHAR(7) NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delaccbalance
-- --------------------------------------------------
CREATE TABLE [dbo].[Delaccbalance]
(
    [Cltcode] VARCHAR(10) NOT NULL,
    [Amount] MONEY NULL,
    [Payflag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Delcdslbalance
-- --------------------------------------------------
CREATE TABLE [dbo].[Delcdslbalance]
(
    [Party_Code] VARCHAR(10) NULL,
    [Dpid] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(16) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(12) NOT NULL,
    [Freebal] INT NOT NULL,
    [Currbal] BIGINT NULL,
    [Freezebal] INT NOT NULL,
    [Lockinbal] INT NOT NULL,
    [Pledgebal] INT NOT NULL,
    [Dpvbal] INT NOT NULL,
    [Dpcbal] INT NOT NULL,
    [Rpcbal] CHAR(10) NOT NULL,
    [Elimbal] INT NOT NULL,
    [Earmarkbal] INT NOT NULL,
    [Remlockbal] INT NOT NULL,
    [Totalbalance] INT NOT NULL,
    [Trdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELCODE
-- --------------------------------------------------
CREATE TABLE [dbo].[DELCODE]
(
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Nsdlno] NUMERIC(18, 0) NULL,
    [Cdslno] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELFILENO
-- --------------------------------------------------
CREATE TABLE [dbo].[DELFILENO]
(
    [Sno] INT IDENTITY(1,1) NOT NULL,
    [FileType] VARCHAR(10) NOT NULL,
    [FileNo] INT NOT NULL,
    [FileDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELIVERYDP
-- --------------------------------------------------
CREATE TABLE [dbo].[DELIVERYDP]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Dptype] VARCHAR(4) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpcltno] VARCHAR(16) NULL,
    [Description] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(4) NULL,
    [LICENCENO] VARCHAR(10) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [DivAcNo] VARCHAR(10) NULL,
    [Status_Flag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DelSegment
-- --------------------------------------------------
CREATE TABLE [dbo].[DelSegment]
(
    [RefNo] INT NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(10) NOT NULL,
    [Company] VARCHAR(60) NULL,
    [DB] VARCHAR(20) NOT NULL,
    [PDpType] VARCHAR(5) NULL,
    [PDpId] VARCHAR(16) NULL,
    [PCltId] VARCHAR(16) NULL,
    [BDpType] VARCHAR(5) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltId] VARCHAR(16) NULL,
    [PDpType1] VARCHAR(5) NULL,
    [PDpId1] VARCHAR(16) NULL,
    [PCltId1] VARCHAR(16) NULL,
    [BDpType1] VARCHAR(5) NULL,
    [BDpId1] VARCHAR(16) NULL,
    [BCltId1] VARCHAR(16) NULL,
    [FileRead] INT NULL,
    [AuctionPer] NUMERIC(18, 2) NULL,
    [NSECmBpId] VARCHAR(8) NULL,
    [BSECMBpId] VARCHAR(8) NULL,
    [NSDLToCDSL] VARCHAR(8) NULL,
    [AuctionParty] VARCHAR(10) NULL,
    [AuctionChrg] MONEY NULL,
    [NoOfSlip] INT NULL,
    [AllocationType] INT NULL,
    [BrokerFileId] VARCHAR(2) NULL,
    [BrokerId] VARCHAR(8) NULL,
    [AuctionFlag] INT NULL,
    [AuctionFlagDesc] VARCHAR(100) NULL,
    [RMSPAYOUT] INT NULL,
    [COLLCALCULATIONFLAG] INT NULL,
    [LOANPARTY] VARCHAR(10) NULL,
    [AUCTIONFINAL] NUMERIC(18, 4) NULL,
    [SETTPOCKETFLAG] INT NULL,
    [NSECMID] VARCHAR(8) NULL,
    [BSECMID] VARCHAR(8) NULL,
    [WITH_ROOT_FLAG] INT NULL,
    [ConsiderationFlag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSEGMENT_bak_27062020
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSEGMENT_bak_27062020]
(
    [RefNo] INT NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(10) NOT NULL,
    [Company] VARCHAR(60) NULL,
    [DB] VARCHAR(20) NOT NULL,
    [PDpType] VARCHAR(5) NULL,
    [PDpId] VARCHAR(16) NULL,
    [PCltId] VARCHAR(16) NULL,
    [BDpType] VARCHAR(5) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltId] VARCHAR(16) NULL,
    [PDpType1] VARCHAR(5) NULL,
    [PDpId1] VARCHAR(16) NULL,
    [PCltId1] VARCHAR(16) NULL,
    [BDpType1] VARCHAR(5) NULL,
    [BDpId1] VARCHAR(16) NULL,
    [BCltId1] VARCHAR(16) NULL,
    [FileRead] INT NULL,
    [AuctionPer] NUMERIC(18, 2) NULL,
    [NSECmBpId] VARCHAR(8) NULL,
    [BSECMBpId] VARCHAR(8) NULL,
    [NSDLToCDSL] VARCHAR(8) NULL,
    [AuctionParty] VARCHAR(10) NULL,
    [AuctionChrg] MONEY NULL,
    [NoOfSlip] INT NULL,
    [AllocationType] INT NULL,
    [BrokerFileId] VARCHAR(2) NULL,
    [BrokerId] VARCHAR(8) NULL,
    [AuctionFlag] INT NULL,
    [AuctionFlagDesc] VARCHAR(100) NULL,
    [RMSPAYOUT] INT NULL,
    [COLLCALCULATIONFLAG] INT NULL,
    [LOANPARTY] VARCHAR(10) NULL,
    [AUCTIONFINAL] NUMERIC(18, 4) NULL,
    [SETTPOCKETFLAG] INT NULL,
    [NSECMID] VARCHAR(8) NULL,
    [BSECMID] VARCHAR(8) NULL,
    [WITH_ROOT_FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSLIPFORMAT
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSLIPFORMAT]
(
    [FormatProvider] VARCHAR(10) NOT NULL,
    [FromDp] VARCHAR(4) NOT NULL,
    [ToDp] VARCHAR(4) NOT NULL,
    [Detail] VARCHAR(10) NOT NULL,
    [PoolOrBen] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSLIPMST
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSLIPMST]
(
    [Dptype] CHAR(4) NULL,
    [Sliptype] VARCHAR(2) NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Slflag] INT NULL,
    [Checksum] VARCHAR(5) NULL,
    [Dpid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [SLIPSERIES] VARCHAR(6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DELSLIPTYPE
-- --------------------------------------------------
CREATE TABLE [dbo].[DELSLIPTYPE]
(
    [SLIPTYPE] VARCHAR(2) NULL,
    [SLIPDESC] VARCHAR(50) NULL,
    [DPTYPE] VARCHAR(4) NULL,
    [ACCOUNTTYPE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltrans
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltrans]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DelTransDP89
-- --------------------------------------------------
CREATE TABLE [dbo].[DelTransDP89]
(
    [ExcCode] VARCHAR(2) NOT NULL,
    [ExcName] VARCHAR(50) NOT NULL,
    [CMId] VARCHAR(4) NOT NULL,
    [Filler1] VARCHAR(10) NOT NULL,
    [SettNo] VARCHAR(13) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [CltName] VARCHAR(100) NOT NULL,
    [MemberCode] VARCHAR(10) NULL,
    [MemberName] VARCHAR(100) NOT NULL,
    [IsIn] VARCHAR(12) NOT NULL,
    [ScripName] VARCHAR(50) NOT NULL,
    [PosQty] NUMERIC(18, 4) NOT NULL,
    [RecQty] NUMERIC(18, 4) NOT NULL,
    [Sett_Type] VARCHAR(2) NULL,
    [Filler3] CHAR(1) NOT NULL,
    [TransNo] INT NOT NULL,
    [trdate] VARCHAR(20) NOT NULL,
    [Party_Code] VARCHAR(50) NOT NULL,
    [MarketType] VARCHAR(20) NOT NULL,
    [Filler4] VARCHAR(20) NOT NULL,
    [Filler5] VARCHAR(20) NOT NULL,
    [Filler6] NUMERIC(18, 0) NULL,
    [TransFlag] CHAR(1) NOT NULL,
    [Filler7] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltranspi
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltranspi]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(35) NULL,
    [Reason] VARCHAR(30) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DelTransPrintBen
-- --------------------------------------------------
CREATE TABLE [dbo].[DelTransPrintBen]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [FromParty] VARCHAR(10) NOT NULL,
    [ToParty] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(10) NULL,
    [Series] VARCHAR(3) NULL,
    [CertNo] VARCHAR(12) NOT NULL,
    [TrType] INT NOT NULL,
    [BDpType] VARCHAR(4) NOT NULL,
    [BDpId] VARCHAR(8) NOT NULL,
    [BCltDpId] VARCHAR(16) NOT NULL,
    [ISett_No] VARCHAR(7) NOT NULL,
    [ISett_Type] VARCHAR(2) NOT NULL,
    [DpId] VARCHAR(8) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [SlipNo] NUMERIC(18, 0) NOT NULL,
    [Batchno] VARCHAR(10) NOT NULL,
    [FolioNo] VARCHAR(16) NOT NULL,
    [TransDate] DATETIME NOT NULL,
    [HolderName] VARCHAR(100) NOT NULL,
    [OptionFlag] INT NOT NULL,
    [Qty] NUMERIC(18, 4) NULL,
    [NewQty] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DelTransPrintPool
-- --------------------------------------------------
CREATE TABLE [dbo].[DelTransPrintPool]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [FromParty] VARCHAR(10) NOT NULL,
    [ToParty] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [CertNo] VARCHAR(12) NOT NULL,
    [TrType] INT NOT NULL,
    [BDpType] VARCHAR(4) NOT NULL,
    [BDpId] VARCHAR(8) NOT NULL,
    [BCltDpId] VARCHAR(16) NOT NULL,
    [ISett_No] VARCHAR(7) NOT NULL,
    [ISett_Type] VARCHAR(2) NOT NULL,
    [DpId] VARCHAR(8) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [SlipNo] NUMERIC(18, 0) NOT NULL,
    [Batchno] VARCHAR(10) NOT NULL,
    [FolioNo] VARCHAR(16) NOT NULL,
    [TransDate] DATETIME NOT NULL,
    [HolderName] VARCHAR(100) NOT NULL,
    [OptionFlag] INT NOT NULL,
    [Qty] NUMERIC(18, 4) NULL,
    [NewQty] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Deltranstemp
-- --------------------------------------------------
CREATE TABLE [dbo].[Deltranstemp]
(
    [Sno] NUMERIC(18, 0) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Fromno] VARCHAR(16) NULL,
    [Tono] VARCHAR(16) NULL,
    [Certno] VARCHAR(16) NULL,
    [Foliono] VARCHAR(16) NULL,
    [Holdername] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [Orgqty] NUMERIC(18, 4) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Branchcd] VARCHAR(10) NOT NULL,
    [Partipantcode] VARCHAR(10) NOT NULL,
    [Slipno] NUMERIC(18, 0) NULL,
    [Batchno] VARCHAR(10) NULL,
    [Isett_No] VARCHAR(7) NULL,
    [Isett_Type] VARCHAR(2) NULL,
    [Sharetype] VARCHAR(8) NULL,
    [Transdate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Bdptype] VARCHAR(10) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltdpid] VARCHAR(16) NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattrans
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattrans]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattransout
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattransout]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Demattransspeed
-- --------------------------------------------------
CREATE TABLE [dbo].[Demattransspeed]
(
    [Sno] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Refno] INT NOT NULL,
    [Tcode] NUMERIC(18, 0) NOT NULL,
    [Trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [Trdate] DATETIME NOT NULL,
    [Cltaccno] VARCHAR(16) NULL,
    [Dpid] VARCHAR(16) NULL,
    [Dpname] VARCHAR(50) NULL,
    [Isin] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [Partipantcode] VARCHAR(10) NULL,
    [Dptype] VARCHAR(10) NULL,
    [Transno] VARCHAR(15) NOT NULL,
    [Drcr] VARCHAR(1) NOT NULL,
    [Bdptype] VARCHAR(4) NULL,
    [Bdpid] VARCHAR(16) NULL,
    [Bcltaccno] VARCHAR(16) NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [Filler4] INT NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_ACCT_MSTR
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_ACCT_MSTR]
(
    [DPAM_ID] NUMERIC(10, 0) NOT NULL,
    [DPAM_CRN_NO] NUMERIC(10, 0) NOT NULL,
    [DPAM_ACCT_NO] VARCHAR(20) NOT NULL,
    [DPAM_SBA_NAME] VARCHAR(150) NULL,
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [DPAM_EXCSM_ID] NUMERIC(10, 0) NULL,
    [DPAM_DPM_ID] NUMERIC(10, 0) NULL,
    [DPAM_ENTTM_CD] VARCHAR(20) NULL,
    [DPAM_CLICM_CD] VARCHAR(20) NULL,
    [DPAM_STAM_CD] VARCHAR(20) NULL,
    [DPAM_CREATED_BY] VARCHAR(25) NOT NULL,
    [DPAM_CREATED_DT] DATETIME NOT NULL,
    [DPAM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [DPAM_LST_UPD_DT] DATETIME NOT NULL,
    [DPAM_DELETED_IND] SMALLINT NOT NULL,
    [dpam_subcm_cd] VARCHAR(20) NULL,
    [dpam_batch_no] NUMERIC(10, 0) NULL,
    [DPAM_BBO_CODE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_HOLDER_DTLS
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_HOLDER_DTLS]
(
    [DPHD_DPAM_ID] NUMERIC(10, 0) NOT NULL,
    [DPHD_DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [DPHD_FH_FTHNAME] VARCHAR(100) NULL,
    [DPHD_SH_FNAME] VARCHAR(100) NULL,
    [DPHD_SH_MNAME] VARCHAR(50) NULL,
    [DPHD_SH_LNAME] VARCHAR(50) NULL,
    [DPHD_SH_FTHNAME] VARCHAR(100) NULL,
    [DPHD_SH_DOB] DATETIME NULL,
    [DPHD_SH_PAN_NO] VARCHAR(50) NULL,
    [DPHD_SH_GENDER] VARCHAR(1) NULL,
    [DPHD_TH_FNAME] VARCHAR(100) NULL,
    [DPHD_TH_MNAME] VARCHAR(50) NULL,
    [DPHD_TH_LNAME] VARCHAR(50) NULL,
    [DPHD_TH_FTHNAME] VARCHAR(100) NULL,
    [DPHD_TH_DOB] DATETIME NULL,
    [DPHD_TH_PAN_NO] VARCHAR(50) NULL,
    [DPHD_TH_GENDER] VARCHAR(1) NULL,
    [DPHD_NOM_FNAME] VARCHAR(100) NULL,
    [DPHD_NOM_MNAME] VARCHAR(50) NULL,
    [DPHD_NOM_LNAME] VARCHAR(50) NULL,
    [DPHD_NOM_FTHNAME] VARCHAR(100) NULL,
    [DPHD_NOM_DOB] DATETIME NULL,
    [DPHD_NOM_PAN_NO] VARCHAR(15) NULL,
    [DPHD_NOM_GENDER] VARCHAR(1) NULL,
    [DPHD_GAU_FNAME] VARCHAR(100) NULL,
    [DPHD_GAU_MNAME] VARCHAR(50) NULL,
    [DPHD_GAU_LNAME] VARCHAR(50) NULL,
    [DPHD_GAU_FTHNAME] VARCHAR(100) NULL,
    [DPHD_GAU_DOB] DATETIME NULL,
    [DPHD_GAU_PAN_NO] VARCHAR(15) NULL,
    [DPHD_GAU_GENDER] VARCHAR(1) NULL,
    [DPHD_CREATED_BY] VARCHAR(25) NOT NULL,
    [DPHD_CREATED_DT] DATETIME NOT NULL,
    [DPHD_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [DPHD_LST_UPD_DT] DATETIME NOT NULL,
    [DPHD_DELETED_IND] SMALLINT NOT NULL,
    [dphd_nomgau_fname] VARCHAR(100) NULL,
    [dphd_nomgau_mname] VARCHAR(50) NULL,
    [dphd_nomgau_lname] VARCHAR(50) NULL,
    [dphd_nomgau_fthname] VARCHAR(100) NULL,
    [dphd_nomgau_dob] DATETIME NULL,
    [dphd_nomgau_pan_no] VARCHAR(15) NULL,
    [dphd_nomgau_gender] VARCHAR(1) NULL,
    [NOM_NRN_NO] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DP_POA_DTLS
-- --------------------------------------------------
CREATE TABLE [dbo].[DP_POA_DTLS]
(
    [DPPD_ID] NUMERIC(10, 0) NOT NULL,
    [DPPD_DPAM_ID] NUMERIC(10, 0) NOT NULL,
    [DPPD_HLD] VARCHAR(20) NOT NULL,
    [DPPD_POA_TYPE] VARCHAR(20) NULL,
    [DPPD_FNAME] VARCHAR(100) NULL,
    [DPPD_MNAME] VARCHAR(50) NULL,
    [DPPD_LNAME] VARCHAR(50) NULL,
    [DPPD_FTHNAME] VARCHAR(100) NULL,
    [DPPD_DOB] DATETIME NULL,
    [DPPD_PAN_NO] VARCHAR(20) NULL,
    [DPPD_GENDER] VARCHAR(10) NULL,
    [DPPD_CREATED_BY] VARCHAR(20) NULL,
    [DPPD_CREATED_DT] DATETIME NULL,
    [DPPD_LST_UPD_BY] VARCHAR(20) NULL,
    [DPPD_LST_UPD_DT] DATETIME NULL,
    [DPPD_DELETED_IND] SMALLINT NULL,
    [dppd_poa_id] VARCHAR(16) NULL,
    [dppd_setup] DATETIME NULL,
    [dppd_gpabpa_flg] CHAR(1) NULL,
    [dppd_eff_fr_dt] DATETIME NULL,
    [dppd_eff_TO_dt] DATETIME NULL,
    [dppd_master_id] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ENTITY_PROPERTIES
-- --------------------------------------------------
CREATE TABLE [dbo].[ENTITY_PROPERTIES]
(
    [ENTP_ID] NUMERIC(10, 0) NOT NULL,
    [ENTP_ENT_ID] NUMERIC(10, 0) NOT NULL,
    [ENTP_ACCT_NO] VARCHAR(25) NULL,
    [ENTP_ENTPM_PROP_ID] NUMERIC(10, 0) NOT NULL,
    [ENTP_ENTPM_CD] VARCHAR(20) NOT NULL,
    [ENTP_VALUE] VARCHAR(50) NOT NULL,
    [ENTP_CREATED_BY] VARCHAR(25) NOT NULL,
    [ENTP_CREATED_DT] DATETIME NOT NULL,
    [ENTP_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [ENTP_LST_UPD_DT] DATETIME NOT NULL,
    [ENTP_DELETED_IND] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_MFSS
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_MFSS]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [AREA] VARCHAR(10) NULL,
    [REGION] VARCHAR(50) NULL,
    [SBU] VARCHAR(2) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] CHAR(1) NOT NULL,
    [OCCUPATION_CODE] VARCHAR(1) NOT NULL,
    [TAX_STATUS] VARCHAR(1) NOT NULL,
    [PAN_NO] VARCHAR(20) NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(40) NOT NULL,
    [ADDR2] VARCHAR(40) NULL,
    [ADDR3] VARCHAR(40) NULL,
    [CITY] VARCHAR(40) NULL,
    [STATE] VARCHAR(50) NULL,
    [ZIP] VARCHAR(10) NULL,
    [NATION] VARCHAR(15) NULL,
    [OFFICE_PHONE] VARCHAR(15) NULL,
    [RES_PHONE] VARCHAR(15) NULL,
    [MOBILE_NO] VARCHAR(40) NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NULL,
    [BANK_BRANCH] VARCHAR(40) NULL,
    [BANK_CITY] VARCHAR(40) NULL,
    [ACC_NO] VARCHAR(20) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NULL,
    [GAURDIAN_NAME] VARCHAR(202) NULL,
    [GAURDIAN_PAN_NO] VARCHAR(15) NOT NULL,
    [NOMINEE_NAME] VARCHAR(1) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(1) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(2) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(7) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(20) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(1) NOT NULL,
    [HOLDER2_NAME] VARCHAR(202) NULL,
    [HOLDER2_PAN_NO] VARCHAR(50) NOT NULL,
    [HOLDER2_KYC_FLAG] VARCHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(1) NOT NULL,
    [HOLDER3_NAME] VARCHAR(202) NULL,
    [HOLDER3_PAN_NO] VARCHAR(50) NOT NULL,
    [HOLDER3_KYC_FLAG] VARCHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(1) NOT NULL,
    [CHEQUENAME] VARCHAR(1) NOT NULL,
    [RESIFAX] VARCHAR(1) NOT NULL,
    [OFFICEFAX] VARCHAR(1) NOT NULL,
    [MAPINID] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(1) NOT NULL,
    [UCC_STATUS] VARCHAR(1) NOT NULL,
    [ADDEDBY] VARCHAR(12) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] VARCHAR(11) NULL,
    [INACTIVE_FROM] VARCHAR(16) NOT NULL,
    [POAFLAG] VARCHAR(3) NOT NULL
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
-- TABLE dbo.GLOBALS
-- --------------------------------------------------
CREATE TABLE [dbo].[GLOBALS]
(
    [Year] VARCHAR(4) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Service_Tax] NUMERIC(10, 4) NULL,
    [Service_Tax_Ac] VARCHAR(30) NULL,
    [Turnover_Ac] VARCHAR(30) NULL,
    [Sebi_Turn_Ac] VARCHAR(30) NULL,
    [Broker_Note_Ac] VARCHAR(30) NULL,
    [Other_Chrg_Ac] VARCHAR(30) NULL,
    [Exchange_Gl_Ac] VARCHAR(30) NULL,
    [Year_Start_Dt] DATETIME NULL,
    [Year_End_Dt] DATETIME NULL,
    [Cess_Tax] NUMERIC(10, 4) NULL,
    [Trdbuytrans] NUMERIC(18, 4) NULL,
    [Trdselltrans] NUMERIC(18, 4) NULL,
    [Delbuytrans] NUMERIC(18, 4) NULL,
    [Delselltrans] NUMERIC(18, 4) NULL,
    [EDUCESSTAX] NUMERIC(18, 4) NULL,
    [STT_TAX_AC] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.iaccbill
-- --------------------------------------------------
CREATE TABLE [dbo].[iaccbill]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Bill_No] INT NULL,
    [Sell_Buy] VARCHAR(2) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Start_Date] SMALLDATETIME NOT NULL,
    [End_Date] SMALLDATETIME NOT NULL,
    [Payin_Date] SMALLDATETIME NOT NULL,
    [Payout_Date] SMALLDATETIME NOT NULL,
    [Amount] MONEY NOT NULL,
    [Branchcd] VARCHAR(10) NULL,
    [Narration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IMP_FilePath
-- --------------------------------------------------
CREATE TABLE [dbo].[IMP_FilePath]
(
    [File_Type] VARCHAR(20) NULL,
    [File_Path] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_BROKERAGE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_BROKERAGE_MASTER]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(50) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [FROMDATE] DATETIME NOT NULL,
    [TODATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_BROKERAGE_MASTER_09
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_BROKERAGE_MASTER_09]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [PARTY_CODE] VARCHAR(50) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [FROMDATE] DATETIME NOT NULL,
    [TODATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_BULK
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_BULK]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CATEGORY
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CATEGORY]
(
    [CATEGORYCODE] VARCHAR(10) NULL,
    [CATEGORYNAME] VARCHAR(100) NULL,
    [BUY_PAYIN] INT NULL,
    [SELL_PAYIN] INT NULL,
    [FROM_DATE] DATETIME NULL,
    [TO_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [PIN] VARCHAR(20) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_bank_Merger
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_bank_Merger]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_CommonInterface
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_CommonInterface]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NULL,
    [ADDR3] VARCHAR(50) NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NULL,
    [RES_PHONE] VARCHAR(15) NULL,
    [MOBILE_NO] VARCHAR(50) NULL,
    [EMAIL_ID] VARCHAR(50) NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NULL,
    [NOMINEE_NAME] VARCHAR(50) NULL,
    [NOMINEE_RELATION] VARCHAR(50) NULL,
    [BANK_AC_TYPE] VARCHAR(10) NULL,
    [STAT_COMM_MODE] VARCHAR(1) NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NULL,
    [HOLDER2_NAME] VARCHAR(100) NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NULL,
    [HOLDER3_CODE] VARCHAR(20) NULL,
    [HOLDER3_NAME] VARCHAR(100) NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NULL,
    [BUY_BROK_TABLE_NO] INT NULL,
    [SELL_BROK_TABLE_NO] INT NULL,
    [BROK_EFF_DATE] DATETIME NULL,
    [NEFTCODE] VARCHAR(11) NULL,
    [CHEQUENAME] VARCHAR(35) NULL,
    [RESIFAX] VARCHAR(15) NULL,
    [OFFICEFAX] VARCHAR(15) NULL,
    [MAPINID] VARCHAR(16) NULL,
    [REMARK] VARCHAR(100) NULL,
    [UCC_STATUS] INT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [CIFLAG] VARCHAR(1) NULL,
    [CICreationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLIENT_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLIENT_LOG]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [EDITEDBY] VARCHAR(50) NOT NULL,
    [EDITEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL,
    [NOMINEE_NAME2] VARCHAR(50) NULL,
    [NOMINEE_RELATION2] VARCHAR(50) NULL,
    [NOMINEEPER2] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG2] VARCHAR(20) NULL,
    [NOMINEEDOB2] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN2] VARCHAR(20) NULL,
    [NOMINEE_NAME3] VARCHAR(50) NULL,
    [NOMINEE_RELATION3] VARCHAR(50) NULL,
    [NOMINEEPER3] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG3] VARCHAR(20) NULL,
    [NOMINEEDOB3] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN3] VARCHAR(20) NULL,
    [FILLER1] VARCHAR(2) NULL,
    [FILLER2] VARCHAR(2) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [ADDRESS12] VARCHAR(50) NULL,
    [ADDRESS22] VARCHAR(50) NULL,
    [ADDRESS13] VARCHAR(50) NULL,
    [ADDRESS23] VARCHAR(50) NULL,
    [NOMINEEPHONE] VARCHAR(20) NULL,
    [NOMINEEPHONE2] VARCHAR(20) NULL,
    [NOMINEEPHONE3] VARCHAR(20) NULL,
    [PIN] VARCHAR(20) NULL,
    [PIN2] VARCHAR(20) NULL,
    [PIN3] VARCHAR(20) NULL,
    [NOMINEEPANNO] VARCHAR(20) NULL,
    [NOMINEEPANNO2] VARCHAR(20) NULL,
    [NOMINEEPANNO3] VARCHAR(20) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [EMAIL2] VARCHAR(100) NULL,
    [EMAIL3] VARCHAR(100) NULL,
    [GAURDPAN] VARCHAR(12) NULL,
    [GAURDPAN2] VARCHAR(12) NULL,
    [GAURDPAN3] VARCHAR(12) NULL,
    [GUARDIANPHONE] VARCHAR(20) NULL,
    [GUARDIANPHONE2] VARCHAR(20) NULL,
    [GUARDIANPHONE3] VARCHAR(20) NULL,
    [NOBANKAC] VARCHAR(20) NULL,
    [NODMAT] VARCHAR(20) NULL,
    [NOAADHAR] VARCHAR(20) NULL,
    [GARBANKAC] VARCHAR(20) NULL,
    [GARDMAT] VARCHAR(20) NULL,
    [GARAADHAR] VARCHAR(20) NULL,
    [NOBANKAC2] VARCHAR(20) NULL,
    [NODMAT2] VARCHAR(20) NULL,
    [NOAADHAR2] VARCHAR(20) NULL,
    [GARBANKAC2] VARCHAR(20) NULL,
    [GARDMAT2] VARCHAR(20) NULL,
    [GARAADHAR2] VARCHAR(20) NULL,
    [NOBANKAC3] VARCHAR(20) NULL,
    [NODMAT3] VARCHAR(20) NULL,
    [NOAADHAR3] VARCHAR(20) NULL,
    [GARBANKAC3] VARCHAR(20) NULL,
    [GARDMAT3] VARCHAR(20) NULL,
    [GARAADHAR3] VARCHAR(20) NULL,
    [GARADDRESS1] VARCHAR(50) NULL,
    [GARADDRESS2] VARCHAR(50) NULL,
    [GARPHONE] VARCHAR(20) NULL,
    [GARPIN] VARCHAR(20) NULL,
    [GAREMAIL] VARCHAR(50) NULL,
    [GARRELATION] VARCHAR(50) NULL,
    [GARADDRESS12] VARCHAR(50) NULL,
    [GARADDRESS22] VARCHAR(50) NULL,
    [GARPHONE2] VARCHAR(20) NULL,
    [GARPIN2] VARCHAR(20) NULL,
    [GAREMAIL2] VARCHAR(50) NULL,
    [GARRELATION2] VARCHAR(50) NULL,
    [GARADDRESS13] VARCHAR(50) NULL,
    [GARADDRESS23] VARCHAR(50) NULL,
    [GARPHONE3] VARCHAR(20) NULL,
    [GARPIN3] VARCHAR(20) NULL,
    [GAREMAIL3] VARCHAR(50) NULL,
    [GARRELATION3] VARCHAR(50) NULL,
    [NOMREQ] VARCHAR(1) NULL,
    [IFSCCODE] VARCHAR(20) NULL,
    [SECOND_HOLDER_DOB] VARCHAR(10) NULL,
    [THIRD_HOLDER_DOB] VARCHAR(10) NULL,
    [GUARDIAN_DOB] VARCHAR(10) NULL,
    [PD_CLTYPE] VARCHAR(1) NULL,
    [AADHAR_UID] VARCHAR(20) NULL,
    [PRIMARYEXEMPT] VARCHAR(20) NULL,
    [PRIMARYEXEMPTCAT] VARCHAR(20) NULL,
    [SECONDEXEMPT] VARCHAR(20) NULL,
    [SECONDEXEMPTCAT] VARCHAR(20) NULL,
    [THIRDEXEMPT] VARCHAR(20) NULL,
    [THIRDEXEMPTCAT] VARCHAR(20) NULL,
    [GUARDIANEXEMPT] VARCHAR(20) NULL,
    [LEINO] VARCHAR(20) NULL,
    [LEIVALIDITY] VARCHAR(20) NULL,
    [PMS] VARCHAR(20) NULL,
    [PID] VARCHAR(20) NULL,
    [PAPERLESSFLAG] VARCHAR(20) NULL,
    [NOMINEEPER] VARCHAR(20) NULL,
    [NOMINEEMINORFLAG] VARCHAR(20) NULL,
    [NOMINEEDOB] VARCHAR(20) NULL,
    [NOMINEEGUARDIAN] VARCHAR(20) NULL,
    [PRIMARYHOLDERKYCTYPE] VARCHAR(20) NULL,
    [GUARDIANHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [THIRDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [SECONDHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [PRIMARYHOLDERKRAEXEMPTNO] VARCHAR(20) NULL,
    [GUARDIANHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERCKYCNO] VARCHAR(20) NULL,
    [THIRDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [SECONDHOLDERCKYCNO] VARCHAR(20) NULL,
    [SECONDHOLDERKYCTYPE] VARCHAR(20) NULL,
    [PRIMARYHOLDERCKYCNO] VARCHAR(20) NULL,
    [AADHARUPDATED] VARCHAR(20) NULL,
    [GUARDIANEXEMPTCAT] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_CLMST_VALUES
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_CLMST_VALUES]
(
    [V_TYPE] VARCHAR(10) NULL,
    [V_CODE] VARCHAR(10) NULL,
    [V_VALUE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DFDS
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DFDS]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(2) NOT NULL,
    [IsIn] VARCHAR(12) NOT NULL,
    [Party_Code] VARCHAR(50) NOT NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [DpId] VARCHAR(8) NOT NULL,
    [CltDpId] VARCHAR(16) NOT NULL,
    [TransNo] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_A1390761
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_A1390761]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [POAFLAG] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_DPMASTER_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_DPMASTER_LOG]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [DEFAULTDP] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [EDITEDBY] VARCHAR(50) NOT NULL,
    [EDITEDON] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mfss_dump
-- --------------------------------------------------
CREATE TABLE [dbo].[mfss_dump]
(
    [PARTY_CODE] VARCHAR(20) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NOT NULL,
    [AREA] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [SBU] VARCHAR(10) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] VARCHAR(1) NOT NULL,
    [OCCUPATION_CODE] INT NOT NULL,
    [TAX_STATUS] INT NOT NULL,
    [PAN_NO] VARCHAR(10) NOT NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(50) NOT NULL,
    [ADDR2] VARCHAR(50) NOT NULL,
    [ADDR3] VARCHAR(50) NOT NULL,
    [CITY] VARCHAR(35) NOT NULL,
    [STATE] VARCHAR(50) NOT NULL,
    [ZIP] VARCHAR(6) NOT NULL,
    [NATION] VARCHAR(50) NOT NULL,
    [OFFICE_PHONE] VARCHAR(15) NOT NULL,
    [RES_PHONE] VARCHAR(15) NOT NULL,
    [MOBILE_NO] VARCHAR(50) NOT NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(50) NOT NULL,
    [BANK_CITY] VARCHAR(50) NOT NULL,
    [ACC_NO] VARCHAR(40) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(12) NOT NULL,
    [DOB] DATETIME NOT NULL,
    [GAURDIAN_NAME] VARCHAR(35) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(10) NOT NULL,
    [NOMINEE_NAME] VARCHAR(50) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(50) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(4) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MODE_HOLDING] CHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(20) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER2_KYC_FLAG] CHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(20) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(10) NOT NULL,
    [HOLDER3_KYC_FLAG] CHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(11) NOT NULL,
    [CHEQUENAME] VARCHAR(35) NOT NULL,
    [RESIFAX] VARCHAR(15) NOT NULL,
    [OFFICEFAX] VARCHAR(15) NOT NULL,
    [MAPINID] VARCHAR(16) NOT NULL,
    [REMARK] VARCHAR(100) NOT NULL,
    [UCC_STATUS] INT NOT NULL,
    [ADDEDBY] VARCHAR(50) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NULL,
    [INACTIVE_FROM] DATETIME NULL,
    [POAFLAG] VARCHAR(3) NULL,
    [DEACTIVE_REMARKS] VARCHAR(100) NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_FUNDS_OBLIGATION
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_FUNDS_OBLIGATION]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [SETTLEMENT_DATE] DATETIME NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [ORDER_NO] NUMERIC(18, 0) NOT NULL,
    [ORDER_INDICATOR] VARCHAR(1) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [AVAIL_AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PROCESSDATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_NAV
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_NAV]
(
    [NAV_DATE] DATETIME NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_NAME] VARCHAR(200) NULL,
    [CATEGORY_CODE] VARCHAR(5) NOT NULL,
    [CATEGORY_NAME] VARCHAR(25) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [NAV_VALUE] NUMERIC(18, 4) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [USER_ID] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_CONF
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_CONF]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_CONF_new
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_CONF_new]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_REJ
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_REJ]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_ALLOT_REJ_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_ALLOT_REJ_NEW]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_BKUP_28JUL20
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_BKUP_28JUL20]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [USER_ID] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_NEW]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [USER_ID] VARCHAR(20) NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_CONF
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_CONF]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [ENTRY_EXIT_LOAD] VARCHAR(20) NULL,
    [STT] VARCHAR(20) NULL,
    [TDS] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_CONF_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_CONF_NEW]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [ENTRY_EXIT_LOAD] VARCHAR(20) NULL,
    [STT] VARCHAR(20) NULL,
    [TDS] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_REJ
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_REJ]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_REDEM_REJ_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_REDEM_REJ_NEW]
(
    [REPORTDATE] DATETIME NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [REJECT_REASON] VARCHAR(50) NOT NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_TMP
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_TMP]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NOT NULL,
    [PAYOUT_MECHANISM] INT NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_ORDER_TMP_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_ORDER_TMP_NEW]
(
    [SNO] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [SETT_TYPE] VARCHAR(1) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ALLOTMENT_MODE] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [AMC_CODE] VARCHAR(3) NOT NULL,
    [AMC_SCHEME_CODE] VARCHAR(10) NOT NULL,
    [RTA_CODE] VARCHAR(50) NOT NULL,
    [RTA_SCHEME_CODE] VARCHAR(5) NOT NULL,
    [SCHEME_CATEGORY] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [SCHEME_OPT_TYPE] VARCHAR(1) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BRANCH_CODE] VARCHAR(10) NOT NULL,
    [DEALER_CODE] VARCHAR(10) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [PAYOUT_MECHANISM] VARCHAR(10) NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TAX_STATUS] VARCHAR(2) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [F_CL_NAME] VARCHAR(100) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_NAME] VARCHAR(100) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_NAME] VARCHAR(100) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [G_NAME] VARCHAR(100) NOT NULL,
    [G_PAN] VARCHAR(10) NOT NULL,
    [DPNAME] VARCHAR(50) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [MOBILE_NO] VARCHAR(15) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(10) NOT NULL,
    [BANK_AC_NO] VARCHAR(40) NOT NULL,
    [BANK_NAME] VARCHAR(40) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(40) NOT NULL,
    [MICR_CODE] VARCHAR(12) NOT NULL,
    [NEFT_CODE] VARCHAR(12) NOT NULL,
    [RTGS_CODE] VARCHAR(12) NOT NULL,
    [EMAIL_ID] VARCHAR(100) NOT NULL,
    [CONF_FLAG] VARCHAR(1) NOT NULL,
    [REJECT_REASON] VARCHAR(200) NULL,
    [NAV_VALUE_ALLOTED] NUMERIC(18, 4) NULL,
    [QTY_ALLOTED] NUMERIC(18, 4) NULL,
    [AMOUNT_ALLOTED] NUMERIC(18, 4) NULL,
    [SIP_Regd_No] VARCHAR(20) NULL,
    [SIP_Tranche_No] VARCHAR(20) NULL,
    [EUIN_NUMBER] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SCRIP_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SCRIP_MASTER]
(
    [TOKEN] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [INTRUMENTTYPE] VARCHAR(6) NOT NULL,
    [QUANTITY_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RTSCHEMECODE] VARCHAR(5) NOT NULL,
    [AMCSCHEMECODE] VARCHAR(10) NOT NULL,
    [Filler] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [FOLIO_LENGHT] INT NOT NULL,
    [SEC_STATUS_NRM] INT NOT NULL,
    [ELIGIBILITY_NRM] VARCHAR(1) NOT NULL,
    [SEC_STATUS_ODDLOT] INT NOT NULL,
    [ELIGIBILITY_ODDLOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_SPOT] INT NOT NULL,
    [ELIGIBILITY_SPOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_AUCTION] INT NOT NULL,
    [ELIGIBILITY_AUCTION] VARCHAR(1) NOT NULL,
    [AMCCODE] VARCHAR(3) NOT NULL,
    [CATEGORYCODE] VARCHAR(5) NOT NULL,
    [SEC_NAME] VARCHAR(200) NULL,
    [ISSUE_RATE] NUMERIC(18, 4) NOT NULL,
    [MINSUBSCRADDL] NUMERIC(18, 4) NOT NULL,
    [BUYNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [SELLNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [RTAGENTCODE] VARCHAR(50) NOT NULL,
    [VALDECINDICATOR] INT NOT NULL,
    [CATSTARTTIME] INT NOT NULL,
    [QTYDECINDICATOR] INT NOT NULL,
    [CATENDTIME] INT NOT NULL,
    [MINSUBSCRFRESH] NUMERIC(18, 4) NOT NULL,
    [VALUE_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RECORD_DATE] DATETIME NOT NULL,
    [EX_DATE] DATETIME NOT NULL,
    [NAVDATE] DATETIME NOT NULL,
    [NO_DELIVERY_END_DATE] DATETIME NOT NULL,
    [ST_ELIGIBLE_IDX] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_AON] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_MIN_FILL] VARCHAR(1) NOT NULL,
    [SECDEPMANDATORY] VARCHAR(1) NOT NULL,
    [SEC_DIVIDEND] VARCHAR(1) NOT NULL,
    [SECALLOWDEP] VARCHAR(1) NOT NULL,
    [SECALLOWSELL] VARCHAR(1) NOT NULL,
    [SECMODCXL] VARCHAR(1) NOT NULL,
    [SECALLOWBUY] VARCHAR(1) NOT NULL,
    [BOOK_CL_START_DT] DATETIME NOT NULL,
    [BOOK_CL_END_DT] DATETIME NOT NULL,
    [DIVIDEND] VARCHAR(1) NOT NULL,
    [RIGHTS] VARCHAR(1) NOT NULL,
    [BONUS] VARCHAR(1) NOT NULL,
    [INTEREST] VARCHAR(1) NOT NULL,
    [AGM] VARCHAR(1) NOT NULL,
    [EGM] VARCHAR(1) NOT NULL,
    [OTHER] VARCHAR(1) NOT NULL,
    [LOCAL_DTTIME] DATETIME NOT NULL,
    [DELETEFLAG] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(25) NOT NULL,
    [SIP_ELIGIBILITY] VARCHAR(1) NULL,
    [MAX_PFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_PAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MIN_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MULTI_PS_LIM] NUMERIC(18, 4) NULL,
    [MULTI_DS_LIM] NUMERIC(18, 4) NULL,
    [AMC_NAME] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SCRIP_MASTER_TMP
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SCRIP_MASTER_TMP]
(
    [TOKEN] VARCHAR(5) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [INTRUMENTTYPE] VARCHAR(6) NOT NULL,
    [QUANTITY_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RTSCHEMECODE] VARCHAR(5) NOT NULL,
    [AMCSCHEMECODE] VARCHAR(10) NOT NULL,
    [Filler] VARCHAR(10) NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [FOLIO_LENGHT] INT NOT NULL,
    [SEC_STATUS_NRM] INT NOT NULL,
    [ELIGIBILITY_NRM] VARCHAR(1) NOT NULL,
    [SEC_STATUS_ODDLOT] INT NOT NULL,
    [ELIGIBILITY_ODDLOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_SPOT] INT NOT NULL,
    [ELIGIBILITY_SPOT] VARCHAR(1) NOT NULL,
    [SEC_STATUS_AUCTION] INT NOT NULL,
    [ELIGIBILITY_AUCTION] VARCHAR(1) NOT NULL,
    [AMCCODE] VARCHAR(3) NOT NULL,
    [CATEGORYCODE] VARCHAR(5) NOT NULL,
    [SEC_NAME] VARCHAR(200) NULL,
    [ISSUE_RATE] NUMERIC(18, 4) NOT NULL,
    [MINSUBSCRADDL] NUMERIC(18, 4) NOT NULL,
    [BUYNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [SELLNAVPRICE] NUMERIC(18, 4) NOT NULL,
    [RTAGENTCODE] VARCHAR(50) NOT NULL,
    [VALDECINDICATOR] INT NOT NULL,
    [CATSTARTTIME] INT NOT NULL,
    [QTYDECINDICATOR] INT NOT NULL,
    [CATENDTIME] INT NOT NULL,
    [MINSUBSCRFRESH] NUMERIC(18, 4) NOT NULL,
    [VALUE_LIMIT] NUMERIC(18, 4) NOT NULL,
    [RECORD_DATE] DATETIME NOT NULL,
    [EX_DATE] DATETIME NOT NULL,
    [NAVDATE] DATETIME NOT NULL,
    [NO_DELIVERY_END_DATE] DATETIME NOT NULL,
    [ST_ELIGIBLE_IDX] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_AON] VARCHAR(1) NOT NULL,
    [ST_ELIGIBLE_MIN_FILL] VARCHAR(1) NOT NULL,
    [SECDEPMANDATORY] VARCHAR(1) NOT NULL,
    [SEC_DIVIDEND] VARCHAR(1) NOT NULL,
    [SECALLOWDEP] VARCHAR(1) NOT NULL,
    [SECALLOWSELL] VARCHAR(1) NOT NULL,
    [SECMODCXL] VARCHAR(1) NOT NULL,
    [SECALLOWBUY] VARCHAR(1) NOT NULL,
    [BOOK_CL_START_DT] DATETIME NOT NULL,
    [BOOK_CL_END_DT] DATETIME NOT NULL,
    [DIVIDEND] VARCHAR(1) NOT NULL,
    [RIGHTS] VARCHAR(1) NOT NULL,
    [BONUS] VARCHAR(1) NOT NULL,
    [INTEREST] VARCHAR(1) NOT NULL,
    [AGM] VARCHAR(1) NOT NULL,
    [EGM] VARCHAR(1) NOT NULL,
    [OTHER] VARCHAR(1) NOT NULL,
    [LOCAL_DTTIME] DATETIME NOT NULL,
    [DELETEFLAG] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(25) NOT NULL,
    [SIP_ELIGIBILITY] VARCHAR(1) NULL,
    [MAX_PFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_PAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DFS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MIN_DAS_VAL_LIM] NUMERIC(18, 4) NULL,
    [MAX_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MIN_DR_QTY_LIM] NUMERIC(18, 4) NULL,
    [MULTI_PS_LIM] NUMERIC(18, 4) NULL,
    [MULTI_DS_LIM] NUMERIC(18, 4) NULL,
    [AMC_NAME] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT_DELETED
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT_DELETED]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_SETTLEMENT_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_SETTLEMENT_LOG]
(
    [CONTRACTNO] VARCHAR(7) NOT NULL,
    [BILLNO] INT NOT NULL,
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] VARCHAR(20) NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [BROKERAGE] NUMERIC(18, 4) NOT NULL,
    [INS_CHRG] NUMERIC(18, 4) NOT NULL,
    [TURN_TAX] NUMERIC(18, 4) NOT NULL,
    [OTHER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SEBI_TAX] NUMERIC(18, 4) NOT NULL,
    [BROKER_CHRG] NUMERIC(18, 4) NOT NULL,
    [SERVICE_TAX] NUMERIC(18, 4) NOT NULL,
    [FILLER1] VARCHAR(10) NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL,
    [REJECTEDDATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MFSS_TRADE
-- --------------------------------------------------
CREATE TABLE [dbo].[MFSS_TRADE]
(
    [ORDER_NO] VARCHAR(16) NOT NULL,
    [STATUS] VARCHAR(2) NOT NULL,
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(2) NOT NULL,
    [ISIN] VARCHAR(16) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SETTFLAG] INT NOT NULL,
    [F_CL_KYC] VARCHAR(1) NOT NULL,
    [F_CL_PAN] VARCHAR(10) NOT NULL,
    [APPLN_NO] VARCHAR(10) NOT NULL,
    [PURCHASE_TYPE] VARCHAR(1) NOT NULL,
    [DP_SETTLMENT] VARCHAR(1) NOT NULL,
    [DP_ID] VARCHAR(8) NOT NULL,
    [DPCODE] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(16) NOT NULL,
    [FOLIONO] NUMERIC(18, 0) NOT NULL,
    [AMOUNT] NUMERIC(18, 4) NOT NULL,
    [QTY] NUMERIC(18, 4) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [S_CLIENTID] VARCHAR(10) NOT NULL,
    [S_CL_KYC] VARCHAR(1) NOT NULL,
    [S_CL_PAN] VARCHAR(10) NOT NULL,
    [T_CLIENTID] VARCHAR(10) NOT NULL,
    [T_CL_KYC] VARCHAR(1) NOT NULL,
    [T_CL_PAN] VARCHAR(10) NOT NULL,
    [USER_ID] VARCHAR(10) NOT NULL,
    [BRANCH_ID] VARCHAR(10) NOT NULL,
    [SUB_RED_FLAG] VARCHAR(1) NOT NULL,
    [ORDER_DATE] DATETIME NOT NULL,
    [ORDER_TIME] DATETIME NOT NULL,
    [MEMBERCODE] VARCHAR(15) NOT NULL,
    [FILLER1] VARCHAR(1) NOT NULL,
    [FILLER2] VARCHAR(1) NOT NULL,
    [FILLER3] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OWNER
-- --------------------------------------------------
CREATE TABLE [dbo].[OWNER]
(
    [Company] VARCHAR(80) NULL,
    [Addr1] VARCHAR(30) NULL,
    [Addr2] VARCHAR(30) NULL,
    [Phone] VARCHAR(25) NULL,
    [Zip] VARCHAR(6) NULL,
    [City] VARCHAR(20) NULL,
    [Membercode] VARCHAR(15) NULL,
    [Bankname] VARCHAR(50) NULL,
    [Bankadd] VARCHAR(50) NULL,
    [Csdlid] VARCHAR(10) NULL,
    [Cdaccno] VARCHAR(10) NULL,
    [Dpid] VARCHAR(10) NULL,
    [Cltaccno] VARCHAR(10) NULL,
    [Mainbroker] CHAR(1) NULL,
    [Maxpartylen] TINYINT NULL,
    [Preprintchq] CHAR(1) NULL,
    [Table_No] SMALLINT NULL,
    [Sub_Tableno] SMALLINT NULL,
    [Std_Rate] SMALLINT NULL,
    [P_To_P] SMALLINT NULL,
    [Demat_Tableno] SMALLINT NULL,
    [Albmcf_Tableno] SMALLINT NULL,
    [Mf_Tableno] SMALLINT NULL,
    [Sb_Tableno] SMALLINT NULL,
    [Brok1_Tableno] SMALLINT NULL,
    [Brok2_Tableno] SMALLINT NULL,
    [Brok3_Tableno] SMALLINT NULL,
    [Terminal] VARCHAR(10) NULL,
    [Tscheme] TINYINT NULL,
    [Dispcharge] TINYINT NULL,
    [Brok_Inc_Stax] TINYINT NULL,
    [Def_Scheme] CHAR(1) NULL,
    [Brok_Scheme] TINYINT NULL,
    [Contcharge] TINYINT NULL,
    [Mincontcharge] TINYINT NULL,
    [Marginmultiplier] TINYINT NULL,
    [Dummy1] TINYINT NULL,
    [Dummy2] TINYINT NULL,
    [Style] INT NULL,
    [Exchangecode] VARCHAR(3) NULL,
    [Brokersebiregno] VARCHAR(15) NULL,
    [Counterparty] VARCHAR(15) NULL,
    [Cp_Sebiregno] VARCHAR(15) NULL,
    [Panno] VARCHAR(50) NULL,
    [Fax] VARCHAR(25) NULL,
    [State] VARCHAR(50) NULL,
    [AutoGenPartyCode] INT NULL,
    [EMAIL] VARCHAR(100) NULL,
    [SMTP_SRV_NAME] VARCHAR(100) NULL,
    [ExchangeSegment] VARCHAR(10) NULL,
    [LEVEL] INT NULL,
    [KEEPINST] TINYINT NULL,
    [PROFILE_BROK_FLAG] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POBANK
-- --------------------------------------------------
CREATE TABLE [dbo].[POBANK]
(
    [BANKID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BRANCH_NAME] VARCHAR(50) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [CITY] VARCHAR(25) NULL,
    [STATE] VARCHAR(25) NULL,
    [NATION] VARCHAR(25) NULL,
    [ZIP] VARCHAR(15) NULL,
    [PHONE1] VARCHAR(15) NULL,
    [PHONE2] VARCHAR(15) NULL,
    [FAX] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [IFSCCODE] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pobank_13122010_bank_standerd_phaseII
-- --------------------------------------------------
CREATE TABLE [dbo].[pobank_13122010_bank_standerd_phaseII]
(
    [BANKID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BRANCH_NAME] VARCHAR(50) NULL,
    [ADDRESS1] VARCHAR(50) NULL,
    [ADDRESS2] VARCHAR(50) NULL,
    [CITY] VARCHAR(25) NULL,
    [STATE] VARCHAR(25) NULL,
    [NATION] VARCHAR(25) NULL,
    [ZIP] VARCHAR(15) NULL,
    [PHONE1] VARCHAR(15) NULL,
    [PHONE2] VARCHAR(15) NULL,
    [FAX] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(50) NULL,
    [IFSCCODE] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.REGION
-- --------------------------------------------------
CREATE TABLE [dbo].[REGION]
(
    [REGIONCODE] VARCHAR(20) NULL,
    [DESCRIPTION] VARCHAR(50) NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL,
    [REG_SUBBROKER] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.S
-- --------------------------------------------------
CREATE TABLE [dbo].[S]
(
    [PARTY_CODE] CHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(1) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [AREA] VARCHAR(10) NULL,
    [REGION] VARCHAR(50) NULL,
    [SBU] VARCHAR(2) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] CHAR(1) NOT NULL,
    [OCCUPATION_CODE] VARCHAR(1) NOT NULL,
    [TAX_STATUS] VARCHAR(1) NOT NULL,
    [PAN_NO] VARCHAR(20) NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(40) NOT NULL,
    [ADDR2] VARCHAR(40) NULL,
    [ADDR3] VARCHAR(40) NULL,
    [CITY] VARCHAR(40) NULL,
    [STATE] VARCHAR(50) NULL,
    [ZIP] VARCHAR(10) NULL,
    [NATION] VARCHAR(15) NULL,
    [OFFICE_PHONE] VARCHAR(15) NULL,
    [RES_PHONE] VARCHAR(15) NULL,
    [MOBILE_NO] VARCHAR(40) NULL,
    [EMAIL_ID] VARCHAR(50) NULL,
    [BANK_NAME] VARCHAR(50) NOT NULL,
    [BANK_BRANCH] VARCHAR(40) NOT NULL,
    [BANK_CITY] VARCHAR(1) NOT NULL,
    [ACC_NO] VARCHAR(20) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NULL,
    [GAURDIAN_NAME] VARCHAR(100) NOT NULL,
    [GAURDIAN_PAN_NO] VARCHAR(1) NOT NULL,
    [NOMINEE_NAME] VARCHAR(1) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(1) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(2) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(7) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(20) NOT NULL,
    [MODE_HOLDING] VARCHAR(1) NOT NULL,
    [HOLDER2_CODE] VARCHAR(1) NOT NULL,
    [HOLDER2_NAME] VARCHAR(100) NOT NULL,
    [HOLDER2_PAN_NO] VARCHAR(25) NOT NULL,
    [HOLDER2_KYC_FLAG] VARCHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(1) NOT NULL,
    [HOLDER3_NAME] VARCHAR(100) NOT NULL,
    [HOLDER3_PAN_NO] VARCHAR(25) NOT NULL,
    [HOLDER3_KYC_FLAG] VARCHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(1) NOT NULL,
    [CHEQUENAME] VARCHAR(1) NOT NULL,
    [RESIFAX] VARCHAR(1) NOT NULL,
    [OFFICEFAX] VARCHAR(1) NOT NULL,
    [MAPINID] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(1) NOT NULL,
    [UCC_STATUS] VARCHAR(1) NOT NULL,
    [ADDEDBY] VARCHAR(4) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] DATETIME NOT NULL,
    [INACTIVE_FROM] DATETIME NOT NULL,
    [POAFLAG] INT NOT NULL,
    [DEACTIVE_VALUE] VARCHAR(1) NOT NULL,
    [DEACTIVE_REMARK] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBU_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[SBU_MASTER]
(
    [SBU_CODE] VARCHAR(10) NOT NULL,
    [SBU_NAME] VARCHAR(50) NOT NULL,
    [SBU_ADDR1] VARCHAR(40) NOT NULL,
    [SBU_ADDR2] VARCHAR(40) NULL,
    [SBU_ADDR3] VARCHAR(40) NULL,
    [SBU_CITY] VARCHAR(20) NULL,
    [SBU_STATE] VARCHAR(20) NULL,
    [SBU_ZIP] VARCHAR(10) NULL,
    [SBU_PHONE1] VARCHAR(15) NULL,
    [SBU_PHONE2] VARCHAR(15) NULL,
    [SBU_TYPE] VARCHAR(10) NOT NULL,
    [SBU_PARTY_CODE] VARCHAR(10) NULL,
    [BRANCH_CD] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MST
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MST]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SETT_MSTTEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[SETT_MSTTEMP]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Start_Date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SIVA
-- --------------------------------------------------
CREATE TABLE [dbo].[SIVA]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_BALANCE] VARCHAR(1) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [AREA] VARCHAR(10) NULL,
    [REGION] VARCHAR(50) NULL,
    [SBU] VARCHAR(2) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [GENDER] CHAR(1) NOT NULL,
    [OCCUPATION_CODE] VARCHAR(1) NOT NULL,
    [TAX_STATUS] VARCHAR(1) NOT NULL,
    [PAN_NO] VARCHAR(20) NULL,
    [KYC_FLAG] VARCHAR(1) NOT NULL,
    [ADDR1] VARCHAR(40) NOT NULL,
    [ADDR2] VARCHAR(40) NULL,
    [ADDR3] VARCHAR(40) NULL,
    [CITY] VARCHAR(40) NULL,
    [STATE] VARCHAR(50) NULL,
    [ZIP] VARCHAR(10) NULL,
    [NATION] VARCHAR(15) NULL,
    [OFFICE_PHONE] VARCHAR(15) NULL,
    [RES_PHONE] VARCHAR(15) NULL,
    [MOBILE_NO] VARCHAR(40) NULL,
    [EMAIL_ID] VARCHAR(50) NOT NULL,
    [BANK_NAME] VARCHAR(50) NULL,
    [BANK_BRANCH] VARCHAR(40) NULL,
    [BANK_CITY] VARCHAR(40) NULL,
    [ACC_NO] VARCHAR(20) NOT NULL,
    [PAYMODE] INT NOT NULL,
    [MICR_NO] VARCHAR(10) NOT NULL,
    [DOB] DATETIME NULL,
    [GAURDIAN_NAME] VARCHAR(202) NULL,
    [GAURDIAN_PAN_NO] VARCHAR(15) NOT NULL,
    [NOMINEE_NAME] VARCHAR(1) NOT NULL,
    [NOMINEE_RELATION] VARCHAR(1) NOT NULL,
    [BANK_AC_TYPE] VARCHAR(2) NOT NULL,
    [STAT_COMM_MODE] VARCHAR(1) NOT NULL,
    [DP_TYPE] VARCHAR(7) NOT NULL,
    [DPID] VARCHAR(8) NOT NULL,
    [CLTDPID] VARCHAR(20) NOT NULL,
    [MODE_HOLDING] VARCHAR(2) NOT NULL,
    [HOLDER2_CODE] VARCHAR(1) NOT NULL,
    [HOLDER2_NAME] VARCHAR(202) NULL,
    [HOLDER2_PAN_NO] VARCHAR(50) NOT NULL,
    [HOLDER2_KYC_FLAG] VARCHAR(1) NOT NULL,
    [HOLDER3_CODE] VARCHAR(1) NOT NULL,
    [HOLDER3_NAME] VARCHAR(202) NULL,
    [HOLDER3_PAN_NO] VARCHAR(50) NOT NULL,
    [HOLDER3_KYC_FLAG] VARCHAR(1) NOT NULL,
    [BUY_BROK_TABLE_NO] INT NOT NULL,
    [SELL_BROK_TABLE_NO] INT NOT NULL,
    [BROK_EFF_DATE] DATETIME NOT NULL,
    [NEFTCODE] VARCHAR(1) NOT NULL,
    [CHEQUENAME] VARCHAR(1) NOT NULL,
    [RESIFAX] VARCHAR(1) NOT NULL,
    [OFFICEFAX] VARCHAR(1) NOT NULL,
    [MAPINID] VARCHAR(1) NOT NULL,
    [REMARK] VARCHAR(1) NOT NULL,
    [UCC_STATUS] VARCHAR(1) NOT NULL,
    [ADDEDBY] VARCHAR(8) NOT NULL,
    [ADDEDON] DATETIME NOT NULL,
    [ACTIVE_FROM] VARCHAR(11) NULL,
    [INACTIVE_FROM] VARCHAR(16) NOT NULL,
    [POAFLAG] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Speed_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[Speed_Temp]
(
    [SNo] NUMERIC(18, 0) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [RefNo] INT NOT NULL,
    [TCode] NUMERIC(18, 0) NOT NULL,
    [TrType] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 4) NOT NULL,
    [TrDate] DATETIME NOT NULL,
    [CltAccNo] VARCHAR(16) NULL,
    [DpId] VARCHAR(16) NULL,
    [DpName] VARCHAR(50) NULL,
    [IsIn] VARCHAR(12) NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [PartiPantCode] VARCHAR(10) NULL,
    [DpType] VARCHAR(10) NULL,
    [TransNo] VARCHAR(15) NOT NULL,
    [DrCr] VARCHAR(1) NOT NULL,
    [BDpType] VARCHAR(4) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltAccNo] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STAT_TRD
-- --------------------------------------------------
CREATE TABLE [dbo].[STAT_TRD]
(
    [Actioncode] VARCHAR(3) NULL,
    [Sysdate] SMALLDATETIME NULL,
    [Filedate] SMALLDATETIME NULL,
    [Com_Date] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.STATE_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[STATE_MASTER]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [State] VARCHAR(50) NOT NULL,
    [State_Code] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SUBBROKERS
-- --------------------------------------------------
CREATE TABLE [dbo].[SUBBROKERS]
(
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [NAME] VARCHAR(50) NULL,
    [ADDRESS1] CHAR(100) NULL,
    [ADDRESS2] CHAR(100) NULL,
    [CITY] CHAR(20) NULL,
    [STATE] CHAR(15) NULL,
    [NATION] CHAR(15) NULL,
    [ZIP] CHAR(10) NULL,
    [FAX] CHAR(15) NULL,
    [PHONE1] CHAR(15) NULL,
    [PHONE2] CHAR(15) NULL,
    [REG_NO] CHAR(30) NULL,
    [REGISTERED] BIT NOT NULL,
    [MAIN_SUB] CHAR(1) NULL,
    [EMAIL] CHAR(50) NULL,
    [COM_PERC] MONEY NULL,
    [BRANCH_CODE] VARCHAR(10) NULL,
    [CONTACT_PERSON] VARCHAR(100) NULL,
    [REMPARTYCODE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sureshss
-- --------------------------------------------------
CREATE TABLE [dbo].[Sureshss]
(
    [SRNO] INT NOT NULL,
    [CL_CODE] VARCHAR(10) NOT NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SUB_BROKER] VARCHAR(10) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [LONG_NAME] VARCHAR(100) NULL,
    [SHORT_NAME] VARCHAR(30) NULL,
    [L_ADDRESS1] VARCHAR(100) NULL,
    [L_CITY] VARCHAR(40) NULL,
    [L_ADDRESS2] VARCHAR(100) NULL,
    [L_STATE] VARCHAR(50) NULL,
    [L_ADDRESS3] VARCHAR(100) NULL,
    [L_NATION] VARCHAR(15) NULL,
    [L_ZIP] VARCHAR(10) NULL,
    [PAN_GIR_NO] VARCHAR(50) NULL,
    [WARD_NO] VARCHAR(50) NULL,
    [SEBI_REGN_NO] VARCHAR(25) NULL,
    [RES_PHONE1] VARCHAR(15) NULL,
    [RES_PHONE2] VARCHAR(15) NULL,
    [OFF_PHONE1] VARCHAR(15) NULL,
    [OFF_PHONE2] VARCHAR(15) NULL,
    [MOBILE_PAGER] VARCHAR(40) NULL,
    [FAX] VARCHAR(15) NULL,
    [EMAIL] VARCHAR(100) NULL,
    [CL_TYPE] VARCHAR(3) NOT NULL,
    [CL_STATUS] VARCHAR(3) NOT NULL,
    [FAMILY] VARCHAR(10) NOT NULL,
    [REGION] VARCHAR(20) NULL,
    [AREA] VARCHAR(20) NULL,
    [P_ADDRESS1] VARCHAR(100) NULL,
    [P_CITY] VARCHAR(40) NULL,
    [P_ADDRESS2] VARCHAR(100) NULL,
    [P_STATE] VARCHAR(50) NULL,
    [P_ADDRESS3] VARCHAR(100) NULL,
    [P_NATION] VARCHAR(15) NULL,
    [P_ZIP] VARCHAR(10) NULL,
    [P_PHONE] VARCHAR(15) NULL,
    [ADDEMAILID] VARCHAR(230) NULL,
    [SEX] CHAR(1) NULL,
    [DOB] DATETIME NULL,
    [INTRODUCER] VARCHAR(30) NULL,
    [APPROVER] VARCHAR(30) NULL,
    [INTERACTMODE] TINYINT NULL,
    [PASSPORT_NO] VARCHAR(30) NULL,
    [PASSPORT_ISSUED_AT] VARCHAR(30) NULL,
    [PASSPORT_ISSUED_ON] DATETIME NULL,
    [PASSPORT_EXPIRES_ON] DATETIME NULL,
    [LICENCE_NO] VARCHAR(30) NULL,
    [LICENCE_ISSUED_AT] VARCHAR(30) NULL,
    [LICENCE_ISSUED_ON] DATETIME NULL,
    [LICENCE_EXPIRES_ON] DATETIME NULL,
    [RAT_CARD_NO] VARCHAR(30) NULL,
    [RAT_CARD_ISSUED_AT] VARCHAR(30) NULL,
    [RAT_CARD_ISSUED_ON] DATETIME NULL,
    [VOTERSID_NO] VARCHAR(30) NULL,
    [VOTERSID_ISSUED_AT] VARCHAR(30) NULL,
    [VOTERSID_ISSUED_ON] DATETIME NULL,
    [IT_RETURN_YR] VARCHAR(30) NULL,
    [IT_RETURN_FILED_ON] DATETIME NULL,
    [REGR_NO] VARCHAR(50) NULL,
    [REGR_AT] VARCHAR(50) NULL,
    [REGR_ON] DATETIME NULL,
    [REGR_AUTHORITY] VARCHAR(50) NULL,
    [CLIENT_AGREEMENT_ON] DATETIME NULL,
    [SETT_MODE] VARCHAR(50) NULL,
    [DEALING_WITH_OTHER_TM] VARCHAR(50) NULL,
    [OTHER_AC_NO] VARCHAR(50) NULL,
    [INTRODUCER_ID] VARCHAR(50) NULL,
    [INTRODUCER_RELATION] VARCHAR(50) NULL,
    [REPATRIAT_BANK] NUMERIC(18, 0) NULL,
    [REPATRIAT_BANK_AC_NO] VARCHAR(30) NULL,
    [CHK_KYC_FORM] TINYINT NULL,
    [CHK_CORPORATE_DEED] TINYINT NULL,
    [CHK_BANK_CERTIFICATE] TINYINT NULL,
    [CHK_ANNUAL_REPORT] TINYINT NULL,
    [CHK_NETWORTH_CERT] TINYINT NULL,
    [CHK_CORP_DTLS_RECD] TINYINT NULL,
    [BANK_NAME] VARCHAR(100) NULL,
    [BRANCH_NAME] VARCHAR(50) NULL,
    [AC_TYPE] VARCHAR(10) NULL,
    [AC_NUM] VARCHAR(20) NULL,
    [DEPOSITORY1] VARCHAR(7) NULL,
    [DPID1] VARCHAR(16) NULL,
    [CLTDPID1] VARCHAR(16) NULL,
    [POA1] CHAR(1) NULL,
    [DEPOSITORY2] VARCHAR(7) NULL,
    [DPID2] VARCHAR(16) NULL,
    [CLTDPID2] VARCHAR(16) NULL,
    [POA2] CHAR(1) NULL,
    [DEPOSITORY3] VARCHAR(7) NULL,
    [DPID3] VARCHAR(16) NULL,
    [CLTDPID3] VARCHAR(16) NULL,
    [POA3] CHAR(1) NULL,
    [REL_MGR] VARCHAR(10) NULL,
    [C_GROUP] VARCHAR(10) NULL,
    [SBU] VARCHAR(10) NULL,
    [STATUS] CHAR(1) NULL,
    [IMP_STATUS] TINYINT NULL,
    [MODIFIDEDBY] VARCHAR(25) NULL,
    [MODIFIDEDON] DATETIME NULL,
    [BANK_ID] VARCHAR(20) NULL,
    [MAPIN_ID] VARCHAR(12) NULL,
    [UCC_CODE] VARCHAR(12) NULL,
    [MICR_NO] VARCHAR(10) NULL,
    [IFSC_CODE] VARCHAR(20) NULL,
    [DIRECTOR_NAME] VARCHAR(500) NULL,
    [PAYLOCATION] VARCHAR(20) NULL,
    [FMCODE] VARCHAR(10) NULL,
    [PARENTCODE] VARCHAR(10) NULL,
    [PRODUCTCODE] VARCHAR(2) NULL,
    [INCOME_SLAB] VARCHAR(50) NULL,
    [NETWORTH_SLAB] VARCHAR(50) NULL,
    [AUTOFUNDPAYOUT] INT NULL,
    [SEBI_REG_DATE] DATETIME NULL,
    [SEBI_EXP_DATE] DATETIME NULL,
    [PERSON_TAG] INT NULL,
    [COMMODITY_TRADER] VARCHAR(20) NULL,
    [CHANNEL_TYPE] VARCHAR(20) NULL,
    [DMA_AGREEMENT_DATE] DATETIME NULL,
    [DMA_ACTIVATION_DATE] DATETIME NULL,
    [FO_TRADER] VARCHAR(20) NULL,
    [CDS_TRADER] VARCHAR(20) NULL,
    [CDS_SUBBROKER] VARCHAR(10) NULL,
    [RES_PHONE1_STD] VARCHAR(10) NULL,
    [RES_PHONE2_STD] VARCHAR(10) NULL,
    [OFF_PHONE1_STD] VARCHAR(10) NULL,
    [OFF_PHONE2_STD] VARCHAR(10) NULL,
    [P_PHONE_STD] VARCHAR(10) NULL,
    [BANKID] INT NULL,
    [VALID_PARTY] VARCHAR(1) NULL,
    [VALID_REGION] VARCHAR(1) NULL,
    [VALID_AREA] VARCHAR(1) NULL,
    [VALID_TRADER] VARCHAR(1) NULL,
    [VALID_SUBBROKER] VARCHAR(1) NULL,
    [VALID_BRANCH] VARCHAR(1) NULL,
    [VALID_BANK] VARCHAR(1) NULL,
    [VALID_DPBANK1] VARCHAR(1) NULL,
    [VALID_DPBANK2] VARCHAR(1) NULL,
    [VALID_DPBANK3] VARCHAR(1) NULL,
    [RECVALID] VARCHAR(1) NULL,
    [OCCUPATION] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_HOLD_SEC
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_HOLD_SEC]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [SETT_NO] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(30) NULL,
    [SERIES] VARCHAR(5) NULL,
    [CERTNO] VARCHAR(20) NULL,
    [TRANSDATE] DATETIME NULL,
    [CRQTY] INT NULL,
    [DRQTY] INT NULL,
    [DPID] VARCHAR(20) NULL,
    [CLTDPID] VARCHAR(20) NULL,
    [BCLTDPID] VARCHAR(20) NULL,
    [BDPID] VARCHAR(20) NULL,
    [REMARK] VARCHAR(100) NULL,
    [MEMBER_ACC_TYPE] VARCHAR(20) NULL,
    [PLEDGED_BAL_QTY] INT NULL,
    [FREE_BAL_QTY] INT NULL,
    [TRF_REF_NO] VARCHAR(20) NULL,
    [TRANSACTION_TYPE] VARCHAR(20) NULL,
    [PURPOSE] VARCHAR(100) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_MASTER_POAID
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_MASTER_POAID]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [DPID] VARCHAR(8) NULL,
    [CLTDPID] VARCHAR(16) NULL,
    [POA_TYPE] VARCHAR(10) NULL,
    [MASTER_POA_ID] VARCHAR(16) NULL,
    [FROM_DATE] DATETIME NULL,
    [TO_DATE] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL,
    [ADDED_ON] DATETIME NULL,
    [EDITED_BY] VARCHAR(16) NULL,
    [EDITED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DEL_MASTER_USER
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DEL_MASTER_USER]
(
    [SNO] INT NOT NULL,
    [REC_TYPE] VARCHAR(10) NULL,
    [DEF_FLAG] INT NULL,
    [USERCODE] VARCHAR(12) NULL,
    [USERNAME] VARCHAR(50) NULL,
    [FROM_DATE] DATETIME NULL,
    [TO_DATE] DATETIME NULL,
    [ADDED_BY] VARCHAR(50) NULL,
    [ADDED_ON] DATETIME NULL,
    [EDITED_BY] VARCHAR(16) NULL,
    [EDITED_ON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblAdmin
-- --------------------------------------------------
CREATE TABLE [dbo].[TblAdmin]
(
    [Fldauto_Admin] INT IDENTITY(1,1) NOT NULL,
    [Fldname] VARCHAR(30) NOT NULL,
    [Fldpassword] VARCHAR(50) NULL,
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
    [Fldpassword] VARCHAR(30) NOT NULL,
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
-- TABLE dbo.TblAdminconfig
-- --------------------------------------------------
CREATE TABLE [dbo].[TblAdminconfig]
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
-- TABLE dbo.TblCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[TblCategory]
(
    [Fldcategorycode] INT IDENTITY(1,1) NOT NULL,
    [Fldcategoryname] VARCHAR(50) NOT NULL,
    [Fldadminauto] INT NULL,
    [Flddesc] VARCHAR(80) NULL
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
-- TABLE dbo.TblCatmenu
-- --------------------------------------------------
CREATE TABLE [dbo].[TblCatmenu]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldreportcode] INT NOT NULL,
    [Fldadminauto] INT NOT NULL,
    [Fldcategorycode] VARCHAR(2000) NULL
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
-- TABLE dbo.tblglobalparams
-- --------------------------------------------------
CREATE TABLE [dbo].[tblglobalparams]
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
    [MKCKFLAG] VARCHAR(1) NULL,
    [FLDCAPTCHA] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblMenuHead
-- --------------------------------------------------
CREATE TABLE [dbo].[TblMenuHead]
(
    [Fldmenucode] VARCHAR(20) NULL,
    [Fldmenuname] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblPradnyausers
-- --------------------------------------------------
CREATE TABLE [dbo].[TblPradnyausers]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(50) NULL,
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
    [MODIFIED_BY] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBLPRADNYAUSERS_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBLPRADNYAUSERS_LOG]
(
    [Fldauto] INT NOT NULL,
    [Fldusername] VARCHAR(25) NULL,
    [Fldpassword] VARCHAR(15) NULL,
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
-- TABLE dbo.TblReportgrp
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReportgrp]
(
    [Fldreportgrp] INT IDENTITY(1,1) NOT NULL,
    [Fldgrpname] VARCHAR(35) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Flddesc] VARCHAR(80) NULL
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
-- TABLE dbo.TblReports
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReports]
(
    [Fldreportcode] INT IDENTITY(1,1) NOT NULL,
    [Fldreportname] VARCHAR(200) NULL,
    [Fldpath] VARCHAR(500) NULL,
    [Fldtarget] VARCHAR(25) NULL,
    [Flddesc] VARCHAR(80) NULL,
    [Fldreportgrp] VARCHAR(10) NULL,
    [Fldmenugrp] VARCHAR(3) NULL,
    [Fldstatus] VARCHAR(20) NULL,
    [Fldorder] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TblReports_Blocked
-- --------------------------------------------------
CREATE TABLE [dbo].[TblReports_Blocked]
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
-- TABLE dbo.tblUserControlGlobals
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlGlobals]
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
-- TABLE dbo.tblUserControlMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlMaster]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
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
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUserControlMaster_23082022
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlMaster_23082022]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
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
    [FLDFORCELOGOUT] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblUserControlMaster_Jrnl
-- --------------------------------------------------
CREATE TABLE [dbo].[tblUserControlMaster_Jrnl]
(
    [FLDAUTO] BIGINT NOT NULL,
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
    [FLDUPDTDT] DATETIME NULL
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
    [FLDAUTO] INT NOT NULL,
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
-- TABLE dbo.V2_LOGIN_ERR_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_LOGIN_ERR_LOG]
(
    [SNO] BIGINT IDENTITY(1,1) NOT NULL,
    [LOGIN_ID] VARCHAR(20) NULL,
    [LOGIN_PWD] VARCHAR(20) NULL,
    [IPADD] VARCHAR(20) NULL,
    [ERR_TYPE] VARCHAR(20) NULL,
    [LOGIN_TYPE] VARCHAR(10) NULL,
    [LOGIN_DT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_Login_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_Login_Log]
(
    [Sno] BIGINT IDENTITY(1,1) NOT NULL,
    [UserId] INT NULL,
    [UserName] VARCHAR(64) NULL,
    [Category] VARCHAR(64) NULL,
    [StatusName] VARCHAR(32) NULL,
    [StatusId] VARCHAR(32) NULL,
    [IPADD] VARCHAR(20) NULL,
    [Action] VARCHAR(6) NULL,
    [AddDt] DATETIME NULL
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
-- TABLE dbo.VALANACCOUNT
-- --------------------------------------------------
CREATE TABLE [dbo].[VALANACCOUNT]
(
    [Accode] VARCHAR(10) NULL,
    [Acname] VARCHAR(50) NULL,
    [Reversed] INT NULL,
    [Revcode] VARCHAR(10) NULL,
    [Oppcode] VARCHAR(10) NULL,
    [Effdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW
-- --------------------------------------------------


CREATE VIEW [dbo].[CLIENT_OTHER_SEGMENT_VIEW] AS              
              
SELECT               
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,--CL_BALANCE='',     
 CL_BALANCE='E',           
 CL_STATUS=C1.CL_STATUS ,       
 --CL_STATUS= ( CASE WHEN CL_STATUS='PPB'OR CL_STATUS='BCP'THEN 'Company'ELSE         
  --   CASE WHEN CL_STATUS='HUF' THEN 'HUF' ELSE         
    --  CASE WHEN CL_STATUS='IND' THEN 'Individual' END END END),    
    BRANCH_CD,              
 SUB_BROKER,TRADER,AREA,REGION,          
 --SBU=DUMMY9,          
 SBU='HO',   FAMILY,              
 GENDER=ISNULL(C5.SEX,''),        
 --OCCUPATION_CODE='',        
 OCCUPATION_CODE= ( CASE WHEN U.OCCUPATION IN ('01','02')THEN '2' ELSE        
         CASE WHEN U.OCCUPATION = '03' THEN '1' ELSE        
      CASE WHEN U.OCCUPATION = '04' THEN '3' ELSE        
      CASE WHEN U.OCCUPATION = '05' THEN '4' ELSE        
      CASE WHEN U.OCCUPATION = '06' THEN '5' ELSE        
      CASE WHEN U.OCCUPATION = '07' THEN '6' ELSE        
      CASE WHEN U.OCCUPATION = '08' THEN '7' ELSE        
      CASE WHEN U.OCCUPATION IN ('09','99')THEN '8'  END END END END END END END END ) ,        
 TAX_STATUS=( CASE WHEN CL_STATUS='PPB'OR CL_STATUS='BCP'THEN '4'ELSE         
     CASE WHEN CL_STATUS='HUF' THEN '3' ELSE         
      CASE WHEN CL_STATUS='IND' THEN '1' END END END),        
 PAN_NO=PAN_GIR_NO,          
 --KYC_FLAG='',             
 KYC_FLAG='Y',            
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,              
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,              
 --BANK_NAME'',        
 BANK_NAME=ISNULL(c4.BANK_NAME,CD.BANK_NAME),        
 --BANK_BRANCH='',        
 BANK_BRANCH=ISNULL(c4.BRANCH_NAME,CD.BRANCH_NAME),BANK_CITY='',              
 ACC_NO=ISNULL(ISNULL(C4.CLTDPID,CD.AC_Num),''),      
 --PAYMODE='',          
 PAYMODE=1,         
 --MICR_NO=''         
 MICR_NO=CD.MICR_NO,              
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',              
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' 
 WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB'
 WHEN ISNULL(CD.AC_Type,'')='S' THEN 'SB' WHEN ISNULL(CD.AC_Type,'')='C' THEN 'CB'
  ELSE '' END
  ,              
 --STAT_COMM_MODE='',          
 STAT_COMM_MODE='P',          
 DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),              
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',              
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',              
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',          
 --BUY_BROK_TABLE_NO='',          
 --SELL_BROK_TABLE_NO='',            
 BUY_BROK_TABLE_NO=1,          
 SELL_BROK_TABLE_NO=1,            
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',              
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID='',POAFLAG =''              
FROM              
 AngelNseCM.MSAJAG.DBO.CLIENT1 C1 , AngelNseCM.MSAJAG.DBO.CLIENT2 C2        
 LEFT OUTER JOIN AngelNseCM.ACCOUNT.DBO.ACMAST             
 ON (CLTCODE = C2.PARTY_CODE)          
 LEFT OUTER JOIN (SELECT PARTY_CODE,c.BANKID,BANK_NAME,BRANCH_NAME,CLTDPID,DEPOSITORY FROM AngelNseCM.MSAJAG.DBO.CLIENT4 C          
     LEFT OUTER JOIN AngelNseCM.MSAJAG.DBO.POBANK PO         
     ON PO.BANKID=C.BANKID        
     WHERE C.DEPOSITORY IN ('SAVING','CURRENT')) C4              
 ON (C2.PARTY_CODE = C4.PARTY_CODE)              
 LEFT OUTER JOIN AngelNseCM.MSAJAG.DBO.CLIENT5 C5               
 ON (C5.CL_CODE = C2.PARTY_CODE)              
 LEFT OUTER JOIN AngelNseCM.MSAJAG.DBO.CLIENT_MASTER_UCC_DATA U           
 ON (U.Party_code = C2.PARTY_CODE)        
 --LEFT OUTER JOIN (SELECT PARTY_CODE,BANK_NAME,BRANCH_NAME,DEPOSITORY FROM AngelNseCM.MSAJAG.DBO.CLIENT4 C4          
 --    LEFT OUTER JOIN AngelNseCM.MSAJAG.DBO.POBANK PO         
 --    ON PO.BANKID=C4.BANKID        
 --    WHERE C4.DEPOSITORY IN ('SAVING','CURRENT'))P        
 --ON (P.Party_code=C2.PARTY_CODE)        
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM AngelNseCM.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44              
 ON (C2.PARTY_CODE = C44.PARTY_CODE)        
 LEFT OUTER JOIN (SELECT PARTY_CODE,Bank_Name,Branch_Name,AC_Type,AC_Num,MICR_NO FROM AngelNseCM.MSAJAG.DBO.CLIENT_DETAILS )CD    --WHERE Micr_No <>''    
 ON (C2.PARTY_CODE = CD.PARTY_CODE)        
WHERE              
 C1.CL_CODE = C2.CL_CODE              
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_02JAN2010
-- --------------------------------------------------


CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW AS

SELECT 
	C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,
	SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,
	GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',
	ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,
	OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,
	BANK_NAME='',BANK_BRANCH='',BANK_CITY='',
	ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),
	DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',
	BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,
	STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),
	CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',
	HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',
	HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO='',SELL_BROK_TABLE_NO='',
	BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS=''
FROM
	nsefo.DBO.CLIENT1 C1 (NOLOCK), nsefo.DBO.CLIENT2 C2 (NOLOCK)
	LEFT OUTER JOIN accountfo.DBO.ACMAST (NOLOCK)
 	ON (CLTCODE = C2.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM nsefo.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4
	ON (C2.PARTY_CODE = C4.PARTY_CODE)
	LEFT OUTER JOIN nsefo.DBO.CLIENT5 C5 (NOLOCK)
	ON (C5.CL_CODE = C2.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM nsefo.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44
	ON (C2.PARTY_CODE = C44.PARTY_CODE)
WHERE
	C1.CL_CODE = C2.CL_CODE
	AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_10092013
-- --------------------------------------------------
      
CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW_10092013 AS      
      
SELECT       
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,      
 SUB_BROKER,TRADER,AREA,REGION,  
 --SBU=DUMMY9,  
  SBU='HO',   FAMILY,      
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,  
 --KYC_FLAG='',     
  KYC_FLAG='Y',    
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,      
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,      
 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',      
 ACC_NO=ISNULL(C4.CLTDPID,''),  
 --PAYMODE='',  
 PAYMODE=1,  
 MICR_NO='',      
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',      
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,      
 --STAT_COMM_MODE='',  
  STAT_COMM_MODE='P',  
 DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),      
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',      
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',      
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',  
 --BUY_BROK_TABLE_NO='',  
 --SELL_BROK_TABLE_NO='',    
  BUY_BROK_TABLE_NO=1,  
 SELL_BROK_TABLE_NO=1,    
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',      
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''      
FROM      
 ANAND1.MSAJAG.DBO.CLIENT1 C1 , ANAND1.MSAJAG.DBO.CLIENT2 C2       
 LEFT OUTER JOIN ANAND1.ACCOUNT.DBO.ACMAST     
  ON (CLTCODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4      
 ON (C2.PARTY_CODE = C4.PARTY_CODE)      
 LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT5 C5       
 ON (C5.CL_CODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44      
 ON (C2.PARTY_CODE = C44.PARTY_CODE)      
WHERE      
 C1.CL_CODE = C2.CL_CODE      
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_12121212
-- --------------------------------------------------
      
CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW_12121212 AS      
      
SELECT       
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,      
 SUB_BROKER,TRADER,AREA,REGION,  
 --SBU=DUMMY9,  
  SBU='HO',   FAMILY,      
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,  
 --KYC_FLAG='',     
  KYC_FLAG='Y',    
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,      
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,      
 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',      
 ACC_NO=ISNULL(C4.CLTDPID,''),  
 --PAYMODE='',  
 PAYMODE=1,  
 MICR_NO='',      
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',      
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,      
 --STAT_COMM_MODE='',  
  STAT_COMM_MODE='P',  
 DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),      
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',      
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',      
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',  
 --BUY_BROK_TABLE_NO='',  
 --SELL_BROK_TABLE_NO='',    
  BUY_BROK_TABLE_NO=1,  
 SELL_BROK_TABLE_NO=1,    
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',      
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''      
FROM      
 ANAND1.MSAJAG.DBO.CLIENT1 C1 , ANAND1.MSAJAG.DBO.CLIENT2 C2       
 LEFT OUTER JOIN ANAND1.ACCOUNT.DBO.ACMAST     
  ON (CLTCODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4      
 ON (C2.PARTY_CODE = C4.PARTY_CODE)      
 LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT5 C5       
 ON (C5.CL_CODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44      
 ON (C2.PARTY_CODE = C44.PARTY_CODE)      
WHERE      
 C1.CL_CODE = C2.CL_CODE      
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_20112014
-- --------------------------------------------------
    
CREATE VIEW [dbo].[CLIENT_OTHER_SEGMENT_VIEW_20112014] AS    
    
SELECT     
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,    
 SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,    
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',    
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,    
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,    
 BANK_NAME=ISNULL(C4.BANK_NAME,''),BANK_BRANCH=ISNULL(C4.BRANCH_NAME,''),BANK_CITY=ISNULL(C4.CITY,''),    
 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),    
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',    
 BANK_AC_TYPE = (CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING'   
       THEN 'SB'   
       WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING'   
                      THEN 'CB'   
                      ELSE ''   
                 END),  
 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),    
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',    
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',    
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BUY_BROK_TABLE_NO='',SELL_BROK_TABLE_NO='',    
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',    
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID='', POAFLAG = ''    
FROM    
 ANAND1.MSAJAG.DBO.CLIENT1 C1 , ANAND1.MSAJAG.DBO.CLIENT2 C2    
 LEFT OUTER JOIN ANAND1.ACCOUNT.DBO.ACMAST 
  ON (CLTCODE = C2.PARTY_CODE)    
 LEFT OUTER JOIN (SELECT PARTY_CODE,CL4.BANKID,CLTDPID,DEPOSITORY,BANK_NAME,BRANCH_NAME,CITY FROM ANAND1.MSAJAG.DBO.CLIENT4 CL4,ANAND1.MSAJAG.DBO.POBANK P(NOLOCK)   
 WHERE DEPOSITORY IN ('SAVING','CURRENT') AND CL4.BANKID=P.BANKID) C4    
 ON (C2.PARTY_CODE = C4.PARTY_CODE)    
 LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT5 C5 (NOLOCK)    
 ON (C5.CL_CODE = C2.PARTY_CODE)    
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4   
 WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44    
 ON (C2.PARTY_CODE = C44.PARTY_CODE)    
WHERE    
 C1.CL_CODE = C2.CL_CODE    
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK)   
WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_BAK
-- --------------------------------------------------
    
CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW_BAK AS      
      
SELECT       
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',CL_STATUS,BRANCH_CD,      
 SUB_BROKER,TRADER,AREA,REGION,SBU=DUMMY9,FAMILY,      
 GENDER=ISNULL(C5.SEX,''),OCCUPATION_CODE='',TAX_STATUS='',PAN_NO=PAN_GIR_NO,KYC_FLAG='',      
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,      
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,      
 BANK_NAME='',BANK_BRANCH='',BANK_CITY='',      
 ACC_NO=ISNULL(C4.CLTDPID,''),PAYMODE='',MICR_NO=ISNULL(MICRNO,''),      
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',      
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,      
 STAT_COMM_MODE='',DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),      
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',      
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',      
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',BROK_TABLE_NO='',      
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',      
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''      
FROM      
 NSEFO.DBO.CLIENT1 C1 (NOLOCK), NSEFO.DBO.CLIENT2 C2 (NOLOCK)      
 LEFT OUTER JOIN ACCOUNTfo.DBO.ACMAST (NOLOCK)      
  ON (CLTCODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('SAVING','CURRENT')) C4      
 ON (C2.PARTY_CODE = C4.PARTY_CODE)      
 LEFT OUTER JOIN NSEFO.DBO.CLIENT5 C5 (NOLOCK)      
 ON (C5.CL_CODE = C2.PARTY_CODE)      
 LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM NSEFO.DBO.CLIENT4 (NOLOCK) WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44      
 ON (C2.PARTY_CODE = C44.PARTY_CODE)      
WHERE      
 C1.CL_CODE = C2.CL_CODE      
 AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT_OTHER_SEGMENT_VIEW_SURESH
-- --------------------------------------------------
      
CREATE VIEW CLIENT_OTHER_SEGMENT_VIEW_SURESH AS      
      
SELECT       
 C2.PARTY_CODE,PARTY_NAME=LONG_NAME,CL_TYPE,CL_BALANCE='',
 --CL_STATUS=''
 CL_STATUS= ( CASE WHEN CL_STATUS='PPB'OR CL_STATUS='BCP'THEN 'Company'ELSE 
					CASE WHEN CL_STATUS='HUF' THEN 'HUF' ELSE 
						CASE WHEN CL_STATUS='IND' THEN 'Individual' END END END),BRANCH_CD,      
 SUB_BROKER,TRADER,AREA,REGION,  
 --SBU=DUMMY9,  
 SBU='HO',   FAMILY,      
 GENDER=ISNULL(C5.SEX,''),
 --OCCUPATION_CODE='',
 OCCUPATION_CODE= ( CASE WHEN U.OCCUPATION IN ('01','02')THEN 'Services' ELSE
					    CASE WHEN U.OCCUPATION = '03' THEN 'Business' ELSE
						CASE WHEN U.OCCUPATION = '04' THEN 'Professional' ELSE
						CASE WHEN U.OCCUPATION = '05' THEN 'Agriculature' ELSE
						CASE WHEN U.OCCUPATION = '06' THEN 'Retired' ELSE
						CASE WHEN U.OCCUPATION = '07' THEN 'Housewife' ELSE
						CASE WHEN U.OCCUPATION = '08' THEN 'Student' ELSE
						CASE WHEN U.OCCUPATION IN ('09','99')THEN 'Others'  END END END END END END END END ) ,
 TAX_STATUS='',
 PAN_NO=PAN_GIR_NO,  
 --KYC_FLAG='',     
 KYC_FLAG='Y',    
 ADDR1=L_ADDRESS1,ADDR2=L_ADDRESS2,ADDR3=L_ADDRESS3,CITY=L_CITY,STATE=L_STATE,ZIP=L_ZIP,NATION=L_NATION,      
 OFFICE_PHONE = OFF_PHONE1,RES_PHONE= RES_PHONE1,MOBILE_NO=MOBILE_PAGER,EMAIL_ID=EMAIL,      
 --BANK_NAME'',
 BANK_NAME=c4.BANK_NAME,
 --BANK_BRANCH='',
 BANK_BRANCH=c4.BRANCH_NAME,BANK_CITY='',      
 ACC_NO=ISNULL(C4.CLTDPID,''),  
 --PAYMODE='',  
 PAYMODE=1, 
 --MICR_NO='' 
 MICR_NO=CD.MICR_NO,      
 DOB=BIRTHDATE,GAURDIAN_NAME='',GAURDIAN_PAN_NO='',NOMINEE_NAME='',NOMINEE_RELATION='',      
 BANK_AC_TYPE = CASE WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'SB' WHEN ISNULL(C4.DEPOSITORY,'') ='SAVING' THEN 'CB' ELSE '' END,      
 --STAT_COMM_MODE='',  
 STAT_COMM_MODE='P',  
 DP_TYPE = ISNULL(C44.DEPOSITORY,''),DPID= ISNULL(C44.BANKID,''),      
 CLTDPID=ISNULL(C44.CLTDPID,''),MODE_HOLDING='',HOLDER2_CODE='',HOLDER2_NAME='',      
 HOLDER2_PAN_NO='',HOLDER2_KYC_FLAG='',HOLDER3_CODE='',      
 HOLDER3_NAME='',HOLDER3_PAN_NO='',HOLDER3_KYC_FLAG='',  
 --BUY_BROK_TABLE_NO='',  
 --SELL_BROK_TABLE_NO='',    
 BUY_BROK_TABLE_NO=1,  
 SELL_BROK_TABLE_NO=1,    
 BROK_EFF_DATE=CONVERT(VARCHAR,GETDATE(),103),REMARK='',UCC_STATUS='',      
 NEFTCODE='',CHEQUENAME='',RESIFAX='',OFFICEFAX='',MAPINID=''      
FROM      
 ANAND1.MSAJAG.DBO.CLIENT1 C1 , ANAND1.MSAJAG.DBO.CLIENT2 C2
	LEFT OUTER JOIN ANAND1.ACCOUNT.DBO.ACMAST     
	ON (CLTCODE = C2.PARTY_CODE)  
	LEFT OUTER JOIN (SELECT PARTY_CODE,c.BANKID,BANK_NAME,BRANCH_NAME,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4 C  
					LEFT OUTER JOIN ANAND1.MSAJAG.DBO.POBANK PO 
					ON PO.BANKID=C.BANKID
					WHERE C.DEPOSITORY IN ('SAVING','CURRENT')) C4      
	ON (C2.PARTY_CODE = C4.PARTY_CODE)      
	LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT5 C5       
	ON (C5.CL_CODE = C2.PARTY_CODE)      
	LEFT OUTER JOIN ANAND1.MSAJAG.DBO.CLIENT_MASTER_UCC_DATA U   
	ON (U.Party_code = C2.PARTY_CODE)
	--LEFT OUTER JOIN (SELECT PARTY_CODE,BANK_NAME,BRANCH_NAME,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4 C4  
	--				LEFT OUTER JOIN ANAND1.MSAJAG.DBO.POBANK PO 
	--				ON PO.BANKID=C4.BANKID
	--				WHERE C4.DEPOSITORY IN ('SAVING','CURRENT'))P
	--ON (P.Party_code=C2.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,BANKID,CLTDPID,DEPOSITORY FROM ANAND1.MSAJAG.DBO.CLIENT4  WHERE DEPOSITORY IN ('CDSL','NDSL') AND DEFDP = 1) C44      
	ON (C2.PARTY_CODE = C44.PARTY_CODE)
	LEFT OUTER JOIN (SELECT PARTY_CODE,MICR_NO FROM ANAND1.MSAJAG.DBO.CLIENT_DETAILS WHERE Micr_No <>'')CD
	ON (C2.PARTY_CODE = CD.PARTY_CODE)
WHERE      
	C1.CL_CODE = C2.CL_CODE      
	AND NOT EXISTS (SELECT PARTY_CODE FROM MFSS_CLIENT MC (NOLOCK) WHERE MC.PARTY_CODE = C2.PARTY_CODE)

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT1
-- --------------------------------------------------
CREATE VIEW [dbo].[CLIENT1]    
AS    
SELECT   
 CL_CODE = PARTY_CODE,   
 SHORT_NAME = PARTY_NAME,   
 LONG_NAME = PARTY_NAME,  
 L_ADDRESS1 = ADDR1,  
 L_ADDRESS2 = ADDR2,  
 L_ADDRESS3 = ADDR3,  
 L_CITY = CITY,    
 L_STATE = [STATE],    
 L_NATION = NATION,  
 L_ZIP = ZIP,    
 FAX = '',    
 RES_PHONE1 = OFFICE_PHONE,    
 RES_PHONE2 = RES_PHONE,    
 MOBILE_PAGER = MOBILE_NO,    
 PAN_GIR_NO = PAN_NO,    
 EMAIL = EMAIL_ID,    
 FAMILY,   
 TRADER,   
 SUB_BROKER,   
 BRANCH_CD,   
 AREA,   
 REGION,   
 CL_TYPE,
 BANK_NAME,
 ACC_NO    
FROM NSEMFSS.DBO.MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.CLIENT2
-- --------------------------------------------------

CREATE VIEW CLIENT2
AS
SELECT
	CL_CODE = PARTY_CODE,
	PARTY_CODE
FROM
	NSEMFSS.dbo.MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.DELIVERYCLT
-- --------------------------------------------------
CREATE VIEW [dbo].[DELIVERYCLT]          
AS          
          
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,PARTY_CODE,QTY=SUM(QTY),INOUT,BRANCH_CD,PARTIPANTCODE,DPCLT     
FROM (    
SELECT SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SCHEME_NAME=SEC_NAME, S.ISIN, PARTY_CODE, QTY = SUM(QTY),           
INOUT = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'O' ELSE 'I' END), BRANCH_CD = 'HO',       
PARTIPANTCODE = MEMBERCODE, DPCLT=(Case When Dp_ID <> '' Then Dp_ID + CLTDPID Else CLTDPID End)
FROM MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M   
WHERE S.SCRIP_CD = M.SCRIP_CD  
AND S.SERIES = M.SERIES  
GROUP BY SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SEC_NAME, S.ISIN, PARTY_CODE, SUB_RED_FLAG, MEMBERCODE, CLTDPID,Dp_ID  ) A    
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,PARTY_CODE,INOUT,BRANCH_CD,PARTIPANTCODE,DPCLT

GO

-- --------------------------------------------------
-- VIEW dbo.DELNET
-- --------------------------------------------------

CREATE VIEW [dbo].[DELNET]
AS        
        
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,QTY=SUM(QTY),INOUT
FROM (  
SELECT SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SCHEME_NAME=SEC_NAME, S.ISIN, QTY = SUM(QTY),         
INOUT = (CASE WHEN SUB_RED_FLAG = 'P' THEN 'O' ELSE 'I' END)
FROM MFSS_SETTLEMENT S, MFSS_SCRIP_MASTER M 
WHERE S.SCRIP_CD = M.SCRIP_CD
AND S.SERIES = M.SERIES
GROUP BY SETT_NO, SETT_TYPE, S.SCRIP_CD, S.SERIES, SEC_NAME, S.ISIN, SUB_RED_FLAG ) A  
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD,SERIES,SCHEME_NAME,ISIN,INOUT

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

-- --------------------------------------------------
-- VIEW dbo.MFSS_CLIENT_NSEMFSS
-- --------------------------------------------------
CREATE VIEW MFSS_CLIENT_NSEMFSS  
AS  
SELECT PARTY_CODE,PARTY_NAME,ADDEDON   
from BSEMFSS..MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.MFSS_CONFIRMVIEW
-- --------------------------------------------------
CREATE VIEW [dbo].[MFSS_CONFIRMVIEW] 

AS      

SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END),
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=(CASE WHEN VAL_PERC = 'V' THEN NORMAL ELSE AMOUNT*NORMAL/100 END)*G.SERVICE_TAX/100,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C, MFSS_BROKERAGE_MASTER M, BROKTABLE B, GLOBALS G
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.PARTY_CODE = M.PARTY_CODE
AND B.TABLE_NO = (CASE WHEN SUB_RED_FLAG = 'P' 
				       THEN M.BUY_BROK_TABLE_NO 
					   ELSE M.SELL_BROK_TABLE_NO 
				  END)
AND ORDER_DATE BETWEEN M.FROMDATE AND M.TODATE
AND ORDER_DATE BETWEEN YEAR_START_DT AND YEAR_END_DT
AND T.AMOUNT > B.LOWER_LIM AND T.AMOUNT <= B.UPPER_LIM
AND T.SETT_NO <> ''
UNION ALL
SELECT CONTRACTNO=CONVERT(VARCHAR(7),'0'),BILLNO='0',ORDER_NO,STATUS,SETT_NO,SETT_TYPE,
SCRIP_CD,SERIES,ISIN,T.PARTY_CODE,SETTFLAG,F_CL_KYC,F_CL_PAN,APPLN_NO,PURCHASE_TYPE,
DP_SETTLMENT,DP_ID,DPCODE,T.CLTDPID,FOLIONO,AMOUNT,QTY,T.MODE_HOLDING,S_CLIENTID,
S_CL_KYC,S_CL_PAN,T_CLIENTID,T_CL_KYC,T_CL_PAN,USER_ID,BRANCH_ID,SUB_RED_FLAG,
ORDER_DATE,ORDER_TIME,MEMBERCODE,
BROKERAGE=0,
INS_CHRG=0,TURN_TAX=0,OTHER_CHRG=0,SEBI_TAX=0,BROKER_CHRG=0,
SERVICE_TAX=0,
FILLER1,FILLER2,FILLER3
FROM MFSS_TRADE T, MFSS_CLIENT C
WHERE T.PARTY_CODE = C.PARTY_CODE 
AND T.AMOUNT = 0
AND T.SETT_NO <> ''

GO

-- --------------------------------------------------
-- VIEW dbo.NSE_MFSS_CLIENT_MFSS
-- --------------------------------------------------

CREATE VIEW [dbo].[NSE_MFSS_CLIENT_MFSS]
AS
SELECT PARTY_CODE,PARTY_NAME,addedon 
from nSEMFSS..MFSS_CLIENT

GO

-- --------------------------------------------------
-- VIEW dbo.RPT_DELCDSLBALANCE_NEW
-- --------------------------------------------------
 
CREATE VIEW [dbo].[RPT_DELCDSLBALANCE_NEW] AS     
SELECT PARTY_CODE='',DPID,CLTDPID,SCRIP_CD,SERIES,ISIN,FREEBAL=SUM(FREEBAL),CURRBAL=SUM(CURRBAL),FREEZEBAL=SUM(FREEZEBAL),    
LOCKINBAL=SUM(LOCKINBAL),PLEDGEBAL=SUM(PLEDGEBAL),DPVBAL=SUM(DPVBAL),DPCBAL=SUM(DPCBAL),RPCBAL=0,ELIMBAL=0,    
EARMARKBAL=0,REMLOCKBAL=0,TOTALBALANCE=SUM(TOTALBALANCE)    
FROM DELCDSLBALANCE    
GROUP BY DPID,CLTDPID,SCRIP_CD,SERIES,ISIN

GO

-- --------------------------------------------------
-- VIEW dbo.Synergy_Clientdata
-- --------------------------------------------------

CREATE view [dbo].[Synergy_Clientdata]
as

select client_code,first_hold_name,itpan,second_hold_name,second_hold_itpan,
third_hold_name,third_hold_itpan 
from [ABCSOORACLEMDLW].synergy.dbo.tbl_client_master

GO

