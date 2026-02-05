-- DDL Export
-- Server: 10.253.78.163
-- Database: ODINNSE
-- Exported: 2026-02-05T12:30:01.369610

USE ODINNSE;
GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DailyExposures
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_Daily_Exposures] ON [dbo].[tbl_DailyExposures] ([sClientID], [sGroupCode], [sSubClientId], [nToken], [nPeriodicity])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DailyPendingOrders
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_DailyPendingOrders1] ON [dbo].[tbl_DailyPendingOrders] ([sAccountCode], [nTransactionStatus])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_DailyTrades] ON [dbo].[tbl_DailyTrades] ([sAccountCode])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_DailyTrades1] ON [dbo].[tbl_DailyTrades] ([nTradeNumber], [nTradedOrderNumber])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_DailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_DailyTrades2] ON [dbo].[tbl_DailyTrades] ([nMessageCode], [nTradedTime], [nTradedOrderNumber], [nTradeNumber])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_HistoricEOD
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_HistoricEOD] ON [dbo].[tbl_HistoricEOD] ([nToken], [nDate], [nMarketSegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_IndexTickInfo
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_IndexTickInfo] ON [dbo].[tbl_IndexTickInfo] ([nSystemTime], [nToken], [nMarketSegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_IntegratedDailyPendingOrders
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_IntegratedDailyPendingOrders1] ON [dbo].[tbl_IntegratedDailyPendingOrders] ([sAccountCode])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_IntegratedDailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_IntegratedDailyTrades] ON [dbo].[tbl_IntegratedDailyTrades] ([sAccountCode])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_IntegratedDailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_IntegratedDailyTrades1] ON [dbo].[tbl_IntegratedDailyTrades] ([nTradeNumber], [nTradedOrderNumber])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_IntegratedDailyTrades
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_IntegratedDailyTrades2] ON [dbo].[tbl_IntegratedDailyTrades] ([nMessageCode], [nTradedTime], [nTradedOrderNumber], [nTradeNumber])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketMovementInfo1
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_MarketMovementInfo1] ON [dbo].[tbl_MarketMovementInfo1] ([nSystemTime], [nToken], [nMarketSegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_MarketStatistics
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_MarketStatistics] ON [dbo].[tbl_MarketStatistics] ([sSymbol], [sSeries], [nMarketType], [nMarketSegmentId], [nExpiryDate], [sIntstrumentName], [nStrikePrice], [sOptionType])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_ScripMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_ScripMaster] ON [dbo].[tbl_ScripMaster] ([sInstrumentName], [sSymbol], [sSeries], [sOptionType], [nAssetToken], [nStrikePrice], [nExpiryDate], [nMarketSegmentId])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_ScripMaster
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_ScripMaster1] ON [dbo].[tbl_ScripMaster] ([nToken])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_SPANContractDetails
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_SPANContractDetails] ON [dbo].[tbl_SPANContractDetails] ([nToken])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_AlertParametersInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_AlertParametersInfo] ADD CONSTRAINT [PK_tbl_AlertParametersInfo] PRIMARY KEY ([nMarketSegmentId], [sDealerCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BackofficeExecutedOrders
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BackofficeExecutedOrders] ADD CONSTRAINT [pk_tbl_BackExecOrders] PRIMARY KEY ([nOrderNumber], [nTradeNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_BackOfficeSurvLimits
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_BackOfficeSurvLimits] ADD CONSTRAINT [pk_tbl_BOSurvLimit_Dlr] PRIMARY KEY ([nEntryID])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ClientExposures
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ClientExposures] ADD CONSTRAINT [pk_tbl_ClientExpo] PRIMARY KEY ([sDealerId], [sClientId], [nToken], [sDealerGroupId], [sClientGroupId], [sSubBrokerClientId], [sGrossingClientId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailyExposures
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailyExposures] ADD CONSTRAINT [pk_tbl_DailyExpo] PRIMARY KEY ([sDealerCode], [sClientID], [sGroupCode], [sSubClientId], [nToken], [nPeriodicity])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailyOrderResponses
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailyOrderResponses] ADD CONSTRAINT [pk_tbl_dORsp] PRIMARY KEY ([nMessageCode], [nOrderTime], [sAccountCode], [nTimeStamp])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailyPendingOrders
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailyPendingOrders] ADD CONSTRAINT [pk_tbl_dOPnd_sAccountCode] PRIMARY KEY ([sAccountCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailySLOrderTriggers
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailySLOrderTriggers] ADD CONSTRAINT [pk_tbl_SLOT_OrdNo] PRIMARY KEY ([nOrderNumber], [nTriggerTime])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailySpreadOrderResponses
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailySpreadOrderResponses] ADD CONSTRAINT [PK_tbl_DailySpreadOrderResponses] PRIMARY KEY ([nMessageCode], [cBuyAccountcode], [cSellAccountcode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DailyTrades
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DailyTrades] ADD CONSTRAINT [PK_tbl_DailyTrades] PRIMARY KEY ([nMessageCode], [nTradedTime], [nTradedOrderNumber], [nTradeNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DealerMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DealerMaster] ADD CONSTRAINT [pk_tbl_DMst_DealerCode] PRIMARY KEY ([sDealerCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DealerToClientMapping
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DealerToClientMapping] ADD CONSTRAINT [pk_tbl_DlrToClntMap] PRIMARY KEY ([sDealerCode], [sClientCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DefaultScripBasket
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DefaultScripBasket] ADD CONSTRAINT [pk_tbl_Def_SBkt_DlrToken] PRIMARY KEY ([nToken])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DefaultUserPrivileges
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DefaultUserPrivileges] ADD CONSTRAINT [PK_tbl_DefaultUserPrivileges] PRIMARY KEY ([sDealerCode], [nExchangeCode], [nMarketCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_DepositInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_DepositInfo] ADD CONSTRAINT [pk_tbl_Deposit] PRIMARY KEY ([sDealerCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntegratedDailyPendingOrders
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntegratedDailyPendingOrders] ADD CONSTRAINT [pk_tbl_IntdOPnd_sAccountCode] PRIMARY KEY ([sAccountCode], [nMessageCode], [nBuyOrSell])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_IntegratedDailyTrades
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_IntegratedDailyTrades] ADD CONSTRAINT [PK_tbl_IntegratedDailyTrades] PRIMARY KEY ([nMessageCode], [nTradedTime], [nTradedOrderNumber], [nTradeNumber])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ManualExplClientExposures
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ManualExplClientExposures] ADD CONSTRAINT [PK_tbl_ManualExplClientExposures] PRIMARY KEY ([sDealerId], [sDealerCode], [sGroupId], [sGroupCode], [sClientId], [sClientCode], [sClientGroupId], [sClientGroupCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_MarginMultipliers
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_MarginMultipliers] ADD CONSTRAINT [pk_MarginMultipliers] PRIMARY KEY ([sDealerCode], [nPeriodicity])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_Masking
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_Masking] ADD CONSTRAINT [PK__tbl_Masking__06A2E7C5] PRIMARY KEY ([nMarketSegmentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ODINConfig
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ODINConfig] ADD CONSTRAINT [pk_tbl_ODINConfig] PRIMARY KEY ([nSystemCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ParticipantMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ParticipantMaster] ADD CONSTRAINT [pk_ParticipantMasterConstraint] PRIMARY KEY ([sParticipantCode], [nMarketSegmentId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ScripBasket
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ScripBasket] ADD CONSTRAINT [pk_tbl_SBkt_DlrToken] PRIMARY KEY ([sDealerCode], [nToken])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ScripMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ScripMaster] ADD CONSTRAINT [pk_ScripMasterConstraint] PRIMARY KEY ([nToken])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_ScripToISINCODE
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_ScripToISINCODE] ADD CONSTRAINT [pk_tbl_ScripToISINCODE] PRIMARY KEY ([sSymbol], [sSeries])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SettlementMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SettlementMaster] ADD CONSTRAINT [pk_tbl_SettlementMaster] PRIMARY KEY ([nSettType], [nSettNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_SurveillanceMaster
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_SurveillanceMaster] ADD CONSTRAINT [PK_tbl_SurveillanceMaster] PRIMARY KEY ([sDealerCode], [nToken], [nPeriodicity])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_TouchlineInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_TouchlineInfo] ADD CONSTRAINT [pk_tbl_TouchlineInfo] PRIMARY KEY ([sSymbol], [sSeries])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_UserPrivileges
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_UserPrivileges] ADD CONSTRAINT [PK_tbl_UserPrivileges] PRIMARY KEY ([sDealerCode], [nExchangeCode], [nMarketCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_WebDailyLoginLogoff
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_WebDailyLoginLogoff] ADD CONSTRAINT [pk_WebDailyLoginLogoff] PRIMARY KEY ([sDealerCode])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.tbl_WebMbpMboInfo
-- --------------------------------------------------
ALTER TABLE [dbo].[tbl_WebMbpMboInfo] ADD CONSTRAINT [pk_tbl_WebMbpMboInfo] PRIMARY KEY ([sSymbol], [sSeries], [nRecNo])

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
-- PROCEDURE dbo.select_dealer_master
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.select_dealer_master    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.select_dealer_master    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.select_dealer_master    Script Date: 23/10/01 9:42:11 AM ******/
create proc select_dealer_master @@sDealerCode char(6) output
as 
begin
--declare @sDealerCode as char(6)
select @@sDealerCode = sDealerCode from tbl_DealerMaster
print @@sDealerCode
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_AddUpdateAlertValues
-- --------------------------------------------------
create procedure stp_AddUpdateAlertValues
(
				@sGroupCode as varchar(5),
	                            	@nGrossExposureLimit1 	 int, @nNetExposureLimit1 		int,@nNetSaleExposureLimit1 	int,
			    	@nNetPositionLimit1 	 int, @nTurnoverLimit1 		int,@nPendingOrdersLimit1 	int,
			    	@nMarginLimit1 		 int, @nMTMLossLimit1 		int,@nGrossExposureLimit2 	int,
                            		@nNetExposureLimit2 	 int, @nNetSaleExposureLimit2 	int,@nNetPositionLimit2 	int, 
			    	@nTurnoverLimit2 	 int,	@nPendingOrdersLimit2 		int,@nMarginLimit2 		int, 
			    	@nMTMLossLimit2 	 int, @nGrossExposureLimit3 		int,@nNetExposureLimit3 	int,
			    	@nNetSaleExposureLimit3 int, @nNetPositionLimit3 		int,@nTurnoverLimit3 	int,
			    	@nPendingOrdersLimit3 	 int, @nMarginLimit3 			int,@nMTMLossLimit3 	int,
				@nPeriodicity int
)
as
begin
   if not exists(select *from tbl_AlertsInfo where sGroupCode = @sGroupCode and nPeriodicity = @nPeriodicity)
   begin
      insert into tbl_AlertsInfo 
	(
	 sGroupCode			, nPeriodicity			,
	 nGrossExposureLimit1		, nGrossExposureLimit2		, nGrossExposureLimit3		,
	 nNetExposureLimit1 		, nNetExposureLimit2		, nNetExposureLimit3		,
	 nNetSaleExposureLimit1		, nNetSaleExposureLimit2		, nNetSaleExposureLimit3		,
	 nNetPositionLimit1		, nNetPositionLimit2		, nNetPositionLimit3		,
         	 nTurnoverLimit1			, nTurnoverLimit2		, nTurnoverLimit3		,
	 nPendingOrdersLimit1		, nPendingOrdersLimit2		, nPendingOrdersLimit3		,	 
	 nMarginLimit1			, nMarginLimit2			, nMarginLimit3			,	 
	 nMTMLossLimit1			, nMTMLossLimit2		, nMTMLossLimit3
	)
      values 
	(
	 @sGroupCode			, @nPeriodicity			,
	 @nGrossExposureLimit1		, @nGrossExposureLimit2		, @nGrossExposureLimit3		,
	 @nNetExposureLimit1 		, @nNetExposureLimit2		, @nNetExposureLimit3		,
	 @nNetSaleExposureLimit1	, @nNetSaleExposureLimit2	, @nNetSaleExposureLimit3	,
	 @nNetPositionLimit1		, @nNetPositionLimit2		, @nNetPositionLimit3		,
            @nTurnoverLimit1		, @nTurnoverLimit2		, @nTurnoverLimit3		,
            @nPendingOrdersLimit1		, @nPendingOrdersLimit2		, @nPendingOrdersLimit3		, 
	 @nMarginLimit1			, @nMarginLimit2		, @nMarginLimit3		, 
	 @nMTMLossLimit1		, @nMTMLossLimit2		, @nMTMLossLimit3
	)

   end --end of insert statement
   else 
   begin
			      	update tbl_AlertsInfo 
				set
				nGrossExposureLimit1 	= @nGrossExposureLimit1, 
				nGrossExposureLimit2 	= @nGrossExposureLimit2, 
				nGrossExposureLimit3 	= @nGrossExposureLimit3,
			    	nNetExposureLimit1 	= @nNetExposureLimit1, 
				nNetExposureLimit2 	= @nNetExposureLimit2, 
				nNetExposureLimit3 	= @nNetExposureLimit3,
			    	nNetSaleExposureLimit1	= @nNetSaleExposureLimit1, 
				nNetSaleExposureLimit2	= @nNetSaleExposureLimit2, 
				nNetSaleExposureLimit3	= @nNetSaleExposureLimit3,
				nNetPositionLimit1	= @nNetPositionLimit1, 
				nNetPositionLimit2	= @nNetPositionLimit2, 
				nNetPositionLimit3	= @nNetPositionLimit3,
                            		nTurnoverLimit1		= @nTurnoverLimit1, 
				nTurnoverLimit2		= @nTurnoverLimit2, 
				nTurnoverLimit3		= @nTurnoverLimit3,
                            		nPendingOrdersLimit1	= @nPendingOrdersLimit1, 
				nPendingOrdersLimit2	= @nPendingOrdersLimit2, 
				nPendingOrdersLimit3	= @nPendingOrdersLimit3, 
				nMarginLimit1		= @nMarginLimit1, 
				nMarginLimit2		= @nMarginLimit2, 
			    	nMarginLimit3		= @nMarginLimit3, 
				nMTMLossLimit1		= @nMTMLossLimit1, 
				nMTMLossLimit2		= @nMTMLossLimit2, 
				nMTMLossLimit3		= @nMTMLossLimit3
				where 
				sGroupCode = @sGroupCode 
				and 
				nPeriodicity = @nPeriodicity
   end -- end of Update statement
end -- end of STP

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_AddUpdateDealerMap
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_AddUpdateDealerMap    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_AddUpdateDealerMap    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_AddUpdateDealerMap    Script Date: 23/10/01 9:42:11 AM ******/

/****** Object:  Stored Procedure dbo.stp_AddUpdateDealerMap    Script Date: 10/20/2001 11:29:45 AM ******/
CREATE PROC stp_AddUpdateDealerMap 
(
@nMessageCode int,
@sDealerCode char(5),
@sClientCode char(5),
@nLastUpdateTime int,
@ClientStatus char 
)
AS
BEGIN
	BEGIN TRANSACTION
	if(EXISTS(select * from tbl_DealerToClientMapping where sDealerCode = @sDealerCode and sClientCode = @sClientCode))
	BEGIN
		update tbl_DealerToClientMapping set
		nLastUpdateTime	= @nLastUpdateTime,cStatus = @ClientStatus where 
		sDealerCode = @sDealerCode AND sClientCode = @sClientCode
	END
	ELSE
	BEGIN
		insert into tbl_DealerToClientMapping values
		(@sDealerCode,@sClientCode,@nLastUpdateTime,@ClientStatus)
	END
	if (@@Error <> 0)
	BEGIN
		ROLLBACK TRANSACTION	
		return @@Error
	END
	COMMIT TRANSACTION
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_AppendMarketMovement
-- --------------------------------------------------

create proc stp_AppendMarketMovement
 ( 
   @sSymbol                    dt_Symbol,
   @sSeries                    dt_Series,
   @nSystemTime                datetime,
   @nTotalQtyTraded            dt_Quantity,
   @nTotalValueTraded          dt_Position,
   @nOpenPrice                 dt_Price,
   @nClosePrice                dt_Price,
   @nHighPrice                 dt_Price,
   @nLowPrice                  dt_Price,
   @nScripCode                 dt_Token,
   @sInstrumentName            char(6),
   @nExpiryDate                dt_Time, 
   @nStrikePrice               int, 
   @sOptionType                char(2),
   @nCALevel                   smallint, 
   @nMarketSegmentId           smallint 
 ) as
begin

  insert tbl_MarketMovementInfo 
  (sSymbol,sSeries,nSystemTime,nTotalQtyTraded,nTotalValueTraded,nOpenPrice,nClosePrice,nHighPrice,nLowPrice,nTokenNumber, sInstrumentName, nExpiryDate, 
   nStrikePrice, sOptionType, nCALevel, nMarketSegmentId)
  values
  (@sSymbol,@sSeries,@nSystemTime,@nTotalQtyTraded,@nTotalValueTraded,@nOpenPrice,@nClosePrice,@nHighPrice,@nLowPrice, 
   @nScripCode, @sInstrumentName, @nExpiryDate, @nStrikePrice, @sOptionType, @nCALevel, @nMarketSegmentId)
    

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_BuildPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_CheckAndUpdateExposure
-- --------------------------------------------------
CREATE PROCEDURE stp_CheckAndUpdateExposure
 ( @sDealerCode   dt_DealerCode,   
   @nExchangeCode smallint,                                                                                                                                                                                                                               
   @nToken        dt_Token,                                                                                                                                                                                                                                   
   @nPeriodicity  smallint,                                                                                                                                                                                                                                   
   @nBuyQty       dt_Quantity,                                                                                                                                                                                                                                
   @nBuyValue     dt_Position,                                                                                                                                                                                                                                
   @nSellQty      dt_Quantity,                                                                                                                                                                                                                                
   @nSellValue    dt_Position,                                                                                                                                                                                                                                
   @nTradedBuyQty dt_Quantity,                                                                                                                                                                                                                                
   @nTradedBuyValue dt_Position,                                                                                                                                                                                                                              
   @nTradedSellQty dt_Quantity,                                                                                                                                                                                                                               
   @nTradedSellValue dt_Position,
   @nAssetToken	int,
   @nExpiryDate dt_Time	,
   @sClientID	varchar(16),
   @nStrikePrice int
) 
as                                                                                                                                                                                                                          
Begin
   Update tbl_DailyExposures                                                                                                                                                                                                                                  
   Set   nBuyQuantity        = @nBuyQty,                               
	 nBuyValue           = @nBuyValue,                                                                                                                                                                                                                     
	 nSellQuantity       = @nSellQty,                                                                                                                                                                                                                      
	 nSellValue          = @nSellValue,                                                                                                                                                                                                                    
	 nTradedBuyQuantity  = @nTradedBuyQty,                                                                                                                                                                                                                       
	 nTradedBuyValue     = @nTradedBuyValue,                                                                                                                                                                                                               
	 nTradedSellQuantity = @nTradedSellQty,                                                                                                                                                                                                                
	 nTradedSellValue    = @nTradedSellValue,
	 nStrikePrice        = @nStrikePrice                                                                                                                                                                                                       
   Where sDealerCode = @sDealerCode 
   And   nToken = @nToken
   And   nPeriodicity = @nPeriodicity
   And   sClientID  = @sClientID
   And   nAssetToken = @nAssetToken
   
																															      
   If @@rowcount = 0
   Begin
      Insert tbl_DailyExposures( sDealerCode, nExchangeCode, nToken, nPeriodicity,                                                                                                                                                                            
				 nBuyQuantity, nBuyValue,                              
				 nSellQuantity, nSellValue,
				 nTradedBuyQuantity, nTradedBuyValue,
				 nTradedSellQuantity, nTradedSellValue,nStrikePrice ,nAssetToken,nExpiryDate,sClientID)
      Values ( @sDealerCode, @nExchangeCode, @nToken, @nPeriodicity,
	       @nBuyQty       , @nBuyValue,
	       @nSellQty      , @nSellValue,
	       @nTradedBuyQty , @nTradedBuyValue,
	       @nTradedSellQty, @nTradedSellValue,@nStrikePrice ,@nAssetToken,@nExpiryDate,@sClientID)
   End
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_CheckAndUpdateLatestBhavCopy
-- --------------------------------------------------


/****** Object:  Stored Procedure dbo.stp_CheckAndUpdateLatestBhavCopy   Script Date: 25/06/01 10:10:15 AM ******/
CREATE proc stp_CheckAndUpdateLatestBhavCopy
as
Begin
   update tbl_LatestBhavCopy
   set
	nToken            = B.nToken,
	nMarketType       = A.nMarketType,
	nLastTradedPrice  = A.nClosingPrice,
   nLastUpdateTime   = A.nLastUpdateTime
   From tbl_MarketStatistics A , tbl_ScripMaster B, tbl_LatestBhavCopy C
   where  A.sSymbol           = B.sSymbol 
      And ((A.sSeries = B.sSeries and A.nMarketSegmentId = 13) Or A.nMarketSegmentId = 12)
      and A.nMarketType       = 1 
      and A.nMarketSegmentId  = B.nMarketSegmentId
      and A.nExpiryDate       = B.nExpiryDate
      and A.sIntstrumentName  = B.sInstrumentName
      and A.nStrikePrice      = B.nStrikePrice
      and A.sOptionType       = B.sOptionType
   	and C.nToken            = B.nToken
      
   Create table #tmpToken
     (nToken    smallint NULL )
   
   insert #tmpToken select nToken from tbl_LatestBhavCopy
   
     insert tbl_LatestBhavCopy
     (
   	nToken,
	   nMarketType,
	   nLastTradedPrice,
      nLastUpdateTime
     ) 
     select
	  B.nToken,
	  A.nMarketType,
	  A.nClosingPrice,
     A.nLastUpdateTime
     From tbl_MarketStatistics A , tbl_ScripMaster B
   where  A.sSymbol           = B.sSymbol 
      And ((A.sSeries = B.sSeries and A.nMarketSegmentId = 13) Or A.nMarketSegmentId = 12)
      and A.nMarketType       = 1 
      and A.nMarketSegmentId  = B.nMarketSegmentId
      and A.nExpiryDate       = B.nExpiryDate
      and A.sIntstrumentName  = B.sInstrumentName
      and A.nStrikePrice      = B.nStrikePrice
      and A.sOptionType       = B.sOptionType
   	and B.nToken not in (select nToken from #tmpToken)

      exec stp_GetLatestClosePriceByToken  -11, 13 
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_CheckAndUpdateMarketStats
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_CheckAndUpdateMarketStats    Script Date: 25/06/01 10:10:15 AM ******/
CREATE proc stp_CheckAndUpdateMarketStats
 ( 
   @sSymbol                    dt_Symbol,
   @sSeries                    dt_Series,
   @nMarketType                smallint,
   @nOpenPrice                 dt_Price,
   @nHighPrice                 dt_Price,
   @nLowPrice                  dt_Price,
   @nClosingPrice              dt_Price,
   @nTotalQtyTraded            dt_Quantity,
   @nTotalValueTraded          float,
   @nPreviousClosePrice        dt_Price,
   @nFiftyTwoWeekHigh          dt_Price,
   @nFiftyTwoWeekLow           dt_Price,
   @sCorporateActionIndicator  char(4),
   @nOpenInterest              	dt_Price,
   @nChangeOpenInterest        	dt_Price,
   @sIntstrumentName		char(6),
   @nExpiryDate			dt_Time,
   @nStrikePrice			int,
   @sOptionType			char(2),
   @nCALevel			smallint,
   @nMarketSegmentId		smallint

 ) as
begin

   update tbl_MarketStatistics 
   set nOpenPrice = @nOpenPrice, 
       nHighPrice = @nHighPrice, 
       nLowPrice = @nLowPrice, 
       nClosingPrice = @nClosingPrice, 
       nTotalQtyTraded = @nTotalQtyTraded, 
       nTotalValueTraded = @nTotalValueTraded, 
       nPreviousClosePrice = @nPreviousClosePrice, 
       nFiftyTwoWeekHigh = @nFiftyTwoWeekHigh, 
       nFiftyTwoWeekLow = @nFiftyTwoWeekLow, 
       sCorporateActionIndicator = @sCorporateActionIndicator, 
       nOpenInterest = @nOpenInterest,
       nChangeInOpenInterest =  @nChangeOpenInterest,
       sIntstrumentName = @sIntstrumentName,
       nStrikePrice = @nStrikePrice,
       sOptionType = @sOptionType,
       nCALevel = @nCALevel,
       nLastUpdateTime = GetDate() 
    where sSymbol = @sSymbol 
      and sSeries = @sSeries 
      and nMarketType = @nMarketType 
      and nMarketSegmentId = @nMarketSegmentId
      and nExpiryDate = @nExpiryDate
      and sIntstrumentName = @sIntstrumentName
      and nStrikePrice = @nStrikePrice
      and sOptionType = @sOptionType


    if @@rowcount = 0
     begin
       insert tbl_MarketStatistics
        (sSymbol, sSeries, nMarketType,
         nOpenPrice, nHighPrice, nLowPrice,
         nClosingPrice, nTotalQtyTraded, nTotalValueTraded,
         nPreviousClosePrice, nFiftyTwoWeekHigh, nFiftyTwoWeekLow, 
         sCorporateActionIndicator,
         nOpenInterest,nChangeInOpenInterest,
         sIntstrumentName,nStrikePrice,
         sOptionType,nCALevel,nMarketSegmentId,
         nExpiryDate, nLastUpdateTime)

	values
        (@sSymbol, @sSeries, @nMarketType,
         @nOpenPrice, @nHighPrice, @nLowPrice,
         @nClosingPrice, @nTotalQtyTraded, @nTotalValueTraded,
         @nPreviousClosePrice, @nFiftyTwoWeekHigh, @nFiftyTwoWeekLow, 
         @sCorporateActionIndicator,
         @nOpenInterest, @nChangeOpenInterest,
         @sIntstrumentName, @nStrikePrice,
         @sOptionType, @nCALevel,
         @nMarketSegmentId, @nExpiryDate, GetDate())
     end

 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_CleanupBOSurvLimitsTable
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_ComputeSettlementPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_ComputeSPANPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyExplRequest
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyExplRequest    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplRequest    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplRequest    Script Date: 23/10/01 9:42:11 AM ******/
create procedure stp_DailyExplRequest
(
@cConfirmed		char,
@nTransactionStatus	smallint,
@sDealerCode		char,
@nMessageCode		smallint,
@nTimeStamp		dt_Time,
@nErrorCode		smallint,
@sAlphaChar		char,
@sTimeStamp1		char,
@nMessageLength		smallint,
@nTokenNumber		smallint,
@sInstrumentName	char,
@sSymbol		char,
@nExpiryDate		dt_Time,
@nStrikePrice		int,
@sOptionType		char,
@nCALevel		smallint,
@nExplFlag		smallint,
@nExplNumber		dt_OrderNumber,
@nMarketType		smallint,
@sAccountCode		char,
@nQuantity		dt_Quantity,
@nProOrClient		smallint,
@nExType		smallint,
@nEntryTime		dt_Time,
@nBranchID		smallint,
@nUserID		smallint,
@sBrokerID		char,
@sRemarks		char,
@sParticipantCode	char,
@nReasonCode		smallint,
@nMarketSegmentID	smallint,
@nReplyCode		smallint,
@nReplyMessageLen	smallint,
@sReplyMessage		varchar(40),
@cOrderStatus		char(1)
)
as
Begin
Begin Transaction
insert into tbl_DailyExplRequests
(
sDealerCode,	nMessageCode,	nTimeStamp,
nErrorCode,	sAlphaChar,	sTimeStamp1,
nMessageLength,	nTokenNumber,	sInstrumentName,
sSymbol,	nExpiryDate,	nStrikePrice,
sOptionType,	nCALevel,	nExplFlag,
nExplNumber,	nMarketType,	sAccountCode,
nQuantity,	nProOrClient,	nExType,
nEntryTime,	nBranchID,	nUserID,
sBrokerID,	sRemarks,	sParticipantCode,
nReasonCode,	nMarketSegmentID, cConfirmed
)
values
(
@sDealerCode,	@nMessageCode,	@nTimeStamp,
@nErrorCode,	@sAlphaChar,	@sTimeStamp1,
@nMessageLength,@nTokenNumber,	@sInstrumentName,
@sSymbol,	@nExpiryDate,	@nStrikePrice,
@sOptionType,	@nCALevel,	@nExplFlag,
@nExplNumber,	@nMarketType,	@sAccountCode,
@nQuantity,	@nProOrClient,	@nExType,
@nEntryTime,	@nBranchID,	@nUserID,
@sBrokerID,	@sRemarks,	@sParticipantCode,
@nReasonCode,	@nMarketSegmentID, @cConfirmed
)
	if @@error <> 0
		begin
			rollback Transaction
			return -1
		end
if @nMessageCode = 4000
BEGIN
insert into tbl_DailyPendingExpls
(
cConfirmed,	nTransactionStatus,	sDealerCode,
nMessageCode,	nTimeStamp,		nErrorCode,
sAlphaChar,	sTimeStamp1,		nMessageLength,
nTokenNumber,	sInstrumentName,	sSymbol,
nExpiryDate,	nStrikePrice,		sOptionType,
nCALevel,	nExplFlag,		nExplNumber,
nMarketType,	sAccountCode,		nQuantity,
nProOrClient,	nExType,		nEntryTime,
nBranchID,	nUserID,		sBrokerID,
sRemarks,	sParticipantCode,	nReasonCode,
nMarketSegmentID,	nReplyCode,	nReplyMessageLen,
sReplyMessage,	cOrderStatus		
)
values
(
@cConfirmed,	@nTransactionStatus,	@sDealerCode,
@nMessageCode,	@nTimeStamp,		@nErrorCode,
@sAlphaChar,	@sTimeStamp1,		@nMessageLength,
@nTokenNumber,	@sInstrumentName,	@sSymbol,
@nExpiryDate,	@nStrikePrice,		@sOptionType,
@nCALevel,	@nExplFlag,		@nExplNumber,
@nMarketType,	@sAccountCode,		@nQuantity,
@nProOrClient,	@nExType,		@nEntryTime,
@nBranchID,	@nUserID,		@sBrokerID,
@sRemarks,	@sParticipantCode,	@nReasonCode,
@nMarketSegmentID,	@nReplyCode,	@nReplyMessageLen,
@sReplyMessage,	@cOrderStatus		
)

	if @@error <> 0
		begin
			rollback Transaction
			return -1
		end
END
else
BEGIN
  update tbl_DailyPendingExpls SET nTransactionStatus = @nTransactionStatus
  where sAccountCode = @sAccountCode and  nTransactionStatus <> 128
END
commit Transaction
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyExplRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyExplRequests    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplRequests    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplRequests    Script Date: 23/10/01 9:42:12 AM ******/
create procedure stp_DailyExplRequests
(
@cConfirmed		char(1),	@nTransactionStatus	smallint,	@sDealerCode		char(5),
@nMessageCode		smallint,	@nTimeStamp		dt_Time,	@nErrorCode		smallint,
@sAlphaChar		char(2),	@sTimeStamp1		char(8),	@nMessageLength		smallint,
@nTokenNumber		smallint,	@sInstrumentName	char(6),	@sSymbol		char(10),
@nExpiryDate		dt_Time,	@nStrikePrice		int,		@sOptionType		char(2),
@nCALevel		smallint,	@nExplFlag		smallint,	@nExplNumber		dt_OrderNumber,
@nMarketType		smallint,	@sAccountCode		char(10),	@nQuantity		dt_Quantity,
@nProOrClient		smallint,	@nExType		smallint,	@nEntryTime		dt_Time,
@nBranchID		smallint,	@nUserID		smallint,	@sBrokerID		char(5),
@sRemarks		char(30),	@sParticipantCode	char(12),	@nReasonCode		smallint,
@nMarketSegmentID	smallint,	@nReplyCode		smallint,	@nReplyMessageLen	smallint,
@sReplyMessage		char(40),	@cOrderStatus		char(1)
)
as
Begin
declare @nOrderInfoMessageCode int
set @nOrderInfoMessageCode = 31024

Begin Transaction
	insert into tbl_DailyExplRequests
	(
	sDealerCode,	nMessageCode,	nTimeStamp,
	nErrorCode,	sAlphaChar,	sTimeStamp1,
	nMessageLength,	nTokenNumber,	sInstrumentName,
	sSymbol,	nExpiryDate,	nStrikePrice,
	sOptionType,	nCALevel,	nExplFlag,
	nExplNumber,	nMarketType,	sAccountCode,
	nQuantity,	nProOrClient,	nExType,
	nEntryTime,	nBranchID,	nUserID,
	sBrokerID,	sRemarks,	sParticipantCode,
	nReasonCode,	nMarketSegmentID, cConfirmed
	)
	values
	(
	@sDealerCode,	@nMessageCode,	@nTimeStamp,
	@nErrorCode,	@sAlphaChar,	@sTimeStamp1,
	@nMessageLength,@nTokenNumber,	@sInstrumentName,
	@sSymbol,	@nExpiryDate,	@nStrikePrice,
	@sOptionType,	@nCALevel,	@nExplFlag,
	@nExplNumber,	@nMarketType,	@sAccountCode,
	@nQuantity,	@nProOrClient,	@nExType,
	@nEntryTime,	@nBranchID,	@nUserID,
	@sBrokerID,	@sRemarks,	@sParticipantCode,
	@nReasonCode,	@nMarketSegmentID, @cConfirmed
	)
		if @@error <> 0
			begin
				rollback Transaction
				return -1
			end

if @nMessageCode = 4000 and @nErrorCode = 0
BEGIN
insert into tbl_DailyPendingExpls
(
cConfirmed,	nTransactionStatus,	sDealerCode,
nMessageCode,	nTimeStamp,		nErrorCode,
sAlphaChar,	sTimeStamp1,		nMessageLength,
nTokenNumber,	sInstrumentName,	sSymbol,
nExpiryDate,	nStrikePrice,		sOptionType,
nCALevel,	nExplFlag,		nExplNumber,
nMarketType,	sAccountCode,		nQuantity,
nProOrClient,	nExType,		nEntryTime,
nBranchID,	nUserID,		sBrokerID,
sRemarks,	sParticipantCode,	nReasonCode,
nMarketSegmentID,	nReplyCode,	nReplyMessageLen,
sReplyMessage,	cOrderStatus		
)
values
(
@cConfirmed,	@nTransactionStatus,	@sDealerCode,
@nOrderInfoMessageCode,	@nTimeStamp,		@nErrorCode,
@sAlphaChar,	@sTimeStamp1,		@nMessageLength,
@nTokenNumber,	@sInstrumentName,	@sSymbol,
@nExpiryDate,	@nStrikePrice,		@sOptionType,
@nCALevel,	@nExplFlag,		@nExplNumber,
@nMarketType,	@sAccountCode,		@nQuantity,
@nProOrClient,	@nExType,		@nEntryTime,
@nBranchID,	@nUserID,		@sBrokerID,
@sRemarks,	@sParticipantCode,	@nReasonCode,
@nMarketSegmentID,	@nReplyCode,	@nReplyMessageLen,
@sReplyMessage,	@cOrderStatus		
)

	if @@error <> 0
		begin
			--rollback Transaction
			return -1
		end
END
else
BEGIN
  update tbl_DailyPendingExpls SET nTransactionStatus = @nTransactionStatus
  where sAccountCode = @sAccountCode and  nTransactionStatus <> 128
END

commit Transaction
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyExplResponse
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyExplResponse    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplResponse    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyExplResponse    Script Date: 23/10/01 9:42:12 AM ******/
create procedure stp_DailyExplResponse
(
@cConfirmed		char(1),	@nTransactionStatus	smallint,	@sDealerCode		char(5),
@nMessageCode		smallint,	@nTimeStamp		dt_Time,	@nErrorCode		smallint,
@sAlphaChar		char(2),	@sTimeStamp1		char(8),	@nMessageLength		smallint,
@nTokenNumber		smallint,	@sInstrumentName	char(12),	@sSymbol		char(10),
@nExpiryDate		dt_Time,	@nStrikePrice		int,		@sOptionType		char(2),
@nCALevel		smallint,	@nExplFlag		smallint,	@nExplNumber		dt_OrderNumber,
@nMarketType		smallint,	@sAccountCode		char(10),	@nQuantity		dt_Quantity,
@nProOrClient		smallint,	@nExType		smallint,	@nEntryTime		dt_Time,
@nBranchID		smallint,	@nUserID		smallint,	@sBrokerID		char(5),
@sRemarks		char(30),	@sParticipantCode	char(12),	@nReasonCode		smallint,
@nMarketSegmentID	smallint,	@nReplyCode		smallint,	@nReplyMessageLen	smallint,
@sReplyMessage		char(40),	@cOrderStatus		char(1)
)
as
Begin
Begin Transaction
insert into tbl_DailyExplResponses
(
sDealerCode,	nMessageCode,	nTimeStamp,
nErrorCode,	sAlphaChar,	sTimeStamp1,
nMessageLength,	nTokenNumber,	sInstrumentName,
sSymbol,	nExpiryDate,	nStrikePrice,
sOptionType,	nCALevel,	nExplFlag,
nExplNumber,	nMarketType,	sAccountCode,
nQuantity,	nProOrClient,	nExType,
nEntryTime,	nBranchID,	nUserID,
sBrokerID,	sRemarks,	sParticipantCode,
nReasonCode,	nMarketSegmentID
)
values
(
@sDealerCode,	@nMessageCode,	@nTimeStamp,
@nErrorCode,	@sAlphaChar,	@sTimeStamp1,
@nMessageLength,@nTokenNumber,	@sInstrumentName,
@sSymbol,	@nExpiryDate,	@nStrikePrice,
@sOptionType,	@nCALevel,	@nExplFlag,
@nExplNumber,	@nMarketType,	@sAccountCode,
@nQuantity,	@nProOrClient,	@nExType,
@nEntryTime,	@nBranchID,	@nUserID,
@sBrokerID,	@sRemarks,	@sParticipantCode,
@nReasonCode,	@nMarketSegmentID
)
	if @@error <> 0
		begin
			rollback Transaction
			return -1
		end

update tbl_DailyExplRequests
set cConfirmed = @cConfirmed
where sAccountCode like @sAccountCode
and cConfirmed like 'N'


	if @@error <> 0
		begin
			rollback Transaction
			return -1
		end
		/*  Ex PL Error */
	if @nMessageCode = 4000 OR @nMessageCode = 4008 OR @nMessageCode = 4005 
	Begin
		update tbl_DailyPendingExpls
		set 	nTimeStamp 		= @nTimeStamp,
			nExplNumber 		= @nExplNumber,
			nTransactionStatus 	= @nTransactionStatus	
		where sAccountCode like @sAccountCode
		and nTimeStamp <= @nTimeStamp
		and nTransactionStatus <> 128
	End
		/*  Ex PL Confirmation  -  Mod Confirmation  - Cancel Confirmation*/
	if @nMessageCode = 4002 OR @nMessageCode = 4007 OR @nMessageCode = 4010

	Begin
		update tbl_DailyPendingExpls
		set 	sDealerCode 	=	@sDealerCode,	
			nMessageCode 	=	31024,	
			@nErrorCode	=	@nErrorCode,	
			sAlphaChar	=	@sAlphaChar,	
			sTimeStamp1	=	@sTimeStamp1,
			nMessageLength	=	@nMessageLength,
			nTokenNumber	=	@nTokenNumber,	
			sInstrumentName	=	@sInstrumentName,
			sSymbol		=	@sSymbol,		
			nExpiryDate	=	@nExpiryDate,	
			nStrikePrice	=	@nStrikePrice,
			sOptionType	=	@sOptionType,	
			nCALevel	=	@nCALevel,	
			nExplFlag	=	@nExplFlag,
			nExplNumber	=	@nExplNumber,	
			nMarketType	=	@nMarketType,	
			nQuantity	=	@nQuantity,	
			nProOrClient	=	@nProOrClient,	
			nExType		=	@nExType,
			nEntryTime	=	@nEntryTime,	
			nBranchID	=	@nBranchID,	
			nUserID		=	@nUserID,
			sBrokerID	=	@sBrokerID,	
			sRemarks	=	@sRemarks,	
			sParticipantCode=	@sParticipantCode,
			nReasonCode	=	@nReasonCode,	
			nMarketSegmentID=	@nMarketSegmentID,
			nTransactionStatus 	= @nTransactionStatus,	
			cOrderStatus		= @cOrderStatus
		where sAccountCode like @sAccountCode
		and nTimeStamp <= @nTimeStamp
		and nTransactionStatus <> 128
	End

	if @@error <> 0
		begin
			rollback Transaction
			return -1
		end


commit Transaction
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyOrderRequests    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyOrderRequests    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailyOrderRequests
(
	@cConfirmed char (1)    ,
	@sDealerCode dt_DealerCode   ,
	@nMessageCode dt_MessageCode   ,
	@nTimeStamp dt_Time   ,
	@nErrorCode dt_ErrorCode   ,
	@sAlphaChar dt_AlphaChar   ,
	@sTimeStamp1 dt_TimeStamp   ,
	@nMessageLength dt_MessageLength   ,
	@nUserID smallint   ,
	@sSymbol dt_Symbol   ,
	@sSeries dt_Series   ,
	@nSettlementDays smallint   ,
	@nOrderType smallint   ,
	@nBuyOrSell dt_BuyOrSell   ,
	@nTotalQuantity dt_Quantity   ,
	@nPrice dt_Price   ,
	@nTriggerPrice dt_Price   ,
	@nGoodTillDays dt_GoodTillDays   ,
	@nDisclosedQuantity dt_Quantity   ,
	@nMinFillQuantity dt_Quantity   ,
	@nProOrClient smallint   ,
	@sAccountCode dt_AccountCode   ,
	@sParticipantCode dt_ParticipantCode   ,
	@sCPBrokerCode dt_BrokerCode   ,
	@sRemarks dt_Remarks   ,
	@nMF dt_OrderTerms   ,
	@nAON dt_OrderTerms   ,
	@nIOC dt_OrderTerms   ,
	@nGTC dt_OrderTerms   ,
	@nDay dt_OrderTerms   ,
	@nSL dt_OrderTerms   ,
	@nMarket dt_OrderTerms   ,
	@nATO dt_OrderTerms   ,
	@nFrozen dt_OrderTerms   ,
	@nModified dt_OrderTerms   ,
	@nTraded dt_OrderTerms   ,
	@nMatchedInd dt_OrderTerms   ,
	@nOrderNumber dt_OrderNumber   ,
	@nOrderTime dt_Time   ,
	@nEntryTime dt_Time   ,
	@nAuctionNumber smallint   ,
	@cParticipantType char (1)    ,
	@nCompetitorPeriod smallint   ,
	@nSolicitorPeriod smallint   ,
	@cModCancelBy char (1)    ,
	@nReasonCode dt_ReasonCode   ,
	@cSecuritySuspendIndicator char (1)    ,
	@nDisclosedQuantityRemaining dt_Quantity   ,
	@nTotalQuantityRemaining dt_Quantity   ,
	@nQuantityTradedToday dt_Quantity   ,
	@nBranchID smallint   ,
	@sBrokerID dt_BrokerCode   ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  

)as

begin
begin transaction
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))



insert into tbl_DailyOrderRequests
(
cConfirmed,
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nUserID,
sSymbol,
sSeries,
nSettlementDays,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nTriggerPrice,
nGoodTillDays,
nDisclosedQuantity,
nMinFillQuantity,
nProOrClient,
sAccountCode,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nOrderNumber,
nOrderTime,
nEntryTime,
nAuctionNumber,
cParticipantType,
nCompetitorPeriod,
nSolicitorPeriod,
cModCancelBy,
nReasonCode,
cSecuritySuspendIndicator,
nDisclosedQuantityRemaining,
nTotalQuantityRemaining,
nQuantityTradedToday,
nBranchID,
sBrokerID,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId
--nArrivalTime
)
VALUES
(
@cConfirmed,
@sDealerCode,
@nMessageCode,
@nTimeStamp,
@nErrorCode,
@sAlphaChar,
@sTimeStamp1,
@nMessageLength,
@nUserID,
@sSymbol,
@sSeries,
@nSettlementDays,
@nOrderType,
@nBuyOrSell,
@nTotalQuantity,
@nPrice,
@nTriggerPrice,
@nGoodTillDays,
@nDisclosedQuantity,
@nMinFillQuantity,
@nProOrClient,
@sAccountCode,
@sParticipantCode,
@sCPBrokerCode,
@sRemarks,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nOrderNumber,
@nOrderTime,
@nEntryTime,
@nAuctionNumber,
@cParticipantType,
@nCompetitorPeriod,
@nSolicitorPeriod,
@cModCancelBy,
@nReasonCode,
@cSecuritySuspendIndicator,
@nDisclosedQuantityRemaining,
@nTotalQuantityRemaining,
@nQuantityTradedToday,
@nBranchID,
@sBrokerID,
@nTokenNumber,
@cOpenClose,
@cCoverUncover,
@cGiveUpFlag,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@nBookType,
@nMarketSegmentId
--@lnArrivalTime
)

if @@error <> 0
	begin
		rollback transaction
		return @@error
	end
/* Second insert*/
insert into tbl_DailyOrderResponses
(
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nUserID,
sSymbol,
sSeries,
nSettlementDays,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nTriggerPrice,
nGoodTillDays,
nDisclosedQuantity,
nMinFillQuantity,
nProOrClient,
sAccountCode,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nOrderNumber,
nOrderTime,
nEntryTime,
nAuctionNumber,
cParticipantType,
nCompetitorPeriod,
nSolicitorPeriod,
cModCancelBy,
nReasonCode,
cSecuritySuspendIndicator,
nDisclosedQuantityRemaining,
nTotalQuantityRemaining,
nQuantityTradedToday,
nBranchID,
sBrokerID,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId
)
VALUES
(
@sDealerCode,
@nMessageCode,
@nTimeStamp,
@nErrorCode,
@sAlphaChar,
@sTimeStamp1,
@nMessageLength,
@nUserID,
@sSymbol,
@sSeries,
@nSettlementDays,
@nOrderType,
@nBuyOrSell,
@nTotalQuantity,
@nPrice,
@nTriggerPrice,
@nGoodTillDays,
@nDisclosedQuantity,
@nMinFillQuantity,
@nProOrClient,
@sAccountCode,
@sParticipantCode,
@sCPBrokerCode,
@sRemarks,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nOrderNumber,
@nOrderTime,
@nEntryTime,
@nAuctionNumber,
@cParticipantType,
@nCompetitorPeriod,
@nSolicitorPeriod,
@cModCancelBy,
@nReasonCode,
@cSecuritySuspendIndicator,
@nDisclosedQuantityRemaining,
@nTotalQuantityRemaining,
@nQuantityTradedToday,
@nBranchID,
@sBrokerID,
@nTokenNumber,
@cOpenClose,
@cCoverUncover,
@cGiveUpFlag,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@nBookType,
@nMarketSegmentId
)

if @@error <> 0
	begin
		rollback transaction
		return @@error
	end


commit transaction

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyOrderResponses
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyOrderResponses    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyOrderResponses    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyOrderResponses    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailyOrderResponses
(
	@sDealerCode dt_DealerCode  ,
	@nMessageCode dt_MessageCode  ,
	@nTimeStamp dt_Time  ,
	@nErrorCode dt_ErrorCode  ,
	@sAlphaChar dt_AlphaChar  ,
	@sTimeStamp1 dt_TimeStamp  ,
	@nMessageLength dt_MessageLength  ,
	@nUserID smallint  ,
	@sSymbol dt_Symbol  ,
	@sSeries dt_Series  ,
	@nSettlementDays smallint  ,
	@nOrderType smallint  ,
	@nBuyOrSell dt_BuyOrSell  ,
	@nTotalQuantity dt_Quantity  ,
	@nPrice dt_Price  ,
	@nTriggerPrice dt_Price  ,
	@nGoodTillDays dt_GoodTillDays  ,
	@nDisclosedQuantity dt_Quantity  ,
	@nMinFillQuantity dt_Quantity  ,
	@nProOrClient smallint  ,
	@sAccountCode dt_AccountCode  ,
	@sParticipantCode dt_ParticipantCode  ,
	@sCPBrokerCode dt_BrokerCode  ,
	@sRemarks dt_Remarks  ,
	@nMF dt_OrderTerms  ,
	@nAON dt_OrderTerms  ,
	@nIOC dt_OrderTerms  ,
	@nGTC dt_OrderTerms  ,
	@nDay dt_OrderTerms  ,
	@nSL dt_OrderTerms  ,
	@nMarket dt_OrderTerms  ,
	@nATO dt_OrderTerms  ,
	@nFrozen dt_OrderTerms  ,
	@nModified dt_OrderTerms  ,
	@nTraded dt_OrderTerms  ,
	@nMatchedInd dt_OrderTerms  ,
	@nOrderNumber dt_OrderNumber  ,
	@nOrderTime dt_Time  ,
	@nEntryTime dt_Time  ,
	@nAuctionNumber smallint  ,
	@cParticipantType char (1)   ,
	@nCompetitorPeriod smallint  ,
	@nSolicitorPeriod smallint  ,
	@cModCancelBy char (1)   ,
	@nReasonCode dt_ReasonCode  ,
	@cSecuritySuspendIndicator char (1)   ,
	@nDisclosedQuantityRemaining dt_Quantity  ,
	@nTotalQuantityRemaining dt_Quantity  ,
	@nQuantityTradedToday dt_Quantity  ,
	@nBranchID smallint  ,
	@sBrokerID dt_BrokerCode  ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  

) as

begin
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

insert into tbl_DailyOrderResponses
(
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nUserID,
sSymbol,
sSeries,
nSettlementDays,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nTriggerPrice,
nGoodTillDays,
nDisclosedQuantity,
nMinFillQuantity,
nProOrClient,
sAccountCode,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nOrderNumber,
nOrderTime,
nEntryTime,
nAuctionNumber,
cParticipantType,
nCompetitorPeriod,
nSolicitorPeriod,
cModCancelBy,
nReasonCode,
cSecuritySuspendIndicator,
nDisclosedQuantityRemaining,
nTotalQuantityRemaining,
nQuantityTradedToday,
nBranchID,
sBrokerID,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId--,
--nArrivalTime
)
values
(
@sDealerCode,
@nMessageCode,
@nTimeStamp,
@nErrorCode,
@sAlphaChar,
@sTimeStamp1,
@nMessageLength,
@nUserID,
@sSymbol,
@sSeries,
@nSettlementDays,
@nOrderType,
@nBuyOrSell,
@nTotalQuantity,
@nPrice,
@nTriggerPrice,
@nGoodTillDays,
@nDisclosedQuantity,
@nMinFillQuantity,
@nProOrClient,
@sAccountCode,
@sParticipantCode,
@sCPBrokerCode,
@sRemarks,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nOrderNumber,
@nOrderTime,
@nEntryTime,
@nAuctionNumber,
@cParticipantType,
@nCompetitorPeriod,
@nSolicitorPeriod,
@cModCancelBy,
@nReasonCode,
@cSecuritySuspendIndicator,
@nDisclosedQuantityRemaining,
@nTotalQuantityRemaining,
@nQuantityTradedToday,
@nBranchID,
@sBrokerID,
@nTokenNumber,
@cOpenClose,
@cCoverUncover,
@cGiveUpFlag,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@nBookType,
@nMarketSegmentId--,
--@lnArrivalTime
)



end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyPendingOrders    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyPendingOrders    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailyPendingOrders
(
	@cOrderStatus char (1)  ,
	@sDealerCode dt_DealerCode  ,
	@nMessageCode dt_MessageCode  ,
	@nTimeStamp dt_Time  ,
	@nErrorCode dt_ErrorCode  ,
	@sAlphaChar dt_AlphaChar  ,
	@sTimeStamp1 dt_TimeStamp  ,
	@nMessageLength dt_MessageLength  ,
	@nUserID smallint  ,
	@sSymbol dt_Symbol  ,
	@sSeries dt_Series  ,
	@nSettlementDays smallint  ,
	@nOrderType smallint  ,
	@nBuyOrSell dt_BuyOrSell  ,
	@nTotalQuantity dt_Quantity  ,
	@nPrice dt_Price  ,
	@nTriggerPrice dt_Price  ,
	@nGoodTillDays dt_GoodTillDays  ,
	@nDisclosedQuantity dt_Quantity  ,
	@nMinFillQuantity dt_Quantity  ,
	@nProOrClient smallint  ,
	@sAccountCode dt_AccountCode  ,
	@sParticipantCode dt_ParticipantCode  ,
	@sCPBrokerCode dt_BrokerCode  ,
	@sRemarks dt_Remarks  ,
	@nMF dt_OrderTerms  ,
	@nAON dt_OrderTerms  ,
	@nIOC dt_OrderTerms  ,
	@nGTC dt_OrderTerms  ,
	@nDay dt_OrderTerms  ,
	@nSL dt_OrderTerms  ,
	@nMarket dt_OrderTerms  ,
	@nATO dt_OrderTerms  ,
	@nFrozen dt_OrderTerms  ,
	@nModified dt_OrderTerms  ,
	@nTraded dt_OrderTerms  ,
	@nMatchedInd dt_OrderTerms  ,
	@nOrderNumber dt_OrderNumber  ,
	@nOrderTime dt_Time  ,
	@nEntryTime dt_Time  ,
	@nAuctionNumber smallint  ,
	@cParticipantType char (1)  ,
	@nCompetitorPeriod smallint  ,
	@nSolicitorPeriod smallint  ,
	@cModCancelBy char (1)  ,
	@nReasonCode dt_ReasonCode  ,
	@cSecuritySuspendIndicator char (1)  ,
	@nDisclosedQuantityRemaining dt_Quantity  ,
	@nTotalQuantityRemaining dt_Quantity  ,
	@nQuantityTradedToday dt_Quantity  ,
	@nBranchID smallint  ,
	@sBrokerID dt_BrokerCode  ,
	@nPendingQty dt_Quantity  ,
	@nTransactionStatus smallint  ,
	@nReplyCode smallint  ,
	@nReplyMessageLen dt_MessageLength  ,
	@sReplyMessage dt_ReplyMessage  ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)  ,
	@cCoverUncover char (1)  ,
	@cGiveUpFlag char (1)  ,
	@sInstrumentName char (6)  ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)  ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  
) as


begin

  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

insert into tbl_DailyPendingOrders
(
cOrderStatus,
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nUserID,
sSymbol,
sSeries,
nSettlementDays,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nTriggerPrice,
nGoodTillDays,
nDisclosedQuantity,
nMinFillQuantity,
nProOrClient,
sAccountCode,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nOrderNumber,
nOrderTime,
nEntryTime,
nAuctionNumber,
cParticipantType,
nCompetitorPeriod,
nSolicitorPeriod,
cModCancelBy,
nReasonCode,
cSecuritySuspendIndicator,
nDisclosedQuantityRemaining,
nTotalQuantityRemaining,
nQuantityTradedToday,
nBranchID,
sBrokerID,
nPendingQty,
nTransactionStatus,
nReplyCode,
nReplyMessageLen,
sReplyMessage,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId
)
values
(
@cOrderStatus,
@sDealerCode,
@nMessageCode,
@nTimeStamp,
@nErrorCode,
@sAlphaChar,
@sTimeStamp1,
@nMessageLength,
@nUserID,
@sSymbol,
@sSeries,
@nSettlementDays,
@nOrderType,
@nBuyOrSell,
@nTotalQuantity,
@nPrice,
@nTriggerPrice,
@nGoodTillDays,
@nDisclosedQuantity,
@nMinFillQuantity,
@nProOrClient,
@sAccountCode,
@sParticipantCode,
@sCPBrokerCode,
@sRemarks,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nOrderNumber,
@nOrderTime,
@nEntryTime,
@nAuctionNumber,
@cParticipantType,
@nCompetitorPeriod,
@nSolicitorPeriod,
@cModCancelBy,
@nReasonCode,
@cSecuritySuspendIndicator,
@nDisclosedQuantityRemaining,
@nTotalQuantityRemaining,
@nQuantityTradedToday,
@nBranchID,
@sBrokerID,
@nPendingQty,
@nTransactionStatus,
@nReplyCode,
@nReplyMessageLen,
@sReplyMessage,
@nTokenNumber,
@cOpenClose,
@cCoverUncover,
@cGiveUpFlag,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@nBookType,
@nMarketSegmentId
)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailySLOrderTriggers
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailySLOrderTriggers    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySLOrderTriggers    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySLOrderTriggers    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailySLOrderTriggers
(
	@nMessageCode dt_MessageCode ,
	@nTimeStamp dt_Time ,
	@sAlphaChar dt_AlphaChar ,
	@nErrorCode dt_ErrorCode ,
	@sTimeStamp1 dt_TimeStamp ,
	@nMessageLength dt_MessageLength ,
	@sSymbol dt_Symbol ,
	@sSeries dt_Series ,
	@nQuantityTraded dt_Quantity ,
	@nQuantityRemaining dt_Quantity ,
	@nTradedPrice int ,
	@nTradeNumber dt_TradeNumber ,
	@nTriggerTime dt_Time ,
	@nBuyOrSell dt_BuyOrSell ,
	@nOrderNumber dt_OrderNumber ,
	@sBrokerID dt_BrokerCode ,
	@cEnteredBy char (1)  ,
	@nUserID smallint ,
	@sAccountCode dt_AccountCode ,
	@nOriginalQuantity dt_Quantity ,
	@nDisclosedQuantity dt_Quantity ,
	@nDisclosedQuantityRemaining dt_Quantity ,
	@nOrderPrice dt_Price ,
	@nMF dt_OrderTerms ,
	@nAON dt_OrderTerms ,
	@nIOC dt_OrderTerms ,
	@nGTC dt_OrderTerms ,
	@nDay dt_OrderTerms ,
	@nSL dt_OrderTerms ,
	@nMarket dt_OrderTerms ,
	@nATO dt_OrderTerms ,
	@nFrozen dt_OrderTerms ,
	@nModified dt_OrderTerms ,
	@nTraded dt_OrderTerms ,
	@nMatchedInd dt_OrderTerms ,
	@nGoodTillDays dt_GoodTillDays ,
	@nQuantityTradedToday dt_Quantity ,
	@sActivityType char (2)  ,
	@nCPTradedOrderNo dt_OrderNumber ,
	@sCPBrokerID dt_BrokerCode ,
	@nOrderType dt_OrderType ,
	@nNewQuantity dt_Quantity ,
	@nTokenNumber smallint ,
	@cOpenClose char (1)  ,
	@cCoverUncover char (1)  ,
	@cGiveUpFlag char (1)  ,
	@sInstrumentName char (6)  ,
	@nExpiryDate int ,
	@nStrikePrice int ,
	@sOptionType char (2)  ,
	@nCALevel smallint ,
	@cBookType char (1)  ,
	@nMarketSegmentId smallint 
)as

begin
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

insert into tbl_DailySLOrderTriggers
(
nMessageCode,
nTimeStamp,
sAlphaChar,
nErrorCode,
sTimeStamp1,
nMessageLength,
sSymbol,
sSeries,
nQuantityTraded,
nQuantityRemaining,
nTradedPrice,
nTradeNumber,
nTriggerTime,
nBuyOrSell,
nOrderNumber,
sBrokerID,
cEnteredBy,
nUserID,
sAccountCode,
nOriginalQuantity,
nDisclosedQuantity,
nDisclosedQuantityRemaining,
nOrderPrice,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nGoodTillDays,
nQuantityTradedToday,
sActivityType,
nCPTradedOrderNo,
sCPBrokerID,
nOrderType,
nNewQuantity,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
cBookType,
nMarketSegmentId

)
VALUES
(
@nMessageCode,
@nTimeStamp,
@sAlphaChar,
@nErrorCode,
@sTimeStamp1,
@nMessageLength,
@sSymbol,
@sSeries,
@nQuantityTraded,
@nQuantityRemaining,
@nTradedPrice,
@nTradeNumber,
@nTriggerTime,
@nBuyOrSell,
@nOrderNumber,
@sBrokerID,
@cEnteredBy,
@nUserID,
@sAccountCode,
@nOriginalQuantity,
@nDisclosedQuantity,
@nDisclosedQuantityRemaining,
@nOrderPrice,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nGoodTillDays,
@nQuantityTradedToday,
@sActivityType,
@nCPTradedOrderNo,
@sCPBrokerID,
@nOrderType,
@nNewQuantity,
@nTokenNumber,
@cOpenClose,
@cCoverUncover,
@cGiveUpFlag,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@cBookType,
@nMarketSegmentId
)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailySpreadOrderResponses
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailySpreadOrderResponses    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySpreadOrderResponses    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySpreadOrderResponses    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailySpreadOrderResponses
(
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
) as

begin
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nBuyTimeStamp,'01/01/1980'))

insert into tbl_DailySpreadOrderResponses
(
nMessageCode,
nMessageLength,
cBuyAlphaChar,
cSellAlphaChar,
nBuyToken,
nSellToken,
nQuantity,
nRemainingQuantity,
nBuyPrice,
nSellPrice,
cBuyAccountcode,
cSellAccountcode,
nAONIOC,
nBuyBookType,
nSellBookType,
nBuyOrderType,
nSellOrderType,
nOrder1BuySell,
nOrder2BuySell,
nBranchId,
cBuyRemarks,
cSellRemarks,
nProClient,
nOrderNumber,
cBuyInstrumentName,
cSellInstrumentName,
cBuySymbol,
cSellSymbol,
cBuySeries,
cSellSeries,
nBuyExpiryDate,
nSellExpiryDate,
nBuyCALevel,
nSellCALevel,
nBuyStrikePrice,
nSellStrikePrice,
cBuyOptionType,
cSellOptionType,
cBuyOpenClose,
cSellOpenClose,
cBuyCoverUncover,
cSellCoverUncover,
cBuyParticipant,
cSellParticipant,
nBuyEntryDateTime,
nSellEntryDateTime,
nBuyTimeStamp,
nSellTimeStamp,
nMarketSegmentId,
sDealerCode,
nBuyErrorCode,
nSellErrorCode,
nUserId
)
values
(
@nMessageCode,
@nMessageLength,
@cBuyAlphaChar,
@cSellAlphaChar,
@nBuyToken,
@nSellToken,
@nQuantity,
@nRemainingQuantity,
@nBuyPrice,
@nSellPrice,
@cBuyAccountCode,
@cSellAccountCode,
@nAONIOC,
@nBuyBookType,
@nSellBookType,
@nBuyOrderType,
@nSellOrderType,
@nOrder1BuySell,
@nOrder2BuySell,
@nBranchId,
@cBuyRemarks,
@cSellRemarks,
@nProClient,
@nOrderNumber,
@cBuyInstrumentName,
@cSellInstrumentName,
@cBuySymbol,
@cSellSymbol,
@cBuySeries,
@cSellSeries,
@nBuyExpiryDate,
@nSellExpiryDate,
@nBuyCALevel,
@nSellCALevel,
@nBuyStrikePrice,
@nSellStrikePrice,
@cBuyOptionType,
@cSellOptionType,
@cBuyOpenClose,
@cSellOpenClose,
@cBuyCoverUncover,
@cSellCoverUncover,
@cBuyParticipant,
@cSellParticipant,
@nBuyEntryDateTime,
@nSellEntryDateTime,
@nBuyTimeStamp,
@nSellTimeStamp,
@nMarketSegmentId,
@sDealerCode,
@nBuyErrorCode,
@nSellErrorCode,
@nUserId
)



end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailySpreadPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailySpreadPendingOrders    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySpreadPendingOrders    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailySpreadPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_DailySpreadPendingOrders
(
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
) as

begin
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nBuyTimeStamp,'01/01/1980'))

insert into tbl_DailySpreadPendingOrders
(
nMessageCode,
nMessageLength,
cBuyAlphaChar,
cSellAlphaChar,
nBuyToken,
nSellToken,
nQuantity,
nRemainingQuantity,
nBuyPrice,
nSellPrice,
cBuyAccountcode,
cSellAccountcode,
nAONIOC,
nBuyBookType,
nSellBookType,
nBuyOrderType,
nSellOrderType,
nOrder1BuySell,
nOrder2BuySell,
nBranchId,
cBuyRemarks,
cSellRemarks,
nProClient,
nOrderNumber,
cBuyInstrumentName,
cSellInstrumentName,
cBuySymbol,
cSellSymbol,
cBuySeries,
cSellSeries,
nBuyExpiryDate,
nSellExpiryDate,
nBuyCALevel,
nSellCALevel,
nBuyStrikePrice,
nSellStrikePrice,
cBuyOptionType,
cSellOptionType,
cBuyOpenClose,
cSellOpenClose,
cBuyCoverUncover,
cSellCoverUncover,
cBuyParticipant,
cSellParticipant,
nBuyEntryDateTime,
nSellEntryDateTime,
nBuyTimeStamp,
nSellTimeStamp,
nMarketSegmentId,
sDealerCode,
nBuyErrorCode,
nSellErrorCode,
nUserId
)
values
(
@nMessageCode,
@nMessageLength,
@cBuyAlphaChar,
@cSellAlphaChar,
@nBuyToken,
@nSellToken,
@nQuantity,
@nRemainingQuantity,
@nBuyPrice,
@nSellPrice,
@cBuyAccountCode,
@cSellAccountCode,
@nAONIOC,
@nBuyBookType,
@nSellBookType,
@nBuyOrderType,
@nSellOrderType,
@nOrder1BuySell,
@nOrder2BuySell,
@nBranchId,
@cBuyRemarks,
@cSellRemarks,
@nProClient,
@nOrderNumber,
@cBuyInstrumentName,
@cSellInstrumentName,
@cBuySymbol,
@cSellSymbol,
@cBuySeries,
@cSellSeries,
@nBuyExpiryDate,
@nSellExpiryDate,
@nBuyCALevel,
@nSellCALevel,
@nBuyStrikePrice,
@nSellStrikePrice,
@cBuyOptionType,
@cSellOptionType,
@cBuyOpenClose,
@cSellOpenClose,
@cBuyCoverUncover,
@cSellCoverUncover,
@cBuyParticipant,
@cSellParticipant,
@nBuyEntryDateTime,
@nSellEntryDateTime,
@nBuyTimeStamp,
@nSellTimeStamp,
@nMarketSegmentId,
@sDealerCode,
@nBuyErrorCode,
@nSellErrorCode,
@nUserId
)



end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailySurvFailedExplRequests
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_DailyTrades
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_DailyTrades    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyTrades    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_DailyTrades    Script Date: 23/10/01 9:42:11 AM ******/
create proc stp_DailyTrades
(
	@nMessageCode dt_MessageCode   ,
	@nTimeStamp dt_Time   ,
	@sAlphaChar dt_AlphaChar   ,
	@nErrorCode dt_ErrorCode   ,
	@sTimeStamp1 dt_TimeStamp   ,
	@nMessageLength dt_MessageLength   ,
	@sSymbol dt_Symbol   ,
	@sSeries dt_Series   ,
	@nQuantityTraded dt_Quantity   ,
	@nQuantityRemaining dt_Quantity   ,
	@nTradedPrice dt_Price   ,
	@nTradeNumber dt_TradeNumber   ,
	@nTradedTime dt_Time   ,
	@nBuyOrSell dt_BuyOrSell   ,
	@nTradedOrderNumber dt_OrderNumber   ,
	@sBrokerID dt_BrokerCode   ,
	@cEnteredBy char (1)    ,
	@nUserID smallint   ,
	@sAccountCode dt_AccountCode   ,
	@nOriginalQuantity dt_Quantity   ,
	@nDisclosedQuantity dt_Quantity   ,
	@nDisclosedQuantityRemaining dt_Quantity   ,
	@nOrderPrice dt_Price   ,
	@nMF dt_OrderTerms   ,
	@nAON dt_OrderTerms   ,
	@nIOC dt_OrderTerms   ,
	@nGTC dt_OrderTerms   ,
	@nDay dt_OrderTerms   ,
	@nSL dt_OrderTerms   ,
	@nMarket dt_OrderTerms   ,
	@nATO dt_OrderTerms   ,
	@nFrozen dt_OrderTerms   ,
	@nModified dt_OrderTerms   ,
	@nTraded dt_OrderTerms   ,
	@nMatchedInd dt_OrderTerms   ,
	@nGoodTillDays dt_GoodTillDays   ,
	@nQuantityTradedToday dt_Quantity   ,
	@sActivityType char (2)    ,
	@nCPTradedOrderNo dt_OrderNumber   ,
	@sCPBrokerID dt_BrokerCode   ,
	@nOrderType smallint   ,
	@nNewQuantity dt_Quantity   ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cOldOpenOrClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cOldCoverOrUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sOldAccountCode char (10)   ,
	@sParticipant char (12)   ,
	@sOldParticipant char (12)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate int  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@cBookType char (1)   ,
	@nMarketSegmentId smallint  

)as

begin
  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

insert into tbl_DailyTrades
(
nMessageCode,
nTimeStamp,
sAlphaChar,
nErrorCode,
sTimeStamp1,
nMessageLength,
sSymbol,
sSeries,
nQuantityTraded,
nQuantityRemaining,
nTradedPrice,
nTradeNumber,
nTradedTime,
nBuyOrSell,
nTradedOrderNumber,
sBrokerID,
cEnteredBy,
nUserID,
sAccountCode,
nOriginalQuantity,
nDisclosedQuantity,
nDisclosedQuantityRemaining,
nOrderPrice,
nMF,
nAON,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nATO,
nFrozen,
nModified,
nTraded,
nMatchedInd,
nGoodTillDays,
nQuantityTradedToday,
sActivityType,
nCPTradedOrderNo,
sCPBrokerID,
nOrderType,
nNewQuantity,
nTokenNumber,
cOpenClose,
cOldOpenOrClose,
cCoverUncover,
cOldCoverOrUncover,
cGiveUpFlag,
sOldAccountCode,
sParticipant,
sOldParticipant,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
cBookType,
nMarketSegmentId
)
VALUES
(
@nMessageCode,
@nTimeStamp,
@sAlphaChar,
@nErrorCode,
@sTimeStamp1,
@nMessageLength,
@sSymbol,
@sSeries,
@nQuantityTraded,
@nQuantityRemaining,
@nTradedPrice,
@nTradeNumber,
@nTradedTime,
@nBuyOrSell,
@nTradedOrderNumber,
@sBrokerID,
@cEnteredBy,
@nUserID,
@sAccountCode,
@nOriginalQuantity,
@nDisclosedQuantity,
@nDisclosedQuantityRemaining,
@nOrderPrice,
@nMF,
@nAON,
@nIOC,
@nGTC,
@nDay,
@nSL,
@nMarket,
@nATO,
@nFrozen,
@nModified,
@nTraded,
@nMatchedInd,
@nGoodTillDays,
@nQuantityTradedToday,
@sActivityType,
@nCPTradedOrderNo,
@sCPBrokerID,
@nOrderType,
@nNewQuantity,
@nTokenNumber,
@cOpenClose,
@cOldOpenOrClose,
@cCoverUncover,
@cOldCoverOrUncover,
@cGiveUpFlag,
@sOldAccountCode,
@sParticipant,
@sOldParticipant,
@sInstrumentName,
@nExpiryDate,
@nStrikePrice,
@sOptionType,
@nCALevel,
@cBookType,
@nMarketSegmentId
)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FAOParticipantMaster
-- --------------------------------------------------
create proc stp_FAOParticipantMaster
(
@nMessageCode		dt_MessageCode,
@nTimeStamp		dt_Time,
@sAlphaChar		dt_AlphaChar,
@nErrorCode		dt_ErrorCode,
@sTimeStamp1		dt_TimeStamp,
@nMessageLength		dt_MessageLength,
@sParticipantCode	dt_ParticipantCode,
@sParticipantName	dt_ParticipantName,
@cParticipantStatus	char(1),
@cDeleteFlag		char(1),
@nLastUpdateTime	dt_Time,
@nMarketSegmentId	smallint
)
--WITH ENCRYPTION
as 
begin


	update tbl_ParticipantMaster
	set 
	nMessageCode 			= @nMessageCode			,
	nTimeStamp 			= @nTimeStamp			,
	sAlphaChar 			= @sAlphaChar			,
	nErrorCode 			= @nErrorCode			,
	sTimeStamp1 			= @sTimeStamp1			,
	nMessageLength 			= @nMessageLength		,
	sParticipantName		= @sParticipantName		,
	cParticipantStatus		= @cParticipantStatus		,	
	nLastUpdateTime			= @nLastUpdateTime		,
	cDeleteFlag			=	case @cDeleteFlag
						when ' ' Then 'N'
						when 'Y' Then 'D'					
						when 'y' Then 'D'
						else @cDeleteFlag		
						End
	where
	sParticipantCode		= @sParticipantCode		
	and
	nMarketSegmentId		= @nMarketSegmentId	

if @@ROWCOUNT = 0

	Begin
	insert into tbl_ParticipantMaster
	(	nMessageCode 			,
		nTimeStamp 			,
		sAlphaChar 			,
		nErrorCode 			,
		sTimeStamp1 			,
		nMessageLength 			,
		sParticipantCode		,
		sParticipantName		,
		cParticipantStatus		,	
		nLastUpdateTime			,
		cDeleteFlag			,		
		nMarketSegmentId

	)
	VALUES
	(
		@nMessageCode 			,
		@nTimeStamp 			,
		@sAlphaChar 			,
		@nErrorCode 			,
		@sTimeStamp1 			,
		@nMessageLength 		,
		@sParticipantCode		,
		@sParticipantName		,
		@cParticipantStatus		,	
		@nLastUpdateTime		,
		case @cDeleteFlag
		when ' ' Then 'N'
		when 'Y' Then 'D'					
		when 'y' Then 'D'
		else @cDeleteFlag		
		End,
		@nMarketSegmentId

	)
	End 


End /* end STP*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FAOScripMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FAOScripMasterFullDownload
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FCMParticipantMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FCMScripMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FetchPreviousTrades
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FutureMTMOFF
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_FutureMTMON
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_GetClientFirstOrderTime
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Stp_GetDailyOHLC
-- --------------------------------------------------
Create Procedure Stp_GetDailyOHLC (@nTime  Integer,
                                   @nToken Integer,
				   @nMarketSegmentId Integer)
as
Begin
  Set NOCOUNT ON

  Select sData,* 
  From   tbl_MarketMovementInfo1
  Where  nSystemTime > @nTime 
  And    nToken      = @nToken
  And    nMarketSegmentId = @nMarketSegmentId	
  Order By nSystemTime

  Set NOCOUNT OFF
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Stp_GetDailyTouchLineInfo
-- --------------------------------------------------
Create Procedure Stp_GetDailyTouchLineInfo (@nTime  Integer,
                                            @nToken Integer)
as
Begin
  Set NOCOUNT ON

  Select sData 
  From   tbl_IndexTickInfo
  Where  nSystemTime > @nTime 
  And    nToken      = @nToken
  Order By nSystemTime

  Set NOCOUNT OFF
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Stp_GetHistoricEOD
-- --------------------------------------------------
Create Procedure Stp_GetHistoricEOD (@nTime int,@nToken smallint,@nMarketSegmentId smallint)
as
Begin
Set NOCOUNT ON
Declare @nTopTime int

create table #tmp_HistoricEOD (sData Varchar(100))

/*
select @nTopTime = nDate from tbl_HistoricEOD
where nDate = (select Top 1 nDate from tbl_HistoricEOD where nDate > @nTime and sTicker = @sTicker order by nDate)
and nToken=@nToken 
And nMarketSegementId = @nMarketSegementId

Insert into #tmp_HistoricEOD
select Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Convert(varchar(6),nDate) + ',' +
       		Replace(convert(varchar(20),nOpen),'00',';') + ',' + 
		Replace(Convert(varchar(20),nHi - nOpen),'00',';') + ',' +
		Replace(convert(varchar(20),nOpen - nLow),'00',';')+ ',' +
       		Replace(convert(varchar(20),nClose - nLow),'00',';')+ ',' +
			 convert(varchar(20),nVolume),',0,0,0,0,',')'), ',0,0,0,' , '('),',0,0,','!'),',0,','|'),'0,',':'),',+','{'),',-','}'),'5,','%'),'10','~'),'20','@'),'30','#'),'40','$'),'50','^'),'60','&'),'70','*'),'80','<'),'90','>')
from tbl_HistoricEOD
where nDate = @nTopTime
and sTicker = @sTicker
*/

Insert into #tmp_HistoricEOD
select sData from tbl_HistoricEOD
where nDate > @nTime 
and nToken=@nToken 
And nMarketSegmentId = @nMarketSegmentId
Order by nDate

select sData from #tmp_HistoricEOD
Set NOCOUNT OFF
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_GetLatestClosePriceByToken
-- --------------------------------------------------
create Procedure stp_GetLatestClosePriceByToken (@nToken int,@nMarketSegmentId smallint)
as
Begin
declare @sData 		varchar(100)	,
	@nTime 		varchar(20)	,
	@nOpen 		varchar(20)	,
	@nHigh 		varchar(20)	,
	@nLow 		varchar(20)	,
	@nClose 	Varchar(20)	,
	@nVolume 	varchar(20)	,
	@nValue 	varchar(30)	,
	@nPointer1 	int		,
	@nPointer2 	int		,
	@nPointer3 	int		,
   @nScripCode int      ,
	@nClosePrice   int	

/* To get the last known Row's Data UnCompressed  */

	select @sData = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(sData, ')', ',0,0,0,0,'), '(', ',0,0,0,'), '!', ',0,0,'), '|', ',0,'), ':', '0,'), '{', ',+'), '}', ',-'), '%', '5,'), '~', '10'), '@', '20'), '#', '30'), '$', '40'), '^', '50'), '&', '60'), '*', '70'), '<', '80'), '>', '90'), ';', '00') 
	from tbl_MarketMovementInfo1 where nSystemTime in (select max(nSystemTime) from tbl_MarketMovementInfo1 where nToken = @nToken and nMarketSegmentId = @nMarketSegmentId)
	and nToken = @nToken
	and nMarketSegmentId = @nMarketSegmentId

/* Split the UnCompressed Data into Meaningful values */

/* Get Time Value Separated */
	select @nPointer1  = 2
	select @nPointer2  = charindex(',',@sData) + 1
	select @nPointer3  = 0
	select @nTime = substring(@sData,@nPointer1,@nPointer2-3)

/* Get Open Price Value Separated */
	select @nPointer1  = @nPointer2
	select @nPointer2  = charindex(',',@sData,@nPointer1) + 1
	select @nPointer3  = (@nPointer2 - @nPointer1) -1
	select @nOpen = substring(@sData,@nPointer1,@nPointer3)

/* Get High Price Value Separated */
	select @nPointer1  = @nPointer2
	select @nPointer2  = charindex(',',@sData,@nPointer1) + 1
	select @nPointer3  = (@nPointer2 - @nPointer1) -1
	select @nHigh = substring(@sData,@nPointer1,@nPointer3)

/* Get Low Price Value Separated */
	select @nPointer1  = @nPointer2
	select @nPointer2  = charindex(',',@sData,@nPointer1) + 1
	select @nPointer3  = (@nPointer2 - @nPointer1) -1
	select @nLow = substring(@sData,@nPointer1,@nPointer3)

/* Get Close Price Value Separated */
	select @nPointer1  = @nPointer2
	select @nPointer2  = charindex(',',@sData,@nPointer1) + 1
	select @nPointer3  = (@nPointer2 - @nPointer1) -1
	select @nClose = substring(@sData,@nPointer1,@nPointer3)


/* With Open Price as the base value form all the other values */ 
	select @nHigh = convert(int,@nOpen) + convert(int,@nHigh)
	select @nLow = convert(int,@nOpen) + convert(int,@nLow)
	select @nClose =  convert(int,@nClose) + convert(int,@nLow)
   select @nClosePrice   = convert(int, isNull(@nClose, 0))

   if @nToken = -11
   Begin
      select @nScripCode = 20000
      if @nClosePrice != 0
      begin
         delete tbl_LatestBhavCopy
         where nToken = @nScripCode

         insert tbl_LatestBhavCopy
         values
         (@nScripCode, 1, @nClosePrice, 0)   
      end 
   End

/* Display the required result */
--	select @nTime as 'Time' ,@nOpen as 'Open' ,@nHigh as 'High', @nLow as 'Low' ,@nClose as 'Close' ,@sData
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_GetTradeOrderDetails
-- --------------------------------------------------
CREATE PROCEDURE stp_GetTradeOrderDetails(
	@nMarketSegmentId int,
	@nOrderNumber dt_OrderNumber,
	@nRetailVersion int,
	@nBuyOrSell dt_BuyOrSell,
	@sDealerId char(15) OUTPUT,
	@nBrokerage dt_Price OUTPUT,
	@DealerOrSquareOff char(2) OUTPUT,
	@sClientId char(15) OUTPUT,
	@nProOrClient int OUTPUT,
	@sMarketType char(2) OUTPUT, 
	@nOrderTime int OUTPUT,
	@sRemarks dt_Remarks OUTPUT,
	@Error char(200) OUTPUT
)
AS
BEGIN
	DECLARE @nDealerCategory as integer
	DECLARE @nCount as integer
	SELECT @nDealerCategory = B.nDealerCategory,@sDealerId = B.sDealerId,@nBrokerage = B.nBrokerage,@DealerOrSquareOff = substring(A.sRemarks,25,1),
		@sClientId = substring(A.sRemarks,1,10),@nProOrClient = A.nProOrClient,@sMarketType = CASE 
													WHEN A.nOrderType in (1,2,3,4) THEN 'N'
													WHEN A.nOrderType = 5 THEN 'O'
													WHEN A.nOrderType = 6 THEN 'S'
													WHEN A.nOrderType = 7 THEN 'A'
													END
													,@nOrderTime = A.nOrderTime,@sRemarks = A.sRemarks 
	FROM tbl_DailyPendingOrders A,tbl_DealerMaster B WHERE A.sDealerCode = B.sDealerCode AND A.nBuyOrSell = @nBuyOrSell and A.nOrderNumber = @nOrderNumber AND A.nMarketSegmentId = @nMarketSegmentId
	
	SELECT @nCount = @@ROWCOUNT
	
	IF @nCount = 0
	BEGIN
		IF @nBuyOrSell = 1
		BEGIN
			SELECT @nDealerCategory = B.nDealerCategory,@sDealerId = B.sDealerId,@nBrokerage = B.nBrokerage,@DealerOrSquareOff = substring(A.cBuyRemarks,25,1),
				@sClientId = substring(A.cBuyRemarks,1,10),@nProOrClient = A.nProClient,@sMarketType = CASE 
															WHEN A.nBuyOrderType in (1,2,3,4) THEN 'N'
															WHEN A.nBuyOrderType = 5 THEN 'O'
															WHEN A.nBuyOrderType = 6 THEN 'S'
															WHEN A.nBuyOrderType = 7 THEN 'A'
															END
															,@nOrderTime = A.nBuyEntryDateTime,@sRemarks = A.cBuyRemarks 
			FROM tbl_DailySpreadPendingOrders A,tbl_DealerMaster B WHERE A.sDealerCode = B.sDealerCode AND A.nOrder1BuySell = @nBuyOrSell AND A.nOrderNumber = @nOrderNumber AND A.nMarketSegmentId = @nMarketSegmentId
		END
		ELSE
		BEGIN
			SELECT @nDealerCategory = B.nDealerCategory,@sDealerId = B.sDealerId,@nBrokerage = B.nBrokerage,@DealerOrSquareOff = substring(A.cSellRemarks,25,1),
				@sClientId = substring(A.cSellRemarks,1,10),@nProOrClient = A.nProClient,@sMarketType = CASE 
															WHEN A.nSellOrderType in (1,2,3,4) THEN 'N'
															WHEN A.nSellOrderType = 5 THEN 'O'
															WHEN A.nSellOrderType = 6 THEN 'S'
															WHEN A.nSellOrderType = 7 THEN 'A'
															END
															,@nOrderTime = A.nSellEntryDateTime,@sRemarks = A.cSellRemarks 
			FROM tbl_DailySpreadPendingOrders A,tbl_DealerMaster B WHERE A.sDealerCode = B.sDealerCode AND A.nOrder2BuySell = @nBuyOrSell AND A.nOrderNumber = @nOrderNumber AND A.nMarketSegmentId = @nMarketSegmentId
		END
		SELECT @nCount = @@ROWCOUNT
		IF @nCount = 0
		BEGIN
			SELECT @Error = 'NOT FOUND IN BOTH SPREAD AND NORNMAL ORDERS'
			RETURN 13
		END
	END
	

	IF (@nDealerCategory in (4,5))
	BEGIN
		Set @sDealerId = 'WEB'
	END
	IF (@nProOrClient = 2 OR @nRetailVersion = 0)
	BEGIN
		Select @sClientId = STUFF(@sClientId, 1, 15, ' ')
	END
	Select @sRemarks = STUFF(@sRemarks, 1, 25, ' ')
	PRINT 'HAPPY DIWALI'
	SELECT @Error = 'ALL OK'
	RETURN 0
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_IndexTick
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailyOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderRequests    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderRequests    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_InsertDailyOrderRequests
(
	@cConfirmed char (1),
	@sDealerCode dt_DealerCode,
	@nMessageCode dt_MessageCode,
	@nTimeStamp dt_Time,
	@nErrorCode dt_ErrorCode,
	@sAlphaChar dt_AlphaChar ,
	@sTimeStamp1 dt_TimeStamp   ,
	@nMessageLength dt_MessageLength   ,
	@nUserID smallint   ,
	@sSymbol dt_Symbol   ,
	@sSeries dt_Series   ,
	@nSettlementDays smallint   ,
	@nOrderType smallint   ,
	@nBuyOrSell dt_BuyOrSell   ,
	@nTotalQuantity dt_Quantity   ,
	@nPrice dt_Price   ,
	@nTriggerPrice dt_Price   ,
	@nGoodTillDays dt_GoodTillDays   ,
	@nDisclosedQuantity dt_Quantity   ,
	@nMinFillQuantity dt_Quantity   ,
	@nProOrClient smallint   ,
	@sAccountCode dt_AccountCode   ,
	@sParticipantCode dt_ParticipantCode   ,
	@sCPBrokerCode dt_BrokerCode   ,
	@sRemarks dt_Remarks   ,
	@nMF dt_OrderTerms   ,
	@nAON dt_OrderTerms   ,
	@nIOC dt_OrderTerms   ,
	@nGTC dt_OrderTerms   ,
	@nDay dt_OrderTerms   ,
	@nSL dt_OrderTerms   ,
	@nMarket dt_OrderTerms   ,
	@nATO dt_OrderTerms   ,
	@nFrozen dt_OrderTerms   ,
	@nModified dt_OrderTerms   ,
	@nTraded dt_OrderTerms   ,
	@nMatchedInd dt_OrderTerms   ,
	@nOrderNumber dt_OrderNumber   ,
	@nOrderTime dt_Time   ,
	@nEntryTime dt_Time   ,
	@nAuctionNumber smallint   ,
	@cParticipantType char (1)    ,
	@nCompetitorPeriod smallint   ,
	@nSolicitorPeriod smallint   ,	
	@cModCancelBy char (1)    ,
	@nReasonCode dt_ReasonCode   ,
	@cSecuritySuspendIndicator char (1)    ,
	@nDisclosedQuantityRemaining dt_Quantity   ,
	@nTotalQuantityRemaining dt_Quantity   ,
	@nQuantityTradedToday dt_Quantity   ,
	@nBranchID smallint   ,
	@sBrokerID dt_BrokerCode   ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  
)as

	begin
	begin transaction
	insert into tbl_DailyOrderRequests
	(
		cConfirmed,sDealerCode,nMessageCode,
		nTimeStamp,nErrorCode,sAlphaChar,
		sTimeStamp1,nMessageLength,nUserID,
		sSymbol,sSeries,nSettlementDays,
		nOrderType,nBuyOrSell,nTotalQuantity,
		nPrice,nTriggerPrice,nGoodTillDays,
		nDisclosedQuantity,nMinFillQuantity,nProOrClient,
		sAccountCode,sParticipantCode,sCPBrokerCode,
		sRemarks,nMF,nAON,
		nIOC,nGTC,nDay,
		nSL,nMarket,nATO,
		nFrozen,nModified,nTraded,
		nMatchedInd,nOrderNumber,nOrderTime,
		nEntryTime,nAuctionNumber,cParticipantType,
		nCompetitorPeriod,nSolicitorPeriod,cModCancelBy,
		nReasonCode,cSecuritySuspendIndicator,nDisclosedQuantityRemaining,
		nTotalQuantityRemaining,nQuantityTradedToday,nBranchID,
		sBrokerID,nTokenNumber,cOpenClose,
		cCoverUncover,cGiveUpFlag,sInstrumentName,
		nExpiryDate,nStrikePrice,sOptionType,
		nCALevel,nBookType,nMarketSegmentId
--nArrivalTime
	)
	VALUES
	(
		@cConfirmed,@sDealerCode,@nMessageCode,
		@nTimeStamp,@nErrorCode,@sAlphaChar,
		@sTimeStamp1,@nMessageLength,@nUserID,
		@sSymbol,@sSeries,@nSettlementDays,
		@nOrderType,@nBuyOrSell,@nTotalQuantity,
		@nPrice,@nTriggerPrice,@nGoodTillDays,
		@nDisclosedQuantity,@nMinFillQuantity,@nProOrClient,
		@sAccountCode,@sParticipantCode,@sCPBrokerCode,
		@sRemarks,@nMF,@nAON,
		@nIOC,@nGTC,@nDay,
		@nSL,@nMarket,@nATO,
		@nFrozen,@nModified,@nTraded,
		@nMatchedInd,@nOrderNumber,@nOrderTime,
		@nEntryTime,@nAuctionNumber,@cParticipantType,
		@nCompetitorPeriod,@nSolicitorPeriod,@cModCancelBy,
		@nReasonCode,@cSecuritySuspendIndicator,@nDisclosedQuantityRemaining,
		@nTotalQuantityRemaining,@nQuantityTradedToday,@nBranchID,
		@sBrokerID,@nTokenNumber,@cOpenClose,
		@cCoverUncover,@cGiveUpFlag,@sInstrumentName,
		@nExpiryDate,@nStrikePrice,@sOptionType,
		@nCALevel,@nBookType,@nMarketSegmentId
	)
	if @@error <> 0
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailyOrderResponses
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderResponses    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderResponses    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyOrderResponses    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_InsertDailyOrderResponses
(
	@sDealerCode dt_DealerCode  ,
	@nMessageCode dt_MessageCode  ,
	@nTimeStamp dt_Time  ,
	@nErrorCode dt_ErrorCode  ,
	@sAlphaChar dt_AlphaChar  ,
	@sTimeStamp1 dt_TimeStamp  ,
	@nMessageLength dt_MessageLength  ,
	@nUserID smallint  ,
	@sSymbol dt_Symbol  ,
	@sSeries dt_Series  ,
	@nSettlementDays smallint  ,
	@nOrderType smallint  ,
	@nBuyOrSell dt_BuyOrSell  ,
	@nTotalQuantity dt_Quantity  ,
	@nPrice dt_Price  ,
	@nTriggerPrice dt_Price  ,
	@nGoodTillDays dt_GoodTillDays  ,
	@nDisclosedQuantity dt_Quantity  ,
	@nMinFillQuantity dt_Quantity  ,
	@nProOrClient smallint  ,
	@sAccountCode dt_AccountCode  ,
	@sParticipantCode dt_ParticipantCode  ,
	@sCPBrokerCode dt_BrokerCode  ,
	@sRemarks dt_Remarks  ,
	@nMF dt_OrderTerms  ,
	@nAON dt_OrderTerms  ,
	@nIOC dt_OrderTerms  ,
	@nGTC dt_OrderTerms  ,
	@nDay dt_OrderTerms  ,
	@nSL dt_OrderTerms  ,
	@nMarket dt_OrderTerms  ,
	@nATO dt_OrderTerms  ,
	@nFrozen dt_OrderTerms  ,
	@nModified dt_OrderTerms  ,
	@nTraded dt_OrderTerms  ,
	@nMatchedInd dt_OrderTerms  ,
	@nOrderNumber dt_OrderNumber  ,
	@nOrderTime dt_Time  ,
	@nEntryTime dt_Time  ,
	@nAuctionNumber smallint  ,
	@cParticipantType char (1)   ,
	@nCompetitorPeriod smallint  ,
	@nSolicitorPeriod smallint  ,
	@cModCancelBy char (1)   ,
	@nReasonCode dt_ReasonCode  ,
	@cSecuritySuspendIndicator char (1)   ,
	@nDisclosedQuantityRemaining dt_Quantity  ,
	@nTotalQuantityRemaining dt_Quantity  ,
	@nQuantityTradedToday dt_Quantity  ,
	@nBranchID smallint  ,
	@sBrokerID dt_BrokerCode  ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  

) as

	BEGIN
	BEGIN TRANSACTION
	INSERT INTO tbl_DailyOrderResponses
	(
		sDealerCode,nMessageCode,nTimeStamp,
		nErrorCode,sAlphaChar,sTimeStamp1,
		nMessageLength,nUserID,sSymbol,
		sSeries,nSettlementDays,nOrderType,
		nBuyOrSell,nTotalQuantity,nPrice,
		nTriggerPrice,nGoodTillDays,nDisclosedQuantity,
		nMinFillQuantity,nProOrClient,sAccountCode,
		sParticipantCode,sCPBrokerCode,sRemarks,
		nMF,nAON,nIOC,
		nGTC,nDay,nSL,
		nMarket,nATO,nFrozen,
		nModified,nTraded,nMatchedInd,
		nOrderNumber,nOrderTime,nEntryTime,
		nAuctionNumber,cParticipantType,nCompetitorPeriod,
		nSolicitorPeriod,cModCancelBy,nReasonCode,
		cSecuritySuspendIndicator,nDisclosedQuantityRemaining,nTotalQuantityRemaining,
		nQuantityTradedToday,nBranchID,sBrokerID,
		nTokenNumber,cOpenClose,cCoverUncover,
		cGiveUpFlag,sInstrumentName,nExpiryDate,
		nStrikePrice,sOptionType,nCALevel,
		nBookType,nMarketSegmentId
	)
	VALUES
	(
		@sDealerCode,@nMessageCode,@nTimeStamp,
		@nErrorCode,@sAlphaChar,@sTimeStamp1,
		@nMessageLength,@nUserID,@sSymbol,
		@sSeries,@nSettlementDays,@nOrderType,
		@nBuyOrSell,@nTotalQuantity,@nPrice,
		@nTriggerPrice,@nGoodTillDays,@nDisclosedQuantity,
		@nMinFillQuantity,@nProOrClient,@sAccountCode,
		@sParticipantCode,@sCPBrokerCode,@sRemarks,
		@nMF,@nAON,@nIOC,
		@nGTC,@nDay,@nSL,
		@nMarket,@nATO,@nFrozen,
		@nModified,@nTraded,@nMatchedInd,
		@nOrderNumber,@nOrderTime,@nEntryTime,
		@nAuctionNumber,@cParticipantType,@nCompetitorPeriod,
		@nSolicitorPeriod,@cModCancelBy,@nReasonCode,
		@cSecuritySuspendIndicator,@nDisclosedQuantityRemaining,@nTotalQuantityRemaining,
		@nQuantityTradedToday,@nBranchID,@sBrokerID,
		@nTokenNumber,@cOpenClose,@cCoverUncover,
		@cGiveUpFlag,@sInstrumentName,@nExpiryDate,
		@nStrikePrice,@sOptionType,@nCALevel,
		@nBookType,@nMarketSegmentId
	)
	IF @@Error <> 0

	BEGIN
		ROLLBACK TRANSACTION
		RETURN @@Error
	END
	COMMIT TRANSACTION	
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailyPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailyPendingOrders    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyPendingOrders    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailyPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_InsertDailyPendingOrders
(
	@cOrderStatus char (1)  ,
	@sDealerCode dt_DealerCode  ,
	@nMessageCode dt_MessageCode  ,
	@nTimeStamp dt_Time  ,
	@nErrorCode dt_ErrorCode  ,
	@sAlphaChar dt_AlphaChar  ,
	@sTimeStamp1 dt_TimeStamp  ,
	@nMessageLength dt_MessageLength  ,
	@nUserID smallint  ,
	@sSymbol dt_Symbol  ,
	@sSeries dt_Series  ,
	@nSettlementDays smallint  ,
	@nOrderType smallint  ,
	@nBuyOrSell dt_BuyOrSell  ,
	@nTotalQuantity dt_Quantity  ,
	@nPrice dt_Price  ,
	@nTriggerPrice dt_Price  ,
	@nGoodTillDays dt_GoodTillDays  ,
	@nDisclosedQuantity dt_Quantity  ,
	@nMinFillQuantity dt_Quantity  ,
	@nProOrClient smallint  ,
	@sAccountCode dt_AccountCode  ,
	@sParticipantCode dt_ParticipantCode  ,
	@sCPBrokerCode dt_BrokerCode  ,
	@sRemarks dt_Remarks  ,
	@nMF dt_OrderTerms  ,
	@nAON dt_OrderTerms  ,
	@nIOC dt_OrderTerms  ,
	@nGTC dt_OrderTerms  ,
	@nDay dt_OrderTerms  ,
	@nSL dt_OrderTerms  ,
	@nMarket dt_OrderTerms  ,
	@nATO dt_OrderTerms  ,
	@nFrozen dt_OrderTerms  ,
	@nModified dt_OrderTerms  ,
	@nTraded dt_OrderTerms  ,
	@nMatchedInd dt_OrderTerms  ,
	@nOrderNumber dt_OrderNumber  ,
	@nOrderTime dt_Time  ,
	@nEntryTime dt_Time  ,
	@nAuctionNumber smallint  ,
	@cParticipantType char (1)  ,
	@nCompetitorPeriod smallint  ,
	@nSolicitorPeriod smallint  ,
	@cModCancelBy char (1)  ,
	@nReasonCode dt_ReasonCode  ,
	@cSecuritySuspendIndicator char (1)  ,
	@nDisclosedQuantityRemaining dt_Quantity  ,
	@nTotalQuantityRemaining dt_Quantity  ,
	@nQuantityTradedToday dt_Quantity  ,
	@nBranchID smallint  ,
	@sBrokerID dt_BrokerCode  ,
	@nPendingQty dt_Quantity  ,
	@nTransactionStatus smallint  ,
	@nReplyCode smallint  ,
	@nReplyMessageLen dt_MessageLength  ,
	@sReplyMessage dt_ReplyMessage  ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)  ,
	@cCoverUncover char (1)  ,
	@cGiveUpFlag char (1)  ,
	@sInstrumentName char (6)  ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)  ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  
) as

	
	BEGIN
	BEGIN TRANSACTION
	  --declare @lnArrivalTime datetime
	  --set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

	INSERT INTO tbl_DailyPendingOrders
	(
		cOrderStatus,sDealerCode,nMessageCode,
		nTimeStamp,nErrorCode,sAlphaChar,
		sTimeStamp1,nMessageLength,nUserID,
		sSymbol,sSeries,nSettlementDays,
		nOrderType,nBuyOrSell,nTotalQuantity,
		nPrice,nTriggerPrice,nGoodTillDays,
		nDisclosedQuantity,nMinFillQuantity,nProOrClient,
		sAccountCode,sParticipantCode,sCPBrokerCode,
		sRemarks,nMF,nAON,
		nIOC,nGTC,nDay,
		nSL,nMarket,nATO,
		nFrozen,nModified,nTraded,
		nMatchedInd,nOrderNumber,nOrderTime,
		nEntryTime,nAuctionNumber,cParticipantType,
		nCompetitorPeriod,nSolicitorPeriod,cModCancelBy,
		nReasonCode,cSecuritySuspendIndicator,nDisclosedQuantityRemaining,
		nTotalQuantityRemaining,nQuantityTradedToday,nBranchID,
		sBrokerID,nPendingQty,nTransactionStatus,
		nReplyCode,nReplyMessageLen,sReplyMessage,
		nTokenNumber,cOpenClose,cCoverUncover,
		cGiveUpFlag,sInstrumentName,nExpiryDate,
		nStrikePrice,sOptionType,nCALevel,
		nBookType,nMarketSegmentId
	)
	VALUES
	(
		@cOrderStatus,@sDealerCode,@nMessageCode,
		@nTimeStamp,@nErrorCode,@sAlphaChar,
		@sTimeStamp1,@nMessageLength,@nUserID,
		@sSymbol,@sSeries,@nSettlementDays,
		@nOrderType,@nBuyOrSell,@nTotalQuantity,
		@nPrice,@nTriggerPrice,@nGoodTillDays,
		@nDisclosedQuantity,@nMinFillQuantity,
		@nProOrClient,@sAccountCode,@sParticipantCode,
		@sCPBrokerCode,@sRemarks,@nMF,
		@nAON,@nIOC,@nGTC,
		@nDay,@nSL,@nMarket,
		@nATO,@nFrozen,@nModified,
		@nTraded,@nMatchedInd,@nOrderNumber,
		@nOrderTime,@nEntryTime,@nAuctionNumber,
		@cParticipantType,@nCompetitorPeriod,@nSolicitorPeriod,
		@cModCancelBy,@nReasonCode,@cSecuritySuspendIndicator,

		@nDisclosedQuantityRemaining,@nTotalQuantityRemaining,@nQuantityTradedToday,
		@nBranchID,@sBrokerID,@nPendingQty,
		@nTransactionStatus,@nReplyCode,@nReplyMessageLen,
		@sReplyMessage,@nTokenNumber,@cOpenClose,
		@cCoverUncover,@cGiveUpFlag,@sInstrumentName,
		@nExpiryDate,@nStrikePrice,@sOptionType,
		@nCALevel,@nBookType,@nMarketSegmentId
	)
	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailySpreadOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderRequests    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderRequests    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_InsertDailySpreadOrderRequests
(
	@cConfirmed char (1)  ,
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
)as
	BEGIN TRANSACTION
	BEGIN
	  --declare @lnArrivalTime datetime
	  --set @lnArrivalTime = (select dateadd(ss,@nBuyTimeStamp,'01/01/1980'))

	INSERT INTO tbl_DailySpreadOrderRequests
	(
		cConfirmed,nMessageCode,nMessageLength,
		cBuyAlphaChar,cSellAlphaChar,nBuyToken,
		nSellToken,nQuantity,nRemainingQuantity,
		nBuyPrice,nSellPrice,cBuyAccountcode,
		cSellAccountcode,nAONIOC,nBuyBookType,
		nSellBookType,nBuyOrderType,nSellOrderType,
		nOrder1BuySell,nOrder2BuySell,nBranchId,
		cBuyRemarks,cSellRemarks,nProClient,
		nOrderNumber,cBuyInstrumentName,cSellInstrumentName,
		cBuySymbol,cSellSymbol,cBuySeries,
		cSellSeries,nBuyExpiryDate,nSellExpiryDate,
		nBuyCALevel,nSellCALevel,nBuyStrikePrice,
		nSellStrikePrice,cBuyOptionType,cSellOptionType,
		cBuyOpenClose,cSellOpenClose,cBuyCoverUncover,
		cSellCoverUncover,cBuyParticipant,cSellParticipant,
		nBuyEntryDateTime,nSellEntryDateTime,nBuyTimeStamp,
		nSellTimeStamp,nMarketSegmentId,sDealerCode,
		nBuyErrorCode,nSellErrorCode,nUserId
	)
	VALUES
	(
		@cConfirmed,@nMessageCode,@nMessageLength,
		@cBuyAlphaChar,@cSellAlphaChar,@nBuyToken,
		@nSellToken,@nQuantity,@nRemainingQuantity,
		@nBuyPrice,@nSellPrice,@cBuyAccountCode,
		@cSellAccountCode,@nAONIOC,@nBuyBookType,
		@nSellBookType,@nBuyOrderType,@nSellOrderType,
		@nOrder1BuySell,@nOrder2BuySell,@nBranchId,
		@cBuyRemarks,@cSellRemarks,@nProClient,
		@nOrderNumber,@cBuyInstrumentName,@cSellInstrumentName,
		@cBuySymbol,@cSellSymbol,@cBuySeries,
		@cSellSeries,@nBuyExpiryDate,@nSellExpiryDate,
		@nBuyCALevel,@nSellCALevel,@nBuyStrikePrice,
		@nSellStrikePrice,@cBuyOptionType,@cSellOptionType,
		@cBuyOpenClose,@cSellOpenClose,@cBuyCoverUncover,
		@cSellCoverUncover,@cBuyParticipant,@cSellParticipant,
		@nBuyEntryDateTime,@nSellEntryDateTime,@nBuyTimeStamp,
		@nSellTimeStamp,@nMarketSegmentId,@sDealerCode,
		@nBuyErrorCode,@nSellErrorCode,@nUserId
	)
	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailySpreadOrderResponses
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderResponses    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderResponses    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadOrderResponses    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_InsertDailySpreadOrderResponses
(
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
) as

	BEGIN
	BEGIN TRANSACTION
	INSERT INTO tbl_DailySpreadOrderResponses
	(
		nMessageCode,nMessageLength,cBuyAlphaChar,
		cSellAlphaChar,nBuyToken,nSellToken,
		nQuantity,nRemainingQuantity,nBuyPrice,
		nSellPrice,cBuyAccountcode,cSellAccountcode,
		nAONIOC,nBuyBookType,nSellBookType,
		nBuyOrderType,nSellOrderType,nOrder1BuySell,
		nOrder2BuySell,nBranchId,cBuyRemarks,
		cSellRemarks,nProClient,nOrderNumber,
		cBuyInstrumentName,cSellInstrumentName,cBuySymbol,
		cSellSymbol,cBuySeries,cSellSeries,
		nBuyExpiryDate,nSellExpiryDate,nBuyCALevel,
		nSellCALevel,nBuyStrikePrice,nSellStrikePrice,
		cBuyOptionType,cSellOptionType,cBuyOpenClose,
		cSellOpenClose,cBuyCoverUncover,cSellCoverUncover,
		cBuyParticipant,cSellParticipant,nBuyEntryDateTime,
		nSellEntryDateTime,nBuyTimeStamp,nSellTimeStamp,
		nMarketSegmentId,sDealerCode,nBuyErrorCode,
		nSellErrorCode,nUserId
	)
	VALUES
	(
		@nMessageCode,@nMessageLength,@cBuyAlphaChar,
		@cSellAlphaChar,@nBuyToken,@nSellToken,
		@nQuantity,@nRemainingQuantity,@nBuyPrice,
		@nSellPrice,@cBuyAccountCode,@cSellAccountCode,
		@nAONIOC,@nBuyBookType,@nSellBookType,
		@nBuyOrderType,@nSellOrderType,@nOrder1BuySell,
		@nOrder2BuySell,@nBranchId,@cBuyRemarks,
		@cSellRemarks,@nProClient,@nOrderNumber,
		@cBuyInstrumentName,@cSellInstrumentName,@cBuySymbol,
		@cSellSymbol,@cBuySeries,@cSellSeries,
		@nBuyExpiryDate,@nSellExpiryDate,@nBuyCALevel,
		@nSellCALevel,@nBuyStrikePrice,@nSellStrikePrice,
		@cBuyOptionType,@cSellOptionType,@cBuyOpenClose,
		@cSellOpenClose,@cBuyCoverUncover,@cSellCoverUncover,
		@cBuyParticipant,@cSellParticipant,@nBuyEntryDateTime,
		@nSellEntryDateTime,@nBuyTimeStamp,@nSellTimeStamp,
		@nMarketSegmentId,@sDealerCode,@nBuyErrorCode,
		@nSellErrorCode,@nUserId
	)
	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailySpreadPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadPendingOrders    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadPendingOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySpreadPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_InsertDailySpreadPendingOrders
(
	@nTransactionStatus smallint,
	@nReplyCode smallint,
	@sReplyMessage dt_ReplyMessage,
	@cOrderStatus char,
	@nReplyMessageLen dt_MessageLength,
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
) as

	BEGIN
	BEGIN TRANSACTION
	INSERT INTO tbl_DailySpreadPendingOrders
	(
		nTransactionStatus,nReplyCode,sReplyMessage,
		cOrderStatus,nReplyMessageLen,
		nMessageCode,nMessageLength,cBuyAlphaChar,
		cSellAlphaChar,nBuyToken,nSellToken,
		nQuantity,nRemainingQuantity,nBuyPrice,
		nSellPrice,cBuyAccountcode,cSellAccountcode,
		nAONIOC,nBuyBookType,nSellBookType,
		nBuyOrderType,nSellOrderType,nOrder1BuySell,
		nOrder2BuySell,nBranchId,cBuyRemarks,
		cSellRemarks,nProClient,nOrderNumber,
		cBuyInstrumentName,cSellInstrumentName,cBuySymbol,
		cSellSymbol,cBuySeries,cSellSeries,nBuyExpiryDate,
		nSellExpiryDate,nBuyCALevel,nSellCALevel,
		nBuyStrikePrice,nSellStrikePrice,cBuyOptionType,
		cSellOptionType,cBuyOpenClose,cSellOpenClose,
		cBuyCoverUncover,cSellCoverUncover,cBuyParticipant,
		cSellParticipant,nBuyEntryDateTime,nSellEntryDateTime,
		nBuyTimeStamp,nSellTimeStamp,nMarketSegmentId,
		sDealerCode,nBuyErrorCode,nSellErrorCode,
		nUserId	)
	VALUES
	(
		@nTransactionStatus,@nReplyCode,@sReplyMessage,
		@cOrderStatus,@nReplyMessageLen,
		@nMessageCode,@nMessageLength,@cBuyAlphaChar,
		@cSellAlphaChar,@nBuyToken,@nSellToken,
		@nQuantity,@nRemainingQuantity,	@nBuyPrice,
		@nSellPrice,@cBuyAccountCode,@cSellAccountCode,
		@nAONIOC,@nBuyBookType,@nSellBookType,
		@nBuyOrderType,@nSellOrderType,@nOrder1BuySell,
		@nOrder2BuySell,@nBranchId,@cBuyRemarks,
		@cSellRemarks,@nProClient,@nOrderNumber,
		@cBuyInstrumentName,@cSellInstrumentName,@cBuySymbol,
		@cSellSymbol,@cBuySeries,@cSellSeries,
		@nBuyExpiryDate,@nSellExpiryDate,@nBuyCALevel,
		@nSellCALevel,@nBuyStrikePrice,@nSellStrikePrice,
		@cBuyOptionType,@cSellOptionType,@cBuyOpenClose,
		@cSellOpenClose,@cBuyCoverUncover,@cSellCoverUncover,
		@cBuyParticipant,@cSellParticipant,@nBuyEntryDateTime,
		@nSellEntryDateTime,@nBuyTimeStamp,@nSellTimeStamp,
		@nMarketSegmentId,@sDealerCode,@nBuyErrorCode,
		@nSellErrorCode,@nUserId)

	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailySurvFailedOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertDailySurvFailedOrders    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySurvFailedOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertDailySurvFailedOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROCEDURE stp_InsertDailySurvFailedOrders
(
	@sDealerCode dt_DealerCode,
	@nMessageCode dt_MessageCode,
	@nTimeStamp dt_Time,
	@nErrorCode dt_ErrorCode,
	@sAlphaChar dt_AlphaChar ,
	@sTimeStamp1 dt_TimeStamp   ,
	@nMessageLength dt_MessageLength   ,
	@nUserID smallint   ,
	@sSymbol dt_Symbol   ,
	@sSeries dt_Series   ,
	@nSettlementDays smallint   ,
	@nOrderType smallint   ,
	@nBuyOrSell dt_BuyOrSell   ,
	@nTotalQuantity dt_Quantity   ,
	@nPrice dt_Price   ,
	@nTriggerPrice dt_Price   ,
	@nGoodTillDays dt_GoodTillDays   ,
	@nDisclosedQuantity dt_Quantity   ,
	@nMinFillQuantity dt_Quantity   ,
	@nProOrClient smallint   ,
	@sAccountCode dt_AccountCode   ,
	@sParticipantCode dt_ParticipantCode   ,
	@sCPBrokerCode dt_BrokerCode   ,
	@sRemarks dt_Remarks   ,
	@nMF dt_OrderTerms   ,
	@nAON dt_OrderTerms   ,
	@nIOC dt_OrderTerms   ,
	@nGTC dt_OrderTerms   ,
	@nDay dt_OrderTerms   ,
	@nSL dt_OrderTerms   ,
	@nMarket dt_OrderTerms   ,
	@nATO dt_OrderTerms   ,
	@nFrozen dt_OrderTerms   ,
	@nModified dt_OrderTerms   ,
	@nTraded dt_OrderTerms   ,
	@nMatchedInd dt_OrderTerms   ,
	@nOrderNumber dt_OrderNumber   ,
	@nOrderTime dt_Time   ,
	@nEntryTime dt_Time   ,
	@nAuctionNumber smallint   ,
	@cParticipantType char (1)    ,
	@nCompetitorPeriod smallint   ,
	@nSolicitorPeriod smallint   ,	
	@cModCancelBy char (1)    ,
	@nReasonCode dt_ReasonCode   ,
	@cSecuritySuspendIndicator char (1)    ,
	@nDisclosedQuantityRemaining dt_Quantity   ,
	@nTotalQuantityRemaining dt_Quantity   ,
	@nQuantityTradedToday dt_Quantity   ,
	@nBranchID smallint   ,
	@sBrokerID dt_BrokerCode   ,
	@nSurvErrorCode dt_ErrorCode,
	@sSurvErrorString dt_ErrorString,
	@cActionCode char,
	@nAcceptRejectStatus dt_AcceptRejectStatus,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@nBookType smallint  ,
	@nMarketSegmentId smallint  
)as

	BEGIN
	BEGIN TRANSACTION
	INSERT INTO tbl_DailySurvFailedOrders
	(
		sDealerCode,nMessageCode,
		nTimeStamp,nErrorCode,sAlphaChar,
		sTimeStamp1,nMessageLength,nUserID,
		sSymbol,sSeries,nSettlementDays,
		nOrderType,nBuyOrSell,nTotalQuantity,
		nPrice,nTriggerPrice,nGoodTillDays,
		nDisclosedQuantity,nMinFillQuantity,nProOrClient,
		sAccountCode,sParticipantCode,sCPBrokerCode,
		sRemarks,nMF,nAON,
		nIOC,nGTC,nDay,
		nSL,nMarket,nATO,
		nFrozen,nModified,nTraded,
		nMatchedInd,nOrderNumber,nOrderTime,
		nEntryTime,nAuctionNumber,cParticipantType,
		nCompetitorPeriod,nSolicitorPeriod,cModCancelBy,
		nReasonCode,cSecuritySuspendIndicator,nDisclosedQuantityRemaining,
		nTotalQuantityRemaining,nQuantityTradedToday,nBranchID,
		sBrokerID,nSurvErrorCode,sSurvErrorString,
		cActionCode,nAcceptRejectStatus,
		nTokenNumber,cOpenClose,
		cCoverUncover,cGiveUpFlag,sInstrumentName,
		nExpiryDate,nStrikePrice,sOptionType,
		nCALevel,nBookType,nMarketSegmentId
	)
	VALUES
	(
		@sDealerCode,@nMessageCode,
		@nTimeStamp,@nErrorCode,@sAlphaChar,
		@sTimeStamp1,@nMessageLength,@nUserID,
		@sSymbol,@sSeries,@nSettlementDays,
		@nOrderType,@nBuyOrSell,@nTotalQuantity,
		@nPrice,@nTriggerPrice,@nGoodTillDays,
		@nDisclosedQuantity,@nMinFillQuantity,@nProOrClient,
		@sAccountCode,@sParticipantCode,@sCPBrokerCode,
		@sRemarks,@nMF,@nAON,
		@nIOC,@nGTC,@nDay,
		@nSL,@nMarket,@nATO,
		@nFrozen,@nModified,@nTraded,
		@nMatchedInd,@nOrderNumber,@nOrderTime,
		@nEntryTime,@nAuctionNumber,@cParticipantType,
		@nCompetitorPeriod,@nSolicitorPeriod,@cModCancelBy,
		@nReasonCode,@cSecuritySuspendIndicator,@nDisclosedQuantityRemaining,
		@nTotalQuantityRemaining,@nQuantityTradedToday,@nBranchID,
		@sBrokerID,@nSurvErrorCode,@sSurvErrorString,
		@cActionCode,@nAcceptRejectStatus,@nTokenNumber,@cOpenClose,
		@cCoverUncover,@cGiveUpFlag,@sInstrumentName,
		@nExpiryDate,@nStrikePrice,@sOptionType,
		@nCALevel,@nBookType,@nMarketSegmentId
	)
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @@ERROR
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertDailyTrades
-- --------------------------------------------------
create proc stp_InsertDailyTrades
(
	@nMessageCode dt_MessageCode   ,
	@nTimeStamp dt_Time   ,
	@sAlphaChar dt_AlphaChar   ,
	@nErrorCode dt_ErrorCode   ,
	@sTimeStamp1 dt_TimeStamp   ,
	@nMessageLength dt_MessageLength   ,
	@sSymbol dt_Symbol   ,
	@sSeries dt_Series   ,
	@nQuantityTraded dt_Quantity   ,
	@nQuantityRemaining dt_Quantity   ,
	@nTradedPrice dt_Price   ,
	@nTradeNumber dt_TradeNumber   ,
	@nTradedTime dt_Time   ,
	@nBuyOrSell dt_BuyOrSell   ,
	@nTradedOrderNumber dt_OrderNumber   ,
	@sBrokerID dt_BrokerCode   ,
	@cEnteredBy char (1)    ,
	@nUserID smallint   ,
	@sAccountCode dt_AccountCode   ,
	@nOriginalQuantity dt_Quantity   ,
	@nDisclosedQuantity dt_Quantity   ,
	@nDisclosedQuantityRemaining dt_Quantity   ,
	@nOrderPrice dt_Price   ,
	@nMF dt_OrderTerms   ,
	@nAON dt_OrderTerms   ,
	@nIOC dt_OrderTerms   ,
	@nGTC dt_OrderTerms   ,
	@nDay dt_OrderTerms   ,
	@nSL dt_OrderTerms   ,
	@nMarket dt_OrderTerms   ,
	@nATO dt_OrderTerms   ,
	@nFrozen dt_OrderTerms   ,
	@nModified dt_OrderTerms   ,
	@nTraded dt_OrderTerms   ,
	@nMatchedInd dt_OrderTerms   ,
	@nGoodTillDays dt_GoodTillDays   ,
	@nQuantityTradedToday dt_Quantity   ,
	@sActivityType char (2)    ,
	@nCPTradedOrderNo dt_OrderNumber   ,
	@sCPBrokerID dt_BrokerCode   ,
	@nOrderType smallint   ,
	@nNewQuantity dt_Quantity   ,
	@nTokenNumber smallint  ,
	@cOpenClose char (1)   ,
	@cCoverUncover char (1)   ,
	@cGiveUpFlag char (1)   ,
	@sInstrumentName char (6)   ,
	@nExpiryDate int  ,
	@nStrikePrice int  ,
	@sOptionType char (2)   ,
	@nCALevel smallint  ,
	@cBookType char (1)   ,
	@nMarketSegmentId smallint,
	@cOldOpenOrClose char (1)   ,
	@cOldCoverOrUncover char,
	@sOldAccountCode char (10)   ,
	@sParticipant char (12)   ,
	@sOldParticipant char (12) 

)as
	BEGIN
	BEGIN TRANSACTION
	update tbl_DailyTrades
	set
	nQuantityTradedToday = @nQuantityTradedToday,
	sOldAccountCode = 	@sOldAccountCode,
	sParticipant = @sParticipant,
	sOldParticipant = @sOldParticipant,
	nTradedTime=@nTradedTime,
	nTimeStamp=@nTimeStamp
	where 
	nMessageCode = @nMessageCode
	and nTradedOrderNumber = @nTradedOrderNumber
	and nTradeNumber = @nTradeNumber

	if (@@ROWCOUNT = 0)
	begin

	INSERT INTO tbl_DailyTrades
	(
		nMessageCode,nTimeStamp,sAlphaChar,
		nErrorCode,sTimeStamp1,nMessageLength,
		sSymbol,sSeries,nQuantityTraded,
		nQuantityRemaining,nTradedPrice,nTradeNumber,
		nTradedTime,nBuyOrSell,nTradedOrderNumber,
		sBrokerID,cEnteredBy,nUserID,
		sAccountCode,nOriginalQuantity,nDisclosedQuantity,
		nDisclosedQuantityRemaining,nOrderPrice,nMF,
		nAON,nIOC,nGTC,
		nDay,nSL,nMarket,
		nATO,nFrozen,nModified,
		nTraded,nMatchedInd,nGoodTillDays,
		nQuantityTradedToday,sActivityType,nCPTradedOrderNo,
		sCPBrokerID,nOrderType,nNewQuantity,
		nTokenNumber,cOpenClose,cOldOpenOrClose,
		cCoverUncover,cOldCoverOrUncover,cGiveUpFlag,
		sOldAccountCode,sParticipant,sOldParticipant,
		sInstrumentName,nExpiryDate,nStrikePrice,
		sOptionType,nCALevel,cBookType,
		nMarketSegmentId
	)
	VALUES
	(
		@nMessageCode,@nTimeStamp,@sAlphaChar,
		@nErrorCode,@sTimeStamp1,@nMessageLength,
		@sSymbol,@sSeries,@nQuantityTraded,
		@nQuantityRemaining,@nTradedPrice,
		@nTradeNumber,@nTradedTime,@nBuyOrSell,
		@nTradedOrderNumber,@sBrokerID,	@cEnteredBy,
		@nUserID,@sAccountCode,@nOriginalQuantity,
		@nDisclosedQuantity,@nDisclosedQuantityRemaining,@nOrderPrice,
		@nMF,@nAON,@nIOC,
		@nGTC,@nDay,@nSL,
		@nMarket,@nATO,@nFrozen,
		@nModified,@nTraded,@nMatchedInd,
		@nGoodTillDays,@nQuantityTradedToday,@sActivityType,
		@nCPTradedOrderNo,@sCPBrokerID,@nOrderType,
		@nNewQuantity,@nTokenNumber,@cOpenClose,
		@cOldOpenOrClose,@cCoverUncover,@cOldCoverOrUncover,
		@cGiveUpFlag,@sOldAccountCode,@sParticipant,
		@sOldParticipant,@sInstrumentName,@nExpiryDate,
		@nStrikePrice,@sOptionType,@nCALevel,
		@cBookType,@nMarketSegmentId
	)
	end 
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN @@ERROR
	END
	COMMIT TRANSACTION
END /* end proc*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertExPlFileUpload
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertExPlFileUpload    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertExPlFileUpload    Script Date: 10/25/01 12:26:46 PM ******/
CREATE PROCEDURE stp_InsertExPlFileUpload
	(
	@dPositionDate			varchar(15),
	@sSegmentIndicator		varchar(10),
	@sSettlementType 		varchar(10),
	@sClearingMemberCode		varchar(10),
	@sMemberType			varchar(10),
	@sTradingMemberCode		varchar(10),
	@sAccountType			varchar(10),
	@sClientAccountCode		varchar(10),
	@sInstrumentType		varchar(10),
	@sSymbol			varchar(10),
	@dExpiryDate			varchar(15),
	@nStrikePrice			int,
	@sOptiontype			varchar(5),
	@sCALevel			varchar(10),
	@nBroughtForwardLongQty		int,
	@nBroughtForwardLongVal		int,
	@nBroughtForwardShortQty	int,
	@nBroughtForwardShortVal	int,
	@nDayBuyOpenQty			int,
	@nDayBuyOpenVal			int,
	@nDaySellOpenQty		int,
	@nDaySellOpenVal		int,
	@nPreExAsgmntLongQty		int,
	@nPreExAsgmntLongVal		int,
	@nPreExAsgmntShortQty		int,
	@nPreExAsgmntShortVal		int,
	@nExercisedQty			int,
	@nAssignedQty			int,
	@nPostExAsgmntLongQty		int,
	@nPostExAsgmntLongVal		int,
	@nPostExAsgmntShortQty		int,
	@nPostExAsgmntShortVal		int,
	@nSettlementPrice		int,
	@nNetPremium			int,
	@nDailyMTMSettlementValue	int,
	@nFuturesFinalSettlementValue	int,
	@nExercisedAssignedValue	int
	)
AS
	IF EXISTS(SELECT * FROM tbl_ExPlFileUploadData WHERE dPositionDate  = @dPositionDate 
		 AND sAccountType         =  @sAccountType 
		 AND sClientAccountCode   =  @sClientAccountCode		
		 AND sInstrumentType 	  =  @sInstrumentType		
		 AND sSymbol	          =  @sSymbol			
		 AND sExpiryDate	  =  @dExpiryDate			
		 AND nStrikePrice	  =  @nStrikePrice			
		 AND sOptionType	  =  @sOptiontype)
	BEGIN
		/*UPDATE tbl_ExPlFileUploadData 
	   	SET  dPositionDate		= 	@dPositionDate ,	
		sSegmentIndicator		=	@sSegmentIndicator	,		
		sSettlementType			=	@sSettlementType 	,	
		sClearingMemberCode		=	@sClearingMemberCode	,	
		sMemberType			=	@sMemberType		,	
		sTradingMemberCode		=	@sTradingMemberCode	,	
		sAccountType			=	@sAccountType		,	
		sClientAccountCode		=	@sClientAccountCode	,	
		sInstrumentType			=	@sInstrumentType	,	
		sSymbol				=	@sSymbol		,	
		sExpiryDate			=	@dExpiryDate		,	
		nStrikePrice			=	@nStrikePrice		,	
		sOptionType			=	@sOptiontype		,	
		sCALevel			=	@sCALevel		,	
		nBroughtForwardLongQty		=	@nBroughtForwardLongQty	,	
		nBroughtForwardLongVal		=	@nBroughtForwardLongVal	,	
		nBroughtForwardShortQty		=	@nBroughtForwardShortQty,	
		nBroughtForwardShortVal		=	@nBroughtForwardShortVal,	
		nDayBuyOpenQty			=	@nDayBuyOpenQty		,	
		nDayBuyOpenVal			=	@nDayBuyOpenVal		,	
		nDaySellOpenQty			=	@nDaySellOpenQty	,	
		nDaySellOpenVal			=	@nDaySellOpenVal	,	
		nPreExAsgmntLongQty		=	@nPreExAsgmntLongQty	,	
		nPreExAsgmntLongVal		=	@nPreExAsgmntLongVal	,	
		nPreExAsgmntShortQty		=	@nPreExAsgmntShortQty	,
		nPreExAsgmntShortVal		=	@nPreExAsgmntShortVal	,	
		nExcercisedQty			=	@nExercisedQty		,
		nAssignedQuantity		=	@nAssignedQty		,	
		nPostExAsgmntLongQty		=	@nPostExAsgmntLongQty	,	
		nPostExAsgmntLongVal		=	@nPostExAsgmntLongVal	,	
		nPostExAsgmntShortQty		=	@nPostExAsgmntShortQty	,	
		nPostExAsgmntShortVal		=	@nPostExAsgmntShortVal	,	
		nSettlementPrice		=	@nSettlementPrice	,	
		nNetPremium			=	@nNetPremium		,	
		nDailyMTMSettlementVal		=	@nDailyMTMSettlementValue,	
		nFuturesFinalSettlement		=	@nFuturesFinalSettlementValue,	
		nExcercisedAssignmentVal		=	@nExercisedAssignedValue	
		WHERE 
		dPositionDate 			 =  @dPositionDate 
		AND sAccountType        	 =  @sAccountType 
		AND sClientAccountCode  	 =  @sClientAccountCode		
		AND sInstrumentType 	 	 =  @sInstrumentType		
		AND sSymbol			 =  @sSymbol			
		AND sExpiryDate	  		 =  @dExpiryDate			
		AND nStrikePrice	  	 =  @nStrikePrice			
		AND sOptionType			 =  @sOptiontype*/
		RAISERROR 50001 'Record Exists'
	END
	ELSE
	BEGIN
	INSERT INTO tbl_ExPlFileUploadData(
	dPositionDate  ,
	sSegmentIndicator ,
	sSettlementType   ,
	sClearingMemberCode  ,
	sMemberType  ,
	sTradingMemberCode ,
	sAccountType  ,
	sClientAccountCode  ,
	sInstrumentType  ,
	sSymbol  ,
	sExpiryDate ,
	nStrikePrice ,
	sOptionType  ,
	sCALevel  ,
	nBroughtForwardLongQty ,
	nBroughtForwardLongVal ,
	nBroughtForwardShortQty ,
	nBroughtForwardShortVal ,
	nDayBuyOpenQty ,
	nDayBuyOpenVal ,
	nDaySellOpenQty ,
	nDaySellOpenVal ,
	nPreExAsgmntLongQty ,
	nPreExAsgmntLongVal ,
	nPreExAsgmntShortQty ,
	nPreExAsgmntShortVal ,
	nExcercisedQty ,
	nAssignedQuantity ,
	nPostExAsgmntLongQty ,
	nPostExAsgmntLongVal ,
	nPostExAsgmntShortQty ,
	nPostExAsgmntShortVal ,
	nSettlementPrice ,
	nNetPremium ,
	nDailyMTMSettlementVal ,
	nFuturesFinalSettlement ,
	nExcercisedAssignmentVal 
)
		
		VALUES
		(
		@dPositionDate,
		@sSegmentIndicator,
		@sSettlementType,
		@sClearingMemberCode,
		@sMemberType,
		@sTradingMemberCode,
		@sAccountType,
		@sClientAccountCode,
		@sInstrumentType,
		@sSymbol,
		@dExpiryDate,
		@nStrikePrice,
		@sOptiontype,
		@sCALevel,
		@nBroughtForwardLongQty,
		@nBroughtForwardLongVal,
		@nBroughtForwardShortQty,
		@nBroughtForwardShortVal,
		@nDayBuyOpenQty,
		@nDayBuyOpenVal,
		@nDaySellOpenQty,
		@nDaySellOpenVal,
		@nPreExAsgmntLongQty,
		@nPreExAsgmntLongVal,
		@nPreExAsgmntShortQty,
		@nPreExAsgmntShortVal,
		@nExercisedQty,
		@nAssignedQty,
		@nPostExAsgmntLongQty,
		@nPostExAsgmntLongVal,
		@nPostExAsgmntShortQty,
		@nPostExAsgmntShortVal,
		@nSettlementPrice,
		@nNetPremium,
		@nDailyMTMSettlementValue,
		@nFuturesFinalSettlementValue,
		@nExercisedAssignedValue
		)
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertIntoManualExplPositions
-- --------------------------------------------------

CREATE PROCEDURE stp_InsertIntoManualExplPositions
(
	@nCaseId  int 		,
	@sDealerId varchar (15)   		,
	@sDealerCode varchar (5)   		,
	@sGroupId varchar (15)   		,
	@sGroupCode varchar (5)   		,
	@sClientId varchar (15)   		,
	@sClientCode dt_DealerCode  		,
	@sClientGroupId varchar (15)   		,
	@sClientGroupCode dt_DealerCode  	,
	@nDealerCategory int  			,
	@nDealerGroupCategory int  		,
	@nClientCategory int  			,
	@nClientGroupCategory int  		,
	@nCurrentNetQuantity int 		,
	@nCurrentNetValue float 		,
	@nBuyQuantity int 			,
	@nBuyValue float 			,
	@nSellQuantity int 			,
	@nSellValue float ,
	@nManualNetQuantity int ,
	@nManualNetValue float ,
	@nNewNetQuantity int ,
	@nNewNetValue float ,
	@nApproved int ,
	@sInstrumentName varchar (6)  ,
	@sSymbol varchar (10)  ,
	@sSeries varchar (2)  ,
	@nExpiryDate int ,
	@nStrikePrice float ,
	@sOptionType varchar (2)  ,
	@nCALevel int ,
	@nTransactionStatus int ,
	@nToken int  ,
	@GrossingId varchar(15)

)
AS
BEGIN
	update tbl_ManualExplClientExposures
	set 
	nCaseId    			   	= @nCaseId				,
	nDealerCategory  			= @nDealerCategory  	      		,
	nDealerGroupCategory  			= @nDealerGroupCategory  		,  
	nClientCategory  			= @nClientCategory  	      		,
	nClientGroupCategory  			= @nClientGroupCategory  	 	, 
	nCurrentNetQuantity  			= @nCurrentNetQuantity  	  	,
	nCurrentNetValue  			= @nCurrentNetValue  	      		,
	nBuyQuantity  				= @nBuyQuantity  			,      
	nBuyValue  				= @nBuyValue  		         	, 
	nSellQuantity  				= @nSellQuantity  	          	,
	nSellValue  				= @nSellValue  		      		,
	nManualNetQuantity  			= @nManualNetQuantity  	  		,
	nManualNetValue  			= @nManualNetValue  	   		,   
	nNewNetQuantity  			= @nNewNetQuantity  	    		,  
	nNewNetValue  				= @nNewNetValue  			,      
	nApproved  				= @nApproved  		         	, 
	sInstrumentName  			= @sInstrumentName  	      		,
	sSymbol  				= @sSymbol  		       		,   
	sSeries  				= @sSeries  		        	,  
	nExpiryDate  				= @nExpiryDate  		 	,     
	nStrikePrice  				= @nStrikePrice  		  	,    
	sOptionType  				= @sOptionType  		   	,   
	nCALevel  				= @nCALevel  		          	,
	nTransactionStatus  			= @nTransactionStatus  	  		
	where 
	sDealerId  				= @sDealerId  				and
	sDealerCode  				= @sDealerCode  			and  
	sGroupId  				= @sGroupId  		          	and
	sGroupCode  				= @sGroupCode  		      		and
	sClientId  				= @sClientId  		          	and
	sClientCode  				= @sClientCode  		      	and
	sClientGroupId  			= @sClientGroupId  	      		and
	sClientGroupCode 			= @sClientGroupCode 	      		and
	nToken  				= @nToken                    
if @@ROWCOUNT = 0
BEGIN
insert into tbl_ManualExplClientExposures
	(
	nCaseId  		,sDealerId  		,sDealerCode  		,sGroupId  		,
	sGroupCode  		,sClientId  		,sClientCode  		,sClientGroupId  	,
	sClientGroupCode 	,nDealerCategory  	,nDealerGroupCategory  	,nClientCategory  	,
	nClientGroupCategory  	,nCurrentNetQuantity  	,nCurrentNetValue  	,nBuyQuantity  		,
	nBuyValue  		,nSellQuantity  	,nSellValue  		,nManualNetQuantity  	,
	nManualNetValue  	,nNewNetQuantity  	,nNewNetValue  		,nApproved  		,
	sInstrumentName  	,sSymbol  		,sSeries  		,nExpiryDate  		,
	nStrikePrice  		,sOptionType  		,nCALevel  		,nTransactionStatus  	,
	nToken,  sGrossingClientId 
	)
	values
	(
	@nCaseId  			,@sDealerId  			,@sDealerCode  			,@sGroupId  			,
	@sGroupCode  			,@sClientId  			,@sClientCode  			,@sClientGroupId  		,
	@sClientGroupCode 		,@nDealerCategory  		,@nDealerGroupCategory  	,@nClientCategory  		,
	@nClientGroupCategory  		,@nCurrentNetQuantity  		,@nCurrentNetValue  		,@nBuyQuantity  		,
	@nBuyValue  			,@nSellQuantity  		,@nSellValue  			,@nManualNetQuantity  	,
	@nManualNetValue  		,@nNewNetQuantity  		,@nNewNetValue  		,@nApproved  			,
	@sInstrumentName  		,@sSymbol  			,@sSeries  			,@nExpiryDate  			,
	@nStrikePrice  			,@sOptionType  			,@nCALevel  			,@nTransactionStatus  	,
	@nToken , @GrossingId
	) 
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertIntoManualPositions
-- --------------------------------------------------

CREATE PROCEDURE stp_InsertIntoManualPositions
(
	@sEnteredBy varchar (15)  		,
	@sDealerId varchar (15)   		,
	@sDealerCode varchar (5)   		,
	@sGroupId varchar (15)   		,
	@sGroupCode varchar (5)   		,
	@sClientId varchar (15)   		,
	@sClientCode dt_DealerCode  		,
	@sClientGroupId varchar (15)   		,
	@sClientGroupCode dt_DealerCode  	,
	@nDealerCategory int  			,
	@nDealerGroupCategory int  		,
	@nClientCategory int  			,
	@nClientGroupCategory int  		,
	@nCurrentNetQuantity int 		,
	@nCurrentNetValue float 		,
	@nBuyQuantity int 			,
	@nBuyValue float 			,
	@nSellQuantity int 			,
	@nSellValue float ,
	@nManualNetQuantity int ,
	@nManualNetValue float ,
	@nNewNetQuantity int ,
	@nNewNetValue float ,
	@nApproved int ,
	@sInstrumentName varchar (6)  ,
	@sSymbol varchar (10)  ,
	@sSeries varchar (2)  ,
	@nExpiryDate int ,
	@nStrikePrice float ,
	@sOptionType varchar (2)  ,
	@nCALevel int ,
	@nTransactionStatus int ,
	@nToken int,  
	@sGrossingClientId varchar(15)
)
AS
BEGIN
	update tbl_ManualPositionEntry
	set 
	sEnteredBy  				= @sEnteredBy  				,
	nDealerCategory  			= @nDealerCategory  	      		,
	nDealerGroupCategory  			= @nDealerGroupCategory  		,  
	nClientCategory  			= @nClientCategory  	      		,
	nClientGroupCategory  			= @nClientGroupCategory  	 	, 
	nCurrentNetQuantity  			= @nCurrentNetQuantity  	  	,
	nCurrentNetValue  			= @nCurrentNetValue  	      		,
	nBuyQuantity  				= @nBuyQuantity  			,      
	nBuyValue  				= @nBuyValue  		         	, 
	nSellQuantity  				= @nSellQuantity  	          	,
	nSellValue  				= @nSellValue  		      		,
	nManualNetQuantity  			= @nManualNetQuantity  	  		,
	nManualNetValue  			= @nManualNetValue  	   		,   
	nNewNetQuantity  			= @nNewNetQuantity  	    		,  
	nNewNetValue  				= @nNewNetValue  			,      
	nApproved  				= @nApproved  		         	, 
	sInstrumentName  			= @sInstrumentName  	      		,
	sSymbol  				= @sSymbol  		       		,   
	sSeries  				= @sSeries  		        	,  
	nExpiryDate  				= @nExpiryDate  		 	,     
	nStrikePrice  				= @nStrikePrice  		  	,    
	sOptionType  				= @sOptionType  		   	,   
	nCALevel  				= @nCALevel  		          	,
	nTransactionStatus  			= @nTransactionStatus  	  		
	where 
	sDealerId  				= @sDealerId  				and
	sDealerCode  				= @sDealerCode  			and  
	sGroupId  				= @sGroupId  		          	and
	sGroupCode  				= @sGroupCode  		      		and
	sClientId  				= @sClientId  		          	and
	sClientCode  				= @sClientCode  		      	and
	sClientGroupId  			= @sClientGroupId  	      		and
	sClientGroupCode 			= @sClientGroupCode 	      		and
	nToken  				= @nToken                    		and
	sGrossingClientId 			= @sGrossingClientId 
if @@ROWCOUNT = 0
BEGIN
insert into tbl_ManualPositionEntry
	(
	sEnteredBy  		,sDealerId  		,sDealerCode  		,sGroupId  		,
	sGroupCode  		,sClientId  		,sClientCode  		,sClientGroupId  	,
	sClientGroupCode 	,nDealerCategory  	,nDealerGroupCategory  	,nClientCategory  	,
	nClientGroupCategory  	,nCurrentNetQuantity  	,nCurrentNetValue  	,nBuyQuantity  		,
	nBuyValue  		,nSellQuantity  	,nSellValue  		,nManualNetQuantity  	,
	nManualNetValue  	,nNewNetQuantity  	,nNewNetValue  		,nApproved  		,
	sInstrumentName  	,sSymbol  		,sSeries  		,nExpiryDate  		,
	nStrikePrice  		,sOptionType  		,nCALevel  		,nTransactionStatus  	,
	nToken  , sGrossingClientId 			
	)
	values
	(
	@sEnteredBy  			,@sDealerId  			,@sDealerCode  			,@sGroupId  			,
	@sGroupCode  			,@sClientId  			,@sClientCode  			,@sClientGroupId  		,
	@sClientGroupCode 		,@nDealerCategory  		,@nDealerGroupCategory  	,@nClientCategory  		,
	@nClientGroupCategory  		,@nCurrentNetQuantity  		,@nCurrentNetValue  		,@nBuyQuantity  		,
	@nBuyValue  			,@nSellQuantity  		,@nSellValue  			,@nManualNetQuantity  	,
	@nManualNetValue  		,@nNewNetQuantity  		,@nNewNetValue  		,@nApproved  			,
	@sInstrumentName  		,@sSymbol  			,@sSeries  			,@nExpiryDate  			,
	@nStrikePrice  			,@sOptionType  			,@nCALevel  			,@nTransactionStatus  	,
	@nToken 			,@sGrossingClientId 			
	) 
END
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertIntoUserPrivileges
-- --------------------------------------------------

create proc stp_InsertIntoUserPrivileges
as
begin
declare @lsDealerCode as char (5)
declare @iRows as int
declare @iRowCount as int
set @iRowCount = 0
select @iRows = count(*) from tbl_DealerMaster 
 
declare UP_Cursor SCROLL CURSOR for 
select distinct sDealerCode from tbl_DealerMaster
 
open UP_Cursor
fetch next from UP_Cursor 
into @lsDealerCode
 
 while @@FETCH_STATUS = 0
 begin
  select @iRowCount = @iRowCount +  1
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,1)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,2)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,3)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,4)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,5)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,1,6)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,1)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,2)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,3)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,4)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,5)
  insert into tbl_UserPrivileges(sDealerCode,nExchangeCode,nMarketCode) values (@lsDealerCode,2,6)
  fetch next from UP_Cursor 
  into @lsDealerCode
 end
close UP_Cursor
DEALLOCATE UP_Cursor

/* changes done for spot market on 15/01/2003 since the default for spot is 1*/
/* since the default for spot is 1 make it 0 for group \ branch*/
update tbl_UserPrivileges
set nSpot = 0
where sDealerCode in (select sDealerCode from tbl_DealerMaster where nDealerCategory in(6,7))
/* end changes done for spot market on 15/01/2003*/

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertSpreadDailyOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertSpreadDailyOrderRequests    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertSpreadDailyOrderRequests    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertSpreadDailyOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_InsertSpreadDailyOrderRequests
(
	@cConfirmed char (1)  ,
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
)as
	BEGIN TRANSACTION
	BEGIN
	  --declare @lnArrivalTime datetime
	  --set @lnArrivalTime = (select dateadd(ss,@nBuyTimeStamp,'01/01/1980'))

	INSERT INTO tbl_DailySpreadOrderRequests
	(
		cConfirmed,nMessageCode,nMessageLength,
		cBuyAlphaChar,cSellAlphaChar,nBuyToken,
		nSellToken,nQuantity,nRemainingQuantity,
		nBuyPrice,nSellPrice,cBuyAccountcode,
		cSellAccountcode,nAONIOC,nBuyBookType,
		nSellBookType,nBuyOrderType,nSellOrderType,
		nOrder1BuySell,nOrder2BuySell,nBranchId,
		cBuyRemarks,cSellRemarks,nProClient,
		nOrderNumber,cBuyInstrumentName,cSellInstrumentName,
		cBuySymbol,cSellSymbol,cBuySeries,
		cSellSeries,nBuyExpiryDate,nSellExpiryDate,
		nBuyCALevel,nSellCALevel,nBuyStrikePrice,
		nSellStrikePrice,cBuyOptionType,cSellOptionType,
		cBuyOpenClose,cSellOpenClose,cBuyCoverUncover,
		cSellCoverUncover,cBuyParticipant,cSellParticipant,
		nBuyEntryDateTime,nSellEntryDateTime,nBuyTimeStamp,
		nSellTimeStamp,nMarketSegmentId,sDealerCode,
		nBuyErrorCode,nSellErrorCode,nUserId
	)
	VALUES
	(
		@cConfirmed,@nMessageCode,@nMessageLength,
		@cBuyAlphaChar,@cSellAlphaChar,@nBuyToken,
		@nSellToken,@nQuantity,@nRemainingQuantity,
		@nBuyPrice,@nSellPrice,@cBuyAccountCode,
		@cSellAccountCode,@nAONIOC,@nBuyBookType,
		@nSellBookType,@nBuyOrderType,@nSellOrderType,
		@nOrder1BuySell,@nOrder2BuySell,@nBranchId,
		@cBuyRemarks,@cSellRemarks,@nProClient,
		@nOrderNumber,@cBuyInstrumentName,@cSellInstrumentName,
		@cBuySymbol,@cSellSymbol,@cBuySeries,
		@cSellSeries,@nBuyExpiryDate,@nSellExpiryDate,
		@nBuyCALevel,@nSellCALevel,@nBuyStrikePrice,
		@nSellStrikePrice,@cBuyOptionType,@cSellOptionType,
		@cBuyOpenClose,@cSellOpenClose,@cBuyCoverUncover,
		@cSellCoverUncover,@cBuyParticipant,@cSellParticipant,
		@nBuyEntryDateTime,@nSellEntryDateTime,@nBuyTimeStamp,
		@nSellTimeStamp,@nMarketSegmentId,@sDealerCode,
		@nBuyErrorCode,@nSellErrorCode,@nUserId
	)
	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertUpdateMPFX
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_InsertUserPrivileges
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_InsertUserPrivileges    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertUserPrivileges    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_InsertUserPrivileges    Script Date: 23/10/01 9:42:12 AM ******/
create procedure stp_InsertUserPrivileges
(
	@sDealerCode		char (5),
	@nExchangeCode		smallint,@nMarketCode		smallint,@nRegularLot		smallint,
	@nSpecialTerms		smallint,@nStopLoss		smallint,@nMarketIfTouched	smallint,
	@nNegotiated		smallint,@nOddLot		smallint,@nSpot			smallint,
	@nAuction		smallint,@nLimit		smallint,@nMarket		smallint,
	@nSpread		smallint,@nExcercise		smallint,@nDontExcercise	smallint,
	@nPositionLiquidation	smallint,@nBuy			smallint,@nSell			smallint,
	@nBuyCall		smallint,@nBuyPut		smallint,@nSellCall		smallint,
	@nSellPut		smallint,@nAmerican		smallint,@nEuropean		smallint,
	@nCover			smallint,@nUnCover		smallint,@nOpen			smallint,
	@nClose			smallint,@nDay			smallint,@nGTD			smallint,
	@nGTC			smallint,@nIOC			smallint,@nGTT			smallint,
	@n6A7A			smallint,@nPro			smallint,@nClient		smallint,
	@nParticipant		smallint,@nWHS			smallint,@nBuyBack		smallint,
	@nCash			smallint,@nMargin		smallint,@nTradeModification	smallint,
	@nTradeCancellation	smallint
)
as
Begin
	select count(*) 
	from tbl_UserPrivileges 
	where 
	sDealerCode 				= @sDealerCode 				and		
	nExchangeCode 				= @nExchangeCode 			and 
	nMarketCode 				= @nMarketCode

if @@ROWCOUNT <> 0
	Begin
	update tbl_UserPrivileges
	set
	nRegularLot = @nRegularLot ,		nSpecialTerms = @nSpecialTerms  ,	nStopLoss =  @nStopLoss,
	nMarketIfTouched = @nMarketIfTouched , 	nNegotiated = @nNegotiated, 		nOddLot =  @nOddLot, 			
	nSpot =  @nSpot , 			nAuction = @nAuction  , 		nLimit =  @nLimit ,			
	nMarket = @nMarket  , 			nSpread = @nSpread ,			nExcercise =  @nExcercise ,		
	nDontExcercise = @nDontExcercise, 	nPositionLiquidation = @nPositionLiquidation  ,	nBuy = @nBuy  , 	
	nSell =  @nSell , 			nBuyCall =  @nBuyCall , 		nBuyPut =  @nBuyPut, 			
	nSellCall = @nSellCall  , 		nSellPut = @nSellPut  , 		nAmerican =  @nAmerican, 			
	nEuropean =  @nEuropean , 
	nCover = @nCover , 			nUnCover =  @nUnCover , 		nOpen =  @nOpen , 
	nClose = @nClose   , 			nDay =  @nDay, 				nGTD =  @nGTD , 
	nGTC =  @nGTC , 			nIOC =  @nIOC, 				nGTT =  @nGTT , 
	n6A7A = @n6A7A   , 			nPro =  @nPro, 				nClient =  @nClient , 
	nParticipant = @nParticipant   ,	nWHS = @nWHS  , 			nBuyBack =  @nBuyBack , 
	nCash = @nCash  , 			nMargin = @nMargin,			nTradeModification = @nTradeModification,
	nTradeCancellation = @nTradeCancellation
	where 
	sDealerCode 				= @sDealerCode 				and		
	nExchangeCode 				= @nExchangeCode 			and 
	nMarketCode 				= @nMarketCode
	End
if @@ROWCOUNT = 0
	Begin
	insert into tbl_UserPrivileges
	(
	sDealerCode,		
	nExchangeCode,			nMarketCode,			nRegularLot,
	nSpecialTerms,			nStopLoss,			nMarketIfTouched,
	nNegotiated,			nOddLot,			nSpot,
	nAuction,			nLimit,				nMarket,
	nSpread,			nExcercise,			nDontExcercise,
	nPositionLiquidation,		nBuy,				nSell,
	nBuyCall,			nBuyPut,			nSellCall,
	nSellPut,			nAmerican,			nEuropean,
	nCover,				nUnCover,			nOpen,
	nClose,				nDay,				nGTD,
	nGTC,				nIOC,				nGTT,
	n6A7A,				nPro,				nClient,
	nParticipant,			nWHS,				nBuyBack,
	nCash,				nMargin,			nTradeModification,
	nTradeCancellation
	)
	values
	(
	@sDealerCode,		
	@nExchangeCode,			@nMarketCode,			@nRegularLot,
	@nSpecialTerms,			@nStopLoss,			@nMarketIfTouched,
	@nNegotiated,			@nOddLot,			@nSpot,
	@nAuction,			@nLimit,			@nMarket,
	@nSpread,			@nExcercise,			@nDontExcercise,
	@nPositionLiquidation,		@nBuy,				@nSell,
	@nBuyCall,			@nBuyPut,			@nSellCall,
	@nSellPut,			@nAmerican,			@nEuropean,
	@nCover,			@nUnCover,			@nOpen,
	@nClose,			@nDay,				@nGTD,
	@nGTC,				@nIOC,				@nGTT,
	@n6A7A,				@nPro,				@nClient,
	@nParticipant,			@nWHS,				@nBuyBack,
	@nCash,				@nMargin,			@nTradeModification,
	@nTradeCancellation			
	)
	End /* End Insert */

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_LoadDataFromLog
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_LoadDataFromLog    Script Date: 10/25/01 12:38:14 PM ******/

/****** Object:  Stored Procedure dbo.stp_LoadDataFromLog    Script Date: 10/25/01 12:26:45 PM ******/

/****** Object:  Stored Procedure dbo.stp_LoadDataFromLog    Script Date: 23/10/01 9:42:11 AM ******/
create procedure stp_LoadDataFromLog(@nTodaysDate datetime)
as

begin
 declare @cTodaysDate varchar(20)
 set @cTodaysDate = cast(@nTodaysDate as varchar(20))
 print @cTodaysDate
 print SUBSTRING(@cTodaysDate,1,3)
 print SUBSTRING(@cTodaysDate,5,2)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_OrderData
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_OrderData    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_OrderData    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_OrderData    Script Date: 23/10/01 9:42:12 AM ******/

/****** Object:  Stored Procedure dbo.stp_OrderData    Script Date: 7/31/2001 6:10:47 PM ******/
/****** Object:  Stored Procedure dbo.stp_Startup    Script Date: 7/17/2001 10:49:08 AM ******/
/****** Object:  Stored Procedure dbo.stp_Startup    Script Date: 30/06/01 9:31:21 AM 

******/

/****** Object:  Stored Procedure dbo.stp_Startup    Script Date: 25/06/01 10:10:15 AM 

******/

/*  new StartUp   */
CREATE PROCEDURE stp_OrderData
(@nTodaysDate dt_Time)
as
Begin
/* 
   In this procedure, subsequently, we will have to check against
   the control table (table containing date) whether the system had 
   been started earlier on the same day. In this case, nothing needs to 
   be done. If it is a new day, then in that case, the Daily Tables 
   data needs to be copied into the Log Tables and then cleaned up for
   usage, also the surveillance position values need to be set to 0's 
   in this case.
*/

   declare @Error int

   Begin Tran

   if not exists (SELECT * 
                  FROM   tbl_Control 
                  WHERE  datediff (dd, tbl_Control.dDateTime, getdate()) = 0)
   begin 

      insert tbl_logSpreadPendingOrders
      select * from tbl_dailySpreadPendingOrders

      if (@@error <> 0)
      Begin	
        rollback tran
        raiserror 500001 '(stp_Startup) SQL#095: Startup failed...'
        return -1;
      End
      
      delete tbl_dailySpreadPendingOrders

     if (@@error <> 0)
      Begin	
        rollback tran
        raiserror 500001 '(stp_Startup) SQL#100: Startup failed...'
        return -1;
      End


      /* Add the current date to the control table */

      INSERT tbl_Control 
      VALUES (getdate())

      if (@@error <> 0)
      Begin	
        rollback tran
        raiserror 500001 '(stp_Startup) SQL#125: Startup failed...'
        return -1;
      End
   end

   Commit Tran
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_PopulateDailyExposures
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_PopulateIntegratedLogPendingOrders
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_PopulateIntegratedPendingOrders
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_PopulateTempIntegratedPendingOrders
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Stp_ProcessExplData
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_RebuildDailyExposures
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_RebuildPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_ReduceClientExposures
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_RemoveDealerId
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_ScripMaster
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_ScripMaster    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_ScripMaster    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_ScripMaster    Script Date: 23/10/01 9:42:11 AM ******/
create proc stp_ScripMaster
(
	@nMessageCode dt_MessageCode ,
	@nTimeStamp dt_Time ,
	@sAlphaChar dt_AlphaChar ,
	@nErrorCode dt_ErrorCode ,
	@sTimeStamp1 dt_TimeStamp ,
	@nMessageLength dt_MessageLength ,
	@nToken dt_Token ,
	@sSymbol dt_Symbol ,
	@sSeries dt_Series ,
	@nInstrumentType smallint ,
	@nPermittedToTrade tinyint ,
	@nIssuedCapital float ,
	@nWarningPercent smallint ,
	@nFreezePercent smallint ,
	@sCreditRating char (12) ,
	@nNormal_MarketAllowed dt_Allowed ,
	@Normal_SecurityStatus dt_SecurityStatus ,
	@nOddLot_MarketAllowed dt_Allowed ,
	@nOddLot_SecurityStatus dt_SecurityStatus ,
	@nSpot_MarketAllowed dt_Allowed ,
	@nSpot_SecurityStatus dt_SecurityStatus ,
	@nAuction_MarketAllowed dt_Allowed ,
	@nAuction_SecurityStatus dt_SecurityStatus ,
	@nIssueRate smallint ,
	@nIssueStartDate int ,
	@nIssuePDate dt_Time ,
	@nIssueMaturityDate dt_Time ,
	@nRegularLot int ,
	@nPriceTick int ,
	@sSecurityDesc char (25),
	@nListingDate dt_Time ,
	@nExpulsionDate dt_Time ,
	@nReadmissionDate dt_Time ,
	@nRecordDate dt_Time ,
	@nExDate dt_Time ,
	@nNoDeliveryStartDate dt_Time ,
	@nNoDeliveryEndDate dt_Time ,
	@nAONAllowed dt_Allowed ,
	@nMFAllowed dt_Allowed ,
	@nIndexParticipant smallint ,
	@nBookClosureStartDate dt_Time ,
	@nBookClosureEndDate dt_Time ,
	@nEGM tinyint ,
	@nAGM tinyint ,
	@nInterest tinyint ,
	@nBonus tinyint ,
	@nRights tinyint ,
	@nDividend tinyint ,
	@nLastUpdateTime dt_Time ,
	@cDeleteFlag char (1) ,
	@sRemarks char (25) ,
	@nMarginPercentage int ,
	@nMinimumLot int,
	@nLowPriceRange int ,
	@nHighPriceRange int,
	@nExerciseStartDate dt_Time ,
	@nExerciseEndDate dt_Time ,
	@nOldToken smallint ,
	@sAssetInstrument char,
	@sAssetName char (10) ,
	@nAssetToken smallint  ,
	@nIntrinsicValue int  ,
	@nExtrinsicValue int  ,
	@nIsAsset tinyint  ,
	@nPlAllowed tinyint  ,
	@nExRejectionAllowed tinyint,
	@nExAllowed tinyint  ,
	@nExcerciseStyle tinyint  ,
	@sInstrumentName char (6) ,
	@nExpiryDate dt_Time  ,
	@nStrikePrice int  ,
	@sOptionType char (2) ,
	@nCALevel smallint ,
	@nMarketSegmentId smallint,
	@nArrivalTime  datetime  
)as 

begin

  declare @lnArrivalTime datetime
  set @lnArrivalTime = (select dateadd(ss,@nTimeStamp,'01/01/1980'))

insert into tbl_ScripMaster
(nMessageCode,
nTimeStamp,
sAlphaChar,
nErrorCode,
sTimeStamp1,
nMessageLength,
nToken,
sSymbol,
sSeries,
nInstrumentType,
nPermittedToTrade,
nIssuedCapital,
nWarningPercent,
nFreezePercent,
sCreditRating,
nNormal_MarketAllowed,
nNormal_SecurityStatus,
nOddLot_MarketAllowed,
nOddLot_SecurityStatus,
nSpot_MarketAllowed,
nSpot_SecurityStatus,
nAuction_MarketAllowed,
nAuction_SecurityStatus,
nIssueRate,
nIssueStartDate,
nIssuePDate,
nIssueMaturityDate,
nRegularLot,
nPriceTick,
sSecurityDesc,
nListingDate,
nExpulsionDate,
nReadmissionDate,
nRecordDate,
nExDate,
nNoDeliveryStartDate,
nNoDeliveryEndDate,
nAONAllowed,
nMFAllowed,
nIndexParticipant,
nBookClosureStartDate,
nBookClosureEndDate,
nEGM,
nAGM,
nInterest,
nBonus,
nRights,
nDividend,
nLastUpdateTime,
cDeleteFlag,
sRemarks,
nMarginPercentage,
nMinimumLot,
nLowPriceRange,
nHighPriceRange,
nExerciseStartDate,
nExerciseEndDate,
nOldToken,
sAssetInstrument,
sAssetName,
nAssetToken,
nIntrinsicValue,
nExtrinsicValue,
nIsAsset,
nPlAllowed,
nExRejectionAllowed,
nExAllowed,
nExcerciseStyle,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nMarketSegmentId
)
VALUES
(
	@nMessageCode ,
	@nTimeStamp ,
	@sAlphaChar ,
	@nErrorCode ,
	@sTimeStamp1 ,
	@nMessageLength ,
	@nToken ,
	@sSymbol ,
	@sSeries ,
	@nInstrumentType ,
	@nPermittedToTrade ,
	@nIssuedCapital ,
	@nWarningPercent ,
	@nFreezePercent ,
	@sCreditRating ,
	@nNormal_MarketAllowed ,
	@Normal_SecurityStatus ,
	@nOddLot_MarketAllowed ,
	@nOddLot_SecurityStatus ,
	@nSpot_MarketAllowed ,
	@nSpot_SecurityStatus ,
	@nAuction_MarketAllowed ,
	@nAuction_SecurityStatus ,
	@nIssueRate ,
	@nIssueStartDate  ,
	@nIssuePDate ,
	@nIssueMaturityDate ,
	@nRegularLot ,
	@nPriceTick ,
	@sSecurityDesc ,
	@nListingDate ,
	@nExpulsionDate ,
	@nReadmissionDate ,
	@nRecordDate ,
	@nExDate ,
	@nNoDeliveryStartDate ,
	@nNoDeliveryEndDate ,
	@nAONAllowed ,
	@nMFAllowed ,
	@nIndexParticipant ,
	@nBookClosureStartDate ,
	@nBookClosureEndDate ,
	@nEGM ,
	@nAGM ,
	@nInterest ,
	@nBonus ,
	@nRights ,
	@nDividend ,
	@nLastUpdateTime ,
	@cDeleteFlag ,
	@sRemarks ,
	@nMarginPercentage ,
	@nMinimumLot , 
	@nLowPriceRange ,
	@nHighPriceRange ,
	@nExerciseStartDate ,
	@nExerciseEndDate ,
	@nOldToken ,
	@sAssetInstrument ,
	@sAssetName  ,
	@nAssetToken ,
	@nIntrinsicValue ,
	@nExtrinsicValue ,
	@nIsAsset   ,
	@nPlAllowed ,
	@nExRejectionAllowed ,
	@nExAllowed ,
	@nExcerciseStyle   ,
	@sInstrumentName ,
	@nExpiryDate ,
	@nStrikePrice,
	@sOptionType ,
	@nCALevel ,
	@nMarketSegmentId 
)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_SpreadDailyOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_SpreadDailyOrderRequests    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_SpreadDailyOrderRequests    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_SpreadDailyOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
create proc stp_SpreadDailyOrderRequests
(
	@cConfirmed char (1)  ,
	@nMessageCode smallint   ,
	@nMessageLength smallint   ,
	@cBuyAlphaChar char (2)    ,
	@cSellAlphaChar char (2)    ,
	@nBuyToken smallint   ,
	@nSellToken smallint   ,
	@nQuantity int   ,
	@nRemainingQuantity int   ,
	@nBuyPrice int   ,
	@nSellPrice int   ,
	@cBuyAccountCode char (10)    ,
	@cSellAccountCode char (10)    ,
	@nAONIOC smallint   ,
	@nBuyBookType smallint   ,
	@nSellBookType smallint   ,
	@nBuyOrderType smallint   ,
	@nSellOrderType smallint   ,
	@nOrder1BuySell smallint   ,
	@nOrder2BuySell smallint   ,
	@nBranchId smallint   ,
	@cBuyRemarks char (25)    ,
	@cSellRemarks char (25)    ,
	@nProClient smallint   ,
	@nOrderNumber float   ,
	@cBuyInstrumentName char (6)    ,
	@cSellInstrumentName char (6)    ,
	@cBuySymbol char (10)    ,
	@cSellSymbol char (10)    ,
	@cBuySeries char (2)    ,
	@cSellSeries char (2)    ,
	@nBuyExpiryDate int   ,
	@nSellExpiryDate int   ,
	@nBuyStrikePrice int   ,
	@nSellStrikePrice int   ,
	@nBuyCALevel smallint   ,
	@nSellCALevel smallint   ,
	@cBuyOptionType char (2)    ,
	@cSellOptionType char (2)    ,
	@cBuyOpenClose char (1)    ,
	@cSellOpenClose char (1)    ,
	@cBuyCoverUncover char (1)    ,
	@cSellCoverUncover char (1)    ,
	@cBuyParticipant char (12)    ,
	@cSellParticipant char (12)    ,
	@nBuyEntryDateTime int   ,
	@nSellEntryDateTime int   ,
	@nBuyTimeStamp int  ,
	@nSellTimeStamp int  ,
	@nMarketSegmentId smallint   ,
	@sDealerCode char (5)    ,
	@nBuyErrorCode smallint   ,
	@nSellErrorCode smallint   ,
	@nUserId smallint   
)as
	BEGIN TRANSACTION
	BEGIN
	  --declare @lnArrivalTime datetime
	  --set @lnArrivalTime = (select dateadd(ss,@nBuyTimeStamp,'01/01/1980'))

	INSERT INTO tbl_DailySpreadOrderRequests
	(
		cConfirmed,nMessageCode,nMessageLength,
		cBuyAlphaChar,cSellAlphaChar,nBuyToken,
		nSellToken,nQuantity,nRemainingQuantity,
		nBuyPrice,nSellPrice,cBuyAccountcode,
		cSellAccountcode,nAONIOC,nBuyBookType,
		nSellBookType,nBuyOrderType,nSellOrderType,
		nOrder1BuySell,nOrder2BuySell,nBranchId,
		cBuyRemarks,cSellRemarks,nProClient,
		nOrderNumber,cBuyInstrumentName,cSellInstrumentName,
		cBuySymbol,cSellSymbol,cBuySeries,
		cSellSeries,nBuyExpiryDate,nSellExpiryDate,
		nBuyCALevel,nSellCALevel,nBuyStrikePrice,
		nSellStrikePrice,cBuyOptionType,cSellOptionType,
		cBuyOpenClose,cSellOpenClose,cBuyCoverUncover,
		cSellCoverUncover,cBuyParticipant,cSellParticipant,
		nBuyEntryDateTime,nSellEntryDateTime,nBuyTimeStamp,
		nSellTimeStamp,nMarketSegmentId,sDealerCode,
		nBuyErrorCode,nSellErrorCode,nUserId
	)
	VALUES
	(
		@cConfirmed,@nMessageCode,@nMessageLength,
		@cBuyAlphaChar,@cSellAlphaChar,@nBuyToken,
		@nSellToken,@nQuantity,@nRemainingQuantity,
		@nBuyPrice,@nSellPrice,@cBuyAccountCode,
		@cSellAccountCode,@nAONIOC,@nBuyBookType,
		@nSellBookType,@nBuyOrderType,@nSellOrderType,
		@nOrder1BuySell,@nOrder2BuySell,@nBranchId,
		@cBuyRemarks,@cSellRemarks,@nProClient,
		@nOrderNumber,@cBuyInstrumentName,@cSellInstrumentName,
		@cBuySymbol,@cSellSymbol,@cBuySeries,
		@cSellSeries,@nBuyExpiryDate,@nSellExpiryDate,
		@nBuyCALevel,@nSellCALevel,@nBuyStrikePrice,
		@nSellStrikePrice,@cBuyOptionType,@cSellOptionType,
		@cBuyOpenClose,@cSellOpenClose,@cBuyCoverUncover,
		@cSellCoverUncover,@cBuyParticipant,@cSellParticipant,
		@nBuyEntryDateTime,@nSellEntryDateTime,@nBuyTimeStamp,
		@nSellTimeStamp,@nMarketSegmentId,@sDealerCode,
		@nBuyErrorCode,@nSellErrorCode,@nUserId
	)
	IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		return @@Error
	END
	COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_Startup
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateBhavCopy
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateBOSurvLimits
-- --------------------------------------------------
-- ==================================================================
-- Create procedure For updating back office surveillance limits
-- ====================================================================
-- creating the store procedure

CREATE PROCEDURE stp_UpdateBOSurvLimits( 
	 @nEntryID				int,
	 @nOperationCode      			smallint,
	 @sDealerId           			char(15), 
	 @sGroupId            			char(15),
	 @sSymbol	     			char(10),
	 @sSeries             			char(2),
	 @nPeriodicity        			smallint,
       	 @sInstrumentName     			char(6),
         @nExpiryDate         			int,
	 @nStrikePrice        			int,
       	 @sOptionType         			char(2),
	 @nGrossExposureMultiplier 		smallint,
	 @nGrossExposureLimit 			float,
	 @nGrossExposureWarnLimit 		smallint,
	 @nNetExposureMultiplier  		smallint,
	 @nNetExposureLimit   			float,
	 @nNetExposureWarnLimit			smallint, 
	 @nNetSaleExposureMultiplier 		smallint,
	 @nNetSaleExposureLimit  		float, 	
	 @nNetSaleExposureWarnLimit  		smallint,
	 @nNetPositionMultiplier   		smallint,
	 @nNetPositionLimit   			float,
	 @nNetPositionWarnLimit     		smallint,
	 @nTurnoverMultiplier        		smallint,
	 @nTurnoverLimit      			float,
	 @nTurnoverWarnLimit        		smallint,
	 @nPendingOrdersMultiplier 		smallint,
	 @nPendingOrdersLimit 			float,
	 @nPendingOrdersWarnLimits 		smallint, 	
	 @nMTMLossMultipler       		smallint, 	
	 @nMTMLossLimit       			float,    	
	 @nMTMLossWarnLimits       		smallint, 	
	 @nMarginMultiplier       		smallint, 	
	 @nMarginLimit   			float,    	
	 @nMarginWarnLimits       		smallint, 	
	 @nMaxSingleTransVal  			float,    	
	 @nMaxSingleTransQty  			int,            	
	 @nRetainMultipier			smallint,
	 @nIncludeMTMP				smallint,
	 @nIncludeNetPremium			smallint,
	 @nGrossOrNet				smallint,
	 @cUpdateOrDeleted			char 	
)
AS
	DECLARE 
	@nMaxEntryID int,
	@nEntryTime datetime ;
	BEGIN
	if(LEN(@sDealerId) > 15 OR @sDealerId is NULL)
	begin
		return -1;

	end
	if(@nPeriodicity is null)
	        return -1;
	if(@nPeriodicity < 0 or @nPeriodicity > 1)--and (@nPeriodicity is null))
		return -1;
	if(@nTurnoverLimit is null or @nTurnoverLimit < 0)
	    	return -1;
	if(@nGrossExposureLimit is NULL or @nGrossExposureLimit < 0  )
		return -1;

	--if(@nGrossExposureWarnLimit is null)
		--SET @nGrossExposureWarnLimit = 0.0
	if(@nOperationCode is null)
	       SET @nOperationCode = 1
	if(@cUpdateOrDeleted is null)
	    SET @cUpdateOrDeleted = 'A';

	SET @nEntryTime = getDate()
/*********************************************

	if(@nGrossExposureMultiplier is null)
	   SET @nGrossExposureMultiplier = 0;
	if(@nGrossExposureLimit is null)
	   SET @nGrossExposureLimit = 0.0;	
	if(@nNetExposureMultiplier is null)
	    SET @nNetExposureMultiplier = 0;	
	if(@nNetExposureLimit is null)
	    SET @nNetExposureLimit = 0.0;
	if(@nNetExposureWarnLimit IS null)
	    SET @nNetExposureWarnLimit = 0;		
	if(@nNetSaleExposureMultiplier IS null)
	    SET @nNetSaleExposureMultiplier = 0;	
	if(@nNetSaleExposureLimit IS null)
	    SET @nNetSaleExposureLimit = 0.0;
	if(@nNetSaleExposureWarnLimit IS null)
	    SET @nNetSaleExposureWarnLimit = 0;		
	if(@nNetPositionMultiplier IS null)
	    SET @nNetPositionMultiplier = 0;
	if(@nNetPositionLimit is null)
	    SET @nNetPositionLimit = 0.0;
	if(@nNetPositionWarnLimit is null)
	    SET @nNetPositionWarnLimit = 0;
	if(@nTurnoverMultiplier is null)
	    SET @nTurnoverMultiplier = 0;			
	if(@nTurnoverWarnLimit is null)
	    SET @nTurnoverWarnLimit = 0;
	if(@nPendingOrdersMultiplier is null)
	    SET @nPendingOrdersMultiplier = 0;
	if(@nPendingOrdersLimit is null)
	    SET @nPendingOrdersLimit = 0.0;
	if(@nPendingOrdersWarnLimits is null)
	    SET @nPendingOrdersWarnLimits = 0;
	if(@nMTMLossMultipler is null)
	    SET @nMTMLossMultipler = 0;
	if(@nMTMLossLimit is null)
	    SET @nMTMLossLimit = 0.0;
	if(@nMTMLossWarnLimits is null)
	    SET @nMTMLossWarnLimits = 0;
	if(@nMarginMultiplier is null)
	    SET @nMarginMultiplier = 0;
	if(@nMarginLimit is null)
	    SET @nMarginLimit = 0.0;
	if(@nMarginWarnLimits is null)
	    SET @nMarginWarnLimits = 0;
	if(@nMaxSingleTransVal is null)
	    SET @nMaxSingleTransVal = 0.0;
	if(@nMaxSingleTransQty is null)
	    SET @nMaxSingleTransQty = 0.0;
	if(@nIncludeNetPremium is null)
	    SET @nIncludeNetPremium = 0;
	if(@nGrossOrNet is null)
	    SET @nGrossOrNet=0;
	if(@nIncludeMTMP is null)
	    SET @nIncludeMTMP = 0;
	if(@nRetainMultipier is null)
	    SET @nRetainMultipier = 0;
*******************************************************/
	
	select @nMaxEntryID = max(nEntryID)from tbl_BackOfficeSurvLimits;
	--if(@nMaxEntryID is null)
	begin
		if(@nMaxEntryID = 0 OR @nMaxEntryID is null)
		   SET @nEntryID = 1;
			
		else
	           SET @nEntryID = @nMaxEntryID + 1;
	end

	insert into tbl_BackOfficeSurvLimits(
			 nEntryID,				
			 nOperationCode,      			
			 sDealerId,           			
			 sGroupId,            			
			 sSymbol,	     			
			 sSeries,             			
			 nPeriodicity,        			
	         	 sInstrumentName,     		
	                 nExpiryDate,         		
			 nStrikePrice,        			
		       	 sOptionType,         		
			 nGrossExposureMultiplier, 		
			 nGrossExposureLimit, 		
			 nGrossExposureWarnLimit, 	
			 nNetExposureMultiplier,  	
			 nNetExposureLimit,   		
			 nNetExposureWarnLimit,		
			 nNetSaleExposureMultiplier, 	
			 nNetSaleExposureLimit,  	
			 nNetSaleExposureWarnLimit,  	
			 nNetPositionMultiplier,   	
			 nNetPositionLimit,   			
			 nNetPositionWarnLimit,     		
			 nTurnoverMultiplier,        		
			 nTurnoverLimit,      			
			 nTurnoverWarnLimit,        		
			 nPendingOrdersMultiplier, 		
			 nPendingOrdersLimit, 		
			 nPendingOrdersWarnLimits, 	
			 nMTMLossMultipler,       	
			 nMTMLossLimit,       		
			 nMTMLossWarnLimits,       	
			 nMarginMultiplier,       	
			 nMarginLimit,   		
			 nMarginWarnLimits,       	
			 nMaxSingleTransVal,  		
			 nMaxSingleTransQty,  		
			 nRetainMultipier,		
			 nIncludeMTMP,			
			 nIncludeNetPremium,		
			 nGrossOrNet,			
			 cUpdateOrDeleted,
			 nEntryTime		
		)values
		(
			 @nEntryID,			
			 @nOperationCode,      		
			 @sDealerId,           		
			 @sGroupId,            		
			 @sSymbol,	     		
			 @sSeries,             		
			 @nPeriodicity,        			
		       	 @sInstrumentName,     			
		         @nExpiryDate,         			
			 @nStrikePrice,        			
		       	 @sOptionType,         			
			 @nGrossExposureMultiplier, 		
			 @nGrossExposureLimit, 			
			 @nGrossExposureWarnLimit, 		
			 @nNetExposureMultiplier,  		
			 @nNetExposureLimit,   			
			 @nNetExposureWarnLimit,			
			 @nNetSaleExposureMultiplier, 		
			 @nNetSaleExposureLimit,  		
			 @nNetSaleExposureWarnLimit,  		
			 @nNetPositionMultiplier,   		
			 @nNetPositionLimit,   			
			 @nNetPositionWarnLimit,     		
			 @nTurnoverMultiplier,        	
			 @nTurnoverLimit,      		
			 @nTurnoverWarnLimit,        	
			 @nPendingOrdersMultiplier, 	
			 @nPendingOrdersLimit, 		
			 @nPendingOrdersWarnLimits, 	
			 @nMTMLossMultipler,       	
			 @nMTMLossLimit,       		
			 @nMTMLossWarnLimits,       	
			 @nMarginMultiplier,       	
			 @nMarginLimit,   		
			 @nMarginWarnLimits,       	
			 @nMaxSingleTransVal,  		
			 @nMaxSingleTransQty,  		
			 @nRetainMultipier,		
			 @nIncludeMTMP,			
			 @nIncludeNetPremium,		
			 @nGrossOrNet,			
			 @cUpdateOrDeleted,		
			 @nEntryTime
		)
	 END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateClientExposures
-- --------------------------------------------------


/****** Object:  Stored Procedure dbo.stp_UpdateClientExposures    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateClientExposures    Script Date: 10/25/01 12:26:46 PM ******/

CREATE PROCEDURE stp_UpdateClientExposures 
			(
			  @Rows		           numeric(1)     ,		
			  @sDealerID1          varchar(15)    ,
			  @sClientID1          varchar(15)    ,
           @sDealerGroupID1     varchar(15)    ,
           @sClientGroupID1     varchar(15)    ,
           @sSubBrokerID1       varchar(15)    ,
           @nDealerCategory1     smallint       ,
           @nDealerGroupCategory1 smallint      ,
           @nClientCategory1     smallint      ,
			  @sDealerID2          varchar(15)    ,
			  @sClientID2          varchar(15)    ,
           @sDealerGroupID2     varchar(15)    ,
           @sClientGroupID2     varchar(15)    ,
           @sSubBrokerID2       varchar(15)    ,
           @nDealerCategory2     smallint       ,
           @nDealerGroupCategory2 smallint      ,
           @nClientCategory2     smallint       ,
			  @sDealerID3           varchar(15)    ,
			  @sClientID3           varchar(15)    ,
           @sDealerGroupID3      varchar(15)    ,
           @sClientGroupID3      varchar(15)    ,
           @sSubBrokerID3        varchar(15)    ,
           @nDealerCategory3     smallint       ,
           @nDealerGroupCategory3 smallint      ,
           @nClientCategory3     smallint       ,
			  @sAdminClientID       varchar(15)    ,
           @sAdminDealerGroupID  varchar(15)    ,
           @sAdminClientGroupID  varchar(15)    ,
           @sAdminSubBrokerID    varchar(15)    ,
           @nAdminClientCategory smallint       ,
           @nToken              dt_Token       ,
           @nBuyQuantity        dt_Quantity    ,
           @nBuyValue           dt_Position    ,
           @nSellQuantity       dt_Quantity    ,
           @nSellValue          dt_Position    ,
           @nExchangeCode       smallint       ,  
           @nPeriodicity        smallint       ,
           @nAssetToken         dt_Token       ,
           @sInstrumentName     char(6)        ,
           @sSymbol             dt_Symbol      ,
           @sSeries             dt_Series      ,
           @nExpiryDate         dt_Time        ,
           @nStrikePrice        dt_Price       ,
           @sOptionType         char(2)        ,
           @nMarketPrice        dt_Price       ,
           @sGrossingClientId   varchar(15)
			)
as 
Begin
   Declare
	   @Error                   int,
		@NoOfRows	             int,
		@sDealerID               varchar(15),
		@sClientID               varchar(15),
      @sDealerGroupID          varchar(15),
      @sClientGroupID          varchar(15),
      @sSubbrokerClientID      varchar(15),
      @nDealerCategory         smallint,
      @nDealerGroupCategory    smallint,
      @nClientCategory         smallint    

   While (@Rows != 0)
   Begin
	   If @Rows = 1
      Begin
		   Select @sDealerID = @sDealerID1
         Select @sClientID = @sClientID1
         Select @sDealerGroupID = @sDealerGroupID1
         Select @sClientGroupID = @sClientGroupID1
         Select @sSubbrokerClientID = @sSubBrokerID1
         Select @nDealerCategory = @nDealerCategory1
         Select @nDealerGroupCategory = @nDealerGroupCategory1
         Select @nClientCategory = @nClientCategory1
      End

		If @Rows = 2
      Begin
		   Select @sDealerID = @sDealerID2
         Select @sClientID = @sClientID2
         Select @sDealerGroupID = @sDealerGroupID2
         Select @sClientGroupID = @sClientGroupID2
         Select @sSubbrokerClientID = @sSubBrokerID2
         Select @nDealerCategory = @nDealerCategory2
         Select @nDealerGroupCategory = @nDealerGroupCategory2
         Select @nClientCategory = @nClientCategory2
      End

		If @Rows = 3
      Begin
		   Select @sDealerID = @sDealerID3
         Select @sClientID = @sClientID3
         Select @sDealerGroupID = @sDealerGroupID3
         Select @sClientGroupID = @sClientGroupID3
         Select @sSubbrokerClientID = @sSubBrokerID3
         Select @nDealerCategory = @nDealerCategory3
         Select @nDealerGroupCategory = @nDealerGroupCategory3
         Select @nClientCategory = @nClientCategory3
      End

      /* Possible keys for client exposures could be
         DealerId, ClientId, Token, DealerGroupId, ClientGroupId, 
         Subbroker's ClientId. Only issue here is if SB's Client Id
         is null, 
         Also would we need to insert a row for franchisee's and branch in this case.
         Periodicity is redundant as this may not be required later
         once we look at optimization of exposures
      */

      /* Update the settlement exposures table */
      Update tbl_ClientExposures
      Set    nBuyQuantity        = nBuyQuantity  + @nBuyQuantity  ,
             nBuyValue           = nBuyValue     + @nBuyValue     ,
             nSellQuantity       = nSellQuantity + @nSellQuantity ,
             nSellValue          = nSellValue    + @nSellValue     
      Where  sDealerId            = @sDealerID
      And    sClientId            = @sClientID
      And    nToken               = @nToken
      And    sDealerGroupId       = @sDealerGroupID
      And    sClientGroupId       = @sClientGroupID
      And    sSubBrokerClientId   = @sSubbrokerClientID
		
      Select @Error    = @@error    ,
             @NoOfRows = @@rowcount 
		
      If (@Error <> 0)
      Begin
         rollback tran
         raiserror 500001 '(stp_ComputeSettlementPositions) SQL#010: Startup failed...'
         return -1
      End
		
      If (@NoOfRows = 0)
      Begin
         /* There was no entry found for the Dealer, Client
           Scrip Combination. Therefore Insert the row 
         */
		
         Insert tbl_ClientExposures
          (sDealerId, sClientId, nToken, nBuyQuantity , nBuyValue, nSellQuantity, 
           nSellValue, sDealerGroupId, sClientGroupId, sSubBrokerClientId,
           nDealerCategory, nDealerGroupCategory, nClientCategory, nExchangeCode,
           nPeriodicity, nAssetToken, sInstrumentName, sSymbol, sSeries, nExpiryDate,
           nStrikePrice, sOptionType, nMarketPrice, sGrossingClientId)
         Values 
          (@sDealerID, @sClientID, @nToken, @nBuyQuantity , @nBuyValue, @nSellQuantity, 
           @nSellValue, @sDealerGroupID, @sClientGroupID, @sSubbrokerClientID,
           @nDealerCategory, @nDealerGroupCategory, isnull(@nClientCategory, -1), @nExchangeCode,
           @nPeriodicity, @nAssetToken, @sInstrumentName, @sSymbol, @sSeries, @nExpiryDate,
           @nStrikePrice, @sOptionType, @nMarketPrice, @sGrossingClientId)
		
         If (@@error <> 0)
         Begin
            rollback tran
            raiserror 500001 '(stp_ComputeSettlementPositions) SQL#015: Startup failed...'
            return -1
         End
      End
		
      Select @Rows = @Rows - 1
   End

   /* UPDATE one row for ADMIN */
   Update tbl_ClientExposures
   Set    nBuyQuantity        = nBuyQuantity  + @nBuyQuantity  ,
          nBuyValue           = nBuyValue     + @nBuyValue     ,
          nSellQuantity       = nSellQuantity + @nSellQuantity ,
          nSellValue          = nSellValue    + @nSellValue     
   Where  sDealerId            = 'ADMIN'
   And    sClientId            = @sAdminClientID
   And    nToken               = @nToken
   And    sDealerGroupId       = @sAdminDealerGroupID
   And    sClientGroupId       = @sAdminClientGroupID
   And    sSubBrokerClientId   = @sAdminSubBrokerID

   Select @Error    = @@error    ,
          @NoOfRows = @@rowcount 
		
   If (@Error <> 0)
   Begin
      rollback tran
      raiserror 500001 '(stp_ComputeSettlementPositions) SQL#010: Startup failed...'
      return -1
   End
		
   If (@NoOfRows = 0)
   Begin
      /* There was no entry found for the Dealer, Client
        Scrip Combination. Therefore Insert the row 
      */
		
      Insert tbl_ClientExposures
       (sDealerId, sClientId, nToken, nBuyQuantity , nBuyValue, nSellQuantity, 
        nSellValue, sDealerGroupId, sClientGroupId, sSubBrokerClientId,
        nDealerCategory, nDealerGroupCategory, nClientCategory, nExchangeCode,
        nPeriodicity, nAssetToken, sInstrumentName, sSymbol, sSeries, nExpiryDate,
        nStrikePrice, sOptionType, nMarketPrice, sGrossingClientId)
      Values 
       ('ADMIN', @sAdminClientID, @nToken, @nBuyQuantity , @nBuyValue, @nSellQuantity, 
        @nSellValue, @sAdminDealerGroupID, @sAdminClientGroupID, @sAdminSubBrokerID,
        0, 7, isNull(@nAdminClientCategory,-1), @nExchangeCode,
        @nPeriodicity, @nAssetToken, @sInstrumentName, @sSymbol, @sSeries, @nExpiryDate,
        @nStrikePrice, @sOptionType, @nMarketPrice, @sGrossingClientId)

      If (@@error <> 0)
      Begin
         rollback tran
         raiserror 500001 '(stp_ComputeSettlementPositions) SQL#015: Startup failed...'
         return -1
      End
   End
   RETURN 0
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailyExposures
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailyOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailyOrderRequests    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyOrderRequests    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROCEDURE stp_UpdateDailyOrderRequests
(
	@cConfirmed char (1),
	@sAccountCode dt_AccountCode  
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailyOrderRequests SET cConfirmed = @cConfirmed 
	WHERE sAccountCode = @sAccountCode AND cConfirmed = 'N'
	if (@@error <> 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailyPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailyPendingOrders
(
	@nMessageCode	dt_MessageCode,
	@nTimeStamp	dt_Time,
	@nOrderNumber	dt_OrderNumber,
	@nTransactionStatus	smallint,
	@sAccountCode	dt_AccountCode,
	@nUserID	smallint,
	@nSettlementDays	smallint,
	@nOrderType	smallint,
	@nTotalQuantity	dt_Quantity,
	@nPrice	dt_Price,
	@nTriggerPrice	dt_Price,
	@nGoodTillDays	dt_GoodTillDays,
	@nDisclosedQuantity	dt_Quantity,
	@nMinFillQuantity	dt_Quantity,
	@nProOrClient	smallint,
	@sParticipantCode	dt_ParticipantCode,
	@sCPBrokerCode	dt_BrokerCode,
	@sRemarks	dt_Remarks,
	@nMF	dt_OrderTerms,
	@nAON	dt_OrderTerms,
	@nIOC	dt_OrderTerms,
	@nGTC	dt_OrderTerms,
	@nDay	dt_OrderTerms,
	@nSL	dt_OrderTerms,
	@nMarket	dt_OrderTerms,
	@nATO	dt_OrderTerms,
	@nFrozen	dt_OrderTerms,
	@nModified	dt_OrderTerms,
	@nTraded	dt_OrderTerms,
	@nMatchedInd	dt_OrderTerms,
	@nOrderTime	dt_Time,
	@nEntryTime	dt_Time,
	@nAuctionNumber	smallint,
	@cParticipantType	char,
	@nCompetitorPeriod	smallint,
	@nSolicitorPeriod	smallint,
	@nPendingQty	dt_Quantity,
	@nReplyCode	smallint,
	@nReplyMessageLen	dt_MessageLength,
	@sReplyMessage	dt_ReplyMessage,
	@cModCancelBy	char,
	@nReasonCode	dt_ReasonCode,
	@cSecuritySuspendIndicator	char,
	@nDisclosedQuantityRemaining	dt_Quantity,
	@nTotalQuantityRemaining	dt_Quantity,
	@nQuantityTradedToday	dt_Quantity,
	@nBranchID	smallint,
	@sBrokerID	dt_BrokerCode
)as

	BEGIN
		BEGIN TRANSACTION
		IF (@nMessageCode = 2231 OR @nMessageCode = 2042 OR @nMessageCode = 2072 OR @nMessageCode = 2170)
		BEGIN
			UPDATE tbl_DailyPendingOrders SET
				nTimeStamp = @nTimeStamp, nOrderNumber = @nOrderNumber, nTransactionStatus = @nTransactionStatus,
				nFrozen = @nFrozen WHERE sAccountCode = @sAccountCode AND nTimeStamp <= @nTimeStamp AND nTransactionStatus <> 128  			
		END
		ELSE
		BEGIN
			IF @nMessageCode = 2075
			BEGIN
				UPDATE tbl_DailyPendingOrders SET
					nTimeStamp = @nTimeStamp, nUserID = @nUserID, nSettlementDays = @nSettlementDays,
					nOrderType = @nOrderType, nTotalQuantity = @nTotalQuantity, nPrice = @nPrice,
					nTriggerPrice = @nTriggerPrice, nGoodTillDays = @nGoodTillDays, nDisclosedQuantity = @nDisclosedQuantity,
					nMinFillQuantity = @nMinFillQuantity, nProOrClient = @nProOrClient, sParticipantCode = @sParticipantCode,
					sCPBrokerCode = @sCPBrokerCode, sRemarks = @sRemarks, nMF = @nMF,
					nAON = @nAON, nIOC = @nIOC, nGTC = @nGTC,
					nDay = @nDay, nSL = @nSL, nMarket = @nMarket,
					nATO = @nATO, nFrozen = @nFrozen, nModified = @nModified,
					nTraded = @nTraded, nMatchedInd = @nMatchedInd, nOrderNumber = @nOrderNumber,
					nOrderTime = @nOrderTime, nEntryTime = @nEntryTime, nAuctionNumber = @nAuctionNumber,
					cParticipantType = @cParticipantType, nCompetitorPeriod = @nCompetitorPeriod, nSolicitorPeriod = @nSolicitorPeriod,
					cOrderStatus = 'C',
					nPendingQty = @nPendingQty, nTransactionStatus = @nTransactionStatus,
					nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen, sReplyMessage = @sReplyMessage,
					cModCancelBy = @cModCancelBy, nReasonCode = @nReasonCode, cSecuritySuspendIndicator = @cSecuritySuspendIndicator,
					nDisclosedQuantityRemaining = @nDisclosedQuantityRemaining, nTotalQuantityRemaining = @nTotalQuantityRemaining, nQuantityTradedToday = @nQuantityTradedToday,
					nBranchID = @nBranchID, sBrokerID = @sBrokerID WHERE sAccountCode = @sAccountCode AND nTimeStamp <= @nTimeStamp 
			END
			ELSE
			BEGIN
				UPDATE tbl_DailyPendingOrders SET
					nTimeStamp = @nTimeStamp, nUserID = @nUserID, nSettlementDays = @nSettlementDays,
					nOrderType = @nOrderType, nTotalQuantity = @nTotalQuantity, nPrice = @nPrice,
					nTriggerPrice = @nTriggerPrice, nGoodTillDays = @nGoodTillDays, nDisclosedQuantity = @nDisclosedQuantity,
					nMinFillQuantity = @nMinFillQuantity, nProOrClient = @nProOrClient, sParticipantCode = @sParticipantCode,
					sCPBrokerCode = @sCPBrokerCode, sRemarks = @sRemarks, nMF = @nMF,
					nAON = @nAON, nIOC = @nIOC, nGTC = @nGTC,
					nDay = @nDay, nSL = @nSL, nMarket = @nMarket,
					nATO = @nATO, nFrozen = @nFrozen, nModified = @nModified,
					nTraded = @nTraded, nMatchedInd = @nMatchedInd, nOrderNumber = @nOrderNumber,
					nOrderTime = @nOrderTime, nEntryTime = @nEntryTime, nAuctionNumber = @nAuctionNumber,
					cParticipantType = @cParticipantType, nCompetitorPeriod = @nCompetitorPeriod, nSolicitorPeriod = @nSolicitorPeriod,
					nPendingQty = @nPendingQty, nTransactionStatus = @nTransactionStatus,
					nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen, sReplyMessage = @sReplyMessage,
					cModCancelBy = @cModCancelBy, nReasonCode = @nReasonCode, cSecuritySuspendIndicator = @cSecuritySuspendIndicator,
					nDisclosedQuantityRemaining = @nDisclosedQuantityRemaining, nTotalQuantityRemaining = @nTotalQuantityRemaining, nQuantityTradedToday = @nQuantityTradedToday,
					nBranchID = @nBranchID, sBrokerID = @sBrokerID WHERE sAccountCode = @sAccountCode AND nTimeStamp <= @nTimeStamp 
			END
		END
		IF @@Error <> 0
		BEGIN	
			ROLLBACK TRANSACTION
			return @@Error
		END
		COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailyPendingOrdersOnTradeConfirm
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrdersOnTradeConfirm    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrdersOnTradeConfirm    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyPendingOrdersOnTradeConfirm    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailyPendingOrdersOnTradeConfirm
(
	@nTotalQuantity	dt_Quantity,
	@nTotalQuantityRemaining	dt_Quantity,
	@nPendingQty	dt_Quantity,
	@nQuantityTradedToday	dt_Quantity,
	@nOrderTime	dt_Time,
	@nTokenNumber	smallint,
	@cOpenClose	char,
	@cCoverUncover	char,
	@cGiveUpFlag	char,
	@sInstrumentName	char(6),
	@nStrikePrice	int,
	@nCALevel	smallint,
	@nOrderNumber	dt_OrderNumber,
	@sSymbol	dt_Symbol,
	@sSeries	dt_Series

)as

	BEGIN
		BEGIN TRANSACTION
		UPDATE tbl_DailyPendingOrders SET
			cOrderStatus = 'E', nTransactionStatus = 128, nTotalQuantity = @nTotalQuantity,
			nTotalQuantityRemaining = @nTotalQuantityRemaining, nPendingQty = @nPendingQty, nQuantityTradedToday = @nQuantityTradedToday,
			nOrderTime = @nOrderTime, nTokenNumber = @nTokenNumber, cOpenClose = @cOpenClose,
			cCoverUncover = @cCoverUncover, cGiveUpFlag = @cGiveUpFlag, sInstrumentName = @sInstrumentName,
			nStrikePrice = @nStrikePrice, nCALevel = @nCALevel 
			WHERE  nOrderNumber = @nOrderNumber AND sSymbol = @sSymbol AND sSeries = @sSeries AND
			 nOrderTime <= @nOrderTime 
		IF @@Error <> 0
		BEGIN	
			ROLLBACK TRANSACTION
			return @@Error
		END
		COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailySpreadOrderRequests
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadOrderRequests    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadOrderRequests    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadOrderRequests    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailySpreadOrderRequests
(
	@cConfirmed char (1),
	@sAccountCode dt_AccountCode  
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailySpreadOrderRequests SET cConfirmed = @cConfirmed 
	WHERE cBuyAccountcode = @sAccountCode AND cConfirmed = 'N'
	if (@@error <> 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailySpreadPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailySpreadPendingOrders
(
	@nMessageCode	dt_MessageCode,
	@nBuyTimeStamp	dt_Time,
	@nSellTimeStamp	dt_Time,
	@nUserID smallint,	
	@nOrderNumber	dt_OrderNumber,
	@nTransactionStatus	smallint,
	@cBuyAccountCode	dt_AccountCode,
	@nBuyOrderType	smallint,
	@nSellOrderType	smallint,
	@nQuantity dt_Quantity,
	@nBuyPrice dt_Price,
	@nSellPrice dt_Price,
	@nProOrClient	smallint,
	@cBuyParticipant	dt_ParticipantCode,
	@cSellParticipant	dt_ParticipantCode,
	@cBuyRemarks	dt_Remarks,
	@cSellRemarks	dt_Remarks,
	@nAONIOC smallint,
	@nBuyEntryDateTime dt_Time,
	@nSellEntryDateTime dt_Time,
	--@cOrderStatus char,
	@nReplyCode	smallint,
	@nReplyMessageLen	dt_MessageLength,
	@sReplyMessage	dt_ReplyMessage,
	@nRemainingQuantity int,
	@nBranchID	smallint

)as

	BEGIN
		BEGIN TRANSACTION
		IF (@nMessageCode = 2156)
		BEGIN
			UPDATE tbl_DailySpreadPendingOrders SET
				nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nOrderNumber = @nOrderNumber, nTransactionStatus = @nTransactionStatus
				WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp AND nTransactionStatus <> 128  			
		END
		ELSE
		BEGIN
			IF @nMessageCode = 2155
			BEGIN
				UPDATE tbl_DailySpreadPendingOrders SET
					nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nUserId = @nUserID, 
					--nSettlementDays = @nSettlementDays,
					nBuyOrderType = @nBuyOrderType, nSellOrderType = @nSellOrderType, nQuantity = @nQuantity,
					nBuyPrice = @nBuyPrice,nSellPrice = @nSellPrice, nProClient = @nProOrClient,
					cBuyParticipant = @cBuyParticipant, cSellParticipant = @cSellParticipant, cBuyRemarks = @cBuyRemarks,
					cSellRemarks = @cSellRemarks, nAONIOC = @nAONIOC, nOrderNumber = @nOrderNumber,
					nBuyEntryDateTime = @nBuyEntryDateTime, nSellEntryDateTime = @nSellEntryDateTime,  
					cOrderStatus = 'C',
					nTransactionStatus = @nTransactionStatus, nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen,
					sReplyMessage = @sReplyMessage, nRemainingQuantity = @nRemainingQuantity, nBranchId = @nBranchID
					WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp
			END
			ELSE
			BEGIN
				UPDATE tbl_DailySpreadPendingOrders SET
					nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nUserId = @nUserID, 
					--nSettlementDays = @nSettlementDays,
					nBuyOrderType = @nBuyOrderType, nSellOrderType = @nSellOrderType, nQuantity = @nQuantity,
					nBuyPrice = @nBuyPrice,nSellPrice = @nSellPrice, nProClient = @nProOrClient,
					cBuyParticipant = @cBuyParticipant, cSellParticipant = @cSellParticipant, cBuyRemarks = @cBuyRemarks,
					cSellRemarks = @cSellRemarks, nAONIOC = @nAONIOC, nOrderNumber = @nOrderNumber,
					nBuyEntryDateTime = @nBuyEntryDateTime, nSellEntryDateTime = @nSellEntryDateTime,  
					--cOrderStatus = 'C',
					nTransactionStatus = @nTransactionStatus, nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen,
					sReplyMessage = @sReplyMessage, nRemainingQuantity = @nRemainingQuantity, nBranchId = @nBranchID
					WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp
			END
		END
		IF @@Error <> 0
		BEGIN	
			ROLLBACK TRANSACTION
			return @@Error
		END
		COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailySpreadPendingOrdersOnTradeConfirm
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrdersOnTradeConfirm    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrdersOnTradeConfirm    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySpreadPendingOrdersOnTradeConfirm    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailySpreadPendingOrdersOnTradeConfirm
(
	@nQuantity	dt_Quantity,
	@nRemainingQuantity	dt_Quantity,
	@nBuyEntryDateTime	dt_Time,
	@nSellEntryDateTime	dt_Time,
	--@nTokenNumber	smallint,
	--@cOpenClose	char,
	--@cCoverUncover	char,
	--@cGiveUpFlag	char,
	--@sInstrumentName	char(6),
	--@nStrikePrice	int,
--	@nCALevel	smallint,
	@nOrderNumber	dt_OrderNumber
--	@sSymbol	dt_Symbol,
--	@sSeries	dt_Series

)as

	BEGIN
		BEGIN TRANSACTION
		UPDATE tbl_DailySpreadPendingOrders SET
			cOrderStatus = 'E', nTransactionStatus = 128, nQuantity = @nQuantity, nRemainingQuantity = @nRemainingQuantity, 
			nBuyEntryDateTime = @nBuyEntryDateTime, nSellEntryDateTime = @nSellEntryDateTime
			WHERE  nOrderNumber = @nOrderNumber AND  nBuyEntryDateTime <= @nBuyEntryDateTime 
			AND nSellEntryDateTime <= @nSellEntryDateTime 
		IF @@Error <> 0
		BEGIN	
			ROLLBACK TRANSACTION
			return @@Error
		END
		COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailySurvFailedOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailySurvFailedOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySurvFailedOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailySurvFailedOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateDailySurvFailedOrders
(
	@nAcceptRejectStatus dt_AcceptRejectStatus,
	@sAccountCode dt_AccountCode  
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailySurvFailedOrders SET nAcceptRejectStatus = @nAcceptRejectStatus 
	WHERE sAccountCode = @sAccountCode AND nAcceptRejectStatus = 0
	if (@@error <> 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDailyTrades
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateDailyTrades    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyTrades    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateDailyTrades    Script Date: 23/10/01 9:42:11 AM ******/
CREATE PROCEDURE stp_UpdateDailyTrades
(
	@nMessageCode dt_MessageCode,
	@nQuantityTraded dt_Quantity,
	@nNewQuantity dt_Quantity,
	@nOriginalQuantity dt_Quantity,
	@sParticipant dt_ParticipantCode,
	@sOldParticipant dt_ParticipantCode,
	@sOldAccountCode dt_AccountCode,
	@nTradeNumber dt_TradeNumber,
	@nTradedOrderNumber dt_OrderNumber
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailyTrades SET 
	nMessageCode = @nMessageCode, nQuantityTraded = @nQuantityTraded, nNewQuantity = @nNewQuantity,
	nOriginalQuantity = @nOriginalQuantity,	sParticipant = @sParticipant, sOldParticipant = @sOldParticipant,
	sOldAccountCode = @sOldAccountCode WHERE nTradeNumber = @nTradeNumber AND nTradedOrderNumber = @nTradedOrderNumber
	if (@@error <> 0 OR @@RowCount = 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateDealer
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Stp_UpdateExPlPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateFinalExplExposures
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateManualPositions
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateMarketMovement
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateMarketMovementUnCompreed
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateSPANOutput
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateSPANRPFDetails
-- --------------------------------------------------

CREATE PROCEDURE stp_UpdateSPANRPFDetails
@nVersion int,
@nCreationDate int,
@nPointInTime int,
@sClearingHouse varchar(100),
@nNetMarginFlag int,
@nExchangeCode int
 AS
  declare @RecordCount int 
   SET @RecordCount = ( SELECT ISNULL(COUNT(*),0) FROM tbl_SPANRPFDetails) 
   IF @RecordCount= 0 
   BEGIN	
	insert into tbl_SPANRPFDetails(nVersion,nCreationDate,nPointInTime,
	sClearingHouse,nNetMarginFlag,nExchangeCode) 
	values(@nVersion ,
	@nCreationDate ,
	@nPointInTime ,
	@sClearingHouse,
	@nNetMarginFlag ,
	@nExchangeCode)
      RETURN 0
   END
  ELSE
   BEGIN	
	update tbl_SPANRPFDetails
	set nVersion=@nVersion ,
	nCreationDate=@nCreationDate,
	nPointInTime=@nPointInTime,
	sClearingHouse=@sClearingHouse,
	nNetMarginFlag=@nNetMarginFlag,
	nExchangeCode=@nExchangeCode 	
      RETURN 0
   END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateSpreadDailyPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateSpreadDailyPendingOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateSpreadDailyPendingOrders    Script Date: 10/25/01 12:26:46 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateSpreadDailyPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateSpreadDailyPendingOrders
(
	@nMessageCode	dt_MessageCode,
	@nBuyTimeStamp	dt_Time,
	@nSellTimeStamp	dt_Time,
	@nUserID smallint,	
	@nOrderNumber	dt_OrderNumber,
	@nTransactionStatus	smallint,
	@cBuyAccountCode	dt_AccountCode,
	@nBuyOrderType	smallint,
	@nSellOrderType	smallint,
	@nQuantity dt_Quantity,
	@nBuyPrice dt_Price,
	@nSellPrice dt_Price,
	@nProOrClient	smallint,
	@cBuyParticipant	dt_ParticipantCode,
	@cSellParticipant	dt_ParticipantCode,
	@cBuyRemarks	dt_Remarks,
	@cSellRemarks	dt_Remarks,
	@nAONIOC smallint,
	@nBuyEntryDateTime dt_Time,
	@nSellEntryDateTime dt_Time,
	--@cOrderStatus char,
	@nReplyCode	smallint,
	@nReplyMessageLen	dt_MessageLength,
	@sReplyMessage	dt_ReplyMessage,
	@nRemainingQuantity int,
	@nBranchID	smallint

)as

	BEGIN
		BEGIN TRANSACTION
		IF (@nMessageCode = 2156)
		BEGIN
			UPDATE tbl_DailySpreadPendingOrders SET
				nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nOrderNumber = @nOrderNumber, nTransactionStatus = @nTransactionStatus
				WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp AND nTransactionStatus <> 128  			
		END
		ELSE
		BEGIN
			IF @nMessageCode = 2075
			BEGIN
				UPDATE tbl_DailySpreadPendingOrders SET
					nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nUserId = @nUserID, 
					--nSettlementDays = @nSettlementDays,
					nBuyOrderType = @nBuyOrderType, nSellOrderType = @nSellOrderType, nQuantity = @nQuantity,
					nBuyPrice = @nBuyPrice,nSellPrice = @nSellPrice, nProClient = @nProOrClient,
					cBuyParticipant = @cBuyParticipant, cSellParticipant = @cSellParticipant, cBuyRemarks = @cBuyRemarks,
					cSellRemarks = @cSellRemarks, nAONIOC = @nAONIOC, nOrderNumber = @nOrderNumber,
					nBuyEntryDateTime = @nBuyEntryDateTime, nSellEntryDateTime = @nSellEntryDateTime,  
					cOrderStatus = 'C',
					nTransactionStatus = @nTransactionStatus, nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen,
					sReplyMessage = @sReplyMessage, nRemainingQuantity = @nRemainingQuantity, nBranchId = @nBranchID
					WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp
			END
			ELSE
			BEGIN
				UPDATE tbl_DailySpreadPendingOrders SET
					nBuyTimeStamp = @nBuyTimeStamp, nSellTimeStamp = @nSellTimeStamp, nUserId = @nUserID, 
					--nSettlementDays = @nSettlementDays,
					nBuyOrderType = @nBuyOrderType, nSellOrderType = @nSellOrderType, nQuantity = @nQuantity,
					nBuyPrice = @nBuyPrice,nSellPrice = @nSellPrice, nProClient = @nProOrClient,
					cBuyParticipant = @cBuyParticipant, cSellParticipant = @cSellParticipant, cBuyRemarks = @cBuyRemarks,
					cSellRemarks = @cSellRemarks, nAONIOC = @nAONIOC, nOrderNumber = @nOrderNumber,
					nBuyEntryDateTime = @nBuyEntryDateTime, nSellEntryDateTime = @nSellEntryDateTime,  
					--cOrderStatus = 'C',
					nTransactionStatus = @nTransactionStatus, nReplyCode = @nReplyCode, nReplyMessageLen = @nReplyMessageLen,
					sReplyMessage = @sReplyMessage, nRemainingQuantity = @nRemainingQuantity, nBranchId = @nBranchID
					WHERE cBuyAccountcode = @cBuyAccountCode AND nBuyTimeStamp <= @nBuyTimeStamp
			END
		END
		IF @@Error <> 0
		BEGIN	
			ROLLBACK TRANSACTION
			return @@Error
		END
		COMMIT TRANSACTION
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateSurveillanceMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateTransDailyPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailyPendingOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailyPendingOrders    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailyPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateTransDailyPendingOrders
(
	@nTransactionStatus smallint,
	@sAccountCode dt_AccountCode  
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailyPendingOrders SET nTransactionStatus = @nTransactionStatus 
	WHERE sAccountCode = @sAccountCode AND nTransactionStatus <> 128  
	if (@@error <> 0 OR @@RowCount = 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateTransDailySpreadPendingOrders
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailySpreadPendingOrders    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailySpreadPendingOrders    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateTransDailySpreadPendingOrders    Script Date: 23/10/01 9:42:12 AM ******/
CREATE PROC stp_UpdateTransDailySpreadPendingOrders
(
	@nTransactionStatus smallint,
	@sAccountCode dt_AccountCode  
)AS

	BEGIN
	BEGIN TRANSACTION
	UPDATE tbl_DailySpreadPendingOrders SET nTransactionStatus = @nTransactionStatus 
	WHERE cBuyAccountcode = @sAccountCode AND nTransactionStatus <> 128  
	if (@@error <> 0 OR @@RowCount = 0)
	begin
		rollback transaction
		return @@error
	end
	commit transaction
	end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdateUserPriveleges
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.stp_UpdateUserPriveleges    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateUserPriveleges    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Stored Procedure dbo.stp_UpdateUserPriveleges    Script Date: 23/10/01 9:42:11 AM ******/
create proc stp_UpdateUserPriveleges (@sDealerCode char(5))
as
begin
	print @sDealerCode
	update tbl_UserPrivileges 
	set
	nRegularLot =1,
	nSpecialTerms =1,
	nStopLoss =1,
	nMarketIfTouched =1,
	nNegotiated =1,
	nOddLot =1,
	nSpot  =1,
	nAuction =1,
	nLimit =1,
	nMarket =1,
	nSpread =1,
	nExcercise =1,
	nDontExcercise=1, 
	nPositionLiquidation =1,
	nBuy   =1,
	nSell  =1,
	nBuyCall =1,
	nBuyPut =1,
	nSellCall =1,
	nSellPut =1,
	nAmerican =1,
	nEuropean =1,
	nCover =1,
	nUnCover =1,
	nOpen  =1,
	nClose =1,
	nDay   =1,
	nGTD   =1,
	nGTC   =1,
	nIOC   =1,
	nGTT   =1,
	n6A7A  =1,
	nPro   =1,
	nClient =1,
	nParticipant =1,
	nWHS   =1,
	nBuyBack =1,
	nCash  =1,
	nMargin =1
	where sDealerCode like @sDealerCode

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UpdtDealerExPlUpload
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UploadBhavCopy
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_UploadExplNetPositionInfo
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.test
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.test    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.test    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Stored Procedure dbo.test    Script Date: 23/10/01 9:42:12 AM ******/
create proc test as
begin
declare @xx as int
set @xx = 1
select * from tbl_UserPrivileges
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.test123
-- --------------------------------------------------

/****** Object:  Stored Procedure dbo.test123    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Stored Procedure dbo.test123    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Stored Procedure dbo.test123    Script Date: 23/10/01 9:42:12 AM ******/
Create Procedure test123 /*Procedure_Name*/
As
declare @xx as int
set @xx = 2
   select count(*) from tbl_DealerMaster
  print @xx
	return (0)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_functions_findInUSP
-- --------------------------------------------------
create PROCEDURE usp_functions_findInUSP  
@str varchar(500)  
AS  
  
 set @str = '%' + @str + '%'  
   
 select O.name from sysComments  C  
 join sysObjects O on O.id = C.id  
 where O.xtype = 'P' and C.text like @str

GO

-- --------------------------------------------------
-- TABLE dbo.bse_termid
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_termid]
(
    [termid] VARCHAR(15) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.categorydetail
-- --------------------------------------------------
CREATE TABLE [dbo].[categorydetail]
(
    [exchangesegment] VARCHAR(10) NULL,
    [category] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [name] VARCHAR(100) NULL,
    [address] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL,
    [dexch] VARCHAR(10) NULL,
    [dcat] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.categorydetail_ah
-- --------------------------------------------------
CREATE TABLE [dbo].[categorydetail_ah]
(
    [exchangesegment] VARCHAR(10) NULL,
    [category] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [name] VARCHAR(100) NULL,
    [address] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.categorydetail_hy
-- --------------------------------------------------
CREATE TABLE [dbo].[categorydetail_hy]
(
    [exchangesegment] VARCHAR(10) NULL,
    [category] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [name] VARCHAR(100) NULL,
    [address] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.categorydetail_in
-- --------------------------------------------------
CREATE TABLE [dbo].[categorydetail_in]
(
    [exchangesegment] VARCHAR(10) NULL,
    [category] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [name] VARCHAR(100) NULL,
    [address] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.categorydetail_su
-- --------------------------------------------------
CREATE TABLE [dbo].[categorydetail_su]
(
    [exchangesegment] VARCHAR(10) NULL,
    [category] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [name] VARCHAR(100) NULL,
    [address] VARCHAR(100) NULL,
    [city] VARCHAR(50) NULL,
    [dcat] VARCHAR(50) NULL,
    [dexc] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DealerMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[DealerMaster]
(
    [DealerNo] NUMERIC(6, 0) NOT NULL,
    [DealerCode] CHAR(12) NOT NULL,
    [DealerName] VARCHAR(255) NOT NULL,
    [DealerTypeId] TINYINT NOT NULL,
    [GLCode] NUMERIC(6, 0) NOT NULL,
    [BranchNo] NUMERIC(6, 0) NOT NULL,
    [ExchangeNo] NUMERIC(6, 0) NULL,
    [SubBrokNo] NUMERIC(6, 0) NULL,
    [MarginSlabNo] CHAR(5) NULL,
    [BrokMethodCode] TINYINT NULL,
    [BrokGrpNo] CHAR(12) NULL,
    [GroupNo] NUMERIC(6, 0) NULL,
    [FamilyNo] NUMERIC(6, 0) NULL,
    [SEBIRegnNo] VARCHAR(25) NULL,
    [AddressNo] NUMERIC(6, 0) NULL,
    [Status] CHAR(1) NULL,
    [PrevDealerCode] CHAR(12) NULL,
    [PrevDealerName] VARCHAR(255) NULL,
    [IntroducedBy] VARCHAR(50) NULL,
    [Remarks] VARCHAR(255) NULL,
    [TraderNo] NUMERIC(6, 0) NULL,
    [DPClient] CHAR(1) NULL,
    [DepoCode] VARCHAR(50) NULL,
    [DepoId] VARCHAR(25) NULL,
    [CMBPId] VARCHAR(25) NULL,
    [ClientId] VARCHAR(25) NULL,
    [PANNo] VARCHAR(50) NULL,
    [PANNo1] VARCHAR(50) NULL,
    [DocsSubmitted] VARCHAR(50) NULL,
    [ActiveDate] DATETIME NULL,
    [AliasCode] CHAR(12) NULL,
    [WebType] CHAR(1) NULL,
    [ManualEntry] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL,
    [client_segment] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail_ah
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail_ah]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL,
    [client_segment] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail_hy
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail_hy]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL,
    [client_segment] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail_in
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail_in]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL,
    [client_segment] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail_su
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail_su]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL,
    [client_segment] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mapdetail1
-- --------------------------------------------------
CREATE TABLE [dbo].[mapdetail1]
(
    [dealer] VARCHAR(40) NULL,
    [client] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception]
(
    [party_code] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.survdata
-- --------------------------------------------------
CREATE TABLE [dbo].[survdata]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] VARCHAR(255) NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL,
    [Col026] VARCHAR(255) NULL,
    [Col027] VARCHAR(255) NULL,
    [Col028] VARCHAR(255) NULL,
    [Col029] VARCHAR(255) NULL,
    [Col030] VARCHAR(255) NULL,
    [Col031] VARCHAR(255) NULL,
    [Col032] VARCHAR(255) NULL,
    [Col033] VARCHAR(255) NULL,
    [Col034] VARCHAR(255) NULL,
    [Col035] VARCHAR(255) NULL,
    [Col036] VARCHAR(255) NULL,
    [Col037] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AlertParametersInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AlertParametersInfo]
(
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nDepositAmount] INT NOT NULL,
    [nAlertOnOrOff] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AlertsInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AlertsInfo]
(
    [sGroupCode] VARCHAR(5) NOT NULL,
    [nPeriodicity] INT NULL,
    [nGrossExposureLimit1] INT NULL DEFAULT 60,
    [nGrossExposureLimit2] INT NULL DEFAULT 70,
    [nGrossExposureLimit3] INT NULL DEFAULT 80,
    [nNetExposureLimit1] INT NULL DEFAULT 60,
    [nNetExposureLimit2] INT NULL DEFAULT 70,
    [nNetExposureLimit3] INT NULL DEFAULT 80,
    [nNetSaleExposureLimit1] INT NULL DEFAULT 60,
    [nNetSaleExposureLimit2] INT NULL DEFAULT 70,
    [nNetSaleExposureLimit3] INT NULL DEFAULT 80,
    [nNetPositionLimit1] INT NULL DEFAULT 60,
    [nNetPositionLimit2] INT NULL DEFAULT 70,
    [nNetPositionLimit3] INT NULL DEFAULT 80,
    [nTurnoverLimit1] INT NULL DEFAULT 60,
    [nTurnoverLimit2] INT NULL DEFAULT 70,
    [nTurnoverLimit3] INT NULL DEFAULT 80,
    [nPendingOrdersLimit1] INT NULL DEFAULT 60,
    [nPendingOrdersLimit2] INT NULL DEFAULT 70,
    [nPendingOrdersLimit3] INT NULL DEFAULT 80,
    [nMarginLimit1] INT NULL DEFAULT 60,
    [nMarginLimit2] INT NULL DEFAULT 70,
    [nMarginLimit3] INT NULL DEFAULT 80,
    [nMTMLossLimit1] INT NULL DEFAULT 60,
    [nMTMLossLimit2] INT NULL DEFAULT 70,
    [nMTMLossLimit3] INT NULL DEFAULT 80
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditDealerMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditDealerMaster]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [sDealerCode] VARCHAR(5) NULL,
    [sGroupCode] VARCHAR(5) NULL,
    [sFamilyCode] VARCHAR(5) NULL,
    [sEMail] CHAR(40) NULL,
    [sDealerName] CHAR(40) NULL,
    [sPassWord] CHAR(8) NULL,
    [cDealerStatus] CHAR(1) NULL,
    [nTermID] INT NULL,
    [nBrokerage] INT NULL,
    [nLastLogonConnectTime] INT NULL,
    [sAddress1] CHAR(40) NULL,
    [sAddress2] CHAR(40) NULL,
    [sCity] CHAR(40) NULL,
    [sStatePin] CHAR(40) NULL,
    [sTelephoneNo] CHAR(40) NULL,
    [sFaxNo] CHAR(40) NULL,
    [cTypeOfAccess] CHAR(1) NULL,
    [nMaxConnectTime] SMALLINT NULL,
    [nDealerCategory] SMALLINT NULL,
    [nSurvOnOrOff] SMALLINT NULL,
    [sDealerId] CHAR(15) NULL,
    [sParticipantCode] CHAR(15) NULL,
    [nLastUpdateTime] INT NULL,
    [cLogonStatus] CHAR(1) NULL,
    [nNoOfLogonAttempts] SMALLINT NULL,
    [nSurvAutoOrManual] SMALLINT NULL,
    [nBankDPOnOrOff] SMALLINT NULL,
    [nExchangeSegmentId] INT NULL,
    [nClientValidationOnOrOff] SMALLINT NULL,
    [nSPANOnOrOff] SMALLINT NULL,
    [sDervParticipantCode] CHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditDealerToClientMapping
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditDealerToClientMapping]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [sDealerCode] VARCHAR(5) NULL,
    [sClientCode] VARCHAR(5) NULL,
    [nLastUpdateTime] INT NULL,
    [cStatus] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditDefaultSurveillance
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditDefaultSurveillance]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [nSurvAutoOrManual] SMALLINT NULL,
    [nGrossExposureLimit] FLOAT NULL,
    [nNetExposureLimit] FLOAT NULL,
    [nNetSaleExposureLimit] FLOAT NULL,
    [nNetPositionLimit] FLOAT NULL,
    [nTurnoverLimit] FLOAT NULL,
    [nMaxSingleTransVal] FLOAT NULL,
    [nMaxSingleTransQty] INT NULL,
    [nPendingOrdersLimit] FLOAT NULL,
    [nMTMLossLimit] FLOAT NULL,
    [nGrossExposureWarnLimit] SMALLINT NULL,
    [nNetExposureWarnLimit] SMALLINT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NULL,
    [nNetPositionWarnLimit] SMALLINT NULL,
    [nTurnoverWarnLimit] SMALLINT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NULL,
    [nMTMLossWarnLimit] SMALLINT NULL,
    [nPeriodicity] SMALLINT NULL,
    [nCurrentIM] FLOAT NULL,
    [nCurrentTradeBasedIM] FLOAT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMaxIM] FLOAT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nLedgerBalance] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL,
    [nRetainMultiplier] TINYINT NULL,
    [nIncludeMTMP] TINYINT NULL,
    [nIncludeNetPremium] TINYINT NULL,
    [nGrossOrNet] TINYINT NULL,
    [nLastUpdateTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditDefaultUserPrivileges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditDefaultUserPrivileges]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nMarketCode] SMALLINT NOT NULL,
    [nRegularLot] SMALLINT NULL,
    [nSpecialTerms] SMALLINT NULL,
    [nStopLoss] SMALLINT NULL,
    [nMarketIfTouched] SMALLINT NULL,
    [nNegotiated] SMALLINT NULL,
    [nOddLot] SMALLINT NULL,
    [nSpot] SMALLINT NULL,
    [nAuction] SMALLINT NULL,
    [nLimit] SMALLINT NULL,
    [nMarket] SMALLINT NULL,
    [nSpread] SMALLINT NULL,
    [nExcercise] SMALLINT NULL,
    [nDontExcercise] SMALLINT NULL,
    [nPositionLiquidation] SMALLINT NULL,
    [nTradeModification] SMALLINT NULL,
    [nTradeCancellation] SMALLINT NULL,
    [nBuy] SMALLINT NULL,
    [nSell] SMALLINT NULL,
    [nBuyCall] SMALLINT NULL,
    [nBuyPut] SMALLINT NULL,
    [nSellCall] SMALLINT NULL,
    [nSellPut] SMALLINT NULL,
    [nAmerican] SMALLINT NULL,
    [nEuropean] SMALLINT NULL,
    [nCover] SMALLINT NULL,
    [nUnCover] SMALLINT NULL,
    [nOpen] SMALLINT NULL,
    [nClose] SMALLINT NULL,
    [nDay] SMALLINT NULL,
    [nGTD] SMALLINT NULL,
    [nGTC] SMALLINT NULL,
    [nIOC] SMALLINT NULL,
    [nGTT] SMALLINT NULL,
    [n6A7A] SMALLINT NULL,
    [nPro] SMALLINT NULL,
    [nClient] SMALLINT NULL,
    [nParticipant] SMALLINT NULL,
    [nWHS] SMALLINT NULL,
    [nBuyBack] SMALLINT NULL,
    [nCash] SMALLINT NULL,
    [nMargin] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditSurveillanceMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditSurveillanceMaster]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nNetExposureLimit] FLOAT NOT NULL,
    [nNetSaleExposureLimit] FLOAT NOT NULL,
    [nNetPositionLimit] FLOAT NOT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nMaxSingleTransVal] FLOAT NOT NULL,
    [nMaxSingleTransQty] INT NOT NULL,
    [nPendingOrdersLimit] FLOAT NOT NULL,
    [nMTMLossLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NOT NULL,
    [nNetExposureWarnLimit] SMALLINT NOT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NOT NULL,
    [nNetPositionWarnLimit] SMALLINT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NOT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NOT NULL,
    [nMTMLossWarnLimit] SMALLINT NOT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL,
    [nRetainMultiplier] TINYINT NOT NULL,
    [nIncludeMTMP] TINYINT NOT NULL,
    [nIncludeNetPremium] TINYINT NOT NULL,
    [nGrossOrNet] TINYINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AuditUserPrivileges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AuditUserPrivileges]
(
    [dTimeStamp] DATETIME NULL,
    [sActionPerformed] CHAR(10) NULL,
    [sDealerCode] VARCHAR(5) NULL,
    [nExchangeCode] SMALLINT NULL,
    [nMarketCode] SMALLINT NULL,
    [nRegularLot] SMALLINT NULL,
    [nSpecialTerms] SMALLINT NULL,
    [nStopLoss] SMALLINT NULL,
    [nMarketIfTouched] SMALLINT NULL,
    [nNegotiated] SMALLINT NULL,
    [nOddLot] SMALLINT NULL,
    [nSpot] SMALLINT NULL,
    [nAuction] SMALLINT NULL,
    [nLimit] SMALLINT NULL,
    [nMarket] SMALLINT NULL,
    [nSpread] SMALLINT NULL,
    [nExcercise] SMALLINT NULL,
    [nDontExcercise] SMALLINT NULL,
    [nPositionLiquidation] SMALLINT NULL,
    [nTradeModification] SMALLINT NULL,
    [nTradeCancellation] SMALLINT NULL,
    [nBuy] SMALLINT NULL,
    [nSell] SMALLINT NULL,
    [nBuyCall] SMALLINT NULL,
    [nBuyPut] SMALLINT NULL,
    [nSellCall] SMALLINT NULL,
    [nSellPut] SMALLINT NULL,
    [nAmerican] SMALLINT NULL,
    [nEuropean] SMALLINT NULL,
    [nCover] SMALLINT NULL,
    [nUnCover] SMALLINT NULL,
    [nOpen] SMALLINT NULL,
    [nClose] SMALLINT NULL,
    [nDay] SMALLINT NULL,
    [nGTD] SMALLINT NULL,
    [nGTC] SMALLINT NULL,
    [nIOC] SMALLINT NULL,
    [nGTT] SMALLINT NULL,
    [n6A7A] SMALLINT NULL,
    [nPro] SMALLINT NULL,
    [nClient] SMALLINT NULL,
    [nParticipant] SMALLINT NULL,
    [nWHS] SMALLINT NULL,
    [nBuyBack] SMALLINT NULL,
    [nCash] SMALLINT NULL,
    [nMargin] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BackofficeExecutedOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BackofficeExecutedOrders]
(
    [nOrderNumber] NUMERIC(15, 0) NOT NULL,
    [nTradeNumber] NUMERIC(15, 0) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [cBuyOrSell] CHAR(1) NOT NULL,
    [nTradedQty] NUMERIC(7, 0) NOT NULL,
    [nTradedPrice] NUMERIC(7, 2) NOT NULL,
    [cBrokerageType] CHAR(1) NOT NULL,
    [nBrokerage] NUMERIC(15, 6) NOT NULL,
    [cDelOrSqroff] CHAR(1) NOT NULL,
    [sMarketType] CHAR(2) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [nTradedTime] DATETIME NOT NULL,
    [nOrderTime] DATETIME NOT NULL,
    [nTradedTime1] INT NOT NULL,
    [nOrderTime1] INT NOT NULL,
    [sRemarks] CHAR(25) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BackOfficeSurvLimits
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BackOfficeSurvLimits]
(
    [nEntryID] INT NOT NULL,
    [nOperationCode] SMALLINT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sGroupId] CHAR(15) NULL,
    [sSymbol] CHAR(10) NULL,
    [sSeries] CHAR(2) NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nGrossExposureMultiplier] SMALLINT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NULL,
    [nNetExposureMultiplier] SMALLINT NULL,
    [nNetExposureLimit] FLOAT NULL,
    [nNetExposureWarnLimit] SMALLINT NULL,
    [nNetSaleExposureMultiplier] SMALLINT NULL,
    [nNetSaleExposureLimit] FLOAT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NULL,
    [nNetPositionMultiplier] SMALLINT NULL,
    [nNetPositionLimit] FLOAT NULL,
    [nNetPositionWarnLimit] SMALLINT NULL,
    [nTurnoverMultiplier] SMALLINT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NULL,
    [nPendingOrdersMultiplier] SMALLINT NULL,
    [nPendingOrdersLimit] FLOAT NULL,
    [nPendingOrdersWarnLimits] SMALLINT NULL,
    [nMTMLossMultipler] SMALLINT NULL,
    [nMTMLossLimit] FLOAT NULL,
    [nMTMLossWarnLimits] SMALLINT NULL,
    [nMarginMultiplier] SMALLINT NULL,
    [nMarginLimit] FLOAT NULL,
    [nMarginWarnLimits] SMALLINT NULL,
    [nMaxSingleTransVal] FLOAT NULL,
    [nMaxSingleTransQty] INT NULL,
    [nRetainMultipier] SMALLINT NULL,
    [nIncludeMTMP] SMALLINT NULL,
    [nIncludeNetPremium] SMALLINT NULL,
    [nGrossOrNet] SMALLINT NULL,
    [cUpdateOrDeleted] CHAR(1) NULL,
    [nEntryTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BandHittersConfig
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BandHittersConfig]
(
    [nLowLimit] INT NOT NULL,
    [nHighLimit] INT NOT NULL,
    [nPercentAllowed] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BlockUnBlock
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BlockUnBlock]
(
    [AccessType] VARCHAR(1) NULL,
    [BeneficiaryAccountNo] INT NULL,
    [TransactionDate] DATETIME NULL,
    [ExectutionDate] DATETIME NULL,
    [ISIN] VARCHAR(12) NULL,
    [Quantity] INT NULL,
    [TransactionType] VARCHAR(5) NULL,
    [SourceOfInstruction] VARCHAR(1) NULL,
    [CallDateTime] DATETIME NULL,
    [CallStatus] VARCHAR(1) NULL,
    [CallFailureReason] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BlockUnBlockInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BlockUnBlockInfo]
(
    [sAccountCode] CHAR(10) NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [sDPClientId] NUMERIC(8, 0) NOT NULL,
    [sISINCODE] CHAR(12) NOT NULL,
    [nQuantity] INT NOT NULL,
    [sTransactionType] CHAR(2) NOT NULL,
    [nExecuteFlag] SMALLINT NULL,
    [sTimeStamp] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CE14feb03
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CE14feb03]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [sDealerGroupId] CHAR(15) NOT NULL,
    [sClientGroupId] CHAR(15) NOT NULL,
    [sSubBrokerClientId] CHAR(15) NOT NULL,
    [nDealerCategory] SMALLINT NOT NULL,
    [nDealerGroupCategory] SMALLINT NOT NULL,
    [nClientCategory] SMALLINT NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NULL,
    [nAssetToken] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nMarketPrice] INT NULL,
    [sGrossingClientId] VARCHAR(15) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CE345
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CE345]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientExposures]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [sDealerGroupId] CHAR(15) NOT NULL,
    [sClientGroupId] CHAR(15) NOT NULL,
    [sSubBrokerClientId] CHAR(15) NOT NULL,
    [nDealerCategory] SMALLINT NOT NULL,
    [nDealerGroupCategory] SMALLINT NOT NULL,
    [nClientCategory] SMALLINT NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NULL,
    [nAssetToken] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nMarketPrice] INT NULL,
    [sGrossingClientId] VARCHAR(15) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Config
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Config]
(
    [nMaxScripUpdateTime] INT NOT NULL,
    [nMaxParticipantUpdateTime] INT NOT NULL,
    [nReferenceTime] INT NOT NULL,
    [nMaxMessageUpdateTime] BINARY(8) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Control
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Control]
(
    [dDateTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyErrorLogs
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyErrorLogs]
(
    [sTimeStamp] VARCHAR(50) NULL,
    [sErrorMsg] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyExplHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyExplHistory]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyExplRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyExplRequests]
(
    [cConfirmed] CHAR(1) NOT NULL DEFAULT 'N',
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL,
    [nTransactionStatus] SMALLINT NULL,
    [sSurvErrorString] VARCHAR(128) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyExplResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyExplResponses]
(
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyExposures]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [nTradedBuyQuantity] INT NOT NULL,
    [nTradedBuyValue] FLOAT NOT NULL,
    [nTradedSellQuantity] INT NOT NULL,
    [nTradedSellValue] FLOAT NOT NULL,
    [nStrikePrice] INT NULL,
    [nAssetToken] SMALLINT NULL,
    [nExpiryDate] INT NULL,
    [sClientID] VARCHAR(16) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sSubClientId] VARCHAR(15) NOT NULL,
    [nMarketPrice] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nMTMPosition] FLOAT NULL,
    [nMTMGainOrLoss] FLOAT NULL,
    [nClientCategory] SMALLINT NULL,
    [nClientGroupCategory] SMALLINT NULL,
    [nSubClientCategory] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyExposuresActivity
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyExposuresActivity]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [nTradedBuyQuantity] INT NOT NULL,
    [nTradedBuyValue] FLOAT NOT NULL,
    [nTradedSellQuantity] INT NOT NULL,
    [nTradedSellValue] FLOAT NOT NULL,
    [nStrikePrice] INT NULL,
    [nActivityType] INT NULL DEFAULT 1,
    [nActivityTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyJcsMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyJcsMessages]
(
    [sAccountCode] CHAR(10) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nMessage1] VARBINARY(255) NULL,
    [nMessage2] VARBINARY(255) NULL,
    [nMessage3] VARBINARY(255) NULL,
    [nMessage4] VARBINARY(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyLoginLogoff
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyLoginLogoff]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nLoginLogoffTime] INT NOT NULL,
    [cLoginLogoff] CHAR(1) NOT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyOrderHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyOrderHistory]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nTransactionTime] INT NOT NULL,
    [sReasonString] VARCHAR(255) NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nInsertUpdateTime] DATETIME NULL DEFAULT (getdate()),
    [nSerialNo] INT NULL,
    [nTotalCount] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyOrderRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyOrderRequests]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [dCurrentTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyOrderResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyOrderResponses]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [dCurrentTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyPendingExpls
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyPendingExpls]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [cOrderStatus] CHAR(1) NULL DEFAULT 'P'
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyPendingOrders]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySLOrderTriggers
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySLOrderTriggers]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTriggerTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] TINYINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySpreadOrderHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySpreadOrderHistory]
(
    [cConfirmed] CHAR(1) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NOT NULL,
    [nSellTimeStamp] INT NOT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySpreadOrderRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySpreadOrderRequests]
(
    [cConfirmed] CHAR(1) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NOT NULL,
    [nSellTimeStamp] INT NOT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySpreadOrderResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySpreadOrderResponses]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NULL,
    [nSellTimeStamp] INT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySpreadPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySpreadPendingOrders]
(
    [cOrderStatus] CHAR(1) NULL,
    [nTransactionStatus] SMALLINT NULL,
    [nReplyCode] SMALLINT NULL,
    [nReplyMessageLen] SMALLINT NULL,
    [sReplyMessage] VARCHAR(40) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NULL,
    [nSellTimeStamp] INT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySurveillanceMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySurveillanceMaster]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nIncludeMTMP] TINYINT NOT NULL,
    [nIncludeNetPremium] TINYINT NOT NULL,
    [nGrossOrNet] TINYINT NOT NULL,
    [nLastUpdateTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySurvFailedOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySurvFailedOrders]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nSurvErrorCode] SMALLINT NOT NULL,
    [sSurvErrorString] VARCHAR(128) NOT NULL,
    [cActionCode] CHAR(1) NOT NULL,
    [nAcceptRejectStatus] TINYINT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailySystemMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailySystemMessages]
(
    [nMessageCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [cMarketType] CHAR(1) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sMessage1] VARCHAR(255) NOT NULL,
    [sMessage2] VARCHAR(255) NULL,
    [sMessage3] VARCHAR(255) NULL,
    [sMessage4] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyTrades]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DailyTradesRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DailyTradesRequest]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [cFAOMktType] CHAR(1) NOT NULL,
    [nFCMMktType] SMALLINT NOT NULL,
    [BuyOpenOrClose] CHAR(1) NOT NULL,
    [SellOpenClose] CHAR(1) NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [sBuyBrokerId] CHAR(5) NOT NULL,
    [sSellBrokerId] CHAR(5) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [cRequestedBy] CHAR(1) NOT NULL,
    [sBuyAccountCode] CHAR(10) NULL,
    [sSellAccountCode] CHAR(10) NULL,
    [cBuyCoverOrUncover] CHAR(1) NOT NULL,
    [cSellCoverOrUncover] CHAR(1) NOT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBuyParticipant] CHAR(12) NULL,
    [sSellParticipant] CHAR(12) NULL,
    [cConfirmed] CHAR(1) NULL,
    [cBuyGiveupFlag] CHAR(1) NULL,
    [cSellGiveUpFlag] CHAR(1) NULL,
    [nToken] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DE14feb03
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DE14feb03]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [nTradedBuyQuantity] INT NOT NULL,
    [nTradedBuyValue] FLOAT NOT NULL,
    [nTradedSellQuantity] INT NOT NULL,
    [nTradedSellValue] FLOAT NOT NULL,
    [nStrikePrice] INT NULL,
    [nAssetToken] SMALLINT NULL,
    [nExpiryDate] INT NULL,
    [sClientID] VARCHAR(16) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sSubClientId] VARCHAR(15) NOT NULL,
    [nMarketPrice] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nMTMPosition] FLOAT NULL,
    [nMTMGainOrLoss] FLOAT NULL,
    [nClientCategory] SMALLINT NULL,
    [nClientGroupCategory] SMALLINT NULL,
    [nSubClientCategory] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DE345
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DE345]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [nTradedBuyQuantity] INT NOT NULL,
    [nTradedBuyValue] FLOAT NOT NULL,
    [nTradedSellQuantity] INT NOT NULL,
    [nTradedSellValue] FLOAT NOT NULL,
    [nStrikePrice] INT NULL,
    [nAssetToken] SMALLINT NULL,
    [nExpiryDate] INT NULL,
    [sClientID] VARCHAR(16) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerInfo]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [nDPClientId] DECIMAL(8, 0) NOT NULL,
    [sDPId] VARCHAR(8) NOT NULL,
    [nCheckHoldings] SMALLINT NULL,
    [nSettOrDaily] SMALLINT NULL,
    [nMailType] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerMaster]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupCode] VARCHAR(5) NULL,
    [sFamilyCode] VARCHAR(5) NULL,
    [sEMail] CHAR(40) NULL,
    [sDealerName] CHAR(40) NOT NULL,
    [sPassWord] CHAR(8) NOT NULL,
    [cDealerStatus] CHAR(1) NOT NULL,
    [nTermID] INT NOT NULL,
    [nBrokerage] INT NULL,
    [nLastLogonConnectTime] INT NULL,
    [sAddress1] CHAR(40) NULL,
    [sAddress2] CHAR(40) NULL,
    [sCity] CHAR(40) NULL,
    [sStatePin] CHAR(40) NULL,
    [sTelephoneNo] CHAR(40) NULL,
    [sFaxNo] CHAR(40) NULL,
    [cTypeOfAccess] CHAR(1) NULL,
    [nMaxConnectTime] SMALLINT NULL,
    [nDealerCategory] SMALLINT NULL,
    [nSurvOnOrOff] SMALLINT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cLogonStatus] CHAR(1) NOT NULL,
    [nNoOfLogonAttempts] SMALLINT NOT NULL,
    [nSurvAutoOrManual] SMALLINT NOT NULL,
    [nBankDPOnOrOff] SMALLINT NOT NULL,
    [nExchangeSegmentId] INT NULL,
    [nClientValidationOnOrOff] SMALLINT NULL,
    [nSPANOnOrOff] SMALLINT NULL,
    [sDervParticipantCode] CHAR(15) NULL DEFAULT ' '
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerMaster1
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerMaster1]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupCode] VARCHAR(5) NULL,
    [sFamilyCode] VARCHAR(5) NULL,
    [sEMail] CHAR(40) NULL,
    [sDealerName] CHAR(40) NOT NULL,
    [sPassWord] CHAR(8) NOT NULL,
    [cDealerStatus] CHAR(1) NOT NULL,
    [nTermID] INT NOT NULL,
    [nBrokerage] INT NULL,
    [nLastLogonConnectTime] INT NULL,
    [sAddress1] CHAR(40) NULL,
    [sAddress2] CHAR(40) NULL,
    [sCity] CHAR(40) NULL,
    [sStatePin] CHAR(40) NULL,
    [sTelephoneNo] CHAR(40) NULL,
    [sFaxNo] CHAR(40) NULL,
    [cTypeOfAccess] CHAR(1) NULL,
    [nMaxConnectTime] SMALLINT NULL,
    [nDealerCategory] SMALLINT NULL,
    [nSurvOnOrOff] SMALLINT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cLogonStatus] CHAR(1) NOT NULL,
    [nNoOfLogonAttempts] SMALLINT NOT NULL,
    [nSurvAutoOrManual] SMALLINT NOT NULL,
    [nBankDPOnOrOff] SMALLINT NOT NULL,
    [nExchangeSegmentId] INT NULL,
    [nClientValidationOnOrOff] SMALLINT NULL,
    [nSPANOnOrOff] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerMaster2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerMaster2]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupCode] VARCHAR(5) NULL,
    [sFamilyCode] VARCHAR(5) NULL,
    [sEMail] CHAR(40) NULL,
    [sDealerName] CHAR(40) NOT NULL,
    [sPassWord] CHAR(8) NOT NULL,
    [cDealerStatus] CHAR(1) NOT NULL,
    [nTermID] INT NOT NULL,
    [nBrokerage] INT NULL,
    [nLastLogonConnectTime] INT NULL,
    [sAddress1] CHAR(40) NULL,
    [sAddress2] CHAR(40) NULL,
    [sCity] CHAR(40) NULL,
    [sStatePin] CHAR(40) NULL,
    [sTelephoneNo] CHAR(40) NULL,
    [sFaxNo] CHAR(40) NULL,
    [cTypeOfAccess] CHAR(1) NULL,
    [nMaxConnectTime] SMALLINT NULL,
    [nDealerCategory] SMALLINT NULL,
    [nSurvOnOrOff] SMALLINT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cLogonStatus] CHAR(1) NOT NULL,
    [nNoOfLogonAttempts] SMALLINT NOT NULL,
    [nSurvAutoOrManual] SMALLINT NOT NULL,
    [nBankDPOnOrOff] SMALLINT NOT NULL,
    [nExchangeSegmentId] INT NULL,
    [nClientValidationOnOrOff] SMALLINT NULL,
    [nSPANOnOrOff] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerMasterEx
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerMasterEx]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sDealerName] CHAR(40) NOT NULL,
    [sPassWord] CHAR(8) NOT NULL,
    [cDealerStatus] CHAR(1) NOT NULL,
    [nTermID] INT NOT NULL,
    [nBrokerage] INT NULL,
    [nLastLogonConnectTime] INT NULL,
    [sAddress1] CHAR(40) NULL,
    [sAddress2] CHAR(40) NULL,
    [sCity] CHAR(40) NULL,
    [sStatePin] CHAR(40) NULL,
    [sTelephoneNo] CHAR(40) NULL,
    [sFaxNo] CHAR(40) NULL,
    [cTypeOfAccess] CHAR(1) NOT NULL,
    [nMaxConnectTime] SMALLINT NULL,
    [nDealerCategory] SMALLINT NOT NULL,
    [nSurvOnOrOff] SMALLINT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [nLastUpdateTimeEx] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DealerToClientMapping
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DealerToClientMapping]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [nLastUpdateTime] INT NULL DEFAULT (datediff(second,'1-1-1970',getdate())),
    [cStatus] CHAR(1) NULL DEFAULT 'A'
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DEF_SM_VER_345
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DEF_SM_VER_345]
(
    [nSurvAutoOrManual] SMALLINT NOT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nNetExposureLimit] FLOAT NOT NULL,
    [nNetSaleExposureLimit] FLOAT NOT NULL,
    [nNetPositionLimit] FLOAT NOT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nMaxSingleTransVal] FLOAT NOT NULL,
    [nMaxSingleTransQty] INT NOT NULL,
    [nPendingOrdersLimit] FLOAT NOT NULL,
    [nMTMLossLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NOT NULL,
    [nNetExposureWarnLimit] SMALLINT NOT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NOT NULL,
    [nNetPositionWarnLimit] SMALLINT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NOT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NOT NULL,
    [nMTMLossWarnLimit] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nCurrentIM] FLOAT NULL,
    [nCurrentTradeBasedIM] FLOAT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMaxIM] FLOAT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nLedgerBalance] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DefaultMarginMultipliers
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DefaultMarginMultipliers]
(
    [nPeriodicity] SMALLINT NULL,
    [nCashGrossExposure] INT NULL,
    [nSecurityGrossExposure] INT NULL,
    [nCashNetExposure] INT NULL,
    [nSecurityNetExposure] INT NULL,
    [nCashNetSaleExposure] INT NULL,
    [nSecurityNetSaleExposure] INT NULL,
    [nCashNetPosition] INT NULL,
    [nSecurityNetPosition] INT NULL,
    [nCashTurnover] INT NULL,
    [nSecurityTurnOver] INT NULL,
    [nCashPendingOrders] INT NULL,
    [nSecurityPendingOrders] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DefaultScripBasket
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DefaultScripBasket]
(
    [nToken] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DefaultSurveillance
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DefaultSurveillance]
(
    [nSurvAutoOrManual] SMALLINT NOT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nNetExposureLimit] FLOAT NOT NULL,
    [nNetSaleExposureLimit] FLOAT NOT NULL,
    [nNetPositionLimit] FLOAT NOT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nMaxSingleTransVal] FLOAT NOT NULL,
    [nMaxSingleTransQty] INT NOT NULL,
    [nPendingOrdersLimit] FLOAT NOT NULL,
    [nMTMLossLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NOT NULL,
    [nNetExposureWarnLimit] SMALLINT NOT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NOT NULL,
    [nNetPositionWarnLimit] SMALLINT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NOT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NOT NULL,
    [nMTMLossWarnLimit] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nCurrentIM] FLOAT NULL,
    [nCurrentTradeBasedIM] FLOAT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMaxIM] FLOAT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nLedgerBalance] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL,
    [nRetainMultiplier] TINYINT NOT NULL DEFAULT 0,
    [nIncludeMTMP] TINYINT NOT NULL DEFAULT 0,
    [nIncludeNetPremium] TINYINT NOT NULL DEFAULT 0,
    [nGrossOrNet] TINYINT NOT NULL DEFAULT 0,
    [nLastUpdateTime] DATETIME NOT NULL DEFAULT (convert(datetime,getdate()))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DefaultUserPrivileges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DefaultUserPrivileges]
(
    [sDealerCode] CHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nMarketCode] SMALLINT NOT NULL,
    [nRegularLot] SMALLINT NULL DEFAULT 1,
    [nSpecialTerms] SMALLINT NULL DEFAULT 1,
    [nStopLoss] SMALLINT NULL DEFAULT 1,
    [nMarketIfTouched] SMALLINT NULL DEFAULT 1,
    [nNegotiated] SMALLINT NULL DEFAULT 1,
    [nOddLot] SMALLINT NULL DEFAULT 1,
    [nSpot] SMALLINT NULL DEFAULT 1,
    [nAuction] SMALLINT NULL DEFAULT 1,
    [nLimit] SMALLINT NULL DEFAULT 1,
    [nMarket] SMALLINT NULL DEFAULT 1,
    [nSpread] SMALLINT NULL DEFAULT 1,
    [nExcercise] SMALLINT NULL DEFAULT 1,
    [nDontExcercise] SMALLINT NULL DEFAULT 1,
    [nPositionLiquidation] SMALLINT NULL DEFAULT 1,
    [nTradeModification] SMALLINT NULL DEFAULT 0,
    [nTradeCancellation] SMALLINT NULL DEFAULT 0,
    [nBuy] SMALLINT NULL DEFAULT 1,
    [nSell] SMALLINT NULL DEFAULT 1,
    [nBuyCall] SMALLINT NULL DEFAULT 1,
    [nBuyPut] SMALLINT NULL DEFAULT 1,
    [nSellCall] SMALLINT NULL DEFAULT 1,
    [nSellPut] SMALLINT NULL DEFAULT 1,
    [nAmerican] SMALLINT NULL DEFAULT 1,
    [nEuropean] SMALLINT NULL DEFAULT 1,
    [nCover] SMALLINT NULL DEFAULT 1,
    [nUnCover] SMALLINT NULL DEFAULT 1,
    [nOpen] SMALLINT NULL DEFAULT 1,
    [nClose] SMALLINT NULL DEFAULT 1,
    [nDay] SMALLINT NULL DEFAULT 1,
    [nGTD] SMALLINT NULL DEFAULT 1,
    [nGTC] SMALLINT NULL DEFAULT 1,
    [nIOC] SMALLINT NULL DEFAULT 1,
    [nGTT] SMALLINT NULL DEFAULT 1,
    [n6A7A] SMALLINT NULL DEFAULT 1,
    [nPro] SMALLINT NULL DEFAULT 1,
    [nClient] SMALLINT NULL DEFAULT 1,
    [nParticipant] SMALLINT NULL DEFAULT 1,
    [nWHS] SMALLINT NULL DEFAULT 1,
    [nBuyBack] SMALLINT NULL DEFAULT 1,
    [nCash] SMALLINT NULL DEFAULT 1,
    [nMargin] SMALLINT NULL DEFAULT 1
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_DepositInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_DepositInfo]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nLedgerBalance] FLOAT NOT NULL,
    [nSecuritiesBalance] FLOAT NOT NULL,
    [nMarginAmount] FLOAT NOT NULL,
    [nDepositOnOff] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ExplClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ExplClientExposures]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ExPlFileUploadData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ExPlFileUploadData]
(
    [dPositionDate] DATETIME NULL,
    [sSegmentIndicator] CHAR(10) NULL,
    [sSettlementType] CHAR(10) NULL,
    [sClearingMemberCode] CHAR(10) NULL,
    [sMemberType] CHAR(10) NULL,
    [sTradingMemberCode] CHAR(10) NULL,
    [sAccountType] CHAR(10) NULL,
    [sClientAccountCode] CHAR(10) NULL,
    [sInstrumentType] CHAR(10) NULL,
    [sSymbol] CHAR(10) NULL,
    [sExpiryDate] DATETIME NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(5) NULL,
    [nBroughtForwardLongQty] INT NULL,
    [nBroughtForwardLongVal] INT NULL,
    [nBroughtForwardShortQty] INT NULL,
    [nBroughtForwardShortVal] INT NULL,
    [nDayBuyOpenQty] INT NULL,
    [nDayBuyOpenVal] INT NULL,
    [nDaySellOpenQty] INT NULL,
    [nDaySellOpenVal] INT NULL,
    [nPreExAsgmntLongQty] INT NULL,
    [nPreExAsgmntLongVal] INT NULL,
    [nPreExAsgmntShortQty] INT NULL,
    [nPreExAsgmntShortVal] INT NULL,
    [nExcercisedQty] INT NULL,
    [nAssignedQuantity] INT NULL,
    [nPostExAsgmntLongQty] INT NULL,
    [nPostExAsgmntLongVal] INT NULL,
    [nPostExAsgmntShortQty] INT NULL,
    [nPostExAsgmntShortVal] INT NULL,
    [nSettlementPrice] INT NULL,
    [nNetPremium] INT NULL,
    [nDailyMTMSettlementVal] INT NULL,
    [nFuturesFinalSettlement] INT NULL,
    [nExcercisedAssignmentVal] INT NULL,
    [sDealerId] VARCHAR(15) NULL,
    [bValidClient] SMALLINT NULL DEFAULT ((-1))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ExplUpload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ExplUpload]
(
    [sDate] DATETIME NOT NULL,
    [sDescriprition] VARCHAR(255) NOT NULL,
    [cSegmentIndicator] CHAR(1) NOT NULL,
    [cSettlementType] CHAR(1) NOT NULL,
    [sClearingMemberCode] VARCHAR(255) NOT NULL,
    [cMemberType] CHAR(1) NOT NULL,
    [cBrokerId] VARCHAR(5) NOT NULL,
    [cAccountType] CHAR(1) NOT NULL,
    [sClientAccountCode] CHAR(10) NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] DATETIME NOT NULL,
    [nStrikePrice] FLOAT NOT NULL,
    [sOptionType] VARCHAR(255) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nPreExLongQty] INT NOT NULL,
    [nPreExShortQty] INT NOT NULL,
    [nExQty] INT NOT NULL,
    [nAssignedQty] INT NOT NULL,
    [nPostExLongQty] INT NOT NULL,
    [nPostExShortQty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FeedUpdateLog
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FeedUpdateLog]
(
    [nUpdateTime] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FileExPlClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FileExPlClientExposures]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FinalExPlClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FinalExPlClientExposures]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FinalExPlControl
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FinalExPlControl]
(
    [dDateTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_HistoricEOD
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_HistoricEOD]
(
    [nToken] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nDate] INT NULL,
    [nOpen] INT NULL,
    [nHi] INT NULL,
    [nLow] INT NULL,
    [nVolume] INT NULL,
    [nClose] INT NULL,
    [sData] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IDPO
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IDPO]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nFundsPayInDate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IDT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IDT]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nFundsPayInDate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IndexTickInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IndexTickInfo]
(
    [nSystemTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IndicesInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IndicesInfo]
(
    [nIndexValue] INT NOT NULL,
    [nPrevIndexValue] INT NOT NULL,
    [nLastBroadcastTime] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_InitDBConfig
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_InitDBConfig]
(
    [sConfigType] VARCHAR(15) NULL,
    [nData] INT NULL,
    [sDescription] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntegratedDailyPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntegratedDailyPendingOrders]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nFundsPayInDate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_IntegratedDailyTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_IntegratedDailyTrades]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nFundsPayInDate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_InternalChatMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_InternalChatMessages]
(
    [nMsgCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nActionCode] SMALLINT NOT NULL,
    [nUserNo] SMALLINT NOT NULL,
    [sUserList] TEXT NOT NULL,
    [sSubject] VARCHAR(50) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sMessage] TEXT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LatestBhavCopy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LatestBhavCopy]
(
    [nToken] SMALLINT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [nLastTradedPrice] INT NOT NULL,
    [nLastUpdateTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogAuditDat
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogAuditDat]
(
    [dDateTime] DATETIME NULL,
    [sDatFileName] VARCHAR(20) NULL,
    [sVersionNo] VARCHAR(10) NULL,
    [sSubject] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogBOSurvLimits
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogBOSurvLimits]
(
    [nEntryID] INT NULL,
    [nOperationCode] SMALLINT NULL,
    [sDealerId] CHAR(15) NULL,
    [sGroupId] CHAR(15) NULL,
    [sSymbol] CHAR(10) NULL,
    [sSeries] CHAR(2) NULL,
    [nPeriodicity] SMALLINT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nGrossExposureMultiplier] SMALLINT NULL,
    [nGrossExposureLimit] FLOAT NULL,
    [nGrossExposureWarnLimit] SMALLINT NULL,
    [nNetExposureMultiplier] SMALLINT NULL,
    [nNetExposureLimit] FLOAT NULL,
    [nNetExposureWarnLimit] SMALLINT NULL,
    [nNetSaleExposureMultiplier] SMALLINT NULL,
    [nNetSaleExposureLimit] FLOAT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NULL,
    [nNetPositionMultiplier] SMALLINT NULL,
    [nNetPositionLimit] FLOAT NULL,
    [nNetPositionWarnLimit] SMALLINT NULL,
    [nTurnoverMultiplier] SMALLINT NULL,
    [nTurnoverLimit] FLOAT NULL,
    [nTurnoverWarnLimit] SMALLINT NULL,
    [nPendingOrdersMultiplier] SMALLINT NULL,
    [nPendingOrdersLimit] FLOAT NULL,
    [nPendingOrdersWarnLimits] SMALLINT NULL,
    [nMTMLossMultipler] SMALLINT NULL,
    [nMTMLossLimit] FLOAT NULL,
    [nMTMLossWarnLimits] SMALLINT NULL,
    [nMarginMultiplier] SMALLINT NULL,
    [nMarginLimit] FLOAT NULL,
    [nMarginWarnLimits] SMALLINT NULL,
    [nMaxSingleTransVal] FLOAT NULL,
    [nMaxSingleTransQty] INT NULL,
    [nRetainMultipier] SMALLINT NULL,
    [nIncludeMTMP] SMALLINT NULL,
    [nIncludeNetPremium] SMALLINT NULL,
    [nGrossOrNet] SMALLINT NULL,
    [cUpdateOrDeleted] CHAR(1) NULL,
    [nEntryTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogExplHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogExplHistory]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogExplRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogExplRequests]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL,
    [nTransactionStatus] SMALLINT NULL,
    [sSurvErrorString] VARCHAR(128) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogExplResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogExplResponses]
(
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogJcsMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogJcsMessages]
(
    [sAccountCode] CHAR(10) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nMessage1] VARBINARY(255) NULL,
    [nMessage2] VARBINARY(255) NULL,
    [nMessage3] VARBINARY(255) NULL,
    [nMessage4] VARBINARY(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogLoginLogoff
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogLoginLogoff]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nLoginLogoffTime] INT NOT NULL,
    [cLoginLogoff] CHAR(1) NOT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogManualExplClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogManualExplClientExposures]
(
    [nCaseId] INT NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupId] VARCHAR(15) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sClientId] VARCHAR(15) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sClientGroupId] VARCHAR(15) NOT NULL,
    [sClientGroupCode] VARCHAR(5) NOT NULL,
    [nDealerCategory] INT NOT NULL,
    [nDealerGroupCategory] INT NOT NULL,
    [nClientCategory] INT NOT NULL,
    [nClientGroupCategory] INT NOT NULL,
    [nCurrentNetQuantity] INT NULL,
    [nCurrentNetValue] FLOAT NULL,
    [nBuyQuantity] INT NULL,
    [nBuyValue] FLOAT NULL,
    [nSellQuantity] INT NULL,
    [nSellValue] FLOAT NULL,
    [nManualNetQuantity] INT NULL,
    [nManualNetValue] FLOAT NULL,
    [nNewNetQuantity] INT NULL,
    [nNewNetValue] FLOAT NULL,
    [nApproved] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] FLOAT NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nCALevel] INT NULL,
    [nTransactionStatus] INT NULL,
    [nToken] INT NOT NULL,
    [sGrossingClientId] VARCHAR(15) NULL,
    [dLogDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogManualPositionEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogManualPositionEntry]
(
    [sEnteredBy] VARCHAR(15) NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupId] VARCHAR(15) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sClientId] VARCHAR(15) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sClientGroupId] VARCHAR(15) NOT NULL,
    [sClientGroupCode] VARCHAR(5) NOT NULL,
    [nDealerCategory] INT NOT NULL,
    [nDealerGroupCategory] INT NOT NULL,
    [nClientCategory] INT NOT NULL,
    [nClientGroupCategory] INT NOT NULL,
    [nCurrentNetQuantity] INT NULL,
    [nCurrentNetValue] FLOAT NULL,
    [nBuyQuantity] INT NULL,
    [nBuyValue] FLOAT NULL,
    [nSellQuantity] INT NULL,
    [nSellValue] FLOAT NULL,
    [nManualNetQuantity] INT NULL,
    [nManualNetValue] FLOAT NULL,
    [nNewNetQuantity] INT NULL,
    [nNewNetValue] FLOAT NULL,
    [nApproved] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] FLOAT NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nCALevel] INT NULL,
    [nTransactionStatus] INT NULL,
    [nToken] INT NOT NULL,
    [dLogDate] DATETIME NULL,
    [sGrossingClientId] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogOrderHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogOrderHistory]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nTransactionTime] INT NOT NULL,
    [sReasonString] VARCHAR(255) NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sParticipantCode] CHAR(15) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogOrderRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogOrderRequests]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [dCurrentTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogOrderResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogOrderResponses]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [dCurrentTime] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogPendingExpls
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogPendingExpls]
(
    [cConfirmed] CHAR(1) NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nTokenNumber] SMALLINT NOT NULL,
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] SMALLINT NOT NULL,
    [nExplFlag] SMALLINT NOT NULL,
    [nExplNumber] FLOAT NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [nExType] SMALLINT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [sRemarks] CHAR(30) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [nMarketSegmentID] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [cOrderStatus] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogPendingOrders]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogScripMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogScripMaster]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nInstrumentType] SMALLINT NOT NULL,
    [nPermittedToTrade] TINYINT NOT NULL,
    [nIssuedCapital] FLOAT NOT NULL,
    [nWarningPercent] INT NOT NULL,
    [nFreezePercent] INT NOT NULL,
    [sCreditRating] CHAR(12) NOT NULL,
    [nNormal_MarketAllowed] TINYINT NOT NULL,
    [nNormal_SecurityStatus] TINYINT NOT NULL,
    [nOddLot_MarketAllowed] TINYINT NOT NULL,
    [nOddLot_SecurityStatus] TINYINT NOT NULL,
    [nSpot_MarketAllowed] TINYINT NOT NULL,
    [nSpot_SecurityStatus] TINYINT NOT NULL,
    [nAuction_MarketAllowed] TINYINT NOT NULL,
    [nAuction_SecurityStatus] TINYINT NOT NULL,
    [nIssueRate] SMALLINT NOT NULL,
    [nIssueStartDate] INT NOT NULL,
    [nIssuePDate] INT NOT NULL,
    [nIssueMaturityDate] INT NOT NULL,
    [nRegularLot] INT NOT NULL,
    [nPriceTick] INT NOT NULL,
    [sSecurityDesc] CHAR(25) NOT NULL,
    [nListingDate] INT NOT NULL,
    [nExpulsionDate] INT NOT NULL,
    [nReadmissionDate] INT NOT NULL,
    [nRecordDate] INT NOT NULL,
    [nExDate] INT NOT NULL,
    [nNoDeliveryStartDate] INT NOT NULL,
    [nNoDeliveryEndDate] INT NOT NULL,
    [nAONAllowed] TINYINT NOT NULL,
    [nMFAllowed] TINYINT NOT NULL,
    [nIndexParticipant] SMALLINT NOT NULL,
    [nBookClosureStartDate] INT NOT NULL,
    [nBookClosureEndDate] INT NOT NULL,
    [nEGM] TINYINT NOT NULL,
    [nAGM] TINYINT NOT NULL,
    [nInterest] TINYINT NOT NULL,
    [nBonus] TINYINT NOT NULL,
    [nRights] TINYINT NOT NULL,
    [nDividend] TINYINT NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cDeleteFlag] CHAR(1) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMarginPercentage] INT NULL,
    [nMinimumLot] INT NULL,
    [nLowPriceRange] INT NULL,
    [nHighPriceRange] INT NULL,
    [nExerciseStartDate] INT NULL,
    [nExerciseEndDate] INT NULL,
    [nOldToken] SMALLINT NULL,
    [sAssetInstrument] CHAR(6) NULL,
    [sAssetName] CHAR(10) NULL,
    [nAssetToken] SMALLINT NULL,
    [nIntrinsicValue] INT NULL,
    [nExtrinsicValue] INT NULL,
    [nIsAsset] TINYINT NULL,
    [nPlAllowed] TINYINT NULL,
    [nExRejectionAllowed] TINYINT NULL,
    [nExAllowed] TINYINT NULL,
    [nExcerciseStyle] TINYINT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSendMail
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSendMail]
(
    [nMailNo] INT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sTo] VARCHAR(255) NOT NULL,
    [sCc] VARCHAR(255) NULL,
    [sFrom] VARCHAR(255) NOT NULL,
    [sSubject] VARCHAR(255) NOT NULL,
    [sMessage] VARCHAR(255) NOT NULL,
    [cMailSent] CHAR(1) NOT NULL,
    [cMailType] CHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSLOrderTriggers
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSLOrderTriggers]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTriggerTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] TINYINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSpreadOrderHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSpreadOrderHistory]
(
    [cConfirmed] CHAR(1) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NOT NULL,
    [nSellTimeStamp] INT NOT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSpreadOrderRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSpreadOrderRequests]
(
    [cConfirmed] CHAR(1) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NOT NULL,
    [nSellTimeStamp] INT NOT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSpreadOrderResponses
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSpreadOrderResponses]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NOT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NULL,
    [nSellTimeStamp] INT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSpreadPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSpreadPendingOrders]
(
    [cOrderStatus] CHAR(1) NULL,
    [nTransactionStatus] SMALLINT NULL,
    [nReplyCode] SMALLINT NULL,
    [nReplyMessageLen] SMALLINT NULL,
    [sReplyMessage] VARCHAR(40) NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [cBuyAlphaChar] CHAR(2) NOT NULL,
    [cSellAlphaChar] CHAR(2) NOT NULL,
    [nBuyToken] SMALLINT NOT NULL,
    [nSellToken] SMALLINT NOT NULL,
    [nQuantity] INT NOT NULL,
    [nRemainingQuantity] INT NULL,
    [nBuyPrice] INT NOT NULL,
    [nSellPrice] INT NOT NULL,
    [cBuyAccountcode] CHAR(10) NOT NULL,
    [cSellAccountcode] CHAR(10) NOT NULL,
    [nAONIOC] SMALLINT NOT NULL,
    [nBuyBookType] SMALLINT NOT NULL,
    [nSellBookType] SMALLINT NOT NULL,
    [nBuyOrderType] SMALLINT NOT NULL,
    [nSellOrderType] SMALLINT NOT NULL,
    [nOrder1BuySell] SMALLINT NOT NULL,
    [nOrder2BuySell] SMALLINT NOT NULL,
    [nBranchId] SMALLINT NOT NULL,
    [cBuyRemarks] CHAR(25) NOT NULL,
    [cSellRemarks] CHAR(25) NOT NULL,
    [nProClient] SMALLINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [cBuyInstrumentName] CHAR(6) NOT NULL,
    [cSellInstrumentName] CHAR(6) NOT NULL,
    [cBuySymbol] CHAR(10) NOT NULL,
    [cSellSymbol] CHAR(10) NOT NULL,
    [cBuySeries] CHAR(2) NOT NULL,
    [cSellSeries] CHAR(2) NOT NULL,
    [nBuyExpiryDate] INT NOT NULL,
    [nSellExpiryDate] INT NOT NULL,
    [nBuyCALevel] SMALLINT NOT NULL,
    [nSellCALevel] SMALLINT NOT NULL,
    [nBuyStrikePrice] INT NOT NULL,
    [nSellStrikePrice] INT NOT NULL,
    [cBuyOptionType] CHAR(2) NOT NULL,
    [cSellOptionType] CHAR(2) NOT NULL,
    [cBuyOpenClose] CHAR(1) NOT NULL,
    [cSellOpenClose] CHAR(1) NOT NULL,
    [cBuyCoverUncover] CHAR(1) NOT NULL,
    [cSellCoverUncover] CHAR(1) NOT NULL,
    [cBuyParticipant] CHAR(12) NOT NULL,
    [cSellParticipant] CHAR(12) NOT NULL,
    [nBuyEntryDateTime] INT NOT NULL,
    [nSellEntryDateTime] INT NOT NULL,
    [nBuyTimeStamp] INT NULL,
    [nSellTimeStamp] INT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [sDealerCode] CHAR(5) NOT NULL,
    [nBuyErrorCode] SMALLINT NOT NULL,
    [nSellErrorCode] SMALLINT NOT NULL,
    [nUserId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSurvFailedOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSurvFailedOrders]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nSurvErrorCode] SMALLINT NOT NULL,
    [sSurvErrorString] VARCHAR(128) NOT NULL,
    [cActionCode] CHAR(1) NOT NULL,
    [nAcceptRejectStatus] TINYINT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogSystemMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogSystemMessages]
(
    [nMessageCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [cMarketType] CHAR(1) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sMessage1] VARCHAR(255) NOT NULL,
    [sMessage2] VARCHAR(255) NULL,
    [sMessage3] VARCHAR(255) NULL,
    [sMessage4] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Logtemp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Logtemp]
(
    [sEnteredBy] VARCHAR(15) NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupId] VARCHAR(15) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sClientId] VARCHAR(15) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sClientGroupId] VARCHAR(15) NOT NULL,
    [sClientGroupCode] VARCHAR(5) NOT NULL,
    [nDealerCategory] INT NOT NULL,
    [nDealerGroupCategory] INT NOT NULL,
    [nClientCategory] INT NOT NULL,
    [nClientGroupCategory] INT NOT NULL,
    [nCurrentNetQuantity] INT NULL,
    [nCurrentNetValue] FLOAT NULL,
    [nBuyQuantity] INT NULL,
    [nBuyValue] FLOAT NULL,
    [nSellQuantity] INT NULL,
    [nSellValue] FLOAT NULL,
    [nManualNetQuantity] INT NULL,
    [nManualNetValue] FLOAT NULL,
    [nNewNetQuantity] INT NULL,
    [nNewNetValue] FLOAT NULL,
    [nApproved] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] FLOAT NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nCALevel] INT NULL,
    [nTransactionStatus] INT NULL,
    [nToken] INT NOT NULL,
    [dLogDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTradeModifyError
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTradeModifyError]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nFundsPayInDate] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTrades]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LogTradesRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LogTradesRequest]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [cFAOMktType] CHAR(1) NOT NULL,
    [nFCMMktType] SMALLINT NOT NULL,
    [BuyOpenOrClose] CHAR(1) NOT NULL,
    [SellOpenClose] CHAR(1) NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [sBuyBrokerId] CHAR(5) NOT NULL,
    [sSellBrokerId] CHAR(5) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [cRequestedBy] CHAR(1) NOT NULL,
    [sBuyAccountCode] CHAR(10) NULL,
    [sSellAccountCode] CHAR(10) NULL,
    [cBuyCoverOrUncover] CHAR(1) NOT NULL,
    [cSellCoverOrUncover] CHAR(1) NOT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [sBuyParticipant] CHAR(12) NULL,
    [sSellParticipant] CHAR(12) NULL,
    [cConfirmed] CHAR(1) NULL,
    [cBuyGiveupFlag] CHAR(1) NULL,
    [cSellGiveUpFlag] CHAR(1) NULL,
    [nToken] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ManualExplClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ManualExplClientExposures]
(
    [nCaseId] INT NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupId] VARCHAR(15) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sClientId] VARCHAR(15) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sClientGroupId] VARCHAR(15) NOT NULL,
    [sClientGroupCode] VARCHAR(5) NOT NULL,
    [nDealerCategory] INT NOT NULL,
    [nDealerGroupCategory] INT NOT NULL,
    [nClientCategory] INT NOT NULL,
    [nClientGroupCategory] INT NOT NULL,
    [nCurrentNetQuantity] INT NULL,
    [nCurrentNetValue] FLOAT NULL,
    [nBuyQuantity] INT NULL,
    [nBuyValue] FLOAT NULL,
    [nSellQuantity] INT NULL,
    [nSellValue] FLOAT NULL,
    [nManualNetQuantity] INT NULL,
    [nManualNetValue] FLOAT NULL,
    [nNewNetQuantity] INT NULL,
    [nNewNetValue] FLOAT NULL,
    [nApproved] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] FLOAT NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nCALevel] INT NULL,
    [nTransactionStatus] INT NULL,
    [nToken] INT NOT NULL,
    [sGrossingClientId] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ManualExplDisplay
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ManualExplDisplay]
(
    [nCaseId] INT NOT NULL,
    [sDealerId] CHAR(15) NULL,
    [sClientId] CHAR(15) NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL,
    [nSerialNo] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ManualPositionEntry
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ManualPositionEntry]
(
    [sEnteredBy] VARCHAR(15) NULL,
    [sDealerId] VARCHAR(15) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sGroupId] VARCHAR(15) NOT NULL,
    [sGroupCode] VARCHAR(5) NOT NULL,
    [sClientId] VARCHAR(15) NOT NULL,
    [sClientCode] VARCHAR(5) NOT NULL,
    [sClientGroupId] VARCHAR(15) NOT NULL,
    [sClientGroupCode] VARCHAR(5) NOT NULL,
    [nDealerCategory] INT NOT NULL,
    [nDealerGroupCategory] INT NOT NULL,
    [nClientCategory] INT NOT NULL,
    [nClientGroupCategory] INT NOT NULL,
    [nCurrentNetQuantity] INT NULL,
    [nCurrentNetValue] FLOAT NULL,
    [nBuyQuantity] INT NULL,
    [nBuyValue] FLOAT NULL,
    [nSellQuantity] INT NULL,
    [nSellValue] FLOAT NULL,
    [nManualNetQuantity] INT NULL,
    [nManualNetValue] FLOAT NULL,
    [nNewNetQuantity] INT NULL,
    [nNewNetValue] FLOAT NULL,
    [nApproved] INT NULL,
    [sInstrumentName] VARCHAR(6) NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] FLOAT NULL,
    [sOptionType] VARCHAR(2) NULL,
    [nCALevel] INT NULL,
    [nTransactionStatus] INT NULL,
    [nToken] INT NOT NULL,
    [sGrossingClientId] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MapSubbroker
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MapSubbroker]
(
    [sSubBrokerCode] VARCHAR(5) NOT NULL,
    [sMappedSubBrokerCode] VARCHAR(5) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarginMultipliers
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarginMultipliers]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nCashGrossExposure] INT NULL,
    [nSecurityGrossExposure] INT NULL,
    [nCashNetExposure] INT NULL,
    [nSecurityNetExposure] INT NULL,
    [nCashNetSaleExposure] INT NULL,
    [nSecurityNetSaleExposure] INT NULL,
    [nCashNetPosition] INT NULL,
    [nSecurityNetPosition] INT NULL,
    [nCashTurnover] INT NULL,
    [nSecurityTurnOver] INT NULL,
    [nCashPendingOrders] INT NULL,
    [nSecurityPendingOrders] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketMovementInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketMovementInfo]
(
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSystemTime] DATETIME NOT NULL,
    [nTotalQtyTraded] INT NOT NULL,
    [nTotalValueTraded] FLOAT NOT NULL,
    [nOpenPrice] INT NOT NULL,
    [nClosePrice] INT NOT NULL,
    [nHighPrice] INT NOT NULL,
    [nLowPrice] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketMovementInfo1
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketMovementInfo1]
(
    [nSystemTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MarketStatistics
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MarketStatistics]
(
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nMarketType] SMALLINT NOT NULL,
    [nOpenPrice] INT NOT NULL,
    [nHighPrice] INT NOT NULL,
    [nLowPrice] INT NOT NULL,
    [nClosingPrice] INT NOT NULL,
    [nTotalQtyTraded] INT NOT NULL,
    [nTotalValueTraded] FLOAT NOT NULL,
    [nPreviousClosePrice] INT NOT NULL,
    [nFiftyTwoWeekHigh] INT NULL,
    [nFiftyTwoWeekLow] INT NULL,
    [sCorporateActionIndicator] CHAR(4) NOT NULL,
    [nOpenInterest] INT NULL,
    [nChangeInOpenInterest] INT NULL,
    [sIntstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL,
    [nLastUpdateTime] DATETIME NULL DEFAULT (convert(datetime,getdate()))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Masking
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Masking]
(
    [nMarketSegmentId] SMALLINT NOT NULL DEFAULT 13,
    [chEnableTermIDMasking] CHAR(1) NULL DEFAULT 'N',
    [chEnableClientMasking] CHAR(1) NULL DEFAULT 'N',
    [nTimeStamp] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MaskingAudit
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MaskingAudit]
(
    [nMarketSegmentId] SMALLINT NULL,
    [chEnableTermIDMasking] CHAR(1) NULL,
    [chEnableClientMasking] CHAR(1) NULL,
    [nTimeStamp] DATETIME NULL DEFAULT (getdate()),
    [cDeleteFlag] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MPFX
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MPFX]
(
    [Col1] VARBINARY(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEErrorMessages
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEErrorMessages]
(
    [nErrorCode] SMALLINT NULL,
    [nMessage1] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ODINConfig
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ODINConfig]
(
    [nSystemCode] SMALLINT NOT NULL,
    [sSystemParam] VARCHAR(255) NOT NULL,
    [sParamValue] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_OnlineBackupOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_OnlineBackupOrders]
(
    [nOrderNo] FLOAT NULL,
    [nOrderStatus] INT NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [sSecurityName] VARCHAR(25) NULL,
    [sInstrumentType] INT NULL,
    [nBookType] INT NULL,
    [nMarketType] INT NULL,
    [nUserId] INT NULL,
    [nBranchId] INT NULL,
    [nBuySellIndicator] INT NULL,
    [nDQ] INT NULL,
    [nDQRemaining] INT NULL,
    [nQtyRemaining] INT NULL,
    [nOrderQty] INT NULL,
    [nMFQty] INT NULL,
    [nAONIndicator] INT NULL,
    [nQuantityTraded] INT NULL,
    [nPrice] FLOAT NULL,
    [sTMId] VARCHAR(5) NULL,
    [nOrderType] INT NULL,
    [nGTD] VARCHAR(30) NULL,
    [nOrderDuration] INT NULL,
    [nPROCLIWHS] INT NULL,
    [sClientID] VARCHAR(10) NULL,
    [sParticipantCode] VARCHAR(12) NULL,
    [cAuctionPartType] CHAR(1) NULL,
    [nAuctionNo] INT NULL,
    [nSettPeriod] INT NULL,
    [dtOrderModified] VARCHAR(30) NULL,
    [sCreditRating] VARCHAR(12) NULL,
    [sRemarks] VARCHAR(12) NULL,
    [sOrderEntryDt] VARCHAR(30) NULL,
    [sCPId] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_OnlineBackupTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_OnlineBackupTrades]
(
    [nTradeNo] INT NULL,
    [nTradeStatus] INT NULL,
    [sSymbol] VARCHAR(10) NULL,
    [sSeries] VARCHAR(2) NULL,
    [sSecurityName] VARCHAR(25) NULL,
    [nInstrumentType] INT NULL,
    [nBookType] INT NULL,
    [nMarketType] INT NULL,
    [nUserId] INT NULL,
    [nBranchId] INT NULL,
    [cBuySell] VARCHAR(1) NULL,
    [nTradeQty] INT NULL,
    [nTradePrice] FLOAT NULL,
    [nPROCLI] INT NULL,
    [sClientID] VARCHAR(10) NULL,
    [sParticipantCode] VARCHAR(12) NULL,
    [cAuctionPartType] VARCHAR(1) NULL,
    [nAuctionNo] INT NULL,
    [nSettPeriod] INT NULL,
    [sTradeEntryDt] VARCHAR(30) NULL,
    [sTradeModified] VARCHAR(30) NULL,
    [nOrderNumber] FLOAT NULL,
    [sCPId] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ParticipantMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ParticipantMaster]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sParticipantName] CHAR(25) NOT NULL,
    [cParticipantStatus] CHAR(1) NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cDeleteFlag] CHAR(1) NOT NULL,
    [nMarketSegmentId] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PreviousTrades
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PreviousTrades]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL,
    [nExchangeCode] SMALLINT NULL,
    [nProOrClient] SMALLINT NULL,
    [sClient] CHAR(15) NULL,
    [sSubBrokerId] CHAR(15) NULL,
    [sDealerCode] CHAR(5) NULL,
    [cOrderStatus] CHAR(1) NULL,
    [sRemarks] CHAR(25) NULL,
    [nBookType] SMALLINT NULL,
    [nEntryTime] INT NULL,
    [nOrderTime] INT NULL,
    [cParticipantType] CHAR(1) NULL,
    [nAuctionNumber] SMALLINT NULL,
    [nSettlementDays] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Profile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Profile]
(
    [sUserId] VARCHAR(255) NOT NULL,
    [sProfile] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ScripBasket
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ScripBasket]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nToken] SMALLINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ScripMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ScripMaster]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nInstrumentType] SMALLINT NOT NULL,
    [nPermittedToTrade] TINYINT NOT NULL,
    [nIssuedCapital] FLOAT NOT NULL,
    [nWarningPercent] INT NOT NULL,
    [nFreezePercent] INT NOT NULL,
    [sCreditRating] CHAR(12) NOT NULL,
    [nNormal_MarketAllowed] TINYINT NOT NULL,
    [nNormal_SecurityStatus] TINYINT NOT NULL,
    [nOddLot_MarketAllowed] TINYINT NOT NULL,
    [nOddLot_SecurityStatus] TINYINT NOT NULL,
    [nSpot_MarketAllowed] TINYINT NOT NULL,
    [nSpot_SecurityStatus] TINYINT NOT NULL,
    [nAuction_MarketAllowed] TINYINT NOT NULL,
    [nAuction_SecurityStatus] TINYINT NOT NULL,
    [nIssueRate] SMALLINT NOT NULL,
    [nIssueStartDate] INT NOT NULL,
    [nIssuePDate] INT NOT NULL,
    [nIssueMaturityDate] INT NOT NULL,
    [nRegularLot] INT NOT NULL,
    [nPriceTick] INT NOT NULL,
    [sSecurityDesc] CHAR(25) NOT NULL,
    [nListingDate] INT NOT NULL,
    [nExpulsionDate] INT NOT NULL,
    [nReadmissionDate] INT NOT NULL,
    [nRecordDate] INT NOT NULL,
    [nExDate] INT NOT NULL,
    [nNoDeliveryStartDate] INT NOT NULL,
    [nNoDeliveryEndDate] INT NOT NULL,
    [nAONAllowed] TINYINT NOT NULL,
    [nMFAllowed] TINYINT NOT NULL,
    [nIndexParticipant] SMALLINT NOT NULL,
    [nBookClosureStartDate] INT NOT NULL,
    [nBookClosureEndDate] INT NOT NULL,
    [nEGM] TINYINT NOT NULL,
    [nAGM] TINYINT NOT NULL,
    [nInterest] TINYINT NOT NULL,
    [nBonus] TINYINT NOT NULL,
    [nRights] TINYINT NOT NULL,
    [nDividend] TINYINT NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cDeleteFlag] CHAR(1) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMarginPercentage] INT NULL,
    [nMinimumLot] INT NULL,
    [nLowPriceRange] INT NULL,
    [nHighPriceRange] INT NULL,
    [nExerciseStartDate] INT NULL,
    [nExerciseEndDate] INT NULL,
    [nOldToken] SMALLINT NULL,
    [sAssetInstrument] CHAR(6) NULL,
    [sAssetName] CHAR(10) NULL,
    [nAssetToken] SMALLINT NULL,
    [nIntrinsicValue] INT NULL,
    [nExtrinsicValue] INT NULL,
    [nIsAsset] TINYINT NULL,
    [nPlAllowed] TINYINT NULL,
    [nExRejectionAllowed] TINYINT NULL,
    [nExAllowed] TINYINT NULL,
    [nExcerciseStyle] TINYINT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ScripToISINCODE
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ScripToISINCODE]
(
    [nToken] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [sISINCODE] CHAR(12) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SendMail
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SendMail]
(
    [nMailNo] INT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [sTo] VARCHAR(255) NOT NULL,
    [sCc] VARCHAR(255) NULL,
    [sFrom] VARCHAR(255) NOT NULL,
    [sSubject] VARCHAR(255) NOT NULL,
    [sMessage] VARCHAR(255) NOT NULL,
    [cMailSent] CHAR(1) NOT NULL,
    [cMailType] CHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SessionUserMapping
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SessionUserMapping]
(
    [sDealerId] CHAR(15) NULL,
    [sTradingId] CHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SettlementMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SettlementMaster]
(
    [nSettType] TINYINT NOT NULL,
    [nSettNo] INT NOT NULL,
    [nFromDate] INT NOT NULL,
    [nToDate] INT NOT NULL,
    [nFundsPayInDate] INT NOT NULL,
    [nFundsPayOutDate] INT NOT NULL,
    [nSecuritiesPayInDate] INT NOT NULL,
    [nSecuritiesPayOutDate] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SM_VER_345
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SM_VER_345]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nNetExposureLimit] FLOAT NOT NULL,
    [nNetSaleExposureLimit] FLOAT NOT NULL,
    [nNetPositionLimit] FLOAT NOT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nMaxSingleTransVal] FLOAT NOT NULL,
    [nMaxSingleTransQty] INT NOT NULL,
    [nPendingOrdersLimit] FLOAT NOT NULL,
    [nMTMLossLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NOT NULL,
    [nNetExposureWarnLimit] SMALLINT NOT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NOT NULL,
    [nNetPositionWarnLimit] SMALLINT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NOT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NOT NULL,
    [nMTMLossWarnLimit] SMALLINT NOT NULL,
    [nMaxGrossExposure] FLOAT NOT NULL,
    [nMaxNetExposure] FLOAT NOT NULL,
    [nMaxNetSaleExposure] FLOAT NOT NULL,
    [nMaxNetPosition] FLOAT NOT NULL,
    [nMaxTurnover] FLOAT NOT NULL,
    [nCurrentGrossExposure] FLOAT NOT NULL,
    [nCurrentNetExposure] FLOAT NOT NULL,
    [nCurrentNetSaleExposure] FLOAT NOT NULL,
    [nCurrentNetPosition] FLOAT NOT NULL,
    [nCurrentTurnover] FLOAT NOT NULL,
    [nCurrentTradeBasedGrossExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetSaleExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetPosition] FLOAT NOT NULL,
    [nCurrentTradeBasedTurnover] FLOAT NOT NULL,
    [nCurrentPendingOrders] FLOAT NOT NULL,
    [nCurrentMTMLoss] FLOAT NOT NULL,
    [nCurrentIM] FLOAT NULL,
    [nCurrentTradeBasedIM] FLOAT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMaxIM] FLOAT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nLedgerBalance] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SPANContractDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SPANContractDetails]
(
    [sInstrumentName] CHAR(6) NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nExpiryDate] INT NOT NULL,
    [nStrikePrice] INT NOT NULL,
    [sOptionType] CHAR(2) NOT NULL,
    [nCALevel] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nAssetToken] INT NOT NULL,
    [nContractPrice] NUMERIC(10, 2) NOT NULL,
    [nContractVolatility] NUMERIC(20, 6) NOT NULL,
    [nScen1] NUMERIC(10, 2) NOT NULL,
    [nScen2] NUMERIC(10, 2) NOT NULL,
    [nScen3] NUMERIC(10, 2) NOT NULL,
    [nScen4] NUMERIC(10, 2) NOT NULL,
    [nScen5] NUMERIC(10, 2) NOT NULL,
    [nScen6] NUMERIC(10, 2) NOT NULL,
    [nScen7] NUMERIC(10, 2) NOT NULL,
    [nScen8] NUMERIC(10, 2) NOT NULL,
    [nScen9] NUMERIC(10, 2) NOT NULL,
    [nScen10] NUMERIC(10, 2) NOT NULL,
    [nScen11] NUMERIC(10, 2) NOT NULL,
    [nScen12] NUMERIC(10, 2) NOT NULL,
    [nScen13] NUMERIC(10, 2) NOT NULL,
    [nScen14] NUMERIC(10, 2) NOT NULL,
    [nScen15] NUMERIC(10, 2) NOT NULL,
    [nScen16] NUMERIC(10, 2) NOT NULL,
    [nCompDelta] NUMERIC(10, 4) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SPANOutPut
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SPANOutPut]
(
    [sDealerCode] VARCHAR(25) NOT NULL,
    [nShortFutureValue] FLOAT NULL,
    [nLongFutureValue] FLOAT NULL,
    [nShortOptionValue] FLOAT NULL,
    [nLongOptionValue] FLOAT NULL,
    [nInitialMarginAvailableOptionValue] FLOAT NULL,
    [nInitialMarginSPANRequirement] FLOAT NULL,
    [nMaintMarginAvailableOptionValue] FLOAT NULL,
    [nMaintMarginSPANRequirement] FLOAT NULL,
    [nUpdateTime] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SPANRPFDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SPANRPFDetails]
(
    [nVersion] INT NULL,
    [nCreationDate] INT NULL,
    [nPointInTime] INT NULL,
    [sClearingHouse] VARCHAR(100) NULL,
    [nNetMarginFlag] INT NULL,
    [nExchangeCode] INT NULL,
    [sRPFFileName] VARCHAR(250) NULL,
    [nLastFileUpdateTime] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SPANUnderlyingDetails
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SPANUnderlyingDetails]
(
    [nToken] INT NOT NULL,
    [nSpreadRate] NUMERIC(10, 2) NOT NULL,
    [nSOMRate] NUMERIC(10, 2) NOT NULL,
    [nScen1] NUMERIC(10, 2) NOT NULL,
    [nScen2] NUMERIC(10, 2) NOT NULL,
    [nScen3] NUMERIC(10, 2) NOT NULL,
    [nScen4] NUMERIC(10, 2) NOT NULL,
    [nScen5] NUMERIC(10, 2) NOT NULL,
    [nScen6] NUMERIC(10, 2) NOT NULL,
    [nScen7] NUMERIC(10, 2) NOT NULL,
    [nScen8] NUMERIC(10, 2) NOT NULL,
    [nScen9] NUMERIC(10, 2) NOT NULL,
    [nScen10] NUMERIC(10, 2) NOT NULL,
    [nScen11] NUMERIC(10, 2) NOT NULL,
    [nScen12] NUMERIC(10, 2) NOT NULL,
    [nScen13] NUMERIC(10, 2) NOT NULL,
    [nScen14] NUMERIC(10, 2) NOT NULL,
    [nScen15] NUMERIC(10, 2) NOT NULL,
    [nScen16] NUMERIC(10, 2) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_StmtOfHolding
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_StmtOfHolding]
(
    [StmtDate] DATETIME NOT NULL,
    [PreparationDateTime] DATETIME NOT NULL,
    [BeneficiaryAccountNo] INT NOT NULL,
    [BeneficiaryCategory] SMALLINT NULL,
    [ISIN] VARCHAR(12) NOT NULL,
    [BeneficiaryAccountType] SMALLINT NULL,
    [BeneficiaryAccountPosition] FLOAT NULL,
    [CCID] VARCHAR(8) NULL,
    [MarketType] SMALLINT NULL,
    [SettlementNo] VARCHAR(7) NULL,
    [BlockLockFlag] CHAR(1) NOT NULL,
    [BlockLockCode] SMALLINT NULL,
    [LockInReleaseDate] DATETIME NULL,
    [BranchNo] SMALLINT NULL,
    [DpId] CHAR(8) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SurveillanceMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SurveillanceMaster]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nPeriodicity] SMALLINT NOT NULL,
    [nGrossExposureLimit] FLOAT NOT NULL,
    [nNetExposureLimit] FLOAT NOT NULL,
    [nNetSaleExposureLimit] FLOAT NOT NULL,
    [nNetPositionLimit] FLOAT NOT NULL,
    [nTurnoverLimit] FLOAT NOT NULL,
    [nMaxSingleTransVal] FLOAT NOT NULL,
    [nMaxSingleTransQty] INT NOT NULL,
    [nPendingOrdersLimit] FLOAT NOT NULL,
    [nMTMLossLimit] FLOAT NOT NULL,
    [nGrossExposureWarnLimit] SMALLINT NOT NULL,
    [nNetExposureWarnLimit] SMALLINT NOT NULL,
    [nNetSaleExposureWarnLimit] SMALLINT NOT NULL,
    [nNetPositionWarnLimit] SMALLINT NOT NULL,
    [nTurnoverWarnLimit] SMALLINT NOT NULL,
    [nPendingOrdersWarnLimit] SMALLINT NOT NULL,
    [nMTMLossWarnLimit] SMALLINT NOT NULL,
    [nMaxGrossExposure] FLOAT NOT NULL,
    [nMaxNetExposure] FLOAT NOT NULL,
    [nMaxNetSaleExposure] FLOAT NOT NULL,
    [nMaxNetPosition] FLOAT NOT NULL,
    [nMaxTurnover] FLOAT NOT NULL,
    [nCurrentGrossExposure] FLOAT NOT NULL,
    [nCurrentNetExposure] FLOAT NOT NULL,
    [nCurrentNetSaleExposure] FLOAT NOT NULL,
    [nCurrentNetPosition] FLOAT NOT NULL,
    [nCurrentTurnover] FLOAT NOT NULL,
    [nCurrentTradeBasedGrossExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetSaleExposure] FLOAT NOT NULL,
    [nCurrentTradeBasedNetPosition] FLOAT NOT NULL,
    [nCurrentTradeBasedTurnover] FLOAT NOT NULL,
    [nCurrentPendingOrders] FLOAT NOT NULL,
    [nCurrentMTMLoss] FLOAT NOT NULL,
    [nCurrentIM] FLOAT NULL,
    [nCurrentTradeBasedIM] FLOAT NULL,
    [nGrossExposureMultiplier] INT NULL,
    [nIMMultiplier] INT NULL,
    [nIMWarningLimit] INT NULL,
    [nMaxIM] FLOAT NULL,
    [nMTMLossMultiplier] INT NULL,
    [nCashCollateral] FLOAT NULL,
    [nNetExposureMultiplier] INT NULL,
    [nNetPositionMultiplier] INT NULL,
    [nNetSaleExposureMultiplier] INT NULL,
    [nIMLimit] FLOAT NULL,
    [nLedgerBalance] FLOAT NULL,
    [nSecurityCollateral] FLOAT NULL,
    [nPendingOrdersMultiplier] INT NULL,
    [nTurnoverMultiplier] INT NULL,
    [nRetainMultiplier] TINYINT NOT NULL DEFAULT 0,
    [nIncludeMTMP] TINYINT NOT NULL DEFAULT 0,
    [nIncludeNetPremium] TINYINT NOT NULL DEFAULT 0,
    [nGrossOrNet] TINYINT NOT NULL DEFAULT 0,
    [nLastUpdateTime] DATETIME NOT NULL DEFAULT (convert(datetime,getdate())),
    [nDealerCategory] SMALLINT NULL,
    [nGroupCategory] SMALLINT NULL,
    [nCurrentGrossingGrossExposure] FLOAT NULL,
    [nCurrentGrossingNetExposure] FLOAT NULL,
    [nCurrentGrossingNetSaleExposure] FLOAT NULL,
    [nCurrentTradeBasedGrossingGrossExposure] FLOAT NULL,
    [nCurrentTradeBasedGrossingNetExposure] FLOAT NULL,
    [nCurrentTradeBasedGrossingNetSaleExposure] FLOAT NULL,
    [nCurrentGrossingMTMLoss] FLOAT NULL,
    [nMaxGrossingGrossExposure] FLOAT NULL,
    [nMaxGrossingNetExposure] FLOAT NULL,
    [nMaxGrossingNetSaleExposure] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TempLogPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TempLogPendingOrders]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_TouchlineInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_TouchlineInfo]
(
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nBestBuyQty] INT NOT NULL,
    [nBestBuyPrice] INT NOT NULL,
    [nBestSellQty] INT NOT NULL,
    [nBestSellPrice] INT NOT NULL,
    [nLastTradedQty] INT NOT NULL,
    [nLastTradedPrice] INT NOT NULL,
    [nLastTradedTime] DATETIME NOT NULL,
    [nAvgTradedPrice] INT NOT NULL,
    [nTotalQtyTraded] INT NOT NULL,
    [nNetChangeFromPrevClose] INT NOT NULL,
    [nOpenPrice] INT NOT NULL,
    [nClosePrice] INT NOT NULL,
    [nHighPrice] INT NOT NULL,
    [nLowPrice] INT NOT NULL,
    [nLastBroadcastTime] DATETIME NOT NULL,
    [nTotalBuyQty] FLOAT NOT NULL,
    [nTotalSellQty] FLOAT NOT NULL,
    [nMktType] CHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UnCompMarketMovementInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UnCompMarketMovementInfo]
(
    [nSystemTime] INT NOT NULL,
    [nToken] INT NOT NULL,
    [nMarketSegmentId] INT NOT NULL,
    [sData] VARCHAR(255) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_UserPrivileges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_UserPrivileges]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nExchangeCode] SMALLINT NOT NULL,
    [nMarketCode] SMALLINT NOT NULL,
    [nRegularLot] SMALLINT NULL DEFAULT 1,
    [nSpecialTerms] SMALLINT NULL DEFAULT 1,
    [nStopLoss] SMALLINT NULL DEFAULT 1,
    [nMarketIfTouched] SMALLINT NULL DEFAULT 1,
    [nNegotiated] SMALLINT NULL DEFAULT 1,
    [nOddLot] SMALLINT NULL DEFAULT 1,
    [nSpot] SMALLINT NULL DEFAULT 1,
    [nAuction] SMALLINT NULL DEFAULT 1,
    [nLimit] SMALLINT NULL DEFAULT 1,
    [nMarket] SMALLINT NULL DEFAULT 1,
    [nSpread] SMALLINT NULL DEFAULT 1,
    [nExcercise] SMALLINT NULL DEFAULT 1,
    [nDontExcercise] SMALLINT NULL DEFAULT 1,
    [nPositionLiquidation] SMALLINT NULL DEFAULT 1,
    [nTradeModification] SMALLINT NULL DEFAULT 0,
    [nTradeCancellation] SMALLINT NULL DEFAULT 0,
    [nBuy] SMALLINT NULL DEFAULT 1,
    [nSell] SMALLINT NULL DEFAULT 1,
    [nBuyCall] SMALLINT NULL DEFAULT 1,
    [nBuyPut] SMALLINT NULL DEFAULT 1,
    [nSellCall] SMALLINT NULL DEFAULT 1,
    [nSellPut] SMALLINT NULL DEFAULT 1,
    [nAmerican] SMALLINT NULL DEFAULT 1,
    [nEuropean] SMALLINT NULL DEFAULT 1,
    [nCover] SMALLINT NULL DEFAULT 1,
    [nUnCover] SMALLINT NULL DEFAULT 1,
    [nOpen] SMALLINT NULL DEFAULT 1,
    [nClose] SMALLINT NULL DEFAULT 1,
    [nDay] SMALLINT NULL DEFAULT 1,
    [nGTD] SMALLINT NULL DEFAULT 1,
    [nGTC] SMALLINT NULL DEFAULT 1,
    [nIOC] SMALLINT NULL DEFAULT 1,
    [nGTT] SMALLINT NULL DEFAULT 1,
    [n6A7A] SMALLINT NULL DEFAULT 1,
    [nPro] SMALLINT NULL DEFAULT 1,
    [nClient] SMALLINT NULL DEFAULT 1,
    [nParticipant] SMALLINT NULL DEFAULT 1,
    [nWHS] SMALLINT NULL DEFAULT 1,
    [nBuyBack] SMALLINT NULL DEFAULT 1,
    [nCash] SMALLINT NULL DEFAULT 1,
    [nMargin] SMALLINT NULL DEFAULT 1
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_WebDailyLoginLogoff
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_WebDailyLoginLogoff]
(
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nLoginLogoffTime] INT NOT NULL,
    [cLoginLogoff] CHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_WebMbpMboInfo
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_WebMbpMboInfo]
(
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nBestBuyQty] INT NOT NULL,
    [nBestBuyPrice] INT NOT NULL,
    [nBestSellQty] INT NOT NULL,
    [nBestSellPrice] INT NOT NULL,
    [nLastTradedQty] INT NOT NULL,
    [nLastTradedPrice] INT NOT NULL,
    [nLastTradedTime] DATETIME NOT NULL,
    [nAvgTradedPrice] INT NOT NULL,
    [nTotalQtyTraded] INT NOT NULL,
    [nNetChangeFromPrevClose] INT NOT NULL,
    [nOpenPrice] INT NOT NULL,
    [nClosePrice] INT NOT NULL,
    [nHighPrice] INT NOT NULL,
    [nLowPrice] INT NOT NULL,
    [nLastBroadcastTime] DATETIME NOT NULL,
    [nTotalBuyQty] FLOAT NOT NULL,
    [nTotalSellQty] FLOAT NOT NULL,
    [nNoOfBuyOrders] INT NOT NULL,
    [nNoOfSellOrders] INT NOT NULL,
    [nMktType] CHAR(1) NOT NULL,
    [nRecNo] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_IntegratedPendingOrders
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_IntegratedPendingOrders]
(
    [cOrderStatus] CHAR(1) NOT NULL,
    [sDealerCode] VARCHAR(5) NOT NULL,
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nSettlementDays] SMALLINT NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTotalQuantity] INT NOT NULL,
    [nPrice] INT NOT NULL,
    [nTriggerPrice] INT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nMinFillQuantity] INT NOT NULL,
    [nProOrClient] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [sParticipantCode] CHAR(12) NOT NULL,
    [sCPBrokerCode] CHAR(5) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nOrderNumber] FLOAT NOT NULL,
    [nOrderTime] INT NOT NULL,
    [nEntryTime] INT NOT NULL,
    [nAuctionNumber] SMALLINT NOT NULL,
    [cParticipantType] CHAR(1) NOT NULL,
    [nCompetitorPeriod] SMALLINT NOT NULL,
    [nSolicitorPeriod] SMALLINT NOT NULL,
    [cModCancelBy] CHAR(1) NOT NULL,
    [nReasonCode] SMALLINT NOT NULL,
    [cSecuritySuspendIndicator] CHAR(1) NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nTotalQuantityRemaining] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [nBranchID] SMALLINT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [nPendingQty] INT NOT NULL,
    [nTransactionStatus] SMALLINT NOT NULL,
    [nReplyCode] SMALLINT NOT NULL,
    [nReplyMessageLen] SMALLINT NOT NULL,
    [sReplyMessage] VARCHAR(40) NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nBookType] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ScripMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ScripMaster]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nInstrumentType] SMALLINT NOT NULL,
    [nPermittedToTrade] TINYINT NOT NULL,
    [nIssuedCapital] FLOAT NOT NULL,
    [nWarningPercent] INT NOT NULL,
    [nFreezePercent] INT NOT NULL,
    [sCreditRating] CHAR(12) NOT NULL,
    [nNormal_MarketAllowed] TINYINT NOT NULL,
    [nNormal_SecurityStatus] TINYINT NOT NULL,
    [nOddLot_MarketAllowed] TINYINT NOT NULL,
    [nOddLot_SecurityStatus] TINYINT NOT NULL,
    [nSpot_MarketAllowed] TINYINT NOT NULL,
    [nSpot_SecurityStatus] TINYINT NOT NULL,
    [nAuction_MarketAllowed] TINYINT NOT NULL,
    [nAuction_SecurityStatus] TINYINT NOT NULL,
    [nIssueRate] SMALLINT NOT NULL,
    [nIssueStartDate] INT NOT NULL,
    [nIssuePDate] INT NOT NULL,
    [nIssueMaturityDate] INT NOT NULL,
    [nRegularLot] INT NOT NULL,
    [nPriceTick] INT NOT NULL,
    [sSecurityDesc] CHAR(25) NOT NULL,
    [nListingDate] INT NOT NULL,
    [nExpulsionDate] INT NOT NULL,
    [nReadmissionDate] INT NOT NULL,
    [nRecordDate] INT NOT NULL,
    [nExDate] INT NOT NULL,
    [nNoDeliveryStartDate] INT NOT NULL,
    [nNoDeliveryEndDate] INT NOT NULL,
    [nAONAllowed] TINYINT NOT NULL,
    [nMFAllowed] TINYINT NOT NULL,
    [nIndexParticipant] SMALLINT NOT NULL,
    [nBookClosureStartDate] INT NOT NULL,
    [nBookClosureEndDate] INT NOT NULL,
    [nEGM] TINYINT NOT NULL,
    [nAGM] TINYINT NOT NULL,
    [nInterest] TINYINT NOT NULL,
    [nBonus] TINYINT NOT NULL,
    [nRights] TINYINT NOT NULL,
    [nDividend] TINYINT NOT NULL,
    [nLastUpdateTime] INT NOT NULL,
    [cDeleteFlag] CHAR(1) NOT NULL,
    [sRemarks] CHAR(25) NOT NULL,
    [nMarginPercentage] INT NULL,
    [nMinimumLot] INT NULL,
    [nLowPriceRange] INT NULL,
    [nHighPriceRange] INT NULL,
    [nExerciseStartDate] INT NULL,
    [nExerciseEndDate] INT NULL,
    [nOldToken] SMALLINT NULL,
    [sAssetInstrument] CHAR(6) NULL,
    [sAssetName] CHAR(10) NULL,
    [nAssetToken] SMALLINT NULL,
    [nIntrinsicValue] INT NULL,
    [nExtrinsicValue] INT NULL,
    [nIsAsset] TINYINT NULL,
    [nPlAllowed] TINYINT NULL,
    [nExRejectionAllowed] TINYINT NULL,
    [nExAllowed] TINYINT NULL,
    [nExcerciseStyle] TINYINT NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Trades
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Trades]
(
    [nMessageCode] SMALLINT NOT NULL,
    [nTimeStamp] INT NOT NULL,
    [sAlphaChar] CHAR(2) NOT NULL,
    [nErrorCode] SMALLINT NOT NULL,
    [sTimeStamp1] CHAR(8) NOT NULL,
    [nMessageLength] SMALLINT NOT NULL,
    [sSymbol] CHAR(10) NOT NULL,
    [sSeries] CHAR(2) NOT NULL,
    [nQuantityTraded] INT NOT NULL,
    [nQuantityRemaining] INT NOT NULL,
    [nTradedPrice] INT NOT NULL,
    [nTradeNumber] INT NOT NULL,
    [nTradedTime] INT NOT NULL,
    [nBuyOrSell] TINYINT NOT NULL,
    [nTradedOrderNumber] FLOAT NOT NULL,
    [sBrokerID] CHAR(5) NOT NULL,
    [cEnteredBy] CHAR(1) NOT NULL,
    [nUserID] SMALLINT NOT NULL,
    [sAccountCode] CHAR(10) NOT NULL,
    [nOriginalQuantity] INT NOT NULL,
    [nDisclosedQuantity] INT NOT NULL,
    [nDisclosedQuantityRemaining] INT NOT NULL,
    [nOrderPrice] INT NOT NULL,
    [nMF] TINYINT NOT NULL,
    [nAON] TINYINT NOT NULL,
    [nIOC] TINYINT NOT NULL,
    [nGTC] TINYINT NOT NULL,
    [nDay] TINYINT NOT NULL,
    [nSL] TINYINT NOT NULL,
    [nMarket] TINYINT NOT NULL,
    [nATO] TINYINT NOT NULL,
    [nFrozen] TINYINT NOT NULL,
    [nModified] TINYINT NOT NULL,
    [nTraded] TINYINT NOT NULL,
    [nMatchedInd] TINYINT NOT NULL,
    [nGoodTillDays] INT NOT NULL,
    [nQuantityTradedToday] INT NOT NULL,
    [sActivityType] CHAR(2) NOT NULL,
    [nCPTradedOrderNo] FLOAT NOT NULL,
    [sCPBrokerID] CHAR(5) NOT NULL,
    [nOrderType] SMALLINT NOT NULL,
    [nNewQuantity] INT NOT NULL,
    [nTokenNumber] SMALLINT NULL,
    [cOpenClose] CHAR(1) NULL,
    [cOldOpenOrClose] CHAR(1) NULL,
    [cCoverUncover] CHAR(1) NULL,
    [cOldCoverOrUncover] CHAR(1) NULL,
    [cGiveUpFlag] CHAR(1) NULL,
    [sOldAccountCode] CHAR(10) NULL,
    [sParticipant] CHAR(12) NULL,
    [sOldParticipant] CHAR(12) NULL,
    [sInstrumentName] CHAR(6) NULL,
    [nExpiryDate] INT NULL,
    [nStrikePrice] INT NULL,
    [sOptionType] CHAR(2) NULL,
    [nCALevel] SMALLINT NULL,
    [cBookType] CHAR(1) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempCE
-- --------------------------------------------------
CREATE TABLE [dbo].[tempCE]
(
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempctclold
-- --------------------------------------------------
CREATE TABLE [dbo].[tempctclold]
(
    [Neat User Id] VARCHAR(255) NULL,
    [Trading Member Code] VARCHAR(255) NULL,
    [newctclid] MONEY NULL,
    [Automated Trading Software/Non Automated Software] VARCHAR(255) NULL,
    [Name of the CTCL Vendor] VARCHAR(255) NULL,
    [oldCtclid] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmp_ExplClientExposures
-- --------------------------------------------------
CREATE TABLE [dbo].[tmp_ExplClientExposures]
(
    [nCaseId] INT NOT NULL,
    [sDealerId] CHAR(15) NOT NULL,
    [sClientId] CHAR(15) NOT NULL,
    [nToken] SMALLINT NOT NULL,
    [nBuyQuantity] INT NOT NULL,
    [nBuyValue] FLOAT NOT NULL,
    [nSellQuantity] INT NOT NULL,
    [nSellValue] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TmpScripLog
-- --------------------------------------------------
CREATE TABLE [dbo].[TmpScripLog]
(
    [dSystemDate] DATETIME NULL,
    [nToken] SMALLINT NULL,
    [sSymbol] CHAR(10) NULL,
    [sSeries] CHAR(2) NULL,
    [nMarketSegmentId] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trial
-- --------------------------------------------------
CREATE TABLE [dbo].[trial]
(
    [code] VARCHAR(10) NULL,
    [Col002] VARCHAR(10) NULL,
    [scrip] VARCHAR(20) NULL,
    [equity] VARCHAR(10) NULL,
    [sname] VARCHAR(50) NULL,
    [Col006] VARCHAR(10) NULL,
    [Col007] VARCHAR(10) NULL,
    [Col008] VARCHAR(10) NULL,
    [terminal] VARCHAR(20) NULL,
    [Col010] VARCHAR(10) NULL,
    [buysell] VARCHAR(10) NULL,
    [qty] VARCHAR(20) NULL,
    [rate] VARCHAR(20) NULL,
    [Col014] VARCHAR(10) NULL,
    [ctclid] VARCHAR(50) NULL,
    [Col016] VARCHAR(10) NULL,
    [Col017] VARCHAR(10) NULL,
    [Col018] VARCHAR(10) NULL,
    [Col019] VARCHAR(10) NULL,
    [Col020] VARCHAR(50) NULL,
    [Col021] VARCHAR(50) NULL,
    [Col022] VARCHAR(50) NULL,
    [Col023] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trial1
-- --------------------------------------------------
CREATE TABLE [dbo].[trial1]
(
    [code] VARCHAR(30) NULL,
    [Col002] VARCHAR(30) NULL,
    [Col003] VARCHAR(30) NULL,
    [scrip] VARCHAR(30) NULL,
    [Col005] VARCHAR(30) NULL,
    [Col006] VARCHAR(30) NULL,
    [Col007] VARCHAR(30) NULL,
    [Col008] VARCHAR(30) NULL,
    [Col009] VARCHAR(30) NULL,
    [qty] VARCHAR(30) NULL,
    [rate] VARCHAR(30) NULL,
    [Col012] VARCHAR(30) NULL,
    [ctclid] VARCHAR(30) NULL,
    [Col014] VARCHAR(30) NULL,
    [Col015] VARCHAR(30) NULL,
    [Col016] VARCHAR(30) NULL,
    [Col017] VARCHAR(30) NULL,
    [Col018] VARCHAR(30) NULL,
    [Col019] VARCHAR(30) NULL,
    [Col020] VARCHAR(30) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_DealerMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_DealerToClientMapping
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_DefaultSurveillance
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_DefaultUserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_Masking
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_SurveillanceMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_del_UserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailyExplRequests
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailyExplRequests    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyExplRequests    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyExplRequests    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailyExplRequests ON dbo.tbl_DailyExplRequests 
FOR INSERT
AS
insert tbl_DailyExplHistory(
cConfirmed,
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nTokenNumber,
sInstrumentName,
sSymbol,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nExplFlag,
nExplNumber,
nMarketType,
sAccountCode,
nQuantity,
nProOrClient,
nExType,
nEntryTime,
nBranchID,
nUserID,
sBrokerID,
sRemarks,
sParticipantCode,
nReasonCode,
nMarketSegmentID)

select
cConfirmed,
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nTokenNumber,
sInstrumentName,
sSymbol,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nExplFlag,
nExplNumber,
nMarketType,
sAccountCode,
nQuantity,
nProOrClient,
nExType,
nEntryTime,
nBranchID,
nUserID,
sBrokerID,
sRemarks,
sParticipantCode,
nReasonCode,
nMarketSegmentID
from inserted

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailyExplResponses
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailyExplResponses    Script Date: 10/25/01 12:38:15 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyExplResponses    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyExplResponses    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailyExplResponses ON dbo.tbl_DailyExplResponses 
FOR INSERT
AS
insert tbl_DailyExplHistory(
cConfirmed,
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nTokenNumber,
sInstrumentName,
sSymbol,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nExplFlag,
nExplNumber,
nMarketType,
sAccountCode,
nQuantity,
nProOrClient,
nExType,
nEntryTime,
nBranchID,
nUserID,
sBrokerID,
sRemarks,
sParticipantCode,
nReasonCode,
nMarketSegmentID)

select
'Y',
sDealerCode,
nMessageCode,
nTimeStamp,
nErrorCode,
sAlphaChar,
sTimeStamp1,
nMessageLength,
nTokenNumber,
sInstrumentName,
sSymbol,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nExplFlag,
nExplNumber,
nMarketType,
sAccountCode,
nQuantity,
nProOrClient,
nExType,
nEntryTime,
nBranchID,
nUserID,
sBrokerID,
sRemarks,
sParticipantCode,
nReasonCode,
nMarketSegmentID
from inserted

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailyOrderRequests
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailyOrderRequests    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyOrderRequests    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyOrderRequests    Script Date: 23/10/01 9:42:13 AM ******/
/****** Object:  Trigger dbo.tr_ins_DailyOrderRequests    Script Date: 10/8/2001 6:12:58 PM ******/
CREATE TRIGGER tr_ins_DailyOrderRequests ON dbo.tbl_DailyOrderRequests 
FOR INSERT
AS
/*added new for order history download*/
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode

insert tbl_DailyOrderHistory(
sDealerCode,
nMessageCode,
nErrorCode,
sSymbol,
sSeries,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nOrderNumber,
nTransactionTime,
nTimeStamp,
sAccountCode,
nDisclosedQuantity,
nTriggerPrice,
nUserID,
nGoodTillDays,
nProOrClient,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nTotalQuantityRemaining,
nQuantityTradedToday,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId,
nQuantityTraded,
nTradeNumber,
sReasonString,
sClientCode,
nSerialNo,
nTotalCount
)

/*select sDealerCode, nMessageCode, nErrorCode, sSymbol, sSeries, nOrderType, nBuyOrSell, 
       nTotalQuantity, nPrice, nOrderNumber,  nOrderTime, ' ', nTimeStamp, 
       substring(sRemarks, 1,5), sAccountCode, nDisclosedQuantity, nTriggerPrice,
       nUserID, nGoodTillDays, nProOrClient, sParticipantCode, sCPBrokerCode,
       sRemarks, nIOC, nGTC, nDay, nSL, nMarket, nTotalQuantityRemaining, 
       nQuantityTradedToday, 0, 0*/

select sDealerCode,
nMessageCode,
nErrorCode,
sSymbol,
sSeries,
nOrderType,
nBuyOrSell,
nTotalQuantity,
nPrice,
nOrderNumber,
nOrderTime,
nTimeStamp,
sAccountCode,
nDisclosedQuantity,
nTriggerPrice,
nUserID,
nGoodTillDays,
nProOrClient,
sParticipantCode,
sCPBrokerCode,
sRemarks,
nIOC,
nGTC,
nDay,
nSL,
nMarket,
nTotalQuantityRemaining,
nQuantityTradedToday,
nTokenNumber,
cOpenClose,
cCoverUncover,
cGiveUpFlag,
sInstrumentName,
nExpiryDate,
nStrikePrice,
sOptionType,
nCALevel,
nBookType,
nMarketSegmentId,
0,
0,
'',
substring(sRemarks, 1,5),
@nSerialNo,
@nTotalCount
from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailyOrderResponses
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailyOrderResponses    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyOrderResponses    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyOrderResponses    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailyOrderResponses ON dbo.tbl_DailyOrderResponses
FOR INSERT
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode
	insert tbl_DailyOrderHistory(
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,nQuantityTraded,nTokenNumber,nTradeNumber,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,nSerialNo,nTotalCount
	)
	select	
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nOrderTime,' ',nTimeStamp,substring(sRemarks, 1,5),
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,0,nTokenNumber,0,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,@nSerialNo,@nTotalCount
	from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailySLOrderTriggers
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailySLOrderTriggers    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySLOrderTriggers    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySLOrderTriggers    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailySLOrderTriggers ON dbo.tbl_DailySLOrderTriggers 
--WITH ENCRYPTION
FOR INSERT
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory

	Declare @nSerialNo int
	Declare @sDealerCode char(5)
	Select  @sDealerCode = b.sDealerCode from tbl_DailyPendingOrders b,inserted where inserted.nOrderNumber = b.nOrderNumber 
	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode   
	insert tbl_DailyOrderHistory
	( sDealerCode, nMessageCode, nErrorCode,sSymbol, 
          sSeries,nOrderType,nBuyOrSell, 
          nQuantityTraded,nPrice,nOrderNumber,  
          nTransactionTime,sReasonString,nTimeStamp,sClientCode, 
          sAccountCode,nDisclosedQuantity, nTriggerPrice,
          nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
          sCPBrokerCode,sRemarks,nIOC,nGTC,nDay,nSL, 
          nMarket, nTotalQuantityRemaining,nQuantityTradedToday, 
	nTradeNumber,nTotalQuantity,
	  nTokenNumber,cOpenClose,cCoverUncover,cGiveUpFlag,sInstrumentName,
	  nExpiryDate,nStrikePrice,sOptionType,nCALevel,
	  nBookType,nMarketSegmentId,nSerialNo,nTotalCount)

   select b.sDealerCode, inserted.nMessageCode, inserted.nErrorCode, inserted.sSymbol, 
          inserted.sSeries, inserted.nOrderType, inserted.nBuyOrSell, 
          inserted.nQuantityTradedToday, inserted.nTradedPrice, inserted.nOrderNumber,  
          nTriggerTime, ' ', inserted.nTimeStamp, substring(b.sRemarks, 1, 11), 
          inserted.sAccountCode, inserted.nDisclosedQuantity, nOrderPrice,
          inserted.nUserID, inserted.nGoodTillDays, b.nProOrClient, b.sParticipantCode,
          b.sCPBrokerCode, b.sRemarks, inserted.nIOC, inserted.nGTC, inserted.nDay, inserted.nSL, 
          inserted.nMarket, b.nTotalQuantityRemaining, inserted.nQuantityTradedToday, 
	 inserted.nTradeNumber,inserted.nQuantityTradedToday,
	  inserted.nTokenNumber,inserted.cOpenClose,inserted.cCoverUncover,inserted.cGiveUpFlag,inserted.sInstrumentName,
	  inserted.nExpiryDate,inserted.nStrikePrice,inserted.sOptionType,inserted.nCALevel,
	  b.nBookType,inserted.nMarketSegmentId,@nSerialNo,@nTotalCount
   from   inserted, tbl_DailyPendingOrders b
   where  inserted.nOrderNumber = b.nOrderNumber  
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailySpreadOrderRequests
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderRequests    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderRequests    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderRequests    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailySpreadOrderRequests ON dbo.tbl_DailySpreadOrderRequests 
FOR INSERT
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode

	insert tbl_DailyOrderHistory(
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,nQuantityTraded,nTokenNumber,nTradeNumber,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,nSerialNo,nTotalCount
	)
	select	
	sDealerCode,nMessageCode,nBuyErrorCode,cBuySymbol,cBuySeries,nBuyBookType,nOrder1BuySell,
	nQuantity,nBuyPrice,nOrderNumber,nBuyEntryDateTime,' ',nBuyTimeStamp,substring(cBuyRemarks, 1,5),
	cBuyAccountcode,0,0,nUserId,0,nProClient,cBuyParticipant,
	'',nAONIOC,0,0,0,0,nRemainingQuantity,
	0,0,nBuyToken,0,cBuyOpenClose,cBuyCoverUncover,0,
	cBuyInstrumentName,nBuyExpiryDate,nBuyStrikePrice,cBuyOptionType,nBuyCALevel,nBuyBookType,nMarketSegmentId,cBuyRemarks,@nSerialNo,@nTotalCount
	from inserted

	Set @nSerialNo = @nSerialNo + 1
	Set @nTotalCount = @nTotalCount + 1
	insert tbl_DailyOrderHistory(
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,nQuantityTraded,nTokenNumber,nTradeNumber,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,nSerialNo,nTotalCount
	)
	select	
	sDealerCode,nMessageCode,nSellErrorCode,cSellSymbol,cSellSeries,nSellBookType,nOrder2BuySell,
	nQuantity,nSellPrice,nOrderNumber,nSellEntryDateTime,' ',nSellTimeStamp,substring(cSellRemarks, 1,5),
	cSellAccountcode,0,0,nUserId,0,nProClient,cSellParticipant,
	'',nAONIOC,0,0,0,0,nRemainingQuantity,
	0,0,nSellToken,0,cSellOpenClose,cSellCoverUncover,0,
	cSellInstrumentName,nSellExpiryDate,nSellStrikePrice,cSellOptionType,nSellCALevel,nSellBookType,nMarketSegmentId,cSellRemarks,@nSerialNo,@nTotalCount
	from inserted

	insert tbl_DailySpreadOrderHistory(
	nMessageCode,nMessageLength,cBuyAlphaChar,
	cSellAlphaChar,nBuyToken,nSellToken,
	nQuantity,nRemainingQuantity,nBuyPrice,
	nSellPrice,cBuyAccountcode,cSellAccountcode,
	nAONIOC,nBuyBookType,nSellBookType,
	nBuyOrderType,nSellOrderType,nOrder1BuySell,
	nOrder2BuySell,nBranchId,cBuyRemarks,
	cSellRemarks,nProClient,nOrderNumber,
	cBuyInstrumentName,cSellInstrumentName,cBuySymbol,
	cSellSymbol,cBuySeries,cSellSeries,
	nBuyExpiryDate,nSellExpiryDate,nBuyCALevel,
	nSellCALevel,nBuyStrikePrice,nSellStrikePrice,
	cBuyOptionType,cSellOptionType,cBuyOpenClose,
	cSellOpenClose,cBuyCoverUncover,cSellCoverUncover,
	cBuyParticipant,cSellParticipant,nBuyEntryDateTime,
	nSellEntryDateTime,nBuyTimeStamp,nSellTimeStamp,
	nMarketSegmentId,sDealerCode,nBuyErrorCode,nSellErrorCode,
	nUserId)
	select nMessageCode,
	nMessageLength,cBuyAlphaChar,cSellAlphaChar,
	nBuyToken,nSellToken,nQuantity,
	nRemainingQuantity,nBuyPrice,nSellPrice,
	cBuyAccountcode,cSellAccountcode,nAONIOC,
	nBuyBookType,nSellBookType,nBuyOrderType,
	nSellOrderType,nOrder1BuySell,nOrder2BuySell,
	nBranchId,cBuyRemarks,cSellRemarks,
	nProClient,nOrderNumber,cBuyInstrumentName,
	cSellInstrumentName,cBuySymbol,cSellSymbol,
	cBuySeries,cSellSeries,nBuyExpiryDate,
	nSellExpiryDate,nBuyCALevel,nSellCALevel,
	nBuyStrikePrice,nSellStrikePrice,cBuyOptionType,
	cSellOptionType,cBuyOpenClose,cSellOpenClose,
	cBuyCoverUncover,cSellCoverUncover,cBuyParticipant,
	cSellParticipant,nBuyEntryDateTime,nSellEntryDateTime,
	nBuyTimeStamp,nSellTimeStamp,nMarketSegmentId,
	sDealerCode,nBuyErrorCode,nSellErrorCode,
	nUserId
	from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailySpreadOrderResponses
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderResponses    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderResponses    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySpreadOrderResponses    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailySpreadOrderResponses ON dbo.tbl_DailySpreadOrderResponses 
FOR INSERT
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode

	insert tbl_DailyOrderHistory(
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,nQuantityTraded,nTokenNumber,nTradeNumber,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,nSerialNo,nTotalCount
	)
	select	
	sDealerCode,nMessageCode,nBuyErrorCode,cBuySymbol,cBuySeries,nBuyBookType,nOrder1BuySell,
	nQuantity,nBuyPrice,nOrderNumber,nBuyEntryDateTime,' ',nBuyTimeStamp,substring(cBuyRemarks, 1,5),
	cBuyAccountcode,0,0,nUserId,0,nProClient,cBuyParticipant,
	'',nAONIOC,0,0,0,0,nRemainingQuantity,
	0,0,nBuyToken,0,cBuyOpenClose,cBuyCoverUncover,0,
	cBuyInstrumentName,nBuyExpiryDate,nBuyStrikePrice,cBuyOptionType,nBuyCALevel,nBuyBookType,nMarketSegmentId,cBuyRemarks,@nSerialNo,@nTotalCount
	from inserted

	Set @nSerialNo = @nSerialNo + 1
	Set @nTotalCount = @nTotalCount + 1
	insert tbl_DailyOrderHistory(
	sDealerCode,nMessageCode,nErrorCode,sSymbol,sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,	nPrice,nOrderNumber,nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,nIOC,nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
	nQuantityTradedToday,nQuantityTraded,nTokenNumber,nTradeNumber,cOpenClose,cCoverUncover,cGiveUpFlag,
	sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,nBookType,nMarketSegmentId,sRemarks,nSerialNo,nTotalCount
	)
	select	
	sDealerCode,nMessageCode,nSellErrorCode,cSellSymbol,cSellSeries,nSellBookType,nOrder2BuySell,
	nQuantity,nSellPrice,nOrderNumber,nSellEntryDateTime,' ',nSellTimeStamp,substring(cSellRemarks, 1,5),
	cSellAccountcode,0,0,nUserId,0,nProClient,cSellParticipant,
	'',nAONIOC,0,0,0,0,nRemainingQuantity,
	0,0,nSellToken,0,cSellOpenClose,cSellCoverUncover,0,
	cSellInstrumentName,nSellExpiryDate,nSellStrikePrice,cSellOptionType,nSellCALevel,nSellBookType,nMarketSegmentId,cSellRemarks,@nSerialNo,@nTotalCount
	from inserted

	insert tbl_DailySpreadOrderHistory(
	nMessageCode,nMessageLength,cBuyAlphaChar,
	cSellAlphaChar,nBuyToken,nSellToken,
	nQuantity,nRemainingQuantity,nBuyPrice,
	nSellPrice,cBuyAccountcode,cSellAccountcode,
	nAONIOC,nBuyBookType,nSellBookType,
	nBuyOrderType,nSellOrderType,nOrder1BuySell,
	nOrder2BuySell,nBranchId,cBuyRemarks,
	cSellRemarks,nProClient,nOrderNumber,
	cBuyInstrumentName,cSellInstrumentName,cBuySymbol,
	cSellSymbol,cBuySeries,cSellSeries,
	nBuyExpiryDate,nSellExpiryDate,nBuyCALevel,
	nSellCALevel,nBuyStrikePrice,nSellStrikePrice,
	cBuyOptionType,cSellOptionType,cBuyOpenClose,
	cSellOpenClose,cBuyCoverUncover,cSellCoverUncover,
	cBuyParticipant,cSellParticipant,nBuyEntryDateTime,
	nSellEntryDateTime,nBuyTimeStamp,nSellTimeStamp,
	nMarketSegmentId,sDealerCode,nBuyErrorCode,nSellErrorCode,
	nUserId)
	select nMessageCode,
	nMessageLength,cBuyAlphaChar,cSellAlphaChar,
	nBuyToken,nSellToken,nQuantity,
	nRemainingQuantity,nBuyPrice,nSellPrice,
	cBuyAccountcode,cSellAccountcode,nAONIOC,
	nBuyBookType,nSellBookType,nBuyOrderType,
	nSellOrderType,nOrder1BuySell,nOrder2BuySell,
	nBranchId,cBuyRemarks,cSellRemarks,
	nProClient,nOrderNumber,cBuyInstrumentName,
	cSellInstrumentName,cBuySymbol,cSellSymbol,
	cBuySeries,cSellSeries,nBuyExpiryDate,
	nSellExpiryDate,nBuyCALevel,nSellCALevel,
	nBuyStrikePrice,nSellStrikePrice,cBuyOptionType,
	cSellOptionType,cBuyOpenClose,cSellOpenClose,
	cBuyCoverUncover,cSellCoverUncover,cBuyParticipant,
	cSellParticipant,nBuyEntryDateTime,nSellEntryDateTime,
	nBuyTimeStamp,nSellTimeStamp,nMarketSegmentId,
	sDealerCode,nBuyErrorCode,nSellErrorCode,
	nUserId
	from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailySurvFailedOrders
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_ins_DailySurvFailedOrders    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySurvFailedOrders    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailySurvFailedOrders    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailySurvFailedOrders ON dbo.tbl_DailySurvFailedOrders 
FOR INSERT
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode
 insert tbl_DailyOrderHistory
			(sDealerCode,nMessageCode,nErrorCode,sSymbol,
			sSeries,nOrderType,nBuyOrSell,nTotalQuantity,
			nPrice,nOrderNumber,nTransactionTime,sReasonString,
			nTimeStamp,sClientCode,sAccountCode,nDisclosedQuantity,
			nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,
			sParticipantCode,sCPBrokerCode,sRemarks,nIOC,
			nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
			nQuantityTradedToday,nQuantityTraded,nTradeNumber,nTokenNumber,
			cOpenClose,cCoverUncover,cGiveUpFlag,sInstrumentName,
			nExpiryDate,nStrikePrice,sOptionType,nCALevel,
			nBookType,nMarketSegmentId,nSerialNo,nTotalCount)

			select sDealerCode,nMessageCode,nErrorCode,sSymbol,
			sSeries,nOrderType,nBuyOrSell,nTotalQuantity,
			nPrice,nOrderNumber,nOrderTime,' ',
			nTimeStamp,substring(sRemarks, 1, 5),sAccountCode,nDisclosedQuantity,
			nTriggerPrice,0,0,nProOrClient,
			sParticipantCode,sCPBrokerCode,sRemarks,nIOC,
			nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
			nQuantityTradedToday,0,0,nTokenNumber,
			cOpenClose,cCoverUncover,cGiveUpFlag,sInstrumentName,
			nExpiryDate,nStrikePrice,sOptionType,nCALevel,
			nBookType,nMarketSegmentId,@nSerialNo,@nTotalCount
		from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailySurvFailedOrders1
-- --------------------------------------------------

CREATE TRIGGER tr_ins_DailySurvFailedOrders1 ON dbo.tbl_DailySurvFailedOrders 
FOR UPDATE
AS
BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode
 insert tbl_DailyOrderHistory
			(sDealerCode,nMessageCode,nErrorCode,sSymbol,
			sSeries,nOrderType,nBuyOrSell,nTotalQuantity,
			nPrice,nOrderNumber,nTransactionTime,sReasonString,
			nTimeStamp,sClientCode,sAccountCode,nDisclosedQuantity,
			nTriggerPrice,nUserID,nGoodTillDays,nProOrClient,
			sParticipantCode,sCPBrokerCode,sRemarks,nIOC,
			nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
			nQuantityTradedToday,nQuantityTraded,nTradeNumber,nTokenNumber,
			cOpenClose,cCoverUncover,cGiveUpFlag,sInstrumentName,
			nExpiryDate,nStrikePrice,sOptionType,nCALevel,
			nBookType,nMarketSegmentId,nSerialNo,nTotalCount)

			select sDealerCode,11,nErrorCode,sSymbol,
			sSeries,nOrderType,nBuyOrSell,nTotalQuantity,
			nPrice,nOrderNumber,nOrderTime,' ',
			nTimeStamp,substring(sRemarks, 1, 5),sAccountCode,nDisclosedQuantity,
			nTriggerPrice,0,0,nProOrClient,
			sParticipantCode,sCPBrokerCode,sRemarks,nIOC,
			nGTC,nDay,nSL,nMarket,nTotalQuantityRemaining,
			nQuantityTradedToday,0,0,nTokenNumber,
			cOpenClose,cCoverUncover,cGiveUpFlag,sInstrumentName,
			nExpiryDate,nStrikePrice,sOptionType,nCALevel,
			nBookType,nMarketSegmentId,@nSerialNo,@nTotalCount
		from inserted
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DailyTrades
-- --------------------------------------------------


/****** Object:  Trigger dbo.tr_ins_DailyTrades    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyTrades    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_ins_DailyTrades    Script Date: 23/10/01 9:42:13 AM ******/
CREATE TRIGGER tr_ins_DailyTrades ON dbo.tbl_DailyTrades
FOR INSERT
AS
--BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = b.sDealerCode from tbl_DailyPendingOrders b,inserted WHERE inserted.nTradedOrderNumber = b.nOrderNumber
	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode

INSERT tbl_DailyOrderHistory
	(sDealerCode,nMessageCode,nErrorCode,
	sSymbol,sSeries,
	nOrderType,nTotalQuantity,
	nBuyOrSell,nQuantityTraded,nPrice,
	nOrderNumber,nTransactionTime,sReasonString,
	nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,
	nUserID,nGoodTillDays,nProOrClient,
	sParticipantCode,
	sCPBrokerCode,sRemarks,nIOC,nGTC,
	nDay,nSL,
	nMarket,nTotalQuantityRemaining,nQuantityTradedToday,
	nTradeNumber,
   nTokenNumber,  cOpenClose,  cCoverUncover,   cGiveUpFlag ,    sInstrumentName,
   nExpiryDate ,nStrikePrice, sOptionType, nCALevel, nBookType, nMarketSegmentId,

    nSerialNo,nTotalCount)
SELECT b.sDealerCode   ,    inserted.nMessageCode, inserted.nErrorCode,
        inserted.sSymbol,    inserted.sSeries     , 
        inserted.nOrderType,inserted.nQuantityTraded,
        inserted.nBuyOrSell, inserted.nQuantityTraded      , inserted.nTradedPrice,
        inserted.nTradedOrderNumber,  inserted.nTradedTime          , ' ',
        inserted.nTimeStamp, substring(b.sRemarks, 1,5),
        inserted.sAccountCode, inserted.nDisclosedQuantity, 0,
        inserted.nUserID, inserted.nGoodTillDays, b.nProOrClient, 
        b.sParticipantCode,
        b.sCPBrokerCode, b.sRemarks, inserted.nIOC, inserted.nGTC, 
        inserted.nDay, inserted.nSL,
        inserted.nMarket, b.nTotalQuantityRemaining, 
        inserted.nQuantityTradedToday,
         inserted.nTradeNumber,
         inserted.nTokenNumber, inserted.cOpenClose, inserted.cCoverUncover, inserted.cGiveUpFlag, inserted.sInstrumentName, 
         inserted.nExpiryDate, inserted.nStrikePrice, inserted.sOptionType, inserted.nCALevel, b.nBookType, inserted.nMarketSegmentId, 
         @nSerialNo,@nTotalCount
   FROM inserted, tbl_DailyPendingOrders b
  WHERE inserted.nTradedOrderNumber = b.nOrderNumber   
--COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DealerMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DealerToClientMapping
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DefaultSurveillance
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_DefaultUserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_HistoricEOD
-- --------------------------------------------------
CREATE TRIGGER tr_ins_HistoricEOD
ON dbo.tbl_MarketStatistics
FOR INSERT 
AS
Begin
Declare
	@nMaxTime int,
	@nToken smallint,
	@nMaxOpenPrice int,
	@nOpen int,
	@nTime datetime,
	@nCurrentTime int,
	@nCurrentOpenPrice int,
	@sTicker varchar(30),
	@RowCount int,
	@nMarketSegmentId smallint,
	@nTodayDate datetime

select @nTodayDate = getdate()


select @nToken = a.nToken ,@nMarketSegmentId = b.nMarketSegmentId
from tbl_ScripMaster a,inserted b
where a.sSymbol = b.sSymbol
And   a.sSeries = b.sSeries
And   b.nMarketSegmentId = 13
And   b.nMarketType = 1

select @nToken = a.nToken ,@nMarketSegmentId = b.nMarketSegmentId
from tbl_ScripMaster a,inserted b
where a.sSymbol = b.sSymbol
--And   a.sSeries = b.sSeries
And   a.sInstrumentName = b.sIntstrumentName
And   a.nExpiryDate =  b.nExpiryDate
And   a.nStrikePrice = b.nStrikePrice
And   a.sOptionType = b.sOptionType
--And   a.nCALevel = b.nCALevel
And   b.nMarketSegmentId = 12
And   b.nMarketType = 1


Select @nMaxTime = isnull(max(nDate),0), @nMaxOpenPrice = isnull(max(nOpen),0)
from tbl_HistoricEOD 
where nToken = @nToken
And   nMarketSegmentId = @nMarketSegmentId
and   nDate = (select max(nDate) from tbl_HistoricEOD where nToken = @nToken And nMarketSegmentId = @nMarketSegmentId)


select @nCurrentTime = Case @nMaxTime when 0 then datediff(dd,'01/01/1980',@nTodayDate)
				      Else datediff(dd,dateadd(dd,@nMaxTime,'01/01/1980'),@nTodayDate) End,
	@nCurrentOpenPrice = Case isnull(@nMaxOpenPrice,0) when  0 then nOpenPrice 
				   Else nOpenPrice - isnull(@nMaxOpenPrice,0)  End,
	@nOpen  = nOpenPrice,
	@nTime = @nTodayDate
from inserted where nMarketType = 1

insert into tbl_HistoricEOD (nToken,nMarketSegmentId,sData, nOpen, nHi, nLow, nVolume, nClose, nDate)
select 	@nToken,nMarketSegmentId, 
	Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Convert(varchar(6),@nCurrentTime) + ',' +
       		Replace(convert(varchar(20),@nCurrentOpenPrice),'00',';') + ',' + 
		Replace(Convert(varchar(20),nHighPrice - nOpenPrice),'00',';') + ',' +
		Replace(convert(varchar(20),nOpenPrice - nLowPrice),'00',';')+ ',' +
       		Replace(convert(varchar(20),nClosingPrice - nLowPrice),'00',';')+ ',' +
			 convert(varchar(20),nTotalQtyTraded),',0,0,0,0,',')'), ',0,0,0,' , '('),',0,0,','!'),',0,','|'),'0,',':'),',+','{'),',-','}'),'5,','%'),'10','~'),'20','@'),'30','#'),'40','$'),'50','^'),'60','&'),'70','*'),'80','<'),'90','>')		,
	nOpenPrice,nHighPrice,nLowPrice,nClosingPrice,nTotalQtyTraded,
        datediff(dd,'01/01/1980',@nTodayDate)
from inserted where nMarketType = 1

/* The following Code can be commented if FEEF CLIENT does not handle Errors */
      if (@@error <> 0)
      Begin	
        rollback tran
        raiserror 500001 '(tr_ins_HistoricEOD) Insert failed...'
      End
End

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_Masking
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_SurveillanceMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_tbl_ParticipantMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_tbl_ScripMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_ins_UserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_DailySurvFailedOrders
-- --------------------------------------------------

/****** Object:  Trigger dbo.tr_upd_DailySurvFailedOrders    Script Date: 10/25/01 12:38:16 PM ******/

/****** Object:  Trigger dbo.tr_upd_DailySurvFailedOrders    Script Date: 10/25/01 12:26:47 PM ******/

/****** Object:  Trigger dbo.tr_upd_DailySurvFailedOrders    Script Date: 23/10/01 9:42:13 AM ******/
/****** Object:  Trigger dbo.tr_upd_DailySurvFailedOrders    Script Date: 10/8/2001 6:12:58 PM ******/
CREATE TRIGGER tr_upd_DailySurvFailedOrders ON dbo.tbl_DailySurvFailedOrders 
FOR UPDATE
AS

BEGIN TRANSACTION
Declare @nTotalCount int
Select @nTotalCount = count(*)+1  from tbl_DailyOrderHistory
Declare @nSerialNo int
Declare @sDealerCode char(5)
Select  @sDealerCode = sDealerCode from inserted

	Select @nSerialNo = count(*)+1 from tbl_DailyOrderHistory where sDealerCode = @sDealerCode

 insert tbl_DailyOrderHistory
	(sDealerCode,nMessageCode,nErrorCode,sSymbol,
	sSeries,nOrderType,nBuyOrSell,
	nTotalQuantity,nPrice,nOrderNumber,
	nTransactionTime,sReasonString,nTimeStamp,sClientCode,
	sAccountCode,nDisclosedQuantity,nTriggerPrice,
	nUserID,nGoodTillDays,nProOrClient,sParticipantCode,
	sCPBrokerCode,sRemarks,nIOC,nGTC,nDay,nSL,
	nMarket,nTotalQuantityRemaining,nQuantityTradedToday,
	nQuantityTraded,nTradeNumber,
	cGiveUpFlag,sInstrumentName,nExpiryDate,nStrikePrice,
	sOptionType,nCALevel,nBookType,nMarketSegmentId,nTokenNumber,nSerialNo,nTotalCount)
 select sDealerCode, 
        nMessageCode = 
         case
           when inserted.nAcceptRejectStatus = 1 then 16
           when inserted.nAcceptRejectStatus = 2 then 15
         end,
 nSurvErrorCode, sSymbol, sSeries, nOrderType, nBuyOrSell,nTotalQuantity, nPrice,
 nOrderNumber,  nOrderTime, sSurvErrorString, nTimeStamp, substring(sRemarks, 1, 5),
 sAccountCode, nDisclosedQuantity, nTriggerPrice,
 nUserID, nGoodTillDays, nProOrClient, sParticipantCode,
 sCPBrokerCode, sRemarks, nIOC, nGTC, nDay, nSL, 
 nMarket, nTotalQuantityRemaining, nQuantityTradedToday, 
 0, 0,cGiveUpFlag,sInstrumentName,nExpiryDate,nStrikePrice,sOptionType,nCALevel,
 nBookType,nMarketSegmentId,nTokenNumber,@nSerialNo,@nTotalCount

 from inserted                                               
COMMIT TRANSACTION

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_DealerMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_DealerToClientMapping
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_DefaultSurveillance
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_DefaultUserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_HistoricEOD
-- --------------------------------------------------
CREATE TRIGGER tr_upd_HistoricEOD
ON dbo.tbl_MarketStatistics
FOR UPDATE
AS
Begin
Declare
	@nMaxTime int,
	@nToken smallint,
	@nMaxOpenPrice int,
	@nOpen int,
	@nTime datetime,
	@nCurrentTime int,
	@nCurrentOpenPrice int,
	@sTicker varchar(30),
	@RowCount int,
	@nMarketSegmentId smallint,
	@nTodayDate datetime

select @nTodayDate = getdate()


select @nToken = a.nToken ,@nMarketSegmentId = b.nMarketSegmentId
from tbl_ScripMaster a,inserted b
where a.sSymbol = b.sSymbol
And   a.sSeries = b.sSeries
And   b.nMarketSegmentId = 13
And   b.nMarketType = 1

select @nToken = a.nToken ,@nMarketSegmentId = b.nMarketSegmentId
from tbl_ScripMaster a,inserted b
where a.sSymbol = b.sSymbol
--And   a.sSeries = b.sSeries
And   a.sInstrumentName = b.sIntstrumentName
And   a.nExpiryDate =  b.nExpiryDate
And   a.nStrikePrice = b.nStrikePrice
And   a.sOptionType = b.sOptionType
--And   a.nCALevel = b.nCALevel
And   b.nMarketSegmentId = 12
And   b.nMarketType = 1


Select @nMaxTime = isnull(max(nDate),0), @nMaxOpenPrice = isnull(max(nOpen),0)
from tbl_HistoricEOD 
where nToken = @nToken
And   nMarketSegmentId = @nMarketSegmentId
and   nDate = (select max(nDate) from tbl_HistoricEOD where nToken = @nToken And nMarketSegmentId = @nMarketSegmentId)


select @nCurrentTime = Case @nMaxTime when 0 then datediff(dd,'01/01/1980',@nTodayDate)
				      Else datediff(dd,dateadd(dd,@nMaxTime,'01/01/1980'),@nTodayDate) End,
	@nCurrentOpenPrice = Case isnull(@nMaxOpenPrice,0) when  0 then nOpenPrice 
				   Else nOpenPrice - isnull(@nMaxOpenPrice,0)  End,
	@nOpen  = nOpenPrice,
	@nTime = @nTodayDate
from inserted where nMarketType = 1

insert into tbl_HistoricEOD (nToken,nMarketSegmentId,sData, nOpen, nHi, nLow, nVolume, nClose, nDate)
select 	@nToken,nMarketSegmentId, 
	Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Convert(varchar(6),@nCurrentTime) + ',' +
       		Replace(convert(varchar(20),@nCurrentOpenPrice),'00',';') + ',' + 
		Replace(Convert(varchar(20),nHighPrice - nOpenPrice),'00',';') + ',' +
		Replace(convert(varchar(20),nOpenPrice - nLowPrice),'00',';')+ ',' +
       		Replace(convert(varchar(20),nClosingPrice - nLowPrice),'00',';')+ ',' +
			 convert(varchar(20),nTotalQtyTraded),',0,0,0,0,',')'), ',0,0,0,' , '('),',0,0,','!'),',0,','|'),'0,',':'),',+','{'),',-','}'),'5,','%'),'10','~'),'20','@'),'30','#'),'40','$'),'50','^'),'60','&'),'70','*'),'80','<'),'90','>')		,
	nOpenPrice,nHighPrice,nLowPrice,nClosingPrice,nTotalQtyTraded,
        datediff(dd,'01/01/1980',@nTodayDate)
from inserted where nMarketType = 1

/* The following Code can be commented if FEEF CLIENT does not handle Errors */
      if (@@error <> 0)
      Begin	
        rollback tran
        raiserror 500001 '(tr_ins_HistoricEOD) Insert failed...'
      End
End

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_Masking
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_SurveillanceMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_tbl_ParticipantMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_tbl_ScripMaster
-- --------------------------------------------------
/* encrypted or not available */

GO

-- --------------------------------------------------
-- TRIGGER dbo.tr_upd_UserPrivileges
-- --------------------------------------------------
/* encrypted or not available */

GO

