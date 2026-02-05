-- DDL Export
-- Server: 10.253.33.232
-- Database: ANGELINHOUSE
-- Exported: 2026-02-05T12:29:19.338284

USE ANGELINHOUSE;
GO

-- --------------------------------------------------
-- FUNCTION dbo.AngelBSeshortage
-- --------------------------------------------------
CREATE Function AngelBSeshortage (@Fromsett_no Varchar(10),@Tosett_no Varchar(10))
Returns Table
as
Return
Select Top 10 ExchangeSegment = 'BSECM', D.sett_no,D.sett_type, Branch_cd =  '', Sub_broker =  '',d.party_code, d.Scrip_cd,d.Series,d.inout,d.Qty,Scripname=s2.scrip_cd,IsIn = Mi.Isin,
	RecQty = Case When d.Sett_Type = 'C' And InOut = 'O' Then 0 Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End,
	GivenQty = Case When d.Sett_Type = 'C' And InOut = 'I' Then Sum((Case When DrCr = 'D' And Reason Like 'EXC%' Then IsNull(De.Qty,0) Else 0 End)) Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) end  ,Rate = 0 /*H.rate*/ ,ReportDate = GetDate()
	From Bsedb.dbo.Scrip2 S2,  BseDb.Dbo.MultiIsiN MI,
             BseDb.Dbo.Deliveryclt D Left Outer Join Bsedb.dbo.DelTrans De
	On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD
	And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series and filler2 = 1 
             And ShareType Not Like (case when d.sett_type not in ('A','X','AD','AC') then  'AUCTION' else '' End))
             Where  S2.bsecode = D.scrip_cd  
             And d.sett_no between @fromsett_no And @ToSett_no  and d.sett_type In ('C','D') 
             And Mi.Scrip_Cd = D.Scrip_cd
             And Mi.Series = D.Series
             And Mi.Valid = 1
             Group by d.sett_no,d.sett_type,d.scrip_cd,d.series, d.party_code,d.inout,s2.scrip_cd,D.Qty ,Mi.IsIn

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
-- FUNCTION dbo.Fn_PayinshortagePart1
-- --------------------------------------------------
Create Function [dbo].[Fn_PayinshortagePart1] (@FromSett_no Varchar(10),@Tosett_no Varchar(10))
Returns Table
As
Return
(
 Select ExchangeSegment = 'BSECM', D.sett_no,D.sett_type, Branch_cd =  '', Sub_broker =  '',d.party_code, d.Scrip_cd,d.Series,d.inout,d.Qty,Scripname=s2.scrip_cd,IsIn = Mi.Isin,    
 RecQty = Case When d.Sett_Type = 'C' And InOut = 'O' Then 0 Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End,    
 GivenQty = Case When d.Sett_Type = 'C' And InOut = 'I' Then Sum((Case When DrCr = 'D' And Reason Like 'EXC%' Then IsNull(De.Qty,0) Else 0 End)) Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) end  ,Rate = 0 /*H.rate*/ ,ReportDate = GetDate()    
 From AngelDemat.Bsedb.Dbo.Scrip2 S2,  AngelDemat.Bsedb.Dbo.MultiIsiN MI,    
             AngelDemat.Bsedb.Dbo.Deliveryclt D Left Outer Join AngelDemat.Bsedb.Dbo.DelTrans De    
 On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD    
 And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series and filler2 = 1     
             And ShareType Not Like (case when d.sett_type not in ('A','X','AD','AC') then  'AUCTION' else '' End))    
             Where  S2.bsecode = D.scrip_cd      
             And d.sett_no between @FromSett_no And @ToSett_no  and d.sett_type In ('C','D')     
             And Mi.Scrip_Cd = D.Scrip_cd    
             And Mi.Series = D.Series    
             And Mi.Valid = 1    
             Group by d.sett_no,d.sett_type,d.scrip_cd,d.series, d.party_code,d.inout,s2.scrip_cd,D.Qty ,Mi.IsIn  
)

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_NewPledge_Calc
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_con] ON [dbo].[tbl_NewPledge_Calc] ([P_R], [Condition])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_NewPledge_Calc
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_Condtion] ON [dbo].[tbl_NewPledge_Calc] ([Condition], [P_R])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_NSECertificate
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_nsecert] ON [dbo].[tbl_NSECertificate] ([Fld_RptDate])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_NSECertificate
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [tx_dt] ON [dbo].[tbl_NSECertificate] ([Fld_RptDate])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_Pledge_Data
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_p] ON [dbo].[tbl_Pledge_Data] ([BcltDpId], [P_R], [Condition])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_Pledge_Data
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_partycode] ON [dbo].[tbl_Pledge_Data] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_PledgeHist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_dt] ON [dbo].[tbl_PledgeHist] ([Fld_DTTime], [Fld_Segment])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_PledgeHist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_dt1] ON [dbo].[tbl_PledgeHist] ([Fld_Segment], [Fld_DTTime])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_PledgeHist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_Pld] ON [dbo].[tbl_PledgeHist] ([Fld_Segment], [Fld_DTTime], [Fld_CertNo])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagrams__286302EC] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_Contract_Bill
-- --------------------------------------------------
CREATE Proc [dbo].[Angel_Contract_Bill](@fdate as varchar(11))  
as  
  
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))  
  
delete tbl_contract_bill where Upd_date = @fdate and segment = 'BSECM'  
delete tbl_contract_bill where Upd_date = @fdate and segment = 'NSECM'  
  
insert into tbl_contract_bill  
Exec anand1.msajag.dbo.Angel_Contract_Bill @fdate  
  
insert into tbl_contract_bill   
Exec ANGELBSECM.bsedb_ab.dbo.Angel_Contract_Bill @fdate  

insert into tbl_contract_bill   
Exec angelfo.fosettlement.dbo.Angel_Contract_Bill @fdate  
  
update tbl_contract_bill set Branch_cd = b.branch_cd,sub_broker = b.sub_broker  
from tbl_contract_bill a inner join anand1.msajag.dbo.client_details b on a.party_code = b.cl_code   
and a.branch_cd = ''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_Fetch_Holding
-- --------------------------------------------------
CREATE Proc Angel_Fetch_Holding                  
as                                  
                  
--------------------Truncate Tables for Fetching Fresh Data------                  
truncate table tbl_payout_Marking       
truncate table Angel_Holding           
                      
---------------------Fetching Fresh Data------------------                  
insert into tbl_Payout_Marking   
select SNo,Sett_No,sett_type,trtype,Party_Code,Scrip_cd,b.scrip,Series,CertNo,DpType,DPId,cltDPId,                      
Qty,bdptype,bdpid,bcltdpid,'BSE' as Segment,'','' from bsedb.dbo.DelTrans a                        
left outer join bsedb.dbo.View_Bse_Scrip b   on a.scrip_cd = b.bsecode                      
where Filler2 = 1 and drcr = 'D' and delivered= '0' and trtype in (904,909)                      
and BcltDpid in ('10003588','1203320000006564','16921197','1203320000000066') /*and  party_code = 'M11477' */   
union all     
select SNo,Sett_No,sett_type,trtype,Party_Code,Scrip_cd,Scrip_cd,Series,CertNo,DpType,DPId,  
cltDPId,Qty,bdptype,bdpid,bcltdpid,'NSE','',''  from Msajag.dbo.DelTrans                       
where Filler2 = 1 and drcr = 'D' and delivered= '0' and trtype in (904,909)                      
and bcltdpid in ('10184021','1203320000000051','1203320000002291','10190593') /*and  party_code = 'M11477' */

/*
insert into Angel_Holding
select x.party_code,holding,Led_Bal,HoldingValue
--case when holding < 0 then holding-Led_Bal-HoldingValue else Led_Balend
  from
(
select party_code,HoldingValue=sum(bseValue) from
(
select party_code,bseValue=sum(Qty*rate) from
(select * from tbl_payout_Marking where Segment = 'BSE')a
left outer join
(select * from intranet.risk.dbo.cp)b
on a.scrip_cd = b.scode group by party_code
union all
select party_code,nseValue=sum(Qty*cls) from
(select * from tbl_payout_Marking where Segment = 'NSE' and series in ('BE','EQ'))a
left outer join
(select * from intranet.risk.dbo.md )b
on a.scrip_cd = b.scrip  group by party_code
)x  group by party_code
)x
left outer join
(
select party_code,(ABL+ACDL+NBFC+FO+NCDX+MCDX+MCD+NSX) as Led_Bal,holding
from intranet.risk.dbo.collection_client_details where ABL+ACDL+NBFC+FO+NCDX+MCDX+MCD+NSX < 0 
and holding >= 0
)y on x.party_code = y.party_code
*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_NSEPldgCertificate
-- --------------------------------------------------

CREATE Proc [dbo].[Angel_NSEPldgCertificate]                                      
as                            
                     
--declare @Segment as varchar(5)                            
declare @RptDate as varchar(11)                           
declare @ClosingDate as varchar(11)                      
declare @First_day as varchar(11)                                                              
declare @Second_day as varchar(11)                                                              
declare @Third_day as varchar(11)                     
declare @sdate as varchar(11)                            
declare @TotalValue as money          
declare @NSEValue as money                                      
                            
--set @Segment = 'NSE'                            
              
set @RptDate = convert(varchar(11),getdate(),103)                  
  
              
set @RptDate = convert(datetime,@RptDate,103)                                                              
set @Third_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date = @RptDate and sett_type = 'D')                                                              
set @Second_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date < convert(datetime,@Third_day,103) and sett_type = 'D')                                                              
set @First_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date < convert(datetime,@Second_day,103) and sett_type = 'D')                                                                                        
set @sdate = (select sdtCur from Anand1.ACCOUNT.DBO.parameter where ldtcur >= @RptDate and sdtcur <= @RptDate)                            
set @ClosingDate = convert(datetime,@Second_day,103)                 
print  @RptDate              
                  
/*                  
print @Third_day                            
print @Second_day                            
print @First_day                            
print @sdate                  
print @RptDate                  
print @ClosingDate*/                  
                  
-----------------------------------------------Dump Deltrans data-----------------                  
      

insert into tbl_PledgeHist                  
select Sett_type,Sett_No,party_code,scrip_cd,series,Qty,CertNo,BcltDpId,'BSE',convert(datetime,convert(varchar(11),getdate())) from angeldemat.bsedb.dbo.deltrans                   
where drcr = 'D' and delivered = '0' and trtype = 909                  
                  
insert into tbl_PledgeHist                  
select Sett_type,Sett_No,party_code,scrip_cd,series,Qty,CertNo,BcltDpId,'NSE',convert(datetime,convert(varchar(11),getdate())) from angeldemat.msajag.dbo.deltrans                   
where drcr = 'D' and delivered = '0' and trtype = 909            

                          
----------------------Total Value                            
select Fld_Party_code,Fld_CertNo,Fld_Segment,sum(Fld_Qty) Qty into #SegmentData from                
tbl_PledgeHist (nolock) where Fld_DtTime = @RptDate group by Fld_Party_code,Fld_CertNo,Fld_Segment              
              
select * into #ClsRate from intranet.risk.dbo.V_Hist_ClosingRate where MFDATE = @ClosingDate              
              
select sum(Qty*bserate) as BsePledge  into #bseP from               
(select * from #SegmentData where Fld_Segment = 'BSE') x              
inner join              
(select * from #ClsRate)y on x.Fld_CertNo = y.Isin              
              
select sum(Qty*nserate) as NsePledge  into #NseP from               
(select * from #SegmentData where Fld_Segment = 'NSE') x              
inner join              
(select * from #ClsRate)y on x.Fld_CertNo = y.Isin              
              
set @TotalValue = (select BsePledge+NsePledge from #bseP,#nseP)              
set @NSEValue = (select NsePledge from #nseP)              
                            
----------------------Client Value               
      
select Fld_Party_Code,      
BsePledgeValue=isnull(sum(Qty*case when Fld_Segment = 'BSE' then bserate END),0),      
NsePledgeValue=isnull(sum(Qty*case when Fld_Segment = 'NSE' then nserate END),0),        
ClientValue=isnull(sum(Qty*case when Fld_Segment = 'BSE' then bserate END),0)+isnull(sum(Qty*case when Fld_Segment = 'NSE' then nserate END),0)      
into #x from #SegmentData x inner join #ClsRate y               
on x.Fld_CertNo = y.isin group by Fld_Party_Code        
              
------------------T-2 BSE Day Billing Ledger             
select cltcode,                             
[T-2 Day Bal] =                            
sum                            
(                            
case                   
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                 
into #T2Bal_Bse                             
from intranet.risk.dbo.abl_ledger x where edt <= @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                             
group by cltcode                  
              
-----------------------T BSE Day Recipt/Payment                            
                      
select cltcode,                             
TDay_PaymentRecipt =                      
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
into #T1PRData_bse              
from intranet.risk.dbo.abl_ledger x where vdt = @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code ) and vtyp in (2,3)                             
group by cltcode                                      
              
-------------------T-1 BSE Payment Receipt                                 
              
select cltcode,                             
T1Day_PaymentRecipt =                            
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
--into #T1DR                        
into #T_1PRData_bse                        
from intranet.risk.dbo.abl_ledger  where convert(varchar(11),vdt) >  convert(datetime,@First_day,103)                             
and convert(varchar(11),vdt) <  convert(datetime,@Third_day,103)               
and vtyp in (2,3)  group by cltcode               
              
              
              
-------------------------------BSE MG 02 T Day                              
                      
 select party_code,                            
 MG02TDay=CASE                             
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(20,2),SUM(MTOM+VARAMT))                      
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                            
 else CONVERT(dec(20,2),SUM(MTOM+VARAMT)) end                            
 into  #MG02TDay_bse from ANGELBSECM.bsedb_ab.dbo.tbl_mg02 where margin_date = @RptDate                          
 GROUP BY party_code               
-------------------------------BSE MG 02 T - 1 Day                          
              
 select party_code,                            
 MG02T1Day=CASE                             
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(20,2),SUM(MTOM+VARAMT))                           
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                      
 else CONVERT(dec(20,2),SUM(MTOM+VARAMT)) end                            
 into  #MG02T1Day_bse from ANGELBSECM.bsedb_ab.dbo.TBL_MG02 where               
 margin_date = convert(datetime,@Second_day,103)                            
 --margin_date = convert(datetime,'02/07/2009',103)                            
 GROUP BY party_code                 
                            
-----------------------T-2 NSE Day Billing Ledger                             
select cltcode,                             
[T-2 Day Bal] =                            
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                 
into #T2Bal                             
from intranet.risk.dbo.nse_ledger x where edt <=  @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                             
group by cltcode                           
                             
-----------------------T Day Recipt/Payment                            
                      
select cltcode,                             
TDay_PaymentRecipt =                      
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
into #T1PRData                             
from intranet.risk.dbo.nse_ledger x where vdt = @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code ) and vtyp in (2,3)                             
group by cltcode                                      
                  
-------------------T-1 Payment Receipt                                  
select cltcode,                             
T1Day_PaymentRecipt =                            
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
--into #T1DR                        
into #T_1PRData                        
from intranet.risk.dbo.nse_ledger  where convert(varchar(11),vdt) >  convert(datetime,@First_day,103)                      
and convert(varchar(11),vdt) < convert(datetime,@Third_day,103)               
and vtyp in (2,3)  group by cltcode                            
                  
-------------------------------MG 02 T Day                               
                      
 select party_code,                            
 MG02TDay=CASE                             
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(20,2),SUM(MTOM+VARAMT))                      
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                            
 else CONVERT(dec(20,2),SUM(MTOM+VARAMT)) end                            
 into  #MG02TDay from anand1.msajag.dbo.tbl_mg02 where margin_date = @RptDate                          
 GROUP BY party_code                         
                      
              
                      
-------------------------------MG 02 T - 1 Day               
                      
 select party_code,                            
 MG02T1Day=CASE                             
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(20,2),SUM(MTOM+VARAMT))                           
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                      
 else CONVERT(dec(20,2),SUM(MTOM+VARAMT)) end                            
 into  #MG02T1Day from anand1.msajag.dbo.TBL_MG02 where               
 margin_date = convert(datetime,@Second_day,103)                             
 GROUP BY party_code                            
                           
-----------------------------T-1 FO Ledger                      
                         
select cltcode,                             
[FO T-1 Day Bal] =                            
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
into #FOT1Bal                             
from intranet.risk.dbo.fo_ledger x where edt <= @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                             
group by cltcode                            
                            
-----------------------FO T Day Recipt/Payment                       
                    
select cltcode,                             
FOTDay_PaymentRecipt =                            
sum                            
(                            
case                             
when drcr = 'C' then vamt                             
when drcr = 'D' then vamt*-1 end                             
)                            
into #FOTPRData                             
from intranet.risk.dbo.FO_ledger x where vdt = @RptDate                            
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code ) and vtyp in (2,3)                             
group by cltcode                                
                  
                            
-------------------------------Fo Margin Ledger                         
                            
SELECT                             
Party_code,                            
Amount=                            
sum(case when drcr = 'D' then Amount*-1                            
when drcr = 'C' then Amount end)                            
into #FoBal FROM ANGELFO.ACCOUNTFO.DBO.MarginLedger where                             
Vdt >= @sdate and Vdt <= @RptDate                            
--Vdt >= 'Apr 01 2009' and Vdt <= 'Jul 03 2009'                            
group by Party_code                                          
                            
select Party_code,                            
T1DayFoBal=case                             
when Amount < 0 then Amount                      
when Amount > 0 then Amount*-1 else Amount end                            
into #T1FOBal                            
from #FoBal                            
                            
select party_code,initialmargin,MTMMargin into #FoMargin from ANGELFO.NSEFO.DBO.TBL_CLIENTMARGIN x               
where margindate = @RptDate                            
and exists (select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code)         
                                        
                            
select a.*,[T-2 Day Bal]=isnull(b.[T-2 Day Bal],0),                            
TDay_PaymentRecipt=isnull(c.TDay_PaymentRecipt,0),                            
T1Day_PaymentRecipt=isnull(d.T1Day_PaymentRecipt,0),              
MG02TDay=isnull(e.MG02TDay,0),                            
MG02T1Day=isnull(f.MG02T1Day,0),                            
[FO T-1 Day Bal]=isnull(g.[FO T-1 Day Bal],0),                            
FOTDay_PaymentRecipt=isnull(FOTDay_PaymentRecipt,0),                            
Amount=isnull(Amount,0),                            
initialmargin=isnull(initialmargin,0),                            
MTMMargin=isnull(MTMMargin,0),              
[T-2 Day Bal_BSE]=isnull(k.[T-2 Day Bal],0),              
[TDay_PaymentRecipt_BSE]=isnull(l.[TDay_PaymentRecipt],0),              
[T1Day_PaymentRecipt_BSE]=isnull(m.[T1Day_PaymentRecipt],0),              
[MG02TDay_BSE]=isnull(n.[MG02TDay],0),              
[MG02T1Day_BSE]=isnull(o.[MG02T1Day],0)              
into #rpt               
from                            
(select * from #x)a                            
left outer join                            
(select cltcode,[T-2 Day Bal]=isnull([T-2 Day Bal],0) from #T2Bal)b                            
on a.Fld_Party_Code = b.cltCode                            
left outer join                            
(select * from #T1PRData)c                            
on a.Fld_Party_Code = c.cltCode                            
left outer join                            
(select * from #T_1PRData)d                            
on a.Fld_Party_Code = d.cltCode                            
left outer join                            
(select * from #MG02TDay)e                            
on a.Fld_Party_Code = e.party_code                            
left outer join                            
(select * from #MG02T1Day)f                            
on a.Fld_Party_Code = f.party_code                            
left outer join                            
(select * from #FOT1Bal)g                            
on a.Fld_Party_Code = g.cltCode                            
left outer join                            
(select * from #FOTPRData)h                            
on a.Fld_Party_Code = h.cltCode                            
left outer join                            
(select * from #FoBal)i                            
on a.Fld_Party_Code = i.party_code                            
left outer join                            
(select * from #FoMargin)j                            
on a.Fld_Party_Code = j.party_code               
left outer join                            
(select * from #T2Bal_Bse)k               
on a.Fld_Party_Code = k.cltcode               
left outer join                
(select * from #T1PRData_bse)l              
on a.Fld_Party_Code = l.cltcode               
left outer join                
(select * from #T_1PRData_bse)m              
on a.Fld_Party_Code = m.cltcode               
left outer join                
(select * from #MG02TDay_bse)n              
on a.Fld_Party_Code = n.party_code               
left outer join                
(select * from #MG02T1Day_bse)o              
on a.Fld_Party_Code = o.party_code               
              
select                       
CurrDate=getdate(),              
Fld_party_Code,                      
TotalPledgeValue=@TotalValue,          
TotalNSEValue=@NSEValue,      
--TotalPledgeValue=0,          
--TotalNSEValue=0,      
BsePledgeValue,       
NsePledgeValue,         
ClientPledgeValue=ClientValue,                      
[T-2 Day Bal_BSE],              
TDay_PaymentRecipt_BSE,              
T1Day_PaymentRecipt_BSE,              
MG02TDay_BSE,              
MG02T1Day_BSE,              
CM_Free_Bal_BSE=[T-2 Day Bal_BSE]+TDay_PaymentRecipt_BSE+T1Day_PaymentRecipt_BSE-MG02TDay_BSE-MG02T1Day_BSE,              
[CMLedgerT-2]=[T-2 Day Bal],                      
TDay_PaymentRecipt,                      
T1Day_PaymentRecipt,                      
MG02TDay,                      
MG02T1Day,                      
CM_Free_Bal_NSE=[T-2 Day Bal]+TDay_PaymentRecipt+T1Day_PaymentRecipt-MG02TDay-MG02T1Day,                      
[FO T-1 Day Bal],               
FOTDay_PaymentRecipt,                      
FoMarginLedger=Amount,                      
initialmargin,                      
ExposureMargin=MTMMargin,                      
FO_Free_Bal=([FO T-1 Day Bal]+FOTDay_PaymentRecipt+Amount-initialmargin-MTMMargin)                      
into #pt1               
from #rpt                                
                      
select *,NseNetObligation =      
case when (CM_Free_Bal_NSE+FO_Free_Bal) > 0 then 0 else (CM_Free_Bal_NSE+FO_Free_Bal) end,      
NSEBSENetObligation=              
case when (CM_Free_Bal_NSE+FO_Free_Bal+CM_Free_Bal_BSE) > 0 then 0 else (CM_Free_Bal_NSE+FO_Free_Bal+CM_Free_Bal_BSE) end               
into #pt2 from #pt1                      
                  
delete from tbl_NSECertificate where convert(varchar(11),Fld_RptDate,103) = @rptdate        
                      
insert into tbl_NSECertificate          
select CurrDate,Fld_party_Code,TotalPledgeValue,BsePledgeValue,NsePledgeValue,TotalNSEValue,      
ClientPledgeValue=ClientPledgeValue/2,[T-2 Day Bal_BSE],TDay_PaymentRecipt_BSE,T1Day_PaymentRecipt_BSE,MG02TDay_BSE,      
MG02T1Day_BSE,CM_Free_Bal_BSE,[CMLedgerT-2],TDay_PaymentRecipt,T1Day_PaymentRecipt,MG02TDay,MG02T1Day,      
CM_Free_Bal_NSE,[FO T-1 Day Bal],FOTDay_PaymentRecipt,FoMarginLedger,initialmargin,ExposureMargin,      
FO_Free_Bal,NseNetObligation,NSEBSENetObligation,  
NSEValueImproperUse=case when ((NsePledgeValue/2)+NseNetObligation) < 0 then 0 else ((NsePledgeValue/2)+NseNetObligation) end,      
BSENSEValueImproperUse=case when ((ClientPledgeValue/2)+NSEBSENetObligation) < 0 then 0 else ((ClientPledgeValue/2)+NSEBSENetObligation) end from #pt2         
--where Fld_Party_Code = 'N20625'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_NSEPldgCertificate_091107
-- --------------------------------------------------

CREATE Proc Angel_NSEPldgCertificate_091107                                
as                      
               
declare @Segment as varchar(5)                      
declare @RptDate as varchar(11)                     
declare @ClosingDate as varchar(11)                
declare @First_day as varchar(11)                                                        
declare @Second_day as varchar(11)                                                        
declare @Third_day as varchar(11)               
declare @sdate as varchar(11)                      
declare @TotalValue as money                                
                      
set @Segment = 'BSE'  
set @RptDate = '09/11/2007'          
set @RptDate = convert(datetime,@RptDate,103)                                                        
set @Third_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date = @RptDate and sett_type = 'D')                                                        
set @Second_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date < convert(datetime,@Third_day,103) and sett_type = 'D')                                                        
set @First_day = (select convert(varchar(11),max(start_date),103) from bsedb.DBO.Sett_Mst where start_date < convert(datetime,@Second_day,103) and sett_type = 'D')                                                                                  
set @sdate = (select sdtCur from Anand1.ACCOUNT.DBO.parameter where ldtcur >= @RptDate and sdtcur <= @RptDate)                      
set @ClosingDate = convert(datetime,@Second_day,103)            
            
/*            
print @Third_day                      
print @Second_day                      
print @First_day                      
print @sdate            
print @RptDate            
print @ClosingDate*/            
            
-----------------------------------------------Dump Deltrans data-----------------            
/*          
insert into tbl_PledgeHist            
select Sett_type,Sett_No,party_code,scrip_cd,series,Qty,CertNo,BcltDpId,'BSE',convert(datetime,convert(varchar(11),getdate())) from angeldemat.bsedb.dbo.deltrans             
where drcr = 'D' and delivered = '0' and trtype = 909            
            
insert into tbl_PledgeHist            
select Sett_type,Sett_No,party_code,scrip_cd,series,Qty,CertNo,BcltDpId,'NSE',convert(datetime,convert(varchar(11),getdate())) from angeldemat.msajag.dbo.deltrans             
where drcr = 'D' and delivered = '0' and trtype = 909            
                      
----------------------Total Value                      
set @TotalValue = (select sum(x.Qty*y.ClosingRate)   from                      
(                      
select Fld_Party_code,Fld_CertNo,sum(Fld_Qty) Qty from tbl_PledgeHist where Fld_Segment = @Segment and Fld_DtTime = @RptDate                      
group by Fld_Party_code,Fld_CertNo                      
)x                      
left outer join                      
(                      
SELECT                       
Isin,                      
ClosingRate=case                       
when @Segment = 'BSE' then bserate                       
when @Segment = 'NSE' then nserate end FROM intranet.risk.dbo.V_Hist_ClosingRate where MFDATE = @ClosingDate)y                      
on x.Fld_CertNo = y.Isin )                      
                      
----------------------Client Value                      
select CurrDate=@RptDate,x.Fld_party_Code,PledgeValue=@TotalValue,sum(x.Qty*y.ClosingRate) ClientValue into #x  from                      
(                      
select Fld_Party_code,Fld_CertNo,sum(Fld_Qty) Qty from tbl_PledgeHist where Fld_Segment = @Segment and Fld_DtTime = @RptDate                      
group by Fld_Party_code,Fld_CertNo                      
)x                      
left outer join                      
(SELECT Isin,                      
ClosingRate=case                       
when @Segment = 'BSE' then bserate                       when @Segment = 'NSE' then nserate end                      
 FROM intranet.risk.dbo.V_Hist_ClosingRate where MFDATE = @ClosingDate)y                      
on x.Fld_CertNo = y.Isin group by Fld_party_Code                      
*/                      
          
select CurrDate=@RptDate,Fld_party_Code=party_Code,PledgeValue=0,ClientValue=0 into #x from intranet.risk.dbo.client_Details          
          
          
-----------------------T-2 Day Billing Ledger                       
          
select cltcode,                       
[T-2 Day Bal] =                      
sum                      
(                      
case                  
when drcr = 'C' then vamt                       
when drcr = 'D' then vamt*-1 end                       
)                      
into #T2Bal                       
from anand1.account.dbo.ledger x           
where vdt >='Apr  1 2007 00:00:00' and edt <= @RptDate                      
--and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                       
group by cltcode                      
                       
-----------------------T Day Recipt/Payment                      
                
select cltcode,                       
TDay_PaymentRecipt =                
sum                      
(                      
case                       
when drcr = 'C' then vamt                       
when drcr = 'D' then vamt*-1 end                       
)                      
into #T1PRData                       
from anand1.account.dbo.ledger x           
where vdt >=convert(datetime,@RptDate,103)-2 and vdt < convert(datetime,@RptDate,103)-1 and vtyp in (2,3)                                          
--and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )and vtyp in (2,3)                       
group by cltcode                                
            
-------------------T-1 Payment Receipt                            
select cltcode,                       
T1Day_PaymentRecipt =                      
sum                      
(                      
case                       
when drcr = 'C' then vamt                       
when drcr = 'D' then vamt*-1 end                       
)                      
--into #T1DR                  
into #T_1PRData                  
from anand1.account.dbo.ledger          
where convert(varchar(11),vdt) > convert(datetime,@First_day,103)                       
and convert(varchar(11),vdt) < convert(datetime,@Third_day,103) and vtyp in (2,3)  group by cltcode                      
            
-------------------------------MG 02 T Day                 
                
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@RptDate,103)) = 0                
begin*/                
                
 select party_code,                      
 MG02TDay=CASE                       
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                      
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                      
 into  #MG02TDay from anand1.msajag.dbo.tbl_mg02_his where margin_date = @RptDate                    
 GROUP BY party_code                   
                
/*                
end                
else                
begin                
                
 select party_code,                      
 MG02TDay=CASE                       
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                      
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                      
 into  #MG02TDay from anand1.msajag.dbo.TBL_MG02_his where margin_date = @RptDate                    
 GROUP BY party_code                 
                
end*/                
                
-------------------------------MG 02 T - 1 Day                    
                
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@Second_day,103)) = 0                
begin*/                
                
 select party_code,                      
 MG02T1Day=CASE                       
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                     
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                      
 into  #MG02T1Day from anand1.msajag.dbo.TBL_MG02_his where margin_date = convert(datetime,@Second_day,103)                      
 GROUP BY party_code                      
/*                
end                      
else                
begin                
 select party_code,                      
 MG02T1Day=CASE                       
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                     
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                      
 into  #MG02T1Day from anand1.msajag.dbo.tbl_mg02_his where margin_date = convert(datetime,@Second_day,103)                      
 GROUP BY party_code                      
end   */                
                      
-----------------------------T-1 FO Ledger         
                   
select cltcode,                       
[FO T-1 Day Bal] =                      
sum                      
(                      
case                       
when drcr = 'C' then vamt                       
when drcr = 'D' then vamt*-1 end                       
)                      
into #FOT1Bal                       
from ANGELFO.ACCOUNTFO.DBO.ledger            
where vdt >='Apr  1 2007 00:00:00' and edt <= @RptDate                    
--and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                       
group by cltcode                      
                      
-----------------------FO T Day Recipt/Payment                 
                
select cltcode,                       
FOTDay_PaymentRecipt =                      
sum                      
(                      
case                       
when drcr = 'C' then vamt                       
when drcr = 'D' then vamt*-1 end                       
)                      
into #FOTPRData                       
from ANGELFO.ACCOUNTFO.DBO.ledger            
where vdt >=convert(datetime,@RptDate,103)-1 and vdt < @RptDate  and vtyp in (2,3)                    
                                                        
--and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )and vtyp in (2,3)                       
group by cltcode                          
            
                      
-------------------------------Fo Margin Ledger                            
                      
SELECT                       
Party_code,                      
Amount=                      
sum(case when drcr = 'D' then Amount*-1                      
when drcr = 'C' then Amount end)                      
into #FoBal FROM ANGELFO.ACCOUNTFO.DBO.MarginLedger where                       
Vdt >= @sdate and Vdt <= @RptDate                      
group by Party_code                      
                      
                      
select Party_code,                      
T1DayFoBal=case                       
when Amount < 0 then Amount                
when Amount > 0 then Amount*-1 else Amount end                      
into #T1FOBal                      
from #FoBal                      
                      
select party_code,initialmargin,MTMMargin into #FoMargin from ANGELFO.PRADNYA.DBO.HISTORY_TBL_CLIENTMARGIN_NSEFO x where margindate = @RptDate                      
--and exists (select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code)                       
                      
      
      
                      
select a.*,[T-2 Day Bal]=isnull(b.[T-2 Day Bal],0),                      
TDay_PaymentRecipt=isnull(c.TDay_PaymentRecipt,0),                      
T1Day_PaymentRecipt=isnull(d.T1Day_PaymentRecipt,0),MG02TDay=isnull(MG02TDay,0),                      
MG02T1Day=isnull(MG02T1Day,0),                      
[FO T-1 Day Bal]=isnull(g.[FO T-1 Day Bal],0),                      
FOTDay_PaymentRecipt=isnull(FOTDay_PaymentRecipt,0),                      
Amount=isnull(Amount,0),                      
initialmargin=isnull(initialmargin,0),                      
MTMMargin=isnull(MTMMargin,0)                      
into #rpt from                      
(select * from #x)a                      
left outer join                      
(select cltcode,[T-2 Day Bal]=isnull([T-2 Day Bal],0) from #T2Bal)b                      
on a.Fld_Party_Code = b.cltCode                      
left outer join                      
(select * from #T1PRData)c                      
on a.Fld_Party_Code = c.cltCode                      
left outer join                      
(select * from #T_1PRData)d                      
on a.Fld_Party_Code = d.cltCode                      
left outer join                      
(select * from #MG02TDay)e                      
on a.Fld_Party_Code = e.party_code                      
left outer join                      
(select * from #MG02T1Day)f                      
on a.Fld_Party_Code = f.party_code                      
left outer join                      
(select * from #FOT1Bal)g                      
on a.Fld_Party_Code = g.cltCode                 
left outer join                      
(select * from #FOTPRData)h                      
on a.Fld_Party_Code = h.cltCode                      
left outer join                      
(select * from #FoBal)i                      
on a.Fld_Party_Code = i.party_code                      
left outer join                      
(select * from #FoMargin)j                      
on a.Fld_Party_Code = j.party_code                      
                  
select                 
CurrDate,Fld_party_Code,                
TotalPledgeValue=PledgeValue,                
ClientPledgeValue=ClientValue,                
[CMLedgerT-2]=[T-2 Day Bal],                
TDay_PaymentRecipt,                
T1Day_PaymentRecipt,                
MG02TDay,                
MG02T1Day,                
CM_Free_Bal=[T-2 Day Bal]+TDay_PaymentRecipt+T1Day_PaymentRecipt-MG02TDay-MG02T1Day,                
[FO T-1 Day Bal],                
FOTDay_PaymentRecipt,                
FoMarginLedger=Amount,                
initialmargin,                
ExposureMargin=MTMMargin,                
FO_Free_Bal=([FO T-1 Day Bal]+FOTDay_PaymentRecipt+Amount-initialmargin-MTMMargin)                
into #pt1 from #rpt                  
          

                
select *,NetObligation=case when (CM_Free_Bal+FO_Free_Bal) > 0 then 0 else (CM_Free_Bal+FO_Free_Bal) end into #pt2  from #pt1                


update #pt2 set clientPledgeValue=b.Actual_value/2 from 
(
select party_code,Actual_value=sum(total)  
from holding09112007 where scrip_cd in (select scode from intranet.risk.dbo.icici_scp)
and accno <> ''
group by party_code
) b where #pt2.fld_party_Code=b.party_Code
          
truncate table tbl_NSECertificate_09112007           
          
insert into tbl_NSECertificate_09112007          
select *,ValueImproperUse=case when (ClientPledgeValue+NetObligation) < 0 then 0 else (ClientPledgeValue+NetObligation) end,0 from #pt2                
          
select cltcode, balance=sum(case when drcr = 'C' then vamt else vamt*-1 end)           
into #bsebal          
from anand.account_Ab.dbo.ledger where          
vdt >='Apr  1 2007 00:00:00' and vdt <='Nov  9 2007 23:59:59'          
group by cltcode          
          
update tbl_NSECertificate_09112007 set bse_balance=b.balance          
from #bsebal b where tbl_NSECertificate_09112007.fld_partycode=b.cltcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_PayoutVerifier
-- --------------------------------------------------
CREATE Proc Angel_PayoutVerifier
as


select x.*,bsecode = y.party_code,nsecode = z.party_code into #BoData from
(
select Fld_CltCode,Fld_BseDp,Fld_Bseid,Fld_BsePoa=replace(Fld_BsePoa,'Y','1'),
Fld_NseDp,Fld_Nseid,Fld_NsePoa=replace(Fld_NsePoa,'Y','1')
 from Angel_AutoPayoutClientMaster (nolock) )x
left outer join
(select * from BSEDB.DBO.V_BSEPOA)y 
on x.Fld_CltCode = y.party_code and x.Fld_Bseid = y.cltdpNo and x.Fld_BsePoa = y.def
left outer join
(select * from msajag.dbo.V_NSEPOA)z 
on x.Fld_CltCode = z.party_code and x.Fld_Nseid = z.cltdpNo and x.Fld_NsePoa = z.def

select party_code from intranet.risk.dbo.collection_client_details where 
(ABL+ACDL+NBFC+FO+NCDX+MCDX+MCD+NSX) < 0 and holding >= 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_SplitPledge
-- --------------------------------------------------

CREATE Proc Angel_SplitPledge                
as                       
      
select * into #TotPEDClt_P from tbl_NewPledge_Calc where condition = 'PED' and P_R = 'P'
--------------------------------Pledge: Updating  tbl_Pledge_Data on the basis of Free Value = Pledge Value       
    
create nonclustered index ix_party_code on #TotPEDClt_P(party_code)     
create nonclustered index ix_FreeValue on #TotPEDClt_P(FreeValue,condition)     
create nonclustered index #tbl_Pledge_Data on #TotPEDClt_P(party_code,NewPledge,P_R)     
    
select * into #tbl_Pledge_Data from tbl_Pledge_Data x (nolock) where exists    
(select party_code from #TotPEDClt_P y where x.party_code = y.party_code)        
      
select * into #SameFreePledge from #TotPEDClt_P where FreeValue = NewPledge -- U                
                
begin tran                
                
update #tbl_Pledge_Data set New_Pledge = #tbl_Pledge_Data.FreeValue,Fld_NewPledgeQty = Free_Qty from  #SameFreePledge                
where #SameFreePledge.party_code = #tbl_Pledge_Data.party_code and #tbl_Pledge_Data.condition = 'PED' and #tbl_Pledge_Data.P_R = 'P'                
                
commit                
--------------------------------Pledge : Updating  tbl_Pledge_Data on the basis of Single Rows                 
      
select * into #FNet from #TotPEDClt_P x where not exists                
(select * from #SameFreePledge y where x.party_code = y.party_code)                         
      
select * into #SingleRow from #Fnet where party_code in                
(                
select party_code from #tbl_Pledge_Data(nolock) where condition = 'PED' and P_R = 'P' group by party_code having count(*) = 1                
)                
                
select * into #x from #tbl_Pledge_Data x (nolock) where exists                
(select * from #SingleRow y where x.party_code = y.party_code) and condition = 'PED' and P_R = 'P'                
                
select x.party_code,NewPledge,PledgeQty= convert(int,round((x.NewPledge*y.Free_Qty)/y.FreeValue,0))                 
into #upd from #SingleRow x, #x y where x.party_code = y.party_code                
                
begin tran                
                
update #tbl_Pledge_Data set New_Pledge = #upd.newPledge,Fld_NewPledgeQty = PledgeQty from  #upd                
where #upd.party_code = #tbl_Pledge_Data.party_code and #tbl_Pledge_Data.condition = 'PED' and #tbl_Pledge_Data.P_R = 'P'                
                
commit                   
                
----------------------------Pledge: Max Value                
select * into #SNet from #FNet x where not exists                
(select * from #SingleRow y where x.party_code = y.party_code)                
      
/*    
select * into #tbl_Pledge_Data from tbl_Pledge_Data(nolock) x where exists        
(select * from #SNet y where x.party_code = y.party_code)    */    
        
select party_code,max(FreeValue) FreeValue into #66 from #tbl_Pledge_Data(nolock) x         
where condition = 'PED' and P_R = 'P' and BcltDpId = '1203320000000066' and exists                
(select * from #SNet y where x.party_code = y.party_code) group by party_code        
        
select party_code,FreeValue,max(SrNo) as SrNo into #upd66         
from #tbl_Pledge_data x where  exists        
(select * from #66 y where x.party_code = y.party_code and x.FreeValue = y.FreeValue and x.condition = 'PED')        
group by party_code,FreeValue        
        
select x.*,y.NewPledge,x.FreeValue-y.NewPledge as Net into #New66  from #upd66 x,#SNet y where x.party_code = y.party_code         
      
select * into #UpdNew  from #New66 where  FreeValue >= NewPledge        
        
Begin tran        
        
update #tbl_Pledge_Data set New_Pledge = #UpdNew.newPledge,        
Fld_NewPledgeQty = convert(int,round(#UpdNew.newPledge/#tbl_Pledge_Data.cls,0)) from #UpdNew                
where #UpdNew.SrNo = #tbl_Pledge_Data.SrNo         
        
commit        
        
---------------------------Not In 66 & 28---------------        
     
select * into #51 from #SNet x where not exists        
(select * from #66 y where x.party_code = y.party_code)        
        
select party_code,max(FreeValue) FreeValue into #51data from #tbl_Pledge_Data(nolock) x         
where condition = 'PED' and P_R = 'P' and BcltDpId not in ('1203320000000066','1203320000000028') and exists                
(select * from #51 y where x.party_code = y.party_code) group by party_code        
        
select party_code,FreeValue,max(SrNo) as SrNo into #upd51         
from #tbl_Pledge_data x where  exists        
(select * from #51data y where x.party_code = y.party_code and x.FreeValue = y.FreeValue and x.condition = 'PED')        
group by party_code,FreeValue        
        
select x.*,y.NewPledge,x.FreeValue-y.NewPledge as Net into #New51  from #upd51 x,#SNet y where x.party_code = y.party_code           
      
select * into #UpdNew51 from #New51 where FreeValue >= NewPledge        
        
Begin tran        
        
update #tbl_Pledge_Data set New_Pledge = #UpdNew51.newPledge,        
Fld_NewPledgeQty = convert(int,round(#UpdNew51.newPledge/#tbl_Pledge_Data.cls,0)) from #UpdNew51                
where #UpdNew51.SrNo = #tbl_Pledge_Data.SrNo         
        
commit        
------------------      
      
SELECT PARTY_CODE INTO #NET FROM #upd66 X WHERE NOT EXISTS      
(SELECT * FROM #UpdNew Y WHERE X.PARTY_CODE = Y.PARTY_CODE)      
UNION ALL      
SELECT PARTY_CODE FROM #New51 X WHERE NOT EXISTS      
(SELECT * FROM #UpdNew51 Y WHERE X.PARTY_CODE = Y.PARTY_CODE)      
UNION ALL      
SELECT PARTY_CODE FROM #51 X WHERE NOT EXISTS      
(SELECT * FROM #51data Y WHERE X.PARTY_CODE = Y.PARTY_CODE)      
      
--------------------------------------Not In 51 & 66        
      
SELECT * into #updfin FROM #SNET X WHERE EXISTS      
(SELECT * FROM #NET Y WHERE X.PARTY_CODE = Y.PARTY_CODE) and FreeValue < 75000 and NewPledge < 75000      
      
Begin tran        
        
update #tbl_Pledge_Data set New_Pledge = #updfin.newPledge,        
Fld_NewPledgeQty = convert(int,round(#updfin.newPledge/#tbl_Pledge_Data.cls,0)) from #updfin                
where #updfin.party_code = #tbl_Pledge_Data.party_code and #tbl_Pledge_Data.condition = 'PED'     
and #tbl_Pledge_Data.P_R = 'P'      
        
commit          
    
select * into #fin from #SNET where party_code in      
(      
select party_code from #NET x where not exists      
(select * from #updfin y where x.party_code = y.party_code)      
)                
    
begin tran    
    
update tbl_Pledge_Data     
set tbl_Pledge_Data.Fld_NewPledgeQty = #tbl_Pledge_Data.Fld_NewPledgeQty,    
tbl_Pledge_Data.New_Pledge = #tbl_Pledge_Data.New_Pledge    
from #tbl_Pledge_Data where tbl_Pledge_Data.srNo = #tbl_Pledge_Data.Srno    
    
commit               
      
-------------------------------------      
    
drop table #tbl_Pledge_Data    
    
select * into #tbl_Pledge_Data1  from tbl_Pledge_Data (NOLOCK) x where exists      
(      
select * from #fin y where x.party_code = y.party_code      
) and condition = 'PED' and P_R = 'P' and FreeValue <> 0   

    
create nonclustered index ix_party_code on #tbl_Pledge_Data1(party_code,Bcltdpid,condition,FreeValue,P_R)    
      
      
declare @party_code as varchar(15)                
declare @amt money                
declare @Tbl_Qty as varchar(50)                 
declare @Mark_Qty as varchar(50)                
declare @temp int                
declare @SrNo varchar(15)            
declare @Free_Qty int            
declare @FreeValue money                 
declare @cmcd varchar(16)          
          
                
DECLARE Pledge_Cursor CURSOR FOR select party_code,NewPledge from #fin --where party_code = 'R6516'           
OPEN Pledge_Cursor                
                  
FETCH NEXT FROM Pledge_Cursor                 
INTO @party_code,@Amt               
            
WHILE @@FETCH_STATUS = 0             
begin            
          
 declare PledgeAc cursor for select cmcd from tbl_pledgepref          
 open PledgeAc          
          
 FETCH NEXT FROM PledgeAc                 
 INTO @cmcd          
             
 WHILE @@FETCH_STATUS = 0             
 begin           
            
   Declare Pledge_Mark_Cursor Cursor for select SrNo,Free_Qty,FreeValue from #tbl_Pledge_Data1 (nolock) where party_code = @party_code and Bcltdpid = @cmcd and condition = 'PED' and FreeValue <> 0 and P_R = 'P' order by SrNo desc            
   open Pledge_Mark_Cursor             
               
     FETCH NEXT FROM Pledge_Mark_Cursor               
     INTO @SrNo,@Free_Qty,@FreeValue                 
                
     set @temp = 0            
               
      WHILE @@FETCH_STATUS = 0            
      begin            
               
    set @temp = @temp+@FreeValue               
                   
    if(@temp <= @Amt)            
     begin          
       set @temp = @temp            
       update #tbl_Pledge_Data1 set New_Pledge = FreeValue,Fld_NewPledgeQty = Free_Qty where SrNo = @SrNo                 
     end          
                      
    if(@temp >= @Amt)                    
     begin          
       set @temp = @Amt-(@temp-@FreeValue)                 
       update #tbl_Pledge_Data1 set New_Pledge = @temp,Fld_NewPledgeQty = convert(int,round(@temp/cls,0)) where SrNo = @SrNo                 
       break                      
     end          
                    
      FETCH NEXT FROM Pledge_Mark_Cursor             
      INTO @SrNo,@Free_Qty,@FreeValue            
 END          
          
   CLOSE Pledge_Mark_Cursor                
   DEALLOCATE Pledge_Mark_Cursor            
          
  FETCH NEXT FROM PledgeAc           
  INTO @cmcd          
END          
          
 CLOSE PledgeAc                
 DEALLOCATE PledgeAc        
             
 FETCH NEXT FROM Pledge_Cursor           
 INTO @party_code,@Amt                
END             
                              
  CLOSE Pledge_Cursor                
  DEALLOCATE Pledge_Cursor     
    
    
begin tran    
    
update tbl_Pledge_Data     
set tbl_Pledge_Data.Fld_NewPledgeQty = #tbl_Pledge_Data1.Fld_NewPledgeQty,    
tbl_Pledge_Data.New_Pledge = #tbl_Pledge_Data1.New_Pledge    
from #tbl_Pledge_Data1 where tbl_Pledge_Data.srNo = #tbl_Pledge_Data1.Srno    
    
commit

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Angel_USP_AutoPayoutClientMaster
-- --------------------------------------------------
CREATE proc Angel_USP_AutoPayoutClientMaster                  
(                  
@Fld_SrNo int,                  
@Fld_CltCode varchar(20),                  
@Fld_CltName varchar(100),                  
@Fld_BrTag varchar(15),                  
@Fld_SbTag varchar(15),                  
@Fld_BseDp varchar(20),                  
@Fld_Bseid varchar(20),                  
@Fld_BsePoa varchar(1),                  
@Fld_NseDp varchar(20),                  
@Fld_Nseid varchar(20),                  
@Fld_NsePoa varchar(1),                  
@Fld_BSEActiveBy varchar(15),                  
@Fld_BSEActiveIp varchar(15),                  
@Fld_NSEActiveBy varchar(15),                  
@Fld_NSEActiveIp varchar(15),                  
@Fld_BSEDeActiveBy varchar(15),                  
@Fld_BSEDeActiveIp varchar(15),                  
@Fld_NSEDeActiveBy varchar(15),                  
@Fld_NSEDeActiveIp varchar(15),                  
@bsechk char(1),                  
@nsechk char(1),                  
@bserechk char(1),                  
@nsedechk char(1)                  
)                  
as                  
declare  @Fld_BseActiveTime datetime,@Fld_NseActiveTime datetime,@Fld_BseDeActiveTime datetime,@Fld_NseDeActiveTime datetime                     
set @Fld_BseActiveTime = case when @bsechk = 'Y' then getdate() else 'Dec 31 2049' end                  
set @Fld_NseActiveTime = case when @nsechk = 'Y' then getdate() else 'Dec 31 2049' end                  
set @Fld_BseDeActiveTime = case when @bserechk = 'Y' then getdate() else 'Dec 31 2049' end                  
set @Fld_NseDeActiveTime = case when @nsedechk = 'Y' then getdate() else 'Dec 31 2049' end                
              
set @Fld_BSEActiveBy = case when @bsechk = 'Y' then @Fld_BSEActiveBy else '' end                
set @Fld_NSEActiveBy = case when @nsechk = 'Y' then @Fld_NSEActiveBy else '' end                
set @Fld_BSEDeActiveBy = case when @bserechk = 'Y' then @Fld_BSEDeActiveBy else '' end                
set @Fld_NSEDeActiveBy = case when @nsedechk = 'Y' then @Fld_NSEDeActiveBy else '' end                
                
                  
if (select count(*) from Angel_AutoPayoutClientMaster (nolock) where Fld_SrNo = @Fld_SrNo) = 0                  
begin                  
insert into Angel_AutoPayoutClientMaster values                  
(                  
 @Fld_CltCode ,                  
 @Fld_CltName ,                  
 @Fld_BrTag ,                  
 @Fld_SbTag ,                  
 @Fld_BseDp ,                  
 @Fld_Bseid ,                  
 @Fld_BsePoa ,                  
 @Fld_NseDp ,                  
 @Fld_Nseid ,                  
 @Fld_NsePoa ,                  
 @Fld_BSEActiveBy ,                  
 @Fld_BseActiveTime,                  
 @Fld_BSEActiveIp ,                  
 @Fld_NSEActiveBy ,                  
 @Fld_NseActiveTime,                  
 @Fld_NSEActiveIp ,                  
 @Fld_BSEDeActiveBy,                  
 @Fld_BseDeActiveTime,                  
 '',                  
 @Fld_NSEDeActiveBy,                  
 @Fld_NseDeActiveTime,                  
 '',                  
 '',                  
 '',                  
 ''               
)                  
end              
                 
 /*update Angel_AutoPayoutClientMaster                   
 set Fld_BSEDeActiveBy = @Fld_BSEDeActiveBy,                  
 Fld_BseDeActiveTime= @Fld_BseDeActiveTime,                  
 Fld_BSEDeActiveIp=@Fld_BSEDeActiveIp ,                  
 Fld_NSEDeActiveBy=@Fld_NSEDeActiveBy,                  
 Fld_NseDeActiveTime=@Fld_NseDeActiveTime,                  
 Fld_NSEDeActiveIp=@Fld_NSEDeActiveIp                   
 where Fld_SrNo = @Fld_SrNo  */                
                
if (select count(*) from Angel_AutoPayoutClientMaster (nolock) where Fld_SrNo = @Fld_SrNo) = 1                
begin                
if(select count(*) from Angel_AutoPayoutClientMaster (nolock) where Fld_BseActiveTime = 'Dec 31 2049' and  Fld_SrNo = @Fld_SrNo ) = 1                
begin                
if @bsechk = 'Y'                
begin                
update Angel_AutoPayoutClientMaster                
set                  
Fld_BSEActiveBy =   @Fld_BSEActiveBy,      
----megha
Fld_NSEActiveBy=@Fld_BSEActiveBy,          
---
Fld_BseActiveTime = @Fld_BseActiveTime,                
Fld_BSEActiveIp  = @Fld_BSEActiveIp                
where Fld_SrNo = @Fld_SrNo                
end                
end                
    
           
if(select count(*)from Angel_AutoPayoutClientMaster (nolock) where Fld_NseActiveTime = 'Dec 31 2049' and Fld_SrNo = @Fld_SrNo ) = 1                
begin                
if @nsechk = 'Y'                
begin                
update Angel_AutoPayoutClientMaster                
set                 
Fld_NSEActiveBy = @Fld_NSEActiveBy ,                  
Fld_NseActiveTime = @Fld_NseActiveTime,                  
Fld_NSEActiveIp = @Fld_NSEActiveIp               
where Fld_SrNo = @Fld_SrNo                 
end                
end                
end                
                
              
if (select count(*) from Angel_AutoPayoutClientMaster (nolock) where Fld_SrNo = @Fld_SrNo) = 1                
begin               
if(select count(*)from Angel_AutoPayoutClientMaster (nolock) where Fld_BseDeActiveTime = 'Dec 31 2049' and Fld_SrNo = @Fld_SrNo ) = 1                 
begin              
if @bserechk = 'Y'               
begin                
update Angel_AutoPayoutClientMaster                   
set                 
Fld_BSEDeActiveBy = @Fld_BSEDeActiveBy,    
---megha
Fld_NSEDeActiveBy=@Fld_BSEDeActiveBy,    
---
Fld_BseDeActiveTime= @Fld_BseDeActiveTime,                  
Fld_BSEDeActiveIp=@Fld_BSEDeActiveIp                 
where Fld_SrNo = @Fld_SrNo                 
end           
end     
    
    
if(select count(*)from Angel_AutoPayoutClientMaster (nolock) where Fld_NseDeActiveTime = 'Dec 31 2049' and Fld_SrNo = @Fld_SrNo ) = 1                    
begin              
if @nsedechk = 'Y'               
begin               
update Angel_AutoPayoutClientMaster                   
set                 
Fld_NSEDeActiveBy=@Fld_NSEDeActiveBy,                 
Fld_NseDeActiveTime=@Fld_NseDeActiveTime,                 
Fld_NSEDeActiveIp=@Fld_NSEDeActiveIp                 
where Fld_SrNo = @Fld_SrNo                 
end              
end               
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DB_TblSize
-- --------------------------------------------------

create procedure DB_TblSize

as



set nocount on



-- Table row counts and sizes.

CREATE TABLE #t 

( 

    [name] NVARCHAR(128),

    [rows] CHAR(11),

    reserved VARCHAR(18), 

    data VARCHAR(18), 

    index_size VARCHAR(18),

    unused VARCHAR(18)

) 



INSERT #t EXEC sp_msForEachTable 'EXEC sp_spaceused ''?''' 



SELECT *

FROM   #t



set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Exwise_ScripwisePosition_BSE
-- --------------------------------------------------
CREATE proc Exwise_ScripwisePosition_BSE  
(@settno varchar(12),@setttype varchar(2),@scripcode varchar(12))  
as  
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,   
SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END) AS RFROMEX,  
SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END) AS GIVE2EX,  
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))>0 THEN   
(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYOUT',  
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))<0 THEN   
-(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYIN' into #temp1  
FROM bsedb..DELIVERYCLT WHERE SETT_NO = @settno AND SETT_TYPE = @setttype AND SCRIP_CD = @scripcode  
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD  
  
select distinct Sett_no,Sett_type,a.scrip_cd,short_name as 'Scrip Name',rfromex as 'To Rec Fm Ex',give2ex as 'To Giv To Ex',[Net payout],[Net payin] from #temp1 a,  
bsedb..scrip1 b,bsedb..scrip2 c where a.scrip_cd=c.bsecode and c.co_code=b.co_code  
--settno=2007133 sett type=c scripcode=500087
--drop table #temp1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Exwise_ScripwisePosition_BSE_new
-- --------------------------------------------------
CREATE proc Exwise_ScripwisePosition_BSE_new    
(@settno varchar(12),@setttype varchar(2),@scripcode varchar(12),@access_to AS VARCHAR(11),@access_code AS VARCHAR(11))    
as    
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,     
SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END) AS RFROMEX,    
SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END) AS GIVE2EX,    
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))>0 THEN     
(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYOUT',    
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))<0 THEN     
-(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYIN' into #temp1    
FROM bsedb..DELIVERYCLT WHERE SETT_NO = @settno AND SETT_TYPE = @setttype AND SCRIP_CD = @scripcode    
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD    
    
select distinct Sett_no,Sett_type,a.scrip_cd,short_name as 'Scrip Name',rfromex as 'To Rec Fm Ex',give2ex as 'To Giv To Ex',[Net payout],[Net payin] from #temp1 a,    
bsedb..scrip1 b,bsedb..scrip2 c where a.scrip_cd=c.bsecode and c.co_code=b.co_code    
--settno=2007133 sett type=c scripcode=500087  
--drop table #temp1

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Exwise_ScripwisePosition_NSE
-- --------------------------------------------------
CREATE proc Exwise_ScripwisePosition_NSE      
(@settno varchar(12),@setttype varchar(2),@scripcode varchar(12))      
as    
    
SELECT SETT_NO,SETT_TYPE,SCRIP_CD,scrip_cd as 'Scrip Name',      
SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END) AS RFROMEX,      
SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END) AS GIVE2EX,      
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))>0 THEN       
(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYOUT',      
CASE WHEN (SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END))<0 THEN       
-(SUM(CASE WHEN INOUT = 'O' THEN QTY ELSE 0 END)-SUM(CASE WHEN INOUT = 'I' THEN QTY ELSE 0 END)) ELSE 0 END AS 'NET PAYIN' into #temp2     
FROM msajag..DELIVERYCLT WHERE SETT_NO = @settno AND SETT_TYPE = @setttype AND SCRIP_CD = @scripcode       
GROUP BY SETT_NO,SETT_TYPE,SCRIP_CD     
  
select  distinct Sett_no,Sett_type,a.scrip_cd,a.scrip_cd as 'Scrip Name',rfromex as 'To Rec Fm Ex',give2ex as 'To Giv To Ex',[Net payout],[Net payin] from #temp2 a   

--set SETT_NO = '2007185' AND SETT_TYPE = 'n' AND SCRIP_CD = 'rel'  

--drop table #temp2

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PP_HoldingDetails
-- --------------------------------------------------
CREATE Proc PP_HoldingDetails                     
@AccountId as Varchar(16)
as
set nocount on
SELECT Accountid,dpref5 as 'ISIN',DPSCCODE ,DPCLCODE,SUM(DPQTY) as 'HOLDING'
FROM mimansa.bits.dbo.ANGELDPTRAN WHERE ACCOUNTID = @AccountId 
AND ((DPTRFTAG = ''  AND DPFLAG = 'G') OR (DPTRFTAG = 'T'  AND DPFLAG = 'G'))
group by Accountid,dpref5,DPSCCODE ,DPCLCODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rcs_Allocation
-- --------------------------------------------------
CREATE procedure rcs_Allocation
as                   
          
SET NOCOUNT ON                                
                                
DECLARE                                 
@party_Code varchar(10),                                 
@isin varchar(20),                                 
@Previsin varchar(20),                                 
@qty int,
@Pqty int,
@pledgeQty int,
@scrip_cd varchar(10),
@clsrate money,
@Client_Net money,
@RunClientNet money,
@ScpBankHold int,
@RunScpBankHold int,
@ScpTotal int
                              
update rcs_bsensedr1 set RunScpBankHold=0
update rcs_bsensedr1 set RunClientNet=0
update rcs_bsensedr1 set fld_pledgeQty=0

update rcs_bsensedr1 set RunClientNet=b.ClientNet from
(select distinct party_Code,ClientNet from rcs_bsensedr1 (nolock)) b
where rcs_bsensedr1.party_code=b.party_code


DECLARE error_cursor CURSOR FOR                                 
select party_code,ISIN,qty,fld_Pledgeqty,scrip_cd,cls_rate,ClientNet,RunClientNet,ScpBankHold,RunScpBankHold
from rcs_bsensedr1 (nolock) 
/*where scrip_cd in ('500440','532121') */
order by scrip_Cd,clientNet                                
OPEN error_cursor                                
                                
FETCH NEXT FROM error_cursor                                 
INTO @party_Code,@isin,@qty,@pledgeQty,@scrip_cd,@clsrate,@Client_Net,@RunClientNet,@ScpBankHold,@RunScpBankHold                                 
       
set @ScpTotal=0
set @ScpTotal=@scpBankHold
set @Previsin=space(15)           
               
WHILE @@FETCH_STATUS = 0                                
BEGIN 

	set @Pqty=0
	if @Previsin <> @Isin 
	begin
		set @ScpTotal=@scpBankHold
	end

	if (@scpTotal >= 0)
	begin
		
		if ((@qty*@clsrate) < @RunClientNet*-1)		
		begin
			set @Pqty=@qty	
		end
		else
		begin
			set @Pqty=floor((@RunClientNet*-1)/@clsrate)
		end
		

		set @scpTotal=@scpTotal-@Pqty

		if @scpTotal < 0 
		begin
			set @Pqty=@Pqty+@scpTotal
			set @scpTotal=0
		end

		update rcs_bsensedr1 set RunScpBankHold=@scpTotal, Fld_PledgeQty=@Pqty
		where party_Code=@party_Code and isin=@isin
		
		update rcs_bsensedr1 set RunClientNet=((@RunClientNet*-1)-(@Pqty*@clsrate))*-1
		where party_Code=@party_code and fld_pledgeQty =0		

	end
 
	set @PrevIsin=@Isin 

	FETCH NEXT FROM error_cursor                                 
INTO @party_Code,@isin,@qty,@pledgeQty,@scrip_cd,@clsrate,@Client_Net,@RunClientNet,@ScpBankHold,@RunScpBankHold                                 

	
END                               
                                
CLOSE error_cursor             
DEALLOCATE error_cursor

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rcs_nseinsp_ledger
-- --------------------------------------------------
CREATE proc [dbo].[rcs_nseinsp_ledger] (@RptDate as varchar(11))
as

--declare @RptDate as varchar(11)    
--set @RptDate = '19/06/2009'              
-----------------------T-2 Day Billing Ledger      19-06-2009                   
select distinct Fld_party_Code=party_code into #x from    certificate_clt
--select  *from  #x

select cltcode,                         
[T-2 Day Bal] =                        
sum                        
(                        
case                    
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #rcsT2Bal                         
from ANGELBSECM.account_ab.dbo.ledger x             
where vdt >='Apr  1 2009 00:00:00' and edt <= CONVERT(DATETIME,@RptDate,103) + ' 23:59:59'
--and cltcode='m709'
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                         
group by cltcode                        
                         
-----------------------T Day Recipt/Payment      19-06-2009                  
                  
select cltcode,                         
TDay_PaymentRecipt =                  
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #rcsT1PRData                         
from ANGELBSECM.account_ab.dbo.ledger x             
where vdt >=convert(datetime,@RptDate,103) and vdt <= convert(datetime,@RptDate,103)+' 23:59:59' and vtyp in (2,3) 
--and cltcode='m709'                                           
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )and vtyp in (2,3)                         
group by cltcode                                  
              
-------------------T-1 Payment Receipt             18-06-2009                 
select cltcode,                         
T1Day_PaymentRecipt =                        
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
--into #T1DR                    
into #rcsT_1PRData                    
from ANGELBSECM.account_ab.dbo.ledger x           
where vdt>= convert(datetime,@RptDate,103)-1                         
and vdt <= convert(datetime,@RptDate,103)-1+' 23:59:59'
--and cltcode='m709'
 and vtyp in (2,3)  
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )
group by cltcode                        
              
-------------------------------MG 02 T Day          17-06-2009         
                  
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@RptDate,103)) = 0                  
begin*/                  
                  
 select party_code,                        
 MG02TDay=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                  
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                        
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #rcsMG02TDay from ANGELBSECM.bsedb_ab.dbo.tbl_mg02_his x 
where margin_date >=convert(datetime,@RptDate,103)-2 and margin_date <=convert(datetime,@RptDate,103)-2+' 23:59:59'
and exists ( select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code )
 GROUP BY party_code                     
                  
/* 
end                  
else                  
begin                  
                  
 select party_code,                        
 MG02TDay=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                  
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                        
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02TDay from anand1.msajag.dbo.TBL_MG02_his where margin_date = @RptDate                      
 GROUP BY party_code                   
                  
end*/                  
                  
-------------------------------MG 02 T - 1 Day         18-06-2009             
                  
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@Second_day,103)) = 0                  
begin*/                  
                  
 select party_code,                        
 MG02T1Day=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                       
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                  
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
into  #rcsMG02T1Day 
from ANGELBSECM.bsedb_aB.dbo.TBL_MG02_his x
where margin_date >=convert(datetime,@RptDate,103)-1 and margin_date <=convert(datetime,@RptDate,103)-1+' 23:59:59'                       
and exists ( select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code )
 GROUP BY party_code                        
/*                  
end                        
else                  
begin                  
 select party_code,                        
 MG02T1Day=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                       
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                  
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02T1Day from anand1.msajag.dbo.tbl_mg02_his where margin_date = convert(datetime,@Second_day,103)                        
 GROUP BY party_code                        
end   */                  





---------------NSE------------         
            
-----------------------T-2 Day Billing Ledger                         
            
select cltcode,                         
[T-2 Day Bal] =                        
sum                        
(                        
case                    
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #T2Bal                         
from anand1.account.dbo.ledger x             
where vdt >='Apr  1 2009 00:00:00' and edt <= CONVERT(DATETIME,@RptDate,103) + ' 23:59:59'
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                         
group by cltcode                       
                         
-----------------------T Day Recipt/Payment                        
                  
select cltcode,                         
TDay_PaymentRecipt =                  
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #T1PRData                         
from anand1.account.dbo.ledger x             
where vdt >=convert(datetime,@RptDate,103) and vdt <= convert(datetime,@RptDate,103)+' 23:59:59' and vtyp in (2,3)                                           
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )and vtyp in (2,3)                         
group by cltcode                                  
              
-------------------T-1 Payment Receipt                              
select cltcode,                         
T1Day_PaymentRecipt =                        
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
--into #T1DR                    
into #T_1PRData                    
from anand1.account.dbo.ledger x           
where vdt>= convert(datetime,@RptDate,103)-1                         
and vdt <= convert(datetime,@RptDate,103)-1+' 23:59:59' and vtyp in (2,3)
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )
group by cltcode                        
              
-------------------------------MG 02 T Day                   
                  
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@RptDate,103)) = 0                  
begin*/                  
                  
 select party_code,                        
 MG02TDay=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                  
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                        
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02TDay from anand1.msajag.dbo.tbl_mg02_his x
where margin_date >=convert(datetime,@RptDate,103)-2 and margin_date <=convert(datetime,@RptDate,103)-2+' 23:59:59'  
and exists ( select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code )                 
 GROUP BY party_code                     
                  
/*                  
end                  
else                  
begin                  
                  
 select party_code,                        
 MG02TDay=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                  
 WHEN SUM(MTOM+VARAMT) < 0  THEN  0                        
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02TDay from anand1.msajag.dbo.TBL_MG02_his where margin_date = @RptDate                      
 GROUP BY party_code                   
                  
end*/                  
                  
-------------------------------MG 02 T - 1 Day                      
                  
/*if(select count(*) from anand1.msajag.dbo.TBL_MG02 where margin_date = convert(datetime,@Second_day,103)) = 0                  
begin*/                  
                  
 select party_code,                        
 MG02T1Day=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                       
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                  
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02T1Day from anand1.msajag.dbo.TBL_MG02_his x
where margin_date >=convert(datetime,@RptDate,103)-1 and margin_date <=convert(datetime,@RptDate,103)-1+' 23:59:59' 
and exists ( select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code )                     
 GROUP BY party_code                        
/*                  
end                        
else                  
begin                  
 select party_code,                        
 MG02T1Day=CASE                         
 WHEN SUM(MTOM+VARAMT) > 0  THEN convert(dec(10,2),SUM(MTOM+VARAMT))                       
 WHEN SUM(MTOM+VARAMT) < 0  THEN 0                  
 else CONVERT(VARCHAR,SUM(MTOM+VARAMT)) end                        
 into  #MG02T1Day from anand1.msajag.dbo.tbl_mg02_his where margin_date = convert(datetime,@Second_day,103)                        
 GROUP BY party_code                        
end   */                  
                        
-----------------------------T-1 FO Ledger  19         
        
select cltcode,                         
[FO T-1 Day Bal] =                        
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #FOT1Bal                         
from ANGELFO.ACCOUNTFO.DBO.ledger  x            
where vdt >='Apr 1 2009 00:00:00' and edt <= convert(datetime,@RptDate,103)+ ' 23:59:59'  
--and cltcode='m709'                    
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )                         
group by cltcode                        
                        
-----------------------FO T Day Recipt/Payment     19              
                  
select cltcode,                         
FOTDay_PaymentRecipt =                        
sum                        
(                        
case                         
when drcr = 'C' then vamt                         
when drcr = 'D' then vamt*-1 end                         
)                        
into #FOTPRData                         
from ANGELFO.ACCOUNTFO.DBO.ledger   x           
where vdt >=convert(datetime,@RptDate,103) and vdt <=convert(datetime,@RptDate,103)+' 23:59:59'
--and cltcode='m709'  
and vtyp in (2,3)                                                                                
and exists ( select Fld_party_Code from #x y where x.cltcode = y.Fld_party_Code )and vtyp in (2,3)                         
group by cltcode                            
              
                        
-------------------------------Fo Margin Ledger       18                       
                        
SELECT                         
Party_code,                        
Amount=                        
sum(case when drcr = 'D' then Amount*-1                        
when drcr = 'C' then Amount end)                        
into #FoBal FROM ANGELFO.ACCOUNTFO.DBO.MarginLedger x where                         
Vdt >= 'apr 1 2009' and Vdt <= convert(datetime,@RptDate,103)-1+' 23:59:59' 
---and Party_code='m709'
and exists ( select Fld_party_Code from #x y where x.Party_code = y.Fld_party_Code )
and vtyp in (2,3)                         
group by Party_code                        
                        
                        
select Party_code,                        
T1DayFoBal=case                         
when Amount < 0 then Amount                  
when Amount > 0 then Amount*-1 else Amount end                        
into #T1FOBal                        
from #FoBal                        
-------------------------------margin   19

                
select party_code,initialmargin,MTMMargin,cash_coll,noncash_coll into #FoMargin 
from ANGELFO.PRADNYA.DBO.HISTORY_TBL_CLIENTMARGIN_NSEFO x 
where margindate >=convert(datetime,@RptDate,103) and  margindate <=convert(datetime,@RptDate,103)+' 23:59:59'
--and Party_code='m709' 
and exists (select Fld_party_Code from #x y where x.party_code = y.Fld_party_Code)                         

        
                       
select a.*,[T-2 Day Bal]=isnull(b.[T-2 Day Bal],0),                        
TDay_PaymentRecipt=isnull(c.TDay_PaymentRecipt,0),                        
T1Day_PaymentRecipt=isnull(d.T1Day_PaymentRecipt,0),MG02TDay=isnull(MG02TDay,0),                        
MG02T1Day=isnull(MG02T1Day,0),                        
[FO T-1 Day Bal]=isnull(g.[FO T-1 Day Bal],0),                        
FOTDay_PaymentRecipt=isnull(FOTDay_PaymentRecipt,0),                        
Amount=isnull(Amount,0),                        
initialmargin=isnull(initialmargin,0),                        
MTMMargin=isnull(MTMMargin,0)                        
into #rpt from                        
(select * from #x)a                        
left outer join                        
(select cltcode,[T-2 Day Bal]=isnull([T-2 Day Bal],0) from #T2Bal)b                        
on a.Fld_Party_Code = b.cltCode                        
left outer join                        
(select * from #T1PRData)c                        
on a.Fld_Party_Code = c.cltCode                        
left outer join                        
(select * from #T_1PRData)d                        
on a.Fld_Party_Code = d.cltCode                        
left outer join                        
(select * from #MG02TDay)e                        
on a.Fld_Party_Code = e.party_code                        
left outer join                        
(select * from #MG02T1Day)f                        
on a.Fld_Party_Code = f.party_code                        
left outer join                        
(select * from #FOT1Bal)g                        
on a.Fld_Party_Code = g.cltCode                   
left outer join                        
(select * from #FOTPRData)h                        
on a.Fld_Party_Code = h.cltCode                        
left outer join                        
(select * from #FoBal)i                        
on a.Fld_Party_Code = i.party_code                        
left outer join                        
(select * from #FoMargin)j                        
on a.Fld_Party_Code = j.party_code                        
                    
select                   
CurrDate,Fld_party_Code,                  
TotalPledgeValue=PledgeValue,                  
ClientPledgeValue=ClientValue,                  
[CMLedgerT-2]=[T-2 Day Bal],                  
TDay_PaymentRecipt,                  
T1Day_PaymentRecipt,                  
MG02TDay,                  
MG02T1Day,                  
CM_Free_Bal=[T-2 Day Bal]+TDay_PaymentRecipt+T1Day_PaymentRecipt-MG02TDay-MG02T1Day,                  
[FO T-1 Day Bal],                  
FOTDay_PaymentRecipt,                  
FoMarginLedger=Amount,                  
initialmargin,                  
ExposureMargin=MTMMargin,                  
FO_Free_Bal=([FO T-1 Day Bal]+FOTDay_PaymentRecipt+Amount-initialmargin-MTMMargin)                  
into #pt1 from #rpt                    
            
  
                  
--select *,NetObligation=case when (CM_Free_Bal+FO_Free_Bal) > 0 then 0 else (CM_Free_Bal+FO_Free_Bal) end into #pt2
--from #pt1                  
  
  
--update #pt2 set clientPledgeValue=b.Actual_value/2 from   
--(  
--select party_code,Actual_value=sum(total)    
--from holding09112007 where scrip_cd in (select scode from intranet.risk.dbo.icici_scp)  
--and accno <> ''  
--group by party_code  
--) b where #pt2.fld_party_Code=b.party_Code  
         




   
--truncate table tbl_NSECertificate_09112007             
--            
--insert into tbl_NSECertificate_09112007            
--select *,ValueImproperUse=case when (ClientPledgeValue+NetObligation) < 0 then 0 else (ClientPledgeValue+NetObligation) end,0 from #pt2                  
--            
--select cltcode, balance=sum(case when drcr = 'C' then vamt else vamt*-1 end)             
--into #bsebal            
--from ANGELBSECM.account_Ab.dbo.ledger where            
--vdt >='Apr  1 2009 00:00:00' and vdt <='Nov  9 2007 23:59:59'            
--group by cltcode            
--            
--update tbl_NSECertificate_09112007 set bse_balance=b.balance            
--from #bsebal b where tbl_NSECertificate_09112007.fld_partycode=b.cltcode

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
-- PROCEDURE dbo.Rpt_AngelBSeshortage
-- --------------------------------------------------
CREATE Procedure [dbo].[Rpt_AngelBSeshortage] (@Fromsett_no Varchar(10),@Tosett_no Varchar(10),@Level Varchar(10) )        
as        
    
--Truncate Table angelinhouse.dbo.TempAngelShortage          
--DELETE angelinhouse.dbo.TempAngelShortage          
  
        
--Insert into angelinhouse.dbo.TempAngelShortage 
If @Level = 'Part1'
Begin        
Select ExchangeSegment = 'BSECM', D.sett_no,D.sett_type, Branch_cd =  '', Sub_broker =  '',d.party_code, d.Scrip_cd,d.Series,d.inout,d.Qty,Scripname=s2.scrip_cd,IsIn = Mi.Isin,        
 RecQty = Case When d.Sett_Type = 'C' And InOut = 'O' Then 0 Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End,        
 GivenQty = Case When d.Sett_Type = 'C' And InOut = 'I' Then Sum((Case When DrCr = 'D' And Reason Like 'EXC%' Then IsNull(De.Qty,0) Else 0 End)) Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) end  ,Rate = 0 /*H.rate*/ ,ReportDate = GetDate()        
 From AngelDemat.Bsedb.dbo.Scrip2 S2,  AngelDemat.BseDb.Dbo.MultiIsiN MI,        
             AngelDemat.BseDb.Dbo.Deliveryclt D Left Outer Join AngelDemat.Bsedb.dbo.DelTrans De        
 On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD        
 And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series and filler2 = 1         
             And ShareType Not Like (case when d.sett_type not in ('A','X','AD','AC') then  'AUCTION' else '' End))        
             Where  S2.bsecode = D.scrip_cd          
             And d.sett_no between @fromsett_no And @ToSett_no  and d.sett_type In ('C','D')         
             And Mi.Scrip_Cd = D.Scrip_cd        
             And Mi.Series = D.Series        
             And Mi.Valid = 1        
             Group by d.sett_no,d.sett_type,d.scrip_cd,d.series, d.party_code,d.inout,s2.scrip_cd,D.Qty ,Mi.IsIn         
     
End   
--Insert Into angelinhouse.dbo.TempAngelShortage         

If @Level = 'Part2'
Begin
Select  ExchangeSegment = 'BSECM', d.sett_no,d.sett_type,  Branch_cd = '', Sub_Broker =  '',d.party_code,d.Scrip_cd,d.Series,inout='I',Qty=0,Scripname=s2.scrip_cd,IsIn = Mi.Isin,        
 RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),        
 GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End)) , Rate = 0 , ReportDate = GetDate()        
 From AngelDemat.Bsedb.Dbo.Scrip2 S2,   AngelDemat.Bsedb.Dbo.MultiIsiN MI, AngelDemat.Bsedb.Dbo.DelTrans D        
 Where  s2.bsecode = d.scrip_cd          
                      
 And d.sett_no Between @FromSett_no and @ToSett_no          
             And d.sett_type In ('C','D')        
             And Mi.Scrip_Cd = D.Scrip_cd        
             And Mi.Series = D.Series        
             And Mi.Valid = 1        
             And Filler2 = 1        
 And d.Party_code Not In ( Select Party_Code From AngelDemat.Bsedb.Dbo.DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD        
 And De.Party_Code = D.Party_Code And De.Series = D.Series )         
                     
              Group by d.sett_no,d.sett_type,d.scrip_cd,d.series,  d.party_code,S2.Scrip_cd ,Mi.Isin      
      
   End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_AngelBSeshortage1
-- --------------------------------------------------
CREATE Procedure [dbo].[Rpt_AngelBSeshortage1] (@Fromsett_no Varchar(10),@Tosett_no Varchar(10),@Level Varchar(10) )        
as        
If @Level = 'Part1'
Begin        
Select ExchangeSegment = 'BSECM', D.sett_no,D.sett_type, Branch_cd =  '', Sub_broker =  '',d.party_code, d.Scrip_cd,d.Series,d.inout,d.Qty,Scripname=s2.scrip_cd,IsIn = Mi.Isin,    
 RecQty = Case When d.Sett_Type = 'C' And InOut = 'O' Then 0 Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End,    
 GivenQty = Case When d.Sett_Type = 'C' And InOut = 'I' Then Sum((Case When DrCr = 'D' And Reason Like 'EXC%' Then IsNull(De.Qty,0) Else 0 End)) Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) end  ,Rate = 0 /*H.rate*/ ,ReportDate = GetDate()    
 From Bsedb.Dbo.Scrip2 S2,  Bsedb.Dbo.MultiIsiN MI,    
             Bsedb.Dbo.Deliveryclt D Left Outer Join Bsedb.Dbo.DelTrans De    
 On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD    
 And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series and filler2 = 1     
             And ShareType Not Like (case when d.sett_type not in ('A','X','AD','AC') then  'AUCTION' else '' End))    
             Where  S2.bsecode = D.scrip_cd      
             And d.sett_no between @FromSett_no And @ToSett_no  and d.sett_type In ('C','D')     
             And Mi.Scrip_Cd = D.Scrip_cd    
             And Mi.Series = D.Series    
             And Mi.Valid = 1    
             Group by d.sett_no,d.sett_type,d.scrip_cd,d.series, d.party_code,d.inout,s2.scrip_cd,D.Qty ,Mi.IsIn  
End

If @Level = 'Part2'
Begin  
Select ExchangeSegment = 'BSECM', d.sett_no,d.sett_type,  Branch_cd = '', Sub_Broker =  '',d.party_code,d.Scrip_cd,d.Series,inout='I',Qty=0,Scripname=s2.scrip_cd,IsIn = Mi.Isin,    
 RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),    
 GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End)) , Rate = 0 , ReportDate = GetDate()    
 From Bsedb.Dbo.Scrip2 S2,Bsedb.Dbo.MultiIsiN MI,Bsedb.Dbo.DelTrans D    
 Where  s2.bsecode = d.scrip_cd      
                  
 And d.sett_no Between @FromSett_no and @ToSett_no      
             And d.sett_type In ('C','D')    
             And Mi.Scrip_Cd = D.Scrip_cd    
             And Mi.Series = D.Series    
             And Mi.Valid = 1    
             And Filler2 = 1    
 And d.Party_code Not In ( Select Party_Code From Bsedb.Dbo.DeliveryClt_Report De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD    
 And De.Party_Code = D.Party_Code And De.Series = D.Series )     
                 
              Group by d.sett_no,d.sett_type,d.scrip_cd,d.series,  d.party_code,S2.Scrip_cd ,Mi.Isin
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_bse_Delpayinmatch
-- --------------------------------------------------
CREATE Proc Rpt_bse_Delpayinmatch            
(@StatusId Varchar(15),        
 @Statusname Varchar(25),        
 @Sett_No Varchar(7),         
 @Sett_Type Varchar(2),         
 @BranchCd Varchar(10),        
@Opt int) AS                                    
truncate table delpayinmatch_bse                     
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                      
              
Select * Into #DeliveryClt From bsedb..DeliveryClt              
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type              
And InOut = 'I'              
              
Select * Into #Deltrans From bsedb..Deltrans              
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type              
And Party_Code <> 'BROKER' And Drcr = 'C'                                       
And Filler2 = 1 And Sharetype <> 'Auction'              
And TrType <> 906              
           
          
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker              
INTO #CLIENT FROM bsedb.dbo.CLIENT1 C1, bsedb..CLIENT2 C2            
WHERE C1.CL_CODE = C2.CL_CODE            
And @StatusName =                                 
                  (case                                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                                
                        when @StatusId = 'Trader' then c1.Trader                                
                        when @StatusId = 'Family' then c1.Family                                
                        when @StatusId = 'Area' then c1.Area                                
                        when @StatusId = 'Region' then c1.Region                                
                        when @StatusId = 'Client' then c2.party_code                                
                  else                                 
                        'BROKER'                                
                  End)             
AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)            
            
set transaction isolation level read uncommitted                          
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),         
Isettqty = 0, Ibenqty = 0,Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0,         
Nsehold = 0, Nsepledge = 0, Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker              
Into #delpayinmatch                                      
From #CLIENT C1, bsedb..Multiisin M (nolock) , #Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                       
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                      
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                       
And D.Party_Code = C.Party_Code And Drcr = 'C'                                       
And Filler2 = 1 And Sharetype <> 'Auction')                                      
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                      
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                      
And C1.Party_Code = D.Party_Code                                  
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                     
Having D.Qty > 0                                       
              
If @Opt <> 1               
Begin              
 Delete From #delpayinmatch Where Delqty <= Recqty              
End              
              
set transaction isolation level read uncommitted                          
Insert Into #delpayinmatch                                      
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                      
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                      
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),             
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                       
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                       
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                      
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                      
From bsedb..Deltrans D (nolock), #Client C1 (nolock)            
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                      
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                      
And C1.Party_Code = D.Party_Code                                  
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker              
                          
set transaction isolation level read uncommitted                          
Insert Into #delpayinmatch                                      
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                      
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                      
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                       
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                       
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                       
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                      
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,              
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                      
From Msajag.Dbo.Deltrans D, #Client C1            
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                      
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                      
And C1.Party_Code = D.Party_Code                                  
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker              
              
set transaction isolation level read uncommitted                                      
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                         
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                      
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                      
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From bsedb..Deltrans D (nolock), bsedb..Deliverydp Dp             (nolock)                          
Where Filler2 = 1 And Drcr = 'D'                                       
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                       
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code             
And A.Certno = #delpayinmatch.Certno                                      
                
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                         
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                      
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),           
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D, Msajag.Dbo.Deliverydp Dp                         
Where Filler2 = 1 And Drcr = 'D'                         
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                            
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                       
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                      
                  
Update #delpayinmatch Set Scrip_Cd = /*S2.Scrip_Cd + ' ( ' +*/ M.Scrip_Cd/* + ' )'      */        
From bsedb..Scrip2 S2, bsedb..MultiIsIn M              
Where S2.BseCode = M.Scrip_Cd              
And M.IsIn = CertNo              
              
If Upper(@Branchcd) = 'All'                                       
begin                          
 Select @Branchcd = '%'                                
end                          
If @Opt = 1                          
begin                          
 set transaction isolation level read uncommitted                                       
        
INSERT INTO delpayinmatch_bse                                     
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                      
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                      
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                      
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,        
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING        
 From #delpayinmatch R                                 
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                       
 And Branch_Cd Like @Branchcd               
 Group By Sett_No, Sett_Type, Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                       
 Having Sum(Delqty) > 0                                       
 Order By Branch_Cd, R.Party_Code, Scrip_Cd                                       
end                          
Else                          
begin                                      
INSERT INTO delpayinmatch_bse                                     
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                      
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                      
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                      
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,        
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING        
        
 From #delpayinmatch R (nolock)              
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                       
 And Branch_Cd Like @Branchcd                             
 Group By Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                      
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                       
 Order By Branch_Cd, R.Party_Code, Scrip_Cd           
                    
end              
  
--SELECT * FROM delpayinmatch_bse      
update delpayinmatch_bse      
set delpayinmatch_bse.poa = 'Yes',delpayinmatch_bse.cltdpno = bsedb..multicltid.cltdpno      
from delpayinmatch_bse,bsedb..multicltid      
where delpayinmatch_bse.party_code = bsedb..multicltid.party_code and bsedb..multicltid.def = 1      
       
select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS   
into #bse_poa_shortage      
from delpayinmatch_bse A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B      
WHERE HLD_AC_TYPE = 11      
AND POA = 'YES' AND CLTDPNO = HLD_AC_CODE AND CERTNO = HLD_ISIN_CODE      
      
select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,C.SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA     
from  #bse_poa_shortage A,BSEDB..SCRIP2 B,BSEDB..SCRIP1 C
WHERE A.SCRIP_CD=B.BSECODE AND B.CO_CODE=C.CO_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_bse_Delpayinmatch_new
-- --------------------------------------------------
CREATE Proc Rpt_bse_Delpayinmatch_new              
(@StatusId Varchar(15),          
 @Statusname Varchar(25),          
 @Sett_No Varchar(7),           
 @Sett_Type Varchar(2),           
 @BranchCd Varchar(10),          
@Opt int,
@access_to as varchar(11),
@access_code as varchar(11)) AS                                      
truncate table delpayinmatch_bse                       
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                        
                
Select * Into #DeliveryClt From bsedb..DeliveryClt                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And InOut = 'I'                
                
Select * Into #Deltrans From bsedb..Deltrans                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And Party_Code <> 'BROKER' And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction'                
And TrType <> 906                
             
            
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
INTO #CLIENT FROM bsedb.dbo.CLIENT1 C1, bsedb..CLIENT2 C2              
WHERE C1.CL_CODE = C2.CL_CODE              
And @StatusName =                                   
                  (case                                   
                        when @StatusId = 'BRANCH' then c1.branch_cd                                  
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                                  
                        when @StatusId = 'Trader' then c1.Trader                                  
                        when @StatusId = 'Family' then c1.Family                                  
                        when @StatusId = 'Area' then c1.Area                                  
                        when @StatusId = 'Region' then c1.Region                                  
                        when @StatusId = 'Client' then c2.party_code                                  
                  else                                   
                        'BROKER'                                  
                  End)               
AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)              
              
set transaction isolation level read uncommitted                            
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),           
Isettqty = 0, Ibenqty = 0,Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0,           
Nsehold = 0, Nsepledge = 0, Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
Into #delpayinmatch                                        
From #CLIENT C1, bsedb..Multiisin M (nolock) , #Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                         
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                        
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                         
And D.Party_Code = C.Party_Code And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction')                                        
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                        
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                       
Having D.Qty > 0                                         
                
If @Opt <> 1                 
Begin                
 Delete From #delpayinmatch Where Delqty <= Recqty                
End                
                
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),               
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From bsedb..Deltrans D (nolock), #Client C1 (nolock)              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                            
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From Msajag.Dbo.Deltrans D, #Client C1              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                
set transaction isolation level read uncommitted                                        
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                        
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From bsedb..Deltrans D (nolock), bsedb..Deliverydp Dp             (nolock)                            
Where Filler2 = 1 And Drcr = 'D'                                         
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                         
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'            
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code               
And A.Certno = #delpayinmatch.Certno                                        
                  
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),             
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D, Msajag.Dbo.Deliverydp Dp                           
Where Filler2 = 1 And Drcr = 'D'                           
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                              
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                         
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                        
                    
Update #delpayinmatch Set Scrip_Cd = /*S2.Scrip_Cd + ' ( ' +*/ M.Scrip_Cd/* + ' )'      */          
From bsedb..Scrip2 S2, bsedb..MultiIsIn M                
Where S2.BseCode = M.Scrip_Cd                
And M.IsIn = CertNo                
                
If Upper(@Branchcd) = 'All'                                         
begin                            
 Select @Branchcd = '%'                                  
end                            
If @Opt = 1                            
begin                            
 set transaction isolation level read uncommitted                                         
          
INSERT INTO delpayinmatch_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
 From #delpayinmatch R                                   
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                 
 Group By Sett_No, Sett_Type, Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                         
 Having Sum(Delqty) > 0                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd                                         
end                            
Else                            
begin                                        
INSERT INTO delpayinmatch_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
          
 From #delpayinmatch R (nolock)                
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                               
 Group By Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                      
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd             
                      
end                
    
--SELECT * FROM delpayinmatch_bse        
update delpayinmatch_bse        
set delpayinmatch_bse.poa = 'Yes',delpayinmatch_bse.cltdpno = bsedb..multicltid.cltdpno        
from delpayinmatch_bse,bsedb..multicltid        
where delpayinmatch_bse.party_code = bsedb..multicltid.party_code and bsedb..multicltid.def = 1        
         
select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS     
into #bse_poa_shortage        
from delpayinmatch_bse A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B        
WHERE HLD_AC_TYPE = 11        
AND POA = 'YES' AND CLTDPNO = HLD_AC_CODE AND CERTNO = HLD_ISIN_CODE        
        
select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,C.SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA       
from  #bse_poa_shortage A,BSEDB..SCRIP2 B,BSEDB..SCRIP1 C  
WHERE A.SCRIP_CD=B.BSECODE AND B.CO_CODE=C.CO_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_bse_Delpayinmatch_Scripwise
-- --------------------------------------------------

create Proc Rpt_bse_Delpayinmatch_Scripwise
(@StatusId Varchar(15),      
 @Statusname Varchar(25),      
 @Sett_No Varchar(7),       
 @Sett_Type Varchar(2),       
 @BranchCd Varchar(10),      
@Opt int) AS                                  
truncate table delpayinmatch_bse_scripwise
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                    
            
Select * Into #DeliveryClt From bsedb..DeliveryClt            
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type            
And InOut = 'I'            
            
Select * Into #Deltrans From bsedb..Deltrans            
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type            
And Party_Code <> 'BROKER' And Drcr = 'C'                                     
And Filler2 = 1 And Sharetype <> 'Auction'            
And TrType <> 906            
         
        
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker            
INTO #CLIENT FROM bsedb.dbo.CLIENT1 C1, bsedb..CLIENT2 C2          
WHERE C1.CL_CODE = C2.CL_CODE          
And @StatusName =                               
                  (case                               
                        when @StatusId = 'BRANCH' then c1.branch_cd                              
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                              
                        when @StatusId = 'Trader' then c1.Trader                              
                        when @StatusId = 'Family' then c1.Family                              
                        when @StatusId = 'Area' then c1.Area                              
                        when @StatusId = 'Region' then c1.Region                              
                        when @StatusId = 'Client' then c2.party_code                              
                  else                               
                        'BROKER'                              
                  End)           
AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)          
          
set transaction isolation level read uncommitted                        
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),       
Isettqty = 0, Ibenqty = 0,Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0,       
Nsehold = 0, Nsepledge = 0, Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker            
Into #delpayinmatch                                    
From #CLIENT C1, bsedb..Multiisin M (nolock) , #Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                     
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                    
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                     
And D.Party_Code = C.Party_Code And Drcr = 'C'                                     
And Filler2 = 1 And Sharetype <> 'Auction')                                    
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                    
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                    
And C1.Party_Code = D.Party_Code                                
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                   
Having D.Qty > 0                                     
            
If @Opt <> 1             
Begin            
 Delete From #delpayinmatch Where Delqty <= Recqty            
End            
            
set transaction isolation level read uncommitted                        
Insert Into #delpayinmatch                                    
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                    
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                    
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),           
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                     
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                     
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                    
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,            
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                    
From bsedb..Deltrans D (nolock), #Client C1 (nolock)          
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                    
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                    
And C1.Party_Code = D.Party_Code                                
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker            
                        
set transaction isolation level read uncommitted                        
Insert Into #delpayinmatch                                    
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                    
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                    
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                     
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                     
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                     
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                    
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,            
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                    
From Msajag.Dbo.Deltrans D, #Client C1          
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                    
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                    
And C1.Party_Code = D.Party_Code                                
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker            
            
set transaction isolation level read uncommitted                                    
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                       
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                    
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From bsedb..Deltrans D (nolock), bsedb..Deliverydp Dp             (nolock)                        
Where Filler2 = 1 And Drcr = 'D'                                     
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                     
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                     
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code           
And A.Certno = #delpayinmatch.Certno                                    
                                    
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                       
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                    
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),         
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D, Msajag.Dbo.Deliverydp Dp                       
Where Filler2 = 1 And Drcr = 'D'                       
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                          
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                     
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                    
                
Update #delpayinmatch Set Scrip_Cd = /*S2.Scrip_Cd + ' ( ' +*/ M.Scrip_Cd/* + ' )'      */      
From bsedb..Scrip2 S2, bsedb..MultiIsIn M            
Where S2.BseCode = M.Scrip_Cd            
And M.IsIn = CertNo            
            
If Upper(@Branchcd) = 'All'                                     
begin                        
 Select @Branchcd = '%'                              
end                        
If @Opt = 1                        
begin                        
 set transaction isolation level read uncommitted                                     
      
INSERT INTO delpayinmatch_bse_scripwise
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                    
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                    
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                    
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge
 From #delpayinmatch R                               
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                     
 And Branch_Cd Like @Branchcd             
 Group By Sett_No, Sett_Type, Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                     
 Having Sum(Delqty) > 0                                     
 Order By Branch_Cd, R.Party_Code, Scrip_Cd                                     
end                        
Else                        
begin                                    
INSERT INTO delpayinmatch_bse_scripwise
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                    
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                    
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                    
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge
 From #delpayinmatch R (nolock)            
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                     
 And Branch_Cd Like @Branchcd                           
 Group By Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                    
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                     
 Order By Branch_Cd, R.Party_Code, Scrip_Cd         
                
end            
select * from delpayinmatch_bse_scripwise order by scrip_cd,party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_bse_shortagenholding
-- --------------------------------------------------
CREATE Proc Rpt_bse_shortagenholding           
(
@StatusId Varchar(15),          
 @Statusname Varchar(25),          
 @Sett_No Varchar(7),           
 @Sett_Type Varchar(2),           
 @BranchCd Varchar(10),          
@Opt int
) AS                                      
--truncate table shortagenholding_bse                       
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                        
                
Select * Into #DeliveryClt From bsedb..DeliveryClt                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And InOut = 'I'                
                
Select * Into #Deltrans From bsedb..Deltrans                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And Party_Code <> 'BROKER' And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction'                
And TrType <> 906                
             
            
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
INTO #CLIENT FROM bsedb.dbo.CLIENT1 C1, bsedb..CLIENT2 C2              
WHERE C1.CL_CODE = C2.CL_CODE              
And @StatusName =                                   
                  (case                                   
                        when @StatusId = 'BRANCH' then c1.branch_cd                                  
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                                  
                        when @StatusId = 'Trader' then c1.Trader                                  
                        when @StatusId = 'Family' then c1.Family                                  
                        when @StatusId = 'Area' then c1.Area                                  
                        when @StatusId = 'Region' then c1.Region                                  
                        when @StatusId = 'Client' then c2.party_code                                  
                  else                                   
                        'BROKER'                                  
                  End)               
AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)              
              
set transaction isolation level read uncommitted                            
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),           
Isettqty = 0, Ibenqty = 0,Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0,           
Nsehold = 0, Nsepledge = 0, Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
Into #delpayinmatch                                        
From #CLIENT C1, bsedb..Multiisin M (nolock) , #Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                         
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                        
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                         
And D.Party_Code = C.Party_Code And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction')                                        
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                        
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                       
Having D.Qty > 0                                         
                
If @Opt <> 1                 
Begin                
 Delete From #delpayinmatch Where Delqty <= Recqty                
End                
                
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),               
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From bsedb..Deltrans D (nolock), #Client C1 (nolock)              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                            
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From Msajag.Dbo.Deltrans D, #Client C1              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                
set transaction isolation level read uncommitted                                        
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                        
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From bsedb..Deltrans D (nolock), bsedb..Deliverydp Dp             (nolock)                            
Where Filler2 = 1 And Drcr = 'D'                                         
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                         
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'            
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code               
And A.Certno = #delpayinmatch.Certno                                        
                  
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),             
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D, Msajag.Dbo.Deliverydp Dp                           
Where Filler2 = 1 And Drcr = 'D'                           
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                              
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                         
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                        
                    
Update #delpayinmatch Set Scrip_Cd = /*S2.Scrip_Cd + ' ( ' +*/ M.Scrip_Cd/* + ' )'      */          
From bsedb..Scrip2 S2, bsedb..MultiIsIn M                
Where S2.BseCode = M.Scrip_Cd                
And M.IsIn = CertNo                
                
If Upper(@Branchcd) = 'All'                                         
begin                            
 Select @Branchcd = '%'                                  
end                            
If @Opt = 1                            
begin                            
 set transaction isolation level read uncommitted                                         
          
INSERT INTO shortagenholding_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
 From #delpayinmatch R                                   
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                 
 Group By Sett_No, Sett_Type, Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                         
 Having Sum(Delqty) > 0                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd                                         
end                            
Else                            
begin  
set transaction isolation level read uncommitted                                                   
INSERT INTO shortagenholding_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
          
 From #delpayinmatch R (nolock)                
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                               
 Group By Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                      
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd             
                      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_Delpayinmatch_NSE
-- --------------------------------------------------
CREATE Proc Rpt_Delpayinmatch_NSE                     
(@StatusId Varchar(15),
@Statusname Varchar(25),
@Sett_No Varchar(7), 
@Sett_Type Varchar(2), 
@BranchCd Varchar(10),
@Opt int) AS                    
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)            
set transaction isolation level read uncommitted  
/* ****************add below line******************************/
truncate table delpayinmatch_nse1                     

Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                      
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                      
Into #delpayinmatch                      
From msajag..Client1 C1 (nolock), msajag..Client2 C2 (nolock), msajag..Multiisin M  (nolock), msajag..Deliveryclt D  (nolock)Left Outer Join msajag..Deltrans C (nolock)                       
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                      
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                       
And D.Party_Code = C.Party_Code And Drcr = 'C'                       
And Filler2 = 1 And Sharetype <> 'Auction')                      
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                      
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                      
And C1.Cl_Code = C2.Cl_Code                  
And C2.Party_Code = D.Party_Code                  
And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
                        when @StatusId = 'Family' then c1.Family                
                        when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
                        when @StatusId = 'Client' then c2.party_code                
                  else                 
                        'BROKER'                
                  End)                   
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin                      
Having D.Qty > 0                       
  
If @Opt <> 1   
Begin  
 Delete From #delpayinmatch Where Delqty <= Recqty  
End  
  
set transaction isolation level read uncommitted            
Insert Into #delpayinmatch                      
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                      
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                      
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                       
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                       
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                       
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                      
From Msajag.Dbo.Deltrans D, MSAJAG.DBO.Client1 C1, MSAJAG.DBO.Client2 C2                       
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                      
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                      
And C1.Cl_Code = C2.Cl_Code                  
And C2.Party_Code = D.Party_Code                  
And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
                        when @StatusId = 'Family' then c1.Family                
                      when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
            when @StatusId = 'Client' then c2.party_code                
                  else                 
              'BROKER'                
                  End)                   
Group By Isett_No, Isett_Type, D.Party_Code, Certno                      
            
set transaction isolation level read uncommitted                      
Insert Into #delpayinmatch                      
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                      
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                      
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                       
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),              
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                       
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                      
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                      
From BSEDB.Dbo.Deltrans D, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2                       
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                      
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                      
And C1.Cl_Code = C2.Cl_Code                  
And C2.Party_Code = D.Party_Code                  
And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
                        when @StatusId = 'Family' then c1.Family                
                        when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
                        when @StatusId = 'Client' then c2.party_code                
                  else                 
                        'BROKER'                
                  End)                   
Group By Isett_No, Isett_Type, D.Party_Code, Certno                      
            
set transaction isolation level read uncommitted            
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),           
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                  
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                      
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)     
From msajag.dbo.Deltrans D (nolock), msajag.dbo.Deliverydp Dp (nolock)                       
Where Filler2 = 1 And Drcr = 'D'                       
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                       
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                      
          
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),           
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                      
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                 
From BSEDB.Dbo.Deltrans D (nolock), BSEDB.Dbo.Deliverydp Dp  (nolock)                      
Where Filler2 = 1 And Drcr = 'D'                       
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                       
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                       
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                      
                      
If Upper(@Branchcd) = 'All'                       
begin            
 Select @Branchcd = '%'                      
end            
            
If @Opt = 1                       
begin            
set transaction isolation level read uncommitted            
INSERT INTO delpayinmatch_nse1 
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                      
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                      
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                      
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                      
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag..Client2 C2 (nolock), msajag..Client1 C1 (nolock)                   
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                       
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                       
And C1.Branch_Cd Like @Branchcd                        
And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
   when @StatusId = 'Family' then c1.Family                
                        when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
                        when @StatusId = 'Client' then c2.party_code                
               else                 
                        'BROKER'                
                  End)                   
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,                   
Certno, Hold, Pledge, BSEHold, BSEPledge                
Having Sum(Delqty) > 0                       
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                       
end            
Else            
begin            
set transaction isolation level read uncommitted   
INSERT INTO delpayinmatch_nse1                    
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                      
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                      
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                      
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge                      
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag..Client2 C2 (nolock), msajag..Client1 C1 (nolock)                   
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                       
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                       
And C1.Branch_Cd Like @Branchcd                        
And @StatusName =                 
                  (case                 
                        when @StatusId = 'BRANCH' then c1.branch_cd                
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                
                        when @StatusId = 'Trader' then c1.Trader                
                        when @StatusId = 'Family' then c1.Family                
                        when @StatusId = 'Area' then c1.Area                
                        when @StatusId = 'Region' then c1.Region                
                        when @StatusId = 'Client' then c2.party_code                
                  else                 
                        'BROKER'                
                  End)                   
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                   
Hold, Pledge, BSEHold, BSEPledge                      
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                       
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                
end  

--select * from delpayinmatch_nse1  
--select * from #nse_poa_shortage1           
-----------------------------------
update delpayinmatch_nse1            
set delpayinmatch_nse1.poa = 'Yes',delpayinmatch_nse1.cltdpno = msajag..multicltid.cltdpno            
from delpayinmatch_nse1,MSAJAG..multicltid            
where delpayinmatch_nse1.party_code = msajag..multicltid.party_code and msajag..multicltid.def = 1            
             
select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS        
into #nse_poa_shortage1            
from delpayinmatch_nse1 A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B            
WHERE HLD_AC_TYPE = 11            
AND POA = 'YES' AND CLTDPNO = HLD_AC_CODE AND CERTNO = HLD_ISIN_CODE            
            
select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,C.SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA                  
from  #nse_poa_shortage1 A,msajag..SCRIP2 B,msajag..SCRIP1 C            
WHERE A.SCRIP_CD=B.BSECODE AND B.CO_CODE=C.CO_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_nse_Delpayinmatch
-- --------------------------------------------------
CREATE Proc Rpt_nse_Delpayinmatch                             
(@StatusId Varchar(15),  
@Statusname Varchar(25),  
@Sett_No Varchar(7),   
@Sett_Type Varchar(2),   
@BranchCd Varchar(10),  
@Opt int) AS  

 /*                           
  DECLARE
@StatusId Varchar(15),  
@Statusname Varchar(25),  
@Sett_No Varchar(7),   
@Sett_Type Varchar(2),   
@BranchCd Varchar(10),  
@Opt int

SET @StatusId='BROKER'
SET @Statusname='BROKER'
SET @Sett_No='2007196'
SET @Sett_Type='N'
SET @BranchCd='ALL'
SET @Opt=2
*/
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                      
set transaction isolation level read uncommitted          
Truncate table delpayinmatch_nse                     
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                                
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                                
Into #delpayinmatch                                
From msajag.dbo.Client1 C1 (nolock), msajag.dbo.Client2 C2 (nolock), msajag..Multiisin M  (nolock), msajag..Deliveryclt D  (nolock)Left Outer Join msajag..Deltrans C (nolock)                                 
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                 
And D.Party_Code = C.Party_Code And Drcr = 'C'                                 
And Filler2 = 1 And Sharetype <> 'Auction')                                
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                
And C1.Cl_Code = C2.Cl_Code                            
And C2.Party_Code = D.Party_Code                            
And @StatusName =                           
                  (case                           
                        when @StatusId = 'BRANCH' then c1.branch_cd                          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                          
                        when @StatusId = 'Trader' then c1.Trader                          
                        when @StatusId = 'Family' then c1.Family                          
                        when @StatusId = 'Area' then c1.Area                          
                        when @StatusId = 'Region' then c1.Region                          
                        when @StatusId = 'Client' then c2.party_code                          
                  else                           
                        'BROKER'                          
                  End)                             
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin                                
Having D.Qty > 0                                 

If @Opt <> 1             
Begin            
 Delete From #delpayinmatch Where Delqty <= Recqty            
End  
          
set transaction isolation level read uncommitted                      
Insert Into #delpayinmatch                                
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                 
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                 
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                 
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0   
  
From BSEDB.Dbo.Deltrans D, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2                                 
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                
And C1.Cl_Code = C2.Cl_Code                            
And C2.Party_Code = D.Party_Code                            
And @StatusName =                           
                  (case                           
                        when @StatusId = 'BRANCH' then c1.branch_cd                                  
      when @StatusId = 'SUBBROKER' then c1.sub_broker                          
                        when @StatusId = 'Trader' then c1.Trader                          
                        when @StatusId = 'Family' then c1.Family                          
                      when @StatusId = 'Area' then c1.Area                          
                        when @StatusId = 'Region' then c1.Region                          
            when @StatusId = 'Client' then c2.party_code                          
                  else                           
              'BROKER'                          
                  End)                             
Group By Isett_No, Isett_Type, D.Party_Code, Certno                                
                      
set transaction isolation level read uncommitted                                
Insert Into #delpayinmatch                                
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                 
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                        
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                 
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                                
  
From MSAJAG.Dbo.Deltrans D, MSAJAG.DBO.Client1 C1, MSAJAG.DBO.Client2 C2                                 
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                
And C1.Cl_Code = C2.Cl_Code                            
And C2.Party_Code = D.Party_Code                            
And @StatusName =                           
                  (case                           
                        when @StatusId = 'BRANCH' then c1.branch_cd                          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                          
                        when @StatusId = 'Trader' then c1.Trader                          
                        when @StatusId = 'Family' then c1.Family                          
                        when @StatusId = 'Area' then c1.Area                          
                        when @StatusId = 'Region' then c1.Region                          
                        when @StatusId = 'Client' then c2.party_code                          
                  else                           
                        'BROKER'                          
                  End)                             
Group By Isett_No, Isett_Type, D.Party_Code, Certno                                
              
set transaction isolation level read uncommitted                      
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                     
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                            
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                                
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)               
  
From BSEDB.dbo.Deltrans D (nolock), BSEDB.dbo.Deliverydp Dp (nolock)                                 
Where Filler2 = 1 And Drcr = 'D'                                 
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                                 
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                
                    
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                     
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (           
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                                
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                           
From MSAJAG.Dbo.Deltrans D (nolock), MSAJAG.Dbo.Deliverydp Dp  (nolock)                                
Where Filler2 = 1 And Drcr = 'D'                                 
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                                 
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                 
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                
             
If Upper(@Branchcd) = 'All'                                 
begin                      
 Select @Branchcd = '%'                                
end                      
                      
If @Opt = 1                                 
begin                      
set transaction isolation level read uncommitted         
INSERT INTO delpayinmatch_nse                     
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                                
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge,        
'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING   
/* done changes on below line*/                                
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag.dbo.Client2 C2 (nolock), msajag.dbo.Client1 C1 (nolock)                             
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                                 
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                                 
And C1.Branch_Cd Like @Branchcd                                  
And @StatusName =                           
                  (case                           
                        when @StatusId = 'BRANCH' then c1.branch_cd                          
						when @StatusId = 'SUBBROKER' then c1.sub_broker                          
                        when @StatusId = 'Trader' then c1.Trader                          
						when @StatusId = 'Family' then c1.Family                          
                        when @StatusId = 'Area' then c1.Area                          
                        when @StatusId = 'Region' then c1.Region                          
                        when @StatusId = 'Client' then c2.party_code                          
						else                           
                        'BROKER'                          
                  End)                             
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,                             
Certno, Hold, Pledge, BSEHold, BSEPledge                          
Having Sum(Delqty) > 0                                 
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                                 
end                           
Else                            
begin 
set transaction isolation level read uncommitted         
       
INSERT INTO delpayinmatch_nse                     
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                                
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                          
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge,        
'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING                                 
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag.dbo.Client2 C2 (nolock), msajag.dbo.Client1 C1 (nolock)                             
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                                 
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                                 
And C1.Branch_Cd Like @Branchcd                                  
And @StatusName =                           
                  (case                           
                        when @StatusId = 'BRANCH' then c1.branch_cd                          
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                          
                        when @StatusId = 'Trader' then c1.Trader                          
                        when @StatusId = 'Family' then c1.Family                          
                        when @StatusId = 'Area' then c1.Area                          
                        when @StatusId = 'Region' then c1.Region                          
                        when @StatusId = 'Client' then c2.party_code                          
                  else                           
                        'BROKER'                          
                  End)                             
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                             
Hold, Pledge, BSEHold, BSEPledge                                
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                 
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                          
 end        
--------  
update delpayinmatch_nse            
set delpayinmatch_nse.poa = 'Yes',delpayinmatch_nse.cltdpno = msajag..multicltid.cltdpno            
from delpayinmatch_nse,MSAJAG..multicltid            
where delpayinmatch_nse.party_code = msajag..multicltid.party_code and msajag..multicltid.def = 1            
             
select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS        
into #nse_poa_shortage            
from delpayinmatch_nse A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B            
WHERE B.HLD_AC_TYPE = 11            
AND A.POA = 'YES' AND A.CLTDPNO = B.HLD_AC_CODE AND A.CERTNO = B.HLD_ISIN_CODE            
            
select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,A.SCRIP_CD as SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA                  
from  #nse_poa_shortage A

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Rpt_nse_Delpayinmatch_new
-- --------------------------------------------------
CREATE Proc Rpt_nse_Delpayinmatch_new                               
(@StatusId Varchar(15),    
@Statusname Varchar(25),    
@Sett_No Varchar(7),     
@Sett_Type Varchar(2),     
@BranchCd Varchar(10),    
@Opt int,
@access_to as varchar(11),
@access_code as varchar(11)) AS    
  
 /*                             
  DECLARE  
@StatusId Varchar(15),    
@Statusname Varchar(25),    
@Sett_No Varchar(7),     
@Sett_Type Varchar(2),     
@BranchCd Varchar(10),    
@Opt int  
  
SET @StatusId='BROKER'  
SET @Statusname='BROKER'  
SET @Sett_No='2007196'  
SET @Sett_Type='N'  
SET @BranchCd='ALL'  
SET @Opt=2  
*/  
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                        
set transaction isolation level read uncommitted            
Truncate table delpayinmatch_nse                       
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)), Isettqty = 0, Ibenqty = 0,                                  
Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                                  
Into #delpayinmatch                                  
From msajag.dbo.Client1 C1 (nolock), msajag.dbo.Client2 C2 (nolock), msajag..Multiisin M  (nolock), msajag..Deliveryclt D  (nolock)Left Outer Join msajag..Deltrans C (nolock)                                   
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                  
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                   
And D.Party_Code = C.Party_Code And Drcr = 'C'                                   
And Filler2 = 1 And Sharetype <> 'Auction')                                  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                  
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                  
And C1.Cl_Code = C2.Cl_Code                              
And C2.Party_Code = D.Party_Code                              
And @StatusName =                             
                  (case                             
                        when @StatusId = 'BRANCH' then c1.branch_cd                            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                            
                        when @StatusId = 'Trader' then c1.Trader                            
                        when @StatusId = 'Family' then c1.Family                            
                        when @StatusId = 'Area' then c1.Area                            
                        when @StatusId = 'Region' then c1.Region                            
                        when @StatusId = 'Client' then c2.party_code                            
                  else                             
                        'BROKER'                            
                  End)                               
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin                                  
Having D.Qty > 0                                   
  
If @Opt <> 1               
Begin              
 Delete From #delpayinmatch Where Delqty <= Recqty              
End    
            
set transaction isolation level read uncommitted                        
Insert Into #delpayinmatch                                  
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                  
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                  
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                   
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                   
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                   
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                  
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0     
    
From BSEDB.Dbo.Deltrans D, BSEDB.DBO.Client1 C1, BSEDB.DBO.Client2 C2                                   
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                  
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                  
And C1.Cl_Code = C2.Cl_Code                              
And C2.Party_Code = D.Party_Code                              
And @StatusName =                             
                  (case                             
                        when @StatusId = 'BRANCH' then c1.branch_cd                                    
      when @StatusId = 'SUBBROKER' then c1.sub_broker                            
                        when @StatusId = 'Trader' then c1.Trader                            
                        when @StatusId = 'Family' then c1.Family                            
                      when @StatusId = 'Area' then c1.Area                            
                        when @StatusId = 'Region' then c1.Region                            
            when @StatusId = 'Client' then c2.party_code                            
                  else                             
              'BROKER'                            
                  End)                               
Group By Isett_No, Isett_Type, D.Party_Code, Certno                                  
                        
set transaction isolation level read uncommitted                                  
Insert Into #delpayinmatch                                  
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                  
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                  
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                   
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                          
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                   
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                  
Hold = 0, Pledge = 0, BSEHold = 0, BSEPledge = 0                                  
    
From MSAJAG.Dbo.Deltrans D, MSAJAG.DBO.Client1 C1, MSAJAG.DBO.Client2 C2                                   
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                  
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                  
And C1.Cl_Code = C2.Cl_Code                              
And C2.Party_Code = D.Party_Code                              
And @StatusName =                             
                  (case                             
                        when @StatusId = 'BRANCH' then c1.branch_cd                            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                            
                        when @StatusId = 'Trader' then c1.Trader                            
                        when @StatusId = 'Family' then c1.Family                            
                        when @StatusId = 'Area' then c1.Area                            
                        when @StatusId = 'Region' then c1.Region                            
                        when @StatusId = 'Client' then c2.party_code                            
                  else                             
                        'BROKER'                            
                  End)                               
Group By Isett_No, Isett_Type, D.Party_Code, Certno                                  
                
set transaction isolation level read uncommitted                        Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                       
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                              
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                                  
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                 
    
From BSEDB.dbo.Deltrans D (nolock), BSEDB.dbo.Deliverydp Dp (nolock)                                   
Where Filler2 = 1 And Drcr = 'D'                                   
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                                   
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                   
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                  
                      
Update #delpayinmatch Set Bsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                       
Bsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (             
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 Then Qty Else 0 End), 0),                                  
Pledge = Isnull(Sum(Case When TrType = 909 Then Qty Else 0 End), 0)                             
From MSAJAG.Dbo.Deltrans D (nolock), MSAJAG.Dbo.Deliverydp Dp  (nolock)                                  
Where Filler2 = 1 And Drcr = 'D'                                   
And Delivered = '0' And Trtype In (904, 909) And D.Bdpid = Dp.Dpid                                   
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                   
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                  
               
If Upper(@Branchcd) = 'All'                                   
begin                        
 Select @Branchcd = '%'                                  
end                        
                        
If @Opt = 1                                   
begin                        
set transaction isolation level read uncommitted           
INSERT INTO delpayinmatch_nse                       
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                                  
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                  
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                  
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge,          
'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING     
/* done changes on below line*/                                  
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag.dbo.Client2 C2 (nolock), msajag.dbo.Client1 C1 (nolock)                               
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                                   
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                                   
And C1.Branch_Cd Like @Branchcd                                    
And @StatusName =                             
                  (case                             
                        when @StatusId = 'BRANCH' then c1.branch_cd                            
      when @StatusId = 'SUBBROKER' then c1.sub_broker                            
                        when @StatusId = 'Trader' then c1.Trader                            
      when @StatusId = 'Family' then c1.Family                            
                        when @StatusId = 'Area' then c1.Area                            
                        when @StatusId = 'Region' then c1.Region                            
      when @StatusId = 'Client' then c2.party_code                            
      else                             
                        'BROKER'                            
                  End)                               
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd,                               
Certno, Hold, Pledge, BSEHold, BSEPledge                            
Having Sum(Delqty) > 0                                   
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                                   
end                             
Else                              
begin   
set transaction isolation level read uncommitted           
         
INSERT INTO delpayinmatch_nse                       
Select Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                                  
Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                  
Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                            
Hold = Hold, Pledge = Pledge, BSEHold = BSEHold, BSEPledge = BSEPledge,          
'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING                                   
From #delpayinmatch R (nolock), msajag..Multiisin M (nolock), msajag.dbo.Client2 C2 (nolock), msajag.dbo.Client1 C1 (nolock)                               
Where M.Isin = R.Certno And Sett_No = @Sett_No And Sett_Type = @Sett_Type                                   
And R.Party_Code = C2.Party_Code And C1.Cl_Code = C2.Cl_Code                                   
And C1.Branch_Cd Like @Branchcd                                    
And @StatusName =                             
                  (case                             
                        when @StatusId = 'BRANCH' then c1.branch_cd                            
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                            
                        when @StatusId = 'Trader' then c1.Trader                            
                        when @StatusId = 'Family' then c1.Family                            
                        when @StatusId = 'Area' then c1.Area                            
                        when @StatusId = 'Region' then c1.Region                            
                        when @StatusId = 'Client' then c2.party_code                            
                  else                             
                        'BROKER'                            
                  End)                               
Group By Sett_No, Sett_Type, R.Party_Code, C1.Short_Name, C1.Branch_Cd, C1.Sub_Broker, M.Scrip_Cd, Certno,                               
Hold, Pledge, BSEHold, BSEPledge                                  
Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                   
Order By C1.Branch_Cd, C1.Sub_Broker, R.Party_Code, M.Scrip_Cd                            
 end          
--------    
update delpayinmatch_nse              
set delpayinmatch_nse.poa = 'Yes',delpayinmatch_nse.cltdpno = msajag..multicltid.cltdpno              
from delpayinmatch_nse,MSAJAG..multicltid              
where delpayinmatch_nse.party_code = msajag..multicltid.party_code and msajag..multicltid.def = 1              
               
select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS          
into #nse_poa_shortage              
from delpayinmatch_nse A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B              
WHERE B.HLD_AC_TYPE = 11              
AND A.POA = 'YES' AND A.CLTDPNO = B.HLD_AC_CODE AND A.CERTNO = B.HLD_ISIN_CODE              
              
select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,A.SCRIP_CD as SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA             
from  #nse_poa_shortage A

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
-- PROCEDURE dbo.usp_auto_payout_report
-- --------------------------------------------------

CREATE proc usp_auto_payout_report  
(  
@fdate varchar(50),            
@todate varchar(50),   
@segment varchar(20),  
@status varchar(20)  
)  
as   
set @fdate = convert(datetime,@fdate,103)                                                  
set @todate = convert(datetime,@todate,103) + '23:59:59.000'     
  
if @status = 'A'   
begin  
if @segment = 'BSE'  
/*select * from Angel_AutoPayoutClientMaster where Fld_bsepoa = 'Y' and Fld_bseactivetime >= @fdate and Fld_bseactivetime <= @todate*/  
select Fld_CltCode,Fld_CltName,Fld_BrTag,Fld_SbTag,Fld_BseDp as dpid,Fld_Bseid as cliid,convert(varchar(11),Fld_bseactivetime,103) as Adate from  Angel_AutoPayoutClientMaster where Fld_bsepoa = 'Y' and Fld_bseactivetime >= @fdate and Fld_bseactivetime <= @todate  
else   
/*select * from Angel_AutoPayoutClientMaster where Fld_nsepoa = 'Y' and Fld_nseactivetime >= @fdate and Fld_nseactivetime <= @todate*/  
select Fld_CltCode,Fld_CltName,Fld_BrTag,Fld_SbTag,Fld_NseDp as dpid,Fld_Nseid as cliid,convert(varchar(11),Fld_nseactivetime,103) as adate from  Angel_AutoPayoutClientMaster where Fld_nsepoa = 'Y' and Fld_nseactivetime >= @fdate and Fld_nseactivetime <= @todate  
end  
  
if @status = 'D'   
begin  
if @segment = 'BSE'  
/*select * from Angel_AutoPayoutClientMaster where Fld_bsepoa = 'Y' and Fld_bseDeactivetime >= @fdate and Fld_bseDeactivetime <= @todate*/  
select Fld_CltCode,Fld_CltName,Fld_BrTag,Fld_SbTag,Fld_BseDp as dpid,Fld_Bseid as cliid,convert(varchar(11),Fld_bseDeactivetime,103) as adate from  Angel_AutoPayoutClientMaster where Fld_bsepoa = 'Y' and Fld_bseDeactivetime >= @fdate and Fld_bseDeactivetime <= @todate  
else  
/*select * from Angel_AutoPayoutClientMaster where Fld_nsepoa = 'Y' and Fld_nseDeactivetime >= @fdate and Fld_nseDeactivetime <= @todate*/  
select Fld_CltCode,Fld_CltName,Fld_BrTag,Fld_SbTag,Fld_NseDp as dpid,Fld_Nseid as cliid,convert(varchar(11),Fld_nseDeactivetime,103) as adate from  Angel_AutoPayoutClientMaster where Fld_nsepoa = 'Y' and Fld_nseDeactivetime >= @fdate and Fld_nseDeactivetime <= @todate  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_automail_directorholding
-- --------------------------------------------------
CREATE PROC [dbo].[usp_automail_directorholding]      
             
as    
            
declare @date as varchar(11)            
set @date=convert(datetime,convert(varchar(11),getdate(),103),103)              
            
select distinct party_code=case when a.party_code is null then b.party_Code else a.party_code end,              
hld_isin_code=case when a.hld_isin_code is null then b.isin else a.hld_isin_code end,              
DPHolding=isnull(DPHolding,0),              
PoolHold=isnull(poolhold,0) into #final              
 from              
(select party_code,hld_isin_code,DPHolding=convert(decimal(14,0),sum(dpholding))               
from director_dp(nolock) where date=@date group by party_code,hld_isin_code)a              
full outer join              
(select isin,party_code,poolhold=convert(decimal(14,0),sum(poolhold))               
from director_pool(nolock)  where date=@date  group by isin,party_code)b              
on a.party_code=b.party_code              
and a.hld_isin_code=b.isin              
order by party_Code              
              
select a.*,b.sc_isinname,C.LONG_NAME into #file3 from              
(select * from #final)a              
/*      
 Changed by Prashant on Jul 22 2013 as per communication with rahul sir      
*/      
--left outer join dpbackoffice.acercross.dbo.security b with(nolock)              
left outer join [ABCSOORACLEMDLW].synergy.dbo.security b with(nolock)      
on a.hld_isin_code=b.sc_isincode              
left outer join              
anand1.msajag.dbo.client_details c               
on a.party_code=c.party_code              
              
select a.*,              
Amount=convert(decimal(14,2),(dpholding+poolhold)*isnull(b.clsrate,0)) into #file4 from #file3 a              
left outer join              
(select distinct isin,clsrate=max(clsrate) from intranet.risk.dbo.holding group by isin) b              
on a.hld_isin_code=b.isin              
              
            
drop table temp_directorhold            
            
create table  temp_directorhold            
(Party_code varchar(15),ISIN varchar(15),DPHolding varchar(15),PoolHold varchar(15)            
,Isinname varchar(55),Name varchar(55),Amount varchar(15))            
            
insert into temp_directorhold values('Party_code','ISIN','DPHolding','PoolHold','Isinname','Name','Amount')            
             
insert into temp_directorhold            
select * from            
(select distinct a.Party_code,ISIN=a.hld_isin_code,a.DPHolding,a.PoolHold,              
Isinname=case when a.sc_isinname is null then b.series else a.sc_isinname end ,Name=a.long_name,              
Amount  from #file4 a              
left outer join              
(select distinct isin,series from intranet.risk.dbo.holding ) b              
on a.hld_isin_code=b.isin            
)a            
order by Isinname            
              
if(select count(*) from temp_directorhold)>0            
begin            
  
declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(100)                                           
set @file = (select 'DirectorHolding_'+replace(convert(varchar(11),getdate(),103),'/','')+'.xls')                                                                                         
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select Party_code,ISIN,DPHolding,PoolHold,Isinname,Name,Amount '  
SET @s = @s + ' from angelinhouse.dbo.temp_directorhold" queryout '+'\\INHOUSEALLAPP-FS.angelone.in\upload1\circularletter\'+@file+' -c -SABVSDPSTTL.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                                 
set @s1= @s+''''                                                                                                                      
set @s1= @s+''''                                                                                                                      
exec(@s1)                  
            
            
DECLARE @rc INT                                       
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                                       
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                                      
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp                  
                       
Declare @Msg as Varchar(1000)                             
                            
Set @Msg = 'Dear Sir,<br><br>            
Kindly find enclosed file having Holding of Directors and their family.            
<br><br>            
Regards            
<br>            
Rahul Shah             
'                   
declare @attach as varchar(500)                                                         
set @attach='\\INHOUSEALLAPP-FS.angelone.in\upload1\circularletter\DirectorHolding_'+replace(convert(varchar(11),getdate(),103),'/','')+'.xls'              
                                                
EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                           
@recipients  = 'Rahulc.shah@angeltrade.com',                          
--@copy_recipients ='Rahulc.shah@angeltrade.com',                  
@profile_name = 'intranet',                                                                                 
--@from = 'rahul.shah@angeltrade.com',                                                                                                                          
@body  = @Msg,                                                                                       
@subject = 'Directors Holding',            
@file_attachments =@attach,                                                                                                                                                             
@body_format  = 'html'            
            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_automail_directorholding_22072013
-- --------------------------------------------------
CREATE proc usp_automail_directorholding_22072013
       
as        
declare @date as varchar(11)      
set @date=convert(datetime,convert(varchar(11),getdate(),103),103)        
      
select distinct party_code=case when a.party_code is null then b.party_Code else a.party_code end,        
hld_isin_code=case when a.hld_isin_code is null then b.isin else a.hld_isin_code end,        
DPHolding=isnull(DPHolding,0),        
PoolHold=isnull(poolhold,0) into #final        
 from        
(select party_code,hld_isin_code,DPHolding=convert(decimal(14,0),sum(dpholding))         
from director_dp(nolock) where date=@date group by party_code,hld_isin_code)a        
full outer join        
(select isin,party_code,poolhold=convert(decimal(14,0),sum(poolhold))         
from director_pool(nolock)  where date=@date  group by isin,party_code)b        
on a.party_code=b.party_code        
and a.hld_isin_code=b.isin        
order by party_Code        
        
select a.*,b.sc_isinname,C.LONG_NAME into #file3 from        
(select * from #final)a        
left outer join dpbackoffice.acercross.dbo.security b with(nolock)        
on a.hld_isin_code=b.sc_isincode        
left outer join        
anand1.msajag.dbo.client_details c         
on a.party_code=c.party_code        
        
select a.*,        
Amount=convert(decimal(14,2),(dpholding+poolhold)*isnull(b.clsrate,0)) into #file4 from #file3 a        
left outer join        
(select distinct isin,clsrate=max(clsrate) from intranet.risk.dbo.holding group by isin) b        
on a.hld_isin_code=b.isin        
        
      
drop table temp_directorhold      
      
create table  temp_directorhold      
(Party_code varchar(15),ISIN varchar(15),DPHolding varchar(15),PoolHold varchar(15)      
,Isinname varchar(55),Name varchar(55),Amount varchar(15))      
      
insert into temp_directorhold values('Party_code','ISIN','DPHolding','PoolHold','Isinname','Name','Amount')      
       
insert into temp_directorhold      
select * from      
(select distinct a.Party_code,ISIN=a.hld_isin_code,a.DPHolding,a.PoolHold,        
Isinname=case when a.sc_isinname is null then b.series else a.sc_isinname end ,Name=a.long_name,        
Amount  from #file4 a        
left outer join        
(select distinct isin,series from intranet.risk.dbo.holding ) b        
on a.hld_isin_code=b.isin      
)a      
order by Isinname      
        
if(select count(*) from temp_directorhold)>0      
begin      
declare @s as varchar(1000),@s1 as varchar(1000),@file as varchar(100)                                     
set @file = (select 'DirectorHolding_'+replace(convert(varchar(11),getdate(),103),'/','')+'.xls')                                                                                   
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select * from angeldemat.angelinhouse.dbo.temp_directorhold" queryout '+'\\196.1.115.136\d$\upload1\circularletter\'+@file+' -c -Sintranet -Usa -Pnirwan612'                                            
set @s1= @s+''''                                                                                                                
exec(@s1)            
      
      
DECLARE @rc INT                                 
IF NOT EXISTS (SELECT * FROM intranet.msdb.sys.service_queues                                 
WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)                                
EXEC @rc = intranet.msdb.dbo.sysmail_start_sp            
                 
Declare @Msg as Varchar(1000)                       
                      
Set @Msg = 'Dear Sir,<br><br>      
Kindly find enclosed file having Holding of Directors and their family.      
<br><br>      
Regards      
<br>      
Rahul Shah       
'                                                                       
declare @attach as varchar(500)                                                   
set @attach='\\196.1.115.136\d$\upload1\circularletter\DirectorHolding_'+replace(convert(varchar(11),getdate(),103),'/','')+'.xls'        
                                          
EXEC intranet.msdb.dbo.sp_send_dbmail                                                                                     
@recipients  = 'Lalit@angeltrade.com;Dilipm.patel@angeltrade.com;Bharat.patil@angeltrade.com;Rahulc.shah@angeltrade.com',                    
--@recipients  = 'preetam.patil@angeltrade.com;devarsh.nandivkar@angeltrade.com',                    
--@copy_recipients ='preetam.patil@angeltrade.com;devarsh.nandivkar@angeltrade.com',            
@profile_name = 'intranet',                                                                           
--@from = 'rahul.shah@angeltrade.com',                                                                                                                    
@body  = @Msg,                                                                                 
@subject = 'Directors Holding',      
@file_attachments =@attach,                                                                                                                                                       
@body_format  = 'html'      
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_autopayout_client1
-- --------------------------------------------------
CREATE proc usp_autopayout_client1
(
@access_to as varchar(25),
@access_code as varchar(25) ,
@cltcode as varchar(25)
)
as 

if @access_to='branch'
begin 
select * from Angel_AutoPayoutClientMaster (nolock) where fld_Cltcode = @cltcode and fld_brtag = @access_code
end

if @access_to='region'
begin  
select * from Angel_AutoPayoutClientMaster (nolock) where fld_Cltcode = @cltcode and fld_brtag 
in (select code from intranet.risk.dbo.region where reg_code = @access_code)
end

if @access_to='broker'
begin 
select * from Angel_AutoPayoutClientMaster (nolock) where fld_Cltcode = @cltcode
end

if @access_to='BRMAST'   
begin
select * from Angel_AutoPayoutClientMaster (nolock) where fld_Cltcode = @cltcode and fld_brtag
in (select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@access_code)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_autopayout_client2
-- --------------------------------------------------
create proc usp_autopayout_client2
(
@access_to as varchar(25),
@access_code as varchar(25) ,
@cltcode as varchar(25)
)
as 
if @access_to='branch'
begin
select * from V_POA_Clients (nolock) where branch_cd = @access_code and cl_code = @cltcode
end

if @access_to='region'
begin 
select * from V_POA_Clients (nolock) where cl_code = @cltcode and branch_cd in
(select code from intranet.risk.dbo.region where reg_code = @access_code)
end

if @access_to='broker'
begin 
select * from V_POA_Clients (nolock) where cl_code = @cltcode
end

if @access_to='BRMAST'   
begin
select * from V_POA_Clients (nolock) where cl_code = @cltcode and branch_cd in
(select branch_cd from intranet.risk.dbo.branch_master where brmast_cd=@access_code)
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_BSECertificate
-- --------------------------------------------------
CREATE Proc usp_BSECertificate(@rptdate as varchar(11),@access_to varchar(15),@access_code varchar(15))       
as        
      
set @rptdate = convert(datetime,@rptdate,103)      
        
select         
Date=convert(varchar(11),Fld_RptDate,103),        
[Client Code]=Fld_PartyCode,        
[Value of Securites Pledged with Bank for all Clients        
(T-1 day Rate) as on the date of maximum utilisation overdraft]=Convert(dec(15,2),Fld_TotalPledgeValue),        
[Pledge Value (Proportion as e based on O/D availed]=Convert(dec(15,2),Fld_ClientPledgeValue),        
[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_CMLedgerT2),        
[CM Recipts/Payments on T Day]=Convert(dec(15,2),Fld_TDay_PR),        
[Recipts/Payments on T-1 Day]=Convert(dec(15,2),Fld_T1Day_PR),        
[MG 02 Requirement on T Day]=Convert(dec(15,2),Fld_MG02TDay),        
[MG 02 Requirement on T-1 Day]=Convert(dec(15,2),Fld_MG02T1Day),        
[Free Balance in CM Segment]=Convert(dec(15,2),Fld_CMFreeBal),        
[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_FOT1Bal),        
[FO Recipts/Payments on T Day]=Convert(dec(15,2),Fld_FOTPR),        
[FO Margin Ledger Balance on T Day]=Convert(dec(15,2),Fld_FOML),        
[T Day F&O Initial Margin Requirement]=Convert(dec(15,2),Fld_IM),        
[T Day F&O Exposure Margin Requirement]=Convert(dec(15,2),Fld_EM),        
[Free Balance in FO Segment]=Convert(dec(15,2),Fld_FreeBal),        
[Net Obligation]=Convert(dec(15,2),Fld_NetOblgation),        
[Value of improper use]=Convert(dec(15,2),Fld_ValueImproperUse) from tbl_BSECertificate  

where Fld_RptDate >= @rptdate      
and Fld_RptDate <= @rptdate +' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_BSENSECertificate
-- --------------------------------------------------
CREATE Proc usp_BSENSECertificate(@rptdate as varchar(11),@access_to varchar(15),@access_code varchar(15))         
as          
        
set @rptdate = convert(datetime,@rptdate,103)        
          
select           
Date=convert(varchar(11),Fld_RptDate,103),          
[Client Code]=Fld_PartyCode,          
[Value of Securites Pledged with Bank for all Clients          
(T-1 day Rate) as on the date of maximum utilisation overdraft]=Convert(dec(15,2),Fld_TotalPledgeValue),          
[Pledge Value (Proportion as e based on O/D availed]=Convert(dec(15,2),Fld_ClientPledgeValue),   
  
[BM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_BseLedgerBal),          
[BM Recipts/Payments on T Day]=Convert(dec(15,2),Fld_BseTDay_PR),          
[BSE Recipts/Payments on T-1 Day]=Convert(dec(15,2),Fld_BseT1Day_PR),          
[BSE MG 02 Requirement on T Day]=Convert(dec(15,2),Fld_BseMg02Tday),          
[BSE MG 02 Requirement on T-1 Day]=Convert(dec(15,2),Fld_BseMg02T1Day),          
[BSE Free Balance in CM Segment]=Convert(dec(15,2),Fld_BseFreeBal),    
  
[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_CMLedgerT2),          
[CM Recipts/Payments on T Day]=Convert(dec(15,2),Fld_TDay_PR),          
[Recipts/Payments on T-1 Day]=Convert(dec(15,2),Fld_T1Day_PR),          
[MG 02 Requirement on T Day]=Convert(dec(15,2),Fld_MG02TDay),          
[MG 02 Requirement on T-1 Day]=Convert(dec(15,2),Fld_MG02T1Day),          
[Free Balance in CM Segment]=Convert(dec(15,2),Fld_CMFreeBal),          
[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_FOT1Bal),          
[FO Recipts/Payments on T Day]=Convert(dec(15,2),Fld_FOTPR),          
[FO Margin Ledger Balance on T Day]=Convert(dec(15,2),Fld_FOML),          
[T Day F&O Initial Margin Requirement]=Convert(dec(15,2),Fld_IM),          
[T Day F&O Exposure Margin Requirement]=Convert(dec(15,2),Fld_EM),          
[Free Balance in FO Segment]=Convert(dec(15,2),Fld_FreeBal),          
[Net Obligation]=Convert(dec(15,2),isnull(Fld_NSEBSENetObligation,0)),          
[Value of improper use]=Convert(dec(15,2),isnull(Fld_BSENSEValueImproperUse,0)) from tbl_NSECertificate  where Fld_RptDate >= @rptdate        
and Fld_RptDate <= @rptdate +' 23:59:59'      

--Select * from tbl_NSECertificate
      
--select           
--Date='',      
--[Client Code]='',          
--[Value of Securites Pledged with Bank for all Clients          
--(T-1 day Rate) as on the date of maximum utilisation overdraft]='',          
--[Pledge Value (Proportion as e based on O/D availed]=sum(Convert(dec(15,2),Fld_ClientPledgeValue)),          
--[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=sum(Convert(dec(15,2),Fld_CMLedgerT2)),          
--[CM Recipts/Payments on T Day]=sum(Convert(dec(15,2),Fld_TDay_PR)),          
--[Recipts/Payments on T-1 Day]=sum(Convert(dec(15,2),Fld_T1Day_PR)),          
--[MG 02 Requirement on T Day]=sum(Convert(dec(15,2),Fld_MG02TDay)),          
--[MG 02 Requirement on T-1 Day]=sum(Convert(dec(15,2),Fld_MG02T1Day)),          
--[Free Balance in CM Segment]=sum(Convert(dec(15,2),Fld_CMFreeBal)),          
--[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=sum(Convert(dec(15,2),Fld_FOT1Bal)),          
--[FO Recipts/Payments on T Day]=sum(Convert(dec(15,2),Fld_FOTPR)),          
--[FO Margin Ledger Balance on T Day]=sum(Convert(dec(15,2),Fld_FOML)),          
--[T Day F&O Initial Margin Requirement]=sum(Convert(dec(15,2),Fld_IM)),          
--[T Day F&O Exposure Margin Requirement]=sum(Convert(dec(15,2),Fld_EM)),          
--[Free Balance in FO Segment]=sum(Convert(dec(15,2),Fld_FreeBal)),          
--[Net Obligation]=sum(Convert(dec(15,2),Fld_NetOblgation)),          
--[Value of improper use]=sum(Convert(dec(15,2),Fld_ValueImproperUse)) from tbl_NSECertificate  where Fld_RptDate >= @rptdate        
--and Fld_RptDate <= @rptdate +' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_collateralsuspense
-- --------------------------------------------------
Create proc usp_collateralsuspense
as

insert into CollateralLog
SELECT  *,getdate() CollateralLog FROM MIMANSA.BITS.DBO.ANGELDPTRAN 
WHERE DPCLCODE = 'SSSS' AND ACCOUNTID IN ('15464303','14216209','13326100') 
AND DPFLAG = 'G' AND DPTRFTAG = ''

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_director_holdreport
-- --------------------------------------------------
CREATE proc usp_director_holdreport
(@date as varchar(11))
as

set @date=convert(datetime,@date,103)

select distinct party_code=case when a.party_code is null then b.party_Code else a.party_code end,
hld_isin_code=case when a.hld_isin_code is null then b.isin else a.hld_isin_code end,
DPHolding=isnull(DPHolding,0),
PoolHold=isnull(poolhold,0) into #final
 from
(select party_code,hld_isin_code,DPHolding=convert(decimal(14,0),sum(dpholding)) 
from director_dp(nolock) where date=@date group by party_code,hld_isin_code)a
full outer join
(select isin,party_code,poolhold=convert(decimal(14,0),sum(poolhold)) 
from director_pool(nolock)  where date=@date  group by isin,party_code)b
on a.party_code=b.party_code
and a.hld_isin_code=b.isin
order by party_Code

select a.*,b.sc_isinname,C.LONG_NAME into #file3 from
(select * from #final)a
left outer join dpbackoffice.acercross.dbo.security b with(nolock)
on a.hld_isin_code=b.sc_isincode
left outer join
anand1.msajag.dbo.client_details c 
on a.party_code=c.party_code

select a.*,
Amount=convert(decimal(14,2),(dpholding+poolhold)*isnull(b.clsrate,0)) into #file4 from #file3 a
left outer join
(select distinct isin,clsrate=max(clsrate) from intranet.risk.dbo.holding group by isin) b
on a.hld_isin_code=b.isin


select distinct a.party_code,a.hld_isin_code,a.dpholding,a.poolhold,
Isinname=case when a.sc_isinname is null then b.series else a.sc_isinname end ,a.long_name,
Amount from #file4 a
left outer join
(select distinct isin,series from intranet.risk.dbo.holding ) b
on a.hld_isin_code=b.isin
order by a.hld_isin_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_displaydata_holdingrec
-- --------------------------------------------------

create proc usp_displaydata_holdingrec
(
@party_code varchar(10),
@holding varchar(10),
@dtformat varchar(11)
) as
select * from modifiedholding_rec where party_code= @party_code and existingholding=@holding and holdingdate=@dtformat

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Excess_Rpt
-- --------------------------------------------------
CREATE Proc USP_Excess_Rpt(@Fdate as varchar(11),@Tdate as varchar(11),@stat as varchar(2),@Segment as varchar(10))
as


Declare  @table as varchar(20)
Declare @FFdate as varchar(11)
Declare @TTdate as varchar(11)
Declare @Str as varchar(5000)
Declare @Sdate as varchar(11)


/*
Declare @stat as varchar(5000)
Declare @Fdate as varchar(11)
Declare @Tdate as varchar(11)
Declare @Segment as varchar(11)
set @stat = 'A'
set @Segment = 'BSE'
set @Fdate = 'Oct 25 2007'
set @Tdate = 'Oct 26 2007'
print @FFdate
print @Ttdate
*/

set @Fdate = convert(varchar(11),convert(datetime,@Fdate,103))
set @Tdate = convert(varchar(11),convert(datetime,@Tdate,103))

set @FFdate = case when @stat = 'A' then @fdate else @tdate  end
set @TTdate = case when @stat = 'A' then @tdate else @fdate end

set @table = case when @Segment = 'BSE' then 'bsedbExcess' else 'msajagExcess' end

set @Sdate =
case 
when @stat = 'A' then @Tdate 
when @stat = 'D' then @Fdate 
end

If @stat = 'M'
	begin	
		set @Str = 'select distinct Sett_No,Sett_Type,Party_code,Scrip_cd,CertNo,cltDpid,QTY from '+@table+' (nolock)
		where convert(varchar(11),Log_date) = '''+@Tdate+''' and not exists(select y.* from
		(select * from '+@table+' where convert(varchar(11),Log_date) = '''+@Fdate+''') x
		inner join (select * from '+@table+' where convert(varchar(11),Log_date) = '''+@Tdate+''' ) y on 
		x.Sno = Y.SNo and x.Sett_No = y.Sett_No and x.Sett_Type = y.Sett_Type and x.party_code = y.party_code
		and x.scrip_cd = y.scrip_cd and x.certNo = y.certNo and x.series = y.series  
		and x.Qty = y.Qty and x.cltdpid = y.cltdpid and y.SNo = '+@table+'.Sno)'		
	end
else
	Begin	
		set @Str = 'select distinct Sett_No,Sett_Type,Party_code,Scrip_cd,CertNo,cltDpid,QTY from '+@table+' where 
		convert(varchar(11),Log_date) = '''+@Sdate+''' and not exists ( select y.* from 
		(select * from '+@table+' where convert(varchar(11),Log_date) = '''+@FFdate+''') x
		inner join (select * from '+@table+' where convert(varchar(11),Log_date) = '''+@TTdate+''') 
		y on  x.Sno = Y.SNo and Y.Sno = '+@table+'.SNO)'	
	end

exec (@Str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Fetch_Pledge_Process
-- --------------------------------------------------
CREATE Proc USP_Fetch_Pledge_Process                            
as                            
                    
--------------------------Already Pledge Value------------------                            
select party_code,BcltDpId,cltdpid,Segment ='BSE',scrip_cd,sum(qty) as Pledge_Qty,CertNo,Sett_No,Sett_type into #bsePledge  from                                               
bsedb.dbo.deltrans x where trtype = 909  AND DELIVERED = '0' AND DRCR ='D' and                             
BcltDpId in ('1203320000000066','1203320000000028') and party_code not in ('BROKER')       
group by party_code,BcltDpId,cltdpid,scrip_cd,CertNo,Sett_No,Sett_type                            
                            
select  party_code,BcltDpId,cltdpid,Segment ='NSE',scrip_cd,sum(qty) as Pledge_Qty,CertNo,Sett_No,Sett_type into #nsePledge  from                             
msajag.dbo.deltrans where trtype = 909 AND DELIVERED = '0' AND DRCR ='D' and BcltDpId = '1203320000000051'                                           
and party_code not in ('BROKER') group by party_code,BcltDpId,cltdpid,scrip_cd,CertNo,Sett_No,Sett_type                    
                            
-------------------------Free Value------------------                            
select party_code,BcltDpId,cltdpid,Segment ='BSE',scrip_cd,sum(qty) as Pledge_Qty,CertNo,Sett_No,Sett_type into #bseFree  from                                               
bsedb.dbo.deltrans x where trtype = 904  AND DELIVERED = '0' AND DRCR ='D' and                             
BcltDpId in ('1203320000000066','1203320000000028') and party_code not in ('BROKER')                             
group by party_code,BcltDpId,cltdpid,scrip_cd,CertNo,Sett_No,Sett_type                            
                            
select  party_code,BcltDpId,cltdpid,Segment ='NSE',scrip_cd,sum(qty) as Pledge_Qty,CertNo,Sett_No,Sett_type into #nseFree  from                             
msajag.dbo.deltrans where trtype = 904 AND DELIVERED = '0' AND DRCR ='D' and BcltDpId = '1203320000000051'                                           
and party_code not in ('BROKER') group by party_code,BcltDpId,cltdpid,scrip_cd,CertNo,Sett_No,Sett_type                             
                            
------------------------------Closing Rate------                            
select * into #ClsRate from intranet.risk.dbo.V_Closing_Rate                            
                            
select * into #Pldege from                            
(                            
select * from #bsePledge                            
union all                            
select * from #nsePledge                            
)x                             
                            
select * into #Free from                            
(                            
select * from #bseFree                            
union all                            
select * from #nseFree                            
)x                             
                    
select x.*,y.cls,PledgeValue = Pledge_Qty*cls into #PledgeValue from #Pldege x left outer join #ClsRate y on x.scrip_cd = y.scrip and x.segment =  y.segment                            
select x.*,y.cls,FreeValue = Pledge_Qty*cls into #FreeValue from #Free x left outer join #ClsRate y on x.scrip_cd = y.scrip and x.segment =  y.segment                            
                    
------------------------------Final Table------------------                            
select party_code=isnull(x.party_code,y.party_code),                                                         
BcltDpId=isnull(x.BcltDpId,y.BcltDpId),                                                      
cltdpid=isnull(x.cltdpid,y.cltdpid),                                                        
Segment=isnull(x.Segment,y.Segment),                                                                  
scrip_cd=isnull(x.scrip_cd,y.scrip_cd),                               
Pledge_Qty= isnull(x.Pledge_Qty,0),                            
PledgeValue=isnull(x.PledgeValue,0),                                                                  
Free_Qty= isnull(y.Pledge_Qty,0),                            
FreeValue=isnull(y.FreeValue,0),                                  
CertNo=isnull(x.CertNo,y.CertNo),                      
cls=isnull(x.cls,y.cls),                    
Sett_No=isnull(x.Sett_No,y.Sett_No),                    
Sett_type=isnull(x.Sett_type,y.Sett_type)                            
into #Final from                            
(select * from #PledgeValue) x                            
full outer join                            
(select * from #FreeValue) y                            
on x.party_code = y.Party_code and x.scrip_cd = y.scrip_cd and x.segment = y.segment                            
                        
select x.*,y.net_def,tradername into #Final1 from #Final x left outer join                         
intranet.risk.dbo.collection_client_details y on x.party_code = y.party_code                         
                
Select Party_Code,sum(isnull(PledgeValue,0))PledgeValue,                
sum(isnull(FreeValue,0))FreeValue,isnull(net_def,0)net_def into #FinalCalc from #Final1                       
group by Party_Code,net_def                 
                      
----------------Table For Generate File--------------------------------                
truncate table tbl_Pledge_Data         
             
insert into tbl_Pledge_Data                    
select party_code,BcltDpId,cltdpid,Segment,scrip_cd,Pledge_Qty,PledgeValue,Free_Qty,FreeValue,CertNo,net_def,                    
New_Pledge,Condition,                  
case                                   
when New_pledge <= 1000 and New_pledge > -1000  then 'NA'                
when New_pledge <= -1000 and New_pledge < 0 then 'R'                
when New_pledge > 1000 then 'P' end P_R,                
tradername,isnull(cls,0)cls,Sett_No,Sett_type,0                  
from                            
(                            
select *,New_Pledge =                 
convert(decimal(20,2),                
Case       
When net_def < 0 then PledgeValue *-1              
WHEN net_def > 0 then       
case      
When net_def*2-PledgeValue < 0 then net_def*2-PledgeValue          
When net_def*2-PledgeValue > 0 then                 
case       
when (net_def*2-PledgeValue)- FreeValue < 0 then net_def*2-PledgeValue                
when (net_def*2-PledgeValue)- FreeValue > 0 then FreeValue end      
end               
End) ,'PED' as Condition from #Final1 --------1                    
union all                    
select *,case when net_def <> 0 then FreeValue end ,'ADC' from #Final1 where net_def>0   ---------2                    
union all                    
select *,FreeValue ,'AC' from #Final1  --------------------3                    
)x                
                
-----------------Table For View Data--------------------------------------                
truncate table tbl_NewPledge_Calc    
               
insert into tbl_NewPledge_Calc                
select party_code,isnull(PledgeValue,0)PledgeValue,isnull(FreeValue,0)FreeValue,isnull(net_def,0)net_def,              
isnull(New_Pledge,0) New_Pledge,isnull(Condition,'')Condition,              
isnull              
(case                
when New_pledge <= 1000 and New_pledge > -1000  then 'NA'                
when New_pledge <= -1000 and New_pledge < 0 then 'R'                
when New_pledge > 1000 then 'P' end,'NA') P_R                
from                            
(                            
select *,New_Pledge =                 
convert(decimal(20,2),                
Case       
When net_def < 0 then PledgeValue *-1              
WHEN net_def > 0 then       
case      
When net_def*2-PledgeValue < 0 then net_def*2-PledgeValue          
When net_def*2-PledgeValue > 0 then                 
case       
when (net_def*2-PledgeValue)- FreeValue < 0 then net_def*2-PledgeValue                
when (net_def*2-PledgeValue)- FreeValue > 0 then FreeValue end      
end               
End) ,'PED' as Condition from #FinalCalc --------1                    
union all                    
select *,case when net_def <> 0 then FreeValue end ,'ADC' from #FinalCalc  where net_def>0  ---------2                    
union all                    
select *,FreeValue ,'AC' from #FinalCalc  --------------------3                    
)x

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_fetchdirectors_holding
-- --------------------------------------------------

CREATE proc [dbo].[usp_fetchdirectors_holding]  
as  
  
select cm_blsavingcd,cm_cd into #tt from  
--dpbackoffice.acercross.dbo.client_master with(nolock) where cm_blsavingcd in  
[ABCSOORACLEMDLW].synergy.dbo.client_master with (nolock) where cm_blsavingcd in  
(select cl_code from directorslist with (nolock))  
  
select party_Code into #tt1 from anand1.msajag.dbo.client_details with (nolock) where party_Code in  
(select cl_code from directorslist with (nolock)  
where cl_Code not in(select cm_blsavingcd from #tt))  
  
select party_code=cm_blsavingcd,cm_cd into #file From #tt  
union  
select party_Code,'' from #tt1  
  
select b.*,a.*,segment=space(10) into #file1 from  
--(select distinct hld_hold_date,hld_ac_code,hld_isin_code,DPHolding=hld_ac_pos  
-- from dpbackoffice.acercross.dbo.holding with(nolock))a  
(select distinct hld_hold_date = convert(varchar, hld_hold_date, 112), hld_ac_code,hld_isin_code,DPHolding=hld_ac_pos  
from [ABCSOORACLEMDLW].synergy.dbo.holding with (nolock))a  
inner join  
(select * from #file)b  
on a.hld_ac_code=b.cm_cd  
order by a.hld_ac_code  
  
--select * from #file1  
----select top 10 *from intranet.risk.dbo.holding  
  
select a.isin,a.party_code,poolhold=a.qty,a.Exchange into #pool from  
(select isin,party_code,qty,Exchange from intranet.risk.dbo.holding with (nolock))a  
inner join  
(select distinct party_Code from #file)b  
on a.party_Code=b.party_Code  
  
delete from director_dp where date=convert(datetime,convert(varchar(11),getdate()))  
delete from director_pool where date=convert(datetime,convert(varchar(11),getdate()))  
  
insert into director_dp  
select *,Date=convert(datetime,convert(varchar(11),getdate())) from #file1  
  
insert into director_pool  
select *,Date=convert(datetime,convert(varchar(11),getdate())) from #pool

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
              
 DECLARE @STR AS VARCHAR(1000)              
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
              
 SET @STR='SELECT DISTINCT O.NAME,O.XTYPE FROM '+@DBNAME+'SYSCOMMENTS  C '               
 SET @STR=@STR+' JOIN '+@DBNAME+'SYSOBJECTS O ON O.ID = C.ID '               
 SET @STR=@STR+' WHERE O.XTYPE IN (''P'',''V'') AND C.TEXT LIKE '''+@SRCSTR+''''                
 --PRINT @STR              
  EXEC(@STR)              
      
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateFileForPledgeSys
-- --------------------------------------------------
  
CREATE PROC [dbo].[USP_GenerateFileForPledgeSys]              
(@bank varchar(15),@condition as varchar(10),@Type as char(1),@AccId varchar(16),@percentage as int)                  
as                      
              
Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @bank            
---------Created Clustered on #bank table------------------              
create clustered index ix_bank on #bank(bank)                  
---------------------------------------------------------       
truncate table tpr1      
truncate table tpr2      
----------------------------------------------------------      
select * into #TempFile from               
(select * from tbl_Pledge_Data (nolock) where BcltDpId = @AccId and  P_R = @Type and condition=@condition)x              
inner join              
(select * from #bank)y on x.CertNo = y.isin              
-------------------------------------------------------------------------------------------------              
declare @bankaccno as varchar(100)                                              
declare @Agreementno as varchar(100)                                              
                                    
declare @company as varchar(100)                                    
declare @od as varchar(100)                                    
                                              
if @AccId = '1203320000000051'                                              
begin                                              
set @Agreementno = '04'                                         
set @company = 'Angel Capital & Debt Market Ltd '                                       
set @od = '000405024928'                                    
                                     
end                                              
                                              
if @AccId = '1203320000000066'                                              
begin                                              
set @Agreementno = '05'                                              
set @company = 'Angel Broking Ltd '                                      
set @od = '000405024923'                                    
                                      
end                   
----------------------------------------------------------------                            
set @bankaccno = (Select distinct Fld_BankAcno from mis.demat.dbo.tbl_BankMaster where Fld_BankName = @bank)              
        
create table #PR                      
(                                      
SrNo int identity(1,1),                                     
CertNo varchar(15),                                      
sname varchar(50),                                      
Free_Qty int                                      
)                
insert into #PR              
select CertNo,sname,sum(Free_Qty* @percentage /100) as FreeQty from #TempFile              
group by CertNo,sname              
---------------Generating Pledge Order No (PSN NO.)-------------------                      
Select * into #p2rel from MIS.Demat.dbo.Pledge2ReleaseEntry                      
                      
select x.*,pledgeOrder into #PR1 from                      
(Select * from #PR)x --where Bank = @bank            
left outer join                      
(Select Isin,min(pledgeOrder) pledgeOrder from #p2rel group by Isin)y                      
on x.CertNo = y.Isin                 
-----------------------------------------------------------------------              
        
----------------------Print-------------------------------------------                            
Select @company as Header into #tp                                                          
union                                                
Select 'Client ID :  '+@company              +@AccId                                                          
Union                                                           
Select @bank+'BANK -'+@bankaccno                                                  
union                                
Select 'Agreement No. '+@Agreementno+',,AC. NO. '+@od                                    
union                                      
Select 'PLEDGE-,'+convert(varchar(11),getdate(),103)                                                  
union                                  
Select 'SR.NO.,ISIN,SCRIP NAME,QUANTITY,PLEDGE ORD NO.'                             
                            
if @Type = 'P'      
begin        
insert into tpr1      
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                                                  
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge_release from #PR1                                       
/*where Bank=@bank  and P_R=@Type and condition like @condition*/                                   
order by SrNo                           
end      
      
if @Type = 'R'      
begin        
insert into tpr1      
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                                                  
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge_release from #PR1                                       
/*where Bank=@bank  and P_R=@Type and condition like @condition*/                                   
order by SrNo                           
end                            
                            
Select * into Print_File from #tp                                      
union all                                        
Select * from tpr1                  
                            
-----------------------Bank------------------------------------------                            
Select 'SN,Flag,Agreement No,Pledgee Account Number,Pledgor Account Number,Pledgor Account Name,Date Of Pledging,Pledge Expiry Date,Remarks,Sr No,ISIN Code,L/F,Flag Lockin Reason,Lockin Release Date,Quantity,PSN No' as Header into #tr                    
  
     
     
        
                               
if @Type = 'P'      
begin        
insert into tpr2      
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                  
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                                  
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                                  
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge      
from #PR1      
order by SrNo      
end       
      
if @Type = 'R'                                                                  
begin        
insert into tpr2      
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                  
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                                  
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                                  
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge      
from #PR1      
order by SrNo      
end      
                           
                              
Select * into Bank_File from #tr                                        
union all                                        
Select * from tpr2 (nolock)                              
-----------------declararion---------------------------------                            
declare @ss as varchar(500)                                                                        
declare @s2 as varchar(500)                                                                        
declare @sss_PR as varchar(500)                            
declare @sss_PB as varchar(500)                            
declare @sss_RP as varchar(500)                                                                        
declare @sss_RB as varchar(500)               
declare @s as varchar(100)                                                  
                                            
declare @bb as varchar(500)                                            
declare @b2 as varchar(500)                                         
declare @bbb as varchar(500)                                                                        
declare @b as varchar(100)                             
-----------------Pledge File-------------------------------------------------------------------------                                                        
if @Type = 'P'                                                                    
begin                                       
                            
set @sss_PR=@Bank+'_PrintPledgeFile'+convert(varchar,getdate(),105)                                                          
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PR+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                     
     
     
      
set @s2= @ss+''''                                        
exec(@s2)                                        
drop table Print_File                             
                            
set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                        
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                       
     
    
      
set @s2= @ss+''''                                        
exec(@s2)                                        
drop table Bank_File                                      
                  
----------------------Pledge BO File------------------------------------                              
--Select 'Client Code, ISIN, QTY, Ben. A/c No' as Header into #BPH                              
                            
Select ltrim(rtrim(Party_Code))+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','    
+convert(varchar(100),ltrim(rtrim(sum(Free_Qty))))+','+ltrim(rtrim(@AccId)) as pledge                              
into #PB1 from #TempFile                                        
where Bank=@bank and P_R= @Type and condition like @condition and Free_Qty > 0     
group by Party_Code,CertNo      
    
--order by SrNo --and party_code = 'M709'                                        
                                        
--Select * into BO_File from #BPH                              
--union all                   
Select * into BO_File from #PB1                              
                              
set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                        
set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                              
set @b2= @bb+''''                                                                          
exec(@b2)                                        
drop table BO_File                                     
        
End                                   
--************************************************************************************************--                                                                
--------------Rlease File-------------------------------------------------------------------------                                                                      
if @Type = 'R'                                      
begin                                    
                            
set @sss_RP=@Bank+'_PrintReleaseFile'+convert(varchar,getdate(),105)                                                          
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RP+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                      
     
    
     
set @s2= @ss+''''                                        
exec(@s2)                                      
drop table Print_File                               
                              
set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                        
set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'             
set @s2= @ss+''''                                        
exec(@s2)                                        
drop table Bank_File                            
                                  
------------------Release BO File--------------------------------------------------------------------------------                                        
Select Sett_No+','+Sett_type+','+Party_Code+','+Tradername+','+sname+','+                                        
scrip_cd+','+Segment+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','+'12033200'+','+@AccId+','                                        
+convert(varchar(100),ltrim(rtrim(Free_Qty))) as pledge                                        
into #Br1 from #TempFile                                        
where Bank=@bank and P_R= @Type and condition like @condition and Free_Qty > 0 order by SrNo --and party_code = 'M709'                                        
                                        
/*Select * into BO_File from #br                                        
union all*/                                        
Select * into BO_File from #br1 (nolock)                                   
                                        
set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                        
set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                        
set @b2= @bb+''''                                                                          
exec(@b2)                                        
drop table BO_File                              
end                                        
---------------------------------------------------------------------------------------------------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateFileForPledgeSys_new
-- --------------------------------------------------
CREATE PROC [dbo].[USP_GenerateFileForPledgeSys_new]                                              
(@bank varchar(15),@condition as varchar(10),@Type as char(1),@AccId varchar(16),@percentage as int)                                                            
as                                                       
                                        
/*declare @bank varchar(15),@condition as varchar(10),@Type as char(1),@AccId varchar(16),@percentage as int                                                 
                                        
Set @bank = 'ICICI'                                        
Set @condition = 'PED'                                        
Set @Type = 'P'                                        
Set @AccId = '1203320000000051'                                        
Set @percentage = '100'*/                                        
                                  
/*if @condition = 'AC'                                    
begin                                    
set @Type = '%%'                                    
end                                  
  */                                  
                                  
                                  
if @percentage = ''                                    
begin                                    
set @percentage = 100                                    
end                                  
                                                        
Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @bank                                                      
---------Created Clustered on #bank table------------------                                                        
create clustered index ix_bank on #bank(bank)                                                            
---------------------------------------------------------                                                 
truncate table tpr1                                                
truncate table tpr2                                                
----------------------------------------------------------                                                
                
Create table #TempFile                
(                
SrNo INT,party_code varchar(50),BcltDpId varchar(50),cltdpid varchar(50),Segment varchar(50),scrip_cd varchar(50),                
Pledge_Qty int,PledgeValue money,Free_Qty int,FreeValue money,CertNo varchar(50),                
net_def money,New_Pledge money,Condition varchar(50),P_R varchar(5),tradername varchar(1000),                
cls money,Sett_No varchar(50),Sett_type varchar(50),Fld_NewPledgeQty int,scode varchar(50),                
sname varchar(50),Bank varchar(50),isin varchar(50))                
                
if @Type = 'P'                
begin                
insert into #TempFile                 
Select * from                
(select * from tbl_Pledge_Data (nolock) where BcltDpId = @AccId and  P_R like @Type  and New_Pledge > 0                    
and condition=@condition)x       ---and Fld_NewPledgeQty > 0                                                  
inner join                                                        
(select * from #bank)y on x.CertNo = y.isin                
end                
              
if @Type = 'R'                
begin                
insert into #TempFile                
select * from                                                         
(select * from tbl_Pledge_Data (nolock) where net_def < 0 and BcltDpId = @AccId and condition=@condition              
--------BcltDpId = @AccId and  P_R like @Type  and New_Pledge > 0 and condition=@condition                
)x       ---and Fld_NewPledgeQty > 0                                                  
inner join                                                        
(select * from #bank)y on x.CertNo = y.isin                
end                
-------------------------------------------------------------------------------------------------               
declare @bankaccno as varchar(100)       
declare @Agreementno as varchar(100)                                                                                        
                                                                              
declare @company as varchar(100)                                                         
declare @od as varchar(100)                                                 
declare @Heder_hdfc as varchar(100)                                              
                                       
if @AccId = '1203320000000051'                                                                                        
begin                                                                                        
set @Agreementno = '04'                                                       
set @company = 'Angel Capital & Debt Market Ltd '                                                                                 
set @od = '000405024928'                                                                              
                                                                               
end                                                                                        
                                                                                        
if @AccId = '1203320000000066'                                                                                        
begin                                                                                        
set @Agreementno = '05'                                                                                        
set @company = 'Angel Broking Ltd '                                                                                
set @od = '000405024923'                                                                              
                                                                                
end                    
----------------------------------------------------------------                                                                      
set @bankaccno = (Select distinct Fld_BankAcno from mis.demat.dbo.tbl_BankMaster where Fld_BankName = @bank)                                                        
                                              
create table #PR                                                                
(                                                                                
SrNo int identity(1,1),                                                                               
CertNo varchar(15),                                           
sname varchar(50),                                                                                
Free_Qty int                                                     
)                                                          
      
if @Type = 'P'      
begin      
      
insert into #PR      
select CertNo,sname,case when @condition = 'PED' then sum(New_Pledge* @percentage /100) else      
sum(Free_Qty* @percentage /100) end as FreeQty from #TempFile      
group by CertNo,sname      
      
end      
      
if @Type = 'R'      
begin      
      
insert into #PR      
select CertNo,sname,case when @condition = 'PED' then sum(New_Pledge* @percentage /100) else      
sum(Pledge_Qty* @percentage /100) end as Free_Qty from #TempFile      
group by CertNo,sname      
      
end      
                                          
---------------Generating Pledge Order No (PSN NO.)-------------------                                                           
Select * into #p2rel from MIS.Demat.dbo.Pledge2ReleaseEntry                                                                
                                                                
select x.*,pledgeOrder into #PR1 from                                                  
(Select * from #PR)x --where Bank = @bank                                                      
left outer join                   
(Select Isin,min(pledgeOrder) pledgeOrder from #p2rel group by Isin)y                                                                
on x.CertNo = y.Isin                                                           
-----------------------------------------------------------------------                                                        
                                                  
----------------------Print-------------------------------------------                                              
if @type = 'P'                                              
begin                                              
set @Heder_hdfc = 'Request for Lodgment of Securities'                                              
end                
else                                              
begin                                              
set @Heder_hdfc = 'Request for Withdrawal of Securities'                                              
end              
-----------------------Hdfc Format-------------------------------------                                              
Select 'FAS No.,,,,Pledgor DP ID,''''12033200' as Header into #tp_hdfc                                              
union all                                             
Select 'Account Number,,'''''+@od+',,Pledgor DP Name,'+@company                                              
Union all                                          
Select 'Account Name,,'+@company+',,Pledgor Client ID,'''''+@AccId                                              
union all                                             
Select 'TRF Serial No.,,,,Pledgor Client Name,'+@company                                    
union all                                             
Select ',,,,Date,'+convert(varchar(11),getdate(),103)                                                                                      
union all                                             
Select @Heder_hdfc                                              
union all                                          
Select 'SR.NO.,ISIN,SCRIP NAME,QUANTITY,PLEDGE ORD NO.,Remarks (Not to be filled by Customer)'                                              
-----------------------------------------------------------------------                                              
Select @company as Header into #tp                                              
union all                                             
Select 'Client ID :  '+@company              +@AccId                                                                                                    
Union all                                          
Select @bank+'BANK -'+@bankaccno                                                                                            
union all                                             
Select 'Agreement No. '+@Agreementno+',,AC. NO. '+@od                                                                              
union all                                  
Select 'PLEDGE-,'+convert(varchar(11),getdate(),103)                                                                                            
union all                                             
Select 'SR.NO.,ISIN,SCRIP NAME,QUANTITY,PLEDGE ORD NO.'                                              
                                              
                                                                      
if @Type = 'P'                                              
begin                                              
insert into tpr1                                                
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                                                                                            
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge_release from #PR1                                                                                 
/*where Bank=@bank  and P_R like @Type and condition like @condition*/                                                 
order by SrNo                                                                     
end                                                
                                                
if @Type = 'R'                         
begin                                                  
insert into tpr1                                                
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                                    
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge_release from #PR1                                                                    
/*where Bank=@bank  and P_R like @Type and condition like @condition*/                                  
order by SrNo                                                                     
end                                                                      
                                                 
Select * into Print_File_hdfc from #tp_hdfc                                          
union all                                                                                  
Select * from tpr1                                         
                                              
Select * into Print_File from #tp                                              
union all                                                                              
Select * from tpr1                                               
                                              
-----------------------Bank------------------------------------------                                          
Select 'SN,Flag,Agreement No,Pledgee Account Number,Pledgor Account Number,Pledgor Account Name,Date Of Pledging,Pledge Expiry Date,Remarks,Sr No,ISIN Code,L/F,Flag Lockin Reason,Lockin Release Date,Quantity,PSN No' as Header into #tr                    
  
    
      
        
          
          
if @Type = 'P'                                               
begin                                                  
insert into tpr2                                                
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                                                            
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                                                                            
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                                                                            
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge                                                
from #PR1                                                
order by SrNo                                                
end                                                 
                                              
if @Type = 'R'                                              
begin                                              
insert into tpr2                                                
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                                                            
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                              
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                              
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge                                                
from #PR1                                                
order by SrNo                                                
end                                              
                                                                  
Select * into Bank_File from #tr                           
union all                                                                                  
Select * from tpr2 (nolock)                                                                        
-----------------declararion---------------------------------      
declare @ss as varchar(500)                                                                                                                  
declare @s2 as varchar(500)                                                                                                                  
declare @sss_PR as varchar(500)                                                                      
declare @sss_PB as varchar(500)                                                      
declare @sss_RP as varchar(500)                                                                                                                  
declare @sss_RB as varchar(500)                                                                                                               
declare @s as varchar(100)                                                                                            
                                    
declare @bb as varchar(500)                                                  
declare @b2 as varchar(500)                                                                                                                  
declare @bbb as varchar(500)                                                                                                                  
declare @b as varchar(100)                                                         
-----------------Pledge File-------------------------------------------------------------------------                                                                                                  
if @Type = 'P'                                                                               
begin                                           
                                                                      
 set @sss_PR=@Bank+'_PrintPledgeFile'+convert(varchar,getdate(),105)                                                                                                    
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PR+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                    
     
    
       
        
         
             
 set @s2= @ss+''''                                                                                  
 exec(@s2)                                   
                                                                       
 if @bank = 'HDFC'                                              
 begin                                              
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                                                                  
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                
     
    
      
        
          
            
                                 
 set @s2= @ss+''''                                                 
 exec(@s2)                                                    
                                              
 end                              
 else                              
 begin                              
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                              
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                   
                               
 set @s2= @ss+''''                              
 exec(@s2)                                                    
 end                                              
                              
 drop table Print_File_hdfc                                              
 drop table Print_File                                              
 drop table Bank_File                               
                                                             
 ----------------------Pledge BO File------------------------------------                                          
 --Select 'Client Code, ISIN, QTY, Ben. A/c No' as Header into #BPH                                          
          
 Select ltrim(rtrim(Party_Code))+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','                                                                        
 +convert(varchar(100),ltrim(rtrim(sum(Free_Qty))))+','+ltrim(rtrim(@AccId)) as pledge                                                                        
 into #PB1 from #TempFile                                                         
 where Bank=@bank and P_R like @Type and condition like @condition and Free_Qty > 0          
--Free_Qty > 0                             
group by Party_Code,CertNo                            
--order by SrNo --and party_code = 'M709'                                                                                  
                  
 --Select * into BO_File from #BPH                                                                        
 --union all                                                             
 Select * into BO_File from #PB1                                                
                                                                         
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                                                  
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                       
    
     
      
        
          
          
 set @b2= @bb+''''                                                                                                                    
 exec(@b2)                                                                                  
 drop table BO_File                                                                               
                                                  
End                                     
--************************************************************************************************--                                                     
--------------Rlease File-------------------------------------------------------------------------                                                                                                                
if @Type = 'R'                                              
begin                  
                                                                      
 set @sss_RP=@Bank+'_PrintReleaseFile'+convert(varchar,getdate(),105)                                                                                                    
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RP+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                     
     
    
      
        
          
                  
 set @s2= @ss+''''                                                                                  
 exec(@s2)                                                                                
                                              
 if @bank = 'HDFC'                                              
 begin                                              
                                              
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                                                  
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                
     
    
      
        
          
           
set @s2= @ss+''''                                              
 exec(@s2)                                                                                
                                              
 end                                              
 else                                            
 begin                                              
                                               
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                            
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                      
    
     
      
        
          
            
 set @s2= @ss+''''                                                                                  
 exec(@s2)                                                          
                                               
 end                    
                                            
 drop table Print_File_hdfc                                              
 drop table Print_File                                              
 drop table Bank_File                                         
                                                                             
 ------------------Release BO File--------------------------------------------------------------------------------                                                                                  
 Select LTRIM(RTRIM(Sett_No))+','+LTRIM(RTRIM(Sett_type))+','+LTRIM(RTRIM(Party_Code))+','+LTRIM(RTRIM(Tradername))+','+LTRIM(RTRIM(sname))+','+                                                                                  
 LTRIM(RTRIM(scrip_cd))+','+LTRIM(RTRIM(Segment))+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','+'12033200'+','+@AccId+','                                
 +convert(varchar(100),ltrim(rtrim(Pledge_Qty))) as pledge                                                                                  
 into #Br1 from #TempFile                                                     
 where Bank=@bank and condition like @condition and Pledge_Qty > 0 order by SrNo --and party_code = 'M709'                                                                                  
------P_R like @Type and          
--Fld_NewPledgeQty>Free_Qty          
          
 /*Select * into BO_File from #br                                                                         
 union all*/                                         
 Select * into BO_File from #br1 (nolock)                                                                             
                                                                                   
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                                                  
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                       
     
    
     
        
          
 set @b2= @bb+''''                                                                                                                    
 exec(@b2)                                                                                  
 drop table BO_File                                               
                            
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GenerateFileForPledgeSys_new_dummy
-- --------------------------------------------------
CREATE PROC [dbo].[USP_GenerateFileForPledgeSys_new_dummy]    
(@bank varchar(15),@condition as varchar(10),@Type as char(1),@AccId varchar(16),@percentage as int)                                                          
as                                                     
                                      
/*declare @bank varchar(15),@condition as varchar(10),@Type as char(1),@AccId varchar(16),@percentage as int                                               
                                      
Set @bank = 'ICICI'                                      
Set @condition = 'PED'                                      
Set @Type = 'P'                                      
Set @AccId = '1203320000000051'                                      
Set @percentage = '100'*/                                      
                                
/*if @condition = 'AC'                                  
begin                                  
set @Type = '%%'                                  
end                                
  */                                
                                
                                
if @percentage = ''                                  
begin                                  
set @percentage = 100                                  
end                                
                                                      
Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @bank                                                    
---------Created Clustered on #bank table------------------                                                      
create clustered index ix_bank on #bank(bank)                                                          
---------------------------------------------------------                                               
truncate table tpr1                                              
truncate table tpr2                                              
----------------------------------------------------------                                              
              
Create table #TempFile              
(              
SrNo INT,party_code varchar(50),BcltDpId varchar(50),cltdpid varchar(50),Segment varchar(50),scrip_cd varchar(50),              
Pledge_Qty int,PledgeValue money,Free_Qty int,FreeValue money,CertNo varchar(50),              
net_def money,New_Pledge money,Condition varchar(50),P_R varchar(5),tradername varchar(1000),              
cls money,Sett_No varchar(50),Sett_type varchar(50),Fld_NewPledgeQty int,scode varchar(50),              
sname varchar(50),Bank varchar(50),isin varchar(50))              
              
if @Type = 'P'              
begin              
insert into #TempFile               
Select * from              
(select * from tbl_Pledge_Data (nolock) where BcltDpId = @AccId and  P_R like @Type  and New_Pledge > 0                  
and condition=@condition)x       ---and Fld_NewPledgeQty > 0                                                
inner join                                                      
(select * from #bank)y on x.CertNo = y.isin              
end              
            
if @Type = 'R'              
begin              
insert into #TempFile              
select * from                                                       
(select * from tbl_Pledge_Data (nolock) where net_def < 0 and BcltDpId = @AccId and condition=@condition            
--------BcltDpId = @AccId and  P_R like @Type  and New_Pledge > 0 and condition=@condition              
)x       ---and Fld_NewPledgeQty > 0                                                
inner join                                                      
(select * from #bank)y on x.CertNo = y.isin              
end              
-------------------------------------------------------------------------------------------------                                                      
declare @bankaccno as varchar(100)                                                                                      
declare @Agreementno as varchar(100)                                                                                      
                                          
declare @company as varchar(100)                                                       
declare @od as varchar(100)                                               
declare @Heder_hdfc as varchar(100)                                            
                                     
if @AccId = '1203320000000051'                                                                                      
begin                                                                                      
set @Agreementno = '04'                                                     
set @company = 'Angel Capital & Debt Market Ltd '                                                                               
set @od = '000405024928'                                                                            
                                                                             
end                                                                                      
                                                                                      
if @AccId = '1203320000000066'                                                                                      
begin                                                                                      
set @Agreementno = '05'                                                                                      
set @company = 'Angel Broking Ltd '                                                                              
set @od = '000405024923'                                                                            
                                                                              
end                  
----------------------------------------------------------------                                                                    
set @bankaccno = (Select distinct Fld_BankAcno from mis.demat.dbo.tbl_BankMaster where Fld_BankName = @bank)                                                      
                                            
create table #PR                                                              
(                                                                              
SrNo int identity(1,1),                                                                             
CertNo varchar(15),                                         
sname varchar(50),                                                                              
Free_Qty int                                                   
)                                                        
insert into #PR                                                      
select CertNo,sname,case when @condition = 'PED' then sum(New_Pledge* @percentage /100) else                                    
sum(Free_Qty* @percentage /100) end as FreeQty from #TempFile                                                  
group by CertNo,sname                                                      
---------------Generating Pledge Order No (PSN NO.)-------------------                                                         
Select * into #p2rel from MIS.Demat.dbo.Pledge2ReleaseEntry                                                              
                                                              
select x.*,pledgeOrder into #PR1 from                                                
(Select * from #PR)x --where Bank = @bank                                                    
left outer join                                                              
(Select Isin,min(pledgeOrder) pledgeOrder from #p2rel group by Isin)y                                                              
on x.CertNo = y.Isin                                                         
-----------------------------------------------------------------------                                                      
          
----------------------Print-------------------------------------------                                            
if @type = 'P'                                            
begin                                        
set @Heder_hdfc = 'Request for Lodgment of Securities'                                            
end              
else                                            
begin                                            
set @Heder_hdfc = 'Request for Withdrawal of Securities'                                            
end            
-----------------------Hdfc Format-------------------------------------                                            
Select 'FAS No.,,,,Pledgor DP ID,''''12033200' as Header into #tp_hdfc                                            
union all                                           
Select 'Account Number,,'''''+@od+',,Pledgor DP Name,'+@company                                            
Union all                                        
Select 'Account Name,,'+@company+',,Pledgor Client ID,'''''+@AccId                                            
union all                                           
Select 'TRF Serial No.,,,,Pledgor Client Name,'+@company                                  
union all                                           
Select ',,,,Date,'+convert(varchar(11),getdate(),103)                                                                                    
union all                                           
Select @Heder_hdfc                                            
union all                                        
Select 'SR.NO.,ISIN,SCRIP NAME,QUANTITY,PLEDGE ORD NO.,Remarks (Not to be filled by Customer)'                                            
-----------------------------------------------------------------------                                            
Select @company as Header into #tp                                            
union all                                           
Select 'Client ID :  '+@company              +@AccId                                                                                                  
Union all                                        
Select @bank+'BANK -'+@bankaccno                                                                                          
union all                                           
Select 'Agreement No. '+@Agreementno+',,AC. NO. '+@od                                                                            
union all                                
Select 'PLEDGE-,'+convert(varchar(11),getdate(),103)                                                                                          
union all                                           
Select 'SR.NO.,ISIN,SCRIP NAME,QUANTITY,PLEDGE ORD NO.'                                            
                                            
                                                                    
if @Type = 'P'                                            
begin                                            
insert into tpr1                                              
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                                                                                          
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge_release from #PR1                                                                               
/*where Bank=@bank  and P_R like @Type and condition like @condition*/                                                                           
order by SrNo                                                                   
end                                              
                                              
if @Type = 'R'                                              
begin                                                
insert into tpr1                                              
Select convert(varchar(100),SrNo)+','+ltrim(rtrim(CertNo))+','+sname+','+                   
convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge_release from #PR1                                                                               
/*where Bank=@bank  and P_R like @Type and condition like @condition*/                                
order by SrNo                                                                   
end                                                                    
                                               
Select * into Print_File_hdfc from #tp_hdfc                                        
union all                                                                                
Select * from tpr1                                       
                                            
Select * into Print_File from #tp                                            
union all                                                                            
Select * from tpr1                                             
                                            
-----------------------Bank------------------------------------------                                        
Select 'SN,Flag,Agreement No,Pledgee Account Number,Pledgor Account Number,Pledgor Account Name,Date Of Pledging,Pledge Expiry Date,Remarks,Sr No,ISIN Code,L/F,Flag Lockin Reason,Lockin Release Date,Quantity,PSN No' as Header into #tr                    
  
    
      
        
        
if @Type = 'P'                                             
begin                                                
insert into tpr2                                              
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                                                          
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                                                                          
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                                                                          
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+'' as pledge                                              
from #PR1                                              
order by SrNo                                              
end                                               
                                            
if @Type = 'R'                                            
begin                                            
insert into tpr2                                              
Select convert(varchar(100),ltrim(rtrim(SrNo)))+','+''+','+@Agreementno+','''+@bankaccno+','''+@AccId+','+@company+','+                                                                                          
''+','+''+','+''+','+convert(varchar(100),ltrim(rtrim(SrNo)))+','+                                            
convert(varchar(100),ltrim(rtrim(CertNo)))+','+'F'+','+''+','+                                            
''+','+convert(varchar(100),ltrim(rtrim(Free_Qty)))+','+pledgeOrder as pledge                                              
from #PR1                                              
order by SrNo                                              
end                                            
                                                                
Select * into Bank_File from #tr                                                                      
union all                                                                                
Select * from tpr2 (nolock)                                                                      
-----------------declararion---------------------------------                                                                    
declare @ss as varchar(500)                                                                                                                
declare @s2 as varchar(500)                                                                     
declare @sss_PR as varchar(500)                                                                    
declare @sss_PB as varchar(500)                                                                    
declare @sss_RP as varchar(500)                            
declare @sss_RB as varchar(500)                                                                                                             
declare @s as varchar(100)                                                                                          
                                  
declare @bb as varchar(500)                                                
declare @b2 as varchar(500)                                                                                                                
declare @bbb as varchar(500)                                                                                                                
declare @b as varchar(100)                                                       
-----------------Pledge File-------------------------------------------------------------------------                                                                                                
if @Type = 'P'                                                                             
begin                                         
                                                                    
 set @sss_PR=@Bank+'_PrintPledgeFile'+convert(varchar,getdate(),105)                                                                                                  
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PR+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                    
     
     
      
       
           
 set @s2= @ss+''''                                                                                
 exec(@s2)                                 
                                                                     
 if @bank = 'HDFC'                                            
 begin                                            
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                                                                                
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                
     
    
      
        
          
                               
 set @s2= @ss+''''                                               
 exec(@s2)                                                  
                                            
 end                            
 else                            
 begin                            
 set @sss_PB=@Bank+'_BankPledgeFile'+convert(varchar,getdate(),105)                            
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_PB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                 
                             
 set @s2= @ss+''''                            
 exec(@s2)                                                  
 end                                            
                            
 drop table Print_File_hdfc                                            
 drop table Print_File                                            
 drop table Bank_File                                                                                
                                                           
 ----------------------Pledge BO File------------------------------------                                        
 --Select 'Client Code, ISIN, QTY, Ben. A/c No' as Header into #BPH                                    
        
 Select ltrim(rtrim(Party_Code))+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','                                                                      
 +convert(varchar(100),ltrim(rtrim(sum(Free_Qty))))+','+ltrim(rtrim(@AccId)) as pledge                                                                      
 into #PB1 from #TempFile                      
 where Bank=@bank and P_R like @Type and condition like @condition and Free_Qty > 0        
--Free_Qty > 0                           
group by Party_Code,CertNo                          
--order by SrNo --and party_code = 'M709'                                                                                
                
 --Select * into BO_File from #BPH                                                                      
 --union all                                                           
 Select * into BO_File from #PB1                                              
                                                                       
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                                                
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                      
     
     
      
        
        
 set @b2= @bb+''''                                                                                                                  
 exec(@b2)                                                                                
 drop table BO_File                                                                             
                                                
End                                   
--************************************************************************************************--                                                   
--------------Rlease File-------------------------------------------------------------------------                                                                                                              
if @Type = 'R'                                            
begin                
                                                                    
 set @sss_RP=@Bank+'_PrintReleaseFile'+convert(varchar,getdate(),105)                                                                                                  
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RP+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                     
     
    
      
        
                
 set @s2= @ss+''''                                                                                
 exec(@s2)                                                                              
                                            
 if @bank = 'HDFC'                                            
 begin                                            
                                            
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                                                
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Print_File_hdfc" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                
     
    
      
        
         
set @s2= @ss+''''                                                                 
 exec(@s2)                                                                              
                                            
 end                                            
 else                                          
 begin                         
                                             
 set @sss_RB=@Bank+'_BankReleaseFile'+convert(varchar,getdate(),105)                                                          
 set @ss = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.Bank_File" queryout '+'D:\upload1\PledgeSystem_File\Pledge_Release_File\'+@sss_RB+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                     
      
    
      
        
          
 set @s2= @ss+''''                                                                              
 exec(@s2)                                                        
                                             
 end                  
                                          
 drop table Print_File_hdfc                                            
 drop table Print_File                                            
 drop table Bank_File                                       
                                                                           
 ------------------Release BO File--------------------------------------------------------------------------------                                                                                
 Select Sett_No+','+Sett_type+','+Party_Code+','+Tradername+','+sname+','+                                                                                
 scrip_cd+','+Segment+','+convert(varchar(100),ltrim(rtrim(CertNo)))+','+'12033200'+','+@AccId+','                              
 +convert(varchar(100),ltrim(rtrim(Free_Qty))) as pledge                                                                                
 into #Br1 from #TempFile                                                   
 where Bank=@bank and condition like @condition and Pledge_Qty > 0 order by SrNo --and party_code = 'M709'                                                                                
------P_R like @Type and        
--Fld_NewPledgeQty>Free_Qty        
        
 /*Select * into BO_File from #br                                                                       
 union all*/                                       
 Select * into BO_File from #br1 (nolock)                                                                           
                                                                                 
 set @bbb=@Bank+'_BOFile_'+@Type+convert(varchar,getdate(),105)                                                                                
 set @bb = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp "Select * from AngelDemat.AngelInhouse.dbo.BO_File" queryout '+'D:\upload1\PledgeSystem_File\BOFiles\'+@bbb+'.csv -c -Smis -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'                                       
    
    
      
        
 set @b2= @bb+''''                                                                                                                  
 exec(@b2)                                                                                
 drop table BO_File                                             
                                                                     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_HoldingAsOnDate
-- --------------------------------------------------
CREATE Proc Usp_HoldingAsOnDate                   
@AccountId as Varchar(16),                  
@ScripCode as Varchar(10),                  
@HoldingDate as Varchar(8),    
@isinno as varchar(15)                  
as                  
set nocount on                                
/*       
Exec spDeepak_HoldingAsOnDate '15464303','532371','20061028'               
              
Declare @AccountId as Varchar(16),                  
@ScripCode as Varchar(10),                  
@HoldingDate as Varchar(8)                  
Set @AccountId = '15464303'              
Set @ScripCode = '532532'              
Set @HoldingDate = '20061017'                    
  
Declare @AccountId as Varchar(16),                  
@ScripCode as Varchar(10),                  
@HoldingDate as Varchar(8),    
@isinno as varchar(15)                  
Set @AccountId = '13326100'--'15464303'              
Set @ScripCode = '500470'--'532371'              
Set @HoldingDate = '20061017'                  
set @isinno='INE081A01012'    
*/                                    
SELECT DPCLCODE,SUM(DPQTY) as 'Holding', DPSCCODE = @ScripCode ,dpref5=@isinno               
into #Holding /* Drop Table #Holding */              
FROM mimansa.bits.dbo.ANGELDPTRAN WHERE DPSCCODE =  @ScripCode                  
AND ACCOUNTID =  @AccountId  AND DPEXDATE < Replace(Convert(Varchar(10),Convert(Datetime,@HoldingDate)+1,102),'.','-')                 
AND ((DPTRFTAG = ''  AND DPFLAG = 'G')                  
OR (DPTRFTAG = 'T' AND DPBOOKDT > Replace(Convert(Varchar(10),Convert(Datetime,@HoldingDate),102),'.','-') AND DPFLAG = 'G'))                  
GROUP BY DPCLCODE                            
-- Select top 10* from #Holding    
-- Select * from mimansa.AngelCS.dbo.AngelInactiveClient  order by NewPArty_Code            
-- Select Count(*) from mimansa.AngelCS.dbo.AngelInactiveClient        
-- select * FROM mimansa.bits.dbo.ANGELDPTRAN where dpsccode='500470'            
Select Distinct 'Old' as 'OldNew',OldParty_Code,NewParty_Code,'N' as 'Eligible'         
into #Eligible /* Drop Table #Eligible */        
from mimansa.AngelCS.dbo.AngelInactiveClient       
where NewParty_code <> ''   and OldParty_code <> ''                  
--select top 5* from #Eligible    
Select *       
into #ToMatch  /* drop table #ToMatch */    
from #Holding       
where DPCLCode in       
(Select OldParty_Code from #Eligible )       
      
Delete from #Holding where DPCLCode      
in(      
Select OldParty_Code from (      
select * from #holding where dpclcode in (      
Select EL.NewParty_Code from #ToMatch TM      
left outer join       
#Eligible EL on DPCLCode = OldParty_Code      
)      
) x      
left outer join #Eligible EL1      
on x.DPCLCode = NewParty_Code      
)      
alter table #Holding add serialno int identity
--(Select Short_Name from mimansa.AngelCS.dbo.AngelClient1 where party_Code = DPCLCode ) as 'Name'                  
Select serialno,DPCLCODE as 'Party_Code', DPSCCODE as 'Scrip_Code' ,dpref5 as 'ISIN'           
,Holding ,holding as 'duplicateholding' from #Holding  order by DPCLCode   
/* drop table duplicate_holding */

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_HoldingnShortage
-- --------------------------------------------------
CREATE Proc Usp_HoldingnShortage       
@AccountId as Varchar(16),                        
@ScripCode as Varchar(10),                        
@HoldingDate as Varchar(8)          
--@isinno as varchar(15)                        
as                        
set nocount on                                      
/*             
Exec Usp_HoldingnShortage '15464303','532371','20061028'                     
                    
Declare @AccountId as Varchar(16),                        
@ScripCode as Varchar(10),                        
@HoldingDate as Varchar(8)                        
Set @AccountId = '15464303'                    
Set @ScripCode = '532532'                    
Set @HoldingDate = '20061017'                          
        
Declare @AccountId as Varchar(16),                        
@ScripCode as Varchar(10),                        
@HoldingDate as Varchar(8)          
                   
Set @AccountId = '13326100'--'15464303'                    
Set @ScripCode = '500470'--'532371'                    
Set @HoldingDate = '20061017'                        
          
*/     
--select top 5* from mimansa.bits.dbo.ANGELDPTRAN        
                                     
SELECT DPCLCODE,SUM(DPQTY) as 'Holding', DPSCCODE = @ScripCode             
into #Holdingrec   /* Drop Table #Holdingrec */                    
FROM mimansa.bits.dbo.ANGELDPTRAN WHERE DPSCCODE =  @ScripCode                        
AND ACCOUNTID =  @AccountId  AND DPEXDATE < Replace(Convert(Varchar(10),Convert(Datetime,@HoldingDate)+1,102),'.','-')                       
AND ((DPTRFTAG = ''  AND DPFLAG = 'G')                        
OR (DPTRFTAG = 'T' AND DPBOOKDT > Replace(Convert(Varchar(10),Convert(Datetime,@HoldingDate),102),'.','-') AND DPFLAG = 'G'))                        
GROUP BY DPCLCODE                                  
-- Select top 10* from #Holdingrec          
-- Select * from mimansa.AngelCS.dbo.AngelInactiveClient  order by NewPArty_Code                  
-- Select Count(*) from mimansa.AngelCS.dbo.AngelInactiveClient              
-- select * FROM mimansa.bits.dbo.ANGELDPTRAN where dpsccode='500470'                  
Select Distinct 'Old' as 'OldNew',OldParty_Code,NewParty_Code,'N' as 'Eligible'               
into #Eligible1  /* Drop Table #Eligible1 */              
from mimansa.AngelCS.dbo.AngelInactiveClient             
where NewParty_code <> ''   and OldParty_code <> ''                        
--select top 5* from #Eligible1          
Select *             
into #ToMatch1  /* drop table #ToMatch1 */          
from #Holdingrec             
where DPCLCode in             
(Select OldParty_Code from #Eligible1 )             
            
Delete from #Holdingrec where DPCLCode            
in(            
Select OldParty_Code from (            
select * from #holdingrec where dpclcode in (            
Select EL.NewParty_Code from #ToMatch1 TM            
left outer join             
#Eligible1 EL on DPCLCode = OldParty_Code            
)            
) x            
left outer join #Eligible1 EL1            
on x.DPCLCode = NewParty_Code            
)            
--alter table #Holdingrec add serialno int identity      
/*
Select DPCLCODE as 'Party_Code', DPSCCODE as 'Scrip_Code'            
,Holding ,sum(b.qty) as 'Shortage'    
 from #Holdingrec a,BSEDB..DELTRANS b      
where a.dpclcode=b.party_code and a.dpsccode=b.scrip_cd  
group by a.DPCLCODE,a.DPSCCODE,a.holding,b.qty
*/

select x.*,y.Qty from
(select * from #Holdingrec) x inner join 
(select party_code,sum(Qty) as Qty from BSEDB..DELTRANS where party_code in 
(select DPCLCODE from #Holdingrec) group by party_code) y 
on x.DpClCode = y.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_NSECertificate
-- --------------------------------------------------

CREATE Proc usp_NSECertificate(@rptdate as varchar(11),@access_to varchar(15),@access_code varchar(15))             
as              
            
set @rptdate = convert(datetime,@rptdate,103)            
              
select               
Date=convert(varchar(11),Fld_RptDate,103),              
[Client Code]=Fld_PartyCode,              
[Value of Securites Pledged with Bank for all Clients (T-1 day Rate) as on the date of maximum utilisation overdraft]=Convert(dec(15,2),isnull(Fld_NSETotalPledgeValue,0)),  
[Pledge Value (Proportion as e based on O/D availed]=Convert(dec(15,2),Fld_NSEValue/2),              
[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_CMLedgerT2),   
[CM Recipts/Payments on T Day]=Convert(dec(15,2),Fld_TDay_PR),  
[Recipts/Payments on T-1 Day]=Convert(dec(15,2),Fld_T1Day_PR),              
[MG 02 Requirement on T Day]=Convert(dec(15,2),Fld_MG02TDay),              
[MG 02 Requirement on T-1 Day]=Convert(dec(15,2),Fld_MG02T1Day),              
[Free Balance in CM Segment]=Convert(dec(15,2),Fld_CMFreeBal),              
[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Convert(dec(15,2),Fld_FOT1Bal),              
[FO Recipts/Payments on T Day]=Convert(dec(15,2),Fld_FOTPR),              
[FO Margin Ledger Balance on T Day]=Convert(dec(15,2),Fld_FOML),              
[T Day F&O Initial Margin Requirement]=Convert(dec(15,2),Fld_IM),              
[T Day F&O Exposure Margin Requirement]=Convert(dec(15,2),Fld_EM),              
[Free Balance in FO Segment]=Convert(dec(15,2),Fld_FreeBal),              
[Net Obligation]=Convert(dec(15,2),isnull(Fld_NSENetObligation,0)),  
[Value of improper use]=Convert(dec(15,2),isnull(Fld_NSEValueImproperUse,0)) from tbl_NSECertificate  where Fld_RptDate >= @rptdate            
and Fld_RptDate <= @rptdate +' 23:59:59' and Fld_NSEValue <> 0         
          
--Select * from tbl_NSECertificate  
  
--select               
--Date='',          
--[Client Code]='',              
--[Value of Securites Pledged with Bank for all Clients              
--(T-1 day Rate) as on the date of maximum utilisation overdraft]='',              
--[Pledge Value (Proportion as e based on O/D availed]=sum(Convert(dec(15,2),Fld_ClientPledgeValue)),              
--[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=sum(Convert(dec(15,2),Fld_CMLedgerT2)),              
--[CM Recipts/Payments on T Day]=sum(Convert(dec(15,2),Fld_TDay_PR)),              
--[Recipts/Payments on T-1 Day]=sum(Convert(dec(15,2),Fld_T1Day_PR)),              
--[MG 02 Requirement on T Day]=sum(Convert(dec(15,2),Fld_MG02TDay)),              
--[MG 02 Requirement on T-1 Day]=sum(Convert(dec(15,2),Fld_MG02T1Day)),              
--[Free Balance in CM Segment]=sum(Convert(dec(15,2),Fld_CMFreeBal)),              
--[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=sum(Convert(dec(15,2),Fld_FOT1Bal)),              
--[FO Recipts/Payments on T Day]=sum(Convert(dec(15,2),Fld_FOTPR)),              
--[FO Margin Ledger Balance on T Day]=sum(Convert(dec(15,2),Fld_FOML)),              
--[T Day F&O Initial Margin Requirement]=sum(Convert(dec(15,2),Fld_IM)),              
--[T Day F&O Exposure Margin Requirement]=sum(Convert(dec(15,2),Fld_EM)),              
--[Free Balance in FO Segment]=sum(Convert(dec(15,2),Fld_FreeBal)),              
--[Net Obligation]=sum(Convert(dec(15,2),Fld_NetOblgation)),              
--[Value of improper use]=sum(Convert(dec(15,2),Fld_ValueImproperUse)) from tbl_NSECertificate  where Fld_RptDate >= @rptdate            
--and Fld_RptDate <= @rptdate +' 23:59:59'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_POA_Clients
-- --------------------------------------------------
CREATE proc usp_POA_Clients          
(
@cl_code as varchar(15),
@brCode as varchar(15)
)
as        

         
select x.cl_code,long_name,sub_broker,branch_cd,          
BSEDPID=isnull(BSEDPId,'No Records'),          
BSECltId=isnull(BSECltId,'No Records'),          
NSEDPId=isnull(NSEDPId,'No Records'),          
NSECltid=isnull(NSECltId,'No Records'),        
BSEPOA=case when BSEPOA = '1' then 'Y' else 'N' end,        
NSEPOA=case when NSEPOA = '1' then 'Y' else 'N' end        
 from          
(          
select cl_code,long_name,sub_broker,branch_cd from intranet.risk.dbo.client_details     
where Last_inactive_date > getdate() and cl_code=@cl_code and branch_cd like @brCode

/*    
where          
(bsecm = 'Y' or nsecm = 'Y' or nsefo = 'Y')  and cl_code = 'A17106'    
(mcdx is null and ncdx is null and bsefo is null and mcd is null and nsx is null)     
and Last_inactive_date > getdate()  and  branch_cd <> 'PMOS'  and cl_type <> 'NBF'        
*/    
)x          
left outer join          
(          
select           
case when x.party_code is null then y.party_code else x.party_code end party_code,          
isnull(x.cltDpNo,'No Records') as BSECltId,          
isnull(y.cltDpNo,'No Records') as NSECltId,        
isnull(convert(varchar,x.def),'No Records') as BSEPOA,        
isnull(x.DPId,'No Records') as BSEDPId,          
isnull(y.DPId,'No Records') as NSEDPId,          
isnull(convert(varchar,y.def),'No Records')as NSEPOA        
from          
(select  * from BSEDB.DBO.V_BSEPOA where party_code=@cl_code)x          
full outer join          
(select * from msajag.dbo.V_NSEPOA where party_code=@cl_code )y          
on x.party_code = y.party_code          
)y on x.cl_code = y.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Port_Reco
-- --------------------------------------------------
CREATE Proc USP_Port_Reco 
as

truncate table tbl_Hold
truncate table tbl_Hold_rpt
truncate table tbl_PortFolio
truncate table tbl_portfolio_rpt

declare @Code as varchar(50)                      

DECLARE Port_cursor CURSOR FOR 
select  Distinct Top 100 Party_Code from  mimansa.angelcs.dbo.SummaryAngelClientPortfolio where Status = 'Open'             
OPEN Port_cursor           
                                        
FETCH NEXT FROM Port_cursor INTO @Code
                                        
WHILE @@FETCH_STATUS = 0                  
                                    
BEGIN   

insert into tbl_Hold
exec mimansa.angelcs.dbo.sp_securityholdingcactiontestbbg @Code

insert into tbl_Hold_rpt
select @Code,ScripName,Isin,BseHold,NseHold,BseHold+NseHold as HOlding_Total from tbl_hold

insert into tbl_PortFolio
exec  mimansa.angelcs.dbo.rptclientportfolio @Code,'ALL'

insert into tbl_portfolio_rpt
select party_code,Scrip_cd,ScripName,Isin,QTy from tbl_PortFolio

FETCH NEXT FROM Port_cursor INTO @Code                                    
END                                        
                
CLOSE Port_cursor                                        
DEALLOCATE Port_cursor

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Portfolio
-- --------------------------------------------------
CREATE Proc USP_Portfolio
as

Drop table Bseclientholdtransdate
Drop table SummaryAngelClientPortfolio

select party_code,scripname,isin,scrip_cd,ExchangeSegment,Qty into Bseclientholdtransdate 
from mimansa.angelcs.dbo.Bseclientholdtransdate 

select Party_Code,Scrip_cd,ExchangeSegment,PTradedqty into SummaryAngelClientPortfolio
from mimansa.angelcs.dbo.SummaryAngelClientPortfolio where Status = 'Open' 

truncate table tbl_Hold_rpt

insert into tbl_Hold_rpt
select party_code,scripname,isin,scrip_cd,ExchangeSegment,sum(Qty) as QTY from Bseclientholdtransdate 
group by party_code,scripname,isin,scrip_cd,ExchangeSegment

truncate table tbl_portfolio_rpt

insert into tbl_portfolio_rpt
select Party_Code,Scrip_cd,ExchangeSegment,'',sum(PTradedqty) as Net
from SummaryAngelClientPortfolio group by Party_Code,Scrip_cd,ExchangeSegment

update tbl_portfolio_rpt set ISIN = x.ISIN 
from bsedb.dbo.multiisin x inner join tbl_portfolio_rpt y
on x.scrip_cd = y.scrip_cd and y.segment = 'BSE'

update tbl_portfolio_rpt set ISIN = x.ISIN 
from msajag.dbo.multiisin x inner join tbl_portfolio_rpt y
on x.scrip_cd = y.scrip_cd and y.segment = 'NSE'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Power_Pledge_Shortage
-- --------------------------------------------------
CREATE Proc USP_Power_Pledge_Shortage
(@StatusId Varchar(15),          
 @Statusname Varchar(25),          
 @Sett_No Varchar(7),           
 @Sett_Type Varchar(2),           
 @BranchCd Varchar(10),          
 @Opt int) AS                                      



truncate table delpayinmatch_bse                       
Select @BranchCD = (Case When @StatusId = 'broker' then @BranchCd Else '%' End)                        
                
Select * Into #DeliveryClt From bsedb..DeliveryClt                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And InOut = 'I'                
                
Select * Into #Deltrans From bsedb..Deltrans                
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                
And Party_Code <> 'BROKER' And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction'                
And TrType <> 906                
             
            
SELECT PARTY_CODE, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
INTO #CLIENT FROM bsedb.dbo.CLIENT1 C1, bsedb..CLIENT2 C2              
WHERE C1.CL_CODE = C2.CL_CODE              
And @StatusName =                                   
                  (case                                   
                        when @StatusId = 'BRANCH' then c1.branch_cd                                  
                        when @StatusId = 'SUBBROKER' then c1.sub_broker                                  
                        when @StatusId = 'Trader' then c1.Trader                                  
                        when @StatusId = 'Family' then c1.Family                                  
                        when @StatusId = 'Area' then c1.Area                                  
                        when @StatusId = 'Region' then c1.Region                                  
                        when @StatusId = 'Client' then c2.party_code                                  
                  else                                   
                        'BROKER'                                  
                  End)               
AND PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #DeliveryClt UNION SELECT DISTINCT PARTY_CODE FROM #Deltrans)              
              
set transaction isolation level read uncommitted                            
Select D.Sett_No, D.Sett_Type, D.Party_Code, Certno = Isin, Delqty = D.Qty, Recqty = Sum(Isnull(C.Qty, 0)),           
Isettqty = 0, Ibenqty = 0,Isettqtyprint = 0, Ibenqtyprint = 0, Isettqtymark = 0, Ibenqtymark = 0, Hold = 0, Pledge = 0,           
Nsehold = 0, Nsepledge = 0, Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
Into #delpayinmatch                                        
From #CLIENT C1, bsedb..Multiisin M (nolock) , #Deliveryclt D (nolock) Left Outer Join #Deltrans C (nolock)                                         
On ( D.Sett_No = C.Sett_No And D.Sett_Type = C.Sett_Type                                        
And D.Scrip_Cd = C.Scrip_Cd And D.Series = C.Series                                         
And D.Party_Code = C.Party_Code And Drcr = 'C'                                         
And Filler2 = 1 And Sharetype <> 'Auction')                                        
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1                                        
And D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Qty, Isin, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                       
Having D.Qty > 0                                         
                
If @Opt <> 1                 
Begin                
 Delete From #delpayinmatch Where Delqty <= Recqty                
End                
                
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),               
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From bsedb..Deltrans D (nolock), #Client C1 (nolock)              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                            
set transaction isolation level read uncommitted                            
Insert Into #delpayinmatch                                        
Select Isett_No, Isett_Type, D.Party_Code, Certno, Qty = 0, Recqty = 0, Isettqty = Sum(Case When Trtype <> 1000 Then Qty Else 0 End),                                        
Ibenqty = Sum(Case When Trtype = 1000 Then Qty Else 0 End),                                        
Isettqtyprint = Sum(Case When Delivered = 'G' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtyprint = Sum(Case When Delivered = 'G' And Trtype = 1000 Then Qty Else 0 End),                                         
Isettqtymark = Sum(Case When Delivered = '0' And Trtype <> 1000 Then Qty Else 0 End),                                         
Ibenqtymark = Sum(Case When Delivered = '0' And Trtype = 1000 Then Qty Else 0 End) ,                                        
Hold = 0, Pledge = 0, Nsehold = 0, Nsepledge = 0,                
Scrip_Cd = Convert(Varchar(50), ''), C1.Short_Name, C1.Branch_Cd, c1.sub_broker                                        
From Msajag.Dbo.Deltrans D, #Client C1              
Where Filler2 = 1 And Drcr = 'D' And Delivered <> 'D' And Trtype In (907, 908, 1000)                                        
And Isett_No = @Sett_No And Isett_Type = @Sett_Type                                        
And C1.Party_Code = D.Party_Code                                    
Group By Isett_No, Isett_Type, D.Party_Code, Certno, C1.Short_Name, C1.Branch_Cd, c1.sub_broker                
                
set transaction isolation level read uncommitted                                        
Update #delpayinmatch Set Hold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Pledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),                                        
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From bsedb..Deltrans D (nolock), bsedb..Deliverydp Dp             (nolock)                            
Where Filler2 = 1 And Drcr = 'D'                                         
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                                         
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'            
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code               
And A.Certno = #delpayinmatch.Certno                                        
                  
Update #delpayinmatch Set Nsehold = A.Hold + (Case When @StatusId <> 'broker' then A.Pledge Else 0 End),                           
Nsepledge = (Case When @StatusId = 'broker' then A.Pledge Else 0 End) From (                                        
Select Party_Code, Certno, Hold = Isnull(Sum(Case When TrType = 904 And Description Not Like '%pledge%' Then Qty Else 0 End), 0),             
Pledge = Isnull(Sum(Case When TrType = 909 Or Description Like '%pledge%' Then Qty Else 0 End), 0) From Msajag.Dbo.Deltrans D, Msajag.Dbo.Deliverydp Dp                           
Where Filler2 = 1 And Drcr = 'D'                           
And Delivered = '0' And Trtype In (904, 909, 905) And D.Bdpid = Dp.Dpid                              
And D.Bcltdpid = Dp.Dpcltno And Description Not Like '%pool%'                                         
Group By Party_Code, Certno ) A Where A.Party_Code = #delpayinmatch.Party_Code And A.Certno = #delpayinmatch.Certno                                        
                    
Update #delpayinmatch Set Scrip_Cd = /*S2.Scrip_Cd + ' ( ' +*/ M.Scrip_Cd/* + ' )'      */          
From bsedb..Scrip2 S2, bsedb..MultiIsIn M                
Where S2.BseCode = M.Scrip_Cd                
And M.IsIn = CertNo                
                
If Upper(@Branchcd) = 'All'                                         
begin                            
 Select @Branchcd = '%'                                  
end                            
If @Opt = 1                            
begin                            
 set transaction isolation level read uncommitted                                         
          
INSERT INTO delpayinmatch_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
 From #delpayinmatch R                                   
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                 
 Group By Sett_No, Sett_Type, Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                                         
 Having Sum(Delqty) > 0                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd                                         
end                            
Else                            
begin                                        
INSERT INTO delpayinmatch_bse                                       
 Select Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno,                                        
 Delqty = Sum(Delqty), Recqty = Sum(Recqty), Isettqtyprint = Sum(Isettqtyprint), Isettqtymark = Sum(Isettqtymark),                                        
 Ibenqtyprint = Sum(Ibenqtyprint), Ibenqtymark = Sum(Ibenqtymark),                                        
 Hold = Hold, Pledge = Pledge, Nsehold = Nsehold, Nsepledge = Nsepledge,          
 'poa' AS POA,'cltdpno' AS CLTDPNO,0 AS DPHOLDING          
          
 From #delpayinmatch R (nolock)                
 Where Sett_No = @Sett_No And Sett_Type = @Sett_Type                                         
 And Branch_Cd Like @Branchcd                               
 Group By Sett_No, Sett_Type, R.Party_Code, Short_Name, Branch_Cd, sub_broker, Scrip_Cd, Certno, Hold, Pledge, Nsehold, Nsepledge                      
 Having Sum(Delqty) > (Sum(Recqty) + Sum(Isettqtyprint) + Sum(Ibenqtyprint) )                                         
 Order By Branch_Cd, R.Party_Code, Scrip_Cd             
                      
end                
    
SELECT * FROM delpayinmatch_bse        
-- update delpayinmatch_bse        
-- set delpayinmatch_bse.poa = 'Yes',delpayinmatch_bse.cltdpno = bsedb..multicltid.cltdpno        
-- from delpayinmatch_bse,bsedb..multicltid        
-- where delpayinmatch_bse.party_code = bsedb..multicltid.party_code and bsedb..multicltid.def = 1        
--          
-- select A.poa,A.Sett_No,A.sett_type,A.branch_cd,A.sub_broker,A.delqty-A.recqty as SHORTAGE,A.PARTY_CODE,A.SCRIP_CD,A.CERTNO,CLTDPNO,CONVERT(INT,HLD_AC_POS)  AS HLD_AC_POS     
-- into #bse_poa_shortage        
-- from delpayinmatch_bse A,DPBACKOFFICE.ACERCROSS.DBO.HOLDING B        
-- WHERE HLD_AC_TYPE = 11        
-- AND POA = 'YES' AND CLTDPNO = HLD_AC_CODE AND CERTNO = HLD_ISIN_CODE        
--         
-- select A.SETT_NO,A.SETT_TYPE,A.PARTY_CODE,C.SHORT_NAME,A.BRANCH_CD,A.SUB_BROKER,A.SCRIP_CD,A.CLTDPNO,A.CERTNO,HLD_AC_POS,A.SHORTAGE,A.POA       
-- from  #bse_poa_shortage A,BSEDB..SCRIP2 B,BSEDB..SCRIP1 C  
-- WHERE A.SCRIP_CD=B.BSECODE AND B.CO_CODE=C.CO_CODE

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_ppHolding
-- --------------------------------------------------
CREATE Proc USP_ppHolding                  
(                    
@Segment as varchar(10)          
)                    
as                    
set nocount on                    
/*        
declare @Segment as varchar(10)                    
set @Segment ='NSE'                    
*/ 
     
                   
declare @ACCOUNTID as varchar(15)                    
declare @Qry as varchar(5000)                    
--declare @File as varchar(5000)                    
declare @s as varchar(5000)                    
declare @s1 as varchar(5000)                      
                    
set @ACCOUNTID =                     
case                     
when @Segment = 'BSE' then '14216209'                     
when @Segment = 'NSE' then '13326100'                     
when @Segment = 'NSEFO' then '15464303'            
end                                              
        
--truncate table tlb_pp          
drop table tlb_pp

--insert into tlb_pp        
SELECT rtrim(ltrim(Accountid))+','+rtrim(ltrim(dpref5))+','+rtrim(ltrim(DPSCCODE))+','+rtrim(ltrim(b.scripname))+','+rtrim(ltrim(DPCLCODE))+','+rtrim(ltrim(convert(varchar,SUM(DPQTY)))) as PP          
into tlb_pp
FROM mimansa.bits.dbo.ANGELDPTRAN a,mimansa.angelcs.dbo.angelscrip b   
WHERE ACCOUNTID =@ACCOUNTID and a.dpsccode=b.scrip_cd  
AND (DPTRFTAG = ''  AND DPFLAG = 'G')    
group by Accountid,dpref5,DPSCCODE,b.scripname,DPCLCODE                    
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "select PP from ANGELDEMAT.ANGELINHOUSE.DBO.tlb_pp" queryout D:\upload1\PPHolding\'+@Segment+'.csv -c -Sintranet -Usa -Pnirwan612'                                                
set @s1= @s+''''                                                
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_RptforPledgeData
-- --------------------------------------------------
CREATE proc USP_RptforPledgeData                
(@accno as varchar(20),@type as varchar(2),@condition as varchar(20),@Bank as varchar(20),@val as varchar(5))                
as                
                
Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @Bank  
  
if @type = '' and @condition = 'AC'  
begin  
set @type = '%%'  
end  
                
if @val = '1'              
begin              
      
 select party_code as [PRTY CODE],scrip_cd as [Scrip Code],CertNo as ISIN,Pledge_Qty as [Pledge Qty],convert(dec(15,2),PledgeValue) as [PLEDGE VALUE],       
 Free_Qty as [Free Qty],convert(dec(15,2),FreeValue) as [FREE VALUE],      
 convert(dec(15,2),net_def) as [NET DEBIT VALUE],convert(dec(15,2),New_Pledge) as NEWPLEDGE,      
 branch_cd as [BRANCH CODE],sub_broker as [SB CODE]             
 from                   
 (      
  select party_code,tradername,scrip_cd,Pledge_Qty=sum(Pledge_Qty),New_Pledge=sum(New_Pledge),PledgeValue=Sum(PledgeValue),      
  Free_Qty=sum(Free_Qty),FreeValue=sum(FreeValue),CertNo,net_def      
  from tbl_Pledge_Data (nolock) where BcltDpId =@accno and  
  --P_R like @type and 
  condition = @condition      
  group by party_code,scrip_cd,CertNo,net_def,tradername      
 )x                  
 inner join                  
 (select * from #bank)y on x.CertNo = y.isin        
 left outer join        
 (Select cl_code,branch_cd,sub_broker from intranet.risk.dbo.client_details)z        
 on x.party_code = z.cl_code         
end              
              
if @val= '2'              
begin              
      
 select x.Scrip_cd as [SCRIP CODE],y.sname as [SCRIP NAME],convert(dec(15,2),Sum(Pledgevalue))as [PLEDGE VALUE],              
 convert(dec(15,2),Sum(Freevalue))as [APPROVED VALUE],convert(dec(15,2),Sum(New_Pledge))as NEWPLEDGE,            
 convert(dec(15,2),Sum(Pledge_Qty))as [PLEDGE QUANTITY],convert(dec(15,2),Sum(Free_Qty))as [APPROVED QUANTITY],            
 cls as [CLOSING RATE]            
  from                   
 (select * from tbl_Pledge_Data (nolock) where BcltDpId = @accno --and  P_R like @type 
  and condition=@condition)x                  
 inner join                  
 (select * from #bank)y on x.CertNo = y.isin --and x.Scrip_cd=y.scode              
 group by Scrip_cd,sname,cls              
 order by Scrip_cd              
      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_setnoMatchbse
-- --------------------------------------------------
CREATE proc usp_setnoMatchbse    
(@segment varchar(10))    
as    
if (SELECT CONVERT(VARCHAR(8), GETDATE(), 108)) < '11:00:00'   
select distinct sett_no from bsedb..sett_mst where sec_payin>=(SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS [YYYY-MM-DD]) and sett_type in ('c','d')    
and  exchange=@segment order by sett_no    
  
else if (SELECT CONVERT(VARCHAR(8), GETDATE(), 108)) > '11:00:00'   
select distinct sett_no from bsedb..sett_mst where sec_payin>(SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS [YYYY-MM-DD]) and sett_type in ('c','d')    
and  exchange=@segment order by sett_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_setnoMatchnse
-- --------------------------------------------------
CREATE proc usp_setnoMatchnse        
(@segment varchar(10))        
as        
if (SELECT CONVERT(VARCHAR(8), GETDATE(), 108)) < '11:00:00'       
select distinct sett_no from msajag..sett_mst where sec_payin>=(SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS [YYYY-MM-DD]) and sett_type in ('n','w')        
and  exchange=@segment order by sett_no        
      
else if (SELECT CONVERT(VARCHAR(8), GETDATE(), 108)) > '11:00:00'       
select distinct sett_no from msajag..sett_mst where sec_payin>(SELECT CONVERT(VARCHAR(8), GETDATE(), 112) AS [YYYY-MM-DD]) and sett_type in ('n','w')        
and  exchange=@segment order by sett_no

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Shares_Excess_Log
-- --------------------------------------------------
CREATE Proc USP_Shares_Excess_Log  
as  
  
insert into msajagExcess  
select *,getdate() from msajag.dbo.deltrans (nolock) where party_code in ('SSSS','EEEE') and drcr = 'D' and filler2 = 1 and delivered = '0'  
and certno <> 'auction'
  
insert into bsedbExcess  
select *,getdate() from bsedb.dbo.deltrans (nolock) where party_code in ('SSSS','EEEE') and drcr = 'D' and filler2 = 1 and delivered = '0'  
and certno <> 'auction'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SummPldgeRpt
-- --------------------------------------------------
CREATE Proc USP_SummPldgeRpt(@bank varchar(15),@AccId varchar(16),@Type as char(1),@condition as varchar(10))        
as        
        
--declare @FreeValue as money        
--set @FreeValue = (select FreeValue=sum(FreeValue)/100000 from tbl_Pledge_Data (nolock) where BcltDpId = @AccId)        
--print @FreeValue        
        
Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @bank        
        
create clustered index ix_bank on #bank(bank)        
        
select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'    
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,    
 P_R,Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),    
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,  
convert(dec(20,2),Sum(FreeValue)) as FreeValue,  
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y         
where x.certNo = y.isin and y.Bank = @bank) and P_R = @Type and condition like @condition      
group by condition,BcltDpId,P_R

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SummPldgeRpt_New
-- --------------------------------------------------
CREATE Proc USP_SummPldgeRpt_new(@bank varchar(15),@AccId varchar(16),@Type as char(1),@condition as varchar(10))
as          
          
--declare @FreeValue as money          
--set @FreeValue = (select FreeValue=sum(FreeValue)/100000 from tbl_Pledge_Data (nolock) where BcltDpId = @AccId)          
--print @FreeValue          

Select * into #bank from INTRANET.RISK.DBO.V_AppScripBank_ISIN where Bank like @bank          

create clustered index ix_bank on #bank(bank)          

if @condition = '%%'
begin

select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'      
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,      
 P_R='',Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),      
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,    
convert(dec(20,2),Sum(FreeValue)) as FreeValue,    
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))  
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y           
where x.certNo = y.isin and y.Bank = @bank) and condition like 'AC'        
group by condition,BcltDpId
union
select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'      
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,      
 P_R,Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),      
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,    
convert(dec(20,2),Sum(FreeValue)) as FreeValue,    
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))  
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y           
where x.certNo = y.isin and y.Bank = @bank) and P_R like @Type and condition like 'ADC'        
group by condition,BcltDpId,P_R
union
select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'      
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,      
 P_R,Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),      
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,    
convert(dec(20,2),Sum(FreeValue)) as FreeValue,    
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))  
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y           
where x.certNo = y.isin and y.Bank = @bank) and P_R like @Type and condition like 'PED'        
group by condition,BcltDpId,P_R

end

-------------------------------------------------------------------
-------------------------------------------------------------------

else
begin

if @condition = 'AC'
begin

select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'      
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,      
 P_R='',Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),      
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,    
convert(dec(20,2),Sum(FreeValue)) as FreeValue,    
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))  
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y           
where x.certNo = y.isin and y.Bank = @bank) and condition like @condition        
group by condition,BcltDpId

end
else
begin

select BcltDpId,condition,condition1=case when condition = 'PED' then 'Pledge: Equivalent To Debit'      
when condition = 'ADC' then 'Pledge : All Debit Client'when condition = 'AC' then 'Pledge : All Client' End,      
 P_R,Bank=@bank,condition,Total_Client=count(*),PledgeValue=convert(dec(20,2),sum(PledgeValue)),      
--FreeValue = convert(dec(10,2),@FreeValue),convert(dec(10,2),Sum(FreeValue)/100000) as FreeValue,    
convert(dec(20,2),Sum(FreeValue)) as FreeValue,    
convert(dec(20,2),Sum(New_Pledge)) as NewPledge,net_def=convert(dec(20,2),sum(net_def))  
from tbl_Pledge_Data x (nolock) where BcltDpId = @AccId and exists (select isin from #bank y           
where x.certNo = y.isin and y.Bank = @bank) and P_R like @Type and condition like @condition        
group by condition,BcltDpId,P_R

end

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_viewmodifieddata
-- --------------------------------------------------
CREATE PROC Usp_viewmodifieddata
(
@accountid varchar(10),
@scripcode varchar(10),
@holdingdate varchar(10),
@isinno varchar(15),
@party_code varchar(10),
@existingholding varchar(10),
@modifiedholding varchar(10)
)  
as 

if(select count(*) from modifiedholding_rec where party_code= @party_code and existingholding=@existingholding and holdingdate=@holdingdate) <> 0 
begin
--@party_code,@existingholding,@holdingdate
update modifiedholding_rec  set modifiedholding=@modifiedholding
where   party_code= @party_code and existingholding=@existingholding and holdingdate=@holdingdate
end
else
if(select count(*) from modifiedholding_rec where party_code= @party_code and existingholding=@existingholding and holdingdate=@holdingdate) = 0 
begin
insert into modifiedholding_rec
--(accountid,scripcode,modifieddate,holdingdate,isinno ,party_code,existingHolding,modifiedHolding) 
values 
(@accountid,@scripcode , getdate(),@holdingdate,@isinno,@party_code,@existingholding ,@modifiedholding)
end

GO

-- --------------------------------------------------
-- TABLE dbo.200609abc
-- --------------------------------------------------
CREATE TABLE [dbo].[200609abc]
(
    [Scrip_Cd] NVARCHAR(50) NULL,
    [Series] NVARCHAR(50) NULL,
    [Party_Code] NVARCHAR(50) NULL,
    [Party_Name] NVARCHAR(50) NULL,
    [Isin] NVARCHAR(50) NULL,
    [DPId] NVARCHAR(50) NULL,
    [ClientId] NVARCHAR(50) NULL,
    [Sett_No] NVARCHAR(50) NULL,
    [Sett_Type] NVARCHAR(50) NULL,
    [HoldQty] NVARCHAR(50) NULL,
    [PledgeQty] NVARCHAR(50) NULL,
    [Qty] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.abc
-- --------------------------------------------------
CREATE TABLE [dbo].[abc]
(
    [fname] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Angel_AutoPayoutClientMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[Angel_AutoPayoutClientMaster]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_CltCode] VARCHAR(20) NULL,
    [Fld_CltName] VARCHAR(100) NULL,
    [Fld_BrTag] VARCHAR(15) NULL,
    [Fld_SbTag] VARCHAR(15) NULL,
    [Fld_BseDp] VARCHAR(20) NULL,
    [Fld_Bseid] VARCHAR(20) NULL,
    [Fld_BsePoa] VARCHAR(1) NULL,
    [Fld_NseDp] VARCHAR(20) NULL,
    [Fld_Nseid] VARCHAR(20) NULL,
    [Fld_NsePoa] VARCHAR(1) NULL,
    [Fld_BSEActiveBy] VARCHAR(15) NULL,
    [Fld_BseActiveTime] DATETIME NULL,
    [Fld_BSEActiveIp] VARCHAR(15) NULL,
    [Fld_NSEActiveBy] VARCHAR(15) NULL,
    [Fld_NseActiveTime] DATETIME NULL,
    [Fld_NSEActiveIp] VARCHAR(15) NULL,
    [Fld_BSEDeActiveBy] VARCHAR(15) NULL,
    [Fld_BseDeActiveTime] DATETIME NULL,
    [Fld_BSEDeActiveIp] VARCHAR(15) NULL,
    [Fld_NSEDeActiveBy] VARCHAR(15) NULL,
    [Fld_NseDeActiveTime] DATETIME NULL,
    [Fld_NSEDeActiveIp] VARCHAR(15) NULL,
    [Fld_dummy1] VARCHAR(15) NULL,
    [Fld_dummy2] VARCHAR(15) NULL,
    [Fld_dummy3] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Angel_Holding
-- --------------------------------------------------
CREATE TABLE [dbo].[Angel_Holding]
(
    [Fld_PartyCode] VARCHAR(20) NULL,
    [Fld_HoldingValue] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_PLEDG
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_PLEDG]
(
    [Scrip_Cd] NVARCHAR(50) NULL,
    [Series] NVARCHAR(50) NULL,
    [Party_Code] NVARCHAR(50) NULL,
    [Party_Name] NVARCHAR(50) NULL,
    [Isin] NVARCHAR(50) NULL,
    [DPId] NVARCHAR(50) NULL,
    [ClientId] NVARCHAR(50) NULL,
    [Sett_No] NVARCHAR(50) NULL,
    [Sett_Type] NVARCHAR(50) NULL,
    [HoldQty] NVARCHAR(50) NULL,
    [PledgeQty] NVARCHAR(50) NULL,
    [Qty] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Bseclientholdtransdate
-- --------------------------------------------------
CREATE TABLE [dbo].[Bseclientholdtransdate]
(
    [party_code] CHAR(15) NULL,
    [scripname] VARCHAR(50) NULL,
    [isin] CHAR(25) NULL,
    [scrip_cd] CHAR(15) NULL,
    [ExchangeSegment] CHAR(10) NULL,
    [Qty] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsedbExcess
-- --------------------------------------------------
CREATE TABLE [dbo].[bsedbExcess]
(
    [SNo] NUMERIC(18, 0) NOT NULL,
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
    [Filler5] INT NULL,
    [Log_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSENSEDR
-- --------------------------------------------------
CREATE TABLE [dbo].[BSENSEDR]
(
    [PartyCode] NVARCHAR(50) NULL,
    [Net] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.certificate_clt
-- --------------------------------------------------
CREATE TABLE [dbo].[certificate_clt]
(
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.clsrate190609
-- --------------------------------------------------
CREATE TABLE [dbo].[clsrate190609]
(
    [scrip_cd] VARCHAR(15) NULL,
    [clsrate] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CollateralLog
-- --------------------------------------------------
CREATE TABLE [dbo].[CollateralLog]
(
    [AngelDpTranID] BIGINT NOT NULL,
    [DPRECNO] BIGINT NOT NULL,
    [DPSRNO] BIGINT NOT NULL,
    [DPSETLNO] VARCHAR(10) NULL,
    [DPSTLTP] VARCHAR(3) NULL,
    [DPEXDATE] DATETIME NULL,
    [DPBOOKDT] DATETIME NULL,
    [DPFLAG] VARCHAR(1) NULL,
    [DPSCCODE] VARCHAR(15) NULL,
    [DPQTY] BIGINT NOT NULL,
    [DPACNO] VARCHAR(20) NULL,
    [DPCLCODE] VARCHAR(10) NULL,
    [DPPRCODE] VARCHAR(10) NULL,
    [DPREFNO] VARCHAR(10) NULL,
    [DPTRFTAG] VARCHAR(12) NULL,
    [DPREM] VARCHAR(255) NULL,
    [DPREF1] BIGINT NULL,
    [DPREF2] VARCHAR(6) NULL,
    [DPREF3] VARCHAR(15) NULL,
    [DPREF4] VARCHAR(8) NULL,
    [DPREF5] VARCHAR(12) NULL,
    [DPPRICE] MONEY NULL,
    [DPPRICEDT] DATETIME NULL,
    [DP1] VARCHAR(3) NULL,
    [DP2] VARCHAR(8) NULL,
    [DP3] VARCHAR(10) NULL,
    [DP4] INT NULL,
    [DP5] INT NULL,
    [DP6] VARCHAR(50) NULL,
    [DP7] VARCHAR(50) NULL,
    [DP8] VARCHAR(50) NULL,
    [DP9] VARCHAR(20) NULL,
    [DP10] INT NULL,
    [exchange] VARCHAR(10) NULL,
    [depository] VARCHAR(10) NULL,
    [accounttype] CHAR(1) NULL,
    [accountid] CHAR(16) NULL,
    [StatusId] VARCHAR(10) NOT NULL,
    [StatusName] VARCHAR(10) NOT NULL,
    [Log_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CSO_Collections_22062009
-- --------------------------------------------------
CREATE TABLE [dbo].[CSO_Collections_22062009]
(
    [Date] NVARCHAR(255) NULL,
    [Branch_Tag] NVARCHAR(255) NULL,
    [SB_Tag] NVARCHAR(255) NULL,
    [Client_Code] NVARCHAR(255) NULL,
    [Client_Name] NVARCHAR(255) NULL,
    [ABL_Ledger] FLOAT NULL,
    [ACDL_Ledger] FLOAT NULL,
    [FO_Ledger] FLOAT NULL,
    [MCX_Ledger] FLOAT NULL,
    [NCDX_Ledger] FLOAT NULL,
    [Total_Ledger] FLOAT NULL,
    [FO_Margin] FLOAT NULL,
    [MCX_Margin] FLOAT NULL,
    [NCDEX_Margin] FLOAT NULL,
    [Margin_Total] FLOAT NULL,
    [Pool_APPL_Hold] FLOAT NULL,
    [Pool_non_app_Hold] FLOAT NULL,
    [Total] FLOAT NULL,
    [Deposit] FLOAT NULL,
    [Cash_Colletral] FLOAT NULL,
    [BSE_Colletral] FLOAT NULL,
    [NSE_Colletral] FLOAT NULL,
    [FO_Colleteral] FLOAT NULL,
    [MCX_Colletral] FLOAT NULL,
    [NCDEX_Colletral] FLOAT NULL,
    [Total1] FLOAT NULL,
    [Cash_Ledger] FLOAT NULL,
    [Margin] FLOAT NULL,
    [Colletrals] FLOAT NULL,
    [F30] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delpayinmatch_bse
-- --------------------------------------------------
CREATE TABLE [dbo].[delpayinmatch_bse]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [Nsehold] INT NOT NULL,
    [Nsepledge] INT NOT NULL,
    [POA] VARCHAR(3) NOT NULL,
    [CLTDPNO] VARCHAR(16) NOT NULL,
    [DPHOLDING] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delpayinmatch_bse_scripwise
-- --------------------------------------------------
CREATE TABLE [dbo].[delpayinmatch_bse_scripwise]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [Nsehold] INT NOT NULL,
    [Nsepledge] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.delpayinmatch_nse
-- --------------------------------------------------
CREATE TABLE [dbo].[delpayinmatch_nse]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [Nsehold] INT NOT NULL,
    [Nsepledge] INT NOT NULL,
    [POA] VARCHAR(3) NOT NULL,
    [CLTDPNO] VARCHAR(16) NOT NULL,
    [DPHOLDING] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.director_dp
-- --------------------------------------------------
CREATE TABLE [dbo].[director_dp]
(
    [party_code] VARCHAR(20) NULL,
    [cm_cd] VARCHAR(16) NOT NULL,
    [hld_hold_date] CHAR(8) NOT NULL,
    [hld_ac_code] CHAR(16) NOT NULL,
    [hld_isin_code] CHAR(12) NOT NULL,
    [DPHolding] MONEY NULL,
    [segment] VARCHAR(10) NULL,
    [Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.director_pool
-- --------------------------------------------------
CREATE TABLE [dbo].[director_pool]
(
    [isin] VARCHAR(20) NULL,
    [party_code] VARCHAR(10) NULL,
    [poolhold] FLOAT NULL,
    [Exchange] VARCHAR(3) NULL,
    [Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.directorslist
-- --------------------------------------------------
CREATE TABLE [dbo].[directorslist]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [clientid] VARBINARY(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.drclient12
-- --------------------------------------------------
CREATE TABLE [dbo].[drclient12]
(
    [PartyCode] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.modifiedholding_rec
-- --------------------------------------------------
CREATE TABLE [dbo].[modifiedholding_rec]
(
    [accountid] VARCHAR(16) NULL,
    [scripcode] VARCHAR(20) NULL,
    [modifieddate] DATETIME NULL,
    [holdingdate] DATETIME NULL,
    [isinno] VARCHAR(15) NULL,
    [party_code] VARCHAR(10) NULL,
    [existingHolding] VARCHAR(15) NULL,
    [modifiedHolding] VARCHAR(15) NULL,
    [serialno] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mrg
-- --------------------------------------------------
CREATE TABLE [dbo].[mrg]
(
    [branch_cd] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL,
    [ledger] MONEY NULL,
    [deposit] MONEY NULL,
    [Imargin] MONEY NULL,
    [cash_colleteral] MONEY NULL,
    [Noncash_colleteral] MONEY NULL,
    [NonCashwork] MONEY NULL,
    [MarginReq] MONEY NULL,
    [Net] MONEY NULL,
    [Appr hold] MONEY NULL,
    [Bsemargin] MONEY NULL,
    [Nsemargin] MONEY NULL,
    [BseAppr] MONEY NULL,
    [Nseappr] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.msajagExcess
-- --------------------------------------------------
CREATE TABLE [dbo].[msajagExcess]
(
    [SNo] NUMERIC(18, 0) NOT NULL,
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
    [Filler5] INT NULL,
    [Log_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pldg_hold
-- --------------------------------------------------
CREATE TABLE [dbo].[pldg_hold]
(
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Party_Name] VARCHAR(255) NULL,
    [Isin] VARCHAR(50) NULL,
    [DPId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(50) NULL,
    [Sett_No] VARCHAR(50) NULL,
    [Sett_Type] VARCHAR(50) NULL,
    [HoldQty] FLOAT NULL,
    [PledgeQty] FLOAT NULL,
    [Qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [amount] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pldg_hold_reco
-- --------------------------------------------------
CREATE TABLE [dbo].[pldg_hold_reco]
(
    [Scrip_Cd] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [Isin] VARCHAR(50) NULL,
    [Qty] FLOAT NULL,
    [bankpqty] FLOAT NULL,
    [bankfqty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pldg_new_alloc
-- --------------------------------------------------
CREATE TABLE [dbo].[pldg_new_alloc]
(
    [party code] NVARCHAR(50) NULL,
    [isin] NVARCHAR(50) NULL,
    [scrip name] NVARCHAR(50) NULL,
    [qty] NVARCHAR(50) NULL,
    [clsrate] MONEY NULL,
    [amount] MONEY NULL,
    [bsehld] VARCHAR(50) NULL,
    [nsehld] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Pledge
-- --------------------------------------------------
CREATE TABLE [dbo].[Pledge]
(
    [Sett_No] VARCHAR(255) NULL,
    [Sett] VARCHAR(255) NULL,
    [PartyCode] VARCHAR(255) NULL,
    [Party_Name] VARCHAR(255) NULL,
    [Scrip_Code] VARCHAR(255) NULL,
    [Scrip_Name] VARCHAR(255) NULL,
    [IsIn] VARCHAR(255) NULL,
    [Quantity] VARCHAR(255) NULL,
    [DpId] VARCHAR(255) NULL,
    [ClientId] VARCHAR(255) NULL,
    [ExeDate] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pledge123
-- --------------------------------------------------
CREATE TABLE [dbo].[pledge123]
(
    [scrip_cd] NVARCHAR(50) NULL,
    [isin] NVARCHAR(50) NULL,
    [name] NVARCHAR(50) NULL,
    [qty] NVARCHAR(50) NULL,
    [clsrate] MONEY NULL,
    [amount] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.shortagenholding_bse
-- --------------------------------------------------
CREATE TABLE [dbo].[shortagenholding_bse]
(
    [Sett_No] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(3) NOT NULL,
    [Party_Code] VARCHAR(10) NOT NULL,
    [Short_Name] VARCHAR(21) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [Scrip_Cd] VARCHAR(50) NULL,
    [Certno] VARCHAR(20) NULL,
    [Delqty] INT NULL,
    [Recqty] NUMERIC(38, 0) NULL,
    [Isettqtyprint] INT NULL,
    [Isettqtymark] INT NULL,
    [Ibenqtyprint] INT NULL,
    [Ibenqtymark] INT NULL,
    [Hold] INT NOT NULL,
    [Pledge] INT NOT NULL,
    [Nsehold] INT NOT NULL,
    [Nsepledge] INT NOT NULL,
    [CLTDPNO] VARCHAR(7) NOT NULL,
    [DPHOLDING] INT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SummaryAngelClientPortfolio
-- --------------------------------------------------
CREATE TABLE [dbo].[SummaryAngelClientPortfolio]
(
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [ExchangeSegment] VARCHAR(3) NOT NULL,
    [PTradedqty] INT NULL
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
-- TABLE dbo.tbl_contract_bill
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_contract_bill]
(
    [UPD_Date] VARCHAR(15) NULL,
    [Segment] VARCHAR(15) NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Branch_Cd] VARCHAR(15) NULL,
    [Sub_Broker] VARCHAR(50) NULL,
    [Contract] VARCHAR(50) NULL,
    [ConCumBill] NUMERIC(25, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_date_fetchdata
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_date_fetchdata]
(
    [Fetch_Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Hold
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Hold]
(
    [ScripName] VARCHAR(100) NULL,
    [Isin] VARCHAR(30) NULL,
    [BseHold] BIGINT NULL,
    [NseHold] BIGINT NULL,
    [BSEHOLDPMS] INT NOT NULL,
    [NSEHOLDPMS] INT NOT NULL,
    [FOHold] BIGINT NULL,
    [McxHold] BIGINT NULL,
    [NcdxHold] BIGINT NULL,
    [DpHold] INT NULL,
    [HoldValue] MONEY NULL,
    [DPHoldValue] MONEY NULL,
    [BseCurrent] INT NULL,
    [NseCurrent] INT NULL,
    [CFlag] VARCHAR(20) NOT NULL,
    [ActionDate] VARCHAR(11) NOT NULL,
    [BonusOffer] BIGINT NULL,
    [BonusForShare] BIGINT NULL,
    [RightsOffer] BIGINT NULL,
    [RightsForShare] BIGINT NULL,
    [RightPrice] MONEY NULL,
    [Dividend_RS] MONEY NULL,
    [Dividend_type] VARCHAR(5) NULL,
    [OldPaidup] BIGINT NULL,
    [NewPaidup] BIGINT NULL,
    [CactionDate] VARCHAR(11) NOT NULL,
    [CactionQty] MONEY NOT NULL,
    [Caction] VARCHAR(1) NOT NULL,
    [bse_hold_pp] BIGINT NULL,
    [nse_hold_pp] BIGINT NULL,
    [BseCl_rate] MONEY NULL,
    [NseCl_rate] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Hold_rpt
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Hold_rpt]
(
    [Party_Code] VARCHAR(50) NOT NULL,
    [ScripName] VARCHAR(100) NULL,
    [Isin] VARCHAR(30) NULL,
    [Scrip_cd] VARCHAR(50) NULL,
    [Segment] VARCHAR(50) NULL,
    [HOlding_Total] BIGINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NewPledge_Calc
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NewPledge_Calc]
(
    [Party_Code] VARCHAR(10) NULL,
    [PledgeValue] NUMERIC(38, 4) NULL,
    [FreeValue] NUMERIC(38, 4) NULL,
    [net_def] FLOAT NULL,
    [NewPledge] NUMERIC(38, 4) NULL,
    [Condition] VARCHAR(25) NULL,
    [P_R] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECert_19062009_zero_bal
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECert_19062009_zero_bal]
(
    [CurrDate] VARCHAR(11) NULL,
    [Fld_party_Code] VARCHAR(10) NOT NULL,
    [TotalPledgeValue] INT NOT NULL,
    [ClientPledgeValue] INT NOT NULL,
    [CMLedgerT-2] MONEY NOT NULL,
    [TDay_PaymentRecipt] MONEY NOT NULL,
    [T1Day_PaymentRecipt] MONEY NOT NULL,
    [MG02TDay] DECIMAL(10, 2) NOT NULL,
    [MG02T1Day] DECIMAL(15, 2) NOT NULL,
    [CM_Free_Bal] DECIMAL(21, 4) NULL,
    [FO T-1 Day Bal] MONEY NOT NULL,
    [FOTDay_PaymentRecipt] MONEY NOT NULL,
    [FoMarginLedger] MONEY NOT NULL,
    [initialmargin] MONEY NOT NULL,
    [ExposureMargin] MONEY NOT NULL,
    [FO_Free_Bal] MONEY NULL,
    [NetObligation] DECIMAL(22, 4) NULL,
    [ValueImproperUse] DECIMAL(23, 4) NULL,
    [bse_balance] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECertificate
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECertificate]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_RptDate] DATETIME NULL,
    [Fld_PartyCode] VARCHAR(20) NULL,
    [Fld_TotalPledgeValue] MONEY NULL,
    [Fld_BSEValue] MONEY NULL,
    [Fld_NSEValue] MONEY NULL,
    [Fld_NSETotalPledgeValue] MONEY NULL,
    [Fld_ClientPledgeValue] MONEY NULL,
    [Fld_BseLedgerBal] MONEY NULL,
    [Fld_BseTDay_PR] MONEY NULL,
    [Fld_BseT1Day_PR] MONEY NULL,
    [Fld_BseMg02Tday] MONEY NULL,
    [Fld_BseMg02T1Day] MONEY NULL,
    [Fld_BseFreeBal] MONEY NULL,
    [Fld_CMLedgerT2] MONEY NULL,
    [Fld_TDay_PR] MONEY NULL,
    [Fld_T1Day_PR] MONEY NULL,
    [Fld_MG02TDay] MONEY NULL,
    [Fld_MG02T1Day] MONEY NULL,
    [Fld_CMFreeBal] MONEY NULL,
    [Fld_FOT1Bal] MONEY NULL,
    [Fld_FOTPR] MONEY NULL,
    [Fld_FOML] MONEY NULL,
    [Fld_IM] MONEY NULL,
    [Fld_EM] MONEY NULL,
    [Fld_FreeBal] MONEY NULL,
    [Fld_NseNetObligation] MONEY NULL,
    [Fld_NSEBSENetObligation] MONEY NULL,
    [Fld_NSEValueImproperUse] MONEY NULL,
    [Fld_BSENSEValueImproperUse] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECertificate_09112007
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECertificate_09112007]
(
    [Fld_party_Code] VARCHAR(50) NULL,
    [BSET-2 Day Bal] MONEY NOT NULL,
    [BSETDay_PaymentRecipt] MONEY NOT NULL,
    [BSET1Day_PaymentRecipt] MONEY NOT NULL,
    [BSEMG02TDay] DECIMAL(14, 2) NOT NULL,
    [BSeMG02T1Day] DECIMAL(14, 2) NOT NULL,
    [NSE T-2 Day Bal] MONEY NOT NULL,
    [NTDay_PaymentRecipt] MONEY NOT NULL,
    [NT1Day_PaymentRecipt] MONEY NOT NULL,
    [NMG02TDay] DECIMAL(14, 2) NOT NULL,
    [NMG02T1Day] DECIMAL(14, 2) NOT NULL,
    [FO T-1 Day Bal] MONEY NOT NULL,
    [FOTDay_PaymentRecipt] MONEY NOT NULL,
    [FOAmount] MONEY NOT NULL,
    [FOinitialmargin] MONEY NOT NULL,
    [FOMTMMargin] MONEY NOT NULL,
    [focashcoll] MONEY NOT NULL,
    [fononcashcoll] MONEY NOT NULL,
    [NSX T-1 Day Bal] MONEY NOT NULL,
    [NSXFOTDay_PaymentRecipt] MONEY NOT NULL,
    [NSXAmount] MONEY NOT NULL,
    [NSXinitialmargin] NUMERIC(36, 12) NOT NULL,
    [NSXMTMMargin] NUMERIC(36, 12) NOT NULL,
    [nsxcashcoll] NUMERIC(36, 12) NOT NULL,
    [nsxnoncashcoll] NUMERIC(36, 12) NOT NULL,
    [MCD T-1 Day Bal] MONEY NOT NULL,
    [MCDFOTDay_PaymentRecipt] MONEY NOT NULL,
    [MCDAmount] MONEY NOT NULL,
    [MCDinitialmargin] MONEY NOT NULL,
    [MCDMTMMargin] MONEY NOT NULL,
    [MCdcashcoll] MONEY NOT NULL,
    [MCdnoncashcoll] MONEY NOT NULL,
    [NCDX T-1 Day Bal] MONEY NOT NULL,
    [NCDXFOTDay_PaymentRecipt] MONEY NOT NULL,
    [NCDXAmount] MONEY NOT NULL,
    [NCDXinitialmargin] MONEY NOT NULL,
    [NCDXMTMMargin] MONEY NOT NULL,
    [NCDxcashcoll] MONEY NOT NULL,
    [NCDxnoncashcoll] MONEY NOT NULL,
    [MCDX T-1 Day Bal] MONEY NOT NULL,
    [MCDXFOTDay_PaymentRecipt] MONEY NOT NULL,
    [MCDXfoAmount] MONEY NOT NULL,
    [MCDXfoinitialmargin] MONEY NOT NULL,
    [MCDXfoMTMMargin] MONEY NOT NULL,
    [MCDxcashcoll] MONEY NOT NULL,
    [MCDxnoncashcoll] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECertificate_19062009
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECertificate_19062009]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_RptDate] DATETIME NULL,
    [Fld_PartyCode] VARCHAR(20) NULL,
    [Fld_TotalPledgeValue] MONEY NULL,
    [Fld_BSEValue] MONEY NULL,
    [Fld_NSEValue] MONEY NULL,
    [Fld_NSETotalPledgeValue] MONEY NULL,
    [Fld_ClientPledgeValue] MONEY NULL,
    [Fld_BseLedgerBal] MONEY NULL,
    [Fld_BseTDay_PR] MONEY NULL,
    [Fld_BseT1Day_PR] MONEY NULL,
    [Fld_BseMg02Tday] MONEY NULL,
    [Fld_BseMg02T1Day] MONEY NULL,
    [Fld_BseFreeBal] MONEY NULL,
    [Fld_CMLedgerT2] MONEY NULL,
    [Fld_TDay_PR] MONEY NULL,
    [Fld_T1Day_PR] MONEY NULL,
    [Fld_MG02TDay] MONEY NULL,
    [Fld_MG02T1Day] MONEY NULL,
    [Fld_CMFreeBal] MONEY NULL,
    [Fld_FOT1Bal] MONEY NULL,
    [Fld_FOTPR] MONEY NULL,
    [Fld_FOML] MONEY NULL,
    [Fld_IM] MONEY NULL,
    [Fld_EM] MONEY NULL,
    [Fld_FreeBal] MONEY NULL,
    [Fld_NseNetObligation] MONEY NULL,
    [Fld_NSEBSENetObligation] MONEY NULL,
    [Fld_NSEValueImproperUse] MONEY NULL,
    [Fld_BSENSEValueImproperUse] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Payout_Marking
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Payout_Marking]
(
    [SNo] NUMERIC(18, 0) NOT NULL,
    [Sett_No] VARCHAR(7) NULL,
    [sett_type] VARCHAR(2) NULL,
    [trtype] NUMERIC(18, 0) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [scrip] VARCHAR(50) NULL,
    [Series] VARCHAR(3) NULL,
    [CertNo] VARCHAR(16) NULL,
    [DpType] VARCHAR(10) NULL,
    [DPId] VARCHAR(16) NULL,
    [cltDPId] VARCHAR(16) NULL,
    [Qty] NUMERIC(18, 0) NOT NULL,
    [bdptype] VARCHAR(10) NULL,
    [bdpid] VARCHAR(16) NULL,
    [bcltdpid] VARCHAR(16) NULL,
    [Segment] VARCHAR(3) NOT NULL,
    [Mark_qty] VARCHAR(50) NULL,
    [Ref_No] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Pledge_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Pledge_Data]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [party_code] VARCHAR(20) NULL,
    [BcltDpId] VARCHAR(16) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [Segment] VARCHAR(5) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [Pledge_Qty] INT NULL,
    [PledgeValue] MONEY NULL,
    [Free_Qty] INT NULL,
    [FreeValue] MONEY NULL,
    [CertNo] VARCHAR(20) NULL,
    [net_def] MONEY NULL,
    [New_Pledge] MONEY NULL,
    [Condition] VARCHAR(10) NULL,
    [P_R] VARCHAR(2) NULL,
    [tradername] VARCHAR(100) NULL,
    [cls] MONEY NULL,
    [Sett_No] VARCHAR(25) NULL,
    [Sett_type] VARCHAR(5) NULL,
    [Fld_NewPledgeQty] INT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Pledge_Data_dummy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Pledge_Data_dummy]
(
    [party_code] VARCHAR(10) NULL,
    [BcltDpId] VARCHAR(16) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [Segment] VARCHAR(3) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [Pledge_Qty] NUMERIC(38, 0) NOT NULL,
    [PledgeValue] NUMERIC(38, 4) NOT NULL,
    [Free_Qty] NUMERIC(38, 0) NOT NULL,
    [FreeValue] NUMERIC(38, 4) NOT NULL,
    [CertNo] VARCHAR(16) NULL,
    [cls] MONEY NULL,
    [Sett_No] VARCHAR(7) NULL,
    [Sett_type] VARCHAR(2) NULL,
    [net_def] FLOAT NULL,
    [tradername] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_pledge_data_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_pledge_data_test]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [party_code] VARCHAR(20) NULL,
    [BcltDpId] VARCHAR(16) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [Segment] VARCHAR(5) NULL,
    [scrip_cd] VARCHAR(50) NULL,
    [Pledge_Qty] INT NULL,
    [PledgeValue] MONEY NULL,
    [Free_Qty] INT NULL,
    [FreeValue] MONEY NULL,
    [CertNo] VARCHAR(20) NULL,
    [net_def] MONEY NULL,
    [New_Pledge] MONEY NULL,
    [Condition] VARCHAR(10) NULL,
    [P_R] VARCHAR(2) NULL,
    [tradername] VARCHAR(100) NULL,
    [cls] MONEY NULL,
    [Sett_No] VARCHAR(25) NULL,
    [Sett_type] VARCHAR(5) NULL,
    [Fld_NewPledgeQty] INT NULL,
    [FreeValue_Update] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PledgeHist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PledgeHist]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_Sett_Type] VARCHAR(5) NULL,
    [Fld_Sett_No] INT NULL,
    [Fld_Party_Code] VARCHAR(25) NULL,
    [Fld_Scrip_cd] VARCHAR(50) NULL,
    [Fld_Series] VARCHAR(10) NULL,
    [Fld_Qty] INT NULL,
    [Fld_CertNo] VARCHAR(25) NULL,
    [Fld_BcltDpId] VARCHAR(25) NULL,
    [Fld_Segment] VARCHAR(3) NULL,
    [Fld_DTTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_pledgepref
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_pledgepref]
(
    [srno] INT IDENTITY(1,1) NOT NULL,
    [cmcd] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_PortFolio
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_PortFolio]
(
    [Party_code] VARCHAR(10) NULL,
    [ExchangeSegment] VARCHAR(5) NOT NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [ScripName] VARCHAR(30) NULL,
    [Qty] INT NULL,
    [AvgCostPrice] MONEY NULL,
    [Cmp] MONEY NOT NULL,
    [VAC] MONEY NULL,
    [VAM] MONEY NULL,
    [RealizedPl] MONEY NULL,
    [UnrealizedPl] MONEY NULL,
    [UnrealizedPlP] MONEY NULL,
    [Source] SMALLINT NULL,
    [isin] VARCHAR(20) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_portfolio_rpt
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_portfolio_rpt]
(
    [party_code] VARCHAR(50) NULL,
    [Scrip_cd] VARCHAR(12) NULL,
    [Segment] VARCHAR(30) NULL,
    [Isin] VARCHAR(20) NOT NULL,
    [QTy] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_rms_summ_16032010
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_rms_summ_16032010]
(
    [party_code] VARCHAR(10) NULL,
    [date] VARCHAR(11) NULL,
    [nsecm_ledger] FLOAT NULL,
    [nsefo_ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [nsefo_imargin] MONEY NULL,
    [NSX_imargin] MONEY NULL,
    [NSEFO_Colletral] MONEY NULL,
    [NSX_Colletral] MONEY NULL,
    [Total] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_directorhold
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_directorhold]
(
    [Party_code] VARCHAR(15) NULL,
    [ISIN] VARCHAR(15) NULL,
    [DPHolding] VARCHAR(15) NULL,
    [PoolHold] VARCHAR(15) NULL,
    [Isinname] VARCHAR(55) NULL,
    [Name] VARCHAR(55) NULL,
    [Amount] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempAngelShortage
-- --------------------------------------------------
CREATE TABLE [dbo].[TempAngelShortage]
(
    [ExchangeSegment] VARCHAR(5) NOT NULL,
    [sett_no] VARCHAR(7) NOT NULL,
    [sett_type] VARCHAR(3) NOT NULL,
    [Branch_cd] VARCHAR(1) NOT NULL,
    [Sub_broker] VARCHAR(1) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Scrip_cd] VARCHAR(12) NOT NULL,
    [Series] VARCHAR(3) NOT NULL,
    [inout] VARCHAR(2) NOT NULL,
    [Qty] INT NOT NULL,
    [Scripname] VARCHAR(12) NOT NULL,
    [IsIn] VARCHAR(20) NULL,
    [RecQty] NUMERIC(38, 0) NULL,
    [GivenQty] NUMERIC(38, 0) NULL,
    [Rate] INT NOT NULL,
    [ReportDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TempClientPayinShortage
-- --------------------------------------------------
CREATE TABLE [dbo].[TempClientPayinShortage]
(
    [ExchangeSegment] CHAR(10) NULL,
    [Sett_no] CHAR(10) NULL,
    [Sett_type] CHAR(2) NULL,
    [Branch_Cd] CHAR(10) NULL,
    [Sub_Broker] CHAR(10) NULL,
    [Party_code] CHAR(15) NULL,
    [Scrip_cd] CHAR(10) NULL,
    [Series] CHAR(3) NULL,
    [InOut] CHAR(2) NULL,
    [Qty] INT NULL,
    [ScripName] CHAR(50) NULL,
    [IsIn] CHAR(25) NULL,
    [RecQty] INT NULL,
    [GivenQty] INT NULL,
    [Rate] MONEY NULL,
    [ReportDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tlb_pp
-- --------------------------------------------------
CREATE TABLE [dbo].[tlb_pp]
(
    [PP] VARCHAR(118) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tpr1
-- --------------------------------------------------
CREATE TABLE [dbo].[tpr1]
(
    [pledge_release] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tpr2
-- --------------------------------------------------
CREATE TABLE [dbo].[tpr2]
(
    [pledge] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.Angel_DefPayout
-- --------------------------------------------------
CREATE View Angel_DefPayout  
as  
  
select Fld_Cltcode from Angel_AutoPayoutClientMaster
 where   
(Fld_BseDeactiveTime = 'Dec 31 2049' and Fld_NseDeactiveTime = 'Dec 31 2049')

GO

-- --------------------------------------------------
-- VIEW dbo.V_Check_Pledge_Value
-- --------------------------------------------------
CREATE View V_Check_Pledge_Value                                      
as                                      
                                  
Select x.*,y.Bank    
from                                   
(                                  
select                        
party_code=isnull(x.party_code,y.party_code),                           
BcltDpId=isnull(x.BcltDpId,y.BcltDpId),                        
cltdpid=isnull(x.cltdpid,y.cltdpid),                          
Segment=isnull(x.Segment,y.Segment),                                    
scrip_cd=isnull(x.scrip_cd,y.scrip_cd),                                    
Pledge_Qty=isnull(x.Pledge_Qty,0),                                    
App_Qty=isnull(y.App_Qty,0),    
CertNo=isnull(x.CertNo,y.CertNo),                        
Flag ='',Agreement='',Pledger_Acc_Name='ANGEL CAPITAL & DEBTMARKET LTD',                        
Date_Pledging='',Pledge_Exp_Dt='',Remarks='',SN='',                      
Sr_No='',[L/F]='L',Flag_Lockin_Reason='',Lockin_Release_Dt='',PSN_No=''                
from                                    
(                                      
select party_code,BcltDpId,cltdpid,Segment,scrip_cd,Pledge_Qty=sum(Pledge_Qty),CertNo from        
(        
select party_code,BcltDpId,cltdpid,Segment ='BSE' ,scrip_cd,qty as Pledge_Qty,CertNo from                 
bsedb.dbo.deltrans where trtype = 909  AND DELIVERED = '0' AND DRCR ='D' and BcltDpId in ('1203320000000066','1203320000000028')             
and party_code not in ('BROKER') /*and party_code = 'A10047'*/          
union all                                      
select  party_code,BcltDpId,cltdpid,'NSE',scrip_cd,qty,CertNo from msajag.dbo.deltrans where trtype = 909 AND DELIVERED = '0' AND DRCR ='D' and BcltDpId = '1203320000000051'             
and party_code not in ('BROKER') /*and party_code = 'A10047'*/         
)x group by   party_code,BcltDpId,cltdpid,CertNo,scrip_cd,Segment        
)x                                    
full outer join                                    
(        
select party_code,BcltDpId,cltdpid,Segment,scrip_cd,App_Qty=sum(App_Qty),CertNo from        
(                                
select  party_code,BcltDpId,cltdpid,Segment ='BSE' ,scrip_cd,qty as App_Qty,CertNo from bsedb.dbo.deltrans where trtype = 904  AND DELIVERED = '0' AND DRCR ='D'  and BcltDpId in ('1203320000000066','1203320000000028')            
and party_code not in ('BROKER') /*and party_code = 'A10047'*/        
union all        
select  party_code,BcltDpId,cltdpid,'NSE',scrip_cd,qty,CertNo from msajag.dbo.deltrans where trtype = 904 AND DELIVERED = '0' AND DRCR ='D' and BcltDpId = '1203320000000051'             
and party_code not in ('BROKER') /*and party_code = 'A10047'*/  
)x group by  party_code,BcltDpId,cltdpid,CertNo,scrip_cd,Segment               
)y on x.party_code = y.party_code and x.scrip_cd = y.scrip_cd         
) x                                   
left outer join                                  
(Select * from INTRANET.RISK.DBO.V_AppScripBank_ISIN) y                                  
on                                  
 x.CertNo = y.isin                       
/*inner join                      
(select * from V_Pledge_summary_Rpt)z                      
on x.party_code = z.party_code*/

GO

-- --------------------------------------------------
-- VIEW dbo.V_NSECertificate
-- --------------------------------------------------
CREATE View V_NSECertificate
as

select 
Date=convert(datetime,convert(varchar(11),Fld_RptDate),103),
[Client Code]=Fld_PartyCode,
[Value of Securites Pledged with Bank for all Clients
(T-1 day Rate) as on the date of maximum utilisation overdraft]=Fld_TotalPledgeValue,
[Pledge Value (Proportion as e based on O/D availed]=Fld_ClientPledgeValue,
[CM-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Fld_CMLedgerT2,
[CM Recipts/Payments on T Day]=Fld_TDay_PR,
[Recipts/Payments on T-1 Day]=Fld_T1Day_PR,
[MG 02 Requirement on T Day]=Fld_MG02TDay,
[MG 02 Requirement on T-1 Day]=Fld_MG02T1Day,
[Free Balance in CM Segment]=Fld_CMFreeBal,
[FO-Segment Ledger Balance as on T-2 day(Dr)/(Cr) if trade day billing]=Fld_FOT1Bal,
[FO Recipts/Payments on T Day]=Fld_FOTPR,
[FO Margin Ledger Balance on T Day]=Fld_FOML,
[T Day F&O Initial Margin Requirement]=Fld_IM,
[T Day F&O Exposure Margin Requirement]=Fld_EM,
[Free Balance in FO Segment]=Fld_FreeBal,
[Net Obligation]=Fld_NetOblgation,
[Value of improper use]=Fld_ValueImproperUse from tbl_NSECertificate

GO

-- --------------------------------------------------
-- VIEW dbo.V_Pledge_summary_Rpt
-- --------------------------------------------------
CREATE view V_Pledge_summary_Rpt          
as          
select *,          
case           
when Newpledge < 0 then 'R'          
when Newpledge > 0 then 'P' end P_R from          
(          
select *,case           
when net_def = PledgeValue then 0           
when net_def < PledgeValue then net_def-PledgeValue          
when net_def > PledgeValue then           
case when net_def- AppValue >= AppValue then AppValue else net_def- AppValue end           
end NewPledge,'PED' Condition from V_Pledge_Value (nolock)-----------1          
union all          
select *,case when net_def <> 0 then AppValue end NewPledge, 'ADC'  Condition from V_Pledge_Value (nolock)-----------2          
union all          
select *,AppValue,'AC'Condition from V_Pledge_Value (nolock)-----------3          
)x

GO

-- --------------------------------------------------
-- VIEW dbo.V_Pledge_Value
-- --------------------------------------------------
CREATE View V_Pledge_Value              
as              
              
select Bank,x.BcltDpId,x.party_code,PledgeValue=sum(Pledge_qty*cls),AppValue=sum(App_qty*cls),
net_def,z.Tradername  from              
(select * from V_Check_Pledge_Value (nolock))x              
left outer join              
(select * from intranet.risk.dbo.V_Closing_Rate )y              
on x.segment = y.segment and x.scrip_cd = y.scrip              
left outer join              
(select party_code,net_def=net_def,Tradername from intranet.risk.dbo.collection_client_details)z              
on x.party_code = z.party_code              
group by x.party_code,net_def,Bank,BcltDpId,Tradername

GO

-- --------------------------------------------------
-- VIEW dbo.V_POA_Clients
-- --------------------------------------------------
CREATE View V_POA_Clients        
as        
        
select x.cl_code,long_name,sub_broker,branch_cd,        
BSEDPID=isnull(BSEDPId,'No Records'),        
BSECltId=isnull(BSECltId,'No Records'),        
NSEDPId=isnull(NSEDPId,'No Records'),        
NSECltid=isnull(NSECltId,'No Records'),      
BSEPOA=case when BSEPOA = '1' then 'Y' else 'N' end,      
NSEPOA=case when NSEPOA = '1' then 'Y' else 'N' end      
 from        
(        
select cl_code,long_name,sub_broker,branch_cd from intranet.risk.dbo.client_details   
where Last_inactive_date > getdate()  
/*  
where        
(bsecm = 'Y' or nsecm = 'Y' or nsefo = 'Y')  and cl_code = 'A17106'  
(mcdx is null and ncdx is null and bsefo is null and mcd is null and nsx is null)   
and Last_inactive_date > getdate()  and  branch_cd <> 'PMOS'  and cl_type <> 'NBF'      
*/  
)x        
left outer join        
(        
select         
case when x.party_code is null then y.party_code else x.party_code end party_code,        
isnull(x.cltDpNo,'No Records') as BSECltId,        
isnull(y.cltDpNo,'No Records') as NSECltId,      
isnull(convert(varchar,x.def),'No Records') as BSEPOA,      
isnull(x.DPId,'No Records') as BSEDPId,        
isnull(y.DPId,'No Records') as NSEDPId,        
isnull(convert(varchar,y.def),'No Records')as NSEPOA      
from        
(select * from BSEDB.DBO.V_BSEPOA)x        
full outer join        
(select  * from msajag.dbo.V_NSEPOA)y        
on x.party_code = y.party_code        
)y on x.cl_code = y.party_code

GO

