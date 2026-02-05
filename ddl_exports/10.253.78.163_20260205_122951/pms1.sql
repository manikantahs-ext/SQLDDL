-- DDL Export
-- Server: 10.253.78.163
-- Database: pms1
-- Exported: 2026-02-05T12:30:01.448069

USE pms1;
GO

-- --------------------------------------------------
-- INDEX dbo.clientmast
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ind_eff_from] ON [dbo].[clientmast] ([eff_from], [eff_to])

GO

-- --------------------------------------------------
-- INDEX dbo.clientmast
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_CLIENTID] ON [dbo].[clientmast] ([clientid], [eff_to])

GO

-- --------------------------------------------------
-- INDEX dbo.clientmast
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [pmscode] ON [dbo].[clientmast] ([pmscode], [clientid])

GO

-- --------------------------------------------------
-- INDEX dbo.cpcumm
-- --------------------------------------------------
CREATE CLUSTERED INDEX [date+scode] ON [dbo].[cpcumm] ([mfdate], [scode])

GO

-- --------------------------------------------------
-- INDEX dbo.pms_Data
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [rep_date] ON [dbo].[pms_Data] ([Rep_date])

GO

-- --------------------------------------------------
-- INDEX dbo.pms_user
-- --------------------------------------------------
CREATE CLUSTERED INDEX [fldlastname] ON [dbo].[pms_user] ([fldlastname])

GO

-- --------------------------------------------------
-- INDEX dbo.rm_fin
-- --------------------------------------------------
CREATE CLUSTERED INDEX [scrip_cd] ON [dbo].[rm_fin] ([Scrip_Cd], [CF])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.rerurns_calc
-- --------------------------------------------------
ALTER TABLE [dbo].[rerurns_calc] ADD CONSTRAINT [PK_rerurns_calc] PRIMARY KEY ([row_id])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cldetails
-- --------------------------------------------------

CREATE procedure cldetails(@pmscode as varchar(10), @fdate as datetime, @tdate as datetime, @afdate as datetime)
as

--exec cldetails 'AA','08/01/2004','08/10/2004','04/01/2004'
-- fdate as fromdate
-- tdate as uptodate
-- afdate is accounting date from
/*
declare @pmscode as varchar(10)
declare @fdate as datetime 
declare @tdate as datetime
declare @afdate as datetime

set @pmscode = 'AA'
set @fdate = '08/01/2004'
set @tdate = '08/10/2004'
set @afdate = '04/01/2004'
*/

select pms.pmscode,pms.pmsname,cl.clientid,cl.clientname,LEdger=balance,open_position=isnull(open_position,0), 
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)
from
pms_manager pms, clientmast cl left outer join
(
select cltcode, balance=sum(case when drcr='D' then vamt else vamt*-1 end) from anand.account_ab.dbo.ledger
where vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by cltcode
) ledger left outer join
(
select party_code,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),open_position=sum(open_position),tradpl=sum(tradpl),tover=sum(tover),
brokerage=sum(brokerage) from 
(
select party_code, scrip_cd, netqty=sum(pqtydel-sqtydel),open_position=sum(pamtdel-samtdel),tradpl=sum(pamttrd-samttrd), 
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd)
from anand.bsedb_ab.dbo.cmbillvalan 
where sauda_date >= @fdate+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'
group by party_code, scrip_cd
) tvalan, 
(
select x.* from risk.dbo.cpcumm x,
(select scode, mfdate=max(mfdate) from risk.dbo.cpcumm where mfdate <= @tdate+' 23:59:59.000' group by scode ) y
where x.scode=y.scode and y.mfdate=x.mfdate
) cp where cp.scode=tvalan.scrip_cd 
group by party_code
) valan on valan.party_Code=ledger.cltcode on ledger.cltcode=cl.clientid
where pms.pmscode=cl.pmscode and cl.clientid=ledger.cltcode and pms.pmscode=@pmscode
order by clientid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cldetails_new
-- --------------------------------------------------
CREATE procedure cldetails_new (@pmscode as varchar(10), @fdate as datetime, @tdate as datetime, @afdate as datetime)
as

--exec cldetails 'AA','08/01/2004','08/10/2004','04/01/2004'
-- fdate as fromdate
-- tdate as uptodate
-- afdate is accounting date from

/*
declare @pmscode as varchar(10)
declare @fdate as datetime 
declare @tdate as datetime
declare @afdate as datetime

set @pmscode = 'RAJEN'
set @fdate = '01/01/2001'
set @tdate = '10/07/2004'
set @afdate = '04/01/2004'
*/

select pms.pmscode,pms.pmsname,cl.clientid,cl.clientname,LEdger=balance,open_position=isnull(open_position,0), 
bookpl=isnull(bookpl,0), tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)
from
pms_manager pms, clientmast cl left outer join
(
select cltcode, balance=sum(case when drcr='D' then vamt else vamt*-1 end) from anand.account_ab.dbo.ledger
where vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by cltcode
) ledger left outer join
(
select party_code,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),open_position=sum(open_position),bookpl=sum(bookpl), 
tradpl=sum(tradpl),tover=sum(tover), brokerage=sum(brokerage) from 
(
select party_code, scrip_cd, netqty=sum(pqtydel-sqtydel),
--open_position=sum(pamtdel-samtdel),
open_position=(case when sum(pqtydel-sqtydel)<>0 then sum(pamtdel-samtdel) else 0 end),
tradpl=sum(pamttrd-samttrd), 
bookpl=(case when sum(pqtydel-sqtydel)=0 then sum(pamtdel-samtdel) else 0 end),
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd)
from anand.bsedb_ab.dbo.cmbillvalan 
where sauda_date >= @fdate+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000' 
group by party_code, scrip_cd
) tvalan, 
(
select x.* from risk.dbo.cpcumm x,
(select scode, mfdate=max(mfdate) from risk.dbo.cpcumm where mfdate <= @tdate+' 23:59:59.000' group by scode ) y
where x.scode=y.scode and y.mfdate=x.mfdate
) cp where cp.scode=tvalan.scrip_cd 
group by party_code
) valan on valan.party_Code=ledger.cltcode on ledger.cltcode=cl.clientid
where pms.pmscode=cl.pmscode and cl.clientid=ledger.cltcode and pms.pmscode=@pmscode 
order by clientid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fifo_temp
-- --------------------------------------------------
CREATE procedure fifo_temp(@clcd as varchar(10))
as


delete from rm_temp
delete from rmbillvalan

insert into rmbillvalan (Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date)
select 
Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date 
from rmbillvalan_full where party_code=@clcd order by party_Code,scrip_cd,sauda_Date

/*
delete from rmbillvalan 
insert into rmbillvalan(Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date)
select 
Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date
from rmbillvalan_full where party_code =@clcd
delete from rm_temp
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fifo_temp_last
-- --------------------------------------------------

create procedure fifo_temp_last
as

insert into rm_temp select 
Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,SqOffDate,CF,valid
from rmbillvalan where valid = 'Y' 

insert into rm_fin select* from rm_temp

GO

-- --------------------------------------------------
-- PROCEDURE dbo.genuser
-- --------------------------------------------------
create procedure genuser 
as
insert into pms_user (fldpartycode, fldpassword,fldpasscheck,fldfirstname,fldlastname)
select clientid,clientid,clientid,clientname,'C' from clientmast a left outer join pms_user b on a.clientid=b.fldpartycode where b.fldpartycode is null

insert into pms_user (fldpartycode, fldpassword,fldpasscheck,fldfirstname,fldlastname)
select distinct location,location,location,location,'L' from clientmast a left outer join pms_user b on a.location=b.fldpartycode where b.fldpartycode is null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GenUser_LA
-- --------------------------------------------------
create procedure GenUser_LA(@uname as varchar(25), @pswd as varchar(25))
as
--declare @uname as varchar(25), @pswd as varchar(25)
--set @uname= 'KUNTAL'
--set @pswd = 'BANGALORE'

select top 1 * into #AAA from pms_user where fldlastname='LA'
update #aaa set fldpartycode = @uname, fldpassword=@pswd, fldpasscheck=@uname, fldfirstname = @uname

insert into pms_user (fldpartycode,fldpassword,fldpasscheck,fldfavshare,fldfirstname,fldmidname,fldlastname,fldemail,fldbdate,fldgender,fldzip,fldcountry,fldstate,fldcity,fldaddress,fldphone1,fldphone2,abl_upd,acdl_upd,fo_upd)
select fldpartycode,fldpassword,fldpasscheck,fldfavshare,fldfirstname,fldmidname,fldlastname,fldemail,fldbdate,fldgender,fldzip,fldcountry,fldstate,fldcity,fldaddress,fldphone1,fldphone2,abl_upd,acdl_upd,fo_upd from #aaa

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_cldetails_a
-- --------------------------------------------------
create procedure pms_cldetails_a (@pmscode as varchar(10),@pmsname as varchar(50), @fdate as datetime, @tdate as datetime, @afdate as datetime, @loca as varchar(25))
as


--exec cldetails 'AA','08/01/2004','08/10/2004','04/01/2004'
-- fdate as fromdate
-- tdate as uptodate
-- afdate is accounting date from

/*
declare @pmscode as varchar(10)
declare @pmsname as varchar(25)
declare @fdate as datetime 
declare @tdate as datetime
declare @afdate as datetime
declare @loca as varchar(10)

set @pmscode = 'RAJEN'
set @pmsname = 'RAJEN'
set @fdate = '01/01/2001'
set @tdate = '10/18/2004'
set @afdate = '04/01/2004'
set @loca = 'SURAT'
*/

select pmscode=@pmscode,pmsname=@pmsname,clientid=ledger.cltcode,clientname=acname,ledger.limit,ledger.location,eff_from=isnull(eff_from,befffrom),LEdger=balance,
open_position=isnull(open_position,0), bookpl=isnull(bookpl,0),
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)
from
(
select cltcode,acname,b.location,b.befffrom,balance=sum(case when drcr='D' then vamt else vamt*-1 end) from ledger a,
(select CLIENTID,limit,befffrom=eff_from,location from intranet.PMS1.DBO.CLIENTMAST WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) b
where a.cltcode=b.clientid and vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by cltcode,acname, befffrom, location

) ledger left outer join
(
select party_code,location,eff_from,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),
open_position=sum(case when netqty > 0 then open_position else 0 end),
bookpl=sum(bookpl), tradpl=sum(tradpl),tover=sum(tover),
brokerage=sum(brokerage) from 
(
select party_code, cl.location, cl.eff_from, scrip_cd, netqty=sum(pqtydel-sqtydel),
tradpl=sum(pamttrd-samttrd), 
open_position=(case when sum(pqtydel-sqtydel)<>0 then sum(pamtdel-samtdel) else 0 end),
bookpl=(case when sum(pqtydel-sqtydel)=0 then sum(pamtdel-samtdel) else 0 end),
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd),
rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end)
from 
(select a.*, b.rate from anand.bsedb_ab.dbo.cmbillvalan a left outer join 
(select x.* from intranet.risk.dbo.cpcumm x, (select scode, mfdate=max(mfdate) 
from intranet.risk.dbo.cpcumm where mfdate <= @tdate+' 23:59:59' group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate
) b on b.scode=a.scrip_cd ) CM, 
(select * from intranet.PMS1.DBO.CLIENTMAST WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) CL
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'
group by party_code, cl.eff_from,scrip_cd,rate,location


) tvalan
/*
, 
(

select x.* from MANESHM.risk.dbo.cpcumm x,
(select scode, mfdate=max(mfdate) from MANESHM.risk.dbo.cpcumm where mfdate <= @tdate+' 23:59:59.000' group by scode ) y
where x.scode=y.scode and y.mfdate=x.mfdate

) cp where cp.scode=tvalan.scrip_cd 
*/
group by party_code,eff_from,location
) valan on valan.party_Code=ledger.cltcode 
order by clientid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_cldetails_ab
-- --------------------------------------------------
CREATE procedure pms_cldetails_ab (@pmscode as varchar(10),@pmsname as varchar(50), @fdate as datetime, @tdate as datetime, @afdate as datetime, @loca as varchar(25))
as


--exec cldetails 'AA','08/01/2004','08/10/2004','04/01/2004'
-- fdate as fromdate
-- tdate as uptodate
-- afdate is accounting date from

/*
declare @pmscode as varchar(10)
declare @pmsname as varchar(25)
declare @fdate as datetime 
declare @tdate as datetime
declare @afdate as datetime
declare @loca as varchar(10)

set @pmscode = 'RAJEN'
set @pmsname = 'RAJEN'
set @fdate = '01/01/2001'
set @tdate = '05/12/2005'
set @afdate = '04/01/2005'
set @loca = 'MUMBAI'
*/


--select * into cpcumm from intranet.risk.dbo.cpcumm

set nocount on

select party_code, cl.location, cl.eff_from, scrip_cd, netqty=sum(case when cf='Y' then pqtydel else 0 end),
tradpl=sum(pamttrd-samttrd), 
--open_position=(case when sum(pqtydel-sqtydel)<>0 then sum(pamtdel-samtdel) else 0 end),
open_position=(case when cf='Y' and sum(pqtydel) > 0 then sum(pamtdel) else 0 end),
port_stock=sum(case when cf='Y' and sqtydel > 0 then samtdel else 0 end),
bookpl=sum(case when cf='N'  then pamtdel-samtdel else 0 end),
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd),
rate=isnull(rate,case when cf='Y' then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) into #b
from 
(
select a.*, b.rate from rm_fin a left outer join 
(
select x.* from cpcumm x, (select scode, mfdate=max(mfdate) 
from cpcumm where mfdate <= @tdate+' 23:59:59' group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate
) b on b.scode=a.scrip_cd 
) CM,
(select * from CLIENTMAST WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) CL
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'
group by party_code, cl.eff_from,scrip_cd,rate,location,cf,valid

select cltcode,acname,b.limit,b.location,b.befffrom,balance=sum(case when drcr='D' then vamt else vamt*-1 end) into #a from anand.account_ab.dbo.ledger a,
(select CLIENTID,limit=isnull(limit,0),befffrom=eff_from,location from CLIENTMAST WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) b
where a.cltcode=b.clientid and vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by cltcode,acname, befffrom, location, limit


select pmscode=@pmscode,pmsname=@pmsname,clientid=ledger.cltcode,clientname=acname,ledger.limit,ledger.location,eff_from=isnull(eff_from,befffrom),LEdger=balance,
open_position=isnull(open_position,0), port_stock=isnull(port_stock,0), bookpl=isnull(bookpl,0),
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)
from #a ledger left outer join
(
select party_code,location,eff_from,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),
open_position=isnull(sum(open_position),0),
--open_position=sum(case when netqty > 0 then open_position else 0 end), 
port_stock=isnull(sum(port_stock),0),
bookpl=sum(bookpl), tradpl=sum(tradpl), tover=sum(tover),
brokerage=sum(brokerage) from #b  tvalan group by party_code,eff_from,location
) valan on valan.party_Code=ledger.cltcode 
order by clientid

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_cldetails_ab_upload
-- --------------------------------------------------
CREATE procedure pms_cldetails_ab_upload (@tdate as datetime, @afdate as datetime)    
as    
    
/*
declare @tdate as datetime    
declare @afdate as datetime    
set @tdate = '11/20/2006'    
set @afdate = '04/01/2006'    
*/
--select top 10 * from rm_fin cpcumm from intranet.risk.dbo.cpcumm    
    
select scode, mfdate=max(mfdate) into #cp from cpcumm where mfdate <= @tdate+' 23:59:59' group by scode     
    
select distinct x.* into #cpcumm from cpcumm x, #cp y where x.scode=y.scode and y.mfdate=x.mfdate    
    
select a.*, b.rate into #rmfin from rm_fin a left outer join #cpcumm  b on b.scode=a.scrip_cd     
    
    
declare @dtMaxReportDate varchar(11)    
    
select party_code, cl.location, cl.eff_from, scrip_cd, netqty=sum(case when cf='Y' then pqtydel else 0 end),    
tradpl=sum(pamttrd-samttrd),     
open_position=(case when cf='Y' and sum(pqtydel) > 0 then sum(pamtdel) else 0 end),    
port_stock=sum(case when cf='Y' and sqtydel > 0 then samtdel else 0 end),    
--bookpl=sum(case when cf='N' and (pqtytrd+pqtydel-sqtytrd-sqtydel)=0 /*and SqOffDate is not null */ then pamttrd+pamtdel-samttrd-samtdel else 0 end),    
--bookpl=sum(case when cf='N' and SqOffDate is not null  then pamttrd+pamtdel-samttrd-samtdel else 0 end),    
bookpl=sum(    
 case when cf='N' and SqOffDate is not null  then    
  case when pqtytrd-sqtytrd=0 then pamttrd else 0 end +     
  case when sqOffdate is not null then pamtdel else 0 end -    
  case when pqtytrd-sqtytrd=0 then samttrd else 0 end -    
  case when sqOffdate is not null then samtdel else 0 end    
 else    
  0    
 end    
),    
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd),    
rate=isnull(rate,case when cf='Y' and sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) into #b    
from #rmfin  CM,    
(select * from CLIENTMAST WHERE eff_to >= @tdate) CL    
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'    
group by party_code, cl.eff_from,scrip_cd,rate,location,cf,valid    
    
select cltcode,acname=space(100),balance=sum(case when drcr='D' then vamt else vamt*-1 end) into #aa    
from anand.account_ab.dbo.ledger where vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'    
group by cltcode
    
update #aa  set acname=b.long_name from 
(select party_Code,long_name from intranet.risk.dbo.client_Details) b 
where #aa.cltcode=b.party_code

select pmscode,cltcode,acname,b.limit,b.location,b.befffrom,balance into #a     
from #aa a,    
(select pmscode,CLIENTID,limit=isnull(limit,0),befffrom=eff_from,location from CLIENTMAST WHERE eff_to >= @tdate ) b    
where a.cltcode=b.clientid --and vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'    
    
--group by pmscode,cltcode,acname, befffrom, location, limit    
    
--select max(rep_date) from pms_Data    
    
delete from pms_data where rep_Date = @tdate    
    
insert into pms_data (Rep_date,pmsname,clientid,clientname,limit,location,eff_from,LEdger,open_position,port_stock,bookpl,tradpl,not_pl,tover,brokerage,dividend, limit_with_profit)    
select Rep_date=@tdate,pmsname=pmscode,clientid=ledger.cltcode,clientname=acname,ledger.limit,ledger.location,eff_from=isnull(eff_from,befffrom),LEdger=balance,    
open_position=isnull(open_position,0), port_stock=isnull(port_stock,0), bookpl=isnull(bookpl,0),    
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0), dividend=0, limit_with_profit = 0    
from #a ledger left outer join    
(select party_code,location,eff_from,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),    
open_position=isnull(sum(open_position),0),    
--open_position=sum(case when netqty > 0 then open_position else 0 end),    
port_stock=isnull(sum(port_stock),0),    
bookpl=sum(bookpl), tradpl=sum(tradpl), tover=sum(tover),    
brokerage=sum(brokerage)    
 from #b  tvalan group by party_code,eff_from,location    
) valan on valan.party_Code=ledger.cltcode    
order by clientid    
    
/*FOR DIVIDEND*/    
--select @dtMaxReportDate = left(convert(varchar, max(rep_date), 109), 11) from pms_data    
select    
 cm.clientid,    
 sum(l.vamt) as vamt    
into    
 #dividend    
from    
 anand.account_ab.dbo.ledger l,    
 mis.pms1.dbo.clientmast cm    
where    
 l.cltcode = cm.clientid and    
 l.vdt >= left(convert(varchar, cm.eff_from, 109), 11) + ' 00:00:00' and    
 l.drcr = 'C' and    
 l.narration like '%div%' and    
 cm.eff_to >= @tdate + ' 00:00:00'    
group by    
 cm.clientid    
order by    
 cm.clientid    
    
update     
 pms_data     
set     
 dividend = vamt    
from    
 #dividend d    
where    
 pms_data.clientid = d.clientid and    
 convert(varchar, rep_date, 101) = @tdate    
/* rep_date like @tdate + '%'*/    
/*END - FOR DIVIDEND*/    
    
/*GET ORIG LIMITS*/    
update     
 pms_data     
set     
 limit_with_profit = limit    
where    
 convert(varchar, rep_date, 101) = @tdate    
 /*rep_date like @tdate + '%'*/    
/*END - GET ORIG LIMITS*/    
    
/*FOR UPDATING LIMIT w.r.t BOOKED PnL*/    
update     
 pms_data     
set     
 pms_data.limit_with_profit = pms_data.limit - (pms_data.bookpl + pms_data.tradpl)    
from    
 clientmast cm    
where    
 pms_data.clientid = cm.clientid and    
 cm.add_pnl_2_limit = 'Y'and    
 convert(varchar, rep_date, 101) = @tdate    
 /*rep_date like @tdate + '%'*/    
/*END - FOR UPDATING LIMIT w.r.t BOOKED PnL*/    
    
/*FOR UPDATING LIMIT w.r.t DIVIDEND*/    
update     
 pms_data     
set     
 pms_data.limit_with_profit = pms_data.limit_with_profit + pms_data.dividend    
from    
 clientmast cm    
where    
 pms_data.clientid = cm.clientid and    
 cm.add_dividend_2_limit = 'Y'and    
 convert(varchar, rep_date, 101) = @tdate    
 /*rep_date like @tdate + '%'*/    
/*END - FOR UPDATING LIMIT w.r.t DIVIDEND*/    
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_cldetails_ab_upload_old
-- --------------------------------------------------
CREATE procedure pms_cldetails_ab_upload_old (@tdate as datetime, @afdate as datetime)
as

/*
declare @tdate as datetime
declare @afdate as datetime
set @tdate = '11/07/2005'
set @afdate = '04/01/2005'
*/
--select top 10 * from rm_fin cpcumm from intranet.risk.dbo.cpcumm

select scode, mfdate=max(mfdate) into #cp from cpcumm where mfdate <= @tdate+' 23:59:59' group by scode 

select x.* into #cpcumm from cpcumm x, #cp y where x.scode=y.scode and y.mfdate=x.mfdate

select a.*, b.rate into #rmfin from rm_fin a left outer join #cpcumm  b on b.scode=a.scrip_cd 


declare @dtMaxReportDate varchar(11)

select party_code, cl.location, cl.eff_from, scrip_cd, netqty=sum(case when cf='Y' then pqtydel else 0 end),
tradpl=sum(pamttrd-samttrd), 
open_position=(case when cf='Y' and sum(pqtydel) > 0 then sum(pamtdel) else 0 end),
port_stock=sum(case when cf='Y' and sqtydel > 0 then samtdel else 0 end),
--bookpl=sum(case when cf='N' and (pqtytrd+pqtydel-sqtytrd-sqtydel)=0 /*and SqOffDate is not null */ then pamttrd+pamtdel-samttrd-samtdel else 0 end),
--bookpl=sum(case when cf='N' and SqOffDate is not null  then pamttrd+pamtdel-samttrd-samtdel else 0 end),
bookpl=sum(
	case when cf='N' and SqOffDate is not null  then
		case when pqtytrd-sqtytrd=0 then pamttrd else 0 end + 
		case when sqOffdate is not null then pamtdel else 0 end -
		case when pqtytrd-sqtytrd=0 then samttrd else 0 end -
		case when sqOffdate is not null then samtdel else 0 end
	else
		0
	end
),
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd),
rate=isnull(rate,case when cf='Y' and sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) into #b
from #rmfin  CM,
(select * from CLIENTMAST WHERE eff_to >= @tdate) CL
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'
group by party_code, cl.eff_from,scrip_cd,rate,location,cf,valid


select cltcode,acname,balance=sum(case when drcr='D' then vamt else vamt*-1 end) into #aa
from anand.account_ab.dbo.ledger where vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by cltcode,acname


select pmscode,cltcode,acname,b.limit,b.location,b.befffrom,balance into #a 
from #aa a,
(select pmscode,CLIENTID,limit=isnull(limit,0),befffrom=eff_from,location from CLIENTMAST WHERE eff_to >= @tdate ) b
where a.cltcode=b.clientid --and vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'

--group by pmscode,cltcode,acname, befffrom, location, limit

select max(rep_date) from pms_Data

--delete from pms_data where rep_Date = @tdate

insert into pms_data 
select Rep_date=@tdate,pmsname=pmscode,clientid=ledger.cltcode,clientname=acname,ledger.limit,ledger.location,eff_from=isnull(eff_from,befffrom),LEdger=balance,
open_position=isnull(open_position,0), port_stock=isnull(port_stock,0), bookpl=isnull(bookpl,0),
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0), dividend=0
from #a ledger left outer join
(select party_code,location,eff_from,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),
open_position=isnull(sum(open_position),0),
--open_position=sum(case when netqty > 0 then open_position else 0 end),
port_stock=isnull(sum(port_stock),0),
bookpl=sum(bookpl), tradpl=sum(tradpl), tover=sum(tover),
brokerage=sum(brokerage)
 from #b  tvalan group by party_code,eff_from,location
) valan on valan.party_Code=ledger.cltcode
order by clientid



/*FOR DIVIDEND*/
--select @dtMaxReportDate = left(convert(varchar, max(rep_date), 109), 11) from pms_data

select
	cm.clientid,
	sum(l.vamt) as vamt
into
	#dividend
from
	anand.account_ab.dbo.ledger l,
	mis.pms1.dbo.clientmast cm
where
	l.cltcode = cm.clientid and
	l.vdt >= left(convert(varchar, cm.eff_from, 109), 11) + ' 00:00:00' and
	l.drcr = 'C' and
	l.narration like '%div%' and
	cm.eff_to >= @tdate + ' 00:00:00'
group by
	cm.clientid
order by
	cm.clientid


update 
	pms_data 
set 
	dividend = vamt
from
	#dividend d
where
	pms_data.clientid = d.clientid
/*END - FOR DIVIDEND*/

/*FOR UPDATING LIMIT w.r.t BOOKED PnL*/


update 
	pms_data 
set 
	pms_data.limit = pms_data.limit+(pms_data.bookpl + pms_data.tradpl)
from
	clientmast cm
where
	pms_data.clientid = cm.clientid and
	cm.add_pnl_2_limit = 'Y'
/*END - FOR UPDATING LIMIT w.r.t BOOKED PnL*/

/*FOR UPDATING LIMIT w.r.t DIVIDEND*/


update 
	pms_data 
set 
	pms_data.limit = pms_data.limit + pms_data.dividend
from
	clientmast cm
where
	pms_data.clientid = cm.clientid and
	cm.add_dividend_2_limit = 'Y'
/*END - FOR UPDATING LIMIT w.r.t DIVIDEND*/

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_cldetails_ab_upload_old1
-- --------------------------------------------------
CREATE    procedure pms_cldetails_ab_upload_old1 (@tdate as datetime, @afdate as datetime)
as

/*
declare @tdate as datetime
declare @afdate as datetime
set @tdate = '05/12/2005'
set @afdate = '04/01/2005'
*/
--select top 10 * from rm_fin cpcumm from intranet.risk.dbo.cpcumm

declare @dtMaxReportDate varchar(11)

set nocount on

select party_code, cl.location, cl.eff_from, scrip_cd, netqty=sum(case when cf='Y' then pqtydel else 0 end),
tradpl=sum(pamttrd-samttrd), 
open_position=(case when cf='Y' and sum(pqtydel) > 0 then sum(pamtdel) else 0 end),
port_stock=sum(case when cf='Y' and sqtydel > 0 then samtdel else 0 end),

--bookpl=sum(case when cf='N' and (pqtytrd+pqtydel-sqtytrd-sqtydel)=0 /*and SqOffDate is not null */ then pamttrd+pamtdel-samttrd-samtdel else 0 end),
--bookpl=sum(case when cf='N' and SqOffDate is not null  then pamttrd+pamtdel-samttrd-samtdel else 0 end),

bookpl=sum(
	case when cf='N' and SqOffDate is not null  then
		case when pqtytrd-sqtytrd=0 then pamttrd else 0 end + 
		case when sqOffdate is not null then pamtdel else 0 end -
		case when pqtytrd-sqtytrd=0 then samttrd else 0 end -
		case when sqOffdate is not null then samtdel else 0 end
	else
		0
	end
),

tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd),
rate=isnull(rate,case when cf='Y' then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) into #b
from 
(
select a.*, b.rate from rm_fin a left outer join 
(
select x.* from cpcumm x, (select scode, mfdate=max(mfdate) 
from cpcumm where mfdate <= @tdate+' 23:59:59' group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate
) b on b.scode=a.scrip_cd 
) CM,
(select * from CLIENTMAST WHERE eff_to >= @tdate) CL
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'
group by party_code, cl.eff_from,scrip_cd,rate,location,cf,valid

select pmscode,cltcode,acname,b.limit,b.location,b.befffrom,balance=sum(case when drcr='D' then vamt else vamt*-1 end) into #a from anand.account_ab.dbo.ledger a,
(select pmscode,CLIENTID,limit=isnull(limit,0),befffrom=eff_from,location from CLIENTMAST WHERE eff_to >= @tdate ) b
where a.cltcode=b.clientid and vdt >= @afdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59.000'
group by pmscode,cltcode,acname, befffrom, location, limit

delete from pms_data where rep_Date = @tdate

insert into pms_data 
select Rep_date=@tdate,pmsname=pmscode,clientid=ledger.cltcode,clientname=acname,ledger.limit,ledger.location,eff_from=isnull(eff_from,befffrom),LEdger=balance,
open_position=isnull(open_position,0), port_stock=isnull(port_stock,0), bookpl=isnull(bookpl,0),
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0), dividend=0, limit_with_profit=0
from #a ledger left outer join
(select party_code,location,eff_from,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),
open_position=isnull(sum(open_position),0),
--open_position=sum(case when netqty > 0 then open_position else 0 end),
port_stock=isnull(sum(port_stock),0),
bookpl=sum(bookpl), tradpl=sum(tradpl), tover=sum(tover),
brokerage=sum(brokerage)
 from #b  tvalan group by party_code,eff_from,location
) valan on valan.party_Code=ledger.cltcode
order by clientid

/*FOR DIVIDEND*/
--select @dtMaxReportDate = left(convert(varchar, max(rep_date), 109), 11) from pms_data
--set transaction isolation level read uncommitted
select
	cm.clientid,
	sum(l.vamt) as vamt
into
	#dividend
from
	anand.account_ab.dbo.ledger l,
	mis.pms1.dbo.clientmast cm
where
	l.cltcode = cm.clientid and
	l.vdt >= left(convert(varchar, cm.eff_from, 109), 11) + ' 00:00:00' and
	l.drcr = 'C' and
	l.narration like '%div%' and
	cm.eff_to >= @tdate + ' 00:00:00'
group by
	cm.clientid
order by
	cm.clientid

update 
	pms_data 
set 
	dividend = vamt
from
	#dividend d
where
	pms_data.clientid = d.clientid and
	rep_date like @tdate + '%'
/*END - FOR DIVIDEND*/

/*COPY ORIG LIMITS TO NEW LIMIT*/
update
	pms_data
set
	limit_with_profit = limit
where
	rep_date like @tdate + '%'
/*END - COPY ORIG LIMITS TO NEW LIMIT*/

/*FOR UPDATING NEW LIMIT w.r.t BOOKED PnL*/
update 
	pms_data 
set 
	pms_data.limit_with_profit = pms_data.limit + -(pms_data.bookpl + pms_data.tradpl)
from
	clientmast cm
where
	pms_data.clientid = cm.clientid and
	pms_data.rep_date like @tdate + '%' and
	cm.add_pnl_2_limit = 'Y'
/*END - FOR UPDATING NEW LIMIT w.r.t BOOKED PnL*/

/*FOR UPDATING NEW LIMIT w.r.t DIVIDEND*/
update 
	pms_data 
set 
	pms_data.limit_with_profit = pms_data.limit_with_profit + pms_data.dividend
from
	clientmast cm
where
	pms_data.clientid = cm.clientid and
	pms_data.rep_date like @tdate + '%' and
	cm.add_dividend_2_limit = 'Y'
/*END - FOR UPDATING NEW LIMIT w.r.t DIVIDEND*/

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PMS_PRINT_a
-- --------------------------------------------------
/*ROLLED BACK*/
CREATE PROCEDURE PMS_PRINT_a (@acdate as varchar(25), @tdate as varchar(25), @pmscode as varchar(25), @loca as varchar(25))  
AS

/*
declare @acdate as varchar(25)
declare @tdate as varchar(25)
declare @pmscode as varchar(25)
declare @loca as varchar(25)  

set @acdate = '04/01/2005'
set @tdate = '05/25/2005'
set @pmscode = 'RAJEN'
set @loca = 'NRI'
*/

set nocount on

select cltcode,balance=sum(case when drcr='D' then vamt else vamt*-1 end) into #ledger from anand.account_ab.dbo.ledger 
where vdt >= @acdate+' 00:00:00.00' and vdt <= @tdate+' 23:59:59' group by cltcode,acname

SELECT LEDGER.*,PMSCL.CLIENTNAME,limit=isnull(pmscl.limit,0),location into #a FROM 
(select * from clientmast where pmscode=@pmscode and location like @loca 
and eff_to >= @tdate+' 23:59:59.00' ) pmscl, #ledger ledger 
WHERE PMSCL.CLIENTID=LEDGER.CLTCODE

select PARTY_CODE,scrip_cd,

/*NEW CONCEPT*/
--ptrdqty=sum(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
--pamttrd=sum(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end),
--sqtytrd=sum(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
--samttrd=sum(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
--pqtydel=sum(case when sqOffdate is not null then pqtydel else 0 end),
--pamtdel=sum(case when sqOffdate is not null then pamtdel else 0 end),
--sqtydel=sum(case when sqOffdate is not null then sqtydel else 0 end),
--samtdel=sum(case when sqOffdate is not null then samtdel else 0 end),

pqtytrd=sum(pqtytrd),
pamttrd=sum(pamttrd),
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel),
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),

pbroktrd=sum(pbroktrd),
sbroktrd=SUM(sbroktrd), 
pbrokdel=sum(pbrokdel),
sbrokdel=SUM(sbrokdel)

into #b 
from (select * from rm_fin where cf='Y' and valid='Y' and pqtydel > 0) aa,
(select * from clientmast where pmscode=@pmscode and location like @loca and eff_to >= @tdate+' 23:59:59.00' )  C
where aA.sauda_Date >= C.eff_from and sauda_date <= @tdate+' 23:59:59.00' AND C.CLIENTID=aA.PARTY_CODE
GROUP BY PARTY_CODE,scrip_cd
having (sum(pqtytrd)+sum(pqtydel))-(sum(sqtytrd)+sum(sqtydel))>0 

/*NEW CONCEPT*/
--update #b set 
--	pqtydel=pqtydel+ptrdqty,
--	sqtydel=sqtydel+sqtytrd,
--	pamtdel=pamttrd+pamtdel,
--	samtdel=samttrd+samtdel

--update #b set 
--	ptrdqty=0,
--	sqtytrd=0,
--	samttrd=0,
--	pamttrd=0

/*RATE NOT USED HERE IN THIS QRY*/
--update #b set 
--	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
--where 
--	rate = 0
/*END - NEW CONCEPT*/

select party_code=CLTCODE,Party_name=clientname,scrip_cd,scrip_name=scripname,

ptrdqty=sum(pqtytrd),
pamttrd=sum(pamttrd), 
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel), 
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),

trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel), /*rate, */
balance,limit,location from #a  X
LEFT OUTER JOIN 
(
SELECT A.*,SCRIPNAME=B.SCRIP_CD /*,CP.RATE*/ FROM #b A, anand.bsedb_Ab.dbo.scrip2 B
WHERE B.BSECODE=A.SCRIP_CD
) cm 
ON CM.PARTY_CODE=X.CLTCODE 
group by CLTCODE,clientname,scrip_cd,scripname,/*rate,*/ balance,limit,location
order by CLTCODE,scrip_name

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_scpdetails_b
-- --------------------------------------------------
CREATE procedure pms_scpdetails_b (@pmscode as varchar(10),@pmsname as varchar(50), @fdate as datetime, @tdate as datetime, @afdate as datetime, @loca as varchar(25))    
as    
    
/*    
declare @pmscode as varchar(10)    
declare @pmsname as varchar(10)    
declare @fdate as datetime     
declare @tdate as datetime    
declare @afdate as datetime    
declare @loca as varchar(10)    
    
set @pmscode = 'RAJEN'    
set @pmsname = 'RAJEN'    
set @fdate = '01/01/2001'    
set @tdate = '10/18/2004'    
set @afdate = '04/01/2004'    
set @loca = 'SURAT'    
*/    
    
    
set nocount on  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
select a.*, b.rate into #file1
from rm_fin a (nolock) left outer join     
(  
select * from intranet.risk.dbo.cp   
) b on b.scode=a.scrip_cd     


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
select party_code, scrip_cd, --netqty=sum(pqtydel-sqtydel),    
netqty=sum(case when cf='Y' then pqtydel else 0 end),    
tradpl=sum(pamttrd-samttrd),     
rate=isnull(rate,case when cf='Y' then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end),    
open_position=(case when cf='Y' and sum(pqtydel) > 0 then sum(pamtdel) else 0 end),    
port_stock=sum(case when cf='Y' and sqtydel > 0 then samtdel else 0 end),    
bookpl=sum(case when cf='N'  then pamtdel-samtdel else 0 end),    
tover=sum(pamtdel+samtdel+pamttrd+samttrd),brokerage=sum(pbrokdel+sbrokdel+pbroktrd+sbroktrd)    
into #file2
from #file1 CM,    
(select * from CLIENTMAST (nolock) WHERE PMSCODE=@pmscode and eff_to >= @tdate and location LIKE @loca) CL    
where cl.clientid=cm.party_Code and sauda_date >= cl.eff_from+' 00:00:00.00' and sauda_date <= @tdate+' 23:59:59.000'    
group by party_code, scrip_cd, rate,cf,valid    


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
select scrip_cd,not_pl=sum(case when netqty > 0 then open_position-(netqty*rate) else 0 end),    
open_position=isnull(sum(open_position),0),port_stock=isnull(sum(port_stock),0),    
bookpl=sum(bookpl), tradpl=sum(tradpl),tover=sum(tover),netqty=sum(case when netqty > 0 then netqty else 0 end),    
brokerage=sum(brokerage) 
into #file3
from #file2 tvalan    
group by scrip_cd    


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
select pmscode=@pmscode,pmsname=@pmsname,clientid=scrip_Cd,    
clientname=scrip_name, netqty,    
LEdger=0, open_position=isnull(open_position,0),port_stock=isnull(port_stock,0),    
 bookpl=isnull(bookpl,0),    
tradpl=isnull(tradpl,0), not_pl=isnull(not_pl,0),tover=isnull(tover,0),brokerage=isnull(brokerage,0)    
from #file3 aa (nolock) ,    
(select scrip_name=scrip_cd,bsecode from bse.dbo.BSE_SCRIP2) scp where aa.scrip_Cd=scp.bsecode    
order by scrip_name    
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.pms_scpdetails_c
-- --------------------------------------------------

/*ROLLED BACK*/
CREATE procedure pms_scpdetails_c (@pmscode as varchar(25), @scpcd as varchar(25), @tdate as datetime,@location as varchar(25),@fromrs as money,@tors as money)
as

set nocount on

select
	sett_no,
	sett_type,
	party_code,
	party_name,
	scrip_cd,
	series,
	scrip_name,
	sauda_date,
	/*NEW CONCEPT*/
--	ptrdqty=(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
--	pamttrd=(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end), 
--	sqtytrd=(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
--	samttrd=(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
--	pqtydel=(case when sqOffdate is not null then pqtydel else 0 end),
--	pamtdel=(case when sqOffdate is not null then pamtdel else 0 end),
--	sqtydel=(case when sqOffdate is not null then sqtydel else 0 end),
--	samtdel=(case when sqOffdate is not null then samtdel else 0 end),
	/*END - NEW CONCEPT*/
	pqtytrd,
	pamttrd,
	pqtydel,
	pamtdel,
	sqtytrd,
	samttrd,
	sqtydel,
	samtdel,
	pbroktrd,
	sbroktrd,
	pbrokdel,
	sbrokdel,
	sub_broker,
	branch_cd,
	start_date,
	end_date,
	sqoffdate,
	cf,
	valid
into 
	#temp1 
from rm_fin where cf='Y' and valid='Y' and scrip_cd=@scpcd  and pqtydel > 0 and pamtdel/pqtydel >= @fromrs and pamtdel/pqtydel <= @tors

--select * into #temp1 from rm_fin where cf='Y' and valid='Y' and scrip_cd=@scpcd and pqtydel > 0

select x.* into #temp2 from cpcumm x, 
(select scode, mfdate=max(mfdate) from cpcumm where mfdate <= @tdate group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate 

/*NEW CONCEPT*/
--update #temp1 set 
--	pqtydel=pqtydel+ptrdqty,
--	sqtydel=sqtydel+sqtytrd,
--	pamtdel=pamttrd+pamtdel,
--	samtdel=samttrd+samtdel

--update #temp1 set 
--	ptrdqty=0,
--	sqtytrd=0,
--	samttrd=0,
--	pamttrd=0

/*RATE NOT USED HERE IN THIS QRY*/
--update #temp1 set 
--	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
--where 
--	rate = 0
/*END - NEW CONCEPT*/

select cm.party_code,party_name=cl.clientname,scrip_cd,scrip_name=scripname,
ptrdqty=sum(pqtytrd),
pamttrd=sum(pamttrd), 
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel),
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),
trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel), rate 
from 
(select a.*, b.rate from #temp1  a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
(select * from clientmast where location like @location
and pmscode=@pmscode and eff_to >= @tdate) cl, (select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2) scp 
where scp.bsecode=cm.scrip_cd and cl.clientid=cm.party_code and sauda_Date >= cl.eff_from+' 00:00:00' 
and sauda_date <= @tdate group by cm.party_code,cl.clientname,scrip_cd,scripname,rate 
having sum(pqtydel) > sum(sqtydel) --order by abs(sum(pqtydel)-sum(sqtydel)) desc 
order by party_code
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
-- PROCEDURE dbo.sp_displayopen
-- --------------------------------------------------
CREATE procedure sp_displayopen(@clcode as varchar(10),@fdate as varchar(25),@tdate as varchar(25))        
as        
        
        
--declare @fdate as varchar(11)        
--declare @tdate as varchar(11)        
--select @fdate=eff_from,@tdate=eff_to from clientmast where clientid=@clcode        
--print @tdate        
        
set nocount on        
        
select * into #temp1 from rm_fin where party_code=@clcode and cf='Y' and valid='Y' and pqtydel > 0         
and sauda_Date >= @fdate and sauda_date <= @tdate        
        
select x.* into #temp2 from cpcumm x,         
(select scode, mfdate=max(mfdate) from cpcumm where mfdate <= @tdate group by scode ) y         
where x.scode=y.scode and y.mfdate=x.mfdate         
      
select cm.party_code,scrip_cd,scrip_name=scripname,      
      
ptrdqty=sum(pqtytrd),      
pamttrd=sum(pamttrd),      
sqtytrd=sum(sqtytrd),      
samttrd=sum(samttrd),      
pqtydel=sum(pqtydel),      
pamtdel=sum(pamtdel),      
sqtydel=sum(sqtydel),      
samtdel=sum(samtdel),      
      
/*NEW CONCEPT*/      
--ptrdqty=sum(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),      
--pamttrd=sum(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end),       
--sqtytrd=sum(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),      
--samttrd=sum(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),      
--pqtydel=sum(case when sqOffdate is not null then pqtydel else 0 end),      
--pamtdel=sum(case when sqOffdate is not null then pamtdel else 0 end),       
--sqtydel=sum(case when sqOffdate is not null then sqtydel else 0 end),      
--samtdel=sum(case when sqOffdate is not null then samtdel else 0 end),      
      
trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),      
rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end),mfdate         
INTO #FILE1      
from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm,         
(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2 ) scp where scp.bsecode=cm.scrip_cd         
--(select scripname=scrip,bsecode=scode from intranet.risk.dbo.isin ) scp where scp.bsecode collate Latin1_General_CI_AS =cm.scrip_cd         
group by cm.party_code,scrip_cd,scripname,rate,mfdate having (sum(pqtytrd)+sum(pqtydel))-(sum(sqtytrd)+sum(sqtydel))>0         
--order by abs(sum(pqtydel)-sum(sqtydel)) desc         
order by scripname        
        
   
/*NEW CONCEPT*/      
--update #FILE1 set       
-- pqtydel=pqtydel+ptrdqty,      
-- sqtydel=sqtydel+sqtytrd,      
-- pamtdel=pamttrd+pamtdel,      
-- samtdel=samttrd+samtdel      
      
--update #FILE1 set       
-- ptrdqty=0,      
-- sqtytrd=0,      
-- samttrd=0,      
-- pamttrd=0      
      
--update #FILE1 set       
-- rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)      
--where       
-- rate = 0      
/*END - NEW CONCEPT*/      
      
SELECT A.*,PARTY_NAME=B.CLIENTNAME FROM #FILE1 A, (select * from CLIENTMAST where eff_to >= getdate()) B WHERE A.PARTY_CODE=B.CLIENTID         
order by scrip_name        
        
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_displayopen_bpl
-- --------------------------------------------------

CREATE  procedure sp_displayopen_bpl(@clcode as varchar(10),@fdate as varchar(25),@tdate as varchar(25))
as

set nocount on

--declare @clcode as varchar(25),@fdate as varchar(25),@tdate as varchar(25)
--SELECT @clcode ='DK39',@FDATE='03/04/2005 00:00:00',@TDATE='10/04/2005 23:59:59'

declare @lngDiff bigint
select @lngDiff  = datediff(dd, @fdate, eff_from) from mis.pms1.dbo.clientmast where clientid = @clcode

select * into #temp1
	from mis.pms1.dbo.rm_fin where 1 = 0

if @lngDiff = 0	/*QUERY FIRED FOR BOOKED PNL's FROM PARTY's CONNENCEMENT DATE TILL NOW*/
begin
	insert into #temp1
	select *
	from mis.pms1.dbo.rm_fin where party_code=@clcode and cf='N' and valid='Y' 
	and pqtydel+pqtytrd > 0 
	--and (sqOffdate is not null OR (pqtydel+pqtytrd-Sqtytrd-sqtydel = 0) )
	and sauda_Date >= @fdate and sauda_date <= @tdate
end
else
	/*QUERY FIRED FOR BOOKED PNL's FOR A DATE RANGE*/
begin
	insert into #temp1
	select *
	from mis.pms1.dbo.rm_fin where party_code=@clcode and cf='N' and valid='Y' 
	and pqtydel+pqtytrd > 0 
	--and (sqOffdate is not null OR (pqtydel+pqtytrd-Sqtytrd-sqtydel = 0) )
	and sqoffdate >= @fdate and sqoffdate <= @tdate
end

--SELECT * FROM #temp1

--declare @clcode as varchar(25),@fdate as varchar(25),@tdate as varchar(25)
--SELECT @clcode ='DK39',@FDATE='03/04/2005 00:00:00',@TDATE='09/13/2005 23:59:59'

------------------- OLD concept banned
select x.* into #temp2 from mis.pms1.dbo.cpcumm x, 
(select scode, mfdate=max(mfdate) from mis.pms1.dbo.cpcumm where mfdate <= @tdate group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate 

--SELECT * FROM #temp2

--select party_code,scrip_cd,scrip_name=scripname,
----ptrdqty=sum(pqtytrd),pamttrd=sum(pamttrd), sqtytrd=sum(sqtytrd),samttrd=sum(samttrd),pqtydel=sum(pqtydel),pamtdel=sum(pamtdel), sqtydel=sum(sqtydel),samtdel=sum(samtdel), 
----ptrdqty=sum(pqtytrd),pamttrd=sum(pamttrd), sqtytrd=sum(sqtytrd),samttrd=sum(samttrd),
--ptrdqty=0,pamttrd=0, sqtytrd=0,samttrd=0,

--pqtydel=sum(pqtydel+pqtytrd),pamtdel=sum(pamtdel+pamttrd), 
--sqtydel=sum(sqtydel+sqtytrd),samtdel=sum(samtdel+samttrd), 

--trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),
--rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) 
--INTO #FILE1
--from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
--(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2) scp where scp.bsecode=cm.scrip_cd 
--group by party_code,scrip_cd,scripname,rate,mfdate 
----order by abs(sum(pqtydel)-sum(sqtydel)) desc 
--order by scripname

--------------- NEW concept used
select party_code,scrip_cd,scrip_name=scripname,
--ptrdqty=0,pamttrd=0, sqtytrd=0,samttrd=0,
--pqtydel=sum(pqtydel+pqtytrd),pamtdel=sum(pamtdel+pamttrd), 
--sqtydel=sum(sqtydel+sqtytrd),samtdel=sum(samtdel+samttrd), 
--trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),
--rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end)
--ptrdqty=sum(pqtytrd),pamttrd=sum(pamttrd), sqtytrd=sum(sqtytrd),samttrd=sum(samttrd),
ptrdqty=sum(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
pamttrd=sum(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end), 
sqtytrd=sum(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
samttrd=sum(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
pqtydel=sum(case when sqOffdate is not null then pqtydel else 0 end),
pamtdel=sum(case when sqOffdate is not null then pamtdel else 0 end), 
sqtydel=sum(case when sqOffdate is not null then sqtydel else 0 end),
samtdel=sum(case when sqOffdate is not null then samtdel else 0 end), 
trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),
--rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end)
rate=isnull(rate,convert(money,0))
INTO #FILE1
from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2) scp where scp.bsecode=cm.scrip_cd 
group by party_code,scrip_cd,scripname,rate,mfdate 
order by scripname

update #FILE1 set 
	pqtydel=pqtydel+ptrdqty,
	sqtydel=sqtydel+sqtytrd,
	pamtdel=pamttrd+pamtdel,
	samtdel=samttrd+samtdel

update #FILE1 set 
	ptrdqty=0,
	sqtytrd=0,
	samttrd=0,
	pamttrd=0

update #FILE1 set 
	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
where 
	rate = 0

--------------------------------

SELECT A.*,PARTY_NAME=B.CLIENTNAME FROM #FILE1 A, mis.pms1.dbo.CLIENTMAST B WHERE A.PARTY_CODE=B.CLIENTID 
and (pamtdel - samtdel) + (pamttrd - samttrd) <> 0
order by scrip_name

/*(pamtdel - samtdel) + (pamttrd - samttrd)*/

print '@lngDiff:' + convert(varchar, @lngDiff)

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_displayopen_cli
-- --------------------------------------------------

CREATE procedure sp_displayopen_cli(@clcode as varchar(10),@fdate as varchar(25),@tdate as varchar(25))
as

set nocount on

select
	sett_no,
	sett_type,
	party_code,
	party_name,
	scrip_cd,
	series,
	scrip_name,
	sauda_date,
	/*NEW CONCEPT*/
	ptrdqty=(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
	pamttrd=(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end), 
	sqtytrd=(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
	samttrd=(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
	pqtydel=(case when sqOffdate is not null then pqtydel else 0 end),
	pamtdel=(case when sqOffdate is not null then pamtdel else 0 end),
	sqtydel=(case when sqOffdate is not null then sqtydel else 0 end),
	samtdel=(case when sqOffdate is not null then samtdel else 0 end),
	/*END - NEW CONCEPT*/
	/*
	pqtytrd
	pamttrd
	pqtydel
	pamtdel
	sqtytrd
	samttrd
	sqtydel
	samtdel
	*/
	pbroktrd,
	sbroktrd,
	pbrokdel,
	sbrokdel,
	sub_broker,
	branch_cd,
	start_date,
	end_date,
	sqoffdate,
	cf,
	valid
into 
	#temp1
from rm_fin where party_code=@clcode and valid='Y' and pqtydel > 0
and sauda_Date >= @fdate and sauda_date <= @tdate

select x.* into #temp2 from cpcumm x,
(select scode, mfdate=max(mfdate) from cpcumm where mfdate <= @tdate group by scode ) y
where x.scode=y.scode and y.mfdate=x.mfdate

/*NEW CONCEPT*/
update #temp1 set
	pqtydel=pqtydel+ptrdqty,
	sqtydel=sqtydel+sqtytrd,
	pamtdel=pamttrd+pamtdel,
	samtdel=samttrd+samtdel

update #temp1 set 
	ptrdqty=0,
	sqtytrd=0,
	samttrd=0,
	pamttrd=0

update #temp1 set 
	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
where
	rate = 0
/*END - NEW CONCEPT*/

select party_code,party_name,scrip_cd,scrip_name=scripname,
ptrdqty=sum(pqtytrd),
pamttrd=sum(pamttrd),
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel),
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),
trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),
rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) 
from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2) scp where scp.bsecode=cm.scrip_cd 
group by party_code,party_name,scrip_cd,scripname,rate,mfdate 
--order by abs(sum(pqtydel)-sum(sqtydel)) desc 
order by scripname

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_displaypstock
-- --------------------------------------------------

/*ROLLED BACK*/
CREATE  procedure sp_displaypstock(@clcode as varchar(10),@fdate as varchar(25),@tdate as varchar(25))
as

--declare @fdate as varchar(11)
--declare @tdate as varchar(11)
--select @fdate=eff_from,@tdate=eff_to from clientmast where clientid=@clcode
--print @tdate

set nocount on

select * into #temp1 
from rm_fin where party_code=@clcode and cf='Y' and valid='Y' and pqtydel-sqtydel < 0
and sauda_Date >= @fdate and sauda_date <= @tdate

select x.* into #temp2 from cpcumm x, 
(select scode, mfdate=max(mfdate) from cpcumm where mfdate <= @tdate group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate 

select cm.party_code,scrip_cd,scrip_name=scripname,

ptrdqty=sum(pqtytrd),
pamttrd=sum(pamttrd),
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel),
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),
/*NEW CONCEPT*/
--ptrdqty=sum(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
--pamttrd=sum(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end),
--sqtytrd=sum(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
--samttrd=sum(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
--pqtydel=sum(case when sqOffdate is not null then pqtydel else 0 end),
--pamtdel=sum(case when sqOffdate is not null then pamtdel else 0 end),
--sqtydel=sum(case when sqOffdate is not null then sqtydel else 0 end),
--samtdel=sum(case when sqOffdate is not null then samtdel else 0 end),

trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel), 
Srate=(case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end),RATE,mfdate 
INTO #FILE1 from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2 ) scp where scp.bsecode=cm.scrip_cd 
group by cm.party_code,scrip_cd,scripname,RATE,mfdate 
--having (sum(pqtytrd)+sum(pqtydel))-(sum(sqtytrd)+sum(sqtydel))>0 
--order by abs(sum(pqtydel)-sum(sqtydel)) desc 
order by scripname

/*NEW CONCEPT*/
--update #FILE1 set
--	pqtydel=pqtydel+ptrdqty,
--	sqtydel=sqtydel+sqtytrd,
--	pamtdel=pamttrd+pamtdel,
--	samtdel=samttrd+samtdel

--update #FILE1 set 
--	ptrdqty=0,
--	sqtytrd=0,
--	samttrd=0,
--	pamttrd=0

--update #FILE1 set 
--	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
--where
--	rate = 0
/*END - NEW CONCEPT*/

SELECT A.*,PARTY_NAME=B.CLIENTNAME FROM #FILE1 A, CLIENTMAST B WHERE A.PARTY_CODE=B.CLIENTID 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_sdisplayopen_bpl
-- --------------------------------------------------


/*ROLLED BACK*/
CREATE  procedure sp_sdisplayopen_bpl(@clcode as varchar(10),@fdate as varchar(25),@tdate as varchar(25),@location as varchar(25))
as

set nocount on
/*
declare @clcode as varchar(25)
declare @fdate as varchar(25)
declare @tdate as varchar(25)
set @clcode = '500260'
set @tdate='06/24/2005'
*/

select
	sett_no,
	sett_type,
	party_code,
	party_name,
	scrip_cd,
	series,
	scrip_name,
	sauda_date,
	/*NEW CONCEPT*/
--	ptrdqty=(case when pqtytrd-sqtytrd=0 then pqtytrd else 0 end),
--	pamttrd=(case when pqtytrd-sqtytrd=0 then pamttrd else 0 end), 
--	sqtytrd=(case when pqtytrd-sqtytrd=0 then sqtytrd else 0 end),
--	samttrd=(case when pqtytrd-sqtytrd=0 then samttrd else 0 end),
--	pqtydel=(case when sqOffdate is not null then pqtydel else 0 end),
--	pamtdel=(case when sqOffdate is not null then pamtdel else 0 end),
--	sqtydel=(case when sqOffdate is not null then sqtydel else 0 end),
--	samtdel=(case when sqOffdate is not null then samtdel else 0 end),
	/*END - NEW CONCEPT*/

	pqtytrd,
	pamttrd,
	pqtydel,
	pamtdel,
	sqtytrd,
	samttrd,
	sqtydel,
	samtdel,

	pbroktrd,
	sbroktrd,
	pbrokdel,
	sbrokdel,
	sub_broker,
	branch_cd,
	start_date,
	end_date,
	sqoffdate,
	cf,
	valid
into
	#temp1 
from rm_fin where scrip_cd=@clcode and cf='N' and valid='Y' and pqtydel > 0 
and party_code in (select clientid from clientmast where location like @location )
--and sauda_Date >= @fdate 
and sauda_date <= @tdate


select x.* into #temp2 from cpcumm x, 
(select scode, mfdate=max(mfdate) from cpcumm where mfdate <= @tdate group by scode ) y 
where x.scode=y.scode and y.mfdate=x.mfdate 

/*NEW CONCEPT*/
--update #temp1 set
--	pqtydel=pqtydel+ptrdqty,
--	sqtydel=sqtydel+sqtytrd,
--	pamtdel=pamttrd+pamtdel,
--	samtdel=samttrd+samtdel

--update #temp1 set 
--	ptrdqty=0,
--	sqtytrd=0,
--	samttrd=0,
--	pamttrd=0

--update #temp1 set 
--	rate=(case when (pqtydel-sqtydel) <> 0 then (pamtdel-samtdel)/(pqtydel-sqtydel) else 0 end)
--where
--	rate = 0
/*END - NEW CONCEPT*/

select party_code,party_name,scrip_cd,scrip_name=scripname,
ptrdqty=sum(pqtytrd),
pamttrd=sum(pamttrd),
sqtytrd=sum(sqtytrd),
samttrd=sum(samttrd),
pqtydel=sum(pqtydel),
pamtdel=sum(pamtdel),
sqtydel=sum(sqtydel),
samtdel=sum(samtdel),
trdbrok=sum(pbroktrd+sbroktrd), delbrok=sum(pbrokdel+sbrokdel),
rate=isnull(rate,case when sum(pqtydel-sqtydel) <> 0 then sum(pamtdel-samtdel)/sum(pqtydel-sqtydel) else 0 end) 
from (select a.*, b.rate,b.mfdate from #temp1 a left outer join #temp2  b on b.scode=a.scrip_cd ) cm, 
(select scripname=scrip_cd,bsecode from anand.bsedb_ab.dbo.scrip2) scp where scp.bsecode=cm.scrip_cd 
group by party_code,party_name,scrip_cd,scripname,rate,mfdate 
order by party_code
--order by abs(sum(pqtydel)-sum(sqtydel)) desc 

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_term_chkdate
-- --------------------------------------------------

CREATE
proc
	sp_term_chkdate
	(

		@exchange varchar(3),
		@segment varchar(5),
		@terminal_id varchar(10),
		@mode varchar(10),
		@from_date datetime,
		@to_date datetime	/*this is not used now*/
	)

as
	/*PROC RETURNS 1 IF @dtDateToCheck IS A PAST DATE, 0 ELSE*/

	/*CHK FOR A ACTIVE ENTRY WITH THE from_date < THE ENTERED FromDate */
	select 
		datediff(d, from_date, @from_date)
	from
		term_map_mst
	where
		exchange=@exchange and
		segment=@segment and
		terminal_id=@terminal_id and
		to_date = 'dec 31 2049 23:59:00'

--	if (DATEDIFF (d, @from_date, getdate())) > 0 
--		select 1	/*YES, @dtDateToCheck IS A PAST DATE*/
--	else
--		select 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_term_map_insert
-- --------------------------------------------------

CREATE
proc
	sp_term_map_insert
	(
		@exchange varchar(3),
		@segment varchar(5),
		@terminal_id varchar(10),
		@mode varchar(10),
		@from_date datetime,
		@to_date datetime	/*this is not used now*/
	)
as

	declare @intCheckRowCount tinyint

	select top 1 exchange from
		term_map_mst
	where
		exchange=@exchange and
		segment=@segment and
		terminal_id=@terminal_id and
		to_date = 'dec 31 2049 23:59:00'

	set @intCheckRowCount = @@ROWCOUNT

	begin tran
	if @intCheckRowCount > 0
	begin
		update
			term_map_mst
		set
			to_date = dateadd(s, -1, (@from_date + '00:00:00'))
		where
			exchange=@exchange and
			segment=@segment and
			terminal_id=@terminal_id and
			to_date = 'dec 31 2049 23:59:00'
	end		/*if @@ROWCOUNT > 0*/
	
	insert into 
		term_map_mst
	values
	(
		@exchange,
		@segment,	
		@terminal_id,
		@mode,
		@from_date + '00:00:00',
		'dec 31 2049 23:59:00'
	)
	commit tran

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_fifo
-- --------------------------------------------------
CREATE procedure upd_fifo(@mdate as varchar(11))  
as  
  
begin transaction  
  
set nocount on  
  
--declare @mdate as varchar(11)  
--set @mdate = 'Mar 03 2005'  
  
delete from rmbillvalan  
  
  
insert into rmbillvalan select * from rm_fin where cf = 'Y' and valid='Y' --and party_code='AY94' --and scrip_Cd='500780'   
  
insert into rmbillvalan (Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date)  
select Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date   
from anand.bsedb_Ab.dbo.cmbillvalan a,  
(select * from clientmast where eff_from <= @mdate+' 00:00:00' and eff_to >= @mdate+' 23:59:59') b  
where a.party_code=b.clientid and sauda_date >=@mdate+' 00:00:00' and sauda_date <=@mdate+' 23:59:59'  
and (pqtydel+sqtydel) > 0 and tradetype not like '__F' --and party_code='AY94' --and scrip_Cd='500780'   
order by party_Code,scrip_cd,sauda_Date  
  
delete from rm_temp  
  
set nocount off  
  
commit transaction

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_fifo_cli
-- --------------------------------------------------
CREATE  procedure upd_fifo_cli(@clcd as varchar(10))    
as    
    
begin transaction    
    
set nocount on    
    
--declare @mdate as varchar(11)    
--set @mdate = 'Mar 03 2005'    
    
delete from rmbillvalan    
    
--insert into rmbillvalan select * from rm_fin where cf = 'Y' and valid='Y' --and party_code='AY94' --and scrip_Cd='500780'     
    
insert into rmbillvalan (Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date)    
select Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,
PQtyTrd=SUM(PQtyTrd),PAmtTrd=SUM(PAmtTrd),PQtyDel=SUM(PQtyDel),PAmtDel=SUM(PAmtDel),
SQtyTrd=SUM(SQtyTrd),SAmtTrd=SUM(SAmtTrd),SQtyDel=SUM(SQtyDel),SAmtDel=SUM(SAmtDel),
PBrokTrd=SUM(PBrokTrd),SBrokTrd=SUM(SBrokTrd),PBrokDel=SUM(PBrokDel),SBrokDel=SUM(SBrokDel),
Sub_Broker,Branch_cd,Start_Date,End_Date
from anand.bsedb_Ab.dbo.cmbillvalan a, (select * from clientmast where clientid=@clcd ) b    
where a.party_code=b.clientid and sauda_date >= b.eff_from and sauda_date <=b.eff_to    
and (pqtydel+sqtydel) > 0 and tradetype not like '__F'  --and party_code='AY94' --and scrip_Cd='500780'     
GROUP BY Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,Sub_Broker,Branch_cd,Start_Date,End_Date
order by party_Code,scrip_cd,sauda_Date    

TRUNCATE TABLE rm_temp    
    
set nocount off    
    
commit transaction

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_fifo_last
-- --------------------------------------------------
CREATE procedure upd_fifo_last(@mdate as varchar(11))
as

begin transaction
set nocount on

insert into rm_temp select 
Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,SqOffDate,CF,valid
from rmbillvalan where valid = 'Y' --and pqtydel > 0

insert into rm_temp(Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,cf,valid)
select Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel=0,PAmtDel=0,SQtyTrd,SAmtTrd,SQtyDel=0,SAmtDel=0,PBrokTrd,SBrokTrd,PBrokDel=0,SBrokDel=0,Sub_Broker,Branch_cd,Start_Date,End_Date,'N','Y'
from anand.bsedb_Ab.dbo.cmbillvalan a,
(select * from clientmast where eff_from <= @mdate+' 00:00:00' and eff_to >= @mdate+' 23:59:59') b
where a.party_code=b.clientid and sauda_date >=@mdate+' 00:00:00' and sauda_date <=@mdate+' 23:59:59'
and (pqtytrd+sqtytrd) > 0  --and party_code='AY94' --and scrip_Cd='500780' 
order by party_Code,scrip_cd,sauda_Date

delete from rm_fin where cf = 'Y' and valid='Y'

insert into rm_fin select* from rm_temp

set nocount off

commit transaction

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_fifocli_last
-- --------------------------------------------------
CREATE procedure upd_fifocli_last(@clcd as varchar(10))
as

begin transaction
set nocount on

insert into rm_temp select 
Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,SqOffDate,CF,valid
from rmbillvalan where valid = 'Y' --and pqtydel > 0

insert into rm_temp(Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,cf,valid)
select Sett_No,Sett_Type,Party_Code,Party_Name,Scrip_Cd,Series,Scrip_Name,Sauda_Date,PQtyTrd,PAmtTrd,PQtyDel,PAmtDel,SQtyTrd,SAmtTrd,SQtyDel,SAmtDel,PBrokTrd,SBrokTrd,PBrokDel,SBrokDel,Sub_Broker,Branch_cd,Start_Date,End_Date,'N','Y'
from anand.bsedb_Ab.dbo.cmbillvalan a,
(select * from clientmast where clientid=@clcd ) b
where a.party_code=b.clientid and sauda_date >= b.eff_from and sauda_date <=b.eff_to
and (pqtytrd+sqtytrd) > 0  and tradetype not like '__F'  --and party_code='AY94' --and scrip_Cd='500780' 
order by party_Code,scrip_cd,sauda_Date

delete from rm_fin where party_code = @clcd

insert into rm_fin select* from rm_temp

set nocount off

commit transaction

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
-- TABLE dbo.bbb
-- --------------------------------------------------
CREATE TABLE [dbo].[bbb]
(
    [pmscode] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(50) NULL,
    [eff_from] DATETIME NULL,
    [eff_to] DATETIME NULL,
    [company] VARCHAR(10) NULL,
    [location] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clientmast
-- --------------------------------------------------
CREATE TABLE [dbo].[clientmast]
(
    [pmscode] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(50) NULL,
    [eff_from] DATETIME NULL,
    [eff_to] DATETIME NULL,
    [company] VARCHAR(10) NULL,
    [location] VARCHAR(25) NULL,
    [email] VARCHAR(50) NULL,
    [limit] MONEY NULL,
    [termid] VARCHAR(10) NULL,
    [add_pnl_2_limit] CHAR(1) NOT NULL,
    [add_dividend_2_limit] CHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cpcumm
-- --------------------------------------------------
CREATE TABLE [dbo].[cpcumm]
(
    [scode] VARCHAR(10) NULL,
    [rate] MONEY NULL,
    [fname] VARCHAR(12) NULL,
    [mfdate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pms_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_Data]
(
    [Rep_date] DATETIME NULL,
    [pmsname] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(100) NULL,
    [limit] MONEY NULL,
    [location] VARCHAR(25) NULL,
    [eff_from] DATETIME NULL,
    [LEdger] MONEY NULL,
    [open_position] MONEY NULL,
    [port_stock] MONEY NULL,
    [bookpl] MONEY NULL,
    [tradpl] MONEY NULL,
    [not_pl] MONEY NULL,
    [tover] MONEY NULL,
    [brokerage] MONEY NULL,
    [dividend] MONEY NULL,
    [limit_with_profit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pms_Data_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_Data_hist]
(
    [Rep_date] DATETIME NULL,
    [pmsname] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(100) NULL,
    [limit] MONEY NULL,
    [location] VARCHAR(25) NULL,
    [eff_from] DATETIME NULL,
    [LEdger] MONEY NULL,
    [open_position] MONEY NULL,
    [port_stock] MONEY NULL,
    [bookpl] MONEY NULL,
    [tradpl] MONEY NULL,
    [not_pl] MONEY NULL,
    [tover] MONEY NULL,
    [brokerage] MONEY NULL,
    [dividend] MONEY NULL,
    [limit_with_profit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pms_data_test
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_data_test]
(
    [Rep_date] DATETIME NULL,
    [pmsname] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(100) NULL,
    [limit] MONEY NULL,
    [location] VARCHAR(25) NULL,
    [eff_from] DATETIME NULL,
    [LEdger] MONEY NULL,
    [open_position] MONEY NULL,
    [port_stock] MONEY NULL,
    [bookpl] MONEY NULL,
    [tradpl] MONEY NULL,
    [not_pl] MONEY NULL,
    [tover] MONEY NULL,
    [brokerage] MONEY NULL,
    [dividend] MONEY NULL,
    [limit_with_profit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pms_manager
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_manager]
(
    [pmscode] VARCHAR(15) NULL,
    [pmsname] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pms_user
-- --------------------------------------------------
CREATE TABLE [dbo].[pms_user]
(
    [fldauto] INT IDENTITY(1,1) NOT NULL,
    [fldpartycode] VARCHAR(40) NOT NULL,
    [fldpassword] VARCHAR(40) NOT NULL,
    [fldpasscheck] VARCHAR(40) NULL,
    [fldfavshare] VARCHAR(40) NULL,
    [fldfirstname] VARCHAR(50) NULL,
    [fldmidname] VARCHAR(40) NULL,
    [fldlastname] VARCHAR(40) NULL,
    [fldemail] VARCHAR(30) NULL,
    [fldbdate] VARCHAR(10) NULL,
    [fldgender] VARCHAR(7) NULL,
    [fldzip] VARCHAR(10) NULL,
    [fldcountry] VARCHAR(30) NULL,
    [fldstate] VARCHAR(20) NULL,
    [fldcity] VARCHAR(30) NULL,
    [fldaddress] VARCHAR(150) NULL,
    [fldphone1] VARCHAR(15) NULL,
    [fldphone2] VARCHAR(15) NULL,
    [abl_upd] DATETIME NULL,
    [acdl_upd] DATETIME NULL,
    [fo_upd] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rerurns_calc
-- --------------------------------------------------
CREATE TABLE [dbo].[rerurns_calc]
(
    [row_id] BIGINT IDENTITY(1,1) NOT NULL,
    [sett_flag] INT NOT NULL,
    [sq_rate] MONEY NOT NULL,
    [cl_rate] MONEY NOT NULL,
    [sett_no] VARCHAR(7) NULL,
    [sett_type] VARCHAR(3) NULL,
    [billno] VARCHAR(10) NULL,
    [contractno] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [party_name] VARCHAR(50) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [isin] VARCHAR(12) NULL,
    [sauda_date] DATETIME NULL,
    [pqtytrd] INT NULL,
    [pamttrd] MONEY NULL,
    [pqtydel] INT NULL,
    [pamtdel] MONEY NULL,
    [sqtytrd] INT NULL,
    [samttrd] MONEY NULL,
    [sqtydel] INT NULL,
    [samtdel] MONEY NULL,
    [pbroktrd] MONEY NULL,
    [sbroktrd] MONEY NULL,
    [pbrokdel] MONEY NULL,
    [sbrokdel] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [family_name] VARCHAR(50) NULL,
    [terminal_id] VARCHAR(10) NULL,
    [clienttype] VARCHAR(10) NULL,
    [tradetype] VARCHAR(3) NULL,
    [trader] VARCHAR(20) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [participantcode] VARCHAR(15) NULL,
    [pamt] MONEY NULL,
    [samt] MONEY NULL,
    [prate] MONEY NULL,
    [srate] MONEY NULL,
    [trdamt] MONEY NULL,
    [delamt] MONEY NULL,
    [serinex] SMALLINT NULL,
    [service_tax] MONEY NULL,
    [exservice_tax] MONEY NULL,
    [turn_tax] MONEY NULL,
    [sebi_tax] MONEY NULL,
    [ins_chrg] MONEY NULL,
    [broker_chrg] MONEY NULL,
    [other_chrg] MONEY NULL,
    [region] VARCHAR(10) NULL,
    [start_date] VARCHAR(11) NULL,
    [end_date] VARCHAR(11) NULL,
    [update_date] VARCHAR(11) NULL,
    [status_name] VARCHAR(15) NULL,
    [exchange] VARCHAR(5) NULL,
    [segment] VARCHAR(10) NULL,
    [membertype] VARCHAR(6) NULL,
    [companyname] VARCHAR(100) NULL,
    [dummy1] VARCHAR(1) NULL,
    [dummy2] VARCHAR(1) NULL,
    [dummy3] VARCHAR(1) NULL,
    [dummy4] MONEY NULL,
    [dummy5] MONEY NULL,
    [area] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rm_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[rm_fin]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] CHAR(1) NULL,
    [valid] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rm_fin_all
-- --------------------------------------------------
CREATE TABLE [dbo].[rm_fin_all]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] CHAR(1) NULL,
    [valid] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rm_fin_full
-- --------------------------------------------------
CREATE TABLE [dbo].[rm_fin_full]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] CHAR(1) NULL,
    [valid] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rm_fin1
-- --------------------------------------------------
CREATE TABLE [dbo].[rm_fin1]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] CHAR(1) NULL,
    [valid] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rm_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[rm_temp]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] CHAR(1) NULL,
    [valid] CHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rmbillvalan
-- --------------------------------------------------
CREATE TABLE [dbo].[rmbillvalan]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] VARCHAR(1) NULL DEFAULT 'Y',
    [valid] VARCHAR(1) NULL DEFAULT 'Y',
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rmbillvalan_full
-- --------------------------------------------------
CREATE TABLE [dbo].[rmbillvalan_full]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] VARCHAR(1) NULL,
    [valid] VARCHAR(1) NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] VARCHAR(1) NULL,
    [valid] VARCHAR(1) NULL,
    [srno] INT NOT NULL,
    [pmscode] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(50) NULL,
    [eff_from] DATETIME NULL,
    [eff_to] DATETIME NULL,
    [company] VARCHAR(10) NULL,
    [location] VARCHAR(25) NULL,
    [email] VARCHAR(50) NULL,
    [limit] MONEY NULL,
    [termid] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.term_map_mst
-- --------------------------------------------------
CREATE TABLE [dbo].[term_map_mst]
(
    [exchange] VARCHAR(3) NOT NULL,
    [segment] VARCHAR(5) NOT NULL,
    [terminal_id] VARCHAR(10) NOT NULL,
    [mode] VARCHAR(10) NOT NULL,
    [from_date] DATETIME NOT NULL,
    [to_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test_pms
-- --------------------------------------------------
CREATE TABLE [dbo].[test_pms]
(
    [Rep_date] DATETIME NULL,
    [pmsname] VARCHAR(15) NULL,
    [clientid] VARCHAR(10) NULL,
    [clientname] VARCHAR(100) NULL,
    [limit] MONEY NULL,
    [location] VARCHAR(25) NULL,
    [eff_from] DATETIME NULL,
    [LEdger] MONEY NULL,
    [open_position] MONEY NULL,
    [port_stock] MONEY NULL,
    [bookpl] MONEY NULL,
    [tradpl] MONEY NULL,
    [not_pl] MONEY NULL,
    [tover] MONEY NULL,
    [brokerage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tmbillvalan
-- --------------------------------------------------
CREATE TABLE [dbo].[tmbillvalan]
(
    [Sett_No] VARCHAR(7) NULL,
    [Sett_Type] VARCHAR(3) NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Party_Name] VARCHAR(100) NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Scrip_Name] VARCHAR(50) NULL,
    [Sauda_Date] DATETIME NULL,
    [PQtyTrd] INT NULL,
    [PAmtTrd] MONEY NULL,
    [PQtyDel] INT NULL,
    [PAmtDel] MONEY NULL,
    [SQtyTrd] INT NULL,
    [SAmtTrd] MONEY NULL,
    [SQtyDel] INT NULL,
    [SAmtDel] MONEY NULL,
    [PBrokTrd] MONEY NULL,
    [SBrokTrd] MONEY NULL,
    [PBrokDel] MONEY NULL,
    [SBrokDel] MONEY NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Start_Date] VARCHAR(11) NULL,
    [End_Date] VARCHAR(11) NULL,
    [SqOffDate] DATETIME NULL,
    [CF] VARCHAR(1) NULL,
    [valid] VARCHAR(1) NULL,
    [srno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.userid
-- --------------------------------------------------
CREATE TABLE [dbo].[userid]
(
    [pmscode] VARCHAR(15) NULL,
    [userid] VARCHAR(10) NULL
);

GO

