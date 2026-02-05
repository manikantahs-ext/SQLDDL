-- DDL Export
-- Server: 10.254.33.61
-- Database: FinPlan
-- Exported: 2026-02-05T11:35:11.689643

USE FinPlan;
GO

-- --------------------------------------------------
-- FUNCTION dbo.ufn_FPGetTitleCase
-- --------------------------------------------------
CREATE FUNCTION [dbo].[ufn_FPGetTitleCase] (@x varchar(7999))
RETURNS varchar(7999)
AS
  BEGIN

	DECLARE @y int
	SET @y = 1
	
	SELECT @x = UPPER(SUBSTRING(@x,1,1))+LOWER(SUBSTRING(@x,2,LEN(@x)-1))+' '
	
	WHILE @y < LEN(@x)
	  BEGIN
		SELECT @y=CHARINDEX(' ',@x,@y)
		SELECT @x=SUBSTRING(@x,1,@y)+UPPER(SUBSTRING(@x,@y+1,1))+SUBSTRING(@x,@y+2,LEN(@x)-@y+1)	
		SELECT @y=@y+1
	  END
	RETURN @x
END

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPAssessmentInsight
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPAssessmentInsight_sFpC] ON [dbo].[Tbl_FPAssessmentInsight] ([sFpCode], [sAssessmentName])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPClientInfo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPClientInfo_sFpC] ON [dbo].[Tbl_FPClientInfo] ([sFpCode], [sClientCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPClientInfo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Tbl_FPClientInfo_sTempId] ON [dbo].[Tbl_FPClientInfo] ([sTempId])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPEquityStocks
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPEquityStocks_sFpC] ON [dbo].[Tbl_FPEquityStocks] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPFixedIncome
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPFixedIncome_sFpC] ON [dbo].[Tbl_FPFixedIncome] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPHealthInsurance
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPHealthInsurance_sFpC] ON [dbo].[Tbl_FPHealthInsurance] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPHomeLoan
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPHomeLoan_sFpC] ON [dbo].[Tbl_FPHomeLoan] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPInvestmentUnder80C
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPInvestmentUnder80C_sFpC] ON [dbo].[Tbl_FPInvestmentUnder80C] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPLifeInsurance
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPLifeInsurance_sFpC] ON [dbo].[Tbl_FPLifeInsurance] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPMutualFunds
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPMutualFunds_sFpC] ON [dbo].[Tbl_FPMutualFunds] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPOtherInvestments
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPOtherInvestments_sFpC] ON [dbo].[Tbl_FPOtherInvestments] ([sFpCode])

GO

-- --------------------------------------------------
-- INDEX dbo.Tbl_FPPersonalLoan
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FinPlan_Tbl_FPPersonalLoan_sFpC] ON [dbo].[Tbl_FPPersonalLoan] ([sFpCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Tbl_FPErrorLog
-- --------------------------------------------------
ALTER TABLE [dbo].[Tbl_FPErrorLog] ADD CONSTRAINT [PK__Tbl_FPEr__80D451CBCC65832E] PRIMARY KEY ([nErrorId])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPAddAssessmentInsight
-- --------------------------------------------------
CREATE PROCEDURE [spx_FPAddAssessmentInsight]
(
	@FpCode varchar(20),
	@AssessmentName varchar(250)	
)
AS
BEGIN
	IF Exists(SELECT 1 FROM Tbl_FPAssessmentInsight With(Nolock) WHERE sfpCode = @FpCode ANd sAssessmentName= @AssessmentName) 
	BEGIN
		UPDATE Tbl_FPAssessmentInsight SET sIsRead='N' WHERE sfpCode = @FpCode ANd sAssessmentName= @AssessmentName
	END
	ELSE 
	BEGIN
		INSERT INTO Tbl_FPAssessmentInsight
		Values (@FpCode,@AssessmentName,'N',GETDATE())
	END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPCheckClientInfo
-- --------------------------------------------------
--EXEC [spx_FPCheckClientInfo] '','J56118'
CREATE PROCEDURE [dbo].[spx_FPCheckClientInfo]
(
	@TempId varchar(20) = NULL,
	@ClientCode varchar(20) = NULL
)
AS
BEGIN

	--CREATE TABLE TEMPTEST (FpCode varchar(20) PRIMARY KEY)
	--ALTER TABLE TEMPTEST Add TempId varchar(20),ClientCode varchar(20)
	Declare @FpCode varchar(20)
	SELECT @FpCode = sFpCode FROM Tbl_FPClientInfo With(Nolock)
	WHERE	(ISNULL(@TempId,'') <> ''  AND (ISNULL(sTempId,'') <> '' AND  sTempId =ISNULL(@TempId,'')))
	OR	(ISNULL(@ClientCode,'') <> ''  AND (ISNULL(sClientCode,'') <> '' AND  sClientCode =ISNULL(@ClientCode,'') ))
	
	--WHERE	(ISNULL(@TempId,'') = '' OR (TempId IS NOT NULL  AND TempId = @TempId))
	--AND		(ISNULL(@ClientCode,'') = '' OR (ClientCode IS NOT NULL  AND ClientCode= @ClientCode))

	SELECT @FpCode as FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPCheckIsValidFpCode
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPCheckIsValidFpCode] 
(
	@FpCode varchar(20) = NULL
)
AS
BEGIN


	Declare @Cnt int,@IsValid bit 
	SET @Cnt = (SELECT Count(sFpCode) FROM Tbl_FPClientInfo With(nolock) Where sFpCode = @FpCode)
	SET @IsValid = 0

	if (@Cnt>0)
	BEGIN
		SET @IsValid = 1
	END
	
	SELECT @IsValid IsValid
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetAssessmentInsights
-- --------------------------------------------------
--EXEC [spx_FPGetAssessmentInsights] 'FP000000000000000014'
CREATE PROCEDURE [spx_FPGetAssessmentInsights]
(
	@FpCode varchar(20) = NULL
)
AS
BEGIN
	SELECT sFpCode, sAssessmentName FROM Tbl_FPAssessmentInsight
	WHERE	sIsRead='N' 
	AND		sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetCarLoan
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetCarLoan]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nOutstandingAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPCarLoan WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetCityList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetCityList]
(
	@CityNameSearch Varchar(250) = NULL
)
AS
BEGIN
	SELECT nCityCode as nCityId, dbo.ufn_FPGetTitleCase(sCityName) as sCityName,sIsMetroCity
	FROM	Tbl_FPCityMaster With(nolock)
	Where	 sCityName Like ISNULL(@CityNameSearch,'') + '%'
	--UPDATE Tbl_FPCityMaster SET sIsMetroCity ='Y'  WHERE sCityName = 'DELHI'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetCityListAll
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetCityListAll]
(
	@CityNameSearch Varchar(250)= NULL
)
AS
BEGIN
	SELECT nCityCode as nCityId, dbo.ufn_FPGetTitleCase(sCityName) as sCityName,sIsMetroCity
	FROM	Tbl_FPCityMaster With(nolock)
	WHERE	sIsActive = 'Y'
	AND		sCityName like '%' + ISNULL(@CityNameSearch,'') + '%'

	--UPDATE Tbl_FPCityMaster SET sIsMetroCity ='Y'  WHERE sCityName = 'DELHI'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetClientIncome
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetClientIncome]
(
	@FpCode varchar(20)
)
AS
BEGIN
	--CREATE TABLE TEMPTEST (FpCode varchar(20) PRIMARY KEY)
	SELECT   sFpCode,nMonthlyIncomeSelf	,nMonthlyIncomeSpouse	,nMonthlyExpense	,nMonthlyEMI	,dCreatedOn	,dModifiedOn
	FROM Tbl_FPClientIncomeDetails With(Nolock) WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetClientInfo
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetClientInfo]
(
	@FpCode varchar(20)
)
AS
BEGIN
	--CREATE TABLE TEMPTEST (FpCode varchar(20) PRIMARY KEY)
	SELECT sFpCode, sTempId, nMfKycId, sClientCode, nProductId, sProductVersion
	, convert(varchar(10),dDateOfBirth,121) as dDateOfBirth
	, nLifeStage, nYoungChildren, nGrownUpChildren, nCityId, sRemarks, 
	sIpAddress,
	sBrowserInfo,
	sOsInfo,
	nReserved1,
	nReserved2,
	sReserved3,
	sReserved4,
	sReserved5,
	dCreatedOn,
	dModifiedOn,
	sIsModified,
	sDesignTemplate 
	FROM Tbl_FPClientInfo With(Nolock) WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetCurrentFinancialYear
-- --------------------------------------------------
CREATE PROCEDURE [spx_FPGetCurrentFinancialYear]
AS
BEGIN

	DECLARE @CurrentFinancialYear varchar(250)
	SET @CurrentFinancialYear = cast(CASE WHEN MONTH(GETDATE()) > 3 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END as varchar)
			+ '-' + cast(RIGHT((CASE WHEN MONTH(GETDATE()) > 3 THEN YEAR(GETDATE()) ELSE YEAR(GETDATE())-1 END + 1),2) as varchar) 

	SELECT @CurrentFinancialYear as CurrentFinancialYear
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetDashboardLastUpdateDate
-- --------------------------------------------------
--EXEC [spx_FPGetDashboardLastUpdateDate]  'FP000000000000000040'
CREATE PROCEDURE [dbo].[spx_FPGetDashboardLastUpdateDate] 
(
--Declare	
	@FpCode varchar(20)
)
AS
BEGIN
	Declare @LastUpdateDate Datetime
--	SET @FpCode = 'FP000000000000000040'
	SELECT @LastUpdateDate = Max(LastDate) 
	FROM (
	select ISNULL(dModifiedOn,dCreatedOn) LastDate  from Tbl_FPClientInfo With(Nolock) Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPClientIncomeDetails With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPHealthInsurance With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPLifeInsurance With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPEquityStocks With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPMutualFunds With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPFixedIncome With(Nolock)Where sFpCode = @FpCode
	Union
	select ISNULL(dModifiedOn,dCreatedOn) from Tbl_FPOtherInvestments With(Nolock)Where sFpCode = @FpCode
	)List
	
	SELECT @LastUpdateDate LastUpdateDate, DATEDIFF(d,@LastUpdateDate ,getdate()) NoOfDaysLastUpdated, 
	CASE WHEN DATEDIFF(d,@LastUpdateDate ,getdate()) = 0 THEN 'Last updated today'
	WHEN DATEDIFF(d,@LastUpdateDate ,getdate()) = 1 THEN 'Last updated yesterday'
	ELSE 'Last updated on ' + Convert(Varchar(11), @LastUpdateDate, 106) + '' END MSG
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetEmergencyAgeAssumptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetEmergencyAgeAssumptions]
AS
BEGIN
	SELECT *
	FROM	Tbl_FPEmergencyAgeAssumptions	 With(nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetEmiSavingsRatioTemplate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetEmiSavingsRatioTemplate]
AS
BEGIN
	SELECT *
	FROM	Tbl_FPMiscellaneousSettings With(nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetEquityStocks
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetEquityStocks]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nCurrentMarketValue, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPEquityStocks WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetFixedIncome
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetFixedIncome]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nSavingsAccountBalance, nBankFixedDeposit, nCorporateFixedDeposit,NBonds,nNonConvertibleDebentures, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPFixedIncome WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetHealthInsurance
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[spx_FPGetHealthInsurance]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nHealthcover, nHIPremium, sIsSelf, sIsSpouse, sIsChildren, sIsParents, dCreatedOn, dModifiedOn, sIsModified,nCorporateHealthCover
	FROM Tbl_FPHealthInsurance With(Nolock) WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetHealthInsuranceTemplate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetHealthInsuranceTemplate]  
AS
BEGIN
	SELECT *
	FROM	Tbl_FPHealthInsuranceTemplate With(nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetHomeLoan
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetHomeLoan]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nOutstandingAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPHomeLoan WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetInvestmentUnder80C
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetInvestmentUnder80C]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nInvestedAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPInvestmentUnder80C WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetInvestmentUnder80CCD
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetInvestmentUnder80CCD]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nInvestedAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPInvestmentUnder80CCD WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetLIAgeAssumptions
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetLIAgeAssumptions]
AS
BEGIN
	SELECT *
	FROM	Tbl_FPLIAgeAssumptions	 With(nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetLifeInsurance
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPGetLifeInsurance]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nLifecover, nLIPremium, dCreatedOn, dModifiedOn, sIsModified,nCoverForMonthlyIncome
	FROM Tbl_FPLifeInsurance With(Nolock) WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetLIMiscellaneousSettings
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetLIMiscellaneousSettings]
AS
BEGIN
	SELECT *
	FROM	Tbl_FPLIMiscellaneousSettings With(nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMaxScoreTemplate
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMaxScoreTemplate]
(
	@BuildWealthFlag varchar(1)
)
AS
BEGIN
	SELECT *
	FROM	Tbl_FPBasicScoreMaster With(nolock)
	Where	 sIsBuildWealthFlag = ISNULL(@BuildWealthFlag,'N')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMessageList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMessageList]
AS
BEGIN
	SELECT * FROM Tbl_FPMessageRepository	 With(Nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMessageSummaryDashboardList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMessageSummaryDashboardList]
AS
BEGIN
	SELECT m.sDashboardCardGroup,m.sDashboardCardName,m.sMessageDescription,m.sDashboardCode 
	FROM	[Tbl_FPDashboardCardMaster] m With(Nolock)
	Order by nOrderOfMessage
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMessageSummaryList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMessageSummaryList]
AS
BEGIN
	SELECT m.sSummaryGroup,m.sSummaryGroupName,r.sMessageNAme,r.sMessageCode,r.sMessageDescription 
	FROM	Tbl_FPSummaryMessageRepository  r With(Nolock)
	Left join Tbl_FPSummaryRepository m With(Nolock) on m.sMessageNAme =  r.sMessageNAme And m.sMessageCode = r.sMessageCode
	Order by nOrderOfMessage
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMetroCityList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMetroCityList]
AS
BEGIN
	SELECT nCityCode as nCityId, dbo.ufn_FPGetTitleCase(sCityName) as sCityName,sIsMetroCity
	FROM	Tbl_FPCityMaster With(nolock)
	Where	sIsMetroCity ='Y' 
	
	--UPDATE Tbl_FPCityMaster SET sIsMetroCity ='Y'  WHERE sCityName = 'DELHI'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMoreInformationList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMoreInformationList]
AS
BEGIN
	SELECT r.sSummaryNoteGroup,r.sSummaryNoteGroupName,r.sNoteGroup,r.sNoteCode,m.sNoteDescription 
	FROM	[Tbl_FPMoreInformationRepository]  r With(Nolock)
	Left join Tbl_FPMoreInformationMaster m With(Nolock) on m.sNoteGroup =  r.sNoteGroup And m.sNoteCode = r.sNoteCode
	Order by nOrderOfMessage
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetMutualFunds
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetMutualFunds]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nEquityMfCurrentMarketValue, nEquityMfSipPerMonth, nEquityMfLumsum, nDebtMfCurrentMarketValue, nDebtMfSipPerMonth,
			nDebtMfLumsum,
			nLiquidMfCurrentMarketValue,
			nLiquidMfSipPerMonth,
			nLiquidMfLumsum,
			dCreatedOn,
			dModifiedOn,
			sIsModified
	FROM Tbl_FPMutualFunds WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Spx_FPGetNewFpCode
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[Spx_FPGetNewFpCode]
AS
BEGIN
--CREATE SEQUENCE SQ_FP_CODE
--    START WITH 1  
--    INCREMENT BY 1;  
    
    Declare @FpNo  bigint
    SET @FpNo = NEXT VALUE FOR SQ_FP_CODE
    --SELECT right('FP000000000000000000',LEN(@FpNo))  as FpNo,@FpNo
    SELECT 'FP' + RIGHT('000000000000000000' + RTRIM(@FpNo), 18) FpNo;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetNonMetroCityList
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetNonMetroCityList]
(
	@CityNameSearch Varchar(250) = NULL
)
AS
BEGIN
	SELECT nCityCode as nCityId, dbo.ufn_FPGetTitleCase(sCityName) as sCityName,sIsMetroCity
	FROM	Tbl_FPCityMaster With(nolock)
	Where	 sIsActive = 'Y'
	AND		sIsMetroCity = 'N'
	AND		sCityName Like ISNULL(@CityNameSearch,'') + '%'
	--UPDATE Tbl_FPCityMaster SET sIsMetroCity ='Y'  WHERE sCityName = 'DELHI'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetOtherInvestments
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetOtherInvestments]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nRealEstatePersonalPropertyValue,
			nRealEstateInvestmentPropertyValue,
			nRetirementSavingsPPFBalance,
			nRetirementSavingsEPFBalance,
			nRetirementSavingsNPSBalance,
			nOtherInvestments,
			nCurrentMarketValueGoldForInvestment,
			nCurrentMarketValueAssetsForInvestment,
			nCurrentMarketValueAssetsForPersonalUse,
			dCreatedOn,
			dModifiedOn,
			sIsModified
	FROM Tbl_FPOtherInvestments WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetOtherLoan
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetOtherLoan]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nOutstandingAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPOtherLoan WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetPersonalLoan
-- --------------------------------------------------
Create PROCEDURE [dbo].[spx_FPGetPersonalLoan]
(
	@FpCode varchar(20)
)
AS
BEGIN
	SELECT   sFpCode, nOutstandingAmount, dCreatedOn, dModifiedOn, sIsModified
	FROM Tbl_FPPersonalLoan WHERE sFpCode = @FpCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetTPMiscellaneousSettings
-- --------------------------------------------------
CREATE PROCEDURE spx_FPGetTPMiscellaneousSettings
AS
BEGIN
	SELECT   nRequiredIn80C,	nRequiredIn80CCD, nTaxRebateLevel
	FROM [Tbl_FPTaxPlanningSettings] With(Nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGetTPTaxSlabs
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGetTPTaxSlabs]
AS
BEGIN
	SELECT   nTaxSlabFrom,nTaxSlabTo,nTaxRate,nMinMonthlySalaryFrom,nMinMonthlySalaryTo
	FROM [Tbl_FPTaxPlanningSlabs] With(Nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPGoalPreConfigurationSettings
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPGoalPreConfigurationSettings]
AS
BEGIN
	SELECT   *
	FROM Tbl_FPGoalPreConfigurationSettings With(Nolock)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveCarLoan
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[spx_FPSaveCarLoan]
(
	@FpCode varchar(20),
	@OutstandingAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPCarLoan With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPCarLoan(	sFpCode, nOutstandingAmount, dCreatedOn)
		VALUES (@FpCode, @OutstandingAmount , GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPCarLoan SET
				nOutstandingAmount= @OutstandingAmount 
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveClientIncome
-- --------------------------------------------------

CREATE PROCEDURE [spx_FPSaveClientIncome]
(
	@FpCode varchar(20),
	@MonthlyIncomeSelf numeric(18,2) = NULL,
	@MonthlyIncomeSpouse numeric(18,2) = NULL,
	@MonthlyExpense numeric(18,2) = NULL,
	@MonthlyEMI numeric(18,2) = NULL

)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPClientIncomeDetails With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPClientIncomeDetails(	sFpCode, nMonthlyIncomeSelf, nMonthlyIncomeSpouse, nMonthlyExpense, nMonthlyEMI, dCreatedOn)
		VALUES (@FpCode, @MonthlyIncomeSelf, @MonthlyIncomeSpouse, @MonthlyExpense, @MonthlyEMI, GETDATE())
	END
	ELSE
	BEGIN
		
		/*******************************************************************/
		/***Added by Mohan dtd 29052019**/
		Declare @CoverForMonthlyIncome numeric(18,2), @MonthlyIncomeSelfOld  numeric(18,2)
		SELECT @MonthlyIncomeSelfOld  = nMonthlyIncomeSelf FROM Tbl_FPClientIncomeDetails With(Nolock)  WHERE sFpCode = @FpCode
		SELECT @CoverForMonthlyIncome = nCoverForMonthlyIncome FROM Tbl_FPLifeInsurance With(Nolock)  WHERE sFpCode = @FpCode

		IF (ISNULL(@CoverForMonthlyIncome,0) = ISNULL(@MonthlyIncomeSelfOld,0))
		BEGIN
			UPDATE  Tbl_FPLifeInsurance  SET nCoverForMonthlyIncome=@MonthlyIncomeSelf WHERE sFpCode = @FpCode
		END
		ELSE
		BEGIN
			IF (ISNULL(@CoverForMonthlyIncome,0) > ISNULL(@MonthlyIncomeSelf,0))
			BEGIN			
				UPDATE  Tbl_FPLifeInsurance  SET nCoverForMonthlyIncome=@MonthlyIncomeSelf WHERE sFpCode = @FpCode
			END			
		END
		/*******************************************************************/
		
		UPDATE Tbl_FPClientIncomeDetails SET
				nMonthlyIncomeSelf = @MonthlyIncomeSelf
				, nMonthlyIncomeSpouse = @MonthlyIncomeSpouse
				, nMonthlyExpense = @MonthlyExpense
				, nMonthlyEMI = @MonthlyEMI
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'cashflow' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'lifeinsurance' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'healthinsurance' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'taxplanning' 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveClientInfo
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveClientInfo]
(
	@FpCode varchar(20),
	@TempId  varchar(50) = NULL,
	@MfKycId bigint = NULL,
	@ClientCode varchar(20) = NULL,
	@ProductId int = NULL,
	@ProductVersion varchar(100) = NULL,
	@DateOfBirth varchar(11) = NULL,
	@LifeStage int = NULL,
	@YoungChildren int = NULL,
	@GrownUpChildren int = NULL,
	@CityId int = NULL,
	@Remarks varchar(250)= NULL,
	@IpAddress varchar(20)= NULL,
	@BrowserInfo varchar(250)= NULL,
	@OsInfo varchar(250)= NULL,
	@Reserved1 bigint = NULL,
	@Reserved2 bigint = NULL,
	@Reserved3 varchar(250)= NULL,
	@Reserved4 varchar(250)= NULL,
	@Reserved5 varchar(250)= NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPClientInfo With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPClientInfo(	sFpCode, sTempId, nMfKycId, sClientCode, nProductId, sProductVersion, dDateOfBirth,nLifeStage,
										nYoungChildren,nGrownUpChildren,nCityId,sRemarks,sIpAddress,sBrowserInfo,sOsInfo
										,nReserved1,nReserved2,sReserved3,sReserved4,sReserved5, sDesignTemplate,dCreatedOn)

		VALUES (@FpCode, @TempId, @MfKycId, @ClientCode, @ProductId, @ProductVersion, @DateOfBirth,@LifeStage,
										@YoungChildren,@GrownUpChildren,@CityId,@Remarks,@IpAddress,@BrowserInfo,@OsInfo
										,@Reserved1,@Reserved2,@Reserved3,@Reserved4,@Reserved5, 'DT01',GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPClientInfo SET
				sClientCode = @ClientCode
				, nProductId = @ProductId
				, sProductVersion = @ProductVersion
				, dDateOfBirth = @DateOfBirth
				, nLifeStage = @LifeStage
				, nYoungChildren =@YoungChildren
				, nGrownUpChildren = @GrownUpChildren
				, nCityId = @CityId
				, sRemarks = @Remarks
				, sIpAddress = @IpAddress
				, sBrowserInfo = @BrowserInfo
				, sOsInfo = @OsInfo
				, nReserved1 = @Reserved1
				, nReserved2 = @Reserved2
				, sReserved3 = @Reserved3
				, sReserved4 = @Reserved4
				, sReserved5 = @Reserved5
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'goal' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'cashflow' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'lifeinsurance' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'healthinsurance' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'taxplanning' 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveEquityStocks
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[spx_FPSaveEquityStocks]
(
	@FpCode varchar(20),
	@CurrentMarketValue numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPEquityStocks With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPEquityStocks(	sFpCode, nCurrentMarketValue, dCreatedOn)
		VALUES (@FpCode, @CurrentMarketValue, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPEquityStocks SET
				nCurrentMarketValue= @CurrentMarketValue
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'assetallocation' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'goal' 
--	exec [spx_FPAddAssessmentInsight] @FpCode, 'portfolioquality'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveErrorLog
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_FPSaveErrorLog]
(
	@FpCode varchar(20),
	@TempId  varchar(50) = NULL,
	@ClientCode varchar(20) = NULL,
	@ProductId int = NULL,
	@ProductVersion varchar(100) = NULL,
	@IpAddress varchar(20)= NULL,
	@MethodName varchar(250),
	@ErrorDescrition varchar(MAX)
)
As
Begin
	INSERT INTO Tbl_FPErrorLog 	(sFpCode, sClientCode, sTempId, ProductId, ProductVersion,IpAddress, sMethodName, sErrorDescrition, dLogDate)
	Values (@FpCode, @ClientCode, @TempId, @ProductId, @ProductVersion,@IpAddress, @MethodName, @ErrorDescrition, GETDATE())
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveFixedIncome
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveFixedIncome]
(
	@FpCode varchar(20),
	@SavingsAccountBalance numeric(18,2) = NULL,
	@BankFixedDeposit numeric(18,2) = NULL,
	@CorporateFixedDeposit numeric(18,2) = NULL,
	@Bonds numeric(18,2) = NULL,
	@NonConvertibleDebentures numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPFixedIncome With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPFixedIncome(	sFpCode, nSavingsAccountBalance, nBankFixedDeposit, nCorporateFixedDeposit,nBonds, nNonConvertibleDebentures, dCreatedOn)
		VALUES (@FpCode, @SavingsAccountBalance, @BankFixedDeposit, @CorporateFixedDeposit ,@Bonds, @NonConvertibleDebentures, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPFixedIncome SET
				nSavingsAccountBalance =@SavingsAccountBalance
				, nBankFixedDeposit = @BankFixedDeposit
				, nCorporateFixedDeposit = @CorporateFixedDeposit
				,nBonds = @Bonds
				,nNonConvertibleDebentures =@NonConvertibleDebentures
				,dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'assetallocation' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'goal' 
	--exec [spx_FPAddAssessmentInsight] @FpCode, 'portfolioquality'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveHealthInsurance
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveHealthInsurance]
(
	@FpCode varchar(20),
	@Healthcover numeric(18,2) = NULL,
	@HIPremium numeric(18,2) = NULL,
	@IsSelf varchar(1) = NULL,
	@IsSpouse varchar(1) = NULL,
	@IsChildren varchar(1) = NULL,
	@IsParents  varchar(1) = NULL,
	@CorporateHealthCover numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPHealthInsurance With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPHealthInsurance(sFpCode, nHealthcover, nHIPremium, sIsSelf, sIsSpouse, sIsChildren, sIsParents, dCreatedOn, nCorporateHealthCover)
		VALUES (@FpCode, @Healthcover, @HIPremium, @IsSelf, @IsSpouse, @IsChildren, @IsParents,GETDATE(),@CorporateHealthCover)
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPHealthInsurance SET
				nHealthcover = @Healthcover
				,nHIPremium = @HIPremium
				,sIsSelf = @IsSelf
				,sIsSpouse = @IsSpouse
				,sIsChildren = @IsChildren
				,sIsParents = @IsParents
				, dModifiedOn = GETDATE()
				,nCorporateHealthCover =@CorporateHealthCover
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'healthinsurance' 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveHomeLoan
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveHomeLoan]
(
	@FpCode varchar(20),
	@OutstandingAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPHomeLoan With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPHomeLoan(	sFpCode, nOutstandingAmount, dCreatedOn)
		VALUES (@FpCode, @OutstandingAmount , GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPHomeLoan SET
				nOutstandingAmount= @OutstandingAmount 
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveInvestmentUnder80C
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveInvestmentUnder80C]
(
	@FpCode varchar(20),
	@InvestedAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPInvestmentUnder80C With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPInvestmentUnder80C(	sFpCode, nInvestedAmount, dCreatedOn)
		VALUES (@FpCode, @InvestedAmount, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPInvestmentUnder80C SET
				nInvestedAmount= @InvestedAmount
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'taxplanning'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveInvestmentUnder80CCD
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[spx_FPSaveInvestmentUnder80CCD]
(
	@FpCode varchar(20),
	@InvestedAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPInvestmentUnder80CCD With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPInvestmentUnder80CCD(	sFpCode, nInvestedAmount, dCreatedOn)
		VALUES (@FpCode, @InvestedAmount, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPInvestmentUnder80CCD SET
				nInvestedAmount= @InvestedAmount
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'taxplanning'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveLifeInsurance
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveLifeInsurance]
(
	@FpCode varchar(20),
	@Lifecover numeric(18,2) = NULL,
	@LIPremium numeric(18,2) = NULL,
	@CoverForMonthlyIncome numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPLifeInsurance With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPLifeInsurance(sFpCode, nLifecover, nLIPremium, dCreatedOn, nCoverForMonthlyIncome)
		VALUES (@FpCode, @Lifecover, @LIPremium,GETDATE(), @CoverForMonthlyIncome)
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPLifeInsurance SET
				nLifecover = @Lifecover
				, nLIPremium = @LIPremium
				,nCoverForMonthlyIncome= @CoverForMonthlyIncome
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'lifeinsurance' 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveMutualFunds
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveMutualFunds]
(
	@FpCode varchar(20),
	@EquityMfCurrentMarketValue numeric(18,2) = NULL,
	@EquityMfSipPerMonth numeric(18,2) = NULL,
	@EquityMfLumsum numeric(18,2) = NULL,
	@DebtMfCurrentMarketValue numeric(18,2) = NULL,
	@DebtMfSipPerMonth numeric(18,2) = NULL,
	@DebtMfLumsum numeric(18,2) = NULL,
	@LiquidMfCurrentMarketValue numeric(18,2) = NULL,
	@LiquidMfSipPerMonth numeric(18,2) = NULL,
	@LiquidMfLumsum numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPMutualFunds With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPMutualFunds(	sFpCode, nEquityMfCurrentMarketValue, nEquityMfSipPerMonth, nEquityMfLumsum, nDebtMfCurrentMarketValue,
										nDebtMfSipPerMonth, nDebtMfLumsum, nLiquidMfCurrentMarketValue, nLiquidMfSipPerMonth, nLiquidMfLumsum
										, dCreatedOn)
		VALUES (@FpCode, @EquityMfCurrentMarketValue, @EquityMfSipPerMonth, @EquityMfLumsum, @DebtMfCurrentMarketValue,
										@DebtMfSipPerMonth, @DebtMfLumsum, @LiquidMfCurrentMarketValue, @LiquidMfSipPerMonth, @LiquidMfLumsum
										, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPMutualFunds SET
				nEquityMfCurrentMarketValue =@EquityMfCurrentMarketValue
				,nEquityMfSipPerMonth = @EquityMfSipPerMonth
				,nEquityMfLumsum = @EquityMfLumsum
				,nDebtMfCurrentMarketValue = @DebtMfCurrentMarketValue
				,nDebtMfSipPerMonth = @DebtMfSipPerMonth
				,nDebtMfLumsum = @DebtMfLumsum
				,nLiquidMfCurrentMarketValue = @LiquidMfCurrentMarketValue
				,nLiquidMfSipPerMonth = @LiquidMfSipPerMonth
				,nLiquidMfLumsum = @LiquidMfLumsum
				,dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'assetallocation' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'goal' 
--	exec [spx_FPAddAssessmentInsight] @FpCode, 'portfolioquality'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveOtherInvestments
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSaveOtherInvestments]
(
	@FpCode varchar(20),
	@RealEstatePersonalPropertyValue numeric(18,2) = NULL,
	@RealEstateInvestmentPropertyValue numeric(18,2) = NULL,
	@RetirementSavingsPPFBalance numeric(18,2) = NULL, 
	@RetirementSavingsEPFBalance numeric(18,2) = NULL,
	@RetirementSavingsNPSBalance numeric(18,2) = NULL,
	@OtherInvestments numeric(18,2) = NULL,
	@CurrentMarketValueGoldForInvestment numeric(18,2) = NULL,
	@CurrentMarketValueAssetsForInvestment numeric(18,2) = NULL,
	@CurrentMarketValueAssetsForPersonalUse numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPOtherInvestments With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPOtherInvestments(	sFpCode, nRealEstatePersonalPropertyValue, nRealEstateInvestmentPropertyValue, nRetirementSavingsPPFBalance, nRetirementSavingsEPFBalance
										, nRetirementSavingsNPSBalance, nOtherInvestments,nCurrentMarketValueGoldForInvestment, nCurrentMarketValueAssetsForInvestment, nCurrentMarketValueAssetsForPersonalUse, dCreatedOn)
		VALUES (@FpCode, @RealEstatePersonalPropertyValue, @RealEstateInvestmentPropertyValue, @RetirementSavingsPPFBalance, @RetirementSavingsEPFBalance
										, @RetirementSavingsNPSBalance, @OtherInvestments,@CurrentMarketValueGoldForInvestment,@CurrentMarketValueAssetsForInvestment,@CurrentMarketValueAssetsForPersonalUse
										, GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPOtherInvestments SET
				nRealEstatePersonalPropertyValue = @RealEstatePersonalPropertyValue
				,nRealEstateInvestmentPropertyValue = @RealEstateInvestmentPropertyValue
				,nRetirementSavingsPPFBalance = @RetirementSavingsPPFBalance
				,nRetirementSavingsEPFBalance = @RetirementSavingsEPFBalance
				,nRetirementSavingsNPSBalance = @RetirementSavingsNPSBalance
				,nOtherInvestments = @OtherInvestments
				,nCurrentMarketValueGoldForInvestment =@CurrentMarketValueGoldForInvestment
				, nCurrentMarketValueAssetsForInvestment =@CurrentMarketValueAssetsForInvestment
				, nCurrentMarketValueAssetsForPersonalUse =@CurrentMarketValueAssetsForPersonalUse
				,dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'emergencyfund' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'assetallocation' 
	exec [spx_FPAddAssessmentInsight] @FpCode, 'goal' 
--	exec [spx_FPAddAssessmentInsight] @FpCode, 'portfolioquality'  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSaveOtherLoan
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[spx_FPSaveOtherLoan]
(
	@FpCode varchar(20),
	@OutstandingAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPOtherLoan With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPOtherLoan(	sFpCode, nOutstandingAmount, dCreatedOn)
		VALUES (@FpCode, @OutstandingAmount , GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPOtherLoan SET
				nOutstandingAmount= @OutstandingAmount 
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
	
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPSavePersonalLoan
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[spx_FPSavePersonalLoan]
(
	@FpCode varchar(20),
	@OutstandingAmount numeric(18,2) = NULL
)
AS
BEGIN
	Declare @Cnt int 
	SET @Cnt = (SELECT  COUNT(1) FROM Tbl_FPPersonalLoan With(Nolock) WHERE sFpCode =@FpCode)
	
	If(@Cnt = 0)
	BEGIN
		INSERT INTO Tbl_FPPersonalLoan(	sFpCode, nOutstandingAmount, dCreatedOn)
		VALUES (@FpCode, @OutstandingAmount , GETDATE())
	END
	ELSE
	BEGIN
		UPDATE Tbl_FPPersonalLoan SET
				nOutstandingAmount= @OutstandingAmount 
				, dModifiedOn = GETDATE()
		WHERE sFpCode = @FpCode
	END
		
	-- Update Insights
	exec [spx_FPAddAssessmentInsight] @FpCode, 'networth'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPUpdateAssessmentInsight
-- --------------------------------------------------
CREATE   PROCEDURE [spx_FPUpdateAssessmentInsight]
(
	@FpCode varchar(20),
	@AssessmentName varchar(250)	
)
AS
BEGIN
	UPDATE Tbl_FPAssessmentInsight SET sIsRead='Y' WHERE sfpCode = @FpCode ANd sAssessmentName= @AssessmentName
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_FPUpdateClientCode
-- --------------------------------------------------
CREATE Procedure [dbo].[spx_FPUpdateClientCode]
(@TempId varchar(50), @ClientCode varchar(20))
As
Begin
	if(ltrim(rtrim(@ClientCode)) <> '')
	Begin
		Update Tbl_FPClientInfo Set sClientCode = ltrim(rtrim(@ClientCode)) Where ltrim(rtrim(ISNULL(sTempId,''))) = ltrim(rtrim(@TempId))
	End
End

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPAssessmentInsight
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPAssessmentInsight]
(
    [sFpCode] VARCHAR(20) NULL,
    [sAssessmentName] VARCHAR(250) NULL,
    [sIsRead] VARCHAR(1) NULL,
    [dChangedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPBasicScoreMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPBasicScoreMaster]
(
    [sIsBuildWealthFlag] VARCHAR(1) NULL,
    [nLife] INT NULL,
    [nAgeFrom] INT NULL,
    [nAgeTo] INT NULL,
    [sSmallKids] VARCHAR(1) NULL,
    [sGrownupKids] VARCHAR(1) NULL,
    [nCashFlowTotal] INT NULL,
    [nEMIToIncomeRatio] INT NULL,
    [nSavingsToIncomeRatio] INT NULL,
    [nInsuranceTotal] INT NULL,
    [nLifeInsurance] INT NULL,
    [nHealthInsurance] INT NULL,
    [nInvestmentsAndTaxSavingsTotal] INT NULL,
    [nTaxPlanning] INT NULL,
    [nRetirement] INT NULL,
    [nChildsEducation] INT NULL,
    [nBuildWealth] INT NULL,
    [nHomeDp] INT NULL,
    [nEmergencyFund] INT NULL,
    [nAssetManagementTotal] INT NULL,
    [nAssetAllocation] INT NULL,
    [nStocksSchemes] INT NULL,
    [nLoansAtHighROI] INT NULL,
    [sRemarks] VARCHAR(250) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPCarLoan
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPCarLoan]
(
    [sFpCode] VARCHAR(20) NULL,
    [nOutstandingAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPCityMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPCityMaster]
(
    [nCityCode] SMALLINT NULL,
    [sCityName] NVARCHAR(510) NULL,
    [sIsMetroCity] VARCHAR(1) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPClientIncomeDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPClientIncomeDetails]
(
    [sFpCode] VARCHAR(20) NULL,
    [nMonthlyIncomeSelf] NUMERIC(18, 2) NULL,
    [nMonthlyIncomeSpouse] NUMERIC(18, 2) NULL,
    [nMonthlyExpense] NUMERIC(18, 2) NULL,
    [nMonthlyEMI] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPClientInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPClientInfo]
(
    [sFpCode] VARCHAR(20) NULL,
    [sTempId] VARCHAR(50) NULL,
    [nMfKycId] BIGINT NULL,
    [sClientCode] VARCHAR(20) NULL,
    [nProductId] BIGINT NULL,
    [sProductVersion] VARCHAR(100) NULL,
    [dDateOfBirth] DATETIME NULL,
    [nLifeStage] INT NULL,
    [nYoungChildren] INT NULL,
    [nGrownUpChildren] INT NULL,
    [nCityId] INT NULL,
    [sDesignTemplate] VARCHAR(20) NULL,
    [sRemarks] VARCHAR(250) NULL,
    [sIpAddress] VARCHAR(20) NULL,
    [sBrowserInfo] VARCHAR(250) NULL,
    [sOsInfo] VARCHAR(250) NULL,
    [nReserved1] BIGINT NULL,
    [nReserved2] BIGINT NULL,
    [sReserved3] VARCHAR(250) NULL,
    [sReserved4] VARCHAR(250) NULL,
    [sReserved5] VARCHAR(250) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPDashboardCardMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPDashboardCardMaster]
(
    [sDashboardCardGroup] VARCHAR(100) NULL,
    [sDashboardCardName] VARCHAR(200) NULL,
    [sMessageDescription] VARCHAR(1000) NULL,
    [nOrderOfMessage] INT NULL,
    [sDashboardCode] VARCHAR(20) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPEmergencyAgeAssumptions
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPEmergencyAgeAssumptions]
(
    [nAgeFromInMonths] INT NULL,
    [nAgeToInMonths] INT NULL,
    [nNoOfMonthsEmergencyFund] NUMERIC(10, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPEquityStocks
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPEquityStocks]
(
    [sFpCode] VARCHAR(20) NULL,
    [nCurrentMarketValue] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPErrorLog
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPErrorLog]
(
    [nErrorId] BIGINT IDENTITY(1,1) NOT NULL,
    [sFpCode] VARCHAR(20) NULL,
    [sClientCode] VARCHAR(20) NULL,
    [sTempId] VARCHAR(20) NULL,
    [ProductId] INT NULL,
    [ProductVersion] VARCHAR(100) NULL,
    [IpAddress] VARCHAR(20) NULL,
    [sMethodName] VARCHAR(250) NULL,
    [sErrorDescrition] VARCHAR(MAX) NULL,
    [dLogDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPFixedIncome
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPFixedIncome]
(
    [sFpCode] VARCHAR(20) NULL,
    [nSavingsAccountBalance] NUMERIC(18, 2) NULL,
    [nBankFixedDeposit] NUMERIC(18, 2) NULL,
    [nCorporateFixedDeposit] NUMERIC(18, 2) NULL,
    [nBonds] NUMERIC(18, 2) NULL,
    [nNonConvertibleDebentures] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPGoalPreConfigurationSettings
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPGoalPreConfigurationSettings]
(
    [nLife] INT NULL,
    [nAgeFrom] INT NULL,
    [nAgeTo] INT NULL,
    [sSmallKids] VARCHAR(1) NULL,
    [sGrownupKids] VARCHAR(1) NULL,
    [sIsHomeGoal] VARCHAR(1) NULL,
    [sIsBuildWealthGoal] VARCHAR(1) NULL,
    [sIsRetirementGoal] VARCHAR(1) NULL,
    [sIsChildEducationGoal] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPHealthInsurance
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPHealthInsurance]
(
    [sFpCode] VARCHAR(20) NULL,
    [nHealthcover] NUMERIC(18, 2) NULL,
    [nHIPremium] NUMERIC(18, 2) NULL,
    [sIsSelf] VARCHAR(1) NULL,
    [sIsSpouse] VARCHAR(1) NULL,
    [sIsChildren] VARCHAR(1) NULL,
    [sIsParents] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL,
    [nCorporateHealthCover] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPHealthInsuranceTemplate
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPHealthInsuranceTemplate]
(
    [nLife] INT NULL,
    [nAgeFrom] INT NULL,
    [nAgeTo] INT NULL,
    [sSmallKids] VARCHAR(1) NULL,
    [sGrownupKids] VARCHAR(1) NULL,
    [sIsLiveInMetro] VARCHAR(1) NULL,
    [nHealthInsuranceRequired] NUMERIC(18, 2) NULL,
    [sRemarks] VARCHAR(250) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPHomeLoan
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPHomeLoan]
(
    [sFpCode] VARCHAR(20) NULL,
    [nOutstandingAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPInvestmentUnder80C
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPInvestmentUnder80C]
(
    [sFpCode] VARCHAR(20) NULL,
    [nInvestedAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPInvestmentUnder80CCD
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPInvestmentUnder80CCD]
(
    [sFpCode] VARCHAR(20) NULL,
    [nInvestedAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPLIAgeAssumptions
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPLIAgeAssumptions]
(
    [nAgeFrom] INT NULL,
    [nAgeto] INT NULL,
    [nMultipleOfIncome] NUMERIC(10, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPLifeInsurance
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPLifeInsurance]
(
    [sFpCode] VARCHAR(20) NULL,
    [nLifecover] NUMERIC(18, 2) NULL,
    [nLIPremium] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL,
    [nCoverForMonthlyIncome] NUMERIC(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPLIMiscellaneousSettings
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPLIMiscellaneousSettings]
(
    [nRetirementAge] NUMERIC(18, 2) NULL,
    [nExpencesGrowthRate] NUMERIC(18, 2) NULL,
    [nIncomeGrowthRate] NUMERIC(18, 2) NULL,
    [nSwithToDebt] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMessageRepository
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMessageRepository]
(
    [sMessageName] VARCHAR(100) NULL,
    [sMessageDescription] VARCHAR(1000) NULL,
    [sErrorCode] VARCHAR(20) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMiscellaneousSettings
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMiscellaneousSettings]
(
    [nErMin] INT NULL,
    [nErMax] INT NULL,
    [nSrMinWithEmi] INT NULL,
    [nSrMaxWithEmi] INT NULL,
    [nSrMinWithoutEmi] INT NULL,
    [nSrMaxWithoutEmi] INT NULL,
    [nErMinScore] DECIMAL(10, 2) NULL,
    [nErMaxScore] DECIMAL(10, 2) NULL,
    [nSrMinScore] DECIMAL(10, 2) NULL,
    [nSrMaxScore] DECIMAL(10, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMoreInformationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMoreInformationMaster]
(
    [sNoteGroup] VARCHAR(100) NULL,
    [sNoteCode] VARCHAR(20) NULL,
    [sNoteDescription] VARCHAR(1000) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMoreInformationRepository
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMoreInformationRepository]
(
    [sSummaryNoteGroup] VARCHAR(100) NULL,
    [sSummaryNoteGroupName] VARCHAR(200) NULL,
    [sNoteGroup] VARCHAR(100) NULL,
    [sNoteCode] VARCHAR(20) NULL,
    [nOrderOfMessage] INT NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMoreInformationRepository_BKP
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMoreInformationRepository_BKP]
(
    [sNoteGroup] VARCHAR(100) NULL,
    [sNoteDescription] VARCHAR(1000) NULL,
    [nOrderOfMessage] INT NULL,
    [sNoteCode] VARCHAR(20) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPMutualFunds
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPMutualFunds]
(
    [sFpCode] VARCHAR(20) NULL,
    [nEquityMfCurrentMarketValue] NUMERIC(18, 2) NULL,
    [nEquityMfSipPerMonth] NUMERIC(18, 2) NULL,
    [nEquityMfLumsum] NUMERIC(18, 2) NULL,
    [nDebtMfCurrentMarketValue] NUMERIC(18, 2) NULL,
    [nDebtMfSipPerMonth] NUMERIC(18, 2) NULL,
    [nDebtMfLumsum] NUMERIC(18, 2) NULL,
    [nLiquidMfCurrentMarketValue] NUMERIC(18, 2) NULL,
    [nLiquidMfSipPerMonth] NUMERIC(18, 2) NULL,
    [nLiquidMfLumsum] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPOtherInvestments
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPOtherInvestments]
(
    [sFpCode] VARCHAR(20) NULL,
    [nRealEstatePersonalPropertyValue] NUMERIC(18, 2) NULL,
    [nRealEstateInvestmentPropertyValue] NUMERIC(18, 2) NULL,
    [nRetirementSavingsPPFBalance] NUMERIC(18, 2) NULL,
    [nRetirementSavingsEPFBalance] NUMERIC(18, 2) NULL,
    [nRetirementSavingsNPSBalance] NUMERIC(18, 2) NULL,
    [nOtherInvestments] NUMERIC(18, 2) NULL,
    [nCurrentMarketValueGoldForInvestment] NUMERIC(18, 2) NULL,
    [nCurrentMarketValueAssetsForInvestment] NUMERIC(18, 2) NULL,
    [nCurrentMarketValueAssetsForPersonalUse] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPOtherLoan
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPOtherLoan]
(
    [sFpCode] VARCHAR(20) NULL,
    [nOutstandingAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPPersonalLoan
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPPersonalLoan]
(
    [sFpCode] VARCHAR(20) NULL,
    [nOutstandingAmount] NUMERIC(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [sIsModified] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPProductMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPProductMaster]
(
    [nProductId] BIGINT NULL,
    [sProductName] VARCHAR(250) NULL,
    [sIsActive] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPSummaryMessageRepository
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPSummaryMessageRepository]
(
    [sMessageName] VARCHAR(100) NULL,
    [sMessageDescription] VARCHAR(1000) NULL,
    [sMessageCode] VARCHAR(20) NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPSummaryRepository
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPSummaryRepository]
(
    [sSummaryGroup] VARCHAR(100) NULL,
    [sSummaryGroupName] VARCHAR(200) NULL,
    [sMessageName] VARCHAR(100) NULL,
    [sMessageCode] VARCHAR(20) NULL,
    [nOrderOfMessage] INT NULL,
    [sIsActive] VARCHAR(1) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPTaxPlanningSettings
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPTaxPlanningSettings]
(
    [nRequiredIn80C] DECIMAL(18, 2) NULL,
    [nRequiredIn80CCD] DECIMAL(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL,
    [nTaxRebateLevel] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPTaxPlanningSlabs
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPTaxPlanningSlabs]
(
    [nTaxSlabFrom] DECIMAL(18, 2) NULL,
    [nTaxSlabTo] DECIMAL(18, 2) NULL,
    [nTaxRate] DECIMAL(10, 5) NULL,
    [nMinMonthlySalaryFrom] DECIMAL(18, 2) NULL,
    [nMinMonthlySalaryTo] DECIMAL(18, 2) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_FPTaxSlab
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_FPTaxSlab]
(
    [nIncomeFrom] NUMERIC(18, 2) NULL,
    [nIncomeTo] NUMERIC(18, 2) NULL,
    [nTaxRate] NUMERIC(10, 4) NULL,
    [dCreatedOn] DATETIME NULL,
    [dModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_FPInvestments
-- --------------------------------------------------
CREATE VIEW [dbo].[Vw_FPInvestments]
As
SELECT	CI.sFpCode              
		,sTempId                                            
		,nMfKycId             
		,sClientCode
		,dDateOfBirth 
		,nLifeStage          
		
		,nMonthlyIncomeSelf
		,nMonthlyIncomeSpouse
		,nMonthlyExpense
		,nMonthlyEMI
		,nCurrentMarketValue
		,nEquityMfCurrentMarketValue
		,nEquityMfSipPerMonth
		,nEquityMfLumsum
		,nDebtMfCurrentMarketValue               
		,nDebtMfSipPerMonth                      
		,nDebtMfLumsum                           
		,nLiquidMfCurrentMarketValue             
		,nLiquidMfSipPerMonth                    
		,nLiquidMfLumsum                         
		,nSavingsAccountBalance
		,nBankFixedDeposit
		,nCorporateFixedDeposit  
		,nBonds
		,nNonConvertibleDebentures
		,nRealEstatePersonalPropertyValue        
		,nRealEstateInvestmentPropertyValue      
		,nRetirementSavingsPPFBalance            
		,nRetirementSavingsEPFBalance            
		,nRetirementSavingsNPSBalance            
		,nOtherInvestments          
		,nCurrentMarketValueGoldForInvestment
		,nCurrentMarketValueAssetsForInvestment
		,nCurrentMarketValueAssetsForPersonalUse
		,ELSS.nInvestedAmount as nELSSInvestedAmount
		,NPS.nInvestedAmount as nNPSInvestedAmount
FROM	Tbl_FPClientInfo CI With(Nolock) 
left join Tbl_FPClientIncomeDetails cinm With(Nolock) ON cinm.sFPCode = CI.sFpCode
left join tbl_FPEquityStocks ES With(Nolock) ON ES.sFPCode = CI.sFpCode
left join tbl_FPMutualFunds MF With(Nolock) ON MF.sFPCode = CI.sFpCode 
left join tbl_FPFixedIncome FI With(Nolock) ON FI.sFPCode = CI.sFpCode
left join tbl_FPOtherInvestments OI With(Nolock) ON OI.sFPCode = CI.sFpCode
left join Tbl_FPInvestmentUnder80C ELSS With(Nolock) ON ELSS.sFPCode = CI.sFpCode
left join Tbl_FPInvestmentUnder80CCD NPS With(Nolock) ON NPS.sFPCode = CI.sFpCode

GO

