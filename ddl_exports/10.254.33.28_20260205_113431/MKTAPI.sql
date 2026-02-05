-- DDL Export
-- Server: 10.254.33.28
-- Database: MKTAPI
-- Exported: 2026-02-05T11:34:36.972355

USE MKTAPI;
GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VPay_LedgerLimit_Update
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPay_LedgerLimit_Update] ADD CONSTRAINT [FK__tbl_VPay___Reque__19DFD96B] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[tbl_VPayRequest] ([RequestID])

GO

-- --------------------------------------------------
-- FOREIGN_KEY dbo.tbl_VPay_Validation_Source
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPay_Validation_Source] ADD CONSTRAINT [FK__tbl_VPay___Reque__160F4887] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[tbl_VPayRequest] ([RequestID])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_POST_DATA
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_mul] ON [dbo].[TBL_POST_DATA] ([RETURN_FLD5], [VDATE], [ROWSTATE])

GO

-- --------------------------------------------------
-- INDEX dbo.TBL_POST_DATA
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_missing_tbl_post_data_fldauto] ON [dbo].[TBL_POST_DATA] ([FLDAUTO])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VPay_BankPrefixSegment_Mst
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPay_BankPrefixSegment_Mst] ADD CONSTRAINT [PK__tbl_VPay__3214EC0746E78A0C] PRIMARY KEY ([Id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VPay_Error_Log
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPay_Error_Log] ADD CONSTRAINT [PK__tbl_VPay__35856A2A5070F446] PRIMARY KEY ([ErrorId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VPay_Validation_Source
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPay_Validation_Source] ADD CONSTRAINT [PK__tbl_VPay__64FD1BC114270015] PRIMARY KEY ([Validation_Source_ID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VPayRequest
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPayRequest] ADD CONSTRAINT [PK__tbl_VPay__33A8519A09A971A2] PRIMARY KEY ([RequestID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_VPayRequest_Deleted
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_VPayRequest_Deleted] ADD CONSTRAINT [PK__tbl_VPay__3214EC075AEE82B9] PRIMARY KEY ([Id])

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
-- PROCEDURE dbo.spx_VPay_ErrorDetails_Save
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[spx_VPay_ErrorDetails_Save]
 @ErrorNo varchar(20)=null,        
 @Description varchar(MAX)=null,        
 @ModuleName varchar(500)=null,        
 @Module_Parameter varchar(1000)=null,        
 @Proc_Name varchar(100)=null,        
 @MethodName varchar(500)=null,        
 @VenDorName varchar(100) =null,
 @RequsetTime Datetime=null       
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Msg varchar(200) = '', @IsSuccess BIT = 0;
	Insert into dbo.tbl_VPay_Error_Log(ErrorNo,[Description],ModuleName,Module_Parameter,Proc_Name,MethodName,VenDorName,Creation_Date,ServerRequestTime)        
	Values(@ErrorNo,@Description,@ModuleName,@Module_Parameter,@Proc_Name,@MethodName,@VenDorName,getdate(),@RequsetTime)  
	IF Scope_identity() > 0
	BEGIN
		SET @IsSuccess = 1;
		SET @Msg = 'Record inserted successfully!!!';
	END

	SELECT @Msg 'Message', @IsSuccess 'IsSuccess'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_GetBankPrefixSegment
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_GetBankPrefixSegment]
@BankAccountNo varchar(50)
As
Begin
	SET NOCOUNT ON;
	select Id,
			BankCode,
			BankAccountNo,
			IFSCCode,
			Prefix,
			Segment,
			Exchange,
			IsActive from tbl_VPay_BankPrefixSegment_Mst M With(nolock) Where M.BankAccountNo=@BankAccountNo and IsActive=1
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_GetGroupID
-- --------------------------------------------------
Create procedure [dbo].[spx_VPay_GetGroupID]
@ClientCode varchar(50)
As
Begin
	SET NOCOUNT ON;
	select tag from [196.1.115.132].MIS.dbo.V_odinclientinfo_GroupID With(nolock) Where pcode=@ClientCode
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_GetUserType
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_GetUserType]
@ClientCode varchar(50)
As
Begin
	SET NOCOUNT ON;
	--select case when(SELECT COUNT(*) FROM [172.31.15.250].[uploader-db].DBO.InvestorClient WITH(NOLOCK)Where AccountId=@ClientCode)>0 then 'omnesys' else 'ft' end as 'UserType'
	select 'ft' as 'UserType'
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_Insert_LedgerLimit_UpdateRequest
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_Insert_LedgerLimit_UpdateRequest]
@Id bigint,
@RequestID bigint,
@ClientID Varchar(150)=NULL, 
@GroupID Varchar(150)=NULL,
@InternalRefNo Varchar(150)=NULL,
@Amount decimal=NULL,
@BankCode Varchar(50)=NULL, 
@BankName Varchar(150)=NULL,
@BankRefNo Varchar(150)=NULL,
@AccountNo Varchar(150)=NULL,
@Exchange Varchar(50)=NULL,
@Segment Varchar(50)=NULL, 
@ProductID Varchar(150)=NULL, 
@UserType Varchar(50)=NULL,
@ModuleName Varchar(50)=NULL,
@ReqSource Varchar(50)=NULL,
@RequestDate varchar(12)=NULL,
@IsRemitterAccountAvailable varchar(1)=NULL,
@ValidatedAccountNo varchar(50)=NULL,
@ResClientId varchar(10)=null,
@ResStatus varchar(100)=null
As 
Begin
	SET NOCOUNT ON;
	DECLARE @Message VARCHAR(100) = '', @IsSuccess BIT = 0;
	Insert into tbl_VPay_LedgerLimit_Update
	(
		RequestID,
		ClientID, 
		GroupID,
		InternalRefNo,
		Amount,
		BankCode, 
		BankName,
		BankRefNo,
		AccountNo,
		Exchange,
		Segment, 
		ProductID, 
		UserType,
		ModuleName,
		ReqSource,
		RequestDate,
		IsRemitterAccountAvailable,
		ValidatedAccountNo,
		ResClientId,
		ResStatus
	)
	values
	(
		@RequestID,
		@ClientID, 
		@GroupID,
		@InternalRefNo,
		@Amount,
		@BankCode, 
		@BankName,
		@BankRefNo,
		@AccountNo,
		@Exchange,
		@Segment, 
		@ProductID, 
		@UserType,
		@ModuleName,
		@ReqSource,
		@RequestDate,
		@IsRemitterAccountAvailable,
		@ValidatedAccountNo,
		@ResClientId,
		@ResStatus
	)
	SET @Id = SCOPE_IDENTITY();
	SET @IsSuccess = 1
	SET @Message = 'Record inserted successfully!!!'
	SELECT  @IsSuccess 'IsSuccess', @Message 'Message', @Id 'Id'
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_Insert_Validation_Source
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_Insert_Validation_Source]
@Id BIGINT OUTPUT,
@RequestID BIGINT,
@Res_PARTY_CODE Varchar(150)=NULL,
@Res_BANK_NAME Varchar(150)=NULL,
@Res_BRANCH_NAME Varchar(200)=NULL,
@Res_ACCNO Varchar(20)=NULL,
@Res_IFSC_CODE Varchar(25)=NULL,
@Res_MICR_CODE Varchar(25)=NULL,
@Res_IsNetBanking varchar(10)=NULL,
@Res_DEFALUT_ID varchar(10)=NULL,
@Res_Validation_Date datetime=NULL,
@Acc_FiveDigit_validated varchar(1)=NULL,
@Flag varchar(10)
as 
	begin
	SET NOCOUNT ON;
	DECLARE @Message VARCHAR(100) = '', @IsSuccess BIT = 0;
	if (@Flag = 'SAVE')
	begin
		Insert into tbl_VPay_Validation_Source
		(
			RequestID,
			Res_PARTY_CODE,
			Res_BANK_NAME,
			Res_BRANCH_NAME,
			Res_ACCNO,
			Res_IFSC_CODE,
			Res_MICR_CODE,
			Res_IsNetBanking,
			Res_DEFALUT_ID,
			Res_Validation_Date,
			Acc_FiveDigit_validated
		)
		values
		(
			@RequestID,
			@Res_PARTY_CODE,
			@Res_BANK_NAME,
			@Res_BRANCH_NAME,
			@Res_ACCNO,
			@Res_IFSC_CODE,
			@Res_MICR_CODE,
			@Res_IsNetBanking,
			@Res_DEFALUT_ID,
			GETDATE(),
			@Acc_FiveDigit_validated
		)
		SET @Id = SCOPE_IDENTITY();
		SET @IsSuccess = 1
		SET @Message = 'Record inserted successfully!!!'
	end
	else
	begin
		UPDATE tbl_VPay_Validation_Source
		set Res_Validation_Date=@Res_Validation_Date,
			Acc_FiveDigit_validated=@Acc_FiveDigit_validated
			WHERE Validation_Source_ID=@Id
		SET @IsSuccess = 1
		SET @Message = 'Record updated successfully!!!'
	end
	SELECT  @IsSuccess 'IsSuccess', @Message 'Message', @Id 'Id'
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_Insert_VPayRequest
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_Insert_VPayRequest]
	@Id BIGINT OUTPUT,
	@Transaction_Date varchar(30),
	@Account_Number Varchar(20),
	@Client_Code Varchar(150),
	@Virtual_Account_No Varchar(150),
	@Bene_Name Varchar(150),
	@Transaction_Description Varchar(500),
	@Debit_Credit Varchar(10),
	@Cheque_No Varchar(20),
	@Reference_No Varchar(50),
	@Amount Money,
	@Type Varchar(10),
	@Remitter_IFSC Varchar(25),
	@Remitter_Bank_Name Varchar(150),
	@Remitting_Bank_Branch Varchar(200),
	@Remitter_Account_No Varchar(150),
	@Remitter_Name Varchar(150),
	@UniqueID varchar(50),
	--@Flag varchar(10),
	@Res_BankReason varchar(50)=NULL,
	@Res_BankStatus varchar(5)=NULL,
	@Res_BankUniqueId varchar(50)=NULL,
	@Res_MainReason varchar(100)=NULL
as 
	begin
		SET NOCOUNT ON;
		DECLARE @Message VARCHAR(100) = '', @IsSuccess BIT = 0;
		if(@Id = 0)
		begin
			Insert into tbl_VPayRequest
			(
				Transaction_Date,
				Account_Number,
				Client_Code,
				Virtual_Account_No,
				Bene_Name,
				Transaction_Description,
				Debit_Credit,
				Cheque_No,
				Reference_No,
				Amount,
				Type,
				Remitter_IFSC,
				Remitter_Bank_Name,
				Remitting_Bank_Branch,
				Remitter_Account_No,
				Remitter_Name,
				UniqueID,
				RequestDate,
				Res_BankReason,
				Res_BankStatus,
				Res_BankUniqueId,
				Res_MainReason
			)
			values
			(
				@Transaction_Date,
				@Account_Number,
				@Client_Code,
				@Virtual_Account_No,
				@Bene_Name,
				@Transaction_Description,
				@Debit_Credit,
				@Cheque_No,
				@Reference_No,
				@Amount,
				@Type,
				@Remitter_IFSC,
				@Remitter_Bank_Name,
				@Remitting_Bank_Branch,
				@Remitter_Account_No,
				@Remitter_Name,
				@UniqueID,
				GETDATE(),
				@Res_BankReason,
				@Res_BankStatus,
				@Res_BankUniqueId,
				@Res_MainReason
			)
			SET @Id = SCOPE_IDENTITY();
			SET @IsSuccess = 1
			SET @Message = 'Record inserted successfully!!!'
			
		end
		else
		begin
			UPDATE tbl_VPayRequest
			set Res_BankReason =@Res_BankReason,
				Res_BankStatus =@Res_BankStatus,
				Res_BankUniqueId =@Res_BankUniqueId,
				Res_MainReason =@Res_MainReason,
				Res_Date=GETDATE()
			Where RequestID=@Id
			
			SET @IsSuccess = 1
			SET @Message = 'Record updated successfully!!!'
		end
		
		
		
		SELECT  @IsSuccess 'IsSuccess', @Message 'Message', @Id 'Id'
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_Validate_BankAcc_VirtualAcc_VPayRequest
-- --------------------------------------------------
CREATE procedure [dbo].[spx_VPay_Validate_BankAcc_VirtualAcc_VPayRequest]
@BankAccountNo varchar(50),
@ClientCode varchar(50),
@VirtualAccountNo varchar(50)
As
Begin
	SET NOCOUNT ON;
	DECLARE @Message VARCHAR(100) = '', @IsSuccess BIT = 0;
	
		If EXISTS(select * from tbl_VPay_BankPrefixSegment_Mst With(Nolock) Where BankAccountNo = @BankAccountNo and Prefix+@ClientCode = @VirtualAccountNo)	
		begin
			set @IsSuccess=1
			set @Message='Data Validate successfully'
		end
		else
		begin
			set @IsSuccess=0
			set @Message='Bank account no & Virtual account no cobmination not exist in Database'
		end
		
		--if(@IsSuccess = 1)
		--begin
		--	If EXISTS(select * from tbl_VPay_BankPrefixSegment_Mst With(Nolock) Where Prefix+@ClientCode = @VirtualAccountNo)	
		--	begin
		--		set @IsSuccess=1
		--		set @Message='Data Validate successfully'
		--	end
		--	else
		--	begin
		--		set @IsSuccess=0
		--		set @Message='Virtual account no does not exist in Database'
		--	end
		--end
	Select @IsSuccess 'IsSuccess', @Message 'Message'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.spx_VPay_Validate_VPayRequest
-- --------------------------------------------------
--EXEC spx_VPay_Validate_VPayRequest '502514281450P414','00441920618','103.00','20-May-2020'
CREATE procedure [dbo].[spx_VPay_Validate_VPayRequest]
@Reference_No Varchar(50),
@UniqueID varchar(50),
@Amount decimal,
@Transaction_Date Varchar(500),
@Account_Number varchar(20),
@Virtual_Account_No varchar(150)
As
Begin
	SET NOCOUNT ON;
	DECLARE @Message VARCHAR(100) = '', @IsSuccess BIT = 0,@RequestId bigint,@ExistingBankReasonResponse varchar(50),@ExistingBankStatus varchar(5);
	Declare @BankKey varchar(1000)=@Reference_No+cast(@Amount as varchar(20))+@Transaction_Date
	
	
	Select TOP 1 @RequestId=RequestID,@ExistingBankReasonResponse=Res_BankReason,@ExistingBankStatus=Res_BankStatus from tbl_VPayRequest With(Nolock) 
				Where (UniqueID=@UniqueID and Account_Number=@Account_Number and Virtual_Account_No=@Virtual_Account_No) or  --Reference_No=@Reference_No or 
				(Reference_No+cast(Amount as varchar(20))+Transaction_Date=@BankKey)
				and CAST(RequestDate as date) >= CAST(DATEADD(mm, -6, GETDATE()) as date)
				Order by RequestDate desc
				
	IF (ISNULL(@RequestId,'') != '')
	BEGIN
		set @IsSuccess=0
		set @Message='Data Already exist against: '+ CAST(@RequestId as varchar(10)) +''
	END
	ELSE
	BEGIN
		set @IsSuccess=1
		set @Message='Data Validate successfully'
	END
	
	--If EXISTS(Select RequestID from tbl_VPayRequest With(Nolock) 
	--			Where UniqueID=@UniqueID or  --Reference_No=@Reference_No or 
	--			(Reference_No+cast(Amount as varchar(20))+Transaction_Date=@BankKey)
	--			and CAST(RequestDate as date) >= CAST(DATEADD(mm, -6, GETDATE()) as date))
	--			Begin
	--				set @IsSuccess=0
	--				set @Message='Data Already exist in Database'
	--			End
	--			else
	--			Begin
	--				set @IsSuccess=1
	--				set @Message='Data Validate successfully'
	--			End
	
	
	Select @IsSuccess 'IsSuccess', @Message 'Message',@ExistingBankReasonResponse 'ExistingBankReason',@ExistingBankStatus 'EsistingBankStatus'
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FINDINUSP
-- --------------------------------------------------
    
CREATE PROCEDURE USP_FINDINUSP                  
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
-- TABLE dbo.abc_lg
-- --------------------------------------------------
CREATE TABLE [dbo].[abc_lg]
(
    [fld1] VARCHAR(10) NULL
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
-- TABLE dbo.tbl_FundTransfer_JV
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FundTransfer_JV]
(
    [Fldauto] INT IDENTITY(1,1) NOT NULL,
    [party_code] VARCHAR(50) NULL,
    [FromSegment] VARCHAR(50) NULL,
    [ToSegment] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [EntryDate] DATETIME NULL,
    [Flag] VARCHAR(50) NULL,
    [Remarks] VARCHAR(100) NULL,
    [VALID] VARCHAR(1) NULL,
    [FROM_JV] VARCHAR(20) NULL,
    [TO_JV] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_POST_DATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_POST_DATA]
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
-- TABLE dbo.tbl_post_data_021222011
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_post_data_021222011]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(20) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_post_data_04022020
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_post_data_04022020]
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
-- TABLE dbo.tbl_post_data_28112017
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_post_data_28112017]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(20) NULL,
    [RETURN_FLD2] VARCHAR(20) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_POST_DATA_trig
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_POST_DATA_trig]
(
    [FLDAUTO] INT IDENTITY(1,1) NOT NULL,
    [VOUCHERTYPE] SMALLINT NULL,
    [SNO] INT NULL,
    [VDATE] DATETIME NULL,
    [EDATE] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [CREDITAMT] MONEY NULL,
    [DEBITAMT] MONEY NULL,
    [NARRATION] VARCHAR(255) NULL,
    [BANKCODE] VARCHAR(10) NULL,
    [MARGINCODE] VARCHAR(10) NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BRANCHNAME] VARCHAR(100) NULL,
    [BRANCHCODE] VARCHAR(10) NULL,
    [DDNO] VARCHAR(15) NULL,
    [CHEQUEMODE] VARCHAR(1) NULL,
    [CHEQUEDATE] DATETIME NULL,
    [CHEQUENAME] VARCHAR(50) NULL,
    [CLEAR_MODE] VARCHAR(1) NULL,
    [TPACCOUNTNUMBER] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(20) NULL,
    [MKCK_FLAG] TINYINT NULL,
    [RETURN_FLD1] VARCHAR(30) NULL,
    [RETURN_FLD2] VARCHAR(30) NULL,
    [RETURN_FLD3] VARCHAR(20) NULL,
    [RETURN_FLD4] VARCHAR(20) NULL,
    [RETURN_FLD5] VARCHAR(20) NULL,
    [ROWSTATE] TINYINT NULL,
    [COMP_NAME] VARCHAR(50) NULL,
    [UPDDATE] DATETIME NULL,
    [DBACTION] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPay_BankPrefixSegment_Mst
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPay_BankPrefixSegment_Mst]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [BankCode] VARCHAR(50) NULL,
    [BankAccountNo] VARCHAR(50) NULL,
    [IFSCCode] VARCHAR(15) NULL,
    [Prefix] VARCHAR(20) NULL,
    [Segment] VARCHAR(20) NULL,
    [Exchange] VARCHAR(20) NULL,
    [IsActive] BIT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPay_Error_Log
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPay_Error_Log]
(
    [ErrorId] BIGINT IDENTITY(1,1) NOT NULL,
    [ErrorNo] VARCHAR(20) NULL,
    [Description] VARCHAR(MAX) NULL,
    [ModuleName] VARCHAR(500) NULL,
    [Module_Parameter] VARCHAR(1000) NULL,
    [Proc_Name] VARCHAR(100) NULL,
    [MethodName] VARCHAR(500) NULL,
    [VenDorName] VARCHAR(100) NULL,
    [Creation_Date] DATETIME NULL,
    [ServerRequestTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPay_LedgerLimit_Update
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPay_LedgerLimit_Update]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [RequestID] BIGINT NULL,
    [ClientID] VARCHAR(150) NULL,
    [GroupID] VARCHAR(150) NULL,
    [InternalRefNo] VARCHAR(150) NULL,
    [Amount] DECIMAL(18, 0) NULL,
    [BankCode] VARCHAR(50) NULL,
    [BankName] VARCHAR(150) NULL,
    [BankRefNo] VARCHAR(150) NULL,
    [AccountNo] VARCHAR(150) NULL,
    [Exchange] VARCHAR(50) NULL,
    [Segment] VARCHAR(50) NULL,
    [ProductID] VARCHAR(150) NULL,
    [UserType] VARCHAR(50) NULL,
    [ModuleName] VARCHAR(50) NULL,
    [ReqSource] VARCHAR(50) NULL,
    [RequestDate] VARCHAR(12) NULL,
    [ResClientId] VARCHAR(10) NULL,
    [ResStatus] VARCHAR(100) NULL,
    [IsRemitterAccountAvailable] VARCHAR(1) NULL,
    [ValidatedAccountNo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPay_Validation_Source
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPay_Validation_Source]
(
    [Validation_Source_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [RequestID] BIGINT NULL,
    [Res_PARTY_CODE] VARCHAR(150) NULL,
    [Res_BANK_NAME] VARCHAR(150) NULL,
    [Res_BRANCH_NAME] VARCHAR(200) NULL,
    [Res_ACCNO] VARCHAR(20) NULL,
    [Res_IFSC_CODE] VARCHAR(25) NULL,
    [Res_MICR_CODE] VARCHAR(25) NULL,
    [Res_IsNetBanking] VARCHAR(10) NULL,
    [Res_DEFALUT_ID] VARCHAR(10) NULL,
    [Res_Validation_Date] DATETIME NULL,
    [Acc_FiveDigit_validated] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPayRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPayRequest]
(
    [RequestID] BIGINT IDENTITY(1,1) NOT NULL,
    [Transaction_Date] VARCHAR(30) NULL,
    [Account_Number] VARCHAR(20) NULL,
    [Client_Code] VARCHAR(150) NULL,
    [Virtual_Account_No] VARCHAR(150) NULL,
    [Bene_Name] VARCHAR(150) NULL,
    [Transaction_Description] VARCHAR(500) NULL,
    [Debit_Credit] VARCHAR(10) NULL,
    [Cheque_No] VARCHAR(20) NULL,
    [Reference_No] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [Type] VARCHAR(10) NULL,
    [Remitter_IFSC] VARCHAR(25) NULL,
    [Remitter_Bank_Name] VARCHAR(150) NULL,
    [Remitting_Bank_Branch] VARCHAR(200) NULL,
    [Remitter_Account_No] VARCHAR(150) NULL,
    [Remitter_Name] VARCHAR(150) NULL,
    [UniqueID] VARCHAR(50) NULL,
    [RequestDate] DATETIME NULL,
    [Res_BankReason] VARCHAR(50) NULL,
    [Res_BankStatus] VARCHAR(5) NULL,
    [Res_BankUniqueId] VARCHAR(50) NULL,
    [Res_MainReason] VARCHAR(100) NULL,
    [Res_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_VPayRequest_Deleted
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_VPayRequest_Deleted]
(
    [Id] BIGINT IDENTITY(1,1) NOT NULL,
    [RequestID] BIGINT NULL,
    [Transaction_Date] VARCHAR(30) NULL,
    [Account_Number] VARCHAR(20) NULL,
    [Client_Code] VARCHAR(150) NULL,
    [Virtual_Account_No] VARCHAR(150) NULL,
    [Bene_Name] VARCHAR(150) NULL,
    [Transaction_Description] VARCHAR(500) NULL,
    [Debit_Credit] VARCHAR(10) NULL,
    [Cheque_No] VARCHAR(20) NULL,
    [Reference_No] VARCHAR(50) NULL,
    [Amount] MONEY NULL,
    [Type] VARCHAR(10) NULL,
    [Remitter_IFSC] VARCHAR(25) NULL,
    [Remitter_Bank_Name] VARCHAR(150) NULL,
    [Remitting_Bank_Branch] VARCHAR(200) NULL,
    [Remitter_Account_No] VARCHAR(150) NULL,
    [Remitter_Name] VARCHAR(150) NULL,
    [UniqueID] VARCHAR(50) NULL,
    [RequestDate] DATETIME NULL,
    [Res_BankReason] VARCHAR(50) NULL,
    [Res_BankStatus] VARCHAR(5) NULL,
    [Res_BankUniqueId] VARCHAR(50) NULL,
    [Res_MainReason] VARCHAR(100) NULL,
    [DeletedDate] DATETIME NULL,
    [local_net_address] VARCHAR(15) NULL,
    [client_net_address] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.LEDGER_DEL1
-- --------------------------------------------------

CREATE TRIGGER [dbo].[LEDGER_DEL1] ON [dbo].[TBL_POST_DATA] 
FOR DELETE 
AS
INSERT INTO TBL_POST_DATA_trig
SELECT VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,
BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,
CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,
RETURN_FLD4,RETURN_FLD5,ROWSTATE,COMP_NAME = HOST_NAME(), UPDDATE=GETDATE(), DBACTION = 'DELETED'
FROM DELETED

GO

-- --------------------------------------------------
-- TRIGGER dbo.ONLINE_MOD1
-- --------------------------------------------------

CREATE TRIGGER [dbo].[ONLINE_MOD1] ON [dbo].[TBL_POST_DATA] 
FOR UPDATE
AS

INSERT INTO TBL_POST_DATA_trig
SELECT VOUCHERTYPE,SNO,VDATE,EDATE,CLTCODE,CREDITAMT,DEBITAMT,NARRATION,
BANKCODE,MARGINCODE,BANKNAME,BRANCHNAME,BRANCHCODE,DDNO,CHEQUEMODE,CHEQUEDATE,CHEQUENAME,
CLEAR_MODE,TPACCOUNTNUMBER,EXCHANGE,SEGMENT,MKCK_FLAG,RETURN_FLD1,RETURN_FLD2,RETURN_FLD3,
RETURN_FLD4,RETURN_FLD5,ROWSTATE,COMP_NAME = HOST_NAME(), UPDDATE=GETDATE(), DBACTION = 'MODIFIED'
FROM DELETED

GO

-- --------------------------------------------------
-- TRIGGER dbo.trgOntbl_VPayRequestDeletion
-- --------------------------------------------------
CREATE TRIGGER [dbo].[trgOntbl_VPayRequestDeletion]
       ON [dbo].[tbl_VPayRequest]
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;
	Declare @local_net_address Varchar(50),@client_net_address Varchar(50)
    Select @local_net_address= Convert(varchar(50),CONNECTIONPROPERTY('local_net_address'))
	Select @client_net_address= Convert(varchar(50),CONNECTIONPROPERTY('client_net_address'))
	DECLARE @RequestID INT
	
	Select @RequestID=Deleted.RequestID
    FROM Deleted
    
			Insert into tbl_VPayRequest_Deleted
			(
				RequestID,
				Transaction_Date,
				Account_Number,
				Client_Code,
				Virtual_Account_No,
				Bene_Name,
				Transaction_Description,
				Debit_Credit,
				Cheque_No,
				Reference_No,
				Amount,
				Type,
				Remitter_IFSC,
				Remitter_Bank_Name,
				Remitting_Bank_Branch,
				Remitter_Account_No,
				Remitter_Name,
				UniqueID,
				RequestDate,
				Res_BankReason,
				Res_BankStatus,
				Res_BankUniqueId,
				Res_MainReason,
				DeletedDate,
				local_net_address,
				client_net_address
			)
			SELECT
				RequestID,
				Transaction_Date,
				Account_Number,
				Client_Code,
				Virtual_Account_No,
				Bene_Name,
				Transaction_Description,
				Debit_Credit,
				Cheque_No,
				Reference_No,
				Amount,
				Type,
				Remitter_IFSC,
				Remitter_Bank_Name,
				Remitting_Bank_Branch,
				Remitter_Account_No,
				Remitter_Name,
				UniqueID,
				RequestDate,
				Res_BankReason,
				Res_BankStatus,
				Res_BankUniqueId,
				Res_MainReason,
				GETDATE(),
				@local_net_address,
				@client_net_address
			FROM Deleted
END

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
-- VIEW dbo.vw_vPayData
-- --------------------------------------------------


CREATE VIEW [dbo].[vw_vPayData] AS
select 
R.Transaction_Date 'Transaction Date',
R.Account_Number 'Account No',
R.Client_Code 'Client Code',
R.Virtual_Account_No 'Virtual Account No',
R.Bene_Name 'Benf. Name',
R.Transaction_Description 'Description',
R.Debit_Credit 'Debit-Credit',
R.Cheque_No 'Cheque No',
R.Reference_No 'Bank Refenence No',
R.Amount 'Amount',
R.Type 'Transaction Type',
R.Remitter_IFSC 'Remitter IFSC',
R.Remitter_Bank_Name 'Remitter Bank Name',
R.Remitting_Bank_Branch 'Remitter Bank Branch',
R.Remitter_Account_No 'Remitter Account No',
R.Remitter_Name 'Remitter Name',
R.UniqueID 'Bank Unique Id',
R.RequestDate,
R.Res_BankReason 'Bank Response',
R.Res_BankStatus 'Bank Status',
R.Res_MainReason 'Main Reason',
L.InternalRefNo 'Internal Reference No',
L.ResStatus 'Limit/Ledger Update' from tbl_VPayRequest R WITH(NOLOCK)
LEFT JOIN tbl_VPay_LedgerLimit_Update L WITH(NOLOCK) ON R.RequestID=L.RequestID

GO

