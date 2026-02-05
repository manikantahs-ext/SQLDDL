-- DDL Export
-- Server: 10.253.33.94
-- Database: INHOUSE_BFO
-- Exported: 2026-02-05T12:29:29.057197

USE INHOUSE_BFO;
GO

-- --------------------------------------------------
-- INDEX dbo.BO_client_deposit_recno
-- --------------------------------------------------
CREATE CLUSTERED INDEX [co_pcode] ON [dbo].[BO_client_deposit_recno] ([cltcode])

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
-- PROCEDURE dbo.Fetch_CliUnreco
-- --------------------------------------------------
 CREATE Procedure [dbo].[Fetch_CliUnreco]    
as    
    
set nocount on    
    
declare @fromdt as datetime,@todate as datetime    
select @fromdt=sdtcur,@todate=ldtcur from accountbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()    
    
select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet    
from accountbfo.dbo.ledger b with (nolock)     
where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1    
    
select     
bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo    
into #led1    
from accountbfo.dbo.ledger1 with (nolock)    
where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )     
    
select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype     
    
    
select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,     
isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),     
Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),     
treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()     
into #recodet     
From accountbfo.dbo.LEDGER l with (nolock)    
join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno    
and vdt <= getdate()     
and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')    
      
/*                                
select top 0 * into BO_client_deposit_recno from [CSOKYC-6].general.dbo.BO_client_deposit_recno     
create clustered index co_pcode on BO_client_deposit_recno(cltcode)     
*/    
    
    
delete #recodet from #recodet a inner join BSEFO.DBO.CLient1 b WITH (NOLOCK) on     
a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')     
    
truncate table BO_client_deposit_recno     
insert into BO_client_deposit_recno select co_code='BSEFO',getdate(),* from #recodet (nolock)     
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.midware_ledger_INHOUSE
-- --------------------------------------------------
CREATE procedure MIDWARE_ledger_inhouse        
as                
                
set nocount on                
----- Account Master                
truncate table INHOUSE_BFO.dbo.ledger        
  
  
/* Fetch Party Ledger */  
insert into INHOUSE_BFO.dbo.ledger              
select * from accountbfo.dbo.ledger with (nolock)   
where vdt >= convert(datetime,convert(varchar(11),getdate()-15)+' 00:00:00')  
and cltcode >='A0001' and cltcode <='ZZ9999'     
  
declare @finDt as datetime,@sDt as datetime  
set @finDt = 'Oct 31 '+case when datepart(mm,getdate()) > 3 then convert(varchar(4),datepart(yy,getdate()))  
else convert(varchar(4),datepart(yy,getdate())-1) end  
  
if getdate() > @finDt  
Begin  
 select @sdt=sdtcur from parameter with (nolock)  where sdtcur <= getdate() and ldtcur >= getdate()  
end  
else  
Begin  
 select @sdt=sdtcur from parameter with (nolock)   
 where ldtprv = (select  ldtprv from parameter with (nolock)  where sdtcur <= getdate() and ldtcur >= getdate())  
end  
  
  
/* Fetch General Ledger */  
insert into INHOUSE_BFO.dbo.ledger              
select * from accountbfo.dbo.ledger with (nolock)   
where vdt >= @sdt and cltcode >='0' and cltcode <='99999999'     
  
                
truncate table INHOUSE_BFO.dbo.ledger1        
insert into INHOUSE_BFO.dbo.ledger1              
select * from accountbfo.dbo.ledger1 with (nolock)      
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Midware_master_inhouse
-- --------------------------------------------------

CREATE procedure Midware_master_inhouse      
as      
      
set nocount on      
----- Account Master      
truncate table INHOUSE_BFO.dbo.acmast      
insert into INHOUSE_BFO.dbo.acmast       
select * from ACCOUNTBFO.DBO.acmast with (nolock) --  00:18 secs      
      
truncate table INHOUSE_BFO.dbo.vmast      
insert into INHOUSE_BFO.dbo.vmast      
select * from ACCOUNTBFO.DBO.vmast with (nolock) --  00:01 secs      
      
truncate table INHOUSE_BFO.dbo.parameter       
insert into INHOUSE_BFO.dbo.parameter       
select * from ACCOUNTBFO.DBO.parameter with (nolock) --  00:01 secs      
    
truncate table INHOUSE_BFO.dbo.costmast    
insert into INHOUSE_BFO.dbo.costmast       
select * from ACCOUNTBFO.DBO.costmast with (nolock) --  00:01 secs      
      
--- Settlement      
/*
truncate table INHOUSE_BFO.DBO.sett_mst      
insert into INHOUSE_BFO.DBO.sett_mst      
select * from BSEFO.DBO.sett_mst with (nolock)      
*/      
      
--- Scrip Master      
truncate table INHOUSE_BFO.DBO.scrip1      
insert into INHOUSE_BFO.DBO.scrip1      
select * from BSEFO.DBO.scrip1 with (nolock)      
      
truncate table INHOUSE_BFO.DBO.scrip2      
insert into INHOUSE_BFO.DBO.scrip2      
select * from BSEFO.DBO.scrip2 with (nolock)      
      
      
--- Sub-broker      
truncate table INHOUSE_BFO.DBO.subbrokers       
insert into INHOUSE_BFO.DBO.subbrokers       
select * from BSEFO.dbo.subbrokers with (nolock)      
      
--- Branch      
truncate table INHOUSE_BFO.DBO.branches      
insert into INHOUSE_BFO.DBO.branches      
select * from BSEFO.dbo.branches with (nolock)      
      
--- Region      
truncate table INHOUSE_BFO.DBO.region      
insert into INHOUSE_BFO.DBO.region      
select * from BSEFO.dbo.region with (nolock)      
      
--- Brokerage      
truncate table INHOUSE_BFO.DBO.Broktable      
insert into INHOUSE_BFO.DBO.Broktable      
select * from BSEFO.dbo.Broktable with (nolock)      
    
   
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.midware_TrxDetails_Inhouse
-- --------------------------------------------------
CREATE procedure midware_TrxDetails_Inhouse
as    
set nocount on              
    
declare @sdate as varchar(11)    
select top 1 @sdate=convert(varchar(13),sauda_DAte) from BSEFO.dbo.BFOsettlement with (nolock)  
--print @sdate    
    
truncate table inhouse_BFO.dbo.BFOsettlement   
insert into inhouse_BFO.dbo.BFOsettlement   
select * from BSEFO.dbo.BFOsettlement with (nolock) where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'     
    
truncate table inhouse_BFO.dbo.BFOBILLVALAN  
insert into inhouse_BFO.dbo.BFOBILLVALAN    
select * from BSEFO.dbo.BFOBILLVALAN with (nolock) where sauda_date >= @sdate+' 00:00:00' and  sauda_date <= @sdate+' 23:59:59'     
    
set nocount off

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
-- TABLE dbo.abc_lg
-- --------------------------------------------------
CREATE TABLE [dbo].[abc_lg]
(
    [fld1] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.acmast
-- --------------------------------------------------
CREATE TABLE [dbo].[acmast]
(
    [Acname] VARCHAR(100) NULL,
    [Longname] VARCHAR(100) NULL,
    [Actyp] CHAR(10) NULL,
    [Accat] CHAR(10) NULL,
    [Familycd] CHAR(10) NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Accdtls] CHAR(35) NULL,
    [Grpcode] CHAR(13) NULL,
    [Booktype] CHAR(4) NULL,
    [Micrno] VARCHAR(10) NULL,
    [Branchcode] VARCHAR(10) NULL,
    [Btobpayment] INT NULL,
    [Paymode] CHAR(1) NULL,
    [Pobankname] VARCHAR(50) NULL,
    [Pobranch] VARCHAR(25) NULL,
    [Pobankcode] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.adt_file
-- --------------------------------------------------
CREATE TABLE [dbo].[adt_file]
(
    [TBDate] DATETIME NULL,
    [CLTCODE] VARCHAR(10) NULL,
    [Balance] MONEY NULL,
    [Margin] MONEY NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL,
    [Flag] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfobillvalan
-- --------------------------------------------------
CREATE TABLE [dbo].[bfobillvalan]
(
    [Party_Code] VARCHAR(15) NOT NULL,
    [Party_Name] VARCHAR(100) NOT NULL,
    [Client_Type] VARCHAR(20) NOT NULL,
    [BillNo] VARCHAR(20) NOT NULL,
    [ContractNo] VARCHAR(20) NOT NULL,
    [Product_Code] VARCHAR(20) NOT NULL,
    [Series_Code] VARCHAR(20) NOT NULL,
    [expirydate] DATETIME NOT NULL,
    [Product_type] VARCHAR(20) NOT NULL,
    [Series_Id] INT NOT NULL,
    [Strike_Price] MONEY NOT NULL,
    [Market_Lot] INT NOT NULL,
    [AuctionPart] VARCHAR(20) NOT NULL,
    [MaturityDate] DATETIME NOT NULL,
    [Sauda_date] DATETIME NOT NULL,
    [IsIn] VARCHAR(20) NOT NULL,
    [PQty] INT NOT NULL,
    [SQty] INT NOT NULL,
    [PRate] MONEY NOT NULL,
    [SRate] MONEY NOT NULL,
    [PAmt] MONEY NOT NULL,
    [SAmt] MONEY NOT NULL,
    [PBrokAmt] MONEY NOT NULL,
    [SBrokAmt] MONEY NOT NULL,
    [PBillAmt] MONEY NOT NULL,
    [SBillAmt] MONEY NOT NULL,
    [Cl_Rate] MONEY NOT NULL,
    [Cl_Chrg] MONEY NOT NULL,
    [ExCl_Chrg] MONEY NOT NULL,
    [Service_Tax] MONEY NOT NULL,
    [ExSer_Tax] MONEY NOT NULL,
    [InExSerFlag] SMALLINT NOT NULL,
    [sebi_tax] MONEY NOT NULL,
    [turn_tax] MONEY NOT NULL,
    [Broker_note] MONEY NOT NULL,
    [Ins_Chrg] MONEY NOT NULL,
    [Other_Chrg] MONEY NOT NULL,
    [TradeType] VARCHAR(20) NOT NULL,
    [ParticiPantCode] VARCHAR(25) NOT NULL,
    [Terminal_Id] VARCHAR(25) NOT NULL,
    [Family] VARCHAR(20) NOT NULL,
    [FamilyName] VARCHAR(100) NOT NULL,
    [Trader] VARCHAR(40) NOT NULL,
    [Branch_Code] VARCHAR(20) NOT NULL,
    [Sub_Broker] VARCHAR(20) NOT NULL,
    [StatusName] VARCHAR(25) NOT NULL,
    [Exchange] VARCHAR(10) NOT NULL,
    [Segment] VARCHAR(25) NOT NULL,
    [MemberType] VARCHAR(10) NOT NULL,
    [CompanyName] VARCHAR(100) NOT NULL,
    [Region] VARCHAR(20) NOT NULL,
    [UpdateDate] VARCHAR(11) NOT NULL,
    [email] VARCHAR(100) NOT NULL,
    [sbu] VARCHAR(20) NOT NULL,
    [relmgr] VARCHAR(20) NOT NULL,
    [grp] VARCHAR(20) NOT NULL,
    [sector] VARCHAR(20) NOT NULL,
    [CMClosing] MONEY NOT NULL,
    [track] VARCHAR(20) NOT NULL,
    [Area] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfoscrip1
-- --------------------------------------------------
CREATE TABLE [dbo].[bfoscrip1]
(
    [ProductName] CHAR(3) NULL,
    [UnderlyingAsset] VARCHAR(5) NULL,
    [product_type] VARCHAR(5) NULL,
    [product_code] VARCHAR(10) NULL,
    [series_code] VARCHAR(20) NULL,
    [series_id] VARCHAR(13) NULL,
    [scripmap_cd] VARCHAR(13) NULL,
    [reserved1] TINYINT NULL,
    [reserved2] TINYINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfoscrip2
-- --------------------------------------------------
CREATE TABLE [dbo].[bfoscrip2]
(
    [product_type] VARCHAR(5) NULL,
    [product_code] VARCHAR(10) NULL,
    [series_code] VARCHAR(20) NULL,
    [Series_id] INT NULL,
    [series_type] VARCHAR(3) NULL,
    [sec_name] VARCHAR(50) NULL,
    [Expirydate] DATETIME NULL,
    [Maturitydate] DATETIME NULL,
    [OpeningDay] DATETIME NULL,
    [Lifetime] INT NULL,
    [Isin_Code] INT NULL,
    [Base_Price] MONEY NULL,
    [Multiplier] INT NULL,
    [marketsegment] VARCHAR(15) NULL,
    [marketlot] INT NULL,
    [ceilingdepth] INT NULL,
    [callput] VARCHAR(3) NULL,
    [optionstyle] VARCHAR(3) NULL,
    [strikeprice] MONEY NULL,
    [nearseriesid] INT NULL,
    [farseriesid] INT NULL,
    [cor_act_level] INT NULL,
    [reserved1] INT NULL,
    [reserved2] INT NULL,
    [reserved3] INT NULL,
    [reserved4] INT NULL,
    [reserved5] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bfosettlement
-- --------------------------------------------------
CREATE TABLE [dbo].[bfosettlement]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] NUMERIC(18, 0) NULL,
    [Trade_no] VARCHAR(20) NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [product_type] VARCHAR(5) NULL,
    [product_code] VARCHAR(10) NULL,
    [Series_code] VARCHAR(20) NULL,
    [Series_id] INT NULL,
    [expirydate] DATETIME NULL,
    [multiplier] INT NULL,
    [User_id] VARCHAR(7) NOT NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] VARCHAR(3) NOT NULL,
    [Order_no] CHAR(20) NOT NULL,
    [MarketRate] MONEY NULL,
    [strike_price] MONEY NULL,
    [Sauda_date] DATETIME NULL,
    [Table_No] VARCHAR(4) NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Normal] MONEY NULL,
    [Day_puc] MONEY NULL,
    [day_sales] MONEY NULL,
    [Sett_purch] MONEY NULL,
    [Sett_sales] MONEY NULL,
    [Sell_buy] INT NOT NULL,
    [Settflag] INT NULL,
    [Brokapplied] MONEY NULL,
    [NetRate] NUMERIC(15, 7) NULL,
    [Amount] MONEY NULL,
    [Ins_chrg] MONEY NULL,
    [turn_tax] MONEY NULL,
    [other_chrg] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [Broker_chrg] MONEY NULL,
    [Service_tax] MONEY NULL,
    [Trade_amount] MONEY NULL,
    [Billflag] INT NULL,
    [sett_no] VARCHAR(7) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] NUMERIC(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_type] VARCHAR(3) NULL,
    [Order_Date] DATETIME NULL,
    [OppMemCode] VARCHAR(5) NULL,
    [OppTraderCode] VARCHAR(5) NULL,
    [Cl_rate] MONEY NULL,
    [GroupId] VARCHAR(7) NULL,
    [TraderCode] VARCHAR(7) NULL,
    [reserved1] TINYINT NULL,
    [reserved2] TINYINT NULL,
    [reserved3] TINYINT NULL,
    [reserved4] TINYINT NULL,
    [reserved5] TINYINT NULL,
    [status] CHAR(2) NULL,
    [branch_cd] VARCHAR(6) NULL,
    [pro_cli] VARCHAR(6) NULL,
    [participantcode] VARCHAR(15) NULL,
    [cpid] VARCHAR(5) NULL,
    [instrument] VARCHAR(5) NULL,
    [booktype] VARCHAR(5) NULL,
    [branch_id] VARCHAR(5) NULL,
    [scheme] VARCHAR(5) NULL,
    [tmark] VARCHAR(5) NULL,
    [dummy1] INT NULL,
    [dummy2] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BO_client_deposit_recno
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_client_deposit_recno]
(
    [co_Code] VARCHAR(10) NULL,
    [Upd_date] DATETIME NOT NULL,
    [accno] VARCHAR(10) NOT NULL,
    [vtyp] SMALLINT NOT NULL,
    [booktype] CHAR(2) NOT NULL,
    [vno] VARCHAR(12) NOT NULL,
    [vdt] DATETIME NULL,
    [tdate] VARCHAR(30) NULL,
    [ddno] VARCHAR(15) NOT NULL,
    [cltcode] VARCHAR(10) NOT NULL,
    [acname] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [Dramt] MONEY NULL,
    [Cramt] MONEY NULL,
    [treldt] VARCHAR(30) NOT NULL,
    [refno] CHAR(12) NULL,
    [last_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.branches
-- --------------------------------------------------
CREATE TABLE [dbo].[branches]
(
    [Branch_Cd] VARCHAR(50) NOT NULL,
    [Short_Name] VARCHAR(20) NOT NULL,
    [Long_Name] VARCHAR(50) NULL,
    [Address1] VARCHAR(25) NULL,
    [Address2] VARCHAR(25) NULL,
    [City] VARCHAR(20) NULL,
    [State] CHAR(15) NULL,
    [Nation] CHAR(15) NULL,
    [Zip] CHAR(15) NULL,
    [Phone1] CHAR(15) NULL,
    [Phone2] CHAR(15) NULL,
    [Fax] CHAR(15) NULL,
    [Email] CHAR(50) NULL,
    [Remote] BIT NOT NULL,
    [Security_Net] BIT NOT NULL,
    [Money_Net] BIT NOT NULL,
    [Excise_Reg] CHAR(30) NULL,
    [Contact_Person] CHAR(25) NULL,
    [Com_Perc] MONEY NULL,
    [Terminal_Id] VARCHAR(10) NULL,
    [Deftrader] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[Broktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [Table_name] CHAR(25) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [Def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL,
    [branch_code] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client1
-- --------------------------------------------------
CREATE TABLE [dbo].[client1]
(
    [Cl_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Long_Name] VARCHAR(100) NULL,
    [L_Address1] VARCHAR(40) NOT NULL,
    [L_Address2] VARCHAR(40) NULL,
    [L_city] VARCHAR(40) NULL,
    [L_State] VARCHAR(50) NULL,
    [L_Nation] VARCHAR(15) NULL,
    [L_Zip] VARCHAR(10) NULL,
    [Fax] VARCHAR(15) NULL,
    [Res_Phone1] VARCHAR(15) NULL,
    [Res_Phone2] VARCHAR(15) NULL,
    [Off_Phone1] VARCHAR(15) NULL,
    [Off_Phone2] VARCHAR(15) NULL,
    [Email] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Credit_Limit] NUMERIC(13, 2) NULL,
    [Cl_type] VARCHAR(3) NOT NULL,
    [Cl_Status] VARCHAR(3) NOT NULL,
    [Gl_Code] VARCHAR(6) NULL,
    [Fd_Code] VARCHAR(25) NULL,
    [Family] VARCHAR(10) NOT NULL,
    [Penalty] NUMERIC(6, 0) NULL,
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Confirm_fax] TINYINT NOT NULL,
    [PhoneOld] VARCHAR(40) NULL,
    [L_Address3] VARCHAR(40) NULL,
    [Mobile_Pager] VARCHAR(40) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [trader] VARCHAR(20) NULL,
    [Ward_No] VARCHAR(50) NULL,
    [Region] VARCHAR(50) NULL,
    [Area] VARCHAR(20) NULL,
    [Clrating] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client2
-- --------------------------------------------------
CREATE TABLE [dbo].[client2]
(
    [Cl_Code] VARCHAR(10) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Tran_Cat] CHAR(3) NOT NULL,
    [Scrip_cat] NUMERIC(18, 4) NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Table_no] INT NULL,
    [Sub_TableNo] INT NULL,
    [Margin] TINYINT NOT NULL,
    [Turnover_tax] TINYINT NOT NULL,
    [Sebi_Turn_tax] TINYINT NOT NULL,
    [Insurance_Chrg] TINYINT NOT NULL,
    [Service_chrg] TINYINT NOT NULL,
    [Std_rate] INT NULL,
    [P_To_P] INT NULL,
    [exposure_lim] NUMERIC(12, 2) NOT NULL,
    [demat_tableno] INT NULL,
    [BankId] VARCHAR(15) NULL,
    [CltDpNo] VARCHAR(15) NULL,
    [Printf] TINYINT NOT NULL,
    [ALBMDelchrg] TINYINT NULL,
    [ALBMDelivery] TINYINT NULL,
    [AlbmCF_tableno] SMALLINT NULL,
    [MF_tableno] INT NULL,
    [SB_tableno] INT NULL,
    [brok1_tableno] INT NULL,
    [brok2_tableno] INT NULL,
    [brok3_tableno] INT NULL,
    [BrokerNote] TINYINT NULL,
    [Other_chrg] TINYINT NULL,
    [brok_scheme] TINYINT NULL,
    [contcharge] TINYINT NULL,
    [mincontamt] TINYINT NULL,
    [AddLedgerBal] TINYINT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [InsCont] CHAR(1) NULL,
    [SerTaxMethod] INT NULL,
    [dummy6] VARCHAR(5) NULL,
    [dummy7] VARCHAR(4) NULL,
    [dummy8] VARCHAR(20) NULL,
    [dummy9] VARCHAR(20) NULL,
    [dummy10] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client3
-- --------------------------------------------------
CREATE TABLE [dbo].[client3]
(
    [Cl_Code] VARCHAR(10) NULL,
    [Party_Code] CHAR(10) NOT NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Markettype] VARCHAR(15) NOT NULL,
    [Margin] MONEY NOT NULL,
    [Nooftimes] NUMERIC(2, 0) NOT NULL,
    [Margin_Recd] NUMERIC(18, 0) NULL,
    [Mtom] NUMERIC(18, 0) NULL,
    [Pmarginrate] NUMERIC(5, 2) NULL,
    [Mtomdate] DATETIME NULL,
    [Initialmargin] NUMERIC(18, 4) NULL,
    [Mainenancetmargin] NUMERIC(18, 4) NULL,
    [Marginexchange] NUMERIC(18, 4) NULL,
    [Marginbroker] NUMERIC(18, 4) NULL,
    [Dummy1] VARCHAR(4) NULL,
    [Dummy2] VARCHAR(4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client4
-- --------------------------------------------------
CREATE TABLE [dbo].[client4]
(
    [Cl_code] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Instru] TINYINT NOT NULL,
    [BankID] VARCHAR(20) NULL,
    [Cltdpid] VARCHAR(16) NULL,
    [Depository] VARCHAR(7) NULL,
    [DefDp] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client5
-- --------------------------------------------------
CREATE TABLE [dbo].[client5]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [BirthDate] DATETIME NULL,
    [Sex] CHAR(1) NULL,
    [ActiveFrom] DATETIME NULL,
    [InteractMode] TINYINT NULL,
    [RepatriatAC] TINYINT NULL,
    [RepatriatBank] TINYINT NULL,
    [RepatriatACNO] VARCHAR(30) NULL,
    [Introducer] VARCHAR(30) NULL,
    [Approver] VARCHAR(30) NULL,
    [KYCForm] TINYINT NULL,
    [BankCert] TINYINT NULL,
    [Passport] TINYINT NULL,
    [Passportdtl] VARCHAR(30) NULL,
    [VotersID] TINYINT NULL,
    [VotersIDdtl] VARCHAR(30) NULL,
    [ITReturn] TINYINT NULL,
    [ITReturndtl] VARCHAR(30) NULL,
    [Drivelicen] TINYINT NULL,
    [Drivelicendtl] VARCHAR(30) NULL,
    [Rationcard] TINYINT NULL,
    [Rationcarddtl] VARCHAR(30) NULL,
    [Corpdtlrecd] TINYINT NULL,
    [Corpdeed] TINYINT NULL,
    [Anualreport] TINYINT NULL,
    [Networthcert] TINYINT NULL,
    [InactiveFrom] DATETIME NULL,
    [P_Address1] VARCHAR(50) NULL,
    [P_Address2] VARCHAR(50) NULL,
    [P_Address3] VARCHAR(50) NULL,
    [P_City] VARCHAR(20) NULL,
    [P_State] VARCHAR(50) NULL,
    [P_Nation] VARCHAR(15) NULL,
    [P_Phone] VARCHAR(15) NULL,
    [P_Zip] VARCHAR(10) NULL,
    [addemailid] VARCHAR(230) NULL,
    [PassportDateOfIssue] DATETIME NULL,
    [PassportPlaceOfIssue] VARCHAR(30) NULL,
    [VoterIdDateOfIssue] DATETIME NULL,
    [VoterIdPlaceOfIssue] VARCHAR(30) NULL,
    [ITReturnDateOfFiling] DATETIME NULL,
    [LicenceNoDateOfIssue] DATETIME NULL,
    [LicenceNoPlaceOfIssue] VARCHAR(30) NULL,
    [RationCardDateOfIssue] DATETIME NULL,
    [RationCardPlaceOfIssue] VARCHAR(30) NULL,
    [Client_Agre_Dt] DATETIME NULL,
    [Regr_No] VARCHAR(50) NULL,
    [Regr_Place] VARCHAR(50) NULL,
    [Regr_Date] DATETIME NULL,
    [Regr_Auth] VARCHAR(50) NULL,
    [Introd_Client_Id] VARCHAR(50) NULL,
    [Introd_Relation] VARCHAR(50) NULL,
    [Any_Other_Acc] VARCHAR(50) NULL,
    [Sett_Mode] VARCHAR(50) NULL,
    [Dealing_With_Othrer_Tm] VARCHAR(50) NULL,
    [Systumdate] DATETIME NULL,
    [Passportexpdate] DATETIME NULL,
    [Driveexpdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client6
-- --------------------------------------------------
CREATE TABLE [dbo].[client6]
(
    [Cl_Code] VARCHAR(10) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Tran_Cat] CHAR(3) NOT NULL,
    [Scrip_cat] NUMERIC(18, 4) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Table_no] SMALLINT NOT NULL,
    [Sub_TableNo] SMALLINT NOT NULL,
    [Margin] TINYINT NOT NULL,
    [Turnover_tax] TINYINT NOT NULL,
    [Sebi_Turn_tax] TINYINT NOT NULL,
    [Insurance_Chrg] TINYINT NOT NULL,
    [Service_chrg] TINYINT NOT NULL,
    [Std_rate] SMALLINT NOT NULL,
    [P_To_P] SMALLINT NOT NULL,
    [exposure_lim] NUMERIC(12, 2) NOT NULL,
    [demat_tableno] SMALLINT NOT NULL,
    [BankId] VARCHAR(15) NULL,
    [CltDpNo] VARCHAR(15) NULL,
    [Printf] TINYINT NOT NULL,
    [ALBMDelchrg] TINYINT NULL,
    [ALBMDelivery] TINYINT NULL,
    [AlbmCF_tableno] SMALLINT NULL,
    [MF_tableno] SMALLINT NULL,
    [SB_tableno] SMALLINT NULL,
    [brok1_tableno] SMALLINT NULL,
    [brok2_tableno] SMALLINT NULL,
    [brok3_tableno] SMALLINT NULL,
    [BrokerNote] TINYINT NULL,
    [Other_chrg] TINYINT NULL,
    [brok_scheme] TINYINT NULL,
    [Contcharge] TINYINT NULL,
    [MinContAmt] TINYINT NULL,
    [AddLedgerBal] TINYINT NULL,
    [Dummy1] TINYINT NULL,
    [Dummy2] TINYINT NULL,
    [InsCont] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.collateraldetails
-- --------------------------------------------------
CREATE TABLE [dbo].[collateraldetails]
(
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
    [Fd_Type] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.costmast
-- --------------------------------------------------
CREATE TABLE [dbo].[costmast]
(
    [COSTNAME] CHAR(35) NOT NULL,
    [COSTCODE] SMALLINT NOT NULL,
    [CATCODE] SMALLINT NOT NULL,
    [GrpCode] VARCHAR(20) NOT NULL
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
-- TABLE dbo.globals
-- --------------------------------------------------
CREATE TABLE [dbo].[globals]
(
    [year] VARCHAR(4) NULL,
    [exchange] VARCHAR(3) NULL,
    [service_tax] NUMERIC(10, 4) NULL,
    [service_tax_ac] VARCHAR(30) NULL,
    [turnover_ac] INT NULL,
    [sebi_turn_ac] INT NULL,
    [broker_note_ac] INT NULL,
    [other_chrg_ac] INT NULL,
    [exchange_gl_ac] VARCHAR(30) NULL,
    [year_start_dt] DATETIME NULL,
    [year_end_dt] DATETIME NULL,
    [CESS_Tax] NUMERIC(10, 4) NULL,
    [TrdBuyTrans] NUMERIC(18, 4) NULL,
    [TrdSellTrans] NUMERIC(18, 4) NULL,
    [DelBuyTrans] NUMERIC(18, 4) NULL,
    [DelSellTrans] NUMERIC(18, 4) NULL,
    [EDUCESSTAX] NUMERIC(18, 4) NULL,
    [STT_TAX_AC] INT NULL,
    [TOTTAXES_LESS] NUMERIC(18, 6) NULL,
    [TOTTAXES_HIGH] NUMERIC(18, 6) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger]
(
    [Vtyp] SMALLINT NOT NULL,
    [Vno] VARCHAR(12) NULL,
    [Edt] DATETIME NULL,
    [Lno] NUMERIC(4, 0) NULL,
    [Acname] VARCHAR(100) NULL,
    [Drcr] CHAR(1) NULL,
    [Vamt] MONEY NULL,
    [Vdt] DATETIME NULL,
    [Vno1] VARCHAR(12) NULL,
    [Refno] CHAR(12) NULL,
    [Balamt] MONEY NOT NULL,
    [Nodays] INT NULL,
    [Cdt] DATETIME NULL,
    [Cltcode] VARCHAR(10) NOT NULL,
    [Booktype] CHAR(2) NULL,
    [Enteredby] VARCHAR(25) NULL,
    [Pdt] DATETIME NULL,
    [Checkedby] VARCHAR(25) NULL,
    [Actnodays] INT NULL,
    [Narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledger1
-- --------------------------------------------------
CREATE TABLE [dbo].[ledger1]
(
    [Bnkname] VARCHAR(50) NULL,
    [Brnname] VARCHAR(50) NULL,
    [Dd] CHAR(1) NULL,
    [Ddno] VARCHAR(15) NULL,
    [Dddt] DATETIME NULL,
    [Reldt] DATETIME NULL,
    [Relamt] MONEY NULL,
    [Refno] CHAR(12) NOT NULL,
    [Receiptno] INT NULL,
    [Vtyp] SMALLINT NULL,
    [Vno] VARCHAR(12) NULL,
    [Lno] NUMERIC(18, 0) NULL,
    [Drcr] CHAR(1) NULL,
    [Booktype] CHAR(2) NULL,
    [Micrno] INT NULL,
    [Slipno] INT NULL,
    [Slipdate] DATETIME NULL,
    [Chequeinname] VARCHAR(50) NULL,
    [Chqprinted] TINYINT NULL,
    [Clear_mode] CHAR(1) NULL,
    [L1_SNo] BIGINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.parameter
-- --------------------------------------------------
CREATE TABLE [dbo].[parameter]
(
    [sdtcur] DATETIME NULL,
    [ldtcur] DATETIME NULL,
    [ldtprv] DATETIME NULL,
    [sdtnxt] DATETIME NULL,
    [curyear] TINYINT NULL,
    [vnoflag] SMALLINT NULL,
    [Match_BtoB] SMALLINT NULL,
    [Match_CtoC] SMALLINT NULL,
    [maker_checker] SMALLINT NULL,
    [VoucherPrintFlag] SMALLINT NULL,
    [BranchFlag] SMALLINT NULL,
    [ReportDays] SMALLINT NOT NULL,
    [FldAuto] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.region
-- --------------------------------------------------
CREATE TABLE [dbo].[region]
(
    [Regioncode] VARCHAR(10) NULL,
    [Description] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(10) NULL,
    [Dummy1] VARCHAR(1) NULL,
    [Dummy2] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip1
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip1]
(
    [co_code] INT NULL,
    [series] VARCHAR(3) NOT NULL,
    [short_name] VARCHAR(50) NULL,
    [long_name] VARCHAR(50) NULL,
    [market_lot] INT NULL,
    [face_val] FLOAT NULL,
    [book_cl_dt] DATETIME NULL,
    [ex_div_dt] DATETIME NULL,
    [ex_bon_dt] DATETIME NULL,
    [ex_rit_dt] DATETIME NULL,
    [eqt_type] VARCHAR(3) NULL,
    [sub_type] VARCHAR(3) NULL,
    [agent_cd] VARCHAR(6) NULL,
    [demat_flag] SMALLINT NULL,
    [demat_date] DATETIME NULL,
    [rec1] VARCHAR(10) NULL,
    [rec2] VARCHAR(10) NULL,
    [rec3] VARCHAR(10) NULL,
    [rec4] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip2
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip2]
(
    [co_code] INT NULL,
    [series] VARCHAR(3) NOT NULL,
    [exchange] VARCHAR(3) NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [scrip_cat] VARCHAR(3) NULL,
    [no_del_fr] DATETIME NULL,
    [no_del_to] DATETIME NULL,
    [cl_rate] FLOAT NULL,
    [clos_rate_dt] DATETIME NULL,
    [min_trd_qty] INT NULL,
    [BseCode] VARCHAR(10) NULL,
    [Isin] VARCHAR(20) NULL,
    [delsc_cat] VARCHAR(3) NULL,
    [Sector] VARCHAR(10) NULL,
    [Track] VARCHAR(1) NULL,
    [CDOL_No] VARCHAR(15) NULL,
    [Res1] VARCHAR(10) NULL,
    [Res2] VARCHAR(10) NULL,
    [Res3] VARCHAR(10) NULL,
    [Res4] VARCHAR(10) NULL,
    [Globalcustodian] VARCHAR(25) NULL,
    [common_code] VARCHAR(25) NULL,
    [IndexName] VARCHAR(10) NULL,
    [Industry] VARCHAR(10) NULL,
    [Bloomberg] VARCHAR(10) NULL,
    [RicCode] VARCHAR(10) NULL,
    [Reuters] VARCHAR(10) NULL,
    [IES] VARCHAR(10) NULL,
    [NoofIssuedshares] NUMERIC(18, 4) NULL,
    [Status] VARCHAR(10) NULL,
    [ADRGDRRatio] NUMERIC(18, 4) NULL,
    [GEMultiple] NUMERIC(18, 4) NULL,
    [GroupforGE] INT NULL,
    [RBICeilingIndicatorFlag] VARCHAR(2) NULL,
    [RBICeilingIndicatorValue] NUMERIC(18, 4) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sett_mst
-- --------------------------------------------------
CREATE TABLE [dbo].[sett_mst]
(
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.subbrokers
-- --------------------------------------------------
CREATE TABLE [dbo].[subbrokers]
(
    [Sub_Broker] VARCHAR(10) NOT NULL,
    [Name] CHAR(30) NULL,
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
    [Email] CHAR(50) NULL,
    [Com_Perc] MONEY NULL,
    [branch_code] VARCHAR(10) NULL,
    [Contact_Person] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_clientmargin
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_clientmargin]
(
    [Party_Code] VARCHAR(15) NOT NULL,
    [Margindate] DATETIME NOT NULL,
    [Billamount] MONEY NOT NULL,
    [Ledgeramount] MONEY NOT NULL,
    [Cash_Coll] MONEY NOT NULL,
    [Noncash_Coll] MONEY NOT NULL,
    [Initialmargin] MONEY NOT NULL,
    [Lst_Update_Dt] DATETIME NOT NULL,
    [Short_Name] VARCHAR(100) NULL,
    [Long_Name] VARCHAR(100) NULL,
    [Branch_Cd] VARCHAR(20) NULL,
    [Family] VARCHAR(20) NULL,
    [Sub_Broker] VARCHAR(20) NULL,
    [Trader] VARCHAR(20) NULL,
    [Mtmmargin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vmast
-- --------------------------------------------------
CREATE TABLE [dbo].[vmast]
(
    [Vtype] SMALLINT NOT NULL,
    [Vdesc] VARCHAR(35) NOT NULL,
    [Shortdesc] CHAR(6) NULL,
    [Dispflag] CHAR(1) NULL,
    [Narration] VARCHAR(234) NULL
);

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
-- VIEW dbo.ROE_Bank_Balance
-- --------------------------------------------------
CREATE view ROE_Bank_Balance
as
select b.branch_Code,b.segment,a.cltcode,Fund_Balance=sum(case when drcr='D' then -vamt else vamt end)            
from  
(select cltcode,drcr,vamt,vdt from accountbfo.dbo.ledger with (nolock) where vdt >=
(select sdtcur from accountbfo.dbo.parameter with (nolock) where sdtcur <=getdate() and ldtcur >=getdate())   
and vdt<=getdate()) a,            
(select * from intranet.roe.dbo.FF_bank_Details with (nolock) where segment='BSEFO') b            
where a.cltcode=b.cltcode            
group by b.branch_Code,b.segment,a.cltcode

GO

-- --------------------------------------------------
-- VIEW dbo.ROE_GetAcMast
-- --------------------------------------------------


CREATE view [dbo].[ROE_GetAcMast]
as
select cltcode from AngelBSECM.accountbfo.dbo.acmast with (nolock) where       
grpcode in (select grpcode from intranet.roe.dbo.ff_bank_grpcode with (nolock) where segment='BSEFO')      
and cltcode not in         
(select cltcode from intranet.roe.dbo.ff_bank_details with (nolock) where segment='BSEFO' and cltcode <> 0)

GO

-- --------------------------------------------------
-- VIEW dbo.ROE_GetHOfund
-- --------------------------------------------------
CREATE view ROE_GetHOfund
as
select Fund_balance=sum(case when drcr='D' then -vamt else vamt end)
from accountbfo.dbo.ledger with (nolock)
where vdt >= (select sdtcur from accountbfo.dbo.parameter with (nolock) where sdtcur <=getdate() and ldtcur >=getdate())
and vdt<=getdate() and cltcode in (select cltcode from ROE_GetAcMast)

GO

