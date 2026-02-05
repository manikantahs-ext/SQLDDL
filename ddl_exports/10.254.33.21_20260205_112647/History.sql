-- DDL Export
-- Server: 10.254.33.21
-- Database: History
-- Exported: 2026-02-05T11:27:07.641947

USE History;
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
-- FUNCTION dbo.FN_EQUITY_CLS_RATE_hist
-- --------------------------------------------------
  
CREATE Function dbo.FN_EQUITY_CLS_RATE_hist(@processdate datetime)          
returns @clsrate table
(
clsrate money,
isin varchar(50)
)
As          
BEGIN
insert into @clsrate
 Select Clsrate=A.RATE,          
        B.ISIN        
 From   (select * from CP_BSECM_hist where cls_date between @processdate and @processdate+ ' 23:59:59' ) A     
        Inner Join general.dbo.Scrip_master B(NOLOCK)          
         On A.SCODE = B.BSECODE          
 Union       
 Select Clsrate=A.CLS,          
        B.ISIN        
 From   (select * from CP_NSECM_hist where cls_date between @processdate and @processdate+ ' 23:59:59') A     
        Left Join general.dbo.Scrip_master B(NOLOCK)          
         On A.SCRIP = B.NSESYMBOL          
            And Case          
                 When A.SERIES In ('EQ', 'BE') Then 'EQ'          
                 Else A.SERIES          
                End = Case          
                       When B.NSESERIES In ('EQ', 'BE') Then 'EQ'          
                       Else B.NSESERIES          
                      End          
 Where  --B.NSESYMBOL IS NULL AND           
  Isin Is Not Null 
  
return
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.SplitStringToResultSet
-- --------------------------------------------------

/*---------------------------------------------------------------------------------            
Author      : Anand Sharan                                      
Create date : 17/Jan/2019                                      
Description : <Split The string using seperator>            
---------------------------------------------------------------------------------*/ 
CREATE FUNCTION [dbo].[SplitStringToResultSet] (@value VARCHAR(MAX), @separator CHAR(1))    
RETURNS TABLE    
AS RETURN
WITH r AS (    
  SELECT value, CAST(NULL AS VARCHAR(MAX)) [x], 0 [no] FROM (SELECT RTRIM(cast(@value AS varchar(MAX))) [value]) AS j    
  UNION ALL    
  SELECT RIGHT(value, LEN(value) - CASE CHARINDEX(@separator, value) WHEN 0 THEN LEN(value) ELSE CHARINDEX(@separator, value) end) [value]    
  , LEFT(r.[value], CASE CHARINDEX(@separator, r.value) WHEN 0 THEN LEN(r.value) ELSE ABS(CHARINDEX(@separator, r.[value])-1) end ) [x]    
  , [no] + 1 [no]    
  FROM r   
  WHERE value > '')    
      
SELECT x [value], [no] FROM r WHERE x IS NOT NULL

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_COMPANYWISE_HIST
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_UpdateDate] ON [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST] ([UPDATE_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_COMPANYWISE_HIST
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ALG_FINALLIMIT_COMPANYWISE_HIST_INSERTDATE] ON [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST] ([INSERTDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Idx_ALG_FinalLimit_Archive_DT] ON [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE] ([INSERTDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Idx_ALG_FinalLimit_Archive_ZRBSP] ON [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE] ([ZONE], [REGION], [BRANCH], [SB], [PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_HIST_ARCHIVE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Idx_ALG_FinalLimit_Archive_DT] ON [dbo].[ALG_FINALLIMIT_HIST_ARCHIVE] ([InsertDate])

GO

-- --------------------------------------------------
-- INDEX dbo.ALG_FINALLIMIT_HIST_ARCHIVE
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Idx_ALG_FinalLimit_Archive_ZRBSP] ON [dbo].[ALG_FINALLIMIT_HIST_ARCHIVE] ([zone], [region], [branch], [sb], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.ASB7_Clidetails_CrDet_Hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMSDATE] ON [dbo].[ASB7_Clidetails_CrDet_Hist] ([RMS_date], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.BSEFO_MARH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_sauda_date] ON [dbo].[BSEFO_MARH] ([sauda_Date], [shortage])

GO

-- --------------------------------------------------
-- INDEX dbo.BSEFO_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXCL_sauda_date] ON [dbo].[BSEFO_MARH] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.BSX_MarginViolation
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [dtPcd] ON [dbo].[BSX_MarginViolation] ([sauda_Date], [clcode], [shortage])

GO

-- --------------------------------------------------
-- INDEX dbo.BSX_MARH
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_sauda_date] ON [dbo].[BSX_MARH] ([sauda_Date], [clcode], [shortage])

GO

-- --------------------------------------------------
-- INDEX dbo.CLIENT_COLLATERALS_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_PC_Isin] ON [dbo].[CLIENT_COLLATERALS_HIST] ([Party_Code], [Isin])

GO

-- --------------------------------------------------
-- INDEX dbo.Client_DrNODs
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_Pty] ON [dbo].[Client_DrNODs] ([party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.ClientCategoryInfo
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ftpty] ON [dbo].[ClientCategoryInfo] ([UpdateOn], [Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.ClientRiskCategory
-- --------------------------------------------------
CREATE CLUSTERED INDEX [dt_pty] ON [dbo].[ClientRiskCategory] ([Upd_date], [Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.CP_BSECM_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_CP_BSECM_HIST_DT] ON [dbo].[CP_BSECM_hist] ([CLS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.cp_mcx_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXTradeDate] ON [dbo].[cp_mcx_hist] ([TradeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.cp_ncdex_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXCLS_Date] ON [dbo].[cp_ncdex_hist] ([CLS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.CP_NSECM_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_CP_NSECM_HIST_DT] ON [dbo].[CP_NSECM_hist] ([Cls_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.CP_NSECM_hist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_CP_NSECM_hist_mkt_type_scrip_series] ON [dbo].[CP_NSECM_hist] ([mkt_type], [scrip], [series]) INCLUDE ([fname], [Cls_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.cp_nseFO_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Cls_Date] ON [dbo].[cp_nseFO_hist] ([Cls_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.CP_NSX_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXISIN] ON [dbo].[CP_NSX_hist] ([mkt_type])

GO

-- --------------------------------------------------
-- INDEX dbo.DebitClientSms
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_cli] ON [dbo].[DebitClientSms] ([party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.DebitClientSms_LC1
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxpty] ON [dbo].[DebitClientSms_LC1] ([SMS_trigger_Datetime], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.EXCHANGEMARGINREPORTING_DATA_LD_HIST
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_INSERTDATETIME] ON [dbo].[EXCHANGEMARGINREPORTING_DATA_LD_HIST] ([INSERTDATETIME])

GO

-- --------------------------------------------------
-- INDEX dbo.FINAL_ANKIT
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [f] ON [dbo].[FINAL_ANKIT] ([mon_rms], [mon_year])

GO

-- --------------------------------------------------
-- INDEX dbo.FINAL_siva
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [F] ON [dbo].[FINAL_siva] ([party_code], [rms_date])

GO

-- --------------------------------------------------
-- INDEX dbo.fovar_margin
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXISIN] ON [dbo].[fovar_margin] ([ISIN])

GO

-- --------------------------------------------------
-- INDEX dbo.MCD_MarginViolation
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Sauda_date] ON [dbo].[MCD_MarginViolation] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.MCD_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [dtPcd] ON [dbo].[MCD_MARH] ([sauda_Date], [clcode])

GO

-- --------------------------------------------------
-- INDEX dbo.MCX_MarginViolation
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Sauda_date] ON [dbo].[MCX_MarginViolation] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.MCX_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXCL_Sauda_date] ON [dbo].[MCX_MARH] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.miles_StockholdingData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_missing_miles_StockholdingData_RptDt] ON [dbo].[miles_StockholdingData] ([RptDt]) INCLUDE ([Client_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.miles_StockholdingData
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXClient_Code] ON [dbo].[miles_StockholdingData] ([Client_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.nbfc_ledger
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXvdt] ON [dbo].[nbfc_ledger] ([vdt])

GO

-- --------------------------------------------------
-- INDEX dbo.nbfc_miles_ledger
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_nbfc_miles_ledger] ON [dbo].[nbfc_miles_ledger] ([TDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.NCDEX_MarginViolation
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Sauda_date] ON [dbo].[NCDEX_MarginViolation] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.NCDEX_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXCL_Sauda_date] ON [dbo].[NCDEX_MARH] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSEFO_MarginViolation
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Sauda_date] ON [dbo].[NSEFO_MarginViolation] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSEFO_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXCL_Sauda_date] ON [dbo].[NSEFO_MARH] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSEFO_REVERSEFILE_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXPDATE] ON [dbo].[NSEFO_REVERSEFILE_HIST] ([PDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.NSX_MarginViolation
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Sauda_date] ON [dbo].[NSX_MarginViolation] ([sauda_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.NSX_MARH
-- --------------------------------------------------
CREATE CLUSTERED INDEX [dtPcd] ON [dbo].[NSX_MARH] ([sauda_Date], [clcode])

GO

-- --------------------------------------------------
-- INDEX dbo.ORMS_SB_DEPOSIT_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idxsb] ON [dbo].[ORMS_SB_DEPOSIT_hist] ([rms_date], [Sub_broker])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_BadDebts
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXSub_Broker] ON [dbo].[RMS_BadDebts] ([Sub_Broker])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_Client_Debit_History
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Update_date] ON [dbo].[RMS_Client_Debit_History] ([update_date])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_CompRisk_Cli_history
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_CompRisk_Cli_history] ON [dbo].[RMS_CompRisk_Cli_history] ([GenDate], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_CompRisk_Cli_history_new
-- --------------------------------------------------
CREATE CLUSTERED INDEX [drcli] ON [dbo].[RMS_CompRisk_Cli_history_new] ([GenDate], [party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_DtclFi
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_Date_Party_code] ON [dbo].[RMS_DtclFi] ([RMS_Date], [Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_DtclFi_Closed
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_Date] ON [dbo].[RMS_DtclFi_Closed] ([RMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_DtclFi_summ
-- --------------------------------------------------
CREATE CLUSTERED INDEX [DTCLI] ON [dbo].[RMS_DtclFi_summ] ([RMS_date], [Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_DtclFi12March
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_Date] ON [dbo].[RMS_DtclFi12March] ([RMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_DtSBFi
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_Date] ON [dbo].[RMS_DtSBFi] ([RMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.rms_holding
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_upd_date] ON [dbo].[rms_holding] ([upd_date])

GO

-- --------------------------------------------------
-- INDEX dbo.rms_holding_archive_abha
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_upd_date] ON [dbo].[rms_holding_archive_abha] ([upd_date])

GO

-- --------------------------------------------------
-- INDEX dbo.SB_NonCashCollateral
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Dt_SB] ON [dbo].[SB_NonCashCollateral] ([Updated_on], [SB])

GO

-- --------------------------------------------------
-- INDEX dbo.SB_Risk_middleware
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXRMS_Date] ON [dbo].[SB_Risk_middleware] ([RMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.SBCategoryInfo
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXSUB_BROKER] ON [dbo].[SBCategoryInfo] ([SUB_BROKER])

GO

-- --------------------------------------------------
-- INDEX dbo.securityholdingdata_rpt_hist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_securityholdingdata_rpt_hist_Update_Date] ON [dbo].[securityholdingdata_rpt_hist] ([Update_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.SqData
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_clSBpro] ON [dbo].[SqData] ([ProcessDate], [party_code], [SB_Type])

GO

-- --------------------------------------------------
-- INDEX dbo.SQUAREUP_CASH_NBFC
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_UPDT] ON [dbo].[SQUAREUP_CASH_NBFC] ([UPDT])

GO

-- --------------------------------------------------
-- INDEX dbo.SQUAREUP_CLIENT_NBFC
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_UPDT] ON [dbo].[SQUAREUP_CLIENT_NBFC] ([updt])

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_datewise_cowise_balance
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Party_code] ON [dbo].[tbl_datewise_cowise_balance] ([PARTY_CODE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_FO_COLLATERAL_PLEDGE_ALLOCATION_DATA_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_date] ON [dbo].[TBL_FO_COLLATERAL_PLEDGE_ALLOCATION_DATA_HIST] ([MARGINDATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_FO_COLLATERAL_PLEDGE_FIN_SUMMARY_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_date] ON [dbo].[TBL_FO_COLLATERAL_PLEDGE_FIN_SUMMARY_HIST] ([MARGINDate])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_LAS_CLI_NOT_FOR_PLEDGE
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXRMS_DATE] ON [dbo].[TBL_LAS_CLI_NOT_FOR_PLEDGE] ([RMS_Date])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_LAS_CLI_NOT_FOR_PLEDGE_HOLDING
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXRMS_DATE] ON [dbo].[TBL_LAS_CLI_NOT_FOR_PLEDGE_HOLDING] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_LAS_CLIENT_SCRIP_DATA
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXRMS_DATE] ON [dbo].[TBL_LAS_CLIENT_SCRIP_DATA] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_LAS_CLIENT_SCRIP_DATA_ALLOCATED
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IXRMS_DATE] ON [dbo].[TBL_LAS_CLIENT_SCRIP_DATA_ALLOCATED] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_pledge_calculation_history
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_pc_isin_date] ON [dbo].[tbl_pledge_calculation_history] ([Upddate], [party_code], [isin])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_RMS_collection_BRANCH_Hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE] ON [dbo].[tbl_RMS_collection_BRANCH_Hist] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_CLI_ABL_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE_ABL] ON [dbo].[TBL_RMS_COLLECTION_CLI_ABL_HIST] ([RMS_DATE], [Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_CLI_ACBPL_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE_ACBL] ON [dbo].[TBL_RMS_COLLECTION_CLI_ACBPL_HIST] ([RMS_DATE], [Party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_CLIENT_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IDX_TBL_RMS_COLLECTION_CLIENT_HIST_File_Nine] ON [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST] ([RMS_DATE], [Client])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_CLIENT_HIST_QTR_DATA
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE] ON [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST_QTR_DATA] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_rms_collection_sb
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_sbCatPrioRCat] ON [dbo].[tbl_rms_collection_sb] ([Upd_date], [Sub_Broker], [cli_category])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_SB_ABL_HIST
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE] ON [dbo].[TBL_RMS_COLLECTION_SB_ABL_HIST] ([RMS_DATE], [Sub_Broker])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_RMS_COLLECTION_SB_ACBPL_HIST
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_RMS_DATE] ON [dbo].[TBL_RMS_COLLECTION_SB_ACBPL_HIST] ([RMS_DATE], [Sub_Broker])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_RMS_collection_SB_Hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_RMS_DATE] ON [dbo].[tbl_RMS_collection_SB_Hist] ([RMS_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_rms_collection_subbroker_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Pdate] ON [dbo].[tbl_rms_collection_subbroker_hist] ([pdate])

GO

-- --------------------------------------------------
-- INDEX dbo.TEMP_FOR_DELIVERY
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [T] ON [dbo].[TEMP_FOR_DELIVERY] ([PARTY_CODE], [START_DATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TEMP_FOR_TRD
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [T] ON [dbo].[TEMP_FOR_TRD] ([CLTCODE], [MON_VDT], [YEAR_VDT])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B612215F810] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Cal_SBCategory
-- --------------------------------------------------
CREATE PROC Cal_SBCategory  
AS    
BEGIN    
  
  
CREATE TABLE #ROI    
(    
 SUB_BROKER VARCHAR(20),    
 GROSS_BROK MONEY default 0,  
 TRADED_DAYS INT default 0,  
 SB_CREDIT MONEY default 0,  
 INTEREST_AMOUNT MONEY default 0,  
 NBFC_INTEREST MONEY default 0,  
 SUMOFDEBIT  MONEY default 0,  
 SUMOFDEBITDAYS INT default 0,  
 AVGNETQUATERLYDEBIT MONEY default 0,    
 CATEGORY VARCHAR(10) default 'C',    
 ROI MONEY default 0  
)  
  
--Fetch Sub brokers  
INSERT INTO #ROI(SUB_BROKER)  
SELECT DISTINCT SUB_BROKER FROM TBL_RMS_COLLECTION (NOLOCK)  
  
  
--Fetch Sub brokers' brokerage  
UPDATE #ROI SET GROSS_BROK=B.GROSSBROK, TRADED_DAYS=B.TRADED_DAYS   
FROM   
 (SELECT SUBBROKCODE,GROSSBROK=SUM(GROSSBROK),TRADED_DAYS=COUNT(1)   
 FROM                        
  (SELECT SUBBROKCODE,SAUDA_DATE,GROSSBROK=SUM(ANGEL_SHARE) FROM MIS.REMISIOR.DBO.COMB_SB  
  WHERE SAUDA_DATE >= GETDATE()-90                         
  GROUP BY SUBBROKCODE,SAUDA_DATE) X   
 GROUP BY SUBBROKCODE) B   
WHERE #ROI.SUB_BROKER=B.SUBBROKCODE  
  
  
--Fetch Sub brokers' Net SB Credit  
UPDATE #ROI SET SB_CREDIT=B.SB_BALANCE FROM      
#ROI INNER JOIN VW_SB_CRWITHVERTICAL B ON  #ROI.SUB_BROKER=B.SB  
  
  
--Fetch Sub brokers' Interest  
UPDATE #ROI SET INTEREST_AMOUNT=B.INTERESTAMOUNT,NBFC_INTEREST=0   
FROM   
 (SELECT SUB_BROKER,INTERESTAMOUNT=SUM(INTERESTAMOUNT*-1)   
 FROM INTRANET.MISC.DBO.SB_PENAL_CREDIT   
 WHERE BALANCEDATE >= GETDATE()-90  GROUP BY SUB_BROKER) B   
WHERE #ROI.SUB_BROKER=B.SUB_BROKER   
  
  
UPDATE #ROI SET SUMOFDEBIT=B.DEBITAMT,SUMOFDEBITDAYS=B.DEBITDAYS   
FROM  
 (SELECT A.SUB_BROKER,SUM(A.DEBITAMT) AS DEBITAMT, COUNT (1) AS DEBITDAYS  FROM   
  
  (SELECT SUB_BROKER,convert(varchar(11), RMS_DATE, 111) AS RMS_DATE,DEBITAMT=SUM(NET)  
  FROM HISTORY.DBO.RMS_DTCLFI_SUMM  (NOLOCK)  
  WHERE RMS_DATE >GETDATE()-90    
  GROUP BY SUB_BROKER,convert(varchar(11), RMS_DATE, 111)) A  
  
 WHERE A.DEBITAMT < 0  
 GROUP BY A.SUB_BROKER) B     
WHERE #ROI.SUB_BROKER=B.SUB_BROKER     
  
--Calculate quartly debit average  
update #ROI set AVGNETQUATERLYDEBIT=B.AVGNET    
FROM  
 (SELECT SUB_BROKER,AVGNET=CASE WHEN SUMOFDEBITDAYS>0 THEN SUMOFDEBIT/SUMOFDEBITDAYS ELSE 0 END from #ROI) B    
  
    
update #ROI set ROI=case when AVGNETQUATERLYDEBIT = 0 then 0 else   
  (((GROSS_BROK*4)+ SB_CREDIT +((INTEREST_AMOUNT+NBFC_INTEREST)*4))*100)/AVGNETQUATERLYDEBIT end  
    
update #ROI set category='HNI' where ROI >= 60 and category='C' and (Gross_Brok/case when Traded_days = 0 then 1 else Traded_days end) >= 3000  
update #ROI set category='A' where ROI >= 40 and category='C' and (Gross_Brok/case when Traded_days = 0 then 1 else Traded_days end)  >= 1000  
update #ROI set category='B' where ROI >= 25 and category='C'  
  
UPDATE #ROI SET category='New' FROM  
(SELECT SBTAG,DAYS from (SELECT SBTAG,DAYS=DATEDIFF(DAY,TAGGENERATEDDATE,GETDATE())  
 FROM MIS.SB_COMP.DBO.SB_BROKER WHERE SBTAG<>'T A G' AND SBTAG<>''  AND SBTAG IS NOT NULL)A
	 WHERE A.DAYS<=90) B WHERE #ROI.SUB_BROKER=B.SBTAG  

truncate table general.dbo.SBCategoryInfo
                    
insert into general.dbo.SBCategoryInfo select *,UpdateOn=getdate() from #ROI                    
                    
insert into history.dbo.SBCategoryInfo select *,UpdateOn=getdate() from #ROI                    

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DB_TblSize
-- --------------------------------------------------
create procedure DB_TblSize
as

set nocount on

-- Table row counts and sizes.
CREATE TABLE #t 
( 
    [name] NVARCHAR(128),
    [rows] CHAR(11),
    reserved VARCHAR(18), 
    data VARCHAR(18), 
    index_size VARCHAR(18),
    unused VARCHAR(18)
) 

INSERT #t EXEC sp_msForEachTable 'EXEC sp_spaceused ''?''' 

SELECT *
FROM   #t

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Debit_SMS_LC1
-- --------------------------------------------------

/*
	From: Shoaib Qureshi [mailto:shoaib@angelbroking.com] 
	Sent: Friday, June 07, 2013 3:23 PM
	To: Manesh Mukherjee
	Cc: Vivek Shukla; Neelay Shah; Sanjay Ghosh; Bhalchandra Ghanekar; SumitS Somani; Bhuvanesh Shukla; Santanu Syam; Bhavin Parekh; Vishal Gohil; Nilam Savinkar
	Subject: RE: Client weekly Ledger SMS
 
	Dear Manesh,
 
	With reference to SEBI Audit actionable ,we have to trigger weekly Ledger confirmation SMS to clients. following is the logic
 
	1.        SMS Content :- LED BAL JANAK1234 on 7/6/12 in ABL  Rs. 10000000.00 (Net Credit with Margins), ACBPL Rs. 10000000.00(Net Credit with margin) .For queries call 33551111. (Highlighted content are variable characters based on client details)
	2.        ABL Balance = BSECM + NSECM+ NSEFO + MCD+ MSX (data will be taken from Net Collection Value from NRMS)
	3.         ACBPL Balance =   NCDEX + MCX (data will be taken from Net Collection Value from NRMS)
	4.        Negative Figure = Debit ; Positive figure = Credit
	5.        SMS to be restricted to debit clients only.
	6.        We send this SMS to clients who have traded in last 15 days and clients above a 5K debit value. Following scenario for SMS will be triggered. 
	a.       If any Segment (i.e. ABL, ACBPL) is having debit more than 5 K – SMS to be send
	b.      If both segment is having combine debit more than 5 K – SMS to be send
	7.        The Client SMS will be triggered on every Monday.
*/ 

Create Procedure Debit_SMS_LC1
as
set nocount on
Begin

	select 
	party_code,convert(varchar(10),rms_date,103) as rms_Date,        
	sum(case when (co_code='BSECM' or co_code='NSECM' or  co_code='NSEFO' or  co_code='NSX' or co_code='MCD' or co_code='BSEFO') then  Brk_Net else 0 end) as ABL_Net,
	sum(case when (co_code='MCX' or co_code='NCDEX' ) then  Brk_Net else 0 end) as ACBPL_Net,
	ABL_lastBillDate=convert(datetime,'Jan  1 1900'), ACBPL_lastBillDate=convert(datetime,'Jan  1 1900'),
	Flag='P' /* P - proceed , L - Legal */
	into #file1
	from Vw_RmsDtclFi_Collection WITH (NOLOCK)
	group by party_code,convert(varchar(10),rms_date,103)        

	update #file1 set Flag='L' where party_Code in (select party_Code from mis.sccs.dbo.sccs_legalBlkClt with (nolock))

	update #file1 set ABL_lastBillDate=b.ABL_lastBillDate from
	(
	select party_Code,max(lastBillDate) as ABL_lastBillDate from rms_dtclfi with (nolock) 
	where (co_code='BSECM' or co_code='NSECM' or  co_code='NSEFO' or  co_code='NSX' or co_code='MCD' or co_code='BSEFO')
	group by party_code
	) b where #file1.party_Code=b.party_code

	update #file1 set ACBPL_lastBillDate=b.ACBPL_lastBillDate from
	(
	select party_Code,max(lastBillDate) as ACBPL_lastBillDate from rms_dtclfi with (nolock) 
	where (co_code='MCX' or co_code='NCDEX')
	group by party_code
	) b where #file1.party_Code=b.party_code

	truncate table DebitClientSms_LC1
	insert into DebitClientSms_LC1
	select getdate() as SMS_Datetime,party_code,rms_Date,ABL_Net,ACBPL_Net,ABL_lastBillDate,ACBPL_lastBillDate,Flag from #file1 where 
	((abl_net+acbpl_net < -5000) or (abl_net< -5000 or acbpl_net < -5000))
	and (abl_lastbilldate >= convert(varchar(11),getdate()-15) or acbpl_lastbilldate >= convert(varchar(11),getdate()-15))

	insert into history.dbo.DebitClientSms_LC1
	select SMS_trigger_Datetime,party_code,ABL_Net,ACBPL_Net,ABL_lastBillDate,ACBPL_lastBillDate,Flag from DebitClientSms_LC1 with (nolock)
END
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DELETE_HOLDING_LD_VIEW_DATA
-- --------------------------------------------------
/*
	SCHEDULE THIS EVERY DAY AT AROUND 8:00 AM
*/
CREATE PROCEDURE DELETE_HOLDING_LD_VIEW_DATA
AS
SET NOCOUNT ON
BEGIN

	DELETE FROM RMS_HOLDING_LD_VIEW_DATA
    WHERE RPQ_DATE < CONVERT(VARCHAR(11),GETDATE()-10)

    DELETE FROM ScripVaR_Master_Hist_LD_VIEW_DATA
    WHERE RPQ_DATE < CONVERT(VARCHAR(11),GETDATE()-10)

    DELETE FROM CLIENT_COLLATERALS_HIST_LD_VIEW_DATA  
    WHERE RPQ_DATE < CONVERT(VARCHAR(11),GETDATE()-10)

    DELETE FROM MILES_STOCKHOLDINGDATA_LD_VIEW_DATA  
    WHERE RPQ_DATE < CONVERT(VARCHAR(11),GETDATE()-10)
    
    DELETE FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA  
    WHERE RPQ_DATE < CONVERT(VARCHAR(11),GETDATE()-10)

END
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FETCH_HOLDING_LD_VIEW_DATA
-- --------------------------------------------------
CREATE PROCEDURE FETCH_HOLDING_LD_VIEW_DATA(@SESSIONID VARCHAR(50),@DATE DATEtime,@PARTY_CODE VARCHAR(20))
AS  
BEGIN  
  
    Declare @RMS_Date dateTIME,  
            @SCRIP_VAR_Date dateTIME,  
            @COLL_Date dateTIME,  
            @MILES_Date dateTIME,
            @ExchReptLD_View datetime
    

    if not exists (
        SELECT * 
        FROM RMS_HOLDING_LD_VIEW_DATA
        WHERE session_id = @SESSIONID and party_code = @PARTY_CODE and rpt_date = @DATE
    )
    begin
    
        SELECT @RMS_Date = MAX(UPD_DATE)
        FROM RMS_HOLDING WITH(NOLOCK)
        WHERE UPD_DATE <= @DATE

        DELETE FROM RMS_HOLDING_LD_VIEW_DATA  
        WHERE SESSION_ID = @SESSIONID

        INSERT INTO RMS_HOLDING_LD_VIEW_DATA
        SELECT *,@SESSIONID,@DATE,GETDATE()  
        FROM RMS_HOLDING WITH(NOLOCK)  
        WHERE UPD_DATE BETWEEN @RMS_Date AND CONVERT(VARCHAR(11),@RMS_Date) + ' 23:59:59' AND PARTY_CODE = @PARTY_CODE  
        
    end

    if not exists (
        SELECT * 
        FROM ScripVaR_Master_Hist_LD_VIEW_DATA
        WHERE session_id = @SESSIONID and rpt_date = @DATE
    )
    begin
    
        SELECT @SCRIP_VAR_Date = MAX(process_date)
        FROM ScripVaR_Master_Hist WITH(NOLOCK)
        WHERE process_date <= @DATE

        DELETE FROM ScripVaR_Master_Hist_LD_VIEW_DATA  
        WHERE SESSION_ID = @SESSIONID

        INSERT INTO ScripVaR_Master_Hist_LD_VIEW_DATA  
        SELECT A.*,@SESSIONID,@DATE,GETDATE()  
        FROM ScripVaR_Master_Hist A   
        RIGHT OUTER JOIN   
        (  
         SELECT ISIN  
         FROM RMS_HOLDING_LD_VIEW_DATA WITH(NOLOCK)  
         --WHERE UPD_DATE BETWEEN @RMS_Date AND CONVERT(VARCHAR(11),@RMS_Date) + ' 23:59:59' AND PARTY_CODE = @PARTY_CODE  
         WHERE RPT_DATE = @DATE AND PARTY_CODE = @PARTY_CODE  
        ) B  
        ON A.ISIN= B.ISIN  
        WHERE PROCESS_DATE BETWEEN @SCRIP_VAR_Date AND CONVERT(VARCHAR(11),@SCRIP_VAR_Date) + ' 23:59:59' 
    end

    if not exists (
        SELECT * 
        FROM CLIENT_COLLATERALS_HIST_LD_VIEW_DATA
        WHERE session_id = @SESSIONID and party_code = @PARTY_CODE and rpt_date = @DATE
    )
    begin
    
        SELECT @COLL_Date = MAX(RMS_DATE)
        FROM CLIENT_COLLATERALS_HIST WITH(NOLOCK)  
        WHERE RMS_DATE <= @DATE 

        DELETE FROM CLIENT_COLLATERALS_HIST_LD_VIEW_DATA  
        WHERE SESSION_ID = @SESSIONID

        INSERT INTO CLIENT_COLLATERALS_HIST_LD_VIEW_DATA  
        SELECT *,@SESSIONID,@DATE,GETDATE()  
        FROM CLIENT_COLLATERALS_HIST WITH(NOLOCK)  
        WHERE RMS_DATE BETWEEN @COLL_Date AND CONVERT(VARCHAR(11),@COLL_Date) + ' 23:59:59' AND PARTY_CODE = @PARTY_CODE
        
    end

    if not exists (
        SELECT * 
        FROM MILES_STOCKHOLDINGDATA_LD_VIEW_DATA
        WHERE session_id = @SESSIONID and partycode = @PARTY_CODE and rpt_date = @DATE
    )
    begin
    
        SELECT @MILES_Date = MAX(RPTDT)
        FROM vw_miles_StockholdingData_HIST WITH(NOLOCK)
        WHERE RPTDT <= @DATE 

        DELETE FROM MILES_STOCKHOLDINGDATA_LD_VIEW_DATA  
        WHERE SESSION_ID = @SESSIONID

        INSERT INTO MILES_STOCKHOLDINGDATA_LD_VIEW_DATA
        SELECT *,@SESSIONID,@DATE,GETDATE()  
        FROM vw_miles_StockholdingData_HIST WITH(NOLOCK)  
        WHERE RPTDT BETWEEN @MILES_Date AND CONVERT(VARCHAR(11),@MILES_Date) + ' 23:59:59' AND PARTYCODE = @PARTY_CODE  
        
    end

    if not exists (
        SELECT * 
        FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA
        WHERE session_id = @SESSIONID and party_code = @PARTY_CODE and rpt_date = @DATE
    )
    begin
    
        SELECT @ExchReptLD_View = MAX(INSERTDATETIME)
        FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST WITH(NOLOCK)
        WHERE INSERTDATETIME <= @DATE + ' 23:59:59'

        DELETE FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA  
        WHERE SESSION_ID = @SESSIONID

        INSERT INTO EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA
        SELECT *,@SESSIONID,@DATE,GETDATE()  
        FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST WITH(NOLOCK)  
        WHERE INSERTDATETIME BETWEEN @ExchReptLD_View AND CONVERT(VARCHAR(11),@ExchReptLD_View) + ' 23:59:59' AND PARTY_CODE = @PARTY_CODE  
        
    end
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_Client_DrNODs
-- --------------------------------------------------
create procedure Get_Client_DrNODs
as

select RDate=max(convert(datetime,convert(varchar(10),a.rms_Date,101)))+1,
a.party_Code 
into #file1
from history.dbo.RMS_DtclFi_summ a (nolock),
(select RMS_date=max(RMS_date),party_Code from history.dbo.RMS_DtclFi_summ  (nolock) group by convert(varchar(10),rms_Date,101),party_code) b
where a.party_Code=b.party_code and a.rms_date=b.rms_Date
and exists (select party_Code from general.dbo.RMS_DtclFi_summ (nolock) where net < 0)
and net >= 0
group by a.party_Code


select RDate=min(convert(datetime,convert(varchar(10),a.rms_Date,101)))+1,
a.party_Code 
into #file2
from history.dbo.RMS_DtclFi_summ a (nolock),
(select RMS_date=max(RMS_date),party_Code from history.dbo.RMS_DtclFi_summ  (nolock) group by convert(varchar(10),rms_Date,101),party_code) b
where a.party_Code=b.party_code and a.rms_date=b.rms_Date
and exists (select party_Code from general.dbo.RMS_DtclFi_summ (nolock) where net < 0)
and net < 0
group by a.party_Code


insert into #file1
select a.* from #file2 a left outer join #file1 b on a.party_code=b.party_Code where b.party_code is null

truncate table Client_DrNODs 
insert into Client_DrNODs 
select party_Code,DrNoOfDays=case when datediff(day,Rdate,getdate()) < 0 then 0 else datediff(day,Rdate,getdate()) end,Upd_date=getdate() 
from #file1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_exchangemarginreporting_ld_reporting_ledger_details
-- --------------------------------------------------
/**************************************************************************************************************        
    
CREATED BY :: Mittal Sompura      
    
CREATED DATE :: 07 Nov 2013        
    
PURPOSE :: get data of Reporting Ledger for LD      
    
exec Get_exchangemarginreporting_ld_reporting_ledger_details 'rvhps545lhebpumaubo50aa4','11/06/2013','PTA5309','','E43244','BROKER','CSO'      
    
******************************************************************************************************************/  
CREATE PROC Get_exchangemarginreporting_ld_reporting_ledger_details (@SESSIONID   VARCHAR(50),  
                                                                     @DATE        DATETIME,  
                                                                     @PARTY_CODE  VARCHAR(20),  
                                                                     @report_Type VARCHAR(50),  
                                                                     @USERID      AS VARCHAR(15),  
                                                                     @ACCESS_TO   AS VARCHAR(10),  
                                                                     @ACCESS_CODE AS VARCHAR(10))  
AS  
  BEGIN  
      SELECT CONVERT(VARCHAR, ProcessDateTime,103) AS [ProcessDate],  
             A.Zone,  
             A.Region,  
             A.Branch,  
             A.SB,  
             A.Party_Code,  
             A.Cli_Type,  
             NSEFO_Ledger,  
             NSEFO_UnReco,  
             NSEFO_Deposit,  
             NSEFO_CashColl,  
             NSEFO_CashNet,  
             NSEFO_NonCashColl,  
             NSEFO_NetAvail,  
             NSECM_Ledger,  
             NSECM_UnReco,  
             NSECM_Deposit,  
             NSECM_CashNet,  
             NSECM_PoolHold,  
             NSECM_NetAvail,  
             BSECM_Ledger,  
             BSECM_UnReco,  
             BSECM_Deposit,  
             BSECM_CashNet,  
             BSECM_PoolHold,  
             BSECM_NetAvail,  
             NSX_Ledger,  
             NSX_UnReco,  
             NSX_Deposit,  
             NSX_CashColl,  
             NSX_CashNet,  
             NSX_NonCashColl,  
             NSX_NetAvail,  
             MCD_Ledger,  
             MCD_UnReco,  
             MCD_Deposit,  
             MCD_CashColl,  
             MCD_CashNet,  
             MCD_NonCashColl,  
             MCD_NetAvail,  
             T2DAY_COLL_VAL  
      --INSERTDATETIME,    
      --RPT_DATE,    
      --RPQ_DATE    
      FROM   EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA A WITH(NOLOCK)  
             LEFT OUTER JOIN general.dbo.CLIENT_DETAILS B WITH(NOLOCK)  
               ON A.PARTY_CODE = B.PARTY_CODE  
      WHERE  SESSION_ID = @SESSIONID  
  
      SELECT ''  
  
      SELECT 'LD VIEW DATA DETAILS Date -' + CONVERT(VARCHAR, @DATE, 103) + ' :: Client Code -' + @PARTY_CODE + ':: Report Type - ' + @report_Type  
  
      SELECT Tdate =''  
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Get_exchangemarginreporting_ld_T2DayCollDetails
-- --------------------------------------------------
/**************************************************************************************************************        
CREATED BY :: Prashant Patel
CREATED DATE :: 04 Dec 2013        
PURPOSE :: T2Day Collateral Details
exec Get_exchangemarginreporting_ld_T2DayCollDetails 'rvhps545lhebpumaubo50aa4','11/06/2013','PTA5309','','E43244','BROKER','CSO'      
******************************************************************************************************************/  
CREATE PROC Get_exchangemarginreporting_ld_T2DayCollDetails (@SESSIONID   VARCHAR(50),  
                                                            @DATE        DATETIME,  
                                                            @PARTY_CODE  VARCHAR(20),  
                                                            @report_Type VARCHAR(50),  
                                                            @USERID      AS VARCHAR(15),  
                                                            @ACCESS_TO   AS VARCHAR(10),  
                                                            @ACCESS_CODE AS VARCHAR(10))  
AS  
  BEGIN
  
      IF @ACCESS_TO = 'BROKER'
      BEGIN
          SELECT PARTY_CODE,ISIN,QTY,HAIRCUT,CLSRATE,VALUE
          FROM   EXCHANGEMARGINREPORTING_COLL_T2DAY_DET_LD_hist A WITH(NOLOCK)  
          WHERE  HIST_DATE = convert(datetime,@DATE,103)
  
          SELECT ''  
          SELECT 'T2 DAY COLLATERAL DETAILS Date -' + CONVERT(VARCHAR, @DATE, 103) + ' :: Client Code -' + @PARTY_CODE + ':: Report Type - ' + @report_Type  
          SELECT Tdate =''  
      END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA_DETAILS
-- --------------------------------------------------
/**************************************************************************************************************        
  
CREATED BY :: Mittal Sompura      
  
CREATED DATE :: 07 Nov 2013        
  
PURPOSE :: get data of rms_holding_annex7_ld_view_data_details.      
  
******************************************************************************************************************/
CREATE PROC Get_vw_rms_holding_annex7_ld_view_data_details ( @SESSIONID   VARCHAR(50),
                                                            @DATE        DATETIME,
                                                            @PARTY_CODE  VARCHAR(20),
                                                            @report_Type VARCHAR(50),
                                                            @USERID      AS VARCHAR(15),
                                                            @ACCESS_TO   AS VARCHAR(10),
                                                            @ACCESS_CODE AS VARCHAR(10))
AS
  BEGIN
      SELECT PARTY_CODE,
             ISIN,
             EXCHANGE,
             SETT_TYPE,
             T2TSCRIP,
             QTY,
             HAIRCUT,
             TOTAL_WITHHC,
             TOTAL,
             SOURCE
      FROM   VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA_DETAILS (NOLOCK)
      WHERE  SESSION_ID = @SESSIONID

      SELECT ''

      SELECT 'LD VIEW DATA DETAILS Date -' + CONVERT(VARCHAR(11), @DATE) + ' :: Client Code -' + @PARTY_CODE + ':: Report Type - ' + @report_Type

      SELECT Tdate =''
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetSBCredit
-- --------------------------------------------------
CREATE PROCEDURE GetSBCredit
AS
BEGIN
      SELECT a.rep_Date
            ,a.Sub_Broker AS Short_name
            ,a.SB_ledger * - 1 AS SB_ledger
            ,isnull(purerisk, 0) * - 1 AS PureRisk
      FROM (
            SELECT convert(DATETIME, convert(VARCHAR(11), RMS_Date)) AS Rep_date
                  ,Sub_Broker
                  ,SUM(SB_Ledger) AS SB_Ledger
            FROM rms_dtsbfi WITH (NOLOCK)
            WHERE rms_Date >= GETDATE() - 35
            GROUP BY RMS_Date
                  ,Sub_Broker
            ) a
      LEFT OUTER MERGE JOIN (
            SELECT rms_Date
                  ,sub_BRoker
                  ,MAX(Tot_ProjRisk) AS PureRisk
            FROM tbl_RMS_collection_SB_hist WITH (NOLOCK)
            WHERE rms_Date >= GETDATE() - 35
            GROUP BY rms_Date
                  ,sub_BRoker
            ) b
            ON a.rep_Date = b.rms_Date
                  AND a.Sub_Broker = b.Sub_Broker
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GROWTH_OF_DATABASE
-- --------------------------------------------------

create proc GROWTH_OF_DATABASE
AS 
BEGIN 

--PART 1
If exists (Select name from sys.objects where name = 'DBGrowthRate' and Type = 'U')
  Drop Table dbo.DBGrowthRate

Create Table dbo.DBGrowthRate (DBGrowthID int identity(1,1), DBName varchar(100), DBID int,
NumPages int, OrigSize decimal(10,2), CurSize decimal(10,2), GrowthAmt varchar(100), 
MetricDate datetime)

Select sd.name as DBName, mf.name as FileName, mf.database_id, file_id, size
into #TempDBSize
from sys.databases sd
join sys.master_files mf
on sd.database_ID = mf.database_ID
Order by mf.database_id, sd.name

Insert into dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
(Select tds.DBName, tds.database_ID, Sum(tds.Size) as NumPages, 
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as OrigSize,
Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as CurSize,
'0.00 MB' as GrowthAmt, GetDate() as MetricDate
from #TempDBSize tds
where tds.database_ID not in (Select Distinct DBID from DBGrowthRate 
									where DBName = tds.database_ID)
Group by tds.database_ID, tds.DBName)

Drop table #TempDBSize

Select *
from DBGrowthRate
--Above creates initial table and checks initial data

--PART 2
--Below is the code run weekly to check the growth.
Select sd.name as DBName, mf.name as FileName, mf.database_id, file_id, size
into #TempDBSize2
from sys.databases sd
join sys.master_files mf
on sd.database_ID = mf.database_ID
Order by mf.database_id, sd.name

If Exists (Select Distinct DBName from #TempDBSize2 
				where DBName in (Select Distinct DBName from DBGrowthRate))
	and Convert(varchar(10),GetDate(),101) > (Select Distinct Convert(varchar(10),Max(MetricDate),101) as MetricDate 
																				from DBGrowthRate)
  Begin
		Insert into dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
		(Select tds.DBName, tds.database_ID, Sum(tds.Size) as NumPages, 
		dgr.CurSize as OrigSize,
		Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as CurSize,
		Convert(varchar(100),(Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) 
					- dgr.CurSize)) + ' MB' as GrowthAmt, GetDate() as MetricDate
		from #TempDBSize2 tds
		join DBGrowthRate dgr
		on tds.database_ID = dgr.DBID
		Where DBGrowthID = (Select Distinct Max(DBGrowthID) from DBGrowthRate
														where DBID = dgr.DBID)
		Group by tds.database_ID, tds.DBName, dgr.CurSize)
  End
 Else
   IF Not Exists (Select Distinct DBName from #TempDBSize2 
				where DBName in (Select Distinct DBName from DBGrowthRate))
		Begin
			Insert into dbo.DBGrowthRate (DBName, DBID, NumPages, OrigSize, CurSize, GrowthAmt, MetricDate)
			(Select tds.DBName, tds.database_ID, Sum(tds.Size) as NumPages, 
			Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as OrigSize,
			Convert(decimal(10,2),(((Sum(Convert(decimal(10,2),tds.Size)) * 8000)/1024)/1024)) as CurSize,
			'0.00 MB' as GrowthAmt, GetDate() as MetricDate
			from #TempDBSize2 tds
			where tds.database_ID not in (Select Distinct DBID from DBGrowthRate 
															where DBName = tds.database_ID)
			Group by tds.database_ID, tds.DBName)
		End

--Select *
--from DBGrowthRate
----Verifies values were entered

Drop table #TempDBSize2

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.HOLd_HISTORY
-- --------------------------------------------------
CREATE PROC HOLd_HISTORY
(@ISIN VARCHAR(25),
@TDATE varchar(11))

AS
 
/* 
DECLARE @ISIN VARCHAR(25)='INE597L01014',
@TDATE varchar(11)='Dec 08 2017'
*/

SELECT PARTY_CODE,ISIN,SCRIPNAME,SUM(DP_HOLDING) DP_HOLDING,SUM(POOL_HOLDING) POOL_HOLDING INTO #TEMP FROM (

select PARTY_CODE,ISIN,SCRIPNAME,SUM(CASE WHEN SOURCE ='DP' THEN TOTAL ELSE 0 END ) AS DP_HOLDING, 
SUM(CASE WHEN SOURCE ='H' THEN Qty ELSE 0 END)  AS POOL_HOLDING
from rms_holding with (nolock) where   
upd_date >=@TDATE and upd_date <=@TDATE+' 23:59:59' AND ISIN  =@ISIN
and ISNULL(source,'') NOT IN ('SI','D')
GROUP BY PARTY_CODE,ISIN,SCRIPNAME 
 UNION ALL

select PARTY_CODE,a.ISIN,b.SCRIPNAME,0 AS DP_HOLDING ,SUM(QTY) AS POOL_HOLDING
from CLIENT_COLLATERALS_HIST a with (nolock)
left join
general.dbo.scrip_master b with(nolock) on a.isin=b.isin
where rms_date >=@TDATE and rms_date <=@TDATE+' 23:59:59' and a.isin=@ISIN
GROUP BY PARTY_CODE,a.ISIN ,b.SCRIPNAME
 )A
 GROUP BY PARTY_CODE,a.ISIN,SCRIPNAME

 SELECT * FROM #TEMP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MSS_DAYSCALCULATION
-- --------------------------------------------------
CREATE PROCEDURE MSS_DAYSCALCULATION
AS
set nOCOUNT ON
  
  select 
  top 7 
  ROW_NUMBER() OVER ( ORDER BY convert(date,process_date) ) AS [SrNo] ,
  convert(date,process_date) as process_Date 
  INTO #TOP7DT
  from tbl_shortage_10days_hist_region 
  group by convert(date,process_date)
  
  select bACKOFFICECODE INTO #CLICODE 
  from tbl_shortage_10days_hist_region 
  WHERE convert(date,process_date) IN
  (select process_Date from #TOP7DT)
  group by bACKOFFICECODE 
  
  select 
  B.SRNO,b.backofficecode,a.NosOfDays,b.process_Date into #CliDateCheck from
  (select * from tbl_shortage_10days_hist_region )a right outer join 
  (SELECT * FROM #CLICODE A , #TOP7DT B ) b
  on convert(date,a.process_date)=b.process_date and a.backofficecode=b.backofficecode
  order by a.backofficecode


	UPDATE tbl_shortage_10days_hist_region 
	SET NOSOFDAYS = tbl_shortage_10days_hist_region.NOSOFDAYS-P.DEDUCTdAYS FROM
	(
	SELECT *,DEDUCTdAYS=(X.NOSOFDAYS-1) FROM 
	(
	select A.bACKOFFICECODE,A.PROCESS_DATE,A.NOSOFDAYS FROM
	(select * from #CliDateCheck where nosofdays is not null) a join
	(select * from #CliDateCheck where  /*backofficecode in ('K40815','a45786','p67787') and  */NosOfdays is null) b
	on a.backofficecode=b.backofficecode and a.process_date > b.process_date AND A.SRNO=B.SRNO+1
	) X WHERE NOSOFDAYS <> 1 
	) P WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=P.BACKOFFICECODE 
	AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)>=P.PROCESS_DATE

set nOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NBFC_MarginShortageProcessExe
-- --------------------------------------------------
CREATE Procedure [dbo].[NBFC_MarginShortageProcessExe]          
as          
          
set nocount on          
          
DECLARE @XACT_ABORT VARCHAR(3) = 'OFF',@XactChg varchar(3) ='No';          
IF ( (16384 & @@OPTIONS) = 16384 ) SET @XACT_ABORT = 'ON';          
if @XACT_ABORT='OFF'          
Begin          
 SET XACT_ABORT ON          
 set @XactChg='Yes'          
End          
          
Begin Try          
	exec upd_10DaysMarginShrtExcess_finalprocess

End Try          
Begin Catch          
	insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)  
	select GETDATE(),'upd_10DaysMarginShrtExcess_finalprocess',ERROR_LINE(),ERROR_MESSAGE()  

	DECLARE @ErrorMessage NVARCHAR(4000);  
	SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());  
	RAISERROR (@ErrorMessage , 16, 1);  
end catch; 
--exec [196.1.115.132].MIS.dbo.Usp_gen_sqof_suspenclient_new

if @XactChg='Yes'          
Begin          
 SET XACT_ABORT OFF          
end          
          
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NBFCMargShortSqOffPro_JobExecutor
-- --------------------------------------------------
  
CREATE Procedure [dbo].[NBFCMargShortSqOffPro_JobExecutor]          
as          
set nocount on          


/*Delete Cusa sq off codes start*/
select distinct party_code  into #cusa 
from INTRANET.CMS.dbo.Cusa_po WITH(NOLOCK) 
where  squareoffqty>0 and Squareoffdate is not NULL

select distinct T1.party_code into #deleteCusacodes from MIS.DBO.ASB7_Clidetails_crdet_Process2 T1 inner join #cusa T2 on T1.party_code=T2.party_code
where rms_date=(select max(rms_date) from MIS.DBO.ASB7_Clidetails_crdet_Process2) and T_day<>0 and Sq_Amt<>0

delete from MIS.DBO.ASB7_Clidetails_crdet_Process2 
where party_code in (select party_code from #deleteCusacodes) and rms_date=(select max(rms_date) from MIS.DBO.ASB7_Clidetails_crdet_Process2) 

/*Delete Cusa sq off codes end */ 
   
Declare @Status varchar(3)=null  
SELECT @Status=FORMAT(getdate(),'tt')    
if(@status='PM') 
begin 
print @status  
return 
end          
else
begin  
print 'ABHA'
      
DECLARE @JobRunningStatus INT,@JOB_ID uniqueidentifier          
 SET @JobRunningStatus = 0          
          
 SELECT @JOB_ID = job_id           
 FROM msdb.dbo.sysjobs           
 WHERE name = 'NBFC_MarginShortage_Sqoff'          
     
 create table #jobstatus          
 (          
  [Job ID] uniqueidentifier,           
  [last run date] int,          
  [last run time] int,          
  [next run date] int,          
  [next run time] int,          
  [next run schedule id] int,          
  [request to run] int,          
  [request source] int,          
  [request source id] varchar(100),          
  [running] int,          
  [current step] int,          
  [current retry attempt] int,          
  [state] int          
 )          
          
 INSERT INTO #jobstatus          
 EXEC master.dbo.xp_sqlagent_enum_jobs 1, sa,@JOB_ID          
          
 IF (SELECT COUNT(*) FROM #jobstatus) > 0          
  SELECT TOP 1 @JobRunningStatus = RUNNING FROM #jobstatus          
 ELSE          
  SELECT @JobRunningStatus = -1          
    
          
 IF @JobRunningStatus = 0          
 BEGIN          
  EXEC msdb.dbo.sp_start_job 'NBFC_MarginShortage_Sqoff'          
  select 'Process Triggered.' as CMSStat    
 END          
 ELSE          
 BEGIN          
  select 'Job Process in Progress...Cannot Start.Try After Sometime' as CMSStat         
 END
END 
           
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BadDebts
-- --------------------------------------------------

CREATE procedure NRMS_BadDebts(@tdate as varchar(11))      
as      
      
set nocount on      
      
select top 0 segment,cltcode,party_code,balance into #file from general.dbo.BadDebts with (nolock)      
/*  
declare @tdate as varchar(11)      
set @tdate='Sep 25 2010'      
*/  
insert into #file      
select Segment='BSECM',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.bsecm_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
insert into #file      
select Segment='BSECM',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.bsecm_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='BSECM')      
group by cltcode      
      
------------------------- NSECM      
insert into #file      
select Segment='NSECM',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsecm_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
      
insert into #file      
select Segment='NSECM',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsecm_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='NSECM')      
group by cltcode      
      
      
------------------------- NSEFO      
      
insert into #file      
select Segment='NSEFO',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsefo_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
insert into #file      
select Segment='NSEFO',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsefo_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='NSEFO')      
group by cltcode      
      
      
------------------------- NSX      
      
insert into #file      
select Segment='NSX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsx_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
insert into #file      
select Segment='NSX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.nsx_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='NSX')      
group by cltcode      
      
      
---------------------------- MCD      
      
insert into #file      
select Segment='MCD',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.mcd_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
      
insert into #file      
select Segment='MCD',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.mcd_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='MCD')      
group by cltcode      
      
------------------------------------ NCDEX      
      
insert into #file      
select Segment='NCDEX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.ncdEx_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
insert into #file      
select Segment='NCDEX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.ncdEx_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='NCDEX')      
group by cltcode      
      
-------------------------------------- MCX      
      
insert into #file      
select Segment='MCX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.MCX_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
(cltcode >='17A0001' and cltcode <='17ZZZ999')       
OR (cltcode >='16A0001' and cltcode <='16ZZZ999')       
OR (cltcode >='7A0001' and cltcode <='7ZZZ999')       
group by cltcode      
having sum(Case when drcr='D' then -vamt else vamt end) <> 0      
      
insert into #file      
select Segment='MCX',cltcode,party_Code=      
(case when       
(cltcode >='17A0001' and cltcode <='17ZZZ999') OR (cltcode >='16A0001' and cltcode <='16ZZZ999') then substring(cltcode,3,10)      
when (cltcode >='7A0001' and cltcode <='7ZZZ999') then substring(cltcode,2,10) else cltcode       
end),      
Balance=sum(Case when drcr='D' then -vamt else vamt end)      
from general.dbo.MCX_ledger with (nolock)       
where vdt <=@tdate+' 23:59:59' and      
cltcode in (select party_Code from #file where segment='MCX')      
group by cltcode      
      
/*      
truncate table BadDebts       
insert into BadDebts select *,getdate() from #file      
      
delete from #file where party_Code not in      
(select distinct party_Code from #file where cltcode <> party_Code)      
      
*/      
  
truncate table RMS_BadDebts 
insert into RMS_BadDebts   
select @tdate as [Date],region,branch_cd,Sub_Broker,  
a.party_code,      
CL_TOTAL=sum(case when cltcode=a.party_code then balance*-1 else 0 end),      
BSECM=sum(case when segment='BSECM' and cltcode=a.party_code then balance*-1 else 0 end),      
NSECM=sum(case when segment='NSECM' and cltcode=a.party_code then balance*-1 else 0 end),      
NSEFO=sum(case when segment='NSEFO' and cltcode=a.party_code then balance*-1 else 0 end),      
NSX=sum(case when segment='NSX' and cltcode=a.party_code then balance*-1 else 0 end),      
MCD=sum(case when segment='MCD' and cltcode=a.party_code then balance*-1 else 0 end),      
NCDEX=sum(case when segment='NCDEX' and cltcode=a.party_code then balance*-1 else 0 end),      
MCX=sum(case when segment='MCX' and cltcode=a.party_code then balance*-1 else 0 end),      
BD_TOTAL=sum(case when cltcode<> a.party_code then balance*-1 else 0 end),      
BD_BSECM=sum(case when segment='BSECM' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_NSECM=sum(case when segment='NSECM' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_NSEFO=sum(case when segment='NSEFO' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_NSX=sum(case when segment='NSX' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_MCD=sum(case when segment='MCD' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_NCDEX=sum(case when segment='NCDEX' and cltcode <> a.party_code then balance*-1 else 0 end),      
BD_MCX=sum(case when segment='MCX' and cltcode <> a.party_code then balance*-1 else 0 end),      
NET=sum(case when cltcode=a.party_code then balance*-1 else 0 end)+sum(case when cltcode<> a.party_code then balance*-1 else 0 end)      
from #file a, general.dbo.client_details b with (nolock) where a.party_Code=b.party_code      
group by region,branch_cd,Sub_Broker,a.party_code      
      
set nocount off

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
-- PROCEDURE dbo.RMS_BadDebts_Calc
-- --------------------------------------------------
 
CREATE Procedure RMS_BadDebts_Calc(@tdate as varchar(11))          
as          
          
/*          
declare @tdate as varchar(11)        
set @tdate ='Oct 25 2010'        
*/        
        
declare @acdate as varchar(11),@Day15 as varchar(11)          
set @day15 = convert(datetime,@tdate)-15       
select @acdate=sdtcur from general.dbo.parameter where sdtcur <= @day15 and ldtcur >=@day15    
       
/*  
--- used only for client's Pure/Proj Risk ---  
          
select rms_Date,party_Code,projRisk,PureRisk            
into #risk1dayFY from  RMS_DtclFi_summ with (nolock)           
where PureRisk < 0 and rms_Date >=@acdate and rms_Date <=@acdate+' 23:59:59'           
          
select rms_Date,party_Code,projRisk,PureRisk            
into #risk15dayFY          
from RMS_DtclFi_summ  with (nolock)           
where PureRisk < 0 and rms_Date >=@day15 and rms_Date <=@day15+' 23:59:59'           
          
select rms_Date,party_Code,projRisk,PureRisk            
into #risk0dayFY from RMS_DtclFi_summ with (nolock)           
where PureRisk < 0 and rms_Date >=@tdate and rms_Date <=@tdate+' 23:59:59'           
*/          
  
/* used for client's Pure/Proj Risk after adjustment with SB Credit */  
          
select pdate as rms_Date,party_Code,(proj_risk+SB_CrAdjwithProjRisk) as projRisk,  
(pure_risk+SB_CrAdjwithPureRisk) as PureRisk            
into #risk1dayFY from  tbl_RMS_Collection_Cli_Hist with (nolock)           
where (pure_risk+SB_CrAdjwithProjRisk) < 0 and pdate >=@acdate and pdate <=@acdate+' 23:59:59'           
          
select pdate as rms_Date,party_Code,(proj_risk+SB_CrAdjwithProjRisk) as projRisk,  
(pure_risk+SB_CrAdjwithPureRisk) as PureRisk    
into #risk15dayFY          
from tbl_RMS_Collection_Cli_Hist  with (nolock)           
where (pure_risk+SB_CrAdjwithProjRisk) < 0 and pdate >=@day15 and pdate <=@day15+' 23:59:59'           
          
select pdate as rms_Date,party_Code,(proj_risk+SB_CrAdjwithProjRisk) as projRisk,  
(pure_risk+SB_CrAdjwithPureRisk) as PureRisk           
into #risk0dayFY from tbl_RMS_Collection_Cli_Hist with (nolock)           
where (pure_risk+SB_CrAdjwithProjRisk) < 0 and pdate >=@tdate and pdate <=@tdate+' 23:59:59'           
          
/*          
select a.party_Code,          
a.rms_Date as Day0Date ,a.pureRisk as Day0Risk,          
b.rms_Date as Day15Date,b.pureRisk as Day15Risk,          
c.rms_Date as DayFYDate,c.pureRisk as DayFYRisk,          
PureRisk=           
(case when (          
case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end) > c.PureRisk           
          
then (case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end)           
else  c.PureRisk           
end)          
from #risk0dayFY  a, #risk15dayFY b, #risk1dayFY c where a.party_Code=b.party_Code and b.party_Code=c.party_code          
and  a.purerisk <> c.purerisk and a.purerisk <> b.purerisk           
*/          
          
exec NRMS_BadDebts @tdate          
/*          
select x.*,BD_Total=isnull(y.BD_Total,0),BadDebts=x.Risk-isnull(y.BD_Total,0) from          
(          
select a.party_Code,          
a.rms_Date as Day0Date ,a.pureRisk as Day0Risk,          
b.rms_Date as Day15Date,b.pureRisk as Day15Risk,          
c.rms_Date as DayFYDate,c.pureRisk as DayFYRisk,          
c.PureRisk-(case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end) as Risk          
from #risk0dayFY  a, #risk15dayFY b, #risk1dayFY c where a.party_Code=b.party_Code and b.party_Code=c.party_code          
) x left outer join rms_baddebts y on x.party_code=y.party_Code          
where x.Risk-isnull(y.BD_Total,0)  > 0          
*/    
  
/*  
select x.*,BadDebts_Prov=isnull(y.BD_Total,0),IncreRisk_Net=x.IncreRisk_Gross+isnull(y.BD_Total,0)     
from      
(      
select a.party_Code,      
a.rms_Date as Day0Date ,a.pureRisk as Day0Risk,      
b.rms_Date as Day15Date,b.pureRisk as Day15Risk,      
c.rms_Date as DayFYDate,c.pureRisk as DayFYRisk,      
c.PureRisk-(case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end) as IncreRisk_Gross      
from #risk0dayFY  a, #risk15dayFY b, #risk1dayFY c where a.party_Code=b.party_Code and b.party_Code=c.party_code      
) x left outer join rms_baddebts y on x.party_code=y.party_Code      
where IncreRisk_Gross > 0    
*/
 

select p.*,BadDebts_Prov=isnull(q.BD_Total,0),IncreRisk_Net=p.IncreRisk_Gross+isnull(q.BD_Total,0) from
(
select x.*,y.rms_Date as DayFYDate,y.pureRisk as DayFYRisk,
isnull(y.PureRisk,0)-x.CurrRisk_Gross as IncreRisk_Gross
from
(
select a.party_Code,      
a.rms_Date as Day0Date ,a.pureRisk as Day0Risk,      
b.rms_Date as Day15Date,b.pureRisk as Day15Risk,      
(case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end) as CurrRisk_Gross      
from #risk0dayFY  a, #risk15dayFY b where a.party_Code=b.party_Code     
and (case when a.PureRisk < b.PureRisk then b.PureRisk else a.PureRisk end) < 0
) x left outer join #risk1dayFY y on x.party_Code=y.party_code
where isnull(y.PureRisk,0)-x.CurrRisk_Gross  < 0
) p left outer join rms_baddebts q on p.party_code=q.party_Code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DEBIT_BRANCH
-- --------------------------------------------------
--RPT_HIST_DEBIT_BRANCH 'KOLPA','BRANCH','Sanjay','Broker','CSO'                  
CREATE procedure RPT_HIST_DEBIT_BRANCH                
(                  
 @EntityCode AS VARCHAR(25),                  
 @EntityType AS VARCHAR(10),                  
 @userid AS VARCHAR(15),                  
 @access_to AS VARCHAR(10),                  
 @access_code AS VARCHAR(25)                  
)                  
AS                                    
BEGIN                                    
 SET NOCOUNT ON                                    
 declare @Main AS NVARCHAR(2000)                  
                                                             
 SET @Main = ' '                                                            
                   
                  
--Region                  
SET @Main =  @Main +' select '                
                
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                  
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Gross Collection], '        
SET @Main =  @Main +' ''<span align=right style="Color:Red">''+convert(varchar(1000),convert(decimal(15,2),ABS(MAX(Gross_Collection_perc))))+''</span>'' as [Gross Collection%], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure]  '                
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST '                
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and Report_Type=''D'' and RMS_DATE>getdate()-90'          
SET @Main =  @Main +' group by RMS_DATE '          
SET @Main =  @Main +' order by RMS_DATE Desc'                
                
                  
                  
SET @Main =  @Main +' SELECT '' '' '                  
set @Main = @Main +' select title=''DEBIT BRANCH REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                     
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                            
 EXECUTE sp_executesql @Main                                                                  
                                
 SET NOCOUNT OFF                                                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DEBIT_CLIENT
-- --------------------------------------------------
--RPT_HIST_DEBIT_CLIENT 'R55770','client','Sanjay','Broker','CSO'              
CREATE procedure RPT_HIST_DEBIT_CLIENT            
(              
 @EntityCode AS VARCHAR(25),              
 @EntityType AS VARCHAR(10),              
 @userid AS VARCHAR(15),              
 @access_to AS VARCHAR(10),              
 @access_code AS VARCHAR(25)              
)              
AS                                
BEGIN                                
 SET NOCOUNT ON                                
 declare @Main AS NVARCHAR(2000)              
                                                         
 SET @Main = ' '                                                        
               
              
--Region              
SET @Main =  @Main +' select '              
            
            
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net_Debit)/100000) as [Net Debit], '            
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '             
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Collection],convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Gross Collection], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_BlueChip)/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Poor)/100000) as [Poor],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Junk], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total Holding], '    
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_TotalHC)/100000) as [Total Holding with HC], '    
SET @Main =  @Main +' convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [Proj Risk (SB Proj. Risk)] '            
          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock) WHERE Client like '''+@EntityCode+''' and Report_type=''D'' and RMS_DATE>getdate()-90 group by RMS_DATE order by RMS_DATE desc '            
            
SET @Main =  @Main +' SELECT '' '' '              
set @Main = @Main +' select title=''DEBIT CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                 
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                        
 EXECUTE sp_executesql @Main                                                              
                            
 SET NOCOUNT OFF                                                          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DEBIT_REGION
-- --------------------------------------------------
--RPT_HIST_DEBIT_REGION '%','Region','Sanjay','Broker','CSO'                  
CREATE procedure RPT_HIST_DEBIT_REGION                
(                  
 @EntityCode AS VARCHAR(25),                  
 @EntityType AS VARCHAR(10),                  
 @userid AS VARCHAR(15),                  
 @access_to AS VARCHAR(10),                  
 @access_code AS VARCHAR(25)                  
)                  
AS                                    
BEGIN                                    
 SET NOCOUNT ON                                    
 declare @Main AS NVARCHAR(2000)                  
                                                             
 SET @Main = ' '                                                            
                   
                  
--Region                  
SET @Main =  @Main +' select '                
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                  
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Gross Collection], '              
SET @Main =  @Main +' [Gross Collection%]=convert(varchar(500),''<span align=right style="Color:Red">''+convert(varchar,convert(decimal(15,2),ABS(MAX(Gross_Collection_perc))))+''</span>'') , '                  
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure]  '                
SET @Main =  @Main +' from TBL_RMS_COLLECTION_REGION_HIST '                
SET @Main =  @Main +' where REGION like '''+@EntityCode+''' and Report_Type=''D'' and RMS_DATE>getdate()-90'                
SET @Main =  @Main +' group by RMS_DATE '                
SET @Main =  @Main +' order by RMS_DATE Desc'          
                
                  
                  
SET @Main =  @Main +' SELECT '' '' '                  
set @Main = @Main +' select title=''DEBIT REGION REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                     
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                            
print @Main       
EXECUTE sp_executesql @Main      
                                
 SET NOCOUNT OFF                                                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DEBIT_SB
-- --------------------------------------------------
--RPT_HIST_DEBIT_SB '%','SB','Sanjay','Broker','CSO'                
CREATE procedure RPT_HIST_DEBIT_SB              
(                
 @EntityCode AS VARCHAR(25),                
 @EntityType AS VARCHAR(10),                
 @userid AS VARCHAR(15),                
 @access_to AS VARCHAR(10),                
 @access_code AS VARCHAR(25)                
)                
AS                                  
BEGIN                                  
 SET NOCOUNT ON                                  
 declare @Main AS NVARCHAR(2000)                
                                                           
 SET @Main = ' '                                                          
                 
                
SET @Main =  @Main +' select '                
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '              
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '              
    
SET @Main =  @Main +' convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Gross Collection], '      
SET @Main =  @Main +' ''<span align=right style="Color:Red">''+convert(varchar(1000),convert(decimal(15,2),ABS(MAX(Gross_Collection_perc))))+''</span>'' as [Gross Collection%], '                
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_BlueChip)/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good],'              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Poor)/100000) as [Poor],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Junk],'              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Holding)/100000) as [Total  Holding],'    
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure] '    
    
SET @Main =  @Main +' from tbl_RMS_collection_SB_Hist '              
SET @Main =  @Main +' where SUB_BROKER LIKE '''+@EntityCode+''' and Report_Type=''D'' and RMS_DATE>getdate()-90'              
SET @Main =  @Main +' group by RMS_DATE '              
SET @Main =  @Main +' order by RMS_DATE Desc'              
              
              
              
SET @Main =  @Main +' SELECT '' '' '                
set @Main = @Main +' select title=''DEBIT SB REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                   
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                          
 EXECUTE sp_executesql @Main                                                                
                              
 SET NOCOUNT OFF                                                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_BRANCH
-- --------------------------------------------------
--RPT_HIST_DRCR_BRANCH '%','BRANCH','Sanjay','Broker','CSO'                      
CREATE procedure [dbo].[RPT_HIST_DRCR_BRANCH]                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST '                      
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                      
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE Desc'                      
                      
IF @access_to = 'BRMAST'                      
 BEGIN                                   
  SET @Main =  @Main + ' and a.BRANCH in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''') group by a.BrType,a.Region,a.Branch,a.BranchName,SB )a INNER JOIN  Vw_RMS_SB_Vertical b on a.SB=b.SB  '                           
  
    
      
       
  SET @Main =  @Main + ' group by a.BrType,a.Region,a.Branch,a.BranchName'                                                                            
 END                        
ELSE IF @access_to = 'BRANCH'                      
SET @Main =  @Main +' where BRANCH_CD like '''+@Access_code+''' '                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
       
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_BRANCH_06012017
-- --------------------------------------------------
--RPT_HIST_DRCR_BRANCH '%','BRANCH','Sanjay','Broker','CSO'                      
CREATE procedure [dbo].[RPT_HIST_DRCR_BRANCH_06012017]                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST '                      
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                      
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE Desc'                      
                      
IF @access_to = 'BRMAST'                      
 BEGIN                                   
  SET @Main =  @Main + ' and a.BRANCH in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''') group by a.BrType,a.Region,a.Branch,a.BranchName,SB )a INNER JOIN  Vw_RMS_SB_Vertical b on a.SB=b.SB  '                           
  
    
      
       
  SET @Main =  @Main + ' group by a.BrType,a.Region,a.Branch,a.BranchName'                                                                            
 END                        
ELSE IF @access_to = 'BRANCH'                      
SET @Main =  @Main +' where BRANCH_CD like '''+@Access_code+''' '                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
       
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_BRANCH_24122016
-- --------------------------------------------------

--RPT_HIST_DRCR_BRANCH '%','BRANCH','Sanjay','Broker','CSO'                      
CREATE procedure [dbo].[RPT_HIST_DRCR_BRANCH_24122016]                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST '                      
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                      
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE Desc'                      
                      
IF @access_to = 'BRMAST'                      
 BEGIN                                   
  SET @Main =  @Main + ' and a.BRANCH in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''') group by a.BrType,a.Region,a.Branch,a.BranchName,SB )a INNER JOIN  Vw_RMS_SB_Vertical b on a.SB=b.SB  '                           
  
    
      
       
  SET @Main =  @Main + ' group by a.BrType,a.Region,a.Branch,a.BranchName'                                                                            
 END                        
ELSE IF @access_to = 'BRANCH'                      
SET @Main =  @Main +' where BRANCH_CD like '''+@Access_code+''' '                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
       
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_BRANCH_BSX
-- --------------------------------------------------
--RPT_HIST_DRCR_BRANCH '%','BRANCH','Sanjay','Broker','CSO'                      
CREATE procedure RPT_HIST_DRCR_BRANCH_BSX                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(BSX_Ledger)/100000) as [BSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST '                      
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                      
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE Desc'                      
                      
IF @access_to = 'BRMAST'                      
 BEGIN                                   
  SET @Main =  @Main + ' and a.BRANCH in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''') group by a.BrType,a.Region,a.Branch,a.BranchName,SB )a INNER JOIN  Vw_RMS_SB_Vertical b on a.SB=b.SB  '                           
  
    
      
       
  SET @Main =  @Main + ' group by a.BrType,a.Region,a.Branch,a.BranchName'                                                                            
 END                        
ELSE IF @access_to = 'BRANCH'                      
SET @Main =  @Main +' where BRANCH_CD like '''+@Access_code+''' '                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
       
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client
-- --------------------------------------------------
  
--RPT_HIST_DRCR_Client 'M709','Client','Sanjay','Broker','CSO'                            
CREATE procedure [dbo].[RPT_HIST_DRCR_Client]                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN

-- return 0                                         

 SET NOCOUNT ON                                       
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-30'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
       
 SET NOCOUNT OFF                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client_180
-- --------------------------------------------------
  
--RPT_HIST_DRCR_Client 'M709','Client','Sanjay','Broker','CSO'                            
create procedure [dbo].[RPT_HIST_DRCR_Client_180]                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN
                                             
 SET NOCOUNT ON    
   print 'hii' 
   
                                   
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-180'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
       
 SET NOCOUNT OFF            
                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client_24122016
-- --------------------------------------------------

  
--RPT_HIST_DRCR_Client 'M709','Client','Sanjay','Broker','CSO'                            
CREATE procedure [dbo].[RPT_HIST_DRCR_Client_24122016]                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN
                                             
 SET NOCOUNT ON    
                                    
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
       
 SET NOCOUNT OFF            
                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client_Bkp10Dec2021
-- --------------------------------------------------
                        
CREATE procedure [dbo].[RPT_HIST_DRCR_Client_Bkp10Dec2021]                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN
  --return 0                                         
 SET NOCOUNT ON    
   print 'hii' 

                                   
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM] '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit]'                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date]'                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good]'        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor]'        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk]'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-180'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
       
 SET NOCOUNT OFF                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client_BSX
-- --------------------------------------------------
--RPT_HIST_DRCR_Client 'M709','Client','Sanjay','Broker','CSO'                            
CREATE procedure RPT_HIST_DRCR_Client_BSX                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN                                              
 SET NOCOUNT ON                                              
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(BSX_Ledger)/100000) as [BSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
             
 SET NOCOUNT OFF                                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_Client_NXT
-- --------------------------------------------------
  
--RPT_HIST_DRCR_Client_NXT 'M709','Client','Sanjay','Broker','CSO'                            
CREATE procedure [dbo].[RPT_HIST_DRCR_Client_NXT]                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN
                                             
 SET NOCOUNT ON    
   print 'hii' 
--   return 0
                                   
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                            
SET @Main =  @Main +' select '                            
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '                          
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)'                          
SET @Main =  @Main +' where Client  like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                            
IF @access_to='Client'                          
SET @Main =  @Main +' and Client like '''+@Access_code+''' '                            
else                          
SET @Main =  @Main +' '                          
                          
 SET @Main =  @Main +' group by RMS_DATE '                    
 SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
 SET @Main =  @Main +' SELECT ''&nbsp;'' '                            
 set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         

  
    
           
 print @Main    
 EXECUTE sp_executesql @Main                                
       
 SET NOCOUNT OFF            
                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_REGION
-- --------------------------------------------------
--RPT_HIST_DRCR_REGION 'NC GUJ','Region','Sanjay','Broker','CSO'                      
CREATE procedure RPT_HIST_DRCR_REGION                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
--Region                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_REGION_HIST '                      
SET @Main =  @Main +' where region like '''+@EntityCode+''' and RMS_DATE>getdate()-90 '                      
                      
IF @access_to = 'ZONE'                                                              
 SET @Main =  @Main + ' and REGION  like '''+@access_code+''''                                                                    
IF @access_to = 'REGIONMAST'                                                           
 SET @Main =  @Main + ' and REGION in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''')  group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB )a  group by a.Zone,a.Region,a.RegionName'                           
  
    
      
        
          
            
              
                
                  
                   
                      
                       
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE desc'                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from [general].dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                       
         
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_REGION_24122016
-- --------------------------------------------------

--RPT_HIST_DRCR_REGION 'NC GUJ','Region','Sanjay','Broker','CSO'                      
CREATE procedure [dbo].[RPT_HIST_DRCR_REGION_24122016]                      
(                      
 @EntityCode AS VARCHAR(25),                      
 @EntityType AS VARCHAR(10),                      
 @userid AS VARCHAR(15),                      
 @access_to AS VARCHAR(10),                      
 @access_code AS VARCHAR(25)                      
)                      
AS                                        
BEGIN                                        
 SET NOCOUNT ON                                        
 declare @Main AS NVARCHAR(2000)                      
                                                                 
 SET @Main = ' '                                                                
                       
                      
--Region                      
SET @Main =  @Main +' select '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                      
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                      
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                      
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                      
SET @Main =  @Main +' from TBL_RMS_COLLECTION_REGION_HIST '                      
SET @Main =  @Main +' where region like '''+@EntityCode+''' and RMS_DATE>getdate()-90 '                      
                      
IF @access_to = 'ZONE'                                                              
 SET @Main =  @Main + ' and REGION  like '''+@access_code+''''                                                                    
IF @access_to = 'REGIONMAST'                                                           
 SET @Main =  @Main + ' and REGION in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''')  group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB )a  group by a.Zone,a.Region,a.RegionName'                           
  
    
      
        
          
            
              
                
                  
                   
                      
                       
SET @Main =  @Main +' group by RMS_DATE '                      
SET @Main =  @Main +' order by RMS_DATE desc'                      
                      
SET @Main =  @Main +' SELECT '' '' '                      
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                         
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from [general].dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                       
         
 EXECUTE sp_executesql @Main                                                                      
                                    
 SET NOCOUNT OFF                                                                  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_REGION_BSX
-- --------------------------------------------------
--RPT_HIST_DRCR_REGION 'NC GUJ','Region','Sanjay','Broker','CSO'                        
CREATE procedure RPT_HIST_DRCR_REGION_BSX                       
(                        
 @EntityCode AS VARCHAR(25),                        
 @EntityType AS VARCHAR(10),                        
 @userid AS VARCHAR(15),                        
 @access_to AS VARCHAR(10),                        
 @access_code AS VARCHAR(25)                        
)                        
AS                                          
BEGIN                                          
 SET NOCOUNT ON                                          
 declare @Main AS NVARCHAR(2000)                        
                                                                   
 SET @Main = ' '                                                                  
                         
                        
--Region                        
SET @Main =  @Main +' select '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(BSX_Ledger)/100000) as [BSX],,convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                        
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Collection)/100000) as [Net Collection],convert(decimal(15,2),SUM(GROSS_Collection)/100000) as [Gross Collection], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),MIN(Tot_SBRisk)/100000) as [Risk], '                        
SET @Main =  @Main +' convert(decimal(15,2),MIN(Sb_ProjRisk)/100000) as [Proj Risk] '                        
SET @Main =  @Main +' from TBL_RMS_COLLECTION_REGION_HIST '                        
SET @Main =  @Main +' where region like '''+@EntityCode+''' and RMS_DATE>getdate()-90 '                        
                        
IF @access_to = 'ZONE'                                                                
 SET @Main =  @Main + ' and REGION  like '''+@access_code+''''                                                                      
IF @access_to = 'REGIONMAST'                                                             
 SET @Main =  @Main + ' and REGION in (select Accesscode from tbl_RMS_GroupMaster  where groupcode= '''+@access_code+''')  group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB )a  group by a.Zone,a.Region,a.RegionName'                           
                       
                         
SET @Main =  @Main +' group by RMS_DATE '                        
SET @Main =  @Main +' order by RMS_DATE desc'                        
                        
SET @Main =  @Main +' SELECT '' '' '                        
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                           
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from [general].dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                       
  
           
 EXECUTE sp_executesql @Main                                                    
                                      
 SET NOCOUNT OFF                                                                    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_DRCR_SB
-- --------------------------------------------------
-- RPT_HIST_DRCR_SB 'RSAN','SB','Sanjay','Broker','CSO'                            
CREATE procedure RPT_HIST_DRCR_SB                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN                                              
 SET NOCOUNT ON                                              
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                             
                            
SET @Main =  @Main +' select '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],convert(decimal(15,2),SUM(ISNULL(GROSS_Collection, 0))/100000) as [Gross Collection], '                        
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_BlueChip)/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Poor)/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Holding)/100000) as [Total  Holding], '        
SET @Main =  @Main +' convert(decimal(15,2),MAX(SB_Credit)/100000) as [SB Credit], '                          
        
-- SET @Main = @Main + ' [SB Credit]=''<a href=''''report.aspx?reportno=148&RMS_DATE=''+Convert(varchar,RMS_DATE,106)+ ''&EntityCode=''+max(SUB_BROKER)+'''                                                     
-- SET @Main = @Main + '&divw=In Lacs'          
-- SET @Main = @Main + '&divby=100000'          
-- SET @Main = @Main + ''''' style="cursor:hand;text-align:right;">'                                                                                                                                
-- SET @Main = @Main + '''+ CONVERT(varchar(25),CONVERT(decimal(20,2),MAX(SB_Credit)/100000))+ ''</a>'','                                                                         
        
        
SET @Main =  @Main +' convert(decimal(15,2),MAX(Tot_ClientRisk)/100000) as [Client Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),MAX(Tot_ProjRisk)/100000) as [SB Proj. Risk] '                          
SET @Main =  @Main +' from tbl_RMS_collection_SB_Hist '                          
SET @Main =  @Main +' where SUB_BROKER like '''+@EntityCode+''' and RMS_DATE>getdate()-90'                           
                        
                          
SET @Main =  @Main +' group by RMS_DATE '                          
SET @Main =  @Main +' order by RMS_DATE Desc'                          
                          
SET @Main =  @Main +' SELECT '' '' '                            
set @Main = @Main +' select title=''ALL CLIENTS REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                     
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid in(''10'',''32'',''61'') order by batchdate desc  Set Nocount off'                        
   
   
       
        
          
             
 EXECUTE sp_executesql @Main                                                                            
                                          
 SET NOCOUNT OFF                                                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_LEGAL_CLIENT
-- --------------------------------------------------
--RPT_HIST_LEGAL_CLIENT 's4455','CLIENT','Sanjay','Broker','CSO'              
CREATE procedure RPT_HIST_LEGAL_CLIENT            
(              
 @EntityCode AS VARCHAR(25),              
 @EntityType AS VARCHAR(10),              
 @userid AS VARCHAR(15),              
 @access_to AS VARCHAR(10),              
 @access_code AS VARCHAR(25)              
)              
AS                                
BEGIN                                
 SET NOCOUNT ON                                
 declare @Main AS NVARCHAR(2000)              
                                                         
 SET @Main = ' '                                                        
               
              
--Region              
SET @Main =  @Main +' select '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [Proj Risk], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Risk_Inc_Dec)/100000) as [Risk Inc/Dec],Convert(varchar,RMS_DATE,106) as [History Date], '          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Collection], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Debit)/100000) as [Net Debit], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_TotalHC)/100000) as [Total  Hold with HC],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin],convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure] '            
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST '            
SET @Main =  @Main +' where CLIENT like '''+@EntityCode+''' and Report_Type=''L'' and RMS_DATE>getdate()-90'            
SET @Main =  @Main +' group by RMS_DATE '            
SET @Main =  @Main +' order by RMS_DATE Desc'            
            
              
              
SET @Main =  @Main +' SELECT '' '' '              
set @Main = @Main +' select title=''LEGAL CLIENT REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                 
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                        
 EXECUTE sp_executesql @Main                                                              
                            
 SET NOCOUNT OFF                                                          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_RISK_BRANCH
-- --------------------------------------------------
--RPT_HIST_RISK_BRANCH '%','Region','Sanjay','Broker','CSO'                            
CREATE procedure RPT_HIST_RISK_BRANCH                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN                                              
 SET NOCOUNT ON                                              
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                             
                            
--Region                            
--SET @Main =  @Main +' select convert(decimal(15,2),SUM(Tot_ProjRisk)/100000) as [Proj Risk (SB Proj. Risk)],'                          
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(Tot_PureRisk)/100000) as [Pure Risk],  '                          
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_ClientRisk)/100000) as [Total Risk], '                          
          
SET @Main =  @Main +' select convert(decimal(15,2),SUM(SB_ProjRisk)/100000) as [Proj Risk],'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(SB_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(SB_PureRisk)/100000) as [Pure Risk],  '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_SBRisk)/100000) as [Total Risk], '                          
          
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Risk_Inc_Dec,0))/100000) as [Risk Inc/Dec],convert(decimal(15,2),MAX(isnull(Risk_Inc_Dec_Perc,0))) as [Risk Inc/Dec %], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '      
SET @Main =  @Main +' [Net Debit]=convert(decimal(15,2),(select SUM(Net)/100000 from TBL_RMS_COLLECTION_BRANCH_HIST where (Report_Type=''R'' OR Report_Type=''L'') and BRANCH_CD like '''+@EntityCode+''' and RMS_DATE=A.RMS_DATE)) ,'      
      
--convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Pure_Net_Collection,0))/100000) as [Pure Net Collection], convert(decimal(15,2),SUM(isnull(Proj_Net_Collection,0))/100000) as [Proj Net Collection],'              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure]  '                          
SET @Main =  @Main +' from TBL_RMS_COLLECTION_BRANCH_HIST  A '                          
SET @Main =  @Main +' where BRANCH_CD like '''+@EntityCode+''' and Report_Type=''R'' and RMS_DATE>getdate()-90'                          
SET @Main =  @Main +' group by RMS_DATE '                    
SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
                            
                            
SET @Main =  @Main +' SELECT '' '' '                            
set @Main = @Main +' select title=''RISK BRANCH REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
             
 EXECUTE sp_executesql @Main                                                                            
                                          
 SET NOCOUNT OFF                                                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_RISK_CLIENT
-- --------------------------------------------------
--RPT_HIST_RISK_CLIENT '%','Region','Sanjay','Broker','CSO'                
CREATE procedure RPT_HIST_RISK_CLIENT              
(                
 @EntityCode AS VARCHAR(25),                
 @EntityType AS VARCHAR(10),                
 @userid AS VARCHAR(15),                
 @access_to AS VARCHAR(10),                
 @access_code AS VARCHAR(25)                
)                
AS                                  
BEGIN                                  
 SET NOCOUNT ON                                  
 declare @Main AS NVARCHAR(2000)                
                                                           
 SET @Main = ' '                                                          
                 
                
--Region                
SET @Main =  @Main +' select convert(decimal(15,2),SUM(Proj_Risk)/100000) as [Proj Risk (SB Proj. Risk)],'              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Risk_Inc_Dec)/100000) as [Risk Inc/Dec],Convert(varchar,RMS_DATE,106) as [History Date], '            
SET @Main =  @Main +' convert(decimal(15,2),SUM(Gross_Collection)/100000) as [Collection], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Net_Debit)/100000) as [Net Debit], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(BSE_Ledger)/100000) as [BSECM],convert(decimal(15,2),SUM(NSE_Ledger)/100000) as [NSECM], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_TotalHC)/100000) as [Total  Hold with HC],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin],convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit] '              
SET @Main =  @Main +' FROM TBL_RMS_COLLECTION_CLIENT_HIST '              
SET @Main =  @Main +' where CLIENT like '''+@EntityCode+''' and Report_Type=''R'' and RMS_DATE>getdate()-90'              
SET @Main =  @Main +' group by RMS_DATE '        
SET @Main =  @Main +' order by RMS_DATE Desc'        
              
                
                
SET @Main =  @Main +' SELECT '' '' '                
set @Main = @Main +' select title=''RISK CLIENT REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                   
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                          
print @Main     
EXECUTE sp_executesql @Main                                                                
                              
 SET NOCOUNT OFF                                                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_RISK_REGION
-- --------------------------------------------------
--RPT_HIST_RISK_REGION 'MUMBAI','Region','Sanjay','Broker','CSO'                            
CREATE procedure RPT_HIST_RISK_REGION                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN                                              
 SET NOCOUNT ON                                              
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                             
                            
--Region                            
--SET @Main =  @Main +' select convert(decimal(15,2),SUM(Tot_ProjRisk)/100000) as [Proj Risk (SB Proj. Risk)],'                          
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(Tot_PureRisk)/100000) as [Pure Risk],  '                          
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_ClientRisk)/100000) as [Total Risk], '                          
SET @Main =  @Main +' select convert(decimal(15,2),SUM(SB_ProjRisk)/100000) as [Proj Risk],'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(SB_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(SB_PureRisk)/100000) as [Pure Risk],  '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_SBRisk)/100000) as [Total Risk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Risk_Inc_Dec,0))/100000) as [Risk Inc/Dec],convert(decimal(15,2),MAX(isnull(Risk_Inc_Dec_Perc,0))) as [Risk Inc/Dec %], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date], '      
SET @Main =  @Main +' Net=convert(decimal(15,2),(select SUM(Net)/100000 from TBL_RMS_COLLECTION_REGION_HIST where (Report_Type=''R'' OR Report_Type=''L'') and REGION like '''+@EntityCode+''' and RMS_DATE=A.RMS_DATE)) ,'      
      
--convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '              
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Pure_Net_Collection,0))/100000) as [Pure Net Collection], convert(decimal(15,2),SUM(ISNULL(Proj_Net_Collection,0))/100000) as [Proj Net Collection],'              
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure]  '                          
SET @Main =  @Main +' from TBL_RMS_COLLECTION_REGION_HIST A '                          
SET @Main =  @Main +' where REGION like '''+@EntityCode+''' and (Report_Type=''R'') and RMS_DATE>getdate()-90'                          
SET @Main =  @Main +' group by RMS_DATE '                    
SET @Main =  @Main +' order by RMS_DATE Desc'                    
                          
                            
                            
SET @Main =  @Main +' SELECT '' '' '                            
set @Main = @Main +' select title=''RISK REGION REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                         
             
print @Main                 
EXECUTE sp_executesql @Main                
                                          
 SET NOCOUNT OFF                                                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_HIST_RISK_SB
-- --------------------------------------------------
--RPT_HIST_RISK_SB 'PLU','SB','Sanjay','Broker','CSO'                            
CREATE procedure RPT_HIST_RISK_SB                          
(                            
 @EntityCode AS VARCHAR(25),                            
 @EntityType AS VARCHAR(10),                            
 @userid AS VARCHAR(15),                            
 @access_to AS VARCHAR(10),                            
 @access_code AS VARCHAR(25)                            
)                            
AS                                              
BEGIN                                              
 SET NOCOUNT ON                                              
 declare @Main AS NVARCHAR(2000)                            
                                                                       
 SET @Main = ' '                                                                      
                             
                            
--Region                            
--SET @Main =  @Main +' select convert(decimal(15,2),SUM(Tot_ProjRisk)/100000) as [Proj Risk (SB Proj. Risk)],'                          
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(Tot_PureRisk)/100000) as [Pure Risk], '                           
--SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_ClientRisk)/100000) as [Total Risk], '                          
      
SET @Main =  @Main +' select convert(decimal(15,2),SUM(SB_ProjRisk)/100000) as [Proj Risk (SB Proj. Risk)],'                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(SB_LegalRisk)/100000) as [Legal Risk],CONVERT(decimal(15,2),SUM(SB_PureRisk)/100000) as [Pure Risk], '                           
SET @Main =  @Main +' convert(decimal(15,2),SUM(Tot_SBRisk)/100000) as [Total Risk], '                          
      
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Risk_Inc_Dec,0))/100000) as [Risk Inc/Dec],convert(decimal(15,2),MAX(isnull(Risk_Inc_Dec_Perc,0))) as [Risk Inc/Dec %], '                          
SET @Main =  @Main +' Convert(varchar,RMS_DATE,106) as [History Date],convert(decimal(15,2),SUM(Net)/100000) as [Net Debit], '               
SET @Main =  @Main +' convert(decimal(15,2),SUM(isnull(Pure_Net_Collection,0))/100000) as [Pure Net Collection], convert(decimal(15,2),SUM(isnull(Proj_Net_Collection,0))/100000) as [Proj Net Collection],'            
SET @Main =  @Main +' convert(decimal(15,2),SUM(SB_Credit)/100000) as [SB Credit], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_BlueChip)/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Hold_Poor)/100000) as [Poor],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Junk], '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Holding)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Total_Colleteral)/100000) as [Total Collateral],  '                          
SET @Main =  @Main +' convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure] '                          
SET @Main =  @Main +' from tbl_RMS_collection_SB_Hist '                          
SET @Main =  @Main +' where SUB_BROKER like '''+@EntityCode+''' and Report_Type=''R'' and RMS_DATE>getdate()-90'                          
SET @Main =  @Main +' group by RMS_DATE '                    
SET @Main =  @Main +' Order by RMS_DATE Desc'                          
                          
                            
                            
SET @Main =  @Main +' SELECT '' '' '                            
set @Main = @Main +' select title=''RISK SB REPORT - '+UPPER(@EntityType)+' : '+ replace(UPPER(@EntityCode),'%','ALL')+''''                                                               
 set @Main = @Main +' select top 1 tdate=''Last updated on : '' +convert(varchar,batchendtime,106)+'' ''+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=30 order by batchdate desc  Set Nocount off'                                     
 
         
--print @Main        
        
EXECUTE sp_executesql @Main                                                                            
                                          
 SET NOCOUNT OFF                                                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_ld_offline_view_data
-- --------------------------------------------------
/**************************************************************************************************************        
CREATED BY :: Mittal Sompura      
CREATED DATE :: 07 Nov 2013        
PURPOSE :: get data of Reporting Ledger(Offline) for LD      
--exec Rpt_ld_offline_view_data 'lvdpqb3xtrv3zs55qqscgz55','11/06/2013','PTA5309','Reporting Colletral','E34080','Broker','CSO'          
    
******************************************************************************************************************/    
CREATE PROC RPT_LD_OFFLINE_VIEW_DATA (@SESSIONID   VARCHAR(50),
                                     @DATE        DATETIME,
                                     @PARTY_CODE  VARCHAR(20),
                                     @report_Type VARCHAR(50),
                                     @USERID      AS VARCHAR(15),
                                     @ACCESS_TO   AS VARCHAR(10),
                                     @ACCESS_CODE AS VARCHAR(10))
AS
SET nocount ON
    
  BEGIN    
      EXEC Fetch_holding_ld_view_data    
        @SESSIONID,    
        @DATE,    
        @PARTY_CODE    
    
      /* @report_Type =0 (Reporting Colletral) and @report_Type= 1 (Reporting Ledger) */    
      IF @REPORT_TYPE = 'Reporting Colletral'    
        BEGIN    
            SELECT TRANSACTION_DATE,    
                   CLIENT_CODE,    
                   ISIN_ODE,    
                   TO_DELIVER_STOCKS,    
                   PERCENT_HAIRCUT,    
                   HAIRCUT,    
                   POA_STOCKS_QTY,    
                   MARKETVALUE,    
                   SOURCE_TABLE,    
                   MARKET_BOD_VALUE,    
                   MARKET_VALUE,    
                   T2T_SCRIP,    
                   SEGMENT_TYPE,    
                   CASE    
                     WHEN Row_number() OVER(ORDER BY CLIENT_CODE DESC) = 1 THEN '<a href=''report.aspx?reportno=190&SESSIONID=' + @SESSIONID + ' &USERID=' + @USERID + ' &ACCESS_TO=' + @ACCESS_TO + ' &DATE=' + convert(varchar(11),@DATE) + ' &ACCESS_CODE='+ @ACCESS_CODE + ' &PARTY_CODE=' + @PARTY_CODE +' &report_Type=' + @report_Type + '''>' + CONVERT(VARCHAR(15), REPORTINGCOLL) + '</a>'    
                     ELSE CONVERT(VARCHAR(15), REPORTINGCOLL)    
                   END AS REPORTINGCOLL,    
                   BEN_STOCKS,    
                   CASE WHEN T2DAY_COLL_VAL > 0 
                        THEN '<a href=''report.aspx?reportno=193&SESSIONID=' + @SESSIONID + ' &USERID=' + @USERID + ' &ACCESS_TO=' + @ACCESS_TO + ' &DATE=' + convert(varchar(11),@DATE) + ' &ACCESS_CODE='+ @ACCESS_CODE + ' &PARTY_CODE=' + @PARTY_CODE +' &report_Type=' + @report_Type + '''>' + CONVERT(VARCHAR(15), T2DAY_COLL_VAL) + '</a>'
                        ELSE CONVERT(VARCHAR,T2DAY_COLL_VAL)
                   END AS T2DAY_COLL_VAL
            FROM   VW_ANNEXTURE7_STOCK_LD_VIEW_DATA    
            WHERE  SESSION_ID = @SESSIONID    
        END    
      ELSE    
        BEGIN    
            SELECT Convert(varchar,RPT_Date,103) as ProcessDate,    
                   ZONE,    
                   REGION,    
                   BRANCH,    
                   SB,    
                   PARTY_CODE,    
                   CLI_TYPE,    
                   LEDGER,    
                   CASE    
                     WHEN Row_number() OVER(ORDER BY PARTY_CODE DESC) = 1 THEN '<a href=''report.aspx?reportno=191&SESSIONID=' + @SESSIONID + ' &USERID=' + @USERID + ' &ACCESS_TO=' + @ACCESS_TO + ' &DATE=' + convert(varchar(11),@DATE) + ' &ACCESS_CODE=' + @ACCESS_CODE + ' &PARTY_CODE=' + @PARTY_CODE +' &report_Type=' + @report_Type +'''>' + CONVERT(VARCHAR(15), NONCASH) + '</a>'    
                     ELSE CONVERT(VARCHAR(15), NONCASH)
                   END AS NONCASH,
                   CASE WHEN T2DAY_COLL_VAL > 0 
                        THEN '<a href=''report.aspx?reportno=193&SESSIONID=' + @SESSIONID + ' &USERID=' + @USERID + ' &ACCESS_TO=' + @ACCESS_TO + ' &DATE=' + convert(varchar(11),@DATE) + ' &ACCESS_CODE='+ @ACCESS_CODE + ' &PARTY_CODE=' + @PARTY_CODE +' &report_Type=' + @report_Type + '''>' + CONVERT(VARCHAR(15), T2DAY_COLL_VAL) + '</a>'
                        ELSE CONVERT(VARCHAR,T2DAY_COLL_VAL)
                   END AS T2DAY_COLL_VAL
            FROM   Vw_EXCHANGEMARGINREPORTING_FOR_LD_VIEW_DATA
            WHERE  SESSION_ID = @SESSIONID
        END
    
      SELECT ''
    
      SELECT 'LD VIEW DATA DETAILS Date -'+ Convert(varchar,@DATE,103)+' :: Client Code -'+ @PARTY_CODE +':: Report Type - '+@report_Type    
    
      SELECT Tdate =''    
  END    
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_MonthEnd_Holding
-- --------------------------------------------------

-- Author:		Abha Jaiswal
-- Create date: 07/03/2018
-- Description:Month end holdind data
-- =============================================
-- Rpt_MonthEnd_Holding 'S278128','Mar 31 2021'
 

CREATE PROCEDURE [dbo].[Rpt_MonthEnd_Holding]
@party_code varchar(20),
@last_day varchar(11)
AS
BEGIN

return 0
if @last_day='Mar 31 2021'
set @last_day='Apr 01 2021'
		SELECT * INTO #AA FROM
		(
		select isin,exchange,qty,clsrate,scripname,total from rms_holding where  cast(Upd_date as date) = @last_day and exchange<>'POA' AND SOURCE ='H' and party_code=@party_code
		union all
		--select isin,exchange,qty,clsrate,scripname,total from rms_holding_archive_abha 
		--where  cast(Upd_date as date) =@last_day and exchange<>'POA' and  SOURCE ='H' and party_code=@party_code
		--union all
		select isin,co_code as exchange,qty,cl_rate as clsrate,scrip_cd as scripname,Amount as total  from Client_Collaterals_hist
		where  cast(RMS_DATE as date) =@last_day and party_code=@party_code
		union all
		select isin,exchange='NBFC',NetQty as qty,clspr as clsrate,FULLNAME as scripname,PFVAlue as total  from miles_StockholdingData 
		where  cast(rptdt as date) =@last_day and partycode=@party_code
		)C 


		select * into #bb 
		from 
		(
		select isin,exchange,qty,clsrate,scripname,total
		from #AA 
		) src
        pivot

		(
		sum(QTY)
        for EXCHANGE in ([BSECM],[NSECM],[NSEFO],[MCX],[NSX],[NCDEX],[NBFC])
        ) piv;

		--select isin, symbol,exchange,qty from  securityholdingdata_rpt_hist where party_code='A101506' and cast(Update_date as date) ='Feb 28 2018' and exchange<>'POA'
		update #bb set [BSECM]=0.00 where [BSECM] is null 
		update #bb set [NSECM]=0.00 where [NSECM] is null 
		update #bb set [NSEFO]=0.00 where [NSEFO] is null 	
		update #bb set NSX=0.00 where NSX is null 
		update #bb set [NCDEX]=0.00 where [NCDEX] is null  
		update #bb set [NBFC]=0.00 where [NBFC] is null 
		update #bb set [MCX]=0.00 where [MCX] is null 

		select isin,max(scripname) as [company name],[BSECM]=sum([BSECM]),[NSECM]=sum([NSECM]),
		[NSEFO]=sum([NSEFO]),[MCX]=sum([MCX]),[NSX]=sum([NSX]),[NCDEX]=sum([NCDEX]),[NBFC]=sum([NBFC]),
		Toatal_Qty=(sum([BSECM])+sum([NSECM])+sum([NSEFO])+ sum([MCX])+sum(NSX)+sum([NCDEX])+ sum([NBFC])),Closing_rate=max(clsrate),Value=convert(decimal(10,2),0.00)
		into #final
		from #bb group by isin--,scripname

		update  #final set Value=Toatal_Qty*Closing_rate
		select isin,[company name],BSECM,NSECM,NSEFO,MCX,NSX,NCDEX,NBFC,Toatal_Qty,Closing_rate=convert(decimal(10,2),Closing_rate),Value from #final

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RPT_SB_CREDIT_HISTORY
-- --------------------------------------------------

--- RPT_SB_CREDIT_History '22 Aug 2011','DSB','In Lacs','100000','','BROKER','CSO'        
CREATE procedure RPT_SB_CREDIT_HISTORY       
(        
 @RMS_DATE as datetime,                                     
 @EntityCode as varchar(10),                                       
 @divw as varchar(10),                                       
 @divby as int,                                       
 @userid as varchar(15),                                       
 @access_To as varchar(10),                                      
 @access_Code as varchar(10)) as            
BEGIN                                      
set nocount on            
        
select  SB = sub_broker, [SB's cash deposit(in Lacs)]=convert(decimal(15,2),sum(SB_CashColl)/@divby),                            
[SB's non cash deposit(in Lacs)]=convert(varchar(1000),convert(decimal(15,2),sum(SB_NonCashColl)/@divby)),                            
[SB's Brokerage lying with Angel(in Lacs)]=convert(varchar(1000),convert(decimal(15,2),sum(SB_Ledger)/@divby)),                            
[SB's Accured brokerage(in Lacs)]=convert(varchar(1000),convert(decimal(15,2),sum(SB_Brokerage)/@divby)),                            
[Total SB credit(in Lacs)]=convert(decimal(15,2),(sum(SB_CashColl)+sum(SB_NonCashColl)+sum(SB_Ledger)+sum(SB_Brokerage))/@divby)                     
from rms_dtsbfi                     
where Sub_Broker =@EntityCode  
and Convert(varchar,RMS_Date,106)= convert(varchar,convert(datetime,@RMS_DATE),106)                    
Group by sub_broker      
  
select ''                        
                  
              
select ''                        
                           
select top 1 tdate='Last updated on : ' +convert(varchar,batchendtime,106)+' '+ convert(varchar,batchendtime,8) from general.dbo.rms_batchjob_log where batchid=13 order by batchdate desc                        
                        
set nocount off                                
                                        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SB_Holding
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[SB_Holding]            
(@Sb_Code as Varchar(25),          
@access_to as varchar(25),          
@access_code as varchar(25),          
@segment as varchar(20)='All'          
)              
AS                
              
SET NOCOUNT ON
select distinct co_code from Vw_SB_NonCashCollateral
if @segment='EQUITY'  
	begin  
		 select SB,Scrip_cd,QTY,co_Code,AMOUNT,isin,Shrt_HC,HairCut,total_WithHC from Vw_SB_NonCashCollateral
		 where SB=@Sb_Code and co_code in ('NSECM','BSECM','NSEFO','MCD','NSX')
	end
	else if @segment='Commodity'  
	begin  
		select SB,Scrip_cd,QTY,co_Code,AMOUNT,isin,Shrt_HC,HairCut,total_WithHC from Vw_SB_NonCashCollateral
		where SB=@Sb_Code and co_code in ('NCDX','MCX')
	end 
	else
	begin
		select SB,Scrip_cd,QTY,co_Code,AMOUNT,isin,Shrt_HC,HairCut,total_WithHC from Vw_SB_NonCashCollateral
		where SB=@Sb_Code          
	end	 
	
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SB_HoldingRpt
-- --------------------------------------------------

--exec SB_HoldingRpt 'MANO','31/03/2015','Broker','CSO','EQUITY'  
CREATE PROCEDURE [dbo].[SB_HoldingRpt]            
(@Sb_Code as Varchar(25),
@Hld_Date as varchar(11),                    
@access_to as varchar(25),          
@access_code as varchar(25),          
@segment as varchar(20)='All'          
)              
AS                
              
SET NOCOUNT ON

--declare @Hld_Date  as Varchar(25),@Party_Code as Varchar(25)            
--set @Hld_Date='31/03/2015'            
--select Convert(datetime,@Hld_Date+' 23:59:59',103)
--select Convert(datetime,@Hld_Date,103)    

SELECT A.SB,A.Scrip_cd,A.QTY,A.co_Code,A.AMOUNT,A.isin,A.Shrt_HC,   
HairCut=(case when CO_CODE = @segment then ISNULL(b.BSE_proj_VaR, 100)   
   when (CO_CODE = @segment OR CO_CODE = @segment) then ISNULL(b.NSE_proj_VaR, 100)   
   else 100   
   end) ,   
total_WithHC=case when qty > 0 then (AMOUNT)-((AMOUNT)*((case when CO_CODE = @Sb_Code then ISNULL(b.BSE_proj_VaR, 100)   
  when (CO_CODE = @segment OR CO_CODE = @segment) then ISNULL(b.NSE_proj_VaR, 100) else 100 end)/100.00))   
  else (AMOUNT)+((AMOUNT)*(isnull(a.Shrt_HC,100.00)/100.00)) end 
  into #SB  
from   
(select p.SB,p.Scrip_cd,p.QTY,p.co_Code,p.AMOUNT,p.isin,q.Shrt_HC from    
 (select SB,Scrip_cd,QTY,co_Code,AMOUNT,isin=(select top 1 isin from general.dbo.scrip_master where bsecode=cash.scrip_cd)   
 from   
   (SELECT SB,Scrip_cd,SUM(QTY) as QTY,Co_code,SUM(AMOUNT) as AMOUNT   
    FROM History.dbo.SB_NonCashCollateral   
where SB=@Sb_Code and
 Updated_On between Convert(datetime,@Hld_Date,103) and Convert(datetime,Convert(datetime,@Hld_Date+' 23:59:59',103),103)  
    GROUP BY SB,Scrip_cd,Co_code) cash) p, general.dbo.company (nolock) q where p.CO_CODE=q.co_code) a   
left outer join general.dbo.ScripVaR_Master (nolock) b   
on a.isin=b.isin 

if @segment='EQUITY'  
begin  
 delete from #SB where co_Code in ('NCDEX','MCX')  
end  
else if @segment='Commodity'  
begin  
 delete from #SB where co_Code in ('NSEFO','MCD','NSX','NSECM','BSECM')  
end  

select x.isin,Scrip_cd,scripname,QTY,AMOUNT,Shrt_HC,HairCut,total_WithHC,co_Code from #SB x
left outer join general.dbo.Scrip_master_with_CP y on             
 x.isin=y.isin          
select ISIN='',scrip_cd='Total',scripname=':',QTY=SUM(QTY),
AMOUNT=SUM(Convert(money,AMOUNT)),Shrt_HC='',HairCut='',total_WithHC='',co_Code='' from #SB

SET NOCOUNT OFF

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
-- PROCEDURE dbo.Sp_SysObj
-- --------------------------------------------------

/*  
Author :- Prashant  
Date :- 28/01/2011  
*/  
CREATE Procedure Sp_SysObj  
(  
 @objName as varchar(20),  
 @objType as varchar(3)=''  
)  
as  
Begin  
 select * from sysobjects where name like '%'+@objName+'%' and type like '%'+@objType+'%'--'%batch%'  
 order by name,type  
End

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
-- PROCEDURE dbo.stp_help_search
-- --------------------------------------------------
--DROP PROC stp_help_search
Create  PROCEDURE [dbo].[stp_help_search]  
 (  
 @fslike    [nvarchar](500),  
 @nxtype    [tinyint]= 0,  
 @fntype    [tinyint]= 0  
 )  
-- WITH ENCRYPTION  
 AS  
 BEGIN  
 SET NOCOUNT ON   
   DECLARE @xtype varchar(2)  
   DECLARE @fxlike varchar(100)  
   DECLARE @charindex NVARCHAR(2)  
    
   SET @fslike =REPLACE (@fslike,'[','')  
   SET @fslike =REPLACE (@fslike,']','')  
   SET @fslike =REPLACE (@fslike,'','')  
     
   SET @fslike =LTRIM(RTRIM(@fslike))  
  
   SET @xtype = case  
       when @nxtype = 0 then ''  
       when @nxtype = 1 then 'U'  
       when @nxtype = 11 then 'U'  
       when @nxtype = 2 then 'P'  
       when @nxtype = 5 then 'PK'  
       when @nxtype = 10 then 'F'  
       when @nxtype = 4 then 'D'  
   
       else ''  
       end;  
   SET @fxlike ='stp_help'  
  
   IF  @fntype = 0 and  @nxtype <> 11  
    BEGIN  -- FOR TABLES  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'U' )  OR [xtype]  =  @xtype)  
      AND upper([name])   NOT LIKE '%'+ upper(@fxlike) +'%'  
     ORDER BY [name] ASC  
       -- FOR STP  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'P')  OR [xtype]  =  @xtype)  
      AND [name]   NOT LIKE '%'+ @fxlike +'%'  
       --FOR VIEWS  
      SELECT [name]  AS ' ' FROM sysobjects  
      WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
      AND ((@xtype   = '' and [xtype] = 'V')  OR [xtype]  =  @xtype)  
      AND [name]   NOT LIKE '%'+ @fxlike +'%'  
       
     ORDER BY [name] ASC  
  
        
    END  
   ELSE  
    BEGIN   
     IF @nxtype = 11  
     begin  
     declare @tabname nvarchar(100), @tabdata nvarchar(500)  
  
     create table #trper   
     (  
     tabname nvarchar(100),  
     tabdata nvarchar(500)  
     )  
  
  
       
     insert into #trper SELECT  [name], ' select * from '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
     declare tableselect cursor for select * from #trper  
  
     open  tableselect  
     fetch next from tableselect into @tabname, @tabdata  
      while @@fetch_status = 0  
       begin  
        print ' '  
        print '-------------------------------------------------------------------------------------'  
        print @tabname  
        execute(@tabdata)  
        fetch next from tableselect into @tabname, @tabdata  
       end  
     close tableselect  
     deallocate tableselect  
      
     drop table #trper  
     end  
  
  
  
    ELSE IF @nxtype = 2 AND @fntype <> 20  
     SELECT 'GO  
 sp_helptext '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
      
    ELSE IF @nxtype = 1 AND @fntype = 20  
     SELECT 'GO  
 stp_help_select '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 1 AND @fntype = 100  
     SELECT 'GO  
 stp_help_anyTableScripGenerator '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 1 AND @fntype  =200  
     begin  
     truncate table table_Null_FinalStatus  
     SELECT 'GO  
 stp_help_whereclouse '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
     end  
    ELSE IF @nxtype = 1 AND @fntype = 22  
     SELECT 'GO  
 stp_help_PreviousDayScripMasterGenerator_stp '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
    ELSE IF @nxtype = 2 AND @fntype = 20  
     SELECT 'GO  
 stp_help_stpdoc '+ [name] FROM sysobjects  
     WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
     AND (@xtype   = ''  
      OR [xtype]  =  @xtype)  
     ORDER BY [name]  
  
     ELSE  
        SELECT 'GO  
    sp_help '+ [name] FROM sysobjects  
       WHERE upper([name])   LIKE '%'+ upper(@fslike) +'%'  
        AND (@xtype   = ''  
         OR [xtype]  =  @xtype)  
        ORDER BY [name]  
  
    END  
  
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess
-- --------------------------------------------------
CREATE PROCEDURE upd_10DaysMarginShrtExcess              
               
AS              
BEGIN               
 delete from tbl_shortage_10days_hist where convert(date,process_date)=CONVERT(date, GETDATE())           
           
 insert into tbl_shortage_10days_hist              
 SELECT B.Zone,B.Region,B.Branch,B.SB,B.Category,B.SB_Category, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.PF,A.VAHC,NETMARGIN as shortage,GETDATE()    
 FROM [172.31.16.57].INHOUSE.DBO.nbfc_miles_ledger A WITH (NOLOCK)         
 inner join general.dbo.vw_rms_client_vertical B on A.BACKOFFICECODE=B.client             
 where NETMARGIN<0       
          
   
  insert into tbl_shortage_10days_hist_region      
  SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,      
  A.VAHC,A.MarginShrtExcess as shortage,GETDATE()-1,1      
   FROM tbl_shortage_10days_hist  A WITH (NOLOCK)       
   where A.TDATE=CONVERT(VARCHAR, GETDATE(), 105)and region in(      
  'A P',      
  'COIMBATORE',      
  'KARNATAKA',      
  'KERALA',      
  'T N',      
  'VKPATNAM')       
     
 insert into tbl_shortage_10days_hist_region          
 SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,    
 A.VAHC,A.MarginShrtExcess as shortage,GETDATE()-1,1    
  FROM tbl_shortage_10days_hist  A WITH (NOLOCK)     
 where  A.TDATE=CONVERT(VARCHAR, GETDATE(), 105)and  A.region in(    
 'DELHI',    
 'RAJSHTAN',    
 'U P',    
 'HARYANA',    
 'KOLK',    
 'M P',    
 'PUNJAB')    
   
 insert into tbl_shortage_10days_hist_region          
 SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,    
 A.VAHC,A.MarginShrtExcess as shortage,GETDATE(),1    
  FROM tbl_shortage_10days_hist  A WITH (NOLOCK)     
 where  A.TDATE=CONVERT(VARCHAR, GETDATE(), 105)and  A.region in(    
 'NC GUJ',  
'SOUTH GUJ',  
'BARODA',  
'NC GUJ1',  
'RSK',  
'MAHARASTRA',  
'ROSK',  
'SKFR',  
'SBU')    

 insert into tbl_shortage_10days_hist_region          
 SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,    
 A.VAHC,A.MarginShrtExcess as shortage,GETDATE(),1    
  FROM tbl_shortage_10days_hist  A WITH (NOLOCK)     
 where  A.TDATE=CONVERT(VARCHAR, GETDATE(), 105)and  A.region ='Mumbai'  
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess
-- --------------------------------------------------
    
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [ABVSCITRUS].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  --update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
  -- from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code
  -- WHERE convert(date,process_date)=convert(date, @ProcDate)

    update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(Amount,0)
   from tbl_shortage_10days_hist t left join general.dbo.tbl_CorporateAction_Data c on t.BACKOFFICECODE=c.party_code
   WHERE convert(date,process_date)=convert(date, @ProcDate)

   /* WHERE convert(date,process_date)=convert(date, @ProcDate) ---> Added ON 25/JAN/2019 after consultation with Siva.K */

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
 t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>-1000 and NosOfDays > 0 --and MarginShrtExcess < 0      

/* --and MarginShrtExcess < 0   --->   COMMENTED ON 25/JAN/2019 after consultation with Siva.K */  

----and shortage_after_excess_Credit_adj>=0  COMMENTED ON 25/JAN/2019 and replaced with shortage_after_excess_Credit_adj>-650 for updating noofdays=0 whose shortage is less than -650 after consultation with Siva.K
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
  delete from #final where client in (select distinct party_code from general.dbo.tbl_projrisk_t1day_data where updt=(select MAX(updt) from general.dbo.tbl_projrisk_t1day_data))                                         
  delete from #final where client in (select distinct party_code from general.dbo.tbl_projrisk_t2day_data where updt=(select MAX(updt) from general.dbo.tbl_projrisk_t2day_data)) 
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
   
   INSERT into tmp_Tbl_NBFC_Excess_ShortageSqOff SELECT * from #final where  shortage_after_excess_credit_adj>-1000  
   delete from #final where  shortage_after_excess_credit_adj>-1000    
   
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
	                      
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
         
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF                                                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_09102015
-- --------------------------------------------------
            
CREATE procedure upd_10DaysMarginShrtExcess_finalprocess_09102015                                     
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
                        
  /* GET NBFC CLIENT FROM NRMS-NBFC */                      
                  
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                                      
  into #tempnbfc                                          
  from  general.dbo.Vw_RmsDtclFi_Collection B                                   
  where  B.co_code = 'nbfc'                 
                  
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                                    
                  
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                          
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                           
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                           
  NET_COLLECTION=Sum(VC.Brk_Net)                                           
  INTO   #temp                                           
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                           
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                                         
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                                      
                                            
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */                      
  SELECT A.Party_code,A.RMSDate,                                           
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                           
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                           
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION                   
  INTO   #temp2                                           
  FROM   #tempnbfc A                                           
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                                      
                        
  /* MERGE DETAILS OF NBFC CLIENT */                   
                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into  #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                                       
  on A.backofficecode=B.Party_code                 
                                     
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO   #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    WHERE  nosofdays >= 4 /* or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(sq_qty * clsrate)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(                      
            nolock)                      
        /* seperate process: source NRMS */                      
        GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
     t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
select * from #final where shortage_after_excess_Credit_adj =0            
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
            
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where NosOfdays >=4 AND  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
   exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
  /*                      
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                                
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                    
  */                      
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_13042015
-- --------------------------------------------------
  
CREATE procedure upd_10DaysMarginShrtExcess_finalprocess_13042015                                      
AS                                        
BEGIN                                         
    
SET NOCOUNT ON    
    
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0    
BEGIN    
        
  declare @ProcDate as datetime             
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >       
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')      
        
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                     
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                     
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                     
                                  
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                       
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,netmargin as shortage,@ProcDate                             
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                   
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                       
  where netmargin<0                                 
        
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                               
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                
  from tbl_shortage_10days_hist  a with (nolock)       
  where convert(date,process_date)=convert(date, @ProcDate)                                   
                           
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'                        
                   
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */            
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                  
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                   
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                   
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                  
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                   
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                  
        
              
  /* GET NBFC CLIENT FROM NRMS-NBFC */            
        
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                            
  into #tempnbfc                                 
  from  general.dbo.Vw_RmsDtclFi_Collection B                              
  where  B.co_code = 'nbfc'       
        
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                               
        
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                 
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                 
  NET_COLLECTION=Sum(VC.Brk_Net)                                 
  INTO   #temp                                 
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                 
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                               
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                            
                                  
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */            
  SELECT A.Party_code,A.RMSDate,                                 
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                 
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                 
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION         
  INTO   #temp2                                 
  FROM   #tempnbfc A                                 
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                            
              
  /* MERGE DETAILS OF NBFC CLIENT */         
        
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                            
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                            
  into  #ExcessMargindata      
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                             
  on A.backofficecode=B.Party_code       
                           
  SELECT C.zone,            
      C.region,            
      C.branch,            
      C.sb,            
      C.backofficecode                AS client,            
      C.clientcategory,            
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,            
      C.sbcategory                    AS sbcat,            
      c.marginshrtexcess,            
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE            
                  WHEN            
           t2.net_collection > 0 THEN            
      c.marginshrtexcess + t2.net_collection            
      ELSE c.marginshrtexcess            
      END )),            
      shortage_after_excess_credit_adj=CASE            
      WHEN t2.net_collection > 0 THEN            
      ( c.marginshrtexcess + t2.net_collection )            
      ELSE c.marginshrtexcess            
            END,            
      Sum(( CASE            
        WHEN CASE            
         WHEN t2.net_collection > 0 THEN            
         c.marginshrtexcess + t2.net_collection            
         ELSE c.marginshrtexcess            
       END < 0            
       AND Isnull(d.squareoff_value, 0) <> 0 THEN            
        Isnull(d.squareoff_value, 0)            
        ELSE 0            
      END ) / 1)                squareoff_value,            
      c.nosofdays,            
      c.tdate            
  INTO   #final            
  FROM   (SELECT *,            
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'            
           + Substring(tdate, 1, 2) + '/'            
           + Substring(tdate, 7, 4)) AS tDATE1            
    FROM   tbl_shortage_10days_hist_region WITH (nolock)            
    WHERE  nosofdays >= 4 /* or nosofdays =5  or  nosofdays =6  */            
      )c            
      INNER JOIN #excessmargindata t2            
        ON C.backofficecode = t2.backofficecode            
        AND C.tdate1 + 1 = t2.tdate            
      LEFT OUTER JOIN (SELECT party_code,            
            squareoff_value=Sum(sq_qty * clsrate)            
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(            
            nolock)            
        /* seperate process: source NRMS */            
        GROUP  BY party_code) d            
       ON C.backofficecode = D.party_code            
  GROUP  BY C.zone,            
      C.region,            
      C.branch,            
      C.sb,            
      C.backofficecode,            
      C.clientcategory,            
      C.sbcategory,            
      C.backofficecode,            
      c.marginshrtexcess,            
     t2.net_collection,            
      c.nosofdays,            
      c.tdate             
  
/* Recalculate No(s) of days with After Excess Credit Adjustments */                           
select * from #final where shortage_after_excess_Credit_adj =0  
update tbl_shortage_10days_hist_region   
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj   
from #final b   
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate  
  
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and   
shortage_after_excess_Credit_adj=0 and excess_credit_net=0     
  
update tbl_shortage_10days_hist_region   
set NosOfDays=0   
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0     
        
/* Delete Client if exist in NBFC Risk */        
  delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))                                
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                
        
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where NosOfdays >=4 AND  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                       
            
  update #TXdata set ActiveEx=          
  (CASE           
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'          
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'          
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'          
  else 'N.A.' end)          
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')          
            
  update #TXdata set NosOfdays=6  where NosOfdays > 6                    
                  
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                               
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx                            
  FROM #TXdata A                           
              
  /*            
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                      
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                      
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                      
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                          
  */            
END    
ELSE    
BEGIN    
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'    
END    
    
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0    
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage            
ELSE    
Begin    
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'    
End    
     
    
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0    
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage            
ELSE    
bEGIN    
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'    
eND    
SET NOCOUNT OFF    
                          
                    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_16012016
-- --------------------------------------------------
            
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_16012016]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
                        
  /* GET NBFC CLIENT FROM NRMS-NBFC */                      
                  
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                                      
  into #tempnbfc                                          
  from  general.dbo.Vw_RmsDtclFi_Collection B                                   
  where  B.co_code = 'nbfc'                 
                  
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                                    
                  
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                          
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                           
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                           
  NET_COLLECTION=Sum(VC.Brk_Net)                                           
  INTO   #temp                                           
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                           
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                                         
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                                      
                                            
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */                      
  SELECT A.Party_code,A.RMSDate,                                           
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                           
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                           
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION                   
  INTO   #temp2                                           
  FROM   #tempnbfc A                                           
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                                      
                        
  /* MERGE DETAILS OF NBFC CLIENT */                   
                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into  #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                                       
  on A.backofficecode=B.Party_code                 
                                     
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO   #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(sq_qty * clsrate)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(                      
            nolock)                      
        /* seperate process: source NRMS */                      
        GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
select * from #final where shortage_after_excess_Credit_adj =0            
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
            
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
  /*                      
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                                
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                    
  */                      
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_17122015
-- --------------------------------------------------
            
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_17122015]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
                        
  /* GET NBFC CLIENT FROM NRMS-NBFC */                      
                  
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                                      
  into #tempnbfc                                          
  from  general.dbo.Vw_RmsDtclFi_Collection B                                   
  where  B.co_code = 'nbfc'                 
                  
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                                    
                  
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                          
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                           
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                           
  NET_COLLECTION=Sum(VC.Brk_Net)                                           
  INTO   #temp                                           
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                           
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                                         
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                                      
                                            
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */                      
  SELECT A.Party_code,A.RMSDate,                                           
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                           
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                           
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION                   
  INTO   #temp2                                           
  FROM   #tempnbfc A                                           
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                                      
                        
  /* MERGE DETAILS OF NBFC CLIENT */                   
                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into  #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                                       
  on A.backofficecode=B.Party_code                 
                                     
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO   #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(sq_qty * clsrate)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(                      
            nolock)                      
        /* seperate process: source NRMS */                      
        GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
select * from #final where shortage_after_excess_Credit_adj =0            
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
            
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
  /*                      
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                                
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                    
  */                      
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_18012016
-- --------------------------------------------------
            
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_18012016]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(sq_qty * clsrate)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)                      
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
  /*                      
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                                
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                    
  */                      
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_19012016
-- --------------------------------------------------
            
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_19012016]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
                        
  /* GET NBFC CLIENT FROM NRMS-NBFC */                      
                  
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                                      
  into #tempnbfc                                          
  from  general.dbo.Vw_RmsDtclFi_Collection B                                   
  where  B.co_code = 'nbfc'                 
                  
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                                    
                  
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                          
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                           
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                           
  NET_COLLECTION=Sum(VC.Brk_Net)                                           
  INTO   #temp                                           
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                           
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                                         
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                                      
                                            
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */                      
  SELECT A.Party_code,A.RMSDate,                                           
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                           
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                           
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION                   
  INTO   #temp2                                           
  FROM   #tempnbfc A                                           
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                                      
                        
  /* MERGE DETAILS OF NBFC CLIENT */                   
                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into  #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                                       
  on A.backofficecode=B.Party_code                 
                                     
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO   #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(sq_qty * clsrate)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(                      
            nolock)                      
        /* seperate process: source NRMS */                      
        GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
select * from #final where shortage_after_excess_Credit_adj =0            
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
            
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
  /*                      
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                                
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                    
  */                      
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_19032015
-- --------------------------------------------------
CREATE procedure upd_10DaysMarginShrtExcess_finalprocess_19032015                
                 
AS                
BEGIN                 
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, getdate())             
           
  insert into tbl_shortage_10days_hist                
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,netmargin as shortage,getdate()-1      
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)           
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client               
  where netmargin<0         
             
      
   insert into tbl_shortage_10days_hist_region        
   select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,        
   a.vahc,a.marginshrtexcess as shortage,getdate()-1,1        
   from tbl_shortage_10days_hist  a with (nolock)         
   where a.tdate=convert(varchar, getdate(), 105)and region in(        
   'A P',        
   'COIMBATORE',        
   'KARNATAKA',        
   'KERALA',        
   'T N',        
   'VKPATNAM')         
        
  insert into tbl_shortage_10days_hist_region            
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,      
  a.vahc,a.marginshrtexcess as shortage,getdate()-1,1      
  from tbl_shortage_10days_hist  a with (nolock)       
  where  a.tdate=convert(varchar, getdate(), 105)and  a.region in(      
  'DELHI',      
  'RAJSHTAN',      
  'U P',      
  'HARYANA',      
  'KOLK',      
  'M P',      
  'PUNJAB')      
      
  insert into tbl_shortage_10days_hist_region            
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,      
  a.vahc,a.marginshrtexcess as shortage,getdate()-1,1      
  from tbl_shortage_10days_hist  a with (nolock)       
  where  a.tdate=convert(varchar, getdate()-1, 105)and  a.region in(      
 'NC GUJ',    
 'SOUTH GUJ',    
 'BARODA',    
 'NC GUJ1',    
 'RSK',    
 'MAHARASTRA',    
 'ROSK',    
 'SKFR',    
 'SBU')      
      
--select * into tbl_shortage_10days_hist_region_20022015 from  tbl_shortage_10days_hist_region    
    
 update tbl_shortage_10days_hist_region set nosofdays=b.cnt from      
 (      
  select BACKOFFICECODE,cnt=COUNT(tbl_shortage_10days_hist_region.BACKOFFICECODE),srno=MAX(tbl_shortage_10days_hist_region.srno)      
  from tbl_shortage_10days_hist_region group by BACKOFFICECODE      
 )b      
  where tbl_shortage_10days_hist_region.SrNo=b.srno and tbl_shortage_10days_hist_region.BACKOFFICECODE=b.BACKOFFICECODE      
      
 /*    
 --To remove inconsistent shortage days     
 if exists (select COUNT(BACKOFFICECODE) from tbl_shortage_10days_hist_region group by BACKOFFICECODE having COUNT(BACKOFFICECODE)<4)    
 BEGIN    
 print 'hii'    
  delete from  tbl_shortage_10days_hist_region where BACKOFFICECODE in     
  (    
  select  BACKOFFICECODE from     
  (    
  select  BACKOFFICECODE,cnt=COUNT(BACKOFFICECODE),srno=MAX(srno)    
  from tbl_shortage_10days_hist_region  group by  BACKOFFICECODE having COUNT(BACKOFFICECODE)<=4    
  )b    
  )    
  and process_Date<Convert(datetime,Convert(varchar(11),getdate(),103),103)    
 END    
 */    
    

        
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate    
  into #tempnbfc         
  from  Vw_RmsDtclFi_Collection B      
  where  B.co_code = 'nbfc' and RMS_Date <= GETDATE() and RMS_Date >=(GETDATE()-7)      
      
     ----3176705--2 min    
       
        SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,        
        BROKING_NET_LEDGER=Sum(VC.Ledger),         
        TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),         
        NET_COLLECTION=Sum(VC.Brk_Net)         
  INTO   #temp         
  FROM   Vw_RmsDtclFi_Collection VC         
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')       
  and vc.RMS_Date <= GETDATE() and RMS_Date >=(GETDATE()-7)       
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))    
        
  --select * from #temp where Party_code='S117453'    
     
  SELECT A.Party_code,A.RMSDate,         
      Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,         
      Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,         
      Isnull(B.net_collection, 0.0)            AS NET_COLLECTION         
  INTO   #temp2         
  FROM   #tempnbfc A         
      LEFT OUTER JOIN #temp B  ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1    
          
       
   select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,    
   B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC    
   into #ExcessMargindata     
   from tbl_shortage_10days_hist_region A inner join #temp2 B     
   on A.backofficecode=B.Party_code and convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1=b.RMSDate    
     
     
  select        
  C.ZONE,    
  C.region,         
  C.branch,         
  C.sb,         
  C.BACKOFFICECODE AS client,         
  C.CLIENTCATEGORY,    
  CONVERT(VARCHAR(10),SPACE(10)) as cli_type,         
  C.sbcategory                          as sbcat,        
  c.marginshrtexcess,        
  excess_credit_net =abs(c.marginshrtexcess-(case when t2.net_collection>0 then c.marginshrtexcess+t2.net_collection else  c.marginshrtexcess end)),        
  shortage_after_excess_credit_adj=case when t2.net_collection>0 then (c.marginshrtexcess+t2.net_collection) else  c.marginshrtexcess end ,        
  sum(( case when case when t2.net_collection>0 then c.marginshrtexcess+t2.net_collection else c.marginshrtexcess end < 0    
  and isnull(d.squareoff_value, 0) <> 0 then         
  isnull(d.squareoff_value, 0)         
  else 0         
  end ) / 1)         
  squareoff_value,    
  c.nosofdays,    
  c.tdate         
  into  #final         
  from      
  (    
  SELECT *,convert(datetime,SUBSTRING(tdate,4,2)+'/'+SUBSTRING(tdate,1,2)+'/'+SUBSTRING(tdate,7,4)) AS tDATE1     
  FROM tbl_shortage_10days_hist_region  with (nolock) WHERE nosofdays =4 or nosofdays =5    
  )c     
  inner join     
  #ExcessMargindata t2 on C.backofficecode=t2.backofficecode AND C.TDATE1=t2.TDATE    
  left outer join (    
  select party_code,         
  squareoff_value=sum(sq_qty * clsrate)         
  from   general.dbo.excessmargin_squareup_nbfc with(nolock)   /* seperate process: source NRMS */      
  group  by party_code    
  ) d         
  ON C.BACKOFFICECODE=D.PARTY_CODE    
  group by     
  C.ZONE,    
  C.region,         
  C.branch,         
  C.sb,         
  C.BACKOFFICECODE,    
  C.CLIENTCATEGORY,    
  C.sbcategory,    
  C.BACKOFFICECODE,        
  c.marginshrtexcess,    
  t2.net_collection,    
  c.nosofdays,c.tdate             
                       
   --end          
     --drop table #squareup_client_alert_nbfc     
   select [client code] into   #squareup_client_alert_nbfc     
   from general.dbo.squareup_client_alert_nbfc where convert(date,updt,105)=convert(date,getdate(),105)        
   group by [client code]    
       
   select party_code into #squareup_client_nbfc     
   from general.dbo.squareup_client_nbfc     
   where convert(date,updt,105)=convert(date,getdate(),105)        
   group by Party_Code    
       
   delete from #final where client in (select  [client code] from #squareup_client_alert_nbfc)        
   delete from #final where client in (select  party_code from #squareup_client_nbfc)        
    
    /*Inserting t5 data*/        
   select A.*  into  #T5data from #final A where NosOfdays =4 AND  a.SQUAREOFF_VALUE>0  and a.tdate=GETDATE()  
           
   /*Inserting t6 data*/        
   select A.* into #T6data from #final A where NosOfdays =5 AND  a.SQUAREOFF_VALUE>0   and a.tdate=GETDATE()        
   --38303        
           
    /*Inserting t7 data*/        
   select A.* into #T7Data from #final A where NosOfdays =6  AND  a.SQUAREOFF_VALUE>0    and a.tdate=GETDATE()  
         
      insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff      
   select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,'5',GETDATE()      
   FROM #T5data A        
     
   select * into  general.dbo.Tbl_NBFC_Excess_ShortageSqOff_23032015  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff   
   insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff       
   select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,'6',GETDATE()      
   FROM #T6data A        
       
       /*       
   insert into Tbl_NBFC_Excess_ShortageSqOff      
   select region,branch,sb,Client,category,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,'7',GETDATE()      
   FROM #T7Data A     
   */  
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_22022017
-- --------------------------------------------------
            
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_22022017]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
                     
     insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
     from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff                       
                   
                   
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_7days
-- --------------------------------------------------
          
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_7days]                                    
AS                                                
BEGIN                                                 
            
SET NOCOUNT ON            
            
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0            
BEGIN            
                
  declare @ProcDate as datetime                     
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >               
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')              
                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                             
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                             
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                             
                                          
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                               
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                     
  from [ABVSCITRUS].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                           
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                               
  where (a.Logicalledger+a.vahc)<0                                       
                
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                       
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                        
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                        
  from tbl_shortage_10days_hist  a with (nolock)               
  where convert(date,process_date)=convert(date, @ProcDate)                                           
                                   
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'       
                              
                           
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                    
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                          
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                           
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                           
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                          
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                           
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                          
                
                      
  /* GET NBFC CLIENT FROM NRMS-NBFC */                    
                
  select B.party_code,convert(DateTIME,convert(varchar(11),b.RMS_Date)) as RMSDate                                    
  into #tempnbfc                                         
  from  general.dbo.Vw_RmsDtclFi_Collection B                                 
  where  B.co_code = 'nbfc'               
                
  /* GET CLIENT FROM NRMS-LEVERAGE SEGMENT */                                  
                
  SELECT VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date)) as RMSDate1,                                        
  BROKING_NET_LEDGER=Sum(VC.Ledger),                                         
  TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),                                         
  NET_COLLECTION=Sum(VC.Brk_Net)                                         
  INTO   #temp                                         
  FROM   general.dbo.Vw_RmsDtclFi_Collection VC                                         
  WHERE  (vc.co_code='nsefo' or  vc.co_code='mcx' or vc.co_code='ncdex' or vc.co_code='mcd' or vc.co_code='nsx')                                       
  GROUP  BY VC.Party_code,convert(DateTIME,convert(varchar(11),vc.rms_date ))                                    
                                          
  /* GROUP DETAILS OF LEVERAGE SEGMENT FOR NBFC CLIENT */                    
  SELECT A.Party_code,A.RMSDate,                                         
  Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,                                         
  Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,                                         
  Isnull(B.net_collection, 0.0)            AS NET_COLLECTION                 
  INTO   #temp2                                         
  FROM   #tempnbfc A                                         
  LEFT OUTER JOIN #temp B ON A.Party_code = B.party_code and  a.RMSDate=b.RMSDate1                                    
                      
  /* MERGE DETAILS OF NBFC CLIENT */                 
                
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                    
  B.NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                    
  into  #ExcessMargindata              
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A inner join #temp2 B                                     
  on A.backofficecode=B.Party_code               
                                   
  SELECT C.zone,                    
      C.region,                    
      C.branch,                    
      C.sb,                    
      C.backofficecode                AS client,                    
      C.clientcategory,                    
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                    
      C.sbcategory                    AS sbcat,                    
      c.marginshrtexcess,                    
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                    
                  WHEN                    
           t2.net_collection > 0 THEN                    
      c.marginshrtexcess + t2.net_collection                    
      ELSE c.marginshrtexcess                    
      END )),                    
      shortage_after_excess_credit_adj=CASE                    
      WHEN t2.net_collection > 0 THEN                    
      ( c.marginshrtexcess + t2.net_collection )                    
      ELSE c.marginshrtexcess                    
            END,                    
      Sum(( CASE                    
        WHEN CASE                    
         WHEN t2.net_collection > 0 THEN                    
         c.marginshrtexcess + t2.net_collection                    
         ELSE c.marginshrtexcess                    
       END < 0                    
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                    
        Isnull(d.squareoff_value, 0)                    
        ELSE 0                    
      END ) / 1)                squareoff_value,                    
      c.nosofdays,                    
      c.tdate                    
  INTO   #final                    
  FROM   (SELECT *,                 
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                    
           + Substring(tdate, 1, 2) + '/'                    
           + Substring(tdate, 7, 4)) AS tDATE1                    
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                    
    WHERE  nosofdays >= 4 /* or nosofdays =5  or  nosofdays =6  */                    
      )c                    
     INNER JOIN #excessmargindata t2                    
        ON C.backofficecode = t2.backofficecode                    
        AND C.tdate1 + 1 = t2.tdate                    
      LEFT OUTER JOIN (SELECT party_code,                    
            squareoff_value=Sum(sq_qty * clsrate)                    
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(                    
            nolock)                    
        /* seperate process: source NRMS */                    
        GROUP  BY party_code) d                    
       ON C.backofficecode = D.party_code                    
  GROUP  BY C.zone,                    
      C.region,                    
      C.branch,                    
      C.sb,                    
      C.backofficecode,                    
      C.clientcategory,                    
      C.sbcategory,                    
      C.backofficecode,                    
      c.marginshrtexcess,                    
     t2.net_collection,                    
      c.nosofdays,                    
      c.tdate                     
          
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                   
select * from #final where shortage_after_excess_Credit_adj =0          
update tbl_shortage_10days_hist_region           
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj           
from #final b           
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate          
          
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and           
shortage_after_excess_Credit_adj=0 and excess_credit_net=0             
          
update tbl_shortage_10days_hist_region           
set NosOfDays=0           
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0             
                
/* Delete Client if exist in NBFC Risk */                
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                        
                
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where NosOfdays >=4 AND  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                               
                    
  update #TXdata set ActiveEx=                  
  (CASE                   
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                  
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                  
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                  
  else 'N.A.' end)                  
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                  
                    
  update #TXdata set NosOfdays=6  where NosOfdays > 6                            
                          
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                       
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                    
  FROM #TXdata A                            
     
   exec general.dbo.Margin_Shortage_SquareOff_Exception     
                      
  /*                    
     --insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                              
     --select region,branch,sb,Client_Code,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,squareoffaction,GETDATE()                              
     --from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                              
     --delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff where squareoffaction=7                                  
  */                    
END            
ELSE            
BEGIN         
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'            
END            
            
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0            
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                    
ELSE            
Begin            
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'            
End            
             
            
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0            
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                    
ELSE            
bEGIN            
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'            
eND            
SET NOCOUNT OFF            
                                  
                            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_bkp_20180806
-- --------------------------------------------------

            
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_bkp_20180806]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_Bkp06Feb2019
-- --------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_Bkp06Feb2019]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  --update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
  -- from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code
  -- WHERE convert(date,process_date)=convert(date, @ProcDate)

    update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(Amount,0)
   from tbl_shortage_10days_hist t left join general.dbo.tbl_CorporateAction_Data c on t.BACKOFFICECODE=c.party_code
   WHERE convert(date,process_date)=convert(date, @ProcDate)

   /* WHERE convert(date,process_date)=convert(date, @ProcDate) ---> Added ON 25/JAN/2019 after consultation with Siva.K */

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,       
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
 t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 --and MarginShrtExcess < 0      

/* --and MarginShrtExcess < 0   --->   COMMENTED ON 25/JAN/2019 after consultation with Siva.K */         
                
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
  
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
   
   INSERT into tmp_Tbl_NBFC_Excess_ShortageSqOff SELECT * from #final where  shortage_after_excess_credit_adj>-650  
   delete from #final where  shortage_after_excess_credit_adj>-650    
   
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
	                      
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
         
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF                                                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_Bkp09012019
-- --------------------------------------------------
          
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_Bkp09012019]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
   from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_Bkp25Jan2019
-- --------------------------------------------------
          
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_Bkp25Jan2019]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
   from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
  
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
   
   INSERT into tmp_Tbl_NBFC_Excess_ShortageSqOff SELECT * from #final where  shortage_after_excess_credit_adj>-650  
   delete from #final where  shortage_after_excess_credit_adj>-650    
   
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
	                      
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_Bkp26122018
-- --------------------------------------------------

            
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_Bkp26122018]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_Bkp31Jan2019
-- --------------------------------------------------

          
CREATE procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_Bkp31Jan2019]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
   from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code
   WHERE convert(date,process_date)=convert(date, @ProcDate)

   /* WHERE convert(date,process_date)=convert(date, @ProcDate) ---> Added ON 25/JAN/2019 after consultation with Siva.K */

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 --and MarginShrtExcess < 0      

/* --and MarginShrtExcess < 0   --->   COMMENTED ON 25/JAN/2019 after consultation with Siva.K */         
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
  
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
   
   INSERT into tmp_Tbl_NBFC_Excess_ShortageSqOff SELECT * from #final where  shortage_after_excess_credit_adj>-650  
   delete from #final where  shortage_after_excess_credit_adj>-650    
   
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
	                      
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_bkup_21052020
-- --------------------------------------------------
    
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_bkup_21052020]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
  
  exec general.dbo.Check_SettlementMast_BO_NRMS                
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0  
  
  ----------------------------------------------------Corporate value added on 26 Dec 2018-------------------------------------------------------
  
  --update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(corporate_value,0)
  -- from tbl_shortage_10days_hist t left join general.dbo.Corporate_Value c on t.BACKOFFICECODE=c.party_code
  -- WHERE convert(date,process_date)=convert(date, @ProcDate)

    update t set MarginShrtExcess=isnull(MarginShrtExcess,0)+isnull(Amount,0)
   from tbl_shortage_10days_hist t left join general.dbo.tbl_CorporateAction_Data c on t.BACKOFFICECODE=c.party_code
   WHERE convert(date,process_date)=convert(date, @ProcDate)

   /* WHERE convert(date,process_date)=convert(date, @ProcDate) ---> Added ON 25/JAN/2019 after consultation with Siva.K */

-----------------------------------------------------End here-------------------------------------------------------------------------------------                                       
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
           
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
 t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                     
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>-1000 and NosOfDays > 0 --and MarginShrtExcess < 0      

/* --and MarginShrtExcess < 0   --->   COMMENTED ON 25/JAN/2019 after consultation with Siva.K */  

----and shortage_after_excess_Credit_adj>=0  COMMENTED ON 25/JAN/2019 and replaced with shortage_after_excess_Credit_adj>-650 for updating noofdays=0 whose shortage is less than -650 after consultation with Siva.K
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
  delete from #final where client in (select distinct party_code from general.dbo.tbl_projrisk_t1day_data where updt=(select MAX(updt) from general.dbo.tbl_projrisk_t1day_data))                                         
  delete from #final where client in (select distinct party_code from general.dbo.tbl_projrisk_t2day_data where updt=(select MAX(updt) from general.dbo.tbl_projrisk_t2day_data)) 
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
   
   INSERT into tmp_Tbl_NBFC_Excess_ShortageSqOff SELECT * from #final where  shortage_after_excess_credit_adj>-1000  
   delete from #final where  shortage_after_excess_credit_adj>-1000    
   
   ----------------------------------------------------650 cap added on 09 Jan 2019-------------------------------------------------------
	                      
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                    
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
   
  
   select distinct  A.party_code,A.scrip_cd into #temp_NineSeries from general.dbo.excessmargin_squareup_nbfc A inner join  general.dbo.Scrip_master B 
   on A.isin=B.isin  where  B.bsecode like '9%' and sq_qty>0
 
   --select distinct A.client,A.ActiveEx from #TXdata A inner join  #temp_NineSeries B on
   --A.client=B.party_code 
   
   --select * from general.dbo.client_details where party_code in (select party_code from #temp_NineSeries)
                         
  Update #TXdata set ActiveEx='NSE' from #temp_NineSeries B where #TXdata.client=B.party_code
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
  
  DELETE FROM general.dbo.Tbl_NBFC_Excess_ShortageSqOff WHERE Client_Code IN (select DISTINCT party_code from [general].dbo.legalblkclients WITH(NOLOCK))
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception    
                 
  insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
  select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
  from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff with (nolock)                       
                   
                                  
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
         
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF                                                                           
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_10DaysMarginShrtExcess_finalprocess_new_16022017
-- --------------------------------------------------
            
create procedure [dbo].[upd_10DaysMarginShrtExcess_finalprocess_new_16022017]                                   
AS                                                  
BEGIN                                                   
              
SET NOCOUNT ON              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where convert(Date,gendate)=CONVERT(date,getdate())) = 0              
BEGIN              
                  
  declare @ProcDate as datetime                       
  select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >                 
  (select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
                  
  delete from tbl_shortage_10days_hist where convert(date,process_date)=convert(date, @ProcDate)                                               
  DELETE FROM tbl_shortage_10days_hist_region where convert(date,process_date)=convert(date, @ProcDate)                                               
  delete from general.dbo.Tbl_NBFC_Excess_ShortageSqOff  where convert(date,update_date)=convert(date, @ProcDate)                                               
                                            
  insert into tbl_shortage_10days_hist (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date)                                                 
  select b.zone,b.region,b.branch,b.sb,b.category,b.sb_category, a.tdate,a.backofficecode,a.logicalledger,a.pf,a.vahc,(a.Logicalledger+a.vahc) as shortage,@ProcDate                                       
  from [172.31.16.57].inhouse.dbo.nbfc_miles_ledger a with (nolock)                                             
  inner join general.dbo.vw_rms_client_vertical b on a.backofficecode=b.client                                                 
  where (a.Logicalledger+a.vahc)<0                                         
                  
  insert into tbl_shortage_10days_hist_region (Zone,Region,Branch,SB,ClientCategory,SBCategory,TDATE,BACKOFFICECODE,LOGICALLEDGER,HoldingBeforeHaircut,VAHC,MarginShrtExcess,Process_date,NosOfDays)                                         
  select a.zone,a.region,a.branch,a.sb,a.clientcategory,a.sbcategory, a.tdate,a.backofficecode,a.logicalledger,a.holdingbeforehaircut,                                          
  a.vahc,a.marginshrtexcess as shortage,@ProcDate,1                                          
  from tbl_shortage_10days_hist  a with (nolock)                 
  where convert(date,process_date)=convert(date, @ProcDate)                                             
                                     
  exec general.dbo.SQUAREUP_ALERT_UPDATION_NBFC_EXCESSMARGIN_PROCESS 'ALL'         
                                
                             
  /* CALCULATE NO OF DAYS -- FOR BACKDATED DAYS CORRECTION USE: EXEC MSS_DAYSCALCULATION */                      
  UPDATE tbl_shortage_10days_hist_region SET NOSOFDAYS=B.NOSOFDAYS+1 FROM                            
  (SELECT BACKOFFICECODE,NOSOFDAYS FROM tbl_shortage_10days_hist_region WHERE CONVERT(DATE,PROCESS_DATE) =                             
  (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region                             
  WHERE CONVERT(DATE,PROCESS_DATE) < (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region))                            
  ) B WHERE tbl_shortage_10days_hist_region.BACKOFFICECODE=B.BACKOFFICECODE                             
  AND CONVERT(DATE,tbl_shortage_10days_hist_region.PROCESS_DATE)= (SELECT CONVERT(DATE,MAX(PROCESS_DATE)) FROM tbl_shortage_10days_hist_region)                            
                  
		
		SELECT B.party_code,     
		CONVERT(DATETIME, CONVERT(VARCHAR(11), b.rms_date)) AS RMSDate     
		INTO   #tempnbfc     
		FROM   general.dbo.Vw_RmsDtclFi_Collection B     
		WHERE  B.co_code = 'nbfc'  --and party_code='PK87'   
    
		SELECT VC.party_code,     
									CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,     
									BROKING_NET_LEDGER=Sum(VC.ledger),     
									TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),     
									NET_COLLECTION=Sum(VC.brk_net),
									Margin=sum(Imargin)     
		INTO   #temp     
		FROM  general.dbo.Vw_RmsDtclFi_Collection VC     
		WHERE  -- VC.party_code='PK87' and 
												( vc.co_code = 'nsefo'     
												OR vc.co_code = 'mcx'     
												OR vc.co_code = 'ncdex'     
												OR vc.co_code = 'mcd'     
												OR vc.co_code = 'nsx' )    
		GROUP  BY VC.party_code,     
												CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date))     
    
		SELECT A.party_code,     
									A.rmsdate,     
									Isnull(B.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,     
									Isnull(B.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,     
									/* Isnull(B.net_collection, 0.0)         AS NET_COLLECTION */
									(case when B.net_collection<0 then 0 else Isnull(B.net_collection, 0.0) end) AS NET_COLLECTION ,
									B.margin as margin,
									(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) 
									else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)   as net_shortage 
							    
		INTO   #temp2     
		FROM   #tempnbfc A     
									LEFT OUTER JOIN #temp B     
																						ON A.party_code = B.party_code     
																									AND a.rmsdate = b.rmsdate1 
																								/*	where 			(case when B.broking_net_ledger<0 then ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc) else ((B.broking_net_ledger-B.margin)+B.total_collateral_after_hc)end)>0*/
																								/* where B.net_collection>0*/          
	
			                   
  /* MERGE DETAILS OF NBFC CLIENT */                                                                  
  select A.backofficecode, convert(datetime,SUBSTRING(A.tdate,4,2)+'/'+SUBSTRING(A.tdate,1,2)+'/'+SUBSTRING(A.tdate,7,4))+1 AS TDATE,                                      
  B.net_shortage as NET_COLLECTION,b.BROKING_NET_LEDGER,b.TOTAL_COLLATERAL_AFTER_HC                                      
  into #ExcessMargindata                
  from (select backofficecode,tdate from tbl_shortage_10days_hist_region where Process_date>=@ProcDate)A left join #temp2 B                                       
  on A.backofficecode=B.Party_code   
		                                  
  SELECT C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode                AS client,                      
      C.clientcategory,                      
      CONVERT(VARCHAR(10), Space(10)) AS cli_type,                      
      C.sbcategory                    AS sbcat,                      
      c.marginshrtexcess,                      
      excess_credit_net =Abs(c.marginshrtexcess - ( CASE                      
                  WHEN                      
           t2.net_collection > 0 THEN                      
      c.marginshrtexcess + t2.net_collection                      
      ELSE c.marginshrtexcess                      
      END )),                      
      shortage_after_excess_credit_adj=CASE                      
      WHEN t2.net_collection > 0 THEN                      
      ( c.marginshrtexcess + t2.net_collection )                      
      ELSE c.marginshrtexcess                      
            END,                      
      Sum(( CASE                      
        WHEN CASE                      
         WHEN t2.net_collection > 0 THEN                      
         c.marginshrtexcess + t2.net_collection                      
         ELSE c.marginshrtexcess                      
       END < 0                      
       AND Isnull(d.squareoff_value, 0) <> 0 THEN                      
        Isnull(d.squareoff_value, 0)                      
        ELSE 0           
      END ) / 1)                squareoff_value,                      
      c.nosofdays,                      
      c.tdate                      
  INTO  #final                      
  FROM   (SELECT *,                   
        CONVERT(DATETIME, Substring(tdate, 4, 2) + '/'                      
           + Substring(tdate, 1, 2) + '/'                      
           + Substring(tdate, 7, 4)) AS tDATE1                      
    FROM   tbl_shortage_10days_hist_region WITH (nolock)                      
    /* WHERE  nosofdays >= 4 or nosofdays =5  or  nosofdays =6  */                      
      )c                      
     INNER JOIN #excessmargindata t2                      
        ON C.backofficecode = t2.backofficecode                      
        AND C.tdate1 + 1 = t2.tdate                      
      LEFT OUTER JOIN (SELECT party_code,                      
            squareoff_value=Sum(clsrate*sq_qty)                      
        FROM   general.dbo.excessmargin_squareup_nbfc WITH(nolock)          
       /* seperate process: source NRMS */                      
       GROUP  BY party_code) d                      
       ON C.backofficecode = D.party_code                      
  GROUP  BY C.zone,                      
      C.region,                      
      C.branch,                      
      C.sb,                      
      C.backofficecode,                      
      C.clientcategory,                      
      C.sbcategory,                      
      C.backofficecode,                      
      c.marginshrtexcess,                      
      t2.net_collection,                      
      c.nosofdays,                      
      c.tdate                       
            
/* Recalculate No(s) of days with After Excess Credit Adjustments */                                     
           
update tbl_shortage_10days_hist_region             
set excess_credit_net=b.excess_credit_net, shortage_after_excess_Credit_adj=b.shortage_after_excess_Credit_adj             
from #final b             
where tbl_shortage_10days_hist_region.backofficecode=b.client and tbl_shortage_10days_hist_region.tdate=b.tdate            
         
update tbl_shortage_10days_hist_region set shortage_after_excess_Credit_adj=MarginShrtExcess where process_date =@ProcDate  and             
shortage_after_excess_Credit_adj=0 and excess_credit_net=0               
            
update tbl_shortage_10days_hist_region             
set NosOfDays=0             
where process_date =@ProcDate  and shortage_after_excess_Credit_adj>=0 and NosOfDays > 0 and MarginShrtExcess < 0               
                  
/* Delete Client if exist in NBFC Risk */                  
  /*delete from #final where client in (select [client code] from general.dbo.squareup_client_alert_nbfc where updt=(select max(updt) from general.dbo.squareup_client_alert_nbfc))  */  
  delete from #final where client in (select party_Code from general.dbo.squareup_client_nbfc where updt=(select max(updt) from general.dbo.squareup_client_nbfc))                                          
                  
  select A.*,ActiveEx='N.A.'  into  #TXdata from #final A where /*NosOfdays >=4 AND*/  a.SQUAREOFF_VALUE>0  /* and a.tdate=convert(varchar,GETDATE()-1,105) */                                 
                      
  update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')   
  
   update #TXdata set ActiveEx=                    
  (CASE                     
  when b.bsecm='Y' and b.nsecm='Y' then 'BOTH'                    
  when b.bsecm='Y' and b.nsecm='N' then 'BSE'                    
  when b.bsecm='N' and b.nsecm='Y' then 'NSE'                    
  else 'N.A.' end)                    
  from general.dbo.client_Details b where #TXdata.client=b.party_code and (b.bsecm='Y' or b.nsecm='Y')                   
                      
  update #TXdata set NosOfdays=6  where NosOfdays > 6                              
  update #TXdata set cli_type=general.dbo.vw_rms_client_vertical.Cli_Type from  general.dbo.vw_rms_client_vertical where #TXdata.client=general.dbo.vw_rms_client_vertical.Client                 
                            
  insert into general.dbo.Tbl_NBFC_Excess_ShortageSqOff                                         
  select region,branch,sb,Client,clientcategory,CLI_TYPE,SBCAT,MarginShrtExcess,Excess_Credit_Net,Shortage_After_Excess_Credit_Adj,SQUAREOFF_VALUE,NosOfdays+1,@ProcDate,ActiveEx,''                                      
  FROM #TXdata A                              
       
  exec general.dbo.Margin_Shortage_SquareOff_Exception       
                        
                     
     insert into history.dbo.Tbl_NBFC_Excess_ShortageSqOff_hist                                
     select region,branch,sb,Client_Code,category,client_type,sb_category,margin_shortage,Excess_Credit_Of_Other_Segments,Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,squareoffaction,GETDATE()                                
     from  general.dbo.Tbl_NBFC_Excess_ShortageSqOff                       
                   
                   
END              
ELSE              
BEGIN           
 Print 'NBFC Margin Shortage Squareoff file Generated for the day. Cannot Process.'              
END              
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=1 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_BSE_NBFC_MarginShortage                      
ELSE              
Begin              
 Print 'NBFC Margin Shortage Squareoff file generation for BSE already processed for the day. Cannot Process.'              
End              
               
              
IF (select count(1) from GENERAL.DBO.MSS_FileGenDate where genid=2 and convert(Date,gendate)=CONVERT(date,getdate())) = 0              
 EXEC general.dbo.MSS_NSE_NBFC_MarginShortage                      
ELSE              
bEGIN              
 Print 'NBFC Margin Shortage Squareoff file generation for NSE already processed for the day. Cannot Process.'              
eND              
SET NOCOUNT OFF              
                                    
                              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_ABL_ACBPL_HISTORY
-- --------------------------------------------------

CREATE PROC [dbo].[UPD_ABL_ACBPL_HISTORY]
AS
Begin
Set nocount on                                                  
BEGIN TRY       

DELETE FROM TBL_RMS_COLLECTION_CLI_ABL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_CLI_ACBPL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_SB_ABL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_SB_ACBPL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

/* ABL HISTORY */

INSERT INTO TBL_RMS_COLLECTION_CLI_ABL_HIST
(
Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit, Net_Debit,
Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger, MCX_Ledger,
NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor, Hold_Junk, Hold_Total,
Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX, Coll_Total, Coll_TotalHC,
Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross, Margin_NSEFO, Margin_BSEFO,
Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage, Margin_Violation, MOS, Pure_Risk,
SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss, CashColl_Total, Debit_Days,
Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection, Gross_Collection_Perc, Risk_Inc_Dec,
Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, RMS_DATE,BSX_Ledger,Coll_BSX,Exp_BSX,Margin_BSX
)
SELECT Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit,
Net_Debit, Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger,
MCX_Ledger, NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor,
Hold_Junk, Hold_Total, Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX,
Coll_Total, Coll_TotalHC, Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross,
Margin_NSEFO, Margin_BSEFO, Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage,
Margin_Violation, MOS, Pure_Risk, SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss,
CashColl_Total, Debit_Days, Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection,
Gross_Collection_Perc, Risk_Inc_Dec, Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, GETDATE(),BSX_Ledger,Coll_BSX,Exp_BSX,Margin_BSX
FROM GENERAL.DBO.TBL_RMS_COLLECTION_CLI_ABL WITH (NOLOCK)
--WHERE REPORT_TYPE = 'R'


INSERT INTO TBL_RMS_COLLECTION_SB_ABL_HIST
([zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,[RMS_DATE])
SELECT [zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_SB_ABL WITH (NOLOCK)

/* ACBPL HISTORY */

INSERT INTO TBL_RMS_COLLECTION_CLI_ACBPL_HIST
(
Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit, Net_Debit,
Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger, MCX_Ledger,
NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor, Hold_Junk, Hold_Total,
Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX, Coll_Total, Coll_TotalHC,
Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross, Margin_NSEFO, Margin_BSEFO,
Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage, Margin_Violation, MOS, Pure_Risk,
SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss, CashColl_Total, Debit_Days,
Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection, Gross_Collection_Perc, Risk_Inc_Dec,
Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, RMS_DATE,BSX_Ledger,Coll_BSX,Exp_BSX,Margin_BSX
)
SELECT Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit,
Net_Debit, Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger,
MCX_Ledger, NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor,
Hold_Junk, Hold_Total, Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX,
Coll_Total, Coll_TotalHC, Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross,
Margin_NSEFO, Margin_BSEFO, Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage,
Margin_Violation, MOS, Pure_Risk, SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss,
CashColl_Total, Debit_Days, Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection,
Gross_Collection_Perc, Risk_Inc_Dec, Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, GETDATE(),BSX_Ledger,Coll_BSX,Exp_BSX,Margin_BSX
FROM GENERAL.DBO.TBL_RMS_COLLECTION_CLI_ACBPL WITH (NOLOCK)
--WHERE REPORT_TYPE = 'R'

INSERT INTO TBL_RMS_COLLECTION_SB_ACBPL_HIST
([zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,[RMS_DATE])
SELECT [zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_SB_ACBPL WITH (NOLOCK)

END TRY      
BEGIN CATCH      
	INSERT INTO EODBODDetail_Error (ErrTime, ErrObject, ErrLine, ErrMessage)      
	SELECT GETDATE(), 'UPD_ABL_ACBPL_HISTORY', ERROR_LINE(), ERROR_MESSAGE()      
	DECLARE @ErrorMessage NVARCHAR(4000);      
	SELECT @ErrorMessage = ERROR_MESSAGE() + convert(VARCHAR(10), error_line());      
	RAISERROR (@ErrorMessage, 16, 1);      
END CATCH;                  

Set nocount off 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_ABL_ACBPL_HISTORY_13012017
-- --------------------------------------------------

create PROC [dbo].[UPD_ABL_ACBPL_HISTORY_13012017]
AS
Begin
Set nocount on                                                  
BEGIN TRY       

DELETE FROM TBL_RMS_COLLECTION_CLI_ABL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_CLI_ACBPL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_SB_ABL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

DELETE FROM TBL_RMS_COLLECTION_SB_ACBPL_HIST
WHERE RMS_DATE BETWEEN CONVERT(VARCHAR(11), GETDATE(), 106) + ' 00:00.000' AND CONVERT(VARCHAR(11), GETDATE(), 106) + ' 23:59:59'

/* ABL HISTORY */

INSERT INTO TBL_RMS_COLLECTION_CLI_ABL_HIST
(
Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit, Net_Debit,
Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger, MCX_Ledger,
NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor, Hold_Junk, Hold_Total,
Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX, Coll_Total, Coll_TotalHC,
Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross, Margin_NSEFO, Margin_BSEFO,
Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage, Margin_Violation, MOS, Pure_Risk,
SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss, CashColl_Total, Debit_Days,
Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection, Gross_Collection_Perc, Risk_Inc_Dec,
Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, RMS_DATE
)
SELECT Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit,
Net_Debit, Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger,
MCX_Ledger, NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor,
Hold_Junk, Hold_Total, Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX,
Coll_Total, Coll_TotalHC, Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross,
Margin_NSEFO, Margin_BSEFO, Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage,
Margin_Violation, MOS, Pure_Risk, SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss,
CashColl_Total, Debit_Days, Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection,
Gross_Collection_Perc, Risk_Inc_Dec, Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_CLI_ABL WITH (NOLOCK)
--WHERE REPORT_TYPE = 'R'


INSERT INTO TBL_RMS_COLLECTION_SB_ABL_HIST
([zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,[RMS_DATE])
SELECT [zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_SB_ABL WITH (NOLOCK)

/* ACBPL HISTORY */

INSERT INTO TBL_RMS_COLLECTION_CLI_ACBPL_HIST
(
Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit, Net_Debit,
Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger, MCX_Ledger,
NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor, Hold_Junk, Hold_Total,
Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX, Coll_Total, Coll_TotalHC,
Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross, Margin_NSEFO, Margin_BSEFO,
Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage, Margin_Violation, MOS, Pure_Risk,
SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss, CashColl_Total, Debit_Days,
Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection, Gross_Collection_Perc, Risk_Inc_Dec,
Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, RMS_DATE
)
SELECT Party_Code, Cash, Derivatives, Currency, Commodities, DP, NBFC, ABL_Net, ACBL_Net, NBFC_Net, Deposit,
Net_Debit, Net_Available, BSE_Ledger, NSE_Ledger, NSEFO_Ledger, BSEFO_Ledger, MCD_Ledger, NSX_Ledger,
MCX_Ledger, NCDEX_Ledger, NBFC_Ledger, Net_Ledger, UnReco_Credit, Hold_BlueChip, Hold_Good, Hold_Poor,
Hold_Junk, Hold_Total, Hold_TotalHC, Coll_NSEFO, Coll_BSEFO, Coll_MCD, Coll_NSX, Coll_MCX, Coll_NCDEX,
Coll_Total, Coll_TotalHC, Exp_NSEFO, Exp_BSEFO, Exp_MCD, Exp_NSX, Exp_MCX, Exp_NCDEX, Exp_Cash, Exp_Gross,
Margin_NSEFO, Margin_BSEFO, Margin_MCD, Margin_NSX, Margin_MCX, Margin_NCDEX, Margin_Total, Margin_Shortage,
Margin_Violation, MOS, Pure_Risk, SB_CrAdjwithPureRisk, Proj_Risk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted, UB_Loss,
CashColl_Total, Debit_Days, Last_Bill_Date, Report_Type, RiskCategory, Net_Collection, Gross_Collection,
Gross_Collection_Perc, Risk_Inc_Dec, Risk_Inc_Dec_Perc, Pure_Net_Collection, Proj_Net_Collection, GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_CLI_ACBPL WITH (NOLOCK)
--WHERE REPORT_TYPE = 'R'

INSERT INTO TBL_RMS_COLLECTION_SB_ACBPL_HIST
([zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,[RMS_DATE])
SELECT [zone] ,[region] ,[Branch_cd] ,[Sub_Broker] ,[cli_category] ,[cli_Priorities] ,[cli_count] ,[cli_RiskCategoryCode]
 ,[Cash] ,[Derivatives] ,[Currency] ,[Commodities] ,[DP] ,[NBFC] ,[Deposit] ,[Net] ,[App.Holding] ,[Non-App.Holding]
 ,[Holding] ,[SB Balance] ,[ProjRisk] ,[PureRisk] ,[MOS] ,[UnbookedLoss] ,[IMargin] ,[Total_Colleteral]
 ,[Margin_Shortage] ,[Un_Reco] ,[Exposure] ,[PureAdj] ,[ProjAdj] ,[SB_Category] ,[SB_MOS] ,[SB_Type]
 ,[SB_ROI] ,[SB_Credit] ,[SB_ClientCount] ,[Exp_Gross] ,[Report_Type] ,[DrCr] ,[Tot_LegalRisk]
 ,[SB_CrAdjWithLegal] ,[SB_CrAfterAdjLegal] ,[SB_LegalRisk] ,[Tot_PureRisk] ,[SB_CrAdjWithPureRisk]
 ,[SB_CrAfterAdjPureRisk] ,[SB_PureRisk] ,[Tot_ClientRisk] ,[Tot_SBRisk] ,[Tot_ProjRisk] ,[SB_CrAdjWithProjRisk]
 ,[SB_CrAfterAdjProjRisk] ,[SB_ProjRisk] ,[SB_CrAdjusted] ,[SB_BalanceCr] ,[Cli_Percent] ,[Net_Collection]
 ,[Gross_Collection] ,[Gross_Collection_perc] ,[Risk_Inc_Dec] ,[Risk_Inc_Dec_Perc] ,[Pure_Net_Collection]
 ,[Proj_Net_Collection] ,[br_credit] ,[BR_CrAdjusted] ,GETDATE()
FROM GENERAL.DBO.TBL_RMS_COLLECTION_SB_ACBPL WITH (NOLOCK)

END TRY      
BEGIN CATCH      
	INSERT INTO EODBODDetail_Error (ErrTime, ErrObject, ErrLine, ErrMessage)      
	SELECT GETDATE(), 'UPD_ABL_ACBPL_HISTORY', ERROR_LINE(), ERROR_MESSAGE()      
	DECLARE @ErrorMessage NVARCHAR(4000);      
	SELECT @ErrorMessage = ERROR_MESSAGE() + convert(VARCHAR(10), error_line());      
	RAISERROR (@ErrorMessage, 16, 1);      
END CATCH;                  

Set nocount off 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_History
-- --------------------------------------------------

create procedure Upd_History
as  
insert into history.dbo.RMS_DtclFi_summ select * from RMS_DtclFi_summ
insert into history.dbo.RMS_DtclFi select * from RMS_DtclFi
insert into history.dbo.RMS_DtSBFi select * from RMS_DtSBFi
insert into history.dbo.RMS_DtBrFi select * from RMS_DtBrFi

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_ALL
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UPD_HISTORY_ALL] 
as                          
BEGIN                          
     
SET NOCOUNT ON   
SET XACT_ABORT ON   
BEGIN TRY 


 DELETE FROM TBL_RMS_COLLECTION_CLIENT_HIST WHERE  RMS_DATE= convert(varchar(12), GETDATE())    
 DELETE FROM tbl_RMS_collection_SB_Hist WHERE  RMS_DATE= convert(varchar(12), GETDATE())
 DELETE FROM [tbl_RMS_collection_BRANCH_Hist] WHERE  RMS_DATE= convert(varchar(12), GETDATE())
 DELETE FROM [tbl_RMS_collection_region_Hist] WHERE  RMS_DATE= convert(varchar(12), GETDATE())
 DELETE FROM ORMS_SB_DEPOSIT_hist WHERE  RMS_DATE= convert(varchar(12), GETDATE())
 DELETE FROM CLIENT_COLLATERALS_HIST WHERE  RMS_DATE= convert(varchar(12), GETDATE())
  
   
 Declare @CurDate datetime                                                          
 Declare @PrevDate datetime                                                              
 SET @CurDate = convert(varchar(12), GETDATE())                                                          
 set @PrevDate = convert(varchar(11),getdate()-1)                                                              
     
 --select * into general.dbo.Vw_RMS_CLIENT_Vertical from general.dbo.Vw_RMS_CLIENT_Vertical      
 --select * into general.dbo.tbl_RMS_collection_CLI from general.dbo.tbl_RMS_collection_CLI 
 
 
  
    
 insert into TBL_RMS_COLLECTION_CLIENT_HIST                                                                    
 (Zone,Region,RegionName,Branch,BranchName,SB,SB_Name,Client,Party_name,Category,RiskCategoryCode,                                                                    
 Priorities,DrNoOfDays,Debit_Priorities,Classification,Cli_Type,SB_Category,Cash,Derivatives,Currency,                                                                    
 Commodities,DP,NBFC,ABL_Net,ACBL_Net,NBFC_Net,Deposit,Net_Debit,Net_Available,BSE_Ledger,NSE_Ledger,                                                                    
 NSEFO_Ledger,MCD_Ledger,NSX_Ledger,MCX_Ledger,NCDEX_Ledger,NBFC_Ledger,Net_Ledger,UnReco_Credit,Hold_BlueChip,                                                                    
 Hold_Good,Hold_Poor,Hold_Junk,Hold_Total,Hold_TotalHC,Coll_NSEFO,Coll_MCD,Coll_NSX,Coll_MCX,Coll_NCDEX,                                                                    
 Coll_Total,Coll_TotalHC,Exp_NSEFO,Exp_MCD,Exp_NSX,Exp_MCX,Exp_NCDEX,Exp_Cash,Exp_Gross,Margin_NSEFO,                                                                    
 Margin_MCD,Margin_NSX,Margin_MCX,Margin_NCDEX,Margin_Total,Margin_Shortage,Margin_Violation,MOS,Pure_Risk,                                                                    
 SB_CrAdjwithPureRisk,Proj_Risk,SB_CrAdjwithProjRisk,SB_Cr_Adjusted,UB_Loss,CashColl_Total,Debit_Days,                                                                    
 Last_Bill_Date,Report_Type,RiskCategory,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                                                  
 Risk_Inc_Dec,RMS_DATE)          
 select A.Zone,A.Region,A.RegionName,A.Branch,A.BranchName,A.SB,A.SB_Name,A.Client,          
 A.Party_name,A.Category,A.RiskCategoryCode,A.Priorities,A.DrNoOfDays,A.Debit_Priorities,          
 A.Classification,A.Cli_Type,A.SB_Category,B.Cash,B.Derivatives,B.Currency,B.Commodities          
 ,B.DP,B.NBFC,B.ABL_Net,B.ACBL_Net,B.NBFC_Net,B.Deposit,B.Net_Debit,B.Net_Available,                                                                    
 B.BSE_Ledger,B.NSE_Ledger,B.NSEFO_Ledger,B.MCD_Ledger,B.NSX_Ledger,B.MCX_Ledger,B.NCDEX_Ledger                                                                    
 ,B.NBFC_Ledger,B.Net_Ledger,B.UnReco_Credit,B.Hold_BlueChip,B.Hold_Good,B.Hold_Poor,B.Hold_Junk                                                                    
 ,B.Hold_Total,B.Hold_TotalHC,B.Coll_NSEFO,B.Coll_MCD,B.Coll_NSX,B.Coll_MCX,B.Coll_NCDEX,B.Coll_Total                                                                    
 ,B.Coll_TotalHC,B.Exp_NSEFO,B.Exp_MCD,B.Exp_NSX,B.Exp_MCX,B.Exp_NCDEX,B.Exp_Cash,B.Exp_Gross                                                                    
 ,B.Margin_NSEFO,B.Margin_MCD,B.Margin_NSX,B.Margin_MCX,B.Margin_NCDEX,B.Margin_Total,B.Margin_Shortage                                                                    
 ,B.Margin_Violation,B.MOS,B.Pure_Risk,B.SB_CrAdjwithPureRisk,B.Proj_Risk,B.SB_CrAdjwithProjRisk                                                                    
 ,B.SB_Cr_Adjusted,B.UB_Loss,B.CashColl_Total,B.Debit_Days,B.Last_Bill_Date,B.Report_Type,B.RiskCategory,                             
 B.Net_Collection,B.Gross_Collection,B.Pure_Net_Collection,B.Proj_Net_Collection,B.Risk_Inc_Dec,@CurDate                   
 FROM general.dbo.Vw_RMS_CLIENT_Vertical a (nolock)     
 inner join general.dbo.tbl_RMS_collection_CLI b (nolock) on  a.Client=b.PARTY_CODE                                
                                                 
 --update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                         
 --Risk_Inc_Dec=A.Risk_Inc_Dec from                                    
 --(select party_code,Risk_Inc_Dec from general.dbo.tbl_RMS_collection_CLI (nolock)) A                                      
 --where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.PARTY_CODE and  RMS_DATE=@CurDate                                        
                     
 update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                         
 Risk_Inc_Dec_perc=((Risk_Inc_Dec/A.Pure_Risk)*100) from                                  
 (select CLIENT,Pure_Risk from TBL_RMS_COLLECTION_CLIENT_HIST (nolock) where rms_date = @PrevDate  and Pure_Risk<>0) A                                      
 where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.CLIENT and  RMS_DATE=@CurDate                                        
                                                             
 update TBL_RMS_COLLECTION_CLIENT_HIST SET                                                 
 Gross_Collection_Perc=((Gross_Collection/Net_debit)*100)                                                                  
 where RMS_Date = @CurDate              and Net_debit <> 0                                                          
     
 -----------------------------------------------END OF INSERTIONS-----------------------------------                                                                                                              
     
 insert into tbl_RMS_collection_SB_Hist                                                                    
 (zone,region,Branch_cd,Sub_Broker,RegionName,BranchName,SB_Name,NoOfClients,ParentTag,BrType,BrCategory,                                                                     
 SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                    
 Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                    
 IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                    
 SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                     
 SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                    
 Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                     
 SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                                  
 Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec , RMS_DATE,br_credit,BR_CrAdjusted)                                                                    
 select MAX(b.zone) as zone,MAX(b.region) as region,MAX(Branch_cd) as Branch_cd,Sub_Broker as Sub_Broker,                                                                    
 MAX(RegionName) AS RegionName,MAX(BranchName) AS BranchName,MAX(SB_Name) AS SB_Name,                                                                    
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                    
 MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,   
 sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,              
 SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                    
 SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,        
 SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                        
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                    
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                
 MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                      
 Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                              
 MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                    
 MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                    
 MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                    
 MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                    
 MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                         
 MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                                    
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,    
 MAX(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate as RMS_DATE,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted    
 from                      
 general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON  a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                    
 group by Sub_Broker,Report_Type                                                    
     
 select                                                                     
  A.SB,                                                                    
  Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                    
  sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                    
  sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(BSX_Ledger) as BSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                        
  sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                    
  sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                    
 into #temp1    
 FROM general.dbo.Vw_RMS_CLIENT_Vertical (nolock) A              
  INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                    
  GROUP BY A.SB,B.Report_Type          
                                                 
 update [tbl_RMS_collection_SB_Hist] set                              
 BSE_Ledger=A.BSE_Ledger,                                     
 NSE_Ledger=A.NSE_Ledger,                                                                    
 NSEFO_Ledger=A.NSEFO_Ledger,                                                                    
 MCD_Ledger=A.MCD_Ledger,                                                             
 NSX_Ledger=A.NSX_Ledger,
 BSX_Ledger=A.BSX_Ledger,                                                                     
 MCX_Ledger=A.MCX_Ledger,                                                                    
 NCDEX_Ledger=A.NCDEX_Ledger,                                                                    
 NBFC_Ledger=A.NBFC_Ledger,                                                                    
 Hold_BlueChip=A.Hold_BlueChip,                                                                    
 Hold_Good=A.Hold_Good,                                                        
 Hold_Poor=A.Hold_Poor,                                                                    
 Hold_Junk=A.Hold_Junk                                                                    
 FROM(                                                                    
  select * from #temp1)A                                                           
 where                                      
  tbl_RMS_collection_SB_Hist.Sub_Broker=A.SB and tbl_RMS_collection_SB_Hist.Report_Type=A.Report_Type and                                                                    
  RMS_DATE=@CurDate                                      
                                                               
 update tbl_RMS_collection_SB_Hist SET                                                                   
 Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                                
 where RMS_DATE=@CurDate and Net <>0                                                               
     
 drop table #temp1          
     
 --update TBL_RMS_COLLECTION_SB_HIST SET                                         
 --Risk_Inc_Dec=A.Risk_Inc_Dec from                                       
 --(select Sub_Broker,SUM(Risk_Inc_Dec) as Risk_Inc_Dec from general.dbo.tbl_RMS_collection_SB group by Sub_Broker) A                                      
 --where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                      
 --AND RMS_DATE=@CurDate                                          
     
 update TBL_RMS_COLLECTION_SB_HIST SET                    
 Risk_Inc_Dec= (Tot_SBRisk*-1)                    
 where RMS_DATE=@CurDate                    
 and Report_Type = 'R'                    
     
 update TBL_RMS_COLLECTION_SB_HIST SET                    
 Risk_Inc_Dec= (TBL_RMS_COLLECTION_SB_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                    
 (select Sub_Broker,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST where rms_date = @PrevDate and Report_Type = 'R' group by Sub_Broker) A                    
 where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                      
 AND RMS_DATE=@CurDate                       
 and Report_Type = 'R'                    
     
 update TBL_RMS_COLLECTION_SB_HIST  SET                                         
 Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                       
 (select Sub_Broker,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST                                     
  where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R'                                     
 group by Sub_Broker) A                                      
 where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate         
 and Report_Type = 'R'                    
     
 --update TBL_RMS_COLLECTION_SB_HIST  SET                                         
 --Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                       
 --(select Sub_Broker,MAX(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_SB_HIST       
 -- where rms_date = @PrevDate  and Tot_ClientRisk<>0                                    
 --group by Sub_Broker) A                                      
 --where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate                                      
     
 -------------------------------------------------------END OF SB HIST------------------------------------------------                                            
     
 insert into [tbl_RMS_collection_BRANCH_Hist]                                                                    
 (zone,region,Branch_cd,RegionName,BranchName,NoOfClients,ParentTag,BrType,BrCategory,                                                                     
 SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                
 Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                    
 IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                       
 SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                     
 SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                    
 Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                     
 SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                              
 Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                             
 select MAX(zone) as zone,MAX(region) as region,Branch_cd,                                                                    
 MAX(RegionName) AS RegionName,BranchName,                                                                    
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                               
 MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                    
 sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                    
 SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                    
 SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                    
 SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                    
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                    
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                
 SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                           
 Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                    
 SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                               
 SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,              
 SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                    
 SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                                                                    
 SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                    
 SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                                    
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                             
 SUM(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted FROM (                                                              
                           
 select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                                 
 MAX(RegionName) AS RegionName,BranchName,                        
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                    
 MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                    
 sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                 
 SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                    
 SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                    
 SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                  
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                    
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                    
 MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                    
 Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                    
 MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                    
 MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                    
 MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                        
 MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                    
 MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                    
 MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,         
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                    
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                    
 MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted    
 from                                                                     
 general.dbo.Vw_RMS_SB_Vertical a  (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                               
 where (Report_Type <>'R' )                
 group by a.Region,Branch_cd,a.BranchName,SB,Report_Type                                                              
                           
 union all                          
                           
 select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                                 
 MAX(RegionName) AS RegionName,BranchName,                                                                    
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                   
 MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                    
 sum(cli_count) as cli_count,                
 SUM(case when Report_Type = 'R' then Cash else 0 end ) as Cash,                
 SUM(case when Report_Type = 'R' then Derivatives else 0 end ) as Derivatives,                       
 SUM(case when Report_Type = 'R' then Currency else 0 end ) as Currency,                
 SUM(case when Report_Type = 'R' then Commodities else 0 end ) as Commodities,SUM(DP) as DP,                                                                    
 SUM(case when Report_Type = 'R' then NBFC else 0 end ) as NBFC,                
 SUM(case when Report_Type = 'R' then Deposit else 0 end ) as Deposit,                
 SUM(case when Report_Type = 'R' then Net else 0 end ) as Net,                                                                    
 SUM(case when Report_Type = 'R' then [App.Holding] else 0 end ) as [App.Holding],                
 SUM(case when Report_Type = 'R' then [Non-App.Holding] else 0 end ) as [Non-App.Holding],                
 SUM(case when Report_Type = 'R' then Holding else 0 end ) as Holding,                                                                    
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                        
 MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                    
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,     
 MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                    
 'R' Report_Type ,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                    
 MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                    
 MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                    
 MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                    
 MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                             
 MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                       
 MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                                
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                    
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                    
 MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted    
 from                                                                     
 general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                          
 where (Report_Type ='R' OR Report_Type = 'L')                           
 group by a.Region,Branch_cd,a.BranchName,SB                          
 )r                                                              
 group by r.BrType,r.Region,r.Branch_cd,r.BranchName,Report_Type                                                               
            
           
 select                                                                     
  A.BRANCH,                                                  
  Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                    
  sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                    
  sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(BSX_Ledger) as BSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                    
  sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                    
  sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                    
           
 into #temp2           
            
 FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                     
  INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                       
  GROUP BY A.BRANCH,B.Report_Type          
           
                                                                    
 update [tbl_RMS_collection_BRANCH_Hist] set                                                                     
 BSE_Ledger=A.BSE_Ledger,                                              
 NSE_Ledger=A.NSE_Ledger,                                                                    
 NSEFO_Ledger=A.NSEFO_Ledger,                                                         
 MCD_Ledger=A.MCD_Ledger,                                                                    
 NSX_Ledger=A.NSX_Ledger,
 BSX_Ledger=A.BSX_Ledger,                                                              
 MCX_Ledger=A.MCX_Ledger,                           
 NCDEX_Ledger=A.NCDEX_Ledger,                                                                 
 NBFC_Ledger=A.NBFC_Ledger,                                                                 
 Hold_BlueChip=A.Hold_BlueChip,                                                                    
 Hold_Good=A.Hold_Good,                                                                    
 Hold_Poor=A.Hold_Poor,                                                                    
 Hold_Junk=A.Hold_Junk                                              
 FROM(                                                   
  select * from #temp2 )A                                                           
 where                                                 
 [tbl_RMS_collection_BRANCH_Hist].Branch_cd=A.BRANCH and [tbl_RMS_collection_BRANCH_Hist].Report_Type=A.Report_Type                                          
 AND RMS_DATE=@CurDate                                                          
                                                               
 update TBL_RMS_COLLECTION_BRANCH_HIST SET                                                     
 Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                                  
 where Net <>0 AND                                                               
  RMS_DATE=@CurDate               
           
           
 drop table #temp2                                                     
           
 --update [TBL_RMS_COLLECTION_BRANCH_HIST]  SET                                       
 --Risk_Inc_Dec=A.Risk_Inc_Dec from                                       
 --(                                      
 --select Branch_cd,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by Branch_cd) A where                                       
 --[TBL_RMS_COLLECTION_BRANCH_HIST].Branch_cd=A.Branch_cd                                      
 --AND RMS_DATE=@CurDate                                          
                     
                     
 update TBL_RMS_COLLECTION_BRANCH_HIST SET                     
 Risk_Inc_Dec= (Tot_SBRisk*-1)                    
 where RMS_DATE=@CurDate               
 and Report_Type = 'R'                    
                     
 update TBL_RMS_COLLECTION_BRANCH_HIST SET                    
 Risk_Inc_Dec= (TBL_RMS_COLLECTION_BRANCH_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                    
 (select BRANCH_CD,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST where rms_date = @PrevDate and Report_Type = 'R' group by BRANCH_CD) A                    
 where TBL_RMS_COLLECTION_BRANCH_HIST.BRANCH_CD=A.BRANCH_CD                                      
 AND RMS_DATE=@CurDate                     
 and Report_Type = 'R'                    
                                       
                                       
 update TBL_RMS_COLLECTION_BRANCH_HIST  SET                                         
 Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                        
 (select Branch_cd,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST                                      
   where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by Branch_cd) A                                      
 where TBL_RMS_COLLECTION_BRANCH_HIST.Branch_cd=A.Branch_cd AND  RMS_DATE=@CurDate                                      
 and Report_Type = 'R'                                                
                     
 -------------------------------------------------------END OF BRANCH HIST------------------------------------------------                                                                    
 insert into [tbl_RMS_collection_region_Hist]                                                                    
 (zone,region,RegionName,NoOfClients,ParentTag,BrType,BrCategory,                                                                     
 SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                    
 Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                
                                                         
 IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                    
 SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                           
 SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                 
 Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                              
 SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                        
 Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                                      
 SELECT R.Zone,                                                                
 R.region,                                                               
 R.RegionName,                                             
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                       
 MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                    
 sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                    
 SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                    
 SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                    
 SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                        
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                       
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                                                                    
 SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                    
 Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                    
 SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                                                    
 SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                    
 SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                    
 SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                        
 SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                    
 SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                  
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                              
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                    
 SUM(Risk_Inc_Dec) as Risk_Inc_Dec, @CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted  From                                                       
 (                                                              
 select MAX(b.zone) as zone,a.region,                                                                    
 a.RegionName AS RegionName,                                                     
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                               
 MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                         
 sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                    
 SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                    
 SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,
 SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                    
 SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                   
 SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                    
 MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                    
 Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                    
 MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                    
 MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                             
 MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                    
 MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                    
 MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                    
 MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                  
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                     
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                    
 MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted    
 from                                                                     
 general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                   
 where Report_Type <> 'R'                      
 group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB,Report_Type                              
                               
 union all                              
                               
 select MAX(b.zone) as zone,a.region,                                 
 a.RegionName AS RegionName,                                                                    
 MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                    
 MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                    
 sum(cli_count) as cli_count,                
 SUM(case when Report_Type = 'R' then Cash else 0 end) as Cash,                
 SUM(case when Report_Type = 'R' then Derivatives else 0 end) as Derivatives,           
 SUM(case when Report_Type = 'R' then Currency  else 0 end) as Currency,                
 SUM(case when Report_Type = 'R' then Commodities  else 0 end) as Commodities,SUM(DP) as DP,                                                                    
 SUM(case when Report_Type = 'R' then NBFC  else 0 end) as NBFC,                
 SUM(case when Report_Type = 'R' then Deposit  else 0 end) as Deposit,                
 SUM(case when Report_Type = 'R' then Net else 0 end) as Net,                
 SUM(case when Report_Type = 'R' then [App.Holding]  else 0 end) as [App.Holding],                
 SUM(case when Report_Type = 'R' then [Non-App.Holding]  else 0 end) as [Non-App.Holding],                
 SUM(case when Report_Type = 'R' then Holding else 0 end) as Holding,                
 SUM(case when Report_Type = 'R' then [SB Balance]  else 0 end) as [SB Balance],                
 SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                    
 MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                    
 SUM(case when Report_Type = 'R' then Total_Colleteral  else 0 end) as Total_Colleteral,                
 SUM(case when Report_Type = 'R' then Margin_Shortage  else 0 end) as Margin_Shortage,                                                                    
 SUM(Un_Reco) as Un_Reco,                
 SUM(case when Report_Type = 'R' then Exposure else 0 end) as Exposure,                
 SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                    
 MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                    
 MAX(case when Report_Type = 'R' then SB_Credit  else 0 end) as SB_Credit,                
 MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                    
 'R' Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                           
 MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                          
 MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                             
 MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                    
 MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                    
 MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                    
 MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                           
 SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                    
 SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                    
 MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted    
 from                              
 general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                              
 where (Report_Type = 'R' OR Report_Type = 'L')                      
 group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB     
 )r                                                              
  group by r.Zone,r.Region,r.RegionName,Report_Type                                          
     
 update [tbl_RMS_collection_region_Hist] set                                       
 BSE_Ledger=A.BSE_Ledger,                
 NSE_Ledger=A.NSE_Ledger,                                                                    
 NSEFO_Ledger=A.NSEFO_Ledger,                                                                    
 MCD_Ledger=A.MCD_Ledger,                                                                    
 NSX_Ledger=A.NSX_Ledger,   
 BSX_Ledger=A.BSX_Ledger,                                                                 
 MCX_Ledger=A.MCX_Ledger,                                                                    
 NCDEX_Ledger=A.NCDEX_Ledger,                                                                    
 NBFC_Ledger=A.NBFC_Ledger,                                                                    
 Hold_BlueChip=A.Hold_BlueChip,                                                                    
 Hold_Good=A.Hold_Good,                                                                    
 Hold_Poor=A.Hold_Poor,                                                
 Hold_Junk=A.Hold_Junk                                                                    
 FROM(                                                                    
 select                                                                     
 A.region,                                                                    
 Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                    
 sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                    
 sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(BSX_Ledger) as BSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                    
 sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                    
 sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                    
 FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                     
 INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                        
 GROUP BY A.region,B.Report_Type)A where                                                                    
 [tbl_RMS_collection_region_Hist].Region=A.region and [tbl_RMS_collection_region_Hist].Report_Type=A.Report_Type                                                                    
 AND RMS_DATE=@CurDate                                            
                                                               
 update TBL_RMS_COLLECTION_REGION_HIST SET                                                                   
 Gross_Collection_Perc=((Gross_Collection/Net)*100)                 
 where Net <>0  AND              
 Convert(varchar,RMS_DATE,103)=Convert(varchar,GETDATE(),103)                                                                   
                                                 
 --update TBL_RMS_COLLECTION_REGION_HIST  SET                                       
 --Risk_Inc_Dec=A.Risk_Inc_Dec from                                       
 --(                                      
 --select region,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by region) A where                                       
 --TBL_RMS_COLLECTION_REGION_HIST.region=A.region                                      
 --AND RMS_DATE=@CurDate                                          
                     
 update TBL_RMS_COLLECTION_REGION_HIST SET                     
 Risk_Inc_Dec= (Tot_SBRisk*-1)                    
 where RMS_DATE=@CurDate                    
 and Report_Type = 'R'                    
                     
 update TBL_RMS_COLLECTION_REGION_HIST SET                    
 Risk_Inc_Dec= (TBL_RMS_COLLECTION_REGION_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from            
 (select region,sum(Tot_SBRisk) Tot_SBRisk  from TBL_RMS_COLLECTION_REGION_HIST where rms_date = @PrevDate and Report_Type = 'R' group by REGION) A                    
 where TBL_RMS_COLLECTION_REGION_HIST.region=A.region                    
 AND RMS_DATE=@CurDate                     
 and Report_Type = 'R'                    
                                  
 --update TBL_RMS_COLLECTION_REGION_HIST  SET                                         
 --Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                       
 --(select region,Sum(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_REGION_HIST                                      
 --  where rms_date =@PrevDate  and Tot_ClientRisk<>0 and Report_Type = 'R' group by region) A                      
 --where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                              
                     
 update TBL_RMS_COLLECTION_REGION_HIST  SET                                         
 Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                       
 (select region,Sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_REGION_HIST                                      
   where rms_date =@PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by region) A                      
 where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                    
 and Report_Type = 'R'                    
     
 insert into ORMS_SB_DEPOSIT_hist(Sub_broker,BSECM_Cash,NSECM_Cash,NSEFO_Cash,MCDX_Cash,NCDX_Cash,BSECM_NonCash,    
 NSECM_NonCash,NSEFO_NonCash,MCDX_NonCash,NCDX_NonCash,UpdatedOn,MCD_Cash,NSX_Cash,BSX_Cash,rms_date)    
 select *,@CurDate    
 from general.dbo.ORMS_SB_DEPOSIT    
     
 INSERT INTO ASB7_Clidetails_CrDet_Hist    
 SELECT * FROM MIS.DBO.ASB7_Clidetails_crdet    
 WHERE RMS_date < GETDATE()-10    
     
 DELETE FROM MIS.dbo.ASB7_Clidetails_crdet    
 WHERE RMS_date < GETDATE()-10    
     
 exec general.dbo.Gen_HistMargVio 'NSEFO'     
 exec general.dbo.Gen_HistMargVio 'MCD'     
 exec general.dbo.Gen_HistMargVio 'NCDEX'    
 exec general.dbo.Gen_HistMargVio 'NSX'
 exec general.dbo.Gen_HistMargVio 'BSX'      
 exec general.dbo.Gen_HistMargVio 'MCX'    
     
 exec general.dbo.Gen_HistMarg 'NSEFO'     
 exec general.dbo.Gen_HistMarg 'MCD'     
 exec general.dbo.Gen_HistMarg 'NCDEX'    
 exec general.dbo.Gen_HistMarg 'NSX'  
 exec general.dbo.Gen_HistMarg 'BSX'     
 exec general.dbo.Gen_HistMarg 'MCX'    
     
 INSERT INTO CLIENT_COLLATERALS_HIST    
 SELECT co_code,EffDate,Exchange,Segment,Party_Code,Scrip_Cd,Series,Isin,Cl_Rate,Amount,Qty,HairCut,    
 FinalAmount,PercentageCash,PerecntageNonCash,Receive_Date,Maturity_Date,Coll_Type,ClientType,    
 Remarks,LoginName,LoginTime,Cash_Ncash,Group_Code,Fd_Bg_No,Bank_Code,Fd_Type,CONVERT(VARCHAR(11),GETDATE(),106)    
 FROM General.dbo.CLIENT_COLLATERALS    
  
end try    
begin catch    
   insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)    
   select GETDATE(),'UPD_HISTORY_ALL',ERROR_LINE(),ERROR_MESSAGE()    
       
   DECLARE @ErrorMessage NVARCHAR(4000);    
   SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());    
   RAISERROR (@ErrorMessage , 16, 1);    
end catch;    
SET NOCOUNT OFF    
   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_ALL_06012017
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_HISTORY_ALL_06012017]  
as                        
BEGIN                        
   
SET NOCOUNT ON 
SET XACT_ABORT ON 
BEGIN TRY   
	Declare @CurDate datetime                                                        
	Declare @PrevDate datetime                                                            
	SET @CurDate = convert(varchar(12), GETDATE())                                                        
	set @PrevDate = convert(varchar(11),getdate()-1)                                                            
	  
	--select * into general.dbo.Vw_RMS_CLIENT_Vertical from general.dbo.Vw_RMS_CLIENT_Vertical    
	--select * into general.dbo.tbl_RMS_collection_CLI from general.dbo.tbl_RMS_collection_CLI    
	  
	insert into TBL_RMS_COLLECTION_CLIENT_HIST                                                                  
	(Zone,Region,RegionName,Branch,BranchName,SB,SB_Name,Client,Party_name,Category,RiskCategoryCode,                                                                  
	Priorities,DrNoOfDays,Debit_Priorities,Classification,Cli_Type,SB_Category,Cash,Derivatives,Currency,                                                                  
	Commodities,DP,NBFC,ABL_Net,ACBL_Net,NBFC_Net,Deposit,Net_Debit,Net_Available,BSE_Ledger,NSE_Ledger,                                                                  
	NSEFO_Ledger,MCD_Ledger,NSX_Ledger,MCX_Ledger,NCDEX_Ledger,NBFC_Ledger,Net_Ledger,UnReco_Credit,Hold_BlueChip,                                                                  
	Hold_Good,Hold_Poor,Hold_Junk,Hold_Total,Hold_TotalHC,Coll_NSEFO,Coll_MCD,Coll_NSX,Coll_MCX,Coll_NCDEX,                                                                  
	Coll_Total,Coll_TotalHC,Exp_NSEFO,Exp_MCD,Exp_NSX,Exp_MCX,Exp_NCDEX,Exp_Cash,Exp_Gross,Margin_NSEFO,                                                                  
	Margin_MCD,Margin_NSX,Margin_MCX,Margin_NCDEX,Margin_Total,Margin_Shortage,Margin_Violation,MOS,Pure_Risk,                                                                  
	SB_CrAdjwithPureRisk,Proj_Risk,SB_CrAdjwithProjRisk,SB_Cr_Adjusted,UB_Loss,CashColl_Total,Debit_Days,                                                                  
	Last_Bill_Date,Report_Type,RiskCategory,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                                                
	Risk_Inc_Dec,RMS_DATE)        
	select A.Zone,A.Region,A.RegionName,A.Branch,A.BranchName,A.SB,A.SB_Name,A.Client,        
	A.Party_name,A.Category,A.RiskCategoryCode,A.Priorities,A.DrNoOfDays,A.Debit_Priorities,        
	A.Classification,A.Cli_Type,A.SB_Category,B.Cash,B.Derivatives,B.Currency,B.Commodities        
	,B.DP,B.NBFC,B.ABL_Net,B.ACBL_Net,B.NBFC_Net,B.Deposit,B.Net_Debit,B.Net_Available,                                                                  
	B.BSE_Ledger,B.NSE_Ledger,B.NSEFO_Ledger,B.MCD_Ledger,B.NSX_Ledger,B.MCX_Ledger,B.NCDEX_Ledger                                                                  
	,B.NBFC_Ledger,B.Net_Ledger,B.UnReco_Credit,B.Hold_BlueChip,B.Hold_Good,B.Hold_Poor,B.Hold_Junk                                                                  
	,B.Hold_Total,B.Hold_TotalHC,B.Coll_NSEFO,B.Coll_MCD,B.Coll_NSX,B.Coll_MCX,B.Coll_NCDEX,B.Coll_Total                                                                  
	,B.Coll_TotalHC,B.Exp_NSEFO,B.Exp_MCD,B.Exp_NSX,B.Exp_MCX,B.Exp_NCDEX,B.Exp_Cash,B.Exp_Gross                                                                  
	,B.Margin_NSEFO,B.Margin_MCD,B.Margin_NSX,B.Margin_MCX,B.Margin_NCDEX,B.Margin_Total,B.Margin_Shortage                                                                  
	,B.Margin_Violation,B.MOS,B.Pure_Risk,B.SB_CrAdjwithPureRisk,B.Proj_Risk,B.SB_CrAdjwithProjRisk                                                                  
	,B.SB_Cr_Adjusted,B.UB_Loss,B.CashColl_Total,B.Debit_Days,B.Last_Bill_Date,B.Report_Type,B.RiskCategory,                                                                  
	B.Net_Collection,B.Gross_Collection,B.Pure_Net_Collection,B.Proj_Net_Collection,B.Risk_Inc_Dec,@CurDate                    FROM general.dbo.Vw_RMS_CLIENT_Vertical a (nolock)   
	inner join general.dbo.tbl_RMS_collection_CLI b (nolock) on  a.Client=b.PARTY_CODE                              
	                                              
	--update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                       
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                  
	--(select party_code,Risk_Inc_Dec from general.dbo.tbl_RMS_collection_CLI (nolock)) A                                    
	--where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.PARTY_CODE and  RMS_DATE=@CurDate                                      
	                  
	update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/A.Pure_Risk)*100) from                                
	(select CLIENT,Pure_Risk from TBL_RMS_COLLECTION_CLIENT_HIST (nolock) where rms_date = @PrevDate  and Pure_Risk<>0) A                                    
	where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.CLIENT and  RMS_DATE=@CurDate                                      
	                                                          
	update TBL_RMS_COLLECTION_CLIENT_HIST SET                                               
	Gross_Collection_Perc=((Gross_Collection/Net_debit)*100)                                                                
	where RMS_Date = @CurDate              and Net_debit <> 0                                                        
	  
	-----------------------------------------------END OF INSERTIONS-----------------------------------                                                                                                            
	  
	insert into tbl_RMS_collection_SB_Hist                                                                  
	(zone,region,Branch_cd,Sub_Broker,RegionName,BranchName,SB_Name,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                  
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                  
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                  
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                   
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                  
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                   
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                                
	Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec , RMS_DATE,br_credit,BR_CrAdjusted)                                                                  
	select MAX(b.zone) as zone,MAX(b.region) as region,MAX(Branch_cd) as Branch_cd,Sub_Broker as Sub_Broker,                                                                  
	MAX(RegionName) AS RegionName,MAX(BranchName) AS BranchName,MAX(SB_Name) AS SB_Name,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,            
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,      
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                      
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                              
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                    
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                            
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                       
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                                  
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate as RMS_DATE,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                    
	general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON  a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                  
	group by Sub_Broker,Report_Type                                                  
	  
	select                                                                   
	 A.SB,                                                                  
	 Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	 sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	 sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                      
	 sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	 sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	into #temp1  
	FROM general.dbo.Vw_RMS_CLIENT_Vertical (nolock) A                 
	 INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                  
	 GROUP BY A.SB,B.Report_Type        
	                                              
	update [tbl_RMS_collection_SB_Hist] set                            
	BSE_Ledger=A.BSE_Ledger,                                   
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                                  
	MCD_Ledger=A.MCD_Ledger,                                                           
	NSX_Ledger=A.NSX_Ledger,                                                                  
	MCX_Ledger=A.MCX_Ledger,                                                                  
	NCDEX_Ledger=A.NCDEX_Ledger,                                                                  
	NBFC_Ledger=A.NBFC_Ledger,                                                                  
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                      
	Hold_Poor=A.Hold_Poor,                                                                  
	Hold_Junk=A.Hold_Junk                                                                  
	FROM(                                                                  
	 select * from #temp1)A                                                         
	where                                    
	 tbl_RMS_collection_SB_Hist.Sub_Broker=A.SB and tbl_RMS_collection_SB_Hist.Report_Type=A.Report_Type and                                                                  
	 RMS_DATE=@CurDate                                    
	                                                            
	update tbl_RMS_collection_SB_Hist SET                                                                 
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                              
	where RMS_DATE=@CurDate and Net <>0                                                             
	  
	drop table #temp1        
	  
	--update TBL_RMS_COLLECTION_SB_HIST SET                                       
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(select Sub_Broker,SUM(Risk_Inc_Dec) as Risk_Inc_Dec from general.dbo.tbl_RMS_collection_SB group by Sub_Broker) A                                    
	--where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                    
	--AND RMS_DATE=@CurDate                                        
	  
	update TBL_RMS_COLLECTION_SB_HIST SET                  
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	  
	update TBL_RMS_COLLECTION_SB_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_SB_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                  
	(select Sub_Broker,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST where rms_date = @PrevDate and Report_Type = 'R' group by Sub_Broker) A                  
	where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                    
	AND RMS_DATE=@CurDate                     
	and Report_Type = 'R'                  
	  
	update TBL_RMS_COLLECTION_SB_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                     
	(select Sub_Broker,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST                                   
	 where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R'                                   
	group by Sub_Broker) A                                    
	where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate       
	and Report_Type = 'R'                  
	  
	--update TBL_RMS_COLLECTION_SB_HIST  SET                                       
	--Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                     
	--(select Sub_Broker,MAX(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_SB_HIST     
	-- where rms_date = @PrevDate  and Tot_ClientRisk<>0                                  
	--group by Sub_Broker) A                                    
	--where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate                                    
	  
	-------------------------------------------------------END OF SB HIST------------------------------------------------                                          
	  
	insert into [tbl_RMS_collection_BRANCH_Hist]                                                                  
	(zone,region,Branch_cd,RegionName,BranchName,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                              
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                  
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                     
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                   
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                  
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                   
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                            
	Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                           
	select MAX(zone) as zone,MAX(region) as region,Branch_cd,                                                                  
	MAX(RegionName) AS RegionName,BranchName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                             
	MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                                            
	SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                         
	Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                             
	SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,            
	SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                  
	SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                  
	SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                                  
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                           
	SUM(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted FROM (                                                            
	                        
	select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                               
	MAX(RegionName) AS RegionName,BranchName,                      
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                               
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                      
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,       
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a  (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                             
	where (Report_Type <>'R' )              
	group by a.Region,Branch_cd,a.BranchName,SB,Report_Type                                                            
	                        
	union all                        
	                        
	select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                               
	MAX(RegionName) AS RegionName,BranchName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                 
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,              
	SUM(case when Report_Type = 'R' then Cash else 0 end ) as Cash,              
	SUM(case when Report_Type = 'R' then Derivatives else 0 end ) as Derivatives,                     
	SUM(case when Report_Type = 'R' then Currency else 0 end ) as Currency,              
	SUM(case when Report_Type = 'R' then Commodities else 0 end ) as Commodities,SUM(DP) as DP,                                                                  
	SUM(case when Report_Type = 'R' then NBFC else 0 end ) as NBFC,              
	SUM(case when Report_Type = 'R' then Deposit else 0 end ) as Deposit,              
	SUM(case when Report_Type = 'R' then Net else 0 end ) as Net,                                                                  
	SUM(case when Report_Type = 'R' then [App.Holding] else 0 end ) as [App.Holding],              
	SUM(case when Report_Type = 'R' then [Non-App.Holding] else 0 end ) as [Non-App.Holding],              
	SUM(case when Report_Type = 'R' then Holding else 0 end ) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                      
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,   
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	'R' Report_Type ,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                           
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                     
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                              
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                        
	where (Report_Type ='R' OR Report_Type = 'L')                         
	group by a.Region,Branch_cd,a.BranchName,SB                        
	)r                                                            
	group by r.BrType,r.Region,r.Branch_cd,r.BranchName,Report_Type                                                             
	         
	        
	select                                                                   
	 A.BRANCH,                                                
	 Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	 sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	 sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                  
	 sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	 sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	        
	into #temp2         
	         
	FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                   
	 INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                     
	 GROUP BY A.BRANCH,B.Report_Type        
	        
	                                                                 
	update [tbl_RMS_collection_BRANCH_Hist] set                                                                   
	BSE_Ledger=A.BSE_Ledger,                                            
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                       
	MCD_Ledger=A.MCD_Ledger,                                                                  
	NSX_Ledger=A.NSX_Ledger,                                                            
	MCX_Ledger=A.MCX_Ledger,                                                      
	NCDEX_Ledger=A.NCDEX_Ledger,                                                               
	NBFC_Ledger=A.NBFC_Ledger,                                                               
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                                  
	Hold_Poor=A.Hold_Poor,                                                                  
	Hold_Junk=A.Hold_Junk                                            
	FROM(                                                 
	 select * from #temp2 )A                                                         
	where                                               
	[tbl_RMS_collection_BRANCH_Hist].Branch_cd=A.BRANCH and [tbl_RMS_collection_BRANCH_Hist].Report_Type=A.Report_Type                                        
	AND RMS_DATE=@CurDate                                                        
	                                                            
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                                                   
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                                
	where Net <>0 AND                                                             
	 RMS_DATE=@CurDate             
	        
	        
	drop table #temp2                                                   
	        
	--update [TBL_RMS_COLLECTION_BRANCH_HIST]  SET                                     
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(                                    
	--select Branch_cd,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by Branch_cd) A where                                     
	--[TBL_RMS_COLLECTION_BRANCH_HIST].Branch_cd=A.Branch_cd                                    
	--AND RMS_DATE=@CurDate                                        
	                  
	                  
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                   
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate             
	and Report_Type = 'R'                  
	                  
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_BRANCH_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                  
	(select BRANCH_CD,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST where rms_date = @PrevDate and Report_Type = 'R' group by BRANCH_CD) A                  
	where TBL_RMS_COLLECTION_BRANCH_HIST.BRANCH_CD=A.BRANCH_CD                                    
	AND RMS_DATE=@CurDate                   
	and Report_Type = 'R'                  
	                                    
	                                    
	update TBL_RMS_COLLECTION_BRANCH_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                      
	(select Branch_cd,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST                                    
	  where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by Branch_cd) A                                    
	where TBL_RMS_COLLECTION_BRANCH_HIST.Branch_cd=A.Branch_cd AND  RMS_DATE=@CurDate                                    
	and Report_Type = 'R'                                              
	                  
	-------------------------------------------------------END OF BRANCH HIST------------------------------------------------                                                                  
	insert into [tbl_RMS_collection_region_Hist]                                                                  
	(zone,region,RegionName,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                  
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,              
	                                                      
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                  
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                         
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                               
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                            
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                      
	Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                                    
	SELECT R.Zone,                                                              
	R.region,                                                             
	R.RegionName,                                           
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                     
	MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                      
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                     
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                                                                  
	SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                                                  
	SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                  
	SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                      
	SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                            
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	SUM(Risk_Inc_Dec) as Risk_Inc_Dec, @CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted  From                                                     
	(                                                            
	select MAX(b.zone) as zone,a.region,                                                                  
	a.RegionName AS RegionName,                                                   
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                             
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                       
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,            SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                 
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                           
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                  SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                      
	  
	  
	  
	  
	   
	   
	  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                 
	where Report_Type <> 'R'                    
	group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB,Report_Type                            
	                            
	union all                            
	                            
	select MAX(b.zone) as zone,a.region,                               
	a.RegionName AS RegionName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,              
	SUM(case when Report_Type = 'R' then Cash else 0 end) as Cash,              
	SUM(case when Report_Type = 'R' then Derivatives else 0 end) as Derivatives,         
	SUM(case when Report_Type = 'R' then Currency  else 0 end) as Currency,              
	SUM(case when Report_Type = 'R' then Commodities  else 0 end) as Commodities,SUM(DP) as DP,                                                                  
	SUM(case when Report_Type = 'R' then NBFC  else 0 end) as NBFC,              
	SUM(case when Report_Type = 'R' then Deposit  else 0 end) as Deposit,              
	SUM(case when Report_Type = 'R' then Net else 0 end) as Net,              
	SUM(case when Report_Type = 'R' then [App.Holding]  else 0 end) as [App.Holding],              
	SUM(case when Report_Type = 'R' then [Non-App.Holding]  else 0 end) as [Non-App.Holding],              
	SUM(case when Report_Type = 'R' then Holding else 0 end) as Holding,              
	SUM(case when Report_Type = 'R' then [SB Balance]  else 0 end) as [SB Balance],              
	SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(case when Report_Type = 'R' then Total_Colleteral  else 0 end) as Total_Colleteral,              
	SUM(case when Report_Type = 'R' then Margin_Shortage  else 0 end) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,              
	SUM(case when Report_Type = 'R' then Exposure else 0 end) as Exposure,              
	SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(case when Report_Type = 'R' then SB_Credit  else 0 end) as SB_Credit,              
	MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	'R' Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                         
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                        
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                           
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                         
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                            
	general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                            
	where (Report_Type = 'R' OR Report_Type = 'L')                    
	group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB   
	)r                                                            
	 group by r.Zone,r.Region,r.RegionName,Report_Type                                        
	  
	update [tbl_RMS_collection_region_Hist] set                                     
	BSE_Ledger=A.BSE_Ledger,              
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                                  
	MCD_Ledger=A.MCD_Ledger,                                                                  
	NSX_Ledger=A.NSX_Ledger,                                                                  
	MCX_Ledger=A.MCX_Ledger,                                                                  
	NCDEX_Ledger=A.NCDEX_Ledger,                                                                  
	NBFC_Ledger=A.NBFC_Ledger,                                                                  
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                                  
	Hold_Poor=A.Hold_Poor,                                              
	Hold_Junk=A.Hold_Junk                                                                  
	FROM(                                                                  
	select                                                                   
	A.region,                                                                  
	Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                  
	sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                   
	INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                      
	GROUP BY A.region,B.Report_Type)A where                                                                  
	[tbl_RMS_collection_region_Hist].Region=A.region and [tbl_RMS_collection_region_Hist].Report_Type=A.Report_Type                                                                  
	AND RMS_DATE=@CurDate                                          
	                                                            
	update TBL_RMS_COLLECTION_REGION_HIST SET                                                                 
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                             
	where Net <>0  AND            
	Convert(varchar,RMS_DATE,103)=Convert(varchar,GETDATE(),103)                                                                 
	                                              
	--update TBL_RMS_COLLECTION_REGION_HIST  SET                                     
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(                                    
	--select region,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by region) A where                                     
	--TBL_RMS_COLLECTION_REGION_HIST.region=A.region                                    
	--AND RMS_DATE=@CurDate                                        
	                  
	update TBL_RMS_COLLECTION_REGION_HIST SET                   
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	                  
	update TBL_RMS_COLLECTION_REGION_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_REGION_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from          
	(select region,sum(Tot_SBRisk) Tot_SBRisk  from TBL_RMS_COLLECTION_REGION_HIST where rms_date = @PrevDate and Report_Type = 'R' group by REGION) A                  
	where TBL_RMS_COLLECTION_REGION_HIST.region=A.region                  
	AND RMS_DATE=@CurDate                   
	and Report_Type = 'R'                  
	                               
	--update TBL_RMS_COLLECTION_REGION_HIST  SET                                       
	--Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                     
	--(select region,Sum(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_REGION_HIST                                    
	--  where rms_date =@PrevDate  and Tot_ClientRisk<>0 and Report_Type = 'R' group by region) A                    
	--where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                            
	                  
	update TBL_RMS_COLLECTION_REGION_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                     
	(select region,Sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_REGION_HIST                                    
	  where rms_date =@PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by region) A                    
	where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	  
	insert into ORMS_SB_DEPOSIT_hist(Sub_broker,BSECM_Cash,NSECM_Cash,NSEFO_Cash,MCDX_Cash,NCDX_Cash,BSECM_NonCash,  
	NSECM_NonCash,NSEFO_NonCash,MCDX_NonCash,NCDX_NonCash,UpdatedOn,MCD_Cash,NSX_Cash,rms_date)  
	select *,@CurDate  
	from general.dbo.ORMS_SB_DEPOSIT  
	  
	INSERT INTO ASB7_Clidetails_CrDet_Hist  
	SELECT * FROM MIS.DBO.ASB7_Clidetails_crdet  
	WHERE RMS_date < GETDATE()-10  
	  
	DELETE FROM MIS.dbo.ASB7_Clidetails_crdet  
	WHERE RMS_date < GETDATE()-10  
	  
	exec general.dbo.Gen_HistMargVio 'NSEFO'   
	exec general.dbo.Gen_HistMargVio 'MCD'   
	exec general.dbo.Gen_HistMargVio 'NCDEX'  
	exec general.dbo.Gen_HistMargVio 'NSX'   
	exec general.dbo.Gen_HistMargVio 'MCX'  
	  
	exec general.dbo.Gen_HistMarg 'NSEFO'   
	exec general.dbo.Gen_HistMarg 'MCD'   
	exec general.dbo.Gen_HistMarg 'NCDEX'  
	exec general.dbo.Gen_HistMarg 'NSX'   
	exec general.dbo.Gen_HistMarg 'MCX'  
	  
	INSERT INTO CLIENT_COLLATERALS_HIST  
	SELECT co_code,EffDate,Exchange,Segment,Party_Code,Scrip_Cd,Series,Isin,Cl_Rate,Amount,Qty,HairCut,  
	FinalAmount,PercentageCash,PerecntageNonCash,Receive_Date,Maturity_Date,Coll_Type,ClientType,  
	Remarks,LoginName,LoginTime,Cash_Ncash,Group_Code,Fd_Bg_No,Bank_Code,Fd_Type,CONVERT(VARCHAR(11),GETDATE(),106)  
	FROM General.dbo.CLIENT_COLLATERALS  

end try  
begin catch  
	  insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)  
	  select GETDATE(),'UPD_HISTORY_ALL',ERROR_LINE(),ERROR_MESSAGE()  
	    
	  DECLARE @ErrorMessage NVARCHAR(4000);  
	  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());  
	  RAISERROR (@ErrorMessage , 16, 1);  
end catch;  
SET NOCOUNT OFF  
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_ALL_13012017
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_HISTORY_ALL_13012017]  
as                        
BEGIN                        
   
SET NOCOUNT ON 
SET XACT_ABORT ON 
BEGIN TRY   
	Declare @CurDate datetime                                                        
	Declare @PrevDate datetime                                                            
	SET @CurDate = convert(varchar(12), GETDATE())                                                        
	set @PrevDate = convert(varchar(11),getdate()-1)                                                            
	  
	--select * into general.dbo.Vw_RMS_CLIENT_Vertical from general.dbo.Vw_RMS_CLIENT_Vertical    
	--select * into general.dbo.tbl_RMS_collection_CLI from general.dbo.tbl_RMS_collection_CLI    
	  
	insert into TBL_RMS_COLLECTION_CLIENT_HIST                                                                  
	(Zone,Region,RegionName,Branch,BranchName,SB,SB_Name,Client,Party_name,Category,RiskCategoryCode,                                                                  
	Priorities,DrNoOfDays,Debit_Priorities,Classification,Cli_Type,SB_Category,Cash,Derivatives,Currency,                                                                  
	Commodities,DP,NBFC,ABL_Net,ACBL_Net,NBFC_Net,Deposit,Net_Debit,Net_Available,BSE_Ledger,NSE_Ledger,                                                                  
	NSEFO_Ledger,MCD_Ledger,NSX_Ledger,MCX_Ledger,NCDEX_Ledger,NBFC_Ledger,Net_Ledger,UnReco_Credit,Hold_BlueChip,                                                                  
	Hold_Good,Hold_Poor,Hold_Junk,Hold_Total,Hold_TotalHC,Coll_NSEFO,Coll_MCD,Coll_NSX,Coll_MCX,Coll_NCDEX,                                                                  
	Coll_Total,Coll_TotalHC,Exp_NSEFO,Exp_MCD,Exp_NSX,Exp_MCX,Exp_NCDEX,Exp_Cash,Exp_Gross,Margin_NSEFO,                                                                  
	Margin_MCD,Margin_NSX,Margin_MCX,Margin_NCDEX,Margin_Total,Margin_Shortage,Margin_Violation,MOS,Pure_Risk,                                                                  
	SB_CrAdjwithPureRisk,Proj_Risk,SB_CrAdjwithProjRisk,SB_Cr_Adjusted,UB_Loss,CashColl_Total,Debit_Days,                                                                  
	Last_Bill_Date,Report_Type,RiskCategory,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                                                
	Risk_Inc_Dec,RMS_DATE)        
	select A.Zone,A.Region,A.RegionName,A.Branch,A.BranchName,A.SB,A.SB_Name,A.Client,        
	A.Party_name,A.Category,A.RiskCategoryCode,A.Priorities,A.DrNoOfDays,A.Debit_Priorities,        
	A.Classification,A.Cli_Type,A.SB_Category,B.Cash,B.Derivatives,B.Currency,B.Commodities        
	,B.DP,B.NBFC,B.ABL_Net,B.ACBL_Net,B.NBFC_Net,B.Deposit,B.Net_Debit,B.Net_Available,                                                                  
	B.BSE_Ledger,B.NSE_Ledger,B.NSEFO_Ledger,B.MCD_Ledger,B.NSX_Ledger,B.MCX_Ledger,B.NCDEX_Ledger                                                                  
	,B.NBFC_Ledger,B.Net_Ledger,B.UnReco_Credit,B.Hold_BlueChip,B.Hold_Good,B.Hold_Poor,B.Hold_Junk                                                                  
	,B.Hold_Total,B.Hold_TotalHC,B.Coll_NSEFO,B.Coll_MCD,B.Coll_NSX,B.Coll_MCX,B.Coll_NCDEX,B.Coll_Total                                                                  
	,B.Coll_TotalHC,B.Exp_NSEFO,B.Exp_MCD,B.Exp_NSX,B.Exp_MCX,B.Exp_NCDEX,B.Exp_Cash,B.Exp_Gross                                                                  
	,B.Margin_NSEFO,B.Margin_MCD,B.Margin_NSX,B.Margin_MCX,B.Margin_NCDEX,B.Margin_Total,B.Margin_Shortage                                                                  
	,B.Margin_Violation,B.MOS,B.Pure_Risk,B.SB_CrAdjwithPureRisk,B.Proj_Risk,B.SB_CrAdjwithProjRisk                                                                  
	,B.SB_Cr_Adjusted,B.UB_Loss,B.CashColl_Total,B.Debit_Days,B.Last_Bill_Date,B.Report_Type,B.RiskCategory,                                                                  
	B.Net_Collection,B.Gross_Collection,B.Pure_Net_Collection,B.Proj_Net_Collection,B.Risk_Inc_Dec,@CurDate                    FROM general.dbo.Vw_RMS_CLIENT_Vertical a (nolock)   
	inner join general.dbo.tbl_RMS_collection_CLI b (nolock) on  a.Client=b.PARTY_CODE                              
	                                              
	--update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                       
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                  
	--(select party_code,Risk_Inc_Dec from general.dbo.tbl_RMS_collection_CLI (nolock)) A                                    
	--where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.PARTY_CODE and  RMS_DATE=@CurDate                                      
	                  
	update TBL_RMS_COLLECTION_CLIENT_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/A.Pure_Risk)*100) from                                
	(select CLIENT,Pure_Risk from TBL_RMS_COLLECTION_CLIENT_HIST (nolock) where rms_date = @PrevDate  and Pure_Risk<>0) A                                    
	where TBL_RMS_COLLECTION_CLIENT_HIST.CLIENT=A.CLIENT and  RMS_DATE=@CurDate                                      
	                                                          
	update TBL_RMS_COLLECTION_CLIENT_HIST SET                                               
	Gross_Collection_Perc=((Gross_Collection/Net_debit)*100)                                                                
	where RMS_Date = @CurDate              and Net_debit <> 0                                                        
	  
	-----------------------------------------------END OF INSERTIONS-----------------------------------                                                                                                            
	  
	insert into tbl_RMS_collection_SB_Hist                                                                  
	(zone,region,Branch_cd,Sub_Broker,RegionName,BranchName,SB_Name,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                  
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                  
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                  
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                   
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                  
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                   
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                                
	Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec , RMS_DATE,br_credit,BR_CrAdjusted)                                                                  
	select MAX(b.zone) as zone,MAX(b.region) as region,MAX(Branch_cd) as Branch_cd,Sub_Broker as Sub_Broker,                                                                  
	MAX(RegionName) AS RegionName,MAX(BranchName) AS BranchName,MAX(SB_Name) AS SB_Name,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,            
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,      
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                      
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                              
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                    
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                            
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                       
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                                  
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate as RMS_DATE,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                    
	general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON  a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                  
	group by Sub_Broker,Report_Type                                                  
	  
	select                                                                   
	 A.SB,                                                                  
	 Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	 sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	 sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                      
	 sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	 sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	into #temp1  
	FROM general.dbo.Vw_RMS_CLIENT_Vertical (nolock) A                 
	 INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                  
	 GROUP BY A.SB,B.Report_Type        
	                                              
	update [tbl_RMS_collection_SB_Hist] set                            
	BSE_Ledger=A.BSE_Ledger,                                   
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                                  
	MCD_Ledger=A.MCD_Ledger,                                                           
	NSX_Ledger=A.NSX_Ledger,                                                                  
	MCX_Ledger=A.MCX_Ledger,                                                                  
	NCDEX_Ledger=A.NCDEX_Ledger,                                                                  
	NBFC_Ledger=A.NBFC_Ledger,                                                                  
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                      
	Hold_Poor=A.Hold_Poor,                                                                  
	Hold_Junk=A.Hold_Junk                                                                  
	FROM(                                                                  
	 select * from #temp1)A                                                         
	where                                    
	 tbl_RMS_collection_SB_Hist.Sub_Broker=A.SB and tbl_RMS_collection_SB_Hist.Report_Type=A.Report_Type and                                                                  
	 RMS_DATE=@CurDate                                    
	                                                            
	update tbl_RMS_collection_SB_Hist SET                                                                 
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                              
	where RMS_DATE=@CurDate and Net <>0                                                             
	  
	drop table #temp1        
	  
	--update TBL_RMS_COLLECTION_SB_HIST SET                                       
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(select Sub_Broker,SUM(Risk_Inc_Dec) as Risk_Inc_Dec from general.dbo.tbl_RMS_collection_SB group by Sub_Broker) A                                    
	--where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                    
	--AND RMS_DATE=@CurDate                                        
	  
	update TBL_RMS_COLLECTION_SB_HIST SET                  
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	  
	update TBL_RMS_COLLECTION_SB_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_SB_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                  
	(select Sub_Broker,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST where rms_date = @PrevDate and Report_Type = 'R' group by Sub_Broker) A                  
	where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker                                    
	AND RMS_DATE=@CurDate                     
	and Report_Type = 'R'                  
	  
	update TBL_RMS_COLLECTION_SB_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                     
	(select Sub_Broker,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_SB_HIST                                   
	 where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R'                                   
	group by Sub_Broker) A                                    
	where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate       
	and Report_Type = 'R'                  
	  
	--update TBL_RMS_COLLECTION_SB_HIST  SET                                       
	--Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                     
	--(select Sub_Broker,MAX(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_SB_HIST     
	-- where rms_date = @PrevDate  and Tot_ClientRisk<>0                                  
	--group by Sub_Broker) A                                    
	--where TBL_RMS_COLLECTION_SB_HIST.Sub_Broker=A.Sub_Broker AND  RMS_DATE=@CurDate                                    
	  
	-------------------------------------------------------END OF SB HIST------------------------------------------------                                          
	  
	insert into [tbl_RMS_collection_BRANCH_Hist]                                                                  
	(zone,region,Branch_cd,RegionName,BranchName,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                              
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,                                                                  
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                     
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                                   
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                                                                  
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                                                                   
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,                                            
	Pure_Net_Collection,Proj_Net_Collection,Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                           
	select MAX(zone) as zone,MAX(region) as region,Branch_cd,                                                                  
	MAX(RegionName) AS RegionName,BranchName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                             
	MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                                            
	SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                         
	Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                             
	SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,            
	SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                  
	SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                  
	SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                                  
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                           
	SUM(Risk_Inc_Dec) as Risk_Inc_Dec,@CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted FROM (                                                            
	                        
	select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                               
	MAX(RegionName) AS RegionName,BranchName,                      
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                               
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                      
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,       
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a  (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                             
	where (Report_Type <>'R' )              
	group by a.Region,Branch_cd,a.BranchName,SB,Report_Type                                                            
	                        
	union all                        
	                        
	select MAX(b.zone) as zone,MAX(b.region) as region,Branch_cd,                                               
	MAX(RegionName) AS RegionName,BranchName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                 
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,              
	SUM(case when Report_Type = 'R' then Cash else 0 end ) as Cash,              
	SUM(case when Report_Type = 'R' then Derivatives else 0 end ) as Derivatives,                     
	SUM(case when Report_Type = 'R' then Currency else 0 end ) as Currency,              
	SUM(case when Report_Type = 'R' then Commodities else 0 end ) as Commodities,SUM(DP) as DP,                                                                  
	SUM(case when Report_Type = 'R' then NBFC else 0 end ) as NBFC,              
	SUM(case when Report_Type = 'R' then Deposit else 0 end ) as Deposit,              
	SUM(case when Report_Type = 'R' then Net else 0 end ) as Net,                                                                  
	SUM(case when Report_Type = 'R' then [App.Holding] else 0 end ) as [App.Holding],              
	SUM(case when Report_Type = 'R' then [Non-App.Holding] else 0 end ) as [Non-App.Holding],              
	SUM(case when Report_Type = 'R' then Holding else 0 end ) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                      
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,   
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	'R' Report_Type ,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                           
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                     
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                              
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a (nolock) INNER JOIN general.dbo.tbl_RMS_collection_SB b (nolock) ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                        
	where (Report_Type ='R' OR Report_Type = 'L')                         
	group by a.Region,Branch_cd,a.BranchName,SB                        
	)r                                                            
	group by r.BrType,r.Region,r.Branch_cd,r.BranchName,Report_Type                                                             
	         
	        
	select                                                                   
	 A.BRANCH,                                                
	 Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	 sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	 sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                  
	 sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	 sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	        
	into #temp2         
	         
	FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                   
	 INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                                                     
	 GROUP BY A.BRANCH,B.Report_Type        
	        
	                                                                 
	update [tbl_RMS_collection_BRANCH_Hist] set                                                                   
	BSE_Ledger=A.BSE_Ledger,                                            
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                       
	MCD_Ledger=A.MCD_Ledger,                                                                  
	NSX_Ledger=A.NSX_Ledger,                                                            
	MCX_Ledger=A.MCX_Ledger,                                                      
	NCDEX_Ledger=A.NCDEX_Ledger,                                                               
	NBFC_Ledger=A.NBFC_Ledger,                                                               
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                                  
	Hold_Poor=A.Hold_Poor,                                                                  
	Hold_Junk=A.Hold_Junk                                            
	FROM(                                                 
	 select * from #temp2 )A                                                         
	where                                               
	[tbl_RMS_collection_BRANCH_Hist].Branch_cd=A.BRANCH and [tbl_RMS_collection_BRANCH_Hist].Report_Type=A.Report_Type                                        
	AND RMS_DATE=@CurDate                                                        
	                                                            
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                                                   
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                                                
	where Net <>0 AND                                                             
	 RMS_DATE=@CurDate             
	        
	        
	drop table #temp2                                                   
	        
	--update [TBL_RMS_COLLECTION_BRANCH_HIST]  SET                                     
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(                                    
	--select Branch_cd,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by Branch_cd) A where                                     
	--[TBL_RMS_COLLECTION_BRANCH_HIST].Branch_cd=A.Branch_cd                                    
	--AND RMS_DATE=@CurDate                                        
	                  
	                  
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                   
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate             
	and Report_Type = 'R'                  
	                  
	update TBL_RMS_COLLECTION_BRANCH_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_BRANCH_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from                  
	(select BRANCH_CD,sum(Tot_SBRisk) Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST where rms_date = @PrevDate and Report_Type = 'R' group by BRANCH_CD) A                  
	where TBL_RMS_COLLECTION_BRANCH_HIST.BRANCH_CD=A.BRANCH_CD                                    
	AND RMS_DATE=@CurDate                   
	and Report_Type = 'R'                  
	                                    
	                                    
	update TBL_RMS_COLLECTION_BRANCH_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                      
	(select Branch_cd,sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_BRANCH_HIST                                    
	  where rms_date = @PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by Branch_cd) A                                    
	where TBL_RMS_COLLECTION_BRANCH_HIST.Branch_cd=A.Branch_cd AND  RMS_DATE=@CurDate                                    
	and Report_Type = 'R'                                              
	                  
	-------------------------------------------------------END OF BRANCH HIST------------------------------------------------                                                                  
	insert into [tbl_RMS_collection_region_Hist]                                                                  
	(zone,region,RegionName,NoOfClients,ParentTag,BrType,BrCategory,                                                                   
	SB_Type,SB_Category,cli_count,Cash,Derivatives,Currency,Commodities,DP,NBFC,Deposit,                                                                  
	Net,[App.Holding],[Non-App.Holding],Holding,[SB Balance],ProjRisk,PureRisk,MOS,UnbookedLoss,              
	                                                      
	IMargin,Total_Colleteral,Margin_Shortage,Un_Reco,Exposure,PureAdj,ProjAdj,SB_MOS,                                                                  
	SB_ROI, SB_Credit,SB_ClientCount,Exp_Gross,Report_Type,Tot_LegalRisk,SB_CrAdjWithLegal,                                                         
	SB_CrAfterAdjLegal, SB_LegalRisk, Tot_PureRisk, SB_CrAdjWithPureRisk, SB_CrAfterAdjPureRisk, SB_PureRisk,                               
	Tot_ClientRisk, Tot_SBRisk, Tot_ProjRisk, SB_CrAdjWithProjRisk, SB_CrAfterAdjProjRisk, SB_ProjRisk,                            
	SB_CrAdjusted, SB_BalanceCr,Net_Collection,Gross_Collection,Pure_Net_Collection,Proj_Net_Collection,                      
	Risk_Inc_Dec, RMS_DATE,br_credit,BR_CrAdjusted)                                    
	SELECT R.Zone,                                                              
	R.region,                                                             
	R.RegionName,                                           
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                     
	MAX(BrCategory) AS BrCategory, MAX(SB_Type) AS SB_Type,MAX(SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,                                                                  
	SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                      
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	SUM(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                     
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	SUM(SB_MOS) as SB_MOS,SUM(SB_ROI) as SB_ROI,                                                                  
	SUM(SB_Credit) as SB_Credit,SUM(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,SUM([Tot_LegalRisk]) as [Tot_LegalRisk],SUM(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	SUM(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,SUM(SB_LegalRisk) as SB_LegalRisk,                                                                  
	SUM(Tot_PureRisk) as Tot_PureRisk,SUM(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                                  
	SUM(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,SUM(SB_PureRisk) as SB_PureRisk,                                                                  
	SUM(Tot_ClientRisk) as Tot_ClientRisk,SUM(Tot_SBRisk) as Tot_SBRisk,SUM(Tot_ProjRisk) as Tot_ProjRisk,                      
	SUM(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,SUM(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	SUM(SB_ProjRisk) as SB_ProjRisk,SUM(SB_CrAdjusted) as SB_CrAdjusted,SUM(SB_BalanceCr) as SB_BalanceCr,                                                
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                            
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	SUM(Risk_Inc_Dec) as Risk_Inc_Dec, @CurDate,SUM(br_credit) as br_credit,SUM(BR_CrAdjusted) as BR_CrAdjusted  From                                                     
	(                                                            
	select MAX(b.zone) as zone,a.region,                                                                  
	a.RegionName AS RegionName,                                                   
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                             
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                       
	sum(cli_count) as cli_count,SUM(Cash) as Cash,SUM(Derivatives) as Derivatives,                                                                  
	SUM(Currency) as Currency,SUM(Commodities) as Commodities,SUM(DP) as DP,                                                                  
	SUM(NBFC) as NBFC,SUM(Deposit) as Deposit,SUM(Net) as Net,            SUM([App.Holding]) as [App.Holding],SUM([Non-App.Holding]) as [Non-App.Holding],SUM(Holding) as Holding,                                                                  
	SUM([SB Balance]) as [SB Balance],SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(Total_Colleteral) as Total_Colleteral,SUM(Margin_Shortage) as Margin_Shortage,                                                                 
	SUM(Un_Reco) as Un_Reco,SUM(Exposure) as Exposure,SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(SB_Credit) as SB_Credit,MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                                  
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                                                  
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                           
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                  SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                      
	  
	  
	  
	  
	   
	   
	  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                                                                   
	general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                                                 
	where Report_Type <> 'R'                    
	group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB,Report_Type                            
	                            
	union all                            
	                            
	select MAX(b.zone) as zone,a.region,                               
	a.RegionName AS RegionName,                                                                  
	MAX(NoOfClients) AS NoOfClients,MAX(ParentTag) AS ParentTag,MAX(BrType) AS BrType,                                                                  
	MAX(BrCategory) AS BrCategory, MAX(b.SB_Type) AS SB_Type,MAX(b.SB_Category) AS SB_Category,                                                                  
	sum(cli_count) as cli_count,              
	SUM(case when Report_Type = 'R' then Cash else 0 end) as Cash,              
	SUM(case when Report_Type = 'R' then Derivatives else 0 end) as Derivatives,         
	SUM(case when Report_Type = 'R' then Currency  else 0 end) as Currency,              
	SUM(case when Report_Type = 'R' then Commodities  else 0 end) as Commodities,SUM(DP) as DP,                                                                  
	SUM(case when Report_Type = 'R' then NBFC  else 0 end) as NBFC,              
	SUM(case when Report_Type = 'R' then Deposit  else 0 end) as Deposit,              
	SUM(case when Report_Type = 'R' then Net else 0 end) as Net,              
	SUM(case when Report_Type = 'R' then [App.Holding]  else 0 end) as [App.Holding],              
	SUM(case when Report_Type = 'R' then [Non-App.Holding]  else 0 end) as [Non-App.Holding],              
	SUM(case when Report_Type = 'R' then Holding else 0 end) as Holding,              
	SUM(case when Report_Type = 'R' then [SB Balance]  else 0 end) as [SB Balance],              
	SUM(ProjRisk) as ProjRisk,SUM(PureRisk) as PureRisk,                                                                  
	MAX(MOS) as MOS,SUM(UnbookedLoss) as UnbookedLoss,SUM(IMargin) as IMargin,                                                                  
	SUM(case when Report_Type = 'R' then Total_Colleteral  else 0 end) as Total_Colleteral,              
	SUM(case when Report_Type = 'R' then Margin_Shortage  else 0 end) as Margin_Shortage,                                                                  
	SUM(Un_Reco) as Un_Reco,              
	SUM(case when Report_Type = 'R' then Exposure else 0 end) as Exposure,              
	SUM(PureAdj) as PureAdj,SUM(ProjAdj) as ProjAdj,                                                                  
	MAX(SB_MOS) as SB_MOS,MAX(SB_ROI) as SB_ROI,                                                                  
	MAX(case when Report_Type = 'R' then SB_Credit  else 0 end) as SB_Credit,              
	MAX(SB_ClientCount) as SB_ClientCount,SUM(Exp_Gross) as Exp_Gross,                                                                  
	'R' Report_Type,MAX([Tot_LegalRisk]) as [Tot_LegalRisk],MAX(SB_CrAdjWithLegal) as SB_CrAdjWithLegal,                                                         
	MAX(SB_CrAfterAdjLegal) as SB_CrAfterAdjLegal,MAX(SB_LegalRisk) as SB_LegalRisk,                                        
	MAX(Tot_PureRisk) as Tot_PureRisk,MAX(SB_CrAdjWithPureRisk) as SB_CrAdjWithPureRisk,                                                           
	MAX(SB_CrAfterAdjPureRisk) as SB_CrAfterAdjPureRisk,MAX(SB_PureRisk) as SB_PureRisk,                                                                  
	MAX(Tot_ClientRisk) as Tot_ClientRisk,MAX(Tot_SBRisk) as Tot_SBRisk,MAX(Tot_ProjRisk) as Tot_ProjRisk,                                                                  
	MAX(SB_CrAdjWithProjRisk) as SB_CrAdjWithProjRisk,MAX(SB_CrAfterAdjProjRisk) as SB_CrAfterAdjProjRisk,                                                                  
	MAX(SB_ProjRisk) as SB_ProjRisk,MAX(SB_CrAdjusted) as SB_CrAdjusted,MAX(SB_BalanceCr) as SB_BalanceCr,                                                         
	SUM(Net_Collection) as Net_Collection,SUM(Gross_Collection) as Gross_Collection,                                                  
	SUM(Pure_Net_Collection) AS Pure_Net_Collection,SUM(Proj_Net_Collection) AS Proj_Net_Collection,                                                  
	MAX(Risk_Inc_Dec) as Risk_Inc_Dec,max(br_credit) as br_credit,max(BR_CrAdjusted) as BR_CrAdjusted  
	from                            
	general.dbo.Vw_RMS_SB_Vertical a INNER JOIN general.dbo.tbl_RMS_collection_SB b ON a.SB=b.Sub_Broker  and a.Branch=b.Branch_cd                            
	where (Report_Type = 'R' OR Report_Type = 'L')                    
	group by a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,SB   
	)r                                                            
	 group by r.Zone,r.Region,r.RegionName,Report_Type                                        
	  
	update [tbl_RMS_collection_region_Hist] set                                     
	BSE_Ledger=A.BSE_Ledger,              
	NSE_Ledger=A.NSE_Ledger,                                                                  
	NSEFO_Ledger=A.NSEFO_Ledger,                                                                  
	MCD_Ledger=A.MCD_Ledger,                                                                  
	NSX_Ledger=A.NSX_Ledger,                                                                  
	MCX_Ledger=A.MCX_Ledger,                                                                  
	NCDEX_Ledger=A.NCDEX_Ledger,                                                                  
	NBFC_Ledger=A.NBFC_Ledger,                                                                  
	Hold_BlueChip=A.Hold_BlueChip,                                                                  
	Hold_Good=A.Hold_Good,                                                                  
	Hold_Poor=A.Hold_Poor,                                              
	Hold_Junk=A.Hold_Junk                                                                  
	FROM(                                                                  
	select                                                                   
	A.region,                                                                  
	Report_Type=case when B.Report_Type ='A' then 'O' else B.Report_Type END ,                                                                  
	sum(BSE_Ledger) as BSE_Ledger,sum(NSE_Ledger) as NSE_Ledger,sum(NSEFO_Ledger) as NSEFO_Ledger,                                                                  
	sum(MCD_Ledger) as MCD_Ledger,sum(NSX_Ledger) as NSX_Ledger,sum(MCX_Ledger) as MCX_Ledger,                                                                  
	sum(NCDEX_Ledger) as NCDEX_Ledger,sum(NBFC_Ledger) as NBFC_Ledger,sum(Hold_BlueChip) as Hold_BlueChip,                                                                  
	sum(Hold_Good) as Hold_Good,sum(Hold_Poor) as Hold_Poor,sum(Hold_Junk) as Hold_Junk                                                                  
	FROM general.dbo.Vw_RMS_CLIENT_Vertical(nolock) A                                                                   
	INNER JOIN general.dbo.tbl_RMS_collection_CLI B (nolock) on A.Client=B.Party_Code                                      
	GROUP BY A.region,B.Report_Type)A where                                                                  
	[tbl_RMS_collection_region_Hist].Region=A.region and [tbl_RMS_collection_region_Hist].Report_Type=A.Report_Type                                                                  
	AND RMS_DATE=@CurDate                                          
	                                                            
	update TBL_RMS_COLLECTION_REGION_HIST SET                                                                 
	Gross_Collection_Perc=((Gross_Collection/Net)*100)                                             
	where Net <>0  AND            
	Convert(varchar,RMS_DATE,103)=Convert(varchar,GETDATE(),103)                                                                 
	                                              
	--update TBL_RMS_COLLECTION_REGION_HIST  SET                                     
	--Risk_Inc_Dec=A.Risk_Inc_Dec from                                     
	--(                                    
	--select region,Risk_Inc_Dec=Sum(Risk_Inc_Dec) from general.dbo.tbl_RMS_collection_SB group by region) A where                                     
	--TBL_RMS_COLLECTION_REGION_HIST.region=A.region                                    
	--AND RMS_DATE=@CurDate                                        
	                  
	update TBL_RMS_COLLECTION_REGION_HIST SET                   
	Risk_Inc_Dec= (Tot_SBRisk*-1)                  
	where RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	                  
	update TBL_RMS_COLLECTION_REGION_HIST SET                  
	Risk_Inc_Dec= (TBL_RMS_COLLECTION_REGION_HIST.Tot_SBRisk*-1) - (A.Tot_SBRisk*-1) from          
	(select region,sum(Tot_SBRisk) Tot_SBRisk  from TBL_RMS_COLLECTION_REGION_HIST where rms_date = @PrevDate and Report_Type = 'R' group by REGION) A                  
	where TBL_RMS_COLLECTION_REGION_HIST.region=A.region                  
	AND RMS_DATE=@CurDate                   
	and Report_Type = 'R'                  
	                               
	--update TBL_RMS_COLLECTION_REGION_HIST  SET                                       
	--Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_ClientRisk*-1))*100) from                                     
	--(select region,Sum(Tot_ClientRisk) as Tot_ClientRisk from TBL_RMS_COLLECTION_REGION_HIST                                    
	--  where rms_date =@PrevDate  and Tot_ClientRisk<>0 and Report_Type = 'R' group by region) A                    
	--where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                            
	                  
	update TBL_RMS_COLLECTION_REGION_HIST  SET                                       
	Risk_Inc_Dec_perc=((Risk_Inc_Dec/(A.Tot_SBRisk*-1))*100) from                                     
	(select region,Sum(Tot_SBRisk) as Tot_SBRisk from TBL_RMS_COLLECTION_REGION_HIST                                    
	  where rms_date =@PrevDate  and Tot_SBRisk<>0 and Report_Type = 'R' group by region) A                    
	where TBL_RMS_COLLECTION_REGION_HIST.region=A.region AND  RMS_DATE=@CurDate                  
	and Report_Type = 'R'                  
	  
	insert into ORMS_SB_DEPOSIT_hist(Sub_broker,BSECM_Cash,NSECM_Cash,NSEFO_Cash,MCDX_Cash,NCDX_Cash,BSECM_NonCash,  
	NSECM_NonCash,NSEFO_NonCash,MCDX_NonCash,NCDX_NonCash,UpdatedOn,MCD_Cash,NSX_Cash,rms_date)  
	select *,@CurDate  
	from general.dbo.ORMS_SB_DEPOSIT  
	  
	INSERT INTO ASB7_Clidetails_CrDet_Hist  
	SELECT * FROM MIS.DBO.ASB7_Clidetails_crdet  
	WHERE RMS_date < GETDATE()-10  
	  
	DELETE FROM MIS.dbo.ASB7_Clidetails_crdet  
	WHERE RMS_date < GETDATE()-10  
	  
	exec general.dbo.Gen_HistMargVio 'NSEFO'   
	exec general.dbo.Gen_HistMargVio 'MCD'   
	exec general.dbo.Gen_HistMargVio 'NCDEX'  
	exec general.dbo.Gen_HistMargVio 'NSX'   
	exec general.dbo.Gen_HistMargVio 'MCX'  
	  
	exec general.dbo.Gen_HistMarg 'NSEFO'   
	exec general.dbo.Gen_HistMarg 'MCD'   
	exec general.dbo.Gen_HistMarg 'NCDEX'  
	exec general.dbo.Gen_HistMarg 'NSX'   
	exec general.dbo.Gen_HistMarg 'MCX'  
	  
	INSERT INTO CLIENT_COLLATERALS_HIST  
	SELECT co_code,EffDate,Exchange,Segment,Party_Code,Scrip_Cd,Series,Isin,Cl_Rate,Amount,Qty,HairCut,  
	FinalAmount,PercentageCash,PerecntageNonCash,Receive_Date,Maturity_Date,Coll_Type,ClientType,  
	Remarks,LoginName,LoginTime,Cash_Ncash,Group_Code,Fd_Bg_No,Bank_Code,Fd_Type,CONVERT(VARCHAR(11),GETDATE(),106)  
	FROM General.dbo.CLIENT_COLLATERALS  

end try  
begin catch  
	  insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)  
	  select GETDATE(),'UPD_HISTORY_ALL',ERROR_LINE(),ERROR_MESSAGE()  
	    
	  DECLARE @ErrorMessage NVARCHAR(4000);  
	  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());  
	  RAISERROR (@ErrorMessage , 16, 1);  
end catch;  
SET NOCOUNT OFF  
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_EOD
-- --------------------------------------------------




CREATE Proc [dbo].[UPD_HISTORY_EOD]                

as                                

BEGIN    

set nocount ON      

SET XACT_ABORT ON              

begin try      

  --SET ANSI_WARNINGS OFF      

  exec GENERAL.DBO.Upd_NetCollection              

                

  delete from [tbl_RMS_collection_region_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_Branch_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_SB_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_Client_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [ORMS_SB_DEPOSIT_hist] where rms_date=convert(varchar(12),GETDATE())      

  delete from [CLIENT_COLLATERALS_HIST] where rms_date=convert(varchar(12),GETDATE())      

  /*       

  COMMENTED BY SUSHANT SAWANT ON 24 JULY 2012 SINCE IT WAS TAKING LONG TIME AND CSV GENERATION WAS GETTING LATE       

  AND TRIGGER A JOB FOR THAT      

  Exec UPD_HISTORY_ALL      

  */      

  declare @Status varchar(20)      

  set @Status=''      

  exec General.dbo.NRMS_JoBStatus 'UPD_HIST_ALL',@Status  output        

  if(@Status='In Progress')      

  begin      

   print 'job is already running'   

  end      

  else      

  begin      

   EXEC msdb.dbo.sp_start_job 'UPD_HIST_ALL'     

  end            

  --SET ANSI_WARNINGS OFF      

            

 end try      

 begin catch      

  insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)      

  select GETDATE(),'UPD_HISTORY_EOD',ERROR_LINE(),ERROR_MESSAGE()      

        

  DECLARE @ErrorMessage NVARCHAR(4000);      

  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());      

  RAISERROR (@ErrorMessage , 16, 1);      

  end catch;    

  set nocount OFF                   

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_EOD_15012016
-- --------------------------------------------------




CREATE Proc [dbo].[UPD_HISTORY_EOD_15012016]                

as                                

BEGIN    

set nocount ON      

SET XACT_ABORT ON              

begin try      

               

  --SET ANSI_WARNINGS OFF      

  exec GENERAL.DBO.Upd_NetCollection              

                

  delete from [tbl_RMS_collection_region_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_Branch_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_SB_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [tbl_RMS_collection_Client_Hist] where rms_date=convert(varchar(12),GETDATE())                

  delete from [ORMS_SB_DEPOSIT_hist] where rms_date=convert(varchar(12),GETDATE())      

  delete from [CLIENT_COLLATERALS_HIST] where rms_date=convert(varchar(12),GETDATE())      

  /*       

  COMMENTED BY SUSHANT SAWANT ON 24 JULY 2012 SINCE IT WAS TAKING LONG TIME AND CSV GENERATION WAS GETTING LATE       

  AND TRIGGER A JOB FOR THAT      

  Exec UPD_HISTORY_ALL      

  */      

  declare @Status varchar(20)      

  set @Status=''      

  exec General.dbo.NRMS_JoBStatus 'UPD_HIST_ALL',@Status  output        

  if(@Status='In Progress')      

  begin      

   print 'job is already running'   

  end      

  else      

  begin      

   EXEC msdb.dbo.sp_start_job 'UPD_HIST_ALL'     

  end            

  --SET ANSI_WARNINGS OFF      

            

 end try      

 begin catch      

  insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)      

  select GETDATE(),'UPD_HISTORY_EOD',ERROR_LINE(),ERROR_MESSAGE()      

        

  DECLARE @ErrorMessage NVARCHAR(4000);      

  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());      

  RAISERROR (@ErrorMessage , 16, 1);      

  end catch;    

  set nocount OFF                   

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_HISTORY_EOD_DEL
-- --------------------------------------------------


CREATE Proc [dbo].[UPD_HISTORY_EOD_DEL]                
as                                
BEGIN    
set nocount ON      
SET XACT_ABORT ON              
begin try      

  --SET ANSI_WARNINGS OFF      

 /* exec GENERAL.DBO.Upd_NetCollection           */   

  delete from [tbl_RMS_collection_region_Hist] where rms_date=convert(varchar(12),GETDATE())                
  delete from [tbl_RMS_collection_Branch_Hist] where rms_date=convert(varchar(12),GETDATE())                
  delete from [tbl_RMS_collection_SB_Hist] where rms_date=convert(varchar(12),GETDATE())                
  delete from [tbl_RMS_collection_Client_Hist] where rms_date=convert(varchar(12),GETDATE())                
  delete from [ORMS_SB_DEPOSIT_hist] where rms_date=convert(varchar(12),GETDATE())      
  delete from [CLIENT_COLLATERALS_HIST] where rms_date=convert(varchar(12),GETDATE())      

 end try      
begin catch      
  insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)      
  select GETDATE(),'UPD_HISTORY_EOD',ERROR_LINE(),ERROR_MESSAGE()      
  DECLARE @ErrorMessage NVARCHAR(4000);      
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());      
  RAISERROR (@ErrorMessage , 16, 1);      
  end catch;    
  set nocount OFF                   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_Regionwise_Margin_Shortage
-- --------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Upd_Regionwise_Margin_Shortage
	
AS
BEGIN

	insert into tbl_shortage_10days_hist_region
	SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,
	A.VAHC,A.LOGICALLEDGER+A.VAHC as shortage, GETDATE(),1
	 FROM tbl_shortage_10days_hist  A WITH (NOLOCK) 
	where  region in(
	'A P',
	'COIMBATORE',
	'KARNATAKA',
	'KERALA',
	'T N',
	'VKPATNAM') 
	
	insert into tbl_shortage_10days_hist_region_south      
	SELECT A.Zone,A.Region,A.Branch,A.SB,A.clientcategory,A.SBCategory, A.TDATE,A.BACKOFFICECODE,A.LOGICALLEDGER,A.holdingbeforehaircut,
	A.VAHC,A.LOGICALLEDGER+A.VAHC as shortage, GETDATE()-1
	 FROM tbl_shortage_10days_hist  A WITH (NOLOCK) 
	where  A.region in(

	'DELHI',
	'RAJSHTAN',
	'U P',
	'HARYANA',
	'KOLK',
	'M P',
	'PUNJAB')

update A set A.nodays=b.cnt from
(
	select BACKOFFICECODE,cnt=COUNT(A.BACKOFFICECODE),srno=MAX(A.srno)
	from tbl_shortage_10days_hist_region A group by BACKOFFICECODE
)b
 where  A.SrNo=b.srno and BACKOFFICECODE=b.BACKOFFICECODE
 
 
--To remove inconsistent shortage days 
if exists (select COUNT(BACKOFFICECODE) from tbl_shortage_10days_hist_region group by BACKOFFICECODE having COUNT(BACKOFFICECODE)<4)
BEGIN
print 'hii'
 delete from  tbl_shortage_10days_hist_region where BACKOFFICECODE in 
 (
 select  BACKOFFICECODE from 
 (
 select  BACKOFFICECODE,cnt=COUNT(BACKOFFICECODE),srno=MAX(srno)
 from tbl_shortage_10days_hist_region  group by  BACKOFFICECODE having COUNT(BACKOFFICECODE)<=4
 )b
 )
 and process_Date<Convert(datetime,Convert(varchar(11),getdate(),103),103)
END


select * from tbl_shortage_10days_hist_region where nosOfdays=7

select * into #temp from tbl_shortage_10days_hist_region where nosOfdays >4
	
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_Amd_TBL_RMS_COLLECTION_CLIENT_HIST
-- --------------------------------------------------
CREATE procedure usp_Amd_TBL_RMS_COLLECTION_CLIENT_HIST
as
begin

--select * into #TBL_RMS_COLLECTION_CLIENT_HIST from TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)  
--where RMS_DATE>getdate()-90  
--where RMS_DATE=convert(date,getdate())  


insert into TBL_RMS_COLLECTION_CLIENT_HIST_NXT
select Client,RMS_DATE ,
  convert(decimal(15,2),SUM(ISNULL(BSE_Ledger, 0))/100000) as [BSECM],
  convert(decimal(15,2),SUM(ISNULL(NSE_Ledger, 0))/100000) as [NSECM],  
  convert(decimal(15,2),SUM(NSEFO_Ledger)/100000) as [NSEFO],convert(decimal(15,2),SUM(MCD_Ledger)/100000) as [MCD],  
  convert(decimal(15,2),SUM(NCDEX_Ledger)/100000) as [NCDEX],convert(decimal(15,2),SUM(MCX_Ledger)/100000) as [MCX],  
  convert(decimal(15,2),SUM(NSX_Ledger)/100000) as [NSX],convert(decimal(15,2),SUM(NBFC_Ledger)/100000) as [NBFC],  
  convert(decimal(15,2),SUM(Deposit)/100000) as [Deposit  (Cli)],convert(decimal(15,2),SUM(ISNULL(Net_Debit, 0))/100000) as [Net Debit],  
  Convert(varchar,RMS_DATE,106) as [History Date],  convert(decimal(15,2),SUM(ISNULL(Net_Collection, 0))/100000) as [Net Collection],
  convert(decimal(15,2),SUM(ISNULL(Gross_Collection, 0))/100000) as [Gross Collection],  
  convert(decimal(15,2),SUM(ISNULL(Hold_BlueChip, 0))/100000) as [BlueChip],convert(decimal(15,2),SUM(Hold_Good)/100000) as [Good],  
  convert(decimal(15,2),SUM(ISNULL(Hold_Poor, 0))/100000) as [Average],convert(decimal(15,2),SUM(Hold_Junk)/100000) as [Poor], 
  convert(decimal(15,2),SUM(Hold_Total)/100000) as [Total  Holding],convert(decimal(15,2),SUM(Coll_Total)/100000) as [Total Collateral],
  convert(decimal(15,2),SUM(Exp_Gross)/100000) as [Gross Exposure],convert(decimal(15,2),SUM(Margin_Total)/100000) as [Total Margin], 
  convert(decimal(15,2),SUM(Pure_Risk)/100000) as [Pure Risk],convert(decimal(15,2),SUM(Proj_Risk)/100000) as [SB Proj. Risk], 
  convert(decimal(15,2),SUM(UnReco_Credit)/100000) as [UnReco. Credit]  
--Into TBL_RMS_COLLECTION_CLIENT_HIST_NXT
from TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)  
where RMS_DATE>getdate()-90  
  group by Client,RMS_DATE 


End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_amd_TBL_RMS_COLLECTION_CLIENT_HIST_NXT_New
-- --------------------------------------------------

Create Procedure usp_amd_TBL_RMS_COLLECTION_CLIENT_HIST_NXT_New 
as
begin

insert into TBL_RMS_COLLECTION_CLIENT_HIST_NXT_New 
Select * from 
TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)  
where RMS_DATE>getdate()-90  


end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
create PROCEDURE [dbo].[usp_findInUSP]              
 @DBNAME VARCHAR(500),            
 @SRCSTR VARCHAR(500)              
AS              
              
 SET NOCOUNT ON            
 SET @SRCSTR  = '%' + @SRCSTR + '%'              
            
 DECLARE @STR AS VARCHAR(1000),@xdbname as varchar(500)            

 set @xdbname=@DBNAME

 SET @STR=''            
 IF @DBNAME <>''            
 BEGIN            
 SET @DBNAME=@DBNAME+'.DBO.'            
 END            
 ELSE            
 BEGIN            
 SET @DBNAME=DB_NAME()+'.DBO.'            
 END            
 ----PRINT @DBNAME            
            
 SET @STR='SELECT DISTINCT '''+@xdbname+''' as DBNAME,O.NAME,O.XTYPE FROM '+@DBNAME+'SYSCOMMENTS  C '             
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '             
 SET @STR=@STR+' WHERE O.XTYPE IN (''P'',''V'') AND C.TEXT LIKE '''+@SRCSTR+''''              
-- PRINT @STR            
  EXEC(@STR)            
    
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetHoldingNetoffRiskReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_GetHoldingNetoffRiskReport]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM history.dbo.tbl_Proj_risk_Holding_netoff_Final_Hist
    WHERE CONVERT(DATE, Upd_date) 
          BETWEEN CAST(DATEADD(DAY, -10, GETDATE()) AS DATE)
              AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetVarshortageRiskReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[usp_GetVarshortageRiskReport]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM history.dbo.tbl_projRisk_Varshortage_Hist
    WHERE CONVERT(DATE, Upd_date) 
          BETWEEN CAST(DATEADD(DAY, -10, GETDATE()) AS DATE)
              AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw_Rms_Holding_WithHC_DATA
-- --------------------------------------------------
CREATE proc Vw_Rms_Holding_WithHC_DATA(@pcode as varchar(10),@fdate as varchar(11))  
AS  
    SELECT A.*,  
         HairCut=(  
                CASE WHEN EXCHANGE = 'NSECM'  
                     THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                     WHEN EXCHANGE = 'BSECM'  
                     THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                     WHEN EXCHANGE = 'POA'  
                     THEN  
                        CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)  
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                             WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)  
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                             ELSE 100  
                        END  
                     ELSE 100  
                END  
            ) ,  
         total_WithHC=  
              CASE WHEN QTY > 0  
                    THEN(CLSRATE*(QTY+ISNULL(ADJQTY,0)))-((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*((  
                        CASE WHEN EXCHANGE = 'NSECM'  
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                             WHEN EXCHANGE = 'BSECM'  
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                             WHEN EXCHANGE = 'POA'  
                             THEN  
                                CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)  
                                     THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                                     WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)  
                                     THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                                     ELSE 100  
                                END  
                             ELSE 100  
                        END)/100.00))  
                    ELSE (CLSRATE*(QTY+ISNULL(ADJQTY,0)))+((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*(ISNULL(A.SHRT_HC,100.00)/100.00))  
              END,  
         ExchangeHairCut=(  
                CASE WHEN EXCHANGE = 'NSECM'  
                     THEN ISNULL(B.NSE_VAR, 100)  
                     WHEN EXCHANGE = 'BSECM'  
                     THEN ISNULL(B.BSE_VAR, 100)  
                     WHEN EXCHANGE = 'POA'  
                     THEN  
                        CASE WHEN ISNULL(B.BSE_VAR, 100) >= ISNULL(B.NSE_VAR, 100)  
                             THEN ISNULL(B.BSE_VAR, 100)  
                             WHEN ISNULL(B.BSE_VAR, 100) < ISNULL(B.NSE_VAR, 100)  
                             THEN ISNULL(B.NSE_VAR, 100)  
                             ELSE 100  
                        END  
                     ELSE 100  
                END)  
    FROM  
    (  
         SELECT P.*,Q.SHRT_HC 
         FROM (
         SELECT *,uDATE=CONVERT(DATETIME,CONVERT(VARCHAR(11),UPD_DATE)) FROM RMS_HOLDING (NOLOCK) 
         WHERE party_Code=@PCODE AND UPD_DATE >=convert(datetime,@FDATE)-1 AND UPD_DATE <=convert(datetime,@FDATE+' 23:59:59')-1
         )P  
         
            INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q  
                ON --CASE WHEN P.EXCHANGE = 'POA' THEN 'DP' ELSE P.EXCHANGE END =Q.CO_CODE  
                    P.EXCHANGE = CASE WHEN Q.CO_CODE = 'DP' THEN 'POA' ELSE Q.CO_CODE END  
    ) A  
        LEFT OUTER JOIN  
            ScripVaR_Master_Hist (NOLOCK) B  
                ON  A.ISIN=B.ISIN  
                AND A.uDATE = B.PROCESS_DATE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Vw_Rms_Holding_WithHC_DATA_archived
-- --------------------------------------------------
CREATE proc Vw_Rms_Holding_WithHC_DATA_archived(@pcode as varchar(10),@fdate as varchar(11))  
AS  
Begin
	SELECT *,uDATE=CONVERT(DATETIME,CONVERT(VARCHAR(11),UPD_DATE)) into #rms_holding_archived FROM [196.1.115.240].NRMS_ARCHIVAL_NEW.DBO.RMS_HOLDING 
		WHERE party_Code=@PCODE AND UPD_DATE >=convert(datetime,@FDATE)-1 AND UPD_DATE <=convert(datetime,@FDATE+' 23:59:59')-1
    SELECT A.*,  
         HairCut=(  
                CASE WHEN EXCHANGE = 'NSECM'  
                     THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                     WHEN EXCHANGE = 'BSECM'  
                     THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                     WHEN EXCHANGE = 'POA'  
                     THEN  
                        CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)  
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                             WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)  
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                             ELSE 100  
                        END  
                     ELSE 100  
                END  
            ) ,  
         total_WithHC=  
              CASE WHEN QTY > 0  
                    THEN(CLSRATE*(QTY+ISNULL(ADJQTY,0)))-((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*((  
                        CASE WHEN EXCHANGE = 'NSECM'  
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                             WHEN EXCHANGE = 'BSECM'  
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                             WHEN EXCHANGE = 'POA'  
                             THEN  
                                CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)  
                                     THEN ISNULL(B.BSE_PROJ_VAR, 100)  
                                     WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)  
                                     THEN ISNULL(B.NSE_PROJ_VAR, 100)  
                                     ELSE 100  
                                END  
                             ELSE 100  
                        END)/100.00))  
                    ELSE (CLSRATE*(QTY+ISNULL(ADJQTY,0)))+((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*(ISNULL(A.SHRT_HC,100.00)/100.00))  
              END,  
         ExchangeHairCut=(  
                CASE WHEN EXCHANGE = 'NSECM'  
                     THEN ISNULL(B.NSE_VAR, 100)  
                     WHEN EXCHANGE = 'BSECM'  
                     THEN ISNULL(B.BSE_VAR, 100)  
                     WHEN EXCHANGE = 'POA'  
                     THEN  
                        CASE WHEN ISNULL(B.BSE_VAR, 100) >= ISNULL(B.NSE_VAR, 100)  
                             THEN ISNULL(B.BSE_VAR, 100)  
                             WHEN ISNULL(B.BSE_VAR, 100) < ISNULL(B.NSE_VAR, 100)  
                             THEN ISNULL(B.NSE_VAR, 100)  
                             ELSE 100  
                        END  
                     ELSE 100  
                END)  
    FROM  
    (  
         SELECT P.*,Q.SHRT_HC 
         FROM #rms_holding_archived P  
         
            INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q  
                ON --CASE WHEN P.EXCHANGE = 'POA' THEN 'DP' ELSE P.EXCHANGE END =Q.CO_CODE  
                    P.EXCHANGE = CASE WHEN Q.CO_CODE = 'DP' THEN 'POA' ELSE Q.CO_CODE END  
    ) A  
        LEFT OUTER JOIN  
            ScripVaR_Master_Hist (NOLOCK) B  
                ON  A.ISIN=B.ISIN  
                AND A.uDATE = B.PROCESS_DATE  


ENd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WC_Ageing
-- --------------------------------------------------

CREATE procedure WC_Ageing (@days as int, @aboveRs as money)  
as  
  
/*  
exec WC_Ageing 31,100  
*/  
set nocount on  
/*
declare @days as int, @aboveRs as money
set @days =15
set @aboveRs = 0
*/
set @days =@days+1  


select top 0 * into #RMS_DtclFi_summ from RMS_DtclFi_summ with (nolock)

insert into #RMS_DtclFi_summ         
select                                                     
RMS_date=max(Rms_date),Branch_cd,Sub_Broker,Party_code,Party_name=max(party_name),                                                    
Ledger=sum(ledger),Deposit=sum(Deposit),IMargin=sum(imargin),Cash_Colleteral=sum(Cash_Colleteral),                                                    
NonCash_Colleteral=sum(NonCash_Colleteral),Holding_total=sum(Holding_total),                                                    
Holding_Approved=sum(Holding_Approved),Holding_NonApproved=sum(Holding_NonApproved),                                                    
Other_Credit=sum(Other_Credit),Other_Deposit=sum(Other_Deposit),                                                    
MTM_Loss_Act=sum(MTM_Loss_Act),MTM_Loss_Proj=sum(MTM_Loss_Proj),MTM_Profit_Act=sum(MTM_Profit_Act),                                                    
NoDel_Loss=sum(NoDel_Loss),NoDel_Profit=sum(NoDel_Profit),Unrecosiled_Credit=sum(Unrecosiled_Credit),                                                    
MTM_Profit_Proj=sum(MTM_Profit_Proj),                                          
IMargin_Shortage_value=sum(case when IMargin_Shortage_value > 0 then IMargin_Shortage_value else 0 end),                                                           
IMargin_Shortage_percent=(sum(Case when IMargin_Shortage_value > 0 then IMargin_Shortage_value else 1 end)*100.00)/sum(case when Imargin > 0 then Imargin else 1 end),                                        
LastBillDate=max(LastBillDate),LastDrCrDays=max(LastDrCrDays),Net=sum(brk_net),                                                  
ProjRisk=convert(money,0),PureRisk=convert(money,0),exposure=sum(exposure),DrNoOfDays=convert(int,0)                                                    
from general.dbo.Vw_RmsDtclFi_Collection a (nolock) where exists (
select co_Code from general.dbo.company b (nolock) where co_code in ('BSECM','NSECM','NSEFO','MCD','NSX') 
and a.co_code=b.co_code
)                                                    
group by Branch_cd,Sub_Broker,Party_code                                                    
                                                    
update #RMS_DtclFi_summ set IMargin_Shortage_percent=100 where IMargin_Shortage_percent > 100                                          
update #RMS_DtclFi_summ set IMargin_Shortage_percent=0 where IMargin_Shortage_value=0                                        
  
select RMS_DATE,Party_Code,Net into #DrAsOnDt from #rms_dtclfi_summ with (nolock) where Net < 0  

/*---- HISTORY ---- */
  
select top 0 * into #RMS_DtclFi_hist from RMS_DtclFi_summ with (nolock)

insert into #RMS_DtclFi_hist         
select                                                     
RMS_date=max(Rms_date),Branch_cd,Sub_Broker,Party_code,Party_name=max(party_name),                                                    
Ledger=sum(ledger),Deposit=sum(Deposit),IMargin=sum(imargin),Cash_Colleteral=sum(Cash_Colleteral),                                                    
NonCash_Colleteral=sum(NonCash_Colleteral),Holding_total=sum(Holding_total),                                                    
Holding_Approved=sum(Holding_Approved),Holding_NonApproved=sum(Holding_NonApproved),                                                    
Other_Credit=sum(Other_Credit),Other_Deposit=sum(Other_Deposit),                                                    
MTM_Loss_Act=sum(MTM_Loss_Act),MTM_Loss_Proj=sum(MTM_Loss_Proj),MTM_Profit_Act=sum(MTM_Profit_Act),                                                    
NoDel_Loss=sum(NoDel_Loss),NoDel_Profit=sum(NoDel_Profit),Unrecosiled_Credit=sum(Unrecosiled_Credit),                                                    
MTM_Profit_Proj=sum(MTM_Profit_Proj),                                          
IMargin_Shortage_value=sum(case when IMargin_Shortage_value > 0 then IMargin_Shortage_value else 0 end),                                                           
IMargin_Shortage_percent=(sum(Case when IMargin_Shortage_value > 0 then IMargin_Shortage_value else 1 end)*100.00)/sum(case when Imargin > 0 then Imargin else 1 end),                                        
LastBillDate=max(LastBillDate),LastDrCrDays=max(LastDrCrDays),Net=sum(brk_net),                                                  
ProjRisk=convert(money,0),PureRisk=convert(money,0),exposure=sum(exposure),DrNoOfDays=convert(int,0)                                                    
from history.dbo.Vw_RmsDtclFi_Collection a (nolock) where  rms_date > getdate()-@days and exists (
select co_Code from general.dbo.company b (nolock) where co_code in ('BSECM','NSECM','NSEFO','MCD','NSX') 
and a.co_code=b.co_code
)                                                    
group by Branch_cd,Sub_Broker,Party_code                                                    
                                                    
update #RMS_DtclFi_hist set IMargin_Shortage_percent=100 where IMargin_Shortage_percent > 100                                          
update #RMS_DtclFi_hist set IMargin_Shortage_percent=0 where IMargin_Shortage_value=0                                        
  
 
select a.* into #DrLast30Days from  
(select RMS_DAte,Party_Code,Net from #RMS_DtclFi_hist with (nolock)) a,   
#DrAsOnDt b where a.party_Code=b.party_Code  
  
select Party_code,Max(Net) as MaxNet into #temp1 from #DrLast30Days group by party_code  
  
create clustered index idxpty on #DrLast30Days (Party_code)  
create clustered index idxpty on #temp1 (Party_code)  
  
  
select Max(RMS_Date) as RMS_date,a.PArty_Code,Max(Net) as Net,MAxNet  
into #MinDr30Days   
from #DrLast30Days a, #temp1 b where a.party_code=b.party_code and a.Net=b.MaxNet  
group by  a.party_code,MaxNet  
  
select a.*,b.rms_date as MinBalDay,  
(Case when a.Net > isnull(b.Net,0) then a.Net else isnull(b.Net,0) end) as DrLast30Days  
into #Final  
from #DrAsOnDt a left outer join #MinDr30Days b on a.party_code=b.party_code  


  
select * from #final where DrLast30Days < @aboveRs /* Only for Debit clients */  
and party_code in  
(select distinct party_code from general.dbo.vw_Party_Pledge_Dtl where pledgeqty <> 0)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.WC_Ageing_Calc
-- --------------------------------------------------
Create proc WC_Ageing_Calc
as
truncate table WC_Ageing_Tbl
exec WC_Ageing 15,0
exec WC_Ageing 30,0

GO

-- --------------------------------------------------
-- TABLE dbo.A
-- --------------------------------------------------
CREATE TABLE [dbo].[A]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [Region] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [shortage] MONEY NULL,
    [nodays] INT NULL,
    [process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ALG_FINALLIMIT_COMPANYWISE_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST]
(
    [ZONE] VARCHAR(25) NULL,
    [REGION] VARCHAR(20) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CLIENT_CATEGORY] VARCHAR(10) NULL,
    [CLIENT_TYPE] VARCHAR(10) NULL,
    [CL_TYPE] VARCHAR(10) NULL,
    [SB_CATEGORY] VARCHAR(25) NULL,
    [ALM] DECIMAL(15, 2) NULL,
    [ALM_HLD_COLL] BIT NULL,
    [EQDECR] DECIMAL(15, 2) NULL,
    [OPLM] DECIMAL(15, 2) NULL,
    [COLM] DECIMAL(15, 2) NULL,
    [COLM_NBFC] DECIMAL(15, 2) NULL,
    [LMT_HLD_COLL] BIT NULL,
    [COLM_HLD_COLL] BIT NULL,
    [OPLM_HLD_COLL] BIT NULL,
    [HLD_COLL_HC_BLUECHIP] INT NULL,
    [HLD_COLL_HC_GOOD] INT NULL,
    [HLD_COLL_HC_AVERAGE] INT NULL,
    [HLD_COLL_HC_POOR] INT NULL,
    [MTM_LMT_PERC] DECIMAL(19, 6) NULL,
    [POA_ALLOWED] BIT NULL,
    [RISK_GRT_MIN_LMT] DECIMAL(15, 2) NULL,
    [BLOCK_MIN_LMT] BIT NULL,
    [MIN_LIM_EQDECR] DECIMAL(15, 2) NULL,
    [MIN_LIM_COLM] DECIMAL(15, 2) NULL,
    [MIN_LIM_COLM_NBFC] DECIMAL(15, 2) NULL,
    [MIN_LIM_ALLEXC] DECIMAL(15, 2) NULL,
    [UN_RECO_CR_LMT] BIT NULL,
    [UN_RECO_LIMIT] DECIMAL(15, 2) NULL,
    [DEF_QTY] INT NULL,
    [DEF_VAL] DECIMAL(15, 2) NULL,
    [ALLExch_ALLOW_UNRECO_CR] BIT NULL,
    [ABL_ALLOW_UNRECO_CR] BIT NULL,
    [ACBPL_ALLOW_UNRECO_CR] BIT NULL,
    [BSE_LEDGER] MONEY NOT NULL,
    [NSE_LEDGER] MONEY NOT NULL,
    [NSEFO_LEDGER] MONEY NOT NULL,
    [BSEFO_LEDGER] MONEY NOT NULL,
    [MCD_LEDGER] MONEY NOT NULL,
    [NSX_LEDGER] MONEY NOT NULL,
    [MCX_LEDGER] MONEY NOT NULL,
    [NCDEX_LEDGER] MONEY NOT NULL,
    [NBFC_LEDGER] MONEY NOT NULL,
    [NET_LEDGER] MONEY NOT NULL,
    [BSE_DEPOSIT] MONEY NOT NULL,
    [NSE_DEPOSIT] MONEY NOT NULL,
    [NSEFO_DEPOSIT] MONEY NOT NULL,
    [BSEFO_DEPOSIT] MONEY NOT NULL,
    [MCD_DEPOSIT] MONEY NOT NULL,
    [NSX_DEPOSIT] MONEY NOT NULL,
    [MCX_DEPOSIT] MONEY NOT NULL,
    [NCDEX_DEPOSIT] MONEY NOT NULL,
    [NBFC_DEPOSIT] MONEY NOT NULL,
    [NET_DEPOSIT] MONEY NOT NULL,
    [BSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [BSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [MCD_UNRECO_CREDIT] MONEY NOT NULL,
    [NSX_UNRECO_CREDIT] MONEY NOT NULL,
    [MCX_UNRECO_CREDIT] MONEY NOT NULL,
    [NCDEX_UNRECO_CREDIT] MONEY NOT NULL,
    [NBFC_UNRECO_CREDIT] MONEY NOT NULL,
    [NET_UNRECO_CREDIT] MONEY NOT NULL,
    [HOLD_BLUECHIP] MONEY NULL,
    [HOLD_GOOD] MONEY NULL,
    [HOLD_POOR] MONEY NULL,
    [HOLD_JUNK] MONEY NULL,
    [HOLD_TOTAL] MONEY NULL,
    [HOLD_TOTAL_WO_HC] MONEY NULL,
    [HOLD_TOTAL_NEGATIVE] MONEY NULL,
    [NBFC_HOLD_TOTAL] MONEY NULL,
    [NBFC_HOLD_WO_HC] MONEY NULL,
    [COLL_NSEFO] MONEY NOT NULL,
    [COLL_BSEFO] MONEY NOT NULL,
    [COLL_MCD] MONEY NOT NULL,
    [COLL_NSX] MONEY NOT NULL,
    [COLL_MCX] MONEY NOT NULL,
    [COLL_NCDEX] MONEY NOT NULL,
    [COLL_TOTAL] MONEY NOT NULL,
    [ABL_COLL_TOTAL_WO_HC] MONEY NULL,
    [ACBPL_COLL_TOTAL_WO_HC] MONEY NULL,
    [CASH_COLL_NSEFO] MONEY NOT NULL,
    [CASH_COLL_BSEFO] MONEY NOT NULL,
    [CASH_COLL_MCD] MONEY NOT NULL,
    [CASH_COLL_NSX] MONEY NOT NULL,
    [CASH_COLL_MCX] MONEY NOT NULL,
    [CASH_COLL_NCDEX] MONEY NOT NULL,
    [CASHCOLL_TOTAL] MONEY NOT NULL,
    [PURE_RISK] MONEY NOT NULL,
    [POA] MONEY NOT NULL,
    [POA_WO_HC] MONEY NULL,
    [ALLExch_LIMITVALUE] MONEY NULL,
    [ABL_LIMITVALUE] MONEY NULL,
    [ACBPL_LIMITVALUE] MONEY NULL,
    [ALLExch_LIMITVALUE_WO_HC] MONEY NULL,
    [ABL_LIMITVALUE_WO_HC] MONEY NULL,
    [ACBPL_LIMITVALUE_WO_HC] MONEY NULL,
    [ALLExch_FINAL_LIMITVALUE] MONEY NULL,
    [EQ_FINAL_LIMITVALUE] MONEY NULL,
    [CURR_FINAL_LIMITVALUE] MONEY NULL,
    [COMMO_FINAL_LIMITVALUE] MONEY NULL,
    [MASTER_SETTING] VARCHAR(100) NULL,
    [UPDATE_DATE] DATETIME NOT NULL,
    [ACTIVITIES] VARCHAR(40) NULL,
    [INSERTDATE] DATETIME NOT NULL,
    [Intraday_Allowed] BIT NULL,
    [Intraday_Type] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE
-- --------------------------------------------------
CREATE TABLE [dbo].[ALG_FINALLIMIT_COMPANYWISE_HIST_ARCHIVE]
(
    [ZONE] VARCHAR(25) NULL,
    [REGION] VARCHAR(10) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [CLIENT_CATEGORY] VARCHAR(10) NULL,
    [CLIENT_TYPE] VARCHAR(10) NULL,
    [SB_CATEGORY] VARCHAR(10) NULL,
    [ALM] NUMERIC(15, 2) NULL,
    [ALM_HLD_COLL] BIT NULL,
    [OPLM] NUMERIC(15, 2) NULL,
    [OPLM_HLD_COLL] BIT NULL,
    [COLM] NUMERIC(15, 2) NULL,
    [COLM_HLD_COLL] BIT NULL,
    [HLD_COLL_HC_BLUECHIP] INT NULL,
    [HLD_COLL_HC_GOOD] INT NULL,
    [HLD_COLL_HC_AVERAGE] INT NULL,
    [HLD_COLL_HC_POOR] INT NULL,
    [MTM_LMT_PERC] NUMERIC(15, 2) NULL,
    [POA_ALLOWED] BIT NULL,
    [RISK_GRT_MIN_LMT] NUMERIC(15, 2) NULL,
    [BLOCK_MIN_LMT] BIT NULL,
    [MIN_LMT] NUMERIC(15, 2) NULL,
    [UN_RECO_CR_LMT] BIT NULL,
    [UN_RECO_LIMIT] NUMERIC(15, 2) NULL,
    [DEF_QTY] INT NULL,
    [DEF_VAL] NUMERIC(15, 2) NULL,
    [ABL_ALLOW_UNRECO_CR] BIT NULL,
    [ACBPL_ALLOW_UNRECO_CR] BIT NULL,
    [BSE_LEDGER] MONEY NOT NULL,
    [NSE_LEDGER] MONEY NOT NULL,
    [NSEFO_LEDGER] MONEY NOT NULL,
    [BSEFO_LEDGER] MONEY NOT NULL,
    [MCD_LEDGER] MONEY NOT NULL,
    [NSX_LEDGER] MONEY NOT NULL,
    [MCX_LEDGER] MONEY NOT NULL,
    [NCDEX_LEDGER] MONEY NOT NULL,
    [NBFC_LEDGER] MONEY NOT NULL,
    [NET_LEDGER] MONEY NOT NULL,
    [BSE_DEPOSIT] MONEY NOT NULL,
    [NSE_DEPOSIT] MONEY NOT NULL,
    [NSEFO_DEPOSIT] MONEY NOT NULL,
    [BSEFO_DEPOSIT] MONEY NOT NULL,
    [MCD_DEPOSIT] MONEY NOT NULL,
    [NSX_DEPOSIT] MONEY NOT NULL,
    [MCX_DEPOSIT] MONEY NOT NULL,
    [NCDEX_DEPOSIT] MONEY NOT NULL,
    [NBFC_DEPOSIT] MONEY NOT NULL,
    [NET_DEPOSIT] MONEY NOT NULL,
    [BSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSE_UNRECO_CREDIT] MONEY NOT NULL,
    [NSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [BSEFO_UNRECO_CREDIT] MONEY NOT NULL,
    [MCD_UNRECO_CREDIT] MONEY NOT NULL,
    [NSX_UNRECO_CREDIT] MONEY NOT NULL,
    [MCX_UNRECO_CREDIT] MONEY NOT NULL,
    [NCDEX_UNRECO_CREDIT] MONEY NOT NULL,
    [NBFC_UNRECO_CREDIT] MONEY NOT NULL,
    [NET_UNRECO_CREDIT] MONEY NOT NULL,
    [HOLD_BLUECHIP] MONEY NULL,
    [HOLD_GOOD] MONEY NULL,
    [HOLD_POOR] MONEY NULL,
    [HOLD_JUNK] MONEY NULL,
    [HOLD_TOTAL] MONEY NULL,
    [COLL_NSEFO] MONEY NOT NULL,
    [COLL_BSEFO] MONEY NOT NULL,
    [COLL_MCD] MONEY NOT NULL,
    [COLL_NSX] MONEY NOT NULL,
    [COLL_MCX] MONEY NOT NULL,
    [COLL_NCDEX] MONEY NOT NULL,
    [COLL_TOTAL] MONEY NOT NULL,
    [CASH_COLL_NSEFO] MONEY NOT NULL,
    [CASH_COLL_BSEFO] MONEY NOT NULL,
    [CASH_COLL_MCD] MONEY NOT NULL,
    [CASH_COLL_NSX] MONEY NOT NULL,
    [CASH_COLL_MCX] MONEY NOT NULL,
    [CASH_COLL_NCDEX] MONEY NOT NULL,
    [CASHCOLL_TOTAL] MONEY NOT NULL,
    [PURE_RISK] MONEY NOT NULL,
    [POA] MONEY NOT NULL,
    [ABL_LIMITVALUE] MONEY NULL,
    [ACBPL_LIMITVALUE] MONEY NULL,
    [EQ_FINAL_LIMITVALUE] MONEY NULL,
    [CURR_FINAL_LIMITVALUE] MONEY NULL,
    [COMMO_FINAL_LIMITVALUE] MONEY NULL,
    [MASTER_SETTING] VARCHAR(100) NULL,
    [UPDATE_DATE] DATETIME NOT NULL,
    [ACTIVITIES] VARCHAR(40) NULL,
    [INSERTDATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ALG_FINALLIMIT_HIST_ARCHIVE
-- --------------------------------------------------
CREATE TABLE [dbo].[ALG_FINALLIMIT_HIST_ARCHIVE]
(
    [zone] VARCHAR(25) NOT NULL,
    [region] VARCHAR(10) NOT NULL,
    [branch] VARCHAR(10) NOT NULL,
    [sb] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [party_name] VARCHAR(100) NOT NULL,
    [client_category] VARCHAR(10) NOT NULL,
    [client_type] VARCHAR(10) NOT NULL,
    [sb_category] VARCHAR(10) NOT NULL,
    [ALM] DECIMAL(15, 2) NOT NULL,
    [ALM_HLD_COLL] BIT NOT NULL,
    [OPLM] DECIMAL(15, 2) NOT NULL,
    [OPLM_HLD_COLL] BIT NOT NULL,
    [COLM] DECIMAL(15, 2) NOT NULL,
    [COLM_HLD_COLL] BIT NOT NULL,
    [HLD_COLL_HC_BLUECHIP] INT NOT NULL,
    [HLD_COLL_HC_GOOD] INT NOT NULL,
    [HLD_COLL_HC_AVERAGE] INT NOT NULL,
    [HLD_COLL_HC_POOR] INT NOT NULL,
    [MTM_LMT_PERC] DECIMAL(15, 2) NOT NULL,
    [POA_ALLOWED] BIT NOT NULL,
    [RISK_GRT_MIN_LMT] DECIMAL(15, 2) NOT NULL,
    [BLOCK_MIN_LMT] BIT NOT NULL,
    [MIN_LMT] DECIMAL(15, 2) NOT NULL,
    [UN_RECO_CR_LMT] BIT NOT NULL,
    [UN_RECO_LIMIT] DECIMAL(15, 2) NOT NULL,
    [DEF_QTY] INT NOT NULL,
    [DEF_VAL] DECIMAL(15, 2) NOT NULL,
    [BSE_Ledger] MONEY NOT NULL,
    [NSE_Ledger] MONEY NOT NULL,
    [NSEFO_Ledger] MONEY NOT NULL,
    [MCD_Ledger] MONEY NOT NULL,
    [NSX_Ledger] MONEY NOT NULL,
    [MCX_Ledger] MONEY NOT NULL,
    [NCDEX_Ledger] MONEY NOT NULL,
    [NBFC_Ledger] MONEY NOT NULL,
    [Net_Ledger] MONEY NOT NULL,
    [UnReco_Credit] MONEY NOT NULL,
    [Hold_BlueChip] MONEY NOT NULL,
    [Hold_Good] MONEY NOT NULL,
    [Hold_Poor] MONEY NOT NULL,
    [Hold_Junk] MONEY NOT NULL,
    [Hold_Total] MONEY NOT NULL,
    [Coll_NSEFO] MONEY NOT NULL,
    [Coll_MCD] MONEY NOT NULL,
    [Coll_NSX] MONEY NOT NULL,
    [Coll_MCX] MONEY NOT NULL,
    [Coll_NCDEX] MONEY NOT NULL,
    [Coll_Total] MONEY NOT NULL,
    [CashColl_Total] MONEY NOT NULL,
    [Pure_Risk] MONEY NOT NULL,
    [POA] MONEY NOT NULL,
    [AllExLimitValue] MONEY NOT NULL,
    [OptLimitValue] MONEY NOT NULL,
    [CommoLimitValue] MONEY NOT NULL,
    [InsertDate] DATETIME NOT NULL,
    [Master_Setting] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_Clidetails_CrDet_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_Clidetails_CrDet_Hist]
(
    [RMS_date] DATETIME NULL,
    [party_code] VARCHAR(10) NULL,
    [Ledger] MONEY NULL,
    [Holding] MONEY NULL,
    [FO_Net] MONEY NULL,
    [Curr_Net] MONEY NULL,
    [Category] VARCHAR(10) NULL,
    [Row_num] BIGINT NULL,
    [PledgeAmt] MONEY NULL,
    [Bucket_001] MONEY NULL,
    [Bucket_002] MONEY NULL,
    [Bucket_003] MONEY NULL,
    [Bucket_004] MONEY NULL,
    [Bucket_005] MONEY NULL,
    [Bucket_006] MONEY NULL,
    [Bucket_007] MONEY NULL,
    [Net7Dr] MONEY NULL,
    [T_day] INT NOT NULL,
    [T_VAlue] MONEY NOT NULL,
    [SB_type] VARCHAR(10) NULL,
    [FO_ExColl] MONEY NULL,
    [Curr_ExColl] MONEY NULL,
    [Comm_ExColl] MONEY NULL,
    [BSECM_7Cr] MONEY NULL,
    [NSECM_7Cr] MONEY NULL,
    [BSECM7Dr] MONEY NULL,
    [NSECM7Dr] MONEY NULL,
    [Computed_Net] MONEY NULL,
    [final_net] MONEY NULL,
    [SqOffValue] MONEY NULL,
    [Prev_T_day] INT NULL,
    [BSECM_ledger] MONEY NULL,
    [NSECM_ledger] MONEY NULL,
    [MCD_NET] MONEY NULL,
    [NSX_NET] MONEY NULL,
    [MCD_Excess_Coll] MONEY NULL,
    [NSX_Excess_Coll] MONEY NULL,
    [action] INT NULL,
    [JV_Amt] MONEY NULL,
    [SQ_Amt] MONEY NULL,
    [PAN_Valid] INT NULL,
    [MOBILE_Valid] INT NULL,
    [MCX_NET] MONEY NULL,
    [NCDEX_NET] MONEY NULL,
    [MCX_Excess_Coll] MONEY NULL,
    [NCDEX_Excess_Coll] MONEY NULL,
    [Comm_Net] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_ExcludedReason_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_ExcludedReason_Hist]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [Reason] VARCHAR(25) NOT NULL,
    [currdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_ExcludedReason_Hist_Process2
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_ExcludedReason_Hist_Process2]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [Reason] VARCHAR(25) NOT NULL,
    [currdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_ExcludedReason_Hist_version2
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_ExcludedReason_Hist_version2]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [Reason] VARCHAR(25) NOT NULL,
    [currdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist]
(
    [Row_num] BIGINT NULL,
    [party_code] VARCHAR(10) NULL,
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [ScripCategory] VARCHAR(20) NULL,
    [exchange] VARCHAR(10) NULL,
    [ActQty] FLOAT NULL,
    [Clsrate] MONEY NULL,
    [Total] MONEY NULL,
    [source] VARCHAR(2) NULL,
    [holding] MONEY NULL,
    [T_Value] MONEY NOT NULL,
    [SqQty] INT NULL,
    [FSeqFlag] INT NOT NULL,
    [SeqFlag] INT NOT NULL,
    [srno] INT NOT NULL,
    [sett_no] VARCHAR(10) NULL,
    [T_VALUE_DUMMY] MONEY NOT NULL,
    [DENSE_SR] BIGINT NULL,
    [DIFF_SR_NO] INT NOT NULL,
    [START_VALUE] MONEY NULL,
    [DIFF_AMT] MONEY NULL,
    [DR_ADJ] MONEY NULL,
    [DR_ALLOCATION] MONEY NULL,
    [exch] VARCHAR(10) NULL,
    [Act_SquareUp_Total] MONEY NULL,
    [Act_SquareUp_Qty] FLOAT NULL,
    [REMARKS] VARCHAR(100) NULL,
    [dumped_on] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist_Process2
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist_Process2]
(
    [Row_num] BIGINT NULL,
    [party_code] VARCHAR(10) NULL,
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [ScripCategory] VARCHAR(20) NULL,
    [exchange] VARCHAR(10) NULL,
    [ActQty] FLOAT NULL,
    [Clsrate] MONEY NULL,
    [Total] MONEY NULL,
    [source] VARCHAR(2) NULL,
    [holding] MONEY NULL,
    [T_Value] MONEY NOT NULL,
    [SqQty] INT NULL,
    [FSeqFlag] INT NOT NULL,
    [SeqFlag] INT NOT NULL,
    [srno] INT NOT NULL,
    [sett_no] VARCHAR(10) NULL,
    [T_VALUE_DUMMY] MONEY NOT NULL,
    [DENSE_SR] BIGINT NULL,
    [DIFF_SR_NO] INT NOT NULL,
    [START_VALUE] MONEY NULL,
    [DIFF_AMT] MONEY NULL,
    [DR_ADJ] MONEY NULL,
    [DR_ALLOCATION] MONEY NULL,
    [exch] VARCHAR(10) NULL,
    [Act_SquareUp_Total] MONEY NULL,
    [Act_SquareUp_Qty] FLOAT NULL,
    [REMARKS] VARCHAR(100) NULL,
    [dumped_on] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist_version2
-- --------------------------------------------------
CREATE TABLE [dbo].[ASB7_SQ_UP_FILE_GENERATE_T6T7_Hist_version2]
(
    [Row_num] BIGINT NULL,
    [party_code] VARCHAR(10) NULL,
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [ScripCategory] VARCHAR(20) NULL,
    [exchange] VARCHAR(10) NULL,
    [ActQty] FLOAT NULL,
    [Clsrate] MONEY NULL,
    [Total] MONEY NULL,
    [source] VARCHAR(2) NULL,
    [holding] MONEY NULL,
    [T_Value] MONEY NOT NULL,
    [SqQty] INT NULL,
    [FSeqFlag] INT NOT NULL,
    [SeqFlag] INT NOT NULL,
    [srno] INT NOT NULL,
    [sett_no] VARCHAR(10) NULL,
    [T_VALUE_DUMMY] MONEY NOT NULL,
    [DENSE_SR] BIGINT NULL,
    [DIFF_SR_NO] INT NOT NULL,
    [START_VALUE] MONEY NULL,
    [DIFF_AMT] MONEY NULL,
    [DR_ADJ] MONEY NULL,
    [DR_ALLOCATION] MONEY NULL,
    [exch] VARCHAR(10) NULL,
    [Act_SquareUp_Total] MONEY NULL,
    [Act_SquareUp_Qty] FLOAT NULL,
    [REMARKS] VARCHAR(100) NULL,
    [dumped_on] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_Illiquid_Scrip_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_Illiquid_Scrip_HIST]
(
    [Company Name] VARCHAR(100) NULL,
    [BSE Scrip Code] VARCHAR(50) NULL,
    [Group] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [NSE Illiquid] VARCHAR(50) NULL,
    [BSE Illiquid] VARCHAR(50) NULL,
    [NSE Symbol] VARCHAR(20) NULL,
    [START DATE] VARCHAR(20) NULL,
    [END DATE] VARCHAR(20) NULL,
    [UPD_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_margin_Test
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_margin_Test]
(
    [Slno] NVARCHAR(10) NULL,
    [SCRIPCODE] NVARCHAR(20) NULL,
    [SCRIPNAME] NVARCHAR(20) NULL,
    [ISINCODE] NVARCHAR(20) NULL,
    [VARMARGIN] NVARCHAR(20) NULL,
    [FIVARMARGINPER] NVARCHAR(20) NULL,
    [PROCESSON] DATETIME NULL,
    [APPLI_ON] DATETIME NULL,
    [VARMARGIN_RATE] MONEY NULL,
    [ELM_PERC] NVARCHAR(20) NULL,
    [ELM_RATE] MONEY NULL,
    [VAR_ELM_Rate] MONEY NULL,
    [CRT_BY] NVARCHAR(20) NULL,
    [CRT_DATE] DATETIME NULL,
    [MOD_BY] NCHAR(10) NULL,
    [MOD_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_PCA_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_PCA_HIST]
(
    [SrNo] INT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Scrip_Name] VARCHAR(100) NULL,
    [Annexture] VARCHAR(50) NULL,
    [UPD_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_REVERSEFILE_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_REVERSEFILE_HIST]
(
    [SCRIPCODE] VARCHAR(50) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(50) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [DEFAULT_1] VARCHAR(50) NULL,
    [DEFAULT_2] VARCHAR(50) NULL,
    [TIME_1] VARCHAR(50) NULL,
    [DATE] VARCHAR(50) NULL,
    [CLEINTCODE] VARCHAR(50) NULL,
    [BUY_SELL] VARCHAR(50) NULL,
    [DEFAULT_3] VARCHAR(50) NULL,
    [ORDERNO] VARCHAR(50) NULL,
    [DEFAULT_4] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [TIME_2] VARCHAR(50) NULL,
    [FILENAME] VARCHAR(25) NULL,
    [PDATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSEFO_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[BSEFO_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(25) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSEVar_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[BSEVar_HIST]
(
    [Slno] NVARCHAR(10) NULL,
    [SCRIPCODE] NVARCHAR(20) NULL,
    [SCRIPNAME] NVARCHAR(20) NULL,
    [ISINCODE] NVARCHAR(20) NULL,
    [VARMARGIN] NVARCHAR(20) NULL,
    [FIVARMARGINPER] NVARCHAR(20) NULL,
    [PROCESSON] DATETIME NULL,
    [APPLI_ON] DATETIME NULL,
    [VARMARGIN_RATE] MONEY NULL,
    [ELM_PERC] NVARCHAR(20) NULL,
    [ELM_RATE] MONEY NULL,
    [VAR_ELM_Rate] MONEY NULL,
    [CRT_BY] NVARCHAR(20) NULL,
    [CRT_DATE] DATETIME NULL,
    [MOD_BY] NCHAR(10) NULL,
    [MOD_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSX_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[BSX_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSX_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[BSX_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_06062018
-- --------------------------------------------------
CREATE TABLE [dbo].[client_06062018]
(
    [l_state] VARCHAR(100) NULL,
    [party_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_COLLATERALS_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_COLLATERALS_HIST]
(
    [co_code] VARCHAR(10) NULL,
    [EffDate] DATETIME NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(20) NULL,
    [Cl_Rate] MONEY NULL,
    [Amount] MONEY NULL,
    [Qty] NUMERIC(18, 0) NULL,
    [HairCut] MONEY NULL,
    [FinalAmount] MONEY NULL,
    [PercentageCash] NUMERIC(18, 2) NULL,
    [PerecntageNonCash] NUMERIC(18, 2) NULL,
    [Receive_Date] DATETIME NULL,
    [Maturity_Date] DATETIME NULL,
    [Coll_Type] VARCHAR(6) NULL,
    [ClientType] VARCHAR(3) NULL,
    [Remarks] VARCHAR(50) NULL,
    [LoginName] VARCHAR(20) NULL,
    [LoginTime] DATETIME NULL,
    [Cash_Ncash] VARCHAR(2) NULL,
    [Group_Code] VARCHAR(15) NULL,
    [Fd_Bg_No] VARCHAR(20) NULL,
    [Bank_Code] VARCHAR(15) NULL,
    [Fd_Type] VARCHAR(1) NULL,
    [RMS_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_COLLATERALS_HIST_LD_VIEW_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_COLLATERALS_HIST_LD_VIEW_DATA]
(
    [co_code] VARCHAR(10) NULL,
    [EffDate] DATETIME NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(20) NULL,
    [Cl_Rate] MONEY NULL,
    [Amount] MONEY NULL,
    [Qty] NUMERIC(18, 0) NULL,
    [HairCut] MONEY NULL,
    [FinalAmount] MONEY NULL,
    [PercentageCash] NUMERIC(18, 2) NULL,
    [PerecntageNonCash] NUMERIC(18, 2) NULL,
    [Receive_Date] DATETIME NULL,
    [Maturity_Date] DATETIME NULL,
    [Coll_Type] VARCHAR(6) NULL,
    [ClientType] VARCHAR(3) NULL,
    [Remarks] VARCHAR(50) NULL,
    [LoginName] VARCHAR(20) NULL,
    [LoginTime] DATETIME NULL,
    [Cash_Ncash] VARCHAR(2) NULL,
    [Group_Code] VARCHAR(15) NULL,
    [Fd_Bg_No] VARCHAR(20) NULL,
    [Bank_Code] VARCHAR(15) NULL,
    [Fd_Type] VARCHAR(1) NULL,
    [RMS_DATE] DATETIME NULL,
    [SESSION_ID] VARCHAR(50) NULL,
    [RPT_DATE] DATETIME NOT NULL,
    [RPQ_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_COMMODITY_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_COMMODITY_DETAILS]
(
    [ID] INT NULL,
    [CLCODE] VARCHAR(20) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [LEDGERAMOUNT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CLIENT_COMMODITY_DETAILS_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[CLIENT_COMMODITY_DETAILS_TEMP]
(
    [ID] INT NULL,
    [CLCODE] VARCHAR(20) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [LEDGERAMOUNT] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Client_DrNODs
-- --------------------------------------------------
CREATE TABLE [dbo].[Client_DrNODs]
(
    [party_Code] VARCHAR(10) NULL,
    [DrNoOfDays] INT NULL,
    [Upd_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientCategoryInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientCategoryInfo]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Gross_Brok] MONEY NULL,
    [Traded_days] INT NOT NULL,
    [Interest_Amount] MONEY NULL,
    [NBFC_Interest] MONEY NULL,
    [AvgMnthDr] MONEY NULL,
    [Category] CHAR(3) NULL,
    [ROI] MONEY NULL,
    [UpdateOn] DATETIME NOT NULL,
    [Net_brok] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientRiskCategory
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientRiskCategory]
(
    [Party_code] VARCHAR(10) NULL,
    [RiskCategoryCode] INT NULL,
    [Priorities] VARCHAR(15) NULL,
    [Upd_date] DATETIME NULL,
    [ProjRisk] MONEY NULL DEFAULT ((0)),
    [AvgDlyBrokerage] MONEY NULL DEFAULT ((0)),
    [Debit_Priorities] VARCHAR(15) NULL DEFAULT 'Normal'
);

GO

-- --------------------------------------------------
-- TABLE dbo.Combine_Closing_File
-- --------------------------------------------------
CREATE TABLE [dbo].[Combine_Closing_File]
(
    [Security_Symbol] VARCHAR(100) NULL,
    [Security_Series] VARCHAR(100) NULL,
    [Security_ISIN] VARCHAR(100) NULL,
    [MTM_Price] VARCHAR(100) NULL,
    [File_Names] VARCHAR(50) NULL,
    [Updated_On] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContractFile_MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[ContractFile_MCX]
(
    [upd_date] VARCHAR(10) NULL,
    [C1] VARCHAR(50) NULL,
    [C2] VARCHAR(50) NULL,
    [C3] VARCHAR(50) NULL,
    [C4] VARCHAR(50) NULL,
    [C5] VARCHAR(50) NULL,
    [C6] VARCHAR(50) NULL,
    [C7] VARCHAR(50) NULL,
    [C8] VARCHAR(50) NULL,
    [C9] VARCHAR(50) NULL,
    [C10] VARCHAR(50) NULL,
    [C11] VARCHAR(50) NULL,
    [C12] VARCHAR(50) NULL,
    [C13] VARCHAR(50) NULL,
    [C14] VARCHAR(50) NULL,
    [C15] VARCHAR(50) NULL,
    [C16] VARCHAR(50) NULL,
    [C17] VARCHAR(50) NULL,
    [C18] VARCHAR(50) NULL,
    [C19] VARCHAR(50) NULL,
    [C20] VARCHAR(50) NULL,
    [C21] VARCHAR(50) NULL,
    [C22] VARCHAR(50) NULL,
    [C23] VARCHAR(50) NULL,
    [C24] VARCHAR(50) NULL,
    [C25] VARCHAR(50) NULL,
    [C26] VARCHAR(50) NULL,
    [C27] VARCHAR(50) NULL,
    [C28] VARCHAR(50) NULL,
    [C29] VARCHAR(50) NULL,
    [C30] VARCHAR(50) NULL,
    [C31] VARCHAR(50) NULL,
    [C32] VARCHAR(50) NULL,
    [C33] VARCHAR(50) NULL,
    [C34] VARCHAR(50) NULL,
    [C35] VARCHAR(50) NULL,
    [C36] VARCHAR(50) NULL,
    [C37] VARCHAR(50) NULL,
    [C38] VARCHAR(50) NULL,
    [C39] VARCHAR(50) NULL,
    [C40] VARCHAR(50) NULL,
    [C41] VARCHAR(50) NULL,
    [C42] VARCHAR(50) NULL,
    [C43] VARCHAR(50) NULL,
    [C44] VARCHAR(50) NULL,
    [C45] VARCHAR(50) NULL,
    [C46] VARCHAR(50) NULL,
    [C47] VARCHAR(50) NULL,
    [C48] VARCHAR(50) NULL,
    [C49] VARCHAR(50) NULL,
    [C50] VARCHAR(50) NULL,
    [C51] VARCHAR(50) NULL,
    [C52] VARCHAR(50) NULL,
    [C53] VARCHAR(50) NULL,
    [C54] VARCHAR(50) NULL,
    [C55] VARCHAR(50) NULL,
    [C56] VARCHAR(50) NULL,
    [C57] VARCHAR(50) NULL,
    [C58] VARCHAR(50) NULL,
    [C59] VARCHAR(50) NULL,
    [C60] VARCHAR(50) NULL,
    [C61] VARCHAR(50) NULL,
    [C62] VARCHAR(50) NULL,
    [C63] VARCHAR(50) NULL,
    [C64] VARCHAR(50) NULL,
    [C65] VARCHAR(50) NULL,
    [C66] VARCHAR(50) NULL,
    [C67] VARCHAR(50) NULL,
    [C68] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContractFile_NCDEX
-- --------------------------------------------------
CREATE TABLE [dbo].[ContractFile_NCDEX]
(
    [upd_date] VARCHAR(10) NULL,
    [C1] VARCHAR(50) NULL,
    [C2] VARCHAR(50) NULL,
    [C3] VARCHAR(50) NULL,
    [C4] VARCHAR(50) NULL,
    [C5] VARCHAR(50) NULL,
    [C6] VARCHAR(50) NULL,
    [C7] VARCHAR(50) NULL,
    [C8] VARCHAR(50) NULL,
    [C9] VARCHAR(50) NULL,
    [C10] VARCHAR(50) NULL,
    [C11] VARCHAR(50) NULL,
    [C12] VARCHAR(50) NULL,
    [C13] VARCHAR(50) NULL,
    [C14] VARCHAR(50) NULL,
    [C15] VARCHAR(50) NULL,
    [C16] VARCHAR(50) NULL,
    [C17] VARCHAR(50) NULL,
    [C18] VARCHAR(50) NULL,
    [C19] VARCHAR(50) NULL,
    [C20] VARCHAR(50) NULL,
    [C21] VARCHAR(50) NULL,
    [C22] VARCHAR(50) NULL,
    [C23] VARCHAR(50) NULL,
    [C24] VARCHAR(50) NULL,
    [C25] VARCHAR(50) NULL,
    [C26] VARCHAR(50) NULL,
    [C27] VARCHAR(50) NULL,
    [C28] VARCHAR(50) NULL,
    [C29] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_BSECM_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_BSECM_hist]
(
    [scode] VARCHAR(10) NULL,
    [rate] MONEY NULL,
    [fname] VARCHAR(12) NULL,
    [CLS_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_bsecm_TEST
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_bsecm_TEST]
(
    [scode] VARCHAR(10) NULL,
    [rate] MONEY NULL,
    [fname] VARCHAR(12) NULL,
    [CLS_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_bsx_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_bsx_hist]
(
    [mkt_type] VARCHAR(30) NULL,
    [instrument] VARCHAR(30) NULL,
    [symbol] VARCHAR(30) NULL,
    [expirydate] VARCHAR(30) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(30) NULL,
    [filler] VARCHAR(10) NULL,
    [previous] MONEY NULL,
    [open_price] MONEY NULL,
    [high_price] MONEY NULL,
    [low_price] MONEY NULL,
    [close_price] MONEY NULL,
    [total_traded_quantity] INT NULL,
    [total_traded_val] MONEY NULL,
    [open_interest] MONEY NULL,
    [change_in_open_interest] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [update_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx_hist]
(
    [TradeDate] DATETIME NULL,
    [MarketType] VARCHAR(10) NULL,
    [InstType] VARCHAR(10) NULL,
    [Symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [StrikePrice] MONEY NULL,
    [Optiontype] VARCHAR(50) NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [ee] VARCHAR(50) NULL,
    [ff] MONEY NULL,
    [gg] MONEY NULL,
    [hh] MONEY NULL,
    [ii] VARCHAR(25) NULL,
    [jj] VARCHAR(50) NULL,
    [kk] VARCHAR(50) NULL,
    [ll] INT NULL,
    [mm] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Updated_on] DATETIME NULL,
    [Cls_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx_hist_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx_hist_comm]
(
    [TradeDate] DATETIME NULL,
    [MarketType] VARCHAR(10) NULL,
    [InstType] VARCHAR(10) NULL,
    [Symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [StrikePrice] MONEY NULL,
    [Optiontype] VARCHAR(50) NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [ee] VARCHAR(50) NULL,
    [ff] MONEY NULL,
    [gg] MONEY NULL,
    [hh] MONEY NULL,
    [ii] VARCHAR(25) NULL,
    [jj] VARCHAR(50) NULL,
    [kk] VARCHAR(50) NULL,
    [ll] INT NULL,
    [mm] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Updated_on] DATETIME NULL,
    [Cls_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx_hist_newformat
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx_hist_newformat]
(
    [TradeDate] DATETIME NULL,
    [MarketType] VARCHAR(10) NULL,
    [InstType] VARCHAR(10) NULL,
    [Symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [Reserved] VARCHAR(200) NULL,
    [StrikePrice] MONEY NULL,
    [Optiontype] VARCHAR(50) NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [ee] VARCHAR(50) NULL,
    [ff] MONEY NULL,
    [gg] MONEY NULL,
    [hh] MONEY NULL,
    [ii] VARCHAR(25) NULL,
    [jj] VARCHAR(50) NULL,
    [kk] VARCHAR(50) NULL,
    [ll] INT NULL,
    [mm] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Updated_on] DATETIME NULL,
    [Cls_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcxsx_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcxsx_hist]
(
    [Date] DATETIME NULL,
    [Instrument] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Expirydate] DATETIME NULL,
    [Strike_Price] VARCHAR(20) NULL,
    [Options_Type] VARCHAR(20) NULL,
    [MTM_Sett_price] MONEY NULL,
    [CurrCode] VARCHAR(20) NULL,
    [Updatedon] DATETIME NULL,
    [Filename] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_hist]
(
    [aa] VARCHAR(2) NULL,
    [InstType] VARCHAR(10) NULL,
    [symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Update_On] DATETIME NULL,
    [CLS_Date] DATETIME NULL,
    [Option_type] VARCHAR(20) NULL,
    [strike_Price] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_hist_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_hist_comm]
(
    [aa] VARCHAR(2) NULL,
    [InstType] VARCHAR(10) NULL,
    [symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Update_On] DATETIME NULL,
    [CLS_Date] DATETIME NULL,
    [Option_type] VARCHAR(20) NULL,
    [strike_Price] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_hist_makelive
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_hist_makelive]
(
    [aa] VARCHAR(2) NULL,
    [InstType] VARCHAR(10) NULL,
    [symbol] VARCHAR(25) NULL,
    [ExpiryDate] DATETIME NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [Update_On] DATETIME NULL,
    [CLS_Date] DATETIME NULL,
    [Option_Type] VARCHAR(10) NULL,
    [srike_price] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSECM_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSECM_hist]
(
    [mkt_type] VARCHAR(10) NULL,
    [scrip] VARCHAR(20) NULL,
    [series] VARCHAR(5) NULL,
    [ycls] MONEY NULL,
    [opn] MONEY NULL,
    [hi] MONEY NULL,
    [lo] MONEY NULL,
    [cls] MONEY NULL,
    [a] VARCHAR(50) NULL,
    [b] VARCHAR(50) NULL,
    [c] VARCHAR(50) NULL,
    [d] VARCHAR(50) NULL,
    [e] VARCHAR(100) NULL,
    [fname] VARCHAR(25) NULL,
    [Cls_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nsecm_hist_SarojBup
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nsecm_hist_SarojBup]
(
    [mkt_type] VARCHAR(10) NULL,
    [scrip] VARCHAR(20) NULL,
    [series] VARCHAR(5) NULL,
    [ycls] MONEY NULL,
    [opn] MONEY NULL,
    [hi] MONEY NULL,
    [lo] MONEY NULL,
    [cls] MONEY NULL,
    [a] VARCHAR(50) NULL,
    [b] VARCHAR(50) NULL,
    [c] VARCHAR(50) NULL,
    [d] VARCHAR(50) NULL,
    [e] VARCHAR(100) NULL,
    [fname] VARCHAR(25) NULL,
    [Cls_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSEFO]
(
    [T_TYPE] VARCHAR(25) NULL,
    [INST_TYPE] VARCHAR(25) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] DATETIME NULL,
    [STRIKE_PRICE] VARCHAR(25) NULL,
    [OPT_TYPE] VARCHAR(25) NULL,
    [Y_CLS] VARCHAR(25) NULL,
    [OPEN] VARCHAR(25) NULL,
    [HI] VARCHAR(25) NULL,
    [LO] VARCHAR(25) NULL,
    [CLS] VARCHAR(25) NULL,
    [AA] VARCHAR(25) NULL,
    [BB] VARCHAR(25) NULL,
    [CC] VARCHAR(25) NULL,
    [DD] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nseFO_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nseFO_hist]
(
    [T_TYPE] VARCHAR(10) NULL,
    [INST_TYPE] VARCHAR(10) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] DATETIME NULL,
    [STRIKE_PRICE] MONEY NULL,
    [OPT_TYPE] VARCHAR(10) NULL,
    [Y_CLS] MONEY NULL,
    [OPEN] MONEY NULL,
    [HI] MONEY NULL,
    [LO] MONEY NULL,
    [CLS] MONEY NULL,
    [AA] MONEY NULL,
    [BB] MONEY NULL,
    [CC] MONEY NULL,
    [DD] MONEY NULL,
    [FNAME] VARCHAR(25) NULL,
    [Cls_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSX_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSX_hist]
(
    [mkt_type] VARCHAR(20) NULL,
    [Instrument] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Contract_Date] DATETIME NULL,
    [aa] VARCHAR(50) NULL,
    [bb] VARCHAR(50) NULL,
    [PREVIOUS] MONEY NULL,
    [OPEN_PRICE] MONEY NULL,
    [HIGH_PRICE] MONEY NULL,
    [LOW_PRICE] MONEY NULL,
    [CLOSE_PRICE] MONEY NULL,
    [TRADED_QUA] INT NULL,
    [TRADED_VAL] MONEY NULL,
    [cc] VARCHAR(50) NULL,
    [dd] VARCHAR(50) NULL,
    [filename] VARCHAR(50) NULL,
    [Update_On] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data182_data
-- --------------------------------------------------
CREATE TABLE [dbo].[data182_data]
(
    [party_Code] VARCHAR(10) NOT NULL,
    [b2c] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.day_defination_change
-- --------------------------------------------------
CREATE TABLE [dbo].[day_defination_change]
(
    [object_name] NVARCHAR(128) NOT NULL,
    [schema_name] NVARCHAR(128) NULL,
    [type_desc] NVARCHAR(60) NULL,
    [create_date] DATETIME NOT NULL,
    [modify_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DBGrowthRate
-- --------------------------------------------------
CREATE TABLE [dbo].[DBGrowthRate]
(
    [DBGrowthID] INT IDENTITY(1,1) NOT NULL,
    [DBName] VARCHAR(100) NULL,
    [DBID] INT NULL,
    [NumPages] INT NULL,
    [OrigSize] DECIMAL(10, 2) NULL,
    [CurSize] DECIMAL(10, 2) NULL,
    [GrowthAmt] VARCHAR(100) NULL,
    [MetricDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DebitClientSms
-- --------------------------------------------------
CREATE TABLE [dbo].[DebitClientSms]
(
    [Update_Date] DATETIME NOT NULL,
    [party_Code] VARCHAR(10) NULL,
    [Net] MONEY NULL,
    [Penal] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [content] VARCHAR(250) NULL,
    [Flag] VARCHAR(1) NOT NULL,
    [Region] VARCHAR(15) NULL,
    [Branch] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [Cli_Type] VARCHAR(5) NULL,
    [processBy] VARCHAR(10) NULL,
    [SMSBy] VARCHAR(10) NULL,
    [SMSFlag] VARCHAR(3) NULL,
    [mobile_no] VARCHAR(11) NULL,
    [SMSDate] DATETIME NULL,
    [cli_cat] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DebitClientSms_LC
-- --------------------------------------------------
CREATE TABLE [dbo].[DebitClientSms_LC]
(
    [Update_Date] DATETIME NOT NULL,
    [party_Code] VARCHAR(10) NULL,
    [Net] MONEY NULL,
    [Penal] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [content] VARCHAR(250) NULL,
    [Flag] VARCHAR(1) NOT NULL,
    [Region] VARCHAR(15) NULL,
    [Branch] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [Cli_Type] VARCHAR(5) NULL,
    [processBy] VARCHAR(10) NULL,
    [SMSBy] VARCHAR(10) NULL,
    [SMSFlag] VARCHAR(3) NULL,
    [mobile_no] VARCHAR(11) NULL,
    [SMSDate] DATETIME NULL,
    [cli_cat] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DebitClientSms_LC1
-- --------------------------------------------------
CREATE TABLE [dbo].[DebitClientSms_LC1]
(
    [SMS_trigger_Datetime] DATETIME NULL,
    [party_code] VARCHAR(10) NULL,
    [ABL_Net] MONEY NULL,
    [ACBPL_Net] MONEY NULL,
    [ABL_lastBillDate] DATETIME NULL,
    [ACBPL_lastBillDate] DATETIME NULL,
    [Flag] CHAR(1) NULL,
    [MobileNo] VARCHAR(15) NULL,
    [otherdebits_ABL] MONEY NULL,
    [otherdebits_ACBPL] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dupsql
-- --------------------------------------------------
CREATE TABLE [dbo].[dupsql]
(
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(100) NULL,
    [Client_Code] VARCHAR(100) NULL,
    [SquareOffAction] VARCHAR(20) NULL,
    [sno] INT IDENTITY(1,1) NOT NULL,
    [Row] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCHANGEMARGINREPORTING_COLL_T2DAY_DET_LD_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCHANGEMARGINREPORTING_COLL_T2DAY_DET_LD_hist]
(
    [PARTY_CODE] VARCHAR(50) NULL,
    [ISIN] VARCHAR(16) NULL,
    [QTY] INT NULL,
    [HAIRCUT] MONEY NULL,
    [CLSRATE] MONEY NULL,
    [VALUE] MONEY NULL,
    [HIST_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCHANGEMARGINREPORTING_DATA_LD_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCHANGEMARGINREPORTING_DATA_LD_HIST]
(
    [Zone] VARCHAR(20) NULL,
    [Region] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [SB] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Cli_Type] VARCHAR(5) NULL,
    [ProcessDateTime] DATETIME NOT NULL,
    [NSEFO_Ledger] MONEY NOT NULL,
    [NSEFO_UnReco] MONEY NOT NULL,
    [NSEFO_Deposit] MONEY NOT NULL,
    [NSEFO_CashColl] MONEY NOT NULL,
    [NSEFO_CashNet] MONEY NOT NULL,
    [NSEFO_NonCashColl] MONEY NOT NULL,
    [NSEFO_NetAvail] MONEY NOT NULL,
    [NSECM_Ledger] MONEY NOT NULL,
    [NSECM_UnReco] MONEY NOT NULL,
    [NSECM_Deposit] MONEY NOT NULL,
    [NSECM_CashNet] MONEY NOT NULL,
    [NSECM_PoolHold] MONEY NOT NULL,
    [NSECM_NetAvail] MONEY NOT NULL,
    [BSECM_Ledger] MONEY NOT NULL,
    [BSECM_UnReco] MONEY NOT NULL,
    [BSECM_Deposit] MONEY NOT NULL,
    [BSECM_CashNet] MONEY NOT NULL,
    [BSECM_PoolHold] MONEY NOT NULL,
    [BSECM_NetAvail] MONEY NOT NULL,
    [NSX_Ledger] MONEY NOT NULL,
    [NSX_UnReco] MONEY NOT NULL,
    [NSX_Deposit] MONEY NOT NULL,
    [NSX_CashColl] MONEY NOT NULL,
    [NSX_CashNet] MONEY NOT NULL,
    [NSX_NonCashColl] MONEY NOT NULL,
    [NSX_NetAvail] MONEY NOT NULL,
    [MCD_Ledger] MONEY NOT NULL,
    [MCD_UnReco] MONEY NOT NULL,
    [MCD_Deposit] MONEY NOT NULL,
    [MCD_CashColl] MONEY NOT NULL,
    [MCD_CashNet] MONEY NOT NULL,
    [MCD_NonCashColl] MONEY NOT NULL,
    [MCD_NetAvail] MONEY NOT NULL,
    [T2DAY_COLL_VAL] MONEY NOT NULL,
    [INSERTDATETIME] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA]
(
    [Zone] VARCHAR(20) NULL,
    [Region] VARCHAR(20) NULL,
    [Branch] VARCHAR(20) NULL,
    [SB] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(20) NULL,
    [Cli_Type] VARCHAR(5) NULL,
    [ProcessDateTime] DATETIME NOT NULL,
    [NSEFO_Ledger] MONEY NOT NULL,
    [NSEFO_UnReco] MONEY NOT NULL,
    [NSEFO_Deposit] MONEY NOT NULL,
    [NSEFO_CashColl] MONEY NOT NULL,
    [NSEFO_CashNet] MONEY NOT NULL,
    [NSEFO_NonCashColl] MONEY NOT NULL,
    [NSEFO_NetAvail] MONEY NOT NULL,
    [NSECM_Ledger] MONEY NOT NULL,
    [NSECM_UnReco] MONEY NOT NULL,
    [NSECM_Deposit] MONEY NOT NULL,
    [NSECM_CashNet] MONEY NOT NULL,
    [NSECM_PoolHold] MONEY NOT NULL,
    [NSECM_NetAvail] MONEY NOT NULL,
    [BSECM_Ledger] MONEY NOT NULL,
    [BSECM_UnReco] MONEY NOT NULL,
    [BSECM_Deposit] MONEY NOT NULL,
    [BSECM_CashNet] MONEY NOT NULL,
    [BSECM_PoolHold] MONEY NOT NULL,
    [BSECM_NetAvail] MONEY NOT NULL,
    [NSX_Ledger] MONEY NOT NULL,
    [NSX_UnReco] MONEY NOT NULL,
    [NSX_Deposit] MONEY NOT NULL,
    [NSX_CashColl] MONEY NOT NULL,
    [NSX_CashNet] MONEY NOT NULL,
    [NSX_NonCashColl] MONEY NOT NULL,
    [NSX_NetAvail] MONEY NOT NULL,
    [MCD_Ledger] MONEY NOT NULL,
    [MCD_UnReco] MONEY NOT NULL,
    [MCD_Deposit] MONEY NOT NULL,
    [MCD_CashColl] MONEY NOT NULL,
    [MCD_CashNet] MONEY NOT NULL,
    [MCD_NonCashColl] MONEY NOT NULL,
    [MCD_NetAvail] MONEY NOT NULL,
    [T2DAY_COLL_VAL] MONEY NOT NULL,
    [INSERTDATETIME] DATETIME NULL,
    [SESSION_ID] VARCHAR(50) NULL,
    [RPT_DATE] DATETIME NOT NULL,
    [RPQ_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_ANKIT
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_ANKIT]
(
    [rms_date] VARCHAR(11) NULL,
    [party_code] VARCHAR(10) NULL,
    [hold] MONEY NULL,
    [cli_type] VARCHAR(10) NULL,
    [mon_rms] INT NULL,
    [mon_year] INT NULL,
    [no_of_days] INT NULL,
    [sr_no] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_siva
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_siva]
(
    [rms_date] VARCHAR(11) NULL,
    [party_code] VARCHAR(10) NULL,
    [holding_total] MONEY NULL,
    [CLI_TYPE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_TEMP]
(
    [party_code] VARCHAR(10) NULL,
    [MON_RMS] INT NULL,
    [YEAR_RMS] INT NULL,
    [HD] MONEY NULL,
    [SRNO] INT NULL,
    [CL_TYPE] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FINAL_TEMP_1502
-- --------------------------------------------------
CREATE TABLE [dbo].[FINAL_TEMP_1502]
(
    [rms_date] VARCHAR(11) NULL,
    [party_code] VARCHAR(10) NULL,
    [holding_total] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fovar_margin
-- --------------------------------------------------
CREATE TABLE [dbo].[fovar_margin]
(
    [rec_type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [SEC_var] VARCHAR(50) NULL,
    [IDX_VAR] VARCHAR(50) NULL,
    [VAR_Margin] VARCHAR(50) NULL,
    [EX_LOSS_RATE] VARCHAR(50) NULL,
    [ADHOC_MARGIN] VARCHAR(50) NULL,
    [APP_MARGIN_RATE] VARCHAR(50) NULL,
    [update_on] DATETIME NULL,
    [Filename] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HistoryIndexFragmentation
-- --------------------------------------------------
CREATE TABLE [dbo].[HistoryIndexFragmentation]
(
    [object_name] NVARCHAR(128) NULL,
    [index_id] INT NULL,
    [name] NVARCHAR(128) NULL,
    [type_desc] NVARCHAR(60) NULL,
    [partition_number] INT NULL,
    [avg_fragmentation_in_percent] FLOAT NULL,
    [Recorddate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.holding_data_rcs
-- --------------------------------------------------
CREATE TABLE [dbo].[holding_data_rcs]
(
    [upd_date] DATETIME NULL,
    [value] MONEY NULL,
    [party_Code] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.holding_data_rcs_b2b_b2c
-- --------------------------------------------------
CREATE TABLE [dbo].[holding_data_rcs_b2b_b2c]
(
    [upd_date] DATETIME NULL,
    [value] MONEY NULL,
    [party_Code] INT NULL,
    [b2c] VARCHAR(3) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kiran
-- --------------------------------------------------
CREATE TABLE [dbo].[kiran]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.led_jun
-- --------------------------------------------------
CREATE TABLE [dbo].[led_jun]
(
    [branch_cd] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [ledger] MONEY NULL,
    [deposit] MONEY NULL,
    [imargin] MONEY NULL,
    [cash_coll] MONEY NULL,
    [NonCash_coll] MONEY NULL,
    [Hold_total] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MArgin_Rahul
-- --------------------------------------------------
CREATE TABLE [dbo].[MArgin_Rahul]
(
    [rms_Date] DATETIME NULL,
    [Tot_MArgin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCD_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[MCD_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCD_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[MCD_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCDX_Bhav_Copy
-- --------------------------------------------------
CREATE TABLE [dbo].[MCDX_Bhav_Copy]
(
    [upd_date] VARCHAR(10) NULL,
    [Date] DATETIME NULL,
    [Instrument Name] NVARCHAR(255) NULL,
    [Commodity Symbol] NVARCHAR(255) NULL,
    [Contract/Expiry Month] DATETIME NULL,
    [Option Type] NVARCHAR(255) NULL,
    [Strike Price] FLOAT NULL,
    [Open(Rs#)] FLOAT NULL,
    [High(Rs#)] FLOAT NULL,
    [Low(Rs#)] FLOAT NULL,
    [Close(Rs#)] FLOAT NULL,
    [PCP(Rs#)] FLOAT NULL,
    [Volume(In Lots)] FLOAT NULL,
    [Volume(In 000's)] NVARCHAR(255) NULL,
    [Value(In Lakhs)] FLOAT NULL,
    [OI(In Lots)] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_Margin
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_Margin]
(
    [Symbol] VARCHAR(15) NULL,
    [ExpiryDate] DATETIME NULL,
    [Price] MONEY NULL,
    [Multiplier] INT NULL,
    [IM] MONEY NULL,
    [SBM] MONEY NULL,
    [SSM] MONEY NULL,
    [AML] MONEY NULL,
    [AMS] MONEY NULL,
    [TenderM] MONEY NULL,
    [TM] MONEY NULL,
    [ICV] MONEY NULL,
    [Margin] MONEY NULL,
    [filename] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.miles_StockholdingData
-- --------------------------------------------------
CREATE TABLE [dbo].[miles_StockholdingData]
(
    [Client_Code] NUMERIC(18, 0) NULL,
    [Scrip_key] NUMERIC(18, 0) NULL,
    [FULLNAME] VARCHAR(100) NULL,
    [HoldQty] NUMERIC(18, 2) NOT NULL,
    [CorporateActionReceivable] NUMERIC(36, 2) NOT NULL,
    [ShortageQty] NUMERIC(18, 2) NOT NULL,
    [NetQty] NUMERIC(20, 2) NULL,
    [clsPr] NUMERIC(18, 2) NOT NULL,
    [PFValue] NUMERIC(38, 4) NULL,
    [Haircut] NUMERIC(18, 2) NOT NULL,
    [PFvalHC] NUMERIC(38, 6) NULL,
    [ApprovNonApprove] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [PartyCode] VARCHAR(50) NULL,
    [RptDt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MILES_STOCKHOLDINGDATA_LD_VIEW_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[MILES_STOCKHOLDINGDATA_LD_VIEW_DATA]
(
    [Client_Code] NUMERIC(18, 0) NULL,
    [Scrip_key] NUMERIC(18, 0) NULL,
    [FULLNAME] VARCHAR(100) NULL,
    [HoldQty] NUMERIC(18, 2) NOT NULL,
    [CorporateActionReceivable] NUMERIC(36, 2) NOT NULL,
    [ShortageQty] NUMERIC(18, 2) NOT NULL,
    [NetQty] NUMERIC(20, 2) NULL,
    [clsPr] NUMERIC(18, 2) NOT NULL,
    [PFValue] NUMERIC(38, 4) NULL,
    [Haircut] NUMERIC(18, 2) NOT NULL,
    [PFvalHC] NUMERIC(38, 6) NULL,
    [ApprovNonApprove] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [PartyCode] VARCHAR(50) NULL,
    [RptDt] DATETIME NULL,
    [Exchange_HairCut] NUMERIC(18, 2) NOT NULL,
    [total_WithHC] NUMERIC(38, 6) NULL,
    [SESSION_ID] VARCHAR(50) NULL,
    [RPT_DATE] DATETIME NOT NULL,
    [RPQ_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nbfc_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[nbfc_ledger]
(
    [vtyp] VARCHAR(10) NOT NULL,
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
    [cltcode] VARCHAR(25) NOT NULL,
    [BookType] CHAR(2) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [pdt] DATETIME NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [actnodays] INT NULL,
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nbfc_miles_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[nbfc_miles_ledger]
(
    [TDATE] VARCHAR(20) NULL,
    [BACKOFFICECODE] VARCHAR(50) NULL,
    [PF] NUMERIC(38, 2) NULL,
    [VAHC] NUMERIC(38, 2) NULL,
    [ACTUALLEDGER] NUMERIC(18, 2) NOT NULL,
    [INTEREST] NUMERIC(18, 2) NOT NULL,
    [UNSETTLEAMT] NUMERIC(18, 2) NOT NULL,
    [LOGICALLEDGER] NUMERIC(19, 2) NULL,
    [MARGIN] NUMERIC(38, 2) NULL,
    [MARGINPER] NUMERIC(38, 6) NULL,
    [UNCLEARCHEQUE] NUMERIC(19, 2) NULL,
    [NETMARGIN] NUMERIC(38, 2) NULL,
    [client_code] NUMERIC(18, 0) NOT NULL,
    [SubBroker] VARCHAR(100) NOT NULL,
    [Branch] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_SqrOff_Exception_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_SqrOff_Exception_Hist]
(
    [Party_Code] VARCHAR(20) NULL,
    [Remarks] VARCHAR(300) NULL,
    [FileName] VARCHAR(100) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_Bhav_Copy
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_Bhav_Copy]
(
    [upd_date] VARCHAR(11) NULL,
    [TradDt] VARCHAR(11) NULL,
    [BizDt] VARCHAR(11) NULL,
    [Sgmt] VARCHAR(10) NULL,
    [Src] VARCHAR(11) NULL,
    [FinInstrmTp] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(10) NULL,
    [Underlying_Commodity] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(10) NULL,
    [ExpiryDate] VARCHAR(11) NULL,
    [FininstrmActlXpryDt] VARCHAR(11) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [FinInstrmNm] VARCHAR(250) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Traded_ValueinLacs] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd_SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [tdate] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncdex_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[ncdex_ps03]
(
    [upd_date] VARCHAR(10) NULL,
    [Position_Date] VARCHAR(255) NULL,
    [Segment_Indicator] VARCHAR(255) NULL,
    [Settlement_Type] VARCHAR(255) NULL,
    [CM_Code] VARCHAR(255) NULL,
    [Member_Type] VARCHAR(255) NULL,
    [Trading Member_Code] VARCHAR(255) NULL,
    [Account_Type] VARCHAR(255) NULL,
    [Client_Code] VARCHAR(255) NULL,
    [Instrument_Type] VARCHAR(255) NULL,
    [Symbol] VARCHAR(255) NULL,
    [Expiry_date] VARCHAR(255) NULL,
    [Strike_Price] VARCHAR(255) NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [BF_long_quantity] INT NULL,
    [BF_Long_Value] MONEY NULL,
    [BF_Short_quantity] INT NULL,
    [BF_Short_Value] MONEY NULL,
    [DayBuyOpenQuantity] INT NULL,
    [DayBuyOpenValue] MONEY NULL,
    [DaySellOpenQuantity] INT NULL,
    [DaySellOpenValue] MONEY NULL,
    [PreExerciseAssignmentLongQuantity] VARCHAR(255) NULL,
    [PreExerciseAssignmentLongValue] VARCHAR(255) NULL,
    [PreExerciseAssignmentShortQuantity] VARCHAR(255) NULL,
    [PreExerciseAssignmentShortValue] VARCHAR(255) NULL,
    [ExercisedQuantity] VARCHAR(255) NULL,
    [AssignedQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentLongQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentLongValue] VARCHAR(255) NULL,
    [PostExercise AssignmentShortQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentShortValue] VARCHAR(255) NULL,
    [SettlementPrice] VARCHAR(255) NULL,
    [NetPremium] VARCHAR(255) NULL,
    [Daily_MTM_Settlement_Value] VARCHAR(255) NULL,
    [Futures_final_Sett_value] VARCHAR(255) NULL,
    [Exercised_Assigned_Value_Calculated] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_Illiquid_Scrip_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_Illiquid_Scrip_HIST]
(
    [Company Name] VARCHAR(100) NULL,
    [BSE Scrip Code] VARCHAR(50) NULL,
    [Group] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [NSE Illiquid] VARCHAR(50) NULL,
    [BSE Illiquid] VARCHAR(50) NULL,
    [NSE Symbol] VARCHAR(20) NULL,
    [START DATE] VARCHAR(20) NULL,
    [END DATE] VARCHAR(20) NULL,
    [UPD_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_PCA_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_PCA_HIST]
(
    [SrNo] INT NULL,
    [NSESymbol] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [SecurityName] VARCHAR(100) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Annexure] VARCHAR(50) NULL,
    [UPD_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_REVERSEFILE_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_REVERSEFILE_HIST]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price_PRO_CLI] MONEY NULL,
    [Client_Ac] INT NULL,
    [Member_Id] VARCHAR(30) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] INT NULL,
    [Auction_No] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] DATETIME NULL,
    [FILENAME] VARCHAR(25) NULL,
    [PDATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFO_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFO_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFO_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFO_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFO_REVERSEFILE_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFO_REVERSEFILE_HIST]
(
    [Trade_Number] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] DATETIME NULL,
    [Strike_Price] INT NULL,
    [Option_type] VARCHAR(50) NULL,
    [Security_name] VARCHAR(50) NULL,
    [Book_Type] INT NULL,
    [Book_Type_Name] VARCHAR(50) NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_No] INT NULL,
    [Buy_Sell_Ind] INT NULL,
    [Trade_Qty] INT NULL,
    [Price] INT NULL,
    [Pro_Client] INT NULL,
    [Account] VARCHAR(50) NULL,
    [Participant] INT NULL,
    [Open_Close_Flag] VARCHAR(10) NULL,
    [Cover_Uncover_Flag] VARCHAR(10) NULL,
    [Activity_Time] DATETIME NULL,
    [Last_Modified_Time] DATETIME NULL,
    [Order_No] VARCHAR(50) NULL,
    [Opposite_Broker_Id] VARCHAR(50) NULL,
    [Order_Entered_Mod_Date] DATETIME NULL,
    [FILENAME] VARCHAR(25) NULL,
    [PDATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSX_MarginViolation
-- --------------------------------------------------
CREATE TABLE [dbo].[NSX_MarginViolation]
(
    [sauda_Date] DATETIME NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [clcode] VARCHAR(10) NULL,
    [short_name] VARCHAR(50) NULL,
    [ledgeramount] MONEY NULL,
    [colletral] MONEY NULL,
    [imargin] MONEY NULL,
    [shortage] MONEY NULL,
    [shrt_percent] MONEY NULL,
    [net] MONEY NULL,
    [days] INT NOT NULL,
    [exposure] MONEY NULL,
    [cumm_short] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSX_MARH
-- --------------------------------------------------
CREATE TABLE [dbo].[NSX_MARH]
(
    [sauda_Date] DATETIME NULL,
    [clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [received] MONEY NULL,
    [shortage] INT NOT NULL,
    [net] MONEY NULL,
    [short_name] VARCHAR(100) NULL,
    [sbtag] VARCHAR(20) NULL,
    [subgroup] VARCHAR(20) NULL,
    [family] VARCHAR(20) NULL,
    [ledgeramount] MONEY NOT NULL,
    [cash_coll] MONEY NOT NULL,
    [non_cash] MONEY NOT NULL,
    [exposure] MONEY NULL,
    [code] INT NULL,
    [remarks] VARCHAR(100) NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ORMS_SB_DEPOSIT_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ORMS_SB_DEPOSIT_hist]
(
    [Sub_broker] VARCHAR(10) NULL,
    [BSECM_Cash] MONEY NULL,
    [NSECM_Cash] MONEY NULL,
    [NSEFO_Cash] MONEY NULL,
    [MCDX_Cash] MONEY NULL,
    [NCDX_Cash] MONEY NULL,
    [BSECM_NonCash] MONEY NULL,
    [NSECM_NonCash] MONEY NULL,
    [NSEFO_NonCash] MONEY NULL,
    [MCDX_NonCash] MONEY NULL,
    [NCDX_NonCash] MONEY NULL,
    [UpdatedOn] DATETIME NULL,
    [MCD_Cash] MONEY NULL,
    [NSX_Cash] MONEY NULL,
    [rms_date] DATETIME NULL,
    [BSX_Cash] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POA_DP_Adj
-- --------------------------------------------------
CREATE TABLE [dbo].[POA_DP_Adj]
(
    [srno] INT NOT NULL,
    [isin] CHAR(12) NULL,
    [scrip_Cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [qty] INT NULL,
    [accno] VARCHAR(16) NULL,
    [total] MONEY NULL,
    [nse_approved] VARCHAR(25) NULL,
    [Net_debit] MONEY NULL,
    [Ben_Adjusted] MONEY NULL,
    [total_adj] MONEY NULL,
    [BalAfterAdj] MONEY NULL,
    [Qty_adj] INT NULL,
    [fo_approved] VARCHAR(1) NULL,
    [Process_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.POA_DP_Adj_Ben
-- --------------------------------------------------
CREATE TABLE [dbo].[POA_DP_Adj_Ben]
(
    [party_code] VARCHAR(10) NOT NULL,
    [net_debit] MONEY NULL,
    [angel_ben] MONEY NOT NULL,
    [Process_date] DATETIME NULL,
    [non_cash] MONEY NULL,
    [FOShrt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_BadDebts
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_BadDebts]
(
    [Date] DATETIME NULL,
    [region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NULL,
    [CL_TOTAL] MONEY NULL,
    [BSECM] MONEY NULL,
    [NSECM] MONEY NULL,
    [NSEFO] MONEY NULL,
    [NSX] MONEY NULL,
    [MCD] MONEY NULL,
    [NCDEX] MONEY NULL,
    [MCX] MONEY NULL,
    [BD_TOTAL] MONEY NULL,
    [BD_BSECM] MONEY NULL,
    [BD_NSECM] MONEY NULL,
    [BD_NSEFO] MONEY NULL,
    [BD_NSX] MONEY NULL,
    [BD_MCD] MONEY NULL,
    [BD_NCDEX] MONEY NULL,
    [BD_MCX] MONEY NULL,
    [NET] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_Client_Debit_History
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_Client_Debit_History]
(
    [party_code] VARCHAR(10) NULL,
    [update_date] DATETIME NULL,
    [debit] FLOAT NULL
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
-- TABLE dbo.RMS_CompRisk_Cli_history_new
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_CompRisk_Cli_history_new]
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
-- TABLE dbo.RMS_DtBrFi
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtBrFi]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Br_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [SB_Ledger] MONEY NULL,
    [SB_Brokerage] MONEY NULL,
    [SB_CashColl] MONEY NULL,
    [SB_NonCashColl] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_DtclFi
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtclFi]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_DtclFi_Closed
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtclFi_Closed]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL DEFAULT ((0)),
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_DtclFi_summ
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtclFi_summ]
(
    [RMS_date] DATETIME NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] INT NOT NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Net] MONEY NULL,
    [ProjRisk] MONEY NULL,
    [PureRisk] MONEY NULL,
    [Exposure] MONEY NULL,
    [DrNoOfDays] INT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_DtclFi12March
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtclFi12March]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_DtSBFi
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_DtSBFi]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [SB_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [SB_Ledger] MONEY NULL,
    [SB_Brokerage] MONEY NULL,
    [SB_CashColl] MONEY NULL,
    [SB_NonCashColl] MONEY NULL,
    [Exposure] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rms_holding
-- --------------------------------------------------
CREATE TABLE [dbo].[rms_holding]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL,
    [Processdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rms_holding_archive_abha
-- --------------------------------------------------
CREATE TABLE [dbo].[rms_holding_archive_abha]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL,
    [Processdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_HOLDING_LD_VIEW_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_HOLDING_LD_VIEW_DATA]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL,
    [SESSION_ID] VARCHAR(50) NOT NULL,
    [RPT_DATE] DATETIME NOT NULL,
    [RPQ_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_NonCashCollateral
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_NonCashCollateral]
(
    [Updated_on] DATETIME NOT NULL,
    [SB] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(15) NULL,
    [Qty] BIGINT NOT NULL,
    [co_Code] VARCHAR(5) NOT NULL,
    [Amount] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_Risk_middleware
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_Risk_middleware]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBCategoryInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[SBCategoryInfo]
(
    [SUB_BROKER] VARCHAR(20) NULL,
    [GROSS_BROK] MONEY NULL DEFAULT ((0)),
    [TRADED_DAYS] INT NULL DEFAULT ((0)),
    [SB_CREDIT] MONEY NULL DEFAULT ((0)),
    [INTEREST_AMOUNT] MONEY NULL DEFAULT ((0)),
    [NBFC_INTEREST] MONEY NULL DEFAULT ((0)),
    [SUMOFDEBIT] MONEY NULL DEFAULT ((0)),
    [SUMOFDEBITDAYS] INT NULL DEFAULT ((0)),
    [AVGNETQUATERLYDEBIT] MONEY NULL DEFAULT ((0)),
    [CATEGORY] VARCHAR(25) NULL DEFAULT 'C',
    [ROI] MONEY NULL DEFAULT ((0)),
    [UPDATEON] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripOnlyVaR_Master_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripOnlyVaR_Master_Hist]
(
    [process_date] DATETIME NOT NULL,
    [isin] VARCHAR(15) NOT NULL,
    [series] VARCHAR(25) NULL,
    [scrip_category] VARCHAR(20) NULL,
    [BSE_VaR] DECIMAL(10, 2) NULL,
    [NSE_VaR] DECIMAL(10, 2) NULL,
    [angel_VaR] DECIMAL(10, 2) NULL,
    [BSE_final_VaR] DECIMAL(10, 2) NULL,
    [NSE_final_VaR] DECIMAL(10, 2) NULL,
    [BSE_proj_VaR] DECIMAL(10, 2) NULL,
    [NSE_proj_VaR] DECIMAL(10, 2) NULL,
    [crtdt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripVaR_Master_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripVaR_Master_Hist]
(
    [process_date] DATETIME NOT NULL,
    [isin] VARCHAR(15) NOT NULL,
    [series] VARCHAR(25) NULL,
    [scrip_category] VARCHAR(20) NULL,
    [BSE_VaR] DECIMAL(10, 2) NULL,
    [NSE_VaR] DECIMAL(10, 2) NULL,
    [angel_VaR] DECIMAL(10, 2) NULL,
    [BSE_final_VaR] DECIMAL(10, 2) NULL,
    [NSE_final_VaR] DECIMAL(10, 2) NULL,
    [BSE_proj_VaR] DECIMAL(10, 2) NULL,
    [NSE_proj_VaR] DECIMAL(10, 2) NULL,
    [crtdt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripVaR_Master_Hist_LD_VIEW_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripVaR_Master_Hist_LD_VIEW_DATA]
(
    [process_date] DATETIME NOT NULL,
    [isin] VARCHAR(15) NOT NULL,
    [series] VARCHAR(25) NULL,
    [scrip_category] VARCHAR(20) NULL,
    [BSE_VaR] DECIMAL(10, 2) NULL,
    [NSE_VaR] DECIMAL(10, 2) NULL,
    [angel_VaR] DECIMAL(10, 2) NULL,
    [BSE_final_VaR] DECIMAL(10, 2) NULL,
    [NSE_final_VaR] DECIMAL(10, 2) NULL,
    [BSE_proj_VaR] DECIMAL(10, 2) NULL,
    [NSE_proj_VaR] DECIMAL(10, 2) NULL,
    [crtdt] DATETIME NULL,
    [SESSION_ID] VARCHAR(50) NOT NULL,
    [RPT_DATE] DATETIME NOT NULL,
    [RPQ_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.securityholdingdata_rpt_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[securityholdingdata_rpt_hist]
(
    [party_code] VARCHAR(50) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [holding] MONEY NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [total] NUMERIC(38, 4) NULL,
    [category] VARCHAR(20) NULL,
    [symbol] VARCHAR(200) NULL,
    [isin] VARCHAR(50) NULL,
    [Update_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SHARES_PAYOUT_ELIGIBILITY_HISTORY
-- --------------------------------------------------
CREATE TABLE [dbo].[SHARES_PAYOUT_ELIGIBILITY_HISTORY]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [ZONE] VARCHAR(25) NULL,
    [REGION] VARCHAR(10) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [NET_DEBIT] MONEY NOT NULL,
    [HOLD_TOTALHC] MONEY NOT NULL,
    [PAYOUTVALUE] MONEY NULL,
    [PO_ELIGIBLE_VAL] MONEY NULL,
    [PROCESS_DATE] DATETIME NOT NULL,
    [PROCESS_HOST] NVARCHAR(100) NULL,
    [PROCESSED_USER] NVARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SHARES_PAYOUT_FILE_HISTORY
-- --------------------------------------------------
CREATE TABLE [dbo].[SHARES_PAYOUT_FILE_HISTORY]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [Exchange] VARCHAR(20) NOT NULL,
    [SCRIPCODE] VARCHAR(20) NOT NULL,
    [SERIES] VARCHAR(10) NOT NULL,
    [ISIN] VARCHAR(20) NOT NULL,
    [QTY_ALLOWED] INT NOT NULL,
    [FDPID] VARCHAR(20) NOT NULL DEFAULT (space((1))),
    [FCLTID] VARCHAR(20) NOT NULL DEFAULT (space((1))),
    [TBANKID] VARCHAR(20) NOT NULL DEFAULT (space((1))),
    [TCLTDPID] VARCHAR(40) NOT NULL DEFAULT (space((1))),
    [REM] VARCHAR(3) NOT NULL DEFAULT 'BTC',
    [PROCESSED_DATE] DATETIME NOT NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.SHARES_PAYOUT_HISTORY
-- --------------------------------------------------
CREATE TABLE [dbo].[SHARES_PAYOUT_HISTORY]
(
    [ROW_NUM] BIGINT NOT NULL,
    [SCRIP_CAT] INT NOT NULL,
    [SC_CAT_DESC] VARCHAR(20) NOT NULL,
    [CLSRATE] MONEY NOT NULL,
    [SETT_NO] VARCHAR(15) NOT NULL,
    [SETT_TYPE] VARCHAR(2) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NOT NULL,
    [SCRIP_CD] VARCHAR(15) NOT NULL,
    [SERIES] VARCHAR(5) NOT NULL,
    [ISIN] VARCHAR(20) NOT NULL,
    [DPTYPE] VARCHAR(10) NOT NULL,
    [DPID] VARCHAR(20) NOT NULL,
    [CLTDPID] VARCHAR(20) NOT NULL,
    [PAYOUTQTY] INT NOT NULL,
    [DELMARKQTY] INT NOT NULL,
    [FREEQTY] INT NOT NULL,
    [PLDQTY] INT NOT NULL,
    [APROVED] NUMERIC(1, 0) NOT NULL,
    [MarkedDate] DATETIME NOT NULL,
    [EXCH] VARCHAR(10) NOT NULL,
    [ELIGIBLE] BIT NOT NULL,
    [ACTUAL_PAYOUT_QTY] INT NOT NULL,
    [EligibleOn] VARCHAR(100) NOT NULL,
    [ZONE] VARCHAR(25) NOT NULL,
    [REGION] VARCHAR(10) NOT NULL,
    [BRANCH] VARCHAR(10) NOT NULL,
    [SB] VARCHAR(10) NOT NULL,
    [PROCESS_DATE] DATETIME NOT NULL,
    [PROCESS_HOST] NVARCHAR(100) NOT NULL,
    [PROCESSED_USER] NVARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SHARES_PAYOUT_RMS_HOLDING_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[SHARES_PAYOUT_RMS_HOLDING_HIST]
(
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(15) NULL,
    [SERIES] VARCHAR(25) NULL,
    [SETT_NO] VARCHAR(10) NULL,
    [SETT_TYPE] VARCHAR(5) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [BS] VARCHAR(1) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [QTY] NUMERIC(38, 0) NULL,
    [CLSRATE] MONEY NULL,
    [ACCNO] VARCHAR(20) NULL,
    [DPID] VARCHAR(20) NULL,
    [CLID] VARCHAR(20) NULL,
    [FLAG] VARCHAR(10) NULL,
    [ABEN] NUMERIC(38, 4) NULL,
    [APOOL] NUMERIC(38, 4) NULL,
    [NBEN] NUMERIC(38, 4) NULL,
    [NPOOL] NUMERIC(38, 4) NULL,
    [APPROVED] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [PARTYNAME] VARCHAR(100) NULL,
    [POOL] VARCHAR(10) NULL,
    [TOTAL] NUMERIC(38, 4) NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [NSE_APPROVED] VARCHAR(10) NULL,
    [SOURCE] VARCHAR(2) NULL,
    [UPD_DATE] DATETIME NULL,
    [ADJQTY] FLOAT NULL,
    [PROCESS_DATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SHARES_PAYOUT_SUMMARY_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[SHARES_PAYOUT_SUMMARY_HIST]
(
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [TOTAL_NETPO] MONEY NOT NULL,
    [BLUECHIP] FLOAT NOT NULL,
    [GOOD] FLOAT NOT NULL,
    [AVERAGE] FLOAT NOT NULL,
    [POOR] FLOAT NOT NULL,
    [BLUECHIP_AFTERPAYOUT] FLOAT NOT NULL,
    [GOOD_AFTERPAYOUT] FLOAT NOT NULL,
    [AVERAGE_AFTERPAYOUT] FLOAT NOT NULL,
    [POOR_AFTERPAYOUT] FLOAT NOT NULL,
    [MARKED_PAYOUT_VALUE] NUMERIC(38, 4) NOT NULL,
    [ACTUAL_PAYOUT_VALUE] MONEY NOT NULL,
    [ALLOW_DEBIT_UPTO] MONEY NOT NULL,
    [DEBITPERC] MONEY NOT NULL,
    [UPDATE_DATE] DATETIME NOT NULL,
    [PAYOUT_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SqData
-- --------------------------------------------------
CREATE TABLE [dbo].[SqData]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(10) NULL,
    [Branch] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [SB_Type] VARCHAR(10) NULL,
    [NoOfDrDays] INT NULL,
    [LastBillDate] VARCHAR(10) NULL,
    [Debit] DECIMAL(15, 2) NULL,
    [Holding_total] DECIMAL(15, 2) NULL,
    [ROI] MONEY NULL,
    [MOS] MONEY NULL,
    [Category] VARCHAR(5) NULL,
    [SqUpCategory] VARCHAR(2) NULL,
    [AppFlag] VARCHAR(1) NULL,
    [ApprovedBy] VARCHAR(10) NULL,
    [DrAgeing] MONEY NULL,
    [ProcessDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SQUAREUP_CASH_NBFC
-- --------------------------------------------------
CREATE TABLE [dbo].[SQUAREUP_CASH_NBFC]
(
    [ID] BIGINT NULL,
    [DENSEID] BIGINT NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(15) NULL,
    [SERIES] VARCHAR(25) NULL,
    [QTY] FLOAT NULL,
    [CLSRATE] MONEY NULL,
    [TOTAL] MONEY NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [SCRIPCAT] INT NULL,
    [SOURCE] CHAR(1) NULL,
    [EXCHANGE_VAR] MONEY NULL,
    [VALID_VAR] MONEY NULL,
    [STATUS] VARCHAR(10) NULL,
    [PROJ_VAR] MONEY NULL,
    [PROJ_RISK] MONEY NULL,
    [haircut] NUMERIC(18, 2) NOT NULL,
    [scrip_shortage] NUMERIC(38, 6) NULL,
    [ADJVAL] MONEY NULL,
    [BAL] MONEY NULL,
    [NET] MONEY NULL,
    [SQ_QTY] MONEY NULL,
    [Act_Squareup_Qty] FLOAT NULL,
    [Act_Squareup_Total] MONEY NULL,
    [UPDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SQUAREUP_CLIENT_NBFC
-- --------------------------------------------------
CREATE TABLE [dbo].[SQUAREUP_CLIENT_NBFC]
(
    [Party_Code] VARCHAR(10) NULL,
    [Net_Debit] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [Net_Available] MONEY NULL,
    [Cash_SqaureUp] MONEY NULL,
    [SquareUpAvailable] CHAR(1) NULL,
    [Exemption] CHAR(1) NULL,
    [Remarks] VARCHAR(250) NULL,
    [Act_Cash_SquareUp] MONEY NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [Email] VARCHAR(50) NULL,
    [updt] DATETIME NULL,
    [LASTUPDT] DATETIME NULL,
    [IPADDRESS] VARCHAR(20) NULL,
    [ENTERED_BY] VARCHAR(20) NULL,
    [SQ_OFF_TYPE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SQuareUp_Exception_T6T7
-- --------------------------------------------------
CREATE TABLE [dbo].[SQuareUp_Exception_T6T7]
(
    [Client] VARCHAR(10) NULL,
    [Remarks] VARCHAR(100) NULL,
    [ValidFrom] VARCHAR(10) NULL,
    [ValidTo] VARCHAR(10) NULL,
    [UPDT] DATETIME NULL,
    [FName] VARCHAR(100) NULL
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
-- TABLE dbo.Tbl_All_Squareoff_Exception_File
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_All_Squareoff_Exception_File]
(
    [Party_code] VARCHAR(20) NULL,
    [Update_date] DATETIME NULL,
    [File_Name] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSEVAR_New
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSEVAR_New]
(
    [Security_Code] VARCHAR(20) NULL,
    [Security_Name] VARCHAR(200) NULL,
    [Group_Name] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [VAR_Group] VARCHAR(10) NULL,
    [Security_VaR] VARCHAR(20) NULL,
    [FILLER1] VARCHAR(20) NULL,
    [VaR_Margin] VARCHAR(20) NULL,
    [Extreme_Loss_Margin] VARCHAR(20) NULL,
    [Additional_Margin] VARCHAR(20) NULL,
    [Applicable_Margin] VARCHAR(20) NULL,
    [Filename] VARCHAR(100) NULL,
    [Upated_On] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CLIENT_COLLATERALS_HIST_3112023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CLIENT_COLLATERALS_HIST_3112023]
(
    [co_code] VARCHAR(10) NULL,
    [EffDate] DATETIME NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(20) NULL,
    [Cl_Rate] MONEY NULL,
    [Amount] MONEY NULL,
    [Qty] NUMERIC(18, 0) NULL,
    [HairCut] MONEY NULL,
    [FinalAmount] MONEY NULL,
    [PercentageCash] NUMERIC(18, 2) NULL,
    [PerecntageNonCash] NUMERIC(18, 2) NULL,
    [Receive_Date] DATETIME NULL,
    [Maturity_Date] DATETIME NULL,
    [Coll_Type] VARCHAR(6) NULL,
    [ClientType] VARCHAR(3) NULL,
    [Remarks] VARCHAR(50) NULL,
    [LoginName] VARCHAR(20) NULL,
    [LoginTime] DATETIME NULL,
    [Cash_Ncash] VARCHAR(2) NULL,
    [Group_Code] VARCHAR(15) NULL,
    [Fd_Bg_No] VARCHAR(20) NULL,
    [Bank_Code] VARCHAR(15) NULL,
    [Fd_Type] VARCHAR(1) NULL,
    [RMS_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_data_03112023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_data_03112023]
(
    [Net_Ledger] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [UB_Loss] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_data_03112023_2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_data_03112023_2]
(
    [Party_Code] VARCHAR(10) NULL,
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [PDATE] DATETIME NULL,
    [mtf_Ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Data_SivaSir
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Data_SivaSir]
(
    [CLI_TYPE] VARCHAR(10) NULL,
    [MON_RMS] INT NULL,
    [MON_YEAR] INT NULL,
    [HOLDING] MONEY NULL,
    [CLIENT_COUNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_datewise_cowise_balance
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_datewise_cowise_balance]
(
    [RMS_DATE] DATETIME NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [CO_CODE] VARCHAR(10) NULL,
    [NET] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_DP_PROj_RISK_ADJ_WITH_VAR_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_DP_PROj_RISK_ADJ_WITH_VAR_HIST]
(
    [party_code] VARCHAR(10) NULL,
    [isin] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(50) NULL,
    [Actqty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [ScripCategory] VARCHAR(10) NULL,
    [Final Var %] DECIMAL(15, 2) NOT NULL,
    [Projected_VAr] DECIMAL(15, 2) NULL,
    [TOTAL_HOLDING] FLOAT NULL,
    [ADJ_HOLDING] FLOAT NULL,
    [DP_ADJ_HOLDING] FLOAT NULL,
    [Update_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FO_COLLATERAL_PLEDGE_ALLOCATION_DATA_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FO_COLLATERAL_PLEDGE_ALLOCATION_DATA_HIST]
(
    [MARGINDATE] DATETIME NULL,
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
    [AVG_COSING] MONEY NULL,
    [PLEDGEABLE_QTY] INT NULL,
    [PLEDGEABLE_VALUE] MONEY NULL,
    [SCRIP_PRIORITY] SMALLINT NULL,
    [UPDATE_DATE] DATETIME NULL,
    [PROCESS_BY] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FO_COLLATERAL_PLEDGE_FIN_SUMMARY_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FO_COLLATERAL_PLEDGE_FIN_SUMMARY_HIST]
(
    [MARGINDate] DATETIME NOT NULL,
    [Client Code] VARCHAR(20) NOT NULL,
    [Value of Securites Pledged] MONEY NOT NULL,
    [Pledge Value (Proportion as e based on O/D availed] MONEY NOT NULL,
    [FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing] MONEY NOT NULL,
    [FO Recipts/Payments on T Day] MONEY NOT NULL,
    [FO Margin Ledger Balance on T Day] MONEY NOT NULL,
    [T Day F&O Initial Margin Requirement] MONEY NOT NULL,
    [T Day F&O Exposure Margin Requirement] MONEY NOT NULL,
    [Free Balance in FO Segment] MONEY NOT NULL,
    [NSEFO_Var] MONEY NOT NULL,
    [Net Obligation] MONEY NOT NULL,
    [Value of improper use] MONEY NOT NULL,
    [UPDATE_DATE] NCHAR(10) NOT NULL,
    [PROCESS_BY] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_FO_COLLATERAL_PLEDGE_RELEASE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_FO_COLLATERAL_PLEDGE_RELEASE]
(
    [MARGINDATE] DATETIME NOT NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_CD] VARCHAR(50) NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [PLEDGE_QTY] INT NULL,
    [VALUE] MONEY NULL,
    [UPDATEDATE] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FortNight_Debit_Clients
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FortNight_Debit_Clients]
(
    [SMS_trigger_Datetime] DATETIME NULL,
    [party_code] VARCHAR(10) NULL,
    [ABL_Net] MONEY NULL,
    [ACBPL_Net] MONEY NULL,
    [ABL_lastBillDate] DATETIME NULL,
    [ACBPL_lastBillDate] DATETIME NULL,
    [Flag] CHAR(1) NULL,
    [MobileNo] VARCHAR(15) NULL,
    [otherdebits_ABL] MONEY NULL,
    [otherdebits_ACBPL] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_fut_opt_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_fut_opt_upload]
(
    [Contract_Date] VARCHAR(100) NULL,
    [Contract_Instrument_Type] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Expiry_Date] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Corporate_Action_level] VARCHAR(100) NULL,
    [Contract_Regular_Lot] VARCHAR(100) NULL,
    [Contract_Issue_Start_Date] VARCHAR(100) NULL,
    [Contract_Issue_Maturity_Date] VARCHAR(100) NULL,
    [Contract_Exercise_Start_Date] VARCHAR(100) NULL,
    [Contract_Exercise_End_Date] VARCHAR(100) NULL,
    [Contract_Exercise_Style] VARCHAR(100) NULL,
    [Contract_Active_Market_Type] VARCHAR(100) NULL,
    [Contract_Open_Price] VARCHAR(100) NULL,
    [Contract_High_Price] VARCHAR(100) NULL,
    [Contract_Low_Price] VARCHAR(100) NULL,
    [Contract_Close_Price] VARCHAR(100) NULL,
    [Contract_Settlement_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Instrument_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Symbol] VARCHAR(100) NULL,
    [Contract_Underlying_Series] VARCHAR(100) NULL,
    [Contract_Underlying_Expiry_Date] VARCHAR(100) NULL,
    [Contract_Underlying_Strike_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Option_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Corporate_Action_Level] VARCHAR(100) NULL,
    [FName] VARCHAR(100) NULL,
    [UpdateDate] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LAS_BAL_PLG_AFTER_ADJUST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LAS_BAL_PLG_AFTER_ADJUST]
(
    [RMS_DATE] DATETIME NOT NULL,
    [ACCNO] CHAR(16) NOT NULL,
    [ISIN] CHAR(12) NOT NULL,
    [HLD_AC_POS] MONEY NULL,
    [AFTER_ADJUST_PLEDGE_QTY] MONEY NULL,
    [SCRIPNAME] VARCHAR(100) NULL,
    [BANK_APPROVED] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LAS_CLI_NOT_FOR_PLEDGE
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LAS_CLI_NOT_FOR_PLEDGE]
(
    [RMS_Date] DATETIME NULL,
    [Party_Code] VARCHAR(10) NULL,
    [DrBal] MONEY NULL,
    [AgeingBal] MONEY NULL,
    [Loan_debit] MONEY NULL,
    [NonAprHold] MONEY NULL,
    [AprHold] MONEY NULL,
    [PRIORITY_FLAG] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LAS_CLI_NOT_FOR_PLEDGE_HOLDING
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LAS_CLI_NOT_FOR_PLEDGE_HOLDING]
(
    [RMS_DATE] DATETIME NOT NULL,
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LAS_CLIENT_SCRIP_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LAS_CLIENT_SCRIP_DATA]
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
    [AVG_COSING] MONEY NULL,
    [PLEDGEABLE_QTY] INT NULL,
    [PLEDGEABLE_VALUE] INT NULL,
    [SCRIP_PRIORITY] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_LAS_CLIENT_SCRIP_DATA_ALLOCATED
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_LAS_CLIENT_SCRIP_DATA_ALLOCATED]
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
    [AVG_COSING] MONEY NULL,
    [PLEDGEABLE_QTY] INT NULL,
    [PLEDGEABLE_VALUE] INT NULL,
    [SCRIP_PRIORITY] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ms_abha
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ms_abha]
(
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(100) NULL,
    [Client_Code] VARCHAR(100) NULL,
    [Category] VARCHAR(50) NULL,
    [Client_Type] VARCHAR(50) NULL,
    [SB_Category] VARCHAR(50) NOT NULL,
    [Margin_Shortage] MONEY NULL,
    [Excess_Credit_Of_Other_Segments] MONEY NULL,
    [Margin_Shortage_After_ExcessCredit_Adj] MONEY NULL,
    [Square_Off_Value] MONEY NULL,
    [SquareOffAction] VARCHAR(20) NULL,
    [Update_date] DATETIME NULL,
    [ActiveEx] VARCHAR(5) NULL,
    [Actual_Cash_SquareOff_Done] MONEY NULL,
    [sno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_NBFC_Excess_ShortageSqOff_17042015
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_NBFC_Excess_ShortageSqOff_17042015]
(
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(100) NULL,
    [Client_Code] VARCHAR(100) NULL,
    [Category] VARCHAR(50) NULL,
    [Client_Type] VARCHAR(50) NULL,
    [SB_Category] VARCHAR(50) NOT NULL,
    [Margin_Shortage] MONEY NULL,
    [Excess_Credit_Of_Other_Segments] MONEY NULL,
    [Margin_Shortage_After_ExcessCredit_Adj] MONEY NULL,
    [Square_Off_Value] MONEY NULL,
    [SquareOffAction] VARCHAR(20) NULL,
    [Update_date] DATETIME NULL,
    [ActiveEx] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_NBFC_Excess_ShortageSqOff_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_NBFC_Excess_ShortageSqOff_hist]
(
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(100) NULL,
    [Client_Code] VARCHAR(100) NULL,
    [Category] VARCHAR(50) NULL,
    [Client_Type] VARCHAR(50) NULL,
    [SB_Category] VARCHAR(50) NOT NULL,
    [Margin_Shortage] MONEY NULL,
    [Excess_Credit_Of_Other_Segments] MONEY NULL,
    [Margin_Shortage_After_ExcessCredit_Adj] MONEY NULL,
    [Square_Off_Value] MONEY NULL,
    [SquareOffAction] VARCHAR(20) NULL,
    [Update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_pledge_calculation_history
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_pledge_calculation_history]
(
    [party_code] VARCHAR(100) NULL,
    [Mobile_Num] VARCHAR(50) NULL,
    [Email] VARCHAR(500) NULL,
    [dpid] VARCHAR(20) NOT NULL,
    [scripname] VARCHAR(500) NULL,
    [isin] VARCHAR(20) NULL,
    [Free_Qty] NUMERIC(18, 5) NOT NULL,
    [Pledge_Qty] NUMERIC(18, 5) NOT NULL,
    [Upddate] DATETIME NOT NULL,
    [Obligation] INT NULL,
    [Unpledge] INT NULL,
    [POA] VARCHAR(10) NULL,
    [Net_Pldg_qty] INT NULL,
    [qty] INT NULL,
    [close_rate] MONEY NULL,
    [total] MONEY NULL,
    [nse_approved] VARCHAR(20) NULL,
    [var_mar] MONEY NULL,
    [net_amt] MONEY NULL,
    [net_pldg_amt] MONEY NULL,
    [ISIN_Type] VARCHAR(30) NULL,
    [NBFC_Block_Qty] INT NULL,
    [Client_Type] VARCHAR(50) NULL,
    [Client_name] VARCHAR(200) NULL,
    [Migrated] VARCHAR(10) NULL,
    [qty_limit1] INT NULL,
    [qty_limit2] INT NULL,
    [BseCode] VARCHAR(20) NULL,
    [NseSymbol] VARCHAR(20) NULL,
    [id] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Proj_risk_Holding_netoff_Final_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Proj_risk_Holding_netoff_Final_Hist]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [isin] VARCHAR(20) NULL,
    [qty_rms] FLOAT NULL,
    [qty_BS] INT NOT NULL,
    [DP_qty] INT NOT NULL,
    [qty_aftercolpoolAdj] INT NOT NULL,
    [qty_aftercolpoolDPAdj] INT NOT NULL,
    [Final_qty] INT NULL,
    [clsrate] MONEY NULL,
    [total] MONEY NULL,
    [Valid_var] DECIMAL(10, 2) NULL,
    [Valid_Var_Shortage] MONEY NULL,
    [Haircut] DECIMAL(14, 6) NULL,
    [Holding_AHC] MONEY NULL,
    [scrip_category] VARCHAR(50) NULL,
    [upd_date] DATETIME NOT NULL,
    [insert_date] DATETIME NOT NULL,
    [qty_rms_new] INT NULL,
    [MarginPledge_qty] INT NULL,
    [cusa_qty] INT NULL,
    [mtf_qty] INT NULL,
    [Unpledge_qty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_PROJRISK_AFTERDPDJ_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_PROJRISK_AFTERDPDJ_HIST]
(
    [Region] VARCHAR(200) NULL,
    [Branch] VARCHAR(200) NULL,
    [SB] VARCHAR(1000) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [proj_risk] MONEY NULL,
    [DP_ADJ_HOLDING] DECIMAL(15, 2) NULL,
    [Proj_Risk_After_Adj] DECIMAL(15, 2) NULL,
    [UpdateDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_projRisk_Varshortage_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_projRisk_Varshortage_Hist]
(
    [cltcode] VARCHAR(25) NULL,
    [Ledger_BO] MONEY NULL,
    [BOD_Margin] MONEY NULL,
    [DIFF_Margin] MONEY NULL,
    [Tota_Margin] MONEY NULL,
    [Final Margin-50% ] MONEY NULL,
    [FUT_MTM] MONEY NULL,
    [TODAY_Premium] MONEY NULL,
    [Final_Ledger] MONEY NULL,
    [Holding] MONEY NULL,
    [Holding_AHC] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [Upd_date] DATETIME NOT NULL,
    [Valid_Var_Shortage] MONEY NULL,
    [Final_Valid_Var_Shortage] MONEY NULL,
    [insert_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_collection_BRANCH_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_collection_BRANCH_Hist]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [RegionName] VARCHAR(50) NULL,
    [BranchName] CHAR(40) NULL,
    [SB_Name] VARCHAR(100) NULL,
    [NoOfClients] INT NULL,
    [ParentTag] VARCHAR(10) NULL,
    [BrType] VARCHAR(10) NULL,
    [BrCategory] VARCHAR(10) NULL,
    [SB_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(25) NULL,
    [cli_count] INT NULL,
    [BSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSEFO_Ledger] MONEY NULL DEFAULT ((0)),
    [MCD_Ledger] MONEY NULL DEFAULT ((0)),
    [NSX_Ledger] MONEY NULL DEFAULT ((0)),
    [MCX_Ledger] MONEY NULL DEFAULT ((0)),
    [NCDEX_Ledger] MONEY NULL DEFAULT ((0)),
    [NBFC_Ledger] MONEY NULL DEFAULT ((0)),
    [Cash] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Derivatives] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Currency] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Commodities] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [DP] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [NBFC] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Deposit] MONEY NULL DEFAULT ((0)),
    [Net] MONEY NULL DEFAULT ((0)),
    [Hold_BlueChip] MONEY NULL DEFAULT ((0)),
    [Hold_Good] MONEY NULL DEFAULT ((0)),
    [Hold_Poor] MONEY NULL DEFAULT ((0)),
    [Hold_Junk] MONEY NULL DEFAULT ((0)),
    [App.Holding] MONEY NULL DEFAULT ((0)),
    [Non-App.Holding] MONEY NULL DEFAULT ((0)),
    [Holding] MONEY NULL DEFAULT ((0)),
    [SB Balance] MONEY NULL DEFAULT ((0)),
    [ProjRisk] MONEY NULL DEFAULT ((0)),
    [PureRisk] MONEY NULL DEFAULT ((0)),
    [MOS] MONEY NULL DEFAULT ((0)),
    [UnbookedLoss] MONEY NULL DEFAULT ((0)),
    [IMargin] MONEY NULL DEFAULT ((0)),
    [Total_Colleteral] MONEY NULL DEFAULT ((0)),
    [Margin_Shortage] MONEY NULL DEFAULT ((0)),
    [Un_Reco] MONEY NULL DEFAULT ((0)),
    [Exposure] MONEY NULL DEFAULT ((0)),
    [PureAdj] MONEY NULL DEFAULT ((0)),
    [ProjAdj] MONEY NULL DEFAULT ((0)),
    [SB_MOS] MONEY NULL,
    [SB_ROI] MONEY NULL DEFAULT ((0)),
    [SB_Credit] MONEY NULL DEFAULT ((0)),
    [SB_ClientCount] INT NULL DEFAULT ((0)),
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithLegal] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjLegal] MONEY NULL DEFAULT ((0)),
    [SB_LegalRisk] MONEY NULL DEFAULT ((0)),
    [Tot_PureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_PureRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ClientRisk] MONEY NULL DEFAULT ((0)),
    [Tot_SBRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [SB_BalanceCr] MONEY NULL DEFAULT ((0)),
    [RMS_DATE] DATETIME NULL DEFAULT (getdate()),
    [Net_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL DEFAULT ((0)),
    [Proj_Net_Collection] MONEY NULL DEFAULT ((0)),
    [br_credit] MONEY NULL DEFAULT ((0)),
    [BR_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [BSX_Ledger] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLI_ABL_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLI_ABL_HIST]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [BSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_BSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_BSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_BSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_Perc] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec_Perc] NUMERIC(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [RMS_DATE] DATETIME NOT NULL,
    [BSX_Ledger] MONEY NULL,
    [Coll_BSX] MONEY NULL,
    [Exp_BSX] MONEY NULL,
    [Margin_BSX] MONEY NULL,
    [mtf_Ledger] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLI_ACBPL_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLI_ACBPL_HIST]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [BSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_BSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_BSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_BSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_Perc] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec_Perc] NUMERIC(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [RMS_DATE] DATETIME NOT NULL,
    [BSX_Ledger] MONEY NULL,
    [Coll_BSX] MONEY NULL,
    [Exp_BSX] MONEY NULL,
    [Margin_BSX] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLIENT_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(15) NULL,
    [RegionName] VARCHAR(50) NULL,
    [Branch] VARCHAR(10) NULL,
    [BranchName] VARCHAR(40) NULL,
    [SB] VARCHAR(10) NULL,
    [SB_Name] VARCHAR(100) NULL,
    [Client] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Category] VARCHAR(10) NULL,
    [RiskCategoryCode] INT NULL DEFAULT ((0)),
    [Priorities] VARCHAR(15) NULL DEFAULT '',
    [DrNoOfDays] INT NULL DEFAULT ((0)),
    [Debit_Priorities] VARCHAR(15) NULL,
    [Classification] VARCHAR(10) NULL DEFAULT 'Others',
    [Cli_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(25) NULL,
    [Cash] MONEY NULL DEFAULT ((0)),
    [Derivatives] MONEY NULL DEFAULT ((0)),
    [Currency] MONEY NULL DEFAULT ((0)),
    [Commodities] MONEY NULL DEFAULT ((0)),
    [DP] MONEY NULL,
    [NBFC] MONEY NULL DEFAULT ((0)),
    [ABL_Net] MONEY NULL DEFAULT ((0)),
    [ACBL_Net] MONEY NULL DEFAULT ((0)),
    [NBFC_Net] MONEY NULL DEFAULT ((0)),
    [Deposit] MONEY NULL DEFAULT ((0)),
    [Net_Debit] MONEY NULL DEFAULT ((0)),
    [Net_Available] MONEY NULL DEFAULT ((0)),
    [BSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSEFO_Ledger] MONEY NULL DEFAULT ((0)),
    [MCD_Ledger] MONEY NULL DEFAULT ((0)),
    [NSX_Ledger] MONEY NULL DEFAULT ((0)),
    [MCX_Ledger] MONEY NULL DEFAULT ((0)),
    [NCDEX_Ledger] MONEY NULL DEFAULT ((0)),
    [NBFC_Ledger] MONEY NULL DEFAULT ((0)),
    [Net_Ledger] MONEY NULL DEFAULT ((0)),
    [UnReco_Credit] MONEY NULL DEFAULT ((0)),
    [Hold_BlueChip] MONEY NULL DEFAULT ((0)),
    [Hold_Good] MONEY NULL DEFAULT ((0)),
    [Hold_Poor] MONEY NULL DEFAULT ((0)),
    [Hold_Junk] MONEY NULL DEFAULT ((0)),
    [Hold_Total] MONEY NULL DEFAULT ((0)),
    [Hold_TotalHC] MONEY NULL DEFAULT ((0)),
    [Coll_NSEFO] MONEY NULL DEFAULT ((0)),
    [Coll_MCD] MONEY NULL DEFAULT ((0)),
    [Coll_NSX] MONEY NULL DEFAULT ((0)),
    [Coll_MCX] MONEY NULL DEFAULT ((0)),
    [Coll_NCDEX] MONEY NULL DEFAULT ((0)),
    [Coll_Total] MONEY NULL DEFAULT ((0)),
    [Coll_TotalHC] MONEY NULL DEFAULT ((0)),
    [Exp_NSEFO] MONEY NULL DEFAULT ((0)),
    [Exp_MCD] MONEY NULL DEFAULT ((0)),
    [Exp_NSX] MONEY NULL DEFAULT ((0)),
    [Exp_MCX] MONEY NULL DEFAULT ((0)),
    [Exp_NCDEX] MONEY NULL DEFAULT ((0)),
    [Exp_Cash] MONEY NULL DEFAULT ((0)),
    [Exp_Gross] MONEY NULL DEFAULT ((0)),
    [Margin_NSEFO] MONEY NULL DEFAULT ((0)),
    [Margin_MCD] MONEY NULL DEFAULT ((0)),
    [Margin_NSX] MONEY NULL DEFAULT ((0)),
    [Margin_MCX] MONEY NULL DEFAULT ((0)),
    [Margin_NCDEX] MONEY NULL DEFAULT ((0)),
    [Margin_Total] MONEY NULL DEFAULT ((0)),
    [Margin_Shortage] MONEY NULL DEFAULT ((0)),
    [Margin_Violation] MONEY NULL DEFAULT ((0)),
    [MOS] MONEY NULL DEFAULT ((0)),
    [Pure_Risk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjwithPureRisk] MONEY NULL DEFAULT ((0)),
    [Proj_Risk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjwithProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_Cr_Adjusted] MONEY NULL DEFAULT ((0)),
    [UB_Loss] MONEY NULL DEFAULT ((0)),
    [CashColl_Total] MONEY NULL DEFAULT ((0)),
    [Debit_Days] INT NULL DEFAULT ((0)),
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [RMS_DATE] DATETIME NULL DEFAULT (getdate()),
    [Net_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL DEFAULT ((0)),
    [Proj_Net_Collection] MONEY NULL DEFAULT ((0)),
    [BSX_Ledger] MONEY NULL DEFAULT ((0)),
    [Coll_BSX] MONEY NULL DEFAULT ((0)),
    [Exp_BSX] MONEY NULL DEFAULT ((0)),
    [Margin_BSX] MONEY NULL DEFAULT ((0)),
    [mtf_Ledger] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLIENT_HIST_new
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST_new]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(10) NULL,
    [RegionName] VARCHAR(50) NULL,
    [Branch] VARCHAR(10) NULL,
    [BranchName] VARCHAR(40) NULL,
    [SB] VARCHAR(10) NULL,
    [SB_Name] VARCHAR(100) NULL,
    [Client] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Category] VARCHAR(10) NULL,
    [RiskCategoryCode] INT NULL DEFAULT ((0)),
    [Priorities] VARCHAR(15) NULL DEFAULT '',
    [DrNoOfDays] INT NULL DEFAULT ((0)),
    [Debit_Priorities] VARCHAR(15) NULL,
    [Classification] VARCHAR(10) NULL DEFAULT 'Others',
    [Cli_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(10) NULL,
    [Cash] MONEY NULL DEFAULT ((0)),
    [Derivatives] MONEY NULL DEFAULT ((0)),
    [Currency] MONEY NULL DEFAULT ((0)),
    [Commodities] MONEY NULL DEFAULT ((0)),
    [DP] MONEY NULL,
    [NBFC] MONEY NULL DEFAULT ((0)),
    [ABL_Net] MONEY NULL DEFAULT ((0)),
    [ACBL_Net] MONEY NULL DEFAULT ((0)),
    [NBFC_Net] MONEY NULL DEFAULT ((0)),
    [Deposit] MONEY NULL DEFAULT ((0)),
    [Net_Debit] MONEY NULL DEFAULT ((0)),
    [Net_Available] MONEY NULL DEFAULT ((0)),
    [BSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSEFO_Ledger] MONEY NULL DEFAULT ((0)),
    [MCD_Ledger] MONEY NULL DEFAULT ((0)),
    [NSX_Ledger] MONEY NULL DEFAULT ((0)),
    [MCX_Ledger] MONEY NULL DEFAULT ((0)),
    [NCDEX_Ledger] MONEY NULL DEFAULT ((0)),
    [NBFC_Ledger] MONEY NULL DEFAULT ((0)),
    [Net_Ledger] MONEY NULL DEFAULT ((0)),
    [UnReco_Credit] MONEY NULL DEFAULT ((0)),
    [Hold_BlueChip] MONEY NULL DEFAULT ((0)),
    [Hold_Good] MONEY NULL DEFAULT ((0)),
    [Hold_Poor] MONEY NULL DEFAULT ((0)),
    [Hold_Junk] MONEY NULL DEFAULT ((0)),
    [Hold_Total] MONEY NULL DEFAULT ((0)),
    [Hold_TotalHC] MONEY NULL DEFAULT ((0)),
    [Coll_NSEFO] MONEY NULL DEFAULT ((0)),
    [Coll_MCD] MONEY NULL DEFAULT ((0)),
    [Coll_NSX] MONEY NULL DEFAULT ((0)),
    [Coll_MCX] MONEY NULL DEFAULT ((0)),
    [Coll_NCDEX] MONEY NULL DEFAULT ((0)),
    [Coll_Total] MONEY NULL DEFAULT ((0)),
    [Coll_TotalHC] MONEY NULL DEFAULT ((0)),
    [Exp_NSEFO] MONEY NULL DEFAULT ((0)),
    [Exp_MCD] MONEY NULL DEFAULT ((0)),
    [Exp_NSX] MONEY NULL DEFAULT ((0)),
    [Exp_MCX] MONEY NULL DEFAULT ((0)),
    [Exp_NCDEX] MONEY NULL DEFAULT ((0)),
    [Exp_Cash] MONEY NULL DEFAULT ((0)),
    [Exp_Gross] MONEY NULL DEFAULT ((0)),
    [Margin_NSEFO] MONEY NULL DEFAULT ((0)),
    [Margin_MCD] MONEY NULL DEFAULT ((0)),
    [Margin_NSX] MONEY NULL DEFAULT ((0)),
    [Margin_MCX] MONEY NULL DEFAULT ((0)),
    [Margin_NCDEX] MONEY NULL DEFAULT ((0)),
    [Margin_Total] MONEY NULL DEFAULT ((0)),
    [Margin_Shortage] MONEY NULL DEFAULT ((0)),
    [Margin_Violation] MONEY NULL DEFAULT ((0)),
    [MOS] MONEY NULL DEFAULT ((0)),
    [Pure_Risk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjwithPureRisk] MONEY NULL DEFAULT ((0)),
    [Proj_Risk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjwithProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_Cr_Adjusted] MONEY NULL DEFAULT ((0)),
    [UB_Loss] MONEY NULL DEFAULT ((0)),
    [CashColl_Total] MONEY NULL DEFAULT ((0)),
    [Debit_Days] INT NULL DEFAULT ((0)),
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [RMS_DATE] DATETIME NULL DEFAULT (getdate()),
    [Net_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL DEFAULT ((0)),
    [Proj_Net_Collection] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLIENT_HIST_NXT
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST_NXT]
(
    [Client] VARCHAR(10) NULL,
    [RMS_DATE] DATETIME NULL,
    [BSECM] DECIMAL(15, 2) NULL,
    [NSECM] DECIMAL(15, 2) NULL,
    [NSEFO] DECIMAL(15, 2) NULL,
    [MCD] DECIMAL(15, 2) NULL,
    [NCDEX] DECIMAL(15, 2) NULL,
    [MCX] DECIMAL(15, 2) NULL,
    [NSX] DECIMAL(15, 2) NULL,
    [NBFC] DECIMAL(15, 2) NULL,
    [Deposit  (Cli)] DECIMAL(15, 2) NULL,
    [Net Debit] DECIMAL(15, 2) NULL,
    [History Date] VARCHAR(30) NULL,
    [Net Collection] DECIMAL(15, 2) NULL,
    [Gross Collection] DECIMAL(15, 2) NULL,
    [BlueChip] DECIMAL(15, 2) NULL,
    [Good] DECIMAL(15, 2) NULL,
    [Average] DECIMAL(15, 2) NULL,
    [Poor] DECIMAL(15, 2) NULL,
    [Total  Holding] DECIMAL(15, 2) NULL,
    [Total Collateral] DECIMAL(15, 2) NULL,
    [Gross Exposure] DECIMAL(15, 2) NULL,
    [Total Margin] DECIMAL(15, 2) NULL,
    [Pure Risk] DECIMAL(15, 2) NULL,
    [SB Proj. Risk] DECIMAL(15, 2) NULL,
    [UnReco. Credit] DECIMAL(15, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLIENT_HIST_NXT_New
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST_NXT_New]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(15) NULL,
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
    [SB_Category] VARCHAR(25) NULL,
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [RMS_DATE] DATETIME NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [BSX_Ledger] MONEY NULL,
    [Coll_BSX] MONEY NULL,
    [Exp_BSX] MONEY NULL,
    [Margin_BSX] MONEY NULL,
    [mtf_Ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_CLIENT_HIST_QTR_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_CLIENT_HIST_QTR_DATA]
(
    [Zone] VARCHAR(25) NULL,
    [Region] VARCHAR(10) NULL,
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
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [RMS_DATE] DATETIME NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_collection_REGION_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_collection_REGION_Hist]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [RegionName] VARCHAR(50) NULL,
    [NoOfClients] INT NULL,
    [ParentTag] VARCHAR(10) NULL,
    [BrType] VARCHAR(10) NULL,
    [BrCategory] VARCHAR(10) NULL,
    [SB_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(25) NULL,
    [cli_count] INT NULL,
    [BSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSEFO_Ledger] MONEY NULL DEFAULT ((0)),
    [MCD_Ledger] MONEY NULL DEFAULT ((0)),
    [NSX_Ledger] MONEY NULL DEFAULT ((0)),
    [MCX_Ledger] MONEY NULL DEFAULT ((0)),
    [NCDEX_Ledger] MONEY NULL DEFAULT ((0)),
    [NBFC_Ledger] MONEY NULL DEFAULT ((0)),
    [Cash] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Derivatives] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Currency] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Commodities] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [DP] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [NBFC] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Deposit] MONEY NULL DEFAULT ((0)),
    [Net] MONEY NULL DEFAULT ((0)),
    [Hold_BlueChip] MONEY NULL DEFAULT ((0)),
    [Hold_Good] MONEY NULL DEFAULT ((0)),
    [Hold_Poor] MONEY NULL DEFAULT ((0)),
    [Hold_Junk] MONEY NULL DEFAULT ((0)),
    [App.Holding] MONEY NULL DEFAULT ((0)),
    [Non-App.Holding] MONEY NULL DEFAULT ((0)),
    [Holding] MONEY NULL DEFAULT ((0)),
    [SB Balance] MONEY NULL DEFAULT ((0)),
    [ProjRisk] MONEY NULL DEFAULT ((0)),
    [PureRisk] MONEY NULL DEFAULT ((0)),
    [MOS] MONEY NULL DEFAULT ((0)),
    [UnbookedLoss] MONEY NULL DEFAULT ((0)),
    [IMargin] MONEY NULL DEFAULT ((0)),
    [Total_Colleteral] MONEY NULL DEFAULT ((0)),
    [Margin_Shortage] MONEY NULL DEFAULT ((0)),
    [Un_Reco] MONEY NULL DEFAULT ((0)),
    [Exposure] MONEY NULL DEFAULT ((0)),
    [PureAdj] MONEY NULL DEFAULT ((0)),
    [ProjAdj] MONEY NULL DEFAULT ((0)),
    [SB_MOS] MONEY NULL,
    [SB_ROI] MONEY NULL DEFAULT ((0)),
    [SB_Credit] MONEY NULL DEFAULT ((0)),
    [SB_ClientCount] INT NULL DEFAULT ((0)),
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithLegal] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjLegal] MONEY NULL DEFAULT ((0)),
    [SB_LegalRisk] MONEY NULL DEFAULT ((0)),
    [Tot_PureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_PureRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ClientRisk] MONEY NULL DEFAULT ((0)),
    [Tot_SBRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [SB_BalanceCr] MONEY NULL DEFAULT ((0)),
    [RMS_DATE] DATETIME NULL DEFAULT (getdate()),
    [Net_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL DEFAULT ((0)),
    [Proj_Net_Collection] MONEY NULL DEFAULT ((0)),
    [br_credit] MONEY NULL DEFAULT ((0)),
    [BR_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [BSX_Ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rms_collection_sb
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rms_collection_sb]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [cli_category] VARCHAR(5) NULL,
    [cli_Priorities] VARCHAR(15) NULL,
    [cli_count] INT NULL,
    [cli_RiskCategoryCode] INT NULL,
    [Cash] DECIMAL(38, 2) NULL,
    [Derivatives] DECIMAL(38, 2) NULL,
    [Currency] DECIMAL(38, 2) NULL,
    [Commodities] DECIMAL(38, 2) NULL,
    [DP] DECIMAL(38, 2) NULL,
    [NBFC] DECIMAL(38, 2) NULL,
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
    [ProjAdj] MONEY NULL,
    [SB_Category] VARCHAR(5) NULL,
    [SB_MOS] MONEY NULL,
    [SB_Type] VARCHAR(3) NULL,
    [SB_ROI] MONEY NULL,
    [SB_Credit] MONEY NULL,
    [SB_PureRisk] MONEY NULL,
    [SB_ProjRisk] MONEY NULL,
    [SB_ClientCount] INT NULL DEFAULT ((0)),
    [Upd_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_SB_ABL_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_SB_ABL_HIST]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [cli_category] VARCHAR(5) NULL,
    [cli_Priorities] VARCHAR(15) NULL,
    [cli_count] INT NULL,
    [cli_RiskCategoryCode] INT NULL,
    [Cash] NUMERIC(38, 2) NULL,
    [Derivatives] NUMERIC(38, 2) NULL,
    [Currency] NUMERIC(38, 2) NULL,
    [Commodities] NUMERIC(38, 2) NULL,
    [DP] NUMERIC(38, 2) NULL,
    [NBFC] NUMERIC(38, 2) NULL,
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
    [ProjAdj] MONEY NULL,
    [SB_Category] VARCHAR(25) NULL,
    [SB_MOS] MONEY NULL,
    [SB_Type] VARCHAR(3) NULL,
    [SB_ROI] MONEY NULL,
    [SB_Credit] MONEY NULL,
    [SB_ClientCount] INT NULL,
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [DrCr] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL,
    [SB_CrAdjWithLegal] MONEY NULL,
    [SB_CrAfterAdjLegal] MONEY NULL,
    [SB_LegalRisk] MONEY NULL,
    [Tot_PureRisk] MONEY NULL,
    [SB_CrAdjWithPureRisk] MONEY NULL,
    [SB_CrAfterAdjPureRisk] MONEY NULL,
    [SB_PureRisk] MONEY NULL,
    [Tot_ClientRisk] MONEY NULL,
    [Tot_SBRisk] MONEY NULL,
    [Tot_ProjRisk] MONEY NULL,
    [SB_CrAdjWithProjRisk] MONEY NULL,
    [SB_CrAfterAdjProjRisk] MONEY NULL,
    [SB_ProjRisk] MONEY NULL,
    [SB_CrAdjusted] MONEY NULL,
    [SB_BalanceCr] MONEY NULL,
    [Cli_Percent] MONEY NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_perc] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec_Perc] NUMERIC(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [br_credit] MONEY NULL,
    [BR_CrAdjusted] MONEY NULL,
    [RMS_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_RMS_COLLECTION_SB_ACBPL_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_RMS_COLLECTION_SB_ACBPL_HIST]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [cli_category] VARCHAR(5) NULL,
    [cli_Priorities] VARCHAR(15) NULL,
    [cli_count] INT NULL,
    [cli_RiskCategoryCode] INT NULL,
    [Cash] NUMERIC(38, 2) NULL,
    [Derivatives] NUMERIC(38, 2) NULL,
    [Currency] NUMERIC(38, 2) NULL,
    [Commodities] NUMERIC(38, 2) NULL,
    [DP] NUMERIC(38, 2) NULL,
    [NBFC] NUMERIC(38, 2) NULL,
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
    [ProjAdj] MONEY NULL,
    [SB_Category] VARCHAR(25) NULL,
    [SB_MOS] MONEY NULL,
    [SB_Type] VARCHAR(3) NULL,
    [SB_ROI] MONEY NULL,
    [SB_Credit] MONEY NULL,
    [SB_ClientCount] INT NULL,
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [DrCr] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL,
    [SB_CrAdjWithLegal] MONEY NULL,
    [SB_CrAfterAdjLegal] MONEY NULL,
    [SB_LegalRisk] MONEY NULL,
    [Tot_PureRisk] MONEY NULL,
    [SB_CrAdjWithPureRisk] MONEY NULL,
    [SB_CrAfterAdjPureRisk] MONEY NULL,
    [SB_PureRisk] MONEY NULL,
    [Tot_ClientRisk] MONEY NULL,
    [Tot_SBRisk] MONEY NULL,
    [Tot_ProjRisk] MONEY NULL,
    [SB_CrAdjWithProjRisk] MONEY NULL,
    [SB_CrAfterAdjProjRisk] MONEY NULL,
    [SB_ProjRisk] MONEY NULL,
    [SB_CrAdjusted] MONEY NULL,
    [SB_BalanceCr] MONEY NULL,
    [Cli_Percent] MONEY NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_perc] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec] NUMERIC(15, 2) NULL,
    [Risk_Inc_Dec_Perc] NUMERIC(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [br_credit] MONEY NULL,
    [BR_CrAdjusted] MONEY NULL,
    [RMS_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RMS_collection_SB_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RMS_collection_SB_Hist]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [RegionName] VARCHAR(50) NULL,
    [BranchName] CHAR(40) NULL,
    [SB_Name] VARCHAR(100) NULL,
    [NoOfClients] INT NULL,
    [ParentTag] VARCHAR(10) NULL,
    [BrType] VARCHAR(10) NULL,
    [BrCategory] VARCHAR(10) NULL,
    [SB_Type] VARCHAR(10) NULL,
    [SB_Category] VARCHAR(25) NULL,
    [cli_count] INT NULL,
    [BSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSE_Ledger] MONEY NULL DEFAULT ((0)),
    [NSEFO_Ledger] MONEY NULL DEFAULT ((0)),
    [MCD_Ledger] MONEY NULL DEFAULT ((0)),
    [NSX_Ledger] MONEY NULL DEFAULT ((0)),
    [MCX_Ledger] MONEY NULL DEFAULT ((0)),
    [NCDEX_Ledger] MONEY NULL DEFAULT ((0)),
    [NBFC_Ledger] MONEY NULL DEFAULT ((0)),
    [Cash] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Derivatives] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Currency] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Commodities] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [DP] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [NBFC] DECIMAL(38, 2) NULL DEFAULT ((0)),
    [Deposit] MONEY NULL DEFAULT ((0)),
    [Net] MONEY NULL DEFAULT ((0)),
    [Hold_BlueChip] MONEY NULL DEFAULT ((0)),
    [Hold_Good] MONEY NULL DEFAULT ((0)),
    [Hold_Poor] MONEY NULL DEFAULT ((0)),
    [Hold_Junk] MONEY NULL DEFAULT ((0)),
    [App.Holding] MONEY NULL DEFAULT ((0)),
    [Non-App.Holding] MONEY NULL DEFAULT ((0)),
    [Holding] MONEY NULL DEFAULT ((0)),
    [SB Balance] MONEY NULL DEFAULT ((0)),
    [ProjRisk] MONEY NULL DEFAULT ((0)),
    [PureRisk] MONEY NULL DEFAULT ((0)),
    [MOS] MONEY NULL DEFAULT ((0)),
    [UnbookedLoss] MONEY NULL DEFAULT ((0)),
    [IMargin] MONEY NULL DEFAULT ((0)),
    [Total_Colleteral] MONEY NULL DEFAULT ((0)),
    [Margin_Shortage] MONEY NULL DEFAULT ((0)),
    [Un_Reco] MONEY NULL DEFAULT ((0)),
    [Exposure] MONEY NULL DEFAULT ((0)),
    [PureAdj] MONEY NULL DEFAULT ((0)),
    [ProjAdj] MONEY NULL DEFAULT ((0)),
    [SB_MOS] MONEY NULL,
    [SB_ROI] MONEY NULL DEFAULT ((0)),
    [SB_Credit] MONEY NULL DEFAULT ((0)),
    [SB_ClientCount] INT NULL DEFAULT ((0)),
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithLegal] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjLegal] MONEY NULL DEFAULT ((0)),
    [SB_LegalRisk] MONEY NULL DEFAULT ((0)),
    [Tot_PureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjPureRisk] MONEY NULL DEFAULT ((0)),
    [SB_PureRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ClientRisk] MONEY NULL DEFAULT ((0)),
    [Tot_SBRisk] MONEY NULL DEFAULT ((0)),
    [Tot_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjWithProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAfterAdjProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_ProjRisk] MONEY NULL DEFAULT ((0)),
    [SB_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [SB_BalanceCr] MONEY NULL DEFAULT ((0)),
    [RMS_DATE] DATETIME NULL DEFAULT (getdate()),
    [Net_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection] MONEY NULL DEFAULT ((0)),
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL DEFAULT ((0)),
    [Proj_Net_Collection] MONEY NULL DEFAULT ((0)),
    [br_credit] MONEY NULL DEFAULT ((0)),
    [BR_CrAdjusted] MONEY NULL DEFAULT ((0)),
    [BSX_Ledger] MONEY NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rms_collection_subbroker_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rms_collection_subbroker_hist]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [cli_category] VARCHAR(5) NULL,
    [cli_Priorities] VARCHAR(15) NULL,
    [cli_count] INT NULL,
    [cli_RiskCategoryCode] INT NULL,
    [Cash] DECIMAL(38, 2) NULL,
    [Derivatives] DECIMAL(38, 2) NULL,
    [Currency] DECIMAL(38, 2) NULL,
    [Commodities] DECIMAL(38, 2) NULL,
    [DP] DECIMAL(38, 2) NULL,
    [NBFC] DECIMAL(38, 2) NULL,
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
    [ProjAdj] MONEY NULL,
    [SB_Category] VARCHAR(25) NULL,
    [SB_MOS] MONEY NULL,
    [SB_Type] VARCHAR(3) NULL,
    [SB_ROI] MONEY NULL,
    [SB_Credit] MONEY NULL,
    [SB_ClientCount] INT NULL,
    [Exp_Gross] MONEY NULL,
    [Report_Type] CHAR(1) NULL,
    [DrCr] CHAR(1) NULL,
    [Tot_LegalRisk] MONEY NULL,
    [SB_CrAdjWithLegal] MONEY NULL,
    [SB_CrAfterAdjLegal] MONEY NULL,
    [SB_LegalRisk] MONEY NULL,
    [Tot_PureRisk] MONEY NULL,
    [SB_CrAdjWithPureRisk] MONEY NULL,
    [SB_CrAfterAdjPureRisk] MONEY NULL,
    [SB_PureRisk] MONEY NULL,
    [Tot_ClientRisk] MONEY NULL,
    [Tot_SBRisk] MONEY NULL,
    [Tot_ProjRisk] MONEY NULL,
    [SB_CrAdjWithProjRisk] MONEY NULL,
    [SB_CrAfterAdjProjRisk] MONEY NULL,
    [SB_ProjRisk] MONEY NULL,
    [SB_CrAdjusted] MONEY NULL,
    [SB_BalanceCr] MONEY NULL,
    [Cli_Percent] MONEY NULL,
    [Net_Collection] MONEY NULL,
    [Gross_Collection] MONEY NULL,
    [Gross_Collection_perc] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec] DECIMAL(15, 2) NULL,
    [Risk_Inc_Dec_Perc] DECIMAL(15, 2) NULL,
    [Pure_Net_Collection] MONEY NULL,
    [Proj_Net_Collection] MONEY NULL,
    [pdate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rms_holding_3112023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rms_holding_3112023]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL,
    [Processdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rmscoll_hist_04112023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rmscoll_hist_04112023]
(
    [Party_Code] VARCHAR(10) NULL,
    [Cash] MONEY NULL,
    [Derivatives] MONEY NULL,
    [Currency] MONEY NULL,
    [Commodities] MONEY NULL,
    [DP] MONEY NULL,
    [NBFC] MONEY NULL,
    [ABL_Net] MONEY NULL,
    [ACBL_Net] MONEY NULL,
    [NBFC_Net] MONEY NULL,
    [Deposit] MONEY NULL,
    [Net_Debit] MONEY NULL,
    [Net_Available] MONEY NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [MCX_Ledger] MONEY NULL,
    [NCDEX_Ledger] MONEY NULL,
    [NBFC_Ledger] MONEY NULL,
    [Net_Ledger] MONEY NULL,
    [UnReco_Credit] MONEY NULL,
    [Hold_BlueChip] MONEY NULL,
    [Hold_Good] MONEY NULL,
    [Hold_Poor] MONEY NULL,
    [Hold_Junk] MONEY NULL,
    [Hold_Total] MONEY NULL,
    [Hold_TotalHC] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Coll_MCX] MONEY NULL,
    [Coll_NCDEX] MONEY NULL,
    [Coll_Total] MONEY NULL,
    [Coll_TotalHC] MONEY NULL,
    [Exp_NSEFO] MONEY NULL,
    [Exp_MCD] MONEY NULL,
    [Exp_NSX] MONEY NULL,
    [Exp_MCX] MONEY NULL,
    [Exp_NCDEX] MONEY NULL,
    [Exp_Cash] MONEY NULL,
    [Exp_Gross] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [Margin_MCX] MONEY NULL,
    [Margin_NCDEX] MONEY NULL,
    [Margin_Total] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Margin_Violation] MONEY NULL,
    [MOS] MONEY NULL,
    [Pure_Risk] MONEY NULL,
    [SB_CrAdjwithPureRisk] MONEY NULL,
    [Proj_Risk] MONEY NULL,
    [SB_CrAdjwithProjRisk] MONEY NULL,
    [SB_Cr_Adjusted] MONEY NULL,
    [UB_Loss] MONEY NULL,
    [CashColl_Total] MONEY NULL,
    [Debit_Days] INT NULL,
    [Last_Bill_Date] DATETIME NULL,
    [Report_Type] VARCHAR(10) NULL,
    [RiskCategory] VARCHAR(10) NULL,
    [PDATE] DATETIME NULL,
    [mtf_Ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Sb_Projrisk_afterdpAdj_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Sb_Projrisk_afterdpAdj_hist]
(
    [sb] VARCHAR(1000) NULL,
    [Proj_Risk_After_Adj] DECIMAL(10, 2) NULL,
    [Update_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_scrip_var
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_scrip_var]
(
    [isin] VARCHAR(15) NULL,
    [BseCode] VARCHAR(15) NULL,
    [Status] VARCHAR(20) NULL,
    [NseSymbol] VARCHAR(15) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Valid Var %] DECIMAL(15, 2) NULL,
    [BSE Var %] DECIMAL(15, 2) NULL,
    [NSE Var %] DECIMAL(15, 2) NULL,
    [CRTDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_scrip_var_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_scrip_var_hist]
(
    [isin] VARCHAR(15) NULL,
    [BseCode] VARCHAR(15) NULL,
    [Status] VARCHAR(20) NULL,
    [NseSymbol] VARCHAR(15) NULL,
    [ScripName] VARCHAR(50) NULL,
    [Exchange Var %] DECIMAL(15, 2) NOT NULL,
    [Angel Var %] DECIMAL(15, 2) NULL,
    [Valid Var %] DECIMAL(15, 2) NOT NULL,
    [BSE Var %] DECIMAL(15, 2) NULL,
    [NSE Var %] DECIMAL(15, 2) NULL,
    [CRTDT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sett_curr_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sett_curr_upload]
(
    [Contract_Date] VARCHAR(100) NULL,
    [Contract_Instrument_Type] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Last Trading Date] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Corporate_Action_level] VARCHAR(100) NULL,
    [Contract_Regular_Lot] VARCHAR(100) NULL,
    [Contract_Issue_Start_Date] VARCHAR(100) NULL,
    [Contract_Issue_Maturity_Date] VARCHAR(100) NULL,
    [Contract_Exercise_End_Date] VARCHAR(100) NULL,
    [Contract_Exercise_Style] VARCHAR(100) NULL,
    [Contract_Active_Market_Type] VARCHAR(100) NULL,
    [Contract_Open_Price] VARCHAR(100) NULL,
    [Contract_High_Price] VARCHAR(100) NULL,
    [Contract_Low_Price] VARCHAR(100) NULL,
    [Contract_Close_Price] VARCHAR(100) NULL,
    [Contract_Settlement_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Instrument_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Symbol] VARCHAR(100) NULL,
    [Contract_Underlying_Series] VARCHAR(100) NULL,
    [Contract_Underlying_Expiry_Date] VARCHAR(100) NULL,
    [Contract_Underlying_Strike_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Option_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Corporate_Action_Level] VARCHAR(100) NULL,
    [Fname] VARCHAR(100) NULL,
    [UpdateDate] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_12to10updation
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_12to10updation]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_140315eve
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_140315eve]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingAfterHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_20data_mon
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_20data_mon]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_27072016_correctdata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_27072016_correctdata]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_Abha_Vishal_Eve
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_Abha_Vishal_Eve]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_Bkp02042019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_Bkp02042019]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_Bkp29032019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_Bkp29032019]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_bkup_12122017_evening
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_bkup_12122017_evening]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_dec282015_duplicate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_dec282015_duplicate]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_ppp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_ppp]
(
    [Zone] VARCHAR(50) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(10) NULL,
    [SB] VARCHAR(50) NULL,
    [ClientType] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(50) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(20) NULL,
    [BACKOFFICECODE] VARCHAR(10) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_previousdaydata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_previousdaydata]
(
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_12to10updation
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_12to10updation]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_16042015
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_16042015]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_16042015_new
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_16042015_new]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_27072016_correctdata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_27072016_correctdata]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Abha_Vishal_Eve
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Abha_Vishal_Eve]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Bkp02042019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Bkp02042019]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Bkp02Mar2019_Renamed_By_DBA
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Bkp02Mar2019_Renamed_By_DBA]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Bkp21Dec2018
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Bkp21Dec2018]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Bkp29032019from
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Bkp29032019from]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_Bkp29Oct2018
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_Bkp29Oct2018]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_bkup_12122017_evening
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_bkup_12122017_evening]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_dec282015_duplicate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_dec282015_duplicate]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_Credit_adj] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_MANESH
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_MANESH]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_north
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_north]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_region_withoutGujregiondata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_region_withoutGujregiondata]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL,
    [NosOfDays] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_RegionSouth
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_RegionSouth]
(
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_south6day
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_south6day]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_southsixthday
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_southsixthday]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_shortage_10days_hist_vishal_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_shortage_10days_hist_vishal_test]
(
    [Zone] VARCHAR(100) NULL,
    [Region] VARCHAR(100) NULL,
    [Branch] VARCHAR(100) NULL,
    [SB] VARCHAR(20) NULL,
    [ClientCategory] VARCHAR(20) NULL,
    [SBCategory] VARCHAR(50) NULL,
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [HoldingBeforeHaircut] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Upload_NBFC_Funding_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Upload_NBFC_Funding_Scrip]
(
    [Company_Name] VARCHAR(100) NULL,
    [BSE_Scrip_Code] VARCHAR(20) NULL,
    [Haircut] VARCHAR(20) NULL,
    [Group] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [NSE_Symbol] VARCHAR(20) NULL,
    [Start_Date] VARCHAR(20) NULL,
    [End_Date] VARCHAR(20) NULL,
    [upload_date] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_CLIENT
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_CLIENT]
(
    [PARTY_CODE] VARCHAR(30) NULL,
    [COUNT] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_FOR_DELIVERY
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_FOR_DELIVERY]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [START_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_FOR_TRD
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_FOR_TRD]
(
    [MON_VDT] INT NULL,
    [YEAR_VDT] INT NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [sr_no] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_NET
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_NET]
(
    [RMS_DATE] VARCHAR(10) NULL,
    [REGION] VARCHAR(15) NULL,
    [BRANCH] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [CLI_TYPE] VARCHAR(10) NULL,
    [SB_CATEGORY] VARCHAR(10) NULL,
    [client] VARCHAR(10) NULL,
    [BSE_Ledger] MONEY NULL,
    [NSE_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [Coll_NSEFO] MONEY NULL,
    [Coll_MCD] MONEY NULL,
    [Coll_NSX] MONEY NULL,
    [Margin_NSEFO] MONEY NULL,
    [Margin_MCD] MONEY NULL,
    [Margin_NSX] MONEY NULL,
    [NSEFO_NET] MONEY NULL,
    [MCD_NET] MONEY NULL,
    [NSX_NET] MONEY NULL,
    [NET_LEDGER] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_SBDeposite
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_SBDeposite]
(
    [CLIENT] VARCHAR(10) NULL,
    [sb tag] VARCHAR(10) NULL,
    [Update_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_TTTT
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_TTTT]
(
    [DID] INT IDENTITY(1,1) NOT NULL,
    [SAUDA_DATE] DATETIME NULL,
    [ID] INT NULL,
    [FSAUDA_DATE] DATETIME NULL,
    [CLCODE] VARCHAR(10) NULL,
    [LEDGERAMOUNT] MONEY NULL,
    [CNT] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Test_abha
-- --------------------------------------------------
CREATE TABLE [dbo].[Test_abha]
(
    [TDATE] VARCHAR(10) NULL,
    [BACKOFFICECODE] VARCHAR(20) NULL,
    [LOGICALLEDGER] MONEY NULL,
    [VAHC] MONEY NULL,
    [MarginShrtExcess] MONEY NULL,
    [Process_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test1
-- --------------------------------------------------
CREATE TABLE [dbo].[test1]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [insertdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test2
-- --------------------------------------------------
CREATE TABLE [dbo].[test2]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [insertdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TMP_AM
-- --------------------------------------------------
CREATE TABLE [dbo].[TMP_AM]
(
    [rms_date] VARCHAR(11) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [BALANCE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TMP_AM1
-- --------------------------------------------------
CREATE TABLE [dbo].[TMP_AM1]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [RMS_MON] INT NULL,
    [RMS_year] INT NULL,
    [RMS_CNT] INT NULL,
    [BALANCE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TMP_AMR1
-- --------------------------------------------------
CREATE TABLE [dbo].[TMP_AMR1]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [RMS_MON] INT NULL,
    [RMS_year] INT NULL,
    [RMS_CNT] INT NULL,
    [BALANCE] MONEY NULL,
    [avg_balance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TMP_AMRR
-- --------------------------------------------------
CREATE TABLE [dbo].[TMP_AMRR]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [RMS_MON] INT NULL,
    [RMS_year] INT NULL,
    [RMS_CNT] INT NULL,
    [BALANCE] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tmp_RMS_Holding
-- --------------------------------------------------
CREATE TABLE [dbo].[Tmp_RMS_Holding]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(10) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(50) NULL,
    [partyname] VARCHAR(100) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [source] VARCHAR(2) NULL,
    [upd_date] DATETIME NULL,
    [AdjQty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmp_Tbl_NBFC_Excess_ShortageSqOff
-- --------------------------------------------------
CREATE TABLE [dbo].[tmp_Tbl_NBFC_Excess_ShortageSqOff]
(
    [zone] VARCHAR(100) NULL,
    [region] VARCHAR(100) NULL,
    [branch] VARCHAR(100) NULL,
    [sb] VARCHAR(20) NULL,
    [client] VARCHAR(20) NULL,
    [clientcategory] VARCHAR(20) NULL,
    [cli_type] VARCHAR(10) NULL,
    [sbcat] VARCHAR(50) NULL,
    [marginshrtexcess] MONEY NULL,
    [excess_credit_net] MONEY NULL,
    [shortage_after_excess_credit_adj] MONEY NULL,
    [squareoff_value] MONEY NULL,
    [nosofdays] INT NULL,
    [tdate] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VMSS_PURERISK_DPHOLDING_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[VMSS_PURERISK_DPHOLDING_HIST]
(
    [srno] INT NOT NULL,
    [isin] CHAR(12) NULL,
    [scrip_Cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [qty] INT NULL,
    [accno] VARCHAR(16) NULL,
    [total] MONEY NULL,
    [nse_approved] VARCHAR(25) NULL,
    [Net_debit] MONEY NULL,
    [Ben_Adjusted] MONEY NULL,
    [total_adj] MONEY NULL,
    [BalAfterAdj] MONEY NULL,
    [Qty_adj] INT NULL,
    [clsrate] MONEY NULL,
    [Total_Adj_Value] MONEY NULL,
    [fo_approved] VARCHAR(1) NULL,
    [Process_date] DATETIME NOT NULL,
    [FromAcc] VARCHAR(20) NULL,
    [ToAcc] VARCHAR(20) NULL,
    [ToSegment] VARCHAR(20) NULL,
    [risktype] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VMSS_PURERISK_DPHOLDING_SMSDay2
-- --------------------------------------------------
CREATE TABLE [dbo].[VMSS_PURERISK_DPHOLDING_SMSDay2]
(
    [srno] INT NOT NULL,
    [isin] CHAR(12) NULL,
    [scrip_Cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [qty] INT NULL,
    [accno] VARCHAR(16) NULL,
    [total] MONEY NULL,
    [nse_approved] VARCHAR(25) NULL,
    [Net_debit] MONEY NULL,
    [Ben_Adjusted] MONEY NULL,
    [total_adj] MONEY NULL,
    [BalAfterAdj] MONEY NULL,
    [Qty_adj] INT NULL,
    [clsrate] MONEY NULL,
    [Total_Adj_Value] MONEY NULL,
    [fo_approved] VARCHAR(1) NULL,
    [Process_date] DATETIME NOT NULL,
    [FromAcc] VARCHAR(20) NULL,
    [ToAcc] VARCHAR(20) NULL,
    [ToSegment] VARCHAR(20) NULL,
    [risktype] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VMSS_PURERISK_DPHOLDINGBEN_HIST
-- --------------------------------------------------
CREATE TABLE [dbo].[VMSS_PURERISK_DPHOLDINGBEN_HIST]
(
    [party_code] VARCHAR(10) NOT NULL,
    [net_debit] MONEY NULL,
    [angel_ben] MONEY NOT NULL,
    [Process_date] DATETIME NULL,
    [non_cash] MONEY NULL,
    [FOShrt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WC_Ageing_Tbl
-- --------------------------------------------------
CREATE TABLE [dbo].[WC_Ageing_Tbl]
(
    [RMS_Date] DATETIME NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Net_debit] MONEY NULL,
    [Debit_day1] MONEY NULL,
    [Debit_day2] MONEY NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.MKT_SB_ledBal
-- --------------------------------------------------
Create View MKT_SB_ledBal
as
	select 
	Co_Code as segment,
	Branch_Cd,Sub_Broker,
	SB_Ledger,
	RMS_date as updated_on from rms_dtsbfi with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Scrip_ValidVar_Hist
-- --------------------------------------------------

  CREATE View Scrip_ValidVar_Hist
  as
  select *,
  (
  CAse 
  when Scrip_category='Average' and Ex_VAR <40 then 40 
  when Scrip_category='Poor' then 100 
  when Scrip_category='Bluechip' or  Scrip_category='good'  and Ex_Var < 20 then 20
  else Ex_VAR end
  ) as AutoSharePO_Var
  from
  (
  select *,(Case when BSE_Var > NSE_Var then BSE_Var else NSE_var end) as Ex_VAR
  from ScripVaR_Master_Hist with (nolock)
  ) x

GO

-- --------------------------------------------------
-- VIEW dbo.Tbl_Rms_Collection_cli_hist
-- --------------------------------------------------
CREATE VIEW Tbl_Rms_Collection_cli_hist  
AS  
SELECT Client Party_Code,Cash,Derivatives,Currency,Commodities,DP,NBFC,ABL_Net,ACBL_Net,NBFC_Net,Deposit,Net_Debit  
,Net_Available,BSE_Ledger,NSE_Ledger,NSEFO_Ledger,MCD_Ledger,NSX_Ledger,MCX_Ledger,NCDEX_Ledger,NBFC_Ledger  
,Net_Ledger,UnReco_Credit,Hold_BlueChip,Hold_Good,Hold_Poor,Hold_Junk,Hold_Total,Hold_TotalHC,Coll_NSEFO,Coll_MCD  
,Coll_NSX,Coll_MCX,Coll_NCDEX,Coll_Total,Coll_TotalHC,Exp_NSEFO,Exp_MCD,Exp_NSX,Exp_MCX,Exp_NCDEX,Exp_Cash  
,Exp_Gross,Margin_NSEFO,Margin_MCD,Margin_NSX,Margin_MCX,Margin_NCDEX,Margin_Total,Margin_Shortage,Margin_Violation  
,MOS,Pure_Risk,SB_CrAdjwithPureRisk,Proj_Risk,SB_CrAdjwithProjRisk,SB_Cr_Adjusted,UB_Loss,CashColl_Total,Debit_Days  
,Last_Bill_Date,Report_Type,RiskCategory,RMS_DATE PDATE,mtf_Ledger  
FROM TBL_RMS_COLLECTION_CLIENT_HIST with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.VW_ANNEXTURE7_STOCK_LD_VIEW_DATA
-- --------------------------------------------------
/******************************************************************************
ID :- 1
CREATED BY: RUTVIJ PATIL
DATE: 20/10/2010
PURPOSE: USED TO GET DATA FOR ANNEXTURE 7 STOCK VIEW

ID :- 2
MODIFIED BY: Shweta Tiwari
DATED: 29/08/2011
REASON: Reporting Non Cash Coll is been added.              

ID :- 3    
MODIFIED BY: MANESH MUKHERJEE                
DATED: 25/08/2011                
REASON: MARKETVALUE and MARKET_BOD_VALUE is replaced with value without haricut.                
    
ID :- 4        
MODIFIED BY: PRASHANT        
DATED: 18/10/2011          
REASON: TO INCLUDE POA HOLDING        
    
ID :- 5    
MODIFIED BY: PRASHANT        
DATED: 21/01/2013    
REASON: Added a cloumn "BEN_STOCKS" as per mail received from Anand Golatkar. (Vendor Requirement)    
******************************************************************************/      
CREATE VIEW VW_ANNEXTURE7_STOCK_LD_VIEW_DATA
AS      
  SELECT A.*,      
         REPORTINGCOLL = Isnull(CONVERT(NUMERIC(14, 2), B.NONCASH), 0),    
         /*ID :- 5*/
         BEN_STOCKS = CONVERT(CHAR(14),0),
		 T2DAY_COLL_VAL = Isnull(CONVERT(NUMERIC(14, 2), B.T2DAY_COLL_VAL), 0)
  FROM   (SELECT ROW_ID = Row_number() OVER (PARTITION BY [CLIENT_CODE],SESSION_ID ORDER BY [CLIENT_CODE], TO_DELIVER_STOCKS DESC),
                 A.*
          FROM   (SELECT CONVERT(VARCHAR(10),RPT_DATE, 103)              AS [TRANSACTION_DATE],      
                         HLD.PARTY_CODE                                    AS [CLIENT_CODE],      
                         HLD.ISIN                                          AS [ISIN_ODE],      
                         CONVERT(NUMERIC(14), ( CASE      
                                                  WHEN EXCHANGE <> 'POA' THEN HLD.QTY      
                                                  ELSE 0      
                                                END ))                     AS TO_DELIVER_STOCKS,--[BEN_STOCK_QTY / COLLATERAL STOCK QTY],                          
                         CONVERT(NUMERIC(10, 0000), ( HLD.HAIRCUT / 100 )) AS [PERCENT_HAIRCUT],      
                         CONVERT(NUMERIC(14, 2), HLD.HAIRCUT)              AS HAIRCUT,      
                         CONVERT(NUMERIC(14), ( CASE      
                                                  WHEN EXCHANGE = 'POA' THEN HLD.QTY      
                                                  ELSE 0      
                                                END ))                     AS [POA_STOCKS_QTY],/* CONVERT(NUMERIC(14,2),HLD.TOTAL_WITHHC) AS MARKETVALUE, */      
                         CONVERT(NUMERIC(14, 2), HLD.TOTAL)                AS MARKETVALUE,      
                         0                                                 AS [SOURCE_TABLE],--CONVERT(NUMERIC(14,2),SU.NONCASH_COLLETERAL + SU.HOLDING_TOTAL) AS [MARKET_BOD_VALUE],                          
                         /* CONVERT(NUMERIC(14,2),SU.TOTAL) AS [MARKET_BOD_VALUE],*/      
                         CONVERT(NUMERIC(14, 2), HLD.TOTAL)                AS [MARKET_BOD_VALUE],      
                         0                                                 AS [MARKET_VALUE],      
                         HLD.T2TSCRIP                                      AS [T2T_SCRIP],      
                         CASE HLD.EXCHANGE      
                           WHEN 'BSECM' THEN 0      
                           WHEN 'NSECM' THEN 0      
                           WHEN 'POA' THEN 0      
                           WHEN 'MCDX' THEN 1      
                           WHEN 'MCX' THEN 1      
                           WHEN 'NCDX' THEN 1      
                           ELSE ''      
                         END                                               AS [SEGMENT_TYPE],
                         HLD.SESSION_ID
                  /*
                  FROM   VW_ANNEXTURE7 ANN WITH(NOLOCK)      
                         INNER JOIN VW_RMS_HOLDING_ANNEX7 HLD WITH(NOLOCK)  
                           ON ANN.PARTY_CODE = HLD.PARTY_CODE    
                         --LEFT JOIN RMS_DTCLFI_SUMM SU ON SU.PARTY_CODE = HLD.PARTY_CODE                  
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC SU WITH(NOLOCK)      
                           ON SU.PARTY_CODE = ANN.PARTY_CODE      
                              AND HLD.ISIN = SU.ISIN      
                  */
                  --FROM   VW_RMS_HOLDING_ANNEX7 HLD WITH(NOLOCK)
                  FROM   VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA HLD WITH(NOLOCK)
                         --ON ANN.PARTY_CODE = HLD.PARTY_CODE    
                         --LEFT JOIN RMS_DTCLFI_SUMM SU ON SU.PARTY_CODE = HLD.PARTY_CODE                  
                         --LEFT JOIN VW_MARKET_BOD_VALUE_CALC SU WITH(NOLOCK)
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC_LD_VIEW_DATA SU WITH(NOLOCK)
                           ON	  HLD.PARTY_CODE = SU.PARTY_CODE
                              AND HLD.ISIN = SU.ISIN
                              AND HLD.SESSION_ID = SU.SESSION_ID
                  UNION ALL
                  SELECT CONVERT(VARCHAR(10), RPT_DATE, 103)               AS TRANSACTION_DATE,
                         COLL.PARTY_CODE                                    AS [CLIENT_CODE],
                         COLL.ISIN                                          AS [ISIN_ODE],      
                         CONVERT(NUMERIC(14), COLL.QTY)                     AS TO_DELIVER_STOCKS,--[BEN_STOCK_QTY / COLLATERAL STOCK QTY],                    
                         CONVERT(NUMERIC(10, 0000), ( COLL.HAIRCUT / 100 )) AS [PERCENT_HAIRCUT],      
                         CONVERT(NUMERIC(14, 2), COLL.HAIRCUT)              AS HAIRCUT,      
                         0                                                  AS [POA_STOCKS_QTY],/* CONVERT(NUMERIC(14,2),COLL.FINALAMOUNT) AS MARKETVALUE, */      
                         CONVERT(NUMERIC(14, 2), COLL.AMOUNT)               AS MARKETVALUE,      
                         1                                                  AS [SOURCE_TABLE],--CONVERT(NUMERIC(14,2),SU1.NONCASH_COLLETERAL + SU1.HOLDING_TOTAL) AS [MARKET_BOD_VALUE],                          
                         /* CONVERT(NUMERIC(14,2),SU1.TOTAL) AS [MARKET_BOD_VALUE], */      
                         CONVERT(NUMERIC(14, 2), COLL.AMOUNT)               AS [MARKET_BOD_VALUE],      
                         0                                                  AS [MARKET_VALUE],      
                         0                                                  AS [T2T_SCRIP],      
                         CASE COLL.EXCHANGE      
                           WHEN 'BSECM' THEN 0      
                           WHEN 'NSECM' THEN 0      
                           WHEN 'POA' THEN 0      
                           WHEN 'NSE' THEN 0      
                           WHEN 'BSE' THEN 0      
                           WHEN 'MCDX' THEN 1      
                           WHEN 'MCX' THEN 1      
                           WHEN 'NCDX' THEN 1      
                           ELSE ''      
                         END                                                AS [SEGMENT_TYPE],
                         COLL.SESSION_ID
                  /*
                  FROM   VW_ANNEXTURE7 ANN WITH(NOLOCK)      
                         INNER JOIN VW_CLIENT_COLLATERALS_ANNEX7 COLL WITH(NOLOCK)      
                           ON ANN.PARTY_CODE = COLL.PARTY_CODE      
                         --LEFT JOIN RMS_DTCLFI_SUMM SU1 ON SU1.PARTY_CODE = COLL.PARTY_CODE                          
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC SU1 WITH(NOLOCK)      
                           ON SU1.PARTY_CODE = ANN.PARTY_CODE      
                              AND COLL.ISIN = SU1.ISIN      
                  */
                  
                  FROM   VW_CLIENT_COLLATERALS_ANNEX7_LD_VIEW_DATA COLL WITH(NOLOCK)     
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC_LD_VIEW_DATA SU1 WITH(NOLOCK)      
                           ON COLL.PARTY_CODE = SU1.PARTY_CODE
                              AND COLL.ISIN = SU1.ISIN
                              AND COLL.SESSION_ID = SU1.SESSION_ID
                        
                  UNION ALL      
                  SELECT CONVERT(VARCHAR(10), RPT_DATE, 103)               AS TRANSACTION_DATE,
                         NBFC.PARTYCODE                                     AS [CLIENT_CODE],      
                         NBFC.ISIN                                          AS [ISIN_ODE],      
                         CONVERT(NUMERIC(14), NBFC.NETQTY)                  AS TO_DELIVER_STOCKS,--[BEN_STOCK_QTY / COLLATERAL STOCK QTY],                    
                         CONVERT(NUMERIC(10, 0000), ( NBFC.HAIRCUT / 100 )) AS [PERCENT_HAIRCUT],      
                         CONVERT(NUMERIC(14, 2), NBFC.HAIRCUT)              AS HAIRCUT,      
                         0                                                  AS [POA_STOCKS_QTY],/* CONVERT(NUMERIC(14,2),COLL.FINALAMOUNT) AS MARKETVALUE, */      
                         CONVERT(NUMERIC(14, 2), NBFC.PFVALUE)              AS MARKETVALUE,      
                         1                                                  AS [SOURCE_TABLE],--CONVERT(NUMERIC(14,2),SU1.NONCASH_COLLETERAL + SU1.HOLDING_TOTAL) AS [MARKET_BOD_VALUE],                          
                         /* CONVERT(NUMERIC(14,2),SU1.TOTAL) AS [MARKET_BOD_VALUE], */      
                         CONVERT(NUMERIC(14, 2), NBFC.PFVALUE)              AS [MARKET_BOD_VALUE],      
                         0                                                  AS [MARKET_VALUE],      
                         0                                                  AS [T2T_SCRIP],      
                         0                                                  AS [SEGMENT_TYPE],
                         NBFC.SESSION_ID
                  /*
                  FROM   VW_ANNEXTURE7 ANN WITH(NOLOCK)      
                         INNER JOIN VW_MILES_STOCKHOLDINGDATA NBFC WITH(NOLOCK)      
                           ON ANN.PARTY_CODE = NBFC.PARTYCODE      
                         --LEFT JOIN RMS_DTCLFI_SUMM SU1 ON SU1.PARTY_CODE = COLL.PARTY_CODE                          
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC SU1 WITH(NOLOCK)      
                           ON SU1.PARTY_CODE = ANN.PARTY_CODE      
                              AND NBFC.ISIN = SU1.ISIN      
                  */
                  FROM   MILES_STOCKHOLDINGDATA_LD_VIEW_DATA NBFC WITH(NOLOCK)
                         LEFT JOIN VW_MARKET_BOD_VALUE_CALC_LD_VIEW_DATA SU1 WITH(NOLOCK)
                           ON	  NBFC.PARTYCODE = SU1.PARTY_CODE
                              AND NBFC.ISIN = SU1.ISIN
                              AND NBFC.SESSION_ID = SU1.SESSION_ID
                     ) A      
                                    
                 ) A      
         LEFT JOIN (SELECT PARTY_CODE,      
                           CASE WHEN NONCASH < 0 THEN 0 ELSE NONCASH END AS NONCASH,T2DAY_COLL_VAL,SESSION_ID
                    FROM   Vw_EXCHANGEMARGINREPORTING_FOR_LD_VIEW_DATA WITH(NOLOCK)) B      
           ON	  A.[CLIENT_CODE] = B.PARTY_CODE
              AND A.SESSION_ID = B.SESSION_ID
              AND A.ROW_ID = 1

GO

-- --------------------------------------------------
-- VIEW dbo.VW_CLIENT_COLLATERALS_ANNEX7_LD_VIEW_DATA
-- --------------------------------------------------
CREATE VIEW VW_CLIENT_COLLATERALS_ANNEX7_LD_VIEW_DATA
AS    
    SELECT	PARTY_CODE,
			ISIN,
			EXCHANGE,
			SUM(QTY)AS QTY,
			--SUM(HAIRCUT)AS HAIRCUT,
			MAX(HAIRCUT)AS HAIRCUT,
			SUM(FINALAMOUNT)AS FINALAMOUNT,
			SUM(AMOUNT)AS AMOUNT,
			SESSION_ID,
			RPT_Date
    FROM CLIENT_COLLATERALS_HIST_LD_VIEW_DATA
    GROUP BY PARTY_CODE,ISIN,EXCHANGE,SESSION_ID,RPT_Date

GO

-- --------------------------------------------------
-- VIEW dbo.VW_EQUITY_CLS_RATE_TMP
-- --------------------------------------------------

CREATE View VW_EQUITY_CLS_RATE_TMP        
As        
  
 Select Clsrate=A.RATE,        
        B.ISIN,        
        Accno='1203320000000066',Exchange='BSE',        
        Scrip_cd=B.BSECODE,        
        Scripname=Scripname        
 From   (select * from CP_BSECM_hist where cls_date like 'Jun 23 2014%' ) A   
        Inner Join general.dbo.Scrip_master B(NOLOCK)        
         On A.SCODE = B.BSECODE        
 Union All        
 Select Clsrate=A.CLS,        
        B.ISIN,        
        Accno='1203320000000051',Exchange='NSE',        
        Scrip_cd=isnull(bsecode,B.NSESYMBOL),        
        Scripname=Scripname        
 From   (select * from CP_NSECM_hist where cls_date like 'Jun 23 2014%' ) A   
        Left Join general.dbo.Scrip_master B(NOLOCK)        
         On A.SCRIP = B.NSESYMBOL        
            And Case        
                 When A.SERIES In ('EQ', 'BE') Then 'EQ'        
                 Else A.SERIES        
                End = Case        
                       When B.NSESERIES In ('EQ', 'BE') Then 'EQ'        
                       Else B.NSESERIES        
                      End        
 Where  --B.NSESYMBOL IS NULL AND         
  Isin Is Not Null

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_EXCHANGEMARGINREPORTING_FOR_LD_VIEW_DATA
-- --------------------------------------------------
/*      
 CHANGE ID :: 1      
 CHANGE BY :- PRASHANT PATEL      
 CHANGE DATE :- MAR 14 2012      
 REASON :- FOR NBFC CLIENTS EQ LEDGER AND HOLDING WILL BE ZERO AS CONFIRMED BY ANAND GOLATKAR.      
     
 CHANGE ID :: 2    
 CHANGE BY :- PRASHANT PATEL      
 CHANGE DATE :- JAN 11 2013    
 REASON :- T2 DAY COLLATERAL SUBTRACTING. CONFIRMED BY RAHUL SIR, ANAND GOLATKAR, BHAVIN SIR    
   
 CHANGE ID :: 3  
 CHANGE BY :- PRASHANT PATEL  
 CHANGE DATE :- JAN 15 2013  
 REASON :- New formula as per mail received from Anand Golatkar at Jan 15 2013 03:59pm  
*/      
CREATE VIEW Vw_EXCHANGEMARGINREPORTING_FOR_LD_VIEW_DATA
as
SELECT  RPT_Date,
		ZONE,              
        A.REGION,              
        BRANCH,              
        SB,              
        A.PARTY_CODE,              
        CLI_TYPE,              
        LEDGER =               
        /*REMOVE CASH COLLATERALS FROM ALL SEGMENT AS CONFIRMED BY ANAND ON JAN  7 2012*/        
        /*        
        NSEFO_LEDGER+NSEFO_DEPOSIT+NSEFO_CASHCOLL-NSEFO_UNRECO +-- NSEFO              
        NSX_LEDGER+NSX_DEPOSIT+NSX_CASHCOLL-NSX_UNRECO +-- NSX              
        MCD_LEDGER+MCD_DEPOSIT+MCD_CASHCOLL-MCD_UNRECO +-- MCD              
        */        
        NSEFO_LEDGER+NSEFO_DEPOSIT-NSEFO_UNRECO +-- NSEFO              
        NSX_LEDGER+NSX_DEPOSIT-NSX_UNRECO +-- NSX              
        MCD_LEDGER+MCD_DEPOSIT-MCD_UNRECO +-- MCD              
        CASE WHEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO > 0 AND NOT (CL_TYPE IN ('NBF','TMF')) THEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO ELSE 0 END  +-- NSECM              
        CASE WHEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO > 0 AND NOT (CL_TYPE IN ('NBF','TMF')) THEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO ELSE 0 END,  -- BSECM              
        --NONCASH=NSEFO_NONCASHCOLL+NSX_NONCASHCOLL+MCD_NONCASHCOLL+NSECM_POOLHOLD+BSECM_POOLHOLD              
        NONCASH=NSEFO_NONCASHCOLL+NSX_NONCASHCOLL+MCD_NONCASHCOLL+            
          
        CASE WHEN NOT (CL_TYPE IN ('NBF','TMF'))  
    THEN   
     CASE WHEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO > 0  
       THEN NSECM_POOLHOLD  
       ELSE   
        CASE WHEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO+NSECM_POOLHOLD > 0 AND NSECM_POOLHOLD > 0  
          THEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO+NSECM_POOLHOLD  
          ELSE 0  
        END  
     END  
    ELSE 0  
  END +-- NSECM  
  CASE WHEN NOT (CL_TYPE IN ('NBF','TMF'))  
    THEN   
     CASE WHEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO > 0  
       THEN BSECM_POOLHOLD  
       ELSE   
        CASE WHEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO+BSECM_POOLHOLD > 0 AND BSECM_POOLHOLD > 0  
          THEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO+BSECM_POOLHOLD  
          ELSE 0  
        END  
     END  
    ELSE 0  
  END +-- BSECM  
        /*  
  CASE WHEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO+NSECM_POOLHOLD > 0 AND NSECM_POOLHOLD > 0 AND NOT (CL_TYPE IN ('NBF','TMF'))  
   THEN NSECM_LEDGER+NSECM_DEPOSIT-NSECM_UNRECO+NSECM_POOLHOLD           
   ELSE 0           
  END  +-- NSECM  
  */  
  /*  
  CASE WHEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO+BSECM_POOLHOLD > 0 AND BSECM_POOLHOLD > 0 AND NOT (CL_TYPE IN ('NBF','TMF'))       
   THEN BSECM_LEDGER+BSECM_DEPOSIT-BSECM_UNRECO+BSECM_POOLHOLD           
   ELSE 0        
  END  -- BSECM        
  */  
  /*CHANGE ID :: 2*/    
  - T2DAY_COLL_VAL,T2DAY_COLL_VAL,
  SESSION_ID
FROM EXCHANGEMARGINREPORTING_DATA_LD_HIST_LD_VIEW_DATA A WITH(NOLOCK) LEFT OUTER JOIN general.dbo.CLIENT_DETAILS B WITH(NOLOCK)      
 ON A.PARTY_CODE = B.PARTY_CODE      
--WHERE A.PARTY_CODE = 'KLNS4635'

GO

-- --------------------------------------------------
-- VIEW dbo.VW_HISTORICATICAL_DATA_CLIENTWISE
-- --------------------------------------------------
CREATE VIEW VW_HISTORICATICAL_DATA_CLIENTWISE
AS
SELECT CONVERT(DECIMAL(15, 2), Sum(Isnull(bse_ledger, 0)) / 100000)       AS
       [BSECM],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(nse_ledger, 0)) / 100000)       AS
       [NSECM],
       CONVERT(DECIMAL(15, 2), Sum(nsefo_ledger) / 100000)                AS
       [NSEFO],
       CONVERT(DECIMAL(15, 2), Sum(mcd_ledger) / 100000)                  AS
       [MCD],
       CONVERT(DECIMAL(15, 2), Sum(ncdex_ledger) / 100000)                AS
       [NCDEX],
       CONVERT(DECIMAL(15, 2), Sum(mcx_ledger) / 100000)                  AS
       [MCX],
       CONVERT(DECIMAL(15, 2), Sum(nsx_ledger) / 100000)                  AS
       [NSX],
       CONVERT(DECIMAL(15, 2), Sum(nbfc_ledger) / 100000)                 AS
       [NBFC],
       CONVERT(DECIMAL(15, 2), Sum(deposit) / 100000)                     AS
       [Deposit  (Cli)],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(net_debit, 0)) / 100000)        AS
       [Net Debit],
       CONVERT(VARCHAR, rms_date, 106)                                    AS
       [History Date],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(net_collection, 0)) / 100000)   AS
       [Net Collection],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(gross_collection, 0)) / 100000) AS
       [Gross Collection],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(hold_bluechip, 0)) / 100000)    AS
       [BlueChip],
       CONVERT(DECIMAL(15, 2), Sum(hold_good) / 100000)                   AS
       [Good],
       CONVERT(DECIMAL(15, 2), Sum(Isnull(hold_poor, 0)) / 100000)        AS
       [Average],
       CONVERT(DECIMAL(15, 2), Sum(hold_junk) / 100000)                   AS
       [Poor],
       CONVERT(DECIMAL(15, 2), Sum(hold_total) / 100000)                  AS
       [Total  Holding],
       CONVERT(DECIMAL(15, 2), Sum(coll_total) / 100000)                  AS
       [Total Collateral],
       CONVERT(DECIMAL(15, 2), Sum(exp_gross) / 100000)                   AS
       [Gross Exposure],
       CONVERT(DECIMAL(15, 2), Sum(margin_total) / 100000)                AS
       [Total Margin],
       CONVERT(DECIMAL(15, 2), Sum(pure_risk) / 100000)                   AS
       [Pure Risk],
       CONVERT(DECIMAL(15, 2), Sum(proj_risk) / 100000)                   AS
       [SB Proj. Risk],
       CONVERT(DECIMAL(15, 2), Sum(unreco_credit) / 100000)               AS
       [UnReco. Credit]
FROM   tbl_rms_collection_client_hist WITH (nolock)
WHERE  rms_date > Getdate() - 30
GROUP  BY rms_date
--ORDER  BY rms_date DESC

GO

-- --------------------------------------------------
-- VIEW dbo.VW_MARKET_BOD_VALUE_CALC_LD_VIEW_DATA
-- --------------------------------------------------
/******************************************************************************                  
CREATED BY: RUTVIJ PATIL                  
DATE: 20/12/2010                  
PURPOSE: USED TO GET DATA FOR ANNEXTURE 7 STOCK VIEW            
                  
MODIFIED BY: PROGRAMMER NAME                  
DATED: DD/MM/YYYY                  
REASON: REASON TO CHANGE STORE PROCEDURE                  
******************************************************************************/                
CREATE VIEW VW_MARKET_BOD_VALUE_CALC_LD_VIEW_DATA
    
AS    
    
 SELECT A.PARTY_CODE,    
  A.ISIN,    
  SUM(A.TOTAL)AS TOTAL,SESSION_ID
 FROM    
 (    
  SELECT PARTY_CODE,ISIN,TOTAL AS TOTAL,SESSION_ID
  FROM RMS_HOLDING_LD_VIEW_DATA     
    
  UNION ALL    
      
  SELECT PARTY_CODE,ISIN,AMOUNT AS TOTAL,SESSION_ID
  FROM CLIENT_COLLATERALS_HIST_LD_VIEW_DATA  
    
  UNION ALL  
    
  SELECT PARTYCODE AS PARTY_CODE,ISIN,PFVALUE AS TOTAL,SESSION_ID
  FROM MILES_STOCKHOLDINGDATA_LD_VIEW_DATA  
    
 )A    
 GROUP BY A.PARTY_CODE,A.ISIN,SESSION_ID

GO

-- --------------------------------------------------
-- VIEW dbo.vw_miles_StockholdingData_HIST
-- --------------------------------------------------
CREATE View vw_miles_StockholdingData_HIST
as          
select    
 a.*,    
 Exchange_HairCut = Haircut,  
 total_WithHC= PFvalHC     
from         
 miles_StockholdingData (nolock)  a

GO

-- --------------------------------------------------
-- VIEW dbo.VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA
-- --------------------------------------------------
/******************************************************************************              
      
CREATED BY: RUTVIJ PATIL              
DATE: 20/10/2010              
PURPOSE: USED TO GET DATA FOR ANNEXTURE 7 STOCK VIEW    
              
MODIFIED BY: RUTVIJ PATIL              
DATED: 16/06/2011      
REASON: CHANGE MAX TO GET HAIRCUT INSTEAD OF HAIRCUT      
    
MODIFIED BY: PRASHANT    
DATED: 18/10/2011      
REASON: TO INCLUDE POA HOLDING    
  
  
MODIFIED BY: PRASHANT    
DATED: 17/12/2011      
REASON: MODIFIED SOURCE FROM NewPOA_Client_all (VIEW) TO CLIENT_POA_DETAILS (USER TABLE)  
      
******************************************************************************/            
CREATE VIEW VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA
AS        
 SELECT RPT_Date,
        PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,    
        CASE     
             WHEN EXCHANGE = 'BSECM' AND SETT_TYPE = 'C' THEN 1    
             WHEN EXCHANGE = 'NSECM' AND SETT_TYPE = 'W' THEN 1    
             ELSE 0    
        END AS T2TSCRIP,    
        SUM(QTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,          
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(TOTAL_WITHHC) AS TOTAL_WITHHC,    
        SUM(TOTAL) AS TOTAL,
        SESSION_ID
 --FROM   VW_RMS_HOLDING    
 FROM   VW_RMS_HOLDING_WITHPOA_LD_VIEW_DATA
 WHERE EXCHANGE IN ('BSECM','NSECM')  
 GROUP BY
        RPT_Date,
        PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,
        SESSION_ID
        /*    
        ADDED BY PRASHANT ON OCT 18 2011    
        REASON :: TO ADD POA HOLDING TOO    
        */    
 UNION ALL    
 SELECT RPT_Date,
        H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,    
        0 AS T2TSCRIP,    
        SUM(QTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,    
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(TOTAL_WITHHC) AS TOTAL_WITHHC,    
        SUM(TOTAL) AS TOTAL,
        SESSION_ID
  --FROM   Vw_Rms_Holding_WithPOA H    
  FROM   VW_RMS_HOLDING_WITHPOA_LD_VIEW_DATA H
    INNER JOIN   GENERAL.DBO.CLIENT_POA_DETAILS C --NewPOA_Client_all C
   ON   H.ACCNO = C.CLTDPID    
  AND   H.PARTY_CODE = C.PARTY_CODE    
 WHERE  EXCHANGE = 'POA'    
 GROUP BY
        RPT_Date,
        H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,
        SESSION_ID

GO

-- --------------------------------------------------
-- VIEW dbo.VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA_DETAILS
-- --------------------------------------------------
CREATE VIEW VW_RMS_HOLDING_ANNEX7_LD_VIEW_DATA_DETAILS
AS
    SELECT PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,    
        CASE     
             WHEN EXCHANGE = 'BSECM' AND SETT_TYPE = 'C' THEN 1    
             WHEN EXCHANGE = 'NSECM' AND SETT_TYPE = 'W' THEN 1    
             ELSE 0    
        END AS T2TSCRIP,    
        SUM(QTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,          
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(TOTAL_WITHHC) AS TOTAL_WITHHC,    
        SUM(TOTAL) AS TOTAL,
        SESSION_ID,
        SOURCE = 'POOL'
    --FROM   VW_RMS_HOLDING    
    FROM   VW_RMS_HOLDING_WITHPOA_LD_VIEW_DATA
    WHERE EXCHANGE IN ('BSECM','NSECM')  
    GROUP BY    
        PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,
        SESSION_ID
        /*    
        ADDED BY PRASHANT ON OCT 18 2011    
        REASON :: TO ADD POA HOLDING TOO    
        */    
    UNION ALL    
    SELECT H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,    
        0 AS T2TSCRIP,    
        SUM(QTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,    
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(TOTAL_WITHHC) AS TOTAL_WITHHC,    
        SUM(TOTAL) AS TOTAL,
        SESSION_ID,
        SOURCE = 'POA'
    --FROM   Vw_Rms_Holding_WithPOA H    
    FROM   VW_RMS_HOLDING_WITHPOA_LD_VIEW_DATA H
    INNER JOIN   GENERAL.DBO.CLIENT_POA_DETAILS C --NewPOA_Client_all C
    ON   H.ACCNO = C.CLTDPID    
    AND   H.PARTY_CODE = C.PARTY_CODE    
    WHERE  EXCHANGE = 'POA'    
    GROUP BY    
        H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE,
        SESSION_ID
    UNION ALL    
    SELECT H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SETT_TYPE ='',    
        0 AS T2TSCRIP,    
        SUM(QTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,    
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(FinalAmount) AS TOTAL_WITHHC,    
        SUM(Amount) AS TOTAL,
        SESSION_ID,
        SOURCE = 'COLL'
    --FROM   Vw_Rms_Holding_WithPOA H    
    FROM   CLIENT_COLLATERALS_HIST_LD_VIEW_DATA H
    GROUP BY    
        H.PARTY_CODE,    
        ISIN,    
        EXCHANGE,    
        SESSION_ID
    UNION ALL    
    SELECT H.PARTYCODE,    
        ISIN,    
        EXCHANGE = 'NBFC',    
        SETT_TYPE ='',    
        0 AS T2TSCRIP,    
        SUM(NETQTY) AS QTY, --SUM(HAIRCUT) AS HAIRCUT,    
        MAX(HAIRCUT) AS HAIRCUT,    
        SUM(PFVALHC) AS TOTAL_WITHHC,    
        SUM(PFVALUE) AS TOTAL,
        SESSION_ID,
        SOURCE = 'NBFC'
    --FROM   Vw_Rms_Holding_WithPOA H    
    FROM   MILES_STOCKHOLDINGDATA_LD_VIEW_DATA H
    GROUP BY    
        H.PARTYCODE,    
        ISIN,    
        SESSION_ID

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Rms_Holding_WithPOA_LD_VIEW_DATA
-- --------------------------------------------------
/*
    CHANGE ID		:: 1
    MODIFIED BY		:: PRASHANT
    MODIFIED DATE	:: OCT 21 2013
    REASON			:: CREATED FOR HISTORY REPORT
*/
CREATE View Vw_Rms_Holding_WithPOA_LD_VIEW_DATA
AS
    SELECT A.*,
         HairCut=(
                CASE WHEN EXCHANGE = 'NSECM'
                     THEN ISNULL(B.NSE_PROJ_VAR, 100)
                     WHEN EXCHANGE = 'BSECM'
                     THEN ISNULL(B.BSE_PROJ_VAR, 100)
                     WHEN EXCHANGE = 'POA'
                     THEN
                        CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)
                             WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)
                             ELSE 100
                        END
                     ELSE 100
                END
            ) ,
         total_WithHC=
              CASE WHEN QTY > 0
                    THEN(CLSRATE*(QTY+ISNULL(ADJQTY,0)))-((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*((
                        CASE WHEN EXCHANGE = 'NSECM'
                             THEN ISNULL(B.NSE_PROJ_VAR, 100)
                             WHEN EXCHANGE = 'BSECM'
                             THEN ISNULL(B.BSE_PROJ_VAR, 100)
                             WHEN EXCHANGE = 'POA'
                             THEN
                                CASE WHEN ISNULL(B.BSE_PROJ_VAR, 100) >= ISNULL(B.NSE_PROJ_VAR, 100)
                                     THEN ISNULL(B.BSE_PROJ_VAR, 100)
                                     WHEN ISNULL(B.BSE_PROJ_VAR, 100) < ISNULL(B.NSE_PROJ_VAR, 100)
                                     THEN ISNULL(B.NSE_PROJ_VAR, 100)
                                     ELSE 100
                                END
                             ELSE 100
                        END)/100.00))
                    ELSE (CLSRATE*(QTY+ISNULL(ADJQTY,0)))+((CLSRATE*(QTY+ISNULL(ADJQTY,0)))*(ISNULL(A.SHRT_HC,100.00)/100.00))
              END,
         ExchangeHairCut=(
                CASE WHEN EXCHANGE = 'NSECM'
                     THEN ISNULL(B.NSE_VAR, 100)
                     WHEN EXCHANGE = 'BSECM'
                     THEN ISNULL(B.BSE_VAR, 100)
                     WHEN EXCHANGE = 'POA'
                     THEN
                        CASE WHEN ISNULL(B.BSE_VAR, 100) >= ISNULL(B.NSE_VAR, 100)
                             THEN ISNULL(B.BSE_VAR, 100)
                             WHEN ISNULL(B.BSE_VAR, 100) < ISNULL(B.NSE_VAR, 100)
                             THEN ISNULL(B.NSE_VAR, 100)
                             ELSE 100
                        END
                     ELSE 100
                END)
    FROM
    (
         SELECT P.*,Q.SHRT_HC
         FROM RMS_HOLDING_LD_VIEW_DATA (NOLOCK) P
            INNER JOIN GENERAL.DBO.COMPANY (NOLOCK) Q
                ON --CASE WHEN P.EXCHANGE = 'POA' THEN 'DP' ELSE P.EXCHANGE END =Q.CO_CODE
                    P.EXCHANGE = CASE WHEN Q.CO_CODE = 'DP' THEN 'POA' ELSE Q.CO_CODE END
    ) A
        LEFT OUTER JOIN
            ScripVaR_Master_Hist_LD_VIEW_DATA (NOLOCK) B
                ON  A.ISIN=B.ISIN
                AND A.SESSION_ID = B.SESSION_ID

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_RmsDtclFi_Collection
-- --------------------------------------------------
CREATE View [dbo].[Vw_RmsDtclFi_Collection]                        
as                        
select a.*,groupname=isnull(b.groupname,'Other'),                        
Brk_Net=(case                         
when groupname='Cash' then ledger      
when groupname='NBFC' then Ledger + HoldingWithHC - Unrecosiled_Credit    
when groupname='Derivatives' then               
(case               
when imargin = 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then 0              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1      
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) > imargin then ledger              
when imargin > 0 and (imargin-ledger) < 0 then (ledger-imargin) else 0 end)              
when groupname='Commodities' then               
(case               
when imargin = 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then 0              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1      
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) > imargin then ledger              
when imargin > 0 and (imargin-ledger) < 0 then (ledger-imargin) else 0 end)              
when groupname='Currency' then               
(case               
when imargin = 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then 0              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) < 0 then ledger              
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) < imargin and (imargin-ledger)-(Cash_Colleteral+NonCash_colleteral) > 0 then ((imargin-ledger)-(Cash_Colleteral+NonCash_colleteral))*-1      
when imargin > 0 and (imargin-ledger) > 0 and (imargin-ledger) > imargin and (Cash_Colleteral+NonCash_colleteral) > imargin then ledger              
when imargin > 0 and (imargin-ledger) < 0 then (ledger-imargin) else 0 end)      
else 0 end)                        
,Ex_Net=(case                        
when groupname='Cash' then ledger                         
when groupname='NBFC' then ledger + HoldingWithHC - Unrecosiled_Credit    
when groupname='Derivatives' then (case when (imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) <= 0 then ledger else ledger-(imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) end)                
when groupname='Commodities' then (case when (imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) <= 0 then ledger else ledger-(imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) end)                 
when groupname='Currency' then (case when (imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) <= 0 then ledger else ledger-(imargin-Cash_Colleteral-(NonCash_colleteral*((100-b.Ex_NonCash_HairCut)/100))) end)                    
else 0 end)                        
from RMS_DtclFi a with (nolock),                        
(select co_code,Ex_NonCash_HairCut,groupname from general.dbo.company (nolock)) b where a.co_code=b.co_code

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SB_NonCashCollateral
-- --------------------------------------------------
CREATE View Vw_SB_NonCashCollateral 
as 
  
SELECT 
A.SB,A.Scrip_cd,A.QTY,A.co_Code,A.AMOUNT,A.isin,A.Shrt_HC, 
HairCut=(case when CO_CODE = 'BSECM' then ISNULL(b.BSE_proj_VaR, 100) 
   when (CO_CODE = 'NSECM' OR CO_CODE = 'NSEFO') then ISNULL(b.NSE_proj_VaR, 100) 
   else 100 
   end) , 
total_WithHC=case when qty > 0 then (AMOUNT)-((AMOUNT)*((case when CO_CODE = 'BSECM' then ISNULL(b.BSE_proj_VaR, 100) 
  when (CO_CODE = 'NSECM' OR CO_CODE = 'NSEFO') then ISNULL(b.NSE_proj_VaR, 100) else 100 end)/100.00)) 
  else (AMOUNT)+((AMOUNT)*(isnull(a.Shrt_HC,100.00)/100.00)) end 
from 
(select p.SB,p.Scrip_cd,p.QTY,p.co_Code,p.AMOUNT,p.isin,q.Shrt_HC from  
 (select SB,Scrip_cd,QTY,co_Code,AMOUNT,isin=(select top 1 isin from general.dbo.scrip_master where bsecode=cash.scrip_cd) 
 from 
   (SELECT SB,Scrip_cd,SUM(QTY) as QTY,Co_code,SUM(AMOUNT) as AMOUNT 
    FROM History.dbo.SB_NonCashCollateral 
where Updated_On BETWEEN '2015-03-31 00:00:00.000' AND '2015-03-31 23:59:59.000'
    GROUP BY SB,Scrip_cd,Co_code) cash) p, general.dbo.company (nolock) q where p.CO_CODE=q.co_code) a 
left outer join general.dbo.ScripVaR_Master (nolock) b 
on a.isin=b.isin

GO

