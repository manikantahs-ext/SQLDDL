-- DDL Export
-- Server: 10.253.50.28
-- Database: Inhouse_BSX
-- Exported: 2026-02-04T11:48:00.081523

USE Inhouse_BSX;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco
-- --------------------------------------------------
      
CREATE Procedure Fetch_CliUnreco(@pcode as varchar(10) = null)        
as        
        
set nocount on        
        
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/        
declare @fromdt as datetime,@todate as datetime          
select @fromdt=sdtcur from accountcurfo.dbo.parameter where sdtnxt = (select sdtcur  from accountcurfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())          
select @todate=ldtcur from accountcurfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()          
-----------END----------------------        
  
IF @pcode is null  
BEGIN  
         
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet        
 from accountcurfo.dbo.ledger b with (nolock)         
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1        
         
 select         
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo        
 into #led1        
 from accountcurfo.dbo.ledger1 with (nolock)        
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )         
         
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype         
         
         
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,         
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),         
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),         
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()         
 into #recodet         
 From accountcurfo.dbo.LEDGER l with (nolock)        
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and vdt <= getdate()         
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')      
       
           
 /*                                    
 select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno         
 create clustered index co_pcode on BO_client_deposit_recno(cltcode)         
 */        
         
         
 delete #recodet from #recodet a inner join NSECURFO.DBO.CLient1 b WITH (NOLOCK) on         
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')         
         
 truncate table BO_client_deposit_recno         
 insert into BO_client_deposit_recno select co_code='BSX',getdate(),* from #recodet (nolock)         
END  
ELSE  
BEGIN  
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet          
 from accountcurfo.dbo.ledger b with (nolock)           
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode    
  
 select           
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,    
 accno=space(10)          
 into #ledger1c          
 from accountcurfo.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype         
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )           
  
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc          
 from accountcurfo.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp    
 where  a.lno=1     
  
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype    
  
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,           
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),           
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),           
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()           
 into #recodetc           
 From accountcurfo.dbo.LEDGER l with (nolock)          
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno          
 and vdt <= getdate()           
 and         
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')        
      
 delete #recodetc from #recodetc a inner join NSECURFO.DBO.CLient1 b WITH (NOLOCK) on           
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')           
        
 delete from BO_client_deposit_recno where cltcode=@pcode          
 insert into BO_client_deposit_recno select co_code='BSX',getdate(),* from #recodetc (nolock)        
  
END  
  
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet
-- --------------------------------------------------
 
  
CREATE Proc NCMS_POdet(@pcode as varchar(10) = null)          
as          
          
set nocount on          
        
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50          
SELECT @MARGINDATE=MAX(MARGINDATE) FROM NSECURFO.dbo.tbl_clientmargin           
select @sdtcur=sdtcur from ACCOUNTcurfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()          
          
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2          
          
IF @pcode is null          
BEGIN          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select            
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
 clcode=b.party_code,           
 imargin=-b.initialmargin,           
 span=0,           
 total=-b.initialmargin,            
 mtm=0,           
 received=0,          
 shortage=0,           
 net=0,           
 ledgeramount=0,            
 cash_coll=isnull(b.cash_coll,0),           
 non_cash=isnull(b.noncash_coll,0),            
 0,0,0,0,0,0          
 from  (            
 select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from           
 NSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE           
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb            
 from          
 (          
 Select cltcode,vamt,drcr from ACCOUNTcurfo.dbo.ledger a (nolock)           
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59') a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb a join (Select party_code from NSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null           
        
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
        
 /*       
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0            
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0           
 then 0  else total-received  end           
 */    
     
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)       
           
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco          
           
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
 update #NCMS_marh set c=          
 (case           
 when (imargin*(NonCashConsideration/100))+non_cash > 0           
 then 0           
 else (imargin*(NonCashConsideration/100))+non_cash           
 end)           
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                  
                                                                
 update #NCMS_marh set PayoutValue =          
 case                                              
 when c >= ledgeramount  then ledgeramount      
 when c < ledgeramount then c                                              
 else 0 end        
        
 update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr         
  
 update #NCMS_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTcurfo.dbo.ledger a (nolock)   
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
        
 truncate table NCMS_marh          
        
 insert into NCMS_marh          
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)          
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh          
        
END          
ELSE          
BEGIN          
         
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select            
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
 clcode=b.party_code,           
 imargin=-b.initialmargin,           
 span=0,           
 total=-b.initialmargin,            
 mtm=0,           
 received=0,          
 shortage=0,           
 net=0,           
 ledgeramount=0,            
 cash_coll=isnull(b.cash_coll,0),           
 non_cash=isnull(b.noncash_coll,0),            
 0,0,0,0,0,0          
 from  (            
 select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), namount=ledgeramount+(cash_coll+noncash_coll),            
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from           
 NSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
 where margindate = @MARGINDATE and party_Code=@pcode          
 ) b            
        
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)           
 into #bb1            
 from          
 (          
  Select cltcode,vamt,drcr from ACCOUNTcurfo.dbo.ledger a (nolock)           
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'        
 ) a          
 group by cltcode          
        
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0            
 from           
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from NSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a            
 left outer join #NCMS_marh b           
 on a.cltcode = b.clcode             
 where b.clcode is null            
        
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0            
 from NCMS_Colleteral a left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode          
        
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode            
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #NCMS_marh.clcode=b.party_Code            
     
 /*       
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0            
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0           
 then 0  else total-received  end           
 */    
     
 update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)       
        
 update #NCMS_marh set OTherDr=b.Vbal from            
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b            
 where #NCMS_marh.clcode=b.cltcode          
        
 exec Fetch_CliUnreco @pcode         
        
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from             
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno where cltcode=@pcode group by cltcode) b            
 where #NCMS_marh.clcode=b.cltcode           
        
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration           
        
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent          
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #NCMS_marh.clcode=b.party_code          
        
 update #NCMS_marh set c=          
 (case           
 when (imargin*(NonCashConsideration/100))+non_cash > 0           
 then 0           
 else (imargin*(NonCashConsideration/100))+non_cash           
 end)           
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                  
                                                                
 update #NCMS_marh set PayoutValue =          
 case                                              
 when c >= ledgeramount  then ledgeramount      
 when c < ledgeramount then c                                              
 else 0 end        
        
 update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr         
  
 update #NCMS_marh set received=b.vamt from  
 (   
  Select cltcode,vamt from ACCOUNTcurfo.dbo.ledger a (nolock)   
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'  
 ) b   
 where #NCMS_marh.clcode=b.cltcode   
  
  
        
 delete from NCMS_marh where clcode=@pcode         
        
 insert into NCMS_marh          
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)          
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh          
         
END          
Set nocount off

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
-- TABLE dbo.NCMS_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[NCMS_marh]
(
    [Sauda_Date] DATETIME NULL,
    [Clcode] VARCHAR(10) NULL,
    [imargin] MONEY NULL,
    [span] MONEY NULL,
    [total] MONEY NULL,
    [mtm] MONEY NULL,
    [received] MONEY NULL,
    [shortage] MONEY NULL,
    [net] MONEY NULL,
    [ledgeramount] MONEY NULL,
    [cash_coll] MONEY NULL,
    [non_cash] MONEY NULL,
    [exposure] MONEY NULL,
    [mtm_loss] MONEY NULL,
    [deposit] MONEY NULL,
    [net_exposure] MONEY NULL,
    [UnrecoCr] MONEY NULL,
    [OtherDr] MONEY NULL,
    [NonCashConsideration] MONEY NULL,
    [PayoutValue] MONEY NULL,
    [UpdDatetime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.NCMS_Colleteral
-- --------------------------------------------------
CREATE View NCMS_Colleteral  
as  
 select party_Code,        
 CashColl=sum(Case when Cash_NCash='C' then FinalAmount else 0 end),        
 NonCashColl=sum(Case when Cash_NCash='N' then FinalAmount else 0 end)        
 from   
 (   
   select Party_Code,FinalAmount,Cash_Ncash=(Case when scrip_cd='' and cash_ncash='' then 'C' else Cash_Ncash end)  
   from msajag.dbo.CollateralDetails WITH (NOLOCK)   
   where exchange='BSX' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)   
   where effDate <= getdate() and exchange='BSX' and segment='FUTURES')    
 ) x group by party_code

GO

