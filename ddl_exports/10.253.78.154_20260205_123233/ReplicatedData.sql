-- DDL Export
-- Server: 10.253.78.154
-- Database: ReplicatedData
-- Exported: 2026-02-05T12:32:34.905000

USE ReplicatedData;
GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_foliono] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([FolioNo])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_SearchTrxn] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([TranDate], [BrokerId], [RMCode], [OnLineFlag], [CreationDate])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_transactionDetail_InvCode] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([InvestorCode])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_transactionDetail_SchCode] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([SchCode])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Ix_TransactionDetail_AgentCode] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([AgentCode]) INCLUDE ([InvestorCode])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_TransactionDetail_InvestorCode_TranDate_Units] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([InvestorCode], [TranDate], [Units]) INCLUDE ([SchCode], [TrxnType], [Amount], [RevTag])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Ix_TransactionDetail_Trandate] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([TranDate], [Units]) INCLUDE ([InvestorCode], [SchCode], [TrxnType], [RevTag])

GO

-- --------------------------------------------------
-- INDEX dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [NCI_TRANSACTIONDETAIL_AGENTCODE_TRANDATE] ON [dbo].[ABRILAAWMutualFundTransactionDetail] ([AgentCode], [TranDate]) INCLUDE ([TranCode], [SchCode], [FolioNo], [TrxnType], [SubTrxnType], [Amount], [Units], [Rate])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_BSEEQ_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_tbl_MarketTickInfo_BSEEQ_Prev_nMarketSegmentId] ON [dbo].[tbl_MarketTickInfo_BSEEQ_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_MCX_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_tbl_MarketTickInfo_MCX_Prev_nMarketSegmentId] ON [dbo].[tbl_MarketTickInfo_MCX_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_NCDEX_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_tbl_MarketTickInfo_NCDEX_Prev_nMarketSegmentId] ON [dbo].[tbl_MarketTickInfo_NCDEX_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_NSECDS_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_tbl_MarketTickInfo_NSECDS_Prev_nMarketSegmentId] ON [dbo].[tbl_MarketTickInfo_NSECDS_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_NSEEQ_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_missing_tbl_MarketTickInfo_NSEEQ_Prev] ON [dbo].[tbl_MarketTickInfo_NSEEQ_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketTickInfo_NSEFAO_Prev
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_tbl_MarketTickInfo_NSEFAO_Prev_nMarketSegmentId_nToken] ON [dbo].[tbl_MarketTickInfo_NSEFAO_Prev] ([nMarketSegmentId], [nToken])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
ALTER TABLE [dbo].[ABRILAAWMutualFundTransactionDetail] ADD CONSTRAINT [PK_TrnsactionDetail] PRIMARY KEY ([TranCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_BSEEQ
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_BSEEQ] ADD CONSTRAINT [PK_tbl_MarketTickInfo_BSEEQ] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_BSEEQ_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_BSEEQ_Prev] ADD CONSTRAINT [pk_MarketTickInfo_BSEEQ_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_BSEFAO
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_BSEFAO] ADD CONSTRAINT [PK_tbl_MarketTickInfo_BSEFAO] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_BSEFAO_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_BSEFAO_Prev] ADD CONSTRAINT [pk_MarketTickInfo_BSEFAO_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_MCX
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_MCX] ADD CONSTRAINT [PK_tbl_MarketTickInfo_MCX] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_MCX_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_MCX_Prev] ADD CONSTRAINT [pk_MarketTickInfo_MCX_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NCDEX
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NCDEX] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NCDEX] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NCDEX_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NCDEX_Prev] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NCDEX_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSECDS
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSECDS] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSECDS] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSECDS_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSECDS_Prev] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSECDS_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSEEQ
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSEEQ] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSEEQ] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSEEQ_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSEEQ_Prev] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSEEQ_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSEFAO
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSEFAO] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSEFAO] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarketTickInfo_NSEFAO_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarketTickInfo_NSEFAO_Prev] ADD CONSTRAINT [PK_tbl_MarketTickInfo_NSEFAO_Prev_nToken] PRIMARY KEY ([nToken], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_BSEEQ
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_BSEEQ] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_BSEEQ] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_BSEEQ_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_BSEEQ_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_BSEEQ_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_MCX
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_MCX] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_MCX] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_MCX_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_MCX_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_MCX_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NCDEX
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NCDEX] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NCDEX] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NCDEX_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NCDEX_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NCDEX_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSECDS
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSECDS] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSECDS] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSECDS_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSECDS_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSECDS_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSEEQ
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEEQ] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSEEQ] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSEEQ_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEEQ_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSEEQ_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSEFAO
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEFAO] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSEFAO] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_PeriodicMarketTickInfo_NSEFAO_Prev
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEFAO_Prev] ADD CONSTRAINT [PK_tbl_PeriodicMarketTickInfo_NSEFAO_Prev] PRIMARY KEY ([nToken], [nATP], [nMarketSegmentId], [nLastTradedTime])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboABRILAAWMutualFundTransactionDetail_25Feb2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboABRILAAWMutualFundTransactionDetail_25Feb2024]     @pkc1 varchar(20)
as
begin    	declare @primarykey_text nvarchar(100) = '' 	delete [dbo].[ABRILAAWMutualFundTransactionDetail] 
	where [TranCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TranCode] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ABRILAAWMutualFundTransactionDetail]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end    --

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboABRILAAWMutualFundTransactionDetail_25Feb2024
-- --------------------------------------------------
create procedure [sp_MSins_dboABRILAAWMutualFundTransactionDetail_25Feb2024]     @c1 varchar(20),     @c2 int,     @c3 datetime,     @c4 varchar(80),     @c5 varchar(50),     @c6 varchar(50),     @c7 varchar(50),     @c8 varchar(20),     @c9 varchar(50),     @c10 varchar(20),     @c11 varchar(50),     @c12 varchar(50),     @c13 decimal(38,2),     @c14 decimal(38,4),     @c15 decimal(38,4),     @c16 datetime,     @c17 char(1),     @c18 varchar(50),     @c19 varchar(50),     @c20 varchar(50),     @c21 varchar(50),     @c22 varchar(2),     @c23 varchar(10),     @c24 varchar(50),     @c25 varchar(25),     @c26 varchar(50),     @c27 numeric(17,2),     @c28 numeric(10,4),     @c29 numeric(10,2),     @c30 char(1),     @c31 varchar(50),     @c32 varchar(50),     @c33 datetime,     @c34 varchar(50),     @c35 varchar(50) as begin   	insert into [dbo].[ABRILAAWMutualFundTransactionDetail] ( 		[TranCode], 		[RegistrarID], 		[TranDate], 		[InvestorCode], 		[SchCode], 		[AppNo], 		[FolioNo], 		[TrxnType], 		[SWFlag], 		[SubTrxnType], 		[TranNo], 		[TranId], 		[Amount], 		[Units], 		[Rate], 		[NAVDate], 		[RevTag], 		[ReferenceNo], 		[BranchId], 		[AgentCode], 		[BrokerId], 		[InvestorType], 		[SwitchScheme], 		[SwitchFolio], 		[SwitchTranCode], 		[RMCode], 		[STT], 		[CommPer], 		[TranCharge], 		[OnLineFlag], 		[Location], 		[CreatedBy], 		[CreationDate], 		[ClientSource], 		[ClientCode] 	) values ( 		@c1, 		@c2, 		@c3, 		@c4, 		@c5, 		@c6, 		@c7, 		@c8, 		@c9, 		@c10, 		@c11, 		@c12, 		@c13, 		@c14, 		@c15, 		@c16, 		@c17, 		@c18, 		@c19, 		@c20, 		@c21, 		@c22, 		@c23, 		@c24, 		@c25, 		@c26, 		@c27, 		@c28, 		@c29, 		@c30, 		@c31, 		@c32, 		@c33, 		@c34, 		@c35	)  end    --

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboABRILAAWMutualFundTransactionDetail_25Feb2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboABRILAAWMutualFundTransactionDetail_25Feb2024]     @c1 varchar(20) = NULL,     @c2 int = NULL,     @c3 datetime = NULL,     @c4 varchar(80) = NULL,     @c5 varchar(50) = NULL,     @c6 varchar(50) = NULL,     @c7 varchar(50) = NULL,     @c8 varchar(20) = NULL,     @c9 varchar(50) = NULL,     @c10 varchar(20) = NULL,     @c11 varchar(50) = NULL,     @c12 varchar(50) = NULL,     @c13 decimal(38,2) = NULL,     @c14 decimal(38,4) = NULL,     @c15 decimal(38,4) = NULL,     @c16 datetime = NULL,     @c17 char(1) = NULL,     @c18 varchar(50) = NULL,     @c19 varchar(50) = NULL,     @c20 varchar(50) = NULL,     @c21 varchar(50) = NULL,     @c22 varchar(2) = NULL,     @c23 varchar(10) = NULL,     @c24 varchar(50) = NULL,     @c25 varchar(25) = NULL,     @c26 varchar(50) = NULL,     @c27 numeric(17,2) = NULL,     @c28 numeric(10,4) = NULL,     @c29 numeric(10,2) = NULL,     @c30 char(1) = NULL,     @c31 varchar(50) = NULL,     @c32 varchar(50) = NULL,     @c33 datetime = NULL,     @c34 varchar(50) = NULL,     @c35 varchar(50) = NULL,     @pkc1 varchar(20) = NULL,     @bitmap binary(5)
as
begin   	declare @primarykey_text nvarchar(100) = '' if (substring(@bitmap,1,1) & 1 = 1)
begin   update [dbo].[ABRILAAWMutualFundTransactionDetail] set     [TranCode] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [TranCode] end,     [RegistrarID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [RegistrarID] end,     [TranDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TranDate] end,     [InvestorCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InvestorCode] end,     [SchCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SchCode] end,     [AppNo] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AppNo] end,     [FolioNo] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [FolioNo] end,     [TrxnType] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [TrxnType] end,     [SWFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SWFlag] end,     [SubTrxnType] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [SubTrxnType] end,     [TranNo] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TranNo] end,     [TranId] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [TranId] end,     [Amount] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Amount] end,     [Units] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Units] end,     [Rate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Rate] end,     [NAVDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [NAVDate] end,     [RevTag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RevTag] end,     [ReferenceNo] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ReferenceNo] end,     [BranchId] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [BranchId] end,     [AgentCode] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [AgentCode] end,     [BrokerId] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [BrokerId] end,     [InvestorType] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InvestorType] end,     [SwitchScheme] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SwitchScheme] end,     [SwitchFolio] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [SwitchFolio] end,     [SwitchTranCode] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SwitchTranCode] end,     [RMCode] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RMCode] end,     [STT] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [STT] end,     [CommPer] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CommPer] end,     [TranCharge] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [TranCharge] end,     [OnLineFlag] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [OnLineFlag] end,     [Location] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Location] end,     [CreatedBy] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CreatedBy] end,     [CreationDate] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CreationDate] end,     [ClientSource] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [ClientSource] end,     [ClientCode] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [ClientCode] end
	where [TranCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TranCode] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ABRILAAWMutualFundTransactionDetail]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end   else
begin   update [dbo].[ABRILAAWMutualFundTransactionDetail] set     [RegistrarID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [RegistrarID] end,     [TranDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TranDate] end,     [InvestorCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InvestorCode] end,     [SchCode] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SchCode] end,     [AppNo] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AppNo] end,     [FolioNo] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [FolioNo] end,     [TrxnType] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [TrxnType] end,     [SWFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SWFlag] end,     [SubTrxnType] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [SubTrxnType] end,     [TranNo] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TranNo] end,     [TranId] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [TranId] end,     [Amount] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Amount] end,     [Units] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Units] end,     [Rate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Rate] end,     [NAVDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [NAVDate] end,     [RevTag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RevTag] end,     [ReferenceNo] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ReferenceNo] end,     [BranchId] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [BranchId] end,     [AgentCode] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [AgentCode] end,     [BrokerId] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [BrokerId] end,     [InvestorType] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InvestorType] end,     [SwitchScheme] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SwitchScheme] end,     [SwitchFolio] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [SwitchFolio] end,     [SwitchTranCode] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SwitchTranCode] end,     [RMCode] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RMCode] end,     [STT] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [STT] end,     [CommPer] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CommPer] end,     [TranCharge] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [TranCharge] end,     [OnLineFlag] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [OnLineFlag] end,     [Location] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Location] end,     [CreatedBy] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CreatedBy] end,     [CreationDate] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CreationDate] end,     [ClientSource] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [ClientSource] end,     [ClientCode] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [ClientCode] end
	where [TranCode] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[TranCode] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ABRILAAWMutualFundTransactionDetail]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end  end   --

GO

-- --------------------------------------------------
-- TABLE dbo.ABRILAAWMutualFundTransactionDetail
-- --------------------------------------------------
CREATE TABLE [dbo].[ABRILAAWMutualFundTransactionDetail]
(
    [TranCode] VARCHAR(20) NOT NULL,
    [RegistrarID] INT NULL,
    [TranDate] DATETIME NULL,
    [InvestorCode] VARCHAR(80) NULL,
    [SchCode] VARCHAR(50) NULL,
    [AppNo] VARCHAR(50) NULL,
    [FolioNo] VARCHAR(50) NULL,
    [TrxnType] VARCHAR(20) NULL,
    [SWFlag] VARCHAR(50) NULL,
    [SubTrxnType] VARCHAR(20) NULL,
    [TranNo] VARCHAR(50) NULL,
    [TranId] VARCHAR(50) NULL,
    [Amount] DECIMAL(38, 2) NULL,
    [Units] DECIMAL(38, 4) NULL,
    [Rate] DECIMAL(38, 4) NULL,
    [NAVDate] DATETIME NULL,
    [RevTag] CHAR(1) NULL,
    [ReferenceNo] VARCHAR(50) NULL,
    [BranchId] VARCHAR(50) NULL,
    [AgentCode] VARCHAR(50) NULL,
    [BrokerId] VARCHAR(50) NULL,
    [InvestorType] VARCHAR(2) NULL,
    [SwitchScheme] VARCHAR(10) NULL,
    [SwitchFolio] VARCHAR(50) NULL,
    [SwitchTranCode] VARCHAR(25) NULL,
    [RMCode] VARCHAR(50) NULL,
    [STT] NUMERIC(17, 2) NULL DEFAULT ((0)),
    [CommPer] NUMERIC(10, 4) NULL,
    [TranCharge] NUMERIC(10, 2) NULL,
    [OnLineFlag] CHAR(1) NULL,
    [Location] VARCHAR(50) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [CreationDate] DATETIME NULL DEFAULT (getdate()),
    [ClientSource] VARCHAR(50) NULL DEFAULT '',
    [ClientCode] VARCHAR(50) NULL DEFAULT ''
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_BSEEQ
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_BSEEQ]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_BSEEQ_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_BSEEQ_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_BSEFAO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_BSEFAO]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_BSEFAO_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_BSEFAO_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_MCX]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_MCX_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_MCX_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NCDEX
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NCDEX]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NCDEX_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NCDEX_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSECDS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSECDS]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSECDS_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSECDS_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSEEQ
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSEEQ]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSEEQ_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSEEQ_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSEFAO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSEFAO]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketTickInfo_NSEFAO_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketTickInfo_NSEFAO_Prev]
(
    [nMarketSegmentId] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nLastUpdateTime] INT NULL,
    [nLastTradedPrice] INT NULL,
    [nLastTradedQuantity] INT NULL,
    [nAvgTradedPrice] INT NULL,
    [nTotalQuantityTraded] INT NULL,
    [nBestFiveBuyQuantity1] INT NULL,
    [nBestFiveBuyPrice1] INT NULL,
    [nBestFiveBuyQuantity2] INT NULL,
    [nBestFiveBuyPrice2] INT NULL,
    [nBestFiveBuyQuantity3] INT NULL,
    [nBestFiveBuyPrice3] INT NULL,
    [nBestFiveBuyQuantity4] INT NULL,
    [nBestFiveBuyPrice4] INT NULL,
    [nBestFiveBuyQuantity5] INT NULL,
    [nBestFiveBuyPrice5] INT NULL,
    [nBestFiveSellQuantity1] INT NULL,
    [nBestFiveSellPrice1] INT NULL,
    [nBestFiveSellQuantity2] INT NULL,
    [nBestFiveSellPrice2] INT NULL,
    [nBestFiveSellQuantity3] INT NULL,
    [nBestFiveSellPrice3] INT NULL,
    [nBestFiveSellQuantity4] INT NULL,
    [nBestFiveSellPrice4] INT NULL,
    [nBestFiveSellQuantity5] INT NULL,
    [nBestFiveSellPrice5] INT NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [pDPR] VARCHAR(255) NOT NULL,
    [nPercentageChange] INT NULL,
    [nTotalBuyQuantity] INT NULL,
    [nTotalSellQuantity] INT NULL,
    [nLifeTimeHigh] INT NULL,
    [nLifeTimeLow] INT NULL,
    [pBuyQtyIndicator] VARCHAR(1) NOT NULL,
    [pBuyPriceIndicator] VARCHAR(1) NOT NULL,
    [pSellQtyIndicator] VARCHAR(1) NOT NULL,
    [pSellPriceIndicator] VARCHAR(1) NOT NULL,
    [pLTPIndicator] VARCHAR(1) NOT NULL,
    [nId] INT NOT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nOpenInterest] INT NULL,
    [pTer] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_BSEEQ
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_BSEEQ]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_BSEEQ_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_BSEEQ_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_MCX]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_MCX_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_MCX_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NCDEX
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NCDEX]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NCDEX_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NCDEX_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSECDS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSECDS]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSECDS_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSECDS_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSEEQ
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEEQ]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSEEQ_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEEQ_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSEFAO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEFAO]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PeriodicMarketTickInfo_NSEFAO_Prev
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PeriodicMarketTickInfo_NSEFAO_Prev]
(
    [nInterVal] INT NULL,
    [nSystemTime] INT NULL,
    [nLastTradedTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NULL,
    [nOpen] INT NULL,
    [nHigh] INT NULL,
    [nLow] INT NULL,
    [nClose] INT NULL,
    [nTotalQtyTraded] INT NULL,
    [nLastQtyTraded] INT NULL,
    [nTotalValueTraded] FLOAT NULL,
    [nActualValueTraded] FLOAT NULL,
    [nATP] INT NOT NULL
);

GO

