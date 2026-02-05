-- DDL Export
-- Server: 10.253.33.87
-- Database: table transfer
-- Exported: 2026-02-05T12:29:51.592105

USE table transfer;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------

  -- exec rebuild_index2 'AdventureWorksDW'
CREATE procedure [dbo].[rebuild_index]
@database varchar(100)
as
declare @db_id  int
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
DECLARE @MAXROWID int;
DECLARE @MINROWID int;
DECLARE @CURRROWID int; 
DECLARE @ID int;    
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function    
-- and convert object and index IDs to names.    
Create table #work_to_do(id bigint primary key identity(1,1),objectid int,indexid int,partitionnum bigint,frag float )  

insert into #work_to_do(objectid,indexid,partitionnum,frag)
 select
object_id AS objectid,    
index_id AS indexid,    
partition_number AS partitionnum,    
avg_fragmentation_in_percent AS frag    
 FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')    
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0; 

  
   --select @ID =ID from #work_to_do 
  
  SELECT @MINROWID=MIN(ID),@MAXROWID=MAX(ID) FROM #work_to_do WITH(NOLOCK) ; 

  SET @CURRROWID=@MINROWID;  

WHILE (@CURRROWID<=@MAXROWID)
   BEGIN 
 
    SELECT  @objectid=objectid , @indexid=indexid  , @partitionnum=partitionnum , @frag=frag 
     FROM #work_to_do WHERE ID=@CURRROWID 
     set @CURRROWID=@CURRROWID+1   


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
select N'Executed: ' + @command; 
end

      
-- Drop the temporary table.    
DROP TABLE #work_to_do;

GO

-- --------------------------------------------------
-- TABLE dbo.ALG_Def_OUTPUT_File_Format
-- --------------------------------------------------
CREATE TABLE [dbo].[ALG_Def_OUTPUT_File_Format]
(
    [Periodicity] VARCHAR(10) NOT NULL,
    [FileFormat] VARCHAR(500) NOT NULL,
    [Product] VARCHAR(25) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ALGFILEDATA_CRP
-- --------------------------------------------------
CREATE TABLE [dbo].[ALGFILEDATA_CRP]
(
    [FileFormat] VARCHAR(8000) NULL,
    [server] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_ACT_SQUP
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_ACT_SQUP]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [SQUAREUP_AMT] MONEY NULL,
    [SQUAREUP_TOTAL_AMT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BO_Subbrokers
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_Subbrokers]
(
    [segment] VARCHAR(25) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] VARCHAR(100) NULL,
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
    [Email] VARCHAR(250) NULL,
    [Com_Perc] MONEY NULL,
    [branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL,
    [B2C] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_brok_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[client_brok_Details]
(
    [Cl_Code] VARCHAR(10) NOT NULL,
    [Exchange] VARCHAR(3) NOT NULL,
    [Segment] VARCHAR(7) NOT NULL,
    [Brok_Scheme] TINYINT NULL,
    [Trd_Brok] INT NULL,
    [Del_Brok] INT NULL,
    [Ser_Tax] TINYINT NULL,
    [Ser_Tax_Method] TINYINT NULL,
    [Credit_Limit] INT NOT NULL,
    [InActive_From] DATETIME NULL,
    [Print_Options] TINYINT NULL,
    [No_Of_Copies] INT NULL,
    [Participant_Code] VARCHAR(15) NULL,
    [Custodian_Code] VARCHAR(50) NULL,
    [Inst_Contract] CHAR(1) NULL,
    [Round_Style] INT NULL,
    [STP_Provider] VARCHAR(5) NULL,
    [STP_Rp_Style] INT NULL,
    [Market_Type] INT NULL,
    [Multiplier] INT NULL,
    [Charged] INT NULL,
    [Maintenance] INT NULL,
    [Reqd_By_Exch] INT NULL,
    [Reqd_By_Broker] INT NULL,
    [Client_Rating] VARCHAR(10) NULL,
    [Debit_Balance] CHAR(1) NULL,
    [Inter_Sett] CHAR(1) NULL,
    [TRD_STT] MONEY NULL,
    [Trd_Tran_Chrgs] MONEY NULL,
    [Trd_Sebi_Fees] MONEY NULL,
    [Trd_Stamp_Duty] MONEY NULL,
    [Trd_Other_Chrgs] MONEY NULL,
    [Trd_Eff_Dt] DATETIME NULL,
    [Del_Stt] MONEY NULL,
    [Del_Tran_Chrgs] MONEY NULL,
    [Del_SEBI_Fees] MONEY NULL,
    [Del_Stamp_Duty] MONEY NULL,
    [Del_Other_Chrgs] MONEY NULL,
    [Del_Eff_Dt] DATETIME NULL,
    [Rounding_Method] VARCHAR(10) NULL,
    [Round_To_Digit] TINYINT NULL,
    [Round_To_Paise] INT NULL,
    [Fut_Brok] INT NULL,
    [Fut_Opt_Brok] INT NULL,
    [Fut_Fut_Fin_Brok] INT NULL,
    [Fut_Opt_Exc] INT NULL,
    [Fut_Brok_Applicable] INT NULL,
    [Fut_Stt] SMALLINT NULL,
    [Fut_Tran_Chrgs] SMALLINT NULL,
    [Fut_Sebi_Fees] SMALLINT NULL,
    [Fut_Stamp_Duty] SMALLINT NULL,
    [Fut_Other_Chrgs] SMALLINT NULL,
    [Status] CHAR(1) NULL,
    [Modifiedon] DATETIME NULL,
    [Modifiedby] VARCHAR(25) NULL,
    [Imp_Status] TINYINT NULL,
    [Pay_B3B_Payment] CHAR(1) NULL,
    [Pay_Bank_name] VARCHAR(50) NULL,
    [Pay_Branch_name] VARCHAR(50) NULL,
    [Pay_AC_No] VARCHAR(10) NULL,
    [Pay_payment_Mode] CHAR(1) NULL,
    [Brok_Eff_Date] DATETIME NULL,
    [Inst_Trd_Brok] INT NULL,
    [Inst_Del_Brok] INT NULL,
    [SYSTEMDATE] DATETIME NULL,
    [Active_Date] DATETIME NULL,
    [CheckActiveClient] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[client_Details]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [trader] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_city] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_state] VARCHAR(50) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [ward_no] VARCHAR(50) NULL,
    [sebi_regn_no] VARCHAR(25) NULL,
    [res_phone1] VARCHAR(15) NULL,
    [res_phone2] VARCHAR(15) NULL,
    [off_phone1] VARCHAR(15) NULL,
    [off_phone2] VARCHAR(15) NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [cl_type] VARCHAR(3) NOT NULL,
    [cl_status] VARCHAR(3) NOT NULL,
    [family] VARCHAR(10) NOT NULL,
    [region] VARCHAR(50) NULL,
    [area] VARCHAR(10) NULL,
    [p_address1] VARCHAR(50) NULL,
    [p_city] VARCHAR(20) NULL,
    [p_address2] VARCHAR(50) NULL,
    [p_state] VARCHAR(15) NULL,
    [p_address3] VARCHAR(50) NULL,
    [p_nation] VARCHAR(15) NULL,
    [p_zip] VARCHAR(10) NULL,
    [p_phone] VARCHAR(15) NULL,
    [addemailid] VARCHAR(230) NULL,
    [sex] CHAR(1) NULL,
    [dob] DATETIME NULL,
    [introducer] VARCHAR(30) NULL,
    [approver] VARCHAR(30) NULL,
    [interactmode] TINYINT NULL,
    [passport_no] VARCHAR(30) NULL,
    [passport_issued_at] VARCHAR(30) NULL,
    [passport_issued_on] DATETIME NULL,
    [passport_expires_on] DATETIME NULL,
    [licence_no] VARCHAR(30) NULL,
    [licence_issued_at] VARCHAR(30) NULL,
    [licence_issued_on] DATETIME NULL,
    [licence_expires_on] DATETIME NULL,
    [rat_card_no] VARCHAR(30) NULL,
    [rat_card_issued_at] VARCHAR(30) NULL,
    [rat_card_issued_on] DATETIME NULL,
    [votersid_no] VARCHAR(30) NULL,
    [votersid_issued_at] VARCHAR(30) NULL,
    [votersid_issued_on] DATETIME NULL,
    [it_return_yr] VARCHAR(30) NULL,
    [it_return_filed_on] DATETIME NULL,
    [regr_no] VARCHAR(50) NULL,
    [regr_at] VARCHAR(50) NULL,
    [regr_on] DATETIME NULL,
    [regr_authority] VARCHAR(50) NULL,
    [client_agreement_on] DATETIME NULL,
    [sett_mode] VARCHAR(50) NULL,
    [dealing_with_other_tm] VARCHAR(50) NULL,
    [other_ac_no] VARCHAR(50) NULL,
    [introducer_id] VARCHAR(50) NULL,
    [introducer_relation] VARCHAR(50) NULL,
    [repatriat_bank] NUMERIC(18, 0) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [chk_kyc_form] TINYINT NULL,
    [chk_corporate_deed] TINYINT NULL,
    [chk_bank_certificate] TINYINT NULL,
    [chk_annual_report] TINYINT NULL,
    [chk_networth_cert] TINYINT NULL,
    [chk_corp_dtls_recd] TINYINT NULL,
    [Bank_Name] VARCHAR(50) NULL,
    [Branch_Name] VARCHAR(50) NULL,
    [AC_Type] VARCHAR(10) NULL,
    [AC_Num] VARCHAR(20) NULL,
    [Depository1] VARCHAR(7) NULL,
    [DpId1] VARCHAR(16) NULL,
    [CltDpId1] VARCHAR(16) NULL,
    [Poa1] CHAR(1) NULL,
    [Depository2] VARCHAR(7) NULL,
    [DpId2] VARCHAR(16) NULL,
    [CltDpId2] VARCHAR(16) NULL,
    [Poa2] CHAR(1) NULL,
    [Depository3] VARCHAR(7) NULL,
    [DpId3] VARCHAR(16) NULL,
    [CltDpId3] VARCHAR(16) NULL,
    [Poa3] CHAR(1) NULL,
    [rel_mgr] VARCHAR(10) NULL,
    [c_group] VARCHAR(10) NULL,
    [sbu] VARCHAR(10) NULL,
    [Status] CHAR(1) NULL,
    [Imp_Status] TINYINT NULL,
    [ModifidedBy] VARCHAR(25) NULL,
    [ModifidedOn] DATETIME NULL,
    [Bank_id] NUMERIC(18, 0) NULL,
    [Mapin_id] VARCHAR(12) NULL,
    [UCC_Code] VARCHAR(12) NULL,
    [Micr_No] VARCHAR(10) NULL,
    [Director_name] VARCHAR(200) NULL,
    [paylocation] VARCHAR(20) NULL,
    [FMCode] VARCHAR(10) NULL,
    [BSECM_LAST_DATE] DATETIME NULL,
    [NSECM_LAST_DATE] DATETIME NULL,
    [BSEFO_LAST_DATE] DATETIME NULL,
    [NSEFO_LAST_DATE] DATETIME NULL,
    [NCDEX_LAST_DATE] DATETIME NULL,
    [MCX_LAST_DATE] DATETIME NULL,
    [NSX_LAST_DATE] DATETIME NULL,
    [MCD_LAST_DATE] DATETIME NULL,
    [comb_LAST_DATE] DATETIME NULL,
    [bsecm] VARCHAR(1) NULL,
    [nsecm] VARCHAR(1) NULL,
    [nsefo] VARCHAR(1) NULL,
    [mcdx] VARCHAR(1) NULL,
    [ncdx] VARCHAR(1) NULL,
    [bsefo] VARCHAR(1) NULL,
    [mcd] VARCHAR(1) NULL,
    [nsx] VARCHAR(1) NULL,
    [Last_inactive_date] DATETIME NULL,
    [First_Active_date] DATETIME NULL,
    [NBFC_cli] VARCHAR(1) NULL,
    [Org_SB] VARCHAR(10) NULL,
    [Org_branch] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.finmast
-- --------------------------------------------------
CREATE TABLE [dbo].[finmast]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SUBGROUP] VARCHAR(10) NULL,
    [FAMILY] VARCHAR(10) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [TRADERNAME] VARCHAR(100) NULL,
    [SBTAG] VARCHAR(10) NULL,
    [ACTIVE] VARCHAR(10) NULL,
    [FLAG] VARCHAR(10) NULL,
    [spmark] VARCHAR(10) NULL,
    [modified] VARCHAR(2) NULL,
    [int_rate] MONEY NULL,
    [Org_SB] VARCHAR(10) NULL,
    [Org_branch] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecm_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecm_ledger]
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
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_CompRisk_Cli
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_CompRisk_Cli]
(
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL,
    [PROJ_MTM_PL] MONEY NULL,
    [GenDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_CompRisk_Cli_history
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_CompRisk_Cli_history]
(
    [Ledger] MONEY NULL,
    [NoDel_PL] MONEY NULL,
    [Option_PL] MONEY NULL,
    [Holding_App] MONEY NULL,
    [Holding_NonApp] MONEY NULL,
    [Holding_Total] MONEY NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [PR_CurrPL] MONEY NULL,
    [PR_Derivatives] MONEY NULL,
    [PR_Commodities] MONEY NULL,
    [PR_Currency] MONEY NULL,
    [PR_Cash_App] MONEY NULL,
    [PR_Cash_NonApp] MONEY NULL,
    [PR_ProjRisk] MONEY NULL,
    [PR_PureRisk] MONEY NULL,
    [ES_Derivatives] MONEY NULL,
    [ES_Commodities] MONEY NULL,
    [ES_Currency] MONEY NULL,
    [ES_Cash_App] MONEY NULL,
    [ES_Cash_NonApp] MONEY NULL,
    [ES_ProjRisk] MONEY NULL,
    [ES_PureRisk] MONEY NULL,
    [Imargin] MONEY NULL,
    [Deposit] MONEY NULL,
    [Colleteral] MONEY NULL,
    [PROJ_MTM_PL] MONEY NULL,
    [GenDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PARTY_PLEDGE_DATA_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PARTY_PLEDGE_DATA_LOG]
(
    [RMS_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [LEDGER_BAL] MONEY NULL,
    [CLIENT_PRIORITY] SMALLINT NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(50) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [ACCNO] VARCHAR(50) NULL,
    [QTY] INT NULL,
    [PLEDGE_QTY] INT NULL,
    [FREE_QTY] INT NULL,
    [HOLD_VALUE] MONEY NULL,
    [AVG_CLOSING] MONEY NULL,
    [PLEDGEABLE_QTY] INT NULL,
    [PLEDGEABLE_VALUE] MONEY NULL,
    [PREVDAY_PLEDEGE_QTY] INT NULL,
    [RELEASE_QTY] INT NULL,
    [SCRIP_PRIORITY] SMALLINT NULL,
    [ProcessDate] DATETIME NOT NULL,
    [USER_BY] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_collection
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_collection]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Category] VARCHAR(5) NULL,
    [Cash] DECIMAL(20, 2) NULL,
    [Derivatives] DECIMAL(20, 2) NULL,
    [Currency] DECIMAL(20, 2) NULL,
    [Commodities] DECIMAL(20, 2) NULL,
    [DP] DECIMAL(20, 2) NULL,
    [NBFC] DECIMAL(20, 2) NULL,
    [Deposit] MONEY NULL,
    [Net] MONEY NULL,
    [App.Holding] MONEY NULL,
    [Non-App.Holding] MONEY NULL,
    [Holding] MONEY NULL,
    [SB Balance] MONEY NULL,
    [ProjRisk] MONEY NULL,
    [PureRisk] MONEY NULL,
    [MOS] MONEY NULL,
    [UnbookedLoss] MONEY NULL,
    [IMargin] MONEY NULL,
    [Total_Colleteral] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Un_Reco] MONEY NULL,
    [Exposure] MONEY NULL,
    [PureAdj] MONEY NULL,
    [SBCrAfterPureAdj] MONEY NULL,
    [ProjAdj] MONEY NULL,
    [SBCrAfterProjAdj] MONEY NULL,
    [SB_Credit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_collection_ABL
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_collection_ABL]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Category] VARCHAR(5) NULL,
    [Cash] DECIMAL(20, 2) NULL,
    [Derivatives] DECIMAL(20, 2) NULL,
    [Currency] DECIMAL(20, 2) NULL,
    [Commodities] DECIMAL(20, 2) NULL,
    [DP] DECIMAL(20, 2) NULL,
    [NBFC] DECIMAL(20, 2) NULL,
    [Deposit] MONEY NULL,
    [Net] MONEY NULL,
    [App.Holding] MONEY NULL,
    [Non-App.Holding] MONEY NULL,
    [Holding] MONEY NULL,
    [SB Balance] MONEY NULL,
    [ProjRisk] MONEY NULL,
    [PureRisk] MONEY NULL,
    [MOS] MONEY NULL,
    [UnbookedLoss] MONEY NULL,
    [IMargin] MONEY NULL,
    [Total_Colleteral] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Un_Reco] MONEY NULL,
    [Exposure] MONEY NULL,
    [PureAdj] MONEY NULL,
    [SBCrAfterPureAdj] MONEY NULL,
    [ProjAdj] MONEY NULL,
    [SBCrAfterProjAdj] MONEY NULL,
    [SB_Credit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_GroupMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_GroupMaster]
(
    [PID_tbl_RMS_GroupMaster] INT NOT NULL,
    [GroupCode] VARCHAR(10) NULL,
    [AccessCode] VARCHAR(400) NULL,
    [Access_Level] VARCHAR(50) NULL,
    [Label] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Vw_RMS_Client_Vertical
-- --------------------------------------------------
CREATE TABLE [dbo].[Vw_RMS_Client_Vertical]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(20) NULL,
    [RegionName] VARCHAR(50) NULL,
    [Branch] VARCHAR(10) NULL,
    [BranchName] VARCHAR(40) NULL,
    [SB] VARCHAR(10) NULL,
    [SB_Name] VARCHAR(100) NULL,
    [Client] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Category] VARCHAR(10) NULL,
    [RiskCategoryCode] INT NULL,
    [Priorities] VARCHAR(15) NULL,
    [DrNoOfDays] INT NULL,
    [Debit_Priorities] VARCHAR(15) NULL,
    [Classification] VARCHAR(10) NULL,
    [Cli_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(10) NULL,
    [Org_SB] VARCHAR(10) NULL,
    [Org_branch] VARCHAR(10) NULL
);

GO

