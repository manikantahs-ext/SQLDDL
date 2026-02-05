-- DDL Export
-- Server: 10.254.33.21
-- Database: ReplicatedData
-- Exported: 2026-02-05T11:34:56.097016

USE ReplicatedData;
GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_VNO_SL] CHECK (ltrim(rtrim([VNO]))<>'')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_ZERO_VTYP_SL] CHECK ([VTYP]<>(0))

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_ACNAME_SL] CHECK ([ACNAME] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_BOOKTYPE_SL] CHECK ([BOOKTYPE] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_CLTCODE_SL] CHECK ([CLTCODE] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_EDT_SL] CHECK ([EDT] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_VDT_SL] CHECK ([VDT] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_VNO_SL] CHECK ([VNO] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NOT_NULL_VTYP_SL] CHECK ([VTYP] IS NOT NULL)

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_ACNAME_SL] CHECK (ltrim(rtrim([ACNAME]))<>'')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_BOOKTYPE_SL] CHECK (ltrim(rtrim([BOOKTYPE]))<>'')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_CLTCODE_SL] CHECK (ltrim(rtrim([CLTCODE]))<>'')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_DRCR_SL] CHECK (ltrim(rtrim([DRCR]))='D' OR ltrim(rtrim([DRCR]))='C')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_EDT_SL] CHECK ([EDT]<>'')

GO

-- --------------------------------------------------
-- CHECK dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [NON_BLANK_VDT_SL] CHECK ([VDT]<>'')

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTFOLEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_accountfoledger_CLTCODE_VDT] ON [dbo].[ACCOUNTFOLEDGER] ([CLTCODE], [VDT]) INCLUDE ([VTYP], [VNO], [DRCR], [VAMT], [NARRATION])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTFOLEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_accountfoledger_VTYP_VNO_LNO_DRCR_VDT_CLTCODE_BOOKTYPE] ON [dbo].[ACCOUNTFOLEDGER] ([VTYP], [VNO], [LNO], [DRCR], [VDT], [CLTCODE], [BOOKTYPE])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTFOLEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Missing_IXNC_accountfoledger_VTYP_DRCR_VDT_CLTCODE_33CA5] ON [dbo].[ACCOUNTFOLEDGER] ([VTYP], [DRCR], [VDT], [CLTCODE]) INCLUDE ([VAMT])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [LED2IND] ON [dbo].[ACCOUNTNCELEDGER] ([Vdt], [Vno], [Vtyp])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ledger3] ON [dbo].[ACCOUNTNCELEDGER] ([Vtyp], [Vno], [Lno], [Vdt], [Cltcode], [Booktype], [Drcr], [Acname])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ledger5] ON [dbo].[ACCOUNTNCELEDGER] ([Vdt], [Vtyp], [Edt], [Drcr], [Vamt], [Cltcode])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ledind] ON [dbo].[ACCOUNTNCELEDGER] ([Vno], [Vtyp], [Vdt], [Cltcode], [Booktype])

GO

-- --------------------------------------------------
-- INDEX dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Partyvdt] ON [dbo].[ACCOUNTNCELEDGER] ([Vno], [Vtyp], [Booktype], [Vdt], [Cltcode])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1ACCOUNTLEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Missing_IXNC_ANAND1ACCOUNTLEDGER_VTYP_DRCR_VDT_CLTCODE_7F5DE] ON [dbo].[ANAND1ACCOUNTLEDGER] ([VTYP], [DRCR], [VDT], [CLTCODE]) INCLUDE ([VAMT])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MSAJAGClient_Details
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Cl_Inx] ON [dbo].[ANAND1MSAJAGClient_Details] ([cl_code], [Status], [Imp_Status])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [CltCodeVdt] ON [dbo].[ANAND1MTFTRADELEDGER] ([cltcode], [vdt], [vtyp], [EnteredBy]) INCLUDE ([vno], [edt], [lno], [acname], [drcr], [vamt], [vno1], [refno], [balamt], [NoDays], [cdt], [BookType], [pdt], [CheckedBy], [actnodays], [narration])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_edt] ON [dbo].[ANAND1MTFTRADELEDGER] ([edt], [cltcode]) INCLUDE ([vtyp], [drcr], [vamt], [balamt])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[ANAND1MTFTRADELEDGER] ([cltcode], [vdt], [edt])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_LEDGER_cvdt] ON [dbo].[ANAND1MTFTRADELEDGER] ([cltcode], [vdt])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_VDT] ON [dbo].[ANAND1MTFTRADELEDGER] ([vdt])

GO

-- --------------------------------------------------
-- INDEX dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [NC_Led_Cover] ON [dbo].[ANAND1MTFTRADELEDGER] ([cltcode], [vtyp], [EnteredBy], [actnodays]) INCLUDE ([vno], [drcr], [vamt], [vdt])

GO

-- --------------------------------------------------
-- INDEX dbo.ANANDACCOUNT_ABLEDGER
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_ANANDACCOUNT_ABLEDGER_VTYP_DRCR_VDT_CLTCODE] ON [dbo].[ANANDACCOUNT_ABLEDGER] ([VTYP], [DRCR], [VDT], [CLTCODE]) INCLUDE ([VAMT])

GO

-- --------------------------------------------------
-- INDEX dbo.ANANDBSEDB_ABCMBILLVALAN
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [idx_ANANDBSEDB_ABCMBILLVALAN_SETT_NO_SETT_TYPE] ON [dbo].[ANANDBSEDB_ABCMBILLVALAN] ([SETT_NO], [SETT_TYPE], [SAUDA_DATE], [PARTY_CODE], [SCRIP_CD], [SERIES], [TERMINAL_ID], [CONTRACTNO], [TRADETYPE])

GO

-- --------------------------------------------------
-- INDEX dbo.ANGELDEMATBSEDBDeltrans
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Sno] ON [dbo].[ANGELDEMATBSEDBDeltrans] ([SNo])

GO

-- --------------------------------------------------
-- INDEX dbo.ANGELDEMATMSAJAGDeltrans
-- --------------------------------------------------
CREATE CLUSTERED INDEX [Sno] ON [dbo].[ANGELDEMATMSAJAGDeltrans] ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTBFOLedger
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTBFOLedger] ADD CONSTRAINT [PK_Ledger_1] PRIMARY KEY ([Vtyp], [Vno], [Lno], [Booktype])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTCURFOLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTCURFOLEDGER] ADD CONSTRAINT [PK1_LEDGER_nsecurfo] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTFOLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTFOLEDGER] ADD CONSTRAINT [PKK_LEDGER_accountfoledger] PRIMARY KEY ([VDT], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR], [CLTCODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTMCDXCDSLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTMCDXCDSLEDGER] ADD CONSTRAINT [PK_ACCOUNTMCDXCDSLEDGER] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTMCDXLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTMCDXLEDGER] ADD CONSTRAINT [PK_ACCOUNTMCDXLEDGER] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTNCDXLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCDXLEDGER] ADD CONSTRAINT [PK_ACCOUNTNCDXLedger] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ACCOUNTNCELEDGER] ADD CONSTRAINT [ACCOUNTNCELEDGER_PK1_LEDGER] PRIMARY KEY ([Vdt], [Cltcode], [Vtyp], [Vno], [Lno], [Booktype], [Drcr])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANAND1ACCOUNTLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ANAND1ACCOUNTLEDGER] ADD CONSTRAINT [PK_ANAND1ACCOUNTLedger] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANAND1MSAJAGCLIENT_BROK_DETAILS
-- --------------------------------------------------
ALTER TABLE [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS] ADD CONSTRAINT [ClientIdx] PRIMARY KEY ([Cl_Code], [Exchange], [Segment])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANAND1MSAJAGClient_Details
-- --------------------------------------------------
ALTER TABLE [dbo].[ANAND1MSAJAGClient_Details] ADD CONSTRAINT [PK_Client_Details] PRIMARY KEY ([party_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ANAND1MTFTRADELEDGER] ADD CONSTRAINT [PK1_ANAND1MTFTRADELEDGER] PRIMARY KEY ([vdt], [cltcode], [vtyp], [vno], [lno], [BookType], [drcr])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANANDACCOUNT_ABLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[ANANDACCOUNT_ABLEDGER] ADD CONSTRAINT [PK1_LEDGER] PRIMARY KEY ([VDT], [CLTCODE], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.AngelCommodityAccountCurBFOLEDGER
-- --------------------------------------------------
ALTER TABLE [dbo].[AngelCommodityAccountCurBFOLEDGER] ADD CONSTRAINT [PKK_LEDGER] PRIMARY KEY ([VDT], [VTYP], [VNO], [LNO], [BOOKTYPE], [DRCR], [CLTCODE])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.AngelCommodityAccountCurBFOLedger1
-- --------------------------------------------------
ALTER TABLE [dbo].[AngelCommodityAccountCurBFOLedger1] ADD CONSTRAINT [PK_Ledger1_nsecurfo] PRIMARY KEY ([L1_SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.AngelCommodityAccountCurBFOLedger2
-- --------------------------------------------------
ALTER TABLE [dbo].[AngelCommodityAccountCurBFOLedger2] ADD CONSTRAINT [PK1_LEDGER2_Bsecurfo] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANGELDEMATBSEDBClient4
-- --------------------------------------------------
ALTER TABLE [dbo].[ANGELDEMATBSEDBClient4] ADD CONSTRAINT [PK1_ANGELDEMATBSEDBClient4] PRIMARY KEY ([Cl_code], [Party_code], [Instru], [BankID], [Cltdpid], [Depository], [DefDp])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANGELDEMATBSEDBDeltrans
-- --------------------------------------------------
ALTER TABLE [dbo].[ANGELDEMATBSEDBDeltrans] ADD CONSTRAINT [PK_ANGELDEMATBSEDBDeltrans] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANGELDEMATMSAJAGClient4
-- --------------------------------------------------
ALTER TABLE [dbo].[ANGELDEMATMSAJAGClient4] ADD CONSTRAINT [PK1_ANGELDEMATMSAJAGClient4] PRIMARY KEY ([Cl_code], [Party_code], [Instru], [BankID], [Cltdpid], [Depository], [DefDp])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ANGELDEMATMSAJAGDeltrans
-- --------------------------------------------------
ALTER TABLE [dbo].[ANGELDEMATMSAJAGDeltrans] ADD CONSTRAINT [PK_ANGELDEMATMSAJAGDeltrans] PRIMARY KEY ([SNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.AngelFOAccountFOLedger1
-- --------------------------------------------------
ALTER TABLE [dbo].[AngelFOAccountFOLedger1] ADD CONSTRAINT [PK_ledger1_nsefo] PRIMARY KEY ([L1_SNo])

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
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTBFOLedger_15June_2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTBFOLedger_15June_2024]
		@pkc1 smallint,
		@pkc2 varchar(12),
		@pkc3 decimal(4,0),
		@pkc4 char(2)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTBFOLedger] 
	where [Vtyp] = @pkc1
  and [Vno] = @pkc2
  and [Lno] = @pkc3
  and [Booktype] = @pkc4
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc4,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTBFOLedger]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTMCDX_LEDGER_18June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTMCDX_LEDGER_18June2024]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTMCDXLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTMCDXCDSLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTMCDXCDSLEDGER_14Apr23]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTMCDXCDSLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTMCDXCDSLEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTMCDXCDSLEDGER_15June2024]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTMCDXCDSLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTMCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTMCDXLEDGER_14Apr23]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTMCDXLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTNCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTNCDXLEDGER_14Apr23]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTNCDXLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTNCDXLEDGER_15une2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTNCDXLEDGER_15une2024]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTNCDXLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboACCOUNTNCELEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboACCOUNTNCELEDGER_15June2024]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 char(2)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTNCELEDGER] 
	where [Vdt] = @pkc1
  and [Cltcode] = @pkc2
  and [Vtyp] = @pkc3
  and [Vno] = @pkc4
  and [Lno] = @pkc5
  and [Booktype] = @pkc6
  and [Drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[Cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[Drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCELEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANAND1ACCOUNTLEDGER_18Feb2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboANAND1ACCOUNTLEDGER_18Feb2024]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANAND1ACCOUNTLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1ACCOUNTLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANAND1LEDGER_msrepl_ccs
-- --------------------------------------------------
create procedure [dbo].[sp_MSdel_dboANAND1LEDGER_msrepl_ccs]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANAND1ACCOUNTLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024]
		@pkc1 varchar(10),
		@pkc2 varchar(3),
		@pkc3 varchar(7)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS] 
	where [Cl_Code] = @pkc1
  and [Exchange] = @pkc2
  and [Segment] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Cl_Code] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Exchange] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Segment] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANAND1MSAJAGClient_Details_17Feb2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboANAND1MSAJAGClient_Details_17Feb2024]
		@pkc1 varchar(10)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANAND1MSAJAGClient_Details] 
	where [party_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[party_code] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGClient_Details]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANAND1MTFTRADELEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSdel_dboANAND1MTFTRADELEDGER_17Feb24]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 char(2)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANAND1MTFTRADELEDGER] 
	where [vdt] = @pkc1
  and [cltcode] = @pkc2
  and [vtyp] = @pkc3
  and [vno] = @pkc4
  and [lno] = @pkc5
  and [BookType] = @pkc6
  and [drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BookType] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MTFTRADELEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANANDACCOUNT_ABLEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSdel_dboANANDACCOUNT_ABLEDGER_17Feb24]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANANDACCOUNT_ABLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDACCOUNT_ABLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboANANDBSEDB_ABCMBILLVALAN_17Feb24
-- --------------------------------------------------
create procedure [sp_MSdel_dboANANDBSEDB_ABCMBILLVALAN_17Feb24]
		@pkc1 varchar(7),
		@pkc2 varchar(3),
		@pkc8 varchar(15),
		@pkc4 varchar(10),
		@pkc5 varchar(12),
		@pkc6 varchar(3),
		@pkc3 datetime,
		@pkc7 varchar(10),
		@pkc9 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ANANDBSEDB_ABCMBILLVALAN] 
	where [SETT_NO] = @pkc1
  and [SETT_TYPE] = @pkc2
  and [SAUDA_DATE] = @pkc3
  and [PARTY_CODE] = @pkc4
  and [SCRIP_CD] = @pkc5
  and [SERIES] = @pkc6
  and [TERMINAL_ID] = @pkc7
  and [CONTRACTNO] = @pkc8
  and [TRADETYPE] = @pkc9
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SETT_NO] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SETT_TYPE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SAUDA_DATE] = ' + convert(nvarchar(100),@pkc3,21) + ', '
				set @primarykey_text = @primarykey_text + '[PARTY_CODE] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[SCRIP_CD] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[SERIES] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[TERMINAL_ID] = ' + convert(nvarchar(100),@pkc7,1) + ', '
				set @primarykey_text = @primarykey_text + '[CONTRACTNO] = ' + convert(nvarchar(100),@pkc8,1) + ', '
				set @primarykey_text = @primarykey_text + '[TRADETYPE] = ' + convert(nvarchar(100),@pkc9,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDBSEDB_ABCMBILLVALAN]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger_14Apr23]
		@pkc2 smallint,
		@pkc3 varchar(12),
		@pkc4 int,
		@pkc6 char(1),
		@pkc1 datetime,
		@pkc7 varchar(10),
		@pkc5 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger] 
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger_15June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger_15June2024]
		@pkc2 smallint,
		@pkc3 varchar(12),
		@pkc4 int,
		@pkc6 char(1),
		@pkc1 datetime,
		@pkc7 varchar(10),
		@pkc5 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger] 
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger1_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger1_14Apr23]
		@pkc1 bigint
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger1] 
	where [L1_SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[L1_SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger1]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger1_15June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger1_15June2024]
		@pkc1 bigint
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger1] 
	where [L1_SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[L1_SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger1]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger2_14Apr23
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger2_14Apr23]
		@pkc1 bigint
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger2] 
	where [SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger2]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboAngelcommodityAccountCurBFOledger2_15June2024
-- --------------------------------------------------
create procedure [sp_MSdel_dboAngelcommodityAccountCurBFOledger2_15June2024]
		@pkc1 bigint
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[AngelcommodityAccountCurBFOledger2] 
	where [SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger2]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboLEDGER_04Feb24_1759
-- --------------------------------------------------
create procedure [sp_MSdel_dboLEDGER_04Feb24_1759]
		@pkc3 smallint,
		@pkc4 varchar(12),
		@pkc5 int,
		@pkc7 char(1),
		@pkc1 datetime,
		@pkc2 varchar(10),
		@pkc6 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTCURFOLEDGER] 
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTCURFOLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSdel_dboLEDGER_04Feb24_1817
-- --------------------------------------------------
create procedure [sp_MSdel_dboLEDGER_04Feb24_1817]
		@pkc2 smallint,
		@pkc3 varchar(12),
		@pkc4 int,
		@pkc6 char(1),
		@pkc1 datetime,
		@pkc7 varchar(10),
		@pkc5 varchar(3)
as
begin  

	declare @primarykey_text nvarchar(100) = ''
	delete [dbo].[ACCOUNTFOLEDGER] 
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTFOLEDGER]', @param2=@primarykey_text, @param3=13234 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTBFOLedger_15June_2024
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTBFOLedger_15June_2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 decimal(4,0),
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 char(2),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(500),
    @c21 int
as
begin  
	insert into [dbo].[ACCOUNTBFOLedger] (
		[Vtyp],
		[Vno],
		[Edt],
		[Lno],
		[Acname],
		[Drcr],
		[Vamt],
		[Vdt],
		[Vno1],
		[Refno],
		[Balamt],
		[Nodays],
		[Cdt],
		[Cltcode],
		[Booktype],
		[Enteredby],
		[Pdt],
		[Checkedby],
		[Actnodays],
		[Narration],
		[SNO]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTMCDX_LEDGER_18June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTMCDX_LEDGER_18June2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTMCDXLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTMCDXCDSLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTMCDXCDSLEDGER_14Apr23]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTMCDXCDSLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTMCDXCDSLEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTMCDXCDSLEDGER_15June2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTMCDXCDSLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTMCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTMCDXLEDGER_14Apr23]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTMCDXLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTNCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTNCDXLEDGER_14Apr23]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTNCDXLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTNCDXLEDGER_15une2024
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTNCDXLEDGER_15une2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTNCDXLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboACCOUNTNCELEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboACCOUNTNCELEDGER_15June2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 char(2),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(500),
    @c21 int
as
begin  
	insert into [dbo].[ACCOUNTNCELEDGER] (
		[Vtyp],
		[Vno],
		[Edt],
		[Lno],
		[Acname],
		[Drcr],
		[Vamt],
		[Vdt],
		[Vno1],
		[Refno],
		[Balamt],
		[Nodays],
		[Cdt],
		[Cltcode],
		[Booktype],
		[Enteredby],
		[Pdt],
		[Checkedby],
		[Actnodays],
		[Narration],
		[SNO]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANAND1ACCOUNTLEDGER_18Feb2024
-- --------------------------------------------------
create procedure [sp_MSins_dboANAND1ACCOUNTLEDGER_18Feb2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ANAND1ACCOUNTLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANAND1LEDGER_msrepl_ccs
-- --------------------------------------------------
create procedure [dbo].[sp_MSins_dboANAND1LEDGER_msrepl_ccs]
		@c1 smallint,
		@c2 varchar(12),
		@c3 datetime,
		@c4 int,
		@c5 varchar(100),
		@c6 char(1),
		@c7 money,
		@c8 datetime,
		@c9 varchar(12),
		@c10 char(12),
		@c11 money,
		@c12 int,
		@c13 datetime,
		@c14 varchar(10),
		@c15 varchar(3),
		@c16 varchar(25),
		@c17 datetime,
		@c18 varchar(25),
		@c19 int,
		@c20 varchar(255)
as
begin
if exists (select * 
             from [dbo].[ANAND1ACCOUNTLEDGER]
            where [VDT] = @c8
              and [CLTCODE] = @c14
              and [VTYP] = @c1
              and [VNO] = @c2
              and [LNO] = @c4
              and [BOOKTYPE] = @c15
              and [DRCR] = @c6)
begin
update [dbo].[ANAND1ACCOUNTLEDGER] set
		[EDT] = @c3,
		[ACNAME] = @c5,
		[VAMT] = @c7,
		[VNO1] = @c9,
		[REFNO] = @c10,
		[BALAMT] = @c11,
		[NODAYS] = @c12,
		[CDT] = @c13,
		[ENTEREDBY] = @c16,
		[PDT] = @c17,
		[CHECKEDBY] = @c18,
		[ACTNODAYS] = @c19,
		[NARRATION] = @c20
	where [VDT] = @c8
  and [CLTCODE] = @c14
  and [VTYP] = @c1
  and [VNO] = @c2
  and [LNO] = @c4
  and [BOOKTYPE] = @c15
  and [DRCR] = @c6
end
else
begin
	insert into [dbo].[ANAND1ACCOUNTLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024
-- --------------------------------------------------
create procedure [sp_MSins_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024]
    @c1 varchar(10),
    @c2 varchar(3),
    @c3 varchar(7),
    @c4 tinyint,
    @c5 int,
    @c6 int,
    @c7 tinyint,
    @c8 tinyint,
    @c9 int,
    @c10 datetime,
    @c11 tinyint,
    @c12 int,
    @c13 varchar(15),
    @c14 varchar(50),
    @c15 char(1),
    @c16 int,
    @c17 varchar(5),
    @c18 int,
    @c19 int,
    @c20 int,
    @c21 int,
    @c22 int,
    @c23 int,
    @c24 int,
    @c25 varchar(10),
    @c26 char(1),
    @c27 char(1),
    @c28 money,
    @c29 numeric(18,6),
    @c30 numeric(18,6),
    @c31 money,
    @c32 money,
    @c33 datetime,
    @c34 money,
    @c35 numeric(18,6),
    @c36 numeric(18,6),
    @c37 money,
    @c38 money,
    @c39 datetime,
    @c40 varchar(10),
    @c41 tinyint,
    @c42 int,
    @c43 int,
    @c44 int,
    @c45 int,
    @c46 int,
    @c47 int,
    @c48 smallint,
    @c49 smallint,
    @c50 smallint,
    @c51 smallint,
    @c52 smallint,
    @c53 char(1),
    @c54 datetime,
    @c55 varchar(25),
    @c56 tinyint,
    @c57 char(1),
    @c58 varchar(50),
    @c59 varchar(50),
    @c60 varchar(10),
    @c61 char(1),
    @c62 datetime,
    @c63 int,
    @c64 int,
    @c65 datetime,
    @c66 datetime,
    @c67 varchar(1),
    @c68 varchar(100),
    @c69 varchar(1)
as
begin  
	insert into [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS] (
		[Cl_Code],
		[Exchange],
		[Segment],
		[Brok_Scheme],
		[Trd_Brok],
		[Del_Brok],
		[Ser_Tax],
		[Ser_Tax_Method],
		[Credit_Limit],
		[InActive_From],
		[Print_Options],
		[No_Of_Copies],
		[Participant_Code],
		[Custodian_Code],
		[Inst_Contract],
		[Round_Style],
		[STP_Provider],
		[STP_Rp_Style],
		[Market_Type],
		[Multiplier],
		[Charged],
		[Maintenance],
		[Reqd_By_Exch],
		[Reqd_By_Broker],
		[Client_Rating],
		[Debit_Balance],
		[Inter_Sett],
		[TRD_STT],
		[Trd_Tran_Chrgs],
		[Trd_Sebi_Fees],
		[Trd_Stamp_Duty],
		[Trd_Other_Chrgs],
		[Trd_Eff_Dt],
		[Del_Stt],
		[Del_Tran_Chrgs],
		[Del_SEBI_Fees],
		[Del_Stamp_Duty],
		[Del_Other_Chrgs],
		[Del_Eff_Dt],
		[Rounding_Method],
		[Round_To_Digit],
		[Round_To_Paise],
		[Fut_Brok],
		[Fut_Opt_Brok],
		[Fut_Fut_Fin_Brok],
		[Fut_Opt_Exc],
		[Fut_Brok_Applicable],
		[Fut_Stt],
		[Fut_Tran_Chrgs],
		[Fut_Sebi_Fees],
		[Fut_Stamp_Duty],
		[Fut_Other_Chrgs],
		[Status],
		[Modifiedon],
		[Modifiedby],
		[Imp_Status],
		[Pay_B3B_Payment],
		[Pay_Bank_name],
		[Pay_Branch_name],
		[Pay_AC_No],
		[Pay_payment_Mode],
		[Brok_Eff_Date],
		[Inst_Trd_Brok],
		[Inst_Del_Brok],
		[SYSTEMDATE],
		[Active_Date],
		[CheckActiveClient],
		[Deactive_Remarks],
		[Deactive_value]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57,
		@c58,
		@c59,
		@c60,
		@c61,
		@c62,
		@c63,
		@c64,
		@c65,
		@c66,
		@c67,
		@c68,
		@c69	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANAND1MSAJAGClient_Details_17Feb2024
-- --------------------------------------------------
create procedure [sp_MSins_dboANAND1MSAJAGClient_Details_17Feb2024]
    @c1 varchar(10),
    @c2 varchar(10),
    @c3 varchar(10),
    @c4 varchar(10),
    @c5 varchar(20),
    @c6 varchar(100),
    @c7 varchar(21),
    @c8 varchar(40),
    @c9 varchar(40),
    @c10 varchar(40),
    @c11 varchar(50),
    @c12 varchar(40),
    @c13 varchar(15),
    @c14 varchar(10),
    @c15 varchar(50),
    @c16 varchar(50),
    @c17 varchar(25),
    @c18 varchar(15),
    @c19 varchar(15),
    @c20 varchar(15),
    @c21 varchar(15),
    @c22 varchar(40),
    @c23 varchar(15),
    @c24 varchar(50),
    @c25 varchar(3),
    @c26 varchar(3),
    @c27 varchar(10),
    @c28 varchar(50),
    @c29 varchar(10),
    @c30 varchar(50),
    @c31 varchar(40),
    @c32 varchar(50),
    @c33 varchar(50),
    @c34 varchar(50),
    @c35 varchar(15),
    @c36 varchar(10),
    @c37 varchar(15),
    @c38 varchar(230),
    @c39 char(1),
    @c40 datetime,
    @c41 varchar(30),
    @c42 varchar(30),
    @c43 tinyint,
    @c44 varchar(30),
    @c45 varchar(30),
    @c46 datetime,
    @c47 datetime,
    @c48 varchar(30),
    @c49 varchar(30),
    @c50 datetime,
    @c51 datetime,
    @c52 varchar(30),
    @c53 varchar(30),
    @c54 datetime,
    @c55 varchar(30),
    @c56 varchar(30),
    @c57 datetime,
    @c58 varchar(30),
    @c59 datetime,
    @c60 varchar(50),
    @c61 varchar(50),
    @c62 datetime,
    @c63 varchar(50),
    @c64 datetime,
    @c65 varchar(50),
    @c66 varchar(50),
    @c67 varchar(50),
    @c68 varchar(50),
    @c69 varchar(50),
    @c70 numeric(18,0),
    @c71 varchar(30),
    @c72 tinyint,
    @c73 tinyint,
    @c74 tinyint,
    @c75 tinyint,
    @c76 tinyint,
    @c77 tinyint,
    @c78 varchar(50),
    @c79 varchar(50),
    @c80 varchar(10),
    @c81 varchar(20),
    @c82 varchar(7),
    @c83 varchar(16),
    @c84 varchar(16),
    @c85 char(1),
    @c86 varchar(7),
    @c87 varchar(16),
    @c88 varchar(16),
    @c89 char(1),
    @c90 varchar(7),
    @c91 varchar(16),
    @c92 varchar(16),
    @c93 char(1),
    @c94 varchar(10),
    @c95 varchar(10),
    @c96 varchar(10),
    @c97 char(1),
    @c98 tinyint,
    @c99 varchar(25),
    @c100 datetime,
    @c101 numeric(18,0),
    @c102 varchar(12),
    @c103 varchar(12),
    @c104 varchar(10),
    @c105 varchar(200),
    @c106 varchar(20),
    @c107 varchar(10),
    @c108 int,
    @c109 int,
    @c110 varchar(10),
    @c111 varchar(10),
    @c112 varchar(5),
    @c113 varchar(5),
    @c114 varchar(5),
    @c115 varchar(5),
    @c116 varchar(5),
    @c117 varchar(20),
    @c118 varchar(100)
as
begin  
	insert into [dbo].[ANAND1MSAJAGClient_Details] (
		[cl_code],
		[branch_cd],
		[party_code],
		[sub_broker],
		[trader],
		[long_name],
		[short_name],
		[l_address1],
		[l_city],
		[l_address2],
		[l_state],
		[l_address3],
		[l_nation],
		[l_zip],
		[pan_gir_no],
		[ward_no],
		[sebi_regn_no],
		[res_phone1],
		[res_phone2],
		[off_phone1],
		[off_phone2],
		[mobile_pager],
		[fax],
		[email],
		[cl_type],
		[cl_status],
		[family],
		[region],
		[area],
		[p_address1],
		[p_city],
		[p_address2],
		[p_state],
		[p_address3],
		[p_nation],
		[p_zip],
		[p_phone],
		[addemailid],
		[sex],
		[dob],
		[introducer],
		[approver],
		[interactmode],
		[passport_no],
		[passport_issued_at],
		[passport_issued_on],
		[passport_expires_on],
		[licence_no],
		[licence_issued_at],
		[licence_issued_on],
		[licence_expires_on],
		[rat_card_no],
		[rat_card_issued_at],
		[rat_card_issued_on],
		[votersid_no],
		[votersid_issued_at],
		[votersid_issued_on],
		[it_return_yr],
		[it_return_filed_on],
		[regr_no],
		[regr_at],
		[regr_on],
		[regr_authority],
		[client_agreement_on],
		[sett_mode],
		[dealing_with_other_tm],
		[other_ac_no],
		[introducer_id],
		[introducer_relation],
		[repatriat_bank],
		[repatriat_bank_ac_no],
		[chk_kyc_form],
		[chk_corporate_deed],
		[chk_bank_certificate],
		[chk_annual_report],
		[chk_networth_cert],
		[chk_corp_dtls_recd],
		[Bank_Name],
		[Branch_Name],
		[AC_Type],
		[AC_Num],
		[Depository1],
		[DpId1],
		[CltDpId1],
		[Poa1],
		[Depository2],
		[DpId2],
		[CltDpId2],
		[Poa2],
		[Depository3],
		[DpId3],
		[CltDpId3],
		[Poa3],
		[rel_mgr],
		[c_group],
		[sbu],
		[Status],
		[Imp_Status],
		[ModifidedBy],
		[ModifidedOn],
		[Bank_id],
		[Mapin_id],
		[UCC_Code],
		[Micr_No],
		[Director_name],
		[paylocation],
		[FMCode],
		[INCOME_SLAB],
		[NETWORTH_SLAB],
		[PARENTCODE],
		[PRODUCTCODE],
		[RES_PHONE1_STD],
		[RES_PHONE2_STD],
		[OFF_PHONE1_STD],
		[OFF_PHONE2_STD],
		[P_PHONE_STD],
		[GST_NO],
		[GST_LOCATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57,
		@c58,
		@c59,
		@c60,
		@c61,
		@c62,
		@c63,
		@c64,
		@c65,
		@c66,
		@c67,
		@c68,
		@c69,
		@c70,
		@c71,
		@c72,
		@c73,
		@c74,
		@c75,
		@c76,
		@c77,
		@c78,
		@c79,
		@c80,
		@c81,
		@c82,
		@c83,
		@c84,
		@c85,
		@c86,
		@c87,
		@c88,
		@c89,
		@c90,
		@c91,
		@c92,
		@c93,
		@c94,
		@c95,
		@c96,
		@c97,
		@c98,
		@c99,
		@c100,
		@c101,
		@c102,
		@c103,
		@c104,
		@c105,
		@c106,
		@c107,
		@c108,
		@c109,
		@c110,
		@c111,
		@c112,
		@c113,
		@c114,
		@c115,
		@c116,
		@c117,
		@c118	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANAND1MTFTRADELEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSins_dboANAND1MTFTRADELEDGER_17Feb24]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 char(2),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(234)
as
begin  
	insert into [dbo].[ANAND1MTFTRADELEDGER] (
		[vtyp],
		[vno],
		[edt],
		[lno],
		[acname],
		[drcr],
		[vamt],
		[vdt],
		[vno1],
		[refno],
		[balamt],
		[NoDays],
		[cdt],
		[cltcode],
		[BookType],
		[EnteredBy],
		[pdt],
		[CheckedBy],
		[actnodays],
		[narration]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANANDACCOUNT_ABLEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSins_dboANANDACCOUNT_ABLEDGER_17Feb24]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ANANDACCOUNT_ABLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboANANDBSEDB_ABCMBILLVALAN_17Feb24
-- --------------------------------------------------
create procedure [sp_MSins_dboANANDBSEDB_ABCMBILLVALAN_17Feb24]
    @c1 varchar(7),
    @c2 varchar(3),
    @c3 varchar(10),
    @c4 varchar(15),
    @c5 varchar(10),
    @c6 varchar(100),
    @c7 varchar(12),
    @c8 varchar(3),
    @c9 varchar(50),
    @c10 varchar(12),
    @c11 datetime,
    @c12 int,
    @c13 money,
    @c14 int,
    @c15 money,
    @c16 int,
    @c17 money,
    @c18 int,
    @c19 money,
    @c20 money,
    @c21 money,
    @c22 money,
    @c23 money,
    @c24 varchar(10),
    @c25 varchar(100),
    @c26 varchar(10),
    @c27 varchar(10),
    @c28 varchar(3),
    @c29 varchar(20),
    @c30 varchar(10),
    @c31 varchar(10),
    @c32 varchar(15),
    @c33 money,
    @c34 money,
    @c35 money,
    @c36 money,
    @c37 money,
    @c38 money,
    @c39 smallint,
    @c40 money,
    @c41 money,
    @c42 money,
    @c43 money,
    @c44 money,
    @c45 money,
    @c46 money,
    @c47 varchar(50),
    @c48 varchar(11),
    @c49 varchar(11),
    @c50 varchar(11),
    @c51 varchar(15),
    @c52 varchar(5),
    @c53 varchar(10),
    @c54 varchar(3),
    @c55 varchar(100),
    @c56 varchar(1),
    @c57 varchar(1),
    @c58 varchar(1),
    @c59 money,
    @c60 money,
    @c61 varchar(20)
as
begin  
	insert into [dbo].[ANANDBSEDB_ABCMBILLVALAN] (
		[SETT_NO],
		[SETT_TYPE],
		[BILLNO],
		[CONTRACTNO],
		[PARTY_CODE],
		[PARTY_NAME],
		[SCRIP_CD],
		[SERIES],
		[SCRIP_NAME],
		[ISIN],
		[SAUDA_DATE],
		[PQTYTRD],
		[PAMTTRD],
		[PQTYDEL],
		[PAMTDEL],
		[SQTYTRD],
		[SAMTTRD],
		[SQTYDEL],
		[SAMTDEL],
		[PBROKTRD],
		[SBROKTRD],
		[PBROKDEL],
		[SBROKDEL],
		[FAMILY],
		[FAMILY_NAME],
		[TERMINAL_ID],
		[CLIENTTYPE],
		[TRADETYPE],
		[TRADER],
		[SUB_BROKER],
		[BRANCH_CD],
		[PARTICIPANTCODE],
		[PAMT],
		[SAMT],
		[PRATE],
		[SRATE],
		[TRDAMT],
		[DELAMT],
		[SERINEX],
		[SERVICE_TAX],
		[EXSERVICE_TAX],
		[TURN_TAX],
		[SEBI_TAX],
		[INS_CHRG],
		[BROKER_CHRG],
		[OTHER_CHRG],
		[REGION],
		[START_DATE],
		[END_DATE],
		[UPDATE_DATE],
		[STATUS_NAME],
		[EXCHANGE],
		[SEGMENT],
		[MEMBERTYPE],
		[COMPANYNAME],
		[DUMMY1],
		[DUMMY2],
		[DUMMY3],
		[DUMMY4],
		[DUMMY5],
		[AREA]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57,
		@c58,
		@c59,
		@c60,
		@c61	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger_14Apr23]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger_15June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger_15June2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger1_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger1_14Apr23]
    @c1 varchar(100),
    @c2 varchar(100),
    @c3 char(1),
    @c4 varchar(30),
    @c5 datetime,
    @c6 datetime,
    @c7 money,
    @c8 char(12),
    @c9 int,
    @c10 smallint,
    @c11 varchar(12),
    @c12 int,
    @c13 char(1),
    @c14 char(2),
    @c15 int,
    @c16 int,
    @c17 datetime,
    @c18 varchar(100),
    @c19 tinyint,
    @c20 char(1),
    @c21 bigint
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger1] (
		[Bnkname],
		[Brnname],
		[Dd],
		[Ddno],
		[Dddt],
		[Reldt],
		[Relamt],
		[Refno],
		[Receiptno],
		[Vtyp],
		[Vno],
		[Lno],
		[Drcr],
		[Booktype],
		[Micrno],
		[Slipno],
		[Slipdate],
		[Chequeinname],
		[Chqprinted],
		[Clear_mode],
		[L1_SNo]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger1_15June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger1_15June2024]
    @c1 varchar(100),
    @c2 varchar(100),
    @c3 char(1),
    @c4 varchar(30),
    @c5 datetime,
    @c6 datetime,
    @c7 money,
    @c8 char(12),
    @c9 int,
    @c10 smallint,
    @c11 varchar(12),
    @c12 int,
    @c13 char(1),
    @c14 char(2),
    @c15 int,
    @c16 int,
    @c17 datetime,
    @c18 varchar(100),
    @c19 tinyint,
    @c20 char(1),
    @c21 bigint
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger1] (
		[Bnkname],
		[Brnname],
		[Dd],
		[Ddno],
		[Dddt],
		[Reldt],
		[Relamt],
		[Refno],
		[Receiptno],
		[Vtyp],
		[Vno],
		[Lno],
		[Drcr],
		[Booktype],
		[Micrno],
		[Slipno],
		[Slipdate],
		[Chequeinname],
		[Chqprinted],
		[Clear_mode],
		[L1_SNo]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger2_14Apr23
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger2_14Apr23]
    @c1 smallint,
    @c2 varchar(12),
    @c3 bigint,
    @c4 char(1),
    @c5 money,
    @c6 smallint,
    @c7 char(2),
    @c8 varchar(10),
    @c9 bigint
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger2] (
		[Vtype],
		[Vno],
		[Lno],
		[Drcr],
		[Camt],
		[Costcode],
		[Booktype],
		[Cltcode],
		[SNo]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboAngelcommodityAccountCurBFOledger2_15June2024
-- --------------------------------------------------
create procedure [sp_MSins_dboAngelcommodityAccountCurBFOledger2_15June2024]
    @c1 smallint,
    @c2 varchar(12),
    @c3 bigint,
    @c4 char(1),
    @c5 money,
    @c6 smallint,
    @c7 char(2),
    @c8 varchar(10),
    @c9 bigint
as
begin  
	insert into [dbo].[AngelcommodityAccountCurBFOledger2] (
		[Vtype],
		[Vno],
		[Lno],
		[Drcr],
		[Camt],
		[Costcode],
		[Booktype],
		[Cltcode],
		[SNo]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboLEDGER_04Feb24_1759
-- --------------------------------------------------
create procedure [sp_MSins_dboLEDGER_04Feb24_1759]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTCURFOLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSins_dboLEDGER_04Feb24_1817
-- --------------------------------------------------
create procedure [sp_MSins_dboLEDGER_04Feb24_1817]
    @c1 smallint,
    @c2 varchar(12),
    @c3 datetime,
    @c4 int,
    @c5 varchar(100),
    @c6 char(1),
    @c7 money,
    @c8 datetime,
    @c9 varchar(12),
    @c10 char(12),
    @c11 money,
    @c12 int,
    @c13 datetime,
    @c14 varchar(10),
    @c15 varchar(3),
    @c16 varchar(25),
    @c17 datetime,
    @c18 varchar(25),
    @c19 int,
    @c20 varchar(255)
as
begin  
	insert into [dbo].[ACCOUNTFOLEDGER] (
		[VTYP],
		[VNO],
		[EDT],
		[LNO],
		[ACNAME],
		[DRCR],
		[VAMT],
		[VDT],
		[VNO1],
		[REFNO],
		[BALAMT],
		[NODAYS],
		[CDT],
		[CLTCODE],
		[BOOKTYPE],
		[ENTEREDBY],
		[PDT],
		[CHECKEDBY],
		[ACTNODAYS],
		[NARRATION]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTBFOLedger_15June_2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTBFOLedger_15June_2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 decimal(4,0) = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 char(2) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(500) = NULL,
		@c21 int = NULL,
		@pkc1 smallint = NULL,
		@pkc2 varchar(12) = NULL,
		@pkc3 decimal(4,0) = NULL,
		@pkc4 char(2) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64)
begin 

update [dbo].[ACCOUNTBFOLedger] set
		[Vtyp] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Vtyp] end,
		[Vno] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Vno] end,
		[Edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Edt] end,
		[Lno] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Lno] end,
		[Acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Acname] end,
		[Drcr] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Drcr] end,
		[Vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Vamt] end,
		[Vdt] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Vdt] end,
		[Vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Vno1] end,
		[Refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Refno] end,
		[Balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Balamt] end,
		[Nodays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Nodays] end,
		[Cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Cdt] end,
		[Cltcode] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Cltcode] end,
		[Booktype] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Booktype] end,
		[Enteredby] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Enteredby] end,
		[Pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Pdt] end,
		[Checkedby] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Checkedby] end,
		[Actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Actnodays] end,
		[Narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Narration] end
	where [Vtyp] = @pkc1
  and [Vno] = @pkc2
  and [Lno] = @pkc3
  and [Booktype] = @pkc4
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc4,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTBFOLedger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTBFOLedger] set
		[Edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Edt] end,
		[Acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Acname] end,
		[Drcr] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Drcr] end,
		[Vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Vamt] end,
		[Vdt] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Vdt] end,
		[Vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Vno1] end,
		[Refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Refno] end,
		[Balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Balamt] end,
		[Nodays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Nodays] end,
		[Cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Cdt] end,
		[Cltcode] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Cltcode] end,
		[Enteredby] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Enteredby] end,
		[Pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Pdt] end,
		[Checkedby] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Checkedby] end,
		[Actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Actnodays] end,
		[Narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Narration] end
	where [Vtyp] = @pkc1
  and [Vno] = @pkc2
  and [Lno] = @pkc3
  and [Booktype] = @pkc4
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc4,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTBFOLedger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTMCDX_LEDGER_18June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTMCDX_LEDGER_18June2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTMCDXLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTMCDXLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTMCDXCDSLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTMCDXCDSLEDGER_14Apr23]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTMCDXCDSLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTMCDXCDSLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTMCDXCDSLEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTMCDXCDSLEDGER_15June2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTMCDXCDSLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTMCDXCDSLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXCDSLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTMCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTMCDXLEDGER_14Apr23]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTMCDXLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTMCDXLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTMCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTNCDXLEDGER_15une2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTNCDXLEDGER_15une2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTNCDXLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTNCDXLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboACCOUNTNCELEDGER_15June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboACCOUNTNCELEDGER_15June2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 char(2) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(500) = NULL,
		@c21 int = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 char(2) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTNCELEDGER] set
		[Vtyp] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Vtyp] end,
		[Vno] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Vno] end,
		[Edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Edt] end,
		[Lno] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Lno] end,
		[Acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Acname] end,
		[Drcr] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Drcr] end,
		[Vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Vamt] end,
		[Vdt] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Vdt] end,
		[Vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Vno1] end,
		[Refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Refno] end,
		[Balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Balamt] end,
		[Nodays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Nodays] end,
		[Cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Cdt] end,
		[Cltcode] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Cltcode] end,
		[Booktype] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Booktype] end,
		[Enteredby] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Enteredby] end,
		[Pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Pdt] end,
		[Checkedby] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Checkedby] end,
		[Actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Actnodays] end,
		[Narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Narration] end
	where [Vdt] = @pkc1
  and [Cltcode] = @pkc2
  and [Vtyp] = @pkc3
  and [Vno] = @pkc4
  and [Lno] = @pkc5
  and [Booktype] = @pkc6
  and [Drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[Cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[Drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCELEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTNCELEDGER] set
		[Edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Edt] end,
		[Acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Acname] end,
		[Vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Vamt] end,
		[Vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Vno1] end,
		[Refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Refno] end,
		[Balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Balamt] end,
		[Nodays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Nodays] end,
		[Cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Cdt] end,
		[Enteredby] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Enteredby] end,
		[Pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Pdt] end,
		[Checkedby] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Checkedby] end,
		[Actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Actnodays] end,
		[Narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Narration] end
	where [Vdt] = @pkc1
  and [Cltcode] = @pkc2
  and [Vtyp] = @pkc3
  and [Vno] = @pkc4
  and [Lno] = @pkc5
  and [Booktype] = @pkc6
  and [Drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[Cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[Vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[Lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[Booktype] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[Drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCELEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANAND1ACCOUNTLEDGER_18Feb2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboANAND1ACCOUNTLEDGER_18Feb2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ANAND1ACCOUNTLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1ACCOUNTLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANAND1ACCOUNTLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1ACCOUNTLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboANAND1MSAJAGCLIENT_BROK_DETAILS_Feb_17_2024]
		@c1 varchar(10) = NULL,
		@c2 varchar(3) = NULL,
		@c3 varchar(7) = NULL,
		@c4 tinyint = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 tinyint = NULL,
		@c8 tinyint = NULL,
		@c9 int = NULL,
		@c10 datetime = NULL,
		@c11 tinyint = NULL,
		@c12 int = NULL,
		@c13 varchar(15) = NULL,
		@c14 varchar(50) = NULL,
		@c15 char(1) = NULL,
		@c16 int = NULL,
		@c17 varchar(5) = NULL,
		@c18 int = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 varchar(10) = NULL,
		@c26 char(1) = NULL,
		@c27 char(1) = NULL,
		@c28 money = NULL,
		@c29 numeric(18,6) = NULL,
		@c30 numeric(18,6) = NULL,
		@c31 money = NULL,
		@c32 money = NULL,
		@c33 datetime = NULL,
		@c34 money = NULL,
		@c35 numeric(18,6) = NULL,
		@c36 numeric(18,6) = NULL,
		@c37 money = NULL,
		@c38 money = NULL,
		@c39 datetime = NULL,
		@c40 varchar(10) = NULL,
		@c41 tinyint = NULL,
		@c42 int = NULL,
		@c43 int = NULL,
		@c44 int = NULL,
		@c45 int = NULL,
		@c46 int = NULL,
		@c47 int = NULL,
		@c48 smallint = NULL,
		@c49 smallint = NULL,
		@c50 smallint = NULL,
		@c51 smallint = NULL,
		@c52 smallint = NULL,
		@c53 char(1) = NULL,
		@c54 datetime = NULL,
		@c55 varchar(25) = NULL,
		@c56 tinyint = NULL,
		@c57 char(1) = NULL,
		@c58 varchar(50) = NULL,
		@c59 varchar(50) = NULL,
		@c60 varchar(10) = NULL,
		@c61 char(1) = NULL,
		@c62 datetime = NULL,
		@c63 int = NULL,
		@c64 int = NULL,
		@c65 datetime = NULL,
		@c66 datetime = NULL,
		@c67 varchar(1) = NULL,
		@c68 varchar(100) = NULL,
		@c69 varchar(1) = NULL,
		@pkc1 varchar(10) = NULL,
		@pkc2 varchar(3) = NULL,
		@pkc3 varchar(7) = NULL,
		@bitmap binary(9)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 4 = 4)
begin 

update [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS] set
		[Cl_Code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Cl_Code] end,
		[Exchange] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Exchange] end,
		[Segment] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Segment] end,
		[Brok_Scheme] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Brok_Scheme] end,
		[Trd_Brok] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Trd_Brok] end,
		[Del_Brok] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Del_Brok] end,
		[Ser_Tax] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Ser_Tax] end,
		[Ser_Tax_Method] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Ser_Tax_Method] end,
		[Credit_Limit] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Credit_Limit] end,
		[InActive_From] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InActive_From] end,
		[Print_Options] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Print_Options] end,
		[No_Of_Copies] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [No_Of_Copies] end,
		[Participant_Code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Participant_Code] end,
		[Custodian_Code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Custodian_Code] end,
		[Inst_Contract] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Inst_Contract] end,
		[Round_Style] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Round_Style] end,
		[STP_Provider] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [STP_Provider] end,
		[STP_Rp_Style] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [STP_Rp_Style] end,
		[Market_Type] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Market_Type] end,
		[Multiplier] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Multiplier] end,
		[Charged] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Charged] end,
		[Maintenance] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Maintenance] end,
		[Reqd_By_Exch] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [Reqd_By_Exch] end,
		[Reqd_By_Broker] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Reqd_By_Broker] end,
		[Client_Rating] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [Client_Rating] end,
		[Debit_Balance] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Debit_Balance] end,
		[Inter_Sett] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [Inter_Sett] end,
		[TRD_STT] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [TRD_STT] end,
		[Trd_Tran_Chrgs] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Trd_Tran_Chrgs] end,
		[Trd_Sebi_Fees] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [Trd_Sebi_Fees] end,
		[Trd_Stamp_Duty] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Trd_Stamp_Duty] end,
		[Trd_Other_Chrgs] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [Trd_Other_Chrgs] end,
		[Trd_Eff_Dt] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Trd_Eff_Dt] end,
		[Del_Stt] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Del_Stt] end,
		[Del_Tran_Chrgs] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Del_Tran_Chrgs] end,
		[Del_SEBI_Fees] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Del_SEBI_Fees] end,
		[Del_Stamp_Duty] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [Del_Stamp_Duty] end,
		[Del_Other_Chrgs] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [Del_Other_Chrgs] end,
		[Del_Eff_Dt] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [Del_Eff_Dt] end,
		[Rounding_Method] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [Rounding_Method] end,
		[Round_To_Digit] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [Round_To_Digit] end,
		[Round_To_Paise] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [Round_To_Paise] end,
		[Fut_Brok] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [Fut_Brok] end,
		[Fut_Opt_Brok] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [Fut_Opt_Brok] end,
		[Fut_Fut_Fin_Brok] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [Fut_Fut_Fin_Brok] end,
		[Fut_Opt_Exc] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [Fut_Opt_Exc] end,
		[Fut_Brok_Applicable] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [Fut_Brok_Applicable] end,
		[Fut_Stt] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [Fut_Stt] end,
		[Fut_Tran_Chrgs] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [Fut_Tran_Chrgs] end,
		[Fut_Sebi_Fees] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [Fut_Sebi_Fees] end,
		[Fut_Stamp_Duty] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [Fut_Stamp_Duty] end,
		[Fut_Other_Chrgs] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [Fut_Other_Chrgs] end,
		[Status] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [Status] end,
		[Modifiedon] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [Modifiedon] end,
		[Modifiedby] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [Modifiedby] end,
		[Imp_Status] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [Imp_Status] end,
		[Pay_B3B_Payment] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [Pay_B3B_Payment] end,
		[Pay_Bank_name] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [Pay_Bank_name] end,
		[Pay_Branch_name] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [Pay_Branch_name] end,
		[Pay_AC_No] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [Pay_AC_No] end,
		[Pay_payment_Mode] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [Pay_payment_Mode] end,
		[Brok_Eff_Date] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [Brok_Eff_Date] end,
		[Inst_Trd_Brok] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [Inst_Trd_Brok] end,
		[Inst_Del_Brok] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [Inst_Del_Brok] end,
		[SYSTEMDATE] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [SYSTEMDATE] end,
		[Active_Date] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [Active_Date] end,
		[CheckActiveClient] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [CheckActiveClient] end,
		[Deactive_Remarks] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [Deactive_Remarks] end,
		[Deactive_value] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [Deactive_value] end
	where [Cl_Code] = @pkc1
  and [Exchange] = @pkc2
  and [Segment] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Cl_Code] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Exchange] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Segment] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS] set
		[Brok_Scheme] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Brok_Scheme] end,
		[Trd_Brok] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Trd_Brok] end,
		[Del_Brok] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Del_Brok] end,
		[Ser_Tax] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Ser_Tax] end,
		[Ser_Tax_Method] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Ser_Tax_Method] end,
		[Credit_Limit] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Credit_Limit] end,
		[InActive_From] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InActive_From] end,
		[Print_Options] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Print_Options] end,
		[No_Of_Copies] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [No_Of_Copies] end,
		[Participant_Code] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Participant_Code] end,
		[Custodian_Code] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Custodian_Code] end,
		[Inst_Contract] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Inst_Contract] end,
		[Round_Style] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Round_Style] end,
		[STP_Provider] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [STP_Provider] end,
		[STP_Rp_Style] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [STP_Rp_Style] end,
		[Market_Type] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Market_Type] end,
		[Multiplier] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Multiplier] end,
		[Charged] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [Charged] end,
		[Maintenance] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [Maintenance] end,
		[Reqd_By_Exch] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [Reqd_By_Exch] end,
		[Reqd_By_Broker] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [Reqd_By_Broker] end,
		[Client_Rating] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [Client_Rating] end,
		[Debit_Balance] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [Debit_Balance] end,
		[Inter_Sett] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [Inter_Sett] end,
		[TRD_STT] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [TRD_STT] end,
		[Trd_Tran_Chrgs] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Trd_Tran_Chrgs] end,
		[Trd_Sebi_Fees] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [Trd_Sebi_Fees] end,
		[Trd_Stamp_Duty] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Trd_Stamp_Duty] end,
		[Trd_Other_Chrgs] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [Trd_Other_Chrgs] end,
		[Trd_Eff_Dt] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Trd_Eff_Dt] end,
		[Del_Stt] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [Del_Stt] end,
		[Del_Tran_Chrgs] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [Del_Tran_Chrgs] end,
		[Del_SEBI_Fees] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Del_SEBI_Fees] end,
		[Del_Stamp_Duty] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [Del_Stamp_Duty] end,
		[Del_Other_Chrgs] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [Del_Other_Chrgs] end,
		[Del_Eff_Dt] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [Del_Eff_Dt] end,
		[Rounding_Method] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [Rounding_Method] end,
		[Round_To_Digit] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [Round_To_Digit] end,
		[Round_To_Paise] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [Round_To_Paise] end,
		[Fut_Brok] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [Fut_Brok] end,
		[Fut_Opt_Brok] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [Fut_Opt_Brok] end,
		[Fut_Fut_Fin_Brok] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [Fut_Fut_Fin_Brok] end,
		[Fut_Opt_Exc] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [Fut_Opt_Exc] end,
		[Fut_Brok_Applicable] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [Fut_Brok_Applicable] end,
		[Fut_Stt] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [Fut_Stt] end,
		[Fut_Tran_Chrgs] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [Fut_Tran_Chrgs] end,
		[Fut_Sebi_Fees] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [Fut_Sebi_Fees] end,
		[Fut_Stamp_Duty] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [Fut_Stamp_Duty] end,
		[Fut_Other_Chrgs] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [Fut_Other_Chrgs] end,
		[Status] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [Status] end,
		[Modifiedon] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [Modifiedon] end,
		[Modifiedby] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [Modifiedby] end,
		[Imp_Status] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [Imp_Status] end,
		[Pay_B3B_Payment] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [Pay_B3B_Payment] end,
		[Pay_Bank_name] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [Pay_Bank_name] end,
		[Pay_Branch_name] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [Pay_Branch_name] end,
		[Pay_AC_No] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [Pay_AC_No] end,
		[Pay_payment_Mode] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [Pay_payment_Mode] end,
		[Brok_Eff_Date] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [Brok_Eff_Date] end,
		[Inst_Trd_Brok] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [Inst_Trd_Brok] end,
		[Inst_Del_Brok] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [Inst_Del_Brok] end,
		[SYSTEMDATE] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [SYSTEMDATE] end,
		[Active_Date] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [Active_Date] end,
		[CheckActiveClient] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [CheckActiveClient] end,
		[Deactive_Remarks] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [Deactive_Remarks] end,
		[Deactive_value] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [Deactive_value] end
	where [Cl_Code] = @pkc1
  and [Exchange] = @pkc2
  and [Segment] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[Cl_Code] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[Exchange] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[Segment] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANAND1MSAJAGClient_Details_17Feb2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboANAND1MSAJAGClient_Details_17Feb2024]
		@c1 varchar(10) = NULL,
		@c2 varchar(10) = NULL,
		@c3 varchar(10) = NULL,
		@c4 varchar(10) = NULL,
		@c5 varchar(20) = NULL,
		@c6 varchar(100) = NULL,
		@c7 varchar(21) = NULL,
		@c8 varchar(40) = NULL,
		@c9 varchar(40) = NULL,
		@c10 varchar(40) = NULL,
		@c11 varchar(50) = NULL,
		@c12 varchar(40) = NULL,
		@c13 varchar(15) = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(50) = NULL,
		@c16 varchar(50) = NULL,
		@c17 varchar(25) = NULL,
		@c18 varchar(15) = NULL,
		@c19 varchar(15) = NULL,
		@c20 varchar(15) = NULL,
		@c21 varchar(15) = NULL,
		@c22 varchar(40) = NULL,
		@c23 varchar(15) = NULL,
		@c24 varchar(50) = NULL,
		@c25 varchar(3) = NULL,
		@c26 varchar(3) = NULL,
		@c27 varchar(10) = NULL,
		@c28 varchar(50) = NULL,
		@c29 varchar(10) = NULL,
		@c30 varchar(50) = NULL,
		@c31 varchar(40) = NULL,
		@c32 varchar(50) = NULL,
		@c33 varchar(50) = NULL,
		@c34 varchar(50) = NULL,
		@c35 varchar(15) = NULL,
		@c36 varchar(10) = NULL,
		@c37 varchar(15) = NULL,
		@c38 varchar(230) = NULL,
		@c39 char(1) = NULL,
		@c40 datetime = NULL,
		@c41 varchar(30) = NULL,
		@c42 varchar(30) = NULL,
		@c43 tinyint = NULL,
		@c44 varchar(30) = NULL,
		@c45 varchar(30) = NULL,
		@c46 datetime = NULL,
		@c47 datetime = NULL,
		@c48 varchar(30) = NULL,
		@c49 varchar(30) = NULL,
		@c50 datetime = NULL,
		@c51 datetime = NULL,
		@c52 varchar(30) = NULL,
		@c53 varchar(30) = NULL,
		@c54 datetime = NULL,
		@c55 varchar(30) = NULL,
		@c56 varchar(30) = NULL,
		@c57 datetime = NULL,
		@c58 varchar(30) = NULL,
		@c59 datetime = NULL,
		@c60 varchar(50) = NULL,
		@c61 varchar(50) = NULL,
		@c62 datetime = NULL,
		@c63 varchar(50) = NULL,
		@c64 datetime = NULL,
		@c65 varchar(50) = NULL,
		@c66 varchar(50) = NULL,
		@c67 varchar(50) = NULL,
		@c68 varchar(50) = NULL,
		@c69 varchar(50) = NULL,
		@c70 numeric(18,0) = NULL,
		@c71 varchar(30) = NULL,
		@c72 tinyint = NULL,
		@c73 tinyint = NULL,
		@c74 tinyint = NULL,
		@c75 tinyint = NULL,
		@c76 tinyint = NULL,
		@c77 tinyint = NULL,
		@c78 varchar(50) = NULL,
		@c79 varchar(50) = NULL,
		@c80 varchar(10) = NULL,
		@c81 varchar(20) = NULL,
		@c82 varchar(7) = NULL,
		@c83 varchar(16) = NULL,
		@c84 varchar(16) = NULL,
		@c85 char(1) = NULL,
		@c86 varchar(7) = NULL,
		@c87 varchar(16) = NULL,
		@c88 varchar(16) = NULL,
		@c89 char(1) = NULL,
		@c90 varchar(7) = NULL,
		@c91 varchar(16) = NULL,
		@c92 varchar(16) = NULL,
		@c93 char(1) = NULL,
		@c94 varchar(10) = NULL,
		@c95 varchar(10) = NULL,
		@c96 varchar(10) = NULL,
		@c97 char(1) = NULL,
		@c98 tinyint = NULL,
		@c99 varchar(25) = NULL,
		@c100 datetime = NULL,
		@c101 numeric(18,0) = NULL,
		@c102 varchar(12) = NULL,
		@c103 varchar(12) = NULL,
		@c104 varchar(10) = NULL,
		@c105 varchar(200) = NULL,
		@c106 varchar(20) = NULL,
		@c107 varchar(10) = NULL,
		@c108 int = NULL,
		@c109 int = NULL,
		@c110 varchar(10) = NULL,
		@c111 varchar(10) = NULL,
		@c112 varchar(5) = NULL,
		@c113 varchar(5) = NULL,
		@c114 varchar(5) = NULL,
		@c115 varchar(5) = NULL,
		@c116 varchar(5) = NULL,
		@c117 varchar(20) = NULL,
		@c118 varchar(100) = NULL,
		@pkc1 varchar(10) = NULL,
		@bitmap binary(15)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 4 = 4)
begin 

update [dbo].[ANAND1MSAJAGClient_Details] set
		[cl_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [cl_code] end,
		[branch_cd] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [branch_cd] end,
		[party_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [party_code] end,
		[sub_broker] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [sub_broker] end,
		[trader] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [trader] end,
		[long_name] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [long_name] end,
		[short_name] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [short_name] end,
		[l_address1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [l_address1] end,
		[l_city] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [l_city] end,
		[l_address2] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [l_address2] end,
		[l_state] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [l_state] end,
		[l_address3] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [l_address3] end,
		[l_nation] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [l_nation] end,
		[l_zip] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [l_zip] end,
		[pan_gir_no] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pan_gir_no] end,
		[ward_no] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ward_no] end,
		[sebi_regn_no] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [sebi_regn_no] end,
		[res_phone1] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [res_phone1] end,
		[res_phone2] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [res_phone2] end,
		[off_phone1] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [off_phone1] end,
		[off_phone2] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [off_phone2] end,
		[mobile_pager] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [mobile_pager] end,
		[fax] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [fax] end,
		[email] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [email] end,
		[cl_type] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cl_type] end,
		[cl_status] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [cl_status] end,
		[family] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [family] end,
		[region] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [region] end,
		[area] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [area] end,
		[p_address1] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [p_address1] end,
		[p_city] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [p_city] end,
		[p_address2] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [p_address2] end,
		[p_state] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [p_state] end,
		[p_address3] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [p_address3] end,
		[p_nation] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [p_nation] end,
		[p_zip] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [p_zip] end,
		[p_phone] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [p_phone] end,
		[addemailid] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [addemailid] end,
		[sex] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [sex] end,
		[dob] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [dob] end,
		[introducer] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [introducer] end,
		[approver] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [approver] end,
		[interactmode] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [interactmode] end,
		[passport_no] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [passport_no] end,
		[passport_issued_at] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [passport_issued_at] end,
		[passport_issued_on] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [passport_issued_on] end,
		[passport_expires_on] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [passport_expires_on] end,
		[licence_no] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [licence_no] end,
		[licence_issued_at] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [licence_issued_at] end,
		[licence_issued_on] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [licence_issued_on] end,
		[licence_expires_on] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [licence_expires_on] end,
		[rat_card_no] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [rat_card_no] end,
		[rat_card_issued_at] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [rat_card_issued_at] end,
		[rat_card_issued_on] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [rat_card_issued_on] end,
		[votersid_no] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [votersid_no] end,
		[votersid_issued_at] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [votersid_issued_at] end,
		[votersid_issued_on] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [votersid_issued_on] end,
		[it_return_yr] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [it_return_yr] end,
		[it_return_filed_on] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [it_return_filed_on] end,
		[regr_no] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [regr_no] end,
		[regr_at] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [regr_at] end,
		[regr_on] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [regr_on] end,
		[regr_authority] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [regr_authority] end,
		[client_agreement_on] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [client_agreement_on] end,
		[sett_mode] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [sett_mode] end,
		[dealing_with_other_tm] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [dealing_with_other_tm] end,
		[other_ac_no] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [other_ac_no] end,
		[introducer_id] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [introducer_id] end,
		[introducer_relation] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [introducer_relation] end,
		[repatriat_bank] = case substring(@bitmap,9,1) & 32 when 32 then @c70 else [repatriat_bank] end,
		[repatriat_bank_ac_no] = case substring(@bitmap,9,1) & 64 when 64 then @c71 else [repatriat_bank_ac_no] end,
		[chk_kyc_form] = case substring(@bitmap,9,1) & 128 when 128 then @c72 else [chk_kyc_form] end,
		[chk_corporate_deed] = case substring(@bitmap,10,1) & 1 when 1 then @c73 else [chk_corporate_deed] end,
		[chk_bank_certificate] = case substring(@bitmap,10,1) & 2 when 2 then @c74 else [chk_bank_certificate] end,
		[chk_annual_report] = case substring(@bitmap,10,1) & 4 when 4 then @c75 else [chk_annual_report] end,
		[chk_networth_cert] = case substring(@bitmap,10,1) & 8 when 8 then @c76 else [chk_networth_cert] end,
		[chk_corp_dtls_recd] = case substring(@bitmap,10,1) & 16 when 16 then @c77 else [chk_corp_dtls_recd] end,
		[Bank_Name] = case substring(@bitmap,10,1) & 32 when 32 then @c78 else [Bank_Name] end,
		[Branch_Name] = case substring(@bitmap,10,1) & 64 when 64 then @c79 else [Branch_Name] end,
		[AC_Type] = case substring(@bitmap,10,1) & 128 when 128 then @c80 else [AC_Type] end,
		[AC_Num] = case substring(@bitmap,11,1) & 1 when 1 then @c81 else [AC_Num] end,
		[Depository1] = case substring(@bitmap,11,1) & 2 when 2 then @c82 else [Depository1] end,
		[DpId1] = case substring(@bitmap,11,1) & 4 when 4 then @c83 else [DpId1] end,
		[CltDpId1] = case substring(@bitmap,11,1) & 8 when 8 then @c84 else [CltDpId1] end,
		[Poa1] = case substring(@bitmap,11,1) & 16 when 16 then @c85 else [Poa1] end,
		[Depository2] = case substring(@bitmap,11,1) & 32 when 32 then @c86 else [Depository2] end,
		[DpId2] = case substring(@bitmap,11,1) & 64 when 64 then @c87 else [DpId2] end,
		[CltDpId2] = case substring(@bitmap,11,1) & 128 when 128 then @c88 else [CltDpId2] end,
		[Poa2] = case substring(@bitmap,12,1) & 1 when 1 then @c89 else [Poa2] end,
		[Depository3] = case substring(@bitmap,12,1) & 2 when 2 then @c90 else [Depository3] end,
		[DpId3] = case substring(@bitmap,12,1) & 4 when 4 then @c91 else [DpId3] end,
		[CltDpId3] = case substring(@bitmap,12,1) & 8 when 8 then @c92 else [CltDpId3] end,
		[Poa3] = case substring(@bitmap,12,1) & 16 when 16 then @c93 else [Poa3] end,
		[rel_mgr] = case substring(@bitmap,12,1) & 32 when 32 then @c94 else [rel_mgr] end,
		[c_group] = case substring(@bitmap,12,1) & 64 when 64 then @c95 else [c_group] end,
		[sbu] = case substring(@bitmap,12,1) & 128 when 128 then @c96 else [sbu] end,
		[Status] = case substring(@bitmap,13,1) & 1 when 1 then @c97 else [Status] end,
		[Imp_Status] = case substring(@bitmap,13,1) & 2 when 2 then @c98 else [Imp_Status] end,
		[ModifidedBy] = case substring(@bitmap,13,1) & 4 when 4 then @c99 else [ModifidedBy] end,
		[ModifidedOn] = case substring(@bitmap,13,1) & 8 when 8 then @c100 else [ModifidedOn] end,
		[Bank_id] = case substring(@bitmap,13,1) & 16 when 16 then @c101 else [Bank_id] end,
		[Mapin_id] = case substring(@bitmap,13,1) & 32 when 32 then @c102 else [Mapin_id] end,
		[UCC_Code] = case substring(@bitmap,13,1) & 64 when 64 then @c103 else [UCC_Code] end,
		[Micr_No] = case substring(@bitmap,13,1) & 128 when 128 then @c104 else [Micr_No] end,
		[Director_name] = case substring(@bitmap,14,1) & 1 when 1 then @c105 else [Director_name] end,
		[paylocation] = case substring(@bitmap,14,1) & 2 when 2 then @c106 else [paylocation] end,
		[FMCode] = case substring(@bitmap,14,1) & 4 when 4 then @c107 else [FMCode] end,
		[INCOME_SLAB] = case substring(@bitmap,14,1) & 8 when 8 then @c108 else [INCOME_SLAB] end,
		[NETWORTH_SLAB] = case substring(@bitmap,14,1) & 16 when 16 then @c109 else [NETWORTH_SLAB] end,
		[PARENTCODE] = case substring(@bitmap,14,1) & 32 when 32 then @c110 else [PARENTCODE] end,
		[PRODUCTCODE] = case substring(@bitmap,14,1) & 64 when 64 then @c111 else [PRODUCTCODE] end,
		[RES_PHONE1_STD] = case substring(@bitmap,14,1) & 128 when 128 then @c112 else [RES_PHONE1_STD] end,
		[RES_PHONE2_STD] = case substring(@bitmap,15,1) & 1 when 1 then @c113 else [RES_PHONE2_STD] end,
		[OFF_PHONE1_STD] = case substring(@bitmap,15,1) & 2 when 2 then @c114 else [OFF_PHONE1_STD] end,
		[OFF_PHONE2_STD] = case substring(@bitmap,15,1) & 4 when 4 then @c115 else [OFF_PHONE2_STD] end,
		[P_PHONE_STD] = case substring(@bitmap,15,1) & 8 when 8 then @c116 else [P_PHONE_STD] end,
		[GST_NO] = case substring(@bitmap,15,1) & 16 when 16 then @c117 else [GST_NO] end,
		[GST_LOCATION] = case substring(@bitmap,15,1) & 32 when 32 then @c118 else [GST_LOCATION] end
	where [party_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[party_code] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGClient_Details]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANAND1MSAJAGClient_Details] set
		[cl_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [cl_code] end,
		[branch_cd] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [branch_cd] end,
		[sub_broker] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [sub_broker] end,
		[trader] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [trader] end,
		[long_name] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [long_name] end,
		[short_name] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [short_name] end,
		[l_address1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [l_address1] end,
		[l_city] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [l_city] end,
		[l_address2] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [l_address2] end,
		[l_state] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [l_state] end,
		[l_address3] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [l_address3] end,
		[l_nation] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [l_nation] end,
		[l_zip] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [l_zip] end,
		[pan_gir_no] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pan_gir_no] end,
		[ward_no] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ward_no] end,
		[sebi_regn_no] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [sebi_regn_no] end,
		[res_phone1] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [res_phone1] end,
		[res_phone2] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [res_phone2] end,
		[off_phone1] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [off_phone1] end,
		[off_phone2] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [off_phone2] end,
		[mobile_pager] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [mobile_pager] end,
		[fax] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [fax] end,
		[email] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [email] end,
		[cl_type] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cl_type] end,
		[cl_status] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [cl_status] end,
		[family] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [family] end,
		[region] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [region] end,
		[area] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [area] end,
		[p_address1] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [p_address1] end,
		[p_city] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [p_city] end,
		[p_address2] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [p_address2] end,
		[p_state] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [p_state] end,
		[p_address3] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [p_address3] end,
		[p_nation] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [p_nation] end,
		[p_zip] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [p_zip] end,
		[p_phone] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [p_phone] end,
		[addemailid] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [addemailid] end,
		[sex] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [sex] end,
		[dob] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [dob] end,
		[introducer] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [introducer] end,
		[approver] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [approver] end,
		[interactmode] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [interactmode] end,
		[passport_no] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [passport_no] end,
		[passport_issued_at] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [passport_issued_at] end,
		[passport_issued_on] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [passport_issued_on] end,
		[passport_expires_on] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [passport_expires_on] end,
		[licence_no] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [licence_no] end,
		[licence_issued_at] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [licence_issued_at] end,
		[licence_issued_on] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [licence_issued_on] end,
		[licence_expires_on] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [licence_expires_on] end,
		[rat_card_no] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [rat_card_no] end,
		[rat_card_issued_at] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [rat_card_issued_at] end,
		[rat_card_issued_on] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [rat_card_issued_on] end,
		[votersid_no] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [votersid_no] end,
		[votersid_issued_at] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [votersid_issued_at] end,
		[votersid_issued_on] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [votersid_issued_on] end,
		[it_return_yr] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [it_return_yr] end,
		[it_return_filed_on] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [it_return_filed_on] end,
		[regr_no] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [regr_no] end,
		[regr_at] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [regr_at] end,
		[regr_on] = case substring(@bitmap,8,1) & 32 when 32 then @c62 else [regr_on] end,
		[regr_authority] = case substring(@bitmap,8,1) & 64 when 64 then @c63 else [regr_authority] end,
		[client_agreement_on] = case substring(@bitmap,8,1) & 128 when 128 then @c64 else [client_agreement_on] end,
		[sett_mode] = case substring(@bitmap,9,1) & 1 when 1 then @c65 else [sett_mode] end,
		[dealing_with_other_tm] = case substring(@bitmap,9,1) & 2 when 2 then @c66 else [dealing_with_other_tm] end,
		[other_ac_no] = case substring(@bitmap,9,1) & 4 when 4 then @c67 else [other_ac_no] end,
		[introducer_id] = case substring(@bitmap,9,1) & 8 when 8 then @c68 else [introducer_id] end,
		[introducer_relation] = case substring(@bitmap,9,1) & 16 when 16 then @c69 else [introducer_relation] end,
		[repatriat_bank] = case substring(@bitmap,9,1) & 32 when 32 then @c70 else [repatriat_bank] end,
		[repatriat_bank_ac_no] = case substring(@bitmap,9,1) & 64 when 64 then @c71 else [repatriat_bank_ac_no] end,
		[chk_kyc_form] = case substring(@bitmap,9,1) & 128 when 128 then @c72 else [chk_kyc_form] end,
		[chk_corporate_deed] = case substring(@bitmap,10,1) & 1 when 1 then @c73 else [chk_corporate_deed] end,
		[chk_bank_certificate] = case substring(@bitmap,10,1) & 2 when 2 then @c74 else [chk_bank_certificate] end,
		[chk_annual_report] = case substring(@bitmap,10,1) & 4 when 4 then @c75 else [chk_annual_report] end,
		[chk_networth_cert] = case substring(@bitmap,10,1) & 8 when 8 then @c76 else [chk_networth_cert] end,
		[chk_corp_dtls_recd] = case substring(@bitmap,10,1) & 16 when 16 then @c77 else [chk_corp_dtls_recd] end,
		[Bank_Name] = case substring(@bitmap,10,1) & 32 when 32 then @c78 else [Bank_Name] end,
		[Branch_Name] = case substring(@bitmap,10,1) & 64 when 64 then @c79 else [Branch_Name] end,
		[AC_Type] = case substring(@bitmap,10,1) & 128 when 128 then @c80 else [AC_Type] end,
		[AC_Num] = case substring(@bitmap,11,1) & 1 when 1 then @c81 else [AC_Num] end,
		[Depository1] = case substring(@bitmap,11,1) & 2 when 2 then @c82 else [Depository1] end,
		[DpId1] = case substring(@bitmap,11,1) & 4 when 4 then @c83 else [DpId1] end,
		[CltDpId1] = case substring(@bitmap,11,1) & 8 when 8 then @c84 else [CltDpId1] end,
		[Poa1] = case substring(@bitmap,11,1) & 16 when 16 then @c85 else [Poa1] end,
		[Depository2] = case substring(@bitmap,11,1) & 32 when 32 then @c86 else [Depository2] end,
		[DpId2] = case substring(@bitmap,11,1) & 64 when 64 then @c87 else [DpId2] end,
		[CltDpId2] = case substring(@bitmap,11,1) & 128 when 128 then @c88 else [CltDpId2] end,
		[Poa2] = case substring(@bitmap,12,1) & 1 when 1 then @c89 else [Poa2] end,
		[Depository3] = case substring(@bitmap,12,1) & 2 when 2 then @c90 else [Depository3] end,
		[DpId3] = case substring(@bitmap,12,1) & 4 when 4 then @c91 else [DpId3] end,
		[CltDpId3] = case substring(@bitmap,12,1) & 8 when 8 then @c92 else [CltDpId3] end,
		[Poa3] = case substring(@bitmap,12,1) & 16 when 16 then @c93 else [Poa3] end,
		[rel_mgr] = case substring(@bitmap,12,1) & 32 when 32 then @c94 else [rel_mgr] end,
		[c_group] = case substring(@bitmap,12,1) & 64 when 64 then @c95 else [c_group] end,
		[sbu] = case substring(@bitmap,12,1) & 128 when 128 then @c96 else [sbu] end,
		[Status] = case substring(@bitmap,13,1) & 1 when 1 then @c97 else [Status] end,
		[Imp_Status] = case substring(@bitmap,13,1) & 2 when 2 then @c98 else [Imp_Status] end,
		[ModifidedBy] = case substring(@bitmap,13,1) & 4 when 4 then @c99 else [ModifidedBy] end,
		[ModifidedOn] = case substring(@bitmap,13,1) & 8 when 8 then @c100 else [ModifidedOn] end,
		[Bank_id] = case substring(@bitmap,13,1) & 16 when 16 then @c101 else [Bank_id] end,
		[Mapin_id] = case substring(@bitmap,13,1) & 32 when 32 then @c102 else [Mapin_id] end,
		[UCC_Code] = case substring(@bitmap,13,1) & 64 when 64 then @c103 else [UCC_Code] end,
		[Micr_No] = case substring(@bitmap,13,1) & 128 when 128 then @c104 else [Micr_No] end,
		[Director_name] = case substring(@bitmap,14,1) & 1 when 1 then @c105 else [Director_name] end,
		[paylocation] = case substring(@bitmap,14,1) & 2 when 2 then @c106 else [paylocation] end,
		[FMCode] = case substring(@bitmap,14,1) & 4 when 4 then @c107 else [FMCode] end,
		[INCOME_SLAB] = case substring(@bitmap,14,1) & 8 when 8 then @c108 else [INCOME_SLAB] end,
		[NETWORTH_SLAB] = case substring(@bitmap,14,1) & 16 when 16 then @c109 else [NETWORTH_SLAB] end,
		[PARENTCODE] = case substring(@bitmap,14,1) & 32 when 32 then @c110 else [PARENTCODE] end,
		[PRODUCTCODE] = case substring(@bitmap,14,1) & 64 when 64 then @c111 else [PRODUCTCODE] end,
		[RES_PHONE1_STD] = case substring(@bitmap,14,1) & 128 when 128 then @c112 else [RES_PHONE1_STD] end,
		[RES_PHONE2_STD] = case substring(@bitmap,15,1) & 1 when 1 then @c113 else [RES_PHONE2_STD] end,
		[OFF_PHONE1_STD] = case substring(@bitmap,15,1) & 2 when 2 then @c114 else [OFF_PHONE1_STD] end,
		[OFF_PHONE2_STD] = case substring(@bitmap,15,1) & 4 when 4 then @c115 else [OFF_PHONE2_STD] end,
		[P_PHONE_STD] = case substring(@bitmap,15,1) & 8 when 8 then @c116 else [P_PHONE_STD] end,
		[GST_NO] = case substring(@bitmap,15,1) & 16 when 16 then @c117 else [GST_NO] end,
		[GST_LOCATION] = case substring(@bitmap,15,1) & 32 when 32 then @c118 else [GST_LOCATION] end
	where [party_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[party_code] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MSAJAGClient_Details]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANAND1MTFTRADELEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSupd_dboANAND1MTFTRADELEDGER_17Feb24]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 char(2) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(234) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 char(2) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ANAND1MTFTRADELEDGER] set
		[vtyp] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [vtyp] end,
		[vno] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [vno] end,
		[edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [edt] end,
		[lno] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [lno] end,
		[acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [acname] end,
		[drcr] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [drcr] end,
		[vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [vamt] end,
		[vdt] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [vdt] end,
		[vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [vno1] end,
		[refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [refno] end,
		[balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [balamt] end,
		[NoDays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NoDays] end,
		[cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cdt] end,
		[cltcode] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [cltcode] end,
		[BookType] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BookType] end,
		[EnteredBy] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [EnteredBy] end,
		[pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [pdt] end,
		[CheckedBy] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CheckedBy] end,
		[actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [actnodays] end,
		[narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [narration] end
	where [vdt] = @pkc1
  and [cltcode] = @pkc2
  and [vtyp] = @pkc3
  and [vno] = @pkc4
  and [lno] = @pkc5
  and [BookType] = @pkc6
  and [drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BookType] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MTFTRADELEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANAND1MTFTRADELEDGER] set
		[edt] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [edt] end,
		[acname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [acname] end,
		[vamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [vamt] end,
		[vno1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [vno1] end,
		[refno] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [refno] end,
		[balamt] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [balamt] end,
		[NoDays] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NoDays] end,
		[cdt] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [cdt] end,
		[EnteredBy] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [EnteredBy] end,
		[pdt] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [pdt] end,
		[CheckedBy] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CheckedBy] end,
		[actnodays] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [actnodays] end,
		[narration] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [narration] end
	where [vdt] = @pkc1
  and [cltcode] = @pkc2
  and [vtyp] = @pkc3
  and [vno] = @pkc4
  and [lno] = @pkc5
  and [BookType] = @pkc6
  and [drcr] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[vdt] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[cltcode] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[vtyp] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[vno] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[lno] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BookType] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[drcr] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANAND1MTFTRADELEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANANDACCOUNT_ABLEDGER_17Feb24
-- --------------------------------------------------
create procedure [sp_MSupd_dboANANDACCOUNT_ABLEDGER_17Feb24]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ANANDACCOUNT_ABLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDACCOUNT_ABLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANANDACCOUNT_ABLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDACCOUNT_ABLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboANANDBSEDB_ABCMBILLVALAN_17Feb24
-- --------------------------------------------------
create procedure [sp_MSupd_dboANANDBSEDB_ABCMBILLVALAN_17Feb24]
		@c1 varchar(7) = NULL,
		@c2 varchar(3) = NULL,
		@c3 varchar(10) = NULL,
		@c4 varchar(15) = NULL,
		@c5 varchar(10) = NULL,
		@c6 varchar(100) = NULL,
		@c7 varchar(12) = NULL,
		@c8 varchar(3) = NULL,
		@c9 varchar(50) = NULL,
		@c10 varchar(12) = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@c13 money = NULL,
		@c14 int = NULL,
		@c15 money = NULL,
		@c16 int = NULL,
		@c17 money = NULL,
		@c18 int = NULL,
		@c19 money = NULL,
		@c20 money = NULL,
		@c21 money = NULL,
		@c22 money = NULL,
		@c23 money = NULL,
		@c24 varchar(10) = NULL,
		@c25 varchar(100) = NULL,
		@c26 varchar(10) = NULL,
		@c27 varchar(10) = NULL,
		@c28 varchar(3) = NULL,
		@c29 varchar(20) = NULL,
		@c30 varchar(10) = NULL,
		@c31 varchar(10) = NULL,
		@c32 varchar(15) = NULL,
		@c33 money = NULL,
		@c34 money = NULL,
		@c35 money = NULL,
		@c36 money = NULL,
		@c37 money = NULL,
		@c38 money = NULL,
		@c39 smallint = NULL,
		@c40 money = NULL,
		@c41 money = NULL,
		@c42 money = NULL,
		@c43 money = NULL,
		@c44 money = NULL,
		@c45 money = NULL,
		@c46 money = NULL,
		@c47 varchar(50) = NULL,
		@c48 varchar(11) = NULL,
		@c49 varchar(11) = NULL,
		@c50 varchar(11) = NULL,
		@c51 varchar(15) = NULL,
		@c52 varchar(5) = NULL,
		@c53 varchar(10) = NULL,
		@c54 varchar(3) = NULL,
		@c55 varchar(100) = NULL,
		@c56 varchar(1) = NULL,
		@c57 varchar(1) = NULL,
		@c58 varchar(1) = NULL,
		@c59 money = NULL,
		@c60 money = NULL,
		@c61 varchar(20) = NULL,
		@pkc1 varchar(7) = NULL,
		@pkc2 varchar(3) = NULL,
		@pkc8 varchar(15) = NULL,
		@pkc4 varchar(10) = NULL,
		@pkc5 varchar(12) = NULL,
		@pkc6 varchar(3) = NULL,
		@pkc3 datetime = NULL,
		@pkc7 varchar(10) = NULL,
		@pkc9 varchar(3) = NULL,
		@bitmap binary(8)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,2,1) & 4 = 4) or
 (substring(@bitmap,1,1) & 16 = 16) or
 (substring(@bitmap,1,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,4,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,4,1) & 8 = 8)
begin 

update [dbo].[ANANDBSEDB_ABCMBILLVALAN] set
		[SETT_NO] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [SETT_NO] end,
		[SETT_TYPE] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SETT_TYPE] end,
		[BILLNO] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [BILLNO] end,
		[CONTRACTNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CONTRACTNO] end,
		[PARTY_CODE] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PARTY_CODE] end,
		[PARTY_NAME] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PARTY_NAME] end,
		[SCRIP_CD] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SCRIP_CD] end,
		[SERIES] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SERIES] end,
		[SCRIP_NAME] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SCRIP_NAME] end,
		[ISIN] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ISIN] end,
		[SAUDA_DATE] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [SAUDA_DATE] end,
		[PQTYTRD] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PQTYTRD] end,
		[PAMTTRD] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PAMTTRD] end,
		[PQTYDEL] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PQTYDEL] end,
		[PAMTDEL] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PAMTDEL] end,
		[SQTYTRD] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SQTYTRD] end,
		[SAMTTRD] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [SAMTTRD] end,
		[SQTYDEL] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SQTYDEL] end,
		[SAMTDEL] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SAMTDEL] end,
		[PBROKTRD] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [PBROKTRD] end,
		[SBROKTRD] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [SBROKTRD] end,
		[PBROKDEL] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PBROKDEL] end,
		[SBROKDEL] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SBROKDEL] end,
		[FAMILY] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [FAMILY] end,
		[FAMILY_NAME] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [FAMILY_NAME] end,
		[TERMINAL_ID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [TERMINAL_ID] end,
		[CLIENTTYPE] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CLIENTTYPE] end,
		[TRADETYPE] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [TRADETYPE] end,
		[TRADER] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [TRADER] end,
		[SUB_BROKER] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [SUB_BROKER] end,
		[BRANCH_CD] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [BRANCH_CD] end,
		[PARTICIPANTCODE] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [PARTICIPANTCODE] end,
		[PAMT] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [PAMT] end,
		[SAMT] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [SAMT] end,
		[PRATE] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [PRATE] end,
		[SRATE] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [SRATE] end,
		[TRDAMT] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [TRDAMT] end,
		[DELAMT] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [DELAMT] end,
		[SERINEX] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SERINEX] end,
		[SERVICE_TAX] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [SERVICE_TAX] end,
		[EXSERVICE_TAX] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [EXSERVICE_TAX] end,
		[TURN_TAX] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [TURN_TAX] end,
		[SEBI_TAX] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [SEBI_TAX] end,
		[INS_CHRG] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [INS_CHRG] end,
		[BROKER_CHRG] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [BROKER_CHRG] end,
		[OTHER_CHRG] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [OTHER_CHRG] end,
		[REGION] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [REGION] end,
		[START_DATE] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [START_DATE] end,
		[END_DATE] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [END_DATE] end,
		[UPDATE_DATE] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [UPDATE_DATE] end,
		[STATUS_NAME] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [STATUS_NAME] end,
		[EXCHANGE] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [EXCHANGE] end,
		[SEGMENT] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [SEGMENT] end,
		[MEMBERTYPE] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [MEMBERTYPE] end,
		[COMPANYNAME] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [COMPANYNAME] end,
		[DUMMY1] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [DUMMY1] end,
		[DUMMY2] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [DUMMY2] end,
		[DUMMY3] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [DUMMY3] end,
		[DUMMY4] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [DUMMY4] end,
		[DUMMY5] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [DUMMY5] end,
		[AREA] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [AREA] end
	where [SETT_NO] = @pkc1
  and [SETT_TYPE] = @pkc2
  and [SAUDA_DATE] = @pkc3
  and [PARTY_CODE] = @pkc4
  and [SCRIP_CD] = @pkc5
  and [SERIES] = @pkc6
  and [TERMINAL_ID] = @pkc7
  and [CONTRACTNO] = @pkc8
  and [TRADETYPE] = @pkc9
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SETT_NO] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SETT_TYPE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SAUDA_DATE] = ' + convert(nvarchar(100),@pkc3,21) + ', '
				set @primarykey_text = @primarykey_text + '[PARTY_CODE] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[SCRIP_CD] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[SERIES] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[TERMINAL_ID] = ' + convert(nvarchar(100),@pkc7,1) + ', '
				set @primarykey_text = @primarykey_text + '[CONTRACTNO] = ' + convert(nvarchar(100),@pkc8,1) + ', '
				set @primarykey_text = @primarykey_text + '[TRADETYPE] = ' + convert(nvarchar(100),@pkc9,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDBSEDB_ABCMBILLVALAN]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ANANDBSEDB_ABCMBILLVALAN] set
		[BILLNO] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [BILLNO] end,
		[PARTY_NAME] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PARTY_NAME] end,
		[SCRIP_NAME] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SCRIP_NAME] end,
		[ISIN] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ISIN] end,
		[PQTYTRD] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PQTYTRD] end,
		[PAMTTRD] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PAMTTRD] end,
		[PQTYDEL] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PQTYDEL] end,
		[PAMTDEL] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PAMTDEL] end,
		[SQTYTRD] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SQTYTRD] end,
		[SAMTTRD] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [SAMTTRD] end,
		[SQTYDEL] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SQTYDEL] end,
		[SAMTDEL] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SAMTDEL] end,
		[PBROKTRD] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [PBROKTRD] end,
		[SBROKTRD] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [SBROKTRD] end,
		[PBROKDEL] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PBROKDEL] end,
		[SBROKDEL] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [SBROKDEL] end,
		[FAMILY] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [FAMILY] end,
		[FAMILY_NAME] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [FAMILY_NAME] end,
		[CLIENTTYPE] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CLIENTTYPE] end,
		[TRADER] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [TRADER] end,
		[SUB_BROKER] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [SUB_BROKER] end,
		[BRANCH_CD] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [BRANCH_CD] end,
		[PARTICIPANTCODE] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [PARTICIPANTCODE] end,
		[PAMT] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [PAMT] end,
		[SAMT] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [SAMT] end,
		[PRATE] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [PRATE] end,
		[SRATE] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [SRATE] end,
		[TRDAMT] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [TRDAMT] end,
		[DELAMT] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [DELAMT] end,
		[SERINEX] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SERINEX] end,
		[SERVICE_TAX] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [SERVICE_TAX] end,
		[EXSERVICE_TAX] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [EXSERVICE_TAX] end,
		[TURN_TAX] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [TURN_TAX] end,
		[SEBI_TAX] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [SEBI_TAX] end,
		[INS_CHRG] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [INS_CHRG] end,
		[BROKER_CHRG] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [BROKER_CHRG] end,
		[OTHER_CHRG] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [OTHER_CHRG] end,
		[REGION] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [REGION] end,
		[START_DATE] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [START_DATE] end,
		[END_DATE] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [END_DATE] end,
		[UPDATE_DATE] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [UPDATE_DATE] end,
		[STATUS_NAME] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [STATUS_NAME] end,
		[EXCHANGE] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [EXCHANGE] end,
		[SEGMENT] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [SEGMENT] end,
		[MEMBERTYPE] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [MEMBERTYPE] end,
		[COMPANYNAME] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [COMPANYNAME] end,
		[DUMMY1] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [DUMMY1] end,
		[DUMMY2] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [DUMMY2] end,
		[DUMMY3] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [DUMMY3] end,
		[DUMMY4] = case substring(@bitmap,8,1) & 4 when 4 then @c59 else [DUMMY4] end,
		[DUMMY5] = case substring(@bitmap,8,1) & 8 when 8 then @c60 else [DUMMY5] end,
		[AREA] = case substring(@bitmap,8,1) & 16 when 16 then @c61 else [AREA] end
	where [SETT_NO] = @pkc1
  and [SETT_TYPE] = @pkc2
  and [SAUDA_DATE] = @pkc3
  and [PARTY_CODE] = @pkc4
  and [SCRIP_CD] = @pkc5
  and [SERIES] = @pkc6
  and [TERMINAL_ID] = @pkc7
  and [CONTRACTNO] = @pkc8
  and [TRADETYPE] = @pkc9
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SETT_NO] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SETT_TYPE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SAUDA_DATE] = ' + convert(nvarchar(100),@pkc3,21) + ', '
				set @primarykey_text = @primarykey_text + '[PARTY_CODE] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[SCRIP_CD] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[SERIES] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[TERMINAL_ID] = ' + convert(nvarchar(100),@pkc7,1) + ', '
				set @primarykey_text = @primarykey_text + '[CONTRACTNO] = ' + convert(nvarchar(100),@pkc8,1) + ', '
				set @primarykey_text = @primarykey_text + '[TRADETYPE] = ' + convert(nvarchar(100),@pkc9,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ANANDBSEDB_ABCMBILLVALAN]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger_14Apr23]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc2 smallint = NULL,
		@pkc3 varchar(12) = NULL,
		@pkc4 int = NULL,
		@pkc6 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc7 varchar(10) = NULL,
		@pkc5 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32) or
 (substring(@bitmap,2,1) & 32 = 32)
begin 

update [dbo].[AngelcommodityAccountCurBFOledger] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[AngelcommodityAccountCurBFOledger] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger_15June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger_15June2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc2 smallint = NULL,
		@pkc3 varchar(12) = NULL,
		@pkc4 int = NULL,
		@pkc6 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc7 varchar(10) = NULL,
		@pkc5 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32) or
 (substring(@bitmap,2,1) & 32 = 32)
begin 

update [dbo].[AngelcommodityAccountCurBFOledger] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[AngelcommodityAccountCurBFOledger] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger1_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger1_14Apr23]
		@c1 varchar(100) = NULL,
		@c2 varchar(100) = NULL,
		@c3 char(1) = NULL,
		@c4 varchar(30) = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 money = NULL,
		@c8 char(12) = NULL,
		@c9 int = NULL,
		@c10 smallint = NULL,
		@c11 varchar(12) = NULL,
		@c12 int = NULL,
		@c13 char(1) = NULL,
		@c14 char(2) = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 datetime = NULL,
		@c18 varchar(100) = NULL,
		@c19 tinyint = NULL,
		@c20 char(1) = NULL,
		@c21 bigint = NULL,
		@pkc1 bigint = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

update [dbo].[AngelcommodityAccountCurBFOledger1] set
		[Bnkname] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Bnkname] end,
		[Brnname] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Brnname] end,
		[Dd] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Dd] end,
		[Ddno] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Ddno] end,
		[Dddt] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Dddt] end,
		[Reldt] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Reldt] end,
		[Relamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Relamt] end,
		[Refno] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Refno] end,
		[Receiptno] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Receiptno] end,
		[Vtyp] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Vtyp] end,
		[Vno] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Vno] end,
		[Lno] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Lno] end,
		[Drcr] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Drcr] end,
		[Booktype] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Booktype] end,
		[Micrno] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Micrno] end,
		[Slipno] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Slipno] end,
		[Slipdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Slipdate] end,
		[Chequeinname] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Chequeinname] end,
		[Chqprinted] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Chqprinted] end,
		[Clear_mode] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Clear_mode] end
	where [L1_SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[L1_SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger1]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger1_15June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger1_15June2024]
		@c1 varchar(100) = NULL,
		@c2 varchar(100) = NULL,
		@c3 char(1) = NULL,
		@c4 varchar(30) = NULL,
		@c5 datetime = NULL,
		@c6 datetime = NULL,
		@c7 money = NULL,
		@c8 char(12) = NULL,
		@c9 int = NULL,
		@c10 smallint = NULL,
		@c11 varchar(12) = NULL,
		@c12 int = NULL,
		@c13 char(1) = NULL,
		@c14 char(2) = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 datetime = NULL,
		@c18 varchar(100) = NULL,
		@c19 tinyint = NULL,
		@c20 char(1) = NULL,
		@c21 bigint = NULL,
		@pkc1 bigint = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

update [dbo].[AngelcommodityAccountCurBFOledger1] set
		[Bnkname] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Bnkname] end,
		[Brnname] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Brnname] end,
		[Dd] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Dd] end,
		[Ddno] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Ddno] end,
		[Dddt] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Dddt] end,
		[Reldt] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Reldt] end,
		[Relamt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Relamt] end,
		[Refno] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Refno] end,
		[Receiptno] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Receiptno] end,
		[Vtyp] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Vtyp] end,
		[Vno] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Vno] end,
		[Lno] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Lno] end,
		[Drcr] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Drcr] end,
		[Booktype] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Booktype] end,
		[Micrno] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Micrno] end,
		[Slipno] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Slipno] end,
		[Slipdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Slipdate] end,
		[Chequeinname] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Chequeinname] end,
		[Chqprinted] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Chqprinted] end,
		[Clear_mode] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [Clear_mode] end
	where [L1_SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[L1_SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger1]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger2_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger2_14Apr23]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 bigint = NULL,
		@c4 char(1) = NULL,
		@c5 money = NULL,
		@c6 smallint = NULL,
		@c7 char(2) = NULL,
		@c8 varchar(10) = NULL,
		@c9 bigint = NULL,
		@pkc1 bigint = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

update [dbo].[AngelcommodityAccountCurBFOledger2] set
		[Vtype] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Vtype] end,
		[Vno] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Vno] end,
		[Lno] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Lno] end,
		[Drcr] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Drcr] end,
		[Camt] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Camt] end,
		[Costcode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Costcode] end,
		[Booktype] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Booktype] end,
		[Cltcode] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Cltcode] end
	where [SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger2]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboAngelcommodityAccountCurBFOledger2_15June2024
-- --------------------------------------------------
create procedure [sp_MSupd_dboAngelcommodityAccountCurBFOledger2_15June2024]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 bigint = NULL,
		@c4 char(1) = NULL,
		@c5 money = NULL,
		@c6 smallint = NULL,
		@c7 char(2) = NULL,
		@c8 varchar(10) = NULL,
		@c9 bigint = NULL,
		@pkc1 bigint = NULL,
		@bitmap binary(2)
as
begin  
	declare @primarykey_text nvarchar(100) = ''

update [dbo].[AngelcommodityAccountCurBFOledger2] set
		[Vtype] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Vtype] end,
		[Vno] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Vno] end,
		[Lno] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Lno] end,
		[Drcr] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Drcr] end,
		[Camt] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Camt] end,
		[Costcode] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Costcode] end,
		[Booktype] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Booktype] end,
		[Cltcode] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Cltcode] end
	where [SNo] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[SNo] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[AngelcommodityAccountCurBFOledger2]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboLEDGER_04Feb24_1759
-- --------------------------------------------------
create procedure [sp_MSupd_dboLEDGER_04Feb24_1759]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTCURFOLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTCURFOLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTCURFOLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTCURFOLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboLEDGER_04Feb24_1817
-- --------------------------------------------------
create procedure [sp_MSupd_dboLEDGER_04Feb24_1817]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc2 smallint = NULL,
		@pkc3 varchar(12) = NULL,
		@pkc4 int = NULL,
		@pkc6 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc7 varchar(10) = NULL,
		@pkc5 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32) or
 (substring(@bitmap,2,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTFOLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTFOLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTFOLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [VTYP] = @pkc2
  and [VNO] = @pkc3
  and [LNO] = @pkc4
  and [BOOKTYPE] = @pkc5
  and [DRCR] = @pkc6
  and [CLTCODE] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTFOLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_MSupd_dboLEDGERACCOUNTNCDXLEDGER_14Apr23
-- --------------------------------------------------
create procedure [sp_MSupd_dboLEDGERACCOUNTNCDXLEDGER_14Apr23]
		@c1 smallint = NULL,
		@c2 varchar(12) = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 varchar(100) = NULL,
		@c6 char(1) = NULL,
		@c7 money = NULL,
		@c8 datetime = NULL,
		@c9 varchar(12) = NULL,
		@c10 char(12) = NULL,
		@c11 money = NULL,
		@c12 int = NULL,
		@c13 datetime = NULL,
		@c14 varchar(10) = NULL,
		@c15 varchar(3) = NULL,
		@c16 varchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 varchar(25) = NULL,
		@c19 int = NULL,
		@c20 varchar(255) = NULL,
		@pkc3 smallint = NULL,
		@pkc4 varchar(12) = NULL,
		@pkc5 int = NULL,
		@pkc7 char(1) = NULL,
		@pkc1 datetime = NULL,
		@pkc2 varchar(10) = NULL,
		@pkc6 varchar(3) = NULL,
		@bitmap binary(3)
as
begin  
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 128 = 128) or
 (substring(@bitmap,2,1) & 32 = 32) or
 (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8) or
 (substring(@bitmap,2,1) & 64 = 64) or
 (substring(@bitmap,1,1) & 32 = 32)
begin 

update [dbo].[ACCOUNTNCDXLEDGER] set
		[VTYP] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [VTYP] end,
		[VNO] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VNO] end,
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[LNO] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LNO] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[DRCR] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [DRCR] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VDT] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VDT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[CLTCODE] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CLTCODE] end,
		[BOOKTYPE] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [BOOKTYPE] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end  
else
begin 

update [dbo].[ACCOUNTNCDXLEDGER] set
		[EDT] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EDT] end,
		[ACNAME] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ACNAME] end,
		[VAMT] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VAMT] end,
		[VNO1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VNO1] end,
		[REFNO] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [REFNO] end,
		[BALAMT] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [BALAMT] end,
		[NODAYS] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [NODAYS] end,
		[CDT] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CDT] end,
		[ENTEREDBY] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ENTEREDBY] end,
		[PDT] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PDT] end,
		[CHECKEDBY] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CHECKEDBY] end,
		[ACTNODAYS] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ACTNODAYS] end,
		[NARRATION] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NARRATION] end
	where [VDT] = @pkc1
  and [CLTCODE] = @pkc2
  and [VTYP] = @pkc3
  and [VNO] = @pkc4
  and [LNO] = @pkc5
  and [BOOKTYPE] = @pkc6
  and [DRCR] = @pkc7
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin
				
				set @primarykey_text = @primarykey_text + '[VDT] = ' + convert(nvarchar(100),@pkc1,21) + ', '
				set @primarykey_text = @primarykey_text + '[CLTCODE] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[VTYP] = ' + convert(nvarchar(100),@pkc3,1) + ', '
				set @primarykey_text = @primarykey_text + '[VNO] = ' + convert(nvarchar(100),@pkc4,1) + ', '
				set @primarykey_text = @primarykey_text + '[LNO] = ' + convert(nvarchar(100),@pkc5,1) + ', '
				set @primarykey_text = @primarykey_text + '[BOOKTYPE] = ' + convert(nvarchar(100),@pkc6,1) + ', '
				set @primarykey_text = @primarykey_text + '[DRCR] = ' + convert(nvarchar(100),@pkc7,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ACCOUNTNCDXLEDGER]', @param2=@primarykey_text, @param3=13233 
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end 
end

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTBFOLedger
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTBFOLedger]
(
    [Vtyp] SMALLINT NOT NULL,
    [Vno] VARCHAR(12) NOT NULL,
    [Edt] DATETIME NULL,
    [Lno] DECIMAL(4, 0) NOT NULL,
    [Acname] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NULL,
    [Vamt] MONEY NULL,
    [Vdt] DATETIME NULL,
    [Vno1] VARCHAR(12) NULL,
    [Refno] CHAR(12) NULL,
    [Balamt] MONEY NOT NULL,
    [Nodays] INT NULL,
    [Cdt] DATETIME NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Booktype] CHAR(2) NOT NULL,
    [Enteredby] VARCHAR(25) NULL,
    [Pdt] DATETIME NULL,
    [Checkedby] VARCHAR(25) NULL,
    [Actnodays] INT NULL,
    [Narration] VARCHAR(500) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTCURBSXLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTCURBSXLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTCURFOLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTCURFOLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTFOLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTFOLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTMCDX_LEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTMCDX_LEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTMCDXCDSLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTMCDXCDSLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTMCDXLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTMCDXLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTNCDXLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTNCDXLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ACCOUNTNCELEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ACCOUNTNCELEDGER]
(
    [Vtyp] SMALLINT NOT NULL,
    [Vno] VARCHAR(12) NOT NULL,
    [Edt] DATETIME NULL,
    [Lno] INT NOT NULL,
    [Acname] VARCHAR(100) NOT NULL,
    [Drcr] CHAR(1) NOT NULL,
    [Vamt] MONEY NULL,
    [Vdt] DATETIME NOT NULL,
    [Vno1] VARCHAR(12) NULL,
    [Refno] CHAR(12) NULL,
    [Balamt] MONEY NOT NULL,
    [Nodays] INT NULL,
    [Cdt] DATETIME NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Booktype] CHAR(2) NOT NULL,
    [Enteredby] VARCHAR(25) NULL,
    [Pdt] DATETIME NULL,
    [Checkedby] VARCHAR(25) NULL,
    [Actnodays] INT NULL,
    [Narration] VARCHAR(500) NULL,
    [SNO] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANAND1ACCOUNTLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ANAND1ACCOUNTLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANAND1MSAJAGCLIENT_BROK_DETAILS
-- --------------------------------------------------
CREATE TABLE [dbo].[ANAND1MSAJAGCLIENT_BROK_DETAILS]
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
    [Trd_Tran_Chrgs] NUMERIC(18, 6) NULL,
    [Trd_Sebi_Fees] NUMERIC(18, 6) NULL,
    [Trd_Stamp_Duty] MONEY NULL,
    [Trd_Other_Chrgs] MONEY NULL,
    [Trd_Eff_Dt] DATETIME NULL,
    [Del_Stt] MONEY NULL,
    [Del_Tran_Chrgs] NUMERIC(18, 6) NULL,
    [Del_SEBI_Fees] NUMERIC(18, 6) NULL,
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
    [CheckActiveClient] VARCHAR(1) NULL,
    [Deactive_Remarks] VARCHAR(100) NULL,
    [Deactive_value] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANAND1MSAJAGClient_Details
-- --------------------------------------------------
CREATE TABLE [dbo].[ANAND1MSAJAGClient_Details]
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
    [p_city] VARCHAR(40) NULL,
    [p_address2] VARCHAR(50) NULL,
    [p_state] VARCHAR(50) NULL,
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
    [INCOME_SLAB] INT NULL,
    [NETWORTH_SLAB] INT NULL,
    [PARENTCODE] VARCHAR(10) NULL,
    [PRODUCTCODE] VARCHAR(10) NULL,
    [RES_PHONE1_STD] VARCHAR(5) NULL,
    [RES_PHONE2_STD] VARCHAR(5) NULL,
    [OFF_PHONE1_STD] VARCHAR(5) NULL,
    [OFF_PHONE2_STD] VARCHAR(5) NULL,
    [P_PHONE_STD] VARCHAR(5) NULL,
    [GST_NO] VARCHAR(20) NULL,
    [GST_LOCATION] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANAND1MTFTRADELEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ANAND1MTFTRADELEDGER]
(
    [vtyp] SMALLINT NOT NULL,
    [vno] VARCHAR(12) NOT NULL,
    [edt] DATETIME NULL,
    [lno] INT NOT NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NOT NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NOT NULL,
    [vno1] VARCHAR(12) NULL,
    [refno] CHAR(12) NULL,
    [balamt] MONEY NOT NULL,
    [NoDays] INT NULL,
    [cdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [BookType] CHAR(2) NOT NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [pdt] DATETIME NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [actnodays] INT NULL,
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANANDACCOUNT_ABLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[ANANDACCOUNT_ABLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANANDBSEDB_ABCMBILLVALAN
-- --------------------------------------------------
CREATE TABLE [dbo].[ANANDBSEDB_ABCMBILLVALAN]
(
    [SETT_NO] VARCHAR(7) NOT NULL,
    [SETT_TYPE] VARCHAR(3) NOT NULL,
    [BILLNO] VARCHAR(10) NULL,
    [CONTRACTNO] VARCHAR(15) NOT NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SCRIP_CD] VARCHAR(12) NOT NULL,
    [SERIES] VARCHAR(3) NOT NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [ISIN] VARCHAR(12) NULL,
    [SAUDA_DATE] DATETIME NOT NULL,
    [PQTYTRD] INT NULL,
    [PAMTTRD] MONEY NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [SQTYTRD] INT NULL,
    [SAMTTRD] MONEY NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [PBROKTRD] MONEY NULL,
    [SBROKTRD] MONEY NULL,
    [PBROKDEL] MONEY NULL,
    [SBROKDEL] MONEY NULL,
    [FAMILY] VARCHAR(10) NULL,
    [FAMILY_NAME] VARCHAR(100) NULL,
    [TERMINAL_ID] VARCHAR(10) NOT NULL,
    [CLIENTTYPE] VARCHAR(10) NULL,
    [TRADETYPE] VARCHAR(3) NOT NULL,
    [TRADER] VARCHAR(20) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [PARTICIPANTCODE] VARCHAR(15) NULL,
    [PAMT] MONEY NOT NULL,
    [SAMT] MONEY NOT NULL,
    [PRATE] MONEY NULL,
    [SRATE] MONEY NULL,
    [TRDAMT] MONEY NULL,
    [DELAMT] MONEY NULL,
    [SERINEX] SMALLINT NULL,
    [SERVICE_TAX] MONEY NULL,
    [EXSERVICE_TAX] MONEY NULL,
    [TURN_TAX] MONEY NULL,
    [SEBI_TAX] MONEY NULL,
    [INS_CHRG] MONEY NULL,
    [BROKER_CHRG] MONEY NULL,
    [OTHER_CHRG] MONEY NULL,
    [REGION] VARCHAR(50) NULL,
    [START_DATE] VARCHAR(11) NULL,
    [END_DATE] VARCHAR(11) NULL,
    [UPDATE_DATE] VARCHAR(11) NULL,
    [STATUS_NAME] VARCHAR(15) NULL,
    [EXCHANGE] VARCHAR(5) NULL,
    [SEGMENT] VARCHAR(10) NULL,
    [MEMBERTYPE] VARCHAR(3) NULL,
    [COMPANYNAME] VARCHAR(100) NULL,
    [DUMMY1] VARCHAR(1) NULL,
    [DUMMY2] VARCHAR(1) NULL,
    [DUMMY3] VARCHAR(1) NULL,
    [DUMMY4] MONEY NULL,
    [DUMMY5] MONEY NULL,
    [AREA] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AngelCommodityAccountCurBFOLEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelCommodityAccountCurBFOLEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AngelCommodityAccountCurBFOLedger1
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelCommodityAccountCurBFOLedger1]
(
    [Bnkname] VARCHAR(100) NULL,
    [Brnname] VARCHAR(100) NULL,
    [Dd] CHAR(1) NULL,
    [Ddno] VARCHAR(30) NULL,
    [Dddt] DATETIME NULL,
    [Reldt] DATETIME NULL,
    [Relamt] MONEY NULL,
    [Refno] CHAR(12) NOT NULL,
    [Receiptno] INT NULL,
    [Vtyp] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Lno] INT NULL,
    [Drcr] CHAR(1) NULL,
    [Booktype] CHAR(2) NULL,
    [Micrno] INT NULL,
    [Slipno] INT NULL,
    [Slipdate] DATETIME NULL,
    [Chequeinname] VARCHAR(100) NULL,
    [Chqprinted] TINYINT NULL,
    [Clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AngelCommodityAccountCurBFOLedger2
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelCommodityAccountCurBFOLedger2]
(
    [Vtype] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Lno] BIGINT NULL,
    [Drcr] CHAR(1) NULL,
    [Camt] MONEY NULL,
    [Costcode] SMALLINT NULL,
    [Booktype] CHAR(2) NULL,
    [Cltcode] VARCHAR(10) NULL,
    [SNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANGELDEMATBSEDBClient4
-- --------------------------------------------------
CREATE TABLE [dbo].[ANGELDEMATBSEDBClient4]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANGELDEMATBSEDBDeltrans
-- --------------------------------------------------
CREATE TABLE [dbo].[ANGELDEMATBSEDBDeltrans]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_type] VARCHAR(2) NULL,
    [RefNo] INT NOT NULL,
    [TCode] NUMERIC(18, 0) NOT NULL,
    [TrType] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [Qty] NUMERIC(18, 0) NOT NULL,
    [FromNo] VARCHAR(16) NULL,
    [ToNo] VARCHAR(16) NULL,
    [CertNo] VARCHAR(16) NULL,
    [FolioNo] VARCHAR(16) NULL,
    [HolderName] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [DrCr] CHAR(1) NULL,
    [Delivered] CHAR(1) NULL,
    [OrgQty] NUMERIC(18, 0) NULL,
    [DpType] VARCHAR(10) NULL,
    [DpId] VARCHAR(16) NULL,
    [CltDpId] VARCHAR(16) NULL,
    [BranchCd] VARCHAR(10) NULL,
    [PartipantCode] VARCHAR(10) NULL,
    [SlipNo] NUMERIC(18, 0) NULL,
    [BatchNo] VARCHAR(10) NULL,
    [ISett_No] VARCHAR(7) NULL,
    [ISett_Type] VARCHAR(2) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANGELDEMATMSAJAGClient4
-- --------------------------------------------------
CREATE TABLE [dbo].[ANGELDEMATMSAJAGClient4]
(
    [Cl_code] VARCHAR(10) NOT NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(20) NOT NULL,
    [Depository] VARCHAR(7) NOT NULL,
    [DefDp] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ANGELDEMATMSAJAGDeltrans
-- --------------------------------------------------
CREATE TABLE [dbo].[ANGELDEMATMSAJAGDeltrans]
(
    [SNo] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_type] VARCHAR(2) NOT NULL,
    [RefNo] INT NOT NULL,
    [TCode] NUMERIC(18, 0) NOT NULL,
    [TrType] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [Qty] NUMERIC(18, 0) NOT NULL,
    [FromNo] VARCHAR(16) NULL,
    [ToNo] VARCHAR(16) NULL,
    [CertNo] VARCHAR(16) NULL,
    [FolioNo] VARCHAR(16) NULL,
    [HolderName] VARCHAR(100) NULL,
    [Reason] VARCHAR(100) NULL,
    [DrCr] CHAR(1) NOT NULL,
    [Delivered] CHAR(1) NOT NULL,
    [OrgQty] NUMERIC(18, 0) NULL,
    [DpType] VARCHAR(10) NULL,
    [DpId] VARCHAR(16) NULL,
    [CltDpId] VARCHAR(16) NULL,
    [BranchCd] VARCHAR(10) NOT NULL,
    [PartipantCode] VARCHAR(10) NOT NULL,
    [SlipNo] NUMERIC(18, 0) NULL,
    [BatchNo] VARCHAR(10) NULL,
    [ISett_No] VARCHAR(7) NULL,
    [ISett_Type] VARCHAR(2) NULL,
    [ShareType] VARCHAR(8) NULL,
    [TransDate] DATETIME NOT NULL,
    [Filler1] VARCHAR(100) NULL,
    [Filler2] INT NULL,
    [Filler3] INT NULL,
    [BDpType] VARCHAR(10) NULL,
    [BDpId] VARCHAR(16) NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [Filler4] DATETIME NULL,
    [Filler5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.AngelFOAccountFOLedger1
-- --------------------------------------------------
CREATE TABLE [dbo].[AngelFOAccountFOLedger1]
(
    [bnkname] VARCHAR(100) NULL,
    [brnname] VARCHAR(100) NULL,
    [dd] CHAR(1) NULL,
    [ddno] VARCHAR(30) NULL,
    [dddt] DATETIME NULL,
    [reldt] DATETIME NULL,
    [relamt] MONEY NULL,
    [refno] CHAR(12) NOT NULL,
    [receiptno] INT NULL,
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [lno] INT NULL,
    [drcr] CHAR(1) NULL,
    [BookType] CHAR(2) NULL,
    [MicrNo] INT NULL,
    [SlipNo] INT NULL,
    [slipdate] DATETIME NULL,
    [ChequeInName] VARCHAR(100) NULL,
    [Chqprinted] TINYINT NULL,
    [clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LEDGER
-- --------------------------------------------------
CREATE TABLE [dbo].[LEDGER]
(
    [VTYP] SMALLINT NOT NULL,
    [VNO] VARCHAR(12) NOT NULL,
    [EDT] DATETIME NULL,
    [LNO] INT NOT NULL,
    [ACNAME] VARCHAR(100) NULL,
    [DRCR] CHAR(1) NOT NULL,
    [VAMT] MONEY NULL,
    [VDT] DATETIME NOT NULL,
    [VNO1] VARCHAR(12) NULL,
    [REFNO] CHAR(12) NULL,
    [BALAMT] MONEY NOT NULL,
    [NODAYS] INT NULL,
    [CDT] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NOT NULL,
    [BOOKTYPE] VARCHAR(3) NOT NULL,
    [ENTEREDBY] VARCHAR(25) NULL,
    [PDT] DATETIME NULL,
    [CHECKEDBY] VARCHAR(25) NULL,
    [ACTNODAYS] INT NULL,
    [NARRATION] VARCHAR(255) NULL
);

GO

