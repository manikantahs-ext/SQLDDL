-- DDL Export
-- Server: 10.253.33.233
-- Database: INHOUSE_BSX
-- Exported: 2026-02-05T02:37:51.816029

USE INHOUSE_BSX;
GO

-- --------------------------------------------------
-- INDEX dbo.SEBI_marh
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [NonClusteredIndex_clcode] ON [dbo].[SEBI_marh] ([Clcode])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_POdet
-- --------------------------------------------------
  
CREATE Proc [dbo].[Bond_POdet](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin               
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
              
select *,convert(money,0) as c into #Bond_marh from Bond_marh where 1=2              
              
IF @pcode is null              
BEGIN              
              
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')) a              
 group by cltcode              
            
            
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #Bond_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
 
 /*           
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null               
   */         
 update #Bond_marh set ledgeramount=balance from #bb b  where #Bond_marh.clcode=b.cltcode                
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */
            
 /*           
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
               
 update #Bond_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                
 where #Bond_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco_bond              
               
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where #Bond_marh.clcode=b.cltcode               
            
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration               
   /*         
 update #Bond_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code              
     */       
 update #Bond_marh set c=              
 (case               
 when (imargin*(NonCashConsideration/100))+non_cash > 0               
 then 0               
 else (imargin*(NonCashConsideration/100))+non_cash               
 end)               
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
                                                                    
 update #Bond_marh set PayoutValue =              
 case                                                  
 when c >= ledgeramount  then ledgeramount          
 when c < ledgeramount then c                                                  
 else 0 end            
            
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #Bond_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #Bond_marh.clcode=b.cltcode       
            
 truncate table Bond_marh              
            
 insert into Bond_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh              
            
END              
ELSE              
BEGIN              
             
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             
 ) a              
 group by cltcode              
            
            
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #Bond_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
    /*        
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
      */      
 update #Bond_marh set ledgeramount=balance from #bb1 b  where #Bond_marh.clcode=b.cltcode                
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */
         
 /*           
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
            
 update #Bond_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b                
 where #Bond_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco_bond @pcode             
            
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno where cltcode=@pcode group by cltcode) b                
 where #Bond_marh.clcode=b.cltcode               
            
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration               
  /*          
 update #Bond_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code              
    */        
 update #Bond_marh set c=              
 (case               
 when (imargin*(NonCashConsideration/100))+non_cash > 0               
 then 0               
 else (imargin*(NonCashConsideration/100))+non_cash               
 end)               
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
                                                                    
 update #Bond_marh set PayoutValue =              
 case                                                  
 when c >= ledgeramount  then ledgeramount          
 when c < ledgeramount then c                                                  
 else 0 end            
            
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #Bond_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
) b       
 where #Bond_marh.clcode=b.cltcode       
      
      
            
 delete from Bond_marh where clcode=@pcode             
            
 insert into Bond_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh              
             
END              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Bond_POdet_02082017
-- --------------------------------------------------
    
CREATE Proc Bond_POdet_02082017(@pcode as varchar(10) = null)                
as                
                
set nocount on                
              
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50                
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin                 
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()                
                
select *,convert(money,0) as c into #Bond_marh from Bond_marh where 1=2                
                
IF @pcode is null                
BEGIN                
                
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                  
 where margindate = @MARGINDATE                 
 ) b                  
              
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)                 
 into #bb                  
 from                
 (                
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)                 
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59') a                
 group by cltcode                
              
              
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                  
 from                 
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                  
 left outer join #Bond_marh b                 
 on a.cltcode = b.clcode                   
 where b.clcode is null                  
   
 /*             
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                  
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null                 
   */           
 update #Bond_marh set ledgeramount=balance from #bb b  where #Bond_marh.clcode=b.cltcode                  
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */  
              
 /*             
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                  
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0       
 then 0  else total-received  end                 
 */          
           
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)             
                 
 update #Bond_marh set OTherDr=b.Vbal from                  
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                  
 where #Bond_marh.clcode=b.cltcode                
              
 exec Fetch_CliUnreco_bond                
                 
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                   
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                  
 where #Bond_marh.clcode=b.cltcode                 
              
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration                 
   /*           
 update #Bond_marh set NonCashConsideration=b.CollateralPercent                
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code                
     */         
 update #Bond_marh set c=                
 (case                 
 when (imargin*(NonCashConsideration/100))+non_cash > 0                 
 then 0                 
 else (imargin*(NonCashConsideration/100))+non_cash                 
 end)                 
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                        
                                                                      
 update #Bond_marh set PayoutValue =                
 case                                                    
 when c >= ledgeramount  then ledgeramount            
 when c < ledgeramount then c                                                    
 else 0 end              
              
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr               
        
 update #Bond_marh set received=b.vamt from        
 (         
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)         
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'        
 ) b         
 where #Bond_marh.clcode=b.cltcode         
              
 truncate table Bond_marh                
              
 insert into Bond_marh                
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh                
              
END                
ELSE                
BEGIN                
               
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                  
 where margindate = @MARGINDATE and party_Code=@pcode                
 ) b                  
              
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)                 
 into #bb1                  
 from                
 (                
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)                 
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'              
 ) a                
 group by cltcode                
              
              
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                  
 from                 
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                  
 left outer join #Bond_marh b                 
 on a.cltcode = b.clcode                   
 where b.clcode is null                  
    /*          
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                    
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                  
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode                
      */        
 update #Bond_marh set ledgeramount=balance from #bb1 b  where #Bond_marh.clcode=b.cltcode                  
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */  
           
 /*             
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                  
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0                 
 then 0  else total-received  end                 
 */          
           
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)             
              
 update #Bond_marh set OTherDr=b.Vbal from                  
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b                  
 where #Bond_marh.clcode=b.cltcode                
              
 exec Fetch_CliUnreco_bond @pcode               
              
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                   
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno where cltcode=@pcode group by cltcode) b                  
 where #Bond_marh.clcode=b.cltcode                 
              
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration                 
  /*            
 update #Bond_marh set NonCashConsideration=b.CollateralPercent                
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code                
    */          
 update #Bond_marh set c=                
 (case                 
 when (imargin*(NonCashConsideration/100))+non_cash > 0                 
 then 0                 
 else (imargin*(NonCashConsideration/100))+non_cash                 
 end)                 
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                        
                                                                      
 update #Bond_marh set PayoutValue =                
 case                                                    
 when c >= ledgeramount  then ledgeramount            
 when c < ledgeramount then c                                                    
 else 0 end              
              
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr               
        
 update #Bond_marh set received=b.vamt from        
 (         
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)         
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'        
) b         
 where #Bond_marh.clcode=b.cltcode         
        
        
              
 delete from Bond_marh where clcode=@pcode               
              
 insert into Bond_marh                
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)                
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh                
               
END                
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco
-- --------------------------------------------------
  
CREATE Procedure [dbo].[Fetch_CliUnreco](@pcode as varchar(10) = null)          
as          
          
set nocount on          
          
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/          
declare @fromdt as datetime,@todate as datetime            
select @fromdt=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())            
select @todate=ldtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()            
-----------END----------------------          
    
IF @pcode is null    
BEGIN    
           
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet          
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)           
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1          
           
 select           
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo          
 into #led1          
 from ACCOUNTcurbfo.dbo.ledger1 with (nolock)          
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )           
           
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype           
           
           
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,           
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),           
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),           
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()           
 into #recodet           
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)          
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno          
 and vdt <= getdate()           
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%') 
 /*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')           */
         
             
 /*                                      
 select top 0 * into BO_client_deposit_recno from [196.1.115.182].general.dbo.BO_client_deposit_recno           
 create clustered index co_pcode on BO_client_deposit_recno(cltcode)           
 */          
           
           
 delete #recodet from #recodet a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on           
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')           
           
 truncate table BO_client_deposit_recno           
 insert into BO_client_deposit_recno select co_code='BSX',getdate(),* from #recodet (nolock)           
END    
ELSE    
BEGIN    
    
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet            
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)             
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode      
    
 select             
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,      
 accno=space(10)            
 into #ledger1c            
 from ACCOUNTcurbfo.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype           
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )             
    
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc            
 from ACCOUNTcurbfo.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp      
 where  a.lno=1  /*and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process')   */
    
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype      
    
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,             
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),             
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),             
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()             
 into #recodetc             
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)            
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno            
 and vdt <= getdate()             
 and           
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%'  AND l.narration not like 'AMOUNT RECEIVED%') 
 /*and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process')        */
        
 delete #recodetc from #recodetc a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on             
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')             
          
 delete from BO_client_deposit_recno where cltcode=@pcode            
 insert into BO_client_deposit_recno select co_code='BSX',getdate(),* from #recodetc (nolock)          
    
END    
    
          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_bond
-- --------------------------------------------------
    
CREATE Procedure [dbo].[Fetch_CliUnreco_bond](@pcode as varchar(10) = null)            
as            
            
set nocount on            
            
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/            
declare @fromdt as datetime,@todate as datetime              
select @fromdt=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())              
select @todate=ldtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()              
-----------END----------------------            
      
IF @pcode is null      
BEGIN      
             
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet            
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)             
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1            
             
 select             
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo            
 into #led1            
 from ACCOUNTcurbfo.dbo.ledger1 with (nolock)            
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )             
             
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype             
             
             
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,             
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),             
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),             
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()             
 into #recodet             
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)            
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno            
 and vdt <= getdate()             
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')  
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
        
           
               
 /*                                        
 select top 0 * into BO_client_deposit_recno_Bond from [196.1.115.182].general.dbo.BO_client_deposit_recno_Bond             
 create clustered index co_pcode on BO_client_deposit_recno_Bond(cltcode)             
 */            
             
             
 delete #recodet from #recodet a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on             
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')             
             
 truncate table BO_client_deposit_recno_Bond             
 insert into BO_client_deposit_recno_Bond select co_code='BSX',getdate(),* from #recodet (nolock)             
END      
ELSE      
BEGIN      
      
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet              
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)               
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode        
      
 select               
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,        
 accno=space(10)              
 into #ledger1c              
 from ACCOUNTcurbfo.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype             
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )               
      
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc              
 from ACCOUNTcurbfo.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp        
 where  a.lno=1 and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') 
        
      
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype        
      
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,               
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),               
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),               
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()               
 into #recodetc               
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)              
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno              
 and vdt <= getdate()               
 and             
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
            
          
 delete #recodetc from #recodetc a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on               
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')               
            
 delete from BO_client_deposit_recno_Bond where cltcode=@pcode              
 insert into BO_client_deposit_recno_Bond select co_code='BSX',getdate(),* from #recodetc (nolock)            
      
END      
      
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_bond_02082017
-- --------------------------------------------------


      
CREATE Procedure Fetch_CliUnreco_bond_02082017(@pcode as varchar(10) = null)              
as              
              
set nocount on              
              
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/              
declare @fromdt as datetime,@todate as datetime                
select @fromdt=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())                
select @todate=ldtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()                
-----------END----------------------              
        
IF @pcode is null        
BEGIN        
               
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet              
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)               
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1              
               
 select               
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo              
 into #led1              
 from ACCOUNTcurbfo.dbo.ledger1 with (nolock)              
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )               
               
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype               
               
               
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,               
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),               
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),               
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()               
 into #recodet               
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)              
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno              
 and vdt <= getdate()               
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')            
             
                 
 /*                                          
 select top 0 * into BO_client_deposit_recno_Bond from [196.1.115.182].general.dbo.BO_client_deposit_recno_Bond               
 create clustered index co_pcode on BO_client_deposit_recno_Bond(cltcode)               
 */              
               
               
 delete #recodet from #recodet a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on               
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')               
               
 truncate table BO_client_deposit_recno_Bond               
 insert into BO_client_deposit_recno_Bond select co_code='BSX',getdate(),* from #recodet (nolock)               
END        
ELSE        
BEGIN        
        
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet                
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)                 
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode          
        
 select                 
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,          
 accno=space(10)                
 into #ledger1c                
 from ACCOUNTcurbfo.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype               
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )                 
        
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc                
 from ACCOUNTcurbfo.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp          
 where  a.lno=1           
        
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype          
        
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                 
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),                 
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),                 
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()                 
 into #recodetc                 
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)                
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno                
 and vdt <= getdate()                 
 and               
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')              
            
 delete #recodetc from #recodetc a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on                 
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')                 
              
 delete from BO_client_deposit_recno_Bond where cltcode=@pcode                
 insert into BO_client_deposit_recno_Bond select co_code='BSX',getdate(),* from #recodetc (nolock)              
        
END        
        
              
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Fetch_CliUnreco_GSec
-- --------------------------------------------------
    
CREATE Procedure [dbo].[Fetch_CliUnreco_GSec](@pcode as varchar(10) = null)            
as            
            
set nocount on            
            
/*------NEW LINE ADD FOR FINANCIAL YEAR CALENDER-----*/            
declare @fromdt as datetime,@todate as datetime              
select @fromdt=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtnxt = (select sdtcur  from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate())              
select @todate=ldtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= getdate() and ldtcur >=getdate()              
-----------END----------------------            
      
IF @pcode is null      
BEGIN      
             
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #vdet            
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)             
 where vdt >=@fromdt and vdt <=@todate and (vtyp=2 or vtyp=3) and lno=1            
             
 select             
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo            
 into #led1            
 from ACCOUNTcurbfo.dbo.ledger1 with (nolock)            
 where drcr='C' and clear_mode not in ( 'R', 'C') and vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )             
             
 select t.*,l.accno into #ledger1 from #vdet l join #led1 t on l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype             
             
             
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,             
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),             
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),             
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()             
 into #recodet             
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)            
 join #ledger1 L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno            
 and vdt <= getdate()             
 and (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')  
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
        
           
               
 /*                                        
 select top 0 * into BO_client_deposit_recno_Bond from [196.1.115.182].general.dbo.BO_client_deposit_recno_Bond             
 create clustered index co_pcode on BO_client_deposit_recno_Bond(cltcode)             
 */            
 delete #recodet from #recodet a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on             
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')             
             
 truncate table BO_client_deposit_recno_GSec             
 insert into BO_client_deposit_recno_GSec select co_code='BSX',getdate(),* from #recodet (nolock)             
END      
ELSE      
BEGIN      
      
 select b.vtyp, b.booktype, b.vno, b.lno,accno=b.cltcode into #cdet              
 from ACCOUNTcurbfo.dbo.ledger b with (nolock)               
 where  vdt >=GETDATE()-31 and vdt <=@todate and (vtyp=2 or vtyp=3) and CLTCODE=@pcode        
      
 select               
 bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,a.vtyp,a.vno,a.lno,drcr,a.BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode,L1_SNo,        
 accno=space(10)              
 into #ledger1c              
 from ACCOUNTcurbfo.dbo.ledger1 a with (nolock) join #cdet b on a.vno=b.vno and a.vtyp=b.vtyp and a.booktype=b.booktype             
 where drcr='C' and clear_mode not in ( 'R', 'C') and a.vtyp in (2, 3) and (reldt ='1900-01-01 00:00:00.000' or reldt > getdate()+1 )               
      
 select b.vtyp, b.booktype, b.vno, b.lno,accno=a.cltcode into #vdetc              
 from ACCOUNTcurbfo.dbo.LEDGER a with (nolock) join #cdet b on a.VNO=b.vno and a.booktype=b.booktype and a.vtyp=b.vtyp        
 where  a.lno=1 and (a.VTYP<>35 and isnull(a.enteredby,'')<>'mtf process') 
        
      
 update #ledger1c set accno=b.accno from #vdetc b where #ledger1c.vno=b.vno and #ledger1c.vtyp=b.vtyp and #ledger1c.booktype=b.booktype        
      
 select l1.accno,l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,               
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then vamt  else 0 end ),               
 Cramt= (case when upper(l.drcr) = 'C' then vamt else 0 end ),               
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno,last_Date=getdate()               
 into #recodetc               
 From ACCOUNTcurbfo.dbo.LEDGER l with (nolock)              
 join #ledger1c L1 on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno              
 and vdt <= getdate()               
 and             
 (l.narration not like 'BEING AMT RECD TECH PROCESS%'  AND l.narration not like 'BEING AMT RECEIVED BY ONLINE TRF%')
 and (l.VTYP<>35 and isnull(l.enteredby,'')<>'mtf process') 
            
          
 delete #recodetc from #recodetc a inner join BSECURFO.DBO.CLient1 b WITH (NOLOCK) on               
 a.cltcode=b.CL_cODE where a.ddno='0' and (B.cl_type = 'NBF' OR B.cl_type = 'TMF')               
            
 delete from BO_client_deposit_recno_GSec where cltcode=@pcode              
 insert into BO_client_deposit_recno_GSec select co_code='BSX',getdate(),* from #recodetc (nolock)            
      
END      
      
            
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GSec_POdet
-- --------------------------------------------------
  
CREATE Proc [dbo].[GSec_POdet](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin               
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
              
select *,convert(money,0) as c into #Bond_marh from Bond_marh where 1=2              
              
IF @pcode is null              
BEGIN              
              
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')) a              
 group by cltcode              
            
            
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #Bond_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
 
 /*           
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null               
   */         
 update #Bond_marh set ledgeramount=balance from #bb b  where #Bond_marh.clcode=b.cltcode                
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */
            
 /*           
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
               
 update #Bond_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                
 where #Bond_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco_GSec              
               
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where #Bond_marh.clcode=b.cltcode               
            
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration               
   /*         
 update #Bond_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code              
     */       
 update #Bond_marh set c=              
 (case               
 when (imargin*(NonCashConsideration/100))+non_cash > 0               
 then 0               
 else (imargin*(NonCashConsideration/100))+non_cash               
 end)               
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
                                                                    
 update #Bond_marh set PayoutValue =              
 case                                                  
 when c >= ledgeramount  then ledgeramount          
 when c < ledgeramount then c                                                  
 else 0 end            
            
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #Bond_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #Bond_marh.clcode=b.cltcode       
            
 truncate table GSEc_marh              

 insert into GSEc_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh              
            
END              
ELSE              
BEGIN              
             
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             
 ) a              
 group by cltcode              
            
            
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #Bond_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
    /*        
 insert into #Bond_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a left outer join #Bond_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
      */      
 update #Bond_marh set ledgeramount=balance from #bb1 b  where #Bond_marh.clcode=b.cltcode                
 /*update #Bond_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b where #Bond_marh.clcode=b.party_Code                */
         
 /*           
 update #Bond_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 update #Bond_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
            
 update #Bond_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b                
 where #Bond_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco_GSec @pcode             
            
 update #Bond_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno where cltcode=@pcode group by cltcode) b                
 where #Bond_marh.clcode=b.cltcode               
            
 update #Bond_marh set NonCashConsideration=@NONCASHconsideration               
  /*          
 update #Bond_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b where #Bond_marh.clcode=b.party_code              
    */        
 update #Bond_marh set c=              
 (case               
 when (imargin*(NonCashConsideration/100))+non_cash > 0               
 then 0               
 else (imargin*(NonCashConsideration/100))+non_cash               
 end)               
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
                                                                    
 update #Bond_marh set PayoutValue =              
 case                                                  
 when c >= ledgeramount  then ledgeramount          
 when c < ledgeramount then c                                                  
 else 0 end            
            
 update #Bond_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #Bond_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
) b       
 where #Bond_marh.clcode=b.cltcode       
      
      
            
 delete from GSEc_marh where clcode=@pcode             
            
 insert into GSEc_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #Bond_marh              
             
END              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet
-- --------------------------------------------------

  
CREATE Proc [dbo].[NCMS_POdet](@pcode as varchar(10) = null)              
as              
              
set nocount on              
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:45') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [INTRANET].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=8  
End  
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
              
IF @pcode is null              
BEGIN              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [INTRANET].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money=1  
       
--  --   select @month=convert(char(3), GETDATE(), 0)  
--  --select @month  
--  --if(@month='Dec' or @month='Jan' or @month='Feb')  
--  --begin  
--  -- set @peakVar=0.25   
--  -- print @peakVar  
--  --end   
--  --if(@month='Mar' or @month='Apr' or @month='May')  
--  --begin  
--  -- set @peakVar=0.5   
--  -- print @peakVar  
--  --end  
--  --if(@month='Jun' or @month='Jul' or @month='Aug')  
--  --begin  
--  -- set @peakVar=0.75   
--  -- print @peakVar  
--  --end  
--  --if(@month='Sep' or @month='Oct' or @month='Nov')  
--  --begin  
--  -- set @peakVar=1   
--  -- print @peakVar  
--  --end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
 
if((CONVERT(VARCHAR(5),GETDATE(),108)>='01:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='15:59'))      
Begin
	 
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b   
end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b       
 
 end           

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from NCMS_marh where clcode=@pcode             
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:45') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [INTRANET].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=8              
end  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_03Apr2018
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_03Apr2018](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin             
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
            
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/    ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_03Mar2017
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_03Mar2017](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin             
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
            
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59') a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'          
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_05Apr2017
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_05Apr2017](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin             
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >= GETDATE()            


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/


            
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'
    /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18        )
 /********************************************************************************/
 ) a            

 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'       
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18        )
 /********************************************************************************/   
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_15Dec2020
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_15Dec2020](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)            
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/ ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
  
  
   /******************Unpleadge Po Adjust**********************************/
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'

update #dd1 set remaning=noncash where noncash>0 and flag='P'

insert into #dd1
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0

 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0

update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning
									 when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning 
									 when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end
									 	 
									 from #dd1 b  WITH (NOLOCK) 
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0

update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash
									  when #UnpleadgePO.non_cash>b.remaning then  0 
									  when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end  
from #dd1 b  WITH (NOLOCK) 
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and 
#UnpleadgePO.imargin<0  and b.noncash>0  


update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash
from #UnpleadgePO b  WITH (NOLOCK) 
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode 
 /*************************************************************/    
   /***********************Share PO *adjust****************************/
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'

update #dd set remaning=noncash where noncash>0 and flag='P'

insert into #dd
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0

 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0

update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning
									 when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning 
									 when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end
									 	 
									 from #dd b  WITH (NOLOCK) 
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0

update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash
									  when #SharePO.non_cash>b.remaning then  0 
									  when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end  
from #dd b  WITH (NOLOCK) 
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and 
#SharePO.imargin<0  and b.noncash>0  


update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash
from #SharePO b  WITH (NOLOCK) 
where  NCMS_Share_Adjust.party_Code=b.clcode 
 /*************************************************************/         
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
  namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/   
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
       
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_17Feb2023
-- --------------------------------------------------


  
CREATE Proc [dbo].[NCMS_POdet_17Feb2023](@pcode as varchar(10) = null)              
as              
              
set nocount on              
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=8  
End  
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
              
IF @pcode is null              
BEGIN              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money=1  
       
--  --   select @month=convert(char(3), GETDATE(), 0)  
--  --select @month  
--  --if(@month='Dec' or @month='Jan' or @month='Feb')  
--  --begin  
--  -- set @peakVar=0.25   
--  -- print @peakVar  
--  --end   
--  --if(@month='Mar' or @month='Apr' or @month='May')  
--  --begin  
--  -- set @peakVar=0.5   
--  -- print @peakVar  
--  --end  
--  --if(@month='Jun' or @month='Jul' or @month='Aug')  
--  --begin  
--  -- set @peakVar=0.75   
--  -- print @peakVar  
--  --end  
--  --if(@month='Sep' or @month='Oct' or @month='Nov')  
--  --begin  
--  -- set @peakVar=1   
--  -- print @peakVar  
--  --end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
 
--if((CONVERT(VARCHAR(5),GETDATE(),108)>='01:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='09:59'))      
--Begin
	 
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b   
/*end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b       
 
 end   */        

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from NCMS_marh where clcode=@pcode             
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=8              
end  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_22Nov2022
-- --------------------------------------------------

  
create Proc [dbo].[NCMS_POdet_22Nov2022](@pcode as varchar(10) = null)              
as              
              
set nocount on              
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=8  
End  
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
              
IF @pcode is null              
BEGIN              
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
   order by party_code      
     
     
     declare @month varchar(10),@peakVar money=1  
       
  --   select @month=convert(char(3), GETDATE(), 0)  
  --select @month  
  --if(@month='Dec' or @month='Jan' or @month='Feb')  
  --begin  
  -- set @peakVar=0.25   
  -- print @peakVar  
  --end   
  --if(@month='Mar' or @month='Apr' or @month='May')  
  --begin  
  -- set @peakVar=0.5   
  -- print @peakVar  
  --end  
  --if(@month='Jun' or @month='Jul' or @month='Aug')  
  --begin  
  -- set @peakVar=0.75   
  -- print @peakVar  
  --end  
  --if(@month='Sep' or @month='Oct' or @month='Nov')  
  --begin  
  -- set @peakVar=1   
  -- print @peakVar  
  --end  
  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
   select party_code,  
   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   into #data from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE  
     
     select * into #margin from #data where initialmargin>0  
     
     
   SELECT party_code, MAX(peakMargin) as peakMargin    
  into #PeckMargin FROM    
  (    
   SELECT party_code, MAX(peakMargin) as peakMargin    
   FROM #peak     
   GROUP BY party_code    
   UNION ALL    
   SELECT party_code, MAX(initialmargin) as initialmargin    
   FROM #margin     
   GROUP BY party_code    
  ) as subQuery    
  GROUP BY party_code       
  
    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   into #main from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE     
      
                 
   update #main set initialmargin=b.peakMargin                 
   from(                      
   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
   ) b                       
   where #main.Party_code=b.party_code                        
  
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
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   from           
  #main         
   ) b       
 end   
/*********************************************/          
 else        
  begin  
  
              
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
 end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from NCMS_marh where clcode=@pcode             
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=8              
end  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_25Nov2020
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_25Nov2020](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)            
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/ ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
          
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
  namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/   
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
       
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_30Jan2023
-- --------------------------------------------------

  
create Proc [dbo].[NCMS_POdet_30Jan2023](@pcode as varchar(10) = null)              
as              
              
set nocount on              
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=8  
End  
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
              
IF @pcode is null              
BEGIN              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money=1  
       
--  --   select @month=convert(char(3), GETDATE(), 0)  
--  --select @month  
--  --if(@month='Dec' or @month='Jan' or @month='Feb')  
--  --begin  
--  -- set @peakVar=0.25   
--  -- print @peakVar  
--  --end   
--  --if(@month='Mar' or @month='Apr' or @month='May')  
--  --begin  
--  -- set @peakVar=0.5   
--  -- print @peakVar  
--  --end  
--  --if(@month='Jun' or @month='Jul' or @month='Aug')  
--  --begin  
--  -- set @peakVar=0.75   
--  -- print @peakVar  
--  --end  
--  --if(@month='Sep' or @month='Oct' or @month='Nov')  
--  --begin  
--  -- set @peakVar=1   
--  -- print @peakVar  
--  --end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
 
if((CONVERT(VARCHAR(5),GETDATE(),108)>='01:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='09:59'))      
Begin
	 
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b   
end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b       
 
 end           

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from NCMS_marh where clcode=@pcode             
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=8              
end  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_30Mar2019
-- --------------------------------------------------

create Proc [dbo].[NCMS_POdet_30Mar2019](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)            
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
            
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/ ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
          
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
       
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_31Jan2023
-- --------------------------------------------------

  
create Proc [dbo].[NCMS_POdet_31Jan2023](@pcode as varchar(10) = null)              
as              
              
set nocount on              
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set StartDate=GETDATE() where srno=8  
End  
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
              
IF @pcode is null              
BEGIN              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money=1  
       
--  --   select @month=convert(char(3), GETDATE(), 0)  
--  --select @month  
--  --if(@month='Dec' or @month='Jan' or @month='Feb')  
--  --begin  
--  -- set @peakVar=0.25   
--  -- print @peakVar  
--  --end   
--  --if(@month='Mar' or @month='Apr' or @month='May')  
--  --begin  
--  -- set @peakVar=0.5   
--  -- print @peakVar  
--  --end  
--  --if(@month='Jun' or @month='Jul' or @month='Aug')  
--  --begin  
--  -- set @peakVar=0.75   
--  -- print @peakVar  
--  --end  
--  --if(@month='Sep' or @month='Oct' or @month='Nov')  
--  --begin  
--  -- set @peakVar=1   
--  -- print @peakVar  
--  --end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
 
--if((CONVERT(VARCHAR(5),GETDATE(),108)>='01:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='09:59'))      
--Begin
	 
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b   
/*end
else
begin
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b       
 
 end   */        

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from NCMS_marh where clcode=@pcode             
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END  
  
if((CONVERT(VARCHAR(5),GETDATE(),108)>='06:59') and (CONVERT(VARCHAR(5),GETDATE(),108)<='23:59'))      
Begin  
update [196.1.115.132].CMS.dbo.ncms_batch_process set EndDate=GETDATE(),Flag=1 where srno=8              
end  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_commodity
-- --------------------------------------------------

  
CREATE Proc [dbo].[NCMS_POdet_commodity](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b   
     

 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT    when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
            
 --update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
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
-- PROCEDURE dbo.NCMS_POdet_ForRealTime_PO
-- --------------------------------------------------
  
  
CREATE  Proc [dbo].[NCMS_POdet_ForRealTime_PO](@pcode as varchar(10) = null)              
as              
              
set nocount on              
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
      select distinct party_code into #PO_client from  [INTRANET].cms.dbo.NCMS_RealPO_ForProcess  with(nolock)  where  validationtxt='OK'  
  
  create index #PO_cli on #PO_client(Party_code)  
   

              
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
 select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),               
 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),                
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin a WITH (NOLOCK)   ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code                
 ) b                
 
 
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)  ,#PO_client p            
   where  a.cltcode=p.party_code                
 and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'   
 /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   
  where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)      
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table NCMS_marh              
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_ForRealTime_PO_22Nov2022
-- --------------------------------------------------
  
  
create  Proc [dbo].[NCMS_POdet_ForRealTime_PO_22Nov2022](@pcode as varchar(10) = null)              
as              
              
set nocount on              
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from NCMS_marh where 1=2              
      select distinct party_code into #PO_client from  [196.1.115.132].cms.dbo.NCMS_RealPO_ForProcess  with(nolock)  where  validationtxt='OK'  
  
  create index #PO_cli on #PO_client(Party_code)  
   
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
   order by party_code      
     
     
     declare @month varchar(10),@peakVar money=1  
       
  --   select @month=convert(char(3), GETDATE(), 0)  
  --select @month  
  --if(@month='Dec' or @month='Jan' or @month='Feb')  
  --begin  
  -- set @peakVar=0.25   
  -- print @peakVar  
  --end   
  --if(@month='Mar' or @month='Apr' or @month='May')  
  --begin  
  -- set @peakVar=0.5   
  -- print @peakVar  
  --end  
  --if(@month='Jun' or @month='Jul' or @month='Aug')  
  --begin  
  -- set @peakVar=0.75   
  -- print @peakVar  
  --end  
  --if(@month='Sep' or @month='Oct' or @month='Nov')  
  --begin  
  -- set @peakVar=1   
  -- print @peakVar  
  --end  
  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
   select party_code,  
   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   into #data from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE  
     
     select * into #margin from #data where initialmargin>0  
     
     
   SELECT party_code, MAX(peakMargin) as peakMargin    
  into #PeckMargin FROM    
  (    
   SELECT party_code, MAX(peakMargin) as peakMargin    
   FROM #peak     
   GROUP BY party_code    
   UNION ALL    
   SELECT party_code, MAX(initialmargin) as initialmargin    
   FROM #margin     
   GROUP BY party_code    
  ) as subQuery    
  GROUP BY party_code       
  
    select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),           
   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   into #main from           
   BSECURFO.dbo.tbl_clientmargin a WITH (NOLOCK)   ,#PO_client p            
   where margindate =@MARGINDATE and a.party_code=p.party_code   
      
                 
   update #main set initialmargin=b.peakMargin                 
   from(                      
   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
   ) b                       
   where #main.Party_code=b.party_code                        
  
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
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   from           
  #main         
   ) b       
 end   
/*********************************************/          
 else        
  begin  
  
              
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select                
 sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
 clcode=b.party_code,               
 imargin=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/           
 span=0,               
 total=0,/*-b.initialmargin,*/    /*commented on 07 july 2021 as suggested by raahul sir*/            
 mtm=0,               
 received=0,              
 shortage=0,               
 net=0,               
 ledgeramount=0,                
 cash_coll=isnull(b.cash_coll,0),               
 non_cash=isnull(b.noncash_coll,0),                
 0,0,0,0,0,0              
 from  (                
 select margindate = left(convert(varchar,margindate,109),11),a.party_code, billamount = isnull(billamount,0),               
 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),                
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin a WITH (NOLOCK)   ,#PO_client p            
where margindate =@MARGINDATE and a.party_code=p.party_code                
 ) b                
 end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)  ,#PO_client p            
   where  a.cltcode=p.party_code                
 and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'   
 /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   
  where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)      
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table NCMS_marh              
            
 insert into NCMS_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_Morning
-- --------------------------------------------------



CREATE Proc [dbo].[NCMS_POdet_Morning](@pcode as varchar(10) = null)            
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 100            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)            
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
 
          
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/
 balance=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)            
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/ ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
  
  
   /******************Unpleadge Po Adjust**********************************/
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'

update #dd1 set remaning=noncash where noncash>0 and flag='P'

insert into #dd1
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0

 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0

update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning
									 when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning 
									 when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end
									 	 
									 from #dd1 b  WITH (NOLOCK) 
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0

update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash
									  when #UnpleadgePO.non_cash>b.remaning then  0 
									  when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end  
from #dd1 b  WITH (NOLOCK) 
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and 
#UnpleadgePO.imargin<0  and b.noncash>0  


update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash
from #UnpleadgePO b  WITH (NOLOCK) 
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode 
 /*************************************************************/    
   /***********************Share PO *adjust****************************/
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'

update #dd set remaning=noncash where noncash>0 and flag='P'

insert into #dd
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0

 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0

update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning
									 when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning 
									 when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end
									 	 
									 from #dd b  WITH (NOLOCK) 
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0

update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash
									  when #SharePO.non_cash>b.remaning then  0 
									  when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end  
from #dd b  WITH (NOLOCK) 
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and 
#SharePO.imargin<0  and b.noncash>0  


update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash
from #SharePO b  WITH (NOLOCK) 
where  NCMS_Share_Adjust.party_Code=b.clcode 
 /*************************************************************/         
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
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
  namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE and party_Code=@pcode            
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb1              
 from            
 (            
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */
       /*Added to exclude opening balance of current year*/
  /********************************************************************************/
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/   
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 --from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode            
          
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode              
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
       
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b              
 where #NCMS_marh.clcode=b.cltcode             
          
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration             
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
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
-- PROCEDURE dbo.NCMS_POdet_Unpledge
-- --------------------------------------------------
  
  
CREATE Proc [dbo].[NCMS_POdet_Unpledge](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from Unpleadge_marh where 1=2              
              
IF @pcode is null              
BEGIN              
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
 
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
             
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null    
 
  --exec SP_Unpleadge_Colleteral
  
 --select * into #NCMS_Colleteralq from Unpleadge_Colleteral with(nolock) 
 --create index #t on #NCMS_Colleteralq (party_code)  
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from #NCMS_Colleteralq a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table Unpleadge_marh              
            
 insert into Unpleadge_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
            
END              
--ELSE              
--BEGIN              
             
-- insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
-- select                
-- sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',               
-- clcode=b.party_code,               
-- imargin=-b.initialmargin,               
-- span=0,               
-- total=-b.initialmargin,                
-- mtm=0,               
-- received=0,              
-- shortage=0,               
-- net=0,               
-- ledgeramount=0,                
-- cash_coll=isnull(b.cash_coll,0),               
-- non_cash=isnull(b.noncash_coll,0),                
-- 0,0,0,0,0,0              
-- from  (                
-- select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),               
-- ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),                
-- /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
--  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--  namount=ledgeramount+(cash_coll+noncash_coll),                
-- FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
-- BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
-- where margindate = @MARGINDATE and party_Code=@pcode              
-- ) b                
            
-- select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
-- into #bb1                
-- from              
-- (              
--  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
--  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
--       /*Added to exclude opening balance of current year*/  
--  /********************************************************************************/  
--  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
-- and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
-- /********************************************************************************/     
--   /********Added on 03 Apr 2018*************/  
-- -- and    
-- --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
-- /********************************************/  
-- ) a              
-- group by cltcode              
            
            
-- insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
-- select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
-- from               
-- (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
-- left outer join #NCMS_marh b               
-- on a.cltcode = b.clcode                 
-- where b.clcode is null                
            
-- insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
-- select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
-- from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
-- update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
-- update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
-- /*           
-- update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
-- then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
-- then 0  else total-received  end               
-- */        
         
-- update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
            
-- update #NCMS_marh set OTherDr=b.Vbal from                
-- (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb1 where cltcode like '98%' and Balance < 0) b                
-- where #NCMS_marh.clcode=b.cltcode              
            
-- exec Fetch_CliUnreco @pcode             
            
-- update #NCMS_marh set UNRecoCr=-b.UnRecoCr from                 
-- (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
-- where #NCMS_marh.clcode=b.cltcode               
            
-- update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
-- update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
-- from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
-- update #NCMS_marh set c=              
-- (case               
-- when (imargin*(NonCashConsideration/100))+non_cash > 0               
-- then 0               
-- else (imargin*(NonCashConsideration/100))+non_cash               
-- end)               
-- + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
                                                                    
-- update #NCMS_marh set PayoutValue =              
-- case                                                  
-- when c >= ledgeramount  then ledgeramount          
-- when c < ledgeramount then c                                                  
-- else 0 end            
            
-- update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
-- update #NCMS_marh set received=b.vamt from      
-- (       
--  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
--  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
-- ) b       
-- where #NCMS_marh.clcode=b.cltcode       
      
      
            
-- delete from Unpleadge_marh where clcode=@pcode             
            
-- insert into Unpleadge_marh              
-- (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
-- select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
--END              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NCMS_POdet_Unpledge_14Sep2023
-- --------------------------------------------------
  
  
create Proc [dbo].[NCMS_POdet_Unpledge_14Sep2023](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from Unpleadge_marh where 1=2              
              
IF @pcode is null              
BEGIN              
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
   order by party_code      
     
     
     declare @month varchar(10),@peakVar money  
       
     select @month=convert(char(3), GETDATE(), 0)  
  select @month  
  if(@month='Dec' or @month='Jan' or @month='Feb')  
  begin  
   set @peakVar=0.25   
   print @peakVar  
  end   
  if(@month='Mar' or @month='Apr' or @month='May')  
  begin  
   set @peakVar=0.5   
   print @peakVar  
  end  
  if(@month='Jun' or @month='Jul' or @month='Aug')  
  begin  
   set @peakVar=0.75   
   print @peakVar  
  end  
  if(@month='Sep' or @month='Oct' or @month='Nov')  
  begin  
   set @peakVar=1   
   print @peakVar  
  end  
  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
   select party_code,  
   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   into #data from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE  
     
     select * into #margin from #data where initialmargin>0  
     
     
   SELECT party_code, MAX(peakMargin) as peakMargin    
  into #PeckMargin FROM    
  (    
   SELECT party_code, MAX(peakMargin) as peakMargin    
   FROM #peak     
   GROUP BY party_code    
   UNION ALL    
   SELECT party_code, MAX(initialmargin) as initialmargin    
   FROM #margin     
   GROUP BY party_code    
  ) as subQuery    
  GROUP BY party_code       
  
    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   into #main from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE     
      
                 
   update #main set initialmargin=b.peakMargin                 
   from(                      
   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
   ) b                       
   where #main.Party_code=b.party_code                        
  
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
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   from           
  #main         
   ) b       
 end   
/*********************************************/          
 else        
  begin  
  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
 end           
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
   /******************Unpleadge Po Adjust**********************************/  
 select * into #dd1 from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd1 set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd1  
select * from ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #UnpleadgePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd1 b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #UnpleadgePO set remaningNonCash =case when #UnpleadgePO.non_cash<b.remaning then b.remaning-#UnpleadgePO.non_cash  
           when #UnpleadgePO.non_cash>b.remaning then  0   
           when #UnpleadgePO.non_cash=b.remaning then  #UnpleadgePO.non_cash-b.remaning else non_Cash end    
from #dd1 b  WITH (NOLOCK)   
where #UnpleadgePO.clcode=b.party_Code and #UnpleadgePO.non_cash>0 and   
#UnpleadgePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Unpleadge_Adjust set flag='U',remaning=b.remaningNonCash  
from #UnpleadgePO b  WITH (NOLOCK)   
where  NCMS_Unpleadge_Adjust.party_Code=b.clcode   
 /*************************************************************/      
   /***********************Share PO *adjust****************************/  
 select * into #dd from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0   and flag='P'  
  
update #dd set remaning=noncash where noncash>0 and flag='P'  
  
insert into #dd  
select * from ANGELFO.inhouse.dbo.NCMS_Share_Adjust with(nolock) where noncash>0 and flag='U' and remaning>0  
  
 select *,CONVERT(money,0) as remaningNonCash into #SharePO from #NCMS_marh  where non_cash>0 and imargin<0  
  
update #NCMS_marh set non_Cash=case when #NCMS_marh.non_cash=b.remaning then #NCMS_marh.non_cash-b.remaning  
          when #NCMS_marh.non_cash>b.remaning then #NCMS_marh.non_cash-b.remaning   
          when #NCMS_marh.non_cash<b.remaning then 0/*b.noncash-#NCMS_marh.non_cash*/ else non_Cash end  
              
          from #dd b  WITH (NOLOCK)   
where #NCMS_marh.clcode=b.party_Code and #NCMS_marh.non_cash>0 and imargin<0  
  
update #SharePO set remaningNonCash =case when #SharePO.non_cash<b.remaning then b.remaning-#SharePO.non_cash  
           when #SharePO.non_cash>b.remaning then  0   
           when #SharePO.non_cash=b.remaning then  #SharePO.non_cash-b.remaning else non_Cash end    
from #dd b  WITH (NOLOCK)   
where #SharePO.clcode=b.party_Code and #SharePO.non_cash>0 and   
#SharePO.imargin<0  and b.noncash>0    
  
  
update ANGELFO.inhouse.dbo.NCMS_Share_Adjust set flag='U',remaning=b.remaningNonCash  
from #SharePO b  WITH (NOLOCK)   
where  NCMS_Share_Adjust.party_Code=b.clcode   
 /*************************************************************/           
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
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table Unpleadge_marh              
            
 insert into Unpleadge_marh              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
  initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
  namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE and party_Code=@pcode              
 ) b                
            
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)               
 into #bb1                
 from              
 (              
  Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)               
  where cltcode=@pcode and VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59'  /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')             */  
       /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/     
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/  
 ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb1 a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null  and a.party_Code=@pcode              
            
 update #NCMS_marh set ledgeramount=balance from #bb1 b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
         
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
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno WITH (NOLOCK) where cltcode=@pcode group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where cltcode=@pcode and eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
      
      
            
 delete from Unpleadge_marh where clcode=@pcode             
            
 insert into Unpleadge_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
             
END              
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_PO_Coll
-- --------------------------------------------------
    
CREATE proc SEBI_PO_Coll  
as   
begin  
truncate table SEBI_colletral_data   

insert into SEBI_colletral_data                 
 select *               
   from msajag.dbo.CollateralDetails WITH (NOLOCK)         
   where exchange='BSX' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)         
   where effDate <= getdate() and exchange='BSX' and segment='FUTURES')          
     and Party_Code in (select Party_Code from SEBI_Client with(nolock)) 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet
-- --------------------------------------------------

CREATE Proc [dbo].[SEBI_POdet](@flag as varchar(10) = null)              
as              
              
set nocount on     
  
truncate table SEBI_Client        
insert into SEBI_Client  
select distinct party_code  from MIS.sccs.dbo.sccs_clientmaster with(nolock)  
          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                                
          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                                
          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                                
          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'              
          and exclude='N'   
            
         
if @Flag='Daily'  
Begin  
 insert into SEBI_Client  
 select  distinct party_code from [INTRANET].cms.dbo.sccs_clientmaster_provisional with(nolock) where  
 SCCS_SettDate_Last =  DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) and exclude='N'  
end            
  
select * into #aaa from SEBI_Client  
  
DECLARE @Days VARCHAR(20)                            
                            
 SET @Days = (                            
   SELECT DATENAME(dw, GETDATE())                            
   )                 
if (@Flag='Daily' and @Days = 'Tuesday')    
Begin   
insert into SEBI_colletral_data_hist  
select * from SEBI_colletral_data  
end  
          
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
select @sdtcur=sdtcur/*Sdtnxt*/ from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2              
              
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [INTRANET].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0   
--     and party_code in (select party_code from #aaa)  
--   group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money  
       
--     select @month=convert(char(3), GETDATE(), 0)  
--  select @month  
--  if(@month='Dec' or @month='Jan' or @month='Feb')  
--  begin  
--   set @peakVar=0.25   
--   print @peakVar  
--  end   
--  if(@month='Mar' or @month='Apr' or @month='May')  
--  begin  
--   set @peakVar=0.5   
--   print @peakVar  
--  end  
--  if(@month='Jun' or @month='Jul' or @month='Aug')  
--  begin  
--   set @peakVar=0.75   
--   print @peakVar  
--  end  
--  if(@month='Sep' or @month='Oct' or @month='Nov')  
--  begin  
--   set @peakVar=1   
--   print @peakVar  
--  end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE   and party_code in (select party_code from #aaa)  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     and party_code in (select party_code from #aaa)  
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE     and party_code in (select party_code from #aaa)            
 ) b                
 --end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
   and CLTCODE in (select party_code from #aaa)    
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)  where party_code in (select party_code from #aaa)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null      
   
 select * into #NCMS_Colleteralq from NCMS_Colleteral where  party_Code in (select party_code from #aaa)  
 create index #t on #NCMS_Colleteralq (party_code)       
   
 exec SEBI_PO_Coll       
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from #NCMS_Colleteralq a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
 /*           
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
               
 update #NCMS_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                
 where #NCMS_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco              
               
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
 --update #NCMS_marh set c=              
 --(case               
 --when (imargin*(NonCashConsideration/100))+non_cash > 0               
 --then 0               
 --else (imargin*(NonCashConsideration/100))+non_cash               
 --end)               
 --+ ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
     
  update #NCMS_marh set imargin=imargin*2.25           
                                                                    
 --update #NCMS_marh set PayoutValue =              
 --case                                                  
 --when c >= ledgeramount  then ledgeramount          
 --when c < ledgeramount then c                                                  
 --else 0 end            
            
 --update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #NCMS_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'    and CLTCODE in (select party_code from #aaa)    
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table SEBI_marh              
            
 insert into SEBI_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
            
              
            
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet_24Jun2021
-- --------------------------------------------------



create Proc [dbo].[SEBI_POdet_24Jun2021](@pcode as varchar(10) = null)            
as            
            
set nocount on   


select distinct party_code into #aaa from MIS.sccs.dbo.sccs_clientmaster with(nolock)
          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                              
          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                              
          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                              
          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'            
          and exclude='N'         
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)            
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse

select @sdtcur=Sdtnxt from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
            
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2            
            
IF @pcode is null            
BEGIN            
 DECLARE @MARGINDATE1 AS DATETIME          
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'

 
if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0
begin
		select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [196.1.115.196].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)
		 where margindate =@MARGINDATE1
		 and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 
		   and party_code in (select party_code from #aaa)
		 group by party_code
		 order by party_code    
		 
		 
		   declare @month varchar(10),@peakVar money
		   
		   select @month=convert(char(3), GETDATE(), 0)
		select @month
		if(@month='Dec' or @month='Jan' or @month='Feb')
		begin
		 set @peakVar=0.25 
		 print @peakVar
		end 
		if(@month='Mar' or @month='Apr' or @month='May')
		begin
		 set @peakVar=0.5 
		 print @peakVar
		end
		if(@month='Jun' or @month='Jul' or @month='Aug')
		begin
		 set @peakVar=0.75 
		 print @peakVar
		end
		if(@month='Sep' or @month='Oct' or @month='Nov')
		begin
		 set @peakVar=1 
		 print @peakVar
		end
		select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa


		 select party_code,
		 initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
		 into #data from         
		 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)          
		 where margindate =@MARGINDATE   and party_code in (select party_code from #aaa)
		 
		   select * into #margin from #data where initialmargin>0
		 
		 
		 SELECT party_code, MAX(peakMargin) as peakMargin  
		into #PeckMargin FROM  
		(  
			SELECT party_code, MAX(peakMargin) as peakMargin  
			FROM #peak   
			GROUP BY party_code  
			UNION ALL  
			SELECT party_code, MAX(initialmargin) as initialmargin  
			FROM #margin   
			GROUP BY party_code  
		) as subQuery  
		GROUP BY party_code     

		  select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),         
		 ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),          
		 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */
		 initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,
		 namount=ledgeramount+(cash_coll+noncash_coll),          
		 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)    
		 into #main from         
		 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)          
		 where margindate =@MARGINDATE     and party_code in (select party_code from #aaa)
		  
		             
		 update #main set initialmargin=b.peakMargin               
		 from(                    
		 select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                
		 ) b                     
		 where #main.Party_code=b.party_code                      

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
		 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */
		 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
		 namount=ledgeramount+(cash_coll+noncash_coll),          
		 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)    
		 from         
		#main       
		 ) b     
 end 
/*********************************************/        
 else      
  begin

            
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE     and party_code in (select party_code from #aaa)          
 ) b              
 end         
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/
 balance=sum(case when drcr='D' then -VAMT
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND 
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)            
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)             
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/ 
   and CLTCODE in (select party_code from #aaa)  
     /*Added to exclude opening balance of current year*/
  /********************************************************************************/
 -- and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse
 --and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )
 /********************************************************************************/
   /********Added on 03 Apr 2018*************/
 -- and  
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')
 /********************************************/ ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)  where party_code in (select party_code from #aaa)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
  
  
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
          
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent            
 --from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
 update #NCMS_marh set c=            
 (case             
 when (imargin*(NonCashConsideration/100))+non_cash > 0             
 then 0             
 else (imargin*(NonCashConsideration/100))+non_cash             
 end)             
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                    
   
  update #NCMS_marh set imargin=imargin*2.25         
                                                                  
 update #NCMS_marh set PayoutValue =            
 case                                                
 when c >= ledgeramount  then ledgeramount        
 when c < ledgeramount then c                                                
 else 0 end          
          
 update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr           
    
 update #NCMS_marh set received=b.vamt from    
 (     
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'    and CLTCODE in (select party_code from #aaa)  
 ) b     
 where #NCMS_marh.clcode=b.cltcode     
          
 truncate table SEBI_marh            
          
 insert into SEBI_marh            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh            
          
END            
          
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet_For_FinancialYearEnd
-- --------------------------------------------------
  
  
  
CREATE Proc [dbo].[SEBI_POdet_For_FinancialYearEnd](@pcode as varchar(10) = null)              
as              
              
set nocount on              
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2              
              
IF @pcode is null              
BEGIN              
 DECLARE @MARGINDATE1 AS DATETIME            
--set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
if(select COUNT(1) from [INTRANET].cms.dbo.NCMS_PeackMargin with(nolock))=0  
begin  
  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
   where margindate =@MARGINDATE1  
   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0 group by party_code  
   order by party_code      
     
     
     declare @month varchar(10),@peakVar money  
       
     select @month=convert(char(3), GETDATE(), 0)  
  select @month  
  if(@month='Dec' or @month='Jan' or @month='Feb')  
  begin  
   set @peakVar=0.25   
   print @peakVar  
  end   
  if(@month='Mar' or @month='Apr' or @month='May')  
  begin  
   set @peakVar=0.5   
   print @peakVar  
  end  
  if(@month='Jun' or @month='Jul' or @month='Aug')  
  begin  
   set @peakVar=0.75   
   print @peakVar  
  end  
  if(@month='Sep' or @month='Oct' or @month='Nov')  
  begin  
   set @peakVar=1   
   print @peakVar  
  end  
  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
   select party_code,  
   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   into #data from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE  
     
     select * into #margin from #data where initialmargin>0  
     
     
   SELECT party_code, MAX(peakMargin) as peakMargin    
  into #PeckMargin FROM    
  (    
   SELECT party_code, MAX(peakMargin) as peakMargin    
   FROM #peak     
   GROUP BY party_code    
   UNION ALL    
   SELECT party_code, MAX(initialmargin) as initialmargin    
   FROM #margin     
   GROUP BY party_code    
  ) as subQuery    
  GROUP BY party_code       
  
    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   into #main from           
   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
   where margindate =@MARGINDATE     
      
                 
   update #main set initialmargin=b.peakMargin                 
   from(                      
   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
   ) b                       
   where #main.Party_code=b.party_code                        
  
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
   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
   namount=ledgeramount+(cash_coll+noncash_coll),            
   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
   from           
  #main         
   ) b       
 end   
/*********************************************/          
 else        
  begin  
  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE               
 ) b                
 end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/     
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null                
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
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
            
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
 update #NCMS_marh set c=              
 (case               
 when (imargin*(NonCashConsideration/100))+non_cash > 0               
 then 0               
 else (imargin*(NonCashConsideration/100))+non_cash               
 end)               
 + ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
     
  update #NCMS_marh set imargin=imargin*2.25           
                                                                    
 update #NCMS_marh set PayoutValue =      
 case                                                  
 when c >= ledgeramount  then ledgeramount          
 when c < ledgeramount then c                                                  
 else 0 end            
            
 update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #NCMS_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'      
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table SEBI_marh              
            
 insert into SEBI_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
            
END              
            
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet_new
-- --------------------------------------------------


CREATE Proc [dbo].[SEBI_POdet_new](@flag as varchar(10) = null)              
as              
              
set nocount on     
  
--truncate table SEBI_Client        
--insert into SEBI_Client  
--select distinct party_code  from MIS.sccs.dbo.sccs_clientmaster with(nolock)  
--          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                                
--          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                                
--          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                                
--          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'              
--          and exclude='N'   
            
         
--if @Flag='Daily'  
--Begin  
-- insert into SEBI_Client  
-- select  distinct party_code from [INTRANET].cms.dbo.sccs_clientmaster_provisional with(nolock) where  
-- SCCS_SettDate_Last =  DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) and exclude='N'  
--end            
  
--select * into #aaa from SEBI_Client  
  
DECLARE @Days VARCHAR(20)                            
                            
 SET @Days = (                            
   SELECT DATENAME(dw, GETDATE())                            
   )                 
--if (@Flag='Daily' and @Days = 'Tuesday')    
--Begin   
--insert into SEBI_colletral_data_hist  
--select * from SEBI_colletral_data  
--end  
          
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
select @sdtcur=sdtcur/*Sdtnxt*/ from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2              
              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [INTRANET].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0   
--     and party_code in (select party_code from #aaa)  
--   group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money  
       
--     select @month=convert(char(3), GETDATE(), 0)  
--  select @month  
--  if(@month='Dec' or @month='Jan' or @month='Feb')  
--  begin  
--   set @peakVar=0.25   
--   print @peakVar  
--  end   
--  if(@month='Mar' or @month='Apr' or @month='May')  
--  begin  
--   set @peakVar=0.5   
--   print @peakVar  
--  end  
--  if(@month='Jun' or @month='Jul' or @month='Aug')  
--  begin  
--   set @peakVar=0.75   
--   print @peakVar  
--  end  
--  if(@month='Sep' or @month='Oct' or @month='Nov')  
--  begin  
--   set @peakVar=1   
--   print @peakVar  
--  end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE   and party_code in (select party_code from #aaa)  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     and party_code in (select party_code from #aaa)  
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0) +isnull(MTMmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*  PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE   --  and party_code in (select party_code from #aaa)            
 ) b                
 --end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
  -- and CLTCODE in (select party_code from #aaa)    
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock) -- where party_code in (select party_code from #aaa)
 ) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null      
   
 --select * into #NCMS_Colleteralq from NCMS_Colleteral with(nolock)--where  party_Code in (select party_code from #aaa)  
 --create index #t on #NCMS_Colleteralq (party_code)       
   
 --exec SEBI_PO_Coll       
            
 --insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 --select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 --from #NCMS_Colleteralq a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 --update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
 /*           
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
               
 update #NCMS_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                
 where #NCMS_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco              
               
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 --from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
 --update #NCMS_marh set c=              
 --(case               
 --when (imargin*(NonCashConsideration/100))+non_cash > 0               
 --then 0               
 --else (imargin*(NonCashConsideration/100))+non_cash               
 --end)               
 --+ ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
     
  /*update #NCMS_marh set imargin=imargin*2.25    */       
                                                                    
 --update #NCMS_marh set PayoutValue =              
 --case                                                  
 --when c >= ledgeramount  then ledgeramount          
 --when c < ledgeramount then c                                                  
 --else 0 end            
            
 --update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #NCMS_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'   -- and CLTCODE in (select party_code from #aaa)    
 ) b       
 where #NCMS_marh.clcode=b.cltcode       

 /*added for unsetteledDrbills*/
    select cltcode,sum(VAMT) as UnsettledDrBill into #drbills from ACCOUNTcurbfo.dbo.ledger WITH(NOLOCK)  
  where cast(EDT as date)>cast(getdate() as date) and VTYP in ('79','15') and DRCR='D' group by cltcode

  update  a set a.UnsettledDrBill=b.UnsettledDrBill from #NCMS_marh a, (select cltcode,UnsettledDrBill from #drbills) b where a.clcode=b.CLTCODE
  /****************************/
   
            
 truncate table SEBI_marh              
            
 insert into SEBI_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,
 net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime,UnsettledDrBill)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,
 net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate(),UnsettledDrBill from #NCMS_marh              
            
              
            
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SEBI_POdet_new_06July2023
-- --------------------------------------------------


create Proc [dbo].[SEBI_POdet_new_06July2023](@flag as varchar(10) = null)              
as              
              
set nocount on     
  
--truncate table SEBI_Client        
--insert into SEBI_Client  
--select distinct party_code  from MIS.sccs.dbo.sccs_clientmaster with(nolock)  
--          /*where sccs_settDate_last>=convert(varchar(11),CONVERT(datetime,'1 jan 2011'))                                                                                
--          and sccs_settDate_last<convert(varchar(11),CONVERT(datetime,'16 jan 2011'))+' 23:59:59' */                                                
--          where sccs_settDate_last>=convert(varchar(11),getdate())                                                                                
--          and sccs_settDate_last<convert(varchar(11),getdate()+6)+' 23:59:59'              
--          and exclude='N'   
            
         
--if @Flag='Daily'  
--Begin  
-- insert into SEBI_Client  
-- select  distinct party_code from [196.1.115.132].cms.dbo.sccs_clientmaster_provisional with(nolock) where  
-- SCCS_SettDate_Last =  DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) and exclude='N'  
--end            
  
--select * into #aaa from SEBI_Client  
  
DECLARE @Days VARCHAR(20)                            
                            
 SET @Days = (                            
   SELECT DATENAME(dw, GETDATE())                            
   )                 
if (@Flag='Daily' and @Days = 'Tuesday')    
Begin   
insert into SEBI_colletral_data_hist  
select * from SEBI_colletral_data  
end  
          
            
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50              
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)              
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()              
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
  
  
/*Code added to handle Financial year end issue on 3rd April 2017*/  
/********************************************************************************/  
declare @ccsy datetime,@ccse datetime  
set @ccsy=@sdtcur  
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'  
  
--select @ccsy, @ccse  
  
select @sdtcur=sdtcur/*Sdtnxt*/ from ACCOUNTcurbfo.dbo.parameter where ldtcur        =  
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )  
/********************************************************************************/  
              
select *,convert(money,0) as c into #NCMS_marh from SEBI_marh where 1=2              
              
-- DECLARE @MARGINDATE1 AS DATETIME            
----set @MARGINDATE1=cast(CAST(getdate()-1 as date)as datetime)  
--SELECT @MARGINDATE1=MAX(MARGINDATE) FROM [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock) WHERE EXCHANGE='BSX' and SEGMENT='FUTURES'  
  
   
--if(select COUNT(1) from [196.1.115.132].cms.dbo.NCMS_PeackMargin with(nolock))=0  
--begin  
--  select party_code,sum(TDAY_MARGIN) as peakMargin into #aa  from [AngelNseCM].Msajag.dbo.Tbl_Combine_Reporting_peak_Detail with(nolock)  
--   where margindate =@MARGINDATE1  
--   and EXCHANGE='BSX' and SEGMENT='FUTURES' and TDAY_MARGIN>0   
--     and party_code in (select party_code from #aaa)  
--   group by party_code  
--   order by party_code      
     
     
--     declare @month varchar(10),@peakVar money  
       
--     select @month=convert(char(3), GETDATE(), 0)  
--  select @month  
--  if(@month='Dec' or @month='Jan' or @month='Feb')  
--  begin  
--   set @peakVar=0.25   
--   print @peakVar  
--  end   
--  if(@month='Mar' or @month='Apr' or @month='May')  
--  begin  
--   set @peakVar=0.5   
--   print @peakVar  
--  end  
--  if(@month='Jun' or @month='Jul' or @month='Aug')  
--  begin  
--   set @peakVar=0.75   
--   print @peakVar  
--  end  
--  if(@month='Sep' or @month='Oct' or @month='Nov')  
--  begin  
--   set @peakVar=1   
--   print @peakVar  
--  end  
--  select party_code,peakMargin*@peakVar as peakMargin into #peak from #aa  
  
  
--   select party_code,  
--   initialmargin = isnull(initialmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0) /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   into #data from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE   and party_code in (select party_code from #aaa)  
     
--     select * into #margin from #data where initialmargin>0  
     
     
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--  into #PeckMargin FROM    
--  (    
--   SELECT party_code, MAX(peakMargin) as peakMargin    
--   FROM #peak     
--   GROUP BY party_code    
--   UNION ALL    
--   SELECT party_code, MAX(initialmargin) as initialmargin    
--   FROM #margin     
--   GROUP BY party_code    
--  ) as subQuery    
--  GROUP BY party_code       
  
--    select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = CONVERT(MONEY, 0),MTMmargin,AddMargin,  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   into #main from           
--   BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)            
--   where margindate =@MARGINDATE     and party_code in (select party_code from #aaa)  
      
                 
--   update #main set initialmargin=b.peakMargin                 
--   from(                      
--   select  party_code,peakMargin from #PeckMargin with(nolock) where party_code is not null                  
--   ) b                       
--   where #main.Party_code=b.party_code                        
  
--   insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)            
--   select            
--   sauda_Date=convert(varchar(11),b.margindate,109)+' 23:59:59',           
--   clcode=b.party_code,           
--   imargin=-b.initialmargin,           
--   span=0,           
--   total=-b.initialmargin,            
--   mtm=0,           
--   received=0,          
--   shortage=0,           
--   net=0,           
--   ledgeramount=0,            
--   cash_coll=isnull(b.cash_coll,0),           
--   non_cash=isnull(b.noncash_coll,0),            
--   0,0,0,0,0,0          
--   from  (            
--   select margindate = left(convert(varchar,margindate,109),11),party_code, billamount = isnull(billamount,0),           
--   ledgeramount = isnull(ledgeramount,0),  cash_coll = isnull(cash_coll,0), noncash_coll=isnull(noncash_coll,0),            
--   /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0), */  
--   initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) , /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
--   namount=ledgeramount+(cash_coll+noncash_coll),            
--   FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)      
--   from           
--  #main         
--   ) b       
-- end   
--/*********************************************/          
-- else        
--  begin  
  
              
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/  
 initialmargin = isnull(initialmargin,0) +isnull(MTMmargin,0)+ isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*  PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/  
 namount=ledgeramount+(cash_coll+noncash_coll),                
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from               
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)                
 where margindate = @MARGINDATE   --  and party_code in (select party_code from #aaa)            
 ) b                
 --end           
 select cltcode,/* balance=sum(case when drcr='C' then vamt else -vamt end)  */ /*comented by neha on 17 apr 2021*/  
 balance=sum(case when drcr='D' then -VAMT  
  when drcr='C' and ( CONVERT(datetime,cdt) not BETWEEN CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '00:00' AND   
 CONVERT(DATETIME, CONVERT(DATE, CURRENT_TIMESTAMP)) + '23:59' or VTYP not in (2,8)) then isnull(VAMT,0.00) end)              
 into #bb                
 from              
 (              
 Select cltcode,vamt,drcr,VTYP,cdt from ACCOUNTcurbfo.dbo.ledger a (nolock)               
 where VDT >=@sdtcur and VDT <= convert(varchar(11),GETDATE())+' 23:59:59' /*and (VTYP<>35 and isnull(enteredby,'')<>'mtf process')*/   
  -- and CLTCODE in (select party_code from #aaa)    
     /*Added to exclude opening balance of current year*/  
  /********************************************************************************/  
  and not exists (select cltcode,vdt,vtyp from ACCOUNTcurbfo.dbo.ledger b with (nolock)   where VDT between @ccsy and @ccse  
 and a.cltcode=b.cltcode and a.vtyp=b.vtyp and vtyp=18  AND A.VNO=B.VNO      )  
 /********************************************************************************/  
   /********Added on 03 Apr 2018*************/  
 -- and    
 --(VTYP<>'18' or  VDT<>'2018-04-01 00:00:00.000')  
 /********************************************/ ) a              
 group by cltcode              
            
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0                
 from               
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock) -- where party_code in (select party_code from #aaa)
 ) b  on a.cltcode=b.party_Code ) a                
 left outer join #NCMS_marh b               
 on a.cltcode = b.clcode                 
 where b.clcode is null      
   
 select * into #NCMS_Colleteralq from NCMS_Colleteral with(nolock)--where  party_Code in (select party_code from #aaa)  
 create index #t on #NCMS_Colleteralq (party_code)       
   
 exec SEBI_PO_Coll       
            
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                  
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0                
 from #NCMS_Colleteralq a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null               
            
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode                
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from #NCMS_Colleteralq b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code                
    
    
 /*           
 update #NCMS_marh set shortage=case  when (ledgeramount+cash_coll+non_cash-total) < 0 and imargin > 0                
 then total-(ledgeramount)-(cash_coll+non_cash)  when (ledgeramount+cash_coll+non_cash-total) >= 0 and imargin > 0               
 then 0  else total-received  end               
 */        
         
 --update #NCMS_marh set shortage=(Case when imargin+ledgeramount+cash_coll+non_cash < 0 then imargin+ledgeramount+cash_coll+non_cash else 0 end)           
               
 update #NCMS_marh set OTherDr=b.Vbal from                
 (select substring(Cltcode,3,10) as Cltcode,balance as VBal from #bb where cltcode like '98%' and Balance < 0) b                
 where #NCMS_marh.clcode=b.cltcode              
            
 exec Fetch_CliUnreco              
               
 update #NCMS_marh set UNRecoCr=-b.UnRecoCr from                 
 (select cltcode,SUM(Cramt) as UnRecoCr from BO_client_deposit_recno group by cltcode) b                
 where #NCMS_marh.clcode=b.cltcode               
            
 update #NCMS_marh set NonCashConsideration=@NONCASHconsideration               
            
 --update #NCMS_marh set NonCashConsideration=b.CollateralPercent              
 --from [196.1.115.132].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code              
            
 --update #NCMS_marh set c=              
 --(case               
 --when (imargin*(NonCashConsideration/100))+non_cash > 0               
 --then 0               
 --else (imargin*(NonCashConsideration/100))+non_cash               
 --end)               
 --+ ((imargin*((100-NonCashConsideration)/100))+cash_coll+ledgeramount)                                                                      
     
  /*update #NCMS_marh set imargin=imargin*2.25    */       
                                                                    
 --update #NCMS_marh set PayoutValue =              
 --case                                                  
 --when c >= ledgeramount  then ledgeramount          
 --when c < ledgeramount then c                                                  
 --else 0 end            
            
 --update #NCMS_marh set PayoutValue=PayoutValue+UnRecoCr+OtherDr             
      
 update #NCMS_marh set received=b.vamt from      
 (       
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)       
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'   -- and CLTCODE in (select party_code from #aaa)    
 ) b       
 where #NCMS_marh.clcode=b.cltcode       
            
 truncate table SEBI_marh              
            
 insert into SEBI_marh              
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)              
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh              
            
              
            
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SP_Unpleadge_Colleteral
-- --------------------------------------------------
CREATE Proc [dbo].[SP_Unpleadge_Colleteral]      
as      
    
Begin       
   select a.* into #Newcoll from msajag.dbo.CollateralDetails a WITH (NOLOCK)     
   where exchange='BSX' and segment='FUTURES' and effdate = (select max(effdate) from msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where effDate <= getdate() and exchange='BSX' and segment='FUTURES')        
      
    
select a.*,c.[Angel scrip category] as Angel_Scrip,c.[ANGEL_VAR %] as Var_margin,CONVERT(MONEY, 0) as Value_BHC,      
CONVERT(MONEY, 0) as Value_AHC      
 into #we  from #Newcoll a join      
 [CSOKYC-6].GENERAL.DBO.TBL_NRMS_RESTRICTED_SCRIPS c with(nolock) on a.ISIN=c.[isin no]      
    
 update #we set Value_BHC=qty*cl_rate      
update #we set Value_AHC=isnull(Value_BHC,0)-(isnull(Value_BHC,0)*isnull(Var_Margin,0)/100)      
    
truncate table Unpleadge_Colleteral    
    
insert into Unpleadge_Colleteral    
select party_code,0,sum(Value_AHC) from #we group by party_code    
    
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MTF_Funding
-- --------------------------------------------------



--USP_MTF_Funding '2020-10-08 00:00:00.000'  
CREATE Proc [dbo].[USP_MTF_Funding](@FilterDate as Datetime)         
as            
            
set nocount on            
          
DECLARE @MARGINDATE AS DATETIME,@sdtcur as datetime,@NONCASHconsideration as int = 50            
SELECT @MARGINDATE=MAX(MARGINDATE) FROM BSECURFO.dbo.tbl_clientmargin  WITH (NOLOCK)   where MARGINDATE=@FilterDate    
      
select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter WITH (NOLOCK) where sdtcur <= GETDATE() and ldtcur >= GETDATE()            
--select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
--(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )


/*Code added to handle Financial year end issue on 3rd April 2017*/
/********************************************************************************/
declare @ccsy datetime,@ccse datetime
set @ccsy=@sdtcur
set @ccse=Convert(varchar(11),@sdtcur,121)+ ' 23:59:59'

--select @ccsy, @ccse


select @sdtcur=sdtcur from ACCOUNTcurbfo.dbo.parameter where ldtcur        =
(select ldtprv from ACCOUNTcurbfo.dbo.parameter where sdtcur <= GETDATE() and ldtcur >=GETDATE()          )
/********************************************************************************/
           
select *,convert(money,0) as c into #NCMS_marh from Tbl_MTF_Fund where 1=2            
        
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
 /*initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0),*/
 initialmargin = isnull(initialmargin,0)+isnull(MTMmargin,0) + isnull(AddMargin,0)+ isnull(PREMIUM_MARGIN,0), /*PREMIUM_MARGIN Added on 28 May 20202 as per sajeevan Mail by Neha Naiwar*/
 namount=ledgeramount+(cash_coll+noncash_coll),              
 FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin-AddMargin)  from             
 BSECURFO.dbo.tbl_clientmargin WITH (NOLOCK)              
 where margindate = @MARGINDATE             
 ) b              
          
 select cltcode,balance=sum(case when drcr='C' then vamt else -vamt end)             
 into #bb              
 from            
 (            
 Select cltcode,vamt,drcr from ACCOUNTcurbfo.dbo.ledger a (nolock)             
   where VDT>=@FilterDate and VDT <= @FilterDate+' 23:59:59' and VTYP=15  
 ) a            
 group by cltcode            
          
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)              
 select @MARGINDATE,a.cltcode,0,0,0,0,0,0,0,a.balance,0,0,0,0,0,0,0,0              
 from             
 (select a.Cltcode,a.balance from #bb a join (Select party_code from BSECURFO.dbo.client2 (nolock)) b  on a.cltcode=b.party_Code ) a              
 left outer join #NCMS_marh b             
 on a.cltcode = b.clcode               
 where b.clcode is null              
          
 insert into #NCMS_marh(Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr)                
 select @MARGINDATE,a.party_code,0,0,0,0,0,0,0,0,a.CashColl,a.NonCashColl,0,0,0,0,0,0              
 from NCMS_Colleteral a  WITH (NOLOCK) left outer join #NCMS_marh b on a.party_code = b.clcode where b.clcode is null             
          
 update #NCMS_marh set ledgeramount=balance from #bb b  where #NCMS_marh.clcode=b.cltcode              
 update #NCMS_marh set cash_coll=CashColl,non_Cash=NonCashColl from NCMS_Colleteral b  WITH (NOLOCK) where #NCMS_marh.clcode=b.party_Code              
          
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
 from [INTRANET].cms.dbo.NCMS_ROI b WITH (NOLOCK) where #NCMS_marh.clcode=b.party_code            
          
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
  Select cltcode,vamt from ACCOUNTcurbfo.dbo.ledger a (nolock)     
  where eDT > convert(varchar(11),GETDATE())+' 23:59:59' and VTYP=15 and DRCR='C'    
 ) b     
 where #NCMS_marh.clcode=b.cltcode     
          
 truncate table Tbl_MTF_Fund            
          
 insert into Tbl_MTF_Fund            
 (Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,UpdDatetime)            
 select Sauda_Date,Clcode,imargin,span,total,mtm,received,shortage,net,ledgeramount,cash_coll,non_cash,exposure,mtm_loss,deposit,net_exposure,UnrecoCr,OtherDr,PayoutValue,NonCashConsideration,getdate() from #NCMS_marh            
            
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
-- TABLE dbo.BO_client_deposit_recno_Bond
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_client_deposit_recno_Bond]
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
-- TABLE dbo.BO_client_deposit_recno_GSec
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_client_deposit_recno_GSec]
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
-- TABLE dbo.Bond_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[Bond_marh]
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
-- TABLE dbo.GSEc_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[GSEc_marh]
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
-- TABLE dbo.SEBI_Client
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_Client]
(
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SEBI_colletral_data
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_colletral_data]
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
    [Qty] NUMERIC(18, 6) NULL,
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
-- TABLE dbo.SEBI_colletral_data_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_colletral_data_hist]
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
    [Qty] NUMERIC(18, 6) NULL,
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
-- TABLE dbo.SEBI_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[SEBI_marh]
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
    [UpdDatetime] DATETIME NULL,
    [UnsettledDrBill] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_MTF_Fund
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_MTF_Fund]
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
-- TABLE dbo.Unpleadge_Colleteral
-- --------------------------------------------------
CREATE TABLE [dbo].[Unpleadge_Colleteral]
(
    [party_Code] VARCHAR(10) NULL,
    [CashColl] MONEY NULL,
    [NonCashColl] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Unpleadge_marh
-- --------------------------------------------------
CREATE TABLE [dbo].[Unpleadge_marh]
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
   where exchange='BSX' and segment='FUTURES' and effdate = (select max(effdate) from angelnsecm.msajag.dbo.CollateralDetails WITH (NOLOCK)       
   where effDate <= getdate() --and exchange='BSX' and segment='FUTURES'
   )        
 ) x group by party_code

GO

