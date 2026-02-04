-- DDL Export
-- Server: 10.253.33.89
-- Database: PS03
-- Exported: 2026-02-05T02:39:14.943027

USE PS03;
GO

-- --------------------------------------------------
-- INDEX dbo.fo_termid_list
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_segment] ON [dbo].[fo_termid_list] ([segment])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fo_ser_tax
-- --------------------------------------------------
CREATE proc fo_ser_tax(@pcode as varchar(20),@sdate as varchar(20),@edate as varchar(20))

as
select 
--turntax = (sum((Strike_Price+convert(float,Price))*Tradeqty)* 0.000042) 
turntax = (sum((Strike_Price+convert(float,Price))*Tradeqty)* 0.00005) 
from newfotrd 
where convert(datetime,left(sauda_date,11)) 
between @sdate and @edate 
and party_code = @pcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote
-- --------------------------------------------------
CREATE procedure margin_debitnote ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))
as
--declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)
--set @ssauda_Date = 'May 1 2004'
--set @esauda_Date = 'May 1 2004'
--set @spcode = 'A001'
--set @epcode = 'Z999'
set @epcode = @epcode + 'ZZZ'


select sauda_Date,party_code = isnull(ms.party_code,'no data') , party_name = c1.long_name , 
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch , 
add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3, city=c1.l_city,state=c1.l_state, pin=c1.l_zip,
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,
 span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date 
and ms.party_code >= @spcode and ms.party_Code <= @epcode
--and c1.branch_Cd = @branch_Cd
--and c1.sub_broker = @sub_broker
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip
--having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 used if opp values are to be displayed
having sum(shortage)*100/sum(span_prem) <= -20 
order by ms.party_Code , ms.sauda_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_debitnote_opp
-- --------------------------------------------------
CREATE procedure margin_debitnote_opp ( @ssauda_date datetime,@esauda_date datetime, @spcode varchar(25), @epcode varchar(25))
as
--declare @ssauda_date varchar(11),@esauda_date varchar(11), @spcode varchar(25), @epcode varchar(25)
--set @ssauda_Date = 'May 1 2004'
--set @esauda_Date = 'May 1 2004'
--set @spcode = 'A001'
--set @epcode = 'Z999'


select sauda_Date,party_code = isnull(ms.party_code,'no data') , party_name = c1.long_name , 
 branch_Cd = isnull(c1.branch_cd,'no data') ,-- branch_name = br.branch , 
add1=c1.l_address1,add2=c1.l_address2,add3=c1.l_address3, city=c1.l_city,state=c1.l_state, pin=c1.l_zip,
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,
 span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date >= @ssauda_date and sauda_date <= @esauda_date 
and ms.party_code >= @spcode and ms.party_Code <= @epcode
--and c1.branch_Cd = @branch_Cd
--and c1.sub_broker = @sub_broker
group by ms.sauda_Date,ms.party_code , c1.long_name, c1.l_address1, c1.branch_cd,
c1.l_address2,c1.l_address3,c1.l_city,c1.l_state,c1.l_zip
having sum(shortage)*100/sum(span_prem) > -20 and sum(shortage) < 0 
--used if opp values are to be displayed
--having sum(shortage)*100/sum(span_prem) <= -20 
order by ms.party_Code , ms.sauda_date

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_branch
-- --------------------------------------------------
CREATE procedure margin_report_branch (@sauda_date as datetime)
as
---query to view shortage report branch wise
if @sauda_date = ''
	set @sauda_date = convert(datetime , left(getdate(),11))
select @sauda_date = convert(varchar(11),@sauda_date)
select branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2)) 
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
where sauda_date = @sauda_date
group by c1.branch_cd , br.branch

union

select branch_Cd = 'zzzz', ' Total : ' , Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2)) 
 from margin_short 
where sauda_date = @sauda_date
order by branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_party_code
-- --------------------------------------------------
CREATE procedure margin_report_party_code (@sauda_date as datetime , @branch_Cd as varchar(25) , @sub_broker as varchar(25))
as
---query to view shortage report branch wise
if @sauda_date = ''
	set @sauda_date = convert(datetime , left(getdate(),11))
select @sauda_date = convert(varchar(11),@sauda_date)
select party_code = isnull(ms.party_code,'no data') , party_name = c1.long_name , 
-- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
 Span = convert(varchar,sum(Span)) , Premium =convert(varchar,sum(Premium)) ,
 span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2))
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
and c1.sub_broker = @sub_broker
group by ms.party_code , c1.long_name
--, c1.branch_cd , br.branch

union

select 'zzzz', ' Total : ' , 
 --branch_Cd = c1.branch_cd , ' ' , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2))
 from margin_short ms
 left join angelfo.nsefo.dbo.client2 c2 
 on c2.party_code = ms.party_code
 join angelfo.nsefo.dbo.client1 c1
 on c1.cl_code = c2.cl_code
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
and c1.sub_broker = @sub_broker
--group by c1.branch_Cd
order by party_code , c1.long_name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.margin_report_sub_broker
-- --------------------------------------------------
CREATE procedure margin_report_sub_broker (@sauda_date as datetime , @branch_Cd as varchar(25))
as
---query to view shortage report branch wise
if @sauda_date = ''
	set @sauda_date = convert(datetime , left(getdate(),11))
select @sauda_date = convert(varchar(11),@sauda_date)
select sub_broker = isnull(c1.sub_broker,'no data') , sub_broker_name = sb.name , 
-- branch_Cd = isnull(c1.branch_cd,'no data') , branch_name = br.branch , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round(sum(shortage)*100/sum(span_prem),2)) 
 from margin_short ms left join
 angelfo.nsefo.dbo.client2 c2 
 on ms.party_code = c2.party_code
 left join angelfo.nsefo.dbo.client1 c1 
 on c1.cl_code = c2.cl_code
 left join angelfo.nsefo.dbo.branch br
 on c1.branch_cd = br.branch_code
 left join angelfo.nsefo.dbo.subbrokers sb
 on c1.sub_broker = sb.sub_broker
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
group by c1.sub_broker , sb.name 
--, c1.branch_cd , br.branch

union

select 'zzzz', ' Total : ' , 
 --branch_Cd = c1.branch_cd , ' ' , 
 Span = convert(varchar,sum(Span)) , Premium = convert(varchar,sum(Premium)) , 
span_prem = convert(varchar,sum(span_prem)) 
 , Mtm_Value = convert(varchar,sum(Mtm_Value)) , Collected = convert(varchar,sum(Collected)) ,
 shortage = convert(varchar,sum(shortage)) , perc_shortage = convert(varchar,round((sum(shortage)*100/sum(span_prem)),2)) 
 from margin_short ms
 left join angelfo.nsefo.dbo.client2 c2 
 on c2.party_code = ms.party_code
 join angelfo.nsefo.dbo.client1 c1
 on c1.cl_code = c2.cl_code
where sauda_date = @sauda_date
and c1.branch_Cd = @branch_Cd
group by c1.branch_Cd
order by sub_broker , name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mismatch_notin_bo
-- --------------------------------------------------
CREATE procedure mismatch_notin_bo @pos_date varchar(11)
as
--query to list data in nse but not in boffice
select @pos_date = convert(varchar(11),convert(datetime,@pos_date),100)
select status= 'Not in BOffice',
Client_Account_Code, 
Symbol, Instrument_Type, 
Expiry_date, 
Strike_price=convert(float,Strike_Price), 
Option_type=(case when Option_Type='' then 'FF' else Option_Type end),
NET_Qty =(case when Post_Ex_Asgmnt_Long_Quantity = 0 then -1*Post_Ex_Asgmnt_Short_Quantity else Post_Ex_Asgmnt_Long_Quantity end),
Position_Date 
from nseps03 
where  (Post_Ex_Asgmnt_Long_Quantity>0 or Post_Ex_Asgmnt_Short_Quantity>0) 
and convert(datetime,position_date) = @pos_date
and not exists
(
select 
Party_Code, Symbol, Inst_type, Exp_date, 
Strike_price = convert(float,Strike_price),Option_type, NETQty,Position_Date
from bofficeps03 
where convert(datetime,position_date) = @pos_date
and party_code= nseps03.Client_Account_Code
and bofficeps03.Symbol = nseps03.Symbol
and inst_type = nseps03.Instrument_Type
and convert(datetime,exp_date,103)= convert(datetime,nseps03.expiry_date)
and convert(float,bofficeps03.strike_price)= convert(float,nseps03.strike_price)
and bofficeps03.Option_type= (case when nseps03.Option_type='FF' then '' else nseps03.Option_type end)
and bofficeps03.netqty= (case when nseps03.Post_Ex_Asgmnt_Long_Quantity = 0 then -1*nseps03.Post_Ex_Asgmnt_Short_Quantity else nseps03.Post_Ex_Asgmnt_Long_Quantity end)
)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mismatch_notin_nse
-- --------------------------------------------------
CREATE procedure mismatch_notin_nse @pos_date varchar(11)
as
--query to list data in boffice but not in nse
select @pos_date = convert(varchar(11),convert(datetime,@pos_date),100)
select status='Not in NSE',
Party_Code, Symbol, Inst_type, Exp_date, 
Strike_price = convert(float,Strike_price),
Option_type=(case when Option_Type='' then 'FF' else Option_Type end), 
NETQty,Position_Date
from bofficeps03 where convert(datetime,position_date) = @pos_date
and not exists
(
select 
Client_Account_Code, 
Symbol, Instrument_Type, 
Expiry_date, 
Strike_price=convert(float,Strike_Price), 
option_type,
NET_Qty =(case when Post_Ex_Asgmnt_Long_Quantity = 0 then -1*Post_Ex_Asgmnt_Short_Quantity else Post_Ex_Asgmnt_Long_Quantity end),
Position_Date 
from nseps03 
where  (Post_Ex_Asgmnt_Long_Quantity>0 or Post_Ex_Asgmnt_Short_Quantity>0) 
and convert(datetime,position_date) = @pos_date
--and bo.inst_type = Instrument_Type
--and bo.Symbol = nseps03.Symbol
--and bo.party_code= nseps03.Client_Account_Code
and party_code= nseps03.Client_Account_Code
and bofficeps03.Symbol = nseps03.Symbol
and inst_type = nseps03.Instrument_Type
and convert(datetime,exp_date,103)= convert(datetime,nseps03.expiry_date)
and convert(float,bofficeps03.strike_price)= convert(float,nseps03.strike_price)
and bofficeps03.Option_type= (case when nseps03.Option_type='FF' then '' else nseps03.Option_type end)
and bofficeps03.netqty= (case when nseps03.Post_Ex_Asgmnt_Long_Quantity = 0 then -1*nseps03.Post_Ex_Asgmnt_Short_Quantity else nseps03.Post_Ex_Asgmnt_Long_Quantity end)
)

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
-- PROCEDURE dbo.ret_cl_rate
-- --------------------------------------------------
CREATE proc ret_cl_rate 
@symbol varchar(15),
@inst_type varchar(10),
@expirydate varchar(15),
@option_type varchar(5),
@strike_price varchar(10),
@trade_date varchar(15)
as
if Len(@trade_date) = 10
Begin
	set @trade_date = STUFF(@trade_date, 4, 1,'  ')
End 
select cl_rate,inst_type,expirydate,symbol,option_type ,strike_price 
from angelfo.nsefo.dbo.foclosing 
where symbol = @symbol
and inst_type = @inst_type
and expirydate = convert(datetime,@expirydate) +' 23:59:00.000' 
and (case when option_type='' then 'XX' else option_type end) = @option_type 
and strike_price = convert(money,@strike_price) 
and convert(varchar(11),trade_date) like @trade_date+'%' 
--exec ret_cl_rate 'SATYAMCOMP', 'FUTSTK', '24 DEC 2003', 'XX', '0.00', 'Dec 5 2003'

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
-- TABLE dbo.bofficeps03
-- --------------------------------------------------
CREATE TABLE [dbo].[bofficeps03]
(
    [Party_Code] CHAR(11) NULL,
    [Party_Name] CHAR(22) NULL,
    [cli_type] CHAR(5) NULL,
    [Symbol] CHAR(11) NULL,
    [Inst_type] CHAR(7) NULL,
    [Exp_date] CHAR(10) NULL,
    [Strike_price] CHAR(5) NULL,
    [Option_type] CHAR(6) NULL,
    [BuyQty] CHAR(7) NULL,
    [Buy_Rate] CHAR(16) NULL,
    [Selqty] CHAR(7) NULL,
    [Sell_Rate] CHAR(16) NULL,
    [NETQty] CHAR(7) NULL,
    [Net_Value] CHAR(16) NULL,
    [Avg_Price] CHAR(16) NULL,
    [Net_Cl_Val] CHAR(16) NULL,
    [Cl_Price] CHAR(16) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clrates
-- --------------------------------------------------
CREATE TABLE [dbo].[clrates]
(
    [type] VARCHAR(25) NULL,
    [inst_type] VARCHAR(25) NULL,
    [symbol] VARCHAR(50) NULL,
    [expirydate] VARCHAR(25) NULL,
    [strike_price] VARCHAR(25) NULL,
    [option_type] VARCHAR(25) NULL,
    [cl_price] VARCHAR(25) NULL,
    [Col008] VARCHAR(25) NULL,
    [Col009] VARCHAR(25) NULL,
    [Col010] VARCHAR(25) NULL,
    [cl_price1] VARCHAR(25) NULL,
    [Col012] VARCHAR(25) NULL,
    [Col013] VARCHAR(25) NULL,
    [Col014] VARCHAR(25) NULL,
    [Col015] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.currency_termid_list
-- --------------------------------------------------
CREATE TABLE [dbo].[currency_termid_list]
(
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_error_report
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_error_report]
(
    [party_code] VARCHAR(20) NULL,
    [pcode_branch_cd] VARCHAR(10) NULL,
    [pcode_sub_broker] VARCHAR(10) NULL,
    [termid] VARCHAR(20) NULL,
    [termid_branch_cd] VARCHAR(10) NULL,
    [termid_sub_broker] VARCHAR(10) NULL,
    [termid_branch_cd_alt] VARCHAR(10) NULL,
    [termid_sub_broker_alt] VARCHAR(10) NULL,
    [remark] VARCHAR(255) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_termid_list
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_termid_list]
(
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[fotrd]
(
    [scripno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] VARCHAR(50) NULL,
    [sauda_date1] VARCHAR(50) NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ledgertrial
-- --------------------------------------------------
CREATE TABLE [dbo].[ledgertrial]
(
    [vtyp] SMALLINT NULL,
    [vno] VARCHAR(12) NULL,
    [acname] VARCHAR(35) NULL,
    [drcr] CHAR(1) NULL,
    [vamt] MONEY NULL,
    [vdt] DATETIME NULL,
    [refno] CHAR(12) NULL,
    [balamt] MONEY NULL,
    [cdt] DATETIME NULL,
    [cltcode] VARCHAR(10) NULL,
    [EnteredBy] VARCHAR(25) NULL,
    [CheckedBy] VARCHAR(25) NULL,
    [narration] VARCHAR(234) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.margin_short
-- --------------------------------------------------
CREATE TABLE [dbo].[margin_short]
(
    [sauda_date] DATETIME NULL,
    [Party_code] VARCHAR(25) NULL,
    [Span] MONEY NULL,
    [Premium] MONEY NULL,
    [span_prem] MONEY NULL,
    [Mtm_Value] MONEY NULL,
    [Cl_Type] VARCHAR(25) NULL,
    [Collected] MONEY NULL,
    [Shortage] MONEY NULL,
    [Error_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.netpos_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[netpos_temp]
(
    [party_code] CHAR(11) NULL,
    [inst_type] CHAR(10) NULL,
    [symbol] CHAR(13) NULL,
    [sec_name] CHAR(66) NULL,
    [expirydate] CHAR(12) NULL,
    [pqty] INT NULL,
    [sqty] INT NULL,
    [strike_price] CHAR(14) NULL,
    [option_type] CHAR(10) NULL,
    [price] CHAR(8) NULL,
    [clrate] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfosettlement
-- --------------------------------------------------
CREATE TABLE [dbo].[newfosettlement]
(
    [ContractNo] VARCHAR(14) NOT NULL,
    [BillNo] VARCHAR(10) NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Inst_type] VARCHAR(6) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Sec_name] VARCHAR(25) NOT NULL,
    [Expirydate] DATETIME NULL,
    [Strike_price] MONEY NULL,
    [Option_type] VARCHAR(2) NULL,
    [User_id] INT NOT NULL,
    [Pro_cli] INT NULL,
    [O_C_Flag] VARCHAR(5) NULL,
    [C_U_Flag] VARCHAR(7) NULL,
    [Tradeqty] INT NULL,
    [AuctionPart] VARCHAR(2) NULL,
    [MarketType] VARCHAR(2) NULL,
    [Series] CHAR(2) NOT NULL,
    [Order_no] VARCHAR(15) NOT NULL,
    [Price] MONEY NULL,
    [Sauda_date] DATETIME NOT NULL,
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
    [sett_no] VARCHAR(12) NULL,
    [NBrokApp] MONEY NULL,
    [NSerTax] MONEY NULL,
    [N_NetRate] NUMERIC(15, 7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [Cl_Rate] MONEY NULL,
    [ParticipantCode] VARCHAR(15) NULL,
    [Status] VARCHAR(2) NULL,
    [CpId] INT NULL,
    [Instrument] INT NULL,
    [BookType] INT NULL,
    [Branch_Id] VARCHAR(15) NULL,
    [TMark] INT NULL,
    [Scheme] INT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [Reserved1] INT NULL,
    [Reserved2] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_closing
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_closing]
(
    [tradeno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_error
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_error]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd_temp]
(
    [tradeno] VARCHAR(50) NULL,
    [svalue11] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Expirydate] VARCHAR(50) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Sec_name] VARCHAR(50) NULL,
    [svalue1] VARCHAR(50) NULL,
    [svalue_1] VARCHAR(50) NULL,
    [termid] VARCHAR(50) NULL,
    [termid_location] VARCHAR(50) NULL,
    [Sell_buy] VARCHAR(50) NULL,
    [Tradeqty] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokerid] VARCHAR(50) NULL,
    [svalue10] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(50) NULL,
    [svaluenil] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrd1
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrd1]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrdbackup
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrdbackup]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newfotrdbackup1
-- --------------------------------------------------
CREATE TABLE [dbo].[newfotrdbackup1]
(
    [tradeno] VARCHAR(25) NULL,
    [svalue11] VARCHAR(25) NULL,
    [symbol] VARCHAR(25) NULL,
    [Inst_type] VARCHAR(25) NULL,
    [Expirydate] VARCHAR(25) NULL,
    [Strike_price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(25) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue1] VARCHAR(25) NULL,
    [svalue_1] VARCHAR(25) NULL,
    [termid] INT NULL,
    [termid_location] INT NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [s_value_1] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [brokerid] VARCHAR(25) NULL,
    [svalue10] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [sauda_date1] DATETIME NULL,
    [Order_no] VARCHAR(25) NULL,
    [svaluenil] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newtermid
-- --------------------------------------------------
CREATE TABLE [dbo].[newtermid]
(
    [termid] VARCHAR(15) NULL,
    [party_code] VARCHAR(15) NULL,
    [party_name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nseps03
-- --------------------------------------------------
CREATE TABLE [dbo].[nseps03]
(
    [Position_Date] VARCHAR(50) NULL,
    [Segment_Indicator] VARCHAR(50) NULL,
    [Settlement_Type] VARCHAR(50) NULL,
    [Clearing_Member_Code] VARCHAR(50) NULL,
    [Member_Type] VARCHAR(50) NULL,
    [Trading_Member_Code] VARCHAR(50) NULL,
    [Account_Type] VARCHAR(50) NULL,
    [Client_Account_Code] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] FLOAT NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [Brought_Forward_Long_Quantity] FLOAT NULL,
    [Brought_Forward_Long_Value] FLOAT NULL,
    [Brought_Forward_Short_Quantity] FLOAT NULL,
    [Brought_Forward_Short_Value] FLOAT NULL,
    [Day_Buy_Open_Quantity] FLOAT NULL,
    [Day_Buy_Open_Value] FLOAT NULL,
    [Day_Sell_Open_Quantity] FLOAT NULL,
    [Day_Sell_Open_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Pre_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Exercised_Quantity] FLOAT NULL,
    [Assigned_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Long_Value] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Quantity] FLOAT NULL,
    [Post_Ex_Asgmnt_Short_Value] FLOAT NULL,
    [Settlement_Price] FLOAT NULL,
    [Net_Premium] FLOAT NULL,
    [Daily_MTM_Settlement_Value] FLOAT NULL,
    [Futures_Final_Settlement_Value] FLOAT NULL,
    [Exercised_Assigned_Value] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception]
(
    [party_code] VARCHAR(30) NULL,
    [segment] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception_currency
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception_currency]
(
    [party_code] VARCHAR(30) NULL,
    [segment] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_fotrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_fotrd]
(
    [termid] FLOAT NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ps03]
(
    [Status] VARCHAR(50) NULL,
    [P_Code] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Inst_type] VARCHAR(50) NULL,
    [Exp_date] VARCHAR(50) NULL,
    [Str_pr] VARCHAR(50) NULL,
    [Opt_type] VARCHAR(50) NULL,
    [NET_Qty] VARCHAR(50) NULL,
    [position_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.termid_mapping
-- --------------------------------------------------
CREATE TABLE [dbo].[termid_mapping]
(
    [new_termid] VARCHAR(15) NULL,
    [old_termid] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.trade15
-- --------------------------------------------------
CREATE TABLE [dbo].[trade15]
(
    [Col001] VARCHAR(50) NULL,
    [Col002] VARCHAR(50) NULL,
    [Col003] VARCHAR(50) NULL,
    [Col004] VARCHAR(50) NULL,
    [Col005] VARCHAR(50) NULL,
    [Col006] VARCHAR(50) NULL,
    [Col007] VARCHAR(50) NULL,
    [Col008] VARCHAR(50) NULL,
    [Col009] VARCHAR(50) NULL,
    [Col010] VARCHAR(50) NULL,
    [Col011] VARCHAR(50) NULL,
    [Col012] VARCHAR(50) NULL,
    [Col013] VARCHAR(50) NULL,
    [Col014] VARCHAR(50) NULL,
    [Col015] VARCHAR(50) NULL,
    [Col016] VARCHAR(50) NULL,
    [Col017] VARCHAR(50) NULL,
    [Col018] VARCHAR(50) NULL,
    [Col019] VARCHAR(50) NULL,
    [Col020] VARCHAR(50) NULL,
    [Col021] VARCHAR(50) NULL,
    [Col022] VARCHAR(50) NULL,
    [Col023] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Get_LastAccessDate
-- --------------------------------------------------
create view Get_LastAccessDate
as

select 
b.name,b.xtype,Created_on=b.crdate,
Last_user_Access_date=
(case when
--chk_date1=
(case when 
isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900')) end)

>
--chk_date1=

(case when 
isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900')) end)

then

(case when 
isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_seek,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_scan,convert(datetime,'Jan  1 1900')) end)

else 

(case when 
isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) > isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900'))
then isnull(a.Last_user_update,convert(datetime,'Jan  1 1900')) 
else isnull(a.Last_user_lookup,convert(datetime,'Jan  1 1900')) end)
end
)
from sys.dm_db_index_usage_stats a, sysobjects b
where a.object_id =b.id

GO

