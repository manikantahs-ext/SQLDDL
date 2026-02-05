-- DDL Export
-- Server: 10.253.78.163
-- Database: NBFC
-- Exported: 2026-02-05T12:30:01.182108

USE NBFC;
GO

-- --------------------------------------------------
-- INDEX dbo.nbfc_findata
-- --------------------------------------------------
CREATE CLUSTERED INDEX [party_code] ON [dbo].[nbfc_findata] ([PARTY_CODE], [td_date])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.abl_ageing
-- --------------------------------------------------
CREATE procedure abl_ageing (@cdate as varchar(25),@pcode as varchar(10))
as
/*
declare @cdate as varchar(11)
set @cdate = 'Dec  8 2004'
*/
select x.*,holdvalue=isnull(y.holdvalue,0),liquid=
(case when isnull(y.holdvalue,0) <= balance-isnull(y.holdvalue,0) then isnull(y.holdvalue,0) 
else balance-isnull(y.holdvalue,0) end)
from
(
select a.party_Code,a.party_name, balance=isnull(balance,0) from
(SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate and party_code=@pcode) a 
left outer join
(select * from tally_group where upper(drcr)='DR' and upd_date = @cdate) b
 on a.party_Code=b.clcd
) x left outer join
(
select clcd,holdvalue=sum(holdvalue) from holding_position where hold_date <= @cdate and hold_date >=
(select min(start_date) from(
select top 5 start_date from anand.bsedb_ab.dbo.sett_mst where start_date <=@cdate and sett_type='D'
order by start_date desc)  x) group by clcd
) y on x.party_Code=y.clcd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.calc
-- --------------------------------------------------
CREATE procedure calc (@sett_Date as varchar(11))
AS

--- Calculate Shortage amount for t-2 day
/*
update nbfc_data set x_shortage = b.x_shortage 
from (select td_date,party_Code,x_shortage=bill_amt-sum(pamtdel)-sum(case 
when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel  
when sqtydel > 0 and sqtydel+holding <  sqtydel then (sqtydel+holding)*(samtdel/sqtydel) 
else 0 end) from nbfc_data where td_Date=sauda_date 
group by td_date,balancetd,party_Code,party_name,bill_amt ) b 
where nbfc_data.td_Date=b.td_date and nbfc_data.party_Code=b.party_code 
*/

--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-2
--update nbfc_data set x_shortage = balancetd 


--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-3
/*
update nbfc_data set x_shortage = c.balancetd
from
(
select distinct a.party_code,a.td_Date,balancetd from nbfc_findata a,
(
select party_code,td_date=max(td_date) from nbfc_findata 
where td_Date < (select max(sauda_date) from nbfc_Data where td_Date <> sauda_Date)
group by party_Code) b 
where a.party_Code=b.party_Code and a.td_Date=b.td_Date
) c where nbfc_data.party_code=c.party_Code 
*/
--- fetch shortage amount from actual trading day

update nbfc_data set shortage = b.x_shortage 
from ( select distinct td_date,party_code,x_shortage 
from nbfc_findata where td_date=sauda_date and funds_payin = @sett_date )B 
where nbfc_data.party_Code=b.party_code 


--- Store Previous Day Shortage Value
/*
update nbfc_data set prev_shortage = b.shortage 
from ( select distinct a.td_date,a.party_code,a.shortage 
from nbfc_findata a, (select party_code, td_date=max(td_date) from nbfc_findata 
where td_Date < @sett_date group by party_code) b 
where a.party_code=b.party_code and a.td_Date=b.td_Date and a.td_date=a.sauda_date 
and a.td_Date < @sett_date )B 
where nbfc_data.td_Date=@sett_date and nbfc_data.party_Code=b.party_code 
*/

--- Now 19-11-2004 20:06 Sandeep had changed the value of Prev.Shortage
--- Now Prev.Shortage = Shortage

update nbfc_data set prev_shortage = shortage

--- Update all holding value with 0 where holding is null
update nbfc_data set holding = 0 where holding is null 


--- Calculate 90% sell_value for funding return on trading day
/*
update nbfc_data set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.90
when sqtydel > 0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date
*/

update nbfc_data set sell_value =
--(case when sqtydel > 0 and holding-sqtydel >= sqtydel then samtdel*.90
(case when sqtydel > 0 and holding+sqtydel >= sqtydel then samtdel*.90
when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date


--- Calculate 10% sell_value for funding return on settlement day

update nbfc_data set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.10
when sqtydel > 0 and holding+sqtydel >0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.10
else 0 end) where td_Date=funds_payin


--- set sell_value to 0 whose 90% funding return was not calculated on trading day

update nbfc_data set sell_value = 0 from
(
select a.* from (select td_Date,sauda_Date,scrip_cd,party_Code,sqtydel,samtdel,sell_value from nbfc_Data where funds_payin=td_Date) a, 
(select td_Date,party_Code,scrip_Cd,sqtydel,sell_value from nbfc_findata where sauda_Date=td_Date)b 
where b.td_Date=a.sauda_date and a.party_code=b.party_code and a.scrip_Cd=b.scrip_cd
and a.sell_Value > 0 and b.sell_value = 0
) b where b.party_code=nbfc_data.party_Code and b.scrip_cd=nbfc_data.scrip_cd and nbfc_data.td_Date=nbfc_data.funds_payin


--- Calculate Amount to be given to NBFC

update nbfc_data set tobegiven=(case when b.tobegiven >= 0 then b.tobegiven else 0 end)
from
(
select party_code, td_Date, 
tobegiven=(case 
--when sum(sell_value) > 0 and prev_shortage < 0 then sum(sell_value)
--when sum(sell_value) > 0 and prev_shortage > 0 then prev_shortage-sum(sell_value)
when sum(sell_value) > 0 and prev_shortage <= 0 then sum(sell_value)
when sum(sell_value) > 0 and prev_shortage > 0  then sum(sell_value)-prev_shortage
else 0 end), sell_value=sum(sell_value),prev_shortage from nbfc_data
group by party_code, td_Date, prev_shortage
) b where nbfc_data.party_code=b.party_code 
--and nbfc_data.td_Date=nbfc_data.sauda_Date

--- Update nbfc_findata (final data file)

delete from nbfc_findata where td_Date = @sett_Date
insert into nbfc_findata select * from nbfc_data

--- End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.calc1
-- --------------------------------------------------
CREATE procedure calc1 (@sett_Date as varchar(11),@acdate as varchar(11))
AS

--- Calculate Shortage amount for t-2 day
/*
update nbfc_data set x_shortage = b.x_shortage 
from (select td_date,party_Code,x_shortage=bill_amt-sum(pamtdel)-sum(case 
when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel  
when sqtydel > 0 and sqtydel+holding <  sqtydel then (sqtydel+holding)*(samtdel/sqtydel) 
else 0 end) from nbfc_data where td_Date=sauda_date 
group by td_date,balancetd,party_Code,party_name,bill_amt ) b 
where nbfc_data.td_Date=b.td_date and nbfc_data.party_Code=b.party_code 
*/

--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-2
--update nbfc_data set x_shortage = balancetd 


--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-3
/*
update nbfc_data set x_shortage = c.balancetd
from
(
select distinct a.party_code,a.td_Date,balancetd from nbfc_findata a,
(
select party_code,td_date=max(td_date) from nbfc_findata 
where td_Date < (select max(sauda_date) from nbfc_Data where td_Date <> sauda_Date)
group by party_Code) b 
where a.party_Code=b.party_Code and a.td_Date=b.td_Date
) c where nbfc_data.party_code=c.party_Code 
*/
--- fetch shortage amount from actual trading day


--update nbfc_data set shortage = b.x_shortage 
--from ( select distinct td_date,party_code,x_shortage 
--from nbfc_findata where td_date=sauda_date and funds_payin = 'Dec 10 2004' )B 
--where nbfc_data.party_Code=b.party_code 

/*
declare @sdate as varchar(11)
select @sdate = start_date from anand.bsedb_ab.dbo.sett_mst where funds_payin='Feb 21 2005' and sett_type='D'
--print @sdate

update nbfc_data set shortage = b.openingTD
from(
select cltcode,OpeningTD=sum(case when upper(drcr)='D' and vdt<=@sdate+' 00:00:00' then vamt 
when upper(drcr)='C' and vdt<=@sdate+' 00:00:00' then -vamt else 0 end) from anand.account_ab.dbo.ledger
where vdt >='Apr  1 2004 00:00:00' and cltcode >='A0001' and cltcode <= 'ZZZZZ' 
group by cltcode ) B
where nbfc_data.party_Code=b.cltcode
*/

update nbfc_data set gap_bill = b.gap_bill
from
(
select a.party_code,gap_bill=sum(case when upper(c.drcr)='D' then vamt else -vamt end)
from (select distinct party_code,td_date from nbfc_data) a, anand.bsedb_Ab.dbo.sett_mst b, anand.account_ab.dbo.ledger c 
where b.funds_payin = a.td_date and b.sett_type='D' and c.cltcode=a.party_Code and c.vdt >= b.start_date+1 and c.vdt <= b.funds_payin+1
and c.vtyp=15 group by a.party_code
) b where nbfc_data.party_Code=b.party_Code

update nbfc_data set shortage = balancetd - gap_bill


--- Store Previous Day Shortage Value
/*
update nbfc_data set prev_shortage = b.shortage 
from ( select distinct a.td_date,a.party_code,a.shortage 
from nbfc_findata a, (select party_code, td_date=max(td_date) from nbfc_findata 
where td_Date < @sett_date group by party_code) b 
where a.party_code=b.party_code and a.td_Date=b.td_Date and a.td_date=a.sauda_date 
and a.td_Date < @sett_date )B 
where nbfc_data.td_Date=@sett_date and nbfc_data.party_Code=b.party_code 
*/

--- Now 19-11-2004 20:06 Sandeep had changed the value of Prev.Shortage
--- Now Prev.Shortage = Shortage

update nbfc_data set prev_shortage = shortage

--- Update all holding value with 0 where holding is null
update nbfc_data set holding = 0 where holding is null 


--- Calculate 90% sell_value for funding return on trading day
/*
update nbfc_data set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.90
when sqtydel > 0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date
*/
/*
update nbfc_data set sell_value =
--(case when sqtydel > 0 and holding-sqtydel >= sqtydel then samtdel*.90
(case when sqtydel > 0 and holding+sqtydel >= sqtydel then samtdel*.90
when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date
*/

-- T+1 Basis

update nbfc_data set sell_value =
(case when sqtydel > 0 and holding+sqtydel >= sqtydel then samtdel
--when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))*.90
when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))
else 0 end) 
where td_Date=sauda_date

--- Calculate 10% sell_value for funding return on settlement day
/*
update nbfc_data set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.10
when sqtydel > 0 and holding+sqtydel >0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.10
else 0 end) where td_Date=funds_payin
*/

--- set sell_value to 0 whose 90% funding return was not calculated on trading day

/*
update nbfc_data set sell_value = 0 from
(
select a.* from (select td_Date,sauda_Date,scrip_cd,party_Code,sqtydel,samtdel,sell_value from nbfc_Data where funds_payin=td_Date) a, 
(select td_Date,party_Code,scrip_Cd,sqtydel,sell_value from nbfc_findata where sauda_Date=td_Date)b 
where b.td_Date=a.sauda_date and a.party_code=b.party_code and a.scrip_Cd=b.scrip_cd
and a.sell_Value > 0 and b.sell_value = 0
) b where b.party_code=nbfc_data.party_Code and b.scrip_cd=nbfc_data.scrip_cd and nbfc_data.td_Date=nbfc_data.funds_payin
*/

--- Calculate Amount to be given to NBFC

update nbfc_data set tobegiven=(case when b.tobegiven >= 0 then b.tobegiven else 0 end)
from
(
select party_code, td_Date, 
tobegiven=(case 
--when sum(sell_value) > 0 and prev_shortage < 0 then sum(sell_value)
--when sum(sell_value) > 0 and prev_shortage > 0 then prev_shortage-sum(sell_value)
when sum(sell_value) > 0 and prev_shortage <= 0 then sum(sell_value)
when sum(sell_value) > 0 and prev_shortage > 0  then sum(sell_value)-prev_shortage
else 0 end), sell_value=sum(sell_value),prev_shortage from nbfc_data
group by party_code, td_Date, prev_shortage
) b where nbfc_data.party_code=b.party_code 
--and nbfc_data.td_Date=nbfc_data.sauda_Date

--- Update nbfc_findata (final data file)

delete from nbfc_findata where td_Date = @sett_Date
insert into nbfc_findata select upd_Date,td_date,SAUDA_dATE,FUNDS_PAYIN,SETT_NO,SETT_TYPE,BRANCH_CD,SUB_BROKER,FAMILY,PARTY_CODE,PARTY_NAME,SCRIP_cD,SCRIP_NAME,PQTYDEL,PAMTDEL,NBFC_FUNDING,SQTYDEL,SAMTDEL,holding,balancetd,bill_amt,shortage,tobegiven,prev_shortage,sell_value,x_shortage from nbfc_data

--- End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dp_hold
-- --------------------------------------------------
CREATE procedure dp_hold
as

set nocount on

DECLARE @nDATE AS VARCHAR(11)

SELECT @ndate=MAX(HOLD_dATE) FROM NBFC_HOLDING
--SELECT @ndate=MAX(HOLD_dATE),@mdate=replace(convert(varchar(11),MAX(HOLD_dATE),102),'.','') frOM NBFC_HOLDING

DECLARE @MDATE AS VARCHAR(11)
SELECT @MDATE=MAX(HLD_HOLD_dATE) FROM DPBACKOFFICE.ACERCROSS.DBO.HOLDING


select party_code=isnull(clcd,party_code),isin=isnull(isin,hld_isin_code),scripname=isnull(scripname,sc_company_name),
scrip_code=isnull(scrip_code,sc_bsecd),nbfc_qty=isnull(qty,0),dp_qty=isnull(hld_ac_pos,0) into #temp from
(
SELECT * FROM NBFC_HOLDING WHERE HOLD_DATE=@ndate
) x full outer join
(
select * from
(
SELECT b.party_code,hld_isin_code,hld_ac_pos=sum(hld_ac_pos) FROM
(SELECT * FROM DPBACKOFFICE.ACERCROSS.DBO.HOLDING WHERE HLD_HOLD_dATE=@MDATE) A, 
CLIENTMASTER B WHERE B.CLIENT_ID=a.hld_ac_code collate Latin1_General_CI_AS
group by party_Code,hld_isin_code
) x1 left outer join
(
SELECT sc_isincode,sc_company_name,sc_bsecd  FROM DPBACKOFFICE.ACERCROSS.DBO.security where sc_bsecd <> ''
) x2 on x1.hld_isin_code=x2.sc_isincode
) y on x.clcd=y.party_code and x.isin=y.hld_isin_code collate Latin1_General_CI_AS

select a.*,b.party_name,b.client_id from #temp a, clientmaster b where a.party_code=b.party_code

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GET_BAL_B
-- --------------------------------------------------

CREATE PROCEDURE GET_BAL_B (@FDATE AS VARCHAR(25), @CLCODE AS VARCHAR(10))
AS

--declare @fdate as varchar(25)
--set @fdate = 'Jan  1 2005 00:00:00'

declare @acdate as varchar(25)
select @acdate='Apr  1 '+
(case when substring(@fdate,1,3) in ('Jan','Feb','Mar') 
then convert(varchar(4),substring(@fdate,8,4)-1) else convert(varchar(4),substring(@fdate,8,4)) end)+' 00:00:00'
-- print @acdate

SELECT BALANCE=isnull(SUM(CASE WHEN UPPER(DRCR)='D' THEN VAMT ELSE -VAMT END),0) FROM anand1.inhouse.dbo.LEDGER WHERE CLTCODE=@CLCODE
AND VDT < @FDATE AND VDT >= @ACDATE and (vtyp <> '18' and vdt = @acdate)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Global_rep
-- --------------------------------------------------
CREATE procedure Global_rep(@sdate as varchar(11))
as

set nocount on

declare @fname1 as varchar(25), @fname2 as varchar(25), @str1 as varchar(3000)
--declare @sdate as varchar(11)
--set @sdate = '08/11/2005'
set @fname1 = 'finrep'+substring(@sdate,4,2)+substring(@sdate,1,2)+substring(@sdate,7,4)
set @fname2 = 'holding'+substring(@sdate,4,2)+substring(@sdate,1,2)+substring(@sdate,7,4)

--print @fname1
--print @fname2


--------------------- Value from Broker's Book
set @str1= ''
set @str1=@str1 + ' select a.*,nbfc_balance=isnull(b.balance,0) into #broker_value from ( select * from intranet.risk.dbo.'+@fname1
set @str1=@str1 + ' where party_Code in (select party_Code from clientmaster where fromdate <= '''+@sdate+''' and todate >= '''+@sdate+''' )'
set @str1=@str1 + ' ) a  left outer join ( select clcd,balance=(case when drcr=''Cr'' then -balance else balance end) from tally_group '
set @str1=@str1 + ' where upd_Date = '''+@sdate+'''  ) b  on a.party_code=b.clcd '

--print @str1
--exec(@str1)

---------------------- Calculate Broker's HDFC Funds Value

set @str1=@str1 + '  '
set @str1=@str1 + ' select party_Code,b_hdfc_hold=sum(total) into #broker_hdfc '
set @str1=@str1 + ' from intranet.risk.dbo.'+@fname2+' a, intranet.risk.dbo.hdfc_scp b '
set @str1=@str1 + ' where a.scrip_cd=b.scode group by party_Code having sum(total) > 0 '

--print @str1
--exec(@str2)


set @str1=@str1 + '  '
set @str1=@str1 + ' select a.*,b_hdfc_hold=isnull(b.b_hdfc_hold,0) into #broker_book '
set @str1=@str1 + ' from #broker_value a left outer join #broker_hdfc b on a.party_Code=b.party_Code '


--------------------- Value from NBFC's Book

set @str1=@str1 + '  '
set @str1=@str1 + ' select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue),hdfc_value=sum(hdfc_hold) '
set @str1=@str1 + ' into #nbfc_val from ( select n1.*,n2.scode,hdfc_hold=(case when n2.scode is not null then actvalue else 0 end) '
set @str1=@str1 + ' from (Select * from nbfc_holding where hold_date=@sdate and clcd is not null ) n1 '
set @str1=@str1 + ' left outer join '
set @str1=@str1 + ' intranet.risk.dbo.hdfc_scp n2 on n1.scrip_code=n2.scode ) ca   group by clcd '


------------------ Final Query
set @str1=@str1 + '  '
set @str1=@str1 + ' select aa.*,subgroup=isnull(bb.subgroup,''XX'') from '
set @str1=@str1 + ' ( select a1.*,actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0),hdfc_val=a1.b_hdfc_hold+isnull(c.hdfc_value,0) '
set @str1=@str1 + ' from #broker_book a1 left outer join #nbfc_val c '
set @str1=@str1 + ' on c.clcd=a1.party_code ) aa left outer join ( '
set @str1=@str1 + ' select party_code,subgroup from intranet.risk.dbo.finmast ) bb on aa.party_code=bb.party_code order by sbtag '

--print @str1
exec (@str1)
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Global_rep_br
-- --------------------------------------------------
CREATE procedure Global_rep_br(@sdate as varchar(11),@brcode as varchar(11))
as

set nocount on

--declare @sdate as varchar(11)
--set @sdate = '08/11/2005'

select party_code,subgroup into #pcode from intranet.risk.dbo.finmast where sbtag=@brcode

--------------------- Value from Broker's Book
select a.*,nbfc_balance=isnull(b.balance,0) into #broker_value from 
(
select * from intranet.risk.dbo.finrep where sbtag=@brcode and party_Code in 
(select party_Code from clientmaster where fromdate <= @sdate and todate >= @sdate )
) a  
left outer join ( select clcd,balance=(case when drcr='Cr' then -balance else balance end) from tally_group 
where upd_Date = @sdate  ) b  on a.party_code=b.clcd 

---------------------- Calculate Broker's HDFC Funds Value

--select party_Code,b_hdfc_hold=sum(total),bse_app 
--into #broker_hdfc 

--select party_Code,b_hdfc_hold=sum(case when (approved='*' or scode is not null) then total else 0 end)
select party_Code,b_hdfc_hold=sum(case when (scode is not null) then total else 0 end)
into #broker_hdfc from (select * from intranet.risk.dbo.holding where party_code in 
(select party_code from #pcode))a left outer join intranet.risk.dbo.hdfc_scp b 
on a.scrip_cd=b.scode 
group by party_Code having sum(total) > 0 


select a.*,b_hdfc_hold=isnull(b.b_hdfc_hold,0) into #broker_book 
from #broker_value a left outer join #broker_hdfc b on a.party_Code=b.party_Code 


--------------------- Value from NBFC's Book


select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue),hdfc_value=sum(hdfc_hold) 
into #nbfc_val 
from ( 
select n1.*,n2.scode,hdfc_hold=(case when n2.scode is not null then actvalue else 0 end) 
from (Select * from nbfc_holding where hold_date=@sdate and clcd in
(select party_code from #pcode)) n1 
--and clcd is not null ) n1 
left outer join 
(
select * from
(
select scode from intranet.risk.dbo.hdfc_scp 
--union
--select scode collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.isin where app='*'
) ss
)n2 on n1.scrip_code=n2.scode 
) ca   group by clcd 


------------------ Final Query

select aa.*,subgroup=isnull(bb.subgroup,'XX') from 
( select a1.*,actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0),hdfc_val=a1.b_hdfc_hold+isnull(c.hdfc_value,0) 
from #broker_book a1 left outer join #nbfc_val c 
on c.clcd=a1.party_code ) aa left outer join ( 
select party_code,subgroup from #pcode) bb on aa.party_code=bb.party_code order by sbtag 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Global_rep_sb
-- --------------------------------------------------
create procedure Global_rep_sb(@sdate as varchar(11),@sbcode as varchar(11))
as

set nocount on

--declare @sdate as varchar(11)
--set @sdate = '08/11/2005'

select party_code,subgroup into #pcode from intranet.risk.dbo.finmast where subgroup=@sbcode

--------------------- Value from Broker's Book
select a.*,nbfc_balance=isnull(b.balance,0) into #broker_value from 
(
select * from intranet.risk.dbo.finrep where party_Code in 
(select party_Code from clientmaster where fromdate <= @sdate and todate >= @sdate 
and party_code in (select party_code from #pcode))
) a  
left outer join ( select clcd,balance=(case when drcr='Cr' then -balance else balance end) from tally_group 
where upd_Date = @sdate  ) b  on a.party_code=b.clcd 

---------------------- Calculate Broker's HDFC Funds Value

--select party_Code,b_hdfc_hold=sum(total),bse_app 
--into #broker_hdfc 

--select party_Code,b_hdfc_hold=sum(case when (approved='*' or scode is not null) then total else 0 end)
select party_Code,b_hdfc_hold=sum(case when (scode is not null) then total else 0 end)
into #broker_hdfc from (select * from intranet.risk.dbo.holding where party_code in 
(select party_code from #pcode))a left outer join intranet.risk.dbo.hdfc_scp b 
on a.scrip_cd=b.scode 
group by party_Code having sum(total) > 0 


select a.*,b_hdfc_hold=isnull(b.b_hdfc_hold,0) into #broker_book 
from #broker_value a left outer join #broker_hdfc b on a.party_Code=b.party_Code 


--------------------- Value from NBFC's Book


select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue),hdfc_value=sum(hdfc_hold) 
into #nbfc_val 
from ( 
select n1.*,n2.scode,hdfc_hold=(case when n2.scode is not null then actvalue else 0 end) 
from (Select * from nbfc_holding where hold_date=@sdate and clcd in
(select party_code from #pcode)) n1 
--and clcd is not null ) n1 
left outer join 
(
select * from
(
select scode from intranet.risk.dbo.hdfc_scp 
--union
--select scode collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.isin where app='*'
) ss
)n2 on n1.scrip_code=n2.scode 
) ca   group by clcd 


------------------ Final Query

select aa.*,subgroup=isnull(bb.subgroup,'XX') from 
( select a1.*,actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0),hdfc_val=a1.b_hdfc_hold+isnull(c.hdfc_value,0) 
from #broker_book a1 left outer join #nbfc_val c 
on c.clcd=a1.party_code ) aa left outer join ( 
select party_code,subgroup from #pcode) bb on aa.party_code=bb.party_code order by sbtag 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Global_rep2
-- --------------------------------------------------
CREATE procedure Global_rep2(@sdate as varchar(11))    
as    
    
set nocount on    
/*    
declare @sdate as varchar(11)    
set @sdate = '09/30/2005'    
  */  
--------------------- Value from Broker's Book    
select a.*,nbfc_balance=isnull(b.balance,0) into #broker_value from ( select * from intranet.risk.dbo.finrep    
where party_Code in (select party_Code from clientmaster where fromdate <= @sdate and todate >= @sdate )    
) a  left outer join ( select clcd,balance=(case when drcr='Cr' then -balance else balance end) from tally_group     
where upd_Date = @sdate  ) b  on a.party_code=b.clcd     
    
---------------------- Calculate Broker's HDFC Funds Value    
    
--select party_Code,b_hdfc_hold=sum(total),bse_app     
--into #broker_hdfc     
    
--select party_Code,b_hdfc_hold=sum(case when (approved='*' or scode is not null) then total else 0 end)    
/*
select party_Code,b_hdfc_hold=sum(case when (scode is not null) then total else 0 end)    
into #broker_hdfc     
from intranet.risk.dbo.holding a left outer join intranet.risk.dbo.hdfc_scp b     
on a.scrip_cd=b.scode     
group by party_Code having sum(total) > 0     
*/    

select party_Code,b_hdfc_hold=sum(total)
into #broker_hdfc     
from
(
select party_code,scrip_Cd,qty=sum(qty),total=sum(clsrate*qty)
--select party_code,scrip_Cd,qty,total
--select *
from intranet.risk.dbo.holding where scrip_cd in (select scode from intranet.risk.dbo.hdfc_scp) 
and sett_type <> 'X' -- and scrip_Cd='500325' and party_code='T619' order by scrip_cd
group by party_code,scrip_Cd 
--having sum(qty) > 0     
) zz
group by party_Code --having sum(total) > 0     



select a.*,b_hdfc_hold=isnull(b.b_hdfc_hold,0) into #broker_book     
from #broker_value a left outer join #broker_hdfc b on a.party_Code=b.party_Code     
    
    
--------------------- Value from NBFC's Book    
    
    
select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue),hdfc_value=sum(hdfc_hold)     
into #nbfc_val     
from (     
select n1.*,n2.scode,hdfc_hold=(case when n2.scode is not null then actvalue else 0 end)     
from (Select * from nbfc_holding where hold_date=@sdate and clcd is not null ) n1     
left outer join     
(    
select * from    
(    
select scode from intranet.risk.dbo.hdfc_scp     
--union    
--select scode collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.isin where app='*'    
) ss    
)n2 on n1.scrip_code=n2.scode     
) ca   group by clcd     

   
------------------ Final Query    
    
select aa.*,subgroup=isnull(bb.subgroup,'XX') from     
( select a1.*,actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0),hdfc_val=a1.b_hdfc_hold+isnull(c.hdfc_value,0)     
from #broker_book a1 left outer join #nbfc_val c     
on c.clcd=a1.party_code ) aa left outer join (     
select party_code,subgroup from intranet.risk.dbo.finmast ) bb on aa.party_code=bb.party_code order by sbtag     
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Global_rep3
-- --------------------------------------------------
CREATE procedure Global_rep3(@sdate as varchar(11))      
as      
      
set nocount on      
/*      
declare @sdate as varchar(11)      
set @sdate = '09/30/2005'      
  */    
  
--declare @sdate as varchar(11)      
--set @sdate = '10/14/2005'      
  
declare @str as varchar(2000),@vsdate as varchar(11)  
select @vsdate = substring(@sdate,4,2)+substring(@sdate,1,2)+substring(@sdate,7,4)  
--print @vsdate   
  
--------------------- Value from Broker's Book      
  
set @str = ''  
set @str = @str + ' select a.*,nbfc_balance=isnull(b.balance,0) into #broker_value from ( select * from intranet.risk.dbo.finrep'+@VSDATE  
set @str = @str + ' where party_Code in (select party_Code from clientmaster where fromdate <= '''+@sdate+''' and todate >= '''+@sdate+''' )    '  
set @str = @str + ' ) a  left outer join ( select clcd,balance=(case when drcr=''Cr'' then -balance else balance end) from tally_group     '  
set @str = @str + ' where upd_Date = '''+@sdate+'''  ) b  on a.party_code=b.clcd     '  
      
--PRINT(LEN(@STR))  
--PRINT(@STR)  
  
--EXEC(@STR)  
  
---------------------- Calculate Broker's HDFC Funds Value      
  
--set @str = ''  
set @str = @str + ' select party_Code,b_hdfc_hold=sum(total) into #broker_hdfc from'  
set @str = @str + ' (select party_code,scrip_Cd,qty=sum(qty),total=sum(clsrate*qty)'  
--set @str = @str + ' from intranet.risk.dbo.holding'+@VSDATE+' where scrip_cd in (select scode from intranet.risk.dbo.hdfc_scp) '  
set @str = @str + ' from intranet.risk.dbo.holding'+@VSDATE+' where scrip_cd in (select scode from intranet.risk.dbo.citi_scp) '  
set @str = @str + ' and sett_type <> ''X'' group by party_code,scrip_Cd ) zz group by party_Code '  
--PRINT(@STR)  
  
set @str = @str + ' select a.*,b_hdfc_hold=isnull(b.b_hdfc_hold,0) into #broker_book     '  
set @str = @str + ' from #broker_value a left outer join #broker_hdfc b on a.party_Code=b.party_Code     '  
      
--EXEC(@STR)  
      
--------------------- Value from NBFC's Book      
      
set @str = @str + ' select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue),hdfc_value=sum(hdfc_hold)'  
set @str = @str + ' into #nbfc_val from ( select n1.*,n2.scode,hdfc_hold=(case when n2.scode is not null then actvalue else 0 end) '  
set @str = @str + ' from (Select * from nbfc_holding where hold_date='''+@sdate+''' and clcd is not null ) n1 '  
--set @str = @str + ' left outer join (select * from ( select scode from intranet.risk.dbo.hdfc_scp) ss '  
set @str = @str + ' left outer join (select * from ( select scode from intranet.risk.dbo.citi_scp) ss '  
set @str = @str + ' )n2 on n1.scrip_code=n2.scode) ca   group by clcd '  
--EXEC(@STR)  
     
------------------ Final Query      
      
set @str = @str + ' select aa.*,subgroup=isnull(bb.subgroup,''XX'') from '  
set @str = @str + ' (select a1.*,actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0),hdfc_val=a1.b_hdfc_hold+isnull(c.hdfc_value,0) '  
set @str = @str + ' from #broker_book a1 left outer join #nbfc_val c on c.clcd=a1.party_code ) aa left outer join ( '  
set @str = @str + ' select party_code,subgroup from intranet.risk.dbo.finmast ) bb on aa.party_code=bb.party_code order by sbtag '  
  
EXEC(@STR)     
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.n_calc1
-- --------------------------------------------------
CREATE procedure n_calc1 (@sett_Date as varchar(11),@acdate as varchar(11))
AS

--- Calculate Shortage amount for t-2 day
/*
update nbfc_ndata set x_shortage = b.x_shortage 
from (select td_date,party_Code,x_shortage=bill_amt-sum(pamtdel)-sum(case 
when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel  
when sqtydel > 0 and sqtydel+holding <  sqtydel then (sqtydel+holding)*(samtdel/sqtydel) 
else 0 end) from nbfc_ndata where td_Date=sauda_date 
group by td_date,balancetd,party_Code,party_name,bill_amt ) b 
where nbfc_ndata.td_Date=b.td_date and nbfc_ndata.party_Code=b.party_code 
*/

--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-2
--update nbfc_ndata set x_shortage = balancetd 


--- Above Shortage formula is changed. Now Shortage = Closing Balance on t-3
/*
update nbfc_ndata set x_shortage = c.balancetd
from
(
select distinct a.party_code,a.td_Date,balancetd from nbfc_findata a,
(
select party_code,td_date=max(td_date) from nbfc_findata 
where td_Date < (select max(sauda_date) from nbfc_ndata where td_Date <> sauda_Date)
group by party_Code) b 
where a.party_Code=b.party_Code and a.td_Date=b.td_Date
) c where nbfc_ndata.party_code=c.party_Code 
*/
--- fetch shortage amount from actual trading day


--update nbfc_ndata set shortage = b.x_shortage 
--from ( select distinct td_date,party_code,x_shortage 
--from nbfc_findata where td_date=sauda_date and funds_payin = 'Dec 10 2004' )B 
--where nbfc_ndata.party_Code=b.party_code 

/*
declare @sdate as varchar(11)
select @sdate = start_date from anand.bsedb_ab.dbo.sett_mst where funds_payin='Feb 21 2005' and sett_type='D'
--print @sdate

update nbfc_ndata set shortage = b.openingTD
from(
select cltcode,OpeningTD=sum(case when upper(drcr)='D' and vdt<=@sdate+' 00:00:00' then vamt 
when upper(drcr)='C' and vdt<=@sdate+' 00:00:00' then -vamt else 0 end) from anand.account_ab.dbo.ledger
where vdt >='Apr  1 2004 00:00:00' and cltcode >='A0001' and cltcode <= 'ZZZZZ' 
group by cltcode ) B
where nbfc_ndata.party_Code=b.cltcode
*/

update nbfc_ndata set gap_bill = b.gap_bill
from
(
select a.party_code,gap_bill=sum(case when upper(c.drcr)='D' then vamt else -vamt end)
from (select distinct party_code,td_date from nbfc_ndata) a, anand1.msajag.dbo.sett_mst b, anand1.account.dbo.ledger c 
where b.funds_payin = a.td_date and b.sett_type='D' and c.cltcode=a.party_Code and c.vdt >= b.start_date+1 and c.vdt <= b.funds_payin+1
and c.vtyp=15 group by a.party_code
) b where nbfc_ndata.party_Code=b.party_Code

update nbfc_ndata set shortage = balancetd - gap_bill


--- Store Previous Day Shortage Value
/*
update nbfc_ndata set prev_shortage = b.shortage 
from ( select distinct a.td_date,a.party_code,a.shortage 
from nbfc_findata a, (select party_code, td_date=max(td_date) from nbfc_findata 
where td_Date < @sett_date group by party_code) b 
where a.party_code=b.party_code and a.td_Date=b.td_Date and a.td_date=a.sauda_date 
and a.td_Date < @sett_date )B 
where nbfc_ndata.td_Date=@sett_date and nbfc_ndata.party_Code=b.party_code 
*/

--- Now 19-11-2004 20:06 Sandeep had changed the value of Prev.Shortage
--- Now Prev.Shortage = Shortage

update nbfc_ndata set prev_shortage = shortage

--- Update all holding value with 0 where holding is null
update nbfc_ndata set holding = 0 where holding is null 


--- Calculate 90% sell_value for funding return on trading day
/*
update nbfc_ndata set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.90
when sqtydel > 0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date
*/
/*
update nbfc_ndata set sell_value =
--(case when sqtydel > 0 and holding-sqtydel >= sqtydel then samtdel*.90
(case when sqtydel > 0 and holding+sqtydel >= sqtydel then samtdel*.90
when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))*.90
else 0 end) 
where td_Date=sauda_date
*/

-- T+1 Basis

update nbfc_ndata set sell_value =
(case when sqtydel > 0 and holding+sqtydel >= sqtydel then samtdel
--when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))*.90
when sqtydel > 0 and holding+sqtydel >0 and holding+sqtydel <  sqtydel then ((holding+sqtydel)*(samtdel/sqtydel))
else 0 end) 
where td_Date=sauda_date

--- Calculate 10% sell_value for funding return on settlement day
/*
update nbfc_ndata set sell_value =
(case when sqtydel > 0 and sqtydel+holding >= sqtydel then samtdel*.10
when sqtydel > 0 and holding+sqtydel >0 and sqtydel+holding <  sqtydel then ((sqtydel+holding)*(samtdel/sqtydel))*.10
else 0 end) where td_Date=funds_payin
*/

--- set sell_value to 0 whose 90% funding return was not calculated on trading day

/*
update nbfc_ndata set sell_value = 0 from
(
select a.* from (select td_Date,sauda_Date,scrip_cd,party_Code,sqtydel,samtdel,sell_value from nbfc_ndata where funds_payin=td_Date) a, 
(select td_Date,party_Code,scrip_Cd,sqtydel,sell_value from nbfc_findata where sauda_Date=td_Date)b 
where b.td_Date=a.sauda_date and a.party_code=b.party_code and a.scrip_Cd=b.scrip_cd
and a.sell_Value > 0 and b.sell_value = 0
) b where b.party_code=nbfc_ndata.party_Code and b.scrip_cd=nbfc_ndata.scrip_cd and nbfc_ndata.td_Date=nbfc_ndata.funds_payin
*/

--- Calculate Amount to be given to NBFC

update nbfc_ndata set tobegiven=(case when b.tobegiven >= 0 then b.tobegiven else 0 end)
from
(
select party_code, td_Date, 
tobegiven=(case 
--when sum(sell_value) > 0 and prev_shortage < 0 then sum(sell_value)
--when sum(sell_value) > 0 and prev_shortage > 0 then prev_shortage-sum(sell_value)
when sum(sell_value) > 0 and prev_shortage <= 0 then sum(sell_value)
when sum(sell_value) > 0 and prev_shortage > 0  then sum(sell_value)-prev_shortage
else 0 end), sell_value=sum(sell_value),prev_shortage from nbfc_ndata
group by party_code, td_Date, prev_shortage
) b where nbfc_ndata.party_code=b.party_code 
--and nbfc_ndata.td_Date=nbfc_ndata.sauda_Date

--- Update nbfc_findata (final data file)

delete from nbfc_nfindata where td_Date = @sett_Date
insert into nbfc_nfindata select * from nbfc_ndata

--- End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nbfc_risk
-- --------------------------------------------------
CREATE procedure nbfc_risk (@fdate as varchar(25))
as
/*
declare @fdate as varchar(25)
set @fdate = 'Mar  4 2005 00:00:00'
*/

declare @acdate as varchar(25)
select @acdate='Apr  1 '+
(case when substring(@fdate,1,3) in ('Jan','Feb','Mar') 
then convert(varchar(4),substring(@fdate,8,4)-1) else convert(varchar(4),substring(@fdate,8,4)) end)+' 00:00:00'
-- print @acdate

select a.*,nbfc_balance=isnull(b.balance,0),actval=isnull(c.actvalue,0),holdval=isnull(c.holdvalue,0) from 
(
select * from intranet.risk.dbo.finrep where party_Code in
(select party_Code from clientmaster  where fromdate <= @fdate and todate >= @fdate)
) a 
left outer join 
(select clcd,balance=(case when drcr='Cr' then -balance else balance end) from tally_group where upd_Date = (select max(upd_Date) from tally_group)) b 
left outer join
(select clcd,actvalue=sum(Actvalue),holdvalue=sum(holdvalue) from nbfc_holding where hold_date=(select max(hold_date) from nbfc_holding)
and clcd is not null group by clcd) c
on c.clcd=b.clcd on a.party_code=b.clcd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.quotes
-- --------------------------------------------------
CREATE procedure quotes (@coname as varchar(10))
as
update temp_tally_group set clcd= replace(clcd,'"','') 
--update tally_group  set drcr = (case when balance <= 0 then 'Dr' else 'Cr' end)
update temp_tally_group  set balance = abs(balance)
update temp_tally_group  set company =@coname

update temp_tally_group set upd_Date =(select tddate=max(convert(datetime,td_date)) from nbfc_findata)

declare @sdate as varchar(11)
select @sdate = upd_date from temp_tally_group 
delete from tally_group where upd_date = @sdate
insert into tally_group select * from temp_tally_group

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
-- PROCEDURE dbo.Rpt_ACDLDelHoldParty_NBFC
-- --------------------------------------------------
CREATE Proc Rpt_ACDLDelHoldParty_NBFC (
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),  
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID  
Varchar(8),@BCltDpID Varchar(16),@mdate as varchar(11))  
AS  
if @BDpID = ''  
Select @BDpID = '%'  
if @BCltDpID = ''  
Select @BCltDpID = '%'  

select * from temp_holding
delete from temp_holding

insert into temp_holding (scrip_code,scripname,clcd,qty,isin,clid,hold_Date,nse_pqty)
   
Select scrip_code=scrip_cd+'-'+series, scrip_name = scrip_cd+'-'+series ,clcd=D.Party_Code,  
Qty=Sum(Case When DrCr = 'C' Then Qty Else -Qty End),
isin=CertNo,clid=BCltDpId, convert(datetime,@mdate), 
--,BDpId,HoldQty=Sum(Case When TrType <> 909 Then (Case When DrCr = 'C' Then Qty Else -Qty End) Else 0 End),  
PledgeQty=Sum(Case When TrType = 909 Then (Case When DrCr = 'C' Then Qty Else -Qty End) Else 0 End)
--Long_Name = Long_Name  
from angeldemat.msajag.dbo.DELTRANS_NBFC D , angeldemat.msajag.dbo.Client1 C1, angeldemat.msajag.dbo.Client2 C2  
where C1.Cl_Code = C2.Cl_Code  
And C2.Party_Code = D.Party_Code   
And BDpId Like @BDpId and BCltDpId Like @BCltDpId    
AND D.PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY    
and Filler2 = 1   
And D.Party_Code <> 'BROKER'   
And TrType <> 906 And CertNo not like 'Auction'    
group by D.Party_Code, scrip_cd,CertNo, series, BDpId,BCltDpId, Long_Name   
having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0    
Order by D.Party_Code, scrip_cd,CertNo, series, BDpId,BCltDpId, Long_Name   

update temp_holding set scrip_code = b.scrip_cd from 
(select * from angeldemat.bsedb.dbo.multiisin ) b where temp_holding.isin collate Latin1_General_CI_AS =b.isin


---update temp_holding set HOLD_dATE = CONVERT(VARCHAR(11),GETDATE(),109)

/*
update temp_holding set actvalue = b.rate*qty from (select a.* from intranet.risk.dbo.cpcumm a, 
(select scode,mfdate=max(mfdate) from intranet.risk.dbo.cpcumm 
group by scode) b where a.scode=b.scode and a.mfdate=b.mfdate 
) b where b.scode=temp_holding.scrip_code 
*/

-- Value only for last traded scrips
update temp_holding set actvalue = b.rate*qty from (select * from intranet.risk.dbo.cp) b where b.scode=temp_holding.scrip_code 

--select * from temp_holding where scripname like'sak%'

update temp_holding set actvalue = b.cls*qty from (
select a.* from (select scode=rtrim(ltrim(scrip))+'-'+series,mfdate,cls from intranet.risk.dbo.mdcumm) a, 
(select scode=rtrim(ltrim(scrip))+'-'+series,mfdate=max(mfdate) from intranet.risk.dbo.mdcumm group by rtrim(ltrim(scrip))+'-'+series) b 
where a.scode=b.scode and a.mfdate=b.mfdate 
) b where b.scode collate Latin1_General_CI_AS =temp_holding.scripname AND ACTVALUE=0


update temp_holding set HOLDvalue = 0 where holdvalue is null 

-- insert scrip group

--update temp_holding set scpgrp='A' from 
--(select * from scp_mast where scp_grp ='A') b where b.scrip_code=temp_holding.scrip_code

--update temp_holding set scpgrp='Z' from 
--(select * from scp_mast where scp_grp ='Z') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set scpgrp='A' from 
(select * from scp_mast where category ='Approved 1') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set scpgrp='Z' from 
(select * from scp_mast where category ='Non Approved') b where b.scrip_code=temp_holding.scrip_code





update temp_holding set scpgrp='B' where scpgrp not in ('A','Z')

update temp_holding set haircut = b.agrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='A'

update temp_holding set haircut = b.zgrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='Z'

update temp_holding set haircut = b.bgrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='B'


update temp_holding set holdvalue=actvalue-actvalue*(haircut/100.00)

---------------------------------------------------------------------------

declare @holddate as varchar(25)
select distinct @holddate=convert(varchar(11),hold_Date,109) from temp_holding

delete from holding_position where hold_Date = convert(datetime,@holddate)
insert into holding_position 
select hold_Date=convert(datetime,@holddate),clcd=isnull(a.clcd,b.clcd),
holdvalue=isnull(a.holdvalue,0)-isnull(b.holdvalue,0) from
(select clcd,holdvalue=sum(holdvalue) from temp_holding group by clcd)a full outer join 
(
select clcd,holdvalue=sum(holdvalue)  from nbfc_holding where hold_date = (
select max(hold_Date) from nbfc_holding 
where hold_date < (select distinct hold_date from temp_holding))
group by clcd
) b
on a.clcd=b.clcd


update temp_holding set bse_qty =0 , nse_qty=qty

update temp_holding set 
bse_value=(case when bse_qty > 0 then (holdvalue/qty)*bse_qty else 0 end),
nse_value=(case when nse_qty > 0 then (holdvalue/qty)*nse_qty else 0 end)

---------------------------------------------------------------------------
delete from nbfc_holding where hold_date = (select distinct hold_date from temp_holding) and nse_qty > 0
--CONVERT(VARCHAR(11),GETDATE(),109)
insert into nbfc_holding select * from temp_holding

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_NseDelHoldParty_NBFC
-- --------------------------------------------------
CREATE Proc Rpt_NseDelHoldParty_NBFC (  
@StatusId Varchar(15),@StatusName Varchar(25),@FromParty varchar(10),  
@ToParty varchar(10),@FromScrip Varchar(12),@ToScrip Varchar(12),@BDpID  
Varchar(8),@BCltDpID Varchar(16),@mdate as varchar(11))  
AS  

/*
declare @StatusId Varchar(15)
declare @StatusName Varchar(25)
declare @FromParty varchar(10)
declare @ToParty varchar(10)
declare @FromScrip Varchar(12)
declare @ToScrip Varchar(12)
declare @BDpID  Varchar(8)
declare @BCltDpID Varchar(16)
declare @mdate as varchar(11)

--Exec Rpt_NseDelHoldParty_NBFC '','','A0001','ZZZZ','','','','','04/15/2005' 

set @StatusId = ''
set @StatusName =''
set @FromParty ='A0001'
set @ToParty ='ZZZZ'
set @FromScrip =''
set @ToScrip =''
set @BDpID  =''
set @BCltDpID =''
set @mdate ='04/15/2005'
*/

if @BDpID = ''  
Select @BDpID = '%'  
if @BCltDpID = ''  
Select @BCltDpID = '%'  


delete from temp_holding

insert into temp_holding (scrip_code,scripname,clcd,qty,isin,clid,hold_Date,bse_Pqty)

Select scrip_code=D.scrip_cd, scrip_name = S2.Scrip_Cd ,clcd=D.Party_Code,  
Qty=Sum(Case When DrCr = 'C' Then Qty Else -Qty End),
isin=CertNo,clid=BCltDpId, convert(datetime,@mdate) ,
--,BDpId,HoldQty=Sum(Case When TrType <> 909 Then (Case When DrCr = 'C' Then Qty Else -Qty End) Else 0 End),  
PledgeQty=Sum(Case When TrType = 909 Then (Case When DrCr = 'C' Then Qty Else -Qty End) Else 0 End)
--Long_Name = Long_Name  
From angeldemat.bsedb.dbo.DELTRANS_NBFC D , angeldemat.bsedb.dbo.Client1 C1, angeldemat.bsedb.dbo.Client2 C2, angeldemat.bsedb.dbo.Scrip2 S2
where C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = D.Party_Code
And D.Scrip_Cd = S2.BseCode
And BDpId Like @BDpId and BCltDpId Like @BCltDpId
AND D.PARTY_CODE BetWeen @FROMPARTY AND @TOPARTY
and Filler2 = 1
And D.Party_Code <> 'BROKER'
And TrType <> 906 And CertNo not like 'Auction'
Group by D.Party_Code, S2.scrip_cd, CertNo , D.Scrip_Cd, BDpId, BCltDpId, Long_Name 
having Sum(Case When DrCr = 'C' Then Qty Else -Qty End) > 0
Order By D.Party_Code, S2.scrip_cd, CertNo , D.Scrip_Cd, BDpId, BCltDpId, Long_Name 


---update temp_holding set HOLD_dATE = CONVERT(VARCHAR(11),GETDATE(),109)
/*
update temp_holding set actvalue = b.rate*qty from (select a.* from intranet.risk.dbo.cpcumm a, 
(select scode,mfdate=max(mfdate) from intranet.risk.dbo.cpcumm 
group by scode) b where a.scode=b.scode and a.mfdate=b.mfdate 
) b where b.scode=temp_holding.scrip_code 
*/

--- value Only for last traded scrip

update temp_holding set actvalue = b.rate*qty from (
select * from intranet.risk.dbo.cp 
) b where b.scode=temp_holding.scrip_code 


update temp_holding set HOLDvalue = 0 where holdvalue is null 

-- insert scrip group

update temp_holding set scpgrp='A' from 
--(select * from scp_mast where scp_grp ='A') b where b.scrip_code=temp_holding.scrip_code
(select * from scp_mast where category ='Approved 1') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set scpgrp='Z' from 
--(select * from scp_mast where scp_grp ='Z') b where b.scrip_code=temp_holding.scrip_code
(select * from scp_mast where category ='Non Approved') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set scpgrp='B' where scpgrp not in ('A','Z')

update temp_holding set haircut = b.agrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='A'

update temp_holding set haircut = b.zgrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='Z'

update temp_holding set haircut = b.bgrp from
clientmaster b where temp_holding.clcd=b.party_code and scpgrp='B'



/*update temp_holding set haircut = 15,scpgrp='A' from 
(select * from scp_mast where scp_grp ='A') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set haircut = 100,scpgrp='Z' from 
(select * from scp_mast where scp_grp ='Z') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set haircut = 25, scpgrp='B' where scpgrp not in ('A','Z')
*/
update temp_holding set holdvalue=actvalue-actvalue*(haircut/100.00)

---------------------------------------------------------------------------

declare @holddate as varchar(25)
select distinct @holddate=convert(varchar(11),hold_Date,109) from temp_holding

delete from holding_position where hold_Date = convert(datetime,@holddate)
insert into holding_position 
select hold_Date=convert(datetime,@holddate),clcd=isnull(a.clcd,b.clcd),
holdvalue=isnull(a.holdvalue,0)-isnull(b.holdvalue,0) from
(select clcd,holdvalue=sum(holdvalue) from temp_holding group by clcd)a full outer join 
(
select clcd,holdvalue=sum(holdvalue)  from nbfc_holding where hold_date = (
select max(hold_Date) from nbfc_holding 
where hold_date < (select distinct hold_date from temp_holding))
group by clcd
) b
on a.clcd=b.clcd


update temp_holding set bse_qty = qty, nse_qty=0

update temp_holding set 
bse_value=(case when bse_qty > 0 then (holdvalue/qty)*bse_qty else 0 end),
nse_value=(case when nse_qty > 0 then (holdvalue/qty)*nse_qty else 0 end)


---------------------------------------------------------------------------
delete from nbfc_holding where hold_date = (select distinct hold_date from temp_holding) and bse_qty > 0
--CONVERT(VARCHAR(11),GETDATE(),109)
insert into nbfc_holding select * from temp_holding

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Shortage_file
-- --------------------------------------------------
CREATE procedure Shortage_file      
(@accessCode as varchar(10), @accessTo as varchar(10))             
             
as                            
                        
set transaction isolation level read uncommitted                            
set nocount on                            
                            
--declare @brcode as varchar(11)                            
--set @brcode = 'HO'                            
                  
                  
                  
if @accessTo='BRMAST'                          
BEGIN          
select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained    
 from shortage where branch in     
(select branch_cd from intranet.risk.dbo.branch_master where brmast_cd = @accessCode) and PartyCode is not null      
order by CallExcess asc     
                     
END                    
                   
if @accessTo='SBMAST'                          
BEGIN                    
select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained     
from shortage where SBTag in (select subbroker from sb_master where sbmast_cd = @accesscode) and PartyCode is not null       
order by CallExcess asc        
END                    
                  
if @accessTo='SB'                          
BEGIN         
      
select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained     
from shortage where  SbTag = @accesscode  and  PartyCode is not null     
order by CallExcess asc             
             
END                    
                 
if @accessTo='BROKER'                          
BEGIN                    
    select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained     
from shortage where PartyCode is not null    
order by CallExcess asc       
END       
      
if @accessTo='REGION'                          
BEGIN        
select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained     
from shortage where branch in (select code from intranet.risk.dbo.region where reg_code  = @accesscode)  and  PartyCode is not null   
order by CallExcess asc                 
                   
END                    
                       
if @accessTo='BRANCH'                          
BEGIN                    
        
select PartyCode,Branch,Region,SBTag,NCM_Val,NCM_Val_HC,BF_Val,DayBuy_1,DaySell_1,DayBuy_2,DaySell_2,LedgerBalance,CallExcess,MarginShortage as MarginMaintained    
from shortage where  Branch = @accessCode and PartyCode is not null      
order by CallExcess asc        
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.shortfall
-- --------------------------------------------------
CREATE procedure shortfall (@cdate as varchar(25))
as

select x.*,loan=isnull((Case when upper(drcr)='DR' then balance else -balance end),0) from 
(
select td_date,balancetd,party_Code,hvalue=isnull(b.hvalue,0),party_name,Purchase_value=sum(Purchase_value),nbfc_funding=sum(nbfc_funding),
shortage,tobegiven=sum(tobegiven),funding=isnull(funding,0),loan_limit from 
(
select td_date,balancetd,p.party_Code,p.party_name,q.loan_limit,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(p.nbfc_funding),0),
shortage, tobegiven,funding=q.nbfc_funding from nbfc_findata p, (SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) q
where td_Date = @cdate AND p.party_code=q.party_code
group by td_date,balancetd,p.party_Code,p.party_name,bill_amt,shortage,tobegiven,q.nbfc_funding,loan_limit 
) a left outer join 
(
select clcd,hvalue=sum(holdvalue) from nbfc_holding where hold_Date=@cdate group by clcd
) b on a.party_code=b.clcd
group by td_date,balancetd,party_Code,party_name,shortage,hvalue,funding,loan_limit
) x left outer join (select * from tally_group where upd_Date = @cdate)y on x.party_code=y.clcd
order by party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.shortfall_a
-- --------------------------------------------------
CREATE procedure shortfall_a (@cdate as varchar(25))
as

/*
declare @cdate as datetime
set @cdate = 'Feb 21 2005'
*/

select x.*,loan=isnull((Case when upper(drcr)='DR' then balance else -balance end),0) from 
(
select td_date,bse_balancetd,nse_balancetd,party_Code,bvalue=isnull(b.bvalue,0),nvalue=isnull(b.nvalue,0),actvalue=isnull(b.actvalue,0),party_name,
bse_Purchase_value=sum(bse_Purchase_value),nse_Purchase_value=sum(nse_Purchase_value),
bse_nbfc_funding=sum(bse_nbfc_funding),nse_nbfc_funding=sum(nse_nbfc_funding),
bse_shortage,nse_shortage,bse_tobegiven=sum(bse_tobegiven),nse_tobegiven=sum(nse_tobegiven),
funding=isnull(funding,0),loan_limit from 
(

select p.*,q.loan_limit,funding=q.nbfc_funding from 
(
SELECT 
td_date=isnull(bse.td_date,nse.td_date),
party_Code=isnull(bse.party_code,nse.party_code),
party_name=isnull(bse.party_name,nse.party_name),

bse_balancetd=isnull(bse.balancetd,0),
bse_Purchase_value=isnull(bse.purchase_value,0),
bse_nbfc_funding=isnull(bse.nbfc_funding,0),
bse_shortage=isnull(bse.shortage,0),
bse_tobegiven=isnull(bse.tobegiven,0),

nse_balancetd=isnull(nse.balancetd,0),
nse_Purchase_value=isnull(nse.purchase_value,0),
nse_nbfc_funding=isnull(nse.nbfc_funding,0),
nse_shortage=isnull(nse.shortage,0),
nse_tobegiven=isnull(nse.tobegiven,0)
 FROM

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_findata where td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) BSE

FULL OUTER JOIN

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_nfindata where td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) NSE on bse.party_Code=nse.party_code
)  p,
(SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) q
where td_Date = @cdate AND p.party_code=q.party_code
--group by td_date,balancetd,p.party_Code,p.party_name,bill_amt,shortage,tobegiven,q.nbfc_funding,loan_limit 
) a left outer join 
(
select clcd,bvalue=sum(bse_value),nvalue=sum(nse_value),actvalue=sum(actvalue) from nbfc_holding where hold_Date=@cdate group by clcd
) b on a.party_code=b.clcd
group by td_date,bse_balancetd,nse_balancetd,party_Code,party_name,bse_shortage,nse_shortage,bvalue,nvalue,actvalue,funding,loan_limit
) x left outer join (select * from tally_group where upd_Date = @cdate)y on x.party_code=y.clcd
order by party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.shortfall_b
-- --------------------------------------------------
create procedure shortfall_b (@cdate as varchar(25),@pcode as varchar(10))
as

/*
declare @cdate as datetime
set @cdate = 'Feb 21 2005'
*/

select x.*,loan=isnull((Case when upper(drcr)='DR' then balance else -balance end),0) from 
(
select td_date,bse_balancetd,nse_balancetd,party_Code,bvalue=isnull(b.bvalue,0),nvalue=isnull(b.nvalue,0),actvalue=isnull(b.actvalue,0),party_name,
bse_Purchase_value=sum(bse_Purchase_value),nse_Purchase_value=sum(nse_Purchase_value),
bse_nbfc_funding=sum(bse_nbfc_funding),nse_nbfc_funding=sum(nse_nbfc_funding),
bse_shortage,nse_shortage,bse_tobegiven=sum(bse_tobegiven),nse_tobegiven=sum(nse_tobegiven),
funding=isnull(funding,0),loan_limit from 
(

select p.*,q.loan_limit,funding=q.nbfc_funding from 
(
SELECT 
td_date=isnull(bse.td_date,nse.td_date),
party_Code=isnull(bse.party_code,nse.party_code),
party_name=isnull(bse.party_name,nse.party_name),

bse_balancetd=isnull(bse.balancetd,0),
bse_Purchase_value=isnull(bse.purchase_value,0),
bse_nbfc_funding=isnull(bse.nbfc_funding,0),
bse_shortage=isnull(bse.shortage,0),
bse_tobegiven=isnull(bse.tobegiven,0),

nse_balancetd=isnull(nse.balancetd,0),
nse_Purchase_value=isnull(nse.purchase_value,0),
nse_nbfc_funding=isnull(nse.nbfc_funding,0),
nse_shortage=isnull(nse.shortage,0),
nse_tobegiven=isnull(nse.tobegiven,0)
 FROM

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_findata where party_Code=@pcode and td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) BSE

FULL OUTER JOIN

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_nfindata where party_Code=@pcode and td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) NSE on bse.party_Code=nse.party_code
)  p,
(SELECT * FROM CLIENTMASTER WHERE party_Code=@pcode and FROMDATE <=@cdate AND TODATE >=@cdate) q
where td_Date = @cdate AND p.party_code=q.party_code
--group by td_date,balancetd,p.party_Code,p.party_name,bill_amt,shortage,tobegiven,q.nbfc_funding,loan_limit 
) a left outer join 
(
select clcd,bvalue=sum(bse_value),nvalue=sum(nse_value),actvalue=sum(actvalue) from nbfc_holding where clcd=@pcode and hold_Date=@cdate group by clcd
) b on a.party_code=b.clcd
group by td_date,bse_balancetd,nse_balancetd,party_Code,party_name,bse_shortage,nse_shortage,bvalue,nvalue,actvalue,funding,loan_limit
) x left outer join (select * from tally_group where upd_Date = @cdate)y on x.party_code=y.clcd
order by party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.shortfall1
-- --------------------------------------------------
CREATE procedure shortfall1 (@cdate as varchar(25))
as

--declare @cdate as varchar(11)
--set @cdate = '12/08/2004'

select shtfall.*,ageing.liquid from
(
select x.*,loan=isnull((Case when upper(drcr)='DR' then balance else -balance end),0) from 
(
select td_date,balancetd,party_Code,hvalue=isnull(b.hvalue,0),party_name,Purchase_value=sum(Purchase_value),nbfc_funding=sum(nbfc_funding),
shortage,tobegiven=sum(tobegiven),funding=isnull(funding,0),loan_limit from 
(
select td_date,balancetd,p.party_Code,p.party_name,q.loan_limit,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=sum(p.nbfc_funding),
shortage, tobegiven,funding=q.nbfc_funding from nbfc_findata p, (SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) q
where td_Date = @cdate AND p.party_code=q.party_code
group by td_date,balancetd,p.party_Code,p.party_name,bill_amt,shortage,tobegiven,q.nbfc_funding,loan_limit 
) a left outer join 
(
select clcd,hvalue=sum(holdvalue) from nbfc_holding where hold_Date=@cdate group by clcd
) b on a.party_code=b.clcd
group by td_date,balancetd,party_Code,party_name,shortage,hvalue,funding,loan_limit
) x left outer join (select * from tally_group where upd_Date = @cdate)y on x.party_code=y.clcd
) shtfall,
(
select x.party_code,liquid=
(case when isnull(y.holdvalue,0) <= balance-isnull(y.holdvalue,0) then isnull(y.holdvalue,0) 
else balance-isnull(y.holdvalue,0) end)
from
(
select a.party_Code,balance=isnull(balance,0) from
(SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) a 
left outer join
(select * from tally_group where upper(drcr)='DR' and upd_date = @cdate) b
 on a.party_Code=b.clcd
) x left outer join
(
select clcd,holdvalue=sum(holdvalue) from holding_position where hold_date <= @cdate and hold_date >=
(select min(start_date) from(
select top 5 start_date from anand.bsedb_ab.dbo.sett_mst where start_date <=@cdate and sett_type='D'
order by start_date desc)  x) group by clcd
) y on x.party_Code=y.clcd
) ageing where shtfall.party_Code=ageing.party_code
order by shtfall.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.shortfall1_a
-- --------------------------------------------------
CREATE procedure shortfall1_a (@cdate as varchar(25))
as

--declare @cdate as varchar(11)
--set @cdate = '12/08/2004'

select shtfall.*,ageing.liquid from
(

select x.*,loan=isnull((Case when upper(drcr)='DR' then balance else -balance end),0) from 
(
select td_date,bse_balancetd,nse_balancetd,party_Code,bvalue=isnull(b.bvalue,0),nvalue=isnull(b.nvalue,0),party_name,
bse_Purchase_value=sum(bse_Purchase_value),nse_Purchase_value=sum(nse_Purchase_value),
bse_nbfc_funding=sum(bse_nbfc_funding),nse_nbfc_funding=sum(nse_nbfc_funding),
bse_shortage,nse_shortage,bse_tobegiven=sum(bse_tobegiven),nse_tobegiven=sum(nse_tobegiven),
funding=isnull(funding,0),loan_limit from 
(

select p.*,q.loan_limit,funding=q.nbfc_funding from 
(
SELECT 
td_date=isnull(bse.td_date,nse.td_date),
party_Code=isnull(bse.party_code,nse.party_code),
party_name=isnull(bse.party_name,nse.party_name),

bse_balancetd=isnull(bse.balancetd,0),
bse_Purchase_value=isnull(bse.purchase_value,0),
bse_nbfc_funding=isnull(bse.nbfc_funding,0),
bse_shortage=isnull(bse.shortage,0),
bse_tobegiven=isnull(bse.tobegiven,0),

nse_balancetd=isnull(nse.balancetd,0),
nse_Purchase_value=isnull(nse.purchase_value,0),
nse_nbfc_funding=isnull(nse.nbfc_funding,0),
nse_shortage=isnull(nse.shortage,0),
nse_tobegiven=isnull(nse.tobegiven,0)
 FROM

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_findata where td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) BSE

FULL OUTER JOIN

(select td_date,balancetd,party_Code,party_name,
Purchase_value=sum(case when td_Date = sauda_Date then pamtdel else 0 end),nbfc_funding=isnull(sum(nbfc_funding),0),
shortage, tobegiven
from nbfc_nfindata where td_Date = @cdate group by td_date,balancetd,party_Code,party_name,shortage,tobegiven
) NSE on bse.party_Code=nse.party_code
)  p,
(SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) q
where td_Date = @cdate AND p.party_code=q.party_code
--group by td_date,balancetd,p.party_Code,p.party_name,bill_amt,shortage,tobegiven,q.nbfc_funding,loan_limit 

) a left outer join 
(
select clcd,bvalue=sum(bse_value),nvalue=sum(nse_value) from nbfc_holding where hold_Date=@cdate group by clcd
) b on a.party_code=b.clcd
group by td_date,bse_balancetd,nse_balancetd,party_Code,party_name,bse_shortage,nse_shortage,bvalue,nvalue,funding,loan_limit
) x left outer join (select * from tally_group where upd_Date = @cdate)y on x.party_code=y.clcd


) shtfall,
(
select x.party_code,liquid=
(case when isnull(y.holdvalue,0) <= balance-isnull(y.holdvalue,0) then isnull(y.holdvalue,0) 
else balance-isnull(y.holdvalue,0) end)
from
(
select a.party_Code,balance=isnull(balance,0) from
(SELECT * FROM CLIENTMASTER WHERE FROMDATE <=@cdate AND TODATE >=@cdate) a 
left outer join
(select * from tally_group where upper(drcr)='DR' and upd_date = @cdate) b
 on a.party_Code=b.clcd
) x left outer join
(
select clcd,holdvalue=sum(holdvalue) from holding_position where hold_date <= @cdate and hold_date >=
(select min(start_date) from(
select top 5 start_date from anand.bsedb_ab.dbo.sett_mst where start_date <=@cdate and sett_type='D'
order by start_date desc)  x) group by clcd
) y on x.party_Code=y.clcd
) ageing where shtfall.party_Code=ageing.party_code
order by shtfall.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_mis1
-- --------------------------------------------------
CREATE procedure sp_mis1(@mdate as varchar(25))  
as  
  
set nocount on  
  
--declare @mdate as varchar(25)
--set @mdate ='Nov 18 2005'

select clcd,  
Other_holding=sum(case when scode is null then actvalue else 0 end),  
HDFC_holding=sum(case when scode is not null then actvalue else 0 end),  
HDFC_Funding=sum(case when scode is not null then actvalue*.60 else 0 end)
into #temp1  
--from nbfc_holding a left outer join intranet.risk.dbo.hdfc_scp b on a.scrip_Code=b.scode   
from nbfc_holding a left outer join intranet.risk.dbo.citi_scp b on a.scrip_Code=b.scode   
where hold_date=@mdate  
group by clcd  
  
 
select clcd,Balance=(case when drcr='Dr' then balance else -balance end) into #temp2 from tally_group where upd_date=@mdate  

 
select clcd=COALESCE(t1.clcd,t2.clcd),Other_holding=isnull(Other_holding,0),HDFC_holding=isnull(HDFC_holding,0),  
HDFC_funding=isnull(HDFC_funding,0),Balance=isnull(balance,0) into #temp3 from #temp1 t1 full outer join #temp2 t2 on t1.clcd=t2.clcd  
  
select a.party_code,a.party_name,a.loan_limit,  
Other_holding=isnull(Other_holding,0),HDFC_holding=isnull(HDFC_holding,0),  
HDFC_funding=isnull(HDFC_funding,0),Balance=isnull(balance,0), Short_Funding=isnull(balance,0)-isnull(HDFC_funding,0)  
 from clientmaster a left outer join #temp3 b  on a.party_code=b.clcd  
where Todate >=@mdate  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_SCRIPGROUP
-- --------------------------------------------------
CREATE PROCEDURE SP_SCRIPGROUP AS
 
SELECT a.scripcode,a.scripname,a.groupname,category=isnull(b.category,
(CASE  
         when  a.groupname='A' then 'Approved 1'
         when  (a.groupname='B2' or a.groupname='Z')  then 'Non Approved'
         ELSE 'Approved 2'
 END))
into #scp_mast2 
from scripgroupmaster a left outer join scp_mast b on a.scripcode=b.scrip_code collate SQL_Latin1_General_CP1_CI_AS 
where a.scripcode>500000 and scripcode <= 800000
--and b.scrip_code>500000

delete from scp_mast

insert into scp_mast select * from #scp_mast2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_upd_scpmast
-- --------------------------------------------------
CREATE procedure sp_upd_scpmast  
as  
update scp_mast set category='Approved 2' where category='Approved 1'   
--update scp_mast set category='Approved 1' where scrip_code in (select scode from intranet.risk.dbo.hdfc_scp)  
update scp_mast set category='Approved 1' where scrip_code in (select scode from intranet.risk.dbo.citi_scp)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_daybook
-- --------------------------------------------------
CREATE procedure upd_daybook
as

update daytemp set val_1 = replace(val_1,'"','')
update daytemp set val_3 = replace(val_3,'"','')
update daytemp set val_2 = replace(val_2,'"','')
update daytemp set val_4 = replace(val_4,'"','')
update daytemp set val_5 = replace(val_5,'"','')

declare @@get_tno as cursor
declare @@mval_1 as varchar(200)
declare @@mval_2 as varchar(200)
declare @@mval_3 as varchar(200)
declare @@mval_4 as varchar(200)
declare @@mval_5 as varchar(200)
declare @@mval_6 as varchar(200)

declare @@mday as varchar(10)
declare @@mpcode as varchar(200)
declare @@mpname as varchar(200)

declare @@npcode as varchar(200)
declare @@npname as varchar(200)
declare @@mamt as varchar(25)
declare @@amtdr as money
declare @@amtcr as money
declare @@mtype as varchar(25)
declare @@mnarr as varchar(200)
declare @@msubmit as int
set @@msubmit = 99

truncate table daybook_fin1
truncate table daybook_fin

set @@get_tno = cursor for select val_1=isnull(val_1,'XXXXX'),val_2=isnull(val_2,'XXXXX'),val_3=isnull(val_3,'XXXXX'),val_4=isnull(val_4,'XXXXX'),val_5=isnull(val_5,'XXXXX'),val_6=isnull(val_6,'XXXXX') from daytemp order by srno
open @@get_tno
fetch next from @@get_tno into @@mval_1,@@mval_2,@@mval_3,@@mval_4,@@mval_5,@@mval_6
while @@fetch_status=0
BEGIN

--	print @@mval_1+','+	@@mval_2+','+@@mval_3+','+@@mval_4+','+@@mval_5+','+@@mval_6


	if @@mval_3 in ('Pymt','Rcpt','Jrnl','C/Note','D/Note','Sale','Purc','Ctra') 
	begin

      ------------SET date format

		if @@msubmit = 0 
		begin
			update daybook_fin1 set narration=space(1)
			update daybook_fin1 set cr_amt=ltrim(str(convert(money,cr_amt)*-1,50,2)) where convert(money,cr_amt) > 0
			insert into daybook_fin select * from daybook_fin1 
			truncate table daybook_fin1 
			set @@msubmit = 1
		end

		set @@msubmit = 0
		set @@mtype = @@mval_3
		set @@mday = replace(@@mval_1,'-','/')

			if substring(@@mday,2,1)='/' 
			begin
				set @@mday='0'+@@mday
		   end
			
			if substring(@@mday,5,1)='/' 
			begin
				set @@mday=substring(@@mday,1,3)+'0'+substring(@@mday,4,7)
		   end

			set @@mday = substring(@@mday,4,3)+substring(@@mday,1,3)+substring(@@mday,7,5)
			
		--print convert(datetime,@@mday)

       ------------------------------ get PArty Code and PArty Name

		if charindex('_',@@mval_2) > 0 
		begin 
			set @@mpcode = substring(@@mval_2,1,charindex('_',@@mval_2)-1)
			set @@mpname = substring(@@mval_2,charindex('_',@@mval_2)+1,200)
		end
		else
		begin
				set @@mpcode = @@mval_2
				set @@mpname = @@mval_2
		end

	--print @@mpcode
	--print @@mpname

--		print @@mday +','+ @@mpcode +','+@@mpname+','+@@mtype+','+@@mval_4+','+@@mval_5

		insert into daybook_fin1 (Tdate,party_code,party_name,vtype,cr_amt,dr_amt,narration) 
		values(@@mday,@@mpcode,@@mpname,@@mtype,@@mval_4,@@mval_5,' ') 
		



	end

  --------------------------- GET COUNTER PARTY DETAILS
	

	if (charindex('Dr',@@mval_2)+charindex('Dr',@@mval_3)+charindex('Dr',@@mval_4)+charindex('Dr',@@mval_5)+
		charindex('Cr',@@mval_2)+charindex('Cr',@@mval_3)+charindex('Cr',@@mval_4)+charindex('Cr',@@mval_5)) > 0


	begin
		
			set @@mamt='0.00 Cr'

			if @@mval_5 ='XXXXX'
				begin
					if @@mval_4 ='XXXXX'
						begin
							if @@mval_3 ='XXXXX'
								begin
									set @@mamt=@@mval_2
								end
							else
								begin
									set @@mamt=@@mval_2+@@mval_3
								end
						end
					else
						begin
							set @@mamt=@@mval_2+@@mval_3+@@mval_4
						end
				end
			else
				begin
					set @@mamt=@@mval_2+@@mval_3+@@mval_4+@@mval_5
				end

		if charindex('_',@@mval_1) > 0 
		begin 
			set @@npcode = substring(@@mval_1,1,charindex('_',@@mval_1)-1)
			set @@npname = substring(@@mval_1,charindex('_',@@mval_1)+1,200)
		end
		else
		begin
				set @@npcode = @@mval_1
				set @@npname = @@mval_1
		end


		set @@amtdr = 0
		set @@amtcr = 0

		if charindex(' Dr',@@mamt) > 0 
			begin
				set @@amtcr = convert(money,replace(@@mamt,'Dr',''))
			end

		if charindex(' Cr',@@mamt) > 0 
			begin
				set @@amtdr = convert(money,replace(@@mamt,'Cr',''))
			end
		
		--print @@mday+','+@@npcode+','+@@npname+','+@@mtype+','+str(@@amtcr,10,2)+','+str(@@amtdr,10,2)

		insert into daybook_fin1 (Tdate,party_code,party_name,vtype,cr_amt,dr_amt,narration) 
		values(@@mday,@@npcode,@@npname,@@mtype,LTRIM(str(@@amtcr,50,2)),LTRIM(str(@@amtdr,50,2)),' ') 

	end		

   ------------------------- Get Narration
	if (@@mval_2 = '' or @@mval_1 like 'Ch. No.%')
	begin
		update daybook_fin1 set narration=@@mval_1 
		update daybook_fin1 set cr_amt=ltrim(str(convert(money,cr_amt)*-1,50,2)) where convert(money,cr_amt) > 0
		insert into daybook_fin select * from daybook_fin1 
		truncate table daybook_fin1 
		set @@msubmit = 1
 	 end


fetch next from @@get_tno into @@mval_1,@@mval_2,@@mval_3,@@mval_4,@@mval_5,@@mval_6 
END

if @@msubmit = 0 
begin
	update daybook_fin1 set narration=space(1)
	update daybook_fin1 set cr_amt=ltrim(str(convert(money,cr_amt)*-1,50,2)) where convert(money,cr_amt) > 0
	insert into daybook_fin select * from daybook_fin1 
	truncate table daybook_fin1 
	set @@msubmit = 1
end

Close @@get_tno
deallocate @@get_tno


update daybook_fin set branch_Cd=b.sbtag from
intranet.risk.dbo.finmast b where daybook_fin .party_code collate Latin1_General_CI_AS =b.party_code


---------------- check for min Data
declare @mdate as datetime

select @mdate=(case when lock_Date+'23:59:59' > mindate then mindate else lock_Date+'23:59:59' end )
from locked_account_date a, 
(select mindate=convert(datetime,convert(varchar(11),min(tdate)-1)+' 23:59:59') from daybook_fin)  b 

--print @mdate

delete from daybook where tdate > @mdate

insert into daybook select * from daybook_fin where (abs(convert(money,cr_amt))+abs(convert(money,dr_amt))) > 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_nbfc_holding
-- --------------------------------------------------
CREATE procedure upd_nbfc_holding (@mholdate as datetime)
as

/*
update temp_holding set clcd = party_code from 
(select * from angeldemat.bsedb.dbo.multicltid) b 
where b.cltdpno=temp_holding.clid 
*/

--declare @mholdate as datetime
--set @mholdate ='03/03/2005'

update temp_holding set clcd = party_code from 
(select * from clientmaster) b 
where b.client_id=temp_holding.clid 

update temp_holding set scrip_code = scrip_cd from 
(select * from angeldemat.bsedb.dbo.multiisin) b 
where b.isin collate Latin1_General_CI_AS =temp_holding.isin 

---update temp_holding set HOLD_dATE = CONVERT(VARCHAR(11),GETDATE(),109)

update temp_holding set HOLD_dATE = @mholdate

update temp_holding set actvalue = b.rate*qty from (select a.* from intranet.risk.dbo.cpcumm a, 
(select scode,mfdate=max(mfdate) from intranet.risk.dbo.cpcumm 
group by scode) b where a.scode=b.scode and a.mfdate=b.mfdate 
) b where b.scode=temp_holding.scrip_code 


update temp_holding set HOLDvalue = 0 where holdvalue is null 

-- insert scrip group

update temp_holding set haircut = 15,scpgrp='A' from 
(select * from scp_mast where scp_grp ='A') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set haircut = 100,scpgrp='Z' from 
(select * from scp_mast where scp_grp ='Z') b where b.scrip_code=temp_holding.scrip_code

update temp_holding set haircut = 25, scpgrp='B' where scpgrp not in ('A','Z')

update temp_holding set holdvalue=actvalue-actvalue*(haircut/100.00)

---------------------------------------------------------------------------

declare @holddate as varchar(25)
select distinct @holddate=convert(varchar(11),hold_Date,109) from temp_holding

delete from holding_position where hold_Date = convert(datetime,@holddate)

insert into holding_position 
select hold_Date=convert(datetime,@holddate),clcd=isnull(a.clcd,b.clcd),
holdvalue=isnull(a.holdvalue,0)-isnull(b.holdvalue,0) from
(select clcd,holdvalue=sum(holdvalue) from temp_holding group by clcd)a full outer join 
(
select clcd,holdvalue=sum(holdvalue)  from nbfc_holding where hold_date = (
select max(hold_Date) from nbfc_holding 
where hold_date < (select distinct hold_date from temp_holding))
group by clcd
) b
on a.clcd=b.clcd


update temp_holding set bse_qty = b.bseqty, nse_qty=b.nseqty
from (
select b.clcd,pqtydel,b.scrip_code,qty,bseqty=case when pqtydel > qty then qty else pqtydel end, nseqty=qty-pqtydel from
(select * from nbfc_findata where td_Date=funds_payin and scrip_cd <> '') a,
temp_holding b where a.party_code=b.clcd and a.scrip_cd=b.scrip_code
) b where temp_holding.clcd=b.clcd and temp_holding.scrip_code=b.scrip_code



update temp_holding set 
bse_value=(case when bse_qty > 0 then (holdvalue/qty)*bse_qty else 0 end),
nse_value=(case when nse_qty > 0 then (holdvalue/qty)*nse_qty else 0 end)


---------------------------------------------------------------------------
delete from nbfc_holding where hold_date = (select distinct hold_date from temp_holding)
--CONVERT(VARCHAR(11),GETDATE(),109)
insert into nbfc_holding select * from temp_holding

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
-- PROCEDURE dbo.USP_UPLOAD_NBFC
-- --------------------------------------------------
CREATE proc USP_UPLOAD_NBFC  
(                      
@filename as varchar(100),@file_flag as varchar(50)                      
)                       
as                          
set transaction  isolation  level read uncommitted                          
              
declare @path as varchar(100)
declare @sql as varchar(2000)
--declare @filename as varchar(100)
--set @filename = 'nbfc_hold.xls'
            
set @path='d:\upload1\' + @filename
  
if @file_flag = 'A'
Begin

 SET @SQL = 'truncate table tbl_NBFC_Main_Data;insert into tbl_NBFC_Main_Data
 select
 PartyCode,
 Branch,
 Region,  
 [SB Tag],  
 convert(dec(10,2),Cash) ,  
 convert(dec(10,2),[Non Cash ]),  
 convert(dec(10,2),[Non Cash Value after Hair Cut ]),  
 convert(dec(10,2),[NBFC Holding ]),  
 convert(dec(10,2),[NBFC Holding after Hair cut]),  
 convert(dec(10,2),[Day Buy]),  
 convert(dec(10,2),[Buy Aftr HC]),  
 convert(dec(10,2),[Day Sell]),  
 convert(dec(10,2),[Sell Aftr HC]),  
 convert(dec(10,2),[Day Buy1]),  
 convert(dec(10,2),[Buy Aftr HC1]),  
 convert(dec(10,2),[Day Sell1]),  
 convert(dec(10,2),[Sell Aftr HC1]),  
 convert(dec(10,2),[NBFC Ledger Balance]),  
 convert(dec(10,2),[Call Excess / Shortage]),  
 convert(dec(10,2),[Portfolio Valuation  (Non Cash Margin + NBFC Holding)]),  
 convert(dec(10,2),[Net Portfolio Value (Portfolio+ NBFC Ledger)]),  
 convert(dec(10,2),[Margin Maintained %])   
 FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [sheet1$]'' )'   

end  

else  
begin  
 SET @SQL = 'truncate table tbl_NBFC_Call_Data;insert into tbl_NBFC_Call_Data   
 select PartyCode ,  
 [Scrip Code] ,  
 convert(int,[Tot Qty]),  
 convert(int,[NCM Qty]),  
 convert(int,[BF Qty]),  
 convert(dec(10,2),[T-2]),  
 convert(dec(10,2),[T-1]),  
 convert(dec(10,2),[Cl Pr]),  
 convert(dec(10,2),[Csh Mrg]),  
 convert(int,HC),  
 convert(dec(10,2),[NCM Val]),  
 convert(dec(10,2),[NCM Val_HC]),  
 convert(dec(10,2),[Bf Val]),  
 convert(dec(10,2),[BF Val_HC])    
 FROM OPENROWSET(''Microsoft.Jet.OLEDB.4.0'',''Excel 8.0;DATABASE='+@path+''',''Select * from [sheet1$]'' )'   
end  
--print @sql  
exec(@SQL)  
if @file_flag = 'A'
Begin
select count(*) as counts from tbl_NBFC_Main_Data
end 
else
begin
select count(*) as counts from tbl_NBFC_Call_Data
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.z_group
-- --------------------------------------------------

CREATE procedure z_group(@tdate as varchar(25),@Type as varchar(25),@brcode as varchar(10),@sbcode as varchar(10))  
as  
  
set nocount on  
  
/*  
declare @tdate as varchar(25)  
set @tdate = 'Aug 30 2005'  
declare @type as varchar(25)  
set @type = 'S'  
declare @brcode as varchar(25)  
set @brcode = 'XS'  
declare @sbcode as varchar(25)  
set @sbcode = '%'  
*/  
  
declare @acdate as varchar(25)  
select @acdate='Apr  1 '+  
(case when substring(@tdate,1,3) in ('Jan','Feb','Mar')   
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'  
--print @acdate  
  
  
---------------------- Capture Z Group Trades  
  
select branch_cd,sub_Broker,party_Code,Party_name,P_value=sum(pamttrd+samtdel),S_value=sum(samttrd+samtdel)  
into #trade  
 from anand.bsedb_Ab.dbo.cmbillvalan where sauda_date = @tdate and scrip_cd in  
(SELECT scripcode collate Latin1_General_CI_AS FROM SCRIPGROUPMASTER where groupname in ('T','S','Z','TS'))  
group by branch_cd,sub_Broker,party_Code,Party_name  
having sum(pamttrd+samtdel) > 0  
  
  
-------------------- ABL Ledger  
  
select cltcode,abl_balance=sum(case when drcr='D' then vamt else -vamt end)  
into #abl  
from anand.account_ab.dbo.ledger where vdt >=@acdate and vdt <=@tdate+' 23:59:59'  
and cltcode in (select party_Code from #trade) group by cltcode  
  
  
------------------ ACDL Ledger  
  
select cltcode,acdl_balance=sum(case when drcr='D' then vamt else -vamt end)  
into #acdl  
from anand1.inhouse.dbo.ledger where vdt >=@acdate and vdt <=@tdate+' 23:59:59'  
and cltcode in (select party_Code from #trade) group by cltcode  
  
  
------------------ Combine details of clients with Debit Balance  
  
select x.*,y.abl_ledger,y.acdl_ledger into #details from #trade x left outer join  
(select cltcode=isnull(a.cltcode,b.cltcode),abl_ledger=isnull(Abl_balance,0),  
acdl_ledger=isnull(acdl_balance,0) from #abl a full outer join #acdl b on a.cltcode =b.cltcode  
) y on x.party_Code=y.cltcode where abl_ledger+acdl_ledger > 0  
  
---------------- Branchwise  
  
if @type='B'   
 begin  
  select x.*,tradername from   
  (select branch_cd,p_value=sum(p_value),s_value=sum(s_value),abl_ledger=sum(abl_ledger),acdl_ledger=sum(acdl_ledger)  
  from #details group by branch_cd) x left outer join intranet.risk.dbo.branch y on x.branch_cd=y.sbTag   
 end  
  
---------------- Sub-broker  
  
if @type='S'   
 begin  
  select x.*,tradername=sbname from   
  (select branch_cd=@brcode,sub_broker,p_value=sum(p_value),s_value=sum(s_value),abl_ledger=sum(abl_ledger),acdl_ledger=sum(acdl_ledger)  
  from #details where branch_cd = @brcode group by sub_Broker ) x left outer join intranet.risk.dbo.subgroup y   
  on x.sub_Broker=y.sub_broker  
 end  
  
---------------- Clientwise  
  
if @type='C'   
 begin  
  select * from #details where branch_cd=@brcode and sub_broker=@sbcode order by abl_ledger+acdl_ledger desc  
 end  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.z_group1
-- --------------------------------------------------

CREATE procedure z_group1(@tdate as varchar(25))    
as    
    
set nocount on    
    
    
/*declare @tdate as varchar(25)    
set @tdate = 'Aug 30 2005'    
  
declare @type as varchar(25)    
set @type = 'S'    
declare @brcode as varchar(25)    
set @brcode = 'XS'    
declare @sbcode as varchar(25)    
set @sbcode = '%'    
*/    
    
declare @acdate as varchar(25)    
select @acdate='Apr  1 '+    
(case when substring(@tdate,1,3) in ('Jan','Feb','Mar')     
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'    
--print @acdate    
    
    
---------------------- Capture Z Group Trades    
    
select branch_cd,sub_Broker,party_Code,Party_name,P_value=sum(pamttrd+pamtdel),S_value=sum(samttrd+samtdel)    
into #trade    
 from anand.bsedb_Ab.dbo.cmbillvalan where sauda_date = @tdate and scrip_cd in    
(SELECT scripcode collate Latin1_General_CI_AS FROM SCRIPGROUPMASTER where groupname in ('T','S','Z','TS'))    
group by branch_cd,sub_Broker,party_Code,Party_name    
having sum(pamttrd+samtdel) > 0    
  
  
 -------------------- ABL Ledger    
    
select cltcode,abl_balance=sum(case when drcr='D' then vamt else -vamt end)    
into #abl    
from anand.account_ab.dbo.ledger where vdt >=@acdate and vdt <=@tdate+' 23:59:59'    
and cltcode in (select party_Code from #trade) group by cltcode    
    
    
------------------ ACDL Ledger    
    
select cltcode,acdl_balance=sum(case when drcr='D' then vamt else -vamt end)    
into #acdl    
from anand1.inhouse.dbo.ledger where vdt >=@acdate and vdt <=@tdate+' 23:59:59'    
and cltcode in (select party_Code from #trade) group by cltcode    
    
    
------------------ Combine details of clients with Debit Balance    
    
select sauda_date=@tdate,x.*,y.abl_ledger,y.acdl_ledger into #details from #trade x left outer join    
(select cltcode=isnull(a.cltcode,b.cltcode),abl_ledger=isnull(Abl_balance,0),    
acdl_ledger=isnull(acdl_balance,0) from #abl a full outer join #acdl b on a.cltcode =b.cltcode    
) y on x.party_Code=y.cltcode where abl_ledger+acdl_ledger > 0    
    
delete from t_tgroup where sauda_date = @tdate  
insert into t_tgroup select * from #details  
  
set nocount off

GO

-- --------------------------------------------------
-- TABLE dbo.aaa
-- --------------------------------------------------
CREATE TABLE [dbo].[aaa]
(
    [PCODE] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cat_update
-- --------------------------------------------------
CREATE TABLE [dbo].[cat_update]
(
    [scrip_code] VARCHAR(50) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [previouscategory] VARCHAR(50) NULL,
    [presentcategory] VARCHAR(50) NULL,
    [updatedate] DATETIME NULL,
    [scp_grp] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.daybook
-- --------------------------------------------------
CREATE TABLE [dbo].[daybook]
(
    [Tdate] DATETIME NULL,
    [party_code] VARCHAR(60) NULL,
    [party_name] VARCHAR(90) NULL,
    [vtype] VARCHAR(70) NULL,
    [cr_amt] VARCHAR(50) NULL,
    [dr_amt] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [narration] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.daybook_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[daybook_fin]
(
    [Tdate] DATETIME NULL,
    [party_code] VARCHAR(60) NULL,
    [party_name] VARCHAR(90) NULL,
    [vtype] VARCHAR(70) NULL,
    [cr_amt] VARCHAR(50) NULL,
    [dr_amt] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [narration] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.daybook_fin1
-- --------------------------------------------------
CREATE TABLE [dbo].[daybook_fin1]
(
    [Tdate] DATETIME NULL,
    [party_code] VARCHAR(60) NULL,
    [party_name] VARCHAR(90) NULL,
    [vtype] VARCHAR(70) NULL,
    [cr_amt] VARCHAR(50) NULL,
    [dr_amt] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [narration] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.daybook_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[daybook_temp]
(
    [col1] VARCHAR(200) NULL,
    [col2] VARCHAR(200) NULL,
    [col3] VARCHAR(200) NULL,
    [col4] VARCHAR(200) NULL,
    [col5] VARCHAR(200) NULL,
    [col6] VARCHAR(200) NULL,
    [col7] VARCHAR(200) NULL,
    [col8] VARCHAR(200) NULL,
    [Tdate] DATETIME NULL,
    [party_code] VARCHAR(60) NULL,
    [party_name] VARCHAR(90) NULL,
    [vtype] VARCHAR(70) NULL,
    [cr_amt] VARCHAR(50) NULL,
    [dr_amt] VARCHAR(50) NULL,
    [dummy1] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [narration] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.daytemp
-- --------------------------------------------------
CREATE TABLE [dbo].[daytemp]
(
    [srno] INT NULL,
    [val_1] VARCHAR(200) NULL,
    [val_2] VARCHAR(200) NULL,
    [val_3] VARCHAR(200) NULL,
    [val_4] VARCHAR(200) NULL,
    [val_5] VARCHAR(200) NULL,
    [val_6] VARCHAR(200) NULL,
    [val_7] VARCHAR(200) NULL,
    [val_8] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.gp
-- --------------------------------------------------
CREATE TABLE [dbo].[gp]
(
    [scripcode] VARCHAR(50) NULL,
    [exchangecode] VARCHAR(50) NULL,
    [scripid] VARCHAR(50) NULL,
    [scripname] VARCHAR(150) NULL,
    [sectorcode] VARCHAR(150) NULL,
    [instrumenttype] VARCHAR(50) NULL,
    [groupname] VARCHAR(50) NULL,
    [scriptype] VARCHAR(50) NULL,
    [facevalue] VARCHAR(50) NULL,
    [marketlot] VARCHAR(50) NULL,
    [ticksize] VARCHAR(50) NULL,
    [filler] VARCHAR(50) NULL,
    [status] VARCHAR(50) NULL,
    [ex_div_date] VARCHAR(150) NULL,
    [no_del_enddate] VARCHAR(50) NULL,
    [no_del_startdate] VARCHAR(50) NULL,
    [splmargin] VARCHAR(50) NULL,
    [isin_code] VARCHAR(150) NULL,
    [filler2] VARCHAR(50) NULL,
    [bc_startdate] VARCHAR(50) NULL,
    [ex_bonusdate] VARCHAR(50) NULL,
    [ex_rightdate] VARCHAR(50) NULL,
    [ex_split] VARCHAR(50) NULL,
    [filler3] VARCHAR(50) NULL,
    [bc_enddate] VARCHAR(50) NULL,
    [ndflag] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.HDFC_EXPOSURE
-- --------------------------------------------------
CREATE TABLE [dbo].[HDFC_EXPOSURE]
(
    [CODE] VARCHAR(20) NULL,
    [ISIN] VARCHAR(50) NULL,
    [SNAME] VARCHAR(50) NULL,
    [PHY_QTY] FLOAT NULL,
    [PHY_DP_PERCENT] FLOAT NULL,
    [DEM_QTY] FLOAT NULL,
    [DEM_DP_PERCENT] FLOAT NULL,
    [RATE] FLOAT NULL,
    [DRAWINGPOW] FLOAT NULL,
    [CONTRI_PERCENT] CHAR(10) NULL,
    [UPLOADDATE] DATETIME NULL,
    [uploaddate1] VARCHAR(50) NULL,
    [DUMMY2] CHAR(10) NULL,
    [DUMMY3] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.hold_ttt
-- --------------------------------------------------
CREATE TABLE [dbo].[hold_ttt]
(
    [clid] VARCHAR(16) NULL,
    [clcd] VARCHAR(25) NULL,
    [hold_Date] DATETIME NULL,
    [isin] VARCHAR(25) NULL,
    [scripname] VARCHAR(50) NULL,
    [scrip_code] VARCHAR(25) NULL,
    [qty] INT NULL,
    [actvalue] MONEY NULL,
    [dummy1] VARCHAR(25) NULL,
    [dummy2] VARCHAR(25) NULL,
    [scpgrp] VARCHAR(10) NULL,
    [haircut] INT NULL,
    [holdvalue] MONEY NULL,
    [bse_qty] INT NULL,
    [nse_qty] INT NULL,
    [bse_value] MONEY NULL,
    [nse_value] MONEY NULL,
    [bse_pqty] INT NULL,
    [nse_pqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.holding_position
-- --------------------------------------------------
CREATE TABLE [dbo].[holding_position]
(
    [hold_Date] DATETIME NULL,
    [clcd] VARCHAR(25) NULL,
    [holdvalue] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.lasthldupd
-- --------------------------------------------------
CREATE TABLE [dbo].[lasthldupd]
(
    [bse_date] DATETIME NULL,
    [nse_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.locked_account_date
-- --------------------------------------------------
CREATE TABLE [dbo].[locked_account_date]
(
    [Lock_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_Collateral
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_Collateral]
(
    [party_code] VARCHAR(12) NULL,
    [Scrip_code] VARCHAR(25) NULL,
    [tot_qty] INT NULL,
    [NCM_qty] INT NULL,
    [BF_qty] INT NULL,
    [Col_20th] MONEY NULL,
    [Col_21st] MONEY NULL,
    [cl_pr] MONEY NULL,
    [Csh_mrg] MONEY NULL,
    [HC] INT NULL,
    [NCM_Val] MONEY NULL,
    [NCM_Val_HC] MONEY NULL,
    [Bf_Val] MONEY NULL,
    [BF_Val_HC] MONEY NULL,
    [tdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_Del_POSITION
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_Del_POSITION]
(
    [Tdate] DATETIME NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_CD] VARCHAR(25) NULL,
    [HC] INT NULL,
    [BuyQty] INT NULL,
    [SellQty] INT NULL,
    [NetQty] INT NULL,
    [BuyRate] MONEY NULL,
    [SellRate] MONEY NULL,
    [BuyVal] MONEY NULL,
    [BuyVal_Hc] MONEY NULL,
    [SellVal] MONEY NULL,
    [SellVal_Hc] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_Del_POSITION_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_Del_POSITION_temp]
(
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_CD] VARCHAR(25) NULL,
    [HC] INT NULL,
    [BuyQty] INT NULL,
    [SellQty] INT NULL,
    [NetQty] INT NULL,
    [BuyRate] MONEY NULL,
    [SellRate] MONEY NULL,
    [BuyVal] MONEY NULL,
    [BuyVal_Hc] MONEY NULL,
    [SellVal] MONEY NULL,
    [SellVal_Hc] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nbfc_findata
-- --------------------------------------------------
CREATE TABLE [dbo].[nbfc_findata]
(
    [upd_Date] DATETIME NULL,
    [td_date] VARCHAR(10) NULL,
    [SAUDA_dATE] DATETIME NULL,
    [FUNDS_PAYIN] DATETIME NULL,
    [SETT_NO] CHAR(7) NULL,
    [SETT_TYPE] CHAR(3) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [FAMILY] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SCRIP_cD] VARCHAR(12) NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [NBFC_FUNDING] NUMERIC(38, 6) NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [holding] FLOAT NULL,
    [balancetd] MONEY NULL,
    [bill_amt] MONEY NULL,
    [shortage] MONEY NULL,
    [tobegiven] MONEY NULL,
    [prev_shortage] MONEY NULL,
    [sell_value] MONEY NULL,
    [x_shortage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nbfc_findate1
-- --------------------------------------------------
CREATE TABLE [dbo].[nbfc_findate1]
(
    [upd_Date] DATETIME NULL,
    [td_date] VARCHAR(10) NULL,
    [SAUDA_dATE] DATETIME NULL,
    [FUNDS_PAYIN] DATETIME NULL,
    [SETT_NO] CHAR(7) NULL,
    [SETT_TYPE] CHAR(3) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [FAMILY] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SCRIP_cD] VARCHAR(12) NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [NBFC_FUNDING] NUMERIC(38, 6) NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [holding] FLOAT NULL,
    [balancetd] MONEY NULL,
    [bill_amt] MONEY NULL,
    [shortage] MONEY NULL,
    [tobegiven] MONEY NULL,
    [prev_shortage] MONEY NULL,
    [sell_value] MONEY NULL,
    [x_shortage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_NEW
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_NEW]
(
    [COMPANY] VARCHAR(6) NOT NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SAUDA_DATE] DATETIME NULL,
    [Sett_No] VARCHAR(7) NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [SCRIP_CD] VARCHAR(12) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyDel] INT NULL,
    [Samtdel] MONEY NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [loan_limit] MONEY NULL,
    [SCP_GRP] VARCHAR(25) NOT NULL,
    [CATEGORY] VARCHAR(50) NOT NULL,
    [HAIRCUT] MONEY NULL,
    [abl_balance] MONEY NULL,
    [acdl_balance] MONEY NULL,
    [HOLDING] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nbfc_nfindata
-- --------------------------------------------------
CREATE TABLE [dbo].[nbfc_nfindata]
(
    [upd_Date] DATETIME NULL,
    [td_date] VARCHAR(10) NULL,
    [SAUDA_dATE] DATETIME NULL,
    [FUNDS_PAYIN] DATETIME NULL,
    [SETT_NO] CHAR(7) NULL,
    [SETT_TYPE] CHAR(3) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [FAMILY] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(50) NULL,
    [SCRIP_cD] VARCHAR(16) NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [NBFC_FUNDING] NUMERIC(38, 6) NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [holding] FLOAT NULL,
    [balancetd] MONEY NULL,
    [bill_amt] MONEY NULL,
    [shortage] MONEY NULL,
    [tobegiven] MONEY NULL,
    [prev_shortage] MONEY NULL,
    [sell_value] MONEY NULL,
    [x_shortage] MONEY NULL,
    [gap_bill] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.old_nbfc_holding
-- --------------------------------------------------
CREATE TABLE [dbo].[old_nbfc_holding]
(
    [clid] VARCHAR(16) NULL,
    [clcd] VARCHAR(25) NULL,
    [hold_Date] DATETIME NULL,
    [isin] VARCHAR(25) NULL,
    [scripname] VARCHAR(50) NULL,
    [scrip_code] VARCHAR(25) NULL,
    [qty] INT NULL,
    [actvalue] MONEY NULL,
    [dummy1] VARCHAR(25) NULL,
    [dummy2] VARCHAR(25) NULL,
    [scpgrp] VARCHAR(10) NULL,
    [haircut] INT NULL,
    [holdvalue] MONEY NULL,
    [bse_qty] INT NULL,
    [nse_qty] INT NULL,
    [bse_value] MONEY NULL,
    [nse_value] MONEY NULL,
    [bse_pqty] INT NULL,
    [nse_pqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.old_TALLY_GROUP
-- --------------------------------------------------
CREATE TABLE [dbo].[old_TALLY_GROUP]
(
    [clcd] VARCHAR(100) NULL,
    [upd_date] DATETIME NULL,
    [balance] MONEY NULL,
    [drcr] VARCHAR(10) NULL,
    [company] VARCHAR(10) NULL,
    [dummy1] VARCHAR(25) NULL,
    [dummy2] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scp_mast
-- --------------------------------------------------
CREATE TABLE [dbo].[scp_mast]
(
    [SCRIP_CODE] VARCHAR(25) NULL,
    [SCRIP_NAME] VARCHAR(500) NULL,
    [scp_grp] VARCHAR(25) NULL,
    [category] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scp_mast1
-- --------------------------------------------------
CREATE TABLE [dbo].[scp_mast1]
(
    [scripcode] VARCHAR(50) NULL,
    [scripname] VARCHAR(150) NULL,
    [groupname] VARCHAR(50) NULL,
    [category] VARCHAR(60) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scp_mast2
-- --------------------------------------------------
CREATE TABLE [dbo].[scp_mast2]
(
    [scripcode] VARCHAR(50) NULL,
    [scripname] VARCHAR(150) NULL,
    [groupname] VARCHAR(50) NULL,
    [category] VARCHAR(12) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scrip_mast1
-- --------------------------------------------------
CREATE TABLE [dbo].[scrip_mast1]
(
    [scrip_code] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(500) NULL,
    [scp_grp] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scripgroupmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[scripgroupmaster]
(
    [scripcode] VARCHAR(50) NULL,
    [exchangecode] VARCHAR(50) NULL,
    [scripid] VARCHAR(50) NULL,
    [scripname] VARCHAR(150) NULL,
    [sectorcode] VARCHAR(150) NULL,
    [instrumenttype] VARCHAR(50) NULL,
    [groupname] VARCHAR(50) NULL,
    [scriptype] VARCHAR(50) NULL,
    [facevalue] VARCHAR(50) NULL,
    [marketlot] VARCHAR(50) NULL,
    [ticksize] VARCHAR(50) NULL,
    [filler] VARCHAR(50) NULL,
    [status] VARCHAR(50) NULL,
    [ex_div_date] VARCHAR(150) NULL,
    [no_del_enddate] VARCHAR(50) NULL,
    [no_del_startdate] VARCHAR(50) NULL,
    [splmargin] VARCHAR(50) NULL,
    [isin_code] VARCHAR(150) NULL,
    [filler2] VARCHAR(50) NULL,
    [bc_startdate] VARCHAR(50) NULL,
    [ex_bonusdate] VARCHAR(50) NULL,
    [ex_rightdate] VARCHAR(50) NULL,
    [ex_split] VARCHAR(50) NULL,
    [filler3] VARCHAR(50) NULL,
    [bc_enddate] VARCHAR(50) NULL,
    [ndflag] VARCHAR(50) NULL,
    [pregroupname] VARCHAR(50) NULL,
    [LAST_UPD_DT] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.scripgroupmaster_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[scripgroupmaster_temp]
(
    [Column 0] VARCHAR(50) NULL,
    [Column 1] VARCHAR(50) NULL,
    [Column 2] VARCHAR(50) NULL,
    [Column 3] VARCHAR(50) NULL,
    [Column 4] VARCHAR(50) NULL,
    [Column 5] VARCHAR(50) NULL,
    [Column 6] VARCHAR(50) NULL,
    [Column 7] VARCHAR(50) NULL,
    [Column 8] VARCHAR(50) NULL,
    [Column 9] VARCHAR(50) NULL,
    [Column 10] VARCHAR(50) NULL,
    [Column 11] VARCHAR(50) NULL,
    [Column 12] VARCHAR(50) NULL,
    [Column 13] VARCHAR(50) NULL,
    [Column 14] VARCHAR(50) NULL,
    [Column 15] VARCHAR(50) NULL,
    [Column 16] VARCHAR(50) NULL,
    [Column 17] VARCHAR(50) NULL,
    [Column 18] VARCHAR(50) NULL,
    [Column 19] VARCHAR(50) NULL,
    [Column 20] VARCHAR(50) NULL,
    [Column 21] VARCHAR(50) NULL,
    [Column 22] VARCHAR(50) NULL,
    [Column 23] VARCHAR(50) NULL,
    [Column 24] VARCHAR(50) NULL,
    [Column 25] VARCHAR(50) NULL,
    [Column 26] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[Shortage]
(
    [PartyCode] VARCHAR(50) NOT NULL,
    [Branch] VARCHAR(50) NOT NULL,
    [Region] VARCHAR(50) NOT NULL,
    [SBTag] VARCHAR(50) NOT NULL,
    [NCM_Val] MONEY NOT NULL,
    [NCM_Val_HC] MONEY NOT NULL,
    [BF_Val] MONEY NOT NULL,
    [DayBuy_1] MONEY NOT NULL,
    [DaySell_1] MONEY NOT NULL,
    [DayBuy_2] MONEY NOT NULL,
    [DaySell_2] MONEY NOT NULL,
    [LedgerBalance] MONEY NOT NULL,
    [CallExcess] MONEY NOT NULL,
    [MarginShortage] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Shortage_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[Shortage_hist]
(
    [PartyCode] VARCHAR(50) NULL,
    [Branch] VARCHAR(50) NULL,
    [Region] VARCHAR(50) NULL,
    [SBTag] VARCHAR(50) NULL,
    [NCM_Val] VARCHAR(50) NULL,
    [NCM_Val_HC] VARCHAR(50) NULL,
    [BF_Val] VARCHAR(50) NULL,
    [DayBuy_1] VARCHAR(50) NULL,
    [DaySell_1] VARCHAR(50) NULL,
    [DayBuy_2] VARCHAR(50) NULL,
    [DaySell_2] VARCHAR(50) NULL,
    [LedgerBalance] VARCHAR(50) NULL,
    [CallExcess] VARCHAR(50) NULL,
    [MarginShortage] VARCHAR(50) NULL,
    [Insert_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.t_tgroup
-- --------------------------------------------------
CREATE TABLE [dbo].[t_tgroup]
(
    [sauda_date] DATETIME NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [P_value] MONEY NULL,
    [S_value] MONEY NULL,
    [abl_ledger] MONEY NULL,
    [acdl_ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.T619
-- --------------------------------------------------
CREATE TABLE [dbo].[T619]
(
    [upd_Date] DATETIME NULL,
    [td_date] VARCHAR(10) NULL,
    [SAUDA_dATE] DATETIME NULL,
    [FUNDS_PAYIN] DATETIME NULL,
    [SETT_NO] CHAR(7) NULL,
    [SETT_TYPE] CHAR(3) NULL,
    [BRANCH_CD] VARCHAR(10) NULL,
    [SUB_BROKER] VARCHAR(10) NULL,
    [FAMILY] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NULL,
    [PARTY_NAME] VARCHAR(100) NULL,
    [SCRIP_cD] VARCHAR(12) NULL,
    [SCRIP_NAME] VARCHAR(50) NULL,
    [PQTYDEL] INT NULL,
    [PAMTDEL] MONEY NULL,
    [NBFC_FUNDING] NUMERIC(38, 6) NULL,
    [SQTYDEL] INT NULL,
    [SAMTDEL] MONEY NULL,
    [holding] FLOAT NULL,
    [balancetd] MONEY NULL,
    [bill_amt] MONEY NULL,
    [shortage] MONEY NULL,
    [tobegiven] MONEY NULL,
    [prev_shortage] MONEY NULL,
    [sell_value] MONEY NULL,
    [x_shortage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NBFC_Call_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NBFC_Call_Data]
(
    [Fld_Party_Code] VARCHAR(20) NULL,
    [Fld_Scrip_Code] VARCHAR(50) NULL,
    [Fld_Total_Qty] INT NULL,
    [Fld_NCMQty] INT NULL,
    [Fld_BFQty] INT NULL,
    [Fld_T2] MONEY NULL,
    [Fld_T1] MONEY NULL,
    [Fld_Cl_Pr] MONEY NULL,
    [Fld_Cash_Margin] MONEY NULL,
    [Fld_HC] INT NULL,
    [Fld_NCM_Val] MONEY NULL,
    [Fld_NCM_Val_HC] MONEY NULL,
    [Fld_BF_Val] MONEY NULL,
    [Fld_BF_Val_HC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NBFC_Main_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NBFC_Main_Data]
(
    [Fld_Party_Code] VARCHAR(20) NULL,
    [Fld_Branch] VARCHAR(20) NULL,
    [Fld_Region] VARCHAR(20) NULL,
    [Fld_Sb_Tag] VARCHAR(20) NULL,
    [Fld_Cash] MONEY NULL,
    [Fld_NonCash] MONEY NULL,
    [Fld_NonCash_After_HairCut] MONEY NULL,
    [Fld_NBFC_Holding] MONEY NULL,
    [Fld_NBFC_Holding_After_HairCut] MONEY NULL,
    [Fld_P_DayBuy] MONEY NULL,
    [Fld_P_Buy_AfterHairCut] MONEY NULL,
    [Fld_P_DaySell] MONEY NULL,
    [Fld_P_Sell_AfterHairCut] MONEY NULL,
    [Fld_C_DayBuy] MONEY NULL,
    [Fld_C_Buy_AfterHairCut] MONEY NULL,
    [Fld_C_DaySell] MONEY NULL,
    [Fld_C_Sell_AfterHairCut] MONEY NULL,
    [Fld_NBFC_Led_Bal] MONEY NULL,
    [Fld_Call_Excess_Shortage] MONEY NULL,
    [Fld_Portfolio_Valuation] MONEY NULL,
    [Fld_Net_Portfolio_Valuation] MONEY NULL,
    [Fld_Margin_Maintain_per] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_temp]
(
    [clcd] VARCHAR(10) NULL,
    [balance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [isin] VARCHAR(25) NULL,
    [bse_qty] INT NULL,
    [nse_qty] INT NULL,
    [actvalue] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_holding
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_holding]
(
    [clid] VARCHAR(16) NULL,
    [clcd] VARCHAR(25) NULL,
    [hold_Date] DATETIME NULL,
    [isin] VARCHAR(25) NULL,
    [scripname] VARCHAR(50) NULL,
    [scrip_code] VARCHAR(25) NULL,
    [qty] INT NULL,
    [actvalue] MONEY NULL DEFAULT 0.00,
    [dummy1] VARCHAR(25) NULL,
    [dummy2] VARCHAR(25) NULL,
    [scpgrp] VARCHAR(10) NULL DEFAULT 'N',
    [haircut] INT NULL DEFAULT 25,
    [holdvalue] MONEY NULL DEFAULT 0,
    [bse_qty] INT NULL DEFAULT 0,
    [nse_qty] INT NULL DEFAULT 0,
    [bse_value] MONEY NULL DEFAULT 0,
    [nse_value] MONEY NULL DEFAULT 0,
    [bse_pqty] INT NULL,
    [nse_pqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_tally_group
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_tally_group]
(
    [clcd] VARCHAR(100) NULL,
    [upd_date] DATETIME NULL,
    [balance] MONEY NULL,
    [drcr] VARCHAR(20) NULL,
    [company] VARCHAR(10) NULL,
    [dummy1] VARCHAR(25) NULL,
    [dummy2] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempx1
-- --------------------------------------------------
CREATE TABLE [dbo].[tempx1]
(
    [clid] VARCHAR(1) NOT NULL,
    [clcd] VARCHAR(15) NULL,
    [hold_Date] DATETIME NULL,
    [isin] VARCHAR(1) NOT NULL,
    [scripname] VARCHAR(15) NULL,
    [scrip_code] VARCHAR(15) NULL,
    [Qty] INT NULL,
    [actValue] MONEY NULL,
    [dummy1] VARCHAR(1) NOT NULL,
    [dummy2] VARCHAR(1) NOT NULL,
    [scpgrp] VARCHAR(1) NOT NULL,
    [haircut] INT NOT NULL,
    [holdValue] MONEY NULL,
    [bse_Qty] INT NULL,
    [nse_qty] INT NOT NULL,
    [BSE_Value] MONEY NULL,
    [nse_value] INT NOT NULL,
    [bse_pqty] INT NOT NULL,
    [nse_pqty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempx2
-- --------------------------------------------------
CREATE TABLE [dbo].[tempx2]
(
    [clcd] VARCHAR(50) NULL,
    [hold_date] DATETIME NULL,
    [isin] VARCHAR(50) NULL,
    [scripname] VARCHAR(255) NULL,
    [scrip_code] VARCHAR(15) NULL,
    [Qty] NUMERIC(30, 4) NOT NULL,
    [ActValue] NUMERIC(38, 6) NULL,
    [dummy1] VARCHAR(1) NOT NULL,
    [dummy2] VARCHAR(1) NOT NULL,
    [scpgrp] VARCHAR(1) NOT NULL,
    [haircut] INT NOT NULL,
    [holdValue] NUMERIC(38, 6) NULL,
    [bse_Qty] NUMERIC(30, 4) NOT NULL,
    [nse_qty] INT NOT NULL,
    [bse_Value] NUMERIC(38, 6) NULL,
    [nse_value] INT NOT NULL,
    [bse_pqty] INT NOT NULL,
    [nse_pqty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TGROUP1
-- --------------------------------------------------
CREATE TABLE [dbo].[TGROUP1]
(
    [ScripCode] VARCHAR(10) NULL,
    [Name of the Company] VARCHAR(150) NULL,
    [Group] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ttt
-- --------------------------------------------------
CREATE TABLE [dbo].[ttt]
(
    [branch_cd] VARCHAR(10) NULL,
    [sub_Broker] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [P_value] MONEY NULL,
    [S_value] MONEY NULL,
    [abl_ledger] MONEY NULL,
    [acdl_ledger] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xxxtemp1
-- --------------------------------------------------
CREATE TABLE [dbo].[xxxtemp1]
(
    [clid] VARCHAR(1) NOT NULL,
    [clcd] VARCHAR(50) NULL,
    [hold_date] DATETIME NULL,
    [isin] VARCHAR(50) NULL,
    [scripname] VARCHAR(255) NULL,
    [scrip_code] VARCHAR(15) NULL,
    [Qty] INT NULL,
    [ActValue] NUMERIC(38, 6) NULL,
    [dummy1] VARCHAR(1) NOT NULL,
    [dummy2] VARCHAR(1) NOT NULL,
    [scpgrp] VARCHAR(1) NOT NULL,
    [haircut] INT NOT NULL,
    [holdValue] NUMERIC(38, 6) NULL,
    [bse_Qty] NUMERIC(30, 4) NOT NULL,
    [nse_qty] INT NOT NULL,
    [bse_Value] NUMERIC(38, 6) NULL,
    [nse_value] INT NOT NULL,
    [bse_pqty] INT NOT NULL,
    [nse_pqty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xxxtemp2
-- --------------------------------------------------
CREATE TABLE [dbo].[xxxtemp2]
(
    [clid] VARCHAR(1) NOT NULL,
    [clcd] VARCHAR(15) NULL,
    [hold_Date] DATETIME NULL,
    [isin] VARCHAR(1) NOT NULL,
    [scripname] VARCHAR(15) NULL,
    [scrip_code] VARCHAR(15) NULL,
    [Qty] INT NULL,
    [actValue] MONEY NULL,
    [dummy1] VARCHAR(1) NOT NULL,
    [dummy2] VARCHAR(1) NOT NULL,
    [scpgrp] VARCHAR(1) NOT NULL,
    [haircut] INT NOT NULL,
    [holdValue] MONEY NULL,
    [bse_Qty] INT NULL,
    [nse_qty] INT NOT NULL,
    [BSE_Value] MONEY NULL,
    [nse_value] INT NOT NULL,
    [bse_pqty] INT NOT NULL,
    [nse_pqty] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.zgroup
-- --------------------------------------------------
CREATE TABLE [dbo].[zgroup]
(
    [Col001] VARCHAR(15) NULL,
    [Col002] VARCHAR(250) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.clientmaster
-- --------------------------------------------------
CREATE view clientmaster
 as
 select  party_Code, long_name as party_name, first_active_Date as fromdate, last_inactive_date as todate 
 from intranet.risk.dbo.client_Details where (cl_type='NBF' or cl_type='SBF')

GO

-- --------------------------------------------------
-- VIEW dbo.miles_holding
-- --------------------------------------------------
CREATE view miles_holding        
as        
select clid='',              
clcd=clientcode,            
hold_date=date,            
isindemat as isin,            
ltrim(rtrim(fullname))+'-'+stocktype as scripname,loanaccountcode as scrip_code ,            
convert(int,nbfcopenqty)-convert(int,Markerreceivable) as Qty,            
valuationatclosingprice as ActValue,            
dummy1='' collate SQL_Latin1_General_CP1_CI_AS,        
dummy2='' collate SQL_Latin1_General_CP1_CI_AS,        
scpgrp='' collate SQL_Latin1_General_CP1_CI_AS,haircut=0,            
valuationatclosingprice as holdValue,            
nbfcopenqty as bse_Qty,nse_qty=0,valuationatclosingprice as bse_Value,nse_value=0,bse_pqty=0,nse_pqty=0,  
Appr=isnull(b.app,'N')            
from intranet.risk.dbo.Miles_holding a   
left outer join  
(select scode,app='Y' from intranet.risk.dbo.isin where (app='*' or nse_appr='*')) b  
on a.loanaccountcode collate Latin1_General_CI_AS=b.scode

GO

-- --------------------------------------------------
-- VIEW dbo.miles_nbfc_client
-- --------------------------------------------------
create view miles_nbfc_client  
as  
select party_Code from intranet.risk.dbo.client_Details a, 
intranet.risk.dbo.miles_branch b where a.branch_cd=b.miles_branch

GO

-- --------------------------------------------------
-- VIEW dbo.nbfc_holding
-- --------------------------------------------------
CREATE view nbfc_holding                    
as                    
--select top 0 * from intranet.risk.dbo.nbfc_holding                               
/*                
select * from pradnya_nbfc_holding1      
  where clcd not in    
  (Select party_Code from intranet.risk.dbo.client_Details where branch_cd in    
  (Select miles_branch from intranet.risk.dbo.miles_branch))    
union              
*/  
select * from miles_holding    
/*  
where clcd in    (Select party_Code from intranet.risk.dbo.client_Details where branch_cd in    
  (Select miles_branch from intranet.risk.dbo.miles_branch))    
*/

GO

-- --------------------------------------------------
-- VIEW dbo.pradnya_nbfc_client
-- --------------------------------------------------
create view pradnya_nbfc_client
as
select party_Code from intranet.risk.dbo.client_Details a left outer join 
intranet.risk.dbo.miles_branch b on a.branch_cd=b.miles_branch  
where b.miles_branch is null

GO

-- --------------------------------------------------
-- VIEW dbo.pradnya_nbfc_holding
-- --------------------------------------------------
CREATE view pradnya_nbfc_holding
as
select clid='',      
clcd=fld_party_code,      
hold_Date=fld_Date,isin='' collate SQL_Latin1_General_CP1_CI_AS,
scripname=scrip_Cd,scrip_code=scrip_Cd,Qty=Fld_BF_qty+fld_NCM_Qty,actValue=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,      
dummy1='' collate SQL_Latin1_General_CP1_CI_AS,
dummy2='' collate SQL_Latin1_General_CP1_CI_AS,
scpgrp='' collate SQL_Latin1_General_CP1_CI_AS,
haircut=0,holdValue=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,      
bse_Qty=Fld_BF_qty+fld_NCM_Qty,nse_qty=0,BSE_Value=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,nse_value=0,bse_pqty=0,nse_pqty=0      
from upload.dbo.tbl_Col_data (nolock) where fld_date = (select max(fld_Date) from upload.dbo.tbl_Col_data (nolock))      
and fld_party_code in     
(select party_Code from intranet.risk.dbo.client_Details where branch_cd not in (select miles_branch from intranet.risk.dbo.miles_branch ))

GO

-- --------------------------------------------------
-- VIEW dbo.pradnya_nbfc_holding_latest
-- --------------------------------------------------
create view pradnya_nbfc_holding_latest
as
select clid=' ',      
clcd=fld_party_code,      
hold_Date=fld_Date,isin=' ' collate SQL_Latin1_General_CP1_CI_AS,
scripname=scrip_Cd,scrip_code=scrip_Cd,Qty=Fld_BF_qty+fld_NCM_Qty,actValue=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,      
dummy1=' ' collate SQL_Latin1_General_CP1_CI_AS,
dummy2=' ' collate SQL_Latin1_General_CP1_CI_AS,
scpgrp=' ' collate SQL_Latin1_General_CP1_CI_AS,
haircut=0,holdValue=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,      
bse_Qty=Fld_BF_qty+fld_NCM_Qty,nse_qty=0,BSE_Value=(Fld_BF_qty+fld_NCM_Qty)*Fld_cl_rate,nse_value=0,bse_pqty=0,nse_pqty=0      
from upload.dbo.tbl_Col_data (nolock) 
where fld_date = (select max(fld_Date) from upload.dbo.tbl_Col_data (nolock))

GO

-- --------------------------------------------------
-- VIEW dbo.pradnya_nbfc_holding1
-- --------------------------------------------------
CREATE view pradnya_nbfc_holding1
as
--select a.* from pradnya_nbfc_holding_latest a , pradnya_nbfc_client b where a.clcd=b.party_Code

select a.* from pradnya_nbfc_holding_latest a left outer join miles_nbfc_client b on  a.clcd=b.party_Code
where b.party_Code is null

GO

-- --------------------------------------------------
-- VIEW dbo.TALLY_GROUP
-- --------------------------------------------------
CREATE view TALLY_GROUP           
as          
  
select clcd=cltcode,upd_date=tdate,        
--balance=abs(funding),        
balance=abs(ledger),        
drcr=(case when ledger >= 0 then 'DR' else 'CR' end),          
company='ABLCM'          
FROM INTRANET.RISK.DBO.NBFC_POSITION           
  
/*    
select clcd=fld_party_code,upd_date=Fld_Datetime,    
balance=abs(Fld_total_amt),     
drcr=(case when Fld_total_amt >= 0 then 'DR' else 'CR' end),          
company='ABLCM'          
from upload.dbo.tbl_holding_data where Fld_Datetime  in (select max(Fld_Datetime) from upload.dbo.tbl_holding_data )    
*/

GO

