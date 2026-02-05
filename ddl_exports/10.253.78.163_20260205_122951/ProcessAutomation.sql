-- DDL Export
-- Server: 10.253.78.163
-- Database: ProcessAutomation
-- Exported: 2026-02-05T12:30:02.082994

USE ProcessAutomation;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.ClientDRFAadharAuthenticationVerificationDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[ClientDRFAadharAuthenticationVerificationDetails] ADD CONSTRAINT [FK__ClientDRF__DRFId__1B88F612] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DRFInwordRegistrationReceivedByRTADetails
-- --------------------------------------------------
ALTER TABLE [dbo].[DRFInwordRegistrationReceivedByRTADetails] ADD CONSTRAINT [FK__DRFInword__DRFId__5FA91635] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails] ADD CONSTRAINT [FK__tbl_Clien__DRFId__5827EFFE] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_ClientDRFInwordDocuments
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientDRFInwordDocuments] ADD CONSTRAINT [FK__tbl_Clien__DRFId__78DED853] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_DRFInwordRegistrationProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFInwordRegistrationProcessDetails] ADD CONSTRAINT [FK__tbl_DRFIn__DRFId__577DE488] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_DRFInwordRegistrationProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFInwordRegistrationProcessDetails] ADD CONSTRAINT [FK__tbl_DRFIn__DRFId__587208C1] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_DRFInwordRegistrationProcessMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFInwordRegistrationProcessMaster] ADD CONSTRAINT [FK__tbl_DRFIn__PodId__54A177DD] FOREIGN KEY ([PodId]) REFERENCES [dbo].[tbl_DRFPodInwordRegistrationProcess] ([PodId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_DRFOutwordRegistrationSendToRTADetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFOutwordRegistrationSendToRTADetails] ADD CONSTRAINT [FK__tbl_DRFOu__DRFId__6E2C3FB6] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_DRFProcessClientMailStatusDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFProcessClientMailStatusDetails] ADD CONSTRAINT [FK__tbl_DRFPr__DRFId__4AADF94F] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryCSOVerificationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryCSOVerificationMaster] ADD CONSTRAINT [FK__tbl_Inter__Inter__1B1EE1BE] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterAddressDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterAddressDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__34DEB3C1] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterBankDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterBankDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__32024716] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterBrokerageDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterBrokerageDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__73D00A73] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterDepositAndFeesDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterDepositAndFeesDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__296D0115] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterGeneralDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterGeneralDetails] ADD CONSTRAINT [FK__tbl_Inter__Compa__1D913A15] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[tbl_SubBrokerOnBoardingCompanyMaster] ([CompanyId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterMultiPartnersDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterMultiPartnersDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__1AE9D794] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterOccuptionDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterOccuptionDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__37BB206C] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterPLVCProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterPLVCProcess] ADD CONSTRAINT [FK__tbl_Inter__Inter__1DFB4E69] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediaryMasterSegmentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterSegmentDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__09BF4B92] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediarySBTagGenerationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationMaster] ADD CONSTRAINT [FK__tbl_Inter__Inter__3D73F9C2] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediarySBTagGenerationRegistrationDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationRegistrationDetails] ADD CONSTRAINT [FK__tbl_Inter__SBMas__5086CE36] FOREIGN KEY ([SBMasterId]) REFERENCES [dbo].[tbl_IntermediarySBTagGenerationMaster] ([SBMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediarySBTagGenerationUploadedDocumentsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationUploadedDocumentsDetails] ADD CONSTRAINT [FK__tbl_Inter__Inter__4DAA618B] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_IntermediarySBVerificationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBVerificationMaster] ADD CONSTRAINT [FK__tbl_Inter__Inter__20D7BB14] FOREIGN KEY ([IntermediaryId]) REFERENCES [dbo].[tbl_IntermediaryMasterGeneralDetails] ([IntermediaryId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_RejectedDRFOutwordProcessAndResponseDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_RejectedDRFOutwordProcessAndResponseDetails] ADD CONSTRAINT [FK__tbl_Rejec__DRFId__20ECC9AD] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_RejectedDRFOutwordProcessAndResponseDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_RejectedDRFOutwordProcessAndResponseDetails] ADD CONSTRAINT [FK__tbl_Rejec__DRFId__21E0EDE6] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_RTARejectedDRFMemoScannedDocument
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_RTARejectedDRFMemoScannedDocument] ADD CONSTRAINT [FK__tbl_RTARe__DRFId__40657506] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBDepositBankingVarificationProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositBankingVarificationProcess] ADD CONSTRAINT [FK__tbl_SBDep__Depos__4C413C06] FOREIGN KEY ([DepositVarificationId]) REFERENCES [dbo].[tbl_SBDepositVarificationAndProcessBySBTeam] ([DepositVarificationId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBDepositBankingVarificationProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositBankingVarificationProcess] ADD CONSTRAINT [FK__tbl_SBDep__Suspe__4B4D17CD] FOREIGN KEY ([SuspenceAccDetailsId]) REFERENCES [dbo].[tbl_SBDepositSuspenceAccountDetails] ([SuspenceAccDetailsId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBDepositKnockOffProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositKnockOffProcessDetails] ADD CONSTRAINT [FK__tbl_SBDep__Depos__7A0806B6] FOREIGN KEY ([DepositRefId]) REFERENCES [dbo].[tbl_SBPayoutDepositProcessDetailsInLMS] ([DepositRefId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBDepositVarificationAndProcessBySBTeam
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositVarificationAndProcessBySBTeam] ADD CONSTRAINT [FK__tbl_SBDep__Depos__4870AB22] FOREIGN KEY ([DepositRefId]) REFERENCES [dbo].[tbl_SBPayoutDepositProcessDetailsInLMS] ([DepositRefId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBDepositVarificationAndProcessBySBTeam
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositVarificationAndProcessBySBTeam] ADD CONSTRAINT [FK__tbl_SBDep__Suspe__477C86E9] FOREIGN KEY ([SuspenceAccDetailsId]) REFERENCES [dbo].[tbl_SBDepositSuspenceAccountDetails] ([SuspenceAccDetailsId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBMultiLocationTagGenerationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBMultiLocationTagGenerationMaster] ADD CONSTRAINT [FK__tbl_SBMul__SBMas__7E4D98E6] FOREIGN KEY ([SBMasterId]) REFERENCES [dbo].[tbl_IntermediarySBTagGenerationMaster] ([SBMasterId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_SBPayoutDepositProcessDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBPayoutDepositProcessDocumentDetails] ADD CONSTRAINT [FK__tbl_SBPay__Depos__7ED7A8CB] FOREIGN KEY ([DepositRefId]) REFERENCES [dbo].[tbl_SBPayoutDepositProcessDetailsInLMS] ([DepositRefId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_UndeliveredClientDRFInwordDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_UndeliveredClientDRFInwordDetails] ADD CONSTRAINT [FK__tbl_Undel__DRFId__11757BF3] FOREIGN KEY ([DRFId]) REFERENCES [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFId])

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
-- FUNCTION dbo.SplitString
-- --------------------------------------------------
CREATE FUNCTION SplitString
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DRFInwordRegistrationProcessMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_DRFMaster_DRFNo] ON [dbo].[tbl_DRFInwordRegistrationProcessMaster] ([DRFNo])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_GstOtherVendorMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_vendor_supno_panno] ON [dbo].[tbl_GstOtherVendorMaster] ([VENDOR_TAG], [SUPNO], [PANNO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BankingFilesEmailMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BankingFilesEmailMaster] ADD CONSTRAINT [PK_BankingFilesEmailMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BSE_Master
-- --------------------------------------------------
ALTER TABLE [dbo].[BSE_Master] ADD CONSTRAINT [PK_BSE_Master] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ControlAccountMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[ControlAccountMaster] ADD CONSTRAINT [PK_ControlAccountMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DailyTriggerLog
-- --------------------------------------------------
ALTER TABLE [dbo].[DailyTriggerLog] ADD CONSTRAINT [PK_DailyTriggerLog] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DRFInwordRegistrationReceivedByRTADetails
-- --------------------------------------------------
ALTER TABLE [dbo].[DRFInwordRegistrationReceivedByRTADetails] ADD CONSTRAINT [PK__DRFInwor__A5ECE19915A1E217] PRIMARY KEY ([DRF_RTADetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ExchangeAccount
-- --------------------------------------------------
ALTER TABLE [dbo].[ExchangeAccount] ADD CONSTRAINT [PK_ExchangeAccount] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ExchangeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[ExchangeMaster] ADD CONSTRAINT [PK_ExchangeMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.GSTMasterData
-- --------------------------------------------------
ALTER TABLE [dbo].[GSTMasterData] ADD CONSTRAINT [PK_GSTMasterData] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IntersegmentJV_OfflineLedger
-- --------------------------------------------------
ALTER TABLE [dbo].[IntersegmentJV_OfflineLedger] ADD CONSTRAINT [PK__Interseg__EB811440C8BACBAC] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.IntersegmentJV_OfflineLedgerLogFile
-- --------------------------------------------------
ALTER TABLE [dbo].[IntersegmentJV_OfflineLedgerLogFile] ADD CONSTRAINT [PK__Interseg__EB811440E033E9D3] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.Logs
-- --------------------------------------------------
ALTER TABLE [dbo].[Logs] ADD CONSTRAINT [PK_Logs] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MailLog
-- --------------------------------------------------
ALTER TABLE [dbo].[MailLog] ADD CONSTRAINT [PK_MailLog] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MonthlyBillingData
-- --------------------------------------------------
ALTER TABLE [dbo].[MonthlyBillingData] ADD CONSTRAINT [PK_MonthlyBillingData] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MonthlyTriggerLog
-- --------------------------------------------------
ALTER TABLE [dbo].[MonthlyTriggerLog] ADD CONSTRAINT [PK_MonthlyTriggerLog] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OnBoardingList
-- --------------------------------------------------
ALTER TABLE [dbo].[OnBoardingList] ADD CONSTRAINT [PK_OnBoardingList] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.OtherVendor_GstInvoiceMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[OtherVendor_GstInvoiceMaster] ADD CONSTRAINT [PK__OtherVen__C3A4D3AC2D0A6B8B] PRIMARY KEY ([SrNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SBRegistrationFeeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[SBRegistrationFeeMaster] ADD CONSTRAINT [PK_SBRegistrationFeeMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SegmentMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[SegmentMaster] ADD CONSTRAINT [PK_SegmentMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SegmentMasterSub
-- --------------------------------------------------
ALTER TABLE [dbo].[SegmentMasterSub] ADD CONSTRAINT [PK_SegmentMasterSub] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ShortageMarginJV_OfflineLedger
-- --------------------------------------------------
ALTER TABLE [dbo].[ShortageMarginJV_OfflineLedger] ADD CONSTRAINT [PK__Shortage__EB811440EFAB4CD5] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ShortageMarginJV_OfflineLedgerLogFile
-- --------------------------------------------------
ALTER TABLE [dbo].[ShortageMarginJV_OfflineLedgerLogFile] ADD CONSTRAINT [PK__Shortage__EB8114409D30CBC0] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.StateMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[StateMaster] ADD CONSTRAINT [PK_StateMaster] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.StateMasterSub
-- --------------------------------------------------
ALTER TABLE [dbo].[StateMasterSub] ADD CONSTRAINT [PK_StateMasterSub] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SubBrokerLimitEnhencementSummaryReport
-- --------------------------------------------------
ALTER TABLE [dbo].[SubBrokerLimitEnhencementSummaryReport] ADD CONSTRAINT [PK__SubBroke__67F03F3989740565] PRIMARY KEY ([SBLimitEnhencementSummaryId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B6101ED03DA] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.SystemLogs
-- --------------------------------------------------
ALTER TABLE [dbo].[SystemLogs] ADD CONSTRAINT [PK_SystemLogs] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails] ADD CONSTRAINT [PK__tbl_Clie__5C5E5DAA065F606B] PRIMARY KEY ([ESignDocumentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ClientDRFInwordDocuments
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientDRFInwordDocuments] ADD CONSTRAINT [PK__tbl_Clie__1A36AF357CB0B390] PRIMARY KEY ([DRFDocumentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ClientSebiPayoutBlockingDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientSebiPayoutBlockingDetails] ADD CONSTRAINT [PK__tbl_Clie__97C11C19CE325B0A] PRIMARY KEY ([SEBI_BlockingId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DRFInwordRegistrationProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFInwordRegistrationProcessDetails] ADD CONSTRAINT [PK__tbl_DRFI__31A1DE2619539CDC] PRIMARY KEY ([SharesId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DRFInwordRegistrationProcessMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFInwordRegistrationProcessMaster] ADD CONSTRAINT [PK__tbl_DRFI__52EEEAE555DBC9A8] PRIMARY KEY ([DRFId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DRFOutwordRegistrationSendToRTADetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFOutwordRegistrationSendToRTADetails] ADD CONSTRAINT [PK__tbl_DRFO__0347435AD7139CA3] PRIMARY KEY ([DRFOutword_RTAId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DRFPodInwordRegistrationProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFPodInwordRegistrationProcess] ADD CONSTRAINT [PK__tbl_DRFP__69F90AFE74369AF2] PRIMARY KEY ([PodId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DRFProcessClientMailStatusDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DRFProcessClientMailStatusDetails] ADD CONSTRAINT [PK__tbl_DRFP__5A5E86B5D6ECB4BA] PRIMARY KEY ([StatusDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_GstOtherVendorMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_GstOtherVendorMaster] ADD CONSTRAINT [PK__tbl_GstO__C3A4D3ACD3E09269] PRIMARY KEY ([SrNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_GstOtherVendorMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_GstOtherVendorMaster] ADD CONSTRAINT [UK_vendor_supno_panno] UNIQUE ([VENDOR_TAG], [SUPNO], [PANNO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryCSOVerificationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryCSOVerificationMaster] ADD CONSTRAINT [PK__tbl_Inte__ADEE422EC9D85988] PRIMARY KEY ([CSOProcessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterAddressDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterAddressDetails] ADD CONSTRAINT [PK__tbl_Inte__84B2CE7E925C52F2] PRIMARY KEY ([IntermediaryAddressId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterBankDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterBankDetails] ADD CONSTRAINT [PK__tbl_Inte__BE2BB2743F13FA7A] PRIMARY KEY ([IntermediaryBankDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterBrokerageDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterBrokerageDetails] ADD CONSTRAINT [PK__tbl_Inte__BB714C147E464150] PRIMARY KEY ([IntermediaryBrokerageDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterDepositAndFeesDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterDepositAndFeesDetails] ADD CONSTRAINT [PK__tbl_Inte__C677C9B34D979E64] PRIMARY KEY ([IntermediaryDepositDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterGeneralDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterGeneralDetails] ADD CONSTRAINT [PK__tbl_Inte__5ED99B3343137E66] PRIMARY KEY ([IntermediaryId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterMultiPartnersDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterMultiPartnersDetails] ADD CONSTRAINT [PK__tbl_Inte__77322EE5A887FE77] PRIMARY KEY ([PartnersDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterOccuptionDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterOccuptionDetails] ADD CONSTRAINT [PK__tbl_Inte__C29200AE64412189] PRIMARY KEY ([IntermediaryOccuptionDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterPLVCProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterPLVCProcess] ADD CONSTRAINT [PK__tbl_Inte__46A8AC0F32B5091A] PRIMARY KEY ([PLVCProcessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediaryMasterSegmentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediaryMasterSegmentDetails] ADD CONSTRAINT [PK__tbl_Inte__09B388EA611A9E22] PRIMARY KEY ([IntermediarySegmentDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediarySBTagGenerationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationMaster] ADD CONSTRAINT [PK__tbl_Inte__B452183B76464C55] PRIMARY KEY ([SBMasterId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediarySBTagGenerationRegistrationDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationRegistrationDetails] ADD CONSTRAINT [PK__tbl_Inte__6EF588100C64D7A5] PRIMARY KEY ([RegistrationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediarySBTagGenerationUploadedDocumentsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBTagGenerationUploadedDocumentsDetails] ADD CONSTRAINT [PK__tbl_Inte__710FB270439DE028] PRIMARY KEY ([DocumentsDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntermediarySBVerificationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntermediarySBVerificationMaster] ADD CONSTRAINT [PK__tbl_Inte__650679C679EC7FC9] PRIMARY KEY ([SBProcessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_RejectedDRFOutwordProcessAndResponseDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_RejectedDRFOutwordProcessAndResponseDetails] ADD CONSTRAINT [PK__tbl_Reje__056C2986783E9216] PRIMARY KEY ([OutwordProcessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_RTARejectedDRFMemoScannedDocument
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_RTARejectedDRFMemoScannedDocument] ADD CONSTRAINT [PK__tbl_RTAR__661EA3334ACD8F57] PRIMARY KEY ([DRFMemoDocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBDepositBankingVarificationProcess
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositBankingVarificationProcess] ADD CONSTRAINT [PK__tbl_SBDe__4F51FE22770F2A36] PRIMARY KEY ([BankingProcessId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBDepositKnockOffProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositKnockOffProcessDetails] ADD CONSTRAINT [PK__tbl_SBDe__F369DFE7F01F5E38] PRIMARY KEY ([KnockOffDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBDepositSuspenceAccountDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositSuspenceAccountDetails] ADD CONSTRAINT [PK__tbl_SBDe__AD3F660E828E0FA6] PRIMARY KEY ([SuspenceAccDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBDepositVarificationAndProcessBySBTeam
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBDepositVarificationAndProcessBySBTeam] ADD CONSTRAINT [PK__tbl_SBDe__969FE12C31E65D7F] PRIMARY KEY ([DepositVarificationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBKnockOffDebitedAmountProcessDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBKnockOffDebitedAmountProcessDetails] ADD CONSTRAINT [PK__tbl_SBKn__F369DFE7C19E4D93] PRIMARY KEY ([KnockOffDetailsId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBMultiLocationTagGenerationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBMultiLocationTagGenerationMaster] ADD CONSTRAINT [PK__tbl_SBMu__08BEE0AA839B379C] PRIMARY KEY ([MultiTagMasterId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBPayoutDepositProcessDetailsInLMS
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBPayoutDepositProcessDetailsInLMS] ADD CONSTRAINT [PK__tbl_SBPa__EAEBF7C89A5F2B59] PRIMARY KEY ([DepositRefId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBPayoutDepositProcessDocumentDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBPayoutDepositProcessDocumentDetails] ADD CONSTRAINT [PK__tbl_SBPa__FD636E873D9F6435] PRIMARY KEY ([Deposit_DocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SBPayoutDetailsBankingVarification
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SBPayoutDetailsBankingVarification] ADD CONSTRAINT [PK__tbl_SBPa__865B3A8B55446B35] PRIMARY KEY ([BankingVarificationId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SubBrokerOnBoardingCompanyMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SubBrokerOnBoardingCompanyMaster] ADD CONSTRAINT [PK__tbl_SubB__2D971CACBA18A6CD] PRIMARY KEY ([CompanyId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_UndeliveredClientDRFInwordDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_UndeliveredClientDRFInwordDetails] ADD CONSTRAINT [PK__tbl_Unde__E556B0B55CCEA24B] PRIMARY KEY ([UnDeliveredId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UploadExcel
-- --------------------------------------------------
ALTER TABLE [dbo].[UploadExcel] ADD CONSTRAINT [PK__UploadEx__3214EC274C9A906E] PRIMARY KEY ([ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserProfile
-- --------------------------------------------------
ALTER TABLE [dbo].[UserProfile] ADD CONSTRAINT [PK__UserProf__1788CC4CF57EC976] PRIMARY KEY ([UserId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.V2_OfflineLedger
-- --------------------------------------------------
ALTER TABLE [dbo].[V2_OfflineLedger] ADD CONSTRAINT [PK_FLDAUTO] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.V3_OfflineLedger
-- --------------------------------------------------
ALTER TABLE [dbo].[V3_OfflineLedger] ADD CONSTRAINT [PK_FLDAUTOV3] PRIMARY KEY ([FldAuto])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AvailableBalance05BySBTag_tobedeleted09jan2026
-- --------------------------------------------------
CREATE PROC [dbo].[AvailableBalance05BySBTag]
@pSubtag nvarchar(MAX) 
AS
BEGIN




SELECT DISTINCT [sb tag] AS SBTAG,BSECM AS BICS,NSECM AS NICS,NSEFO AS NIFA,MCX AS MICX,NCDEX AS NICX,MCD AS MCD,NSX AS NICF,
ISNULL([Non Cash Deposit],0) AS NonCashDeposit,
ABL=ISNULL(ABL,0),ACBPL=ISNULL(ACBPL,0),
[Accruals]=ISNULL([Accruals],0),ISNULL([Accured Brokerage],0) AS AccuredBrokerage
FROM
(
SELECT [sb tag]=X.SB,
BSECM = ISNULL(BSECM,0),NSECM= ISNULL(NSECM,0),NSEFO= ISNULL(NSEFO,0),
MCX= ISNULL(MCX,0),NCDEX= ISNULL(NCDEX,0),
MCD= ISNULL(MCD,0),NSX= ISNULL(NSX,0)
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
(SELECT A.cltcode,
[BSECM]=CONVERT(VARCHAR(15), Sum(CASE WHEN segment='BSECM' THEN balance ELSE 0 END)/1),
NSECM= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSECM' THEN balance ELSE 0 END)/1),
NSEFO= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSEFO' THEN balance ELSE 0 END)/1),
MCX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='MCX' THEN balance ELSE 0 END)/1),
NCDEX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NCDEX' THEN balance ELSE 0 END)/1),
MCD= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='MCD' THEN balance ELSE 0 END)/1),
NSX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSX' THEN balance ELSE 0 END)/1),
TOTAL= CONVERT(DECIMAL(15, 2), Sum(balance) / 1)
FROM
(
select cltcode,'BSECM' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.bsecm_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSECM' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSECM_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSEFO' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSEFO_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'MCX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.MCX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NCDEX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NCDEX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'MCD' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.MCD_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
)A
WHERE A.cltcode in(SELECT DISTINCT SB = '05'+SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK))
GROUP BY A.cltcode
) Y ON X.SB=SUBSTRING(Y.cltcode,3,10)
) P
LEFT JOIN
(
--SELECT Sub_Broker ,[Non Cash Deposit]=CONVERT(DECIMAL(15, 2), Sum(SB_NonCashColl)),
--[Accured Brokerage]=CONVERT(DECIMAL(15, 2), Sum(SB_Brokerage))
--FROM   rms_dtsbfi a WITH (nolock)
--GROUP  BY a.sub_broker
SELECT X.SB,[Non Cash Deposit]=CONVERT(DECIMAL(18,2),ISNULL(SB_NonCashColl,0)),[Accured Brokerage]=CONVERT(DECIMAL(18,2),ISNULL(SB_Brokerage,0))
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
/*Modified on 26 AUG 2013 as per Sailesh Req.*/
--(SELECT SB,SUM(Remi_share) SB_Brokerage FROM Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) M
(SELECT B.SB,SB_Brokerage = ISNULL(A.SB_Brokerage,B.SB_Brokerage)
FROM(SELECT Sub_Broker SB ,SB_Brokerage=CONVERT(DECIMAL(15, 2), Sum(SB_Brokerage))
FROM   [196.1.115.182].general.dbo.rms_dtsbfi WITH (nolock)
GROUP  BY sub_broker) A
RIGHT JOIN (SELECT SB,SUM(Remi_share) SB_Brokerage FROM [196.1.115.182].general.dbo.Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) B
ON A.SB= B.SB
) M
ON X.SB = M.SB
LEFT JOIN
(SELECT SB,SUM(N.total_WithHC) SB_NonCashColl FROM [196.1.115.182].general.dbo.Vw_SB_NonCashCollateral N WITH(NOLOCK) GROUP BY SB) N
ON X.SB = N.SB
) Q
ON  P.[sb tag] = Q.SB
LEFT JOIN
(
SELECT sbcode,ABL,ACBPL,[Accruals]= CONVERT(DECIMAL(20, 2), unreg_tot)
FROM   [196.1.115.182].general.dbo.vw_sb_balance a WITH(NOLOCK)
--LEFT OUTER JOIN vw_rms_sb_vertical b WITH(NOLOCK) ON a.sbcode = b.sb
)R
ON  P.[sb tag] = R.SBCODE


WHERE [Sb tag] =@pSubtag

--where [sb tag] IN (
--SELECT CAST(Item AS NVARCHAR(MAX))
--            FROM SplitString(@pSubtag, ',')
--)
/*
SELECT X.SB,[Non Cash Deposit]=ISNULL(SB_NonCashColl,0),[Accured Brokerage]=ISNULL(SB_Brokerage,0)
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
(SELECT SB,SUM(Remi_share) SB_Brokerage FROM Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) M
ON X.SB = M.SB
LEFT JOIN
(SELECT SB,SUM(N.total_WithHC) SB_NonCashColl FROM Vw_SB_NonCashCollateral N WITH(NOLOCK) GROUP BY SB) N
ON X.SB = N.SB
*/
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Edit_SBPayoutDepositProcessDetailsInLMS
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[Edit_SBPayoutDepositProcessDetailsInLMS]            
(            
@SBPanNo VARCHAR(15) , @SBName VARCHAR(255),@RefId bigint, @RefNo VARCHAR(35),@Amount Decimal(17,2),            
@FileName VARCHAR(100)='',@File Image=null , @Extension VARCHAR(10)='',@Remarks VARCHAR(255)           
)            
AS            
BEGIN            
IF EXISTS(SELECT * FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE DepositRefId=@RefId)            
BEGIN            
DECLARE @SuspenceAccDetailsId bigint      
IF EXISTS(SELECT * FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE DepositRefId=@RefId AND IsBankingRejected=1)   
BEGIN  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET SBPanNo=@SBPanNo, SBName=@SBName, RefNo=@RefNo ,       
FileName=@FileName, Extension=@Extension,    
 Amount=@Amount,Remarks=@Remarks,IsSBRejected=2,SBRejectionReason='' WHERE DepositRefId=@RefId    

Update tbl_SBPayoutDepositProcessDocumentDetails set Files=@File,FileName=@FileName,Extension=@Extension 
 WHERE DepositRefId=@RefId  
    
SET @SuspenceAccDetailsId = (SELECT DISTINCT SuspenceAccDetailsId FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE DepositRefId=@RefId)  
  
DELETE FROM tbl_SBDepositBankingVarificationProcess WHERE IsBankingRejected=1 AND SuspenceAccDetailsId=@SuspenceAccDetailsId   
DELETE FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE DepositRefId=@RefId        
DELETE FROM tbl_SBDepositSuspenceAccountDetails WHERE SuspenceAccDetailsId=@SuspenceAccDetailsId   
  
END  
ELSE  
BEGIN  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET SBPanNo=@SBPanNo, SBName=@SBName, RefNo=@RefNo ,       
FileName=@FileName, Extension=@Extension,    
Amount=@Amount,Remarks=@Remarks,IsSBRejected=2,SBRejectionReason='' WHERE DepositRefId=@RefId    

Update tbl_SBPayoutDepositProcessDocumentDetails set Files=@File,FileName=@FileName,Extension=@Extension 
 WHERE DepositRefId=@RefId  
    
UPDATE tbl_SBDepositVarificationAndProcessBySBTeam SET IsSBRejected=2, RejectionReason='Re Process'        
WHERE DepositRefId=@RefId    
  
END  


SELECT 
SBPanNo,SBName,RefNo,Amount,Remarks,CONVERT(VARCHAR(10),CreatedOn,103) 'ProcessDate' INTO #TEST
FROM tbl_SBPayoutDepositProcessDetailsInLMS WITH(NOLOCK) WHERE DepositRefId=@RefId  

       
DECLARE @xml NVARCHAR(MAX)  
DECLARE @body NVARCHAR(MAX)             
DECLARE @Subject VARCHAR(MAX)= 'SB Deposit Process'          
  
 SET @xml = CAST(( SELECT [SBName] AS 'td','', [SBPanNo] AS 'td' ,'', [RefNo] AS 'td'            
 ,'', [Amount] AS 'td','', [Remarks] AS 'td' ,'', [ProcessDate] AS 'td'               
FROM #TEST                
                
--ORDER BY BalanceDate                
                
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                
                
SET @body ='<p style="font-size:medium; font-family:Calibri">                
                
 <b>Dear Team </b>,<br /><br />                
                
We are update the Rejected Client Ref Payout details received from Client for SB process. <br />  
Request you to please verify the details and start Tag generation process from your side. <br />                  
Please find the Details which we received from clients.          
                
 </H2>                
                
<table border=1   cellpadding=2 cellspacing=2>                
                
<tr style="background-color:rgb(201, 76, 76); color :White">                
                
<th> SBName </th> <th> SBPanNo </th> <th> RefNo </th> <th> Amount </th> <th> Remarks </th>  <th> ProcessDate </th> '                
         
 SET @body = @body + @xml +'</table></body></html>                
       
<br />Thanks & Regards,<br /><br />        
Angel One Ltd.  <br />      
System Generated Mail'                
                
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL 
                
@profile_name = 'AngelBroking',                
                
@body = @body,                
                
@body_format ='HTML',                
                
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',                
@recipients = 'pegasusinfocorp.suraj@angelbroking.com',                
                
@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',                
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',                
                
@subject = @Subject ;  

END          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pBankingEmailMaster
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pBankingEmailMaster]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT M.BANKACCOUNT
	  ,B.[Segment]
      ,B.[BankName]
      ,B.[BankCode]
      ,B.[FileType]
      ,[EmailSender]
      ,[EmailReceiver]
      ,[EmailReceiverPwd]
      ,[EmailSubject]
      ,[EmailReadTimeFrom]
      ,[EmailReadTimeTo]
      ,[EmailReadOrder]
      ,[EmailReadPosition]
      ,[IsZipFile]
      ,[EmailAttachmentLogic]
      ,[EmailAttachmentType]
      ,[ZipAttachmentType]
	  ,[IsAttachmentEncrypted]
	  ,[AttachmentPassword]
      ,[IsActive]
  FROM [ProcessAutomation].[dbo].[BankingFilesEmailMaster] B
    INNER JOIN [196.1.115.196].Account.dbo.RECON_BANK_MASTER M
ON M.SEGMENT=B.Segment AND M.BANKNAME=B.BankName AND M.FILETYPE=B.FileType AND M.BANKCODE=B.BankCode AND B.IsActive=1
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pBSEMasterAll
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pBSEMasterAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

SELECT RegDate AS REGISTRATION_DATE,RegFrom AS REGISTRATION_FROM,RegTo AS REGISTRATION_TO,SBTag AS SBTAG,Amount AS AMOUNT,SegmentFeeType AS NATURE 
FROM BSE_Master
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pBSEMasterInsert
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pBSEMasterInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
			@pRegFrom nvarchar(30),
			@pRegTo nvarchar(30) ,
			@pSBTAG nvarchar(30) ,
			--@pPanNo nvarchar(30) ,
			@pRegDate datetime ,
			--@pRegState nvarchar(20),
			--@pGST decimal(18, 0) ,
			--@pGSTAmount decimal(18, 0),
			--@pGSTValueType nvarchar(20),
			@pSegmentFeeType nvarchar(20) ,
			@pAmount decimal(18, 0) 
			--@pRecoveredAmount decimal(18, 0) ,
			--@pUnRecoveredAmount decimal(18, 0),
			--@pisRecovered bit,
			--@pRecoveredDate datetime,
			--@pIsRightOff bit,
			--@pCreatedDate datetime,
			--@pID bigint

		
			

	
AS
BEGIN
SET NOCOUNT ON;

--IF not exists 
--(
--SELECT @pID FROM [dbo].[BSE_Master] 
--WHERE ID=@pID
--)
BEGIN
INSERT INTO BSE_Master  (
			RegFrom,
			RegTo,
			SBTAG,
			--PanNo,
			RegDate ,
			--RegState ,
			--GST ,
			--GSTAmount,
			--GSTValueType,
			SegmentFeeType,
			Amount
			--RecoveredAmount,
			--UnRecoveredAmount,
			--isRecovered ,
			--RecoveredDate ,
			--IsRightOff  ,
			--CreatedDate

	)
VALUES (
			@pRegFrom,
			@pRegTo ,
			@pSBTAG,
			--@pPanNo,
			@pRegDate ,
			--@pRegState,
			--@pGST  ,
			--@pGSTAmount,
			--@pGSTValueType,
			@pSegmentFeeType ,
			@pAmount
			--@pRecoveredAmount ,
			--@pUnRecoveredAmount ,
			--@pisRecovered ,
			--@pRecoveredDate ,
			--@pIsRightOff ,
			--Getdate() 

	 );
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pControlAccountMasterAll
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pControlAccountMasterAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
--SELECT ControlAccount.ID,FromExchange.Name 
--AS FromExchangeMasterName ,ControlAccount.FromExchangeMasterRefNo,ToExchange.Name 
--AS ToExchangeMasterName,ControlAccount.ToExchangeMasterRefNo,ControlAccount.Code
--FROM ControlAccountMaster ControlAccount
--JOIN ExchangeMaster FromExchange
--ON FromExchange.ID = ControlAccount.FromExchangeMasterRefNo
--JOIN ExchangeMaster ToExchange
--ON ToExchange.ID = ControlAccount.ToExchangeMasterRefNo
--WHERE ControlAccount.IsActive=1 
SELECT ControlAccount.ID,FromSegment.Name 
AS FromExchangeMasterName ,ControlAccount.FromExchangeMasterRefNo,ToSegment.Name 
AS ToExchangeMasterName,ControlAccount.ToExchangeMasterRefNo,ControlAccount.Code
FROM ControlAccountMaster ControlAccount
JOIN SegmentMaster FromSegment
ON FromSegment.ID = ControlAccount.FromExchangeMasterRefNo
JOIN SegmentMaster ToSegment
ON ToSegment.ID = ControlAccount.ToExchangeMasterRefNo
WHERE ControlAccount.IsActive=1  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pControlAccountMasterById
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pControlAccountMasterById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the AccountMaster Details using ID >
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ControlAccount.ID,FromExchange.Name AS FromExchangeMasterName ,ControlAccount.IsActive,ControlAccount.FromExchangeMasterRefNo,ToExchange.Name AS ToExchangeMasterName,ControlAccount.ToExchangeMasterRefNo,ControlAccount.Code
FROM ControlAccountMaster ControlAccount 
INNER JOIN SegmentMaster FromExchange
ON FromExchange.ID = ControlAccount.FromExchangeMasterRefNo
INNER JOIN SegmentMaster ToExchange
ON ToExchange.ID = ControlAccount.ToExchangeMasterRefNo
WHERE ControlAccount.ID= @pID  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pControlAccountMasterDelete
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pControlAccountMasterDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AccountMasterDetails using ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE ControlAccountMaster 
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pControlAccountMasterInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pControlAccountMasterInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pFromExchangeMasterRefNo bigint ,
	@pToExchangeMasterRefNo bigint ,
	@pCode bigint ,
	@pIsActive bit,
	--@pCreatedOn datetime,
	@pCreatedBy nvarchar(20),
	--@pUpdatedOn datetime ,
	@pUpdatedBy nvarchar(20),
	--@pDeletedOn datetime,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[ControlAccountMaster] 
WHERE ID=@pID
)
BEGIN
INSERT INTO ControlAccountMaster  (
	FromExchangeMasterRefNo,
	ToExchangeMasterRefNo,
	Code  ,
	IsActive ,
	CreatedOn ,
	CreatedBy,
	UpdatedOn  ,
	UpdatedBy,
	--DeletedOn ,
	--DeletedBy,
	ServerIP
	)
VALUES (
	@pFromExchangeMasterRefNo,
	@pToExchangeMasterRefNo,
	@pCode  ,
	@pIsActive ,
	GETDATE() ,
	@pCreatedBy,
	GETDATE()  ,
	@pUpdatedBy,
	--null ,
	--null,
	@pServerIP
	 );
END

ELSE
BEGIN
UPDATE ControlAccountMaster
SET	FromExchangeMasterRefNo=@pFromExchangeMasterRefNo,
	ToExchangeMasterRefNo=@pToExchangeMasterRefNo,
	Code=@pCode,
	IsActive=@pIsActive,
	--CreatedOn=GETDATE(),
	--CreatedBy=@pCreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedOn=GETDATE(),
	--DeletedBy=@pDeletedBy,
	ServerIP=@pServerIP
	
WHERE ID=@pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDailyTriggerLogCreate
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================


CREATE PROCEDURE [dbo].[pDailyTriggerLogCreate]

	@CreatedDate datetime,
	@DailyStatus nvarchar(10),
	@Details nvarchar(30),
	@Rescheduled bit,
	@ID bigint
	 
AS
BEGIN
INSERT INTO pDailyTriggerLogCreate  (
	CreatedDate,
	DailyStatus,
	Details,
	Rescheduled
	)
    VALUES (
	@CreatedDate,
	@DailyStatus,
	@Details,
	@Rescheduled
	 );
 
SET @ID = SCOPE_IDENTITY();
 
SELECT 
	CreatedDate=@CreatedDate,
	DailyStatus=@DailyStatus,
	Details=@Details,
	Rescheduled=@Rescheduled
		

FROM DailyTriggerLog 
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDailyTriggerLogDelete
-- --------------------------------------------------
CREATE PROC [dbo].[pDailyTriggerLogDelete] 
    @ID bigint
AS 
BEGIN 
DELETE
FROM   DailyTriggerLog
WHERE  ID = @ID
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDailyTriggerLogRead
-- --------------------------------------------------
CREATE PROC pDailyTriggerLogRead
    @ID int
AS 
BEGIN 
 
 SELECT ID, CreatedDate, DailyStatus, Details, Rescheduled
    FROM   DailyTriggerLog  
    WHERE  (ID = @ID)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pDailyTriggerLogUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[pDailyTriggerLogUpdate]
	@ID bigint,
	@CreatedDate datetime,
	@DailyStatus nvarchar(10),
	@Details nvarchar(30),
	@Rescheduled bit
  
AS 
BEGIN 
 
UPDATE DailyTriggerLog

SET	CreatedDate=@CreatedDate,
	DailyStatus=@DailyStatus,
	Details=@Details,
	Rescheduled=@Rescheduled

WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pEEEEEEEEEEEEEEEE_06Nov2025
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pEEEEEEEEEEEEEEEE_06Nov2025]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Get the AccountMaster Details using ID >  
--=============================================  
@pTradeName nvarchar(500),  
@pBillingDate Date,  
@pNature nvarchar(20),  
@pSegment nvarchar(100)  
AS   
BEGIN   
SET NOCOUNT ON;  
  
 SELECT * INTO #Temp FROM   
(SELECT S.SBTAG,B.RegName, REPLACE(B.RegName,' ','')AS Name,TAGGeneratedDate,IsActive,IsActiveDate   
FROM SB_COMP.[dbo].[SB_Broker] S  
INNER JOIN SB_COMP.[dbo].[bpregMaster] B  
ON S.SBTAG=B.REGTAG AND B.RegExchangeSegment IN(SELECT CAST(Item AS NVARCHAR(MAX))FROM SplitString(@pSegment, ','))  
WHERE REPLACE(B.RegName,' ','')= REPLACE(@pTradeName,' ','') )data  
  
DECLARE @Statement  nvarchar(700)  
DECLARE @count INT  
SET @count = (SELECT COUNT(SBTAG) FROM #Temp)  
   
IF @count =0  
 BEGIN  
  SELECT '-' AS SBTAG,'No Match FOUND' AS History,@pTradeName FROM #Temp  
 END  
ELSE IF @count =1  
 BEGIN  
  SELECT SBTAG,'1 Match FOUND'AS History,@pTradeName FROM #Temp  
 END  
ELSE  
 BEGIN  
  IF(@pNature='Registration')  
  BEGIN  
   SET @count = (SELECT COUNT(SBTAG) FROM #Temp   
       WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
       AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0)))  
    IF @count =0  
    BEGIN  
     SELECT '-' AS SBTAG,'No Match Found in Previous Month' AS History,@pTradeName FROM #Temp  
    END  
    ELSE IF @count =1  
    BEGIN  
     SELECT SBTAG,'1 Match FOUND in Previous Month' AS History,@pTradeName FROM #Temp   
     WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
     AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0))  
    END   
    ELSE  
    BEGIN  
     SELECT SBTAG,'More Tags Found' AS History,@pTradeName FROM #Temp   
     WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
     AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0))  
    END    
   END  
   ELSE  
   BEGIN  
    SET @count = (SELECT COUNT(SBTAG) FROM #Temp   
       WHERE IsActive='InActive')  
    IF @count =0  
    BEGIN  
     SELECT '-' AS SBTAG,'No Match Found :InActive' AS History,@pTradeName FROM #Temp  
    END  
    ELSE IF @count =1  
    BEGIN  
     SELECT SBTAG,'1 Match FOUND Found :InActive' AS History,@pTradeName FROM #Temp WHERE IsActive='InActive'  
    END   
    ELSE  
    BEGIN  
     SELECT TOP 1 SBTAG,'1 Match FOUND Found :InActive TOP 1' AS History,@pTradeName FROM #Temp WHERE IsActive='InActive' ORDER BY IsActiveDate DESC  
    END    
   END  
 END  
  
 DROP TABLE #Temp  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pEEEEEEEEEEEEEEEE_tobedeleted09jan2026
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pEEEEEEEEEEEEEEEE]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Get the AccountMaster Details using ID >  
--=============================================  
@pTradeName nvarchar(500),  
@pBillingDate Date,  
@pNature nvarchar(20),  
@pSegment nvarchar(100)  
AS  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

BEGIN   
SET NOCOUNT ON;  
  
 SELECT * INTO #Temp FROM   
(SELECT S.SBTAG,B.RegName, REPLACE(B.RegName,' ','')AS Name,TAGGeneratedDate,IsActive,IsActiveDate   
FROM SB_COMP.[dbo].[SB_Broker] S  
INNER JOIN SB_COMP.[dbo].[bpregMaster] B  
ON S.SBTAG=B.REGTAG AND B.RegExchangeSegment IN(SELECT CAST(Item AS NVARCHAR(MAX))FROM SplitString(@pSegment, ','))  
WHERE REPLACE(B.RegName,' ','')= REPLACE(@pTradeName,' ','') )data  
  
DECLARE @Statement  nvarchar(700)  
DECLARE @count INT  
SET @count = (SELECT COUNT(SBTAG) FROM #Temp)  
   
IF @count =0  
 BEGIN  
  SELECT '-' AS SBTAG,'No Match FOUND' AS History,@pTradeName FROM #Temp  
 END  
ELSE IF @count =1  
 BEGIN  
  SELECT SBTAG,'1 Match FOUND'AS History,@pTradeName FROM #Temp  
 END  
ELSE  
 BEGIN  
  IF(@pNature='Registration')  
  BEGIN  
   SET @count = (SELECT COUNT(SBTAG) FROM #Temp   
       WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
       AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0)))  
    IF @count =0  
    BEGIN  
     SELECT '-' AS SBTAG,'No Match Found in Previous Month' AS History,@pTradeName FROM #Temp  
    END  
    ELSE IF @count =1  
    BEGIN  
     SELECT SBTAG,'1 Match FOUND in Previous Month' AS History,@pTradeName FROM #Temp   
     WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
     AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0))  
    END   
    ELSE  
    BEGIN  
     SELECT SBTAG,'More Tags Found' AS History,@pTradeName FROM #Temp   
     WHERE TAGGeneratedDate>= DATEADD(month, DATEDIFF(month, -1, @pBillingDate) - 2, 0)  
     AND TAGGeneratedDate<=DATEADD(ss, -1, DATEADD(month, DATEDIFF(month, 0, @pBillingDate), 0))  
    END    
   END  
   ELSE  
   BEGIN  
    SET @count = (SELECT COUNT(SBTAG) FROM #Temp   
       WHERE IsActive='InActive')  
    IF @count =0  
    BEGIN  
     SELECT '-' AS SBTAG,'No Match Found :InActive' AS History,@pTradeName FROM #Temp  
    END  
    ELSE IF @count =1  
    BEGIN  
     SELECT SBTAG,'1 Match FOUND Found :InActive' AS History,@pTradeName FROM #Temp WHERE IsActive='InActive'  
    END   
    ELSE  
    BEGIN  
     SELECT TOP 1 SBTAG,'1 Match FOUND Found :InActive TOP 1' AS History,@pTradeName FROM #Temp WHERE IsActive='InActive' ORDER BY IsActiveDate DESC  
    END    
   END  
 END  
  
 DROP TABLE #Temp  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeAccountAll
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pExchangeAccountAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 

--WHERE ControlAccount.IsActive=1 
SELECT Exchange.ID,FromSegment.Name 
AS FromExchangeMasterName ,Exchange.FromExchangeMasterRefNo,ToSegment.Name 
AS ToExchangeMasterName,Exchange.ToExchangeMasterRefNo,Exchange.Code
FROM ExchangeAccount Exchange
JOIN SegmentMaster FromSegment
ON FromSegment.ID = Exchange.FromExchangeMasterRefNo
JOIN SegmentMaster ToSegment
ON ToSegment.ID = Exchange.ToExchangeMasterRefNo
WHERE Exchange.IsActive=1  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeAccountById
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExchangeAccountById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the AccountMaster Details using ID >
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ExchangeAccount.ID,FromExchange.Name AS FromExchangeMasterName ,ExchangeAccount.IsActive,ExchangeAccount.FromExchangeMasterRefNo,ToExchange.Name AS ToExchangeMasterName,ExchangeAccount.ToExchangeMasterRefNo,ExchangeAccount.Code
FROM ExchangeAccount ExchangeAccount 
INNER JOIN SegmentMaster FromExchange
ON FromExchange.ID = ExchangeAccount.FromExchangeMasterRefNo
INNER JOIN SegmentMaster ToExchange
ON ToExchange.ID = ExchangeAccount.ToExchangeMasterRefNo
WHERE ExchangeAccount.ID= @pID  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeAccountDelete
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExchangeAccountDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for AccountMasterDetails using ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE ExchangeAccount 
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeAccountInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExchangeAccountInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pFromExchangeMasterRefNo bigint ,
	@pToExchangeMasterRefNo bigint ,
	@pCode bigint ,
	@pIsActive bit,
	--@pCreatedOn datetime,
	@pCreatedBy nvarchar(20),
	--@pUpdatedOn datetime ,
	@pUpdatedBy nvarchar(20),
	--@pDeletedOn datetime,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[ExchangeAccount] 
WHERE ID=@pID
)
BEGIN
INSERT INTO ExchangeAccount  (
	FromExchangeMasterRefNo,
	ToExchangeMasterRefNo,
	Code  ,
	IsActive ,
	CreatedOn ,
	CreatedBy,
	UpdatedOn  ,
	UpdatedBy,
	--DeletedOn ,
	--DeletedBy,
	ServerIP
	)
VALUES (
	@pFromExchangeMasterRefNo,
	@pToExchangeMasterRefNo,
	@pCode  ,
	@pIsActive ,
	GETDATE() ,
	@pCreatedBy,
	GETDATE()  ,
	@pUpdatedBy,
	--null ,
	--null,
	@pServerIP
	 );
END

ELSE
BEGIN
UPDATE ExchangeAccount
SET	FromExchangeMasterRefNo=@pFromExchangeMasterRefNo,
	ToExchangeMasterRefNo=@pToExchangeMasterRefNo,
	Code=@pCode,
	IsActive=@pIsActive,
	--CreatedOn=GETDATE(),
	--CreatedBy=@pCreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedOn=GETDATE(),
	--DeletedBy=@pDeletedBy,
	ServerIP=@pServerIP
	
WHERE ID=@pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeMasterAll
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExchangeMasterAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the all ExchangeMaster Details>
--=============================================
--@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,Name,Code 
FROM ExchangeMaster 
WHERE IsActive=1
END

--drop procedure pExchangeMasterAll

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeMasterById
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pExchangeMasterById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the ExchangeMaster Details using ID>
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,Name,Code 
FROM ExchangeMaster 
WHERE ID=@pID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeMasterDelete
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pExchangeMasterDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for ExchangeMaster using ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE ExchangeMaster 
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pExchangeMasterInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pExchangeMasterInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for ExchangeMaster>
--=============================================
	@pName nvarchar(50),
	@pCode nvarchar(5),
	@pIsActive bit,
	@pCreatedOn datetime,
	@pCreatedBy nvarchar(20),
	@pUpdatedOn datetime,
	@pUpdatedBy nvarchar (20),
	--@pDeletedOn datetime,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
	 
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[ExchangeMaster] 
WHERE ID=@pID
)
BEGIN
INSERT INTO ExchangeMaster  (
	Name,
	Code,
	IsActive,
	CreatedOn, 
	CreatedBy,
	UpdatedOn,
	UpdatedBy,
	--DeletedOn,
	--DeletedBy,
	ServerIP
	)
    VALUES (
	@pName,
	@pCode,
	@pIsActive,
	GETDATE(), 
	@pCreatedBy,
	GETDATE(),
	@pUpdatedBy,
	--null,
	--null,
	@pServerIP
	 );
END

ELSE
BEGIN

UPDATE ExchangeMaster

SET	Name=@pName,
	Code=@pCode,
	IsActive=@pIsActive,
	--CreatedOn=@CreatedOn,
	--CreatedBy=@CreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedOn=@DeletedOn,
	--DeletedBy=@DeletedBy,
	ServerIP=@pServerIP

WHERE  ID = @pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBalanceByGlCode
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[pGetBalanceByGlCode]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the AccountMaster Details using ID >
--=============================================
@pSubtag nvarchar(10)
AS 
BEGIN 
SET NOCOUNT ON;
-- Changed By Mohan dtd 2020-09-11 - With Siva 
Select @pSubtag AS SBTAG,

(SELECT  COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0) 
from [196.1.115.196].account.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag ) NICS ,

(SELECT COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0)
from [196.1.115.201].Account_AB.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) BICS, 

(SELECT  COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0) 
from [196.1.115.200].AccountFO.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) NIFA,

(SELECT COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0) 
from [196.1.115.200].AccountcurFO.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) NICF,

(SELECT COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0) 
from [196.1.115.204].AccountMCDX.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) MICX,

(SELECT  COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0) 
from [196.1.115.204].AccountNCDX.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) NICX,

(SELECT   COALESCE(SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END),0)
From [196.1.115.204].AccountcurBFO.dbo.ledger WITH(NOLOCK)
WHERE VDT >='2020-04-01'   AND VDT <=GETDATE()
and cltcode=@pSubtag) BSX

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBillingDashboardRecords
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetBillingDashboardRecords]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pBillMonth int,
@pBillYear int

AS 
BEGIN 
SET NOCOUNT ON;
SELECT o.ID
	  ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,s.Name AS RegTo
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
	  ,[IsForceDebit]
      ,[isDuplicate]
	  ,[PendingAmount]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData] o
   LEFT JOIN [dbo].[SegmentMasterSub] sub
   on o.RegTo=sub.AliasCode
  LEFT JOIN [dbo].[SegmentMaster] s
  on s.ID=sub.SegmentID

WHERE o.BillMonth=@pBillMonth AND o.BillYear=@pBillYear

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBillingDuplicateRecords
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetBillingDuplicateRecords]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT [ID]
      ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[UpdatedOn]
      ,[isDuplicate]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData]

  WHERE [isDuplicate]=1 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBillingDuplicateRecordsbyId
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetBillingDuplicateRecordsbyId]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================

@pid int
AS 
BEGIN 
SET NOCOUNT ON;
SELECT [ID]
      ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[UpdatedOn]
      ,[isDuplicate]
	  ,[StateCode]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData]

  WHERE [isDuplicate]=1  AND [ID]=@pid

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBillingProcessRecords
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetBillingProcessRecords]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT [ID]
		,[StateCode]
      ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[TotalGST]
      ,[GSTAmount]
      ,[TotalAmount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
      ,[IsForceDebit]
      ,[CreatedBy]
      ,[CreatedOn]
      ,[UpatedBy]
      ,[UpdatedOn]
      ,[UploadedFrom]
      ,[isDuplicate]
      ,[IsForceWriteoffRecovered]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData]

  WHERE [isDuplicate]=0 AND [isRecovered]=0 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetBillingRecordsbyId
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetBillingRecordsbyId]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================

@pid int
AS 
BEGIN 
SET NOCOUNT ON;
SELECT [ID]
		,[StateCode]
      ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[UpdatedOn]
      ,[isDuplicate]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData]

  WHERE [ID]=@pid

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetControlAccountCodeBySegment
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetControlAccountCodeBySegment]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pFromSegment nvarchar(6),
@pToSegment nvarchar(6)
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT CODE FROM ControlAccountMaster 
WHERE FromExchangeMasterRefNo=(SELECT ID FROM SegmentMaster Where Code=@pFromSegment) 
AND	ToExchangeMasterRefNo=(SELECT ID FROM SegmentMaster Where Code=@pToSegment)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetDailyTriggerLog
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetDailyTriggerLog]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

SELECT TOP 1000 [ID]
      ,[ProceessedDate]
      ,[Status]
      ,[TotalRecords]
      ,[Recovered]
      ,[UnRecovered]
      ,[PartialRecovered]
      ,[NotApplied]
      ,[Details]
      ,[Remarks]
      ,[IsRescheduled]
      ,[RescheduledDate]
  FROM [ProcessAutomation].[dbo].[DailyTriggerLog]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetExchangeAccountCodeBySegment
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetExchangeAccountCodeBySegment]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pFromSegment nvarchar(6),
@pToSegment nvarchar(6)
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT CODE FROM ExchangeAccount 
WHERE FromExchangeMasterRefNo=(SELECT ID FROM SegmentMaster Where Code=@pFromSegment) 
AND	ToExchangeMasterRefNo=(SELECT ID FROM SegmentMaster Where Code=@pToSegment)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PGetExchangeAccountDetails
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[PGetExchangeAccountDetails]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the AccountMaster Details using ID >
--=============================================
@pFromSegment nvarchar(6),
@pSegmentFeeType nvarchar(15)
AS 
BEGIN 
SET NOCOUNT ON;
 
  SELECT Code,GLCode 
  FROM [ProcessAutomation].[dbo].[SBRegistrationFeeMaster] Fees
  INNER JOIN [ProcessAutomation].[dbo].[SegmentMaster] Segment
  ON RecoverySegment06=Segment.ID
  WHERE SegmentMasterRefNo=(SELECT ID FROM [ProcessAutomation].[dbo].[SegmentMaster] WHERE Code=@pFromSegment)
AND SegmentFeeType=@pSegmentFeeType
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetForceWriteOffRecords
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetForceWriteOffRecords]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT M.[ID]
	  ,[Name]
      ,[BillMonth]
      ,[BillYear]
      ,[RegFrom]
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
	  ,[TotalAmount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
	  ,[IsForceDebit]
      ,[isDuplicate]
	  ,[PendingAmount]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData] M
  INNER JOIN SegmentMaster S
  ON M.RegFrom=S.Code

  WHERE [IsWriteOff]=1 AND [isRecovered]=1

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetFTSubBrokerDashboard
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetFTSubBrokerDashboard]
@pFromDate datetime,@pToDate datetime
AS 
BEGIN 
SET NOCOUNT ON;
 
 SELECT s.Name
	  ,o.ID
	  ,[Regstatus]
      ,[RegExchangeSegment]
      ,[SBTAG]
      ,[PanNo]
      ,[TagGeneratedDate]
      ,[State]
      ,[TotalGST]
      ,[GSTValueType]
      ,[SegmentFeeType]
      ,[Amount]
      ,[TotalAmount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
	  ,[RecoveredDate]
  FROM [ProcessAutomation].[dbo].[OnBoardingList] o
   LEFT JOIN [dbo].[SegmentMasterSub] sub
   on o.RegExchangeSegment=sub.AliasCode
  LEFT JOIN [dbo].[SegmentMaster] s
  on s.ID=sub.SegmentID
  WHERE [TagGeneratedDate]>=@pFromDate 
  AND [TagGeneratedDate]<= @pToDate

--WHERE
--Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','	
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetGSTandAmountBySBTAG_06Nov2025
-- --------------------------------------------------
  
  
  
  
CREATE PROCEDURE [dbo].[pGetGSTandAmountBySBTAG_06Nov2025]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Insert and Update for AccountMaster>  
--=============================================  
   @pSBTag nvarchar(20),  
   @pSegments nvarchar(40),  
   @pSegmentFeeType nvarchar(20)   
   
AS  
BEGIN  
SET NOCOUNT ON;  
SELECT  
 sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment AS Code,  
 GSTMaster.StateCode,  
 GSTMaster.CGST_Code,  
 GSTMaster.CGST,  
 GSTMaster.SGST_Code,  
 GSTMaster.SGST,  
 GSTMaster.UGST_Code,  
 GSTMaster.UGST,  
 GSTMaster.IGST_Code,  
 GSTMaster.IGST,  
 GSTMaster.KFC_Code,  
 GSTMaster.KFC,  
 GSTMaster.TotalGST,  
 GSTMaster.GSTValueType,  
 FeesMaster.SegmentFeeType,  
 FeesMaster.Amount,  
 CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
  THEN ((FeesMaster.Amount*GSTMaster.TotalGST)/100)   
  ELSE (GSTMaster.TotalGST)   
 END) AS GSTAmount  
FROM SB_COMP.[dbo].[SB_Broker] sbbroker  
INNER JOIN SB_COMP.[dbo].[bpregMaster] bpregMaster  
ON bpregMaster.RegTAG=sbbroker.SBTAG  
LEFT JOIN (  
   --SELECT RefNo, State,AddType   
   --FROM  [SB_COMP].[dbo].[SB_Contact]  
   --WHERE AddType ='RES' OR AddType ='Ter'  
   --GROUP BY RefNo,State,AddType  
   SELECT S.RefNo,S.State,S.AddType  
   FROM (SELECT T.*,RANK() OVER (PARTITION BY T.RefNo ORDER BY T.AddType DESC ) AS rank  
      FROM [SB_COMP].[dbo].[SB_Contact] T WHERE T.AddType IN ('RES', 'OFF')  ) S  
   WHERE S.rank = 1   
   GROUP BY S.RefNo,S.State,S.AddType  
  ) AS contact  
ON contact.[RefNo]=sbbroker.[RefNo]  
LEFT JOIN (  
   SELECT statemaster.StateName AS StateName,statemaster.StateCode AS StateCode,  
   GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
   (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
   FROM GSTMasterData GST  
   INNER JOIN StateMaster statemaster  
   ON statemaster.ID = GST.GSTStateID  
   WHERE GST.IsActive=1  
  
   UNION  
  
   SELECT SUB.AliasName AS StateName,statemaster.StateCode AS StateCode,  
   GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
   (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
   FROM GSTMasterData GST  
   INNER JOIN StateMaster statemaster  
   ON statemaster.ID = GST.GSTStateID  
   INNER JOIN [dbo].[StateMasterSub] SUB  
   ON statemaster.ID = SUB.StateId  
   WHERE GST.IsActive=1  
  ) AS GSTMaster  
ON GSTMaster.StateName=contact.State  
LEFT JOIN (  
   SELECT SegmentSub.AliasCode AS SegmentCode,FeeMaster.SegmentFeeType,FeeMaster.Amount  
   FROM SBRegistrationFeeMaster FeeMaster  
   INNER JOIN SegmentMaster Segment  
   ON Segment.ID = FeeMaster.SegmentMasterRefNo  
   LEFT JOIN SegmentMasterSub SegmentSub  
   ON Segment.ID = SegmentSub.SegmentID  
   WHERE FeeMaster.IsActive=1  
   ) AS FeesMaster  
ON FeesMaster.SegmentCode=bpregMaster.RegExchangeSegment   
WHERE  sbbroker.Branch NOT IN('OFRA','RFRL')  
AND bpregMaster.RegExchangeSegment in( SELECT AliasCode FROM [ProcessAutomation].[dbo].[SegmentMasterSub] )  
--AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
--AND sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment=@pCode  
AND sbbroker.SBTAG=@pSBTag AND bpregMaster.RegExchangeSegment IN(SELECT Item FROM dbo.SplitString(@pSegments,',') )  
AND FeesMaster.SegmentFeeType=@pSegmentFeeType  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetGSTandAmountBySBTAG_tobedeleted09jan2026
-- --------------------------------------------------
  
  
  
  
CREATE PROCEDURE [dbo].[pGetGSTandAmountBySBTAG]  
--=============================================  
--Author:   <Author,,Akidut>  
--Created Date:  <Created Date,,23/10/2019>  
--Discription:  <Description,,Insert and Update for AccountMaster>  
--=============================================  
   @pSBTag nvarchar(20),  
   @pSegments nvarchar(40),  
   @pSegmentFeeType nvarchar(20)   
   
AS  
BEGIN
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SET NOCOUNT ON;  
SELECT  
 sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment AS Code,  
 GSTMaster.StateCode,  
 GSTMaster.CGST_Code,  
 GSTMaster.CGST,  
 GSTMaster.SGST_Code,  
 GSTMaster.SGST,  
 GSTMaster.UGST_Code,  
 GSTMaster.UGST,  
 GSTMaster.IGST_Code,  
 GSTMaster.IGST,  
 GSTMaster.KFC_Code,  
 GSTMaster.KFC,  
 GSTMaster.TotalGST,  
 GSTMaster.GSTValueType,  
 FeesMaster.SegmentFeeType,  
 FeesMaster.Amount,  
 CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
  THEN ((FeesMaster.Amount*GSTMaster.TotalGST)/100)   
  ELSE (GSTMaster.TotalGST)   
 END) AS GSTAmount  
FROM SB_COMP.[dbo].[SB_Broker] sbbroker  
INNER JOIN SB_COMP.[dbo].[bpregMaster] bpregMaster  
ON bpregMaster.RegTAG=sbbroker.SBTAG  
LEFT JOIN (  
   --SELECT RefNo, State,AddType   
   --FROM  [SB_COMP].[dbo].[SB_Contact]  
   --WHERE AddType ='RES' OR AddType ='Ter'  
   --GROUP BY RefNo,State,AddType  
   SELECT S.RefNo,S.State,S.AddType  
   FROM (SELECT T.*,RANK() OVER (PARTITION BY T.RefNo ORDER BY T.AddType DESC ) AS rank  
      FROM [SB_COMP].[dbo].[SB_Contact] T WHERE T.AddType IN ('RES', 'OFF')  ) S  
   WHERE S.rank = 1   
   GROUP BY S.RefNo,S.State,S.AddType  
  ) AS contact  
ON contact.[RefNo]=sbbroker.[RefNo]  
LEFT JOIN (  
   SELECT statemaster.StateName AS StateName,statemaster.StateCode AS StateCode,  
   GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
   (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
   FROM GSTMasterData GST  
   INNER JOIN StateMaster statemaster  
   ON statemaster.ID = GST.GSTStateID  
   WHERE GST.IsActive=1  
  
   UNION  
  
   SELECT SUB.AliasName AS StateName,statemaster.StateCode AS StateCode,  
   GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
   (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
   FROM GSTMasterData GST  
   INNER JOIN StateMaster statemaster  
   ON statemaster.ID = GST.GSTStateID  
   INNER JOIN [dbo].[StateMasterSub] SUB  
   ON statemaster.ID = SUB.StateId  
   WHERE GST.IsActive=1  
  ) AS GSTMaster  
ON GSTMaster.StateName=contact.State  
LEFT JOIN (  
   SELECT SegmentSub.AliasCode AS SegmentCode,FeeMaster.SegmentFeeType,FeeMaster.Amount  
   FROM SBRegistrationFeeMaster FeeMaster  
   INNER JOIN SegmentMaster Segment  
   ON Segment.ID = FeeMaster.SegmentMasterRefNo  
   LEFT JOIN SegmentMasterSub SegmentSub  
   ON Segment.ID = SegmentSub.SegmentID  
   WHERE FeeMaster.IsActive=1  
   ) AS FeesMaster  
ON FeesMaster.SegmentCode=bpregMaster.RegExchangeSegment   
WHERE  sbbroker.Branch NOT IN('OFRA','RFRL')  
AND bpregMaster.RegExchangeSegment in( SELECT AliasCode FROM [ProcessAutomation].[dbo].[SegmentMasterSub] )  
--AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
--AND sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment=@pCode  
AND sbbroker.SBTAG=@pSBTag AND bpregMaster.RegExchangeSegment IN(SELECT Item FROM dbo.SplitString(@pSegments,',') )  
AND FeesMaster.SegmentFeeType=@pSegmentFeeType  
END  
  
  /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetGSTDetailsByState
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGetGSTDetailsByState]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pStateCode nvarchar(5)
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT 
StateCode 
,[CGST]
,[SGST]
,[UGST]
,[IGST]
,[KFC]
,[CGST_Code]
,[SGST_Code]
,[UGST_Code]
,[IGST_Code]
,[KFC_Code]
FROM GSTMasterData  G
INNER JOIN [dbo].[StateMaster] S
ON S.ID=G.[GSTStateID]

WHERE StateCode =@pStateCode
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetMonthlyTriggerLog
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetMonthlyTriggerLog]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

SELECT TOP 1000 [ID]
      ,[ProceessedDate]
	  ,[ProceessedMonth]
	  ,[ProceessedYear]
      ,[Status]
      ,[TotalRecords]
      ,[Recovered]
      ,[UnRecovered]
      ,[PartialRecovered]
      ,[ForceWriteoff]
	  ,[ForceDebit]
      ,[Details]
      ,[Remarks]
  FROM [ProcessAutomation].[dbo].[MonthlyTriggerLog]
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetSlNo
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetSlNo]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pDate nvarchar(15)=NULL
AS 
BEGIN 
SET NOCOUNT ON;
IF @pDate IS NULL
BEGIN 
SET @pDate=CAST(GETDATE() AS date)
PRINT @pDate
END
  SELECT CASE WHEN MAX(SNo) IS NULL THEN 0  ELSE MAX(SNo) END  AS SlNo FROM [ProcessAutomation].[dbo].[V2_OfflineLedger]
   WHERE Vdate=@pDate
  --WHERE Vdate>DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetSubBrokerDashboard
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetSubBrokerDashboard]
@pDate datetime
AS 
BEGIN 
SET NOCOUNT ON;
 
 SELECT s.Name
	  ,o.ID
	  ,[Regstatus]
      ,[RegExchangeSegment]
      ,[SBTAG]
      ,[PanNo]
      ,[TagGeneratedDate]
      ,[State]
      ,[TotalGST]
      ,[GSTValueType]
      ,[SegmentFeeType]
      ,[Amount]
      ,[TotalAmount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
	  ,[RecoveredDate]
  FROM [ProcessAutomation].[dbo].[OnBoardingList] o
  LEFT JOIN [dbo].[SegmentMaster] s
  on o.RegExchangeSegment=s.Code
  WHERE [TagGeneratedDate]>=@pDate 
  --AND [TagGeneratedDate]< DATEADD(day, 1, @pDate)

--WHERE
--Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','	
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetSubBrokerOnBoardingList_06Nov2025
-- --------------------------------------------------
  
  
  
  
CREATE PROCEDURE [dbo].[pGetSubBrokerOnBoardingList_06Nov2025]  
  
AS   
BEGIN   
SET NOCOUNT ON;  
   
 SELECT [ID]  
      ,[Regstatus]  
      ,[RegExchangeSegment]  
   ,[RecoverySegment06]  
      ,[SBTAG]  
      ,[PanNo]  
      ,[TagGeneratedDate]  
      ,[State]  
      ,[TotalGST]  
      ,[GSTValueType]  
      ,[SegmentFeeType]  
      ,[Amount]  
      ,[TotalAmount]  
      ,[RecoveredAmount]  
      ,[UnRecoveredAmount]  
      ,[isRecovered]  
  FROM [ProcessAutomation].[dbo].[OnBoardingList]  
  WHERE [isRecovered]=0   
  AND Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
  
  
  
  
--AND bpregMaster.Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
END  
  
 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetSubBrokerOnBoardingList_tobedeleted09jan2026
-- --------------------------------------------------
  
  
  
  
CREATE PROCEDURE [dbo].[pGetSubBrokerOnBoardingList]  
  
AS   
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SET NOCOUNT ON;  
   
 SELECT [ID]  
      ,[Regstatus]  
      ,[RegExchangeSegment]  
   ,[RecoverySegment06]  
      ,[SBTAG]  
      ,[PanNo]  
      ,[TagGeneratedDate]  
      ,[State]  
      ,[TotalGST]  
      ,[GSTValueType]  
      ,[SegmentFeeType]  
      ,[Amount]  
      ,[TotalAmount]  
      ,[RecoveredAmount]  
      ,[UnRecoveredAmount]  
      ,[isRecovered]  
  FROM [ProcessAutomation].[dbo].[OnBoardingList]  
  WHERE [isRecovered]=0   
  AND Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
  
  
  
  
--AND bpregMaster.Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
--In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
END  
  
 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetUnreconcilledRecords
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGetUnreconcilledRecords]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT M.[ID]
      ,[BillMonth]
      ,[BillYear]
      ,S.Name AS RegFrom
      ,[RegTo]
      ,[SBTAG]
      ,[RegDate]
      ,[SegmentFeeType]
      ,[Amount]
      ,[RecoveredAmount]
      ,[UnRecoveredAmount]
      ,[isRecovered]
      ,[RecoveredDate]
      ,[IsWriteOff]
	  ,[IsForceDebit]
      ,[isDuplicate]
  FROM [ProcessAutomation].[dbo].[MonthlyBillingData] M
   LEFT JOIN [dbo].[SegmentMasterSub] sub
   on M.RegTo=sub.AliasCode
  LEFT JOIN [dbo].[SegmentMaster] S
  on S.ID=sub.SegmentID


  WHERE [isDuplicate]=0 AND [isRecovered]=0  AND [IsWriteOff]=0 AND [IsForceDebit]=0

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGetUserDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[pGetUserDetails]  
  
@pusername nvarchar(10),  
@puserpassword nvarchar(10)  
AS   
BEGIN   
SET NOCOUNT ON;  
   
  
SELECT person_name,username,userpassword,usertype,active   
FROM INTRANET.[ROLEMGM].[dbo].[user_login]  
WHERE username=@pusername AND userpassword=@puserpassword  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGlCodeExist
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pGlCodeExist]
--=============================================
--Author:			<Author,,Supreeth>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

DELETE FROM GlCodeExist

INSERT INTO GlCodeExist (cltcode)
SELECT DISTINCT('05'+[SBTAG])
FROM [ProcessAutomation].[dbo].[MonthlyBillingData] M
WHERE RegDate= (SELECT TOP 1 RegDate FROM [ProcessAutomation].[dbo].[MonthlyBillingData] ORDER BY RegDate DESC)

INSERT INTO GlCodeExist (cltcode)
SELECT DISTINCT('06'+[SBTAG])
FROM [ProcessAutomation].[dbo].[MonthlyBillingData] M
WHERE RegDate= (SELECT TOP 1 RegDate FROM [ProcessAutomation].[dbo].[MonthlyBillingData] ORDER BY RegDate DESC)


SELECT cltcode FROM GlCodeExist;

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGSTMasterDataAll
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGSTMasterDataAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the all GSTMasterData Details>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT GST.ID,GST.GSTStateID,statemaster.StateName,statemaster.StateCode,GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC, GST.GSTValueType
FROM GSTMasterData GST
INNER JOIN StateMaster statemaster
ON statemaster.ID = GST.GSTStateID
WHERE GST.IsActive=1


  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGSTMasterDataById
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGSTMasterDataById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the GSTMasterData Details using ID>
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
SELECT GST.ID,GST.GSTStateID,statemaster.StateName,GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC, GST.GSTValueType 
FROM GSTMasterData GST 
INNER JOIN StateMaster statemaster 
ON statemaster.ID = GST.GSTStateID 
WHERE GST.ID= @pID

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGSTMasterDataDelete
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pGSTMasterDataDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,31/10/2019>
--Discription:		<Description,,Soft Delete for GSTMasterData using ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE GSTMasterData
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pGSTMasterDataInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pGSTMasterDataInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,31/10/2019>
--Discription:		<Description,,InsertAndUpdateGSTMasterDataDetails>
--=============================================
	@pCountry nvarchar(10),
	@pGSTStateID bigint,
	@pCGST_Code nvarchar(10),
	@pCGST decimal,
	@pUGST_Code nvarchar(10),
	@pUGST decimal,
	@pSGST_Code nvarchar(10),
	@pSGST decimal,
	@pIGST_Code nvarchar(10),
	@pIGST decimal,
	@pKFC_Code nvarchar(10),
	@pKFC decimal,
	@pGSTValueType nvarchar(10) ,
	@pIsActive bit,
	--@pCreatedOn datetime ,
	@pCreatedBy nvarchar(20) ,
	--@pUpdatedOn datetime ,
	@pUpdatedBy nvarchar(20) ,
	--@pDeletedOn datetime,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[GSTMasterData] 
WHERE ID=@pID
)
BEGIN
INSERT INTO GSTMasterData  (
	  Country,
      GSTStateID,
	  CGST_Code,
      CGST,
	  SGST_Code,
	  SGST,
	  UGST_Code,
	  UGST,
	  IGST_Code,
	  IGST,
	  KFC_Code,
	  KFC,
	  GSTValueType,
	  IsActive,
	  CreatedOn,
	  CreatedBy,
	  UpdatedOn,
	  UpdatedBy,
	  --DeletedOn,
	  --DeletedBy,
	  ServerIP
	)
    VALUES (
	@pCountry,
	@pGSTStateID,
	@pCGST_Code,
	@pCGST,
	@pSGST_Code,
	@pSGST,
	@pUGST_Code,
	@pUGST,
	@pIGST_Code,
	@pIGST,
	@pKFC_Code,
	@pKFC,
	@pGSTValueType,
	@pIsActive ,
	GETDATE()  ,
	@pCreatedBy,
	GETDATE() ,
	@pUpdatedBy,
	--@DeletedOn ,
	--@DeletedBy,
	@pServerIP
	 );
END

ELSE
BEGIN
UPDATE GSTMasterData
SET	Country=@pCountry,
	GSTStateID=@pGSTStateID,
	CGST_Code=@pCGST_Code,
	CGST=@pCGST,
	SGST_Code=@pSGST_Code,
	SGST=@pSGST,
	UGST_Code=@pUGST_Code,
	UGST=@pUGST,
	IGST_Code=@pIGST_Code,
	IGST=@pIGST,
	KFC_Code=@pKFC_Code,
	KFC=@pKFC,
	GSTValueType=@pGSTValueType,
	IsActive=@pIsActive,
	--CreatedOn=@CreatedOn,
	--CreatedBy=@CreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedOn=@DeletedOn,
	--DeletedBy=@DeletedBy,
	ServerIP=@pServerIP
WHERE  ID = @pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pInsertBillTriggerLog
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pInsertBillTriggerLog]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pProceessedDate datetime,
	@pStatus nvarchar(55),
	@pTotalRecords decimal(18,0),
	@pRecovered decimal(18,0),
	@pPartialRecovered decimal(18,0),
	@pUnRecovered decimal(18,0),
	@pDetails nvarchar(MAX),
	@pRemarks nvarchar(MAX),
	@pForceDebit decimal(18,0),
	@pForceWriteoff decimal(18,0)
AS

BEGIN
SET NOCOUNT ON;

INSERT INTO [MonthlyTriggerLog]  (
	   [ProceessedDate]
      ,[Status]
      ,[TotalRecords]
      ,[Recovered]
      ,[PartialRecovered]
	  ,[UnRecovered]
      ,[Details]
      ,[Remarks]
      ,[ForceDebit]
      ,[ForceWriteoff]
	)
VALUES (
	@pProceessedDate,
	@pStatus,
	@pTotalRecords,
	@pRecovered,
	@pPartialRecovered,
	@pUnRecovered,
	@pDetails,
	@pRemarks,
	@pForceDebit,
	@pForceWriteoff
	 );

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pInsertDailyTriggerLog
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pInsertDailyTriggerLog]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pProceessedDate datetime,
	@pStatus nvarchar(20),
	@pTotalRecords decimal(18,0),
	@pRecovered decimal(18,0),
	@pPartialRecovered decimal(18,0),
	@pUnRecovered decimal(18,0),
	@pDetails nvarchar(100),
	@pRemarks nvarchar(100),
	@pIsRescheduled bit,
	@pRescheduledDate datetime
AS

BEGIN
SET NOCOUNT ON;

INSERT INTO DailyTriggerLog  (
	   [ProceessedDate]
      ,[Status]
      ,[TotalRecords]
      ,[Recovered]
      ,[PartialRecovered]
	  ,[UnRecovered]
      ,[Details]
      ,[Remarks]
      ,[IsRescheduled]
      ,[RescheduledDate]
	)
VALUES (
	@pProceessedDate,
	@pStatus,
	@pTotalRecords,
	@pRecovered,
	@pPartialRecovered,
	@pUnRecovered,
	@pDetails,
	@pRemarks,
	@pIsRescheduled,
	@pRescheduledDate
	 );

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pLogsCreate
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================


CREATE PROCEDURE [dbo].[pLogsCreate]

	@LogType nvarchar(20),
	@LogDescription nvarchar(20),
	@LogDatabase nvarchar(20),
	@LogTable nvarchar(20),
	@Operation nvarchar(20),
	@Queries nvarchar(20),
	@LoggedOn datetime,
	@LoggedBy nvarchar(20),
	@ID bigint
	 
AS
BEGIN
INSERT INTO pLogsCreate  (
	LogType,
	LogDescription,
	LogDatabase,
	LogTable,
	Operation,
	Queries,
	LoggedOn,
	LoggedBy
	)
    VALUES (
	@LogType,
	@LogDescription,
	@LogDatabase,
	@LogTable,
	@Operation,
	@Queries,
	@LoggedOn,
	@LoggedBy
	 );
 
SET @ID = SCOPE_IDENTITY();
 
SELECT 
	LogType=@LogType,
	LogDescription=@LogDescription,
	LogDatabase=@LogDatabase,
	LogTable=@LogTable,
	Operation=@Operation,
	Queries=@Queries,
	LoggedOn=@LoggedOn,
	LoggedBy=@LoggedBy


FROM Logs
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pLogsDelete
-- --------------------------------------------------
CREATE PROC [dbo].[pLogsDelete] 
    @ID bigint
AS 
BEGIN 
DELETE
FROM   Logs
WHERE  ID = @ID
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pLogsRead
-- --------------------------------------------------
CREATE PROC pLogsRead
    @ID int
AS 
BEGIN 
 
 SELECT ID, LogType, LogDescription, LogDatabase, LogTable,Operation,Queries,LoggedOn,LoggedBy
    FROM   Logs  
    WHERE  (ID = @ID)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pLogsUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[pLogsUpdate]
	@ID bigint,
	@LogType nvarchar(20),
	@LogDescription nvarchar(20),
	@LogDatabase nvarchar(20),
	@LogTable nvarchar(20),
	@Operation nvarchar(20),
	@Queries nvarchar(20),
	@LoggedOn datetime,
	@LoggedBy nvarchar(20)
  
AS 
BEGIN 
 
UPDATE Logs

SET	LogType=@LogType,
	LogDescription=@LogDescription,
	LogDatabase=@LogDatabase,
	LogTable=@LogTable,
	Operation=@Operation,
	Queries=@Queries,
	LoggedOn=@LoggedOn,
	LoggedBy=@LoggedBy

WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMailLogCreate
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================


CREATE PROCEDURE [dbo].[pMailLogCreate]

	@MailObject nvarchar(10),
	@MailFrom nvarchar(30),
	@MailTo nvarchar(30),
	@CC nvarchar(30),
	@BCC nvarchar(30) ,
	@MailSubject nvarchar(30),
	@MailBody nvarchar(100),
	@MailDate datetime,
	@MailStatus bit,
	@MailProfile nvarchar(10),
	@ID bigint
	 
AS
BEGIN
INSERT INTO pMailLogCreate  (
	MailObject,
	MailFrom,
	MailTo,
	CC,
	BCC,
	MailSubject,
	MailBody,
	MailDate,
	MailStatus,
	MailProfile
	)
    VALUES (
	@MailObject,
	@MailFrom,
	@MailTo,
	@CC,
	@BCC,
	@MailSubject,
	@MailBody,
	@MailDate,
	@MailStatus,
	@MailProfile
	 );
 
SET @ID = SCOPE_IDENTITY();
 
SELECT 
	MailObject=@MailObject,
	MailFrom=@MailFrom,
	MailTo=@MailTo,
	CC=@CC,
	BCC=@BCC,
	MailSubject=@MailSubject,
	MailBody=@MailBody,
	MailDate=@MailDate,
	MailStatus=@MailStatus,
	MailProfile=@MailProfile


FROM MailLog
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMailLogDelete
-- --------------------------------------------------
CREATE PROC [dbo].[pMailLogDelete] 
    @ID bigint
AS 
BEGIN 
DELETE
FROM   MailLog
WHERE  ID = @ID
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMailLogRead
-- --------------------------------------------------
CREATE PROC pMailLogRead
    @ID int
AS 
BEGIN 
 
 SELECT ID, MailObject, MailFrom, MailTo, CC,BCC,MailSubject,MailBody,MailDate,MailStatus,MailProfile
    FROM   MailLog  
    WHERE  (ID = @ID)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMailLogUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[pMailLogUpdate]
	@ID bigint,
	@MailObject nvarchar(10),
	@MailFrom nvarchar(30),
	@MailTo nvarchar(30),
	@CC nvarchar(30),
	@BCC nvarchar(30) ,
	@MailSubject nvarchar(30),
	@MailBody nvarchar(100),
	@MailDate datetime,
	@MailStatus bit,
	@MailProfile nvarchar(10)
  
AS 
BEGIN 
 
UPDATE MailLog

SET	MailObject=@MailObject,
	MailFrom=@MailFrom,
	MailTo=@MailTo,
	CC=@CC,
	BCC=@BCC,
	MailSubject=@MailSubject,
	MailBody=@MailBody,
	MailDate=@MailDate,
	MailStatus=@MailStatus,
	MailProfile=@MailProfile

WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDataAll
-- --------------------------------------------------





CREATE PROCEDURE [dbo].[pMonthlyBillingDataAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for MonthlyBillingData>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;

SELECT RegDate AS REGISTRATION_DATE,RegFrom AS REGISTRATION_FROM,RegTo AS REGISTRATION_TO,SBTag AS SBTAG,Amount AS AMOUNT,SegmentFeeType AS NATURE 
FROM MonthlyBillingData
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDataInsert
-- --------------------------------------------------





CREATE PROCEDURE [dbo].[pMonthlyBillingDataInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for MonthlyBillingData>
--=============================================
			@pRegFrom nvarchar(30),
			@pRegTo nvarchar(30) ,
			@pSBTAG nvarchar(30) ,
			--@pPanNo nvarchar(30) ,
			@pRegDate datetime ,
			--@pRegState nvarchar(20),
			@pSegmentFeeType nvarchar(20) ,
			@pStateCode nvarchar(5) ,
			@pAmount decimal(18, 0) ,
			@pTotalGST decimal(18, 0) ,
			@pGSTAmount decimal(18, 0),
			@pTotalAmount  decimal(18, 0),
			--@pRecoveredAmount decimal(18, 0) ,
			--@pUnRecoveredAmount decimal(18, 0),
			--@pisRecovered bit,
			--@pRecoveredDate datetime,
			--@pIsWriteOff bit,
			--@pCreatedDate datetime,
			--@pID bigint
			@IsInserted BIT OUTPUT

		
			

	
AS
BEGIN
SET NOCOUNT ON;

--IF not exists 
--(
--SELECT @pID FROM [dbo].[BSE_Master] 
--WHERE ID=@pID
--)
BEGIN
SET @IsInserted = 1
	IF (SELECT COUNT(*) FROM MonthlyBillingData 
	WHERE RegFrom=@pRegFrom AND RegTo=@pRegTo  AND SBTAG=@pSBTAG  AND BillMonth=MONTH(@pRegDate) AND BillYear= YEAR(@pRegDate))>0
	BEGIN
		SET @IsInserted = 0
		UPDATE MonthlyBillingData set isDuplicate=1
		WHERE RegFrom=@pRegFrom AND RegTo=@pRegTo AND SBTAG=@pSBTAG  AND BillMonth=MONTH(@pRegDate) AND BillYear= YEAR(@pRegDate)
		RETURN;
	END
INSERT INTO MonthlyBillingData  (
			RegFrom,
			RegTo,
			SBTAG,
			--PanNo,
			RegDate ,
			BillMonth,
			BillYear,
			--RegState ,
			--GST ,
			--GSTAmount,
			StateCode,
			SegmentFeeType,
			Amount,
			TotalGST,
			GSTAmount,
			TotalAmount,
			RecoveredAmount,
			UnRecoveredAmount,
			isRecovered ,
			IsWriteOff,
			IsForceDebit,
			--RecoveredDate ,
			--IsWriteOff  ,
			--CreatedDate
			CreatedOn,
			isDuplicate
	)
VALUES (
			@pRegFrom,
			@pRegTo ,
			@pSBTAG,
			--@pPanNo,
			@pRegDate ,
			MONTH(@pRegDate),
			YEAR(@pRegDate),
			--@pRegState,
			--@pGST  ,
			--@pGSTAmount,
			--@pGSTValueType,
			@pStateCode,
			@pSegmentFeeType ,
			@pAmount,
			@pTotalGST,
			@pGSTAmount,
			@pTotalAmount,
			0 ,
			@pTotalAmount ,
			0,
			0,
			0,
			--@pRecoveredDate ,
			--@pIsWriteOff ,
			Getdate(),
			0 

	 );
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDetailsCreate
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================


CREATE PROCEDURE [dbo].[pMonthlyBillingDetailsCreate]
	    @ExchangeName nvarchar(10),
		@SegmentName	nvarchar(10),
		@SubBrokerName	nvarchar(10),
		@SubBrokerID	nvarchar(5),
		@Amount	decimal,
		@GST	decimal,
		@BillingID	nvarchar(30),
		@BillDate	datetime,
		@BillMonth	int,
		@BillYear	int,
		@CreatedBy	nvarchar(30),
		@CreatedOn	datetime,
		@UpatedBy	nvarchar(30),
		@Updatedon	datetime,
		@BillingStatus nvarchar(10),
		@UnreconcilledType	bit,
		@IsForceDebit	bit,
		@IsForceWriteOff bit,
		@ID bigint
	 
AS
BEGIN
INSERT INTO MonthlyBillingDetailsCreate  (
	    ExchangeName,
		SegmentName,
		SubBrokerName,
		SubBrokerID,
		Amount,
		GST,
		BillingID,
		BillDate,
		BillMonth,
		BillYear,
		CreatedBy,
		CreatedOn,
		UpatedBy,
		UpdatedOn,
		BillingStatus,
		UnreconcilledType,
		IsForceDebit,
		IsForceWriteOff)
    VALUES (
	    @ExchangeName,
		@SegmentName,
		@SubBrokerName,
		@SubBrokerID,
		@Amount,
		@GST,
		@BillingID,
		@BillDate,
		@BillMonth,
		@BillYear,
		@CreatedBy,
		@CreatedOn,
		@UpatedBy,
		@Updatedon,
		@BillingStatus,
		@UnreconcilledType,
		@IsForceDebit,
		@IsForceWriteOff);
 
SET @ID = SCOPE_IDENTITY();
 
SELECT 
	    ExchangeName= @ExchangeName,
		SegmentName=@SegmentName,
		SubBrokerName=@SubBrokerName,
		SubBrokerID=@SubBrokerID,
		Amount=@Amount,
		GST=@GST,
		BillingID=@BillingID,
		BillDate=@BillDate,
		BillMonth=@BillMonth,
		BillYear=@BillYear,
		CreatedBy=@CreatedBy,
		CreatedOn=@CreatedOn,
		UpatedBy=@UpatedBy,
		UpdatedOn=@Updatedon,
		BillingStatus=@BillingStatus,
		UnreconcilledType=@UnreconcilledType,
		IsForceDebit=@IsForceDebit,
		IsForceWriteOff=@IsForceWriteOff

FROM MonthlyBillingDetails 
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDetailsDelete
-- --------------------------------------------------
CREATE PROC [dbo].[pMonthlyBillingDetailsDelete] 
    @ID bigint
AS 
BEGIN 
DELETE
FROM   MonthlyBillingDetails
WHERE  ID = @ID
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDetailsRead
-- --------------------------------------------------
CREATE PROC pMonthlyBillingDetailsRead
    @ID int
AS 
BEGIN 
 
 SELECT ID, ExchangeName, SegmentName, SubBrokerName, SubBrokerID, Amount, GST, BillingID, BillDate, BillMonth, BillYear, CreatedBy, CreatedOn, UpatedBy, UpdatedOn, BillingStatus, UnreconcilledType, IsForceDebit, IsForceWriteOff
    FROM   MonthlyBillingDetails  
    WHERE  (ID = @ID)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyBillingDetailsUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[pMonthlyBillingDetailsUpdate]
		@ID bigint,
		@ExchangeName nvarchar(10),
		@SegmentName	nvarchar(10),
		@SubBrokerName	nvarchar(10),
		@SubBrokerID	nvarchar(5),
		@Amount	decimal,
		@GST	decimal,
		@BillingID	nvarchar(30),
		@BillDate	datetime,
		@BillMonth	int,
		@BillYear	int,
		@CreatedBy	nvarchar(30),
		@CreatedOn	datetime,
		@UpatedBy	nvarchar(30),
		@Updatedon	datetime,
		@BillingStatus nvarchar(10),
		@UnreconcilledType	bit,
		@IsForceDebit	bit,
		@IsForceWriteOff bit
  
AS 
BEGIN 
 
UPDATE MonthlyBillingDetails
SET  ExchangeName= @ExchangeName,
		SegmentName=@SegmentName,
		SubBrokerName=@SubBrokerName,
		SubBrokerID=@SubBrokerID,
		Amount=@Amount,
		GST=@GST,
		BillingID=@BillingID,
		BillDate=@BillDate,
		BillMonth=@BillMonth,
		BillYear=@BillYear,
		CreatedBy=@CreatedBy,
		CreatedOn=@CreatedOn,
		UpatedBy=@UpatedBy,
		UpdatedOn=@Updatedon,
		BillingStatus=@BillingStatus,
		UnreconcilledType=@UnreconcilledType,
		IsForceDebit=@IsForceDebit,
		IsForceWriteOff=@IsForceWriteOff
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyTriggerLogCreate
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================


CREATE PROCEDURE [dbo].[pMonthlyTriggerLogCreate]
	    @CreatedDate datetime,
		@MonthlyStatus nvarchar(10),
		@Details nvarchar(30),
		@Rescheduled bit,
		@ID bigint
	 
AS
BEGIN
INSERT INTO pMonthlyTriggerLogCreate  (
	    CreatedDate,
		MonthlyStatus,
		Details,
		Rescheduled
		)
    VALUES (
	    @CreatedDate,
		@MonthlyStatus,
		@Details,
		@Rescheduled);
 
SET @ID = SCOPE_IDENTITY();
 
SELECT 
	    CreatedDate= @CreatedDate,
		MonthlyStatus=@MonthlyStatus,
		Details=@Details,
		Rescheduled=@Rescheduled
		

FROM MonthlyTriggerLog 
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyTriggerLogDelete
-- --------------------------------------------------
CREATE PROC [dbo].[pMonthlyTriggerLogDelete] 
    @ID bigint
AS 
BEGIN 
DELETE
FROM   MonthlyTriggerLog
WHERE  ID = @ID
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyTriggerLogRead
-- --------------------------------------------------
CREATE PROC pMonthlyTriggerLogRead
    @ID int
AS 
BEGIN 
 
 SELECT ID, CreatedDate, MonthlyStatus, Details, Rescheduled
    FROM   MonthlyTriggerLog  
    WHERE  (ID = @ID)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMonthlyTriggerLogUpdate
-- --------------------------------------------------
CREATE PROC [dbo].[pMonthlyTriggerLogUpdate]
		@ID bigint,
		@CreatedDate datetime,
		@MonthlyStatus nvarchar(10),
		@Details nvarchar(30),
		@Rescheduled bit
  
AS 
BEGIN 
 
UPDATE MonthlyTriggerLog
SET		CreatedDate= @CreatedDate,
		MonthlyStatus=@MonthlyStatus,
		Details=@Details,
		Rescheduled=@Rescheduled
WHERE  ID = @ID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMoveV2LedgerToLive
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================



CREATE PROCEDURE [dbo].[pMoveV2LedgerToLive]
AS
BEGIN

INSERT INTO 
--[ProcessAutomation].[dbo].[V2_OfflineLedger]
[196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES
(VoucherType,BookType,sno,Vdate,Edate,CltCode,CreditAmt,DebitAmt,
Narration,Exchange,Segment,AddDt,ApprovalDate,UploadDt,AddBy,RowState,ApprovalFlag,voucherno,BranchName,BranchCode,StatusID,StatusName)
SELECT VoucherType,BookType,sno,Vdate,Edate,CltCode,CreditAmt,DebitAmt,
Narration,Exchange,Segment,AddDt,ApprovalDate,UploadDt,AddBy,RowState,ApprovalFlag,voucherno,BranchName,BranchCode,StatusID,StatusName 
FROM [ProcessAutomation].[dbo].[V2_OfflineLedger]
WHERE IsUpdatetoLive=0

UPDATE [ProcessAutomation].[dbo].[V2_OfflineLedger]
SET IsUpdatetoLive=1
WHERE IsUpdatetoLive=0

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pMoveV3LedgerToLive
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================



CREATE PROCEDURE [dbo].[pMoveV3LedgerToLive]
AS
BEGIN

INSERT INTO 
--[ProcessAutomation].[dbo].[V2_OfflineLedger]
[196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES
(VoucherType,BookType,sno,Vdate,Edate,CltCode,CreditAmt,DebitAmt,
Narration,Exchange,Segment,AddDt,ApprovalDate,UploadDt,AddBy,RowState,ApprovalFlag,voucherno,BranchName,BranchCode,StatusID,StatusName)
SELECT VoucherType,BookType,sno,Vdate,Edate,CltCode,CreditAmt,DebitAmt,
Narration,Exchange,Segment,AddDt,ApprovalDate,UploadDt,AddBy,RowState,ApprovalFlag,voucherno,BranchName,BranchCode,StatusID,StatusName 
FROM [ProcessAutomation].[dbo].[V3_OfflineLedger]
WHERE IsUpdatetoLive=0

UPDATE [ProcessAutomation].[dbo].[V3_OfflineLedger]
SET IsUpdatetoLive=1
WHERE IsUpdatetoLive=0

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pOnBoardingUpdate
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pOnBoardingUpdate]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pIsRecovered bit ,
	@pRecoveredAmount decimal ,
	@pUnRecoveredAmount decimal,
	@pRecoveredDate datetime,
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

UPDATE OnBoardingList
SET	
	IsRecovered=@pIsRecovered,
	RecoveredAmount=@pRecoveredAmount,
	UnRecoveredAmount=@pUnRecoveredAmount,
	RecoveredDate=@pRecoveredDate
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pPostJVEntry
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================



CREATE PROCEDURE [dbo].[pPostJVEntry]
	    @pVoucherType smallint,
		@pBookType	nvarchar(2),
		@pSNo int ,
		@pVdate datetime,
		@pEDate datetime,
		@pCltCode varchar(10),
		@pCreditAmt money,
		@pDebitAmt money,
		@pNarration varchar(255),
		@pExchange nvarchar(15),
		@pSegment nvarchar(15),
		@pAddDt datetime,
		@pAddBy nvarchar(15),
		@pStatusID nvarchar(15),
		@pStatusName nvarchar(15),
		@pRowState bit,
		@pApprovalFlag bit,
		@pVoucherNo nvarchar(12),
		@pBranchCode nvarchar(10),
		@pBranchName nvarchar(10),
		@pApprovalDate datetime,
		@pUploadDt datetime
	 
AS
BEGIN
INSERT INTO V2_OfflineLedger  (
	    VoucherType,
		BookType,
		SNo,
		Vdate,
		EDate,
		CltCode,
		CreditAmt,
		DebitAmt,
		Narration,
		Exchange,
		Segment,
		AddDt,
		AddBy,
		StatusID,
		StatusName,
		RowState,
		ApprovalFlag,
		VoucherNo,
		BranchCode,
		BranchName,
		ApprovalDate,
		UploadDt
		)
    VALUES (
	    @pVoucherType,
		@pBookType,
		@pSNo,
		@pVdate,
		@pEDate,
		@pCltCode,
		@pCreditAmt,
		@pDebitAmt,
		@pNarration,
		@pExchange,
		@pSegment,
		@pAddDt,
		@pAddBy,
		@pStatusID,
		@pStatusName,
		@pRowState,
		@pApprovalFlag,
		@pVoucherNo,
		@pBranchCode,
		@pBranchName,
		@pApprovalDate,
		@pUploadDt
		);

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pPostJVEntryRecovery
-- --------------------------------------------------

--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Discription,,>
--=============================================



CREATE PROCEDURE [dbo].[pPostJVEntryRecovery]
	    @pVoucherType smallint,
		@pBookType	nvarchar(2),
		@pSNo int ,
		@pVdate datetime,
		@pEDate datetime,
		@pCltCode varchar(10),
		@pCreditAmt money,
		@pDebitAmt money,
		@pNarration varchar(255),
		@pExchange nvarchar(15),
		@pSegment nvarchar(15),
		@pAddDt datetime,
		@pAddBy nvarchar(15),
		@pStatusID nvarchar(15),
		@pStatusName nvarchar(15),
		@pRowState bit,
		@pApprovalFlag bit,
		@pVoucherNo nvarchar(12),
		@pBranchCode nvarchar(10),
		@pBranchName nvarchar(10),
		@pApprovalDate datetime,
		@pUploadDt datetime
	 
AS
BEGIN
INSERT INTO V3_OfflineLedger  (
	    VoucherType,
		BookType,
		SNo,
		Vdate,
		EDate,
		CltCode,
		CreditAmt,
		DebitAmt,
		Narration,
		Exchange,
		Segment,
		AddDt,
		AddBy,
		StatusID,
		StatusName,
		RowState,
		ApprovalFlag,
		VoucherNo,
		BranchCode,
		BranchName,
		ApprovalDate,
		UploadDt,
		IsUpdatetoLive
		)
    VALUES (
	    @pVoucherType,
		@pBookType,
		@pSNo,
		@pVdate,
		@pEDate,
		@pCltCode,
		@pCreditAmt,
		@pDebitAmt,
		@pNarration,
		@pExchange,
		@pSegment,
		@pAddDt,
		@pAddBy,
		@pStatusID,
		@pStatusName,
		@pRowState,
		@pApprovalFlag,
		@pVoucherNo,
		@pBranchCode,
		@pBranchName,
		@pApprovalDate,
		@pUploadDt,
		0
		);

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBRegistrationFeeMasterDelete
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pSBRegistrationFeeMasterDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for SBRegistrationFeeMaster based on ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE SBRegistrationFeeMaster 
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBRegistrationFeesMasterAll
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pSBRegistrationFeesMasterAll]
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the all SBRegistrationFeesMaster Details>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT FeeMaster.ID,FeeMaster.SegmentMasterRefNo,FeeMaster.SegmentFeeType,FeeMaster.Amount,FeeMaster.OtherCharges,FeeMaster.TotalAmount,Segment.Name AS SegmentName ,FeeMaster.GLCode ,Segment06.Name AS RecoverySegment06
FROM SBRegistrationFeeMaster FeeMaster
INNER JOIN SegmentMaster Segment
ON Segment.ID = FeeMaster.SegmentMasterRefNo
LEFT JOIN SegmentMaster Segment06
ON Segment06.ID = FeeMaster.RecoverySegment06
WHERE FeeMaster.IsActive=1
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBRegistrationFeesMasterById
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pSBRegistrationFeesMasterById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the SBRegistrationFeesMaster Details using ID >
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT FeeMaster.ID,FeeMaster.SegmentMasterRefNo,FeeMaster.SegmentFeeType,FeeMaster.Amount,FeeMaster.IsActive,
FeeMaster.OtherCharges,FeeMaster.TotalAmount,Segment.Code 
AS SegmentCode,FeeMaster.GLCode ,FeeMaster.RecoverySegment06
FROM SBRegistrationFeeMaster FeeMaster
INNER JOIN SegmentMaster Segment 
ON Segment.ID = FeeMaster.SegmentMasterRefNo
WHERE FeeMaster.ID= @pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSBRegistrationFeesMasterInsert
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pSBRegistrationFeesMasterInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for SBRegistrationFeesMaster>
--=============================================
	@pSegmentMasterRefNo bigint,
	@pExchangeMasterRefNo bigint,
	@pSegmentFeeType nvarchar(20),
	@pAmount decimal,
	@pGLCode nvarchar(15),
	@pRecoverySegment06 nvarchar(15),
	--@pGSTAmount decimal,
	@pOtherCharges decimal,
	@pTotalAmount decimal,
	@pIsActive bit,
	--@pCpreatedOn datetime,
	@pCreatedBy nvarchar(20),
	--@pUpdatedOn datetime,
	@pUpdatedBy nvarchar(20),
	--@pDeletedOn datetime,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[SBRegistrationFeeMaster] 
WHERE ID=@pID
)
BEGIN
INSERT INTO SBRegistrationFeeMaster  (
	SegmentMasterRefNo,
	ExchangeMasterRefNo,
	SegmentFeeType,
	Amount,
	GLCode,
	RecoverySegment06,
	--GSTAmount,
	OtherCharges,
	TotalAmount,
	IsActive,
	CreatedOn,
	CreatedBy,
	UpdatedOn,
	UpdatedBy,
	--DeletedOn,
	--DeletedBy,
	ServerIP
	)
VALUES (
	@pSegmentMasterRefNo,
	@pExchangeMasterRefNo,
	@pSegmentFeeType,
	@pAmount,
	@pGLCode,
	@pRecoverySegment06,
	--@pGSTAmount,
	@pOtherCharges,
	@pTotalAmount,
	@pIsActive,
	GETDATE(),
	@pCreatedBy,
	GETDATE(),
	@pUpdatedBy,
	--@DeletedOn,
	--@DeletedBy,
	@pServerIP
	 );
END

ELSE
BEGIN
UPDATE SBRegistrationFeeMaster
SET	SegmentMasterRefNo=@pSegmentMasterRefNo,
	ExchangeMasterRefNo=@pExchangeMasterRefNo,
	SegmentFeeType=@pSegmentFeeType,
	Amount=@pAmount,
	GLCode=@pGLCode,
	RecoverySegment06=@pRecoverySegment06,
	--GST=@pGST,
	--GSTAmount=@pGSTAmount,
	OtherCharges=@pOtherCharges,
	TotalAmount=@pTotalAmount,
	IsActive=@pIsActive,
	--CreatedOn=GETDATE(),
	--CreatedBy=@pCreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedOn=GETDATE(),
	--DeletedBy=@pDeletedBy,
	ServerIP=@pServerIP
	
WHERE ID=@pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSegmenMasterDelete
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pSegmenMasterDelete]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Soft Delete for SegmentMaster using ID>
--=============================================

@pID bigint,
--@pUpdatedOn datetime ,
@pUpdatedBy nvarchar(20),
--@pDeletedOn datetime,
@pDeletedBy nvarchar(20)
AS
BEGIN
SET NOCOUNT ON

/*DELETE [dbo].ControlAccountMaster WHERE ID=@ID*/
UPDATE SegmentMaster
SET IsActive=0,
UpdatedOn=GETDATE(),
UpdatedBy=@pUpdatedBy,
DeletedOn=GETDATE(),
DeletedBy=@pDeletedBy 

WHERE ID=@pID;
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSegmentMasterAll
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[pSegmentMasterAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the all SegmentMaster Details>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT Segment.ID,Segment.Name,Segment.Code,Segment.ExchangeMasterRefNo,Exchange.Name 
AS ExchangeMasterName
FROM SegmentMaster Segment
INNER JOIN ExchangeMaster Exchange
ON Exchange.ID = Segment.ExchangeMasterRefNo
WHERE Segment.IsActive=1  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSegmentMasterById
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pSegmentMasterById]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Get the SegmentMaster Details using ID >
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT Segment.ID,Segment.Name,Segment.Code,Segment.ExchangeMasterRefNo,Segment.IsActive,Exchange.Name 
AS ExchangeMasterName
FROM SegmentMaster Segment
INNER JOIN ExchangeMaster Exchange
ON Exchange.ID = Segment.ExchangeMasterRefNo
WHERE Segment.ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSegmentMasterInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pSegmentMasterInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for SegmentMaster>
--=============================================
	@pName nvarchar(50) ,
	@pCode nvarchar(5) ,
	@pExchangeMasterRefNo bigint,
	@pIsActive bit ,
	--@pCreatedOn datetime,
	@pCreatedBy nvarchar(20),
	--@pUpdatedOn datetime,
	@pUpdatedBy nvarchar(20),
	--@pDeletedOn datetime ,
	--@pDeletedBy nvarchar(20),
	@pServerIP varchar(10),
	@pID bigint
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[SegmentMaster] 
WHERE ID=@pID
)
BEGIN
INSERT INTO SegmentMaster  (
	Name,
	Code,
	ExchangeMasterRefNo,
	IsActive,
	CreatedOn, 
	CreatedBy,
	UpdatedOn,
	UpdatedBy,
	--DeletedOn,
	--DeletedBy,
	ServerIP
	)
VALUES (
	@pName,
	@pCode,
	@pExchangeMasterRefNo,
	@pIsActive,
	GETDATE(), 
	@pCreatedBy,
	GETDATE(),
	@pUpdatedBy,
	--null,
	--null,
	@pServerIP
	 );
END

ELSE
BEGIN
UPDATE SegmentMaster
SET	Name=@pName,
	Code=@pCode,
	ExchangeMasterRefNo=@pExchangeMasterRefNo,
	IsActive=@pIsActive,
	--CreatedOn=@pCreatedOn,
	--CreatedBy=@pCreatedBy,
	UpdatedOn=GETDATE(),
	UpdatedBy=@pUpdatedBy,
	--DeletedBy=@pDeletedBy
	--DeletedOn=@pDeletedOn,
	ServerIP=@pServerIP
	
WHERE ID=@pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSegmentNotFoundRecords
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pSegmentNotFoundRecords]
--=============================================
--Author:			<Author,,Supreeth>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
SELECT DISTINCT([RegTo]),[SBTAG]
FROM [ProcessAutomation].[dbo].[MonthlyBillingData] M
WHERE RegDate= (SELECT TOP 1 RegDate FROM [ProcessAutomation].[dbo].[MonthlyBillingData] ORDER BY RegDate DESC)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterAll
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateMasterAll]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,StateName,StateCode
FROM StateMaster 
WHERE ID 
NOT IN (
SELECT GSTStateID 
FROM GSTMasterData
)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterEdit
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateMasterEdit]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,StateName,StateCode
FROM StateMaster 
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterNoFilter
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateMasterNoFilter]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,StateName,StateCode
FROM StateMaster 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterSub
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateMasterSub]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT sub.ID,StateId,smaster.StateName,AliasName
FROM StateMasterSub sub
INNER JOIN StateMaster smaster
ON smaster.ID=sub.StateId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterSubEdit
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateMasterSubEdit]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
@pID bigint
AS 
BEGIN 
SET NOCOUNT ON;
 
SELECT ID,StateId,AliasName
FROM StateMasterSub 
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateMasterSubInsert
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pStateMasterSubInsert]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,31/10/2019>
--Discription:		<Description,,InsertAndUpdateGSTMasterDataDetails>
--=============================================
	@pStateId nvarchar(10),
	@pAliasName nvarchar(30),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

IF not exists 
(
SELECT @pID FROM [dbo].[StateMasterSub] 
WHERE ID=@pID
)
BEGIN
INSERT INTO StateMasterSub(
		[StateId]
      ,[AliasName]
	)
    VALUES (
	@pStateId,
	@pAliasName
	 );
END

ELSE
BEGIN
UPDATE StateMasterSub
SET	[StateId]=@pStateId,
	[AliasName]=@pAliasName
	
WHERE  ID = @pID
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pStateNotFoundGST
-- --------------------------------------------------




CREATE PROCEDURE [dbo].[pStateNotFoundGST]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
			
AS
BEGIN
SET NOCOUNT ON;
SELECT (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST
FROM GSTMasterData GST
INNER JOIN StateMaster statemaster
ON statemaster.ID = GST.GSTStateID
WHERE GST.IsActive=1 AND statemaster.StateName='OTHER'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSubBrokerTagGeneratedList_06Nov2025
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pSubBrokerTagGeneratedList_06Nov2025]  
  
AS   
BEGIN   
SET NOCOUNT ON;  
 INSERT INTO [dbo].[OnBoardingList]     
  SELECT  
   sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment AS Code,  
   bpregMaster.Regstatus,  
   bpregMaster.RegExchangeSegment,  
   sbbroker.SBTAG,  
   sbbroker.PanNo,  
   sbbroker.TagGeneratedDate,  
   contact.State,  
   GSTMaster.TotalGST,  
   GSTMaster.GSTValueType,  
   --FeesMaster.SegmentCode,  
   FeesMaster.SegmentFeeType,  
   FeesMaster.Amount,  
   CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
    THEN (FeesMaster.Amount+((FeesMaster.Amount*GSTMaster.TotalGST)/100))   
    ELSE (FeesMaster.Amount+GSTMaster.TotalGST)   
   END) AS TotalAmount,  
   0 AS RecoveredAmount,  
   CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
    THEN (FeesMaster.Amount+((FeesMaster.Amount*GSTMaster.TotalGST)/100))   
    ELSE (FeesMaster.Amount+GSTMaster.TotalGST)   
   END) AS UnRecoveredAmount,  
   0 as isRecovered,  
   NULL as RecoveredDate,  
   RecoverySegment06  
  FROM SB_COMP.[dbo].[SB_Broker] sbbroker  
  INNER JOIN SB_COMP.[dbo].[bpregMaster] bpregMaster  
  ON bpregMaster.RegTAG=sbbroker.SBTAG  
  LEFT JOIN (  
     --SELECT RefNo, State,AddType   
     --FROM  [SB_COMP].[dbo].[SB_Contact]  
     --WHERE AddType ='RES'  
     --GROUP BY RefNo,State,AddType  
     SELECT S.RefNo,S.State,S.AddType  
     FROM (SELECT T.*,RANK() OVER (PARTITION BY T.RefNo ORDER BY T.AddType DESC ) AS rank  
         FROM [SB_COMP].[dbo].[SB_Contact] T WHERE T.AddType IN ('RES', 'OFF')  ) S  
      WHERE S.rank = 1   
      GROUP BY S.RefNo,S.State,S.AddType  
      ) AS contact  
  ON contact.[RefNo]=sbbroker.[RefNo]  
  LEFT JOIN (  
     --SELECT statemaster.StateName AS StateName,(GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     --FROM GSTMasterData GST  
     --INNER JOIN StateMaster statemaster  
     --ON statemaster.ID = GST.GSTStateID  
     --WHERE GST.IsActive=1  
     SELECT statemaster.StateName AS StateName,statemaster.StateCode AS StateCode,  
     GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
     (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     FROM GSTMasterData GST  
     INNER JOIN StateMaster statemaster  
     ON statemaster.ID = GST.GSTStateID  
     WHERE GST.IsActive=1  
  
     UNION  
  
     SELECT SUB.AliasName AS StateName,statemaster.StateCode AS StateCode,  
     GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
     (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     FROM GSTMasterData GST  
     INNER JOIN StateMaster statemaster  
     ON statemaster.ID = GST.GSTStateID  
     INNER JOIN [dbo].[StateMasterSub] SUB  
     ON statemaster.ID = SUB.StateId  
     WHERE GST.IsActive=1  
    ) AS GSTMaster  
  ON GSTMaster.StateName=contact.State  
  LEFT JOIN (  
     SELECT SegmentSub.AliasCode AS SegmentCode,Segment.Code,FeeMaster.SegmentFeeType,FeeMaster.Amount,Segment1.Code AS RecoverySegment06  
     FROM SBRegistrationFeeMaster FeeMaster  
     INNER JOIN SegmentMaster Segment  
     ON Segment.ID = FeeMaster.SegmentMasterRefNo  
     INNER JOIN SegmentMaster Segment1  
     ON Segment1.ID = FeeMaster.RecoverySegment06  
     LEFT JOIN SegmentMasterSub SegmentSub  
     ON Segment.ID = SegmentSub.SegmentID  
     WHERE FeeMaster.IsActive=1  
     ) AS FeesMaster  
  ON FeesMaster.SegmentCode=bpregMaster.RegExchangeSegment AND FeesMaster.SegmentFeeType='Registration'  
  WHERE sbbroker.TagGeneratedDate >='2019-11-01'    
  --dateadd(day,datediff(day,20,GETDATE()),0)  
    AND sbbroker.TagGeneratedDate < dateadd(day,datediff(day,0,GETDATE()),0)  
  AND sbbroker.Branch NOT IN('OFRA','RFRL')  
  --AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX')  
  AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
AND NOT EXISTS(SELECT Code from [dbo].[OnBoardingList] o WHERE o.Code=sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment)  
  
  
--New Code  
SELECT * INTO #Temp FROM   
 (  
SELECT   
 bpregMaster.RegTAG+'-'+bpregMaster.RegExchangeSegment as Code1,  
 Code,  
 bpregMaster.Regstatus  
FROM SB_COMP.[dbo].[bpregMaster] bpregMaster  
LEFT JOIN (  
SELECT  Code,Regstatus  
  FROM [ProcessAutomation].[dbo].[OnBoardingList]  
  WHERE  
  isRecovered=0   
) onboard  
on code=bpregMaster.RegTAG+'-'+bpregMaster.RegExchangeSegment  
WHERE   
bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
AND bpregMaster.Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
AND bpregMaster.Regstatus!=onboard.Regstatus  
)data  
  
update onboardinglist set Regstatus=(select top 1 t.Regstatus from #Temp t where t.Code=Code)  
Where Code in (select code from #Temp )  
  
drop table #Temp  
  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSubBrokerTagGeneratedList_tobedeleted09jan2026
-- --------------------------------------------------
  
  
CREATE PROCEDURE [dbo].[pSubBrokerTagGeneratedList]  
  
AS   
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SET NOCOUNT ON;  
 INSERT INTO [dbo].[OnBoardingList]     
  SELECT  
   sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment AS Code,  
   bpregMaster.Regstatus,  
   bpregMaster.RegExchangeSegment,  
   sbbroker.SBTAG,  
   sbbroker.PanNo,  
   sbbroker.TagGeneratedDate,  
   contact.State,  
   GSTMaster.TotalGST,  
   GSTMaster.GSTValueType,  
   --FeesMaster.SegmentCode,  
   FeesMaster.SegmentFeeType,  
   FeesMaster.Amount,  
   CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
    THEN (FeesMaster.Amount+((FeesMaster.Amount*GSTMaster.TotalGST)/100))   
    ELSE (FeesMaster.Amount+GSTMaster.TotalGST)   
   END) AS TotalAmount,  
   0 AS RecoveredAmount,  
   CONVERT(DECIMAL(10,2), CASE WHEN GSTMaster.GSTValueType='Percentage'   
    THEN (FeesMaster.Amount+((FeesMaster.Amount*GSTMaster.TotalGST)/100))   
    ELSE (FeesMaster.Amount+GSTMaster.TotalGST)   
   END) AS UnRecoveredAmount,  
   0 as isRecovered,  
   NULL as RecoveredDate,  
   RecoverySegment06  
  FROM SB_COMP.[dbo].[SB_Broker] sbbroker  
  INNER JOIN SB_COMP.[dbo].[bpregMaster] bpregMaster  
  ON bpregMaster.RegTAG=sbbroker.SBTAG  
  LEFT JOIN (  
     --SELECT RefNo, State,AddType   
     --FROM  [SB_COMP].[dbo].[SB_Contact]  
     --WHERE AddType ='RES'  
     --GROUP BY RefNo,State,AddType  
     SELECT S.RefNo,S.State,S.AddType  
     FROM (SELECT T.*,RANK() OVER (PARTITION BY T.RefNo ORDER BY T.AddType DESC ) AS rank  
         FROM [SB_COMP].[dbo].[SB_Contact] T WHERE T.AddType IN ('RES', 'OFF')  ) S  
      WHERE S.rank = 1   
      GROUP BY S.RefNo,S.State,S.AddType  
      ) AS contact  
  ON contact.[RefNo]=sbbroker.[RefNo]  
  LEFT JOIN (  
     --SELECT statemaster.StateName AS StateName,(GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     --FROM GSTMasterData GST  
     --INNER JOIN StateMaster statemaster  
     --ON statemaster.ID = GST.GSTStateID  
     --WHERE GST.IsActive=1  
     SELECT statemaster.StateName AS StateName,statemaster.StateCode AS StateCode,  
     GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
     (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     FROM GSTMasterData GST  
     INNER JOIN StateMaster statemaster  
     ON statemaster.ID = GST.GSTStateID  
     WHERE GST.IsActive=1  
  
     UNION  
  
     SELECT SUB.AliasName AS StateName,statemaster.StateCode AS StateCode,  
     GST.CGST_Code,GST.CGST,GST.SGST_Code,GST.SGST,GST.UGST_Code,GST.UGST,GST.IGST_Code,GST.IGST,GST.KFC_Code,GST.KFC,  
     (GST.CGST+GST.SGST+GST.UGST+GST.IGST+GST.KFC) AS TotalGST, GST.GSTValueType  
     FROM GSTMasterData GST  
     INNER JOIN StateMaster statemaster  
     ON statemaster.ID = GST.GSTStateID  
     INNER JOIN [dbo].[StateMasterSub] SUB  
     ON statemaster.ID = SUB.StateId  
     WHERE GST.IsActive=1  
    ) AS GSTMaster  
  ON GSTMaster.StateName=contact.State  
  LEFT JOIN (  
     SELECT SegmentSub.AliasCode AS SegmentCode,Segment.Code,FeeMaster.SegmentFeeType,FeeMaster.Amount,Segment1.Code AS RecoverySegment06  
     FROM SBRegistrationFeeMaster FeeMaster  
     INNER JOIN SegmentMaster Segment  
     ON Segment.ID = FeeMaster.SegmentMasterRefNo  
     INNER JOIN SegmentMaster Segment1  
     ON Segment1.ID = FeeMaster.RecoverySegment06  
     LEFT JOIN SegmentMasterSub SegmentSub  
     ON Segment.ID = SegmentSub.SegmentID  
     WHERE FeeMaster.IsActive=1  
     ) AS FeesMaster  
  ON FeesMaster.SegmentCode=bpregMaster.RegExchangeSegment AND FeesMaster.SegmentFeeType='Registration'  
  WHERE sbbroker.TagGeneratedDate >='2019-11-01'    
  --dateadd(day,datediff(day,20,GETDATE()),0)  
    AND sbbroker.TagGeneratedDate < dateadd(day,datediff(day,0,GETDATE()),0)  
  AND sbbroker.Branch NOT IN('OFRA','RFRL')  
  --AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX')  
  AND bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
AND NOT EXISTS(SELECT Code from [dbo].[OnBoardingList] o WHERE o.Code=sbbroker.SBTAG+'-'+bpregMaster.RegExchangeSegment)  
  
  
--New Code  
SELECT * INTO #Temp FROM   
 (  
SELECT   
 bpregMaster.RegTAG+'-'+bpregMaster.RegExchangeSegment as Code1,  
 Code,  
 bpregMaster.Regstatus  
FROM SB_COMP.[dbo].[bpregMaster] bpregMaster  
LEFT JOIN (  
SELECT  Code,Regstatus  
  FROM [ProcessAutomation].[dbo].[OnBoardingList]  
  WHERE  
  isRecovered=0   
) onboard  
on code=bpregMaster.RegTAG+'-'+bpregMaster.RegExchangeSegment  
WHERE   
bpregMaster.RegExchangeSegment in('BICS','NICS','NIFA','NICF','MICX','NICX','BCCS','BLCS','BPCS','NCCS','NLCS','NPCS','MCCX','MLCX','MPCX','NCCX','NLCX','NPCX','NCFA','NLFA','NPFA','NCCF','NLCF','NPCF')  
AND bpregMaster.Regstatus IN ('returned to branch','Rejected By Exchange','Rejected by Exchange and Returned To Branch','Rejected by CSO','Resubmitted','   
In Process','Applied To Exchange','Registered','Query Raised BY SEBI','Rejected by CSO and Returned To Branch')  
AND bpregMaster.Regstatus!=onboard.Regstatus  
)data  
  
update onboardinglist set Regstatus=(select top 1 t.Regstatus from #Temp t where t.Code=Code)  
Where Code in (select code from #Temp )  
  
drop table #Temp  
  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pSystemLogs
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pSystemLogs]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================

	@pUserName nvarchar(20),
	@pUserID nvarchar(20),
	@IPAddress nvarchar(20),
	@LoginDate datetime,
	@pRemarks varchar(50)
AS

BEGIN
SET NOCOUNT ON;

INSERT INTO SystemLogs  (
	[UserName],
	[UserID],
	[IPAddress]  ,
	[LoginDate] ,
	[Remarks]
	)
VALUES (
	@pUserName,
	@pUserID,
	@IPAddress,
	@LoginDate,
	@pRemarks
	 );

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpateDuplicateBillingData
-- --------------------------------------------------



CREATE PROCEDURE [dbo].[pUpateDuplicateBillingData]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for SBRegistrationFeesMaster>
--=============================================
	@pSBTag nvarchar(15),
	@pRegistrationFrom nvarchar(15),
	@pRegistrationTo nvarchar(15),
	@pSegmentFeeType nvarchar(15),
	@pAmount decimal(18,0),
	@pTotalGST decimal(18, 0) ,
	@pGSTAmount decimal(18, 0),
	@pTotalAmount  decimal(18, 0),
	@pStateCode nvarchar(5),
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

UPDATE [dbo].[MonthlyBillingData]
   SET [RegFrom] = @pRegistrationFrom
      ,[RegTo] = @pRegistrationTo
      ,[SBTAG] = @pSBTag
      ,[Amount] = @pAmount
	  ,[SegmentFeeType]=@pSegmentFeeType
	  ,[TotalGST]=@pTotalGST
	  ,[GSTAmount]=@pGSTAmount
	  ,[TotalAmount]=@pTotalAmount
	  ,[StateCode]=@pStateCode
	  ,isDuplicate=0

 WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdateBillingList
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pUpdateBillingList]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pIsRecovered bit,
	@pRecoveredAmount decimal(18,4),
	@pUnRecoveredAmount decimal(18,4),
	@pRecoveredDate datetime,
	@pIsWriteOff bit,
	@pIsForceDebit bit,
	@pIsForceWriteoffRecovered bit,
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

UPDATE MonthlyBillingData
SET	
	IsRecovered=@pIsRecovered,
	RecoveredAmount=@pRecoveredAmount,
	UnRecoveredAmount=@pUnRecoveredAmount,
	RecoveredDate=@pRecoveredDate,
	IsWriteOff=@pIsWriteOff,
	IsForceDebit=@pIsForceDebit,
	IsForceWriteoffRecovered=@pIsForceWriteoffRecovered
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pUpdatePendingAmount
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[pUpdatePendingAmount]
--=============================================
--Author:			<Author,,Akidut>
--Created Date:		<Created Date,,23/10/2019>
--Discription:		<Description,,Insert and Update for AccountMaster>
--=============================================
	@pPendingAmount decimal(18,4) ,
	@pID bigint
	
AS
BEGIN
SET NOCOUNT ON;

UPDATE MonthlyBillingData
SET	
	PendingAmount=@pPendingAmount
WHERE ID=@pID
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Save_ClientSebiPayoutBlockUnblockDetails
-- --------------------------------------------------

CREATE PROCEDURE Save_ClientSebiPayoutBlockUnblockDetails  
(  
@ClientPanNo VARCHAR(10)='' , @CltCode VARCHAR(15)='',@ClientName VARCHAR(255)='',  
@BranchCode VARCHAR(30)='', @SBTag VARCHAR(15)='',  
@FileName VARCHAR(350)='', @Extension VARCHAR(10)=''              
,@BlockingTeam VARCHAR(15)='',@Remarks VARCHAR(MAX)='' ,@BlockedBy VARCHAR(20)=''  
)  
AS  
BEGIN   
--IF NOT EXISTS(SELECT * FROM tbl_ClientSebiPayoutBlockingDetails WHERE CltCode= @CltCode AND IsUnBlocked=1)  
--BEGIN  
INSERT INTO tbl_ClientSebiPayoutBlockingDetails   
VALUES(@ClientPanNo,@CltCode,@ClientName,@BranchCode,@SBTag,@Extension,@FileName,@BlockingTeam,Replace(@Remarks,char(13),''),GETDATE(),@BlockedBy,0,'','','','')  
--END       
  
  
--- Mailer Logic  
              
Declare @url varchar(500)=null;  
declare @subject nvarchar(500)=null,@body nvarchar(max)=null     
            
SELECT TOP 1   
@url='\\10.253.16.26\upload1\ClientPayoutBlockingUnBlockingDoc\'+@FileName+''        
               
  
set @subject='Client SEBI Payout Block - '+@CltCode+''  
  
set @body='<pre style="font-family:Calibri;font-size:medium"><strong>Dear All, </strong></pre> <br />  
  
<pre style="font-family:Calibri;font-size:medium">  
Action taken against SEBI Payout. <br />  
<strong>Client code :- </strong>'+@CltCode+'   
<strong>Type :- </strong> Blocked   
<strong>Reason/Remark :- </strong> '+Replace(@Remarks,char(13),'')+'   
Detail Report-Attached   
<br />  
   
<strong>  
Regards,    
SEBI Payout Team </strong>  
<pre>'  
             
             
----EXEC [INTRANET].MSDB.DBO.SP_SEND_DBMAIL     
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
@RECIPIENTS ='pmla.cso@angelbroking.com;jignesh@angelbroking.com;dhanesh.magodia@angelbroking.com;hemantp.patel@angelbroking.com;banking@angelbroking.com;santhosh.shastry@angelbroking.com;fdssupport@angelbroking.com;',
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com;',  
---@PROFILE_NAME ='GST invoice', -- intranet ,        
 @profile_name = 'AngelBroking',      
@BODY_FORMAT ='HTML',     
@SUBJECT =@subject ,  
--@copy_recipients='remisier@angelbroking.com',  
@BODY =@body,  
@file_attachments=@url;  
  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Save_SBPayoutDepositProcessDetailsInLMS
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[Save_SBPayoutDepositProcessDetailsInLMS]              
(              
@SBPanNo VARCHAR(15) , @SBName VARCHAR(255), @RefNo VARCHAR(35),@Amount Decimal(17,2),              
@FileName VARCHAR(100),@File Image=null , @Extension VARCHAR(10),@Remarks VARCHAR(255),  
@BDMEmailId VARCHAR(650)=''  
)              
AS              
BEGIN              
IF NOT EXISTS(SELECT * FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE SBPanNo=@SBPanNo AND RefNo=@RefNo)              
BEGIN              
DECLARE @DepositRefId bigint            
INSERT INTO tbl_SBPayoutDepositProcessDetailsInLMS               
VALUES(@SBPanNo,'',@SBName,LTRIM(RTRIM(@RefNo)),@Amount,@Extension,@FileName,@Remarks,GETDATE(),'Test',0,'',0,'',@BDMEmailId)   

SET @DepositRefId = SCOPE_IDENTITY()

INSERT INTO tbl_SBPayoutDepositProcessDocumentDetails
VALUES(@DepositRefId,@File,@FileName,@Extension)

        
SELECT SBPanNo,SBName,RefNo,Amount,Remarks        
,CONVERT(VARCHAR(10),CreatedOn,103) 'ProcessDate' INTO #TEMP         
FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE SBPanNo=@SBPanNo          
AND RefNo = @RefNo AND CAST(CreatedOn as date) = CAST(GETDATE() as date)        
               
DECLARE @xml NVARCHAR(MAX)          
DECLARE @body NVARCHAR(MAX)                     
DECLARE @Subject VARCHAR(MAX)= 'SB Deposit Process'                  
          
 SET @xml = CAST(( SELECT [SBName] AS 'td','', [SBPanNo] AS 'td' ,'', [RefNo] AS 'td'                    
 ,'', [Amount] AS 'td','', [Remarks] AS 'td' ,'', [ProcessDate] AS 'td'                       
FROM #TEMP                        
                        
--ORDER BY BalanceDate                        
                        
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                        
                        
SET @body ='<p style="font-size:medium; font-family:Calibri">                        
                        
 <b>Dear Team </b>,<br /><br />                        
                        
New Ref Payout details received from Client for SB process. <br />          
Request you to please verify the details and start Tag generation process from your side. <br />                          
Please find the Details which we received from clients.                  
                        
 </H2>                        
                        
<table border=1   cellpadding=2 cellspacing=2>                        
                        
<tr style="background-color:rgb(201, 76, 76); color :White">                        
                        
<th> SBName </th> <th> SBPanNo </th> <th> RefNo </th> <th> Amount </th> <th> Remarks </th>  <th> ProcessDate </th> '                        
                 
 SET @body = @body + @xml +'</table></body></html>                        
               
<br />Thanks & Regards,<br /><br />                
Angel One Ltd.  <br />              
System Generated Mail'                        
                        
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL 
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   
                        
@profile_name = 'AngelBroking',                        
                        
@body = @body,                        
                        
@body_format ='HTML',                        
                        
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',                        
@recipients = @BDMEmailId,                        
                        
@blind_copy_recipients ='sbregistration@angelbroking.com; suhas.raut@angelbroking.com',                        
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',                        
                        
@subject = @Subject ;          
        
END             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SaveAndDeleteInterSegmentControlLogData
-- --------------------------------------------------
CREATE Procedure [dbo].[SaveAndDeleteInterSegmentControlLogData]  
AS  
BEGIN  
IF EXISTS(SELECT * FROM tblInterSegmentJVCalculation WITH(NOLOCK))
BEGIN
 Insert into tblInterSegmentJVCalculationLogData(FromSegment ,FromCount,FromCode,FromAmount ,ToSegment ,ToCount ,ToCode ,ToAmount,CreatedDate, UpdationDate)  
 select FromSegment ,FromCount,FromCode,FromAmount ,ToSegment ,ToCount ,ToCode ,ToAmount,CreatedDate,GETDATE() from tblInterSegmentJVCalculation
   
 Delete From tblInterSegmentJVCalculation
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SaveAndDeleteInterSegmentLogData
-- --------------------------------------------------

CREATE Procedure [dbo].[SaveAndDeleteInterSegmentLogData]  
AS  
BEGIN  
IF EXISTS(Select * FROM tblInterSegmentJV WITH(NOLOCK))
BEGIN
 Insert into tblInterSegmentLogData(CLTCODE ,CreatedDate,UpdationDate,FromSegment,ToSegment ,FromAmount ,ToAmount ,Adjust ,Pending )  
 select CLTCODE,CreatedDate,GETDATE(),FromSegment,ToSegment,FromAmount,ToAmount,Adjust,Pending from tblInterSegmentJV
   
 Delete From tblInterSegmentJV
 END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SB_DEPOSITE_ACCURAL_BAL_REMISIER_tobedeleted09jan2026
-- --------------------------------------------------
CREATE PROC [dbo].[SB_DEPOSITE_ACCURAL_BAL_REMISIER]
@pSubtag nvarchar(MAX) 
AS
BEGIN




SELECT DISTINCT [sb tag] AS SBTAG,BSECM AS BICS,NSECM AS NICS,NSEFO AS NIFA,MCX AS MICX,NCDEX AS NICX,MCD AS MCD,NSX AS NICF,
ISNULL([Non Cash Deposit],0) AS NonCashDeposit,
ABL=ISNULL(ABL,0),ACBPL=ISNULL(ACBPL,0),
[Accruals]=ISNULL([Accruals],0),ISNULL([Accured Brokerage],0) AS AccuredBrokerage
FROM
(
SELECT [sb tag]=X.SB,
BSECM = ISNULL(BSECM,0),NSECM= ISNULL(NSECM,0),NSEFO= ISNULL(NSEFO,0),
MCX= ISNULL(MCX,0),NCDEX= ISNULL(NCDEX,0),
MCD= ISNULL(MCD,0),NSX= ISNULL(NSX,0)
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
(SELECT A.cltcode,
[BSECM]=CONVERT(VARCHAR(15), Sum(CASE WHEN segment='BSECM' THEN balance ELSE 0 END)/1),
NSECM= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSECM' THEN balance ELSE 0 END)/1),
NSEFO= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSEFO' THEN balance ELSE 0 END)/1),
MCX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='MCX' THEN balance ELSE 0 END)/1),
NCDEX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NCDEX' THEN balance ELSE 0 END)/1),
MCD= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='MCD' THEN balance ELSE 0 END)/1),
NSX= CONVERT(VARCHAR(15), Sum(CASE WHEN segment='NSX' THEN balance ELSE 0 END)/1),
TOTAL= CONVERT(DECIMAL(15, 2), Sum(balance) / 1)
FROM
(
select cltcode,'BSECM' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.bsecm_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSECM' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSECM_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSEFO' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSEFO_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'MCX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.MCX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NCDEX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NCDEX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'MCD' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.MCD_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
UNION
select cltcode,'NSX' segment,balance=sum(case when drcr='C' then vamt else -vamt end) from [196.1.115.182].general.dbo.NSX_ledger WITH(NOLOCK)
where cltcode like '05%'  group by cltcode
)A
WHERE A.cltcode in(SELECT DISTINCT SB = '05'+SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK))
GROUP BY A.cltcode
) Y ON X.SB=SUBSTRING(Y.cltcode,3,10)
) P
LEFT JOIN
(
--SELECT Sub_Broker ,[Non Cash Deposit]=CONVERT(DECIMAL(15, 2), Sum(SB_NonCashColl)),
--[Accured Brokerage]=CONVERT(DECIMAL(15, 2), Sum(SB_Brokerage))
--FROM   rms_dtsbfi a WITH (nolock)
--GROUP  BY a.sub_broker
SELECT X.SB,[Non Cash Deposit]=CONVERT(DECIMAL(18,2),ISNULL(SB_NonCashColl,0)),[Accured Brokerage]=CONVERT(DECIMAL(18,2),ISNULL(SB_Brokerage,0))
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
/*Modified on 26 AUG 2013 as per Sailesh Req.*/
--(SELECT SB,SUM(Remi_share) SB_Brokerage FROM Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) M
(SELECT B.SB,SB_Brokerage = ISNULL(A.SB_Brokerage,B.SB_Brokerage)
FROM(SELECT Sub_Broker SB ,SB_Brokerage=CONVERT(DECIMAL(15, 2), Sum(SB_Brokerage))
FROM   [196.1.115.182].general.dbo.rms_dtsbfi WITH (nolock)
GROUP  BY sub_broker) A
RIGHT JOIN (SELECT SB,SUM(Remi_share) SB_Brokerage FROM [196.1.115.182].general.dbo.Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) B
ON A.SB= B.SB
) M
ON X.SB = M.SB
LEFT JOIN
(SELECT SB,SUM(N.total_WithHC) SB_NonCashColl FROM [196.1.115.182].general.dbo.Vw_SB_NonCashCollateral N WITH(NOLOCK) GROUP BY SB) N
ON X.SB = N.SB
) Q
ON  P.[sb tag] = Q.SB
LEFT JOIN
(
SELECT sbcode,ABL,ACBPL,[Accruals]= CONVERT(DECIMAL(20, 2), unreg_tot)
FROM   [196.1.115.182].general.dbo.vw_sb_balance a WITH(NOLOCK)
--LEFT OUTER JOIN vw_rms_sb_vertical b WITH(NOLOCK) ON a.sbcode = b.sb
)R
ON  P.[sb tag] = R.SBCODE


--WHERE [Sb tag] IN (@pSubtag)

where [sb tag] IN (
SELECT CAST(Item AS NVARCHAR(MAX))
            FROM SplitString(@pSubtag, ',')
)
/*
SELECT X.SB,[Non Cash Deposit]=ISNULL(SB_NonCashColl,0),[Accured Brokerage]=ISNULL(SB_Brokerage,0)
FROM (SELECT DISTINCT SB = SBTAG FROM MIS.SB_COMP.DBO.SB_BROKER WITH(NOLOCK)) X
LEFT JOIN
(SELECT SB,SUM(Remi_share) SB_Brokerage FROM Vw_SB_AccruedBrokerage WITH(NOLOCK) GROUP BY SB) M
ON X.SB = M.SB
LEFT JOIN
(SELECT SB,SUM(N.total_WithHC) SB_NonCashColl FROM Vw_SB_NonCashCollateral N WITH(NOLOCK) GROUP BY SB) N
ON X.SB = N.SB
*/
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
-- PROCEDURE dbo.Update_SBDepositDetailsInLMSProcess
-- --------------------------------------------------

CREATE PROCEDURE Update_SBDepositDetailsInLMSProcess            
(            
@SBPanNo VARCHAR(15) , @SBName VARCHAR(255),@RefId bigint, @RefNo VARCHAR(35),@Amount Decimal(17,2),            
@Remarks VARCHAR(255)           
)            
AS            
BEGIN            
IF EXISTS(SELECT * FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE DepositRefId=@RefId)            
BEGIN            
DECLARE @SuspenceAccDetailsId bigint      
IF EXISTS(SELECT * FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE DepositRefId=@RefId AND IsBankingRejected=1)   
BEGIN  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET SBPanNo=@SBPanNo, SBName=@SBName, RefNo=@RefNo ,CreatedOn=GETDATE(),       
Amount=@Amount,Remarks=@Remarks,IsBankingRejected=2,BankingRejectionReason='' WHERE DepositRefId=@RefId    
  
SET @SuspenceAccDetailsId = (SELECT DISTINCT SuspenceAccDetailsId FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE DepositRefId=@RefId)  
  
DELETE FROM tbl_SBDepositBankingVarificationProcess WHERE IsBankingRejected=1 AND SuspenceAccDetailsId=@SuspenceAccDetailsId   
DELETE FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE DepositRefId=@RefId        
DELETE FROM tbl_SBDepositSuspenceAccountDetails WHERE SuspenceAccDetailsId=@SuspenceAccDetailsId   
  
END  
ELSE  
BEGIN  
  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET SBPanNo=@SBPanNo, SBName=@SBName, RefNo=@RefNo,CreatedOn=GETDATE() ,        
Amount=@Amount,Remarks=@Remarks,IsSBRejected=2,SBRejectionReason='' WHERE DepositRefId=@RefId    
  
UPDATE tbl_SBDepositVarificationAndProcessBySBTeam SET IsSBRejected=2, RejectionReason='Re Process'        
WHERE DepositRefId=@RefId    
END  

SELECT 
SBPanNo,SBName,RefNo,Amount,Remarks,CONVERT(VARCHAR(10),CreatedOn,103) 'ProcessDate' INTO #TEST
FROM tbl_SBPayoutDepositProcessDetailsInLMS WITH(NOLOCK) WHERE DepositRefId=@RefId  

       
DECLARE @xml NVARCHAR(MAX)  
DECLARE @body NVARCHAR(MAX)             
DECLARE @Subject VARCHAR(MAX)= 'SB Deposit Process'          
  
 SET @xml = CAST(( SELECT [SBName] AS 'td','', [SBPanNo] AS 'td' ,'', [RefNo] AS 'td'            
 ,'', [Amount] AS 'td','', [Remarks] AS 'td' ,'', [ProcessDate] AS 'td'               
FROM #TEST                
                
--ORDER BY BalanceDate                
                
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                
                
SET @body ='<p style="font-size:medium; font-family:Calibri">                
                
 <b>Dear Team </b>,<br /><br />                
                
We are update the Rejected Client Ref Payout details received from Client for SB process. <br />  
Request you to please verify the details and start Tag generation process from your side. <br />                  
Please find the Details which we received from clients.          
                
 </H2>                
                
<table border=1   cellpadding=2 cellspacing=2>                
                
<tr style="background-color:rgb(201, 76, 76); color :White">                
                
<th> SBName </th> <th> SBPanNo </th> <th> RefNo </th> <th> Amount </th> <th> Remarks </th>  <th> ProcessDate </th> '                
         
 SET @body = @body + @xml +'</table></body></html>                
       
<br />Thanks & Regards,<br /><br />        
Angel One Ltd.  <br />      
System Generated Mail'                
                
EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL                
                
@profile_name = 'AngelBroking',                
                
@body = @body,                
                
@body_format ='HTML',                
                
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',                
@recipients = 'pegasusinfocorp.suraj@angelbroking.com',                
                
@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',                
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',                
                
@subject = @Subject ;  


END          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AddClientDRFPodDetailsManually
-- --------------------------------------------------

CREATE Procedure USP_AddClientDRFPodDetailsManually    
@DRFId bigint, @ClientId VARCHAR(35)='', @PodNo VARCHAR(50)='',@CourierName VARCHAR(200)='',    
@DocumentReceived VARCHAR(15)=''    
AS    
BEGIN    
IF(@DocumentReceived='Received')    
BEGIN   

-- Send To Client

Update tbl_RejectedDRFOutwordProcessAndResponseDetails SET    
IsResponseUpload=1,  ResponseRemarks='Upload',      
CustomerCode='318883',PODNo=@PodNo, CourierBy=@CourierName    
,SpecialInstructions='Manual', ResponseUploadDate=GETDATE(),  
IsDocumentReceived=1,StatusDescription='DRF DELIVERED',DocumentReceivedBy='Owner',  
StatusDate= GETDATE(),DocumentReceivedDate=GETDATE(),  
ResponseBy='Test'      
WHERE DRFId = @DRFId AND ISNULL(IsFileGenerate,0)<>0

-- Send To RTA

Update tbl_DRFOutwordRegistrationSendToRTADetails SET    
IsResponseUpload=1,  ResponseRemarks='Upload',      
CustomerCode='318883',PODNo=@PodNo, CourierBy=@CourierName    
,SpecialInstructions='Manual', ResponseUploadDate=GETDATE(),  
IsDocumentReceived=1,StatusDescription='DRF DELIVERED',DocumentReceivedBy='Owner',  
StatusDate= GETDATE(),DocumentReceivedDate=GETDATE(),  
ResponseBy='Test'      
WHERE DRFId = @DRFId AND ISNULL(IsFileGenerate,0)<>0

END    
ELSE    
BEGIN  

-- Send To Client

Update tbl_RejectedDRFOutwordProcessAndResponseDetails SET    
IsResponseUpload=1,  ResponseRemarks='Upload',      
CustomerCode='318883',PODNo=@PodNo, CourierBy=@CourierName    
,SpecialInstructions='Manual', ResponseUploadDate=GETDATE(),  
IsDocumentReceived=0,StatusDescription='In Transit', ResponseBy='Test'      
WHERE DRFId = @DRFId AND ISNULL(IsFileGenerate,0)<>0   

-- Send To RTA

Update tbl_DRFOutwordRegistrationSendToRTADetails SET    
IsResponseUpload=1,  ResponseRemarks='Upload',      
CustomerCode='318883',PODNo=@PodNo, CourierBy=@CourierName    
,SpecialInstructions='Manual', ResponseUploadDate=GETDATE(),  
IsDocumentReceived=0,StatusDescription='In Transit', ResponseBy='Test'      
WHERE DRFId = @DRFId AND ISNULL(IsFileGenerate,0)<>0  

END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AddInterSementJVEntry
-- --------------------------------------------------

CREATE Procedure [dbo].[USP_AddInterSementJVEntry]   
(  
@VoucherType smallint,   
@BookType Nvarchar(5),   
@SNo int,   
@CltCode NVARCHAR(20),   
@CreditAmt money,  
@DebitAmt money,  
@Narration Varchar(255),  
@Exchange NVARCHAR(20),  
@Segment NVARCHAR(20),  
@VoucherNo NVARCHAR(25)  
)  
AS  
BEGIN  
Insert Into IntersegmentJV_OfflineLedger  
(VoucherType,    
  BookType,    
  SNo,    
  Vdate,    
  EDate,    
  CltCode,    
  CreditAmt,    
  DebitAmt,    
  Narration,    
  Exchange,    
  Segment,    
  AddDt,    
  AddBy,    
  StatusID,    
  StatusName,    
  RowState,    
  ApprovalFlag,    
  ApprovalDate,  
  VoucherNo,       
  UploadDt,  
  IsUpdatetoLive)   
    
  values(@VoucherType  
  ,@BookType  
  ,@SNo  
  ,cast(GETDATE() as date)  
  ,cast(GETDATE() as date)  
  ,@CltCode  
  ,@CreditAmt  
  ,@DebitAmt  
  ,@Narration  
  ,@Exchange  
  ,@Segment  
  ,GETDATE()  
  ,'AutoNBFC'  
  ,'broker'  
  ,'broker'  
  ,0  
  ,1  
  ,GETDATE()  
  ,@VoucherNo  
  ,GETDATE()  
  ,0  
  )  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AddShortageMarginJV_OfflineLedger
-- --------------------------------------------------

CREATE Procedure [dbo].[USP_AddShortageMarginJV_OfflineLedger]       
(      
@VoucherType smallint,       
@BookType Nvarchar(5),       
@SNo int,       
@CltCode NVARCHAR(20),       
@CreditAmt money,      
@DebitAmt money,      
@Narration Varchar(255),      
@Exchange NVARCHAR(20),      
@Segment NVARCHAR(20),      
@VoucherNo NVARCHAR(25),
@StartDate NVARCHAR(50),
@EndDate NVARCHAR(50)
)      
AS      
BEGIN      
Insert Into ShortageMarginJV_OfflineLedger      
(VoucherType,        
  BookType,        
  SNo,        
  Vdate,        
  EDate,        
  CltCode,        
  CreditAmt,        
  DebitAmt,        
  Narration,        
  Exchange,        
  Segment,        
  AddDt,        
  AddBy,        
  StatusID,        
  StatusName,        
  RowState,        
  ApprovalFlag,        
  ApprovalDate,      
  VoucherNo,           
  UploadDt,   
  StartDate,
  EndDate,
  IsUpdatetoLive)       
        
  values(@VoucherType      
  ,@BookType      
  ,@SNo      
  ,cast(GETDATE() as date)      
  ,cast(GETDATE() as date)      
  ,@CltCode      
  ,@CreditAmt      
  ,@DebitAmt      
  ,@Narration      
  ,@Exchange      
  ,@Segment      
  ,GETDATE()      
  ,'Remisier'      
  ,'broker'      
  ,'broker'      
  ,0      
  ,1      
  ,GETDATE()      
  ,@VoucherNo      
  ,GETDATE()  
  ,@StartDate
  ,@EndDate
  ,0      
  )      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CheckProcess2NBFCAndEquityAdjustmentAmount
-- --------------------------------------------------

CREATE PROCEDURE USP_CheckProcess2NBFCAndEquityAdjustmentAmount @NBFCFundingDate VARCHAR(30), @IsProcess2 bit  
AS  
BEGIN  
IF(@IsProcess2=1)  
BEGIN  
IF EXISTS(SElect * FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK) WHERE NBFCFundingDate = CAST(GETDATE() as date) AND IsProcess2 =0)  
BEGIN  
select DISTINCT 1 FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK)WHERE NBFCFundingDate = @NBFCFundingDate AND IsProcess2= 0  
END  
ELSE  
BEGIN  
select DISTINCT NBFCFundingDate FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK)WHERE NBFCFundingDate = @NBFCFundingDate AND IsProcess2= 1  
END  
  
END  
ELSE  
BEGIN  
select 1   
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ClientDRFProcessMailStatusAndDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ClientDRFProcessMailStatusAndDetails] @IsCurrentProcessedDRF bit=0  
As  
BEGIN  
  
------========= Reload DRF All Status Data ============-------  
  
EXEC [AGMUBODPL3].[DMAT].DBO.USP_ClientDRFProcessRTARejectedDetails  
  
EXEC USP_GetClientDRF_AllProcessCompleteStatusDetails  
  
------=============== END  ===============---------  

------- Update Rejection data for Courier 

SELECT RDRF.DRFId,RDRF.IsFileGenerate,RDRF.FileRemarks,IsCheckerRejected,CheckerProcessDate,
IsCDSLRejected,CDSLProcessDate,IsRTAProcess,RTAProcessDate,RTA.DocumentReceivedDate, 
CASE WHEN ISNULL(RTA.DRFId,0)<>0 THEN 'RTA'
WHEN DRFCSD.IsCDSLRejected =1 THEN 'CDSL'
WHEN DRFCSD.IsCheckerRejected=1 THEN 'DP' END 'RejectedStatus' INTO #DRF_CourierDetails
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails RDRF
JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFCSD
ON RDRF.DRFId = DRFCSD.DRFId
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails RTA
ON  RDRF.DRFId = RTA.DRFId --AND ISNULL(RTA.DRFId,0)<>0
WHERE RDRF.IsFileGenerate=0 
AND (DRFCSD.IsCDSLRejected =1 OR DRFCSD.IsCheckerRejected=1 OR ISNULL(RTA.DRFId,0)<>0)


UPDATE RDRFOPRD 
SET IsFileGenerate=(CASE WHEN DRFD.RejectedStatus='RTA' THEN 4 
WHEN DRFD.RejectedStatus='CDSL' THEN  3
WHEN DRFD.RejectedStatus='DP' THEN  2 END),
FileRemarks= (CASE WHEN DRFD.RejectedStatus='RTA' THEN 'RTA Rejected letter sent to Client - Maker' 
WHEN DRFD.RejectedStatus='CDSL' THEN  'DRF Rejected by CDSL'
WHEN DRFD.RejectedStatus='DP' THEN  'DRF Verfication by DP - Rejected' END),
FileGenerateDate=GETDATE()
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD
JOIN #DRF_CourierDetails DRFD
ON RDRFOPRD.DRFId = DRFD.DRFId

 ----------- 
  
DECLARE @xml NVARCHAR(MAX)  
DECLARE @body NVARCHAR(MAX)        
DECLARE @ProcessDate VARCHAR(15) = CONVERT(VARCHAR(11),GETDATE(),113)  
DECLARE @TotalCount int =0   
DECLARE @SRNo int =1, @PodNo VARCHAR(50)='',@CourierName VARCHAR(100)=''  
DECLARE @DispatchDate VARCHAR(17)='',@Quantity VARCHAR=''  
DECLARE @ClientEmailId VARCHAR(255)=''  
DECLARE @ClientAddress VARCHAR(MAX)=''  
DECLARE @ClientName VARCHAR(255)=''  , @DRFNo VARCHAR(35)=''  
DECLARE @RejectionType VARCHAR(MAX)=''         
DECLARE @Subject VARCHAR(MAX)= ''        
    
  
  
IF(@IsCurrentProcessedDRF=1)  
BEGIN   
  
-------========== Today DP Rejected DRF  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.CheckerProcessRemarks,'')  'ProcessRemarks',  
ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress',  
'Angel One' 'GeneratedType'  
INTO #TodayDPRejectedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId      
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code     
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
WHERE  CAST(DRFIRPM.InwordProcessDate as date)= CAST(GETDATE() as date)    
AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1   
AND CAST(DRFMCPT.CheckerProcessDate as date)= CAST(GETDATE() as date)    
  
  
---------======= Today CDSL Rejected DRF   
  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.CDSLRemarks,'')  'ProcessRemarks',  
ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress',  
'CDSL' 'GeneratedType'  
 INTO #TodayCDSLRejectedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId      
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code     
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
WHERE  CAST(DRFIRPM.InwordProcessDate as date)= CAST(GETDATE() as date)    
AND ISNULL(IsCDSLProcess,0)=1  
AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1  
AND CAST(DRFMCPT.CDSLProcessDate as date)= CAST(GETDATE() as date)    
  
  
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo', * INTO #TodayRejectedDRF FROM (  
SELECT * FROM #TodayDPRejectedDRF  
UNION   
SELECT * FROM #TodayCDSLRejectedDRF  
)A  
  
  
  
-------============ Today DP & CDSL Rejected DRF Mailer   
  
      
IF EXISTS(SELECT * FROM #TodayRejectedDRF)  
BEGIN  
       
SET @TotalCount =(SELECT COUNT(*) FROM #TodayRejectedDRF)   
  
SET @Subject = 'Demat Request Rejected'    
  
SET @RejectionType =''  
  
WHILE(@SRNo<=@TotalCount)  
BEGIN  
  
SET @DRFNo = (SELECT DISTINCT DRFNo FROM #TodayRejectedDRF WHERE SRNo=@SRNo)  
SET @ClientName = (SELECT DISTINCT ClientName FROM #TodayRejectedDRF WHERE SRNo=@SRNo)  
SET @ClientEmailId = (SELECT DISTINCT REPLACE(ClientEmailId,',',';') FROM #TodayRejectedDRF WHERE SRNo=@SRNo)  
SET @RejectionType = (SELECT DISTINCT GeneratedType FROM #TodayRejectedDRF WHERE SRNo=@SRNo)  
SET @ClientAddress = (SELECT DISTINCT ClientAddress FROM #TodayRejectedDRF WHERE SRNo=@SRNo)         
SET @Quantity = (SELECT DISTINCT CAST(Quantity as VARCHAR) FROM #TodayRejectedDRF WHERE SRNo=@SRNo)      
  
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','',[CompanyName] AS 'td','', [ProcessRemarks] AS 'td'        
FROM #TodayRejectedDRF  WHERE SRNo=@SRNo   
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
We regret to inform you that your Dematerialisation request has been rejected by '+@RejectionType+' due to the following reason:  
  
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> Company Name </th> <th> Reason </th> '  
         
 SET @body = @body + @xml +'</table></body></html>  
      
<br />    
We will send your rejected share certificates at the below mentioned address. <br />  
Please find here the details of the same: <br /> <br />     
  
1. DRFNo : '+@DRFNo+'  <br />    
2. No of Share Certificates : '+@Quantity+' <br />  
3. Address : '+@ClientAddress+'  <br />  
  
Kindly rectify the above rejection reason and resubmit the same with new DRF form.  
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,  
  
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = @Subject ;  
  
SET @SRNo = @SRNo+1;  
END    
END           
  
END  
  
ELSE  
  
BEGIN  
  
----------===*************** Rejected DRF Send to Client for Dispatch *************===========--------  
  
---================ DP Rejected DRF Send to Courier for dispatch  
  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.CheckerProcessRemarks,'')  'ProcessRemarks',  
ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
 INTO #DPRejectedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId      
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
WHERE IsFileGenerate=2  
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1  AND ISNULL(StatusGroup,'') <>''  
AND ISNULL(DRFPCMSD.IsDPRejectionMail,0)=0 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1  
  
  
--============ CDSL Rejected DRF Send to Courier for dispatch  
  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.CDSLRemarks,'')  'ProcessRemarks'  
,ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
INTO #CDSLRejectedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId       
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
WHERE IsFileGenerate=3   
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1  AND ISNULL(StatusGroup,'') <>''  
AND ISNULL(DRFPCMSD.IsCDSLRejectionMail,0)=0 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1  
  
  
----============= RTA Rejected DRF Send to Courier for dispatch  
  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.RTARemarks,'')  'ProcessRemarks'  
,ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
INTO #RTARejectedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId       
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
 LEFT JOIN [AGMUBODPL3].[DMAT].DBO.ClientDRFRTARejectedDetails DRFMCPT WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFMCPT.DRFId  
WHERE IsFileGenerate=4   
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1  AND ISNULL(StatusGroup,'') <>''  
AND ISNULL(DRFPCMSD.IsRTARejectionMail,0)=0 AND ISNULL(DRFMCPT.IsRTAProcess,0)=1  
  
  
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo', * INTO #RejectedDRFProcess FROM (  
SELECT * FROM #DPRejectedDRF  
UNION   
SELECT * FROM #CDSLRejectedDRF  
UNION  
SELECT * FROM #RTARejectedDRF  
)A  
  
  
-------------===========  DP, CDSL & RTA Rejected Send to Courier for dispatch DRF Mailer   
   
      
IF EXISTS(SELECT * FROM #RejectedDRFProcess)  
BEGIN  
       
SET @TotalCount =(SELECT COUNT(*) FROM #RejectedDRFProcess)   
  
SET @Subject = 'Demat Request Rejected'    
  
SET @RejectionType =''  
  
WHILE(@SRNo<=@TotalCount)  
BEGIN  
  
SET @DRFNo = (SELECT DISTINCT DRFNo FROM #RejectedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientName = (SELECT DISTINCT ClientName FROM #RejectedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientEmailId = (SELECT DISTINCT REPLACE(ClientEmailId,',',';') FROM #RejectedDRFProcess WHERE SRNo=@SRNo)  
SET @RejectionType = (SELECT DISTINCT CASE WHEN GenerationType=2 THEN ' AngelOne ' WHEN GenerationType=3 THEN ' CDSL ' WHEN GenerationType=4 THEN ' RTA ' END FROM #RejectedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientAddress = (SELECT DISTINCT ClientAddress FROM #RejectedDRFProcess WHERE SRNo=@SRNo)      
SET @PodNo = (SELECT DISTINCT PodNo FROM #RejectedDRFProcess WHERE SRNo=@SRNo)      
SET @CourierName = (SELECT DISTINCT CourierBy FROM #RejectedDRFProcess WHERE SRNo=@SRNo)      
SET @DispatchDate = (SELECT DISTINCT DispatchDate FROM #RejectedDRFProcess WHERE SRNo=@SRNo)      
SET @Quantity = (SELECT DISTINCT CAST(Quantity as VARCHAR) FROM #RejectedDRFProcess WHERE SRNo=@SRNo)      
  
UPDATE DRFCMSD SET IsDPRejectionMail =(CASE WHEN GenerationType=2 THEN 1 ELSE ISNULL(IsDPRejectionMail,0) END)  
, DPRejectionMailProcessDate=(CASE WHEN GenerationType=2 THEN GETDATE() ELSE ISNULL(DPRejectionMailProcessDate,'') END),  
IsCDSLRejectionMail=(CASE WHEN GenerationType=3 THEN 1 ELSE ISNULL(IsCDSLRejectionMail,0) END)  
,CDSLRejectionMailProcessDate=(CASE WHEN GenerationType=3 THEN GETDATE() ELSE ISNULL(CDSLRejectionMailProcessDate,'') END),  
IsRTARejectionMail=(CASE WHEN GenerationType=4 THEN 1 ELSE ISNULL(IsRTARejectionMail,0) END),   
RTARejectionMailProcessDate=(CASE WHEN GenerationType=4 THEN GETDATE() ELSE ISNULL(RTARejectionMailProcessDate,'') END)  
FROM tbl_DRFProcessClientMailStatusDetails DRFCMSD  
JOIN #RejectedDRFProcess RDRFP  
ON DRFCMSD.DRFId = RDRFP.DRFId  
WHERE SRNo = @SRNo  
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','',[CompanyName] AS 'td','', [ProcessRemarks] AS 'td'        
FROM #RejectedDRFProcess  WHERE SRNo=@SRNo   
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
We regret to inform you that your Dematerialisation request has been rejected by '+@RejectionType+' due to the following reason:  
  
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> Company Name </th> <th> Reason </th> '  
         
 SET @body = @body + @xml +'</table></body></html>  
      
<br />    
We have send your rejected share certificates at the below mentioned address. <br />  
Please find here the details of the same: <br /> <br />     
  
1. DRFNo : '+@DRFNo+'  <br />    
2. No of Share Certificates : '+@Quantity+' <br />  
3. Address : '+@ClientAddress+'  <br />  
4. Courier Company Name: '+@CourierName+'  <br />  
5. Tracking No: '+@PodNo+'  <br />    <br />  
  
Kindly rectify the above rejection reason and resubmit the same with new DRF form.  
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,  
  
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = @Subject ;  
  
SET @SRNo = @SRNo+1;  
END    
END           
  
  
---------===================== END ===================------------------  
   
----------************  Rejected DRF Dispatched to Client *************-----------  
  
  
-----================== DP Rejected Dispatched to client DRF  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,         
ISNULL(DRFMCPT.CheckerProcessRemarks,'')  'ProcessRemarks',  
ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
INTO #DPRejectedDispatchedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId      
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0    
WHERE IsFileGenerate=2   
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1 AND ISNULL(StatusGroup,'') ='DL'  
AND ISNULL(DRFPCMSD.IsDPRejectionReceivedMail,0)=0 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1  
  
  
-----==================== CDSL Rejected Dispatched to client DRF        
  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.CDSLRemarks,'')  'ProcessRemarks'  
,ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
INTO #CDSLRejectionDispatchedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId       
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
  
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0    
WHERE IsFileGenerate=3   
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1 AND ISNULL(StatusGroup,'') ='DL'  
AND ISNULL(DRFPCMSD.IsCDSLRejectionReceivedMail,0)=0 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1  
  
  
------================== RTA Rejected Dispatched to client DRF  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity,RDRFOPRD.PodNo,RDRFOPRD.CourierBy,  
CONVERT(VARCHAR(17),RDRFOPRD.FileGenerateDate,113) 'FileGenerateDate',  
CONVERT(VARCHAR(17),RDRFOPRD.ResponseUploadDate,113) 'ResponseUploadDate',  
CONVERT(VARCHAR(17),RDRFOPRD.DocumentReceivedDate,113) 'DispatchDate',DRFPCMSD.ClientEmailId,  
ISNULL(DRFMCPT.RTARemarks,'')  'ProcessRemarks'  
,ISNULL(IsFileGenerate,0) 'GenerationType'   
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+   
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'  
INTO #RTARejectedDispatchedDRF  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId       
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFPCMSD.cltCode = AMCD.cl_code   
 LEFT JOIN [AGMUBODPL3].[DMAT].DBO.ClientDRFRTARejectedDetails DRFMCPT WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFMCPT.DRFId  
WHERE IsFileGenerate=4   
AND CAST(RDRFOPRD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND IsResponseUpload=1 AND ISNULL(StatusGroup,'') ='DL'  
AND ISNULL(DRFPCMSD.IsRTARejectionReceivedMail,0)=0 AND ISNULL(DRFMCPT.IsRTAProcess,0)=1  
  
  
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo', * INTO #RejectedDispatchedDRFProcess FROM (  
SELECT * FROM #DPRejectedDispatchedDRF  
UNION   
SELECT * FROM #CDSLRejectionDispatchedDRF  
UNION  
SELECT * FROM #RTARejectedDispatchedDRF  
)A  
  
  
-------------===========  DP, CDSL & RTA Rejected Dispatched to Client DRF Mailer   
  
  
SET @TotalCount =0   
SET @SRNo =1        
    
      
IF EXISTS(SELECT * FROM #RejectedDispatchedDRFProcess)  
BEGIN  
       
SET @TotalCount =(SELECT COUNT(*) FROM #RejectedDispatchedDRFProcess)   
  
SET @Subject = 'Demat Request Rejected'    
  
SET @RejectionType =''  
  
WHILE(@SRNo<=@TotalCount)  
BEGIN  
  
SET @DRFNo = (SELECT DISTINCT DRFNo FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientName = (SELECT DISTINCT ClientName FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientEmailId = (SELECT DISTINCT REPLACE(ClientEmailId,',',';') FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)  
SET @RejectionType = (SELECT DISTINCT CASE WHEN GenerationType=2 THEN ' AngelOne ' WHEN GenerationType=3 THEN ' CDSL ' WHEN GenerationType=4 THEN ' RTA ' END FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)  
SET @ClientAddress = (SELECT DISTINCT ClientAddress FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)      
SET @PodNo = (SELECT DISTINCT PodNo FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)      
SET @CourierName = (SELECT DISTINCT CourierBy FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)      
SET @DispatchDate = (SELECT DISTINCT DispatchDate FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)      
SET @Quantity = (SELECT DISTINCT CAST(Quantity as VARCHAR) FROM #RejectedDispatchedDRFProcess WHERE SRNo=@SRNo)      
  
UPDATE DRFCMSD SET IsDPRejectionReceivedMail =(CASE WHEN GenerationType=2 THEN 1 ELSE 0 END)  
, DPRejectionReceivedMailProcessDate=(CASE WHEN GenerationType=2 THEN GETDATE() ELSE '' END),  
IsCDSLRejectionReceivedMail=(CASE WHEN GenerationType=3 THEN 1 ELSE 0 END)  
,CDSLRejectionReceivedMailProcessDate=(CASE WHEN GenerationType=3 THEN GETDATE() ELSE '' END),  
IsRTARejectionReceivedMail=(CASE WHEN GenerationType=4 THEN 1 ELSE 0 END),   
RTARejectioReceivednMailProcessDate=(CASE WHEN GenerationType=4 THEN GETDATE() ELSE '' END)  
FROM tbl_DRFProcessClientMailStatusDetails DRFCMSD  
JOIN #RejectedDispatchedDRFProcess RDRFP  
ON DRFCMSD.DRFId = RDRFP.DRFId  
WHERE SRNo = @SRNo  
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','', [CompanyName] AS 'td','', [ProcessRemarks] AS 'td'        
FROM #RejectedDispatchedDRFProcess  WHERE SRNo=@SRNo   
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
We regret to inform you that your Dematerialisation request has been rejected by '+@RejectionType+' due to the following reason:  
  
 </H2>           
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> Company Name </th> <th> Reason </th> '  
         
 SET @body = @body + @xml +'</table></body></html>  
      
<br />    
We have dispatched your rejected share certificates at the below mentioned address. <br />  
Please find here the details of the same: <br /> <br />     
  
1. DRFNo : '+@DRFNo+'  <br />          
2. No of Share Certificates : '+@Quantity+' <br />  
3. Address : '+@ClientAddress+'  <br />  
4. Courier Company Name: '+@CourierName+'  <br />  
5. Tracking No: '+@PodNo+'  <br />  
6. Date of Dispatch: '+@DispatchDate+' <br /><br />  
  
Kindly rectify the above rejection reason and resubmit the same with new DRF form.  
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,  
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = @Subject ;  
  
SET @SRNo = @SRNo+1;  
END    
END  
  
---------------===================== END ====================------------------------  
    
    
-----===============********** RTA Confirmed DRF *********===============------------------------  
  
          
SELECT ROW_NUMBER() OVER(ORDER By DRFId) 'SRNo' ,* INTO #RTA_AcceptedDRF   
FROM (        
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPD.CompanyName, DRFIRPM.ClientId  
,DRFIRPM.ClientName,DRFIRPM.NoOfCertificates,  
DRFIRPD.Quantity ,ClientEmailId ,DRFMCPT.RTAProcessDate          
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId =DRFIRPD.DRFId      
JOIN tbl_DRFOutwordRegistrationSendToRTADetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId  
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId  
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0    
 WHERE DRFMCPT.IsRTAProcess=1           
 AND ISNULL(RTARemarks,'') like 'CONFIRMED%'          
 AND CAST(RTAProcessDate as date)=cast(GETDATE() as date)          
 AND IsRTASuccessMail=0          
 )AA          
  
  
      
IF EXISTS(SELECT * FROM #RTA_AcceptedDRF)  
BEGIN          
  
SET @TotalCount =(SELECT COUNT(*) FROM #RTA_AcceptedDRF)   
SET @SRNo =1          
  
DECLARE @Subject1 VARCHAR(MAX)= 'Demat Request Processed'    
  
          
WHILE(@SRNo<=@TotalCount)  
BEGIN  
  
SET @ClientName = (SELECT DISTINCT ClientName FROM #RTA_AcceptedDRF WHERE SRNo=@SRNo)  
SET @ClientEmailId = (SELECT DISTINCT REPLACE(ClientEmailId,',',';') FROM #RTA_AcceptedDRF WHERE SRNo=@SRNo)   
SET @Quantity = (SELECT DISTINCT CAST(NoOfCertificates as VARCHAR) FROM #RTA_AcceptedDRF WHERE SRNo=@SRNo)      
  
UPDATE DRFCMSD SET IsRTASuccessMail =1  
, RTASuccessMailProcessDate= GETDATE()           
FROM tbl_DRFProcessClientMailStatusDetails DRFCMSD  
JOIN #RTA_AcceptedDRF RDRFP  
ON DRFCMSD.DRFId = RDRFP.DRFId  
WHERE SRNo = @SRNo  
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','', [ClientId] AS 'td','', [CompanyName] AS 'td'           
 ,'', [Quantity] AS 'td'           
FROM #RTA_AcceptedDRF  WHERE SRNo=@SRNo   
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
This is to inform you that, RTA has credited the shares in your demat account. The details are as under and you can view your holding in portal:       
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> DP/Demat Account (DP ID) </th> <th> Name of Company </th> <th> Number of shares </th> '  
         
 SET @body = @body + @xml +'</table></body></html>  
      
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,  
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = @Subject1 ;  
  
SET @SRNo = @SRNo+1;  
END    
END  
  
  
------------************************* END **************************-------------  
  
  
  
-------================== DRF Send to RTA Mailer ===================---------------         
          
  
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo',DRFId,CompanyName,  
ClientName, ClientEmailId,DRFNo ,RTAAddress ,RTAEmailId ,RTAContactNo ,ProcessDate     
INTO #SendToRTADRF  
FROM(  
SELECT DISTINCT DRFIRPM.DRFId, DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,  
DEM.ENTM_NAME1 'CompanyName',  CONVERT(VARCHAR(17),DRFRSTRTAD.FileGenerateDate,113) 'ProcessDate'  ,      
DRFIRPM.NoOfCertificates,  
DRFPCMSD.ClientEmailId,          
ISNULL(DISINM.isin_adr1,'')+','+ISNULL(DISINM.isin_adr2,'')+','+ISNULL(DISINM.isin_adr3,'')+','+ISNULL(DISINM.isin_adrcity,'')+','+ISNULL(DISINM.isin_adrstate,'') +'-'+ ISNULL(DISINM.isin_adrzip,'') 'RTAAddress'          
,ISNULL(isin_email,'') 'RTAEmailId' ,
---- ISNULL(isin_TELE,'') 'RTAContactNo' 
CASE WHEN ISNULL(isin_TELE,'') like '%/%' THEN SUBSTRING(ISNULL(isin_TELE,''),0,CHARINDEX('/',ISNULL(isin_TELE,''),0))
ELSE ISNULL(isin_TELE,'') END 'RTAContactNo'
          
FROM tbl_DRFOutwordRegistrationSendToRTADetails DRFRSTRTAD WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFRSTRTAD.DRFId    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPD.DRFId = DRFIRPM.DRFId          
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFPCMSD.DRFId           
JOIN [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR DISINM WITH(NOLOCK)  
ON DISINM.ISIN_CD = DRFIRPD.ISINNo  
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].entity_mstr DEM WITH(NOLOCK)  
ON ENTM_ENTTM_CD ='rta' and ENTM_SHORT_NAME ='rta_'+CONVERT(varchar,ISIN_REG_CD )        
WHERE DRFRSTRTAD.IsResponseUpload=1     
AND CAST(DRFRSTRTAD.ResponseUploadDate as date)= CAST(GETDATE() as date)  
AND ISNULL(DRFRSTRTAD.StatusGroup,'') ='DL'  
AND DRFPCMSD.IsDRFSendToRTAMail=0 AND ISNUMERIC(ISIN_REG_CD)=1        
)A  
          
IF EXISTS(SELECT * FROM #SendToRTADRF)  
BEGIN  
  
  
SET @TotalCount =(SELECT COUNT(*) FROM #SendToRTADRF)   
SET @SRNo =1           
 DECLARE @RTAName VARCHAR(255)=''          
 DECLARE @RTAAddress VARCHAR(MAX)=''          
 DECLARE @RTAContactNo VARCHAR(25)=''          
 DECLARE @RTAEmailId VARCHAR(150)=''          
          
WHILE(@SRNo<=@TotalCount)  
BEGIN  
  
SET @DRFNo = (SELECT DISTINCT DRFNo FROM #SendToRTADRF WHERE SRNo=@SRNo)          
SET @ClientName = (SELECT DISTINCT ClientName FROM #SendToRTADRF WHERE SRNo=@SRNo)  
SET @ClientEmailId = (SELECT DISTINCT REPLACE(ClientEmailId,',',';') FROM #SendToRTADRF WHERE SRNo=@SRNo)   
SET @ProcessDate = (SELECT DISTINCT ProcessDate FROM #SendToRTADRF WHERE SRNo=@SRNo)      
SET @RTAName = (SELECT DISTINCT CompanyName FROM #SendToRTADRF WHERE SRNo=@SRNo)           
SET @RTAAddress = (SELECT DISTINCT RTAAddress FROM #SendToRTADRF WHERE SRNo=@SRNo)           
SET @RTAContactNo = (SELECT DISTINCT RTAContactNo FROM #SendToRTADRF WHERE SRNo=@SRNo)           
SET @RTAEmailId = (SELECT DISTINCT REPLACE(RTAEmailId,',',';') FROM #SendToRTADRF WHERE SRNo=@SRNo)           
  
UPDATE DRFCMSD SET IsDRFSendToRTAMail =1  
, DRFSendToRTAMailProcessDate= GETDATE()           
FROM tbl_DRFProcessClientMailStatusDetails DRFCMSD  
JOIN #SendToRTADRF RDRFP  
ON DRFCMSD.DRFId = RDRFP.DRFId  
WHERE SRNo = @SRNo  
         
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
          
We have processed your demat Form at AngelOne and sent to RTA for further processing on '+@ProcessDate+'. Following are the RTA details and you may also coordinate with RTA for faster processing at their end.          
<br />  <br />    
DRF No : '+@DRFNo+' <br />   
RTA name : '+@RTAName+' <br />           
RTA address : '+@RTAAddress+' <br />  
Telephone no. : '+@RTAContactNo+' <br />           
Email id  :  '+@RTAEmailId+'         
          
 </H2>  
         
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,  
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = 'Demat Request processed and Sent RTA' ;  
  
SET @SRNo = @SRNo+1;  
END    
END    



-------================== DRF Send RTA Remainder Mailer ===================---------------         
          
  
SELECT ROW_NUMBER() OVER(ORDER BY DRFNo) 'SRNo',* INTO #DRF_RTA_Remainder FROM (
SELECT DRFIRPM.DRFNo,DRFIRPM.DRFId,DRFIRPM.ClientId,DRFIRPM.ClientName,ISINNo,CompanyName,NoOfCertificates,Quantity,DRNNo,
isin_adr1,ISNULL(isin_adr2,'') isin_adr2,ISNULL(isin_adr3,'') isin_adr3,isin_adrcity,
isin_adrstate,isin_adrcountry,isin_adrzip,isin_email 'RTA_EmailId'
,ENTM_NAME1 'RTA_Name',CONVERT(VARCHAR(10),CONVERT(datetime,CDSLProcessDate,103),103) 'ProcessDate'
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)
ON DRFIRPM.DRFId = DRFIRPD.DRFId
JOIN tbl_DRFOutwordRegistrationSendToRTADetails DRFORSTAD WITH(NOLOCK)
ON DRFIRPM.DRFId = DRFORSTAD.DRFId
JOIN tbl_ClientDRFProcessCompleteStatusDetails CDRFCSD WITH(NOLOCK)
ON DRFIRPM.DRFId = CDRFCSD.DRFId
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)
ON DRFIRPM.DRFId=DRFPCMSD.DRFId
JOIN [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR DISINM WITH(NOLOCK)     
ON DISINM.ISIN_CD = DRFIRPD.ISINNo     
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].entity_mstr DEM WITH(NOLOCK)     
ON ENTM_ENTTM_CD ='rta' and ENTM_SHORT_NAME ='rta_'+CONVERT(varchar,ISIN_REG_CD )  
WHERE CDRFCSD.IsCDSLProcess=1 AND ISNULL(DRFPCMSD.IsRTARemainder,0)=0
AND RTALetterGenerate=1 AND IsRTAProcess=0 ---AND ISNUMERIC(ISIN_REG_CD)=1 
AND CAST(CDSLProcessDate as date) < CAST(GETDATE()-21 as date)
AND CAST(CDSLProcessDate as date)>= '2025-01-01'
)A
          
IF EXISTS(SELECT * FROM #DRF_RTA_Remainder)  
BEGIN  
  
  
SET @TotalCount =(SELECT COUNT(*) FROM #DRF_RTA_Remainder)   
SET @SRNo =1           
 DECLARE @RTAName_1 VARCHAR(255)=''          
 DECLARE @RTAAddress_isin_adr1 VARCHAR(MAX)='',@RTAAddress_isin_adr2 VARCHAR(MAX)='',@RTAAddress_isin_adr3 VARCHAR(MAX)='',    
 @RTAAddress_isin_adrcity VARCHAR(MAX)='',@RTAAddress_isin_adrstate VARCHAR(MAX)='',@RTAAddress_isin_adrcountry VARCHAR(MAX)='',
 @RTAAddress_isin_adrzip VARCHAR(MAX)=''         
 DECLARE @RTAEmailId_1 VARCHAR(150)=''          
          
WHILE(@SRNo<=@TotalCount)  
BEGIN  
     
SET @RTAName_1 = (SELECT DISTINCT RTA_Name FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adr1 = (SELECT DISTINCT isin_adr1 FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adr2 = (SELECT DISTINCT isin_adr2 FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adr3 = (SELECT DISTINCT isin_adr3 FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adrcity = (SELECT DISTINCT isin_adrcity FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adrstate = (SELECT DISTINCT isin_adrstate FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adrcountry = (SELECT DISTINCT isin_adrcountry FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
SET @RTAAddress_isin_adrzip = (SELECT DISTINCT isin_adrzip FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)                   
SET @RTAEmailId_1 = (SELECT DISTINCT REPLACE(RTA_EmailId,',',';') FROM #DRF_RTA_Remainder WHERE SRNo=@SRNo)           
  
UPDATE DRFCMSD SET IsRTARemainder =1  
, RTARemainderMailProcessDate= GETDATE()           
FROM tbl_DRFProcessClientMailStatusDetails DRFCMSD  
JOIN #DRF_RTA_Remainder RDRFP  
ON DRFCMSD.DRFId = RDRFP.DRFId  
WHERE SRNo = @SRNo  

 SET @xml = CAST(( SELECT [DRFNo] AS 'td','', [ClientId] AS 'td','', [DRNNo] AS 'td','',
 [ProcessDate] AS 'td','',[CompanyName] AS 'td' ,'',[ISINNo] AS 'td'           
 ,'', [Quantity] AS 'td'           
FROM #DRF_RTA_Remainder  WHERE SRNo=@SRNo   
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))
         
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 To, <br />  
 '+@RTAName_1+' ,<br />
 '+@RTAAddress_isin_adr1+' ,<br />
 '+@RTAAddress_isin_adr2+' ,<br />
 '+@RTAAddress_isin_adr3+' ,<br />
 '+@RTAAddress_isin_adrcity+' ,<br />
 '+@RTAAddress_isin_adrstate+' ,<br />
 '+@RTAAddress_isin_adrcountry+' <br />
 '+@RTAAddress_isin_adrzip+' <br /><br />  

Sir/Madam,

We are giving herewith details of DRN which are pending for more than 21 days. 
As per SEBI guideline, shares should be demater within 15 days from submission with register. 
Investor are regularly inquiring with us regarding status of this DRN. 
We request look into the matter and do the needful as early as possible. 
Please ingore this mail in case you have alredy closed this DRN. 

<br /><br />

<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> Client ID </th> <th> DRN </th> <th> Date </th> <th> Script Name </th> <th> ISIN No. </th> <th> Qty </th> '  
         
 SET @body = @body + @xml +'</table></body></html>         
          
 </H2>  
         
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @RTAEmailId_1,  
--@recipients = 'pegasusinfocorp.suraj@angelbroking.com;' ,  
--@copy_recipients = 'jagannath@angelbroking.com;',

--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = 'Pending Dematerialisation Request' ;  
  
SET @SRNo = @SRNo+1;  
END    
END 
  
  
-------------========================== END ==============================--------------------  
 
 -----------******* Client Mailer Send MIS ******-------

 
SELECT subject 'MailerSubject',COUNT(recipients) 'MailerSendCount'  INTO #ClientMailerLogSummary
FROM [CSOKYC-6].MSDB.DBO.sysmail_mailitems WITH(NOLOCK)               
WHERE CAST(sent_date as date)>=CAST(GETDATE() as date) 
AND subject IN('Demat Request Processed','Demat Request Rejected'
,'Demat Request processed and Sent RTA','Pending Dematerialisation Request')
GROUP BY subject

 
DECLARE @xml_Mailer NVARCHAR(MAX)    
           
 SET @xml_Mailer = CAST(( SELECT [MailerSubject] AS 'td','', [MailerSendCount] AS 'td'            
FROM #ClientMailerLogSummary    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))     


SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear Team </b>,<br /><br />  
  
Please find the Today client mailer send log count.     
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> MailerSubject </th> <th> MailerSendCount </th> '  
         
 SET @body = @body + @xml_Mailer +'</table>  
  
 </body></html>  
      
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = 'jagannath@angelbroking.com;',  
--@copy_recipients = 'paresh.natekar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = 'Client DRF Process Mailer Count MIS' ;  
       

-------------------------- END ----------------------

  
-------- Client DRF Process MIS : overall / Daily Process Basis  
  
  
CREATE TABLE #ClientDRFProcessMISData  
(  
SR int,  
AppStatus VARCHAR(10),  
NoOfRecords bigint,  
UniqueRecords bigint,  
TotalValueOfDRF decimal(17,2),  
AmountGreater5Lac bigint,  
CountOfBreachOffCumValue bigint,  
IncomeBreachOffCumValue decimal(17,2)  
)  
  
INSERT INTO #ClientDRFProcessMISData  
EXEC USP_GetClientDRFProcess_MISData 0  
  
DECLARE @xml1 NVARCHAR(MAX)    
           
 SET @xml = CAST(( SELECT [SR] AS 'td','', [AppStatus] AS 'td'           
 ,'', [NoOfRecords] AS 'td'  ,'', [UniqueRecords] AS 'td'  ,'', [TotalValueOfDRF] AS 'td'   
  ,'', [AmountGreater5Lac] AS 'td'  ,'', [CountOfBreachOffCumValue] AS 'td'   
  ,'', [IncomeBreachOffCumValue] AS 'td'   
FROM #ClientDRFProcessMISData    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
delete from #ClientDRFProcessMISData  
  
INSERT INTO #ClientDRFProcessMISData  
EXEC USP_GetClientDRFProcess_MISData 1  
  
SET @xml1 = CAST(( SELECT [SR] AS 'td','', [AppStatus] AS 'td'           
 ,'', [NoOfRecords] AS 'td'  ,'', [UniqueRecords] AS 'td'  ,'', [TotalValueOfDRF] AS 'td'   
  ,'', [AmountGreater5Lac] AS 'td'  ,'', [CountOfBreachOffCumValue] AS 'td'   
  ,'', [IncomeBreachOffCumValue] AS 'td'   
FROM #ClientDRFProcessMISData    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear Team </b>,<br /><br />  
  
Please find the Client DRF Process Overall MIS.     
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> SR </th> <th> AppStatus </th> <th> NoOfRecords </th> <th> UniqueRecords </th> <th> TotalValueOfDRF </th> <th> AmountGreater5Lac </th> <th> CountOfBreachOffCumValue </th> <th> IncomeBreachOffCumValue </th> '  
         
 SET @body = @body + @xml +'</table>  
  
 <br />  
  
 Please find the Client DRF Process MIS on process date : '+@ProcessDate+'.     
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> SR </th> <th> AppStatus </th> <th> NoOfRecords </th> <th> UniqueRecords </th> <th> TotalValueOfDRF </th> <th> AmountGreater5Lac </th> <th> CountOfBreachOffCumValue </th> <th> IncomeBreachOffCumValue </th> '  
         
 SET @body = @body + @xml1 +'</table></body></html>  
      
<br />  
  
<br />Thank you,<br />      
Team Angel One'  
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = 'jagannath@angelbroking.com;',  
@copy_recipients = 'dileswar.jena@angelbroking.com; paresh.natekar@angelbroking.com;' ,  
  
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = 'MIS of Client DRF Process' ;  
          
END   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CreateAndSaveSubBrokerTagGenerationDetails_06Nov2025
-- --------------------------------------------------
  
 CREATE PROCEDURE USP_CreateAndSaveSubBrokerTagGenerationDetails_06Nov2025    
 @IntermediaryId bigint=0,@SBPanNo VARCHAR(15)='' ,@ProcessBy VARCHAR(15)=''    
 AS    
 BEGIN    
 DECLARE @loop_ctr INT = 0      
 WHILE @loop_ctr < 10    
 BEGIN     
  DECLARE @chars NCHAR(62)    
  SET @chars = N'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    
  DECLARE @AlphaNumeric NCHAR(5)=''    
  SET @AlphaNumeric = (SELECT SUBSTRING(IntermediaryName,1,1)     
  +SUBSTRING(IntermediaryName, CHARINDEX(' ',IntermediaryName)+1,1)     
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)    
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)    
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)   
  From tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)    
  
    
  SELECT * INTO #SBTagDetails FROM (  
  SELECT DISTINCT SBTAG FROM SB_COMP.dbo.SB_Broker WITH(NOLOCK) WHERE SBTAG=@AlphaNumeric  
  UNION   
  SELECT DISTINCT SBTAG FROM tbl_IntermediarySBTagGenerationMaster WITH(NOLOCK) WHERE SBTAG=@AlphaNumeric  
  )AA  
    
  --print @AlphaNumeric    
  IF NOT EXISTS(SELECT * FROM #SBTagDetails)    
  BEGIN    
  INSERT INTO tbl_IntermediarySBTagGenerationMaster    
  VALUES(@IntermediaryId,@AlphaNumeric,@SBPanNo,GETDATE(),GETDATE(),@ProcessBy)    
  BREAK;    
  END    
  ELSE    
  BEGIN    
  SET @loop_ctr = @loop_ctr + 1    
  END    
 END    
 END

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_CreateAndSaveSubBrokerTagGenerationDetails_tobedeleted09jan2026
-- --------------------------------------------------
  
 CREATE PROCEDURE USP_CreateAndSaveSubBrokerTagGenerationDetails    
 @IntermediaryId bigint=0,@SBPanNo VARCHAR(15)='' ,@ProcessBy VARCHAR(15)=''    
 AS    
 BEGIN  
 insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

 DECLARE @loop_ctr INT = 0      
 WHILE @loop_ctr < 10    
 BEGIN     
  DECLARE @chars NCHAR(62)    
  SET @chars = N'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    
  DECLARE @AlphaNumeric NCHAR(5)=''    
  SET @AlphaNumeric = (SELECT SUBSTRING(IntermediaryName,1,1)     
  +SUBSTRING(IntermediaryName, CHARINDEX(' ',IntermediaryName)+1,1)     
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)    
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)    
  + SUBSTRING(@chars, CAST((RAND() * LEN(@chars)) AS INT) + 1, 1)   
  From tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)    
  
    
  SELECT * INTO #SBTagDetails FROM (  
  SELECT DISTINCT SBTAG FROM SB_COMP.dbo.SB_Broker WITH(NOLOCK) WHERE SBTAG=@AlphaNumeric  
  UNION   
  SELECT DISTINCT SBTAG FROM tbl_IntermediarySBTagGenerationMaster WITH(NOLOCK) WHERE SBTAG=@AlphaNumeric  
  )AA  
    
  --print @AlphaNumeric    
  IF NOT EXISTS(SELECT * FROM #SBTagDetails)    
  BEGIN    
  INSERT INTO tbl_IntermediarySBTagGenerationMaster    
  VALUES(@IntermediaryId,@AlphaNumeric,@SBPanNo,GETDATE(),GETDATE(),@ProcessBy)    
  BREAK;    
  END    
  ELSE    
  BEGIN    
  SET @loop_ctr = @loop_ctr + 1    
  END    
 END    
 END

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndMailDRFOutwordProcesstoClientReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GenerateAndMailDRFOutwordProcesstoClientReport]     
@FromDate VARCHAR(10)='', @ToDate VARCHAR(10)='',@ReportType VARCHAR(130)='' ,@GeneratedBy VARCHAR(35)=''    
AS    
BEGIN    
    
DECLARE @Condition VARCHAR(MAX)='', @Condition1 VARCHAR(MAX)=''    
IF EXISTS(SELECT * FROM tbl_RejectedDRFOutwordProcessAndResponseDetails WITH(NOLOCK) WHERE IsFileGenerate=0 AND CAST(FileGenerateDate as date) <>CAST(GETDATE() as date))    
BEGIN    
    
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)      
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)      
      
IF(@ReportType='InValidClientId')      
BEGIN      
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFIRPM.IsRejected=1 '      
END      
IF(@ReportType='DP_Rejected')      
BEGIN      
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsCheckerRejected=1 '      
END      
IF(@ReportType='CDSL_Rejected')      
BEGIN      
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsCDSLRejected=1 '      
END      
IF(@ReportType='RTA_Rejected')      
BEGIN      
SET @Condition = ' AND CAST(DRFIRBRTA.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0 '      
END      
IF(@ReportType='DRFAllRejected')      
BEGIN      
SET @Condition = ' AND ( CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' OR CAST(DRFIRBRTA.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''')         
AND (DRFMCPT.IsCheckerRejected=1 OR DRFMCPT.IsCDSLRejected=1 OR (DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0)) '      
END    
    
TRUNCATE TABLE ClientDRFProcessBlueDartCourierDetails    
     
    
EXEC('    
UPDATE DRFORRPD SET IsFileGenerate = StatusCode    
, FileRemarks=B.Status    
,FileGenerateDate=GETDATE() ,GenerateBy='''+@GeneratedBy+'''     
    
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails DRFORRPD    
JOIN (    
SELECT * FROM(     
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,    
    
CASE WHEN DRFIRPM.IsRejected=1 THEN 1    
WHEN DRFMCPT.IsCheckerRejected=1 THEN 2    
WHEN DRFMCPT.IsCDSLRejected=1  THEN 3    
WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN 4     
ELSE 0 END StatusCode,    
    
CASE    
WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN ''RTA Rejected letter sent to Client - Maker''     
WHEN DRFMCPT.IsCDSLRejected=1 THEN ''DRF Rejected by CDSL''    
WHEN DRFMCPT.IsCheckerRejected=1 THEN ''DRF Verfication by DP - Rejected''    
WHEN DRFIRPM.IsRejected=1 THEN ''DRF Courier Receieved & Rejected due to Invalid Client Id''    
END ''Status''    
    
    
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)    
ON DRFIRPM.DRFId = DRFIRPD.DRFId    
JOIN tbl_DRFProcessClientMailStatusDetails DRFCMSD WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFCMSD.DRFId    
    
LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)    
 ON DRFIRPM.DRFId = DRFMCPT.DRFId       
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)    
ON RDRFOPRD.DRFId = DRFIRPM.DRFId       
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)    
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId     
LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)    
 ON DRFIRPM.DRFId = RTARDSD.DRFId     
WHERE 
-----RDRFOPRD.IsFileGenerate=0  
(RDRFOPRD.IsFileGenerate=0 OR CAST(RDRFOPRD.FileGenerateDate as date)=CAST(GETDATE() as date))
'+@Condition+'    
)  A WHERE ISNULL(StatusCode,''0'') <>''0''    
)B ON DRFORRPD.DRFId = B.DRFId    
WHERE DRFORRPD.IsFileGenerate=0      
    
        
INSERT INTO ClientDRFProcessBlueDartCourierDetails    
SELECT ROW_NUMBER() OVER(ORDER BY DRFNo) ''SRNo'',ClientName,    
ISNULL((City +''-''+PinCode),''MUMBAI'') ''CityPincode'',DRFNo FROM(      
SELECT DISTINCT DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName    
,AMCD.l_city ''City'',    
AMCD.l_zip ''PinCode''    
, DRFIRPM.MobileNo ''MobileNo''    
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)    
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)    
ON DRFIRPM.DRFId = RDRFOPRD.DRFId       
JOIN tbl_DRFProcessClientMailStatusDetails DRFCMSD WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFCMSD.DRFId        
LEFT JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)    
ON DRFCMSD.cltCode = AMCD.cl_code    
LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)    
 ON DRFIRPM.DRFId = DRFMCPT.DRFId     
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)    
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId    
WHERE RDRFOPRD.IsFileGenerate IN(1,2,3,4)     
 ' + @Condition +'    
AND CAST(RDRFOPRD.FileGenerateDate AS DATE) = CAST(GETDATE() AS DATE)     
AND RDRFOPRD.IsResponseUpload=0    
)AA     
    
')     
    
    
IF EXISTS(SELECT * FROM ClientDRFProcessBlueDartCourierDetails)    
BEGIN     
    
  -- Changes New Query - Comment for next process - 01/11/2022        
  /*        
SELECT ROW_NUMBER() OVER(Order by DRFNo) 'SRNo',* INTO #TEST FROM (    
  SELECT DISTINCT  stuff((    
SELECT '/ ' + CDRPD.DRFNo    
FROM ClientDRFProcessBlueDartCourierDetails  CDRPD WITH(NOLOCK)    
   WHERE CDRPD.CityPincode = AA.CityPincode     
   AND CDRPD.ClientName = AA.ClientName    
ORDER by CDRPD.ClientName,CityPincode    
for xml path ('')    
  ),1,1,'') 'DRFNo'    
  ,AA.ClientName,AA.CityPincode    
  FROM    
  (    
  SELECT * FROM     
   ClientDRFProcessBlueDartCourierDetails WITH(NOLOCK)    
  )AA    
  )BB    
    
  TRUNCATE TABLE ClientDRFProcessBlueDartCourierDetails    
    
  INSERT INTO ClientDRFProcessBlueDartCourierDetails    
  SELECT SRNo,ClientName,CityPincode,DRFNo FROM #TEST  */        
    
 DECLARE @SQLCMD varchar(MAX),    
@EmailAttachmentName varchar(200)    
    
DECLARE @xml NVARCHAR(MAX)    
DECLARE @body NVARCHAR(MAX)     
DECLARE @CurrentDate VARCHAR(10) = REPLACE(CONVERT(VARCHAR(10), GETDATE(),103),'/','.')    
DECLARE @Subject VARCHAR(MAX)= 'Soft data copy in excel sheet a/c 318883 Dt '+@CurrentDate    
    
SELECT @EmailAttachmentName = 'DRF DISPATCH_' + REPLACE(CONVERT(VARCHAR(10), getdate(),103),'/','') +'.xls',    
@SQLCMD = 'SELECT DISTINCT SRNo,ClientName,CityPincode,DRFNo FROM [MIS].ProcessAutomation.dbo.ClientDRFProcessBlueDartCourierDetails'    
       
    
SET @body ='<p style="font-size:medium; font-family:Calibri">       
       
 <b>Dear Sir</b>,<br /><br />       
       
 Please find the file attached herewith of BLUE DART DISPATCHED.    
 <br />    
 Note- Please don not forget to mention PINCODE    
  <br />      
    
 </H2>       
       
</body></html>       
       
<br />Regards,<br />    
Rajesh D. Thalkar<br />    
Angel Broking Ltd<br />    
DP DRF <br />    
TEL: 3941 3940 EXTN 5560'     
    
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL    
   @profile_name = 'AngelBroking',    
   @recipients = 'rajesh.thalkar@angelbroking.com; sm.nachiket@angelbroking.com;',      
   @blind_copy_recipients ='jagannath@angelbroking.com;',    
   @subject = @Subject,    
   @body = @body,    
   @body_format ='HTML',      
   @query = @SQLCMD,    
   @attach_query_result_as_file = 1,    
   @query_attachment_filename = @EmailAttachmentName,     
   @query_result_width =32767,    
   ---@query_result_header = 1,    
   @query_result_separator = ',',    
   @query_result_no_padding = 1    
       
       
END    
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndSaveClientExchangeScripObligationCalculationData
-- --------------------------------------------------

CREATE PROCEDURE USP_GenerateAndSaveClientExchangeScripObligationCalculationData            
@ReportType VARCHAR(20)='',@ProcessDate VARCHAR(10)='' ,        
@updClientExchangeObligationReport updClientExchangeObligationReport readonly ,    
@updClientFinalScriptObligationDetails updClientFinalScriptObligationDetails readonly    
AS          
BEGIN          
          
IF(@ReportType='ObligationReport')          
BEGIN          
SELECT * FROM tbl_ClientExchangeScripObligationFinalCalculationData WITH(NOLOCK)          
END          
ELSE IF(@ReportType='MisReport')          
BEGIN          
SELECT TOP 5 CONVERT(VARCHAR(10),ProcessDate,103) 'ProcessDate',          
COUNT(DISTINCT ClientCode) 'ClientCount',COUNT(DISTINCT ScripCode) 'ScriptCount',          
SUM(NetQty) 'Amount' ,      
CAST(ProcessDate as date) 'ProcessDate1'      
FROM tbl_ClientExchangeScripObligationReport          
GROUP BY CONVERT(VARCHAR(10),ProcessDate,103),CAST(ProcessDate as date)        
ORDER BY CAST(ProcessDate as date) desc      
END          
          
ELSE IF(@ReportType='ScriptReport')          
BEGIN          
          
SET @ProcessDate = CAST(CONVERT(datetime,@ProcessDate,103) as date)          
          
SELECT LTRIM(RTRIM(ClientCode)) 'ClientCode',LTRIM(RTRIM(ScripCode)) 'ScripCode',          
IIF(NetQty<0,-1*NetQty,NetQty) 'NetQty' ,Position INTO #ClientDetails1          
FROM tbl_ClientExchangeScripObligationReport WITH(NOLOCK)           
WHERE CAST(ProcessDate as date)=@ProcessDate          
          
--          
          
SELECT *,ClientCode +'-'+ISIN_No 'Client_ISIN'  INTO #ClientIsinDetails1  FROM (          
SELECT CD.*,Isin 'ISIN_No'           
FROM #ClientDetails1 CD          
JOIN [AngelDemat].[MSAJAG].dbo.MultiIsin MISIN WITH(Nolock)          
ON CD.ScripCode = MISIN.Scrip_cd          
WHERE Series='EQ' AND Valid=1          
)A          
          
          
SELECT Client_ISIN,ISNULL([FUT Long],0) 'FUT_Long' ,
(ISNULL([CE Long],0)+ISNULL([Call Long],0))  'CE_Long',
(ISNULL([PE Short],0)+ISNULL([Put Short],0)) 'PE_Short',
(ISNULL([CE Short],0)+ISNULL([Call Short],0)) 'CE_Short',
ISNULL([FUT Short],0) 'FUT_Short',          
(ISNULL([PE Long],0)+ISNULL([Put Long],0)) 'PE_Long',          
(ISNULL([FUT Long],0)+ISNULL([CE Long],0)+ISNULL([PE Short],0)+ISNULL([Call Long],0)+ISNULL([Put Short],0))-(ISNULL([CE Short],0)+ISNULL([FUT Short],0)+ISNULL([PE Long],0)+ISNULL([Call Short],0)+ISNULL([Put Long],0)) 'Final'          

INTO #FinalDetails1          
FROM (          
SELECT Client_ISIN,Position,NetQty FROM #ClientIsinDetails1          
)A          
PIVOT (SUM(NetQty) FOR Position IN([FUT Long],[CE Long],[PE Short],[CE Short],
[FUT Short],[PE Long],[Call Short],[Put Long],[Call Long],[Put Short])          
)as PVDetails            
          
SELECT * FROM #FinalDetails1          
          
END       
ELSE IF(@ReportType='ObligationUpload')    
BEGIN    
SELECT * INTO #ObligationDetails FROM @updClientFinalScriptObligationDetails    
    
TRUNCATE TABLE tbl_ClientExchangeScripObligationFinalCalculationData    
    
INSERT INTO tbl_ClientExchangeScripObligationFinalCalculationData    
SELECT *,GETDATE() FROM #ObligationDetails WHERE ISNULL(PARTY_CODE,'') <>''  
END    
ELSE          
BEGIN          
DECLARE @SettlementNo VARCHAR(25)=''    
     
SELECT * INTO #Test FROM @updClientExchangeObligationReport       
    
SET @SettlementNo = (SELECT TOP 1 SETT_NO FROM tbl_ClientExchangeScripObligationFinalCalculationData)    
          
INSERT INTO tbl_ClientExchangeScripObligationReport          
SELECT ClientCode,ScripCode,--CAST(CONVERT(datetime,ExpiryDate,103) as date),          
ExpiryDate,          
StrikePrice,NetQty,Position,GETDATE() FROM #Test          
          
SELECT LTRIM(RTRIM(ClientCode)) 'ClientCode',LTRIM(RTRIM(ScripCode)) 'ScripCode',          
IIF(NetQty<0,-1*NetQty,NetQty) 'NetQty' ,Position INTO #ClientDetails          
FROM #Test          
          
--          
          
SELECT *,ClientCode +'-'+ISIN_No 'Client_ISIN'  INTO #ClientIsinDetails  FROM (          
SELECT CD.*,Isin 'ISIN_No'           
FROM #ClientDetails CD          
JOIN [AngelDemat].[MSAJAG].dbo.MultiIsin MISIN WITH(Nolock)          
ON CD.ScripCode = MISIN.Scrip_cd          
WHERE Series='EQ' AND Valid=1          
)A          
          
          
SELECT Client_ISIN,ISNULL([FUT Long],0) 'FUT Long' ,
(ISNULL([CE Long],0)+ISNULL([Call Long],0))  'CE Long',
(ISNULL([PE Short],0)+ISNULL([Put Short],0)) 'PE Short',
(ISNULL([CE Short],0)+ISNULL([Call Short],0)) 'CE Short',
ISNULL([FUT Short],0) 'FUT Short',          
(ISNULL([PE Long],0)+ISNULL([Put Long],0)) 'PE Long',          
(ISNULL([FUT Long],0)+ISNULL([CE Long],0)+ISNULL([PE Short],0)+ISNULL([Call Long],0)+ISNULL([Put Short],0))-(ISNULL([CE Short],0)+ISNULL([FUT Short],0)+ISNULL([PE Long],0)+ISNULL([Call Short],0)+ISNULL([Put Long],0)) 'Final'     
INTO #FinalDetails          
FROM (          
SELECT Client_ISIN,Position,NetQty FROM #ClientIsinDetails          
)A          
PIVOT (SUM(NetQty) FOR Position IN([FUT Long],[CE Long],[PE Short],[CE Short],
[FUT Short],[PE Long],[Call Short],[Put Long],[Call Long],[Put Short])          
)as PVDetails          

          
SELECT @SettlementNo 'SETT_NO', 'M' 'SETT_TYPE',          
ClientCode,ScripCode, 'EQ' 'SERIES', (-1*Final) 'PayinQty', ISIN_No'ISIN'           
INTO #FinalObligationDetails          
FROM(          
SELECT DISTINCT ClientCode,ScripCode, ISIN_No,Client_ISIN          
FROM #ClientIsinDetails )CD          
JOIN #FinalDetails FD          
ON CD.Client_ISIN=FD.Client_ISIN          
 WHERE Final<0          
          
          
 UPDATE CESOFCD SET PayinQty=CESOFCD.PayinQty+FOD.PayinQty          
 FROM tbl_ClientExchangeScripObligationFinalCalculationData CESOFCD          
 JOIN #FinalObligationDetails FOD          
 ON CESOFCD.PARTY_CODE = FOD.ClientCode AND CESOFCD.ISIN = FOD.ISIN          
          
          
 INSERT INTO tbl_ClientExchangeScripObligationFinalCalculationData          
 SELECT *,GETDATE() FROM #FinalObligationDetails FOD          
 WHERE NOT EXISTS(SELECT * FROM tbl_ClientExchangeScripObligationFinalCalculationData CESOFCD          
 WHERE CESOFCD.PARTY_CODE = FOD.ClientCode AND CESOFCD.ISIN = FOD.ISIN)          
 AND ISNULL(FOD.ClientCode,'')<>''  
    
 END          
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndSendAutoMailSBLimitEnhencement
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GenerateAndSendAutoMailSBLimitEnhencement]  
AS  
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @subBrokerEmailId VARCHAR(255)  
declare @createdDate VARCHAR(50) = cast(getdate() as date)  
declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @createdDate)))),21))    
  
IF NOT EXISTS (SELECT * FROM SubBrokerLimitEnhencementSummaryReport WITH(NOLOCK) WHERE CAST(EnhencementDate as date) = CAST(GETDATE() as date) )  
BEGIN  
  
declare @time varchar(20) = (SELECT cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar))  
IF(@time>'17:00')  
BEGIN  
select UPPER(a.SBCode) as SBTAG,(a.clientcode) as CLIENT_CODE,(b.long_name) as CLIENT_NAME, sum( CAST(a.EnterLimit as decimal(17,2))) as TOTAL_LIMIT  INTO #LIMIT_DATA     
from [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)    
    
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code    
    
inner join SB_COMP.DBO.SB_Broker c on a.SBCode=c.SBTAG    
    
where a.CreatedDT>=@createdDate    
    
and a.CreatedDT<=@NextDate    
and a.EnterLimit>0.00 and a.LimitResponse=1   
group by a.SBCode,a.clientcode,b.long_name    
  
SELECT ROW_NUMBER() OVER(ORDER BY SBTAG) 'SRNo', SBTAG INTO #SBTagDetails   
FROM (SELECT DISTINCT SBTAG FROM #LIMIT_DATA ) A  
  
DECLARE @MAXSRNo int = (SELECT MAX(SRNo) 'MaxSRNo' FROM #SBTagDetails)  
DECLARE @SRNo int =1  
DECLARE @SBTAG VARCHAR(30)  
  
WHILE (@SRNo <=@MAXSRNo)  
BEGIN  
  
SET @SBTAG  = (SELECT SBTAG FROM #SBTagDetails WHERE SRNo = @SRNo);  
   
  with ranked_contacts as      
 (select SBCT.RefNo      
   , SBCT.addtype      
   , SBCT.EmailId      
   ,SBBR.SBTAG      
       , rank() over      
        (      
         partition by SBCT.RefNo      
         order by      
           (CASE WHEN SBCT.addtype = 'RES' THEN 1 WHEN SBCT.addtype= 'OFF' THEN 2 WHEN SBCT.addtype ='TER' THEN 3 END      
                 )      
         ) priority      
   FROM SB_COMP.DBO.SB_CONTACT SBCT WITH(NOLOCK)      
JOIN SB_COMP.DBO.SB_BROKER SBBR WITH(NOLOCK)      
ON SBCT.RefNo = SBBR.RefNo       
 WHERE SBBR.SBTAG =@SBTAG  AND SBCT.addtype IN('RES','OFF','TER')    
--WHERE SBBR.SBTAG IN('AKJ','AMRHM','DFC')      
)      
      
select EmailId INTO #SBEmailId  
 FROM ranked_contacts      
 WHERE priority = 1    
 AND ISNULL(EmailId,'') <>'';  
   
 SET @subBrokerEmailId  = (SELECT EmailId FROM #SBEmailId)  
  
   
DECLARE @xml NVARCHAR(MAX)    
    
DECLARE @body NVARCHAR(MAX)    
    
    
SELECT SBTAG, CLIENT_CODE , CLIENT_NAME , FORMAT(TOTAL_LIMIT, '#,###,##0')  as 'TOTAL_LIMIT' INTO #Temp FROM #LIMIT_DATA WHERE  SBTAG = @SBTAG   
     
    
 SET @xml = CAST(( SELECT [CLIENT_CODE] AS 'td','', [CLIENT_NAME] AS 'td','', [TOTAL_LIMIT] AS 'td'    
    
FROM #Temp    
    
--ORDER BY BalanceDate    
    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    
    
SET @body ='<p style="font-size:medium; font-family:Calibri">    
    
 <b>Dear Business Partner </b>,<br /><br />    
    
 LE Limit has given to client and shortage of margin will be charged penalty so its your responsibility to recover require margin to avoid margin shortage penalty from your Sub Broker ledger. Below is the clients detail :-    
    
 </H3>    
 <br />    
 SBTAG : ' + @SBTag +'    
    
 </H2>    
    
<table border=1   cellpadding=2 cellspacing=2>    
    
<tr style="background-color:rgb(201, 76, 76); color :White">    
    
<th> CLIENT_CODE </th> <th> CLIENT_NAME </th> <th> TOTAL_LIMIT </th>'    
    
       
    
 SET @body = @body + @xml +'</table></body></html>    
    
<br />Thanks & Regards,<br /><br />    
    
System Generated Mail'    
    
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL    
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   
    
@profile_name = 'AngelBroking',    
    
@body = @body,    
    
@body_format ='HTML',    
    
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',    
--@recipients = 'pegasusinfocorp.suraj@angelbroking.com',    
@recipients = @subBrokerEmailId,    
    
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',    
@blind_copy_recipients ='hemantp.patel@angelbroking.com',    
    
@subject = 'Sub Broker Limit Enhancement' ;    
    
SET @SRNo =@SRNo+1;  
  
DROP Table #SBEmailId  
DROP TABLE #Temp  
  
END  
INSERT INTO SubBrokerLimitEnhencementSummaryReport   
SELECT DISTINCT GETDATE(), COUNT(DISTINCT SBTAG) 'SBCount', COUNT(DISTINCT CLIENT_NAME) 'ClientCount', SUM(TOTAL_LIMIT) 'TotalLimit' FROM #LIMIT_DATA  
  
DROP table #LIMIT_DATA  
DROP table #SBTagDetails  
END  
END  
END
/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndSendAutoMailSBLimitEnhencement_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GenerateAndSendAutoMailSBLimitEnhencement_06Nov2025]  
AS  
BEGIN  
DECLARE @subBrokerEmailId VARCHAR(255)  
declare @createdDate VARCHAR(50) = cast(getdate() as date)  
declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @createdDate)))),21))    
  
IF NOT EXISTS (SELECT * FROM SubBrokerLimitEnhencementSummaryReport WITH(NOLOCK) WHERE CAST(EnhencementDate as date) = CAST(GETDATE() as date) )  
BEGIN  
  
declare @time varchar(20) = (SELECT cast(DATEPART(hour, GETDATE()) as varchar) + ':' + cast(DATEPART(minute, GETDATE()) as varchar))  
IF(@time>'17:00')  
BEGIN  
select UPPER(a.SBCode) as SBTAG,(a.clientcode) as CLIENT_CODE,(b.long_name) as CLIENT_NAME, sum( CAST(a.EnterLimit as decimal(17,2))) as TOTAL_LIMIT  INTO #LIMIT_DATA     
from [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)    
    
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code    
    
inner join SB_COMP.DBO.SB_Broker c on a.SBCode=c.SBTAG    
    
where a.CreatedDT>=@createdDate    
    
and a.CreatedDT<=@NextDate    
and a.EnterLimit>0.00 and a.LimitResponse=1   
group by a.SBCode,a.clientcode,b.long_name    
  
SELECT ROW_NUMBER() OVER(ORDER BY SBTAG) 'SRNo', SBTAG INTO #SBTagDetails   
FROM (SELECT DISTINCT SBTAG FROM #LIMIT_DATA ) A  
  
DECLARE @MAXSRNo int = (SELECT MAX(SRNo) 'MaxSRNo' FROM #SBTagDetails)  
DECLARE @SRNo int =1  
DECLARE @SBTAG VARCHAR(30)  
  
WHILE (@SRNo <=@MAXSRNo)  
BEGIN  
  
SET @SBTAG  = (SELECT SBTAG FROM #SBTagDetails WHERE SRNo = @SRNo);  
   
  with ranked_contacts as      
 (select SBCT.RefNo      
   , SBCT.addtype      
   , SBCT.EmailId      
   ,SBBR.SBTAG      
       , rank() over      
        (      
         partition by SBCT.RefNo      
         order by      
           (CASE WHEN SBCT.addtype = 'RES' THEN 1 WHEN SBCT.addtype= 'OFF' THEN 2 WHEN SBCT.addtype ='TER' THEN 3 END      
                 )      
         ) priority      
   FROM SB_COMP.DBO.SB_CONTACT SBCT WITH(NOLOCK)      
JOIN SB_COMP.DBO.SB_BROKER SBBR WITH(NOLOCK)      
ON SBCT.RefNo = SBBR.RefNo       
 WHERE SBBR.SBTAG =@SBTAG  AND SBCT.addtype IN('RES','OFF','TER')    
--WHERE SBBR.SBTAG IN('AKJ','AMRHM','DFC')      
)      
      
select EmailId INTO #SBEmailId  
 FROM ranked_contacts      
 WHERE priority = 1    
 AND ISNULL(EmailId,'') <>'';  
   
 SET @subBrokerEmailId  = (SELECT EmailId FROM #SBEmailId)  
  
   
DECLARE @xml NVARCHAR(MAX)    
    
DECLARE @body NVARCHAR(MAX)    
    
    
SELECT SBTAG, CLIENT_CODE , CLIENT_NAME , FORMAT(TOTAL_LIMIT, '#,###,##0')  as 'TOTAL_LIMIT' INTO #Temp FROM #LIMIT_DATA WHERE  SBTAG = @SBTAG   
     
    
 SET @xml = CAST(( SELECT [CLIENT_CODE] AS 'td','', [CLIENT_NAME] AS 'td','', [TOTAL_LIMIT] AS 'td'    
    
FROM #Temp    
    
--ORDER BY BalanceDate    
    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    
    
SET @body ='<p style="font-size:medium; font-family:Calibri">    
    
 <b>Dear Business Partner </b>,<br /><br />    
    
 LE Limit has given to client and shortage of margin will be charged penalty so its your responsibility to recover require margin to avoid margin shortage penalty from your Sub Broker ledger. Below is the clients detail :-    
    
 </H3>    
 <br />    
 SBTAG : ' + @SBTag +'    
    
 </H2>    
    
<table border=1   cellpadding=2 cellspacing=2>    
    
<tr style="background-color:rgb(201, 76, 76); color :White">    
    
<th> CLIENT_CODE </th> <th> CLIENT_NAME </th> <th> TOTAL_LIMIT </th>'    
    
       
    
 SET @body = @body + @xml +'</table></body></html>    
    
<br />Thanks & Regards,<br /><br />    
    
System Generated Mail'    
    
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL    
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   
    
@profile_name = 'AngelBroking',    
    
@body = @body,    
    
@body_format ='HTML',    
    
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',    
--@recipients = 'pegasusinfocorp.suraj@angelbroking.com',    
@recipients = @subBrokerEmailId,    
    
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',    
@blind_copy_recipients ='hemantp.patel@angelbroking.com',    
    
@subject = 'Sub Broker Limit Enhancement' ;    
    
SET @SRNo =@SRNo+1;  
  
DROP Table #SBEmailId  
DROP TABLE #Temp  
  
END  
INSERT INTO SubBrokerLimitEnhencementSummaryReport   
SELECT DISTINCT GETDATE(), COUNT(DISTINCT SBTAG) 'SBCount', COUNT(DISTINCT CLIENT_NAME) 'ClientCount', SUM(TOTAL_LIMIT) 'TotalLimit' FROM #LIMIT_DATA  
  
DROP table #LIMIT_DATA  
DROP table #SBTagDetails  
END  
END  
END
/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndSendCDSLAcceptedToRTAProcess
-- --------------------------------------------------
      
CREATE PROCEDURE [dbo].[USP_GenerateAndSendCDSLAcceptedToRTAProcess]  @GeneratedBy VARCHAR(35)=''          
AS   
BEGIN  
    
---EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''     
TRUNCATE TABLE ClientDRFProcessBlueDartCourierDetails    
      
INSERT INTO tbl_DRFOutwordRegistrationSendToRTADetails      
SELECT DISTINCT DRFRPM.DRFId,5,'DRF Dispatch to RTA - Maker',GETDATE()      
,0,'','','','','','',0,'','','','','','','','','','','',@GeneratedBy,''      
FROM     
--tbl_DRFMakerCheckerProcess_temp TDRFMCPT WITH(NOLOCK)      
--Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)   
tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)     
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)      
 ON DRFRPM.DRFId = DRFMCPT.DRFId      
WHERE DRFMCPT.BatchUploadInCDSL=1 AND DRFMCPT.IsCDSLRejected=0 AND DRFMCPT.IsCDSLProcess=1      
AND DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=0   AND ISNULL(DRFMCPT.DRNNo,'')<>''    
AND DRFRPM.DRFId NOT IN(SELECT DRFId FROM tbl_DRFOutwordRegistrationSendToRTADetails)   
----   
    
      
INSERT INTO ClientDRFProcessBlueDartCourierDetails       
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFNo) 'SRNo',CompanyName,   
City +'-'+PinCode 'CityPincode' ,DRFNo  
-- INTO #Temp   
FROM(   
SELECT DISTINCT DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,   
DEM.ENTM_NAME1 'CompanyName',   
DRFIRPM.NoOfCertificates, DRFMCPT.DRNNo 'DRNNo',   
DISINM.isin_adrcity 'City',DISINM.isin_adrzip 'PinCode'   
       
FROM tbl_DRFOutwordRegistrationSendToRTADetails DRFRSTRTAD WITH(NOLOCK)   
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)   
ON DRFIRPM.DRFId = DRFRSTRTAD.DRFId  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)   
ON DRFIRPD.DRFId = DRFIRPM.DRFId   
JOIN [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR DISINM WITH(NOLOCK)   
ON DISINM.ISIN_CD = DRFIRPD.ISINNo   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].entity_mstr DEM WITH(NOLOCK)   
ON ENTM_ENTTM_CD ='rta' and ENTM_SHORT_NAME ='rta_'+CONVERT(varchar,ISIN_REG_CD )  
--JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)  
--ON DRFMCPT.DRFId = DRFIRPM.DRFId     
--JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)   
--ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0    
 --LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)          
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId    
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId   
WHERE DRFRSTRTAD.IsResponseUpload=0   
AND CAST(DRFRSTRTAD.FileGenerateDate as date) = CAST(GETDATE() as date)   
AND DRFMCPT.RTALetterGenerate=1   AND DRFMCPT.IsRTAProcess=0 AND ISNUMERIC(ISIN_REG_CD)=1      
)A   
   
IF EXISTS(SELECT * FROM ClientDRFProcessBlueDartCourierDetails)   
BEGIN   
    
DECLARE @SQLCMD varchar(MAX),  
        @EmailAttachmentName varchar(200)    
     
DECLARE @xml NVARCHAR(MAX)     
DECLARE @body NVARCHAR(MAX)      
DECLARE @CurrentDate VARCHAR(10) = REPLACE(CONVERT(VARCHAR(10), GETDATE(),103),'/','.')   
DECLARE @Subject VARCHAR(MAX)= 'Soft data copy in excel sheet a/c 318883 Dt '+@CurrentDate   
     
SELECT @EmailAttachmentName = 'DRF DISPATCH_' + REPLACE(CONVERT(VARCHAR(10), getdate(),103),'/','') +'.xls',  
@SQLCMD = 'SELECT DISTINCT SRNo,ClientName,CityPincode,DRFNo FROM [MIS].ProcessAutomation.dbo.ClientDRFProcessBlueDartCourierDetails'   
          
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear Sir</b>,<br /><br />  
  
 Please find the file attached herewith of DISPATCHED.  
 <br />  
 Note- Please don not forget to mention PINCODE  
  <br />      
          
 </H2>  
  
</body></html>  
  
<br />Regards,<br />      
Rajesh D. Thalkar<br />    
Angel Broking Ltd<br />    
DP DRF <br />    
TEL: 3941 3940 EXTN 5560'      
  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   
@profile_name = 'AngelBroking',  
@recipients = 'rajesh.thalkar@angelbroking.com; sm.nachiket@angelbroking.com;',      
--@blind_copy_recipients ='jagannath@angelbroking.com; pegasusinfocorp.suraj@angelbroking.com',     
@subject = @Subject,  
@body = @body,  
@body_format ='HTML',       
@query = @SQLCMD,  
@attach_query_result_as_file = 1,  
@query_attachment_filename = @EmailAttachmentName,     
   @query_result_width =32767,    
---@query_result_header = 1,  
@query_result_separator = ',',  
@query_result_no_padding = 1    
       
     
END   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateAndSendMailForNBFCShortageProcessDetails
-- --------------------------------------------------
      
CREATE PROCEDURE USP_GenerateAndSendMailForNBFCShortageProcessDetails       
@NBFCShortageProcessDetails NBFCShortageProcessDetails readonly      
AS      
BEGIN      
      
--INSERT INTO NBFCShortageProcessDetails SELECT PARTY_CODE,CONVERT(NVARCHAR(50),MARGINDATE,103) 'MARGINDATE',TOTAL_SHORTAGE,GETDATE() FROM @NBFCShortageProcessDetails      
INSERT INTO NBFCShortageProcessDetails SELECT PARTY_CODE, MARGINDATE,TOTAL_SHORTAGE,GETDATE() FROM @NBFCShortageProcessDetails      
      
SELECT PARTY_CODE, CONVERT(NVARCHAR(50),MARGINDATE,103)'MARGINDATE',TOTAL_SHORTAGE  INTO #Temp FROM @NBFCShortageProcessDetails      
      
DECLARE @xml NVARCHAR(MAX)      
      
DECLARE @body NVARCHAR(MAX)      
      
SET @xml = CAST(( SELECT [Party_Code] AS 'td','',[MARGINDATE] AS 'td','', [Total_Shortage] AS 'td'      
      
FROM #Temp      
      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))      
      
SET @body ='<p style="font-size:medium; font-family:Calibri">                                      
      
Dear Team,<br /><br />                                       
      
Below is NBFC Shortage Process details                                      
      
</H3>      
      
<table border=1   cellpadding=2 cellspacing=2>      
      
<tr style="background-color:rgb(201, 76, 76); color :White">      
      
<th> Client Code </th> <th> Shortage Date </th> <th> Shortage Amount </th></tr>'      
      
SET @body = @body + @xml +'</table></body></html>      
<br />Thanks & Regards,<br /><br />      
      
System Generated Mail'      
      
EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL      
      
@profile_name = 'AngelBroking', -- replace with your SQL Database Mail Profile      
      
@body = @body,      
@body_format ='HTML',      
      
@recipients ='hemantp.patel@angelbroking.com;sandip.tote@angelbroking.com;krunald.patel@angelbroking.com;pegasusinfocorp.suraj@angelbroking.com', -- replace with your email address      
--@recipients ='pegasusinfocorp.suraj@angelbroking.com',       
      
@blind_copy_recipients ='hemantp.patel@angelbroking.com',      
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',      
      
@subject = 'NBFC Shortage Details' ;      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateGeneralizeDataForExport
-- --------------------------------------------------

CREATE PROCEDURE USP_GenerateGeneralizeDataForExport @GeneralizeQuery VARCHAR(MAX)
AS

BEGIN
EXEC(@GeneralizeQuery)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateMailForSubBrokerFinalShortage_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GenerateMailForSubBrokerFinalShortage_06Nov2025]   
@SubBrokerFinalShortageEnhancement SubBrokerFinalShortageEnhancement readonly,   
@subBrokerEmailId VARCHAR(MAX)  
AS  
BEGIN  
DECLARE @xml NVARCHAR(MAX)  
  
DECLARE @body NVARCHAR(MAX)  
  
DECLARE @SBTag NVARCHAR(50)  
  
DECLARE @Subject NVARCHAR(MAX)  
  
  
SELECT SBTAG, CLIENT_CODE , CLIENT_NAME, DATE , FORMAT(TOTAL_LIMIT, '#,###,##0')  as 'TOTAL_LIMIT'  
,FORMAT(INITIAL_SHORTAGE, '#,###,##0')  as 'INITIAL_SHORTAGE', FORMAT(MTM_SHORTAGE , '#,###,##0') as 'MTM_SHORTAGE'  
,FORMAT(PEAK_SHORTAGE, '#,###,##0')  as 'PEAK_SHORTAGE' , FORMAT(TOTAL_PENALTY, '#,###,##0')  as 'MARGIN_PENALTY'  INTO #Temp FROM @SubBrokerFinalShortageEnhancement  
   
 SET @SBTag = (SELECT DISTINCT SBTAG FROM #Temp)  
  
 SET @xml = CAST(( SELECT [CLIENT_CODE] AS 'td','', [CLIENT_NAME] AS 'td','', [DATE] AS 'td','', [TOTAL_LIMIT] AS 'td','', [INITIAL_SHORTAGE] AS 'td','', [MTM_SHORTAGE] AS 'td','', [PEAK_SHORTAGE] AS 'td','', [MARGIN_PENALTY] AS 'td'  
  
FROM #Temp  
  
--ORDER BY BalanceDate  
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear Business Partner </b>,<br /><br />  
  
 LE Limit has given to client and due to that client charged margin shortage penalty, now penalty will be recovered from your SB Brokerage ledger and reverse to client. Below is the clients detail :-  
  
 </H3>  
 <br />  
 SBTAG : ' + @SBTag +'  
  
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> CLIENT_CODE </th> <th> CLIENT_NAME </th> <th> DATE </th> <th> TOTAL_LIMIT </th> <th> INITIAL_SHORTAGE </th> <th> MTM_SHORTAGE </th> <th> PEAK_SHORTAGE </th> <th> MARGIN_PENALTY </th>'  
  
     
  
 SET @body = @body + @xml +'</table></body></html>  
  
  
<br />Thanks & Regards,<br /><br />  
  
System Generated Mail'  
  
SET @Subject = 'Recovery of Margin penalty against your SB Tag : '+@SBTag  
  
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   --- 10.253.33.27  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',  
@recipients = @subBrokerEmailId,  
  
@blind_copy_recipients ='hemantp.patel@angelbroking.com; b2brisk@angelbroking.com',  
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',  
  
@subject = @Subject;  
  
DROP table #Temp  
END  

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateMailForSubBrokerFinalShortage_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GenerateMailForSubBrokerFinalShortage]   
@SubBrokerFinalShortageEnhancement SubBrokerFinalShortageEnhancement readonly,   
@subBrokerEmailId VARCHAR(MAX)  
AS  
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @xml NVARCHAR(MAX)  
  
DECLARE @body NVARCHAR(MAX)  
  
DECLARE @SBTag NVARCHAR(50)  
  
DECLARE @Subject NVARCHAR(MAX)  
  
  
SELECT SBTAG, CLIENT_CODE , CLIENT_NAME, DATE , FORMAT(TOTAL_LIMIT, '#,###,##0')  as 'TOTAL_LIMIT'  
,FORMAT(INITIAL_SHORTAGE, '#,###,##0')  as 'INITIAL_SHORTAGE', FORMAT(MTM_SHORTAGE , '#,###,##0') as 'MTM_SHORTAGE'  
,FORMAT(PEAK_SHORTAGE, '#,###,##0')  as 'PEAK_SHORTAGE' , FORMAT(TOTAL_PENALTY, '#,###,##0')  as 'MARGIN_PENALTY'  INTO #Temp FROM @SubBrokerFinalShortageEnhancement  
   
 SET @SBTag = (SELECT DISTINCT SBTAG FROM #Temp)  
  
 SET @xml = CAST(( SELECT [CLIENT_CODE] AS 'td','', [CLIENT_NAME] AS 'td','', [DATE] AS 'td','', [TOTAL_LIMIT] AS 'td','', [INITIAL_SHORTAGE] AS 'td','', [MTM_SHORTAGE] AS 'td','', [PEAK_SHORTAGE] AS 'td','', [MARGIN_PENALTY] AS 'td'  
  
FROM #Temp  
  
--ORDER BY BalanceDate  
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear Business Partner </b>,<br /><br />  
  
 LE Limit has given to client and due to that client charged margin shortage penalty, now penalty will be recovered from your SB Brokerage ledger and reverse to client. Below is the clients detail :-  
  
 </H3>  
 <br />  
 SBTAG : ' + @SBTag +'  
  
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> CLIENT_CODE </th> <th> CLIENT_NAME </th> <th> DATE </th> <th> TOTAL_LIMIT </th> <th> INITIAL_SHORTAGE </th> <th> MTM_SHORTAGE </th> <th> PEAK_SHORTAGE </th> <th> MARGIN_PENALTY </th>'  
  
     
  
 SET @body = @body + @xml +'</table></body></html>  
  
  
<br />Thanks & Regards,<br /><br />  
  
System Generated Mail'  
  
SET @Subject = 'Recovery of Margin penalty against your SB Tag : '+@SBTag  
  
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL  
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   --- 10.253.33.27  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',  
@recipients = @subBrokerEmailId,  
  
@blind_copy_recipients ='hemantp.patel@angelbroking.com; b2brisk@angelbroking.com',  
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',  
  
@subject = @Subject;  
  
DROP table #Temp  
END  

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateMailForSubBrokerLimitEnh
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GenerateMailForSubBrokerLimitEnh] 
@SubBrokerLimitEnhancement SubBrokerLimitEnhancement readonly, @subBrokerEmailId VARCHAR(MAX)
AS
BEGIN
DECLARE @xml NVARCHAR(MAX)

DECLARE @body NVARCHAR(MAX)

DECLARE @SBTag NVARCHAR(50)

SELECT SBTAG, CLIENT_CODE , CLIENT_NAME , FORMAT(TOTAL_LIMIT, '#,###,##0')  as 'TOTAL_LIMIT' INTO #Temp FROM @SubBrokerLimitEnhancement
 
 SET @SBTag = (SELECT DISTINCT SBTAG FROM #Temp)

 SET @xml = CAST(( SELECT [CLIENT_CODE] AS 'td','', [CLIENT_NAME] AS 'td','', [TOTAL_LIMIT] AS 'td'

FROM #Temp

--ORDER BY BalanceDate

FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))

SET @body ='<p style="font-size:medium; font-family:Calibri">

 <b>Dear Business Partner </b>,<br /><br />

 LE Limit has given to client and shortage of margin will be charged penalty so its your responsibility to recover require margin to avoid margin shortage penalty from your Sub Broker ledger. Below is the clients detail :-

 </H3>
 <br />
 SBTAG : ' + @SBTag +'

 </H2>

<table border=1   cellpadding=2 cellspacing=2>

<tr style="background-color:rgb(201, 76, 76); color :White">

<th> CLIENT_CODE </th> <th> CLIENT_NAME </th> <th> TOTAL_LIMIT </th>'

   

 SET @body = @body + @xml +'</table></body></html>

<br />Thanks & Regards,<br /><br />

System Generated Mail'

--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL

@profile_name = 'AngelBroking',

@body = @body,

@body_format ='HTML',

--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',
@recipients = @subBrokerEmailId,

--@blind_copy_recipients ='hemantp.patel@angelbroking.com',
@blind_copy_recipients ='hemantp.patel@angelbroking.com',

@subject = 'Sub Broker Limit Enhancement' ;

DROP table #Temp
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetAllClientSegmentData
-- --------------------------------------------------

CREATE Procedure USP_GetAllClientSegmentData (@txtDateFilter varchar(50))          
AS          
BEGIN          
declare @financialDate nvarchar(20), @test nvarchar(20),@financialEndDate nvarchar(20)    
set @test = (select YEAR(@txtDateFilter))          
        
declare @Query1 varchar(255) ='',@Query2  varchar(255)='',@Query3 varchar(255)=''        
          
SET @financialDate = (select IIF(MONTH(@txtDateFilter)<4,DATEADD(year, -1, Convert(datetime,  '04' + '/' + '01' + '/' +  @test)),Convert(datetime,  '04' + '/' + '01' + '/' +  @test)))          
set @financialEndDate = (SELECT DATEADD(day, -1, @financialDate))           
       
Select distinct a.ClientCode 'party_code' INTO #ClientDetails from [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS a WITH(NOLOCK)           
where ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()          
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSE           
from [AngelNseCM].account.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BSE           
from [AngelBSECM].Account_AB.dbo.ledger WITH(NOLOCK)          
 join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code           
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
          
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSEFO           
from [AngelFO].AccountFO.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code           
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
          
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSX           
from [AngelFO].AccountcurFO.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
          
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #MCX           
from [AngelCommodity].AccountMCDX.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NCX           
from [AngelCommodity].AccountNCDX.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
GROUP BY CLTCODE           
        
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NBFC        
from [ABVSCITRUS].ACCOUNTNBFC.dbo.ledger WITH(NOLOCK)        
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate     
group by CLTCODE        
        
          
          
CREATE TABLE #FINAL          
(CLTCODE VARCHAR(10),          
NSE MONEY,          
BSE MONEY,          
NSEFO MONEY,          
NSX MONEY,          
MCX MONEY,          
NCX MONEY,          
NBFC MONEY        
)          
          
INSERT INTO  #FINAL          
SELECT DISTINCT ClTcode,0,0,0,0,0,0,0 FROM (          
SELECT * FROM #NSE          
UNION ALL          
SELECT * FROM #BSE          
UNION ALL          
SELECT * FROM #NSEFO          
UNION ALL          
SELECT * FROM #NSX          
UNION ALL          
SELECT * FROM #MCX          
UNION ALL          
SELECT * FROM #NCX          
UNION ALL        
SELECT * FROM #NBFC          
 )A          
          
 UPDATE #FINAL SET NSE =BAL FROM #NSE A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
 UPDATE #FINAL SET BSE =BAL FROM #BSE A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
 UPDATE #FINAL SET NSEFO =BAL FROM #NSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
 UPDATE #FINAL SET NSX =BAL FROM #NSX A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
UPDATE #FINAL SET MCX =BAL FROM #MCX A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
UPDATE #FINAL SET NCX =BAL FROM #NCX A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
UPDATE #FINAL SET NBFC =BAL FROM #NBFC A WHERE A.CLTCODE =#FINAL.CLTCODE           
          
         
SELECT CLTCODE,       
cast((SUM(NSE)+ SUM(NBFC)) as decimal(15,2)) NSE,          
cast(SUM(BSE) as decimal(17,2))BSE,          
cast(SUM(NSEFO) as decimal(17,2))NSEFO,          
cast(SUM(NSX) as decimal(17,2))NSX,          
cast(SUM(MCX) as decimal(17,2))MCX,          
cast(SUM(NCX) as decimal(17,2))NCX,        
CAST(SUM(NBFC) as decimal(17,2)) NBFC,        
CAST( SUM(NSE+NBFC+BSE+NSEFO+NSX+MCX+NCX) as decimal(15,2)) AS TotalEquity--,          
 INTO #TEMP          
   FROM #FINAL A          
  WHERE CLTCODE BETWEEN '0000' AND  'ZZ999'       
     GROUP BY CLTCODE ORDER BY CLTCODE ASC          
          
 select  *  FROM #TEMP          
       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetAndSendMailOfPendingLedgerStatus
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetAndSendMailOfPendingLedgerStatus      
AS      
BEGIN      
      
SELECT VOUCHERTYPE,ADDBY,VDATE,    
CASE WHEN ROWSTATE=0 THEN 'PENDING'    
WHEN ROWSTATE=1 THEN 'SUCCESS'    
WHEN ROWSTATE=9 THEN 'REJECT'    
WHEN ROWSTATE=2 THEN 'HOLD' END 'STATUS',     
CASE WHEN EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN 'NSE CASH'      
WHEN EXCHANGE='BSE' AND SEGMENT='CAPITAL' THEN 'BSE CASH'     
--WHEN EXCHANGE='BSE' AND SEGMENT='MFSS' THEN 'BSE MFSS'     
WHEN EXCHANGE='NSE' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NSEFO'      
WHEN EXCHANGE='BSE' AND SEGMENT IN('FUTURES','FUTURE') THEN 'BSEFO'    
WHEN EXCHANGE='MCX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'MCX'    
WHEN EXCHANGE='MCX' AND SEGMENT='CAPITAL' THEN 'MCX CASH'    
WHEN EXCHANGE='MCD' AND SEGMENT IN('FUTURES','FUTURE') THEN 'MCD'    
WHEN EXCHANGE='NCX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NCX'    
WHEN EXCHANGE='NCX' AND SEGMENT='CAPITAL' THEN 'NCX CASH'    
WHEN EXCHANGE='NSX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NSX'    
--WHEN EXCHANGE='BSX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'BSX'  
--WHEN EXCHANGE='NBF' AND SEGMENT IN('NBFC') THEN 'NBFC'    
ELSE EXCHANGE  
  
END 'SEGMENT',    
IIF(CREDIT_CLIENT>=DEBIT_CLIENT,CREDIT_CLIENT,DEBIT_CLIENT) 'CLIENT_COUNT'    
,CREDIT_AMT,DEBIT_AMT INTO #TEMP    
FROM (    
SELECT VOUCHERTYPE,ADDBY,ROWSTATE,EXCHANGE,SEGMENT, CONVERT(VARCHAR(10),VDATE,103) 'VDATE',    
COUNT(CASE WHEN CreditAmt <> 0 THEN 1 END) 'CREDIT_CLIENT',    
COUNT(CASE WHEN DebitAmt <> 0 THEN 1 END) 'DEBIT_CLIENT'    
, SUM(CreditAmt) 'CREDIT_AMT', SUM(DebitAmt) 'DEBIT_AMT'     
FROM [196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES WITH(NOLOCK)    
WHERE CAST(AddDt AS DATE) = CAST(GETDATE()-1 AS DATE)  AND ROWSTATE<>1    
 --AND DATEPART(HOUR, AddDt) < ((DATEPART(HOUR, GETDATE()))-1)    
GROUP BY VOUCHERTYPE,ADDBY,ROWSTATE,EXCHANGE,SEGMENT ,VDATE    
) A    
    
---drop table #Temp      
    
    
SELECT VOUCHERTYPE,ADDBY,    
CASE WHEN ROWSTATE=0 THEN 'PENDING'    
WHEN ROWSTATE=99 THEN 'REJECT'    
WHEN ROWSTATE=2 THEN 'SUCCESS' END 'STATUS',     
CASE WHEN EXCHANGE='NSE' AND SEGMENT='CAPITAL' THEN 'NSE CASH'      
WHEN EXCHANGE='BSE' AND SEGMENT='CAPITAL' THEN 'BSE CASH'     
--WHEN EXCHANGE='BSE' AND SEGMENT='MFSS' THEN 'BSE MFSS'     
WHEN EXCHANGE='NSE' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NSEFO'      
WHEN EXCHANGE='BSE' AND SEGMENT IN('FUTURES','FUTURE') THEN 'BSEFO'    
WHEN EXCHANGE='MCX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'MCX'    
WHEN EXCHANGE='MCX' AND SEGMENT ='CAPITAL' THEN 'MCX CASH'    
WHEN EXCHANGE='NCX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NCX'    
WHEN EXCHANGE='NSX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'NSX'    
--WHEN EXCHANGE='BSX' AND SEGMENT IN('FUTURES','FUTURE') THEN 'BSX'    
--WHEN EXCHANGE='NBF' AND SEGMENT IN('NBFC') THEN 'NBFC'   
ELSE EXCHANGE  
END 'SEGMENT',    
IIF(CREDIT_CLIENT>=DEBIT_CLIENT,CREDIT_CLIENT,DEBIT_CLIENT) 'CLIENT_COUNT'    
,CREDIT_AMT,DEBIT_AMT INTO #TEMP1    
FROM (    
SELECT VOUCHERTYPE,RETURN_FLD5 'ADDBY',ROWSTATE,EXCHANGE,SEGMENT,     
COUNT(CASE WHEN CreditAmt <> 0 THEN 1 END) 'CREDIT_CLIENT',    
COUNT(CASE WHEN DebitAmt <> 0 THEN 1 END) 'DEBIT_CLIENT'    
, SUM(CreditAmt) 'CREDIT_AMT', SUM(DebitAmt) 'DEBIT_AMT'     
FROM anand.MKTAPI.dbo.tbl_post_data WITH(NOLOCK)    
WHERE CAST(VDATE AS DATE) = CAST(GETDATE()-1 AS DATE)  AND ROWSTATE NOT IN(2) --AND CreditAmt<>0    
--AND DATEPART(HOUR, UploadDt) < DATEPART(HOUR, GETDATE())    
--AND DATEPART(HOUR, AddDt) = '13'    
GROUP BY VOUCHERTYPE,RETURN_FLD5,ROWSTATE,EXCHANGE,SEGMENT     
)B    
      
      
DECLARE @xml NVARCHAR(MAX)          
          
DECLARE @body NVARCHAR(MAX)          
             
IF EXISTS(SELECT * FROM #TEMP)         
BEGIN    
 SET @xml = CAST(( SELECT 'left' AS 'td/@align', [VOUCHERTYPE] AS 'td','', 'left' AS 'td/@align', [ADDBY] AS 'td',''    
 ,'left' AS 'td/@align', [VDATE] AS 'td','' ,'left' AS 'td/@align', [STATUS] AS 'td',''  , 'left' AS 'td/@align', [SEGMENT] AS 'td',''    
 , 'left' AS 'td/@align', [CLIENT_COUNT] AS 'td','', 'right' AS 'td/@align', [CREDIT_AMT] AS 'td' ,''     
 , 'right' AS 'td/@align', [DEBIT_AMT] AS 'td',''          
FROM #Temp          
          
--ORDER BY BalanceDate          
          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))          
          
SET @body ='<p style="font-size:medium; font-family:Calibri">          
          
 <b>Dear Team </b>,<br /><br />          
          
 This is the list of data which ledger status pending from long time for Back office posting.     
 <br />    
 Table : V2_OFFLINE_LEDGER_ENTRIES    
      
 </H2>          
          
<table border=1   cellpadding=2 cellspacing=2>          
          
<tr style="background-color:rgb(201, 76, 76); color :White"; text-align: right;>          
          
<th> VOUCHERTYPE </th> <th> ADDBY </th> <th> VDATE </th> <th> STATUS </th> <th> SEGMENT </th> <th> TOTAL_CLIENT </th> <th> CREDIT_AMT </th> <th> DEBIT_AMT </th>'             
             
         
 SET @body = @body + @xml +'</table></body></html>          
          
<br />Thanks & Regards,<br /><br />          
          
Hemant Patel<br/>      
System Generated Mail'          
          
EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL          
          
@profile_name = 'AngelBroking',          
          
@body = @body,          
          
@body_format ='HTML',          
          
@recipients = 'pegasusinfocorp.suraj@angelbroking.com',          
---@recipients = 'corporatefinance@angelbroking.com; ankit.joshi@angelbroking.com;sajeev@angelbroking.com;nikunj.shah@angelbroking.com;fundspayout@angelbroking.com;dileswar.jena@angelbroking.com;nilesh.gokral@angelbroking.com;bhavin@angelbroking.com;narayan.    
---patankar@angelbroking.com',          
          
@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',          
---@blind_copy_recipients ='hemantp.patel@angelbroking.com;pegasusinfocorp.suraj@angelbroking.com',          
          
@subject = 'Pending Ledger Status' ;              
        
---DROP TABLE #Temp        
END    
    
IF EXISTS(SELECT * FROM #TEMP1)    
BEGIN    
 SET @xml = CAST(( SELECT 'left' AS 'td/@align', [VOUCHERTYPE] AS 'td','', 'left' AS 'td/@align', [ADDBY] AS 'td',''    
 ,'left' AS 'td/@align', [STATUS] AS 'td',''  , 'left' AS 'td/@align', [SEGMENT] AS 'td',''    
 , 'left' AS 'td/@align', [CLIENT_COUNT] AS 'td','', 'right' AS 'td/@align', [CREDIT_AMT] AS 'td' ,''     
 , 'right' AS 'td/@align', [DEBIT_AMT] AS 'td',''          
FROM #Temp1          
          
--ORDER BY BalanceDate          
          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))          
          
SET @body ='<p style="font-size:medium; font-family:Calibri">          
          
 <b>Dear Team </b>,<br /><br />          
          
 This is the list of data which ledger status pending from long time for Back office posting.     
 <br />    
 Table : tbl_post_data    
      
 </H2>          
          
<table border=1   cellpadding=2 cellspacing=2>          
          
<tr style="background-color:rgb(201, 76, 76); color :White"; text-align: right;>          
          
<th> VOUCHERTYPE </th> <th> ADDBY </th> <th> STATUS </th> <th> SEGMENT </th> <th> TOTAL_CLIENT </th> <th> CREDIT_AMT </th> <th> DEBIT_AMT </th>'             
             
         
 SET @body = @body + @xml +'</table></body></html>          
          
<br />Thanks & Regards,<br /><br />          
          
Hemant Patel<br/>      
System Generated Mail'          
          
EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL          
          
@profile_name = 'AngelBroking',          
          
@body = @body,          
          
@body_format ='HTML',          
          
@recipients = 'pegasusinfocorp.suraj@angelbroking.com',          
---@recipients = 'corporatefinance@angelbroking.com; ankit.joshi@angelbroking.com;sajeev@angelbroking.com;nikunj.shah@angelbroking.com;fundspayout@angelbroking.com;dileswar.jena@angelbroking.com;nilesh.gokral@angelbroking.com;bhavin@angelbroking.com;narayan.    
---patankar@angelbroking.com',          
          
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',          
@blind_copy_recipients ='hemantp.patel@angelbroking.com',          
          
@subject = 'Pending Ledger Status' ;              
    
END    
    
DROP TABLE #TEMP    
DROP TABLE #TEMP1    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetBankDetailsAgainstClient
-- --------------------------------------------------

CREATE PROCEDURE USP_GetBankDetailsAgainstClient @ClientCode VARCHAR(20)
AS
BEGIN
SELECT ClientCode,ClientName,BankName,BankAccountNo
FROM [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS WITH(NOLOCK) 
Where ClientCode = @ClientCode AND BANKName in('INDUSIND BANK LTD','KOTAK MAHINDRA BANK','HDFC') 
AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetBankDetailsUsingIFSCCode
-- --------------------------------------------------

CREATE PROCEDURE USP_GetBankDetailsUsingIFSCCode @IFSCCode  VARCHAR(18)      
AS      
BEGIN      
SELECT TOP 1 Bank_Name,Branch_Name,Branch_Address,Micr_Code     
 FROM [INTRANET].[RISK].dbo.RTGS_MASTER WITH(NOLOCK)       
WHERE Ifsc_Code= @IFSCCode      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientCompleteDRFProcessStatusReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientCompleteDRFProcessStatusReport] 
@ClientDPId VARCHAR(35)='',@DRFNo VARCHAR(15)=''
AS  
BEGIN         
      
DECLARE @Condition VARCHAR(MAX)='',@query1 VARCHAR(MAX)='',@query2 VARCHAR(MAX)='',@query3 VARCHAR(MAX)='',
@query4 VARCHAR(MAX)=''

IF(@ClientDPId<>'')
BEGIN
SET @Condition = ' DRFIRPM.ClientId = '''+@ClientDPId+'''  '
END
IF(@DRFNo<>'')
BEGIN
SET @Condition = ' DRFIRPM.DRFNo = '''+@DRFNo+'''  '
END

IF(@ClientDPId<>'' AND @DRFNo<>'')
BEGIN
SET @Condition = ' DRFIRPM.ClientId = '''+@ClientDPId+''' AND DRFIRPM.DRFNo = '''+@DRFNo+'''  '
END

SET @query1='
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) ''SRNo'', * FROM(  
  SELECT DRFIRPM.DRFId, DRFIRPM.DRFNo,  
  DRFIRPM.ClientId,DRFIRPM.ClientName,DRFIRPM.MobileNo,DRFIRPD.CompanyName,  
  DRFIRPD.Quantity,DRFIRPM.NoOfCertificates,  
  
  CASE WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'''')<>''''      
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END ''DRF Courier Receieved From Client'',  
    
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'''')<>''''      
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END ''DRF Courier Receieved & Rejected due to Invalid Client Id'',      
    
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'''')<>'''' AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=1 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END ''Rejected due to Invalid Client Id - DRF Send to Client'',      
   
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'''')<>'''' AND ISNULL(RDRFOPRD.IsFileGenerate,0)=1 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'''') = ''DL''  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END ''DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed'',        
  
  CASE WHEN ISNULL(CDRFID.DocumentName,'''')<>''''  
  THEN CONVERT(VARCHAR(20),CDRFID.ProcessDate,113) END ''DRF Scanning'',       
      
--CASE WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0      
-- THEN CONVERT(VARCHAR(20),CDRFAAVD.ProcessDate,113) END ''DRF Hold Due to Pending e-sign Aadhar Authantication Documents'',      
        
-- CASE WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=1      
-- THEN CONVERT(VARCHAR(20),CDRFAAVD.IsESignDocUploadDate,113) END ''DRF e-sign Aadhar Authantication Documents Upload And Verified'',    
  
 CASE WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN   
 CONVERT(VARCHAR(20),CDRFAAESDAPID.RequestSendDate) END  
  ''DRF Hold Due to Pending e-sign Aadhar Authantication Documents'' ,  
  
 CASE WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)  
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=0 THEN   
  CONVERT(VARCHAR(20),CDRFAAESDAPID.ExpiryDate) END   
  ''DRF Hold - Aadhar Authantication e-sign Link Expired'' ,  
  '
  SET @query2='
CASE WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1   
 THEN CONVERT(VARCHAR(20),CDRFAAESDAPID.ResponseUploadDate) END   
 ''DRF e-sign Aadhar Authantication Documents Upload And Verified'',  
  
  CASE WHEN ISNULL(DRFMCPT.IsMakerProcess,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.MakerProcessDate,113) END ''DRF Verfication by DP - Maker'',  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerProcess,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END ''DRF Verfication by DP - Checker'',  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END ''DRF Verfication by DP - Rejected'',  
    
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=2 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END ''DP - Rejected DRF Send to Client'',      
   
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1  AND ISNULL(RDRFOPRD.IsFileGenerate,0)=2 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'''') = ''DL''  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END ''DP - Rejected DRF Received by the Client And Closed'',        
  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1   
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END ''DRF Upload to CDSL'',  
         
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END ''DRF Rejected by CDSL'',  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1    
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=3 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END ''CDSL Rejected DRF Send to Client'',  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND ISNULL(RDRFOPRD.IsFileGenerate,0)=3 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'''') = ''DL''  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END ''CDSL Rejected DRF Received by the Client And Closed'',  
          
 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'''')<>'''' AND ISNULL(DRFMCPT.DRNNo,'''')<>''''  
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0    
 THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END ''DRF Setup in CDSL'',  
  
 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'''')<>'''' AND ISNULL(DRFMCPT.DRNNo,'''')<>''''  
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0  AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1  
 THEN CONVERT(VARCHAR(20),DRFMCPT.DispatchDate,113) END ''RTA Letter Generation'',  
  
 CASE WHEN ISNULL(DRFMCPT.IsCDSLRejected,0)=0 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1    
 AND (ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5  OR ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0)   
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.FileGenerateDate,113) END ''DRF Dispatch to RTA - Maker'',     
  
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1       
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END ''DRF Dispatch to RTA - Checker'' ,         
         
  CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1          
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END ''DRF Send to RTA'' ,         
     
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND TDRFORSRTAD.IsResponseUpload=1    
 AND TDRFORSRTAD.IsDocumentReceived=1 AND ISNULL(TDRFORSRTAD.StatusGroup,'''') = ''DL''  
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.DocumentReceivedDate,113) END  ''Courier Received by RTA'',  
   
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') IN(''CONFIRMED (CREDIT CURRENT BALANCE)'' ,''CONFIRMED (CR LOCK-IN BALANCE)'') 
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  ''DRF converted in Demat & Closed'',  
   '
   SET @query3='
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')  
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  ''RTA Rejected'',  
    
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')   
 AND DATEDIFF(day,RTAProcessDate,getdate())>1  AND ISNULL(DRFIRBRTA.DRFId,0) =0  
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  ''RTA Rejected, but not Courier Received by DP'',  
        
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')  
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0   
 THEN CONVERT(VARCHAR(20),DRFIRBRTA.DocumentReceivedDate,113) END  ''RTA Rejected DRF Received by DP'',  
    
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')  
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0 AND ISNULL(RTARDSD.DRFId,0)<>0  
 THEN CONVERT(VARCHAR(20),RTARDSD.ProcessDate,113) END  ''RTA Rejected DRF Memo Scanned'',  
  
  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END      
  ''RTA Rejected letter sent to Client - Maker'',       
        
  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')       
AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1      
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END      
   ''RTA Rejected letter sent to Client - Checker'',  
   CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=0      
  AND ISNULL(RDRFOPRD.StatusGroup,'''') IN('''', ''IT'' )     
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END      
 ''RTA Rejected DRF Sent to Client- In Trasit'',  
      
 CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''',''CONFIRMED (CR LOCK-IN BALANCE)'')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=1       
  AND ISNULL(RDRFOPRD.StatusGroup,'''') = ''DL''  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END      
 ''RTA Rejected DRF Received by the Client & Closed''    ,  
   
 CASE WHEN ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=0  
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
 AND ISNULL(RDRFOPRD.StatusGroup,'''') IN(''RT'',''UD'') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0  
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END   ''DRF UnDelivered, Return Received by DP team'' ,   
    
CASE WHEN ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=1  
 AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1  
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END   ''DRF UnDelivered, Resend to Client And Closed''    
    
  
 FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFIRPD.DRFId  
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId  
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)  
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId  
  LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)          
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId  
 --LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)  
 --ON DRFMCPT.DRFId = DRFIRPM.DRFId    
 '
 SET @query4='
 --LEFT JOIN [AGMUBODPL3].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)  
 --ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0      
 -- LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)        
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId AND  DRFMCPT.DRFNo=@DRFNo    
   LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)          
 ON DRFIRPM.DRFId = DRFMCPT.DRFId ----AND DRFMCPT.DRFNo=     
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)  
 ON CDRFID.DRFId = DRFIRPM.DRFId  
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)  
 ON DRFIRPM.DRFId = RTARDSD.DRFId   
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)  
 ON DRFIRPM.DRFId = UDCDRFID.DRFId          
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)       
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId     
 LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)  
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId  
      
 WHERE '+@Condition+' 
 ) A  
UNPIVOT      
 (      
 ProcessDate For DRFStatus IN      
 (      
 [DRF Courier Receieved From Client],      
[DRF Courier Receieved & Rejected due to Invalid Client Id],  
[Rejected due to Invalid Client Id - DRF Send to Client],      
[DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed],  
 [DRF Scanning],      
 [DRF Hold Due to Pending e-sign Aadhar Authantication Documents],      
 [DRF Hold - Aadhar Authantication e-sign Link Expired],  
 [DRF e-sign Aadhar Authantication Documents Upload And Verified],      
 [DRF Verfication by DP - Maker],  
 [DRF Verfication by DP - Checker],  
 [DRF Verfication by DP - Rejected],  
 [DP - Rejected DRF Send to Client],      
 [DP - Rejected DRF Received by the Client And Closed],      
 [DRF Upload to CDSL],      
 [DRF Rejected by CDSL],      
 [CDSL Rejected DRF Send to Client],       
 [CDSL Rejected DRF Received by the Client And Closed],      
 [DRF Setup in CDSL],      
 [RTA Letter Generation],      
 [DRF Dispatch to RTA - Maker],      
 [DRF Dispatch to RTA - Checker],         
 [DRF Send to RTA],        
 [Courier Received by RTA],      
 [DRF converted in Demat & Closed],      
 [RTA Rejected],      
 [RTA Rejected, but not Courier Received by DP],      
 [RTA Rejected DRF Received by DP],      
 [RTA Rejected DRF Memo Scanned],      
 [RTA Rejected letter sent to Client - Maker],      
 [RTA Rejected letter sent to Client - Checker],       
 [RTA Rejected DRF Sent to Client- In Trasit],      
[RTA Rejected DRF Received by the Client & Closed],  
[DRF UnDelivered, Return Received by DP team] ,  
[DRF UnDelivered, Resend to Client And Closed]   
       
 )      
 )As UnPvt  
 '

--Print CAST((@query1+@query2+@query3+@query4) as ntext) 
EXEC(@query1+@query2+@query3+@query4)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDetailsForSebiPayout
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDetailsForSebiPayout   
@ClientPanNo VARCHAR(15)=''  , @CltCode VARCHAR(15)=''    
AS      
BEGIN      
DECLARE @Condition VARCHAR(MAX)=''            
  
IF(ISNULL(@ClientPanNo,'')<>'')            
BEGIN            
SET @Condition = ' WHERE AA.pan_gir_no = '''+@ClientPanNo+''' '            
END            
IF(ISNULL(@CltCode,'')<>'')            
BEGIN            
SET @Condition = ' WHERE AA.cl_code = '''+@CltCode+''' '            
END            
  
EXEC('  
SELECT CltCode,SBTag,BranchCode,ClientName,ClientPanNo,SUM(ExistingBlockedCount) ''ExistingBlockedCount''    
FROM (    
SELECT DISTINCT AA.cl_code ''CltCode'', AA.sub_broker ''SBTag'',AA.branch_cd ''BranchCode'',      
AA.long_name ''ClientName'',AA.pan_gir_no ''ClientPanNo'',     
CASE WHEN ISNULL(CSPBD.CltCode,'''')<>'''' AND ISNULL(CSPBD.IsUnBlocked,0)=0    
THEN 1 ELSE 0 END ''ExistingBlockedCount''      
FROM anand1.msajag.dbo.client_details  AA WITH(NOLOCK)      
JOIN anand1.msajag.dbo.client_brok_details CBD WITH(NOLOCK)      
ON AA.cl_code = CBD.Cl_Code      
LEFT JOIN tbl_ClientSebiPayoutBlockingDetails CSPBD WITH(NOLOCK)    
ON AA.cl_code = CSPBD.CltCode AND AA.pan_gir_no = CSPBD.ClientPanNo    
--- WHERE pan_gir_no =  @ClientPanNo       
'+@Condition+'  
---- AND CAST(InActive_From as date) > CAST(GETDATE() as date)      
)AA    
GROUP BY CltCode,SBTag,BranchCode,ClientName,ClientPanNo    
')  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRF_AllProcessCompleteStatusDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientDRF_AllProcessCompleteStatusDetails]                    
AS                  
              
BEGIN              
            
/*            
CREATE TABLE #ClientDRFCompleteStatusDetails              
(              
DRFId bigint,              
DRFNo VARCHAR(35),               
DEMRM_ID VARCHAR(25),               
CurrentStatus VARCHAR(550),               
MakerProcessStatus VARCHAR(20),              
IsMakerProcess bit,              
MakerProcessDate VARCHAR(20),              
MakerBy VARCHAR(10),              
IsCheckerProcess bit,               
IsCheckerRejected bit,              
CheckerProcessStatus VARCHAR(20),               
CheckerProcessRemarks VARCHAR(500),              
CheckerProcessDate VARCHAR(20),              
CheckerBy VARCHAR(10),               
BatchUploadInCDSL bit,              
BatchNo VARCHAR(15),              
DRNNo VARCHAR(25),               
IsCDSLProcess bit,               
IsCDSLRejected bit,              
CDSLStatus VARCHAR(30),              
CDSLRemarks VARCHAR(500),              
CDSLProcessDate VARCHAR(20),               
RTALetterGenerate bit,              
DispatchDate VARCHAR(20),              
IsRTAProcess bit,               
RTAProcessDate VARCHAR(20),              
RTAStatus VARCHAR(20),               
RTARemarks VARCHAR(550)              
)              
*/            
            
TRUNCATE table tbl_ClientDRFProcessCompleteStatusDetails    --- 38221 / 42405  / 38239                          
              
---INSERT INTO tbl_ClientDRFProcessCompleteStatusDetails              
EXEC [AGMUBODPL3].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails          --- 10.253.33.189   --- 200 DP                    
            
---INSERT INTO tbl_ClientDRFProcessCompleteStatusDetails               
EXEC [AngelDP5].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails         --- 10.253.33.190     --- 201 DP                    
            
---INSERT INTO tbl_ClientDRFProcessCompleteStatusDetails                
EXEC [ATMUMBODPL03].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails         --- 10.253.33.227   --- 202 DP                    
      
EXEC [AOPR0SPSDB01].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails  --- 10.253.78.167,13442 : 203 DP  GPX Server                            

---EXEC [10.254.33.93,13442].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails   --- Comment NTT Server            

EXEC [ABVSDP204].DMAT.dbo.USP_GetClientDRFProcessCompleteStatusDetails  --- 10.253.78.167,13442 : 203 DP  GPX Server                            

                        
--TRUNCATE table tbl_ClientDRFProcessCompleteStatusDetails              
            
--INSERT INTO tbl_ClientDRFProcessCompleteStatusDetails             
--SELECT * FROM #ClientDRFCompleteStatusDetails            
              
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRF_DashboardMonthly_MISReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRF_DashboardMonthly_MISReport      
@IsMis bit=0, @ProcessDate VARCHAR(10)=''      
AS      
BEGIN      
      
SELECT * INTO #DRF_StatusDetails FROM (      
SELECT       
CAST(InwordProcessDate as date) 'InwordProcessDate',DRFM.DRFNo,      
DRFM.ClientId,DRFM.ClientName,      
CONVERT(VARCHAR(17),ISNULL(MakerProcessDate,''),113) 'MakerProcessDate',      
CASE WHEN ISNULL(IsCheckerProcess,0)=1 AND ISNULL(IsCheckerRejected,0)=0 THEN 'DP Success'      
WHEN ISNULL(IsCheckerProcess,0)=1 AND ISNULL(IsCheckerRejected,0)=1 THEN 'DP Rejected'       
ELSE ''      
END 'CheckerStatus',      
CONVERT(VARCHAR(17),ISNULL(CheckerProcessDate,''),113) 'CheckerProcessDate',      
CASE WHEN ISNULL(IsCDSLProcess,0)=1 AND ISNULL(IsCDSLRejected,0)=0 THEN 'CDSL Success'      
WHEN ISNULL(IsCDSLProcess,0)=1 AND ISNULL(IsCDSLRejected,0)=1 THEN 'CDSL Rejected'       
ELSE ''      
END 'CDSLStatus',      
CONVERT(VARCHAR(17),ISNULL(CDSLProcessDate,''),113) 'CDSLProcessDate',      
CASE WHEN RTALetterGenerate=1 AND IsRTAProcess=1 AND CDRFPCSD.RTARemarks like 'CONFIRMED%'      
THEN 'RTA Confirmed'      
WHEN RTALetterGenerate=1 AND IsRTAProcess=1 AND CDRFPCSD.RTARemarks like 'REJECTED%'      
THEN 'RTA Rejected'      
WHEN RTALetterGenerate=1 AND IsRTAProcess=0 AND RTARemarks='SETUP' THEN 'Setup'      
WHEN RTALetterGenerate=1 AND IsRTAProcess=0 AND ISNULL(RTARemarks,'')='' THEN 'Send to RTA'      
ELSE '' END 'RTAStatus',      
CONVERT(VARCHAR(17),ISNULL(RTAProcessDate,''),113) 'RTAProcessDate',      
ISNULL(CheckerProcessRemarks,'') CheckerProcessRemarks,ISNULL(CDSLRemarks,'') CDSLRemarks,  
ISNULL(RTARemarks,'') RTARemarks,      
CASE WHEN CDRFPCSD.RTALetterGenerate=1 AND CDRFPCSD.IsRTAProcess=1       
AND CDRFPCSD.RTARemarks like 'CONFIRMED%'      
THEN 1 ELSE 0 END 'DRF_Processed',      
CASE WHEN (CDRFPCSD.IsCDSLRejected=1 OR CDRFPCSD.IsCheckerRejected=1) THEN 1       
ELSE 0 END 'DP_Rejected',      
CASE WHEN RTALetterGenerate=1 AND IsRTAProcess=1 AND RTARemarks like 'REJECTED%'      
THEN 1 ELSE 0 END 'RTA_Rejected',      
IIF(DRFAAVD.TotalCost>=500000,1,0) 'HighValue',      
DRFAAVD.TotalCost      
      
FROM tbl_DRFInwordRegistrationProcessMaster DRFM WITH(NOLOCK)      
LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails CDRFPCSD WITH(NOLOCK)      
ON DRFM.DRFId = CDRFPCSD.DRFId      
LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails DRFAAVD WITH(NOLOCK)      
ON DRFM.DRFId = DRFAAVD.DRFId      
WHERE CAST(InwordProcessDate as date) >= CAST(GETDATE()-32 as date)      
)A      
      
IF(@IsMis=1)      
BEGIN      
SELECT CONVERT(VARCHAR(10),InwordProcessDate,103) 'InwordProcessDate',      
COUNT(DRFNo) 'TotalDRF',       
SUM(DRF_Processed) 'DRF_Processed',SUM(DP_Rejected) 'DP_Rejected',      
SUM(RTA_Rejected) 'RTA_Rejected',      
SUM(HighValue) 'HighValue_Count'      
FROM(      
SELECT * FROM #DRF_StatusDetails      
)AA      
GROUP BY InwordProcessDate      
ORDER BY CAST(InwordProcessDate as date) desc      
      
END      
ELSE      
BEGIN      
      
SET @ProcessDate = CAST(CONVERT(date,@ProcessDate,103) as date)        
  
--SET @ProcessDate = CAST(@ProcessDate as date)     
    
SELECT       
CONVERT(VARCHAR(10),InwordProcessDate,103) 'InwordProcessDate',DRFNo,ClientId,ClientName,    
ISNULL(MakerProcessDate,'') MakerProcessDate,ISNULL(CheckerStatus,'') CheckerStatus,    
ISNULL(CheckerProcessDate,'') CheckerProcessDate,      
ISNULL(CheckerProcessRemarks,'') CheckerProcessRemarks,ISNULL(CDSLStatus,'') CDSLStatus,    
ISNULL(CDSLProcessDate,'') CDSLProcessDate,ISNULL(CDSLRemarks,'') CDSLRemarks,       
ISNULL(RTAStatus,'') RTAStatus,ISNULL(RTAProcessDate,'') RTAProcessDate,    
ISNULL(RTARemarks,'') RTARemarks,ISNULL(TotalCost,0) TotalCost ,      
IIF(ISNULL(TotalCost,0)>=500000, 'Yes','No') 'HighValue'      
FROM #DRF_StatusDetails       
WHERE CAST(InwordProcessDate as date)=@ProcessDate      
       
END      
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRF_RTARejectedInwordProcessReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRF_RTARejectedInwordProcessReport  
@FromDate VARCHAR(12)='', @ToDate VARCHAR(12)=''  
AS  
BEGIN  
  
SET @FromDate = CONVERT(datetime,@FromDate,103)  
SET @ToDate = CONVERT(datetime,@ToDate,103)  
  
SELECT DRFIRPM.DRFNo,DRFIRPM.DRFId,DRFIRPM.ClientId,DRFIRPM.ClientName,  
CONVERT(VARCHAR(17),DRFIRPM.InwordProcessDate,113) 'InwordProcessDate'  
,DRFIRPM.NoOfCertificates,VGCDCRPS.DRNNo,  
'Rejected By RTA' 'Status',VGCDCRPS.RTARemarks 'Remarks',  
DRFIRPD.ISINNo,DRFIRPD.CompanyName,DRFIRPD.Quantity,  
DRFIRRPRRTA.PodNo,DRFIRRPRRTA.CourierName   
, CONVERT(VARCHAR(17),DRFIRRPRRTA.DocumentReceivedDate,113) 'CourierReceivedDate'   
  
FROM DRFInwordRegistrationReceivedByRTADetails DRFIRRPRRTA WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
ON DRFIRRPRRTA.DRFId = DRFIRPM.DRFId  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPD.DRFId = DRFIRPM.DRFId  
--JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus VGCDCRPS WITH(NOLOCK)  
--ON VGCDCRPS.DRFId = DRFIRPM.DRFId
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails VGCDCRPS WITH(NOLOCK)      
 ON DRFIRPM.DRFId = VGCDCRPS.DRFId 
WHERE CAST(DocumentReceivedDate as date) between CAST(@FromDate as date) AND CAST(@ToDate as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFAadharAuthenicationVerificationDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFAadharAuthenicationVerificationDetails 
@ProcessStatus VARCHAR(15)=''   
AS    
BEGIN   
DECLARE @Condition VARCHAR(MAX)=''
IF(ISNULL(@ProcessStatus,'')='Hold' OR ISNULL(@ProcessStatus,'')='Process')
BEGIN
SET @Condition =' AND ISNULL(AppStatus,'''') ='''+@ProcessStatus+''' '
END

EXEC('
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,ClientId,CLTCode,ClientName,FinalStatus,FinalDescription,    
CONVERT(VARCHAR(17),ProcessDate,103) ''ProcessDate'',DRFIRPD.ISINNo,DRFIRPD.CompanyName    
FROM ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)    
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)    
ON CDRFAAVD.DRFId = DRFIRPM.DRFId AND CDRFAAVD.ClientDPId= DRFIRPM.ClientId    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)    
ON DRFIRPM.DRFId = DRFIRPD.DRFId    
WHERE IsESignDocumentUpload=0 
AND CAST(ProcessDate as date) >= CAST(GetDate()-7 as date) 
'+@Condition+'  
')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFAadharAuthenicationVerificationReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFAadharAuthenicationVerificationReport    
@FromDate VARCHAR(15)='', @ToDate VARCHAR(15)='', @IsESignUpload VARCHAR(15)=''    
AS      
BEGIN      
DECLARE @Condition VARCHAR(MAX)=''    
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    

IF(ISNULL(@IsESignUpload,'')='AllDetails')    
BEGIN    
SET @Condition = ' WHERE CAST(CDRFAAVD.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+'''  '    
END      
IF(ISNULL(@IsESignUpload,'')='ESignUpload')    
BEGIN    
SET @Condition = ' WHERE ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=1 AND CAST(CDRFAAVD.IsESignDocUploadDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '    
END    
IF(ISNULL(@IsESignUpload,'')='5LacGreater')    
BEGIN    
SET @Condition = ' WHERE ISNULL(TotalCost,0) >=500000 AND CAST(CDRFAAVD.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '    
END    
IF(ISNULL(@IsESignUpload,'')='ESignPending')    
BEGIN    
SET @Condition = ' WHERE ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0 AND CAST(CDRFAAVD.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '    
END      
    
EXEC('    
SELECT   
DRFIRPM.DRFId,CLTCode,ClientDPId,DRFIRPM.DRFNo,DRFIRPM.ClientName,DRFIRD.ISINNo,DRFIRD.CompanyName,  
CASE WHEN IsESignDocumentUpload=1 THEN ''Verified''   
ELSE AppStatus END ''AppStatus'',  
CASE WHEN IsESignDocumentUpload=1 THEN AppDescription + ''- Verified''  
ELSE AppDescription END ''AppDescription''  
, CAST(CAST(TotalIncomeValue/5 as decimal(17,2)) as nvarchar)+ '' X5'' ''Income_Value'',  
TotalIncomeValue,SharesQty,ClosingPrice,TotalCost,CommulativeValuation,  
CASE WHEN CommulativeValuation>=TotalIncomeValue THEN ''YES''  
ELSE ''NO'' END ''IncomeHoldStatus'',  
CONVERT(VARCHAR(17),CDRFAAVD.ProcessDate,113) ''ProcessDate'',  
CASE WHEN CAST(CDRFAAVD.IsESignDocUploadDate as date) = ''1900-01-01'' THEN ''''     
ELSE CONVERT(VARCHAR(17),CDRFAAVD.IsESignDocUploadDate ,103) END ''IsESignDocUploadDate''  
  
FROM ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM  
ON CDRFAAVD.DRFId =DRFIRPM.DRFId  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRD  
ON CDRFAAVD.DRFId =DRFIRD.DRFId  
'+@Condition+'    
')    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFAadharAuthenticationESignRequestDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFAadharAuthenticationESignRequestDetails
AS
BEGIN
SELECT ESignDocumentId,DRFId,DocumentId 
FROM tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails WITH(NOLOCK)
WHERE IsResponseForESign=0 AND CAST(ExpiryDate as date)> CAST(GETDATE() AS DATE)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFDetailsForESignAadharAuthentication
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFDetailsForESignAadharAuthentication          
@DRFId bigint=0          
AS          
BEGIN          
SELECT DRFNo,ClientName,  DRFIRPM.MobileNo MobileNo , DRFPCMSD.ClientEmailId ClientEmailId          
-- '8108338296' MobileNo , 'parmarsuraj254@gmail.com' ClientEmailId     
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)          
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)          
ON DRFIRPM.DRFId= DRFPCMSD.DRFId          
JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)          
ON DRFIRPM.DRFId= CDRFAAVD.DRFId          
WHERE AppStatus='Hold' --AND ApplicationType='Offline'    
AND DRFIRPM.DRFId = @DRFId          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFInwordProcessDetails
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetClientDRFInwordProcessDetails          
AS          
BEGIN            
        
SELECT DRFRPM.DRFId,DRFRPM.DRFNo,DRFRPM.ClientId ,DRFRPM.ClientName,         
CDRFID.IsTransferForScanning,CDRFID.ToTransfered,        
IIF(CDRFID.IsTransferForScanning=1, 1,0) 'TransferedStatus',        
DocumentName 'FileName',      
CONVERT(VARCHAR(20),ProcessDate,13) 'ProcessDate' ,        
        
CASE         
WHEN ISNULL(DocumentName,'')='' AND ISNULL(IsTransferForScanning,0)=1 THEN 'PendingForScanning'        
WHEN ISNULL(IsTransferForScanning,0)=0 THEN 'PendingForTransfer'        
WHEN DRFRPM.DRFNo <> '' AND ISNULL(Extension,'')='' AND ISNULL(CDRFID.DRFId,0)=0 THEN 'DRFPerformed'        
ELSE 'Scanning Done'        
END 'DRFProcessStatus'  ,      
CASE WHEN ISNULL(CDRFID.DocumentName,'')<>'' THEN 'Yes'      
ELSE 'No' END 'DocumentStatus'      
      
        
FROM tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)          
--JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)          
--ON AMCD.CltDpId1 = DRFRPM.ClientId          
LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)          
ON DRFRPM.DRFId = CDRFID.DRFId          
WHERE IsRejected=0      
AND DRFRPM.DRFId NOT IN(SELECT DRFId FROM tbl_ClientDRFInwordDocuments WITH(NOLOCK)     
 WHERE CAST(ProcessDate as date) < CAST((GETDATE()) as date) AND ISNULL(DocumentName,'')<>'')      
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFMemoScannedDetails
-- --------------------------------------------------
   
CREATE PROCEDURE USP_GetClientDRFMemoScannedDetails      
AS      
BEGIN      
SELECT DISTINCT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId,DRFIRPM.ClientName,DRFIRPD.CompanyName,      
DRFIRPM.NoOfCertificates, DRFIRPD.Quantity, CONVERT(VARCHAR(20),RTARDRFMSD.ProcessDate,113) 'ProcessDate',      
CASE WHEN ISNULL(RTARDRFMSD.DRFId,0) <> '' THEN 'Yes'       
ELSE 'No' END 'DocumentUploadStatus',      
ISNULL(RTARDRFMSD.FileName,'') 'FileName',  
DRFIRBRTA.DRNNo 'DRNNo'  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)                  
 ON DRFIRPM.DRFId = DRFIRPD.DRFId      
 JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)                  
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId        
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDRFMSD WITH(NOLOCK)      
 ON DRFIRPM.DRFId = RTARDRFMSD.DRFId       
 WHERE DRFIRPM.DRFId NOT IN  
 (SELECT ISNULL(DRFId,0) FROM tbl_RTARejectedDRFMemoScannedDocument WITH(NOLOCK))    
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFNoUsingClientDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFNoUsingClientDetails       
@ProcessType VARCHAR(25)='', @ProcessValue VARCHAR(25)=''      
AS      
BEGIN      
DECLARE @Condition VARCHAR(MAX) = ''      
      
IF(@ProcessType = 'ClientId')      
BEGIN      
SET @Condition = ' WHERE DRFIRPM.ClientId = '''+@ProcessValue+''' '       
END      
IF(@ProcessType = 'MobileNo')      
BEGIN      
SET @Condition = ' WHERE DRFIRPM.MobileNo = '''+@ProcessValue+''' '       
END      
IF(@ProcessType = 'PanNo')      
BEGIN      
SET @Condition = ' WHERE AMCLTD.pan_gir_no = '''+@ProcessValue+''' '       
END      
IF(@ProcessType = 'TradingCode')      
BEGIN      
SET @Condition = ' WHERE AMCLTD.cl_code = '''+@ProcessValue+''' '       
END      
      
EXEC('      
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFIRPM.DRFNo) ''SRNo'', DRFIRPM.DRFNo      
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
LEFT JOIN [AGMUBODPL3].inhouse.dbo.TBL_CLIENT_MASTER AMCLTD WITH(NOLOCK)      
ON DRFIRPM.ClientId = AMCLTD.CLIENT_CODE      
 '+@Condition+'      
 UNION     
 SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFIRPM.DRFNo) ''SRNo'', DRFIRPM.DRFNo      
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
LEFT JOIN [AngelDP5].inhouse.dbo.TBL_CLIENT_MASTER AMCLTD WITH(NOLOCK)      
ON DRFIRPM.ClientId = AMCLTD.CLIENT_CODE      
 '+@Condition+'    
  UNION     
 SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFIRPM.DRFNo) ''SRNo'', DRFIRPM.DRFNo      
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
LEFT JOIN [ATMUMBODPL03].inhouse.dbo.TBL_CLIENT_MASTER AMCLTD WITH(NOLOCK)      
ON DRFIRPM.ClientId = AMCLTD.CLIENT_CODE      
 '+@Condition+'   
   UNION     
 SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY DRFIRPM.DRFNo) ''SRNo'', DRFIRPM.DRFNo      
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
LEFT JOIN [10.253.78.167,13442].inhouse.dbo.TBL_CLIENT_MASTER AMCLTD WITH(NOLOCK)      
ON DRFIRPM.ClientId = AMCLTD.CLIENT_CODE      
 '+@Condition+' 
')      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFOnlineOfflineTransaction_MISReport
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetClientDRFOnlineOfflineTransaction_MISReport    
@FromDate VARCHAR(10)='', @ToDate VARCHAR(10)='', @IsOfflineReport bit=0,@IsDefaultReport bit=0    
AS    
BEGIN    
    
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    
    
IF(@IsDefaultReport = 1)    
BEGIN    
SET @FromDate = CAST(GETDATE()-10 as date)    
SET @ToDate = CAST(GETDATE() as date)    
END    
    
IF(@IsOfflineReport =1)    
BEGIN    
  
  
 SELECT *, CASE WHEN (ApplicationValue='W' OR  ApplicationValue='AB'                    
OR  ApplicationValue='SP' OR  ApplicationValue='MF')                    
THEN 'Online'                    
ELSE 'Offline' END 'ApplicationStatus' INTO  #ApplicationStatusDetails   
FROM (                    
SELECT *,                    
case patindex('%[0-9]%', Fld_Application_No)                    
    when 0 then Fld_Application_No                    
    else left(Fld_Application_No, patindex('%[0-9]%', Fld_Application_No) -1 )                     
end 'ApplicationValue'   
 FROM(  
SELECT DISTINCT DRFCMSD.DRFId, Fld_Application_No,KYCR.PARTY_Code,  
IsCheckerRejected,CheckerProcessRemarks,CheckerProcessDate  
FROM    
 tbl_DRFProcessClientMailStatusDetails DRFCMSD With(noLock)   
JOIN tbl_ClientDRFProcessCompleteStatusDetails CDRFCSD WITH(NOLOCK)       
ON DRFCMSD.DRFId = CDRFCSD.DRFId AND CDRFCSD.IsCheckerRejected=1  
JOIN ABVSKYCMIS.kyc.dbo.kycregister KYCR with(NoLock)     
ON KYCR.party_code= DRFCMSD.CLTCode  
INNER JOIN ABVSKYCMIS.KYC.dbo.Client_InwardRegister CIR With(noLock)                    
ON KYCR.party_code = CIR.party_code   
)AA  
)BB  
  
    
SELECT  ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo',* FROM(    
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,    
CONVERT(VARCHAR(10),InwordProcessDate,105) 'InwordProcessDate',CDRFAVD.PARTY_Code 'CLTCode', '' 'Channel',    
AMCD.sub_broker 'SBTag',  
CONVERT(VARCHAR(10),CAST(CheckerProcessDate as date),105)CheckerProcessDate,    
IsCheckerRejected,CheckerProcessRemarks    
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM  WITH(NOLOCK)       
JOIN #ApplicationStatusDetails CDRFAVD   
ON DRFIRPM.DRFId = CDRFAVD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD  WITH(NOLOCK)     
ON CDRFAVD.PARTY_Code= AMCD.cl_code   
WHERE CDRFAVD.ApplicationStatus='Offline'    
AND CAST(InwordProcessDate as date) between @FromDate AND @ToDate    
)AA    
    
END    
ELSE    
BEGIN    
    
SELECT ROW_NUMBER() OVER(ORDER BY ProcessDate) 'SRNo', CONVERT(varchar(10),ProcessDate,105) 'ProcessDate',    
SUM(OfflineCount) 'OfflineCount',SUM(OnlineCount) 'OnlineCount',    
SUM(OfflineCount+OnlineCount) 'TotalCount'    
,SUM(AmountGreater5Lac) 'AmountGreater5Lac'    
,SUM(CumAmount) 'CumAmount'    
FROM (    
SELECT CAST(ProcessDate as date) 'ProcessDate',CLTCode,    
SUM(OfflineCount) 'OfflineCount',SUM(OnlineCount) 'OnlineCount',    
ApplicationType,SUM(AmountGreater5Lac) 'AmountGreater5Lac', SUM(distinct CumAmount) 'CumAmount'    
    
FROM    
(        
SELECT DISTINCT ApplicationType,DRFId, CLTCode,TotalCost,TotalIncomeValue,ProcessDate,       
    
CASE WHEN ApplicationType ='Offline' THEN 1 ELSE 0 END 'OfflineCount',    
CASE WHEN ApplicationType ='Online' THEN 1 ELSE 0 END 'OnlineCount',    
CASE WHEN TotalCost>500000 AND CommulativeValuation<TotalIncomeValue THEN 1 ELSE 0 END 'AmountGreater5Lac' ,     
CASE WHEN CommulativeValuation>TotalIncomeValue THEN 1 ELSE 0 END 'CumAmount'    
,CommulativeValuation        
FROM         
ClientDRFAadharAuthenticationVerificationDetails WITH(NOLOCK)       
 WHERE CAST(ProcessDate as date) between @FromDate AND @ToDate    
)A    
GROUP BY CAST(ProcessDate as date),ApplicationType,CLTCode    
)B    
GROUP BY ProcessDate    
    
END    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFOutwordCDSLAcceptedToRTAProcess
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientDRFOutwordCDSLAcceptedToRTAProcess]       
AS          
BEGIN    
        
---EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''     
    
-- EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus      
          
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY CompanyName) 'SRNo', *         
FROM (SELECT         
DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId    
, DRFIRPM.ClientName 'ClientName'    
, DEM.ENTM_NAME1 'CompanyName',    
DRFIRPD.Quantity,      
DRFIRPM.NoOfCertificates,    
CONVERT(VARCHAR(10),GETDATE(),103) 'ProcessDate',     
ISNULL(DRFMCPT.DRNNo,'') DRNNo,    
DISINM.isin_adrcity + '-' + DISINM.isin_adrzip 'CityPincode',    
'RTA Letter Generation' 'Status',          
CONVERT(VARCHAR(20), DRFMCPT.CDSLProcessDate,113) 'CDSLProcessDate'          
          
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)     
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)          
ON DRFIRPM.DRFId = DRFIRPD.DRFId          
JOIN [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR DISINM WITH(NOLOCK)          
ON DISINM.ISIN_CD = DRFIRPD.ISINNo        
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].entity_mstr DEM WITH(NOLOCK)    
ON ENTM_ENTTM_CD ='rta' and ENTM_SHORT_NAME ='rta_'+CONVERT(varchar,ISIN_REG_CD )      
--JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)         
--ON DRFMCPT.DRFId = DRFIRPM.DRFId    
--JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)    
--ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0           
--JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)    
--ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0    
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)          
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0     
WHERE  DRFMCPT.BatchUploadInCDSL=1 AND DRFMCPT.IsCDSLRejected=0 AND DRFMCPT.IsCDSLProcess=1        
AND DRFMCPT.RTALetterGenerate =1 AND DRFMCPT.IsRTAProcess=0 AND ISNUMERIC(ISIN_REG_CD)=1    
AND DRFIRPM.DRFId NOT     
IN(SELECT DISTINCT DRFId FROM tbl_DRFOutwordRegistrationSendToRTADetails WITH(NOLOCK)     
WHERE IsFileGenerate=5)    
)AA        
ORDER BY CompanyName        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcess_MISData
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFProcess_MISData @IsDailyProcess bit =0       
AS  
BEGIN  
DECLARE @Condition VARCHAR(MAX)=''
IF(@IsDailyProcess=1)
BEGIN
SET @Condition = ' WHERE CAST(ProcessDate as date) = CAST(GETDATE() as date)'
END

EXEC('
SELECT DISTINCT ROW_NUMBER() OVER(ORDER BY AppStatus) ''SR'',  
AppStatus,SUM(TotalClients) ''NoOfRecords'',COUNT(DISTINCT CLTCode) ''UniqueRecords'',  
SUM(TotalCost) ''TotalValueOfDRF'', SUM(AmountGreater5Lac) ''AmountGreater5Lac'',  
SUM(HoldStatusCount) ''CountOfBreachOffCumValue''  
,SUM(HoldStatusAmount)  ''IncomeBreachOffCumValue'' INTO #ClientDetails  
FROM  
(  
SELECT AppStatus,CLTCode,COUNT(CLTCode) ''TotalClients'', SUM(TotalCost) ''TotalCost'',  
 SUM(AmountGreater5Lac) ''AmountGreater5Lac'',  
CASE WHEN MAX(CommulativeValuation) >MAX(TotalIncomeValue) THEN 1 ELSE 0 END ''HoldStatusCount'',  
CASE WHEN MAX(CommulativeValuation) >MAX(TotalIncomeValue) THEN SUM(CommulativeValuation) ELSE 0 END ''HoldStatusAmount'' 
FROM(  
SELECT DISTINCT AppStatus, CLTCode,TotalCost,TotalIncomeValue,ProcessDate,    
CASE WHEN TotalCost>500000 THEN 1 ELSE 0 END ''AmountGreater5Lac''    
,CommulativeValuation  
FROM   
ClientDRFAadharAuthenticationVerificationDetails WITH(NOLOCK) 
 '+@Condition+'  
)A  
GROUP BY AppStatus, CLTCode  
)B  
GROUP BY AppStatus  
  
  
SELECT * FROM #ClientDetails  
UNION  
SELECT  3 ''SR'', ''Total'' ''AppStatus'',ISNULL(SUM(NoOfRecords),0) ''NoOfRecords'',  
ISNULL(SUM(UniqueRecords),0) ''UniqueRecords'',ISNULL(SUM(TotalValueOfDRF),0) ''TotalValueOfDRF''  
,ISNULL(SUM(AmountGreater5Lac),0) ''AmountGreater5Lac'',ISNULL(SUM(CountOfBreachOffCumValue),0)''CountOfBreachOffCumValue''  
,ISNULL(SUM(IncomeBreachOffCumValue),0) ''IncomeBreachOffCumValue''  
FROM #ClientDetails    
  
 DROP TABLE #ClientDetails  
 ')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcessAllStatusDetails
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientDRFProcessAllStatusDetails]               
@FromDate VARCHAR(15)='', @ToDate VARCHAR(15)='', @Status VARCHAR(250)=''              
AS              
BEGIN             
DECLARE @Condition VARCHAR(MAX)=''         
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)              
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)              
        
----EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''         
        
              
IF(@Status='DRF Courier Receieved From Client')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+'''  '            
END            
IF(@Status='DRF Courier Receieved And Rejected due to Invalid Client Id')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=1 AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Rejected due to Invalid Client Id - Send to Client')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=1  AND ISNULL(UDCDRFID.DRFId,0)=0            
 AND RDRFOPRD.IsFileGenerate=1 AND CAST(RDRFOPRD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Rejected due to Invalid Client Id Received by the Client And Closed')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=1             
 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
 AND CAST(RDRFOPRD.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Transfer for Scanning')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND CDRFID.IsTransferForScanning=1               
AND CAST(CDRFID.TransferedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Scanning')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND CDRFID.IsTransferForScanning=1 AND ISNULL(CDRFID.DocumentName,'''') <> ''''               
AND CAST(CDRFID.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END  
IF(@Status='DRF Hold Due to Pending e-sign Aadhar Authantication Documents')            
BEGIN            
----SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(IsESignDocumentUpload,0)=0               
----AND CAST(CDRFAAVD.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
SET @Condition = ' WHERE ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND
ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0               
AND CAST(CDRFAAESDAPID.RequestSendDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '  
END   
IF(@Status='DRF Hold - Aadhar Authantication e-sign Link Expired')            
BEGIN            
           
SET @Condition = ' WHERE ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND
ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0               
AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date) AND CAST(CDRFAAESDAPID.ExpiryDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '  
END   
IF(@Status='DRF e-sign Aadhar Authantication Documents Upload And Verified')            
BEGIN            
--SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(IsESignDocumentUpload,0)=1               
--AND CAST(CDRFAAVD.IsESignDocUploadDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '          
SET @Condition = ' WHERE ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0
 AND CAST(CDRFAAESDAPID.ResponseUploadDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '          
END   
IF(@Status='DRF Verfication by DP - Maker')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=1         
 AND CAST(DRFMCPT.MakerProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Verfication by DP - Checker')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.DRFNo<>'''' AND DRFIRPM.IsRejected=0 AND DRFMCPT.IsCheckerProcess=1 AND DRFMCPT.IsCheckerRejected=0               
AND CAST(DRFMCPT.CheckerProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END        
IF(@Status='DRF Verfication by DP - Rejected')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.IsRejected=0 AND DRFMCPT.IsCheckerProcess=1 AND DRFMCPT.IsCheckerRejected=1              
AND CAST(DRFMCPT.CheckerProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END        
IF(@Status='DP - Rejected DRF Send to Client')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.IsRejected=0 AND DRFMCPT.IsCheckerProcess=1 AND DRFMCPT.IsCheckerRejected=1 AND RDRFOPRD.IsFileGenerate=2               
 AND CAST(RDRFOPRD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DP - Rejected DRF Received by the Client And Closed')            
BEGIN            
SET @Condition = ' WHERE DRFIRPM.IsRejected=0 AND DRFMCPT.IsCheckerRejected=1 AND RDRFOPRD.IsFileGenerate=2 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
 AND CAST(RDRFOPRD.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Upload to CDSL')            
BEGIN         
SET @Condition = ' WHERE DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.BatchUploadInCDSL=1        
AND CAST(DRFMCPT.CDSLProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Rejected by CDSL')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1 AND RDRFOPRD.IsFileGenerate IN(0,3) AND CAST(DRFMCPT.CDSLProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''''            
END            
IF(@Status='CDSL Rejected DRF Send to Client')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1 AND RDRFOPRD.IsFileGenerate=3         
AND ISNULL(UDCDRFID.DRFId,0)=0 AND CAST(RDRFOPRD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='CDSL Rejected DRF Received by the Client And Closed')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1 AND RDRFOPRD.IsFileGenerate=3 AND RDRFOPRD.IsResponseUpload=1         
AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
 AND CAST(RDRFOPRD.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='DRF Setup in CDSL')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.IsCDSLRejected=0 AND DRFMCPT.BatchUploadInCDSL=1 AND CAST(DRFMCPT.CDSLProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
         
IF(@Status='RTA Letter Generation')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.BatchUploadInCDSL=1 AND DRFMCPT.RTALetterGenerate=1 AND CAST(DRFMCPT.CDSLProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
            
IF(@Status='DRF Dispatch to RTA - Maker')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND ISNULL(DRFMCPT.DRNNo,''0'')<>''0'' AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5         
AND CAST(TDRFORSRTAD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
            
IF(@Status='DRF Dispatch to RTA - Checker')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1                
 AND ISNULL(DRFMCPT.DRNNo,''0'')<>''0'' AND CAST(TDRFORSRTAD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
            
IF(@Status='DRF Send to RTA')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND ISNULL(TDRFORSRTAD.PodNo,'''') <>''''               
 AND ISNULL(DRFMCPT.DRNNo,''0'')<>''0'' AND CAST(TDRFORSRTAD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '      
END            
IF(@Status='Courier Received by RTA')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND ISNULL(TDRFORSRTAD.PodNo,'''') <>'''' AND TDRFORSRTAD.IsDocumentReceived=1 AND TDRFORSRTAD.StatusGroup=''DL''
             
 AND ISNULL(DRFMCPT.DRNNo,''0'')<>''0'' AND CAST(TDRFORSRTAD.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+'''  '            
END            
IF(@Status='DRF converted in Demat And Closed')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') =''CONFIRMED (CREDIT CURRENT BALANCE)''               
AND CAST(DRFMCPT.RTAProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''''            
END            
IF(@Status='RTA Rejected')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')              
AND CAST(DRFMCPT.RTAProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected, but Courier not Received by DP')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')        
AND DATEDIFF(day,RTAProcessDate,getdate())>1                
AND CAST(DRFMCPT.RTAProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected DRF Received by DP')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''') AND ISNULL(DRFIRBRTA.PodNo,'''')<>''''               
  AND CAST(DRFIRBRTA.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected DRF Memo Scanned')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')        
 AND ISNULL(RTARDSD.DRFId,0)<>0               
 AND CAST(RTARDSD.ProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected letter sent to Client - Maker')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 AND ISNULL(RTARDSD.DRFId,0)<>0 AND RDRFOPRD.IsFileGenerate=4 AND CAST(RDRFOPRD.FileGenerateDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected letter sent to Client - Checker')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 AND ISNULL(RTARDSD.DRFId,0)<>0 AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1  AND ISNULL(UDCDRFID.DRFId,0)=0             
  AND CAST(RDRFOPRD.ResponseUploadDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected DRF Sent to Client- In Trasit')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 AND ISNULL(DRFIRBRTA.PodNo,'''')<>'''' AND ISNULL(RTARDSD.DRFId,0)<>0 AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND ISNULL(RDRFOPRD.PodNo,'''')<>'''' AND ISNULL(RDRFOPRD.IsDocumentReceived,0)=0           
 AND ISNULL(RDRFOPRD.StatusGroup,'''') IN (''IT'','''') AND ISNULL(UDCDRFID.DRFId,0)=0              
 AND CAST(RDRFOPRD.ResponseUploadDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '            
END            
IF(@Status='RTA Rejected DRF Received by the Client And Closed')            
BEGIN            
SET @Condition = ' WHERE DRFMCPT.RTALetterGenerate=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')        
 AND ISNULL(DRFIRBRTA.PodNo,'''')<>'''' AND ISNULL(RTARDSD.DRFId,0)<>0 AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1        
 AND ISNULL(RDRFOPRD.PodNo,'''')<>'''' AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
  AND CAST(RDRFOPRD.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '        
END              
            
IF(@Status='DRF UnDelivered, Return Received by DP team')            
BEGIN            
SET @Condition = ' WHERE ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=0              
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1               
 AND ISNULL(RDRFOPRD.StatusGroup,'''') IN(''RT'',''UD'') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0        
  AND CAST(UDCDRFID.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '        
END 

IF(@Status='DRF UnDelivered, Resend to Client And Closed')            
BEGIN            
SET @Condition = ' WHERE ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=1                    
AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1        
  AND CAST(UDCDRFID.ReProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' '        
END  
            
EXEC('             
SELECT               
DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId,              
DRFIRPM.ClientName,DRFIRPM.MobileNo, CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) ''InwordProcessDate'',              
DRFIRPM.NoOfCertificates,DRFIRPD.CompanyName,DRFIRPD.ISINNo,DRFIRPD.Quantity,              
ISNULL(DRFMCPT.DRNNo,'''') ''DRNNo'',              
----CASE WHEN ISNULL(DRFIRBRTA.PodNo,'''') <> '''' THEN ISNULL(DRFIRBRTA.PodNo,'''')           
----ELSE ISNULL(DRFPIRP.PodNo,'''') END ''InwordPodNo''           
----, CASE WHEN ISNULL(DRFIRBRTA.PodNo,'''') <> '''' THEN ISNULL(DRFIRBRTA.CourierName,'''')           
----ELSE ISNULL(DRFPIRP.CourierName,'''') END ''InwordCourierName'',            
           
 ISNULL(DRFPIRP.PodNo,'''') ''InwordPodNo'',           
 ISNULL(DRFPIRP.CourierName,'''') ''InwordCourierName'',      
   
---- CASE WHEN ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=1 AND ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' THEN   
----''E-Sign DRF Upload & Verified''  
----WHEN ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0 AND ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' THEN ''DRF Hold - eSign DRF not upload''  
----WHEN ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0 AND ISNULL(CDRFAAVD.AppStatus,'''')=''Process'' THEN ''Verified''  
----END ''AadharAuthanticationStatus'',  

CASE WHEN CDRFAAVD.AppStatus=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline''
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1
THEN ''E-Sign DRF Authenticate''
WHEN CDRFAAVD.AppStatus=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline''
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0
AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
THEN ''DRF eSign Link Expired''
WHEN CDRFAAVD.AppStatus=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline''
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0
THEN ''DRF Hold - eSign Pending''
ELSE ''Verified'' END ''AadharAuthanticationStatus'',
  
CASE WHEN CAST(CDRFAAESDAPID.ResponseUploadDate as date) = ''1900-01-01'' THEN ''''   
ELSE CONVERT(VARCHAR(20),CDRFAAESDAPID.ResponseUploadDate,113) END ''ESignDocumentUploadDate'',  
  
           
CASE WHEN CAST(DRFMCPT.MakerProcessDate as date) = ''1900-01-01'' THEN ''''          
ELSE CONVERT(VARCHAR(20),DRFMCPT.MakerProcessDate,113) END ''MakerProcessDate'',           
CASE WHEN CAST(DRFMCPT.CheckerProcessDate as date) = ''1900-01-01'' THEN ''''          
ELSE CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END ''DPProcessDate'',               
CASE WHEN CAST(DRFMCPT.CDSLProcessDate as date) = ''1900-01-01'' THEN ''''          
ELSE CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END ''CDSLProcessDate'',              
CASE WHEN CAST(DRFMCPT.RTAProcessDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END ''RTAProcessDate'',            
            
 CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.PodNo,'''')           
WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.PodNo,'''')           
ELSE ISNULL(RDRFOPRD.PodNo,'''') END ''OutwordPodNo''           
           
 ,CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.CourierBy,'''')            
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.CourierBy,'''')            
 ELSE ISNULL(RDRFOPRD.CourierBy,'''') END ''OutwordCourierName''             
            
 , CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN           
 CASE WHEN CAST(RDRFOPRD.ResponseUploadDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END            
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN            
 CASE WHEN CAST(TDRFORSRTAD.ResponseUploadDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END            
 ELSE CASE WHEN CAST(RDRFOPRD.ResponseUploadDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END            
 END ''OutwordProcessDate'',           
            
 CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN           
 CASE WHEN CAST(RDRFOPRD.DocumentReceivedDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END            
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN            
 CASE WHEN CAST(TDRFORSRTAD.DocumentReceivedDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),TDRFORSRTAD.DocumentReceivedDate,113) END            
 ELSE CASE WHEN CAST(RDRFOPRD.DocumentReceivedDate as date) = ''1900-01-01'' THEN ''''          
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END            
 END ''DRFDeliveredDate'',           
           
 CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.StatusDescription,'''')            
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.StatusDescription,'''')           
 ELSE ISNULL(RDRFOPRD.StatusDescription,'''') END ''StatusDescription'',           
            
 '''+@Status+''' ''ProcessStatus'',              
            
 CASE         
 WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.IsRejectionRemarks,'''')<>'''' THEN DRFIRPM.IsRejectionRemarks        
 WHEN DRFMCPT.IsCheckerRejected =1 AND ISNULL(DRFMCPT.CheckerProcessRemarks,'''')<>'''' THEN DRFMCPT.CheckerProcessRemarks            
 WHEN DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1 AND ISNULL(DRFMCPT.CDSLRemarks,'''')<> '''' THEN  DRFMCPT.CDSLRemarks            
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')  THEN DRFMCPT.RTARemarks            
 END ''RejectionRemarks'',            
              
CASE  
WHEN ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=1                            
 AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1              
THEN ''DRF UnDelivered, Resend to Client And Closed''

WHEN ISNULL(UDCDRFID.PodNo,'''')<>'''' AND ISNULL(UDCDRFID.IsReProcess,0)=0              
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1               
 AND ISNULL(RDRFOPRD.StatusGroup,'''') IN(''RT'',''UD'') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0              
THEN ''DRF UnDelivered, Return Received by DP team''             
            
WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected DRF Received by the Client And Closed''              
 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.StatusGroup=''IT''              
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected DRF Sent to Client- In Trasit''          
         
 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND ISNULL(RDRFOPRD.StatusGroup,'''') <>''DL''              
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 AND ISNULL(DRFIRBRTA.PodNo,'''') <>'''' THEN ''RTA Rejected letter sent to Client - Checker''         
          
 WHEN ISNULL(DRFIRBRTA.PodNo,'''')<>'''' AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=0              
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected letter sent to Client - Maker''            
         
 WHEN RTALetterGenerate=1  AND ISNULL(RTARDSD.FileName,'''')<>''''              
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected DRF Memo Scanned''              
        
 WHEN ISNULL(DRFIRBRTA.PodNo,'''')<>'''' AND TDRFORSRTAD.IsFileGenerate=5 AND RTALetterGenerate=1         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected DRF Received by DP''          
         
 WHEN ISNULL(DRFIRBRTA.PodNo,'''')='''' AND TDRFORSRTAD.IsFileGenerate=5 AND DATEDIFF(day,RTAProcessDate,getdate())>1               
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected, but Courier not Received by DP''           
         
 WHEN ISNULL(DRFIRBRTA.PodNo,'''')='''' AND TDRFORSRTAD.IsFileGenerate=5         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') NOT IN(''CONFIRMED (CREDIT CURRENT BALANCE)'','''')         
 THEN ''RTA Rejected''           
         
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'''') =''CONFIRMED (CREDIT CURRENT BALANCE)''            
 AND DRFMCPT.RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.PodNo,'''')<>''''               
 AND TDRFORSRTAD.StatusGroup=''DL'' AND TDRFORSRTAD.IsFileGenerate=5  AND ISNULL(DRFMCPT.DRNNo,'''')<>''''            
 THEN ''DRF converted in Demat And Closed''          
         
 WHEN IsRTAProcess=0 AND RTALetterGenerate=1 AND TDRFORSRTAD.IsFileGenerate=5 AND TDRFORSRTAD.IsResponseUpload=1 AND               
 ISNULL(TDRFORSRTAD.PodNo,'''')<>'''' AND TDRFORSRTAD.StatusGroup=''DL'' AND ISNULL(DRFMCPT.DRNNo,'''')<>''''        
 THEN ''Courier Received by RTA''              
              
 WHEN IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND               
 ISNULL(TDRFORSRTAD.PodNo,'''')<>'''' AND RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.StatusGroup,'''')<>''DL''         
 AND ISNULL(DRFMCPT.DRNNo,'''')<>''''        
 THEN ''DRF Send to RTA''              
             WHEN IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(DRFMCPT.DRNNo,'''')<>''''        
 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND RTALetterGenerate=1 AND              
 ISNULL(TDRFORSRTAD.PodNo,'''')='''' THEN ''DRF Dispatch to RTA - Checker''         
         
 WHEN IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5  AND ISNULL(DRFMCPT.DRNNo,'''')<>''''         
 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0 AND RTALetterGenerate=1 AND              
 ISNULL(TDRFORSRTAD.PodNo,'''')='''' THEN ''DRF Dispatch to RTA - Maker''             
         
 WHEN IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=0 AND RTALetterGenerate=1             
 AND DRFMCPT.IsCDSLProcess=1 AND ISNULL(DRFMCPT.DRNNo,'''')<>''''        
 THEN ''RTA Letter Generation''            
         
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0 AND ISNULL(DRFMCPT.DRNNo,'''')<>''''             
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=0             
 THEN ''DRF Setup in CDSL''              
        
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND RTALetterGenerate=0              
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1               
 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL''               
 THEN ''CDSL Rejected DRF Received by the Client And Closed''              
              
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND RTALetterGenerate=0              
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1               
  AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'''')<>''DL''               
 THEN ''CDSL Rejected DRF Send to Client''              
              
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0              
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLProcess=1 AND DRFMCPT.IsCDSLRejected=1              
 THEN ''DRF Rejected by CDSL''              
              
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0              
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1              
 THEN ''DRF Upload to CDSL''              
         
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1              
 AND RDRFOPRD.IsFileGenerate=2 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1              
 AND RDRFOPRD.StatusGroup=''DL'' THEN ''DP - Rejected DRF Received by the Client And Closed''              
              
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1              
 AND (RDRFOPRD.IsFileGenerate=2 OR RDRFOPRD.IsResponseUpload=1) AND RDRFOPRD.IsDocumentReceived=0              
 AND ISNULL(RDRFOPRD.StatusGroup,'''')<>''DL'' THEN ''DP - Rejected DRF Send to Client''              
              
  WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1              
 AND RDRFOPRD.IsFileGenerate=0 THEN ''DRF Verfication by DP - Rejected''              
              
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND IsCheckerProcess=1 AND IsCheckerRejected=0              
 AND RDRFOPRD.IsFileGenerate=0 THEN ''DRF Verfication by DP - Checker''               
              
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=1              
 AND RDRFOPRD.IsFileGenerate=0 THEN ''DRF Verfication by DP - Maker''               
  
 ----  WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(IsESignDocumentUpload,0)=1  
 ----THEN ''DRF e-sign Aadhar Authantication Documents Upload And Verified''  
  
 ----WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(IsESignDocumentUpload,0)=0  
 ----THEN ''DRF Hold Due to Pending e-sign Aadhar Authantication Documents'' 
 
  WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND 
  ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1 THEN 
 ''DRF e-sign Aadhar Authantication Documents Upload And Verified''
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  ''DRF Hold - Aadhar Authantication e-sign Link Expired'' 

 WHEN ISNULL(CDRFAAVD.AppStatus,'''')=''Hold'' AND ISNULL(CDRFAAVD.ApplicationType,'''')=''Offline'' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  ''DRF Hold Due to Pending e-sign Aadhar Authantication Documents'' 
              
 WHEN ISNULL(CDRFID.DocumentName,'''') <>'''' AND ISNULL(IsTransferForScanning,0)=1 AND              
 ISNULL(DRFMCPT.IsCheckerProcess,0)=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=0 THEN ''DRF Scanning''              
              
 WHEN ISNULL(CDRFID.DocumentName,'''') ='''' AND ISNULL(IsTransferForScanning,0)=1 AND              
 ISNULL(IsCheckerProcess,0)=0 AND ISNULL(IsMakerProcess,0)=0 THEN ''DRF Transfer for Scanning''              
              
 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=1 AND RDRFOPRD.IsResponseUpload=1              
 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup=''DL'' THEN ''DRF Rejected due to Invalid Client Id Received by the Client And Closed''              
              
 WHEN DRFIRPM.IsRejected=1 AND (RDRFOPRD.IsFileGenerate=1 OR RDRFOPRD.IsResponseUpload=1)              
 AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'''')<>''DL'' THEN ''DRF Rejected due to Invalid Client Id - Send to Client''              
              
 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=0 AND RDRFOPRD.IsResponseUpload=0              
 THEN ''DRF Courier Receieved And Rejected due to Invalid Client Id''              
              
 WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'''')<>''''               
 AND ISNULL(IsTransferForScanning,0)=0 AND RDRFOPRD.IsFileGenerate=0 THEN ''DRF Courier Receieved From Client''              
 END ''CurrentStatus''             
              
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)         
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)              
 ON DRFIRPM.DRFId = DRFIRPD.DRFId              
 JOIN tbl_DRFPodInwordRegistrationProcess DRFPIRP WITH(NOLOCK)              
 ON DRFPIRP.PodId = DRFIRPM.PodId              
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)              
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId              
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)              
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId          
LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)        
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId          
 ----LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)              
 ----ON DRFMCPT.DRFId = DRFIRPM.DRFId           
 ----LEFT JOIN [AGMUBODPL3].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)        
 ----ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0         
 ----LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)     
 ----ON DRFIRPM.DRFId = DRFMCPT.DRFId AND  DRFIRPM.IsRejected=0    
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)      
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0    
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)              
 ON CDRFID.DRFId = DRFIRPM.DRFId              
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)              
 ON DRFIRPM.DRFId = RTARDSD.DRFId              
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)              
 ON DRFIRPM.DRFId = UDCDRFID.DRFId   
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)   
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId 
 LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId
  
 ' +@Condition+ '            
 ')            
             
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcessCompleteStatusReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientDRFProcessCompleteStatusReport] @DRFNo VARCHAR(35)=''
AS
BEGIN       
    
--EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus @DRFNo

SELECT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo', * FROM(
  SELECT DRFIRPM.DRFId, DRFIRPM.DRFNo,
  DRFIRPM.ClientId,DRFIRPM.ClientName,DRFIRPM.MobileNo,DRFIRPD.CompanyName,
  DRFIRPD.Quantity,DRFIRPM.NoOfCertificates,

  CASE WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'')<>''    
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END 'DRF Courier Receieved From Client',
  
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>''    
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END 'DRF Courier Receieved & Rejected due to Invalid Client Id',    
  
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>'' AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=1 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1) 
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'Rejected due to Invalid Client Id - DRF Send to Client',    
 
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>'' AND ISNULL(RDRFOPRD.IsFileGenerate,0)=1 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed',      

  CASE WHEN ISNULL(CDRFID.DocumentName,'')<>''
  THEN CONVERT(VARCHAR(20),CDRFID.ProcessDate,113) END 'DRF Scanning',     
    
--CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0    
-- THEN CONVERT(VARCHAR(20),CDRFAAVD.ProcessDate,113) END 'DRF Hold Due to Pending e-sign Aadhar Authantication Documents',    
      
-- CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=1    
-- THEN CONVERT(VARCHAR(20),CDRFAAVD.IsESignDocUploadDate,113) END 'DRF e-sign Aadhar Authantication Documents Upload And Verified',  

 CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
 CONVERT(VARCHAR(20),CDRFAAESDAPID.RequestSendDate) END
  'DRF Hold Due to Pending e-sign Aadhar Authantication Documents' ,

 CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=0 THEN 
  CONVERT(VARCHAR(20),CDRFAAESDAPID.ExpiryDate) END 
  'DRF Hold - Aadhar Authantication e-sign Link Expired' ,

CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1 
 THEN CONVERT(VARCHAR(20),CDRFAAESDAPID.ResponseUploadDate) END 
 'DRF e-sign Aadhar Authantication Documents Upload And Verified',

  CASE WHEN ISNULL(DRFMCPT.IsMakerProcess,0)=1
  THEN CONVERT(VARCHAR(20),DRFMCPT.MakerProcessDate,113) END 'DRF Verfication by DP - Maker',
  CASE WHEN ISNULL(DRFMCPT.IsCheckerProcess,0)=1
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END 'DRF Verfication by DP - Checker',
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END 'DRF Verfication by DP - Rejected',
  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=2 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1) 
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'DP - Rejected DRF Send to Client',    
 
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1  AND ISNULL(RDRFOPRD.IsFileGenerate,0)=2 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'DP - Rejected DRF Received by the Client And Closed',      


  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Upload to CDSL',
       
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Rejected by CDSL',

  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=3 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1) 
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'CDSL Rejected DRF Send to Client',

  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND ISNULL(RDRFOPRD.IsFileGenerate,0)=3 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'CDSL Rejected DRF Received by the Client And Closed',
        
 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'')<>'' AND ISNULL(DRFMCPT.DRNNo,'')<>''
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0  
 THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Setup in CDSL',

 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'')<>'' AND ISNULL(DRFMCPT.DRNNo,'')<>''
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0  AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1
 THEN CONVERT(VARCHAR(20),DRFMCPT.DispatchDate,113) END 'RTA Letter Generation',

 CASE WHEN ISNULL(DRFMCPT.IsCDSLRejected,0)=0 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1  
 AND (ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5  OR ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0) 
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.FileGenerateDate,113) END 'DRF Dispatch to RTA - Maker',   

 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1     
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END 'DRF Dispatch to RTA - Checker' ,       
       
  CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1        
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END 'DRF Send to RTA' ,       
   
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND TDRFORSRTAD.IsResponseUpload=1  
 AND TDRFORSRTAD.IsDocumentReceived=1 AND ISNULL(TDRFORSRTAD.StatusGroup,'') = 'DL'
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.DocumentReceivedDate,113) END  'Courier Received by RTA',
 
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') ='CONFIRMED (CREDIT CURRENT BALANCE)'
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'DRF converted in Demat & Closed',
 
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'RTA Rejected',
  
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','') 
 AND DATEDIFF(day,RTAProcessDate,getdate())>1  AND ISNULL(DRFIRBRTA.DRFId,0) =0
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'RTA Rejected, but not Courier Received by DP',
      
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0 
 THEN CONVERT(VARCHAR(20),DRFIRBRTA.DocumentReceivedDate,113) END  'RTA Rejected DRF Received by DP',
  
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0 AND ISNULL(RTARDSD.DRFId,0)<>0
 THEN CONVERT(VARCHAR(20),RTARDSD.ProcessDate,113) END  'RTA Rejected DRF Memo Scanned',

  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')     
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0     
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END    
  'RTA Rejected letter sent to Client - Maker',     
      
  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')     
AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0     
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1    
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END    
   'RTA Rejected letter sent to Client - Checker',
   CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')     
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0     
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=0    
  AND ISNULL(RDRFOPRD.StatusGroup,'') IN('', 'IT' )   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END    
 'RTA Rejected DRF Sent to Client- In Trasit',
    
 CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')     
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0     
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=1     
  AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END    
 'RTA Rejected DRF Received by the Client & Closed'    ,
 
 CASE WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=0
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 
 AND ISNULL(RDRFOPRD.StatusGroup,'') IN('RT','UD') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END   'DRF UnDelivered, Return Received by DP team' , 
  
CASE WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=1
 AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END   'DRF UnDelivered, Resend to Client And Closed'  
  

 FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)
 ON DRFIRPM.DRFId = DRFIRPD.DRFId
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId
  LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)        
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId
 --LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)
 --ON DRFMCPT.DRFId = DRFIRPM.DRFId  
 --LEFT JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)
 --ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0    
 -- LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)      
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId AND  DRFMCPT.DRFNo=@DRFNo  
   LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFMCPT.DRFNo=@DRFNo   
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)
 ON CDRFID.DRFId = DRFIRPM.DRFId
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)
 ON DRFIRPM.DRFId = RTARDSD.DRFId 
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)
 ON DRFIRPM.DRFId = UDCDRFID.DRFId        
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)     
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId   
 LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId
    
 WHERE DRFIRPM.DRFNo = @DRFNo
 ) A
UNPIVOT    
 (    
 ProcessDate For DRFStatus IN    
 (    
 [DRF Courier Receieved From Client],    
[DRF Courier Receieved & Rejected due to Invalid Client Id],
[Rejected due to Invalid Client Id - DRF Send to Client],    
[DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed],
 [DRF Scanning],    
 [DRF Hold Due to Pending e-sign Aadhar Authantication Documents],    
 [DRF Hold - Aadhar Authantication e-sign Link Expired],
 [DRF e-sign Aadhar Authantication Documents Upload And Verified],    
 [DRF Verfication by DP - Maker],
 [DRF Verfication by DP - Checker],
 [DRF Verfication by DP - Rejected],
 [DP - Rejected DRF Send to Client],    
 [DP - Rejected DRF Received by the Client And Closed],    
 [DRF Upload to CDSL],    
 [DRF Rejected by CDSL],    
 [CDSL Rejected DRF Send to Client],     
 [CDSL Rejected DRF Received by the Client And Closed],    
 [DRF Setup in CDSL],    
 [RTA Letter Generation],    
 [DRF Dispatch to RTA - Maker],    
 [DRF Dispatch to RTA - Checker],       
 [DRF Send to RTA],      
 [Courier Received by RTA],    
 [DRF converted in Demat & Closed],    
 [RTA Rejected],    
 [RTA Rejected, but not Courier Received by DP],    
 [RTA Rejected DRF Received by DP],    
 [RTA Rejected DRF Memo Scanned],    
 [RTA Rejected letter sent to Client - Maker],    
 [RTA Rejected letter sent to Client - Checker],     
 [RTA Rejected DRF Sent to Client- In Trasit],    
[RTA Rejected DRF Received by the Client & Closed],
[DRF UnDelivered, Return Received by DP team] ,
[DRF UnDelivered, Resend to Client And Closed] 
     
 )    
 )As UnPvt

 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcessCurrentStatusDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientDRFProcessCurrentStatusDetails] @Status VARCHAR(250)
AS
BEGIN

--- EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''

SELECT * FROM (
SELECT
DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId,
DRFIRPM.ClientName,DRFIRPM.MobileNo, CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) 'InwordProcessDate',
DRFIRPM.NoOfCertificates,DRFIRPD.CompanyName,DRFIRPD.ISINNo,DRFIRPD.Quantity,
ISNULL(DRFMCPT.DRNNo,'') 'DRNNo',
CASE WHEN ISNULL(DRFIRBRTA.PodNo,'') <> '' THEN ISNULL(DRFIRBRTA.PodNo,'')   
ELSE ISNULL(DRFPIRP.PodNo,'') END 'InwordPodNo',   
CASE WHEN ISNULL(DRFIRBRTA.PodNo,'') <> '' THEN ISNULL(DRFIRBRTA.CourierName,'')   
ELSE ISNULL(DRFPIRP.CourierName,'') END 'InwordCourierName',  

--CASE WHEN CDRFAAVD.IsESignDocumentUpload=1 AND CDRFAAVD.AppStatus='Hold' THEN 
--'E-Sign DRF Upload & Verified'
--WHEN CDRFAAVD.IsESignDocumentUpload=0 AND CDRFAAVD.AppStatus='Hold' THEN 'DRF Hold - eSign DRF not upload'
--WHEN CDRFAAVD.IsESignDocumentUpload=0 AND CDRFAAVD.AppStatus='Process' THEN 'Verified'
--END 'AadharAuthanticationStatus',

CASE WHEN CDRFAAVD.AppStatus='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline'
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1
THEN 'E-Sign DRF Authenticate'
WHEN CDRFAAVD.AppStatus='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline'
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0
AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
THEN 'DRF eSign Link Expired'
WHEN CDRFAAVD.AppStatus='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline'
AND ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0
THEN 'DRF Hold - eSign Pending'
ELSE 'Verified' END 'AadharAuthanticationStatus',

CASE WHEN CAST(CDRFAAESDAPID.ResponseUploadDate as date) = '1900-01-01' THEN '' 
ELSE CONVERT(VARCHAR(20),CDRFAAESDAPID.ResponseUploadDate,113) END 'ESignDocumentUploadDate',
   
CASE WHEN CAST(DRFMCPT.MakerProcessDate as date) = '1900-01-01' THEN ''
ELSE CONVERT(VARCHAR(20),DRFMCPT.MakerProcessDate,113) END 'MakerProcessDate', 
CASE WHEN CAST(DRFMCPT.CheckerProcessDate as date) = '1900-01-01' THEN ''
ELSE CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END 'DPProcessDate',
CASE WHEN CAST(DRFMCPT.CDSLProcessDate as date) = '1900-01-01' THEN ''
ELSE CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'CDSLProcessDate',
CASE WHEN CAST(DRFMCPT.RTAProcessDate as date) = '1900-01-01' THEN ''
ELSE CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END 'RTAProcessDate',
CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.PodNo,'')   
WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.PodNo,'')   
ELSE ISNULL(RDRFOPRD.PodNo,'') END 'OutwordPodNo'   
   
 ,CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.CourierBy,'')
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.CourierBy,'')
 ELSE ISNULL(RDRFOPRD.CourierBy,'') END 'OutwordCourierName' 

 , CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN   
 CASE WHEN CAST(RDRFOPRD.ResponseUploadDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN
 CASE WHEN CAST(TDRFORSRTAD.ResponseUploadDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END
 ELSE CASE WHEN CAST(RDRFOPRD.ResponseUploadDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END
 END   
 'OutwordProcessDate',   

 CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN   
 CASE WHEN CAST(RDRFOPRD.DocumentReceivedDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN
 CASE WHEN CAST(TDRFORSRTAD.DocumentReceivedDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),TDRFORSRTAD.DocumentReceivedDate,113) END
 ELSE CASE WHEN CAST(RDRFOPRD.DocumentReceivedDate as date) = '1900-01-01' THEN ''
 ELSE CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END
 END 'DRFDeliveredDate',   
   
 CASE WHEN RDRFOPRD.IsFileGenerate=4 THEN ISNULL(RDRFOPRD.StatusDescription,'')
 WHEN TDRFORSRTAD.IsFileGenerate=5 THEN ISNULL(TDRFORSRTAD.StatusDescription,'')   
 ELSE ISNULL(RDRFOPRD.StatusDescription,'') END 'StatusDescription',
 @Status 'ProcessStatus',
 
 CASE  
 WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.IsRejectionRemarks,'')<>'' THEN DRFIRPM.IsRejectionRemarks 
 WHEN DRFMCPT.IsCheckerRejected =1 AND ISNULL(DRFMCPT.CheckerProcessRemarks,'')<>'' THEN DRFMCPT.CheckerProcessRemarks
 WHEN DRFMCPT.IsCDSLRejected=1 AND ISNULL(DRFMCPT.CDSLRemarks,'')<> '' THEN  DRFMCPT.CDSLRemarks
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','') THEN DRFMCPT.RTARemarks  
 END 'RejectionRemarks',

CASE
 WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=1   
AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1  
AND CAST(UDCDRFID.DRFReceivedDate as date)>= CAST((GETDATE()-10) as date)
THEN 'DRF UnDelivered, Resend to Client And Close' 

 WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=0 
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1  
 AND ISNULL(RDRFOPRD.StatusGroup,'') IN('RT','UD') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0 
THEN 'DRF UnDelivered, Return Received by DP team'  

WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL'
AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-12) as date)
 THEN 'RTA Rejected DRF Received by the Client And Closed'

 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.StatusGroup='IT'
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN 'RTA Rejected DRF Sent to Client- In Trasit'

 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND ISNULL(RDRFOPRD.StatusGroup,'') <>'DL'
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 AND ISNULL(DRFIRBRTA.PodNo,'') <>'' THEN 'RTA Rejected letter sent to Client - Checker'

 WHEN ISNULL(DRFIRBRTA.PodNo,'')<>'' AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=0
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN 'RTA Rejected letter sent to Client - Maker'

 WHEN RTALetterGenerate=1  AND ISNULL(RTARDSD.FileName,'')<>''
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN 'RTA Rejected DRF Memo Scanned'

 WHEN ISNULL(DRFIRBRTA.PodNo,'')<>'' AND TDRFORSRTAD.IsFileGenerate=5 
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN 'RTA Rejected DRF Received by DP'
 
 WHEN ISNULL(DRFIRBRTA.PodNo,'')='' AND TDRFORSRTAD.IsFileGenerate=5 AND RTALetterGenerate=1 
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','') AND DATEDIFF(day,RTAProcessDate,getdate())>1
 THEN 'RTA Rejected, but Courier not Received by DP'

 WHEN ISNULL(DRFIRBRTA.PodNo,'')='' AND TDRFORSRTAD.IsFileGenerate=5 AND RTALetterGenerate=1 
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')
 THEN 'RTA Rejected'
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') ='CONFIRMED (CREDIT CURRENT BALANCE)'
 AND RTALetterGenerate=1  AND ISNULL(TDRFORSRTAD.PodNo,'')<>''
 AND TDRFORSRTAD.StatusGroup='DL' AND TDRFORSRTAD.IsFileGenerate=5   
 AND CAST(DRFMCPT.RTAProcessDate as date)>= CAST((GETDATE()-15) as date)
 THEN 'DRF converted in Demat And Closed'
 
 WHEN IsRTAProcess=0 AND RTALetterGenerate=1 AND TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND
 ISNULL(TDRFORSRTAD.PodNo,'')<>'' AND ISNULL(TDRFORSRTAD.StatusGroup,0)='DL' THEN 'Courier Received by RTA'

 WHEN IsRTAProcess=0 AND RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND TDRFORSRTAD.IsResponseUpload=1 AND
 ISNULL(TDRFORSRTAD.PodNo,'')<>'' AND ISNULL(TDRFORSRTAD.StatusGroup,'')<>'DL'
 THEN 'DRF Send to RTA'

 WHEN IsRTAProcess=0 AND RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 
 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1   AND ISNULL(DRFMCPT.DRNNO,'')<>''
 AND ISNULL(TDRFORSRTAD.PodNo,'')='' THEN 'DRF Dispatch to RTA - Checker'

 WHEN IsRTAProcess=0 AND RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 
 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0 AND ISNULL(DRFMCPT.DRNNO,'')<>'' AND
 ISNULL(TDRFORSRTAD.PodNo,'')='' THEN 'DRF Dispatch to RTA - Maker'
 WHEN IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=0 AND RTALetterGenerate=1
 AND ISNULL(DRFMCPT.DRNNO,'')<>''
 THEN 'RTA Letter Generation'
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0
 AND BatchUploadInCDSL=1  AND IsCDSLRejected=0  AND IsCDSLProcess=1  AND ISNULL(DRFMCPT.DRNNO,'')<>''
 THEN 'DRF Setup in CDSL'

 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND RTALetterGenerate=0
 AND BatchUploadInCDSL=1  AND IsCDSLRejected=1  AND IsCDSLProcess=1
 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL'
 AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-10) as date)
 THEN 'CDSL Rejected DRF Received by the Client And Closed'
   
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND RTALetterGenerate=0
 AND BatchUploadInCDSL=1  AND IsCDSLRejected=1  AND IsCDSLProcess=1
 AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL'
 THEN 'CDSL Rejected DRF Send to Client'

 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0
 AND BatchUploadInCDSL=1  AND IsCDSLRejected=1  AND IsCDSLProcess=1
THEN 'DRF Rejected by CDSL'

 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND RTALetterGenerate=0
 AND BatchUploadInCDSL=1
 THEN 'DRF Upload to CDSL'

 WHEN BatchUploadInCDSL=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1
 AND RDRFOPRD.IsFileGenerate=2 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1
 AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-10) as date)
 AND RDRFOPRD.StatusGroup='DL' THEN 'DP - Rejected DRF Received by the Client And Closed'

 WHEN BatchUploadInCDSL=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1
 AND (RDRFOPRD.IsFileGenerate=2 OR RDRFOPRD.IsResponseUpload=1) AND RDRFOPRD.IsDocumentReceived=0
 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL' THEN 'DP - Rejected DRF Send to Client'

  WHEN BatchUploadInCDSL=0 AND IsCheckerProcess=1 AND IsCheckerRejected=1
 AND RDRFOPRD.IsFileGenerate=0 AND RDRFOPRD.IsDocumentReceived=0
  THEN 'DRF Verfication by DP - Rejected'

 WHEN BatchUploadInCDSL=0 AND IsCheckerProcess=1 AND IsCheckerRejected=0
 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Verfication by DP - Checker'

 WHEN BatchUploadInCDSL=0 AND IsCheckerProcess=0 AND IsMakerProcess=1
 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Verfication by DP - Maker'   
 
 -- WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(IsESignDocumentUpload,0)=1
 --THEN 'DRF e-sign Aadhar Authantication Documents Upload And Verified'

 --WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(IsESignDocumentUpload,0)=0
 --THEN 'DRF Hold Due to Pending e-sign Aadhar Authantication Documents'

 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1 THEN 
 'DRF e-sign Aadhar Authantication Documents Upload And Verified'
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  'DRF Hold - Aadhar Authantication e-sign Link Expired' 
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  'DRF Hold Due to Pending e-sign Aadhar Authantication Documents' 


 WHEN ISNULL(CDRFID.DocumentName,'') <>'' AND IsTransferForScanning=1 AND
 ISNULL(IsCheckerProcess,0)=0 AND ISNULL(IsMakerProcess,0)=0 THEN 'DRF Scanning'

 WHEN ISNULL(CDRFID.DocumentName,'') ='' AND ISNULL(IsTransferForScanning,0)=1 AND
 ISNULL(IsCheckerProcess,0)=0 AND ISNULL(IsMakerProcess,0)=0 THEN 'DRF Transfer for Scanning'

 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=1 AND RDRFOPRD.IsResponseUpload=1
 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL' THEN 'DRF Rejected due to Invalid Client Id Received by the Client And Closed'

 WHEN DRFIRPM.IsRejected=1 AND (RDRFOPRD.IsFileGenerate=1 OR RDRFOPRD.IsResponseUpload=1)
 AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL' THEN 'DRF Rejected due to Invalid Client Id - Send to Client'

 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=0 AND RDRFOPRD.IsResponseUpload=0
 THEN 'DRF Courier Receieved And Rejected due to Invalid Client Id'

 WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'')<>''
 AND ISNULL(IsTransferForScanning,0)=0 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Courier Receieved From Client'
 END 'CurrentStatus'


FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)
 ON DRFIRPM.DRFId = DRFIRPD.DRFId
 JOIN tbl_DRFPodInwordRegistrationProcess DRFPIRP WITH(NOLOCK)
 ON DRFPIRP.PodId = DRFIRPM.PodId
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId 
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId
 LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)  
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId
 --LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)
 --ON DRFMCPT.DRFId = DRFIRPM.DRFId   
 --LEFT JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)   
 --ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0
 --LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)  
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0 
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)
 ON CDRFID.DRFId = DRFIRPM.DRFId
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)
 ON DRFIRPM.DRFId = RTARDSD.DRFId  
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK) 
 ON DRFIRPM.DRFId = UDCDRFID.DRFId
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK) 
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId
  LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId
 ) A
 WHERE CurrentStatus = @Status
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcessDashboardStatus
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientDRFProcessDashboardStatus]                      
 AS                      
 BEGIN             
       
--- EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus '' 

/*
CREATE TABLE #DRFProcessDetails
(
DRFId bigint,
DRFNo VARCHAR(35),	
DEMRM_ID VARCHAR(25),	
CurrentStatus VARCHAR(550),	
MakerProcessStatus	VARCHAR(20),
IsMakerProcess	bit,
MakerProcessDate VARCHAR(20),
MakerBy VARCHAR(10),
IsCheckerProcess bit,	
IsCheckerRejected	bit,
CheckerProcessStatus VARCHAR(20),	
CheckerProcessRemarks VARCHAR(500),
CheckerProcessDate VARCHAR(20),
CheckerBy VARCHAR(10),	
BatchUploadInCDSL bit,
BatchNo VARCHAR(15),
DRNNo VARCHAR(25),	
IsCDSLProcess bit,	
IsCDSLRejected	bit,
CDSLStatus	VARCHAR(30),
CDSLRemarks VARCHAR(500),
CDSLProcessDate VARCHAR(20),	
RTALetterGenerate bit,
DispatchDate VARCHAR(20),
IsRTAProcess bit,	
RTAProcessDate VARCHAR(20),
RTAStatus VARCHAR(20),	
RTARemarks VARCHAR(550)
)



INSERT INTO #DRFProcessDetails
EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus
-- EXEC [196.1.115.167].ProcessAutomation.dbo.USP_GetClientDRF_DP_CDSL_RTAProcessStatus
 */

-- EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus
 
 SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) 'SRNo', DRFStatus,Orders                       
 FROM(                      
                       
 SELECT  
 ISNULL(SUM(IIF(DRFStatus='DRF UnDelivered, Resend to Client And Closed',1,0)),0) [DRF UnDelivered, Resend to Client And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='DRF UnDelivered, Return Received by DP team',1,0)),0) [DRF UnDelivered, Return Received by DP team],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected DRF Received by the Client & Closed',1,0)),0) [RTA Rejected DRF Received by the Client And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected DRF Sent to Client- In Trasit',1,0)),0) [RTA Rejected DRF Sent to Client- In Trasit],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected letter sent to Client - Checker',1,0)),0) [RTA Rejected letter sent to Client - Checker],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected letter sent to Client - Maker',1,0)),0) [RTA Rejected letter sent to Client - Maker],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected DRF Memo Scanned',1,0)),0) [RTA Rejected DRF Memo Scanned],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected DRF Received by DP',1,0)),0) [RTA Rejected DRF Received by DP],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected, but Courier not Received by DP',1,0)),0) [RTA Rejected, but Courier not Received by DP],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Rejected',1,0)),0) [RTA Rejected],                      
 ISNULL(SUM(IIF(DRFStatus='DRF converted in Demat & Closed',1,0)),0) [DRF converted in Demat And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='Courier Received by RTA',1,0)),0) [Courier Received by RTA],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Send to RTA',1,0)),0) [DRF Send to RTA],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Dispatch to RTA - Checker',1,0)),0) [DRF Dispatch to RTA - Checker],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Dispatch to RTA - Maker',1,0)),0) [DRF Dispatch to RTA - Maker],                      
 ISNULL(SUM(IIF(DRFStatus='RTA Letter Generation',1,0)),0) [RTA Letter Generation],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Setup in CDSL',1,0)),0) [DRF Setup in CDSL],                      
 ISNULL(SUM(IIF(DRFStatus='CDSL Rejected DRF Received by the Client & Closed',1,0)),0) [CDSL Rejected DRF Received by the Client And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='CDSL Rejected DRF Send to Client',1,0)),0) [CDSL Rejected DRF Send to Client],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Rejected by CDSL',1,0)),0) [DRF Rejected by CDSL],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Upload to CDSL',1,0)),0) [DRF Upload to CDSL],                      
 ISNULL(SUM(IIF(DRFStatus='DP - Rejected DRF Received by the Client & Closed',1,0)),0) [DP - Rejected DRF Received by the Client And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='DP - Rejected DRF Send to Client',1,0)),0) [DP - Rejected DRF Send to Client],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Verfication by DP - Rejected',1,0)),0) [DRF Verfication by DP - Rejected],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Verfication by DP - Checker',1,0)),0) [DRF Verfication by DP - Checker],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Verfication by DP - Maker',1,0)),0) [DRF Verfication by DP - Maker],                      
 ISNULL(SUM(IIF(DRFStatus='DRF e-sign Aadhar Authantication Documents Upload And Verified',1,0)),0) [DRF e-sign Aadhar Authantication Documents Upload And Verified],  
 ISNULL(SUM(IIF(DRFStatus='DRF Hold - Aadhar Authantication e-sign Link Expired',1,0)),0) [DRF Hold - Aadhar Authantication e-sign Link Expired],
 ISNULL(SUM(IIF(DRFStatus='DRF Hold Due to Pending e-sign Aadhar Authantication Documents',1,0)),0) [DRF Hold Due to Pending e-sign Aadhar Authantication Documents],  
 ISNULL(SUM(IIF(DRFStatus='DRF Scanning',1,0)),0) [DRF Scanning],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Transfer for Scanning',1,0)),0) [DRF Transfer for Scanning],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Rejected due to Invalid Client Id Received by the Client & Closed',1,0)),0) [DRF Rejected due to Invalid Client Id Received by the Client And Closed],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Rejected due to Invalid Client Id - Send to Client',1,0)),0) [DRF Rejected due to Invalid Client Id - Send to Client],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Courier Receieved & Rejected due to Invalid Client Id',1,0)),0) [DRF Courier Receieved And Rejected due to Invalid Client Id],                      
 ISNULL(SUM(IIF(DRFStatus='DRF Courier Receieved From Client',1,0)),0) [DRF Courier Receieved From Client]          
                      
 FROM (                      
 SELECT 
 CASE           
 WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=1                   
 AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1  
 AND CAST(UDCDRFID.DRFReceivedDate as date)>= CAST((GETDATE()-10) as date)
 THEN 'DRF UnDelivered, Resend to Client And Closed'    
            
 WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=0            
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1             
 AND ISNULL(RDRFOPRD.StatusGroup,'') IN('RT','UD') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0            
 THEN 'DRF UnDelivered, Return Received by DP team'           
          
 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL'                       
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-12) as date) 
 THEN 'RTA Rejected DRF Received by the Client & Closed'                      
        
 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.StatusGroup='IT'        
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 THEN 'RTA Rejected DRF Sent to Client- In Trasit'                      
 WHEN RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=1 AND ISNULL(RDRFOPRD.StatusGroup,'') <>'DL'                      
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 AND ISNULL(DRFIRBRTA.PodNo,'') <>'' THEN 'RTA Rejected letter sent to Client - Checker'                 
                 
 WHEN ISNULL(DRFIRBRTA.PodNo,'')<>'' AND RDRFOPRD.IsFileGenerate=4 AND RDRFOPRD.IsResponseUpload=0         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')                      
 THEN 'RTA Rejected letter sent to Client - Maker'                      
         
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 AND ISNULL(RTARDSD.FileName,'')<>'' AND ISNULL(DRFIRBRTA.PodNo,'')<>''                      
 THEN 'RTA Rejected DRF Memo Scanned'                      
        
 WHEN ISNULL(DRFIRBRTA.PodNo,'')<>'' AND TDRFORSRTAD.IsFileGenerate=5         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 THEN 'RTA Rejected DRF Received by DP'                       
        
 WHEN ISNULL(DRFIRBRTA.PodNo,'')='' AND TDRFORSRTAD.IsFileGenerate=5         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')        
 AND DATEDIFF(day,RTAProcessDate,getdate())>1                       
 THEN 'RTA Rejected, but Courier not Received by DP'        
         
 WHEN ISNULL(DRFIRBRTA.PodNo,'')='' AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5         
 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')                     
 THEN 'RTA Rejected'                    
         
 WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') ='CONFIRMED (CREDIT CURRENT BALANCE)'        
 AND DRFMCPT.RTALetterGenerate=1 AND ISNULL(TDRFORSRTAD.PodNo,'')<>''                       
 AND ISNULL(TDRFORSRTAD.StatusGroup,'')='DL' AND TDRFORSRTAD.IsFileGenerate=5 
  AND CAST(DRFMCPT.RTAProcessDate as date)>= CAST((GETDATE()-15) as date)  
 THEN 'DRF converted in Demat & Closed'         
         
 WHEN DRFMCPT.IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5         
 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND                       
 ISNULL(TDRFORSRTAD.PodNo,'')<>'' AND TDRFORSRTAD.StatusGroup='DL' THEN 'Courier Received by RTA'                      
                      
 WHEN DRFMCPT.IsRTAProcess=0 AND TDRFORSRTAD.IsFileGenerate=5         
 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND                       
 ISNULL(TDRFORSRTAD.PodNo,'')<>'' AND ISNULL(TDRFORSRTAD.StatusGroup,'')<>'DL'                       
 THEN 'DRF Send to RTA'                      
                      
 WHEN DRFMCPT.IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1        
AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1 AND                      
 ISNULL(TDRFORSRTAD.PodNo,'')='' THEN 'DRF Dispatch to RTA - Checker'         
         
 WHEN DRFMCPT.IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5         
 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0 AND                      
 ISNULL(TDRFORSRTAD.PodNo,'')='' THEN 'DRF Dispatch to RTA - Maker'          
         
 WHEN DRFMCPT.IsRTAProcess=0 AND ISNULL(TDRFORSRTAD.IsFileGenerate,0)=0         
 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1  AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1                   
 THEN 'RTA Letter Generation'                   
         
 WHEN DRFMCPT.IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=0                      
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1 AND DRFMCPT.IsCDSLRejected=0         
 AND ISNULL(DRFMCPT.DRNNo,'')<>''                     
 THEN 'DRF Setup in CDSL'                      
        
 WHEN IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=0                     
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLRejected=1 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1                      
 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL'                       
 AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-12) as date) 
 THEN 'CDSL Rejected DRF Received by the Client & Closed'                      
                      
 WHEN DRFMCPT.IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=3 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=0              
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLRejected=1 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1                         
 AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL'                       
 THEN 'CDSL Rejected DRF Send to Client'                      
                      
 WHEN DRFMCPT.IsRTAProcess=0 AND RDRFOPRD.IsFileGenerate=0 AND DRFMCPT.RTALetterGenerate=0                      
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND DRFMCPT.IsCDSLRejected=1  AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1                    
 THEN 'DRF Rejected by CDSL'                      
                      
 WHEN ISNULL(DRFMCPT.IsRTAProcess,0)=0 AND ISNULL(RDRFOPRD.IsFileGenerate,0)=0 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=0                      
 AND ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1               
 THEN 'DRF Upload to CDSL'            
         
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1                      
 AND RDRFOPRD.IsFileGenerate=2 AND RDRFOPRD.IsResponseUpload=1 AND RDRFOPRD.IsDocumentReceived=1                      
 AND CAST(RDRFOPRD.DocumentReceivedDate as date)>= CAST((GETDATE()-12) as date) 
 AND RDRFOPRD.StatusGroup='DL' THEN 'DP - Rejected DRF Received by the Client & Closed'                      
                      
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1                     
 AND (RDRFOPRD.IsFileGenerate=2 OR RDRFOPRD.IsResponseUpload=1)               
 AND RDRFOPRD.IsDocumentReceived=0                      
 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL'               
 THEN 'DP - Rejected DRF Send to Client'                                    
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1                      
 AND RDRFOPRD.IsFileGenerate=0              
 AND RDRFOPRD.IsDocumentReceived=0                      
 THEN 'DRF Verfication by DP - Rejected'               
                      
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=0                      
 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Verfication by DP - Checker'                       
                      
 WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=1                      
 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Verfication by DP - Maker'                       
  
 --WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(IsESignDocumentUpload,0)=1  
 --THEN 'DRF e-sign Aadhar Authantication Documents Upload And Verified'

 --WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(IsESignDocumentUpload,0)=0  
 --THEN 'DRF Hold Due to Pending e-sign Aadhar Authantication Documents' 
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1 THEN 
 'DRF e-sign Aadhar Authantication Documents Upload And Verified'
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  'DRF Hold - Aadhar Authantication e-sign Link Expired' 
 
 WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN 
  'DRF Hold Due to Pending e-sign Aadhar Authantication Documents' 

 WHEN ISNULL(CDRFID.DocumentName,'') <>'' AND IsTransferForScanning=1 AND       
 ISNULL(DRFMCPT.IsCheckerProcess,0)=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=0 THEN 'DRF Scanning'                             
                      
 WHEN ISNULL(CDRFID.DocumentName,'') ='' AND IsTransferForScanning=1 AND                      
 ISNULL(DRFMCPT.IsCheckerProcess,0)=0 AND ISNULL(DRFMCPT.IsMakerProcess,0)=0 THEN 'DRF Transfer for Scanning'                      
                      
 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=1 AND RDRFOPRD.IsResponseUpload=1                      
 AND RDRFOPRD.IsDocumentReceived=1 AND RDRFOPRD.StatusGroup='DL' THEN 'DRF Rejected due to Invalid Client Id Received by the Client & Closed'                      
                      
 WHEN DRFIRPM.IsRejected=1 AND (RDRFOPRD.IsFileGenerate=1 OR RDRFOPRD.IsResponseUpload=1)                      
 AND RDRFOPRD.IsDocumentReceived=0 AND ISNULL(RDRFOPRD.StatusGroup,'')<>'DL' THEN 'DRF Rejected due to Invalid Client Id - Send to Client'                      
                      
 WHEN DRFIRPM.IsRejected=1 AND RDRFOPRD.IsFileGenerate=0 AND RDRFOPRD.IsResponseUpload=0                      
 THEN 'DRF Courier Receieved & Rejected due to Invalid Client Id'                      
                      
 WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'')<>''                      
 AND ISNULL(IsTransferForScanning,0)=0 AND RDRFOPRD.IsFileGenerate=0 THEN 'DRF Courier Receieved From Client'                      
            
 END 'DRFStatus'                      
                      
 FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)                      
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)                      
 ON DRFIRPM.DRFId = DRFIRPD.DRFId                      
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)                      
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId                      
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)                      
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId                   
  LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)                
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId                 
 --LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)                      
 --ON DRFMCPT.DRFId = DRFIRPM.DRFId          
 --LEFT JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)                        
 --ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0       
 --LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)    
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)    
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0  
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)                      
 ON CDRFID.DRFId = DRFIRPM.DRFId                      
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)                      
 ON DRFIRPM.DRFId = RTARDSD.DRFId             
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)            
 ON DRFIRPM.DRFId = UDCDRFID.DRFId      
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)   
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId 
 LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId
 ) A                      
 )AA                      
 UNPIVOT                      
 (                      
 Orders For DRFStatus IN                      
 (                      
 [DRF Courier Receieved From Client],                      
[DRF Courier Receieved And Rejected due to Invalid Client Id],                      
[DRF Rejected due to Invalid Client Id - Send to Client],                      
[DRF Rejected due to Invalid Client Id Received by the Client And Closed],                       
 [DRF Transfer for Scanning],                      
 [DRF Scanning],    
 [DRF Hold Due to Pending e-sign Aadhar Authantication Documents],  
 [DRF Hold - Aadhar Authantication e-sign Link Expired],
 [DRF e-sign Aadhar Authantication Documents Upload And Verified],  
 [DRF Verfication by DP - Maker],                      
 [DRF Verfication by DP - Checker],               
 [DRF Verfication by DP - Rejected],              
 [DP - Rejected DRF Send to Client],                    
 [DP - Rejected DRF Received by the Client And Closed],                      
 [DRF Upload to CDSL],                      
 [DRF Rejected by CDSL],                      
 [CDSL Rejected DRF Send to Client],                      
 [CDSL Rejected DRF Received by the Client And Closed],                      
 [DRF Setup in CDSL],                      
 [RTA Letter Generation],                      
 [DRF Dispatch to RTA - Maker],                      
 [DRF Dispatch to RTA - Checker],                      
 [DRF Send to RTA],                      
 [Courier Received by RTA],                      
 [DRF converted in Demat And Closed],                      
 [RTA Rejected],                      
 [RTA Rejected, but Courier not Received by DP],                      
 [RTA Rejected DRF Received by DP],                      
 [RTA Rejected DRF Memo Scanned],                      
 [RTA Rejected letter sent to Client - Maker],                      
 [RTA Rejected letter sent to Client - Checker],                       
 [RTA Rejected DRF Sent to Client- In Trasit],                      
[RTA Rejected DRF Received by the Client And Closed] ,          
[DRF UnDelivered, Return Received by DP team],          
[DRF UnDelivered, Resend to Client And Closed]                       
 )                      
 )As UnPvt                      
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFProcessRejectionStatusDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientDRFProcessRejectionStatusDetails @ClientId VARCHAR(45)=''
AS
BEGIN 
CREATE TABLE #DRFDetails
(
DRFNo VARCHAR(35),
ProcessStatus VARCHAR(MAX),
ProcessDate VARCHAR(25)
)

EXEC('
INSERT INTO #DRFDetails
 SELECT * 
 FROM (       
 Select * from Openquery([AGMUBODPL3],''select DEMRM_SLIP_SERIAL_NO, [DMAT].citrus_usr.gettranstype(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessStatus'''',       
 [DMAT].citrus_usr.gettranstype_date(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessDate''''       
 from [DMAT].[citrus_usr].DEMAT_REQUEST_MSTR       
 WHERE DEMRM_SLIP_SERIAL_NO  In (SELECT DRFNo FROM [MIS].ProcessAutomation.dbo.tbl_DRFInwordRegistrationProcessMaster WHERE ClientId ='+@ClientId+')'')       
 )A 
 
 INSERT INTO #DRFDetails
 SELECT * 
 FROM (       
 Select * from Openquery([AngelDP5],''select DEMRM_SLIP_SERIAL_NO, [DMAT].citrus_usr.gettranstype(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessStatus'''',       
 [DMAT].citrus_usr.gettranstype_date(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessDate''''       
 from [DMAT].[citrus_usr].DEMAT_REQUEST_MSTR       
 WHERE DEMRM_SLIP_SERIAL_NO  In (SELECT DRFNo FROM [MIS].ProcessAutomation.dbo.tbl_DRFInwordRegistrationProcessMaster WHERE ClientId ='+@ClientId+')'')       
 )A 

 INSERT INTO #DRFDetails
 SELECT * 
 FROM (       
 Select * from Openquery([ATMUMBODPL03],''select DEMRM_SLIP_SERIAL_NO, [DMAT].citrus_usr.gettranstype(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessStatus'''',       
 [DMAT].citrus_usr.gettranstype_date(DEMRM_TRANSACTION_NO,DEMRM_DPAM_ID) ''''ProcessDate''''       
 from [DMAT].[citrus_usr].DEMAT_REQUEST_MSTR       
 WHERE DEMRM_SLIP_SERIAL_NO  In (SELECT DRFNo FROM [MIS].ProcessAutomation.dbo.tbl_DRFInwordRegistrationProcessMaster WHERE ClientId ='+@ClientId+')'')       
 )A 


 
SELECT DRFIRPM.DRFNo,ClientId,ClientName,CompanyName,Quantity,

CASE WHEN ISNULL(DRFMCPT.IsRTAProcess,0)=1 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1 
AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0 AND ISNULL(DRFD.ProcessStatus,'''') LIKE ''%Reject%''  THEN ''RTA REJECTED - ''+ DRFD.ProcessStatus
WHEN ISNULL(DRFMCPT.IsRTAProcess,0)=0 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1 
AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 THEN ''CDSL REJECTED - ''+ DRFMCPT.CDSLRemarks
WHEN ISNULL(DRFMCPT.IsCDSLProcess,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1
AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1 THEN ''DP REJECTED - ''+ DRFMCPT.CheckerProcessRemarks
ELSE '''' END ''RejectionRemarks'',

CASE WHEN ISNULL(DRFMCPT.IsRTAProcess,0)=1 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1 
AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0 AND ISNULL(DRFD.ProcessStatus,'''') LIKE ''%Reject%'' THEN DRFD.ProcessDate
WHEN ISNULL(DRFMCPT.IsRTAProcess,0)=0 AND ISNULL(DRFMCPT.IsCDSLProcess,0)=1 
AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 THEN  DRFMCPT.CDSLProcessDate
WHEN ISNULL(DRFMCPT.IsCDSLProcess,0)=0 AND ISNULL(DRFMCPT.IsCheckerProcess,0)=1
AND ISNULL(DRFMCPT.IsCheckerRejected,0)=1 THEN  DRFMCPT.CheckerProcessDate
ELSE '''' END ''ProcessDate''

FROM 
tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFIRPD.DRFId 
LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)          
 ON DRFIRPM.DRFId = DRFMCPT.DRFId
 LEFT JOIN #DRFDetails DRFD
 ON DRFD.DRFNo = DRFIRPM.DRFNo
 WHERE DRFIRPM.ClientId= '''+@ClientId+'''

 ')      

 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientDRFRejectedDetailsForOutwordProcess
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetClientDRFRejectedDetailsForOutwordProcess]         
@ReportType VARCHAR(255)=''          
AS        
BEGIN         
         
---EXEC [USP_GetClientDRF_AllProcessCompleteStatusDetails]    
           
DECLARE @Condition VARCHAR(MAX)=''          
           
IF(@ReportType='InValidClientId')        
BEGIN        
SET @Condition = ' AND DRFIRPM.IsRejected=1 '        
END        
IF(@ReportType='DP_Rejected')        
BEGIN        
SET @Condition = ' AND DRFMCPT.IsCheckerRejected=1 '        
END        
IF(@ReportType='CDSL_Rejected')        
BEGIN        
SET @Condition = ' AND DRFMCPT.IsCDSLRejected=1 '        
END        
IF(@ReportType='RTA_Rejected')        
BEGIN        
SET @Condition = ' AND DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0 '        
END        
IF(@ReportType='DRFAllRejected' OR ISNULL(@ReportType,'')='')        
BEGIN        
SET @Condition = ' AND (DRFIRPM.IsRejected=1 OR DRFMCPT.IsCheckerRejected=1 OR DRFMCPT.IsCDSLRejected=1 OR (DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0)) '        
END        
          
EXEC('          
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) ''SRNo'', * FROM(        
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,         
DRFIRPD.CompanyName,DRFIRPM.NoOfCertificates,DRFIRPD.Quantity,        
AMCD.l_city+''-''+AMCD.l_zip ''CityPincode'' ,          
ISNULL(DRFMCPT.DRNNo,'''') ''DRNNo'',          
          
--CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'''')<> '''' AND isnull(DMATRMT.DEMRM_TRANSACTION_NO ,'''') <> '''' AND ISNULL(DMATRMT.DEMRM_STATUS,'''')<>''F'' THEN DMATRMT.DEMRM_TRANSACTION_NO        
--ELSE '' END ''DRNNo'',        
        
--CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'''')<> '''' AND ISNULL(DMATRMT.DEMRM_STATUS,'''')=''F'' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''''  THEN ''2''        
--WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '' AND DMATDMK.demrm_res_desc_intobj = '''' THEN ''3''        
--WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '' OR DMATDMK.demrm_res_desc_intobj = '''') THEN ''3''        
--END ''StatusCode'',        
        
--CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'''')=''F'' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''''  THEN ''CDSL REJECTED''        
--WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '''' AND DMATDMK.demrm_res_desc_intobj = '''' THEN ''DP REJECTED''        
--WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '''' OR DMATDMK.demrm_res_desc_intobj = '''') THEN ''DP REJECTED''        
--END ''Status'',        
        
--CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'''')<> '''' AND ISNULL(DMATRMT.DEMRM_STATUS,'')=''F'' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''''  THEN DMATRMT.DEMRM_INTERNAL_REJ        
--WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '''' AND DMATDMK.demrm_res_desc_intobj = '''' THEN DMATDMK.DEMRM_INTERNAL_REJ        
--WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '''' OR DMATDMK.demrm_res_desc_intobj = '''') THEN DMATDMK.demrm_res_desc_intobj        
--END ''Remarks''         
----CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) ''InwordProcessDate'',          
        
CASE WHEN DRFIRPM.IsRejected=1 THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113)        
WHEN DRFMCPT.IsCheckerRejected=1 THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113)        
WHEN DRFMCPT.IsCDSLRejected=1  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113)          
WHEN ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN CONVERT(VARCHAR(20),DRFIRBRTA.DocumentReceivedDate,113)          
END ''InwordProcessDate'',        
          
CASE WHEN DRFIRPM.IsRejected=1 THEN 1        
WHEN DRFMCPT.IsCheckerRejected=1 THEN 2        
WHEN DRFMCPT.IsCDSLRejected=1  THEN 3          
WHEN ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN 4        
ELSE 0 END StatusCode,          
        
CASE         
WHEN ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN ''RTA Rejected letter sent to Client - Maker''        
WHEN DRFMCPT.IsCDSLRejected=1 THEN ''DRF Rejected by CDSL''        
WHEN DRFMCPT.IsCheckerRejected=1 THEN ''DRF Verfication by DP - Rejected''        
WHEN DRFIRPM.IsRejected=1 THEN ''DRF Courier Receieved & Rejected due to Invalid Client Id''          
END ''Status'',          
CASE        
WHEN ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN ''RTA Rejected letter sent to Client - Maker''        
WHEN DRFMCPT.IsCDSLRejected=1 THEN ''DRF Rejected by CDSL''         
WHEN DRFMCPT.IsCheckerRejected=1 THEN ''DRF Verfication by DP - Rejected''         
WHEN DRFIRPM.IsRejected=1 THEN ''DRF Courier Receieved & Rejected due to Invalid Client Id''           
END ''Remarks''          
        
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)          
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)        
ON DRFIRPM.DRFId = DRFIRPD.DRFId          
JOIN tbl_DRFProcessClientMailStatusDetails DRFCMSD WITH(NOLOCK)        
ON DRFIRPM.DRFId = DRFCMSD.DRFId          
LEFT JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)          
ON DRFCMSD.cltCode = AMCD.cl_code        
LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
ON DRFIRPM.DRFId = DRFMCPT.DRFId --AND DRFIRPM.IsRejected=0        
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)        
ON RDRFOPRD.DRFId = DRFIRPM.DRFId         
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)          
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId          
LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)          
 ON DRFIRPM.DRFId = RTARDSD.DRFId          
WHERE 
(RDRFOPRD.IsFileGenerate=0 OR CAST(RDRFOPRD.FileGenerateDate as date)=CAST(GETDATE() as date))
'+@Condition+'          
) A WHERE ISNULL(StatusCode,0) <>0        
 ')         
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientExceptionDataforExport
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[USP_GetClientExceptionDataforExport]
AS

BEGIN
  Select ClientCode, 
  ClientName,
  PanNo,
  CONVERT(NVARCHAR(255),BlockedDate,103) 'BlockedDate', 
  ''UpdationDate, 
  'Block' 'ExceptionHistory'
  From ExceptionClientDetails WITH(NOLOCK)
  Union All
  Select ClientCode, 
  ClientName,
  PanNo,
  CONVERT(NVARCHAR(255),BlockedDate,103) 'BlockedDate' , 
  CONVERT(NVARCHAR(255),UpdationDate,103) 'UpdationDate',
  'Log' 'ExceptionHistory'
  from dbo.ClientLogDetails WITH(NOLOCK)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientExceptionDetails
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[USP_GetClientExceptionDetails]  
AS  
BEGIN  
  Select Distinct  
  ANG_CD.ClientCode,  
  ANG_CD.ClientName,  
  ANG_CD.Pan_No 'PanNo',  
  CAST(IsNull(ECD.IsBlocked,0) as bit) 'IsBlocked' ,  
  CAST(IsNull(ECD.IsBlocked,0) as bit) 'IsBlockedHistory' ,  
  CONVERT(NVARCHAR(255),ECD.BlockedDate,103) 'BlockedDate',  
  (Select Count(ClientCode) 'CountClientCode' from ExceptionClientDetails WITH(NOLOCK)) 'IsBlockedCount',  
  (Select Count(ClientCode) 'CountClientCode' from ClientLogDetails WITH(NOLOCK)) 'IsLogCount'  
  
  from [ABVSCITRUS].nbfc.dbo.ANG_NBFCCLIENTS ANG_CD WITH(NOLOCK)  
  LEFT JOIN ExceptionClientDetails ECD WITH(NOLOCK)  
  ON ANG_CD.ClientCode = ECD.ClientCode  
  WHERE ANG_CD.AccountType='POA' and ANG_CD.INACTIVEDATE > getdate()  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientRejectedDRFOutwordProcessReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientRejectedDRFOutwordProcessReport          
@FromDate VARCHAR(10)='', @ToDate VARCHAR(10)='',@ReportType VARCHAR(130)=''        
AS            
BEGIN          
DECLARE @Condition VARCHAR(MAX)=''        
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)        
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)        
        
IF(@ReportType='InValidClientId')        
BEGIN        
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFIRPM.IsRejected=1 '        
END        
IF(@ReportType='DP_Rejected')        
BEGIN        
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsCheckerRejected=1 '        
END        
IF(@ReportType='CDSL_Rejected')        
BEGIN        
SET @Condition = ' AND CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsCDSLRejected=1 '        
END        
IF(@ReportType='RTA_Rejected')        
BEGIN        
SET @Condition = ' AND CAST(DRFIRBRTA.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' AND DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0 '        
END        
IF(@ReportType='DRFAllRejected')        
BEGIN        
SET @Condition = ' AND (CAST(DRFIRPM.InwordProcessDate as date) between '''+@FromDate+''' AND '''+@ToDate+''' OR CAST(DRFIRBRTA.DocumentReceivedDate as date) between '''+@FromDate+''' AND '''+@ToDate+''') 
AND (DRFMCPT.IsCheckerRejected=1 OR DRFMCPT.IsCDSLRejected=1 OR (DRFMCPT.IsRTAProcess=1 AND ISNULL(DRFIRBRTA.DRFId,0) <> 0)) '        
END        
        
----EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus            
        
EXEC('        
SELECT ROW_NUMBER() OVER(ORDER BY DRFId) ''SRNo'', * FROM(            
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,         
DRFIRPD.CompanyName,DRFIRPM.NoOfCertificates,DRFIRPD.Quantity,        
AMCD.l_city+''-''+AMCD.l_zip ''CityPincode'' ,        
ISNULL(DRFMCPT.DRNNo,'''') ''DRNNo'',          
CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) ''InwordProcessDate'',            
         
CASE        
WHEN ISNULL(DRFIRBRTA.DRFId,0) <> 0 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARDSD.DRFId,0) <>0 THEN ''RTA Rejected letter sent to Client - Maker''          
WHEN DRFMCPT.IsCDSLRejected=1 THEN ''DRF Rejected by CDSL''         
WHEN DRFMCPT.IsCheckerRejected=1 THEN ''DRF Verfication by DP - Rejected''         
WHEN DRFIRPM.IsRejected=1 THEN ''DRF Courier Receieved & Rejected due to Invalid Client Id''        
END ''Status''        
            
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)         
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)            
ON DRFIRPM.DRFId = DRFIRPD.DRFId         
JOIN tbl_DRFProcessClientMailStatusDetails DRFCMSD WITH(NOLOCK)            
ON DRFIRPM.DRFId = DRFCMSD.DRFId         
LEFT JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)         
ON DRFCMSD.cltCode = AMCD.cl_code         
 LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)        
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0          
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)         
ON RDRFOPRD.DRFId = DRFIRPM.DRFId          
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)        
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId            
LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)        
 ON DRFIRPM.DRFId = RTARDSD.DRFId            
WHERE ISNULL(RDRFOPRD.IsFileGenerate,0)=0        
AND ISNULL(RDRFOPRD.IsResponseUpload,0)=0    
'+ @Condition +'        
) A         
')        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientSebiPayoutBlockingDocuments
-- --------------------------------------------------
    
CREATE PROCEDURE USP_GetClientSebiPayoutBlockingDocuments   
@BlockingId bigint =0 ,@IsUnBlockingProcess bit=0    
AS      
BEGIN      
SELECT SEBI_BlockingId 'BlockingId',ClientPanNo,CltCode,  
CASE WHEN @IsUnBlockingProcess =1 THEN UnBlockingFileName ELSE FileName END 'FileName' 
FROM tbl_ClientSebiPayoutBlockingDetails WITH(NOLOCK)      
WHERE SEBI_BlockingId= @BlockingId      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientSebiPayoutBlockingUnBlockingReport
-- --------------------------------------------------
CREATE PROCEDURE USP_GetClientSebiPayoutBlockingUnBlockingReport
@FromDate VARCHAR(10)='', @ToDate VARCHAR(10)=''
AS
BEGIN
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)

SELECT ClientPanNo,CltCode,ClientName,BranchCode,SBTag,
BlockingTeam,Remarks,CONVERT(VARCHAR(17),BlockingDate,113) 'BlockingDate',BlockedBy
,CASE WHEN IsUnBlocked=1 THEN 'UnBlock' ELSE 'Block' END 'Status',
ISNULL(UnBlockingRemarks,'') 'UnBlockingRemarks' ,
CASE WHEN IsUnBlocked=1 THEN CONVERT(VARCHAR(17),UnBlockingDate,113)
ELSE '' END 'UnBlockingDate',UnBlockedBy
FROM tbl_ClientSebiPayoutBlockingDetails WITH(NOLOCK)
WHERE CAST(BlockingDate as date) between @FromDate AND @ToDate
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientSebiPayoutBlockUnBlockDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetClientSebiPayoutBlockUnBlockDetails         
@ClientPanNo VARCHAR(10)='',@CltCode VARCHAR(15)=''        
AS        
BEGIN        
DECLARE @Condition VARCHAR(MAX)=''        
        
IF(ISNULL(@CltCode,'')<>'')        
BEGIN        
SET @Condition = ' WHERE CltCode = '''+@CltCode+''''        
END        
IF(ISNULL(@ClientPanNo,'')<>'')        
BEGIN        
SET @Condition = ' WHERE ClientPanNo = '''+@ClientPanNo+''''        
END        
        
EXEC('        
SELECT SEBI_BlockingId ''BlockingId'', CLTSPBD.ClientPanNo,CLTSPBD.CltCode ,CLTSPBD.ClientName, CLTSPBD.SBTag ''SBTag''        
,CLTSPBD.FileName, replace(Remarks,char(13),'''') ''Remarks'',
CLTSPBD. BranchCode,  BlockingTeam,    
CONVERT(VARCHAR(17),CLTSPBD.BlockingDate,113) ''BlockingDate'', CLTSPBD.BlockedBy ''BlockingBy'',       
ISNULL(UnBlockingRemarks,'''') ''UnBlockingRemarks'',  
CASE WHEN CAST(CLTSPBD.UnBlockingDate as date) =''1900-01-01'' THEN ''''        
ELSE CONVERT(VARCHAR(17),CLTSPBD.UnBlockingDate,113) END ''UnBlockingDate''  
,ISNULL(CLTSPBD.IsUnBlocked ,0) ''IsUnBlocked''        
,CLTSPBD.UnBlockedBy ''UnBlockingBy''        
FROM tbl_ClientSebiPayoutBlockingDetails CLTSPBD WITH(NOLOCK)        
'+@Condition+'        
')        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetClientSegmentDetailsWithMargin
-- --------------------------------------------------

CREATE Procedure [dbo].[USP_GetClientSegmentDetailsWithMargin] @txtDateFilter varchar(50),@IsProcess2 bit=0, @IsMargin bit=0        
AS        
BEGIN        
  
declare @financialDate nvarchar(20), @test nvarchar(20),@financialEndDate nvarchar(20),@condition nvarchar(255) = ''    
SET @txtDateFilter = CAST(@txtDateFilter as date)
set @test = (select YEAR(@txtDateFilter))      
    
SET @financialDate = CAST((select IIF(MONTH(@txtDateFilter)<4,DATEADD(year, -1, Convert(datetime,  '04' + '/' + '01' + '/' +  @test)),Convert(datetime,  '04' + '/' + '01' + '/' +  @test))) as date)      
set @financialEndDate = CAST((SELECT DATEADD(day, -1, @financialDate)) as date)
Declare @CurrentDay NVARCHAR(50) = (SELECT REPLACE(CONVERT(CHAR(10), GETDATE(), 103), '/', ''))  

IF Exists(SELECT * FROM tblNBFCFundingProcessDetails WITH(NOLOCK) where NBFCFundingDate = @txtDateFilter AND IsProcess2 = @IsProcess2)
BEGIN
SELECT * FROM tblNBFCFundingProcessDetails WITH(NOLOCK)  where NBFCFundingDate = @txtDateFilter AND IsProcess2 = @IsProcess2
--and CLTCODE in('LCK319','M80344','D40897')
--and CLTCODE in('M591','K57298','R57275'
--,'DELL3086','S93098','A2892','B40993','DELP3545','NOD518','HMA025','R61429','JOD15445','JAIP18121','B40492') 
END
ELSE
BEGIN
Select distinct a.ClientCode 'party_code' INTO #ClientDetails from [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS a WITH(NOLOCK)           
where ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() --and ClientCode in('A10145','A111539','A1427','A1498','A15834','A17247','A17341','A37099','A39827','A40027')               
             
        
  
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSE           
from [196.1.115.196].account.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >= @financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate  
 GROUP BY CLTCODE           
        
        
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BSE           
from [196.1.115.201].Account_AB.dbo.ledger WITH(NOLOCK)          
 join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code           
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate  
 GROUP BY CLTCODE           
         
  
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSEFO           
from [196.1.115.200].AccountFO.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code           
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate   
 GROUP BY CLTCODE              
  
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NSX           
from [196.1.115.200].AccountcurFO.dbo.ledger  WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate
 GROUP BY CLTCODE              
          
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #MCX           
from [196.1.115.204].AccountMCDX.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate
 GROUP BY CLTCODE                  
        
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NCX           
from [196.1.115.204].AccountNCDX.dbo.ledger WITH(NOLOCK)          
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate 
GROUP BY CLTCODE                  
        
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #BSX         
From [196.1.115.204].AccountcurBFO.dbo.ledger WITH(NOLOCK)        
inner join  #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate   
 GROUP BY CLTCODE               
        
SELECT  CLTCODE, SUM(CASE WHEN DRCR='C' THEN VAMT ELSE VAMT*-1 END) BAL INTO #NBFC        
from [172.31.16.57].ACCOUNTNBFC.dbo.ledger WITH(NOLOCK)        
inner join #ClientDetails CD WITH(NOLOCK) on CLTCODE=CD.party_code          
WHERE EDT >=@financialDate   AND EDT<=@txtDateFilter and VDT>@financialEndDate  
group by CLTCODE               
   
        
--Step-2_ Margin        
        
--Normal        
IF(@IsMargin=1)        
BEGIN        
        
SELECT  (a.Party_Code) as CLTCODE, SUM(a.MINIMUM_MARGIN+ADNL_MRG)*-1 as NSE_MAR INTO #NSE_Margin         
 from Anand1.msajag.dbo.Tbl_mg02 a with (nolock)        
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode      
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code   
where a.Margin_Date=@txtDateFilter --AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()  
GROUP BY a.Party_Code            
        
SELECT  (a.Party_Code) as CLTCODE, SUM(a.VARAMT+A.ELM)*-1 as BSE_MAR INTO #BSE_MAR         
from Anand.Bsedb_ab.dbo.Tbl_mg02 a with (nolock)        
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode          
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code   
where a.Margin_Date=@txtDateFilter  --AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()          
 GROUP BY a.Party_Code             
        

SELECT  (a.Party_Code) as CLTCODE, SUM(a.initialmargin+a.MTMMargin+a.AddMargin+c.MTOMLOSS)*-1 as NSEFO_MAR INTO #FO_Margin
from [196.1.115.200].NSEFO.DBO.TBL_CLIENTMARGIN a with (nolock)
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode 
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code  
inner join [196.1.115.200].NSEFO.DBO.FoMarginNew c on  a.Party_Code=c.party_code and a.MARGINDATE=c.mdate
where a.MARGINDATE = @txtDateFilter --AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()       
GROUP BY a.Party_Code
              

SELECT  (a.Party_Code) as CLTCODE, SUM(a.initialmargin+a.MTMMargin+a.AddMargin+MTOMLOSS)*-1 as NSX_MAR INTO #NSX_Margin
from [196.1.115.200].NSECURFO.DBO.TBL_CLIENTMARGIN a with (nolock)
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode 
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code  
inner join [196.1.115.200].NSECURFO.DBO.FoMarginNew c on  a.Party_Code=c.party_code and a.MARGINDATE=c.mdate
where a.MARGINDATE = @txtDateFilter --AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()     
GROUP BY a.Party_Code
        
        
SELECT  (a.Party_Code) as CLTCODE, SUM(a.initialmargin+a.MTMMargin+a.AddMargin)*-1 as MCX_MAR INTO #MCX_MAR        
FROM  [196.1.115.204].MCDX.DBO.TBL_CLIENTMARGIN a with (nolock)        
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode         
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code  
where a.MARGINDATE = (Select CAST(MAX(MARGINDATE) as date) FROM [196.1.115.204].MCDX.DBO.TBL_CLIENTMARGIN with(nolock)  )  
--AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()
GROUP BY a.Party_Code           
        
SELECT  (a.Party_Code) as CLTCODE, SUM(a.initialmargin+a.MTMMargin+a.AddMargin)*-1 as NCX_MAR INTO #NCX_MAR        
from [196.1.115.204].NCDX.DBO.TBL_CLIENTMARGIN a with (nolock)        
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode        
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code  
where a.MARGINDATE = (Select CAST(MAX(MARGINDATE) as date) FROM [196.1.115.204].NCDX.DBO.TBL_CLIENTMARGIN with(nolock))   
--AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()
 GROUP BY a.Party_Code            
        
SELECT  (a.Party_Code) as CLTCODE, SUM(a.initialmargin+a.MTMMargin+a.AddMargin)*-1 as BSX_MAR INTO #BSX_MAR        
from [196.1.115.204].BSECURFO.DBO.TBL_CLIENTMARGIN a with (nolock)        
--inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode        
inner join #ClientDetails CD WITH(NOLOCK) on a.Party_Code=CD.party_code  
where a.MARGINDATE = @txtDateFilter  --AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()       
 GROUP BY a.Party_Code                
        
--Peak        
Insert into #NSE_Margin SElect (a.Party_Code) as CLTCODE,  MAX(TOTAL_MARGIN)*-1 AS NSE_MAR 
from Anand1.msajag.dbo.TBL_CMMARGIN_INTRADAY a WITH(NOLOCK)
inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode  
where MARGINDATE=@txtDateFilter AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() 
group by a.Party_Code              
  
        
Insert into #FO_Margin select (a.Party_Code) as CLTCODE,  MAX(TOTALMARGIN)*-1 AS NSEFO_MAR         
 from [196.1.115.200].NSEFO.DBO.FOMARGINNEW_INTRADAY a with (nolock)    
  inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode          
where a.MDATE= @txtDateFilter  AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()    
GROUP BY a.Party_Code               
       
        
Insert into #NSX_Margin select (a.Party_Code) as CLTCODE,  MAX(TOTALMARGIN)*-1 AS NSX_MAR         
 from [196.1.115.200].NSECURFO.DBO.FOMARGINNEW_INTRADAY a with (nolock)    
  inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode           
where a.MDATE=@txtDateFilter AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()  
 GROUP BY a.Party_Code                
        
--Max Margin        
SELECT  CLTCODE, min(NSE_MAR) as NSE_MAR INTO #NSE_MAR          
 from #NSE_Margin GROUP BY CLTCODE               
        
SELECT  CLTCODE, min(NSEFO_MAR) as NSEFO_MAR INTO #FO_MAR          
 from #FO_Margin GROUP BY CLTCODE                       
        
SELECT  CLTCODE, min(NSX_MAR) as NSX_MAR INTO #NSX_MAR          
 from #NSX_Margin GROUP BY CLTCODE               
       
END        
        
--Step-3_Pledge        
        
SELECT a.BCLTDPID AS ACCNO,a.PARTY_CODE,a.SCRIP_CD,a.SERIES,a.CERTNO,SUM(a.QTY) AS QTY INTO #HOLD        
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS_REPORT a WITH (NOLOCK)        
inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode               
 WHERE a.DRCR = 'D' AND a.DELIVERED = '0' AND a.FILLER2 = 1 AND a.BCLTDPID <> '' AND  a.PARTY_CODE  NOT IN  ('BROKER','NSE','EXE')        
 AND BCLTDPID = '1203320030135814'            
 and TransDate<= @txtDateFilter  AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()
 GROUP BY a.BCLTDPID,a.PARTY_CODE,a.SCRIP_CD,a.SERIES,a.CERTNO        
        
ALTER TABLE #HOLD        
ADD CLSRATE MONEY        
        
----         
        
UPDATE A SET CLSRATE = B.PRE_CL_RATE FROM #HOLD A , ANAND1.MSAJAG.DBO.CLOSING B WITH (NOLOCK) WHERE SYSDATE = @txtDateFilter        
AND A.SCRIP_CD = B.SCRIP_CD AND A.SERIES = B.SERIES        
        
SELECT * INTO #BSECLR FROM ANAND.BSEDB_AB.DBO.CLOSING WITH (NOLOCK)  WHERE SYSDATE = @txtDateFilter  
        
UPDATE A SET CLSRATE = B.CL_RATE FROM #HOLD A , #BSECLR B WHERE SYSDATE = @txtDateFilter  
AND A.SCRIP_CD = B.SCRIP_CD AND A.SERIES = B.SERIES        
        
UPDATE #HOLD SET CLSRATE = 0 WHERE CLSRATE IS NULL        
        
ALTER TABLE #HOLD        
ADD VAR_MRG MONEY        
        
        
UPDATE A SET VAR_MRG = AppVar FROM #HOLD A, ANAND1.MSAJAG.DBO.VARDETAIL B WITH (NOLOCK)        
WHERE DETAILKEY = @CurrentDay AND CERTNO = ISIN         
        
UPDATE #HOLD SET  VAR_MRG = 0 WHERE VAR_MRG IS NULL        
      
--        
        
SELECT (PARTY_CODE) as CLTCODE ,HLD_VAL = SUM(QTY*CLSRATE),AHC_VAL = SUM((QTY*CLSRATE)-((CLSRATE*VAR_MRG)/100)*QTY) into #Pledge_All        
 FROM #HOLD         
GROUP BY PARTY_CODE        
ORDER BY PARTY_CODE        
--Go        
Select CLTCODE, sum(HLD_VAL) as PLEDGE into #Pledge1 from #Pledge_All GROUP BY CLTCODE        
Select CLTCODE, sum(AHC_VAL) as PLEDGE_HC into #Pledge2 from #Pledge_All GROUP BY CLTCODE        
        
        
--Step-4_ Overall Balance        
SELECT  (a.PARTY_CODE) as CLTCODE, SUM(a.CASHBENEFIT+a.MARGIN_BENEFIT) BAL INTO #EPN         
from anand1.msajag.dbo.tbl_EPN_BENEFIT a WITH(NOLOCK)        
inner join [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS b WITH(NOLOCK) on a.Party_Code=b.ClientCode     
WHERE a.TRANSDATE=@txtDateFilter AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE()      
 GROUP BY a.PARTY_CODE                
            
--Step-5_ Overall Balance        
        
CREATE TABLE #FINAL        
(CLTCODE VARCHAR(10),        
NSE MONEY,        
BSE MONEY,        
NSEFO MONEY,        
NSX MONEY,        
MCX MONEY,        
NCX MONEY,        
BSX MONEY,        
NSE_MAR MONEY,        
BSE_MAR MONEY,        
NSEFO_MAR MONEY,        
NSX_MAR MONEY,        
MCX_MAR MONEY,        
NCX_MAR MONEY,        
BSX_MAR MONEY,        
PLEDGE MONEY,        
PLEDGE_HC MONEY,        
EPN MONEY,        
NBFC MONEY        
        
)        
      
IF(@IsMargin=1)        
BEGIN        
INSERT INTO  #FINAL        
SELECT DISTINCT ClTcode,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 FROM (        
SELECT * FROM #NSE        
UNION ALL        
SELECT * FROM #BSE        
UNION ALL        
SELECT * FROM #NSEFO        
UNION ALL        
SELECT * FROM #NSX        
UNION ALL        
SELECT * FROM #MCX        
UNION ALL        
SELECT * FROM #NCX        
UNION ALL        
SELECT * FROM #BSX        
UNION ALL        
SELECT * FROM #NSE_MAR        
UNION ALL        
SELECT * FROM #BSE_MAR        
UNION ALL        
SELECT * FROM #FO_MAR        
UNION ALL        
SELECT * FROM #NSX_MAR        
UNION ALL        
SELECT * FROM #MCX_MAR        
UNION ALL        
SELECT * FROM #NCX_MAR        
UNION ALL        
SELECT * FROM #BSX_MAR        
UNION ALL        
SELECT * FROM #Pledge1        
UNION ALL        
SELECT * FROM #Pledge2        
UNION ALL        
SELECT * FROM #EPN        
UNION ALL        
SELECT * FROM #NBFC        
 )A        
        
END        
ELSE        
BEGIN        
INSERT INTO  #FINAL        
SELECT DISTINCT ClTcode,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 FROM (        
SELECT * FROM #NSE        
UNION ALL        
SELECT * FROM #BSE        
UNION ALL        
SELECT * FROM #NSEFO        
UNION ALL        
SELECT * FROM #NSX        
UNION ALL        
SELECT * FROM #MCX        
UNION ALL        
SELECT * FROM #NCX        
UNION ALL        
SELECT * FROM #BSX        
UNION ALL        
SELECT * FROM #Pledge1        
UNION ALL        
SELECT * FROM #Pledge2        
UNION ALL        
SELECT * FROM #EPN        
UNION ALL        
SELECT * FROM #NBFC        
 )A        
         
END     
  
--Go        
IF(@IsMargin=1)        
BEGIN        
 UPDATE #FINAL SET NSE =BAL FROM #NSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
 UPDATE #FINAL SET BSE =BAL FROM #BSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
 UPDATE #FINAL SET NSEFO =BAL FROM #NSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
 UPDATE #FINAL SET NSX =BAL FROM #NSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET MCX =BAL FROM #MCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET NCX =BAL FROM #NCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET BSX =BAL FROM #BSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET NSE_MAR=a.NSE_MAR FROM #NSE_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET BSE_MAR=a.BSE_MAR FROM #BSE_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET NSEFO_MAR=a.NSEFO_MAR FROM #FO_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET NSX_MAR=a.NSX_MAR FROM #NSX_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET MCX_MAR=a.MCX_MAR FROM #MCX_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET NCX_MAR=a.NCX_MAR FROM #NCX_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET BSX_MAR=a.BSX_MAR FROM #BSX_MAR A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET PLEDGE=a.PLEDGE FROM #Pledge1 A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET PLEDGE_HC=a.PLEDGE_HC FROM #Pledge2 A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET EPN=a.Bal FROM #EPN A WHERE A.CLTCODE =#FINAL.CLTCODE         
        
UPDATE #FINAL SET NBFC=a.Bal FROM #NBFC A WHERE A.CLTCODE =#FINAL.CLTCODE         
    
END        
ELSE        
BEGIN        
UPDATE #FINAL SET NSE =BAL FROM #NSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
     
 UPDATE #FINAL SET BSE =BAL FROM #BSE A WHERE A.CLTCODE =#FINAL.CLTCODE         
     
 UPDATE #FINAL SET NSEFO =BAL FROM #NSEFO A WHERE A.CLTCODE =#FINAL.CLTCODE         
     
 UPDATE #FINAL SET NSX =BAL FROM #NSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET MCX =BAL FROM #MCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
     
UPDATE #FINAL SET NCX =BAL FROM #NCX A WHERE A.CLTCODE =#FINAL.CLTCODE         
      
UPDATE #FINAL SET BSX =BAL FROM #BSX A WHERE A.CLTCODE =#FINAL.CLTCODE         
        
UPDATE #FINAL SET PLEDGE=a.PLEDGE FROM #Pledge1 A WHERE A.CLTCODE =#FINAL.CLTCODE         
     
UPDATE #FINAL SET PLEDGE_HC=a.PLEDGE_HC FROM #Pledge2 A WHERE A.CLTCODE =#FINAL.CLTCODE         
       
UPDATE #FINAL SET EPN=a.Bal FROM #EPN A WHERE A.CLTCODE =#FINAL.CLTCODE         
        
UPDATE #FINAL SET NBFC=a.Bal FROM #NBFC A WHERE A.CLTCODE =#FINAL.CLTCODE         
END        
    
  
  SElect *, CAST(SUM(TOTAL_Balance + TOTAL_MAR + TOTAL_PLEDGE_HC + TOTAL_EPN ) as decimal(17,2)) 'Shortage'    
  INTO #TEMP        
  FROM ( SELECT CLTCODE, CAST(SUM(NSE) as decimal(17,2))NSE,CAST(SUM(BSE) as decimal(17,2))BSE,CAST(SUM(NSEFO) as decimal(17,2))NSEFO,CAST(SUM(NSX) as decimal(17,2))NSX,        
  CAST(SUM(MCX) as decimal(17,2))MCX,CAST(SUM(NCX) as decimal(17,2))NCX,CAST(SUM(BSX) as decimal(17,2))BSX,CAST(SUM(NSE_MAR) as decimal(17,2))NSE_MAR,        
  CAST(SUM(BSE_MAR) as decimal(17,2))BSE_MAR,CAST(SUM(NSEFO_MAR) as decimal(17,2))NSEFO_MAR,CAST(SUM(NSX_MAR) as decimal(17,2))NSX_MAR,CAST(SUM(MCX_MAR) as decimal(17,2))MCX_MAR,        
  CAST(SUM(NCX_MAR) as decimal(17,2))NCX_MAR,CAST(SUM(BSX_MAR) as decimal(17,2))BSX_MAR,        
     CAST(SUM(NSE+BSE+NSEFO+NSX+MCX+NCX+BSX) as decimal(17,2)) AS TOTAL_Balance, 
	 CAST(SUM(NSE+BSE) as decimal(17,2)) AS TOTAL_NSEBSE, 
  CAST(SUM(NSE_MAR+BSE_MAR+NSEFO_MAR+NSX_MAR+MCX_MAR+NCX_MAR+BSX_MAR) as decimal(17,2)) AS TOTAL_MAR,        
  CAST(SUM(PLEDGE) as decimal(17,2)) as TOTAL_PLEDGE,        
  CAST(SUM(PLEDGE_HC) as decimal(17,2)) as TOTAL_PLEDGE_HC,        
  CAST(SUM(EPN) as decimal(17,2)) as TOTAL_EPN,        
  CAST(SUM(NBFC) as decimal(17,2)) as NBFC--,             
    FROM #FINAL A      
            
      GROUP BY CLTCODE        
   ) T        
       
   GROUP BY CLTCODE,         
 NSE,BSE,NSEFO,NSX,MCX,NCX,BSX,NSE_MAR,BSE_MAR,NSEFO_MAR,NSX_MAR,MCX_MAR,NCX_MAR,BSX_MAR        
 ,TOTAL_Balance,TOTAL_NSEBSE,TOTAL_MAR,TOTAL_PLEDGE,TOTAL_PLEDGE_HC,TOTAL_EPN,NBFC    
 ORDER BY CLTCODE ASC            
        
     
Select Distinct PARTY_CODE, CAST(FUND_AMT AS decimal(17,2)) 'PF_VAL_HC', CAST(CASHMARG as decimal(17,2)) 'ACT_LEDGER'    
,CAST((FUND_AMT + CASHMARG ) as decimal(17,2)) 'Available_Net' INTO #SUMMARY     
From [172.31.16.57].nbfc.dbo.TBL_NBFC_SUMMARY WITH(NOLOCK) WHERE CONVERT(DATETIME,MARGINDATE) =@txtDateFilter         
        
  SELECT TT.*,ISNULL(SM.PF_VAL_HC,0) 'PF_VAL_HC', ISNULL(SM.ACT_LEDGER,0) 'ACT_LEDGER', ISNULL(SM.Available_Net,0) 'Available_Net',CAST(@txtDateFilter as date) 'NBFCFundingDate' FROM #TEMP TT LEFT JOIN #SUMMARY SM ON TT.CLTCODE = SM.PARTY_CODE    
 WHERE CLTCODE NOT IN (SELECT ClientCode FROM ExceptionClientDetails WITH(NOLOCK))         

END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetCompanyNameUsingISINo
-- --------------------------------------------------

CREATE PROCEDURE USP_GetCompanyNameUsingISINo @ISINNo VARCHAR(350)=''  ,@IsCompany bit=0    
AS      
BEGIN      
IF(@IsCompany=1)    
BEGIN    
SELECT TOP 1 ISIN_COMP_NAME 'CompanyName' FROM [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR WITH(NOLOCK)       
WHERE ISIN_COMP_NAME like ''+@ISINNo+'%'      
END    
ELSE    
BEGIN    
SELECT TOP 1 ISIN_COMP_NAME 'CompanyName' FROM [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR WITH(NOLOCK)       
WHERE ISIN_CD=@ISINNo      
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetControlAccountMasterData
-- --------------------------------------------------
Create procedure [dbo].[USP_GetControlAccountMasterData]
AS
BEGIN
select * from CltControlAccMaster WITH(NOLOCK)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFDocumentsProcessStatus
-- --------------------------------------------------

CREATE PROCEDURE USP_GetDRFDocumentsProcessStatus  
AS  
BEGIN  
SELECT ISNULL(SUM(TotalDRFPerformed),0) 'TotalDRFPerformed',
ISNULL(SUM(PendingForTransfer),0) 'PendingForTransfer',  
ISNULL(SUM(PendingForDocUploading),0) 'PendingForDocUploading' FROM(  
SELECT IIF(DRFRPM.DRFNo <> '' AND ISNULL(Extension,'')='' AND ISNULL(CDRFID.DRFId,0)=0 ,1,0) 'TotalDRFPerformed',  
IIF(ISNULL(IsTransferForScanning,0)=0,1,0) 'PendingForTransfer',  
IIF(ISNULL(DocumentName,'')='' AND ISNULL(IsTransferForScanning,0)=1,1,0) 'PendingForDocUploading'  
FROM tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)  
LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)    
ON DRFRPM.DRFId = CDRFID.DRFId    
WHERE IsRejected=0  
) A  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFInwordProcessClientReport
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetDRFInwordProcessClientReport]        
@FromDate VARCHAR(20)='', @ToDate VARCHAR(20)='' ,@IsReport bit =0        
AS       
BEGIN       
DECLARE @Condition VARCHAR(MAX)=''       
      
IF(@IsReport=1)      
BEGIN      
SET @Condition = ' WHERE CAST(DRFIRPM.InwordProcessDate as date) between CAST(CONVERT(datetime ,'''+@FromDate+''',103) as date) AND CAST(CONVERT(datetime ,'''+@ToDate+''',103) as date) '       
END
ELSE           
BEGIN      
---EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''          
      
SET @Condition = ' WHERE CAST(DRFIRPM.InwordProcessDate as date) >=  CAST((GETDATE()-5) as date) '       
END          
            
EXEC('            
SELECT DISTINCT DRFIRP.PodNo,DRFIRP.CourierName,DRFIRP.CourierReceivedDate      
,DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId,DRFIRPM.ClientName , DRFIRPM.MobileNo,         
CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,13) ''InwordProcessDate'',DRFIRPM.NoOfCertificates            
, DRFIRPD.ISINNo,DRFIRPD.CompanyName,DRFIRPD.Quantity , ISNULL(IsTransferForScanning,0) ''IsTransferForScanning'' 
--,IIF(DRFIRPM.IsRejected=1, ''Reject'',''Done'') ''Status''       
,IIF(DRFIRPM.IsRejected=1, ''DRF Courier Receieved & Rejected due to Invalid Client Id'',''DRF Courier Receieved From Client'') ''Status''      
, IIF(DRFIRPM.IsRejectionRemarks<>'''' , DRFIRPM.IsRejectionRemarks, ''DRF Courier Receieved From Client'') ''Remarks''            
----,AMCD.sub_broker ''SBTag'',AMCD.pan_gir_no ''PanNo'',    
, '''' ''SBTag''  
, '''' ''PanNo''  
----IIF(DRFMCPT.IsCheckerProcess=1,1,0) ''IsCheckerProcess''      
,0 ''IsCheckerProcess''    
FROM  tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)
LEFT JOIN  tbl_DRFPodInwordRegistrationProcess DRFIRP WITH(NOLOCK) 
ON DRFIRP.PodId = DRFIRPM.PodId
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)            
ON DRFIRPM.DRFId = DRFIRPD.DRFId            
----LEFT JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)      
----ON DRFIRPM.ClientId = AMCD.CltDpId1
 ----LEFT JOIN [AGMUBODPL3].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)
 ----ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0        
LEFT JOIN tbl_ClientDRFInwordDocuments CDRFIDOC WITH(NOLOCK)            
ON CDRFIDOC.DRFId = DRFIRPM.DRFId            
 '+@Condition+'            
 ORDER BY DRFIRPM.DRFId DESC      
' )      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFInwordRegistrationProcessDetailsReceivedByRTA
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetDRFInwordRegistrationProcessDetailsReceivedByRTA]       
@DRFNo VARCHAR(15)='',@ClientId VARCHAR(30) =''      
AS      
BEGIN      
DECLARE @Condition VARCHAR(MAX)=''       
     
---- EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''      
    
IF(ISNULL(@ClientId,'')<>'' AND ISNULL(@DRFNo,'')<>'')  
BEGIN  
SET @Condition =' ANND DRFIRPM.ClientId like ''%'+@ClientId+'''  And DRFIRPM.DRFNo= '''+@DRFNo+''' '  
END  
ELSE  
BEGIN  
IF(ISNULL(@ClientId,'')<>'')  
BEGIN  
SET @Condition =' AND DRFIRPM.ClientId like ''%'+@ClientId+''' '  
END  
IF(ISNULL(@DRFNo,'')<>'')  
BEGIN  
SET @Condition =' AND DRFIRPM.DRFNo= '''+@DRFNo+''' '  
END  
END       
      
EXEC('        
SELECT DRFIRPM.DRFId, DRFIRPM.DRFNo,DRFIRPM.ClientId,DRFIRPM.ClientName,        
DRFIRPD.CompanyName,DRFIRPD.Quantity,DRFIRPM.NoOfCertificates,    
DRFMCPT.DRNNo ''DRNNo'', ''RTA Rejected'' ''RTAStatus'', DRFMCPT.RTARemarks ''RTARemarks'',     
CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) ''RTAProcessDate'',      
DRFIRRTA.PodNo, DRFIRRTA.CourierName, ISNULL(DRFIRRTA.IsDocumentReceived,0)     
''IsDocumentReceived''   ,ISNULL(DRFIRRTA.NoOfCertificates,0) ''NoOfCertificatesReceived''    
, CONVERT(VARCHAR(20),DRFIRRTA.DocumentReceivedDate,13) ''DocumentReceivedDate''      
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFIRPD.DRFId    
JOIN tbl_DRFOutwordRegistrationSendToRTADetails RDRFOPRD WITH(NOLOCK)      
ON DRFIRPM.DRFId = RDRFOPRD.DRFId AND IsFileGenerate=5 AND IsResponseUpload=1    
----JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)      
----ON DRFMCPT.DRFId = DRFIRPM.DRFId AND IsRTARejected=1  
----JOIN [AGMUBODPL3].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)    
----ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0     
 ----LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)     
 ----ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0       
  LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)     
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0       
----AND DRFMCPT.IsRTAProcess=1  
----- AND ISNULL(RTARemarks,'''') IN(''REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'')     
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRRTA WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFIRRTA.DRFId    
WHERE DRFIRPM.DRFId NOT IN(SELECT DISTINCT DRFId FROM DRFInwordRegistrationReceivedByRTADetails WITH(NOLOCK))   
AND DRFIRPM.InwordProcessDate > CAST(GETDATE()-250 as date) 
'+@Condition+'      
')      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFOutwordRejectedClientsDetailsForPod
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetDRFOutwordRejectedClientsDetailsForPod  
AS  
  
---- EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''     
    
--- EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus      
    
BEGIN  
  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId, DRFIRPM.ClientName,  
DRFIRPD.CompanyName, DRFIRPM.NoOfCertificates, DRFIRPD.Quantity, ISNULL(DRFMCPT.DRNNo,'') 'DRNNo',     
CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.FileGenerateDate,113)  
ELSE CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'ProcessDate',    
   
CASE WHEN DRFIRPM.IsRejected=1 THEN 1  
WHEN DRFMCPT.IsCheckerRejected=1 THEN 2  
WHEN DRFMCPT.IsCDSLRejected=1  THEN 3      
WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN 5      
ELSE 0 END StatusCode,   
  
CASE   
WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN 'DRF Dispatch to RTA - Checker'    
WHEN DRFMCPT.IsCDSLRejected=1 THEN 'DRF Rejected by CDSL'  
WHEN DRFMCPT.IsCheckerRejected=1 THEN 'DRF Verfication by DP - Rejected'  
WHEN DRFIRPM.IsRejected=1 THEN 'DRF Courier Receieved & Rejected due to Invalid Client Id'   
END 'Status',   
   
CASE  
WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN 'DRF Dispatch to RTA - Checker'    
WHEN DRFMCPT.IsCDSLRejected=1 THEN 'DRF Rejected by CDSL'   
WHEN DRFMCPT.IsCheckerRejected=1 THEN 'DRF Verfication by DP - Rejected'   
WHEN DRFIRPM.IsRejected=1 THEN 'DRF Courier Receieved & Rejected due to Invalid Client Id'  
END 'Remarks' ,  
  
CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN ISNULL(TDRFORSRTAD.PodNo,'')  
ELSE RDRFOPRD.PODNo END 'PODNo',  
CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(IsRTAProcess,0)=0 THEN ISNULL(TDRFORSRTAD.CourierBy,'')   
ELSE RDRFOPRD.CourierBy END 'CourierName' ,   
  
CASE WHEN ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5  AND ISNULL(IsRTAProcess,0)=0       
THEN CASE WHEN ISNULL(TDRFORSRTAD.IsDocumentReceived,0)=1 THEN 'YES' ELSE 'NO' END  
--WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)<>0   
--THEN   
ELSE  
CASE WHEN ISNULL(RDRFOPRD.IsDocumentReceived,0)=1 THEN  'YES' ELSE 'NO' END  
END 'DocumentReceived',   
  
CASE WHEN ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5 AND ISNULL(IsRTAProcess,0)=0   
THEN ISNULL(TDRFORSRTAD.StatusDescription,'')  
ELSE ISNULL(RDRFOPRD.StatusDescription,'') END 'CourierStatus'  
   
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)   
ON DRFIRPM.DRFId = DRFIRPD.DRFId   
--LEFT JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)   
--ON DRFIRPM.ClientId = AMCD.CltDpId1  
JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
ON RDRFOPRD.DRFId = DRFIRPM.DRFId  
 LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)  
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId   
--LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)  
--ON DRFMCPT.DRFId = DRFIRPM.DRFId  
--JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)   
--ON DRFMCPT.DRFNo = DRFIRPM.DRFNo  
 --LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)  
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId     
   LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0     
--LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)     
-- ON DRFIRBRTA.DRFId = DRFIRPM.DRFId    
--LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)     
-- ON DRFIRPM.DRFId = RTARDSD.DRFId    
WHERE   
(ISNULL(RDRFOPRD.IsFileGenerate,0) IN(1,2,3,4) AND (ISNULL(RDRFOPRD.IsDocumentReceived,0)=0)      
      
OR (ISNULL(TDRFORSRTAD.IsFileGenerate,0) =5) --AND IsRejectedProcessResponseUpload=0   
 AND  ISNULL(TDRFORSRTAD.IsDocumentReceived,0)=0)     
 AND RDRFOPRD.FileGenerateDate >= DATEADD(mm,-6,CAST(GETDATE() as date))
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFOutwordRejectedDRFProcessSummary
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetDRFOutwordRejectedDRFProcessSummary]  
AS  
BEGIN  
SELECT SUM(TotalDRF) 'TotalDRFPerform', SUM(DPRejected) 'DPRejected'  
, SUM(CDSLRejected) 'CDSLRejected', SUM(RTARejected) 'RTARejected' 
,SUM(CDSLStatus) 'CDSLStatus'
FROM(  
SELECT 1 'TotalDRF',  
IIF(ISNULL(StatusCode,0)=1,1,0) 'RTARejected',  
IIF(ISNULL(StatusCode,0)=2,1,0) 'CDSLRejected',  
IIF(ISNULL(StatusCode,0)=3,1,0) 'DPRejected' ,
IIF(ISNULL(CDSLProcessStatus,'')='APPROVE',1,0) 'CDSLStatus'
FROM   
(  
SELECT DRFIRPM.DRFId,DRFIRPM.DRFNo,DRFIRPM.ClientId, AMCD.long_name 'ClientName',   
CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND isnull(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')<>'F' THEN DMATRMT.DEMRM_TRANSACTION_NO  
ELSE '' END 'DRNNo',  
  
CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')='F' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''  THEN '2'  
WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '' AND DMATDMK.demrm_res_desc_intobj = '' THEN '3'  
WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '' OR DMATDMK.demrm_res_desc_intobj = '') THEN '3'  
END 'StatusCode',  
  
CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')='F' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''  THEN 'CDSL REJECTED'  
WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '' AND DMATDMK.demrm_res_desc_intobj = '' THEN 'DP REJECTED'  
WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '' OR DMATDMK.demrm_res_desc_intobj = '') THEN 'DP REJECTED'  
END 'Status',  
  
CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')='F' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''  THEN DMATRMT.DEMRM_INTERNAL_REJ  
WHEN DMATDMK.DEMRM_DELETED_IND = 1 AND DMATDMK.DEMRM_INTERNAL_REJ = '' AND DMATDMK.demrm_res_desc_intobj = '' THEN DMATDMK.DEMRM_INTERNAL_REJ  
WHEN DMATDMK.DEMRM_DELETED_IND = 0 AND (DMATDMK.DEMRM_INTERNAL_REJ = '' OR DMATDMK.demrm_res_desc_intobj = '') THEN DMATDMK.demrm_res_desc_intobj  
END 'Remarks' ,

CASE WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND isnull(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')='S' AND DMATRMT.DEMRM_INTERNAL_REJ = '' THEN 'APPROVE'
WHEN ISNULL(DMATRMT.demrm_batch_no,'')<> '' AND ISNULL(DMATRMT.DEMRM_STATUS,'')='F' AND DMATRMT.DEMRM_INTERNAL_REJ <> ''  THEN 'CDSL REJECTED'
ELSE '' END 'CDSLProcessStatus'
  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFIRPD.DRFId  
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)       
ON DRFIRPM.ClientId = AMCD.CltDpId1    
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)   
ON DMATDMK.DEMRM_SLIP_SERIAL_NO = DRFIRPM.DRFNo  
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)   
ON DMATRMT.DEMRM_SLIP_SERIAL_NO = DRFIRPM.DRFNo AND DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID  
)AA  
)A  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFProcessClientDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetDRFProcessClientDetails  @ClientId VARCHAR(50)='',@DRFNo VARCHAR(35)=''          
AS            
BEGIN         
        
IF(@DRFNo<>'')        
BEGIN        
SELECT DRFNo FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo=@DRFNo        
END        
ELSE        
BEGIN        
  /*                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [172.31.16.108].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''        
  */                
         
 /*                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'           
FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''                 
UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [172.31.16.141].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''                 
 */              
              
              
                 
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'           
FROM [AGMUBODPL3].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''                 
UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [AngelDP5].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''              
               
 UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [AngelDP4].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''              
       
UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [AOPR0SPSDB01].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''              

UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [ABVSDP204].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''    
 
/*        
  --- GPX Server             
        
UNION                
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [10.253.78.167,13442].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''              
               
               
   -- Commant NTT Server             
          
UNION            
SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'            
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'              
FROM [10.254.33.93,13442].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)              
 WHERE TBLCM.CLIENT_CODE like '%'+@ClientId+''               
  */           
              
END         
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetDRFRTAInwordRegistrationProcessReport
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetDRFRTAInwordRegistrationProcessReport]    
AS    
BEGIN    
          
---- EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus ''         
      
 ---- EXEC USP_GetClientDRF_DP_CDSL_RTAProcessStatus        
          
SELECT DRFIRPM.DRFId, DRFIRPM.DRFNo,DRFIRPM.ClientId,DRFIRPM.ClientName,    
DRFIRPD.CompanyName,DRFIRPD.Quantity,DRFIRPM.NoOfCertificates,  
DRFMCPT.DRNNo 'DRNNo', 'RTA Rejected' 'RTAStatus', DRFMCPT.RTARemarks 'RTARemarks',   
CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) 'RTAProcessDate',  
DRFIRRTA.PodNo, DRFIRRTA.CourierName, ISNULL(DRFIRRTA.IsDocumentReceived,0)   
'IsDocumentReceived'   ,ISNULL(DRFIRRTA.NoOfCertificates,0) 'NoOfCertificatesReceived'  
, CONVERT(VARCHAR(20),DRFIRRTA.DocumentReceivedDate,13) 'DocumentReceivedDate'  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFIRPD.DRFId  
JOIN tbl_DRFOutwordRegistrationSendToRTADetails RDRFOPRD WITH(NOLOCK)  
ON DRFIRPM.DRFId = RDRFOPRD.DRFId AND IsFileGenerate=5 AND IsResponseUpload=1  
--JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)  
--ON DRFMCPT.DRFId = DRFIRPM.DRFId AND IsRTARejected=1          
--JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)    
--ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0        
 --LEFT JOIN Vw_GetClientDRF_DP_CDSL_RTAProcessStatus DRFMCPT WITH(NOLOCK)          
 --ON DRFIRPM.DRFId = DRFMCPT.DRFId AND DRFIRPM.IsRejected=0         
  LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFMCPT.DRFId --AND DRFIRPM.IsRejected=0       
AND           
DRFMCPT.IsRTAProcess=1 ----AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')          
JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRRTA WITH(NOLOCK)  
ON DRFIRPM.DRFId = DRFIRRTA.DRFId     
WHERE DRFIRPM.InwordProcessDate > CAST(GETDATE()-180 as date)
ORDER BY DRFIRRTA.DRF_RTADetailsId DESC    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetExistingBlockingClientDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetExistingBlockingClientDetails 
@ClientCode VARCHAR(15)='',@BlockingTeam VARCHAR(15)=''
AS
BEGIN
SELECT ISNULL(CltCode,'') 'CltCode' FROM tbl_ClientSebiPayoutBlockingDetails WITH(NOLOCK)
WHERE CltCode=@ClientCode AND BlockingTeam=@BlockingTeam
AND IsUnBlocked=0
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetGSTStateMasterDetails
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetGSTStateMasterDetails    
AS    
BEGIN    
SELECT GSTStateCode,UPPER(StateName) 'StateName' ,StateType 
FROM tbl_GSTStateMasterDetails WITH(NOLOCK)    
ORDER BY StateName  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetIntermadiarySBTagGenerationDetails
-- --------------------------------------------------


CREATE PROCEDURE USP_GetIntermadiarySBTagGenerationDetails
@SBTag VARCHAR(15)=''
AS
BEGIN 
SELECT  TIMGD.IntermediaryId, TIMGD.PanNo,TIMGD.IntermediaryName,TIMGD.TradeName,
TIMAD.Mobile1,TIMAD.Email,TIMGD.Parent 'Branch',
TIMAD.RegisteredAddressLine1,TIMAD.RegisteredAddressLine2,TIMAD.RegisteredAddressLine3,
TIMAD.RegisteredAreaLandmark,TIMAD.RegisteredCity,TIMAD.RegisteredState
,TIMAD.RegisteredPin,TIMAD.RegisteredCountry,
ISNULL(ISBTGM.SBMasterId,0) 'SBMasterId',ISNULL(ISBTGM.SBTag,'') 'SBTag'
,CASE WHEN ISNULL(ISBTGM.TagGenerationDate,'')='1900-01-01 00:00:00.000' THEN ''
ELSE CONVERT(VARCHAR(19),ISBTGM.TagGenerationDate,113) END 'TagGenerationDate'

FROM tbl_IntermediaryMasterGeneralDetails TIMGD WITH(NOLOCK)
JOIN tbl_IntermediaryMasterAddressDetails TIMAD WITH(NOLOCK)
ON TIMGD.IntermediaryId = TIMAD.IntermediaryId
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM WITH(NOLOCK)
ON ISBTGM.IntermediaryId =TIMGD.IntermediaryId 

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetIntermediaryCode_IntermediaryMaster
-- --------------------------------------------------

CREATE PROCEDURE USP_GetIntermediaryCode_IntermediaryMaster  
AS    
BEGIN    
DECLARE @MaxNo int=0
SET @MaxNo =(SELECT TOP 1 CAST(SUBSTRING(IntermediaryCode,9,12) as bigint)  FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) 
WHERE CAST(ProcessDate as date) = CAST(GETDATE() as date)
order by IntermediaryId desc)

SELECT
CAST(REPLACE(CONVERT(VARCHAR(10),GETDATE(),111),'/','')+ (REPLICATE('0',4-LEN(RTRIM(ISNULL(@MaxNo,0)))) + RTRIM(ISNULL(@MaxNo,0))) as bigint) +1
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetIntermediarySBTagGenerationRegistrationDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetIntermediarySBTagGenerationRegistrationDetails    
@IntermediaryId VARCHAR(15)=''    
AS    
BEGIN   
  
  
SELECT BB.*,ISNULL(ISBTGRD.Segment,'') 'Segment',ISNULL(ISBTGRD.Status,'') 'Status'    
, ISNULL(ISBTGRD.RegistrationNo,'') 'RegistrationNo'    
    
,CASE WHEN CAST(ISNULL(ISBTGRD.RegistrationDate,'') as date)<>'1900-01-01'    
THEN CONVERT(VARCHAR(20),ISNULL(ISBTGRD.RegistrationDate,''),113) ELSE '' END 'RegistrationDate1',  
CASE WHEN CAST(ISNULL(ISBTGRD.RegistrationDate,'') as date)<>'1900-01-01'    
THEN CONVERT(VARCHAR(20),ISNULL(ISBTGRD.RegistrationDate,''),103) ELSE '' END 'RegistrationDate',  
  
CASE WHEN CAST(ISNULL(ISBTGRD.IntimationDate,'') as date)<>'1900-01-01'    
THEN CONVERT(VARCHAR(20),ISNULL(ISBTGRD.IntimationDate,''),103) ELSE '' END 'IntimationDate',  
ISNULL(ISBTGRD.RejectionRemarks,'') 'RejectionRemarks'  
  
FROM
(SELECT * FROM(    
SELECT     
IntermediaryId,IntermediaryName,TradeName,PanNo, IntermediaryDate,Mobile1,Email,    
SBMasterId,SBTag,TagGenerationDate,  
RegisteredSegment,IsApplied , DocumentSegment , ExchangeDocumentName   
FROM (    
SELECT IMGD.IntermediaryId,IMGD.IntermediaryName,IMGD.TradeName,    
IMGD.PanNo, CONVERT(VARCHAR(20),IMGD.ProcessDate,113) 'IntermediaryDate',    
IMAD.Mobile1,IMAD.Email,    
ISNULL(ISBTGM.SBMasterId,0) 'SBMasterId',ISNULL(ISBTGM.SBTag,'')'SBTag'    
,CASE WHEN CAST(ISNULL(ISBTGM.TagGenerationDate,'') as date)<>'1900-01-01'    
THEN CONVERT(VARCHAR(20),ISNULL(ISBTGM.TagGenerationDate,''),113) ELSE '' END 'TagGenerationDate',    
  
IMSD.BSE_CASH,IMSD.BSE_FO,IMSD.NSE_CASH,IMSD.NSE_FO,IMSD.NCDEX_FO     
,IMSD.MCX_FO,IMSD.BSE_CDX,IMSD.NSE_CDX   ,

CASE WHEN ISNULL(BSESegmentDocName,'')='' THEN 'Not Uploaded' ELSE ISNULL(BSESegmentDocName,'') END 'A_BSE_CASH'
,CASE WHEN ISNULL(BSESegmentDocName,'')='' THEN 'Not Uploaded' ELSE ISNULL(BSESegmentDocName,'') END 'A_BSE_FO'
,CASE WHEN ISNULL(BSESegmentDocName,'')='' THEN 'Not Uploaded' ELSE ISNULL(BSESegmentDocName,'') END 'A_BSE_CDX'
,CASE WHEN ISNULL(NSESegmentDocName,'')='' THEN  'Not Uploaded' ELSE ISNULL(NSESegmentDocName,'') END 'A_NSE_CASH'
,CASE WHEN ISNULL(NSESegmentDocName,'')='' THEN  'Not Uploaded' ELSE ISNULL(NSESegmentDocName,'') END 'A_NSE_FO'
,CASE WHEN ISNULL(NSESegmentDocName,'')='' THEN  'Not Uploaded' ELSE ISNULL(NSESegmentDocName,'') END 'A_NSE_CDX'
,CASE WHEN ISNULL(MCXSegmentDocName,'')='' THEN 'Not Uploaded' ELSE ISNULL(MCXSegmentDocName,'') END 'A_MCX_FO'
, CASE WHEN ISNULL(NCDEXSegmentDocName,'')='' THEN 'Not Uploaded' ELSE ISNULL(NCDEXSegmentDocName,'') END  'A_NCDEX_FO'

  
FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)    
JOIN tbl_IntermediaryMasterSegmentDetails IMSD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMSD.IntermediaryId    
JOIN tbl_IntermediaryMasterAddressDetails IMAD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMAD.IntermediaryId    
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM WITH(NOLOCK)    
ON IMGD.IntermediaryId = ISBTGM.IntermediaryId    

LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUDD WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGUDD.IntermediaryId 

WHERE IMGD.IntermediaryId = @IntermediaryId    
)AA    
UNPIVOT     
(IsApplied For RegisteredSegment IN     
(BSE_CASH,BSE_FO,NSE_CASH,NSE_FO,NCDEX_FO,MCX_FO,BSE_CDX,NSE_CDX)    
) AS UnPVT    

UNPIVOT     
(ExchangeDocumentName For DocumentSegment IN     
(A_BSE_CASH,A_BSE_FO,A_NSE_CASH,A_NSE_FO,A_NCDEX_FO,A_MCX_FO,A_BSE_CDX,A_NSE_CDX)    
) AS UnPVT 
)ABC
WHERE RegisteredSegment =  (SUBSTRING(DocumentSegment , CHARINDEX('_',DocumentSegment)+1,15))
)BB    
 
LEFT JOIN tbl_IntermediarySBTagGenerationRegistrationDetails ISBTGRD WITH(NOLOCK)    
ON BB.SBMasterId = ISBTGRD.SBMasterId AND BB.RegisteredSegment = ISBTGRD.Segment  
WHERE IsApplied=1    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetJV_OfflineLedgerEntry
-- --------------------------------------------------

CREATE Procedure USP_GetJV_OfflineLedgerEntry            
AS            
BEGIN            
Select             
ISJVOL.VoucherType             
,ISJVOL.BookType             
,ISJVOL.SNo             
,ISJVOL.Vdate             
,ISJVOL.EDate             
,ISJVOL.CltCode             
,ISJVOL.CreditAmt             
,ISJVOL.DebitAmt             
,ISJVOL.Narration             
,ISJVOL.OppCode             
,ISJVOL.MarginCode             
,ISJVOL.BankName             
,ISJVOL.BranchName             
,ISJVOL.BranchCode             
,ISJVOL.DDNo             
,ISJVOL.ChequeMode             
,ISJVOL.ChequeDate             
,ISJVOL.ChequeName            
,ISJVOL.Clear_Mode             
,ISJVOL.TPAccountNumber             
,ISJVOL.Exchange             
,ISJVOL.Segment             
,ISJVOL.TPFlag             
,ISJVOL.AddDt             
,ISJVOL.AddBy             
,ISJVOL.StatusID             
,ISJVOL.StatusName             
,ISJVOL.RowState             
,ISJVOL.ApprovalFlag             
,ISJVOL.ApprovalDate             
,ISJVOL.ApprovedBy             
,ISJVOL.VoucherNo             
,ISJVOL.UploadDt             
,ISJVOL.LedgerVNO             
,ISJVOL.ClientName             
,ISJVOL.OppCodeName             
,ISJVOL.MarginCodeName             
,ISJVOL.Sett_No             
,ISJVOL.Sett_Type             
,ISJVOL.ProductType             
,ISJVOL.RevAmt             
,ISJVOL.RevCode             
,ISJVOL.MICR            
/*FROM IntersegmentJV_OfflineLedger ISJVOL WITH(NOLOCK) LEFT JOIN           
[196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES OLLE WITH(NOLOCK)           
ON ISJVOL.vdate = OLLE.vdate AND ISJVOL.AddBy = OLLE.AddBy AND OLLE.RowState !=1 AND OLLE.VoucherType=8         
where ISJVOL.vdate= cast(GETDATE() as date) AND ISJVOL.IsUpdatetoLive=0 AND ISJVOL.AddBy='AutoNBFC' ORDER by  VoucherNo , Sno asc     
*/    
FROM IntersegmentJV_OfflineLedger ISJVOL WITH(NOLOCK) LEFT JOIN           
AngelBSECM.MKTAPI.dbo.tbl_post_data OLLE WITH(NOLOCK)           
ON ISJVOL.vdate = OLLE.vdate AND ISJVOL.AddBy = OLLE.Return_fld5 AND OLLE.RowState !=2 AND OLLE.VoucherType=8         
where ISJVOL.vdate= cast(GETDATE() as date) AND ISJVOL.IsUpdatetoLive=0 AND ISJVOL.AddBy='AutoNBFC' ORDER by  VoucherNo , Sno asc     
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetJVPostedDataForExport
-- --------------------------------------------------
CREATE Procedure USP_GetJVPostedDataForExport    
AS    
BEGIN    
Select  VoucherType,    
       BookType,    
    SNo,    
       Convert(NVARCHAR(255),Vdate,103) 'Vdate',    
       Convert(NVARCHAR(255),Edate,103) 'Edate',    
       CltCode,    
        CreditAmt ,    
        DebitAmt ,     
       Narration ,     
       Exchange ,    
       Segment ,    
       VoucherNo,     
       Convert(NVARCHAR(255),AddDt,103) 'AddDt',    
       AddBy,    
       StatusID,    
       StatusName,    
        RowState ,    
        ApprovalFlag,    
        Convert(NVARCHAR(255),ApprovalDate,103) 'ApprovalDate',    
        Convert(NVARCHAR(255),UploadDt,103) 'UploadDt' ,    
        LedgerVNO    
         from IntersegmentJV_OfflineLedger WITH(NOLOCK)    
  Where vdate= cast(GETDATE() as date) And    
  Addby='AutoNBFC' AND VoucherType=8 AND Narration like 'Amount Tran From%'   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetLedgerSuspenceAccountDetails
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GetLedgerSuspenceAccountDetails]
@VouchorNo VARCHAR(35)='' ,@TrancationType VARCHAR(450) ,@IsOldProcess bit      
AS   
BEGIN   
DECLARE @Condition VARCHAR(MAX)='',@Condition1 VARCHAR(MAX)='',@TrancationType1 VARCHAR(250)=''  
, @Segment VARCHAR(5)='' ,@VNO VARCHAR(35) =''
IF(ISNULL(@VouchorNo,'')<>'')       
BEGIN
SET @VNO = SUBSTRING(@VouchorNo, 1,Charindex(',', @VouchorNo)-1)      
SET @Segment = SUBSTRING(@VouchorNo, Charindex(',', @VouchorNo)+1, LEN(@VouchorNo))      
SET @Condition = '  WHERE VNO =  '''+ @VNO +''' AND Segment = '''+@Segment+''' '
END
     
IF(@TrancationType='C')     
BEGIN     
SET @TrancationType = ' AND DRCR = ''C'' AND VTYP=''2'' '  
SET @TrancationType1 = ' WHERE LD.DRCR = ''C'' AND LD.VTYP=''2'' '  
END     
ELSE     
BEGIN     
SET @TrancationType = ' AND DRCR = ''D'' AND VTYP=''3'' '
SET @TrancationType1 = ' WHERE LD.DRCR = ''D'' AND LD.VTYP=''3'' ' 
END   


IF(@IsOldProcess=1)
BEGIN
SET @Condition1 = ' AND EDT < ''2022-11-07'' AND EDT > ''2022-10-07'' '
END
ELSE
BEGIN
SET @Condition1 = ' AND EDT >= ''2022-11-07'' '
END
       
EXEC('  
SELECT * INTO #EXISTING FROM (   
SELECT DISTINCT VNo,Segment FROM tbl_SBDepositSuspenceAccountDetails   
UNION ALL   
SELECT DISTINCT VNo,Segment FROM tbl_SBDepositKnockOffProcessDetails       
UNION ALL   
SELECT DISTINCT VNo,Segment FROM tbl_SBDepositSuspenceAccountManualProcess      
UNION ALL   
SELECT DISTINCT DebitVNo ''VNo'', DebitSegment ''Segment'' FROM tbl_SBKnockOffDebitedAmountProcessDetails   
UNION ALL   
SELECT DISTINCT CreditVNo ''VNo'', CreditSegment ''Segment'' FROM tbl_SBKnockOffDebitedAmountProcessDetails   
)AA   
   
SELECT VTYP, VNO,DRCR,VAMT,EDT, CONVERT(VARCHAR(10),VDT,103) ''VDT'' ,NARRATION,''NSE'' ''Segment'' INTO #NSE   
FROM [AngelNseCM].account.dbo.ledger WITH(NOLOCK)   
WHERE CLTCODE = ''5100000017'' '+@Condition1+' '+@TrancationType+' 
   
SELECT VTYP, VNO,DRCR,VAMT,EDT,CONVERT(VARCHAR(10),VDT,103) ''VDT'',NARRATION,''BSE'' ''Segment'' INTO #BSE   
FROM [AngelBSECM].Account_AB.dbo.ledger WITH(NOLOCK)   
WHERE CLTCODE = ''5100000017'' '+@Condition1+' '+@TrancationType+'  

 /*  Old Logic - Commanted      
 
SELECT NS.*,LD.ddno  INTO #NSE_Latest
FROM [AngelNseCM].account.dbo.ledger1 LD WITH(NOLOCK) 
JOIN #NSE NS
ON LD.vno = NS.VNO AND LD.drcr=NS.DRCR   
AND NS.VAMT=LD.relamt  '+@TrancationType1+'          
       
SELECT BS.*,LD.ddno INTO #BSE_Latest   
FROM [AngelBSECM].Account_AB.dbo.ledger1 LD WITH(NOLOCK) 
JOIN #BSE BS
ON LD.vno = BS.VNO AND LD.drcr=BS.DRCR   
---AND CAST(LD.dddt as date) = CAST(CONVERT(datetime,BS.VDT ,103) as date)       
---AND CAST(LD.reldt as date) = CAST(CONVERT(datetime,BS.VDT ,103) as date)     
AND BS.VAMT=LD.relamt '+@TrancationType1+' 
     
*/

SELECT NS.*,'''' ddno  INTO #NSE_Latest
FROM #NSE NS
         
       
SELECT BS.*,'''' ddno INTO #BSE_Latest   
FROM #BSE BS     

SELECT * FROM (       
SELECT ROW_NUMBER() OVER(ORDER BY VTYP) ''SRNO'', * FROM (   
SELECT * FROM #NSE_Latest WHERE VNo NOT IN(SELECT VNo FROM #EXISTING WHERE Segment=''NSE'' )   
UNION ALL   
SELECT * FROM #BSE_Latest WHERE VNo NOT IN(SELECT VNo FROM #EXISTING WHERE Segment=''BSE'' )   
)A       
)B   
'+@Condition+'       
')       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetMarginJVPostedDataForExport
-- --------------------------------------------------

CREATE Procedure USP_GetMarginJVPostedDataForExport    
AS    
BEGIN    
Select  VoucherType,    
       BookType,    
    SNo,    
       Convert(NVARCHAR(255),Vdate,103) 'Vdate',    
       Convert(NVARCHAR(255),Edate,103) 'Edate',    
       CltCode,    
        CreditAmt ,    
        DebitAmt ,     
       Narration ,     
       Exchange ,    
       Segment ,    
       VoucherNo,     
       Convert(NVARCHAR(255),AddDt,103) 'AddDt',    
       AddBy,    
       StatusID,    
       StatusName,    
        RowState ,    
        ApprovalFlag,    
        Convert(NVARCHAR(255),ApprovalDate,103) 'ApprovalDate',    
        Convert(NVARCHAR(255),UploadDt,103) 'UploadDt' ,    
        LedgerVNO    
         from ShortageMarginJV_OfflineLedger WITH(NOLOCK)    
  Where vdate= cast(GETDATE() as date) And    
  Addby='Remisier' AND VoucherType=8
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetMaxIntersegmentJVSRNO
-- --------------------------------------------------
CREATE Procedure [DBO].[USP_GetMaxIntersegmentJVSRNO] @Exchange NVARCHAR(20),@Segment NVARCHAR(25)
AS
BEGIN
Select ISNULL(MAX(SNO),0) 'SNo' from IntersegmentJV_OfflineLedger WITH(NOLOCK) where Exchange=@Exchange and Segment =@Segment and vdate= cast(GETDATE() as date)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetMaxIntersegmentJVVoucherNo
-- --------------------------------------------------
CREATE Procedure [DBO].[USP_GetMaxIntersegmentJVVoucherNo] @Exchange NVARCHAR(20),@Segment NVARCHAR(25)
AS
BEGIN
Select ISNULL(MAX(VoucherNo),0) 'VoucherNo' from IntersegmentJV_OfflineLedger WITH(NOLOCK) where Exchange=@Exchange and Segment =@Segment and vdate= cast(GETDATE() as date)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetMaxNBFEquityNoForTrack
-- --------------------------------------------------

CREATE PROCEDURE USP_GetMaxNBFEquityNoForTrack     
@ColumnName VARCHAR(50),@IsEquityToNBFC bit    
AS    
BEGIN    
    
IF(@ColumnName='KotakNBFC')    
BEGIN    
--SELECT ISNULL(KotakNBFC,0) 'KotakNBFC' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC    
SELECT ISNULL(KotakNBFC,'') 'KotakNBFC' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC AND CAST(FileDate as date) = CAST(GETDATE() as date)   
END    
IF(@ColumnName='KotakEquity')    
BEGIN    
SELECT ISNULL(KotakEquity,'') 'KotakEquity' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC AND CAST(FileDate as date) = CAST(GETDATE() as date)      
END    
IF(@ColumnName='HDFCNBFC')    
BEGIN    
SELECT ISNULL(HDFCNBFC,'') 'HDFCNBFC' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC AND CAST(FileDate as date) = CAST(GETDATE() as date)      
END    
IF(@ColumnName='HDFCEquity')    
BEGIN    
SELECT ISNULL(HDFCEquity,'') 'HDFCEquity' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC AND CAST(FileDate as date) = CAST(GETDATE() as date)      
END    
IF(@ColumnName='IndusindNBFC')    
BEGIN    
SELECT ISNULL(IndusindNBFC,'') 'IndusindNBFC' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC  AND CAST(FileDate as date) = CAST(GETDATE() as date)     
END    
IF(@ColumnName='IndusindEquity')    
BEGIN    
SELECT ISNULL(IndusindEquity,'') 'IndusindEquity' FROM  NBFCBankDownloadFileForTrack WHERE IsEquityToNBFC=@IsEquityToNBFC AND CAST(FileDate as date) = CAST(GETDATE() as date)       
END    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetMaxShortageMarginJVSRNO
-- --------------------------------------------------
CREATE Procedure [DBO].[USP_GetMaxShortageMarginJVSRNO] @Exchange NVARCHAR(20),@Segment NVARCHAR(25)  
AS  
BEGIN  
Select ISNULL(MAX(SNO),0) 'SNo' from ShortageMarginJV_OfflineLedger WITH(NOLOCK) 
where Exchange=@Exchange and Segment =@Segment and vdate= cast(GETDATE() as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCAdjustmentAmountForDashboard
-- --------------------------------------------------
 
CREATE Procedure [dbo].[USP_GetNBFCAdjustmentAmountForDashboard]       
(@SearchDate VARCHAR(50),@IsProcess2 bit,@IsEquityTONBFC bit)      
AS      
BEGIN      
DECLARE @BackOfcNBFC decimal(17,2), @BACKOFCNBFCClients int , @Condition VARCHAR(MAX)       
      
IF(@SearchDate='LastSave')      
BEGIN  
SET @Condition = (SELECT DISTINCT MAX(NBFCFundingDate) 'NBFCFundingDate' FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK)) 
END
ELSE
BEGIN
SET @Condition = @SearchDate
END

SElECT BankName, COUNT(CLTCODE)'TotalNBFCClients', SUM(Adjust) 'TotalNBFCAmount' Into #Temp       
FROM(      
SELECT Distinct ANBFCC.BankName,CLTCODE      
,CASE WHEN Cast(Adjust as decimal(17,2)) <0 THEN Cast((Adjust * -1) as decimal(17,2))        
ELSE Cast(Adjust as decimal(17,2)) END 'Adjust'       
FROM NBFCAndEquityAdjustmentAmount NBFCAAM WITH(NOLOCK)       
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)       
ON NBFCAAM.CLTCODE = ANBFCC.ClientCode      
WHERE BANKName in('INDUSIND BANK LTD','KOTAK MAHINDRA BANK','HDFC') AND IsEquityToNBFC= @IsEquityTONBFC      
AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() AND IsProcess2= @IsProcess2 AND NBFCFundingDate = @Condition     
)A      
WHERE A.Adjust>=1      
Group BY BankName      
      
SET @BackOfcNBFC  = (Select SUM(TotalNBFCAmount) 'TotalNBFCAmount' from #Temp)      
SET @BACKOFCNBFCClients = (Select SUM(TotalNBFCClients) 'TotalNBFCClients' from #Temp)      
      
IF(ISNULL(@BackOfcNBFC,0)!=0)      
BEGIN     
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('INDUSIND BANK LTD'))    
BEGIN    
Insert into #Temp values('INDUSIND BANK LTD',0,0)       
END    
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('KOTAK MAHINDRA BANK'))    
BEGIN    
Insert into #Temp values('KOTAK MAHINDRA BANK',0,0)       
END    
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('HDFC'))    
BEGIN    
Insert into #Temp values('HDFC',0,0)       
END   
Insert into #Temp values('BackOffice',@BACKOFCNBFCClients,@BackOfcNBFC)      
END      
      
SELECT ROW_NUMBER() over(order by BankName desc) 'SRNo',      
CASE WHEN BANKName='KOTAK MAHINDRA BANK' THEN 'Kotak'      
WHEN BANKName='INDUSIND BANK LTD' THEN 'INDUSIND'      
ELSE BANKName      
END BANKName,TotalNBFCClients,TotalNBFCAmount FROM #Temp      
      
         
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCAdjustmentAmountWithBankDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetNBFCAdjustmentAmountWithBankDetails] @SearchDate VARCHAR(50),@BankName VARCHAR(50),@IsProcess2 bit,@IsEquityTONBFC bit          
AS          
BEGIN          
DECLARE @Condition VARCHAR(50), @Query VARCHAR(MAX), @Condition1 VARCHAR(MAX)          
IF(@BankName='BackOfc')          
BEGIN          
SET @Condition=''          
END          
ELSE          
BEGIN          
SET @Condition = ' AND BankName = '''+@BankName+''''          
END          
          
IF(@SearchDate ='LastSave')          
BEGIN          
SET @SearchDate = (select CONVERT(nvarchar(50), MAX(NBFCFundingDate),101)  FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK))
SET @Condition1 = ' AND CONVERT(nvarchar(50), NBFCFundingDate,101) = '''+@SearchDate+''''        
  
END          
ELSE          
BEGIN              
SET @Condition1 = ' AND CONVERT(nvarchar(50), NBFCFundingDate,101) = '''+@SearchDate+''''        
END      
          
EXEC('          
SELECT Distinct ROW_NUMBER() over(order by CLTCode) ''SRNo'',* FROM (          
SELECT  CLTCode , Convert(VARCHAR(30),NBFCFundingDate,103) ''NBFCFundingDate''         
,CASE WHEN Cast(Adjust as decimal(17,2)) <0 THEN Cast((Adjust * -1) as decimal(17,2))            
ELSE Cast(Adjust as decimal(17,2)) END ''Adjust''          
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''KOTAK LTD''          
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''INDUSIND BANK''          
WHEN ANBFCC.BankName=''HDFC'' THEN ''HDFC LTD''          
END ''BankName''          
, CLIENTNAME,BANKACCOUNTNO          
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''300001''          
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''300006''          
WHEN ANBFCC.BankName=''HDFC'' THEN ''300002''          
END ''NBFCBankCode''          
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''02086''          
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''03031''          
WHEN ANBFCC.BankName=''HDFC'' THEN ''02014''          
END ''EquityBankCode''          
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''KOTAK''          
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''INDUSIND BANK''          
WHEN ANBFCC.BankName=''HDFC'' THEN ''HDFC''          
END ''BankNameForChk''          
FROM NBFCAndEquityAdjustmentAmount NBFCAAM WITH(NOLOCK)          
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)           
ON NBFCAAM.CLTCODE = ANBFCC.ClientCode          
WHERE BANKName in(''INDUSIND BANK LTD'',''KOTAK MAHINDRA BANK'',''HDFC'')           
AND ACCOUNTTYPE=''POA'' and INACTIVEDATE > GETDATE() AND IsProcess2 = '+@IsProcess2+'         
AND IsEquityToNBFC='+@IsEquityTONBFC+'  '+@Condition+' '+@Condition1+'          
) A          
WHERE A.Adjust >=1          
 ')          
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCAndEquityAdjustmentAmount
-- --------------------------------------------------

CREATE PROCEDURE USP_GetNBFCAndEquityAdjustmentAmount @DateFilter NVARCHAR(50) ,@IsEquityToNBFC bit     
AS        
BEGIN    
IF(@DateFilter='val')    
BEGIN      

SELECT * FROM (SELECT CLTCode, FromSegment,ToSegment, 
CASE WHEN Cast(Adjust as decimal(17,2)) <0 THEN Cast((Adjust * -1) as decimal(17,2))
ELSE Cast(Adjust as decimal(17,2)) END 'Adjust' 
FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK) WHERE IsEquityToNBFC=@IsEquityToNBFC) A WHERE A.Adjust>=1
END      
IF(@DateFilter = CONVERT(nvarchar(50), GETDATE(),101))      
BEGIN      
SELECT * FROM (SELECT CLTCode, FromSegment,ToSegment, 
CASE WHEN Cast(Adjust as decimal(17,2)) <0 THEN Cast((Adjust * -1) as decimal(17,2))
ELSE Cast(Adjust as decimal(17,2)) END 'Adjust' 
FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK) WHERE IsEquityToNBFC=@IsEquityToNBFC) A WHERE A.Adjust>=1          
END      
ELSE      
BEGIN      
 SELECT * FROM (SELECT CLTCode, FromSegment,ToSegment, 
CASE WHEN Cast(Adjust as decimal(17,2)) <0 THEN Cast((Adjust * -1) as decimal(17,2))
ELSE Cast(Adjust as decimal(17,2)) END 'Adjust' 
FROM NBFCAndEquityAdjustmentAmountLogFile WITH(NOLOCK) WHERE CONVERT(nvarchar(50), CreatedDate,101)=@DateFilter AND IsEquityToNBFC=@IsEquityToNBFC) A where A.Adjust>=1     
END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCShortageProcessBackOfficeReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetNBFCShortageProcessBackOfficeReport  @NBFCFundingProcess bit
AS  
BEGIN  

DECLARE @Condition VARCHAR(300)=''
IF(@NBFCFundingProcess=1)
BEGIN
SET @Condition = ' AND RETURN_FLD2 = ''NBFC_Funding'' AND CAST(VDATE as date) = CAST(GETDATE() as date) '
END
ELSE
BEGIN
SET @Condition = ' AND RETURN_FLD2 = ''NBFC_Shortage'' AND CAST(VDATE as date) = CAST(DATEADD(DD,-1,GETDATE()) as date) '
END

EXEC('
SELECT   
 [VOUCHERTYPE],            
 [SNO],            
 [VDATE] ,            
 [EDATE] ,            
 [CLTCODE] ,            
 [CREDITAMT] ,            
 [DEBITAMT] ,            
 [NARRATION] ,            
 [BANKCODE] ,            
 [MARGINCODE],            
 [BANKNAME] ,            
 [BRANCHNAME],            
 [BRANCHCODE],            
 [DDNO] ,            
 [CHEQUEMODE] ,            
 [CHEQUEDATE] ,            
 [CHEQUENAME] ,            
 [CLEAR_MODE] ,            
 [TPACCOUNTNUMBER] ,            
 [EXCHANGE],             
 [SEGMENT],             
 [MKCK_FLAG],            
 [RETURN_FLD1],            
 [RETURN_FLD2],            
 [RETURN_FLD3],            
 [RETURN_FLD4],            
 [RETURN_FLD5],            
 [ROWSTATE]   
   FROM anand.MKTAPI.dbo.tbl_post_data WITH(NOLOCK)  
   WHERE VOUCHERTYPE in(''2'',''3'')
   '+@Condition+'
   ')
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETNBFCShortageProcessDetails
-- --------------------------------------------------
   
CREATE PROCEDURE USP_GetNBFCShortageProcessDetails @SearchDate VARCHAR(50)      
AS      
BEGIN      
IF EXISTS(SELECT * FROM NBFCShortageProcessDetails WITH(NOLOCK) WHERE CAST(MARGINDATE as date) = @SearchDate)    
BEGIN    
SELECT Party_Code, CONVERT(NVARCHAR(50),MARGINDATE,103) 'MARGINDATE1',MARGINDATE 'MARGINDATE',Total_Shortage     
FROM NBFCShortageProcessDetails WITH(NOLOCK) WHERE CAST(MARGINDATE as date) = @SearchDate    
END    
ELSE    
BEGIN    
select MARGINDATE,PARTY_CODE,      
      
sum(TDAY_MARGIN_SHORT) as TDAY_SHORTAGE,      
      
SUM(TDAY_MTM_SHORT) as TDAY_MTM_SHORTAGE  INTO #Margin_Shortage      
      
from anand1.MSAJAG.dbo.TBL_COMBINE_REPORTING WITH(NOLOCK)      
      
where MARGINDATE =@SearchDate      
      
group by MARGINDATE,PARTY_CODE      
      
       
      
Insert into #Margin_Shortage select MARGINDATE,PARTY_CODE,      
      
sum(TDAY_MARGIN_SHORT) as TDAY_SHORTAGE,      
      
SUM(TDAY_MTM_SHORT) as TDAY_MTM_SHORTAGE        
      
from anand1.MSAJAG.dbo.TBL_COMBINE_REPORTING_Peak WITH(NOLOCK)      
      
where MARGINDATE =@SearchDate      
      
group by MARGINDATE,PARTY_CODE      
      
       
      
update #Margin_Shortage set TDAY_SHORTAGE='0.00' from #Margin_Shortage where TDAY_SHORTAGE>=0      
      
update #Margin_Shortage set TDAY_MTM_SHORTAGE='0.00' from #Margin_Shortage where TDAY_MTM_SHORTAGE>=0      
      
ALTER TABLE #Margin_Shortage ADD Total_Shortage MONEY;      
      
update #Margin_Shortage set Total_Shortage=TDAY_SHORTAGE+TDAY_MTM_SHORTAGE  from #Margin_Shortage      
      
delete from #Margin_Shortage where Total_Shortage='0.00'      
      
      
select (a.Party_Code) as Party_Code,a.MARGINDATE, a.TDAY_SHORTAGE,a.TDAY_MTM_SHORTAGE,a.Total_Shortage   into #NBFC_Shortage from #Margin_Shortage a      
      
inner join [196.1.115.132].risk.dbo.client_Details b WITH(NOLOCK) on a.Party_Code=b.party_code      
      
where  b.cl_type='NBF' group by a.Party_Code,a.MARGINDATE, a.TDAY_SHORTAGE,a.TDAY_MTM_SHORTAGE,a.Total_Shortage      
      
       
SELECT  Party_Code, convert(date,MARGINDATE) as MARGINDATE, min(round(Total_Shortage,0)) as Total_Shortage into #NBFC_Shortage_Final       
from #NBFC_Shortage where  Total_Shortage<-0.49      
      
GROUP BY Party_Code,MARGINDATE order by Total_Shortage      
      
SELECT Party_Code, CONVERT(NVARCHAR(50),MARGINDATE,103) 'MARGINDATE1',MARGINDATE 'MARGINDATE',Total_Shortage FROM #NBFC_Shortage_Final NBFCSF   
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANGNBFCC WITH(NOLOCK)   
ON ANGNBFCC.ClientCode = NBFCSF.Party_Code  
where ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() AND  Party_Code NOT IN (SELECT ClientCode FROM ExceptionClientDetails WITH(NOLOCK))  
ORDER BY Total_Shortage      
END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCShortageProcessDetailsForDashboard
-- --------------------------------------------------

CREATE PROCEDURE USP_GetNBFCShortageProcessDetailsForDashboard @SearchMarginDate Varchar(25)    
AS      
BEGIN      
DECLARE @BackOfcNBFC decimal(17,2), @BACKOFCNBFCClients int  , @Condition VARCHAR(255)     
    
IF(@SearchMarginDate ='LastSave')    
BEGIN    
SET @Condition = (SELECT DISTINCT MAX(MARGINDATE) 'MARGINDATE' FROM NBFCShortageProcessDetails WITH(NOLOCK))    
END    
ELSE    
BEGIN    
SET @Condition = @SearchMarginDate    
END    
SElECT BankName, COUNT(PARTY_CODE)'TotalNBFCClients', SUM(TOTAL_SHORTAGE) 'TotalNBFCAmount' Into #Temp         
FROM(        
SELECT Distinct ANBFCC.BankName,PARTY_CODE        
,CASE WHEN Cast(TOTAL_SHORTAGE as decimal(17,2)) <0 THEN Cast((TOTAL_SHORTAGE * -1) as decimal(17,2))          
ELSE Cast(TOTAL_SHORTAGE as decimal(17,2)) END 'TOTAL_SHORTAGE'         
FROM NBFCShortageProcessDetails NBFCSPD WITH(NOLOCK)         
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)         
ON NBFCSPD.PARTY_CODE = ANBFCC.ClientCode        
WHERE BANKName in('INDUSIND BANK LTD','KOTAK MAHINDRA BANK','HDFC')       
AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() AND MARGINDATE = @Condition        
)A        
WHERE A.TOTAL_SHORTAGE>0        
Group BY BankName        
        
SET @BackOfcNBFC  = (Select SUM(TotalNBFCAmount) 'TotalNBFCAmount' from #Temp)        
SET @BACKOFCNBFCClients = (Select SUM(TotalNBFCClients) 'TotalNBFCClients' from #Temp)        
  

        
IF(ISNULL(@BackOfcNBFC,0)!=0)        
BEGIN   
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('INDUSIND BANK LTD'))  
BEGIN  
Insert into #Temp values('INDUSIND BANK LTD',0,0)     
END  
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('KOTAK MAHINDRA BANK'))  
BEGIN  
Insert into #Temp values('KOTAK MAHINDRA BANK',0,0)     
END  
IF NOT EXISTS(SELECT DISTINCT BankName  FROM #Temp WHERE BankName IN('HDFC'))  
BEGIN  
Insert into #Temp values('HDFC',0,0)     
END 
Insert into #Temp values('BackOffice',@BACKOFCNBFCClients,@BackOfcNBFC)        
END        
        
SELECT ROW_NUMBER() over(order by BankName desc) 'SRNo',        
CASE WHEN BANKName='KOTAK MAHINDRA BANK' THEN 'Kotak'        
WHEN BANKName='INDUSIND BANK LTD' THEN 'INDUSIND'        
ELSE BANKName        
END BANKName,TotalNBFCClients,TotalNBFCAmount FROM #Temp        
      
DROP table #Temp      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCShortageProcessPostInBackOffice_Status
-- --------------------------------------------------
   CREATE PROCEDURE USP_GetNBFCShortageProcessPostInBackOffice_Status @IsNBFCFundingProcess bit
   AS  
   BEGIN  
   DECLARE @Condition VARCHAR(250)=''

   IF(@IsNBFCFundingProcess=1)
   BEGIN
   SET @Condition =' WHERE AMTPD.RETURN_FLD2 = ''NBFC_Funding''  AND CAST(AMTPD.VDATE as date) = CAST(GETDATE() as date) '
   END
   ELSE
   BEGIN
   SET @Condition =' WHERE AMTPD.RETURN_FLD2 = ''NBFC_Shortage''  AND CAST(AMTPD.VDATE as date) = CAST(DATEADD(DD,-1,GETDATE()) as date) '
   END

   EXEC('
   SELECT   
   CASE WHEN NBF=0 THEN 1  
   WHEN NBF=2 THEN 2  
   WHEN NBF=99 THEN 9  
   WHEN ISNULL(NBF,'''')='''' THEN 0  
   END ''NBFC'',  
   CASE WHEN NSE=0 THEN 1  
   WHEN NSE=2 THEN 2  
   WHEN NSE=99 THEN 9  
   WHEN ISNULL(NSE,'''')='''' THEN 0  
   END ''NSE''  
   FROM  
   (  
   SELECT DISTINCT  
   AMTPD.EXCHANGE,AMTPD.ROWSTATE  
   FROM anand.MKTAPI.dbo.tbl_post_data AMTPD WITH(NOLOCK)  
   '+@Condition+'
   ) AS P      
   PIVOT      
   (      
     MAX(RowState) FOR Exchange IN ([NBF], [NSE])      
   ) AS pv2   ')

   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetNBFCShortageProcessWithBankDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetNBFCShortageProcessWithBankDetails @SearchMarginDate VARCHAR(50) , @BankName VARCHAR(50)  
AS    
BEGIN    
DECLARE @Condition VARCHAR(MAX)  

IF(@SearchMarginDate ='LastSave')
BEGIN
SET @Condition = ' AND MARGINDATE = (SELECT DISTINCT MAX(MARGINDATE) FROM NBFCShortageProcessDetails WITH(NOLOCK)) '
END
ELSE
BEGIN
SET @Condition = ' AND MARGINDATE = '''+@SearchMarginDate+''''
END

IF(@BankName='BackOfc')    
BEGIN    
SET @Condition +=''    
END    
ELSE    
BEGIN    
SET @Condition += ' AND BankName = '''+@BankName+''''    
END   


    
    
EXEC('  SELECT ROW_NUMBER() over(order by PARTY_CODE) ''SRNo'',* FROM(  
SELECT Distinct  PARTY_CODE , CONVERT(NVARCHAR(50),MARGINDATE,103) ''MARGINDATE''
,CASE WHEN Cast(TOTAL_SHORTAGE as decimal(17,2)) <0 THEN Cast((TOTAL_SHORTAGE * -1) as decimal(17,2))      
ELSE Cast(TOTAL_SHORTAGE as decimal(17,2)) END ''TOTAL_SHORTAGE''    
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''KOTAK LTD''    
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''INDUSIND BANK''    
WHEN ANBFCC.BankName=''HDFC'' THEN ''HDFC LTD''    
END ''BankName''    
, CLIENTNAME,BANKACCOUNTNO    
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''300001''    
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''300006''    
WHEN ANBFCC.BankName=''HDFC'' THEN ''300002''    
END ''NBFCBankCode''    
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''02086''    
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''03031''    
WHEN ANBFCC.BankName=''HDFC'' THEN ''02014''    
END ''EquityBankCode''    
, CASE WHEN ANBFCC.BankName=''KOTAK MAHINDRA BANK'' THEN ''KOTAK''    
WHEN ANBFCC.BankName=''INDUSIND BANK LTD'' THEN ''INDUSIND BANK''    
WHEN ANBFCC.BankName=''HDFC'' THEN ''HDFC''    
END ''BankNameForChk''    
FROM NBFCShortageProcessDetails NBFCSPD WITH(NOLOCK)     
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)     
ON NBFCSPD.PARTY_CODE = ANBFCC.ClientCode     
WHERE BANKName in(''INDUSIND BANK LTD'',''KOTAK MAHINDRA BANK'',''HDFC'')     
AND ACCOUNTTYPE=''POA'' and INACTIVEDATE > GETDATE()     
 '+@Condition+'  
 )A
 WHERE A.TOTAL_SHORTAGE>0
 ')   
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBAddressChangesDocumentDetailsForVerification_06Nov2025
-- --------------------------------------------------
  
CREATE PROC USP_GetSBAddressChangesDocumentDetailsForVerification_06Nov2025      
@SBTag VARCHAR(15)='' , @PanNo VARCHAR(15)=''    
AS      
BEGIN 

DECLARE @Condition VARCHAR(MAX)=''    
IF(ISNULL(@SBTag,'')<>'' AND ISNULL(@PanNo,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBTag = '''+@SBTag+''' AND SBACPD.SBPanNo = '''+@PanNo+''' '    
END    
IF(ISNULL(@SBTag,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBTag = '''+@SBTag+''' '    
END    
IF(ISNULL(@PanNo,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBPanNo = '''+@PanNo+''' '    
END    
    
EXEC ('    
SELECT DISTINCT SBTAG, [BR] as BRAddress, ALT as AltAddress, TER as TerAddress ,        
City,CrtDt INTO #LatestSBDetails         
FROM (         
SELECT *  FROM (        
SELECT SBCADC.SBTag,SBCADC.AddType,        
SBCADC.AddLine1 +'',''+SBCADC.AddLine2 +'',''+SBCADC.Landmark+'',''+SBCADC.City +'',''+SBCADC.State+''-''+SBCADC.PinCode ''Address''        
,SBCADC.City,         
CONVERT(VARCHAR(11),SBCADC.CrtDt,113) ''CrtDt''         
            FROM [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCADC WITH(NOLOCK)       
   JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
   ON SBCADC.SBTag = SBACPD.SBTag      
   WHERE SBCADC.Current_Status=''VERIFIED'' AND CAST(SBCADC.CrtDt as date) >=''2022-12-20''        
   -----AND SBTAG =@SBTag     
   '+@Condition+'    
  )AA        
        ) AS P        
        PIVOT         
        (   MAX(Address)         
            FOR addtype in ([BR],[ALT],[TER])        
        ) AS  PVT        
      
------      
      
  SELECT  ISNULL(SBTAG,'''') ''SBTAG'',ISNULL(BranchTag,'''') ''BranchTag'',ISNULL(SBName,'''') ''SBName''        
  ,ISNULL(TradeName,'''') ''TradeName'',ISNULL(PanNo,'''') ''PanNo'',        
  ISNULL([OFF],'''') as OfficeAddress, ISNULL(RES,'''') as ResAddress, ISNULL(TER,'''') as TerAddress ,        
  ISNULL(Latest_AltAddress,'''') ''Latest_AltAddress'',ISNULL(Latest_BRAddress,'''') ''Latest_BRAddress''        
  ,ISNULL(Latest_TerAddress,'''') ''Latest_TerAddress''        
  ,ISNULL(Latest_City,'''') ''Latest_City'',ISNULL(Latest_CrtDt,'''') ''Latest_CrtDt'',         
  CASE         
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(Latest_TerAddress,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')='''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(Latest_AltAddress,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')='''' THEN ISNULL(Latest_TerAddress,'''')        
  ELSE ISNULL(Latest_AltAddress,'''')        
  END ''LatestAddress'',        
  CASE         
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(RES,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')='''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(RES,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')='''' THEN ISNULL(RES,'''')        
  ELSE ISNULL([OFF],'''') END ''OldAddress''--,EmailId        
  ,DocumentSendDate      
FROM    (         
SELECT * FROM (        
SELECT DISTINCT SBCT.addtype,         
 ISNULL(SBB.SBTAG,'''') AS SBTAG,            
        SBB.Branch AS ''BranchTag'' ,               
            
  ISNULL(SBB.TRADENAME,'''') ''SBName'' ,              
  ISNULL(SBB.TRADENAME,'''') AS TradeName,             
            
  ISNULL(SBB.Panno,'''') as PanNo  ,            
  CONVERT(VARCHAR(10),SBB.TAGGeneratedDate,103) ''TAGGeneratedDate'',            
  ISNULL(SBB.IsActive,'''') ''Status'',          
  CONVERT(VARCHAR(10),SBB.IsActiveDate,103) ''StatusDate'',        
SBCT.AddLine1 +'' ''+ SBCT.AddLine2 +'' ''+ SBCT.Landmark +''-''+ SBCT.City +''-''+ SBCT.State +''-''+ SBCT.Country           
    ''Address''   ,        
 LSBD.AltAddress ''Latest_AltAddress'' , LSBD.BRAddress ''Latest_BRAddress''        
 ,LSBD.TerAddress ''Latest_TerAddress'',LSBD.City ''Latest_City'', LSBD.CrtDt ''Latest_CrtDt'',      
 CONVERT(VARCHAR(11),SBACPD.DocumentMailDate,113) ''DocumentSendDate''       
           
   FROM [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)          
  JOIN [SB_COMP].[dbo].SB_CONTACT SBCT WITH(NOLOCK)           
  ON SBCT.RefNo = SBB.RefNo         
  JOIN [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCAC WITH(NOLOCK)            
  ON SBCAC.SBTAG = SBB.SBTAG          
  JOIN #LatestSBDetails LSBD        
  ON SBB.SBTAG = LSBD.SBTag        
  JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
  ON SBB.SBTAG = SBACPD.SBTag      
  WHERE SBB.sbtag <> ''T A G''  AND SBCT.addtype IN(''RES'',''OFF'',''TER'')            
  AND SBCAC.Current_Status=''VERIFIED''        
  ----AND SBB.SBTAG in(''BHKS'')       
   '+@Condition+'    
  )AA        
        ) AS P        
        PIVOT         
        (   MAX(Address)         
            FOR addtype in ([OFF],[RES],[TER])        
        ) AS  PVT        
        
       ORDER BY SBTAG      
    ')    
END


/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBAddressChangesDocumentDetailsForVerification_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE PROC USP_GetSBAddressChangesDocumentDetailsForVerification      
@SBTag VARCHAR(15)='' , @PanNo VARCHAR(15)=''    
AS      
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @Condition VARCHAR(MAX)=''    
IF(ISNULL(@SBTag,'')<>'' AND ISNULL(@PanNo,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBTag = '''+@SBTag+''' AND SBACPD.SBPanNo = '''+@PanNo+''' '    
END    
IF(ISNULL(@SBTag,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBTag = '''+@SBTag+''' '    
END    
IF(ISNULL(@PanNo,'')<>'')    
BEGIN    
SET @Condition = ' AND SBACPD.SBPanNo = '''+@PanNo+''' '    
END    
    
EXEC ('    
SELECT DISTINCT SBTAG, [BR] as BRAddress, ALT as AltAddress, TER as TerAddress ,        
City,CrtDt INTO #LatestSBDetails         
FROM (         
SELECT *  FROM (        
SELECT SBCADC.SBTag,SBCADC.AddType,        
SBCADC.AddLine1 +'',''+SBCADC.AddLine2 +'',''+SBCADC.Landmark+'',''+SBCADC.City +'',''+SBCADC.State+''-''+SBCADC.PinCode ''Address''        
,SBCADC.City,         
CONVERT(VARCHAR(11),SBCADC.CrtDt,113) ''CrtDt''         
            FROM [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCADC WITH(NOLOCK)       
   JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
   ON SBCADC.SBTag = SBACPD.SBTag      
   WHERE SBCADC.Current_Status=''VERIFIED'' AND CAST(SBCADC.CrtDt as date) >=''2022-12-20''        
   -----AND SBTAG =@SBTag     
   '+@Condition+'    
  )AA        
        ) AS P        
        PIVOT         
        (   MAX(Address)         
            FOR addtype in ([BR],[ALT],[TER])        
        ) AS  PVT        
      
------      
      
  SELECT  ISNULL(SBTAG,'''') ''SBTAG'',ISNULL(BranchTag,'''') ''BranchTag'',ISNULL(SBName,'''') ''SBName''        
  ,ISNULL(TradeName,'''') ''TradeName'',ISNULL(PanNo,'''') ''PanNo'',        
  ISNULL([OFF],'''') as OfficeAddress, ISNULL(RES,'''') as ResAddress, ISNULL(TER,'''') as TerAddress ,        
  ISNULL(Latest_AltAddress,'''') ''Latest_AltAddress'',ISNULL(Latest_BRAddress,'''') ''Latest_BRAddress''        
  ,ISNULL(Latest_TerAddress,'''') ''Latest_TerAddress''        
  ,ISNULL(Latest_City,'''') ''Latest_City'',ISNULL(Latest_CrtDt,'''') ''Latest_CrtDt'',         
  CASE         
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(Latest_TerAddress,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')='''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(Latest_AltAddress,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')='''' THEN ISNULL(Latest_TerAddress,'''')        
  ELSE ISNULL(Latest_AltAddress,'''')        
  END ''LatestAddress'',        
  CASE         
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(RES,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')='''' AND ISNULL(Latest_AltAddress,'''')<>'''' THEN ISNULL(RES,'''')        
  WHEN ISNULL(Latest_TerAddress,'''')<>'''' AND ISNULL(Latest_AltAddress,'''')='''' THEN ISNULL(RES,'''')        
  ELSE ISNULL([OFF],'''') END ''OldAddress''--,EmailId        
  ,DocumentSendDate      
FROM    (         
SELECT * FROM (        
SELECT DISTINCT SBCT.addtype,         
 ISNULL(SBB.SBTAG,'''') AS SBTAG,            
        SBB.Branch AS ''BranchTag'' ,               
            
  ISNULL(SBB.TRADENAME,'''') ''SBName'' ,              
  ISNULL(SBB.TRADENAME,'''') AS TradeName,             
            
  ISNULL(SBB.Panno,'''') as PanNo  ,            
  CONVERT(VARCHAR(10),SBB.TAGGeneratedDate,103) ''TAGGeneratedDate'',            
  ISNULL(SBB.IsActive,'''') ''Status'',          
  CONVERT(VARCHAR(10),SBB.IsActiveDate,103) ''StatusDate'',        
SBCT.AddLine1 +'' ''+ SBCT.AddLine2 +'' ''+ SBCT.Landmark +''-''+ SBCT.City +''-''+ SBCT.State +''-''+ SBCT.Country           
    ''Address''   ,        
 LSBD.AltAddress ''Latest_AltAddress'' , LSBD.BRAddress ''Latest_BRAddress''        
 ,LSBD.TerAddress ''Latest_TerAddress'',LSBD.City ''Latest_City'', LSBD.CrtDt ''Latest_CrtDt'',      
 CONVERT(VARCHAR(11),SBACPD.DocumentMailDate,113) ''DocumentSendDate''       
           
   FROM [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)          
  JOIN [SB_COMP].[dbo].SB_CONTACT SBCT WITH(NOLOCK)           
  ON SBCT.RefNo = SBB.RefNo         
  JOIN [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCAC WITH(NOLOCK)            
  ON SBCAC.SBTAG = SBB.SBTAG          
  JOIN #LatestSBDetails LSBD        
  ON SBB.SBTAG = LSBD.SBTag        
  JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
  ON SBB.SBTAG = SBACPD.SBTag      
  WHERE SBB.sbtag <> ''T A G''  AND SBCT.addtype IN(''RES'',''OFF'',''TER'')            
  AND SBCAC.Current_Status=''VERIFIED''        
  ----AND SBB.SBTAG in(''BHKS'')       
   '+@Condition+'    
  )AA        
        ) AS P        
        PIVOT         
        (   MAX(Address)         
            FOR addtype in ([OFF],[RES],[TER])        
        ) AS  PVT        
        
       ORDER BY SBTAG      
    ')    
END


/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositAllProcessStatusReport
-- --------------------------------------------------
  
       
CREATE PROCEDURE USP_GetSBDepositAllProcessStatusReport        
AS        
BEGIN
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SELECT ISNULL(SUM(ISNULL(TotalSBReceived,0)),0) 'TotalSBReceived', ISNULL(SUM(ISNULL(SBTeamApprove,0)),0) 'SBTeamApprove',      
ISNULL(SUM(ISNULL(SBProcessPending,0)),0) 'SBProcessPending',      
ISNULL(SUM(ISNULL(SBTeamRejected,0)),0) 'SBTeamRejected', ISNULL(SUM(ISNULL(KnockOffBySBTeam,0)),0) 'KnockOffBySBTeam',        
ISNULL(SUM(ISNULL(BankingJVDone,0)),0) 'BankingJVDone',ISNULL(SUM(ISNULL(BankingJVPending,0)),0) 'BankingJVPending'        
FROM (        
SELECT IIF(ISNULL(SBPDPLMS.DepositRefId,0)<>0,1,0) 'TotalSBReceived',        
CASE WHEN ISNULL(SBDVPSB.SuspenceAccDetailsId,0)<>0 AND SBDVPSB.IsSBRejected=0 THEN 1 END 'SBTeamApprove',        
CASE WHEN SBDVPSB.IsSBRejected NOT IN(0,8) THEN 1 END 'SBTeamRejected',        
CASE WHEN SBDVPSB.IsSBRejected =8 THEN 1 END 'KnockOffBySBTeam',        
CASE WHEN SBPDPLMS.IsSBRejected IN(0,1) AND ISNULL(SBDVPSB.DepositRefId,0)=0 THEN 1 END 'SBProcessPending',      
IIF(ISNULL(SBDBVP.IsJVProcess,0)<>0,1,0) 'BankingJVDone',        
CASE WHEN ISNULL(SBDBVP.IsJVProcess,0)=0 AND ISNULL(SBDVPSB.SuspenceAccDetailsId,0)<>0        
AND SBDVPSB.IsSBRejected=0 THEN 1 END 'BankingJVPending'        
        
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPLMS WITH(NOLOCK)        
LEFT JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSB WITH(NOLOCK)        
ON SBPDPLMS.DepositRefId = SBDVPSB.DepositRefId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDBVP.DepositVarificationId = SBDVPSB.DepositVarificationId        
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)             
ON SBCSBB.PanNo = SBDVPSB.SBPanNo AND SBDVPSB.SBTag= SBCSBB.SBTag  
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')  
  
) A        
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositAllProcessStatusReport_06Nov2025
-- --------------------------------------------------
  
       
CREATE PROCEDURE USP_GetSBDepositAllProcessStatusReport_06Nov2025        
AS        
BEGIN        
SELECT ISNULL(SUM(ISNULL(TotalSBReceived,0)),0) 'TotalSBReceived', ISNULL(SUM(ISNULL(SBTeamApprove,0)),0) 'SBTeamApprove',      
ISNULL(SUM(ISNULL(SBProcessPending,0)),0) 'SBProcessPending',      
ISNULL(SUM(ISNULL(SBTeamRejected,0)),0) 'SBTeamRejected', ISNULL(SUM(ISNULL(KnockOffBySBTeam,0)),0) 'KnockOffBySBTeam',        
ISNULL(SUM(ISNULL(BankingJVDone,0)),0) 'BankingJVDone',ISNULL(SUM(ISNULL(BankingJVPending,0)),0) 'BankingJVPending'        
FROM (        
SELECT IIF(ISNULL(SBPDPLMS.DepositRefId,0)<>0,1,0) 'TotalSBReceived',        
CASE WHEN ISNULL(SBDVPSB.SuspenceAccDetailsId,0)<>0 AND SBDVPSB.IsSBRejected=0 THEN 1 END 'SBTeamApprove',        
CASE WHEN SBDVPSB.IsSBRejected NOT IN(0,8) THEN 1 END 'SBTeamRejected',        
CASE WHEN SBDVPSB.IsSBRejected =8 THEN 1 END 'KnockOffBySBTeam',        
CASE WHEN SBPDPLMS.IsSBRejected IN(0,1) AND ISNULL(SBDVPSB.DepositRefId,0)=0 THEN 1 END 'SBProcessPending',      
IIF(ISNULL(SBDBVP.IsJVProcess,0)<>0,1,0) 'BankingJVDone',        
CASE WHEN ISNULL(SBDBVP.IsJVProcess,0)=0 AND ISNULL(SBDVPSB.SuspenceAccDetailsId,0)<>0        
AND SBDVPSB.IsSBRejected=0 THEN 1 END 'BankingJVPending'        
        
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPLMS WITH(NOLOCK)        
LEFT JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSB WITH(NOLOCK)        
ON SBPDPLMS.DepositRefId = SBDVPSB.DepositRefId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDBVP.DepositVarificationId = SBDVPSB.DepositVarificationId        
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)             
ON SBCSBB.PanNo = SBDVPSB.SBPanNo AND SBDVPSB.SBTag= SBCSBB.SBTag  
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')  
  
) A        
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositBackOfficeJVProcessStatus
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBDepositBackOfficeJVProcessStatus @IsRefundProcess bit    
AS    
BEGIN    
DECLARE @Condition VARCHAR(MAX)=''    
IF(@IsRefundProcess=1)    
BEGIN    
SET @Condition = ' AND AddBy=''SB_KnockOffRefund'' '    
END    
ELSE    
BEGIN    
SET @Condition = ' AND AddBy=''SBDeposit'' '    
END    
    
EXEC('    
   SELECT         
   CASE WHEN BSE=0 THEN 1        
   WHEN BSE=1 THEN 2        
   WHEN BSE=2 THEN 9        
   WHEN ISNULL(BSE,'''')='''' THEN 0        
   END ''BSE'',        
   CASE WHEN NSE=0 THEN 1        
   WHEN NSE=1 THEN 2        
   WHEN NSE=2 THEN 9        
   WHEN ISNULL(NSE,'''')='''' THEN 0        
   END ''NSE''        
   FROM        
   (        
   SELECT DISTINCT        
   AMTPD.EXCHANGE,AMTPD.ROWSTATE        
   FROM [AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES AMTPD WITH(NOLOCK)        
   WHERE CAST(VDATE AS DATE)=CAST(GETDATE() AS DATE) '+@Condition+'     
   ) AS P            
   PIVOT            
   (            
     MAX(RowState) FOR Exchange IN ([NSE],[BSE])            
   ) AS pv2 ')    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositRefundBankProcessFile
-- --------------------------------------------------
 
CREATE PROCEDURE USP_GetSBDepositRefundBankProcessFile    
AS    
BEGIN    
SELECT SBDKPD.SBBankAccountNo,VAmount,SBPDPDLMS.SBName , 'Mumbai' 'City',    
SBPDPDLMS.RefNo, CONVERT(VARCHAR(10),GETDATE(),103) 'Date',SBDKPD.IFSCCode,SBDKPD.BankName,SBDKPD.BranchName    
,SBDKPD.VNo,SBDKPD.Segment    
FROM tbl_SBDepositKnockOffProcessDetails SBDKPD WITH(NOLOCK)    
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSBT WITH(NOLOCK)    
ON SBDKPD.DepositRefId= SBDVPSBT.DepositRefId    
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)    
ON SBPDPDLMS.DepositRefId = SBDKPD.DepositRefId    
WHERE SBDVPSBT.IsSBRejected=8    
AND CAST(SBDKPD.ProcessDate as date) =CAST(getdate() as date)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositSBTeamRejectedKnockOffData
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GetSBDepositSBTeamRejectedKnockOffData] @RefId bigint=0    
AS    
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @Condition VARCHAR(MAX)=''      
IF(ISNULL(@RefId,0)<>0)    
BEGIN    
SET @Condition = ' AND CAST(SBPDPDL.DepositRefId as nvarchar) = '+CAST(@RefId as nvarchar)+''    
END    
    
EXEC('    
SELECT SBPDPDL.DepositRefId ''RefId'', SBPDPDL.SBPanNo,ISNULL(SBCSBB.SBTAG,''Not Available'') ''SBTAG''    
,SBPDPDL.SBName,SBPDPDL.RefNo,SBPDPDL.Amount ''DepositAmount'',SBPDPDL.FileName    
,Remarks ''LMSRemarks'', RejectionReason ''SBRemarks''    
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDL WITH(NOLOCK)    
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSB WITH(NOLOCK)    
ON SBPDPDL.DepositRefId = SBDVPSB.DepositRefId    
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)       
ON SBCSBB.PanNo = SBPDPDL.SBPanNo AND  SBCSBB.TradeName = SBPDPDL.SBName   
AND Branch NOT IN(''ITRADE'',''SMART'',''RFRL'')       
WHERE SBDVPSB.IsSBRejected=8 AND ISNULL(SBDVPSB.RejectionReason,'''')<>''''   
AND SBDVPSB.DepositRefId NOT IN(SELECT DepositRefId FROM tbl_SBDepositKnockOffProcessDetails)  
'+@Condition+'    
')    
END    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositSBTeamRejectedKnockOffData_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_GetSBDepositSBTeamRejectedKnockOffData_06Nov2025] @RefId bigint=0    
AS    
BEGIN    
DECLARE @Condition VARCHAR(MAX)=''      
IF(ISNULL(@RefId,0)<>0)    
BEGIN    
SET @Condition = ' AND CAST(SBPDPDL.DepositRefId as nvarchar) = '+CAST(@RefId as nvarchar)+''    
END    
    
EXEC('    
SELECT SBPDPDL.DepositRefId ''RefId'', SBPDPDL.SBPanNo,ISNULL(SBCSBB.SBTAG,''Not Available'') ''SBTAG''    
,SBPDPDL.SBName,SBPDPDL.RefNo,SBPDPDL.Amount ''DepositAmount'',SBPDPDL.FileName    
,Remarks ''LMSRemarks'', RejectionReason ''SBRemarks''    
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDL WITH(NOLOCK)    
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSB WITH(NOLOCK)    
ON SBPDPDL.DepositRefId = SBDVPSB.DepositRefId    
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)       
ON SBCSBB.PanNo = SBPDPDL.SBPanNo AND  SBCSBB.TradeName = SBPDPDL.SBName   
AND Branch NOT IN(''ITRADE'',''SMART'',''RFRL'')       
WHERE SBDVPSB.IsSBRejected=8 AND ISNULL(SBDVPSB.RejectionReason,'''')<>''''   
AND SBDVPSB.DepositRefId NOT IN(SELECT DepositRefId FROM tbl_SBDepositKnockOffProcessDetails)  
'+@Condition+'    
')    
END    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositSuspenceAccDetailsForBankingProcess
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBDepositSuspenceAccDetailsForBankingProcess      
@FromDate VARCHAR(15)='',@ToDate VARCHAR(15)='',@ProcessType VARCHAR(15)=''     
AS              
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

IF(ISNULL(@ProcessType,'') ='Closed')    
BEGIN    
    
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    
    
SELECT SBDVPS.SBTag,SBDVPS.SBPanNo,SBCSBB.TradeName 'SBName',SBDVPS.DepositRefId 'RefId',SBDVPS.RefNo,SBDVPS.DepositAmount              
,SBDSAC.VType, '' 'FileName' ,SBDSAC.VNo,SBDSAC.VAmount, CONVERT(VARCHAR(10),SBDSAC.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDBVP.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)    
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)     
ON SBDBVP.DepositVarificationId = SBDVPS.DepositVarificationId     
AND SBDBVP.SuspenceAccDetailsId = SBDVPS.SuspenceAccDetailsId    
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)              
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId              
JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)              
ON SBCSBB.SBTAG = SBDVPS.SBTag AND SBCSBB.PanNo = SBDVPS.SBPanNo         
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')      
WHERE CAST(SBDBVP.ProcessDate as date) between @FromDate  AND @ToDate    
END    
IF(ISNULL(@ProcessType,'') ='KnockOff')  
BEGIN  
  
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    
  
SELECT SBPDPDLMS.SBTag,SBPDPDLMS.SBPanNo,SBPDPDLMS.SBName 'SBName',SBPDPDLMS.DepositRefId 'RefId',SBPDPDLMS.RefNo,SBPDPDLMS.Amount 'DepositAmount'  
,SBDKOPD.VType, '' 'FileName' ,SBDKOPD.VNo,SBDKOPD.VAmount, CONVERT(VARCHAR(10),SBDKOPD.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDKOPD.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositKnockOffProcessDetails SBDKOPD WITH(NOLOCK)    
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)  
ON SBDKOPD.DepositRefId = SBPDPDLMS.DepositRefId     
WHERE SBDKOPD.IsProcessStatus=1 AND SBDKOPD.IsOldProcess=0  
AND CAST(SBDKOPD.ProcessDate as date) between @FromDate  AND @ToDate    
END  
ELSE    
BEGIN    
SELECT SBDVPS.SBTag,SBDVPS.SBPanNo,SBCSBB.TradeName 'SBName',SBDVPS.DepositRefId 'RefId',SBDVPS.RefNo,SBDVPS.DepositAmount              
,SBDSAC.VType, '' 'FileName' ,SBDSAC.VNo,SBDSAC.VAmount, CONVERT(VARCHAR(10),SBDSAC.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDSAC.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)              
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)              
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId              
JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)              
ON SBCSBB.SBTAG = SBDVPS.SBTag AND SBCSBB.PanNo = SBDVPS.SBPanNo         
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')      
WHERE SBDVPS.DepositVarificationId NOT IN(SELECT distinct DepositVarificationId FROM tbl_SBDepositBankingVarificationProcess)            
END      
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositSuspenceAccDetailsForBankingProcess_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBDepositSuspenceAccDetailsForBankingProcess_06Nov2025      
@FromDate VARCHAR(15)='',@ToDate VARCHAR(15)='',@ProcessType VARCHAR(15)=''     
AS              
BEGIN         
IF(ISNULL(@ProcessType,'') ='Closed')    
BEGIN    
    
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    
    
SELECT SBDVPS.SBTag,SBDVPS.SBPanNo,SBCSBB.TradeName 'SBName',SBDVPS.DepositRefId 'RefId',SBDVPS.RefNo,SBDVPS.DepositAmount              
,SBDSAC.VType, '' 'FileName' ,SBDSAC.VNo,SBDSAC.VAmount, CONVERT(VARCHAR(10),SBDSAC.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDBVP.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)    
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)     
ON SBDBVP.DepositVarificationId = SBDVPS.DepositVarificationId     
AND SBDBVP.SuspenceAccDetailsId = SBDVPS.SuspenceAccDetailsId    
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)              
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId              
JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)              
ON SBCSBB.SBTAG = SBDVPS.SBTag AND SBCSBB.PanNo = SBDVPS.SBPanNo         
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')      
WHERE CAST(SBDBVP.ProcessDate as date) between @FromDate  AND @ToDate    
END    
IF(ISNULL(@ProcessType,'') ='KnockOff')  
BEGIN  
  
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)    
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)    
  
SELECT SBPDPDLMS.SBTag,SBPDPDLMS.SBPanNo,SBPDPDLMS.SBName 'SBName',SBPDPDLMS.DepositRefId 'RefId',SBPDPDLMS.RefNo,SBPDPDLMS.Amount 'DepositAmount'  
,SBDKOPD.VType, '' 'FileName' ,SBDKOPD.VNo,SBDKOPD.VAmount, CONVERT(VARCHAR(10),SBDKOPD.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDKOPD.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositKnockOffProcessDetails SBDKOPD WITH(NOLOCK)    
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)  
ON SBDKOPD.DepositRefId = SBPDPDLMS.DepositRefId     
WHERE SBDKOPD.IsProcessStatus=1 AND SBDKOPD.IsOldProcess=0  
AND CAST(SBDKOPD.ProcessDate as date) between @FromDate  AND @ToDate    
END  
ELSE    
BEGIN    
SELECT SBDVPS.SBTag,SBDVPS.SBPanNo,SBCSBB.TradeName 'SBName',SBDVPS.DepositRefId 'RefId',SBDVPS.RefNo,SBDVPS.DepositAmount              
,SBDSAC.VType, '' 'FileName' ,SBDSAC.VNo,SBDSAC.VAmount, CONVERT(VARCHAR(10),SBDSAC.VDate,103) 'VDate'              
,Segment, Narration, CONVERT(VARCHAR(10),SBDSAC.ProcessDate,103) 'ProcessDate'              
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)              
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)              
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId              
JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)              
ON SBCSBB.SBTAG = SBDVPS.SBTag AND SBCSBB.PanNo = SBDVPS.SBPanNo         
AND SBCSBB.branch NOT IN('ITRADE','SMART','RFRL')      
WHERE SBDVPS.DepositVarificationId NOT IN(SELECT distinct DepositVarificationId FROM tbl_SBDepositBankingVarificationProcess)            
END      
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositSuspenceAccJVBackOfficeReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBDepositSuspenceAccJVBackOfficeReport   
@IsRefundProcess bit =0      
AS        
BEGIN        
IF(@IsRefundProcess=1)    
BEGIN    
SELECT                 
VOUCHERTYPE                 
,SNO                 
,CONVERT(VARCHAR(10),VDATE,103) 'VDATE'                 
,CONVERT(VARCHAR(10),EDATE,103) 'EDATE'                 
,CLTCODE                 
,CREDITAMT                 
,DEBITAMT                 
,NARRATION                 
,BANKCODE                 
,MARGINCODE                 
,BANKNAME                 
,BRANCHNAME                 
,BRANCHCODE                 
,DDNO                 
,CHEQUEMODE                 
,CONVERT(VARCHAR(10),CHEQUEDATE,103) 'CHEQUEDATE'                 
,CHEQUENAME                 
,CLEAR_MODE                 
,TPACCOUNTNUMBER                 
,EXCHANGE                 
,SEGMENT                 
,MKCK_FLAG                 
,RETURN_FLD1                 
,RETURN_FLD2                 
,RETURN_FLD3                 
,RETURN_FLD4                 
,RETURN_FLD5                 
,ROWSTATE                
FROM tbl_SBDepositProcessBOLedgerData WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE)         
AND ISPROCESS_STATUS=0  AND ISKNOCKOFF_PROCESS =1      
END    
ELSE    
BEGIN    
SELECT                 
VOUCHERTYPE                 
,SNO                 
,CONVERT(VARCHAR(10),VDATE,103) 'VDATE'                 
,CONVERT(VARCHAR(10),EDATE,103) 'EDATE'                     
,CLTCODE                 
, IIF(ISNULL(CREDITAMT,0)<>0 , CREDITAMT,   DEBITAMT) 'CREDITAMT'              
,DEBITAMT                 
,NARRATION                 
,BANKCODE                 
, IIF(ISNULL(CREDITAMT,0)<>0 , 'C',   'D') 'MARGINCODE'    
,BANKNAME                 
,BRANCHNAME                 
,BRANCHCODE                 
,DDNO                 
, IIF(ISNULL(CREDITAMT,0)<>0 , 'C',   'D') 'CHEQUEMODE'                 
,CHEQUEDATE                 
,CHEQUENAME                 
,CLEAR_MODE                 
,TPACCOUNTNUMBER                 
,EXCHANGE                 
,SEGMENT                 
,MKCK_FLAG                 
,RETURN_FLD1                 
,RETURN_FLD2                 
,RETURN_FLD3                 
,RETURN_FLD4                 
,RETURN_FLD5                 
,ROWSTATE                
FROM tbl_SBDepositProcessBOLedgerData WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE)         
AND ISPROCESS_STATUS=0  AND ISKNOCKOFF_PROCESS =0      
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositTransactionDocuments
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBDepositTransactionDocuments @DepositRefId bigint    
AS    
BEGIN    
SELECT SBPanNo, SBName,LTRIM(RTRIM(SBPDPDLMS.RefNo)) RefNo,SBPDPDLMS.Amount,SBPDPDD.FileName,SBPDPDD.Files   
FROM tbl_SBPayoutDepositProcessDocumentDetails SBPDPDD WITH(NOLOCK)    
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)   
ON SBPDPDD.DepositRefId=SBPDPDLMS.DepositRefId  
WHERE SBPDPDD.DepositRefId= @DepositRefId    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBDepositVarificationProcessReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBDepositVarificationProcessReport  
AS  
BEGIN  
SELECT SBDVPSBT.DepositRefId 'RefId', SBDVPSBT.SBTag,SBDVPSBT.SBPanNo  
,SBPDPDLMS.SBName 'SBName',  
LTRIM(RTRIM(SBDVPSBT.RefNo)) 'RefNo', SBDVPSBT.DepositAmount,  
CASE WHEN SBDVPSBT.IsSBRejected=8 THEN 'Knock Off'  
WHEN SBDVPSBT.IsSBRejected=0 THEN 'Accepted'  
ELSE 'Rejected' END 'Status',  
CASE WHEN SBDVPSBT.IsSBRejected=8 THEN RejectionReason  
WHEN SBDVPSBT.IsSBRejected=0 THEN 'Accepted'  
ELSE SBDVPSBT.RejectionReason END 'Remarks',  
ISNULL(SBDSAD.VType,0) 'VType', ISNULL(SBDSAD.VNo,'NP') 'VNo'  
,CAST(ISNULL(SBDSAD.VAmount,0) as decimal(10,2)) 'VAmount',   
CONVERT(VARCHAR(10),ISNULL(SBDSAD.VDate,''),103) 'VDate',   
ISNULL(SBDSAD.Segment,'NP') 'Segment', ISNULL(SBDSAD.Narration,'NP') 'Narration'  
,CONVERT(VARCHAR(10),ISNULL(SBDVPSBT.ProcessDate,''),103) 'ProcessDate'  
  
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPSBT WITH(NOLOCK)   
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)  
ON SBPDPDLMS.SBPanNo = SBDVPSBT.SBPanNo AND SBDVPSBT.DepositRefId = SBPDPDLMS.DepositRefId  
LEFT JOIN tbl_SBDepositSuspenceAccountDetails SBDSAD WITH(NOLOCK)  
ON SBDVPSBT.SuspenceAccDetailsId = SBDSAD.SuspenceAccDetailsId  
WHERE CAST(SBDVPSBT.ProcessDate as date) >= CAST(GETDATE()-7 as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBIntermediaryGeneralAndAddressDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBIntermediaryGeneralAndAddressDetails        
@SBPanNo VARCHAR(15)=''        
AS        
BEGIN         
SELECT TOP 1 IMGD.IntermediaryId,IMGD.IntermediaryCode,   SBOBCM.CompanyId, SBOBCM.CompanyName,     
IMGD.IntermediaryName, IMGD.TradeName,IMGD.IntermediaryType,IMGD.Region,IMGD.PanNo,        
CONVERT(VARCHAR(10),IMGD.DOB_IncorporationDate,103) 'DOB_IncorporationDate',        
        
AadhaarNo,        
TerminalAddressLine1 +','+ TerminalAddressLine2 +','+TerminalAddressLine3 +','+         
TerminalAreaLandmark+','+TerminalCity+','+TerminalState +'-'+TerminalPin 'OfficeAddress',        
TerminalCity,TerminalCountry,TerminalOffStdCode1,TerminalOffPhone1,Mobile1,Mobile2,Email,        
RegisteredAddressLine1 +','+RegisteredAddressLine2 +','+RegisteredAddressLine3 +','+        
RegisteredAreaLandmark +','+RegisteredCity +','+RegisteredState +'-'+RegisteredPin 'RegisteredAddress'        
,RegisteredCountry,Gender,MaritalStatus, CONVERT(VARCHAR(10),GETDATE(),103) 'CurrentDate',
CASE WHEN ISNULL(IMSD.BSE_CASH,0)=1 AND ISNULL(IMSD.BSE_FO,0)=1 AND ISNULL(IMSD.BSE_CDX,0)=1 THEN 'CM/FO/CD'
WHEN ISNULL(IMSD.BSE_CASH,0)=1 AND ISNULL(IMSD.BSE_FO,0)=1 THEN 'CM/FO'
WHEN ISNULL(IMSD.BSE_CASH,0)=1 AND ISNULL(IMSD.BSE_CDX,0)=1 THEN 'CM/CD'
WHEN ISNULL(IMSD.BSE_FO,0)=1 AND ISNULL(IMSD.BSE_CDX,0)=1 THEN 'FO/CD'
WHEN ISNULL(IMSD.BSE_FO,0)=1 THEN 'FO'
WHEN ISNULL(IMSD.BSE_CDX,0)=1 THEN 'CD'
WHEN ISNULL(IMSD.BSE_CASH,0)=1 THEN 'CM'
ELSE '' END 'BSESegment',
CASE WHEN ISNULL(IMSD.NSE_CASH,0)=1 AND ISNULL(IMSD.NSE_FO,0)=1 AND ISNULL(IMSD.NSE_CDX,0)=1 THEN 'CM/FO/CD'
WHEN ISNULL(IMSD.NSE_CASH,0)=1 AND ISNULL(IMSD.NSE_FO,0)=1 THEN 'CM/FO'
WHEN ISNULL(IMSD.NSE_CASH,0)=1 AND ISNULL(IMSD.NSE_CDX,0)=1 THEN 'CM/CD'
WHEN ISNULL(IMSD.NSE_FO,0)=1 AND ISNULL(IMSD.NSE_CDX,0)=1 THEN 'FO/CD'
WHEN ISNULL(IMSD.NSE_FO,0)=1 THEN 'FO'
WHEN ISNULL(IMSD.NSE_CDX,0)=1 THEN 'CD'
WHEN ISNULL(IMSD.NSE_CASH,0)=1 THEN 'CM'
ELSE '' END 'NSESegment'
FROM         
tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)        
JOIN tbl_SubBrokerOnBoardingCompanyMaster SBOBCM WITH(NOLOCK)      
ON IMGD.CompanyId = SBOBCM.CompanyId    
LEFT JOIN tbl_IntermediaryMasterAddressDetails IMAD WITH(NOLOCK)                
ON IMGD.IntermediaryId = IMAD.IntermediaryId 
LEFT JOIN tbl_IntermediaryMasterSegmentDetails IMSD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMSD.IntermediaryId
WHERE IMGD.PanNo=@SBPanNo        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBIntermediaryMasterProcessDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetSBIntermediaryMasterProcessDetails]    
AS    
BEGIN    
SELECT IMGD.IntermediaryId,SBOBCM.CompanyId,SBOBCM.CompanyName,    
CASE WHEN ISNULL(ISBTGM.SBTag,'')<>'' THEN ISBTGM.SBTag    
ELSE IMGD.IntermediaryCode END 'IntermediaryCode', IMGD.IntermediaryName,    
ISNULL(IMGD.TradeName,'') 'TradeName',ISNULL(IMGD.PanNo,'') 'PanNo',    
CONVERT(VARCHAR(10),IMGD.DOB_IncorporationDate,103) 'DOB_IncorporationDate',    
CONVERT(VARCHAR(10),IMGD.DateIntroduced,103) 'DateIntroduced'     
,ISNULL(IMGD.IntroducedByIntermediary_Branch,'') 'IntroducedByIntermediary_Branch'    
,ISNULL(IMGD.Region,'') 'Region',ISNULL(IMGD.IntermediaryType,'') 'IntermediaryType'        
,ISNULL(IMGD.BusinessType,'') 'BusinessType',ISNULL(IMGD.Zone,'') 'Zone'    
,ISNULL(IMGD.IntermediaryStatus,'') 'IntermediaryStatus',ISNULL(IMGD.GSTNo,'') 'GSTNo'        
,ISNULL(IMGD.Parent,'') 'Parent' ,    
ISNULL(IMGD.BranchName,'') 'BranchName',    
ISNULL(IMGD.NoOfPartners_Directors,0) 'NoOfPartners_Directors'    
,ISNULL(IMGD.IntroducedByEmployee,'') 'IntroducedByEmployee'    
    
, CASE WHEN ISNULL(IMGD.Remarks,'0')='1' AND ISNULL(IMGD.Notes,'')<>'' THEN 'Re-Process : ' + IMGD.Notes    
WHEN ISNULL(ISBVPM.ProcessRemarks,'')<>'' THEN 'CSO '+ISBVPM.ProcessStatus+' : '+ISBVPM.ProcessRemarks    
WHEN ISNULL(PLVCVPD.ProcessRemarks,'')<>'' THEN 'PLVC '+PLVCVPD.ProcessStatus+' : '+PLVCVPD.ProcessRemarks     
ELSE '' END 'Notes',    
ISNULL(IMGD.Remarks,'0') 'General_Remarks'    
    
,ISNULL(IMGD.ProcessBy,'') 'AddedBy'    
,CONVERT(VARCHAR(20),IMGD.ProcessDate,113) 'ProcessDate',       
     
ISNULL(IMAD.AadhaarNo,'') 'AadhaarNo',ISNULL(IMAD.TerminalAddressLine1,'') 'TerminalAddressLine1'        
,ISNULL(IMAD.TerminalAddressLine2,'')'TerminalAddressLine2'        
,ISNULL(IMAD.TerminalAddressLine3,'') 'TerminalAddressLine3',    
ISNULL(IMAD.TerminalAreaLandmark,'') 'TerminalAreaLandmark',ISNULL(IMAD.TerminalCountry,'')'TerminalCountry',    
ISNULL(IMAD.TerminalCity,'')'TerminalCity',ISNULL(IMAD.TerminalState,'') 'TerminalState'        
,ISNULL(IMAD.TerminalPin,'') 'TerminalPin',     
ISNULL(IMAD.Mobile1,'') 'Mobile1',ISNULL(IMAD.Mobile2,'') 'Mobile2', ISNULL(IMAD.Email,'')'Email',     
ISNULL(IMAD.IsCopyTerminalAddress,0) 'IsCopyTerminalAddress',     
ISNULL(IMAD.RegisteredAddressLine1,'') 'RegisteredAddressLine1',        
ISNULL(IMAD.RegisteredAddressLine2,'') 'RegisteredAddressLine2'        
,ISNULL(IMAD.RegisteredAddressLine3,'') 'RegisteredAddressLine3',    
ISNULL(IMAD.RegisteredCity,'') 'RegisteredCity',ISNULL(IMAD.RegisteredState,'') 'RegisteredState'        
,ISNULL(IMAD.RegisteredPin,'') 'RegisteredPin', ISNULL(IMAD.RegisteredAreaLandmark,'') 'RegisteredAreaLandmark'    
,ISNULL(IMAD.RegisteredCountry,'') 'RegisteredCountry',       
ISNULL(IMAD.TerminalOffStdCode1,'') 'TerminalOffStdCode1'        
,ISNULL(IMAD.TerminalOffPhone1,'') 'TerminalOffPhone1'        
,ISNULL(IMAD.Gender,'') 'Gender',ISNULL(IMAD.MaritalStatus,'') 'MaritalStatus',    
ISNULL(IMAD.TerminalOffStdCode2,'') 'TerminalOffStdCode2'        
,ISNULL(IMAD.TerminalOffPhone2,'') 'TerminalOffPhone2'        
,ISNULL(IMAD.TerminalOffStdCode3,'') 'TerminalOffStdCode3',        
ISNULL(IMAD.TerminalOffPhone3,'') 'TerminalOffPhone3',    
ISNULL(IMAD.RegisteredStdFax,'') 'RegisteredStdFax',ISNULL(IMAD.RegisteredFax,'') 'RegisteredFax'        
,ISNULL(IMAD.RegisteredStdResPhone,'') 'RegisteredStdResPhone',        
ISNULL(IMAD.RegisteredResPhone,'') 'RegisteredResPhone',    
ISNULL(IMAD.MaritalStatus,'') 'MaritalStatus',ISNULL(IMAD.FatherName,'') 'FatherName'        
,ISNULL(IMAD.SpouseName,'') 'SpouseName'    
,ISNULL(IMAD.RelationshipManager,'') 'RelationshipManager',ISNULL(IMAD.FGCode,'') 'FGCode'        
,ISNULL(IMAD.FamilyReason,'') 'FamilyReason',     
     
ISNULL(IMBD.IFSC_RTGS_NEFTCode,'') 'IFSC_RTGS_NEFTCode',ISNULL(IMBD.BankName,'') 'BankName'        
,ISNULL(IMBD.Branch,'') 'Branch',ISNULL(IMBD.Address,'') 'Address',ISNULL(IMBD.AccountType,'') 'AccountType'    
,ISNULL(IMBD.AccountNo,'') 'AccountNo',ISNULL(IMBD.MICRNo,'') 'MICRNo',        
ISNULL(IMBD.NameInBank,'') 'NameInBank'     
     
,ISNULL(IMOD.PreviouslyAffiliated,'') 'PreviouslyAffiliated',ISNULL(IMOD.NameOfBroker,'') 'NameOfBroker'    
,ISNULL(IMOD.Occupation,'') 'Occupation',ISNULL(IMOD.OccupationDetails,'') 'OccupationDetails'        
,ISNULL(IMOD.CapitalMarketExperience,'') 'CapitalMarketExperience',ISNULL(IMOD.TotalExperience,'') 'TotalExperience'    
,ISNULL(IMOD.Networth,'') 'Networth',ISNULL(IMOD.ClientBase,'') 'ClientBase'        
,ISNULL(IMOD.OfficeSpace,'') 'OfficeSpace',ISNULL(IMOD.TerminalRequried,'') 'TerminalRequried'        
,ISNULL(IMOD.OfficeType,'') 'OfficeType',  ISNULL(IMOD.EducationQualification,'') 'EducationQualification',        
     
ISNULL(IMBKD.SubBrokerShares,0) 'SubBrokerShares',        
ISNULL(IMBKD.Intraday_MinToClient,'') 'Intraday_MinToClient',ISNULL(IMBKD.NSE_Nifty,0) 'NSE_Nifty',        
ISNULL(IMBKD.NSEBankNifty,0) 'NSEBankNifty'    
,ISNULL(IMBKD.NSE_FIN_Nifty,0) 'NSE_FIN_Nifty',    
ISNULL(IMBKD.NSE_StockOption,0) 'NSE_StockOption'        
,ISNULL(IMBKD.Delivery_MinToClient,'') 'Delivery_MinToClient'        
,ISNULL(IMBKD.NSECurrencyOption,0) 'NSECurrencyOption',ISNULL(IMBKD.MCXOption,0) 'MCXOption',        
ISNULL(IsDefaultSharesToSB,0) 'IsDefaultSharesToSB',       
     
ISNULL(IMDAFD.TypeOfSB,'') 'TypeOfSB',ISNULL(IMDAFD.Deposit,0) 'Deposit'        
,ISNULL(IMDAFD.ActualDeposit,0) 'ActualDeposit',ISNULL(IMDAFD.Balance,0) 'Balance'        
,ISNULL(IMDAFD.ApprovalForLowDeposit,'') 'ApprovalForLowDeposit',    
ISNULL(IMDAFD.RegnFees,0) 'RegnFees' ,ISNULL(IMDAFD.ApprovalDocFileName,'') 'DepositApprovalDocFileName'     
     
,ISNULL(IMSD.BSE_CASH,0) 'BSE_CASH',ISNULL(IMSD.BSE_FO,0) 'BSE_FO',ISNULL(IMSD.NSE_CASH,0) 'NSE_CASH'        
,ISNULL(IMSD.NSE_FO,0) 'NSE_FO',  ISNULL(IMSD.NCDEX_FO,0) 'NCDEX_FO',ISNULL(IMSD.MCX_FO,0) 'MCX_FO'    
,ISNULL(IMSD.BSE_CDX,0) 'BSE_CDX',ISNULL(IMSD.NSE_CDX,0) 'NSE_CDX' ,     
    
CASE WHEN CAST(ISNULL(ISBTGM.TagGenerationDate,'') as date)<>'1900-01-01'    
THEN CONVERT(VARCHAR(20),ISNULL(ISBTGM.TagGenerationDate,''),113) ELSE '' END 'TagGenerationDate',      
    
ISNULL(ISBTGUDD.IsFinalIntermediaryProcess,0) 'IsFinalIntermediaryProcess',    
    
CASE WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Approve' THEN 1      
WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Reject' THEN 2     
ELSE 0 END 'PLVCStatus',     
ISNULL(PLVCVPD.ProcessStatus,'') 'PLVCProcessStatus'     
, ISNULL(PLVCVPD.ProcessRemarks,'') 'PLVCProcessRemarks'     
,ISNULL(PLVCVPD.ProcessBy,'') 'PLVCProcessBy'     
,ISNULL(PLVCVPD.ProcessDate,'') 'PLVCProcessDate',     
     
--CASE WHEN ISNULL(CSOVPM.ProcessStatus,'')='Approve' THEN 1      
--WHEN ISNULL(CSOVPM.ProcessStatus,'')='Reject' THEN 2     
--ELSE 0 END 'CSOStatus',     
--ISNULL(CSOVPM.ProcessStatus,'') 'CSOProcessStatus'     
--,ISNULL(CSOVPM.ProcessRemarks,'') 'CSOProcessRemarks'     
--,ISNULL(CSOVPM.ProcessBy,'') 'CSOProcessBy'     
--,ISNULL(CSOVPM.ProcessDate,'') 'CSOProcessDate',     
     
CASE WHEN ISNULL(ISBVPM.ProcessStatus,'')='Approve' THEN 1      
WHEN ISNULL(ISBVPM.ProcessStatus,'')='Reject' THEN 2     
ELSE 0 END 'SBStatus',     
ISNULL(ISBVPM.ProcessStatus,'') 'SBProcessStatus'     
, ISNULL(ISBVPM.ProcessRemarks,'') 'SBProcessRemarks'     
,ISNULL(ISBVPM.ProcessBy,'') 'SBProcessBy'     
,ISNULL(ISBVPM.ProcessDate,'') 'SBProcessDate',     
     
CASE WHEN ISNULL(ISBVPM.ProcessStatus,'')='Approve' THEN 'SB Approved'     
WHEN ISNULL(ISBVPM.ProcessStatus,'')='Reject' THEN 'SB Rejected'     
--WHEN ISNULL(CSOVPM.ProcessStatus,'')='Approve' THEN 'CSO Approved'     
--WHEN ISNULL(CSOVPM.ProcessStatus,'')='Reject' THEN 'CSO Rejected'     
WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Approve' THEN 'PLVC Approved'     
WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Reject' THEN 'PLVC Rejected'     
WHEN ISNULL(ISBTGUDD.IsFinalIntermediaryProcess,0) <>0 THEN 'BDM Process Done' 
WHEN ISNULL(IMGD.IntermediaryId,0) <>0 AND ISNULL(ISBTGUDD.IsFinalIntermediaryProcess,0)=0 THEN 'BDM Entry In-Process' 
END 'CurrentProcess',     
     
CASE WHEN ISNULL(ISBVPM.ProcessStatus,'')='Approve' THEN 4     
WHEN ISNULL(ISBVPM.ProcessStatus,'')='Reject' THEN 3    
WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Approve' THEN 4     
WHEN ISNULL(PLVCVPD.ProcessStatus,'')='Reject' THEN 2     
WHEN ISNULL(ISBTGUDD.IsFinalIntermediaryProcess,0) <>0 THEN 1 
WHEN ISNULL(IMGD.IntermediaryId,0) <>0 AND ISNULL(ISBTGUDD.IsFinalIntermediaryProcess,0)=0 THEN 0     
END 'CurrentStatusCode',     
     
CASE WHEN ISNULL(ISBVPM.ProcessStatus,'')<>'' THEN ISBVPM.ProcessRemarks     
--WHEN ISNULL(CSOVPM.ProcessStatus,'')<>'' THEN CSOVPM.ProcessRemarks     
WHEN ISNULL(PLVCVPD.ProcessStatus,'')<>'' THEN PLVCVPD.ProcessRemarks         
ELSE ''        
END 'ProcessRemarks'     
     
FROM     
tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)    
JOIN tbl_SubBrokerOnBoardingCompanyMaster SBOBCM WITH(NOLOCK)    
ON IMGD.CompanyId = SBOBCM.CompanyId  
LEFT JOIN tbl_IntermediaryMasterAddressDetails IMAD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMAD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterBankDetails IMBD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMBD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterBrokerageDetails IMBKD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMBKD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterDepositAndFeesDetails IMDAFD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMDAFD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterOccuptionDetails IMOD WITH(NOLOCK)    
ON IMGD.IntermediaryId = IMOD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterSegmentDetails IMSD WITH(NOLOCK)         
ON IMGD.IntermediaryId = IMSD.IntermediaryId    
LEFT JOIN tbl_IntermediaryMasterPLVCProcess PLVCVPD WITH(NOLOCK)     
ON IMGD.IntermediaryId = PLVCVPD.IntermediaryId        
--LEFT JOIN tbl_IntermediaryCSOVerificationMaster CSOVPM WITH(NOLOCK)     
--ON IMGD.IntermediaryId = CSOVPM.IntermediaryId      
LEFT JOIN tbl_IntermediarySBVerificationMaster ISBVPM WITH(NOLOCK)     
ON IMGD.IntermediaryId = ISBVPM.IntermediaryId    
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM WITH(NOLOCK)    
ON IMGD.IntermediaryId = ISBTGM.IntermediaryId      
LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUDD WITH(NOLOCK)     
ON IMGD.IntermediaryId = ISBTGUDD.IntermediaryId      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBIntermediaryMultiPartnersDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBIntermediaryMultiPartnersDetails        
@SBPanNo VARCHAR(15)=''        
AS        
BEGIN        
SELECT IMMPD.PartnersDetailsId,IMGD.IntermediaryId,IMGD.IntermediaryName,IMGD.TradeName,IMGD.IntermediaryType        
,IMMPD.PartnersName,CONVERT(VARCHAR(10),IMMPD.PartnerDOB,103)'PartnerDOB',IMMPD.PartnerPanNo,IMMPD.PartnerGender        
,IMMPD.PartnerDesignation,IMMPD.EducationalQualification,IMMPD.PartnerFatherName,IMMPD.Husband_WifeName         
,IMMPD.PartnerAddressLine1,IMMPD.PartnerAddressLine2,IMMPD.PartnerAddressLine3,IMMPD.Occupation        
,IMMPD.PercentageShareHolding ,IMMPD.CapitalMarketExperience,IMMPD.AreaLandmark,IMMPD.PinCode,IMMPD.City,IMMPD.State,        
IMMPD.Country,IMMPD.AadharNo,IMMPD.MobileNo,IMMPD.EmailId,IMMPD.PEPType,IMMPD.PEPDocFileName ,  
IMMPD.PanCardFileName,IMMPD.AddressProffFileName,IMMPD.EducationProffFileName,IMMPD.OtherDocFileName  
,CONVERT(VARCHAR(10),IMMPD.ProcessDate,103)'ProcessDate',IMMPD.ProcessBy,
CASE WHEN ISNULL(ProcessStatus,'')='Approve' THEN 1 ELSE 0 END 'SBStatus'
FROM tbl_IntermediaryMasterMultiPartnersDetails IMMPD WITH(NOLOCK)        
JOIN tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)        
ON IMMPD.IntermediaryId= IMGD.IntermediaryId     
LEFT JOIN tbl_IntermediarySBVerificationMaster IMSBVM  WITH(NOLOCK)    
ON IMMPD.IntermediaryId = IMSBVM.IntermediaryId
WHERE IMGD.PanNo = @SBPanNo      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETSBJVMarginAmountSummaryReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GETSBJVMarginAmountSummaryReport    
AS    
BEGIN    
SELECT TOP 10 ROW_NUMBER() OVER(ORDER by VDate desc) 'SR', 
CONVERT(NVARCHAR(25),VDate,103) 'JV_DATE',FROMDATE,TODATE,TOTAL_CLIENTS,PENALTY_AMOUNT

FROM (    
SELECT  VDate,FROMDATE,TODATE,COUNT(Distinct A.CltCode) 'TOTAL_CLIENTS' ,SUM(A.CreditAmt) 'PENALTY_AMOUNT'    
FROM(    
SELECT DISTINCT --CONVERT(NVARCHAR(25),SMJOL.VDate,103) 'JV_DATE', 
SMJOL.VDate,
CONVERT(NVARCHAR(25),SMJOL.StartDate,103) 'FROMDATE'    
, CONVERT(NVARCHAR(25),SMJOL.EndDate,103) 'TODATE'
, SMJOL.CltCode, SMJOL.CreditAmt    
FROM ShortageMarginJV_OfflineLedger  SMJOL WITH(NOLOCK)      
WHERE SMJOL.VoucherType=8 AND SMJOL.AddBy='Remisier' AND SMJOL.IsUpdatetoLive=1 AND SMJOL.CltCode !='42000029'    
)A    
GROUP By A.VDate, A.FROMDATE, A.TODATE    
    
UNION    
    
SELECT  VDate,FROMDATE,TODATE,COUNT(Distinct A.CltCode) 'TOTAL_CLIENTS' ,SUM(A.CreditAmt) 'PENALTY_AMOUNT'    
FROM(    
SELECT DISTINCT --CONVERT(NVARCHAR(25),SMJOL.VDate,103) 'JV_DATE'
SMJOL.VDate
, CONVERT(NVARCHAR(25),SMJOL.StartDate,103) 'FROMDATE'    
, CONVERT(NVARCHAR(25),SMJOL.EndDate,103) 'TODATE', SMJOL.CltCode, SMJOL.CreditAmt    
FROM ShortageMarginJV_OfflineLedgerLogFile  SMJOL WITH(NOLOCK)     
WHERE SMJOL.VoucherType=8 AND SMJOL.AddBy='Remisier' AND SMJOL.IsUpdatetoLive=1 AND SMJOL.CltCode !='42000029'    
)A    
GROUP By A.VDate, A.FROMDATE, A.TODATE    
) TEMP    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GETSBLimitEnhencementSummaryReport
-- --------------------------------------------------
CREATE PROCEDURE USP_GETSBLimitEnhencementSummaryReport  
AS  
BEGIN  
SELECT TOP 5 CONVERT(NVARCHAR(50),EnhencementDate,103) 'EnhencementDate', SBCount, ClientCount, CAST(ISNULL(TotalLimit,0) as decimal(17,2)) 'TotalLimit'  
FROM SubBrokerLimitEnhencementSummaryReport WITH(NOLOCK)   
ORDER BY SBLimitEnhencementSummaryId desc    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDepositDetailsByLMS
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDepositDetailsByLMS        
@PanNo Varchar(20) ='' ,@IsSBProcess bit             
As        
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @Condition VARCHAR(MAX)=''  ,@Condition1 VARCHAR(MAX) =''           
IF(ISNULL(@PanNo,'') <>'')        
BEGIN        
SET @Condition = ' AND SBDPDLMS.SBPanNo = '''+@PanNo+''''        
END        
        
IF(@IsSBProcess=0)        
BEGIN        
SET @Condition1 = ' WHERE IsSBRejected IN(0,1,8)'        
END        
        
EXEC('        
SELECT DISTINCT SBDPDLMS.SBPanNo, ISNULL(SBCSBB.SBTag,''Not Available'') ''SBTag'',SBDPDLMS.SBName            
,SBDPDLMS.DepositRefId ''RefId'',LTRIM(RTRIM(SBDPDLMS.RefNo)) ''RefNo'',SBDPDLMS.Amount,SBDPDLMS.Remarks ''SBRemarks'','''' ''SBReason''        
,'''' ''Files'',SBDPDLMS.FileName, '''' ''BankingStatus'', '''' ''BankingRemarks''        
, CONVERT(VARCHAR(20),SBDPDLMS.CreatedOn,13) ''ProcessDate''        
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBDPDLMS WITH(NOLOCK)               
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)             
ON SBCSBB.PanNo = SBDPDLMS.SBPanNo  AND SBCSBB.branch NOT IN(''ITRADE'',''SMART'',''RFRL'')          
----AND ISNULL(SBCSBB.IsActive,'''') <>''InActive''       
WHERE ISNULL(DepositRefId,0) NOT IN(SELECT ISNULL(DepositRefId,0) FROM tbl_SBDepositVarificationAndProcessBySBTeam WITH(NOLOCK) '+@Condition1+')         
'+@Condition+'        
  ')             
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDepositDetailsByLMS_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDepositDetailsByLMS_06Nov2025        
@PanNo Varchar(20) ='' ,@IsSBProcess bit             
As        
BEGIN             
DECLARE @Condition VARCHAR(MAX)=''  ,@Condition1 VARCHAR(MAX) =''           
IF(ISNULL(@PanNo,'') <>'')        
BEGIN        
SET @Condition = ' AND SBDPDLMS.SBPanNo = '''+@PanNo+''''        
END        
        
IF(@IsSBProcess=0)        
BEGIN        
SET @Condition1 = ' WHERE IsSBRejected IN(0,1,8)'        
END        
        
EXEC('        
SELECT DISTINCT SBDPDLMS.SBPanNo, ISNULL(SBCSBB.SBTag,''Not Available'') ''SBTag'',SBDPDLMS.SBName            
,SBDPDLMS.DepositRefId ''RefId'',LTRIM(RTRIM(SBDPDLMS.RefNo)) ''RefNo'',SBDPDLMS.Amount,SBDPDLMS.Remarks ''SBRemarks'','''' ''SBReason''        
,'''' ''Files'',SBDPDLMS.FileName, '''' ''BankingStatus'', '''' ''BankingRemarks''        
, CONVERT(VARCHAR(20),SBDPDLMS.CreatedOn,13) ''ProcessDate''        
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBDPDLMS WITH(NOLOCK)               
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)             
ON SBCSBB.PanNo = SBDPDLMS.SBPanNo  AND SBCSBB.branch NOT IN(''ITRADE'',''SMART'',''RFRL'')          
----AND ISNULL(SBCSBB.IsActive,'''') <>''InActive''       
WHERE ISNULL(DepositRefId,0) NOT IN(SELECT ISNULL(DepositRefId,0) FROM tbl_SBDepositVarificationAndProcessBySBTeam WITH(NOLOCK) '+@Condition1+')         
'+@Condition+'        
  ')             
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDetailsForBankingProcess_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDetailsForBankingProcess_06Nov2025   
@SBTag VARCHAR(20) ='', @SBPanNo VARCHAR(15)=''  
AS  
BEGIN  
 SELECT SBCSBB.SBTAG,SBPDPD.SBPanNo, SBPDPD.SBName, SBPDPD.RefNo,Amount,  
 FileName,SBPDVSB.Remarks,SBPDVSB.RejectionReason,  CONVERT(VARCHAR(20),SBPDVSB.CreatedOn,13) 'ProcessDate'  
 FROM SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)   
 JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPD WITH(NOLOCK)  
 ON SBCSBB.PanNo = SBPDPD.SBPanNo  
 JOIN tbl_SBPayoutDetailsVarificationBySBTeam SBPDVSB WITH(NOLOCK)  
 ON SBPDPD.DepositRefId = SBPDVSB.DepositRefId AND SBPDVSB.SBPanNo = SBPDPD.SBPanNo  
 WHERE SBPDVSB.DepositVarificationId NOT IN(SELECT DepositVarificationId FROM tbl_SBPayoutDetailsBankingVarification WITH(NOLOCK) WHERE Remarks='Approve')  
END  

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDetailsForBankingProcess_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDetailsForBankingProcess   
@SBTag VARCHAR(20) ='', @SBPanNo VARCHAR(15)=''  
AS  
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

 SELECT SBCSBB.SBTAG,SBPDPD.SBPanNo, SBPDPD.SBName, SBPDPD.RefNo,Amount,  
 FileName,SBPDVSB.Remarks,SBPDVSB.RejectionReason,  CONVERT(VARCHAR(20),SBPDVSB.CreatedOn,13) 'ProcessDate'  
 FROM SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)   
 JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPD WITH(NOLOCK)  
 ON SBCSBB.PanNo = SBPDPD.SBPanNo  
 JOIN tbl_SBPayoutDetailsVarificationBySBTeam SBPDVSB WITH(NOLOCK)  
 ON SBPDPD.DepositRefId = SBPDVSB.DepositRefId AND SBPDVSB.SBPanNo = SBPDPD.SBPanNo  
 WHERE SBPDVSB.DepositVarificationId NOT IN(SELECT DepositVarificationId FROM tbl_SBPayoutDetailsBankingVarification WITH(NOLOCK) WHERE Remarks='Approve')  
END  

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDetailsForVarification
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDetailsForVarification            
@FromDate VARCHAR(15)='', @ToDate VARCHAR(15)=''                             
AS                      
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

DECLARE @Condition VARCHAR(MAX)=''          
          
IF(ISNULL(@FromDate,'')<>'')          
BEGIN          
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)          
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)          
SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) Between '''+@FromDate+''' AND '''+@ToDate+''' '         
----SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) >= CAST(GETDATE()-12 as date) '         
          
END      
ELSE     
BEGIN    
SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) >= CAST(GETDATE()-60 as date) '         
END    
        
EXEC('          
SELECT ISNULL(SBCSBB.SBTAG,''Not Available'')  ''SBTAG'', SBPDPD.SBName ''SBName'',SBPDPD.SBPanNo ''PanNo'',SBPDPD.DepositRefId ''RefId''                            
,LTRIM(RTRIM(SBPDPD.RefNo)) RefNo,SBPDPD.Amount,SBPDPD.Remarks ''LMSRemarks'',0x Files,FileName ,                
SBPDPD.IsSBRejected ''IsRejectedStatus'',                
CASE WHEN ISNULL(SBPDPD.IsSBRejected,0) =0 AND ISNULL(SBPDPD.IsBankingRejected,0)=0 THEN ''''                       
WHEN ISNULL(SBPDPD.IsSBRejected,0) in(1,8) AND ISNULL(SBPDPD.IsBankingRejected,0)IN(0,2) THEN ''SB Team Rejected''                      
WHEN ISNULL(SBPDPD.IsSBRejected,0) IN(0,2) AND ISNULL(SBPDPD.IsBankingRejected,0)=1 THEN ''Banking Team Rejected''                      
END ''Status''                       
, CASE WHEN ISNULL(SBPDPD.IsSBRejected,0)=0 AND ISNULL(SBPDPD.IsBankingRejected,0)=0           
THEN CASE WHEN SBDBVP.IsJVProcess=1 THEN ''Done'' ELSE ''InProcess''END                     
WHEN ISNULL(SBPDPD.IsSBRejected,0) In(1,8) AND ISNULL(SBPDPD.IsBankingRejected,0) IN(0,2) THEN SBPDPD.SBRejectionReason                      
WHEN ISNULL(SBPDPD.IsSBRejected,0) IN(0,2) AND ISNULL(SBPDPD.IsBankingRejected,0)=1 THEN SBPDPD.BankingRejectionReason                      
END  ''Remarks''    ,          
CONVERT(VARCHAR(10),SBPDPD.CreatedOn,103) ''LMSProcessDate''          
                            
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPD WITH(NOLOCK)                            
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)                       
ON SBCSBB.PanNo = SBPDPD.SBPanNo AND SBCSBB.branch NOT IN(''ITRADE'',''SMART'',''RFRL'')          
LEFT JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)            
ON SBDVPS.DepositRefId = SBPDPD.DepositRefId          
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)          
ON SBDBVP.DepositVarificationId = SBDVPS.DepositVarificationId          
---AND  SBCSBB.TradeName = SBPDPD.SBName                        
'+@Condition+'          
')                      
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBPayoutDetailsForVarification_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSBPayoutDetailsForVarification_06Nov2025            
@FromDate VARCHAR(15)='', @ToDate VARCHAR(15)=''                             
AS                      
BEGIN           
DECLARE @Condition VARCHAR(MAX)=''          
          
IF(ISNULL(@FromDate,'')<>'')          
BEGIN          
SET @FromDate = CAST(CONVERT(datetime,@FromDate,103) as date)          
SET @ToDate = CAST(CONVERT(datetime,@ToDate,103) as date)          
SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) Between '''+@FromDate+''' AND '''+@ToDate+''' '         
----SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) >= CAST(GETDATE()-12 as date) '         
          
END      
ELSE     
BEGIN    
SET @Condition = ' WHERE CAST(SBPDPD.CreatedOn as date) >= CAST(GETDATE()-60 as date) '         
END    
        
EXEC('          
SELECT ISNULL(SBCSBB.SBTAG,''Not Available'')  ''SBTAG'', SBPDPD.SBName ''SBName'',SBPDPD.SBPanNo ''PanNo'',SBPDPD.DepositRefId ''RefId''                            
,LTRIM(RTRIM(SBPDPD.RefNo)) RefNo,SBPDPD.Amount,SBPDPD.Remarks ''LMSRemarks'',0x Files,FileName ,                
SBPDPD.IsSBRejected ''IsRejectedStatus'',                
CASE WHEN ISNULL(SBPDPD.IsSBRejected,0) =0 AND ISNULL(SBPDPD.IsBankingRejected,0)=0 THEN ''''                       
WHEN ISNULL(SBPDPD.IsSBRejected,0) in(1,8) AND ISNULL(SBPDPD.IsBankingRejected,0)IN(0,2) THEN ''SB Team Rejected''                      
WHEN ISNULL(SBPDPD.IsSBRejected,0) IN(0,2) AND ISNULL(SBPDPD.IsBankingRejected,0)=1 THEN ''Banking Team Rejected''                      
END ''Status''                       
, CASE WHEN ISNULL(SBPDPD.IsSBRejected,0)=0 AND ISNULL(SBPDPD.IsBankingRejected,0)=0           
THEN CASE WHEN SBDBVP.IsJVProcess=1 THEN ''Done'' ELSE ''InProcess''END                     
WHEN ISNULL(SBPDPD.IsSBRejected,0) In(1,8) AND ISNULL(SBPDPD.IsBankingRejected,0) IN(0,2) THEN SBPDPD.SBRejectionReason                      
WHEN ISNULL(SBPDPD.IsSBRejected,0) IN(0,2) AND ISNULL(SBPDPD.IsBankingRejected,0)=1 THEN SBPDPD.BankingRejectionReason                      
END  ''Remarks''    ,          
CONVERT(VARCHAR(10),SBPDPD.CreatedOn,103) ''LMSProcessDate''          
                            
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBPDPD WITH(NOLOCK)                            
LEFT JOIN SB_COMP.dbo.SB_broker SBCSBB WITH(NOLOCK)                       
ON SBCSBB.PanNo = SBPDPD.SBPanNo AND SBCSBB.branch NOT IN(''ITRADE'',''SMART'',''RFRL'')          
LEFT JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)            
ON SBDVPS.DepositRefId = SBPDPD.DepositRefId          
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)          
ON SBDBVP.DepositVarificationId = SBDVPS.DepositVarificationId          
---AND  SBCSBB.TradeName = SBPDPD.SBName                        
'+@Condition+'          
')                      
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBRegisterdSegmentDetailsForChangesAddress_06Nov2025
-- --------------------------------------------------
    
CREATE PROCEDURE USP_GetSBRegisterdSegmentDetailsForChangesAddress_06Nov2025    
AS    
BEGIN    
  
  
SELECT DISTINCT SBTAG, [BR] as BRAddress, ALT as AltAddress, TER as TerAddress ,  
City,CrtDt INTO #LatestSBDetails   
FROM (   
SELECT *  FROM (  
SELECT SBTag,AddType,  
AddLine1 +','+AddLine2 +','+Landmark+','+City +','+State+'-'+PinCode 'Address'  
,City,   
CONVERT(VARCHAR(11),CrtDt,113) 'CrtDt'   
            FROM [SB_COMP].[dbo].SB_ChangeAddress_Contact WITH(NOLOCK)  
   WHERE Current_Status='VERIFIED' AND CAST(CrtDt as date) >='2022-12-20'  
   --AND SBTAG in('BHKS')   
  )AA  
        ) AS P  
        PIVOT   
        (   MAX(Address)   
            FOR addtype in ([BR],[ALT],[TER])  
        ) AS  PVT  
    
    
--------------------    
         
  
  SELECT  ISNULL(SBTAG,'') 'SBTAG',ISNULL(BranchTag,'') 'BranchTag',ISNULL(SBName,'') 'SBName'  
  ,ISNULL(TradeName,'') 'TradeName',ISNULL(PanNo,'') 'PanNo',TAGGeneratedDate,  
  ISNULL(Status,'') 'Status',ISNULL(StatusDate,'') 'StatusDate',  
  ISNULL([OFF],'') as OfficeAddress, ISNULL(RES,'') as ResAddress, ISNULL(TER,'') as TerAddress ,  
  ISNULL(Latest_AltAddress,'') 'Latest_AltAddress',ISNULL(Latest_BRAddress,'') 'Latest_BRAddress'  
  ,ISNULL(Latest_TerAddress,'') 'Latest_TerAddress'  
  ,ISNULL(Latest_City,'') 'Latest_City',ISNULL(Latest_CrtDt,'') 'Latest_CrtDt',   
  ISNULL(Segment,'') 'Segment',ISNULL(Regstatus,'') 'Regstatus'  
  ,ISNULL(RegNo,'') 'RegNo',ISNULL(Regdate,'') 'Regdate',  
  CASE   
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(Latest_TerAddress,'')  
  WHEN ISNULL(Latest_TerAddress,'')='' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(Latest_AltAddress,'')  
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')='' THEN ISNULL(Latest_TerAddress,'')  
  ELSE ISNULL(Latest_AltAddress,'')  
  END 'LatestAddress',  
  CASE   
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(RES,'')  
  WHEN ISNULL(Latest_TerAddress,'')='' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(RES,'')  
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')='' THEN ISNULL(RES,'')  
  ELSE ISNULL([OFF],'') END 'OldAddress'--,EmailId  
  
FROM    (   
SELECT * FROM (  
SELECT DISTINCT SBCT.addtype,   
 ISNULL(SBB.SBTAG,'') AS SBTAG,      
        SBB.Branch AS 'BranchTag' ,         
      
  ISNULL(SBB.TRADENAME,'') 'SBName' ,        
  ISNULL(SBB.TRADENAME,'') AS TradeName,       
      
  ISNULL(SBB.Panno,'') as PanNo  ,      
  CONVERT(VARCHAR(10),SBB.TAGGeneratedDate,103) 'TAGGeneratedDate',      
  ISNULL(SBB.IsActive,'') 'Status',    
  CONVERT(VARCHAR(10),SBB.IsActiveDate,103) 'StatusDate',  
SBCT.AddLine1 +' '+ SBCT.AddLine2 +' '+ SBCT.Landmark +'-'+ SBCT.City +'-'+ SBCT.State +'-'+ SBCT.Country     
    'Address'   ,  
 LSBD.AltAddress 'Latest_AltAddress' , LSBD.BRAddress 'Latest_BRAddress'  
 ,LSBD.TerAddress 'Latest_TerAddress',LSBD.City 'Latest_City', LSBD.CrtDt 'Latest_CrtDt',  
 Segment=CASE LEFT(regexchangesegment,1)+RIGHT(regexchangesegment,2)      
when  'BCR' then 'BSERemisier'      
when  'BCS' then 'BSECash'        
when  'BFA' then 'BSEFO'      
when  'NCS' then 'NSECash'      
when  'NFA' then 'NSEFO'     
when  'MCX' then 'MCX'       
when  'NMF' then 'MCXCDS'       
when  'NCX' then 'NCX'          
when  'NCF' then 'NSX'         
        when  'BSX' then 'BSX' End,        
        
        bpapp.[Appstatus] AS Regstatus ,  
  bpreg.RegNo,  
  CONVERT(VARCHAR(11),Regdate,113) 'Regdate'--,SBCT.EmailId  
    
     
   FROM [SB_COMP].[dbo].[bpregMaster] bpreg WITH(NOLOCK)      
  JOIN [SB_COMP].[dbo].bpapplication bpapp WITH(NOLOCK)      
  on bpreg.RegAprRefNo = bpapp.AppRefNo AND       
        bpreg.[regexchangesegment]=bpapp.est    
  JOIN [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)    
   ON bpreg.RegAprRefNo = SBB.REFNO    
  JOIN [SB_COMP].[dbo].SB_CONTACT SBCT WITH(NOLOCK)     
  ON SBCT.RefNo = SBB.RefNo   
  JOIN [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCAC WITH(NOLOCK)      
  ON SBCAC.SBTAG = SBB.SBTAG    
  JOIN #LatestSBDetails LSBD  
  ON SBB.SBTAG = LSBD.SBTag  
  WHERE SBB.sbtag <> 'T A G'  AND SBCT.addtype IN('RES','OFF','TER')      
  AND SBCAC.Current_Status='VERIFIED'  AND bpapp.[Appstatus]='Registered'   
  --AND SBB.SBTAG in('BHKS')   
  )AA  
        ) AS P  
        PIVOT   
        (   MAX(Address)   
            FOR addtype in ([OFF],[RES],[TER])  
        ) AS  PVT  
  
       ORDER BY SBTAG         
END    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBRegisterdSegmentDetailsForChangesAddress_tobedeleted09jan2026
-- --------------------------------------------------
    
CREATE PROCEDURE USP_GetSBRegisterdSegmentDetailsForChangesAddress    
AS    
BEGIN    
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())  
  
SELECT DISTINCT SBTAG, [BR] as BRAddress, ALT as AltAddress, TER as TerAddress ,  
City,CrtDt INTO #LatestSBDetails   
FROM (   
SELECT *  FROM (  
SELECT SBTag,AddType,  
AddLine1 +','+AddLine2 +','+Landmark+','+City +','+State+'-'+PinCode 'Address'  
,City,   
CONVERT(VARCHAR(11),CrtDt,113) 'CrtDt'   
            FROM [SB_COMP].[dbo].SB_ChangeAddress_Contact WITH(NOLOCK)  
   WHERE Current_Status='VERIFIED' AND CAST(CrtDt as date) >='2022-12-20'  
   --AND SBTAG in('BHKS')   
  )AA  
        ) AS P  
        PIVOT   
        (   MAX(Address)   
            FOR addtype in ([BR],[ALT],[TER])  
        ) AS  PVT  
    
    
--------------------    
         
  
  SELECT  ISNULL(SBTAG,'') 'SBTAG',ISNULL(BranchTag,'') 'BranchTag',ISNULL(SBName,'') 'SBName'  
  ,ISNULL(TradeName,'') 'TradeName',ISNULL(PanNo,'') 'PanNo',TAGGeneratedDate,  
  ISNULL(Status,'') 'Status',ISNULL(StatusDate,'') 'StatusDate',  
  ISNULL([OFF],'') as OfficeAddress, ISNULL(RES,'') as ResAddress, ISNULL(TER,'') as TerAddress ,  
  ISNULL(Latest_AltAddress,'') 'Latest_AltAddress',ISNULL(Latest_BRAddress,'') 'Latest_BRAddress'  
  ,ISNULL(Latest_TerAddress,'') 'Latest_TerAddress'  
  ,ISNULL(Latest_City,'') 'Latest_City',ISNULL(Latest_CrtDt,'') 'Latest_CrtDt',   
  ISNULL(Segment,'') 'Segment',ISNULL(Regstatus,'') 'Regstatus'  
  ,ISNULL(RegNo,'') 'RegNo',ISNULL(Regdate,'') 'Regdate',  
  CASE   
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(Latest_TerAddress,'')  
  WHEN ISNULL(Latest_TerAddress,'')='' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(Latest_AltAddress,'')  
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')='' THEN ISNULL(Latest_TerAddress,'')  
  ELSE ISNULL(Latest_AltAddress,'')  
  END 'LatestAddress',  
  CASE   
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(RES,'')  
  WHEN ISNULL(Latest_TerAddress,'')='' AND ISNULL(Latest_AltAddress,'')<>'' THEN ISNULL(RES,'')  
  WHEN ISNULL(Latest_TerAddress,'')<>'' AND ISNULL(Latest_AltAddress,'')='' THEN ISNULL(RES,'')  
  ELSE ISNULL([OFF],'') END 'OldAddress'--,EmailId  
  
FROM    (   
SELECT * FROM (  
SELECT DISTINCT SBCT.addtype,   
 ISNULL(SBB.SBTAG,'') AS SBTAG,      
        SBB.Branch AS 'BranchTag' ,         
      
  ISNULL(SBB.TRADENAME,'') 'SBName' ,        
  ISNULL(SBB.TRADENAME,'') AS TradeName,       
      
  ISNULL(SBB.Panno,'') as PanNo  ,      
  CONVERT(VARCHAR(10),SBB.TAGGeneratedDate,103) 'TAGGeneratedDate',      
  ISNULL(SBB.IsActive,'') 'Status',    
  CONVERT(VARCHAR(10),SBB.IsActiveDate,103) 'StatusDate',  
SBCT.AddLine1 +' '+ SBCT.AddLine2 +' '+ SBCT.Landmark +'-'+ SBCT.City +'-'+ SBCT.State +'-'+ SBCT.Country     
    'Address'   ,  
 LSBD.AltAddress 'Latest_AltAddress' , LSBD.BRAddress 'Latest_BRAddress'  
 ,LSBD.TerAddress 'Latest_TerAddress',LSBD.City 'Latest_City', LSBD.CrtDt 'Latest_CrtDt',  
 Segment=CASE LEFT(regexchangesegment,1)+RIGHT(regexchangesegment,2)      
when  'BCR' then 'BSERemisier'      
when  'BCS' then 'BSECash'        
when  'BFA' then 'BSEFO'      
when  'NCS' then 'NSECash'      
when  'NFA' then 'NSEFO'     
when  'MCX' then 'MCX'       
when  'NMF' then 'MCXCDS'       
when  'NCX' then 'NCX'          
when  'NCF' then 'NSX'         
        when  'BSX' then 'BSX' End,        
        
        bpapp.[Appstatus] AS Regstatus ,  
  bpreg.RegNo,  
  CONVERT(VARCHAR(11),Regdate,113) 'Regdate'--,SBCT.EmailId  
    
     
   FROM [SB_COMP].[dbo].[bpregMaster] bpreg WITH(NOLOCK)      
  JOIN [SB_COMP].[dbo].bpapplication bpapp WITH(NOLOCK)      
  on bpreg.RegAprRefNo = bpapp.AppRefNo AND       
        bpreg.[regexchangesegment]=bpapp.est    
  JOIN [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)    
   ON bpreg.RegAprRefNo = SBB.REFNO    
  JOIN [SB_COMP].[dbo].SB_CONTACT SBCT WITH(NOLOCK)     
  ON SBCT.RefNo = SBB.RefNo   
  JOIN [SB_COMP].[dbo].SB_ChangeAddress_Contact SBCAC WITH(NOLOCK)      
  ON SBCAC.SBTAG = SBB.SBTAG    
  JOIN #LatestSBDetails LSBD  
  ON SBB.SBTAG = LSBD.SBTag  
  WHERE SBB.sbtag <> 'T A G'  AND SBCT.addtype IN('RES','OFF','TER')      
  AND SBCAC.Current_Status='VERIFIED'  AND bpapp.[Appstatus]='Registered'   
  --AND SBB.SBTAG in('BHKS')   
  )AA  
        ) AS P  
        PIVOT   
        (   MAX(Address)   
            FOR addtype in ([OFF],[RES],[TER])  
        ) AS  PVT  
  
       ORDER BY SBTAG         
END    

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBsegmentDetailsForAddressVerification_06Nov2025
-- --------------------------------------------------
     
CREATE PROCEDURE USP_GetSBsegmentDetailsForAddressVerification_06Nov2025      
@SBTag VARCHAR(15)=''      
AS      
BEGIN      
      
SELECT * INTO #SegmentDetails FROM (        
SELECT DISTINCT         
 ISNULL(SBB.SBTAG,'') AS SBTAG,             
 Segment=CASE LEFT(regexchangesegment,1)+RIGHT(regexchangesegment,2)            
when  'BCR' then 'BSERemisier'            
when  'BCS' then 'BSE'              
when  'BFA' then 'BSEFO'            
when  'NCS' then 'NSE'            
when  'NFA' then 'NSEFO'           
when  'MCX' then 'MCX'             
when  'NMF' then 'MCXCDS'             
when  'NCX' then 'NCX'                
when  'NCF' then 'NSX'               
        when  'BSX' then 'BSX' End              
   FROM [SB_COMP].[dbo].[bpregMaster] bpreg WITH(NOLOCK)            
  JOIN [SB_COMP].[dbo].bpapplication bpapp WITH(NOLOCK)            
  on bpreg.RegAprRefNo = bpapp.AppRefNo AND             
        bpreg.[regexchangesegment]=bpapp.est          
  JOIN [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)          
   ON bpreg.RegAprRefNo = SBB.REFNO         
   JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
   ON SBB.SBTAG = SBACPD.SBTAG      
  WHERE SBB.sbtag <> 'T A G' AND SBACPD.SBTag = @SBTag     
   AND bpapp.[Appstatus]='Registered'        
  )A      
      
  ----      
      
SELECT BB.SBTag,BB.SBPanNo,      
CASE WHEN CAST(BB.ProcessDate as date)='1900-01-01' THEN ''      
ELSE CONVERT(VARCHAR(11),BB.ProcessDate,113) END 'VerificationProcessDate'   ,  
BB.Remarks  
, BB.Segment,BB.IsSegmentVerified FROM (      
SELECT * FROM (    
SELECT DISTINCT SBTag,SBPanNo,Segment,IsSegmentVerified,ProcessDate,Remarks,    
 SegmentDetails = replace(Segment1,'VerificationDate','')  ,  
 processRemarks = replace(Segment2,'Status','')    
FROM(      
SELECT SBTag,SBPanNo,ISNULL(VerifiedBy,'') 'VerifiedBy',      
ISNULL([IsNSEVerified],'') 'NSE',ISNULL([IsBSEVerified],'') 'BSE',ISNULL([IsNSEFOVerified],'') 'NSEFO'      
,ISNULL([IsBSEFOVerified],'') 'BSEFO',ISNULL([IsNSXVerified],'') 'NSX',ISNULL([IsBSXVerified],'') 'BSX'      
,ISNULL([IsMCXVerified],'') 'MCX',ISNULL([IsNCXVerified],'') 'NCX'  ,    
    
ISNULL([NSEVerificationDate],'') [NSEVerificationDate] ,ISNULL([BSEVerificationDate],'') [BSEVerificationDate]  
,ISNULL([NSEFOVerificationDate],'')  [NSEFOVerificationDate]   
,ISNULL([BSEFOVerificationDate],'') [BSEFOVerificationDate]  ,ISNULL([NSXVerificationDate],'') [NSXVerificationDate]  
,ISNULL([BSXVerificationDate],'') [BSXVerificationDate]     
,ISNULL([MCXVerificationDate],'') [MCXVerificationDate],ISNULL([NCXVerificationDate],'') [NCXVerificationDate],  
  
ISNULL([BSEStatus],'') [BSEStatus], ISNULL([NSEStatus],'') [NSEStatus],ISNULL([NSEFOStatus],'') [NSEFOStatus]  
,ISNULL([BSEFOStatus],'') [BSEFOStatus],ISNULL([NSXStatus],'') [NSXStatus],  
ISNULL([BSXStatus],'') [BSXStatus],ISNULL([MCXStatus],'') [MCXStatus],ISNULL([NCXStatus],'') [NCXStatus]  
    
FROM tbl_SBAddressChangeProcessDetails WITH(NOLOCK)      
WHERE SBTag = @SBTag    
)P      
UNPIVOT      
(IsSegmentVerified For Segment IN(      
[NSE],[BSE],[NSEFO],[BSEFO],[NSX],[BSX]      
,[MCX],[NCX]      
))As UnPVT     
UNPIVOT      
(ProcessDate For Segment1 IN(      
[NSEVerificationDate] ,[BSEVerificationDate] ,[NSEFOVerificationDate]     
,[BSEFOVerificationDate] ,[NSXVerificationDate] ,[BSXVerificationDate]      
,[MCXVerificationDate] ,[NCXVerificationDate]      
))As UnPVT      
 UNPIVOT      
(Remarks For Segment2 IN(      
[BSEStatus] ,[NSEStatus] ,[NSEFOStatus]     
,[BSEFOStatus] ,[NSXStatus] ,[BSXStatus]      
,[MCXStatus] ,[NCXStatus]      
))As UnPVT    
  
)AA      
WHERE SegmentDetails=Segment AND processRemarks = Segment)BB    
JOIN #SegmentDetails SD       
ON BB.SBTag = SD.SBTAG AND BB.Segment= SD.Segment      
      
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBsegmentDetailsForAddressVerification_tobedeleted09jan2026
-- --------------------------------------------------
     
CREATE PROCEDURE USP_GetSBsegmentDetailsForAddressVerification      
@SBTag VARCHAR(15)=''      
AS      
BEGIN 
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

      
SELECT * INTO #SegmentDetails FROM (        
SELECT DISTINCT         
 ISNULL(SBB.SBTAG,'') AS SBTAG,             
 Segment=CASE LEFT(regexchangesegment,1)+RIGHT(regexchangesegment,2)            
when  'BCR' then 'BSERemisier'            
when  'BCS' then 'BSE'              
when  'BFA' then 'BSEFO'            
when  'NCS' then 'NSE'            
when  'NFA' then 'NSEFO'           
when  'MCX' then 'MCX'             
when  'NMF' then 'MCXCDS'             
when  'NCX' then 'NCX'                
when  'NCF' then 'NSX'               
        when  'BSX' then 'BSX' End              
   FROM [SB_COMP].[dbo].[bpregMaster] bpreg WITH(NOLOCK)            
  JOIN [SB_COMP].[dbo].bpapplication bpapp WITH(NOLOCK)            
  on bpreg.RegAprRefNo = bpapp.AppRefNo AND             
        bpreg.[regexchangesegment]=bpapp.est          
  JOIN [SB_COMP].[dbo].SB_broker SBB WITH(NOLOCK)          
   ON bpreg.RegAprRefNo = SBB.REFNO         
   JOIN tbl_SBAddressChangeProcessDetails SBACPD WITH(NOLOCK)      
   ON SBB.SBTAG = SBACPD.SBTAG      
  WHERE SBB.sbtag <> 'T A G' AND SBACPD.SBTag = @SBTag     
   AND bpapp.[Appstatus]='Registered'        
  )A      
      
  ----      
      
SELECT BB.SBTag,BB.SBPanNo,      
CASE WHEN CAST(BB.ProcessDate as date)='1900-01-01' THEN ''      
ELSE CONVERT(VARCHAR(11),BB.ProcessDate,113) END 'VerificationProcessDate'   ,  
BB.Remarks  
, BB.Segment,BB.IsSegmentVerified FROM (      
SELECT * FROM (    
SELECT DISTINCT SBTag,SBPanNo,Segment,IsSegmentVerified,ProcessDate,Remarks,    
 SegmentDetails = replace(Segment1,'VerificationDate','')  ,  
 processRemarks = replace(Segment2,'Status','')    
FROM(      
SELECT SBTag,SBPanNo,ISNULL(VerifiedBy,'') 'VerifiedBy',      
ISNULL([IsNSEVerified],'') 'NSE',ISNULL([IsBSEVerified],'') 'BSE',ISNULL([IsNSEFOVerified],'') 'NSEFO'      
,ISNULL([IsBSEFOVerified],'') 'BSEFO',ISNULL([IsNSXVerified],'') 'NSX',ISNULL([IsBSXVerified],'') 'BSX'      
,ISNULL([IsMCXVerified],'') 'MCX',ISNULL([IsNCXVerified],'') 'NCX'  ,    
    
ISNULL([NSEVerificationDate],'') [NSEVerificationDate] ,ISNULL([BSEVerificationDate],'') [BSEVerificationDate]  
,ISNULL([NSEFOVerificationDate],'')  [NSEFOVerificationDate]   
,ISNULL([BSEFOVerificationDate],'') [BSEFOVerificationDate]  ,ISNULL([NSXVerificationDate],'') [NSXVerificationDate]  
,ISNULL([BSXVerificationDate],'') [BSXVerificationDate]     
,ISNULL([MCXVerificationDate],'') [MCXVerificationDate],ISNULL([NCXVerificationDate],'') [NCXVerificationDate],  
  
ISNULL([BSEStatus],'') [BSEStatus], ISNULL([NSEStatus],'') [NSEStatus],ISNULL([NSEFOStatus],'') [NSEFOStatus]  
,ISNULL([BSEFOStatus],'') [BSEFOStatus],ISNULL([NSXStatus],'') [NSXStatus],  
ISNULL([BSXStatus],'') [BSXStatus],ISNULL([MCXStatus],'') [MCXStatus],ISNULL([NCXStatus],'') [NCXStatus]  
    
FROM tbl_SBAddressChangeProcessDetails WITH(NOLOCK)      
WHERE SBTag = @SBTag    
)P      
UNPIVOT      
(IsSegmentVerified For Segment IN(      
[NSE],[BSE],[NSEFO],[BSEFO],[NSX],[BSX]      
,[MCX],[NCX]      
))As UnPVT     
UNPIVOT      
(ProcessDate For Segment1 IN(      
[NSEVerificationDate] ,[BSEVerificationDate] ,[NSEFOVerificationDate]     
,[BSEFOVerificationDate] ,[NSXVerificationDate] ,[BSXVerificationDate]      
,[MCXVerificationDate] ,[NCXVerificationDate]      
))As UnPVT      
 UNPIVOT      
(Remarks For Segment2 IN(      
[BSEStatus] ,[NSEStatus] ,[NSEFOStatus]     
,[BSEFOStatus] ,[NSXStatus] ,[BSXStatus]      
,[MCXStatus] ,[NCXStatus]      
))As UnPVT    
  
)AA      
WHERE SegmentDetails=Segment AND processRemarks = Segment)BB    
JOIN #SegmentDetails SD       
ON BB.SBTag = SD.SBTAG AND BB.Segment= SD.Segment      
      
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSBTagGenerationRM_Dashboard
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSBTagGenerationRM_Dashboard   
@year VARCHAR(5)='',@month VARCHAR(10)='',@Zone VARCHAR(15)='',@IsMonthlyProcess bit=0  
AS  
BEGIN  
  
IF(@IsMonthlyProcess=1)  
BEGIN  
  
SELECT DISTINCT ProcessYear,ProcessMonth,Zone,ProcessDate,'' 'Branch'  
,SUM(RequestAdded) 'RequestAdded',  
SUM(IncompleteEntries) 'IncompleteEntries',  
  
SUM(PLVC_Pending) 'PLVC_Pending', SUM(PLVC_Rejected) 'PLVC_Rejected',  
SUM(PLVC_Approved) 'PLVC_Approved',
SUM(SB_Pending) 'SB_Pending', SUM(SB_Rejected) 'SB_Rejected', SUM(TagGenerated) 'TagGenerated',  
SUM(Doc_PendingForSubmission) 'Doc_PendingForSubmission'  
FROM (  
SELECT  YEAR(IMGD.ProcessDate) 'ProcessYear',DateName(month,IMGD.ProcessDate) 'ProcessMonth',  
CONVERT(VARCHAR(11),IMGD.ProcessDate,113) 'ProcessDate',  
CASE WHEN ISNULL(IMGD.Zone,'')<>'' THEN IMGD.Zone ELSE '' END 'Zone',  
CASE WHEN ISNULL(IMGD.PanNo,'')<>'' THEN 1 ELSE 0 END 'RequestAdded',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=0 THEN 1 ELSE 0 END 'IncompleteEntries',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.IsApproved,0) =0 THEN 1 ELSE 0 END 'PLVC_Pending',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Reject' THEN 1 ELSE 0 END 'PLVC_Rejected',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Approve' 
AND ISNULL(IMPLVCP.IsApproved,0) = 1 THEN 1 ELSE 0 END 'PLVC_Approved',
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.IsApproved,0)=0 THEN 1   
ELSE 0 END 'SB_Pending',  
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.ProcessStatus,'')='Reject' THEN 1   
ELSE 0 END 'SB_Rejected',  
CASE WHEN ISNULL(ISBVM.IsApproved,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>'' THEN 1  
ELSE 0 END 'TagGenerated',  
CASE WHEN (ISNULL(ISBTGUD.IsPanCardUpload,0)=0 OR ISNULL(ISBTGUD.IsAadharCardUpload,0)=0 OR   
ISNULL(ISBTGUD.IsAddressDetailsUpload,0)=0 OR ISNULL(ISBTGUD.IsEducationDetailsUpload,0)=0 OR  
ISNULL(ISBTGUD.IsNSESegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsBSESegmentDocUpload,0)=0 OR  
ISNULL(ISBTGUD.IsMCXSegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsNCDEXSegmentDocUpload,0)=0 OR   
ISNULL(ISBTGUD.IsTagsheet_MOUDocUpload,0)=0) AND ISNULL(IMGD.PanNo,'')<>''   
AND ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>''  
THEN 1 ELSE 0 END 'Doc_PendingForSubmission'  
  
FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)  
LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUD WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGUD.IntermediaryId  
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM  WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGM.IntermediaryId  
LEFT JOIN tbl_IntermediarySBVerificationMaster ISBVM WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBVM.IntermediaryId  
LEFT JOIN tbl_IntermediaryMasterPLVCProcess IMPLVCP WITH(NOLOCK)  
ON IMGD.IntermediaryId = IMPLVCP.IntermediaryId  
  
)AA  
WHERE ProcessYear = @year AND ProcessMonth = @month AND Zone=@Zone  
GROUP BY ProcessYear,ProcessMonth,Zone,ProcessDate  
  
END  
ELSE  
BEGIN  
IF(ISNULL(@month,'')<>'')  
BEGIN  
  
SELECT DISTINCT ProcessYear,ProcessMonth,Zone,'' 'ProcessDate', '' 'Branch'  
,SUM(RequestAdded) 'RequestAdded',  
SUM(IncompleteEntries) 'IncompleteEntries',  
  
SUM(PLVC_Pending) 'PLVC_Pending', SUM(PLVC_Rejected) 'PLVC_Rejected', 
SUM(PLVC_Approved) 'PLVC_Approved',
SUM(SB_Pending) 'SB_Pending', SUM(SB_Rejected) 'SB_Rejected', SUM(TagGenerated) 'TagGenerated',  
SUM(Doc_PendingForSubmission) 'Doc_PendingForSubmission'  
FROM (  
SELECT  YEAR(IMGD.ProcessDate) 'ProcessYear',DateName(month,IMGD.ProcessDate) 'ProcessMonth',  
CASE WHEN ISNULL(IMGD.Zone,'')<>'' THEN IMGD.Zone ELSE '' END 'Zone',  
CASE WHEN ISNULL(IMGD.PanNo,'')<>'' THEN 1 ELSE 0 END 'RequestAdded',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=0 THEN 1 ELSE 0 END 'IncompleteEntries',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.IsApproved,0) =0 THEN 1 ELSE 0 END 'PLVC_Pending',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Reject' THEN 1 ELSE 0 END 'PLVC_Rejected',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Approve' 
AND ISNULL(IMPLVCP.IsApproved,0) = 1 THEN 1 ELSE 0 END 'PLVC_Approved',
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.IsApproved,0)=0 THEN 1   
ELSE 0 END 'SB_Pending',  
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.ProcessStatus,'')='Reject' THEN 1   
ELSE 0 END 'SB_Rejected',  
CASE WHEN ISNULL(ISBVM.IsApproved,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>'' THEN 1  
ELSE 0 END 'TagGenerated',  
CASE WHEN (ISNULL(ISBTGUD.IsPanCardUpload,0)=0 OR ISNULL(ISBTGUD.IsAadharCardUpload,0)=0 OR   
ISNULL(ISBTGUD.IsAddressDetailsUpload,0)=0 OR ISNULL(ISBTGUD.IsEducationDetailsUpload,0)=0 OR  
ISNULL(ISBTGUD.IsNSESegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsBSESegmentDocUpload,0)=0 OR  
ISNULL(ISBTGUD.IsMCXSegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsNCDEXSegmentDocUpload,0)=0 OR   
ISNULL(ISBTGUD.IsTagsheet_MOUDocUpload,0)=0) AND ISNULL(IMGD.PanNo,'')<>''   
AND ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>''  
THEN 1 ELSE 0 END 'Doc_PendingForSubmission'  
  
FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)  
LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUD WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGUD.IntermediaryId  
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM  WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGM.IntermediaryId  
LEFT JOIN tbl_IntermediarySBVerificationMaster ISBVM WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBVM.IntermediaryId  
LEFT JOIN tbl_IntermediaryMasterPLVCProcess IMPLVCP WITH(NOLOCK)  
ON IMGD.IntermediaryId = IMPLVCP.IntermediaryId  
  
)AA  
WHERE ProcessYear = @year AND ProcessMonth = @month  
GROUP BY ProcessYear,ProcessMonth,Zone  
  
END  
ELSE  
BEGIN  
SELECT DISTINCT ProcessYear,ProcessMonth,'' 'Zone', '' 'ProcessDate', '' 'Branch'  
,SUM(RequestAdded) 'RequestAdded',  
SUM(IncompleteEntries) 'IncompleteEntries',  
  
SUM(PLVC_Pending) 'PLVC_Pending', SUM(PLVC_Rejected) 'PLVC_Rejected',  
SUM(PLVC_Approved) 'PLVC_Approved',
SUM(SB_Pending) 'SB_Pending', SUM(SB_Rejected) 'SB_Rejected', SUM(TagGenerated) 'TagGenerated',  
SUM(Doc_PendingForSubmission) 'Doc_PendingForSubmission'  
FROM (  
SELECT  YEAR(IMGD.ProcessDate) 'ProcessYear',DateName(month,IMGD.ProcessDate) 'ProcessMonth',  
CASE WHEN ISNULL(IMGD.PanNo,'')<>'' THEN 1 ELSE 0 END 'RequestAdded',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=0 THEN 1 ELSE 0 END 'IncompleteEntries',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.IsApproved,0) =0 THEN 1 ELSE 0 END 'PLVC_Pending',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Reject' THEN 1 ELSE 0 END 'PLVC_Rejected',  
CASE WHEN ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1   
AND ISNULL(IMPLVCP.ProcessStatus,'') ='Approve' 
AND ISNULL(IMPLVCP.IsApproved,0) = 1 THEN 1 ELSE 0 END 'PLVC_Approved',
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.IsApproved,0)=0 THEN 1   
ELSE 0 END 'SB_Pending',  
CASE WHEN ISNULL(IMPLVCP.IsApproved,0) =1 AND ISNULL(ISBVM.ProcessStatus,'')='Reject' THEN 1   
ELSE 0 END 'SB_Rejected',  
CASE WHEN ISNULL(ISBVM.IsApproved,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>'' THEN 1  
ELSE 0 END 'TagGenerated',  
CASE WHEN (ISNULL(ISBTGUD.IsPanCardUpload,0)=0 OR ISNULL(ISBTGUD.IsAadharCardUpload,0)=0 OR   
ISNULL(ISBTGUD.IsAddressDetailsUpload,0)=0 OR ISNULL(ISBTGUD.IsEducationDetailsUpload,0)=0 OR  
ISNULL(ISBTGUD.IsNSESegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsBSESegmentDocUpload,0)=0 OR  
ISNULL(ISBTGUD.IsMCXSegmentDocUpload,0)=0 OR ISNULL(ISBTGUD.IsNCDEXSegmentDocUpload,0)=0 OR   
ISNULL(ISBTGUD.IsTagsheet_MOUDocUpload,0)=0) AND ISNULL(IMGD.PanNo,'')<>''   
AND ISNULL(ISBTGUD.IsFinalIntermediaryProcess,0)=1 AND ISNULL(ISBTGM.SBTag,'')<>''  
THEN 1 ELSE 0 END 'Doc_PendingForSubmission'  
  
FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)  
LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUD WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGUD.IntermediaryId  
LEFT JOIN tbl_IntermediarySBTagGenerationMaster ISBTGM  WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBTGM.IntermediaryId  
LEFT JOIN tbl_IntermediarySBVerificationMaster ISBVM WITH(NOLOCK)  
ON IMGD.IntermediaryId = ISBVM.IntermediaryId  
LEFT JOIN tbl_IntermediaryMasterPLVCProcess IMPLVCP WITH(NOLOCK)  
ON IMGD.IntermediaryId = IMPLVCP.IntermediaryId  
  
)AA  
GROUP BY ProcessYear,ProcessMonth  
END  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSegmentStatus
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSegmentStatus      
AS      
BEGIN    
/*
 Select IIF(V2OLE.Exchange='NSE' and V2OLE.Segment='FUTURES','NSEFO',V2OLE.Exchange) 'Exchange', V2OLE.RowState INTO #Temp      
  from IntersegmentJV_OfflineLedger ISJOL WITH(NOLOCK)        
  LEFT JOIN [196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES V2OLE WITH(NOLOCK) ON  V2OLE.VDate = ISJOL.VDate and V2OLE.Addby=ISJOL.Addby        
  Where ISJOL.VDate= cast(GETDATE() as date) And ISJOL.Addby='AutoNBFC'  AND ISJOL.VoucherType=8   
  */  
    
  Select IIF(V2OLE.Exchange='NSE' and V2OLE.Segment='FUTURES','NSEFO',V2OLE.Exchange) 'Exchange', V2OLE.RowState INTO #Temp      
  from IntersegmentJV_OfflineLedger ISJOL WITH(NOLOCK)        
  LEFT JOIN anand.MKTAPI.dbo.tbl_post_data V2OLE WITH(NOLOCK) ON  V2OLE.VDate = ISJOL.VDate and V2OLE.Return_fld5=ISJOL.Addby        
  Where ISJOL.VDate= cast(GETDATE() as date) And ISJOL.Addby='AutoNBFC'  AND ISJOL.VoucherType=8   
    
 SELECT      
CASE       
WHEN NSE =0 THEN 'Entered'      
WHEN ISNULL(NSE,'')= '' THEN 'Not Posted'      
WHEN NSE =2 THEN 'Success'      
WHEN NSE =9 THEN 'Failed'      
END 'NSE',      
CASE       
WHEN BSE =0 THEN 'Entered'       
WHEN ISNUll(BSE,'')= '' THEN 'Not Posted'      
WHEN BSE=2 THEN 'Success'      
WHEN BSE=9 THEN 'Failed'      
END 'BSE',      
CASE       
WHEN NSEFO =0 THEN 'Entered'       
WHEN ISNULL(NSEFO,'') = '' THEN 'Not Posted'      
WHEN NSEFO =2 THEN 'Success'      
WHEN NSEFO =9 THEN 'Failed'      
END 'NSEFO',      
CASE       
WHEN NSX =0 THEN 'Entered'       
WHEN ISNULL(NSX,'')= '' THEN 'Not Posted'      
WHEN ISNULL(NSX,0)=2 THEN 'Success'      
WHEN ISNULL(NSX,0)=9 THEN 'Failed'      
END 'NSX',      
CASE       
WHEN MCX =0 THEN 'Entered'      
WHEN ISNULL(MCX,'')= '' THEN 'Not Posted'      
WHEN MCX =2 THEN 'Success'      
WHEN MCX =9 THEN 'Failed'      
END 'MCX',      
CASE       
WHEN NCX =0 THEN 'Entered'      
WHEN ISNULL(NCX,'')= '' THEN 'Not Posted'      
WHEN NCX =2 THEN 'Success'      
WHEN NCX =9 THEN 'Failed'      
END 'NCX'      
FROM      
(      
  SELECT distinct      
   Exchange,      
   RowState      
  FROM #Temp     
      
 ) AS P      
      
 PIVOT      
 (      
   MAX(RowState) FOR Exchange IN ([NSE], [BSE], [NSEFO],[NSX],[MCX],[NCX])      
 ) AS pv2      
      
Drop table #Temp      
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetShortageMarginJV_OfflineLedgerEntry
-- --------------------------------------------------

CREATE Procedure [dbo].[USP_GetShortageMarginJV_OfflineLedgerEntry]        
AS        
BEGIN        
Select         
SMJVOL.VoucherType         
,SMJVOL.BookType         
,SMJVOL.SNo         
,SMJVOL.Vdate         
,SMJVOL.EDate         
,SMJVOL.CltCode         
,SMJVOL.CreditAmt         
,SMJVOL.DebitAmt         
,SMJVOL.Narration         
,SMJVOL.OppCode         
,SMJVOL.MarginCode         
,SMJVOL.BankName         
,SMJVOL.BranchName         
,SMJVOL.BranchCode         
,SMJVOL.DDNo         
,SMJVOL.ChequeMode         
,SMJVOL.ChequeDate         
,SMJVOL.ChequeName        
,SMJVOL.Clear_Mode         
,SMJVOL.TPAccountNumber         
,SMJVOL.Exchange         
,SMJVOL.Segment         
,SMJVOL.TPFlag         
,SMJVOL.AddDt         
,SMJVOL.AddBy         
,SMJVOL.StatusID         
,SMJVOL.StatusName         
,SMJVOL.RowState         
,SMJVOL.ApprovalFlag         
,SMJVOL.ApprovalDate         
,SMJVOL.ApprovedBy         
,SMJVOL.VoucherNo         
,SMJVOL.UploadDt         
,SMJVOL.LedgerVNO         
,SMJVOL.ClientName         
,SMJVOL.OppCodeName         
,SMJVOL.MarginCodeName         
,SMJVOL.Sett_No         
,SMJVOL.Sett_Type         
,SMJVOL.ProductType         
,SMJVOL.RevAmt         
,SMJVOL.RevCode         
,SMJVOL.MICR        
FROM ShortageMarginJV_OfflineLedger SMJVOL WITH(NOLOCK) LEFT JOIN       
[AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES OLLE WITH(NOLOCK)       
ON SMJVOL.vdate = OLLE.vdate AND SMJVOL.AddBy = OLLE.AddBy AND OLLE.RowState !=1 AND OLLE.VoucherType=8     
where SMJVOL.vdate= cast(GETDATE() as date) AND SMJVOL.IsUpdatetoLive=0 AND SMJVOL.AddBy='Remisier'   
ORDER by  VoucherNo , Sno asc          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerAgainstClientLimit_06Nov2025
-- --------------------------------------------------
  
CREATE Procedure [dbo].[USP_GetSubBrokerAgainstClientLimit_06Nov2025] @createdDate NVARCHAR(50)  
AS  
BEGIN  
declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @createdDate)))),21))  
select UPPER(a.SBCode) as SBTAG,(a.clientcode) as CLIENT_CODE,(b.long_name) as CLIENT_NAME, sum( CAST(a.EnterLimit as decimal(17,2))) as TOTAL_LIMIT     
from [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)  
  
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code  
  
inner join SB_COMP.DBO.SB_Broker c on a.SBCode=c.SBTAG  
  
where a.CreatedDT>=@createdDate  
  
and a.CreatedDT<=@NextDate  
and a.EnterLimit>0.00 and a.LimitResponse=1   
group by a.SBCode,a.clientcode,b.long_name  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerAgainstClientLimit_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE Procedure [dbo].[USP_GetSubBrokerAgainstClientLimit] @createdDate NVARCHAR(50)  
AS  
BEGIN  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @createdDate)))),21))  
select UPPER(a.SBCode) as SBTAG,(a.clientcode) as CLIENT_CODE,(b.long_name) as CLIENT_NAME, sum( CAST(a.EnterLimit as decimal(17,2))) as TOTAL_LIMIT     
from [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)  
  
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code  
  
inner join SB_COMP.DBO.SB_Broker c on a.SBCode=c.SBTAG  
  
where a.CreatedDT>=@createdDate  
  
and a.CreatedDT<=@NextDate  
and a.EnterLimit>0.00 and a.LimitResponse=1   
group by a.SBCode,a.clientcode,b.long_name  
END

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerEmailDetails_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSubBrokerEmailDetails_06Nov2025 @SBTAG NVARCHAR(50)    
AS    
BEGIN    
with ranked_contacts as    
 (select SBCT.RefNo    
   , SBCT.addtype    
   , SBCT.EmailId    
   ,SBBR.SBTAG    
       , rank() over    
        (    
         partition by SBCT.RefNo    
         order by    
           (CASE WHEN SBCT.addtype = 'RES' THEN 1 WHEN SBCT.addtype= 'OFF' THEN 2 WHEN SBCT.addtype ='TER' THEN 3 END    
                 )    
         ) priority    
   FROM SB_COMP.DBO.SB_CONTACT SBCT WITH(NOLOCK)    
JOIN SB_COMP.DBO.SB_BROKER SBBR WITH(NOLOCK)    
ON SBCT.RefNo = SBBR.RefNo     
 WHERE SBBR.SBTAG =@SBTAG  AND SBCT.addtype IN('RES','OFF','TER')  
--WHERE SBBR.SBTAG IN('AKJ','AMRHM','DFC')    
)    
    
 select EmailId    
 FROM ranked_contacts    
 WHERE priority = 1  
 AND ISNULL(EmailId,'') <>'';    
    
 END    

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerEmailDetails_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE PROCEDURE USP_GetSubBrokerEmailDetails @SBTAG NVARCHAR(50)    
AS  
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

BEGIN    
with ranked_contacts as    
 (select SBCT.RefNo    
   , SBCT.addtype    
   , SBCT.EmailId    
   ,SBBR.SBTAG    
       , rank() over    
        (    
         partition by SBCT.RefNo    
         order by    
           (CASE WHEN SBCT.addtype = 'RES' THEN 1 WHEN SBCT.addtype= 'OFF' THEN 2 WHEN SBCT.addtype ='TER' THEN 3 END    
                 )    
         ) priority    
   FROM SB_COMP.DBO.SB_CONTACT SBCT WITH(NOLOCK)    
JOIN SB_COMP.DBO.SB_BROKER SBBR WITH(NOLOCK)    
ON SBCT.RefNo = SBBR.RefNo     
 WHERE SBBR.SBTAG =@SBTAG  AND SBCT.addtype IN('RES','OFF','TER')  
--WHERE SBBR.SBTAG IN('AKJ','AMRHM','DFC')    
)    
    
 select EmailId    
 FROM ranked_contacts    
 WHERE priority = 1  
 AND ISNULL(EmailId,'') <>'';    
    
 END    

 /*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerFinalShortageAgainstClient_06Nov2025
-- --------------------------------------------------
  
CREATE Procedure USP_GetSubBrokerFinalShortageAgainstClient_06Nov2025        
@FromDate NVARCHAR(50) , @ToDate NVARCHAR(50)        
AS        
BEGIN        
    
declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @ToDate)))),21))        
declare @previousDate NVARCHAR(30) = (convert(nvarchar(50), (DATEADD(DAY,-1,@FromDate)),21))        
        
SELECT SBTAG,CLIENT_CODE,CLIENT_NAME,DATE, TOTAL_LIMIT,        
INITIAL_SHORTAGE,MTM_SHORTAGE,PEAK_SHORTAGE,NSE_PENALTY,NSEFO_PENALTY,NSX_PENALTY,MCX_PENALTY,NCX_PENALTY,BSX_PENALTY,MCD_PENALTY        
,SUM(NSE_Penalty+NSEFO_Penalty+NSX_Penalty+MCX_Penalty+NCX_Penalty+BSX_Penalty+MCD_Penalty)'TOTAL_PENALTY' FROM(        
        
SELECT SBTAG,CLIENT_CODE,CLIENT_NAME,CreatedDT 'DATE'         
, CAST((SUM(Total_Limit)) as decimal(17,2)) 'TOTAL_LIMIT'        
,CAST(ISNULL(Initial_Shortage,0) as decimal(17,2)) 'INITIAL_SHORTAGE',        
CAST(ISNULL(MTM_SHORTAGE,0) as decimal(17,2)) 'MTM_SHORTAGE'         
,CAST(ISNULL(TBLCRP.Peak_Shortage,0) as decimal(17,2)) 'PEAK_SHORTAGE'        
,CAST(ISNULL(NSEMP.NSE_Penalty,0) as decimal(17,2)) 'NSE_PENALTY'        
,CAST(ISNULL(NSEFOFP.NSEFO_Penalty ,0) as decimal(17,2)) 'NSEFO_PENALTY'         
,CAST(ISNULL(NSXFP.NSX_Penalty ,0) as decimal(17,2)) 'NSX_PENALTY'        
,CAST(ISNULL(MCXFP.MCX_Penalty ,0) as decimal(17,2)) 'MCX_PENALTY'        
,CAST(ISNULL(NCDXFP.NCX_Penalty ,0) as decimal(17,2)) 'NCX_PENALTY'        
,CAST(ISNULL(BSXFP.BSX_Penalty ,0) as decimal(17,2)) 'BSX_PENALTY'        
,CAST(ISNULL(MCDFP.MCD_Penalty ,0) as decimal(17,2)) 'MCD_PENALTY'        
FROM (        
select UPPER(a.SBCode) as SBTAG,UPPER(a.clientcode) as CLIENT_CODE,(b.long_name) as Client_Name, (a.EnterLimit) as Total_Limit         
, CONVERT(nvarchar(50), a.CreatedDT,103) 'CreatedDT'   -- 264        
--,TBLCR.Initial_Shortage, TBLCR.MTM_SHORTAGE        
--from [196.1.115.132].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)   
--inner join [196.1.115.132].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code   
  
FROM [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)              
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code        
        
inner join SB_COMP.DBO.SB_Broker c WITH(NOLOCK) on a.SBCode=c.SBTAG        
        
where a.CreatedDT  >=@FromDate and a.CreatedDT<=@NextDate  and        
        
a.EnterLimit>0.00 and a.LimitResponse=1 --group by a.SBCode,a.clientcode,b.long_name,a.CreatedDT         
        
) A        
        
LEFT JOIN (Select PARTY_CODE,MARGINDATE        
,Isnull(sum(cast(TDAY_MARGIN_SHORT as decimal(17,2))),0) 'Initial_Shortage'         
,IIF(SUM(Cast((TDAY_MTM_SHORT) as decimal(17,2)))>0,0,SUM(Cast((TDAY_MTM_SHORT) as decimal(17,2)))) as MTM_SHORTAGE         
From(        
Select PARTY_CODE, CONVERT(nvarchar(50), MARGINDATE,103) 'MARGINDATE' ,TDAY_MARGIN_SHORT,TDAY_MTM_SHORT        
FROM [AngelNseCM].MSAJAG.dbo.TBL_COMBINE_REPORTING WITH(NOLOCK)        
 WHERE TDAY_MARGIN_SHORT<0         
 AND MARGINDATE  >=@FromDate and MARGINDATE <=@NextDate        
 --AND MARGINDATE  >='2021-06-10' and MARGINDATE <='2021-06-11 23:59:59.000'        
         
) T        
Group By PARTY_CODE,MARGINDATE        
)TBLCR         
ON TBLCR.PARTY_CODE = A.CLIENT_CODE AND TBLCR.MARGINDATE = A.CreatedDT        
        
LEFT JOIN (Select PARTY_CODE,MARGINDATE, sum(TDAY_MARGIN_SHORT) as Peak_Shortage FROM(        
select Convert(NVARCHAR(50),MARGINDATE,103) 'MARGINDATE',PARTY_CODE,        
TDAY_MARGIN_SHORT        
        
--from anand1.MSAJAG.dbo.TBL_COMBINE_REPORTING_Peak with(nolock)      
from AngelNseCM.MSAJAG.dbo.TBL_COMBINE_REPORTING_Peak with(nolock)        
        
where MARGINDATE >=@FromDate and MARGINDATE <=@NextDate  and TDAY_MARGIN_SHORT<0        
) T        
Group By PARTY_CODE,MARGINDATE        
) TBLCRP        
ON TBLCRP.PARTY_CODE = A.CLIENT_CODE AND TBLCRP.MARGINDATE = A.CreatedDT        
        
LEFT JOIN ( Select PARTY_CODE, MARGIN_DATE, Sum(NSE_Penalty) as NSE_Penalty FROM         
(        
select Convert(NVARCHAR(50),MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSE_Penalty        
from AngelNseCM.MSAJAG.dbo.CMMARGIN_PENALTY with(nolock)        
where MARGIN_DATE  >=@FromDate and MARGIN_DATE <=@NextDate        
) T        
Group By PARTY_CODE,MARGIN_DATE        
) NSEMP        
ON NSEMP.PARTY_CODE = A.CLIENT_CODE AND NSEMP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE, Sum(NSEFO_Penalty) as NSEFO_Penalty FROM        
(        
 SELECT CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSEFO_Penalty        
from [AngelFO].NSEFO.dbo.FOMARGIN_PENALTY with(nolock)        
WHERE MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
Group By PARTY_CODE,MARGIN_DATE        
) NSEFOFP        
ON NSEFOFP.PARTY_CODE = A.CLIENT_CODE AND NSEFOFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE, Sum(NSX_Penalty) 'NSX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSX_Penalty        
        
from [AngelFO].NSECURFO.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
Group By PARTY_CODE,MARGIN_DATE        
) NSXFP        
ON NSXFP.PARTY_CODE = A.CLIENT_CODE AND NSXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE,Sum(MCX_Penalty) 'MCX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as MCX_Penalty        
        
from [AngelCommodity].MCDX.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
)A        
GROUP BY MARGIN_DATE,PARTY_CODE        
) MCXFP        
ON MCXFP.PARTY_CODE = A.CLIENT_CODE AND MCXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN ( SELECT PARTY_CODE,MARGIN_DATE,Sum(NCDX_Penalty) 'NCX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NCDX_Penalty        
        
from [AngelCommodity].NCDX.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
GROUP BY MARGIN_DATE,PARTY_CODE        
) NCDXFP        
ON NCDXFP.PARTY_CODE = A.CLIENT_CODE AND NCDXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN ( SELECT PARTY_CODE,MARGIN_DATE, Sum(BSX_Penalty) 'BSX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as BSX_Penalty        
        
from [AngelCommodity].BSECURFO.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
group by MARGIN_DATE,PARTY_CODE        
)BSXFP        
ON BSXFP.PARTY_CODE = A.CLIENT_CODE AND BSXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN(SELECT PARTY_CODE,MARGIN_DATE, SUM(MCD_Penalty) 'MCD_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as MCD_Penalty        
        
FROM [AngelCommodity].MCDXCDS.dbo.FOMARGIN_PENALTY with(nolock)        
WHERE MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
group by MARGIN_DATE,PARTY_CODE        
)MCDFP        
ON MCDFP.PARTY_CODE = A.CLIENT_CODE AND MCDFP.MARGIN_DATE = A.CreatedDT        
        
group by SBTAG,CLIENT_CODE,Client_Name,CreatedDT,Initial_Shortage, MTM_SHORTAGE,Peak_Shortage,NSE_Penalty        
,NSEFO_Penalty,NSX_Penalty,MCX_Penalty,NCX_Penalty,BSX_Penalty, MCD_Penalty        
        
) B        
WHERE (B.Initial_Shortage<0 OR B.MTM_SHORTAGE<0 OR B.Peak_Shortage<0)        
--AND B.SBTAG IN('GGIV','GGSHA','HEGU')        
        
group by SBTAG,CLIENT_CODE,Client_Name,DATE,TOTAL_LIMIT,Initial_Shortage, MTM_SHORTAGE,Peak_Shortage,NSE_Penalty        
,NSEFO_Penalty,NSX_Penalty,MCX_Penalty,NCX_Penalty,BSX_Penalty, MCD_Penalty        
        
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerFinalShortageAgainstClient_tobedeleted09jan2026
-- --------------------------------------------------
  
CREATE Procedure USP_GetSubBrokerFinalShortageAgainstClient        
@FromDate NVARCHAR(50) , @ToDate NVARCHAR(50)        
AS        
BEGIN        
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

declare @NextDate NVARCHAR(50) = (convert(nvarchar(50), (DATEADD(s,-1,(DATEADD(DAY, 1, @ToDate)))),21))        
declare @previousDate NVARCHAR(30) = (convert(nvarchar(50), (DATEADD(DAY,-1,@FromDate)),21))        
        
SELECT SBTAG,CLIENT_CODE,CLIENT_NAME,DATE, TOTAL_LIMIT,        
INITIAL_SHORTAGE,MTM_SHORTAGE,PEAK_SHORTAGE,NSE_PENALTY,NSEFO_PENALTY,NSX_PENALTY,MCX_PENALTY,NCX_PENALTY,BSX_PENALTY,MCD_PENALTY        
,SUM(NSE_Penalty+NSEFO_Penalty+NSX_Penalty+MCX_Penalty+NCX_Penalty+BSX_Penalty+MCD_Penalty)'TOTAL_PENALTY' FROM(        
        
SELECT SBTAG,CLIENT_CODE,CLIENT_NAME,CreatedDT 'DATE'         
, CAST((SUM(Total_Limit)) as decimal(17,2)) 'TOTAL_LIMIT'        
,CAST(ISNULL(Initial_Shortage,0) as decimal(17,2)) 'INITIAL_SHORTAGE',        
CAST(ISNULL(MTM_SHORTAGE,0) as decimal(17,2)) 'MTM_SHORTAGE'         
,CAST(ISNULL(TBLCRP.Peak_Shortage,0) as decimal(17,2)) 'PEAK_SHORTAGE'        
,CAST(ISNULL(NSEMP.NSE_Penalty,0) as decimal(17,2)) 'NSE_PENALTY'        
,CAST(ISNULL(NSEFOFP.NSEFO_Penalty ,0) as decimal(17,2)) 'NSEFO_PENALTY'         
,CAST(ISNULL(NSXFP.NSX_Penalty ,0) as decimal(17,2)) 'NSX_PENALTY'        
,CAST(ISNULL(MCXFP.MCX_Penalty ,0) as decimal(17,2)) 'MCX_PENALTY'        
,CAST(ISNULL(NCDXFP.NCX_Penalty ,0) as decimal(17,2)) 'NCX_PENALTY'        
,CAST(ISNULL(BSXFP.BSX_Penalty ,0) as decimal(17,2)) 'BSX_PENALTY'        
,CAST(ISNULL(MCDFP.MCD_Penalty ,0) as decimal(17,2)) 'MCD_PENALTY'        
FROM (        
select UPPER(a.SBCode) as SBTAG,UPPER(a.clientcode) as CLIENT_CODE,(b.long_name) as Client_Name, (a.EnterLimit) as Total_Limit         
, CONVERT(nvarchar(50), a.CreatedDT,103) 'CreatedDT'   -- 264        
--,TBLCR.Initial_Shortage, TBLCR.MTM_SHORTAGE        
--from [196.1.115.132].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)   
--inner join [196.1.115.132].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code   
  
FROM [INTRANET].LimitEnhancement.DBO.tbl_SBLimitAllocation_log a WITH(NOLOCK)              
inner join [INTRANET].risk.DBO.CLient_details b WITH(NOLOCK) on  a.clientcode=b.party_code        
        
inner join SB_COMP.DBO.SB_Broker c WITH(NOLOCK) on a.SBCode=c.SBTAG        
        
where a.CreatedDT  >=@FromDate and a.CreatedDT<=@NextDate  and        
        
a.EnterLimit>0.00 and a.LimitResponse=1 --group by a.SBCode,a.clientcode,b.long_name,a.CreatedDT         
        
) A        
        
LEFT JOIN (Select PARTY_CODE,MARGINDATE        
,Isnull(sum(cast(TDAY_MARGIN_SHORT as decimal(17,2))),0) 'Initial_Shortage'         
,IIF(SUM(Cast((TDAY_MTM_SHORT) as decimal(17,2)))>0,0,SUM(Cast((TDAY_MTM_SHORT) as decimal(17,2)))) as MTM_SHORTAGE         
From(        
Select PARTY_CODE, CONVERT(nvarchar(50), MARGINDATE,103) 'MARGINDATE' ,TDAY_MARGIN_SHORT,TDAY_MTM_SHORT        
FROM [AngelNseCM].MSAJAG.dbo.TBL_COMBINE_REPORTING WITH(NOLOCK)        
 WHERE TDAY_MARGIN_SHORT<0         
 AND MARGINDATE  >=@FromDate and MARGINDATE <=@NextDate        
 --AND MARGINDATE  >='2021-06-10' and MARGINDATE <='2021-06-11 23:59:59.000'        
         
) T        
Group By PARTY_CODE,MARGINDATE        
)TBLCR         
ON TBLCR.PARTY_CODE = A.CLIENT_CODE AND TBLCR.MARGINDATE = A.CreatedDT        
        
LEFT JOIN (Select PARTY_CODE,MARGINDATE, sum(TDAY_MARGIN_SHORT) as Peak_Shortage FROM(        
select Convert(NVARCHAR(50),MARGINDATE,103) 'MARGINDATE',PARTY_CODE,        
TDAY_MARGIN_SHORT        
        
--from anand1.MSAJAG.dbo.TBL_COMBINE_REPORTING_Peak with(nolock)      
from AngelNseCM.MSAJAG.dbo.TBL_COMBINE_REPORTING_Peak with(nolock)        
        
where MARGINDATE >=@FromDate and MARGINDATE <=@NextDate  and TDAY_MARGIN_SHORT<0        
) T        
Group By PARTY_CODE,MARGINDATE        
) TBLCRP        
ON TBLCRP.PARTY_CODE = A.CLIENT_CODE AND TBLCRP.MARGINDATE = A.CreatedDT        
        
LEFT JOIN ( Select PARTY_CODE, MARGIN_DATE, Sum(NSE_Penalty) as NSE_Penalty FROM         
(        
select Convert(NVARCHAR(50),MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSE_Penalty        
from AngelNseCM.MSAJAG.dbo.CMMARGIN_PENALTY with(nolock)        
where MARGIN_DATE  >=@FromDate and MARGIN_DATE <=@NextDate        
) T        
Group By PARTY_CODE,MARGIN_DATE        
) NSEMP        
ON NSEMP.PARTY_CODE = A.CLIENT_CODE AND NSEMP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE, Sum(NSEFO_Penalty) as NSEFO_Penalty FROM        
(        
 SELECT CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSEFO_Penalty        
from [AngelFO].NSEFO.dbo.FOMARGIN_PENALTY with(nolock)        
WHERE MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
Group By PARTY_CODE,MARGIN_DATE        
) NSEFOFP        
ON NSEFOFP.PARTY_CODE = A.CLIENT_CODE AND NSEFOFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE, Sum(NSX_Penalty) 'NSX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NSX_Penalty        
        
from [AngelFO].NSECURFO.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
Group By PARTY_CODE,MARGIN_DATE        
) NSXFP        
ON NSXFP.PARTY_CODE = A.CLIENT_CODE AND NSXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN (SELECT PARTY_CODE,MARGIN_DATE,Sum(MCX_Penalty) 'MCX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as MCX_Penalty        
        
from [AngelCommodity].MCDX.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
)A        
GROUP BY MARGIN_DATE,PARTY_CODE        
) MCXFP        
ON MCXFP.PARTY_CODE = A.CLIENT_CODE AND MCXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN ( SELECT PARTY_CODE,MARGIN_DATE,Sum(NCDX_Penalty) 'NCX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as NCDX_Penalty        
        
from [AngelCommodity].NCDX.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
GROUP BY MARGIN_DATE,PARTY_CODE        
) NCDXFP        
ON NCDXFP.PARTY_CODE = A.CLIENT_CODE AND NCDXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN ( SELECT PARTY_CODE,MARGIN_DATE, Sum(BSX_Penalty) 'BSX_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as BSX_Penalty        
        
from [AngelCommodity].BSECURFO.dbo.FOMARGIN_PENALTY with(nolock)        
where MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
group by MARGIN_DATE,PARTY_CODE        
)BSXFP        
ON BSXFP.PARTY_CODE = A.CLIENT_CODE AND BSXFP.MARGIN_DATE = A.CreatedDT        
        
LEFT JOIN(SELECT PARTY_CODE,MARGIN_DATE, SUM(MCD_Penalty) 'MCD_Penalty' FROM (        
select CONVERT(nvarchar(50), MARGIN_DATE,103) 'MARGIN_DATE',PARTY_CODE,        
(PENALTY_AMT+SERVICE_TAX) as MCD_Penalty        
        
FROM [AngelCommodity].MCDXCDS.dbo.FOMARGIN_PENALTY with(nolock)        
WHERE MARGIN_DATE >=@FromDate and MARGIN_DATE <=@NextDate        
) A        
group by MARGIN_DATE,PARTY_CODE        
)MCDFP        
ON MCDFP.PARTY_CODE = A.CLIENT_CODE AND MCDFP.MARGIN_DATE = A.CreatedDT        
        
group by SBTAG,CLIENT_CODE,Client_Name,CreatedDT,Initial_Shortage, MTM_SHORTAGE,Peak_Shortage,NSE_Penalty        
,NSEFO_Penalty,NSX_Penalty,MCX_Penalty,NCX_Penalty,BSX_Penalty, MCD_Penalty        
        
) B        
WHERE (B.Initial_Shortage<0 OR B.MTM_SHORTAGE<0 OR B.Peak_Shortage<0)        
--AND B.SBTAG IN('GGIV','GGSHA','HEGU')        
        
group by SBTAG,CLIENT_CODE,Client_Name,DATE,TOTAL_LIMIT,Initial_Shortage, MTM_SHORTAGE,Peak_Shortage,NSE_Penalty        
,NSEFO_Penalty,NSX_Penalty,MCX_Penalty,NCX_Penalty,BSX_Penalty, MCD_Penalty        
        
END 

/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerOnBoardingProcessCommonDetails
-- --------------------------------------------------
CREATE PROCEDURE USP_GetSubBrokerOnBoardingProcessCommonDetails  
AS  
BEGIN  
SELECT CompanyId,CompanyCode,CompanyName  
FROM tbl_SubBrokerOnBoardingCompanyMaster WITH(NOLOCK)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetSubBrokerTagGenerationDocumentUploadedStatusDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_GetSubBrokerTagGenerationDocumentUploadedStatusDetails @SBPanNo VARCHAR(10)=''
AS
BEGIN
SELECT IntermediaryId,PanNo,ISNULL(DocumentName,'') 'DocumentName',
CASE WHEN DocumentStatus=1 THEN 'Uploaded' ELSE 'Not Upload' END 'DocumentStatus' FROM(
SELECT IMGD.IntermediaryId,IMGD.PanNo,
ISNULL(IsPANCardUpload,0) 'PAN CARD',ISNULL(IsAadharCardUpload,0) 'AADHAR CARD (Resi.)'
,ISNULL(IsAddressDetailsUpload,0) 'Address (Off.)',ISNULL(IsEducationDetailsUpload,0) 'Education',
ISNULL(IsAffidavitDetailsUpload,0) 'Affidavit',ISNULL(IsNSESegmentDocUpload,0) 'NSE Segment'
,ISNULL(IsBSESegmentDocUpload,0) 'BSE Segment',ISNULL(IsMCXSegmentDocUpload,0) 'MCX Segment',
ISNULL(IsNCDEXSegmentDocUpload,0) 'NCDEX Segment',ISNULL(IsTagsheet_MOUDocUpload,0) 'Tagsheet/MOU'
,ISNULL(IsBankDetailsUpload,0) 'Bank Details',ISNULL(IsCancelChequeDocUpload,0) 'Cancel Cheque',
ISNULL(IsFinalDraftFromAP_SBDocUpload,0) 'Final Draft from AP/SB',ISNULL(IsAP_SBProfilingDocUpload,0) 'AP/SB Profiling'
FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)
LEFT JOIN tbl_IntermediarySBTagGenerationUploadedDocumentsDetails ISBTGUDD WITH(NOLOCK)
ON IMGD.IntermediaryId = ISBTGUDD.IntermediaryId
WHERE IMGD.PanNo=@SBPanNo
)AA
UNPIVOT
(
DocumentStatus For DocumentName IN(
[PAN CARD],[AADHAR CARD (Resi.)],[Address (Off.)],[Education],
[Affidavit],[NSE Segment],[BSE Segment],[MCX Segment],
[NCDEX Segment],[Tagsheet/MOU],[Bank Details],[Cancel Cheque],
[Final Draft from AP/SB],[AP/SB Profiling]
)
)As UnPVT
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetUndeliveredClientDRFForInwordProcess
-- --------------------------------------------------

CREATE PROCEDURE USP_GetUndeliveredClientDRFForInwordProcess  
AS  
BEGIN  
SELECT DRFRPM.DRFId,DRFRPM.DRFNo,DRFRPM.ClientId,DRFRPM.ClientName  
,CompanyName,Quantity,DRFRPM.NoOfCertificates,   
ISNULL(UDCDRFID.PodNo,'') 'PodNo', ISNULL(UDCDRFID.CourierBy,'') 'CourierBy' ,  
CASE WHEN CAST(ISNULL(UDCDRFID.InwordProcessDate,'') as date) = '1900-01-01'  
THEN '' ELSE CONVERT(VARCHAR(18),UDCDRFID.InwordProcessDate,113) END  
'ProcessDate'  
,DRFORRPD.StatusDescription 'Remarks'  
  
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails DRFORRPD WITH(NOLOCK)    
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)    
ON DRFORRPD.DRFId = DRFRPM.DRFId    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPD.DRFId = DRFRPM.DRFId  
LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)  
ON UDCDRFID.DRFId = DRFRPM.DRFId  
WHERE ISNULL(DRFORRPD.StatusGroup,'') IN('RT','UD') AND DRFORRPD.IsDocumentReceived=0  
AND ISNULL(IsReProcess,0)=0  
ORDER BY UDCDRFID.DRFId DESC  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GetUndeliveredDRFInwordProcessReport
-- --------------------------------------------------

CREATE PROCEDURE USP_GetUndeliveredDRFInwordProcessReport  
@FromDate VARCHAR(10)='', @ToDate VARCHAR(10)=''  
AS  
BEGIN  
  
SELECT DRFRPM.DRFId,  
DRFRPM.DRFNo,DRFRPM.ClientId,DRFRPM.NoOfCertificates,DRFRPM.ClientName,  
DRFIRPD.CompanyName,DRFIRPD.Quantity,UDCDRFID.PodNo,  
UDCDRFID.CourierBy,UDCDRFID.Remarks,  
CONVERT(VARCHAR(10),UDCDRFID.InwordProcessDate,103) 'InwordProcessDate'  ,
CASE WHEN ISNULL(DocumentReceivedBy,'')<>'' OR ISNULL(ReProcessPodNo,'')<>'' 
THEN 'DRF Resent to Client' ELSE '' END 'Status',
ISNULL(ReProcessType,'') 'ReProcessType',ISNULL(DocumentReceivedBy,'') 'DocumentReceivedBy',
ISNULL(ReProcessPodNo,'') 'ReProcessPodNo'
,ISNULL(ReProcessCourierName,'') 'ReProcessCourierName'
  
FROM tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)    
ON UDCDRFID.DRFId = DRFRPM.DRFId    
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPD.DRFId = DRFRPM.DRFId  
WHERE CAST(UDCDRFID.InwordProcessDate as date) between   
CAST(CONVERT(datetime, @FromDate,103) as date) AND  
CAST(CONVERT(datetime, @ToDate,103) as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_PostJVLedgerEntryOnline
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_PostJVLedgerEntryOnline]          
@InterSegmentJVLedgerType InterSegmentJVLedgerType readonly          
As          
BEGIN        
/*
Insert into [196.1.115.201].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES(          
VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration          
,Exchange,Segment,AddDt,AddBy,StatusID,          
StatusName,RowState,ApprovalFlag,ApprovalDate,ApprovedBy,VoucherNo,UploadDt          
)          
Select           
VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration          
,Exchange,Segment,AddDt,AddBy,StatusID,          
StatusName,0,ApprovalFlag,GETDATE(),ApprovedBy,VoucherNo,GETDATE() from @InterSegmentJVLedgerType         
   */   
-------------      
      
 ----INSERT INTO anand.MKTAPI.dbo.tbl_post_data              
 INSERT INTO AngelBSECM.MKTAPI.dbo.tbl_post_data  
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE            
,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3             
,RETURN_FLD4,RETURN_FLD5,ROWSTATE)        
SELECT       
VoucherType,      
SNo,      
Vdate,      
EDate,      
CltCode,      
CreditAmt,      
DebitAmt,      
Narration,      
'' BankCode,      
'' MarginCode,      
'' BankName,      
'' BranchName,      
'' BranchCode,      
'' DDNo,      
'' ChequeMode,      
'' ChequeDate,      
'' ChequeName,      
'' Clear_Mode,      
'' TPAccountNumber,      
Exchange,      
Segment,      
1 'MKCK_FLAG',      
'' 'Return_fld1',      
AddBy 'Return_fld2',      
'' 'Return_fld3',      
'' 'Return_fld4',      
AddBy 'Return_fld5',      
0 'ROWSTATE'      
FROM @InterSegmentJVLedgerType         
--FROM IntersegmentJV_OfflineLedger    
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RemoveClientDRFDetailsFromProcess
-- --------------------------------------------------

CREATE PROCEDURE USP_RemoveClientDRFDetailsFromProcess   
@DRFId bigint=0, @ClientId VARCHAR(35)=''  
AS  
BEGIN  
  
DELETE FROM tbl_DRFInwordRegistrationProcessDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_ClientDRFInwordDocuments WHERE DRFId= @DRFId  
DELETE FROM tbl_RejectedDRFOutwordProcessAndResponseDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_ClientDRFProcessCompleteStatusDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_RTARejectedDRFMemoScannedDocument WHERE DRFId= @DRFId  
DELETE FROM tbl_UndeliveredClientDRFInwordDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_DRFOutwordRegistrationSendToRTADetails WHERE DRFId= @DRFId  
DELETE FROM DRFInwordRegistrationReceivedByRTADetails WHERE DRFId= @DRFId  
DELETE FROM tbl_UndeliveredClientDRFInwordDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_DRFProcessClientMailStatusDetails WHERE DRFId= @DRFId  
DELETE FROM tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails WHERE DRFId=@DRFId

  
--- Aadhar Authentication Entry  
  
SELECT ROW_NUMBER() OVER(ORDER BY ProcessDate) 'SR',* INTO #AuthDetails  
FROM ClientDRFAadharAuthenticationVerificationDetails WHERE ClientDPId=@ClientId  
ORDER BY ProcessDate  
  
IF EXISTS(SELECT * FROM #AuthDetails)  
BEGIN  
DECLARE @SRNo int= (SELECT SR FROM #AuthDetails WHERE DRFId= @DRFId)  
DECLARE @TotalCost decimal(17,2)=(SELECT TotalCost FROM #AuthDetails WHERE DRFId= @DRFId)  
  
IF EXISTS(SELECT * FROM #AuthDetails WHERE SR> @SRNo)  
BEGIN  
UPDATE CDRFAD SET CommulativeValuation=CDRFAD.CommulativeValuation- @TotalCost  
FROM ClientDRFAadharAuthenticationVerificationDetails CDRFAD  
JOIN #AuthDetails AD  
ON CDRFAD.ClientDPId=AD.ClientDPId AND CDRFAD.DRFId=AD.DRFId  
WHERE AD.SR>@SRNo  
  
DELETE FROM ClientDRFAadharAuthenticationVerificationDetails WHERE DRFId=@DRFId  
END  
ELSE  
BEGIN  
DELETE FROM ClientDRFAadharAuthenticationVerificationDetails WHERE DRFId=@DRFId  
END  
  
END  
  
----  
  
DECLARE @PodId bigint=0  
SET @PodId = (SELECT PodId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFId= @DRFId)  
  
IF((SELECT COUNT(*) FROM tbl_DRFInwordRegistrationProcessMaster WHERE PodId=@PodId)>1)  
BEGIN  
DELETE FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFId= @DRFId  
END  
ELSE  
BEGIN  
DELETE FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFId= @DRFId  
DELETE FROM tbl_DRFPodInwordRegistrationProcess  WHERE PodId=@PodId  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveAndUpdateJV_OfflineLedgerLogData
-- --------------------------------------------------
Create Procedure USP_SaveAndUpdateJV_OfflineLedgerLogData  
AS  
BEGIN  
IF EXISTS(Select * FROM IntersegmentJV_OfflineLedger WITH(NOLOCK) )
BEGIN
INSERT INTO IntersegmentJV_OfflineLedgerLogFile
(VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration,Exchange,Segment,AddDt,AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,VoucherNo,UploadDt,IsUpdatetoLive,UpdationDate)
Select VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration,Exchange,Segment,AddDt,AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,VoucherNo,UploadDt,IsUpdatetoLive,GETDATE() From IntersegmentJV_OfflineLedger

Delete From IntersegmentJV_OfflineLedger
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveAndUpdateShortageJV_OfflineLedgerLogData
-- --------------------------------------------------

CREATE Procedure USP_SaveAndUpdateShortageJV_OfflineLedgerLogData      
AS      
BEGIN      
IF EXISTS(Select * FROM ShortageMarginJV_OfflineLedger WITH(NOLOCK) )    
BEGIN    
INSERT INTO ShortageMarginJV_OfflineLedgerLogFile    
(VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration,Exchange,Segment,AddDt,AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,VoucherNo,UploadDt,StartDate,EndDate,IsUpdatetoLive,UpdationDate)    
Select VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration,Exchange,Segment,AddDt,AddBy,StatusID,StatusName,RowState,ApprovalFlag,ApprovalDate,VoucherNo,UploadDt,StartDate,EndDate,IsUpdatetoLive,GETDATE() From ShortageMarginJV_OfflineLedger    
    
Delete From ShortageMarginJV_OfflineLedger    
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveBankingVerifiedSBPayoutDetails
-- --------------------------------------------------

CREATE Procedure USP_SaveBankingVerifiedSBPayoutDetails
@SBTag VARCHAR(15),@SBPanNo VARCHAR(15),@RefNo VARCHAR(35),@Remarks VARCHAR(25),@RejectionReason VARCHAR(255)
AS
BEGIN
DECLARE @DepositRefId bigint ,@DepositVarificationId bigint
SET @DepositRefId = (SELECT DepositRefId FROM tbl_SBPayoutDepositProcessDetailsInLMS WITH(NOLOCK) WHERE SBPanNo=@SBPanNo AND RefNo = @RefNo)
SET @DepositVarificationId = (SELECT DepositVarificationId FROM tbl_SBPayoutDetailsVarificationBySBTeam WITH(NOLOCK) WHERE SBPanNo=@SBPanNo AND DepositRefId = @DepositRefId)

IF NOT EXISTS(SELECT * FROM tbl_SBPayoutDetailsBankingVarification WITH(NOLOCK) WHERE DepositVarificationId= @DepositVarificationId AND SBPanNo=@SBPanNo AND SBTag=@SBTag)
BEGIN
INSERT INTO tbl_SBPayoutDetailsBankingVarification 
VALUES(@DepositVarificationId,@SBTag,@SBPanNo,@Remarks,@RejectionReason,GETDATE(),'Test','')

UPDATE SBPDVSB SET IsBankingRejected=1
FROM  tbl_SBPayoutDetailsVarificationBySBTeam SBPDVSB                     
JOIN tbl_SBPayoutDetailsBankingVarification SBPDBV
ON SBPDBV.DepositVarificationId= SBPDVSB.DepositVarificationId AND SBPDVSB.SBPanNo = SBPDBV.SBPanNo
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPD
ON SBPDVSB.DepositRefId = SBPDPD.DepositRefId AND SBPDVSB.SBPanNo = SBPDPD.SBPanNo
WHERE SBPDBV.Remarks ='Reject'
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveClientDRFAadharAuthenticationESignDocument
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveClientDRFAadharAuthenticationESignDocument
@DRFId bigint='', @ClientId VARCHAR(50)='', @FileName VARCHAR(250)='',@ProcessBy VARCHAR(50)=''
AS
BEGIN
Update ClientDRFAadharAuthenticationVerificationDetails SET
IsESignDocumentUpload=1 , IsESignDocUploadDate=GETDATE(), DocumentName=@FileName,
FilePath='//196.1.115.147/upload1/DRFESignDocuments/',ProcessBy=@ProcessBy
WHERE DRFId=@DRFId AND ClientDPId=@ClientId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveClientDRFInwordDocumentsDetails
-- --------------------------------------------------
  
CREATE PROCEDURE USP_SaveClientDRFInwordDocumentsDetails    
@DRFId bigint,@ClientId VARCHAR(35)='',@IsDRFTransferedForScan bit,@ToTransfredName VARCHAR(255)=''
, @FilePath VARCHAR(250)='',@DocumentName VARCHAR(250)='', @Extension VARCHAR(8)='' ,@ProcessBy VARCHAR(25) =''
AS    
BEGIN    
IF NOT EXISTS(SELECT * FROM tbl_ClientDRFInwordDocuments WITH(NOLOCK) WHERE DRFId = @DRFId)    
BEGIN    
INSERT INTO tbl_ClientDRFInwordDocuments 
VALUES(@DRFId,@ClientId,@IsDRFTransferedForScan,GETDATE(),@ToTransfredName,@FilePath,@DocumentName,@Extension,GETDATE(),@ProcessBy)    
END    
ELSE    
BEGIN    
UPDATE tbl_ClientDRFInwordDocuments SET FilePath=@FilePath,DocumentName=@DocumentName,Extension=@Extension,ProcessDate=GETDATE()    
WHERE DRFId = @DRFId    
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveClientDRFRTARejectedMemoScannedDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveClientDRFRTARejectedMemoScannedDetails        
@DRFId bigint  , @FilePath VARCHAR(250)='',@DocumentName VARCHAR(250)='' ,@ProcessBy VARCHAR(25) =''    
AS        
BEGIN        
IF NOT EXISTS(SELECT * FROM tbl_RTARejectedDRFMemoScannedDocument WITH(NOLOCK) WHERE DRFId = @DRFId)        
BEGIN     
DECLARE @DRNNo VARCHAR(35)=''
SET @DRNNo = (SELECT DISTINCT DRNNo FROM DRFInwordRegistrationReceivedByRTADetails WITH(NOLOCK) WHERE DRFId = @DRFId)
INSERT INTO tbl_RTARejectedDRFMemoScannedDocument     
VALUES(@DRFId,@DRNNo,@DocumentName,@FilePath,GETDATE(),@ProcessBy)        
END        
ELSE        
BEGIN        
UPDATE tbl_RTARejectedDRFMemoScannedDocument SET FilePath=@FilePath,FileName=@DocumentName  
WHERE DRFId = @DRFId        
END        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveClientExceptionDetails
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[USP_SaveClientExceptionDetails]
(
 @ClientCode NVARCHAR(50),
 @ClientName NVARCHAR(200),
 @PanNo NVARCHAR(50),
 @IsBlocked bit
)
AS
Begin
  IF Exists(Select * from ExceptionClientDetails WITH(NOLOCK) where ClientCode =@ClientCode)
  BEGIN
  Declare @BlockedDate DateTime 
   SET @BlockedDate =(Select BlockedDate from ExceptionClientDetails WITH(NOLOCK) where ClientCode =@ClientCode)
   Delete From ExceptionClientDetails where ClientCode = @ClientCode
   Insert into ClientLogDetails values(@ClientCode,@ClientName,@PanNo,@BlockedDate,GETDATE())
  END
  ELSE
  BEGIN
  Insert into ExceptionClientDetails values(@ClientCode,@ClientName,@PanNo,1,GETDATE())
  END
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveDRFESignAadharAuthenticationRequestResponseDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveDRFESignAadharAuthenticationRequestResponseDetails  
@DRFId bigint=0, @DocumentId VARCHAR(35)='',@IRNNo VARCHAR(35)='',@SignUrlPath VARCHAR(MAX)='',  
@ActiveStatus bit=0,@ExpiryDate VARCHAR(20)='',@ProcessBy VARCHAR(15)=''  
AS  
BEGIN  
SET @ExpiryDate = convert(datetime,@ExpiryDate,103)  
IF NOT EXISTS(SELECT * FROM tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails WHERE DRFId=@DRFId)  
BEGIN  
INSERT INTO tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails   
VALUES(@DRFId,1,@DocumentId,@IRNNo,GETDATE(),@SignUrlPath,@ActiveStatus,@ExpiryDate,'Active',0,'','','',@ProcessBy,GETDATE())  
END  
ELSE
BEGIN
Update tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails set 
DocumentId=@DocumentId,RequestSendDate=GETDATE(),SignUrlPath=@SignUrlPath,
ActiveStatus=@ActiveStatus,ExpiryDate=@ExpiryDate,ProcessBy=@ProcessBy,
ResponseSignUrlPath='Resend' WHERE DRFId= @DRFId 
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveDRFInwordRegistrationProcessData
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveDRFInwordRegistrationProcessData]  
@ClientId VARCHAR(30),@ClientName VARCHAR(255)='',@MobileNo VARCHAR(12), @PodNo VARCHAR(30)
,@CourierName VARCHAR(250), @DRFNo VARCHAR(15),  
@ISIN VARCHAR(25)='',@CompanyName VARCHAR(250), @Quantity int, @NoOfCertificates int,
@CreatedBy VARCHAR(35)=''
AS  
BEGIN  
DECLARE @PodId int, @DRFId int  
  
Select DISTINCT DRFNo,DRFIRPD.DRFId,CompanyName,Quantity,NoOfCertificates INTO #DRFDetails  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPM.DRFId=DRFIRPD.DRFId  
WHERE ClientId = @ClientId AND DRFNo=@DRFNo AND CompanyName=@CompanyName  
AND Quantity=@Quantity AND NoOfCertificates=@NoOfCertificates --AND DRFIRPM.IsRejected=0           
  
IF(ISNULL(@ISIN,'')='')  
BEGIN  
SET @ISIN = (SELECT TOP 1 ISIN_CD FROM [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR WITH(NOLOCK) WHERE ISIN_COMP_NAME=@CompanyName)           
END  
  
IF NOT EXISTS(SELECT DRFId FROM #DRFDetails)  
BEGIN  
--IF NOT EXISTS(SELECT * FROM tbl_DRFPodInwordRegistrationProcess WITH(NOLOCK) WHERE PodNo = @PodNo)  
--BEGIN  
INSERT INTO tbl_DRFPodInwordRegistrationProcess Values(@PodNo,@CourierName,GETDATE())  
SET @PodId = SCOPE_IDENTITY()  
IF NOT EXISTS(SELECT * FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo = @DRFNo)  
BEGIN  
  
INSERT INTO tbl_DRFInwordRegistrationProcessMaster Values (@PodId,@DRFNo,@ClientId,@NoOfCertificates,0,'',GETDATE(),@ClientName,@MobileNo)  
SET @DRFId = SCOPE_IDENTITY()  
INSERT INTO tbl_DRFInwordRegistrationProcessDetails   
Values(@DRFId,UPPER(@ISIN),@CompanyName,@Quantity,'','',GETDATE(),0,@CreatedBy,'')  

INSERT INTO tbl_RejectedDRFOutwordProcessAndResponseDetails
VALUES(@DRFId,0,'','',0,'','','','','','',0,'','','','','','','','','','','','','')
END  
--ELSE  
--BEGIN  
--SET @DRFId = (SELECT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFNo = @DRFNo)  
--INSERT INTO tbl_DRFInwordRegistrationProcessDetails   
--Values(@DRFId,@CompanyName,@Quantity,'','',GETDATE(),0,'Test','')  
--END  
--END  
--ELSE  
--BEGIN  
--SET @PodId = (SELECT PodId FROM tbl_DRFPodInwordRegistrationProcess WITH(NOLOCK) WHERE PodNo = @PodNo)  
--IF NOT EXISTS(SELECT * FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo = @DRFNo )  
--BEGIN  
--INSERT INTO tbl_DRFInwordRegistrationProcessMaster Values (@PodId,@DRFNo,@ClientId,@NoOfCertificates,0,'',GETDATE(),@ClientName,@MobileNo) 
--SET @DRFId = SCOPE_IDENTITY()  
--INSERT INTO tbl_DRFInwordRegistrationProcessDetails   
--Values(@DRFId,@ISIN,@CompanyName,@Quantity,'','',GETDATE(),0,@CreatedBy,'')  

--INSERT INTO tbl_RejectedDRFOutwordProcessAndResponseDetails
--VALUES(@DRFId,0,'','',0,'','','','','','',0,'','','','','','','','','','','','','')   
--END  
----ELSE  
----BEGIN            
----SET @DRFId = (SELECT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFNo = @DRFNo)          
----INSERT INTO tbl_DRFInwordRegistrationProcessDetails   
----Values(@DRFId,@CompanyName,@Quantity,'','',GETDATE(),0,'Test','')  
----END  
--END  
END          
        
CREATE TABLE #ClientDetails        
(        
 ClientId varchar(35),ClientCode varchar(15), ClientName varchar(255)    
, SBTag varchar(15), PANNO varchar(15), MobileNo varchar(15),email VARCHAR(255)          
)        
        
--INSERT INTO #ClientDetails        
--EXEC [AGMUBODPL3].DMAT.dbo.[USP_GetDRFProcessClientDetails] @ClientId        
      
INSERT INTO #ClientDetails      
SELECT * FROM (       
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'   
FROM [AGMUBODPL3].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE  = @ClientId   
UNION    
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [AngelDP5].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE  = @ClientId            
UNION
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [ATMUMBODPL03].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE =@ClientId       

  UNION
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [AOPR0SPSDB01].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE =@ClientId     
 UNION
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [ABVSDP204].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE =@ClientId  

 /*    
  -- GPX Server    
  
 UNION
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [10.253.78.167,13442].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE =@ClientId     
 
   -- Commanted -NTT Server      
  UNION
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'    
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'      
FROM [ANGELDP203].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)      
 WHERE TBLCM.CLIENT_CODE =@ClientId       
   */
   --10.254.33.93,13442
        
 )AA        
      
        
/*  -- old Query  
SELECT * INTO #ClientDetails FROM(   
 SELECT DISTINCT TBLCM.FIRST_HOLD_NAME 'ClientName',EMAIL_ADD 'email'   
 , TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'ClientCode','' 'SBTag'            
FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)          
 WHERE TBLCM.CLIENT_CODE = @ClientId           
UNION          
SELECT DISTINCT TBLCM.FIRST_HOLD_NAME 'ClientName',EMAIL_ADD 'email'   
 , TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'ClientCode','' 'SBTag'            
FROM [172.31.16.141].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)          
 WHERE TBLCM.CLIENT_CODE =@ClientId
 )A         
 */        
   
--SELECT * INTO #ClientDetails1 FROM (   
--SELECT long_name,email,CltDpId1 'ClientId',cl_code 'ClientCode', 
--sub_broker 'SBTag' 
--FROM anand1.msajag.dbo.client_details AMCD WITH(NOLOCK) WHERE CltDpId1 = @ClientId 
--UNION          
--SELECT long_name,email,CltDpId2 'ClientId',cl_code 'ClientCode' , 
--sub_broker 'SBTag' 
--FROM anand1.msajag.dbo.client_details AMCD WITH(NOLOCK) WHERE CltDpId2 = @ClientId 
--)A 
            

--IF EXISTS(SELECT * FROM #ClientDetails1)
--BEGIN
--INSERT INTO #ClientDetails
--SELECT * FROM #ClientDetails1
--END
--ELSE
--BEGIN
--DECLARE @CltCode VARCHAR(15)= (SELECT DISTINCT ClientCode FROM [172.31.16.94].dmat.dbo.ClientDRFDPAccountDetails WITH(NOLOCK))

--INSERT INTO #ClientDetails
--SELECT AMCD.long_name,AMCD.email,@ClientId 'ClientId',AMCD.cl_code 'ClientCode', 
--AMCD.sub_broker 'SBTag'
--FROM anand1.msajag.dbo.client_details AMCD WITH(NOLOCK) 
--WHERE cl_code =  @CltCode
--END

          
SELECT DISTINCT DRFNo,DRFIRPD.DRFId,DRFIRPM.ClientId, AMCD.ClientName 'ClientName'          
,CompanyName,Quantity,NoOfCertificates , AMCD.ClientCode,   AMCD.SBTag,  
CONVERT(VARCHAR(11),DRFIRPM.InwordProcessDate,113) 'ProcessDate'  ,           
AMCD.email 'EmailId'           
INTO #TEMP  
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
ON DRFIRPM.DRFId=DRFIRPD.DRFId
JOIN #ClientDetails AMCD WITH(NOLOCK)          
ON DRFIRPM.ClientId = AMCD.ClientId
WHERE DRFIRPM.ClientId = @ClientId AND DRFNo=@DRFNo AND CompanyName=@CompanyName            
AND IsReportSend=0 
           
 
IF EXISTS(SELECT * FROM #TEMP)          
BEGIN          
          
UPDATE DRFRPD SET IsReportSend=1           
FROM tbl_DRFInwordRegistrationProcessDetails DRFRPD          
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM           
ON DRFRPM.DRFId = DRFRPD.DRFId WHERE DRFRPD.IsReportSend=0          
AND DRFNo=@DRFNo   
           
INSERT INTO tbl_DRFProcessClientMailStatusDetails            
SELECT DRFId,ClientId,EmailId,1,GETDATE(),0,'',0,'',0,'',0,'',0,'',0,'',ClientCode,SBTag,0,'',0,'',0,'',0,'',0,'',0,'' FROM #TEMP           
   
DECLARE @CltCode VARCHAR(15)=(SELECT DISTINCT ISNULL(ClientCode,'') FROM #TEMP)   
   
--- Check Client Aadhar Authentication Process   
--EXEC [AGMUBODPL3].DMAT.DBO.USP_ValidateClientDRFAadharAuthenticationDetails @CltCode,@ClientId,@DRFId,@Quantity,@ISIN   
      
EXEC USP_ValidateClientDRFAadharAuthenticationDetails @CltCode,@ClientId,@DRFId,@Quantity,@ISIN   
        
          
DECLARE @xml NVARCHAR(MAX)  
DECLARE @body NVARCHAR(MAX)
DECLARE @ProcessDate VARCHAR(15) = CONVERT(VARCHAR(11),GETDATE(),113)           
DECLARE @ClientEmailId VARCHAR(255) = ( SELECT DISTINCT EmailId FROM #TEMP WHERE DRFNo=@DRFNo) 
DECLARE @Subject VARCHAR(MAX)= 'DRF Form Received'          
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','',[CompanyName] AS 'td','', [Quantity] AS 'td'           
FROM #TEMP           
           
--ORDER BY BalanceDate           
   
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))           
           
SET @body ='<p style="font-size:medium; font-family:Calibri">           
           
 <b>Dear '+@ClientName+' </b>,<br /><br />           
           
We have received your request for Dematerialisation Form of Shares on '+@ProcessDate+'. <br />
The details of your share certificate are given below:-           
           
 </H2>           
           
<table border=1   cellpadding=2 cellspacing=2>           
           
<tr style="background-color:rgb(201, 76, 76); color :White">           
           
<th> DRFNo </th> <th> Name Of Company </th> <th> Number of shares </th> '           
  
 SET @body = @body + @xml +'</table></body></html>           
 
<br />  
Your request will be sent to the Registrar & Transfer Agent (RTA) for further processing and validation.  <br />            
We will send the status of your request from time to time. <br /> <br />          
          
Kindly note that RTA takes minimum 20 to 25 working days to process the request. <br /> <br />          
          
<br />Thank you,<br />            
Team Angel One'           
           
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL      
      
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL        
           
@profile_name = 'AngelBroking',           
           
@body = @body,           
           
@body_format ='HTML',           
           
@recipients = @ClientEmailId,           
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,           
           
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',           
--@blind_copy_recipients ='jagannath@angelbroking.com;pegasusinfocorp.suraj@angelbroking.com;',           
           
@subject = @Subject;           
END
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveDRFInwordRTARejectedPodDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveDRFInwordRTARejectedPodDetails]      
@DRFId VARCHAR(20),@ClientId VARCHAR(15),@PodNo VARCHAR(25), @CourierName VARCHAR(250)    
,@DRNNo VARCHAR(25)='',@NoOfCertificatesReceived int=0 , @CreatedBy VARCHAR(35)=''    
AS      
BEGIN      
IF NOT EXISTS(SELECT * FROM DRFInwordRegistrationReceivedByRTADetails WITH(NOLOCK) WHERE DRFId=@DRFId)      
BEGIN      
INSERT INTO DRFInwordRegistrationReceivedByRTADetails      
VALUES(@DRFId,@PodNo,@CourierName,@DRNNo,@NoOfCertificatesReceived,'318883','0000',1,GETDATE(),@CreatedBy)      
       
    
SELECT DISTINCT DRFIRPM.DRFId,DRFIRPM.DRFNo, DRFIRPM.ClientName ,ClientEmailId ,    
CONVERT(VARCHAR(17),DocumentReceivedDate,113) 'ProcessDate'    
INTO #RTAReturnedDRF    
FROM DRFInwordRegistrationReceivedByRTADetails RDRFOPRD WITH(NOLOCK)        
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
ON DRFIRPM.DRFId = RDRFOPRD.DRFId      
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFPCMSD.DRFId      
WHERE RDRFOPRD.DRFId=@DRFId    
         
 IF EXISTS(SELECT * FROM #RTAReturnedDRF)        
 BEGIN       
DECLARE @body NVARCHAR(MAX)        
DECLARE @ClientEmailId VARCHAR(255)=(SELECT ClientEmailId FROM #RTAReturnedDRF)       
DECLARE @ClientName VARCHAR(255)= (SELECT ClientName FROM #RTAReturnedDRF)    
DECLARE @DRFNo VARCHAR(35)= (SELECT DRFNo FROM #RTAReturnedDRF)  
DECLARE @ProcessDate VARCHAR(17)= (SELECT ProcessDate FROM #RTAReturnedDRF)        
       
SET @body ='<p style="font-size:medium; font-family:Calibri">        
        
 <b>Dear '+@ClientName+' </b>,<br /><br />        
        
We regret to inform you that your Dematerialisation request, DRFNo : '+@DRFNo+' has been rejected by RTA and Physical share certificates     
received by Angel team from RTA on '+@ProcessDate+'.    
      
<br /><br />      
We will dispatch your rejected share certificates as soon as posibile at your registered address . <br />      
  
</H2>        
      
<br />      
      
<br />Thank you,<br />    
Team Angel One'        
        
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL 
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL   
        
@profile_name = 'AngelBroking',        
        
@body = @body,        
        
@body_format ='HTML',        
        
@recipients = @ClientEmailId,      
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,        
    
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',        
        
@subject = 'Demat Request Rejected' ;        
     
END       
END      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermadiarySBMultiLocationTagDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveIntermadiarySBMultiLocationTagDetails
@IntermediaryId bigint, @SBPanNo VARCHAR(15)='',@MobileNo VARCHAR(15)='',
@EmailId VARCHAR(255)='', @Address1 VARCHAR(355)='',@Address2 VARCHAR(355)='',
@Address3 VARCHAR(255)='',@AreaLandmark VARCHAR(255)='',@City VARCHAR(45)='',
@PinCode VARCHAR(10)='', @State VARCHAR(35)='',@Country VARCHAR(20)='',
@TagsheetMOUDocName VARCHAR(255)='',@CancellationChaqueDocName VARCHAR(255)='',
@TagsheetAddressProffDocName VARCHAR(255)='',@TagsheetApprovalDocName VARCHAR(255)='',
@ProcessBy VARCHAR(15)=''
AS
BEGIN
IF NOT EXISTS(SELECT * FROM tbl_SBMultiLocationTagGenerationMaster WITH(NOLOCK) WHERE MobileNo=@MobileNo)
BEGIN
DECLARE @SBMasterId bigint =0
SET @SBMasterId = (SELECT SBMasterId FROM tbl_IntermediarySBTagGenerationMaster WHERE IntermediaryId=@IntermediaryId)

INSERT INTO tbl_SBMultiLocationTagGenerationMaster 
VALUES(@SBMasterId,@MobileNo,@EmailId,@Address1,@Address2,@Address3,@AreaLandmark,@City,
@PinCode,@State,@Country,@TagsheetMOUDocName,@CancellationChaqueDocName,@TagsheetAddressProffDocName,
@TagsheetApprovalDocName,@ProcessBy,GETDATE())
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterAddressDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveIntermediaryMasterAddressDetails]        
(      
@IntermediaryId bigint=0,  
@AadhaarNo VARCHAR(35)='',        
@TerminalAddressLine1 VARCHAR(455)='',        
@TerminalAddressLine2 VARCHAR(455)='',        
@TerminalAddressLine3 VARCHAR(455)='',        
@TerminalAreaLandmark VARCHAR(155)='',        
@TerminalCity VARCHAR(35)='',        
@TerminalState VARCHAR(35)='',        
@TerminalPin VARCHAR(10)='',        
@TerminalCountry VARCHAR(35)='',        
@TerminalOffStdCode1 VARCHAR(10)='',        
@TerminalOffPhone1 VARCHAR(15)='',        
@TerminalOffStdCode2 VARCHAR(10)='',        
@TerminalOffPhone2 VARCHAR(15)='',        
@TerminalOffStdCode3 VARCHAR(10)='',        
@TerminalOffPhone3 VARCHAR(15)='',        
@Mobile1 VARCHAR(15)='',        
@Mobile2 VARCHAR(15)='',        
@Email VARCHAR(105)='', 
@IsCopyTerminalAddress bit=0, 
@RegisteredAddressLine1 VARCHAR(455)='',        
@RegisteredAddressLine2 VARCHAR(455)='',        
@RegisteredAddressLine3 VARCHAR(455)='',        
@RegisteredAreaLandmark VARCHAR(155)='',        
@RegisteredCity VARCHAR(35)='',        
@RegisteredState VARCHAR(35)='',        
@RegisteredPin VARCHAR(10)='',        
@RegisteredCountry VARCHAR(35)='',        
@RegisteredStdFax VARCHAR(10)='',        
@RegisteredFax VARCHAR(85)='',        
@RegisteredStdResPhone VARCHAR(10)='',        
@RegisteredResPhone VARCHAR(15)='',        
@Gender VARCHAR(10)='',        
@MaritalStatus VARCHAR(25)='',
@FatherName VARCHAR(225)='',
@SpouseName VARCHAR(255)='',
@RelationshipManager VARCHAR(255)='',        
@FGCode VARCHAR(255)='',        
@FamilyReason VARCHAR(155)='',        
@Remarks VARCHAR(MAX)='',        
@ProcessBy VARCHAR(25)='', 
@PanNo VARCHAR(15)='',        
@IsUpdate bit=0 )        
AS        
BEGIN      
IF(@IsUpdate=1)  
BEGIN  
UPDATE tbl_IntermediaryMasterAddressDetails SET AadhaarNo=@AadhaarNo,  
TerminalAddressLine1=UPPER(@TerminalAddressLine1),  
TerminalAddressLine2=UPPER(@TerminalAddressLine2),TerminalAddressLine3=UPPER(@TerminalAddressLine3),  
TerminalAreaLandmark=UPPER(@TerminalAreaLandmark),   
TerminalCity=UPPER(@TerminalCity),TerminalState=UPPER(@TerminalState),  
TerminalPin=@TerminalPin,TerminalCountry=UPPER(@TerminalCountry),  
TerminalOffStdCode1=@TerminalOffStdCode1,TerminalOffPhone1=@TerminalOffPhone1,  
TerminalOffStdCode2 =@TerminalOffStdCode2,  
TerminalOffPhone2=@TerminalOffPhone2,TerminalOffStdCode3=@TerminalOffStdCode3,  
TerminalOffPhone3=@TerminalOffPhone3,   
Mobile1=@Mobile1,Mobile2=@Mobile2,Email=UPPER(@Email), 
IsCopyTerminalAddress=@IsCopyTerminalAddress,
RegisteredAddressLine1=UPPER(@RegisteredAddressLine1),RegisteredAddressLine2=UPPER(RegisteredAddressLine2),  
RegisteredAddressLine3=UPPER(@RegisteredAddressLine3),RegisteredAreaLandmark=UPPER(RegisteredAreaLandmark),  
RegisteredCity=UPPER(@RegisteredCity),   
RegisteredState=UPPER(RegisteredState),RegisteredPin=@RegisteredPin,  
RegisteredCountry=UPPER(@RegisteredCountry),RegisteredStdFax=RegisteredStdFax,  
RegisteredFax=@RegisteredFax,RegisteredStdResPhone=@RegisteredStdResPhone,  
RegisteredResPhone=@RegisteredResPhone,Gender=@Gender,   
MaritalStatus=UPPER(@MaritalStatus),RelationshipManager=UPPER(@RelationshipManager),  
FGCode=@FGCode,FamilyReason=UPPER(@FamilyReason),   
FatherName =UPPER(@FatherName),SpouseName =UPPER(@SpouseName),
LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()   
WHERE IntermediaryId = @IntermediaryId  
  
END  
ELSE  
BEGIN  
SET @IntermediaryId = (SELECT MAX(IntermediaryId) FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)      
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterAddressDetails WHERE IntermediaryId=@IntermediaryId)        
BEGIN        
INSERT INTO tbl_IntermediaryMasterAddressDetails        
VALUES(@IntermediaryId,        
@AadhaarNo,UPPER(@TerminalAddressLine1) ,UPPER(@TerminalAddressLine2) ,UPPER(@TerminalAddressLine3),        
UPPER(@TerminalAreaLandmark),UPPER(@TerminalCity),UPPER(@TerminalState),@TerminalPin,UPPER(@TerminalCountry),        
@TerminalOffStdCode1,@TerminalOffPhone1,@TerminalOffStdCode2,@TerminalOffPhone2,        
@TerminalOffStdCode3,@TerminalOffPhone3,@Mobile1,@Mobile2,UPPER(@Email),@IsCopyTerminalAddress,UPPER(@RegisteredAddressLine1),        
UPPER(@RegisteredAddressLine2) ,UPPER(@RegisteredAddressLine3) ,UPPER(@RegisteredAreaLandmark),UPPER(@RegisteredCity) ,        
UPPER(@RegisteredState),@RegisteredPin,UPPER(@RegisteredCountry),@RegisteredStdFax ,@RegisteredFax,        
@RegisteredStdResPhone,@RegisteredResPhone ,@Gender ,@MaritalStatus,UPPER(@FatherName),UPPER(@SpouseName),@RelationshipManager,        
@FGCode,UPPER(@FamilyReason),UPPER(@Remarks) ,UPPER(@ProcessBy),GETDATE(),'','','','')        
END        
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterBankAndSegmentDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveIntermediaryMasterBankAndSegmentDetails  
(          
@IntermediaryId bigint=0,      
@IFSC_RTGS_NEFTCode VARCHAR(55)='',  
@BankName VARCHAR(225)='',  
@Branch VARCHAR(50)='',  
@Address VARCHAR(MAX)='',  
@AccountType VARCHAR(10)='',  
@AccountNo VARCHAR(20)='',  
@MICRNo VARCHAR(105)='',  
@NameInBank VARCHAR(155)='',  
    
@BSE_CASH bit=0,  
@BSE_FO bit=0,  
@NSE_CASH bit=0,  
@NSE_FO bit=0, 
@MutualFund bit=0, 
    
@NCDEX_FO bit=0,  
@MCX_FO bit=0,  
    
@BSE_CDX bit=0,  
@NSE_CDX bit=0,  
@RegnFees decimal(17,2)=0,  
@ProcessBy VARCHAR(25)='',      
@PanNo VARCHAR(15)='',      
@IsUpdate bit=0       
)          
AS  
BEGIN  
IF(@IsUpdate=1)      
BEGIN      
UPDATE tbl_IntermediaryMasterBankDetails SET       
IFSC_RTGS_NEFTCode=@IFSC_RTGS_NEFTCode,BankName=UPPER(@BankName),      
Branch=UPPER(@Branch),Address=UPPER(@Address),      
AccountType=UPPER(@AccountType),AccountNo=@AccountNo,MICRNo=@MICRNo,      
NameInBank=UPPER(@NameInBank),LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()      
WHERE IntermediaryId=@IntermediaryId      
      
UPDATE tbl_IntermediaryMasterSegmentDetails SET      
BSE_CASH=@BSE_CASH,BSE_FO=@BSE_FO,NSE_CASH=@NSE_CASH,NSE_FO=@NSE_FO,MutualFund=@MutualFund,    
NCDEX_FO=@NCDEX_FO, MCX_FO=@MCX_FO,BSE_CDX=@BSE_CDX,NSE_CDX=@NSE_CDX  ,    
LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()      
WHERE IntermediaryId=@IntermediaryId      
  
IF EXISTS(SELECT * FROM tbl_IntermediaryMasterDepositAndFeesDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)  
BEGIN  
UPDATE tbl_IntermediaryMasterDepositAndFeesDetails SET RegnFees=@RegnFees  
WHERE IntermediaryId=@IntermediaryId  
END  
      
END      
ELSE      
BEGIN      
SET @IntermediaryId = (SELECT MAX(IntermediaryId) FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)          
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterBankDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)  
BEGIN  
INSERT INTO tbl_IntermediaryMasterBankDetails   
VALUES(@IntermediaryId,@IFSC_RTGS_NEFTCode,UPPER(@BankName),UPPER(@Branch),UPPER(@Address)        
,UPPER(@AccountType),@AccountNo,  
@MICRNo,UPPER(@NameInBank),UPPER(@ProcessBy),GETDATE(),'','','','')  
  
INSERT INTO tbl_IntermediaryMasterSegmentDetails   
VALUES(@IntermediaryId,@BSE_CASH,@BSE_FO,@NSE_CASH,@NSE_FO,@MutualFund,    
@NCDEX_FO,@MCX_FO,@BSE_CDX,@NSE_CDX,  
'',@ProcessBy,GETDATE(),'','','','')  
END  
END        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterBrokerageDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveIntermediaryMasterBrokerageDetails]        
(      
@IntermediaryId bigint=0,  
@SubBrokerShares decimal(17,2)=0,        
@Intraday_MinToClient VARCHAR(15)='',        
@NSE_Nifty decimal(17,2)=0,        
@NSEBankNifty decimal(17,2)=0,        
@NSE_FIN_Nifty decimal(17,2)=0,        
@NSE_StockOption decimal(17,2)=0,        
@Delivery_MinToClient VARCHAR(15)='',        
@NSECurrencyOption decimal(17,2)=0,        
@MCXOption decimal(17,2)=0,   
@CommodityCurrencyFuture VARCHAR(15)='',
@IsDefaultSharesToSB bit=0,        
@Remarks VARCHAR(255)='',        
@ProcessBy VARCHAR(25)='',  
@PanNo VARCHAR(15)='',  
@IsUpdate bit=0  
)      
AS        
BEGIN        
IF(@IsUpdate=1)      
BEGIN  
UPDATE tbl_IntermediaryMasterBrokerageDetails   
SET IsDefaultSharesToSB=@IsDefaultSharesToSB,  
LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()  
WHERE IntermediaryId=@IntermediaryId  
END  
ELSE  
BEGIN  
SET @IntermediaryId = (SELECT MAX(IntermediaryId) FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)      
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterBrokerageDetails WHERE IntermediaryId=@IntermediaryId)        
BEGIN        
INSERT INTO tbl_IntermediaryMasterBrokerageDetails        
VALUES(@IntermediaryId,@SubBrokerShares,@Intraday_MinToClient,@NSE_Nifty,@NSEBankNifty,        
@NSE_FIN_Nifty,@NSE_StockOption,@Delivery_MinToClient,@NSECurrencyOption,@MCXOption,        
@CommodityCurrencyFuture,@IsDefaultSharesToSB,UPPER(@Remarks),UPPER(@ProcessBy),GETDATE(),'','','','')        
END        
END        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterCSOVerificationProcess
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveIntermediaryMasterCSOVerificationProcess  
@IntermediaryId bigint=0 ,  
@ProcessStatus VARCHAR(15)='',  
@ProcessRemarks VARCHAR(MAX)='',  
@ProcessBy VARCHAR(15)=''  
AS  
BEGIN  
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryCSOVerificationMaster WHERE IntermediaryId=@IntermediaryId)  
BEGIN  
INSERT INTO tbl_IntermediaryCSOVerificationMaster  
VALUES(@IntermediaryId,CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END,@ProcessStatus,@ProcessRemarks,@ProcessBy,GETDATE(),'','')  
END  
ELSE
BEGIN
UPDATE tbl_IntermediaryCSOVerificationMaster 
SET ISApproved=(CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END),
ProcessStatus=@ProcessStatus,
ProcessRemarks=@ProcessRemarks ,EditBy=@ProcessBy,EditDate=GETDATE() 
WHERE IntermediaryId=@IntermediaryId
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterDepositAndFeesDetails
-- --------------------------------------------------

CREATE PROC [dbo].[USP_SaveIntermediaryMasterDepositAndFeesDetails]        
@IntermediaryId bigint=0 ,  
@TypeOfSB VARCHAR(15)='',        
@Deposit decimal(17,2)=0,        
@ActualDeposit decimal(17,2)=0,        
@Balance decimal(17,2)=0,        
@ApprovalForLowDeposit VARCHAR(MAX)='',        
---@UploadApprovalDocument image=null,        
@ApprovalDocFileName VARCHAR(255)='',        
@RegnFees decimal(17,2)=0,        
@Remarks VARCHAR(255)='',        
@ProcessBy VARCHAR(25)='',  
@PanNo VARCHAR(15)='',  
@IsUpdate bit=0  
AS        
BEGIN        
IF(@IsUpdate=1)  
BEGIN  
UPDATE tbl_IntermediaryMasterDepositAndFeesDetails SET   
TypeOfSB=UPPER(@TypeOfSB),Deposit=@Deposit,ActualDeposit=@ActualDeposit,  
Balance=@Balance,RegnFees=@RegnFees,  
Remarks=UPPER(@Remarks),LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()  
WHERE IntermediaryId=@IntermediaryId  
  
END  
ELSE  
BEGIN  
SET @IntermediaryId = (SELECT DISTINCT IntermediaryId FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)      
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterDepositAndFeesDetails WHERE IntermediaryId=@IntermediaryId)        
BEGIN        
INSERT INTO tbl_IntermediaryMasterDepositAndFeesDetails        
VALUES(@IntermediaryId,UPPER(@TypeOfSB),@Deposit,@ActualDeposit,@Balance,UPPER(@ApprovalForLowDeposit),        
@ApprovalDocFileName,@RegnFees,UPPER(@Remarks),UPPER(@ProcessBy),GETDATE(),'','','','')        
END        
END   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterGeneralDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveIntermediaryMasterGeneralDetails                    
(                  
@IntermediaryId bigint=0,              
@Company VARCHAR(25)='',                  
@IntermediaryCode VARCHAR(35)='',                    
@IntermediaryName VARCHAR(255)='',                    
@TradeName VARCHAR(255)='',                    
@TradeNameInCommodities VARCHAR(255)='',                    
@PanNo VARCHAR(10)='',                    
@DOB_IncorporationDate VARCHAR(10)='',                    
@Region VARCHAR(25)='',                    
@IntermediaryType VARCHAR(45)='',                     
@BranchName VARCHAR(155)='',                    
@DateIntroduced VARCHAR(10)='',                    
@IntroducedByIntermediary_Branch VARCHAR(200)='',                    
@BusinessType VARCHAR(50)='',                    
@Zone VARCHAR(45)='',                    
@IntermediaryStatus VARCHAR(55)='',                    
@GSTNo VARCHAR(155)='',                    
@Parent VARCHAR(255)='',                    
@IntroducedByEmployee VARCHAR(55)='',                    
@Notes VARCHAR(MAX)='',              
@NoOfPartners_Directors int=0,          
@Remarks VARCHAR(255)='',                    
@ProcessBy VARCHAR(25)='',              
@IsUpdate bit=0              
)                    
AS                    
BEGIN       
    
SET @Company = (SELECT CompanyId FROM tbl_SubBrokerOnBoardingCompanyMaster WHERE CompanyName=@Company)      
    
IF(@IsUpdate=1)              
BEGIN              
              
SET @DOB_IncorporationDate = CAST(CONVERT(datetime,@DOB_IncorporationDate,103) as date)                  
SET @DateIntroduced = CAST(CONVERT(datetime,@DateIntroduced,103) as date)         
    
                  
UPDATE tbl_IntermediaryMasterGeneralDetails SET               
CompanyId=@Company,IntermediaryName=UPPER(@IntermediaryName),TradeName=UPPER(@TradeName),               
PanNo=UPPER(@PanNo),DOB_IncorporationDate=@DOB_IncorporationDate,        
BranchName=UPPER(@BranchName),        
Region=UPPER(@Region),IntermediaryType=UPPER(@IntermediaryType),                
IntroducedByIntermediary_Branch=UPPER(@IntroducedByIntermediary_Branch),              
BusinessType=UPPER(@BusinessType),Zone=UPPER(@Zone),IntermediaryStatus=UPPER(@IntermediaryStatus),              
GSTNo=UPPER(@GSTNo),Parent=UPPER(@Parent), NoOfPartners_Directors=@NoOfPartners_Directors ,            
IntroducedByEmployee=UPPER(@IntroducedByEmployee),              
LastEditBy=UPPER(@ProcessBy),LastEditDate=GETDATE()              
WHERE IntermediaryId = @IntermediaryId      
  
SELECT @IntermediaryCode  
END              
ELSE              
BEGIN              
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterGeneralDetails WHERE ISNULL(PanNo,'')=@PanNo)                    
BEGIN                    
  
DECLARE @MaxNo int =0                  
SET @DOB_IncorporationDate = CAST(CONVERT(datetime,@DOB_IncorporationDate,103) as date)                  
SET @DateIntroduced = CAST(CONVERT(datetime,@DateIntroduced,103) as date)          
  
SET @MaxNo =(SELECT TOP 1 CAST(SUBSTRING(IntermediaryCode,9,12) as bigint)  FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK)   
WHERE CAST(ProcessDate as date) = CAST(GETDATE() as date)  
order by IntermediaryId desc)  
  
SET @IntermediaryCode =  
CAST(REPLACE(CONVERT(VARCHAR(10),GETDATE(),111),'/','')+ (REPLICATE('0',4-LEN(RTRIM(ISNULL(@MaxNo,0)))) + RTRIM(ISNULL(@MaxNo,0))) as bigint)+1   
  
INSERT INTO tbl_IntermediaryMasterGeneralDetails                    
VALUES(UPPER(@Company),@IntermediaryCode ,UPPER(@IntermediaryName) ,UPPER(@TradeName)                
,UPPER(@TradeNameInCommodities) ,                    
UPPER(@PanNo) ,@DOB_IncorporationDate,UPPER(@Region) ,UPPER(@IntermediaryType) ,                     
UPPER(@BranchName),@DateIntroduced,UPPER(@IntroducedByIntermediary_Branch) ,                    
UPPER(@BusinessType) ,UPPER(@Zone) ,UPPER(@IntermediaryStatus),UPPER(@GSTNo)                
,UPPER(@Parent),                    
UPPER(@IntroducedByEmployee),UPPER(@Notes),@NoOfPartners_Directors,UPPER(@Remarks),UPPER(@ProcessBy),GETDATE(),'','','','')                    
  
SELECT @IntermediaryCode  
END                    
END  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterMultiPartnersDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveIntermediaryMasterMultiPartnersDetails]        
(    
@IntermediaryId bigint=0,        
@PartnersName VARCHAR(255)='',        
@PartnerDOB VARCHAR(10)='',        
@PartnerPanNo VARCHAR(15)='',        
@PartnerGender VARCHAR(10)='',        
@PartnerDesignation VARCHAR(250)='',        
@EducationalQualification VARCHAR(250)='',        
@PartnerFatherName VARCHAR(250)='',        
@Husband_WifeName VARCHAR(250)='',        
@PartnerAddressLine1 VARCHAR(450)='',        
@PartnerAddressLine2 VARCHAR(450)='',        
@PartnerAddressLine3 VARCHAR(450)='',        
@Occupation VARCHAR(255)='',        
@PercentageShareHolding VARCHAR(15)='',        
@CapitalMarketExperience VARCHAR(15)='',        
@AreaLandmark VARCHAR(250)='',        
@PinCode VARCHAR(10)='',        
@City VARCHAR(30)='',        
@State VARCHAR(30)='',        
@Country VARCHAR(30)='',        
@AadharNo VARCHAR(15)='',        
@MobileNo VARCHAR(12)='',        
@EmailId VARCHAR(125)='',        
@PEPType VARCHAR(10)='',        
@PEPDocFileName VARCHAR(150)='',    
@PanCardFileName VARCHAR(150)='',     
@AddressProffFileName VARCHAR(150)='',     
@EducationProffFileName VARCHAR(150)='',     
@OtherDocFileName VARCHAR(150)='',    
@ProcessBy VARCHAR(15)='',        
@PanNo VARCHAR(15)='',        
@IsUpdate bit=0        
)        
AS        
BEGIN       
SET @PartnerDOB= CAST(CONVERT(datetime,@PartnerDOB,103) as date)    
SET @IntermediaryId = (SELECT MAX(IntermediaryId) FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)                
IF(@IsUpdate=1)        
BEGIN     
IF EXISTS(SELECT * FROM tbl_IntermediaryMasterMultiPartnersDetails WHERE PartnerPanNo=@PartnerPanNo)  
BEGIN  
UPDATE tbl_IntermediaryMasterMultiPartnersDetails SET PartnersName=UPPER(@PartnersName),        
PartnerDOB = @PartnerDOB,PartnerPanNo=UPPER(@PartnerPanNo),PartnerGender=UPPER(@PartnerGender),        
PartnerDesignation=UPPER(@PartnerDesignation),EducationalQualification=UPPER(@EducationalQualification),        
PartnerFatherName=UPPER(@PartnerFatherName),Husband_WifeName=UPPER(@Husband_WifeName),        
PartnerAddressLine1=UPPER(@PartnerAddressLine1),PartnerAddressLine2=UPPER(@PartnerAddressLine2)        
,PartnerAddressLine3=UPPER(@PartnerAddressLine3),Occupation=UPPER(@Occupation),        
PercentageShareHolding=UPPER(@PercentageShareHolding),CapitalMarketExperience=UPPER(@CapitalMarketExperience),        
AreaLandmark=UPPER(@AreaLandmark),PinCode=UPPER(@PinCode),City= UPPER(@City),State =UPPER(@State),Country =UPPER(@Country),        
AadharNo =@AadharNo,MobileNo =@MobileNo,EmailId =UPPER(@EmailId),PEPType =UPPER(@PEPType),        
PEPDocFileName =CASE WHEN @PEPDocFileName='' THEN ISNULL(PEPDocFileName,'') ELSE @PEPDocFileName END
,PanCardFileName=CASE WHEN @PanCardFileName ='' THEN ISNULL(PanCardFileName,'') ELSE @PanCardFileName END  
,AddressProffFileName=CASE WHEN @AddressProffFileName ='' THEN ISNULL(AddressProffFileName,'') ELSE @AddressProffFileName END
,EducationProffFileName=CASE WHEN @EducationProffFileName ='' THEN ISNULL(EducationProffFileName,'') ELSE @EducationProffFileName END 
,OtherDocFileName=@OtherDocFileName,EditDate=GETDATE(),        
EditBy =@ProcessBy WHERE IntermediaryId=@IntermediaryId AND PartnerPanNo=@PartnerPanNo        
END  
ELSE  
BEGIN  
INSERT INTO tbl_IntermediaryMasterMultiPartnersDetails        
VALUES(@IntermediaryId,UPPER(@PartnersName),@PartnerDOB,UPPER(@PartnerPanNo),UPPER(@PartnerGender)        
,UPPER(@PartnerDesignation),UPPER(@EducationalQualification),UPPER(@PartnerFatherName),UPPER(@Husband_WifeName)         
,UPPER(@PartnerAddressLine1),UPPER(@PartnerAddressLine2),UPPER(@PartnerAddressLine3),UPPER(@Occupation)        
,@PercentageShareHolding ,UPPER(@CapitalMarketExperience),UPPER(@AreaLandmark),@PinCode,UPPER(@City),UPPER(@State),        
UPPER(@Country),@AadharNo,@MobileNo,UPPER(@EmailId),UPPER(@PEPType),@PEPDocFileName  
,@PanCardFileName,@AddressProffFileName,@EducationProffFileName,@OtherDocFileName  
,@ProcessBy,GETDATE(),'','','','')    
END  
END        
ELSE        
BEGIN        
  
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterMultiPartnersDetails WHERE PartnerPanNo=@PartnerPanNo)                  
BEGIN        
INSERT INTO tbl_IntermediaryMasterMultiPartnersDetails        
VALUES(@IntermediaryId,UPPER(@PartnersName),@PartnerDOB,UPPER(@PartnerPanNo),UPPER(@PartnerGender)        
,UPPER(@PartnerDesignation),UPPER(@EducationalQualification),UPPER(@PartnerFatherName),UPPER(@Husband_WifeName)         
,UPPER(@PartnerAddressLine1),UPPER(@PartnerAddressLine2),UPPER(@PartnerAddressLine3),UPPER(@Occupation)        
,@PercentageShareHolding ,UPPER(@CapitalMarketExperience),UPPER(@AreaLandmark),@PinCode,UPPER(@City),UPPER(@State),        
UPPER(@Country),@AadharNo,@MobileNo,UPPER(@EmailId),UPPER(@PEPType),@PEPDocFileName  
,@PanCardFileName,@AddressProffFileName,@EducationProffFileName,@OtherDocFileName  
,@ProcessBy,GETDATE(),'','','','')        
END        
END        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterOccuptionDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveIntermediaryMasterOccuptionDetails]          
@IntermediaryId bigint=0 ,    
@PreviouslyAffiliated VARCHAR(15) ='',          
@NameOfBroker VARCHAR(255)='',          
@Occupation VARCHAR(155) ='',          
@OccupationDetails VARCHAR(255)='',          
@CapitalMarketExperience VARCHAR(15)='',          
@TotalExperience VARCHAR(15)='',          
@Networth VARCHAR(15)='',          
@ClientBase VARCHAR(15)='',          
@OfficeSpace VARCHAR(205)='',          
@TerminalRequried VARCHAR(5)='',          
@OfficeType VARCHAR(15)='',  
@EducationQualification VARCHAR(18)='',  
@ProcessBy VARCHAR(25)='' ,    
@PanNo VARCHAR(15)='' ,    
@IsUpdate bit=0    
AS          
BEGIN          
IF(@IsUpdate=1)    
BEGIN    
UPDATE tbl_IntermediaryMasterOccuptionDetails SET     
PreviouslyAffiliated=UPPER(@PreviouslyAffiliated),NameOfBroker=UPPER(@NameOfBroker),    
Occupation=UPPER(@Occupation),OccupationDetails=UPPER(@OccupationDetails),    
CapitalMarketExperience=@CapitalMarketExperience,TotalExperience=@TotalExperience,    
Networth=@Networth,ClientBase=@ClientBase,OfficeSpace=@OfficeSpace,    
TerminalRequried=@TerminalRequried,OfficeType=@OfficeType,  
EducationQualification=@EducationQualification  
,LastEditBy=UPPER(@ProcessBy),    
LastEditDate=GETDATE() WHERE IntermediaryId=@IntermediaryId    
    
END    
ELSE    
BEGIN    
SET @IntermediaryId = (SELECT MAX(IntermediaryId) FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo=@PanNo)        
        
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterOccuptionDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)          
BEGIN          
INSERT INTO tbl_IntermediaryMasterOccuptionDetails          
VALUES(@IntermediaryId,UPPER(@PreviouslyAffiliated),UPPER(@NameOfBroker),UPPER(@Occupation),UPPER(@OccupationDetails),          
@CapitalMarketExperience,@TotalExperience,@Networth,@ClientBase,@OfficeSpace,          
@TerminalRequried,@OfficeType,@EducationQualification,UPPER(@ProcessBy),GETDATE(),'','','','')          

IF NOT EXISTS(SELECT * FROM tbl_IntermediarySBTagGenerationUploadedDocumentsDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)
BEGIN
INSERT INTO tbl_IntermediarySBTagGenerationUploadedDocumentsDetails
VALUES(@IntermediaryId,0,'','',0,'','',0,'','',0,'','',0,'','',0,'','',0,'','',0,'','',
0,'','',0,'','',0,'','',0,'','',0,'','',0,'','',0,'','',0,'','')

END
END          
END     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterPLVCProcess
-- --------------------------------------------------
 
CREATE PROCEDURE USP_SaveIntermediaryMasterPLVCProcess      
@IntermediaryId bigint=0 ,      
@ProcessStatus VARCHAR(15)='',      
@ProcessRemarks VARCHAR(MAX)='',      
@ProcessBy VARCHAR(15)=''      
AS      
BEGIN      
IF NOT EXISTS(SELECT * FROM tbl_IntermediaryMasterPLVCProcess WHERE IntermediaryId=@IntermediaryId)      
BEGIN      
INSERT INTO tbl_IntermediaryMasterPLVCProcess      
VALUES(@IntermediaryId,CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END,@ProcessStatus,@ProcessRemarks,@ProcessBy,GETDATE(),'','')      

Update tbl_IntermediaryMasterGeneralDetails SET 
Remarks= (CASE WHEN @ProcessStatus ='Reject' THEN '2' ELSE '0' END)
WHERE IntermediaryId = @IntermediaryId
END      
ELSE    
BEGIN    
UPDATE tbl_IntermediaryMasterPLVCProcess    
SET IsApproved=(CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END),  
ProcessStatus=@ProcessStatus,  
ProcessRemarks=@ProcessRemarks ,EditBy=@ProcessBy,EditDate=GETDATE()     
WHERE IntermediaryId=@IntermediaryId   

Update tbl_IntermediaryMasterGeneralDetails SET 
Remarks= (CASE WHEN @ProcessStatus ='Reject' THEN '2' ELSE '0' END)
WHERE IntermediaryId = @IntermediaryId

END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediaryMasterSBVerificationProcess
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveIntermediaryMasterSBVerificationProcess          
@IntermediaryId bigint=0 ,          
@ProcessStatus VARCHAR(15)='',          
@ProcessRemarks VARCHAR(MAX)='',          
@ProcessBy VARCHAR(15)=''          
AS          
BEGIN     
  
DECLARE @SBPanNo VARCHAR(15) ='',@SBTag VARCHAR(10)=''  
SET @SBPanNo = (SELECT PanNo FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE IntermediaryId=@IntermediaryId)  
SET @SBTag =(SELECT SBTag FROM tbl_IntermediarySBTagGenerationMaster WHERE IntermediaryId=@IntermediaryId)   
  
IF NOT EXISTS(SELECT * FROM tbl_IntermediarySBVerificationMaster WHERE IntermediaryId=@IntermediaryId)          
BEGIN          
INSERT INTO tbl_IntermediarySBVerificationMaster          
VALUES(@IntermediaryId,CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END,@ProcessStatus,@ProcessRemarks,@ProcessBy,GETDATE(),'','')          
    
Update tbl_IntermediaryMasterGeneralDetails SET     
Remarks= (CASE WHEN @ProcessStatus ='Reject' THEN '4' ELSE '0' END)    
WHERE IntermediaryId = @IntermediaryId   
  
END          
ELSE        
BEGIN        
UPDATE tbl_IntermediarySBVerificationMaster         
SET ISApproved=(CASE WHEN @ProcessStatus='Approve' THEN 1 ELSE 0 END),        
ProcessStatus=@ProcessStatus,        
ProcessRemarks=@ProcessRemarks ,EditBy=@ProcessBy,EditDate=GETDATE()         
WHERE IntermediaryId=@IntermediaryId       
    
Update tbl_IntermediaryMasterGeneralDetails SET     
Remarks= (CASE WHEN @ProcessStatus ='Reject' THEN '4' ELSE '0' END)    
WHERE IntermediaryId = @IntermediaryId    
END        
  
  
IF(@ProcessStatus='Approve' AND ISNULL(@SBTag,'') ='')  
BEGIN  
EXEC USP_CreateAndSaveSubBrokerTagGenerationDetails @IntermediaryId,@SBPanNo ,@ProcessBy  

SET @SBTag =(SELECT SBTag FROM tbl_IntermediarySBTagGenerationMaster WHERE IntermediaryId=@IntermediaryId)

SELECT CAST(@SBTag as varchar)
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveIntermediarySBUploadedDocumentsDetails
-- --------------------------------------------------

CREATE Procedure USP_SaveIntermediarySBUploadedDocumentsDetails  
@SBPanNo VARCHAR(15)='',  
@DocumentName VARCHAR(255)='',
@DocumentFileName VARCHAR(255)='',
@IsFinalIntermediaryProcess bit=0,  
@ProcessBy VARCHAR(18)=''  
AS  
BEGIN  
DECLARE @IntermediaryId bigint=0  
SET @IntermediaryId =(SELECT DISTINCT IntermediaryId FROM tbl_IntermediaryMasterGeneralDetails WITH(NOLOCK) WHERE PanNo= @SBPanNo)  
  
IF(ISNULL(@IsFinalIntermediaryProcess,0)=1)  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsFinalIntermediaryProcess =@IsFinalIntermediaryProcess,ProcessBy=@ProcessBy,  
ProcessDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
ELSE  
BEGIN  
IF(ISNULL(@DocumentName,'')='PAN CARD')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsPANCardUpload =1, PanCardDocName =@ProcessBy,PanCardUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='AADHAR CARD (Resi.)')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsAadharCardUpload =1, AadharDocName =@ProcessBy,AadharDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Address (Off.)')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsAddressDetailsUpload =1, AddressDetailsDocName =@ProcessBy,AddressDetailsUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Education')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsEducationDetailsUpload =1, EducationDetailsDocName =@ProcessBy,EducationDetailsDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Affidavit')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsAffidavitDetailsUpload =1, AffidavitDetailsDocName =@ProcessBy,AffidavitDetailsDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='NSE Segment')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsNSESegmentDocUpload =1, NSESegmentDocName=@DocumentFileName,NSESegmentDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='BSE Segment')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsBSESegmentDocUpload =1, BSESegmentDocName =@DocumentFileName,BSESegmentDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='MCX Segment')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsMCXSegmentDocUpload =1, MCXSegmentDocName =@DocumentFileName,MCXSegmentDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='NCDEX Segment')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsNCDEXSegmentDocUpload =1, NCDEXSegmentDocName =@DocumentFileName,NCDEXSegmentDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Tagsheet_MOU')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsTagsheet_MOUDocUpload =1, Tagsheet_MOUDocName =@ProcessBy,Tagsheet_MOUDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Bank Details')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsBankDetailsUpload =1, BankDetailsDocName =@ProcessBy,BankDetailsDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Cancel Cheque')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsCancelChequeDocUpload =1, CancelChequeDocName =@ProcessBy,CancelChequeDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='Final Draft from AP_SB')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsFinalDraftFromAP_SBDocUpload =1, FinalDraftFromAP_SBDocName =@ProcessBy,FinalDraftFromAP_SBDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')='AP_SB Profiling')  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsAP_SBProfilingDocUpload =1, AP_SBProfilingDocName =@ProcessBy,AP_SBProfilingDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
IF(ISNULL(@DocumentName,'')<>'')   
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationUploadedDocumentsDetails SET  
IsOthersDocUpload =1, OthersDocName =@ProcessBy,OthersDocUploadDate=GETDATE() WHERE IntermediaryId=@IntermediaryId  
END  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveInterSegmentControlData
-- --------------------------------------------------

CREATE Procedure [dbo].[USP_SaveInterSegmentControlData]  
@InterSegmentJVCalType InterSegmentJVCalType readonly  
As  
BEGIN  
 Insert into tblInterSegmentJVCalculation (FromSegment,FromCount,FromCode,FromAmount,ToSegment,ToCount,ToCode,ToAmount,CreatedDate)  
 Select  FromSegment,FromCount,FromCode,FromAmount,ToSegment,ToCount,ToCode,ToAmount,CreatedDate from @InterSegmentJVCalType  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveInterSegmentData
-- --------------------------------------------------
Create Procedure [dbo].[USP_SaveInterSegmentData]
@InterSegmentJVType InterSegmentJVType readonly
As
BEGIN
 Insert into tblInterSegmentJV (CLTCODE,CreatedDate,FromSegment,ToSegment,FromAmount,ToAmount,Adjust,Pending)
 Select  CLTCODE,CreatedDate,FromSegment,ToSegment,FromAmount,ToAmount,Adjust,Pending from @InterSegmentJVType
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveNBFCAndEquityAdjustmentAmount
-- --------------------------------------------------
CREATE Procedure [dbo].[USP_SaveNBFCAndEquityAdjustmentAmount]      
@NBFCAndEquityAdjustmentAmountJVType NBFCAndEquityAdjustmentAmountJVType readonly      
As      
BEGIN  
 Insert into NBFCAndEquityAdjustmentAmount(CLTCODE,NBFCFundingDate,CreatedDate,FromSegment,ToSegment,FromAmount,ToAmount,Adjust,IsEquityToNBFC,IsProcess2)      
 Select  CLTCODE,NBFCFundingDate,CreatedDate,FromSegment,ToSegment,FromAmount,ToAmount,Adjust,IsEquityToNBFC,IsProcess2 from @NBFCAndEquityAdjustmentAmountJVType    

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveNBFCDownloadFileForTrack
-- --------------------------------------------------

CREATE Procedure USP_SaveNBFCDownloadFileForTrack   
@ColumnName VARCHAR(50),@IsEquityToNBFC bit
AS  
Declare @NBFCEquityColumn NVARCHAR(50)  
BEGIN  
IF Exists(Select * from NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC and CONVERT(nvarchar(50),FileDate,101) = CONVERT(nvarchar(50),GETDATE(),101))  
BEGIN  
IF(@ColumnName='KotakNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(KotakNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET KotakNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='KotakEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(KotakEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET KotakEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='HDFCNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(HDFCNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET HDFCNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='HDFCEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(HDFCEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET HDFCEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='IndusindNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(IndusindNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET IndusindNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='IndusindEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(IndusindEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) where IsEquityToNBFC=@IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET IndusindEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
  
END  
ELSE  
BEGIN  
DELETE FROM NBFCBankDownloadFileForTrack Where IsEquityToNBFC = @IsEquityToNBFC  
INSERT INTO NBFCBankDownloadFileForTrack(FileDate,IsEquityToNBFC) values(GETDATE(),@IsEquityToNBFC)  
IF(@ColumnName='KotakNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(KotakNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET KotakNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='KotakEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(KotakEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET KotakEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='HDFCNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(HDFCNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET HDFCNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='HDFCEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(HDFCEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET HDFCEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='IndusindNBFC')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(IndusindNBFC,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET IndusindNBFC = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
IF(@ColumnName='IndusindEquity')  
BEGIN  
SET @NBFCEquityColumn = (SELECT ISNULL(IndusindEquity,0) FROM NBFCBankDownloadFileForTrack WITH(NOLOCK) Where IsEquityToNBFC = @IsEquityToNBFC  )  
UPDATE NBFCBankDownloadFileForTrack SET IndusindEquity = (@NBFCEquityColumn+1) where IsEquityToNBFC=@IsEquityToNBFC  
END  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveNBFCFundingInBackOffice
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveNBFCFundingInBackOffice  
(@SearchDate VARCHAR(50),@IsProcess2 bit)    
AS  
BEGIN  
 DECLARE @Condition VARCHAR(MAX)         
IF(@SearchDate = CONVERT(VARCHAR(30),GETDATE(),101))          
BEGIN      
SET @Condition = (SELECT DISTINCT MAX(NBFCFundingDate) 'NBFCFundingDate' FROM NBFCAndEquityAdjustmentAmount WITH(NOLOCK))     
END    
ELSE    
BEGIN    
SET @Condition = CAST(@SearchDate as date)   
END    
  
  
SELECT NBFCAAM.NBFCFundingDate,NBFCAAM.CLTCODE,NBFCAAM.Adjust,NBFCAAM.CreatedDate,  
ANBFCC.CLIENTNAME,ANBFCC.BANKACCOUNTNO ,IsEquityToNBFC,  
  
 CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN 'KOTAK LTD'              
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN 'INDUSIND BANK'              
WHEN ANBFCC.BankName='HDFC' THEN 'HDFC LTD'              
END 'BankName' ,  
  
 CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN '300001'              
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN '300006'              
WHEN ANBFCC.BankName='HDFC' THEN '300002'              
END 'NBFCBankCode'              
, CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN '02086'              
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN '03031'              
WHEN ANBFCC.BankName='HDFC' THEN '02014'              
END 'EquityBankCode'   
              
, CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN 'KOTAK'              
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN 'INDUSIND BANK'              
WHEN ANBFCC.BankName='HDFC' THEN 'HDFC'              
END 'BankNameForChk'   INTO #Temp  
  
FROM NBFCAndEquityAdjustmentAmount NBFCAAM WITH(NOLOCK)           
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)           
ON NBFCAAM.CLTCODE = ANBFCC.ClientCode          
WHERE BANKName in('INDUSIND BANK LTD','KOTAK MAHINDRA BANK','HDFC')           
AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() AND IsProcess2= @IsProcess2 AND NBFCFundingDate = @Condition   
AND Adjust>=1  
  
SELECT  ROW_NUMBER() OVER(ORDER BY A.CLTCODE) 'SNO',* INTO #NBFCToEquity FROM(SELECT * FROM #Temp WHERE IsEquityToNBFC= 0)A  
SELECT  ROW_NUMBER() OVER(ORDER BY B.CLTCODE) 'SNO',* INTO #EquityToNBFC FROM (SELECT * FROM #Temp WHERE IsEquityToNBFC= 1)B  
  
IF EXISTS(SELECT * FROM #NBFCToEquity)  
BEGIN  
INSERT INTO tbl_NBFCPostData  
  
SELECT   
3 'VOUCHERTYPE',  
SNO,  
NBFCFundingDate 'VDATE',  
NBFCFundingDate 'EDATE',  
CLTCODE,  
0 'CREDITAMT',  
Adjust 'DEBITAMT',  
'LOAN DISBURSEMENT_'+BANKACCOUNTNO 'NARRATION',  
NBFCBankCode 'BANKCODE',  
'' MARGINCODE,  
BANKNAME,  
'MUMBAI' BRANCHNAME,  
'ALL' BRANCHCODE,   
'A'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',  
'D' CHEQUEMODE,  
NBFCFundingDate 'CHEQUEDATE',  
BankNameForChk 'CHEQUENAME',  
'L' CLEAR_MODE,  
BANKACCOUNTNO TPACCOUNTNUMBER,  
'NBF' EXCHANGE,  
'NBFC' SEGMENT,  
1 'MKCK_FLAG',  
'' RETURN_FLD1,  
'NBFC_Funding' RETURN_FLD2,  
'' RETURN_FLD3,  
'' RETURN_FLD4,  
'NBFC_Funding' RETURN_FLD5,  
'0' ROWSTATE,  
@IsProcess2 'IsProcess'  
FROM #NBFCToEquity  
  
INSERT INTO tbl_NBFCPostData  
SELECT   
2 'VOUCHERTYPE',  
SNO,  
NBFCFundingDate 'VDATE',  
NBFCFundingDate 'EDATE',  
CLTCODE,  
Adjust 'CREDITAMT',  
0 'DEBITAMT',  
'AMT RECD AGAINST DR_'+BANKACCOUNTNO 'NARRATION',  
EquityBankCode 'BANKCODE',  
'' MARGINCODE,  
BANKNAME,  
'MUMBAI' BRANCHNAME,  
'ALL' BRANCHCODE,   
'B'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',  
'C' CHEQUEMODE,  
NBFCFundingDate 'CHEQUEDATE',  
BankNameForChk 'CHEQUENAME',  
'L' CLEAR_MODE,  
BANKACCOUNTNO TPACCOUNTNUMBER,  
'NSE' EXCHANGE,  
'CAPITAL' SEGMENT,  
1 'MKCK_FLAG',  
'' RETURN_FLD1,  
'NBFC_Funding' RETURN_FLD2,  
'' RETURN_FLD3,  
'' RETURN_FLD4,  
'NBFC_Funding' RETURN_FLD5,  
'0' ROWSTATE,  
@IsProcess2 'IsProcess'  
FROM #NBFCToEquity  
  
END  
  
  /*
IF EXISTS(SELECT * FROM #EquityToNBFC)  
BEGIN  
INSERT INTO tbl_NBFCPostData  
  
SELECT   
3 'VOUCHERTYPE',  
SNO,  
NBFCFundingDate 'VDATE',  
NBFCFundingDate 'EDATE',  
CLTCODE,  
0 'CREDITAMT',  
Adjust 'DEBITAMT',  
'LOAN DISBURSEMENT_'+BANKACCOUNTNO 'NARRATION',  
NBFCBankCode 'BANKCODE',  
'' MARGINCODE,  
BANKNAME,  
'MUMBAI' BRANCHNAME,  
'ALL' BRANCHCODE,   
'A'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',  
'D' CHEQUEMODE,  
NBFCFundingDate 'CHEQUEDATE',  
BankNameForChk 'CHEQUENAME',  
'L' CLEAR_MODE,  
BANKACCOUNTNO TPACCOUNTNUMBER,  
'NSE' EXCHANGE,  
'CAPITAL' SEGMENT,  
1 'MKCK_FLAG',  
'' RETURN_FLD1,  
'NBFC_Funding' RETURN_FLD2,  
'' RETURN_FLD3,  
'' RETURN_FLD4,  
'NBFC_Funding' RETURN_FLD5,  
'0' ROWSTATE,  
@IsProcess2 'IsProcess'  
FROM #EquityToNBFC  
  
INSERT INTO tbl_NBFCPostData  
SELECT   
2 'VOUCHERTYPE',  
SNO,  
NBFCFundingDate 'VDATE',  
NBFCFundingDate 'EDATE',  
CLTCODE,  
Adjust 'CREDITAMT',  
0 'DEBITAMT',  
'FUND RECEIVED_'+BANKACCOUNTNO 'NARRATION',  
EquityBankCode 'BANKCODE',  
'' MARGINCODE,  
BANKNAME,  
'MUMBAI' BRANCHNAME,  
'ALL' BRANCHCODE,   
'B'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',  
'C' CHEQUEMODE,  
NBFCFundingDate 'CHEQUEDATE',  
BankNameForChk 'CHEQUENAME',  
'L' CLEAR_MODE,  
BANKACCOUNTNO TPACCOUNTNUMBER,  
'NSE' EXCHANGE,  
'CAPITAL' SEGMENT,  
1 'MKCK_FLAG',  
'' RETURN_FLD1,  
'NBFC_Funding' RETURN_FLD2,  
'' RETURN_FLD3,  
'' RETURN_FLD4,  
'NBFC_Funding' RETURN_FLD5,  
'0' ROWSTATE,  
@IsProcess2 'IsProcess'  
FROM #EquityToNBFC  
  
END  
  */

IF EXISTS(SELECT * FROM tbl_NBFCPostData WHERE CAST(VDATE as date) = CAST(@Condition as date) AND IsProcess = @IsProcess2)  
BEGIN  
-- INSERT INTO anand.MKTAPI.dbo.tbl_post_data          
-- (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE        
--,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3         
--,RETURN_FLD4,RETURN_FLD5,ROWSTATE) 
 SELECT   
 [VOUCHERTYPE],  
 [SNO],  
 [VDATE] ,  
 [EDATE] ,  
 [CLTCODE] ,  
 [CREDITAMT] ,  
 [DEBITAMT] ,  
 [NARRATION] ,  
 [BANKCODE] ,  
 [MARGINCODE],  
 [BANKNAME] ,  
 [BRANCHNAME],  
 [BRANCHCODE],  
 [DDNO] ,  
 [CHEQUEMODE] ,  
 [CHEQUEDATE] ,  
 [CHEQUENAME] ,  
 [CLEAR_MODE] ,  
 [TPACCOUNTNUMBER] ,  
 [EXCHANGE],   
 [SEGMENT],   
 [MKCK_FLAG],  
 [RETURN_FLD1],  
 [RETURN_FLD2],  
 [RETURN_FLD3],  
 [RETURN_FLD4],  
 [RETURN_FLD5],  
 [ROWSTATE]  
 FROM tbl_NBFCPostData WHERE CAST(VDATE as date) = CAST(@Condition as date) AND IsProcess = @IsProcess2  
END  
  
DROP TABLE #EquityToNBFC  
DROP TABLE #NBFCToEquity  
DROP TABLE #Temp  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveNBFCShortageInBackOffice
-- --------------------------------------------------
        
CREATE PROCEDURE USP_SaveNBFCShortageInBackOffice @SearchDate VARCHAR(50)            
AS          
BEGIN          
DECLARE @Condition VARCHAR(MAX)                 
IF(@SearchDate = CONVERT(VARCHAR(30),GETDATE(),101))                  
BEGIN              
SET @Condition = (SELECT DISTINCT MAX(MARGINDATE) FROM NBFCShortageProcessDetails WITH(NOLOCK))             
END            
ELSE            
BEGIN            
SET @Condition = CAST(@SearchDate as date)          
END            
          
SELECT ROW_NUMBER() OVER(ORDER BY B.CLTCODE)'SNO' ,* INTO #Temp FROM(          
SELECT * FROM (          
SELECT NBFCAAM.MARGINDATE,NBFCAAM.PARTY_CODE 'CLTCODE',          
CASE WHEN Cast(NBFCAAM.TOTAL_SHORTAGE as decimal(17,2)) <0 THEN Cast((NBFCAAM.TOTAL_SHORTAGE * -1) as decimal(17,2))                  
ELSE Cast(NBFCAAM.TOTAL_SHORTAGE as decimal(17,2)) END 'Adjust'          
,NBFCAAM.CREATIONDATE 'CreatedDate',          
ANBFCC.CLIENTNAME,ANBFCC.BANKACCOUNTNO ,          
          
 CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN 'KOTAK LTD'                      
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN 'INDUSIND BANK'                      
WHEN ANBFCC.BankName='HDFC' THEN 'HDFC LTD'                      
END 'BankName' ,          
          
 CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN '300001'                      
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN '300006'                      
WHEN ANBFCC.BankName='HDFC' THEN '300002'                      
END 'NBFCBankCode'                      
, CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN '02086'                      
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN '03031'                      
WHEN ANBFCC.BankName='HDFC' THEN '02014'                      
END 'EquityBankCode'           
                      
, CASE WHEN ANBFCC.BankName='KOTAK MAHINDRA BANK' THEN 'KOTAK'                      
WHEN ANBFCC.BankName='INDUSIND BANK LTD' THEN 'INDUSIND BANK'                      
WHEN ANBFCC.BankName='HDFC' THEN 'HDFC'                      
END 'BankNameForChk'             
          
FROM NBFCShortageProcessDetails NBFCAAM WITH(NOLOCK)                   
JOIN [172.31.16.57].nbfc.dbo.ANG_NBFCCLIENTS ANBFCC WITH(NOLOCK)                   
ON NBFCAAM.PARTY_CODE = ANBFCC.ClientCode                  
WHERE BANKName in('INDUSIND BANK LTD','KOTAK MAHINDRA BANK','HDFC')                   
AND ACCOUNTTYPE='POA' and INACTIVEDATE > GETDATE() AND CAST(MARGINDATE as date) = @Condition           
)A          
WHERE A.Adjust>0          
)B          
          
IF EXISTS(SELECT * FROM #Temp)          
BEGIN          
INSERT INTO tbl_NBFCShortageProcessPostData          
          
SELECT           
3 'VOUCHERTYPE',          
SNO,          
MARGINDATE 'VDATE',          
MARGINDATE 'EDATE',          
CLTCODE,          
0 'CREDITAMT',          
Adjust 'DEBITAMT',          
'LOAN DISBURSEMENT_'+BANKACCOUNTNO 'NARRATION',          
NBFCBankCode 'BANKCODE',          
'' MARGINCODE,          
BANKNAME,          
'MUMBAI' BRANCHNAME,          
'ALL' BRANCHCODE,           
'M'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',          
'D' CHEQUEMODE,          
MARGINDATE 'CHEQUEDATE',          
BankNameForChk 'CHEQUENAME',          
'L' CLEAR_MODE,          
BANKACCOUNTNO TPACCOUNTNUMBER,          
'NBF' EXCHANGE,          
'NBFC' SEGMENT,          
1 'MKCK_FLAG',          
'' RETURN_FLD1,          
'NBFC_Shortage' RETURN_FLD2,          
'' RETURN_FLD3,          
'' RETURN_FLD4,          
'NBFC_Shortage' RETURN_FLD5,          
'0' ROWSTATE          
FROM #Temp          
          
INSERT INTO tbl_NBFCShortageProcessPostData          
SELECT           
2 'VOUCHERTYPE',          
SNO,          
MARGINDATE 'VDATE',          
MARGINDATE 'EDATE',          
CLTCODE,          
Adjust 'CREDITAMT',          
0 'DEBITAMT',          
'AMT RECD AGAINST DR_'+BANKACCOUNTNO 'NARRATION',          
EquityBankCode 'BANKCODE',          
'' MARGINCODE,          
BANKNAME,          
'MUMBAI' BRANCHNAME,          
'ALL' BRANCHCODE,           
'N'+REPLACE(cast(GETDATE() as date),'-','')+format(SNO,'000') 'DDNO',          
'C' CHEQUEMODE,          
MARGINDATE 'CHEQUEDATE',          
BankNameForChk 'CHEQUENAME',          
'L' CLEAR_MODE,          
BANKACCOUNTNO TPACCOUNTNUMBER,          
'NSE' EXCHANGE,          
'CAPITAL' SEGMENT,          
1 'MKCK_FLAG',          
'' RETURN_FLD1,          
'NBFC_Shortage' RETURN_FLD2,          
'' RETURN_FLD3,          
'' RETURN_FLD4,          
'NBFC_Shortage' RETURN_FLD5,          
'0' ROWSTATE          
FROM #Temp          
          
END          
      
          
IF EXISTS(SELECT * FROM tbl_NBFCShortageProcessPostData WHERE CAST(VDATE as date) = CAST(@Condition as date))          
BEGIN          
 INSERT INTO anand.MKTAPI.dbo.tbl_post_data          
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE        
,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3         
,RETURN_FLD4,RETURN_FLD5,ROWSTATE)        
 SELECT           
   [VOUCHERTYPE],          
 [SNO],          
 [VDATE] ,          
 [EDATE] ,          
 [CLTCODE] ,          
 [CREDITAMT] ,          
 [DEBITAMT] ,          
 [NARRATION] ,          
 [BANKCODE] ,          
 [MARGINCODE],          
 [BANKNAME] ,          
 [BRANCHNAME],          
 [BRANCHCODE],          
 [DDNO] ,          
 [CHEQUEMODE] ,          
 [CHEQUEDATE] ,          
 [CHEQUENAME] ,          
 [CLEAR_MODE] ,          
 [TPACCOUNTNUMBER] ,          
 [EXCHANGE],           
 [SEGMENT],           
 [MKCK_FLAG],          
 [RETURN_FLD1],          
 [RETURN_FLD2],          
 [RETURN_FLD3],          
 [RETURN_FLD4],          
 [RETURN_FLD5],          
 [ROWSTATE]          
 FROM tbl_NBFCShortageProcessPostData WHERE CAST(VDATE as date) = CAST(@Condition as date)          
END          
          
DROP TABLE #Temp          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveRejectedDRFInwordRegistrationProcessData
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveRejectedDRFInwordRegistrationProcessData          
@ClientId VARCHAR(30)='',@ClientName VARCHAR(255)='',@MobileNo VARCHAR(12)='' , @PodNo VARCHAR(30),@CourierName VARCHAR(250), @DRFNo VARCHAR(15),          
@ISIN VARCHAR(25)='',@CompanyName VARCHAR(250), @Quantity int, @NoOfCertificates int ,  
@CreatedBy VARCHAR(35)=''  
AS          
BEGIN          
DECLARE @PodId int, @DRFId int          
          
Select DISTINCT DRFNo,DRFIRPD.DRFId,CompanyName,Quantity,NoOfCertificates INTO #DRFDetails          
FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)          
JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)          
ON DRFIRPM.DRFId=DRFIRPD.DRFId          
WHERE ClientId = @ClientId AND DRFNo=@DRFNo AND CompanyName=@CompanyName          
AND Quantity=@Quantity AND NoOfCertificates=@NoOfCertificates --AND DRFIRPM.IsRejected=0           
       
IF(ISNULL(@ISIN,'')='')      
BEGIN      
SET @ISIN = (SELECT TOP 1 ISIN_CD FROM [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR WHERE ISIN_COMP_NAME=@CompanyName)    
END      
       
IF NOT EXISTS(SELECT DRFId FROM #DRFDetails)          
BEGIN          
IF NOT EXISTS(SELECT * FROM tbl_DRFPodInwordRegistrationProcess WITH(NOLOCK) WHERE PodNo = @PodNo)          
BEGIN          
INSERT INTO tbl_DRFPodInwordRegistrationProcess Values(@PodNo,@CourierName,GETDATE())          
SET @PodId = SCOPE_IDENTITY()          
IF NOT EXISTS(SELECT * FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo = @DRFNo)          
BEGIN          
INSERT INTO tbl_DRFInwordRegistrationProcessMaster Values (@PodId,@DRFNo,@ClientId,@NoOfCertificates,1,'Invalid Client Id',GETDATE(),@ClientName,@MobileNo)          
SET @DRFId = SCOPE_IDENTITY()          
INSERT INTO tbl_DRFInwordRegistrationProcessDetails           
Values(@DRFId,@ISIN,@CompanyName,@Quantity,'1','Invalid ClientId',GETDATE(),0,@CreatedBy,'')          
          
INSERT INTO tbl_RejectedDRFOutwordProcessAndResponseDetails          
VALUES(@DRFId,0,'','',0,'','','','','','',0,'','','','','','','','','','','','','')          
END          
--ELSE          
--BEGIN          
--SET @DRFId = (SELECT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFNo = @DRFNo)          
--INSERT INTO tbl_DRFInwordRegistrationProcessDetails           
--Values(@DRFId,@CompanyName,@Quantity,'','',GETDATE(),0,'Test','')          
--END          
END          
ELSE          
BEGIN          
SET @PodId = (SELECT PodId FROM tbl_DRFPodInwordRegistrationProcess WITH(NOLOCK) WHERE PodNo = @PodNo)          
IF NOT EXISTS(SELECT * FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo = @DRFNo)          
BEGIN          
INSERT INTO tbl_DRFInwordRegistrationProcessMaster Values (@PodId,@DRFNo,@ClientId,@NoOfCertificates,1,'Invalid Client Id',GETDATE(),@ClientName,@MobileNo)          
SET @DRFId = SCOPE_IDENTITY()          
INSERT INTO tbl_DRFInwordRegistrationProcessDetails           
Values(@DRFId,@ISIN,@CompanyName,@Quantity,'1','Invalid ClientId',GETDATE(),0,@CreatedBy,'')          
          
INSERT INTO tbl_RejectedDRFOutwordProcessAndResponseDetails          
VALUES(@DRFId,0,'','',0,'','','','','','',0,'','','','','','','','','','','','','')           
END          
--ELSE          
--BEGIN          
--SET @DRFId = (SELECT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFNo = @DRFNo)          
--INSERT INTO tbl_DRFInwordRegistrationProcessDetails           
--Values(@DRFId,@CompanyName,@Quantity,'','',GETDATE(),0,'Test','')          
--END          
END          
END           
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBAddressChangesProcessDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBAddressChangesProcessDetails   
@SBTag VARCHAR(15)='',@SBPanNo VARCHAR(15)=''  
AS  
BEGIN  
IF NOT EXISTS(SELECT * FROM tbl_SBAddressChangeProcessDetails WHERE SBTag=@SBTag)  
BEGIN  
INSERT INTO tbl_SBAddressChangeProcessDetails VALUES(@SBTag,@SBPanNo,1,GETDATE(),  
'','','','','','','','','','','','','','','','','','','','','','','','','')  
END  
 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositBankingRejectionDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBDepositBankingRejectionDetails    
@SBTag VARCHAR(15),@SBPanNo VARCHAR(15),@RefNo VARCHAR(35),@VType int, @VNo VARCHAR(35), @Vdate VARCHAR(10),@Segment VARCHAR(4) ,@Reason VARCHAR(355)    
AS    
BEGIN   
DECLARE @SuspenceAccDetailsId bigint, @DepositVarificationId bigint , @DepositRefId bigint   
SET @SuspenceAccDetailsId = (SELECT SuspenceAccDetailsId FROM tbl_SBDepositSuspenceAccountDetails WITH(NOLOCK)     
WHERE VType=@VType AND VNo=@VNo AND VDate = CONVERT(datetime,@Vdate,103) AND Segment=@Segment)    
    
SET @DepositVarificationId =(SELECT DepositVarificationId FROM tbl_SBDepositVarificationAndProcessBySBTeam WITH(NOLOCK)      
WHERE SBTag=@SBTag AND SBPanNo=@SBPanNo AND RefNo= @RefNo AND SuspenceAccDetailsId=@SuspenceAccDetailsId)   
  
SET @DepositRefId =(SELECT DepositRefId FROM tbl_SBDepositVarificationAndProcessBySBTeam WITH(NOLOCK)      
WHERE SBTag=@SBTag AND SBPanNo=@SBPanNo AND RefNo= @RefNo AND SuspenceAccDetailsId=@SuspenceAccDetailsId)   

IF NOT EXISTS(SELECT * FROM tbl_SBDepositBankingVarificationProcess WHERE SuspenceAccDetailsId=@SuspenceAccDetailsId AND DepositVarificationId=@DepositVarificationId)    
BEGIN
INSERT INTO tbl_SBDepositBankingVarificationProcess     
VALUES(@SuspenceAccDetailsId,@DepositVarificationId,1,@Reason,0,GETDATE())    
  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET IsBankingRejected=1,BankingRejectionReason=@Reason  
WHERE DepositRefId= @DepositRefId  
END    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositKnockOffProcessData
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBDepositKnockOffProcessData
AS
BEGIN
INSERT INTO tbl_SBDepositProcessBOLedgerData
SELECT                           
8 'VOUCHERTYPE',                
SRNo,                
CAST(GETDATE() AS DATE) 'VDATE',                
CAST(GETDATE() AS DATE) 'EDATE',                
'5100000017' 'CLTCODE',                
0 'CREDITAMT',                
VAmount 'DEBITAMT',                
'SB Refund_' 'NARRATION',                            
'' 'BANKCODE',                
'' 'MARGINCODE',                
'' 'BANKNAME',                
'' BRANCHNAME,                
'ALL' BRANCHCODE,                 
'' 'DDNO',                
'' CHEQUEMODE,                
'' 'CHEQUEDATE',                
'' 'CHEQUENAME',                
'' CLEAR_MODE,                
'' TPACCOUNTNUMBER,                
Segment 'EXCHANGE',                
'CAPITAL' 'SEGMENT',                
1 'MKCK_FLAG',                
'' RETURN_FLD1,                
'SBDeposit' RETURN_FLD2,                
'' RETURN_FLD3,                
'' RETURN_FLD4,                
'SBDeposit' RETURN_FLD5,                
'0' ROWSTATE ,     
1 'ISKNOCKOFF_PROCESS',      
0 'ISPROCESS_STATUS'
 FROM
(SELECT ROW_NUMBER() OVER(ORDER BY KnockOffDetailsId) 'SRNo',*  FROM (
SELECT * FROM tbl_SBDepositKnockOffProcessDetails WITH(NOLOCK) WHERE IsProcessStatus=0
)AA
)BB

UPDATE tbl_SBDepositKnockOffProcessDetails SET IsProcessStatus=1 WHERE IsProcessStatus=0

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositKnockOffProcessDetails
-- --------------------------------------------------
CREATE PROCEDURE USP_SaveSBDepositKnockOffProcessDetails  
@RefId bigint, @VType int, @VNo VARCHAR(35),@VAmount decimal(17,2),@VDate VARCHAR(35),@Segment VARCHAR(5)  
,@Narration VARCHAR(500) ,@BankAccountNo VARCHAR(20), @IFSCCode VARCHAR(18),@BankName VARCHAR(35), @BranchName VARCHAR(255) 
AS  
BEGIN  
INSERT INTO tbl_SBDepositKnockOffProcessDetails   
VALUES(@RefId,@VType,@VNo,@VAmount, CONVERT(datetime,@VDate,103), @Segment,@Narration
,@BankAccountNo,@IFSCCode,@BankName,@BranchName,0,0,GETDATE(),'Test')  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositRejectionDetailsBySBTeam
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBDepositRejectionDetailsBySBTeam              
@SBPanNo VARCHAR(15),@SBTag VARCHAR(15)='',@RefNo VARCHAR(35),@DepositAmount DECIMAL(17,2),@RejectionStatus int,@SBRemarks VARCHAR(255)              
AS              
BEGIN        
IF NOT EXISTS(SELECT * FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE SBPanNo=@SBPanNo AND RefNo=@RefNo)    
BEGIN    
DECLARE @DepositRefId bigint =(SELECT DepositRefId FROM tbl_SBPayoutDepositProcessDetailsInLMS WITH(NOLOCK) WHERE SBPanNo=@SBPanNo AND RefNo=@RefNo)              
INSERT INTO tbl_SBDepositVarificationAndProcessBySBTeam              
VALUES(NULL,@DepositRefId,@SBTag,@SBPanNo,@RefNo,@DepositAmount,@RejectionStatus,@SBRemarks,GETDATE())              
              
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET IsSBRejected= @RejectionStatus, SBRejectionReason=@SBRemarks               
WHERE DepositRefId=@DepositRefId              
          
          
SELECT SBDPDLMS.SBPanNo,SBDPDLMS.SBName,SBDPDLMS.RefNo,SBDPDLMS.Amount,          
SBDVAPSBT.RejectionReason           
,CONVERT(VARCHAR(10),CreatedOn,103) 'ProcessDate' INTO #TEMP           
FROM tbl_SBPayoutDepositProcessDetailsInLMS SBDPDLMS WITH(NOLOCK)          
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVAPSBT WITH(NOLOCK)          
ON SBDPDLMS.DepositRefId = SBDVAPSBT.DepositRefId          
WHERE SBDVAPSBT.SBPanNo=@SBPanNo            
AND SBDVAPSBT.RefNo = @RefNo           
AND CAST(SBDVAPSBT.ProcessDate as date) = CAST(GETDATE() as date)          
AND SBDVAPSBT.IsSBRejected=@RejectionStatus          
                 
DECLARE @xml NVARCHAR(MAX)            
DECLARE @body NVARCHAR(MAX)                       
DECLARE @Subject VARCHAR(MAX)= 'SB Deposit Process'                    
            
 SET @xml = CAST(( SELECT [SBName] AS 'td','', [SBPanNo] AS 'td' ,'', [RefNo] AS 'td'                      
 ,'', [Amount] AS 'td','', [RejectionReason] AS 'td' ,'', [ProcessDate] AS 'td'                         
FROM #TEMP                          
                          
--ORDER BY BalanceDate                          
                          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                          
                          
SET @body ='<p style="font-size:medium; font-family:Calibri">                          
                          
 <b>Dear Team </b>,<br /><br />                          
                          
We are verify the clients details for Tag generation process but Tag generation process reject due to following reason. <br />            
Please find the details with rejection remarks.                    
                          
 </H2>                          
                          
<table border=1   cellpadding=2 cellspacing=2>                          
                          
<tr style="background-color:rgb(201, 76, 76); color :White">                          
                          
<th> SBName </th> <th> SBPanNo </th> <th> RefNo </th> <th> Amount </th> <th> Remarks </th>  <th> ProcessDate </th> '                          
                   
 SET @body = @body + @xml +'</table></body></html>                          
                 
<br />Thanks & Regards,<br /><br />                  
Angel One Ltd.  <br />                
System Generated Mail'                          
                          
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
                          
@profile_name = 'AngelBroking',                          
                          
@body = @body,                          
                          
@body_format ='HTML',                          
                          
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',                          
@recipients = 'sbregistration@angelbroking.com; suhas.raut@angelbroking.com',                          
                          
@blind_copy_recipients ='sbregistration@angelbroking.com; suhas.raut@angelbroking.com',                          
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',                          
                          
@subject = @Subject ;            
          
END    
ELSE  
BEGIN  
  
UPDATE tbl_SBDepositVarificationAndProcessBySBTeam SET IsSBRejected=@RejectionStatus,  
RejectionReason=@SBRemarks   
WHERE SBPanNo=@SBPanNo AND  RefNo=@RefNo AND DepositAmount=@DepositAmount  
  
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET IsSBRejected= @RejectionStatus, SBRejectionReason=@SBRemarks               
WHERE SBPanNo=@SBPanNo AND  RefNo=@RefNo AND Amount=@DepositAmount  
  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositSuspenceAccJVProcessInBackOffice
-- --------------------------------------------------
  
CREATE PROCEDURE [dbo].[USP_SaveSBDepositSuspenceAccJVProcessInBackOffice] @IsRefundProcess bit=0       
AS        
BEGIN        
IF EXISTS(SELECT * FROM tbl_SBDepositProcessBOLedgerData WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE) AND ISPROCESS_STATUS=0 )
BEGIN           
    
/*    
 INSERT INTO anand.MKTAPI.dbo.tbl_post_data
 (VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE          
,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3           
,RETURN_FLD4,RETURN_FLD5,ROWSTATE)          
 SELECT 
   [VOUCHERTYPE],
 [SNO],
 [VDATE] ,
 [EDATE] ,
 [CLTCODE] ,
 [CREDITAMT] ,
 [DEBITAMT] ,
 [NARRATION] ,
 [BANKCODE] ,
 [MARGINCODE],
 [BANKNAME] ,
 [BRANCHNAME],
 [BRANCHCODE],
 [DDNO] ,
 [CHEQUEMODE] ,
 [CHEQUEDATE] ,
 [CHEQUENAME] ,
 [CLEAR_MODE] ,
 [TPACCOUNTNUMBER] ,
 [EXCHANGE], 
 [SEGMENT], 
 [MKCK_FLAG],
 [RETURN_FLD1],
 [RETURN_FLD2],
 [RETURN_FLD3],
 [RETURN_FLD4],
 [RETURN_FLD5],
 [ROWSTATE]
 FROM tbl_SBDepositProcessBOLedgerData WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE)        
 AND ISPROCESS_STATUS=0  AND ISKNOCKOFF_PROCESS=@IsRefundProcess       
 */    
    
     
INSERT INTO [AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES(
VoucherType,BookType,SNo,Vdate,EDate,CltCode,CreditAmt,DebitAmt,Narration,
OppCode,MarginCode,BankName,BranchName,BranchCode,    
DDNo,ChequeMode,ChequeDate,ChequeName,Clear_Mode,TPAccountNumber,    
Exchange,Segment,TPFlag,AddDt,AddBy,StatusID,
StatusName,RowState,ApprovalFlag,ApprovalDate,ApprovedBy,VoucherNo,UploadDt
)
SELECT 
VoucherType    
,'01' 'BookType'    
,SNo    
,Vdate    
,EDate    
,CltCode,    
CreditAmt,    
DebitAmt,    
Narration ,    
[BANKCODE],    
[MARGINCODE],
[BANKNAME] ,    
[BRANCHNAME],    
[BRANCHCODE],    
[DDNO] ,    
[CHEQUEMODE] ,
[CHEQUEDATE] ,
[CHEQUENAME] ,
[CLEAR_MODE] ,
[TPACCOUNTNUMBER] ,
[EXCHANGE],     
[SEGMENT],     
''  TPFlag,    
Cast(Getdate() as date) 'AddDt',     
RETURN_FLD2 'AddBy',    
'broker' StatusID,
'broker' StatusName,    
0 'RowState',    
1 'ApprovalFlag',    
GETDATE() 'ApprovalDate',    
'' 'ApprovedBy',    
CAST(Replace(CAST(GETDATE() as date),'-','') as VARCHAR(10)) +RIGHT('000'+CAST(ISNULL(SNo,0) AS VARCHAR),4) 'VoucherNo'     
,GETDATE() 'UploadDt'    
 FROM tbl_SBDepositProcessBOLedgerData WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE)        
 AND ISPROCESS_STATUS=0  AND ISKNOCKOFF_PROCESS=@IsRefundProcess          
        
 UPDATE tbl_SBDepositProcessBOLedgerData SET ISPROCESS_STATUS=1 WHERE CAST(VDATE AS DATE) = CAST(GETDATE() AS DATE)        
 AND ISPROCESS_STATUS=0 AND ISKNOCKOFF_PROCESS=@IsRefundProcess        
 END        
 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBDepositSuspenceAccountDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBDepositSuspenceAccountDetails                
@VNo VARCHAR(35),@Segment VARCHAR(5), @SBTag VARCHAR(15), @SBPanNo VARCHAR(15),@RefNo VARCHAR(35), @Amount decimal(17,2)                
AS                
BEGIN                
DECLARE @SuspenceAccDetailsId bigint, @DepositRefId bigint                
                
SET @DepositRefId = (SELECT DepositRefId FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE SBPanNo=@SBPanNo AND RefNo=@RefNo)                
                
IF NOT EXISTS(SELECT * FROM tbl_SBDepositSuspenceAccountDetails WHERE VNo=@VNo AND Segment=@Segment)                
BEGIN                
SELECT VTYP, VNO,DRCR,VAMT,EDT, CONVERT(VARCHAR(10),VDT,103) 'VDT' ,NARRATION,'NSE' 'Segment' INTO #NSE                      
FROM [AngelNseCM].account.dbo.ledger WITH(NOLOCK)                      
WHERE EDT>'2022-06-25' and cltcode like '5100000017' AND VNo = @VNo                    
                      
SELECT VTYP, VNO,DRCR,VAMT,EDT,CONVERT(VARCHAR(10),VDT,103) 'VDT',NARRATION,'BSE' 'Segment' INTO #BSE                      
FROM [AngelBSECM].Account_AB.dbo.ledger WITH(NOLOCK)                      
WHERE EDt>'2022-06-25' and cltcode like '5100000017' AND VNo = @VNo                      
                  
SELECT * INTO #Temp FROM (                  
SELECT ROW_NUMBER() OVER(ORDER BY VTYP) 'SRNO', * FROM (                      
SELECT * FROM #NSE                      
UNION ALL                      
SELECT * FROM #BSE                      
)A                  
)B  WHERE VNo = @VNo AND Segment=@Segment             
        
DELETE FROM tbl_SBDepositVarificationAndProcessBySBTeam WHERE DepositRefId = @DepositRefId AND ISNULL(SuspenceAccDetailsId,0)=0        
                
INSERT INTO tbl_SBDepositSuspenceAccountDetails                
SELECT VTYP,VNO,VAMT,  CONVERT(datetime2, VDT,103) 'VDT',Segment, Narration,GETDATE(),'Test' FROM #Temp                
                
SET @SuspenceAccDetailsId = SCOPE_IDENTITY()                
                
INSERT INTO tbl_SBDepositVarificationAndProcessBySBTeam                
VALUES(@SuspenceAccDetailsId,@DepositRefId,@SBTag,@SBPanNo,@RefNo,@Amount,0,'',GETDATE())                
END                
ELSE                
BEGIN                
SET @SuspenceAccDetailsId = (SELECT SuspenceAccDetailsId FROM tbl_SBDepositSuspenceAccountDetails WHERE VNo=@VNo AND Segment=@Segment)                
              
IF EXISTS(SELECT * FROM tbl_SBDepositVarificationAndProcessBySBTeam WITH(NOLOCK) WHERE DepositRefId=@DepositRefId)                
BEGIN              
UPDATE tbl_SBDepositVarificationAndProcessBySBTeam SET SuspenceAccDetailsId=@SuspenceAccDetailsId, IsSBRejected=3 , RejectionReason=''               
WHERE DepositRefId=@DepositRefId               
              
              
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS               
SET IsSBRejected = (CASE WHEN ISNULL(IsSBRejected,0)=0  THEN 0               
WHEN ISNULL(IsSBRejected,0)=2  THEN 3 END),              
SBRejectionReason=(CASE WHEN ISNULL(IsSBRejected,0)=0  THEN ''               
WHEN ISNULL(IsSBRejected,0)=2  THEN '' END)              
,IsBankingRejected=(CASE WHEN ISNULL(IsBankingRejected,0)=0  THEN 0               
WHEN ISNULL(IsBankingRejected,0)=1  THEN 2 END)              
,BankingRejectionReason=(CASE WHEN ISNULL(IsBankingRejected,0)=0  THEN ''               
WHEN ISNULL(IsBankingRejected,0)=1  THEN '' END)              
WHERE DepositRefId=@DepositRefId               
              
END              
ELSE              
BEGIN              
INSERT INTO tbl_SBDepositVarificationAndProcessBySBTeam                
VALUES(@SuspenceAccDetailsId,@DepositRefId,@SBTag,@SBPanNo,@RefNo,@Amount,0,'',GETDATE())                
END                
END            
      
SELECT       
SBPDPDLMS.SBName, SBPDPDLMS.SBPanNo, SBDVAPSBT.SBTag,SBDVAPSBT.RefNo      
, SBPDPDLMS.Amount,      
SBDSAD.VType,SBDSAD.VNo,SBDSAD.VAmount,CONVERT(VARCHAR(10),SBDSAD.VDate,103) 'VDate'      
, SBDSAD.Segment, SBDSAD.Narration,      
CONVERT(VARCHAR(10),SBDSAD.ProcessDate,103) 'ProcessDate' INTO #TEST      
      
FROM tbl_SBDepositSuspenceAccountDetails SBDSAD WITH(NOLOCK)      
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVAPSBT WITH(NOLOCK)      
ON SBDSAD.SuspenceAccDetailsId = SBDVAPSBT.SuspenceAccDetailsId      
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPDLMS WITH(NOLOCK)      
ON SBPDPDLMS.DepositRefId = SBDVAPSBT.DepositRefId      
WHERE SBDVAPSBT.SBTag =@SBTag AND SBDVAPSBT.SBPanNo = @SBPanNo       
AND SBDVAPSBT.RefNo = @RefNo AND SBPDPDLMS.DepositRefId = @DepositRefId      
      
           
DECLARE @xml NVARCHAR(MAX)        
DECLARE @body NVARCHAR(MAX)                   
DECLARE @Subject VARCHAR(MAX)= 'SB Deposit Process'                
        
 SET @xml = CAST(( SELECT [SBName] AS 'td','', [SBPanNo] AS 'td','', [SBTag] AS 'td'       
 ,'', [RefNo] AS 'td'                  
 ,'', [Amount] AS 'td','', [ProcessDate] AS 'td'        
 ,'', [VType] AS 'td' ,'', [VNo] AS 'td' ,'', [VAmount] AS 'td'       
 ,'', [VDate] AS 'td' ,'', [Segment] AS 'td' ,'', [Narration] AS 'td'       
FROM #TEST                      
                      
--ORDER BY BalanceDate                      
                      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                      
                      
SET @body ='<p style="font-size:medium; font-family:Calibri">                      
                      
 <b>Dear Team </b>,<br /><br />                      
                      
New Ref Payout details received from Client for SB process,       
we are verify the details and generate the SB Tag. <br />         
Request you to please verify the SB details and start the JV process from your side. <br />      
Please find the SB Payout Details.                
                      
 </H2>                      
                      
<table border=1   cellpadding=2 cellspacing=2>                      
                      
<tr style="background-color:rgb(201, 76, 76); color :White">                      
                      
<th> SBName </th> <th> SBPanNo </th> <th> SBTag </th> <th> RefNo </th> <th> Amount </th> <th> ProcessDate </th> <th> VType </th> <th> VNo </th> <th> VAmount </th> <th> VDate </th> <th> Segment </th> <th> Narration </th> '                      
               
 SET @body = @body + @xml +'</table></body></html>                      
             
<br />Thanks & Regards,<br /><br />              
Angel One Ltd.  <br />            
System Generated Mail'                      
                      
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL                      
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL 
                      
@profile_name = 'AngelBroking',                      
                      
@body = @body,                      
                      
@body_format ='HTML',                      
                      
--@recipients = 'hemantp.patel@angelbroking.com; mishelpdesk@angelbroking.com',                      
@recipients = 'sbregistration@angelbroking.com; suhas.raut@angelbroking.com',                      
                      
@blind_copy_recipients ='sbregistration@angelbroking.com; suhas.raut@angelbroking.com',                      
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',                      
                      
@subject = @Subject ;        
      
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBKnockOffDebitedAmountProcessDetails
-- --------------------------------------------------
  
CREATE PROCEDURE USP_SaveSBKnockOffDebitedAmountProcessDetails    
@DebitVNo VARCHAR(35),@DebitSegment VARCHAR(5), @VType int, @VNo VARCHAR(35),@VAmount decimal(17,2),@VDate VARCHAR(35)  
,@Segment VARCHAR(5),@Narration VARCHAR(500),@Remarks VARCHAR(450)     
AS    
BEGIN    
    
    
SELECT VTYP, VNO,DRCR,VAMT,EDT, VDT 'VDT' ,NARRATION,'NSE' 'Segment' INTO #NSE 
FROM [AngelNseCM].account.dbo.ledger WITH(NOLOCK) 
WHERE CLTCODE = '5100000017' AND EDT >= '2022-07-01' AND DRCR = 'D'     
AND VNo= @DebitVNo                
 
SELECT VTYP, VNO,DRCR,VAMT,EDT,VDT 'VDT',NARRATION,'BSE' 'Segment' INTO #BSE 
FROM [AngelBSECM].Account_AB.dbo.ledger WITH(NOLOCK) 
WHERE CLTCODE = '5100000017' AND EDT >= '2022-07-01' AND DRCR = 'D'        
AND VNo= @DebitVNo     
                
SELECT * INTO #Temp FROM (               
SELECT ROW_NUMBER() OVER(ORDER BY VTYP) 'SRNO', * FROM ( 
SELECT * FROM #NSE WHERE Segment=@DebitSegment
UNION ALL 
SELECT * FROM #BSE WHERE Segment=@DebitSegment 
)A                
)B    
    
INSERT INTO [tbl_SBKnockOffDebitedAmountProcessDetails]    
SELECT VTYP,VNO,VAMT,VDT,Segment,NARRATION,@VType,@VNo,@VAmount,@VDate,@Segment,@Narration ,@Remarks,0,GETDATE(),'Banking'    
FROM #Temp    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBPayoutDetailsVarificationBySBTeam
-- --------------------------------------------------

CREATE Procedure USP_SaveSBPayoutDetailsVarificationBySBTeam  
@SBPanNo VARCHAR(15),@RefNo VARCHAR(35),@SBRemarks VARCHAR(25),@RejectionReason VARCHAR(255)  
AS  
BEGIN  

DECLARE @DepositRefId bigint = (SELECT DepositRefId FROM tbl_SBPayoutDepositProcessDetailsInLMS WHERE SBPanNo=@SBPanNo AND RefNo=@RefNo)

SELECT SBPDVSB.* INTO #EXISTING FROM tbl_SBPayoutDetailsVarificationBySBTeam SBPDVSB 
JOIN tbl_SBProcessStatusDetails_Payout SBPSDP WITH(NOLOCK) 
ON SBPDVSB.DepositVarificationId = SBPSDP.DepositVarificationId 
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SBPDPLMS 
ON SBPDPLMS.DepositRefId = SBPSDP.DepositRefId
WHERE SBPDVSB.SBPanNo =@SBPanNo AND SBPDPLMS.RefNo=@RefNo

IF NOT EXISTS(SELECT * FROM #EXISTING)  
BEGIN  
INSERT INTO tbl_SBPayoutDetailsVarificationBySBTeam  
VALUES(@SBPanNo,@SBRemarks,@RejectionReason,GETDATE(),'Test')  

DECLARE @DepositVarificationId bigint  
SET @DepositVarificationId = SCOPE_IDENTITY()

UPDATE tbl_SBProcessStatusDetails_Payout SET DepositVarificationId=@DepositVarificationId
WHERE DepositRefId= @DepositRefId
 
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSBSBTagGenerationRegistrationDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSBSBTagGenerationRegistrationDetails  
(@SBMasterId bigint=0, @Segment VARCHAR(10)='',@Status VARCHAR(15)='',  
@RegistrationNo VARCHAR(35)='',@RegistrationDate VARCHAR(10)='',@RejectionRemarks VARCHAR(255)='',   
@IsRejectionDocUpload bit=0, @ProcessBy VARCHAR(15)='')  
AS  
BEGIN  
SET @RegistrationDate = CAST(CONVERT(datetime, @RegistrationDate,103) as date)
IF NOT EXISTS(SELECT * FROM tbl_IntermediarySBTagGenerationRegistrationDetails WITH(NOLOCK) WHERE SBMasterId=@SBMasterId AND Segment=@Segment)  
BEGIN  
INSERT INTO tbl_IntermediarySBTagGenerationRegistrationDetails  
VALUES(@SBMasterId,@Segment,@Status,@RegistrationNo,(CASE WHEN ISNULL(@RegistrationNo,'')<>'' THEN @RegistrationDate ELSE '' END)   
,GETDATE(),@RejectionRemarks,@IsRejectionDocUpload,'',GETDATE(),@ProcessBy,'','')  
END  
ELSE  
BEGIN  
UPDATE tbl_IntermediarySBTagGenerationRegistrationDetails SET Status=@Status,  
RegistrationNo =@RegistrationNo,RegistrationDate=@RegistrationDate, RejectionRemarks=@RejectionRemarks,  
EditBy = @ProcessBy, EditDate = GETDATE()   
WHERE SBMasterId=@SBMasterId AND Segment=@Segment  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSubBrokerLimitEnhencementSummaryReport
-- --------------------------------------------------

CREATE PROCEDURE USP_SaveSubBrokerLimitEnhencementSummaryReport (@SBCount int, @ClientCount int, @TotalLimit decimal)
AS
BEGIN
INSERT INTO SubBrokerLimitEnhencementSummaryReport VALUES(GETDATE(),@SBCount,@ClientCount,@TotalLimit)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveSubBrokerOnBoardingProcessCompanyDetails
-- --------------------------------------------------

  
CREATE PROCEDURE USP_SaveSubBrokerOnBoardingProcessCompanyDetails  
@CompanyName VARCHAR(255)='',@ProcessBy VARCHAR(15)=''  
AS  
BEGIN  
IF NOT EXISTS(SELECT * FROM tbl_SubBrokerOnBoardingCompanyMaster WHERE CompanyName=@CompanyName)  
BEGIN  
DECLARE @CompanyCode VARCHAR(15) ='',@CompanyId int = 0  
  
SET @CompanyId = (SELECT ISNULL(MAX(CompanyId),0) FROM tbl_SubBrokerOnBoardingCompanyMaster)  
SET @CompanyCode = 'CMP000' + CAST((@CompanyId+1) as varchar)  
  
INSERT INTO tbl_SubBrokerOnBoardingCompanyMaster  
VALUES(@CompanyCode,@CompanyName,GETDATE(),@ProcessBy)  
END  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SaveUndeliveredClientDRFInwordDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SaveUndeliveredClientDRFInwordDetails]
@DRFId bigint, @NoOfCertificates int=0, @PodNo VARCHAR(35),@CourierBy VARCHAR(150),
@Remarks VARCHAR(225)='',@ProcessStatus VARCHAR(35)='',  
@ResendProcessType VARCHAR(15)='',@DRFReceivedBy VARCHAR(255)='',  
@ReProcessPodNo VARCHAR(35)='', @ReProcessCourierName VARCHAR(155)=''  
,@ProcessBy VARCHAR(35)=''
AS
BEGIN
IF NOT EXISTS(SELECT * FROM tbl_UndeliveredClientDRFInwordDetails WHERE DRFId = @DRFId)
BEGIN
INSERT INTO tbl_UndeliveredClientDRFInwordDetails
VALUES(@DRFId,@NoOfCertificates,@PodNo,@CourierBy,@Remarks,GETDATE()
,CASE WHEN @ProcessStatus = 'ReProcess' THEN 1 ELSE 0 END
,CASE WHEN @ProcessStatus = 'ReProcess' THEN GETDATE() ELSE '' END,  
(CASE WHEN ISNULL(@DRFReceivedBy,'')<>'' OR ISNULL(@ReProcessPodNo,'')<>'' THEN 1 ELSE 0 END)  
,(CASE WHEN ISNULL(@DRFReceivedBy,'')<>'' OR ISNULL(@ReProcessPodNo,'')<>'' THEN GETDATE() ELSE '' END)  
,@ProcessBy,  
(CASE WHEN @ResendProcessType='SelectSendByTyp' THEN '' ELSE @ResendProcessType END)  
,@DRFReceivedBy,@ReProcessPodNo,@ReProcessCourierName)       
    
    
SELECT DISTINCT DRFIRPM.DRFId, DRFIRPM.ClientName ,ClientEmailId     
,ISNULL(AMCD.l_address1,'-') +','+ ISNULL(AMCD.l_address2,'-') +','+ ISNULL(AMCD.l_address3,'-')+','+       
ISNULL(AMCD.l_city,'')  +','+ ISNULL(AMCD.l_state,'') +'-'+ ISNULL(AMCD.l_zip,'') 'ClientAddress'      
INTO #ReturnedDRF    
FROM tbl_UndeliveredClientDRFInwordDetails RDRFOPRD WITH(NOLOCK)        
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)      
ON DRFIRPM.DRFId = RDRFOPRD.DRFId      
JOIN tbl_DRFProcessClientMailStatusDetails DRFPCMSD WITH(NOLOCK)      
ON DRFIRPM.DRFId = DRFPCMSD.DRFId      
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK) 
ON DRFPCMSD.cltCode = AMCD.cl_code     
WHERE RDRFOPRD.DRFId=@DRFId    
    
  
DECLARE @body NVARCHAR(MAX)        
DECLARE @ClientEmailId VARCHAR(255)=(SELECT ClientEmailId FROM #ReturnedDRF)      
DECLARE @ClientAddress VARCHAR(MAX)=(SELECT ClientAddress FROM #ReturnedDRF)      
DECLARE @ClientName VARCHAR(255)= (SELECT ClientName FROM #ReturnedDRF)    
        
 
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
With regards to your Dematerialisation Request rejection, we tried to deliver your Share Certificates to the below address. However, we were unable to do so.
<br /><br />    
Address : '+@ClientAddress+'    
<br /><br />    
To re-initiate delivery of your Share Certificates, please write to us at 
<b style="font-size:medium; color:blue;"><u>support@angelbroking.com </u></b>
 </H2>  

<br />      
      
<br />Thank you,<br />    
Team Angel One'  
  
EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @ClientEmailId,      
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,  
    
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',  
  
@subject = 'Share Certificates Undelivered' ;  
       
END
ELSE
BEGIN
UPDATE tbl_UndeliveredClientDRFInwordDetails   
SET NoOfCertificates=@NoOfCertificates,
IsReProcess = (CASE WHEN @ProcessStatus = 'ReProcess' THEN 1 ELSE 0 END)  
, ReProcessDate=(CASE WHEN @ProcessStatus = 'ReProcess' THEN GETDATE() ELSE '' END) 
,ReProcessType = (CASE WHEN @ResendProcessType='SelectSendByTyp' THEN '' ELSE @ResendProcessType END)  
,DocumentReceivedBy=@DRFReceivedBy,  
ReProcessPodNo=@ReProcessPodNo , ReProcessCourierName=@ReProcessCourierName  
,IsDocumentReceived= (CASE WHEN ISNULL(@DRFReceivedBy,'')<>'' OR ISNULL(@ReProcessPodNo,'')<>'' THEN 1 ELSE 0 END)  
,DRFReceivedDate= (CASE WHEN ISNULL(@DRFReceivedBy,'')<>'' OR ISNULL(@ReProcessPodNo,'')<>'' THEN GETDATE() ELSE '' END)  
WHERE DRFId = @DRFId       
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SB_Pledge_Request
-- --------------------------------------------------

CREATE PROCEDURE USP_SB_Pledge_Request @PanNo VARCHAR(30)  
AS  
BEGIN  
  
SELECT (a.tradingid) as PARTY_CODE, (a.hld_isin_code) as ISIN, a.SecurityName, CAST(FREE_QTY as decimal(17,2)) 'FREE_QTY'  
,Rate 'Closing_Rate' , CAST(Valuation as decimal(17,2)) 'Valuation'   
,DPID='12033200', (a.hld_ac_code) as CLTDPID  
, BROKERBOID='1203320051669051', ISNULL(AMVD.VarMarginRate,100) 'VarMarginRate',  
CASE WHEN ISNULL(AMVD.VarMarginRate,0)=0 THEN  CAST(0 AS decimal(17,2))  
ELSE CAST((Valuation - ((Valuation*AMVD.VarMarginRate)/100)) as decimal(17,2)) END 'ValueAfterHaiCut'  
  
FROM [172.31.16.94].dmat.citrus_usr.holding a WITH(NOLOCK)   
INNER JOIN [196.1.115.132].risk.dbo.client_details b WITH(NOLOCK)   
ON a.tradingid=b.party_code  
LEFT JOIN (SELECT DISTINCT ISIN,VarMarginRate FROM ANAND1.MSAJAG.DBO.VARDETAIL  WITH(NOLOCK)  
WHERE DetailKey = (SELECT MAX(DetailKey) FROM ANAND1.MSAJAG.DBO.VARDETAIL  WITH(NOLOCK))  
--AND isin='INE039A01010'  
) AMVD  
ON a.hld_isin_code =AMVD.ISIN   
WHERE b.pan_gir_no=@PanNo AND CAST(FREE_QTY as decimal(17,2)) >0  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBDepositSuspenceAccJVProcessByBanking
-- --------------------------------------------------
  
CREATE PROCEDURE USP_SBDepositSuspenceAccJVProcessByBanking        
@SBDepositSuspenceAccJVProcess SBDepositSuspenceAccJVProcess readonly        
AS        
BEGIN   
insert into Dustbin.dbo.tbl_SP_log
values(OBJECT_NAME(@@PROCID),getdate())

SELECT     
VType,    
 VNo,    
 VAMT ,    
 CAST(CONVERT(datetime,VDT,103) as date) VDT,    
 Segment ,    
 SBTag,    
 PANNo,    
 RefNo ,    
 Amount     
INTO #Temp FROM @SBDepositSuspenceAccJVProcess        
        
SELECT VType,VNo,VAmount,VDate,Segment,SBTag,SBPanNo,RefNo,DepositAmount 'Amount' INTO #ProcessData        
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)        
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)        
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDVPS.DepositVarificationId = SBDBVP.DepositVarificationId         
AND SBDSAC.SuspenceAccDetailsId = SBDBVP.SuspenceAccDetailsId AND IsJVProcess=0        
        
SELECT * INTO #REMOVE_TEMP FROM(        
SELECT * FROM #ProcessData        
EXCEPT        
SELECT * FROM #Temp ---WHERE RefNo<>'808080'        
)A        
    
    
SELECT DISTINCT SBDSAC.SuspenceAccDetailsId,SBDSAC.VNo,SBDSAC.VAmount,SBDSAC.Segment    
 INTO #ExistingDetails    
FROM  tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)         
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)    
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId     
JOIN #REMOVE_TEMP T    
ON SBDVPS.SBTag  = T.SBTag        
AND SBDVPS.RefNo = T.RefNo AND SBDSAC.VNo = T.VNo        
AND SBDVPS.DepositAmount  = T.Amount     
AND SBDSAC.Segment=T.Segment    
        
SELECT ROW_NUMBER() OVER(ORDER BY SBTag) 'SRNO', * INTO #FINAL_DATA         
FROM (        
SELECT SBDSAC.SuspenceAccDetailsId,SBDVPS.DepositVarificationId,         
SBDSAC.VType,SBDSAC.VNo,SBDSAC.VAmount,SBDSAC.VDate,SBDSAC.Narration,SBDSAC.Segment        
,SBDVPS.SBTag,SBDVPS.SBPanNo,SBDVPS.RefNo,SBDVPS.DepositAmount         
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)        
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)        
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDVPS.DepositVarificationId = SBDBVP.DepositVarificationId         
AND SBDSAC.SuspenceAccDetailsId = SBDBVP.SuspenceAccDetailsId AND IsJVProcess=0         
JOIN #Temp T         
ON SBDVPS.SBTag  = T.SBTag        
AND SBDVPS.RefNo = T.RefNo AND SBDSAC.VNo = T.VNo        
AND SBDVPS.DepositAmount  = T.Amount    
WHERE SBDSAC.SuspenceAccDetailsId NOT IN(SELECT DISTINCT SuspenceAccDetailsId FROM #ExistingDetails)     
)AA        
        
IF EXISTS(SELECT * FROM #FINAL_DATA)    
BEGIN     
      
DECLARE @TotalCount int = (SELECT COUNT(*) FROM #FINAL_DATA)        
DECLARE @Start int=1      
DECLARE @SBTag VARCHAR(12) = ''      
      
      
WHILE(@Start<=@TotalCount)      
BEGIN         
SET @SBTag = (SELECT SBTag FROM #FINAL_DATA WHERE SRNo=@Start)      
IF EXISTS(SELECT * FROM #FINAL_DATA WHERE Segment='NSE' AND SRNo=@Start)      
BEGIN      
IF NOT EXISTS (SELECT * FROM AngelNseCM.ACCOUNT.DBO.ACMAST  WHERE CLTCODE='05'+@SBTag)       
BEGIN      
insert into AngelNseCM.account.dbo.acmast      
(      
acname,longname,actyp,accat,familycd,cltcode,accdtls,grpcode,      
BookType,MicrNo,branchcode,Btobpayment,Paymode,Pobankname,Pobranch,Pobankcode      
)      
SELECT    
REGTRADENAME,REGTRADENAME,'LIABILITIE',3,'BOI01','05'+RegTAG,      
left(REGTRADENAME,35),'L0403000000','',0,TAGBRANCH,0,'P','HDFC BANK','',''      
FROM SB_Comp.DBO.bpregmaster a with (nolock)       
left join AngelNseCM.account.dbo.acmast b on '05'+RegTAG=b.cltcode      
Where regexchangesegment like 'N_CS' and b.cltcode is null   and RegTAG in (@SBTag)      
END      
END     
ELSE      
BEGIN      
IF NOT EXISTS (SELECT * FROM AngelBSECM.ACCOUNT_AB.DBO.ACMAST WHERE CLTCODE='05'+@SBTag)       
 BEGIN      
insert into AngelBSECM.ACCOUNT_AB.DBO.ACMAST      
(       
acname,longname,actyp,accat,familycd,cltcode,accdtls,grpcode,      
BookType,MicrNo,branchcode,Btobpayment,Paymode,Pobankname,Pobranch,Pobankcode      
)      
SELECT    
REGTRADENAME,REGTRADENAME,'LIABILITIE',3,'BOI01','05'+RegTAG,      
left(REGTRADENAME,35),'L0403000000','',0,TAGBRANCH,0,'P','HDFC BANK','',''      
from SB_Comp.DBO.bpregmaster a with (nolock) left join AngelBSECM.ACCOUNT_AB.DBO.ACMAST b on '05'+RegTAG=b.cltcode      
where regexchangesegment like 'N_CS' and b.cltcode is null  and RegTAG in (@SBTag)      
END      
      
END      
      
SET @Start = @Start+1      
END      
      
---- BACK OFFICE     
      
INSERT INTO tbl_SBDepositProcessBOLedgerData       
SELECT         
8 'VOUCHERTYPE',    
SRNO,    
CAST(GETDATE() AS DATE) 'VDATE',    
CAST(GETDATE() AS DATE) 'EDATE',    
'5100000017' 'CLTCODE',    
0 'CREDITAMT',    
DepositAmount 'DEBITAMT',    
'AMT RECD_'+VNo+'_'+RefNo+'_05'+SBTag 'NARRATION',    
'' 'BANKCODE',    
'' 'MARGINCODE',    
'' 'BANKNAME',    
'' BRANCHNAME,    
'HO' BRANCHCODE,     
'' 'DDNO',    
'' CHEQUEMODE,    
'' 'CHEQUEDATE',    
'' 'CHEQUENAME',    
'' CLEAR_MODE,    
'' TPACCOUNTNUMBER,    
Segment 'EXCHANGE',    
'CAPITAL' 'SEGMENT',    
1 'MKCK_FLAG',    
'' RETURN_FLD1,    
'SBDeposit' RETURN_FLD2,    
'' RETURN_FLD3,    
'' RETURN_FLD4,    
'SBDeposit' RETURN_FLD5,    
'0' ROWSTATE ,     
0 'ISKNOCKOFF_PROCESS',      
0 'ISPROCESS_STATUS'         
FROM #FINAL_DATA    
    
INSERT INTO tbl_SBDepositProcessBOLedgerData       
SELECT         
8 'VOUCHERTYPE',    
SRNO,    
CAST(GETDATE() AS DATE) 'VDATE',    
CAST(GETDATE() AS DATE) 'EDATE',    
'05'+SBTag 'CLTCODE',    
DepositAmount 'CREDITAMT',    
0 'DEBITAMT',    
'AMT RECD_'+VNo+'_'+RefNo+'_05'+SBTag 'NARRATION',    
'' 'BANKCODE',    
'' 'MARGINCODE',    
'' 'BANKNAME',    
'' BRANCHNAME,    
'HO' BRANCHCODE,     
'' 'DDNO',    
'' CHEQUEMODE,    
'' 'CHEQUEDATE',    
'' 'CHEQUENAME',    
'' CLEAR_MODE,    
'' TPACCOUNTNUMBER,    
Segment 'EXCHANGE',    
'CAPITAL' 'SEGMENT',    
1 'MKCK_FLAG',    
'' RETURN_FLD1,    
'SBDeposit' RETURN_FLD2,    
'' RETURN_FLD3,    
'' RETURN_FLD4,    
'SBDeposit' RETURN_FLD5,    
'0' ROWSTATE ,     
0 'ISKNOCKOFF_PROCESS',      
0 'ISPROCESS_STATUS'         
FROM #FINAL_DATA        
       
INSERT INTO tbl_SBDepositBankingVarificationProcess        
SELECT DISTINCT SuspenceAccDetailsId,DepositVarificationId,0,'',1,GETDATE() FROM #FINAL_DATA        
        
END        
        
DROP TABLE #Temp        
DROP TABLE #ProcessData        
DROP TABLE #REMOVE_TEMP        
DROP TABLE #FINAL_DATA        
END       
/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBDepositSuspenceAccJVProcessByBanking_06Nov2025
-- --------------------------------------------------
  
CREATE PROCEDURE USP_SBDepositSuspenceAccJVProcessByBanking_06Nov2025        
@SBDepositSuspenceAccJVProcess SBDepositSuspenceAccJVProcess readonly        
AS        
BEGIN        
SELECT     
VType,    
 VNo,    
 VAMT ,    
 CAST(CONVERT(datetime,VDT,103) as date) VDT,    
 Segment ,    
 SBTag,    
 PANNo,    
 RefNo ,    
 Amount     
INTO #Temp FROM @SBDepositSuspenceAccJVProcess        
        
SELECT VType,VNo,VAmount,VDate,Segment,SBTag,SBPanNo,RefNo,DepositAmount 'Amount' INTO #ProcessData        
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)        
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)        
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDVPS.DepositVarificationId = SBDBVP.DepositVarificationId         
AND SBDSAC.SuspenceAccDetailsId = SBDBVP.SuspenceAccDetailsId AND IsJVProcess=0        
        
SELECT * INTO #REMOVE_TEMP FROM(        
SELECT * FROM #ProcessData        
EXCEPT        
SELECT * FROM #Temp ---WHERE RefNo<>'808080'        
)A        
    
    
SELECT DISTINCT SBDSAC.SuspenceAccDetailsId,SBDSAC.VNo,SBDSAC.VAmount,SBDSAC.Segment    
 INTO #ExistingDetails    
FROM  tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)         
JOIN tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)    
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId     
JOIN #REMOVE_TEMP T    
ON SBDVPS.SBTag  = T.SBTag        
AND SBDVPS.RefNo = T.RefNo AND SBDSAC.VNo = T.VNo        
AND SBDVPS.DepositAmount  = T.Amount     
AND SBDSAC.Segment=T.Segment    
        
SELECT ROW_NUMBER() OVER(ORDER BY SBTag) 'SRNO', * INTO #FINAL_DATA         
FROM (        
SELECT SBDSAC.SuspenceAccDetailsId,SBDVPS.DepositVarificationId,         
SBDSAC.VType,SBDSAC.VNo,SBDSAC.VAmount,SBDSAC.VDate,SBDSAC.Narration,SBDSAC.Segment        
,SBDVPS.SBTag,SBDVPS.SBPanNo,SBDVPS.RefNo,SBDVPS.DepositAmount         
FROM tbl_SBDepositVarificationAndProcessBySBTeam SBDVPS WITH(NOLOCK)        
JOIN tbl_SBDepositSuspenceAccountDetails SBDSAC WITH(NOLOCK)        
ON SBDVPS.SuspenceAccDetailsId = SBDSAC.SuspenceAccDetailsId        
LEFT JOIN tbl_SBDepositBankingVarificationProcess SBDBVP WITH(NOLOCK)        
ON SBDVPS.DepositVarificationId = SBDBVP.DepositVarificationId         
AND SBDSAC.SuspenceAccDetailsId = SBDBVP.SuspenceAccDetailsId AND IsJVProcess=0         
JOIN #Temp T         
ON SBDVPS.SBTag  = T.SBTag        
AND SBDVPS.RefNo = T.RefNo AND SBDSAC.VNo = T.VNo        
AND SBDVPS.DepositAmount  = T.Amount    
WHERE SBDSAC.SuspenceAccDetailsId NOT IN(SELECT DISTINCT SuspenceAccDetailsId FROM #ExistingDetails)     
)AA        
        
IF EXISTS(SELECT * FROM #FINAL_DATA)    
BEGIN     
      
DECLARE @TotalCount int = (SELECT COUNT(*) FROM #FINAL_DATA)        
DECLARE @Start int=1      
DECLARE @SBTag VARCHAR(12) = ''      
      
      
WHILE(@Start<=@TotalCount)      
BEGIN         
SET @SBTag = (SELECT SBTag FROM #FINAL_DATA WHERE SRNo=@Start)      
IF EXISTS(SELECT * FROM #FINAL_DATA WHERE Segment='NSE' AND SRNo=@Start)      
BEGIN      
IF NOT EXISTS (SELECT * FROM AngelNseCM.ACCOUNT.DBO.ACMAST  WHERE CLTCODE='05'+@SBTag)       
BEGIN      
insert into AngelNseCM.account.dbo.acmast      
(      
acname,longname,actyp,accat,familycd,cltcode,accdtls,grpcode,      
BookType,MicrNo,branchcode,Btobpayment,Paymode,Pobankname,Pobranch,Pobankcode      
)      
SELECT    
REGTRADENAME,REGTRADENAME,'LIABILITIE',3,'BOI01','05'+RegTAG,      
left(REGTRADENAME,35),'L0403000000','',0,TAGBRANCH,0,'P','HDFC BANK','',''      
FROM SB_Comp.DBO.bpregmaster a with (nolock)       
left join AngelNseCM.account.dbo.acmast b on '05'+RegTAG=b.cltcode      
Where regexchangesegment like 'N_CS' and b.cltcode is null   and RegTAG in (@SBTag)      
END      
END     
ELSE      
BEGIN      
IF NOT EXISTS (SELECT * FROM AngelBSECM.ACCOUNT_AB.DBO.ACMAST WHERE CLTCODE='05'+@SBTag)       
 BEGIN      
insert into AngelBSECM.ACCOUNT_AB.DBO.ACMAST      
(       
acname,longname,actyp,accat,familycd,cltcode,accdtls,grpcode,      
BookType,MicrNo,branchcode,Btobpayment,Paymode,Pobankname,Pobranch,Pobankcode      
)      
SELECT    
REGTRADENAME,REGTRADENAME,'LIABILITIE',3,'BOI01','05'+RegTAG,      
left(REGTRADENAME,35),'L0403000000','',0,TAGBRANCH,0,'P','HDFC BANK','',''      
from SB_Comp.DBO.bpregmaster a with (nolock) left join AngelBSECM.ACCOUNT_AB.DBO.ACMAST b on '05'+RegTAG=b.cltcode      
where regexchangesegment like 'N_CS' and b.cltcode is null  and RegTAG in (@SBTag)      
END      
      
END      
      
SET @Start = @Start+1      
END      
      
---- BACK OFFICE     
      
INSERT INTO tbl_SBDepositProcessBOLedgerData       
SELECT         
8 'VOUCHERTYPE',    
SRNO,    
CAST(GETDATE() AS DATE) 'VDATE',    
CAST(GETDATE() AS DATE) 'EDATE',    
'5100000017' 'CLTCODE',    
0 'CREDITAMT',    
DepositAmount 'DEBITAMT',    
'AMT RECD_'+VNo+'_'+RefNo+'_05'+SBTag 'NARRATION',    
'' 'BANKCODE',    
'' 'MARGINCODE',    
'' 'BANKNAME',    
'' BRANCHNAME,    
'HO' BRANCHCODE,     
'' 'DDNO',    
'' CHEQUEMODE,    
'' 'CHEQUEDATE',    
'' 'CHEQUENAME',    
'' CLEAR_MODE,    
'' TPACCOUNTNUMBER,    
Segment 'EXCHANGE',    
'CAPITAL' 'SEGMENT',    
1 'MKCK_FLAG',    
'' RETURN_FLD1,    
'SBDeposit' RETURN_FLD2,    
'' RETURN_FLD3,    
'' RETURN_FLD4,    
'SBDeposit' RETURN_FLD5,    
'0' ROWSTATE ,     
0 'ISKNOCKOFF_PROCESS',      
0 'ISPROCESS_STATUS'         
FROM #FINAL_DATA    
    
INSERT INTO tbl_SBDepositProcessBOLedgerData       
SELECT         
8 'VOUCHERTYPE',    
SRNO,    
CAST(GETDATE() AS DATE) 'VDATE',    
CAST(GETDATE() AS DATE) 'EDATE',    
'05'+SBTag 'CLTCODE',    
DepositAmount 'CREDITAMT',    
0 'DEBITAMT',    
'AMT RECD_'+VNo+'_'+RefNo+'_05'+SBTag 'NARRATION',    
'' 'BANKCODE',    
'' 'MARGINCODE',    
'' 'BANKNAME',    
'' BRANCHNAME,    
'HO' BRANCHCODE,     
'' 'DDNO',    
'' CHEQUEMODE,    
'' 'CHEQUEDATE',    
'' 'CHEQUENAME',    
'' CLEAR_MODE,    
'' TPACCOUNTNUMBER,    
Segment 'EXCHANGE',    
'CAPITAL' 'SEGMENT',    
1 'MKCK_FLAG',    
'' RETURN_FLD1,    
'SBDeposit' RETURN_FLD2,    
'' RETURN_FLD3,    
'' RETURN_FLD4,    
'SBDeposit' RETURN_FLD5,    
'0' ROWSTATE ,     
0 'ISKNOCKOFF_PROCESS',      
0 'ISPROCESS_STATUS'         
FROM #FINAL_DATA        
       
INSERT INTO tbl_SBDepositBankingVarificationProcess        
SELECT DISTINCT SuspenceAccDetailsId,DepositVarificationId,0,'',1,GETDATE() FROM #FINAL_DATA        
        
END        
        
DROP TABLE #Temp        
DROP TABLE #ProcessData        
DROP TABLE #REMOVE_TEMP        
DROP TABLE #FINAL_DATA        
END       
/*-https://angelbrokingpl.atlassian.net/browse/SRE-41572*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SBKnockOffAmountRefundProcess
-- --------------------------------------------------

CREATE PROCEDURE USP_SBKnockOffAmountRefundProcess          
AS          
BEGIN          
INSERT INTO tbl_SBDepositProcessBOLedgerData                                   
SELECT                                     
3 'VOUCHERTYPE',                          
ROW_NUMBER() OVER (ORDER BY KnockOffDetailsId) 'SRNo',                          
CAST(GETDATE() AS DATE) 'VDATE',                          
CAST(GETDATE() AS DATE) 'EDATE',                          
'5100000017' 'CLTCODE',                          
0 'CREDITAMT',                          
VAmount 'DEBITAMT',                          
'REFUND_'+VNo+'_'+RefNo 'NARRATION',                                      
'02015' 'BANKCODE',                          
'' 'MARGINCODE',                          
--LEFT(BankName, CASE WHEN charindex(' ', BankName) = 0 THEN           
--    LEN(BankName) ELSE charindex(' ', BankName) - 1 END) 'BANKNAME',         
BankName 'BANKNAME',           
'ALL' BRANCHNAME,                          
'HO' BRANCHCODE,                           
RefNo 'DDNO',                          
'D' CHEQUEMODE,                          
CAST(GETDATE() AS DATE) 'CHEQUEDATE',                          
-- BankName 'CHEQUENAME',  
'HDFC' 'CHEQUENAME',                          
'L' CLEAR_MODE,                          
SBBankAccountNo TPACCOUNTNUMBER,                          
Segment 'EXCHANGE',                          
'CAPITAL' 'SEGMENT',                          
1 'MKCK_FLAG',                          
'' RETURN_FLD1,                          
'SB_KnockOffRefund' RETURN_FLD2,                          
'' RETURN_FLD3,                          
'' RETURN_FLD4,                          
'SB_KnockOffRefund' RETURN_FLD5,                          
'0' ROWSTATE ,               
1 'ISKNOCKOFF_PROCESS',                
0 'ISPROCESS_STATUS'             
          
FROM(          
SELECT SBDKOD.*,SPDPDLMS.RefNo           
FROM tbl_SBDepositKnockOffProcessDetails SBDKOD WITH(NOLOCK)  
JOIN tbl_SBPayoutDepositProcessDetailsInLMS SPDPDLMS WITH(NOLOCK)  
ON SBDKOD.DepositRefId =SPDPDLMS.DepositRefId  
WHERE IsProcessStatus=0  AND IsOldProcess=0           
)AA          
          
UPDATE tbl_SBDepositKnockOffProcessDetails SET IsProcessStatus=1 WHERE IsProcessStatus=0  AND IsOldProcess=0           
          
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SendClientDRFESignAadharAuthenticationRequestMailer
-- --------------------------------------------------

CREATE PROCEDURE USP_SendClientDRFESignAadharAuthenticationRequestMailer          
@DRFId bigint=0          
AS          
BEGIN          
          
DECLARE @DRFNo VARCHAR(25)=(SELECT DRFNo FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFId=@DRFId AND IsRejected=0)          
DECLARE @ClientName VARCHAR(255)=(SELECT ClientName FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFId=@DRFId AND IsRejected=0)          
DECLARE @Quantity NVARCHAR(15) = (SELECT Quantity FROM tbl_DRFInwordRegistrationProcessDetails WITH(NOLOCK) WHERE DRFId=@DRFId)          
DECLARE @ClientEmailId VARCHAR(355)=(SELECT ClientEmailId FROM tbl_DRFProcessClientMailStatusDetails WITH(NOLOCK) WHERE DRFId=@DRFId)          
          
DECLARE @body NVARCHAR(MAX)     

Print 'Message'
          
 /*   -- Commanted for some time  - 16/02/2024
 
SET @body ='<p style="font-size:medium; font-family:Calibri">            
            
 <b>Dear '+@ClientName+' </b>,<br /><br />            
            
We are inform you that your Dematerialisation request has been received by Angel One team and we are start the process. <br />          
For further process we will send the DRF Aadhar Authetication link to your Registered MobileNo and Emailid for DRF Aadhar authentication due to :<br />          
          
1. Your DMAT Account Open is offline.<br />          
2. Your (Gross Income * 5) less then DRF (Shares Closing Price * DRF Total Cost).<br /><br />          
          
We are send the DRF Authentication link from <b> <u>Angel One Ltd - noreply@leegality.com </u></b> EmailId for ESign the DRF.          
So request you to please esign the DRF on the priority basis for your DRF next process. <br />          
<b>Note :</b> Link will be expired on 10 days.  <br />         
            
 </H2>            
                    
Please find here the details of the same: <br /> <br />                         
            
1. DRFNo : '+@DRFNo+'  <br />                        
2. No of Share Certificates : '+@Quantity+' <br />                      
                       
<br />                      
                      
<br />Thank you,<br />                          
Team Angel One'            
            
--EXEC [196.1.115.182].MSDB.DBO.SP_SEND_DBMAIL     
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL       
            
@profile_name = 'AngelBroking',            
            
@body = @body,            
            
@body_format ='HTML',            
            
@recipients = @ClientEmailId,          
--@recipients = 'parmarsuraj254@gmail.com',           
          
--@recipients = 'sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;' ,            
            
--@blind_copy_recipients ='sm.nachiket@angelbroking.com; jalinder.sapgade@angelbroking.com; rajesh.thalkar@angelbroking.com;',            
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',            
            
@subject = 'DMAT Aadhar Authentication Request Process' ;            

*/

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SendClientDRFProcess_MISReport
-- --------------------------------------------------

CREATE PROCEDURE USP_SendClientDRFProcess_MISReport  
AS  
BEGIN  
CREATE TABLE #ClientDRFProcessMISData    
(    
SR int,    
AppStatus VARCHAR(10),    
NoOfRecords bigint,    
UniqueRecords bigint,    
TotalValueOfDRF decimal(17,2),    
AmountGreater5Lac bigint,    
CountOfBreachOffCumValue bigint,    
IncomeBreachOffCumValue decimal(17,2)    
)    
    
INSERT INTO #ClientDRFProcessMISData    
EXEC USP_GetClientDRFProcess_MISData 0    
  
DECLARE @xml NVARCHAR(MAX)    
DECLARE @body NVARCHAR(MAX)      
DECLARE @xml1 NVARCHAR(MAX)    
DECLARE @ProcessDate VARCHAR(15) = CONVERT(VARCHAR(11),GETDATE(),113)    
             
 SET @xml = CAST(( SELECT [SR] AS 'td','', [AppStatus] AS 'td'             
 ,'', [NoOfRecords] AS 'td'  ,'', [UniqueRecords] AS 'td'  ,'', [TotalValueOfDRF] AS 'td'     
  ,'', [AmountGreater5Lac] AS 'td'  ,'', [CountOfBreachOffCumValue] AS 'td'     
  ,'', [IncomeBreachOffCumValue] AS 'td'     
FROM #ClientDRFProcessMISData      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    
    
delete from #ClientDRFProcessMISData    
    
INSERT INTO #ClientDRFProcessMISData    
EXEC USP_GetClientDRFProcess_MISData 1    
    
SET @xml1 = CAST(( SELECT [SR] AS 'td','', [AppStatus] AS 'td'             
 ,'', [NoOfRecords] AS 'td'  ,'', [UniqueRecords] AS 'td'  ,'', [TotalValueOfDRF] AS 'td'     
  ,'', [AmountGreater5Lac] AS 'td'  ,'', [CountOfBreachOffCumValue] AS 'td'     
  ,'', [IncomeBreachOffCumValue] AS 'td'     
FROM #ClientDRFProcessMISData      
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    
    
SET @body ='<p style="font-size:medium; font-family:Calibri">    
    
 <b>Dear Team </b>,<br /><br />    
    
Please find the Client DRF Process Overall MIS.       
 </H2>    
    
<table border=1   cellpadding=2 cellspacing=2>    
    
<tr style="background-color:rgb(201, 76, 76); color :White">    
    
<th> SR </th> <th> AppStatus </th> <th> NoOfRecords </th> <th> UniqueRecords </th> <th> TotalValueOfDRF </th> <th> AmountGreater5Lac </th> <th> CountOfBreachOffCumValue </th> <th> IncomeBreachOffCumValue </th> '    
           
 SET @body = @body + @xml +'</table>    
    
 <br />    
    
 Please find the Client DRF Process MIS on process date : '+@ProcessDate+'.       
 </H2>    
    
<table border=1   cellpadding=2 cellspacing=2>    
    
<tr style="background-color:rgb(201, 76, 76); color :White">    
    
<th> SR </th> <th> AppStatus </th> <th> NoOfRecords </th> <th> UniqueRecords </th> <th> TotalValueOfDRF </th> <th> AmountGreater5Lac </th> <th> CountOfBreachOffCumValue </th> <th> IncomeBreachOffCumValue </th> '    
           
 SET @body = @body + @xml1 +'</table></body></html>    
        
<br />    
    
<br />Thank you,<br />        
Team Angel One'    
    
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL    
    
@profile_name = 'AngelBroking',    
    
@body = @body,    
    
@body_format ='HTML',    
    
@recipients = 'jagannath@angelbroking.com;',    
@copy_recipients = 'dileswar.jena@angelbroking.com; paresh.natekar@angelbroking.com;' ,    
    
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com',    
--@blind_copy_recipients ='dileswar.jena@angelbroking.com; jagannath@angelbroking.com; rajesh.thalkar@angelbroking.com;',    
    
@subject = 'MIS of Client DRF Process' ;    
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SendClientDRFProcessCompleteStatusReportToClient
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SendClientDRFProcessCompleteStatusReportToClient] @DRFNo VARCHAR(35)=''     
AS     
BEGIN   
          
--EXEC [172.31.16.94].[DMAT].DBO.USP_GetClientDRF_DP_CDSL_RTAProcessStatus @DRFNo  
          
 SELECT ROW_NUMBER() OVER(ORDER BY DRFId) 'SRNo', * INTO #DRFStatus   
 FROM(     
  SELECT DRFIRPM.DRFId, DRFIRPM.DRFNo,     
  DRFIRPM.ClientId,DRFIRPM.ClientName,DRFIRPM.MobileNo,DRFIRPD.CompanyName,     
  DRFIRPD.Quantity,DRFIRPM.NoOfCertificates, AMCD.ClientEmailId 'Email',  
    
     
  CASE WHEN DRFIRPM.IsRejected=0 AND ISNULL(DRFIRPM.DRFNo,'')<>''    
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END 'DRF Courier Receieved From Client',  
  
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>''    
  THEN CONVERT(VARCHAR(20),DRFIRPM.InwordProcessDate,113) END 'DRF Courier Receieved & Rejected due to Invalid Client Id',    
  
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>'' AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=1 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'Rejected due to Invalid Client Id - DRF Send to Client',    
   
  CASE WHEN DRFIRPM.IsRejected=1 AND ISNULL(DRFIRPM.DRFNo,'')<>'' AND ISNULL(RDRFOPRD.IsFileGenerate,0)=1 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed',  
  
  CASE WHEN ISNULL(CDRFID.DocumentName,'')<>''  
  THEN CONVERT(VARCHAR(20),CDRFID.ProcessDate,113) END 'DRF Scanning',  
    
 -- CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=0      
 --THEN CONVERT(VARCHAR(20),CDRFAAVD.ProcessDate,113) END 'DRF Hold Due to Pending e-sign Aadhar Authantication Documents',      
        
 --CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.IsESignDocumentUpload,0)=1      
 --THEN CONVERT(VARCHAR(20),CDRFAAVD.IsESignDocUploadDate,113) END 'DRF e-sign Aadhar Authantication Documents Upload And Verified',  
  
CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 THEN   
 CONVERT(VARCHAR(20),CDRFAAESDAPID.RequestSendDate) END  
  'DRF Hold Due to Pending e-sign Aadhar Authantication Documents' ,  
  
 CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND CAST(CDRFAAESDAPID.ExpiryDate as date)< CAST(getdate() as date)  
 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=0 AND ISNULL(DRFMCPT.IsCheckerRejected,0)=0 THEN   
  CONVERT(VARCHAR(20),CDRFAAESDAPID.ExpiryDate) END   
  'DRF Hold - Aadhar Authantication e-sign Link Expired' ,  
  
CASE WHEN ISNULL(CDRFAAVD.AppStatus,'')='Hold' AND ISNULL(CDRFAAVD.ApplicationType,'')='Offline' AND  
 ISNULL(CDRFAAESDAPID.IsRequestSendForESign,0)=1 AND ISNULL(CDRFAAESDAPID.IsResponseForESign,0)=1   
 THEN CONVERT(VARCHAR(20),CDRFAAESDAPID.ResponseUploadDate) END   
 'DRF e-sign Aadhar Authantication Documents Upload And Verified',  
  
  
  CASE WHEN ISNULL(DRFMCPT.IsMakerProcess,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.MakerProcessDate,113) END 'DRF Verfication by DP - Maker',  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerProcess,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END 'DRF Verfication by DP - Checker',  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CheckerProcessDate,113) END 'DRF Verfication by DP - Rejected',  
  
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=2 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'DP - Rejected DRF Send to Client',    
   
  CASE WHEN ISNULL(DRFMCPT.IsCheckerRejected,0)=1  AND ISNULL(RDRFOPRD.IsFileGenerate,0)=2 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'DP - Rejected DRF Received by the Client And Closed',  
  
    
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1   
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Upload to CDSL',  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1  
  THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Rejected by CDSL',  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND (ISNULL(RDRFOPRD.IsFileGenerate,0)=3 OR ISNULL(RDRFOPRD.IsResponseUpload,0)=1)   
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END 'CDSL Rejected DRF Send to Client',  
  
  CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1  
  AND ISNULL(DRFMCPT.IsCDSLRejected,0)=1 AND ISNULL(RDRFOPRD.IsFileGenerate,0)=3 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
  AND RDRFOPRD.IsDocumentReceived=1 AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END 'CDSL Rejected DRF Received by the Client And Closed',  
          
 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'')<>'' AND ISNULL(DRFMCPT.DRNNo,'')<>''  
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0  
 THEN CONVERT(VARCHAR(20),DRFMCPT.CDSLProcessDate,113) END 'DRF Setup in CDSL',  
  
 CASE WHEN ISNULL(DRFMCPT.BatchUploadInCDSL,0)=1 AND ISNULL(DRFMCPT.BatchNo,'')<>'' AND ISNULL(DRFMCPT.DRNNo,'')<>''  
 AND ISNULL(DRFMCPT.IsCDSLRejected,0)=0  AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1  
 THEN CONVERT(VARCHAR(20),DRFMCPT.DispatchDate,113) END 'RTA Letter Generation',  
  
 CASE WHEN ISNULL(DRFMCPT.IsCDSLRejected,0)=0 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1  
 AND (ISNULL(TDRFORSRTAD.IsFileGenerate,0)=5  OR ISNULL(TDRFORSRTAD.IsResponseUpload,0)=0)   
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.FileGenerateDate,113) END 'DRF Dispatch to RTA - Maker',   
  
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1     
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END 'DRF Dispatch to RTA - Checker' ,      
       
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND ISNULL(TDRFORSRTAD.IsResponseUpload,0)=1     
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.ResponseUploadDate,113) END 'DRF Send to RTA' ,      
   
 CASE WHEN TDRFORSRTAD.IsFileGenerate=5 AND ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND TDRFORSRTAD.IsResponseUpload=1  
 AND TDRFORSRTAD.IsDocumentReceived=1 AND ISNULL(TDRFORSRTAD.StatusGroup,'') = 'DL'  
 THEN CONVERT(VARCHAR(20),TDRFORSRTAD.DocumentReceivedDate,113) END  'Courier Received by RTA',  
   
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') ='CONFIRMED (CREDIT CURRENT BALANCE)'  
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'DRF converted in Demat & Closed',  
   
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')  
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'RTA Rejected',  
  
 CASE WHEN ISNULL(DRFMCPT.RTALetterGenerate,0)=1 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')   
 AND DATEDIFF(day,RTAProcessDate,getdate())>1  AND ISNULL(DRFIRBRTA.DRFId,0) =0  
 THEN CONVERT(VARCHAR(20),DRFMCPT.RTAProcessDate,113) END  'RTA Rejected, but not Courier Received by DP',  
   
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')  
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0   
 THEN CONVERT(VARCHAR(20),DRFIRBRTA.DocumentReceivedDate,113) END  'RTA Rejected DRF Received by DP',  
  
 CASE WHEN DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')  
 AND ISNULL(DRFIRBRTA.DRFId,0) <>0 AND ISNULL(RTARDSD.DRFId,0)<>0  
 THEN CONVERT(VARCHAR(20),RTARDSD.ProcessDate,113) END  'RTA Rejected DRF Memo Scanned',  
  
  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  THEN CONVERT(VARCHAR(20),RDRFOPRD.FileGenerateDate,113) END      
  'RTA Rejected letter sent to Client - Maker',       
        
  CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')       
AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1      
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END      
   'RTA Rejected letter sent to Client - Checker',  
   CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=0      
  AND ISNULL(RDRFOPRD.StatusGroup,'') IN('', 'IT' )     
  THEN CONVERT(VARCHAR(20),RDRFOPRD.ResponseUploadDate,113) END      
 'RTA Rejected DRF Sent to Client- In Trasit',  
      
 CASE WHEN ISNULL(RDRFOPRD.IsFileGenerate,0)=4 AND DRFMCPT.IsRTAProcess=1 AND ISNULL(RTARemarks,'') NOT IN('CONFIRMED (CREDIT CURRENT BALANCE)','')       
  AND ISNULL(RTARDSD.DRFId,0)<>0 AND ISNULL(DRFIRBRTA.DRFId,0) <>0       
  AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1 AND RDRFOPRD.IsDocumentReceived=1       
  AND ISNULL(RDRFOPRD.StatusGroup,'') = 'DL'  
  THEN CONVERT(VARCHAR(20),RDRFOPRD.DocumentReceivedDate,113) END      
 'RTA Rejected DRF Received by the Client & Closed',  
   
 CASE WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=0  
 AND ISNULL(RDRFOPRD.IsFileGenerate,0)<>0 AND ISNULL(RDRFOPRD.IsResponseUpload,0)=1   
 AND ISNULL(RDRFOPRD.StatusGroup,'') IN('RT','UD') AND ISNULL(UDCDRFID.IsDocumentReceived,0)=0  
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END 'DRF UnDelivered, Return Received by DP team',  
  
 CASE WHEN ISNULL(UDCDRFID.PodNo,'')<>'' AND ISNULL(UDCDRFID.IsReProcess,0)=1  
 AND ISNULL(UDCDRFID.IsDocumentReceived,0)=1  
THEN CONVERT(VARCHAR(20),UDCDRFID.InwordProcessDate,113) END 'DRF UnDelivered, Resend to Client And Closed'  
  
 FROM tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
 JOIN tbl_DRFInwordRegistrationProcessDetails DRFIRPD WITH(NOLOCK)  
 ON DRFIRPM.DRFId = DRFIRPD.DRFId  
 LEFT JOIN tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD WITH(NOLOCK)  
 ON RDRFOPRD.DRFId = DRFIRPM.DRFId  
 LEFT JOIN DRFInwordRegistrationReceivedByRTADetails DRFIRBRTA WITH(NOLOCK)  
 ON DRFIRBRTA.DRFId = DRFIRPM.DRFId  
  LEFT JOIN tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAD WITH(NOLOCK)          
 ON TDRFORSRTAD.DRFId = DRFIRPM.DRFId  
 --LEFT JOIN tbl_DRFMakerCheckerProcess_temp DRFMCPT WITH(NOLOCK)  
 --ON DRFMCPT.DRFId = DRFIRPM.DRFId  
 --LEFT JOIN [172.31.16.94].DMAT.DBO.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails DRFMCPT WITH(NOLOCK)  
 --ON DRFMCPT.DRFNo = DRFIRPM.DRFNo AND  DRFIRPM.IsRejected=0        
  LEFT JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFMCPT WITH(NOLOCK)          
 ON DRFIRPM.DRFId = DRFMCPT.DRFId --AND DRFMCPT.DRFNo='DRF_Test001'     
 LEFT JOIN tbl_ClientDRFInwordDocuments CDRFID WITH(NOLOCK)  
 ON CDRFID.DRFId = DRFIRPM.DRFId  
 LEFT JOIN tbl_RTARejectedDRFMemoScannedDocument RTARDSD WITH(NOLOCK)  
 ON DRFIRPM.DRFId = RTARDSD.DRFId   
 LEFT JOIN tbl_UndeliveredClientDRFInwordDetails UDCDRFID WITH(NOLOCK)  
 ON DRFIRPM.DRFId = UDCDRFID.DRFId  
 JOIN tbl_DRFProcessClientMailStatusDetails AMCD WITH(NOLOCK)    
ON DRFIRPM.DRFId = AMCD.DRFId        
 LEFT JOIN ClientDRFAadharAuthenticationVerificationDetails CDRFAAVD WITH(NOLOCK)       
 ON CDRFAAVD.DRFId=DRFIRPM.DRFId AND CDRFAAVD.ClientDPId = DRFIRPM.ClientId     
 LEFT JOIN tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails CDRFAAESDAPID WITH(NOLOCK)  
 ON DRFIRPM.DRFId= CDRFAAESDAPID.DRFId  
 WHERE DRFIRPM.DRFNo = @DRFNo     
 ) A     
UNPIVOT  
 (  
 ProcessDate For DRFStatus IN  
 (  
 [DRF Courier Receieved From Client],  
 [DRF Courier Receieved & Rejected due to Invalid Client Id],  
 [Rejected due to Invalid Client Id - DRF Send to Client],  
 [DRF Rejected due to Invalid Client Id - Courier Received by the Client And Closed],  
 [DRF Scanning],        
 [DRF Hold Due to Pending e-sign Aadhar Authantication Documents],      
 [DRF Hold - Aadhar Authantication e-sign Link Expired],  
 [DRF e-sign Aadhar Authantication Documents Upload And Verified],     
 [DRF Verfication by DP - Maker],  
 [DRF Verfication by DP - Checker],     
 [DRF Verfication by DP - Rejected],     
 [DP - Rejected DRF Send to Client],  
 [DP - Rejected DRF Received by the Client And Closed],  
 [DRF Upload to CDSL],  
 [DRF Rejected by CDSL],  
 [CDSL Rejected DRF Send to Client],  
 [CDSL Rejected DRF Received by the Client And Closed],  
 [DRF Setup in CDSL],  
 [RTA Letter Generation],  
 [DRF Dispatch to RTA - Maker],  
 [DRF Dispatch to RTA - Checker],        
 [DRF Send to RTA],      
 [Courier Received by RTA],  
 [DRF converted in Demat & Closed],  
 [RTA Rejected],  
 [RTA Rejected, but not Courier Received by DP],  
 [RTA Rejected DRF Received by DP],  
 [RTA Rejected DRF Memo Scanned],  
 [RTA Rejected letter sent to Client - Maker],  
 [RTA Rejected letter sent to Client - Checker],   
 [RTA Rejected DRF Sent to Client- In Trasit],  
 [RTA Rejected DRF Received by the Client & Closed],  
 [DRF UnDelivered, Return Received by DP team] ,  
 [DRF UnDelivered, Resend to Client And Closed]   
   
 )  
 )As UnPvt     
  
 IF EXISTS(SELECT * FROM #DRFStatus)  
 BEGIN  
   
DECLARE @xml NVARCHAR(MAX)  
DECLARE @body NVARCHAR(MAX)  
DECLARE @ClientName VARCHAR(255) = ( SELECT TOP 1 ClientName FROM #DRFStatus)  
DECLARE @EmailId VARCHAR(255) = ( SELECT  TOP 1 Email FROM #DRFStatus)  
DECLARE @Subject VARCHAR(MAX)= 'DRF PROCESS STATUS'   
  
 SET @xml = CAST(( SELECT [DRFNo] AS 'td','', [ClientId] AS 'td' ,'', [ClientName] AS 'td'     
 ,'', [CompanyName] AS 'td','', [Quantity] AS 'td' ,'', [NoOfCertificates] AS 'td'   
 ,'', [DRFStatus] AS 'td','', [ProcessDate] AS 'td'  
FROM #DRFStatus  
  
  
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))  
  
SET @body ='<p style="font-size:medium; font-family:Calibri">  
  
 <b>Dear '+@ClientName+' </b>,<br /><br />  
  
Please find your DRF Process complete Status Report.  
  
 </H2>  
  
<table border=1   cellpadding=2 cellspacing=2>  
  
<tr style="background-color:rgb(201, 76, 76); color :White">  
  
<th> DRFNo </th> <th> ClientId </th> <th> ClientName </th> <th> Script Name </th> <th> Quantity </th>  <th> NoOfCertificates </th> <th> DRF Status </th> <th> ProcessDate </th> '  
  
 SET @body = @body + @xml +'</table></body></html>  
  
<br /> <br />   
  
<br />Thanks & Regards,<br /><br />   
Angel One Ltd. <br />  
System Generated Mail'  
    EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL  
  
@profile_name = 'AngelBroking',  
  
@body = @body,  
  
@body_format ='HTML',  
  
@recipients = @EmailId,  
--@recipients = 'pegasusinfocorp.suraj@angelbroking.com',  
  
@blind_copy_recipients ='rajesh.thalkar@angelbroking.com; sm.nachiket@angelbroking.com;',  
--@blind_copy_recipients ='hemantp.patel@angelbroking.com',  
  
@subject = @Subject ;  
  
END     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateClientDRFAadharAuthenticationESignStatus
-- --------------------------------------------------

CREATE PROCEDURE USP_UpdateClientDRFAadharAuthenticationESignStatus
@ESignDocumentId bigint=0,@DRFId bigint=0, @documentId VARCHAR(25)='', @Status VARCHAR(35)='',
@Signed bit=0,@IsExpired bit=0
AS
BEGIN
IF EXISTS(SELECT * FROM tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails WITH(NOLOCK) WHERE ESignDocumentId=@ESignDocumentId AND DRFId=@DRFId AND documentId=@documentId)
BEGIN
UPDATE tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails SET 
IsResponseForESign= CASE WHEN ISNULL(@Signed,0)=1 THEN 1 WHEN ISNULL(@Status,'')='COMPLETED' THEN 1 ELSE 0 END,
ResponseUploadDate= CASE WHEN ISNULL(@Signed,0)=1 THEN GETDATE() WHEN ISNULL(@Status,'')='COMPLETED' THEN GETDATE() ELSE '' END,
ESignStatus = CASE WHEN @IsExpired=1 THEN 'Expired' ELSE 'Active' END
WHERE ESignDocumentId= @ESignDocumentId AND DRFId=@DRFId AND DocumentId=@documentId
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateClientSEBIPayoutUnBlockingDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_UpdateClientSEBIPayoutUnBlockingDetails           
@SEBI_BlockingId bigint=0, @CltCode VARCHAR(15)='',         
@FileName VARCHAR(350), @UnBlockingRemarks VARCHAR(max) ='' ,        
@UnBlockedBy VARCHAR(15)=''          
AS          
BEGIN          
UPDATE tbl_ClientSebiPayoutBlockingDetails SET IsUnBlocked=1,         
UnBlockingFileName = @FileName,        
UnBlockingRemarks=Replace(Replace(@UnBlockingRemarks,'  ',' '),'''',''),        
UnBlockingDate=GETDATE(), UnBlockedBy=@UnBlockedBy          
WHERE SEBI_BlockingId=@SEBI_BlockingId          
    
    
    
--- Mailer Logic    
                
Declare @url varchar(500)=null;    
declare @subject nvarchar(500)=null,@body nvarchar(max)=null       
              
SELECT TOP 1     
@url='\\10.253.16.26\upload1\ClientPayoutBlockingUnBlockingDoc\'+@FileName+''          
                 
    
set @subject='Client SEBI Payout UnBlock - '+@CltCode+''    
    
set @body='<pre style="font-family:Calibri;font-size:medium"><strong>Dear All,</strong></pre>    
    
<pre style="font-family:Calibri;font-size:medium">  
Action taken against SEBI Payout. <br />  
<strong>Client Code :-</strong> '+@CltCode+'   
<strong>Type :-</strong> UnBlocked   
<strong>Reason/Remark :-</strong>  '+Replace(@UnBlockingRemarks,char(13),'')+'   
Detail Report-Attached   
<br />  
     
<strong>  
Regards,    
SEBI Payout Team  </strong>  
<pre>'    
               
               
----EXEC [INTRANET].MSDB.DBO.SP_SEND_DBMAIL       
EXEC [CSOKYC-6].MSDB.DBO.SP_SEND_DBMAIL    
@RECIPIENTS ='pmla.cso@angelbroking.com;jignesh@angelbroking.com;dhanesh.magodia@angelbroking.com;hemantp.patel@angelbroking.com;banking@angelbroking.com;santhosh.shastry@angelbroking.com;fdssupport@angelbroking.com;',   
--@blind_copy_recipients ='pegasusinfocorp.suraj@angelbroking.com;',    
---@PROFILE_NAME ='GST invoice', -- intranet ,          
 @profile_name = 'AngelBroking',        
@BODY_FORMAT ='HTML',       
@SUBJECT =@subject ,    
--@copy_recipients='remisier@angelbroking.com',    
@BODY =@body,    
@file_attachments=@url;    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateDRFInwordProcessDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpdateDRFInwordProcessDetails]
(
@ClientId VARCHAR(50),@PodNo VARCHAR(30),@CourierName VARCHAR(250),@DRFId int,@DRFNo VARCHAR(30)        
, @CompanyName VARCHAR(500),@Quantity int, @NoOfCertificates int
)
AS
BEGIN
DECLARE @PodId int , @ClientName VARCHAR(500)='', @MobileNo VARCHAR(15)='',@SBTag VARCHAR(15)='',        
@CltCode VARCHAR(15)='',@EmailId VARCHAR(255)='',@OldClientId VARCHAR(35)='', @ISIN VARCHAR(35)=''        

-- 
/* Old Code Commented        
SELECT TOP 1 * INTO #ClientDetails FROM(        
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'         
FROM [172.31.16.94].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)         
 WHERE TBLCM.CLIENT_CODE =@ClientId         
UNION        
SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo'         
FROM [172.31.16.141].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)         
 WHERE TBLCM.CLIENT_CODE =@ClientId         
)AA */ 
        
        
CREATE TABLE #ClientDetails        
(        
 ClientId varchar(35),CLTCode varchar(15), ClientName varchar(255)    
, SBTag varchar(15), PANNO varchar(15), MobileNo varchar(15),email VARCHAR(255)
) 

--INSERT INTO #ClientDetails
--EXEC [172.31.16.94].DMAT.dbo.[USP_GetDRFProcessClientDetails] @ClientId        
  
INSERT INTO #ClientDetails   
SELECT * FROM (   
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'         
FROM [AGMUBODPL3].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)       
 WHERE TBLCM.CLIENT_CODE  = @ClientId        
UNION    
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'       
FROM [AngelDP5].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)       
 WHERE TBLCM.CLIENT_CODE  = @ClientId
UNION    
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'       
FROM [ATMUMBODPL03].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)       
 WHERE TBLCM.CLIENT_CODE = @ClientId 
 UNION    
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'       
FROM [AOPR0SPSDB01].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)       
 WHERE TBLCM.CLIENT_CODE = @ClientId 

 /*UNION    
 SELECT DISTINCT TBLCM.CLIENT_CODE 'ClientId', TBLCM.NISE_PARTY_CODE 'CLTCode', TBLCM.FIRST_HOLD_NAME 'ClientName'
,'' 'SBTag',TBLCM.ITPAN 'PANNO' ,FIRST_HOLD_PHONE 'MobileNo',EMAIL_ADD 'email'       
FROM [10.253.78.167,13442].inhouse.dbo.TBL_CLIENT_MASTER TBLCM WITH(NOLOCK)       
 WHERE TBLCM.CLIENT_CODE = @ClientId 
 */
 )AA     

        
SET @ClientName = (SELECT ClientName FROM  #ClientDetails )        
SET @MobileNo = (SELECT MobileNo FROM  #ClientDetails )        
SET @CltCode = (SELECT CLTCode FROM  #ClientDetails )        
SET @PodId = (SELECT DISTINCT PodId FROM tbl_DRFInwordRegistrationProcessMaster WHERE DRFId=@DRFId)        
SET @SBTag = (SELECT sub_broker FROM anand1.msajag.dbo.client_details WITH(NOLOCK) WHERE party_code =@CltCode)        
SET @EmailId = (SELECT email FROM anand1.msajag.dbo.client_details WITH(NOLOCK) WHERE party_code =@CltCode)        
SET @OldClientId = (SELECT DISTINCT ClientId FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFId=@DRFId)        
--SET @ISIN = (SELECT DISTINCT ISINNo FROM tbl_DRFInwordRegistrationProcessDetails WITH(NOLOCK) WHERE DRFId=@DRFId)        
SET @ISIN = (SELECT TOP 1 ISIN_CD FROM [AGMUBODPL3].DMAT.[citrus_usr].ISIN_MSTR WITH(NOLOCK) WHERE ISIN_COMP_NAME=@CompanyName)
        
IF(ISNULL(@ClientName,'')<>'')        
BEGIN
UPDATE tbl_DRFInwordRegistrationProcessMaster SET ClientId=@ClientId, ClientName=@ClientName,MobileNo=@MobileNo, DRFNo=@DRFNo,NoOfCertificates=@NoOfCertificates ,IsRejected=0 ,IsRejectionRemarks=''
WHERE DRFId=@DRFId        

UPDATE tbl_DRFInwordRegistrationProcessDetails SET CompanyName=@CompanyName,Quantity=@Quantity,        
UpdationDate= GETDATE()  ,Status='0',RejectionRemarks=''
WHERE DRFId=@DRFId        
END
        
UPDATE tbl_DRFProcessClientMailStatusDetails SET ClientId=@ClientId,ClientEmailId=@EmailId,        
SBTag=@SBTag,CLTCode=@CltCode WHERE DRFId=@DRFId         
        
UPDATE tbl_DRFPodInwordRegistrationProcess SET PodNo=@PodNo,CourierName=@CourierName        
WHERE PodId=@PodId        
        
SELECT ROW_NUMBER() OVER(ORDER BY ProcessDate) 'SR',* INTO #AuthDetails         
FROM ClientDRFAadharAuthenticationVerificationDetails WITH(NOLOCK)        
where ClientDPId=@OldClientId        
ORDER BY ProcessDate        
        
IF EXISTS(SELECT * FROM #AuthDetails)        
BEGIN        
DECLARE @SRNo int=0,@TotalCost decimal(17,2)=0        
SET @SRNo = (SELECT SR FROM #AuthDetails WHERE DRFId=@DRFId)        
SET @TotalCost = (SELECT TotalCost FROM #AuthDetails WHERE DRFId=@DRFId)        
        
IF EXISTS(SELECT * FROM #AuthDetails WHERE SR>@SRNo)        
BEGIN        
        
UPDATE CDRFAAD SET CommulativeValuation= CDRFAAD.CommulativeValuation- @TotalCost        
FROM ClientDRFAadharAuthenticationVerificationDetails CDRFAAD        
JOIN #AuthDetails AD        
ON CDRFAAD.ClientDPId = AD.ClientDPId AND CDRFAAD.DRFId = AD.DRFId        
WHERE AD.SR> @SRNo        
        
DELETE FROM ClientDRFAadharAuthenticationVerificationDetails WHERE DRFId=@DRFId        
END        
ELSE        
BEGIN        
DELETE FROM ClientDRFAadharAuthenticationVerificationDetails WHERE DRFId=@DRFId        
END        
    
  
--- Check Client Aadhar Authentication Process  
--EXEC [AGMUBODPL3].DMAT.DBO.USP_ValidateClientDRFAadharAuthenticationDetails @CltCode,@ClientId,@DRFId,@Quantity,@ISIN   
  
  EXEC USP_ValidateClientDRFAadharAuthenticationDetails @CltCode,@ClientId,@DRFId,@Quantity,@ISIN   
  
END        

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateIntermediaryRejectionReProcessStatus
-- --------------------------------------------------

Create Procedure USP_UpdateIntermediaryRejectionReProcessStatus
@IntermediaryId bigint=0, @Remarks VARCHAR(MAX)=''
AS
BEGIN

UPDATE tbl_IntermediaryMasterGeneralDetails SET Remarks='1',Notes=@Remarks
WHERE IntermediaryId=@IntermediaryId
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateJVLedgerEntryOffline
-- --------------------------------------------------

CREATE Procedure USP_UpdateJVLedgerEntryOffline
AS
BEGIN
Update IntersegmentJV_OfflineLedger Set IsUpdatetoLive=1 where vdate= cast(GETDATE() as date) 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateSBPayoutDepositProcessDetailsInLMS
-- --------------------------------------------------
CREATE PROCEDURE USP_UpdateSBPayoutDepositProcessDetailsInLMS
@RefId bigint,@SBPanNo VARCHAR(15), @RefNo VARCHAR(35),@Amount decimal,@Extension VARCHAR(10)
,@File Image='',@FileName VARCHAR(255), @Remarks VARCHAR(255)
AS
BEGIN
IF(CAST(@File AS BINARY(4) ) != '')
BEGIN
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET RefNo=@RefNo, Amount = @Amount, Extension= @Extension,
Files = @File, FileName=@FileName,Remarks = @Remarks,IsSBRejected=0,UpdatedOn = CAST(GETDATE() as date)
WHERE SBPanNo=@SBPanNo AND DepositRefId=@RefId
END
ELSE
BEGIN
UPDATE tbl_SBPayoutDepositProcessDetailsInLMS SET RefNo=@RefNo, Amount = @Amount
,Remarks = @Remarks,IsSBRejected=0,UpdatedOn = CAST(GETDATE() as date)
WHERE SBPanNo=@SBPanNo AND DepositRefId=@RefId
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateShortageMarginJVLedgerEntryOffline
-- --------------------------------------------------
CREATE Procedure USP_UpdateShortageMarginJVLedgerEntryOffline  
AS  
BEGIN  
Update ShortageMarginJV_OfflineLedger Set IsUpdatetoLive=1 where vdate= cast(GETDATE() as date)   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UpdateStatusJVLedgerEntryOffline
-- --------------------------------------------------
CREATE Procedure USP_UpdateStatusJVLedgerEntryOffline  
AS  
BEGIN  
Update ShortageMarginJV_OfflineLedger Set IsUpdatetoLive=1 where vdate= cast(GETDATE() as date)   
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UploadAndSaveClientBlockingDetails
-- --------------------------------------------------
 
CREATE PROCEDURE USP_UploadAndSaveClientBlockingDetails        
@ClientSebiPayoutBlockingProcess ClientSebiPayoutBlockingProcess readonly,        
@FileName VARCHAR(350)='', @Extension VARCHAR(10)=''        
,@BlockingBy VARCHAR(15)=''        
AS        
BEGIN        
SELECT DISTINCT * INTO #Test FROM @ClientSebiPayoutBlockingProcess        
        
        
SELECT DISTINCT TT.*,AMCD.sub_broker 'SBTag',AMCD.branch_cd 'BranchCode'        
,AMCD.long_name 'ClientName' INTO #ClientDetails        
FROM #Test TT        
JOIN anand1.msajag.dbo.client_details AMCD WITH(NOLOCK)        
ON ClientCode = cl_code         
    
SELECT DISTINCT * INTO #ClientBlockingDetails FROM (    
SELECT ClientPanNo,ClientCode,BlockingBy 'BlockingBy' FROM #ClientDetails    
EXCEPT     
SELECT ClientPanNo,CltCode 'ClientCode',BlockingTeam 'BlockingBy' FROM tbl_ClientSebiPayoutBlockingDetails WHERE IsUnBlocked=0    
)AA    
        
IF EXISTS(SELECT * FROM #ClientDetails)        
BEGIN        
--INSERT INTO tbl_ClientSebiPayoutBlockingDetails        
--SELECT ClientPanNo,ClientCode,ClientName,BranchCode,SBTag,@Extension,@FileName,BlockingBy,Remarks,GETDATE(),@BlockingBy,0,'','','',''        
--FROM #ClientDetails WHERE ClientCode NOT IN(SELECT Distinct ClientCode FROM #ClientBlockingDetails)

INSERT INTO tbl_ClientSebiPayoutBlockingDetails        
SELECT CD.ClientPanNo,CD.ClientCode,CD.ClientName,BranchCode,SBTag,@Extension,@FileName,CD.BlockingBy,Remarks,GETDATE(),@BlockingBy,0,'','','',''        
FROM #ClientDetails CD
JOIN #ClientBlockingDetails CBD
ON CD.ClientPanNo=CBD.ClientPanNo
AND CD.ClientCode=CBD.ClientCode 
AND CD.BlockingBy=CBD.BlockingBy  

END        
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UploadBlukDRFScanningDocuments
-- --------------------------------------------------

CREATE PROCEDURE USP_UploadBlukDRFScanningDocuments                   
@DocumentName VARCHAR(450)=''  ,@IsMemoScanned bit=0 ,@CreatedBy VARCHAR(35)=''              
AS                  
BEGIN                  
DECLARE @DRFNo VARCHAR(35)='', @DRFId bigint=0,@ClientId bigint=0, @TransferName VARCHAR(250)=''             
            
IF(@IsMemoScanned=1)            
BEGIN  
DECLARE @DRNNo VARCHAR(35)='' 
SET @DRNNo = (SELECT SUBSTRING(@DocumentName,0,CHARINDEX('.',@DocumentName,0)))       

IF NOT EXISTS(SELECT * FROM tbl_RTARejectedDRFMemoScannedDocument WITH(NOLOCK) WHERE DRNNO=@DRNNo)                  
BEGIN       
       
SET @DRFId = (SELECT DISTINCT DRFId FROM DRFInwordRegistrationReceivedByRTADetails WHERE DRNNo = @DRNNo)      
-- SET @DRFId = (SELECT DISTINCT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo=@DRFNo AND IsRejected=0)                  
            
INSERT INTO tbl_RTARejectedDRFMemoScannedDocument            
VALUES(@DRFId,@DRNNo,@DocumentName,'10.253.16.26/upload1/DRFMemoDocuments/',GETDATE(),@CreatedBy)            
END            
END            
ELSE            
BEGIN            
IF NOT EXISTS(SELECT * FROM tbl_ClientDRFInwordDocuments WITH(NOLOCK) WHERE DocumentName=@DocumentName)                  
BEGIN                  
SET @DRFNo = (SELECT SUBSTRING(@DocumentName,0,CHARINDEX('.',@DocumentName,0)))                   
SET @DRFId = (SELECT DRFId FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFNo=@DRFNo AND IsRejected=0)                  
SET @ClientId = (SELECT ClientId FROM tbl_DRFInwordRegistrationProcessMaster WITH(NOLOCK) WHERE DRFId=@DRFId)                  
SET @TransferName = (SELECT TOP 1 ToTransfered FROM tbl_ClientDRFInwordDocuments ORDER BY DRFDocumentId DESC )                  
                
IF(@DRFId<>0)                  
BEGIN                
IF EXISTS(SELECT * FROM tbl_ClientDRFInwordDocuments WHERE DRFId=@DRFId)                  
BEGIN                  
UPDATE tbl_ClientDRFInwordDocuments SET                  
FilePath='10.253.16.26/upload1/DRFDocuments/', DocumentName=@DocumentName,Extension='.PDF',                  
ProcessDate=GETDATE() WHERE DRFId=@DRFId                  
END                  
ELSE                  
BEGIN                  
INSERT INTO tbl_ClientDRFInwordDocuments                  
VALUES(@DRFId,@ClientId,1,GETDATE(),@TransferName,'10.253.16.26/upload1/DRFDocuments/',@DocumentName,'.PDF',GETDATE(),@CreatedBy)                  
END                  
END                  
END               
END            
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UploadClientDRFOutwordProcessPodDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UploadClientDRFOutwordProcessPodDetails]
@upd_DRFOutwordPodDetails upd_DRFOutwordPodDetails readonly  ,@ResponseBy VARCHAR(35)=''  
AS  
BEGIN  
SELECT  
CourierName,PodNo,UploadDate,LTRIM(RTRIM(DRFNo)) DRFNo ,REPLACE(StatusDescription,'''','') StatusDescription,  
StatusGroup,StatusDate,ReceivedBy  
INTO #PodDetails FROM @upd_DRFOutwordPodDetails  
  
----------  
  
------- Update Rejection data for Courier
  
SELECT RDRF.DRFId,RDRF.IsFileGenerate,RDRF.FileRemarks,IsCheckerRejected,CheckerProcessDate,  
IsCDSLRejected,CDSLProcessDate,IsRTAProcess,RTAProcessDate,RTA.DocumentReceivedDate,
CASE WHEN ISNULL(RTA.DRFId,0)<>0 THEN 'RTA'  
WHEN DRFCSD.IsCDSLRejected =1 THEN 'CDSL'  
WHEN DRFCSD.IsCheckerRejected=1 THEN 'DP' END 'RejectedStatus' INTO #DRF_CourierDetails  
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails RDRF  
JOIN tbl_ClientDRFProcessCompleteStatusDetails DRFCSD  
ON RDRF.DRFId = DRFCSD.DRFId  
LEFT JOIN DRFInwordRegistrationReceivedByRTADetails RTA  
ON  RDRF.DRFId = RTA.DRFId --AND ISNULL(RTA.DRFId,0)<>0  
WHERE RDRF.IsFileGenerate=0
AND (DRFCSD.IsCDSLRejected =1 OR DRFCSD.IsCheckerRejected=1 OR ISNULL(RTA.DRFId,0)<>0)  
  
  
UPDATE RDRFOPRD
SET IsFileGenerate=(CASE WHEN DRFD.RejectedStatus='RTA' THEN 4
WHEN DRFD.RejectedStatus='CDSL' THEN  3  
WHEN DRFD.RejectedStatus='DP' THEN  2 END),  
FileRemarks= (CASE WHEN DRFD.RejectedStatus='RTA' THEN 'RTA Rejected letter sent to Client - Maker'
WHEN DRFD.RejectedStatus='CDSL' THEN  'DRF Rejected by CDSL'  
WHEN DRFD.RejectedStatus='DP' THEN  'DRF Verfication by DP - Rejected' END),  
FileGenerateDate=GETDATE()  
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails RDRFOPRD  
JOIN #DRF_CourierDetails DRFD  
ON RDRFOPRD.DRFId = DRFD.DRFId  
  
---------------------  
 
--SELECT * FROM #Test 
  
---- Sent to Client  
  
SELECT DISTINCT PD.PodNo INTO #ExistingDetails  
FROM #PodDetails PD  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFIRPM WITH(NOLOCK)  
ON PD.DRFNo = DRFIRPM.DRFNo  
JOIN tbl_DRFOutwordRegistrationSendToRTADetails DRFRSRTA WITH(NOLOCK)  
ON DRFRSRTA.DRFId = DRFIRPM.DRFId AND DRFRSRTA.PodNo = PD.PodNo  
  
  
UPDATE DRFORRPD SET IsResponseUpload=1,  ResponseRemarks='Upload',  
PodNo=PD.PodNo, CourierBy=PD.CourierName,CustomerCode='318883',  
ResponseUploadDate =  
CASE WHEN CAST(DRFORRPD.ResponseUploadDate as date) = '1900-01-01' THEN  
GETDATE() ELSE DRFORRPD.ResponseUploadDate END 
,IsDocumentReceived=CASE WHEN PD.StatusGroup = 'DL' THEN 1 ELSE 0 END 
,StatusDescription= Replace(PD.StatusDescription,'''','') 
,StatusGroup = PD.StatusGroup, 
StatusDate = CONVERT(datetime, PD.StatusDate,103) 
,DocumentReceivedDate = CASE WHEN PD.StatusGroup = 'DL' THEN GETDATE() ELSE '' END 
,DocumentReceivedBy = PD.ReceivedBy
,UploadedDate=PD.UploadDate
,ResponseBy=@ResponseBy  
  
FROM tbl_RejectedDRFOutwordProcessAndResponseDetails DRFORRPD WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)  
ON DRFORRPD.DRFId = DRFRPM.DRFId  
JOIN #PodDetails PD  
--JOIN @upd_DRFOutwordPodDetails PD  
ON PD.DRFNo = DRFRPM.DRFNo 
WHERE ISNULL(DRFORRPD.IsFileGenerate,0)<>0 AND ISNULL(DRFORRPD.IsDocumentReceived,0)=0  
AND ISNULL(DRFORRPD.StatusGroup,'') NOT IN('DL','RT')
AND PD.PodNo NOT IN(SELECT DISTINCT PodNo FROM #ExistingDetails)  
  
--AND ISNULL(DRFORRPD.DocumentReceivedBy,'')='' 
  
---- Send to RTA  
  
UPDATE TDRFORSRTAPD SET IsResponseUpload=1,  ResponseRemarks='Upload',  
PodNo=PD.PodNo, CourierBy=PD.CourierName,CustomerCode='318883',  
ResponseUploadDate =  
CASE WHEN CAST(TDRFORSRTAPD.ResponseUploadDate as date) = '1900-01-01' THEN  
GETDATE() ELSE TDRFORSRTAPD.ResponseUploadDate END 
,IsDocumentReceived=CASE WHEN PD.StatusGroup = 'DL' THEN 1 ELSE 0 END 
,StatusDescription= Replace(PD.StatusDescription,'''','') 
,StatusGroup = PD.StatusGroup, 
StatusDate = CONVERT(datetime, PD.StatusDate,103) 
,DocumentReceivedDate = CASE WHEN PD.StatusGroup = 'DL' THEN GETDATE() ELSE '' END 
,DocumentReceivedBy = PD.ReceivedBy 
,UploadedDate=PD.UploadDate
,ResponseBy=@ResponseBy
  
FROM tbl_DRFOutwordRegistrationSendToRTADetails TDRFORSRTAPD WITH(NOLOCK)  
JOIN tbl_DRFInwordRegistrationProcessMaster DRFRPM WITH(NOLOCK)  
ON TDRFORSRTAPD.DRFId = DRFRPM.DRFId  
JOIN #PodDetails PD
---JOIN @upd_DRFOutwordPodDetails PD  
ON PD.DRFNo = DRFRPM.DRFNo 
WHERE ISNULL(TDRFORSRTAPD.IsFileGenerate,0)<>0 AND ISNULL(TDRFORSRTAPD.IsDocumentReceived,0)=0 
AND ISNULL(TDRFORSRTAPD.StatusGroup,'')<> 'DL'
--AND ISNULL(TDRFORSRTAPD.DocumentReceivedBy,'')='' 
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateClientDRFAadharAuthenticationDetails
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ValidateClientDRFAadharAuthenticationDetails]
@CltCode VARCHAR(15)='', @ClientDPId VARCHAR(35)='',@DRFId bigint , @SharesQty bigint=0, @ISINNo VARCHAR(25)=''  
AS
BEGIN
--SELECT DISTINCT Fld_Application_No,KYCR.PARTY_Code INTO #ApplicationNo
--from [ABVSKYCMIS].kyc.dbo.kycregister KYCR with(NoLock)
--INNER JOIN [ABVSKYCMIS].KYC.dbo.Client_InwardRegister CIR With(noLock)
--ON KYCR.party_code = CIR.party_code
--WHERE KYCR.party_code  = @CltCode    
    
SELECT DISTINCT Fld_Application_No,PARTY_Code INTO #ApplicationNo
from [ABVSKYCMIS].KYC.dbo.client_inwardregister_PII CIR With(noLock) 
WHERE ISNULL(CIR.party_code,'') = @CltCode     


DECLARE @AppStatus VARCHAR(15)=''
SELECT CASE WHEN (ApplicationValue='W' OR  ApplicationValue='AB'
OR  ApplicationValue='SP' OR  ApplicationValue='MF')
THEN 'Online'
ELSE 'Offline' END 'ApplicationStatus' INTO #ApplicationStatus FROM (
SELECT  
case patindex('%[0-9]%', Fld_Application_No)
when 0 then Fld_Application_No
else left(Fld_Application_No, patindex('%[0-9]%', Fld_Application_No) -1 )  
end 'ApplicationValue'
FROM #ApplicationNo
)A

DECLARE @ApplicationNo VARCHAR(35)= (SELECT Fld_Application_No FROM #ApplicationNo)
SET @AppStatus = (SELECT ApplicationStatus FROM #ApplicationStatus)
  
  
SELECT Cl_code,Income_code 'Gross_incomeType',CASE  
WHEN Income_code='1' THEN 100000* 5
WHEN Income_code='2' THEN 200000* 5
WHEN Income_code='6' THEN 500000* 5
WHEN Income_code='7' THEN 1000000* 5
WHEN Income_code='8' THEN 2500000* 5
--WHEN Gross_income='05' THEN 5000000* 5
WHEN Income_code='9' OR Income_code='10' THEN 10000000* 5
WHEN Income_code='11' THEN 10000001* 5
END 'GrossIncome'
INTO #CltIncomeDetails  
FROM (   
SELECT Cl_code,MAX(Income_code) 'Income_code' FROM(  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,  
CMUD.Income_code,INCOME as Income   
FROM [AGMUBODPL3].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)  
on CLTD.Income_code = CMUD.Income_code  
WHERE NISE_PARTY_CODE = @CltCode  
UNION   
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,  
CMUD.Income_code,INCOME as Income   
FROM [AngelDP5].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)  
on CLTD.Income_code = CMUD.Income_code  
WHERE NISE_PARTY_CODE = @CltCode  
UNION  
  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,
CMUD.Income_code,INCOME as Income  
FROM [ATMUMBODPL03].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)
on CLTD.Income_code = CMUD.Income_code
WHERE NISE_PARTY_CODE = @CltCode   

UNION  
  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,
CMUD.Income_code,INCOME as Income  
FROM [AOPR0SPSDB01].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)
on CLTD.Income_code = CMUD.Income_code
WHERE NISE_PARTY_CODE = @CltCode   

UNION  
  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,
CMUD.Income_code,INCOME as Income  
FROM [ABVSDP204].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)
on CLTD.Income_code = CMUD.Income_code
WHERE NISE_PARTY_CODE = @CltCode     
 /*
 -- GPX Server  
  
UNION  
  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,
CMUD.Income_code,INCOME as Income  
FROM [10.253.78.167,13442].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)
on CLTD.Income_code = CMUD.Income_code
WHERE NISE_PARTY_CODE = @CltCode   
 
  -- Commanted on - NTT Server 
  
UNION  
  
Select CLTD.NISE_PARTY_CODE 'Cl_code',  CLTD.ITPAN,
CMUD.Income_code,INCOME as Income  
FROM [10.254.33.93,13442].DMAT.DBO.TBL_CLIENT_MASTER CLTD WITH(NOLOCK)   
LEFT OUTER JOIN [AGMUBODPL3].DMAT.[citrus_usr].INCOME_MST CMUD WITH(NOLOCK)
on CLTD.Income_code = CMUD.Income_code
WHERE NISE_PARTY_CODE = @CltCode   
 */

)A  
GROUP BY Cl_code  
)AA  

SELECT CLOPM_ISIN_CD,MAX(CLOPM_DT) 'ClosingDate' INTO #MaxClosingDate
FROM [AGMUBODPL3].DMAT.citrus_usr.closing_price_mstr_cdsl  WITH(NOLOCK)
where CLOPM_ISIN_CD=@ISINNo
GROUP BY CLOPM_ISIN_CD

SELECT CLOPM_CDSL_RT,CLOPM_ISIN_CD,CLOPM_DT INTO #ClosingDetails
FROM [AGMUBODPL3].DMAT.citrus_usr.closing_price_mstr_cdsl  WITH(NOLOCK)
where CLOPM_ISIN_CD=@ISINNo  


SELECT MCD.CLOPM_ISIN_CD,MCD.ClosingDate,CLOPM_CDSL_RT INTO #ClosingPrice 
FROM #MaxClosingDate MCD
JOIN #ClosingDetails CD
ON MCD.CLOPM_ISIN_CD = CD.CLOPM_ISIN_CD
AND CAST(MCD.ClosingDate as date)= CAST(CD.CLOPM_DT as date)
  
  
IF NOT EXISTS(SELECT * FROM #ClosingPrice)
BEGIN  
INSERT INTO #ClosingPrice VALUES('','',0)  
END

DECLARE @ClosingPrice decimal(17,2)=0,@ClientTotalCost decimal(17,2)=0,
@ClientGrossIncome decimal(17,2)=0,@IncomeType int=0
DECLARE @FacingValueCal decimal(17,2)= (SELECT CASE WHEN ISNULL(CAST(CLOPM_CDSL_RT as decimal(17,2)),0)=0 THEN 10 ELSE CAST(CLOPM_CDSL_RT as decimal(17,2)) END  FROM #ClosingPrice)

SET @ClosingPrice=  ISNULL(@FacingValueCal,10)
SET @ClientTotalCost =  (SELECT CAST(ISNULL(@FacingValueCal,10)*@SharesQty as decimal(17,2))  FROM #ClosingPrice)
SET @ClientGrossIncome = (SELECT CAST(GrossIncome as decimal(17,2))  FROM #CltIncomeDetails)  
SET @IncomeType =  (SELECT Gross_incomeType  FROM #CltIncomeDetails)
   
Declare @ClientOldClostingPrice decimal(17,2)=  (SELECT ISNULL(SUM(TotalCost),0) FROM ClientDRFAadharAuthenticationVerificationDetails WITH(NOLOCK) WHERE ClientDPId=@ClientDPId)   
   
DECLARE @ClientTotalOldAndnewClostingPrice decimal(17,2) =0   
SET @ClientTotalOldAndnewClostingPrice= ISNULL(@ClientTotalCost,0)  + ISNULL(@ClientOldClostingPrice,0)   


IF(@AppStatus='Online')
BEGIN


IF(ISNULL(@ClientGrossIncome,0)>ISNULL(@ClientTotalOldAndnewClostingPrice,0))
BEGIN
INSERT INTO ClientDRFAadharAuthenticationVerificationDetails
VALUES(@CltCode,@ClientDPId,@DRFId,@ApplicationNo,'Online','Process','Process'
,@IncomeType,5,ISNULL(@ClientGrossIncome,0),@SharesQty,ISNULL(@ClosingPrice,0),ISNULL(@ClientTotalCost,0),ISNULL(@ClientTotalOldAndnewClostingPrice,0),'Process','Process',0,'','','',GETDATE(),'Test')
END
ELSE
BEGIN
INSERT INTO ClientDRFAadharAuthenticationVerificationDetails
VALUES(@CltCode,@ClientDPId,@DRFId,@ApplicationNo,'Online','Hold','Hold due to Client Gross Income greater then Total Cost'
,@IncomeType,5,ISNULL(@ClientGrossIncome,0),@SharesQty,ISNULL(@ClosingPrice,0),ISNULL(@ClientTotalCost,0),ISNULL(@ClientTotalOldAndnewClostingPrice,0),'Hold','Hold due to Client Gross Income greater then Total Cost',0,'','','',GETDATE(),'Test')  

END

END
ELSE
BEGIN
INSERT INTO ClientDRFAadharAuthenticationVerificationDetails
VALUES(@CltCode,@ClientDPId,@DRFId,@ApplicationNo,'Offline','Hold','Hold due to Offline Account Opening'
,@IncomeType,5,ISNULL(@ClientGrossIncome,0),@SharesQty,ISNULL(@ClosingPrice,0),ISNULL(@ClientTotalCost,0),ISNULL(@ClientTotalOldAndnewClostingPrice,0),'Hold','Hold due to Offline Account Opening',0,'','','',GETDATE(),'Test')
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateExistingAndSaveNBFCFundingProcessDetails
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ValidateExistingAndSaveNBFCFundingProcessDetails] @SearchDate VARCHAR(25), @IsProcess2 bit
,@NBFCFundingProcessDetails_Save NBFCFundingProcessDetails_Save readonly 
AS
BEGIN

IF NOT EXISTS(SELECT * FROM tblNBFCFundingProcessDetails WITH(NOLOCK) WHERE NBFCFundingDate = @SearchDate AND IsProcess2=@IsProcess2)
BEGIN
 
 INSERT INTO tblNBFCFundingProcessDetails
 SELECT *,GETDATE(),@IsProcess2 FROM @NBFCFundingProcessDetails_Save
END

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateExistingNBFCFundingData
-- --------------------------------------------------

CREATE PROCEDURE USP_ValidateExistingNBFCFundingData @SearchDate VARCHAR(50), @IsProcess2 bit
AS
BEGIN  
SELECT DISTINCT VDATE FROM tbl_NBFCPostData WHERE IsProcess= @IsProcess2 AND CAST(VDATE as date) =CAST(@SearchDate as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateExistingNBFCShortageData
-- --------------------------------------------------

CREATE PROCEDURE USP_ValidateExistingNBFCShortageData @SearchDate VARCHAR(50)
AS
BEGIN  
SELECT DISTINCT VDATE FROM tbl_NBFCShortageProcessPostData WHERE  CAST(VDATE as date) = CAST(@SearchDate as date)  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateExistingPostedMailData
-- --------------------------------------------------

CREATE PROCEDURE USP_ValidateExistingPostedMailData @EnhencementDate VARCHAR(30)
AS
BEGIN
SELECT EnhencementDate FROM SubBrokerLimitEnhencementSummaryReport WITH(NOLOCK) WHERE CAST(EnhencementDate as date) = @EnhencementDate
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateForExistingDataAgainstFilter
-- --------------------------------------------------

CREATE Procedure USP_ValidateForExistingDataAgainstFilter @FromDate nvarchar(50),@ToDate nvarchar(50)  
AS  
BEGIN  
Select distinct StartDate, EndDate from ShortageMarginJV_OfflineLedger SMJOL WITH(NOLOCK)   
JOIN [AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES OLLE WITH(NOLOCK)   
ON SMJOL.vdate = OLLE.vdate AND SMJOL.AddBy = OLLE.AddBy AND OLLE.VoucherType=8 AND OLLE.AddBy='Remisier'   -- AND OLLE.RowState !=1   
WHERE ((StartDate between @FromDate and @ToDate) OR (EndDate between @FromDate and @ToDate))  
Union   
Select distinct StartDate, EndDate from  ShortageMarginJV_OfflineLedgerLogFile SMJOLLF WITH(NOLOCK)   
JOIN [AngelBSECM].account_ab.dbo.V2_OFFLINE_LEDGER_ENTRIES OLLE WITH(NOLOCK)   
ON SMJOLLF.vdate = OLLE.vdate AND SMJOLLF.AddBy = OLLE.AddBy AND OLLE.VoucherType=8 AND OLLE.AddBy='Remisier'  
where ((StartDate between @FromDate and @ToDate) OR (EndDate between @FromDate and @ToDate))  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ValidateSBIntermediaryExistingDetails
-- --------------------------------------------------

CREATE PROCEDURE USP_ValidateSBIntermediaryExistingDetails
@PanNo VARCHAR(15)='',@MobileNo VARCHAR(12)='', @EmailId VARCHAR(255)=''
AS
BEGIN
DECLARE @Condition VARCHAR(255)=''
IF(ISNULL(@PanNo,'')<>'')
BEGIN
SET @Condition = ' WHERE IMGD.PanNo = '''+@PanNo+''' '
END
IF(ISNULL(@MobileNo,'')<>'')
BEGIN
SET @Condition = ' WHERE IMAD.Mobile1 = '''+@MobileNo+''' '
END
IF(ISNULL(@EmailId,'')<>'')
BEGIN
SET @Condition = ' WHERE IMAD.Email = '''+@EmailId+''' '
END
 
EXEC('
SELECT TOP 1 * FROM tbl_IntermediaryMasterGeneralDetails IMGD WITH(NOLOCK)
LEFT JOIN tbl_IntermediaryMasterAddressDetails IMAD WITH(NOLOCK)
ON IMGD.IntermediaryId = IMAD.IntermediaryId
'+@Condition+'
')
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_VerifyAndSaveSBAddressChangeDocumentDetails
-- --------------------------------------------------

CREATE PROC USP_VerifyAndSaveSBAddressChangeDocumentDetails   
@SBTag VARCHAR(15),@Segment VARCHAR(10)='',@ProcessStatus VARCHAR(15)=''  
, @Remarks VARCHAR(MAX)='',@VerifyBy VARCHAR(15)=''  
AS  
BEGIN  
Update tbl_SBAddressChangeProcessDetails SET   
IsNSEVerified = CASE WHEN @Segment='NSE'  THEN @ProcessStatus ELSE IsNSEVerified END ,  
NSEStatus = CASE WHEN @Segment='NSE' THEN @Remarks ELSE NSEStatus END ,  
NSEVerificationDate =  CASE WHEN @Segment='NSE' THEN GETDATE() ELSE NSEVerificationDate END,  
  
IsBSEVerified = CASE WHEN @Segment='BSE' THEN @ProcessStatus ELSE IsBSEVerified END ,  
BSEStatus = CASE WHEN @Segment='BSE' THEN @Remarks ELSE BSEStatus END ,  
[BSEVerificationDate] =  CASE WHEN @Segment='BSE' THEN GETDATE() ELSE [BSEVerificationDate] END,  
  
IsNSEFOVerified = CASE WHEN @Segment='NSEFO' THEN @ProcessStatus ELSE IsNSEFOVerified END ,  
[NSEFOStatus] = CASE WHEN @Segment='NSEFO' THEN @Remarks ELSE [NSEFOStatus] END ,  
[NSEFOVerificationDate] =  CASE WHEN @Segment='NSEFO' THEN GETDATE() ELSE [NSEFOVerificationDate] END,  
  
[IsBSEFOVerified] = CASE WHEN @Segment='BSEFO' THEN @ProcessStatus ELSE [IsBSEFOVerified] END ,  
[BSEFOStatus] = CASE WHEN @Segment='BSEFO' THEN @Remarks ELSE [BSEFOStatus] END ,  
[BSEFOVerificationDate] =  CASE WHEN @Segment='BSEFO' THEN GETDATE() ELSE [BSEFOVerificationDate] END,  
  
[IsNSXVerified] = CASE WHEN @Segment='NSX' THEN @ProcessStatus ELSE [IsNSXVerified] END ,  
[NSXStatus] = CASE WHEN @Segment='NSX' THEN @Remarks ELSE [NSXStatus] END ,  
[NSXVerificationDate] =  CASE WHEN @Segment='NSX' THEN GETDATE() ELSE [NSXVerificationDate] END,  
  
[IsBSXVerified] = CASE WHEN @Segment='BSX' THEN @ProcessStatus ELSE [IsBSXVerified] END ,  
[BSXStatus] = CASE WHEN @Segment='BSX' THEN @Remarks ELSE [BSXStatus] END ,  
[BSXVerificationDate] =  CASE WHEN @Segment='BSX' THEN GETDATE() ELSE [BSXVerificationDate] END,  
  
[IsMCXVerified] = CASE WHEN @Segment='MCX' THEN @ProcessStatus ELSE [IsMCXVerified] END ,  
[MCXStatus] = CASE WHEN @Segment='MCX' THEN @Remarks ELSE [MCXStatus] END ,  
[MCXVerificationDate] =  CASE WHEN @Segment='MCX' THEN GETDATE() ELSE [MCXVerificationDate] END,  
  
[IsNCXVerified] = CASE WHEN @Segment='NCX' THEN @ProcessStatus ELSE [IsNCXVerified] END ,  
[NCXStatus] = CASE WHEN @Segment='NCX' THEN @Remarks ELSE [NCXStatus] END ,  
[NCXVerificationDate] =  CASE WHEN @Segment='NCX' THEN GETDATE() ELSE [NCXVerificationDate] END,  
   
 VerifiedBy=@VerifyBy  
 WHERE SBTag = @SBTag  
END

GO

-- --------------------------------------------------
-- TABLE dbo.BankingFilesEmailMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BankingFilesEmailMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Segment] NVARCHAR(50) NOT NULL,
    [BankName] NVARCHAR(100) NOT NULL,
    [BankCode] NVARCHAR(50) NOT NULL,
    [FileType] NVARCHAR(50) NOT NULL,
    [EmailSender] NVARCHAR(50) NOT NULL,
    [EmailReceiver] NVARCHAR(50) NOT NULL,
    [EmailReceiverPwd] NVARCHAR(50) NOT NULL,
    [EmailSubject] NVARCHAR(500) NOT NULL,
    [EmailReadTimeFrom] DATETIME NULL,
    [EmailReadTimeTo] DATETIME NULL,
    [EmailReadOrder] NVARCHAR(4) NOT NULL,
    [EmailReadPosition] INT NOT NULL,
    [IsZipFile] BIT NOT NULL,
    [EmailAttachmentLogic] NVARCHAR(100) NOT NULL,
    [EmailAttachmentType] NVARCHAR(100) NOT NULL,
    [ZipAttachmentType] NVARCHAR(500) NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] NVARCHAR(20) NULL,
    [IsAttachmentEncrypted] BIT NULL DEFAULT ((0)),
    [AttachmentPassword] NVARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_Master
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_Master]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [RegFrom] NVARCHAR(30) NULL,
    [RegTo] NVARCHAR(30) NULL,
    [SBTAG] NVARCHAR(30) NULL,
    [PanNo] NVARCHAR(30) NULL,
    [RegDate] DATETIME NULL,
    [RegState] NVARCHAR(20) NULL,
    [GST] DECIMAL(18, 0) NULL,
    [GSTAmount] DECIMAL(18, 0) NULL,
    [GSTValueType] NVARCHAR(20) NULL,
    [SegmentFeeType] NVARCHAR(20) NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [RecoveredAmount] DECIMAL(18, 0) NULL,
    [UnRecoveredAmount] DECIMAL(18, 0) NULL,
    [isRecovered] BIT NULL,
    [RecoveredDate] DATETIME NULL,
    [IsRightOff] BIT NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientDRFAadharAuthenticationVerificationDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientDRFAadharAuthenticationVerificationDetails]
(
    [CLTCode] VARCHAR(15) NULL,
    [ClientDPId] VARCHAR(50) NULL,
    [DRFId] BIGINT NULL,
    [ApplicationNo] VARCHAR(30) NULL,
    [ApplicationType] VARCHAR(15) NULL,
    [AppStatus] VARCHAR(15) NULL,
    [AppDescription] VARCHAR(650) NULL,
    [IncomeType] INT NULL,
    [MultiProcessValue] INT NULL,
    [TotalIncomeValue] DECIMAL(17, 2) NULL,
    [SharesQty] BIGINT NULL,
    [ClosingPrice] DECIMAL(17, 2) NULL,
    [TotalCost] DECIMAL(17, 2) NULL,
    [CommulativeValuation] DECIMAL(17, 2) NULL,
    [FinalStatus] VARCHAR(15) NULL,
    [FinalDescription] VARCHAR(650) NULL,
    [IsESignDocumentUpload] BIT NULL,
    [IsESignDocUploadDate] DATETIME NULL,
    [DocumentName] VARCHAR(250) NULL,
    [FilePath] VARCHAR(250) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientDRFAadharAuthenticationVerificationDetails_Backup_12062023
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientDRFAadharAuthenticationVerificationDetails_Backup_12062023]
(
    [CLTCode] VARCHAR(15) NULL,
    [ClientDPId] VARCHAR(50) NULL,
    [DRFId] BIGINT NULL,
    [ApplicationNo] VARCHAR(30) NULL,
    [ApplicationType] VARCHAR(15) NULL,
    [AppStatus] VARCHAR(15) NULL,
    [AppDescription] VARCHAR(650) NULL,
    [IncomeType] INT NULL,
    [MultiProcessValue] INT NULL,
    [TotalIncomeValue] DECIMAL(17, 2) NULL,
    [SharesQty] BIGINT NULL,
    [ClosingPrice] DECIMAL(17, 2) NULL,
    [TotalCost] DECIMAL(17, 2) NULL,
    [CommulativeValuation] DECIMAL(17, 2) NULL,
    [FinalStatus] VARCHAR(15) NULL,
    [FinalDescription] VARCHAR(650) NULL,
    [IsESignDocumentUpload] BIT NULL,
    [IsESignDocUploadDate] DATETIME NULL,
    [DocumentName] VARCHAR(250) NULL,
    [FilePath] VARCHAR(250) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientDRFAadharAuthenticationVerificationDetails_Bkp05102023
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientDRFAadharAuthenticationVerificationDetails_Bkp05102023]
(
    [CLTCode] VARCHAR(15) NULL,
    [ClientDPId] VARCHAR(50) NULL,
    [DRFId] BIGINT NULL,
    [ApplicationNo] VARCHAR(30) NULL,
    [ApplicationType] VARCHAR(15) NULL,
    [AppStatus] VARCHAR(15) NULL,
    [AppDescription] VARCHAR(650) NULL,
    [IncomeType] INT NULL,
    [MultiProcessValue] INT NULL,
    [TotalIncomeValue] DECIMAL(17, 2) NULL,
    [SharesQty] BIGINT NULL,
    [ClosingPrice] DECIMAL(17, 2) NULL,
    [TotalCost] DECIMAL(17, 2) NULL,
    [CommulativeValuation] DECIMAL(17, 2) NULL,
    [FinalStatus] VARCHAR(15) NULL,
    [FinalDescription] VARCHAR(650) NULL,
    [IsESignDocumentUpload] BIT NULL,
    [IsESignDocUploadDate] DATETIME NULL,
    [DocumentName] VARCHAR(250) NULL,
    [FilePath] VARCHAR(250) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientDRFProcessBlueDartCourierDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientDRFProcessBlueDartCourierDetails]
(
    [SRNo] INT NULL,
    [ClientName] VARCHAR(255) NULL,
    [CityPincode] VARCHAR(200) NULL,
    [DRFNo] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ClientLogDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[ClientLogDetails]
(
    [ClientCode] NVARCHAR(50) NULL,
    [ClientName] NVARCHAR(200) NULL,
    [PanNo] NVARCHAR(50) NULL,
    [BlockedDate] DATETIME NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CltControlAccMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[CltControlAccMaster]
(
    [FromSegment] NVARCHAR(25) NULL,
    [ToSegment] NVARCHAR(25) NULL,
    [Code] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ControlAccountMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[ControlAccountMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [FromExchangeMasterRefNo] BIGINT NOT NULL,
    [ToExchangeMasterRefNo] BIGINT NOT NULL,
    [Code] BIGINT NOT NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DailyTriggerLog
-- --------------------------------------------------
CREATE TABLE [dbo].[DailyTriggerLog]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [ProceessedDate] DATETIME NULL,
    [Status] NVARCHAR(30) NULL,
    [TotalRecords] DECIMAL(18, 0) NULL,
    [Recovered] DECIMAL(18, 0) NULL,
    [UnRecovered] DECIMAL(18, 0) NULL,
    [PartialRecovered] DECIMAL(18, 0) NULL,
    [NotApplied] DECIMAL(18, 0) NULL,
    [Details] NVARCHAR(30) NULL,
    [Remarks] NVARCHAR(30) NULL,
    [IsRescheduled] BIT NULL,
    [RescheduledDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DRFInwordRegistrationReceivedByRTADetails
-- --------------------------------------------------
CREATE TABLE [dbo].[DRFInwordRegistrationReceivedByRTADetails]
(
    [DRF_RTADetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [PodNo] VARCHAR(35) NULL,
    [CourierName] VARCHAR(255) NULL,
    [DRNNo] VARCHAR(35) NULL,
    [NoOfCertificates] INT NULL,
    [CustomerCode] VARCHAR(15) NULL,
    [SpecialInstructions] VARCHAR(15) NULL,
    [IsDocumentReceived] BIT NULL,
    [DocumentReceivedDate] DATETIME NULL,
    [CreatedBy] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ExceptionClientDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[ExceptionClientDetails]
(
    [ClientCode] NVARCHAR(50) NULL,
    [ClientName] NVARCHAR(200) NULL,
    [PanNo] NVARCHAR(50) NULL,
    [IsBlocked] BIT NULL,
    [BlockedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ExchangeAccount
-- --------------------------------------------------
CREATE TABLE [dbo].[ExchangeAccount]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [FromExchangeMasterRefNo] BIGINT NOT NULL,
    [ToExchangeMasterRefNo] BIGINT NOT NULL,
    [Code] BIGINT NOT NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ExchangeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[ExchangeMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(50) NULL,
    [Code] NVARCHAR(5) NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GlCodeExist
-- --------------------------------------------------
CREATE TABLE [dbo].[GlCodeExist]
(
    [cltcode] NVARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GSTMasterData
-- --------------------------------------------------
CREATE TABLE [dbo].[GSTMasterData]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Country] NVARCHAR(10) NULL,
    [GSTStateID] BIGINT NULL,
    [CGST] DECIMAL(18, 0) NULL,
    [SGST] DECIMAL(18, 0) NULL,
    [UGST] DECIMAL(18, 0) NULL,
    [IGST] DECIMAL(18, 0) NULL,
    [KFC] DECIMAL(18, 0) NULL,
    [GSTValueType] NVARCHAR(10) NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL,
    [CGST_Code] NVARCHAR(10) NULL,
    [SGST_Code] NVARCHAR(10) NULL,
    [UGST_Code] NVARCHAR(10) NULL,
    [IGST_Code] NVARCHAR(10) NULL,
    [KFC_Code] NVARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IntersegmentJV_OfflineLedger
-- --------------------------------------------------
CREATE TABLE [dbo].[IntersegmentJV_OfflineLedger]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] NVARCHAR(5) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] NVARCHAR(20) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(1) NULL,
    [MarginCode] VARCHAR(1) NULL,
    [BankName] VARCHAR(1) NULL,
    [BranchName] VARCHAR(1) NULL,
    [BranchCode] VARCHAR(1) NULL,
    [DDNo] VARCHAR(1) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(1) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(1) NULL,
    [Exchange] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(20) NULL,
    [StatusID] VARCHAR(20) NULL,
    [StatusName] VARCHAR(50) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(20) NULL,
    [VoucherNo] VARCHAR(50) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(1) NULL,
    [ClientName] VARCHAR(1) NULL,
    [OppCodeName] VARCHAR(1) NULL,
    [MarginCodeName] VARCHAR(1) NULL,
    [Sett_No] VARCHAR(1) NULL,
    [Sett_Type] VARCHAR(1) NULL,
    [ProductType] VARCHAR(1) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(1) NULL,
    [MICR] VARCHAR(1) NULL,
    [IsUpdatetoLive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.IntersegmentJV_OfflineLedgerLogFile
-- --------------------------------------------------
CREATE TABLE [dbo].[IntersegmentJV_OfflineLedgerLogFile]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] NVARCHAR(5) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] NVARCHAR(20) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(1) NULL,
    [MarginCode] VARCHAR(1) NULL,
    [BankName] VARCHAR(1) NULL,
    [BranchName] VARCHAR(1) NULL,
    [BranchCode] VARCHAR(1) NULL,
    [DDNo] VARCHAR(1) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(1) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(1) NULL,
    [Exchange] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(20) NULL,
    [StatusID] VARCHAR(20) NULL,
    [StatusName] VARCHAR(50) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(20) NULL,
    [VoucherNo] VARCHAR(50) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(1) NULL,
    [ClientName] VARCHAR(1) NULL,
    [OppCodeName] VARCHAR(1) NULL,
    [MarginCodeName] VARCHAR(1) NULL,
    [Sett_No] VARCHAR(1) NULL,
    [Sett_Type] VARCHAR(1) NULL,
    [ProductType] VARCHAR(1) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(1) NULL,
    [MICR] VARCHAR(1) NULL,
    [IsUpdatetoLive] BIT NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Logs
-- --------------------------------------------------
CREATE TABLE [dbo].[Logs]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [LogType] NVARCHAR(20) NULL,
    [LogDescription] NVARCHAR(20) NULL,
    [LogDatabase] NVARCHAR(20) NULL,
    [LogTable] NVARCHAR(20) NULL,
    [Operation] NVARCHAR(20) NULL,
    [Queries] NVARCHAR(20) NULL,
    [LoggedOn] DATETIME NULL,
    [LoggedBy] NVARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MailLog
-- --------------------------------------------------
CREATE TABLE [dbo].[MailLog]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [MailObject] NVARCHAR(10) NULL,
    [MailFrom] NVARCHAR(30) NULL,
    [MailTo] NVARCHAR(30) NULL,
    [CC] NVARCHAR(30) NULL,
    [BCC] NVARCHAR(30) NULL,
    [MailSubject] NVARCHAR(30) NULL,
    [MailBody] NVARCHAR(100) NULL,
    [MailDate] DATETIME NULL,
    [MailStatus] BIT NULL,
    [MailProfile] NVARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MonthlyBillingData
-- --------------------------------------------------
CREATE TABLE [dbo].[MonthlyBillingData]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [BillMonth] INT NULL,
    [BillYear] INT NULL,
    [RegFrom] NVARCHAR(30) NULL,
    [RegTo] NVARCHAR(30) NULL,
    [SBTAG] NVARCHAR(10) NULL,
    [RegDate] DATETIME NULL,
    [SegmentFeeType] NVARCHAR(30) NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [TotalGST] DECIMAL(18, 0) NULL,
    [GSTAmount] DECIMAL(18, 0) NULL,
    [TotalAmount] DECIMAL(18, 0) NULL,
    [RecoveredAmount] DECIMAL(18, 0) NULL,
    [UnRecoveredAmount] DECIMAL(18, 0) NULL,
    [isRecovered] BIT NULL,
    [RecoveredDate] DATETIME NULL,
    [IsWriteOff] BIT NULL,
    [IsForceDebit] BIT NULL,
    [CreatedBy] NVARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [UpatedBy] NVARCHAR(30) NULL,
    [UpdatedOn] DATETIME NULL,
    [UploadedFrom] NVARCHAR(10) NULL,
    [isDuplicate] BIT NULL,
    [IsForceWriteoffRecovered] BIT NULL DEFAULT ((0)),
    [StateCode] NVARCHAR(5) NULL,
    [PendingAmount] DECIMAL(18, 0) NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.MonthlyTriggerLog
-- --------------------------------------------------
CREATE TABLE [dbo].[MonthlyTriggerLog]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [ProceessedDate] DATETIME NULL,
    [ProceessedMonth] INT NULL,
    [ProceessedYear] INT NULL,
    [Status] NVARCHAR(100) NULL,
    [TotalRecords] DECIMAL(18, 0) NULL,
    [Recovered] DECIMAL(18, 0) NULL,
    [UnRecovered] DECIMAL(18, 0) NULL,
    [PartialRecovered] DECIMAL(18, 0) NULL,
    [ForceWriteoff] DECIMAL(18, 0) NULL,
    [ForceDebit] DECIMAL(18, 0) NULL,
    [Details] NVARCHAR(MAX) NULL,
    [Remarks] NVARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFCAndEquityAdjustmentAmount
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFCAndEquityAdjustmentAmount]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [NBFCFundingDate] DATETIME NULL,
    [CreatedDate] DATETIME NULL,
    [FromSegment] NVARCHAR(20) NULL,
    [ToSegment] NVARCHAR(20) NULL,
    [FromAmount] MONEY NULL,
    [ToAmount] MONEY NULL,
    [Adjust] MONEY NULL,
    [IsEquityToNBFC] BIT NULL,
    [IsProcess2] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFCBankDownloadFileForTrack
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFCBankDownloadFileForTrack]
(
    [FileDate] DATETIME NULL,
    [KotakNBFC] INT NULL,
    [KotakEquity] INT NULL,
    [HDFCNBFC] INT NULL,
    [HDFCEquity] INT NULL,
    [IndusindNBFC] INT NULL,
    [IndusindEquity] INT NULL,
    [IsEquityToNBFC] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFCShortageProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFCShortageProcessDetails]
(
    [PARTY_CODE] VARCHAR(50) NULL,
    [MARGINDATE] DATETIME NULL,
    [TOTAL_SHORTAGE] DECIMAL(18, 0) NULL,
    [CREATIONDATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OnBoardingList
-- --------------------------------------------------
CREATE TABLE [dbo].[OnBoardingList]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Code] NVARCHAR(30) NULL,
    [Regstatus] NVARCHAR(30) NULL,
    [RegExchangeSegment] NVARCHAR(30) NULL,
    [SBTAG] NVARCHAR(30) NULL,
    [PanNo] NVARCHAR(30) NULL,
    [TagGeneratedDate] DATETIME NULL,
    [State] NVARCHAR(80) NULL,
    [TotalGST] DECIMAL(18, 0) NULL,
    [GSTValueType] NVARCHAR(20) NULL,
    [SegmentFeeType] NVARCHAR(20) NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [TotalAmount] DECIMAL(18, 0) NULL,
    [RecoveredAmount] DECIMAL(18, 0) NULL,
    [UnRecoveredAmount] DECIMAL(18, 0) NULL,
    [isRecovered] BIT NULL,
    [RecoveredDate] DATETIME NULL,
    [RecoverySegment06] NVARCHAR(6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OtherVendor_Balance
-- --------------------------------------------------
CREATE TABLE [dbo].[OtherVendor_Balance]
(
    [VDT] DATETIME NULL,
    [VTYPE] VARCHAR(25) NULL,
    [VNO] VARCHAR(55) NULL,
    [NARRATION] VARCHAR(455) NULL,
    [INV_CHK_NUM] VARCHAR(255) NULL,
    [DEBIT] DECIMAL(17, 2) NULL,
    [CREDIT] DECIMAL(17, 2) NULL,
    [INV_CHECK_ID] VARCHAR(55) NULL,
    [VENDOR_NUMBER] VARCHAR(55) NULL,
    [VENDOR_NAME] VARCHAR(355) NULL,
    [VENDOR_TAG] VARCHAR(55) NULL,
    [VENDOR_ID_GRP] VARCHAR(55) NULL,
    [CREATION_DATE] DATETIME NULL,
    [UPDATE_DATE] DATETIME NULL,
    [VENDOR_TYPE] VARCHAR(55) NULL,
    [ATTRIBUTE1] VARCHAR(255) NULL,
    [ATTRIBUTE2] VARCHAR(255) NULL,
    [ATTRIBUTE3] VARCHAR(255) NULL,
    [ATTRIBUTE4] VARCHAR(255) NULL,
    [ATTRIBUTE5] VARCHAR(255) NULL,
    [ATTRIBUTE6] VARCHAR(255) NULL,
    [ATTRIBUTE7] VARCHAR(255) NULL,
    [ATTRIBUTE8] VARCHAR(255) NULL,
    [ATTRIBUTE9] VARCHAR(255) NULL,
    [ATTRIBUTE10] VARCHAR(255) NULL,
    [ATTRIBUTE11] VARCHAR(255) NULL,
    [ATTRIBUTE12] VARCHAR(255) NULL,
    [ATTRIBUTE_CONTEXT] VARCHAR(255) NULL,
    [INVOICE_ID] VARCHAR(155) NULL,
    [VENDOR_ID] VARCHAR(55) NULL,
    [ORG_NAME] VARCHAR(255) NULL,
    [ORG_ID] INT NULL,
    [CATEGORY_CODE] VARCHAR(155) NULL,
    [SEGMENT_CODE] VARCHAR(10) NULL,
    [SEGMENT_NAME] VARCHAR(155) NULL,
    [COMPANY_CODE] VARCHAR(10) NULL,
    [BANK_REFERENCE_NAME] VARCHAR(255) NULL,
    [COMPANY_NAME] VARCHAR(255) NULL,
    [CLEARED_AMOUNT] DECIMAL(17, 2) NULL,
    [CLEARED_DATE] DATETIME NULL,
    [DIST_CONCATENATED_CODE] VARCHAR(455) NULL,
    [PAYMENT_METHOD_CODE] VARCHAR(255) NULL,
    [SEQ] VARCHAR(55) NULL,
    [BALANCE] DECIMAL(17, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.OtherVendor_GstInvoiceMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[OtherVendor_GstInvoiceMaster]
(
    [SrNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [InvoiceNo] VARCHAR(30) NULL,
    [InvoiceDate] DATETIME NULL,
    [VendorID] VARCHAR(20) NULL,
    [VendorCode] VARCHAR(10) NULL,
    [LedgerName] VARCHAR(100) NULL,
    [FromState] VARCHAR(100) NULL,
    [ToState] VARCHAR(100) NULL,
    [Brok_Charges] MONEY NULL,
    [CgstTax] VARCHAR(5) NULL,
    [SgstTax] VARCHAR(5) NULL,
    [UgstTax] VARCHAR(5) NULL,
    [IgstTax] VARCHAR(5) NULL,
    [CgstAmt] MONEY NULL,
    [SgstAmt] MONEY NULL,
    [UgstAmt] MONEY NULL,
    [IgstAmt] MONEY NULL,
    [TotalGst] MONEY NULL,
    [GrandTotal] MONEY NULL,
    [InvoiceType] VARCHAR(1) NULL,
    [SbRegType] VARCHAR(1) NULL,
    [AngelRegType] VARCHAR(1) NULL,
    [VendorTradeName] VARCHAR(255) NULL,
    [VendorName] VARCHAR(255) NULL,
    [VendorPAN] VARCHAR(15) NULL,
    [VendorGST] VARCHAR(30) NULL,
    [VendorAddress] VARCHAR(700) NULL,
    [AngelPAN] VARCHAR(30) NULL,
    [AngelGST] VARCHAR(30) NULL,
    [AngelAddress] VARCHAR(500) NULL,
    [SAC] VARCHAR(10) NULL,
    [SBEmailID] VARCHAR(300) NULL,
    [CreatedOn] DATETIME NULL,
    [Createdby] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RA_Sahring
-- --------------------------------------------------
CREATE TABLE [dbo].[RA_Sahring]
(
    [RA Name] VARCHAR(455) NULL,
    [Payout Duration] VARCHAR(150) NULL,
    [Subscription Sold] VARCHAR(150) NULL,
    [1:1 Call Scheduled] VARCHAR(150) NULL,
    [Webinar Conducted] VARCHAR(150) NULL,
    [Refund Amount] DECIMAL(17, 2) NULL,
    [Amount - Subscription] DECIMAL(17, 2) NULL,
    [Amount - Call Sessions] DECIMAL(17, 2) NULL,
    [Amount - Webinars] DECIMAL(17, 2) NULL,
    [Total Amount] DECIMAL(17, 2) NULL,
    [RA Fixed Payout (50%(Total - Refund))] DECIMAL(17, 2) NULL,
    [RA Performance Payout] DECIMAL(17, 2) NULL,
    [RA Total Payout] DECIMAL(17, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_Charges
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_Charges]
(
    [SBTAG] VARCHAR(25) NULL,
    [Packs_Sold] VARCHAR(155) NULL,
    [Date] DATETIME NULL,
    [Duration] VARCHAR(25) NULL,
    [Active_date] DATETIME NULL,
    [Deactive_Date] DATETIME NULL,
    [Amount] DECIMAL(17, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SB_RA_Sharing
-- --------------------------------------------------
CREATE TABLE [dbo].[SB_RA_Sharing]
(
    [SBTAG] VARCHAR(25) NULL,
    [Client] VARCHAR(355) NULL,
    [Packs_Sold] VARCHAR(155) NULL,
    [Date] DATETIME NULL,
    [Duration] VARCHAR(25) NULL,
    [Active_date] DATETIME NULL,
    [Deactive_Date] DATETIME NULL,
    [Gross_Revenue] DECIMAL(17, 2) NULL,
    [SB_Sharing] DECIMAL(17, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SBRegistrationFeeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SBRegistrationFeeMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [SegmentMasterRefNo] BIGINT NULL,
    [ExchangeMasterRefNo] BIGINT NULL,
    [SegmentFeeType] NVARCHAR(20) NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [OtherCharges] DECIMAL(18, 0) NULL,
    [TotalAmount] DECIMAL(18, 0) NULL,
    [IsActive] BIT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL,
    [GLCode] NVARCHAR(15) NULL,
    [RecoverySegment06] NVARCHAR(15) NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.SegmentMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SegmentMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(50) NULL,
    [Code] NVARCHAR(5) NULL,
    [ExchangeMasterRefNo] BIGINT NOT NULL,
    [IsActive] BIT NOT NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] NVARCHAR(20) NULL,
    [UpdatedOn] DATETIME NULL,
    [UpdatedBy] NVARCHAR(20) NULL,
    [DeletedOn] DATETIME NULL,
    [DeletedBy] NVARCHAR(20) NULL,
    [ServerIP] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SegmentMasterSub
-- --------------------------------------------------
CREATE TABLE [dbo].[SegmentMasterSub]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [SegmentID] INT NULL,
    [AliasCode] NVARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ShortageMarginJV_OfflineLedger
-- --------------------------------------------------
CREATE TABLE [dbo].[ShortageMarginJV_OfflineLedger]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] NVARCHAR(5) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] NVARCHAR(20) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(1) NULL,
    [MarginCode] VARCHAR(1) NULL,
    [BankName] VARCHAR(1) NULL,
    [BranchName] VARCHAR(1) NULL,
    [BranchCode] VARCHAR(1) NULL,
    [DDNo] VARCHAR(1) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(1) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(1) NULL,
    [Exchange] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(20) NULL,
    [StatusID] VARCHAR(20) NULL,
    [StatusName] VARCHAR(50) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(20) NULL,
    [VoucherNo] VARCHAR(50) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(1) NULL,
    [ClientName] VARCHAR(1) NULL,
    [OppCodeName] VARCHAR(1) NULL,
    [MarginCodeName] VARCHAR(1) NULL,
    [Sett_No] VARCHAR(1) NULL,
    [Sett_Type] VARCHAR(1) NULL,
    [ProductType] VARCHAR(1) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(1) NULL,
    [MICR] VARCHAR(1) NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [IsUpdatetoLive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ShortageMarginJV_OfflineLedgerLogFile
-- --------------------------------------------------
CREATE TABLE [dbo].[ShortageMarginJV_OfflineLedgerLogFile]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] NVARCHAR(5) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] NVARCHAR(20) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(1) NULL,
    [MarginCode] VARCHAR(1) NULL,
    [BankName] VARCHAR(1) NULL,
    [BranchName] VARCHAR(1) NULL,
    [BranchCode] VARCHAR(1) NULL,
    [DDNo] VARCHAR(1) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(1) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(1) NULL,
    [Exchange] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(20) NULL,
    [StatusID] VARCHAR(20) NULL,
    [StatusName] VARCHAR(50) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(20) NULL,
    [VoucherNo] VARCHAR(50) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(1) NULL,
    [ClientName] VARCHAR(1) NULL,
    [OppCodeName] VARCHAR(1) NULL,
    [MarginCodeName] VARCHAR(1) NULL,
    [Sett_No] VARCHAR(1) NULL,
    [Sett_Type] VARCHAR(1) NULL,
    [ProductType] VARCHAR(1) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(1) NULL,
    [MICR] VARCHAR(1) NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [IsUpdatetoLive] BIT NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.StateMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[StateMaster]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [StateName] NVARCHAR(30) NULL,
    [StateCode] NVARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.StateMasterSub
-- --------------------------------------------------
CREATE TABLE [dbo].[StateMasterSub]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [StateId] INT NULL,
    [StateCode] NVARCHAR(3) NULL,
    [StateName] NVARCHAR(30) NULL,
    [AliasName] NVARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SubBrokerLimitEnhencementSummaryReport
-- --------------------------------------------------
CREATE TABLE [dbo].[SubBrokerLimitEnhencementSummaryReport]
(
    [SBLimitEnhencementSummaryId] INT IDENTITY(1,1) NOT NULL,
    [EnhencementDate] DATETIME NULL,
    [SBCount] INT NULL,
    [ClientCount] INT NULL,
    [TotalLimit] DECIMAL(18, 0) NULL
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
-- TABLE dbo.SystemLogs
-- --------------------------------------------------
CREATE TABLE [dbo].[SystemLogs]
(
    [ID] BIGINT IDENTITY(1,1) NOT NULL,
    [UserName] NVARCHAR(20) NULL,
    [UserID] NVARCHAR(20) NULL,
    [IPAddress] NVARCHAR(20) NULL,
    [LoginDate] DATETIME NULL,
    [LogoutDate] DATETIME NULL,
    [Remarks] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientDRFAadharAuthenticationESignDocumentAPIDetails]
(
    [ESignDocumentId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [IsRequestSendForESign] BIT NULL,
    [DocumentId] VARCHAR(50) NULL,
    [IRNNo] VARCHAR(50) NULL,
    [RequestSendDate] DATETIME NULL,
    [SignUrlPath] VARCHAR(MAX) NULL,
    [ActiveStatus] BIT NULL,
    [ExpiryDate] DATETIME NULL,
    [ESignStatus] VARCHAR(25) NULL,
    [IsResponseForESign] BIT NULL,
    [ResponseDocumentId] VARCHAR(50) NULL,
    [ResponseUploadDate] DATETIME NULL,
    [ResponseSignUrlPath] VARCHAR(MAX) NULL,
    [ProcessBy] VARCHAR(18) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientDRFInwordDocuments
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientDRFInwordDocuments]
(
    [DRFDocumentId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [ClientId] VARCHAR(35) NULL,
    [IsTransferForScanning] BIT NULL,
    [TransferedDate] DATETIME NULL,
    [ToTransfered] VARCHAR(250) NULL,
    [FilePath] VARCHAR(500) NULL,
    [DocumentName] VARCHAR(250) NULL,
    [Extension] VARCHAR(5) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientDRFProcessCompleteStatusDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientDRFProcessCompleteStatusDetails]
(
    [DRFId] BIGINT NULL,
    [DRFNo] VARCHAR(35) NULL,
    [DEMRM_ID] VARCHAR(25) NULL,
    [CurrentStatus] VARCHAR(550) NULL,
    [MakerProcessStatus] VARCHAR(20) NULL,
    [IsMakerProcess] BIT NULL,
    [MakerProcessDate] VARCHAR(20) NULL,
    [MakerBy] VARCHAR(10) NULL,
    [IsCheckerProcess] BIT NULL,
    [IsCheckerRejected] BIT NULL,
    [CheckerProcessStatus] VARCHAR(20) NULL,
    [CheckerProcessRemarks] VARCHAR(500) NULL,
    [CheckerProcessDate] VARCHAR(20) NULL,
    [CheckerBy] VARCHAR(10) NULL,
    [BatchUploadInCDSL] BIT NULL,
    [BatchNo] VARCHAR(15) NULL,
    [DRNNo] VARCHAR(25) NULL,
    [IsCDSLProcess] BIT NULL,
    [IsCDSLRejected] BIT NULL,
    [CDSLStatus] VARCHAR(30) NULL,
    [CDSLRemarks] VARCHAR(500) NULL,
    [CDSLProcessDate] VARCHAR(20) NULL,
    [RTALetterGenerate] BIT NULL,
    [DispatchDate] VARCHAR(20) NULL,
    [IsRTAProcess] BIT NULL,
    [RTAProcessDate] VARCHAR(20) NULL,
    [RTAStatus] VARCHAR(20) NULL,
    [RTARemarks] VARCHAR(550) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientExchangeScripObligationFinalCalculationData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientExchangeScripObligationFinalCalculationData]
(
    [SETT_NO] VARCHAR(15) NULL,
    [SETT_TYPE] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(25) NULL,
    [SCRIP_CD] VARCHAR(55) NULL,
    [SERIES] VARCHAR(10) NULL,
    [PayinQty] INT NULL,
    [ISIN] VARCHAR(35) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientExchangeScripObligationReport
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientExchangeScripObligationReport]
(
    [ClientCode] VARCHAR(15) NULL,
    [ScripCode] VARCHAR(105) NULL,
    [ExpiryDate] DATE NULL,
    [StrikePrice] DECIMAL(17, 2) NULL,
    [NetQty] INT NULL,
    [Position] VARCHAR(105) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientSebiPayoutBlockingDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientSebiPayoutBlockingDetails]
(
    [SEBI_BlockingId] BIGINT IDENTITY(1,1) NOT NULL,
    [ClientPanNo] VARCHAR(10) NULL,
    [CltCode] VARCHAR(15) NULL,
    [ClientName] VARCHAR(255) NULL,
    [BranchCode] VARCHAR(25) NULL,
    [SBTag] VARCHAR(15) NULL,
    [Extension] VARCHAR(10) NULL,
    [FileName] VARCHAR(350) NULL,
    [BlockingTeam] VARCHAR(15) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [BlockingDate] DATETIME NULL,
    [BlockedBy] VARCHAR(20) NULL,
    [IsUnBlocked] BIT NULL,
    [UnBlockingFileName] VARCHAR(350) NULL,
    [UnBlockingRemarks] VARCHAR(MAX) NULL,
    [UnBlockingDate] DATETIME NULL,
    [UnBlockedBy] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DRFInwordRegistrationProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DRFInwordRegistrationProcessDetails]
(
    [SharesId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [ISINNo] VARCHAR(20) NULL,
    [CompanyName] VARCHAR(500) NULL,
    [Quantity] INT NULL,
    [Status] VARCHAR(50) NULL,
    [RejectionRemarks] VARCHAR(MAX) NULL,
    [InwordProcessDate] DATETIME NULL,
    [IsReportSend] BIT NULL,
    [CreatedBy] VARCHAR(25) NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DRFInwordRegistrationProcessMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DRFInwordRegistrationProcessMaster]
(
    [DRFId] BIGINT IDENTITY(1,1) NOT NULL,
    [PodId] BIGINT NULL,
    [DRFNo] VARCHAR(30) NULL,
    [ClientId] VARCHAR(50) NULL,
    [NoOfCertificates] INT NULL,
    [IsRejected] BIT NULL,
    [IsRejectionRemarks] VARCHAR(255) NULL,
    [InwordProcessDate] DATETIME NULL,
    [ClientName] VARCHAR(255) NULL,
    [MobileNo] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DRFOutwordRegistrationSendToRTADetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DRFOutwordRegistrationSendToRTADetails]
(
    [DRFOutword_RTAId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [IsFileGenerate] INT NULL,
    [FileRemarks] VARCHAR(200) NULL,
    [FileGenerateDate] DATETIME NULL,
    [IsResponseUpload] INT NULL,
    [ResponseRemarks] VARCHAR(100) NULL,
    [PodNo] VARCHAR(50) NULL,
    [CourierBy] VARCHAR(255) NULL,
    [CustomerCode] VARCHAR(10) NULL,
    [SpecialInstructions] VARCHAR(12) NULL,
    [ResponseUploadDate] DATETIME NULL,
    [IsDocumentReceived] BIT NULL,
    [StatusDescription] VARCHAR(250) NULL,
    [StatusGroup] VARCHAR(5) NULL,
    [StatusDate] DATETIME NULL,
    [DocumentReceivedDate] DATETIME NULL,
    [DocumentReceivedBy] VARCHAR(255) NULL,
    [Relation] VARCHAR(100) NULL,
    [IdentityType] VARCHAR(10) NULL,
    [UploadedDate] VARCHAR(35) NULL,
    [DocumentWeight] VARCHAR(5) NULL,
    [ExpDeliveryDate] VARCHAR(12) NULL,
    [RtoReason] VARCHAR(200) NULL,
    [GenerateBy] VARCHAR(25) NULL,
    [ResponseBy] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DRFPodInwordRegistrationProcess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DRFPodInwordRegistrationProcess]
(
    [PodId] BIGINT IDENTITY(1,1) NOT NULL,
    [PodNo] VARCHAR(50) NULL,
    [CourierName] VARCHAR(150) NULL,
    [CourierReceivedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DRFProcessClientMailStatusDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DRFProcessClientMailStatusDetails]
(
    [StatusDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [ClientId] VARCHAR(35) NULL,
    [ClientEmailId] VARCHAR(255) NULL,
    [IsDRFReceivedMail] BIT NULL,
    [DRFReceivedMailProcessDate] DATETIME NULL,
    [IsDPRejectionMail] BIT NULL,
    [DPRejectionMailProcessDate] DATETIME NULL,
    [IsCDSLRejectionMail] BIT NULL,
    [CDSLRejectionMailProcessDate] DATETIME NULL,
    [IsDRFSendToRTAMail] BIT NULL,
    [DRFSendToRTAMailProcessDate] DATETIME NULL,
    [IsRTARejectionMail] BIT NULL,
    [RTARejectionMailProcessDate] DATETIME NULL,
    [IsRTASuccessMail] BIT NULL,
    [RTASuccessMailProcessDate] DATETIME NULL,
    [IsDRFUndeliveredMail] BIT NULL,
    [DRFUndeliveredMailProcessDate] DATETIME NULL,
    [CLTCode] VARCHAR(25) NULL,
    [SBTag] VARCHAR(25) NULL,
    [IsDPRejectionReceivedMail] BIT NULL,
    [DPRejectionReceivedMailProcessDate] DATETIME NULL,
    [IsCDSLRejectionReceivedMail] BIT NULL,
    [CDSLRejectionReceivedMailProcessDate] DATETIME NULL,
    [IsRTARejectionReceivedMail] BIT NULL,
    [RTARejectioReceivednMailProcessDate] DATETIME NULL,
    [IsRTARemainder] BIT NULL,
    [RTARemainderMailProcessDate] DATETIME NULL,
    [IsRTARemainder1] BIT NULL,
    [RTARemainderMailProcessDate1] DATETIME NULL,
    [IsRTARemainder2] BIT NULL,
    [RTARemainderMailProcessDate2] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_GstOtherVendorMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_GstOtherVendorMaster]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [VENDOR_TAG] VARCHAR(10) NULL,
    [SUPNO] VARCHAR(50) NULL,
    [PANNO] VARCHAR(20) NULL,
    [TRADENAME] VARCHAR(100) NULL,
    [NAME] VARCHAR(100) NULL,
    [FULLADDRESS] VARCHAR(2000) NULL,
    [STATE] VARCHAR(100) NULL,
    [GstRegDate] DATETIME NULL,
    [GSTIN] VARCHAR(30) NULL,
    [CreatedOn] DATETIME NULL,
    [Createdby] VARCHAR(15) NULL,
    [ModifiedOn] DATETIME NULL,
    [Modifiedby] VARCHAR(15) NULL,
    [Ip] VARCHAR(30) NULL,
    [CreatedStatus] VARCHAR(10) NULL,
    [IsActive] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_GSTStateMasterDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_GSTStateMasterDetails]
(
    [GSTStateCode] NVARCHAR(10) NULL,
    [StateName] VARCHAR(105) NULL,
    [StateType] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryCSOVerificationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryCSOVerificationMaster]
(
    [CSOProcessId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [IsApproved] BIT NULL,
    [ProcessStatus] VARCHAR(15) NULL,
    [ProcessRemarks] VARCHAR(MAX) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL,
    [EditBy] VARCHAR(15) NULL,
    [EditDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterAddressDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterAddressDetails]
(
    [IntermediaryAddressId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [AadhaarNo] VARCHAR(35) NULL,
    [TerminalAddressLine1] VARCHAR(455) NULL,
    [TerminalAddressLine2] VARCHAR(455) NULL,
    [TerminalAddressLine3] VARCHAR(455) NULL,
    [TerminalAreaLandmark] VARCHAR(155) NULL,
    [TerminalCity] VARCHAR(35) NULL,
    [TerminalState] VARCHAR(35) NULL,
    [TerminalPin] VARCHAR(10) NULL,
    [TerminalCountry] VARCHAR(35) NULL,
    [TerminalOffStdCode1] VARCHAR(10) NULL,
    [TerminalOffPhone1] VARCHAR(15) NULL,
    [TerminalOffStdCode2] VARCHAR(10) NULL,
    [TerminalOffPhone2] VARCHAR(15) NULL,
    [TerminalOffStdCode3] VARCHAR(10) NULL,
    [TerminalOffPhone3] VARCHAR(15) NULL,
    [Mobile1] VARCHAR(15) NULL,
    [Mobile2] VARCHAR(15) NULL,
    [Email] VARCHAR(105) NULL,
    [IsCopyTerminalAddress] BIT NULL,
    [RegisteredAddressLine1] VARCHAR(455) NULL,
    [RegisteredAddressLine2] VARCHAR(455) NULL,
    [RegisteredAddressLine3] VARCHAR(455) NULL,
    [RegisteredAreaLandmark] VARCHAR(155) NULL,
    [RegisteredCity] VARCHAR(35) NULL,
    [RegisteredState] VARCHAR(35) NULL,
    [RegisteredPin] VARCHAR(10) NULL,
    [RegisteredCountry] VARCHAR(35) NULL,
    [RegisteredStdFax] VARCHAR(10) NULL,
    [RegisteredFax] VARCHAR(85) NULL,
    [RegisteredStdResPhone] VARCHAR(10) NULL,
    [RegisteredResPhone] VARCHAR(15) NULL,
    [Gender] VARCHAR(10) NULL,
    [MaritalStatus] VARCHAR(25) NULL,
    [FatherName] VARCHAR(255) NULL,
    [SpouseName] VARCHAR(255) NULL,
    [RelationshipManager] VARCHAR(255) NULL,
    [FGCode] VARCHAR(255) NULL,
    [FamilyReason] VARCHAR(155) NULL,
    [Remarks] VARCHAR(MAX) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterBankDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterBankDetails]
(
    [IntermediaryBankDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [IFSC_RTGS_NEFTCode] VARCHAR(55) NULL,
    [BankName] VARCHAR(225) NULL,
    [Branch] VARCHAR(50) NULL,
    [Address] VARCHAR(MAX) NULL,
    [AccountType] VARCHAR(10) NULL,
    [AccountNo] VARCHAR(20) NULL,
    [MICRNo] VARCHAR(105) NULL,
    [NameInBank] VARCHAR(155) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterBrokerageDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterBrokerageDetails]
(
    [IntermediaryBrokerageDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [SubBrokerShares] DECIMAL(17, 2) NULL,
    [Intraday_MinToClient] VARCHAR(15) NULL,
    [NSE_Nifty] DECIMAL(17, 2) NULL,
    [NSEBankNifty] DECIMAL(17, 2) NULL,
    [NSE_FIN_Nifty] DECIMAL(17, 2) NULL,
    [NSE_StockOption] DECIMAL(17, 2) NULL,
    [Delivery_MinToClient] VARCHAR(15) NULL,
    [NSECurrencyOption] DECIMAL(17, 2) NULL,
    [MCXOption] DECIMAL(17, 2) NULL,
    [CommodityCurrencyFuture] VARCHAR(15) NULL,
    [IsDefaultSharesToSB] BIT NULL,
    [Remarks] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterDepositAndFeesDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterDepositAndFeesDetails]
(
    [IntermediaryDepositDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [TypeOfSB] VARCHAR(25) NULL,
    [Deposit] DECIMAL(17, 2) NULL,
    [ActualDeposit] DECIMAL(17, 2) NULL,
    [Balance] DECIMAL(17, 2) NULL,
    [ApprovalForLowDeposit] VARCHAR(MAX) NULL,
    [ApprovalDocFileName] VARCHAR(255) NULL,
    [RegnFees] DECIMAL(17, 2) NULL,
    [Remarks] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterGeneralDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterGeneralDetails]
(
    [IntermediaryId] BIGINT IDENTITY(1,1) NOT NULL,
    [CompanyId] INT NULL,
    [IntermediaryCode] VARCHAR(35) NULL,
    [IntermediaryName] VARCHAR(255) NULL,
    [TradeName] VARCHAR(255) NULL,
    [TradeNameInCommodities] VARCHAR(255) NULL,
    [PanNo] VARCHAR(10) NULL,
    [DOB_IncorporationDate] DATETIME NULL,
    [Region] VARCHAR(25) NULL,
    [IntermediaryType] VARCHAR(50) NULL,
    [BranchName] VARCHAR(155) NULL,
    [DateIntroduced] DATETIME NULL,
    [IntroducedByIntermediary_Branch] VARCHAR(200) NULL,
    [BusinessType] VARCHAR(50) NULL,
    [Zone] VARCHAR(45) NULL,
    [IntermediaryStatus] VARCHAR(55) NULL,
    [GSTNo] VARCHAR(155) NULL,
    [Parent] VARCHAR(255) NULL,
    [IntroducedByEmployee] VARCHAR(55) NULL,
    [Notes] VARCHAR(MAX) NULL,
    [NoOfPartners_Directors] INT NULL,
    [Remarks] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterMultiPartnersDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterMultiPartnersDetails]
(
    [PartnersDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [PartnersName] VARCHAR(255) NULL,
    [PartnerDOB] DATETIME NULL,
    [PartnerPanNo] VARCHAR(15) NULL,
    [PartnerGender] VARCHAR(10) NULL,
    [PartnerDesignation] VARCHAR(250) NULL,
    [EducationalQualification] VARCHAR(250) NULL,
    [PartnerFatherName] VARCHAR(250) NULL,
    [Husband_WifeName] VARCHAR(250) NULL,
    [PartnerAddressLine1] VARCHAR(450) NULL,
    [PartnerAddressLine2] VARCHAR(450) NULL,
    [PartnerAddressLine3] VARCHAR(450) NULL,
    [Occupation] VARCHAR(255) NULL,
    [PercentageShareHolding] VARCHAR(15) NULL,
    [CapitalMarketExperience] VARCHAR(15) NULL,
    [AreaLandmark] VARCHAR(250) NULL,
    [PinCode] VARCHAR(10) NULL,
    [City] VARCHAR(30) NULL,
    [State] VARCHAR(30) NULL,
    [Country] VARCHAR(30) NULL,
    [AadharNo] VARCHAR(15) NULL,
    [MobileNo] VARCHAR(12) NULL,
    [EmailId] VARCHAR(125) NULL,
    [PEPType] VARCHAR(10) NULL,
    [PEPDocFileName] VARCHAR(150) NULL,
    [PanCardFileName] VARCHAR(150) NULL,
    [AddressProffFileName] VARCHAR(150) NULL,
    [EducationProffFileName] VARCHAR(150) NULL,
    [OtherDocFileName] VARCHAR(150) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL,
    [EditBy] VARCHAR(15) NULL,
    [EditDate] DATETIME NULL,
    [EditBySB] VARCHAR(15) NULL,
    [EditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterOccuptionDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterOccuptionDetails]
(
    [IntermediaryOccuptionDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [PreviouslyAffiliated] VARCHAR(15) NULL,
    [NameOfBroker] VARCHAR(255) NULL,
    [Occupation] VARCHAR(155) NULL,
    [OccupationDetails] VARCHAR(255) NULL,
    [CapitalMarketExperience] VARCHAR(15) NULL,
    [TotalExperience] VARCHAR(15) NULL,
    [Networth] VARCHAR(15) NULL,
    [ClientBase] VARCHAR(15) NULL,
    [OfficeSpace] VARCHAR(205) NULL,
    [TerminalRequried] VARCHAR(5) NULL,
    [OfficeType] VARCHAR(15) NULL,
    [EducationQualification] VARCHAR(18) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterPLVCProcess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterPLVCProcess]
(
    [PLVCProcessId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [IsApproved] BIT NULL,
    [ProcessStatus] VARCHAR(15) NULL,
    [ProcessRemarks] VARCHAR(MAX) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL,
    [EditBy] VARCHAR(15) NULL,
    [EditDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediaryMasterSegmentDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediaryMasterSegmentDetails]
(
    [IntermediarySegmentDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [BSE_CASH] BIT NULL,
    [BSE_FO] BIT NULL,
    [NSE_CASH] BIT NULL,
    [NSE_FO] BIT NULL,
    [MutualFund] BIT NULL,
    [NCDEX_FO] BIT NULL,
    [MCX_FO] BIT NULL,
    [BSE_CDX] BIT NULL,
    [NSE_CDX] BIT NULL,
    [Remarks] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(25) NULL,
    [ProcessDate] DATETIME NULL,
    [LastEditBy] VARCHAR(25) NULL,
    [LastEditDate] DATETIME NULL,
    [LastEditBySB] VARCHAR(25) NULL,
    [LastEditDateBySB] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediarySBTagGenerationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediarySBTagGenerationMaster]
(
    [SBMasterId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [SBTag] VARCHAR(15) NULL,
    [SBPanNo] VARCHAR(15) NULL,
    [TagGenerationDate] DATETIME NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediarySBTagGenerationRegistrationDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediarySBTagGenerationRegistrationDetails]
(
    [RegistrationId] BIGINT IDENTITY(1,1) NOT NULL,
    [SBMasterId] BIGINT NULL,
    [Segment] VARCHAR(10) NULL,
    [Status] VARCHAR(15) NULL,
    [RegistrationNo] VARCHAR(35) NULL,
    [RegistrationDate] DATETIME NULL,
    [IntimationDate] DATETIME NULL,
    [RejectionRemarks] VARCHAR(255) NULL,
    [IsRejectionDocUpload] BIT NULL,
    [Remarks] VARCHAR(255) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [EditDate] DATETIME NULL,
    [EditBy] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediarySBTagGenerationUploadedDocumentsDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediarySBTagGenerationUploadedDocumentsDetails]
(
    [DocumentsDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [IsPANCardUpload] BIT NULL,
    [PanCardDocName] VARCHAR(155) NULL,
    [PanCardUploadDate] DATETIME NULL,
    [IsAadharCardUpload] BIT NULL,
    [AadharDocName] VARCHAR(155) NULL,
    [AadharDocUploadDate] DATETIME NULL,
    [IsAddressDetailsUpload] BIT NULL,
    [AddressDetailsDocName] VARCHAR(155) NULL,
    [AddressDetailsUploadDate] DATETIME NULL,
    [IsEducationDetailsUpload] BIT NULL,
    [EducationDetailsDocName] VARCHAR(155) NULL,
    [EducationDetailsDocUploadDate] DATETIME NULL,
    [IsAffidavitDetailsUpload] BIT NULL,
    [AffidavitDetailsDocName] VARCHAR(155) NULL,
    [AffidavitDetailsDocUploadDate] DATETIME NULL,
    [IsNSESegmentDocUpload] BIT NULL,
    [NSESegmentDocName] VARCHAR(155) NULL,
    [NSESegmentDocUploadDate] DATETIME NULL,
    [IsBSESegmentDocUpload] BIT NULL,
    [BSESegmentDocName] VARCHAR(155) NULL,
    [BSESegmentDocUploadDate] DATETIME NULL,
    [IsMCXSegmentDocUpload] BIT NULL,
    [MCXSegmentDocName] VARCHAR(155) NULL,
    [MCXSegmentDocUploadDate] DATETIME NULL,
    [IsNCDEXSegmentDocUpload] BIT NULL,
    [NCDEXSegmentDocName] VARCHAR(155) NULL,
    [NCDEXSegmentDocUploadDate] DATETIME NULL,
    [IsTagsheet_MOUDocUpload] BIT NULL,
    [Tagsheet_MOUDocName] VARCHAR(155) NULL,
    [Tagsheet_MOUDocUploadDate] DATETIME NULL,
    [IsBankDetailsUpload] BIT NULL,
    [BankDetailsDocName] VARCHAR(155) NULL,
    [BankDetailsDocUploadDate] DATETIME NULL,
    [IsCancelChequeDocUpload] BIT NULL,
    [CancelChequeDocName] VARCHAR(155) NULL,
    [CancelChequeDocUploadDate] DATETIME NULL,
    [IsFinalDraftFromAP_SBDocUpload] BIT NULL,
    [FinalDraftFromAP_SBDocName] VARCHAR(155) NULL,
    [FinalDraftFromAP_SBDocUploadDate] DATETIME NULL,
    [IsAP_SBProfilingDocUpload] BIT NULL,
    [AP_SBProfilingDocName] VARCHAR(155) NULL,
    [AP_SBProfilingDocUploadDate] DATETIME NULL,
    [IsOthersDocUpload] BIT NULL,
    [OthersDocName] VARCHAR(155) NULL,
    [OthersDocUploadDate] DATETIME NULL,
    [IsFinalIntermediaryProcess] BIT NULL,
    [ProcessBy] VARCHAR(18) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntermediarySBVerificationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntermediarySBVerificationMaster]
(
    [SBProcessId] BIGINT IDENTITY(1,1) NOT NULL,
    [IntermediaryId] BIGINT NULL,
    [IsApproved] BIT NULL,
    [ProcessStatus] VARCHAR(15) NULL,
    [ProcessRemarks] VARCHAR(MAX) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL,
    [EditBy] VARCHAR(15) NULL,
    [EditDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NBFCPostData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NBFCPostData]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(20) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(100) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(30) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(40) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL,
    [IsProcess] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NBFCShortageProcessPostData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NBFCShortageProcessPostData]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(20) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(100) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(30) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(40) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RejectedDRFOutwordProcessAndResponseDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RejectedDRFOutwordProcessAndResponseDetails]
(
    [OutwordProcessId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [IsFileGenerate] INT NULL,
    [FileRemarks] VARCHAR(200) NULL,
    [FileGenerateDate] DATETIME NULL,
    [IsResponseUpload] INT NULL,
    [ResponseRemarks] VARCHAR(100) NULL,
    [PodNo] VARCHAR(50) NULL,
    [CourierBy] VARCHAR(255) NULL,
    [CustomerCode] VARCHAR(10) NULL,
    [SpecialInstructions] VARCHAR(12) NULL,
    [ResponseUploadDate] DATETIME NULL,
    [IsDocumentReceived] BIT NULL,
    [StatusDescription] VARCHAR(250) NULL,
    [StatusGroup] VARCHAR(5) NULL,
    [StatusDate] DATETIME NULL,
    [DocumentReceivedDate] DATETIME NULL,
    [DocumentReceivedBy] VARCHAR(255) NULL,
    [Relation] VARCHAR(100) NULL,
    [IdentityType] VARCHAR(10) NULL,
    [UploadedDate] VARCHAR(35) NULL,
    [DocumentWeight] VARCHAR(5) NULL,
    [ExpDeliveryDate] VARCHAR(12) NULL,
    [RtoReason] VARCHAR(200) NULL,
    [GenerateBy] VARCHAR(25) NULL,
    [ResponseBy] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_RTARejectedDRFMemoScannedDocument
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_RTARejectedDRFMemoScannedDocument]
(
    [DRFMemoDocId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [DRNNO] NVARCHAR(35) NULL,
    [FileName] VARCHAR(255) NULL,
    [FilePath] VARCHAR(500) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBAddressChangeProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBAddressChangeProcessDetails]
(
    [SBTag] VARCHAR(15) NULL,
    [SBPanNo] VARCHAR(15) NULL,
    [IsDocumentMail] BIT NULL,
    [DocumentMailDate] DATETIME NULL,
    [IsNSEVerified] VARCHAR(10) NULL,
    [NSEStatus] VARCHAR(255) NULL,
    [NSEVerificationDate] DATETIME NULL,
    [IsBSEVerified] VARCHAR(10) NULL,
    [BSEStatus] VARCHAR(255) NULL,
    [BSEVerificationDate] DATETIME NULL,
    [IsNSEFOVerified] VARCHAR(10) NULL,
    [NSEFOStatus] VARCHAR(255) NULL,
    [NSEFOVerificationDate] DATETIME NULL,
    [IsBSEFOVerified] VARCHAR(10) NULL,
    [BSEFOStatus] VARCHAR(255) NULL,
    [BSEFOVerificationDate] DATETIME NULL,
    [IsNSXVerified] VARCHAR(10) NULL,
    [NSXStatus] VARCHAR(255) NULL,
    [NSXVerificationDate] DATETIME NULL,
    [IsBSXVerified] VARCHAR(10) NULL,
    [BSXStatus] VARCHAR(255) NULL,
    [BSXVerificationDate] DATETIME NULL,
    [IsMCXVerified] VARCHAR(10) NULL,
    [MCXStatus] VARCHAR(255) NULL,
    [MCXVerificationDate] DATETIME NULL,
    [IsNCXVerified] VARCHAR(10) NULL,
    [NCXStatus] VARCHAR(255) NULL,
    [NCXVerificationDate] DATETIME NULL,
    [VerifiedBy] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositBankingVarificationProcess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositBankingVarificationProcess]
(
    [BankingProcessId] BIGINT IDENTITY(1,1) NOT NULL,
    [SuspenceAccDetailsId] BIGINT NULL,
    [DepositVarificationId] BIGINT NULL,
    [IsBankingRejected] BIT NULL,
    [RejectionRemarks] VARCHAR(255) NULL,
    [IsJVProcess] BIT NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositKnockOffProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositKnockOffProcessDetails]
(
    [KnockOffDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [DepositRefId] BIGINT NULL,
    [VType] INT NULL,
    [VNo] VARCHAR(30) NULL,
    [VAmount] DECIMAL(17, 2) NULL,
    [VDate] DATETIME NULL,
    [Segment] VARCHAR(3) NULL,
    [Narration] VARCHAR(500) NULL,
    [SBBankAccountNo] VARCHAR(20) NULL,
    [IFSCCode] VARCHAR(18) NULL,
    [BankName] VARCHAR(35) NULL,
    [BranchName] VARCHAR(255) NULL,
    [IsOldProcess] BIT NULL,
    [IsProcessStatus] BIT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositProcessBOLedgerData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositProcessBOLedgerData]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(100) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(100) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(30) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(40) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL,
    [ISKNOCKOFF_PROCESS] BIT NULL,
    [ISPROCESS_STATUS] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositSuspenceAccLedgerData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositSuspenceAccLedgerData]
(
    [FLDAUTO] BIGINT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(20) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(20) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(100) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(30) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(40) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL,
    [ISProcessStatus] BIT NULL,
    [ProcessDate] DATETIME NULL,
    [ISKnockOffPROCESS] BIT NULL,
    [KnockOffProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositSuspenceAccountDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositSuspenceAccountDetails]
(
    [SuspenceAccDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [VType] INT NULL,
    [VNo] VARCHAR(30) NULL,
    [VAmount] DECIMAL(17, 2) NULL,
    [VDate] DATETIME NULL,
    [Segment] VARCHAR(3) NULL,
    [Narration] VARCHAR(500) NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositSuspenceAccountManualProcess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositSuspenceAccountManualProcess]
(
    [VType] INT NULL,
    [VNo] VARCHAR(35) NULL,
    [Amount] DECIMAL(17, 2) NULL,
    [VDT] DATETIME NULL,
    [Narration] VARCHAR(255) NULL,
    [Segment] VARCHAR(5) NULL,
    [RefNo] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBDepositVarificationAndProcessBySBTeam
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBDepositVarificationAndProcessBySBTeam]
(
    [DepositVarificationId] BIGINT IDENTITY(1,1) NOT NULL,
    [SuspenceAccDetailsId] BIGINT NULL,
    [DepositRefId] BIGINT NULL,
    [SBTag] VARCHAR(15) NULL,
    [SBPanNo] VARCHAR(15) NULL,
    [RefNo] VARCHAR(35) NULL,
    [DepositAmount] DECIMAL(17, 2) NULL,
    [IsSBRejected] SMALLINT NULL,
    [RejectionReason] VARCHAR(255) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBKnockOffDebitedAmountProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBKnockOffDebitedAmountProcessDetails]
(
    [KnockOffDetailsId] BIGINT IDENTITY(1,1) NOT NULL,
    [DebitVType] INT NULL,
    [DebitVNo] VARCHAR(30) NULL,
    [DebitVAmount] DECIMAL(17, 2) NULL,
    [DebitVDate] DATETIME NULL,
    [DebitSegment] VARCHAR(3) NULL,
    [DebitNarration] VARCHAR(500) NULL,
    [CreditVType] INT NULL,
    [CreditVNo] VARCHAR(30) NULL,
    [CreditVAmount] DECIMAL(17, 2) NULL,
    [CreditVDate] DATETIME NULL,
    [CreditSegment] VARCHAR(3) NULL,
    [CreditNarration] VARCHAR(500) NULL,
    [CreditRemarks] VARCHAR(500) NULL,
    [IsProcessStatus] BIT NULL,
    [ProcessDate] DATETIME NULL,
    [ProcessBy] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBMultiLocationTagGenerationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBMultiLocationTagGenerationMaster]
(
    [MultiTagMasterId] BIGINT IDENTITY(1,1) NOT NULL,
    [SBMasterId] BIGINT NULL,
    [MobileNo] VARCHAR(15) NULL,
    [EmailId] VARCHAR(255) NULL,
    [Address1] VARCHAR(355) NULL,
    [Address2] VARCHAR(355) NULL,
    [Address3] VARCHAR(255) NULL,
    [AreaLandmark] VARCHAR(255) NULL,
    [City] VARCHAR(45) NULL,
    [PinCode] VARCHAR(10) NULL,
    [State] VARCHAR(35) NULL,
    [Country] VARCHAR(20) NULL,
    [TagsheetMOUDocName] VARCHAR(255) NULL,
    [CancellationChaqueDocName] VARCHAR(255) NULL,
    [TagsheetAddressProffDocName] VARCHAR(255) NULL,
    [TagsheetApprovalDocName] VARCHAR(255) NULL,
    [ProcessBy] VARCHAR(15) NULL,
    [ProcessDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBPayoutDepositProcessDetailsInLMS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBPayoutDepositProcessDetailsInLMS]
(
    [DepositRefId] BIGINT IDENTITY(1,1) NOT NULL,
    [SBPanNo] VARCHAR(15) NULL,
    [SBTag] VARCHAR(15) NULL,
    [SBName] VARCHAR(250) NULL,
    [RefNo] NVARCHAR(50) NULL,
    [Amount] DECIMAL(17, 2) NULL,
    [Extension] VARCHAR(10) NULL,
    [FileName] VARCHAR(100) NULL,
    [Remarks] VARCHAR(255) NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] VARCHAR(20) NULL,
    [IsSBRejected] INT NULL,
    [SBRejectionReason] VARCHAR(250) NULL,
    [IsBankingRejected] INT NULL,
    [BankingRejectionReason] VARCHAR(250) NULL,
    [BDMEmailId] VARCHAR(650) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBPayoutDepositProcessDocumentDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBPayoutDepositProcessDocumentDetails]
(
    [Deposit_DocId] BIGINT IDENTITY(1,1) NOT NULL,
    [DepositRefId] BIGINT NULL,
    [Files] IMAGE NULL,
    [FileName] VARCHAR(100) NULL,
    [Extension] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SBPayoutDetailsBankingVarification
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SBPayoutDetailsBankingVarification]
(
    [BankingVarificationId] BIGINT IDENTITY(1,1) NOT NULL,
    [SBTag] VARCHAR(15) NULL,
    [SBPanNo] VARCHAR(15) NULL,
    [BankingRemarks] VARCHAR(25) NULL,
    [RejectionReason] VARCHAR(255) NULL,
    [CreatedOn] DATETIME NULL,
    [CreatedBy] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SubBrokerOnBoardingCompanyMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SubBrokerOnBoardingCompanyMaster]
(
    [CompanyId] INT IDENTITY(1,1) NOT NULL,
    [CompanyCode] VARCHAR(15) NULL,
    [CompanyName] VARCHAR(255) NULL,
    [CreationDate] DATETIME NULL,
    [CreatedBy] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UndeliveredClientDRFInwordDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UndeliveredClientDRFInwordDetails]
(
    [UnDeliveredId] BIGINT IDENTITY(1,1) NOT NULL,
    [DRFId] BIGINT NULL,
    [NoOfCertificates] INT NULL,
    [PodNo] VARCHAR(35) NULL,
    [CourierBy] VARCHAR(150) NULL,
    [Remarks] VARCHAR(225) NULL,
    [InwordProcessDate] DATETIME NULL,
    [IsReProcess] BIT NULL,
    [ReProcessDate] DATETIME NULL,
    [IsDocumentReceived] BIT NULL,
    [DRFReceivedDate] DATETIME NULL,
    [ProcessBy] VARCHAR(50) NULL,
    [ReProcessType] VARCHAR(15) NULL,
    [DocumentReceivedBy] VARCHAR(15) NULL,
    [ReProcessPodNo] VARCHAR(35) NULL,
    [ReProcessCourierName] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblInterSegmentJV
-- --------------------------------------------------
CREATE TABLE [dbo].[tblInterSegmentJV]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [CreatedDate] DATETIME NULL,
    [FromSegment] NVARCHAR(20) NULL,
    [ToSegment] NVARCHAR(20) NULL,
    [FromAmount] MONEY NULL,
    [ToAmount] MONEY NULL,
    [Adjust] MONEY NULL,
    [Pending] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblInterSegmentJVCalculation
-- --------------------------------------------------
CREATE TABLE [dbo].[tblInterSegmentJVCalculation]
(
    [FromSegment] NVARCHAR(20) NULL,
    [FromCount] INT NULL,
    [FromCode] NVARCHAR(20) NULL,
    [FromAmount] MONEY NULL,
    [ToSegment] NVARCHAR(20) NULL,
    [ToCount] INT NULL,
    [ToCode] NVARCHAR(20) NULL,
    [ToAmount] MONEY NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblInterSegmentJVCalculationLogData
-- --------------------------------------------------
CREATE TABLE [dbo].[tblInterSegmentJVCalculationLogData]
(
    [FromSegment] NVARCHAR(20) NULL,
    [FromCount] INT NULL,
    [FromCode] NVARCHAR(20) NULL,
    [FromAmount] MONEY NULL,
    [ToSegment] NVARCHAR(20) NULL,
    [ToCount] INT NULL,
    [ToCode] NVARCHAR(20) NULL,
    [ToAmount] MONEY NULL,
    [CreatedDate] DATETIME NULL,
    [UpdationDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblInterSegmentLogData
-- --------------------------------------------------
CREATE TABLE [dbo].[tblInterSegmentLogData]
(
    [CLTCODE] NVARCHAR(50) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdationDate] DATETIME NULL,
    [FromSegment] NVARCHAR(20) NULL,
    [ToSegment] NVARCHAR(20) NULL,
    [FromAmount] MONEY NULL,
    [ToAmount] MONEY NULL,
    [Adjust] MONEY NULL,
    [Pending] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblNBFCFundingProcessDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tblNBFCFundingProcessDetails]
(
    [CLTCODE] VARCHAR(50) NULL,
    [NSE] DECIMAL(18, 2) NULL,
    [BSE] DECIMAL(18, 2) NULL,
    [NSEFO] DECIMAL(18, 2) NULL,
    [NSX] DECIMAL(18, 2) NULL,
    [MCX] DECIMAL(18, 2) NULL,
    [NCX] DECIMAL(18, 2) NULL,
    [BSX] DECIMAL(18, 2) NULL,
    [NSE_MAR] DECIMAL(18, 2) NULL,
    [BSE_MAR] DECIMAL(18, 2) NULL,
    [NSEFO_MAR] DECIMAL(18, 2) NULL,
    [NSX_MAR] DECIMAL(18, 2) NULL,
    [MCX_MAR] DECIMAL(18, 2) NULL,
    [NCX_MAR] DECIMAL(18, 2) NULL,
    [BSX_MAR] DECIMAL(18, 2) NULL,
    [TOTAL_Balance] DECIMAL(18, 2) NULL,
    [TOTAL_NSEBSE] DECIMAL(18, 2) NULL,
    [TOTAL_MAR] DECIMAL(18, 2) NULL,
    [TOTAL_PLEDGE] DECIMAL(18, 2) NULL,
    [TOTAL_PLEDGE_HC] DECIMAL(18, 2) NULL,
    [TOTAL_EPN] DECIMAL(18, 2) NULL,
    [NBFC] DECIMAL(18, 2) NULL,
    [Shortage] DECIMAL(18, 2) NULL,
    [PF_VAL_HC] DECIMAL(18, 2) NULL,
    [ACT_LEDGER] DECIMAL(18, 2) NULL,
    [Available_Net] DECIMAL(18, 2) NULL,
    [NBFCFundingDate] DATETIME NULL,
    [CreationDate] DATETIME NULL,
    [IsProcess2] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UploadExcel
-- --------------------------------------------------
CREATE TABLE [dbo].[UploadExcel]
(
    [ID] INT IDENTITY(1,1) NOT NULL,
    [SBTag] VARCHAR(10) NULL,
    [Segment] NVARCHAR(15) NULL,
    [CreatedDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserProfile
-- --------------------------------------------------
CREATE TABLE [dbo].[UserProfile]
(
    [UserId] INT IDENTITY(1,1) NOT NULL,
    [UserName] VARCHAR(50) NULL,
    [Password] VARCHAR(50) NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.V2_OfflineLedger
-- --------------------------------------------------
CREATE TABLE [dbo].[V2_OfflineLedger]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] VARCHAR(2) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] VARCHAR(10) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(10) NULL,
    [MarginCode] VARCHAR(10) NULL,
    [BankName] VARCHAR(100) NULL,
    [BranchName] VARCHAR(100) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [DDNo] VARCHAR(30) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(100) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(20) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(25) NULL,
    [StatusID] VARCHAR(25) NULL,
    [StatusName] VARCHAR(25) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(25) NULL,
    [VoucherNo] VARCHAR(12) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(12) NULL,
    [ClientName] VARCHAR(100) NULL,
    [OppCodeName] VARCHAR(100) NULL,
    [MarginCodeName] VARCHAR(100) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [ProductType] VARCHAR(3) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(10) NULL,
    [MICR] VARCHAR(12) NULL,
    [IsUpdatetoLive] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.V3_OfflineLedger
-- --------------------------------------------------
CREATE TABLE [dbo].[V3_OfflineLedger]
(
    [FldAuto] BIGINT IDENTITY(1,1) NOT NULL,
    [VoucherType] SMALLINT NULL,
    [BookType] VARCHAR(2) NULL,
    [SNo] INT NULL,
    [Vdate] DATETIME NULL,
    [EDate] DATETIME NULL,
    [CltCode] VARCHAR(10) NULL,
    [CreditAmt] MONEY NULL,
    [DebitAmt] MONEY NULL,
    [Narration] VARCHAR(255) NULL,
    [OppCode] VARCHAR(10) NULL,
    [MarginCode] VARCHAR(10) NULL,
    [BankName] VARCHAR(100) NULL,
    [BranchName] VARCHAR(100) NULL,
    [BranchCode] VARCHAR(10) NULL,
    [DDNo] VARCHAR(30) NULL,
    [ChequeMode] VARCHAR(1) NULL,
    [ChequeDate] DATETIME NULL,
    [ChequeName] VARCHAR(100) NULL,
    [Clear_Mode] VARCHAR(1) NULL,
    [TPAccountNumber] VARCHAR(20) NULL,
    [Exchange] VARCHAR(3) NULL,
    [Segment] VARCHAR(20) NULL,
    [TPFlag] TINYINT NULL,
    [AddDt] DATETIME NULL,
    [AddBy] VARCHAR(25) NULL,
    [StatusID] VARCHAR(25) NULL,
    [StatusName] VARCHAR(25) NULL,
    [RowState] TINYINT NULL,
    [ApprovalFlag] TINYINT NULL,
    [ApprovalDate] DATETIME NULL,
    [ApprovedBy] VARCHAR(25) NULL,
    [VoucherNo] VARCHAR(12) NULL,
    [UploadDt] DATETIME NULL,
    [LedgerVNO] VARCHAR(12) NULL,
    [ClientName] VARCHAR(100) NULL,
    [OppCodeName] VARCHAR(100) NULL,
    [MarginCodeName] VARCHAR(100) NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [ProductType] VARCHAR(3) NULL,
    [RevAmt] MONEY NULL,
    [RevCode] VARCHAR(10) NULL,
    [MICR] VARCHAR(12) NULL,
    [IsUpdatetoLive] BIT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_GetClientDRF_DP_CDSL_RTAProcessRejectionStatus
-- --------------------------------------------------
  
CREATE View Vw_GetClientDRF_DP_CDSL_RTAProcessRejectionStatus  
AS  
SELECT DISTINCT  *  FROM (     
       
SELECT  DISTINCT         
PADRFIRPM.DRFId 'DRFId',    
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',               
DMATDMK.DEMRM_ID 'DEMRM_ID',                   
                         
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 1 ELSE 0 END 'IsMakerProcess',                          
      
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1               
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 1                
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND               
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1               
ELSE 0 END 'IsCheckerProcess',       
      
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND               
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1               
ELSE 0 END 'IsCheckerRejected',       
      
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'      
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,      
                         
       
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                
THEN 1   
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'      
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 1 ELSE 0 END 'IsCDSLProcess',              
      
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                
THEN 1  
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                
THEN 1  
ELSE 0 END 'IsCDSLRejected',                                       
      
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')     
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')          
THEN 1 ELSE 0 END 'IsRTAProcess' ,  
  
CASE   
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)' THEN  1  
ELSE 0    
END 'IsRTARejected'   
               
From tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)      
JOIN [AGMUBODPL3].DMAT.[citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)    
ON PADRFIRPM.DRFNo = DMATDMK.DEMRM_SLIP_SERIAL_NO    
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)               
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID        
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].dmat_dispatch DMATDD WITH(NOLOCK)       
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id  and DISP_TO = 'R'             
LEFT JOIN (   
SELECT * FROM (  
Select DENSE_RANK() over(partition by cdshm_trans_no order by cdshm_created_dt desc, cdshm_id desc) 'SRNo'    
,DEMRM_SLIP_SERIAL_NO, CDSHM_TRATM_DESC,cdshm_id 'cdshm_id'    
,cdshm_trans_no,cdshm_dpam_id,cdshm_created_dt    
FROM [AGMUBODPL3].DMAT.[citrus_usr].cdsl_holding_dtls CDSLHD    
JOIN [AGMUBODPL3].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)    
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no          
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id    
JOIN tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)    
ON PADRFIRPM.DRFNo = DMATRMT.DEMRM_SLIP_SERIAL_NO    
---where cdshm_trans_no='10475391' and cdshm_dpam_id=7305641    
)S WHERE SRNo=1  
) CDSLHD          
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no          
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id        
--AND ISNULL(CDSHM_TRATM_DESC,'') IN ('DEMAT10473466 CLOSE-CR CONFIRMED BALANCE'          
--,'DEMAT10473459 REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)')          
WHERE  DMATDMK.demrm_deleted_ind in(0,1,-1)             
--AND DMATDMK.DEMRM_SLIP_SERIAL_NO = '1531764'              
    
UNION      
      
SELECT  DISTINCT         
PADRFIRPM.DRFId 'DRFId',    
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',               
DMATDMK.DEMRM_ID 'DEMRM_ID',                   
                         
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 1 ELSE 0 END 'IsMakerProcess',                          
      
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1               
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 1                
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND               
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1               
ELSE 0 END 'IsCheckerProcess',       
      
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND               
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1               
ELSE 0 END 'IsCheckerRejected',       
      
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'      
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,      
                         
       
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                
THEN 1   
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'      
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 1 ELSE 0 END 'IsCDSLProcess',              
      
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                
THEN 1  
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                
THEN 1  
ELSE 0 END 'IsCDSLRejected',                                       
      
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')     
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')          
THEN 1 ELSE 0 END 'IsRTAProcess' ,  
CASE   
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)' THEN  1  
ELSE 0    
END 'IsRTARejected'   
                          
               
From tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)      
JOIN [AngelDP5].DMAT.[citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)    
ON PADRFIRPM.DRFNo = DMATDMK.DEMRM_SLIP_SERIAL_NO    
LEFT JOIN [AngelDP5].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)               
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID        
LEFT JOIN [AngelDP5].DMAT.[citrus_usr].dmat_dispatch DMATDD WITH(NOLOCK)       
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id  and DISP_TO = 'R'             
LEFT JOIN (    
SELECT * FROM (  
Select DENSE_RANK() over(partition by cdshm_trans_no order by cdshm_created_dt desc, cdshm_id desc) 'SRNo'    
,DEMRM_SLIP_SERIAL_NO, CDSHM_TRATM_DESC,cdshm_id 'cdshm_id'    
,cdshm_trans_no,cdshm_dpam_id,cdshm_created_dt    
FROM [AngelDP5].DMAT.[citrus_usr].cdsl_holding_dtls CDSLHD    
JOIN [AngelDP5].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)    
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no          
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id    
JOIN tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)    
ON PADRFIRPM.DRFNo = DMATRMT.DEMRM_SLIP_SERIAL_NO    
---where cdshm_trans_no='10475391' and cdshm_dpam_id=7305641  
) S WHERE SRNo=1      
) CDSLHD          
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no          
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id       
--AND ISNULL(CDSHM_TRATM_DESC,'') IN ('DEMAT10473466 CLOSE-CR CONFIRMED BALANCE'          
--,'DEMAT10473459 REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)')          
WHERE  DMATDMK.demrm_deleted_ind in(0,1,-1)             
--AND DMATDMK.DEMRM_SLIP_SERIAL_NO = '1531764'              
)BB    
WHERE IsCheckerRejected=1 OR IsCDSLRejected=1 OR IsRTARejected=1

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_GetClientDRF_DP_CDSL_RTAProcessStatus
-- --------------------------------------------------
  
CREATE VIEW Vw_GetClientDRF_DP_CDSL_RTAProcessStatus      
AS      
SELECT DISTINCT              
DRFId,DRFNo,DEMRM_ID,CurrentStatus,MakerStatus 'MakerProcessStatus',IsMakerProcess,MakerDate 'MakerProcessDate',MakerBy                      
,IsCheckerProcess,IsCheckerRejected,CheckerStatus 'CheckerProcessStatus',CheckerRemarks 'CheckerProcessRemarks',CheckerDate 'CheckerProcessDate',CheckerBy                        
,BatchUploadInCDSL,BatchNo,DRNNo,IsCDSLProcess,IsCDSLRejected,CDSLStatus,CDSLRemarks,                        
CDSLDate 'CDSLProcessDate',RTALetterGenerate,DispatchDate,IsRTAProcess,       
CASE WHEN CONVERT(VARCHAR(17),RTAProcessDate,113) ='01 Jan 1900 00:00' THEN ''      
ELSE CONVERT(VARCHAR(17),RTAProcessDate,113) END 'RTAProcessDate'                        
,RTAStatus,RTARemarks                       
FROM (                 
 SELECT  DISTINCT              
DRFId,DRFNo,DEMRM_ID,CurrentStatus,MakerStatus ,IsMakerProcess,MakerDate ,MakerBy                      
,IsCheckerProcess,IsCheckerRejected,CheckerStatus ,CheckerRemarks ,CheckerDate ,CheckerBy                        
,BatchUploadInCDSL,BatchNo,DRNNo,IsCDSLProcess,IsCDSLRejected,CDSLStatus,CDSLRemarks,                        
CDSLDate ,RTALetterGenerate,'' DispatchDate,IsRTAProcess      
,CASE WHEN CAST(CONVERT(datetime,RTAProcessDate,103) as date) = '1900-01-01' THEN ''       
ELSE CONVERT(datetime,RTAProcessDate,103)  END 'RTAProcessDate'                        
,RTAStatus,RTARemarks        
FROM       
(          
          
        
SELECT  DISTINCT           
PADRFIRPM.DRFId 'DRFId',      
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',                 
--DMATDMK.DEMRM_ID 'DEMRM_ID',                 
'' 'DEMRM_ID',  
                 
--CASE WHEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''                  
--THEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,''))                 
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'                    
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'                   
--when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'                  
--when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,        
      
      
CASE       
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='VERIFY-CR PENDING CONFIRMATION' THEN  'VERIFY'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'      
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'                    
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'                   
when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'                  
when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,        
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 'Done' ELSE 'Pending' END 'MakerStatus',                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 1 ELSE 0 END 'IsMakerProcess',                 
CONVERT(VARCHAR(20),DMATDMK.DEMRM_CREATED_DT,113) 'MakerDate',                 
                 
DMATDMK.DEMRM_CREATED_BY 'MakerBy',                 
DMATDMK.DEMRM_LST_UPD_BY 'CheckerBy',                 
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1                 
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 'Done'                  
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 'Rejected'              
ELSE 'Pending' END 'CheckerStatus',          
        
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1                 
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 1                  
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1                 
ELSE 0 END 'IsCheckerProcess',         
        
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1                 
ELSE 0 END 'IsCheckerRejected',         
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>''                  
AND (ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '')                 
THEN CASE WHEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <>'' THEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'')                
WHEN ISNULL(DMATDMK.demrm_res_desc_intobj,'')<>'' THEN ISNULL(DMATDMK.demrm_res_desc_intobj,'')                
ELSE '' END                  
ELSE ''                
END 'CheckerRemarks',                   
                 
CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113) 'CheckerDate',                 
                 
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''                  
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )                  
--THEN CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'DispatchDate',         
--'' DispatchDate,              
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> ''        
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0' THEN 1    
ELSE 0 END 'BatchUploadInCDSL' ,        
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN DMATRMT.DEMRM_BATCH_NO ELSE '' END 'BatchNo',                 
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,        
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 'CDSL Rejected'      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 'CDSL Rejected'      
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 'CDSL Done' ELSE '' END 'CDSLStatus',                
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 1      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 1     
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 1 ELSE 0 END 'IsCDSLProcess',                
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 1    
ELSE 0 END 'IsCDSLRejected',                
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN DMATRMT.DEMRM_INTERNAL_REJ     
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 'CDSL Rejected - Batch Generated'     
ELSE '' END 'CDSLRemarks',                 
                 
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''                  
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )                  
--THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'CDSLDate',               
                
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''       
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'       
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE '' END   'CDSLDate',        
--CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> ''      
--THEN Convert(Nvarchar(255),(MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),113) END 'CDSLDate',      
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''        
AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' AND ISNULL(DMATDD.disp_demrm_id,0)<>0               
AND ISNULL((MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),'')<>''                 
THEN 1 ELSE 0 END   'RTALetterGenerate',                 
        
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')            
THEN 1 ELSE 0 END 'IsRTAProcess',                
                 
--CASE WHEN citrus_usr.gettranstype(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0')) <> ''                  
--THEN citrus_usr.gettranstype_date(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0'))         
--ELSE '' END 'RTAProcessDate',              
-- CAST(CDSLHD.cdshm_tras_dt as date) 'RTAProcessDate',       
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')       
THEN Convert(NVARCHAR(255),(MAX(CDSLHD.cdshm_created_dt) OVER (PARTITION BY cdshm_dpam_id)),113)      
ELSE ''      
END  'RTAProcessDate',      
                 
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,'')) NOT In('SETUP', '')                  
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')            
THEN 'Done' ELSE '' END 'RTAStatus',          
      
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''                  
--THEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,'')) ELSE ''      
CASE     
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)' THEN  'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'    
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='VERIFY-CR PENDING CONFIRMATION' THEN  'VERIFY'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'      
ELSE ''      
END 'RTARemarks'                 
                 
From tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)        
JOIN [AGMUBODPL3].DMAT.[citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)      
ON PADRFIRPM.DRFNo = DMATDMK.DEMRM_SLIP_SERIAL_NO      
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)                 
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID          
LEFT JOIN [AGMUBODPL3].DMAT.[citrus_usr].dmat_dispatch DMATDD WITH(NOLOCK)         
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id  and DISP_TO = 'R'               
LEFT JOIN (     
SELECT * FROM (    
Select DENSE_RANK() over(partition by cdshm_trans_no order by cdshm_created_dt desc, cdshm_id desc) 'SRNo'      
,DEMRM_SLIP_SERIAL_NO, CDSHM_TRATM_DESC,cdshm_id 'cdshm_id'      
,cdshm_trans_no,cdshm_dpam_id,cdshm_created_dt      
FROM [AGMUBODPL3].DMAT.[citrus_usr].cdsl_holding_dtls CDSLHD      
JOIN [AGMUBODPL3].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)      
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no            
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id      
JOIN tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)      
ON PADRFIRPM.DRFNo = DMATRMT.DEMRM_SLIP_SERIAL_NO      
---where cdshm_trans_no='10475391' and cdshm_dpam_id=7305641      
)S WHERE SRNo=1    
) CDSLHD            
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no            
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id          
--AND ISNULL(CDSHM_TRATM_DESC,'') IN ('DEMAT10473466 CLOSE-CR CONFIRMED BALANCE'            
--,'DEMAT10473459 REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)')            
WHERE  DMATDMK.demrm_deleted_ind in(0,1,-1)               
--AND DMATDMK.DEMRM_SLIP_SERIAL_NO = '1531764'                
)AA      
      
UNION      
      
SELECT  DISTINCT              
DRFId,DRFNo,DEMRM_ID,CurrentStatus,MakerStatus ,IsMakerProcess,MakerDate ,MakerBy                      
,IsCheckerProcess,IsCheckerRejected,CheckerStatus ,CheckerRemarks ,CheckerDate ,CheckerBy                        
,BatchUploadInCDSL,BatchNo,DRNNo,IsCDSLProcess,IsCDSLRejected,CDSLStatus,CDSLRemarks,                        
CDSLDate ,RTALetterGenerate,'' DispatchDate,IsRTAProcess,      
CASE WHEN CONVERT(datetime,RTAProcessDate,103) = '1900-01-01 00:00:00.000' THEN ''       
ELSE CONVERT(datetime,RTAProcessDate,103)  END 'RTAProcessDate'                       
,RTAStatus,RTARemarks        
 FROM       
(          
          
        
SELECT  DISTINCT           
PADRFIRPM.DRFId 'DRFId',      
DMATDMK.DEMRM_SLIP_SERIAL_NO 'DRFNo',                 
--DMATDMK.DEMRM_ID 'DEMRM_ID',                 
'' 'DEMRM_ID',  
                 
--CASE WHEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''                  
--THEN [172.31.16.94].DMAT.citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,''))                 
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'                    
--WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'                   
--when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'                  
--when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,        
      
      
CASE       
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='VERIFY-CR PENDING CONFIRMATION' THEN  'VERIFY'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'      
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') = '0' then 'REJECTED FROM CDSL'                    
WHEN ISNULL(DEMRM_TRANSACTION_NO,'') <> '' then 'RESPONSE FILE IMPORTED'                   
when ISNULL(DEMRM_BATCH_NO,'') <> '' then 'BATCH GENERATED'                  
when DMATDMK.demrm_deleted_ind = 1 then 'CHECKER DONE' ELSE '' END AS CurrentStatus,        
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 'Done' ELSE 'Pending' END 'MakerStatus',                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' THEN 1 ELSE 0 END 'IsMakerProcess',                 
CONVERT(VARCHAR(20),DMATDMK.DEMRM_CREATED_DT,113) 'MakerDate',                 
                 
DMATDMK.DEMRM_CREATED_BY 'MakerBy',                 
DMATDMK.DEMRM_LST_UPD_BY 'CheckerBy',                 
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1                 
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 'Done'                  
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 'Rejected'                 
ELSE 'Pending' END 'CheckerStatus',          
        
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND DMATDMK.DEMRM_DELETED_IND = 1                 
AND ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') = '' AND ISNULL(DMATDMK.demrm_res_desc_intobj,'')='' THEN 1                  
WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1                 
ELSE 0 END 'IsCheckerProcess',         
        
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>'' AND                 
(ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '') THEN 1                 
ELSE 0 END 'IsCheckerRejected',         
                 
CASE WHEN ISNULL(DMATDMK.DEMRM_SLIP_SERIAL_NO,'')<>''                  
AND (ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <> '' or ISNULL(DMATDMK.demrm_res_desc_intobj,'') <> '')                 
THEN CASE WHEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'') <>'' THEN ISNULL(DMATDMK.DEMRM_INTERNAL_REJ,'')                
WHEN ISNULL(DMATDMK.demrm_res_desc_intobj,'')<>'' THEN ISNULL(DMATDMK.demrm_res_desc_intobj,'')                
ELSE '' END                  
ELSE ''                
END 'CheckerRemarks',                   
                 
CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113) 'CheckerDate',                 
                 
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''                  
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )                  
--THEN CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'DispatchDate',         
--'' DispatchDate,              
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_TRANSACTION_NO ,'') <> ''        
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0' THEN 1    
ELSE 0 END 'BatchUploadInCDSL' ,        
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN DMATRMT.DEMRM_BATCH_NO ELSE '' END 'BatchNo',                 
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
THEN DMATRMT.DEMRM_TRANSACTION_NO  ELSE '' END 'DRNNo' ,        
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 'CDSL Rejected'      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 'CDSL Rejected'      
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 'CDSL Done' ELSE '' END 'CDSLStatus',                
         
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 1      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 1     
 WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> '0'        
 AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' THEN 1 ELSE 0 END 'IsCDSLProcess',                
        
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN 1    
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 1    
ELSE 0 END 'IsCDSLRejected',                
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''                  
THEN DMATRMT.DEMRM_INTERNAL_REJ     
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'                  
THEN 'CDSL Rejected - Batch Generated'     
ELSE '' END 'CDSLRemarks',                 
                 
--CASE WHEN (ISNULL(DMATDMK.demrm_internal_rej,'') <> '' OR ISNULL(DMATRMT.demrm_company_obj,'')<>''                  
--OR ISNULL(DMATDMK.demrm_res_cd_intobj,'')<>'' OR ISNULL(DMATDMK.demrm_res_cd_compobj,'')<>'' )                  
--THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE CONVERT(VARCHAR(20),DISP_DT,113) END   'CDSLDate',               
                
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') <>''       
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND  ISNULL(DEMRM_TRANSACTION_NO,'0')= '0'       
THEN CONVERT(VARCHAR(20),DMATDMK.DEMRM_LST_UPD_DT,113)      
WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' THEN  CONVERT(VARCHAR(20),DISP_DT,113) ELSE '' END   'CDSLDate',        
--CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> ''      
--THEN Convert(Nvarchar(255),(MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),113) END 'CDSLDate',      
                 
CASE WHEN ISNULL(DMATRMT.DEMRM_BATCH_NO,'') <> '' AND ISNULL(DEMRM_TRANSACTION_NO,'0')<> ''        
AND ISNULL(DMATRMT.DEMRM_INTERNAL_REJ,'') ='' AND ISNULL(DMATDD.disp_demrm_id,0)<>0               
AND ISNULL((MAX(DISP_DT) OVER (PARTITION BY cdshm_dpam_id)),'')<>''                 
THEN 1 ELSE 0 END   'RTALetterGenerate',                 
        
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')            
THEN 1 ELSE 0 END 'IsRTAProcess',                
                 
--CASE WHEN citrus_usr.gettranstype(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0')) <> ''                  
--THEN citrus_usr.gettranstype_date(ISNULL(DMATRMT.demrm_transaction_no,''),ISNULL(convert(varchar,DMATRMT.demrm_dpam_id),'0'))         
--ELSE '' END 'RTAProcessDate',              
-- CAST(CDSLHD.cdshm_tras_dt as date) 'RTAProcessDate',       
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')       
THEN Convert(NVARCHAR(255),(MAX(CDSLHD.cdshm_created_dt) OVER (PARTITION BY cdshm_dpam_id)),113)      
ELSE ''      
END  'RTAProcessDate',      
                 
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,'')) NOT In('SETUP', '')                  
CASE WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'')       
NOT In('VERIFY-CR PENDING CONFIRMATION','SETUP-CR PENDING VERIFICATION','VERIFY-DB PENDING VERIFICATION', '')            
THEN 'Done' ELSE '' END 'RTAStatus',          
      
--CASE WHEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_dpam_id,''))<> ''                  
--THEN citrus_usr.gettranstype(ISNULL(DEMRM_TRANSACTION_NO,''),ISNULL(DMATDMK.DEMRM_DPAM_ID,'')) ELSE ''      
CASE     
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)' THEN  'REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)'    
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='CLOSE-CR CONFIRMED BALANCE' THEN  'CONFIRMED (CREDIT CURRENT BALANCE)'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='VERIFY-CR PENDING CONFIRMATION' THEN  'VERIFY'      
WHEN ISNULL(STUFF(CDSHM_TRATM_DESC, 1, CHARINDEX(' ', CDSHM_TRATM_DESC), ''),'') ='SETUP-CR PENDING VERIFICATION' THEN  'SETUP'      
ELSE ''      
END 'RTARemarks'                
                 
From tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)        
JOIN [AngelDP5].DMAT.[citrus_usr].demrm_mak DMATDMK WITH(NOLOCK)      
ON PADRFIRPM.DRFNo = DMATDMK.DEMRM_SLIP_SERIAL_NO      
LEFT JOIN [AngelDP5].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)                 
ON  DMATDMK.DEMRM_ID = DMATRMT.DEMRM_ID          
LEFT JOIN [AngelDP5].DMAT.[citrus_usr].dmat_dispatch DMATDD WITH(NOLOCK)         
ON DMATDMK.DEMRM_ID = DMATDD.disp_demrm_id  and DISP_TO = 'R'               
LEFT JOIN (      
SELECT * FROM (    
Select DENSE_RANK() over(partition by cdshm_trans_no order by cdshm_created_dt desc, cdshm_id desc) 'SRNo'      
,DEMRM_SLIP_SERIAL_NO, CDSHM_TRATM_DESC,cdshm_id 'cdshm_id'      
,cdshm_trans_no,cdshm_dpam_id,cdshm_created_dt      
FROM [AngelDP5].DMAT.[citrus_usr].cdsl_holding_dtls CDSLHD      
JOIN [AngelDP5].DMAT.[citrus_usr].DEMAT_REQUEST_MSTR DMATRMT WITH(NOLOCK)      
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no            
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id      
JOIN tbl_DRFInwordRegistrationProcessMaster PADRFIRPM WITH(NOLOCK)      
ON PADRFIRPM.DRFNo = DMATRMT.DEMRM_SLIP_SERIAL_NO      
---where cdshm_trans_no='10475391' and cdshm_dpam_id=7305641    
) S WHERE SRNo=1        
) CDSLHD            
ON DMATRMT.demrm_transaction_no = CDSLHD.cdshm_trans_no            
AND DMATRMT.DEMRM_dpam_id = CDSLHD.cdshm_dpam_id         
--AND ISNULL(CDSHM_TRATM_DESC,'') IN ('DEMAT10473466 CLOSE-CR CONFIRMED BALANCE'            
--,'DEMAT10473459 REJECTED (VERIFICATION / CONFIRMATION REJECTED QUANTITY)')            
WHERE  DMATDMK.demrm_deleted_ind in(0,1,-1)               
--AND DMATDMK.DEMRM_SLIP_SERIAL_NO = '1531764'                
)AA      
)BB

GO

