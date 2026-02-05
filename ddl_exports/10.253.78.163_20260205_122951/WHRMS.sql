-- DDL Export
-- Server: 10.253.78.163
-- Database: WHRMS
-- Exported: 2026-02-05T12:32:33.792828

USE WHRMS;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.BoxMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BoxMaster] ADD CONSTRAINT [FK__BoxMaster__Branc__7EF6D905] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.CourierTransactionMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[CourierTransactionMaster] ADD CONSTRAINT [fk_InvBranchMaster_CourierMaster] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.DepartmentMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[DepartmentMaster] ADD CONSTRAINT [FK__Departmen__Branc__6EC0713C] FOREIGN KEY ([Branchid]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.FormMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormMaster] ADD CONSTRAINT [fk_FormTypeMaster_FormMaster] FOREIGN KEY ([FormTypeId]) REFERENCES [dbo].[FormTypeMaster] ([FormTypeId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvBranchConsumption
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchConsumption] ADD CONSTRAINT [fk_FormMaster_BranchConsumption] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvBranchConsumption
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchConsumption] ADD CONSTRAINT [fk_InvBranchMaster_BranchConsumption] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvBranchStockMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchStockMaster] ADD CONSTRAINT [fk_FormMaster_BranchStockMaster] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvBranchStockMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchStockMaster] ADD CONSTRAINT [fk_InvBranchMaster_BranchStockMaster] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispatchDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispatchDetails] ADD CONSTRAINT [FK__DispatchD__Branc__02284B6B] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToBranchDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToBranchDetails] ADD CONSTRAINT [fk_InvDispToBranchHeader_InvDispToBranchDetails] FOREIGN KEY ([DispToBranchJcNo]) REFERENCES [dbo].[InvDispToBranchHeader] ([DispToBranchJcNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToBranchHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToBranchHeader] ADD CONSTRAINT [fk_FormMaster_InvDispToBranchHeader] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToBranchHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToBranchHeader] ADD CONSTRAINT [fk_InvBranchMaster_InvDispToBranchHeader] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToCSODetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToCSODetails] ADD CONSTRAINT [fk_DispToCSOJCNo_DispToKYCDetails] FOREIGN KEY ([DispToCSOJCNo]) REFERENCES [dbo].[InvDispToCSOHeader] ([DispToCSOJCNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToCSOHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToCSOHeader] ADD CONSTRAINT [fk_FormMaster_InvDispToCSOHeader] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToKYCDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToKYCDetails] ADD CONSTRAINT [fk_InvDispToKYCHeader_DispToKYCDetails] FOREIGN KEY ([DispToKycJCNo]) REFERENCES [dbo].[InvDispToKYCHeader] ([DispToKycJCNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvDispToKYCHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToKYCHeader] ADD CONSTRAINT [fk_FormMaster_InvDispToKYCHeader] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvEmpMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvEmpMenuRightsMaster] ADD CONSTRAINT [FK__InvEmpMen__menui__62E4AA3C] FOREIGN KEY ([menuid]) REFERENCES [dbo].[InvMenuMaster] ([MenuId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvInwardRegisterDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterDetails] ADD CONSTRAINT [FK__InvInward__LotId__63D8CE75] FOREIGN KEY ([LotId]) REFERENCES [dbo].[FormsLotMaster] ([LotId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvInwardRegisterDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterDetails] ADD CONSTRAINT [fk_InwardRegHeader_InwardRegDtls] FOREIGN KEY ([InwardJCNo]) REFERENCES [dbo].[InvInwardRegisterHeader] ([InwardJCNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvInwardRegisterHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterHeader] ADD CONSTRAINT [fk_FormMaster_InvInwardRegisterHeader] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvReceiptDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvReceiptDetails] ADD CONSTRAINT [fk_InvReceiptHeader_InvReceiptDetails] FOREIGN KEY ([ReceiptJCNo]) REFERENCES [dbo].[InvReceiptHeader] ([ReceiptJCNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvReceiptHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvReceiptHeader] ADD CONSTRAINT [fk_FormMaster_InvReceiptHeader] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUsedFormsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsDetails] ADD CONSTRAINT [fk_InvUsedFormsHeader_InvDispToBranchDetails] FOREIGN KEY ([UsedFormsJcNo]) REFERENCES [dbo].[InvUsedFormsHeader] ([UsedFormsJcNo])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUsedFormsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsDetails] ADD CONSTRAINT [fk_InvUsedFormsHeader_InvUsedFormsDetails] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUsedFormsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsDetails] ADD CONSTRAINT [fk_InvUsedFormsHeader_InvUsedFormsDetailsId] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUsedFormsHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsHeader] ADD CONSTRAINT [fk_FormMaster_InvUsedForms] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUsedFormsHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsHeader] ADD CONSTRAINT [fk_InvBranchMaster_InvUsedForms] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[InvBranchMaster] ([BranchId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUserTypeMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUserTypeMenuRightsMaster] ADD CONSTRAINT [FK__InvUserTy__MenuI__6E565CE8] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[InvMenuMaster] ([MenuId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvUserTypeMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUserTypeMenuRightsMaster] ADD CONSTRAINT [FK__InvUserTy__UserT__6F4A8121] FOREIGN KEY ([UserTypeId]) REFERENCES [dbo].[InvUserTypeMaster] ([UserTypeId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.InvVendorInwardData
-- --------------------------------------------------
ALTER TABLE [dbo].[InvVendorInwardData] ADD CONSTRAINT [FK__InvVendor__FormI__703EA55A] FOREIGN KEY ([FormId]) REFERENCES [dbo].[FormMaster] ([FormId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.KYCInsertionDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[KYCInsertionDetails] ADD CONSTRAINT [FK__KYCInsers__KYCDo__41EDCAC5] FOREIGN KEY ([KYCDocId]) REFERENCES [dbo].[KYCMaster] ([KycDocId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.KYCInsertionDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[KYCInsertionDetails] ADD CONSTRAINT [FK__KYCInsert__Branc__7E02B4CC] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
ALTER TABLE [dbo].[NonKYCDocumentsArachive] ADD CONSTRAINT [FK__NonKYCDoc__Depar__28ED12D1] FOREIGN KEY ([DepartmentId]) REFERENCES [dbo].[DepartmentMaster] ([DepartmentId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
ALTER TABLE [dbo].[NonKYCDocumentsArachive] ADD CONSTRAINT [FK__NonKYCDoc__Stora__2AD55B43] FOREIGN KEY ([StorageLocId]) REFERENCES [dbo].[StorageLocationMaster] ([StorageLocId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
ALTER TABLE [dbo].[NonKYCDocumentsArachive] ADD CONSTRAINT [fk_BranchId] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
ALTER TABLE [dbo].[NonKYCDocumentsArachive] ADD CONSTRAINT [fk_NONKYC_TransId] FOREIGN KEY ([TransId]) REFERENCES [dbo].[NonKYCDocumentsDump] ([TransId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.RefileData
-- --------------------------------------------------
ALTER TABLE [dbo].[RefileData] ADD CONSTRAINT [FK__RefileDat__Branc__1209AD79] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.RetrievalDataDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[RetrievalDataDetails] ADD CONSTRAINT [FK__Retrieval__Branc__03BB8E22] FOREIGN KEY ([BranchId]) REFERENCES [dbo].[BranchMaster] ([Branchid])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[UserMenuRightsMaster] ADD CONSTRAINT [fk_MnuMst_UsrMaser] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[MenuMaster] ([MenuId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserTypeMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[UserTypeMenuRightsMaster] ADD CONSTRAINT [FK_UserMenuRightsMaster_MenuMaster] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[MenuMaster] ([MenuId])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.UserTypeMenuRightsMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[UserTypeMenuRightsMaster] ADD CONSTRAINT [fk_UserType_UserMenuMstr] FOREIGN KEY ([UsertypeId]) REFERENCES [dbo].[UserTypeMaster] ([UsertypeId])

GO

-- --------------------------------------------------
-- INDEX dbo.BillingMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__BillingMaster__60083D91] ON [dbo].[BillingMaster] ([BillDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.BoxMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BoxBarcode] ON [dbo].[BoxMaster] ([BoxBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.CourierTransactionMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_branchid] ON [dbo].[CourierTransactionMaster] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.CourierTransactionMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_CourierId] ON [dbo].[CourierTransactionMaster] ([CourierId])

GO

-- --------------------------------------------------
-- INDEX dbo.CourierTransactionMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_TransId] ON [dbo].[CourierTransactionMaster] ([TransId])

GO

-- --------------------------------------------------
-- INDEX dbo.DepartmentMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__DepartmentMaster__6DCC4D03] ON [dbo].[DepartmentMaster] ([DepartmentDesc])

GO

-- --------------------------------------------------
-- INDEX dbo.DocumentTypeMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__DocumentTypeMast__5165187F] ON [dbo].[DocumentTypeMaster] ([DocDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.FormMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__FormMast__4858DEC56225902D] ON [dbo].[FormMaster] ([FormDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.FormsLotMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__FormsLot__F803D24969C6B1F5] ON [dbo].[FormsLotMaster] ([LotNumber])

GO

-- --------------------------------------------------
-- INDEX dbo.FormTypeMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__FormType__81B78A2F7167D3BD] ON [dbo].[FormTypeMaster] ([FormName])

GO

-- --------------------------------------------------
-- INDEX dbo.InvBranchConsumption
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvBranchConsumption] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvBranchMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__InvBranchMaster__4B0D20AB] ON [dbo].[InvBranchMaster] ([BranchName])

GO

-- --------------------------------------------------
-- INDEX dbo.InvBranchStockMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[InvBranchStockMaster] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvBranchStockMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvBranchStockMaster] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[InvDispatchDetails] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_CourierId] ON [dbo].[InvDispatchDetails] ([CourierId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DispatchTrackNo] ON [dbo].[InvDispatchDetails] ([DispatchTrackNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_InvDispatchDetails] ON [dbo].[InvDispatchDetails] ([DispatchTrackNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_PodDate] ON [dbo].[InvDispatchDetails] ([PodDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[InvDispToBranchDetails] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvDispToBranchDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DispToBranchJcNo] ON [dbo].[InvDispToBranchDetails] ([DispToBranchJcNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToBranchDetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[InvDispToBranchHeader] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToBranchHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToBranchHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToCSODetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvDispToCSODetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToCSODetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DispToCSOJCNo] ON [dbo].[InvDispToCSODetails] ([DispToCSOJCNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToCSODetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToCSODetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToCSOHeader
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [DispToCSO_Unique_JC_Form] ON [dbo].[InvDispToCSOHeader] ([DispToCSOJCNo], [FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToCSOHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToCSOHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToKYCDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvDispToKYCDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToKYCDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DispToKycJCNo] ON [dbo].[InvDispToKYCDetails] ([DispToKycJCNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToKYCDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToKYCDetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToKYCHeader
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [DispToKyc_Unique_JC_Form] ON [dbo].[InvDispToKYCHeader] ([DispToKycJCNo], [FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvDispToKYCHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvDispToKYCHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvInwardRegisterDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvInwardRegisterDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvInwardRegisterDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvInwardRegisterDetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvInwardRegisterDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_InwardJCNo] ON [dbo].[InvInwardRegisterDetails] ([InwardJCNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvInwardRegisterHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvInwardRegisterHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvInwardRegisterHeader
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [Unique_JC_Form] ON [dbo].[InvInwardRegisterHeader] ([InwardJCNo], [FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvMenuMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__InvMenuM__019AA7EB2D7CBDC4] ON [dbo].[InvMenuMaster] ([MenuSerialNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvReceiptDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvReceiptDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvReceiptDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvReceiptDetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvReceiptDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_ReceiptJCNo] ON [dbo].[InvReceiptDetails] ([ReceiptJCNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvReceiptHeader
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [InvReceiptHeader_Unique_JC_Form] ON [dbo].[InvReceiptHeader] ([ReceiptJCNo], [FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvReceiptHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvReceiptHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvUsedFormsDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[InvUsedFormsDetails] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvUsedFormsDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[InvUsedFormsDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.InvUsedFormsDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvUsedFormsDetails] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvUsedFormsDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_UsedFormsJcNo] ON [dbo].[InvUsedFormsDetails] ([UsedFormsJcNo])

GO

-- --------------------------------------------------
-- INDEX dbo.InvUsedFormsHeader
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvUsedFormsHeader] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.InvVendorInwardData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormBarcode] ON [dbo].[InvVendorInwardData] ([FormBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.InvVendorInwardData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[InvVendorInwardData] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.KYCInsertionDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[KYCInsertionDetails] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.KYCInsertionDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FileBarcode] ON [dbo].[KYCInsertionDetails] ([FileBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.KYCInsertionDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_KYCDocId] ON [dbo].[KYCInsertionDetails] ([KYCDocId])

GO

-- --------------------------------------------------
-- INDEX dbo.LogBillingMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BillingId] ON [dbo].[LogBillingMaster] ([BillingId])

GO

-- --------------------------------------------------
-- INDEX dbo.LogInterChangeForms
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormBarcode] ON [dbo].[LogInterChangeForms] ([FormBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.LoginvBranchStockMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BranchId] ON [dbo].[LoginvBranchStockMaster] ([BranchId])

GO

-- --------------------------------------------------
-- INDEX dbo.LoginvBranchStockMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FormId] ON [dbo].[LoginvBranchStockMaster] ([FormId])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_AuthorisedId] ON [dbo].[NonKYCDocumentsArachive] ([AuthorisedId])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_BoxBarcode] ON [dbo].[NonKYCDocumentsArachive] ([BoxBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DeDate] ON [dbo].[NonKYCDocumentsArachive] ([DeDate])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DepartmentId] ON [dbo].[NonKYCDocumentsArachive] ([DepartmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FileBarcode] ON [dbo].[NonKYCDocumentsArachive] ([FileBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_MajorDecription] ON [dbo].[NonKYCDocumentsArachive] ([MinorDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_MinorDescription] ON [dbo].[NonKYCDocumentsArachive] ([MinorDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsDump
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_MajorDecription] ON [dbo].[NonKYCDocumentsDump] ([MinorDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsDump
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_MinorDescription] ON [dbo].[NonKYCDocumentsDump] ([MinorDescription])

GO

-- --------------------------------------------------
-- INDEX dbo.NonKYCDocumentsDump
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_UploadedDate] ON [dbo].[NonKYCDocumentsDump] ([UploadedDate])

GO

-- --------------------------------------------------
-- INDEX dbo.RefileData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_Filebarcode] ON [dbo].[RefileData] ([Filebarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.RefileData
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_refilejobcard] ON [dbo].[RefileData] ([RefileJobcard])

GO

-- --------------------------------------------------
-- INDEX dbo.RetrievalDataDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_DtprnDate] ON [dbo].[RetrievalDataDetails] ([DtprnDate])

GO

-- --------------------------------------------------
-- INDEX dbo.RetrievalDataDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_FileBarcode] ON [dbo].[RetrievalDataDetails] ([FileBarcode])

GO

-- --------------------------------------------------
-- INDEX dbo.RetrievalDataDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_WorkOrderNo] ON [dbo].[RetrievalDataDetails] ([WorkOrderNo])

GO

-- --------------------------------------------------
-- INDEX dbo.RetrievalTypeMaster
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UQ__RetrievalTypeMas__5535A963] ON [dbo].[RetrievalTypeMaster] ([RetDescription])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BillingMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BillingMaster] ADD CONSTRAINT [PK__BillingMaster__5F141958] PRIMARY KEY ([BillingId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BillingMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BillingMaster] ADD CONSTRAINT [UQ__BillingMaster__60083D91] UNIQUE ([BillDescription])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.BranchMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[BranchMaster] ADD CONSTRAINT [PK__BranchMaster__145C0A3F] PRIMARY KEY ([Branchid])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DeliveryTickets
-- --------------------------------------------------
ALTER TABLE [dbo].[DeliveryTickets] ADD CONSTRAINT [PK__DeliveryTickets__123EB7A3] PRIMARY KEY ([DeliveryTicket])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DepartmentMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[DepartmentMaster] ADD CONSTRAINT [PK__DepartmentMaster__6CD828CA] PRIMARY KEY ([DepartmentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DepartmentMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[DepartmentMaster] ADD CONSTRAINT [UQ__DepartmentMaster__6DCC4D03] UNIQUE ([DepartmentDesc])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DocumentTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[DocumentTypeMaster] ADD CONSTRAINT [PK__DocumentTypeMast__5070F446] PRIMARY KEY ([DocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.DocumentTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[DocumentTypeMaster] ADD CONSTRAINT [UQ__DocumentTypeMast__5165187F] UNIQUE ([DocDescription])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormMaster] ADD CONSTRAINT [PK__FormMast__FB05B7DD5F492382] PRIMARY KEY ([FormId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormMaster] ADD CONSTRAINT [UQ__FormMast__4858DEC56225902D] UNIQUE ([FormDescription])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormsLotMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormsLotMaster] ADD CONSTRAINT [PK__FormsLot__4160EFAD66EA454A] PRIMARY KEY ([LotId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormsLotMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormsLotMaster] ADD CONSTRAINT [UQ__FormsLot__F803D24969C6B1F5] UNIQUE ([LotNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormTypeMaster] ADD CONSTRAINT [PK__FormType__3177BBC36E8B6712] PRIMARY KEY ([FormTypeId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.FormTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[FormTypeMaster] ADD CONSTRAINT [UQ__FormType__81B78A2F7167D3BD] UNIQUE ([FormName])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvBranchMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchMaster] ADD CONSTRAINT [PK__InvBranchMaster__4A18FC72] PRIMARY KEY ([BranchId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvBranchMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvBranchMaster] ADD CONSTRAINT [UQ__InvBranchMaster__4B0D20AB] UNIQUE ([BranchName])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispatchDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispatchDetails] ADD CONSTRAINT [PK_InvDispatchDetails] PRIMARY KEY ([DispatchTrackNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToBranchDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToBranchDetails] ADD CONSTRAINT [PK__InvDispToBranchD__6D2D2E85] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToBranchHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToBranchHeader] ADD CONSTRAINT [PK__InvDispToBranchH__695C9DA1] PRIMARY KEY ([DispToBranchJcNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToCSODetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToCSODetails] ADD CONSTRAINT [PK__InvDispT__D470E277038683F8] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToCSOHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToCSOHeader] ADD CONSTRAINT [DispToCSO_Unique_JC_Form] UNIQUE ([DispToCSOJCNo], [FormId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToCSOHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToCSOHeader] ADD CONSTRAINT [PK__InvDispT__84748497075714DC] PRIMARY KEY ([DispToCSOJCNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToKYCDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToKYCDetails] ADD CONSTRAINT [PK__InvDispT__D470E2770C1BC9F9] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToKYCHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToKYCHeader] ADD CONSTRAINT [DispToKyc_Unique_JC_Form] UNIQUE ([DispToKycJCNo], [FormId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvDispToKYCHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvDispToKYCHeader] ADD CONSTRAINT [PK__InvDispT__7A7D3C010FEC5ADD] PRIMARY KEY ([DispToKycJCNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvInwardRegisterDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterDetails] ADD CONSTRAINT [PK__InvInwar__D470E2771D4655FB] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvInwardRegisterHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterHeader] ADD CONSTRAINT [PK__InvInwar__D705DA4125DB9BFC] PRIMARY KEY ([InwardJCNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvInwardRegisterHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvInwardRegisterHeader] ADD CONSTRAINT [Unique_JC_Form] UNIQUE ([InwardJCNo], [FormId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvMenuMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvMenuMaster] ADD CONSTRAINT [PK__InvMenuM__C99ED2302AA05119] PRIMARY KEY ([MenuId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvMenuMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvMenuMaster] ADD CONSTRAINT [UQ__InvMenuM__019AA7EB2D7CBDC4] UNIQUE ([MenuSerialNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvReceiptDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvReceiptDetails] ADD CONSTRAINT [PK__InvRecei__D470E277314D4EA8] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvReceiptHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvReceiptHeader] ADD CONSTRAINT [InvReceiptHeader_Unique_JC_Form] UNIQUE ([ReceiptJCNo], [FormId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvReceiptHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvReceiptHeader] ADD CONSTRAINT [PK__InvRecei__1808195C351DDF8C] PRIMARY KEY ([ReceiptJCNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvUsedFormsDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsDetails] ADD CONSTRAINT [PK__InvUsedF__D470E27739E294A9] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvUsedFormsHeader
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUsedFormsHeader] ADD CONSTRAINT [PK__InvUsedF__EA37269C3DB3258D] PRIMARY KEY ([UsedFormsJcNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvUserTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[InvUserTypeMaster] ADD CONSTRAINT [PK__InvUserT__40D2D8164183B671] PRIMARY KEY ([UserTypeId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvVendorDetails
-- --------------------------------------------------
ALTER TABLE [dbo].[InvVendorDetails] ADD CONSTRAINT [PK__InvVendo__FC8618F3473C8FC7] PRIMARY KEY ([VendorId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.InvVendorInwardData
-- --------------------------------------------------
ALTER TABLE [dbo].[InvVendorInwardData] ADD CONSTRAINT [PK__InvVendo__D470E2774B0D20AB] PRIMARY KEY ([FormBarcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.KYCMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[KYCMaster] ADD CONSTRAINT [PK__KYCMaster__395884C4] PRIMARY KEY ([KycDocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.MenuMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[MenuMaster] ADD CONSTRAINT [PK__MenuMaster__57DD0BE4] PRIMARY KEY ([MenuId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.NonKYCDocumentsDump
-- --------------------------------------------------
ALTER TABLE [dbo].[NonKYCDocumentsDump] ADD CONSTRAINT [PK__NonKYCDocumentsD__3DE82FB7] PRIMARY KEY ([TransId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.RetrievalTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[RetrievalTypeMaster] ADD CONSTRAINT [PK__RetrievalTypeMas__5441852A] PRIMARY KEY ([RetrievalId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.RetrievalTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[RetrievalTypeMaster] ADD CONSTRAINT [UQ__RetrievalTypeMas__5535A963] UNIQUE ([RetDescription])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.StorageLocationMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[StorageLocationMaster] ADD CONSTRAINT [PK__StorageLocationM__08B54D69] PRIMARY KEY ([StorageLocId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.UserTypeMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[UserTypeMaster] ADD CONSTRAINT [PK_UserTypeMaster] PRIMARY KEY ([UsertypeId])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AuthorisedPersonGetDetails
-- --------------------------------------------------
CREATE Procedure AuthorisedPersonGetDetails  
As      
Begin      
Set NoCount On      
      
Select a.AuthorisedId,a.PersonName,a.BranchId,b.BranchName,IsNull(a.Email,'') As 'EmailId',  
Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus', d.departmentdesc, d.Departmentid  
From AuthorisedPerson a,BranchMaster b, departmentmaster d Where a.BranchId=b.BranchId and a.departmentid = d.departmentid
Order By a.PersonName  
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AuthorisedPersonSaveDetails
-- --------------------------------------------------
CREATE Procedure AuthorisedPersonSaveDetails   
(  
 @AuthorisedId Varchar(10),@PersonName varchar(50),@EmailId Varchar(50),@BranchId varchar(10),@ActiveStatus bit,        
  @DepartmentId Varchar(10),@UserId Varchar(10),@Message varchar(250) output,@ControlNo int output   
)    
As          
Begin Try             
Set NoCount On  
-----------------------------------------------------------------------------------------------                
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)  
Select @Message='',@ControlNo=0  
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)  
-----------------------------------------------------------------------------------------------     
If @AuthorisedId=''  
Begin  
  
If Exists(Select PersonName From AuthorisedPerson Where PersonName=@PersonName)  
Begin  
 Set @Message='Authorised Person Name already exist...'  
 Return  
End  
  
Select @MaxNumber=Coalesce(Max(SubString(AuthorisedId,5,Len(AuthorisedId))),0)+1 From AuthorisedPerson                   
Set @AuthorisedId='AUTH' + RIGHT('000000' +  Cast(@MaxNumber As Varchar(10)),6)       
  
Insert Into AuthorisedPerson(AuthorisedId,PersonName,BranchId,UserId,DeDate,DeTime,ActiveStatus,Email,departmentid) Values  
(@AuthorisedId,@PersonName,@BranchId,@UserId,@DeDate,@DeTime,@ActiveStatus,@EmailId,@DepartmentId)  
  
End  
  
Else ---------------------------  
Begin  
  
If Exists(Select PersonName From AuthorisedPerson Where PersonName=@PersonName And AuthorisedId<>@AuthorisedId)  
Begin  
 Set @Message='Authorised Person Name already exist for another person...'  
 Return  
End  
  
Update AuthorisedPerson Set PersonName=@PersonName,BranchId=@BranchId,ActiveStatus=@ActiveStatus,Email=@EmailId,
departmentid=@departmentid Where AuthorisedId=@AuthorisedId  
  
End  
         
Set @Message='SUCCESS'                              
    
End Try                          
Begin Catch         
                                     
 DECLARE @ErSeverity INT,@ErState INT                                  
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                        
 Set @ControlNo=99                                
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                     
 RAISERROR (@Message,@ErSeverity,@ErState)   
                                            
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BranchMasterGetDetails
-- --------------------------------------------------
CREATE Procedure BranchMasterGetDetails
As    
Begin    
Set NoCount On    
    
Select a.BranchId,a.BranchName,a.Address,a.ContactPerson,
Case a.Status When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
From BranchMaster a 
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.BranchMasterSaveDetails
-- --------------------------------------------------
CREATE Procedure BranchMasterSaveDetails 
(
	@BranchId Varchar(10),@BranchName varchar(20),@Address Varchar(50),@ContactPerson varchar(20),@ActiveStatus bit,      
	@UserId Varchar(10),@Message varchar(250) output,@ControlNo int output 
)  
As        
Begin Try           
Set NoCount On
-----------------------------------------------------------------------------------------------              
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)
Select @Message='',@ControlNo=0
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)
-----------------------------------------------------------------------------------------------   
If @BranchId=''
Begin

If Exists(Select BranchName From BranchMaster Where BranchName=@BranchName)
Begin
	Set @Message='Branch Name already exist...'
	Return
End

Select @MaxNumber=Coalesce(Max(SubString(BranchId,4,Len(BranchId))),0)+1 From BranchMaster                 
Set @BranchId='LOC' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)     

Insert Into BranchMaster(Branchid,BranchName,Address,ContactPerson,UserId,DeDate,Detime,Status) Values
(@BranchId,@BranchName,@Address,@ContactPerson,@UserId,@DeDate,@DeTime,@ActiveStatus)

End

Else ---------------------------
Begin

If Exists(Select BranchName From BranchMaster Where BranchName=@BranchName And BranchId<>@BranchId)
Begin
	Set @Message='Branch Name already exist for another Branch...'
	Return
End

Update BranchMaster Set BranchName=@BranchName,Address=@Address,ContactPerson=@ContactPerson,
Status=@ActiveStatus Where BranchId=@BranchId

End
       
Set @Message='SUCCESS'                            
  
End Try                        
Begin Catch       
                                   
	DECLARE @ErSeverity INT,@ErState INT                                
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                      
	Set @ControlNo=99                              
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
	RAISERROR (@Message,@ErSeverity,@ErState) 
                                          
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DepartmentMasterGetDetails
-- --------------------------------------------------
CREATE Procedure DepartmentMasterGetDetails
As    
Begin    
Set NoCount On    
    
Select a.DepartmentId,a.DepartmentDesc,a.BranchId,b.BranchName,
Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
From DepartmentMaster a,BranchMaster b Where a.BranchId=b.BranchId Order By a.DepartmentDesc
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DepartmentMasterSaveDetails
-- --------------------------------------------------
CREATE Procedure DepartmentMasterSaveDetails   
(  
  @DepartmentId Varchar(10),@Department varchar(50),@BranchId varchar(10),@ActiveStatus bit,        
  @UserId Varchar(10),@Message varchar(250) output,@ControlNo int output   
)    
As          
Begin Try             
Set NoCount On  
-----------------------------------------------------------------------------------------------                
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)  
Select @Message='',@ControlNo=0  
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)  
-----------------------------------------------------------------------------------------------     
If @DepartmentId=''  
Begin  
  
If Exists(Select DepartmentDesc From DepartmentMaster Where DepartmentDesc=@Department)  
Begin  
 Set @Message='Department Name already exist...'  
 Return  
End  
  
Select @MaxNumber=Coalesce(Max(SubString(DepartmentId,5,Len(DepartmentId))),0)+1 From DepartmentMaster                   
Set @DepartmentId='DEPT' + RIGHT('000000' +  Cast(@MaxNumber As Varchar(10)),6)       
  
Insert Into DepartmentMaster(DepartmentId,DepartmentDesc,Branchid,UserId,DeDate,DeTime,ActiveStatus) Values  
(@DepartmentId,@Department,@BranchId,@UserId,@DeDate,@DeTime,@ActiveStatus)  
  
End  
  
Else ---------------------------  
Begin  
  
If Exists(Select DepartmentDesc From DepartmentMaster Where DepartmentDesc=@Department And DepartmentId<>@DepartmentId)  
Begin  
 Set @Message='Department Name already exist for another department...'  
 Return  
End  
  
Update DepartmentMaster Set DepartmentDesc=@Department,BranchId=@BranchId,ActiveStatus=@ActiveStatus
Where DepartmentId=@DepartmentId
  
End  
         
Set @Message='SUCCESS'                              
    
End Try                          
Begin Catch         
                                     
 DECLARE @ErSeverity INT,@ErState INT                                  
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                        
 Set @ControlNo=99                                
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                     
 RAISERROR (@Message,@ErSeverity,@ErState)   
                                            
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvBranchMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvBranchMasterGetDetails](@BranchName Varchar(50))
As    
Begin    
Set NoCount On    

Declare @Query Varchar(Max)

If @BranchName=''
Begin
	Select a.BranchId,a.BranchName,a.BranchAddress,a.ContactPerson,a.BranchTag,IsNull(a.EmpCode,'') As 'EmpCode',
	Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
	From InvBranchMaster a 
	Order By BranchName
End
-----------------
Else
Begin
	Set @Query='Select a.BranchId,a.BranchName,a.BranchAddress,a.ContactPerson,a.BranchTag,
	IsNull(a.EmpCode,'''') As ''EmpCode'',Case a.ActiveStatus When 0 Then ''No'' Else ''Yes'' End As ''ActiveStatus'' 
	From InvBranchMaster a Where a.BranchName Like ''%' + @BranchName + '%''
	Order By BranchName'
	
	Exec (@Query)
End
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvBranchMasterSaveDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvBranchMasterSaveDetails] 
(
	@BranchId Varchar(10),@BranchName varchar(50),@Address Varchar(250),@ContactPerson varchar(20),@BranchTag Char(10),
	@ActiveStatus bit,@EmpCode varchar(10),@EmpId Varchar(10),@Message varchar(250) output,@ControlNo int output 
)  
As        
Begin Try           
Set NoCount On
-----------------------------------------------------------------------------------------------              
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)
Select @Message='',@ControlNo=0
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)
-----------------------------------------------------------------------------------------------   
If @BranchId=''
Begin

If Exists(Select BranchName From InvBranchMaster Where BranchName=@BranchName)
Begin
	Set @Message='Branch Name already exists...'
	Return
End

Select @MaxNumber=Coalesce(Max(SubString(BranchId,4,Len(BranchId))),0)+1 From InvBranchMaster                 
Set @BranchId='BRN' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)     

Insert Into InvBranchMaster(BranchId,BranchName,BranchAddress,ContactPerson,BranchTag,ActiveStatus,EmpId,DeDate,DeTime,EmpCode) Values
(@BranchId,@BranchName,@Address,@ContactPerson,@BranchTag,@ActiveStatus,@EmpId,@DeDate,@DeTime,@EmpCode)

End

Else ---------------------------
Begin

If Exists(Select BranchName From InvBranchMaster Where BranchName=@BranchName And BranchId<>@BranchId)
Begin
	Set @Message='Branch Name already exists for another Branch...'
	Return
End

Update InvBranchMaster Set BranchName=@BranchName,BranchAddress=@Address,ContactPerson=@ContactPerson,
BranchTag=@BranchTag,ActiveStatus=@ActiveStatus,EmpCode=@EmpCode Where BranchId=@BranchId

End
       
Set @Message='SUCCESS'                            
  
End Try                        
Begin Catch       
                                   
	DECLARE @ErSeverity INT,@ErState INT                                
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                      
	Set @ControlNo=99                              
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
	RAISERROR (@Message,@ErSeverity,@ErState) 
                                          
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvGetLoginDetails
-- --------------------------------------------------

CREATE Procedure [dbo].[InvGetLoginDetails]           
(            
	@LoginId Varchar(8),@Password Varchar(8),@Message Varchar(250) Output           
)            
As            
Begin Try            
Set NoCount On           
        
Declare @EmpId Varchar(10),@UserName Varchar(50),@Email Varchar(50),@ActiveStatus Bit,@BranchId varchar(10),
@BranchName Varchar(50)
        
Set @Message=''        
           
If Not Exists(Select EmpId From InvEmployeeMaster Where LoginId=@LoginId And EmpPassword=@Password)            
Begin        
	Set @Message='Invalid UserName/Password...'        
	Return        
End        
      
Select @ActiveStatus=em.ActiveStatus,@EmpId=em.EmpId,@UserName=em.FirstName,@Email=IsNull(em.EmailId,''),
@Loginid=em.LoginId,@Branchid=em.BranchId,@BranchName=bm.BranchName 
From InvEmployeeMaster em,InvBranchMaster bm 
Where em.BranchId=bm.BranchId And em.LoginId=@LoginId And em.EmpPassword=@Password      
      
If @ActiveStatus=0      
Begin        
	Set @Message='In-Active User...'        
	Return        
End        
      
If @Email=''      
Begin        
	Set @Message='Email has not been set for user..Contact system administrator...'        
	Return        
End  
      
Set @Message='SUCCESS'        
Select @EmpId As 'EmpId',@UserName As 'UserName',@Email As 'Email',@Loginid As 'LoginId',@BranchId As BranchId,
@BranchName As 'BranchName'
        
End Try        
Begin Catch          
	Set @Message='Error occured at database level:' + Replace(ERROR_MESSAGE(),'''','`')                
	Return             
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvGetLoginMenu
-- --------------------------------------------------
CREATE Procedure [dbo].[InvGetLoginMenu](@EmpId Varchar(10))           
As          
Begin  
    
Select 'MAIN' As 'MenuGroup','MENUS' As 'MenuCaption','MNU0000000' As MenuId,
'#' As 'NavigateURL',0 As 'MenuSerialNo'
Union All
Select Upper(IsNull(MenuGroup,'MAIN')) As 'MenuGroup',MenuCaption As 'MenuCaption',a.MenuId,
NavigateURL,MenuSerialNo
From InvMenuMaster a,InvEmpMenuRightsMaster b Where a.MenuId=b.MenuId And b.EmpId=@EmpId Order By MenuSerialNo  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvGetUserTypes
-- --------------------------------------------------
CREATE Procedure [dbo].[InvGetUserTypes](@UserTypeId Varchar(5))       
As      
Begin  

If Upper(@UserTypeId)='ALL'
Begin
	Select UserTypeId,Description As 'UserType' From InvUserTypeMaster Order By UserType
End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvGetUserTypeWiseMenus
-- --------------------------------------------------
 
CREATE Procedure [dbo].[InvGetUserTypeWiseMenus](@UserTypeId Varchar(5),@Mode Varchar(5))       
As      
Begin  

If Upper(@Mode)='NEW'
Begin

	Select Upper(MenuGroup) As 'ParentId',MenuId,MenuCaption 
	From InvMenuMaster Order By MenuSerialNo

End

Else ------------------------------------------------
Begin

	Select Upper(MenuGroup) As 'ParentId',mm.MenuId,mm.MenuCaption,
	(Case When IsNull(rm.UserTypeId,'')='' Then 'False' Else 'True' End) As 'IsChecked'
	From InvMenuMaster mm
	Left Outer Join InvUserTypeMenuRightsMaster rm On rm.MenuId=mm.MenuId And rm.UserTypeId=@UserTypeId
	Order By mm.MenuSerialNo

End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvGetUserWiseMenus
-- --------------------------------------------------
CREATE Procedure [dbo].[InvGetUserWiseMenus](@LoginId Varchar(10),@SessionLoginId varchar(10),@EmpId Varchar(10) Output,@Message Varchar(250) Output)         
As        
Begin    
  
Set @Message=''  

If @LoginId=@SessionLoginId
Begin  
 Set @Message='Login Id is in use.'  
 Return  
End    

If Not Exists(Select LoginId From InvEmployeeMaster Where LoginId=@LoginId)  
Begin  
 Set @Message='Login Id does not exist'  
 Return  
End  
  
Select @EmpId=EmpId From InvEmployeeMaster Where LoginId=@LoginId  
  
Set @Message='SUCCESS'  
Select Upper(MenuGroup) As 'ParentId',mm.MenuId,mm.MenuCaption,  
(Case When IsNull(rm.EmpId,'')='' Then 'False' Else 'True' End) As 'IsChecked'  
From InvMenuMaster mm  
Left Outer Join InvEmployeeMaster um On um.LoginId=@LoginId  
Left Outer Join InvEmpMenuRightsMaster rm On rm.MenuId=mm.MenuId And rm.EmpId=um.EmpId  
  
Order By mm.MenuSerialNo  
  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvLoginGetPassword
-- --------------------------------------------------
CREATE Procedure [dbo].[InvLoginGetPassword]    
(        
	@UserName Varchar(30),@Message Varchar(250) Output       
)        
As        
Begin Try        
Set NoCount On       
    
Declare @Email Varchar(150),@Password Varchar(15),@MailDesc Varchar(Max),@DummyPassword Varchar(10)    
    
Set @Message=''    
       
If Not Exists(Select LoginId From InvEmployeeMaster Where LoginId=@UserName)        
Begin    
	 Set @Message='Invalid User Name...'    
	 Return    
End    
    
Select @Password=EmpPassword,@Email=IsNull(EmailId,'') From InvEmployeeMaster Where LoginId=@UserName   
    
If @Email=''    
Begin    
	 Set @Message='Email Id is not updated...'    
	 Return    
End     
    
Set @DummyPassword='##**##**##'    
    
Set @MailDesc='<html><body><table border=1 width=100%>' +    
'<tr><td><strong>UserName</strong></td><td><strong>' + Upper(@UserName) + '</strong></td></tr>' +    
'<tr><td><strong>Password</strong></td><td><strong>' + @DummyPassword + '</strong></td></tr>' +    
'</table></body></html>'    
   
Select @Email As 'Email',@MailDesc As 'MailDesc',@Password As 'Password'    
    
Set @Message='SUCCESS'    
    
End Try    
Begin Catch    

	Set @Message='Error occured at database level:' + Replace(ERROR_MESSAGE(),'''','`')              
	Return    
    
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMasterReportsList
-- --------------------------------------------------

CREATE Procedure InvMasterReportsList
As
Begin
Set NoCount On

Declare @TblReportType Table(ReportType Varchar(50),ReportDesc Varchar(100))

Insert Into @TblReportType Values('BranchMaster','Branch Master')
Insert Into @TblReportType Values('UserTypeMaster','User Type Master')
Insert Into @TblReportType Values('UserMaster','User Master')
Insert Into @TblReportType Values('LotMaster','Lot Master')
Insert Into @TblReportType Values('FormTypeMaster','Form Type Master')
Insert Into @TblReportType Values('FormMaster','Form Master')
Insert Into @TblReportType Values('CourierMaster','Courier Master')
Insert Into @TblReportType Values('BillingMaster','Billing Master')
Insert Into @TblReportType Values('BranchStockMaster','Branch Stock Master')
Insert Into @TblReportType Values('CourierRateMaster','Courier Rate Master')
Insert Into @TblReportType Values('UserTypeWiseRights','User Type Wise Rights')
Insert Into @TblReportType Values('UserWiseRights','User Wise Rights')
Insert Into @TblReportType Values('UploadedVendorInwardData','Uploaded Vendor Inward Data For The Day')

Select * From @TblReportType

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstBillingMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstBillingMaster] (@BillDescription varchar(250),@Rate numeric(9,2),@DMLAction char(3),
@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output, @Billingid varchar(10) output )
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 

if @DMLAction ='ADD'
begin
	if  exists(SELECT * from BillingMaster where BillDescription =@BillDescription)
	begin
		Set @Message='Billing description has already exists..'						
		return
	end

	Select @BillingId='BIL' +  RIGHT('0000000' +  Cast(coalesce(max(substring(BillingId,4,len(BillingId))),0) + 1 As Varchar(10)),7)  
	From BillingMaster  

	insert into BillingMaster(BillingId,BillDescription,Rate,ActiveStatus,EmpId,DeDate,DeTime) 
	values (@BillingId,UPPER(@BillDescription),@Rate,1,@EmpId,@DeDate,@DeTime)  
  
end
if @DMLAction='EDT'
Begin
	insert into LogBillingMaster(BillingId,OldBillDescription,NewBillDescription,OldRate,NewRate,OldEmpId,NewEmpId,
	OldDeDate,NewDeDate,oldDeTime,NewDeTime)select BillingId,BillDescription,@BillDescription,Rate,@rate,EmpId,@EmpId,DeDate,@DeDate,
	DeTime,@DeTime from BillingMaster where billingid =@BillingId
	
	update BillingMaster set BillDescription=@BillDescription,Rate=@Rate where billingid =@BillingId
end


Set @Message='SUCCESS'            
SET @Billingid=@BillingId  
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstBillingMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstBillingMasterGetDetails]
As    
Begin    
Set NoCount On  

	Select BillingId,BillDescription,Rate
	From BillingMaster
-----------------    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstBranchStockMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstBranchStockMaster] (@BranchId varchar(10),@FormId varchar(10),@MinStock bigint, @ActiveStatus bit ,@DMLAction char(3),
@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 

if @DMLAction ='ADD'
begin
	if  exists(SELECT * from invBranchStockMaster where branchid =@BranchId and formId =@FormId)
	begin
		Set @Message='Minimum stock has already added to the selected branch and form.'						
		return
	end

	insert into invBranchStockMaster(BranchId,FormId,MinStock,ActiveStatus,EmpId,DeDate,DeTime) 
	values (@BranchId,@FormId,@MinStock,1,@EmpId,@DeDate,@DeTime)  
  
end
if @DMLAction='EDT'
Begin
	if not exists(SELECT * from invBranchStockMaster where branchid =@BranchId and formId =@FormId)
	begin
		Set @Message='Minimum stock has not added to the selected branch and form.'						
		return
	end
	
	Insert into LogInvBranchStockMaster(BranchId,FormId,OldMinStock,NewMinStock,OldEmpId,NewEmpId,OldDeDate,
    NewDeDate,OldDeTime,NewDeTime)select BranchId,FormId,MinStock,@MinStock,EmpId,@EmpId,DeDate,
    @DeDate,DeTime,@DeTime from InvBranchStockMaster where BranchId =@BranchId and FormId=@FormId  

	Update invBranchStockMaster set MinStock=@MinStock where BranchId=@BranchId and formId=@FormId
end

Set @Message='SUCCESS'            

End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstBranchStockMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstBranchStockMasterGetDetails](@BranchId Varchar(10))
As      
Begin      
Set NoCount On    
  Select b.FormDescription,a.MinStock,a.FormId
  from InvBranchStockMaster a,FormMaster b
  Where a.FormId=b.FormId and a.BranchId=@BranchId and a.ActiveStatus=1
-----------------      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstChangePassword
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstChangePassword]           
(            
	@LoginId Varchar(8),@SessionLoginId varchar(8),@OldPassword Varchar(8),@NewPassword Varchar(8),@ConfirmPassword Varchar(8),
    @Message Varchar(250) Output           
)            
As            
Begin Try            
Set NoCount On   
       
Set @Message=''        
           
If @LoginId <> @SessionLoginId            
Begin        
	Set @Message='Only logged in user can change his/her password...'        
	Return        
End        

If Not Exists(Select EmpPassword From InvEmployeeMaster Where LoginId=@LoginId and EmpPassword=@OldPassword)            
Begin        
	Set @Message='Entered password does not match with the Old Password...'        
	Return        
End          

If @NewPassword <> @ConfirmPassword
Begin
	Set @Message='Confirm password should be same as New password...'        
	Return  
End

Update InvEmployeeMaster set EmpPassword=@NewPassword Where LoginId=@LoginId

Set @Message='SUCCESS'        
        
End Try        
Begin Catch          
	Set @Message='Error occured at database level:' + Replace(ERROR_MESSAGE(),'''','`')                
	Return             
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstCourierMaster
-- --------------------------------------------------

CREATE proc [dbo].[InvMstCourierMaster] ( @CourierName varchar(50),@ActiveStatus Int,@EmpId varchar(10),@CourierId Varchar(10) output,
@ContactPerson varchar(50), @TelephoneNo varchar(30), @Message varchar(250) output, @ControlNo int output )
As
Begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime
Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
----------------------------------------------------------------------
If @CourierId=''
Begin
	If  Exists(SELECT * from CourierMaster where CourierName=@CourierName)
	Begin
		Set @Message='Courier Name already exists..'						
		Return
	End

	Select @CourierId='COU' +  RIGHT('0000000' +  Cast(coalesce(max(substring(CourierId,4,len(CourierId))),0) + 1 As Varchar(10)),7)  
	From CourierMaster  

	Insert into CourierMaster(CourierId,CourierName,ActiveStatus,EmpId,DeDate,DeTime,ContactPerson,TelephoneNo) 
	values (@CourierId,@CourierName,1,@EmpId,@DeDate,@DeTime,@ContactPerson,@TelephoneNo)  
End

Else
Begin
	If  Exists(SELECT * from CourierMaster where CourierName=@CourierName and CourierId<>@CourierId)
	Begin
		Set @Message='Courier Name already exists..'						
		Return
	End

	Update CourierMaster set CourierName=@CourierName,ActiveStatus=@ActiveStatus,ContactPerson=@ContactPerson,
	TelephoneNo=@TelephoneNo where CourierId=@CourierId
End	
  

Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstCourierMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstCourierMasterGetDetails](@CourierName Varchar(50))  
As      
Begin      
Set NoCount On      
  
Declare @Query Varchar(Max)  

If @CourierName=''  
Begin  
	Select a.CourierId,a.CourierName,a.EmpId,a.DeDate,a.DeTime,  
	Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus',a.ContactPerson,a.TelephoneNo   
	From CourierMaster a  
End  
-----------------  
Else  
	Begin  
	Set @Query='Select a.CourierId,a.CourierName,a.EmpId,a.DeDate,a.DeTime, 
	Case a.ActiveStatus When 0 Then ''No'' Else ''Yes'' End As ''ActiveStatus'',a.ContactPerson,a.TelephoneNo     
	From CourierMaster a Where a.CourierName Like ''%' + @CourierName + '%'''  

	Exec (@Query)  
End  
      
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstCourierTransMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstCourierTransMaster] ( @CourierId varchar(10),@BranchId varchar(10), @WeightFrom numeric(9,3),@WeightTo numeric(9,3),
@Rate numeric(9,2),@EmpId varchar(10),@TransId Varchar(10),@DMLMode char(10),@Message varchar(250) output, @ControlNo int output )
as
begin
Begin Try              
Set Nocount on				
Declare @DeDate Datetime
Declare @DeTime Datetime
Declare @MaxNo numeric(9,2)
Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
-------------------------
If @DMLMode='ADD'
Begin

    if @WeightTo < @WeightFrom
	begin
		Set @Message='Weight To cannot be less than Weight From...'  
		return  
	end	


if exists(SELECT  * from CourierTransactionMaster where BranchId=@BranchId and CourierId=@CourierId and ActiveStatus=1 and
((@Weightfrom between weightfrom and weightto) OR (@WeightTo between weightfrom and weightto) OR 
(weightfrom between @Weightfrom and @WeightTo)))
	begin
		Set @Message='Entered range has already found in one of the range...' 
		return  
	end
	
	Select @TransId='TRN' +  RIGHT('0000000' +  Cast(coalesce(max(substring(TransId,4,len(TransId))),0) + 1 As Varchar(10)),7)  
	From CourierTransactionMaster

	insert into CourierTransactionMaster(CourierId,BranchId,WeightFrom,WeightTo,Rate,ActiveStatus,EmpId,DeDate,DeTime,TransId)  
	values (@CourierId,@BranchId,@WeightFrom,@WeightTo,@Rate,1,@EmpId,@DeDate,@DeTime,@TransId)  
End
----------------------------------------------------
If @DMLMode='EDIT'
Begin
	if @WeightTo < @WeightFrom
	begin
		Set @Message='Weight To cannot be less than Weight From...'  
		return  
	end	
	if exists(SELECT  * from CourierTransactionMaster where BranchId=@BranchId and CourierId=@CourierId and 
	ActiveStatus=1 and 
	((@Weightfrom between weightfrom and weightto) OR (@WeightTo between weightfrom and weightto) OR 
	(weightfrom between @Weightfrom and @WeightTo)) AND TransId<>@TransId)
	begin
		Set @Message='Entered range has already found in one of the range...' 
		return  
	end

	Update CourierTransactionMaster Set WeightFrom=@WeightFrom, WeightTo=@WeightTo, Rate=@Rate
	Where BranchId=@BranchId and CourierId=@CourierId and TransId=@TransId
End
----------------------------------------------------
If @DMLMode='DEACTIVATE'
Begin
	Update CourierTransactionMaster set ActiveStatus=0 Where BranchId=@BranchId and CourierId=@CourierId
End
-----------------------------------------------------
Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstCourierTransMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstCourierTransMasterGetDetails](@CourierId Varchar(10),@BranchId Varchar(10))
As    
Begin    
Set NoCount On    

Select a.TransId,a.WeightFrom,a.WeightTo,a.Rate,
Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus'   
From CourierTransactionMaster a
Where a.CourierId=@CourierId and a.BranchId=@BranchId and a.ActiveStatus=1 Order By a.WeightFrom,a.WeightTo
-----------------    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstFormMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstFormMaster] ( @FormName varchar(50),@ActiveStatus Int,@FormTypeId varchar(10), @EmpId varchar(10),@FormId Varchar(10),@Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime
Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
--------------------------------------------------------------------
If @FormId=''
Begin
	If  Exists(SELECT * from FormMaster where FormDescription=@FormName)
	Begin
		Set @Message='Form Description already exists..'						
		Return
	End

	Select @FormId='FRM' +  RIGHT('0000000' +  Cast(coalesce(max(substring(FormId,4,len(FormId))),0) + 1 As Varchar(10)),7)  
	From FormMaster  

	Insert into FormMaster(FormId,FormDescription,FormTypeId,ActiveStatus,EmpId,DeDate,DeTime)  
	values (@FormId,@FormName,@FormTypeId,1,@EmpId,@DeDate,@DeTime)  
End

Else
Begin
	If  Exists(SELECT * from FormMaster where FormDescription=@FormName and FormId<>@FormId)
	Begin
		Set @Message='Form Description already exists..'						
		Return
	End

	Update FormMaster set FormDescription=@FormName,ActiveStatus=@ActiveStatus where FormId=@FormId
End

Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstFormMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstFormMasterGetDetails](@FormName Varchar(50))
As    
Begin    
Set NoCount On    

Declare @Query Varchar(Max)

If @FormName=''
Begin
	Select a.FormId,a.FormDescription,a.EmpId,a.DeDate,a.DeTime,b.FormTypeId,b.FormName As 'FormTypeName',
	Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
	From FormMaster a, FormTypeMaster b
	Where a.FormTypeId=b.FormTypeId
End
-----------------
Else
Begin
	Set @Query='Select a.FormId,a.FormDescription,a.EmpId,a.DeDate,a.DeTime,b.FormTypeId,b.FormName As FormTypeName,
	Case a.ActiveStatus When 0 Then ''No'' Else ''Yes'' End As ''ActiveStatus''
	From FormMaster a , FormTypeMaster b
	Where a.FormTypeId=b.FormTypeId and a.FormDescription Like ''%' + @FormName + '%'''
	
	Exec (@Query)
End
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstFormTypeMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstFormTypeMaster] (@FormName varchar(50),@ActiveStatus Int,@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output, @FtypeId
varchar(10) output )
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0 
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
------------------------------------------------------------------
If @FtypeId=''
Begin
	If  Exists(SELECT * from FormTypeMaster where FormName=@FormName)
	begin
		Set @Message='Form Description already exists..'						
		return
	end

	Select @FtypeId='FRMTYPE' +  RIGHT('000' +  Cast(coalesce(max(substring(FormTypeId,8,len(FormTypeId))),0) + 1 As Varchar(10)),3)  
	From FormTypeMaster  

	insert into FormTypeMaster(FormTypeId,FormName,ActiveStatus,EmpId,DeDate,DeTime)  values (@FtypeId,@FormName,1,@EmpId,@DeDate,@DeTime)   
End

Else
Begin
	If  Exists(SELECT * from FormTypeMaster where FormName=@FormName and FormTypeId<>@FtypeId)
	begin
		Set @Message='Form Description already exists..'						
		return
	end

	Update FormTypeMaster set FormName=@FormName,ActiveStatus=@ActiveStatus where FormTypeId=@FtypeId
End	

Set @Message='SUCCESS'            

End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstFormTypeMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstFormTypeMasterGetDetails](@FormName Varchar(50))
As    
Begin    
Set NoCount On    

Declare @Query Varchar(Max)

If @FormName=''
Begin
	Select a.FormTypeId,a.FormName,a.EmpId,a.DeDate,a.DeTime,
	Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
	From FormTypeMaster a
End
-----------------
Else
Begin
	Set @Query='Select a.FormTypeId,a.FormName,a.EmpId,a.DeDate,a.DeTime,
	Case a.ActiveStatus When 0 Then ''No'' Else ''Yes'' End As ''ActiveStatus''
	From FormTypeMaster a Where a.FormName Like ''%' + @FormName + '%'''
	
	Exec (@Query)
End
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstLotMaster
-- --------------------------------------------------
CREATE proc [dbo].[InvMstLotMaster] (@LotId VARCHAR(10), @LotNumber varchar(10),@Rate numeric(9,2), @EmpId varchar(10),
@DMLAction char(5),@ActiveStatus int,@Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
--------------------------------------------------------------------
If @DMLAction='ADD'
	Begin
		if @LotNumber=''
		begin
			Set @Message='Lot Number cannot be blank..'				
			Return				
		end

		if @Rate=0
		begin
			Set @Message='Rate cannot be blank..'				
			Return				
		end

		If  Exists(SELECT * from FormsLotMaster where LotNumber=@LotNumber)
		Begin
			Set @Message='Lot Number already exists..'						
			Return
		End

		Select @LotId='LOT' +  RIGHT('0000000' +  Cast(coalesce(max(substring(LotId,4,len(LotId))),0) + 1 As Varchar(10)),7)  
		From FormsLotMaster  

		Insert into FormsLotMaster(LotId,LotNumber,Rate,ActiveStatus,EmpId,DeDate,DeTime)  
		values (@LotId,@LotNumber,@Rate,1,@EmpId,@DeDate,@DeTime)  
	End

If @DMLAction='EDIT'
	Begin
		if @LotId=''
		begin
			Set @Message='Lot Id cannot be blank'						
			Return
		end
		
		If  Exists(SELECT * from FormsLotMaster where LotNumber=@LotNumber And LotId<>@LotId)
		Begin
			Set @Message='Lot Number already exists..'						
			Return
		End

		Update FormsLotMaster Set LotNumber=@LotNumber,Rate=@Rate,ActiveStatus=@ActiveStatus where LotId=@LotId
	End

Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvMstLotMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvMstLotMasterGetDetails](@LotNumber Varchar(10))
As    
Begin    
Set NoCount On    

Declare @Query Varchar(Max)

If @LotNumber=''
Begin
	Select LotId,LotNumber,Rate,Case ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus' 
	From FormsLotMaster
End
-----------------
Else
Begin
	Set @Query='Select LotId,LotNumber,Rate,Case ActiveStatus When 0 Then ''No'' Else ''Yes'' End As ''ActiveStatus'' 
	From FormsLotMaster Where LotNumber Like ''%' + @LotNumber + '%'''
	
	Exec (@Query)
End
    
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoBillingAllServices
-- --------------------------------------------------
CREATE proc [dbo].[InvRepoBillingAllServices] (@FromDate datetime, @ToDate Datetime, @BranchId varchar(10),@Message varchar(250) output, @ControlNo int output)  
as  
begin  
Begin Try                
Set Nocount on             
Declare @Services varchar(250), @PrintFrankFromsAmt numeric(9,2) ,@PrintFrankFromsCount bigint    
DeClare @CourierId varchar(10),@Unit char(5),@Weight numeric(9,3),@TotalRate numeric(9,2)  
Declare @Rate numeric(9,2),@SerRate numeric(9,2),@Branch varchar(50), @TotalWeight numeric(9,3)  
Declare @FormCountPrinting bigint, @RatePrinting numeric(9,2),@TotalRatePrinting numeric(9,2), @TotalFormCountPrinting bigint
  
Set @ControlNo=0          
Set @Message=''   
------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    
 
SET @Rate=0.00  
SET @TotalRate=0.00  
SET @SerRate=0.00  
SET @PrintFrankFromsCount=0  
SET @PrintFrankFromsAmt=0.00  
set @TotalWeight=0.000  
set @FormCountPrinting=0
set @TotalFormCountPrinting=0
set @RatePrinting=0.00  
set @TotalRatePrinting=0.00 

  
Create table #TempBilling(Branch varchar(50), Services varchar(250), Qty numeric(9,3), Rate numeric(9,2),  Unit char(5), TotalAmount numeric(9,2))  
  
-- PRINTING CHARGES  
select @PrintFrankFromsCount= isnull(sum(formcount),0) from InvDispToBranchHeader where branchid =@BranchId and createddate   
between @FromDate and @ToDate  
--select @Services =billdescription,@Unit=Unit,@SerRate=Rate from billingmaster where billingid ='BIL0000001'  
--set @PrintFrankFromsAmt= @PrintFrankFromsCount*@SerRate  
select @Branch=upper(branchname) from InvBranchMaster where branchid =@BranchId  
--insert into #TempBilling values(@Branch,@Services,@PrintFrankFromsCount,@SerRate,@Unit,@PrintFrankFromsAmt)  


Declare PrintCharges cursor local for SELECT count(b.formbarcode) as TotalCount, (count(b.formbarcode)*a.rate) as TotalRate from 
FORMSLOTMASTER a,InvInwardRegisterDetails b where a.lotid = b.lotid and b.dedate >=@FromDate and b.dedate <=@ToDate
group by a.lotnumber, a.rate

open PrintCharges  
  
fetch next from PrintCharges into @FormCountPrinting,@RatePrinting  
WHILE @@FETCH_STATUS =0  
begin  
	set @TotalFormCountPrinting=@TotalFormCountPrinting+@FormCountPrinting
	set @TotalRatePrinting=@TotalRatePrinting+@RatePrinting

	fetch next from PrintCharges into @FormCountPrinting,@RatePrinting  
  
end  
  
Close PrintCharges  
Deallocate PrintCharges  
  
select @Services =billdescription,@Unit=Unit from billingmaster where billingid ='BIL0000001'  
insert into #TempBilling values(@Branch,@Services,@TotalFormCountPrinting,0,@Unit,@TotalRatePrinting)  

  
-- FRANKING CHARGES  
SET @SerRate=0.00  
SET @PrintFrankFromsAmt=0.00  
  
select @Services =billdescription,@Unit=Unit,@SerRate=Rate from billingmaster where billingid ='BIL0000003'  
set @PrintFrankFromsAmt= @PrintFrankFromsCount*@SerRate  
insert into #TempBilling values(@Branch,@Services,@PrintFrankFromsCount,@SerRate,@Unit,@PrintFrankFromsAmt)  
  
-- DISPATCH CHARGES  
Declare DisptachDetails cursor for select courierId,weight from InvDispatchDetails where branchid =@BranchId and dedate   
  between @FromDate and @ToDate And ActiveStatus=1
open DisptachDetails  
  
fetch next from DisptachDetails into @CourierId,@Weight  
WHILE @@FETCH_STATUS =0  
begin  
 set @rate=0.00  
 SELECT @Rate=rate from couriertransactionmaster where branchid =@BranchId and courierid =@CourierId and   
 @Weight >= Weightfrom and @Weight <= weightTo and activestatus =1  
  
 SET @TotalRate=@TotalRate+@rate  
 set @TotalWeight=@TotalWeight+@Weight        
 fetch next from DisptachDetails into @CourierId,@Weight  
  
end  
  
Close DisptachDetails  
Deallocate DisptachDetails  
  
select @Services =billdescription,@Unit=Unit from billingmaster where billingid ='BIL0000002'  
insert into #TempBilling values(@Branch,@Services,@TotalWeight,0,@Unit,@TotalRate)  
	  
	select * from #TempBilling  
Set @Message='SUCCESS'              
End Try                
          
Begin Catch                
          
 DECLARE @ErSeverity INT,@ErState INT            
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
 Set @ControlNo=99              
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
 RAISERROR (@Message,@ErSeverity,@ErState)                     
            
End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoBillingInDetails
-- --------------------------------------------------


CREATE proc InvRepoBillingInDetails (@FromDate datetime, @ToDate Datetime, @BranchId varchar(10),
@BillingId varchar(10), @Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           

Declare @DispatchTrackNo varchar(10),@CourierName varchar(50),@PodNo varchar(100)
Declare @PodDate varchar(10),@BranchName varchar(50),@Weight numeric(9,3),@DeDate varchar(10)
Declare @Rate numeric(9,2),	@WeightFrom numeric(9,3),@WeightTo numeric(9,3)
Declare @courierid varchar(10)

Set @ControlNo=0        
Set @Message='' 

------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------   

if @BillingId ='BIL0000001'-- PRINTING CHARGES
	begin

		select a.DispToBranchJCNo, br.BranchName, f.Formdescription, a.FormCount, convert(varchar,a.CreatedDate,103)'Sent Date',a.DispatchTrackNo
		from InvDispToBranchHeader a, Invbranchmaster br, FormMaster f where a.branchid = br.branchid and
		a.formId = f.FormId and a.branchid =@BranchId and createddate between @FromDate and @ToDate order
		by a.DispToBranchJCNo

	end

if @BillingId ='BIL0000003'-- FRANKING CHARGES
	Begin
		select  b.DispToBranchJCNo, br.BranchName,convert(varchar,b.dedate,103)'Sent Date',
		isnull(count(a.formbarcode),0) from InvReceiptDetails a, InvDispToBranchDetails b, Invbranchmaster br where a.FormBarcode =b.FormBarcode and
		b.branchid = br.branchid 		and a.DeDate between '2016-01-01' and '2016-06-01'
		group by b.DispToBranchJCNo, br.BranchName,convert(varchar,b.dedate,103) order by  br.BranchName

	end

if @BillingId ='BIL0000002'-- DISPATCH CHARGES
	begin

		Create table #TempBilling(DispatchTrackNo varchar(10), CourierName varchar(50),PodNo varchar(100),
		PodDate varchar(10),BranchName varchar(50),Weight numeric(9,3),SentDate varchar(10), CourierRate numeric(9,2),
		WeightRangeFrom numeric(9,3),WeightRangeTo numeric(9,3))


		Declare DisptachInDetailsNew cursor for select a.DispatchTrackNo,a.courierid, c.CourierName,a.PodNo,convert(varchar,a.PodDate,103)
		'Pod Date', br.BranchName, a.Weight,convert(varchar,a.DeDate,103)'Sent Date' from InvDispatchDetails a, 
		CourierMaster c, Invbranchmaster br where a.branchid = br.branchid and a.courierid =c.CourierId and a.DeDate 
		between @FromDate and @ToDate And a.BranchId=@BranchId And a.ActiveStatus=1 order by a.DispatchTrackNo

		open DisptachInDetailsNew

		fetch next from DisptachInDetailsNew into @DispatchTrackNo,@courierid,@CourierName,@PodNo,@PodDate,@BranchName,@Weight,
		@DeDate

		WHILE @@FETCH_STATUS =0
		begin
			SELECT @Rate=rate,@Weightfrom=Weightfrom,@weightTo=weightTo from couriertransactionmaster where 
			branchid =@BranchId and courierid =@CourierId and @Weight >= Weightfrom and @Weight <= weightTo and 
			activestatus =1
			
			insert into #TempBilling values(@DispatchTrackNo,@CourierName,@PodNo,@PodDate,@BranchName,@Weight,@DeDate,
			@Rate,@Weightfrom,@weightTo)

			fetch next from DisptachInDetailsNew into @DispatchTrackNo,@courierid,@CourierName,@PodNo,@PodDate,@BranchName,
			@Weight,@DeDate

		end

		Close DisptachInDetailsNew
		Deallocate DisptachInDetailsNew
		select * from #TempBilling
	end


Set @Message='SUCCESS'            
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoBillingSingleService
-- --------------------------------------------------

CREATE proc InvRepoBillingSingleService (@FromDate datetime, @ToDate Datetime, @BranchId varchar(10),
@BillingId varchar(10), @Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           
Declare @Services varchar(250), @PrintFrankFromsAmt numeric(9,2) ,@PrintFrankFromsCount bigint  
DeClare @CourierId varchar(10),@Unit char(5),@Weight numeric(9,3),@TotalRate numeric(9,2)
Declare @Rate numeric(9,2),@SerRate numeric(9,2),@Branch varchar(50), @TotalWeight numeric(9,3)

Set @ControlNo=0        
Set @Message='' 

------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    
SET @Rate=0.00
SET @TotalRate=0.00
SET @SerRate=0.00
SET @PrintFrankFromsCount=0
SET @PrintFrankFromsAmt=0.00
set @TotalWeight=0.000

Create table #TempBilling(Branch varchar(50), Services varchar(250), Qty numeric(9,3), Rate numeric(9,2),  Unit char(5), TotalAmount numeric(9,2))

if @BillingId ='BIL0000001'-- PRINTING CHARGES
	begin
		select @PrintFrankFromsCount= IsNull(sum(formcount),0) from InvDispToBranchHeader where branchid =@BranchId and createddate 
		between @FromDate and @ToDate
		select @Services =billdescription,@Unit=Unit,@SerRate=Rate from billingmaster where billingid ='BIL0000001'
		set @PrintFrankFromsAmt= @PrintFrankFromsCount*@SerRate
		select @Branch=upper(branchname) from InvBranchMaster where branchid =@BranchId
		insert into #TempBilling values(@Branch,@Services,@PrintFrankFromsCount,@SerRate,@Unit,@PrintFrankFromsAmt)
	end

if @BillingId ='BIL0000003'-- FRANKING CHARGES
	Begin
		SET @SerRate=0.00
		SET @PrintFrankFromsAmt=0.00

		select @PrintFrankFromsCount= IsNull(count(a.formbarcode),0) from InvReceiptDetails a, InvDispToBranchDetails b where a.FormBarcode =b.FormBarcode
		and a.DeDate between @FromDate and @ToDate and b.BranchId =@BranchId

		select @Services =billdescription,@Unit=Unit,@SerRate=Rate from billingmaster where billingid ='BIL0000003'
		set @PrintFrankFromsAmt= @PrintFrankFromsCount*@SerRate
		select @Branch=upper(branchname) from InvBranchMaster where branchid =@BranchId
		insert into #TempBilling values(@Branch,@Services,@PrintFrankFromsCount,@SerRate,@Unit,@PrintFrankFromsAmt)
	end

if @BillingId ='BIL0000002'-- DISPATCH CHARGES
	begin
		select @Branch=upper(branchname) from InvBranchMaster where branchid =@BranchId
		Declare DisptachDetails cursor for select courierId,weight from InvDispatchDetails where branchid =@BranchId and dedate 
				between @FromDate and @ToDate And ActiveStatus=1
		open DisptachDetails

		fetch next from DisptachDetails into @CourierId,@Weight
		WHILE @@FETCH_STATUS =0
		begin
			set @rate=0.00
			SELECT @Rate=rate from couriertransactionmaster where branchid =@BranchId and courierid =@CourierId and 
			@Weight >= Weightfrom and @Weight <= weightTo and activestatus =1

			SET @TotalRate=@TotalRate+@rate
			set @TotalWeight=@TotalWeight+@Weight	     
			fetch next from DisptachDetails into @CourierId,@Weight

		end

		Close DisptachDetails
		Deallocate DisptachDetails

		select @Services =billdescription,@Unit=Unit from billingmaster where billingid ='BIL0000002'
		insert into #TempBilling values(@Branch,@Services,@TotalWeight,0,@Unit,@TotalRate)
	end

select * from #TempBilling
Set @Message='SUCCESS'            
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoBranchRecon
-- --------------------------------------------------
CREATE proc [dbo].[InvRepoBranchRecon](@BranchId varchar(10),@Option varchar(3),@Message varchar(250) output)
as
begin
Begin Try              
Set Nocount on           
  
Set @Message='SUCCESS' 

if @Option ='ALL'
	begin
		select br.BranchName, f.FormDescription, a.TotalForms 'Total Dispatched',a.TotalUsedForms 'Total Activated',
		(a.TotalForms-a.TotalUsedForms) 'Balance At Branch' from InvBranchConsumption a, invbranchmaster br,
		formmaster f where a.branchid = br.branchid and a.formid = f.formid order by br.BranchName
	end

if @Option ='SIG'
	BEGIN
	if @BranchId=''
		begin
			set @Message ='Branch cannot be blank...'
			return
		end
	
		select br.BranchName, f.FormDescription, a.TotalForms 'Total Dispatched',a.TotalUsedForms 'Total Activated',
		(a.TotalForms-a.TotalUsedForms) 'Balance At Branch' from InvBranchConsumption a, invbranchmaster br,
		formmaster f where a.branchid = br.branchid and a.formid = f.formid AND a.branchid =@branchid order by br.BranchName
	end


End Try             
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoBranchUtilization
-- --------------------------------------------------
CREATE proc [dbo].[InvRepoBranchUtilization](@BranchId varchar(10),@Option varchar(3),@Message varchar(250) output)
as
begin
Begin Try              
Set Nocount on           
  
Set @Message='SUCCESS' 

if @Option ='ALL'
	begin
		select br.BranchName, f.FormDescription, a.MinStock 'Min.Stock',(b.TotalForms-b.TotalUsedForms) 'Stock At Branch' 
		from invBranchStockMaster a, InvBranchConsumption b, invbranchmaster br,formmaster f where a.branchid = b.branchid 
		and a.formid = b.formid and a.branchid = br.branchid and a.formid = f.formid order by br.BranchName,f.FormDescription
	end

if @Option ='SIG'
	BEGIN
	if @BranchId=''
		begin
			set @Message ='Branch cannot be blank...'
			return
		end

		select br.BranchName, f.FormDescription, a.MinStock 'Min.Stock',(b.TotalForms-b.TotalUsedForms) 'Stock At Branch' 
		from invBranchStockMaster a, InvBranchConsumption b, invbranchmaster br,
		formmaster f where a.branchid = b.branchid and a.formid = b.formid and a.branchid = br.branchid and a.formid = f.formid 
		and a.branchid =@BranchId order by br.BranchName,f.FormDescription	

	end


End Try             
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoDispatchDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvRepoDispatchDetails](@FromDate Datetime,@ToDate Datetime,@Option Varchar(50),@Message Varchar(250) Output)
As
Begin
Set NoCount On

Set @Message='SUCCESS'
------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    
If @Option='DISPATCH'
	Select DispatchTrackNo,cm.CourierName,a.PodNo,a.PodDate,bm.BranchName,a.Weight,a.Remarks,
	em.FirstName As 'EmpName',a.DeDate,Convert(Varchar(10),a.DeTime,108) As 'DeTime',
	Case a.ActiveStatus When 1 Then 'Yes' Else 'No' End As 'ActiveStatus'
	From InvDispatchDetails a,CourierMaster cm,InvBranchMaster bm,InvEmployeeMaster em
	Where a.CourierId=cm.CourierId And a.BranchId=bm.BranchId And a.EmpId=em.EmpId And 
	a.DeDate Between @FromDate And @ToDate

If @Option='LINKEDJC'
	Select a.DispatchTrackNo,bh.DispToBranchJCNo As 'DispatchJCNo',bm.BranchName As 'DispatchToBranch'
	From InvDispatchDetails a,InvDispToBranchHeader bh,InvBranchMaster bm
	Where a.DispatchTrackNo=bh.DispatchTrackNo And bh.BranchId=bm.BranchId And 
	a.DeDate Between @FromDate And @ToDate

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoGetFormsDispTrackNowise
-- --------------------------------------------------
CREATE Procedure [dbo].[InvRepoGetFormsDispTrackNowise](@DispTrackNo varchar(10))
As      
Begin      
Set NoCount On           

select  a.DispatchTrackNo, a.DispToBranchJCNo As 'JobcardNo',b.FormBarcode, f.FormDescription, Br.BranchName, b.DeDate, E.FirstName 'Entered By'
from InvDispToBranchHeader a, InvDispToBranchDetails b, FormMaster f, invbranchmaster br, InvEmployeeMaster e 
where a.disptobranchJcNo=b.disptobranchJcNo and b.formid =f.formId and b.branchid =br.branchid and b.empid = e.empid and
a.DispatchTrackNo=@DispTrackNo order by  b.FormBarcode
       
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvRepoLogDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvRepoLogDetails](@FromDate Datetime,@ToDate Datetime,@Option Varchar(50),@Message Varchar(250) Output)
As
Begin
Set NoCount On

Set @Message='SUCCESS'
------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    
If @Option='BillingMaster'
	Select OldBillDescription,NewBillDescription,OldRate,NewRate,oldE.FirstName As 'OldEmpId',
	newE.FirstName As 'NewEmpId',OldDeDate,NewDeDate,Convert(Varchar(10),oldDeTime,108) As 'OldDeTime',
	Convert(Varchar(10),NewDeTime,108) As 'NewDeTime'
	From LogBillingMaster a,InvEmployeeMaster oldE,InvEmployeeMaster newE
	Where a.OldEmpId=oldE.EmpId And a.NewEmpId=newE.EmpId And NewDeDate Between @FromDate And @ToDate

If @Option='BranchStockMaster'
	Select bm.BranchName,fm.FormDescription,OldMinStock,NewMinStock,oldE.FirstName As 'OldEmpId',
	newE.FirstName As 'NewEmpId',OldDeDate,NewDeDate,Convert(Varchar(10),oldDeTime,108) As 'OldDeTime',
	Convert(Varchar(10),NewDeTime,108) As 'NewDeTime'
	From LogInvBranchStockMaster a,invBranchMaster bm,FormMaster fm,InvEmployeeMaster oldE,InvEmployeeMaster newE
	Where a.BranchId=bm.BranchId And a.FormId=fm.FormId And a.OldEmpId=oldE.EmpId And a.NewEmpId=newE.EmpId
	And NewDeDate Between @FromDate And @ToDate	

If @Option='DispatchDetails'
	Select DispatchTrackNo,oldCm.CourierName As 'OldCourierName',newCm.CourierName As 'NewCourierName',
	OldPodNo,NewPodNo,OldPodDate,NewPodDate,oldBm.BranchName As 'OldBranch',newBm.BranchName As 'NewBranch',
	OldWeight,NewWeight,OldRemarks,NewRemarks,oldE.FirstName As 'OldEmpId',newE.FirstName As 'NewEmpId',
	OldDeDate,NewDeDate,Convert(Varchar(10),oldTime,108) As 'OldDeTime',
	Convert(Varchar(10),NewTime,108) As 'NewDeTime',OldDispatchToBranchJcs,
	Case a.ActiveStatus When 1 Then 'Yes' Else 'No' End As 'ActiveStatus' 
	From LogInvDispatchDetails a,CourierMaster oldCm,CourierMaster newCm,InvBranchMaster oldBm,InvBranchMaster newBm,
	InvEmployeeMaster oldE,InvEmployeeMaster newE
	Where a.OldCourierId=oldCm.CourierId And a.NewCourierId=newCm.CourierId And a.OldBranchId=oldBm.BranchId
	And a.NewBranchId=newBm.BranchId And a.OldEmpId=oldE.EmpId And a.NewEmpId=newE.EmpId 
	And NewDeDate Between @FromDate And @ToDate	

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvReportAll
-- --------------------------------------------------
CREATE proc [dbo].[InvReportAll](@FromDate datetime,@ToDate datetime, @Option varchar(10), 
@Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           

Set @ControlNo=0        
Set @Message='SUCCESS' 

------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    

if @Option ='RECPRINTER'
	begin
		select a.InwardJCNo,a.FormBarcode, f.FormDescription, case dispToKyc when 1 then 'DONE' else 'NOT DONE' end
		'Dispatch To KYC', case dispToCSO when 1 then 'DONE' else 'NOT DONE' end 'Dispatch To CSO',
		case ReceiptAtCSO when 1 then 'DONE' else 'NOT DONE' end 'Reced At CSO', 
		case dispToBranch when 1 then 'DONE' else 'NOT DONE' end 'Dispatch To Branch',
		case UsedForm when 1 then 'DONE' else 'NOT DONE' end 'Used Form', e.Firstname 'First Name', a.DeDate 'DataEntry Dt.'
		from InvInwardRegisterDetails a, formmaster f, InvEmployeeMaster e where a.FormId = f.FormId and a.EmpId=e.EmpId and
		a.DeDate between @FromDate and @ToDate
	end

if @Option ='DISPATOKYC'
	begin
		select a.DispToKycJCNo,a.FormBarcode, f.FormDescription,a.ContactPerson,  e.Firstname 'First Name', a.DeDate 'DataEntry Dt.'
		from InvDispToKYCDetails a, formmaster f, InvEmployeeMaster e where a.FormId = f.FormId and a.EmpId=e.EmpId and
		a.DeDate between @FromDate and @ToDate
	end

if @Option ='DISPATOCSO'
	begin
		select a.DispToCSOJCNo,a.FormBarcode, f.FormDescription,a.ContactPerson,  e.Firstname 'First Name', a.DeDate 'DataEntry Dt.'
		from InvDispToCSODetails a, formmaster f, InvEmployeeMaster e where a.FormId = f.FormId and a.EmpId=e.EmpId and
		a.DeDate between @FromDate and @ToDate
	end

if @Option ='RECEDATCSO'
	begin
		select a.ReceiptJCNo,a.FormBarcode, f.FormDescription,e.Firstname 'First Name', a.DeDate 'DataEntry Dt.'
		from InvReceiptDetails a, formmaster f, InvEmployeeMaster e where a.FormId = f.FormId and a.EmpId=e.EmpId and
		a.DeDate between @FromDate and @ToDate
	end

if @Option ='DISPTOBRAN'
	begin
		select a.DispToBranchJcNo,a.FormBarcode, f.FormDescription,b.BranchName, dh.ContactPerson 'Branch Contact Person',e.Firstname 'First Name', 
		a.DeDate 'DataEntry Dt.' from InvDispToBranchDetails a, formmaster f, InvEmployeeMaster e,invBranchMaster b,
		InvDispToBranchHeader dh where a.FormId = f.FormId and a.EmpId=e.EmpId and	a.branchid = b.branchid and 
		a.DispToBranchJcNo=dh.DispToBranchJcNo And a.DeDate between @FromDate and @ToDate
	end

if @Option ='USEDFORMS'
	begin
		select a.UsedFormsJcNo,a.FormBarcode, f.FormDescription,b.BranchName,e.Firstname 'First Name', 
		a.DeDate 'DataEntry Dt.' from InvUsedFormsDetails a, formmaster f, InvEmployeeMaster e,invBranchMaster b where 
		a.FormId = f.FormId and a.EmpId=e.EmpId and	a.branchid = b.branchid and a.DeDate between @FromDate and @ToDate
	end

if @Option ='VENCHALLAN'
	begin
		Select a.VendorId,a.VendorName,a.ChallanNumber,a.ChallanDate,a.FormsQty As 'Forms Quantity',b.FirstName As 'First Name',b.LastName As 'Last Name',
		case b.ActiveStatus when 1 then 'Active' else 'In-active' end 'Active Status'
		from InvVendorDetails a,InvEmployeeMaster b
		Where a.EmpId=b.EmpId and a.DeDate between @FromDate and @ToDate
	end

End Try             
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')              
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvReportAllSummary
-- --------------------------------------------------
CREATE proc [dbo].[InvReportAllSummary](@FromDate datetime,@ToDate datetime, @Option varchar(10), 
@Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           

Set @ControlNo=0        
Set @Message='SUCCESS' 

------------------------------------------------------------------------------------------------ 
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------    

if @Option ='RECPRINTER'
	begin
		select a.InwardJCNo, f.FormDescription, count(a.formid) 'Form Count'	from InvInwardRegisterDetails a, 
		formmaster f where a.FormId = f.FormId and a.DeDate between @FromDate and @ToDate group by a.InwardJCNo, 
		f.FormDescription order by a.InwardJCNo
	end

if @Option ='DISPATOKYC'
	begin
		select a.DispToKycJCNo,f.FormDescription,count(a.FormBarcode) 'Form Count' from InvDispToKYCDetails a, formmaster f where 
		a.FormId = f.FormId and a.DeDate between @FromDate and @ToDate group by a.DispToKycJCNo,f.FormDescription
		order by a.DispToKycJCNo
	end

if @Option ='DISPATOCSO'
	begin
		select a.DispToCSOJCNo, f.FormDescription,count(a.FormBarcode) 'Form Count' from InvDispToCSODetails a, formmaster f 
		where a.FormId = f.FormId and a.DeDate between @FromDate and @ToDate  group by a.DispToCSOJCNo, 
		f.FormDescription
	end

if @Option ='RECEDATCSO'
	begin
		select a.ReceiptJCNo, f.FormDescription,count(a.FormBarcode) 'Form Count' from InvReceiptDetails a, formmaster f where 
		a.FormId = f.FormId and	a.DeDate between @FromDate and @ToDate group by a.ReceiptJCNo, f.FormDescription 
		order by a.ReceiptJCNo
	end

if @Option ='DISPTOBRAN'
	begin
		select a.DispToBranchJcNo, f.FormDescription,b.BranchName, count(a.FormBarcode) from InvDispToBranchDetails a, 
		formmaster f, invBranchMaster b where a.FormId = f.FormId and	a.branchid = b.branchid and a.DeDate 
		between '2016-01-01' and '2016-01-31' group by a.DispToBranchJcNo, f.FormDescription,b.BranchName 
		order by a.DispToBranchJcNo, f.FormDescription
	end

if @Option ='USEDFORMS'
	begin
		select a.UsedFormsJcNo,f.FormDescription,b.BranchName, count(a.FormBarcode) 'Form Count' from InvUsedFormsDetails a, 
		formmaster f, invBranchMaster b where a.FormId = f.FormId and a.branchid = b.branchid and a.DeDate 
		between '2016-01-01' and '2016-01-31' group by a.UsedFormsJcNo,f.FormDescription,b.BranchName 
		order by a.UsedFormsJcNo,f.FormDescription
	end

End Try             
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvReportMasters
-- --------------------------------------------------

CREATE proc InvReportMasters(@Option varchar(50),@Message varchar(250) output, @ControlNo int output)
as
begin
Begin Try              
Set Nocount on           

Set @ControlNo=0        
Set @Message='SUCCESS' 
----------------------------------------------------------------------
if @Option ='BranchMaster'
	Begin	
		select a.BranchId, a.BranchName, a.BranchAddress, a.ContactPerson, e.FirstName 'Created By',
		case a.ActiveStatus when 1 then 'Active' else 'In-Active' end 'Active Status',convert(varchar,a.DeDate, 103) 
		'Created Date' from invbranchmaster a,invemployeemaster e where a.empid = e.empid
		order by a.BranchName
	End

if @Option ='UserTypeMaster'
	Begin	
		Select UserTypeId,Description As 'UserType',Case Status When 1 Then 'Active' Else 'In-Active' End As 'Status' 
		From InvUserTypeMaster Order By Description
	End

if @Option ='UserMaster'
	Begin	
		Select a.EmpId,a.LoginId,a.FirstName,a.LastName,b.Description As 'UserType',bm.BranchName,a.EmailId,
		Case a.ActiveStatus When 1 Then 'Active' Else 'In-Active' End As 'Status' 
		From InvEmployeeMaster a,InvUserTypeMaster b,InvBranchMaster bm Where a.UserTypeId=b.UserTypeId And a.BranchId=bm.BranchId
		Order By LoginId
	End

if @Option ='FormTypeMaster'
	begin	
		select a.FormTypeId, a.FormName,e.FirstName 'Created By',case a.ActiveStatus when 1 then 'Active' else 'In-Active' 
		end 'Active Status',convert(varchar,a.DeDate, 103) 'Created Date' from FormTypemaster a,invemployeemaster e 
		where  a.empid = e.empid order by a.FormName
	end

if @Option ='FormMaster'
	begin	
		select a.FormId, a.FormDescription 'Form Name',f.FormName 'Linked Form Type',e.FirstName 'Created By',
		case a.ActiveStatus when 1 then 'Active' else 'In-Active' end 'Active Status',convert(varchar,a.DeDate, 103) 'Created Date' 
		from Formmaster A, FormTypemaster F,invemployeemaster e where a.formtypeid = f.formtypeid and a.empid = e.empid
		order by a.FormDescription
	end

if @Option ='CourierMaster'
	begin	
		select a.CourierId, a.CourierName, e.FirstName 'Created By',case a.ActiveStatus when 1 then 'Active' else 'In-Active' 
		end 'Active Status',convert(varchar,a.DeDate, 103) 'Created Date' from CourierMaster A, invemployeemaster e where 
		a.empid = e.empid order by a.CourierName
	end

if @Option ='BillingMaster'
	begin	
		select a.BillingId, a.BillDescription,a.Unit,a.Rate, e.FirstName 'Created By',case a.ActiveStatus when 1 then 'Active' 
		else 'In-Active' end 'Active Status',convert(varchar,a.DeDate, 103) 'Created Date' from billingmaster A, invemployeemaster e where 
		a.empid = e.empid order by a.BillDescription
	end

if @Option ='BranchStockMaster'
	begin	
		select br.BranchName,f.FormDescription, a.MinStock, e.FirstName 'Created By',	case a.ActiveStatus when 1 then 'Active' else 
		'In-Active' end 'Active Status',convert(varchar,a.DeDate, 103) 'Created Date' from invBRANCHstockmaster A, Invbranchmaster br, 
		invemployeemaster e, formmaster f where a.branchid = br.branchid and a.empid = e.empid  and a.formid = f.formid order by 
		br.BranchName,f.FormDescription
	end

if @Option ='CourierRateMaster'
	begin	
		select c.CourierName, br.BranchName , a.WeightFrom, a.WeightTo, a.Rate, case a.ActiveStatus when 1 then 'Active' else
		'In-Active' end 'Active Status',e.FirstName 'Created By' from Couriertransactionmaster a, CourierMaster c, InvBranchMaster br,
		invemployeemaster e 	where a.courierId = c.Courierid and a.branchid = br.BranchId and a.empid = e.empid order by 
		c.CourierName, br.BranchName, a.Transid
	end

if @Option ='UserTypeWiseRights'
	begin	
		Select a.UserTypeId,a.Description As 'UserType',c.MenuCaption
		From InvUsertypeMaster a,InvUserTypeMenuRightsMaster b,InvMenuMaster c 
		Where a.UserTypeId=b.UserTypeId And b.MenuId=c.MenuId And a.Status=1 Order By a.Description,c.MenuSerialNo
	end

if @Option ='UserWiseRights'
	begin	
		Select a.EmpId,a.LoginId,c.MenuCaption
		From InvEmployeeMaster a,InvUserTypeMenuRightsMaster b,InvMenuMaster c 
		Where a.EmpId=b.EmpId And b.MenuId=c.MenuId And a.ActiveStatus=1 Order By a.LoginId,c.MenuSerialNo
	end

if @Option='LotMaster'
	begin
		Select a.LotId,a.LotNumber,a.Rate,Case a.ActiveStatus When 0 Then 'No' Else 'Yes' End As 'ActiveStatus',
		e.FirstName As 'CreatedBy',convert(varchar,a.DeDate,103) As 'Created Date'
		From FormsLotMaster a,InvEmployeeMaster e Where a.EmpId=e.EmpId
	end

if @Option='UploadedVendorInwardData'
	begin
		Select fm.FormDescription,a.FormBarcode,e.FirstName As 'UploadedBy',convert(varchar,a.UploadDate,103) As 'Uploaded Date',
		convert(varchar,a.UploadTime,103) As 'Uploaded Time' From InvVendorInwardData a,InvEmployeeMaster e,FormMaster fm 
		Where a.EmpId=e.EmpId And a.FormId=fm.FormId And Convert(Varchar(10),a.UploadDate,112)=Convert(Varchar(10),GetDate(),112)
	end

End Try             
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchDetails
-- --------------------------------------------------
CREATE proc [dbo].[InvTranDispatchDetails] (@DispatchTrackNo varchar(10) output, @CourierId varchar(10),@PODNo varchar(200),  
@PodDate datetime, @BranchId varchar(10), @DispToBranchJcNo varchar(10), @Weight numeric(9,3), @Remarks varchar(100),  
@UpdateStatus char(3),@EmpId varchar(10), @DMLTran char(5),@Transit varchar(10), @Message varchar(250) output, @ControlNo int output )  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime  
Declare @DeTime Datetime  
Declare @JCsNos nvarchar(max)
Declare @OldDispatchTrackNo Varchar(10)
Set @ControlNo=0          
Set @Message=''   

Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)   


if not exists(SELECT * from couriertransactionmaster where branchid =@BranchId and courierid =@CourierId and @Weight >= Weightfrom and @Weight <= weightTo
	and activestatus =1)  
	begin  
	Set @Message='Rate based on weight has not updated in Courier Master for selected branch and courier...' 
	Set @ControlNo=2       
	return  
	end  

if @PodDate>Convert(Varchar(10),getdate(),120)   
	begin
		set @message='POD Date cannot be greater than today`s date...'
		set @Controlno=1
		return
	end

if @DMLTran ='ADD'   
	begin  
	if @UpdateStatus ='NO'
		begin
			if not exists(SELECT * from couriertransactionmaster where branchid =@BranchId and courierid =@CourierId and 
				@Weight >= Weightfrom and @Weight <= weightTo)  
				begin  
				Set @Message='Rate based on weight has not updated in Courier Master for selected branch and courier...' 
				Set @ControlNo=2   
				return  
				end  
			
			Select @DispatchTrackNo='TR' +  RIGHT('00000000' +  Cast(coalesce(max(substring(DispatchTrackNo,3,len(DispatchTrackNo))),0) + 1 As Varchar(10)),8)    
			From invDispatchDetails    

			insert into invDispatchDetails(DispatchTrackNo,CourierId,PodNo,PodDate,BranchId,Weight,Remarks,EmpId,deDate,DeTime,Transit)  
			values (@DispatchTrackNo,@CourierId,@PODNo,@PodDate,@BranchId,@Weight,@Remarks,@EmpId,@DeDate,@DeTime,@Transit)     

		end

		----- To avoid overwrite of dispatch track no. in InvDispToBranchHeader if two persons are saving same instance
		If Exists(Select DispToBranchJcNo From InvDispToBranchHeader Where DispToBranchJcNo=@DispToBranchJcNo And DispatchTrackNo Is Not Null)
		Begin 
			Select @OldDispatchTrackNo=DispatchTrackNo From InvDispToBranchHeader Where DispToBranchJcNo=@DispToBranchJcNo
			Set @Message='Jobcard: ' + @DispToBranchJcNo + ' is already linked to Dispatch Track No.:' + @OldDispatchTrackNo + '..Transaction has been cancelled...'	
			Return
		End

		update InvDispToBranchHeader set DispatchTrackNo=@DispatchTrackNo where DispToBranchJcNo= @DispToBranchJcNo
	end  

if @DMLTran ='EDIT'   
	begin  
		if @UpdateStatus ='NO'

		BEGIN

			if not exists(SELECT * from couriertransactionmaster where branchid =@BranchId and courierid =@CourierId and 
			@Weight >= Weightfrom and @Weight <= weightTo and activestatus =1)  
			begin  
			Set @Message='Rate based on weight has not updated in Courier Master for selected branch and courier...' 
			Set @ControlNo=2   
			return  
			end 

			SELECT @JCsNos= ISNULL(@JCsNos + ',','') +DispToBranchJcNo FROM InvDispToBranchHeader where DispatchTrackNo=@DispatchTrackNo
			
			update InvDispToBranchHeader set DispatchTrackNo=null where DispatchTrackNo= @DispatchTrackNo 
			
			insert into logInvDispatchDetails(OldCourierId,NewCourierId,OldPodNo,NewPodNo,OldPodDate,NewPodDate,OldBranchId,NewBranchId,  
			OldWeight,NewWeight,OldRemarks,NewRemarks,OldEmpId,NewEmpId,OldDeDate,NewDeDate,  
			OldTime,NewTime,OldDispatchToBranchJcs,DispatchTrackNo,OldTransit,NewTransit) select CourierId,@CourierId,PodNo,@PODNo,PodDate,@PodDate,BranchId,@BranchId,  
			Weight,@Weight,Remarks,@Remarks,EmpId,@EmpId,deDate,@deDate,DeTime,@DeTime,@JCsNos,DispatchTrackNo,Transit,@Transit 
			from InvDispatchDetails where  DispatchTrackNo=@DispatchTrackNo

			update InvDispatchDetails set CourierId=@CourierId,PodNo=@PODNo,PodDate=@PodDate,BranchId=@BranchId,
			Weight=@Weight,Remarks=@Remarks,EmpId=@EmpId,deDate=@deDate,DeTime=@DeTime,Transit=@Transit where DispatchTrackNo=@DispatchTrackNo  

		END

		----- To avoid overwrite of dispatch track no. in InvDispToBranchHeader if two persons are saving same instance
		If Exists(Select DispToBranchJcNo From InvDispToBranchHeader Where DispToBranchJcNo=@DispToBranchJcNo And DispatchTrackNo Is Not Null)
		Begin 
			Select @OldDispatchTrackNo=DispatchTrackNo From InvDispToBranchHeader Where DispToBranchJcNo=@DispToBranchJcNo
			Set @Message='Jobcard: ' + @DispToBranchJcNo + ' is already linked to Dispatch Track No.:' + @OldDispatchTrackNo + '..Transaction has been cancelled...'	
			Return
		End

		update InvDispToBranchHeader set DispatchTrackNo=@DispatchTrackNo where DispToBranchJcNo= @DispToBranchJcNo
	end  

if @DMLTran='DEACT'
	begin
		
		If Exists(Select DispatchTrackNo From InvDispatchDetails Where ActiveStatus=0 And DispatchTrackNo=@DispatchTrackNo)
		Begin
			Set @Message='Dispatch Track No. is already in-active...'
			Return
		End

		SELECT @JCsNos= ISNULL(@JCsNos + ',','') +DispToBranchJcNo FROM InvDispToBranchHeader where DispatchTrackNo=@DispatchTrackNo
			
		update InvDispToBranchHeader set DispatchTrackNo=null where DispatchTrackNo=@DispatchTrackNo 
		
		insert into logInvDispatchDetails(OldCourierId,NewCourierId,OldPodNo,NewPodNo,OldPodDate,NewPodDate,OldBranchId,NewBranchId,  
		OldWeight,NewWeight,OldRemarks,NewRemarks,OldEmpId,NewEmpId,OldDeDate,NewDeDate,  
		OldTime,NewTime,OldDispatchToBranchJcs,DispatchTrackNo,ActiveStatus,OldTransit,NewTransit) select CourierId,@CourierId,PodNo,@PODNo,PodDate,@PodDate,BranchId,@BranchId,  
		Weight,@Weight,Remarks,@Remarks,EmpId,@EmpId,deDate,@deDate,DeTime,@DeTime,@JCsNos,DispatchTrackNo,0,Transit,@Transit 
		from InvDispatchDetails where  DispatchTrackNo=@DispatchTrackNo

		update InvDispatchDetails set ActiveStatus=0 where DispatchTrackNo=@DispatchTrackNo  
	end


Set @Message='SUCCESS'              

End Try                

Begin Catch                

DECLARE @ErSeverity INT,@ErState INT            
Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')  
Set @ControlNo=99              
SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
RAISERROR (@Message,@ErSeverity,@ErState)                     

End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvTranDispatchGetDetails](@BranchId Varchar(10),@DispatchTrackNo Varchar(10))
As
Begin

If @DispatchTrackNo=''
	Select bh.DispToBranchJCNo As 'JobcardNo',fm.FormDescription As 'FormDesc',bh.FormCount 
	From InvDispToBranchHeader bh,FormMaster fm Where bh.FormId=fm.FormId And bh.DispatchTrackNo Is NULL And bh.BranchId=@BranchId
Else
	Select bh.DispToBranchJCNo As 'JobcardNo',fm.FormDescription As 'FormDesc',bh.FormCount,1 As 'CheckedStatus' 
	From InvDispToBranchHeader bh,FormMaster fm Where bh.FormId=fm.FormId And bh.DispatchTrackNo=@DispatchTrackNo And bh.BranchId=@BranchId
	Union All
	Select bh.DispToBranchJCNo As 'JobcardNo',fm.FormDescription As 'FormDesc',bh.FormCount,0 As 'CheckedStatus' 
	From InvDispToBranchHeader bh,FormMaster fm Where bh.FormId=fm.FormId And bh.DispatchTrackNo Is NULL And bh.BranchId=@BranchId
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchGetTrackNoDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvTranDispatchGetTrackNoDetails](@DispatchTrackNo Varchar(10),@Message Varchar(250) Output)
As
Begin

Declare @BranchId Varchar(10),@CourierId Varchar(10),@DeDate Datetime
Select @BranchId=BranchId,@CourierId=CourierId,@DeDate=DeDate From InvDispatchDetails Where DispatchTrackNo=@DispatchTrackNo

Set @Message='SUCCESS'

If Exists(Select DispatchTrackNo From InvDispatchDetails Where DispatchTrackNo=@DispatchTrackNo And ActiveStatus=0)
Begin
	Set @Message='Dispatch Track No. is already in-active..cannot modify...'
	Return
End

If Exists(Select BranchName From InvBranchMaster Where BranchId=@BranchId And ActiveStatus=0)
Begin
	Set @Message='Branch linked to dispatch track no. is already in-active..cannot modify...'
	Return
End

If Exists(Select CourierId From CourierMaster Where CourierId=@CourierId And ActiveStatus=0)
Begin
	Set @Message='Courier linked to dispatch track no. is already in-active..cannot modify...'
	Return
End
	
If Year(@DeDate)<=Year(GetDate()) And Month(@DeDate)<Month(GetDate()) And Day(GetDate())>=5
Begin
	Set @Message='Billing information has already been sent..cannot modify...'
	Return
End

Select dd.BranchId,dd.CourierId,dd.PODNo,Convert(Varchar(10),dd.PODDate,103) As 'PODDate',
dd.Weight,dd.Remarks,bh.DispToBranchJCNo As 'JobcardNo',fm.FormDescription As 'FormDesc',bh.FormCount,
1 As 'CheckedStatus',dd.Transit
From InvDispToBranchHeader bh,FormMaster fm,InvDispatchDetails dd 
Where bh.FormId=fm.FormId And dd.DispatchTrackNo=bh.DispatchTrackNo And 
bh.DispatchTrackNo=@DispatchTrackNo

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchToBranch
-- --------------------------------------------------

CREATE proc InvTranDispatchToBranch (@DispToBranchJcNo varchar(10) output,@FormBarcode varchar(10), 
@FormId varchar(10),@Person varchar(50), @BranchId varchar(10),
@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output )
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime
Declare @BranchName Varchar(50)

Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 

if exists (select * from InvDispToBranchHeader where DispToBranchJcNo=@DispToBranchJcNo)
	
	begin
		if not exists (Select * from InvDispToBranchHeader where DispToBranchJcNo=@DispToBranchJcNo and 
		branchid = @BranchId)
		begin
			set @Message='Dispatch Jobcard has already linked to another branch.  Cannot process.'
			return
		end
		if not exists (Select * from InvDispToBranchHeader where DispToBranchJcNo=@DispToBranchJcNo and 
		FormId = @FormId)
		begin
			set @Message='Dispatch Jobcard has already linked to another Form.  Cannot process.'
			return
		end	
	end

----if not exists(select formbarcode from InvReceiptDetails where FormBarcode=@FormBarcode AND FormId =@FormId)
----	begin
----		set @Message='Form has not received from KYC team after franking or mismatch between form and form type'
----		return
----	end

If Not Exists(Select FormBarcode From InvInwardRegisterDetails Where FormBarcode=@FormBarcode And FormId=@FormId)
Begin
	Set @Message='Form not received from the printer or mismatch between form and form type...' 
	Return
End

if exists(select formbarcode from InvDispToBranchDetails where FormBarcode=@FormBarcode)
	begin
		Select @BranchName=BranchName From InvDispToBranchDetails a,InvBranchMaster b WHere a.BranchId=b.BranchId And FormBarcode=@FormBarcode
		set @Message='Form has already sent to Branch: ' + @BranchName + '...'
		return
	end
--------------------------------------------------------------------------
if @DispToBranchJcNo ='TOBEGENERA'
	begin
		
		if not exists(Select BranchId From invBranchStockMaster Where BranchId=@BranchId And FormId=@FormId)
		begin
			set @Message='Branch Stock has not been updated for selected branch and form..Please update...'
			set @ControlNo=1
			return
		end
		----------------------
		Select @DispToBranchJcNo='DS' +  RIGHT('00000000' +  Cast(coalesce(max(substring(DispToBranchJcNo,3,len(DispToBranchJcNo))),0) + 1 As Varchar(10)),8)
		From InvDispToBranchHeader
		insert into InvDispToBranchHeader(DispToBranchJcNo,BranchId,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime,ContactPerson)
		values	(@DispToBranchJcNo,@BranchId,@FormId,0,@EmpId,@DeDate,@DeTime,@Person)

	end
--------------------------------------------------------------------------
	insert into InvDispToBranchDetails(DispToBranchJcNo,FormBarcode,BranchId,FormId,EmpId,DeDate,
	DeTime)	values (@DispToBranchJcNo,@FormBarcode,@BranchId,@FormId,@EmpId,@DeDate,@DeTime)

	Update InvDispToBranchHeader set FormCount=FormCount+1 where DispToBranchJcNo=@DispToBranchJcNo and FormId=@FormId and
	BranchId =@BranchId
	Update InvInwardRegisterDetails set DispToBranch =1 where FormBarcode=@FormBarcode
	
if not exists (select branchid from InvBranchConsumption where branchid =@BranchId and  FormId=@FormId)
	begin
		insert into InvBranchConsumption(BranchId,FormId,TotalForms,TotalUsedForms) values (@BranchId,@FormId,0,0)
	end
	update 	InvBranchConsumption set TotalForms=TotalForms+1 where branchid =@BranchId and  FormId=@FormId

Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchToBranchGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvTranDispatchToBranchGetDetails](
	@DispToBranchJcNo varchar(10),@Message Varchar(250) Output
)  
As  
Begin Try 
Set NoCount On  
Declare @BranchName Varchar(50),@DispatchTrackNo Varchar(10)

Set @Message=''  

If Not Exists(Select DispToBranchJcNo from InvDispToBranchHeader Where DispToBranchJcNo=@DispToBranchJcNo)
Begin
	Set @Message='Dispatch Jobcard Number not found...'
	Return
End

If Exists(Select DispatchTrackNo from InvDispToBranchHeader where DisptoBranchJcNo=@DispToBranchJcNo and DispatchTrackNo is not NULL) 
Begin
		Select @BranchName=b.BranchName,@DispatchTrackNo=a.DispatchTrackNo from InvDispToBranchHeader a,InvBranchMaster b
		where a.BranchId=b.BranchId and DisptoBranchJcNo=@DispToBranchJcNo
		Set @Message='Dispatch JC No. is already linked to '  + @BranchName +  ' branch on Dispatch Track No : '+ @DispatchTrackNo + 
					 '\n Please delink this Dispatch Jobcard before proceeding...'	
		Return
End

Select b.BranchName,a.ContactPerson,b.BranchId from InvDispToBranchHeader a,InvBranchMaster b
Where a.BranchId=b.BranchId and a.DispToBranchJcNo=@DispToBranchJcNo
  
Set @Message='SUCCESS' 

End Try  
Begin Catch              
	DECLARE @ErSeverity INT,@ErState INT    
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')          
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()       
	RAISERROR (@Message,@ErSeverity,@ErState)              
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispatchToBranchModify
-- --------------------------------------------------
CREATE proc [dbo].[InvTranDispatchToBranchModify] (@DispatchJcNo varchar(10), @OldBranchId varchar(10), @NewBranchId varchar(10),
@ContactPerson varchar(50), @Message varchar(250) output, @ControlNo int output )  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime  
Declare @DeTime Datetime  
Declare @FormCount bigint
Declare @FormId varchar(10)

Set @ControlNo=0          
Set @Message=''  

if @OldBranchId =''
	begin  
	Set @Message='Branch Name cannot be blank....' 
	Set @ControlNo=2      
	return  
	end   

if @NewBranchId =''
	begin  
	Set @Message='New Branch Name cannot be blank....' 
	Set @ControlNo=2      
	return  
	end   

if @OldBranchId =@NewBranchId
	begin  
	Set @Message='Old Branch Name and New Branch Name cannot be same....' 
	Set @ControlNo=2      
	return  
	end  


select @FormId = formid from InvDispToBranchHeader where DispToBranchJcNo=@DispatchJcNo

if not exists(Select BranchId From invBranchStockMaster Where BranchId=@NewBranchId And FormId=@FormId)
	begin
	set @Message='Branch Stock has not been updated for selected branch and form..Please update...'
	set @ControlNo=2
	return
end

select @FormCount = formcount from InvDispToBranchHeader where DispToBranchJcNo=@DispatchJcNo

update InvDispToBranchHeader set BranchId=@NewBranchId,ContactPerson=@ContactPerson where DispToBranchJcNo=@DispatchJcNo
update InvDispToBranchDetails set BranchId=@NewBranchId where DispToBranchJcNo=@DispatchJcNo

if not exists (select branchid from InvBranchConsumption where branchid=@NewBranchId and  FormId=@FormId)
	begin
		insert into InvBranchConsumption(BranchId,FormId,TotalForms,TotalUsedForms) values 
		(@NewBranchId,@FormId,@FormCount,0)

		update InvBranchConsumption set TotalForms=TotalForms-@FormCount,formid=@FormId where branchid=@OldBranchId 
		and  FormId=@FormId
	end
else
	begin
	update InvBranchConsumption set TotalForms=TotalForms+@FormCount,formid =@FormId  where branchid=@NewBranchId and  FormId=@FormId
	update InvBranchConsumption set TotalForms=TotalForms-@FormCount ,formid =@FormId where branchid=@OldBranchId and  FormId=@FormId
	end
	delete from InvBranchConsumption where TotalForms=0

Set @Message='SUCCESS'              

End Try                

Begin Catch                

DECLARE @ErSeverity INT,@ErState INT            
Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')  
Set @ControlNo=99              
SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
RAISERROR (@Message,@ErSeverity,@ErState)                     

End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispToCSO
-- --------------------------------------------------
CREATE proc [dbo].[InvTranDispToCSO] (@DispToCSOJCNo varchar(10) output,@FormBarcode varchar(10), @FormId varchar(10),    
@Person varchar(50), @EmpId varchar(10), @Message varchar(250) output, @ControlNo int output )    
as    
begin    
Begin Try                  
Set Nocount on               
Declare @DeDate Datetime    
Declare @DeTime Datetime    
    
Set @ControlNo=0            
Set @Message=''     
    
Select @DeDate=convert(varchar(10),getdate(),120)    
Select @DeTime=Convert(varchar(10),getdate(),108)     

if exists (select * from InvDispToCSOHeader where DispToCSOJCNo=@DispToCSOJCNo)
	
	begin
		if not exists (Select * from InvDispToCSOHeader where DispToCSOJCNo=@DispToCSOJCNo and 
		FormId = @FormId)
		begin
			set @Message='Dispatch To CSO Jobcard has already linked to another Form.  Cannot process.'
			return
		end
	end
    
if not exists(select formbarcode from InvDispToKYCDetails where FormBarcode=@FormBarcode AND FormId =@FormId)    
 begin    
  set @Message='Form not received from the CSO team for franking or mismatch between form and form type'    
  return    
 end    
    
if exists(select formbarcode from InvDispToCSODetails where FormBarcode=@FormBarcode)    
 begin    
  set @Message='Form has already dispatch to CSO team after franking..'    
  return    
 end    
    
if @DispToCSOJCNo ='TOBEGENERA'    
 begin    
 Select @DispToCSOJCNo='CS' +  RIGHT('00000000' +  Cast(coalesce(max(substring(DispToCSOJCNo,3,len(DispToCSOJCNo))),0) + 1 As Varchar(10)),8)    
 From InvDispToCSOHeader    
 insert into InvDispToCSOHeader(DispToCSOJCNo,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime) values    
 (@DispToCSOJCNo,@FormId,0,@EmpId,@DeDate,@DeTime)    
 end    
    
 insert into InvDispToCSODetails(DispToCSOJCNo,FormBarcode,FormId,ContactPerson,EmpId,DeDate,DeTime)    
 values (@DispToCSOJCNo,@FormBarcode,@FormId,@Person,@EmpId,@DeDate,@DeTime)    
    
 Update InvDispToCSOHeader set FormCount=FormCount+1 where DispToCSOJCNo=@DispToCSOJCNo and FormId=@FormId    
 Update InvInwardRegisterDetails set dispToCSO =1 where FormBarcode=@FormBarcode    
    
Set @Message='SUCCESS'                
           
End Try                  
            
Begin Catch                  
            
 DECLARE @ErSeverity INT,@ErState INT              
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                    
 Set @ControlNo=99                
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                 
 RAISERROR (@Message,@ErSeverity,@ErState)                       
              
End Catch       
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranDispToKYC
-- --------------------------------------------------
CREATE proc [dbo].[InvTranDispToKYC] (@DispToKycJCNo varchar(10) output,@FormBarcode varchar(10), @FormId varchar(10),  
@Person varchar(50), @EmpId varchar(10), @Message varchar(250) output, @ControlNo int output )  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime  
Declare @DeTime Datetime  
  
Set @ControlNo=0          
Set @Message=''   
  
Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)   


if exists (select * from InvDispToKYCHeader where DispToKycJCNo=@DispToKycJCNo)
	
	begin
		if not exists (Select * from InvDispToKYCHeader where DispToKycJCNo=@DispToKycJCNo and 
		FormId = @FormId)
		begin
			set @Message='Dispatch To KYC Jobcard has already linked to another Form.  Cannot process.'
			return
		end
	end
  
if not exists(select formbarcode from InvInwardRegisterDetails where FormBarcode=@FormBarcode AND FormId =@FormId)  
 begin  
  set @Message='Form not received from the printer or mismatch between form and form type'  
  return  
 end  
  
if exists(select formbarcode from InvDispToKYCDetails where FormBarcode=@FormBarcode)  
 begin  
  set @Message='Form has already dispatch to KYC team for franking..'  
  return  
 end  
  
if @DispToKycJCNo ='TOBEGENERA'  
 begin  
 Select @DispToKycJCNo='KY' +  RIGHT('00000000' +  Cast(coalesce(max(substring(DispToKycJCNo,3,len(DispToKycJCNo))),0) + 1 As Varchar(10)),8)  
 From InvDispToKYCHeader  
 insert into InvDispToKYCHeader(DispToKycJCNo,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime) values  
 (@DispToKycJCNo,@FormId,0,@EmpId,@DeDate,@DeTime)  
 end  
  
 insert into InvDispToKYCDetails(DispToKycJCNo,FormId,FormBarcode,ContactPerson,EmpId,DeDate,DeTime)  
 values (@DispToKycJCNo,@FormId,@FormBarcode,@Person,@EmpId,@DeDate,@DeTime)  
  
 Update InvDispToKYCHeader set FormCount=FormCount+1 where DispToKycJCNo=@DispToKycJCNo and FormId=@FormId  
 Update InvInwardRegisterDetails set dispToKyc =1 where FormBarcode=@FormBarcode  
  
Set @Message='SUCCESS'              
         
End Try                
          
Begin Catch                
          
 DECLARE @ErSeverity INT,@ErState INT            
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
 Set @ControlNo=99              
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
 RAISERROR (@Message,@ErSeverity,@ErState)                     
            
End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranInterChangeForms
-- --------------------------------------------------
CREATE proc [dbo].[InvTranInterChangeForms] ( @ToFormId varchar(10),@FormBarcode varchar(10),@EmpId varchar(10),
@Message varchar(250) output, @ControlNo int output )
As
Begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime
Declare @FromFormId varchar(10)
Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
----------------------------------------------------------------------

if not exists (select formbarcode from InvInwardRegisterDetails WHere FormBarcode=@FormBarcode) 
	begin
		Set @Message='Form not received from printer..........'	
		Set @ControlNo=1	
		return
	end

if  exists (select formbarcode from InvDispToKYCDetails WHere FormBarcode=@FormBarcode) 
	begin
		Set @Message='Transaction has already started for this form.- Dispatch to KYC.........'	
		Set @ControlNo=1		
		return
	end
	
	select @FromFormId=formId from InvInwardRegisterDetails where formbarcode =@FormBarcode

if @FromFormId= @ToFormId
	begin
		Set @Message='Form has already belongs to selected To form Id........'	
		Set @ControlNo=2		
		return	
	end
	
	insert into LogInterChangeForms(FromFormId,ToFormId,FormBarcode,EmpId,DeDate,DeTime)
	values(@FromFormId,@ToFormId,@FormBarcode,@EmpId,@DeDate,@DeTime)
	
	update InvInwardRegisterDetails set formId=@ToFormId where FormBarcode=@FormBarcode


Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranInwardRangeWise
-- --------------------------------------------------
CREATE Procedure [dbo].[InvTranInwardRangeWise]
(
	@JobcardNo Varchar(10) Output,@FormId Varchar(10),@FromNo Varchar(10),@ToNo Varchar(10),@LotId Varchar(10),
	@EmpId Varchar(10),@Message Varchar(250) Output,@ControlNo int Output
)
As
Begin Try
Set NoCount On
------------------------------------------------------------------------------------------
Declare @DeDate Datetime,@DeTime DateTime,@NoOfForms BigInt,@FNo BigInt,@TNo BigInt
Declare @TblForms Table(FormBarcode Varchar(10))
Declare @TblPresentFormsInVendorInwardData Table(FormBarcode Varchar(10),FormId Varchar(10),FormDesc Varchar(50))
Declare @TblFormsNotInVendorInwardData Table(FormBarcode Varchar(10),FormDesc Varchar(50))

Select @Message='',@ControlNo=0

Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)  

Select @FNo=Convert(BigInt,@FromNo),@TNo=Convert(BigInt,@ToNo)
Set @NoOfForms=(@TNo-@FNo+1)
------------------------------------------------------------------------------------------
If @NoOfForms>3000
Begin 
	Set @Message='Only 3000 form barcodes can be generated at a time..Please decrease the range...'
	Set @ControlNo=1
	Return 	
End
--------------------------------------------------------------------------------------------------
While @FNo<=@TNo
Begin
	Insert Into @TblForms Values(Convert(Varchar,@FNo))
	Set @FNo=@FNo+1
End
--------------------------------------------------------------------------------------------------
---- Check for Forms in InvInwardRegisterDetails
If Exists(Select top 1 a.FormBarcode From InvInwardRegisterDetails a,@TblForms b Where a.FormBarcode=b.FormBarcode)
Begin 
	Select a.FormBarcode,c.FormDescription From InvInwardRegisterDetails a,@TblForms b,FormMaster c Where a.FormBarcode=b.FormBarcode ANd a.FormId=c.FormId 
	Set @Message='Form(s) is/are already present in Inward Register..Please click Reject button to view details...'
	Set @ControlNo=2
	Return 	
End
--------------------------------------------------------------------------------------------------
---- Check for Forms in InvVendorInwardData if not present then display message or if present in different form
Insert Into @TblPresentFormsInVendorInwardData Select a.FormBarcode,a.FormId,c.FormDescription 
From InvVendorInwardData a,@TblForms b,FormMaster c Where a.FormBarcode=b.FormBarcode And a.FormId=c.FormId

Insert Into @TblFormsNotInVendorInwardData Select a.FormBarcode,b.FormDescription From @TblForms a,FormMaster b 
Where b.FormId=@FormId And a.FormBarcode Not In (Select FormBarcode From @TblPresentFormsInVendorInwardData)

If Exists(Select top 1 FormBarcode From @TblFormsNotInVendorInwardData)
Begin 
	Select * From @TblFormsNotInVendorInwardData
	Set @Message='Form(s) is/are not present in Vendor Inward Data..Please click Reject button to view details...'
	Set @ControlNo=2
	Return 	
End

If Exists(Select top 1 FormBarcode From @TblPresentFormsInVendorInwardData Where FormId<>@FormId)
Begin 
	Select FormBarcode,FormDesc From @TblPresentFormsInVendorInwardData Where FormId<>@FormId
	Set @Message='Form(s) is/are present for different Form Description in Vendor Inward Data..Please click Reject button to view details...'
	Set @ControlNo=2
	Return 	
End
--------------------------------------------------------------------------------------------------
If @JobcardNo='TOBEGENERA'  
Begin  
	Select @JobcardNo='IN' +  RIGHT('00000000' +  Cast(coalesce(max(substring(InwardJCNo,3,len(InwardJCNo))),0) + 1 As Varchar(10)),8) From InvInwardRegisterHeader  
	Insert into InvInwardRegisterHeader(InwardJCNo,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime) values  
	(@JobcardNo,@FormId,@NoOfForms,@EmpId,@DeDate,@DeTime)  
End  
  
Insert into InvInwardRegisterDetails(InwardJCNo,FormBarcode,FormId,DispToKYC,DispToCSO,ReceiptAtCSO,DispToBranch,
EmpId,DeDate,DeTime,LotId) 
Select @JobcardNo,FormBarcode,@FormId,0,0,0,0,@EmpId,@DeDate,@DeTime,@LotId From @TblForms
  
Set @Message='SUCCESS'              
--------------------------------------------------------------------------------------------------
End Try
Begin Catch
	DECLARE @ErSeverity INT,@ErState INT            
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
	Set @ControlNo=99              
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
	RAISERROR (@Message,@ErSeverity,@ErState)                     
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranInwardRegister
-- --------------------------------------------------
CREATE proc [dbo].[InvTranInwardRegister] (@JobcardNo varchar(10) output,@FormBarcode varchar(10), @FormId varchar(10),  
@EmpId varchar(10),@LotId varchar(10), @Message varchar(250) output, @ControlNo int output )  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime  
Declare @DeTime Datetime 
Declare @FormDesc Varchar(50) 
  
Set @ControlNo=0          
Set @Message=''   
  
Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)   

if exists (select * from InvInwardRegisterHeader where InwardJCNo=@JobcardNo)	
	begin
		if not exists (Select * from InvInwardRegisterHeader where InwardJCNo=@JobcardNo and 
		FormId = @FormId)
		begin
			set @Message='Inward Jobcard has already linked to another Form.  Cannot process.'
			Set @ControlNo=1
			return
		end
	end

if exists(select formbarcode from InvInwardRegisterDetails where FormBarcode=@FormBarcode)  
 begin  
	set @Message='Form Barcode already exists.'  
	Set @ControlNo=2
	return  
 end  

if not exists(select formbarcode from InvVendorInwardData where FormBarcode=@FormBarcode)  
 begin  
	set @Message='Form Barcode does not exist in Vendor Inward Data...'  
	Set @ControlNo=2
	return  
 end  

if exists(select formbarcode from InvVendorInwardData where FormBarcode=@FormBarcode And FormId<>@FormId)  
 begin  
	Select @FormDesc=FormDescription From InvVendorInwardData a,FormMaster b WHere a.FormId=b.FormId And FormBarcode=@FormBarcode
	set @Message='Form Barcode exists in another Form Description: ' + @FormDesc + ' in Vendor Inward Data...'  
	Set @ControlNo=2
	return  
 end
  
if @JobcardNo ='TOBEGENERA'  
 begin  
 Select @JobcardNo='IN' +  RIGHT('00000000' +  Cast(coalesce(max(substring(InwardJCNo,3,len(InwardJCNo))),0) + 1 As Varchar(10)),8)  
 From InvInwardRegisterHeader  
 Insert into InvInwardRegisterHeader(InwardJCNo,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime) values  
 (@JobcardNo,@FormId,0,@EmpId,@DeDate,@DeTime)  
 end  
  
 Insert into InvInwardRegisterDetails(InwardJCNo,FormBarcode,FormId,DispToKYC,DispToCSO,ReceiptAtCSO,DispToBranch,EmpId,  
 DeDate,DeTime,LotId) values (@JobcardNo,@FormBarcode,@FormId,0,0,0,0,@EmpId,@DeDate,@DeTime,@LotId)  
 Update InvInwardRegisterHeader set FormCount=FormCount+1 where InwardJCNo=@JobcardNo and FormId=@FormId  
  
Set @Message='SUCCESS'              
         
End Try                
          
Begin Catch                
          
 DECLARE @ErSeverity INT,@ErState INT            
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
 Set @ControlNo=99              
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
 RAISERROR (@Message,@ErSeverity,@ErState)                     
            
End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranReceiptOfForms
-- --------------------------------------------------

CREATE proc InvTranReceiptOfForms (@ReceiptJCNo varchar(10) output,@FormBarcode varchar(10), @FormId varchar(10),  
@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output )  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime  
Declare @DeTime Datetime  
  
Set @ControlNo=0          
Set @Message=''   
  
Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)   

if exists (select * from InvReceiptHeader where ReceiptJCNo=@ReceiptJCNo)
	
	begin
		if not exists (Select * from InvReceiptHeader where ReceiptJCNo=@ReceiptJCNo and 
		FormId = @FormId)
		begin
			set @Message='Receipt Jobcard has already linked to another Form.  Cannot process.'
			return
		end
	end
  
--if not exists(select formbarcode from InvDispToCSODetails where FormBarcode=@FormBarcode AND FormId =@FormId)  
-- begin  
--  set @Message='Form not sent by KYC team after franking or mismatch between form and form type'  
--  return  
-- end  

If Not Exists(Select FormBarcode From InvInwardRegisterDetails Where FormBarcode=@FormBarcode And FormId=@FormId)
Begin
	Set @Message='Form not received from the printer or mismatch between form and form type...' 
	Return
End

If Not Exists(Select FormId From FormMaster Where FormId=@FormId And FormTypeId='FRMTYPE001')
Begin
	Set @Message='Only Franked Forms are allowed..'
	Return
End
  
if exists(select formbarcode from InvReceiptDetails where FormBarcode=@FormBarcode)  
 begin  
  set @Message='Franked Form has already received at CSO.'  
  return  
 end  
  
if @ReceiptJCNo ='TOBEGENERA'  
 begin  
 Select @ReceiptJCNo='RC' +  RIGHT('00000000' +  Cast(coalesce(max(substring(ReceiptJCNo,3,len(ReceiptJCNo))),0) + 1 As Varchar(10)),8)  
 From InvReceiptHeader  
 insert into InvReceiptHeader(ReceiptJCNo,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime) values  
 (@ReceiptJCNo,@FormId,0,@EmpId,@DeDate,@DeTime)  
 end  
  
 insert into InvReceiptDetails(ReceiptJCNo,FormBarcode,FormId,EmpId,DeDate,DeTime)  
 values (@ReceiptJCNo,@FormBarcode,@FormId,@EmpId,@DeDate,@DeTime)  
  
 Update InvReceiptHeader set FormCount=FormCount+1 where ReceiptJCNo=@ReceiptJCNo and FormId=@FormId  
 Update InvInwardRegisterDetails set ReceiptAtCSO =1 where FormBarcode=@FormBarcode  
  
Set @Message='SUCCESS'              
         
End Try                
          
Begin Catch                
          
 DECLARE @ErSeverity INT,@ErState INT            
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
 Set @ControlNo=99              
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
 RAISERROR (@Message,@ErSeverity,@ErState)                     
            
End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranReceiptUsedForms
-- --------------------------------------------------
CREATE proc [dbo].[InvTranReceiptUsedForms] (@UsedFormsJcNo varchar(10) output, @BranchId varchar(10),@FormId varchar(10),
@FormBarcode varchar(10), @EmpId varchar(10), @Message varchar(250) output, @ControlNo int output )
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0        
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
if exists (select * from InvUsedFormsHeader where UsedFormsJcNo=@UsedFormsJcNo)
	
	begin
		if not exists (Select * from InvUsedFormsHeader where UsedFormsJcNo=@UsedFormsJcNo and 
		branchid = @BranchId)
		begin
			set @Message='Used Form Jobcard has already linked to another branch.  Cannot process.'
			return
		end
		if not exists (Select * from InvUsedFormsHeader where UsedFormsJcNo=@UsedFormsJcNo and 
		FormId = @FormId)
		begin
			set @Message='Used Form Jobcard has already linked to another Form.  Cannot process.'
			return
		end	
	end

if not exists(select formbarcode from InvDispToBranchDetails  where FormBarcode=@FormBarcode AND FormId =@FormId)
	begin
		set @Message='Form has not sent to branch or mismatch between form and form type'
		Set @ControlNo=1
		return
	end

if exists(select formbarcode from InvUsedFormsDetails where FormBarcode=@FormBarcode)
	begin
		set @Message='Used Form has already Received from branch..'
		Set @ControlNo=1
		return
	end
if not exists(select formbarcode from InvDispToBranchDetails  where FormBarcode=@FormBarcode AND branchid =@BranchId)
	begin
		set @Message='Form has not sent to selected branch. Please select proper branch name'
		Set @ControlNo=2
		return
	end


if @UsedFormsJcNo ='TOBEGENERA'
	begin
	Select @UsedFormsJcNo='US' +  RIGHT('00000000' +  Cast(coalesce(max(substring(UsedFormsJcNo,3,len(UsedFormsJcNo))),0) + 1 As Varchar(10)),8)
	From InvUsedFormsHeader
	insert into InvUsedFormsHeader(UsedFormsJcNo,BranchId,FormId,FormCount,CreatedBy,CreatedDate,CreatedTime)
	values	(@UsedFormsJcNo,@BranchId,@FormId,0,@EmpId,@DeDate,@DeTime)
	end

	insert into InvUsedFormsDetails(UsedFormsJcNo,BranchId,FormId,FormBarcode,EmpId,DeDate,DeTime)	
	values (@UsedFormsJcNo,@BranchId,@FormId,@FormBarcode,@EmpId,@DeDate,@DeTime)

	Update InvUsedFormsHeader set FormCount=FormCount+1 where UsedFormsJcNo=@UsedFormsJcNo and FormId=@FormId and
	BranchId =@BranchId

	Update InvInwardRegisterDetails set usedform =1 where FormBarcode=@FormBarcode

	update 	InvBranchConsumption set TotalUsedForms=TotalUsedForms+1 where branchid =@BranchId and  FormId=@FormId

Set @Message='SUCCESS'            
     
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranUploadInwardData
-- --------------------------------------------------

CREATE proc [dbo].[InvTranUploadInwardData](@FormId Varchar(10),@FormBarcode Varchar(10),@EmpId varchar(10),
	@Message varchar(250) output,@ControlNo int output)  
As
Begin Try
Set NoCount On
-------------------------------------------------
Declare @DeDate Datetime,@DeTime DateTime
Select @Message='',@ControlNo=0
  
Select @DeDate=convert(varchar(10),getdate(),120)  
Select @DeTime=Convert(varchar(10),getdate(),108)   
-------------------------------------------------
If @FormBarcode=''
Begin
	Set @Message='Form Barcode cannot be blank...'
	Return
End

If IsNumeric(@FormBarcode)=0
Begin
	Set @Message='Form Barcode should be in NUMBER format...'
	Return
End

If Exists(Select FormBarcode From InvVendorInwardData Where FormBarcode=@FormBarcode)
Begin
	Set @Message='Form Barcode already exists...'
	Return
End

Insert Into InvVendorInwardData(FormId,FormBarcode,EmpId,UploadDate,UploadTime) Values
(@FormId,@FormBarcode,@EmpId,@DeDate,@DeTime)

Set @Message='SUCCESS'


End Try
Begin Catch
	 DECLARE @ErSeverity INT,@ErState INT            
	 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                  
	 Set @ControlNo=99              
	 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
	 RAISERROR (@Message,@ErSeverity,@ErState) 
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranVendorChallanDetails
-- --------------------------------------------------
CREATE proc [dbo].[InvTranVendorChallanDetails](@VendoName varchar(50),@ChallanNo Varchar(30),@ChallanDate DateTime,
	@FormsQty BigInt,@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output, @VendorId varchar(10) output )
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0 
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
------------------------------------------------------------------
  
If @ChallanDate>Convert(Varchar(10),getdate(),120)     
	Begin  
		set @Message='Challan Date cannot be greater than today`s date...'  
		set @Controlno=1  
		return  
	End 

Select @VendorId='VN' +  RIGHT('00000000' +  Cast(coalesce(max(substring(VendorId,3,len(VendorId))),0) + 1 As Varchar(10)),8)  
From InvVendorDetails 

Insert into InvVendorDetails(VendorId,VendorName,ChallanNumber,ChallanDate,FormsQty,EmpId,DeDate,DeTime) values 
(@VendorId,@VendoName,@ChallanNo,@ChallanDate,@FormsQty,@EmpId,@DeDate,@DeTime)   

Set @Message='SUCCESS'            

End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranVendorChallanDetailsModify
-- --------------------------------------------------
CREATE proc [dbo].[InvTranVendorChallanDetailsModify](@VendorId varchar(10),@VendorName Varchar(50), @ChallanNo Varchar(30),@ChallanDate DateTime,
	@FormsQty BigInt,@EmpId varchar(10), @Message varchar(250) output, @ControlNo int output)  
as  
begin  
Begin Try                
Set Nocount on             
Declare @DeDate Datetime
Declare @DeTime Datetime

Set @ControlNo=0 
Set @Message='' 

Select @DeDate=convert(varchar(10),getdate(),120)
Select @DeTime=Convert(varchar(10),getdate(),108) 
------------------------------------------------------------------

If @ChallanDate>Convert(Varchar(10),getdate(),120)     
	Begin  
		set @Message='Challan Date cannot be greater than today`s date...'  
		set @Controlno=1  
		return  
	End 

Update InvVendorDetails Set VendorName=@VendorName,ChallanNumber=@ChallanNo,ChallanDate=@ChallanDate,
FormsQty=@FormsQty,EmpId=@EmpId,DeDate=@DeDate,DeTime=@DeTime Where VendorId=@VendorId

Set @Message='SUCCESS'              

End Try                

Begin Catch                

DECLARE @ErSeverity INT,@ErState INT            
Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')  
Set @ControlNo=99              
SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
RAISERROR (@Message,@ErSeverity,@ErState)                     

End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvTranVendorChallanGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvTranVendorChallanGetDetails](
	@VendorId varchar(10),@Message Varchar(250) Output
)  
As  
Begin Try 
Set NoCount On  

Set @Message=''  

If Not Exists(Select VendorId from InvVendorDetails Where VendorId=@VendorId)
Begin
	Set @Message='Vendor Id not found...'
	Return
End

Select VendorName,ChallanNumber,Convert(Varchar(10),ChallanDate,103) As 'ChallanDate',FormsQty from InvVendorDetails Where VendorId=@VendorId
  
Set @Message='SUCCESS' 

End Try  
Begin Catch              
	DECLARE @ErSeverity INT,@ErState INT    
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')          
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()       
	RAISERROR (@Message,@ErSeverity,@ErState)              
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvUserMasterAddModify
-- --------------------------------------------------
CREATE proc [dbo].[InvUserMasterAddModify] (@DMLAction varchar(5) output, @LoginId varchar(10), @UserPassword varchar(10),    
@FirstName varchar(20), @LastName varchar(20),@Branchid varchar(10),@UsertypeId varchar(5),@Email varchar(50),@ActiveStatus bit,    
@Message varchar(250) output,@ControlNo int output )  as      
begin            
            
begin try                        
	set nocount on                        
	Declare @CurrentDate datetime                        
	Declare @CurrentTime datetime    
	Declare @MaxNumber bigint    
	Declare @UsrId varchar(10)    
	Declare @GetType varchar(10)    

	Select @CurrentTime= convert(varchar(12),getdate(),108)                                          
	select @CurrentDate=convert(varchar(10),getdate(),120)                         
	begin tran          
		Set @Message=''                        
		Set @ControlNo=0        

		if @DMLAction ='ADD'    
			begin      
				if exists (select * from InvEmployeeMaster where loginId =@Loginid)    
					begin    
						rollback tran    
						Set @Message='Login Id cannot be duplicate..'                   
						Set @ControlNo=1      
						return     
					end    

				Select @MaxNumber=Coalesce(Max(SubString(EmpId,4,Len(EmpId))),0)+1 From InvEmployeeMaster               
				Set @UsrId='EMP' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)        

				Insert into InvEmployeeMaster(EmpId,LoginId,EmpPassword,FirstName,LastName,Branchid,UsertypeId,DeDate,Detime,ActiveStatus,    
				EmailId) values(@UsrId,@LoginId,@UserPassword,@FirstName,@LastName,@Branchid,@UsertypeId,@CurrentDate,@CurrentTime,@ActiveStatus,    
				@Email)    
				insert into InvEmpMenuRightsMaster(EmpId,menuId) select @UsrId, menuid from InvUserTypeMenuRightsMaster where     
				usertypeid = @UsertypeId     
			end    

		if @DMLAction ='MODIF'    
			BEGIN    

				select @GetType= UsertypeId,@UsrId=EmpId from InvEmployeeMaster where loginid=@LoginId    

				if @GetType <> @UsertypeId    
					begin    
						delete from InvEmpMenuRightsMaster where EmpId =@UsrId
						insert into InvEmpMenuRightsMaster(EmpId,menuId) select @UsrId, menuid from InvUserTypeMenuRightsMaster    
						where usertypeid=@UsertypeId     	
					end  

					Update InvEmployeeMaster set Firstname=@FirstName, LastName =@LastName,branchid =@Branchid,UserTypeId =@UsertypeId,
					ActiveStatus=@ActiveStatus,EmailId=@Email where LoginId=@LoginId		  

			end    

commit tran     
Set @Message='SUCCESS'                        
Set @ControlNo=0    

end try                        
Begin Catch     
	rollback tran                                    
	DECLARE @ErSeverity INT,@ErState INT                              

	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                    
	Set @ControlNo=99                            
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                 
	RAISERROR (@Message,@ErSeverity,@ErState)                                         
End Catch                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvUserMasterGetDetails
-- --------------------------------------------------
CREATE Procedure [dbo].[InvUserMasterGetDetails](@LoginId Varchar(10),@SessionLoginId varchar(10),@Message Varchar(250) Output)  
As  
Begin Try 
Set NoCount On  
  
Set @Message=''  
  
If @LoginId=@SessionLoginId
Begin   
	Set @Message='Login Id is in use. Cannot modify any changes.'  
	Return  
End  

If Not Exists(Select LoginId From InvEmployeeMaster Where LoginId=@LoginId)  
Begin   
	Set @Message='LoginId does not exist'  
	Return  
End  
  
Set @Message='SUCCESS'  
Select FirstName,LastName,EmailId,BranchId,UserTypeId,ActiveStatus From InvEmployeeMaster Where LoginId=@LoginId  
  
End Try  
Begin Catch              
	DECLARE @ErSeverity INT,@ErState INT    
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')          
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()       
	RAISERROR (@Message,@ErSeverity,@ErState)              
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvUserTypeWiseSaveRights
-- --------------------------------------------------
  
  
CREATE Procedure [dbo].[InvUserTypeWiseSaveRights]        
(        
	@UserTypeId Varchar(5) Output,@UserType Varchar(50),@MenuId Varchar(10),@ActiveStatus Int,@IsDelete Varchar(5),  
	@EmpId Varchar(10),@Message Varchar(200) Output,@ControlNo int Output        
)        
As        
Begin Try    
  
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)  
Select @Message='',@ControlNo=0  
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)  
---------------------------------------------------------------------------------------------------------------  
If Not Exists(Select UserTypeId From InvUserTypeMaster Where UserTypeId=@UserTypeId)  
Begin  	
	if Exists(select * from InvUserTypeMaster where Description =@UserType)
		begin	
			set @Message ='User type has already exists...'
			Set @ControlNo=99
			return
		end	
	Select @MaxNumber=Coalesce(Max(SubString(UserTypeId,3,Len(UserTypeId))),0)+1 From InvUserTypeMaster      

	Set @UserTypeId='UT' + RIGHT('000' +  Cast(@MaxNumber As Varchar(10)),3)     

	Insert Into InvUserTypeMaster(UsertypeId,Description,EmpId,DeDate,DeTime,Status) Values(@UserTypeId,@UserType,  
	@EmpId,@DeDate,@DeTime,1)  
End  
---------------------------------------------------------------------------------------------------------------  
--- If exists then delete all rights one time only  
If @IsDelete='YES'  
Begin  
	Delete From InvUserTypeMenuRightsMaster Where UserTypeId=@UserTypeId  
	Update InvUserTypeMaster Set Status=@ActiveStatus Where UserTypeId=@UserTypeId  
End  
---------------------------------------------------------------------------------------------------------------  
Insert Into InvUserTypeMenuRightsMaster(UsertypeId,MenuId,EmpId,DeDate,Detime) Values (@UserTypeId,@MenuId,  
@EmpId,@DeDate,@DeTime)  
  
Set @Message='SUCCESS'  
  
End Try  
Begin Catch              
	DECLARE @ErSeverity INT,@ErState INT    
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')          
	Set @ControlNo=99  
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()       
	RAISERROR (@Message,@ErSeverity,@ErState)              
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.InvUserWiseSaveRights
-- --------------------------------------------------
CREATE Procedure [dbo].[InvUserWiseSaveRights]      
(      
	@EmpId Varchar(10),@MenuId Varchar(10),@IsDelete Varchar(5),@Message Varchar(200) Output,@ControlNo int Output      
)      
As      
Begin Try  

Select @Message='',@ControlNo=0
---------------------------------------------------------------------------------------------------------------
--- If exists then delete all rights one time only
If @IsDelete='YES'
Begin
	Delete From InvEmpMenuRightsMaster Where EmpId=@EmpId
End
---------------------------------------------------------------------------------------------------------------
Insert Into InvEmpMenuRightsMaster(EmpId,MenuId) Values (@EmpId,@MenuId)
Set @Message='SUCCESS'

End Try
Begin Catch            
	DECLARE @ErSeverity INT,@ErState INT  
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')        
	Set @ControlNo=99
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()     
	RAISERROR (@Message,@ErSeverity,@ErState)            
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.KYCMasterSaveDetails
-- --------------------------------------------------
CREATE Procedure KYCMasterSaveDetails 
(
	@KycDocId Varchar(10),@KycDocuments varchar(100),@UserId Varchar(10),@Message varchar(250) output,
	@ControlNo int output 
)  
As        
Begin Try           
Set NoCount On
-----------------------------------------------------------------------------------------------              
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)
Select @Message='',@ControlNo=0
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)
-----------------------------------------------------------------------------------------------   
If @KycDocId=''
Begin

If Exists(Select KycDocId From KYCMaster Where KycDocuments=@KycDocuments)
Begin
	Set @Message='Kyc Document already exist...'
	Return
End

Select @MaxNumber=Coalesce(Max(SubString(KycDocId,4,Len(KycDocId))),0)+1 From KYCMaster                 
Set @KycDocId='KYC' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)     

Insert Into KYCMaster(KycDocId,KycDocuments,UserId,DeDate,DeTime) Values
(@KycDocId,@KycDocuments,@UserId,@DeDate,@DeTime)

End

Else ---------------------------
Begin

If Exists(Select KycDocuments From KYCMaster Where KycDocuments=@KycDocuments And KycDocId<>@KycDocId)
Begin
	Set @Message='KYC Document description already exist for another KYC Document...'
	Return
End

Update KYCMaster Set KycDocuments=@KycDocuments Where KycDocId=@KycDocId

End
       
Set @Message='SUCCESS'                            
  
End Try                        
Begin Catch       
                                   
	DECLARE @ErSeverity INT,@ErState INT                                
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                      
	Set @ControlNo=99                              
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
	RAISERROR (@Message,@ErSeverity,@ErState) 
                                          
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MasterReportsList
-- --------------------------------------------------
CREATE Procedure MasterReportsList
As
Begin
Set NoCount On

Select Replace(MenuCaption,' ','') As 'ReportType',MenuCaption As 'ReportDesc' From MenuMaster Where MenuGroup='MNU0000001'
Union All
Select 'UserTypeWiseRights' As 'ReportType','User Type Wise Rights' As 'ReportDesc'
Union All
Select 'UserWiseRights' As 'ReportType','User Wise Rights' As 'ReportDesc'

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoFileHistory
-- --------------------------------------------------

CREATE proc RepoFileHistory(@Filebarcode varchar(15),@ModuleType Varchar(6),@Message Varchar(250) Output)
as 
begin
set nocount on
Declare @FileModuleType Varchar(6)
Set @Message=''
------------------------------------------------------------------------------------------------      
If Not Exists(Select top 1 * From RetrievalDatadetails Where filebarcode=@Filebarcode)          
Begin          
  Set @Message='File Barcode not found...'          
  Return          
End          
------------------------------------------------------------------------------------------------         
Select @FileModuleType=ModuleType From RetrievalDataHeader a,RetrievalDatadetails b Where a.WorkOrderNo=b.WorkOrderNo And FileBarcode=@FileBarcode

If @FileModuleType<>@ModuleType 
Begin
	If @ModuleType='KYC'
		Set @Message='File belongs to Non-KYC...'
	Else
		Set @Message='File belongs to KYC...'
	Return
End
------------------------------------------------------------------------------------------------ 
set @Message='SUCCESS'

If @ModuleType='KYC' 
	select a.FileBarcode,d.ClientCode, b.WorkOrderNo, b.OrderDate, au.PersonName 'Authorised Person', doc.DocDescription,
	ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date',
	case when INStatus = 1 then 'IN' else (Case when DtprnStatus=0 Then 'PROCESSING' Else 'OUT' End) end 'INOUT Status',
	convert(varchar, ref.Refiledate,103) 'Refile Date'
	from RetrievalDataHeader b inner join RetrievalDatadetails a on a.workorderno = b.workorderno  
	inner join AuthorisedPerson au on b.authorisedid = au.authorisedid inner join DocumentTypeMaster doc on b.docid = doc.docid 
	inner join RetrievalTypeMaster ret  on b.retrievalId = ret.retrievalid 
	inner join inventorydata d on d.FileBarcode=a.FileBarcode left outer join refiledata ref
	on a.filebarcode =ref.filebarcode and a.workorderno = ref.workorderno where a.filebarcode=@Filebarcode
Else
	select a.FileBarcode,d.MajorDecription As 'Major',d.MinorDescription As 'Minor',b.WorkOrderNo, b.OrderDate, 
	au.PersonName 'Authorised Person', doc.DocDescription,ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, 
	convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date',
	case when INStatus = 1 then 'IN' else (Case when DtprnStatus=0 Then 'PROCESSING' Else 'OUT' End) end 'INOUT Status',
	convert(varchar, ref.Refiledate,103) 'Refile Date'
	from RetrievalDataHeader b inner join RetrievalDatadetails a on a.workorderno = b.workorderno  
	inner join AuthorisedPerson au on b.authorisedid = au.authorisedid inner join DocumentTypeMaster doc on b.docid = doc.docid 
	inner join RetrievalTypeMaster ret  on b.retrievalId = ret.retrievalid 
	inner join NonKYCDocumentsArachive d on d.FileBarcode=a.FileBarcode left outer join refiledata ref
	on a.filebarcode =ref.filebarcode and a.workorderno = ref.workorderno where a.filebarcode=@Filebarcode

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoFileOut
-- --------------------------------------------------

CREATE proc RepoFileOut (@FromDate datetime, @ToDate datetime,@BranchId varchar(10),@ModuleType Varchar(6),
@Message Varchar(250) Output )  
as   
begin  
set nocount on  
------------------------------------------------------------------------------------------------    
If @ToDate<@FromDate  
Begin            
  Set @Message='To Date cannot be less than From Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------           
If @ToDate>Convert(Varchar(10),getdate(),120)            
Begin            
  Set @Message='To Date cannot be greater than Today`s Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
If DateDiff(Day,@FromDate,@ToDate)>30            
Begin            
  Set @Message='Date Range difference cannot be greater than 30 days...'            
  Return            
End            
------------------------------------------------------------------------------------------------                 
Set @Message='SUCCESS'     

If @ModuleType='KYC'  
	select a.FileBarcode,d.ClientCode, b.WorkOrderNo, b.OrderDate, au.PersonName 'Authorised Person', doc.DocDescription,  
	ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date'  
	from RetrievalDataHeader b, RetrievalDatadetails a,  
	AuthorisedPerson au,DocumentTypeMaster doc, RetrievalTypeMaster ret,InventoryData d   
	where a.workorderno = b.workorderno and b.authorisedid = au.authorisedid and b.docid = doc.docid and   
	b.retrievalId = ret.retrievalid and d.FileBarcode=a.FileBarcode And a.INStatus=0 and
	a.DtprnDate between @FromDate and @ToDate and a.branchid =@BranchId And b.ModuleType=@ModuleType
Else
	select a.FileBarcode,d.MajorDecription As 'Major',d.MinorDescription As 'Minor',b.WorkOrderNo, b.OrderDate, 
	au.PersonName 'Authorised Person', doc.DocDescription,ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, 
	convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date'  
	from RetrievalDataHeader b, RetrievalDatadetails a,  
	AuthorisedPerson au,DocumentTypeMaster doc, RetrievalTypeMaster ret,NonKYCDocumentsArachive d   
	where a.workorderno = b.workorderno and b.authorisedid = au.authorisedid and b.docid = doc.docid and   
	b.retrievalId = ret.retrievalid and d.FileBarcode=a.FileBarcode And a.INStatus=0 and
	a.DtprnDate between @FromDate and @ToDate and a.branchid =@BranchId And b.ModuleType=@ModuleType

  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoInventoryDataBoxwise
-- --------------------------------------------------

CREATE proc RepoInventoryDataBoxwise (@DocType char(6), @Boxwise varchar(12), @Message varchar(250) output)  
as  
begin  
Begin Try                
Set Nocount on   

Set @Message='SUCCESS'      

if @DocType ='KYC'   
	begin  
		select a.FileBarcode,a.Boxbarcode,a.FormNumber,a.ClientCode,a.ClientName,a.Segment,a.FormType,('''' + a.DpId) As 'DpId',
		a.ActivationDate, a.PancardNo,w.StorageLocation, p.PersonName,d.DepartmentDesc 
		from InventoryData a, storagelocationmaster w,  authorisedperson p, departmentmaster d  
		where a. storagelocid = w.storagelocid and a.authorisedid = p.authorisedid and a.departmentid =d.departmentid and  
		a.Boxbarcode =@Boxwise  
	end  
  
if @DocType ='NONKYC'   
	begin  
		select a.FileBarcode,a.Boxbarcode,a.MajorDecription,a.MinorDescription,a.Fromdate,a.ToDate,a.FromNumber,  
		a.ToNumber, w.StorageLocation, p.PersonName,d.DepartmentDesc 
		from NonKYCDocumentsArachive a, storagelocationmaster w,authorisedperson p , departmentmaster d 
		where a. storagelocid = w.storagelocid and a.authorisedid = p.authorisedid and   
		a.departmentid =d.departmentid and a.Boxbarcode =@Boxwise  
	end          
         
End Try                
          
Begin Catch                
          
 DECLARE @ErSeverity INT,@ErState INT            
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                   
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()               
 RAISERROR (@Message,@ErSeverity,@ErState)                     
            
End Catch     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoInventoryDataDepartmentwise
-- --------------------------------------------------

CREATE proc RepoInventoryDataDepartmentwise (@DocType char(6), @DeptId varchar(10), @Message varchar(250) output)
as
begin
Begin Try              
Set Nocount on 

Set @Message='SUCCESS'   

if @DocType ='KYC' 
	begin
		select a.FileBarcode,a.Boxbarcode,a.FormNumber,a.ClientCode,a.ClientName,a.Segment,a.FormType,
		('''' + a.DpId) As 'DpId',a.ActivationDate, a.PancardNo,w.StorageLocation, p.PersonName 
		from InventoryData a, storagelocationmaster w, 	authorisedperson p where
		a. storagelocid = w.storagelocid and a.authorisedid = p.authorisedid and a.departmentid =@DeptId
	end

if @DocType ='NONKYC' 
	begin
		select a.FileBarcode,a.Boxbarcode,a.MajorDecription,a.MinorDescription,a.Fromdate,a.ToDate,a.FromNumber,
		a.ToNumber,	w.StorageLocation, p.PersonName from NonKYCDocumentsArachive a, storagelocationmaster w, 	
		authorisedperson p where a. storagelocid = w.storagelocid and a.authorisedid = p.authorisedid and 
		a.departmentid =@DeptId
	end         
       
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                 
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoKYCInsertion
-- --------------------------------------------------
CREATE proc RepoKYCInsertion (@FromDate datetime, @ToDate datetime,@Branchid varchar(10),@Message Varchar(250) Output)    
as     
begin    
set nocount on    
------------------------------------------------------------------------------------------------      
If @ToDate<@FromDate  
Begin            
  Set @Message='To Date cannot be less than From Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------           
If @ToDate>Convert(Varchar(10),getdate(),120)            
Begin            
  Set @Message='To Date cannot be greater than Today`s Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
If DateDiff(Day,@FromDate,@ToDate)>30            
Begin            
  Set @Message='Date Range difference cannot be greater than 30 days...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
If Not Exists(Select top 1 * From KYCInsertionDetails Where DeDate between @FromDate and @ToDate)            
Begin            
  Set @Message='No records found...'            
  Return            
End            
------------------------------------------------------------------------------------------------           
If (Select Count(*) From KYCInsertionDetails Where DeDate between @FromDate and @ToDate)>60000         
Begin            
  Set @Message='Data is too large..Please decrease date difference or Contact system administrator...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
Set @Message='SUCCESS'     
    
select a.FileBarcode,d.ClientCode,c.KycDocuments, a.OtherRemarks,b.FirstName,    
convert(varchar, a.deDate,103) 'Data Entry Date' from    
KYCInsertionDetails a ,usermaster b,KYCMaster c,InventoryData d   
where a.UserId = b.userid and a.KYCDocId=c.KYCDocId And a.FileBarcode=d.FileBarcode And   
a.DeDate between @FromDate and @ToDate and a.branchid =@Branchid
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoManualDataEntry
-- --------------------------------------------------

CREATE proc RepoManualDataEntry (@FromDate datetime, @ToDate datetime,@Branchid varchar(10), @ModuleType char(6), @Message Varchar(250) Output)      
as       
begin      
set nocount on      
------------------------------------------------------------------------------------------------        
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
Set @Message='SUCCESS'       

if @ModuleType ='KYC'      
	begin
	Select a.FileBarcode,a.BoxBarcode,a.FormNumber, a.ClientCode, a.ClientName,a.Segment,a.FormType,       
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',a.ActivationDate,a.PancardNo,    
	c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,
	convert(varchar, a.deDate,103) 'Data Entry Date' from        
	inventorydata a ,usermaster b,StorageLocationMaster c,DepartmentMaster d,AuthorisedPerson ap        
	where a.Dataentryby = b.userid and a.StorageLocId=c.StorageLocId and a.departmentid=d.departmentid And 
	a.AuthorisedId=ap.AuthorisedId And a.DeDate between @FromDate and @ToDate      
	And a.ManualEntryStatus=1  and a.branchid = @Branchid  
	end

if @ModuleType ='NONKYC'
	begin
	select a.FileBarcode,a.BoxBarcode, a.MajorDecription As 'Major', a.MinorDescription As 'Minor', 
	convert(varchar,a.FromDate,103) as FromDate,convert(varchar,a.ToDate,103) as ToDate,     	
	a.FromNumber,a.ToNumber,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName, 	
	convert(varchar, a.deDate,103) 'Data Entry Date' from      
	NonKYCDocumentsArachive a , usermaster b,StorageLocationMaster c,DepartmentMaster d,AuthorisedPerson ap     
	where a.empid = b.userid and a.StorageLocId=c.StorageLocId and a.departmentid=d.departmentid And 
	a.AuthorisedId=ap.AuthorisedId and a.DeDate between @FromDate and @ToDate And a.ManualEntryStatus=1 
	and a.branchid =@BranchId    
	end
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoMasterReports
-- --------------------------------------------------
CREATE proc RepoMasterReports(@ReportType Varchar(50),@Message Varchar(250) Output)    
As     
Begin    
Set NoCount ON  

Set @Message='Report is not available..Contact system administrator...'  
------------------------------------------------------------------------------------------------      
If @ReportType='UserTypeMaster'
Begin  -------------1

If Not Exists(Select top 1 * From UserTypeMaster)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From UserTypeMaster)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select UserTypeId,Description As 'UserType',Case Status When 1 Then 'Active' Else 'In-Active' End As 'Status' 
From UserTypeMaster Order By Description

End  -------------1            
------------------------------------------------------------------------------------------------              
If @ReportType='UserMaster'
Begin  -------------2

If Not Exists(Select top 1 * From UserMaster)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From UserMaster)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select a.UserId,a.LoginId,a.FirstName,a.LastName,b.Description As 'UserType',bm.BranchName,a.Email,
Case ActiveStatus When 1 Then 'Active' Else 'In-Active' End As 'Status' 
From UserMaster a,UserTypeMaster b,BranchMaster bm Where a.UserTypeId=b.UserTypeId And a.BranchId=bm.BranchId
Order By LoginId

End  -------------2           
------------------------------------------------------------------------------------------------  
If @ReportType='AuthorisedPerson'
Begin  -------------3

If Not Exists(Select top 1 * From AuthorisedPerson)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From AuthorisedPerson)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select a.AuthorisedId,a.PersonName,a.Email,bm.BranchName,d.DepartmentDesc,
Case a.ActiveStatus When 1 Then 'Active' Else 'In-Active' End As 'Status' 
From AuthorisedPerson a,BranchMaster bm,DepartmentMaster d 
Where a.BranchId=bm.BranchId And a.DepartmentId=d.DepartmentId
Order By a.PersonName

End  -------------3           
------------------------------------------------------------------------------------------------  
If @ReportType='BranchMaster'
Begin  -------------4

If Not Exists(Select top 1 * From BranchMaster)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From BranchMaster)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select BranchId,BranchName,Address,ContactPerson,Case Status When 1 Then 'Active' Else 'In-Active' End As 'Status' 
From BranchMaster Order By BranchName

End  -------------4     
------------------------------------------------------------------------------------------------  
If @ReportType='KYCMaster'
Begin  -------------5

If Not Exists(Select top 1 * From KYCMaster)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From KYCMaster)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select KycDocId,KycDocuments From KYCMaster Order By KycDocuments

End  -------------5     
------------------------------------------------------------------------------------------------  
If @ReportType='UserTypeWiseRights'
Begin  -------------6

If Not Exists(Select top 1 * From UserTypeMaster a,UserTypeMenuRightsMaster b Where a.UserTypeId=b.UserTypeId)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From UserTypeMaster a,UserTypeMenuRightsMaster b Where a.UserTypeId=b.UserTypeId)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select a.UserTypeId,a.Description As 'UserType',c.MenuCaption
From UserTypeMaster a,UserTypeMenuRightsMaster b,MenuMaster c 
Where a.UserTypeId=b.UserTypeId And b.MenuId=c.MenuId And a.Status=1 Order By a.Description,c.MenuSerialNo

End  -------------6 
------------------------------------------------------------------------------------------------  
If @ReportType='UserWiseRights'
Begin  -------------7

If Not Exists(Select top 1 * From UserMaster a,UserMenuRightsMaster b Where a.UserId=b.UserId)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From UserMaster a,UserMenuRightsMaster b Where a.UserId=b.UserId)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select a.UserId,a.LoginId,c.MenuCaption
From UserMaster a,UserMenuRightsMaster b,MenuMaster c 
Where a.UserId=b.UserId And b.MenuId=c.MenuId And a.ActiveStatus=1 Order By a.LoginId,c.MenuSerialNo

End  -------------7
------------------------------------------------------------------------------------------------  
If @ReportType='DepartmentMaster'
Begin  -------------8

If Not Exists(Select top 1 * From DepartmentMaster)
Begin
	Set @Message='No records found...'
	Return
End

If (Select Count(*) From DepartmentMaster)>60000           
Begin              
  Set @Message='Data is too large..Contact system administrator...'              
  Return              
End  

Set @Message='SUCCESS'
Select a.DepartmentId,a.DepartmentDesc,b.BranchName,
Case a.ActiveStatus When 1 Then 'Active' Else 'In-Active' End As 'Status' 
From DepartmentMaster a,BranchMaster b Where a.Branchid=b.BranchId Order By a.DepartmentDesc

End  -------------8    
------------------------------------------------------------------------------------------------  
 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoRefileDetails
-- --------------------------------------------------

CREATE proc RepoRefileDetails( @FromDate datetime, @ToDate datetime,@BranchId varchar(10),
@ModuleType Varchar(6),@Message Varchar(250) Output )    
as     
begin    
set nocount on    
------------------------------------------------------------------------------------------------    
If @ToDate<@FromDate  
Begin            
  Set @Message='To Date cannot be less than From Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------           
If @ToDate>Convert(Varchar(10),getdate(),120)            
Begin            
  Set @Message='To Date cannot be greater than Today`s Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
If DateDiff(Day,@FromDate,@ToDate)>30            
Begin            
  Set @Message='Date Range difference cannot be greater than 30 days...'            
  Return            
End            
------------------------------------------------------------------------------------------------               
Set @Message='SUCCESS'    

If @ModuleType='KYC'      
	select a.RefileJobcard, a.FileBarcode,c.ClientCode, a.WorkOrderNo, a.OrderDate,b.FirstName 'Refiled By',    
	convert(varchar, a.refiledate,103) 'Refile Date' from    
	refiledata a,usermaster b,inventorydata c,RetrievalDataHeader rdh 
	where a.refiledby = b.userid and c.filebarcode=a.filebarcode and a.WorkorderNo=rdh.WorkOrderNo And 
	rdh.ModuleType=@ModuleType And a.refiledate between @FromDate and @ToDate and a.branchid=@Branchid  
Else
	select a.RefileJobcard, a.FileBarcode,c.MajorDecription As 'Major',c.MinorDescription As 'Minor', 
	a.WorkOrderNo, a.OrderDate,b.FirstName 'Refiled By',convert(varchar, a.refiledate,103) 'Refile Date' from    
	refiledata a , usermaster b,NonKYCDocumentsArachive c,RetrievalDataHeader rdh 
	where a.refiledby = b.userid and c.filebarcode=a.filebarcode and a.WorkorderNo=rdh.WorkOrderNo And 
	rdh.ModuleType=@ModuleType And a.refiledate between @FromDate and @ToDate and a.branchid=@Branchid     
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoRetrievalClosedWo
-- --------------------------------------------------
CREATE proc RepoRetrievalClosedWo (@FromDate datetime, @ToDate datetime,@BranchId varchar(10),@Message Varchar(250) Output )    
as     
begin    
set nocount on    
------------------------------------------------------------------------------------------------      
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If Not Exists(Select top 1 * From RetrievalDataHeader Where OrderDate between @FromDate and @ToDate and branchid= @BranchId)              
Begin              
  Set @Message='No records found...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If (Select Count(*) From RetrievalDataHeader Where OrderDate between @FromDate and @ToDate and branchid =@BranchId)>60000           
Begin              
  Set @Message='Data is too large..Please decrease date difference or Contact system administrator...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
Set @Message='SUCCESS'       

select b.WorkOrderNo, b.OrderDate, au.PersonName 'Authorised Person', doc.DocDescription,ret.RetDescription,
b.DeliveryContact, b.DeliveryAddress,Case b.CloseStatus When 1 Then 'Closed' Else 'Open' End As 'CloseStatus',
IsNull(b.CloseRemarks,'') As 'CloseRemarks',IsNull(um.LoginId,'') As 'ClosedBy', 
Case b.CloseStatus When 1 Then Convert(Varchar(10),b.ClosedDate,103) Else '' End As 'ClosedDate',
Case b.CloseStatus When 1 Then Convert(Varchar(10),b.ClosedTime,108) Else '' End As 'ClosedTime'
from RetrievalDataHeader b
Inner Join AuthorisedPerson au On au.authorisedid = b.authorisedid
Inner Join DocumentTypeMaster doc On doc.docid = b.docid
Inner Join RetrievalTypeMaster ret On ret.retrievalId = b.retrievalid
Left Outer Join UserMaster um On um.UserId=b.ClosedBy
where b.OrderDate between @FromDate and @ToDate and b.branchid=@BranchId order by b.WorkOrderNo  
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoRetrievalDeletedFiles
-- --------------------------------------------------

CREATE proc RepoRetrievalDeletedFiles (@FromDate datetime, @ToDate datetime,@BranchId varchar(10),
@ModuleType Varchar(6),@Message Varchar(250) Output )      
as       
begin      
set nocount on      
------------------------------------------------------------------------------------------------        
If @ToDate<@FromDate      
Begin                
  Set @Message='To Date cannot be less than From Date...'                
  Return                
End                
------------------------------------------------------------------------------------------------               
If @ToDate>Convert(Varchar(10),getdate(),120)                
Begin                
  Set @Message='To Date cannot be greater than Today`s Date...'                
  Return                
End                
------------------------------------------------------------------------------------------------                
If DateDiff(Day,@FromDate,@ToDate)>30                
Begin                
  Set @Message='Date Range difference cannot be greater than 30 days...'                
  Return                
End                
------------------------------------------------------------------------------------------------                             
Set @Message='SUCCESS'         

If @ModuleType='KYC'  
	Select a.WorkOrderNo,a.FileBarcode,id.ClientCode,a.DeleteRemarks,Convert(Varchar(10),a.DeletedDate,103) As 'DeletedDate',  
	Convert(Varchar(10),a.DeletedTime,108) As 'DeletedTime',um.LoginId As 'DeletedBy',bm.BranchName  
	From RetrievalDeletedFiles a,BranchMaster bm,UserMaster um,InventoryData id,RetrievalDataHeader rdh  
	Where a.Branchid=bm.Branchid And a.DeletedBy=um.UserId And id.FileBarcode=a.FileBarcode And  
	a.WorkorderNo=rdh.WorkOrderNo And rdh.ModuleType=@ModuleType And a.DeletedDate between @FromDate and @ToDate 
	and a.branchid =@BranchId  
Else
	Select a.WorkOrderNo,a.FileBarcode,id.MajorDecription As 'Major',id.MinorDescription As 'Minor',a.DeleteRemarks,
	Convert(Varchar(10),a.DeletedDate,103) As 'DeletedDate',Convert(Varchar(10),a.DeletedTime,108) As 'DeletedTime',
	um.LoginId As 'DeletedBy',bm.BranchName  
	From RetrievalDeletedFiles a,BranchMaster bm,UserMaster um,NonKYCDocumentsArachive id,RetrievalDataHeader rdh    
	Where a.Branchid=bm.Branchid And a.DeletedBy=um.UserId And id.FileBarcode=a.FileBarcode And  
	a.WorkorderNo=rdh.WorkOrderNo And rdh.ModuleType=@ModuleType And a.DeletedDate between @FromDate and @ToDate 
	and a.branchid =@BranchId  
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoRetrievalMIS
-- --------------------------------------------------

CREATE proc RepoRetrievalMIS (@FromDate datetime, @ToDate datetime,@BranchId varchar(10),@ModuleType Varchar(6),
@Message Varchar(250) Output )      
as       
begin      
set nocount on      
------------------------------------------------------------------------------------------------        
If @ToDate<@FromDate      
Begin                
  Set @Message='To Date cannot be less than From Date...'                
  Return                
End                
------------------------------------------------------------------------------------------------               
If @ToDate>Convert(Varchar(10),getdate(),120)                
Begin                
  Set @Message='To Date cannot be greater than Today`s Date...'                
  Return                
End                
------------------------------------------------------------------------------------------------                
If DateDiff(Day,@FromDate,@ToDate)>30                
Begin                
  Set @Message='Date Range difference cannot be greater than 30 days...'                
  Return                
End 
------------------------------------------------------------------------------------------------            
Set @Message='SUCCESS'         

If @ModuleType='KYC'
	select a.FileBarcode,d.ClientCode,b.WorkOrderNo, b.OrderDate, au.PersonName 'Authorised Person', doc.DocDescription,      
	ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date',      
	case when INStatus = 1 then 'IN' else (Case when DtprnStatus=0 Then 'PROCESSING' Else 'OUT' End) end 'INOUT Status'
	from RetrievalDataHeader b, RetrievalDatadetails a,      
	AuthorisedPerson au,DocumentTypeMaster doc, RetrievalTypeMaster ret,InventoryData d       
	where a.workorderno = b.workorderno and b.authorisedid = au.authorisedid and b.docid = doc.docid and       
	b.retrievalId = ret.retrievalid and d.FileBarcode=a.FileBarcode And b.OrderDate between @FromDate and @ToDate      
	and a.branchid =@BranchId And b.ModuleType=@ModuleType order by b.WorkOrderNo 
Else
	select a.FileBarcode,d.MajorDecription As 'Major',d.MinorDescription As 'Minor',b.WorkOrderNo, b.OrderDate, 
	au.PersonName 'Authorised Person',doc.DocDescription,ret.RetDescription,b.DeliveryContact, b.DeliveryAddress, 
	convert(varchar, a.DtprnDate,103) 'Delivery Ticket Date',      
	case when INStatus = 1 then 'IN' else (Case when DtprnStatus=0 Then 'PROCESSING' Else 'OUT' End) end 'INOUT Status'
	from RetrievalDataHeader b, RetrievalDatadetails a,      
	AuthorisedPerson au,DocumentTypeMaster doc, RetrievalTypeMaster ret,NonKYCDocumentsArachive d       
	where a.workorderno = b.workorderno and b.authorisedid = au.authorisedid and b.docid = doc.docid and       
	b.retrievalId = ret.retrievalid and d.FileBarcode=a.FileBarcode And b.OrderDate between @FromDate and @ToDate      
	and a.branchid =@BranchId And b.ModuleType=@ModuleType order by b.WorkOrderNo 
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoTotalActivationData
-- --------------------------------------------------

CREATE proc RepoTotalActivationData  (@RepoOption varchar(10), @BranchId varchar(10),@FromDate datetime, 
@ToDate datetime,@ModuleType Varchar(6),@Message Varchar(250) Output )    
as     
Begin  -----------Main    
set nocount on    
------------------------------------------------------------------------------------------------      
If @ToDate<@FromDate  
Begin            
  Set @Message='To Date cannot be less than From Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------           
If @ToDate>Convert(Varchar(10),getdate(),120)            
Begin            
  Set @Message='To Date cannot be greater than Today`s Date...'            
  Return            
End            
------------------------------------------------------------------------------------------------            
If DateDiff(Day,@FromDate,@ToDate)>30            
Begin            
  Set @Message='Date Range difference cannot be greater than 30 days...'            
  Return            
End            
------------------------------------------------------------------------------------------------        
If @RepoOption='Details' ----------------------Details    
Begin    

Set @Message='SUCCESS'  

If @ModuleType='KYC'
	select a.FormNumber, a.ClientCode, a.ClientName,a.Exchange, a.Segment,a.FormType,   
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',   
	a.ActivationDate,a.PancardNo,b.FirstName 'Uploaded By',convert(varchar, a.deDate,103) 'Uploaded Date', 
	case when dataentrystatus =1 then 'DONE' else 'NOT DONE' end 'DataEntry Status',a.FileBarcode,
	convert(varchar, d.deDate,103) 'Data Entry Date'
	from activationdata a 
	Inner Join usermaster b On b.userid=a.userid
	Left Outer Join InventoryData d On d.FileBarcode=a.FileBarcode
	where a.DeDate between @FromDate and @ToDate and a.branchid =@Branchid
Else
	select a.MajorDecription As 'Major', a.MinorDescription As 'Minor',
	convert(varchar,a.FromDate,103) as FromDate,convert(varchar,a.ToDate,103) as ToDate,a.FromNumber,a.ToNumber,
	b.FirstName 'Uploaded By',convert(varchar, a.UploadedDate,103) 'Uploaded Date', 
	case when dataentrystatus =1 then 'DONE' else 'NOT DONE' end 'DataEntry Status',d.FileBarcode,
	convert(varchar, d.deDate,103) 'Data Entry Date'
	from NonKYCDocumentsDump a 
	Inner Join usermaster b On b.userid=a.UploadedBY
	Left Outer Join NonKYCDocumentsArachive d On d.TransId=a.TransId
	where a.UploadedDate between @FromDate and @ToDate and a.branchid =@Branchid        
   
End    ----------------------Details    
Else  
Begin  ----------------------Pending    
  
Set @Message='SUCCESS'  

If @ModuleType='KYC' 
	select a.FormNumber, a.ClientCode, a.ClientName,a.Exchange, a.Segment,a.FormType,   
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',   
	a.ActivationDate,a.PancardNo,b.FirstName 'Uploaded By',    
	convert(varchar, a.deDate,103) 'Uploaded Date' from activationdata a , usermaster b where a.userid = b.userid     
	and a.dataentrystatus = 0 and a.DeDate between @FromDate and @ToDate  and a.branchid =@Branchid  
Else
	select a.MajorDecription As 'Major', a.MinorDescription As 'Minor',
	convert(varchar,a.FromDate,103) as FromDate,convert(varchar,a.ToDate,103) as ToDate,a.FromNumber,a.ToNumber,
	b.FirstName 'Uploaded By',convert(varchar, a.UploadedDate,103) 'Uploaded Date' 
	from NonKYCDocumentsDump a,usermaster b where a.UploadedBY = b.userid     
	and a.dataentrystatus = 0 and a.UploadedDate between @FromDate and @ToDate and a.branchid =@Branchid        
  
End    ----------------------Pending        
  
  
End  -----------Main

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RepoTotalDataEntry
-- --------------------------------------------------

CREATE proc RepoTotalDataEntry (@FromDate datetime, @ToDate datetime,@BranchId varchar(10),@ModuleType char(6),
@Message Varchar(250) Output)      
as       
begin      
set nocount on      
------------------------------------------------------------------------------------------------        
If @ToDate<@FromDate    
Begin              
  Set @Message='To Date cannot be less than From Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------             
If @ToDate>Convert(Varchar(10),getdate(),120)              
Begin              
  Set @Message='To Date cannot be greater than Today`s Date...'              
  Return              
End              
------------------------------------------------------------------------------------------------              
If DateDiff(Day,@FromDate,@ToDate)>30              
Begin              
  Set @Message='Date Range difference cannot be greater than 30 days...'              
  Return              
End              
------------------------------------------------------------------------------------------------      

Set @Message='SUCCESS' 

if @ModuleType ='KYC'
	begin
	select a.FileBarcode,a.BoxBarcode, a.FormNumber, a.ClientCode, a.ClientName,a.Segment,a.FormType,     
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',     
	a.ActivationDate,a.PancardNo,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,      
	convert(varchar, a.deDate,103) 'Data Entry Date' from      
	inventorydata a , usermaster b,StorageLocationMaster c,DepartmentMaster d,AuthorisedPerson ap     
	where a.Dataentryby = b.userid and a.StorageLocId=c.StorageLocId and a.departmentid=d.departmentid And 
	a.AuthorisedId=ap.AuthorisedId And a.DeDate between @FromDate and @ToDate and a.branchid =@BranchId    
	end

if @ModuleType ='NONKYC'
	begin
	select a.FileBarcode,a.BoxBarcode, a.MajorDecription As 'Major', a.MinorDescription As 'Minor', 
	convert(varchar,a.FromDate,103) as FromDate,convert(varchar,a.ToDate,103) as ToDate,a.FromNumber,a.ToNumber,
	c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,
	convert(varchar, a.deDate,103) 'Data Entry Date' from      
	NonKYCDocumentsArachive a , usermaster b,StorageLocationMaster c,DepartmentMaster d,AuthorisedPerson ap     
	where a.empid = b.userid and a.StorageLocId=c.StorageLocId and a.departmentid=d.departmentid And 
	a.AuthorisedId=ap.AuthorisedId And a.DeDate between @FromDate and @ToDate and a.branchid=@BranchId    
	end
  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSGetLoginDetails
-- --------------------------------------------------
CREATE Procedure RMSGetLoginDetails           
(            
 @LoginId Varchar(10),@Password Varchar(10),@Message Varchar(250) Output           
)            
As            
Begin Try            
Set NoCount On           
        
Declare @UserId Varchar(10),@UserName Varchar(50),@Email Varchar(50),@ActiveStatus Bit ,@branchid varchar(10)      
        
Set @Message=''        
           
If Not Exists(Select UserId From UserMaster Where LoginId=@LoginId And UserPassword=@Password)            
Begin        
 Set @Message='Invalid UserName/Password...'        
 Return        
End        
      
Select @ActiveStatus=ActiveStatus,@UserId=UserId,@UserName=(FirstName + ' ' + LastName),@Email=IsNull(Email,''),      
@Loginid =Loginid,@branchid=branchid From UserMaster Where LoginId=@LoginId And UserPassword=@Password      
      
If @ActiveStatus=0      
Begin        
 Set @Message='In-Active User...'        
 Return        
End        
      
If @Email=''      
Begin        
 Set @Message='Email has not been set for user..Contact system administrator...'        
 Return        
End        
      
Set @Message='SUCCESS'        
Select @UserId As 'UserId',@UserName As 'UserName',@Email As 'Email',@Loginid As 'LoginId',@branchid as branchid  
        
End Try        
Begin Catch        
      
 Set @Message='Error occured at database level:' + Replace(ERROR_MESSAGE(),'''','`')                
 Return         
        
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSGetLoginMenu
-- --------------------------------------------------
    
CREATE Procedure RMSGetLoginMenu(@UserId Varchar(10))         
As        
Begin      
Select Upper(IsNull(MenuGroup,'MAIN')) As 'MenuGroup',Upper(MenuCaption) As 'MenuCaption',a.MenuId,NavigateURL  
From MenuMaster a,UserMenuRightsMaster b Where a.MenuId=b.MenuId And b.UserId=@UserId Order By MenuSerialNo  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSGetUserTypes
-- --------------------------------------------------
CREATE Procedure RMSGetUserTypes(@UserTypeId Varchar(5))       
As      
Begin  

If Upper(@UserTypeId)='ALL'
Begin
	Select UserTypeId,Description As 'UserType' From UserTypeMaster Order By UserType
End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSGetUserTypeWiseMenus
-- --------------------------------------------------
  
CREATE Procedure RMSGetUserTypeWiseMenus(@UserTypeId Varchar(5),@Mode Varchar(5))       
As      
Begin  

If Upper(@Mode)='NEW'
Begin

Select Upper(MenuGroup) As 'ParentId',MenuId,MenuCaption 
From MenuMaster Order By MenuSerialNo

End

Else ------------------------------------------------
Begin

Select Upper(MenuGroup) As 'ParentId',mm.MenuId,mm.MenuCaption,
(Case When IsNull(rm.UserTypeId,'')='' Then 'False' Else 'True' End) As 'IsChecked'
From MenuMaster mm
Left Outer Join UserTypeMenuRightsMaster rm On rm.MenuId=mm.MenuId And rm.UserTypeId=@UserTypeId
Order By mm.MenuSerialNo

End

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSGetUserWiseMenus
-- --------------------------------------------------
CREATE Procedure RMSGetUserWiseMenus(@LoginId Varchar(10),@SessionLoginId varchar(10) ,@UserId Varchar(10) Output,@Message Varchar(250) Output)         
As        
Begin    
  
Set @Message=''  

If @LoginId=@SessionLoginId
Begin  
 Set @Message='Login Id is in use.'  
 Return  
End    

If Not Exists(Select LoginId From UserMaster Where LoginId=@LoginId)  
Begin  
 Set @Message='Login Id does not exist'  
 Return  
End  
  
Select @UserId=UserId From UserMaster Where LoginId=@LoginId  
  
Set @Message='SUCCESS'  
Select Upper(MenuGroup) As 'ParentId',mm.MenuId,mm.MenuCaption,  
(Case When IsNull(rm.UserId,'')='' Then 'False' Else 'True' End) As 'IsChecked'  
From MenuMaster mm  
Left Outer Join UserMaster um On um.LoginId=@LoginId  
Left Outer Join UserMenuRightsMaster rm On rm.MenuId=mm.MenuId And rm.UserId=um.UserId  
  
Order By mm.MenuSerialNo  
  
  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSLoginGetPassword
-- --------------------------------------------------
CREATE Procedure RMSLoginGetPassword    
(        
	@UserName Varchar(30),@Message Varchar(250) Output       
)        
As        
Begin Try        
Set NoCount On       
    
Declare @Email Varchar(150),@Password Varchar(15),@MailDesc Varchar(Max),@DummyPassword Varchar(10)    
    
Set @Message=''    
       
If Not Exists(Select LoginId From UserMaster Where LoginId=@UserName)        
Begin    
	 Set @Message='Invalid User Name...'    
	 Return    
End    
    
Select @Password=UserPassword,@Email=IsNull(Email,'') From UserMaster Where LoginId=@UserName   
    
If @Email=''    
Begin    
	 Set @Message='Email Id is not updated...'    
	 Return    
End     
    
Set @DummyPassword='##**##**##'    
    
Set @MailDesc='<html><body><table border=1 width=100%>' +    
'<tr><td><strong>UserName</strong></td><td><strong>' + Upper(@UserName) + '</strong></td></tr>' +    
'<tr><td><strong>Password</strong></td><td><strong>' + @DummyPassword + '</strong></td></tr>' +    
'</table></body></html>'    
   
Select @Email As 'Email',@MailDesc As 'MailDesc',@Password As 'Password'    
    
Set @Message='SUCCESS'    
    
End Try    
Begin Catch    

 Set @Message='Error occured at database level:' + Replace(ERROR_MESSAGE(),'''','`')              
 Return    
    
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSUploadSaveData
-- --------------------------------------------------

CREATE Procedure RMSUploadSaveData              
(              
	@FormNumber Varchar(20),@ClientCode Varchar(20),@ClientName Varchar(250),@Exchange Varchar(100),      
	@Segment Varchar(100),@FormType Varchar(200),@DpId Varchar(20),@ActivationDate Datetime,@PancardNo Varchar(10),       
	@BranchId Varchar(10),@UserId Varchar(10),@Message VarChar(250) Output,@ControlNo int Output              
)              
As              
Begin Try                                    
Set NoCount On                  
-----------------------------------------------------------------------------              
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)                
-----------------------------------------------------------------------------              
Select @Message='',@ControlNo=0              
Select @DeDate=Convert(Varchar(10),GetDate(),120),@DeTime=Convert(Varchar(12),GetDate(),108)                
            
If @ActivationDate='1900-01-01'            
 Set @ActivationDate=NULL              
-----------------------------------------------------------------------------          
If Len(@FormNumber)>10      
Begin      
 Set @Message='Length of FORMNUMBER cannot be greater than 10...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@ClientCode)>15      
Begin      
 Set @Message='Length of CLIENTCODE cannot be greater than 15...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@ClientName)>50      
Begin      
 Set @Message='Length of CLIENTNAME cannot be greater than 50...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@Exchange)>50      
Begin      
 Set @Message='Length of EXCHANGE cannot be greater than 50...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@Segment)>40      
Begin      
 Set @Message='Length of SEGMENT cannot be greater than 40...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@FormType)>16      
Begin      
 Set @Message='Length of FORMTYPE cannot be greater than 16...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@DpId)>16      
Begin      
 Set @Message='Length of DPID cannot be greater than 16...'                                    
 Return          
End        
-----------------------------------------------------------------------------      
If Len(@PancardNo)>10      
Begin      
 Set @Message='Length of PANCARDNO cannot be greater than 10...'                                    
 Return          
End        
-----------------------------------------------------------------------------          
Insert Into ActivationData(FormNumber,ClientCode,ClientName,Exchange,Segment,FormType,DpId,ActivationDate,PancardNo,      
UserId,DeDate,DeTime,BranchId) Values              
(@FormNumber,@ClientCode,@ClientName,@Exchange,@Segment,@FormType,@DpId,@ActivationDate,@PancardNo,@UserId,@DeDate,      
@DeTime,@BranchId)              
              
Set @Message='SUCCESS'              
              
End Try              
Begin Catch                
              
	DECLARE @ErSeverity INT,@ErState INT                
	Set @ControlNo=0      
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                        
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                   
	RAISERROR (@Message,@ErSeverity,@ErState)               
                             
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSUserTypeWiseSaveRights
-- --------------------------------------------------
  
  
CREATE Procedure RMSUserTypeWiseSaveRights        
(        
 @UserTypeId Varchar(5) Output,@UserType Varchar(50),@MenuId Varchar(10),@ActiveStatus Int,@IsDelete Varchar(5),  
 @UserId Varchar(10),@Message Varchar(200) Output,@ControlNo int Output        
)        
As        
Begin Try    
  
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)  
Select @Message='',@ControlNo=0  
Select @DeDate=Convert(Varchar(10),GetDate(),120), @DeTime=Convert(Varchar(12),GetDate(),108)  
---------------------------------------------------------------------------------------------------------------  
If Not Exists(Select UserTypeId From UserTypeMaster Where UserTypeId=@UserTypeId)  
Begin  
 Select @MaxNumber=Coalesce(Max(SubString(UserTypeId,3,Len(UserTypeId))),0)+1 From UserTypeMaster      
  
 Set @UserTypeId='UT' + RIGHT('000' +  Cast(@MaxNumber As Varchar(10)),3)     
  
 Insert Into UserTypeMaster(UsertypeId,Description,Userid,DeDate,DeTime,Status) Values(@UserTypeId,@UserType,  
 @UserId,@DeDate,@DeTime,1)  
End  
---------------------------------------------------------------------------------------------------------------  
--- If exists then delete all rights one time only  
If @IsDelete='YES'  
Begin  
 Delete From UserTypeMenuRightsMaster Where UserTypeId=@UserTypeId  
 Update UserTypeMaster Set Status=@ActiveStatus Where UserTypeId=@UserTypeId  
End  
---------------------------------------------------------------------------------------------------------------  
Insert Into UserTypeMenuRightsMaster(UsertypeId,MenuId,userId,DeDate,Detime) Values (@UserTypeId,@MenuId,  
@UserId,@DeDate,@DeTime)  
  
Set @Message='SUCCESS'  
  
End Try  
Begin Catch              
 DECLARE @ErSeverity INT,@ErState INT    
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')          
 Set @ControlNo=99  
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()       
 RAISERROR (@Message,@ErSeverity,@ErState)              
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.RMSUserWiseSaveRights
-- --------------------------------------------------


CREATE Procedure RMSUserWiseSaveRights      
(      
	@UserId Varchar(10),@MenuId Varchar(10),@IsDelete Varchar(5),@Message Varchar(200) Output,@ControlNo int Output      
)      
As      
Begin Try  

Select @Message='',@ControlNo=0
---------------------------------------------------------------------------------------------------------------
--- If exists then delete all rights one time only
If @IsDelete='YES'
Begin
	Delete From UserMenuRightsMaster Where UserId=@UserId
End
---------------------------------------------------------------------------------------------------------------
Insert Into UserMenuRightsMaster(UserId,MenuId) Values (@UserId,@MenuId)
Set @Message='SUCCESS'

End Try
Begin Catch            
	DECLARE @ErSeverity INT,@ErState INT  
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')        
	Set @ControlNo=99
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()     
	RAISERROR (@Message,@ErSeverity,@ErState)            
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranCloseBoxSave
-- --------------------------------------------------

CREATE Proc TranCloseBoxSave(@BoxBarcode varchar(12),@Task Varchar(5),@UserId varchar(10),@Message varchar(250) output,
@ControlNo int output ) As      
Begin Try
            
Set nocount on                  
Declare @CurrentDate datetime,@CurrentTime datetime                  
Select @CurrentTime= convert(varchar(12),getdate(),108)                                    
select @CurrentDate=convert(varchar(10),getdate(),120)                   
      
Set @Message=''                  
Set @ControlNo=0  

If @Task='OPEN'
	Update BoxMaster Set CloseStatus=0,ClosedBy=NULL,ClosedDate=NULL,ClosedTime=NULL
	Where BoxBarcode=@BoxBarcode
Else
	Update BoxMaster Set CloseStatus=1,ClosedBy=@UserId,ClosedDate=@CurrentDate,ClosedTime=@CurrentTime 
	Where BoxBarcode=@BoxBarcode
 
Set @Message='SUCCESS'                  
           
                   
End Try                 
Begin Catch                               
	DECLARE @ErSeverity INT,@ErState INT                        
	              
	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                              
	Set @ControlNo=99                      
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                           
	RAISERROR (@Message,@ErSeverity,@ErState)                                   
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranDataEntry
-- --------------------------------------------------

CREATE Proc TranDataEntry (@StorageLocId varchar(10),@BoxBarcode Varchar(12),@Filebarcode varchar(15),    
@FormNumber varchar(10),@ClientCode varchar(15),@ClientName varchar(50), @Segment varchar(150),     
@FormType varchar(16), @DpId varchar(16),@ActivationDate datetime,@PancardNo varchar(10),@DepartmentId Varchar(10),
@AuthorisedId Varchar(10),@Branchid varchar(10),@UserId varchar(10),@Message varchar(250) output,@ControlNo int output) 
as          
begin          
    
 begin try                      
 set nocount on                      
 Declare @CurrentDate datetime                      
 Declare @CurrentTime datetime     
 DECLARE @MaxNumber bigint                      
 Select @CurrentTime= convert(varchar(12),getdate(),108)                                        
 select @CurrentDate=convert(varchar(10),getdate(),120)     
 Set @Message=''                      
 Set @ControlNo=0     
    
if @StorageLocId =''     
 begin    
  Set @Message='Select Storage Location..'                      
  Set @ControlNo=1    
  return    
 end    
    
if @BoxBarcode =''     
 begin    
  Set @Message='Boxbarcode cannot be blank...'                      
  Set @ControlNo=2     
  return    
 end    
    
if @Filebarcode =''     
 begin    
  Set @Message='Filebarcode cannot be blank...'                      
  Set @ControlNo=3     
  return    
 end    
    
if @FormNumber =''     
 begin    
  Set @Message='FormNo cannot be blank...'                      
  Set @ControlNo=4    
  return    
 end    
if @ClientCode =''     
 begin    
  Set @Message='Client code cannot be blank...'                      
  Set @ControlNo=5     
  return    
 end    
if @ClientName =''     
 begin    
  Set @Message='Client Name cannot be blank...'                      
  Set @ControlNo=6     
  return    
 end    
if @Segment =''     
 begin    
  Set @Message='Segment cannot be blank...'                      
  Set @ControlNo=7    
  return    
 end    
if @FormType =''     
 begin    
  Set @Message='Form Type cannot be blank...'                      
  Set @ControlNo=8    
  return    
 end    
if @DpId =''     
 begin    
  Set @Message='DPID cannot be blank...'                      
  Set @ControlNo=9     
  return    
 end        
if @ActivationDate ='1900-01-01'     
 begin    
  Set @Message='Activation date cannot be blank...'                      
  Set @ControlNo=10    
  return    
 end     
if @PancardNo =''     
 begin    
  Set @Message='Pancard cannot be blank...'                      
  Set @ControlNo=11    
  return    
 end       
    
if exists (Select * from InventoryData where filebarcode =@FileBarcode)    
 begin    
  Set @Message='Duplicate file barcode...'                      
  Set @ControlNo=3    
  return      
 end    

 If Not Exists(Select BoxBarcode from BoxMaster where BoxBarcode=@BoxBarcode)    
 Begin    
 insert into BoxMaster(BoxBarcode,CloseStatus,OpenBy,OpenDate,OpenTime,Branchid,ModuleType) Values(@BoxBarcode,0,@UserId,@CurrentDate,@CurrentTime,@Branchid,'KYC')    
 End    
    
 insert into InventoryData (BoxBarcode,Filebarcode,FormNumber,ClientCode,ClientName,Segment,FormType,DpId,ActivationDate,PancardNo,          
 OutStatus,StorageLocId,DataEntryBy,DeDate,DeTime,ManualEntryStatus,branchid,AuthorisedId,DepartmentId) values
 (@BoxBarcode,@FileBarcode,@FormNumber,@ClientCode,@ClientName,@Segment,@FormType,@DpId,@ActivationDate,@PancardNo,0,
 @StorageLocId,@UserId,@CurrentDate,@CurrentTime,1,@BranchId,@AuthorisedId,@DepartmentId)    
     
       
 Set @Message='SUCCESS'                      
 Set @ControlNo=0                        
                       
 end try                      
 Begin Catch                                   
  DECLARE @ErSeverity INT,@ErState INT                           
                      
  Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                  
  Set @ControlNo=99                          
  SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                               
  RAISERROR (@Message,@ErSeverity,@ErState)                                       
 End Catch                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranKYCInsertionSave
-- --------------------------------------------------
CREATE proc TranKYCInsertionSave (@Filebarcode varchar(16), @KycDocId varchar(10), @OtherRemarks varchar(100),  
@BranchId varchar(10),@UserId varchar(10), @Message varchar(250) output,@ControlNo int output )  as        
begin              
              
begin try                          
set nocount on                          
 set nocount on                            
 Declare @CurrentDate datetime                            
 Declare @CurrentTime datetime   
 Select @CurrentTime= convert(varchar(12),getdate(),108)                                              
 select @CurrentDate=convert(varchar(10),getdate(),120)         
Set @Message=''                          
Set @ControlNo=0      
  
if @KycDocId =''  
 begin   
  Set @Message='Kyc document cannot be blank..'                          
  Set @ControlNo=2  
  return  
 end  
if @KycDocId ='KYC0000001' and @OtherRemarks=''  
 begin  
  Set @Message='Others cannot be blank..'                          
  Set @ControlNo=3  
  return   
 end  
  
 insert into  KYCInsertionDetails(FileBarcode,KYCDocId,OtherRemarks,UserId,DeDate,DeTime,BranchId)  
 values(@Filebarcode,@KycDocId,@OtherRemarks,@UserId,@CurrentDate,@CurrentTime,@BranchId)  
  
  
Set @Message='SUCCESS'                          
Set @ControlNo=0      
  
end try                          
Begin Catch       
 DECLARE @ErSeverity INT,@ErState INT                                
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                      
 Set @ControlNo=99                              
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
 RAISERROR (@Message,@ErSeverity,@ErState)                                           
End Catch                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranKYCInsertionSearch
-- --------------------------------------------------
CREATE proc TranKYCInsertionSearch (@ClientCode varchar(15),@BranchId varchar(10),@Message varchar(250) output)  as            
begin                  
                  
begin try                              
set nocount on       
Set @Message=''    
    
If Not Exists(Select ClientCode from inventorydata where clientcode =@ClientCode and branchid =@BranchId)    
Begin    
 Set @Message='Client Code not found or client might be belongs to other branch.'    
 Return    
End                           
    
Set @Message='SUCCESS'                              
select Filebarcode, FormNumber,ClientName,Segment from inventorydata where clientcode =@ClientCode and  
branchid = @BranchId  
    
end try                              
Begin Catch           
 DECLARE @ErSeverity INT,@ErState INT                                    
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                                                     
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                       
 RAISERROR (@Message,@ErSeverity,@ErState)                                               
End Catch                                
end     

select * from inventorydata

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranLinkDataFillGrid
-- --------------------------------------------------
CREATE proc TranLinkDataFillGrid (@SearchField varchar(16),@SearchValue varchar(16),@BranchId Varchar(10),
@Message varchar(250) output,@ControlNo int output)      
as        
set nocount on        
begin         
begin try                        
set nocount on       
DECLARE @SQLString nvarchar(4000);                                                                                                                              
DECLARE @ParmDefinition nvarchar(500);    
    
Set @Message=''                                          
set @ControlNo=0       

if @SearchField=''     
 begin    
  Set @Message='Search field cannot be blank..'     
  set @ControlNo=1   
  return    
 end    
    
if @SearchValue=''     
 begin    
  Set @Message='Search value cannot be blank..'     
  set @ControlNo=2   
  return    
 end    
    
 set @SQLString = N'select Transid, FormNumber,ClientCode,ClientName,Exchange,Segment,DpId,ActivationDate,PancardNo    
 from activationdata where ' + @SearchField + ' =@SrchValue AND dataentrystatus =0 and branchid =@BrId'
    set @ParmDefinition = N'@SrchValue varchar(16),@BrId varchar(10)'    
 EXECUTE sp_executesql @SQLString, @ParmDefinition,@SrchValue=@SearchValue,@BrId =@BranchId  
    
    
Set @Message='SUCCESS'                                          
set @ControlNo=0                         
end try                        
Begin Catch                                     
 DECLARE @ErSeverity INT,@ErState INT                                             
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                     
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                   
 set @ControlNo=99                
 RAISERROR (@Message,@ErSeverity,@ErState)                                             
 End Catch                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranLinkDataGetSearchFields
-- --------------------------------------------------

CREATE proc TranLinkDataGetSearchFields  
as   
begin  
SELECT column_name as columnId,column_name as columnName FROM information_schema.columns 
WHERE table_name = 'ActivationData' and column_name in ('ClientCode','DpId','FormNumber','PancardNo')  
order by column_name          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranLinkDataSave
-- --------------------------------------------------

CREATE Proc TranLinkDataSave (@TransId Bigint,@BoxBarcode Varchar(12), @FileBarcode varchar(15),@WHLocation varchar(50),          
@Segment varchar(150),@DepartmentId Varchar(10),@AuthorisedId Varchar(10),@BranchId varchar(10),@UserId varchar(10),
@Message varchar(250) output,@ControlNo int output )  as          
begin          
          
 begin try                      
 set nocount on                      
 Declare @CurrentDate datetime                      
 Declare @CurrentTime datetime                      
 Select @CurrentTime= convert(varchar(12),getdate(),108)                                        
 select @CurrentDate=convert(varchar(10),getdate(),120)                       
          
 Set @Message=''                      
 Set @ControlNo=0      
    
    
if exists (Select * from InventoryData where filebarcode =@FileBarcode)    
 begin    
	Set @Message='Duplicate file barcode...'                      
	Set @ControlNo=1    
	return      
 end    
     
 If Not Exists(Select BoxBarcode from BoxMaster where BoxBarcode=@BoxBarcode)    
 Begin    
	insert into BoxMaster(BoxBarcode,CloseStatus,OpenBy,OpenDate,OpenTime,branchid,ModuleType) Values(@BoxBarcode,0,@UserId,@CurrentDate,@CurrentTime,@BranchId,'KYC')    
 End    
    
 insert into InventoryData (BoxBarcode,Filebarcode,FormNumber,ClientCode,ClientName,Segment,FormType,DpId,ActivationDate,PancardNo,          
 OutStatus,StorageLocId,DataEntryBy,DeDate,DeTime,ManualEntryStatus,TransId,Branchid,AuthorisedId,DepartmentId) 
 select @BoxBarcode,@FileBarcode,FormNumber,ClientCode,ClientName,@Segment,FormType,DpId,ActivationDate,PancardNo,0,
 @WHLocation,@UserId,@CurrentDate,@CurrentTime,0,TransId,branchid,@AuthorisedId,@DepartmentId 
 from ActivationData where TransId=@TransId          
          
 Set @Message='SUCCESS'                      
 Set @ControlNo=0                        
                       
 end try                      
 Begin Catch                                   
  DECLARE @ErSeverity INT,@ErState INT                            
                      
  Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                  
  Set @ControlNo=99                          
  SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                               
  RAISERROR (@Message,@ErSeverity,@ErState)                                       
 End Catch                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranLinkDataValidateBox
-- --------------------------------------------------

CREATE Procedure TranLinkDataValidateBox
(
	@BoxBarcode Varchar(12),@BranchId Varchar(10),@Module Varchar(6),@FileCount BigInt Output,
	@Message varchar(250) output,@ControlNo int Output
)
As
Begin Try
/*
This procedure is called from options viz. 1)TranLinkData  2)TranDataEntry  
3)TranModifyFileDetails(In Procedure:TranModifyFileDetails) 
4)TranModifyFileDetailsBulk(In Procedure:TranModifyFileDetails)
5)TranLinkNonKYCData  6)TranNonKYCDataEntry
*/
Set NoCount On

Declare @BoxBranchId Varchar(10),@BoxBranchName Varchar(50),@CloseStatus bit,@BoxModule Varchar(10)
Set @Message=''
Set @ControlNo=0

If Exists(Select BoxBarcode From BoxMaster Where BoxBarcode=@BoxBarcode)
Begin    ---------------------------------1
	
Select @BoxBranchId=BranchId,@CloseStatus=CloseStatus,@BoxModule=ModuleType From BoxMaster Where BoxBarcode=@BoxBarcode

If @BranchId<>@BoxBranchId
Begin
	Select @BoxBranchName=BranchName From BranchMaster Where BranchId=@BoxBranchId
	Set @ControlNo=3
	Set @Message='Box belongs to Branch : ' + @BoxBranchName
	Return
End

If @CloseStatus=1
Begin
	Select @BoxBranchName=BranchName From BranchMaster Where BranchId=@BoxBranchId
	Set @ControlNo=3
	Set @Message='Box Barcode is already closed and packed..Cannot use this box barcode...'
	Return
End

If @BoxModule<>@Module
Begin
	If @Module='KYC'
		Set @Message='Box belongs to Non-KYC..Cannot use this box for KYC files...'
	Else
		Set @Message='Box belongs to KYC..Cannot use this box for Non-KYC files...'

	Set @ControlNo=3
	Return
End

End  ---------------------------------1

Set @Message='SUCCESS'
If @Module='KYC'
	Select @FileCount=(Count(FileBarcode)+1) From InventoryData Where BoxBarcode=@BoxBarcode
Else
	Select @FileCount=(Count(FileBarcode)+1) From NonKYCDocumentsArachive Where BoxBarcode=@BoxBarcode

End Try
Begin Catch                                     
	DECLARE @ErSeverity INT,@ErState INT                                             
	Set @Message='Database Error: ' + Replace(ERROR_MESSAGE(),'''','`')                                     
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()     
	Set @ControlNo=99                            
	RAISERROR (@Message,@ErSeverity,@ErState)                                        
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranLinkNonKYCDataFillGrid
-- --------------------------------------------------

CREATE proc TranLinkNonKYCDataFillGrid (@SearchField varchar(20),@SearchValue varchar(60),@BranchId Varchar(10),
@Message varchar(250) output,@ControlNo int output)      
As   
Begin Try
Set NoCount On
DECLARE @SQLString nvarchar(4000);                                                                                                                              
DECLARE @ParmDefinition nvarchar(500);    

Set @Message='SUCCESS'                                          
Set @ControlNo=0       

Set @SQLString = N'Select TransId,MajorDecription As ''MAJOR'',MinorDescription As ''MINOR'',
Case When FromDate Is NULL Then '''' Else Convert(Varchar(10),FromDate,103) End As ''FromDate'',
Case When ToDate Is NULL Then '''' Else Convert(Varchar(10),ToDate,103) End As ''ToDate'',FromNumber,ToNumber   
From NonKYCDocumentsdump Where DataEntryStatus=0 And ' + @SearchField + ' =@SrchValue And Branchid=@BrId'
Set @ParmDefinition = N'@SrchValue varchar(60),@BrId varchar(10)'    
EXECUTE sp_executesql @SQLString,@ParmDefinition,@SrchValue=@SearchValue,@BrId=@BranchId    

End Try  
Begin Catch                                     
	DECLARE @ErSeverity INT,@ErState INT                                             
	Set @Message='Error occured at database level..' + Replace(ERROR_MESSAGE(),'''','`')                                     
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                   
	Set @ControlNo=99                
	RAISERROR (@Message,@ErSeverity,@ErState)                                             
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranModifyFileDetails
-- --------------------------------------------------

CREATE Proc TranModifyFileDetails(@StorageLocId varchar(10),@BoxBarcode Varchar(12),@Filebarcode varchar(15),
@FormNumber varchar(10),@ClientCode varchar(15),@ClientName varchar(50), @Segment varchar(150), 
@FormType varchar(16), @DpId varchar(16),@ActivationDate datetime,@PancardNo varchar(10),@UserId varchar(10),
@BranchId Varchar(10),@Message varchar(250) output,@ControlNo int output) 
As
Begin Try

Set NoCount On               

Declare @FileBox Varchar(12),@CurrentDate datetime,@CurrentTime datetime,@InnerMsg Varchar(250),@InnerCtrlNo int,@FileCount BigInt         
Select @CurrentTime= convert(varchar(12),getdate(),108)                                    
select @CurrentDate=convert(varchar(10),getdate(),120)     
Set @Message=''                  
Set @ControlNo=0 
------------------------------------
If @FormNumber=''     
Begin   
	Set @Message='FormNo cannot be blank...'                      
	Set @ControlNo=4   
	Return    
End  

If @ClientCode=''     
Begin    
	Set @Message='Client code cannot be blank...'                      
	Set @ControlNo=5     
	return    
End 
   
If @ClientName=''     
Begin    
	Set @Message='Client Name cannot be blank...'                      
	Set @ControlNo=6     
	return    
End  
  
If @Segment=''     
Begin 
	Set @Message='Segment cannot be blank...'                      
	Set @ControlNo=7    
	return    
End  
 
If @FormType =''     
Begin  
	Set @Message='Form Type cannot be blank...'                      
	Set @ControlNo=8    
	return    
End 

If @DpId =''     
Begin  
	Set @Message='DPID cannot be blank...'                      
	Set @ControlNo=9     
	return    
End   
   
If @ActivationDate ='1900-01-01'     
Begin    
	Set @Message='Activation date cannot be blank...'                      
	Set @ControlNo=10    
	return    
End    

If @PancardNo =''     
Begin   
	Set @Message='Pancard cannot be blank...'                      
	Set @ControlNo=11    
	return    
End      

Select @FileBox=BoxBarcode From InventoryData Where FileBarcode=@FileBarcode

If @FileBox<>@BoxBarcode
Begin   --------1

Exec TranLinkDataValidateBox @BoxBarcode,@BranchId,'KYC',@FileCount Output,@InnerMsg output,@InnerCtrlNo OutPut
If @InnerMsg<>'SUCCESS'
Begin
	Set @Message=@InnerMsg
	Set @ControlNo=@InnerCtrlNo
	Return
End 

End   --------1

If Not Exists(Select BoxBarcode from BoxMaster where BoxBarcode=@BoxBarcode)
Begin
	insert into BoxMaster(BoxBarcode,CloseStatus,OpenBy,OpenDate,OpenTime,Branchid,ModuleType) Values(@BoxBarcode,0,@UserId,@CurrentDate,@CurrentTime,@BranchId,'KYC')
End

Update InventoryData Set BoxBarcode=@BoxBarcode,FormNumber=@FormNumber,ClientCode=@ClientCode,ClientName=@ClientName,
Segment=@Segment,FormType=@FormType,DpId=@DpId,ActivationDate=@ActivationDate,PancardNo=@PancardNo,      
StorageLocId=@StorageLocId,ModifyStatus=1 Where FileBarcode=@FileBarcode
   
Set @Message='SUCCESS'                             
                   
End Try            
Begin Catch
                               
	DECLARE @ErSeverity INT,@ErState INT                                          
	Set @Message='Error occured at database level...' + Replace(ERROR_MESSAGE(),'''','`')                              
	Set @ControlNo=99                      
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                           
	RAISERROR (@Message,@ErSeverity,@ErState) 
                                  
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranModifyFileGetDetails
-- --------------------------------------------------



CREATE proc TranModifyFileGetDetails (@FileBarcode varchar(15),@BranchId varchar(10),@Message varchar(250) output,@ControlNo int output)      
As          
Begin Try                   
Set NoCount On       

Declare @FileBranchId Varchar(10),@FileBranchName Varchar(50),@OutStatus bit
Set @Message=''                                          
set @ControlNo=0       
  
If Not Exists(Select FileBarcode From InventoryData Where FileBarcode=@FileBarcode)  
Begin  
 Set @Message='File does not exist...'  
 Return  
End  
----------------------------------------------------
Select @FileBranchId=BranchId,@OutStatus=OutStatus From InventoryData Where FileBarcode=@FileBarcode

If @BranchId<>@FileBranchId
Begin
	Select @FileBranchName=BranchName From BranchMaster Where BranchId=@FileBranchId
	Set @Message='File belongs to Branch: ' + @FileBranchName 
	Return  
End
----------------------------------------------------
If @OutStatus=1
Begin  
	Set @Message='File is already out..cannot modify...'  
	Return  
End  
  
Set @Message='SUCCESS'          
Select StorageLocId,BoxBarcode,IsNull(FormNumber,'') As 'FormNumber',IsNull(ClientCode,'') As 'ClientCode',
IsNull(ClientName,'') As 'ClientName',IsNull(Segment,'') As 'Segment',IsNull(FormType,'') As 'FormType',
IsNull(DpId,'') As 'DpId',Case When ActivationDate Is Null Then '' Else Convert(Varchar(10),ActivationDate,103) End As 'ActivationDate',
IsNull(PancardNo,'') As 'PancardNo' From InventoryData Where FileBarcode=@FileBarcode and branchid =@BranchId               
  
End Try                        
Begin Catch                                     
	DECLARE @ErSeverity INT,@ErState INT                                             
	Set @Message='Database Error : ' + Replace(ERROR_MESSAGE(),'''','`')                             
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()  
	set @ControlNo=99                               
	RAISERROR (@Message,@ErSeverity,@ErState)                                        
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranNonKyCDocumentsArchive
-- --------------------------------------------------

CREATE proc TranNonKyCDocumentsArchive (@DMLMode char(6), @Filebarcode varchar(15), @BoxBarcode varchar(12), @MajorDesc varchar(60),
@MinorDesc varchar(60), @FromDate datetime, @ToDate datetime, @FromNo bigint, @ToNo bigint, @AuthorisedId varchar(10),
@DeptId varchar(10),@TransactionId BigInt,@BranchId varchar(10), @EmpId varchar(10),@StorageId varchar(10), 
@Message varchar(250) output,@ControlNo int output)
as
begin
Begin Try              
Set Nocount on           
Declare @DeDate datetime
Declare @DeTime datetime
declare @ManualEntryStatus bit 
Declare @MaxNumber bigint

Set @ControlNo=0        
Set @Message='' 

if  @Filebarcode=''
	begin
		Set @Message='Filebarcode cannot be blank...' 		
		set @ControlNo=5
		return	
	end

if  @BoxBarcode=''
	begin
		Set @Message='Boxbarcode cannot be blank...' 		
		set @ControlNo=4
		return
	end

if  @MajorDesc=''
	begin
		Set @Message='Major Description cannot be blank...' 		
		set @ControlNo=6
		return
	end

if exists (Select * from NonKYCDocumentsArachive where filebarcode=@FileBarcode)    
	begin    
		Set @Message='Duplicate file barcode...'                      
		Set @ControlNo=5    
		return      
	end    

	Select @DeDate=convert(varchar(10),getdate(),120)              
	Select @DeTime=Convert(varchar(10),getdate(),108) 

if @DMLMode='MANUAL'
	begin
	set @ManualEntryStatus=1
	end

if @DMLMode='LINK'
	begin
	set @ManualEntryStatus=0
	end
--------------------------------------------------------------------------------------------------------
IF @FromDate='1900-01-01'
	SET @FromDate= null

IF @ToDate='1900-01-01'
	SET @ToDate= null


If Not Exists(Select BoxBarcode from BoxMaster where BoxBarcode=@BoxBarcode)    
Begin    
	insert into BoxMaster(BoxBarcode,CloseStatus,OpenBy,OpenDate,OpenTime,branchid,ModuleType) Values(@BoxBarcode,0,@EmpId,@DeDate,@DeTime,@BranchId,'NONKYC')    
End   
--------------------------------------------------------------------------------------------------------
If @DMLMode='MANUAL'	
Begin
	insert into NonKYCDocumentsArachive (FileBarcode,BoxBarcode,MajorDecription,MinorDescription,FromDate,ToDate,FromNumber,
	ToNumber,EmpId,DeDate,DeTime,AuthorisedId,DepartmentId,ManualEntryStatus,BranchId,StorageLocId) values(@FileBarcode,@BoxBarcode,
	@MajorDesc,@MinorDesc,@FromDate,@ToDate,@FromNo,@ToNo,@EmpId,@DeDate,@DeTime,@AuthorisedId,	@DeptId,
	@ManualEntryStatus,@BranchId,@StorageId)
End
Else --------------------------------------------------------------------------------------------------------
Begin
	insert into NonKYCDocumentsArachive (FileBarcode,BoxBarcode,MajorDecription,MinorDescription,FromDate,ToDate,
	FromNumber,ToNumber,TransId,EmpId,DeDate,DeTime,AuthorisedId,DepartmentId,ManualEntryStatus,BranchId,StorageLocId)
	Select @FileBarcode,@BoxBarcode,MajorDecription,MinorDescription,FromDate,ToDate,FromNumber,ToNumber,TransId,
	@EmpId,@DeDate,@DeTime,@AuthorisedId,@DeptId,@ManualEntryStatus,@BranchId,@StorageId From NonKYCDocumentsdump
	Where TransId=@TransactionId
End
--------------------------------------------------------------------------------------------------------
Update NonKYCDocumentsdump Set DataEntryStatus=1 Where TransId=@TransactionId
--------------------------------------------------------------------------------------------------------
Set @Message='SUCCESS'            
       
End Try              
        
Begin Catch              
        
 DECLARE @ErSeverity INT,@ErState INT          
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                
 Set @ControlNo=99            
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()             
 RAISERROR (@Message,@ErSeverity,@ErState)                   
          
End Catch   
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranNonKYCDocumentsdump
-- --------------------------------------------------

CREATE Procedure TranNonKYCDocumentsdump                
(                
  @MajorDesc Varchar(65),@MinorDesc Varchar(65),@FromDate datetime, @ToDate datetime, @FromNo bigint, @ToNO Bigint, 
  @BranchId Varchar(10),@UserId Varchar(10),@Message VarChar(250) Output,@ControlNo int Output                
)                
As                
Begin Try                                      
Set NoCount On                    
-----------------------------------------------------------------------------                
Declare @DeDate Datetime,@DeTime Datetime,@MaxNumber Numeric(18,0)                  
-----------------------------------------------------------------------------                
Select @Message='',@ControlNo=0                         
IF @MajorDesc =''
Begin        
 Set @Message='MAJOR DESCRIPTION cannot be blank...'
 Return            
End          
               
If Len(@MajorDesc)>60        
Begin        
 Set @Message='Length of MAJOR DESCRIPTION cannot be greater than 60...'                                      
 Return            
End          
-----------------------------------------------------------------------------        
IF @MinorDesc <> ''
	begin
	If Len(@MinorDesc)>60        
		Begin        
			Set @Message='Length of MINOR DESCRIPTION cannot be greater than 60...'                                      
			Return            
		End         
	end
-----------------------------------------------------------------------------        
Select @DeDate=Convert(Varchar(10),GetDate(),120),@DeTime=Convert(Varchar(12),GetDate(),108)   
If @FromDate='1900-01-01'
	Set @FromDate=NULL
If @ToDate='1900-01-01'
	Set @ToDate=NULL               
-----------------------------------------------------------------------------     
Insert Into NonKYCDocumentsdump(MajorDecription,MinorDescription,FromDate,ToDate,FromNumber,ToNumber,UploadedBy,
UploadedDate,UploadedTime,BranchId) Values (@MajorDesc,@MinorDesc,@FromDate,@ToDate,@FromNO,@ToNO,
@UserId,@DeDate,@DeTime,@BranchId)
                
Set @Message='SUCCESS'                
                
End Try                
Begin Catch                  
                
 DECLARE @ErSeverity INT,@ErState INT                  
 Set @ControlNo=0        
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                          
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                     
 RAISERROR (@Message,@ErSeverity,@ErState)                 
                               
End Catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRefilePrint
-- --------------------------------------------------
CREATE  proc TranRefilePrint(@RefileJc varchar(10) output,@Message varchar(250) output,     
@ControlNo int output)    
as      
set nocount on      
begin       
begin try                      
set nocount on            
      
Set @Message=''                                        
set @ControlNo=0                       
    
if @RefileJc='Pending'    
 begin    
	Set @Message='Refile jobcard has not created. Status is pending...'                                        
	set @ControlNo=0                       
	return
 end    

select a.RefileJobcard, a.FileBarcode,a.WorkOrderNo, convert(varchar,OrderDate,103) as OrderDate,u.FirstName as RefiledBy,
 convert(varchar,a.RefileDate,103) as RefileDate, convert(varchar,a.RefileTime,108) as RefileTime from refiledata a,
usermaster u  where a.refiledby = u.userid and refilejobcard =@RefileJc

    
Set @Message='SUCCESS'                                        
set @ControlNo=0                       
end try                      
Begin Catch                                   
 DECLARE @ErSeverity INT,@ErState INT                                           
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                   
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                               
 RAISERROR (@Message,@ErSeverity,@ErState)                                      
 set @ControlNo=99     
 End Catch                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRefileUpdateStatus
-- --------------------------------------------------

CREATE  proc TranRefileUpdateStatus(@Filebarcode varchar(15),@RefileJc varchar(10) output,@Userid varchar(10) ,  
@BranchId varchar(10) ,@Message varchar(250) output,           
@ControlNo int output)          
as            
set nocount on            
begin             
begin try      
                       
set nocount on           
Declare @MaxNumber bigint            
Declare @CurrentDate datetime                                
Declare @CurrentTime datetime                                
Declare @WO varchar(10)          
Declare @OrderDt datetime                                
Declare @ModuleType char(6)  
                
Select @CurrentTime= convert(varchar(12),getdate(),108)                                                  
select @CurrentDate=convert(varchar(10),getdate(),120)                 
            
Set @Message=''                                              
set @ControlNo=0                             
if  @Filebarcode=''      
  begin         
    
   Set @Message='File barcode cannot be blank..'          
 set @ControlNo=1      
   return          
  end          
          
 if not exists(select * from RetrievalDatadetails where filebarcode =@Filebarcode and dtprnstatus =1 and instatus =0  
and branchid =@BranchId)          
  begin          
    
   Set @Message='Delivery ticket has not done or Invaild file barcode.'          
 set @ControlNo=1      
   return          
  end          
        
          
if @RefileJc='Pending'          
 begin          
 Select @MaxNumber=Coalesce(Max(SubString(RefileJobcard,4,Len(RefileJobcard))),0)+1 From RefileData                   
 Set @RefileJc='REF' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)            
 end          
 select @WO=a.workorderno,@OrderDt=a.orderdate,@ModuleType=a.ModuleType from RetrievalDataHeader a,RetrievalDatadetails b where a.workorderno=          
 b.workorderno and b.filebarcode=@Filebarcode and dtprnstatus =1  and b.branchid =@BranchId        
        
 insert into RefileData (RefileJobcard,Filebarcode,WorkOrderNo,OrderDate,RefiledBy,RefileDate,RefileTime,Branchid)          
 values(@RefileJc,@Filebarcode,@WO,@OrderDt,@Userid,@CurrentDate,@CurrentTime,@BranchId)          
        
update RetrievalDatadetails set instatus =1 where filebarcode=@Filebarcode and dtprnstatus =1  and instatus =0    
and branchid =@BranchId
     
if @ModuleType ='KYC'   
	begin
	update Inventorydata set outstatus=0 where filebarcode=@Filebarcode  and branchid =@BranchId  
    end
if @ModuleType ='NONKYC'   
	begin
	update NonKYCDocumentsArachive set outstatus=0 where filebarcode=@Filebarcode  and branchid =@BranchId  
    end
 
Set @Message='SUCCESS'                                              
set @ControlNo=0     
    
end try                            
Begin Catch         
                                 
 DECLARE @ErSeverity INT,@ErState INT                                                 
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                         
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                     
 RAISERROR (@Message,@ErSeverity,@ErState)                                            
 set @ControlNo=99           
 End Catch                              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetCloseWorkOrder
-- --------------------------------------------------
CREATE proc TranRetCloseWorkOrder (@WorkOrderNo bigint, @Remarks varchar(250), @UserId varchar(10),
@Message varchar(250) output,@ControlNo int Output)          
as          
set nocount on          
begin 
begin try            
Declare @CurrentDate datetime                          
Declare @CurrentTime datetime
                          
set @ControlNo=0
Set @Message=''

if @WorkOrderNo ='' 
	begin
		Set @Message='Work Order No cannot be blank...' 
		set @ControlNo=1
		return
	end 

if @Remarks ='' 
	begin
		Set @Message='Remarks cannot be blank...' 
		set @ControlNo=2
		return
	end 

if len(@Remarks) < 15
	begin
		Set @Message='Remarks cannot be less than 15 charcters...' 
		set @ControlNo=2
		return
	end 
if exists (select filebarcode from retrievaldatadetails where workorderno= @WorkOrderNo and dtprnstatus =0)
	begin
		Set @Message='Transactions are still pending for some files..' 
		set @ControlNo=1
		return
	end


Select @CurrentTime= convert(varchar(12),getdate(),108)                                            
select @CurrentDate=convert(varchar(10),getdate(),120)           
                        
update retrievaldataheader set CloseRemarks=@Remarks,ClosedBy=@UserId,ClosedDate=@CurrentDate,ClosedTime=@CurrentTime,
CloseStatus =1 where workorderno=@WorkOrderNo


Set @Message='SUCCESS'                                            
set @ControlNo=0
                           
end try                          
Begin Catch                                       
 DECLARE @ErSeverity INT,@ErState INT                                               
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                       
 Set @ControlNo=99        
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
 RAISERROR (@Message,@ErSeverity,@ErState)                                           
End Catch                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetCreateDeliveryTicket
-- --------------------------------------------------
CREATE proc TranRetCreateDeliveryTicket(@UserId varchar(10),@BranchId varchar(10),@Message varchar(250) output, @ControlNo int output,  
@DeliveryTicket varchar(10) output)    
as      
set nocount on      
begin       
begin try                      
set nocount on     
Declare @MaxNumber bigint    
Declare @DelTicket varchar(10)    
Declare @CurrentDate datetime                        
Declare @CurrentTime datetime                        
        
Select @CurrentTime= convert(varchar(12),getdate(),108)                                          
select @CurrentDate=convert(varchar(10),getdate(),120)         
    
 Set @Message=''                                        
 set @ControlNo=0                       
    
 Select @MaxNumber=Coalesce(Max(SubString(DeliveryTicket,4,Len(DeliveryTicket))),0)+1 From DeliveryTickets           
 Set @DelTicket='DEL' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)        
     
 Insert into DeliveryTickets (DeliveryTicket, DeliveryTkDate,UserId,DeDate, DeTime,branchid)    
 values(@DelTicket,@CurrentDate,@UserId,@CurrentDate,@CurrentTime,@BranchId)    
    
 Set @Message='SUCCESS'                                        
 set @ControlNo=0                       
 set @DeliveryTicket=@DelTicket  
end try                      
Begin Catch                                   
 DECLARE @ErSeverity INT,@ErState INT                                           
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                   
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                               
 RAISERROR (@Message,@ErSeverity,@ErState)                                      
 set @ControlNo=99     
 End Catch                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetCreateWorkorder
-- --------------------------------------------------

CREATE proc TranRetCreateWorkorder (@Filebarcode varchar(16), @AuthId varchar(10),@DocId varchar(10),        
@RetId varchar(10), @DelContact varchar(50),@DelAddress varchar(100),@Remarks varchar(250), @UserId varchar(10),        
@DepartmentId varchar(10),@BranchId varchar(10), @Message varchar(250) output,@ControlNo int Output,
@WorkOrderNo bigint output,@ModuleType Varchar(10),@RetrievalLevel Varchar(10))        
as        
set nocount on        
begin         
        
begin try                        
set nocount on                   
Declare @CurrentDate datetime                        
Declare @CurrentTime datetime                        
Declare @WO bigint                        
Declare @ProcessWO bigint       
      
Select @Message='',@ControlNo=0      
Set @WO=@WorkOrderNo      
        
Select @CurrentTime= convert(varchar(12),getdate(),108)                                          
select @CurrentDate=convert(varchar(10),getdate(),120)         
        
if  exists(select * from RetrievalDatadetails where filebarcode =@Filebarcode and dtprnstatus=0)          
 begin        
         
 select @ProcessWO= workorderno from RetrievalDatadetails where filebarcode =@Filebarcode and dtprnstatus=0        
 set @Message ='File barcode processing under workorder No.'  + convert( varchar(12), @ProcessWO)        
 return        
 end        
      
if @WO =0         
 begin        
 select @WO = coalesce(max(workorderno),0) +1 from RetrievalDataHeader         
 insert into RetrievalDataHeader (WorkOrderNo ,OrderDate,AuthorisedId,DocId,RetrievalId,DeliveryContact,DeliveryAddress,        
 Remarks,UserId,DeDate,DeTime,Departmentid,Branchid,ModuleType,RetrievalLevel) values(@WO,@CurrentDate,@AuthId,@DocId,@RetId,@DelContact,@DelAddress,@Remarks,@UserId,        
 @CurrentDate,@CurrentTime,@DepartmentId,@BranchId,@ModuleType,@RetrievalLevel)        
 end        
        
 insert into RetrievalDatadetails(WorkOrderNo,fileBarcode,INStatus,DtprnStatus,DtprnDate,DtprnTime,DtprnBy,branchid)        
 values(@WO,@Filebarcode,0,0,null,null,null,@BranchId)        
       
Set @WorkOrderNo=@WO      
Set @Message='SUCCESS'                                          
                 
end try                        
Begin Catch   
 DECLARE @ErSeverity INT,@ErState INT                                             
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                     
 Set @ControlNo=99      
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                 
 RAISERROR (@Message,@ErSeverity,@ErState)                                         
End Catch                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetDeleteWOFiles
-- --------------------------------------------------
CREATE proc TranRetDeleteWOFiles (@WorkOrderNo bigint,@FileBarcode varchar(15), @Remarks varchar(250), @UserId varchar(10),
@Message varchar(250) output,@ControlNo int Output)          
as          
set nocount on          
begin 
begin try            
Declare @CurrentDate datetime                          
Declare @CurrentTime datetime
                          
set @ControlNo=0
Set @Message=''

if @WorkOrderNo ='' 
	begin
		Set @Message='Work Order No cannot be blank...' 
		set @ControlNo=1
		return
	end 

if @FileBarcode ='' 
	begin
		Set @Message='Filebarcode cannot blank...' 
		set @ControlNo=1
		return
	end 

if @Remarks ='' 
	begin
		Set @Message='Remarks cannot be blank...' 
		set @ControlNo=2
		return
	end 

if len(@Remarks) < 15
	begin
		Set @Message='Remarks cannot be less than 15 charcters...' 
		set @ControlNo=2
		return
	end 

Select @CurrentTime= convert(varchar(12),getdate(),108)                                            
select @CurrentDate=convert(varchar(10),getdate(),120)           

begin tran
insert into RetrievalDeletedFiles(WorkOrderNo,FileBarcode,instatus,Dtprnstatus,DtprnDate,dtprntime,
DtprnBy,DeliveryTicket,BranchId,DeleteRemarks,DeletedBy,DeletedDate,DeletedTime)
select WorkOrderNo,FileBarcode,instatus,Dtprnstatus,DtprnDate,dtprntime,
DtprnBy,DeliveryTicket,BranchId,@Remarks,@UserId,@CurrentDate,@CurrentTime from retrievaldatadetails
where workorderno =@WorkOrderNo and filebarcode =@FileBarcode

delete from retrievaldatadetails where workorderno =@WorkOrderNo and filebarcode =@FileBarcode

commit tran

Set @Message='SUCCESS'                                            
set @ControlNo=0
                           
end try                          
Begin Catch
	rollback tran                                       
 DECLARE @ErSeverity INT,@ErState INT                                               
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                       
 Set @ControlNo=99        
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
 RAISERROR (@Message,@ErSeverity,@ErState)                                           
End Catch                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetDelTicketFileValidation
-- --------------------------------------------------
CREATE proc TranRetDelTicketFileValidation (@WorkOrderNo bigint, @Filebarcode varchar(15), @BranchId varchar(10),     
@Message varchar(250) output, @ControlNo int output)      
as        
set nocount on        
begin         
begin try                        
set nocount on       
 Set @Message=''                                          
 set @ControlNo=0            
if @WorkOrderNo =0     
 begin    
  Set @Message='Work order number cannot be blank..'                                          
  set @ControlNo=1    
  return      
 end                 
    
if @Filebarcode =''     
 begin    
  Set @Message='File barcode cannot be blank..'                                          
  set @ControlNo=2    
  return      
 end    
       
 if not exists (select filebarcode from RetrievalDatadetails where filebarcode =@Filebarcode and       
 workorderno =@WorkOrderNo and dtprnstatus=0 and branchid =@BranchId)      
  begin      
   Set @Message='Filebarcode not found or delivery ticket is not pending.'            
   set @ControlNo=2      
   return      
  end       
      
 Set @Message='SUCCESS'                                          
 set @ControlNo=0                         
end try                        
Begin Catch                                     
 DECLARE @ErSeverity INT,@ErState INT                                             
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                     
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                 
 RAISERROR (@Message,@ErSeverity,@ErState)                                        
 set @ControlNo=99       
 End Catch                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetDisplayFileBarcodes
-- --------------------------------------------------
CREATE proc TranRetDisplayFileBarcodes (@WorkOrder Bigint,   @BranchId varchar(10),
@Message varchar(250) output,@ControlNo int Output)          
as          
set nocount on          
begin 
begin try 
Set @Message='SUCCESS'                                            
set @ControlNo=0
           
if @WorkOrder =''
	begin
		Set @Message='Work Order number cannot be blank'                                            
		set @ControlNo=1	
		return	
	end

if not exists (select * from retrievaldataheader where workorderno =@WorkOrder and branchid =@BranchId)
	begin
		Set @Message='Work Order not found or not belongs to login branch..'                                            
		set @ControlNo=1	
		return	
	end

if  exists (select * from retrievaldataheader where workorderno =@WorkOrder and closestatus =1)
	begin
		Set @Message='Work Order has already closed.'                                            
		set @ControlNo=1	
		return	
	end

if not exists (select * from retrievaldatadetails where workorderno =@WorkOrder and dtprnstatus=0)
	begin
		Set @Message='No files pending for deletion..'                                            
		set @ControlNo=1	
		return	
	end


select a.Workorderno, b.Filebarcode,Convert(Varchar(10),a.OrderDate,103) as 'OrderDate' from retrievaldataheader a, retrievaldatadetails b
where a.Workorderno =b.Workorderno and b.Workorderno =@WorkOrder and b.dtprnstatus =0 order by b.Filebarcode


Set @Message='SUCCESS'                                            
set @ControlNo=0
                           
end try                          
Begin Catch
 rollback tran                                       
 DECLARE @ErSeverity INT,@ErState INT                                               
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                       
 Set @ControlNo=99        
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                   
 RAISERROR (@Message,@ErSeverity,@ErState)                                           
End Catch                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetDisplayWorkorders
-- --------------------------------------------------
CREATE proc TranRetDisplayWorkorders (@BranchId varchar(10),  
@Message varchar(250) output,@ControlNo int Output)            
as            
set nocount on            
begin   
begin try              
  
set @ControlNo=0  
  
--If Not Exists(Select top 1 * From retrievaldataheader Where BranchId=@BranchId And CloseStatus=0)  
--Begin  
-- Set @Message='No workorders found...'  
-- Return  
--End  
  
Set @Message='SUCCESS'                                              
set @ControlNo=0  
select a.Workorderno, Convert(Varchar(10),a.OrderDate,103) As 'OrderDate', au.PersonName as AuthorisedPerson,a.DeliveryContact from retrievaldataheader a, authorisedperson au  
where a.authorisedId =au.authorisedId and a.branchid =@BranchId and a.closestatus =0 order by a.workorderno  
                             
end try                            
Begin Catch  
 rollback tran                                         
 DECLARE @ErSeverity INT,@ErState INT                                                 
 Set @Message='Error occured at database level.' + Replace(ERROR_MESSAGE(),'''','`')                                         
 Set @ControlNo=99          
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                     
 RAISERROR (@Message,@ErSeverity,@ErState)                                             
End Catch                              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetGetFilebarcode
-- --------------------------------------------------

CREATE proc TranRetGetFilebarcode (@FieldName varchar(10), @SearchValue varchar(60), @Message varchar(250) output,    
@ControlNo int output )    
as    
set nocount on    
begin     
Select @Message='',@ControlNo=0  
  
if @FieldName ='CLIENTCODE'     
begin    

	if not exists(select clientcode from InventoryData where clientcode =@SearchValue)    
	begin    
	set @Message ='Client code not found..'    
	return    
	end    

	Set @Message='SUCCESS'  

	select a.FileBarcode,a.BoxBarcode, a.FormNumber, a.ClientCode, a.ClientName,a.Segment,a.FormType,   
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',   
	a.ActivationDate,a.PancardNo,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,    
	convert(varchar, a.deDate,103) 'Data Entry Date', br.BranchName from    
	inventorydata a , usermaster b,StorageLocationMaster c, branchmaster br,DepartmentMaster d,AuthorisedPerson ap    
	where a.Dataentryby = b.userid and a.StorageLocId=c.StorageLocId and a.branchid = br.branchid and 
	a.departmentid=d.departmentid And a.AuthorisedId=ap.AuthorisedId and a.clientcode=@SearchValue    

end    
  
if @FieldName ='DPID'     
begin    

	if not exists(select dpid from InventoryData where dpid =@SearchValue)    
	begin    
	set @Message ='DpId not found..'    
	return    
	end    

	Set @Message='SUCCESS'  
	select a.FileBarcode,a.BoxBarcode, a.FormNumber, a.ClientCode, a.ClientName,a.Segment,a.FormType,   
	Case When IsNumeric(a.DPID)=1 Then ('''' + a.DPID) Else a.DPID End As 'DPID',   
	a.ActivationDate,a.PancardNo,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,    
	convert(varchar, a.deDate,103) 'Data Entry Date', br.BranchName from    
	inventorydata a,usermaster b,StorageLocationMaster c, branchmaster br,DepartmentMaster d,AuthorisedPerson ap     
	where a.Dataentryby = b.userid and a.StorageLocId=c.StorageLocId and a.branchid = br.branchid and 
	a.departmentid=d.departmentid And a.AuthorisedId=ap.AuthorisedId and a.dpid=@SearchValue   

end    

if @FieldName ='MAJOR'     
begin    

	if not exists(select majordecription from NonKYCDocumentsArachive where majordecription=@SearchValue)    
	begin    
	set @Message ='Major Description not found..'    
	return    
	end    

	Set @Message='SUCCESS' 

	select a.FileBarcode,a.BoxBarcode,a.MajorDecription As 'Major',a.MinorDescription As 'Minor',
	Case When a.FromDate Is Null Then '' Else Convert(Varchar(10),a.FromDate,103) End As 'FromDate',
	Case When a.ToDate Is Null Then '' Else Convert(Varchar(10),a.ToDate,103) End As 'ToDate',
	a.FromNumber,a.ToNumber,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,    
	convert(varchar, a.deDate,103) 'Data Entry Date', br.BranchName from    
	NonKYCDocumentsArachive a,usermaster b,StorageLocationMaster c, branchmaster br,DepartmentMaster d,AuthorisedPerson ap     
	where a.EmpId = b.userid and a.StorageLocId=c.StorageLocId and a.branchid = br.branchid and 
	a.departmentid=d.departmentid And a.AuthorisedId=ap.AuthorisedId and a.MajorDecription=@SearchValue 

end    

if @FieldName ='MINOR'     
begin    

	if not exists(select MinorDescription from NonKYCDocumentsArachive where MinorDescription=@SearchValue)    
	begin    
	set @Message ='Minor Description not found..'    
	return    
	end    

	Set @Message='SUCCESS' 

	select a.FileBarcode,a.BoxBarcode,a.MajorDecription As 'Major',a.MinorDescription As 'Minor',
	Case When a.FromDate Is Null Then '' Else Convert(Varchar(10),a.FromDate,103) End As 'FromDate',
	Case When a.ToDate Is Null Then '' Else Convert(Varchar(10),a.ToDate,103) End As 'ToDate',
	a.FromNumber,a.ToNumber,c.StorageLocation,d.DepartmentDesc,ap.PersonName As 'AuthorisedPerson',b.FirstName,    
	convert(varchar, a.deDate,103) 'Data Entry Date', br.BranchName from    
	NonKYCDocumentsArachive a,usermaster b,StorageLocationMaster c, branchmaster br,DepartmentMaster d,AuthorisedPerson ap     
	where a.EmpId = b.userid and a.StorageLocId=c.StorageLocId and a.branchid = br.branchid and 
	a.departmentid=d.departmentid And a.AuthorisedId=ap.AuthorisedId and a.MinorDescription=@SearchValue 

end    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetGetFileDtlsAfterDelTickt
-- --------------------------------------------------

CREATE proc TranRetGetFileDtlsAfterDelTickt(@WorkOrderNo bigint,@Message varchar(250) output, @ControlNo int output)  
as    
set nocount on    
begin     
begin try                    
set nocount on   
Declare @ModuleType Varchar(10)
  
Set @Message=''                                      
set @ControlNo=0                     
if @WorkOrderNo =0 
	begin
		Set @Message='Work order number cannot be blank..'                                      
		set @ControlNo=0  
		return                   
	end

Select @ModuleType=ModuleType From RetrievalDataHeader Where Workorderno=@WorkOrderNo

Set @Message='SUCCESS'                                      
set @ControlNo=0    

If @ModuleType='KYC'
	select a.Workorderno,a.Filebarcode, a.DeliveryTicket, b.DeliveryContact,b.DeliveryAddress, c.PersonName,br.Branchname,  
	d.ClientCode, d.Clientname,'''' + D.DpId  as DPID from RetrievalDatadetails a, RetrievalDataHeader b,AuthorisedPerson c,  
	InventoryData d,branchmaster br where a.workorderno = b.workorderno and b.authorisedId = c.authorisedId and a.filebarcode=  
	d.filebarcode and c.branchid = br.branchid and a.workorderno =@WorkOrderNo and a.dtprnstatus =1 
Else
	select a.Workorderno,a.Filebarcode, a.DeliveryTicket, b.DeliveryContact,b.DeliveryAddress, c.PersonName,br.Branchname,  
	d.MajorDecription As 'Major', d.MinorDescription As 'Minor' from RetrievalDatadetails a, RetrievalDataHeader b,AuthorisedPerson c,  
	NonKYCDocumentsArachive d,branchmaster br where a.workorderno = b.workorderno and b.authorisedId = c.authorisedId and a.filebarcode=  
	d.filebarcode and c.branchid = br.branchid and a.workorderno =@WorkOrderNo and a.dtprnstatus =1 
              
end try                    
Begin Catch                                 
 DECLARE @ErSeverity INT,@ErState INT                                         
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                 
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                             
 RAISERROR (@Message,@ErSeverity,@ErState)                                    
 set @ControlNo=99   
 End Catch                      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetGetWOFiledetails
-- --------------------------------------------------
   
CREATE proc TranRetGetWOFiledetails(@WorkorderNo bigint,@ModuleType Varchar(10))  
as  
begin  

If @ModuleType='KYC'
	select a.Filebarcode,a.FormNumber, a.ClientCode, a.ClientName,('''' + a.DpId) As 'DpId',c.StorageLocation, 
	b.WorkOrderNo from InventoryData a,RetrievalDatadetails b, StorageLocationMaster c where 
	a.Filebarcode=b.Filebarcode and a.StorageLocId=c.StorageLocId and b.workorderno =@WorkorderNo  
Else
	select a.Filebarcode,a.MajorDecription As 'Major',a.MinorDescription As 'Minor',
	Case When a.FromDate Is Null Then '' Else Convert(Varchar(10),a.FromDate,103) End As 'FromDate',
	Case When a.ToDate Is Null Then '' Else Convert(Varchar(10),a.ToDate,103) End As 'ToDate',
	a.FromNumber,a.ToNumber,c.StorageLocation,b.WorkOrderNo from NonKYCDocumentsArachive a,  
	RetrievalDatadetails b, StorageLocationMaster c where a.Filebarcode=b.Filebarcode and 
	a.StorageLocId=c.StorageLocId and b.workorderno =@WorkorderNo 

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetUpdateDelTcktStatus
-- --------------------------------------------------

CREATE proc TranRetUpdateDelTcktStatus(@WorkOrderNo bigint,@Filebarcode varchar(15), @DeliveryTicket varchar(10),    
@Userid varchar(10), @Message varchar(250) output, @ControlNo int output)    
as      
set nocount on      
begin       
begin try   
begin tran                     
set nocount on     
Declare @CurrentDate datetime                        
Declare @CurrentTime datetime                        
Declare @ModuleType char(6)
        
Select @CurrentTime= convert(varchar(12),getdate(),108)                                          
select @CurrentDate=convert(varchar(10),getdate(),120)         
    
 Set @Message=''                                        
 set @ControlNo=0                       


     
update  RetrievalDatadetails set Dtprnstatus =1,DtprnDate =@CurrentDate,dtprntime =@CurrentTime,Dtprnby=@Userid,    
DeliveryTicket =@DeliveryTicket where filebarcode =@Filebarcode and workorderno =@WorkOrderNo    

select @ModuleType= ModuleType from RetrievalDataHeader where workorderno =@WorkOrderNo
if @ModuleType ='KYC'
	begin
		update Inventorydata set outstatus =1 where filebarcode =@Filebarcode  
    end

if @ModuleType ='NONKYC'
	begin
		update NonKYCDocumentsArachive set outstatus =1 where filebarcode =@Filebarcode  
    end


 Set @Message='SUCCESS'                                        
 set @ControlNo=0                       
commit tran  
end try                      
Begin Catch    
 rollback tran                                 
 DECLARE @ErSeverity INT,@ErState INT                                           
 Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                   
 SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                               
 RAISERROR (@Message,@ErSeverity,@ErState)                                      
 set @ControlNo=99     
 End Catch                        
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TranRetUploadFilebarcode
-- --------------------------------------------------

CREATE proc TranRetUploadFilebarcode 
(
	@BoxBarcode Varchar(12),@Filebarcode varchar(16),@RetrievalLevel Varchar(10),@Documents Varchar(10),
	@DepartmentId Varchar(10),@BranchId varchar(10),@Message varchar(250) output,@ControlNo int output
)      
As 
Begin  ------------Main
------------------------------------------------------------------------------------------
Set NoCount On
Declare @BrName Varchar(20),@ModuleType Varchar(10),@BrId Varchar(10),@OutStatus bit,@FileDeptId Varchar(10)

Select @Message='',@ControlNo=0
------------------------------------------------------------------------------------------
If @RetrievalLevel='BOX'
Begin  -------------@RetrievalLevel='BOX'
--------------------------------------
If Not Exists(Select BoxBarcode From BoxMaster Where BoxBarcode=@BoxBarcode)
Begin
	Set @Message='Box Barcode not found...'
	Return
End
---------------------------------------
Select @BrId=a.BranchId,@BrName=bm.BranchName,@ModuleType=a.ModuleType From BoxMaster a,BranchMaster bm 
Where a.BranchId=bm.BranchId And a.BoxBarcode=@boxBarcode

If @BranchId<>@BrId
Begin
	Set @Message='Box Barcode belongs to Branch: ' + @BrName + '...'
	Return
End
---------------------------------------
If @ModuleType<>@Documents
Begin
	If @Documents='KYC'
		Set @Message='Box belongs to Non-KYC..Cannot process...'
	Else
		Set @Message='Box belongs to KYC..Cannot process...'

	Return
End  
---------------------------------------
Set @Message='SUCCESS'
If @Documents='KYC'
Begin

Select Filebarcode,BoxBarcode,FormNumber,ClientCode,DpId,FormType,ClientName From InventoryData 
Where BoxBarcode=@BoxBarcode And OutStatus=0 And DepartmentId=@DepartmentId

---- Get Invalid Records
Select Filebarcode,BoxBarcode,'File Barcode is already out..Check File out report for details.' As 'Remarks'
From InventoryData Where BoxBarcode=@BoxBarcode And OutStatus=1
Union All
Select Filebarcode,BoxBarcode,'File Barcode does not belong to selected department...' As 'Remarks'
From InventoryData Where BoxBarcode=@BoxBarcode And OutStatus=0 And DepartmentId<>@DepartmentId

End
Else
Begin

Select Filebarcode,BoxBarcode,MajorDecription As 'Major',MinorDescription As 'Minor',
Case When FromDate Is Null Then '' Else Convert(Varchar(10),FromDate,103) End As 'FromDate',
Case When ToDate Is Null Then '' Else Convert(Varchar(10),ToDate,103) End As 'ToDate',FromNumber,ToNumber 
From NonKYCDocumentsArachive Where BoxBarcode=@BoxBarcode And OutStatus=0 And DepartmentId=@DepartmentId

---- Get Invalid Records
Select Filebarcode,BoxBarcode,'File Barcode is already out..Check File out report for details.' As 'Remarks'
From NonKYCDocumentsArachive Where BoxBarcode=@BoxBarcode And OutStatus=1
Union All
Select Filebarcode,BoxBarcode,'File Barcode does not belong to selected department...' As 'Remarks'
From NonKYCDocumentsArachive Where BoxBarcode=@BoxBarcode And OutStatus=0 And DepartmentId<>@DepartmentId

End
----------------------------------------
End    -------------@RetrievalLevel='BOX'
------------------------------------------------------------------------------------------
Else If @RetrievalLevel='FILE'
Begin   -------------@RetrievalLevel='FILE'
--------------------------------------
If @Documents='KYC'
Begin  ------------@Documents='KYC'
-----------------
If Not Exists(Select FileBarcode From InventoryData Where FileBarcode=@FileBarcode)
Begin
	Set @Message='File Barcode not found...'
	Return
End
-----------------
Select @BrId=a.BranchId,@BrName=bm.BranchName,@OutStatus=OutStatus,@FileDeptId=a.DepartmentId 
From InventoryData a,BranchMaster bm Where a.BranchId=bm.BranchId And a.FileBarcode=@FileBarcode

If @BranchId<>@BrId
Begin
	Set @Message='File Barcode belongs to Branch: ' + @BrName + '...'
	Return
End
-----------------
If @OutStatus=1
Begin
	Set @Message='File Barcode is already out..Check File out report for details.'
	Return
End
-----------------
If @FileDeptId<>@DepartmentId
Begin
	Set @Message='File does not belong to selected department...'
	Return
End
-----------------
Set @Message='SUCCESS'
Select Filebarcode,BoxBarcode,FormNumber,ClientCode,DpId,FormType,ClientName From InventoryData Where FileBarcode=@FileBarcode
-----------------
End   ------------@Documents='KYC'
Else --------------------------------------
Begin  ------------@Documents='NONKYC'
-----------------
If Not Exists(Select FileBarcode From NonKYCDocumentsArachive Where FileBarcode=@FileBarcode)
Begin
	Set @Message='File Barcode not found...'
	Return
End
-----------------
Select @BrId=a.BranchId,@BrName=bm.BranchName,@OutStatus=OutStatus,@FileDeptId=a.DepartmentId 
From NonKYCDocumentsArachive a,BranchMaster bm Where a.BranchId=bm.BranchId And a.FileBarcode=@FileBarcode

If @BranchId<>@BrId
Begin
	Set @Message='File Barcode belongs to Branch: ' + @BrName + '...'
	Return
End
-----------------
If @OutStatus=1
Begin
	Set @Message='File Barcode is already out..Check File out report for details.'
	Return
End
-----------------
If @FileDeptId<>@DepartmentId
Begin
	Set @Message='File does not belong to selected department...'
	Return
End
-----------------
Set @Message='SUCCESS'
Select Filebarcode,BoxBarcode,MajorDecription As 'Major',MinorDescription As 'Minor',
Case When FromDate Is Null Then '' Else Convert(Varchar(10),FromDate,103) End As 'FromDate',
Case When ToDate Is Null Then '' Else Convert(Varchar(10),ToDate,103) End As 'ToDate',
FromNumber,ToNumber From NonKYCDocumentsArachive Where FileBarcode=@FileBarcode
-----------------
End    ------------@Documents='NONKYC'
--------------------------------------
End  -------------@RetrievalLevel='FILE'
------------------------------------------------------------------------------------------

End   ------------Main

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UserMasterAddModify
-- --------------------------------------------------
CREATE proc UserMasterAddModify (@DMLAction varchar(5) output, @LoginId varchar(10), @UserPassword varchar(10),    
@FirstName varchar(20), @LastName varchar(20),@Branchid varchar(10),@UsertypeId varchar(5),@Email varchar(50),@ActiveStatus bit,    
@Message varchar(250) output,@ControlNo int output )  as      
begin            
            
begin try                        
	set nocount on                        
	Declare @CurrentDate datetime                        
	Declare @CurrentTime datetime    
	Declare @MaxNumber bigint    
	Declare @UsrId varchar(10)    
	Declare @GetType varchar(10)    

	Select @CurrentTime= convert(varchar(12),getdate(),108)                                          
	select @CurrentDate=convert(varchar(10),getdate(),120)                         
	begin tran          
		Set @Message=''                        
		Set @ControlNo=0        

		if @DMLAction ='ADD'    
			begin      
				if exists (select * from usermaster where loginId =@Loginid)    
					begin    
						rollback tran    
						Set @Message='Login Id cannot be duplicate..'                   
						Set @ControlNo=1      
						return     
					end    
				Select @MaxNumber=Coalesce(Max(SubString(UserId,4,Len(UserId))),0)+1 From usermaster               
				Set @UsrId='USR' + RIGHT('0000000' +  Cast(@MaxNumber As Varchar(10)),7)        

				Insert into usermaster(UserId,LoginId,UserPassword,FirstName,LastName,Branchid,UsertypeId,DeDate,Detime,ActiveStatus,    
				Email) values(@UsrId,@LoginId,@UserPassword,@FirstName,@LastName,@Branchid,@UsertypeId,@CurrentDate,@CurrentTime,@ActiveStatus,    
				@Email)    
				insert into UserMenuRightsMaster(userid,menuId) select @UsrId, menuid from UserTypeMenuRightsMaster where     
				usertypeid = @UsertypeId     
			end    

		if @DMLAction ='MODIF'    
			BEGIN    

				select @GetType= UsertypeId,@UsrId=UserId from usermaster where loginid=@LoginId    
				if @GetType <> @UsertypeId    
					begin    
						delete from UserMenuRightsMaster where Userid in(select userid from    
						usermaster where loginid =@LoginId)    
						insert into UserMenuRightsMaster(userid,menuId) select @UsrId, menuid from UserTypeMenuRightsMaster    
						where usertypeid=@UsertypeId     	
					end  

					Update usermaster set Firstname=@FirstName, LastName =@LastName,branchid =	@Branchid,UserTypeId =@UsertypeId,
					ActiveStatus=@ActiveStatus,Email=@Email where LoginId=@LoginId		  

			end    

commit tran     
Set @Message='SUCCESS'                        
Set @ControlNo=0    

end try                        
Begin Catch     
	rollback tran                                    
	DECLARE @ErSeverity INT,@ErState INT                              

	Set @Message='Error occured at database level. Transaction has been cancelled. ' + Replace(ERROR_MESSAGE(),'''','`')                                    
	Set @ControlNo=99                            
	SELECT @ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()                                 
	RAISERROR (@Message,@ErSeverity,@ErState)                                         
End Catch                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UserMasterGetDetails
-- --------------------------------------------------
CREATE Procedure UserMasterGetDetails(@LoginId Varchar(10),@SessionLoginId varchar(10),@Message Varchar(250) Output)  
As  
Begin  
Set NoCount On  
  
Set @Message=''  
  
If @LoginId  =@SessionLoginId
Begin   
 Set @Message='Login Id is in use. Cannot modify any changes.'  
 Return  
End  

If Not Exists(Select LoginId From UserMaster Where LoginId=@LoginId)  
Begin   
 Set @Message='LoginId does not exist'  
 Return  
End  
  
Set @Message='SUCCESS'  
Select FirstName,LastName,Email,BranchId,UserTypeId,ActiveStatus From UserMaster Where LoginId=@LoginId  
  
End

GO

-- --------------------------------------------------
-- TABLE dbo.backupmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[backupmaster]
(
    [UserId] VARCHAR(10) NOT NULL,
    [LoginId] VARCHAR(10) NOT NULL,
    [UserPassword] VARCHAR(10) NOT NULL,
    [FirstName] VARCHAR(20) NOT NULL,
    [LastName] VARCHAR(20) NOT NULL,
    [Branchid] VARCHAR(10) NOT NULL,
    [UsertypeId] VARCHAR(5) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [Detime] DATETIME NOT NULL,
    [ActiveStatus] BIT NULL,
    [Email] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BillingMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BillingMaster]
(
    [BillingId] VARCHAR(10) NOT NULL,
    [BillDescription] VARCHAR(250) NOT NULL,
    [Unit] CHAR(5) NOT NULL,
    [Rate] NUMERIC(9, 2) NOT NULL,
    [ActiveStatus] BIT NOT NULL DEFAULT ((1)),
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BoxMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BoxMaster]
(
    [BoxBarcode] VARCHAR(12) NOT NULL,
    [CloseStatus] BIT NOT NULL DEFAULT ((0)),
    [OpenBy] VARCHAR(10) NOT NULL,
    [OpenDate] DATETIME NOT NULL,
    [OpenTime] DATETIME NOT NULL,
    [ClosedBy] VARCHAR(10) NULL,
    [ClosedDate] DATETIME NULL,
    [ClosedTime] DATETIME NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [ModuleType] CHAR(6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BranchMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[BranchMaster]
(
    [Branchid] VARCHAR(10) NOT NULL,
    [BranchName] VARCHAR(20) NOT NULL,
    [Address] VARCHAR(50) NOT NULL,
    [ContactPerson] VARCHAR(20) NOT NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [Detime] DATETIME NOT NULL,
    [Status] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.CourierTransactionMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[CourierTransactionMaster]
(
    [CourierId] VARCHAR(10) NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [WeightFrom] NUMERIC(9, 3) NOT NULL,
    [WeightTo] NUMERIC(9, 3) NOT NULL,
    [Rate] NUMERIC(9, 2) NULL,
    [ActiveStatus] BIT NULL DEFAULT ((0)),
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [TransId] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DeliveryTickets
-- --------------------------------------------------
CREATE TABLE [dbo].[DeliveryTickets]
(
    [DeliveryTicket] VARCHAR(10) NOT NULL,
    [DeliveryTkDate] DATETIME NOT NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DepartmentMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[DepartmentMaster]
(
    [DepartmentId] VARCHAR(10) NOT NULL,
    [DepartmentDesc] VARCHAR(50) NULL,
    [Branchid] VARCHAR(10) NOT NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.DocumentTypeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[DocumentTypeMaster]
(
    [DocId] VARCHAR(10) NOT NULL,
    [DocDescription] VARCHAR(50) NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.FormMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[FormMaster]
(
    [FormId] VARCHAR(10) NOT NULL,
    [FormDescription] VARCHAR(50) NULL,
    [FormTypeId] VARCHAR(10) NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [EmpId] VARCHAR(10) NULL,
    [DeDate] DATETIME NULL,
    [DeTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FormsLotMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[FormsLotMaster]
(
    [LotId] VARCHAR(10) NOT NULL,
    [LotNumber] VARCHAR(10) NOT NULL,
    [Rate] NUMERIC(9, 2) NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FormTypeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[FormTypeMaster]
(
    [FormTypeId] VARCHAR(10) NOT NULL,
    [FormName] VARCHAR(50) NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [EmpId] VARCHAR(10) NULL,
    [DeDate] DATETIME NULL,
    [DeTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvBranchConsumption
-- --------------------------------------------------
CREATE TABLE [dbo].[InvBranchConsumption]
(
    [BranchId] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NULL,
    [TotalForms] BIGINT NOT NULL,
    [TotalUsedForms] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvBranchMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvBranchMaster]
(
    [BranchId] VARCHAR(10) NOT NULL,
    [BranchName] VARCHAR(50) NOT NULL,
    [BranchAddress] CHAR(250) NULL,
    [ContactPerson] VARCHAR(50) NOT NULL,
    [BranchTag] CHAR(10) NULL,
    [ActiveStatus] BIT NOT NULL DEFAULT ((0)),
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [EmpCode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvBranchStockMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvBranchStockMaster]
(
    [BranchId] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NULL,
    [MinStock] BIGINT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispatchDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispatchDetails]
(
    [DispatchTrackNo] VARCHAR(10) NOT NULL,
    [CourierId] VARCHAR(10) NOT NULL,
    [PodNo] VARCHAR(100) NOT NULL,
    [PodDate] DATETIME NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [Weight] NUMERIC(9, 3) NOT NULL,
    [Remarks] VARCHAR(100) NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [Transit] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToBranchDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToBranchDetails]
(
    [DispToBranchJcNo] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToBranchHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToBranchHeader]
(
    [DispToBranchJcNo] VARCHAR(10) NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [ContactPerson] VARCHAR(50) NOT NULL,
    [CreatedBy] VARCHAR(10) NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedTime] DATETIME NOT NULL,
    [DispatchTrackNo] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToCSODetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToCSODetails]
(
    [DispToCSOJCNo] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [ContactPerson] VARCHAR(50) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [detime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToCSOHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToCSOHeader]
(
    [DispToCSOJCNo] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [CreatedDate] DATETIME NULL,
    [CreatedTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToKYCDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToKYCDetails]
(
    [DispToKycJCNo] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [ContactPerson] VARCHAR(50) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [detime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvDispToKYCHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvDispToKYCHeader]
(
    [DispToKycJCNo] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [CreatedDate] DATETIME NULL,
    [CreatedTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvEmpMenuRightsMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvEmpMenuRightsMaster]
(
    [EmpId] VARCHAR(10) NULL,
    [menuid] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvInwardRegisterDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvInwardRegisterDetails]
(
    [InwardJCNo] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [DispToKYC] BIT NULL DEFAULT ((0)),
    [DispToCSO] BIT NULL DEFAULT ((0)),
    [ReceiptAtCSO] BIT NULL DEFAULT ((0)),
    [DispToBranch] BIT NULL DEFAULT ((0)),
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [UsedForm] BIT NOT NULL DEFAULT ((0)),
    [LotId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvInwardRegisterHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvInwardRegisterHeader]
(
    [InwardJCNo] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [CreatedDate] DATETIME NULL,
    [CreatedTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvMenuMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvMenuMaster]
(
    [MenuId] VARCHAR(10) NOT NULL,
    [MenuCaption] VARCHAR(40) NULL,
    [MenuSerialNo] INT NULL,
    [MenuGroup] VARCHAR(10) NULL,
    [NavigateURL] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvReceiptDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvReceiptDetails]
(
    [ReceiptJCNo] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [detime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvReceiptHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvReceiptHeader]
(
    [ReceiptJCNo] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [CreatedDate] DATETIME NULL,
    [CreatedTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvUsedFormsDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvUsedFormsDetails]
(
    [UsedFormsJcNo] VARCHAR(10) NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvUsedFormsHeader
-- --------------------------------------------------
CREATE TABLE [dbo].[InvUsedFormsHeader]
(
    [UsedFormsJcNo] VARCHAR(10) NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [FormId] VARCHAR(10) NOT NULL,
    [FormCount] BIGINT NOT NULL,
    [CreatedBy] VARCHAR(10) NOT NULL,
    [CreatedDate] DATETIME NOT NULL,
    [CreatedTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvUserTypeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvUserTypeMaster]
(
    [UserTypeId] VARCHAR(5) NOT NULL,
    [Description] VARCHAR(50) NULL,
    [EmpId] VARCHAR(10) NULL,
    [DeDate] DATETIME NULL,
    [DeTime] DATETIME NULL,
    [Status] BIT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvUserTypeMenuRightsMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[InvUserTypeMenuRightsMaster]
(
    [UserTypeId] VARCHAR(5) NULL,
    [MenuId] VARCHAR(10) NULL,
    [EmpId] VARCHAR(10) NULL,
    [DeDate] DATETIME NULL,
    [DeTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvVendorDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[InvVendorDetails]
(
    [VendorId] VARCHAR(10) NOT NULL,
    [VendorName] VARCHAR(50) NOT NULL,
    [ChallanNumber] VARCHAR(30) NOT NULL,
    [ChallanDate] DATETIME NOT NULL,
    [FormsQty] BIGINT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.InvVendorInwardData
-- --------------------------------------------------
CREATE TABLE [dbo].[InvVendorInwardData]
(
    [FormId] VARCHAR(10) NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [EmpId] VARCHAR(10) NULL,
    [UploadDate] DATETIME NULL,
    [UploadTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KYCInsertionDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[KYCInsertionDetails]
(
    [FileBarcode] VARCHAR(15) NOT NULL,
    [KYCDocId] VARCHAR(10) NOT NULL,
    [OtherRemarks] VARCHAR(100) NULL,
    [UserId] VARCHAR(10) NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KYCMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[KYCMaster]
(
    [KycDocId] VARCHAR(10) NOT NULL,
    [KycDocuments] VARCHAR(100) NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LogBillingMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[LogBillingMaster]
(
    [BillingId] VARCHAR(10) NULL,
    [OldBillDescription] VARCHAR(1000) NULL,
    [NewBillDescription] VARCHAR(1000) NULL,
    [OldRate] NUMERIC(9, 2) NULL,
    [NewRate] NUMERIC(9, 2) NULL,
    [OldEmpId] VARCHAR(10) NULL,
    [NewEmpId] VARCHAR(10) NULL,
    [OldDeDate] DATETIME NULL,
    [NewDeDate] DATETIME NULL,
    [oldDeTime] DATETIME NULL,
    [NewDeTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LogInterChangeForms
-- --------------------------------------------------
CREATE TABLE [dbo].[LogInterChangeForms]
(
    [FromFormId] VARCHAR(10) NOT NULL,
    [ToFormId] VARCHAR(10) NOT NULL,
    [FormBarcode] VARCHAR(10) NOT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LoginvBranchStockMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[LoginvBranchStockMaster]
(
    [BranchId] VARCHAR(10) NULL,
    [FormId] VARCHAR(10) NULL,
    [OldMinStock] BIGINT NULL,
    [NewMinStock] BIGINT NULL,
    [OldEmpId] VARCHAR(10) NULL,
    [NewEmpId] VARCHAR(10) NULL,
    [OldDeDate] DATETIME NULL,
    [NewDeDate] DATETIME NULL,
    [OldDeTime] DATETIME NULL,
    [NewDeTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.logInvDispatchDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[logInvDispatchDetails]
(
    [OldCourierId] VARCHAR(10) NULL,
    [NewCourierId] VARCHAR(10) NULL,
    [OldPodNo] VARCHAR(100) NULL,
    [NewPodNo] VARCHAR(100) NULL,
    [OldPodDate] DATETIME NULL,
    [NewPodDate] DATETIME NULL,
    [OldBranchId] VARCHAR(10) NULL,
    [NewBranchId] VARCHAR(10) NULL,
    [OldWeight] NUMERIC(5, 2) NULL,
    [NewWeight] NUMERIC(5, 2) NULL,
    [OldRemarks] VARCHAR(100) NULL,
    [NewRemarks] VARCHAR(100) NULL,
    [OldEmpId] VARCHAR(10) NULL,
    [NewEmpId] VARCHAR(10) NULL,
    [OldDeDate] DATETIME NULL,
    [NewDeDate] DATETIME NULL,
    [OldTime] DATETIME NULL,
    [NewTime] DATETIME NULL,
    [OldDispatchToBranchJcs] NVARCHAR(MAX) NULL,
    [DispatchTrackNo] VARCHAR(10) NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1)),
    [OldTransit] VARCHAR(10) NULL,
    [NewTransit] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MenuMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[MenuMaster]
(
    [MenuId] VARCHAR(10) NOT NULL,
    [MenuCaption] VARCHAR(40) NOT NULL,
    [MenuSerialNo] INT NOT NULL,
    [MenuGroup] VARCHAR(10) NULL,
    [NavigateURL] VARCHAR(100) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NonKYCDocumentsArachive
-- --------------------------------------------------
CREATE TABLE [dbo].[NonKYCDocumentsArachive]
(
    [FileBarcode] VARCHAR(15) NOT NULL,
    [BoxBarcode] VARCHAR(12) NOT NULL,
    [MajorDecription] VARCHAR(250) NULL,
    [MinorDescription] VARCHAR(60) NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [FromNumber] BIGINT NULL,
    [ToNumber] BIGINT NULL,
    [TransId] BIGINT NULL,
    [EmpId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [AuthorisedId] VARCHAR(10) NULL,
    [DepartmentId] VARCHAR(10) NULL,
    [ManualEntryStatus] BIT NULL DEFAULT ((0)),
    [StorageLocId] VARCHAR(10) NULL,
    [BranchId] VARCHAR(10) NULL,
    [Outstatus] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.NonKYCDocumentsDump
-- --------------------------------------------------
CREATE TABLE [dbo].[NonKYCDocumentsDump]
(
    [MajorDecription] VARCHAR(60) NULL,
    [MinorDescription] VARCHAR(60) NULL,
    [FromDate] DATETIME NULL,
    [ToDate] DATETIME NULL,
    [FromNumber] BIGINT NULL,
    [ToNumber] BIGINT NULL,
    [UploadedBy] VARCHAR(10) NOT NULL,
    [UploadedDate] DATETIME NOT NULL,
    [UploadedTime] DATETIME NOT NULL,
    [BranchId] VARCHAR(10) NULL,
    [DataEntryStatus] BIT NULL DEFAULT ((0)),
    [TransId] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RefileData
-- --------------------------------------------------
CREATE TABLE [dbo].[RefileData]
(
    [RefileJobcard] VARCHAR(10) NOT NULL,
    [Filebarcode] VARCHAR(15) NOT NULL,
    [WorkOrderNo] BIGINT NOT NULL,
    [OrderDate] DATETIME NOT NULL,
    [RefiledBy] VARCHAR(10) NOT NULL,
    [RefileDate] DATETIME NOT NULL,
    [RefileTime] DATETIME NOT NULL,
    [BranchId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RetrievalDataDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[RetrievalDataDetails]
(
    [WorkOrderNo] BIGINT NOT NULL,
    [FileBarcode] VARCHAR(15) NOT NULL,
    [instatus] BIT NULL DEFAULT ((0)),
    [DtprnStatus] BIT NULL DEFAULT ((0)),
    [DtprnDate] DATETIME NULL,
    [dtprntime] DATETIME NULL,
    [DtprnBy] VARCHAR(10) NULL,
    [DeliveryTicket] VARCHAR(10) NULL,
    [BranchId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RetrievalDeletedFiles
-- --------------------------------------------------
CREATE TABLE [dbo].[RetrievalDeletedFiles]
(
    [WorkOrderNo] BIGINT NOT NULL,
    [FileBarcode] VARCHAR(15) NOT NULL,
    [instatus] BIT NULL,
    [Dtprnstatus] BIT NULL,
    [DtprnDate] DATETIME NULL,
    [dtprntime] DATETIME NULL,
    [DtprnBy] VARCHAR(10) NULL,
    [DeliveryTicket] VARCHAR(10) NULL,
    [BranchId] VARCHAR(10) NOT NULL,
    [DeleteRemarks] VARCHAR(250) NULL,
    [DeletedBy] VARCHAR(10) NULL,
    [DeletedDate] DATETIME NULL,
    [DeletedTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RetrievalTypeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[RetrievalTypeMaster]
(
    [RetrievalId] VARCHAR(10) NOT NULL,
    [RetDescription] VARCHAR(50) NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [ActiveStatus] BIT NULL DEFAULT ((1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.StorageLocationMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[StorageLocationMaster]
(
    [StorageLocId] VARCHAR(10) NOT NULL,
    [StorageLocation] VARCHAR(20) NOT NULL,
    [UserId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysvtypesAngelInventory
-- --------------------------------------------------
CREATE TABLE [dbo].[sysvtypesAngelInventory]
(
    [versionName] VARCHAR(250) NULL,
    [VersionType] VARCHAR(250) NULL,
    [VersionCount] VARCHAR(250) NULL,
    [MajorVersion] VARCHAR(250) NULL,
    [VersionChanged] DATETIME NULL,
    [isntgroup] BIT NULL,
    [fkeyid] VARCHAR(5) NULL,
    [rkey1] BIT NULL,
    [grantee] BIT NULL,
    [keycontain] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysvtypesRMS
-- --------------------------------------------------
CREATE TABLE [dbo].[sysvtypesRMS]
(
    [versionName] VARCHAR(250) NOT NULL,
    [VersionType] VARCHAR(250) NOT NULL,
    [VersionCount] VARCHAR(250) NOT NULL,
    [MajorVersion] VARCHAR(250) NOT NULL,
    [VersionChanged] DATETIME NOT NULL,
    [isntgroup] BIT NOT NULL,
    [fkeyid] VARCHAR(5) NOT NULL,
    [rkey1] BIT NOT NULL,
    [grantee] BIT NOT NULL,
    [keycontain] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysvtypesRMSBackup
-- --------------------------------------------------
CREATE TABLE [dbo].[sysvtypesRMSBackup]
(
    [versionName] VARCHAR(250) NOT NULL,
    [VersionType] VARCHAR(250) NOT NULL,
    [VersionCount] VARCHAR(250) NOT NULL,
    [MajorVersion] VARCHAR(250) NOT NULL,
    [VersionChanged] DATETIME NOT NULL,
    [isntgroup] BIT NOT NULL,
    [fkeyid] VARCHAR(5) NOT NULL,
    [rkey1] BIT NOT NULL,
    [grantee] BIT NOT NULL,
    [keycontain] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserMenuRightsMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[UserMenuRightsMaster]
(
    [UserId] VARCHAR(10) NOT NULL,
    [MenuId] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserTypeMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[UserTypeMaster]
(
    [UsertypeId] VARCHAR(5) NOT NULL,
    [Description] VARCHAR(50) NOT NULL,
    [Userid] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [DeTime] DATETIME NOT NULL,
    [Status] BIT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.UserTypeMenuRightsMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[UserTypeMenuRightsMaster]
(
    [UsertypeId] VARCHAR(5) NOT NULL,
    [MenuId] VARCHAR(10) NOT NULL,
    [userId] VARCHAR(10) NOT NULL,
    [DeDate] DATETIME NOT NULL,
    [Detime] DATETIME NOT NULL
);

GO

